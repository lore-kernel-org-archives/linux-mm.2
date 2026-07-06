Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0DD1C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604266B00B9; Mon,  6 Jul 2026 13:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBB16B00BA; Mon,  6 Jul 2026 13:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC2A6B00BB; Mon,  6 Jul 2026 13:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17FA26B00B9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:55:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F6D5A01A9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:55:12 +0000 (UTC)
X-FDA: 84959103264.19.FFA83DC
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 94AF1120006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:55:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qOuUCXIY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWy+bnn3yMum/vuSl7ClBqJ7Vcv4n74EsH2PruuLics=;
	b=UGGFj6h5INEaJ9mrAIWINyE58sp1GerlgGFKT8osGmOZ9M1P6srDVl8bolPgP1/q2y44YZ
	o8WItXnFiBctsX6HrFqw+TT6yyWpHtYv1JFpBCvysLMmHKYf4xEW2JAHidVELG04jyCy6z
	FixeAdFRJLg20s+ywROsSLhzLFJYgi4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qOuUCXIY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360510;
	b=3N3WmrKl1d8WOJjUeBjycKKkvUPory9AUSCwAdgvBrvHxZtTXeIagJneY5/V6U09KM3Avh
	U/VccEHi27V29JaIvGMk6950OZ479rt2fKRC9eHujTB5P1Kk1Q0/RYYN4a64Wu1L+FIRfA
	uANKPoJSpHqF5IFteqb5A7B3jaZK/kU=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-382a3fe0d28so2537583a91.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783360509; x=1783965309; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WWy+bnn3yMum/vuSl7ClBqJ7Vcv4n74EsH2PruuLics=;
        b=qOuUCXIYJzNvVFkeg9Pboaa0uv97s0AG/PdJaaO6XaOlPePmHpKkDcZQU0gm4vptuN
         qB7PJ6WA2peqVZK7tlt0qwpNAKbkAxh4Rnapa4BsIu9ZGrVDm5r0bEpemIJyz5LiFWGE
         EU3rZ4ZAPEtKbD/sLS93TcEdOFxU2qZYjZyUQIlyby/JAnKzvdwSrplcN7SCZ5DsRFpQ
         1bH8EGeSfNFZhA/J4kQh5UloZtJvppgVktFm4OgnPXHQtQKjmF/8qhM6Xx53OCRZvnib
         RrdZM/Zn3qNqSI8usgoRqn1dE8VEe0P9akgbeh1UraCLoSASFlh/hpdkEW4p89LorPyf
         1G/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360509; x=1783965309;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WWy+bnn3yMum/vuSl7ClBqJ7Vcv4n74EsH2PruuLics=;
        b=PnBOdkRwOejFoH36+iduM/4Def5sY0J0ue9RYh5qyX3Tr8bcMsFCaAQUEDFefjJSz1
         3n9n9bzIPHut0g9JcLfvNn3iQRQgkKE/n+nFL/k0OB44+5SSoTJkPzLfCDNCtphjy1PJ
         d40h5GHuKyW7eshTvRRfTR8kSMVG3n8RUbnzhC29ycSNBOFNuHn4loLMj1FMJlO9meML
         CcJiOqiO7V9Pv5yyFz2chhO6DeqVyLiAFkUCTlaqkbYRFLKcRIl+LG6LM1omBYn9/fhq
         PWspCGfjr/qCMof5KBpm6TKrlywRlnha4pZkGUhFmRlNwk5oe8WB6sQBglrmzlDjU5JN
         XszA==
X-Forwarded-Encrypted: i=1; AHgh+RqMU8HNN9WOc+EM+of6XVLkeknD9+WHH1tg8adMERLyQZ8cD+e/xx3hv4T7VukyqBJO3INpRdcPSA==@kvack.org
X-Gm-Message-State: AOJu0YwMtVqbz/VI8Q1VH3TWUWLOKWn1/K2oRSn+BxDUH8pFm2Pda9SN
	DUMkydvgEl6+yEaxMzVHdekbM2v+HoScUlAPft+PnUxm1HGlOUAZC1Pn
