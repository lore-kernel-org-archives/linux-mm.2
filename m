Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2E7CD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C8D6B009B; Thu,  4 Jun 2026 23:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E248D6B009D; Thu,  4 Jun 2026 23:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A746B009E; Thu,  4 Jun 2026 23:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2E3E6B009B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:33:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 921151409C2
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:38 +0000 (UTC)
X-FDA: 84844439316.18.E841240
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id BEA784000F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="J/bLsrv5";
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9VRMQ5Ef8ulqUN7FHiGBWdV1K/iIYqxWaAhgeSwRK0=;
	b=2zNPq1GRyANai2ev/GCwFM8j2qBHqV9U4QzumjinSnKuNsMM28uo813HTZvNwwzcL4tRP6
	t+4cGIotweJEqoCgFzfSUM7D4tFcPdqDAgM3rEkeRa2Fu/dshSyw0Uqkqw8oyafi0E77GP
	gyOMwID0qD/RMjTGolwa5ZkPCTxVL+4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630416;
	b=Mj74PnNQP2OCfX20oeCmsG2Yl7wgxvEDh/OlhY31JRTgIU4I2mqtLNpuUv704N0Y6PQ//H
	bCDwqwShedCEfUs+qC10J2X7aul7PQabMrr6em/caUA584ir1onPGY4tLpRLPupTGx2dcb
	PlqAlTyyJ0H/vUmqrOrMavvqb/LaOyc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="J/bLsrv5";
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9158fbaa4bbso184759785a.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630416; x=1781235216; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J9VRMQ5Ef8ulqUN7FHiGBWdV1K/iIYqxWaAhgeSwRK0=;
        b=J/bLsrv5LSerT0JbDISXJ0el6n/ceJFw/YlmwyTMt2bGRF7UqXXYBrYMsMPWcjSRUq
         xWPhrcvp4gHTPzED21eWXyuk8pieZBkLLg7hqja5k3BMnop217N02gl8OWWKvafsH2MB
         j+EDnExVbuvfoGkGdqYq6LHRsEuQZu0hsFAndyts0JBfdRnQNyg2kWaI9m1EndlnZn7E
         kr3JiHCrzcdFBO/zkuAiyUvYD+YJp3fa7eG4QjqqKeiSOzATerLwOYeL3ZmnDpYCj1hx
         WNF57r1SNM+kqqze3+PLHcP66qTfh6KXbeHYKNGFKrfhMRHthAseb71teW0roen1kxts
         ZCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630416; x=1781235216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J9VRMQ5Ef8ulqUN7FHiGBWdV1K/iIYqxWaAhgeSwRK0=;
        b=WWKAvQ9zeapvGjGgcxiaqPQpXuKaze68U4FGF3QOg32ev6tRKUzsGWf+UVXUjLbzj9
         0ncUArvFRIOT8SiC7ac5BHH7UaF2bvn8KHoU/Vok1hwsyWbIR7Aya9rmBhIJwi+txWhO
         QUb1hXm/h2oaSlPu08EIh24SUxXc3m0KevgtrEA1U73KlikgMNchuv7VKb+YslGU7s3F
         4NN4KPkws4mutM40AShc6GMUzZ6UIY+r2A4aEh68n28z1Xk0uGgAyb8aAx8MjPSNYoU7
         3q/yp5gdhFPtERkiA/sWasBElzEmkjwFeDoDGZ6gMX+sBriC9qctdmeZDIl1mtWZPf4u
         CqTw==
X-Forwarded-Encrypted: i=1; AFNElJ/zr8g8E3CkN5Lai8J/S/zNoV9gCptKILOH5PkFAaytDzjS7+QLmCHXl03ktVfw6S1vr+ww8O+XUA==@kvack.org
X-Gm-Message-State: AOJu0Yw98UYmcgcAQhtfdRCgyxYI0GEEAaxCY99gCrkaNEPf7f5qvQ/O
	CafgYD2KaGaGchADbXVfhotsnQHvOQiPwBNEwM3KRZ9dwB1xaJaRC9c8l6ju5oW/LaU=
