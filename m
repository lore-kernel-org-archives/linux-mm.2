Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B70B6CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1533A8E0015; Wed, 24 Sep 2025 16:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103E78E0001; Wed, 24 Sep 2025 16:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DAA8E0015; Wed, 24 Sep 2025 16:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB2CB8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:32:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E963B6E68
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:32:50 +0000 (UTC)
X-FDA: 83925292500.23.9F55CF9
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id D18392000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:32:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=eJARBKEm;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
	b=6EfHIkEdWgTMUucHc8rMuky9mcb/57fNbXruHQ3DV8G3cM5EGp+yPB1AuQSkJgGasmIPQQ
	HSBiogVanA4v4lvVWUOg3cenu97fMeFXyfUeqHlhb5MrNWj2GI093Cdmfhbt8LBQYAJ+Qd
	cv37kZGGYzp3/akwSCUcPZbv5B90oVA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=eJARBKEm;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745968; a=rsa-sha256;
	cv=none;
	b=DRymFpGNMjesQvIo4AjFGCu2R62cj9h9EHDtzubzauOSLriBEQCqm3eRs2jC0xSWL8S4GA
	JaDES5zbQf2GDEC4V5SpRhoJoAO5ddhWMMOFPOv9gNwrecWnR4YFgXlG7Ix53vh+MAQR1w
	7IEx2o30uCtGl3ONcHBuRgmUbZbvPrM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745967; x=1790281967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
  b=eJARBKEmzXEYiYfRWwK6GK+rf/IJ82m5BMOG0JfpHeJUATclxjPFKZfs
   /fthobZ7d3xkgJcefXzeYrengL63FC/sPSNVniYbAZelVD2RCcJPaVt28
   NdjqicF/38hcCXOJpk9CfeJteL1GeoHNthTEiRLJI4flCXpSjUPyXLNn4
   ocRd/E2WgK6VjkO2SYPoU6J3UGqBxxzSFKDuDz8GNeJcA1uqMBd6pqyhz
   7HJEGrwkXm6OIz96wLQ2iV/EfOCvlD/a9bfIANQiVe/ZibLmH0mOMcGxN
   TyuVK5BuG56pRs9P5I5mxanLcfbw7OoiApUcEKh59OQ5pSncFmwjjYRsa
   g==;
X-CSE-ConnectionGUID: a9rtJO3GTWOFzT3IrRvO9A==
X-CSE-MsgGUID: v2Hjz7raSaaE9+zJCn+NJA==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2525303"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:32:46 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:24308]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.38.97:2525] with esmtp (Farcaster)
 id 0bc2316c-0d9e-49f9-a945-7f707cc31df5; Wed, 24 Sep 2025 20:32:46 +0000 (UTC)
