Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8FFBCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF838E000A; Wed, 24 Sep 2025 16:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5A98E0001; Wed, 24 Sep 2025 16:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB3E8E000A; Wed, 24 Sep 2025 16:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE838E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:25:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5C73160195
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:25:49 +0000 (UTC)
X-FDA: 83925274818.06.E365195
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 92E654000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:25:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=J7SAV8GS;
	spf=pass (imf01.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/92zpxyjeHvGlOVhJoOGNENC+jRdBRPJKKvWmFCfMhU=;
	b=QgTO4uzKabOZH81UwSFixLzFAbI+ELh7F0txrEV2zvG9DIXFXyo7mpXlT+Of9WMSpvotS/
	Jo6qMoTBIiNSEwcECqIi2D49LSj8eLri5FV7RXXlwOdjIOrdWSZiMigmGV4LbepPNGjzWP
	E4dM2C1/a67a/tzChJU0j7D1iYVuBL0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=J7SAV8GS;
	spf=pass (imf01.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745547; a=rsa-sha256;
	cv=none;
	b=19Mh6xbhbKoVYXiK19UbJww+wUJXPD9mt9H5LxGmlcl++1AgIfcUMlfSdeRwlfjwVHHduA
	mYV1/1IWuEa/G17j1Bc23uxwWIq1aJK+Rx4/P3ES99bVoEolXWvbHCZh3l2w7BOuD0DYFC
	/JFNalGfawm7DPNSuTIFGBvyM6Pq3fw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745547; x=1790281547;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=/92zpxyjeHvGlOVhJoOGNENC+jRdBRPJKKvWmFCfMhU=;
  b=J7SAV8GSs+y6cuW592O0grwnuMkplTakIIYpuTBFIJpfOf+WDDBGY1Y2
   o1whj+EY7FEyVcbxDQrG0mVA/kkr0plqJ9NP6wwCmLrZAQQXj9BXvSlFC
   IzuEg1F71MLZZseHXy+goTrSJJAF/IkcQ3yPAVkKLD9eOvaQgrplWkdOf
   cvP+cdaLdOacrHNAArypb09aDMl6OTD4lzEg5mndSWimv43jk6MmS3Yix
   LIW6szAbdt5wDs4+Rrr2LR8xnOXfg6n60lHodyXnbP17ZAonMiWwPybgI
   govrscW4D5bzZqOCEgcGDBhgg1NAtLzNrETBNKsxjdnN0HmVeW1QvSyRU
   g==;
X-CSE-ConnectionGUID: oouYGm3aRoqGoHtWUGdqSw==
X-CSE-MsgGUID: EOnuYXiASKiRqlUO40vVig==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2525132"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:25:44 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:23628]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id dcc177e1-9bc7-482f-9822-8d08804a2071; Wed, 24 Sep 2025 20:25:44 +0000 (UTC)
X-Farcaster-Flow-ID: dcc177e1-9bc7-482f-9822-8d08804a2071
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:25:43 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:25:09 +0000
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
Subject: [PATCH 03/19 v6.1.y] minmax: deduplicate __unconst_integer_typeof()
Date: Wed, 24 Sep 2025 20:23:04 +0000
Message-ID: <20250924202320.32333-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: sfyj3ex9rr9o154n3z67uk44uyeedzid
X-Rspam-User: 
X-Rspamd-Queue-Id: 92E654000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1758745547-477260
X-HE-Meta: U2FsdGVkX19jRodCWpT3sBlMy/WqP3ukEU3fku03dQD5vXtDAi/J1tM1yp5NisZO7j7N+i/0BFhA9VgzP02XUzScsUHed9rzIQUoaQ1nTfZycDYrjBOiz20v9pu4k7EJVPzkFu/Hnofa6xEZnq5x4LqEiNR6Cn20vhMaHnsjsKlfK1gtvb242wlAVVSFVswhNDLuE8j/VaV7WL1l6+q2/MOJ7OsU2H7dcNp7iMwvkw9vKzettv+7cp/4wMoW5EGIAoHd/nQzeS0mTxYR+R7bVUDvxVT8L7By6Uo6v7h++slEDBxWxdQonlw0zikXZQsLd/icSzdVSwhrW6WWeAcUniR+G+n9Jlhz+rM3UcnCK4p67IEMvPndGe7jaQgQymkuXQPrgovukv32gro7fpMD/lukyE55qSJOIhhHcYBj3+vDGPKEnAtlCVgY2Ye0WLrCnvOTVoe5mIS8ZTC8GYhdDhu1SDiYOqvtZ1v1SZB2130uRCTyKpgUQv53lfzJBpi0IalbkAF+Su8c0YizzG6sozia/2iI7PCifpk7mQzdqnq24+GFpbj4AN6E9IMecrbor+18GkRB/+efmiUMVnL7d7TlxYAmkGxlhTbdkqSHEK0ai5H/zQ+8lxyss/n79apS8eEKlhbYfRktrJ40ktRrFt+Tk2w7SLpGy6gPanZNVNLF5ajAWBbQ98ImKLfed9dfCj9xN6ddke48w8ksUPxvmb+nk9+ZIPg/+5h0BLGC7hRjc1lIgNTVdX5fo1dWi+mocFaunP6IV8HHqeCnjcRS7r6KO04ZLsKJJIOQ1IYbT12rNNUJKnPGnWfUEF3Tde7/4JhqnifVGfbWHUtXvGf8TwJRMfcRfAXf9nnRioKMY50N4KoG/jBy4qUWYN8DTa+BA70VlEYRh3oELhnKnMV0i+ZJJztwOqGFbsCKOZcqMHEbYzMmk8MiqCfmuXnlSkYKrpi+SOOHQ27dpomal2g
 lftdvSRc
 TkbNAM0+1wtjhntR0QQ5OSdCHPpTX1wXqX5B56asfc5bG+2QqVI1oq7T1pWULz+H8zgrwcgxdr3ctwYzQpgVucac33Brm5AMyYL212AdDPQwZHqRltqpegrydOSkGievN1U6wqiuqUOfPpvS3eFGRFctvl23ENZBUq3zxzSKmgjJimwDho2ibDFPat7pg405/tIH6Kw4UDd1EwRTO+DR4+gIMbQFMXUIVCD7THDhhNwn913YQmcSnQByNm1zB7tf1dsuia3aKSorBdJRxBJC8oR+grODtzdbvr9F57Qq0/2JHpqrkBAcDgxLsPRKLNXg5QCE1JeGVyYPMnBIskM3SEi7eF920wV4oeI1bzLpT+Bhadlu6U1JoDpTV8GIq1Tm8T3r8yZLmB7LZZycL2P5BqWaSVvNvPXJtETe7H9xBWiUrwCJIiMkoG2vwgu+ShgL9lXK/SafhNTMNQ1b3DcMhmT7BBjWN+BuRo1ip6dgzE/t1Jk9W25JX0GNBUNyjHTsOIegwU4zxv88tYAL/Dyqq5d4rntPuhqXSHMkC1atbTPDemBphH6G+gHzUI2xYywWJLvZL0P4LdR6ci9sylE/1chARFOYN56qg+78HObLeJo+hGMLNLO9ENBY2Z0ByC4rmcwyOiMhbmsdI/WlZrK5UFiwnfildrWQIm7c7WhGb3Iu2bE6KiyqjuAd82b9Kg+5MqqAfS6xGa79Dg3ht+AsZMQE8EQb5CxgB7OsfbcfIRTHLn2Mt1Y20xPSAzoQbTDE/+UgWmTajHVf0pmPq/ykimrJVQlgpZgpxoaenZ3JzvuqglbjjO4GNiy4/rQFqca17VVtNyakPvsVlksWf3kZWaXUeQE0VHUKECmlkh9eJNJrnaPBwHBnN40mQRm6f+uePPazD7L1PvSUsH5J+qnqbWh3K2OhC7d/Tlv/mOAIFyo0rdEeSdBVaw3mFVMds5rtvHWcadn0FDGB2rrfVBI9GXnSgzY7m
 nEkY/GBW
 JcHHPQGkksbUVUwdRfD6e+nLNd689p6W1Fb7DJvpp962dOjyuecH96Z0o935Ylz3LiNTftCYNzqrjQluhBwwpbSNnR5A2FW2WXyQsfqGCmmVRg/74o1dO/DD5mJexy/kakWMr7a7YbLZGBBHy9K4CCZItRsF+Fi9ayJTaFKo32b428TNxu5SEfvyfv4MdX6dcm1dEytO6frE1YmX54+ZqaJ2RO27ZAenh838Leh0hWEreVTrUn190cMSMtyomleJeDgBn0xc6ohKf1jGYww5PEZMhwwV0Abxpa3M62OOuekuMUPiTLwtwde91TfvWqOIvs6lTuyDvhShmHCQJsPHIrxYlcD0BX4p35M37AX55gzziwFCvDA6dsFmWCWTlmFvZK6oDkYiHG94bnQ6ZxYt5/vrcdgI/m2wyiY44Y/BppmJGAbCnwCPcPE39n+GZVYT9MacNnuKEwg/1Gypqv8zyNuPsTxAHaoDRG5EX/Bjcbp6HFjZPJAwBW73fkq0ocWJ2R8h5L61cDZSGXrkXbiE2cU/pgxKL26oDQddmgK8orV8qrtkE7PG4StPyddpnp2udh+KM5UERX69hTS/hqksqwvKAye848hzYKLs1rvk/Iu19/Q4zKCCFELAeaoKBAJ1mzteZURREvYyv12J/Qaeit7Dgsr5whm+ATjz+oURRciEsbQ0uG+AZyv63VAAnJfGMpx4d/rIIhUdOLRQv/ftztQ4eYrc6aB4ZnVe4YzbnOMu00iC1OCa1WHN/c5ranvx2KDXo4U7Fe0eDC2GqRQzmKm5eQMsmEcFKHNIE3I6qGPXFp6kn9wgC2SlQNQs+GHqdOsyzWuFlaRcLOtOp4sJEleVyZx7pTS4c1Am4aN//ID+E7J7TNO5B4JXo5lWcrXod1nprzjYnA2DQuJ+Uy+A8CIMGL4UlIer3aQOHa/jhSBveOnSpT0PrZibjRsJ2hLZVeEFIYzm/851MuHEjo4gqa1rChvVH
 CPEIhx8A
 7/TYnimr5hplKlBuIxBpIy9wMb7YcDntW2ENf2q1g/gm1escrQfx1yYi5jUbHcgLmcRsxqdQwIhB7KwiCeHLnTeMdcSifxdw/bCiUBGBomwN92HRpIxJVtifjLd/WLwRFjYZvcEDP5hD/GxnsRZ17GakXmDR04RdV8TnS6tJeMOAI3slOpxx3jj7RamhvsyVlpSo/U4Ki1RNVBhKjL+UYGcMKVbhKoqPeqFlp0LEGJBp1wjvQqln/0QkJWee5614/lTlZDmaSWilvb5vgkxQXQCz6SeRim8CrbvktMyey9P62rxu+5q0oeEESVrhJRZsPbD+V2cyp1F1SPeyWS+JhUYSyqRmU6xBHdb0Qbvet4/ozDRtLFS5UtssXVSkmb/lLVnUG1ByWO+TQUeMAyd083R/KenohKbSda3nU0NJD7V3Gqdke5xh80a0er7OfI8G13LzmJjqja3eL2BFqQQ7n4ow6eBBf6JZuU5s1MffSW7qaYxTt6fjQTFg3NhjIdTCmeqAzBQBJ8fI1ic9fsSWFKIoyBzSxGh5VJSxYUXliTz94UGmpPD9BufVyDukeNytCczuj1k6Y+yaMggMlna58SEVV4bEc9T+zsDDuY+dauFhe0AEi5SxiIyfEi36/XsczA3peFWHfHIu/bd5pTcBRig7LyWXjs1+O4aHcTTJvvfEgxK2zlilpYMWDLljU2eAu9p7X/qeabs9XGW93KoUjRkVeiPqqtVzrDfRfN4YwGfUYWFkRzzf5aCVcEt7pn4Jp5SnhacuFzJoyZdITwIOKXFUGgrIzqz0ABk8Nn8aKBRTlVmXVQcBMT5uL2SV7x3kESwGds8cZw+Njrt/R7a1lpuX18MU5elvU/7NeeMzeuBDiX0DV6OgoW3QFFOB3Y0K28s/RZfStZcrwRb1AapNoiRAEd7co5D9H1o1+tTHupGihVkld1luxuxqWri8wzixhO/UDxTl+Ny/UR+qmsPcHdJvTyHFh
 WGwCKYwc
 60L27LQ/OpZggfIM5qeKbs0jG98mto2Ak5QhmFWW4zFu49vDMyhtkEqxn89Xm4bKFewuS2Uk2oISNfDoHYV//I/48Ab2dXgRU24tdn0aFY+qGgEqxne+WH7Iv6xHhCV9BeIAgbZoDnsJdCGltuwvTs16tJVfZ1EGoWLaoGhD1IGJRRdSahmMRcNZhz9PeYyJWWnr5I1tNZuNQFqG8s6FTV8eTQSrsxnFcU8r7RcQicZwO+gaHy4OY9bXGHrvgNpZ/qOlw6W9SDFuAav/TxpCykoEM0N7MiRsvkuztmj4bKv0Y/ml0c5SnpjhhQz7CamZEVOnVd/JysgvwWneWMjfcq19DXADV/7ghpyX4G93lv5U4+RVOEV7ySyKsHEMtsKpS4AGy+26yYYzooM/BV0/bLCQH1NaY1RyG+pCZehuq65ZU/AtwQi3p/em78OFP8CRz1fDZ9J3bC5bemD0qtfoRcj9N9ws9vt/KFp1V3Y7EdBr6Xu9Od4BPn+LY7FKL9CYWeGw/e+QIy1lIjjHTr6URzhOVhmBcppBuaa+LKnQf+uggLP8FP1umDSk+vNbQsyYRg6GFtR8RqJCoFY2gDIqjsygnhvlSCCmaGUJfdGA8QLSlHqTbJXgen1BMQN+ieJLAPbOQwsr6jr45nkDkOJ7MTv1Au5BCch7NU0tG/WqkZULwTJw6s9TUzp2IsFWZHpCQav2xQdTztH0vmQFrhzIiO5LxQ/4wT8O4EKyDAWsLbCg/QyDCj1wT1Nd/p6NpjomaBJmyl80I4kUSXpuyHafky473oJ/OegJ9gphFLDkX4ayfPhEggg2lks2guuyvJ/pNmpa7zBR19PpbKIubt3lutFIjq2r6QYa9zmqZYhhKWyOw4cHUOKSs47kVhF/EWdn8xP6b7RiBIDF0XYBRJR8O4LIW+oBLwhSJrIJ9AOJWG9GqdgNeNuTEj8M4XQmqQBdZdMe/P7Qubi0J2eOrH6T/mrFfQh7a
 YgGQcxqP
 7dkJAz2BsugLj9apuVMklLOdsL72GpGzZVLtk+lQ9ay00AMKEtWOPM4hDKk8/oTM6+DQVcjCrMXz8IsiV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5e57418a2031cd5e1863efdf3d7447a16a368172 ]

It appears that compiler_types.h already have an implementation of the
__unconst_integer_typeof() called __unqual_scalar_typeof().  Use it
instead of the copy.

Link: https://lkml.kernel.org/r/20230911154913.4176033-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index aac0b7d23768..62b0c0a3cf30 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -168,27 +168,6 @@
  */
 #define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
-/*
- * Remove a const qualifier from integer types
- * _Generic(foo, type-name: association, ..., default: association) performs a
- * comparison against the foo type (not the qualified type).
- * Do not use the const keyword in the type-name as it will not match the
- * unqualified type of foo.
- */
-#define __unconst_integer_type_cases(type)	\
-	unsigned type:  (unsigned type)0,	\
-	signed type:    (signed type)0
-
-#define __unconst_integer_typeof(x) typeof(			\
-	_Generic((x),						\
-		char: (char)0,					\
-		__unconst_integer_type_cases(char),		\
-		__unconst_integer_type_cases(short),		\
-		__unconst_integer_type_cases(int),		\
-		__unconst_integer_type_cases(long),		\
-		__unconst_integer_type_cases(long long),	\
-		default: (x)))
-
 /*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
@@ -203,13 +182,13 @@
  * 'int *buff' and 'int buff[N]' types.
  *
  * The array can be an array of const items.
- * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * typeof() keeps the const qualifier. Use __unqual_scalar_typeof() in order
  * to discard the const qualifier for the __element variable.
  */
 #define __minmax_array(op, array, len) ({				\
 	typeof(&(array)[0]) __array = (array);				\
 	typeof(len) __len = (len);					\
-	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	__unqual_scalar_typeof(__array[0]) __element = __array[--__len];\
 	while (__len--)							\
 		__element = op(__element, __array[__len]);		\
 	__element; })
-- 
2.47.3


