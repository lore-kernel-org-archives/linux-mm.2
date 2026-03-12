Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B888F106ACEE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482396B00A7; Thu, 12 Mar 2026 16:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448C16B00A8; Thu, 12 Mar 2026 16:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2AD6B00AA; Thu, 12 Mar 2026 16:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CC9F6B00A7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:53:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E61961A03EF
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:35 +0000 (UTC)
X-FDA: 84538611990.05.EE70F85
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2CC171C0004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="YBT+/6Xb";
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKktsnvx+4HbrqJvE5JfNhKHypqzO+issASPe3WGHl8=;
	b=TAbJMSsxTEYOlkmrhGkWKincKcOLvXHK1L0Ljpq40J0b8IJyOPnQZrUo8ZRW8vlRRXIEON
	iOYo70NTVfCO1fspCtRrcepa7n+FB7LsONbxkzzVB4Xl9ncDUgh2S/+vylL/SPSznTZ4F8
	5UUfUcRYL+gD2ykkObY6y8xuIdOhRyI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="YBT+/6Xb";
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348814; a=rsa-sha256;
	cv=none;
	b=N8XJxtgvluNKOuxp4+eBT6qCXCsHzw0FW9T1pFM9PhQidUdiibymUCTsrCme7sf8be9H1g
	zoVP5AEqRuKMBrAs6LN10we6JDscf6kCEwoKcyqUNo6tqNUk/YSlUCOmEUh379FP6/1C/W
	fyvQmYVa+IYCUghcOuc1DgtCabfeiZQ=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cd90401034so164016985a.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773348813; x=1773953613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKktsnvx+4HbrqJvE5JfNhKHypqzO+issASPe3WGHl8=;
        b=YBT+/6XbgZ4WQ/IfrcdGE45wuIW/rtFFgCM8SoL4QRBZb1y6ndAEfPHlVmBn472pS6
         6jzKm82Olbm6aHO6Q+LUhL1kf6F9IiuKdo7ABbK4Hyw+7QGeWJkUF2tMg45YSqM2vegW
         nsU24FmBzsVahBqjaYMvOXBZOVuhHsTp71qUQ7eMk9erF4R41GJEJJ++AxVYsHs/dldu
         F70mTwem0f0sy8dL1AAIZfY1nABgzjOnRiJjrBRXNtyHaMk0L9BU0JK0sMrWkCXT2BU8
         rDPT1Rl+nmmubNzP9NEH66CMWpu5KiWN2Sasv6hcCDdrrouwikcSFRy1nFPwppXPoqQx
         HPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348813; x=1773953613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bKktsnvx+4HbrqJvE5JfNhKHypqzO+issASPe3WGHl8=;
        b=XLzVraj+Ec+k4VBOY8Hs0mt6es6LUFrvGKwA5SwDWuaXz/P1h/KX4FQeAL8O8a0ihc
         oa/D07/ENDhlYG01TzZTiTZEFKm/MSDW7Dm3jJ/t/dp30fU7mmbGVrNyBSuqc6GyW7+c
         RiRGqiz54yXSjg1VzLf2zurBWx1zHl864jermjBG+VEW8xYK/bIAmBxJlo9IHApFkA00
         3kIvUKdjv2mEGxExNOG2fDpoAqdxgJxkrCujVKnpjc6d5VxauqqUn/g3dXzimr8Ea7UZ
         pUoMwmsOZqGBehHkj4RpHZZF38fqQidpvm2/Ax3PkCt5JvMFBxAcT3ck1WVS3aOjgi1S
         hr0w==
X-Forwarded-Encrypted: i=1; AJvYcCW6vERstalaCYfI5lG7XXFMAffc+HOYomDvGYdyPvjQ3Z5IAl1ZY95HMXgZ4DzxjPIOtpE9BvlllA==@kvack.org
X-Gm-Message-State: AOJu0YyMbHjt43SZVYBXLlqfY7vXhILtcefA6xZFKebTRA3ox/qynOd5
	0lKpN/kdc7EBQL3jYDEzwCfflRzGJvko7aqViEpzhT0KEu/KfPueQaEA+IS8IcNMO4g=
X-Gm-Gg: ATEYQzwecZFqxIRozObN9MC58Jz2PfivANxfMoTvF9UBjLMCvdEyUu2M1SPanPD8S3f
	5px1qQuSLoCtvxgg5WExr5mM7SbuR51lvtRYQQPcz5F3MngzsLTC1S5UeL6hRh52O5mJ8rrO+Qf
	pxn2ncRJ05RVH98Czlr718xjpSY8b7rkoajhVXeHR0wpcs2DyIqGvGY02tVJD7j4b8uvxW+v0v/
	mywsbsn5XE2NjEOJ+dsCuG2Gt975hXSvDuok67qkGwbVAb15N4fEFPMz0oPPF9yNYwSctal5pc8
	UNkhNqSR3WujhEIwOSZuHJW4D5ysp4xjTlbtEgFNv9hw4KKZ84ZVmeyk71Vm1uO/QwDUme337t7
	SyrDwKPaZZnvB3bdPIKZeUE1FOQ9yoEe2ImmMnPzxwecjCP6k3z062Df1U1Oogf54wir6bG6O7E
	NF1CKRhBd5xGTr/ZHJhWXu/A==
