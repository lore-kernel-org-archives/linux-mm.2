Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE3F7FC5907
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252306B008C; Thu, 26 Feb 2026 02:06:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B796B0095; Thu, 26 Feb 2026 02:06:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73236B0099; Thu, 26 Feb 2026 02:06:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE5E66B008C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:06:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9612A5BF1F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:20 +0000 (UTC)
X-FDA: 84485724120.09.1EC475B
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id C6F7C8000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nXYnVVQo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 36fCfaQYKCJ4QSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=36fCfaQYKCJ4QSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089578; a=rsa-sha256;
	cv=none;
	b=LCrgPF1AURQUEPhK+Uo+fVlD17M+uIwLScq4eap++4zzkzNsCO1FPB2f3R8/FjkbeDe6Zm
	ahT3REc//7ejVKpVbRU5VQXqcpb/gRoJs7fTu3pcoJ4YAF+RKFOdEB1yeBNntBF+nx3SOs
	m+Xki9B2d1uRk9snvPPYaYWAP9Hl+K0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nXYnVVQo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 36fCfaQYKCJ4QSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=36fCfaQYKCJ4QSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0h74aJcSXnDLzdO9/+xWfXmwkWXbud4wNQ9AdoodIg=;
	b=xmbvpk0ExehFhBC1IZ1l70QBKpsV7il5zq89z4qNcTEigC4hki1WuJkzMT3FKkPX+nZtZ2
	7vv0amzeCn1X14zvCpvlqmiao8JlY+VXdo/ZZ9YaBxJouLugUbL+gMmMl5IOAeuBLUrJuw
	QldfQotHfbsP/eOLVCddB4dUIP6PEUI=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12711ec96fbso9966856c88.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772089578; x=1772694378; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W0h74aJcSXnDLzdO9/+xWfXmwkWXbud4wNQ9AdoodIg=;
        b=nXYnVVQoIo+RPtxOtkyGpr8mYl3qzDf2KUJnB+6Q3+dzaurBmCDgA3TTmBplUNVC2T
         oHNNcKBqYc3SQg3qFSQMMPSqR0MlIQmROdYTag8trW1szf8WCZA1DnAJY0Ah6m6AYC5P
         BcuIPxxk6T9aHOqGot0l4ujB68HU8YoUq7e0zfBKiUItCzHclmMTcprHqYDOZvg0EUEz
         stbf9sCRAPImpoi6OJFhBEwrfazrescJnOXGq7iVZciYPkNRIhJ+8tWtzWkJ0HLWMR9x
         sQ5yqMiCyPFXRAbPRzqz0JmkOqX9vutLGVTS7JHDUxsLDsEKQAnHnGIf7JnvFsuyZFmJ
         KPDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089578; x=1772694378;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W0h74aJcSXnDLzdO9/+xWfXmwkWXbud4wNQ9AdoodIg=;
        b=sWf9HUe+DsIz+rTHFqBS8fEGXx5+c5HNQWuEBTgqSPxIGreHlmQ/AtN5v4lOReMa0I
         GldRrBKuv+Xl0F+sMKNY6ObGZtY019stpIpdA3uYiOY5SUAHdsE2K0ArxfjqVt0PkpsV
         dQGtqsB7UCkpNGif9mnD5doZnmIT/UH87PeOb3S1MoRsD19DT8k/YDGIGvAEKBapn6qi
         h7gE3d7uc8+QwTIv7Ag8p/lpOgUNH9xpa8a394nCCAz6xUyCwXizDu0pLqrqkmJ67m/H
         FIyTMdrYN0O1qYQVtfxQ6Rwus1vHIX1Y2PgazFQAbTsMbKd1Ya26yKbG5pxeN37C4lC1
         BHuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUS0W3kqECPtJqtTKWl7USx7hz0tuyZiy9YdxU/C45KcNH8fRFRImTTV8nN6L4zPFjrqUAGb2qDDQ==@kvack.org
X-Gm-Message-State: AOJu0YwT1+++bXBSVnbEz0HoPP7p+5hiuqgXZfPLNPd86f09ngudYxnf
	9upWDRZV0gnr1Nab1qnSlJkXE24dJxfjYYha8P5lSOWFNM0hpQczQ/0E2X3PaDtZuQgCEhV0MM8
	0OAjr+w==
