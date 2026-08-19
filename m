Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2968C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E806B0092; Wed, 19 Aug 2026 05:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18ED6B0093; Wed, 19 Aug 2026 05:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E14B6B0095; Wed, 19 Aug 2026 05:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5319D6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:36:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB396140561
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:36:29 +0000 (UTC)
X-FDA: 85117513698.20.70EB7AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51926C0003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:36:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hj0ElIKx;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787132188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTF3U2EL5wIQEwuPiw65PvVWmB+O0rc/BDnD0e5FQ+Y=;
	b=Spa74ppSxweL0vfwuIiRoU6lxPLUiJrLtKg0MiZ/j9YzSf1mq8gByjDJKZfos4+utCJcOL
	sPWCd6J07q8FujF1GR8BCDF2+acLoymSfGGeTPA5iwIwq3I/2C5nsqyWHZ1f0mIA4kW8jF
	RvDoZqYaI5D0gPTeyHu65wRkmbZyKcE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hj0ElIKx;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787132188;
	b=FuGW7UlI+WF4uMUVDRayxUVC3dZtUL6cb8RwYZu9X8qq8hm8xuJ5feIH+xDrqhC5xqHWw1
	sk13S2AnBpBdJaTOdN7h+SM1CQFqyyHj5tkWKQG3LwuL0tbQLdwpID03CXsvky1mbz2mgr
	oBttHM4EDcXWQYv1Vs4NHeRoDmrtPRY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDF7060A63;
	Wed, 19 Aug 2026 09:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986B61F00A3A;
	Wed, 19 Aug 2026 09:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787132187;
	bh=JTF3U2EL5wIQEwuPiw65PvVWmB+O0rc/BDnD0e5FQ+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hj0ElIKx6VJRJ8JYMcW7LtKc86NfHVIYzjKdrLUeZRiOHTg8nGQ4o2cY/ibgpYML/
	 oY/NM6K7sOKxMrpb3VNMwdiGX7zic2LJrZFIABndvfb/CjQdDqEdy/y6366j5cKMoo
	 pASkORkbrV3sVPZpjcO88OWwTuomkL97xuv0br9C2NgzYfQuWggsNnC2Fed8X32maS
	 xCdS8A/WycqjnVUdaPrvSkNNFdUu+qJ1tNH4hGrhowXTj6WQSN9lctDaAVYh7pjOi5
	 PrjjS9A+UJTIrbRfBxuxliHP7lu4ISMtCOm/xLFIIaEbbSAyXd3Hi6JfrGOaxR6P2s
	 DbUdsMWU7bmsw==
Date: Wed, 19 Aug 2026 12:36:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	rmikey@meta.com, riel@surriel.com, kernel-team@meta.com,
	Kiryl Shutsemau <kas@kernel.org>,
	Bradley Morgan <include@grrlz.net>
