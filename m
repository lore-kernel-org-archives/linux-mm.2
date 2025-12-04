Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F16D2A53B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A05E6B007B; Thu,  4 Dec 2025 15:58:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450DC6B009F; Thu,  4 Dec 2025 15:58:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340FE6B00A1; Thu,  4 Dec 2025 15:58:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23E586B007B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:58:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B6C851A02A5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:58:11 +0000 (UTC)
X-FDA: 84183001182.28.DD84075
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 15A0D180008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:58:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uClXz34X;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764881890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+A2Fv0iOqbL7KYLNpelnPx5k62VuTOY+fSutEiUX6c=;
	b=lIbdywrsTz4UWrOWcq+li0Iep+WSJFUwXGoGedCAu8yyPNv10ttWGj0w0eVssVrSlcx3Hy
	/eBLsOCXgWliyMgmoEHSlJ4CSKnIGRxY2aEAXSTJ5lwx0LE3fZd49HEok/PXdTCrRLwJ7/
	7EskR2aeDUq4R83heyQhmU9hvwo+FuQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uClXz34X;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764881890; a=rsa-sha256;
	cv=none;
	b=YLE9uSB95xxHqWW0bA5QnIH1gTI4oLDkGhoYJtCZJN3UlQV35oMZSN53F+LymIwAa23w9h
	vYkgWhcA4X5iWu8tRTwjaOWohjJj7ZkOWUydQbxzLnVcudxzCd4pIUxxZ2d2uAJK1/jreA
	o40UauEbZnrc56x8mgfSWbRceiIOqi8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D21B60202;
	Thu,  4 Dec 2025 20:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F3AC4CEFB;
	Thu,  4 Dec 2025 20:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764881888;
	bh=loobrzi70Pz8tRGrBPxxU+Z3c+tNVIg/LFKhDULsEAI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uClXz34XPXMkEKff3YIWkBOZ37RSNuVgI+nxzOy4TOM+DZPFXJFT5LoRMPVzQVDB+
	 eGM6XD/mm14R4hH1LID2HzwVCSwnLVXazDKHDElM9jZdFe2JxumKbIvocccvJw7wPX
	 SpavRLRZFhmxTuotit33kbMWKD3Jy9YkeXhOi9JHK2fZiONV1G26eNS58b05e1lX/M
	 WkkyCucIFVM9KECbZuASEanszKlXzX74vlOX2t8FAWc163PSPTdmjRIRhB4TQtECbE
	 XhqjHHjVFKU7pN+ZflKZPDUQdRq8mJjx1d3ZTOmZpCS1u3E39BiOePBI/xM0TBvqRB
	 QPZLVe7hqQKnA==
Message-ID: <48344838-d601-45ae-b260-01eb6b2fa422@kernel.org>
Date: Thu, 4 Dec 2025 21:58:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm, hugetlb: implement movable_gigantic_pages sysctl
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, osalvador@suse.de, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
 muchun.song@linux.dev, Mel Gorman <mgorman@suse.de>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 David Rientjes <rientjes@google.com>
References: <20251203063836.187016-1-gourry@gourry.net>
 <305328e0-3011-409c-a040-76fc478d541a@kernel.org>
 <aTHBjU5-Fio6CrwD@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aTHBjU5-Fio6CrwD@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 15A0D180008
