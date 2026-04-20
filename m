Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9568BF557ED
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 09:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB026B00D6; Mon, 20 Apr 2026 05:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BA66B00D7; Mon, 20 Apr 2026 05:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5ACD6B00D8; Mon, 20 Apr 2026 05:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B43346B00D6
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:31:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 516611B8DB7
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:31:04 +0000 (UTC)
X-FDA: 84678415248.06.E046C49
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5332620004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:31:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SqYkHkac;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776677462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Psv86sYw6WRRa2dc8XVnn4F/sQNlqX7p+36B++yB2PI=;
	b=v+D6lBNpi9IOXa7fui9Z/LTssR7vQNOARbfJUOzk9a4XCe0fr0XPlBuRCyykN3VohFIbEk
	mkN8gaRj2GXoFbwDknTu5/b+u8xlB6xGl5JOPMkxnUt13hCWmPaDnO9A5Ag3BNNckPEcpI
	UtIyL25uBkaAPT2WymDNoPx+b3yjnBU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SqYkHkac;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776677462; a=rsa-sha256;
	cv=pass;
	b=IhuDGzh9gn3a6um/XQRWEzxEVjf/DoGkqqw6NXrDIvtkoc/PoxCApJYOO4FisOhiM04pjv
	qDjhniDg8ZfknmkUYwihjh110XpWJgT+OQV0jYN2CKrOq9ypR1yZ2i2pTBQGg/d/u9Jrop
	lqP1aBHbx5WbiGqbUGulqFRWvDUWipA=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12c8ca27c0dso137035c88.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:31:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776677461; cv=none;
        d=google.com; s=arc-20240605;
        b=BJW5R9lgjCccjkUHQAcyeKdNH161qlhLZ/ZQSRifzTj3kNX4tFnqxokBmLYE2Gu8vS
         nhlMOgIc2b3g5BmZo+92zmFwvP+TibITnnuB8LRno9kL83tJi969WSNmZfHM0Sb9lLlX
         6AulRkSmg6JIg327geVINUz32Hq77Xc5OKeoKu8uDjYaX6jTqdg0S+Gi6JSDL0Hm0IKv
         xp2p7mpeii7eUPm3CTT4hSkjT8ZgUFUQYBQ8gNNijH5c9NXB01MabPbUN7+WGmSFThHP
         P8liGb3tp4DPFPAuAYh9ElUcou6gHA8h8lFd9TkJ3L4S4SKbljeyzAs7+p8cEQsaVoZp
         wDUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Psv86sYw6WRRa2dc8XVnn4F/sQNlqX7p+36B++yB2PI=;
        fh=gTnJH/YV2w8vB8BkwuowYeZnWB0OKHAYtuMxHWvN6p0=;
        b=M4b8+wgkTRkgXpVCOB2puX/nyq2pg+LX9d8Tj69/aGuk2waZrNX1ug7847OdCNtCnz
         YFDqYIOXoGgHFTl7aJIaq0F56Frh9n5CF3n2KPBKIzylYUch8w4Uxtrr2mubS7IwbWj+
         3UM3c4r8ic5pOn8KBrS5k84bX6oYUTwc2t1ZaJF/5lHZtZdvkrUJfUomYbUmGc8sdKxh
         6EJNYoYPvtI3XZ4haCCesav1rge5Q/fiJaDRNDrndZy/IjWRkfkwemSAL7h3n4vXZO10
         IB9fAcrhQMrGAJRsc69XhlFpCGsKVhrPpuiFiouEH5+yo3KzHsaVpnUo8fyBQMyZ6VEL
         QHTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776677461; x=1777282261; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Psv86sYw6WRRa2dc8XVnn4F/sQNlqX7p+36B++yB2PI=;
        b=SqYkHkacpIRyM5BAxhDJjZqR5dNmg5iR5BNN+o+L3iDEQ5NEau6Y7X0o9ACd+BK36L
         hiuIyZOJU25ebKJpOQkPx3q8SLeaV+U1auFuncvQiwrHW7GbaJxDpwdFYI48zklRmDQe
         Wp1XiBW/qkGPY+W0hWSAs6t8+IjMoQthL9Z2wauzt25ErSUQjjn7CyF8UDUZbmQFL1Np
         y5WpZbMmO4ARir9nTi6GDyl2cwrq3Gz9xNNQlR6n18t0YREJz6827FkHhMEMr1xWAKJk
         Ay97PMMpfVhVzHu7pRucYqw8Amsfmk941k6BplwdfLbIkNDvtLO1B+0SCker4NsWuu4h
         fvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776677461; x=1777282261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Psv86sYw6WRRa2dc8XVnn4F/sQNlqX7p+36B++yB2PI=;
        b=rauVSl4bfo+08WBlSr8hdtQPOjG8wX7ofaoYkFL3XBcJ/RInltWVL/dPJElKE6mVe9
         Dar+AKcwDp+ZXlAST94+v8V80v/lNCO1l/hqS6Thas0nr4KmORhB4jQEj5tVIqf3mMgR
         5i7J30fTigcfU0yrXo/K3VGa4ebJZlZuM96ouLguI1e2Dx41iJZxB4qpXXA4bmDbTCnx
         x0EN3EfetEDLQu4F8NG8BZJ6aTlgiRpBPLEPRC/Lw/jTsE0H4zeBW5vp2SBOlWGZCGuy
         6Ogps2fOC2CjxMIIk/J54r33C3Tjit73w0aWxTGkJ+YOXomn2b9d4ABbASOxOPIn1K1g
         NIbw==
