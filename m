Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07645CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 18:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670BC8E0005; Mon, 10 Nov 2025 13:29:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6479E8E0002; Mon, 10 Nov 2025 13:29:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585768E0005; Mon, 10 Nov 2025 13:29:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 484198E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:29:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8610C0220
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:29:29 +0000 (UTC)
X-FDA: 84095535258.01.AE40C41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2FAAE40010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:29:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZronPL2;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762799368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36ZLXKuH6aaZ4B3B9DwYvzQQJ42i3M6hGzQ4TqHn9S0=;
	b=uRuGi73w1KH57r5hQRVWtxOzFcEics7x5H1ZpzYmb286+OG2LLWRCRewxLyBfOtwX4S2RE
	a4PwNFU/2wvaTXYy7dvLK5n5nJ+5jygmltAt5JztteobYRQ1Ish2QUStyrIcS1xWSpkgLK
	OyQDGqCDNuaf/z1kbeQITsFlr0VG35Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZronPL2;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762799368; a=rsa-sha256;
	cv=none;
	b=wpnAxDRUbEjCgJwNe5FRZzIfQqK5WvsBbuVPzVaY2GT0OAeiylF6lPLFjTf1Ja/hUL97TX
	akUufrH+1Yw63ZKNW+zofKfBHxelRCUD7OazPXnn8th7vGAjGaf613J49BqqfiXTnSxWGP
	qZlABrM2129iLSt1WVf+Uj3jSwR6yXw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 927EA60144;
	Mon, 10 Nov 2025 18:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14F8C116B1;
	Mon, 10 Nov 2025 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762799367;
	bh=vnrR8EFpufqGwq1f5pDV0cFkGbmnECjWMICT4b0JH7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HZronPL2JFd0m3EVOakqveMN0/VpvlI0Hr9SxZxRe8KASYthT2jZ2rKJ6xHcVWGhc
	 jrN0x/CbOpU4mjGorNKiX6KhJ3JDEK5WB0WLC89Zn5ofFvyIeCX957WVtJULeMvaa0
	 b3nLdNd8JdoqI7mIfssUKcRqkXaIzFuiOrk+og9hcKbMg2zaQKqe+4wIxNzqZoOJdJ
	 4RZGLeGUxSfpeIsPT3if0GlEWFKrEcg/Ml0BmyJ9jUJo3R9PuZaelTy9OUZVlpeRL6
	 c9dmDjF2CBZxRwoVxEV2kr7vBXsL1MGp2OCry/K+K2WHLs5XASJR5dOBf4pjmZ1ITy
	 /y+tODM2PyvNA==
Message-ID: <760aef03-54c6-452e-b507-6210433f9943@kernel.org>
Date: Mon, 10 Nov 2025 19:29:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/madvise: allow guard page install/remove under
 VMA lock
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1762795245.git.lorenzo.stoakes@oracle.com>
 <cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2FAAE40010
X-Stat-Signature: hzihdpx9g3wxe8ycpfdwik7mj5qz4wwt
X-Rspam-User: 
X-HE-Tag: 1762799368-559604
X-HE-Meta: U2FsdGVkX1+vQKkFMSHzOLra8qC1qMui1oLE6YDuWn2400uEACQXUyahxe/R4yyeMJYuP8txy2cTWvF/7AXe8+8aIYuesiWdBULihAwvHKMKGxuolCqrQPJZHtbOQTBg0+1Sf93+GHP/n+9+QnNniP5ePbf91b4XlA5IyN7JEh/I0a8wdsqBHPGyFQfJj9SoQhfj8HPiPyt3ZJzKLna+wlVVSIya5juW2MUgumAQkKBvE0fdT8QGJ54vtQNLoVdZWDbAReEC0bhew7LCmDTnwn5jWhQbqRTrORhyAeT06OcNAtfERcUo6M5RmT9Pwsy/R8dfL99CWr16on2ipsSBKRf7Wwhd2vaSS9l6JLxiLeX7fqShcMmgUIwcEo3pQd973Le3vTo5riP8p5EF1c1GHanRNlEsP8bUIU91zp/brYNqzf/Rvn/kqXrxa0I54Dy+6ZO3+ClVqc1UMxyFWkzgXtjnDZNIt+afog+h11T+/WghYlnHU2J1+A7KlFRNhUx4TtfU/CygKkAJMOKRDgPB3jJSapKp4IIw47IlO80oH5kbtnQ1KJgS2Qqm/7bpf7nrFvQ6Qjx4D4HHuHJFIvOh0Omm+GdWHMoX9C7+50p80fINP1Fnt7V6oHD636y4O9SQb0yQgqeT/f+AN1NR7RQcl7BUzEgNqtV0p6ZoH5fXQVKyNi4WlJj9M2TJgWQv6adjRaS61W8di8ynMGRRCOssc2Nq99BUHdb/xDvLGO3Qvn+D6vzlDUGCEkxWFioLRbFG7uKKV1xrNjtZxo6cYWBAWe6ExnE6UpY2yHxhahKSu+ZiOO9al0HhlOdwtar/8s8tIu7JnRa9A5oj3EYuN/ZAu4Q1CLy+r2yAdNU5Zjz+SGotUIilATHl16BXc0qo76MTcBP0HdXPCqMX0JYE+iQRZOIfmReer4390d7uksMMN241+vdyDu7h79uUv67GrtUEhVDpTfaeAIIZo79evI3
 nS4xT0RY
 PvSE3vcj+6wkIE9Y7VdPU2WpJ2mqfxbq5VRWwn4lPY1cvlwHp/tXkftvRDUS3Mu3i7Uv5uqo9GrptU7yiQfMzwWCHRzFpbbWZoC3o36LnFhOcDny8n9+Iv47MG71kHFZdsnElmqxNhFPDRJEyUnDPldCxWPjSthMDgBCKvoMffCLHf/uHBbumnm5llEF3cKAnK6Sh2O8FWFY6y1xBI41iQdomEyuCpk6IWHfcHZ2yNp9nddli7s9rR5w+JnbnXWthOJNAbCLt/2bZZtoOERlbz4AOmISMc2Nm6A7AvpvxKzlhg00=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.11.25 18:22, Lorenzo Stoakes wrote:
> We only need to keep the page table stable so we can perform this operation
> under the VMA lock. PTE installation is stabilised via the PTE lock.
> 
> One caveat is that, if we prepare vma->anon_vma we must hold the mmap read
> lock. We can account for this by adapting the VMA locking logic to
> explicitly check for this case and prevent a VMA lock from being acquired
> should it be the case.
> 
> This check is safe, as while we might be raced on anon_vma installation,
> this would simply make the check conservative, there's no way for us to see
> an anon_vma and then for it to be cleared, as doing so requires the
> mmap/VMA write lock.
> 
> We abstract the VMA lock validity logic to is_vma_lock_sufficient() for
> this purpose, and add prepares_anon_vma() to abstract the anon_vma logic.
> 
> In order to do this we need to have a way of installing page tables
> explicitly for an identified VMA, so we export walk_page_range_vma() in an
> unsafe variant - walk_page_range_vma_unsafe() and use this should the VMA
> read lock be taken.
> 
> We additionally update the comments in madvise_guard_install() to more
> accurately reflect the cases in which the logic may be reattempted,
> specifically THP huge pages being present.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Looks good to me

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

