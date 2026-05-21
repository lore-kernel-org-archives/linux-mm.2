Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD39CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E58F6B0088; Thu, 21 May 2026 03:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD726B008A; Thu, 21 May 2026 03:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ABDE6B0099; Thu, 21 May 2026 03:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07CF36B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:20:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FDA312056A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:20:16 +0000 (UTC)
X-FDA: 84790578432.30.F02E1E5
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id B144B1A0005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:20:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rMKcrBNa;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779348014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lV/LRyXdVcEtETS6N6JX0KnOiUE4cogpgAqkVQgk4U=;
	b=b1CDYNhcOSxmtALUHyNmKzdyLZ4DfyrMftBdToSa2ROjdlqE8WOHg6VEzwWi6+8ylNh93w
	Zf9gvx4z3ZoworACYcNNU30E3RgBnE1yClt/Bhy+vgqWp8DS+C2zpAalia86ey/d/W1LD8
	DWtIjrkSi8HGSPHsdpPFaxuObSRNsCc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rMKcrBNa;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779348014; a=rsa-sha256;
	cv=pass;
	b=KAYl/T2Q4kuEpwFaoWlOicrXab2AFfHzlwe3Efy7jqu++wp2zQhyqo+L2g6SLiZZvOWd1O
	wbilYABSZajO1IZmKeXx0o/fo09ZvXEZY8lGykL7sCImZmZkGjw9nh72flLusgdjgPWYYD
	ENV3CeOopUwo/+Sgeur/6rEYvn/ZNJo=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50d6b393d60so8581cf.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 00:20:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779348014; cv=none;
        d=google.com; s=arc-20240605;
        b=lHAmQrhb2FgAMhCPPtw6/o6EWhwdaAtzq7rxQAYrdaIe1kI4d/jzIZChuzz1oZmaex
         hXlisgq+wi4DV8Wxda3phLU7dRV58pP2j6ALJS1vGxGk+xxB/j0K0FS/onx4u9Z1l3vg
         OVsIXYqqcgJEvamBa/fUx2D4pxhHMd69eso9PkeF8yNjVeNDHZRV5onCqv98cznIqKsv
         ivZiVKmzTl3eGG1E3JKK6IWEnFFhEyR4x46dTeFvChsGM8YSfgx0h/w9soj+I1E1usUp
         R64IlejimDE0FnvvsyCsBHd0tZWNGuzDJ9SgwFalwyvQ3xD2kSpr++zvy0kWjX6N6gcZ
         cPDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4lV/LRyXdVcEtETS6N6JX0KnOiUE4cogpgAqkVQgk4U=;
        fh=Kf7NJKnJh8dxxAzR68xOT+YkRVrCxUv0Hq8nYDmxtI4=;
        b=PCHt3QbCD8oH3GTTOpee/HUILui1PNMWcTLAnyIalpgbzBYJO15MmcQ5/++U44B9vX
         e7y5ZHSUVB7nhguH+TAmQF8e1uNYDsMzzxbp60ogbmWsHfFc4CFaalFUtNczZOwZob+V
         mZ0SYPmF0XbXNfcLMoBmY0OsiOyosZnqVIJaXdIaYSGgJTQCqs9Wb1t6q71Cb8gV0Ddn
         KCRTHmeLzJtCQ7K8qP/q6FX6BOlBjEgEERk4UxMqZkyCSvoLfjyHVUCTcoSXetbzfYqB
         l0+mW1pDohfQKKs3onWrMMlqjqWSg4mk2lDxhhaf5S9SJfR7uT1cOGlE0RQpZUHq5O4D
         ZCkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779348014; x=1779952814; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4lV/LRyXdVcEtETS6N6JX0KnOiUE4cogpgAqkVQgk4U=;
        b=rMKcrBNa1zqEFV8G3b0yJV1UI+ibFvpU94Z3QdlF9oW0mIUtqlaZWBNzqfWYr2JO+e
         DNmlgUu3b3mwrr8vi8cp0tHYme07ZspL+z6l38rVkfiLnO5GaCsDfIkGBTHClUIR5mLN
         sJ4TtcG3s+LM6De6bi6q124g8cTFBDaeyIby0p5+DoahkHmX8OMAj2Ydwd9RR4Kvfm9P
         hUCFqfNAGQgWVPiSeYD/9jj2HILDDPRDdUjrhui0Eo3tFutxM11kL+yogPpqFJ3sMtEy
         fNQL0lljU/Nme1S7c+Ub4QwLhtG7Mq/o/fYB7V2LZBGc5xxYCl0cOPYJ2KrCYx/ePauQ
         puDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779348014; x=1779952814;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4lV/LRyXdVcEtETS6N6JX0KnOiUE4cogpgAqkVQgk4U=;
        b=i2h993ptq4wdWB2qXSO9+pG33g7DT1gxti0gbX7LmCWHni8H4NINaBteO3AjnNT33/
         f9wALM9gEpShyMks4ow4wcHm1CNOKP7TZ6JHZtu5+L4rHz9P7GPzeV/lkQQwpzwu0RnG
         /n95r/zeIGxrxtboyhHcqC28QMkmGdIw/5mVZ5pv8SnEE29rtXzaSCFIoSKmWmFSvZYs
         65z5XKrv9Ty7cQ1ChwoZvFB/Hrit0ro3k0+Nd1Rqvx7LrhWWi+wY44tCD0M0sdF5kXXZ
         P7XZiVbipFuVkQkOTSJuUe0pbLEFMdnPpWCt76xKXJ6X+8jLex4tglRhAjntHbSLQpzp
         RBVg==
