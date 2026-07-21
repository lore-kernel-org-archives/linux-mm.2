Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FE6C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639C36B00B3; Tue, 21 Jul 2026 10:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612966B00B7; Tue, 21 Jul 2026 10:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD046B00B9; Tue, 21 Jul 2026 10:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16BEB6B00B3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:50:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E6F11401C7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:50:06 +0000 (UTC)
X-FDA: 85013068812.17.48FE665
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B7A6AC0010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:50:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TktR1nXS;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784645404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhL0bFb0++kqhYjp/S8n6P1xQsFGJpg+0C8Sp6UvQH8=;
	b=EBm9pW4Ro5Chf/jls9wsSNqeRTs28acQjf6pVXN69vFF2APiintQwl6VPXMlxWPMeaC7dH
	JGx+s9L3rYPZWd59bO1ZbmHKDCshtSM9CKToB5UBctB0ZCtmVvQTpLiBbVn0bx6ayz0Ppb
	+ZWaNHv3FQas7/c0u1N93w9P267m/PE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784645404;
	b=MA6o64kP74HcDAFUdPffqh2m7qAKpTDa2jpd1rxEQ3LXc1ZIDLnqn9xm33npSKC7kKh4D/
	udnQ4xzSxZkkvn7nDDwR96adfROWmWnZPPOdF2TscwzWuN1vomTVCTQB4Ubckl+mBo2oyp
	O0gn4PUxRt0FRNWrQ9l/wqC5mGLBwv8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TktR1nXS;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C15D14349A;
	Tue, 21 Jul 2026 14:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9A01F00A3A;
	Tue, 21 Jul 2026 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784645403;
	bh=WhL0bFb0++kqhYjp/S8n6P1xQsFGJpg+0C8Sp6UvQH8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TktR1nXS84Yept5lCED+QgykKLhT6N3Xrhd0LiMItRlurja+5uZZ11i0zp8NrDnUR
	 PoYPJFgrhBgwGF5gYM2GqQVX/lxPBXvv7RXbaCnqXueC3BqGhrs80VFfnhb13K0N85
	 HtELci/hrSOPjRseUMipO8KjKDVqLGkC9r2VML8Axz+Xc/GUNa8jcTaeK5FgcqQ25S
	 xoRp0LmsMN2p87NbzhsbkJkn5smJO9OKaia3shW6SZOXA1tc24UEORwFG7rZZI9v6+
	 nKxmo2El32Mt8+pWRt4mZBZaOYKqH28lKZkzHWXpjn0mZILlFlEOASI7iUYFHjTnP2
	 I5BxGwbGckSpw==
Message-ID: <25e3e218-cb74-4d7d-9301-24b583f4323f@kernel.org>
Date: Tue, 21 Jul 2026 16:49:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: fix out-of-bounds access and race in
 generic_access_phys
To: Ren Wei <enjou1224z@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 notasas@gmail.com, vega@nebusec.ai, rakukuip@gmail.com
References: <cover.1784428532.git.rakukuip@gmail.com>
 <f618e2f57ad0086a8d7a95cb17dcf5a1f0cf0e45.1784428532.git.rakukuip@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f618e2f57ad0086a8d7a95cb17dcf5a1f0cf0e45.1784428532.git.rakukuip@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B7A6AC0010