X-Farcaster-Flow-ID: 0bc2316c-0d9e-49f9-a945-7f707cc31df5
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:32:38 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:32:01 +0000
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
Subject: [PATCH 13/19 v6.1.y] minmax.h: add whitespace around operators and after commas
Date: Wed, 24 Sep 2025 20:23:14 +0000
Message-ID: <20250924202320.32333-14-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA001.ant.amazon.com (10.13.139.103) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: D18392000F
X-Stat-Signature: awtkx1pxzn8ih7crf83cc71ibrtybir6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758745967-845677
X-HE-Meta: U2FsdGVkX188hDBwokIxVR/RWuxS8faObgdZ1Us7zuFeFokf45ts7ra1BGi8BKSPB9XftssTwi24sw4HZSYQw68WeVjqK61197P8yTSZY+TFGzqxZONBvcL/LywbodcGSx+wA3Tgr8oa1jQxneaoY2bBO/htGh/66DFX3RZdGRhy4bWAyCd7kss1JUqlUAEkBDxd12ujcWzVOezi8F7aGG3eR1PQ+RQPu5WzXQ7P8qvy1APBpj1Jk68oMwUsBNVELMh6P9yHZdueOI2Rkp/+gLfpqmYx4utDzQ7gso5lFS0iXxq979FwLHNBci7WzcYU9FLqtMFIg6rwRZ3QTtB1kSemvO44jdU843IRAvSknM7hdgeMM+u6f7nXsQvyZHcpvZLhWkbYGf5Q3PN+w5l5aFvhOx4bgIG3v18ZxZ3NcGannqiGMFLWwX2CvS2JhUv1ue/UY9zVv4vQ5ziq7188CcOqx3xGyuSPf2AVWDjFk9oNuEcTIi4s2KZRszGB3KfieGVOrPr3OJtAqxDUCabSEj+nvo4xtVgVUhtdyt+VBYm/VbI4n/X5kt1dE4iHwU3mMtzxcV+SdzTVxUXH+jhgS7++F9ruY5o/JQsVwDBAaFj2V/bYtHXQ+XJJiVTJ5A2CtIQLxqpBlbN2LQqTvKrccWoaYYW1LQnujxW6tXbQ4z/awQ62hmiHSpmF1AkR9nn1c2ieGg9tDq/59tjqKm9Nzc25484GeQOCP6Laxum+GjIZVjTz15rxANX9vZAixt9M5XI/hhgg7UfkJ8lOMeTToGOmUzTlbmhzm3aRLyyuEOK2B0g88/4bsataH8dvQE4WefYrX2rqnt6tkn3hhylec9CncRuJufz95B7x7+TIJaPbngEfYua70LE+Pb2XGvpWUaMYN+6lWoUt2xvZvRnZAvCJs9TIvveQX7rji1eG9KvhUxWRd4PD0AQS5AyNHph38J+8AkTGBJaP1gQLH65
 unJoQ4L4
 FDZV7VaMua8zs5M5xi/gQQfLXdubH2Xv7ScJYjlsFIl23Gu0C+eiXbWYGX5QOJKoJ8zFQIt2evvPcg/b4krjGK48Rp4nyXdDd52zfxqAzJfG1B1Tl8E8DcSTLMR3e+EX169aKwJVlrcKewaTY9icE7gBeUPI6jXBl15i6nwY6qTzaxzmR9uu8VkfcFWLFBWdGjlb2xWWftH+WiUp9vd1iXvxjSxCCwaLmjEzcqle5yVKT3HpFs4DdPmT1c3wHH2InacY2kY/za5xir1Fxfrx9cnPatxj7GBPmMUPqiq38WApWEOCAKmke23fThhn4UvbZ6A3ST//av8w7LElaXUUOH+P66vTh+mG1zOnnOr2frD3ZOIXYnHcEgCl7oOy0rXIL0/1SHbrLWXVvBAuhXyBjeWjLwPD4kuMnWOmczuexwu1NCJgE7N8JsSHkTgeRNL37xAg6DSeH0R0n5QaqcJlcrEd7DlHjNjbVrqfYs3q4f+T0WQoEGjsW0Kbn6ACgXj2WdI0oYMvE1JqN+CyFVs+sCiv2A4O1wQofulVq3W8KnWSVCReroG2Rv5fRYXN9Ft6E8YLkpRuWR28wUQH9p74fQbz3Da8kZjwNpy23CA1tqHZv7Iy4IMv0QYs67znf76kS6thGkfs05mTw/Ju1/423jcVk4iOAxCk/zLXdBOjFKSD4HZvA0BfLbsI2cI98tAU70LAImVclwj/3ccXoSxQ2PMK0o+FLES7Mg5tFM1aIMJZ42DMT+wSujAOVCBds5WKLQH6O8IC0GOB+9atHgqkt7XzfyOA8k+3IwqnFQQ4PMk2xSz1c5hsw6/kk7Vw+qMHxOX1fEggXKNGArV47Ydor/Rv8Su6p5js+om8c0PwvI5332b+EDmt9sF7TFst583vlwFv8qBEt2TsIe7KdbDqcx80eR1wjjnQbIVJGTq9wLfhWwuLTUZaIX4CK8EC2IgKGBU0tegbxVUtzSt7ampbchuzmUlP+
 na+9GH4P
 1GgDQF/O9Yr7QM9SKg6AvfE2BWbBUDwRKfNJVfPejXJn9Mgx/d+3a/JKBGgrAZ7KRQVdHtFKfI9FZ0heWdEZcgcWHQJEl1ELnHh6W4oV17vqVlcTHDg3RaQoLF8sM14r0A8bZMmcU51VhYGgFlcR+A40Ne/GVv2cSLneSVvS7VgMN6TpYzd/ttXl2i1heqY5sjW8An4m3CoLEpWYGPjIgajN3jkHUma6lcEvG9PBxEKTygKA16SK7GFNNKHs84Ti6pTrICYOrdUkGrveWhjSPfxUE4BK3SbbuajXHSzFdQwX3kRemh62Nz5Cupd0Y/pNUstcLNFC1lpmbhn3AGUC0MRiOgwssRDH6re95r+ibQIp4a5sIE5MnClrjlnc1I38WAemDvtdZQNOg+mrLvFq4qy238X0PSOafzMJpVUvk//zjZnah/tQI5Mh2gngfZxvtSdArcULvWFx2LCQu5DE+L09sWdHyjK068D1QA0GJWf6tZMjqGZij8u/zmIdCMwagoRvPf8C7iTNCPn9q6Dh86+cVQ5lCugobmAB8ulHK3sS3xReR8PcHdev6IhBMs04svMLPoaDKLULNJBZDN8jjhfleSzot52Rt4kRL7UqWUVpJqf9toP3f4pmo/6q5fuAW0KWMB6DWNt7FUlm1gUh3pOaqNChEYif/Tf4l6VmbsEMs1iDHf1Y1PjAkviemh17Sj9yHoK4IF8X+11LGKnW7fgYghkZgO+28sjikLJykpDjoAnafNu07i+U/1iWMyo6deCxWhpahbQcYgk6qIsct52vFIzvn7wMfM/hZ6JmMocOHpALbgHCgm5sab8K169oG/t4UZY37a9B/k8OxKfCW/EMkYouZ1sy57tW6d3j92dQs0SLsufhCXFc3ZQWeQPQVi4e3d0cIrHC3UCT+n+Y4rlhH2N+hRwJuNrLf9cjaMhDl7OQJteM/aTfMjBJeTShyCwqX8VkOmCTOwGZ64ljmVc+qR7Tb
 M+ihhTgF
 GuTBTNEm26E9oJDmlhVv2rqf1jimlQvSv7DABsl7hkVKWdCVVYcR6Dd8qmMyLCWMEoVAVjkUw2wa7rLB7MJEPVV11LF3iIUWbKG/VA87wLwPkydR9SJrFwLKDxnRDDCbkTZFGiGEi4dwrZyYaYNouIHxjECx7+3+WPTKIbxyj9R6/vzaofzpEVSIHfa0bU0sAlwl0dsXq1X1m6kv2SG9nwzUW7Uq+xiKGhGqhD0gNFyv4fP1KzGlE4BgfzIZXi5fE6UhHsshv+ivtQbyLKFhyeZfIELSYTY1bs9x/pj8HiV4E1jkT21RapHswkZd9MSnz4t7nuG276TWqpBxgVE0V8Kh0ThRPTAqZ3kW3axMZ6PkDJEvHIY58eWE3cz62yVsSOb17KX+9HRDlvhU301LhcTbrKx9XdoMRSmb8QS/Zjn3hfkzKqMO5TX4Abf5YaIBVW0astj+JGFXdeH+n7FOpYJkpjblm8RGQiQy9+XehuopY9Cq+clbSTOttAMThTSyYmJ+ghW2CwukZU+ZpZ7Gna+jF1M846yjo9efuzrG5avKW3+WAMw0CNztRDHNUaicCsLzvKtRPn2oih9sal+6lALOnCUiSj6gvph7UKK626E1QYzk1pqXpEEuTv+09PYVIugGGxnqS42MQWXDcgbqwNT9JwpSkp5LLlFloWTHaToIGa/jxOhh03t3z1n6gaVbQzQCmpTANHFP5zs8jiJ+uxS5kNGi8xuc8Yd49vL49TnVhRT9Y0DSBOZB+YS0HQLbfHOvIcPbcSqZreTai19SPiPqoqWEkmhZPWROPtTOUkUcPQ4txR97aUtpwWvkW0ItlT5z7rFlcGGgUlWGz4PVGA+Ici6GsxrrOSmQOuoQ8oKzYVKANaux0f0vRw2z6sOujC6k0Ue2tOf7q5bnRDw7qOMhJZ2xlhZqojl8UDwktnbnIyRh6EHJmy1IQxpznULtDLfGSFcW5D2Bo4ktKgJ+cDxy5LgZy
 fpM4kjp3
 B39ImrxEe3u5dcEVp0MsX5kCxewMpueYO1DVp1/O+lEWlHXOIiQahk7ZNeQEfY60kLiljq/gtNkWcDsYqIdq6ZH5Po/flLFSWdv73ROGDCWwq9CIOmf6VuPvOlDGsGUVilIUQodDbqfH9+r+YJYyL3TpCQ+P/urVTxp3E363JaFvtvqKItYiLQKOhN8qKn1qzdQmrzq1R+icenZmxiT0lT/lzZITkv/i7l1wLki+jW4g6+qXl3yTGCusQl7m5EBa0vVX133RSp1fB7N51IcfzR/Xu6Tgfa3YpJ6bt+DMlBlmepoKMznX7yPX2MkXikQU/S+pDBkcniwTBxyw0rO8fVA/5Y6DalndUnteyruUCSB0ibIKfM0orEoqhrAAF5D97q+JUBHFJKJahJ9NwVJNHO5DHNwgdSGusY178xYihqGyB6z6b+cPjCAfWQ9cgQGTs53PlTrUDLjY4DLvnVALqX24+OY4Hlj9yUx587NpPKtgX1zRKGHGsVp2rO3sx/gfedQT5iTblTJlcHsNfcB1WtDjzDyQPm4clYxQQerJo1OGiTX+CILVEJS7xSxR5qqkUbCeknt0tM+EtVNWzMkJaz1VfvgtLZXEfOeW7mjwy5FAgbGgo5MhUc8l3+652ZGVvX/kO1NwT1S/aFx4O2f/sbb5zVOKJfSNQujxHc+9q2dWZ62IdgHp4lxtnMpYw6TAFvGue9s+P/1nY2Hjs+2Xle4+T2HlXNkHBvyBePoVQhuuNhyrztLKzNAwtuWliOVxXg/Z52kcjyGyYfVlHyv1/UiuLx7P2RwJNoE5pJo0SSn0WdMKvGh7sIUTOrQakCUt9i0mNCh/pz6YUPAzAhdFORNoXnidAzeH4emlQ2apD4cF302MIwghZUuSPj53mMFCBS6t5709DgQ4jAxpTp/D5amwMxrctPy+d+FCOTDHiHLEDwhIuHFu068ckBCFuDqfY1hhoTJkg6nftXI+aRD4SMmAIS3fS
 5hUpSe7u
 dhtCVH2WxBN2h9txxCTiGchOHhhFuazrNHlFVrYNHk1Ln6CR9lOpyQvKIyVgERSToy1doa1N3be4DCfCNl7LQ9MLEH+ZZ4FQTQK9DLbh34KZd7N2vAvMyBBOSC+atGPHT0t4MzEjbpkIJpaGbM1dyy8M/Qpi2Pz/qqRuAPZu0yhX4/wlUrM0SoFKUr/sSUeiDMCU/1ClF81pXBNKUiRGeMFtzlQTp6C/eOkDBRx33ECqqPnufEdlynSuTxc4/AmRvsis/EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 71ee9b16251ea4bf7c1fe222517c82bdb3220acc ]

