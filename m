Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF24606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=IfbPwZw/
Received: by kanga.kvack.org (Postfix)
	id 5CEF76B05BC; Wed, 18 Nov 2026 12:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580146B05BD; Wed, 18 Nov 2026 12:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4981A6B05BE; Wed, 18 Nov 2026 12:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 168DA6B05BC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:01:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 420DEC0800
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:01:03 +0000 (UTC)
X-FDA: 85448854806.09.56B39B0
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2D191C0015
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:01:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b="IfbPwZw/";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cq2yLROKOWFClHJlMFODj2cE+UUP94CiAArBBY1dyMQ=;
	b=gE4iIF8atc9muPdyqWN3f6qXlU7KRXX7WE9MGmx2DC2b+wNEz71jOkWepLxK278Iuaa4sN
	Ufi1IxsMJkKAgVuqr/gR+CMr1dBIRlRuk4ddctJODy1D/RpdJT0NfeOGkIMLSo06ajxNzR
	nH1JZdh4w8MnAPpmkHNC4/20JXgmBZw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b="IfbPwZw/";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021261;
	b=pwHenWAQ1CDfa01ovdwnwWLbN+J02p0kbqJAMoztO0HwimRghtYu15vS19APcCAzUh3Mjm
	PTCss+uir4jmrAokwWH8fP1xgBK/kIpFdKHEVjNF58MKl5cPRAz/oUsY8hqPW2EGyPXZBQ
	w2kcNzDiY29TVYxUEtcWBNsZHkfrDqQ=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-55c5b6584ceso9391131cf.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021260; x=1795626060; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cq2yLROKOWFClHJlMFODj2cE+UUP94CiAArBBY1dyMQ=;
        b=IfbPwZw/eoK0ZFdXXWpYGCrW6FSNVsgLxj/K6SbX2I1PYvJcShuG0YE/3vyKz4svrE
         gahmhjLkDMhJJylko5mEHBDRHJzEG0o6C7Ab5vYSC3yG8IiGJsU5khODr8kYVQDv1uxD
         roAT1Prb+pVSbG4mnBaPwEYQgy3J9ogLSzHFdU37AxlVRxp13HQr2T2gF/Tgwd5XWb7B
         tEk3kGGbKJza+gj6xzqGTOZ3dC5L1ihDWsYLYfmdgTtJ6Ve23qrTvZVUiuOoGcW3tHR9
         Eo+/bBoRajqm2M+idJDOO4vsaLo2fdPtOKhYktn3fhelmEUUk9kq6ORMjO1OD8E2wmpk
         GrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021260; x=1795626060;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cq2yLROKOWFClHJlMFODj2cE+UUP94CiAArBBY1dyMQ=;
        b=z6X6iOlsTxrHUHPl5JT4iNAQosqPnrBoA+er7kADFBbdacOjIou4FwUVUvHA/OyVkD
         OxQKRKTP6UafZj9lxW1rGeOghtkF/ZA7mVHOgsbF01QsT6V3uxtfVNwMiF2Ud69z9MuW
         D7f1nNXipo88WUb2dy/B2ycOs0RtT7RwaUdl8QfIhh60mN4u7KOlo/ck+11wn2GpixCw
         /lMKrnHvmQxgo6TXWJuNWteQ6PxRDkEJ031RY+lQmbu2EoWiMLdx9+ci13Kbwi7tnTwk
         nLRY7njr/mBW8YyIs2ZofgpCnjcMWG6G0GazRycu6XoR5k2Bb2l/K/AVyxgDvnONJM+x
         8VWw==
X-Forwarded-Encrypted: i=1; AL+hErEMH77MOHar6p8++BPjjiGWc6414byclZc2fU302nlMrmg0aQdTolo5LoAzCvYm/S3rz83XbFXwtA==@kvack.org
X-Gm-Message-State: APuU4Z8tJW3KXLYhjuXnQ1gGZJzPcp2EbZqKdVskU9Dzh790Ef3O+sm0
	y42hl7higlPrWUp5njuKT4WymgSr8V2WMfHx7Io94FxU7gubOXyhfKsMcIoJMlb8wM/8eywUx9G
	RF4hS5+E=
