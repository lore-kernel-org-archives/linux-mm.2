Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49C2CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0038E8E003B; Wed,  8 Oct 2025 11:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6B98E0002; Wed,  8 Oct 2025 11:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDBB8E003B; Wed,  8 Oct 2025 11:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C23A68E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:35:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C53C1605E8
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:35:01 +0000 (UTC)
X-FDA: 83975345202.04.ED9980F
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7A2101C0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:34:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=cUvPQtYi;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf21.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937699; a=rsa-sha256;
	cv=none;
	b=Y90s14EO3RrcOS0TxDBJ4Aj7iV5+r/jEQGLk5mA2B4lXrzd/Zky4D/Zdeue9n7c5Bjif8c
	gZebD9Qbbml+LHctdT2nOXn9t3pI7qvSf1Owgkotez4dSsdgZLZzpp7VKVJGyxiKlKfsSK
	yVojhBBdu1HB/qaR7jF+C4iIKkHUrKw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=cUvPQtYi;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf21.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
	b=iVj4lcgk6iUaI8n+FXLvG9jkEhHmbGORLu/qSQdPATSLgRMkJf4Mn7KuhCVZru1sA11DYL
	mesemA7+pnJnD4yDqiBor2irNTueKx68OgTGtFnLsGvpe0NF/4vtdQIqdpKZmrGTxZqjGF
	wiMpqKK63HZkVqSZpDRp9CbALiqsf4g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937699; x=1791473699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
  b=cUvPQtYi1B4NKZOejLdG6G2+LsoIvSz738op0hG0AMcZPBNBioFL42DT
   uQjAY2sVRMW2SqDAvhdgT7Qp0KZ1iw4dXb0mJuxZ/8rsMqlcTlBCyX11r
   UD+Kx9ElrTeMMLd1tK1Aj57vJO/K+LsTUT52jtGhhMoV2C/i04Ryyu8Y/
   2tv/ikYI6old22Su0WnYiUhZRfYWV7GTKulCIdYcl6gibNvgusiJ8sEYv
   pXCRnF4JiESz0aUfgrbyiyVffFxg4Bjt9WcqeldwVtfd/HU4cuaXD9nxI
   fRxIhtbAwP/olN1Qo4ltdAEzt/NCOUjAujrO+gEbsPHnm9gEAFRGJ57+9
   w==;
X-CSE-ConnectionGUID: itXPK2QGRGuEesBR1wju9Q==
X-CSE-MsgGUID: b/4WZRnLQniBVTX4zCZo3w==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4410925"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:34:58 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:46428]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.225:2525] with esmtp (Farcaster)
 id db997045-828d-4716-a451-8921ecfaf1b3; Wed, 8 Oct 2025 15:34:58 +0000 (UTC)
X-Farcaster-Flow-ID: db997045-828d-4716-a451-8921ecfaf1b3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:34:53 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:34:39 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
	<jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>,
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
	<linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro
 Falcato" <pedro.falcato@gmail.com>
