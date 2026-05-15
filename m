Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DECCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 14:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722246B008C; Fri, 15 May 2026 10:28:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9486B0092; Fri, 15 May 2026 10:28:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60EBB6B0093; Fri, 15 May 2026 10:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BFE06B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 10:28:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17D6F1C00BF
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:28:45 +0000 (UTC)
X-FDA: 84769885410.10.39A266C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id B51B1160010
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:28:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Sfq8rEKb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c6mZM+Rt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Sfq8rEKb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c6mZM+Rt;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778855323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BecDRMYedazdGNIjJxC/aBqY4Cn73u55vUJMwukHYmk=;
	b=Q7R5Na2kC2m8J240easaFRnktjtFUkWL5V72YvtW36osUYy7rgmk+wdqyj2a31/73dnZel
	XEhmnLgBsQu3UzW6dvbYRns+vpzzEQC3WF4C05ntHkJbUBfDtCJOuwOKkdNM4jnjzi/42F
	42MZOn7zC42H3EYB3S5gKOf/QvQ6WRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778855323; a=rsa-sha256;
	cv=none;
	b=NqdYrudjyBatfmuE4PodzoymYFlebpvMCvkzkytCP/VxU1POGpGt+pUdHq0e5X4zm/1oHE
	W+7kE8MCH/UnJfpBxczU+WKC0tCoCtbU2Kim5o8I0bw2CKL5QrWGNnMN40camrvBhxz/5l
	fiY5zmkbyDioceFh+y975/sAz7ZXkOs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Sfq8rEKb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c6mZM+Rt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Sfq8rEKb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c6mZM+Rt;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 02F1D67754;
	Fri, 15 May 2026 14:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778855321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BecDRMYedazdGNIjJxC/aBqY4Cn73u55vUJMwukHYmk=;
	b=Sfq8rEKbU8uUh81sS2hKRj6Oqk8PsCkU0mRUWoSHsaf4dyOVvzixRyjdd+WfDIsKtvrLb3
	fB8HamDGRnHMgCeStIsHwJ3yzEPYfFssHxTGTG3sGs+eoi+wxDuNyRhGIzDkIwnmG9fAFe
	K3LYuXXtNO6lleo7aXmTLmAuVNGlTGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778855321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BecDRMYedazdGNIjJxC/aBqY4Cn73u55vUJMwukHYmk=;
	b=c6mZM+RtGYzQEewsUHmxU5pnFA37J9Myd/hL61envlm4ctoeiX6RBBPZepUCjrJZZP5pTw
	PMtnTgkVEmi9sxCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778855321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BecDRMYedazdGNIjJxC/aBqY4Cn73u55vUJMwukHYmk=;
	b=Sfq8rEKbU8uUh81sS2hKRj6Oqk8PsCkU0mRUWoSHsaf4dyOVvzixRyjdd+WfDIsKtvrLb3
	fB8HamDGRnHMgCeStIsHwJ3yzEPYfFssHxTGTG3sGs+eoi+wxDuNyRhGIzDkIwnmG9fAFe
	K3LYuXXtNO6lleo7aXmTLmAuVNGlTGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778855321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BecDRMYedazdGNIjJxC/aBqY4Cn73u55vUJMwukHYmk=;
	b=c6mZM+RtGYzQEewsUHmxU5pnFA37J9Myd/hL61envlm4ctoeiX6RBBPZepUCjrJZZP5pTw
	PMtnTgkVEmi9sxCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE5BD593A9;
	Fri, 15 May 2026 14:28:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GqkbJ5YtB2ptJgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 15 May 2026 14:28:38 +0000
Date: Fri, 15 May 2026 15:28:36 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Bill Wendling <morbo@google.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matteo Rizzo <matteorizzo@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	linux-hardening@vger.kernel.org, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, 
	Hao Li <hao.li@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Alexander Potapenko <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH v4 1/3] slab: support for compiler-assisted type-based
 slab cache partitioning
