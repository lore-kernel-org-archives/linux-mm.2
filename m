Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7356AC5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 02:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070986B007B; Mon, 10 Aug 2026 22:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021FA6B008A; Mon, 10 Aug 2026 22:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2BAC6B008C; Mon, 10 Aug 2026 22:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA60A6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:17:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22CF9A225E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:17:17 +0000 (UTC)
X-FDA: 85087376514.05.27B1156
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2A3B31C0009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:17:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cT82SdzF;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786414635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1H+h+WapU6HmHtu5GH/zw8vUgSMNLrMHJCstuFReTU4=;
	b=FzqfIN1uANU9Za58GACyZx6Y584ecaSZCwUupsxSPh58YbkxRpdQqC4hijts+ruzpY+zvJ
	nugjW8Laimts5W0QY7/8hnnKPU7V0aJl9WASOftlNbRYwOVchPsfcHGBZIEssWn0CIil4p
	P/AjPbZ8nXzqDGypnc1tgJsZERV4gWE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cT82SdzF;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786414635;
	b=b3QIUpHKIC2X5vyk2DOKsPDz2FfDmexmRxBGNDbbRw+CK6Cvnd69lT9+SOFETEAstDHKkK
	e8CafGnfyfPfZcMuwXYKDNUCsikM+BB8nojlEFbtP9sEZ2r7CGnuEsXdAe7fNAist193zf
	8q5SgxNKn+EaXjLpyDxYOJ02zJtVyPk=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so2480529a91.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:17:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786414634; cv=none;
        d=google.com; s=arc-20260327;
        b=D5rX8ozm8B4DfFTIPESaGkeJ9xunNDbwiZfDUlty+4LutKNjdS5OTerfVra1zZvB6S
         VfWxVv0NWvGU46E0fWLaS3eHDIHPFIVtZX7YmXPiaS4nC22gQlGeqen84YrsSO7wHGRk
         Dbft9X6AgqlbvcQ+b/hFXU337Vm/CbHXK2A8xK/hj3hsggRhODWtiQRjDNXd/q9K0VQZ
         4s/FmCZsHBFljFlf9w7gOL55oDF053qf0CtobPHldQbhodyGymzWp7n/vVXSurJvMnJY
         rod1yo10f4SkKkyBf00L3gaYpPK5gydMiwpbfwLeZx3Q12HHKb9OfN+i0DquejHUmum3
         P/vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=1H+h+WapU6HmHtu5GH/zw8vUgSMNLrMHJCstuFReTU4=;
        fh=XCDDPRxAxbkSKTb5FW/23GMpVJlZv0JjAhWjeOF85Bw=;
        b=G9d+kaSltLuDCfgCEEjOC5ZNTEoUL5hVmNS3muncgwtS7fzv/Z8LKYnkuOLkT6vfNJ
         f3d37HwhluUZqwNs3XD8iA9pmw22khIJCsmfGOIJRyjdX2/MZL/I9xaPbcgGNEWtKyBL
         Ym5C36Tr3cS+y3Q4EtU3SM+k7UtvxkjiB+t487dytuht2GoAqS6Rllq8PmDtE0VFe9CG
         ZkbJFil7KoJPbqoB1gRCwOE2EgUHO441nf+tN/9Sd/y1Q5Nqm5ERpW/v4iPcw6yZcaP1
         ZRXEMURRcd+jYVtUHRzlvse5FsSArNLCbY7fgcM6WMoRovDBfIA5LoLQ+emor16h3gSi
         61xA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786414634; x=1787019434; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1H+h+WapU6HmHtu5GH/zw8vUgSMNLrMHJCstuFReTU4=;
        b=cT82SdzFNnczBIMESwhX+ABS/aTxvT0Vd3qLv7ymM+Uh5SVCi9yxd2TUWbN43vBCEh
         1SsUB1R4h73AsQiW8jQIy/8thxDtG+SCpOoXh+Ike9/UeCO9UIHa53W6BAH/EERTRMAx
         NzqNwxwiqnVuN3jumSKA8aNbOYX6atPJZPXmgcoTMYWLU0077VVMGYBguXG4XZ/XE2M/
         skqSXfGdUlVTmVEAxYmmQOwgH3atspBpZnIrryDrz2lpT+QM8eO8i5ULlFuxUI/C5dxJ
         tMigSr2m+nPGKzymT0gUFOQdYHfhNZFYptcdOfzaLFBjnW/R7MCSEKZAgCdJsYDBmUD6
         D9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786414634; x=1787019434;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1H+h+WapU6HmHtu5GH/zw8vUgSMNLrMHJCstuFReTU4=;
        b=QucvCykLsIY4AhR6yiqqFBQJNDrq2FsehGsoEAs4hA/acnX91z9kqUbE0PBjlBdl7w
         Wxx6qlSHaxOGgljtpVfZ3KPjh9SIKYnGne+Q518fR89EWzA9DjJypc9c6zwAt67VkpdY
         RAHgU7uhUn6WnViwN2NoPHdwb8EszhjAS5UAFPWQSOFKXvVKA/M0o+ziTKo3mqJYYXZu
         sb/WH3VDZlr7zif/zVkTzBfAVBs8n5fVFWRUS65P92/NT4iFrGMVECvrW0TBtcZ7ktk8
         uzyDNDu8tbI50QVv/pzGpZMqNFIMy1eCMBuqy8yMeTrGbUJJ76EA7YI6a6fKuFtOdQQQ
         +/3w==
