Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F48C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 21:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F9D6B007B; Mon, 10 Aug 2026 17:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 750706B008A; Mon, 10 Aug 2026 17:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63EDB6B008C; Mon, 10 Aug 2026 17:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A89A6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:06:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 201381A02B5
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:06:12 +0000 (UTC)
X-FDA: 85086592584.18.64B9686
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 153A8C0006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:06:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qdxiCM3Z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786395970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBbGpsBOXqFYnTikH0FoZ8DdjoKWQr2k7+SRpWv9uL4=;
	b=wbcxe+yGEm4Tkmm9dnToL8QISxem1nbS7xnl6ZHJIsK1DOdurQY9e9GC0JlTuzfhKDVAIK
	z94Y1M8aRzl3MWEDsBISEAAfLrUZxnUk5m4izTgMzmjX2MvYdIeHqOqvvXetixW8EPCqMJ
	QmJzBgp6bibfW9syIgi3aBuhkJokivs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qdxiCM3Z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786395970;
	b=Sg08Ndzzp5Rx5TXQclNvhVtwp7m+EcPZ8Wsl0BO39TQWuU0LbvrYLAz9KeOG2OJ7tobVo1
	NT69luJ4LWWWdyNsTHvcM3ZwdBLoABnKt8MEtD23N/GwpiNvtbyta1TJAO9OiTxxjeNwWS
	6I1aD0Z6iEA75ktgV+xzppgAxD22oeE=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso26404505ad.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:06:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786395969; cv=none;
        d=google.com; s=arc-20260327;
        b=bL6DHLX3S/M2Lgl0VIKACCHLVNj6MWoxb2e/06o19IJP84udYK7ftJPONPKbladoyX
         TqBLkRB/KY3+WhFmJ6mQeiAiP/iOJwWnMi1WWPXXlEaDHWcSIhfIY1WSk3GVSLhAaBPI
         4f45ZME5WY7ZSVl5JG8STnD9BbbsgPzAj6ytpRmi11aWXanjMjfF8PbF7ioMfOtSA3kX
         KmjFadiQpKFywtvsZM6jCt56AopBjwlFXsr5kMQO7MYolZjIfByRA5voT6GgRueoxxDr
         sJqrPDXyWpJ7yQElrDp57DJrmY+R6M+0BVY6u7dGw61Qxf1l8/1amc3mQvtNyVp9ddkr
         7C3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:mime-version:references:in-reply-to:from
         :dkim-signature;
        bh=jBbGpsBOXqFYnTikH0FoZ8DdjoKWQr2k7+SRpWv9uL4=;
        fh=Qmc21Tyju+2bSnMxdxdz1N/SqHTk3Mc3IUhmNpVXCB4=;
        b=Y35bCETZczblz1Cvp9Gqbau/xyQPfP+SAaOrkIfOaQms/ewVp/yOPqEW2Zb8QZjTcb
         vLBdYYHfnRpzt9DCU4DC3VKKya3diRXvE9OJdvx5GdwNi0bXbkks/GfASZEu+TwBJ7Kl
         LomDcM6V3SDkK+q9QMg4H6vP3N/gRM8Af08uXZYmivePLr8GUDjmiSkQ9CNIZxugM2ZH
         CELlv6cPSpAxBtQokPfFluhmHEquzmVKdeAxyRY1eFieQzupELh0f3zp3FDfUmgW2F6N
         fxHpZjejBhWin7E7XOwxZ95MnRmiOYtNbqYT80yiNB+GzgGMgJWR/Yzo96pv0w/GF80z
         3A0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786395969; x=1787000769; darn=kvack.org;
        h=content-type:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jBbGpsBOXqFYnTikH0FoZ8DdjoKWQr2k7+SRpWv9uL4=;
        b=qdxiCM3ZO/vN6L5iUIk+63fhyKaogAbN1l4Ad0h8EXQM5Jy25XOz7kpwYzOg9tl4u8
         ZnkDiTMZz7n0ojzi6+6OTpX/vivfH89dkExFfZqvR4gXBBtomB2J1ENdeDIMNpdwuUax
         yOvVLEZTkW2d9peDGs9+FdOevzSJMuZLE21AQpAofER0VCJb/LzRHrQzF7COsm0/O7Ed
         djLB24YZ5fUxwyBnrGu+yaBuhEdM3wHSJ/dDPQLGznsvc4KZ5yG613Tt7NhJB5I54/1S
         URK/MZXWLBXTk6C71h5Fx3sI71frAOOrbWowGyETP3rW9uHkRbgzkzVqTla0QctwU//v
         Khxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786395969; x=1787000769;
        h=content-type:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jBbGpsBOXqFYnTikH0FoZ8DdjoKWQr2k7+SRpWv9uL4=;
        b=OAQDV0amG84zNoBW94LnaAvOKVc9+wq5KbW4E6m5oG+XEvrbMc5dG1cSlZHJHd7R73
         XVFZ09ZsGcyaiwGPZtkquXibzHBYF3ujBeU8f2Fc8ilak1KmKWpvRudxZyxOITKb56KA
         DpLWy+vdGVEN/TsInYm/Pkctgm4DeQ0agdikuzZ3XKh8x8egTReCijS9YTG7g4GyWaMf
         KbekIDNoaJd2WbOyIPGJLx1KA4WE0MuflAd1TVq/4ZgmrQG5L07ZJ2vnM8AWuLCOazCs
         6rNxmM3sE/rgQukmqnDU1uuM/gIc4XwEdrwGRDiXIBVMMl5jNVZGnWx4gE2WXnqS3UTY
         bHVQ==
