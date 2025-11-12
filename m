Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F6FCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 10:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8868E0019; Wed, 12 Nov 2025 05:09:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0278E0002; Wed, 12 Nov 2025 05:09:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5CD8E0019; Wed, 12 Nov 2025 05:09:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8348E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:09:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04DC713AFC4
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:09:58 +0000 (UTC)
X-FDA: 84101534118.24.8351825
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 23E3820014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:09:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ipFvEp/h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762942197; a=rsa-sha256;
	cv=none;
	b=tlxmCJEpfoipt2DELM1zawB1Girn9VU4I5bW85zi6lCsTcZ4VWPuo5zKxrCl4GrApODOCI
	n+J3uineh72ZLMkqayAsv1B2rL2Jy/LZBCCiRAKVLzB0bhdRS8DmpexagAnzwbhLxyIb34
	/1W/SaebEw6xEv0QhRWX1Yl7DuldvBQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ipFvEp/h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762942197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSFxej47CRo5G2gO4PHK9FI8eRqtd9Jxs0aSu19kvY0=;
	b=8UBkJG8NjK1QfkBqX5IrDbfZc/1Z+wE53iO+ULIkWM035pjcob2P77IiLZhPtau2+aSaLr
	CSdGcFUgTx/wEq9rnp6quuoSmbp5vq4zoa20uWKa11jZg0aA/SOy4m3J5QCtlMD2p4Rw0h
	unMJH4diHK4UWd5GmknjCTGjup41k2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 268BA434CF;
	Wed, 12 Nov 2025 10:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABF3C116B1;
	Wed, 12 Nov 2025 10:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762942196;
	bh=0pN/N/WAEGV8G73wqQYsy1NYVE302SNrvtLisTX/RFM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ipFvEp/hfILLkxsY+k06HidEsIf8ffPVLU466T+rWPF18sHN42s39t8W5OlLwF0z/
	 lr6PIvS4/3zfBmi0nnpAHZRlwFz2ly+RoNeUYXVCNUdKXZTsZc9kcl/xUvxsPhu0+J
	 WHC/KK9Hbx/fSQdNJOTteV9VznFF964AGjiNI9PO2E0mPbDodJPtvQ0fjF+m+fE4eX
	 4PqWdflNQCw4yhQbbtfxOd7ka/AMObTnz//MZaOqv/Rslr4pKDUgL7FkRa4MdHD2/U
	 cJHKybdmQJuqzbjMmpd7LA7Zx0JYL6YpTKPnzkEfFAw1NqiMcVHk4e5kbLuGSHqzoK
	 zf40DMoPvzYYw==
Message-ID: <6a63dbb8-58f7-4511-8090-18a58c3206d8@kernel.org>
Date: Wed, 12 Nov 2025 11:09:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memfd: clear hugetlb pages on allocation
To: Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>,
 Deepanshu Kartikey <kartikey406@gmail.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
References: <20251112031631.2315651-1-kartikey406@gmail.com>
 <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com>
 <aRRPvn4DYAhuGtq3@localhost.localdomain>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aRRPvn4DYAhuGtq3@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 23E3820014
