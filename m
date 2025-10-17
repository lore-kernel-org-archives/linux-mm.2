Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F67BCCD1A2
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6509F8E0060; Fri, 17 Oct 2025 05:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA138E0016; Fri, 17 Oct 2025 05:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C23A8E0060; Fri, 17 Oct 2025 05:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34D098E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:08:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF03213B5C5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:08:28 +0000 (UTC)
X-FDA: 84007030296.22.43C4D44
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA6F0180013
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:08:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Zhe2yM71;
	spf=pass (imf24.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnBmV/SkhIg5SgTRTNSUlBFA6sgQ2eBqJGsC4N+ceR0=;
	b=grzZfhancvHcr2HLNrcXwBIEfxsRTq5N2updw8aC7JDZyvdOgnbIrQ9IVcddXETM9sVbmw
	LGBLOoQ8GicFUywg2Nx5/2magQ5TZK5LDCNk8Pb6fTDtTNsI6KhCT6B/VeZEgS+CFr6DIQ
	kpyLd50o/SCzOaQe9s2AZWZn07IbhG8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Zhe2yM71;
	spf=pass (imf24.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692107; a=rsa-sha256;
	cv=none;
	b=23Dl9Bl+dDR5JlcKEV3rHGrPX7Xv8NTz66d6/WyHLL5SGxhROblJNc60rrWAtHeUnyHce7
	wIEtQbgZ8ohd0Wih6EeTeWyXBqhmLVM6B97hJGAk99urdEObJtKs/OHCYKSbPogQnjY/tw
	etYC4LF8sWimMmhMmHvXcp7Ywol1lHg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692106; x=1792228106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UnBmV/SkhIg5SgTRTNSUlBFA6sgQ2eBqJGsC4N+ceR0=;
  b=Zhe2yM71EgJcC5sw08/nHZ5K+P6f9VWJImY4bMqOlTuANtvsP9ZIbFik
   6KZFAGlJwaovxG5eIeWw3twp/wDYFEJ6FwJKOlezvm3qhvNQr/3WX3X1y
   e+czQjBS3Kp3avPUkWVa3R1KjBuIj2MPbqNVcVw6TEanxHCMEoFituNwP
   SEmJxdSPWCTGuh2B0yPWYcLgwOogjWNkG1GnLAOmPSZZt/ELiMet1Q//I
   dnwU++tgYYLU9lWj0P3TtUPYeMVprm4kn6iRW0toERgcJqLK2fy1S6xyp
   xHqrw3g46GKX5mvA8f3wQowet8Wcscao0UDkDwPssjwRP03Kr4dCJ8DSJ
   g==;
X-CSE-ConnectionGUID: cSLlLtMIS0ar38E4jBFoaw==
X-CSE-MsgGUID: Iy4u4ipASnC9CFM5BwZ/nQ==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4872748"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:08:25 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:29079]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.51:2525] with esmtp (Farcaster)
 id 4e6239f0-9d62-40c7-b1fe-bd066b1a9129; Fri, 17 Oct 2025 09:08:25 +0000 (UTC)
X-Farcaster-Flow-ID: 4e6239f0-9d62-40c7-b1fe-bd066b1a9129
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:08:24 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:08:09 +0000
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
CC: Christoph Hellwig <hch@infradead.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
Subject: [PATCH v2 09/27 5.10.y] minmax: allow min()/max()/clamp() if the arguments have the same signedness.
Date: Fri, 17 Oct 2025 09:05:01 +0000
Message-ID: <20251017090519.46992-10-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWA001.ant.amazon.com (10.13.139.101) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA6F0180013
X-Stat-Signature: tgpywwkj3psrosham4ns5qd1a8yqscgu
X-Rspam-User: 
X-HE-Tag: 1760692106-54425
X-HE-Meta: U2FsdGVkX19IXPX09wAHzsL1VHasZwSxRAghGGM1cHRirU/FII6LCJyBEpc3D1ojUMkIGuNrjkBIiRLduG7GHGEnwbUfjWjJVHsmqH1bfDV+9L6nXeSb33DqBNA3ect/VCKMDDzn5zEZ/8AHxtVwbakbSxidym0NPN4ShJlydZl9kVdz8JSuTxHhWSxVw2n1sy/YQ7BIurQQWlvPC77Hi/4Pyhj22GL9xTXbofe/HA5jIOHJIWIdFuQm2NSQTnvvJ5vOQQcyHpqqcCwoXftR54Qb/Xb//eq5GLWbllz9tihwjUoGGry09kYhkE63UtllLpxNPcoXqKhwrZoRrISuoEJw2Voc6+eXEeoqcu/yoblJCgV3M7zLKioLfXFJoIXqPzYRWi5vNK4a67i/IjVfuRfOMb81Xxn41TLN6mLFgodeOKTIUr+vMulfKv1INwDQJDHrN5URCmELmYx62UFEsl7l27b5SPl0sdK8nLNP/aW6KWSElfEkhxuCQIuRj7MtS4TeHp0lB/01k3+w6aFvAmQvPjFkC6LbJ2+566Mjvkszy0aErbN57AE2MAQmuHtbCkFh5ENRyqF5HN1niRzOP1/CJsboxVbcPqmrjltwZI2BA095Tf/kWHiZgDsKFZ+Ds5dZvHxzBeuiMl+Hm8ykArS+o1avZN+LdpJyjuwXlZUGlHooSM5mhTEnqpUiNhHRP8gC+ay2cwQIWWwJcnxZ9hk/F3QOZ+l2J+eoPetTU5NrL1WOYr7+n3nXE+CD3Ar8t3YjU3Hj/x9akuz1VYa4Uq5Yu9oEVHJBOrPEfUWZnr2Ir0+LAXCV/S9dx5P9AonnYN7fswknfwAclHUta+50hlAIVmhks/AmaFzv8aw1fN/n2q36VIi5/QIoTqVuxplbsTxX92WvpCoF2Yv2jphgygJZ+fSyrSIY+mWtG8/wi2wjS5gRjBBB/9Me7XMCwUPKA2oMy7uSydLso7edIhv
 TjLEiI4D
 gi8OoBRX9FSlJ10r35noX97mcWM2KVgSTMCtqtGzJNIQjCrkgajJciIqBD5FKcUIuInrcXJ5d22FYMncyVUJNsU+KMmAEEiKM7HeWDUyRf1+/NnPiFKHUKTPoj7SX0m41YGJcxLjRg5YW4cemZTbTdtPe58MrSEoJInnZIW/b3cIyeFGfPNDFMDIENhFZ3bODlIUrMUQh9shK5tcZJjy9jSnld1l5sxUUj3/hTQMucwS6Zg+QDnwOwJqO8cgGJk3QA5/T0i0XFDSEZZefa0rkzOTLgKrkY8eZifqisXSr9wNQtKQqCSnT7aO2CHDXDer/ZujNbIXcfC5sfyaWPH0jLqy9RSb/LuFtFrbM6ZS1bJMS+EMcXiGsJReT+G54Mr8xOAN26sATm0BKXc/1BUI1s1JU2vKTgdpEUehizdWnUl7Dh6KX1SAV+4nz0Wrs0a3DliLB7t1vpmcyJYYFYKZ7cJgnpJZwPu+L8fiekAnHnOoeS9JNyCWOgSdypZS3+ykUA7M3k586BsSVESUcU7muoQcqj95vTAeiZuOw+Xxc6s9Ofj6azk6S2H4igl9iIfTx3tHNeEV8GzxjfmVQmEd5QsPymT0k9U1py8+j+iNpAXMw2ubMHAIkT7U2V3M9emDEvxFEpxfnkn++bMlcgxQMFuLK5Xvw10nOgYFB0CtcIzcCW88uaOrami1/Li9gjpg00C1KUenOQLl1/fBiLvIjHz4/iSfNN2U3sF8f4NVP3P62XtRu0JTze2cj+1/wJ9aDwZ7FY6LRKWu01bsSjWcJtXq9na9/bFMuATmFMCxLpR8X07T/R0350ecLMLPh7q1jsMySmhuZbp5lPj/UhP2K4qckkDqY4CBQ0mAjJiJw5M7K81Y42V3kRGrfz7Q03cjYjQlb2rO6gh9kqqxo6j1gmD6kB+5iwTKwzLSqmw5eiM9rsO35/D+xqeyczLSjuBirTSuS2mioX84yGamExqurMYJ3VDnL
 VUH21IJ3
 YxkJurgT1wBtq7HYo4eOb8tsGT09l9uEzxu/iWlJ9i3ZRFsI7sQeDHzldGzbKpkMczaoVC1wbsOVtatRpPkNDFhFnSSSJejU1BYZ2bwb1EbuBnS7Kqztx2EH9nqTGPi9s53CiiWM9Ffh5P0zUVJOLF/IwMRyIlbUByssIc5ZuGbdk3evxyhkO8b8765QT+ygXszPKUW9AfvWfyfbEcYSKjSzTE9ISZYrpMGgOKUPTfMXJc2I1nsTnXRf1DOYb2mr6/xDmt+xpNrXoIbwnE2tZso9hPXoq1xbgVv+FSLsgyWXPpheNguTbF9mbRqQl+D5aNqFJDQRtXAYWXQfrCEJiXG+pvYwHyeN56ncpIaB08/rkN2Mih5hL7RdP85jmRzTsluwOu61gUeOjXIoVAhrMOe/47XdgtuTBXjAZlEiwJQ/hzM4GER5vnFoBao9hmQgcbjjJZ601FuSnB1EChjSjR8y/8WI5W+jpPF/dJGMC58XIhlFA58B4GoCw9v5PJgCvRoJ2CgaIdK10ZkkxSPjs1NKn2DQxyNZmwb5iquS1wr33TYP92A3ByvXnd6RZGnnq7R+pXZm2qgM0xh29aP191A5ffsja5CoL4vZxVblMRlzuWyl0y51OQsXH0PzKIM11goRSMxl44q1bNGDIpnagB3jK+9hFYpzYBzPzWXabnDpeXnHiCn3fgTQxgArpgrOl+D8ylOOdx4t8x78zAtQeUkl5drqwaB7MRITmd7kBV/vBYCIsBZ0vy1WbBKn4HkQtHGQKAQ9zmZACKf4RYj/O8cc3ZYQjNhGxkYXLbfFe3AAZheowlgkAoKPPmSS9YCLLgMHGRHRjIx5izXsgT7ScJyye55F5JdhUJGG+CLa4n4q9yDl2PanEhAqRyDiLb2zqlKGmskB0ibHA3Qm/ODII3Z4hpTLsKzFAyWI1y5KHraaTDzthzi+YTiyh8M/OV8qPCOeFLzKFnqtW1og9Qif7F7m5NdGk
 +RkyrA/d
 KmQ/s00rJuPfx6XbNOI2zbAuMrw7gw/umMESvuk7Qx6o3nrilUmd6UKxNW5/fBcuaOes9mht8srqWebZju2NDbncDbYzlQluF9fT0YOJDqr+65CfCAmt2I2fTkZE2iQXJpN6UM6AmHFQbzFMJ2mRTHHXg45rnTdou50115E1CeeH83ZbAex3sk16xx2ZSnvGqFkShHwSmTnizEARd2sJ5HtlrjduQxL1jTNrTGzXH0TNsiPAkdgyh3RBjcHicXpQYTHaI2W6w91LEjfOmQGrWUUBRcvpwHJriuRIIvznKkov9KH3F+mPDFx4MqWQCB6905c+A5QRz3uW1fCEiJmSuYyoDC/tHbc/BTiVgHLmxPhbPrsM9vZ9Tk8VP++QeP0APtnRlDZdwI2fP0YmhayYPLkYD/GF/IFEELjrq68N6Do1fa8fckAyy5ag5zWwN5GRTj8Rs0Lv0fiZVX3uKoKqA/yD0KtBInTwFazRU2FX/U/9xvw9IHuf1Yl1ERksaQYUBgf2AxJUqjuQR8LzSEVyQ1Yyw9v1MJGRQEjziWSF8s7X/t9qRaOo29yMNj/QvtKAOjgLgr1+/jqQ9muZWjJS2l0twFEP1hqaLI+bu3yIHBCDsXlopeFvhueXbJx0gzMgz0efE5pI8Tt+gCuqwnLh95wPdU4ayIMDhceaas8L9r/VPVoqXTiP9+d89hfigfpaGovinyrlpX91PFhJkKAK2T7rg9jgHYD4NvhpItFJ/0XSND+78NAgLZyiNL6grLU7UrN4I6vQfxSJWUUcobqPifuPsOCu5hQhVEEU/abZn6eNdF8y5ixV3i3X7VYD4LqQjzIfAalx3oxHkuRAFoF9DMjmLLASfPlv82aytg7vKpKHpUcbdN9nb23goiArJIpP517dvmAZl1ezzf3XXdzrS600GoSAEizYktp57q55DGKtGb5KfME3RNSYBB6lKyrNGBuCydxjPNh0+axuVh4tzvKQAn1os
 o1BU2LMD
 JfpCFhXor0OY2Fz05yk8rl2tOPs8sRum6/k20R3f2CTbyjXU4IbuVC0a9D/I52SThJs883Pkn3GLhHjDy87QqhdpisYpafJ+uiT23GvkbncV7bhHaoTxvqHj9y/6OEF8ehmOgakAagAUnXwr5lNaLlO6ifr+3XHbVwVD+X99UtrmaDx7Rl7rB8QzyrA9sVg4CWBqazZwC2Fd4huCEXphhGB46AZHWwQw0rc7ckSY1yYasdshQbhTAZQHsyQSDau9XjAHZczUVlgd55HIC0BqknJXputYDjP5C24yQcvSupFaDK84UgMRbzX27upE7eu4jMZpfmIEHdyUC2n/xsnw3vCV66POLiyBRgICodt0QK+Q3P6OkIMgfIM/m2V20+3N2jQ9m6jGYbntgjXjeXipa7UDGcmSf2dw7Av8SIz/+aJHOdKuDGvpDZh4tJM/o6fZUzNsKYSKP3nMaYrKjZk3MGAvApdz5C60g7DI+CDlwoffP8dDrUe91n0oxUEG0MIUqG5f8Q25IZ4Yl7jW05MhjXyh5HIjHGvGyuGSV5ccYb+w2N7SQ8ULPwB9Qe45X2bGjB4ol/HTOI5hbPVpodbudt4FSOr5JIVXGcBiK4N+bgGWqyMSq1K5sz3NkYQWma04lDIo19qMf/ktwj7b+s/qm+3Y74xcrcVU6ouQ5O5kIq2u1fpJE/aI+T4Y5fHOTER+oZKR8nfinR2maOsPHnqzuPcp48KpxUMlTKb5i2UXVJYCoAHOiIPHzjddq9Id5zGdVYyXdQl0VZJpfCEE7nHebBgLT/SwwkAhgzQ//jT7kuNtrlZINg3BwmI0UJGLIELjmuqeNYNlmNPOkB52+aENgCx9Ms7DleKT6oyq4eZWpwLC6FHd4Rdg/6MSKLs19LZgcAXtlcXSuH/kCDvXVsCR0pIreCvM/MXJiVwAE3MPYuWItdnbt5LDf5hmL1vEBU/QdCW0TD2RdaWG8j0KuBYG/slTJo8VO
 YmsaZCRK
 yCUhrdF/DK9tH+76ubgbT/NEJ3LqaRxEOMFFDca5RP9JhFuep3vVsfZZ8rmIQiKqRlIW7WqZfIwqh5nHuzkJat5jW32kn2569CO1m7TtWBo4VKVOa5udC4GKwPdDDIu2XZX7/zpAa4Kv3/94qdJG59dfGEPZ4Roftp+DGjuzQAftkX5Y6/GW6fs8nAa42viek7rGzg0mIvpBnEV1kswdKrqMdIHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit d03eba99f5bf7cbc6e2fdde3b6fa36954ad58e09 ]

The type-check in min()/max() is there to stop unexpected results if a
negative value gets converted to a large unsigned value.  However it also
rejects 'unsigned int' v 'unsigned long' compares which are common and
never problematc.

Replace the 'same type' check with a 'same signedness' check.

The new test isn't itself a compile time error, so use static_assert() to
report the error and give a meaningful error message.

Due to the way builtin_choose_expr() works detecting the error in the
'non-constant' side (where static_assert() can be used) also detects
errors when the arguments are constant.

Link: https://lkml.kernel.org/r/fe7e6c542e094bfca655abcd323c1c98@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 60 ++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2a197f54fe05..8718fd71a793 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -12,9 +12,8 @@
  *
  * - avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - perform strict type-checking (to generate warnings instead of
- *   nasty runtime surprises). See the "unnecessary" pointer comparison
- *   in __typecheck().
+ * - perform signed v unsigned type-checking (to generate compile
+ *   errors instead of nasty runtime surprises).
  * - retain result as a constant expressions when called with only
  *   constant expressions (to avoid tripping VLA warnings in stack
  *   allocation usage).
@@ -22,23 +21,30 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-#define __no_side_effects(x, y) \
-		(__is_constexpr(x) && __is_constexpr(y))
+/* is_signed_type() isn't a constexpr for pointer types */
+#define __is_signed(x) 								\
+	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
+		is_signed_type(typeof(x)), 0)
 
