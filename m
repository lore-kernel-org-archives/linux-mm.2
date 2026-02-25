Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0B58FD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6B56B00BC; Wed, 25 Feb 2026 11:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3D66B00BD; Wed, 25 Feb 2026 11:34:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D15C6B00BE; Wed, 25 Feb 2026 11:34:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 301CB6B00BC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8C868C239
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:39 +0000 (UTC)
X-FDA: 84483527478.08.DDBE920
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3909160006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HBkQ0FZw;
	spf=pass (imf08.hostedemail.com: domain of 3nCSfaQgKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3nCSfaQgKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4LE82gjFn/5ZZ/2JvjaZiilw8mXnBm6i4XsVTFRpvFg=;
	b=Safav5/3TxY03e4aQ+o8lJxuRbAWOcmfnaAhQJlQmH25gL937Ra04eZBZ2uIoVJMhEAKge
	E//p88BJI1iOwp2niicml7J0ergI0ezEbssPtoHU4AW6xD5agegYlgTrYgDQRRbaqeadRH
	ijWXh/8wPpQPONyU4pUp2loV99Hc93U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HBkQ0FZw;
	spf=pass (imf08.hostedemail.com: domain of 3nCSfaQgKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3nCSfaQgKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037278; a=rsa-sha256;
	cv=none;
	b=EWx+28Wpgfys0q2Vusq27YMLwEHlnNSFSfljCjWKOfq/FHXS2uYx3s3wwiVc8tD7+mRZ/u
	a1WNg0Clg26eQ2Iba4/D5ZmvhrR7//7ta5Vjg5tFqu0M/ppeuQQcGed7qNkHLjt2C9OJ6C
	p8L4IS0t2UxTCQInvb4dLht8bXRTePs=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837907ec88so78417555e9.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037276; x=1772642076; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4LE82gjFn/5ZZ/2JvjaZiilw8mXnBm6i4XsVTFRpvFg=;
        b=HBkQ0FZwp+yMVjkdKlz1R7ZnWqF+4Gu19IW0Dz2BshWcRvnbgWGTuzVAOjvu8dBvoQ
         HxWhSvw7IPTSiw5OTi99rKSEXrOkXoNTIrtrYwhpvuRA6RX/bKdqFFS4bxQug9LwG6VS
         49rEHeuH0qUBzcs8PGp2MR9u0Ue8O0G88GPQoUsCMqqf8p9y9+AFTrEGZMtOErCiY1QL
         S0KJO8GQKrKULkzweSdAzZPCu48lLbCOJcdBmDVND1X7A9mUI4tx3JBrLz8/HryDi7L2
         G72IrhpDKseMwqHE7ZHjn24YVnsAOl48MfySwtPu08cne8ZUypl5VvJSu27hRefxctDC
         A5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037276; x=1772642076;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4LE82gjFn/5ZZ/2JvjaZiilw8mXnBm6i4XsVTFRpvFg=;
        b=V05uTQ8cPeHgVH7RV8x8WGSb9/y+hNS+hqqb5gD59NmAMX5BfMSwc2LGasaOaWN0uw
         noo80BlkRFVWCDiFpAFmw27h+ET0yJT9fY8FatstiKSoGz27DsKoWEC7SaFTeTVzJ6Md
         kNTx1i8zHAzOLTHQxtvc5ladnovyjiO5BCbmDg7b0UI911l9jPn31RtTyRuhxtsBdBaq
         Ylp2Oau1dHEoz9bOklPxU6o9wlJmJyBlfHZR3KngCqgXOWH0FNRC10Pi+j6SpR5OV2/H
         AGwK013qDgVlj6a3FJDq7rlkDjJ/KlP2ZDRvlpJiHVQCiv5/fxCXlhSJWUO+8JVf6Nxc
         nMeQ==
X-Gm-Message-State: AOJu0YzRmLzUQ1d7rRQj1JnkzL+CRmTbrz6KicUEXjNpjXY6tnL9Wtwa
	7e910pZav7rEvZuwd/DmEvX3xQnYp7lXcC/wu9/vUeNr/ezo0UhsTDQVf6eBcQRptl/KPosNnr3
	QqI0qfkrZPcZwYA==
X-Received: from wmpc17.prod.google.com ([2002:a05:600c:4a11:b0:483:a1ee:5eb8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5397:b0:483:71f9:37f3 with SMTP id 5b1f17b1804b1-483a95a85c0mr296216125e9.1.1772037276137;
 Wed, 25 Feb 2026 08:34:36 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:25 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAJIkn2kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQ0Mj3YLE9NT4xJyc/GTd0rzcxIKC1BRdSxOTtFTTFPMkU9NkJaDOgqL UtMwKsKnRSkFuzkqxtbUAuB9eqGoAAAA=
X-Change-Id: 20260112-page_alloc-unmapped-944fe5d7b55c
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Subject: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w9dfqfe8erzpiw3b5wsbgacj8mfmsrwq
X-Rspam-User: 
X-Rspamd-Queue-Id: F3909160006
X-Rspamd-Server: rspam01
X-HE-Tag: 1772037277-736818
X-HE-Meta: U2FsdGVkX1+Gi4M1Q7wiLUlDc+Fd4majUOAOwwjAJYf5ooqXrUboczWuDf0+FRPrPb8UrtXS9fjSbz6Dsnu4i+z45g65Wc/g5RMIzwFg5yuMrm0IGEFjHUslpzkb/QW2OHIX95JJ52EHGwX/NyL87RAKyJ8SC2NkJaU/6omvrsIffXnnp9pIztuDyE3GausZIIWn1oWE5EzFmC9g3sWxpX+KRAWNSaLoyUJvVLCZpj5clHMUkvKneP+Fd8gb5aWqibfRl2OcasKe3QRFhKSr29CsXYElw188M3jyWm2BncaN/u3mMDzIkDaag6FjRd65pwZssac0xAG1WkZGpkdyXO7Nzn0o/YhDnz50CJ3DBX7/IwjloUwWaTBGQZJexr7etgSaWOba57GCL9a0S6X2IluGEYkNv0f84ReU3MAq0Qo47aTtOgxF9M0r7YpNKRJiCHh8Otm/dz15gRc4VUlxCn3ja2jKohqgaUihmv0nU1xfCURoVvwk214hu9gK/6RsOlSluRWGMt0w5ZeXQwehK0tEZHxHIyZpie/1e1EmJAPjV6zpiMoxVfRFJgUcgYiqnGabH+jwvnEjxuBBgvmYJ+A0addXtOB3btFuvyHNB5wr44sFf7bLzLgh0bCoAJ/Jjjsa0kBlziCP9wGM2jNcl2eRt8nJR4W2vRxVOK1dX6ZcfqAk/xb5xbH4X8LKIHnfJMZIZYIvI4pFtdML5WUxKh/W23qg8U/mdYDRqMe/bIPaFuo74UNNw1Qkt5NfvfqyVwTv4gL3s/mB8L2cOuG/emWc8q8YyTt9F+GKXycQ313Vx7DzaVbQkKjGqOSUjHGv8tfbs3CN4qjItO+CZFWPvKnppauouK1KSujEHK2z5oAclfyiCO7bXsjfIRlrbaen9BCA2SHpJTgnzKy9z2O8I45UAOCNAOdQlcpGmMMIEI4WH9/0yybnvkWjf8miTxVcKcu27K4zdMZ2zddANHW
 4uDPhhdi
 3FTxyqtjl42utDpNhFLhBGeXmgt61oz7v87e2gGQKwbGbTpnEO17ncF/v52vKOrovlEgISi7JFBNydRaK8uZBc9jZ/S3t455ViS7oRqoDsXa9CJdCdKuYIUuLBWL4f0GBdj5HKumMsozMBiPWvvnRS5She0QtPR+o3heMb4QKT3BEvNAC5cd6YtZqUdcjxtbTXhHti1+9NCalo8OODC5dgERh/OsdwpIx7G1wQHTqwxk4yXUUtTJVQ4vRKVUYuoG4HywbTN/YkjCjgr5LNyymrB2Qq0rCaODoyToUYt3eXsfuqOEC05p5acZk+dWhZzuq1ZNR/O9yuqgoT/DUBDXkQwwsUNeriZjVMr47SSZTKqSyfix3jZ6Ehb9sVStfEyyUri9NlaqtTWmJt/kVrLx2YQAuRUW1qZoW4ohlLWJwVOHxkEoyZgB55DWEybep9/DU0ivTAHVm5VEBUWjyMETiaj9wKXf6IWZte2rPCJzY7x6P7DuzxnmgtXRJf/OSUJuMNcTY50P5G1rcknz6r+Fag9ojmnmNhMjjTOup8pLub5nBTWOu6w1mjagHTRTrIUVASooMuWl4jFlqtnZeu4Azpm8tt0NVY1gw+uuVntwE0kjVjtayePs1Q2R0iJ0r5MRvGfOv4D8EsvNUGm9xARu2Frd5X3YkMgekKptFwFdzDX+jucGjxLPzmQH+eURzlZzEMsXQd3Wn2fKBmyCSPsz5AqOxU7T0XAPE4H52seK9wF3FBW+7RFdHsNx6ngGvytWMaXH7jQYy8WyxE1+OYzUqNXa8Ueqa3LyEwZ6rNZKQ5u35T6xFS6s7W6ArbH5AqvFmWfTfv8uvyUcOU7ADZqFtmJbeicHu2rPgqVOurJ9hsUXP1THgoPlcdE5Gju5oY6SJn6w7tYj/dYBecr2vbksYn1Wpfa7dRjUBUUii4ZHxiB0f3UMZXaBVhKl/ShfnihUK66y36VRIk0sZ6aue3Rc8L9X2Wh7h
 rlbrrhIS
 q1Yimw9Jj0lapfgW+YXbDn8M94fsXNsbkgriI1EF2dhf5M+w1z5Imb0A78kxZxTyPu1B56WZrXdhjrbP9c4/pVoRZPP19o+dcTE7XvS+KgDA6WEOFUd+r9uN+YwDsx8ZE/J5hCZL82EjgT8oKzY+yeAimEhqjMjNzd4D7hHMrT27oBSZ1Ap2JiuL5y82dbu8KIBJ4Azovg4XmUKMCiseRetCJgJ4ou81sJqC7XfPtfy7/74P9hgQV6iD52YXy1KBlxGW4hnCeH31QhgCIVjB3uPFLNoYexiVEywZcJ6vGMnXaZsS0RrWr7QJSE1NEfRvYChN41Pry/eKslO+YFsXHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

.:: What? Why?

This series adds support for efficiently allocating pages that are not
present in the direct map. This is instrumental to two different
immediate goals:

1. This supports the effort to remove guest_memfd memory from the direct
   map [0]. One of the challenges faced in that effort has been
   efficiently eliminating TLB entries, this series offers a solution to
   that problem

2. Address Space Isolation (ASI) [1] also needs an efficient way to
   allocate pages that are missing from the direct map. Although for ASI
   the needs are slightly different (in that case, the pages need only
   be removed from ASI's special pagetables), the most interesting mm
   challenges are basically the same.

   So, __GFP_UNMAPPED serves as a Trojan horse to get the page allocator
   into a state where adding ASI's features "Should Be Easy".

   This series _also_ serves as a Trojan horse for the "mermap" (details
   below) which is also a key building block for making ASI efficient.

Longer term, there are a wide range of security techniques unlocked by
being able to efficiently remove pages from the kernel's address space.

There may also be non-security usecases for this feature, for example
at LPC Sumit Garg presented an issue with memory-firewalled client
devices that could he remediated by __GFP_UNMAPPED [2].=20

.:: Design

The key design elements introduced here are just repurposed from
previous attempts to directly introduce ASI's needs to the page
allocator [3]. The only real difference is that now these support
totally unmapping stuff from the direct map, instead of only unmapping
it from ASI's special pagetables.

.:::: Design: Introducing "freetypes"

The biggest challenge for efficiently getting stuff out of the direct
map is TLB flushing. Pushing this problem into the page allocator turns
out to enable amortising that flush cost into almost nothing. The core
idea is to have pools of already-unmapped pages. We'd like those pages
to be physically contiguous so they don't unduly fragment the pagetables
around them, and we'd like to be able to efficiently look up these
already-unmapped pages during allocation. The page allocator already has
deeply-ingrained functionality for physically grouping pages by a
certain attribute, and then indexing free pages by that attribute, this
mechanism is: migratetypes.

So basically, this series extends the concepts of migratetypes in the
allocator so that as well as just representing mobility, they can
represent other properties of the page too. (Actually, migratetypes are
already sort of overloaded, but the main extension is to be able to
represent _orthogonal_ properties). In order to avoid further
overloading the concept of a migratetype, this extension is done by
adding a new concept on top of migratetype: the _freetype_. A freetype
is basically just a migratetype plus some flags, and it replaces
migratetypes wherever the latter is currently used as to index free
pages.

The first freetype flag is then added, which marks the pages it indexes
as being absent from the direct map. This is then used to implement the
new __GFP_UNMAPPED flag, which allocates pages from pageblocks that have
the new flag, or unmaps pages if no existing ones are already available.

.:::: Design: Introducing the "mermap"

Sharp readers might by now be asking how __GFP_UNMAPPED interacts with
__GFP_ZERO. If pages aren't in the direct map, how can the page
allocator zero them? The solution is the "mermap", short for "epheMERal
mapping". The mermap provides an efficient way to temporarily map pages
into the local address space, and the allocator uses these mappings to
zero pages.

Using the mermap securely requires some knowledge about the usage of the
pages. One slightly awkward part of this design is that the page
allocator's usage of the mermap then "leaks" out so that callers who
allocate with __GFP_UNMAPPED|__GFP_ZERO need to be aware of the mermap's
security implications. For the guest_memfd unmapping usecase, that means
when guest_memfd.c makes these special allocations, it is only safe
because the pages will belong to the current process. In other words,
the use of the mermap potentially allows that process to leak the pages
via CPU sidechannels (unless more holistic/expensive mitigations are
enabled).

Since this cover letter is already too long I won't describe most
details of the mermap here, please see the patch that introduces it.

But one key detail is that it requires a kernel-space but mm-local
virtual address region. So... this series adds that too (for x86). This
is called the mm-local region and is implemented by "just" extending and
generalising the LDT remap area.

.:: Outline of the patchset

- Patches  1 ->  2 introduce the mm-local region for x86

- Patches  3 ->  5 introduce the mermap

- Patches  6 -> 14 introduce freetypes

  - Patch 8 in particular is the big annoying switch-over which changes
    a whole bunch of code from "migratetype" to "freetype". In order to
    try and have the compiler help out with catching bugs, this is done
    with an annoying typedef. I'm sorry that this patch is so annoying,
    but I think if we do want to extend the allocator along these lines
    then a typedef + big annoying patch is probably the safest way.

- Patches 15 -> 20 introduce __GFP_UNMAPPED

.:: Why [RFC]?

I really wanted to stop sending RFC and start sending PATCHes but
getting this series out has taken months longer than I expected, so it's
time to get something on the list. The known issues here are:

1. __GFP_UNMAPPED isn't useful yet until guest_memfd unmapping support
   [0] gets merged.

2. Apparently while implementing the mm-local region, I totally forgot
   that KPTI existed on 32-bit systems. I expect the 0-day bot to fire a
   failure on that patch.

There is also one really nasty hack in mermap.c, namely
set_unmapped_pte(). This is basically a symptom of the problem I
propose to discuss at LSF/MM/BPF [3], i.e. the fact that there are
lots of pagetable libraries yet none of them are flexible enough to do
anything new (in this case the "new thing" is pre-allocating pagetables
then subsequently populating them in a separate context). Whether this
particular hack should block merging the mermap is not clear to me, I'd
be interested to hear opinions.

.:: Performance

In [4] is a branch containing:=20

1. This series.

2. All the key kernel patches from the Firecracker team's "secret-free"
   effort, which includes guest_memfd unmapping ([0]).

3. Some prototype patches to switch guest_memfd over from an ad-hoc
   unmapping logic to use of __GFP_UNMAPPED (plus direct use of the
   mermap to implement write()).

I benchmarked this using Firecracker's own performance tests [4], which
measure the time required to populate the VM guest's memory. This
population happens via write() so it exercises the mermap. I ran this on
a Sapphire Rapids machine [5]. The baseline here is just the secret-free
patches on their own. "gfp_unmapped" is the branch described above.
"skip-flush" provides a reference against an implementation that just
skips flushing the TLB when unmapping guest_memfd pages, which serves as
an upper-bound on performance.

metric: populate_latency (ms)   |  test: firecracker-perf-tests-wrapped
+---------------+---------+----------+----------+------------------------+-=
---------+--------+
| nixos_variant | samples |     mean |      min | histogram              | =
     max | =CE=94=CE=BC     |
+---------------+---------+----------+----------+------------------------+-=
---------+--------+
|               |      30 |    1.04s |    1.02s |                     =E2=
=96=88  |    1.10s |        |
| gfp_unmapped  |      30 | 313.02ms | 299.48ms |       =E2=96=88          =
      | 343.25ms | -70.0% |
| skip-flush    |      30 | 325.80ms | 307.91ms |       =E2=96=88          =
      | 333.30ms | -68.8% |
+---------------+---------+----------+----------+------------------------+-=
---------+--------+

Conclusion: it's close to the best case performance for this particular
workload. (Note in the sample above the mean is actually faster - that's
noise, this isn't a consistent observation).

[0] [PATCH v10 00/15] Direct Map Removal Support for guest_memfd
    https://lore.kernel.org/all/20260126164445.11867-1-kalyazin@amazon.com/

[1] https://linuxasi.dev/

[2] https://lpc.events/event/19/contributions/2095/

[3] https://lore.kernel.org/all/20260219175113.618562-1-jackmanb@google.com=
/

[4] https://github.com/bjackman/kernel-benchmarks-nix/blob/fd56c93344760927=
b71161368230a15741a5869f/packages/benchmarks/firecracker-perf-tests/firecra=
cker-perf-tests.sh

[5] https://github.com/bjackman/aethelred/blob/eb0dd0e99ee08fa0534733113e93=
b89499affe91

Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Cc: rppt@kernel.org
Cc: Sumit Garg <sumit.garg@oss.qualcomm.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Wei Xu <weixugc@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: yosryahmed@google.com
Cc: derkling@google.com
Cc: reijiw@google.com
Cc: Will Deacon <will@kernel.org>
Cc: rientjes@google.com
Cc: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: patrick.roy@linux.dev
Cc: "Itazuri, Takahiro" <itazur@amazon.co.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: David Kaplan <david.kaplan@amd.com>
Cc: Thomas Gleixner <tglx@kernel.org>

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Brendan Jackman (19):
      x86/mm: split out preallocate_sub_pgd()
      x86/mm: Generalize LDT remap into "mm-local region"
      x86/tlb: Expose some flush function declarations to modules
      x86/mm: introduce the mermap
      mm: KUnit tests for the mermap
      mm: introduce for_each_free_list()
      mm/page_alloc: don't overload migratetype in find_suitable_fallback()
      mm: introduce freetype_t
      mm: move migratetype definitions to freetype.h
      mm: add definitions for allocating unmapped pages
      mm: rejig pageblock mask definitions
      mm: encode freetype flags in pageblock flags
      mm/page_alloc: remove ifdefs from pindex helpers
      mm/page_alloc: separate pcplists by freetype flags
      mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
      mm/page_alloc: introduce ALLOC_NOBLOCK
      mm/page_alloc: implement __GFP_UNMAPPED allocations
      mm/page_alloc: implement __GFP_UNMAPPED|__GFP_ZERO allocations
      mm: Minimal KUnit tests for some new page_alloc logic

 Documentation/arch/x86/x86_64/mm.rst    |   4 +-
 arch/x86/Kconfig                        |   3 +
 arch/x86/include/asm/mermap.h           |  23 +
 arch/x86/include/asm/mmu_context.h      |  71 ++-
 arch/x86/include/asm/pgalloc.h          |  33 ++
 arch/x86/include/asm/pgtable_64_types.h |  19 +-
 arch/x86/include/asm/pgtable_types.h    |   2 +
 arch/x86/include/asm/tlbflush.h         |  43 +-
 arch/x86/kernel/ldt.c                   | 137 ++----
 arch/x86/mm/init_64.c                   |  44 +-
 arch/x86/mm/pgtable.c                   |   3 +
 include/linux/freetype.h                | 147 ++++++
 include/linux/gfp.h                     |  25 +-
 include/linux/gfp_types.h               |  26 ++
 include/linux/mermap.h                  |  63 +++
 include/linux/mermap_types.h            |  43 ++
 include/linux/mm.h                      |  13 +
 include/linux/mm_types.h                |   6 +
 include/linux/mmzone.h                  |  84 ++--
 include/linux/pageblock-flags.h         |  16 +-
 include/trace/events/mmflags.h          |   9 +-
 kernel/fork.c                           |   6 +
 kernel/panic.c                          |   2 +
 kernel/power/snapshot.c                 |   8 +-
 mm/Kconfig                              |  41 ++
 mm/Makefile                             |   3 +
 mm/compaction.c                         |  36 +-
 mm/init-mm.c                            |   3 +
 mm/internal.h                           |  43 +-
 mm/mermap.c                             | 323 +++++++++++++
 mm/mm_init.c                            |  11 +-
 mm/page_alloc.c                         | 782 +++++++++++++++++++++++-----=
----
 mm/page_isolation.c                     |   2 +-
 mm/page_owner.c                         |   7 +-
 mm/page_reporting.c                     |   4 +-
 mm/pgalloc-track.h                      |   6 +
 mm/show_mem.c                           |   4 +-
 mm/tests/mermap_kunit.c                 | 231 ++++++++++
 mm/tests/page_alloc_kunit.c             | 250 ++++++++++
 39 files changed, 2099 insertions(+), 477 deletions(-)
---
base-commit: 44982d352c33767cd8d19f8044e7e1161a587ff7
change-id: 20260112-page_alloc-unmapped-944fe5d7b55c

Best regards,
--=20
Brendan Jackman <jackmanb@google.com>


