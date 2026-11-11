Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE694606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VOIzhbnP
Received: by kanga.kvack.org (Postfix)
	id B60E36B05B0; Wed, 11 Nov 2026 09:21:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38626B05B3; Wed, 11 Nov 2026 09:21:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E826B05B5; Wed, 11 Nov 2026 09:21:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 841896B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:21:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FEB51A01BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:21:09 +0000 (UTC)
X-FDA: 85423050258.02.0899B5C
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26EA118000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:21:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VOIzhbnP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794406867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ET7iczPctAVnyXFpp6ZDoVXUaxuU2xX/qY9AdNh6SRs=;
	b=xouIaLmgzRIFT9tCBggtJpQps4otHitWThHdFIzv9nKGFTokVPm+qxNkw/ePG04lp2Ojyn
	ETdz2ZQePHY3eUDlkv9LvqmX3vhnT0jtMUfr5eCDiMVXZBjU8S34qCJWjyh/gm8RA7S24O
	AUrDxBYCAjHCdQdnqK+HlmdMLkXecKk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VOIzhbnP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794406867;
	b=rXw7WTqLV80X0aOBox3xWV8n7bHbNHGs8cDD7MYn/qda4o1saivxVoYC+Dg/Lx4I8pDZEE
	4cHRB3BkE3XlS77STPfMUt8ChdTNN+vxYS43CwcKlYR8YMxH7kaGcqdkEtJDtl5uR+93aA
	eBbS+f/rWguVXHF3ludlRPNYo3GsQ2E=
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3b0d11b85f0so1935428a91.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794406866; x=1795011666; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ET7iczPctAVnyXFpp6ZDoVXUaxuU2xX/qY9AdNh6SRs=;
        b=VOIzhbnPN4LM7BXJ8UgRASr3GG7ZZwQr1mfxDJWkXdBxRceC076MiVo0lbd5cg8Oje
         uwDSpYMKNIwggc+avtgLTDCnPFMqfrgQB0ezpA/+l4jB7Iqmr/Aw9OWL84q7jSHA4De2
         V088sWTh36BW7tqXc3sheZLV8is29yw6ENj+5+YVnc6V13U7+ajNx5FdkxpJcI2xnrMK
         yj+1ctPr1BX52hYRhTa+NwEF0l0CLAXvPsDfP2kAxm89wfO/kXozgQWV/SNUkeZ5zNAi
         JHw3+eSOAg/YURxARVhDlC/OTajsrSQpByhlbEalDptDrr8BIq7uNz61LbJIUiTIsktF
         TLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406866; x=1795011666;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ET7iczPctAVnyXFpp6ZDoVXUaxuU2xX/qY9AdNh6SRs=;
        b=SY3ljfv2yTa+Yoz16uXSwbhzQyoStrM2zIFSYXO4R9qSWuTGTBcL4Nqubu0GtdKix4
         vhVDwgRLD7dgtBk44sudPyeGbzdFxgktVRaNr6bYQAUHrqxjS0ihfmmS4gjW83NRQAnV
         AUYabkeB+EuMXrG0buY0KYpDDs5hb7ChHC8O877FEykCN+s+89L8XuwNqQ1rNWMVtlqr
         pTaYoTgqlPT9warrhNkgghvgvT7IX0QX/glEREHhZOb9AY7yD9LdiqoDS0axEAx5l3Id
         1m+EdFKNuGYLsd6QianmBTjyNvQ8Rj8xzTuTN51kbrwcs1hwdhTkadwVYi3kez1vPRLA
         pcLQ==
X-Forwarded-Encrypted: i=1; AL+hErGosbaouDHiGBXeDV8BeLVJVTrMuznip43iesQAbkY1r5sFR3SATtWarbVPCkwDlICuU7JRUgNnUQ==@kvack.org
X-Gm-Message-State: APuU4Z9KJNAknyzJJi+E7cntNQecTS6ZEzzVDS10oTw8ulgds8o2Xbs3
	FrvsYYSjj5gJ14ZJJR99qL9eesyrDqA5KTXhBu7AHdyqhJ/ftTxZ2Vy4
