Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6763F94CA7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 19:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11CF6B0088; Tue, 21 Apr 2026 15:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79996B0089; Tue, 21 Apr 2026 15:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A4C6B008A; Tue, 21 Apr 2026 15:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE696B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:13:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07A8A8D49C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:13:51 +0000 (UTC)
X-FDA: 84683512662.15.3B8A209
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0917D180009
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:13:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e3AEcYKZ;
	spf=pass (imf24.hostedemail.com: domain of elver@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776798829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+nBi8NMCSPfGIscPWxKFWQOBdlvlCfORQNm2QzRooQ=;
	b=F3MRrrZo/k9FcJXmWquq16xXODnqdd/TDI1B5wOFN2NbmxyUhfZv+lbGeDiBzuVqumHhZ9
	iWrgM93wqJVZagzuP4ojd6mOj3UiF4Cc7JYbXqXb2aPMSDhkgdAc4dTxcz/Mi4VuBQNHWz
	xveO6PegaPcMxGoffkL3NS+fElorVUs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e3AEcYKZ;
	spf=pass (imf24.hostedemail.com: domain of elver@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776798829; a=rsa-sha256;
	cv=pass;
	b=C5Sy2UBgwyE8RoA7sOb9acVK6kdmHsfX9cifAgy/F46+kTzwxP0Q8yWrT5qEyrftQBdSvL
	Rk/zH3g+Ox9tSRsYMXl2YAmr3N2XsIXZqDWGIPDLjoP1aD2vBpnC40RWgnicCdUyEPp3Xr
	97OkkUaifjBy64w9aWLPzV2oZdq1GiU=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12c45281a06so6206049c88.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:13:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776798828; cv=none;
        d=google.com; s=arc-20240605;
        b=dGeO2hPg2s1jT8/t0JhbunJMClKSWkNDCA/rNTXQGxddC1tCpKlf9LIjXPvSfMdFt2
         mGveZFEt1kiXeBhLFwJH/M4AX2+KQ681P6E+kQCCw96Y/jbw2xoJNeT4yirG94HuoolL
         vf5CZgckoX0qy8fUJkMy0hYm/ljASpl66YeuW3l/HdFqSsuhUwpJ+nSLVdxXQ/zj5++4
         MbhA+vqXxkj4RwzlKvO9nJTiXD5Em6IMW9SlAtH7NrXzoi5XqHMvQHLWmQkokHDxhKUJ
         ABzMZmRDImuzYuP4g/tuX9nVTPWX2aRllRy5iysZy8k4TUZMVa0nFqj3cUcTMgSJYH6W
         hy1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J+nBi8NMCSPfGIscPWxKFWQOBdlvlCfORQNm2QzRooQ=;
        fh=SRr+K2XAoSSXWRfxbvb/MRMTqEVv8elwxdRysyr8kA8=;
        b=P4NwycBUTFZ6TyPtX1GynPiYUwnazmfDylcsS09i4iDIzIFdRjt3vkXLrX3oghsTGg
         Xs0FeJZJUkwlyL3DnzGrwJSZHhtrFAQ/Kc681iTLIvpkAfAduaoFoawUA2Imc7ZS7vg0
         XLcjZjhi8JW661I4AgOJl+HbIaoCxdK4uVEuRCuQIVe/TaxvqiJFGxeB6fkrhSteSSaT
         WZMdszYJ2YJYNNimQNc1VKxIVP9ZzjW7UP13OWPPlro5aGuSkqj/rdrYEHDD6j/f9nOg
         UVgHgHbcvlb0dI9p4SxHPH6NJicAEvT1g9ELns62O5fuGrQaJZZGgWi5UrQPYK1sxBl6
         COsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776798828; x=1777403628; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J+nBi8NMCSPfGIscPWxKFWQOBdlvlCfORQNm2QzRooQ=;
        b=e3AEcYKZ6B1IzCi79SoyVqpFwB0MPmPBJkglPaEF19lfLWEFeJ63gcUQkbPfGPEU0n
         qXr+ZaZ9Sj070gnNDaBl+4O2Y9GuY1bnfAoCptUrdp61LgtmWIw/Nt/UJXFN8GTBXMfm
         CY9EZXYntxXhfiq6r5XajQSvwC2llqJYy9N0uPQp1eRmuQhQs5tbEEE/RDAfnF2tYMWA
         U4KOeTdVDsFyWTQcmWx1e/tYsSdW/lJTzWijYEYChDLgpOBiQTIkMARqC3tyH24hgfCl
         Vr7HpNlAzb52RY1x8ClMgnjwYQ7LYyt4PQlV23J4qpMZAua0jUbUZLZ4m8GYL0+AA0xv
         TRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776798828; x=1777403628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+nBi8NMCSPfGIscPWxKFWQOBdlvlCfORQNm2QzRooQ=;
        b=iW1l/AsIALiis7sx8XiODgpqxxVblWj0bS2lydBH16B1pshjJM+iBS4QfWud64wNP9
         x2tVxgUrLBXna0nOltuFVY3WiNyBST80eYFm03s453KskOe14Rckj2dTY8808+eibl34
         C2dFG1Sr9Ycxqux6t8TjvXZnLdcoWBxVMlAvvgsiKVwthA8tvQTfD/05YNG/wCwN79JO
         bm+4gUXC00jZc6xXHycRppiAyejrZuFEzLP7Hr9IV+G9e+c7QWm75o98m4sr1msHn/us
         b2/aZg7v1LkdSQ07rEiEwqUP89gOv4F93KMDpDcvkEcvf8HoEBt7JAKQCPuNqGl4hUD8
         q86w==
X-Forwarded-Encrypted: i=1; AFNElJ8d7kvkBMCJe+wkNvPA0PJ3kuaEAVFQOeyhbCg8mN3wwS4roY3FMIQKtEhpMUzBSJMGHDFA6uPa/Q==@kvack.org
X-Gm-Message-State: AOJu0Yw6z4tQhhB6x6DB7sJC5FduM8XAGUEpSppZU/0y+jGuyGMgjP7W
	BvykSHsZ8BB29OAVulakok7Ke7uOSduSrDWIdB58Ii4ZBUNtHHVCgDzYVJQ33irOWKEEwCVHIeF
	hDbBlnUykLVVVvcCoduQiqeu/Zdziuldzt+bm93tG
X-Gm-Gg: AeBDietfpUmT4QpzZrfemxE2jfIhqE6jnSbR6eznZrCzbBdCRUiLFCZM5E6WdtdNP1Z
	8FD7amXA91JzA2Z/IRB07evaPwwWL5FA9oQNaHhKJG9jHg2lPtP5tCavZXTDDRZTFtpPuXbPBiX
	P011t6pX6WwadGirZ8ZDYb8/msZqiCUBOWZ61Ba3ZlSPh0YOszxA91fsVsMCmnTDGGt5VRfyA74
	+UtJ/dV3WFg1lSS8THVbdlznVnK7G5drk8uLOrg46jVYezh5JBbz2FHjsu/vBQ06gaEvVTKroc8
	Kzl0oeEcqmqAAeXMQubybFt5FrYhXTpQdx3LOZL3DlpxDixgPr/y8cNR+k75pcCfjLMF98E=
X-Received: by 2002:a05:7022:4199:b0:12c:2cf8:2f30 with SMTP id
 a92af1059eb24-12c73f83616mr10488523c88.15.1776798827054; Tue, 21 Apr 2026
 12:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260415143735.2974230-1-elver@google.com> <202604210954.84C57E5E0@keescook>
In-Reply-To: <202604210954.84C57E5E0@keescook>
From: Marco Elver <elver@google.com>
Date: Tue, 21 Apr 2026 21:13:10 +0200
X-Gm-Features: AQROBzBMsDbE7_dyhVt5xWTROldThQNRDRm_VJxxVveH1z3BL1b5nLG0UUHDDRE
Message-ID: <CANpmjNO8CcR56LXAQf4GQhGcbU4MQkRCa7gVvwuAfvVrzEUhQg@mail.gmail.com>
Subject: Re: [PATCH v2] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, 
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>, 
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>, 
	Matteo Rizzo <matteorizzo@google.com>, GONG Ruiqi <gongruiqi1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0917D180009
X-Stat-Signature: 5uysi45yhgg7oc6stwwmczgoc71qsufz
X-Rspam-User: 
X-HE-Tag: 1776798828-992225
X-HE-Meta: U2FsdGVkX19vbxCqlF93bd6wSLUi7ovJ5pTcIRtn2qnx+oRl4Bk3dlezkxQ/w8VBGK/hjNFHeqxDTBYOX2D6qVuK3PfM46GjT+TIdXddRQz9o8mlabUIE3+ceEKORZ5LVx7Zfx2CsnWhc3VkeYQu2exIh2IykbYQKV89y3GpR7P3BVgmg5UW/IQisZo53FkPcoGiyU35bCKaAmwdXHqcdpy85WU0xJ9SRVTkXdTbJCh0v2cTMyFUh4BZqRgqvoAo/SR9PwPqE6JKgB/s+2h9Zb9o8dyfzXziIDCPcHhrPEmuHKLL6LxxknSN5Sj92FNpailTqeLx4ougLP48KdKorM2yqu3hNaTAC6Um8RDu3O58IgH1ItKQYaWPabGHgOZ+vT5fIewlbyJuiuYaZp3kwbJUhm8opyFOcKf4IT7fTvAENl3hX6uoQUVKmpyXTtnvSHKpa0uCykZX3TnhspYiniq0IK9Xr12grsR0IK7jTlnas0OgOikH4YOH8sdBJ4+59yQo+coBqv16vTiUix8ChyyLTv/YvJm/j5wIqf5Jv8FIovf+x4UkF/RoX+EnDPs43qwwIwZ2zcx8uFSjHNtBe5ktBigEuL+TdCjkQX8k1ejclvKMrk72Wgre7QfuzCMJU/LuV3rjLcHYzjAhmXWsWcsa57ExO9RUXrp+8uzSrvi4MufCw1g/gB7lLU2KZK8h91AXxbh1KVS4PJigckSDSL+4YpHs2ZqlbFxlgvk3q6VjaK2/ka7nV+giSUGOnvY9VzOW5k0gWrKczHvQNTE0/B1RJX6gtbplbuCMOBT1gKOw6pAxY0aeeqba+vGrsV7GSoAqCfFbaG+wEBO4/r37CLv20pXZ5UjCzxp1hT3AlJte34PrYUQDdMh4xIt7QMhhuKoDchWM+Qd15vDMKRsds1rIhAJY/mewz8NTknJ1s36CKfksStF6VbKmR6noIzyA7GqTXgH0d4jjC8ogvdJ
 px+RubWW
 cs2h/FviQCBW/6uEiEy92ASfa1rDxZdJNZgl23mEm6VnrU9C/696tND0s8DOb+uCFmWA2DLKCijW/0vomFUo1Yjho0sMhoVQRJRJ1mwoV+r03obDmaeEY7/w2SvmoTW9e1bqvkIgxC7VeNKqBKtDoxppOEUt7jaO/y9b0Lhf6Q4DEV//0pxYMc7yTfXn1j54fyK8ZDf35M0VCNhpaeA2vnLy9hYh85ncruv6qXI8SV4/1Au1Tm8L3CYxybTE8KcaK9mfEXzLvC8lb1bFmQvKdEqrCcZdU+d5osbW7v8YIxA3y1rfJguyr8w0FlclciSmVBVctDw/1fbn3WMLnyTwp/36G9fDpb5SmFVwNI1au0c9doXlh1wqW2wppPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Apr 2026 at 19:22, 'Kees Cook' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> On Wed, Apr 15, 2026 at 04:37:05PM +0200, Marco Elver wrote:
> > The builtin __builtin_infer_alloc_token(<malloc-args>, ...) instructs
> > the compiler to infer an allocation type from arguments commonly passed
> > to memory-allocating functions and returns a type-derived token ID. The
> > implementation passes kmalloc-args to the builtin: the compiler performs
> > best-effort type inference, and then recognizes common patterns such as
> > `kmalloc(sizeof(T), ...)`, `kmalloc(sizeof(T) * n, ...)`, but also
> > `(T *)kmalloc(...)`. Where the compiler fails to infer a type the
> > fallback token (default: 0) is chosen.
> >
> > Note: kmalloc_obj(..) APIs fix the pattern how size and result type are
> > expressed, and therefore ensures there's not much drift in which
> > patterns the compiler needs to recognize. Specifically, kmalloc_obj()
> > and friends expand to `(TYPE *)KMALLOC(__obj_size, GFP)`, which the
> > compiler recognizes via the cast to TYPE*.
>
> Great! I'm glad this gets deterministically handled for the kmalloc_obj*
> cases.
>
> > Additionally, when I compile my kernel with -Rpass=alloc-token, which
> > provides diagnostics where (after dead-code elimination) type inference
> > failed, I see 186 allocation sites where the compiler failed to identify
> > a type (down from 966 when I sent the RFC [4]). Some initial review
> > confirms these are mostly variable sized buffers, but also include
> > structs with trailing flexible length arrays.
>
> For the call-site-partitioning series[1] I sent before, I had
> per-site caches for fixed-sized allocations and size bucket caches for
> variably-sized allocations. I'd like to see something similar for this
> series. Specifically, I replaced "kmalloc_slab" with "choose_slab" that
> did O(1) to find the dedicated cache/bucket for the allocation[2].
>
> In this case, we now have a build-time-constant value that it should be
> possible to use to look up a _single_ dedicated cache/bucket for the
> given unique type: there is no need to do hashing.

That should be a separate series; I know what you're getting at, but
it's a significant rework and a different design with different
properties. This simpler patch is likely ready for the next merge
window (once I send v3), and in light of recent developments, I'd like
this to land sooner than later.

> > [...]
> > -config RANDOM_KMALLOC_CACHES
> > -     default n
> > +config PARTITION_KMALLOC_CACHES
> >       depends on !SLUB_TINY
> > -     bool "Randomize slab caches for normal kmalloc"
> > +     bool "Partitioned slab caches for normal kmalloc"
> >       help
> > -       A hardening feature that creates multiple copies of slab caches for
> > -       normal kmalloc allocation and makes kmalloc randomly pick one based
> > -       on code address, which makes the attackers more difficult to spray
> > -       vulnerable memory objects on the heap for the purpose of exploiting
> > -       memory vulnerabilities.
> > +       A hardening feature that creates multiple isolated copies of slab
> > +       caches for normal kmalloc allocations. This makes it more difficult
> > +       to exploit memory-safety vulnerabilities by attacking vulnerable
> > +       co-located memory objects. Several modes are provided.
> >
> >         Currently the number of copies is set to 16, a reasonably large value
>
> The "16" buckets seems to hold for TYPED_KMALLOC_CACHES too? My goal
> with the earlier type-partitioning was to get _total_ isolation, not
> simply bucketed: 1 cache (or sizes-bucket) for each type. The "16"
> limitation from RANDOM_KMALLOC_CACHES was kind of arbitrary due to the
> hashing.

The token ID is also a hash, although it can be configured to be
unbounded to effectively give unique hash per type. As-is, limiting to
16 keeps it comparable to the RANDOM mode, albeit IMHO with better
isolation properties with the same overheads. As-is, performance
properties of RANDOM and TYPED are comparable, and the friction to
switch between them is minimal.

Unlike a completely new design, which will have comletely different
performance and memory usage properties - and wouldn't be comparable.

> >         that effectively diverges the memory objects allocated for different
> >         subsystems or modules into different caches, at the expense of a
> > -       limited degree of memory and CPU overhead that relates to hardware and
> > -       system workload.
> > +       limited degree of memory and CPU overhead that relates to hardware
> > +       and system workload.
> > +
> > +choice
> > +     prompt "Partitioned slab cache mode"
> > +     depends on PARTITION_KMALLOC_CACHES
> > +     default RANDOM_KMALLOC_CACHES
>
> I think this should be adjusted a bit:
>
> config CC_HAS_ALLOC_TOKEN
>         def_bool $(cc-option,-falloc-token-max=123)
>
> ...
> choice
>         prompt "Partitioned slab cache mode"
>         depends on PARTITION_KMALLOC_CACHES
>         default TYPED_KMALLOC_CACHES if CC_HAS_ALLOC_TOKEN
>         default RANDOM_KMALLOC_CACHES

Sure.

> And actually, perhaps a global rename of the options so the selection
> naming is at the end of the CONFIG phrase, and bundle the on/off into
> the choice:
>
>
> choice
>         prompt "Partitioned slab cache mode"
>         depends on PARTITION_KMALLOC_CACHES
>         default KMALLOC_PARTITION_TYPED if !SLUB_TINY && CC_HAS_ALLOC_TOKEN
>         default KMALLOC_PARTITION_RANDOM if !SLUB_TINY
>         default KMALLOC_PARTITION_NONE
>
> config KMALLOC_PARTITION_NONE
> ...
> config KMALLOC_PARTITION_RANDOM
>         depends on !SLUB_TINY
> ...
> config KMALLOC_PARTITION_TYPED
>         depends on !SLUB_TINY && CC_HAS_ALLOC_TOKEN

There was a comment somewhere else that even introducing
PARTITION_KMALLOC_CACHES might confuse users of RANDOM_KMALLOC_CACHES.
I think completely getting rid of and renaming RANDOM_KMALLOC_CACHES
has marginal benefit, and will cause friction for existing users (even
moreso than already). I see little benefit here, and would prefer not
to break user configs more than needed: configs that already set
RANDOM_KMALLOC_CACHES, upon rebuild will be prompted to enable
PARTITION_KMALLOC_CACHES; if user says Y, then their previous
selection (RANDOM) would already be picked and they don't have to
rediscover that it exists under a new name.

I can make this change, but only if you're sure the benefit outweighs
the downsides here.

Thanks,
-- Marco