X-Gm-Gg: AYBFou3PgzZccoUD53IO+Unib43/Jf8dfsLOgo5Rpn/YEnYoncWWjju4D/7Y3l7kNRX
	7eSp8rkZ+KPlhdJo4jOmMhXyLfSJb8RS7pqcgXqfqrTY0Q7yP3Ldb9dzHIm1gl9efyCQmVzHL74
	SUzHNW1AQOuFQK8+z+HO/5Bt9KCYuTcWG/wS8uGpi+bXplmr2K0vH9R08k86SJwrsc4TReIkx39
	B2goz03upbcglU3jiXyOJ6vcXWknzEdpCqJcVMXHm7CWSA+9+2AWY+oAHgvYAnvgLLKjcC0zRkg
	ZTQidXxniHQVuSRRAdm7r1tS0/ihb1B6C5+26IBPUrvaTao2HIJ7OJfS76p7Z9VcHJNPNXzdlMw
	nZ9bLFE2M9GAffd2XnvDPqDAMXbMY5bteL1KGnvAJKzNhv7KEGc77Tq71kILZmn3PHbIqLp0UY+
	qS+4+4MM00UZzLR0ydcSCOhGll9J8CP7ckP5kuh8hS+A/+WNs4DXZxKJIyiiURNPgcPc0Byu/AY
	OZGUeGrzaInp0K8FOoJb312CDmR07xklnTBo0Nfi/qta8Kx9/LPeRSNySsw7YFFlSTluuiSBr7w
	IIg9iTTjdH3p1Gga4zMltKe6uyR+JRfgtlsJQsnVsG9DHg==
X-Received: by 2002:a05:622a:400a:b0:536:6383:577f with SMTP id d75a77b69052e-55d5a6b306emr50193141cf.64.1795021259940;
        Wed, 18 Nov 2026 09:00:59 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.248])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d66b24cb1sm3975971cf.7.2026.11.18.09.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:00:59 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:00:38 +0000
Subject: [PATCH RFC 6/7] mm/hugetlb: fail if the VMA lock can't be
 allocated
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-b4-vma-open-fail-v1-6-c8b0209f2700@toxicpanda.com>
References: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
In-Reply-To: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021242; l=3679;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=iBF3/6KMJ/SiW/Rd9KJURbxnVipCLR+twmclMcsIVbE=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHzTPeY/fpmHj3hqqWX/bJ3YvvxxLxGceRUMDyb5+XNXNk4IGIBwsBhexU391OLFk/iTP6duxFR
 Z7cCIxlR2lAw=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Queue-Id: 2D191C0015
X-Stat-Signature: zhc3uoxd4nkixy5xdis4tgjeck1o69ic
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795021260-889077
X-HE-Meta: U2FsdGVkX1//xTIyo/FCcY1c83vUKMsNnA5atnTplg03uOmhzvHYVgpg4YGGULKOt0sSTx8yj1s0wJfZFYSJtA82d0a5iiytu4bLVtoGcweFrIupTIXoV8pNsrOT+E03WjLrXMIlOnFeBA2K25Zirt/mxFCoEvfJadnIPfVzpev+LRzUyXWZ78DoRry4mhb4ryTMWGUoa0DZqbWKLfwLTs++ZsCDfhJUvz1kCoUw124o09w2UOmBibYaNUbOuo5V5FrNHcsG5yvcgoyhlKKXpm1VoyDSONjuyZ2jXALhUMmC3djZtKKrDLGMvShfAyVH6aEtijx2O25Ybk4LU/jpEFevigVk0fFSCyLtPWqeknJ6ShtUYtCH9ikNTet+b3QvEFgFOs/ux/kDhIkA8kbJ/hVHMyTa3akjUqJwKutj0zMKCAZyovwUBOrGCudXUAMU5r+boFtPVe2EPUewDxCEjtUecIm+Wux6neKjX5/WVB08CV5zOJZE01bkjW8LLeUyyIjQ3IYv084nrid8KU9eKNVfP3uemaBDjOmIDBIFhfo0KS7XVBFBKbISu/FEM/Gev2GtlZ3UVSBdQhAo2olDkGMHHpRe5pcpFpAVFbuvVygU2l/kdB9Z2Q63J4BqOxCVrzitNyyu9y+MApp2cJc5zvJ19i/plIe0QdKIl0vy7Qwzp3WcqJW+BkCZKsidMGJ+qJ/AcLtFjDhs5AqAT413aeS+Ruas6NQFkBXZDnJqb1lUBOo3cUb3/RTWGJownQZhVxYQs1AfUR7KF7ZGdiR7XLrVGs97TebSXthbOtwsZ44ehG4Go+0g3ykHKfxx05NqCYLqOGmochWaO+pkuS15P44NhrMEm9PjEDI0pg4PNDLapiN1bHcd/5r8Sax5ORjSuJetD0grFrK8GN7A5F3aUGM1Nk90OJ3h3MeMFhFvYTXdb6W7dUyXrARmtT0VefSGiK1j+bkcPzTRkBqLEfZ
 UL0JNskC
 nfHAIYbjUI1/HJZKJN0gRydjZFThAely39rO8XOuHMbrlpSX1PDCEQ5lhBm25fBAVcWChoh6l9XXj1ELC9khtoxnwBtKzjc/pJxuBq6398IxDl7iExa4q4rh/50fmIb18R4aPOsMMXNNtUxXbVENiKeatDpYE9Osj5BX63xJPP+ki6c4PrMV1kpVoziDkYk8x4ZQ6PPld9Shk+ZetydQWq+u+KEAsWHNgZb2IDOObwG0FQRJVZDM2oyNjqbDM1J3otSp/FxrhPV6053j7KdUPF/il8qkfl+iHLnf4KGkcRn9dPU6TjKSGhR9jpO2NQfmPw3KcWC054pdxccc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If the VMA lock of a shared mapping can't be allocated, the VMA carries on
