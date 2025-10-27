Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D659ECCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 10:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D9880032; Mon, 27 Oct 2025 06:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DF38000A; Mon, 27 Oct 2025 06:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B7280032; Mon, 27 Oct 2025 06:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05ADB8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:10:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF45AC0552
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:10:35 +0000 (UTC)
X-FDA: 84043474830.22.264ED7A
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id E22EB14000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:10:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JhGvuNde;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761559833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUhyKQSng3Y0nFruy6J+JGnvlCGsArioA9tG6LAGPJM=;
	b=z6lyAbxQ2U2EZqj0jAcgZF9DqyUA3aosdkJvTD0I8V3IHbtaJ98w2FaDyQZWXXTYH4gAOp
	ErGXGfRv2Yh2FRUMENvitHBFkkefoH6+aEJLIagAeRO4oNcIXOPBaplKg5dtXM8cZKkkHg
	US3hGRpK95rYNZwhsf/jLFovZuXvXiE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761559833; a=rsa-sha256;
	cv=none;
	b=zQS5yn0dGz3n06KKmnaxorYdL9/IWOl1yxGg0fyFTOf5uyZa0PFcVCnz2B7JyI/zm09zih
	hyBL33f2iyLCoAYMAK270e70rgR/eDDgyxLlQ1OC2y6ySC3EdUEh9JrHwdHBGvlLOPA4SQ
	v/Oc+XEItQax3RPv7NaRGfJOAVB4oYQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JhGvuNde;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-63bc1aeb427so4636628d50.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 03:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761559833; x=1762164633; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wUhyKQSng3Y0nFruy6J+JGnvlCGsArioA9tG6LAGPJM=;
        b=JhGvuNdeNVaNtpX4zKQtHodPhDZ3lBrfOZjWR0IO8hgUNK4ftTQ5cuQ4ZqCgZkod42
         lERMwN5uYHjq71xrI8iOfsYDuOS2FCHrmkvlgYQFqcUjBASkd6KdoKkHLDYXYGQWXhwX
         sXlPo8+/UBNw+8EVa1IO5HS+YX6j/K67uGTNu6QnqwnGsYFmgsZeNoGUth4qoqJNGt7m
         LeVmmvE2STsRhBS9KpwR0u/v5+Dk9HoAjyJQ/OtRufVPX1ZOhAPRBx/ygSA3z2ZPrxNK
         eJM6fkvx7NcTyxF0cEAFJ9ntNbCGXyXFAOZtUcEcVNxbxii6JMDM2K8WFpjWwb3tKNGs
         sVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761559833; x=1762164633;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wUhyKQSng3Y0nFruy6J+JGnvlCGsArioA9tG6LAGPJM=;
        b=fSiLcOQFPH3KKKWkxZdQJvpeXsz3uXs20PUkUOYceZ3MGfozF+HKD9NS3OJXbcRp4I
         bnaWTtOBxGHw+KGw9LFy7GNpKVuugAprF9drT4gmBP3IaMrlhulxlIfyNXs6pjjiFnpC
         1TC3UJ1luQWfB1hDrOU/1Wau2SdW2XySE1wdj0fqubrH2joxrV1P9El17UkUvNrw5UEM
         Dicr1beNVJyNX15ia72hszd1eFiEB5KR0GYIEBEa14IxXtw/SUPhUVJYtGRTzO883fd5
         cYYQJOfA468AGQ6g9psiwRlgY9Rp0GJt2Kfxk8pLgdD9ppjNuzBNbo8+BqqZOcocj0bY
         BBEg==
X-Forwarded-Encrypted: i=1; AJvYcCUUcoUoDfpCb37kuqoM7SlTOotUckunsFpplcvE4Hpo58CJfzvpicKxRn6/Y6frYje2j0XFeikpRQ==@kvack.org
X-Gm-Message-State: AOJu0YyP0nsJd315Vg7uhxaa+AHEWNKummCr5saCMwT7+z10T3CWIdjO
	iFeneU1RUJ6uxCS8jIZ0RMetdY+wCtU3VFm0gVzseVh0PBmhCad5CUGFti1ocsmKSQ==