X-Gm-Gg: AfdE7cmzZS6wcsGzhdq2w3+e6oz8MaFvEndga0yPAJmynfoUwcv1iVdQwcxujCHdxpd
	SrQvK7bdb2vimVyoD06O+qzxlUGAOIOtOU+qkdq5KwqejFhbAPw8E1EOQ2YKLNhn5zDKCaeS2gQ
	ty13j6/CvFGs6kXfGHb0Vne3krwdo+KAZwyoQCopEaiNa2GrICdSuYovM2HjViiIRa2p+XSUoRE
	v38G4gfdU3jwwxz2XjeE981RHSfWJH0e4j+yu2RJH/eDEkUEGRo/JlOiJz5G1+bwcgFGuBxU2Jn
	ldN1zYUNq3xtNq7Au/m1nJXd9qnFVvrU/wpMuFavdFh102nk7hAoi78MR2tsMa/x81C5dPIAQZp
	WmW+bOzRJZ1apqGbdsvk4KluK1yyoxrdsqIyl0Jr72pmB+YDvc3Bso0oGdP8s4tcyOWXpj3ImjQ
	YhcXTPnmsp4fO/34mmi5ayBRZUid/XBWgpYonqkkgs9/3qaRJP3B5ijoUka/w=
X-Received: by 2002:a17:90b:2652:b0:37d:f206:a2ac with SMTP id 98e67ed59e1d1-38755573a58mr1666168a91.7.1783360509393;
        Mon, 06 Jul 2026 10:55:09 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38127c8b700sm5654078a91.11.2026.07.06.10.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 10:55:08 -0700 (PDT)
Subject: [PATCH v6 2/4] mm/hmm: add hmm_range_fault_unlocked() for mmap
 lock-drop support
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com, kys@microsoft.com,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 longli@microsoft.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-hyperv@vger.kernel.org
Date: Mon, 06 Jul 2026 10:55:07 -0700
Message-ID: <178336050736.504354.6052508493877924780.stgit@skinsburskii>
In-Reply-To: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
References: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: buezqrfdca1kycenmomg3fea8e5gju97
X-Rspamd-Queue-Id: 94AF1120006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783360510-683208
X-HE-Meta: U2FsdGVkX18KamaOiODDUbvPdGR3Qx4tXq1jdpZyTp5COL/H/LqK8Z8Nl5q0jfIhhpwNVjsQocY96ENCNuK8tPBJmQwNpEQw/8utvjSvFuvD5uzpQEbY+K2hf6eiLkd3iGPk8ywiUVwjZW+fjJiJzc/yrEDKCGJI8p6knhhuSkB5EaWAh1C+1VMrT7RKKeGlXCkpadnQGYkya1f/ZoCreR4jcKzJUAZa1uO0lvxt6A20o/zPcm5atkauldVIMiHcBvx8pZ3MhIEkQN4zDC8JzBKry6kBqqNMZJrGiJtTQbX8MwOcUMjE/RnXW77o2XH9br2wdI1tpyjR/ZemARYkDJkTVpmSMWXedXvG+MynBEqowWXZTmtxFS/TlbG6JYJX8nD7NCkWswBosvwz++VFSNQhuOCeS9hK/bxu4BjoVAUNmHxE9RCwdgAC3qJTNEsho+DmleI8VUjWykCCs35Jt1WIsV+mCgS9dFeAzbsn4Vr/wh9OB8ZmiOnGEqRChJuWAYNEZFw4jO5n5NWFHM+i8rIyFXfnQ9dkpLM6vLShnktPdr9DPzGTzW7pCK0kfMmFgsIrydlZy/UcXYRjrX6atn54ty3jXNtSkaxC4jZkAdyF9AHE+AfdlzRhZfm7h9EkZYDjP0kagLWawpq+lWtZz9lGmzXtEXgXCDK4GBTUng7+3lTJ0Ngup9RElwhYVESTmNzNpcVbjiCd9+Io6DUWR4850p5w6zKjry0S7gLNodoPrzbBAtbcIpHHZwUvi2JTVCEpcwAcV1m1zSCYfcUkENg7kCMNuYnbPCJ+8dm/DDwmA/Pzmh7UK9JOuY+3hJMWVn4Pk3vXEvDSsLI1nzTKY59SyBAtv0VOkVO5+AVA8Esph1bNUXNALxS1lEFdwLnfYrfPteD6mx9HrgdRAoc0seuKgNcvuUC41mkcHbyHGTN3T01NPRNBUYnNOuDDL2yUAAJcIjVQUaWRiFXdpy4
 O554Xto9
 QlEnHyol4PUM9exDQVmJvWDhE9s5UF4IsgKC2mC89DUacoNGMJ67rsinJweAdu45UD7k9tadoiW7VNNW9u2BtJ/jB2dsivHP4JfMw1vpLNWIW44Q/qyRogn3JAnzCOM6TLKgJDvJdIQh3qxIRAJJnZ9ChWaju9fum2px4JRiPxbWQWuu8U7ciYnrwPZaxysM23WOkDg1HskgzxzTfIxGDFTgu8iV7/RjXWX2jS9YadIBO1j3cTk2HGlPeuyQBDxKqTqkEXOIxgZcGmFLCaNGnSTUnJh4yTXAQIwuUz6FRFDsqG9LmVP+UEivh3dP/mEToxfP2BqYW+pwgDbql2vrAP08RpYYXqicEWjY8LSq7ZLvoHBnq1h+wO/HxJZZ5gZTuR/yIOMlPEGtlYf03MtvK2/HEx0NxmCmQBtDSwBAtLcLoNDUC66d4lqsSGyG1QMaottXCkvWn88FtTO2qynv+xzuZDz99JyU07sWjjpcLiuEFdY72DqW+WJCf1aslj7LGv5M6Gwn35EcxjyBQQtzMFItVL/+Tnq2Z+4aRSB8N1HFC/8m0xHYtpGwDO7sT8KveJS7n9TCYORoFGqLtjTHlxCsXyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hmm_range_fault() requires the caller to hold the mmap read lock for the