X-Received: by 2002:a05:620a:4510:b0:8cd:79aa:6931 with SMTP id af79cd13be357-8cdb5b6f77amr159581585a.58.1773348813306;
        Thu, 12 Mar 2026 13:53:33 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda2112f5bsm473183885a.32.2026.03.12.13.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 13:53:32 -0700 (PDT)
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
Subject: [PATCH v2 2/7] mm: list_lru: deduplicate unlock_list_lru()
Date: Thu, 12 Mar 2026 16:51:50 -0400
Message-ID: <20260312205321.638053-3-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312205321.638053-1-hannes@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q66x33nbb1eioc74inhjg44erf75qu7u
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CC171C0004
X-HE-Tag: 1773348814-40941
X-HE-Meta: U2FsdGVkX1/pRiOgvlmR/a9F+UoxlwvLe0XNSvvJ0iSflgUzJnFfeaM5U7m9O/PV+i49vwzpAhqpST97cAA/5Tf8dStiLhfHWe2IrzppssEYJD0hJvA7ezxcLhf7frzIX9irpoxx3uTKzZWO3C7U5F9HV0lREqvKHSjTnGf8foy3snl6ejG5iJyqaSei4HAQMElHd97NWfjnH1vMVoAWRNOBiNG6fJSqclLQ1+wzXDK5SCyYMvYKiWU8xtjApMu4Amrn2sW8gj2Qsz70X1tSzJJQ1wA722mzZJ/wYJX0mbr7MDnsyHhf+CqI9VOj837UqWdckpj79a2inzUzwWiOdcjF2lKRR5kNS2PzgOr1PfuSrPVYRQEaXcJQyYOb/AgpBMQ0b/rc7MyrYq9yTBLTm6VImHJguXvoyt6aGuRD2RlhHFtuMkcxXhJg0C6AVLrVgp9GgKVa46YApEyL3X/rcfTNrWQV4OuRCqHmBPiF5AhCF0b+UDcVKbpn8twTtF9xI/zgf+QLaJCUTqWbjmC9qHLQ5/N5v9+NMH8ob1jrvOnGAvukyjLgVfCuk4iJ32QGwfVVwwzQ1V/6EbcU8ajze3hOL9HA6bcpazxWTgjbjrB8sG2OvYxTU+Fkun30iFA5Z+i47/OQOdOWL6KHrHMFCFvCPsAHFgXiNE47WJUBg5jwFh9/NCPXtxIkGoWzGT3YXQaWqsCMEhPzWLHVhHtNi8acgkkmpSzZac+CfScVq6smNE+umvsWITyWlmrJUqHoELCbqNtEVDVNfz117PpOYavq9ZKlf1hpY5kWajwCz6kX3UQiENXaYmZQI3n/wVZiCFdW/qDHsttm0G2kDFQ1AdUKLGmALQl1m+Yek/bMXf5/V70xYtFE/CEkjM9zNtqbrMvtp5o4xr7ZT4qoF+KDhOih7pqw/HPewtwqiOUjOkrwpmX2cNjpOTibH9YRKGUMSzZc+DCydPsjUu3Vt2I
 xXhPQ3CY
 NWhLpy8BDDW/j3WTLnX+0ycgBLQjfQkppt+DiXselIbp1nXg6xQv9UaS0GWR2sWWEAUk7lQEmb4Hf24A3ln0M0vtPTpuP1WO9UFN8I10wm8smOifspluN6XJtglAkaXYTbGHEeDwyot9Z5yJfaN3Zth82V/1J7m5jpFtjkPkcmzXknz7pNM+bYz9n8cj4Pz/WorTXwg3ZjFhVGts/H6Lfr6roIFKewNIalS1iOAXsEtLCpqg+NyS5aIdZBNjJlQ/wU+xOcmeOcISAjyPN8u9wZc/J7WuM7+OAVtf8RI12wLCI8hf6E0PMxm/fnj060IJDo9+xjao19FWYgSA7O2OAhn1gYvhw9Rp1d76Y+Bq3LitWyxeE+SK+sGA4q/1b9zncIEa8SFgrpVYO3ZAH8Dnxd1+o48l2Eze83zUK06i1qRCLLFOGalKEjKLd+Hf9Xfp/2NCiITepA0pO7QVTnubZpMUbXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MEMCG and !MEMCG variants are the same. lock_list_lru() has the
same pattern when bailing. Consolidate into a common implementation.

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