X-Gm-Gg: AYBFou2Q7NW+t6g7mF+fn494J2HimQhhwwuORedtFjEgYzSmp7KCRCWqEGVJ+07f6ww
	exurnMQoGRDozoBA1xO/PsjGl6Izshfs+qaahcZFat+gfhRpdXtMLRXC6j1Rcx7a4Mg8pmN/p9z
	kyzok6zDfSnxfY66+MfVt1bpngXbhTo+9Y4xPqItetzwEvG7sXO175d+AT661V9jaF8ar3v4fyd
	jQIz5zteHs76kV9s2wrFS+RSMFgAW3iFqmnKrwKPLG/FNnIKe6SX7CMYMU/YMHaWNaKq2f/VqaK
	gslrHDBGtXuXIdsn72ePttSob5DCZD0XNQ6Ky4xL32ytn9qMp5K8WCRyPO2p9Nt1J1JRKx66UPD
	Lu8LzwFI4b7sx6AgVKnyNzycEl9EyzSUwKVsRcXlsareS4lDyfzcI4in6q55q6wOqTAHz9hSo0N
	5xJ27RgfPGmAEEkOdE5GZQricUvNTj4UNZZ7yrghnRNX9UU16YDcjnMKKMO0Bg6dDPUe6Glcd3Z
	f/Ea4eThDNGdJsJSsyWdjxbfM5K/IZsJH3qG1b5PaSzCuidAo5KJPJguGYc89Ymj64yx6+JTMoI
	Q84O/J1zOidOZXgUWuQvDTQX6kGRdZF/KlTsvK6zSFdYcVJN0Hx5yFOOsVWaFUCgMm+WyhDB2c1
	cVGsE4OO6DlD8e3QCLbqKCc/0qg==
X-Received: by 2002:a17:90b:2541:b0:3b0:a757:4f85 with SMTP id 98e67ed59e1d1-3b182df3396mr2481822a91.2.1794406865432;
        Wed, 11 Nov 2026 06:21:05 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b186234c12sm2844333a91.10.2026.11.11.06.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:21:04 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 12 Nov 2026 01:11:35 +1100
Subject: [PATCH] mm: multi-gen LRU: migrate every mm owner on memcg attach
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-mglru-memcg-attach-fix-20261112-v1-1-4c3c707ba922@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z2NwQrCMBBEf6Xs2YWmFFv9FfGw2axJxERJ0iKU/
 ruJgsc3M7zZIEvykuHcbZBk9dk/YwV16IAdRSvoTWUY+uGolBow2EdaMEhgi1QKscObf+O/nwy
 PJzOPUz8zVMsrSe2/D5frj/Oi78KladtCUxbUiSK7FgXKRRLs+wdXZ6+snAAAAA==
X-Change-ID: 20261112-mglru-memcg-attach-fix-20261112-7dc49d84708c
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Yu Zhao <yuzhao@google.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brian Geffon <bgeffon@google.com>, 
 "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, 
 Oleksandr Natalenko <oleksandr@natalenko.name>, 
 Steven Barrett <steven@liquorix.net>, 
 Suleiman Souhlal <suleiman@google.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 26EA118000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qtim5n1j7fa9zrn1rq436j8ooqwtuezg
