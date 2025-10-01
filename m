Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1699CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74CC98E000C; Wed,  1 Oct 2025 15:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724DB8E0003; Wed,  1 Oct 2025 15:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC028E000C; Wed,  1 Oct 2025 15:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EEDE8E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:26:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07314119221
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:57 +0000 (UTC)
X-FDA: 83950528074.18.0A42CF1
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2ADCC40014
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HiXiSeu/";
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yCAVXUd+Xggdo34An12Zy3AWPX111PHofILGlMoG8c=;
	b=YjZYSS5ebpmk5+hzEcapHamfO6qSRXx4iIJEFywWambX6xwZqxWjlbw5+1RV9BlVIaMrvo
	qBm0aKFa+HhrlVLxm+76ecBurI3dF3YZWXAiVV3EbrUaOls0Qd5sGbK7aGufspNKRcK86A
	AbSdJdslkzwX/NekPQsUCUPSGBwR1pM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HiXiSeu/";
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346815; a=rsa-sha256;
	cv=none;
	b=vqfcslww49kdCr/Q0uERgTQeFVv7V49zwG646T/uGO/FwITRq83KuKPVaea4GvxoGydVz7
	xRdzxFPF9D/RhTwIzFsABFeHyYAsCGXKzhUJdnsOwEUX0wRhyIJ4IOItDnmbYL4V+0YN0T
	KZYc+OK/nVGXrf4RbNReix69cO6PmQo=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-57db15eeb11so225705e87.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346813; x=1759951613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yCAVXUd+Xggdo34An12Zy3AWPX111PHofILGlMoG8c=;
        b=HiXiSeu/bAkJDHRRfBIn5XJ3k/g1jYuPabGDiGAR4WlBEfQYV1yLa4IRmeoXhLXFB3
         Ha1uej148spSC8eZrpiJEFJf4DR2la4KFiYGG4ZY11xpQN6WOBR9G3nK94chkJbBDFU8
         c6KqBuGrNjn+Q1cvntYkPZqAX2LZv1ztw7Rf55wpDwanGgV3v52SZzdA0Yw8r8ZA5aGY
         qZEuGEGoeXth7xc+wQEsNihFZJBGF3NcNCfNQOOWqX5j8rSj5cbd44DsnqqC3u1iR9LD
         TpkYw2LZSgQJHBw+lvzWq9UPsSIoXryqBIvIGO0HNBxxlT71nHEfqYL788PDxAaHZjQ0
         PVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346813; x=1759951613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yCAVXUd+Xggdo34An12Zy3AWPX111PHofILGlMoG8c=;
        b=b+drdu8rCj1GYt1PmeCtvjsOfSa8Dhd1/6Rp7CLkrZ2jOf6cGrPnEafQue+YZ8sUrA
         PROt0od/U9xCGrgQC3kqxBzco9hUfMJtlY6zhbgfDG7YVH58/LlVzs7+XPvcT7u9CZ4o
         SFFPzEuGJQCOEs4VWA7WZEQZUAtW4NAtMil1YSOvaUJPJDR2AE7JQSzc2DtYFU1NM00m
         mo0w1bii1tjxjWjRkILcLg7MG8pGGAyA3oKFb+SWUaH0GvGDwAa/6lUPFRg6fFey6FvC
         lC5s3ijDT2FbN6JQeVyJfUz9MJkCMcKD/OVJqHRUbpKk4GH3x+Gp62SiznE0t78bQHwU
         kYWg==
X-Gm-Message-State: AOJu0YxbZOcDNwcnAA2cKH3FnuTpzDn85PEO4nrvyD5ye+BJ5k4ujL18
	FZ33FHtQqJzcdZcU+7Mk6jxY9ELG97Mns0USB01JJsH0/5XkhQ041AG24/u9Jt1H8Qs=