without it.  Faults then race with truncation, which can leave pages past
i_size until the file is removed.

Now that vm_ops->open() can fail, return -ENOMEM instead, from there and
from hugetlb_reserve_pages().  This is a small unaccounted allocation, so
in practice it only fails for a task that is already being killed.  A
reservation map reference taken earlier in hugetlb_vm_op_open() doesn't
need undoing, only private mappings have one and only shared mappings have
a lock.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/hugetlb.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c94d491b338b..e05e6db3ff31 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -130,7 +130,7 @@ struct mutex *hugetlb_fault_mutex_table __ro_after_init;
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 static unsigned int allowed_mems_nr(struct hstate *h);
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
-static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
+static int hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 static int __huge_pmd_unshare(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
@@ -440,38 +440,27 @@ static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
 	}
 }
 
-static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
+static int hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
 {
 	struct hugetlb_vma_lock *vma_lock;
 
 	/* Only establish in (flags) sharable vmas */
 	if (!vma || !(vma->vm_flags & VM_MAYSHARE))
-		return;
+		return 0;
 
 	/* Should never get here with non-NULL vm_private_data */
 	if (vma->vm_private_data)
-		return;
+		return 0;
 
 	vma_lock = kmalloc_obj(*vma_lock);
-	if (!vma_lock) {
-		/*
-		 * If we can not allocate structure, then vma can not
-		 * participate in pmd sharing.  This is only a possible
-		 * performance enhancement and memory saving issue.
-		 * However, the lock is also used to synchronize page
-		 * faults with truncation.  If the lock is not present,
-		 * unlikely races could leave pages in a file past i_size
-		 * until the file is removed.  Warn in the unlikely case of
-		 * allocation failure.
-		 */
-		pr_warn_once("unable to allocate vma specific lock\n");
-		return;
-	}
+	if (!vma_lock)
+		return -ENOMEM;
 
 	kref_init(&vma_lock->refs);
 	init_rwsem(&vma_lock->rw_sema);
 	vma_lock->vma = vma;
 	vma->vm_private_data = vma_lock;
+	return 0;
 }
 
 /* Helper that removes a struct file_region from the resv_map cache and returns
@@ -4784,12 +4773,11 @@ static int hugetlb_vm_op_open(struct vm_area_struct *vma)
 		if (vma_lock) {
 			if (vma_lock->vma != vma) {
 				vma->vm_private_data = NULL;
-				hugetlb_vma_lock_alloc(vma);
-			} else {
-				pr_warn("vma_lock already exists in %s.\n", __func__);
+				return hugetlb_vma_lock_alloc(vma);
 			}
+			pr_warn("vma_lock already exists in %s.\n", __func__);
 		} else {
-			hugetlb_vma_lock_alloc(vma);
+			return hugetlb_vma_lock_alloc(vma);
 		}
 	}
 
@@ -6821,7 +6809,9 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * vma specific semaphore used for pmd sharing and fault/truncation
 	 * synchronization
 	 */
-	hugetlb_vma_lock_alloc(vma);
+	err = hugetlb_vma_lock_alloc(vma);
+	if (err)
+		return err;
 
 	/*
 	 * Only apply hugepage reservation if asked. At fault time, an

-- 
2.55.0