-#define __safe_cmp(x, y) \
-		(__typecheck(x, y) && __no_side_effects(x, y))
+#define __types_ok(x, y) \
+	(__is_signed(x) == __is_signed(y))
 
-#define __cmp(x, y, op)	((x) op (y) ? (x) : (y))
+#define __cmp_op_min <
+#define __cmp_op_max >
 
-#define __cmp_once(x, y, unique_x, unique_y, op) ({	\
+#define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
+
+#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
 		typeof(x) unique_x = (x);		\
 		typeof(y) unique_y = (y);		\
-		__cmp(unique_x, unique_y, op); })
+		static_assert(__types_ok(x, y),		\
+			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+		__cmp(op, unique_x, unique_y); })
 
-#define __careful_cmp(x, y, op) \
-	__builtin_choose_expr(__safe_cmp(x, y), \
-		__cmp(x, y, op), \
-		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
+#define __careful_cmp(op, x, y)					\
+	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
+		__cmp(op, x, y),				\
+		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -47,17 +53,15 @@
 		typeof(val) unique_val = (val);				\
 		typeof(lo) unique_lo = (lo);				\
 		typeof(hi) unique_hi = (hi);				\
+		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+				(lo) <= (hi), true),					\
+			"clamp() low limit " #lo " greater than high limit " #hi);	\
+		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
 		__clamp(unique_val, unique_lo, unique_hi); })
 
