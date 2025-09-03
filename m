Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BF5CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 06:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928986B0008; Wed,  3 Sep 2025 02:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D92E6B000C; Wed,  3 Sep 2025 02:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C80D6B000D; Wed,  3 Sep 2025 02:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C8D6B0008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:00:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E06B1DE3FE
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:00:13 +0000 (UTC)
X-FDA: 83846888706.18.7A70408
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 474FEC0013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:00:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GM1NLNqh;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756879211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdC3QTxmU3besuQLS5g8tc+09uf1KenOXC1aPNt3jcA=;
	b=R0Rtl7b+dkcVpt01BIeLhNI1snF+tVLMUpwvWpGxymWzqAJbchS4akeiNqR6c+ZNE05MQ2
	4906U6TcP2YJnf2spLhM4a8DSYG2qgT96zszqmhanxd9uCrM04AQkFTWYuzgKCdqWnMYPq
	HG3gvFPIZPkf8i5KzyzmTjhssUxrVWw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GM1NLNqh;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756879211; a=rsa-sha256;
	cv=none;
	b=T3+9LKjMXenoIfs2K3js/WVV1GgZGIk1xoQdynLiOTCUMp3KbDC0kprKEtGtxnKRUvmLJa
	Sx2FjWsup/hkkP0Z6VJr70gJAqNEC4Pkh1tXJSDqYULgCDnxjBRe5/5KpW3Tpy2x4QaL+k
	kVRJPAqyRsVQUxW+aSYLoPrivoXBmgE=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b47173749dbso4288936a12.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 23:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756879210; x=1757484010; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FdC3QTxmU3besuQLS5g8tc+09uf1KenOXC1aPNt3jcA=;
        b=GM1NLNqh4RP+fCdrInBaRl5jNMcIwXydCky5WrZYQ7J6TLxq6dGNWpKkdlPoqAUBe0
         cqaewcmGPnRmNkawteqkSnl6GYVpMsKxPO492lBJZ3/NEE2kdf3TyhLoHpPcQULjDiSX
         Wo1o88oIDu9tV8kR78MtWe8gGuvlP8KCb4twDLH+sPPrxRf0ee1wN2NhCmlYJxN3AUcI
         RFrLtlvfSGV5S7V0dIh5+C5q2K7rRcmEMGRxnpy7o1vrjFv+5KJENkdaRNw9F+RGGr+Q
         5hIeZ04tqNVlTuwSe3ELeSgFNQh8iYPake7IenmXIQjEN3zjxr+G9EfEBIysZYRcquut
         F2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756879210; x=1757484010;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FdC3QTxmU3besuQLS5g8tc+09uf1KenOXC1aPNt3jcA=;
        b=TWyi2ZHeFZdOLpiqKEj/oDzSNL5skCe7NTQ6Fh32+XxKwboAMJ6U3Prwzj34mtB+bv
         7NgsgIcBPDYcb4vwn8qSEw/uhZcAfG1lGq29SEgWp5FegEC2RVp7FHT5RtAtQaJ8aP1R
         wv3F4roHDSFB2duq4ikeXdgcNzQQ7hhpjzzHJptjKVonW27roaINssTY+9n2YazuFJfq
         BS4iCmNceEj78ThB3oANAHpPGgKtXYRGBw5FlUiOLvMFsa0zzlvJO1NgdD0vNr0XIjjA
         nzpNo/Slz1qr+NUA02IRJroStTIwoa7rHqdbg+ja2yszIQEfPj/crYp+f3LbwfiGQc2K
         MC/A==
X-Forwarded-Encrypted: i=1; AJvYcCXqwfHD0EHFzBmLc3nlI6pyjqPVzI8v27vcVkaw7sLLjTucetZetYMEdG46Bsv+3xpgKi/kGD+qhg==@kvack.org
X-Gm-Message-State: AOJu0Yyc+DedFCWMWsyjN/ueTDxmhwYM6l7cCc3/+ye3gjkxt0JgBA4f
	GRvhXj40T8OonP7rVkRGUkTQiSy98A73O5ktsNkU/6RwMcQ2LnEC0DiUHLo9E8I7Rxnh+2CmvJn
	cKTv3sUf+7Pcg8rR4lEHcfmVwdEdoZq3jeI+E905R
X-Gm-Gg: ASbGncvd3kkGU2D4gfVsAk2ODYLCtUQAWWcXtHKhWIVT74JNt2pIAmXtWjDqsLv9hDM
	8AY/4WT6buPktaP6g55em5HxGQftoQuaH2RqI1uP9yCRQYdYTWw1R1V+Hboq4DZbcpGQ7bh3GBp
	2nv05zIB57d/kHbF40AF1OzE5l3ZESltzB0Nd/pY4rWlP7MrgRJwkSTBQuVAR9AwGKVo18kKNCD
	OqnB7/KVjHri2HA4AT/sLoO54Mzx7TwULEq6fSxpMiShQ==
X-Google-Smtp-Source: AGHT+IE4iWea1dHMglD1MtIs2f5EA13KiTkiIb8qI2VYbzhFnB8dDcZN8fetSPmt+uSKa/XqAOMO3DrJFBjK/NVnrDg=
X-Received: by 2002:a17:902:d543:b0:246:4077:456f with SMTP id
 d9443c01a7336-24944b35030mr172147985ad.58.1756879209794; Tue, 02 Sep 2025
 23:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250903000752.GA2403288@ax162>
