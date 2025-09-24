Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A029CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFFE8E0002; Wed, 24 Sep 2025 16:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D77B8E0001; Wed, 24 Sep 2025 16:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C63E8E0002; Wed, 24 Sep 2025 16:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 168998E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:24:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 502C81178E7
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:24:14 +0000 (UTC)
X-FDA: 83925270828.23.BB00A6B
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1DA8840002
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:24:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=iKl7Yx0j;
	spf=pass (imf11.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KzVc5pQt1xJae1laTHwFTkgfsVttwXUFIKNqt4L9XFg=;
	b=Ija0k4d6m8D0ZtPU8EmKXiP6hgP1wki3a69ePhsaejP6yOhlqCJecG7Vxx3gkOE+1plWQI
	5AEuQ+aFMyIc3U7G0w/NRlpfVsBuqYL3p+yXK97lDxvSUZygnXh68Bpr+U5eCdLJZJH8+P
	SWHXzv5qtGWIG6BfSaZ+EnIEu6SDALg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=iKl7Yx0j;
	spf=pass (imf11.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745452; a=rsa-sha256;
	cv=none;
	b=GUX3O2R4KlELFcrAnj5k4kcULYEtjcI1rCce7V4KTKzCjEOx306FH0Nc83vNMx9fvK2qMY
	TRYw1WQpoWw2rUjY+exAzslKY8PPE6f1uqdjSNkg3IBVXBCuR/hnyW8YQrFLXcxzDJKueL
	W/fTUrbhKRysuhsRJ25lwpBiXsIOME4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745452; x=1790281452;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KzVc5pQt1xJae1laTHwFTkgfsVttwXUFIKNqt4L9XFg=;
  b=iKl7Yx0j8trtbJHYCUBM26/WGsW6y0WFt3RtbrEyyz8KfTRBQVXiIl9m
   QDcIXTFdt+XkiqzNhNri8NDhwVSO1mohXIhvOLCpXn1BQtvsqATwhkaWB
   ctvfLoDRxjZfm2a4VUbalZeN50ecubOJWB161l3dZceAVQoIT22+1icP5
   09ramX30wmj9yw2mFtVwzdZo/8Nw2kKptzZNiDWZkMwroepFdis3m5AKx
   ODJx+YTZQ0j+Mj6C0E/CCCSB0vfSQvN7zrHtwjTRI80aTjdysJ/nrWrgf
   oqnv5p/olt45hBErGgq9cdD8h3C5H4lZ/NNKQ04Z/JypwZKVrzXwkvJ+G
   g==;
X-CSE-ConnectionGUID: +bpb7ezGQtmV8E8VA8qXRA==
X-CSE-MsgGUID: SFde7s01RFKi6zh/6W6ZSQ==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2525915"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:24:01 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:12397]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.5.254:2525] with esmtp (Farcaster)
 id d8c58b1d-ca7d-4c1f-a53d-72dcf5ba6a6f; Wed, 24 Sep 2025 20:24:01 +0000 (UTC)
X-Farcaster-Flow-ID: d8c58b1d-ca7d-4c1f-a53d-72dcf5ba6a6f
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:24:00 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:23:26 +0000
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
Subject: [PATCH 00/19 v6.1.y] Backport minmax.h updates from v6.17-rc7
Date: Wed, 24 Sep 2025 20:23:01 +0000
Message-ID: <20250924202320.32333-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 1DA8840002
X-Stat-Signature: i7ewebby96do9ci8mwgd9cgsj3d59843
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758745451-829612
X-HE-Meta: U2FsdGVkX19FlY48UHIHUwrFml+w20aI7S1c+cyx4yq4032jUN5CdlvY9Bo/A59LaYG0sprI7ZExmwM7GwAVTO4z1CHZROi4btN4ewSgr+0xW+/vNc7W0S2X1UnJFwRnztJc93Jra04DyWvgJd/4AegvN7RVWVJovg7YsL2rIOLQe01Y5Wu64Twd/VIOc/StaNhfn3Lex+lLitC2yqg5Qei9HChkmifwomvjk8+zeBmL0sfb/N3WFQqwg9Cxg4gF3ZMiBLID87pciCpfz1T7tKBTvpIHHmywk3MsCXPS9mbBM2hSDfnigndEgqVi07IuZ9tvBIUmB3jQvx1PmzoJ+VH1A4qa6c1VRjGYRzsEUV+TPi6DekJZYYlNZp+5Y5TVyd23SRKJ+zRTUiD96QMO/W+YCBexiI5WqPw7KexJ6aeooYkY2WDpOCyknqTa+EuqTcObzRindHd8Qi5VsYzCMBivDj4kDffnVP9VwWwH2G+EaJtqQgFWJ9jOWg5l5tSz/oX5PUvPSITiHP22KqBCcs3CClW2+Htj9xs4OBHThhrB5Up74I/+nxXe4NIbHIaifaUAi0jQyv8vwNxHHX8YlZ+CaSyW3uM1+XH1890KJ35qSoCnO6uprFGjhFUb2m32d5qLqq5IFLYk1vrcjaqsDrnGfQkDmO8G+5J2LpNSuCguXISESUMdczq2xSZxhR7NDYNplVaqMvZpOcVf2upX0ybllfODgkZJ1Ii8Mk6VfZ0Uxn5Zpxdy+5A945VdwhzRqpJrtJ03SYb6taCS5SL0LfBeRAL15aDFd0tzjsDTPtvSlCCVcenj80GMzt/s9liA04QnSJbt02EcBkXvGqbsSuHjSplETR5BmeijPPLtoi8XcjDV0NFHhaZdBhZsWzzYPItPk4nvKOQD9POKoXoIkN2iH4+IcVtoPp7Q94O9L49cY4ir0aegCIjfADRVYcv+rWeysdpYCKBlUt2+MuX
 It7X4IIU
 lAoBd4h3b6voO+PJt75dQc7TYi6GagzkZrvUop2/BP2+vuuXge4qoEr3HCn5j0DtyIOPUH7pKSyJQoOwKCxlqgmlrhvIg7zgIJRvDk8cFLFU4pd/9s/5R0kSgEWoxANe8bcEfSpugX62c+bcuA+lIPV0Eb0rcWxkb+php7G6Vy6zlRbVFTZNzljTFxrsS5OEeS4rW4msAgRSWP+N7yvfr+2wusEdQ1ZUDEruUBSs5eaU+IAXCuo7T/NG0hcYpeE1r3IAiTTkv6iThI/uj4d59OAE/GgRPaUiZVrfiR12LoJOjC5F0HTFbpprKBJB1P6mu8cgQnyUQh894iWLLFoQD5cGR4NCTYKyPWFQ5iWQdttPv7RFr68L1qjP1wnllGJhQejiC8VbmP322wcuRDr39x9yeMFsL1Day+7DK6g+qbYV1/A0GyhXKPV3nUu4ksOzNG6qpWq0FYIhKcB5+OKGUz68oo7h3nbOjZV5LGfAOAx0c6fDEBMi1AgN/zS4qtIqP58ll8dP2m3KP66GdM8jylXZTU7ho7FuYFV4/paYoRDXkawniHbxmQ9O/uKiFdvyNQIAoHMC/mtGVEPXSefe/aoqMtgkjJySMzwSjOGk/cLGLVEyZ7D4PBN2cPomuArq3hiyvfUGekxs30gDitkFAPEt9/uPApaX7SkBc0Mddi+MprDKFCLC4X5zvRVZF5aj4/lTZjxSkPDv++yP3QYnjiT8wdt3n36Dq0rC7ei5rblLAy+JJ+eAm6TaziwxbBLDtD22riQ7p10xlz3yZqQiFMD2nM30GVY58CmV6W1vy2DeP3UEOrdnI9ygSv+Rruwj2jiSqmwoDN3x0Y+3FCoPdVJfmL/5KcTP7FMaa//f1iRbGvBDtJabILKq+lTwbqv1fDJG6NyTtmth7r0EwMt9rVMloFBp6v+IwR3s/K5cewbfQQMZDbBurDebYGOm4T+PV3qlyCxgh5jJseMiF6GJNVzh7l+bo
 QbAe+XEI
 nVCcugR8oRjW6JI1LjtWg+WOFo7TeMW9B4cLR2+zQ4zpcdd+Sjg5JqqsAS+83dqiuQiZ+umdMgn6J3hn+54X1+obGaUiV/+VhU1PHfSBW+/z3vKwYZSHTM1lvsSLeLMT3ZFfyPnUmn95TfVjI3lqjQzf3gIqu8LE+zueikq2NWRSC9KYCuonO7mFa0l2p/NiGhMgJmVgjv2HgvE62diXaBJy4d4I7TtlWSVJrPVhvcJt8SMU5id4bBIeObsqTHhwW7RsbSEtPBEPXy9+OVM0VA9Htp7aR9eyp+oGYrIWx+iKg6QhibDBULsbGVWXpe1POsAdiecJh6bqjAzlA3VwFyNsQEPl48psE8WAuGAtBXpQxPugcFTOY1m4CDt+obRgagYuibsD05i0R1ktWD2rK1QUkCaDz7FbIHlhHjPy0S9U8if7eybk+oZZ0C1BQT3TkU2ou54aRAkjcYf8AW0Z/AT+73t8U8SGaTf59IICtetTttA7j2GLD4ScI8ZFXtT9dgLCKpPHbBbuXxAKLxiuepKYko69hl9Ksyhx6ZYTIGdQmc63xudptINSv0IGxeCmhbGKSioQttMGJjPr04RgCpd5V6+BeVebEjVmSj/0UvuekvMfLh0Ug/5ADiJ3Y7ZZhpKA3GCDpdzNkE9aJ3ZdZQqa6SbStociHgix76cmNye2N4P9WVD9Za6QI/AuqJ7X2nz7m8qhLs1jykkdGelA+RpHrxcwU2hgjKItFsJTPumOtXornJ85xGv99MCh672Sn/U02lAsOrr+3VY+mQeFkgY5TXFY6dr2kvg0BDpdi7XCfQ+D4hEN14ooCjLiZtZsoRoyeMXh0rvK4b/3e39adETstefmD77gxKq2OQR06d++z04Xze0oRpSnvUT1pVZoTI+5ERNkWobvTyTcL4Jp41pStz8CgdTlGDt00hb44HggdGrFFfbGK8iQ9qKjidueZpDhqQpCD5YEuDRJVn92I9GwcJoQo
 RzyQ8ex5
 V33fe048CJu6GWsVYJHtOK10/olP6Phq7AxQM01NXchmmMm+Trc+aa/uTs6Casoux+l5EF+3OxqYHQ+qhTwY8eldGFPjK8kSfWLFGe/bCPvHIcCfZWiDW3fGdGyaezZLhYzE52d5Kg8y2tVh+XD5khXIR3A9wVGMx/LkSbad1E5nrfxjwjSwa0g3qjEpn70/jX7c0mJtg4JWyUI7oGHfwnSGR6R7rsuu5SBv5gF3Y6JPZRXmYIDtnrk3TYPIBqykwxkq+vod1lkj1Ji8468on8a8hNNlEZr5gsli6mpDVfgdAhNsS/WcEkaArEVTrPcOEY3Ir+myBOkGYtrgAdcB3dQca2PGTq4eDB8oz7uKCKWtcZoi5qOL1Xcp8XLglb1usZaa9kolTIl7seApPm8fK51Fd8YS6IDLeLgqlEz658PgWI41PHyiblBe8J/lj5pD0P/FYyjuGCcbZtjvF/R06JewpSDTbLm1NPqBqBDtFnAcpa4StLQjte+hhPLGttjMAraoRPCk2Ef/XeFivyDCKldMySoSdpJn7+nyrRE4zih+pxDiQYRG81vFHsh9//wdsLNWJpMSQgIkVxErCefWTfmhpnKckieUJcNa1/ySwIJrNrcYQckv3NSoX936Rx67p59HuX6015iV36LT6dMIPFFuWJJR+b8WpnBXW1fo6uRRRnSXU0qdWOxKIIjFq1CtZ6XBiGENyoHlGvqDwr9YqJeSLlOjGFE52JExwCL8rMmXJ9rEWUONOxY1RMuCxUd+g4CdBanEaRt7kIJlS3RwsvjcPMW4io5FSxaxU65mlKWFQpSKZ3I5DB9zRQp9lEu8JBaKFu/ckltDs3h53MtwX4qVzCSas140cJhAaS4DjmH9aQlkkUzMg1iu+0KXWfCkzeYz90/vhQtdpk7L3DrzaBCK4c9kS9MTWyrTQCdckwNvdM4svXSD6spWfXigdb0WiP2FyBJ71FpIxxwQNiTKHhOTDhDu0
 cJu7Voj9
 8Nx/wLqSgCgDzJlGSKEmVDmMjkpI6zo2yIPLaLBi7apsszh9rR4Y9plCbIX/xjMvfFJtW0rnevqP/wDRjccqFMnWAl3wZueC9HxZJSSbCj5XPWWw4JYtgVlGZh5C5w4Sbesa8FBa721/Aaz5Crr2hQlLR89XqeGE+vc0Ozg4HLrI8XG3ZL/45K5H5rCIU11T1BYOaleqFBF75Ttj8gJEwkDq+iYffEL/TZ6+L1aVEWIFJ4aL6HzM3X6sC7jv6rQ8kir4PI0+j9EBdPoj3R2XHSUdMUkJwT19nU1kTOIGEBQmnRxmy4iFIYPfcQBnaS0b33DSDfWCsAbuOkNcTfvh8dQZV3rAl6bybcQcxFVA/1v9+/lYgYSisiT5Q1uXuS3QRLTNEYEZ5hqf61oLnEoFY7mSrkTsAQts1aWJJ3nOGjbiHhcUgZoC+vJI0pJ3U07ZyE4XIz2fa2yfh+m9hwkCAseA56/HexZYhYgzJcZVV7KDB/HeD2sjTEACg/t/JTKGBb9DoqfJ7C1tn/n59JvLgKjG7i/anYfayNmWvnQWQkRT5lp/xswipNbPLAd7HafXXyxliHfT469yiwzpcw3UOnGvlNPSh1+iGRePPdBMieF50JQaEfgmZjEQI7kTIUaoktUAkzeRvGhhOc11PxTbg130kS5HlMZ6tNMIVa/9R6Y9OUpgk71ZvyQuFnjKnDI2fgZ8eiMR2bzKxZtoHFs6/PjbHjjxtvxqx2dFov9koSd3WeqBIi/ys17v554p8aF624aTEpdPRqqHQcwNmsohMi/N2q9jw+5uTJNF9audH0VG2u2ayL4bPALGQbyeWewFGqXMjpE1ZyrpLYSPRa1PdApf9OqjLE79bL4qLpbVM/61YDLQzGEyaW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series backports 19 patches to update minmax.h in the 6.1.y branch,
aligning it with v6.17-rc7.

The ultimate goal is to synchronize all longterm branches so that they
include the full set of minmax.h changes.

Previous work to update 6.12.48:
https://lore.kernel.org/stable/20250922103123.14538-1-farbere@amazon.com/T/#t
and 6.6.107:
https://lore.kernel.org/stable/20250922103241.16213-1-farbere@amazon.com/T/#t

The key motivation is to bring in commit d03eba99f5bf ("minmax: allow
min()/max()/clamp() if the arguments have the same signedness"), which
is missing in older kernels.

In mainline, this change enables min()/max()/clamp() to accept mixed
argument types, provided both have the same signedness. Without it,
backported patches that use these forms may trigger compiler warnings,
which escalate to build failures when -Werror is enabled.

Andy Shevchenko (1):
  minmax: deduplicate __unconst_integer_typeof()

David Laight (8):
  minmax: fix indentation of __cmp_once() and __clamp_once()
  minmax.h: add whitespace around operators and after commas
  minmax.h: update some comments
  minmax.h: reduce the #define expansion of min(), max() and clamp()
  minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
  minmax.h: move all the clamp() definitions after the min/max() ones
  minmax.h: simplify the variants of clamp()
  minmax.h: remove some #defines that are only expanded once

Herve Codina (1):
  minmax: Introduce {min,max}_array()

Linus Torvalds (8):
  minmax: avoid overly complicated constant expressions in VM code
  minmax: simplify and clarify min_t()/max_t() implementation
  minmax: make generic MIN() and MAX() macros available everywhere
  minmax: add a few more MIN_T/MAX_T users
  minmax: simplify min()/max()/clamp() implementation
  minmax: don't use max() in situations that want a C constant
    expression
  minmax: improve macro expansion and type checking
  minmax: fix up min3() and max3() too

Matthew Wilcox (Oracle) (1):
  minmax: add in_range() macro

 arch/arm/mm/pageattr.c                        |   6 +-
 arch/um/drivers/mconsole_user.c               |   2 +
 arch/x86/mm/pgtable.c                         |   2 +-
 drivers/edac/sb_edac.c                        |   4 +-
 drivers/edac/skx_common.h                     |   1 -
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |   2 +
 .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    |  14 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c        |   2 +-
 .../drm/arm/display/include/malidp_utils.h    |   2 +-
 .../display/komeda/komeda_pipeline_state.c    |  24 +-
 drivers/gpu/drm/drm_color_mgmt.c              |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c         |   6 -
 drivers/gpu/drm/radeon/evergreen_cs.c         |   2 +
 drivers/hwmon/adt7475.c                       |  24 +-
 drivers/input/touchscreen/cyttsp4_core.c      |   2 +-
 drivers/irqchip/irq-sun6i-r.c                 |   2 +-
 drivers/md/dm-integrity.c                     |   2 +-
 drivers/media/dvb-frontends/stv0367_priv.h    |   3 +
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  18 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 drivers/net/fjes/fjes_main.c                  |   4 +-
 drivers/nfc/pn544/i2c.c                       |   2 -
 drivers/platform/x86/sony-laptop.c            |   1 -
 drivers/scsi/isci/init.c                      |   6 +-
 .../pci/hive_isp_css_include/math_support.h   |   5 -
 drivers/virt/acrn/ioreq.c                     |   4 +-
 fs/btrfs/misc.h                               |   2 -
 fs/btrfs/tree-checker.c                       |   2 +-
 fs/ext2/balloc.c                              |   2 -
 fs/ext4/ext4.h                                |   2 -
 fs/ufs/util.h                                 |   6 -
 include/linux/compiler.h                      |   9 +
 include/linux/minmax.h                        | 264 +++++++++++++-----
 include/linux/pageblock-flags.h               |   2 +-
 kernel/trace/preemptirq_delay_test.c          |   2 -
 lib/btree.c                                   |   1 -
 lib/decompress_unlzma.c                       |   2 +
 lib/logic_pio.c                               |   3 -
 lib/vsprintf.c                                |   2 +-
 mm/zsmalloc.c                                 |   1 -
 net/ipv4/proc.c                               |   2 +-
 net/ipv6/proc.c                               |   2 +-
 net/netfilter/nf_nat_core.c                   |   6 +-
 net/tipc/core.h                               |   2 +-
 net/tipc/link.c                               |  10 +-
 .../selftests/bpf/progs/get_branch_snapshot.c |   4 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c |   2 +
 tools/testing/selftests/vm/mremap_test.c      |   2 +
 48 files changed, 290 insertions(+), 184 deletions(-)

-- 
2.47.3


