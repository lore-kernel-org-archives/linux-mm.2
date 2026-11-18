Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95ED4606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFGyvYg0
Received: by kanga.kvack.org (Postfix)
	id B74B86B05B7; Wed, 18 Nov 2026 04:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BE96B05BA; Wed, 18 Nov 2026 04:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62E96B05BB; Wed, 18 Nov 2026 04:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81FB76B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:26:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D00B80204
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:26:17 +0000 (UTC)
X-FDA: 85447708794.04.1877EBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4017C1C0009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:26:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GFGyvYg0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCpvpmRay5CD/t5tU4GRUaHaWtAjTRfHVMypBLzz8xg=;
	b=O5xKC+XG7CoWQLIrff4alxunEUlEPENJfF5iHoi6vLv2YepPTOyyeVMzr7bJhuDn0HKN8w
	BSC2RLZrH38xAIXA1Rs9McvoVw/RHJeifoVQoPyaf/EM8Fpsoaw4CxtXmdRWMiYzDdwNUF
	9szJcetYRQVeJycDX/TGvl7FWw9G7Wo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993975;
	b=msrfbVeFRdUfVbSoYyCNaEgkoMs7W3EmD/i1sVL0JjqwrTUpCKd5qv+mPi8Pep18If/ptP
	TuNaufEHaqiKbCntkjCcJUDYXWGu4bROOdaBoXPGh5qbqNWpdrFeMGZiUY1Y+rnD8rLlQa
	AU7tc/C1OaCiufYdrR8KHOK7YN+d0xI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GFGyvYg0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80E834161E;
	Wed, 18 Nov 2026 09:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C436A1F000C6;
	Wed, 18 Nov 2026 09:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794993974;
	bh=DCpvpmRay5CD/t5tU4GRUaHaWtAjTRfHVMypBLzz8xg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GFGyvYg021aA9lGp/EV5CM0n4XTVQQku09tqAxj3wKvcKhVfUmu7U8NeJqLAXZBbq
	 GdUS8KiszLLaFlpuAe9DYQGLQlm70IdM+eow2x0MsrAOTu+CL1NmSXiZ1XLUxaEiva
	 RvXOZvreZ4yV9Qsfbg9LCpgO6y0vJcitiguVIE5flEY40fqmIxoiE6yPENkknz3nxg
	 8mdNCKtakb4Z0PCL41VECBeMGVn/FviYdCgscc1c25GjMNwmrpOa0IxEVWD1waUDaR
	 W73nKx/00g0zeQnzpuVzWKdRLvvfzwJG/Bft+p3mAmvLK7g/uFUZ0+00IZdidgRM8C
	 g/sqKLe/Ml+cw==
Message-ID: <50bfbdb5-548f-41e6-8225-5292fcaef535@kernel.org>
Date: Wed, 18 Nov 2026 10:26:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] mm: print pte in __print_bad_page_map_pgtable()
To: Arnd Bergmann <arnd@arndb.de>, sashiko-reviews@lists.linux.dev,
 Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org