X-Gm-Gg: ASbGnctIoW/1hdBQRhTkb9/T+PkSHlBWu/M4hHFv8rywaYdbUvIbJ3gQhoUUJ7Cj9no
	PqKP5z/mERMBKWXpPOnO9y/R27pS0oAKM7HTuWsetrNrX1EIaetXfqfIAkTECiolCXp6WyUfOTH
	ZFoKrozz9pkWciUxoACMTKyzM+f40Rb9DPEgujAUQHnxZzZZv+GhjkxEsx7jctFQs0RTCCX8uW/
	SbS5QwJ6Sy8sxF0go2wPR77oUCilI7PDoPe2TIB0MBqeWuX73nx4FWXrgnVIbgjB2nK+ARDkDbT
	EQkljmW1dC5EBr/iXnZ8tEs6wrjw52NiviaZJpN40vr9BYQoeuXClrcfcw0rlauAY5Slr+nv5B9
	ndZZ41FhB0wj34AuFFwBsi3rW7dcf9txwkmloMAolfRJr91te9+1VJ3hfL8C1Shyo9tbhPtGtCZ
	lvkdbKCX5sKgg7bifA5gIQbUJ0Eri35QHO+jR1esjXDFTtC42puifGgo6EyRSV
X-Google-Smtp-Source: AGHT+IHAsqrJNcSoY8LjTbIk76DeRsubW3n8U1csW4hXw8uoXLM1KAlPHNJLv1iQQr1PXd5rpnOY7A==
X-Received: by 2002:a05:690e:155b:10b0:63c:ec55:321c with SMTP id 956f58d0204a3-63e1613dc04mr25781815d50.26.1761559832808;
        Mon, 27 Oct 2025 03:10:32 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785ed14081dsm17731987b3.6.2025.10.27.03.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 03:10:31 -0700 (PDT)
Date: Mon, 27 Oct 2025 03:10:29 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, 
    linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
