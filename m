Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BBCCD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98176B0005; Wed, 20 May 2026 16:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22466B0088; Wed, 20 May 2026 16:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3606B008A; Wed, 20 May 2026 16:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 873886B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:25:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5A1BA03F5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:25:54 +0000 (UTC)
X-FDA: 84788929428.20.E2A8C51
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id D4B182000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:25:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c43UYfrp;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779308752; a=rsa-sha256;
	cv=pass;
	b=AA37CHvIyHh34wAviWqSzau1FZdRAH9Er/C7Torpv+Lg+svRFBhb1Ebc5kAS48PPIa/VC3
	rD7hNZK12UBTY0HslcToydO7VWexQA3AAjiSHOXHvEj4Z0wny8CMbWkCxS6SuabJhc8snu
	W3kgSwQ4otes+r5yxlc2kaqNkk6THks=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c43UYfrp;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779308752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANitp46w7gSSv/gOMNKZIor35cJdYj41rSqFN5gAzAs=;
	b=Zr3uDlszaTZJiddy+ew3Wt5172KMxFEvhUSV4dCSjocnqRxZvTfFp2OjmLdLNJ9SPeqyXb
	D6hD5DZ0jX8/DNh6T3/NuSUkKQtJQwmf2OlGZJCynXFfE2wk7XPFY9nHwCfg6HrD0IRQB7
	XDd05CBxM+Zrxn4RQkvuMW99uIlo/TE=
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-95f2b0bd920so4299497241.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:25:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779308752; cv=none;
        d=google.com; s=arc-20240605;
        b=R9Aj7vQlhU1zxpsg6VG4pCkXBiRnHCwKDiJb5NBYQGqs5kY4DbkHr4QQigUPrEd/eJ
         nkpzngojdymaLBrPfgfBANspq/1Ob9vywNn9CJiuTIUie9ZHvzPqt0XLIfhqxAf3WK/n
         OQuLYJVflHx/epkVFFa8amuSbpVT0Vu7fsjeTC8KH76fZxncUwW3sr4+VFIUaXhoEE7k
         GwvyPDSKZ/GhK9KzdrTMjRms8dCYAyx3CCcyPz0QorO6HBudvda67RrN23yKGDZPCPbk
         G074/wSI0K8BYkZ15Y4x79CYKRwfbb/4Tx23SHdeegw8q6h/lFmUZYNMFN899+coOz1X
         nbjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ANitp46w7gSSv/gOMNKZIor35cJdYj41rSqFN5gAzAs=;
        fh=7kDTUmX28hCbcXo4Apt1E/0J2342bP8e8jD7VREQfAs=;
        b=h/wwcxlwOG+6bQIAC466jflycVOoT/3/2WmPDQQqOOSuBDOjcCX8O5eFNyuxMZ3X2u
         3QVR90L67vSof45iGqItPRai2uMjW2yd8SiA0vLKFyz+j+LNOSNPpqgPjqsh3wZGBr0n
         2V9cIT8Ij7VAFe1FLPqs7R7k1KtB/uhk6ef7b8ZSF03tOzRhXLyuN0Iphz2Q6HjZc0sb
         NimEuvN2Ullxo7HJCX63Enk1IoUkbkNsLYtZwn+xh9CkLa/2Cfqla8iD/7XOoU15o4QR
         OLcE1qPuicwHAckfGj3p+Y7fNKT9GEU5qj8Kvjo8Xaw0v0z5g+/mu1FQDyUw71KLOcKH
         UL4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779308752; x=1779913552; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ANitp46w7gSSv/gOMNKZIor35cJdYj41rSqFN5gAzAs=;
        b=c43UYfrpQULmzZDnx3DaiyaB6TwK+p61BP54+zKawjONNFZfZ2H35aYk8upWf2OC1I
         Ru0mOXBJrPWpsJzmPQ0KRfLbDH2a4l8ACAjA66Z+gLYrqe7sS1rtJF9Y1o1UcALSDXfO
         4hwJm56CUeo5Auji/SKXRUdNFUIex+atLXdiEz4+wBcLl1cxqhe79NxAdGmRfersr41p
         n2CAt4bf3Hc+SYJOzxsnwUdiESmns8+mHuRaHtvFc+4lrvC9/x2qFutKrMOyes7JkNQx
         eVhUeJhB+tKTlNqTrEgSltDe986b1qd8tB8g8HOgy7Z1oP7cuTqVHNYC+9TX00JllbLR
         GonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779308752; x=1779913552;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ANitp46w7gSSv/gOMNKZIor35cJdYj41rSqFN5gAzAs=;
        b=hbt6B59BEwogrcmXoo3VkSiiJWrNRQSHLK8ghfdoaOmQrdRxbA1+s4yYFvLdjXLHFl
         3QM1J6WEO15Ycx2YWKx6DHdc6hhxuUS8ZyYepW+KSRe8dKtYoxL3XMWmOryTawY1ojUc
         8tKSrdvjvYhw2jbprssJttIKMl0ieoNMLRD0oNC4lACo9MNZZtpFFRNJjLw9kia4NZQ8
         2Ehk0gnP3/DmRznbMarKPYxU/mb5mupg7ofghbBtic9dujA9zDE/iIiRdjyw0FFKubkT
         nTDkhbn65ISub1HevG7ldKcyglAf3IraOErnntihWkwvtqsSnWWWtWo2zOmjZeEB4RlZ
         YjQg==
