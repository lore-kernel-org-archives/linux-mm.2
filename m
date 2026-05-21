Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DEFACD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A606B0088; Thu, 21 May 2026 10:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801AF6B00BA; Thu, 21 May 2026 10:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717A96B00BB; Thu, 21 May 2026 10:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60E756B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:29:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22A1A1A0373
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:29:44 +0000 (UTC)
X-FDA: 84791660688.08.A26DA44
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1784414000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:29:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CX74syfH;
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Wo6mylBSliDlwCJngQfhikHW93XVCjTkYwG+w8Z6n8=;
	b=f2O7DdlXArTZ5ept3G693fJMEUQiluRsTZkbGjDhZlnX8yQrqJRWc8mEa5rO0HzXuJ6b5g
	CJONbwjfAe7dIldxU9YPSMKcBhTQZRruPCLJVo5HALUSecg4jM9uTfKG9dMxCrCiX6mPCd
	++9KW9N96k02EmbCok+6LImZg/gmgZs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779373782; a=rsa-sha256;
	cv=pass;
	b=L56AXzkj4b/o2g8RaWq4b3pR93rHRgAwYtd2dpOrmnmWU3jK85azzY01nMkotlsimSFhO/
	TOo7kkIEqHZjuIAkGSmofIdw7MxxEl9qw5U0nXHyB/3F0VTaoOQXQBYpJE6u/F2NUj9kKi
	NmrUdvbPKG/12DmzlgrYDFZo4lwLojE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CX74syfH;
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-575212eb419so4422092e0c.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 07:29:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779373781; cv=none;
        d=google.com; s=arc-20240605;
        b=ahVtt8zemHr0PFSLLvFluD8v6ZNfjh6xX7CmNnNJhcc7QltW87It+zl2eXPvgDZ5CM
         ULrJ4ahmhAElP+/pHUXw3F11vlqh+qu8PvOmfcug8fqpH0jv2+jn5XZWN60KfWbHtdE9
         86ANwMrwEVqo3ngR5n1zgMzBqnfmFXt2k1JFyOr7R8X+Q9/Vv7fXhyVRPa6vNRYg0Cc8
         ziCE1JzvRM0OPE2u6Y/tWx2icj4fu0OxF+h4CjVUiuF/9gA9FqcHs1FrSk5+nyvgY/3A
         8n2PXoHYY1rS9z71PI5oiI0W6iSL64Xd8tt5/qPyDyzg1A40hNSZUt4ph2sXZemPAqza
         AnPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=1Wo6mylBSliDlwCJngQfhikHW93XVCjTkYwG+w8Z6n8=;
        fh=LsIO6uDVBvB4v8PW0mrj/vQwVBQHIQMZnGGZY/neHL8=;
        b=JCaFJ395b35MjBqZ1NdsmISzLA0ToIoNmEakqDhhMbG/GRQO1qvYKbImMUGhKeVV10
         PyDfr1dQlL0WTPubaQSszj7Ur2flvB9yP6DdvIQ4rfNvEqNZcfIjgnH+Ec8mSqS4YTiQ
         KReOAUQvL2/5nvv+yv7XfmqnIAIvR9Ig9vIyQj65ad5BCSTH6xWVVgsvTNVb0onkGUl7
         yUZQDnJMkLFWKhR4PH5R4pQsRJ444+VvpqKDSFwvF72IHWEFxachWtr+h2L79Lx3sO59
         SohuSOzKRGW73ASB1X3MWj7oaCgxkyLUVchjonHJxQhTh3K/ZjkmrPc1mtPnwonMIVEW
         2oKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779373781; x=1779978581; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Wo6mylBSliDlwCJngQfhikHW93XVCjTkYwG+w8Z6n8=;
        b=CX74syfHDbbDd4oF1Ci2y17SwRPs2dQSKs7schicGO+Lm70GHQq7hY6f9zVWhw4V11
         GDb29JEvsGkmL8dzGQPdcqcWz4zYpOVYfmynsF5tr3CHRHSrnBjuFX2+QcGA2d6kfEEY
         ikL2RkUXnedi+Bi2vhhISr/QyWqnLykAijJ4vFUefNRQSWMxj+9vqpR6rX+zKi/YOuBv
         1xHuZmnobgrT2Q0qPUIEwRR/HB9eK6njj0GEhE2sa+4a6VmXIoJBm+SbheeD3nbw7Diq
         cgSZMS9u/af30ZJ8qWE6/4DwpbKB9El49U907uOFNYTEqO5cJNvnxrRH3+nqRWRfIBcR
         EqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779373781; x=1779978581;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Wo6mylBSliDlwCJngQfhikHW93XVCjTkYwG+w8Z6n8=;
        b=VzyIJX/R/UUtNBS2Vu/0dGQDn7TFIv3FPB1hj/zAQfLJVWjdpMcg1ta/FWk50Vv0S0
         fo52XerjceXAU+asHX89IAL26OM2f0vNJdBuy3l84N1EG0/Bk170I0cdAVUI3lpWp9Ng
         lM/6cWenSjVeQwy6XJqK82gJRrbLvUbGsKenW6zhLSNc+OcdQOQexoy5FggbVySrPlFj
         sTlZVlh6EF09paOJHy5/9YXA5bcaqWXW0UX1sS2fvNcrFBQhLFwsG6Tb/9+qR+0fckL0
         FKxqu3jIun3so4wthwyTvdYPIoaIMwr5syL0Ueh+DimwN3Eaw4f2Fxl2bANmb6LhXm3R
         i2/g==
