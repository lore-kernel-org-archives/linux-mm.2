Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C6FCF3958
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C303F6B00A7; Wed, 19 Nov 2025 11:29:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE05B6B00A9; Wed, 19 Nov 2025 11:29:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACCF6B00AA; Wed, 19 Nov 2025 11:29:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9281D6B00A7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:29:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F81613B305
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:29:27 +0000 (UTC)
X-FDA: 84127891974.02.CB1004D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CBD51A0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:29:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MaDzWdP6;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763569765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yysW3GAFdDR7cvQccQ37RQ70J/+oCxePvfJ3ChWHfd8=;
	b=ks4KnaAmZVTLRNYg2+kVZ6uhLTiDkeDv2zcd/RWdd3pOcUkBnTS1p893wLffKGkCGjOZqz
	kH9SO68Xf9e102GCF3iAVYVthsGSKrnBSgHjXb9t9K53PdykYUvqDUQqGsU/93Rul/7aY9
	e0978jzSKKIaP2F6ZnMuwisepVb8ufI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MaDzWdP6;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763569765; a=rsa-sha256;
	cv=none;
	b=hhNiQAghqgWV2sEhNL/TQhveoP5Z7hxtmdJhdXo+vXlPQU+bwVgLeb4rUdVIsgfljFsXSA
	WFj4v2N5id+1P1YgnK4u+EIDyhtWLWvLX/LpIdRqyM3AvHfwXhoXcbnWufvaRMDzBq+kyq
	G98TWssI9YhNyq59SjyyHtc3jRU/7gQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1035360172;
	Wed, 19 Nov 2025 16:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAC0C4CEF5;
	Wed, 19 Nov 2025 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763569764;
	bh=TZ758d5/YEZLhoc4VSMgt5fLw/xbPcRGb/+cc267KEc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MaDzWdP675KOgfaKESTfH59kXVQiWdke3+ygU+0OqRL7Sv1m8nQcmarXn+HUWfdyd
	 LCpBntydGltnMTi7A3/308fmvWGG9h955ph5tCtIstowAO37pRffmDPBk7LzBVlzg8
	 zwmgikgOwuTp1muye8MZlGwpBQ2ssgKDdZZ6sAjexroFvTjWU1q3m4oGKT7/37UzjR
	 9cZMW/spKryFmgq20PCPZH5m2h88ALKdSgknqVoFh0+IIoQULdY9xeO+pH7fpaB8ih
	 b7ULLq6ZEIe7/wBE0325qcBbgdNuYAwffq6r0D+LFXdyn+lXi5R7e3Fa21LPNnmnTN
	 brtT9OTr0MumA==
Message-ID: <968d5458-7d2b-4a8d-a2a6-0931cd87898f@kernel.org>
Date: Wed, 19 Nov 2025 17:29:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>, "Uschakow, Stanislav" <suschako@amazon.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
 <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
 <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local>
 <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
 <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local>
 <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
 <2bff49c4-6292-446b-9cd4-1563358fe3b4@redhat.com>
 <0dabc80e-9c68-41be-b936-8c6e55582c79@lucifer.local>
 <944a09b0-77a6-40c9-8bea-d6b86a438d8a@kernel.org>
 <1d53ef79-c88c-4c5b-af82-1eb22306993b@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <1d53ef79-c88c-4c5b-af82-1eb22306993b@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9CBD51A0006