X-Gm-Gg: ASbGncsu43rocE0PEN83ENFI8VW7EDhFfE6cf3rLDIly4rbKQYxDmC8ZdLu6WKLwr1q
	UiwJmjRU18F9SNQ259PpvNyDwpUZ7qiW49VorKKwjkbaNgRvVS5Kflr3kyWEHIlL+wfMTIBbeFh
	tyON7yp0ISg+dbbPMf6oAftclRCXHoQ4+c2a4H6C0IQopVpeCb/X8Kf9dF60QBjm09kxtLseF4o
	joRjegdDd+ZXZyTs/fn+FmNKZlMID+1y1MI37fU5rXgeA/IVQFwhe/Ji8cRL9OkMeHAec133eV/
	FkglnRZa1vFgP5KpwdA6chWXN/I+MoNVskDqnanugdBZkrhG8QtTLZiN0+/8LwJAnxDtclkK59I
	kRjQe2MrO6zCltI95KKo6P3s0gNaVFk8TetC/7PZ/w722bpvRd5Q=
X-Google-Smtp-Source: AGHT+IF5fzKNeL87En2CtBg9XIbVfY39t145FRGMU6tdsljRKNoG0mSUH5/2UDHarr9y/rtlcz5Xkw==
X-Received: by 2002:a05:6512:23a9:b0:57b:8a82:1e27 with SMTP id 2adb3069b0e04-58af9f0d388mr1273724e87.13.1759346813320;
        Wed, 01 Oct 2025 12:26:53 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:52 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 05/10] mm/vmalloc: Handle non-blocking GFP in __vmalloc_area_node()
Date: Wed,  1 Oct 2025 21:26:41 +0200
Message-ID: <20251001192647.195204-6-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2ADCC40014
X-Stat-Signature: tm8cmkx8nu7n5e7t1jab8dqzw1a9b1hu
X-HE-Tag: 1759346814-287983
X-HE-Meta: U2FsdGVkX1/r5chKVGZzWwHK8KFefEe5gH90rc6aTR10841gJAQ//hqNds14Rc0cN+hl/8zkB7kkMPtYclXq2FNC8SKhCYoXT5q+zTZ1WU1YpuZtHu77920XPJtM2rIJYq1g5xhBA2kffcGElSDLtbJWVDw5+97Hf2PJ+mALrtJhSf9uiNm7rAoDowgiVjVsYx0ZRdELyeFkOK4i6oonWt+vtPbEpm4Pt73N53RUdDqMvZT7plBosMeqatk/+z4jCK4y7ynwnOOe+LseRhV9vV6A2DGcPB7iF0PnF94fiWeYtr+wkdHRyyoo5lMQi03uz4mxcNHbADci1m6TLXSMLO9mxmUC/FtBUZJObsDWEdbCHxHR28aBXZfImKSOff4YzihljJjRyTPAvZtMJ7uFGN9mgRdu/gGdE3XbkyP7wt9dMwiFdpwt5LtkAIo9V3tAjuTdGhrMKQd0SwsuVMwUmZySLBwqWzk0zGN8CvnN0e3OMqb0LF5O2EsfY/dkuBUymN9Cx8Jr45Xf9Yh3r/PSaYJN7E8DPB35wY/lNM8ArYfZIN6FwzeDzhF5vk4QbmQ33ymiiIHQ+78AmdJq3WezyNXKkgdFn6qeUejZNJs+oqpPj3DQQYXmmqs1Wz0VxDHv8h+ye112x5HDZSEu/jQCpJHiWEooDeTF2MRmViDE/QRNMJ89Lb3bla+P/XF+m/NqeFkZJxnx7hoDE/bweth8gUskY1bU7Y5V/I2SXQRmrxi0CMihpCl0Cvf7JP/wovk9iSKimVcqvqAl6iFCaXBX7cheGZB1sBCZN9cRGkmv0ji30xa/xpsTZ7fi75YbKDDnXN4DV0oc8tCO56oJjfiNJYgf6++/gFGeZcLJz2SJHgKkpnQzNC18jlfTs94eTu8OCpKABHRQYBImx0O5sruV6111Gw7C7Fb8URRYVIXT2vTZZ4qsiKgEsWdw8N75CYcy+xmn+bzF1r7vsdmfJRa
 /RZGLZpu
 /uEICW5jp8fkw/ZafR5ABtLL8Sp7XSW79Eyn47gBY/dGfhUp1W8407lBG0WBZn48n6WmF6y4LfvJUV9cyjWYn0VCiZrC8DOsSrWWnAFmgoTItuF0qiVFyXxneZGOROX9ZCRQoKHe4xHhTtpgFJnrMfMBT3RspU/B583zxjLnf0TJYm+anDXJ8t4szP379YV3fT9xu6/ZF1GZ8aQ3x2GaklTCo4SMXgGFp5sbp5lwK5/2GLEOomWO60T45ZT0Qm/zL9D4nVnXryXn6euFszk28qlFHlml4igiuZJpur2+V/t/UVVPyLU4YhpVQz/DO12uGkZ/9R1iFI7gtAJLI6fi2Mh3sYz5g/HYmguW8KQxNjtR03EsSGY4E2k/T63n2ai7+brgmVtzJTZ8Nid8qRCUtr1OOhhLMtXMwT61bG1TKAEQ3vQ/5wME9Ny0L0hlk44ibBno1mMnJe9L1BLCwf6lPQ6DACPDXEnop/jcRCJXy1/7FfVmSy44HKzdY/j+ZFI58cJe06DoMDSsqbdXwxf4lXtBorSQjxFtouOjjraX+u7LLE0g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make __vmalloc_area_node() respect non-blocking GFP masks such