X-Forwarded-Encrypted: i=1; AHgh+RpSxk3zryNZvnYEGvObLPg4KM4+BFcWUGmF175pSNOYPC3x7rUpm+C6hbXCr26ANgawjGwhrgQXkw==@kvack.org
X-Gm-Message-State: AOJu0YwK9gVIHR3UXxTWuQqC2d2+NEfsY/jySBM8GH+TUHywszzp9PC+
	IOoyPSq57F7l7bbF3ZzxoVnjIvXfQCJQ+BD6oynQKhilnB6KtlWcOd9sfeWq2Ck3k+rZ7zolE+g
	76od6I9L5w3Sx3m91QXfyzDL2oAJRSyhbadGuXn1z
X-Gm-Gg: AR+sD117s6cMyZayBXcZvvdlSbJ6hwgVCHG4b60RJbKEVrIDONyy9fbzlhECe2MIk2O
	jtIg2HeU9nm0guEO9LlQcDG34QCHAKcv1RBeBm1fD53iM+WAC3ZsO/xv9DLWQDXSq0Z3AVdIt23
	dPL0FZdftCRAmZM/tIkdnPrFKNVU2+x+hTL29RRnRfIbudonZL/qmJc8EG2rOnebS6L29tb2nm+
	rUP5WnW7yZzpoF9FBJJWS0fQurhTCISg9jdRh+2I8zNphbYIV0GrkP49V6t16FJT9qv0lOXnO0H
	ikyKaMwRMT+9L+JXAusLkuam/VuPSygHOUtmqS2bUPxmZz0twXMhF0LUZ9fbo4FRohSj7WSDWK5
	7RMVSawMIkMoJ//C+XLOhH151ukQYsPbsrDc=
X-Received: by 2002:a17:90b:3847:b0:383:f52b:d616 with SMTP id
 98e67ed59e1d1-3909d89bd69mr24868036a91.10.1786395967805; Mon, 10 Aug 2026
 14:06:07 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 14:06:06 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 14:06:06 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
 <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com> <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Mon, 10 Aug 2026 14:06:06 -0700
