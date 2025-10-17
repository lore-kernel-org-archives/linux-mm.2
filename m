Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0691CCD1A2
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D3E8E005C; Fri, 17 Oct 2025 05:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CA78E0016; Fri, 17 Oct 2025 05:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004578E005C; Fri, 17 Oct 2025 05:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE2478E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:07:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A30131605DE
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:36 +0000 (UTC)
X-FDA: 84007028112.09.BF2934C
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8294EA0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="cJktT/N2";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf15.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692054; a=rsa-sha256;
	cv=none;
	b=kwZDi4hnYSS++BaS03c/NKV7KG+4YS6/xia3714OIv/xNey9zI0kWRxIKTlLIHCnANE6eX
	a4pxXYqnNX+16ilkIe6ODgf1klUunpu7D0co2yygLtnkyrPUmpLmfFJs2JYyeufeov3CPk
	zhVCBEClaeVlHT3nxGoaT1ZgGlKRqvE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="cJktT/N2";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf15.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAlxXvtF6wZ1RF0/zktk6f5ZtKHAgPghtBG8hJeCJz4=;
	b=djMQR5YX+/1atwhYjqJPhlKabEKipONsG3Zl4PiyRgBB7qEsfH/VOt06lYA52ARIXZxmw6
	W/mgSDr9xSVdvVCqw1rmVPGuiP4LH4TU1BAULYNSw32tLr0C7yZbAWIrySuO9GArc6I3QD
	1DdmMUp/XHMo9exXvNT/DUzTIKu8zW0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692054; x=1792228054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jAlxXvtF6wZ1RF0/zktk6f5ZtKHAgPghtBG8hJeCJz4=;
  b=cJktT/N2nOTTjNFREjUDLw8zdgH58qPpUSjshQpZ5ZQJDdShx4oyJZPH
   DCQLIjEbzl8TGI7SWleCZsOfCB9vCGHe9LXlq0T1z55pv3RldJdwpqXIf
   hKfZkXAV3oUITGQAQAdDsFpmhHA7GWlRDX3ujG4KrANy8Hod2Eez01po4
   3HcJPgf7vwviFEkayWH2g8f9peyYa4BMSp+E6+83xfRjqIwh5mW1lXd/e
   sikbH0NZyJye8To63E4K4+LlzDEw2VZvcrMCZvyEtFLvsBfrQeZojQ5QN
   K/1SRe/bTPnTKPcCzxsycgkCK3T0YXiLYv5sm8G8VqxrvCZBJbswrGHzD
   Q==;
X-CSE-ConnectionGUID: cQUVe7RrT6GODSgYFbCEjQ==
X-CSE-MsgGUID: 3WpmHRSKQ8OYOAubrpvS3w==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4952086"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:07:32 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:30405]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.51:2525] with esmtp (Farcaster)
 id 7bc6b824-6494-4ce6-be82-2170fda5a10b; Fri, 17 Oct 2025 09:07:31 +0000 (UTC)
X-Farcaster-Flow-ID: 7bc6b824-6494-4ce6-be82-2170fda5a10b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:07:31 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:07:16 +0000
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
CC: Andy Shevchenko <andy.shevchenko@gmail.com>, Christophe Leroy
	<christophe.leroy@csgroup.eu>
