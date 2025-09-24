Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B112ECAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1804B8E0019; Wed, 24 Sep 2025 16:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130CA8E0001; Wed, 24 Sep 2025 16:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F137C8E0019; Wed, 24 Sep 2025 16:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF1CD8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:35:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE5AE160110
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:35:34 +0000 (UTC)
X-FDA: 83925299388.26.6ECD4AA
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66F55C0011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:35:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sjelxazu;
	spf=pass (imf10.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
	b=GmkXh2m1MAgObwD3CbmArMonudWVeUAYeEs9X9PFkK3zg3MX43quhnke2UvzqSxcx32/e8
	zkldrj29kVSLZym2CnjfQFJpcnj8Z7wk3KnIktaK0brteaJLAvhud1ZQ6Zaz/Y6wDsEngR
	geuY9E2kSwuB/d3r9cucVOxiOr3uYzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746132; a=rsa-sha256;
	cv=none;
	b=Dl8LgE0Bz+JEEjq2XAXzEMkeI/Tza+FJZCVyd0kxHdaExLbMUyErFipRPy9xDvmhBu8dTk
	P5MgDbpKBuZlIxfd4F8eaqlOSrh860atJ6CsF2I7cruF+CnywJ62AyoZbuka5yS8TdM/U7
	bPmrxnVGT+Ayx2uMZfVxKtcaPZw48P0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sjelxazu;
	spf=pass (imf10.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758746132; x=1790282132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
  b=sjelxazuMduAoqeOmD2qUa2AK5gAbtzjXRESH93u6wgGGPP9CDF3dcC2
   umalIRQHilQxr55uH2+hevVoZHu2FjD4HoErI5ZnuEAqfHEduDtcMQ5lt
   iggkXEJJpwRCR4aEcW/ULTJT+31RuJASnQF3ZBgr2M7bH3imWMneuSc76
   w18hyIexoJSAUuqMAZL02doA1mRE87mwkC4ipFRKAhtTVO9juIejcxVas
   zJbsZl9unpJgQsoVET9CZH70jAFiWFFD0e++U256aLn9oeveJ+IKX4BqK
   Zit6OD8Aj2z4DPLjh37rP7WiTi9pEMIyfuM9jqz+d87E3Bi+l43I02r2E
   w==;
X-CSE-ConnectionGUID: ToxvtjMyTCarFsA66CsNiA==
X-CSE-MsgGUID: z4xIFYWWSAWkvhUV3xnrmA==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2630518"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:35:30 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:1267]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.27.71:2525] with esmtp (Farcaster)
 id db857eee-f23d-49bd-bfe5-35f55c14c51b; Wed, 24 Sep 2025 20:35:30 +0000 (UTC)
X-Farcaster-Flow-ID: db857eee-f23d-49bd-bfe5-35f55c14c51b
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:35:18 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:34:42 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>,
	<hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>,
	<mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>,
	<harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>,
	<dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <peppe.cavallaro@st.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<pmladek@suse.com>, <senozhatsky@chromium.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>,
	<yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>,
	<kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>,
	<song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
	<kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
	<jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>,
	<wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>,
	<sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<stable@vger.kernel.org>
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro
 Falcato" <pedro.falcato@gmail.com>
Subject: [PATCH 17/19 v6.1.y] minmax.h: move all the clamp() definitions after the min/max() ones
Date: Wed, 24 Sep 2025 20:23:18 +0000
Message-ID: <20250924202320.32333-18-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66F55C0011
X-Stat-Signature: bzb755z7rxxya7ygmqdabzk66b5hoqux
X-Rspam-User: 
X-HE-Tag: 1758746132-890200
X-HE-Meta: U2FsdGVkX1/xIQP4r4UceSSe9231Em63PUmRblL+uuhCCbIfWuy19pCJnKMFqiRaI8aFfUX99EUTaRi6wenl9VOuQLv1pv+wPFrPBOP7veP8MtLH6fnmiUjgZfnaONPq9baYSCZ3Vl2ucygISoK11HQr/01V5GsKJ3lmNdpAgFnexR8Z8SFHhJJq+zFW5P3JikDLP2x8kywDVP4Sh8GIZCdXoyCT0+i1yTeQ+F7WoaB/XqneDnsJXxM0weA+lgvNAiu+0yjrzF8CwI8HZN+5BpzHorIgiMfUBZXgW0vg6P7DtvYxR4pj6IOMPWaQPMD/g1/cIWbrdeBNyfadvlVht3hi4Kve1WdpR+HtDYBURXW9CkXlMfVA2p9y378hwoXedBQSK5KV4Dg46CE9YYGWKiCaHzK6gogFW1Tx/EF4C4AWG+XVVNTGGt794E/TpLDR8QoZgdPZi1TgkaUwxjDnRgkPkNo8W1k2rjKcja1Qufyr7Sx4W8AKVh94PmN7Uj+er9H1lQs1Ks96n8XQtObXtFY0aDtAsizyNxthnCjOeXXPOG2upE0gQugL1t/KL1+Wk74/9VikQI6YXzTve+B58HjQ64bkPSbZZCDBz2A4DRAq72L9e+kkPYSkfqxJ/8RU9v6N9ITmnqeVFjmmdXYyO3jHWnV/+JXkYvmAWIj5JU0GQ2p7UwEcBXpJh4PgSn3iwq1hs89g9B3GuvWuqrBDKVA9BeSCyNXbZmsiQuLcNVypfQQSbauW00C/yz8kDopzoKR2wiw3/VTtVagAgx1KIFDhBWhnWgKZzXA+Vtmb//ywOz099/zbAhIz2DhYAJLehCbsvnnMzDiOObVlPLlXdjBpd0yXYzzUsfsZfmCZVAu8fYDHNaimdrFJ90KiLS2Sq+YNy2R+Tfbh17lAZFq6ojX4nFZzS8x7BYrxkXyNtBdZYA9PcJy3fJD0KVQwUHKR3t8YYdjQuiFVU7mmszC
 9K3ZQV9X
 NzZi9kceqz7bPgNEwsPDiaAEjeNqfdfSTWgBPUzdzzLEU2V3+wnFMQB8YGweFlTcimFxQaGlT1AUgjCFsaWIJlFvbl7hSdWdwzX+T3OKrisYT3ax5v5IqEqIGr+YlNN2gtqalTixQYomdSngEHdd+5lkKR0ueqOTAxckQ4HWbePxN0Eq4BQ8txqjSVY1Q298ydhfafTqctK1WJHYj0eRsT4dzgJ3xIWEls0BOHLzQd68EcM5N8jX58Mnpua4eSs6z2n5tb3Wt+J+DEl9QI9sFFI4DN1/PLTZLTtVd6wl4/5Pb2o9VkpfQT3vCrcJSSgEGnZnyYU7TKuCx2ZMD3jozsFleBtnQSIbyLi58jFNa7R8TUDYAQ0oSuhpz9oSSVMXlUGVkcQzDU09QSriBraWGrq/wpdl37k02Qh8ZbalaAIyOuiw7U/DrrNGzJyuey5svaBkQBnjwcGJ8coK/67CJzwIDXRhoC22oyNKIKIQDdJd1shxCv3Hi8E2yT3WqF3Edt6sC8Cje/WdFy3/1CMcrbauBrzxEytFqRXa5DlO3RuiTuCa3f/toPv8QM5/K/TyulsdYqexVqhPtWyMom/w4vicoB9K/0o6o6r0cJdaZMlUp/T+KNpZqCnM3hM/s12B6YxukD7X2a/q97gl7HgknXZXk8xR394e67Se7d7qWMPtX+H8w8ZoE6EhvqtFq+uIpvs/sMYNgZa2fln9Zbo/+J6gmNTo5VFUWBzVeiFjCxdT8ugVZFVpzrvJ8YJCFsjove+w2/qllsgmIiAEoZzSQVppLxF55pNbyBOwFGcmnnFzBipcjf2IghBeiTXdxaQV87wo3lq3PerpH2GX95KXQDp+9JeW1zNC3OcTlNbZQPaMchDXoECzL9b8JYcK39bPbf6L7oOGXs4dDZuRJ0chQiSR+gODkC/oSSl3l8BvEIPRovK86NKCGSUZRevQR62Qfq76opHPdoRuKGRu1ku3nwtErdMIG
 h8tuA9sU
 D8tAr81AoBqlMfnaWq0I9CfYMKlhz7as2xwTJ43Mec9mBAvbBQKDuF4nI11iHesrb7b+esKGOjOjQcKd64txwcMLKZFpQYRw4nc75enBh9HHxMvqKsAuSn8jjfUA6mpi62TfnRbKaG3p4rUykpbF2KOshxqUwrULya1ML7EwD1786RJwH90nWroKHKCrPev5xu10g4evpSWZBuqxAW+11Zo7ACrAlVnDIrgu6lwHf1oh8RssXP2GVzgKDaFumiDtcEdTHDa+u4o3lCEA8L2wc0D5ZhvqwF08EXRB0PzlaO9s/+XCUAaLq5FDmYsRkpw6ufwTPQzhcR2/JHOmz7HcTZDHOxDz8mztGobRIHJiQCX51EpXBcYkv1buAdhd7ejEi3yOz1robm4cHLEXmSfopUFukUdIZj0osDaFYifa3zRC7W1XIprNS70yohY78KxLhkVUxK7o3AyS1SDW8S7eSsX0iZA+NEsW2h1QEbqfv+bwGUkFBijTk/y1oIaVc9Vt/fdpfoldIY7hJDCjQmWWYG/QO5/kidZWtzMZRl89srimbuI36hwkpBdAbtpzpVVVIo9hjp8z6mVTuP+/hjMNdBPikRE8eT2/9mK+K4+Pdx4Kays8mJdNvWPXp2R0qbHw1+tOWge/Bc6zsP05meI9l/eXtEqM/wb0KU6sDeaOW6Ic1OpKSuUOxabWzkN2L61G1AudL7Fhfihh5JnoESkxbJzK4z4Xagm+a4UU9khFr3IjqC+FLCYgOOz/pYSlenrnyPSyr1EgmxayIdiUlgqzEITcJv8hKqOkNaTwaNNFjvIXhzkx2okpUcOAdktd81DEAYjOIMbSTujQGYjA+JctUPeaFjoH89XqFBNNL3R8jTHeLKT6e7HbtsWc9lkdDgwv7a94gTp5bC9nYq4nZBFn7Ivrh0qx8JkI0rQKmgfP/IhAKOmOdNJ/HheIEjV59EICP6K/cCuvi2b0079wnPp8sXEzo9jyK
 f4F44lvJ
 MluSy//IrZdKx+cZny2du7pplYv1WZD/g6hmviwgY7FAfWowZmheVT1Nq0SjWZzcXDm4eQV7QhsnU2kwRgRLU2C87M0s09sOFuUs0guhHgagWd9o71bXDegeQnA2h3giuGGuxlQqDRJDkZPRD3kQOKhn8KGrhREP/pcq7u1lwuw0qhHdsR1hlhCOq/TDF4FTc9FcNx9JKXh9z7Y55qBHLP+faNMybAO+Ny3mkhdvh/q+1gIz2o5rWfgOX1CuUq0J0VWUVWZT7QeIpqBL3xknOdomfaDMUlorFL60h9H3y/dhCHUxQrK0ah63neQ28Qh6KTDx06GWdzF/fzmhkRpQERfDFIl+pT28tNue/CijjDSFvuWWRmKOZyutUTHIFYmFkdzVYDB66pBE20fSruu38kHi55r7957mRH1SSgXKYJQ2as766//KepN+RxrJ1+4LTgc2qkro7cIL8b64ZVCB2WeFE0+4eT1HGUWJbYtk+SP+ZaKjI4C257BiCr2Q/XmCW6wpHsicgf19g9maTo8Jo+R9jBmtWH9fA8kuagbGUUQiNambfOq0BpY9nzoHCHjMN/Hwkc7lPPPRQPSrk0nF5xankLtQChIhti6yO8fTKycoluxyr3svHoCUT8Jgs5EOj0/WfOjPsHdcWuOzyNLqtQYWf1Z1VAPnR0GvHreNrqp4Ca+kv+Zy/y06QRwSL1SQCK9FOzgDNmr22TGWgAkaikj3aniNIjT5HO2RIzhxlYzmDVQJ66+xPlLJltg2m3BtaNlfZaUUEMIO9IPOF1SQIJpjkzrWZUQTrYk/o0UiT/m/ltAuT7kzRBho6e8m+PDLt5V8XJ/USl0NaTKjHsH2W7uCmztg8jRBJKnDguHzlZ6RJlHcnvunkysbL/yWwr9U5vwIse+EhBPFC/aQlZB5LbPk7uyaMt7e+9IgZaRp9z/AgtO9IoOa06fKGhcz0S6RSt2t0yN0DeXiA1Ch7qCg4U/AhTejT
 QvW/nqRa
 QhCqwwvI1YlckZT48azVaiC/0L8vYQYb5zMbWku4aaYcjvW32u3jgAfamznHFiVpwYo9XiCg7grzxsuOHm2Z+y4EM5zEoD1BI+EriBWD28aKXDj/WwYxHWh+db2XluWpzmSC3w+1olyJTeQtek0StNjMCDnfeMznYvKWsT+Alkt4rbGVhhhcn7rEjtFKI09IjAvEKgu9soyNDRimJrBy8rlrF2Dv5pYkZ1KQapEsNWG8FB+ygxh0XPgmT8jrMSukEDDRcb47DM+HzYYjF1V7ZCkmFeqlYo51qv8XhEgEX345c6lP/kz7X/LmI684rQP5rVN0i7sqWGux/TWQn/Z7xP7H7YzYIX2NFXJvooDxVdReAMKM0C7PxYiDW+dlqOiwf4vHrA0Rq5ORHBhupQrx+wU+OaMtiMNrnLnI14HXj2zBSxFlMZiJjbjOSWsrVZHN0s+OpTYqW/xYGF89J7iOxNbAT3LkaLm6v+7tVt16q47jJmBUSmmyFzKyMfVsjmYP0Tz1e8CX+osvCcL+d1wLOLsdHu1kTVa8O8z18irOD5njdnqdI/xD9hBenc6djx4I2qDzhcZTQjiujaxVnkw/eeWd/qiw3nxAoFjKRvJjYpx0ZIetik/TKhaz8cFSZFzllT/lrXmt+UXk+O8NMkR3/zBWMTF7p3+s60PkrejAMpyf8nolsTMx94jQuAs9PCTFRKlP7ZbZjq2riPxflb7ejblidh9G/dnjK3Kzb55L5zRgUP0GbxjI9vAvW3FziUgAq9SV8Ruoy00JCEUoQZeyhY+l4wsw8PhOIFxjcZoQ5iq5BmdPihftuZLc71UbiOVSHSwf3l0syEfKYInl2NG5PLcKwHdOTZbKUPUZ+KxDOtGaFIKH/ie2mGnmmUIWpbhSsjFPdxyZwK/QekQv7fToMjEFUFLFGfukvSwxBljV6bqiHsMhvZ3Ff0ATiuJtY5aiQKMTdazLizEktmYb5GzKQg8VtR9B7
 NDuoD9/f
 8b1fpIr020Ywfr4mgfo0gjsIFY/cVs454ZBj9T3pfykUAWEoavDnNqHuZbnP1dhFG+38YgngnIRzzt8/T2/VEXwttlMqkXeOZyvm7Y2qUK6k11GBsZ8a38neQ8AQ+3CMs4qQp0/ew8897pjJ2GUHLoJJEZ6lloR7EKeqVd+i3ZoI+1ovrZoyrS43P75Ah7V1Mkt4i4g0nPOr9q4RalVraCBT1WyP+jMKs6pAhsJAR/k8lqKIgCjQzikbJPKkADQ0Zq4EGMohUtGF+mbFfBgZ2vr4pRDQhpTH/nXeJvlHzPFxw1q+AjO/SVjATqY40YndTAUzIbJeiW5CzwuXT8Oa5Z+HRss23fE0Xb/xaa+CwcFGSM/2MGmvo3C24ANw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit c3939872ee4a6b8bdcd0e813c66823b31e6e26f7 ]

At some point the definitions for clamp() got added in the middle of the
ones for min() and max().  Re-order the definitions so they are more
sensibly grouped.

Link: https://lkml.kernel.org/r/8bb285818e4846469121c8abc3dfb6e2@AcuMS.aculab.com
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
 include/linux/minmax.h | 109 +++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 58 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 91aa1b90c1bb..75fb7a6ad4c6 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -99,22 +99,6 @@
 #define __careful_cmp(op, x, y) \
 	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __clamp(val, lo, hi)	\
-	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
-
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
-	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
-		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
-		"clamp("#val", "#lo", "#hi") signedness error");		\
-	__clamp(uval, ulo, uhi); })
-
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
-
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -170,6 +154,22 @@
 #define max3(x, y, z) \
 	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