In-Reply-To: <20250903000752.GA2403288@ax162>
From: Marco Elver <elver@google.com>
Date: Wed, 3 Sep 2025 08:00:00 +0200
X-Gm-Features: Ac12FXy7vOsop2eZcEJ8r-sYpuE381OhvdK3KJiYzgxTh4KO44xvrZCKXVwkZ5E
Message-ID: <CANpmjNNV=ZmjcGWvPwHz+To6qVE4s=SY0CrcXFbizMeBrBaX4g@mail.gmail.com>
Subject: Re: clang-22 -Walloc-size in mm/kfence/kfence_test.c in 6.6 and 6.1
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 474FEC0013
X-Stat-Signature: bbjimjbqyg374w9ixj849upd4uokwyw5
X-Rspam-User: 
X-HE-Tag: 1756879211-631001
X-HE-Meta: U2FsdGVkX190f9ZxqGjds+ErMO5e/07rztzKvtihwsOcL1jVYk1ZwkwM1z5kIO23W5iDo2L8YNaii3g2p6SZpUxamHnd+OsPV7u67h1lVPB8wfMVhZRdNG38Y6zUEKiKcq8b/127fosjDLSyUB0n/MDoQHId+dnp3BIu/FAuIMjBDuQP2T5Gj2+HA3PzfMQyUeiWRrQVVsu9l/uVNY+eZ0f5BZaiuuBn0ia3ZDbhsCdscNKKhUKBvNoVr7jPfu7RL22wgfvENPyqx2+Im5MUySRVGv+EIfFKc9SvfzJWS3WhtiLsTG5zgopZ0r57Gg7Arnt5hYtdONEEihLCDBZcfqCjUOilfDkRT2mfeCX+UdQwNGk01WXhjszM6ddlHCRmr00pbGg/qtTMnY71qb7pB+vCqLvj3+anQN/4RKH/w5+QbvJUgwkoZ7T4EidnwpSCb+Mrh4ZrBd6ujrZ8quEEvcqyN1jJwAFrAoI/6NVaLunMCLQzafKMxmPVqS7c2W6dNKImmFkezTUol0UjYebufHw4a4OSSSQgQh37Gv9PGJy2fVByElsDB4UJ0uEfet2tneGLWvaTnWDBvjPtZuA9TU80ZuuljpGsCjSDgyU/2tm1URCq3hyjvKzq1RWvj2hxsdKOZpdD60nQuPfqu2FVDNkOeFPcCVj7VdunRTpfUOsVRn33Z/cmbA5BJBoKG1C3WXu4IOFGAIzFBlMyHLUl07/SekVrKy5qonT37B/Lodkem7ililK2LYowlh7CqcW0+3p0ghuSNnVdZu2yo2rbM4Mhjo9QAu1SkM99bsG/KqDIsbkoHNF46E0v+DBSqCpqC8At3fS1iEzbj022WF2ytLaEzuIMivXaTnr9d1e1s2KAF62VRM7e9x0ieOCtwl/hLxjQKpDfMoSOg8Q5XEb8Xb7b9KX5n//y2ks8xlKpuegK39z+K7tdyCxIy6eT06E/LC1B5zOvpD345lj9WeO
 ojVlSpEA
 OfzWrrdMZNsGI3ULYCJJ/itNDP/DRjTJajpZ8gWDh9kTn2xwhKtkoAdRHi/+DyK4Fx3QszknRAIhLzfUeV3ypdDNpLH6aaD+XhwGiNU9NKr+7/2saEUKaKbrAKf/LdyIUbco1UYZRjd1Ty+U9bbzkzi0gQWAAvYs1dGuSmM+zC06eSIxhxvMrmM5XeYXqNu1o1EHNksYXcN0/G8sTe7kIRQxUOMOu2EZRTIALgUQqeUQNqSB1he2LzG4mSP5Ul4OsCn0ZVYXf2ExQ7K8zkUpBev8a5oHEpPqErv8B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Sept 2025 at 02:07, Nathan Chancellor <nathan@kernel.org> wrote:
>
> Hi kfence folks,
>
> After [1] in clang, I am seeing an instance of this pop up in
> mm/kfence/kfence_test.c on linux-6.6.y and linux-6.1.y:
>
>   mm/kfence/kfence_test.c:723:8: error: allocation of insufficient size '0' for type 'char' with size '1' [-Werror,-Walloc-size]
>     723 |         buf = krealloc(buf, 0, GFP_KERNEL); /* Free. */
>         |               ^
>
> I do not see this in linux-6.12.y or newer but I wonder if that is just
> because the memory allocation profiling adds some indirection that makes
> it harder for clang to perform this analysis?

It shouldn't, there's still a direct call:

  > void * __must_check krealloc_noprof(const void *objp, size_t new_size,
  >                                     gfp_t flags) __realloc_size(2);
  > #define krealloc(...)
alloc_hooks(krealloc_noprof(__VA_ARGS__))

> Should this warning just be silenced for this translation unit or is
> there some other fix that could be done here?

It should be silenced. I'm surprised that they'd e.g. warn about
malloc(0), which is well defined, and in the kernel, we also have
0-sized kmalloc (incl krealloc) allocations being well-defined. As
long as the returned pointer isn't used, there's no UB. I guess doing
an explicit 0-sized alloc is not something anyone should do normally I
guess, so the warning ought to prevent that, but in the test case we
explicitly want that.

> [1]: https://github.com/llvm/llvm-project/commit/6dc188d4eb15cbe9bdece3d940f03d93b926328c
>
> Cheers,
> Nathan

