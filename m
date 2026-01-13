Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8742CD2D0FC
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 23:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E698B6B0088; Tue, 13 Jan 2026 18:13:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18E46B0089; Tue, 13 Jan 2026 18:13:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE176B008A; Tue, 13 Jan 2026 18:13:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAB496B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:13:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2DB7B13A6FE
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:13:28 +0000 (UTC)
X-FDA: 84328494096.16.DDC5D7F
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3BB6F20008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:13:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=ggUe5AZi;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf13.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768346006; a=rsa-sha256;
	cv=none;
	b=kFLsIqMpTaKliBf4HJDBJAVQx1g6KHnD7s8VOwOcBOC8WxDdMBSz3Rc8x+oV24tBXjeUHf
	THN40zwjiReEOc9MDAWngunfOb5QCq1bghcy5dOCiMhipRO3tZLKsiDM4E6zLby+G8GLbn
	75lFIHRYAK4Gb9fxw3p+wsIM0kfs7nY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=ggUe5AZi;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf13.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768346006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6b8lhji3oxV30DYJl9hk8PPRW00E8IBcoZn7eC/2TZ0=;
	b=y/c4/BShQQstcebchZs0rYbsdQELBwEcSUN39wn9byeB2WiY+JdTOuF21rEjFANGhqdRQ2
	yGyu+5Rq6aDG5XRrJxm8hxdUWvzw6UtRFgUMAzkeztsVf6qcwAxCmBtEgkuwDVQe1o1t4p
	RKTz+UU/cGZKxiOlt1LpJCwqtpcqX3U=
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DJdo4X3597538;
	Tue, 13 Jan 2026 15:13:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=6b8lhji3oxV30DYJl9hk8PPRW00E8IBcoZn7eC/2TZ0=; b=ggUe5AZiRPYJ
	M5Ht6Qu+EbaTJTqAcfGlNPDca8SGxU6MU7GhWm6lm6ZewM9R9nnjfnX5xZP5WOoa
	jUGkKFNIEghdQuCPqhFZdH5mlPP/AWFbU6Zl6ImP2U3xsqpXotxbrGj93ke/Bqsq
	lx5BJ6EXIPFE2tRKAt5eMwz4fZLsjuAGjugTsKC0E17iGNsGNSP5ZJy6TWvZqHpZ
	CuihkxRZUjjC6vLbbdyM8RMNdmT8vC1gqxp2zbCSzoM0nJxk4wNefdtkdVH0GWVt
	jt//M7N/POX8bCqn0BvU/eGc9OjOqWgTPOOQh2rcIiubinbgeFHQZ+ASUwftJQaY
	I6qeLCODHA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bnqktmu4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 13 Jan 2026 15:13:13 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Tue, 13 Jan 2026 23:13:11 +0000
From: Chris Mason <clm@meta.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam
 R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Masami
 Hiramatsu" <mhiramat@kernel.org>,
        Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v4 5/9] mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
Date: Tue, 13 Jan 2026 15:12:55 -0800
Message-ID: <20260113231257.3002271-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <5d41b24e7bc622cda0af92b6d558d7f4c0d1bc8c.1763460113.git.lorenzo.stoakes@oracle.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::150d]
X-Authority-Analysis: v=2.4 cv=M89A6iws c=1 sm=1 tr=0 ts=6966d189 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=K3mAnt_iSIqV1N-OikAA:9
X-Proofpoint-GUID: 5-CcFQBuNngsaUgw3TgiRUAET30XzMDq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE4OCBTYWx0ZWRfX2DhGmdnpVK4A
 LH9faNP4/xk97+1ec61zl/gKesEZTMzKwF6k//6ncpB1RaeYymPjCSpxJ2jEETu4T6gnYwJtU54
 dCwogLU/Q5/xmR5fK6UN4t2MiJawyueXAkZxe2JhOIpCHtoLoChUAEp1Q978J5aUsRTT54fXXCb
 t//mqC+Wss6Uei+7zmlvdgyGai3YYItrHWylZL6bWh93e1NzYhgcrC8OwtP0uc4YaVy0xk0E/ew
 5lMnpZ5m1uEStBT0eIYFluWR8uKtLQGQZEljmswk8De8/R0v817ts8rGwdem4EtuzHqnXZpGUZt
 hJ2a+EgsGXYZ9brFHP5PkXFK9nJ55WexMz96w3yMLDjEJuyuVLlFzxoi3+ZP2CLDcdGo2YG543E
 vGDTJ5RNMtJMQcwkxZzJAqV3L09aYdLn+a2xisbuVVTHDsD2f7m1SCWF9PeLUo6Ka6XaKaNnEG/
 nKjXIdXrS1R7qgsJg0Q==