X-Stat-Signature: px6yrr8bnuqppbdacrhmifrrnfua8qwa
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763569765-766543
X-HE-Meta: U2FsdGVkX18dRt8jX02UevqbvYTdxlDe87h6gp6tE+cDspcnzmvpyFUbY4rBAgzW87UwMGLvfiIYxClmUHW2tEbrwzJQVfJDg0PRmovTNH4Wcq57gt4tlQNqi0cjN++VN41R47QXOqWzeXAdIxIa23yfR+umF4EV67HHUn+NT7CYFoRh5c59Eu8S0K0F0HYNdhhyrUweezF16vPxXGipyinO/QESFjfvLrqy1dev10HDWQt0cEZWsoXkpIy8ihVfEgvcsi4bALz4bKvmH9Jl+LluwrZousQ+vY4Zrcwo6WgAauIrBdaEraMKGDHUMJ/ghx2VSAgCOHtVNT9TWdQF4azUN57VuKPhIJIYUxHNUquT3yE9FsBCaosCcFWPq4FtsRxn3vaDOJESV5moRsy0ZTBU/TvRkUiOfcS6OGimIW6sJz/jYw42QeDcdhW1fH1c/uer58cZVkz9MGyaFbronsQ4f++8rRSpohcJLId3eA3NnS45hU+8Lky1mJnsbV1AITMCFib2f/1tyUaLmPwve6Xu/PZmsJEhywDigqAV4LFoVvTBi8jOsE9iVPjO7C7kVFRoZ4sEPj7O5soVvB7uIvy0Q4JIrhAAdP53hSRjp0J1NDO5hZ/PMgNrS+sMt66kcUX27z2YKOZVp3BUs9tPhB4Ppmyfc5XfGImLFzXu/57tRGtv1xH716N8j4AdoRPK5h2y8BdsSY4J7hUBOwyBWEXmS8SUdpufzsjDG6DOY11NXdNrFV9U9ViauZps08iCRm1iezRzP9hMONO5XSVOfc0wUnENskj7zK8Z1U5RzvlVXaviXUMoM76ueXQGJSoscOPVDZWEk1iCPtZ8tEFDNNQGwODqf3Dwh5ooq9TR9O6Zha71zWyleL2czdUOWvF1UZ19z1jj/qBrtZGFonJSQx6XlEdgiJ2eyI2nHnF7gZXoWFCgznzGOq4mzKNdbh9tDWO1O2SETblXn+XOvZ7
 /JTcUL7x
 Fh8Ptq3GLQJgyUcUReQJOGbn27VhmcZErnp89Od5cEqbW3PmckG2JpyRm1tnsXqobOknoB93SxRGcQDLgVu+FGN38/FiFkCKpv5sxY9yrg+VfwwLtnYdYLGMYmmYmlv3ZkAPJrjp1bJWRKCH5u9HXwSq7qEVaNiCu0Te+1FdgqUX0OuAwd9X7Fv7z8M/Uxbqmg7i/s9DeHwDcw1Q4teE09c//+SfGvzlPkVWbjBJibMYE1Mlz6pxaGXU/X3dCkdLgAFTSf8S8IWUL7zxI+UTJP2CdGgbqexGOoiFtm7JA3mAHpUpeP2Yfwv0LY4Fuq2Qsqe2l3yByUTPy7Ue8G/IbmNRFbZNQ9CSWeetq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> So what I am currently looking into is simply reducing (batching) the number
>> of IPIs.
> 
> As in the IPIs we are now generating in tlb_remove_table_sync_one()?
> 
> Or something else?

Yes, for now. I'm essentially reducing the number of 
tlb_remove_table_sync_one() calls.

> 
> As this bug is only an issue when we don't use IPIs for pgtable freeing right
> (e.g. CONFIG_MMU_GATHER_RCU_TABLE_FREE is set), as otherwise
> tlb_remove_table_sync_one() is a no-op?

Right. But it's still confusing: I think for page table unsharing we 
always need an IPI one way or the other to make sure GUP-fast was called.

At least for preventing that anybody would be able to reuse the page 
table in the meantime.

That is either:

(a) The TLB shootdown implied an IPI

(b) We manually send one

But that's where it gets confusing: nowadays x86 also selects 
MMU_GATHER_RCU_TABLE_FREE, meaning we would get a double IPI?

This is so complicated, so I might be missing something.

But it's the same behavior we have in collapse_huge_page() where we first

> 
>>
>> In essence, we only have to send one IPI when unsharing multiple page
>> tables, and we only have to send one when we are the last one sharing the
>> page table (before it can get reused).
> 
> Right, hopefully that significantly cuts down on the amount genrated.

I'd assume that the problem of the current approach is that when we fork 
a child and it quits, that we call __unmap_hugepage_range(). If the 
range is large enough to cover many PMD tables (multiple gigabytes?), we
essentially send one IPI per PMD table we are unsharing, when we really 
only have to send one.

That's the theory ...

-- 
Cheers

David

