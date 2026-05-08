Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B99CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF746B00FC; Fri,  8 May 2026 02:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6A86B00FE; Fri,  8 May 2026 02:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD416B00FF; Fri,  8 May 2026 02:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7DBA6B00FC
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:08:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DB151C0619
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:51 +0000 (UTC)
X-FDA: 84743224062.17.F135862
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7327CC0007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Q/32bRy0";
	spf=pass (imf22.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778220529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYRirjFTjUvafOj+0puY9l5IWTCm5/8QMipbtzzjFcI=;
	b=LfR9+dCP8Ua0HJnWHmJ4st95qVnekYx53nLzgC0+VRueiYeKVLnXSY+ui3C6Teb76jTYfL
	fbgBR8GCF5Dp+bfLD/QNh3UsT+fgswd3GixwmpVFedEJwrjjc0J4ecH1zpbz6P1i5UawY8
	acDi1FdRI4cMtKpCLYQfPHLbdoAbSd0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Q/32bRy0";
	spf=pass (imf22.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778220529; a=rsa-sha256;
	cv=none;
	b=TfUhTZqBMVpRq47fcJAyuOmgaq+SYiZjPWoMT+U7ks/cp4UfpUj6eoyVPKKmJ2iezqEJ+n
	h/m+iDoK8j6xLvYAiBXgj3+glPapgx74ZuLZlDhTMt7FNEnU02wysL+a9nThM+L/U9qNtG
	qmSxZ4hxAeF1DLAEByFiYNmlcpzOIL4=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-365d4d2f9c1so1057337a91.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778220528; x=1778825328; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYRirjFTjUvafOj+0puY9l5IWTCm5/8QMipbtzzjFcI=;
        b=Q/32bRy0l4e1yevt/f7uWRaYqU7PrU9hba3gimJ2LYCIYQw6vNKQCk7ImoQ63N+Upi
         WT3R7bETQgxoXZnMeMwJb+yll3sIOKehWxmKqPPdWOT+FFaVspEcWX8TNd3QU1FRjSDB
         PdyqPKz1w65gj9lLTa5W2TF6bYISe2AnGCEhuzWlXaAoLmf+I+ThrW2sR37D0GVIcuJe
         DW/Cdrruj5rPywll1GJ3OTvoBKaM8981TyP7EDZA6d1Fz+f4F+Xwm30RKgMucvYEOBtP
         6s3aqPfNZVXNVnqrpg0wyl2yOzGZMfRQRROhx7SRYAF/YKY5NpKfdORcsdC5BLpxWkIQ
         jwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778220528; x=1778825328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lYRirjFTjUvafOj+0puY9l5IWTCm5/8QMipbtzzjFcI=;
        b=EhM9dRzvWu1Aamvid1DrSQaT0GCtHzCeoiMTGMQOH+tPH/2t0Z4MnXe/nK2bMnWfVy
         wmet/2LzzZC0cTeZnqMV9h3D/KsDhEeUvEO3x8CyDfCImkY5ZvIqMv35bXicAHgPk8xa
         N+tspJDhegpq/tpLD6L2lT291Mglsqk1a2m84uFSo0lHHyL26MqWUb716lpdHx4DzWz3
         J2c44QPDPVW7ANW4LQGI9a85XSSCqKqOIBaeggAt8Vv4/YuRAE772hlk2wDGK2yOaYDe
         C35hBkdt3YRzDjhQ621whAvGEfAQIy6fhZ3gB/SPB19GTKeDkhXTMT71AnzDv1oWaJWa
         MDIA==
X-Forwarded-Encrypted: i=1; AFNElJ/iayOxinCFO+10PtfrQLf6wWH+LXr4eLBnglrEXSSEdWI9PZjaCLUWoN6Y5nVvkqR/+/kBwYzhOg==@kvack.org
X-Gm-Message-State: AOJu0YyzQq1IDmFpFsbM2rn+5Jr93FN5kPaz+M0kZad1Sioyy1dD9bpa
	z0wzWhBDoSNohz1JuMy94djohdLABXTLm+TwCUApetHWiBJAY5vmDkZC
X-Gm-Gg: Acq92OHOtAR1slnr655GR7uVZELeDI5OnL7/jMt6DIlV6VF2wj7NSOk1ot4Uqb2hKf9
	fgTyymz8G+Gl2p3SrEN17ucf3osv3SV9gOfWrO7u8f6TGPc/pju2FOh7pE6GvKdeRonnMtpIvSB
	npQFFEnkddrtJu8bd5bScHPtcJ6pBQA8APg+dMPjMXf3i8kq12cri4isNnoJ/ofkAyZXzv7V6rK
	hccnuoi81ypx6Ax1u4BKItfDlZoaPXkpzyDad994xRG6n87hZqaUKKPoKq1Drn+5AKdiuY1wPQJ
	XWqfw2PIvOwVUrVEQOt4+3DfEmsFL9cBJhfgLFHy5RMbcm51ZWc6PFy5neE65W7eEeHqH2nTJdF
	EefzxKapUGsios+jrfpgUy1V7bVvgZN3SGsHMeV766C2ZivKLUVrL2Z/pGhBTysgTc28MBXAieO
	Cas8PCTAoQy6FMru5Bm6z1jdEitu1in74WsH0whg==
X-Received: by 2002:a17:90b:3805:b0:35e:b017:da6a with SMTP id 98e67ed59e1d1-365aa73cc81mr11744580a91.0.1778220528288;
        Thu, 07 May 2026 23:08:48 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36645bb9c02sm673651a91.1.2026.05.07.23.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:08:47 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <21cnbao@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v3 4/4] zram: batch clear flags in slot_free with single write
Date: Fri,  8 May 2026 14:07:24 +0800
Message-Id: <20260508060724.3810904-5-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260508060724.3810904-1-haowenchao@xiaomi.com>
References: <20260508060724.3810904-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7327CC0007
X-Stat-Signature: opt6sydr9cu5mf16imyaogs94ufgenph
X-HE-Tag: 1778220529-631929
X-HE-Meta: U2FsdGVkX197OGIzj3sQWrQlJxTAuwreOk+/+c7R9wr6q5L/uu8G3qLL0gddp7whZ4S/zI1xftgG1TjkEVySWzdwov0pG+bJ/agVggK1su2K5YTbRH97P6+ISoEnhHM3Xfar0sn5gcNVaLnfPuhVxSRqPht1WLFrCuSXqoBVUXEs7aHgA+cIZ1KduKes1XLpZRzRHjpL7+x+ml2+Kpw1cGY5alHGRiqnKq031MnW+co9YRhpwqyGwOxiJgHPlE2FlMc5QLLdLabGpQaqx+QMdbT4FekFVlhl2r3p+A4qAF9+qU0babu5zWCHkWHPuhO52Jo8/pfwWDq6zJgicId3XqQ7QRumDgJ1d8NqcygD01urMi+DtEdOMli/UU6jrcNq0a8x0Nq79KojnvBpkdQi4mocQlrbHHaNe3qQEd+5eCntlymGgYBHzD+RPLIPqfsEbWuJAhYE6+myua2lOWtiUT9MTHx0f0ZA1K/qudfaSS1/h6cwY2hCJ5pmr9ChlyxghhQwy7SXe9iFfVDCsaz3hkrFmXATJyPsdm25cPiYMWzXomnFE5//5Ij3jN2zOdSGk8IJsJRJAUY8XOIT+sVQ/BVDCDe1IrDF1jAMbbkdr1J9BUJgWnFOEyru1aecKTGk55dlbuD2ifzObMmCd7MjSNzZgyb/RXG8TT8ERxWtvgMNSA8qUk0SEhgWPk4PTfW39dU3i1GikZX4aTCrkKq4UbhIIPP4LCCqHEGAQpd//4GuTZg9HsjtLfig0k6ZmmVX69qKxR536IwEMt1c6QNAQaqj1h6lAHOhI3kPDRvjj4EfCxJF45GN9ovqpupgQ74OjAAsC7snNeHsR0+BpyuYCP5vduP3gwULuVeyLn9Qz4AZZpMbrMGiBErcC2XLFMmaXNgQeJdXCErTzI2kBRVBZjPWMSBeamXldeIIQYHizfcVHt4l2Gp9O0/+sgqJJA6FNXB3VOpH9JZSUg9ocwZ
 LRN4l4c4
 XTl/IEdxgP95rubzR4Id1GWjEkKS7pnu/xGBs9gXqED28DzBBBECjKulJzDjD8fXYs7SiF/of8asQ8LVBNsTYi/P6EDCGAc/90yOF5+XEHpXc/pad1pIuE018dXX6Uag7jQIYVerL744SBPpFG/KynAcV7UDsl9PLmIS7ZAMroSXeEV/SXxEtgyH8JTOjp0JK6qoru31ALloSCMWHxVorVEmIxea3x3mKepljCXT7pGdkxTCMUg2baqngpTmO6veyAkEuBdasQ37e5goEa5n7fxSBM1KVzOlm6IBUvZpzgV4DqqGvgv10PD00QIefJWNP0V2UY1Bck81vPViuC5rinnQBP0QuNfqiOgqX27DIOBACn0yedqfaxkG01LBqi9P4v4TK2puw0i00FeoYupT/RYvjIWpKlSsSPvHQUINqRhHdMzmWxAt8QD1ePV05g3x2I12ydt+b+63fqo4ItPeIl8nZTMXD7AQIuO0fSu9MqQ4hAruMg/RedPa9u1gXvZVqdtgZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace four separate flag clear operations in slot_free() with a
single mask write. This reduces redundant read-modify-write cycles
on the same flags word.

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 drivers/block/zram/zram_drv.c | 5 +----
 drivers/block/zram/zram_drv.h | 6 ++++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0d07f0901e55..b1a565d35567 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2011,10 +2011,7 @@ static void slot_free(struct zram *zram, u32 index)
 	zram->table[index].attr.ac_time = 0;
 #endif
 
-	clear_slot_flag(zram, index, ZRAM_IDLE);
-	clear_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
-	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
-	set_slot_comp_priority(zram, index, 0);
+	zram->table[index].attr.flags &= ~ZRAM_SLOT_FREE_CLEAR_MASK;
 
 	if (test_slot_flag(zram, index, ZRAM_HUGE)) {
 		/*
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 08d1774c15db..89a7e39a2f4b 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -57,6 +57,12 @@ enum zram_pageflags {
 	__NR_ZRAM_PAGEFLAGS,
 };
 
+#define ZRAM_SLOT_FREE_CLEAR_MASK	(BIT(ZRAM_IDLE) | \
+					 BIT(ZRAM_INCOMPRESSIBLE) | \
+					 BIT(ZRAM_PP_SLOT) | \
+					 (ZRAM_COMP_PRIORITY_MASK << \
+					  ZRAM_COMP_PRIORITY_BIT1))
+
 /*
  * Allocated for each disk page.  We use bit-lock (ZRAM_ENTRY_LOCK bit
  * of flags) to save memory.  There can be plenty of entries and standard
-- 
2.34.1