X-Proofpoint-ORIG-GUID: 5-CcFQBuNngsaUgw3TgiRUAET30XzMDq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Rspamd-Queue-Id: 3BB6F20008
X-Rspamd-Server: rspam06
X-Stat-Signature: 547w3cjcinjsbtegryteqbrux6rqoznc
X-Rspam-User: 
X-HE-Tag: 1768346005-825174
X-HE-Meta: U2FsdGVkX19sPN2lU47USfZkAjOO0u+2YYRb8ZQjq9IfIycCCjEC/c6Rs2LzFmLCzkdXb8Sc6awjdppXcZSdfkFIgDIaCrgr17K8Rns2C+f7UVezVcYqfL4nB1hsn1YS0yAwmTtXvksuRFJnVlfdTrF0pz7W7M5Qe37wbSYcvt8q9Io/rWWWLvamhOGMSmCyIvdIjnHz39YPh5JwXjtA47iNP0uoDX0/XC3yz4PvD6HQrMt1ihG+X06IgRPBQ69e8ytnWrCBwCUFkT87Mox6m93c9uCBHBWPcHqiWQiAjSwEX2fktai4iyO3d8hRnaHzbGMza2i6be5WTMj2RxzyXMH7JMa5TjB+bRtJpPF17wulHUAcrtSfmV/iyKgwH19qgKQVeZOFuXhI3/xrN4QQfkH0DGNGH9vGIjO5Jm09mak6mQvn6b9bQr6MVa1qYTsHuv3P8J0RJuz6aEds7p4+veZmspc2mG/QrW/LDNw2eGr19p1oSfWnInid7DY4unSzg+NjZrBPGEKmJCTIvapGTI/rsr5sBgXFLb+ovuwVIn+i1vriQ/zWnuOc10qEzK/qy92WCUfHtGlvzzVSyqiJQvjnzHOKYfz7TsMVn8qIdpTl9pnT2eT5T4/pdX9lxfxhy74jUB/QNtn3Hyoo50No8xjigwrM0PtvaKggsMDemDGFfvk8tdbPzH8EZtVxSgB7pllzqBJQjvrN8bIHZk1AWWJGZ7ONTRdmmvn4Vm6q5foVOovzlRjTYtFoHxg929HJlR6wEM/EJjiY9O9QHq9Y++YnoAcGeLeDLsmtHRZSlmJcjjVHaOgyEnkBAfKNMA4OMjrhHT+XeK+gHtixRwAPEeBrr99oiW/ILq1UZ/YshNURPvRO0D38q/ApAvp4U/L3q61EFb2z5DQTW53nORppgnIvXuYIi3W2oI7lIYL45SHMfoTq40rOhk3WKAiCSWuJ8PrP18WiEId03hf69HS
 PDbHopI+
 86dIhwqz+PkBTZ+eiIxX1d+A4lo/Hfek7mXxKRPAp5rHwDfaPk2Blf+4rqZC+fo6AgPzPthsvk/qQTkl544Tvb1expX9FDlrFJQnhMktF5Jl0KHfqGC6xLUHyRPqnZo3EzdkkJJ5LVqGknJ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 10:17:47 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Gather all the VMA flags whose presence implies that page tables must be