X-Received: from dlbcy1.prod.google.com ([2002:a05:7022:b81:b0:123:3358:ca1c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:f00a:b0:124:a4cf:ce90
 with SMTP id a92af1059eb24-1278693cf97mr1461760c88.1.1772089577435; Wed, 25
 Feb 2026 23:06:17 -0800 (PST)
Date: Wed, 25 Feb 2026 23:06:08 -0800
In-Reply-To: <20260226070609.3072570-1-surenb@google.com>
Mime-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260226070609.3072570-3-surenb@google.com>
Subject: [PATCH v3 2/3] mm: replace vma_start_write() with vma_start_write_killable()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C6F7C8000A
X-Stat-Signature: zbb3ic1r5t9uxfmfw5zuashy5r93wiam
X-HE-Tag: 1772089578-144665
X-HE-Meta: U2FsdGVkX18EXgESP8ikYqem7ZSPZMPI9bVkYPtEY8JWpWzyocbsBpOVJItNxotoJZGJSMIs6wuxj+b6Of0whhqEkCOrNWoq7P7Jk7NY0BU2Uup4t8hz7HcnV+ghlImQR+uzET+avIPfIT/8EPz2c/zcWHBT7IdQ6g7/iDao1Y8VGo/Ib9eKdCBc1MYSVuO+HoaHfOigtmkuD2O8Z6KYUoS+0tfbvq+siUvYyB1UdbSB7jERHUA4BK+cuvxNG9zlbR2Fw4GhP6Ksb3eIPB/jreBLBiX0RMC2f5ecw/vBzPhmmCw+i+zDJLawHYKyKqTlQltauJXc2Tzr2M8TYmIE9Vpc4TLI8LVVnVtvy//1IOVVJtMcSxOGcWiCYgxBqeu2ELHRkevBySigzJcRdvpClGem12yYEyKS8v11SCDes184VYeo8kdacqscalV2HkGenaiX/5jhXBH1WxjnQs0OCz06UA1seaazPy1DseHXbANpgbpxeU4gbnLBIY6M16FXJPK4coL1+ax7gWiya+kv3r887eJ7ZX/PTPnxQA6VSUtWpFK/xpC1CRwfoO7QDT5fJyH9xzjaVgKt5Sh3dWN92f9R/evBJiizJR56V+0wmsrc6YlOAJbBTtQsYEZUFY5Z0GnkhapEamyiphHnzoBWgCeayVohZSLzUk2Dvu3VT3pyuO1LSVkel+t53uRoSDw8Fhw1gooldJrxZblbnfSgCSjx6ffbQf3L8IVpn2F7wYGjoF59HK+FAC8LdQco5IDu8CI7vmpCboTUKXGSyLZebo3eLiDY6k4xTRr95Bh3U9/7+K4pPbKEx5MgW1hA6E0dbg7A9wjApgv9R8phihOypq7GvwGdsPWvkCb7rTZEEaq3BawRab2NuSMhiFn8hpCdcQz3YA3h+ZWXhVtcQq6h6zWjuQPI8RuiTNOAUOHHlaYdHs6+a77it8iW+e9KFqekwXbP0s9n8RtlcbDY75t
 PAK0nep7
 bIoh0SGgEiipGxMvG69/VG0r9zhDYiLAsewds1ksxtwa5e/8m4A6jVa2FG5mmmdr8cjLw/UXFXWeOunOKS3Wny5q81LHpDtgbYlkFMiFyLAWBc5T8qap84NWaOJ5QO3tLYiZuE1clzrmPUeX9OgTHe2d2RoJVh/FGVgNBqooMoQfOn+xe+MbM0+EaL5pb4U2qiGQzdsj2gzfxGan+sm1vKVvq02CoRojpGXnTRSb3inz4UwRt6ff1sUhDJZ6FShFzrjmxYK+rRKTXcx7oI6AaURo8Qv/UBVSwo8hcLR6ywgtZKfPof3+EGe3F7lLCyn0AQjcN2o3GfQkN6zbekQmCgyjiZLW9uoreUuMSZfQ9Cocn4EEB0Zhca+obBzybJrDg70bU7bls6u+yPZcPPZhiDYPV4FAFZOXnNInRmDqYmGFdtNAPs6GeWuYjlGHLKyphIk8kswN6CRElr00QxM4gul9pFW4pfVfDxpxMyl1TmFpbDIZBZb+QFcc/Hj/PA+KY1t/K2+9AI0Y5b82vedey4bt5t6FUKbrdzHVmKDIKO9PkkNyFQ0YcTjTrXAOJPmRyBZoRfzMOLGRf+UPoI7zx4ynooUMjEaLvXVgOVB/T13k4/HOoTpA3eBmqbtEtAhsrQ0alBg8bOEs2cGmAE/WwWlok4S0kjMVw9eM1KhrpzKD2xKUWgC2C0t+3sLU5w0z78bf7gkTthELcXYQVwTPsNEte7ccTgL41cvJ3b4zSMAOA4qZ8y9AVMdQG25uN/AB+hVI4yPSf7RGdt0ZXJDWYF+l//eZeFzH/iRYtdtnLk48/sZ0r7jjhMxDL5XI38Ar3Wqg5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have vma_start_write_killable() we can replace most of the
vma_start_write() calls with it, improving reaction time to the kill
signal.

There are several places which are left untouched by this patch:

1. free_pgtables() because function should free page tables even if a
fatal signal is pending.

2. process_vma_walk_lock(), which requires changes in its callers and
will be handled in the next patch.

3. userfaultd code, where some paths calling vma_start_write() can
handle EINTR and some can't without a deeper code refactoring.

4. mpol_rebind_mm() which is used by cpusset controller for migrations
and operates on a remote mm. Incomplete operations here would result
in an inconsistent cgroup state.

5. vm_flags_{set|mod|clear} require refactoring that involves moving
vma_start_write() out of these functions and replacing it with
vma_assert_write_locked(), then callers of these functions should
lock the vma themselves using vma_start_write_killable() whenever
possible.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc
---
 arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
 mm/khugepaged.c                    |  5 +-
 mm/madvise.c                       |  4 +-
 mm/memory.c                        |  2 +
 mm/mempolicy.c                     |  8 ++-
 mm/mlock.c                         | 21 +++++--
 mm/mprotect.c                      |  4 +-
 mm/mremap.c                        |  4 +-
 mm/vma.c                           | 93 +++++++++++++++++++++---------
 mm/vma_exec.c                      |  6 +-
 10 files changed, 109 insertions(+), 43 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 5fbb95d90e99..0a28b48a46b8 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
 			ret = H_STATE;
 			break;
 		}
-		vma_start_write(vma);
+		if (vma_start_write_killable(vma)) {
+			ret = H_STATE;
+			break;
+		}
 		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
 		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1dd3cfca610d..6c92e31ee5fb 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1141,7 +1141,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		result = SCAN_FAIL;
+		goto out_up_write;
+	}
 	result = check_pmd_still_valid(mm, address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
diff --git a/mm/madvise.c b/mm/madvise.c
index c0370d9b4e23..ccdaea6b3b15 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -173,7 +173,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	madv_behavior->vma = vma;
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vm_flags_reset(vma, new_flags);
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..691062154cf5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -379,6 +379,8 @@ void free_pgd_range(struct mmu_gather *tlb,
  * page tables that should be removed.  This can differ from the vma mappings on
  * some archs that may have mappings that need to be removed outside the vmas.
  * Note that the prev->vm_end and next->vm_start are often used.
+ * We don't use vma_start_write_killable() because page tables should be freed
+ * even if the task is being killed.
  *
  * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
  * unrelated data to the mm_struct being torn down.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0e5175f1c767..90939f5bde02 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1784,7 +1784,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	mmap_write_lock(mm);
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
 	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
 		/*
@@ -1801,13 +1802,16 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 			err = -EOPNOTSUPP;
 			break;
 		}
+		if (vma_start_write_killable(vma)) {
+			err = -EINTR;
+			break;
+		}
 		new = mpol_dup(old);
 		if (IS_ERR(new)) {
 			err = PTR_ERR(new);
 			break;
 		}
 
-		vma_start_write(vma);
 		new->home_node = home_node;
 		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
diff --git a/mm/mlock.c b/mm/mlock.c
index 2f699c3497a5..c562c77c3ee0 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -420,7 +420,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
  * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
  * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
  */
-static void mlock_vma_pages_range(struct vm_area_struct *vma,
+static int mlock_vma_pages_range(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end, vm_flags_t newflags)
 {
 	static const struct mm_walk_ops mlock_walk_ops = {
@@ -441,7 +441,9 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	 */
 	if (newflags & VM_LOCKED)
 		newflags |= VM_IO;
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vm_flags_reset_once(vma, newflags);
 
 	lru_add_drain();
@@ -452,6 +454,7 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		newflags &= ~VM_IO;
 		vm_flags_reset_once(vma, newflags);
 	}
+	return 0;
 }
 
 /*
@@ -501,10 +504,12 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 */
 	if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
 		/* No work to do, and mlocking twice would be wrong */
-		vma_start_write(vma);
+		ret = vma_start_write_killable(vma);
+		if (ret)
+			goto out;
 		vm_flags_reset(vma, newflags);
 	} else {
-		mlock_vma_pages_range(vma, start, end, newflags);
+		ret = mlock_vma_pages_range(vma, start, end, newflags);
 	}
 out:
 	*prev = vma;
@@ -733,9 +738,13 @@ static int apply_mlockall_flags(int flags)
 
 		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
 				    newflags);
-		/* Ignore errors, but prev needs fixing up. */
-		if (error)
+		/* Ignore errors except EINTR, but prev needs fixing up. */
+		if (error) {
+			if (error == -EINTR)
+				return error;
+
 			prev = vma;
+		}
 		cond_resched();
 	}
 out:
diff --git a/mm/mprotect.c b/mm/mprotect.c
index c0571445bef7..49dbb7156936 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -765,7 +765,9 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * vm_flags and vm_page_prot are protected by the mmap_lock
 	 * held in write mode.
 	 */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error < 0)
+		goto fail;
 	vm_flags_reset_once(vma, newflags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
diff --git a/mm/mremap.c b/mm/mremap.c
index 2be876a70cc0..aef1e5f373c7 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1286,7 +1286,9 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
 		return -ENOMEM;
 
 	/* We don't want racing faults. */
-	vma_start_write(vrm->vma);
+	err = vma_start_write_killable(vrm->vma);
+	if (err)
+		return err;
 
 	/* Perform copy step. */
 	err = copy_vma_and_data(vrm, &new_vma);
diff --git a/mm/vma.c b/mm/vma.c
index bb4d0326fecb..9f2664f1d078 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -530,6 +530,13 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (err)
 		goto out_free_vmi;
 
+	err = vma_start_write_killable(vma);
+	if (err)
+		goto out_free_mpol;
+	err = vma_start_write_killable(new);
+	if (err)
+		goto out_free_mpol;
+
 	err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
 	if (err)
 		goto out_free_mpol;
@@ -540,9 +547,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_start_write(vma);
-	vma_start_write(new);
-
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
@@ -895,16 +899,22 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	}
 
 	/* No matter what happens, we will be adjusting middle. */
