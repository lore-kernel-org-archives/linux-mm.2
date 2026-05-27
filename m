Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB383CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D03B6B009B; Wed, 27 May 2026 08:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A85A6B009E; Wed, 27 May 2026 08:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4BC6B009F; Wed, 27 May 2026 08:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9C06B009B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:01:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5FC2C206B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:01:47 +0000 (UTC)
X-FDA: 84813060654.24.8754663
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id C0BB2180022
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:01:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PEv/1WkP";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779883305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mefnb7wtXl9fo2oJQ/q5HPl8VRiw71wTKLdzGgpyQU=;
	b=lPriKa9C3KzhxPTVyP8/Y78XksBdOcvxhDivFrd0TuS1pSwZ3lWBBSShUuwNPOPV/0wVmc
	9xNwRkh24fH5HMeTY7fQoH6C/52RQxXaZHNfexKDGJIbVFXUkmCJLqeHoKTNwFQQOZNFi5
	lKtwUMuvh9Xed+0i+KVvbtA0pf8Qu+Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PEv/1WkP";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779883305; a=rsa-sha256;
	cv=none;
	b=8gQm7RFb1AdA0US7zXn7y4xItYZ644P+AvhGa+hoH8M4pHrcdp97QQY7zWgzCDw5oRe2g3
	2znGee9G5/kGgXkz6+DWCmUEy15pqoD8R5vo2Eb/4glzH/TdFpW/1G3VEAJpk1xx+KbPs5
	OdhN95nG+RHK6QK1U7dcfDVLsabp6W4=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bd2051167eso57334215ad.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 05:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779883305; x=1780488105; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3mefnb7wtXl9fo2oJQ/q5HPl8VRiw71wTKLdzGgpyQU=;
        b=PEv/1WkPNSH/jea8vGNXpsffLmL+b4/7oPttvxhi5hu82MtDbwlYUWhddWfxfD8SpK
         OUexr+klIz1rsen4EdOm0XS++ku0BiKsFBp3gOis97INj5Eq3llNv4X79sARjYaDKafi
         wz7w6Pjdvzjopk6wEt3T3IU1jFRv1Bl77+MvaorHtVVTFDnCN4yWorp+fc+tuZJxRJTC
         eAddKf/Zh2NF35tO4SCwqAL/87bjJcXAoKZD3h2f7AgL5dwiWGfL2Jco9AmyNPkV521O
         C2O2SnWLee0pxv4L0cqKpFxcf3MXhirQzy+aKC7PCHpOUnqCUnc2pzHaMyaVYCKXLddV
         FGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779883305; x=1780488105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3mefnb7wtXl9fo2oJQ/q5HPl8VRiw71wTKLdzGgpyQU=;
        b=BirFox0VOanYQqbEucbzgHymXjGpwFrWAJf7hxb/5ihFVPhFbjvq2pgjLoljBKbrWU
         ouafAUmB9JXQucjhZ96WVFfKwZuNKcjB13osoOrNm/WiYPEWQGBlR2oD6Khm0MMwHVMX
         J2VxbXjBdF+DEM/kYcuLi3tiTQHsi+2bEX6qidckZivdS8PnicrLZFC0QWKgHGFT6TPq
         GlLhllEnZ44lELHrkzpB3tFk6t5TwdGsATZKEungP64fJKYXyIMABG7T25T/wViavMNB
         VfwSJlLU9DUcvA99V75wyJ8PzWGuilB+lnSgetvDT+DTRVR13guUo7fQuxuQvLZ0dFGV
         RjsQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rnBepyOsX8MILQ/2bFmm92psSVFtWnzlRAjRFsmkd1kuquHT47dxojOgCUNGguLUP779P2EGcwA==@kvack.org
X-Gm-Message-State: AOJu0Yz6zZxnweCRiGKoGWUEwP0svdl3TXP3ODi1bhguGujCyHVFtqDR
	Dlr3tr3MUxS3v+g5ofV2yLirUoCTaEANSUtP0Q14EEi1nb/iWUafdUYS
