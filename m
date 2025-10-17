Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 295E1CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F13C8E0057; Fri, 17 Oct 2025 05:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3038E0016; Fri, 17 Oct 2025 05:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642008E0057; Fri, 17 Oct 2025 05:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49C228E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:06:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECCAA1605DD
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:05:59 +0000 (UTC)
X-FDA: 84007024038.05.4936075
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE975140010
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:05:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=cxkK2KXT;
	spf=pass (imf26.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760691957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFRk/YEfanxcwxn3T4iYIqsiSiWmkv1ShCNggWcZo/w=;
	b=ESm4H79lA+AFFbGbr6M1dgC2i3iAkaDty9bUQmIoe4qu5YwjxGy2kHzfk2oht9A3dj0dwZ
	kXq7322W3svmxDYR68PwdkD5LKSFghSayS1K18uQo0EShldyAUxOJhSuorpOvmrpTDzaYR
	4fkZs18L2pJn2u+kbV64nOwwiGiBc5A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=cxkK2KXT;
	spf=pass (imf26.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760691957; a=rsa-sha256;
	cv=none;
	b=LqG+y6kc4CU23lER3cVztPeuRodIs5FzVIPTjS2qAl0Kvt2F+7vDyReHLt1NwxfvEQzi8x
	E5+hihmeKF8JyTpjMasFr02wwlM5LSWIvOYfwdJvNhy5t8yFMYDOdFwqxsuvs1YQZXv8hT
	s9any5jfsjm2OywvGWmbneHErPAz2e0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760691957; x=1792227957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kFRk/YEfanxcwxn3T4iYIqsiSiWmkv1ShCNggWcZo/w=;
  b=cxkK2KXTGMe+4xuTUF5gr+bP2faaAdiXzuRNI+WmQi/EQoTGeK2tzz2y
   k9KRIuuFrx6Ma3WLy0r5lRyb4MV1D6AE+UdedU1ONE3bHQcA+kp5Lfs5D
   dD7WSpymXC1k5XWcDnI42/xAGTVlprYouQ+6+GhCrkMrIh/lGwyOf9RPE
   nZ9DvJCLzwNA9HcjqdNalDB5GCbfRf+QIZVZwr5wVzY0VyNMBDCyiMMO3
   zc9farIfVO7U7pQ5WYWNDSbcVOWwiItCKH34KKBLuxagdZfBbKvN7ggXL
   lYpGrdv8O+LV6MV0m9Y0ipL+4q3QPLVshIwa6ZKB5mpO6d2FH/upSS2y2
   w==;
X-CSE-ConnectionGUID: mmWdkVVjTsyPnw62us7gdA==
X-CSE-MsgGUID: zCG8tz2uQkG3AJR2iQRSzQ==
X-IronPort-AV: E=Sophos;i="6.18,263,1751241600"; 
   d="scan'208";a="5073156"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:05:55 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:9202]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.191:2525] with esmtp (Farcaster)
 id b995c6ee-454b-49f6-9b2c-0072079f78ab; Fri, 17 Oct 2025 09:05:54 +0000 (UTC)
X-Farcaster-Flow-ID: b995c6ee-454b-49f6-9b2c-0072079f78ab
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:05:54 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:05:38 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
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
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>,
	<chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>,
	<kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>,
	<ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<tipc-discussion@lists.sourceforge.net>
CC: Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>,
	Eric Dumazet <edumazet@google.com>, Isabella Basso <isabbasso@riseup.net>,
	Josh Poimboeuf <jpoimboe@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
	Sander Vanheule <sander@svanheule.net>, Vlastimil Babka <vbabka@suse.cz>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH v2 01/27 5.10.y] overflow, tracing: Define the is_signed_type() macro once