X-Forwarded-Encrypted: i=1; AFNElJ+xjPWAmStXmVHTvGdx4M9iQmRrEVR6bw7hco7Ycms41R/DY2jLvWnsio7GBN3yX5+tfZZ0p6mRnw==@kvack.org
X-Gm-Message-State: AOJu0YwPC6Z2tGmrXjc6LU2OnMNJhm8eEEKH09+88b4Bbnfl9M/jbT5o
	JlPKy0PUi6OIGB95lxffMzxNNPwrVjaAqZdk2I8g/t654tWg2jIoOCU/O1sWky+rflppxzOPw/k
	mSGJk4mJ7EMOEK+XINLoe3XA19WqBM/qoPQkue2fU
X-Gm-Gg: Acq92OFmC4EaE0pTu9tcDWO/0dKiX8hqsUhdG3ptlK3IkE25Bzt637diddg0pcGwmwW
	9LDadPiC6KjvH9BqOiZJoHxtgrrHTHdMLAstD+aABffq3dLjaIJMMFu0mQvDnao+3ON88qVVa0D
	YPDy7d0MjY0NskixxAUkDsH+YiJclGA6ZXDKjF/KhrpgfwAdbTmmrgrCJFyO7OxdKcgVjro4pKf
	R5dF9FSfrJ+ChVzLJUFHknCSjQZYin0LGBjUzM2TRRugAMJf3QiekrpLZ7UmA97mMLGc50794SZ
	JXzd2rtzDy0wOvBq030=
X-Received: by 2002:a05:622a:8c09:b0:50e:41f3:6467 with SMTP id
 d75a77b69052e-516c545d431mr5347341cf.12.1779348013286; Thu, 21 May 2026
 00:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com>
 <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com> <CAEvNRgGQvMdDmVfbk42EY_PGN0ybTp-x21Zj+pg_X1mk9iCRtA@mail.gmail.com>
In-Reply-To: <CAEvNRgGQvMdDmVfbk42EY_PGN0ybTp-x21Zj+pg_X1mk9iCRtA@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 08:19:36 +0100
X-Gm-Features: AVHnY4IfKawE844Bbti7f163iVDDGQdLfAc0aSSibjPNKnZdr2ZvCDCMhO5buRs
Message-ID: <CA+EHjTzLCD-dU-euZKgzwyEr2ecPqFDNutcaHm2fCDGA+MHVXA@mail.gmail.com>
Subject: Re: [PATCH v6 05/43] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
X-Stat-Signature: 8nog99xjtkkk741qo1mdxioubnbip48r
X-Rspamd-Queue-Id: B144B1A0005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779348014-659863
X-HE-Meta: U2FsdGVkX1979ApFQ7uJxOYkvgDiNnyVp8Guh6GINYrTz5Qzp3E5mHtWSUbkP9z6bFFiUGYZY8ZdOJRlFmDKcpetO2SBBwvWTqxRQHX15UdDKhDHzWDpcad0gChXOxxpfFN2T23TPQZ2FVSSapdec5l1RENlkOCqhnyCQSPgH0OPATTNBnEPYsZpLdnCLwdddSV+2e4P2DLL5vNQxTfD88GjhU8HPwayPkzZpmiQIN1QTIOrgN6X56wMEFcumc6phWdUbdieKm3qfiSg1/k4fKKkMmrt9G+yCwqJH8fuCE0a8XpqMQFEcRk0Rr37wrfUqRgkIhLs1GsF6CZjqzw4XRH7Tq2ulAQCCfe6e1TWOkxEKU2XZx2Wg6IBm59pr+3yqdz+/CJzRVOcdJh7sUW/Rod9AD+n7o+qSD9/tYbAIXM0J8d5WVUelZzdGAkns+t9CmMrUP9gZmGqUs9RB7PV0RVWsYSwQpD4r89btFxOMzCrWPUaYX+MTbT0Vvcbvdkzv48v7we54bLqtBTSZUUPDiUtPI4nZZxHJ0IoUZElVS174YO6/ukKm0/IXPxqF7N990cIxaY6cGVdYovQ14DuchiPrDNV9EPuNG38f4Oe/H18aI3NaXxmvFvyy57OdPaxXpIiNUc39fKOUR1O3TDk2lJUZu8F60aQrY3HeqCh+HQ7jNr4wcLczP1FjyjodmGq3huMe6S4PoZ19corforcRz9ygbCGlGJjBIxu/ffYp6mumYitOPdeZSOFKqjE2ZDBpGbp8/Bb2N7sYslGRE2JpXz2+8CaW7PhjkyHsdjgosu0+MO/KqbM3zRRjx6j1AET+XCCaLQOj5qNpt2gEdTeUFMopWoYkXhFa7iebtaWyW4miSIO6bHe75bE3bQGxvXnna+M42lwbQ70YWeEwsH6rHHMbh0GJt8RTcCYW+3g/5/vz/w/OmPEx9mUh0iPFnfVCap23wF83+hzQBKXW5U
 9CzKZ3KS
 brsCOsFMaZA0lAC96tc4pWeFT0uYDikJeAY/2Z21+FZi73avQaYerHc87u8QjvcU6Y1CKbiWgqq6NomF551YhMhEnDIyIljr7+8B8DTQycAhSwtit2jaAXjerigPOKRK+77DPm+zvm8npbRByIfRBKftGomvNp5ttYEhsxbWrSScf6MM5xs+HkE/ncJulbN9cYIEoY0yqI2hsge0JNuHPCLzYKESiXvrgq5Q2UN90v2pCk/uuAMGwtDsk/mlfg0+a0v9bwM/4zo8/yB373GC4Dthv5Fhjto2PnipaefVL40bI/8FCli/TRvj0Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 at 22:44, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> >
