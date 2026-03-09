Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3590EF36E8
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 06:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80146B0088; Mon,  9 Mar 2026 02:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37946B0089; Mon,  9 Mar 2026 02:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D360A6B008A; Mon,  9 Mar 2026 02:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE4F56B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:59:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64F228D280
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 06:59:01 +0000 (UTC)
X-FDA: 84525622482.06.798941B
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8EFB81A0014
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 06:58:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nLBITQ6y;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773039539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xm+uz1scAwUZE28AuDXf2j1vo8g+3wU8dKlPy71SF1k=;
	b=yu7sZ0VCcBo4PIQ4oW854m1WXaaWcl9U4d+BCk/Qy9+MzQO9z3rSvICPehYkBKQtPphz7J
	e81fF4hj2NZ9ePNNiEHKZwjjZANeN2WxALazaBwgV3dhyKXHpV139EJsuv/tmRiymWZ5QC
	bg6WaF1jlEaum8JMoGn2SgU2I76kR5k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773039539; a=rsa-sha256;
	cv=pass;
	b=vPUOcPxFCf+FSewcZH7nASTBj7jxM7lmdUPSZYMdw33DIqLesxr2VCkERJjud2xQ8WqseS
	5RirvaPf2NBScn1sMIsWhbp4I6aJAB2GkFBQrfd3pCyMJnb+njs9kZSrG4r/5TA2j+9POz
	ITSSog0Om3YC1un6pXgawo5FP3os6XI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nLBITQ6y;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-5ffe41e8e83so1674760137.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 23:58:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773039538; cv=none;
        d=google.com; s=arc-20240605;
        b=QrcCXGk9VXxK223L+1u+CnLgAjnLuZNCvpQV+vYLwe2g519N3q0ZJOm10y0swqctqI
         bhyzhpTm1Z6tslDoYQHek/58cEi/xEOUWiz4bJ90yoTNVLWhOovxmfGP1BBohOU0LyN9
         NBjEk+ieZCuoK47bPmT99w5UJyG7voOJFkhwxxHwp0kzqY7ERhwaXKmjMKf1cLk9dSix
         wkEtZcBBo7hQ3IogMQfuXfdKdIsNCcu3+I7+eGUe7ryjQFqi+JZRDDlEQW9PM+Jovqsl
         5Lag2f9fwbl2qLJMeFkc9UA85i04JVqLfLd7Oq2wpasthvT6Jz7aY3vRPhlEM0zc3jFw
         KMSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Xm+uz1scAwUZE28AuDXf2j1vo8g+3wU8dKlPy71SF1k=;
        fh=n2OJZ2bRKRY27K/gljfq5vlP7dioHL+8odNJK0co4T0=;
        b=HrT8nnTY0v5d3jzOJmei5r5oT/DWWH48SV3JoSK6NBMNxUE5kxVb8kgP9hnKh/0Nez
         UHPYtu1fijgC9qISsKg9nSWryPGco+UKyLTviVyOgaZIx9qH2hCfhNlXokDUGpMiwwgS
         1OAXI9ktxQluv2X4ffjETY+qxPeyHBxSvVNiIKN1c/a3y+8uovT7IRp1NbNvSLOSDjoN
         OclJhkX1nZEcDK0yTnFIBJHMLAfc/TGCSO4bxGEWPAbWeKvHluYRYMLGl0ivJwg26WTg
         JWK0kQC/JxM74txuz78s9JVXoYlm874IcXSxC6g3LLvzAv24Z5AY4fBWdnQyTwg/ySjs
         kyjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773039538; x=1773644338; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xm+uz1scAwUZE28AuDXf2j1vo8g+3wU8dKlPy71SF1k=;
        b=nLBITQ6yzldzRjiWVsKwCz1U5LZyJ1KAKsjqFmTyN/WmCXJP7quUcWZK868MrkIhH6
         GBqNxPbstrCQD+LSySjvmaTKX4VKcnKxJGj6AjTnNlMV8j6QFNeKIVup76kWTts5KFsO
         WlB/k5WopCY1SbW5sLNr0MUhNy8sIdAST4w+6otsB01l+GNGyDzTy85ypO7ie0T6RYoR
         m2cHR8pBtRpyZgWNIiRfQrXDxUA/9EriVY9PQPGgO4fRzrbnlNihTJQmkrpJ//Lo56+B
         ToaanE2XzpGAed5M5G9ETApoa2d/P5qW3THTG6zqSlYuKafLZe2tEMTkFz5pJAQ3j1hQ
         TvKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773039538; x=1773644338;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xm+uz1scAwUZE28AuDXf2j1vo8g+3wU8dKlPy71SF1k=;
        b=iIkHlorbLbgWRHHn8JvZQdO3f3rmjjOkXbIQNCLR96QEQEeZOAvy0Yzb+jaHGQEGaD
         20xy+QdHZkyQimhqE3GiycH5n4yP2ysIdcM5xZLujyZcZ1NUhUFMUgcDlEfDF41BId9j
         NVmOCH8CQ7iLYhbfXxf3Qx78zqhPKdvg4MZoTJYpRS3J3wANi4SId6Z5BAi3HVMABZGE
         Bt93ubNpTFf3Q/JhyY/vYd7djaB0DplYRmhfry0HiVFqh02OoqRLBFSaW0DLshz+ggNk
         T+Y10l0GQstfMmtyFwwzd+WweieMMFEAKK5yRDzJPEA/H9p/a79/pafZFLT0pBanJ63P
         /T6g==
