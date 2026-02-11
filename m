Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2C6ECD6DA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9C36B0088; Wed, 11 Feb 2026 14:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098076B0099; Wed, 11 Feb 2026 14:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC106B009B; Wed, 11 Feb 2026 14:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF9BD6B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:55:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 718971B3E98
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:55:49 +0000 (UTC)
X-FDA: 84433231218.24.38F3AAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BD0A140006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:55:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=feMhQtw2;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770839747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALggF2rKhsQf1DynBlCbJlWcz6q9GyXXWa9pu5xMBU8=;
	b=fRRZLXfXJf+dsZdOQmAhMq/U6XnO+zpCFb+1J08LxyeAR7wvmuCTRoWm40KEDLW3iGnNZe
	l3AHodwsS40jlDw/6LhZCnoUm0pjoefeU4l9KJysyP1xLOVexk51E7ESi1VuRuRkn1yWT6
	WMfZ2Z2guv0bOUq9M4xdcofWpXU2oos=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=feMhQtw2;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770839747; a=rsa-sha256;
	cv=none;
	b=Oa1jYAoWOzcFMrGePPgETD4M3ggiuHLDR5VNTX9xGeptxBDQakn1QPkPybFCH/jx/VOOHU
	7gBxtGRnfEZSUvdZKqsFFNss1Syxf1WYUkotTAHEQKdiSMmw4j8wJMKPuJGSqUCdlbEFv2
	SgXwQ5x6YTL/nRwjXLaFIGJb2ajORz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0855560018;
	Wed, 11 Feb 2026 19:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA0CC4CEF7;
	Wed, 11 Feb 2026 19:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770839746;
	bh=Y9BuVtfrc3MpVjhMYqmzU+lYgy7kt4JKSqHm0IW+wCs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=feMhQtw2K2zdChSgSLstFJd3bNy6uSEy99k1mtXz/kwtBgV0LHgd76MCWex8UmUaU
	 J30waBA4qqFt0LfuZ9tX1AiS4HPnftbJsHySSaQMBZFgHqf9nTA+5ZUw6rXhdZT/4G
	 a02Jn8IsCJqunmYz/v71ueP17hLxHodCT71U4nixoIioRKUoLK2g95v/iQFBJhzqo+
	 p40LpQg/kOO7qu51oF1kL4tPWdDZjT/jsrpAeow2jWjQr0s1pthhzyBUNvsVM0VJt4
	 DM4/zS4GSXUEmvbYAXIuZA0W/JpGEVe+/bnuGLsoM7BeHhVzVo25bHLqWKU5NVRzTt
	 YgvxQ0OadhQgw==
Message-ID: <1dfa0bd6-9658-4d29-ae5d-baad0a7a9572@kernel.org>
Date: Wed, 11 Feb 2026 20:55:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
To: Matthew Wilcox <willy@infradead.org>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-2-usama.arif@linux.dev>
 <aYzYZ-QqQGH-dNEQ@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYzYZ-QqQGH-dNEQ@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: apyu8fpxfg3f9oous8y5arzgzuyo889j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD0A140006
X-HE-Tag: 1770839747-413737
X-HE-Meta: U2FsdGVkX198KNUWKZO/BmEpO8aIQBI2AQuSDE/9kCDwYJAMtLjFerNBcdyFKh7OhFpu4iwVionX9Cmx9BK2Nsm21UxpOfTuNOiFuestn44CdXv4+QTSPlquuxfh2WmJW8NKsmIBasshEnxqjp9/JPMI7hjyHOqJw1d65Dr244DGaAqJjuvyJs2N954RFNGB9xGbZCwML/kojxu/Fi9smNhO54dm3cPLBjd1TTuSFDRZnenzLoH0birEEU5RWVkvrhbdSdyDMfs45ag4185QHT8yW0p3UkjIiexh5p08dqtZ+uU7o9+cFH5U4SDQyBKzJHNRaFNmjskbw7Q+sfnS1NxDvmB9D0DkFDVecWTRajvTXicVdPrSeUBRuBQygEPScTWHeW5/O0n6sXpEfB6W6hrKjZcX1jNnPhzLKQvErDmVovWkGdmPBlZshcjxbOIQJ7MHdvpOoCUDGygrTdOx05emHt85OlKerDruVlz1SxikwKv3GuYbmieN+TYX5FeeHSsubPIQbQwxsYFq+ZjaGjD5H/NmlApq/rJDKqb8Xbyxx2sXZNYhrHZWTBi1QqyJbxlapHv4CDLp8TKlttm4hFE1qSHuFv2Jy9lPdXHuuzKYDMrxTeYMnMbC4y70Gp1Wc+fg8P8N57f4i67uZXuP9Rql0L9hS+ggvPz9NUiAxO9YdMZfobuu7bGBNdDslUUP7DepcgykGugPq+OlveOwaoybplnTk2Ar5i0VPh9FK0Uc7FnKfft31uoNX/ulhzV5W8x2qS72WjkWyS9kDxxnm0EIkcBXDdDFSn6n4bWw4xzuqpaDnLfrfvCGlMMiEGSeKWah99XJCtyS+rP85ML/a0uPdJtMrqkoA/EsXCmFLBk8dIPsTku+D9ur9GhpGtYWWYj+ug10fsGfqsr5ov3Pr2nYee0pqr1jddVkSOfgwDRMD/t5LzzE/PWoQBk6oJWd14VwdaHSEGqJwdtaMjs
 GJc3Vcj8
 KqLG33sbbMg71gKoPNa/slKZQy0X8NWEZlGio0N4fDxkivYKzlnH5XdFBV/o6BMNeHnvZKvFXxYcXN7oB+wvyZY0VDC6v3oWYLttpyNi4+JqASzXPLdXUuWSnnA9HWVCYWIBfCmlZDDuh5rZJEoxEu366LcIFt1Jj1fQFcKbXN5B9Zv/kvjtmZRkd35BBvq2r4C383pqRuOR73wFOSVVDkVNjaFDpn1sVTeQSmGbATRFf0ohs8RVjA3UCI4pi7G3AnoMO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 20:28, Matthew Wilcox wrote:
> On Wed, Feb 11, 2026 at 04:49:45AM -0800, Usama Arif wrote:
>> - Memory reclaim (try_to_unmap()): Returns false, folio rotated back
>> LRU, retried in next reclaim cycle.
> 
> I was advised to ask my stupid question ...
> 
> Why do we still try to split the PMD in reclaim?  I understand we're
> about to swap the folio out and we'll need to put a swap entry in the page
> table so we can find it again.  But can't we now store swap entries at the
> PMD level, or are we still forced to store 512 entries at the PTE level?

Yes. We don't support PMD swap entries yet.

I don't know all historical details. I suspect there are some rough 
edges around swapin (assume we cannot swapin a 2M THP), and maybe it was 
just easier to not deal with splitting of PMD swap entries (which we 
would similarly have to support).

For sure an interesting project to look into.

-- 
Cheers,

David