X-Gm-Gg: Acq92OGLDnGNOr7TGduapxt2yB77je5f5hpsxeCcJwT8qajI5j2wB9076hac+cKpSiN
	BUyqUBHfC+mpR1IbL5uxPkMILpzaXSJtRe4Njy4701sIVI0iwxAsFfbL8ROCljKE30OgqBKqZDh
	JeL9ePxuidtNIaD2dakk7m1ajE0mvlTRsPGwLFRIqeSi/d+bPBMOBsWkxBiBWEaxfzZ5emP/aSY
	QbCul8V+UBQTXD4Z3Cu3O12UEXVXBhQV6yGrlEi5ZoDiRv3YmX4H5bJ4yfIMORpu4b2kW+4l8I4
	fphYX0Ud/q6QPNmucXLPhXdmzEWHhvtAyTwnjokPS+7ZnE55WmU93Lzs4umio0ydELjYJKJAgoM
	UeIohiJoPeg/CM+/cFLXwpgbEcKmRwxMoMdunJYN5+6KT0hmXa3wTMb6tQvPuIr3YTt175YSFJa
	LTwlu4cVv21m6KwZv+1KObxhes5P8OYPQ5E8XcOxvo+LpQDgTERZoGE3umWnb1Cw==
X-Received: by 2002:a05:620a:3910:b0:915:7f9f:8d97 with SMTP id af79cd13be357-915a9daef8bmr376847085a.53.1780630415906;
        Thu, 04 Jun 2026 20:33:35 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37c645sm743050785a.30.2026.06.04.20.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:33:35 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 5/9] kho: move kho_block.h to kho/block.h
Date: Fri,  5 Jun 2026 03:32:31 +0000
Message-ID: <20260605033235.717351-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEA784000F
X-Stat-Signature: d749oy8wxdwg83g4n6adsag95cw1qtq3
X-HE-Tag: 1780630416-946571
X-HE-Meta: U2FsdGVkX1/O3RXU0id/54Bmd3259UX4KhMSY/ugLVsxg2WX3VLAKfN9hc6yiewgWl/bpjBOn9K6VmNCyAMWZEcTIf5oMqlno+XV3FCVDsy0crOuZHNJAXORruFs81YxNVvH1RgIRPnUAFA6nnmCKgdKD7NeqlxSnl/ZLeQPstnoSYZqe2hnOGOm1MZkf2mob+7XHJGyma/Cg+Ft2TWvD00katqwh0SUhYxxbctgbao2UCSQhO3XeksuM095CcYRihdP+yDRWEhbCUF1y00Ou+bRWeW8mURPel5tXr6d2DFsAVNdPWw3mbnIzl/4Ua+3E3h78v9FGGdssCQFLTKdPdhtaD2043VtTW6hXTuPGrzPwCEUjzky99oTc44V6cpVzr1JCnn5cfiROLfe1IkuAS0iTBUFSu3jK3ch6vTT5gGP4k4ii27ZFbELkc9MTyxWdp2ZRUfdZXYcsiBpksW+LWoJgfc3JnPgV3P6Mo4OmVn2Zm28g0eKgTsTDffewfmz8oBSgrHYI31qut05FrvVSFqwu4gWYSsrydBVZhCMY9WHMqWWhcsgEroZ38MRMVdrgjiv5CCjmnhBYF43hvbkVWwd4JsasS8x6BlB+GJMxiaV8glbLU4Sv4ag5BRaBMYHfYFXpqY1Pv7sHr0c1BYDcnTQO+7PKFLtnFA0aITzMU55zWlZYeLQ87LZBWcSyH/9eK7KJoTp3JCMqIGEGJq2u4ciFrOaHU+8SuofMRGUz4TPsuI4hOdJEb9xSKQYT+GMpLLobbgcHrj+EHNAxR9jl9pwguZIELg1QIny6SqKluia9DyYX8gagINGEeOMhfE6vsH1UP2YJpohKPKatbnQ9UiaPPV4AzSBLfGH2QZPz+EfsVssExKXPwIF5S/p4r/0a//KHRECKlAY9gbsEFWjg7YOhVafASo8DTbnUmSjdEH9X03Hgy7yDhmx+HF9PzFk44OVNsEk+d8axkSXxw8
 lKHk6RMW
 TBZmPMpQAGAt7/2X4yf2AytKF1d9Muf3PyDY5nY21spUYZmbSqvkiRsEt8TipICC1u1KsDRmw8qeSKygVW+75P83ewzO6tJLE4KLTXNy7hjHhliSRHo+ZNGgVnikKbHU4VFMFcRksUD1FrbUUIF5TbjWbee51J2+tRq/z6qlaSt+lCOK8yTG6s+xfJmU6Jya9JmKBGBhIz6CGL0TcPQy05o+3te3QLPPyXt49vvpmekW/Twrzbg1b1MrYhB0u06tsPGYbcYWpFblx2kRKCTuq1aRIP/2wViCy4Bbki7IBu4ds4sAHt6tFDwyqCfjNQdr19+FrnkGeUcL32uMOFZgApc42uXhiPr5oQyOkr4XZMc1HTpBxtODCPfwqqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move kho_block.h to kho/block.h, organizing it within the existing