Subject: [PATCH v2 06/27 5.10.y] minmax: Introduce {min,max}_array()
Date: Fri, 17 Oct 2025 09:04:58 +0000
Message-ID: <20251017090519.46992-7-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8294EA0008
X-Stat-Signature: ndbc4pfuma5ywbnpf9hkgo8zp18mgdsi
X-HE-Tag: 1760692054-801715
X-HE-Meta: U2FsdGVkX1+SeNtutvsguBrB4h3HNw8fcrvGgkSOtCEyWsvdKw1AVU8ZZIAPND1L0PjT+U9L6C9DFdVZPsEhBQbVaWYT0MuoalDjW7PagXiyapkYZx71GW9057Kfdr08Hmuys6hxS502x8z7vBIdjWpcJnwL5o9xueLEUYHL4k2WEK7s83l78Pf6X7AkwmKXk5m17JgPfJP/exfK3rnI2NlFt1HUkqofcf6A0u3HcLFjgJqarxtY7rUOuzvsN74B1DAY3MimYTFDIiBzxaUxVcpE6smZdVDb2af3RQBReTZvCzvEq4unhHJQfk90or3xpCbuFcWnIyBbAjJP5e2A993+bEaySvs//o/aC2B0LAotvvzQ/UxMoP2pC1usemh4+ikJGgV8juP9u5Ki1gbhvPx+c8lqOw40vOaKsn9j2QoWgjRcjkY2QM+nU60z5ZRtkAWYu/lqEmp+oxdCUoTPbi7Ws4xBddU7ettElPWfIKmRWs8imhkncb7tDIZDtEwf+4QThc/0ybtrRV0PlcUujHgZc6+iJTxjjWjUobLBF7VswZRFiUbBkkjxC+IyZoctz9/ajLKJB9+fZxV8u8EkImupD7bQXvVMDwSzPoOYYQkquLFEklHHfZOaPgcpXwA86R01i9W4Z0FxktlJJZ0k44asN5TI74sihKN/P3h0oMdbItAvNkeJgztGFjBy4HE9qn6g5r/JbanRUmkVwk9Pkc8NOMjADAc/rkgzGDgR8JpKqNGCTBaAc1bvYEtogdFPBqCv2BfKpwCCM0CFxUBs6eFaajqfzRbJVJcGzGA30TX15O/72nkPLgMT1rxpEB9seICLKSzy5TB3uCOezkACqxNgd3B6z+N84wtIpB6YbW6SzpRFh78kaoheSkV5AF11GXeYTEdDQLUwBmb27F3YeVfyk4qLxRhXSCFkdJsO+XNMQibRzyf6nevIxQpDRTH6EvNZNYU1487OOh6Kl9Y
 km0Ntw4h
 cICUMkYGJUEC4XGOfk+ZfL0jB29+Cvl+ViPKWRloqwgJbGmnqCBLQQBC1xg/tx+hZHN915FrrEXyiOFClc3e1RgKNEcjqjaJEpLXax9cnfg/w896H3OAlpqI0ySuBvRIUBgbPlV1v+E2mdG/3pzTd+Y1Kv8bCjOEQ15Todrr2fBy7r3NsCA9I3Jv8Fh0GYPVYuc2z2wsKFnxssOg024LRa/thRqe+Rtn0OsuUvnD0YsmVVYgxG1BKa9U75mhmjYHqK9acRCF3nP9Og1p5im2TqL20P8yNQx6bUqdbRwSSknatiHTNTu/75wMKOee1Ouni+AqnbSlcJPtB68In4FhLgZyIt5uVL9K0fO8ouig3ZXyyPOIN1xkHPgzTymf8TPY+FHmSdgdvj+iwhHNpbc4thc5V/Zgv817n+6sPJDs/oPyIf0nHWkdKYP6euEqo9RwCHc7nEylSWpsIMJx+ZCw21S10YVJfk6Cz+M7s0cKkXMmPDvYJnarFR4uDEnoa7koomy4r3fY3kMAg58OYAg8csml06XzmFZGpJ3JgLCrFCd7W2aE8Afi9pQcn0AyviMjwAT7vjWXb09+sqM817/cVTFe1dCmKTjM1xKMfSVJCE7nRLLemr1ymYqEF23ZtLD7BGcJ5j4wBIoX7Zzq/D7YgS+kdRtjOiUJuxBFyJAYLeJRETmGzRZPEiykxaMRFB7Yn3cyOZ+p0f8N458W/NCeO9SJtH9K5xNf/5uOfSlqolHrPAk1BEM17Dp+qeacpHfHrueXzpICPIErR7wqD+3QSFjqhqSWPDKSxGunRt9b5vd8BcOBui9Ef+H6wLvTemZ+aqO31puGWXGjKug6ufhpLSOBitoEJr7nSsASNNSi/7BSHMr8fqmeGUMIwZzgTRSGD7/p67KdGzS+UIrW9d0kn5vsa5Rk9qfWVC+CmTID3iPvuDLhgJVUnJ1mXZAg9LD3PKFkrt9/fH4uMmib7CJQZyvI76hOq
 LVHc6Bzx
 wAjBTCM9EBuYiISAoDl6SifXZs907mR4FBZkltJxHq42tKNQ7/hQ7CzS42oVGS7ywKv/Gma3lcgV9S/vGPiRd1wTaTaqp5To0uItJ9Fkk3jDGukNzK+PLltmKdXbJ+WVVnPK42ZclDJnf85nJwDkJ8LaBkxzrqev+CBWFMnUUWuSJh2MCgNTpfMjfI/bJ1mWSKyGR3ukrWhs3cq9e0/pEyekSeEmfXOMYid8BWv/jWJ3V9OITgLK2z11zWMP4FhxVZEKkQbgVhZyZ+vm7N4BLCPBanxeePZRsMJ5qiJ4i+LhJyPts2NdzVglSbV9c4wx4AXQ9+VxNCQCWe21EuKHvM2UsFUS6FK0TMGOTjVwGOJsQWXlKGzhY32FBzpW5MYxOotoP92cCUYiL5y/XMh5q4M21a/lk7/+681CxWBMpYPOx6BdGZCLH6kenXUIwW4YPX7gSk5fwzDn5wJfROrlg2pSaWPkz7uvu+nsZUKCNpiBwfarZ3WEXpAmjnib/7mjKUTdIqlWqWNlxsnnsL9Msg6dpW3eO9mziPxYNHQnN9B2ZSI5kPXEvgj4m70LGTVNGdBOtHxAGUBZl8CqkyZo6mi1KolZErn24oIVNEuUrxOKw/D/jTws+4/oT2D2DvE2Nw60QmJmJkzW4PhU8zKLzYIUR82EbnZdC9G/eRiCpK4rDywkvyJ41JYl9+Sn1D2al1dWCRwIbiefihq+H8p9PMIYNbD0yw34Bgg9pDjdc9TQEzey6X30vrJ7RI0VTFsoUctuxfo682lSL0FXyBBKin1ZTG7PahE/S3j7Cqv5HwMBKgqcwQuh/G9VIpLElUy/Pal4nwtMGMR/eXdsObdBVH6cmhtJLX34jLIgBr/R6TcpkTun8jutrZK3rP01aMo6GNC48wk+b+G+QSQiAkFaC4tlMfxHZs2EBSrVhTeywYN2C5DkUB+BRWEQq8UeK9roMzFXH71sVORbEVUz9PttNDYqZpd6m
 l4k+Tmy5
 5Z2wyC9vDRZSqTTTWyqnJPEbqD53sdb5sBFp4c2A+lVNSEKYgPzahrmnDzFiOamrSZdfYQx6M0xDp5Q8PJC0uJXnW3ruEKCz3X3v31pGSY4ihAP8wlyrVHR5ExwuIvEZ5W7wLhN+pdM1BMmXHBr+RhSGqO25XeYZO7TPNEMO+q4IKsSX68HjETq4snSVElrdDrpBKJsx5bbhSXQjUdf3oOmx4rRBPxAx6lYobsdK8ud2Ph24fXqjVZSWGmy1qdnA0Rg8LofEwn/fWOS1ZItVxbMHSPkfg+jvJz59tdla2DrSGNvegEkywEUTuDmLvNFjD9lbgL0cBKFzD+2SAENo9oBkvhX7OkU8L+atu2SEb7q6ScWXpsm5vEnhzXJ+iDABvxPOp+2iB61bp5qQAxNHdhiWxHw8B/GEOtPu5sU+BF98gMjeSweLEViw3B9sZ9O9mPht1iECXvT6DPItYNAKAmDcXBxW0Y9q1RgG7SuO/WwX549TJre8S7yo0sTCjWC2qkf5mJOWcLO7MWxcBoAAdpYJHf482Uscf/N8h6/UxaXnG5XsgjLNdmV77SnD3DHJc9zcBV3MDQhptS0dhahBlZxWOIqDmxmvRWpitrnwXRHqCgsf0C/fdpG32GEZ0pPROUt6On5N1yZ6MeIcoHETfYpZnsxU3MvVuDY3/YTllePxHG09+ViPmGZBmz7n0/iuiWrQ7DD1Hh/6Pg01+DGuOcJa2hHzoDCsIRmLlly0KDmLlwD5MC1hHVvl+7TPzSudRrQheNUqxdpjtMKkB1lO1f4OyZt0qFBeEmOBg5FvF6Wmz5TSj1YR8rRkswDRRLLrlXPPx922piIMN5wcPX5RMGq9ABYD93kNEARevhOQdF2pTc3NqkjxfPXc8RpWqHZ2+klM5BF6YIexWSgZ6K5YdoEM9IJr4Z3AeIGT1LP1SOIiPuJ1g85dsOhPMGaiTp9JMuZeIi8wP8nEoxHGdKElbpfaU6b5i
 2jT8Q8dr
 DGNfh1Kt9MeC3Gsh2hpRZQNpMT/p+i0ER5RYj8wlIZbKc8BLO9/6u5ybbzWqroAQT5G7+AB1iO7XEzyQjlqazYN7VANLun/hh4eVu1Fsofc7BiRy0l+aQa9UMHWZ3oxMuNCic85AsvUYLYOdunaKidSPaphkF68384n5h5J1ZJ0W/lEha8jhf/zRB29Smx4OGufkyqf/Ye7EaGCpbYFVZxXBuuk0RafQBaJQw42yytAkFGfJKwXMq1ynsL0D6UTdhnhVzEqCZUonYz0kWAe2NVhz0bbF87P/WE4dp9jbu1ciLH/NmhvOyQO1x1QYMTagat4pcxs/E7R5t4F65H5OtWvGIt+/gJ9k9ObWk1DMCUoc5PdTXq0X9Ij2A4enfkI7M1syLp0FrkEGB+5dxORJvCaa/Brf53xKcy+OBx2EbsZGTz0wOLyr5ayIznbB1/5eEsn+jEII3YclyBKtQaKwnCKVgzgcYMj/w0Gopt5KAdslU0m5h6L4RDK4qF05yrr4JCcxmW7OWxH+SqjvoLln4RHLhmJKuYxDzk64o20t/1J2mN6HCSHEXtoDzB8SfgVNNmWsJVZGwAaBE/VvcwUNWuMAqRNvFjFH8UbN1sk8QQ8if4HJ7hp0qbyFt4hwxfKYfBa+bYt7jkrt8l8MG9aQUzetSyu/Ehs8HR17E7qus45rGwFLDIcgw8QfCXx8hlUse4hQE6N5z0udNSkIw7q6+NzzQyAlTN/n1AQHUwGMX/PFjyK499iPW/x6zdFy5Z/7BqkMSsrRtdXOX/ftWK1aBjF7qJWz6l7gCYIYhZoG2Mf/3gFsK8wqQYmYMY63ce57UV6PnQQBYxjXE0MBs/iOEoV5hjCsG+1mYu/IJz1KP9goCT6cVwVpScXynbwuDChZJxP89qbM+K6/KDDUGS3UniBI2nkouRmITaJmnVXvEy5t0qE8GRf5lv1vR7oTveBKAEul0KQKtgqsNvCA4j67bKzaOor10
 k/Q9XBta
 ecMplo+3Y44CHsJhMVZ0riYUwYfFMwloJruKUD4d8SZNNOYF7Gpo6YNkLw1qKm4k8Nhhuowr1Nq8ikpaL3RsLlMQ08Km09OENtlzVQoWvB/XPzBrz573VE7tssAuujTGrQH7taQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit c952c748c7a983a8bda9112984e6f2c1f6e441a5 ]

