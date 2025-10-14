Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED6DCCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 23:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210FC8E0154; Tue, 14 Oct 2025 19:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1AF8E0041; Tue, 14 Oct 2025 19:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A3F8E0154; Tue, 14 Oct 2025 19:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D99358E0041
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:15:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8733A478B8
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:21 +0000 (UTC)
X-FDA: 83998278042.06.D53E974
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4EE0A20009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UPSTzPAe;
	spf=pass (imf13.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760483719; a=rsa-sha256;
	cv=none;
	b=tkfpqVdlHeIcaQpKFJNfE/bMbA5/L08paXu9S84WYwgWCtIWJzhhU6B1Ro9mkoiM4GyAvH
	1zs4JqjoHF+WQEKP7ufbnAR+2EKBHPKId+JLdWex8D6NF5d8/UhXaRC4lVAQhSfk5JkQ1D
	8jdTBQVOhCS8xX3G7rBxVKChdAMQ4jo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UPSTzPAe;
	spf=pass (imf13.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760483719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HedfkyMs3B9oqDedHNEV7q9JZcOI7I215Yi2CdixyTc=;
	b=02KDO1nbHIzmLyvruJeLzEnFHfj1VQLWGR26JrxjQFMn/oBiZZovzL3JenWOp/9PVTmWkx
	R2aqYLHtQ3mT6cDzpJZRoOIG4uDbVWuGMS/a6tk088ZCD/0+r4wjQlUVLbhiRyjHcR0XUB
	L+rpxguGOJi8lZ5SzJwRt3bIFZv3fiw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760483718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HedfkyMs3B9oqDedHNEV7q9JZcOI7I215Yi2CdixyTc=;
	b=UPSTzPAeT1iIDMPzI033KKjXH1KhzxqhBsH3QQQMupr8fb+0Gpq9skPmimMeoDuQZJH3vJ
	d57Swo/5Q9c43SjZBWiF8WGNigW5qoNsyF1aKLg2MEOm4YKDZr80x5/Cc5IsHa17BzcuQf
	K7LCvTY1ljai+IKU0+X+xNPZ5fuWC3M=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-V9q6c-MlND6hDohYzUMaug-1; Tue, 14 Oct 2025 19:15:17 -0400
X-MC-Unique: V9q6c-MlND6hDohYzUMaug-1
X-Mimecast-MFC-AGG-ID: V9q6c-MlND6hDohYzUMaug_1760483717
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-88e35354330so41247685a.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760483717; x=1761088517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HedfkyMs3B9oqDedHNEV7q9JZcOI7I215Yi2CdixyTc=;
        b=PJAAds0OjfCX5MUTmcpRzoPsrzy3tOHTw1n7EbV6gynNkWv7MmITBGYE6D/GWQ6BQK
         T4mrs/if57ehxiJGdO4HD9BEu2nz+E5d8itZSVVXjvTqwj36HUlpcV1xg+/eymQBVjbJ
         XVwV8/esh6KBUoe+4+qSIDzQKfa2g66RAwy4qgpo9MS3toI+gX1sMJq04TywVCjMb6g+
         DubbWiwborHlaPbaxAZqztIIPA4JDSlYeblavS8HZqmEAxj+DwLHjZnaS6+f8kFyBBFX
         bvIehO0r6VZdAfnBEcykraujBSTJz1HijNt0Os+E3EZz0foUXCpDvf86WEN4A3MITFJp
         4NCg==
X-Forwarded-Encrypted: i=1; AJvYcCWMOV1fAcpMFUF18/kVHaxqJ5moi/paRIQnCyFN93EV14KWiUWerxjnJomAhaAAjfCNY4R7W8cb2g==@kvack.org
X-Gm-Message-State: AOJu0YwzhcEVG8C6GWfVlb8gxtgf22k8LwPUcC11fwD2QkM7CFFPQeHs
	bxdGhl39HroUJfsBVPftHgFp2XR7PasafrGjtQtEi1lmNPO6h5tqThQJQnSne+OYeVXbArZO13v
	2tPwzqHgUaoHwPASQ+DAlZ/98P3Fbl+GQpE+FAYCQHOA3oePFAPsM
X-Gm-Gg: ASbGncvOIh5VVwLlGWuEFF4OhnOu7Uv9Gn8vmlfOXQVSLBz/jneQfKe1YOKLFbNKhin
	VDsCOZPkgsJuJN6isuIGOhrZYTZzs5dSOwbekZdBGPwWoxGarqCxT8fCVDSabe0XyDxg0HNZdqL
	Yr3RIsMNvWgOky2n4EOrICnf/5akAiPCz8QRNmVxVFzFPJQ5SyxPQKgYvX2J/QX7CeiycrGuUEt
	fZqKGtrcmZO3tiI7wT3QxY6JkYV0aw6SuBYjZfAf0dvhDqgKIdgwkc9wuC5qMbRVkVl+Zz9gQHi
	zf6pKl+qvjoKlefMSJ7gAPc2il0XOg==
X-Received: by 2002:a05:620a:7012:b0:816:b56d:20ef with SMTP id af79cd13be357-8835326fa38mr3291255285a.86.1760483716687;
        Tue, 14 Oct 2025 16:15:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8trGwxOWwN9vklPIUb4DUFPDDuGTh9yrsza4jeSL14iOpRJmq9d1JUbiuCxpuX4zt03gfgQ==
X-Received: by 2002:a05:620a:7012:b0:816:b56d:20ef with SMTP id af79cd13be357-8835326fa38mr3291250085a.86.1760483716141;
        Tue, 14 Oct 2025 16:15:16 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a23693a0sm1280258685a.53.2025.10.14.16.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 16:15:15 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v4 4/4] mm: Apply vm_uffd_ops API to core mm
Date: Tue, 14 Oct 2025 19:15:01 -0400
Message-ID: <20251014231501.2301398-5-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251014231501.2301398-1-peterx@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tk6fVD3dpe3GRBhQ7_JVOP19gfcd3rXLxP9xrRGHBzI_1760483717
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: 5hqfarq61wqcfi93rpn3ufhepkdkusfj
X-Rspamd-Queue-Id: 4EE0A20009
X-Rspamd-Server: rspam09
X-HE-Tag: 1760483719-722287
X-HE-Meta: U2FsdGVkX18le7/a7nV5QwlXXVRNWBIj8UB9fjsNJs+OhsrCHzKhus2qTZ7SMZrkAYt/SL8yIKIdFo0jg02XoKrsiJ9blPQBsYfW7zxXgSm4yVtgsf8HC6oCKhfIGTICTIh+knvZ2gCFKDfETgzadsnmCr+xCYxNXDguKqFHNP9kCOzvmFFFuyaWLF3m4U5OUmToJGaydTHN73TP3ErdtYrjDb02QiTxk8WwkZMhyLPYo7PWrr8DaI+9dff7mwlI+7ma3EJBwGDskL3UILtMZduCNQHO+2v29KEFtjTMyBxcq47N2G/SebxHdKH1cm8sccy1gW7ioPVfIHwGruUcgbNHlNw62Nk6H3hjRj1NUoI+tmDSJEIUWYiQduedbEGT+wJ1URqkO7VFIZAE0mQ3FR+DwgyCdIn1/BzNOLcdw04x0HQkJOmPB4X0VMW0SCU5JZvP9M37lvKBK3LVObvaXkXVXkNdG8eDVDcwF0myEhIhyz2moyRCTcJR7f5or7F9HB8uI2F5okAMDpZdVWFWYWP+SfpyWcRzQk576X9CC5tjIJHtuPXSQg6vi3yYjmKG+ILGbAcfvZ3n5CS4cE2wsaHdwqYOIqGyV6MDUqhFot2+xs8gRoBg8MS1zUB0xaIukvLYJTGbgvMApuGWo8R/cbqb6ejk6bVmpDuVtLHf3mbxFCbT1DTh1B0RgLJEdjo4AnKAJHLTx6bC++SDLL+hnk2OijRm2G2W/U4Zbv+9iG/KNG+KSJtohb/vCGD80INdtIMg0RZNRPa93VU5y6MM0uIKrc+cqBa2CYTDVkRS+7QwhsNTb6GN8JYT0xIeKa2jgACyqGtDdoyXF98qJppGbAPKZwlxoLtY7N93DBDCGegqWAqbiXilY/B8O74gm8wCpmOIlSoUdMGQ9bw8SY4w2q9jpN3bRny7oXJseP8y/AXEwAzMr4guX8a6pefZlkK/HRNrBxmEvp7i0+nBc31
 8moevp/j
 uqgmjXTVNBghKcSvabjtd8PonLEtpnik3GtlpHaseg/1sh7NbVMqirTS7n8i5tXmqElJb5zr3SVnUut70mA2HY6pXJYT+nwxKC/B5KXZOnrkSOugqe0MTa8L3rcvGJPh+mOSNbO7UkOkl76vaHINgKMUCRpCQfO9lmxRzzsvyRtE5O2HpfefIegCaWrgrADJwsmqyWHxVVGBg3W6GfAnKBNr0UFmT1YsCC5tr+TboOTnTP9ciseXr+TMo0sHI1aRSIztMllHskXk99yn2zQUOCA6ft4YsAS473ak/3TeVbpCceoOHRkVNz4rolb5/o4HtZuLHk2IFFyIFRdDTVxsHEcwDIAFpJr+VIvreyshEl3TUrON8nKaRaEZcX98u8aaGhbbl3/1u4qi0bPf9mP//tBbZ2TD0vONZfvHOhdmw5JEAQh11r/YcFYNzZt5yQs/xB/pPgKTDPySt7qnsKncbhj4TEhtJ7NW4u4g7LNlSTVVo8ufkRMsB3Ijgkx3w2UoGpA2jYQedUkhfpUJdh31rfX68HDIGrMNTE//EMZzneeNrM14r/FoktYhmPIEh1tZU/4if1A7cYZepzcIGM+c84PQyOyD3Y6lQJsYuxevBUJU5NS6pBmynxe9hKxVMlHg95PCp9lWPAtAMwMBM9WSSx0eShA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move userfaultfd core to use new vm_uffd_ops API. After this change, file
systems that implement vm_operations_struct can start using new API for
userfaultfd operations.

When at it, moving vma_can_userfault() into mm/userfaultfd.c instead,
because it's getting too big.  It's only used in slow paths so it shouldn't
be an issue.  Move the pte marker check before wp_async, which might be
more intuitive because wp_async depends on pte markers.  That shouldn't
cause any functional change though because only one check would take effect
depending on whether pte marker was selected in config.

This will also remove quite some hard-coded checks for either shmem or
hugetlbfs.  Now all the old checks should still work but with vm_uffd_ops.

Note that anonymous memory will still need to be processed separately
because it doesn't have vm_ops at all.

Reviewed-by: James Houghton <jthoughton@google.com>
Acked-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/userfaultfd_k.h |  46 ++++---------
 mm/userfaultfd.c              | 120 +++++++++++++++++++++++++++-------
 2 files changed, 109 insertions(+), 57 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index b5b4f3f174b32..983efaecfdcb0 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -126,9 +126,14 @@ struct vm_uffd_ops {
 #define MFILL_ATOMIC_FLAG(nr) ((__force uffd_flags_t) MFILL_ATOMIC_BIT(nr))
 #define MFILL_ATOMIC_MODE_MASK ((__force uffd_flags_t) (MFILL_ATOMIC_BIT(0) - 1))
 
+static inline enum mfill_atomic_mode uffd_flags_get_mode(uffd_flags_t flags)
+{
+	return (__force enum mfill_atomic_mode)(flags & MFILL_ATOMIC_MODE_MASK);
+}
+
 static inline bool uffd_flags_mode_is(uffd_flags_t flags, enum mfill_atomic_mode expected)
 {
-	return (flags & MFILL_ATOMIC_MODE_MASK) == ((__force uffd_flags_t) expected);
+	return uffd_flags_get_mode(flags) == expected;
 }
 
 static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_atomic_mode mode)
@@ -237,41 +242,16 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
-static inline bool vma_can_userfault(struct vm_area_struct *vma,
-				     vm_flags_t vm_flags,
-				     bool wp_async)
+static inline const struct vm_uffd_ops *vma_get_uffd_ops(struct vm_area_struct *vma)
 {
-	vm_flags &= __VM_UFFD_FLAGS;
-
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
-
-	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
-	 * memory type.
-	 */
-	if (wp_async && (vm_flags == VM_UFFD_WP))
-		return true;
-
-#ifndef CONFIG_PTE_MARKER_UFFD_WP
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
-		return false;
-#endif
-
-	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
+	if (vma->vm_ops && vma->vm_ops->userfaultfd_ops)
+		return vma->vm_ops->userfaultfd_ops;
+	return NULL;
 }
 
+bool vma_can_userfault(struct vm_area_struct *vma,
+		       unsigned long vm_flags, bool wp_async);
+
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
 	struct userfaultfd_ctx *uffd_ctx = vma->vm_userfaultfd_ctx.ctx;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 00122f42718cc..b50db51e75d5b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -20,6 +20,61 @@
 #include "internal.h"
 #include "swap.h"
 
+static unsigned long uffd_get_supported_modes(struct vm_area_struct *vma)
+{
+	const struct vm_uffd_ops *uffd_ops = vma_get_uffd_ops(vma);
+	unsigned long ioctls, supported = 0;
+
+	if (!uffd_ops)
+		return 0;
+
+	ioctls = uffd_ops->supported_ioctls;
+
+	if (ioctls & (BIT(_UFFDIO_COPY) | BIT(_UFFDIO_ZEROPAGE)))
+		supported |= VM_UFFD_MISSING;
+	if (ioctls & BIT(_UFFDIO_CONTINUE))
+		supported |= VM_UFFD_MINOR;
+	if (ioctls & BIT(_UFFDIO_WRITEPROTECT))
+		supported |= VM_UFFD_WP;
+
+	return supported;
+}
+
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async)
+{
+	unsigned long supported = 0;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
+	vm_flags &= __VM_UFFD_FLAGS;
+
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then any file system (like shmem or hugetlbfs) are not
+	 * supported but only anonymous.
+	 */
+	if (!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) &&
+	    ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma)))
+		return false;
+
+	/*
+	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * memory type.
+	 */
+	if (wp_async && (vm_flags == VM_UFFD_WP))
+		return true;
+
+	if (vma_is_anonymous(vma))
+		/* Anonymous has no page cache, MINOR not supported */
+		supported = VM_UFFD_MISSING | VM_UFFD_WP;
+	else if (vma_get_uffd_ops(vma))
+		supported = uffd_get_supported_modes(vma);
+
+	return !(vm_flags & ~supported);
+}
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -382,13 +437,17 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 				     unsigned long dst_addr,
 				     uffd_flags_t flags)
 {
+	const struct vm_uffd_ops *uffd_ops = vma_get_uffd_ops(dst_vma);
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct folio *folio;
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	if (WARN_ON_ONCE(!uffd_ops || !uffd_ops->minor_get_folio))
+		return -EINVAL;
+
+	ret = uffd_ops->minor_get_folio(inode, pgoff, &folio);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
 	if (ret == -ENOENT)
 		ret = -EFAULT;
@@ -504,18 +563,6 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 	u32 hash;
 	struct address_space *mapping;
 
-	/*
-	 * There is no default zero huge page for all huge page sizes as
-	 * supported by hugetlb.  A PMD_SIZE huge pages may exist as used
-	 * by THP.  Since we can not reliably insert a zero page, this
-	 * feature is not supported.
-	 */
-	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
-		up_read(&ctx->map_changing_lock);
-		uffd_mfill_unlock(dst_vma);
-		return -EINVAL;
-	}
-
 	src_addr = src_start;
 	dst_addr = dst_start;
 	copied = 0;