> copied on fork into a single bitmap - VM_COPY_ON_FORK - and use this
> rather than specifying individual flags in vma_needs_copy().
> 
> We also add VM_MAYBE_GUARD to this list, as it being set on a VMA implies
> that there may be metadata contained in the page tables (that is - guard
> markers) which would will not and cannot be propagated upon fork.
> 
> This was already being done manually previously in vma_needs_copy(), but
> this makes it very explicit, alongside VM_PFNMAP, VM_MIXEDMAP and
> VM_UFFD_WP all of which imply the same.
> 
> Note that VM_STICKY flags ought generally to be marked VM_COPY_ON_FORK too
> - because equally a flag being VM_STICKY indicates that the VMA contains
> metadat that is not propagated by being faulted in - i.e.  that the VMA
> metadata does not fully describe the VMA alone, and thus we must propagate
> whatever metadata there is on a fork.
> 
> However, for maximum flexibility, we do not make this necessarily the case
> here.
> 

Hi Lorenzo, one more from the review automation:

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fea113d1d723c..af2904aeb1631 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -555,6 +555,32 @@ extern unsigned int kobjsize(const void *objp);
>  */
> #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
>
> +/*
> + * Flags which should result in page tables being copied on fork. These are
> + * flags which indicate that the VMA maps page tables which cannot be
> + * reconsistuted upon page fault, so necessitate page table copying upon
> + *
> + * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
> + *                           reasonably reconstructed on page fault.
> + *
> + *              VM_UFFD_WP - Encodes metadata about an installed uffd
> + *                           write protect handler, which cannot be
> + *                           reconstructed on page fault.
> + *
> + *                           We always copy pgtables when dst_vma has uffd-wp
                                                           ^^^^^^^
The comment says "dst_vma" but the new code in vma_needs_copy() checks
src_vma->vm_flags. Is this intentional?

The old code checked userfaultfd_wp(dst_vma), which tests whether the
child VMA has VM_UFFD_WP set. After dup_userfaultfd() clears VM_UFFD_WP
from the child when !UFFD_FEATURE_EVENT_FORK, the old code would skip
page table copying since the child no longer needs uffd-wp protection.

The new code checks src_vma->vm_flags & VM_COPY_ON_FORK, which includes
VM_UFFD_WP. Since the parent VMA still has VM_UFFD_WP set, this will now
force page table copying even when the child has had VM_UFFD_WP cleared.

For file-backed VMAs (e.g., shmem) with uffd-wp but !UFFD_FEATURE_EVENT_FORK,
this appears to cause unnecessary page table copying where the old code
would have allowed the child to fault pages in fresh.

The call chain is:

    dup_mmap()
      -> vm_area_dup(mpnt)                  // child gets same flags
      -> dup_userfaultfd(tmp, &uf)          // may clear VM_UFFD_WP from child
      -> copy_page_range(tmp, mpnt)
           -> vma_needs_copy(dst_vma=tmp, src_vma=mpnt)

> + *                           enabled even if it's file-backed
> + *                           (e.g. shmem). Because when uffd-wp is enabled,
> + *                           pgtable contains uffd-wp protection information,
> + *                           that's something we can't retrieve from page cache,
> + *                           and skip copying will lose those info.
> + *
> + *          VM_MAYBE_GUARD - Could contain page guard region markers which
> + *                           by design are a property of the page tables
> + *                           only and thus cannot be reconstructed on page
> + *                           fault.
> + */
> +#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)

[ ... ]

> diff --git a/mm/memory.c b/mm/memory.c
> index d1728d0538d64..27bc457b32c2e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1463,25 +1463,15 @@ copy_p4d_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
> static bool
> vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
> {
> +	if (src_vma->vm_flags & VM_COPY_ON_FORK)
        ^^^^^^^^
Was the change from checking dst_vma to src_vma for VM_UFFD_WP intentional?

The old code was:

    if (userfaultfd_wp(dst_vma))
        return true;

which expanded to:

    if (dst_vma->vm_flags & VM_UFFD_WP)
        return true;