duration of the call. This is incompatible with mappings whose fault
handler may release the mmap lock, notably userfaultfd-managed regions,
where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
after dropping the lock. Drivers that need to populate device page tables
for such mappings have no way to do so today.

Add hmm_range_fault_unlocked() for callers that do not need to hold
mmap_lock across any work outside the HMM fault itself. The new helper
takes mmap_read_lock() internally, calls the common HMM fault
implementation, and releases the lock before returning if it is still
held.

When handle_mm_fault() drops mmap_lock, hmm_range_fault_unlocked() returns
-EBUSY. The caller must then restart its HMM walk with a fresh
mmu_interval_read_begin() sequence. If a fatal signal is pending after the
lock has been dropped, -EINTR is returned instead. This gives callers a
simple restart contract while allowing fault handlers that must drop
mmap_lock, including userfaultfd-backed mappings, to make progress.

The common implementation conditionally sets FAULT_FLAG_ALLOW_RETRY and
FAULT_FLAG_KILLABLE only for hmm_range_fault_unlocked(). The existing
hmm_range_fault() path still passes no locked state, does not allow
handle_mm_fault() to drop mmap_lock, and remains a thin wrapper preserving
the existing API contract for current callers.

The previous refactor that moved page fault handling out of the
page-table walk callbacks is what makes this change small. Faults now run
after walk_page_range() has unwound, with only mmap_lock held, so dropping
it does not interact with the walker's pte spinlock or hugetlb_vma_lock.
Hugetlb regions therefore participate in the unlocked path uniformly with
PTE- and PMD-level mappings; no special case is required.

Documentation/mm/hmm.rst is updated with a description of the new API and
the recommended caller pattern.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 Documentation/mm/hmm.rst |   59 +++++++++++++++++++++
 include/linux/hmm.h      |    1 
 mm/hmm.c                 |  129 ++++++++++++++++++++++++++++++++++++----------
 3 files changed, 160 insertions(+), 29 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 7d61b7a8b65b..844343712abd 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -208,6 +208,65 @@ invalidate() callback. That lock must be held before calling
 mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
 update.
 