X-HE-Tag: 1794406866-767950
X-HE-Meta: U2FsdGVkX1/xZKvoG7fWOx9RwfDxKgELyeRYTW86KpFdN5leuyrIB6M/wtz5CYjvxQqqzI4wY1D8sm1M5eDU2Xup91FYtYd7YeXxvXErLZtR39GxzgpI5/lRijuE90QaQrg8wFiAiPtC+HXpXizMNHU27kS6IldmKHaxCpkbYG9v90IVU2gjl5pL10Kxv8U/m14Dk5gAm4qAL3KqpO6CMCdxgXmUtZZgAq3/4ks/nDaJX9QyYhCnrU4d5lPpu9sZh87JDvt/wKHhhauNL1gy0mEsDBH5JCRXJYIDiFII0oiLNNw92aKbl4dohLRj3il//dQ9u+Ni8BUiXZV6XSJd5A7YZh3JRSnjv1CoquDqOEKs3G4CxVdQjW4N0+WABKnbyeZnv2a8+ojS8U+xEJ4hYklRlxkUuPLY9CS3FIrH2MV71uuJbsxDViRcaxwq0bReFaVuDziQT1plqp8oP6qR6rs7iw9DihkM3MciQHPwp9i1K6NcXQEepzn8g1CCPYkE11ZfNDPnw6rdx9BVPJisjbwPTrlHppBZMtnMfP9gef6zrgJGmF5hsPyT39ZstZtAxwo1X6EmQ/SZ2r3VKZeKEPjGGzGV5MqebmmAhli5PGabVwUIUp4NUt4za0jGSZW7DntjKAzzizHBvn3SzqpQTyHMT1r6J6J9kr/gGmZ4NmWEpe7TBxqy06P7MFJVPx4Bt1EVG/SRmfAXoXgJxvLtWoXIuGC3FsYJpyp+vi5Z1Q/iQwuOw5x/JIS3jb+Lo0BibAdgnCeFcdLwG8JjlI034NFIdvwvzwAjY1h7Gj4bbyOGPXTMLQ8KeUUYFr/Yng2RRMetccxs5Hj3ETpJ7TOlK5ED7aZoIF3AGDflnfprqnZBjE7m7ueZK4rKLVdzi0XDRIjzWlRWYGeO0fy1+4TFvJoaffPj6i6xQzJ9qJPCyQbpO3Uevg9BKLDhGuw9HosAx+fLPdMiA/vY1u7iEzQ
 Or56PPPE
 ov3vjYO19WCZFI+rjHnittyuSjGpoje9dn67Wvf6eOYG1KZvcxYzzX/H2hv8UZFUJKQA4hM3ZpHwgL1GlGf47PsYm82jG8DEKsqEzw7Mek5xQWXvFqqIzHeD9XBh91T1jJdVkxsXY4fap8IX0tyUFtyvyfjrlds5Bn9Ccz7vir45zIbsv0suwUwKC+MhnGe6CrR1/OVCS5UYVqcZxvCQNTeBiApu77wGJw1zqRbiLQfOwz/0IqLwoc3Nurt3lxrwrcOYdMkkZICQwzdq78JG4ggPpmlcXtt8XV+RxgDMb3V4OG3lP/HMiRDH0bBtiMFsGVe4Qy1Gkx7uVErHnBGOEbQVimovQWQFu0VGrQMtQEZUO33267bLgkgogYgW4njMWceoRN65RgXCIGFFsKmtmNf5VEBwrOHJY8ABhWxI+jGpMyWuTw9bTR6TNcCTUPs7xH9mjoDj/jOKz9ua3DA5VlOVevg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a task moves to another memcg, MGLRU should move the mm it owns to
the new memcg's mm list.  mem_cgroup_lru_gen_attach() only checks the
first thread-group leader in the taskset, though.  A taskset can have
several processes, e.g., when +memory is enabled on a parent, or no
leader at all if the leader has exited.  An mm missed this way stays on
the old list, so the new memcg's aging doesn't walk it, and it keeps the
old memcg alive after its memory controller is disabled.

Check every task in the taskset instead.  Skip this when MGLRU doesn't
walk page tables, since lru_gen_migrate_mm() does nothing then.

This takes task_lock() for every task being moved.  Moving a 256-thread
process via cgroup.procs got about 2.8 us (26%) slower in a QEMU/KVM
microbenchmark.

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Reproducers for both cases pass on x86_64.
---
 mm/memcontrol.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..4590a9bfd9ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4762,27 +4762,22 @@ static void mem_cgroup_exit(struct task_struct *task)
 	task->objcg = NULL;
 }
 
-#ifdef CONFIG_LRU_GEN
+#ifdef CONFIG_LRU_GEN_WALKS_MMU
 static void mem_cgroup_lru_gen_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
 	struct cgroup_subsys_state *css;
 
-	/* find the first leader if there is any */
-	cgroup_taskset_for_each_leader(task, css, tset)
-		break;
-
-	if (!task)
-		return;
-
-	task_lock(task);
-	if (task->mm && READ_ONCE(task->mm->owner) == task)
-		lru_gen_migrate_mm(task->mm);
-	task_unlock(task);
+	cgroup_taskset_for_each(task, css, tset) {
+		task_lock(task);
+		if (task->mm && READ_ONCE(task->mm->owner) == task)
+			lru_gen_migrate_mm(task->mm);
+		task_unlock(task);
+	}
 }
 #else
 static void mem_cgroup_lru_gen_attach(struct cgroup_taskset *tset) {}
-#endif /* CONFIG_LRU_GEN */
+#endif /* CONFIG_LRU_GEN_WALKS_MMU */
 
 static void mem_cgroup_kmem_attach(struct cgroup_taskset *tset)
 {

---
base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
change-id: 20261112-mglru-memcg-attach-fix-20261112-7dc49d84708c

Best regards,
--  
Aveline Noir <jm5905938@gmail.com>


