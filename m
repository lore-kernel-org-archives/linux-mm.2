Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018C1CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5218E001A; Wed, 24 Sep 2025 16:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E3B8E0001; Wed, 24 Sep 2025 16:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F738E001A; Wed, 24 Sep 2025 16:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 330578E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:36:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6572D84BE0
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:36:17 +0000 (UTC)
X-FDA: 83925301194.01.A1C9465
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29FD3A001C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:36:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qpvLUOx8;
	spf=pass (imf15.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
	b=MlxU/JTd2I/B+zJjLzzu1XA90NgXCRLUtvu0Cp0mXE1qPj9Ol7F8rgm49Lhd8AblsY9AcE
	V7tmwBcr0PNv9O2nGpj7+yQdzaWI2Nm9BIgNS7MiRmVb/q1ay/5r1ab3qOtlAQ25/37DSY
	1iQ/Zy7/oyyzdZbpCdN+cHQj5FW+npk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qpvLUOx8;
	spf=pass (imf15.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746175; a=rsa-sha256;
	cv=none;
	b=i1G1EN3+hCNvGANDv6ieOHz05T8Z/BjCpgFR1mPpLsZFRU9NBvK3U1ysEwQVhK23lB18zV
	vTvcljHYsBf+JUDTloWpFsYOGgCLJHulnwq0qjjD1SZ8vC9+69ErSA02Nwhi/bCUpHj3pG
	auMKPkpoh4UNRCZtvLaXDF+05Sph9dY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758746175; x=1790282175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
  b=qpvLUOx8MKzgqzFzkZDjOSz6LT8lQ0X+myL14REeiPVTMQxAc/9VCYhB
   5LXuznhI198Lnib/+AkunHvISUmXcvuha1guOFN78ZEk9n1peYZud/3Y1
   1LmFg8sWDTNr2nTlwa3GMHqpOGVCMzpeoLDudIumeHkdJtvmOIk2YdWRQ
   E6lATmSG5UFp/jxVW90z2n+oQ/ybg9TgpWmQwHtBB+Sb7ZWeUXKyh0NEH
   kyx8tnGABdUa8eeXsDULLUKpHiGajDQ1FZaRDl4InqBlyiMGsydJdFytG
   iMksYrHMP3s8NPYqdFi6XdFv8ePHPQDzQcowaV3K4xZNMUU3O21cT13Er
   A==;
X-CSE-ConnectionGUID: jp0lr/zdQmmhikx3Z/hB5g==
X-CSE-MsgGUID: O/iAmUW7RWabr9VRpq0lsw==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2628431"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:36:13 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:6666]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.16:2525] with esmtp (Farcaster)
 id 4531d23e-29c8-4dfb-bea0-6ee73d1b5a39; Wed, 24 Sep 2025 20:36:13 +0000 (UTC)
X-Farcaster-Flow-ID: 4531d23e-29c8-4dfb-bea0-6ee73d1b5a39
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:35:54 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:35:18 +0000
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
Subject: [PATCH 18/19 v6.1.y] minmax.h: simplify the variants of clamp()
Date: Wed, 24 Sep 2025 20:23:19 +0000
Message-ID: <20250924202320.32333-19-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 29FD3A001C
X-Stat-Signature: yorsoseggtefq1nh36idd3we6gkksazb
X-HE-Tag: 1758746174-133179
X-HE-Meta: U2FsdGVkX1/VEznN8oNMGSUTQ1wMGTJEoLMIUV+72AVIpmzrScE23QlceDcSyPcCrwlVDTg+SRiSp+q7Vlo/dbCbuA+uOj4ne8iPPoZdpPqKyaLtVJ9fY6fuKA3SKNZX2yTMtIlAyOizbLun2X9zPhMsfjjuZD9kI5Dms9oVuUlqFjzPZpwwa+kkq0hEtxzWP92BEflyG9xWIdAPYSoJONqDNC+mpOmniRBSmbO30bFGbLC3hVFI8i+j0WB7eMPh+vNhoTePzW0ylUE5WRsXERmmnmCNqOxWMrBnz9+bwFhrq1KO0G1lFFpQvk5oNqUKu5naV4cHE++lPU2ETKGhFmwSlCH34NvUHDEptG1ZiWw+2DPHaA46XW2s9X6zgzMVVuBQMnwdUR7oerapezcClKc4wlPmxaAZM3esEj25Vy0aRlihDFkB91tr1u8sTYfejIc8xZIeL/8MGdAgKEMVm0LHF5SOz1+wsr5L7Pwmvu0AQpRDPxDm9QLRMgizgvxwmSfP3MkC5UUootPhVoVw84TB3FUb2qpOqJ3zekIpg4TRtpbFbp3Xg2KYOYhD6rGjLQHjK2aTApH9DcokanCwLOZyxrbizvrjJERKJKYFFydzZspCNfTW93Bt+7ZcLQBKbJaAdVxKLR7VLVxPPSJ5e025fBmsGamiaoCzz+gNW8K7wsRsnX8C345aq5QdtrlPH6CV+Du2KHZwSdpcxLwgdw9k2ott/gcvTT1zVZmYAr9w34Q2uhYnR3Ear2T2zGspztXlaF4hftZc+SzsU49kSMcU8C1O30wuIq+4dNtY69ee/VoMg4qmTC+maBOBPqzf3p05yGQO5nA4AB++fJbDtRKoahrH5Qe3b7DAHxQk8uEAHB1VPJ7rWyBOJii1HevHRAXhy/R6EDvfTikXvirOFawcmF1UDtPoWr6VWRgWBWCUcQr41L2D8hmNGJ5MAm0OE4UI9znAgz4CG1b++nZ
 dGpoNOtG
 caRwz3PPc4RobB96GyFhcvoItscjiTq07D0iD7DP54DLC0XIqxOWhRQSHDH/WPpcd8P+7GeNJuQ69dWhEVeRx7zr6/rD5iZmkrQeaqyMungY3QJG7bT68iy0JWFv4wA01poOv82g7usT0RLFT9L/xvfK75zwgasobas5Z/p1fhEHrvLADqtVSTUQuWcKGimMqVfCJSd/O0FDHw9seWi/t8Exf/XOxhoEG6EqYjm7SW8r3yn78zet2KvKOuF1dpL/GAt/G2PXO22f1F38P962hNmAw8bHHt64WXRwY+AahSW0RnKKvuuzgijwHIh5bFZC74fNS8SeRLook8XPLj6jIS9IW2LShYwnL22ewXVaJTDORN+GZKB62mwVG7iTvyykuo9aZa8A6N4wY0282dRl77YfjQJOQNN+xS1VsLKow9hnLwlwcwUUPdvGBOfBpNNvyFYqsuapI2QQXsvDv3WKU6CpEbyaru6EbTHWVyUpbOxv6DCKagW/Vq4M9B44UEOy4s1fnWg55+cT9O4wQVZ1q9YMksttbpINzwRYm6cdkDBUhWGgUy1sn+tLufNrOnKjMBoL9Hp+1Mdse1GpURJSjfMX9jZXIpSbvR//eEZhZWR0gxXiGXuybLDcE8wgKNTFQsbNW/niP4prCGK2UiFgNbBQNG7X3sJ3uSIJydzmv0ctvbIBW9pXY14z5nTRhlxCyITuAYUG8XWBShp/hlJ9dsJAaPB1G3yiDzS7VwOE9R89gZ3DFSH/pyVyfEt9p0dLCKOHrFzar+MQAnmMTlYchQGruxlPaxSNAfwNP+IZhIOCp5xuISfZuF0Cxk0BbuVPDHjg9j1UWkp0VdTM+U0FPpxeCOytz2TcngmDtpCY5AHFtqwcrPy/2FM9iWmKcHgG1mD5pBRt14/teJ58TUEoCR9ZWCA3GZQwyPoxTyxIuziOuQFSCbNVF38RiEEs1n8JW2G22xypPp9bVFkI+Ma9z4wCKE3SF
 vEAV4l5+
 A1QFviy07JrNl5gEgLFR33M3ckB50LjO6GKjV1pDAG7leqRz3ovvfSQID01VJjeLkk4elMkTxjec4EGiWrEQX18z8HGLsfc5K66W3pbwkC/5JtU8bCmeY1caJFENmm3s+QtTSn7mEN+9B794EexseBAfUQLo9u3k4O4NFAyw37b6VRYDnsD3y9XX7W2T+rmD8nf3UYglcaAA7gPfwZqdHdgxZciSIPfnl+Y+5LpZeLcNRJDYISJqjvUUhbPSB7xixyfAzUGhPjKW0M4BC2X4VpMZFEPWBCBhgwCOL7iHe0InC9cc1c8pbevOTXzQyMbedJPybc0ByrIvDUwbQxgUcYkeFSuO3Oqd0LF/aghfl7/gmav01gXWhJUi62seu6Da8awOSOVx3BBGFt1nsR4VS60vcMGlZPgGnGOe5p0wTGl7jRT31fbtqJ3C5pdgFVJNNnY2yj2sKukXSjZ6EBa4myT7ZQXgDlDZtIK/ahfChDBbSjzs2wx4eZ0w78zPecG6luS+eRukYuMO7RmYzw5yevb4oT0i76DTld5HRIC2/1oxxyXkEH2ItTnW6jjFPwNG1wMkHVqrHkhKP+vky2pzZQo+4phMlzXKsQ7Ea9dEx2qYj9tmTNA/ZgK5Wptsg0wDtE3jmJdUvwsGBOMnbek1EW+WTeoTPy3W5KEw/MixLsXLPRMZT1psoA480pNbtliUVjpstX5aUgcnQX5UXsswZGo/dEyb6ud4aDHzP+Zbpkg3p1Z6ZLKL6BaIKocxHlEzssDE1cHUL/acbi7ZfadJgMwJ8BqKs6E445777gPgmV1xKQW8KKzu3envvUNaviADqr2krZfyGHtndh+LI6/NCSG2oig7BVxPBFJdjILxJIeGgtVPJqEmfXESy4t2IqlpX7TnGQXEZdiz1wvptaDWeQAFlFUY8N1NXtyuHsrJ95C0pVpE2rvOeNIoarIHj9V8V7Ek4lds2BgSfvwU0KcdqgYY+rRki
 MS8QJe0i
 Dvx/DMIcFg/jJHDgx735SCSMqFqQowFytNfwVIcVo3GDxT0yE+Pi4G+3Z1tN31oXzZgtlH5EmE6Ks0zCqWWYPSZVEH0X/qwz4m7gJmDRpAeAFDHjgyhKSNbHpXifH4eGScQ1UhqPM0QAuLcAvZWdCeP3GeQfXo24rn0+X0syyFq5Am6FAbPb5oZkraKnO0uXYUt6MgQB7DRB5j490N6AiVC8kEg4QvCIPWUW2YHln+8omYDqinlPUEsrfOJCmho9n2uPJb7tXvbG0O+bfO4zyErgnGbf9mgjAbfoZzOAYa7nQG/IZ7PlsaUnjjRIvJmMilXn7xzfWtSCiZo5bAeoicjxoaaWK8+1rX3zv3QTzgHUJ1Mb6N0VHrkOlC6+spZy81KBzIKK01f60UQ+m2cgEEoWCCpYQrmqn46ycrQT4YP2JPb/oo7CUZWwR52uysLaQNnP6swUx+IUboDEDtZBMKE9F9kOar1JLt8x6vVHKRSs0LGNUEhQdUy/c1uf60AWzyWNjZn0aJLWmaPR0i5s1C3pzRiWLkprub7u+gR1c0/jhmK7g5xr/bleW9ydqzB7c+5DjJ8L0SBBhDHYTuRYcGhiMGhsjt6zQu8BPTGCYWYr4dfDmKsyrhoVLDMSPaNi6TNA13bFzWRLODSIw1ZW3A5KgexHLnzojunP+FoiSwC0KOEP+dm1ciihG6wCBZZ6FikMyy/VALcGMLerFw2dbjijNzGw4yLU1FaNaHYdgt5XEdzhiJOG1wTArF6x8cCzZ6e7f3x6xI7QxDGOM9G6Oc1R5+XvU0ervA3LFJRO5yC2GYdC0hJHDMUKXvAxdJVzoQAkuHMhB0RiRayMBdIZEpXfwgX3vWGRFZCVhamGSe/sqKZt7hOHeQavvh/PqPyTgn3fXdAQQBoNywmQy7vhXbDOz+16aeEGSC8RKpuyh2kCwGDrhFzVhMk7Z5p2OOARramaMxBIEkqz1nfxgdN1NCZsyP4PD
 8uQXB51m
 PKmbd/wDDq+62IDT1z3uK1RrH2f32zLnv92ZNOlnz+LE3rv3A4Zqyd5jyiccBUCXMoHvMy7KtyJInRwBFeLATIRC1xuxmefqNZcGKevi/ULMheO7YkWS5/FYgbiX8RuDlrI12mcCprD6jMmyWeoXdd6u8aOoFoqeulqB3zp2qkFrXAuZbKUgI0uGlRChve6fYROX+pJBFRLgJS3kXoHcbS326Fn0/EvAv2ugLW5hFPaixVEKiUMJ4cx+YgEx1p7m9OJwVyPc/Wz6uTmU+QgO7NxL7raO2Eyfv75G+cNZv93feKUA3/9y+DaRXFhMBJ1Eh6KGR8Mm43KqRA08M+ZvyyULtjAPq0FB8ElUYnB6RnPHhX9rx70w2pm4Io9qg0/QrvDdG723bf10fhe/AhSIvOv4pKZ4iNcCa+EmTy+0gvRcjeYeruXxa55MRaPPcS7MuJ+IiJynGJd9MzlWZiXyH8TzJn9zXPaWT4kWB8RReA71W36YfQo127eC5N4Swf/MKRHNmDbsj/be02NDvK1xzya/DCqx76X2U6xaWNskgnN8yvdyImQtG5dik2sfjQNhbRW2ki8oJ9X48MDnsofPUD6X9dFAn6vQ37hUK6ohtiwmkSLYlc/nhMQnVhUGoAdUDMMUWO7LT3MhkEf4cbGJWt6LLw8ED47viqtx8rxXR02li6zsQUmaMOxTtUQ+ihDsLwnZ8/6Y6ILUo3Gq9KoXt5f9Ork7+UvqEKLcCZ3sqCDWdETD92TEG1zWUzmq83r6ncoUQldb4CC5Ms5i9Hg+Je2UuN8uBxwWEW4r6xF2ml1qIbH9VPkTP09aZjaqG2JBQNZzRodbbQBkHpJGKTf02rKvDuLonUdE56dl7iXLCZzrpHZfCD1/I1PDHilPRiFaqE3jMo1RcP54M6K36dwZGKkJjea8TJntMt1vKyZ+zrqwbfv/8mjwcqyG4z5m9y0f5eNAs0OA3HwYKrWu+gGdVRWmUHtZy
 c9WqXwJk
 a/zJItrBw9MKmewtWeRoV+a/M8b5dIPRUVoUiQaJh8fSTizJT6DECsEmJkA7dLUfrRw7WxdDm/yTeGFSMQUCz7e44BwO97lB+TUrDT4Jzoay6wFz4FUfcRAlLxaDodNkDlf3m1L6zjYxD9jJC5uMZ64nZPrrpS6vrgmgrzSk3pfqIaZ3hvVn0MPAWRhhF8W7AwdJpJj+JyRM82UU6/rgykHMOJlFzUvG0nSnSMVoJVZE75YEUU0LcJjex4iKzZG6ysIWeR9StqkjkqUQRp8oshEqC7pJa0QaQ0J/4H9GwOt6+L7rxTWMfXRPyG7oevO/64ZNduV9yX6pMluFNeg8aK13sKlI=
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