X-Rspamd-Server: rspam07
X-Stat-Signature: qnx71gbnxnyhdr4ryowtx4kb5hjazhr8
X-Rspam-User: 
X-HE-Tag: 1762942196-265739
X-HE-Meta: U2FsdGVkX18hfHu6vaQzH3g9e+7ZziGyKUfS8osTzthZ6vEbsdm14baG6lHyShNxLnRTlGFP4loKt40T64zK0bJ6YyHbb2Be0Us/Kw54kOdOkQ2Uw6gD8qiFp4PPiY6RdfRA55DI8pZqs5/dAH/kdtaM8w50AXZMiFy1an1LFjS9netCbBeZ9DoQ3RcY6JHpzrlnAZN8naxZWZzb3sAy5356ID9ygGpRXnrexuOoRFot3EApayMS4d6j7sHBUnM5ZIjCycdMwVfg0xFx5PMK4zTUAySvnE7gJBtxtgXnDxyX9jp9/4pFSVLfRnflhe7QRNnIwavVKzO8ETSEP3IBN19Q8BGjLTWon+hgazxB5ECFz2JIq9qVo008SgWEMydOJQF/jwn1qs2h9NIe0CRNZsK7EfL6/iKg2PfxHfWrAkHyPtI+4DU+8p+d/LLVLBF1DxRaqfjnW4/EDl/2iftOI5hhaGYFbEaS3/ym0YV94m1LoOPGn840gVjq952YFsQA8y0YvMOPvnqYAM8aJqmawseOL46Rjz62GY2JkTdYIEIWRBQtSCtZSNpG0fvkMzbP1MSdTx9jy9R1hEqzChjhUOenFqaUuTteczSHrXPx1O+lahwAsXwCc7in/1S+uvk3ierxl+C9138qv9mG6S6iKdqGsPV918t2cvZrIo+H4bm22SBnt1gJ7hrJxnCMneTURQbQkThRPg+M1DzK9pZl8CEkItjq7CUydHQ6faznZWN9AG21t4hPxMmgszMwxLtPg7C5ZkxtDnhrr5CQqg+jsMYfGWuVEZ5oAdSd2pnxx6j27YfBnlqzVav5vl/4cca2eeKEeshiKsFfegfUTo9ayq1BJP8/BRVBr0RV6dRY5j2qwtHK2xSaNJiLZ7y5IOytd4yfNvalSshZPv0i4RbCe5EdpkcssPrIaPBykvMQ+oQyAtShstIHD6sW+In69RsanYVfVkeAsD+KhzTYyMR
 e/aDOZnn
 RzYF866MdCCnoKIwdZ/LBHjNh09lwPYLFT+V+CGKC1qphkenys3IcE5+dI7PCh393CbQJO35I1osKXQ4soXfV5xC82HEdiWvSAE75+/NXn213dtLQ+jjNHe8+3ZgXaMpF+gs/hT7UYMS1zTSlX3nt18ma94V/9tK0UrqvVgOj8YH0YeQnXAqLAO7Px/opZrop/mSJg2eUI7AuyPnxvAEOPVzJMNWJi+cL5I73v3rGwr6Iu83idsSKqcu/LTY/bvofjHfZKEFebw1Sp1rEUi4ecoUWp5vSFGfPMlD9EYFNPlMAV24BUsITSIrJYq1paJQBIAwG0GhQf2cf5jSeliX3OWHicVj94/1yfFw4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 10:13, Oscar Salvador wrote:
> On Tue, Nov 11, 2025 at 10:55:03PM -0800, Hugh Dickins wrote:
>> Thanks a lot, Deepanshu and syzbot: this sounds horrid, and important
>> to fix very soon; and wlll need a Fixes tag (with stable Cc'ed when
>> the fix goes into mm.git), I presume it's
>>
>> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
>>
>> But although my name appears against mm/memfd.c, the truth is I know
>> little of hugetlb (maintainers now addressed), and when its folios
>> are supposed to get zeroed (would a __GFP_ZERO somewhere be better?).
>>
>> I was puzzled by how udmabuf came into the picture, since hugetlbfs
>> has always supported the read (not write) system call: but see now
>> that there is this surprising backdoor into the hugetlb subsystem,
>> via memfd and GUP pinning.
>>
>> And where does that folio get marked uptodate, or is "uptodate"
>> irrelevant on hugetlbfs?  Are the right locks taken, or could
>> there be races when adding to hugetlbfs cache in this way?
> 
> Thanks Hugh for raising this up.
> 
> memfd_alloc_folio() seems to try to recreate what hugetlb_no_page()
> would do (slightly different though).

Can we factor that out to merge both paths?

> 
> The thing is that as far as I know, we should grab hugetlb mutex before
> trying to add a new page in the pagecache, per comment in
> hugetlb_fault():
> 
>   "
>     /*
>      * Serialize hugepage allocation and instantiation, so that we don't
>      * get spurious allocation failures if two CPUs race to instantiate
>      * the same page in the page cache.
>      */
>   "
> 
> and at least that is what all callers of hugetlb_add_to_page_cache() do
> at this moment, all except memfd_alloc_folio(), so I guess this one
> needs fixing.
> 
> Regarding the uptodate question, I do not see what is special about this situation
> that we would not need it.
> We seem to be marking the folio uptodate every time we do allocate a folio __and__
> before adding it into the pagecache (which is expected, right?).

Right, at least filemap.c heavily depends on it being set (I don't think 
hugetlb itself needs it).

> 
> Now, for the GFP_ZERO question.
> This one is nasty.
> hugetlb_reserve_pages() will allocate surplus folios without zeroing, but those
> will be zeroed in the faulting path before mapping them into userspace pagetables
> (see folio_zero_user() in hugetlb_no_page()).
> So unless I am missing something we need to zero them in this case as well.

I assume we want to avoid GFP_ZERO and use folio_zero_user(), which is 
optimized for zeroing huge/gigantic pages.


-- 
Cheers

David

