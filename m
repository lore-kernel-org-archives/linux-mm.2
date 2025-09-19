Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F68CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A27A8E0145; Fri, 19 Sep 2025 06:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453618E006B; Fri, 19 Sep 2025 06:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3D48E0145; Fri, 19 Sep 2025 06:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 192648E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:29:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A1BD140623
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:29:27 +0000 (UTC)
X-FDA: 83905627974.28.B827F94
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf18.hostedemail.com (Postfix) with ESMTP id 216541C000D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:29:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZRxhIyNr;
	spf=pass (imf18.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
	b=nE9nJz6464MLEwTsLUkjqqtfTlmhHpnJghYITYQSDjTa6fWvPWUbuYHhjG5FJJLr6C1ZEw
	ahSz6SIbspWSVDpdi1pOkzPvMArpwWtLhFxfZK80XuuRrIGlNNADDN5hGfojCU+IqRk9Nh
	mkGRtE4PfnLnjZpv+E+QETxFbgyjROA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZRxhIyNr;
	spf=pass (imf18.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277765; a=rsa-sha256;
	cv=none;
	b=hgQfnkZxFRAPcYLZ99d7Ppc0j/Z8yRw7RsEhvb04RH45CKhls5JQgbkYFJ5zwnbO3+0SNo
	fiHv0KWzBZebypR/veZfEFLwqTnCzDkkI404fsQJplXEbOfTAaD+0TGbn7fV0EMIPxj1aJ
	sQtK+BcG08CJZ3kovk1b9cWX6fPHjW4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277765; x=1789813765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
  b=ZRxhIyNrTgE3UwxFm4MWcNN6xTWCnff0tYOM+nqsi47GUpAKShctNg3Z
   HW1IZgDOaT2C4Q5Z+IyhXIulDTivMkOnU3pktbU68gAtgtsbQo3FxScUG
   y3yVAv1k3Y8m/yxP7m+QFwdYTrsd2tDJOG8qzUPgnzaUtAsXTIYEVeCNL
   EKvnGO54miwh7KVxsq3uM99mEX0h62YWdg8pR+edvlsMkjY2UZy3tIihN
   bVUb51bQ7yIAWvwphDrZKe0KB+vFHAY5HAzT1mhC/aOPyTzHDYNDZzl1Q
   spC5wrEXiDGMmYVHty85184sQ+juZEkuvnxP/rP5CbT1eGdlh2S9xVnLl
   w==;
X-CSE-ConnectionGUID: EpzcXZ6/TMyS8nYRHV2y6Q==
X-CSE-MsgGUID: olkm3Y/7RxeC17uHACN6Yw==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2368849"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:29:23 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:2551]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.197:2525] with esmtp (Farcaster)
 id 95e6de20-998f-4308-bcf7-eefa3272a8ca; Fri, 19 Sep 2025 10:29:23 +0000 (UTC)
X-Farcaster-Flow-ID: 95e6de20-998f-4308-bcf7-eefa3272a8ca
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:29:22 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:28:54 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>,
	<james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>,
	<dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
	<joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>,
	<hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <bvanassche@acm.org>,
	<keescook@chromium.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<stable@vger.kernel.org>
CC: <jonnyc@amazon.com>, Linus Torvalds <torvalds@linux-foundation.org>,
	"David Laight" <David.Laight@aculab.com>, Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH 20/27 5.10.y] minmax: fix up min3() and max3() too
Date: Fri, 19 Sep 2025 10:17:20 +0000
Message-ID: <20250919101727.16152-21-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 216541C000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7myzk3u9j9zugamqq6au6tonpkeaze5x
X-HE-Tag: 1758277764-4276
X-HE-Meta: U2FsdGVkX1/1fxIKrSCROKCw/UGsbHuBb0LPan23Hdgf00xaf0OTGkxs6gWAcnU9sgUUaRR7LCajbXrvbseoUjcp0i7ZVutoUanh4WWUDCjPCK2i0CFDyy1AmbBC78K82N2QqNr+ZYW1DsK8JXPQvPV+HPOBVx5IG2sB7beGeuuzrZIXJlwU6xMrKozNrUh3pZh5FyCNAJwcQ8gM42q2HkVRKqRciHQQWuBGjDwJ9g6NH4f8Mxc1Nu8RfmVz0jio5tXox9ByAaW7jq0ipRN5JxpmSGQWlS6kH+uB9OgzZUL7KAYJYd4eWFgjvqo31p72HEBPvSyhqvZu+TGO2YaUPN7vKLs1yGR2pdGlyTlR+2YoZe3rrkBb7xb77QykCTR2q9qSGGnlaxtrFo63OvJky0t/XS9lhpZHbO4ulo48vsHu7DaF991EcuBlwQnouTzIzViMhAto3iDiqnzPAigeGD/hunPpo/AZ0n9xsEpp99npzgs4LU2kiJG7GQNyxRuMBgFgp7dIuwNSN0abX5+HddSYXCckrE8Hgkypv05bDxLcxiS/Ya/QtehQn81UT5MRMyJt3I4OPuLKWspxeAs4KLke8zYYAO10DuZt3LA6eeuYTQsexoBqqclhodKUxiRV/pqDUL5nSNPLe/Ik+mixLQlxoK5N2nHrQydOkBpLICW457QXwlwWs12kzrU5Tgiy8DiPjsJYFtz13WwQ22FF6GToUsXSQ5rEQr7oJTeqm9UkRAu49uFQLAzDK/0qHpNfYvrTYsQMDEq/VNe6HyIDMzqGBgqxMMl+IjJBW3aq2ofdfKmABIpdpkrE+bBiAkywcFATk4BsQdSmCqjcpmFVrVy9qhTKDXgBYZEOwJOzi42V2YMRHfwlfqn9hTna3b3w++9XG2CFGjP8dFdIVhfykakEeJmuTBa2QhiTprIEnBW8D/DzzDZ8yIPZLQxHkA+1xf7EyJm4NWsUdOiuzvz
 PXWbs1S5
 59Urw3mxbmbA+BRQiXhsMNrS6ok9485C0yHAcXzcg32PTc61aaOrm+zTeblQZU214BI5VRSxhKFKQh3f26spvBNPSGqcxmK5C5byUlRQyhNUcIvwhOLsrjWJbV7ng9bnaXHs82VY2dJLOhrCNrzcD7IXeU+asK/7lwIgzhZp8yXR2WylzdPwOx+dzi6NmOO7SaWjSpj4VZh5jnbn7I9iqpb9i71gBOa5g7Cxc7WTYOfajf/2zrWWheltqIuum1iVo8EIx9BUKkcJY5gKPE7OboLucBb+NDAMTNsXWuxSqfCsNroaLHZU7hxnQQlQ1QiFPYs79ZsiiO5OkoxVIP4KFm6Kw6slfS791qd7OhHlKosVB4tj1R/QAL4TNp22jWBLha7Gmq2XAMPoNZJSQBMA9Je/Z7fgOjWubKUCE07iCrPQLvcT0c0X+8PtzT6ZIqT0qQWVX9ZR3gEFaDU2DmIvczRXoYwccBzsgJq2U6BA89Jk/s017Lz8w/eHImG4VC7gwG+c8Nx584x8ugGfjN+bKrgO0bDrwDGEUEMrRxIEcrIaiLSI3HagqwA8NZMXinfudW0e3zXlXepp4/G5ieb/w1PbtUpcThesZ5AgUhyFddMc5T4CXt7wxXM3ZNeFxhgFuzLgvK3Bz+vTueFBhOnDPYjMGsyosEexmfHfQQefEkzqIWbBxavHvDigWu1Z1KbVehHxVr3G1bRrXOwjDqG/MnxMb/zdizknaJgZd8JQWMcAeNtBT7yEbsQEDm3wqR7jizU/nvIEj+zjN7znMy6fT1Vov7G2XLa6rD3LtltjyzwGC1jjzJoe9i3If6Uu6hzkLz90EYsGmTKa2xUlGJ1Bs7WTAimG8cw/CwfViY4tChaW2SD/o31jtRasgl56a8RRUOBNG5IFjUhhsCSbDHkyMMOheioyEPzw7HCw2xTVsoTbBaIbOu8C+QQMa7GTMyfuJX6spXGtVI+Is584gTFkfGiQcxw2u
 61RBuKYN
 cXDyc4eHYL/Q5EZCMU69BV57pcncJOUteZzWXHwLMmy2HLuOVKLYy4xIDY3ELo6EumMsJCgJE2IEJjb7XON/tQleUqSyVL4csHAfaZuPgEH8tYzUrMY9mcDPq3fYnoU3CM+ZalB68KE+NTKDW/vV49YBKVYDcysxTqPAxK4bEh5z4omCm4dxg54lUMyzymPRSWYCr5m91eUgN+ccrEpNUB1Tu1HSHKxnlFLK16g6V+8ReyWjgiqctQSa3uGkISZ8ZVWLls5+NBtfO99LBvRbT1P2EXJT1MlyHRr7F1d0LUNnUH+ISHKNoYsXcDUAS3++xJUkKd1hVoDRIsD1Y8arhC9ZrU5FbL6Z1KTmqX/DblSgA2rd2/yhbbEqqKwTrTYQXREsriC1RnnANyU5X72mFnvrSg82sK9AJXbKEFpsSSJV+5d1wDQcX7Gq/L+kDaLjeJvx2063JmIhPOXCvaKYPGrwkACePIAWI2PebCmouSH2Q8RJ2uEH2HiQ3DbVMc8bTiTSNqWQmciNdnjYkxZw/G/gpwa9iJ9UYzkIx0oZHxmQ3rbmNDzlJul+kOLIv5zPzlITX9bqpvQAUPm1fy91uUgcxGOiDrtIpRhU+JQ/5kct3PadJajLlVNRB7SpmY/6Jgjk/9PcnB0cwQiE978iEnq7mpJUHMAALRyUOuRjU4Jk1Yj75AS7Vo8oEqHwXvGbmT2mTAePWnQJRddsV0h9dU0AcJeCzn+Kilq2W/YCENmY5fuC0jNi/TTtBMbdFKurychnGVtsj/a4n8B5Uhyu3ceUan3F/8zUTKScFS2UKRS4pW+3NX6+rajlrxvp9MANDCsRu4TmaK7QgSqQW/RiRB1E5QdLyS3XUTLeAgih0E4L/rMb/cTRM/ZklM4zGR5AWG/YHBH9GD1/eid7nw2RioqgzdRpwhajTayyC2gGWORMlT8twi5lwzzK1rwGOBo1d5Cs2nSdmYltMfiDqXOmJbO0od8g7
 bXTDD4LE
 C+lKg4zeqcwJging3Lr4ICeLpytA9IUhE+Clpxm/fqDr+cM0CWY/Z64aKbKvCERMNPXv11bGgwqKqueAGBBL3uOAUMdehcGtQ+wFOr+CiKYukiKICKLnkW3OvHn1u6DjEEVvcLkzivoTxDq/+b0JbYWqEBBnbWWMz+/3uPEhISrbgwyiwJCUSY9H0FfeAmOsIFi+gutKg27EtInc9YY4OiftCdxnfiYuA+NGE/coe2CMoUAAtl92Ow2An97UlDRZjry/Fv/UwLXGFpGnLrAB8DEvgZYaCRSWK2Kr9r8Z9f9K/S1Fe0/5XVieDMl4H/tyyQXats0SsBzNGNF2ZwPrGJlO3ZqNRuLhBlaVxnXarNEe4ESaYyExZANILFZnRp4SCBDMXOW95YS9/aORYKqgZq1nKdTlFM/M1TMpenVdC5E9SRDuKC+BVtlj0lBcgnucdhU5dNElKv7aozLJR+4MBggudaeVNhO7A75EGp7t4Bl5utHtHnxBJscn32FVp9b6j5rJqwWdfwQ8/toTcsblUo7OVIJHbeEbWUvOjXAyQOVXMwdYxCCpfC/EN2ZL6TCGci1nlL/5NxdCAcM6KirvM0NqR1luxE1hDmJmohFrVnjOCbjREFHsvhJwBux0RAPZ7chiJJaFLSHLEQTWtv/vdg/NYeu2YBD7imoWP+G+lRv1Ew9givGYMvC6PeLQVmuERy2Oh6rrI8uYkoIxT/BEQFp1YbhONAUKIYYX5Cr58n9MrQq9GBAOwuu2aip92fG3SCdmPFqC84hWkApDKfk2KKP9oMinh7kC5B1hteWunyjXfH+2wuieqt1ueDqF6xTHQh8lw3RHGVOI1xT9QRQZq0twITaLQ5B0T6zwVN0oU8gEUjz+n/+3wG5SEfJsJo4vZbLkhEdykZ9iWVaovDbzXROkKAPJ3KTkiYH1oPeCZcEwMlX7+LTHRQL4SOi9qO7i5m4G+poJdrZuRoT1nBuCarrueHdYC
 R26cbi7f
 EwJvD5WCSEib0DlW0qDT1QVFX5zYCGf17QlfawhFCowcdNQXMYJfj8zub/GnvuHo2f3HnVrLyRIAOJbeFldlaGYCza6TXlrfbmmSAohiQI1CgSR37YkO+0sfULQBPbe75CNEAXpfXlPhTbEkkkFwqFGo/pq7xOdnZQ3Kk6eFiSuGVGcwwqqZ08ZM1H4gC7lT2bT7lGbip/eo/Oe1XWG5lAbc4VbEDWMfN58eaNbT6g0S9KvS4R3xMgcQkx1Df3fGoFBL2M1w1ZBlqAbBzme/Z5ovSR3ar5inMxaZ8qZWakD/D5/YHwnjln03fim6eewYS3HahseQ6zP5+5bcasBsIGaeEeuBH8sknD3kv2x+qMrmUGmdo+nanlpFR36YNLz72BbK9lNv5ysJvJNgwAJvEABMc6D6iiXeVt7hIfm+UoobE025Rn/nzhrkRTD8IA8WvaweTQC5K1yNfVpO+ODD5IekHZo0mo5gPobxUarc/KptBtsi7mbdUvYaxseSnf1xCdyOSLIGBCAFjZW977JHOojl0bCx1O8bX+/f5HAwH6t19MMWla00LRUlcUjaO35y1/AKIdXqDoxxf4wtGr+R/Ac9sDzGXtlivGsNolyuf9US5UaFqfOGHijLRgwDNhap19jPrv7vcqEZYsQ3LBJiSdDT/jv5wL2fIgrrImmW9NbbpZj2JrscZCRgNVeZgFSYHS3JP5kFJQS7PMexRRCWMhHEBhIVp/yPqMjwr0ogLDK+Y9bieUjejX5009bI1bC4JQbnSy9F0XvyJ+0OXN1JRmKkEGZ3SAODZsVTNQXQg4HV5UXqW38pqDgxppRJjgxzV/OdJeojE9pXcJm2m19xXKXB0EDUC9ZcByoHcRmyiKRGlaLe+femdQLIqw7tC+AfklnhbTak23ESHWmRSw7SfsH3/w4SkA2ODchwHaV0xBN/LpsyPv+AIhwysIdfLWGIyypDBivRXW8vcH0LLWlElctlPxXI/
 bTNncVf0
 MthP937p+rBwovdGbj3YFMRutg7d+o7UH15pL1xwStADJag3KUNxyDzxPdcaRiywYgfEI8pyv0Dr6/aSENcj/X0yptE/lyupN+LCnp2lWDLZTYYdPMDvk63NjJ0WRdcd5mTY21nG7CQrfyPo9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 21b136cc63d2a9ddd60d4699552b69c214b32964 ]