X-Gm-Features: AUfX_myPYbMVlta00ya1-5ZhE7lDWW0LOnyJR-gHZaPeDATx5xIvNNK-iJcLcsY
Message-ID: <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: Yan Zhao <yan.y.zhao@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: hhn6b954s8qwpx3sge46a7qeeqssa8gd
X-Rspamd-Queue-Id: 153A8C0006
X-HE-Tag: 1786395969-822075
X-HE-Meta: U2FsdGVkX18s8rYQbP6cfP9IlPqWLE7TTMuy6XcSsHYuWVhKyMLLOfPHBgD6jr+m2h/6AUpXYaChP77e83xYP7T6sqZTkuBUz3TSAN4hqEvhtqnIvDqjpMEMiE+gS0GXUjXz+z6vdaKZUOTu3OjhVhZtMrOYI+QbiWapH8KakcDqloHLMgYC8S/8g0qTFstU1NgwYRYbRlcYbXEdrltLGQYd5RoYlQxBFeTgGA3ta/uuoQ0UgoMG0ghxzfdCLLt1B/H0Kr+4rLwC+BDUVuUb+NtTMkp1uPkLQS0LlrzFL+pjs2u9nCZKvLtwrzQ7h1B8lbmU+/fdOZWe6NS74m26OAZIhV+zUiwkN4k0dv8RvWTTpnb3hCnvxLZceR//btAJyXemtjgUASs0iepVvV6E9TiQrhtgGcan4KRVuJ5KCKvMBUYGw28LRYiGZp3hFqLwFODuOSP19hLuMudUhSJ1UrP3NIU2rscgbMw+1itpj836IrhEWAuE8XI8P4LZoyt7csEmTRog/x8nHfCqZztUfDWluaE3d+Y0BIZN1BF9MsKxome+aiUsW5i24H34tLZiluwwxJDshVutCcFDTG5U6mW4Fvwa7dmCdYT7AQISLGFD205afgqp5UZS+3VIT0z1N+BA/Inyn/mHzFqb3F/EZzDr+zzm2zir3c45f7sDLC1fk6ipsqmkHr9FLiHK+mKvt0fpcnlGjJ7R+cYgGjsfgvaAB/1r33S7vMZ3W5hMzB/XhpO/D6sX9KOc8u48eDBTRCCalJ+J8yNs1iOkpBx/Q6htxW0TlzD3qldwThFKH82NmolgPz3WeNK+mBUmgus/mGxVRlsWbvgWW0VtbgulOwq/fqSANALPbrqxa7KW/BtSIXUBg2wCSPgDnSxW8SXcwQ6/kmwqg16WSvATVknelOznU90+MB3L4Mw2PkdgcFd/gm/txJ+LOYD65Ul0HqyXSI2OftCg+9FNMVuPBL0
 kH/PJL+X
 NKQbhgrVeF6OewvHDOVAmi22DWM+1TwniM+9SEltguoZjIJIYdft054tkP05+A/Vl1KaOSNQ6zMblfv6PM/GWGfXTErd0BkgOG4uHThALtZDXVbTuHvHwOyo2duz8/0XsASRdjXzfCT41wDt+t7LToWEGaM6BWb+GZAmI539TV/L5/UE2WokC9jyNyjNlzP1Ez9fEKQUwWOtyycqIp06uam71lt6tBRuLFlkeVSdxsTvTLm8xZ4JNy3RuRKJ16nnoexOIxbCqMUPrTvqrNIrbJz5w6UgxMASZegHLLnyVeX/BTUGyZPxPPBJj+2kLfs9KnNCwUXmIf+AMwH1XoLh3qDVHCKLepvyOl4zrwrxpZnZp/eV41aSonHYLm1GfUT/Dr+EsrmbTM/LE/2ZIq5pgQDBUJ571DTsShKtH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