X-Forwarded-Encrypted: i=1; AFNElJ/7xz9rV4cAVuWHLsXQBKCa7sk5w2UNktJZA1NN3tDasrMpTfqjOlwMdsTeBdiYC5Lf+7H8v6qI7w==@kvack.org
X-Gm-Message-State: AOJu0Yx9BzI6nBvxFMlsjvpB6C9QGsrO0w04Kv248yBkoq3KiuZQf68s
	9dKbr+SFm57bPd7tzPLlVCApRSMy56ru9pP+GqbOuCRItImyCgDQgNjUB/JUyteEkSkV+BSOn1T
	g+P45bMbJa+9e/oOzkf4meZZrFLN9zJlq5Z0XoGFk
X-Gm-Gg: AeBDies3Jun3bMpnOfaFaQl7oP54i56PxV3JYTeb9quf7M4XPyWc2N2kNRWMQX/TgOm
	Zh6UOX6OoBgnfuWmUqp1SHLTMIMVG9Dd9CCFQHpWWfqGLxM4Oh49jSdKqJfDWgflgF6kG2JeUwl
	n9duK2vkhEKfFsTlvpJ5Ha27qBbF+W3lUcnDw7X52Swx+ftorIqCNgJu3nLqZu/O43HLg2uiAEs
	uT88zss7+mk5LFNIjycdI6xJ7cnehQQ/S5rwU0vITCkKfCIDXDKwQt0ix0LGuO8NR+4RXgIHKlr
	qp6Nk2ZcQAEEifjbmv4pr4/mCwdWSAN6kfas/vx19ejG9BgUjc3hddyKjNdV2Gb9vonJ
X-Received: by 2002:a05:7022:90a:b0:127:33e0:ea40 with SMTP id
 a92af1059eb24-12c73f7fbaamr5617278c88.15.1776677460282; Mon, 20 Apr 2026
 02:31:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260415143735.2974230-1-elver@google.com> <aeXU-wwGSwcx2dvy@hyeyoo>
In-Reply-To: <aeXU-wwGSwcx2dvy@hyeyoo>
From: Marco Elver <elver@google.com>
Date: Mon, 20 Apr 2026 11:30:23 +0200
X-Gm-Features: AQROBzCDqXBXEzcrST_0Skn6GXHUWSKau4IE3IO7VWholE-9v6QWyxVbFP_MsxE
Message-ID: <CANpmjNN0dYD8MB3PpPoxpz4ey2U9xA0w6oVO9hambtRwzSSkiQ@mail.gmail.com>
Subject: Re: [PATCH v2] slab: support for compiler-assisted type-based slab
 cache partitioning
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
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
	Matteo Rizzo <matteorizzo@google.com>, GONG Ruiqi <gongruiqi1@huawei.com>, 
	Danilo Krummrich <dakr@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5332620004