X-Gm-Gg: Acq92OEqCUXY+SkiE63kf6ruMbJhKG7oFK+8QU1TjJuae1OYQbj+ZxGZpG6Hf6Zpobr
	2jJiwkDD8qcne+yvHPU6TQa4w76NvAFCYjEmBFjIEXozLEi6oim2MJcNqn2EHAxzwfeFbjWMCgQ
	I87aQ58YQkDZJ+b0N1J5eorGjlFpNoKe46ao8kmAUlrSVoKsju1rxc1zNfz6EuBjSF9CzGYRjbx
	TkAYtrqnoYTOUQWOAW7vvbASx4hzq8u7nj4kUwaZYKtFT5i8C+7+a38Y/1XOAzDLGYM5Far64+j
	quzXavErAlf2k22hDFa8ac4PbMyFxnLLV4gNG2SIUxwA8P4IkZDOXF0It5Ygqywcl9qrR2XZrFj
	uUK/YFOmwAIeyyndXhX9ZkBE9Q7D67dLrVlCrOf8RNqbiK1UwlZFML/EAb3czT2p/fhIRPgkB0B
	6OqkhzuWSs4f/NsmlX9wSo0UiRAVQhgwfd6B6VMab7tlsve2T9
X-Received: by 2002:a17:903:b85:b0:2ba:bfc:7699 with SMTP id d9443c01a7336-2beb05908eamr256392215ad.17.1779883304577;
        Wed, 27 May 2026 05:01:44 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56b5886sm136250465ad.20.2026.05.27.05.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 05:01:44 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v2 3/3] mm/zsmalloc: drop class lock before freeing zspage
Date: Wed, 27 May 2026 19:59:30 +0800
Message-Id: <20260527115930.3138213-4-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527115930.3138213-1-haowenchao@xiaomi.com>
References: <20260527115930.3138213-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C0BB2180022
X-Stat-Signature: 46r1h7f1exa6d9ibhyugkz51kc8oofhn
X-Rspam-User: 
X-HE-Tag: 1779883305-891427
X-HE-Meta: U2FsdGVkX1+zT71eORWKQ10QdL2rNSdirGD+u8VQNVcqrhriJDPH5rOTPA2V64uhwwbl+iKGRkn6V1YdKfd8QmHV8/iaOMSqwxk2vQHxTjJi4svkVx6ENjuFwghZiuye4Q+T1N4qIllkrlNDlmYYUIvnZykp8t4A7OBlNII+DLOpqMD6E/ftaT8dNRdfUhl3oxK52Dg/lHUjRqGKY7gcQYAnx5PG+CibjI+wTLmU1I+Pg1fK4fnUrgVBC8nD3oXPbSZ+/hUJ0BJ4WH9WZz5/MEg+5yaSWdic4XyRZ1bcR+IOeZ4OyDq+egeGKv4OGNy+BlOaPACN1Jy9LTWf60m8KzCKEC0QX7XohV8Ts1vL2s8J+nSX6fVfoSTv2GyFyYRjV/nJaex7f4p8Nk3bxX5D8sb78wKfn8+5xoabTzEr8GtohNQXulWcJcoGBR/IKuAaqarP1oFsg5R2+toVb4ojVEV2fQOFOZkyVThwKMVLsgxhxvyaIZYioIl58f4V78T9oQceJQ7j6C+crzBKt8M22fOLWaWryqD6sOJxogjIdzpt+uu+QAq4MdrYWclW7v4QpVxYgfLfXX3U8o19M1dVt4JVz/yG9LdrL2e3mVSRh5k68bmhPHio0QZ52bxBB4xElTJsbsehi0qD7GREdMAV4NermYxsnjRG+/DSF+h5tSWggFRIcS3qcIlyqdxF35sfL0np98IlWUCQM+kGQQEVccyHgZ+dHAor8eBhc6nMbwl1rW0J2oOcZJgV4/7Ul5v89WP4g32AeYIv/huDt568xXdiN4dJlWQpu11OJbI4OGD1Jh7KAMMGkNwYOyqwnFOu9UDaQo3sQiTrZEeDVu76h72sTE7fSHECPU+7pJzfqNRp1WYpq7j0E5pBAhw+S/d+cd9eWL9cXdIqoBStCuBRwv/PJP6+Jr4DiVHrfgM5RYoN5c7h7KsBX0t0lLBKPiH3pI2OmKtWaeadD/R2QzM
 Z36EWjPg
 Fu+IwzVm8cYUMB+kZK9D3x6TuREBhv6Av6OBNh+5uLExN4+RGW+FYNbt3PrdVphEGyoaHKlB4XkFEzmnfMePQwr0LBr0QUaSqA38i5vk7lAg43Rr9j62/FLA7ct2koqsLIDEBJpzR9Cew5TcRnILE+DZSlGvjGleY3X95+bpzf8K0ZV/gKSzaQOVbawa1B4buj23TNOHwNAVwui8g/7ARJ70agSbxrtVgRqg55NJTzsgeZgjNA+QDwVIY9f8JJB1xFxxEy7Fy+r/MAmG0J1fs4Xh+exvpQ5CurBeWMyGERHJa4xDf52C5gaLG2WDr6d6dpv6Mt22gpW0NLC4LGstpjexfh0VodgKMMO11DQzaGiKLYsUFGE0pz/b1nmIJKQUGnDKsOgwwirTF3tbKxQniQNuzaWWGQHaLsdKKVTfP/7fAjwYs2VEPN/bey9hjmR5FKQQsn5DFyTEwE2iRvDt6xdcyxlhz+JCh4NgY6qtVTuEtbNAJDSRR+QOtIZWIzs9jks+pg/6qtP/nIyT7yWesqvtEVoo8VllaHe4GK1poOLj6+uiSGjXwxQzf7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Currently in zs_free(), the class->lock is held until the zspage is
