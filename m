Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9D7FF495E
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C840B6B008C; Mon, 30 Mar 2026 10:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DA26B0095; Mon, 30 Mar 2026 10:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFBE76B0096; Mon, 30 Mar 2026 10:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5EC6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:00:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03EDB14081D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:00:49 +0000 (UTC)
X-FDA: 84602890260.17.8F428D7
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id CE9BC140019
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:00:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lS9w9BPl;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774879248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaGpJgvU7fzaZHNV9egMJ09PF1OrT8PBmReLhVLOy8s=;
	b=cPAwyI1vgxH1HnaOHVv8HBJcMw3RRHiYw+vmqoi5tT80GtJwU3iwBwIRZbxVqirmQUa2Dd
	8iadZAbOzJxXmyVvCtl+NeJ8PUzeY7/2KG3vhd932+p2ggsgypLPCcRWPGmdIGVvVtEFTN
	tMCxSCxmayA9oZFRiJVM/lBymWYNifw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lS9w9BPl;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774879248; a=rsa-sha256;
	cv=none;
	b=CkW5gzvngzACe+FwJYk8pyBc0xTa3WEyVXRWMBuInX71/putNilvVGubpUODNafxbOK6Ay
	tJMtUyLT5WuoNU1fxRQa8FQ64ehrFq31iPgZrDWtJugSYvBbRk56MWESdObXYcRYQv7Ahm
	GhCcnMBAGUNgUZjcyctW2fLEMw7dw+k=
Message-ID: <e3876d3f-0e86-4542-861d-2de3d0cbf66e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774879244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CaGpJgvU7fzaZHNV9egMJ09PF1OrT8PBmReLhVLOy8s=;
	b=lS9w9BPlpn3w7Y6et2LBOIXHgvvaMn9p28qX39J+x4F8xAvdXoNIWXQtnIFst7cGSn4B8i
	lEUcuiFbizFcrIFZoDdU/tj2oIyK1tlAj28oBGq0wenPC6w5RPlSLYdxJN2bXYd0fqqi/3
	hAOTBN1N5ysSW5IbJMAZcoTn0ZQ4JsI=
Date: Mon, 30 Mar 2026 15:00:40 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE
 coalescing
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>, WANG Rui <r@hev.cc>
Cc: Liam.Howlett@oracle.com, ajd@linux.ibm.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 brauner@kernel.org, catalin.marinas@arm.com, david@kernel.org,
 dev.jain@arm.com, jack@suse.cz, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com, vbabka@kernel.org,
 viro@zeniv.linux.org.uk
References: <0725ce97-b8a3-47c9-952f-7b512873cc35@linux.dev>
 <20260329043700.19355-1-r@hev.cc> <acpy6DLjPVXXzwJX@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <acpy6DLjPVXXzwJX@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE9BC140019
X-Stat-Signature: qwehz958cxnam4u9w7bmxiuctyuriw94
X-Rspam-User: 
X-HE-Tag: 1774879247-516468
X-HE-Meta: U2FsdGVkX18ywmHetOPhDFXvRKlKq7JeDxnE82nINaNYVPZ5DmcWvamYhFtkj5lJ233t5ZukMZl8mvIq+27PhXDu2Tt/yswGiNgB9/1zVqwemIZDLiJfWwmzQwUh0G8nKZ5ljKbBIV0IC83O8NE3T1xRLd797Ko1d9vAsj5KlMXmIaTIA+WhMNafZDWUVXsLAlA3MUsrlrwKWs+8UtwW9u7VziAal/nE1oONe9tlDduEjGReiz0Ad8XQRCzz1MJah+Nd2SVpDW7kw5r6ZRo7qNutudCsPxD0ifkFOc4FYOklrE7ilyj+bcDqLLNB9Aaz2jfzpiT+eZn5P6nlK4YgzoLwmdss76kntZQHaIdR149yxTHoKIm1rd3Vnl97LwwgeEoF4JVioNt8Wq5GdBvfPaw2RqLiWHnkESLUkRrLp5pH7qoUwqIenN59dU2uMcYdshxVVtnGr5dzoL1c45VD0xpNxGFB92KwhS8vCovjhMeArqzqDzHJaSpl/0Ktwni0JdrHFOuTPZfK801MKlVWe5tuVvkiGK6pjQF8eN2oWEy3NASlB1G5JFMNJvYdC0Zs/l8S1cbvIbHze08jT1dD2xjqclexJZxsxKvmHs1hBoYSpOGC8uTDV/p/5QB/8rd0aTmTQAOnIoyQyn8pdnTyN9G8sDmeoXE+VflP5y76gTa/WoJLhKWxgU/IstGrj7Phj6VsHaIqE5iwsvo6i38MnB100OvGHgFQyAyPP2374uVpODLbzwWvHg+d1V8+L9xVz3sf2ihjplSrGESpL5jhVj34g0/rFtHtbNv32pL4FRNJnoayv7JaS7OiPpatb6pUDvt6QqlNOzOnxPflYSUFLff4aGMgqxjO3J+4k9X6+G17U3satUkz1tjDgyxpSrqB1YwzVvfShwfhMj8IZ2H19RWw5VWHzP1O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/03/2026 15:56, Matthew Wilcox wrote:
> On Sun, Mar 29, 2026 at 12:37:00PM +0800, WANG Rui wrote:
>>> mapping_max_folio_size() reflects what the page cache will actually
>>> allocate for a given filesystem, since readahead caps folio allocation
>>> at mapping_max_folio_order() (in page_cache_ra_order()). If btrfs
>>> reports PAGE_SIZE, readahead won't allocate large folios for it, so
>>> there are no large folios to coalesce PTEs for, aligning the binary
>>> beyond that would only reduce ASLR entropy for no benefit.
>>>
>>> I don't think we should over-align binaries on filesystems that can't
>>> take advantage of it.
>>
>> Ah, it looks like this might be overlooking another path that can create
>> huge page mappings for read-only code segments: even when the filesystem
>> (e.g. btrfs without experimental) didn't support large folios,
>> READ_ONLY_THP_FOR_FS still allowed read-only file-backed code segments
>> to be collapsed into huge page mappings via khugepaged.

ah yes, Thank you for pointing this out!

Maybe we should rename mapping_max_folio_size() to mapping_fault_max_folio_size().

>>
>> As Wilcox pointed out, it may take quite some time for many filesystems
>> to gain full large folio support? So what I'm trying to clarify is that
>> using mapping_max_folio_size() on this path is not favorable for
>> khugepaged-based optimizations.

ack

I am worried that 32M is too large and we lose out on a lot of ASLR bits.
Instead of PMD_ORDER, should we do max(SZ_2M, PMD_ORDER)?

> Nono, that's not what I'm pointing out!  btrfs is simply not putting
> in the effort to support large folios, and that needs to change.
> READ_ONLY_THP_FOR_FS unnecessaily burdens the rest of the kernel.
> It was a great hack for its time and paved the path for a lot of what
> we have today, but it's time to remove it.