Subject: [PATCH v3 16/19 5.15.y] minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Wed, 8 Oct 2025 15:29:41 +0000
Message-ID: <20251008152946.29285-17-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: ba4fstrmfstaohqu1kfabkfd7drgsmm4
X-Rspamd-Queue-Id: 7A2101C0002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759937699-14650
X-HE-Meta: U2FsdGVkX1+XQ1qZwRlOvsmhrM4t88nik386Mw0WEGND3qTwJJKiSWZ1JnboL0aFB4ivhOYF8uyFNnyqwn2/GPMwTkJLZGL/rU4+3CzjEwdTewvFRwBg+XmNbJB74q70KD4xImSKQiCU5srkNb6d8CknBqIzn4tLGqErHMV/LAe/SjvrMEQz+XUSeqZAjsECf6X3UYchKASSOpbyPB9QZ4HfW/ecVKQOzX9LiOpsv7OjKeMyC76et3KpXXCtc1sxNL9flC/RL+WzdKoRk8RodNDLfLcnC4jx6TNo1Dgftc5TqQ40kFJzuCIemp/ZYnRya9MXFqHN20gndWxqeOd8aXGUQCG87BurHDD5pCF148XCDR/659T6idZV/Z1XiBH2qxUEjzhAVuPft2DfE2XZMqf9TYwKLKF2SdSNhTh9gNyCCaScKtzLkqPEKuSOZHMS4vFVBfINhOz+IvlsHjla9eS3OELq6kbjtb6l8reT9IZA6U+G+wmQQ2Y1h1+oMwTJZMPx/vBsDwaxPsP17G9djauWqrRr8GBUIPh5gSKbnu65LazdD/x5qbePYjoTXK5JS3NgQojpzzrnAmaXELm1an2ILyoYVFtS5+x/GzRW3VJ9omfKSK2MeFws9TaVnpmB6mSdc3+kx4b3yXseIuvzpgF/gDXUPiCuCV5sZDmchZtzsjAQ9FNFjXkdcmS+/toMv/3Y8TqqTpv/PibyzESmfQR4ScvjpxopkLp4FhQKVr+YsrEBFJUNJRSqJ4hmtMaAgxmcuUf7GJC3N1gY1cF8jmTFXONLf0RhXqoU/64eUWK3YHNn2K/uQsDlzjNPlgUthzY90uIqZ7zCuxc01DxUgdpIVeL/4hLyLIto3wqqvFFdvo/ETDCDwWvGxbXFzbXWHSTcRFdNz2L2oRklnr+fUsRAl2+ZLMZObxDuh4MjH3lY0o4293XUZVxxhZvFMDyKkfBPXKjLN6pMeBiYfZd
 ToUg2Odi
 E8fSHGN31DuaNxNqGOjQnTtBD6JYJuqYs1sZdPzUTiBE/4xslF2Lk9VSw0c9T1BE6PogYSpwEfAfHWK4L7uHOyW/fuDuSR2MlihNWaesMu72TyeSHtAIdUsQ6Pi79hcj2/WThee54psagSR5DPirbeHgFgKXpdge9idd2EVOJkauLX2Wd2OsclM2Gq2YMngYa8cYHTiFtveyhU70giZRjaBchQvJiy9/lmgB4msEtYYTpX3n2YRBDp87YacVSB0ZDLNNGTBj8zSPC5kADN+fUjw1L+E46xTBj0T1MrBRBH35/yjzDjgw7cYhehc/W5U7I+8KQCPqny4vTTXdCNNNwSEkxvcEZUg7kXpPUEVXVdM3K37CUtOXXhNTKNjtSrxDKGwmzzq28VZnQkTcgzqhWXG4Vvc1qTB930Sd9+7kSV0Xs37+juqw98h74emVa4UiQPiALa+BXL0KpZkRbbm4VZfCC5U9O9RZefqW68JH+35ShVWEmnsVps32p+QJn+l5SVXI9uqwmbDO/f7HXMYETVg5x4sGEPF6wJZMZasL8trpTptW8rZgYNuRU0xKqRsT/LUqj0CVSUCVLepx6OTNT36+LagBAr3lxUPckzVOp1Yq7yCtANT7jAp9hUfE3dXbDn6A65at2lYrO0xqQcLam0ZF9LsLadsVodgEXNpqAijsK69IE/MIZLMDQuA+LSLCRVgIxjuy4KM0pONwyolHVdPiuMwfGdJAUP2+Qt7tzKgnPKMDmdvwvPf4sNf1hL6Tbs2+6rRDYLH4VYS8eC28weVZf1Lz95S6vZnsdwhVrshTeT8rSKqMx/5hf91jvEB04LxXjNmacrGYDwPwCULrEK4NXBCD8ZqtP9e7LkB9A+USO0razRc2AyC6gseEqxUl0lOSHUhrlaI42+0iJVsBhngIpdus836HCmcHxLd0DTypmDktezCPkclx+GbN97Wqz2i9tLmnpPdMUTZbx9wQdGDTh2GdO
 w/40Fbat
 j1b4kxAAflltXj/h4BqT/ABSJXP69utvUWiEZX6C1oQBVnd48RinNYvN8mPmiQz+tVqLm42acufNVAW7Z+jikdsMB+wEXJdLJx+JJKcwy3ys6eL48MVN5eZkwnNSuy22uh1FBIzTRpsFmt2iNkDPqyg89/8BJngKmvUxDXOEYvKGrB0mfbE9LXBEzhbStB5Nc944aXh++OvAbVvLaH+e4D251SWCjaa2GOni8KVKiyV2xTZYlJaCORtWqixducylGTbacqiRqYwer0ZKjrLlVJfyYTxCkwBFl7p93FzHCf1SVgHKT93KFmqgBCOzbAZS
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