as GFP_ATOMIC and GFP_NOWAIT.

- Add memalloc_apply_gfp_scope()/memalloc_restore_scope()
  helpers to apply a proper scope.
- Apply memalloc_apply_gfp_scope()/memalloc_restore_scope()
  around vmap_pages_range() for page table setup.
- Set "nofail" to false if a non-blocking mask is used, as
  they are mutually exclusive.

This is particularly important for page table allocations that
internally use GFP_PGTABLE_KERNEL, which may sleep unless such
scope restrictions are applied. For example:

<snip>
__pte_alloc_kernel()
  pte_alloc_one_kernel(&init_mm);
    pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
<snip>

Note: in most cases, PTE entries are established only up to the
level required by current vmap space usage, meaning the page tables
are typically fully populated during the mapping process.

Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/vmalloc.h |  2 ++
 mm/vmalloc.c            | 52 +++++++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 1e43181369f1..e8e94f90d686 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -332,4 +332,6 @@ bool vmalloc_dump_obj(void *object);
 static inline bool vmalloc_dump_obj(void *object) { return false; }
 #endif
 
+unsigned int memalloc_apply_gfp_scope(gfp_t gfp_mask);
+void memalloc_restore_scope(unsigned int flags);
 #endif /* _LINUX_VMALLOC_H */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9e29dd767c41..d8bcd87239b5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3716,6 +3716,42 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
 		schedule_work(&cleanup_vm_area);
 }
 
+/*
+ * Page tables allocations ignore external GFP. Enforces it by
+ * the memalloc scope API. It is used by vmalloc internals and
+ * KASAN shadow population only.
+ *
+ * GFP to scope mapping:
+ *
+ * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
+ * GFP_NOFS - memalloc_nofs_save()
+ * GFP_NOIO - memalloc_noio_save()
+ *
+ * Returns a flag cookie to pair with restore.
+ */
+unsigned int
+memalloc_apply_gfp_scope(gfp_t gfp_mask)
+{
+	unsigned int flags = 0;
+
+	if (!gfpflags_allow_blocking(gfp_mask))
+		flags = memalloc_noreclaim_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+		flags = memalloc_nofs_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+		flags = memalloc_noio_save();
+
+	/* 0 - no scope applied. */
+	return flags;
+}
+
+void
+memalloc_restore_scope(unsigned int flags)
+{
+	if (flags)
+		memalloc_flags_restore(flags);
+}
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -3732,6 +3768,10 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
 
+	/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
+	if (!gfpflags_allow_blocking(gfp_mask))
+		nofail = false;
+
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
 		gfp_mask |= __GFP_HIGHMEM;
 
@@ -3797,22 +3837,14 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * page tables allocations ignore external gfp mask, enforce it
 	 * by the scope API
 	 */
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-		flags = memalloc_nofs_save();
-	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-		flags = memalloc_noio_save();
-
+	flags = memalloc_apply_gfp_scope(gfp_mask);
 	do {
 		ret = vmap_pages_range(addr, addr + size, prot, area->pages,
 			page_shift);
 		if (nofail && (ret < 0))
 			schedule_timeout_uninterruptible(1);
 	} while (nofail && (ret < 0));
-
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-		memalloc_nofs_restore(flags);
-	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-		memalloc_noio_restore(flags);
+	memalloc_restore_scope(flags);
 
 	if (ret < 0) {
 		warn_alloc(gfp_mask, NULL,
-- 
2.47.3


