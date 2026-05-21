Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D096ECD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429BF6B008C; Thu, 21 May 2026 09:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB136B0092; Thu, 21 May 2026 09:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1596B0093; Thu, 21 May 2026 09:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7BA6B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:31:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1AB91C0217
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:31:18 +0000 (UTC)
X-FDA: 84791513436.20.794EE92
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 18756A0002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:31:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tzz/ANqU";
	spf=pass (imf15.hostedemail.com: domain of 3IgkPagYKCMc5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3IgkPagYKCMc5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779370277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55Qyjr301rCPWrgG1oq6BJ9BiVpqhO1a4dUCIfsketY=;
	b=RdWbcS31lbICuq6jinoa56wEHywNqVZAhfd/YrZv5CPvK9JeULreuDELZ6r6lnv9ugTqiN
	6NXB2SYSHQ6DlEsSgpTMBL17bWB/SLaIxdiqBVkmJJ0shRqwCucZmKzRUGPVlxK+aJuwcm
	mqTI8+QBqyLe51DMfJ0fMnOyJYV2/s8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tzz/ANqU";
	spf=pass (imf15.hostedemail.com: domain of 3IgkPagYKCMc5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3IgkPagYKCMc5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779370277; a=rsa-sha256;
	cv=none;
	b=DX9/McPXwhNsN/9KI7YTLy7neZLLUeK/9GQEcVc46/5/GieJIRvtj98+KwaPi9EYY/JuzN
	RkzFZ5BeySKj9dSF9Qljmp0R9IiXGq6mApMracrtgICuGoaH+0XXM8OKYR1HI47V2fITC0
	RnvZbqStigf5L86/8THwHq0M1pDHvl8=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f6b984b3aso3018352b3a.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 06:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779370276; x=1779975076; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=55Qyjr301rCPWrgG1oq6BJ9BiVpqhO1a4dUCIfsketY=;
        b=tzz/ANqU7KQURnFvxYZjaBgvFM7GCO/jnnPG9efHxQ7Ts7d5C5nSHz3qZyyN2B7A9g
         1kPu7Wh9xl05i0pwA/j2WbIu1eEhBYYkBjZTUjDf9Oj9XGketxc/7FO+50eXtAbMUD7/
         t3DXuMSBsLHDa4k05TDlMp2ku4HMyT4ZkcsAiNkKIgR/jzUiQoX7bH78CIqc5Ac07ifm
         2/iC3erchQlc2aAZUVCjlAoduLrKH9Z5dVBcoroZ2b79goFA39qmcqCTNS41EDGZzd+u
         /nnWqXXE6bxWGIk9+wRHjcD6is1/l3iIjeRMg3HUYEaFEfgLuooyRzl7jyyifuERN2UI
         4b9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779370276; x=1779975076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=55Qyjr301rCPWrgG1oq6BJ9BiVpqhO1a4dUCIfsketY=;
        b=WWNgdrn8tY2vuE7GHdeXTs14NroMBAh3FNVkfncySSqwH+G3ubXc17qMhxQ5SJ3DcN
         OiFLJgwMDWQrvs7DtPxTiuR8TeEYypzY3+NnbbsVCfUwBCvnpHoLgfKcgFI+OyzUbjIC
         jIf9IJoVt8HvH/S4Fn5BwT/8rOIZeMgiCT6Fcr4HAl54WUlXlIpUbvDcM/SO+yFtnOJU
         4O6TjwDod9VcMP6iuX+9egCSCSu7UpRykVP9LX4DUnHqZAudczLzdeb/tkjRuV2aS9fo
         ZqnaxGZ5bfDgqJHEFkiIp50h+SWxE31niWIivjfTBz9ZMXbmL3qZDWl07rIszAu3pzqi
         lMBw==
X-Forwarded-Encrypted: i=1; AFNElJ+pDLTnEptlSaL+ztMak/mpfahb7yGj/naKVUm4gzb0DIS60d2aCpo8H3Q0t6nQ6yZEGgKJUduPDA==@kvack.org
X-Gm-Message-State: AOJu0YzHLXBbUcq2dKb8jbUbInB+d8X+ZFjpCi6CW7eYE/Odp5yAVfyK
	cAq5hxuy9MgGO9Jedht5Q8LgGZ7WVsiTECP+2fiaifCvzj/oRdqT3ylHiSyKee0ld1qQIQfsVT2
	mmDeHMA==
X-Received: from pfblt3.prod.google.com ([2002:a05:6a00:7443:b0:839:65e2:e48f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1494:b0:83f:2568:d469
 with SMTP id d2e1a72fcca58-8414adfae19mr3245544b3a.32.1779370274841; Thu, 21
 May 2026 06:31:14 -0700 (PDT)
Date: Thu, 21 May 2026 06:31:14 -0700
In-Reply-To: <CA+EHjTzLCD-dU-euZKgzwyEr2ecPqFDNutcaHm2fCDGA+MHVXA@mail.gmail.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com>
 <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com>
 <CAEvNRgGQvMdDmVfbk42EY_PGN0ybTp-x21Zj+pg_X1mk9iCRtA@mail.gmail.com> <CA+EHjTzLCD-dU-euZKgzwyEr2ecPqFDNutcaHm2fCDGA+MHVXA@mail.gmail.com>
Message-ID: <ag8JIlHjohAOC3-g@google.com>
Subject: Re: [PATCH v6 05/43] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: ii8d4axaen5xuaiq6sesgijj6mbw4rt1
X-Rspamd-Queue-Id: 18756A0002
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779370276-96746
X-HE-Meta: U2FsdGVkX1/l+PtMNj9WmWIlxQXj7+2HkfjpiJcTy+sCnSF/IvMKgVVtA5z2qLlT4pXZWTB2iwPeSz+tBWm3lSH+T+al9j15PUtDXxnUdoMNyuQ56EtM6rC9fUTOgTj6S+eJcqIndIHJVwgbedIVvxzDnGaod1bz6mOSad1enCDGD8uGKgHYDI2gPB2yke6FVW1ycRLyT0LeLB7r8yVKvibqlVAO3rB7bHJsbqGIIou0Lbt1zYoujHQJ/v7xPW9+vLHIWuo+ZFhRnT7UMJc1NUxEqyvLHGr3HaOAnr02AxYEOPXvA+wH9krbXGSgE/nl/9PUhKbZvWjLXkg4UpADDGtk59R42NBE8z5bp+vVLgGAbwe1v9W6wQZbxNGPjJVkT6FLSB/wEsKD15ClPlIDi2UGJ2WsqGWsvprKyMZyukYT7Os99yCiEilJArM6+OQ4FTgOTtaANydIke2zg+sykXIbugNPgOnMt8HI+4l2Jgh/15ZF5Y77VkVo+X3cSurK/eYggTN604BeO/y0c0yuCLVRwP6KKKfPEDjQK0D8SPe284a3wiXhk89NPAqQilDE57bUQBvSj7njKRnyx5s4o929NLVHCyf19tggE09bO0Eh10+t2Xgywo77+vypFyj/CSzvwurRRka8hR9ogTKQ2/4hdOJ1JKHQklCyTeba3qrnoQPzwPOw09k3clVGizUNsZI70biWE4rm4TRSB7muy+Dbq4seQjBECDcS1fG7ixkcJO+9kMNyicF6czAzyOQudsZtPH3At9fG36xPHJsobkpcinH/Drn90yt65ZFFWS6VgxUk6jCr+R17SrwIUoznqvAAB5TgGBh9Tumy2gEbrxduzSnz7ZCh4fTBTphIeuTPIFjBer/kqdQTiO1cSoT0BmZoyWvnctWs+rdyinskoyoJL1eb8wAoE7WfCuSLX7mCC/eMwC/bOpke7vhlszax0Bf96AAo0TdIrizDjPm
 NeUWeusJ
 ekWuFp8lQVS4/pCLzOBIEGtWmlMm4+S9mSzbXBwUKkGLrvkRatzx39j7cpkYXWJdIhZkaYAjhkBrzhDY9wK633prBJ5d9m5ZtCpuitcWv4lp0WAxitRcznIVViI4whDGAhF6fQbOEqD9k8y6Gm0D+deUX2Axjmt6wnvIQ9OkUeofxjAy2n7rMK1FQcn4iyYz9gMxtOx1HTomm/WwO3aolGsc7IT/e/opbxYtnxaSmH7Z7OQGuKeZGAM9vJIQeCxxC0+uwePWBfy3pTKkKIfOQo2k0yb9NF5ru21+54ElkfQGXk8cNK4/7bIcafAeBID6h6dIwyPTgA6u8alydU/GszI/B5+zNALS7WHsZhuyGX9owAVq8o6YvFyPHT46UDLbxM/eJoTe7+oiD7C0+2HCgC66L8gDGYiSGtwmtUjRsZfpwBSI0v+Ps5L73YC9oWiQVJuKc30XGICE+J3IljC4Qc+7GgW010xe1psmWVJSEoFMeZp480Ycmn6M8luw5svg/UO4B7mHgLu4b0rAKCZsHRMN8HxjyxZfjzgorxks1YmENglXphveSqxKYWQzl6E/2tyNY2KGDPJIpzJWK75r7NzoRZLraJHm12XGIJQnAaadW2F9IZ/Ic8SvmU+UWIH+YGrqx9pld/xuvFN3m9u6rdRKFHVrrWW1eLHlm9E+6jm3W1o3RM8xgoPtei0FBX4Uel58R2zeiO1Kv9lFHSkzkey5n0erUghykU+BrvAlLdeWXRCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026, Fuad Tabba wrote:
> On Wed, 20 May 2026 at 22:44, Ackerley Tng <ackerleytng@google.com> wrote:
> >
> > Fuad Tabba <tabba@google.com> writes:
> >
> > >
> > > [...snip...]
> > >
> > >> +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> > >> +{
> > >> +       struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> > >> +       struct inode *inode;
> > >> +
> > >> +       /*
> > >> +        * If this gfn has no associated memslot, there's no chance of the gfn
> > >> +        * being backed by private memory, since guest_memfd must be used for
> > >> +        * private memory, and guest_memfd must be associated with some memslot.
> > >> +        */
> > >> +       if (!slot)
> > >> +               return 0;
> > >> +
> > >> +       CLASS(gmem_get_file, file)(slot);
> > >> +       if (!file)
> > >> +               return 0;
> > >> +
> > >> +       inode = file_inode(file);
> > >> +
> > >> +       /*
> > >> +        * Rely on the maple tree's internal RCU lock to ensure a
> > >> +        * stable result. This result can become stale as soon as the
> > >> +        * lock is dropped, so the caller _must_ still protect
> > >> +        * consumption of private vs. shared by checking
> > >> +        * mmu_invalidate_retry_gfn() under mmu_lock to serialize
> > >> +        * against ongoing attribute updates.
> > >> +        */
> > >> +       return kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
> > >> +}
> > >
> > > Doesn't this imply that all consumers of kvm_mem_is_private() should
> > > validate the result using mmu_lock and the invalidation sequence?
> >
> > Let me know how I can improve the comment.
> 
> Given Sean's context, the comment is good I think. I would quibble
> with the the "_must_ still protect" phrasing being a bit too strict.
> 
> Maybe just soften it slightly to acknowledge the exception? Something like:
> 
>   * lock is dropped, so callers that require a strict result _must_ protect
>   * consumption of private vs. shared by checking mmu_invalidate_retry_gfn()
>   * under mmu_lock to serialize against ongoing attribute updates. Callers
>   * doing lockless reads must be able to tolerate a stale result.
> 
> That aligns the comment with how KVM is actually using it today. That
> said, this is nitpicking. Feel free to use or ignore.

Hmm, I wonder if we can figure out a way to consolidate some documentation,
because this is _exactly_ the same pattern that x86's host_pfn_mapping_level()
deals with (see its big comment below).

There's also the stale comment in kvm_invalidate_memslot(), which, stating the
obvious, speaks to the memslot+SRCU side of things.

Maybe it makes sense to to find a central location for one giant comment about
how how MMU notifier events and memslot+SRCU protections work?  And then refer
to that in paths where some asset needs to be tied into MMU notifiers and/or
memslots+SRCU?

[*] https://lore.kernel.org/all/agcbWe8s9lmPuJwG@google.com


/*
 * Lookup the mapping level for @gfn in the current mm.
 *
 * WARNING!  Use of host_pfn_mapping_level() requires the caller and the end
 * consumer to be tied into KVM's handlers for MMU notifier events!
 *
 * There are several ways to safely use this helper:
 *
 * - Check mmu_invalidate_retry_gfn() after grabbing the mapping level, before
 *   consuming it.  In this case, mmu_lock doesn't need to be held during the
 *   lookup, but it does need to be held while checking the MMU notifier.
 *
 * - Hold mmu_lock AND ensure there is no in-progress MMU notifier invalidation
 *   event for the hva.  This can be done by explicit checking the MMU notifier
 *   or by ensuring that KVM already has a valid mapping that covers the hva.
 *
 * - Do not use the result to install new mappings, e.g. use the host mapping
 *   level only to decide whether or not to zap an entry.  In this case, it's
 *   not required to hold mmu_lock (though it's highly likely the caller will
 *   want to hold mmu_lock anyways, e.g. to modify SPTEs).
 *
 * Note!  The lookup can still race with modifications to host page tables, but
 * the above "rules" ensure KVM will not _consume_ the result of the walk if a
 * race with the primary MMU occurs.
 */