+/**
+ * min_t - return minimum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
+
+/**
+ * max_t - return maximum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
+
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
  * @x: value1
@@ -180,6 +180,22 @@
 	typeof(y) __y = (y);			\
 	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
 
+#define __clamp(val, lo, hi)	\
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
+
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
@@ -191,28 +207,30 @@
  */
 #define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
-/*
- * ..and if you can't take the strict
- * types, you can specify one yourself.
- *
- * Or not use min/max/clamp at all, of course.
- */
-
 /**
- * min_t - return minimum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * @type to make all the comparisons.
  */
-#define min_t(type, x, y) __cmp_once(min, type, x, y)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
- * max_t - return maximum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument @val is.  This is useful when @val is an unsigned
+ * type and @lo and @hi are literals that will otherwise be assigned a signed
+ * integer type.
  */
-#define max_t(type, x, y) __cmp_once(max, type, x, y)
+#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
@@ -257,31 +275,6 @@
  */
 #define max_array(array, len) __minmax_array(max, array, len)
 
-/**
- * clamp_t - return a value clamped to a given range using a given type
- * @type: the type of variable to use
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of type
- * @type to make all the comparisons.
- */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
-
-/**
- * clamp_val - return a value clamped to a given range using val's type
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of whatever
- * type the input argument @val is.  This is useful when @val is an unsigned
- * type and @lo and @hi are literals that will otherwise be assigned a signed
- * integer type.
- */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
-
 static inline bool in_range64(u64 val, u64 start, u64 len)
 {
 	return (val - start) < len;
-- 
2.47.3


