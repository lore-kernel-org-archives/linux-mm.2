Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D357ACAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037878E000B; Fri, 26 Sep 2025 05:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23748E0001; Fri, 26 Sep 2025 05:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12358E000B; Fri, 26 Sep 2025 05:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCA4B8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:14:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C27616060A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:14:51 +0000 (UTC)
X-FDA: 83930841582.02.660DD43
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 942F9A000A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:14:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IL1CK0h0;
	spf=pass (imf25.hostedemail.com: domain of 3h1nWaAsKCOACEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3h1nWaAsKCOACEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758878089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=xzlecSBlGNy5Hb7DuTGlXytPmBFktseBO6e58xwE2NU=;
	b=B1D/AfHBeeTeFZXoGeUdUEeZhh8F7dw2wQp+f3zWA8oq2TQ9vsZW/nD7YbI1H+RL9zn+xO
	HpDfRHxn+N/3fPLgG9lgvOHbI3l+05dpgNjZ6uY6XS6PWhppphWNngRTH6lScvW8cCYMvS
	77qeW0dXJ2vOhHxZJO9itziryIGO24s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758878089; a=rsa-sha256;
	cv=none;
	b=pHCVwvCI54fmr0adicExZNmPj7JpFWIKj0OPFzuDk46sHegz5auNmwQJXmSQ+DK2QCeKNt
	/sSp9q6QqAArCl44L2zVRSkKVEW1gXa2C60AzGTqHWSpr2R6/tD+nyuLvTIsigStQKkDqo
	1m3+RzLRabhCGsHSZm/jCEu5TpGlmA0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IL1CK0h0;
	spf=pass (imf25.hostedemail.com: domain of 3h1nWaAsKCOACEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3h1nWaAsKCOACEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5509ed1854so1331710a12.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758878088; x=1759482888; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xzlecSBlGNy5Hb7DuTGlXytPmBFktseBO6e58xwE2NU=;
        b=IL1CK0h07Q+/N941kFTx0hChVnZ43wzg97trnVmmQWmATdaodf0j9gp+yA3k46Y8Mq
         /Q7RnxYEcmw5Wj7dHjwTffy8/TmpetbPTPaEkZlaB6nIDOjSKpTw9mFJBWVNRHJRV5li
         vvsfDQqpMt38K8s8xsifM1fWdwsxVw3EBUZt60be2iiJByVuPoLasINzEuveehTD7Lno
         hqvMgLJeEz+s4VBhtzSR+dXbk1g5/OoS+la9aWqZWywrF9aatDWmGWUEvsf5X+o+7gjt
         pPygHeUpcRMkerfxELmmDq1rA+K36PUx/YHdN/OEOBjA2iW2tXNhpVInZylu/Y2jjwcL
         QcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758878088; x=1759482888;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xzlecSBlGNy5Hb7DuTGlXytPmBFktseBO6e58xwE2NU=;
        b=ZlrMvgPuWx1YQPw2WM400VTr7wm+GN4nAWVBuQV4C1EBcQnkWFuWiO9wyAGVem2ufE
         MzcBw2/ooRXNv7PDoF3w6eJHOANb9JFOFH2wwqazU5AEKRpuNH3czB/NC1sOBQWBHdZn
         bgPJnEGtE+AL2pGruz00J73A7CtWfJoyjIqC8qxXURlZ54lccYKzn4d2oTpiQybYBdSc
         pmf+xX6H15HkNQ8Uy+PhFOLH9eyuEvfR9Bi8kNwPjzupJ7fWwF6CMw3mwoe1yt68ASRM
         GIOWzP1txIw2eTvHGI7HnfwH461rxtRw6BV1WTA9JWM7UaazaSdDiLK3ltyNvVeFgmTP
         /xOA==
X-Forwarded-Encrypted: i=1; AJvYcCWdcbjwfjaRCDDVLCoeKeJw/C3x9OdaNECNK2Wzsk2btO9t61XGUqtUvaWs7673VC+EEmQ9vCQmMA==@kvack.org
X-Gm-Message-State: AOJu0YwOSuKpcwd++pHSlNaOSktyMU0UJgksCwrkhpEnRZjY/4S4CTQj
	UYAcE6iDF40KyygV7VYBlYoa3zw1fnmjGW0uTrddUMTkLlYCoIhfpyRRnrfVg19ANTQAv5t8ESQ
	vi8+6KlwfA6lv4UMKYtyvAPgK3w==
X-Google-Smtp-Source: AGHT+IEx8E9cWhlfu1Vxq2AQuNomZgiEGJpm7W9AMx7sfDI2/uhsc96oawFywv4yb5EYZvdHJHPDXZqYAh60qO9vkw==
X-Received: from plxq5.prod.google.com ([2002:a17:902:dac5:b0:268:eb:3b3b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef09:b0:276:76e1:2e84 with SMTP id d9443c01a7336-27ed4a06b49mr70346315ad.3.1758878087498;
 Fri, 26 Sep 2025 02:14:47 -0700 (PDT)
Date: Fri, 26 Sep 2025 09:14:45 +0000
In-Reply-To: <aDfT35EsYP/Byf7Z@yzhao56-desk.sh.intel.com> (message from Yan
 Zhao on Thu, 29 May 2025 11:26:23 +0800)
Mime-Version: 1.0
Message-ID: <diqzcy7d60e2.fsf@google.com>
Subject: Re: [RFC PATCH v2 39/51] KVM: guest_memfd: Merge and truncate on fallocate(PUNCH_HOLE)
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 942F9A000A
X-Stat-Signature: ehgqq595y4wwm6p8ox1n384t8cpooz9s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758878089-324097
X-HE-Meta: U2FsdGVkX18H0T//n/SRvz1aEluJnCjJ8rgBJ1wzPltyJalUMrSIr6zd0IjrdAno5MH4pcH/FHLjny1jS80OHB0QqgtxIhB7IHj6qaMKJt7ujfU/J9WHS069spwT91Em4W5oxU1av+v/C5P+bMLGqfNoSFbaUkTnLd8n/OYaeeZPaGG5KJrcdRpDIZUPv4jkdrbhEjnaUD8A7wE3gNn2VP7J+wx8o6K9npyufIcjsvucManIhyW0UwaTo50gS7aM89cL0bv2t7ltTKsMxgeTigLrqlUPKdjVNkOxS8+ZtX7/yxIJG8jv2IA0kfdlh96UEDrhyEEHnm8S+L/z40ERRvoQXqjG2K4QzYLPJiApxvtWz8OO+fzL6vqjRJ7aiaB7s7m08UOLnczc4k7NsOqUCywQsbRVjFr6J5A96L1r+XCVYBpWtrwSkapRCf99rFMTXTTZHV7X1JuxjCk0IGvLFGNell5enekm0bLpA9u3fxdmQoSihz6/fVR0tvx9Bg5aqluv/ZA3pmHWHxSD1LcULMxHBksv9XhSFk/GdDYw1arOBLCpcpkcHTfC5uEuETU1ppz+hYKGEHqrZ5i4nG85uY91Xna+iDasue/K6ObP2Ignf3A5mapUxa7O2M2b326W692oTpN9DxJW1hPd4bVfTgl+o3m+wPTWWUX+Pd+lbLvIa1CFQgTmQs4YhCvuXAXPiQzCUG4/PzXgGfLMPiNCejERvUTy5Dyvn8DraJf7bgGd/BzuSUxWtIRmwjZy73O7IQhoNO67j5mB1HI6WebrS9vTqd13Y6TLr2ZXwP/WCeh2RTiS8yH/0ixjrGh+CKNpVQtBd+C1wddAhyIcHwNWuaPAoE34AbKR2AYx14IEzl2T2IBkjn2Q2+q9gswPdFodwUfJ+61FevRqQdeSz6noMuiBifALbJO/hC8q0e/6sMC7MTEbEkrikvhpYXtydUuCeVrYQifSsiR2LLo1Viu
 aD8z9Ktj
 YF5gi4gQ2NSt/dSffxRlCwtl21Ak8N1sTdJD3tgerEnYeWG0Bi1jx5yb61+wZCh32aRlxmAkXeJfIQFlhIPwkcrOeFRBaTI7fZr2ukpgSAlxDvEINL/tZuTq9YhFFOqNtmJEsC3mo/7pubNTBElM2CRfPTIRMI64ccMB4oH4B9go7h/IJkWhA+atoWi3isq5fBNlrTT12v9a3oqMNaX7d+KiFPcLq7Jq/TZGpxuKOXH5Gf3Y0LnaqRhs8kJpY3hmEzkOL8+iginBBXM4GqEvMMDlwNKAPtHdDvTQ5UjEjivqlD/UU0H/bLmbbf1xIRzwxE5BtPMjh7JwMDt7bXFyhQQr7xZ5CG94v4iB2vesPVEF+wi1MbeIHqBxqs7MDtZMR2vXrTtMuQjtEEqcKnJbkBS+BqLvVXvF3fo4oeNRrs6lvpzf8ekaXcVjBAKI3opgwfNtl1DznLtnfh5EOrgR5XguTQONg0oMuf3dKfdv1UkVDJf8l8akgtHK+SW5PvAABCWtM7mayLi0CDE9/FGsz8l338MoZJ9//RNq41oCxZ2AQ7KaeQ59wvPYj3qMlNiJUvTDJMF2hdbbNe5qoRZVu4jVpbDfRgzddPg8XYl1MzOTzMUf01iNoh5Lbv5UofsB74x5D6bFayfS/GVKaB7pDjoaJJ6DHFzjGOZwkSXhV0jVFCCgSmhW0EQaIOIqmc3TWOpUU2IQb2Cp0Cr3yRxq5MN0/hpQNgxGiY1p+p3fDaxq35DJbfUoHsSmwDkpgZgZXmO9MzKJgmOMz1zCiSFjiAz4VJcoS+R+2GlOTEZjPptxduU8NgFFYhTNXN7vb4Inq1xFkIALFmkbPolRNBmzDa7latfVTvGQGPQriRyMvqFton4uuubL8rSz6SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Wed, May 28, 2025 at 09:39:35AM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>> 
>> > On Wed, May 14, 2025 at 04:42:18PM -0700, Ackerley Tng wrote:
>> >> Merge and truncate on fallocate(PUNCH_HOLE), but if the file is being
>> >> closed, defer merging to folio_put() callback.
>> >> 
>> >> Change-Id: Iae26987756e70c83f3b121edbc0ed0bc105eec0d
>> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> >> ---
>> >>  virt/kvm/guest_memfd.c | 76 +++++++++++++++++++++++++++++++++++++-----
>> >>  1 file changed, 68 insertions(+), 8 deletions(-)
>> >> 
>> >> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> >> index cb426c1dfef8..04b1513c2998 100644
>> >> --- a/virt/kvm/guest_memfd.c
>> >> +++ b/virt/kvm/guest_memfd.c
>> >> @@ -859,6 +859,35 @@ static int kvm_gmem_restructure_folios_in_range(struct inode *inode,
>> >>  	return ret;
>> >>  }
>> >>  
>> >> +static long kvm_gmem_merge_truncate_indices(struct inode *inode, pgoff_t index,
>> >> +					   size_t nr_pages)
>> >> +{
>> >> +	struct folio *f;
>> >> +	pgoff_t unused;
>> >> +	long num_freed;
>> >> +
>> >> +	unmap_mapping_pages(inode->i_mapping, index, nr_pages, false);
>> >> +
>> >> +	if (!kvm_gmem_has_safe_refcount(inode->i_mapping, index, nr_pages, &unused))
>> 
>> Yan, thank you for your reviews!
>> 

Thanks again for your reviews. I would like to respond to this since I'm
finally getting back to this part.

>> > Why is kvm_gmem_has_safe_refcount() checked here, but not in
>> > kvm_gmem_zero_range() within kvm_gmem_truncate_inode_range() in patch 33?
>> >
>> 
>> The contract for guest_memfd with HugeTLB pages is that if holes are
>> punched in any ranges less than a full huge page, no pages are removed
>> from the filemap. Those ranges are only zeroed.
>> 
>> In kvm_gmem_zero_range(), we never remove any folios, and so there is no
>> need to merge. If there's no need to merge, then we don't need to check
>> for a safe refcount, and can just proceed to zero.
> However, if there are still extra ref count to a shared page, its content will
> be zeroed out.
>

I believe this topic is kind of overtaken by events. IIUC the current
upstream stance is that for guest_memfd we're not allowing hole-punching
of pages for huge pages, so once a HugeTLB guest_memfd is requested,
hole punching of less than the requested HugeTLB size will result in
-EINVAL being returned to userspace.

>> 
>> kvm_gmem_merge_truncate_indices() is only used during hole punching and
>> not when the file is closed. Hole punch vs file closure is checked using
>> mapping_exiting(inode->i_mapping).
>> 
>> During a hole punch, we will only allow truncation if there are no
>> unexpected refcounts on any subpages, hence this
>> kvm_gmem_has_safe_refcount() check.
> Hmm, I couldn't find a similar refcount check in hugetlbfs_punch_hole().
> Did I overlook it?
>
> So, why does guest_memfd require this check when punching a hole?
>

There's no equivalent check in HugeTLBfs.

For guest_memfd, we want to defer merging to the kernel worker as little
as possible, hence we want to merge before truncating. Checking for
elevated refcounts is a prerequisite for merging, not directly for hole
punching.

>> >> +		return -EAGAIN;
>> >> +
>> >
>> > Rather than merging the folios, could we simply call kvm_gmem_truncate_indices()
>> > instead?
>> >
>> > num_freed = kvm_gmem_truncate_indices(inode->i_mapping, index, nr_pages);
>> > return num_freed;
>> >
>> 
>> We could do this too, but then that would be deferring the huge page
>> merging to the folio_put() callback and eventually the kernel worker
>> thread.
> With deferring the huge page merging to folio_put(), a benefit is that
> __kvm_gmem_filemap_add_folio() can be saved for the merged folio. This function
> is possible to fail and is unnecessary for punch hole as the folio will be
> removed immediately from the filemap in truncate_inode_folio().
>
>

That is a good point! Definitely sounds good to defer this to folio_put().

>> My goal here is to try to not to defer merging and freeing as much as
>> possible so that most of the page/memory operations are
>> synchronous, because synchronous operations are more predictable.
>> 
>> As an example of improving predictability, in one of the selftests, I do
>> a hole punch and then try to allocate again. Because the merging and
>> freeing of the HugeTLB page sometimes takes too long, the allocation
>> sometimes fails: the guest_memfd's subpool hadn't yet received the freed
>> page back. With a synchronous truncation, the truncation may take
>> longer, but the selftest predictably passes.
> Maybe check if guestmem_hugetlb_handle_folio_put() is invoked in the
> interrupt context, and, if not, invoke the guestmem_hugetlb_cleanup_folio()
> synchronously?
>
>

I think this is a good idea. I would like to pursue this in a future
revision of a patch series.

It seems like the use of in_atomic() is strongly discouraged, do you
have any tips on how to determine if folio_put() is being called from
atomic context?

>> 
>> [...snip...]
>> 