@@ -694,6 +741,41 @@ static __always_inline ssize_t mfill_atomic_pte(pmd_t *dst_pmd,
 	return err;
 }
 
+static inline bool
+vma_uffd_ops_supported(struct vm_area_struct *vma, uffd_flags_t flags)
+{
+	enum mfill_atomic_mode mode = uffd_flags_get_mode(flags);
+	const struct vm_uffd_ops *uffd_ops;
+	unsigned long supported_ioctls;
+
+	if ((flags & MFILL_ATOMIC_WP) && !(vma->vm_flags & VM_UFFD_WP))
+		return false;
+
+	/* Anonymous supports everything except CONTINUE */
+	if (vma_is_anonymous(vma))
+		return mode != MFILL_ATOMIC_CONTINUE;
+
+	uffd_ops = vma_get_uffd_ops(vma);
+	if (!uffd_ops)
+		return false;
+
+	supported_ioctls = uffd_ops->supported_ioctls;
+	switch (mode) {
+	case MFILL_ATOMIC_COPY:
+		return supported_ioctls & BIT(_UFFDIO_COPY);
+	case MFILL_ATOMIC_ZEROPAGE:
+		return supported_ioctls & BIT(_UFFDIO_ZEROPAGE);
+	case MFILL_ATOMIC_CONTINUE:
+		if (!(vma->vm_flags & VM_SHARED))
+			return false;
+		return supported_ioctls & BIT(_UFFDIO_CONTINUE);
+	case MFILL_ATOMIC_POISON:
+		return supported_ioctls & BIT(_UFFDIO_POISON);
+	default:
+		return false;
+	}
+}
+
 static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 					    unsigned long dst_start,
 					    unsigned long src_start,
@@ -752,11 +834,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	    dst_vma->vm_flags & VM_SHARED))
 		goto out_unlock;
 
-	/*
-	 * validate 'mode' now that we know the dst_vma: don't allow
-	 * a wrprotect copy if the userfaultfd didn't register as WP.
-	 */
-	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
+	if (!vma_uffd_ops_supported(dst_vma, flags))
 		goto out_unlock;
 
 	/*
@@ -766,12 +844,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
 					     src_start, len, flags);
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
-		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
-		goto out_unlock;
-
 	while (src_addr < src_start + len) {
 		pmd_t dst_pmdval;
 
-- 
2.50.1