X-Forwarded-Encrypted: i=1; AFNElJ94KTqPdmPf9e1PRaMGIuyTQmI/XMPWMvtrdYgxItUlFSv+T3ZHQ5stpi3EpkWji4jipjD0g1K3dQ==@kvack.org
X-Gm-Message-State: AOJu0YyCZrrMV5ewZve+ck2PVl6ddkCllEYzPH6VNEcaLZWdvwnTbVxx
	V2baHC4GV4PItJsPvZfp6nASoX0kYuYE7ISU+yzQddW2oN6Ezipl1YFX+6TYIa11XC6fFgmAWM8
	2j6LetrLm6IYJVWW2e6Ji+RJ1LXErs+4EUDYoNJRw
X-Gm-Gg: Acq92OEUWzBs4WRXOjXBMvWf4xGNxR8tsBE3LIXxpiQR7vFUUE0qpQYDz8zIWg3jmic
	PhxFehimT4wKOGPcGSRcSlUi4mjsYaDpqtJ12do3rxY1sEcPBN46755xC2FIC2v/BufD8hU4HV0
	JoGFso6OhaF5aRc5f0e+GsVVTuemcSKvWSkd5mehf5ssG1ssfFObwosigfuyI6R8agwYHeRmc8O
	N5Gs4rQ9hLo3w6SzapWI0X98acqV9yyGHwd/61OMkT0vtfXBy3uBMmfQ3Zfr9r1T6bTvvJPvQth
	EFCZc1NMuzpSybcuaxSnJf3vqvbnMQHcqmSkjrrpWhHOmCEiXK+xYpC+hNTMQJqL8Zhw/auFLKY
	xkCAo
X-Received: by 2002:a05:6102:2583:10b0:631:a34d:b671 with SMTP id
 ada2fe7eead31-673bf885fcfmr10043137.5.1779308751281; Wed, 20 May 2026
 13:25:51 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 20 May 2026 13:25:50 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 20 May 2026 13:25:50 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ag3DawWCcrpCkD0e@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-6-91ab5a8b19a4@google.com>
 <CA+EHjTxvLU4XDPXDXYXXWJES1OFQgN8VTRLMgCCNMwBE6Hk8tQ@mail.gmail.com> <ag3DawWCcrpCkD0e@google.com>
