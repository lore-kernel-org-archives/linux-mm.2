Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 237CFC4450A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 00:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80F46B007B; Sat, 18 Jul 2026 20:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B321E6B0088; Sat, 18 Jul 2026 20:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47B66B008A; Sat, 18 Jul 2026 20:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE2F6B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 20:51:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFACD14049F
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 00:51:17 +0000 (UTC)
X-FDA: 85003697394.13.5ECAE16
Received: from smtp-190e.mail.infomaniak.ch (smtp-190e.mail.infomaniak.ch [185.125.25.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6E22E14000B
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 00:51:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=J7YfOIkN;
	dmarc=pass (policy=reject) header.from=ik.me;
	spf=pass (imf23.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 185.125.25.14 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784422276;
	b=XacGP5mQ6KaPin7ntuKQiDP1byIszsIWiSNVz40eqz4m8enZxSULYGBXiUl5zmOmWGXK8V
	84qeSM1kH8hVxo2lfZzAYWXpoRBNp1Agly9OjttifIz4HdM4tQ1BMYuOoHO4JFMBM0FW2z
	DoBI3MLes78VcUzkeGIaMzF++xBSiwE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=J7YfOIkN;
	dmarc=pass (policy=reject) header.from=ik.me;
	spf=pass (imf23.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 185.125.25.14 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784422276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2KALP2TBsb3l+hWdIh07QoScHkCaibomWa3RHfyOGY=;
	b=tVzVrVXrTjUZHheSLmQiAr3JmStvAbROlHD+QP6pXMOvgjwXVun7RfmOpL4JQLI/zMnOpu
	rW7BzVsYxCE+g8KhNxyhFJ1ihYApoAflRgiY5V+zxVcgpRAvn6nr2HS8/4g0IwplJdnRXE
	+hJbd/5uPwlzkIibpTmhWY1g8X7hUQY=
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h2lSx1SlbzDsF;
	Sun, 19 Jul 2026 02:51:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ik.me; s=20200325;
	t=1784422272; bh=D2KALP2TBsb3l+hWdIh07QoScHkCaibomWa3RHfyOGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J7YfOIkNtpyzXfS5cV2GtB7kQiLoUpIgNyTkYhOrf4rtHb91tTLKGibse+M0TSVAF
	 AsQscJ+aD0Tmt05gFmXzvzPy/v7L6iLCdRU4LIWf64CCqbJwtD0eTI5P+7Y8Wau2QV
	 daT7u6wKQuSy/syCgEVZ6fk6XPOYcDK7vYUehAUM=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4h2lSs5SgpzlGx;
	Sun, 19 Jul 2026 02:51:09 +0200 (CEST)
Date: Sun, 19 Jul 2026 02:51:08 +0200
From: Nadia Chambers <nadia.yvette.chambers@ik.me>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>, Hugh Dickins <hughd@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <alvyRRVgFTgO-tW6@ik.me>
References: <aZcmlIF4bmG0twkp@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZcmlIF4bmG0twkp@thinkstation>
Feedback-ID: :e0199cdf3b76464:ham:b89b32586f6d122
X-Infomaniak-Routing: alpha
X-Rspamd-Queue-Id: 6E22E14000B
X-Rspam-User: 
X-Stat-Signature: dmob4178o8645zr5tdcu58tf6n6cmhj6
X-Rspamd-Server: rspam03
X-HE-Tag: 1784422275-294680
X-HE-Meta: U2FsdGVkX1+cypzzWWZ08vzp6GIfaU6XkNVddvTq1Xgbpy0BF7juMiDvvdBGuAjpOYtQFry47kTuWaI6/BsodAJmAq0dWc9LypwnUrl52uw4mrO6xbvevmjsqICSVHwYJlAcouIfIkniNPv+nFQJx5HctGd0zP65Bhn9iEhu4zRi1iX0vE60/TWI4vwiKu4skVWmF3TiqCL1Dk2XhDDgLPL6LN54VHEIlsDxULHfxBy9zY2ZvRNAD4ZToPTQy+Ml3j/bJZ/h/otjSDU1QecPisOOUp3L0thDDsSt+C6nrPEicewoWdGvWC+hJzzkt0e/w7aKmBB3sBQLRwGt0uuL+v4NACRorckrGNtharFUASbgD5m6eGxaQegdGx/DeoIKQSkO46doKmOdxjCCJMryQm2c3PqQVBmkjSQL38V0x96iCfCZREJoIOxmmqdWHPtI2AQb2jbEv6KZc3vyuSJ1Oqs9WiVOsB5RwHZr7YQO4qc94xFlQRdb1zZPHTZ3euVOpwM6kleY9zmqZTEqMT55KNfqsgkxJsbUmSnBBHF9qp+CZsd8zoN9gIL5IXgZWhCfnvQ1qclUQpbTFnKFLlhMF0G/rJADHk3oo9MA7DjHB/yKI6OjnY5ubOIgOZ8YbZs1ccr9jXEVBF7uj1PNZ1p/2PExwvzfMJkl6V14fzmnkIG6AnMvhRzZGUfJJQJoyvIYaJlSCO2Qp3Ax8gJHei7a5Pd11b8nIji1/bBW5Ly/t+zXN0xGzL73FJuj8tKqA+mjiGjIeVrvCrCOrA0hy9Fltu8U4Egcn+26utU7G/Dyx1+ySF74E9L4Mp9UMoSZydx02RByNEVKw3qWSQIfQi5Na86Yj/36Oi+C+erULY5HWRwmzqtN7Xptlbxbxv2JsQH3K9b6Hdvj0Bs5iQQxEqMcdg9LgjDHNwhAuRqDBdGMz3TSTul3vc54azJUb9eeJsuzg2SKocKwZwbnXVqsnBR
 k3EwpfNk
 nZCY4YaIHHXp1M/iFkqNLaitI78B0UGvF+fHuFy/JDQodPgnOmMbSBvzzy2+2csDXA6OT39jUU2J+WVKB4X6HK3/CDUUsStfPt+GBwWYzXch2+nZsCIk4JdajF0W2753Sw6rHSsorA42cdrNZw3Yf8fQwivkOhgOgemiShWje7v1YRkw931ZsIeKa3s1vHkyo8o1U5jim8WT+f8InkJYaL6zmI1mzdP43jccntDvM+KeOuL7Tz+J3bY4EnOroNSSBC7M+6d8nnZhJTai4ck4ZFRRrILGvN2qWcJldHv9B0P035lmgG0LXKzqAUm/+k/aKhhT530Bag1VITEnNL9gPVcjDxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> No, there's no new hardware (that I know of). I want to explore what page size
> means.
> The kernel uses the same value - PAGE_SIZE - for two things:
>   - the order-0 buddy allocation size;
>   - the granularity of virtual address space mapping;
> I think we can benefit from separating these two meanings and allowing
> order-0 allocations to be larger than the virtual address space covered by a
> PTE entry.
> The main motivation is scalability. Managing memory on multi-terabyte
> machines in 4k is suboptimal, to say the least.

I apologise for my delay responding. I've been out of the loop a while.

As far as I know, the ABI compatibility algorithms are original to Hugh
Dickins from his 2001 larpage patch. I forward ported it in 2003 and
renamed it to „pgcl“ because „large pages“ had a major nameclash with
the „large pages“ of various superpaging efforts. Babaoğlu and Joy in
1979 introduced CLSIZE as part of their VM work on the VAX, though I've
heard suggestions it might have actually been McKusick or Karels, hence
the terminology „page clustering“ and the use of the abbreviation „pgcl“
from taking the „page“ abbreviation „pg“ from „NBPG“ and the „cluster“
abbreviation „cl“ from „CLSIZE“, as there is some lineage and priority
to their efforts, though they did not preserve the 512 B -aligned VAX
ABI (corrections from McKusick are also welcome, though this mailing
list might be a bit far afield for casually cc:'ing him).

The Linux parts of the superpaging efforts renamed superpages to „huge
pages“, though the well-known existing literature and code from e.g.
Talluri & Hill (1992) and Navarro, Iyer, Druschel & Cox (2001), where the
Cox of the second paper is even the Alan Cox known, in addition to other
things, for his extensive contributions to Linux. I'm unsure of the
origin of the nomenclature „huge pages“, but suspect Rohit Seth, from
whom I've not seen recent posts to Linux mailing lists, though like all
the other historical contributors, it would also be good to hear from
him in this thread. I strongly suspect the ABI compatibility algorithms
were original to Hugh and have cc:'d him in case he wants clarify the
origins or correct any of my commentary involving his work or otherwise
comment on things.

My 2003 code can be found at
https://mirrors.edge.kernel.org/pub/linux/kernel/people/wli/vm/pgcl/
I don't know of a link to Hugh Dickins' code from 2001, but it was
a couple of years earlier and far better-written than my forward ports or
attempts thereat of his code.

Scalability is worth being more specific about. Trimming a constant
factor is potentially worthwhile, but often one might want to go about
trying to make a difference in the computational complexity. In my 2003
IBM-internal whitepaper (dhansen had to have seen it, but it may not
have been memorable enough) and some commentaries on the subject since,
I've described it differently from scalability per se, varying by
whether the page size spectrum is dense or sparse:

	1. The sparse case is perhaps trivial, where the log of the
		clustering factor (your ilog2(PG_SIZE/PTE_SIZE) without
		a named macro for it that I know of, Hugh's
		PAGE_MMUSHIFT) gets shaved off the allocation order of
		the first nontrivial superpage/„huge page“ size, and
		maybe still-larger ones, but the small constant
		subtracted becomes progressively less significant as
		they continue their growth. I think there is
		doubly-exponential drop-off in availability as page
		orders increase, barring tactics to combat it.
		Empirically, orders up to maybe 2 or 3 aren't too bad,
		so choosing a PAGE_MMUSHIFT so the first nontrivial
		superpage size is order 2 or 3 can be reasonable, though
		with page size spectra as sparse as e.g. x86-64
		(„Sprungfaktor“ might be worth borrowing from German) of
		2**9 == 512, it's already 256 KiB, which might start
		raising zeroing latency and internal fragmentation of
		concerns, which can be algorithmically addressed via
		e.g. tail packing the pagecache into MMUPAGE_SIZE
		-aligned fragments for the perhaps common case of many
		small files and slab allocating many things now
		allocated as pages and more.

	2. The dense page size spectrum case can go about mapping
		individual PAGE_SIZE/PG_SIZE -sized allocation units
		with many different translation sizes. This provides a
		guarantee that so long as the size and alignment allow,
		the superpages/„huge pages“ up to PAGE_SIZE/PG_SIZE will
		always successfully be allocated without fear of
		external fragmentation. This guarantee was of particular
		industrial importance in the „forward-looking to
		64-bit“ aspects for proposing it as the solution to
		32-bit large memory's struct page array virtualspace
		footprint problems, in part because at the time „64-bit“
		meant IA64, which meant a dense page size spectrum with
		a Sprungfaktor of 4 like MIPS and the VHPT inverted
		pagetable, perhaps more like SPARC. (Here, XKVA, later
		done by Ingo as „4/4“, was the „32-bit hack“ to be
		avoided according to the advice I was given and the page
		clustering strategy was intended to be the
		forward-looking solution to the struct page array.) The
		interim since I worked on it has been long enough that
		priorities differ now.

These more specific motivations may have more force than „scalability.“

As far as completeness, in discussions about mechanical coding assistance
of a certain type, I used page clustering as an example of something
some of the algorithms might have trouble with. While trying on real x86
laptop hardware was late and not the subject of the majority of the
thought, it was able to get that up to running a GUI and starting up
some Electron apps in the start-up at login list before anything goes
wrong. The regression testing matrix in QEMU was 20 architectures with
PAGE_MMUSHIFT values of 0, 2, 4, and 6, for 80 cells, with the
regression tests being LTP and something called mm-stress, which is I
think mostly a script running various arguments for stress-ng. I don't
think QEMU cuts it and some sort of real hardware would be far better to
use if one can put together the multi-architecture testing lab with
terminal concentrators, serial consoles, and remote power controls etc.
Brewing up a kernel de novo as a vehicle for it all almost seemed like a
good idea at one point. The Coq, CBMC etc. models they produced are also
a bit weak for checking it all, and I was particularly dissatisfied with
their not directly representing user address spaces in the models, never
mind the concrete C (and I guess Rust is in the mix these days too)
rather often leaving code unswept right beside code it just swept, and
the stack top code looked off, too, and environments weren't being
inherited properly, but it seemed better to approach by extending the
verification than directly fixing it by hand. I had started trying to
add Dartagnan and some other Coq etc. packages in on it that are also
kernel-relevant before certain disruptions, but it got renamed to Dat3M
and some unusual Java things are ongoing with it that make it harder to
get interoperating the rest of the Coq-based tools. Perhaps the
inevitable and always obligatory human review has to expand to make up
for where formal modelling and the thus-far-not-entirely-well-grounded
machine reasoning systems cannot yet tread. While there's been something
of an interruption or disruption so that it's disorganised, the residue
or detritus of the experimentation with mechanically-generated code
ended up at git@git.sr.ht:~nadiayvette/linux-pgcl which is rather far
from a finished product, but if we're posting things that merely get to
a shell that doesn't crash immediately but does eventually, well, it's
of that kind.

In 2003 I thought it was by far the most fun project I ever worked on.
It would be great if I could contribute to efforts along these lines.


-- nyc

