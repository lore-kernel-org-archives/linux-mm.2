Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6B51077610
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6836B0302; Wed, 18 Mar 2026 16:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDA96B0304; Wed, 18 Mar 2026 16:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ACF56B0305; Wed, 18 Mar 2026 16:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5066B0302
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:04:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC2D61395E2
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:06 +0000 (UTC)
X-FDA: 84560260092.20.58D1CCD
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A18418000D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="sC9/XfMY";
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773864245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lbnp+kFbFYjM1YsuaYPPjCjMikwKyOcf6X0AkdLiyeI=;
	b=VWMrxFUvCGw6d9qqtrA78+J3xBXWurJTSLPpTZVM061ndKCW9Zi2+EOYhSd2o6bvNzKxWA
	SdSYV1UqqwaAfk5EYaDKUFm/RyCOBAdPwm5QY6clDkauvkXzDoO+56HLUM4Pa0tAgxTr7/
	WkCZosldVG7SbEUZ2mUPHM02tw6ZV98=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="sC9/XfMY";
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773864245; a=rsa-sha256;
	cv=none;
	b=v1CpvO3WHlMEZSIIglprX81QUhQdCbpNtpH8gFnnSQTQfVOAkkYJXlhlv/FMz0KzbxwOAG
	Tf/qhEsYoD9g+kSDdLawrvfpfW4DNzubBnakgeta9/OG4wFFaqNb6ASO/X5l7o+LCe2kF9
	FleBTpYE+46NKFin+AAG+Eqd2OoA2x0=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50934b8ab60so13505961cf.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773864244; x=1774469044; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lbnp+kFbFYjM1YsuaYPPjCjMikwKyOcf6X0AkdLiyeI=;
        b=sC9/XfMYhL3QzKbSQMWmniVfb/pXKvTrgy8v9udk3hvSDC9TljNPLVPKh2P0Bqcl2Y
         3hHDnozn7fp0NCFQ3Jw/O6o2MrXkuH1G+DCqKyRw0BtdhuRyoo74lzjY6Z1yerzkceWE
         43PNLpFB/T5RyG1+ZJO7iO6DWYLhQREzrZjsOWWHs2a1BEXsTeUTonvQk3mZFrZ3c+B7
         vGE7oNszDoEe71Ajt/11oCTvH3R6lpPu/0YyfhuikqnuGUhCqIjuHNFAfcaRKn/5wfDw
         ubxs4Ok9lLikkPVnnadSN7bjpmIsu4hNQO9phBUVZaGl/rIIHZ4z8g6W2DTh4UGKqOG0
         2ZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773864244; x=1774469044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lbnp+kFbFYjM1YsuaYPPjCjMikwKyOcf6X0AkdLiyeI=;
        b=jDuJivvBr9ylLoNXXiK7lkpk0bL9pb/PBqBqNvIgTNZLitP7s7hR+AmvpEiv32M4Nt
         n4PSYGQTyT9zripe5UVlZkUQ/qyFrwzeXBa9lqOyLYiB6xgcyRy9LRT5hQfJ5mqSg7VR
         iCAbW3nqj3biHZyt+TVJRBzPbv2EYs2pzzJ1fyXg4hdW0bclJPvsEyIPkPZ9+qY7U1+R
         EZ//EbmrlmO9oXENEfo5hWej5gdhl/bh8bPOGXqUelTOPng5BS1Jg6lWo3uze3Suau0K
         IkHL2GeSSU31W6VKjdB50BLvtO+cJZGfrfihA2gldN8xNZqu8dRRF5EzOFKFsQXiH/rK
         +k9g==
X-Forwarded-Encrypted: i=1; AJvYcCXKYPGkUGaqGjAmyNjO3g0xXRF87YCbDPuh/lj0+MM+9KG33LH7FzY/K6HrsP5W/Rwer/zAQpUm+w==@kvack.org
X-Gm-Message-State: AOJu0Yxn4nuYfoMAx27tIJ8CM9O0sYpJCYybdy/mxSH8lmsJq32jvEXz
	M9CtjZO8hfPaup65qey/Q31R/xVMkQfuJvVc+4skZFWcjC0l4cY50VdhczYjqLN00MA=
X-Gm-Gg: ATEYQzw7hBBPFunglh8ehRNuVFbiJU0AhfPVCxAkYhJi8n0+sqK8VQlBzyXFmjHm1n3
	TqLDMxOz6Xu2m3T5FOoIExy+On3L6WbiVopUpbb1jrgJ4I+mfTvBCip0+ERqrS4jEwaijVmNyAg
	bOgyjdmJYXQHxpg4zFhlpGd2z+C7Lh2Rmh9sWu18f0X4ZjBLrnyuJI4XZtE8K4cpL7WvLli9ugN
	XWCuZno8t2GJ91ePZN+/EMyl+2JAcRQjplPsZU0SMOOsReZN9oZc7JwnfR2eFCo6nBdqhJo/ity
	5QO2w0X145ASNiVYPz/6d9D9vXDeiNMmQT0Oqwbhy8fP3hq+7CYJ34Dw4qqixXaxuYjxTaEZhXn
	dDuAink/8flift0GHqaYgYVUjq5P3zxtCtJPxhIrvEporkJuO0HBDN4/ETLzpom5SDSdXfxWX+0
	3TFbBcFpMMDOqqQVjdmrfdFw==