Date: Fri, 17 Oct 2025 09:04:53 +0000
Message-ID: <20251017090519.46992-2-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWA003.ant.amazon.com (10.13.139.46) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: ndmya83hfs9gcxrqy8a6bcgd83y9mjup
X-Rspamd-Queue-Id: BE975140010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760691957-552667
X-HE-Meta: U2FsdGVkX1/zLrNhPgj36GMaHZJzW3EePkZOzVrbAhtiYDh52Q5O/pqzWyyQfc5Z227YqG6ng9LN7nwk9H0svUBSRm3x5+VhYBkMN7wqroNfREx3DAU0TN0S9f+fm9/kk6yupCnSCW/b3DybUWXUM717UM2MpAIsA80J0SsE5u4rY91ESUe+ae9UGhJIKW3totvP95wGwGRj3i/lTJHxiiKJYiO96XkbQjA/5bekwoVBygrrv02N4mp5PotuTcdBZzoYmXa7Grh93+eovYAw/+2rvUiYT2iy5fjhgeqpHfSN9o00bzcWc4HkgWwCv6145g8Su3bSQbuD0VTRPsXj4vPpWV+v07KlsUPSk+P6o97Y+bnbpjFc0DNmKYgwyPt7K0oADcs3WTHp7zcrgLvqedf6KAWoKNmTWoNqGBc15K35pbLvZg8wHZYmsX7YCRliOxymwfR/0CmehGLXWoCjjzF7P4nPKaYDVNrJeSO86FGH1/OuCZ3uLAEFlMGgqpQwDQZsVjp43j3tpwxd/7nOlz07M73PFvxyPYQZ05O1tV6IFDoQ+cABAre2T2canHnCr1OLSmwoSccB5LLETp1wuKLErI8roj+rlIUDUwxYX6KB8RkPBXZ24XdxJwyDSVxr81Ff7MEQGK8T5Z+r8dg+4R+dC7H8utUOVo00ZOiy4P+KHUSmZXAK5tNSh6EE3a8oe0I3UQhLEDdWp9Ewdl49i0Bhz0CKW2KeDNYETi/vpQQYY+NQ9T9krU/vJ1asfZJyOXuQobBE1iWdbQRRZtCuoz55BLN2+yFg2BEQcCtyyoV9NlFIs5z0hhiBMKQlf4zWhhYdaDDAc9z4BX6kEm+wRlhYhWj4f044NE5Dctluv7gTmaINXUPClrveMocR8R/qr//tpCRildDa9gz4OAfPMR0ZcNypGssRhlpacXNFe4K0U4Utj1RYXeUKp4rSG2UoRWFUQPCsemRNlEQb8yG
 tTPcMee1
 hu9bN+DdpwGZgIrcIN4WnastWFWsxMrNs9ex2no4yYezLPIpLrDfuC+Mb3zqH5lXhj7Wl0ZUpHi0l0H2vaRFqQ/vZHh2EB6mETjqLKRCHB2VIlgKX9cMztgJrsUO9ygu1BHBpIM4gbrEIrB2Z1Pmifpe2ktaEYpNcNRfNAc4qpIjFybD26QO5UkflUnbND+ksJVKio+BPk+YYlSm9/gGxQ8wnYqvr/tf3ul4JeYm91/vvuQYZcyxS9ORs/iqlreZSlI22DLROlA7HAqMmoAv2CStbbpBX7urL0OgO0wUHpibE98zFGnFYG0UDfcgaSscfF9aj5tsddaZJzzaFFExx1DXx5r9GS0atEfwb9qVqP0QGiy9DDyVQgcOE/G4lLjChrOEzFydtU0OOTA911NfhQlW9WFR+Mkeu66Xd6RMcRnQEElvubBjYQ881VZavc+DaryJer1AT3v4v68Wk5tHZkdb1W3mHFqYLHSNqHcfwxu/OoU/VAc0mp2h4H/wcNy3FTeDQ1crgLVWBho5UVSk6gb38HYWkWBoiLJgjwNnJRTP9mwl6OZRdVEq2EX6Ly9v1v92vk078xw9JOKKG7O0UGg0GFNdiSPUdPdqilxLSnFaZKp8jhr0iewE+KXwS9IR6/lwDhe55MQGWO/mT8/hGXFLu/2+KdAr1d6M2zQQclm54wlJDkaO3YIqSFOT5azEemTiVHRMjYRtATpYhC4DxGm7Flgk/HpCoaWALfVfXciS/hjEl/EH4E5ZFwluVlgJ1GZE0P3vdXKqzGSJUIEH+AMZOEOpmM1voliXtCE59pgEOBjY1kOeo7mNxmUldbPHqRTT+iuI9KRWUYs/zfYWKgXWyM4skJJO36A6hhHp+doWFrBwAq8VDNvZ5ZJ9aKc/ymTa8i0cZx7oNopXzqpm4SurYjW46XcCvXtSAJXW/Xd+sY1spXo2cOsSRcPywqfIEyxTeDftM9oNPbHg5iLEf1SIo6Hdg
 87rUl4Ej
 XhfwrXVW1seyg7kbBwyOL8EkR4B6o9rgU48zJhfivgzuCkXNm/qI6cF+t1wta38GT7+pi/P7TyHgkylbSMjengQ8uyh88fA8aD4uT0ei0tQPK5E/M9E+5NKP3Yr20dE/u7obMgYkAJBitL8iEnWvk8i375+JufKG8QWqPSZW0VXpRBVgoOGybQytz2fb+CE+D5oNaqwTN8QdZYlZO61GL/dj9RT4I/0Vsvl4l2ay5lo2VInm/BPA/4LCZNrYn0QB9xSNfnstu8ubiVNd6TCvEPWjm/xEgM4wNHWImHlGG+n/B6d7m2V/ugX9EflDZm2ZkBoVQiNgDQPNbDEYWkOHpPH8KA2UWOSRMY4Ppnvw9DUI0ApMT4HLU6oKlEQr4EPQskB2hO0J8zYMYVq5ot7vsnmo8TKjiXCq1ggH3ApKujDlurcR60GLX1/ZBAvVdZ1dZAz1cpHYQhMX3lyJ/ouHU/DQsaN96NUuLPz11YV0c4rs1MdK8nmPdAPC79jqblKoCYIGAVaVSJUisvS8SEpjzC3lELNcXJtuMgOvH+18pjGFy3TMGG51b8ZcaPAI7Kk+tB6Dpp0CoPJBMNWWCfjyF1/FUuHuwx7jnCNVmhuLiGNrwwsfx3DN22ExewcZbzPiO1qp2VqfRGvpN4OPoGSMgxrJp9K6+4lZenXLMeI7DYoI7eFW9dKlftFpaNhdBS4OgLdlaIycYqLR8GVPVpemPs9IE8r4lPd30drgxZu2A7o5TGj01KPELAgjmEgc6EDSzX8/j60ueg0AR7cXg981YjyJx9/k33+whl44VSTgt+cHJv5vL9OeXecwuO3bXDzRwwKmxAXek+EkedIh4NTGOI55dqwJAfpD/73icT8ZPukxOXQTXNlIW+ZSBOBxdObm0AYa2CN3VLfDG9WyPA7kgRToSWk7nUfCXQFC7L+aVQmSOmQW2qfBtryvXk9XyxtcOrQBau+zLy8dbIpFQeM/Np92eNHdm
 iyFJiP7F
 fdQmWLwVcOCSnVwlWmfNOoMVSKWCWNEKa/36mpzmmT2RJ8UJAAEgiBpILFjaSjexJbqlh0fE+gHLI1ZBN9aZuhceMu5tfQ4PcKsERnc+i6+hTelXtEBG6VItC9PMSy1vOA5UgcIU2R026dy1AgAl4vqEoffFZ6bv767cPByRC+cqf/BGW65Dj3bAZkGAb8J/7zNL4IMgF1BTTxaRbfwXFJ45LlEzo+VenP7hfosjHkV3Rf0OovbLe8WiJiK0uC+lRV9zG6CeuuJ5/kSV7M2tN+CQB0Pc6U5EShbWcwVMpSF4yoGL68DmUwCKnMmas9mYcCdgctNSgPnhmihz6lQc9WNSdRxKnathZvX+D8S/u+mmWw7ZIvBgPic8WPjazzRXz1NeyoaIwkZKXU5Jp1uWsOfHKMAG6J3MWPV4IP9jPWpxExKWHmuEdLw8BNENAoISUmGVjh/snTXQ9Z479VY51Hm/JjHRtlMm4l34WSprTdu43+Oq+nPnpakW4PGaZ2KCx/7Ow8jhrVUYloIcCPBhVEiACD7FxPQy1pYl6U//ezheJ6iMbxstK9pYWixCLWXec8MQp9/ikMWLjcJ6Vi+suCQvoQjr3GJEiKYjYuEUV1pi7sCsN8ERvekSg7DC/vy/gSZwljiC2C7rwmNownGD9YwDOn8RleE0dIDGHVWZt8CZ2wy1thbco8JGO+C9hjFz6k/utCSKWejx9IobG3RiPqJIqUv6F7Tc9/RzOE0G34Cg1Haj6iIyYESRhEm9ooy2vcJJi4CBr8VQ2QasZGCu2N+4ia+OARi1Ez8HZ8ZMGhSp+XqYeN9/dKScs8fo//TuOL3qgCDYqSc9YG3ktFFmqzl3RPY6Xvh4xCtGxMiUdebWpmLtqrJoCyCfuKvkoUU63D997pu5HUmyQQ1C4x9F6/e3LiOcxveMvFwyusDnyK9zzJqYMBxd/UB5YlyKUaEWEhseh5tALDdJX5sT2fFw84Y5U9aTW
 OyyO3d3J
 6F0W5044AL6gHkbjoOipSFqlynddT98NeQzwp5w1wPfCqP9k2iVF8re1Az+85JWEEXXsXT4myxqNwjBWLUZ3rEIhZljL7GbxiOuukqdVOox0INQl6NjN1A97huK2G8CxLYkTl+WS0fkiA+6iaMR5/Qc0gH5Ziy9iD+k64yfyxBww/BUS73pYsEdNxKU0bp9D1dYCX+eBrr5ePgX1+zcykP1AKxmoWTohBprTF1bQc1w8cGbqD47rx3bl2yY4bI2g7YrlFGCo02e0devz0GO1fuz4YJ8xP+qANuZ6nu3xlpOCtvaFlWXb2IHkZ0HqK8sekqICuUGupO776/4dZ2n+1q4Phl4XLXERKUIDGiDAzeuWCTYcjexc2U2PHR3pgw/T9P+VHwSdKGSeMcwkDTTYMmoVpT6TSQKsQFtKE57zPGzC2ag7+WcBqAiHtGSQSN/yu72x0WdiSDQNrImILrxPlD35S4rW9LOYj8A92RLlAsqBdBXJRydgkM5AQWz2YFhvdMhAtF/HNPNwxhgCsohhokZyZCp3Jv4lXWyNplom8NPm9r22+QTBt3BBYtSFDmIOy6Ctiur041ttN8+nMqf1ERaMqMc/GYiLj6JyxH+/YuyDrsP8tPH+BFAlwboIw7EeHyYwTppjVa3NQODeEQsKmeDKAg/2YRDHgRKRlXW/F6j46RdNDnTr9cDZ2GLx63PLMb0mQac2Cw2FrVdQqe8/k+/oLOsb6f8zLza6LBLWS7EF/tSA2IMO+R7ZEMJz9gFtbihmasNp8f6hx8uWRAXxJqw5mGhjWaRAVQvsFAErb/Qv3RN/Nal8QUzp63B/A/vkgAbzoBIxLWSF6DdKPi7I/VoU6zTBeEAfg7+y2sFKdsAR+rNECBYC5hhiQUUWryRHogO7kP6HIw3hmc2SEz3wozsrqjE5QUa2EiO/i1NZjqnAS7wU4odFSkpnHVFe0RWaTvCNF1ADhMehkNJaulpB6Zh9KvJbZ
 PyX6D7s3
 YbaLidxZxdYKvT2KQhGXpi+NOI2VYn6I+wthnMN4Ml3k5guGdk1d4n2MQb12lu2p2xsq/S79ZfcK87nKguqn4KMFl5Tii+2pFc+BQ/8vQt6evZCn/qCzJ9YFQFF/x42u4JzdqiEve1tpgatJ5sLlfu5aq51ni48EPE+USDThH5WK/6yUC8DeoSyTgZuFLQFwk8xsNX97iILRyCZBxcKGkJrmgmroHdHxuJyrUvmpMJjhh4Ow0tY07t4jJpjaRCklNtJlu0jMTqGVug7YpsydbmfTo7RoqEallZ/f+/pr14ndSwYZe0NVkZIIbstQioDls+oPAuOECW5TqCZyKyH/JU31spetjSNP8c77ryX/vLPVxq6jiIPVThh/NInpdbWKA93rPXRjBiEOGVtqlnk1dSQY72xSTv52t+S0+VeewhcmpypQ+naFHuOPBqgd46mE7Dsih8E+8YbyeBSI7aTr7wKBMwQlzq8xia1e7Xtp6WdOwuL6LBeQW7h6+st4qqe8wcEL49sQbiru1jwiCKIyaW9So731T48KnZyqmFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 92d23c6e94157739b997cacce151586a0d07bb8a ]

