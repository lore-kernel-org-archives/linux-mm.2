Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6735E8B362
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 20:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7481E6B0005; Tue,  3 Feb 2026 15:56:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E1E6B0088; Tue,  3 Feb 2026 15:56:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2EE6B0089; Tue,  3 Feb 2026 15:56:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45E026B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 15:56:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F29D16055D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 20:56:17 +0000 (UTC)
X-FDA: 84404353194.26.12C5650
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id C252B4000B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 20:56:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N3TcZ5xZ;
	spf=pass (imf12.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770152175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwRl5rPitk/eF4i9o9ZxWYkLMwqq6COPXHVuVOqJ7X0=;
	b=trOmMXv7y8eVu/kKgGYK/uVJk/86BJEa03mlm4ydY+GxgGa/4NLg5ZpP2UAvaROu6Wourn
	E/pYUi9nI+si2t55SNSxsuNsiBFnWzPg9rjgoMVy9SRLcczG3FsKFkUV3gRJnjA+XsQjhU
	L8R5DYOzw4ahanLBFlT4/Ne5FOMzMrg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N3TcZ5xZ;
	spf=pass (imf12.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770152175; a=rsa-sha256;
	cv=none;
	b=10YFdVyC/ERgvesu8//r0P4FIEiyOzurqNXONxUyvCREA8qvTK6n3ULVSDlDNfXebR3v4K
	i3C/ZoQaByxADMXxZrxgvkMHv3VyO2f2LvEyjN/JKoGagPAMJwmQFKvTXz8JIujZaI7pST
	ih9P0v5PWs7xwW0F3HUhDUZ6INio8jA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770152174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OwRl5rPitk/eF4i9o9ZxWYkLMwqq6COPXHVuVOqJ7X0=;
	b=N3TcZ5xZw0mJjbpbxKP8+iHArSzuS2NqjEqMRSqzi1OmYM+tsI+HnXTo73RJvUD8I9KWBO
	jLBoWxW4kg87QhePn/WS93CZ9kpxFi5FdS8+2j0g7Q8e2YYEHphCqoX5+STxKLzbMBDt2e
	TCk8qqdo4D7+DBSP4+LU0Ail0+BZpW4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-I2lu5y6yMXuEv32kgIW1AA-1; Tue, 03 Feb 2026 15:56:11 -0500
X-MC-Unique: I2lu5y6yMXuEv32kgIW1AA-1
X-Mimecast-MFC-AGG-ID: I2lu5y6yMXuEv32kgIW1AA_1770152170
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5014c472ad5so5186921cf.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 12:56:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770152170; x=1770756970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OwRl5rPitk/eF4i9o9ZxWYkLMwqq6COPXHVuVOqJ7X0=;
        b=cHxbJLf+TVPI1Vt3cbr7TtHn5rv2B4poTM1mZg8mrvtgSniqvsgcCTR9K3uSv7DC62
         iMBpyEUq8fY78TiQuO6R38ksp/VyzCFd+SVXhes6DpE2w0pT1DrFXB6yyuubw1KcT2Ka
         DwANKMgEQQB5wA0ckjhelE3ZunTIbksqWnIxZIZDWNCXLHthBJqszEP0s+kmpOdY0yvE
         kAtCq0PD7bvEAZKfjiQCFZ8iflNe6JDarzpQqDYE6cVTu8qOYhY8Q9W5wpvB/tMVc/tK
         ii0XGYDfMTpPnv26B+o7kNl/lBGoCEr/TLShGg82Rxa9uOgVIDAM5c0Xm5cKbVpIHwrO
         eGwA==
X-Gm-Message-State: AOJu0YzNF450AtSah/QEpan94kgXJvf1hqqGDU8SGqqNZdCoeECHsQG4
	32dayq/HyTvL1Og35NBCMX9NH5BAnDGkoeP+h75HRM5IxpBG4XTuBSb+vCvC/whpUjzYlsMRjwz
	qzmMWc5Fo4EsxSCUyozVsPIx9PcrxvRHETLhtjxQAyV0tH5pD/BHE
X-Gm-Gg: AZuq6aKxoqkrtT0qDMjChPZlEAksacTUyWYGATGuQtbHqeS9YxAEzccMjvYpb8JUbvV
	Iky15MuCzswGP1G1sL1ai4XpcB1/FZ7fe7GWxFbjjx8FoZA0oUSRBc6nuK7Z0M8ASxi2dOR6/RM
	sHDGVH5gBlnOrynUePy5P53gYDxGpx7Pg4pWFHzoyjQamej2Nyqnvd/5DoDVdLbJ0AJhGuIP2rH
	JxtwnY+5MphO6rdLkfi8ke5b3Su8Yh3nolxY0S5LtJD/+Cfg4oGetKuOMHKy27lLN8oujz3+cxz
	EXcnOF9HDZNe+QkEyDjvCrfP7H3yGdD1+efBGr7fR3ugtJKb7o9OAFZGxQwI3hvnPI9vPHP4bod
	9V2U=
X-Received: by 2002:a05:622a:1207:b0:500:f02d:1c55 with SMTP id d75a77b69052e-5061c1b7f43mr9598711cf.57.1770152170299;
        Tue, 03 Feb 2026 12:56:10 -0800 (PST)
X-Received: by 2002:a05:622a:1207:b0:500:f02d:1c55 with SMTP id d75a77b69052e-5061c1b7f43mr9598341cf.57.1770152169738;
        Tue, 03 Feb 2026 12:56:09 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ca2fd41335sm47631285a.38.2026.02.03.12.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 12:56:09 -0800 (PST)
Date: Tue, 3 Feb 2026 15:56:06 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 00/17] mm, kvm: allow uffd suppot in guest_memfd
Message-ID: <aYJg5lT9MG0BQFkG@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eGMipHZQzlp6_sbGmngKbsEaR3hUf8NAGKQturdwE0M_1770152170
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: 8n1yobs34x5n5fnspzz4b5aoigmaxjgf
X-Rspam-User: 
X-Rspamd-Queue-Id: C252B4000B
X-HE-Tag: 1770152174-214595
X-HE-Meta: U2FsdGVkX19MWLXBzWBqk7Z0ZqClthAMoX1rIBKsurrHzJ+1Lb4MnYhqaEJRPxSG2wgW74E8mIxcBnu7ObPH1zoyo+vuSGg08ZeK7OBb9w+rBR6VvE355UmCwJqqajRHm+Hg3U75++BU1DXWPRtcl2aPJD8KiQzrcELqThTnaeBU1kdtRiISLlK61t1k3yiq2KDByl031KtepMIXi7NdVEKr+e5C2RGaNo8kdmpYlhuJTh+d9K7No5quzxmroGU42UWj24BykZykcH/Md0K5uGsyfq8sA62Ri0q7AnSEOyvyJNsPNEvZwEGqyFOt0vX7n0pxMk0iCF8hCAOXF8A/m/enApvDcYQQ8uyL1y1wY+4yPNWsNVVB1xcVOejXwizMXFVEH4WmF/zeMVqp34d7QcBkwLPlhzyOwzq19992eCeQRY0Q07KgArX9E7jeVZstTVym+85dr+z3uKoWYXOX4s6psTdmvbGRl8N01/wWDNEpC0MZUNOkNxuzlVFIHXlD37unBjp8Z7CIy8rm2fDK6hmo1Jr6ge2GEKGnO+dn5C8rbDHXUaUksWtahSGTvtLjLQ5r/9/r0Bzte2hhawkbr3SecM/NJsXMAS8YrN+IXWLuHSjVliz5KSTiCDzadkse36ANYpCUs6R4r/w5k7swatSi0kJwOB5Ruomiw8vYwHt+8HScBTIZ0LULOqxAjhMBNkScN1FT9KbWsTLZjHKOyQLSgBlEqAv4+foeuRe1tdIruAHtBgtOt2LOH0TMOKo1Qt0AR+hJ8EDt5H+wcmZFILOlVWMeKQr9ifss46p6ePsYqDX7G0F51FuW/edBQFQt2+in2VS5CW+6IALfLwyhCshD1eyYcbED/8jTZmWlGUUN4lSznZvrOQTeHTb/iXuEmbx1LOeNWU4o82pKOeQ1MJa+fC1fkqNX/y/cdt9iYsYzziVIs+nLwNHzqmmwHsy2OEejZmlbwYBCkPIOAT0
 DPtChEMc
 mQHB6p5aDp7uaaDG184ju0EUmsHQYQP3qCTlX5PzlgsZPfKdydnrLRwz6+IE0PlrUIrMJy8ZaaeT1dsdiBPZ4HLbNzCK5a/Zw8B3DnM1YSq7Yydm2fDTaGSbCVAqs4uv8x37HSqS5+AuR713a+KtmjP6Fd2ySZSW5t934bZuF1IKT1VztmqGyZBl8jq7g1t9fc2yUr1MkNM0JQyS9I1y4Jw+K0zbiYBzKBXLGMv+3hB7W2EVuh4iuMZWwzGIcCKzN9CmpA0KvWd/3L8QxiSIh4dbi9QNnAI2w11aTESQ5lda+VVoXZddXcwLDHRmx4kc3SPz8xREwCVvHTuwl2KjMfTvuEVxAp4FJXajfiBeMSJ+MZtBiqIiubHkqJB1Hbus25r+h0Hf1IyYRi5HZP5viHKtrCD5dKyrsyz+ewLDrhS3clOYy7yNvU/UG5rZcKCHgf5MIRum5X6QfrMtlje3mh7nJu5X/uKxQKy7T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 09:29:19PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> These patches enable support for userfaultfd in guest_memfd.
> They are quite different from the latest posting [1] so I'm restarting the
> versioning. As there was a lot of tension around the topic, this is an RFC
> to get some feedback and see how we can move forward.
> 
> As the ground work I refactored userfaultfd handling of PTE-based memory types
> (anonymous and shmem) and converted them to use vm_uffd_ops for allocating a
> folio or getting an existing folio from the page cache. shmem also implements
> callbacks that add a folio to the page cache after the data passed in
> UFFDIO_COPY was copied and remove the folio from the page cache if page table
> update fails.
> 
> In order for guest_memfd to notify userspace about page faults, there are new
> VM_FAULT_UFFD_MINOR and VM_FAULT_UFFD_MISSING that a ->fault() handler can
> return to inform the page fault handler that it needs to call
> handle_userfault() to complete the fault.
> 
> Nikita helped to plumb these new goodies into guest_memfd and provided basic
> tests to verify that guest_memfd works with userfaultfd.
> 
> I deliberately left hugetlb out, at least for the most part.
> hugetlb handles acquisition of VMA and more importantly establishing of parent
> page table entry differently than PTE-based memory types. This is a different
> abstraction level than what vm_uffd_ops provides and people objected to
> exposing such low level APIs as a part of VMA operations.
> 
> Also, to enable uffd in guest_memfd refactoring of hugetlb is not needed and I
> prefer to delay it until the dust settles after the changes in this set.
> 
> [1] https://lore.kernel.org/all/20251130111812.699259-1-rppt@kernel.org
> 
> Mike Rapoport (Microsoft) (12):
>   userfaultfd: introduce mfill_copy_folio_locked() helper
>   userfaultfd: introduce struct mfill_state
>   userfaultfd: introduce mfill_get_pmd() helper.
>   userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
>   userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
>   userfaultfd: move vma_can_userfault out of line
>   userfaultfd: introduce vm_uffd_ops
>   userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
>   userfaultfd: introduce vm_uffd_ops->alloc_folio()
>   shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
>   userfaultfd: mfill_atomic() remove retry logic
>   mm: introduce VM_FAULT_UFFD_MINOR fault reason
> 
> Nikita Kalyazin (5):
>   mm: introduce VM_FAULT_UFFD_MISSING fault reason
>   KVM: guest_memfd: implement userfaultfd minor mode
>   KVM: guest_memfd: implement userfaultfd missing mode
>   KVM: selftests: test userfaultfd minor for guest_memfd
>   KVM: selftests: test userfaultfd missing for guest_memfd
> 
>  include/linux/mm.h                            |   5 +
>  include/linux/mm_types.h                      |  15 +-
>  include/linux/shmem_fs.h                      |  14 -
>  include/linux/userfaultfd_k.h                 |  74 +-
>  mm/hugetlb.c                                  |  21 +
>  mm/memory.c                                   |   8 +-
>  mm/shmem.c                                    | 188 +++--
>  mm/userfaultfd.c                              | 671 ++++++++++--------
>  .../testing/selftests/kvm/guest_memfd_test.c  | 191 +++++
>  virt/kvm/guest_memfd.c                        | 134 +++-
>  10 files changed, 871 insertions(+), 450 deletions(-)

Mike,

The idea looks good to me, thanks for this work!  Your process on
UFFDIO_COPY over anon/shmem is nice to me.

If you remember, I used to raise a concern on introducing two new fault
retvals only for userfaultfd:

https://lore.kernel.org/all/aShb8J18BaRrsA-u@x1.local/

IMHO they're not only unnecessarily leaking userfaultfd information into
fault core definitions, but also cause code duplications.  I still think we
should avoid them.

This time, I've attached a smoke tested patch removing both of them.

It's pretty small and it runs all fine with all old/new userfaultfd tests
(including gmem ones). Feel free to have a look at the end.

I understand you want to avoid adding mnore complexity to this series, if
you want I can also prepare such a patch after this series landed to remove
the two retvals.  I'd still would like to know how you think about it,
though, let me know if you have any comments.

Note that it may indeed need some perf tests to make sure there's zero
overhead after this change.  Currently there's still some trivial overheads
(e.g. unnecessary folio locks), but IIUC we can even avoid that.

Thanks,

===8<===
From 5379d084494b17281f3e5365104a7edbdbe53759 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Tue, 3 Feb 2026 15:07:58 -0500
Subject: [PATCH] mm/userfaultfd: Remove two userfaultfd fault retvals

They're not needed when with vm_uffd_ops.  We can remove both of them.
Actually, another side benefit is drivers do not need to process
userfaultfd missing / minor faults anymore in the main fault handler.

This patch will make get_folio_noalloc() required for either MISSING or
MINOR fault, but that's not a problem, as it should be lightweight and the
current only outside-mm user (gmem) will support both anyway.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm_types.h      | 15 +-----------
 include/linux/userfaultfd_k.h |  2 +-
 mm/memory.c                   | 45 +++++++++++++++++++++++++++++------
 mm/shmem.c                    | 12 ----------
 virt/kvm/guest_memfd.c        | 20 ----------------
 5 files changed, 40 insertions(+), 54 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a6d32470a78a3..3cc8ae7228860 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1612,10 +1612,6 @@ typedef __bitwise unsigned int vm_fault_t;
  *				fsync() to complete (for synchronous page faults
  *				in DAX)
  * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
- * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
- *				handle_userfault(VM_UFFD_MINOR) to complete
- * @VM_FAULT_UFFD_MISSING:	->fault did not modify page tables and needs
- *				handle_userfault(VM_UFFD_MISSING) to complete
  * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
  *
  */
@@ -1633,13 +1629,6 @@ enum vm_fault_reason {
 	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
 	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
 	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
-#ifdef CONFIG_USERFAULTFD
-	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
-	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x010000,
-#else
-	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x000000,
-	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x000000,
-#endif
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
@@ -1664,9 +1653,7 @@ enum vm_fault_reason {
 	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
 	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
 	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
-	{ VM_FAULT_COMPLETED,           "COMPLETED" },	\
-	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }, \
-	{ VM_FAULT_UFFD_MISSING,	"UFFD_MISSING" }
+	{ VM_FAULT_COMPLETED,           "COMPLETED" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 75d5b09f2560c..5923e32de53b5 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -85,7 +85,7 @@ struct vm_uffd_ops {
 	/* Checks if a VMA can support userfaultfd */
 	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
 	/*
-	 * Called to resolve UFFDIO_CONTINUE request.
+	 * Required by any uffd driver for either MISSING or MINOR fault.
 	 * Should return the folio found at pgoff in the VMA's pagecache if it
 	 * exists or ERR_PTR otherwise.
 	 * The returned folio is locked and with reference held.
diff --git a/mm/memory.c b/mm/memory.c
index 456344938c72b..098febb761acc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5338,6 +5338,33 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	return VM_FAULT_OOM;
 }
 
+static vm_fault_t fault_process_userfaultfd(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct inode *inode = file_inode(vma->vm_file);
+	/*
+	 * NOTE: we could double check this hook present when
+	 * UFFDIO_REGISTER on MISSING or MINOR for a file driver.
+	 */
+	struct folio *folio =
+	    vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pgoff);
+
+	if (!IS_ERR_OR_NULL(folio)) {
+		/*
+		 * TODO: provide a flag for get_folio_noalloc() to avoid
+		 * locking (or even the extra reference?)
+		 */
+		folio_unlock(folio);
+		folio_put(folio);
+		if (userfaultfd_minor(vma))
+			return handle_userfault(vmf, VM_UFFD_MINOR);
+	} else {
+		return handle_userfault(vmf, VM_UFFD_MISSING);
+	}
+
+	return 0;
+}
+
 /*
  * The mmap_lock must have been held on entry, and may have been
  * released depending on flags and vma->vm_ops->fault() return value.
@@ -5370,16 +5397,20 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 			return VM_FAULT_OOM;
 	}
 
+	/*
+	 * If this is an userfaultfd trap, process it in advance before
+	 * triggering the genuine fault handler.
+	 */
+	if (userfaultfd_missing(vma) || userfaultfd_minor(vma)) {
+		ret = fault_process_userfaultfd(vmf);
+		if (ret)
+			return ret;
+	}
+
 	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
-			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR |
-			    VM_FAULT_UFFD_MISSING))) {
-		if (ret & VM_FAULT_UFFD_MINOR)
-			return handle_userfault(vmf, VM_UFFD_MINOR);
-		if (ret & VM_FAULT_UFFD_MISSING)
-			return handle_userfault(vmf, VM_UFFD_MISSING);
+			    VM_FAULT_DONE_COW)))
 		return ret;