X-Forwarded-Encrypted: i=1; AJvYcCW0dBiq35Lcvi4Ymt9qDgaetjqV95PLM/nMJrr0/JIdVS8FECYhLjciZ+ellLDWMhdlg/J+KtouYQ==@kvack.org
X-Gm-Message-State: AOJu0YwBbkIsLeoQO5VWvOdpBDaXaInSF8yF36C03VO/MmHBpYOCFt1S
	4TLbTrExLLUZK6nCjjx+h6qhmhTAS1XAtZxm3PwgymXVRL/gIJIzOURs97Ar03qK9Az9ngz9iHf
	8PVGZkneW0iYoE3R4gSXRNHmy6t+DOP41ejyIC+Hc
X-Gm-Gg: ATEYQzwj7JWbvlnVSFlpuRIu0+H6mmUvZFSV0DlIAF6n6StNJuLfQrkbf7KUnVG/+q0
	ecoN3IcrjMM8wx9yZZ3RJnp7sEpiYNco8nsoQ8ktRW2KNhT+9jTELfDtEzwdWZsJpOTTZz2SnDO
	cLUr9C96vRFOHNA/+mVhujh90MiDpS/xXaAHuQ43z86WqcV0jUw78F9V0QWJiBUxKxiLZCXErCx
	wUn2yXpI/Magh2fXvSsAFdjDmj89o0ulHmUhBTC9Xmh5Ab8y0Ogc/Sg2DFTUMyhawsNjoDpUKzT
	oL3L9fhIKDMm18AolvCuKYGW/sQUSCUI1kC8e1NxiS/+YZwLhikg/zkIyh9RBj2oYu9tjeAcz/O
	Se8bL
X-Received: by 2002:a05:6102:e13:b0:600:1547:967c with SMTP id
 ada2fe7eead31-60015479e34mr1563846137.16.1773039538125; Sun, 08 Mar 2026
 23:58:58 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 8 Mar 2026 23:58:57 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 8 Mar 2026 23:58:57 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260226180821.2218448-1-joshua.hahnjy@gmail.com>
References: <20260226180821.2218448-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Date: Sun, 8 Mar 2026 23:58:57 -0700
X-Gm-Features: AaiRm52DFXwwe30HaILLP1hzK0v0FaeZdOZHX4R5IM7HVR_30U8T8Nloh1wxEVg
Message-ID: <CAEvNRgFpD0jD8QdmBPz-T=jhGn+Rb8MjTq4aycAUkAx54fMhWg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/7] Open HugeTLB allocation routine for more
 generic use
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: kxuta1shge8a3prifz18page5513nz7p
X-Rspamd-Queue-Id: 8EFB81A0014
X-Rspamd-Server: rspam03
X-HE-Tag: 1773039539-424744
X-HE-Meta: U2FsdGVkX18WXeA/535aHeIhIykDT9a/6+/sswRT+UFrCUlb02081vds/5ERPgkfwnwcnAPTFdv26/dj9jLS6sRIB7jxqCtHQTaSsPmViG+36hsKnT7SN2XEatnjc+Bm5CHdJJec/u+V3E5JPSOboOXgQqHX7B1+s3PUMbzXn8mvVARF3ZuvZb7hCmzcYzKqW4cY4htse8+m39WCjinUrnQ9o3R4go6KAP1ihFZMEYb4DjEE47y465yxEoL8Q4JJy9ikDfFB3wRO6ZTKxTkgA2ndZLaj9iSLU8N4WcxRi3+wQI7Uo6IAGhl1ijTAicMI76XR65vwGPPZdx2x1lDvFcy8sxwdClhVNUpQBOqQASUg1LhL1xZC/UgxsUTOGFlo6D5s/Yd52AzvRneXjuZgfnDVRdv96jnBLQrUlQZrvUB6SHL+NRW5L647Ro+3Mna0PoiM8tMimNKr7rf92LY3mejnI3xHf8DEbwCjAex3W+fYg37/ew7bp5eysBJynnf1N2io3YQLKgCgEJF2+lmEh9cAIzWDEIEvBkLW3Xp3N8ACp6n53jorf847qYc9NHD257bivDNJkt1DSZIhf+cEU+F3Wvmn8Ce7iWzJ4ALrQSBjhExzOb2wGkol7/BsdlKgLjIQN0TcinOMrGoI/WTTuAwXFB62pWibRSM0JAhl71g8jqLbB3nkI+5kHKE6kNETRJnxDtsdbof32J/GaxmgvI2FZJ649h/6P6D9apUTUIjsNCKtok2KM0mUXkpXhnz9gIQ5B9bP1ObZk+r6J9L6T+82znpuN1ODmblLRAvfFWoegARIpItrj08nVeXRFUcNU7OIhvJLOiiJDGUBHeqWGfavSKP3PPmqGN2jJgv6Y8+zrVZFEZihpFqU+t5bJ7wyogNivDownI0hsSOu4e6oMvqfzo95xJ8H3KQEzkZw/EsU4V3R81G9rUvsJ7YRWLIFoZs/QSwm0c5HAdHaTr4
 J5BiRH6e
 2uw0oJJY3BXOBpSs3D5G9QeH9bq55Mh4XLcb3UAX/lilVK98h49j9SdfeIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Wed, 25 Feb 2026 19:37:04 -0800 Ackerley Tng <ackerleytng@google.com> wrote:
>
>> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
>>
>> > On Wed, 11 Feb 2026 16:37:11 -0800 Ackerley Tng <ackerleytng@google.com> wrote:
>> >
>> > Hi Ackerly, I hope you're donig well!
>> >
>> > [...snip...]
>> >
>> >> I would like to get feedback on:
>> >>
>> >> 1. Opening up HugeTLB's allocation for more generic use
>> >
>> > I'm not entirely familiar with guest_memfd, so pleae excuse my ignorance
>> > if I'm missing anything obvious.
>>
>> Happy to take questions! Thank you for your thoughts and reviews!
>
> Of course, thank you for your work, Ackerley!
>
>> > But I'm wondering what hugeTLB offers
>> > that other hugepage solutions cannot offer for guest_memfd, if the
>> > goal of this series is to decouple it from hugeTLBfs.
>> >
>>
>> The one other huge page source that we've explored is THP pages from the
>> buddy allocator. Compared to HugeTLB, huge pages from the buddy
>> allocator
>>
>> + Has a maximum size of 2M
>> + Does not guarantee huge pages the way HugeTLB does - HugeTLB pages are
>>   allocated at boot, and guest_memfd can reserve pages at guest_memfd
>>   creation time.
>> + Allocation of HugeTLB pages is also really fast, it's just dequeuing
>>   from a preallocated pool
>
> All of these make sense. Just wanted to know if guest_memfd had any
> unique usecases for hugeTLB that normal hugetlbfs didn't have.
>

IIUC HugeTLB was meant to make huge pages available to userspace for
performance reasons, guest_memfd wants HugeTLB for the same reason, but
just for virtualization use cases. So nope, I don't think there's any
specifically unique usecases.

These are the differences I can think of between guest_memfd and
HugeTLBfs's usage of HugeTLB:

+ guest_memfd may split HugeTLB pages to individual struct pages during
  guest_memfd's ownership of the HugeTLB page. (The pages will be merged
  before returning them to HugeTLB)

+ guest_memfd will provide an option to remove memory in guest_memfd
  ownership from the kernel direct map - I think HugeTLB pages are
  always in the direct map (?)

+ guest_memfd doesn't want to use HugeTLB surplus pages, for now

+ guest_memfd will reserve pages at fd creation time instead of at mmap
  time. Reservation is done by creating a subpool, so guest_memfd
  doesn't use resv_map.

>> The last reason to use HugeTLB is not because of any inherent advantage
>> of using HugeTLB over other sources of huge pages, but for
>> administrative/scheduling purposes:
>>
>>   Given that existing non-guest_memfd workloads are already using
>>   HugeTLB, for optimal scheduling, machine memory is already carved up
>>   in HugeTLB pages for these workloads. Workloads that require using
>>   guest_memfd (like Confidential VMs) must also use HugeTLB to
>>   participate in optimial workload scheduling across machines.
>>
>>
>> [...snip...]
>>
>> On the other hand, reintroducing the charging protocol has the benefit
>> of avoiding allocations (not just dequeuing, if surplus HugeTLB pages
>> are required) if the memcg limit is hit. Also, if the original reason
>> for removing the protocol was to simplify the code, refactoring out
>> hugetlb_alloc_folio() also simplifies the code, and I think it's
>> actually nice that memcg charging is done the same way as the other two
>> (h_cg and h_cg_rsvd charging). After hugetlb_alloc_folio() is refactored
>> out, the gotos make all three charging systems consistent and symmetric,
>> which I think is nice to have :)
>>
>> I hope the consistent/symmetric charging among all 3 systems is welcome,
>> what do you think?
>
> For the hugetlbfs case, the path to allocate a hugeTLB page on demand
> makes sense, so I definitely see the argument for avoiding allocations.
> Does guest_memfd also have a path to allocate a hugeTLB page outside of
> the boottime reservations? In that case I think it would be nice to
> clarify that the allocation failure case optimization is also for
> guest_memfd, not only for hugetlbfs.
>

For now, guest_memfd actually doesn't want to use surplus pages, so
guest_memfd won't be allocating pages outside of boottime
reservations.

> Symmetric charging is definitely welcome : -) All of your reasons make
> sense to me, I just wanted to ask and make sure.
>

This change is mostly for (an alternate form of) simplicity :)

> Thanks for your thoughts! I hope you have a great day!!
> Joshua