In-Reply-To: <20251023093251.54146-3-kirill@shutemov.name>
Message-ID: <9c7ae4c5-cc63-f11f-c5b0-5d539df153e1@google.com>
References: <20251023093251.54146-1-kirill@shutemov.name> <20251023093251.54146-3-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Stat-Signature: cep8af694xu39inn5b7qrfwz96qn93e8
X-Rspam-User: 
X-Rspamd-Queue-Id: E22EB14000A
X-HE-Tag: 1761559833-796811
X-HE-Meta: U2FsdGVkX1/FfL5Hi52FklsGlr5viymk9w2G/AOfRGGgMxlwAJgvf/cQhiwiaRCiiEzynH4SKWF8pgldVIkXvTPNLp2t5UimjRdS8lCimY2Hgq9pubVcb4Oi9AEB36vKlCsY5q2lmdGeKHu23nEddONIqXQ1yjyRTeDcc4IEqZ6qT9r3HLEAWGYU3YupOwBLan7MCeBNRQ0whmxREmvRKUw1InI981yn3SqWQIMJ+HHXRRB5HBgsdl8c5NDGCbsPzZD4Pk6kKpldBtbKpCNDwRY8KOHDjQL79VWsNq7+vuvz/V5fECSxjwz8QspnzYHxrV61XWFSxm7mf1laFfkXrjTvlOtsqTBpEzbzT2lIPuKg42rQWy0rvynPnKJsLfF2zUCQ0te/1YsNZ6V5J1p5HPRZ1Puhunyktz5ux8MvReplnP6/qKHeZ6Z/amlmFrJvcBlTE1/qGoe99p3FIU/YqekdQ+cYW2fT+hYJgfTMd5duYeemOPGTsY3684JU90sGwPnOMbFWjL61gg3a0zVeyzKS7ZMWfmgC6o1PSjh7EDWT7SPpTDIMnvc25keW31CKtaWaZBu4/ft3s5EYjkt1DR5mcsSMQktvg8qkc3h/k7SzJeGEICtEYtkUrxhDfA0J+pyKWum+m5fJmL6JmssjYLf2f1wPmMXE36FLgfM8vzByau9Uoej1OZqMXKU1xbOPeaf2ViCkaMQ+lYPgfXa4y2aueSr2EMTKgeaQt9ZyU5+244tq3HL+pkDlcwmg5yeA36TAWm4011oa4xSLPsuzIxVPdAe7TE7BKPBUsoxgeRjPE8EA78nndvjysp3RXnD0XVE396UNEKRQyDPY7xxF2C8TpvUVlvuDrifHoTZT1semjjuktfQA7TsORKx0Xw3XJWZw9OC1ndogaSxfqZNx1hffrf9GZnDm48RK5kCMnVFojvjdzGugJoawU7g2Smg5RcEVPwq2rmaMjoLU9pL
 OuBh+Cqu
 l5LvrRtSReZH2YUvc1LXmaIgMmAvy5G876D7vXVRgA2Bp0T8iPjNaUrwc6Z/jOJLuw8VqSsOrehvmhDlPBH1q9Vzi4BKLMjZ8sHOh1Qs34QMJ3v5ollIn0KmZ1QlhpmMUjnW2ETqTQcBMEEckz2BBc/Xu9j3kKIEyam5yQ1F54GfCMdP6HLKiDT/wvtBeL1DYSLfbYv8tJaJWItyGMdiPoJ2TiuheZWKRM/83Xie2ovJm1dICPsiYav/Kw+rCyAFSWuJZOoQY8nFrBwMispNX9rRcC4n8WcpBo5+6vkrzMqPS6AnfH3iCzecKMKN4JwqORuHtTk+cbMUSBbHQzIju9rWJ4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025, Kiryl Shutsemau wrote:

> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> This behavior might not be respected on truncation.
> 
> During truncation, the kernel splits a large folio in order to reclaim
> memory. As a side effect, it unmaps the folio and destroys PMD mappings
> of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> are preserved.
> 
> However, if the split fails, PMD mappings are preserved and the user
> will not receive SIGBUS on any accesses within the PMD.
> 
> Unmap the folio on split failure. It will lead to refault as PTEs and
> preserve SIGBUS semantics.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

It's taking me too long to understand what truncate_inode_partial_folio()
had become before your changes, to be very sure of your changes to it.

But if your commit does indeed achieve what's intended, then I have
no objection to it applying to shmem/tmpfs as well as other filesystems:
we always hope that a split will succeed, so I don't mind you tightening
up what is done when it fails.

However, a few points that have occurred to me...

If 1/2's exception for shmem/tmpfs huge=always does the simple thing,
of just judging by whether a huge page is already there in the file
(without reference to mount option), which I think is okay: then
this 2/2 will not be doing anything useful on shmem/tmpfs, because
when the split fails, the huge page will remain, and after 2/2's
unmap it will just get remapped by PMD again afterwards, so why
bother to unmap at all in the shmem/tmpfs case?.

But it's arguable whether it would then be worth making an
exception for shmem/tmpfs here in 2/2 - how much do we care about
optimizing failed splits?  At least a comment I guess, but you
might prefer to do it quite differently.

Aside from shmem/tmpfs, it does seem to me that this patch is
doing more work than it needs to (but how many lines of source
do we want to add to avoid doing work in the failed split case?):

The intent is to enable SIGBUS beyond EOF: but the changes are
being applied unnecessarily to hole-punch in addition to truncation.

Does the folio2 part actually need to unmap again?  And if it does,
then what about when its trylock failed?  But it's hole-punch anyway.

And a final nit: I'd delete that WARN_ON(folio_mapped(folio)) myself,
all it could ever achieve is perhaps a very rare syzbot report which
nobody would want to spend time on.

Hugh