-	}
 
 	folio = page_folio(vmf->page);
 	if (unlikely(PageHWPoison(vmf->page))) {
diff --git a/mm/shmem.c b/mm/shmem.c
index eafd7986fc2ec..5286f28b3e443 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2484,13 +2484,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	fault_mm = vma ? vma->vm_mm : NULL;
 
 	folio = filemap_get_entry(inode->i_mapping, index);
-	if (folio && vma && userfaultfd_minor(vma)) {
-		if (!xa_is_value(folio))
-			folio_put(folio);
-		*fault_type = VM_FAULT_UFFD_MINOR;
-		return 0;
-	}
-
 	if (xa_is_value(folio)) {
 		error = shmem_swapin_folio(inode, index, &folio,
 					   sgp, gfp, vma, fault_type);
@@ -2535,11 +2528,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	 * Fast cache lookup and swap lookup did not find it: allocate.
 	 */
 
-	if (vma && userfaultfd_missing(vma)) {
-		*fault_type = VM_FAULT_UFFD_MISSING;
-		return 0;
-	}
-
 	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
 	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
 	if (orders > 0) {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 14cca057fc0ec..bd0de685f42f8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -421,26 +421,6 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	folio = __filemap_get_folio(inode->i_mapping, vmf->pgoff,
 				    FGP_LOCK | FGP_ACCESSED, 0);
 
-	if (userfaultfd_armed(vmf->vma)) {
-		/*
-		 * If userfaultfd is registered in minor mode and a folio
-		 * exists, return VM_FAULT_UFFD_MINOR to trigger the
-		 * userfaultfd handler.
-		 */
-		if (userfaultfd_minor(vmf->vma) && !IS_ERR_OR_NULL(folio)) {
-			ret = VM_FAULT_UFFD_MINOR;
-			goto out_folio;
-		}
-
-		/*
-		 * Check if userfaultfd is registered in missing mode. If so,
-		 * check if a folio exists in the page cache. If not, return
-		 * VM_FAULT_UFFD_MISSING to trigger the userfaultfd handler.
-		 */
-		if (userfaultfd_missing(vmf->vma) && IS_ERR_OR_NULL(folio))
-			return VM_FAULT_UFFD_MISSING;
-	}
-
 	/* folio not in the pagecache, try to allocate */
 	if (IS_ERR(folio))
 		folio = __kvm_gmem_folio_alloc(inode, vmf->pgoff);
-- 
2.50.1


-- 
Peter Xu