X-Stat-Signature: cwpxa5a77p6tmfx3bzm4h9kuqzfeanh7
X-Rspam-User: 
X-HE-Tag: 1776677462-145459
X-HE-Meta: U2FsdGVkX1/TCh/WPfrQ0idwzPSCIqHglAe9vyKrglm/QZ0A5w35dDxfSKfdXNR2NXlUzKK+zJ1WEVpzX9qTlGSFq+V2lXCbpUh4ZWq1AfwzUzVVtS7gOHiEIBW0f8Zu+t1LI62apcfX8WH1HG4vbqntPTuMXS7X6bjjQhfzNJ89BuELqq/wsh90U+BmOPLVZjLzLmYb7zKw08+H38PCE9wtvPXpVAHs8UwviYHxoMskPesqvewEAp4xP2BkYNUa/3jv15ogZi3q7ynYr8R/JY6BxyQodW1KKP47oKhNajLnJMgcohW1Y0xYlBt36YYNE4rB0G4cR66DK3FEDwrv3Nwd+a8o5mofkOvXzAFaQtP/HCQfAAWwMy0cHYiUD+GWJzZY3gxFqPNeV9Hrwr0mUigiwaDGhzLnyFc44LDnF6GDngkPqA5hiN9KhwBqyA+DIn6aAhWl5SAB+AC5q0+TSe+Ew8seYGmSFxh++kBCNgInL3TdSC2YLA3q6QDKplo+GK+L6Bjwrh1B+BTn6CjJXh1tAMSdG5FyPsUvX+Q3YAsnK1OQrtar5jWhOcGJNps6A4TMk91m52lX/1US/vqy8ds3ZUVjIBzP7fr/SR77lO49b1PGkvWUqx8qLkyHr60Lbwd+zq8EHyNu9hFNnfQJbZC/4ixXtKT7mqR87n1O+/Qjy4vd4Q1NEsftB3zTHo+H1Q/pPoxQYvvo0D0R27cRgg0CFSc1v3sYXOF1Vl3yJjphTKon9XFfvMoqny9MFmos3lmkT2YLsaL3pXVOzfmwOQazEDtK3YPVx6sgRCj2O1F95H+LhzSgGovoVGs+pmhXcjPczUR3JVh1TjY5Xf/EugIMo9myAvG+96JBmkxn2essgN/cVtTkYwZh4ZAP7dkEnzHAQgpkyQF1BF6ZsX0gvSKnjjxNdX19fVGHUc7bFXrbmzF/gHyI5oosqk5kYBVhcKGjoHxK5Lmc/AHthhp
 vi4PE/w5
 mF441QXcjE3NqOPBZE0qfyOxULQaZFawZECTO4q+Lxihi2mBbxTnXyVBAWBpQNKv10w8mX5LHRNVvsXWl06HMJrpmhNnUfbCn1huBz8cCG8g8Ur7tcEa+WbZajuophSd7bCoWPu/0sgrrOCqqv2KrvuM20wGeTJCYSM3we8Z7J0398b4XGbtykN74mheV4edvRqPDrGNEH50Np+8fo74MDFpbsQCBtSZaKY2KnudXj7xb9PczayTyQ8ZZiZxi1qQtH9AYdK/Z8j2RxymQ4GsKy95zc7+t2IHdH0iJk74M7ICBcUbOWM9dcGgeARbiUas8xVUC7P3PX311mH5gRmfWXajb1aTZ2A0jszwim/Ts4zUee6Os3YyOQLKm9hiZAt+7HXsejgbXgoyAXIdND0CVzJKIa4/JVB3AhifoVg6c9uGdkXBzCaRheeFDCrVl/hGdndUpO9l405jPnukc5FJ83VwnQAE0V96sFxETbCc8WrxeqEhOI8FPv9TMc1fwCU6e5neQqXIANVk3709uUMoESlAHq+GVhk47iH/XsizNpfjuGuxbJZVAkDfxqysRP+dohVKhhaiT1fLmlMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Apr 2026 at 09:25, Harry Yoo (Oracle) <harry@kernel.org> wrote:
>
> [CC'ing RUST ALLOC folks for rust bindings]
>
> On Wed, Apr 15, 2026 at 04:37:05PM +0200, Marco Elver wrote:
> > Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
> > flexible PARTITION_KMALLOC_CACHES, with the former being a partitioning
> > mode of the latter.
> >
> > Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages a feature
> > available in Clang 22 and later, called "allocation tokens" via
> > __builtin_infer_alloc_token [1]. Unlike RANDOM_KMALLOC_CACHES, this mode
> > deterministically assigns a slab cache to an allocation of type T,
> > regardless of allocation site.
> >
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
> >
> > Clang's default token ID calculation is described as [1]:
> >
> >    typehashpointersplit: This mode assigns a token ID based on the hash
> >    of the allocated type's name, where the top half ID-space is reserved
> >    for types that contain pointers and the bottom half for types that do
> >    not contain pointers.
> >
> > Separating pointer-containing objects from pointerless objects and data
> > allocations can help mitigate certain classes of memory corruption
> > exploits [2]: attackers who gains a buffer overflow on a primitive
> > buffer cannot use it to directly corrupt pointers or other critical
> > metadata in an object residing in a different, isolated heap region.
> >
> > It is important to note that heap isolation strategies offer a
> > best-effort approach, and do not provide a 100% security guarantee,
> > albeit achievable at relatively low performance cost. Note that this
> > also does not prevent cross-cache attacks: while waiting for future
> > features like SLAB_VIRTUAL [3] to provide physical page isolation, this
> > feature should be deployed alongside SHUFFLE_PAGE_ALLOCATOR and
> > init_on_free=1 to mitigate cross-cache attacks and page-reuse attacks as
> > much as possible today.
> >
> > With all that, my kernel (x86 defconfig) shows me a histogram of slab
> > cache object distribution per /proc/slabinfo (after boot):
> >
> >   <slab cache>      <objs> <hist>
> >   kmalloc-part-15    1465  ++++++++++++++
> >   kmalloc-part-14    2988  +++++++++++++++++++++++++++++
> >   kmalloc-part-13    1656  ++++++++++++++++
> >   kmalloc-part-12    1045  ++++++++++
> >   kmalloc-part-11    1697  ++++++++++++++++
> >   kmalloc-part-10    1489  ++++++++++++++
> >   kmalloc-part-09     965  +++++++++
> >   kmalloc-part-08     710  +++++++
> >   kmalloc-part-07     100  +
> >   kmalloc-part-06     217  ++
> >   kmalloc-part-05     105  +
> >   kmalloc-part-04    4047  ++++++++++++++++++++++++++++++++++++++++
> >   kmalloc-part-03     183  +
> >   kmalloc-part-02     283  ++
> >   kmalloc-part-01     316  +++
> >   kmalloc            1422  ++++++++++++++
> >
> > The above /proc/slabinfo snapshot shows me there are 6673 allocated
> > objects (slabs 00 - 07) that the compiler claims contain no pointers or
> > it was unable to infer the type of, and 12015 objects that contain
> > pointers (slabs 08 - 15). On a whole, this looks relatively sane.
> >
> > Additionally, when I compile my kernel with -Rpass=alloc-token, which
> > provides diagnostics where (after dead-code elimination) type inference
> > failed, I see 186 allocation sites where the compiler failed to identify
> > a type (down from 966 when I sent the RFC [4]). Some initial review
> > confirms these are mostly variable sized buffers, but also include
> > structs with trailing flexible length arrays.
> >
> > Link: https://clang.llvm.org/docs/AllocToken.html [1]
> > Link: https://blog.dfsec.com/ios/2025/05/30/blasting-past-ios-18/ [2]
> > Link: https://lwn.net/Articles/944647/ [3]
> > Link: https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/ [4]
> > Link: https://discourse.llvm.org/t/rfc-a-framework-for-allocator-partitioning-hints/87434
> > Acked-by: GONG Ruiqi <gongruiqi1@huawei.com>
> > Co-developed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
> > v2:
> > * Avoid empty function argument if !PARTITION_KMALLOC_CACHES
> >   (co-developed-by Harry). While Clang does optimize out the empty
> >   struct argument (and generated code is identical to before if
> >   PARTITION_KMALLOC_CACHES is disabled), GCC doesn't do so. So we need
> >   to fully remove the argument if not actually required.
> > * Cover krealloc() which was missed before, resulting in ~100 additional
> >   objects in the pointer-containing caches in above histogram.
> > * Unify kmalloc_token_t definition.
>
> > * Expand Kconfig help text.
>
> Thanks. I find the help text much more useful.
>
> >
> > v1: https://lore.kernel.org/all/20260331111240.153913-1-elver@google.com/
> > * Rebase and switch to builtin name that was released in Clang 22.
> > * Keep RANDOM_KMALLOC_CACHES the default.
> >
> > RFC: https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/
> > ---
>
> A few comments on V2:
>
> # comment 1
>
> I'm not a big fan of how k[v]realloc_node_align()
> and kmalloc_nolock() define and pass the token parameter.
>
> IMHO it'll be fine to use {DECL,PASS}_KMALLOC_PARAMS() in those
> functions, since SLAB_BUCKETS users already passes NULL bucket
> to most of __kmalloc*() calls anyway.

I'm not sure I agree. 2 reasons:

1. Even though it's "just" k[v]realloc_node_align() and
kmalloc_nolock() - despite their relatively less frequent use - just
put one of them in a hot path and you're sacrificing performance even
further. There are only so many arguments that can be passed in
registers (depending on arch), and may cause more stack spilling.

2. We'd misleadingly declare that these functions do something with
the bucket arg. This is wrong.

Both feels wrong, and would only make this change if you confirm both
are trade-offs that you strongly prefer.

> # comment 2
>
> This breaks Documentation/.
>
> Problems:
>
> - The document generator doesn't handle DECL_KMALLOC_PARAMS() well.
>
> - The signature of the function that users call (krealloc_node_align())
>   and the function that has kerneldoc (krealloc_node_align_noprof())
>   don't match.
>
> - Even worse, moving kerneldoc to the macro doesn't work because
>   it uses variable arguments (...)

Well, some were broken before, now it's just broken more. :-)

We could move the documentation to macros and switch to explicit args
instead of (...).

Otherwise, I don't see any way to fix this. Preferences?

> # comment 3
>
> Looking at how rust generates helper functions,
> in rust/helpers/slab.c:
> | // SPDX-License-Identifier: GPL-2.0
> |
> | #include <linux/slab.h>
> |
> | __rust_helper void *__must_check __realloc_size(2)
> | rust_helper_krealloc_node_align(const void *objp, size_t new_size, unsigned long align,
> |                               gfp_t flags, int node)
> | {
> |       return krealloc_node_align(objp, new_size, align, flags, node);
> | }
> |
> | __rust_helper void *__must_check __realloc_size(2)
> | rust_helper_kvrealloc_node_align(const void *p, size_t size, unsigned long align,
> |                                gfp_t flags, int node)
> | {
> |       return kvrealloc_node_align(p, size, align, flags, node);
> | }
>
> Rust code probably won't pass any meaningful token?
> (something you may want to address in the future)

Yes, it'll just pass '0' by default. We could force Rust's allocation
to be in the pointer-containing range - if we assume Rust code is less
prone to contain bugs, but the assumption is that such allocations
both originate and are confined to the Rust side. One easy way to do
this is to write:

       return kvrealloc_node_align(p, size + 0 * sizeof(long*), align,
flags, node);

But I'd defer that for now, until we're sure the above assumption
holds (Rust originated + confined).