X-Rspamd-Server: rspam02
X-Stat-Signature: z5zrhgrz5scoq1dybw9bt1o5d86yzyfq
X-Rspam-User: 
X-HE-Tag: 1764881889-666678
X-HE-Meta: U2FsdGVkX1/wETxRny3vFH100DMpN5TI8MhMCsTNEEwlf+0eDJ4c+i4OQ3PN1kPW+7V4ig1HXvyM0k7w2apdjFfx8NlflFFhKIDkrhg4l7Sv9laf5vkeNmd+T45nTxuSPmjb42B/dZhcVitESTxhPrLXNNxX62tFcDkGASIgdOAHjsXrxHtUwNDhzJHe2n2bh3i1bBDbHu+w6ApotanOcZNDonvbzSZCYecrOXtxROtzZ28DF00zy7fHYuh1/ByuPjwtw6P6mVgMi7KO009JjvsAccrJn08grVaR/QkDve3SDtT6y576eT8RP8hSgntgZIWKOt5UaqOqoJO012PSIK4Ry2sizCl9vC95fzY3+PC23XLH0/Kq67NrinN3nSrBVa09KfMl4PZWd79A60IP3Y7hZwSIK//smCvtH1XdsxKUria0JMLL1hGx6RhiI195VP7YbLkP3pG7Q/PZQF5terPC3Y9LHcMWZm+O0ojNTsZx/J5hjTJGEAPtJkTl+vVQV38b+sDFoH6svNDJdgR2RvuF5yytkf8zEp91m/nQNPqkSskrE4QfGNuy5Xf4Me2uF+kv1GXeC69eD93NETeyppmn6U5VIuQ01rxcIrGqaPIY4iD5ZN7OQUWnLy2drZlQ/m1FUcctNN3pU9xDxcK7oubQsDW19qnt2gIL9MIRctvIostIJsULxSW+85c1JD0XLw9edJH+EawYzyVxe1dvWR0JNxoRANmByQkFRyvwpdFyOAVcRlWmRMb+B1Mp7z6HrirzBKMLUNMH2P7/SaY/JZL+RtXxPiYo66L3UXNaz84xo1hnBbI2qO5250eTSom+M8HOBCGKfQPb7mvq6W+2Bk+9gkq2Tx/HWLgzUJgvlUkU0UIvv/cTYRlCSeb41YEdzpVKgfpY1edSH5dsOUKaViAFRGZZHn0oPs1DEsp+x49EnfokEIlSxiaQt/E5NN31Mhe3OP82zlSsESyB1Fb
 s3NkDzAB
 A5dflNTUhwJ4hmCx50EAbL+uR283eB7lOGTaM3DpZtCeO6qp0sBbdiLzijh2b3ntjFdQMFAQA3rDKzPrBqC72xs4HbL6Futb0o87Ol/l3OLyBT933WZton8Ijxif19GvkNHULwZXTVEG1Y9U0UH4cRH9okgrUEfE5hHYEByrSmwK9eucXNlQa3LGLoIKET/4n3jnRSZjNH55t9gRTN4yhBDPWDbHT8ZNYCRismDCkjQWC80VZoYeU2Be3lc8+N7uVnkmW4jhS1OZ52NAk7wHKHznGcT6/89l9zd6QbROGnMUHeDmSGAHPq1WZ+QWdSWR8o5B0Gron7dys0l7uO9LJHvba9M6HEN71kG6XGk3JOJQpvyThofVAwVq7+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 18:14, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 10:26:20AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/3/25 07:38, Gregory Price wrote:
>>> This reintroduces a concept removed by:
>>> commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
>>>
>>> This sysctl provides flexibility between ZONE_MOVABLE use cases:
>>> 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
>>> 2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable
>>>
>>> When ZONE_MOVABLE is used to make huge page allocation more reliable,
>>> disallowing gigantic pages memory in this region is pointless.  If
>>> hotplug is not a requirement, we can loosen the restrictions to allow
>>> 1GB gigantic pages in ZONE_MOVABLE.
>>>
>>> Since 1GB can be difficult to migrate / has impacts on compaction /
>>> defragmentation, we don't enable this by default. Notably, 1GB pages
>>> can only be migrated if another 1GB page is available - so hot-unplug
>>> will fail if such a page cannot be found.
>>
>> In light of the other discussion: will it fail or will it simplt retry
>> forever, until there is a free 1g page?
>>
> 
> It retries until a 1GB page is available.
> 
> Example test:
> 
> echo 0 > node0/hugepages/..-1GB/nr_hugepages (dram node)
> echo 1 > node1/hugepages/..-1GB/nr_hugepages (zone_movable node)
> ./alloc_huge &                               (allocate the page)
> ./node1_offline  &                           (offline > memory*/state)
> sleep 5                                      (give offline time)
> echo 1 > node0/hugepages/..-1GB/nr_hugepages (dram node)
> 
> This node1_offline generates migration failures until the last step
> occurs, at which point migration and node1_offline complete as expected.
> 
> The migration failures produce the following:
> 
> [  707.443105] migrating pfn c080000 failed ret:-12
> [  707.453353] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xc080000
> [  707.471315] head: order:18 mapcount:1 entire_mapcount:1 nr_pages_mapped:0 pincount:0
> [  707.488504] anon flags: 0x17ffff0000000848(uptodate|owner_2|head|node=1|zone=3|lastcpupid=0x1ffff)
> [  707.508393] page_type: f4(hugetlb)
> [  707.515940] raw: 17ffff0000000848 ffa000007d873cc0 ffa000007d873cc0 ff1100082366c6e9
> [  707.533126] raw: 0000000000000000 0000000000000010 00000002f4000000 0000000000000000
> [  707.550317] head: 17ffff0000000848 ffa000007d873cc0 ffa000007d873cc0 ff1100082366c6e9
> [  707.567699] head: 0000000000000000 0000000000000010 00000002f4000000 0000000000000000
> [  707.585085] head: 17ffff0000000012 ffd4000302000001 0000000000000000 0000000000000000
> [  707.602469] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000040000
> [  707.619851] page dumped because: migration failure
> 
> 
> I can add this to the changelog if you prefer

Yes, we should document that. I guess it's just what we already document 
in the memory hotplug doc: it keeps retrying until there is sufficient 
free memory.


-- 
Cheers

David

