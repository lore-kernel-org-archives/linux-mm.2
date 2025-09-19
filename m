Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6125CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6FD68E014A; Fri, 19 Sep 2025 06:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1FCE8E0053; Fri, 19 Sep 2025 06:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0248E014A; Fri, 19 Sep 2025 06:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B857F8E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:33:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C5EF118466
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:33:04 +0000 (UTC)
X-FDA: 83905637088.29.A72FC44
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf21.hostedemail.com (Postfix) with ESMTP id 455E51C0006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:33:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=O7qKbSHh;
	spf=pass (imf21.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
	b=0uDiWTcYw/K2A9eOeieIxE7eBQ2fbvHmO3kYdvZNJZmvgOSd4LU4sTe2FyoLQyk2zclfvE
	JlRo1KPTOvFaqHslhU7hZ8ZS1DibLlQDPr+BJQWognoYHB0z4m53cSG6FQ0osGpoh20T8t
	2t2Zx5rB7glD3YGQt5u8/TkLx+KI8aQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277982; a=rsa-sha256;
	cv=none;
	b=Cx4b8zxVZoPK5hl3bJNPhpbfWMAR54sst73BYT2mcVx01RfPEIPrQt59cQPVlbzyqC4Ldy
	+/0gH1zkRlkVjUQ+UPyv/0+hPwIeXkziPv4jlTYZl85B2Y+U+GDCgsh90jA3a2mYPWB6oI
	zSJ/CiLTwIaHfXSE9Iz+VhGBtodh0Z8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=O7qKbSHh;
	spf=pass (imf21.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277982; x=1789813982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
  b=O7qKbSHhV3N8qZjaaDIXhMKr+5PN65DJGzbXbxi1aKn0ryYvaCvEGbP0
   70VcuEmtDOGo56ze6UJz/8syoUlJ47YZbAqDYwyXSbaYlM61nAfkc8dTS
   XtIr1IchEWjuN1sO/nA912/UKC6vPjHgYr62nkofoY6t9lf739PYQgEwY
   i3zz4Fc5dIv9gys+PS1cTPPloLhKvD7qldDyvl5+MEYxYYmQkPVfH5Alo
   gC0iHJDkEGhjf+8LyeF3P2TukTj3u0uX2MfSCe9tgnzwCkd5iiZ5fiUWk
   +jw7LLVEFgicbar0pOVubKz9aEC+PZAqI2Q2n+jKLt8+x+DNG0GhtQ17g
   w==;
X-CSE-ConnectionGUID: UW5gnmkdQTiXSYEIfmGLQQ==
X-CSE-MsgGUID: g8u952lXQ0CQOdRubqmsLw==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2264951"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:33:00 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:19477]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.212:2525] with esmtp (Farcaster)
 id 3cacb80e-2d3f-4963-bb11-96fbee5fabe1; Fri, 19 Sep 2025 10:33:00 +0000 (UTC)
X-Farcaster-Flow-ID: 3cacb80e-2d3f-4963-bb11-96fbee5fabe1
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:32:59 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:32:30 +0000
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
CC: <jonnyc@amazon.com>, Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe
	<axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Mateusz
 Guzik" <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH 26/27 5.10.y] minmax.h: simplify the variants of clamp()
Date: Fri, 19 Sep 2025 10:17:26 +0000
Message-ID: <20250919101727.16152-27-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 455E51C0006
X-Stat-Signature: qr4yis54szwsue5kx7cpo66irwgoznk7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758277982-649431
X-HE-Meta: U2FsdGVkX1/iQajtCRvhoDlKlePXjeFSOPdOE1eohzV0Z2DuLRg2jyPk9StsClxBjUQ4+LfUs0VFS7n8oxCbvVUvcSx8Yn7hMXE5srHeUIBk+5VxcZ4CSwH+TRJCfLfzFr5FICpfwasxk6Y79MQocKRrNO8tZcbCP8AFVldWkuZzDmwUcdaDsnPGn8YtjVo7zpqf0WCrkAM2uPf/hvyTGl0JTwrFPrDY222usC+aYeG36SYOoh4oX6KCHuOyYZ80EA2Hyud4Br711g8ANthBP0dWOJ/S3pxwemptTiiqGaX3CsgrMvLtmqkdD86TeF6F5a80BoHxJ1caxcza8G15bJcleAiBbQIwNqwnmXpGFQrMWcpdU2pv0S4+G9eD2XIvdoLW9QfO1BxZZJjnJhIzsGbou/QCWRoU7IJBmkhvbsQ/+3X6wcyAiLB2dpOi/2C3cNoWgKeXUsf27T6KdOA6zba0+iNJhOrtdwYw5+6WRGc2qOx1cXxvZ1PE2+MzK6sOQXSh2qqnMOPCmBU/nrvjnXmUmuQDv7tRe20I8jl5iLBdGx2FqmopNPY7iw0Du6HpPszUKfAN6Nt3Q+ZdJ2hcMlDjqbtg1VqrJKYMQW2nl5qpp5MXFCvP2FmHzTJ1TdLovbjVShQ1XGP/s3DcyRl0U1WoOqQNwX4a1i9Zr2myuryi2xad8+lsNIUA+XRRxAfk2CsclAPTci2UkqOKCD0Wkg9oEEsY1FH0iDp5/X5wYs+x8IlLS9sFnBsb050M3rQgAzwiF232gk0BD/OQWGXP5TjE2YjKSs7ZgK/gFmi/Euk1JI5ZNYrhbcXGxStQX1RfZgRqnaZBafvK45MaZhOg+J1TTfvJCWy/CEkbOWaMLHfIdwjkC99IbCLFESjR+VL9PSgDYV6JLQ4hTOHd/TeEP9NGk5fmmAIgwGAXaMyZ68OE4qGT5NgDml6+oVKaGWtjCzgbMJVq/VQSsnJG0/d
 1Yf6R0ko
 JSe/mFvHCIzWWRZk1aRa5Wpxgjyt4QeyDBl45Y/ikU7FU4YAxInvlKxV0GegnBg56rK78UQ+iVshMK932LnZKFWwS3L1pfX93RBnLEX2n9Q5HM3yuoHui/vHcSuFEsmIqyDB6+HqxPrgkGCNspHrGeKhIuhiQEceA94Q7ZsA7moQ50R2/XCQ5GrzomjR6oFoHG2geNfVS4OvLPJcnsfnT9li6gVZWyudRLfMmJxSQyS5+1ER3+cqj1aBj57/Q6dFeYTY8aVH1hGEAhdWCtcijUS3Owda6cgICPHW9OGmN4LpKDDUTGFM9tTv8ci80hRtgoErlJ2VMHHj9hzKyLXaA9uXj3eqACIFX02NkClmKB/WFBZgg7cTcqxx6DaBEv7g3w63sKlp0RgOPAfEiLVQ8j8PluzsCZQcCIdK5b80PBP3V5LaJ2f5o9NFJ7xk8P5JORxQoThQDb+ddY2SCQk8DrpMSAkz4BqjFZTPJlG1+DVsd7fR1lP55TfMdz4pwuTlMHD1EqYZN0FNqsQKztEinDbex0nJpYS16NS9d5Ku4C2uDHF4ItP1GbeqnHrD+RmudIQ/i52R7AsNby8I56gUrG9MOyOUKFJTf/eJ60MGJwqMBUvU7/HVlX/2toNXwVR3i1u2rzoEs0a2z3XdHYDS1HxUnyiPBghQ5JcxSPzvrbB0vnTZN/kckwq599humsa8HGxf+SJHoNKJpmvAbgPgNt9DTvffG3xI1gkdLQ3UYQ8MkGLY3SjvP4FQdjwoDEA3XH7jGVDuCwlSs7u0JMee2Gf0cFC/6I+gjUUjXNNmdDJEI3wHrINgvYfKfIpoMSDTYk0PQl43anG3UcJgkts+bkKyxUpV0/r7GZX1MvFLl8qDW0qfWllIKO7r8K1CcPF6OuABP6qrFuutAN7i6pe7pT01ZJtqRgIMKxMaZMAgx5lqOdov78WMGzNPh8rheG0PSQoPwbekPs8emgpZhZ0zF8DU1TZ43
 bgRxGKXv
 ZIPV20QqUmCGgP8VOWKQpkzy6xIZ/PgHyfGKKcPrvIx2AAGiEFcGJtMUACu+NWw2iL3YNuf5nFm3z4cPQ5u6X8a0TQRb9t29GikM/MX16blViXP+L5RsQwkSX+Tu5T2u5lI5ZRBvDt3clnow/Nz8mzjKFRarX4ZOGiAqxIdn2OTTX6MhEPAHKKYrF6l7pr0h2WwZn0P2Xg1P/F6W80MkA4KVemrnmMdDIMCNyDbDeWi+kGxALfSnMo0Wr45UtGugOa5FcfVgD9sRjthXEsaujZO4uiy4KMp7eiFwoIWd2nbDxTzpACtQxrWxmK1mpFJ9MaMpF/FLsZhOrGITHM5fweqqRA71ZQO824T3vo85vzJx0mT3X3oEX34xkmwJN4MPsnsbYzkacuFkjwKz/VPzX60TopBg9T9X6auagf6d+B8ADJM6a+SpBit11iPoVvBm2VMnyjwO2+1mMTDgZv2rHl0r2B3Lt1O9z/3FHUlBNcpc83wcvwfndXtXdipj5ytFfRjlxqC5cdUIYYpWxNhoiXtubaqBdZWjgE1fJJJfvqE4aTx2qMHukDFAe1mcSfyGstfQ5+IwmwhFS7J2rWjf7a9U3qXs9kIqUNN4wHgNBQedE4z9Liop5j+mBzd7TgZQjTjhzURdX1VMUMbYdBcSllb27h5eBqlODJwl0b5hfISfgBtxUSKgFTtjvnTeXNmNNkiKcbP5D61cgVSLJ96Mo3cz4wTSDcw2vojd3fnNXln10ZM16TXuV6i1ES6JzpUP0BKNV7MqX207WSvC975Hh3PHUNDhLsgva47aaI78aJawblV6MFUhNOyUC/T6VOPepTDgVwZKXfRFzO4iFm4s0GBMieENZWEsrrwlojx+0rJhqSIRCgAcJ0ysiGiwbZj6mmNTjZbsUcFURL1XmALh5QLo9Ip3s4CpXtHc7Pkq/E1mzF1o/Av/t0LbrrxxEuaC3xbSK56yPcMfu89GmFRuU9Ypf6GUJ
 4ALGl+zE
 aAd/QJIGDUJ70jhyQ3dt+Rohmu6gSolJF28yQIOoiZaJpeHg+29/lB5UqPVWudcpmlBa72IL2qBoM0yU6UhPnP4Ci2Bz5ovLMvz1t28en7YReiclDGdzxHA5pOYwR16MsGPJd6wi2BIQ7e8YrKHk9t0WBYfrXYSN7+/o5FpwRYHxH3ngu8a2iI7v4zxapX4msXKiNzdbfZylYGH0Xgmy/Vx/fGKjjWpqVgSDPC7XLK//iXh61wcNBAsG99ibP4Mt/gWSJqzGZr541N1bYMnw0cU2iij2ZJ0ktMChIZZBGsSlx5GTQKgd53L+aNZGxMtoulUlFwripqPVuGutQkeqdkOB7NtczzMvjBtX6dVoET1fIwEPENFADF17rcXgQIXlnHB++VJnKNd8MliDO9AZvSM2ia2PDeADbiVsURdMGWAZUvIdyiUQ6H+aeoKpfRnc8i9JNcrY4J/4/vhcFuL8K22unFmpe/4PKIAwDPywViWqUIyDEID/HeuuDce506iuUVZ+l3ZcqAXzwHG9cAuEBaz1d1qpoqeD04V/e/AMJeZbgEdo96IdL6L9qiv08qvIIon9GghGTfGl63S+6HCHPOrN+nQhgIrn8SxTJ7p4xFEHIEjkAeD2bIEqZfg1363nD8mSVpz6JPYOTLRQXQwCZR7ulHN5FRe2yqjmyMuAgd45pBLAEaPRNSnWYw9FvTbhl3+TdM2DntdkARnjP+B3uwXrQ7Pso3REQlPcR8hUPfGou5688CAwFVLywMOQrUcBT6/ZBT/5JrTsbd4t3S3UN34/1XU28d2HZL+Pft34IOO6RNnytlvFfhm6H/XyI5oC8m/QBFuQ7ImmUvh1Y7lz6Ckc0IfngRSI+ANBxX5J4Iiy0P6v3+haztwL/pPn8t2zd6GUM0IxZJL8ZoKk9dByJE6aOIUnIZCm2+yFpCRjsRCg04w28ztZt2L1u2GtMvl/H2vZ+pMqIlD7YMBhVFt9/tVftKjoX
 GlVsSZqn
 IudywZmO/I9IFvd2QBURMhd6hNL5PH/e3HURlob0D/tc4uDR1PW7k/E0nZekRD5I7filcoWJv9LK6LB7zvszHQ8fMNYdO5Lj9e2AYVDuFnf503kVlmwdpCnCBSgA3O8KVTYO73bVD0UeLUIeKjr08FFl9ldvEEWHh7yuzFeprhYGqu/PfFiEuWIo5JnCpthYoWJobNqYf7sISeb7ugUT1lPnGGQfaH/96bPcPLYRz6ZutI/IJ0NEe1lXmr6rOqc2RBvzL3Z4/AFwBKbYYNB5pHtWfqScWgv3SQstVOzY2RICexLxVp1lOp0PsDEEw9hkC+URL3B/zIDT4DbAsncjgOHFHc9mQKn8v/DkYAsQJoSa/1qm/coIo2lMWMIp1+jWzcUZXfcdyk9EafmVaBikiLNgfglpmuz8gVfUTfHemPqlmqfurMJL+uLVCC1qhC0OdIItzVaGFaQTTvtmp86jbALAnhUTN7rvFaMsgBDwU+MqnsXD5cKl8bmqleAIIyiPdoeFP9NW1QDjKQDxIFvXSJjyAWl0k63N+kWtz98N/uNZzqJbl+G8tG0X/y7YngheVPyakhq2KP4CpCEUcT05QvCpCnDyIcMGcdPkZSmmG1Bpp1jAqPzuvi9cYpqcHp6W2roFQO1zmYLOgC5Ff92mhKe7kdoyM0tT1KeJ1Twn+UxdRMIpBbpLdcUlAduAphrLGEoVHpaJ5GZo4xlNmSI4UatjT/yDxEyUGNogNT/a53uG4ZIe9+r2oUFUHG3sDe/EnniF1UeUIw/bS6fAXAjRW4R5ZDGs+KOGduMr+nQ6f2yIdHFd1rCnMNMBl1jKisyOWiDD2nc+nB9lv5AoPMLGRv/MfQYeCl4rS/CvZZ9czLZfY2Nx2MVI2e242DVn8qSe7xg8/5f10BBI1vBtppb0MYSRlHNb3Cak0RZlMvc5I62UPACj/XKTZNxvcAulvZaXTVSh6Yh1hZgiveOmmtP4wz5JPvjUG
 tZ9nHM7e
 4kmqpDNAzln5ms1s37WxeEsApOuQ060jQ9rGwSuPyIqCv17wSpcX0wSdRwu7xAoZTYoKodAhbMaVpHsbn88mqSmccURmx7oLmuEKO5xwbVYbylSZB4sfEJlLaTnYe6BZedMa9Ctt0petPMGbWXjh/AcX+mx+h0VdoX96MMEVVLv6PLnumI+rd1w0zVmpOLpu6tRNuX0qfJANTJXo94pZZAezpBFWq+E0xwR5la90J3/e1m1bbfVdrVRpulb+qo3cNLt9DdCEmfDsCCcHGboFveaUTn1ytkj/VBOeGVpBw0fZHl/66tW0kG9WUOh0xYlzyKZ322KzxE/Mx7+WLp5kOIpTeapXxlZ0hrK0D1dPNQpv1oD8ZqSoF6POKrFrVhXNpXh4MGFcc7q5CPFmzEl7h4nAcVro=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 495bba17cdf95e9703af1b8ef773c55ef0dfe703 ]

Always pass a 'type' through to __clamp_once(), pass '__auto_type' from
clamp() itself.

The expansion of __types_ok3() is reasonable so it isn't worth the added
complexity of avoiding it when a fixed type is used for all three values.

Link: https://lkml.kernel.org/r/8f69f4deac014f558bab186444bac2e8@AcuMS.aculab.com
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
 include/linux/minmax.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 75fb7a6ad4c6..2bbdd5b5e07e 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -183,29 +183,29 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
+#define __clamp_once(type, val, lo, hi, uval, ulo, uhi) ({			\
+	type uval = (val);							\
+	type ulo = (lo);							\
+	type uhi = (hi);							\
 	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+#define __careful_clamp(type, val, lo, hi) \
+	__clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
- * clamp - return a value clamped to a given range with strict typechecking
+ * clamp - return a value clamped to a given range with typechecking
  * @val: current value
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of @lo/@hi to make sure they are of the
- * same type as @val.  See the unnecessary pointer comparisons.
+ * This macro checks @val/@lo/@hi to make sure they have compatible
+ * signedness.
  */
-#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
+#define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -217,7 +217,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
+#define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -230,7 +230,7 @@
  * type and @lo and @hi are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
+#define clamp_val(val, lo, hi) __careful_clamp(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


