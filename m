Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E703FCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB5D6B0088; Thu, 14 May 2026 03:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282CB6B008A; Thu, 14 May 2026 03:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172826B008C; Thu, 14 May 2026 03:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0428E6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:10:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACF641C0496
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:10:51 +0000 (UTC)
X-FDA: 84765153102.01.348E275
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B963F1C000F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:10:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQVK+8Na;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778742650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0cr1L0DBtfJ85wG/HEbx2Di+djOEd4lDKKPw7YRdLU=;
	b=ePnonGHMcUzdMBAVBWxmsu9e0uyUqiBbJywhIEaYR2+kQtPtpZzT9lrLRszJKSwY/ilWus
	T1DC+GQuyb3gub3VuJ0Gcb/rdL/baddRIQ1tCQ0Yz0rpSDq9DDOF9x27GZvZzPq1xBadep
	ckIllnD3hTNDG0hns7PEdofTawK8ODo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQVK+8Na;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778742650; a=rsa-sha256;
	cv=none;
	b=j/lN2SdpeS7B+BCeTwhM8WeuTcJDVqqBhGXpve+uMEeIBhRn1zurHPPvs1oNVq36hE9iAn
	j9g7Y4CCwxI5pbC5V1B61TFhBzvmTybN18D1r7VrvzdHhxdtM5K3E/tuRmlBDQpwKGhZLn
	QVgdl6XiZxKT+uqECODUUnOPBe0ZeUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A30C4327C;
	Thu, 14 May 2026 07:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4842C2BCB7;
	Thu, 14 May 2026 07:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778742648;
	bh=Dovb0ZSp5Q9c9EM9Cxe4xd9/THMwZyNDud2+qF48IrM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VQVK+8NamiDvmyWVPlvIE8KFbcc/zLvTxDHq8r4VS/uKjoZWsZArHZLG9uOnRCM8M
	 +tbbV30upsQiO+lvzN1Wa3dfumk1WBVMNhOe4t0C8j7+v+u7D0SgLwFggRMnY+Ppv4
	 j78PP3E0Wi8fN8eDISSNXzxB5NC8dwHs50RV6kThwJQ5FOUjKXNnx8wNGWBgdpuXpF
	 CphgWuxoVP3uLKepFyEloksmre1TXKynCpqd33tVXorTfKlNqLzLpmT8g/E1obRlT3
	 YGWVC5cHC+NQXI9ZzE4HWAGtYSevT6+hZ8DH3+yYVkzICVM7Fpkgn2/9bHiXtyXmLc
	 QG0GlOd2L4C3A==
Message-ID: <1f68fc67-66d8-4db0-8ddb-44737d7ea37e@kernel.org>
Date: Thu, 14 May 2026 09:10:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] slab: improve KMALLOC_PARTITION_RANDOM randomness
To: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Bill Wendling <morbo@google.com>,
 David Hildenbrand <david@kernel.org>, David Rientjes <rientjes@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
 Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>,
 Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-hardening@vger.kernel.org,
 Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Alexander Potapenko <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev
References: <20260511200136.3201646-1-elver@google.com>
 <20260511200136.3201646-2-elver@google.com>
 <afc2202a-2e0b-43e0-9556-06be2da33c83@kernel.org>
 <CANpmjNN0-b0TG2=7SsPpRuubwTWYfoAiYgnnM_5-39SoVfv=Pw@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <CANpmjNN0-b0TG2=7SsPpRuubwTWYfoAiYgnnM_5-39SoVfv=Pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B963F1C000F