completely freed and the counters are updated. However, freeing pages
back to the buddy allocator requires acquiring the zone lock.

Under heavy memory pressure, zone lock contention can be severe. When
this happens, the CPU holding the class->lock will stall waiting for
the zone lock, thereby blocking all other CPUs attempting to acquire
the same class->lock.

This patch shrinks the critical section of the class->lock to reduce
lock contention. By moving the actual page freeing process outside the
class->lock, we can improve the concurrency performance of zs_free().

Testing on the RADXA O6 platform shows that with 12 CPUs concurrently
performing zs_free() operations, the execution time is reduced by 20%.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 88d10f814da9..5511c347d00b 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -856,13 +856,10 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
-static void __free_zspage(struct zs_pool *pool, struct size_class *class,
-				struct zspage *zspage)
+static inline void __free_zspage_lockless(struct zs_pool *pool, struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
 
-	assert_spin_locked(&class->lock);
-
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
@@ -878,7 +875,13 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 	} while (zpdesc != NULL);
 
 	cache_free_zspage(zspage);
+}
 
+static void __free_zspage(struct zs_pool *pool, struct size_class *class,
+				struct zspage *zspage)
+{
+	assert_spin_locked(&class->lock);
+	__free_zspage_lockless(pool, zspage);
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 }
@@ -1492,6 +1495,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
+	struct zspage *zspage_to_free = NULL;
 
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
@@ -1502,10 +1506,22 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	obj_free(class->size, obj);
 
 	fullness = fix_fullness_group(class, zspage);
-	if (fullness == ZS_INUSE_RATIO_0)
-		free_zspage(pool, class, zspage);
+	if (fullness == ZS_INUSE_RATIO_0) {
+		if (trylock_zspage(zspage)) {
+			remove_zspage(class, zspage);
+			class_stat_sub(class, ZS_OBJS_ALLOCATED,
+				class->objs_per_zspage);
+			zspage_to_free = zspage;
+		} else
+			kick_deferred_free(pool);
+	}
 
 	spin_unlock(&class->lock);
+
+	if (likely(zspage_to_free)) {
+		__free_zspage_lockless(pool, zspage_to_free);
+		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
+	}
 	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
-- 
2.34.1


