Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 115E2C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C3B6B007B; Tue, 21 Jul 2026 14:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153446B008C; Tue, 21 Jul 2026 14:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042C66B0095; Tue, 21 Jul 2026 14:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9416B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:12:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E9751C0142
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:12:45 +0000 (UTC)
X-FDA: 85013579490.04.147A814
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B65EA100006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:12:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bvdgVv6s;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784657563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kl0Lh6FjGEgG1H/3xD/a8p3nj1WAQN+duTO4F2foLOk=;
	b=Io5NNG45JdISYFqcXwv+p26xrhDWzo44XUoS2PmJ1A5T+XrI6ftRyHUpSHbPtLxuh93rzn
	LE/f2XH/XegTg416zBSLHaZPiJknUqN6nxyVhYWdPMVFY7NPs2oGfPfnnb1NUKQFWpSdZk
	M/enHimpOz5B4L8Egh5pcIn7IScGMiQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bvdgVv6s;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784657563;
	b=ge1YTKTCsSL9LVQQU2CZh+xGX60XBMw6Z4qQhn2P9Rk15DWzcWqngu8PxRHO0GrJUbr4kn
	jBXljuXVfB5/zQr282BFwRFI+lfnBmb2OrONEiWDrOXqB3SrJpXm0nkowGzH0Rtt53Mq1+
	uRagOJQF7FzWAO7Ilx54UlhwWPwkS0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D976241395;
	Tue, 21 Jul 2026 18:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D111F000E9;
	Tue, 21 Jul 2026 18:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784657562;
	bh=Kl0Lh6FjGEgG1H/3xD/a8p3nj1WAQN+duTO4F2foLOk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bvdgVv6sYnZOASG/ksH9sQhf/lJzzXdiBaiQw4qKoPbUwo8rmsFbdnFL7KJkOSzzo
	 qkbWcYA+5g0tRRv8TBOdqhhU6lEtcvLeI0Uy8tgPF09Ws0ZSujd0n55HbnxKo0oC9u
	 K5/0bXQjlcKvvBX2ny4JRMxCxlvrem0vBvhoKO8nOe3ve7vBr35CFb7J1GwzlVfePA
	 z4Dj6v723Rdu0FdpkO32dxJn1+tiZN2cb6M/ynUx9RoiajTtjMavSg377RTAp6f5IF
	 MS/I28YPA3bXOXRy9RdKD0fWo60E1iTo+iX7FaIwm0pMIXggQJ22eo19LY4DD8gdZs
	 jOnKGEQ9jcW/w==
