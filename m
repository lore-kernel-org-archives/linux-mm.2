Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81CEACA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 10:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AFC06B01A3; Tue, 26 Aug 2025 06:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FEB6B01A4; Tue, 26 Aug 2025 06:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5754D6B01A5; Tue, 26 Aug 2025 06:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42BD86B01A3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:46:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6EDC139A33
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:46:00 +0000 (UTC)
X-FDA: 83818578480.22.FBFC24D
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 17A1D40002
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:45:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NlCKuFu8;
	spf=pass (imf17.hostedemail.com: domain of elver@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756205159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGOLh5cQuaV0+vt4hcjFj06C3bqSM1fNgF6Sjp1p1nM=;
	b=Se5IIJw2fuTBT//AyQYrg0wRuVRbkOsxm7JeTkIJUyLTQm0Q4/h9FuAhwVnKwaZrqmA75M
	Gh8AAwBQCQxhdROpC07ixREI8mldeUgVjFIwKkl2BzBmkqkjiWyI0XAOtFtayYHAK9/grx
	bUYTgFj5o2kgXMnCabP1Sh+BI6PABaw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NlCKuFu8;
	spf=pass (imf17.hostedemail.com: domain of elver@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756205159; a=rsa-sha256;
	cv=none;
	b=ggXV18xzEC+Z8alFUe51jDj2IKkd5S3A4ycRMXEu1x5kV/+GUHyN7io1nziLbmi/KvGCqE
	YzFiKuwid94HWog/VCHUBe2dshk99oE5h7JlRgnsFyH6l1HWgJbB8qoXxZBFc6jeBcMa4i
	a3AJxZh+eIwdPjRX0vaYsHx4b7TU0to=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2460757107bso49645975ad.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756205158; x=1756809958; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGOLh5cQuaV0+vt4hcjFj06C3bqSM1fNgF6Sjp1p1nM=;
        b=NlCKuFu8RM14wPBeVRDP4RcEitBxI1UbZCryV288C4Bc6WtWmNZ8QGzyBDTZlopSb3
         6J/q5W8g3fMumUtz4jL0wP5pyHWv9IEScIXqbnycsetjjaYsHLqtsIWM/Flt6AwLg92p
         kuNkk3AYykpClLVctGsS5yVffnVLQdUpJxYpfw4pCSnboT2j+Uo6LYRBaDPZdc3Ayg8m
         fyzGhsPLc19YCDo5oTKtpc0qCEiqrHDRjWMh39qX3vLQ33Cj3pTTbCpQ7aVZAX2QMcKk
         2lv9QUxesqUusYtlXeytQaZ2PM0/d22qrXjNnz6290Eq2G8/c0scBrcHxRHKkYk1bHmO
         h2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756205158; x=1756809958;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGOLh5cQuaV0+vt4hcjFj06C3bqSM1fNgF6Sjp1p1nM=;
        b=NovL8C6NLo2fhYVr2mbOQ33T3nRWhH5k/y7QE3isiVCP3e9AIfoyq/OdT7TWZLkRmr
         GgKWZqL+isZ+ll6rcNDGg6+bUf6PucnaAWOmfV2DrM0WWsQL/XTz2hWUMTYxoJ8h2fu/
         Oofh3a3+j//d2ZOd0IFm/zpOYRfnGLmHcP1fEY9ez/rXxR1OtaThEaR+YbTtuqZLsu0g
         G3lAclpoNYY/9QQ70/Zf83kSgLOmAZ8uRcSiRAt9ROkG4q/7OS2MZuyfh4cuS/OMXpp1
         fNwfCSXkc1UVpDkiedbGjxf5U4cByr22GXQ0RSlxo+ISgeDf+8LaFX5QUqv2IvMpTtV4
         Rw8g==
X-Forwarded-Encrypted: i=1; AJvYcCVLfcwGsfxXwe0FhPVg1XuCyjGC4PejMFxqcLUCVGnZIU61/WteR5JkE4k9I7TQ4/dFHNG/kKLFdg==@kvack.org
X-Gm-Message-State: AOJu0Ywj/tlTYYgxJBjgDtOhqTVpWMqiDb+ftV5+xnS0qc2UA5GA4b1A
	UpkF4107nBk0/8kjgiXNE58rDVwbR1sVtP9le56MIMZfmiNJsQNScSI4nKdefgBrOHaO+OFilS7
	G3iTDGLwPSJic2LcUsNfC2ScI1vwFJyGBbXFEdfJe
X-Gm-Gg: ASbGncujNtVCKvARA+u26ExCcl+PMc8AWEfLdSQRwWgKEid3eI6Ar4BBR9fQzncZzR4
	+x8YLbs3x5vGFpcN7QdOc7SxQmCMVKZr04ZSwaISuwb71XImhk58x9e7Mh5oHzDypunUwSWksws
	vb/jxoT6SN+8Ni2qr3yKZFOE0o4ScWf0cBttFjkvK6L8qifMLcFCTMA0FDWC5Ljh7kv3wbvPIZP
	QSVtLX1sinV3k5lHpxOxDP4654=
X-Google-Smtp-Source: AGHT+IHaZIymcSNO51VzrGvkl+EzFgf+EwvT7kBpe3gUWu+Fy0TGd2k7zRtskb+cPodn3Z41b2nZl1YDZatmO+4LcFc=
X-Received: by 2002:a17:902:dad1:b0:240:8262:1a46 with SMTP id
 d9443c01a7336-2462ee54512mr199229855ad.25.1756205157527; Tue, 26 Aug 2025
 03:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250825154505.1558444-1-elver@google.com> <aKyT2UKmlznvN2jv@hyeyoo>
In-Reply-To: <aKyT2UKmlznvN2jv@hyeyoo>
From: Marco Elver <elver@google.com>
Date: Tue, 26 Aug 2025 12:45:19 +0200
X-Gm-Features: Ac12FXxpah0HkZevruBg4QeHMNDjWXsh7--6Kjx5Kp37atP55Mt7D7-5zFmt0B8
Message-ID: <CANpmjNPUsbkyg5VvzUSYqVvaScXpqdfsb_oq2PuKV6VbkZLqFA@mail.gmail.com>
Subject: Re: [PATCH RFC] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, David Hildenbrand <david@redhat.com>, 
	David Rientjes <rientjes@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Florent Revest <revest@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, 
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matteo Rizzo <matteorizzo@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-hardening@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kcsrgmix7ngxup8kk95n61b3zu8gy69o
X-Rspam-User: 
X-Rspamd-Queue-Id: 17A1D40002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756205158-248358
X-HE-Meta: U2FsdGVkX18/7kEk+jgTtat7ZsqsyLRYtWRiBsSc5wgdQG1cfhxdTyX1+uld8F3YTxl/Su2+Xxf0QU8oG6siURT8mPZlMir5JLEmDp+rhNUE9z0JI0tnjo5cTZe34H6GMNKg0xpXW2w9/uLEXljADWfVeDFQGaj2QwtDNjoGuPJ11E9BaDbZ1tw/o9hDPjuf0ISeOZmfG3MKJUTQ/GpUYMNTkS85AljLEiEBkiN+hF8VIhT3H1F64RrsMzobtEfX6JJnGJgfsiG05P41c7VY9UvcfdGiCOmATKk9QbD+gOy/uq9tYFfnx90Lj53LXJk5+PkGB4ya4vHZseGtRm53BgKn+Z9ZFvSm7DaBl3A2ygc8oPXS30oqqA4S3RG4WQEpJrI6H69pjHf/HLCNzVSXEz4AySg3aiMyoENHWHXOWtQM8VM5Yqf5KWr6im5h8sJxIfLWjZiVU5Gp+Od0lAq/sjv/C3wmEJblqo9aDzWVVmGklRZnk3mZKnOTIeqkTexTnmlCYlyV/4VYjmJCkv92+gHFnLP7y6MWBS7qAjNNGykws8ZVTcGAlBC8EMl6BWW//8GCXNymo2ATOt9/feWfKeMiNXbhuDqJW6Xp1WP7++95HxHWx5UctPR8X7tlf8kpWAKbG4mO0ED0NHCAkznjFqQ2ennrImEaAGBCksJ1wXJKVyr9xftetwND4jMn5Kq0Zlg6niD6G1O142YGklb9SgsZpwIoO/cZBn9VF1EC2p6/be8IgJXcucw+dJ5Dx6r3+NoIPWq/x8hzJxnxrvRkJzktYgNItFibr162MW+fs50XGdn2uCP8pSe3dvioQPEWFJEqGtkjAO7AyadzqOVuq0Yp0ODLNXx7uyQnht4VLfO8ffTDs5YV3QP+amMkFRmdDwuM/OVk86yJv2k/eur8OWoaOfo1n+lDrmTvNQOUGzCZCGL6DcjthAKkUmgOSaaUJvFCJxf7HJY12ruNEVa
 fhvmxxTK
 jGOIRIHdvN6l/w5HGSaHaztq8PMAeUZdWk2vDVzQ9YqjKa7z+QZTBz9iwIosruNDHR9AMJjyt0FVW1vzGx/ahObLsWGWTkomk6H4BATq35ngQfUz8plOLIO8pDdWWU5wGTGe3NZibBgmBnK+PEdckJ0QqGEdBRBJfaQQwBDp4/XkCr6Ywfs8NWWtGNiuGNxf3cpDLujjwVb81KDnwCgE5v91agf2JPBZL3v9IAK/19EElBQJji0kf+4MEYNJz1m5E8GM7zRdCmWh7s2r3cz/Alc3moA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 Aug 2025 at 18:49, Harry Yoo <harry.yoo@oracle.com> wrote:
[...]
> > This mechanism allows the compiler to pass a token ID derived from the
> > allocation's type to the allocator. The compiler performs best-effort
> > type inference, and recognizes idioms such as kmalloc(sizeof(T), ...).
> > Unlike RANDOM_KMALLOC_CACHES, this mode deterministically assigns a slab
> > cache to an allocation of type T, regardless of allocation site.
>
> I don't think either TYPED_KMALLOC_CACHES or RANDOM_KMALLOC_CACHES is
> strictly superior to the other (or am I wrong?).

TYPED_KMALLOC_CACHES provides stronger guarantees on how objects are
isolated; in particular, isolating (most) pointer-containing objects
from plain data objects means that it's a lot harder to gain control
of a pointer from an ordinary buffer overflow in a plain data object.

This particular proposed scheme is the result of conclusions I
gathered from various security researchers (and also reconfirmed by
e.g. [2]), and the conclusion being that many successful exploits gain
a write primitive through a vulnerable plain data allocation. That
write primitive can then be used to overwrite pointers in adjacent
objects.

In addition, I have been told by some of those security researches
(citation needed), that RANDOM_KMALLOC_CACHES actually makes some
exploits easier, because there is less "noise" in each individual slab
cache, yet a given allocation is predictably assigned to a slab cache
by its callsite (via _RET_IP_ + boot-time seed). RANDOM_KMALLOC_CACHES
does not separate pointer-containing and non-pointer-containing
objects, and therefore it's likely that a vulnerable object is still
co-located with a pointer-containing object that can be overwritten.

That being said, none of these mitigation are perfect. But on systems
that cannot afford to enable KASAN (or rather, KASAN_HW_TAGS) in
production, it's a lot better than nothing.

[2] https://blog.dfsec.com/ios/2025/05/30/blasting-past-ios-18

> Would it be reasonable
> to do some run-time randomization for TYPED_KMALLOC_CACHES too?
> (i.e., randomize index within top/bottom half based on allocation site and
> random seed)

It's unclear to me if that would strengthen or weaken the mitigation.
Irrespective of the top/bottom split, one of the key properties to
retain is that allocations of type T are predictably assigned a slab
cache. This means that even if a pointer-containing object of type T
is vulnerable, yet the pointer within T is useless for exploitation,
the difficulty of getting to a sensitive object S is still increased
by the fact that S is unlikely to be co-located. If we were to
introduce more randomness, we increase the probability that S will be
co-located with T, which is counter-intuitive to me.

> > Clang's default token ID calculation is described as [1]:
> >
> >    TypeHashPointerSplit: This mode assigns a token ID based on the hash
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
> > also does not prevent cross-cache attacks, and SLAB_VIRTUAL [3] should
> > be used as a complementary mitigation.
>
> Not relevant to this patch, but just wondering if there are
> any plans for SLAB_VIRTUAL?

The relevant folks are Cc'd, so hopefully they are aware.

[...]
> > Additionally, when I compile my kernel with -Rpass=alloc-token, which
> > provides diagnostics where (after dead-code elimination) type inference
> > failed, I see 966 allocation sites where the compiler failed to identify
> > a type. Some initial review confirms these are mostly variable sized
> > buffers, but also include structs with trailing flexible length arrays
> > (the latter could be recognized by the compiler by teaching it to look
> > more deeply into complex expressions such as those generated by
> > struct_size).
>
> When the compiler fails to identify a type, does it go to top half or
> bottom half, or perhaps it doesn't matter?

It picks fallback of 0 by default, so that'd be the bottom half, which
would be the pointer-less bucket. That also matches what I'm seeing,
where the majority of these objects are variably sized plain buffers.
The fallback itself is configurable, so it'd also be possible to pick
a dedicated slab cache for the "unknown type" allocations.