MIME-Version: 1.0
Date: Wed, 20 May 2026 13:25:50 -0700
X-Gm-Features: AVHnY4IBlIN9DzOr96NZ1ZZdFo1tnLv8pC5ZAKQh-hjUOng4U7q5IXabnxVwwpI
Message-ID: <CAEvNRgGHHkvfJ-mn9rfDvS+_1ht08YatFWo-Swt+5wFSPnC9Nw@mail.gmail.com>
Subject: Re: [PATCH v6 06/43] KVM: x86/mmu: Bug the VM if gmem attributes are
 queried to determine max mapping level
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: D4B182000C
X-Rspamd-Server: rspam03
X-Stat-Signature: kkuywunozkd7d99wk3z6g69ik4j1rfib
X-HE-Tag: 1779308752-261748
X-HE-Meta: U2FsdGVkX18ccsZhaKphqbVUpfF5XhRlKHTqMNIQXqLyo4XUum0rOmIpbSQBo+9BVldcUSzTxqva4KaWDZND0ymaz+gxolw+I21hdNyHqaQhVrZW052PO00jO6soVAIUIXvSiV42e+ezuVMag1SmiXbwz3kVcydHuzBYV0FR00JsBX/vgCu4o52x9KpOt4oFtDf9pkVVKv0J3lNHTVJWoILGLHPxlRibzaojIueuICoyUvFoFDdNWokdYulVhbFgGq7qb92zDxAJjjdAxCY5d8xU1vBCZo731Ugcdiq3cAz/nJD0JMZWMGYFMQPGO2gac6L9YDREbTH1i23Xl5RzSN+VGYZcED/nbi4GHLHpsJObVorhnu+7sYuNFZfTmFfM/p6g0ql/TZCQNMLyXJdWM8meDlOddW9YcU8oMhwt6w8OdWidigesLpaYM+DB2qA855E+2P9snKicPcvQ3XxQHhjZ/Y2glbP6ffDUQCho1a7BZU8daYB6oyTveK1f+oEwPMFEjQJUYotJxl2KlpDoH5aRWydRBY26tMY1xqsAsWDwGgDYE6+SvgRCyWFoJiB1vTlGacwdaApM00q9jnnjzTedtK8KA/v+5iCPZn0nygnv1787wQ11PAFX22aaslc6RJYbJLdqbvtLpHqD17NY193UHg361AVEEJN3nsFglNhRzPvSOMf36BvsbvJ+Gy/g9UFUOnMxlTNbYNuWSCiAktmd6Ik85BaOB3s0lF16SFGLatDpinI7DDvJU70IMTYFE8pHg0WxmFao8xY632n/5jywRjsG7KYFoahtup6CeIz9co7ObUwdydlxw8hxAAGvMZwFeFROhOQIlHllrDsLzHfzvcYynKSTbr4jYnK8DGLcvAAjxEebPH3940zbRSKnBdwXt+xl2LhO49Nsg4p8id3dWK4EnbNZqLCeSI+PtzvCw9o/kKLVzhP3Cu/h9E9V1dBppzBCXug/1qb8C2N
 xtGAaa/M
 XPz0OGZIH1RH9JPqKPOZQcV0jCWA1GV9udTuXM3YTWrUWS7AcbW13KmttRaNl61XLU6sGui34WF7U0PL1U+xYIPhkCwuGWkUzF7ohZN95BlnrGh+EEwqQ/x2PXP92s4HGkn4DKiPXk8/mInYWAotf8p2A08ulJ2rSw+y0ZL7pzK+uB6zj5V5yk3PTm0WIWvwT1lhlVzfW9Ic4p9jZgEWG+ykSDltAiAFk14hphcgfPZWaJMm1wehMCMbMeXZ4YhbokGhmdZVic68e6qIg1FC/cQGG2puZgNAsMwkCwLJoxupAPdTojypKsC/UqODLFTV1NpKTKcvLZV1bcwtlC5ISbeR2otN2VGDcwSUmKLdyQVatGhBFbhlxQi28psmX55WMs1Ih9XOUHiM/FKAPcLxRwWJMCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

>
> [...snip...]
>
>> > @@ -3357,6 +3357,15 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>> >                 max_level = fault->max_level;
>> >                 is_private = fault->is_private;
>> >         } else {
>> > +               /*
>> > +                * Memory attributes cannot be obtained from guest_memfd while
>> > +                * the MMU lock is held.
>> > +                */
>> > +               if (KVM_BUG_ON(static_call_query(__kvm_get_memory_attributes) ==
>> > +                              kvm_gmem_get_memory_attributes, kvm)) {
>> > +                       return 0;
>> > +               }
>> > +
>>
>> This directly takes the address of kvm_gmem_get_memory_attributes,
>> which is only compiled if CONFIG_KVM_GUEST_MEMFD=y. This breaks
>> ARCH=i386.
>
> And this bleeds guest_memfd implementation details into places they don't belong.
> The right way to deal with this is to use lockdep_assert_not_held() in whatever
> code mustn't run with mmu_lock held.  E.g.
>
> diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
> index c9f155c2dc5c..3bea9c1137ef 100644
> --- virt/kvm/guest_memfd.c
> +++ virt/kvm/guest_memfd.c
> @@ -547,6 +547,9 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>         struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>         struct inode *inode;
>
> +       /* Comment goes here. */
> +       lockdep_assert_not_held(&kvm->mmu_lock);
> +
>         /*
>          * If this gfn has no associated memslot, there's no chance of the gfn
>          * being backed by private memory, since guest_memfd must be used for
>
> But I'm confused, because kvm_gmem_get_memory_attributes() doesn't actually take
> filemap_invalidate_lock(), so what exactly is the problem?
>

Ahh I can drop this patch now. kvm_gmem_get_memory_attributes() used to
take the filemap_invalidate_lock(), but after Liam pointed out that
the attributes maple tree should be using MT_FLAGS_USE_RCU, I stopped
taking filemap_invalidate_lock() and forgot to undo this.

I'll wait a bit for more reviews and then put out another revision
without this patch.

>> >                 max_level = PG_LEVEL_NUM;
>> >                 is_private = kvm_mem_is_private(kvm, gfn);
>> >         }
>> >
>> > --
>> > 2.54.0.563.g4f69b47b94-goog
>> >
>> >