-#define __clamp_input_check(lo, hi)					\
-        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
-                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
-
 #define __careful_clamp(val, lo, hi) ({					\
-	__clamp_input_check(lo, hi) +					\
-	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) && \
-			      __typecheck(hi, lo) && __is_constexpr(val) && \
-			      __is_constexpr(lo) && __is_constexpr(hi),	\
+	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
 		__clamp(val, lo, hi),					\
 		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
 			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
@@ -67,14 +71,14 @@
  * @x: first value
  * @y: second value
  */
-#define min(x, y)	__careful_cmp(x, y, <)
+#define min(x, y)	__careful_cmp(min, x, y)
 
 /**
  * max - return maximum of two values of the same or compatible types
  * @x: first value
  * @y: second value
  */
-#define max(x, y)	__careful_cmp(x, y, >)
+#define max(x, y)	__careful_cmp(max, x, y)
 
 /**
  * umin - return minimum of two non-negative values
@@ -83,7 +87,7 @@
  * @y: second value
  */
 #define umin(x, y)	\
-	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, <)
+	__careful_cmp(min, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
 /**
  * umax - return maximum of two non-negative values
@@ -91,7 +95,7 @@
  * @y: second value
  */
 #define umax(x, y)	\
-	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, >)
+	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
 /**
  * min3 - return minimum of three values
@@ -143,7 +147,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp((type)(x), (type)(y), <)
+#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -151,7 +155,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
+#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