-	vma_start_write(middle);
+	err = vma_start_write_killable(middle);
+	if (err)
+		goto abort;
 
 	if (merge_right) {
-		vma_start_write(next);
+		err = vma_start_write_killable(next);
+		if (err)
+			goto abort;
 		vmg->target = next;
 		sticky_flags |= (next->vm_flags & VM_STICKY);
 	}
 
 	if (merge_left) {
-		vma_start_write(prev);
+		err = vma_start_write_killable(prev);
+		if (err)
+			goto abort;
 		vmg->target = prev;
 		sticky_flags |= (prev->vm_flags & VM_STICKY);
 	}
@@ -1155,10 +1165,12 @@ int vma_expand(struct vma_merge_struct *vmg)
 	struct vm_area_struct *next = vmg->next;
 	bool remove_next = false;
 	vm_flags_t sticky_flags;
-	int ret = 0;
+	int ret;
 
 	mmap_assert_write_locked(vmg->mm);
-	vma_start_write(target);
+	ret = vma_start_write_killable(target);
+	if (ret)
+		return ret;
 
 	if (next && target != next && vmg->end == next->vm_end)
 		remove_next = true;
@@ -1187,6 +1199,9 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
 	if (remove_next) {
+		ret = vma_start_write_killable(next);
+		if (ret)
+			return ret;
 		ret = dup_anon_vma(target, next, &anon_dup);
 		if (ret)
 			return ret;
@@ -1197,10 +1212,8 @@ int vma_expand(struct vma_merge_struct *vmg)
 			return ret;
 	}
 