Message-ID: <cbecbce0-475e-4817-bdda-d1f4c89698d0@kernel.org>
Date: Tue, 21 Jul 2026 20:12:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] mm: access remote process memory under the per-VMA
 lock
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
References: <20260717170036.743149-1-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260717170036.743149-1-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B65EA100006
X-Rspamd-Server: rspam01
X-Stat-Signature: 4p8iufhc37nuk679asq1siipzrwn571x
X-HE-Tag: 1784657563-979241
X-HE-Meta: U2FsdGVkX1+i5V/eUdPo2Snic6ER3wwHEp3adbzr5iB9RTnWJ+HkcvAUDuZr82pQhB+0cvxHyO83KVs9ZFiQ7gi5Y0axjGl3zHO46CsuwOCXH9Kner2c9Hru+Lx/kNp7FEnZaQLOtAOsfTZTUnS4fRr5kQy2q4Dh5RDR8RHu9lnzIPTMyv8FCkzBJevebCred+NkIBqU9p49qzHemuLGztCqHpRMO57LQ6Vi2sL+y5/W8Yyn0uxUOxDDnpMD/wc3AgfDf5IZcdIYakw6nBKh2aVisJCVSFXYn0mM6qFGXvg4EhqXOMgqo38okctq8VNNE8xoOwc5/XKOrk3KR/4Dvf4kVrGFbOw5nt8O/LeNtSsD+KhkhXeCbFtMT43K/+ATrwEvDHONr4ZfuKSakM/3QpZ7YbYSZiWzhVoYbu4FFRYoOD5aYRyiuVtQpFt5xgos2VUerDD5P3+PIJW48bFwTh1RgDA/i6EhUJTMyjX/b2r5/dDxw1Ck5N1MYgYw9oNvOjJK0dlzhZLfzwbhAuIBc2q6ALUra9WVToG7xy5gI+q/Cuy1Pg4DzC0C+EDxAAdfUBIko1p5Mi/F+DsBQ27FBEj3g68IXXLvzqHAGb3+7oeOSIQYm8NWbeswdqfKMS45VkxEDEfSKfR/5cLpyZE4IBzkUya2jYso4GGhZyhTObLR99dRewT/atz8AWw4xHfs8GU9bz+OO64VD6PF9cgl+0fli1uorVZKX/HqB+4mzXURFSo7RLuYHITkOuYAn34SonM65EhS7FlBtTI5bvCtU3ZlsgWSsZ/9aMCRn2t52X1W5bkDpHc/WndewZuL3Fq63UB2jTGyvaij/kp3kDSvynQByEy7t7EyqhIwcyl1r+r7qM+PpL+dU5VKovLx3Eej9+RifnjFvijnPCflc3Yd6yzUX89uIYQ/C/YbxzrkzxLNFhzWQe8dsmCAwT1AxpmYAtcq2pgqjr65KS55pyQ
 hcizJP6k
 YGIah4C/XdCUveHCdPEAzVgyRlF2lsSJ4nb6weBU5ioQz3TwkPnG8lu43w71dsGT5ybiTtUj4VrywRmBxb/XDK8qcbmJfL6jHK9pRg6NOmw5Y+fN+ODJh2Oq2L01NlktZoXR8t4XagVqif/ftfF+eM4CTtCXuznSG7K29rgJcY0KIbNAEnhq8xqa8Afc1WmUHF9WcF5JWCkHHApMJFqK8Iarrqd5fbpvJKzLwZDpYn2qtW6iW6mKyF0yR1cClDRn1TH6m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/17/26 19:00, Rik van Riel wrote:
> __access_remote_vm() holds mmap_read_lock() for the whole transfer. On
> large machines with large multi-threaded applications, the mmap_lock
> is often contended due to mixed accesses from readers and writers, like
> mmap and munmap. When a lock holder gets stuck, system monitoring software
> can get stuck behind that, resulting in a failure to log that the system
> is in trouble.
> 
> Take the per-VMA lock in __access_remote_vm() when the access falls
> entirely within a single VMA. Fall back to the mmap lock when the access
> crosses a VMA boundary, or when the page cannot be reached under the
> per-VMA lock: a dropped fault, a userfaultfd VMA, a hard error, or memory
> with no struct page that has to go through vma->vm_ops->access().
> 
> The bulk of the work is a new gup helper. __access_remote_vm() needs a
> single page from a VMA it has already looked up and locked, faulting it in
> when necessary, under either lock.

Yes, much better.

> 
> get_user_pages_remote() does not fit: it hard codes the mmap lock and
> re-derives the VMA. get_user_page_vma() walks the page tables, faults a
> missing page in, and returns it with a reference and the caller's lock
> still held.

Agreed, and that can be tackled later.

> 
> The per-VMA path also closes a pre-existing gap. A COWed page in a
> VM_IO/VM_PFNMAP VMA has a struct page, but the old code routed it to
> ->access(), where generic_access_phys() ioremaps the PFN and ioremap of RAM
> is rejected, so the read came up short.

Yep. The GUP code rejected VM_IO/VM_PFNMAP for, though, because it did not
properly handle vm_normal_page_pmd() etc so far.

> 
> get_user_page_vma() now returns that page normally. Raw PFNs with no struct
> page still reach ->access() under the mmap lock, as before.
> 
> The series is arranged as:


It will take me a bit to dig into the details; I'll be out the remainder of the
week. But the general direction sounds good.

-- 
Cheers,

David