Subject: Re: [PATCH v6 0/2] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <aoV5EfBtlWcyf51E@kernel.org>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 51926C0003
X-Stat-Signature: scso6188b73qqp7a1edpajppdog6m4n6
X-Rspam-User: 
X-HE-Tag: 1787132188-82921
X-HE-Meta: U2FsdGVkX1/aGxgMhW7xzkvPopS+nsZl9xaNuYvobqpUxN6oD4Nuq6+wcvwbMjBIgR53vIugcqigHQk/f8LXAWptL6m6c3uKSv4SsSqAgHs2Sc+C1mFEbKf8YoEvjLwvvoJ4CKVrmg/I3LFziXXFXViWHvcKnKhFhpV+QS6dgIcHjaqaIUsJjeYKhCIY7HEaX2HbCXGhROIYC1iqMbuhuLaVMHGuVOE2d58gJ4My1X3pgkQuASc2tMcnXdPvfInz1lduSiC3X4JFGseJmrHeypmnZejpPvxNMvH3Rs5gWKmIGicEstBdsxcCxw21ig5qQwUpDcKlqQbCCNXRNpgqzyViawyD0Ysk5xDhP/uuQPjDe0Q4+qVHVX4XoNVIEZ6CP4sDO0u5c4fvs28jpe5kQkapog1xBa1GldRWHqq4qGa4Jptf7+Ln4RXaMxID52Jzr9J6NLeDdzBedJfO1iTn2hhX2Eun1ltnPucf0iGCKee1gnH335x7RTEzhAjoFpqA6Qmd2eXo+kz4LLSwVnNntNxuQEjFL1/WevwUtaDd0LjefwxNKqPTi2n0tuu/3Ei5D1bRWdau8Rn06fNhcowJ2pbXHMNuH7440Fuzc/Et5Z+AuTzXnuT62haVNhsPfHQIxh8wZR9NQXXMt5C4P8evM+m1YPvSEsXA3spBvEGxk9LIz8fBdg/5isT/eRMDXPP2fOJt8vhY0+aXVwYEebwC6H4rJyvpP6fNaLVvzmZwEw82eD2/Pa7Hvo5ieZwO7uh8z5pYWOCtdfCVfNsbGFC/dENhkOrRWkFaNgY9q+1F7h3cwHKVlMTQbPQWNDZfzPUT2Pzl01Ry9+Tco09tntG8RWBrabR7PyhukGcKcAqKnFeOVaQUJeIt35NKgVBwmbT+VBGztuZ2WKqL6V7EwRB3X9vNu7Y+k/VQ/fbp71YXm6rz63n0iNURe0WZ2d0OiiLrqYEynItNcMHUJBo7b4k
 jaIr033m
 Q/Os3qeAOEs3NkL5q+FYxV7gAs20CRWhTAuuFFP4ZoFqZLJEV5R/fRdeyLzySXIQBRvOscrbhiH31Nrnyq3G2MRsfWsgnxAaqQlSr41hdn71mNA6ujYiKDx6hnIQjIRK+m+iwxN6qii6b6UXsFCSqE8AvPd1RI8z4aWWV5KED58mzJMiAcW6E+62zQGR8rj0bTgs5AAgoOeLjeO66pmb5MlVUlpz69pJxp0+16E6vg0awtmyCSKUPu8Ygz8D77ywGc2XurWEt/ND2PngvHfDC0hUh2SVpg2/wzZeVVw7gPa6kDJW+Fgdmcao1oO2Qf4pmR139iggxcDk2anTPmhq4S6Qi6yC4oqzBpL2+lu82q+uWNdL3yBOhIvessQGF/nO4na+Erm2PXiUUIQb21XRlVC4BnQYm1pcyhFxoS2Tm8CM7+vlTFc61AQy58xLu0IDkvjQee+b4Ogv+s/DwHxv+lbQ4GF5sP4u80aeRYd+16jpUhyWhlH+qYlY8dfdJmV/4zcH0jI9WkoXWZkOJn3YbZ+LKiN9lJ5EM0l0d93jb6aX2tBhYI2uI2M8pk2LH8fU6uJNx+w/fH4skG0SVp06bXhgMsS81kO1KJc7yXHVixsiGCVBqtz+zBCOO0oFBuwLJx9K/1OZNIbTtfLwKvTxsBaO+mIZtCLM12YQSqgrQWNzViYviK1CNQdxvKRBChD5+Hq7IdSdv6aBVaw+BPXih3k2yi0RIBzQxkbn5TCCOH3cwGREAzUvaq9ZfwXc0UmVlDA1P+sQmE+b8c8EXb4wT05K55L54GfJeDY1Xd1A25UDcbm5YczO0Fi1/VJlGgUVJEPXXFChWMx3cumvLNNWJ2EvMQci2OCtHbsA9n0fWeU6BYUs9oJUIpi+Kl7fnZda7MmXXSG05mHOOhCEpUhiIh/cBHozpL3barVdTi8teE5+4H4tXwEFKhUiEcWWyGQxDQKuW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 04:31:50AM -0700, Breno Leitao wrote:
> Memory failures are common enough on large fleets that kexec regularly
> lands the next kernel on a frame the memory failure subsystem has already
> marked bad. Patch 2 teaches the segment placement to avoid those frames.
> 
> Patch 1 is a prerequisite. locate_mem_hole_top_down() walks candidates
> downwards without ever checking that the subtraction stays above zero, so
> the walk can wrap and report success with a destination outside of RAM.
> Patch 2 adds one more downward step to that loop, so the bug is fixed
> first and both patches rely on the same bail-out.

I queued this for v7.4, the patches will appear in the liveupdate tree
after the merge window.
 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
> Changes in v6:
> - Split the pre-existing top-down underflow out into its own patch, and
>   drop the "if (poison < kbuf->memsz)" guard from the hwpoison hunk now
>   that the loop bail-out covers it. (Mike Rapoport, Sashiko)
> - Reword the changelog: the MCE comes from reading the poison back, not
>   from the relocation copy writing it, and the placement paragraphs read
>   better split up. (Mike Rapoport)
> - Move cond_resched() after the struct page dereference, so the scan does
>   not yield between pfn_to_online_page() and is_page_hwpoison().
>   (Pratyush Yadav, Sashiko)
> - Keep cond_resched() per pfn rather than batching it. (Kiryl Shutsemau,
>   Rik van Riel)
> - Link to v5: https://patch.msgid.link/20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org
> 
> Changes in v5:
> - Return -EHWPOISON instead of -EADDRNOTAVAIL
> - Leverage is_page_hwpoison() instead of per-page check
> - Link to v4: https://patch.msgid.link/20260807-kexec_posioned-v4-1-70d57f14625d@debian.org
> 
> Changes in v4:
> - Anchor the top-down hole finder on the first poisoned page in the
>   window and the bottom-up one on the last, so each jumps clear of the
>   poison in one step. New range_first_hwpoison(). (Kiryl Shutsemau)
> - Count a poisoned hugetlb folio in full: the flag lives on the folio,
>   not on the subpages, so the per-pfn scan missed poisoned tail pages.
>   (Kiryl Shutsemau)
> - Link to v3: https://patch.msgid.link/20260803-kexec_posioned-v3-1-83aa6ede0351@debian.org
> 
> Changes in v3:
> - Return the address of the last poisoned page in the range, or
>   PHYS_ADDR_MAX when it is clean, instead of a bool plus an output
>   parameter. Renamed to range_last_hwpoison(). (Pratyush Yadav)
> - Add cond_resched() to the scan loop, as a segment can span half of
>   memory. (Sashiko)
> - Link to v2: https://patch.msgid.link/20260730-kexec_posioned-v2-1-f92d18551f64@debian.org
> 
> Changes in v2:
> - Change from pfn_to_page() to pfn_to_online_page(). (Miaohe Lin)
> - Return the poisoned address once we find a hit, to avoid the O(n^2)
>   rescan. (Sashiko)
> - Link to v1: https://patch.msgid.link/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org
> 
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> To: "Liam R. Howlett" <liam@infradead.org>
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Mike Rapoport <rppt@kernel.org>
> To: Suren Baghdasaryan <surenb@google.com>
> To: Michal Hocko <mhocko@suse.com>
> To: Baoquan He <baoquan.he@linux.dev>
> To: Pasha Tatashin <pasha.tatashin@soleen.com>
> To: Pratyush Yadav <pratyush@kernel.org>
> To: Miaohe Lin <linmiaohe@huawei.com>
> To: Naoya Horiguchi <nao.horiguchi@gmail.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kexec@lists.infradead.org
> Cc: rmikey@meta.com
> Cc: riel@surriel.com
> 
> ---
> Breno Leitao (2):
>       kexec_file: stop the top-down search before it underflows
>       kexec: keep the next kernel off hardware-poisoned pages
> 
>  include/linux/mm.h  | 14 ++++++++++++++
>  kernel/kexec_core.c | 10 ++++++++++
>  kernel/kexec_file.c | 20 +++++++++++++++++++-
>  mm/memory-failure.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 83 insertions(+), 1 deletion(-)
> ---
> base-commit: c5e32e86ca02b003f86e095d379b38148999293d
> change-id: 20260727-kexec_posioned-72bb0a4143a0
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 

-- 
Sincerely yours,
Mike.