X-Forwarded-Encrypted: i=1; AHgh+RoyWfeY5NaOH+bWWqZl6zJPg5l09uvVfpOKfzWFGsB5qGPMfBKPJcMiKJT6W3O9aec7ALmv9WGZSQ==@kvack.org
X-Gm-Message-State: AOJu0YyHd+IPrwP41ObZXn0mXyuWsOYCiSSBnATUQQB0+v7qEVO6Nnrz
	4O+0KvHMERHowZbB1SvZ8qB0znRp01nxfVZ4lM2B2CLFKmA147sbea588+zdHK9WT8/I8tDayvH
	nN7pCYrAEq9+EwvIbTSIiPtxKa5Mp6GteVT8+bsOw
X-Gm-Gg: AR+sD11thk/wmeZA2P9ZbRKJFpn3kSrZWMupc1Dux1pDQYu/csIlU8mEhiSSnw+mYEo
	2qYQ2XUZ4Ut0+IMRgAar2SBiE/weHK6I3T8mV+RgPbWV/GovOhjE9Lu8sKIQQDr8T6fr0Q/twWm
	klLDAUPo2L1s2yco1ctAOojQmhVAwCDeVE7mAX2tUAmJerZjP/TxRbnfAnkmMzOLAlyWaMufgdn
	GEFASRifQeTw7mqXq3GWNmbKsgfpLGZ2287itxh8CoeYiLvOKYj5z1XiTEF/pQoHv6s5mo7UF94
	m1SP6Q4GfT6jhBB3Huxw7YUyVuclzQk4DsUItCnDiWSmuHfZzUQUcLZhBGNn/poges4HhblK06W
	T
X-Received: by 2002:a17:90b:3950:b0:37f:b0a9:1a68 with SMTP id
 98e67ed59e1d1-392822afd23mr27577046a91.7.1786414633045; Mon, 10 Aug 2026
 19:17:13 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 19:17:11 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 19:17:11 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
 <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com> <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
 <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com> <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Mon, 10 Aug 2026 19:17:11 -0700
X-Gm-Features: AUfX_mzvgcGJKhBZdH74z8--mi0L_iDlDHSTMM9cYEbuSUE6Lb98RLbbLhS37aw
Message-ID: <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rp1dzeyb4q9r7rxhxrzaf6z8brw3tqry
X-Rspamd-Queue-Id: 2A3B31C0009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786414635-856090
X-HE-Meta: U2FsdGVkX19ABA+qTQ0IF+EPiEDL3IuJmEfTbrUUFBrRxZLbCtctDGeR6t3xq6sV/wji2VSbozLnVPgcsv+Z4EBGkPa2MPN/s+9+9PPObBFVVP9tI6j/sC4ck0Uv9ZbXU/nRG5u5P3BoO4oCOYi/jv8GHPkXAK740SvUbsm6uivSnnPssrsdSeScWWU1lvrbRn/8xQuLm+cKEMl5LJ0E6BpmVbzfw8kQBK/lb/2EUH5mkZkBWTCVH812Nf/jFR1d5LanfE8erutpj7XRiHfmMaeiyqyrjQ5uzQm/4sFTGLCL2ANA8tMbRdivydclwq82ls/BGREQN5wNox24dlbsEMceUj5C7ILUfFj1wnIglOsUYRKjAUc596ZhA8kE6LjGhJllTQII/d8yt+1fiAedism6NxttUlPwRCpan3gl6YmdlmifREXoGsUa0PnyOODD4nTT8O9eDPOZpj/tfY2VBJ8CIUvHfzLHUxIFJ9ffp5G2dop9n0PzXSPstun/wfQvNv1K9CH3Yuz1J8TRyWJUxvRrAJpuVSslo5QazaF3lHfy6Y1vjUInqXhoFuB9Kbc/lQtXlUBHCCoaevfX7126D4SBLaYcr2bu8Kc3sOdQk9rAUm/3r423B4Mu7LkFqf/gQk67a4N6zY3ujj63PuJaPCP/Nj+dOkxQ5Omg4Fufn2WetoyYNmqrL/eMRaTEuTXcEp8sWmhM3nJIAiIr6421a8kutu/05vvZVfkCb/yfMfeKx9rOSpG6iIMfK+zPjReQoyjfV7KHXbB35bZXPwRv0xMKobc7gDdNa8oaNeGXVJxoC5iabFbB7Hfsh3CiOX3oZuGhZ2+kjJ3SXkb8ro4oJqs5+bpLIoAbyZ5nV5sC/explZMYyBykF5SPRfN8/3umSZI8Z7dHY18bAste+e5KDQyEFyNuos4LGJKvMNW2PpPdCpzU+q32QYc1pWl7PbbI17nvbvLV76a68Z0pDMJ
 tpwmsaT6
 zYqwMabjwyZaPvKdvV28w7/yFPaoLnRAWT33S7clVqlAlC3DfnGAMqwZJVHIq94RMvIX6ZSIM4VBNwpu5o7UnoTIx5PN6i6rvsEoa8QoQf0HhMHxKDw0G6PzG+tX/Vpv6J2qVSLExXuTBVXSZi+zmolAJaXsvs/KNF6wA5sBaGuYEYe5coXXxwFH7XAqD1/vQdmYtBg4NoI2xwRZVs7MzwE1eG9rZxRZ0Xdfl0VGkEJ6bDklXrOnyGQK7bE5sfxtMmA0YPeto0nxZsMrff+OGcEqeTqiHHOGEOD8xtze2fpM3BynghT4BnXsq2rhGdhHeEmu0qyEdasz12Iby8AjmlxDIv/zlcUjdBYxlWa/k461/bw6huBy34io8hs1RpYLtHPpddn0J0kFQSvfjQF+i6DxihUFBBM1zp2qX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Mon, Aug 10, 2026 at 02:06:06PM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>>
