Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B8BDC61DCD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 06:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5B76B0098; Fri, 28 Aug 2026 02:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FAC36B009B; Fri, 28 Aug 2026 02:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2516B009D; Fri, 28 Aug 2026 02:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B86F6B0098
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:00:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A1FF120277
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:00:05 +0000 (UTC)
X-FDA: 85149627570.12.3E88263
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id B5D00C0004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:00:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FulJ1j1G;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787896803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxXRXO9cihd6J9ek1BtX6/zY0HVJ8iMxbQFVA3IYgog=;
	b=iMwHSYWL0051cPK8z9Lfr1k3NfD/a+gPlbsf0JzgljKsdn1EjUdN5qz4O6OSSvINIRSYce
	Ffik2UPOvlECKjxKDSjljCpd6Is40p0981EQhDEg5/ajdT+pzFNUtUxWuEsaow9zfjJaLv
	dcCELgEx+enYMRbWN/U1r476D2bmBnM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FulJ1j1G;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787896803;
	b=bCte8ozVjmPSSK7y/Mpi0kBUgiLKWUbZ/XzZkx0GeM1pGJItoU6lfkuCbZ9zKagMmV2nOz
	O5AZlI/6Dj64d8EIPeseymrDGIyj2D1Nu0w1rhiMgv1ywbEHSG9h9X0pLkyTm/8ZM+zRU8
	vy9ez0/1/QHRXQv/P+zCYhJKNY6zQMo=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-381b831d535so1318018a91.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787896803; x=1788501603; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CxXRXO9cihd6J9ek1BtX6/zY0HVJ8iMxbQFVA3IYgog=;
        b=FulJ1j1GXSsSL6vXhJidXCqruiB/36beRAVSfaa08AlUVI+6WtNlnPzcYViD1PyhPg
         aaJNJZBeybmOwTqH3K3sAJyvPypUuR4p4zEMwMRHfUVbh90QdffJ2vvYjer1roVN1JJy
         DX2VYY4isB+UfOTlL33fgNDMt4e6J/UWxxBCDrmLNduoS3EbadQBKX/HPFJsQkUH3/J+
         Dl5G9eTGN0NRaCGzdT6+0wm30L1U8zFsKXdzinGFX+Xd/fYZWxNvfpA9T1DJFjfKEKJ4
         7Kk3nFGYesJ29GqX/K5Ueczi2s/SjG6N9l0WcYTwrfFzxJg8/AIgQY15LzWEKtAUR5jN
         fnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787896803; x=1788501603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CxXRXO9cihd6J9ek1BtX6/zY0HVJ8iMxbQFVA3IYgog=;
        b=Pec6SKYKoAnC5/q0fykVnxL1eW0GXGDnoB98+pE8tgOc55YgRnN3Stuc584a8F/CWf
         QgerKeeI3hGjC//KF/+993+Y/9QtnN3YX8KOU/3NOLvYOH2HlGM+RQSeupFdK4wGhmlX
         /0/U/kJQJJJyeATnMCTo2u7Y0g+aksTkFvG+jj1uJn7yLv6t4XKHIhkjwlfBEE81KJB6
         qVyehmQgeXMvsCYkXwzPvxCg7an2joV7hV2Tg7PDTNv58b7kYs4HEpP+8gTf6KYTD8Na
         JQvIUCBbshCXTmrOZyPjlnfYgPIxiu2PjolG226AFhImMpVk9qB1FRmR+jLNnggP//RS
         26rQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp8SaDDmVWN+EjXLkEo7y23l3Sop7cw0544Rjxx9ga7prezhjNZ4BGPVoMmmpsgEh8ghWaQ3qvDLA==@kvack.org
X-Gm-Message-State: AFuF++k8ZC1170Evey4cTRO7R9toKNMckPSocBdUwA4bTnCgb+5BlyIb
	+8CJk2LYONGJ8LSpM9j21V0+5SStKvn3NUb15eoEFqehqsmlUJozW+Pp
X-Gm-Gg: AR+sD12QmWxe/Xo37kK0GPdPt+ZH+7w0tNLeqvdfyKBii0hSOxa8GgRMW1hkEOhEdJQ
	vkbQ6yvj15IR5uyxWe1C7Tj87VKscGRaTXIxxCxbN9b9p9pL/0Kp8Hfny90mQD0V2H2qIEYH4T1
	/JKjoQm6Ub3R72GLsF+DklIDqCEgYCDfEczz1WIqNoY0ArWNMQBTrYP5ngnCtss8mzVq4Tcd7fu
	Zw0qBDSI03+5WYXFyx+rG2tcuXnRjptlzBXEu8vCZy1QkPF4yhe668rxTAyznsv28VonR+QOZBv
	8uklz5HLeAwPIk4JZ8vxOPKL+cvu0oO5VQ3gxqf4IVpZuYaT4/aIEfzFiDS9qO+yojxDBCb0GMW
	uWiiEn6uqP1EUt2AGZUQfquOsbHx6Stm/cm+3N6QG1jvurBF/Mf9exhLcKYBHUUpQmvkbgNpCE9
	4NpSqvS5Al5fxWVtS2xjF3W/4L90iUfOfOBhSk8mWoJPnIrbDyVvGPdR+G/spfN6xDfBNNQdceB
	qo=