Message-ID: <agcsMgfKjGTasJ5n@pedro-suse>
References: <20260511200136.3201646-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511200136.3201646-1-elver@google.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B51B1160010
X-Rspam-User: 
X-Stat-Signature: q4tpfdcm7ju5ckiyztz41jgi49n6865w
X-HE-Tag: 1778855322-795070
X-HE-Meta: U2FsdGVkX1/g351gYZoxnJy3FFgkgEOtZh8dflXNXCrACNSpIAXihQWUuDFVYxl8fYzlwFiHiolGywTL197GcFG/4fu3YcBGLa2H73i5dkfxwzmbRIYFRhvjeZ52dhgTfyiG919NZJ00oOmQ4P19H6NMpUqG2sI8y905UvlHS5FFyuHKa7EaKIedG7c756Z6dAcF57iY3b3qZ1nq9JzdZCwSniEUSOZpQjZFZ1ms37GrTlLBWJ9vlwXBqQtA78OuV2eQJeTsb3ZGNeZYbxY9OSA1eDE82TG9MnA5C0DL/LmkyLghQXPvVJ2xZ7lDqbeVYLnvDYeze9HuN9l4lWr1iAEsemMmSVBFgRhPPwCpoiMAXpTa6y61qAJi2OTz4zHGTlX73hjJg1fRZviQgD+DNRSZ5LbO1hTM7T6WGXDb6COBDwcUE7DaPxk0Pm6VfZ/U1uzdK+myWadBIDdoH3P+5sTdV2x2G52wGkj/dTeUEc7ndimt2bkfckSVHyL0w2UY+kQOP1mMjJK/GxLxkA67r03n5eNCE5u+eu/vNrvQQ9Bbbe9OcXLyWWwNaoglw3Vwdig9cE81FN0PlfmTVzjVjTygFhnsbBPPyKU+vx/6aPfhTw10L4LdMCnrzGwmWnwCdb0F3I620bA4U9LdaJv2z0VvuZdYmmyt74DIPHvW6lWw73PUy0Pm8DbFVqFMKjk4ctenWacugvv1MtHOJSYMN23ePRhvGZRnF1J+gOCOTE5Ed0khx397tuvDmLEa/5YrtlPgIav8dP0mgxfVEzXIy+rr2uNd4DB7Sd7ma1BP7Bw4C+6M/HWqyqh4Gfk0vAGK2jXWTl/iOD3r01shdhChSW1FPp6ROq3m2qIWgWqNFVY2tAI/ETgRytqDJw4aTu+jCv7KkRcz/Wv8B+Ynibm4bc0ZR7oD9SGy0aBxwRs1Ny6fUE4awBBElu07/rf9gEea99BN64QnFTcAlnKPmpd
 j5UeOlL6
 /fVnZ6Hnh5kacAuE89dUAcOq25gjKqoBJ7QAA82s2PY53LMA8CNSdXqpbNe31UiA08vSciYyIT2F5ieg8EMPJlQd16XN4h+ybJbTmbNOHxV1ygXx5MPap6sJwq5BMEfuGjoSkgUDn1uF2hhe77yuI35WcEwV/uTJQ9dpDR2KBpDEKZlB8P6rxm3zIyESMlm49YHcRaVo0hf6+CKY+0dRV/2Orgir4uWGsYhqYy5kmdq8nuxiDK+bDUOe4qzzgdZGUetiPfoF1h2Am5LPqYUdZVlMhJj/VZ4mB3+lJM01i/8AjfwB3QnSn8azR8XxgFTcMlVJ/qXjdYK5d/CxJNo7SF/zqtF7AOQTr6u0KKUUUXYXnYzJ1Mkr7KjrdF2v8EejBK0TQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:00:48PM +0200, Marco Elver wrote:
> Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
> flexible KMALLOC_PARTITION_CACHES, with the former being a partitioning
> mode of the latter.
> 
> Introduce a new mode, KMALLOC_PARTITION_TYPED, which leverages a feature
> available in Clang 22 and later, called "allocation tokens" via
> __builtin_infer_alloc_token() [1]. Unlike KMALLOC_PARTITION_RANDOM
> (formerly RANDOM_KMALLOC_CACHES), this mode deterministically assigns a
> slab cache to an allocation of type T, regardless of allocation site.
> 
> The builtin __builtin_infer_alloc_token(<malloc-args>, ...) instructs
> the compiler to infer an allocation type from arguments commonly passed
> to memory-allocating functions and returns a type-derived token ID. The
> implementation passes kmalloc-args to the builtin: the compiler performs
> best-effort type inference, and then recognizes common patterns such as
> `kmalloc(sizeof(T), ...)`, `kmalloc(sizeof(T) * n, ...)`, but also
> `(T *)kmalloc(...)`. Where the compiler fails to infer a type the
> fallback token (default: 0) is chosen.
> 
> Note: kmalloc_obj(..) APIs fix the pattern how size and result type are
> expressed, and therefore ensures there's not much drift in which
> patterns the compiler needs to recognize. Specifically, kmalloc_obj()
> and friends expand to `(TYPE *)KMALLOC(__obj_size, GFP)`, which the
> compiler recognizes via the cast to TYPE*.
> 
> Clang's default token ID calculation is described as [1]:
> 
>    typehashpointersplit: This mode assigns a token ID based on the hash
>    of the allocated type's name, where the top half ID-space is reserved
>    for types that contain pointers and the bottom half for types that do
>    not contain pointers.
> 
> Separating pointer-containing objects from pointerless objects and data
> allocations can help mitigate certain classes of memory corruption
> exploits [2]: attackers who gains a buffer overflow on a primitive
> buffer cannot use it to directly corrupt pointers or other critical
> metadata in an object residing in a different, isolated heap region.
> 
> It is important to note that heap isolation strategies offer a
> best-effort approach, and do not provide a 100% security guarantee,
> albeit achievable at relatively low performance cost. Note that this
> also does not prevent cross-cache attacks: while waiting for future
> features like SLAB_VIRTUAL [3] to provide physical page isolation, this
> feature should be deployed alongside SHUFFLE_PAGE_ALLOCATOR and
> init_on_free=1 to mitigate cross-cache attacks and page-reuse attacks as
> much as possible today.
> 
> With all that, my kernel (x86 defconfig) shows me a histogram of slab
> cache object distribution per /proc/slabinfo (after boot):
> 
>   <slab cache>      <objs> <hist>
>   kmalloc-part-15    1465  ++++++++++++++
>   kmalloc-part-14    2988  +++++++++++++++++++++++++++++
>   kmalloc-part-13    1656  ++++++++++++++++
>   kmalloc-part-12    1045  ++++++++++
>   kmalloc-part-11    1697  ++++++++++++++++
>   kmalloc-part-10    1489  ++++++++++++++
>   kmalloc-part-09     965  +++++++++
>   kmalloc-part-08     710  +++++++
>   kmalloc-part-07     100  +
>   kmalloc-part-06     217  ++
>   kmalloc-part-05     105  +
>   kmalloc-part-04    4047  ++++++++++++++++++++++++++++++++++++++++
>   kmalloc-part-03     183  +
>   kmalloc-part-02     283  ++
>   kmalloc-part-01     316  +++
>   kmalloc            1422  ++++++++++++++

Hi,

A couple of questions (I apologise if this was asked before, I wasn't involved
in this thread):

1) What's the object behind kmalloc-part-04? I imagine it's a single type
getting allocated a lot?

2) The bucketing looks quite skewed. Do you have plans to implement something
more similar to what's in the original Apple blog post (with the smaller
granularity and all)? I'm asking because most of our types have pointers in
some way.

3) Obligatory "how about GCC?" :) I quite like the idea behind this feature,
and it would be awesome if it could be more broadly deployed!


In any case, really cool work!

-- 
Pedro