David Laight pointed out that we should deal with the min3() and max3()
mess too, which still does excessive expansion.

And our current macros are actually rather broken.

In particular, the macros did this:

  #define min3(x, y, z) min((typeof(x))min(x, y), z)
  #define max3(x, y, z) max((typeof(x))max(x, y), z)

and that not only is a nested expansion of possibly very complex
arguments with all that involves, the typing with that "typeof()" cast
is completely wrong.

For example, imagine what happens in max3() if 'x' happens to be a
'unsigned char', but 'y' and 'z' are 'unsigned long'.  The types are
compatible, and there's no warning - but the result is just random
garbage.

No, I don't think we've ever hit that issue in practice, but since we
now have sane infrastructure for doing this right, let's just use it.
It fixes any excessive expansion, and also avoids these kinds of broken
type issues.

Requested-by: David Laight <David.Laight@aculab.com>
Acked-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 41da6f85a407..98008dd92153 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -152,13 +152,20 @@
 #define umax(x, y)	\
 	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
+#define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
+	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
+	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+		#op"3("#x", "#y", "#z") signedness error");		\
+	__cmp(op, ux, __cmp(op, uy, uz)); })
+
 /**
  * min3 - return minimum of three values
  * @x: first value
  * @y: second value
  * @z: third value
  */
-#define min3(x, y, z) min((typeof(x))min(x, y), z)
+#define min3(x, y, z) \
+	__careful_op3(min, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * max3 - return maximum of three values
@@ -166,7 +173,8 @@
  * @y: second value
  * @z: third value
  */
-#define max3(x, y, z) max((typeof(x))max(x, y), z)
+#define max3(x, y, z) \
+	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
-- 
2.47.3