X-Received: by 2002:ac8:5914:0:b0:4ff:b32b:cdf9 with SMTP id d75a77b69052e-50b24655c9bmr14048141cf.14.1773864244121;
        Wed, 18 Mar 2026 13:04:04 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b134ad438sm28515181cf.10.2026.03.18.13.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 13:04:03 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/7] mm: list_lru: deduplicate unlock_list_lru()
Date: Wed, 18 Mar 2026 15:53:20 -0400
Message-ID: <20260318200352.1039011-3-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318200352.1039011-1-hannes@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A18418000D
X-Rspamd-Server: rspam07
X-Stat-Signature: xu5tok554gzc9wguzri3j5szmepyegp3
X-Rspam-User: 
X-HE-Tag: 1773864244-932004
X-HE-Meta: U2FsdGVkX18nRDX0+Rnessz8LLTwWe1F7zzHhwXmogGE9yUAmZPaeXUfGb7W7MWaTe4ErfLU9Qatyb7HujmW89j4lc7/VsEDKDOwARaedGOAOErmxJKROkKb2DnheeHN6NFv+yAvkohNBt9ny7aQ88k1axmVgHJfEZUc+7K78jpVIIhM3b8YcuPhLTj1c8g/mTyvKyFZ8lcp7Gdy9Hlw4O1f7D2m3JgcRgtOGt4N335xYlyQkrU5OSAAdtaYTX4W0Jqxs2jdYcO1+UfwqGJWPr+eNkDu3r/R1JvAk960rQwkiy1KJGaGI4yweE2rCuI6l54qXsi7aRcvfzmFMR/AmXMhHsTtMTLbVEfbxgCx5iA4LLWF58Qd+jfsROEDhKfnhimtE8R4lHMusXxZ4G9l0+74AjbnzGJ0oZ5frgAoheQEw4+PlAr5x6qcXeHzqVZKGL1Sb6TOWoVn56dCv9OZdKu6qj6pQjBjnxS5T+CiBBIUo2wpKV2EuKSfLzZ9Pw5N+aKrlH5u1u4l984Vqm7Wqh6F1Q0MXRsJUw2BYUPD71ML9UJ0dy2fbWNIUgQ/cO7k5uBsTFnG/0zGuNiVmKX+sEat7lYiRmERXKwIqZgnq+v9ao389sIfQ2HDke+V0ADUmhds7+mGQQQtldWmpegZFIJKYOo3hfLQRFrsjDeRqmVGs3T1q1d++ZyqlNHGm3D8UAr6qN4A/NeUk257XT+VBL6uMNUl94DjDtNAwu5ZU1RS2jIJzqKFzixRNxrBL3N4yc2PssusCc8cgdMyw2ygUWeHumzCBW6zNAMbC3QBgpcjbn9yfRHKfbsIjq+CoewZIVnhaTNfFSu0xe0yVrnfy/pwDHmhTdpS0gi2HaxZmYjhGtxYgUBJ7RP5pRvu0pXydSCRL2OHxCJ0+3i0Ug/rYF3iimlp6JpOpM4OiaDsG//Kz+3YtdIDzCPq1ZFqBglI66ykujVji7KJgUcRN/Q
 NlZdMH9+
 kia8H5mxHAoUMqz1A/mIH/DsskwLA7jyhjl5T+d4oVBsU0Q8muSTdfgWmHnkJ4Y221fISw6WsDZ+fU6VXXOK3ylQGLDrarzM56X/fmxDC4lM9DIOKqvpRhgq3ArNU2NFOEfoJccRt77T6p8Xk264cbPpadddKy5g8vrmOhbTcrl+cVFU9wS2FTLdKvRcIUZgLp7kQUzpFhfDG3XOXo2eHiQZNoFlnaI0cBcPY0Y7LGCR+z1gNcIjGzwpOP7K7QKs6MU6NgCofoj3FP5RnFecFT16tfZFnKU30Yf7cU+Q4KhW5m4fX4L3wJu52FweRk/1A+G7D0iqjMfyEKf/3G5THm8XPwcB32QB1QoRDEy8Ft8UH0JaEfynDdD5wr97bP4jPukgCBlVkN1RZVHH9hb9Qh2Wou/HRW/TDcm4LDyLq7AZzw9d3AG+B7YQznymLEr9mluJZdov6Lbpjmfz47FhkteZ+PGST24RBc4Xeg2jU0Ls2JDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MEMCG and !MEMCG variants are the same. lock_list_lru() has the
same pattern when bailing. Consolidate into a common implementation.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index d96fd50fc9af..e873bc26a7ef 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
+{
+	if (irq_off)
+		spin_unlock_irq(&l->lock);
+	else
+		spin_unlock(&l->lock);
+}
+
 #ifdef CONFIG_MEMCG
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
@@ -67,10 +75,7 @@ static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
 	else
 		spin_lock(&l->lock);
 	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		if (irq)
-			spin_unlock_irq(&l->lock);
-		else
-			spin_unlock(&l->lock);
+		unlock_list_lru(l, irq);
 		return false;
 	}
 	return true;
@@ -101,14 +106,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	memcg = parent_mem_cgroup(memcg);
 	goto again;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -147,14 +144,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 
 	return l;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #endif /* CONFIG_MEMCG */
 
 /* The caller must ensure the memcg lifetime. */
-- 
2.53.0