X-Rspamd-Server: rspam06
X-Stat-Signature: j57ojnxwzdrk93dot99jgmm3gd68xw9u
X-HE-Tag: 1778742649-720133
X-HE-Meta: U2FsdGVkX18jIVXU6dL7I8wFOh1OjiomVJ8E95AI4GJDHxCu0P02t1yHoydVL5cKQLroisPOyHJObGBu4/o99weYcWRRXAwQYk1KJYF3hPeYz+Ob+yizgDV6zl93TG1dF5PB4AJy/hawvHwf4dN9EDchIowFOOner284fY77ilqcWJupUeGcNvNxaiqJocIcuVwDflpYTeaW6yC5aDpqVW9yZlz2+9L0HEJBhhANI1aWmZrevfnRsgqusF66WLKnRC6ntEiLyUusBkBiTy8v+EqhEg4DEjHkgd/+w+wLGlkDMt8OFjENtmc3Wa+MGFsZcUpM08yGjzxvhar4TrfS0ApIYhcoT02Yh4laju3RbTT1xc2AdE8HSi7/I4ANQiOnQWC6E5Zo65YII2OunBRDVG+rR+bFMr8UGG0PsMgeWV1tfT9bIlMzuW3dw4PylsgIa3ynpidie+oq3+Hop/ZTN/azctheKAEJ5IvMFKVvOyrX7ooS4ty/QEp7coUOxVkIi28XEqEZUErkp/ZqCGb0Pwvbb+zqbQD12pxzmBUYd0DCbaYs/oN+Qe2wR9e3Q1+dMNTgUYie3jqvfqEKqA2cCYWXCQDtlYfuHk304vrl2jbjP9WfQMHb/QcYZ9DbjbyQa+BLGzplljqDaop3IAxLHo9w7MoyBckebEd77kCsNruixVZZd57MVB1uVgOqIa4oJLHxcVgYzgcKg2bP5QlergYwDqAThxvWJnRzM/kx4Eo/vMg1fSDAvYLuq8g+kYAh86rKbYbSbuzpOJZMcbnFaBxxs+qbk0rnmfahELy26cpNNYfmeZTdYts/SvauRIvXAkr6Q2m+gyq3ncPkGMCiONrO9dPZw7h63FJo6sUm3EiP9+BfAF8eO3KrwczK0g2kpsYL/7HbdJAScxJaQs0WbDm0vZ7zbF4FxQ/f7uXufgTeE1pP+ObUq1vMS/tdvM6RLQE2vFo2L5q5QHzo+sY
 7Ary2aYM
 H+Jr5VUKXE3wL/kPFdTPcD9efq+VsjKp/3OUWigBSmtG6DUca8AEjzABbeKP/mW/35E+/TOtNzMT3w3OKoGpRq4T1tSG2u2Pdcw241HaF1EcNXNvRR+tO5UeOca6hZanhKXs9cJx1Q2SQbS4rPBHMbEnnMTo/cH4yrtmwypKVOu6qdyfexIAQb9yqXYRWRq2YBmM5P5kPkdtNvks8rpwZOPwBHU4U2XiENuQgkK/wB9tkXVbdirNgyq717Klpv4vrCR/pk+FQfx+GsVdaZwWeQfdUuJO2Og0V3OpCOQ3XeK+w3WsMBQWjX3AFUK7mTCgEllUhynJJ6GQN2Bg1z26e8+kenCtXE/K1qHv39osh84VBLsMZwfcBOj24C2SMRD31vUIJOTOggPu0bMdhuXbqnzxxPrJS3oSng+l+RNPoQ2vk1V3lk3h+O2f/mTEZWBOjPJzg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:54, Marco Elver wrote:
> On Tue, 12 May 2026 at 12:37, 'Vlastimil Babka (SUSE)' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
>> On 5/11/26 22:00, Marco Elver wrote:
>> > When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
>> > to identify the allocation site. _RET_IP_, however, evaluates to the
>> > caller's parent's instruction pointer rather than the actual allocation
>> > site; this would lead to collisions where a function performs multiple
>> > allocations.
>> >
>> > With the generalization to kmalloc_token_t, we now generate the token at
>> > the outermost macro, and using _THIS_IP_ would fix this for all cases.
>>
>> Hm but it means in patch 1 we make things even worse and then fix them
>> again, and also improve what was suboptimal prior to the series.
>> Would it be instead possible to reorder patches 1 and 2 so we improve the
>> current state first, and then introduce typed partitioning without any
>> changes to the randomized one? (aside from changing the previously correcly
>> used cases _RET_IP_ to _CODE_LOCATION_).
> 
> It won't work (it could be made to work if _THIS_IP_ wasn't broken).
> The compiler is supposed to maintain semantics of a static variable in
> a function, even inline functions, and refer to the same static
> variable -- and because kmalloc_type is an inline function, if
> _CODE_LOCATION_ is the non-_THIS_IP_ version, it'd break.

Oh, I see.

> Even if _THIS_IP_ wasn't broken, the other complication is introducing
> the slab.c vs. outside use of kmalloc_type differentiation.
> 
> Both these problems go away if we make this patch 2 (using
> _CODE_LOCATION_ on the outer macro, not in an inline function).
> 
> While I understand that maybe we could have considered this as a
> stable backport, I think it's borderline; the feature isn't broken
> per-se, just slightly lower randomness than perhaps intended if size
> is a constant expression. A minimal fix prior to the macro rework
> currently eludes me.

Fair enough. I wanted to avoid a bisection hazard, but since it's not
feasible and it shouldn't actually break anything (compilation, run), it's
acceptable. Thanks.

