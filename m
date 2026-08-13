Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56203C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736646B05B3; Thu, 13 Aug 2026 15:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E67C6B05B5; Thu, 13 Aug 2026 15:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FCDB6B05B6; Thu, 13 Aug 2026 15:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 302836B05B3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:35:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8D1A402B7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:35:40 +0000 (UTC)
X-FDA: 85097250840.20.1130580
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E74FD4000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:35:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W0JQGfhX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786649739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEBeBGKqcYmQquziix0FBBLpmC/A5w7ICEtCSGsPqXk=;
	b=SQqbFWaqNNVGWU/DX9vjaR3fs7WBqldkCt52hGxb+LkmM3G29d4tnGLmQ084TwbHXhXbj9
	xcsCPieWquWkCQwoewCNxsRpjtSFHpcYoxftbTZUWw2cRsQqZl2u2/ZQ6S6FbxBa5MVefN
	MF4o5oCQqOvKkvtZ5nMU1ymbtcTMmBw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W0JQGfhX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786649739;
	b=sW9I3GZjG0j28oXe0ZMIy9En8yDHZs3FdpKlELWjymcoMNanqzNMkXSbBV4LcrBt33vy0z
	5UyZAJU4Z8YXyDZuKf4eyqawrc5NOzC2Wyxwp42qNSTpHGYNUVBsgLHLdLJyT2ByV0dJaD
	Fu2lTAHAhyVcIAuDCVRbRIFNPO/kEmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1782D42339;
	Thu, 13 Aug 2026 19:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CA01F00A3D;
	Thu, 13 Aug 2026 19:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786649738;
	bh=KEBeBGKqcYmQquziix0FBBLpmC/A5w7ICEtCSGsPqXk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W0JQGfhXzjm90qZeu1tlAzd1Oqttsv8eo3/eFnoWp0OWvHd/X/HAEECR+rE2O+5We
	 2RpWF3tcLkDpsWboQEDS39zCqvZS2noyaOd7hrFd2bXLKIIuW6NUDml2VVCgiTsSu8
	 KtI87LqX6zp3HQWFgwD4lcMmBFxtTe0FpnNWhWzXU61FKACOjcXqAmGdy8zax68y8P
	 /z6YoYEknizUYyxR9d0OcZnJ3obkFLsCGdOt0TlnJknCY7Eku7g0/8G58KlFMxKPR7
	 zw0mDtEHp2k2fXeufcKL9ecOU2bywIypmlVwr0XoLN2dtwx8VGzGCnccEIbggjZpTv
	 8e37wsp7x4/Rg==