Patch series "minmax.h: Cleanups and minor optimisations".

Some tidyups and minor changes to minmax.h.

This patch (of 7):

Link: https://lkml.kernel.org/r/c50365d214e04f9ba256d417c8bebbc0@AcuMS.aculab.com
Link: https://lkml.kernel.org/r/f04b2e1310244f62826267346fde0553@AcuMS.aculab.com
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
 include/linux/minmax.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 98008dd92153..51b0d988e322 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -51,10 +51,10 @@
  * only need to be careful to not cause warnings for
  * pointer use.
  */
-#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
-#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
-#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
-	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
+#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
 
 /*
  * To avoid warnings about casting pointers to integers
@@ -74,15 +74,15 @@
 #ifdef CONFIG_64BIT
   #define __signed_type(ux) long
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
+#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
 
-#define __types_ok(x,y,ux,uy) \
-	(__sign_use(x,ux) & __sign_use(y,uy))
+#define __types_ok(x, y, ux, uy) \
+	(__sign_use(x, ux) & __sign_use(y, uy))
 
-#define __types_ok3(x,y,z,ux,uy,uz) \
-	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
+#define __types_ok3(x, y, z, ux, uy, uz) \
+	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -97,7 +97,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -114,7 +114,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -154,7 +154,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
@@ -326,9 +326,9 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
-#define MIN(a,b) __cmp(min,a,b)
-#define MAX(a,b) __cmp(max,a,b)
-#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
-#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+#define MIN(a, b) __cmp(min, a, b)
+#define MAX(a, b) __cmp(max, a, b)
+#define MIN_T(type, a, b) __cmp(min, (type)(a), (type)(b))
+#define MAX_T(type, a, b) __cmp(max, (type)(a), (type)(b))
 
 #endif	/* _LINUX_MINMAX_H */
-- 
2.47.3