X-Forwarded-Encrypted: i=1; AFNElJ83rs4LxcNThce0s5j4cHsoE4GKAlCSNeuOil3OO4cN1aEZAOGP6NHR2Zpal55itDDLJHBbpt9xwQ==@kvack.org
X-Gm-Message-State: AOJu0YznXv4xv8KR4qQLc+i8mue1XMlM9kKdOekDSkwMa+MvIrrAU99P
	44Rm0a0QkZV9kiICdeQb1PfpZjpAEL0cgUeB5QNjanZTiw1HF/6YOr6+e/J8c/RpkibCWN4gKXI
	MNMdNej6HgGCWX7LwVKZBat2nb982Kd8enQX4X2mx
X-Gm-Gg: Acq92OFU2UND13Xu0RUvVWGbDoF9KPLPD47UkbQQDs7Moa7QXGIjo7Mucu3HpfHWZt3
	ODFQ9zy1SEytk9uEBQrCMERc6yL1s7EPJnwvxQJcx8OZd+0mPLR0httIPevlcmcb/gL6r7Fmi9y
	gAlXgMyg01T0tJZqCEnQ5dgL8JC1sG4bfBetE/atAii8zSvHvVmy4vLhx+vtpxvkimTZQH+gYKs
	r9XwPLWEfhDBHIFL4PXd0iqdf8lXInjO8zzVYO4i5KnxITGMTLKGGv3uov2NqvRAOoY7zxWEYx9
	hP0zKuprEiNcr7DXeKSrmcZRWDCbpsdPVGOGj6Jbi1qfhYFx+w==
X-Received: by 2002:a05:6122:3110:b0:575:9f5:ac57 with SMTP id
 71dfb90a1353d-5841d681791mr1479571e0c.4.1779373780196; Thu, 21 May 2026
 07:29:40 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 21 May 2026 07:29:39 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 21 May 2026 07:29:39 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ag8JIlHjohAOC3-g@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com>
 <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com>
 <CAEvNRgGQvMdDmVfbk42EY_PGN0ybTp-x21Zj+pg_X1mk9iCRtA@mail.gmail.com>
 <CA+EHjTzLCD-dU-euZKgzwyEr2ecPqFDNutcaHm2fCDGA+MHVXA@mail.gmail.com> <ag8JIlHjohAOC3-g@google.com>
MIME-Version: 1.0
Date: Thu, 21 May 2026 07:29:39 -0700
X-Gm-Features: AVHnY4L1QQsQd0FYhhV2GOCZxkOSXAeihTuLPqsZRThJ8u9A5XK7N3qOGhZF0xk
Message-ID: <CAEvNRgEZ9vCKkoMC11tVrueAonGWH2x6OeaYYxXGEj2gwHUaKw@mail.gmail.com>
Subject: Re: [PATCH v6 05/43] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1784414000D
X-Rspam-User: 
X-Stat-Signature: oq5zhmjx7f1471qceyoga9bi45aq4ufa
X-HE-Tag: 1779373781-804556
X-HE-Meta: U2FsdGVkX19euKIa2UJKcvBbERAiwXF4ww5jmlHCqyABzpRKxoP65nFRT9pxtARToanxSmj37kX2vFSP34P5e51k+VfwLV2fhypq3lmYfc3aHMxNcNGyBTTYRZqSBHkOCebY/hMcKAi6zAB0bSRg07Oo5ZMsa1XHcGLqS4GLFEjnxrfTNVb8UyPpMO7zMSKK1O91DnLQ5syveNTP5l3iL25zUD4I+X+sHiABqhPVefBnx5PRognBxSxyoCyMvaAqMkMcrnmJIUpqM3ANW4ycYH0ShzH/WLsW7js8aEUwLjuyzAFBBrn/hkgh9k2AuAy5ubMG1nZErjez/MqR3BLu3xkGDQ004/z8hN+gNBySq5Rfdj+79frjAze6oy9nQWGkS/UeAJgUMNEwKT82R8jjO9gMPiHRIELHX3GqgsW0MaIrkbC1nUdFqOP0cuyqCOjPEYFhi7zsfER5L/4DYsN09ip4vXnHCuKJ2yZdTpFr9UZK45+qF6HzOOm1Ri3ToMg8dMbJ9Fli9YeDL+tmyw90G4OzrwwZzEnqXHzDDGgF2hCGJ1B7AgHNkH5+f4v+Or+/4L5SZ/yqGuAfSEj90NXqGw9HRLKaHWUsr2OjrNmE0grTcMhp6Hd0N/MuAhEx+8NHwpWJeZ907uD3yk7CfRNbViqfHqpWVV3D2vD/erbPUoMb2lkDjN1tdkRga8suZLME2IjS1pMg2UtGTtrdqn288N9fihPaU5WNWd/OM8/19zIN1pvrEdu5X2LJ0Sxgv4VGX7I8RsbHNNhm/ChQy5Hq2juSKCZbo3rpLQpj6BBWpbAkxsuHcdyS+5E5Ro4w6yjB/SoGzDFmvpWDexcxO6CazbUoQd/anPE9yE14PyO47ofZb8p7ZoKq9cIxMFm4/zJhfFsJ8HOW/Hyuu401Y2+yuK9PZpyNAP7TrhMPz+XBMvCOyCh+BpY2pHX/qk9T22zei6FTEzGaAP5E2HLtIHw
 fq0m0Ok/
 ZOJDSARvMNsen3N4Qnf3g73yQ+9sWQN0O9k3TDxTHPjlO+f+JFn/jKdXL9h+hlMU+mi3yvXJRtMJ2DXEKWRdF+CpH1tbCov3J87NNZZp2eyOgI1wRQF7gRiGd+6jsmdBvxqcvZE/wvRC8YfMHxVmrsNiv8bnkp7ZGHlibJuwpetEvkuoe1rUzVh6bTOZxxnYNlyo5PVsIFCFIvamzPKAjJm+o+TreSxgtgdvYPiNdgATHwqMLjG7qQyQnHBOvqCkABCB5CiGPVvla0tCVBGjlk4q5B/TIaAXOtuP5ITdO4Q37gFXWwrfvTHlhM/sczwdGW+iEfJKEM5X97MFBxehnOzceZRZMRyhr9qHByKaoBmGBvK4kfUvqPlzDlNYhxIKxw+sHaJMuRVwGp4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, May 21, 2026, Fuad Tabba wrote:
>> On Wed, 20 May 2026 at 22:44, Ackerley Tng <ackerleytng@google.com> wrote:
>> >
>> > Fuad Tabba <tabba@google.com> writes:
>> >
>> > >
>> > > [...snip...]
>> > >
>> > >> +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>> > >> +{
>> > >> +       struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>> > >> +       struct inode *inode;
>> > >> +
>> > >> +       /*
>> > >> +        * If this gfn has no associated memslot, there's no chance of the gfn
>> > >> +        * being backed by private memory, since guest_memfd must be used for
>> > >> +        * private memory, and guest_memfd must be associated with some memslot.
>> > >> +        */
>> > >> +       if (!slot)
>> > >> +               return 0;
>> > >> +
>> > >> +       CLASS(gmem_get_file, file)(slot);
>> > >> +       if (!file)
>> > >> +               return 0;
>> > >> +
>> > >> +       inode = file_inode(file);
>> > >> +
>> > >> +       /*
>> > >> +        * Rely on the maple tree's internal RCU lock to ensure a
>> > >> +        * stable result. This result can become stale as soon as the
>> > >> +        * lock is dropped, so the caller _must_ still protect
>> > >> +        * consumption of private vs. shared by checking
>> > >> +        * mmu_invalidate_retry_gfn() under mmu_lock to serialize
>> > >> +        * against ongoing attribute updates.
>> > >> +        */
>> > >> +       return kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
>> > >> +}
>> > >
>> > > Doesn't this imply that all consumers of kvm_mem_is_private() should
>> > > validate the result using mmu_lock and the invalidation sequence?
>> >
>> > Let me know how I can improve the comment.
>>
>> Given Sean's context, the comment is good I think. I would quibble
>> with the the "_must_ still protect" phrasing being a bit too strict.
>>
>> Maybe just soften it slightly to acknowledge the exception? Something like:
>>
>>   * lock is dropped, so callers that require a strict result _must_ protect
>>   * consumption of private vs. shared by checking mmu_invalidate_retry_gfn()
>>   * under mmu_lock to serialize against ongoing attribute updates. Callers
>>   * doing lockless reads must be able to tolerate a stale result.
>>
>> That aligns the comment with how KVM is actually using it today. That
>> said, this is nitpicking. Feel free to use or ignore.
>
> Hmm, I wonder if we can figure out a way to consolidate some documentation,
> because this is _exactly_ the same pattern that x86's host_pfn_mapping_level()
> deals with (see its big comment below).
>

This would be great, are you thinking an actual comment or something in
Documentation/?

Perhaps we could iterate on this a little with me providing the newbie
perspective. Do you want me to take a stab at writing something up?

> There's also the stale comment in kvm_invalidate_memslot(), which, stating the
> obvious, speaks to the memslot+SRCU side of things.
>
> Maybe it makes sense to to find a central location for one giant comment about
> how how MMU notifier events and memslot+SRCU protections work?  And then refer
> to that in paths where some asset needs to be tied into MMU notifiers and/or
> memslots+SRCU?
>
> [*] https://lore.kernel.org/all/agcbWe8s9lmPuJwG@google.com
>
> [...snip...]
>