Message-ID: <a93084e1-b31a-4642-99f4-6c8c1fa8c49c@kernel.org>
Date: Thu, 13 Aug 2026 21:35:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/17] mm/huge_memory: clean up folio split and lift
 swapcache split limits
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aqj9u19qojs94xcd7twsn867o8jaz59t
X-Rspamd-Queue-Id: E74FD4000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786649738-275917
X-HE-Meta: U2FsdGVkX18LO88G3XIvYwZTt9xaZE7PN3kTikFu7J5jMv0LwxNyWb3pZ76SFV5Hu9qu69ECFFylc9CYWZoDaRt9WsdnuwqTBm9TjHubMrUez+1MS4073PUlblPNiLueXI2OrbL28FmnviP/t+ugojlS8alTzcM2UxP8srSRobCuRb4RGv91hwkT6dOqfwaLFZJCYtpAOR3mRjsNpJJAp0D6SXCA8kKWPdcP06gFB0aw8+L5xo/vQdMetP+1dCtXqtxXKeCF0frcxqDP+o+97f2x1KLC2gMvZRt2df36SFaJfmjauAUFpzQVPCFJDnbN8KlrQvWXRTWuX6ujVP/tQIbFTLMOuZ/xKJoJg6SkMtric5Lj656AbsyJXZ0Gr0DGFDHCBJtl7HASE9JO+5zOO6dwua1Iu9QuY209iPI9gN7GA0p2Ua3+WaVx3cOeI/mny/TCGiqMP67v+JqX+KVxWY/TxCwurdDikbIF6V3KxqBmd810WMRlCifxmD8i11X/M7DiIbAWxNdzleDytPZVH3yjjRuha2L+a2pZOlvOr6qRI2ipy4b+QYCNjwrpnIe7i/rOAENF2sNLoVkvudoc+9JBtNUbH0Wa2maJ06sPffC7QueZW/d3JBrisUXnkt7oDTSuI/dAC5auxt4gU69gCNh1nGL7uou3SRM5ZSPc/SpdfXs58aidR4ZDqFDpM41HJ0zgQQqctcHZQP901RGrimvq7+ewzs6RGixJ9nVFe7D/dvasGTiU0Z4uANAu03HkEik4yZR33F2vq8LTlCz+tkDTNEf072ybyKd5G1fOK+kvTmEyX+kiuPFwpaUSY489lL2oepBQGSVkiCiDaWPiTE5OMU+wrI4BMjFXXaHxkZG3IXay5btK9h6A002V8/6swKpJwU9c6Q0KYgCtYd1pLj4bAIjdT+YrErZddJFuiUWzJYv0HEo31UiLEGK+rDLmeZy8ZqWpIaSp9zpgbio
 f/1wPSUF
 ka4IXggFSnrkpHFFicwitT/vUw3DwLKDfNKssWoliq+5kTbtZOOl+fWk/NF+2Jjdb9m7Va0ary5PSg3IUm/hSQXcofvHaVtW18sn7b4NAaD9780E/wt8aljVpbYh4p7p+XvUjzs1iFy6kn4Go0k1IGpo59HOs8ekIRaMbDDtoS1jyxaMpRXI4gOafaKO+AFIEOV18TGLaDkKHiJUkyF+tJQuNRy2uvTjNROkMKtjnZTG4XqEBlBHhbpvGD8S+eDDu40d6dm5X5ro0R2cISftEBUQbTM7qSBcDZoqq8dmYhOX53ty0Oy/uTwiAGJkNTgkZiNSqikgyIhy1754=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 20:48, Kairui Song via B4 Relay wrote:
> This series clean up the split code, add better swap cache split support
> for mappingless, large order, uniform and non-uniform split.  Generic
> performance is on par or slightly better, and stack usage is reduced.
> 
> The swap cache infrastructure can handle non-uniform or high order folio
> replace, so there is no reason for either restriction from the THP side.
> What stands in the way is the mixed anon/file folio split routine,
> which makes lifting the restrictions hard to follow, and it already
> carries some buggy or redundant checks.
> 
> So this series cleans up the split path and separates anon and file
> splitting into two helpers.  The file split path never sees a swap
> cache folio, and that is now enforced up front: a folio that is both
> in the page cache and the swap cache can only be a shmem folio, which
> remains unsupported and is rejected early.  That helps to rule out swap
> cache handling in that part completely.  Only the anon split path
> handles swap cache folios, with an anon mapping or mappingless:
> either way the splitting is similar, and non-uniform split is
> supported as well.
> 
> Order-1 is still forbidden for swap cache splitting.  In theory it is
> doable for shmem swap cache folios, but a mappingless swap cache
> folio cannot currently be told apart from a shmem one, so forbid it
> for all swap cache folios for now.
> 
> Testing:
> 
> The in-tree split_huge_page_test selftest (uniform, non-uniform and
> in-folio-offset splits of anon and pagecache folios) passes 62/62 on
> the patched kernel.
> 
> ftrace function_graph tracing filtered on __folio_split() was used to
> compare per-call durations between the base and the patched kernel on
> the same x86-64 box (interleaved runs across alternating reboots;
> mean +- stddev of the per-run averages, 135 split calls per run):
> 
>   base:    24 runs, 69.6 +- 0.7 us per __folio_split()
>   patched: 26 runs, 68.8 +- 1.3 us per __folio_split()
> 
> The patched kernel is consistently ~1% faster; with this sample
> count the difference is outside run-to-run noise.
> 
> On x86-64 with gcc 12 (-fstack-usage), the stack frame of
> __folio_split() shrinks from 240 to 96 bytes, and the worst-case
> split call chain from ~544 to ~384 (anon) or ~464 (file) bytes.
> 
> Bloat-o-meter shows a tiny growth of huge_memory.o:
> before=58419 after=58446, chg +0.05% (+27 bytes).
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

I might need a bit to get to this; but the merge window is about to open either
way so, so this is material for the one afterwards.

-- 
Cheers,

David

