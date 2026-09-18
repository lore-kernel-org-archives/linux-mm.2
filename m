Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A9AC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45DFB6B009B; Fri, 18 Sep 2026 11:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40FA16B009D; Fri, 18 Sep 2026 11:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261706B009E; Fri, 18 Sep 2026 11:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6D706B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:33:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 312971403FC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:30 +0000 (UTC)
X-FDA: 85227277380.17.F9B9BF0
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6A2394000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JibKz6fN;
	spf=pass (imf17.hostedemail.com: domain of 3x1mtagYKCIw8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3x1mtagYKCIw8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31y1T2wCgzpuS+JdcRd/GVSVXNd4Xu5+lzNmsg6bK28=;
	b=rWbjuiNswlnZc6usRDpWDGxzl6FSM4as5TTVnW4gwSCVJBk7G91vD3Wh+cKBL0Tu47rll8
	/9VribsTlITX8dI+ecmu55jPoEp771d4VC4RbY7h/zZxuw0jR0YngzJZPtbpXonU8QYfaE
	giEU3tOHWcfSDHu4SSfcX8DvPErXZ9Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745608;
	b=8qWRMdyMDRrDEpIU9ldcIDAaDz9I/nuPLbi96YRxZKVKP8JhCuzFk3TmxWnYzGPIxVLl//
	IH8CQJd8hfZWRKJ3ym3P9fpcqmxzQGUYsbSmyoQzaJHLryKU56s4KwTEWAZtGUXLQUbW7/
	5ttzyZ7ynY0XP2Y9FUyxh1Ku0KOz028=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JibKz6fN;
	spf=pass (imf17.hostedemail.com: domain of 3x1mtagYKCIw8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3x1mtagYKCIw8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39533bb224cso1804199a91.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745607; x=1790350407; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=31y1T2wCgzpuS+JdcRd/GVSVXNd4Xu5+lzNmsg6bK28=;
        b=JibKz6fNwhjiYkRTIrLrCz31qNtOPShnSjfAwY5L0nFADq7pszC4oaG7RGl8lfrhd4
         +JMI//j8LAIYLBIuwZvBPQylgP56EeDcDm7M1R3CDpeLlaD6eZMHMXkSWho/508Yr0XF
         IeuApanBTtV4FIILTYY/VtZbOzHVYqufVIvB5TFFi9WEjrLl8AhQwobGs/8N16ysbyOx
         E35Qn350HZ0FRDf8cS3Wl+VYdObRaw8R1SWK25MOW69r3QHDrg9NOnpyh59ZwtETm2IT
         rKTP7HzJHQXDc0UZSYDvcYb/tGseSy8dYo6oTfRj24I5J3/PSqB3yxR6H0Q4MlWZKY8v
         MIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745607; x=1790350407;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=31y1T2wCgzpuS+JdcRd/GVSVXNd4Xu5+lzNmsg6bK28=;
        b=mqtW8Nk5pZlTH3THfn9Mxh9pvMkNjHtbTO9SmwhGqCIKynT15ADIq95eOclo32z1GD
         mRVoHL/85y/uwaW9SYabEd9qIqoGUGdvS9ifU7yNcak/MlNMivLX9HzIqk7VO/7ZtTnS
         CqVazmNdThzrr7m+R26XF2L5nHFRik2ncWn8cLFUXZnPkOsTDzueLVaUgWD7BZ/gBH0p
         QKz1y2jFiwOaUf5qA1CcwHYIo/novpxGPWEK++dwSLXAnOmoxB2sZ5lNOoFWu0cwIWQh
         GoAB3nhkskEnltwYVKJQL72W6JoCbSIsUCEOrtIeyOKmuh3xdJqeBYk7ya2yWgvAJeBH
         6Tdg==
X-Forwarded-Encrypted: i=1; AKwUvBwJsf+zGvj3WxuouU3a9hNyfmosfixDwhRPvXRYgsK8Orp2ade+PGM0lphP4aW+9csfi7Ilr4PK9Q==@kvack.org
X-Gm-Message-State: AFuF++kP+T6FLWMIAmOWjYHrwHRoEbOZM4jUK56AuA83i9zcMdfyS1BP
	hInJOxcrqa7VgrquzAdRErq1edHkBShFU1GnYnU4bvUuY1cIImpZZCRsoJdn3Q5yEZQeQ4q+E4V
	FQkuWXQ==
X-Received: from dlan4-n2.prod.google.com ([2002:a05:7022:eb44:20b0:144:d2ba:3139])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ecb:b0:39e:31ec:ba55
 with SMTP id 98e67ed59e1d1-39e54d36b09mr7394741a91.7.1789745607146; Fri, 18
 Sep 2026 08:33:27 -0700 (PDT)
Date: Fri, 18 Sep 2026 08:33:14 -0700
In-Reply-To: <20260918153318.758387-1-surenb@google.com>
Mime-Version: 1.0
References: <20260918153318.758387-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918153318.758387-4-surenb@google.com>
Subject: [PATCH v5 3/7] proc/task_mmu: clarify shmem mapping walk conditions
 in smap_gather_stats()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3mrmpm1fhdancmy4txej3edqdso9fyda
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A2394000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1789745608-549397
X-HE-Meta: U2FsdGVkX18QZ/uUNwoMAIWGGpVBYWA4cf7HOW9g7fOCAOrwXmnqlx4iTcnT+FwDPD0EHApDzpbx3jZt3FqWVPbk6LuTxnLcDXQKIDEWLeZHO0uvS/jberl3kMZmBUJBRo8nglgrRGT7nrmC3RtBDRoECug1c1aY9rg7h8mxcljqAkLqgwQjyRZCuMfgKAoHyZ7HdDLxSSKjjmt+BM57mUeSw1uPHhpJsiQOBJMHXETsV1JOexWCxWelx0dAlTriOYAlyGIlIod+hw8325JKGttIzFEn1/OnKexNTbKRklp1oNOrufLCyJNEgkiG1ADh86VNNnUxdJOLXR09eHC4f6jQkuys9f3mnP/8iRT4vNryDTv4GfjjBR0V8uyvoZMArmSo2+v/pJl+RpHUH3HEhPY4rBFXbsMktuNgo+8ibW2q3DAroxVyaybOwwWNtNRoNF024ZVmH+1SUqadeHu4NAmmKKiTQTaQ8+t3e7e2nc4NJB+XwfcCCqUmQ7YaPTbcsMNhlo/RFUl5j14vuqu/hFWb4EoK45IRK9NsJstwubQYzDhipv0M7KQBwf/ntCpLcFsv6Y6Uqcb/weDGHyRW8QtjodpKXhHMzAUfFN5Bva+Jo/C5tgY6XestksA2A0FnS0zUnn7DRxr0NIWXxeWB6Jtipm22vlH9nmWX40xh1zNokS3auqB5NUEm0mmAzSoaqjtdkQGdhs6Bl5acvnMeubKuw/ZEkvqWjuEpccLtOFYAijJapvnQVBhzkBwbj9TSJMDnD4KzE8X1Cnk+MveQbufqtTUnQFSTXNHHv/UEQHwPEKvVAOlA2oF4YASSmxHTiavmbwT42f/xh7jQyY1DjcJD4XbTzgjuN9+8ndlweE1h+dcSt48zVV84LQHiqn7KLcYSwFVUeOD7Re2EBR5nENuAa7IxauJ7pETEtBalqa4nz4aqEdRmBDa4coecKEPzncW4Af1+JTz6FB6z6g1
 6nweMPvg
 1efL2GLkXWq6WyhL0vFqGz6FYYvRvYwCllDtAXprhYAD5dC6qu+nYqPfoMjYXVjNmukvxH1RJnX2p20m6sHxDGg57+nyHDeefLoFS3uS7PPwDwkx2WXDr5iu7NXuuYAZH7W47VjE7ESceEpV42x+9XKWcgBhK7efDMLqjM0laHTw99S41FyAoV+IWWamxLOZ8qjDVzl8xs93b4Ffn/RWJqu/tRdShm+HkVts9h3RrDXWuwEKdYNzx8BLo8wZ38VB1MRGxHfS2svWPGXTXmp/5C7H7QOZlSzlaLxeTGHJe/GMhTX1mdC/q4DYsD1bxtn4BfVxYcdMRX6cRN+6hkX8mqdu61g7eP+VkhuTV1vKFqVziXkt2PoZ7GxvHigjIuLQDGv5l9Edfk9Zwfrj7evvUCoQcZytM+s0Wfeoc/EVpmMJZWw31nQPFnp7v96LKGksyxQfh9sgkMTf3wZwSLGDJPBGpVWzfRJRiuPILT7a8/wxKHaAX0+i3AvYxVxfgzj7L0cZdUHXJ7/hezQ6h98UlbN6FK2JvSv9qOwARes+R5trQnpSE+SmSsRhHcX2YiKKAqcCK2K7zhZObsT+QsyF1WfUbpPM2W7129Wabqc5csPQ1VJVHuj2mZI0Y4ftTexVa1AiQs5MBKfK1fDTn/8jycKa1tgbOSrk+cl7FsokTKcUWVU6iLjjqtmJJIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smap_gather_stats() optimizes stats gathering by skipping the walk for
shmem mappings in certain conditions. Update the comment to clarify
these conditions and use vma_is_cow_mapping() for CoW identification
instead of open-coding it.

No functional change intended.

Suggested by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8a72dc0dc945..f1ce15981253 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1274,23 +1274,18 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
 		/*
-		 * For shared or readonly shmem mappings we know that all
-		 * swapped out pages belong to the shmem object, and we can
-		 * obtain the swap value much more efficiently. For private
-		 * writable mappings, we might have COW pages that are
-		 * not affected by the parent swapped out pages of the shmem
-		 * object, so we have to distinguish them during the page walk.
-		 * Unless we know that the shmem object (or the part mapped by
-		 * our VMA) has no swapped out pages at all.
+		 * CoW mappings might map anon folios that do not belong to
+		 * shmem. Perform a less efficient page table walk in this
+		 * situation, unless we know that the shmem object (or the
+		 * part mapped by our VMA) has no swapped out pages at all.
 		 */
-		unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const bool is_cow = vma_is_cow_mapping(vma);
 
-		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE))) {
-			mss->swap += shmem_swapped;
-		} else {
+		if (start || (shmem_swapped && is_cow))
 			ops = get_smaps_shmem_walk_ops(priv);
-		}
+		else
+			mss->swap += shmem_swapped;
 	}
 
 	if (!start)
-- 
2.55.0.1082.g2b9226bbc0-goog


