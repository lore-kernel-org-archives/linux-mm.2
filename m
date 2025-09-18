Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCCA0CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 06:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34EB88E00BE; Thu, 18 Sep 2025 02:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325BF8E0093; Thu, 18 Sep 2025 02:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262BD8E00BE; Thu, 18 Sep 2025 02:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 127DD8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:31:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F9D21DF2EC
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:31:06 +0000 (UTC)
X-FDA: 83901398532.24.620BBC4
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id CDBCE20003
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:31:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OpOEuWQt;
	spf=pass (imf13.hostedemail.com: domain of 3J6fLaAsKCPASUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3J6fLaAsKCPASUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758177064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYw7ATyO+FbNb+44lQoltDz9PEwp1UWJIGjKMOTdpb4=;
	b=6vE/eOq/v6gap/mVwuMHV//5C5STJARhpiAKYdTRk01mFKFz2mOhrufeVGKlQF2JNJ8en4
	pZ3cDBPizQd2T11H5w+sGuZuBlY2U+R7SZXziLEOIPTRUSFhIA8ZyUwKjdDmW6+Oq+HovP
	jcb0dhLMkzjWz4uK7n3JUJqgtkNxyL4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OpOEuWQt;
	spf=pass (imf13.hostedemail.com: domain of 3J6fLaAsKCPASUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3J6fLaAsKCPASUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758177064; a=rsa-sha256;
	cv=none;
	b=L4zBXOv76CVEtnJuG/XXjKcili9iJFrB27Z7pZJdnzn8ZRSvnkc+1L1buUERoJ1SWc1xwz
	VLYSo2HaQzi1duN4JOVGHM4NWgn//g9z4W9p1dMsd39w/rdkdxkE+aQBwIsj23ltxFPolz
	Vpno8EHAHTNnciGsy1fsbWKsAtVFDvk=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso60744a91.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758177063; x=1758781863; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zYw7ATyO+FbNb+44lQoltDz9PEwp1UWJIGjKMOTdpb4=;
        b=OpOEuWQtYOnn4DLFKorP0ZrFugZ4t/pV9rZaUbd/JQBQ0DL6uRg0U0oQBWINgNVzpP
         g4PkKREJogBCmn7A34/4f/XW/Flhwvm35R9ZgiOVfyIPu5ejAvwAmCz3jZs9UI+ONZ9R
         qW4usGfCtvyt8B10WEckcsPM5RFsp9EOVCV/7R90lztmT3KQb0Prx1xfk1ONut7Jx8oq
         VcblRQFfvbxwk+gHtKi2cBrLn9IlNiJTwLCyve1sxZFbaYe+LmPkrfFoMU+ydXXkidtU
         VyZ0qv+qHL6kTxIH5/fTQZY7LzoEdef7oWpeLiVCQge314CwSCmDpWLQXCePV+58ToQD
         439g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758177063; x=1758781863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYw7ATyO+FbNb+44lQoltDz9PEwp1UWJIGjKMOTdpb4=;
        b=TDCjPyfAtfZuqUeOFPYNrOs2htiuiDVTLiw9MxS0JIG+PQ+H8+OId4sqMDKi7VFcNX
         rB+GkxrbDeq7uLvWSYHZRrnq0Ce5uCOSmKu7Hs9a0SPNBhNOjQWMvOeRjJTvCr6HShth
         EeOMXfySxO8fzRBicFE95aS0SvQFPyzsIGJVgaqunL5wuJUjIuBAjyquvN7VWFedO1o7
         en4awbW1tRfLSiNrbRo6FIydST6S/n76qni2vmzUSemjnywNwKE617Zk2z4Fcmb5Xovd
         xgvAjeAS9ifpdqNm/DIZHQOZlb5EgTZdXKB73ht7xhPgT7Jnc4FwCBBk6b4YNHzAp6Q0
         5sZA==
X-Forwarded-Encrypted: i=1; AJvYcCXwa/hr2hFMSDN5sgLKnyfgzfglXcGwNqQuRAztbtkJl3OlHHjNIp+yE22ffqPpbmwDoMJVJOm6+A==@kvack.org
X-Gm-Message-State: AOJu0YzdwYHtSyoTEO9OJjYOQTQvokrBnXKCFkWq5yEF95XjaV2B31Hi
	v3AX91MOlFqPkZ1NxGYDMKdzAArTzWfm7u8TvrDRAa0qUkH8XKnAWR4ukYcyLkfJJBl2Da9eRbq
	7hTMSblUAozL7AsJpfiex2NQaBg==
X-Google-Smtp-Source: AGHT+IG8r6Hh7ieBZNhEHWEonWxugVqZ2GsgcsPqQV0BbYfLkp6mgTeqw5ZShceR0hVG0T5MXwZgGvkkREJdhdBrSQ==
X-Received: from pjvv5.prod.google.com ([2002:a17:90b:5885:b0:32b:58d1:a610])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5788:b0:32d:dffc:7ad6 with SMTP id 98e67ed59e1d1-32ee3f8c588mr6178959a91.33.1758177063484;
 Wed, 17 Sep 2025 23:31:03 -0700 (PDT)
Date: Thu, 18 Sep 2025 06:31:01 +0000
In-Reply-To: <20250916233335.wv2lf4fiejlw53o2@amd.com>
Mime-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-2-michael.roth@amd.com> <diqztt1vf198.fsf@google.com> <20250916233335.wv2lf4fiejlw53o2@amd.com>
Message-ID: <diqzo6r8p90a.fsf@google.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	vannapurve@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CDBCE20003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: duwpgueh6i4wb5wzaxy5uuz8waqqmmib
X-HE-Tag: 1758177064-571287
X-HE-Meta: U2FsdGVkX19ScpxHXn63+2BsK1MYbjMKu1OZ0FQ4u60AGssA2yMcgqvrjgLq1QwC6ba2k+ZDmFoqqB9iDG05WjknG18x35EPaSPQ4g2K2dNJoEL415EZGVsRtr7SJTjnIRkcfi01w+QBvdcWGYzjSvoJEB2WEYZIurwc8Cx2iNHECmV5z0O0aSndzEYIGDkp0Em6J9IfO33MKs22nlBcWsyCXahsYTR7GSLoQsLXH5BTqxHxE6/WvwVo79piU+v8Mar9QwM08Nn2XaJEVNPg6P8MebxMuv/rBTBHEIcQujD5ZFJ+mxLEdEkeosWc7wsTfiVCHzlsXLXqMIAASQd6fjUGXsWNF9skX1nYPcXLP8EDBybx5rrJyBmYan7mdGr1s5dxxYlm0W9pPmeyPqOrIF+dJf2DI1PZfk/tni+A/DR73Tto6qSDrEs2rafrPtg3XPjXqWc9rZEHyDQbKCP6Nmt8LkUekcrm7EyPEiAB0RDOWGdEZKMHDVvYH6zdfR/PGzSbYRpgLslo1U45GzNzeIF5ktlGSqrCGwmdt6CbkG+peHM2x6ZzzSteI5tKiUpIfWc3dIv9/Vn8iiTqTWZVFeWGOFdssMOeRqWkfP0BS/ldkyBEot3yqvuWG2wr9hfM3NcLM/YPUn0IxyynqGdWjUiEG093zG/iOH1tWla2H7Pe3vT7TtdVVDdQ+59aBxvo+TnAk3tpwn+aQRXMmTV+7qQ1N6GMPu6Wz3zPAEN3m9h07UUKYkZQ3oMiJPO5YjZBvjuVKXusmFm5PVnDEnyjgorK42GrJx6lQNW0qlVrQd1DrYI5KCPwdGUKyU6+MujDzfiGFV+eOgQqTPyV5uqV1NqShr8mLMhCdr5Dp+G8lJg/+yEgnvfCpDfXpSMLmFwtw7IXasb3HGw6ZOgOzwTA9aO8gyZYnhSl2JqubHfpUWEuLmP1Xjaqeb8lx10sYtr44/bGcVy7MHTD+JwKit7
 hPZTWcgF
 8E0zLF9tSbu73rUyqGUkWryGjmiKRlapxelc8+AvSAVfk7pWhNtROtIOwRKvmVdLkx8DaE8X0U9GnL1O5t/iUooqscQKIgpSAwYy5RJRs+HbGZSH4AldVSuzAJILwcRy4VHPQEELHet8yEkUPljYYyLhC92/+S+LulHVkiJfQr9wLj3RGA9LJRvpQK9l0Ichzh6bQATtjvDgJxjNsyAcwxjMj6Fv0OtaRwWJvHD1v7Ozr4oHkFq+n3b72xp0Oz5NoJM/TozMzirJhaQP6iV/RKcogEVZDhsktrLsHglclP1epFaV+iLT8NJ4EXvryNerP3/GwFFlo2zNlAaCBpACmu0hli2X0vVwc1QfbS+5bYFK6RHMwL7ZnNCPAa+N8t+I11fl7E1HMkRpykxkuNu5nO15u6HR+RD7thydJl7oNOlroS10H3m9RDxIQ8vEummMHlSPaSQHWQxRNcDDw5fGhalLZn9PIMMO5Kn8drTq999koR4+wHx7EV60tvXur/L09bq5+ZGf2cE35hW9uRT2yL7Fe/CbK7PP5MlKPAXPPb1PqDQwV7+Ah03F5ubU+D2/iJLJL5QA3bZLGyV3M06KXyjIGY+2qxOIK0hzSwx+0vC/UbK2XU23UBGrhGZLr8HObHCVuYckQFDbHilqxa5ZOZ12Y71xWVYp4l4s7BSmEu98EUqjC9YQdRike4j8W87RidltXPQ2bmSKrkWycLa8ztDpJl5XsZwAfxsY9ta6ir0hZoMWareySnC454T9c+uNKvvZOS6YfkwHqr84=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth <michael.roth@amd.com> writes:

> On Mon, Aug 25, 2025 at 04:08:19PM -0700, Ackerley Tng wrote:
>> Michael Roth <michael.roth@amd.com> writes:
>> 
>> > guest_memfd currently uses the folio uptodate flag to track:
>> >
>> >   1) whether or not a page had been cleared before initial usage
>> >   2) whether or not the architecture hooks have been issued to put the
>> >      page in a private state as defined by the architecture
>> >
>> > In practice, 2) is only actually being tracked for SEV-SNP VMs, and
>> > there do not seem to be any plans/reasons that would suggest this will
>> > change in the future, so this additional tracking/complexity is not
>> > really providing any general benefit to guest_memfd users. Future plans
>> > around in-place conversion and hugepage support, where the per-folio
>> > uptodate flag is planned to be used purely to track the initial clearing
>> > of folios, whereas conversion operations could trigger multiple
>> > transitions between 'prepared' and 'unprepared' and thus need separate
>> > tracking, will make the burden of tracking this information within
>> > guest_memfd even more complex, since preparation generally happens
>> > during fault time, on the "read-side" of any global locks that might
>> > protect state tracked by guest_memfd, and so may require more complex
>> > locking schemes to allow for concurrent handling of page faults for
>> > multiple vCPUs where the "preparedness" state tracked by guest_memfd
>> > might need to be updated as part of handling the fault.
>> >
>> > Instead of keeping this current/future complexity within guest_memfd for
>> > what is essentially just SEV-SNP, just drop the tracking for 2) and have
>> > the arch-specific preparation hooks get triggered unconditionally on
>> > every fault so the arch-specific hooks can check the preparation state
>> > directly and decide whether or not a folio still needs additional
>> > preparation. In the case of SEV-SNP, the preparation state is already
>> > checked again via the preparation hooks to avoid double-preparation, so
>> > nothing extra needs to be done to update the handling of things there.
>> >
>> > Signed-off-by: Michael Roth <michael.roth@amd.com>
>> > ---
>> >  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
>> >  1 file changed, 15 insertions(+), 32 deletions(-)
>> >
>> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> > index 35f94a288e52..cc93c502b5d8 100644
>> > --- a/virt/kvm/guest_memfd.c
>> > +++ b/virt/kvm/guest_memfd.c
>> > @@ -421,11 +421,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>> >  	return 0;
>> >  }
>> >  
>> > -static inline void kvm_gmem_mark_prepared(struct folio *folio)
>> > -{
>> > -	folio_mark_uptodate(folio);
>> > -}
>> > -
>> >  /*
>> >   * Process @folio, which contains @gfn, so that the guest can use it.
>> >   * The folio must be locked and the gfn must be contained in @slot.
>> > @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>> >  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  				  gfn_t gfn, struct folio *folio)
>> >  {
>> > -	unsigned long nr_pages, i;
>> >  	pgoff_t index;
>> > -	int r;
>> > -
>> > -	nr_pages = folio_nr_pages(folio);
>> > -	for (i = 0; i < nr_pages; i++)
>> > -		clear_highpage(folio_page(folio, i));
>> >  
>> >  	/*
>> >  	 * Preparing huge folios should always be safe, since it should
>> > @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>> 
>> While working on HugeTLB support for guest_memfd, I added a test that
>> tries to map a non-huge-page-aligned gmem.pgoff to a huge-page aligned
>> gfn.
>> 
>> I understand that config would destroy the performance advantages of
>> huge pages, but I think the test is necessary since Yan brought up the
>> use case here [1].
>> 
>> The conclusion in that thread, I believe, was to allow binding of
>> unaligned GFNs to offsets, but disallow large pages in that case. The
>> next series for guest_memfd HugeTLB support will include a fix similar
>> to this [2].
>> 
>> While testing, I hit this WARN_ON with a non-huge-page-aligned
>> gmem.pgoff.
>> 
>> >  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
>> 
>> Do you all think this WARN_ON can be removed?
>
> I think so.. I actually ended up dropping this WARN_ON() for a similar
> reason:
>

Thanks for confirming!

>   https://github.com/AMDESE/linux/commit/c654cd144ad0d823f4db8793ebf9b43a3e8a7c48
>
> but in that case it was to deal with memslots where most of the GPA
> ranges are huge-page aligned to the gmemfd, and it's just that the start/end
> GPA ranges have been split up and associated with other memslots. In that case
> I still try to allow hugepages but force order 0 in kvm_gmem_get_pfn()
> for the start/end ranges.
>
> I haven't really considered the case where entire GPA range is misaligned
> with gmemfd hugepage offsets but the proposed handling seems reasonable
> to me... I need to take a closer look at whether the above-mentioned
> logic is at odds with what is/will be implemented in
> kvm_alloc_memslot_metadata() however as that seems a bit more restrictive.
>

Does this help? [1] (from a WIP patch series).

KVM already checks that the guest base address (base_gfn) and the
userspace virtual address (userspace_addr) are aligned relative to each
other for each large page level. If they are not, large pages are
disabled for the entire memory slot.

[1] extends that same check for slot->base_gfn and
slot->gmem.pgoff. Hence, guest_memfd is letting KVM manage the
mapping. guest_memfd reports max_order based on what it knows (folio
size, and folio size is also determined by shareability), and KVM
manages the mapping after taking account lpage_info in addition to
max_order.

[1] https://github.com/googleprodkernel/linux-cc/commit/371ed9281e0c9ba41cfdc20b48a6c5566f61a7df

> Thanks,
>
> Mike
>
>> 
>> Also, do you think kvm_gmem_prepare_folio()s interface should perhaps be
>> changed to take pfn, gfn, nr_pages (PAGE_SIZE pages) and level?
>> 
>> I think taking a folio is kind of awkward since we're not really setting
>> up the folio, we're setting up something mapping-related for the
>> folio. Also, kvm_gmem_invalidate() doesn't take folios, which is more
>> aligned with invalidating mappings rather than something folio-related.
>> 
>> [1] https://lore.kernel.org/all/aA7UXI0NB7oQQrL2@yzhao56-desk.sh.intel.com/
>> [2] https://github.com/googleprodkernel/linux-cc/commit/371ed9281e0c9ba41cfdc20b48a6c5566f61a7df
>> 
>> >  	index = gfn - slot->base_gfn + slot->gmem.pgoff;
>> >  	index = ALIGN_DOWN(index, 1 << folio_order(folio));
>> > -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>> > -	if (!r)
>> > -		kvm_gmem_mark_prepared(folio);
>> >  
>> > -	return r;
>> > +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>> >  }
>> >  
>> > 
>> > [...snip...]
>> > 
>> 