-	if (remove_next) {
-		vma_start_write(next);
+	if (remove_next)
 		vmg->__remove_next = true;
-	}
 	if (commit_merge(vmg))
 		goto nomem;
 
@@ -1233,6 +1246,7 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff)
 {
 	struct vma_prepare vp;
+	int err;
 
 	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
 
@@ -1244,7 +1258,11 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (vma_iter_prealloc(vmi, NULL))
 		return -ENOMEM;
 
-	vma_start_write(vma);
+	err = vma_start_write_killable(vma);
+	if (err) {
+		vma_iter_free(vmi);
+		return err;
+	}
 
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
@@ -1434,7 +1452,9 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 			if (error)
 				goto end_split_failed;
 		}
-		vma_start_write(next);
+		error = vma_start_write_killable(next);
+		if (error)
+			goto munmap_gather_failed;
 		mas_set(mas_detach, vms->vma_count++);
 		error = mas_store_gfp(mas_detach, next, GFP_KERNEL);
 		if (error)
@@ -1828,12 +1848,17 @@ static void vma_link_file(struct vm_area_struct *vma, bool hold_rmap_lock)
 static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	VMA_ITERATOR(vmi, mm, 0);
+	int err;
 
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
-	vma_start_write(vma);
+	err = vma_start_write_killable(vma);
+	if (err) {
+		vma_iter_free(&vmi);
+		return err;
+	}
 	vma_iter_store_new(&vmi, vma);
 	vma_link_file(vma, /* hold_rmap_lock= */false);
 	mm->map_count++;
@@ -2215,9 +2240,8 @@ int mm_take_all_locks(struct mm_struct *mm)
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (signal_pending(current) || vma_start_write_killable(vma))
 			goto out_unlock;
-		vma_start_write(vma);
 	}
 
 	vma_iter_init(&vmi, mm, 0);
@@ -2522,6 +2546,11 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 	if (!vma)
 		return -ENOMEM;
 
+	/* Lock the VMA since it is modified after insertion into VMA tree */
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free_vma;
+
 	vma_iter_config(vmi, map->addr, map->end);
 	vma_set_range(vma, map->addr, map->end, map->pgoff);
 	vm_flags_init(vma, map->vm_flags);
@@ -2552,8 +2581,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
 #endif
 
-	/* Lock the VMA since it is modified after insertion into VMA tree */
-	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
 	map->mm->map_count++;
 	vma_link_file(vma, map->hold_file_rmap_lock);
@@ -2864,6 +2891,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		 unsigned long addr, unsigned long len, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
+	int err = -ENOMEM;
 
 	/*
 	 * Check against address space limits by the changed size
@@ -2908,7 +2936,10 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
 	vm_flags_init(vma, vm_flags);
 	vma->vm_page_prot = vm_get_page_prot(vm_flags);
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		err = -EINTR;
+		goto mas_store_fail;
+	}
 	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
 		goto mas_store_fail;
 
@@ -2928,7 +2959,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vm_area_free(vma);
 unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
-	return -ENOMEM;
+	return err;
 }
 
 /**
@@ -3089,7 +3120,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next;
 	unsigned long gap_addr;
-	int error = 0;
+	int error;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
 	if (!(vma->vm_flags & VM_GROWSUP))
@@ -3126,12 +3157,14 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto free;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3160,6 +3193,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
+free:
 	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
@@ -3174,7 +3208,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *prev;
-	int error = 0;
+	int error;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
 	if (!(vma->vm_flags & VM_GROWSDOWN))
@@ -3205,12 +3239,14 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto free;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3240,6 +3276,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
+free:
 	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 8134e1afca68..a4addc2a8480 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -40,6 +40,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
+	int err;
 
 	BUG_ON(new_start > new_end);
 
@@ -55,8 +56,9 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	 * cover the whole range: [new_start, old_end)
 	 */
 	vmg.target = vma;
-	if (vma_expand(&vmg))
-		return -ENOMEM;
+	err = vma_expand(&vmg);
+	if (err)
+		return err;
 
 	/*
 	 * move the page tables downwards, on failure we rely on
-- 
2.53.0.414.gf7e9f6c205-goog


