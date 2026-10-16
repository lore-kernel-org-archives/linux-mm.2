Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2042CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 15:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D022B6B008A; Fri, 16 Oct 2026 11:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB826B0092; Fri, 16 Oct 2026 11:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCA96B0095; Fri, 16 Oct 2026 11:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96E426B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:14:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 169D4A8079
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:14:41 +0000 (UTC)
X-FDA: 85328836362.09.EA0DA1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3B05E100003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:14:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LE03XN4r;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792163679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5v3J6WKP+bHQTvLWIIelf/Yrhn+GxWTc6CC2vGMgLRc=;
	b=EWfMwgpCx40I3yT/9g1MEhQ1kLwvijGSnDDnkQw5aKLfsX0+ypEe1aBl/nxnH+SlANuNVI
	jjIncQ32AEfC8E/GAevIcvnA1okWyTihiREpgCmuSNRdDyXCfrf7qoV7Xwkytj4A5VGHtj
	csYt23TEQB3cDzV0r4Ew5JS+uKM6/YU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LE03XN4r;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792163679;
	b=ljMid5uNqxRE/2ZBeEY4DzgKY2hS7DjvQ1ASYgXVu3HKiCRrY6zi9X0vM08S8ANPfSEg81
	mDn8SwIug39UcgEZFzykmWx1NFMny+EfGItLV0Elp0ascc3YE8XYkgJOA2HbaEBumu5V+k
	om2KEE5wEM3FCxXQvLocqRUKnawbY08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28D0C401EE;
	Fri, 16 Oct 2026 15:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895321F000C4;
	Fri, 16 Oct 2026 15:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792163678;
	bh=5v3J6WKP+bHQTvLWIIelf/Yrhn+GxWTc6CC2vGMgLRc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LE03XN4rEVcp7wnxG0PrnjlUqFydFo3JZdPbDyihq74fSLSK3hhifkR7kEAr/RDRy
	 +dYgIf3llk1dFjn3QPsishW8AlpPi1OmuYsFxR4G2oP5tRPEwbUWCMDtJEFiNXPklb
	 r+eSQf4ZGIFgRo3CJ5L84/TkoOvxH6/9da83AFC6+KPulonX9kkPgH2s+lR/o6HpQH
	 AznufVTctKJgt0XqtEut1qTg3/Y+v6VkeLJg5anI/8bnmgqAHUWHUdV4iZzWvQgqgq
	 XYEgJq1PQ+2OZxVeJDQJ7u6T/7Td2y3tNKMhml/K7NQUYyzHBw1Z152IzHe3fKOOhi
	 2OUZps1SUKd2w==