>
> [...snip...]
>
>> > @@ -542,8 +576,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> >
>> >  	mas_init(&mas, mt, start);
>> >  	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>> > -	if (r)
>> > +	if (r) {
>> > +		*err_index = start;
>> >  		goto out;
>> > +	}
>> > +
>> > +	if (to_private) {
>> > +		unmap_mapping_pages(mapping, start, nr_pages, false);
>> > +
>> > +		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
>> > +						     err_index)) {
>> Note: conversion failures could occur if another vCPU is attempting to map a GFN
>> within this range.
>>
>> CPU 0 (setting attributes)          CPU 1 (attempting to map)
>> --------------------------          --------------------
>>                                  A: mmu_invalidate_retry_gfn_unsafe
>>                                     filemap_invalidate_lock_shared
>>                                     __kvm_gmem_get_pfn ==> folio refcount++
>>                                     filemap_invalidate_unlock_shared
>>
>> filemap_invalidate_lock
>> filemap_get_folios
>> check folio_ref_count(folio) ==> Not match !!
>> filemap_invalidate_unlock
>>
>>                                  B: read_lock(&vcpu->kvm->mmu_lock);
>>                                     is_page_fault_stale
>>                                     kvm_mmu_finish_page_fault ==>folio recount--
>> 				    read_unlock(&vcpu->kvm->mmu_lock);
>>
>>

Thanks for reporting this!

>> Retrying in kvm_gmem_is_safe_for_conversion() or moving the invocation of
>> kvm_mmu_invalidate_start() + kvm_mmu_invalidate_range_add() to an earlier
>> position does not help as long as CPU 1 stays at stage A.
>>

IIUC CPU 1 isn't blocked by a conversion so stages A and B should
complete fine, and CPU 0 would already be retrying for other reasons
anyway, like speculative refcounts from elsewhere in the kernel, so the
conversion would take longer but it'd work out.

Is that understanding right, that this doesn't completely break
conversions?

>> So, should we avoid this failure?
>> e.g., by moving filemap_invalidate_unlock_shared() from stage A to after
>> stage B?

Not really sure about this, how will control go back to guest_memfd
after the fault finishes for guest_memfd to unlock the filemap?

>
> Or what about having KVM always treat gmem page as non-refcounted, and have
> kvm_gmem_get_pfn() put folio refcount before releasing the filemap invalidate
> lock?
> Below patch is applied and tested at the end of this series.
>
> From 8c2f29bc15bceb6a8fa103cf2585ec11354fd74e Mon Sep 17 00:00:00 2001
> From: Yan Zhao <yan.y.zhao@intel.com>
> Date: Mon, 10 Aug 2026 06:24:52 +0800
> Subject: [PATCH] KVM: guest_memfd: Return gmem page as non-refcounted
>
> Have kvm_gmem_get_pfn() put gmem page refcount before releasing filemap
> invalidate lock and return the gmem page as non-refcounted. This avoids
> gmem memory attribute conversion failure caused by temporarily holding gmem
> page after faulting and before completing mapping.
>
> guest_memfd always holds gmem page in filemap cache. TDX does not increment
> gmem page refcount when having gmem pages mapped in S-EPT. Additionally,
> as gmem pages are not swappable, setting dirty or accessed bit is not
> necessary. Therefore, there's no need to treat gmem pages as refcounted
> pages.
>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  virt/kvm/guest_memfd.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 2115e73e455a..e357b4ffa777 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1332,11 +1332,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  #endif
>
>  	folio_unlock(folio);
> +	folio_put(folio);
>
>  	if (!r)
> -		*page = folio_file_page(folio, index);
> -	else
> -		folio_put(folio);
> +		*page = NULL;
>
>  out:
>  	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
> --
> 2.43.2

Hmm going with the above CPU 0 and 1 illustration, if instead CPU 0
truncates the folio and the folio ends up being freed, then KVM's MMU
has a pointer to a page that is already
freed. kvm_release_faultin_page() is passed the pointer to this page and
will dereference the page.