> > [...snip...]
> >
> >> +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> >> +{
> >> +       struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> >> +       struct inode *inode;
> >> +
> >> +       /*
> >> +        * If this gfn has no associated memslot, there's no chance of the gfn
> >> +        * being backed by private memory, since guest_memfd must be used for
> >> +        * private memory, and guest_memfd must be associated with some memslot.
> >> +        */
> >> +       if (!slot)
> >> +               return 0;
> >> +
> >> +       CLASS(gmem_get_file, file)(slot);
> >> +       if (!file)
> >> +               return 0;
> >> +
> >> +       inode = file_inode(file);
> >> +
> >> +       /*
> >> +        * Rely on the maple tree's internal RCU lock to ensure a
> >> +        * stable result. This result can become stale as soon as the
> >> +        * lock is dropped, so the caller _must_ still protect
> >> +        * consumption of private vs. shared by checking
> >> +        * mmu_invalidate_retry_gfn() under mmu_lock to serialize
> >> +        * against ongoing attribute updates.
> >> +        */
> >> +       return kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
> >> +}
> >
> > Doesn't this imply that all consumers of kvm_mem_is_private() should
> > validate the result using mmu_lock and the invalidation sequence?
>
> Let me know how I can improve the comment.

Given Sean's context, the comment is good I think. I would quibble
with the the "_must_ still protect" phrasing being a bit too strict.

Maybe just soften it slightly to acknowledge the exception? Something like:

  * lock is dropped, so callers that require a strict result _must_ protect
  * consumption of private vs. shared by checking mmu_invalidate_retry_gfn()
  * under mmu_lock to serialize against ongoing attribute updates. Callers
  * doing lockless reads must be able to tolerate a stale result.

That aligns the comment with how KVM is actually using it today. That
said, this is nitpicking. Feel free to use or ignore.

>
> I think the "consumption" of private vs shared here actually means
> something like "don't commit a page being faulted into page tables based
> on the result of kvm_gmem_get_memory_attributes() without checking
> kvm->mmu_invalidate_in_progress.", since a racing conversion may
> complete before you commit.
>
> kvm_mem_is_private() is used from these places:
>
> 1. Fault handling in KVM, like page_fault_can_be_fast(),
>    kvm_mmu_faultin_pfn(), kvm_mmu_page_fault(): this already handles the
>    entire mmu_lock and invalidation dance. No fault will be committed if
>    a racing conversion happened after kvm_mem_is_private() but before
>    the commit.
>
> 2. kvm_mmu_max_mapping_level() from recovering huge pages after
>    disabling dirty logging: Other than that it can't be used with
>    guest_memfd now since dirty logging can't be used with guest_memfd
>    and guest_memfd memslots are not updatable, this holds mmu_lock
>    throughout until the huge page recovery is done. invalidate_begin
>    also involves zapping the pages in the range, so if the order of
>    events is
>
>    | Thread A                     | Thread B          |
>    |------------------------------|-------------------|
>    | invalidate_begin + zap       |                   |
>    | update attributes maple_tree | recover huge page |
>    | invalidate_end               |                   |
>
>    Then recovering will never see the zapped pages, nothing to
>    recover, no kvm_mem_is_private() lookup.
>
> 3. kvm_arch_vcpu_pre_fault_memory()
>
>    This eventually calls kvm_tdp_mmu_page_fault(), which checks
>    is_page_fault_stale(), so it does check before committing.
>
> Were there any other calls I missed?

The one I was looking at was `sev_handle_rmp_fault()`, which does a lockless
read without the retry loop. But as Sean just pointed out, that path can
tolerate false positives/negatives and relies on the guest faulting again,
so the lack of synchronization there is existing behavior and considered "fine".

>
> > sev_handle_rmp_fault() calls kvm_mem_is_private() without holding
> > mmu_lock and without any retry mechanism. Is that a problem?
> >
>
> Sean already replied on your actual question separately :)
>
> > Cheers,
> > /fuad
> >
> >
> >>
> >> [...snip...]
> >>