Introduce min_array() (resp max_array()) in order to get the
minimal (resp maximum) of values present in an array.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20230623085830.749991-8-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 64 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 7affadcb2a29..0e89c78810f6 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -151,6 +151,70 @@
  */
 #define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
 
+/*
+ * Remove a const qualifier from integer types
+ * _Generic(foo, type-name: association, ..., default: association) performs a
+ * comparison against the foo type (not the qualified type).
+ * Do not use the const keyword in the type-name as it will not match the
+ * unqualified type of foo.
+ */
+#define __unconst_integer_type_cases(type)	\
+	unsigned type:  (unsigned type)0,	\
+	signed type:    (signed type)0
+
+#define __unconst_integer_typeof(x) typeof(			\
+	_Generic((x),						\
+		char: (char)0,					\
+		__unconst_integer_type_cases(char),		\
+		__unconst_integer_type_cases(short),		\
+		__unconst_integer_type_cases(int),		\
+		__unconst_integer_type_cases(long),		\
+		__unconst_integer_type_cases(long long),	\
+		default: (x)))
+
+/*
+ * Do not check the array parameter using __must_be_array().
+ * In the following legit use-case where the "array" passed is a simple pointer,
+ * __must_be_array() will return a failure.
+ * --- 8< ---
+ * int *buff
+ * ...
+ * min = min_array(buff, nb_items);
+ * --- 8< ---
+ *
+ * The first typeof(&(array)[0]) is needed in order to support arrays of both
+ * 'int *buff' and 'int buff[N]' types.
+ *
+ * The array can be an array of const items.
+ * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * to discard the const qualifier for the __element variable.
+ */
+#define __minmax_array(op, array, len) ({				\
+	typeof(&(array)[0]) __array = (array);				\
+	typeof(len) __len = (len);					\
+	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	while (__len--)							\
+		__element = op(__element, __array[__len]);		\
+	__element; })
+
+/**
+ * min_array - return minimum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define min_array(array, len) __minmax_array(min, array, len)
+
+/**
+ * max_array - return maximum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define max_array(array, len) __minmax_array(max, array, len)
+
 /**
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use
-- 
2.47.3


