Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB004C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 16:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAEA6B0095; Fri, 31 Jul 2026 12:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2626B0096; Fri, 31 Jul 2026 12:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B76F6B0099; Fri, 31 Jul 2026 12:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65E8B6B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 12:05:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69AB4120483
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:05:28 +0000 (UTC)
X-FDA: 85049546736.19.8183226
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id AB7781A000C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:05:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TjulweAB;
	spf=pass (imf19.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785513925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ryHo/Pk85RB1et4y6uESf2yi2i/ESrF3Kar7ZIFnpUk=;
	b=Pp6GeHGIwcVc4a2rVvrAnov598nRpgA8BlIttWBLzrRmpUArz3DYOPf933PEYWrZ50hA5c
	LN5EECHz2oW36IyUT0ov4Ary3S3Fts3QEWuEyRLm+snHACT2pdVWv9xz8hinUKyBoH+jxP
	rxYZpxLJntP9k34lIcbKaZrCYcmQXPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785513926;
	b=ncewGY8d4lgRntkiwIg84/NpjHP7jE3jmQiUe/pNwxig4e8j+wRVcMRqeLjA34NRNNtMPw
	zpEjx7RG/DaaLPszVco3m1YdKuNfLc7wDH814qbfneQNc1zwld2GAQk7efv09fOWMls8yN
	7e1Psq8ElTNdr71Kqdwlg1OGMJtWdIM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TjulweAB;
	spf=pass (imf19.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785513925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ryHo/Pk85RB1et4y6uESf2yi2i/ESrF3Kar7ZIFnpUk=;
	b=TjulweABoKDR4TCiLBYuuiHGXCsGlbyuQSCoj0Do7od2KD8Qk+6yHES8FDw2Aj1REq99Jw
	VjUpe1e4Fla/szeQz7n5zB8p9i9RzQYkqoo1a2+Rms5DmSmJ40WMrSwF/UtoijD+Iln6Af
	6fdbNRcVCjGjhkzqvmPlT+bra3Agijw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-Tcp7d96LMy-sZHniQWAYqg-1; Fri, 31 Jul 2026 12:05:23 -0400
X-MC-Unique: Tcp7d96LMy-sZHniQWAYqg-1
X-Mimecast-MFC-AGG-ID: Tcp7d96LMy-sZHniQWAYqg_1785513922
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c1f548718d0so151433066b.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785513922; x=1786118722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ryHo/Pk85RB1et4y6uESf2yi2i/ESrF3Kar7ZIFnpUk=;
        b=sFnO0PGpdIqVDqvP1XiZIbCjqDS6vbFNZ2CVwjKnh1DjSmAYHxe1B42IbYAcW6It70
         kitmePjxdTisq0sihZ0BKlnyirVgTxVNuGlSObtasDafp8Ow5ULZN0k6lR8k7memh9uV
         XTOEzikGqJSbgfaAQ/9K+HB84tUvtYSVE7tz63fRUVzfYpK9mfMnWH6+Ln+VekISBPX8
         52dLJpjpAhnza9USTp8nZgtzfWA1u6FdnGqkVHwO8DLwevk8XlopGJDl2WXjdlQTSaKE
         okYha3b0deazbRA/WNpD2W8vio1Z5PEfUcATpzsQEgjjL/6EXLbeD1nwjetmPoniAR0H
         f7pQ==
X-Forwarded-Encrypted: i=1; AHgh+RrMI2yq+LdBzDv+gmTeTf5xYm5EJL55Ezon0O4MGsRuGfOO9Na/KE6WUPRkVpk4c7HeSq5hfRKqcg==@kvack.org
X-Gm-Message-State: AOJu0YzISBY9JCUcaEjeTePMuy+x6VNGVbJO20e8Lz4oVvv4tjIC9K64
	k19tZ2U/G24YAaZMboc/cEsETj/h25iKvl7n8QD9fbCyznLHyq05q5rA6hCyb9PGE7EmtHaJ6vZ
	lmpMmxA1Ar4CfoMbDTzkrtfJPJsNEHUp54Ja7WAWWxj+o5z8/FDuJ
X-Gm-Gg: AR+sD12UJfAv0vA1TFtBX1omAji6sO60UNBacrDFsQGkg297XpZKg1auT+ONHq9SPh3
	7OD8RSe3048WWzt7t8byTz9mPguCMrHnaLa0Hg+6QbolPm0F3Y6L6xZdfkABI1RWZ9tOSq6gR2n
	bIKsX7Eyg7XTSG5fQhOrfZlzDMCCYBi5B7jEbnbtHKupalEWyS1LZMQPj8ut3NN575iUCJRfksq
	VYlrc1mLMn8NgWZOsEN9brEjBpqyDUQhDK3lNH9CqMjqJd2mOw9tsbVFVOjV7s+fVolb/D69voO
	+Of08euhfn+n+iavSKkb1hvbATfBEYMJcIURB2FS2W6gJjwC5ZTC0bgLEZ3NhGVzRS0rZFGW5d/
	L1ehrk8fyTqTpXX6TyJ3UZL3Wlkq3hiT1HAIzbT6R74TzuanZEQiD4RhsI/c6x5ehGVJufJ/sXW
	VwdM0=
X-Received: by 2002:a17:906:ee81:b0:c15:9709:fb9b with SMTP id a640c23a62f3a-c1fe8373675mr8933766b.44.1785513921877;
        Fri, 31 Jul 2026 09:05:21 -0700 (PDT)
X-Received: by 2002:a17:906:ee81:b0:c15:9709:fb9b with SMTP id a640c23a62f3a-c1fe8373675mr8929866b.44.1785513921309;
        Fri, 31 Jul 2026 09:05:21 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd44542d2sm222203766b.35.2026.07.31.09.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:05:17 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Alex Williamson <alex@shazbot.org>,
	Fei Li <fei1.li@intel.com>,
	David Hildenbrand <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-s390@vger.kernel.org,
	linux-mm@kvack.org,
	Sergio Lopez <slp@redhat.com>
Subject: [PATCH] mm: pull writability check to follow_pfnmap_start()
Date: Fri, 31 Jul 2026 18:05:14 +0200
Message-ID: <20260731160514.1101989-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lCH9R8NpgbrJGk_qI6Tw7gpCwDq89hFiVVdUKxPc6uU_1785513922
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AB7781A000C
X-Stat-Signature: 7ozahbzcns169as1d3cx4rocyremakoq
X-Rspam-User: 
X-HE-Tag: 1785513925-866739
X-HE-Meta: U2FsdGVkX19eDXj218ogNh0+YkHZHovlZG5NEXw0LJTmqbjfvHwQ62xsU8L7QLjx5m0A0qDjBhWekHVwiTC+AfngQBepora/v7IieiazREfD53oEW/xswRgLHeuKWDZukbhMrQcPOyV26BVdZWhC73sI5WM/+fFdUTiTx6c0Wp3Edv+n+9rLaQ+dcDIsqRLHBjgs3oyR65sPev/bbQQiZNIb2kCDBNpi3v/GQsCuPDrccB1RBLp8tWz8+bsTBlvKWHYh3QtWATqoAUKI7/rJcrNxPB3lXszwvEc11yiavCxNacnK3uVYdUeuVLf7uNG2azpKlNqrD5O5fzhBrYT45z+4VzU3Efo2cuIPJvCCFZiWahXNAvZRYdojVLseiGHAMQoZLF0KSXAdG+TQ1yOLKaH5GX2CAH+4tHvUeDExDOdrjptiQsR4BpE5GFUGdByHLI1J7o1VH1m2bnaL4JOW97irXsR5iWgDdowkbXJ0dL2yuIBzBV5BkhEcVw1n8B8/A9lu5GKlbS3vOr9bvVYJC72QVebApUs9zNwDCrg2QCEA08GG7NS0eFnS6dRNqnXobDhpfnJ6B7yHlt7I7a8HDK7HuAvhjpyTPNPtQJOvLryqvgC95lr3ZY4nT/GvzpvZ5sg8aVZQqIwTnfBr0Q52+kaCtmdQFfdH3mv26d60P89MWv4YQKgfRb+gpuiufIq4ejiuLeNGihajjrApdy+CjJ6j0+bBqk9niGqp9wAaoniGzX/UGpdHioTYjUtBLAOF1g7irVnTh3ztU4lpaKG62aduZd7rdCtOv3wcEhrJ6MtN/VTDY1u6W6PAvVw8ywVDUg9evs6CiV6JG4dQ+4lnHaq56EWHtrKg6MBescQ7ikpvmkCuljgEcDD5UiNE2OSeAfXXH8KE9O9TKZT3yL45zg1xQD1G4hiN1ACSANSLFFjkDzNwZpI9jLHp5bzavbW52BsGlmOHLJ1a71p5T/Z
 9icCxBsR
 yjJADpjGRejwVbKKMSfpG25BuLbuSbiQ9FSMzRU6AT9g+jlGj2IKepjyp+oiI9ELmsVRR6TxVlq5P9OL+5Y2x45hUAxZNHSVLUe+Y9j+A2oAywpi6DvjdNMQwb4UM6Jf4Sbxopnw7EKEkmnrebnb1kEuRCkbT4FXqaftSVuB8oAb99Pjd5EiWbeIFPjJKSTcHmgZYaXTGnEWfcSpfp3nULM5gi34ynpRbwWnUDe26TVSbl5XfqlLwOGpMMHKlY3vUJNO1XI4PLFlCKyBDhovrkcTCj/bPJeXDeE7PfvSSTB/w/NGnDjgE/GDHfhYBS2K95UHS9V0zvz5HJfmWV5mNGb51LkUBubdFk4V294qYRX1oJ9dyzAWfBokIUxxHwIDDN1CDkZ7+0MZXvCf2TNIBZARK6JrvREonyk+vqPqb24cUZ0wLpIEFEb81yK7zmrlAhRFHnklunR5Dy98NNhOJBebWGxGHgDzboP5k+8RqNKUQQvVO6/tScuBMKIMySggf3sFGhUSRXq8o5a7xkI1IfA18PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers of follow_pfnmap_start() except s390_pci_mmio_write() are
following it, if they are doing a write, with a check that args.writable
is true; for s390_pci_mmio_write() that's a bug.  Most of them return
-EFAULT if it is not, but because follow_pfnmap_start() returned success,
they do not attempt to upgrade the page from read-only to read-write
with fixup_user_fault().

Pull the check directly into follow_pfnmap_start() through another
input parameter args.write_fault; this eliminates the need to do it in
the caller and, for callers that do use fixup_user_fault(), lets it
attempt to upgrade the page.

The change in return code to -EFAULT is okay:

- s390 is the only one to have a functional change in this respect;
  but EINVAL is only documented for "Invalid length argument", while
  "The address in mmio_addr is invalid" should already return EFAULT
  (https://www.man7.org/linux/man-pages/man2/s390_pci_mmio_read.2.html)

- for VFIO and ACRN, -EFAULT was returned already

- for KVM, -EFAULT is eaten

- for generic_access_phys() the caller is __access_remote_vm()
  which does not care about the error code.

Reported-by: Sergio Lopez <slp@redhat.com>
Link: https://lore.kernel.org/kvm/CAAiTLFU1ALsDoJoKW3d9bUvv990AozAoX=bEHmfnG54qyBAHFg@mail.gmail.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Sergio, this is half of the fix for your issue.  Please
	test both patches together if possible.

 arch/s390/pci/pci_mmio.c        |  2 ++
 drivers/vfio/vfio_iommu_type1.c | 17 +++++----
 drivers/virt/acrn/mm.c          | 10 +-----
 include/linux/mm.h              |  3 ++
 mm/memory.c                     | 62 ++++++++++++++++++++-------------
 virt/kvm/kvm_main.c             | 22 ++++++------
 6 files changed, 64 insertions(+), 52 deletions(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 51e7a28af899..526f80b8fb3b 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -180,6 +180,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 
 	args.address = mmio_addr;
 	args.vma = vma;
+	args.write_fault = true;
 	ret = follow_pfnmap_start(&args);
 	if (ret) {
 		fixup_user_fault(current->mm, mmio_addr, FAULT_FLAG_WRITE, NULL);
@@ -332,6 +333,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 
 	args.vma = vma;
 	args.address = mmio_addr;
+	args.write_fault = false;
 	ret = follow_pfnmap_start(&args);
 	if (ret) {
 		fixup_user_fault(current->mm, mmio_addr, 0, NULL);
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c8151ba54de3..9ee92820b4de 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -541,7 +541,11 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
 			    unsigned long *addr_mask, bool write_fault)
 {
-	struct follow_pfnmap_args args = { .vma = vma, .address = vaddr };
+	struct follow_pfnmap_args args = {
+		.vma = vma,
+		.address = vaddr,
+		.write_fault = write_fault
+	};
 	int ret;
 
 	ret = follow_pfnmap_start(&args);
@@ -563,15 +567,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			return ret;
 	}
 
-	if (write_fault && !args.writable) {
-		ret = -EFAULT;
-	} else {
-		*pfn = args.pfn;
-		*addr_mask = args.addr_mask;
-	}
-
+	*pfn = args.pfn;
+	*addr_mask = args.addr_mask;
 	follow_pfnmap_end(&args);
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c
index 5bca500a83e0..b057e78ef3f4 100644
--- a/drivers/virt/acrn/mm.c
+++ b/drivers/virt/acrn/mm.c
@@ -177,7 +177,6 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
 		unsigned long start_pfn, cur_pfn;
-		bool writable;
 
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
 			mmap_read_unlock(current->mm);
@@ -188,6 +187,7 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 			struct follow_pfnmap_args args = {
 				.vma = vma,
 				.address = memmap->vma_base + i * PAGE_SIZE,
+				.write_fault = !!(memmap->attr & ACRN_MEM_ACCESS_WRITE),
 			};
 
 			ret = follow_pfnmap_start(&args);
@@ -197,16 +197,8 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 			cur_pfn = args.pfn;
 			if (i == 0)
 				start_pfn = cur_pfn;
-			writable = args.writable;
 			follow_pfnmap_end(&args);
 
-			/* Disallow write access if the PTE is not writable. */
-			if (!writable &&
-			    (memmap->attr & ACRN_MEM_ACCESS_WRITE)) {
-				ret = -EFAULT;
-				break;
-			}
-
 			/* Disallow refcounted pages. */
 			if (pfn_valid(cur_pfn) &&
 			    !PageReserved(pfn_to_page(cur_pfn))) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..34c79b5fcb9b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3136,9 +3136,12 @@ struct follow_pfnmap_args {
 	 * Inputs:
 	 * @vma: Pointer to @vm_area_struct struct
 	 * @address: the virtual address to walk
+	 * @write_fault: if true, fail with -EFAULT unless the mapping is
+	 * writable
 	 */
 	struct vm_area_struct *vma;
 	unsigned long address;
+	bool write_fault;
 	/**
 	 * Internals:
 	 *
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..40997a26846f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6786,12 +6786,15 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
-				     spinlock_t *lock, pte_t *ptep,
-				     pgprot_t pgprot, unsigned long pfn_base,
-				     unsigned long addr_mask, bool writable,
-				     bool special)
+static inline int pfnmap_args_setup(struct follow_pfnmap_args *args,
+				    spinlock_t *lock, pte_t *ptep,
+				    pgprot_t pgprot, unsigned long pfn_base,
+				    unsigned long addr_mask, bool writable,
+				    bool special)
 {
+	if (!writable && args->write_fault)
+		return -EFAULT;
+
 	args->lock = lock;
 	args->ptep = ptep;
 	args->pfn = pfn_base + ((args->address & ~addr_mask) >> PAGE_SHIFT);
@@ -6799,6 +6802,7 @@ static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
 	args->pgprot = pgprot;
 	args->writable = writable;
 	args->special = special;
+	return 0;
 }
 
 static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
@@ -6820,8 +6824,9 @@ static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
  * @args: Pointer to struct @follow_pfnmap_args
  *
  * The caller needs to setup args->vma and args->address to point to the
- * virtual address as the target of such lookup.  On a successful return,
- * the results will be put into other output fields.
+ * virtual address as the target of such lookup, and optionally set
+ * args->write_fault to require a writable mapping.  On a successful
+ * return, the results will be put into other output fields.
  *
  * After the caller finished using the fields, the caller must invoke
  * another follow_pfnmap_end() to proper releases the locks and resources
@@ -6844,7 +6849,8 @@ static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
  *
  * This function must not be used to modify PTE content.
  *
- * Return: zero on success, negative otherwise.
+ * Return: zero on success, -EFAULT if @args->write_fault was set but the
+ * mapping is not writable, -EINVAL if there is no mapping at all.
  */
 int follow_pfnmap_start(struct follow_pfnmap_args *args)
 {
@@ -6857,6 +6863,7 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
 	pte_t *ptep, pte;
+	int r = -EINVAL;
 
 	pfnmap_lockdep_assert(vma);
 
@@ -6890,10 +6897,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 			spin_unlock(lock);
 			goto retry;
 		}
-		pfnmap_args_setup(args, lock, NULL, pud_pgprot(pud),
-				  pud_pfn(pud), PUD_MASK, pud_write(pud),
-				  pud_special(pud));
-		return 0;
+		r = pfnmap_args_setup(args, lock, NULL, pud_pgprot(pud),
+				      pud_pfn(pud), PUD_MASK, pud_write(pud),
+				      pud_special(pud));
+		if (r)
+			spin_unlock(lock);
+		return r;
 	}
 
 	pmdp = pmd_offset(pudp, address);
@@ -6911,10 +6920,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 			spin_unlock(lock);
 			goto retry;
 		}
-		pfnmap_args_setup(args, lock, NULL, pmd_pgprot(pmd),
-				  pmd_pfn(pmd), PMD_MASK, pmd_write(pmd),
-				  pmd_special(pmd));
-		return 0;
+		r = pfnmap_args_setup(args, lock, NULL, pmd_pgprot(pmd),
+				      pmd_pfn(pmd), PMD_MASK, pmd_write(pmd),
+				      pmd_special(pmd));
+		if (r)
+			spin_unlock(lock);
+		return r;
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, address, &lock);
@@ -6923,14 +6934,16 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	pte = ptep_get(ptep);
 	if (!pte_present(pte))
 		goto unlock;
-	pfnmap_args_setup(args, lock, ptep, pte_pgprot(pte),
-			  pte_pfn(pte), PAGE_MASK, pte_write(pte),
-			  pte_special(pte));
+	r = pfnmap_args_setup(args, lock, ptep, pte_pgprot(pte),
+			      pte_pfn(pte), PAGE_MASK, pte_write(pte),
+			      pte_special(pte));
+	if (r)
+		goto unlock;
 	return 0;
 unlock:
 	pte_unmap_unlock(ptep, lock);
 out:
-	return -EINVAL;
+	return r;
 }
 EXPORT_SYMBOL_GPL(follow_pfnmap_start);
 
@@ -6972,7 +6985,11 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
 	bool writable;
-	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
+	struct follow_pfnmap_args args = {
+		.vma = vma,
+		.address = addr,
+		.write_fault = !!(write & FOLL_WRITE)
+	};
 
 retry:
 	if (follow_pfnmap_start(&args))
@@ -6982,9 +6999,6 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	writable = args.writable;
 	follow_pfnmap_end(&args);
 
-	if ((write & FOLL_WRITE) && !writable)
-		return -EINVAL;
-
 	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
 	if (!maddr)
 		return -ENOMEM;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 45e784462ec6..0c4ff223162b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2939,8 +2939,11 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       struct kvm_follow_pfn *kfp, kvm_pfn_t *p_pfn)
 {
-	struct follow_pfnmap_args args = { .vma = vma, .address = kfp->hva };
-	bool write_fault = kfp->flags & FOLL_WRITE;
+	struct follow_pfnmap_args args = {
+		.vma = vma,
+		.address = kfp->hva,
+		.write_fault = !!(kfp->flags & FOLL_WRITE),
+	};
 	int r;
 
 	/*
@@ -2959,7 +2962,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		 */
 		bool unlocked = false;
 		r = fixup_user_fault(current->mm, kfp->hva,
-				     (write_fault ? FAULT_FLAG_WRITE : 0),
+				     (args.write_fault ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
 		if (unlocked)
 			return -EAGAIN;
@@ -2967,17 +2970,16 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			return r;
 
 		r = follow_pfnmap_start(&args);
-		if (r)
+		if (r) {
+			if (r == -EFAULT) {
+				*p_pfn = KVM_PFN_ERR_RO_FAULT;
+				return 0;
+			}
 			return r;
-	}
-
-	if (write_fault && !args.writable) {
-		*p_pfn = KVM_PFN_ERR_RO_FAULT;
-		goto out;
+		}
 	}
 
 	*p_pfn = kvm_resolve_pfn(kfp, NULL, &args, args.writable);
-out:
 	follow_pfnmap_end(&args);
 	return r;
 }
-- 
2.55.0


