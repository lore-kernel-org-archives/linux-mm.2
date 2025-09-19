Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FAACAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED8C8E012A; Fri, 19 Sep 2025 06:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75978E006B; Fri, 19 Sep 2025 06:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16818E012A; Fri, 19 Sep 2025 06:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 883AC8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:25:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39548BA7AC
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:25:36 +0000 (UTC)
X-FDA: 83905618272.15.B62D09D
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf14.hostedemail.com (Postfix) with ESMTP id E4849100002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:25:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MweV+9Zf;
	spf=pass (imf14.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKrzZxxwAGrrsDAYTdb2CFyqRRiBdvlMoDbZLm/oNpo=;
	b=b3CGDZ+57HzxdS/jSJ5cVYuRGGyofbkRoEF3FDnukTqRmVI2RXz5IwolisEcVXKpXXXhff
	JDEepO6o1yKATiFl9Wm2M1znpR5XRDyrmq1cOKv0Z5VQaL/V37NAQpW5fQlc7mIbKlH8IF
	aHhweufZq+ubFetJcRQN+skLn2kkTM4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277534; a=rsa-sha256;
	cv=none;
	b=5QX+hYHG/8Dci3TKbjLFT1vqAUEKL03tAEvh/JCANNbdAW5ZFnRXI117ScS9eXH202HB1M
	E7/Rx5hjoizUlqKnEiOy0Ljwg29aX+cLiVlRw1GAMTvr8m0DxzTKi/YVvamI6qS6rpNz5F
	pZryi0xBdoqXLIDDJb/7MeKlm/Z7fl0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MweV+9Zf;
	spf=pass (imf14.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277534; x=1789813534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JKrzZxxwAGrrsDAYTdb2CFyqRRiBdvlMoDbZLm/oNpo=;
  b=MweV+9ZfU01ZtTpQdgwIFJQV262P2fbFbMISLOD9v/l5o7ENt+MtkBEu
   YhNelQxvg7UotNSh9vweabDuRnt9ivezdJSueL7rrd3GBAgZ7FSRINr21
   c/tdqc2o8modrpgS39q7UkWkFp/jvdMLolQCn6xGRFJ8JUzFWIyxdR1x7
   M5iousziF6rBixl928YBWT87BPI15kEDy6KlKbCuwtMlHMT27XjjArlRR
   yEtjWGCFax/mJQeJPk8ic968K9wRJBB89e1a1HUefaI2zEEhnfiBOzDjj
   8RC8HNsLndBZRFS0GfZ4VTS+z0eCVhO/8c++pE2fy8M/Ag1y0Z9YCHg3R
   g==;
X-CSE-ConnectionGUID: /KJzP37LQf6k38ZLxFASQg==
X-CSE-MsgGUID: 3wkYSDRFQsGnu3n2SgcG1A==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2369417"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:25:32 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:26532]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.0.240:2525] with esmtp (Farcaster)
 id 70cb6f1b-6138-4159-8845-ca7822e18c61; Fri, 19 Sep 2025 10:25:32 +0000 (UTC)
X-Farcaster-Flow-ID: 70cb6f1b-6138-4159-8845-ca7822e18c61
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:25:30 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:25:01 +0000
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
	"David Laight" <David.Laight@aculab.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
Subject: [PATCH 13/27 5.10.y] minmax: add a few more MIN_T/MAX_T users
Date: Fri, 19 Sep 2025 10:17:13 +0000
Message-ID: <20250919101727.16152-14-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: a5s97bj4w9imheu1g6nqwuzkc7pmcwr7
X-Rspam-User: 
X-Rspamd-Queue-Id: E4849100002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758277533-154254
X-HE-Meta: U2FsdGVkX1/npOalfo/tKcgTR0dtQBlAtiASXlCu7ghmM09NuNP1irqlRyk2nPwZNXaZM1Y8vVXwpORQNrw+f2lKt8yzRDet4Fngu2GCgRcBrWFgdsyc0XXCr87SuOgkizL9UgP6rBePWFfID1XLmMBfd4rICmPar1bYYIE11dq6CRmSsDoZlNz3oXHH1wHzUzhZyiXnvCIlWjFyt0ZHEvbqVaxwYpws+4rvJu226zxt2guyvuPAVg8BAvtrUvvBznA+0Co4FgTngddp2MzbXOkGmrxxFiOpjcl0bs9howL+xbq+uPDp9tZpnGP9IIO2RlTt2N2KMtsgr9vURUElhs6O1Y/SoEi+LztU1rkDE/Oh6/x0unfoM9YapwN9YokU6xjuakNvFI2RWfBcNro4yo8jNkFR1tm59/mPNMwNRt2/THw5vfLn2EMEueew90dRw+Fs262zCcIs7NA5/S7qSyRZ2ul+yU8G5HM5wgr4K51CB8S14V5w2y4HKjLs3pxAA3pulUHzFrCGZIT9Dl92IPqvbbYtji4e4ZjgXZZe8NWAU1aCF8p0uFFghWwQHXlVt1CvPK/ZY9CtmJXAOZ3USxESYHFjMPVr51hNbf896Gg+Myzw+JPhXvX7/yqAq+tpCx3FcdMZ3oifwo1ev3gzo1ZP+nMboH2M6FS25OIvjJIF6Di57UmCF/xT9nZcUKMilEC9rBhevoaOwd50zzRYv7HXZTy70atFzGXQ0rRx0xgIHkjbm17qUQkW5zrjgxihiKXSxpTveXZBTwp3rAA0tT+p91grFARHy70QqjeLm72hdQ2VWy3rKrCz348SlRdYqi79vxNB3kKi+n/THt/Sn4TUPpsf/y6N2Vs4V5C8Qp5mUhYPvvOlJQllfsKKMnoKfJRatcSP4MCBEgIMW18Zq81cDm0+Xuy68tQXykYPRYqjglSDx5lcGbxevW4WVCq6zL5ud8aFTpLaIopiAB2
 nIpD5e+O
 waTqaTwHIm1wmaz6HgEfpAPYdcAHo34LTquDt4rnIjwrgDaNcr90qcEJ9LNgg6D3IhDrrj5sPEv5BUhwd58PUJMOUukvXh5aWJ9nGmCBheIezeFs78vxnPORw3sTlVkd8TqUd3aoiBxTYgqV6QiP1plplxmvewJqKmLzuNSI+wa7MJPR0JcOdmOvJd96CoFyPl5LUkTCK41RW8Y0XdD5UOxBerDn0SwNhPY9MnsAAcgu9Dx0azPoq6axinJHRD0sfUigDE/OZQFhwRM0A2en2CZio0zNso9pZqCPoMJf40XE6NGBliWyAd0+VkDanqbvAutsM4+4iwHrcohAXq//ixVKxig3hCUjfgibfNHrpw1Wgr6do7TrLPqnKWNchlKN5hz3s2lAt4J+7oPf8Y2+voxhqk5cOZ7BinfEVQORvmT6khAKgGdCOXUPBOqKoVgu7a1eMNlmSVLmW2d0LeA33ty1+drdScx8aIDBF3hSLrYEKcqCg/GDEo4WC6psqG8RRoTyYdywUFf3ERHr4+OjZNkD/DdMfL3oAfR1uraPuqQFOLhqtkR/+PVAq2J7vsM+afInQBILTcUkCVO8R3m4LGYC7e0sINkLPvdCFcqChjr2eD4RqFuYihbUNPwW2xD16UvEiMLiY11in5rwtJhEd+bezDIzYIMdkTCqetL3T8q6NcKMLrFsXIE4Nd5fgrlA5vW32IsNy5ewgnxAq4XTokkZ0C3UTa72WTVKtwWLIz/NYLHDZuXizsPmtbY000wu6Gw95eAzif7KHt/o+RdJ4dDJzVyeAxAhd35zG7A01e5OdPMvlmcW8Ht+U028c5eiz96FuthC+/SLBhbRrrEosy5QaGNECeRNH8jHz0BOskATJspV+cExgdifo/pg03XmHZFSl+jMEeDKPD0Kgkf0dgYtWppRKFDCJ/3hfweD1TwSRMzt/IfgZtRsrCtzUjqPo1RAdTmCKZy1BHUTjwv3tlon0czAQ
 CNxV0CKC
 2tdPefeBY4Nz6nzHH1LXrAyNGh2oCwQoakY8ZdzMIOx/geulMqq5gutyWXysvhk6gmR0RXNJLnKvSigUKs/KlyNdrn4rsXQrmMwtfDk2X2Khor0wsmlMcdq+tZiEPV1L2ZFHyttq7pDKtPAEXTO88FHyIODP1prBUpw+Er1T4iRVKGTQc07h8w6dgGrjE9H0e44OtvNALScWPOWRx230TZJidputJagoa3LXLdZJDEHY3Uml5Z4K63CTaKt19L94GZu9n0o4JwxRPW6kKxuRsUcZfLPLmcpfYEf7Tnfqk0wR87pH5INMSspBCCD7mhHrq+dIkuOF/ZSDXjKIldhW2qOUFm11tz4ABPjPvdJUa0IxOXR3Sabj+8uVLPrR8/4JYTq7DH3EtI9+2aS8sizDgkbL7rlc94ljvsyyDixGfOGJPWiHWe/UOo50qDPwsOR6Yqv2d4pMcYZVlbEOjE81ZUVDbz1GdIdnY+YD6GObtW1hd5PEWZr88gfmJ1GI8lj4xhGwOyu6+edrCli9HMFhHfylbxNLrvccqwklBGNhVVVad1r5jPSWF5giV+W9p/9j0Xx9KPRiDm6Z1OZfydO/8D7fR5XDcasBZClcU5KannL9wF+jb7XUvCuKsZhh4y/i0L8XONQPn9KjiDLhJgq9AGuDDpPsDi5kBXDEesbZInVVUFW3EYkViUew+2r0hG8V6FStvTG1hEeI0hZVs9PCHAGiJQkSYyIIw8mOBwDXnW08f3yRcxY6iQtznmryxsvl6RiRUzFd7KQ6mg44k1IOpfb+m/ChiZ8rxUNcdy7Ewwi/Jt5wpqWkT96fbflYo0CkWkGSdUSpyjIxS4n4wDxBEjqk+/91+Uy+p5VJyJA6/+CfRClrQUX6wPycrNdEiIAuu7i3Vz8fbt6yjbychAn5EyKW8GhwC+E8pebX9Ywc+rtp3dhwBh2SLNsEL72JaviHhlvnNY4ucBA7L579iPK3FyUIHF+Ln
 D5EjBAi1
 hCvBOrPsdK8VAznEodI4iMZjwBoAQofvphD2duEobmyNZw93Wd11SmOftc7Uw2o9j7dznH90+eyEz5bczjl7tdW/A/e8M/aR4Rv3TqoAqEFXIIuBKhQ/jaCyElKrMHns0Canao4iSS3H9g9frsIzwqBDSS58LFfyepCwgHPDyIkG74sIOWBoaoNNIEXGJIuup6wMyAsr8Dpv4aOQMnWreQeVcpcpoZgV06pIBV8AvU8NeoeG2c+O7RYR2Fk2qBgR0MCtTjlrRkhk04uCD2f7RXK3NjZI8kB/YEqlJHvetzPECXg8emNcwA6Ix0OH3KV4voPt6GNyIsAFJNqTq2S+gm32SLfBYqNAQVFZFqV9TsvZU2/LKMMPj6rcU4Ir+RXNxNcIlL+LVPv1ReCT4F2MA+UE0G4I35kqc1oI9XCRHus52JtbYkxPb9xpIzrZ7nw72NaZZh66V31DArJ+wvzl6Apr7v2oj2dH6UHf3U/7xpABn24CspgQvaRUeAwyICM28rBDvhlWLNdcWd8vYREyQDBxAU23p+PfFqjzt9keUZL4mNxEANYFxz3TAZUiTEg2+qaFEyy5USrbevXX1N+9Spy4M/L5AFdcJBKrTHmkFKjVr9IidDoJUUpxXES741jaTGy+flhVjQmeKV8QG1bWgDk9HiFzALi7DNAcbWoDDWR3X/qK6YDUXlUB8i2iwdHBGs0m9CGazuuXtPDAg2nYpwCd612bxWFOsu1fL4KHlzdiiyN6uy/zEUu0ISGsp0obzf3uSfpn5nifxVH0IbepnKPBctCaq4UU+Sdk0NhQzjffhrtf8afuOak1xixomldOUlky+GPykU9lcMf+7SZ4B6zZsFu+wbUzrdVgRuTn+/d04TI7snJd7Qw68fskyNddzXgW97oIm2c65XcSNMIgINsnZ8QPsMJQx0grw5FUbS0QmSRpZikqqUv3um6rMqSsIf+ZiBn3+WkvLIurB8fzYC6lg57S+
 I5ArfnvY
 upZdHy4pANPQcYA5aTmIFdncy7YYkCoPKeV/Djlm1l5oGDyhIHjClY9v1dqCNsOMzPQcAp8hV0x4JM/gchF7aFxAsR0PC7hTHHCdnXQ+LXbrHda1hlxbT5tFroL3UB9AlL4Ei/OzvT3hbaTaZtimuDGAHNzXVr1J94V5knUErh6nC/YhZmco6e19WuWeMpcTKTKGJdUDNVsXkvKpiGaVhduVayB/VdM5yaTSsOXzdS1+0ewm7hXgXlXQTlfGe56nrkyHiy8ejaquhrB8uURoggfXgXBNuXE19dg33VfySuhG3S0Q5D7l/Kym+VCzvAqs8LQBoqGTidLIbkEzuYnDj9dtDDJuh6BLCVbrGnor62/2LYfWAJhlgROi1QGTOAXWp587tD07hWpYevudtoNEn86RXjr5eMtTDIufkf6K4lr4VXxaw5ixU5MKqMMyPN1VZEaTe8AnGKZlu4wajHIllmYRj4Wn1aM1nN02c2rhcBYuGo4Xc0XiAHaPk4Gzu1BiYhAnFbQ0DkFEG8a7PFO2cjq+MsWFSbR3+KNwFvl2G/LsuxZB3odi0n2RdQRXtPlAqJqzSQdWCnOz+XGRecq3dOOKgeuYZp9LjwM2Clzwwv1tbK8FHe4AUi0GbF9AZH1s8Ed6XMU/4utT6QaWue06BXhsnAXbwUWOKG/s2fOUeo7i+AWo6xOLCTwL65JE/vGEukImWRSSanouPpyZEkNzGwTeT0XRbXCPM0cS2dxfzxoepMU9f28kOyzJPQBgzu7jCXwwQv1mWbuRdZ2S4F61+HHb+DB00hlRmmcIeU9SRz0ywrLeNd6aNXvu0EhzmELpjNetysOQ0TojAXij8LS/VQ8xUQOhMb9Mm5H9OT+9jnsDW9zee4rde7nZRxk2a9KQvapqU4CPaWW+Sqwav5sYW1WDVmLnwHQ2/1+VbA9rfHBY1LRl8vPRU0Ny6/0HGe4RCol4eQO1qTaPoedQp9ozj3RGG8466
 ecHgWPtY
 xzs8I2QOVdbnOsWFV8GUy0oHTZPtz5Cq3ghLKupJfQcIspfkWA70QdYnMU6ow2OBM0rrDnoW/p+5VNnlcPRV297+Q2qJ7NQshvmC5F9Gf5M1gHmQ4FnPBEP3Mr9u8pAaPs967SpsxfFy5lGhGk4wBpRwRZw1slF3lfkX+i8okm3NBtIDd0U8V7/SxpKks02l2gs8ts+wbO7fOj36Y549qQNyrnUk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4477b39c32fdc03363affef4b11d48391e6dc9ff ]

Commit 3a7e02c040b1 ("minmax: avoid overly complicated constant
expressions in VM code") added the simpler MIN_T/MAX_T macros in order
to avoid some excessive expansion from the rather complicated regular
min/max macros.

The complexity of those macros stems from two issues:

 (a) trying to use them in situations that require a C constant
     expression (in static initializers and for array sizes)

 (b) the type sanity checking

and MIN_T/MAX_T avoids both of these issues.

Now, in the whole (long) discussion about all this, it was pointed out
that the whole type sanity checking is entirely unnecessary for
min_t/max_t which get a fixed type that the comparison is done in.

But that still leaves min_t/max_t unnecessarily complicated due to
worries about the C constant expression case.

However, it turns out that there really aren't very many cases that use
min_t/max_t for this, and we can just force-convert those.

This does exactly that.

Which in turn will then allow for much simpler implementations of
min_t()/max_t().  All the usual "macros in all upper case will evaluate
the arguments multiple times" rules apply.

We should do all the same things for the regular min/max() vs MIN/MAX()
cases, but that has the added complexity of various drivers defining
their own local versions of MIN/MAX, so that needs another level of
fixes first.

Link: https://lore.kernel.org/all/b47fad1d0cf8449886ad148f8c013dae@AcuMS.aculab.com/
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/x86/mm/pgtable.c                             | 2 +-
 drivers/edac/sb_edac.c                            | 4 ++--
 drivers/gpu/drm/drm_color_mgmt.c                  | 2 +-
 drivers/md/dm-integrity.c                         | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 net/ipv4/proc.c                                   | 2 +-
 net/ipv6/proc.c                                   | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 204b25ee26f0..27e8e3d6be48 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -107,7 +107,7 @@ static inline void pgd_list_del(pgd_t *pgd)
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 #define MAX_UNSHARED_PTRS_PER_PGD			\
-	max_t(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
+	MAX_T(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
 
 
 static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 1522d4aa2ca6..714020e7405a 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -109,8 +109,8 @@ static const u32 knl_interleave_list[] = {
 	0x104, 0x10c, 0x114, 0x11c,   /* 20-23 */
 };
 #define MAX_INTERLEAVE							\
-	(max_t(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
-	       max_t(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
+	(MAX_T(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
+	       MAX_T(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
 		     ARRAY_SIZE(knl_interleave_list))))
 
 struct interleave_pkg {
diff --git a/drivers/gpu/drm/drm_color_mgmt.c b/drivers/gpu/drm/drm_color_mgmt.c
index 138ff34b31db..4bc671484c05 100644
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -421,7 +421,7 @@ int drm_plane_create_color_properties(struct drm_plane *plane,
 {
 	struct drm_device *dev = plane->dev;
 	struct drm_property *prop;
-	struct drm_prop_enum_list enum_list[max_t(int, DRM_COLOR_ENCODING_MAX,
+	struct drm_prop_enum_list enum_list[MAX_T(int, DRM_COLOR_ENCODING_MAX,
 						       DRM_COLOR_RANGE_MAX)];
 	int i, len;
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 07a7b4e51f0e..7fa3bf74747d 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2431,7 +2431,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 				    unlikely(from_replay) &&
 #endif
 				    ic->internal_hash) {
-					char test_tag[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b8581a711514..e6fa2782d28f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2267,7 +2267,7 @@ static void stmmac_dma_interrupt(struct stmmac_priv *priv)
 	u32 channels_to_check = tx_channel_count > rx_channel_count ?
 				tx_channel_count : rx_channel_count;
 	u32 chan;
-	int status[max_t(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
+	int status[MAX_T(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
 
 	/* Make sure we never check beyond our status buffer. */
 	if (WARN_ON_ONCE(channels_to_check > ARRAY_SIZE(status)))
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 80d13d8f982d..94fbba052b49 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -43,7 +43,7 @@
 #include <net/sock.h>
 #include <net/raw.h>
 
-#define TCPUDP_MIB_MAX max_t(u32, UDP_MIB_MAX, TCP_MIB_MAX)
+#define TCPUDP_MIB_MAX MAX_T(u32, UDP_MIB_MAX, TCP_MIB_MAX)
 
 /*
  *	Report socket allocation statistics [mea@utu.fi]
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index bbff3e02e302..929981a8fe98 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -27,7 +27,7 @@
 #include <net/ipv6.h>
 
 #define MAX4(a, b, c, d) \
-	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
+	MAX_T(u32, MAX_T(u32, a, b), MAX_T(u32, c, d))
 #define SNMP_MIB_MAX MAX4(UDP_MIB_MAX, TCP_MIB_MAX, \
 			IPSTATS_MIB_MAX, ICMP_MIB_MAX)
 
-- 
2.47.3