There are two definitions of the is_signed_type() macro: one in
<linux/overflow.h> and a second definition in <linux/trace_events.h>.

As suggested by Linus Torvalds, move the definition of the
is_signed_type() macro into the <linux/compiler.h> header file. Change
the definition of the is_signed_type() macro to make sure that it does
not trigger any sparse warnings with future versions of sparse for
bitwise types. See also:
https://lore.kernel.org/all/CAHk-=whjH6p+qzwUdx5SOVVHjS3WvzJQr6mDUwhEyTf6pJWzaQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wjQGnVfb4jehFR0XyZikdQvCZouE96xR_nnf5kqaM5qqQ@mail.gmail.com/

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sander Vanheule <sander@svanheule.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220826162116.1050972-3-bvanassche@acm.org
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/compiler.h     | 6 ++++++
 include/linux/overflow.h     | 1 -
 include/linux/trace_events.h | 2 --
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index bbd74420fa21..004a030d5ad2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -245,6 +245,12 @@ static inline void *offset_to_ptr(const int *off)
 /* &a[0] degrades to a pointer: a different type from an array */
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 
+/*
+ * Whether 'type' is a signed type or an unsigned type. Supports scalar types,
+ * bool and also pointer types.
+ */
+#define is_signed_type(type) (((type)(-1)) < (__force type)1)
+
 /*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 73bc67ec2136..e6bf14f462e9 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -29,7 +29,6 @@
  * https://mail-index.netbsd.org/tech-misc/2007/02/05/0000.html -
  * credit to Christian Biere.
  */
-#define is_signed_type(type)       (((type)(-1)) < (type)1)
 #define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 - is_signed_type(type)))
 #define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
 #define type_min(T) ((T)((T)-type_max(T)-(T)1))
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 5af2acb9fb7d..0c8c3cf36f96 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -700,8 +700,6 @@ extern int trace_add_event_call(struct trace_event_call *call);
 extern int trace_remove_event_call(struct trace_event_call *call);
 extern int trace_event_get_offsets(struct trace_event_call *call);
 
-#define is_signed_type(type)	(((type)(-1)) < (type)1)
-
 int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set);
 int trace_set_clr_event(const char *system, const char *event, int set);
 int trace_array_set_clr_event(struct trace_array *tr, const char *system,
-- 
2.47.3