+Dropping the mmap lock during page faults
+=========================================
+
+Some VMAs have fault handlers that need to release the mmap lock while
+servicing a fault (for example, regions managed by ``userfaultfd``).
+``hmm_range_fault()`` cannot be used on such mappings because it must hold the
+mmap lock for the duration of the call. Drivers that need to support them
+should call::
+
+  int hmm_range_fault_unlocked(struct hmm_range *range);
+
+The caller must not hold ``mmap_read_lock`` before the call.
+``hmm_range_fault_unlocked()`` takes the mmap read lock internally and allows
+``handle_mm_fault()`` to drop it during fault handling. If the mmap lock is
+dropped, the function returns ``-EBUSY``. The caller must then restart the
+walk from ``range->start`` with a fresh notifier sequence. ``-EINTR`` is
+returned if a fatal signal is pending during retry handling.
+
+A typical caller looks like this::
+
+ int driver_populate_range_unlocked(...)
+ {
+      struct hmm_range range;
+      ...
+
+      range.notifier = &interval_sub;
+      range.start = ...;
+      range.end = ...;
+      range.hmm_pfns = ...;
+
+      if (!mmget_not_zero(interval_sub.mm))
+          return -EFAULT;
+
+ again:
+      range.notifier_seq = mmu_interval_read_begin(&interval_sub);
+      ret = hmm_range_fault_unlocked(&range);
+      if (ret) {
+          if (ret == -EBUSY)
+              goto again;
+          goto out_put;
+      }
+
+      take_lock(driver->update);
+      if (mmu_interval_read_retry(&interval_sub, range.notifier_seq)) {
+          release_lock(driver->update);
+          goto again;
+      }
+
+      /* Use pfns array content to update device page table,
+       * under the update lock */
+
+      release_lock(driver->update);
+      ret = 0;
+
+ out_put:
+      mmput(interval_sub.mm);
+      return ret;
+ }
+
 Leverage default_flags and pfn_flags_mask
 =========================================
 
diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..1b584e5a2900 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -123,6 +123,7 @@ struct hmm_range {
  * Please see Documentation/mm/hmm.rst for how to use the range API.
  */
 int hmm_range_fault(struct hmm_range *range);
+int hmm_range_fault_unlocked(struct hmm_range *range);
 
 /*
  * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
diff --git a/mm/hmm.c b/mm/hmm.c
index 2129b1ee4c35..316116994209 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -32,6 +32,7 @@
 
 struct hmm_vma_walk {
 	struct hmm_range	*range;
+	int			*locked;
 	unsigned long		last;
 	unsigned long		end;
 	unsigned int		required_fault;
@@ -44,6 +45,14 @@ struct hmm_vma_walk {
  */
 #define HMM_FAULT_PENDING	-EAGAIN
 
+/*
+ * Internal sentinel returned by hmm_do_fault() when handle_mm_fault()
+ * completes a page fault with the mmap lock dropped. hmm_do_fault() sets
+ * *locked = 0; the outer loop consumes the sentinel and never propagates it
+ * to the caller.
+ */
+#define HMM_FAULT_UNLOCKED	-ENOLCK
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -73,9 +82,9 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
  *
  * Called by the walk callbacks when they discover that part of the range
  * needs a page fault.  The callback records what to fault and returns
- * HMM_FAULT_PENDING; the outer loop in hmm_range_fault() drops back out of
- * walk_page_range() and invokes handle_mm_fault() from a context where no
- * page-table or hugetlb_vma_lock is held.
+ * HMM_FAULT_PENDING; the outer loop in hmm_range_fault_locked() drops
+ * back out of walk_page_range() and invokes handle_mm_fault() from a context
+ * where no page-table or hugetlb_vma_lock is held.
  */
 static int hmm_record_fault(unsigned long addr, unsigned long end,
 			    unsigned int required_fault,
@@ -624,7 +633,7 @@ static const struct mm_walk_ops hmm_walk_ops = {
 /*
  * hmm_do_fault - fault in a range recorded by a walk callback
  *
- * Called from the outer loop in hmm_range_fault() after a callback
+ * Called from the outer loop in hmm_range_fault_locked() after a callback
  * returned HMM_FAULT_PENDING.  At this point we hold only mmap_lock;
  * the page-table spinlock and any hugetlb_vma_lock acquired by the walk
  * framework have already been released by the unwind.
@@ -641,6 +650,9 @@ static int hmm_do_fault(struct mm_struct *mm,
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 	struct vm_area_struct *vma;
 
+	if (hmm_vma_walk->locked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+
 	vma = vma_lookup(mm, addr);
 	if (!vma)
 		return -EFAULT;
@@ -651,37 +663,33 @@ static int hmm_do_fault(struct mm_struct *mm,
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
 
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
-			return -EFAULT;
+	for (; addr < end; addr += PAGE_SIZE) {
+		vm_fault_t ret;
+
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+
+		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
+			*hmm_vma_walk->locked = 0;
+			return HMM_FAULT_UNLOCKED;
+		}
+
+		if (ret & VM_FAULT_ERROR) {
+			int err = vm_fault_to_errno(ret, 0);
+
+			if (err)
+				return err;
+			BUG();
+		}
+	}
 
 	return -EBUSY;
 }
 
-/**
- * hmm_range_fault - try to fault some address in a virtual address range
- * @range:	argument structure
- *
- * Returns 0 on success or one of the following error codes:
- *
- * -EINVAL:	Invalid arguments or mm or virtual address is in an invalid vma
- *		(e.g., device file vma).
- * -ENOMEM:	Out of memory.
- * -EPERM:	Invalid permission (e.g., asking for write and range is read
- *		only).
- * -EBUSY:	The range has been invalidated and the caller needs to wait for
- *		the invalidation to finish.
- * -EFAULT:     A page was requested to be valid and could not be made valid
- *              ie it has no backing VMA or it is illegal to access
- *
- * This is similar to get_user_pages(), except that it can read the page tables
- * without mutating them (ie causing faults).
- */
-int hmm_range_fault(struct hmm_range *range)
+static int hmm_range_fault_locked(struct hmm_range *range, int *locked)
 {
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
+		.locked = locked,
 		.last = range->start,
 	};
 	struct mm_struct *mm = range->notifier->mm;
@@ -704,8 +712,14 @@ int hmm_range_fault(struct hmm_range *range)
 		 * returns -EBUSY so the loop re-walks and picks up the
 		 * now-present entries.
 		 */
-		if (ret == HMM_FAULT_PENDING)
+		if (ret == HMM_FAULT_PENDING) {
 			ret = hmm_do_fault(mm, &hmm_vma_walk);
+			if (ret == HMM_FAULT_UNLOCKED) {
+				if (fatal_signal_pending(current))
+					return -EINTR;
+				return -EBUSY;
+			}
+		}
 		/*
 		 * When -EBUSY is returned the loop restarts with
 		 * hmm_vma_walk.last set to an address that has not been stored
@@ -715,8 +729,65 @@ int hmm_range_fault(struct hmm_range *range)
 	} while (ret == -EBUSY);
 	return ret;
 }
+
+/**
+ * hmm_range_fault - try to fault some address in a virtual address range
+ * @range:	argument structure
+ *
+ * Returns 0 on success or one of the following error codes:
+ *
+ * -EINVAL:	Invalid arguments or mm or virtual address is in an invalid vma
+ *		(e.g., device file vma).
+ * -ENOMEM:	Out of memory.
+ * -EPERM:	Invalid permission (e.g., asking for write and range is read
+ *		only).
+ * -EBUSY:	The range has been invalidated and the caller needs to wait for
+ *		the invalidation to finish.
+ * -EFAULT:     A page was requested to be valid and could not be made valid
+ *              ie it has no backing VMA or it is illegal to access
+ *
+ * This is similar to get_user_pages(), except that it can read the page tables
+ * without mutating them (ie causing faults).
+ *
+ * The mmap lock must be held by the caller and will remain held on return.
+ * For a variant that allows the mmap lock to be dropped during faults (e.g.,
+ * for userfaultfd support), see hmm_range_fault_unlocked().
+ */
+int hmm_range_fault(struct hmm_range *range)
+{
+	return hmm_range_fault_locked(range, NULL);
+}
 EXPORT_SYMBOL(hmm_range_fault);
 
+/**
+ * hmm_range_fault_unlocked - fault in a range, possibly dropping the mmap lock
+ * @range:	argument structure
+ *
+ * This is similar to hmm_range_fault(), except the caller must not hold the
+ * mmap lock. The function takes the mmap read lock internally and allows
+ * handle_mm_fault() to drop it during faults. If the lock is dropped, the
+ * function returns -EBUSY and the caller must restart the walk with a fresh
+ * mmu_interval_read_begin() sequence.
+ *
+ * Returns 0 on success or one of the error codes documented for
+ * hmm_range_fault(). -EINTR is returned if a fatal signal is pending during
+ * retry handling.
+ */
+int hmm_range_fault_unlocked(struct hmm_range *range)
+{
+	struct mm_struct *mm = range->notifier->mm;
+	int locked = 1;
+	int ret;
+
+	mmap_read_lock(mm);
+	ret = hmm_range_fault_locked(range, &locked);
+	if (locked)
+		mmap_read_unlock(mm);
+
+	return ret;
+}
+EXPORT_SYMBOL(hmm_range_fault_unlocked);
+
 /**
  * hmm_dma_map_alloc - Allocate HMM map structure
  * @dev: device to allocate structure for



