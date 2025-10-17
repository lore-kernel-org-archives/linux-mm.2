Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6C42CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE2D8E0070; Fri, 17 Oct 2025 05:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F318E0016; Fri, 17 Oct 2025 05:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F678E0070; Fri, 17 Oct 2025 05:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23D4D8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:13:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F17DC883B3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:13:13 +0000 (UTC)
X-FDA: 84007042266.29.FEBD4EF
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf30.hostedemail.com (Postfix) with ESMTP id C2CC180003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:13:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VoHaAnsX;
	spf=pass (imf30.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692392; a=rsa-sha256;
	cv=none;
	b=F+R3/q0x5FudOPTurbnQtFWkxqJuypfo4LI9RgO28++a5L+u2IsKklTrn8YGmTsVCCdw6w
	5xQiZhv5AJujKxydf9WuOsjQydYTtnEYdvkiHh86dRkVgzH0ndA0Yb7x0y814gsFroGpQg
	0fVIo25B77pwAE4sw2Jf06+vGJh7Tj8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VoHaAnsX;
	spf=pass (imf30.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
	b=BEQxnhvz10oVJRmAEWNKzqT2MPMqHAzKw2d4G5Ki5UmgpENI3tDlMcIFjUv0+5JNkX11/r
	uH79LYuQ5xAzMSj0iWxBv/OblndniezlMuVUClJdHoWV9W7CPE/8z9Z6NItuaQg302IGgZ
	eadxhJYsXpaEJ1WYdZAZa5vaY173v+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692391; x=1792228391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
  b=VoHaAnsX7y0HB7Pav+nDpeIRnYWSzMUFbnIo4g8CFnDRljA8pC7Ug3LV
   vnwF2oKZ1giGkdwDklxuUImaucODruwZuLwqRGoT2RGEMSr1jyYw2wrKO
   tClCOoQuNKqS7MTp+3G5uUTtazZL1g6bUSXk62Im9AQE+30KM8zZOiEbI
   ILJ3xXaCfbPlUL3yEz2KfG7e9JkDyO+tQW2XrAh0cTkahF5sv7V7X2ebN
   NEGMhIcaKqlnyho6e/lVGRzRshB0hra59jherG/O+eNMUHbIrbHbAaaIl
   cIEq3ysUyGG7xfBK364ga75RU56ZSj1flpYICIPo78yp1w3Q3wu4W+UjX
   A==;
X-CSE-ConnectionGUID: xtWmMqzjRzODYPTmSLiGLQ==
X-CSE-MsgGUID: adC3aNcQTcygthFfz5NDYA==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="5074282"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:13:10 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:5724]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.42.150:2525] with esmtp (Farcaster)
 id 3b05bf4a-43bd-419e-989e-7c540a4ebabf; Fri, 17 Oct 2025 09:13:10 +0000 (UTC)
X-Farcaster-Flow-ID: 3b05bf4a-43bd-419e-989e-7c540a4ebabf
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:13:10 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:12:54 +0000
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
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe <axboe@kernel.dk>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik
	<mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH v2 24/27 5.10.y] minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Fri, 17 Oct 2025 09:05:16 +0000