Message-ID: <e91e6388-633b-4ddd-b498-d03c7aa0fdb7@kernel.org>
Date: Fri, 16 Oct 2026 17:14:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Improve page refcount scalability
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ilya Gladyshev <ilya.gladyshev@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux-MM <linux-mm@kvack.org>, "Paul E. McKenney" <paulmck@kernel.org>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <atI0edrmeiRuRtNQ@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <atI0edrmeiRuRtNQ@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B05E100003
X-Rspam-User: 
X-Stat-Signature: j86hmkiwhgz16cd3dk3skgc994yckqeq
X-HE-Tag: 1792163679-941182
X-HE-Meta: U2FsdGVkX1/smYXyVg8PRibBUXjRdvEBL+6CcshfEZy5lYMVGjx/NaA65CJ5Zp+vTaju9pjtOnMGpId9SXTSEnbf9ssPh2hBESv+SBFP6Ryhd9R+uA0M8slza7A57i3XT/U47GjT8opBXewLaNmdvBdN1fEgWc3EhU14vcPSnd47hIWpT0KqmaMzYH2wUFl0rJwoKLriZtgJZzM7TXAkY5iRebloCoyiE91LiCvLXJcsb0eO+T9MFI70XHLB20XxdiDBP9q6hHcNWm9Ck7NJInINNBYbpgovbOu07UxpNJe5eXM0LeGtn6aqCnWz9p0PQhBRnJ/8qmAR7CHGcbplEyZAxmsVbkd0NdtBBVpueY0pbTwljRpkKkgt2ED6z1um4CleXzyJba0TDsLCaqErkvqSsJQYv8er0U7KeAadOqYc1XYtxyGwReGpAHPydsc7vA7+bUHs1cxCehEAIzweyfPc3/zsEUpx7gF02xsZ05KiFys9p/BR51nDVmTfHfRcJBodBMf+xPW8SJM4OPvChQkvCuu0mr7Ig8OlVMZ5AzooIfG8tax2YjILYmVxf/Hw4x9HGrJJHU7lRyfMGEcZ/xH2PNxCmXozQXEf6REvnmJfxitKMtszOE6UvyDTMuUBTgLYOwZjTcIG2dLUa9dyrCE/x7JehqVmofEdRaNqIuGwkvffanD2gx5tIAFFqyhXp8LEnqn2nDMEC5qjWcAi7HCR322M5cBdFJIk2TpaUX4Bo9NimD2UMjR7h6rEDXvhj1WMNxuBkky5yvN/t5z52dtjDnsLBIJAyP+r4ZnxeBVdVBedbG39MQfM3lShF+3b8btSFSwgaQc3Drrv8kIUDihJqPsyrbhQ/362MCNfw0L4cdaUOubYCDL+2lGpCyLHG6KhTN3eZrIaGvDy2mowv+CV+Z1zAbVo0vXwf/ryYb0yeDyZtFLW/Qt9Uh0BFXnMnAXEiTsWiSJlCJ9fLHx
 zNmutDmc
 6S4bznJYhAvjhHPkps+w5FOWyPate1G3c1SbXHcPcISpXZoHbNaTvpwdZer9OQxQ3tFuXdB3iwUmVgRe1K1MMUh7PFGVFT3mPbWG2OOJnHwtGkW/bKhZJ9IKkWmBp856FjxjJhbKJbUbbhTln8VFgNDvUoRgg7n6OxCzhuxxLwMZIgpiaUNxcDAfT6nILQD0l05L9Sx493ZrbkOUaxSxpITQIpjQI9yne3Xwj33OHl94QTaGrRIjFyvYv2rLFM8y0f53eNQU/Jv1JR65OVRuw1sBQCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 16:40, Kiryl Shutsemau wrote:
> On Tue, Oct 13, 2026 at 11:43:14AM -0700, Linus Torvalds wrote:
>> Comments?
> 
> There's a regression: the lockless read loses on large reads from large
> folios.
> 
> In a 64-vCPU guest on a Threadripper 7975WX, 1 MiB reads of a cached
> ext4 file are 9% slower from one thread with rcu-free-v3 than without
> it, 64K reads 4% slower.
> 
> The reference path looks a large folio up once and copies it in one go.
> The lockless one walks i_pages from the root and calls
> copy_page_to_iter() for every 4K page.
> 
> I've added a cutoff to the lockless path: if the folio is large and the
> read covers more than four of its pages, leave it to the slow path,
> where one reference covers all of them.
> 
> 		if (folio != prev) {
> 			if (!filemap_read_rcu_can_copy(folio, index, *last_index))
> 				break;
> 			/* Many pages of a large folio: one reference is cheaper */
> 			if (folio_test_large(folio) &&
> 			    min_t(unsigned long, folio_next_index(folio) - index,
> 				  DIV_ROUND_UP(offset + iov_iter_count(iter),
> 					       PAGE_SIZE)) > 4)
> 				break;
> 			prev = folio;
> 		}
> 
> With it, ext4 1 MiB reads match base and 64K reads are within 2%. Small
> reads do not change. The cut is on the folio, not on the read size, so
> files in 4K folios keep the gain on large reads: 1 MiB tmpfs reads from
> one thread are ~30% faster than base.
> 
> Sounds reasonable?
> 
> I've pushed my tree here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git rcu-free/rfc-v1
> 
> I'm thinking of posting it as an RFC to make it easier to review.
> Objections?

Yes please. I spent 6 hours today fixing all sorts of bugs after wanting to get
something rather trivial fixed.

I need the patch in my inbox to not get distracted by all the other stuff :)

-- 
Cheers,

David