Cc: Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christophe Leroy <chleroy@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Linus Walleij <linusw@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Lucas Stach <l.stach@pengutronix.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Malin Jonsson <malin.jonsson@est.tech>, Matthew Wilcox
 <willy@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Simek <monstr@monstr.eu>, Mike Rapoport <rppt@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>, Nishanth Menon <nm@ti.com>,
 Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>,
 Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-11-arnd@kernel.org> <sashiko-outbox-218805@kernel.org>
 <ec881778-0f77-4f4e-be4e-17dc0adf8bf0@app.fastmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ec881778-0f77-4f4e-be4e-17dc0adf8bf0@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4017C1C0009
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: i6auuo8mugo7k7hx8msmhh4zbnug56eq
X-Rspam-User: 
X-HE-Tag: 1794993975-229676
X-HE-Meta: U2FsdGVkX18Xx0TOdANuYgDA/VvXsRPStQqcigD5ZAB8Ng4k0Bk+IYJFPnmc0P42wKQcTDtx6gjnYG0pnHmhULe3sYSx88gu2y8VzUClbQXkDAOSAzbvADPO8VL4db6dq7h9pRG6AzmbBQRsmZR3Av4H/wX0YwzvCb/J+CnL5G6FDX3eFIw5khHHl3FbrUu0lvk5ENsI/sypv+ZYL8GQmRuY2J8Xs08UBfJ4X8T3A6izYaCD3Jwwf6Hy7Hs94FmrRsy13K567XVe6jx1ndJURUjFu7xCq3kxiho+q1ntIoGDlsPW9tIkupnHh2hVNtXWh/R4Mv+bTMbbuWJNrrl04sIQBBkYyhsFLjn9eRVCphjFsU3Ap6VWjrdrj/4Brf/BqqcMcIkjsRXlBoPROMWXthpbCtE4Z+VXK3cYuRpWyEy8w41LBYIG836dMYXt4Qszfq7tvFpij8rvOAkeo7uY3xx1SY38LuFdDa6cssUBzBeFemF23301EbXTCOB1TsdG/stVeCpF5UGsUwEVewk/1PSPcpadS15cHR2/0wHzPqPX3N3mcaQwKUtJzwGSbLYpwxNj/PtxdQyBhFGv0yrDAMidcfS0ZwfXUqNBeI1WBTm+uhGt3D6WALiH5J4dyiJ8ZDXXoSmMfilkuMOl4YPbGqI3LGdoWZm78bn1uPRJT7sAq0Xsbvoql13kxeVEjeCcldXQ9Zbr/SzUng3Q7fS9nSR1/n4ejfbyV4BNbF6vAulZzKjZ8+YhkLpT+XY8qTkHqSAxD0cqBGg4opWS8up5iIG3SFPnXZFJO9zUpZdZpMAkqYIHJF8w7Ch9P6BOmNRNFZnU9A+PVX1u2JKPqEa9vU3TkmqOOTdkrwtHrBosdgHHTXeKLVp/hnw4fY2rt+WOLKdeSdAIEbD/wQapMwO8YQqNNVDfLNX0r5HerzQ8cXmz77ngbCCq9qg0l63F6vZasnpiNHjDNqAxxD5mbwt
 jjg47cI8
 +lInZ/DaNTlZlzwrjsVFNVV52bexl5S8smtsfkmS+xih4x2I/UEX8wdnJ/hjVx7yCPDB7QYMd2vcH72f+LSSG4WXTHZgMCsrfj9dUJgkm+LAAKBJB3rAE6NeLqhqN1sDR+e+tNhmD0P9hNsSjAKABE0HEUgtaEFAeWXHmrX6I5decYWSxasFqhHTQbfh63uPZvFyHrwmntRQEwbM30RK9mxk51DchvxyI1wbpwPx9wZT6resx3rHBh/GZa6qYUhZt8+no/aZZc1EmQJ9kNBNJsGGYKjK/P7LVXjl80/hX4kGammqIeu+ZRPC3HnvdxoqE/xfFNu6NI3nTyfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 08:32, Arnd Bergmann wrote:
> On Tue, Nov 17, 2026, at 13:50, sashiko-bot@kernel.org wrote:
> 
>>   print_bad_pte()
>>     ...
>>     pmd = pmdp_get(pmdp)
>>     if (!pmd_present(pmd) || ...)
>>                                       retract_page_tables() / zap_pte_range()
>>                                         pmdp_collapse_flush() / pmd_clear()
>>                                         pte_free_defer()
>>                                         /* RCU grace period elapses */
>>     ptep = pte_offset_kernel(pmdp, addr)
>>     pte = ptep_get(ptep)  <-- bogus address or use-after-free
>>
>> If CPU1 clears *pmdp or replaces it with a huge leaf PMD and frees the PTE
>> page table via RCU between pmdp_get(pmdp) and ptep_get(ptep), CPU0 will
>> re-read the modified *pmdp and dereference a bogus kernel address or freed
>> PTE table.  Using pte_offset_map() and pte_unmap() here avoids re-reading
>> *pmdp and keeps the PTE page table RCU-protected while reading the entry.
> 
> This looks like it should be prevented calling conventions for
> print_bad_page_map():
> 
>  * This function must be called during a proper page table walk, as it will
>  * re-walk the page table to dump information: the caller MUST prevent page
>  * table teardown (by holding mmap, vma or rmap lock) and MUST hold the leaf
>  * page table lock.
> 
> Is that a case of do_swap_page() calling print_bad_pte() incorrectly
> that I can ignore here, or should I actually change this? Is the
> same race present in the upper page table lookups?

TBH, I wouldn't worry about. If we run into this the system is already pretty
messed up ...

-- 
Cheers,

David