Message-ID: <20251017090519.46992-25-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Stat-Signature: yi4oejr1aws4wjzb9pqzke6d6bdigmjf
X-Rspamd-Queue-Id: C2CC180003
X-Rspamd-Server: rspam09
X-HE-Tag: 1760692391-898770
X-HE-Meta: U2FsdGVkX1+Rl5LHI5qhMvVRES/DJ8nv2PFYrky+/GTWzr3t4Nh24LVQARc8kB/1YqYnk1/z9wUnbNCvNLthy/UQg4rrZtWrbP6NWWC+adNgxtN9AaFW1l9sbQvHfwTp7ySALwRy8QcPyjh/eQ3GGnKq4jcYO4xzM7rz6ZORVoIzbs1or6Cd7sW1zzbDv4D5Lxz7wTVhb8oJ3/X80UHCckqXmThl5duAu8ieH7jKd6KWsxdLoyRxmDHlEi8qFCWXcq/D2bGtWBiaNDOxweQAJorf7DnA3X6f86IQYvND8d10owIUwc1helACghzJhQEBysIiKNirkcuNX4lqB8mq8Q+ldkNzio/9PeTdx43J9vBWmvfXunRHURThptNXL4MmKM+JDiDgqaR41AgcRUTCzhD1IVHQHg5TarjjHWrQrzHACQhkxcBihOuSSpuD5qNL0A5dKNdptdRtYqyKY+MY8f03SPmKwe/RikdAxVzLnSyel/jreZw+NqMkohWHujVJXBGepgsBU4F4Vzr4619msqEOrLhRG4fqo5cqnZlxysirA7mdsqeT94aPGAj8bYsyYtoLFYmott1B1gNTN5lnREYnX2VTNGf/cJqqYvmRwzF8WF87oSK2RBXpcmLbtAuXfNHDiEGeL7GIG0YqD4/BMZG/MsYJa7f5ah2G6RRl95v2M5+RYlav+L6Oq8outxLA0xnXZEoVWjfLcsjfzBVKpHHDTOItATl4f0UO9qfJoykRmpJdQBkdpu3iSJb91xu3twt+ojIszfxwgNDdQP0izAnFlykby29C9LTNJi3JwVGPNP3pGXh7UdYRI/LWmUEiaETaSjC6V1OXUIRajkPZumhyn3bhLTYiLdrp6ONK8amDC7ol7IoaocoRbT5iQg7CZpbmCNOKGP9/b3YYta2jq4yORCojyDmGQvzEbrnVBzF9/2pwNzimQjQItvHcwTC0aidNtZmdIW1j7+2h+Fm
 F6DqqkPM
 eyyaYsp8FBTIMT/WY35d5pAtKQKYOJnNCVVh7HbSsS9u0hexAV2sLpiXhQm7MtTcjy4H2PDgsdH67jjejfPCjFnS3fNciN3oKFA/fYwATD6S4IRiAEcfvxKj7hGhVWPgrlL401zD12d1Y5g5EhKSy7cV832W2ITaerDc1JwiZs67Us8juGAn0hmVFjPNUAKsgefVFh6A+egLaXR+obptruzLBU9pyEGBLaj6BnbERN7tQsRrzhM/syhFMU/WnUgAusz/elbcl2JSIDMdtlgwt0h722VIL4ziuK+w1WKwuFYYoII+vRtWZzp2fKDTX+2bffnQnnqeCusPulBtTqHYVpDiu0W7BLgcDgBKKLQFy0IY3eF4EmbI3QZ6bPl7buf0lb1HLkLkPSXtCmt2qs59GUYCOg4namRJcSMj6iAiAvjZOciVI8HUOWg+OxZ3cfnyxU4xqKTQfVbK5boeCvbaG1yEcpGh/LlAJTPzuNWnXDf9hiBVPXHy+/MTvFeC6RWyuVpBKPWdX94OHDc1/ux6GmNKdmVutrlwEpV4TqdFs2rkUgLGX8xly6RzkGmeh7Ciq7FZYmgIYnUXMwxpPYlGt1lJtUvSRfvXHBe86aAdqYo4L6eiFjKslw/hcySCwhg35Ksuo1QwuPh/eRtkK6pOGoqliDNqQYWeH8tn/5nRAoLfbkdSUkzNSZ2O5T5v9BoNPJN+8YuAY7l2Y8oRnlqKUtk8eR8PvjKmGyxzaQpr6s0OMZZFbh6u4sniel+wzGcjTotaEbOFP7/XUWajTxbnjSzJjVQUm2YQXoftEXFHwUtxVYBMNgRsweglwI1d7+YS4dz1JOahiggnqLGONJRnbSZ6xbq3NAk8Bym7EnFsV1Zwt/gbWtsRvv0YHR0EaEZm+k8xb5VUcjgum8i1czwJA+m9epNGTgxDiLPuv3KpgWeMB2xITvkRoJpHiEk3wMOGw89HG/9bIO86BYmUyfqgQ9jBRezj/
 gnn4cTdc
 ac4DWDwxMwbnYSGM/4+BoaZYBgPR0uL/fG6XIt4ejimcUkAPy+DgXjb+kDGhtGT0f6DOn/S4jSEr6XC+Ogwd4TyV4MyDxJ0ki5js9ggoUOdBe/wvnLujJ4g9Tpck93z9zgZ/6AWVxR33U2EUsQo+CSUeQs/c9+35Wn0ZosX54FMBLFU031wE/rpnceUcHCduJA0Xky/WsCPsNFmiJ0ANodrvZTfrwm1FYsT66cbPHXHiS0U/DNrZ3WLXKrwgn+mNkgC8R5pgl4k2c/ZzmdUtrT2hZUC8ZIz5MmuEHoesYhKOK7E9JqpkFM6eCk/Qye1RjeIMWcAD3WaitzcWgWMtU+SY/tIw93R1CyRPvGN2XpNC4kRNmlsjc02614J/40TOKW59PTLrMJLemDEFGBGU8vrnZnSnZwO5nmSuIt96KSALR6O+uSNNwANqJ1N7PSgEk8iQ6x9fp7qGeUspzavjbXfzjHJJxYtKBttGvwhZD3H2Xz27vLHcdXNTaxFRLZ+VBvxzq/TvIFupLPy2K8J91bJejtrnfUaR7kJPfkVIm39af9gS135rYUnqKUGiuTrs3tI78Q+2ZYeWxjxOtgaoSlJI47yNZlyz8i8fpzZSuknXGLElCJoF0BG3qHd2QG9clAlmwErPJL/TlwiOVxiIs5mw22DhzgXRjfc8Fa4/QOAFmuPiGWYe1qp8+lPkXpF9TDPNIsef3wLDJVZG4CNZqY+QCIzmvJ6SZ+WhrhMGs4y3rRzhvxqA9S7t2sycXtZFkqU7lmjC73cr3qymdV+p5IzAGaYmRBlzi+GFOrJ0KYEidv9vEatHrkyOvojfrwzA6IuvNZ4zsnZ0Jxb92ZrUTb/6dawSCOZgPwXMovO7csmFtqzG+0S1Mpucc5yTikRPW7iemzbQnVrAcA3nI80andGbHBumgZ3md7NxBZkzugVsAFYXHb8hxY+bQ0nKnfvK0RTr/Vs36PvcN7EFx49ozSX0lgZNp
 t7CKAQ17
 YHXgMkW8DOTmKcMb4jSeEd5TqvpUjeuz5qFdUWWlRfkFYySQh/Gymzv0BV8u0E1jDcPx0B/cD/1t4C+Bjr4cxT/7zs7Ssw7oO9maxKLBUdJP0MI9TFQfMOjtzHeMzuu0aI4bW9o3Z7onBYOkDspCRnAzX9hNMSb5eEbcSLKkeFTXE/OeXw5PHmmlhbYXvTxhTQJuamAbPGusYiNRAi24URYjWFvlvMAt+yCH3KsN50pThVLUPQYcEnjbgPS09h/FxyV1EMZgv6mWc10EgN5Aj/vWjAk2Vu6Bh3s6MtL0yuR2WlHBi+htMEn5piAlqbjkstWLFtaSQuUBHfcyhqqpWdvzSvhgjUluxy43G2AzhHLvXrlTleLlZa+LYQATv+RS2/V6YXSjH99jmnsyDzA8NaOquNDGe9rwiXX1y0Dq2E12bBpGKJiYjHI8zqXFuLYM7zhBp5c7DzF8TerOCai+d15z9ONKbndW4IXHJFfIH4KqgCoWKMQil2qNn4f9SJz3lQMrXYM4eUJheiavFLWN7bE5wR2jJYRMdxhlIp8aExUVQdFjju1Sk97HDMpRUS0Bs7oZcWwLkiZhGnIXEDYq5qVyPFxJ+GzMYA1a/T+SKayMMwQwF/u9pfwCEAXkDS2mxMzPqfb1T4M57bko8gNQQ5G2UOCufJGkOaDyitL+3LgUU4OGLadbi6pUUoGaGhLScUZlNRGHHJ89glirfqNRSwbctM6UAvoz8a+8WytL0/Qn9DNIsmvGvkNHhK37+vqugjE8q4C3VNKc+c18HSA1QDjwzRhOkugqoEO7W97VAiyQca9SnuJJbNIANVh/xS6wi8hdKF+6qfjDos3hoO8l4KEqR1O9FnK8EUkWYyyDWfzZ6uMdpXyPMh1v7DfYWpHlkjU46UAqAp4fSOIAewPyPHykFLzw+qH1fw9b3p36JX7X3fICqLArxQwgfiqjlNou+tPAISUPcsSgjKdQ7E9tZFlyHe4q2
 kR5VcWc0
 bpdLcM83AXPKkr74Ub5VknTTYXmCmQUcrhys6vD7kUuDV/pPKvXEvLAxdje75D/YNB4OXcF5cUyeUd1b2yCm/cx8rIHWbGiazsg9oLIsOS3lcRmJC/j0jWSxQL7m2WfBqK0mnBOKFGlWEKmnVEtvUlfeCWRnNQsK7jjBDxW9zsLh96jrinV84qKwMdD1k35xFfFZWG/vzqYPM73VzrSrJ7eWpF8YrKeKO/Oj4MJhGEPo3OfgnCNWu+LlDPkzLrobxwp14slLoT9lH/6DGbf12LMyw+n/l2CKyBe/dMMetJbj1xperzJdybcSnqlfDLqFryGy1H3dotE1qsvPBPbXpz/hWXZyfeTpPMh7+EA+9oxaFQD4+Pc6ZbuN+yxt0PgM3TxJqk8oVXCSB1o+VuonFC2cvvXzwqvZQOYUwpeWYA77rRiYBzyAOsL9RBX1pyLbsDWgpNnV7a8tZGMjxigE86sSiApj4l258W7FXAVcLUaA+hdcxwxaMl97F26WxFITj0TMa6aV0UI4O8G3HuM1ewY0ccKRb3ctzascAZVAUVkb6EsOC8mbWB0ryhT4l4hDpLZIQu4xatIgowWc6eHEOIjJY8lAfL8V6VK8EdKE1kBqX8RV3F0RB8yNL7jdSV/45+UX9DJIREFfkZdvLlu4f3lFe9VIBRsmEK0SXAPDSU5bI28516mOiuzMoMfMZVQLilN2V8I0EtzYqI5nhTLrLZGaApPeawk1NCwnzhwu+ptwqymzofxInmFmtDh23GaDH+0s0z1X9BHVdkgbPCd6TuKUlpY6LB+2BX4L1whZPe2FHfBkTGjPGSwbb6+l3Al565PmAql7/krLHbbFDoCUZHXoSLUy9gMVIY3KwUWVbAzxREj53GoSCiR6Dw2LNFXrdzOnGn56AF1OAQs2x4ErZ3rHenFz0taFqaP0RXuKU4bSxoTjkWc0hlF72D3hg3cIljsXVtjwJKhypYg0R3gZ5kurt1mkU
 k4neUvVa
 FjXbK+SQf5p3PDs+R6ejWkb2cxMbYiFnqQGtRnsdK1ziWLu4Nw4BPN3LrogpXY+4z+ZlECq2LY+VabyHLG8SawrTWJJ/4Uppg1LGkeeOO9b3EInirTRjZCwXjL8Nc3LbBJAmujeFCBKatqLdd+S6XAPx5v/VR3Yr2dpp2irTt+kBYXdOhdnaSiVuHIo3Fo+lSR+5T9ZF+wGSj3UcbMYCHI6MVOUk6XpNKN8Rr1yyT06RCBej2/kdtkwCzie8hXQ0G10euBCR9fZIELPZH5wUS4vSVNpdNkV6P+UUiWSWQfRCGC88P7XH6IevDrbobiOlLj7hA++5pSAO75z4LVy2nVwpB525LA/HHH0D5Lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit a5743f32baec4728711bbc01d6ac2b33d4c67040 ]

Use BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...) for the sanity check
of the bounds in clamp().  Gives better error coverage and one less
expansion of the arguments.

Link: https://lkml.kernel.org/r/34d53778977747f19cce2abb287bb3e6@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 6f7ea669d305..91aa1b90c1bb 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -106,8 +106,7 @@
 	__auto_type uval = (val);						\
 	__auto_type ulo = (lo);							\
 	__auto_type uhi = (hi);							\
-	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-			(lo) <= (hi), true),					\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
-- 
2.47.3