>> >
>> > [...snip...]
>> >
>> >> > @@ -542,8 +576,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> >> >
>> >> >  	mas_init(&mas, mt, start);
>> >> >  	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>> >> > -	if (r)
>> >> > +	if (r) {
>> >> > +		*err_index = start;
>> >> >  		goto out;
>> >> > +	}
>> >> > +
>> >> > +	if (to_private) {
>> >> > +		unmap_mapping_pages(mapping, start, nr_pages, false);
>> >> > +
>> >> > +		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
>> >> > +						     err_index)) {
>> >> Note: conversion failures could occur if another vCPU is attempting to map a GFN
>> >> within this range.
>> >>
>> >> CPU 0 (setting attributes)          CPU 1 (attempting to map)
>> >> --------------------------          --------------------
>> >>                                  A: mmu_invalidate_retry_gfn_unsafe
>> >>                                     filemap_invalidate_lock_shared
>> >>                                     __kvm_gmem_get_pfn ==> folio refcount++
>> >>                                     filemap_invalidate_unlock_shared
>> >>
>> >> filemap_invalidate_lock
>> >> filemap_get_folios
>> >> check folio_ref_count(folio) ==> Not match !!
>> >> filemap_invalidate_unlock
>> >>
>> >>                                  B: read_lock(&vcpu->kvm->mmu_lock);
>> >>                                     is_page_fault_stale
>> >>                                     kvm_mmu_finish_page_fault ==>folio recount--
>> >> 				    read_unlock(&vcpu->kvm->mmu_lock);
>> >>
>> >>
>>
>> Thanks for reporting this!
>>
>> >> Retrying in kvm_gmem_is_safe_for_conversion() or moving the invocation of
>> >> kvm_mmu_invalidate_start() + kvm_mmu_invalidate_range_add() to an earlier
>> >> position does not help as long as CPU 1 stays at stage A.
>> >>
>>
>> IIUC CPU 1 isn't blocked by a conversion so stages A and B should
>> complete fine, and CPU 0 would already be retrying for other reasons
>> anyway, like speculative refcounts from elsewhere in the kernel, so the
>> conversion would take longer but it'd work out.
>>
>> Is that understanding right, that this doesn't completely break
>> conversions?
> It depends on the timing. The max retry count cannot be expected under unlucky
> conditions.
>
>> >> So, should we avoid this failure?
>> >> e.g., by moving filemap_invalidate_unlock_shared() from stage A to after
>> >> stage B?
>>
>> Not really sure about this, how will control go back to guest_memfd
>> after the fault finishes for guest_memfd to unlock the filemap?
> I don't understand your question. But I find this solution is less ideal than my
> below proposal.
>

When kvm_gmem_get_pfn() is called from kvm_mmu_faultin_pfn_gmem(), KVM
MMU takes over from there, there isn't another call when KVM MMU
finishes mapping the page into the stage 2 page tables back into
guest_memfd.

After stage B, how is filemap_invalidate_unlock_shared() going to be
called? Do you mean filemap_invalidate_unlock_shared(folio->mapping)?

I think filemap_invalidate_unlock_shared(folio->mapping) is a little
asymmetric...

>> > Or what about having KVM always treat gmem page as non-refcounted, and have
>> > kvm_gmem_get_pfn() put folio refcount before releasing the filemap invalidate
>> > lock?
>> > Below patch is applied and tested at the end of this series.
>> >
>> > From 8c2f29bc15bceb6a8fa103cf2585ec11354fd74e Mon Sep 17 00:00:00 2001
>> > From: Yan Zhao <yan.y.zhao@intel.com>
>> > Date: Mon, 10 Aug 2026 06:24:52 +0800
>> > Subject: [PATCH] KVM: guest_memfd: Return gmem page as non-refcounted
>> >
>> > Have kvm_gmem_get_pfn() put gmem page refcount before releasing filemap
>> > invalidate lock and return the gmem page as non-refcounted. This avoids
>> > gmem memory attribute conversion failure caused by temporarily holding gmem
>> > page after faulting and before completing mapping.
>> >
>> > guest_memfd always holds gmem page in filemap cache. TDX does not increment
>> > gmem page refcount when having gmem pages mapped in S-EPT. Additionally,
>> > as gmem pages are not swappable, setting dirty or accessed bit is not
>> > necessary. Therefore, there's no need to treat gmem pages as refcounted
>> > pages.
>> >
>> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>> > ---
>> >  virt/kvm/guest_memfd.c | 5 ++---
>> >  1 file changed, 2 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> > index 2115e73e455a..e357b4ffa777 100644
>> > --- a/virt/kvm/guest_memfd.c
>> > +++ b/virt/kvm/guest_memfd.c
>> > @@ -1332,11 +1332,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  #endif
>> >
>> >  	folio_unlock(folio);
>> > +	folio_put(folio);
>> >
>> >  	if (!r)
>> > -		*page = folio_file_page(folio, index);
>> > -	else
>> > -		folio_put(folio);
>> > +		*page = NULL;
>> >
>> >  out:
>> >  	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
>> > --
>> > 2.43.2
>>
>> Hmm going with the above CPU 0 and 1 illustration, if instead CPU 0
>> truncates the folio and the folio ends up being freed, then KVM's MMU
>> has a pointer to a page that is already
>> freed. kvm_release_faultin_page() is passed the pointer to this page and
>> will dereference the page.
> Not really. It's just like KVM mapping non-refcounted pages.
> kvm_release_faultin_page() does not access the non-refcounted pages.
> The invalidate protocol also ensures no mapping of stale pfn.
>
> As below, if CPU 0 truncates the folio, it needs to hold filemap invalidate lock,
> add KVM mmu invalidate range, hold mmu_lock, zap KVM mappings before the
> truncation.
>
>
> CPU 0                                      CPU 1
> -----                                    --------
>                                          Save fault->mmu_seq
>
>                                      B1. filemap_invalidate_lock_shared
>                                          __kvm_gmem_get_pfn
>                                          folio_put
>                                          filemap_invalidate_unlock_shared
>
> 				     B2. read_lock
>                                          is_page_fault_stale
>
>                                      B3. kvm_tdp_mmu_map
>                                      B4. kvm_mmu_finish_page_fault
>                                          read_unlock
> A1. filemap_invalidate_lock
>     kvm_gmem_invalidate_start
>
> A2. write_lock
>     zap KVM MMU
>     write_unlock
>     truncate
>
> A3. kvm_gmem_invalidate_end
>     filemap_invalidate_unlock
>
>
> A1 occurs either before or after B1.
> 1) If A1 occurs before B1, B1 will find the correct pfn.
> 2) If A1 occurs after B1 and before B2,
>    a. if A2 is before B2, B2 must find the fault is stale, so it's fine.
>    b. if A2 is after B2, A2 must be after B4 as well. So, accessing stale pfn
>       in CPU 1 is fine.
> 3) If A1 occurs after B2 and before B3,
> 4) If A1 occurs after B3 and before B4,
> 5) If A1 occurs after B4,
>    A2 must be after B4 (for 3-5 conditions).
>    So, accessing stale pfn in CPU 1 is fine.

It's not about the stale PFN, if there's no refcount on the page
returned from B1, then after A3, the page can be freed.

Contractually, I think KVM is allowed to reference the page?
kvm_release_page_clean() calls kvm_set_page_accessed() on the page
(UAF?). Not sure which other KVM architectures reference the struct page
itself. Are we going to teach the rest of KVM to not reference and not
do kvm_release_page_*?

Would like to see what Sean thinks of this. Either way, is it okay to
follow up after conversions lands?