X-Received: by 2002:a17:90b:264c:b0:396:61f1:da5c with SMTP id 98e67ed59e1d1-396d0e86577mr9497339a91.4.1787896802700;
        Thu, 27 Aug 2026 23:00:02 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0ea808csm5826241a91.2.2026.08.27.22.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 23:00:02 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v4 3/3] mm: khugepaged: fix folio is used after folio_put/unlock()
Date: Fri, 28 Aug 2026 13:59:26 +0800
Message-ID: <20260828055926.346744-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260828055926.346744-1-vernon2gm@gmail.com>
References: <20260828055926.346744-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i94cy3f744wqfkrrrwzs4riri7rkwne8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5D00C0004
X-Rspam-User: 
X-HE-Tag: 1787896803-47733
X-HE-Meta: U2FsdGVkX1/0cao7UvZHl+nXw3gYi4OsD1sjbSgsLIu38ERIlj+eFp7FsdRmubA7fWhmxiEtsR2SwjJjKeEvJH9nV81EvjkW3i4OBot1utU3hAjC+SzaOHBF2r27vI5NwkLVB1S6Q61JQaZRdksxs9P8XLT7aO+8Yn+R6o4j6oL2CAlTT6p/vmEe3ZfRH5ef5zR8C0cm/CnK+87yNSusTa+3UJTBw3Hosw/nlAqpGygaMk/LAv9o8Q1Z1mvVsN6yP1my+4uprZLCyIb7jQS0oTdVTbOyqDGIhDUuUqHh2SoHDJkq3eM0djPCgGq0uxZYLWplp3WZwn43zM3EUu+vAdx0fFGGn2jKDKIhnrPDTMIidCqzwt0mg6eKiX3YlWZwUeivLaOpQLTh104ilSu+dSR4kquMC50j8Pn7cUS7/9kN9X4L5Y9Lk9IQZFW7vJ45UF4Rkg0VhalLXg7ADt/mSqEgwrtZDtQgTaWUvOELtxZUHaLEieiQTNBtvSjt5Zsu+cuUaTY+SrbOxpPmqohGOa9zeyg7l+X0evAEb2zyWHK+pzM2aKkULj1M0nOwwToxAqekJwjCyU/Qojw0ZAEuBVcqCAG/CT6cnu9i7qU86ra5m8pQ9TzqSo3Gy9nPsyzVV67kIcgJwNS3pAypmwXOh6R4qPPWwG4O8ubDrgVI4fh1b5XxBqSny4kgYSnveZIYFAuj9RDyfkUH0oU2oTXTL+L2slacC2sZAU3vQsT9+XCdw6QGK2fiIBPDFd3oUBY0M0aPzFtcAKLY+KOmeFJdYXxcCnejmAnTP+9DMUqHU3zY+coaLP6IRuRqODeCrGpAdlDLKA9gA0ZJfzFUDig04Zt4+aMD26RGrvVYWPD15ozaMX3f5Dv9ME7SVj7UuBT2WouWbp0OlUBNVGZJ5GzwLfdWbzBnQjYmmLVkASNvp9n+pgIGUCESH3k8F1KAVI41uaQCBhZX9DE65vqzs4O
 jm0kJr1n
 vzGy9aMI4lhBjNrXhoXzLWIYDUsrqo8hf7cV7g4OkdBy/jQt37lBRYrGIqQNL4jEFk2Y64dsqDf6vfJ6/mjDY1A4yuXNCklQYz2sjQ1ItvboaOAnTdY2jp8BCs+Tt4fXP7r4VlXk79IO2spHB1/78X0ZW3qPYf39rjp427UknC2IzDI2ci333S5YOgacEYRh2zImwApaoYckP6BRJ/ZXyWnkTvi1XUAJ76+KT1xJHeL6i0IJs1DMdZS11CEvk0oCoHYkolq3o2lkpOQq4mz30inrx9eeXTnf0aIskLl2vF+uxJu1T2nMtW+Pc0qNZvhOmtR1LKN7C5JM+IRswtywHxP2liMbErxAGNWCZ3uH0fYm7F2PstJF8X1H7HSwN5w/83FTPII367uXjXrvF0IjIHdyGCOwE3H63tObWvWaj3HhhYpXBrZ31UrnRBHaOW6XsUwGbLLSOLemcs3aTpg2eBukOehc5N0QG86hJVW1aPgFkjkYGY3249ul356Un1/77uRhh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

On the rollback path, folio_put() has already dropped the last reference
of new_folio. On the success path, new_folio is already unlocked and can
be freed concurrently. The trace_mm_khugepaged_collapse_file() is left
with a dangling folio pointer.

So using the folio_pfn() before dropping the reference, closing
use-after-free window.

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index fa828967e1fb..5fb4d92cfd84 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -211,10 +211,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 );
 
 TRACE_EVENT(mm_khugepaged_collapse_file,
-	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
+	TP_PROTO(struct mm_struct *mm, unsigned long new_pfn, pgoff_t index,
 			unsigned long addr, bool is_shmem, struct file *file,
 			int nr, int result),
-	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
+	TP_ARGS(mm, new_pfn, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, hpfn)
@@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
+		__entry->hpfn = new_pfn;
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4d360ae87769..52b4476898d9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2256,6 +2256,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
+	unsigned long new_pfn = -1;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -2275,6 +2276,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
+	new_pfn = folio_pfn(new_folio);
 
 	mapping_set_update(&xas, mapping);
 
@@ -2678,7 +2680,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 
-- 
2.53.0