kho directory structure as more KHO data structures are introduced.

This is a pure code movement patch; no logic or functional changes are
introduced.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/kho/index.rst       | 2 +-
 MAINTAINERS                                | 1 -
 include/linux/{kho_block.h => kho/block.h} | 2 +-
 kernel/liveupdate/kho_block.c              | 2 +-
 kernel/liveupdate/luo_internal.h           | 2 +-
 kernel/liveupdate/luo_session.c            | 2 +-
 6 files changed, 5 insertions(+), 6 deletions(-)
 rename include/linux/{kho_block.h => kho/block.h} (100%)

diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index a10b10700fb9..4a5477221fe4 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -95,7 +95,7 @@ KHO Serialization Blocks API
 .. kernel-doc:: kernel/liveupdate/kho_block.c
   :doc: KHO Serialization Blocks
 
-.. kernel-doc:: include/linux/kho_block.h
+.. kernel-doc:: include/linux/kho/block.h
 
 .. kernel-doc:: kernel/liveupdate/kho_block.c
   :internal:
diff --git a/MAINTAINERS b/MAINTAINERS
index 920ba7622afa..9ec290e38b44 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14208,7 +14208,6 @@ F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	include/linux/kho/
-F:	include/linux/kho_block.h
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
diff --git a/include/linux/kho_block.h b/include/linux/kho/block.h
similarity index 100%
rename from include/linux/kho_block.h
rename to include/linux/kho/block.h
index 93a7cc2be5f5..2b9d5a080a6a 100644
--- a/include/linux/kho_block.h
+++ b/include/linux/kho/block.h
@@ -7,9 +7,9 @@
 #ifndef _LINUX_KHO_BLOCK_H
 #define _LINUX_KHO_BLOCK_H
 
+#include <linux/kho/abi/block.h>
 #include <linux/list.h>
 #include <linux/types.h>
-#include <linux/kho/abi/block.h>
 
 /**
  * struct kho_block - Internal representation of a serialization block.
diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 0d2a342ef422..6cedcd36bfd2 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -23,7 +23,7 @@
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/block.h>
-#include <linux/kho_block.h>
+#include <linux/kho/block.h>
 #include <linux/slab.h>
 
 /*
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 64879ffe7378..349f6d141873 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -8,9 +8,9 @@
 #ifndef _LINUX_LUO_INTERNAL_H
 #define _LINUX_LUO_INTERNAL_H
 
+#include <linux/kho/block.h>
 #include <linux/liveupdate.h>
 #include <linux/uaccess.h>
-#include <linux/kho_block.h>
 
 struct luo_ucmd {
 	void __user *ubuffer;
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index b79b2a488974..01c0ccf09919 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -90,8 +90,8 @@
 #include <linux/fs.h>
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
-#include <linux/kho_block.h>
 #include <linux/kho/abi/luo.h>
+#include <linux/kho/block.h>
 #include <linux/list.h>
 #include <linux/liveupdate.h>
 #include <linux/mutex.h>
-- 
2.53.0