X-Stat-Signature: 61cjkyspkrp8jqjydwku8xac3b6aqmui
X-Rspam-User: 
X-HE-Tag: 1784645404-272717
X-HE-Meta: U2FsdGVkX18uYqluy3aNbWcvrKJTDHcOyx14MuA/In1y0sjsc8X98bMa+eeBNy1hkhlTozwk+1L3MT3KPcLOCJdeM9s5AR32c1sQfggVIPMjWcHiUzS5/ma5Im22o61mKHOML5LgzG7Wn9lzVFzqnqbgtJionIGoDqQ0e/eXaWlb2emIEa235+raudbeRhaQ1RlaXdUN3o1E6Lt8F871xDOW4O5XffaAKkxezWdz1Wb9NYbOOiH8J5rWadDcBMZFWB+qASHGLI1V0NkHlTt8OOZuOVGpTwOqUvOJS0n30qx+PuUsi0X8Md7jLc8b5XFeWdzYr1/WyLOoVrvRIEpW/xoZsgndCCM5f9VblHCLB0a+2Iw3CSPAYziifrDpWa3JMvFSldybNhZeWUMOWT82zrnrb3rGmToX+VJuYf4oA1fXGogb6CP9ErYmjg1s/W//y+SmSV30glxFwzTDc7yGoFGQW+Xn0tao0zzrKX2URNLA/xaK12xyIAvbvKElgLFgW/Hljly8zg9xySbwjrdrEiEK9OVzYXNlB7q+HDDbda2T9d6k+qDynVcv2xqfBzyUWabWjtK45+B7LvQCNnpZJX6a6pHSEXg3+/IDyI8mipUV/L6PFt4NWylZOfCDt0SHufk17XaLmGzNP5bfRIHkhZdJzX2QFQz5QHP3KSwyW2NkTS2r6ZFIjWrrWPTYCES6FpKB6k2WPd0B8XrweqwWVp1aXb/GSX8yErFpytQ4kC1NkD4o/BPkv5lf6JAWdbonZWylqJ83BmGJspWf9UCXmCzjt0nx6DKHDGh2/LA+FPwGJq10eqhiyIOTAvGXN2qCGAHmCcB1TV5/wr9///q1Sg7RUuQEc2OwSt99RHnno3XyT4HdGwEZ4UiiWBiyfYU1mzwGRhTl5d/jojmENhXBwgSnBTjM3+UTucw8VL1s4Yv+yuvLNOSz9oXnYiS9NbozZCLjaPARGYdIN//gZtz
 siekTLwK
 8YHquR07STiC8wjoFyz01vv473E+zLxdGjpyK6ViZiHmak6NZUejf4Tg+plSZEEjSR5gR7UzLBMbYuD3k7qkMcUSOH15MXIPXuo3moN6VEz+5/+dc44DromuKzVerMp3A3wSp3gcNyP5dw4BDmlR3kSiNICymxvhKJ6e63jKnOQcQU/ZhpcQqowkYam2SlPtOdPQEO4t3kuEyMjS8OszCWjXPsiBrAKUlnhLVY0HTxi20F2t9I2o4VX5o23QYvH6chhzBN0A0EBcab32ZYfqEFu/N4uoDLWdNewvKB9D3Fcfxw5MGL7DCsxocfDw7r4M1l9iYyjjZAN0mTcQvS9TS++YX7XVNJ8BATxP4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 16:26, Ren Wei wrote:
> From: Luxiao Xu <rakukuip@gmail.com>
> 
> generic_access_phys() improperly validates the memory access range. It
> only validates the start address using follow_pfnmap_start() and then
> uses ioremap_prot() to map the entire requested length. This fails to
> verify if the access range stays within the VMA boundaries or if it
> crosses into adjacent physical/MMIO mappings, allowing out-of-bounds
> read or write access.
> 
> Furthermore, the previous implementation failed to handle partial
> progress semantics required by __access_remote_vm() and lacked
> necessary concurrency checks (retry logic) to prevent the use of
> stale mappings after releasing the PFNMAP lock.
> 
> Fix this by:
> - Processing memory access in page-sized chunks, ensuring every page
>   is validated within its VMA boundaries.
> - Introducing a retry mechanism to re-validate the PFN/protection
>   after mapping, ensuring safety against concurrent page table
>   modifications.
> - Returning the total number of bytes successfully copied to satisfy
>   the partial progress semantics of the access_process_vm
>   infrastructure.
> 
> Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: Codex:gpt-5.4
> Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
> Signed-off-by: Ren Wei <enjou1224z@gmail.com>


Hm, I wonder if it's responsibility of the callers to make sure that [addr,
addr+len) is actually within VMA bounds. Just like it's the callers
responsibility to ensure that "addr" falls within the VMA.

That makes the ->access() implementation harder to get wrong.

-- 
Cheers,

David

