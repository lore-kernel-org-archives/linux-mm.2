Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DAF606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XZR+Yzdz
Received: by kanga.kvack.org (Postfix)
	id 8E4E66B00EF; Mon, 16 Nov 2026 15:41:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895576B05B0; Mon, 16 Nov 2026 15:41:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736726B05B3; Mon, 16 Nov 2026 15:41:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1616B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:41:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC925120210
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:41:37 +0000 (UTC)
X-FDA: 85442153034.22.AC640E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D95E51C000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:41:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZR+Yzdz;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794861696;
	b=xCU4jy6wdvPTmXA5n66PIj+nea1fCKggotqO/5tLvWL/7Iri/b8EVzEt08AF6O+Zm2JGnX
	BUQfkgyYk/6+RMzF8tLxg1ONEmmdv14xoZ5U7hkH1n6/FnJejerfWeYrQ5Mckzj0VXxR2H
	EeDYh/n/UkP5pk7UR72YUU+TkgED9Z0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZR+Yzdz;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794861696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42gPF7+Sqfz7dUAfpkhFkb2az57AMCqoFi+goWrCla4=;
	b=oHf/AY5Os57tCbwILv71ks1xoPjSTeclzfoNvm8kMaOgoNmkGTVO5gJDpzSucGSU64Tjom
	5V7ZKAsGf2pUsjh/AwukgrUs9sPQJbWmkClQi0sJ7qfwz0wjKps1NfZqjQ810GSrcifuer
	zvLHQCSDrSBSWdCiJiO74byOsL/YMpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EEA1450B0;
	Mon, 16 Nov 2026 20:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB67D1F000C4;
	Mon, 16 Nov 2026 20:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794861694;
	bh=42gPF7+Sqfz7dUAfpkhFkb2az57AMCqoFi+goWrCla4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XZR+YzdzGO8kVm1OoLFC+f+Dc95f7eCsQkumaGTHmg46QgC1RHKc55NADhs5GT8xe
	 h1G7GZsdMliehYDsulEjZdhbQOJzr+jQfOoq4CXYuOTz7ZpI3IrTzB3E8WtiEyeCND
	 brq71AhDljpkwZvMPQjgVtqfOSbjmpBoE+mghLi23aNhR9keyfcgozSmkmi9I4qRoY
	 qomtiIQ4mg0hnrCh8+YwwJSvl8oq6czuT/JJFq1Xh4uUQzGB4p6rsyijFjBKXMdDbT
	 oCqWv4pZh7+5gE21Rso7ENLYh30obWrZF/K28c2ExWTKosNjVbePQOnZAFn3I+oatl
	 RA9rGyx5oJ7qQ==
Message-ID: <20f100af-c831-4e37-8077-50f6366f323a@kernel.org>
Date: Mon, 16 Nov 2026 21:41:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-7-4397a0196479@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-uffd-state-fixes-v2-7-4397a0196479@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nnpa9oucnmoomu4pmkubwkc5x6xyat3a
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D95E51C000D
X-HE-Tag: 1794861695-182313
X-HE-Meta: U2FsdGVkX19jY8hpFLUhPjWz1nLhnk09y6oroDgAavoGGntaKU9vCdeePUZJVX2aHVlxbwitNasLun0cZmaTUrrKPcxbhXYHjRtp3lxmDYMmzltPxLD1bXFNK1/JNNjxze8vmev/UQx3pnu4QDQ0LgpYBPMBq3RwhwrCjmHWWxhJSURwbZ0EaUeG1WLxZauBRUAKLqvQjIzLXgbgumyLu7kJPAPc0aL/DOzyCtx8QHKS4yWnJyWBxC9rJvjJ5VfJh9yiY6+LBAGvnF0s/RybLB+gRX6Ri3IFyLzvRwiTuCw8z6jg2xH7BdYkK5kU4ayH4q/i2C74VyvJOL+72ZV/w1EGGHdT1rTBCDbArQFffALf6Hsc+IO9ShqPXbWOV3PuUEQnuaNU5024NlTRAECtd0Vug8fLC7yER+PIrKcudRJoX3U+7dlemdxZGdkVU3Dgnl6leNP1nABdXHqTebOiMg6+2g0lr9n78voZme2cje87MaloG7xPd1DtNQcnZAY1rp6yJfheel31EAgW3bAwRiqBlUsojCmAdiynzM82ExZqj3EoYU8+r3FmKZWZhiwUulE8Z3Dee1iwArITFO2iGTPs3dKnVrcKMuMLxlobidXGhlX32UkqECsewvqQqvE6C75Bvwx//JYambtksUbqtY4S6v9QdwBMdOKXWpycbxpPFOkqRLmoyVVs7645eFP7dHaNZs0CUcLNkHekjn/3k5TNpV6QA87SmyR+RpK1YY+Bjhl+E00oSeqpfPn2ziPC4M4b+wi1W/VRrhiYDwwDnLwKqNCk6FxznmftB3cXBFf+pyI1hWeBg+ApVs1vuTNL+uA2k3CsT7MjqnZI3b0JdmKVmwEweaMeqP+scEMS619N0OAUVeUl0p6MHgK6+4Ymh6o84MXM5RCJLoZ3IjTxuL6GAp0Nyu4rYqGksqcLshad7oI/UWecUIhFgK6FeAOKFsDrM+KF2TCpcKzrUFI
 hiEk45AS
 Roo04TaQuLK9DY7kXVgHYoveEsIECsFuwfpBc8rgIvbyLwMt/4ssUOJpJVpeIeacb7Am+f10RT6qTno0/8mmYu6Yj9pNRcdLJT7me2cxCrp1MZ1nauMUH9dAUh5mfcFg66CQixohOaKnkvemyyAwbbnnxdtuAL0RVs381vya5vObJwxbBg3skGqraPl958xRQRO6/e/pcGae0k0K282bwTzTb5GFB9Uvq7P56Dk52kxSKOLv+K5MN0S3YMySfECPYO76pRkc9Vdn25HNFKM2reVFg+2xvKE4Nya5EiKBv0WqOhr891W8zYo7X63p2fiZrROTiHuxn5zEU0Vo0u72QWF/G1l8DPjdtrtz4Zhg0MWEoWREO4Q4z75sCS2CUPFOQRn5Lphx5OMrWiwBGIAG90GZGuhgCWMOlPe8n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 21:02, Tal Zussman wrote:
> Without UFFD_FEATURE_EVENT_REMAP, the new VMA of an mremap() is not
> registered with userfaultfd, so the uffd state of its entries is cleared
> while they are moved. If the move fails halfway, the entries are moved
> back into the old VMA, which is still registered, without their uffd
> state. Writes and accesses to them are then no longer reported.
> 
> To fix it, leave the entries alone during the move and clear the uffd
> state of the new VMA in mremap_userfaultfd_prep(), right before dropping
> the context, like unregistering does. This walks the page tables of the
> new VMA a second time.
> 
> This is done with userfaultfd_clear_ptes(), which also makes the PTEs
> writable again where that is safe. That removes a spurious write fault
> per protected page on private anonymous memory, but adds spurious write
> faults on shmem and hugetlb, as change_protection() makes writable pages
> that were never protected read-only. UFFDIO_UNREGISTER and
> UFFDIO_WRITEPROTECT already behave this way. This will be fixed in
> change_protection() separately.
> 
> The entries no longer need per-entry handling during the move, so drop
> uffd_supports_page_table_move() and clear_uffd_wp_pmd(). Whole page
> tables of these VMAs can be moved again.
> 
> Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

VMAs should be write-locked, so nobody should stumble over it and walk page tables.

Rmap walkers can stumble over entries, because only the page table locks protect
us here. With your change, that's now actually consistent while doing the move.

I assume there is now a short period in time where the PTE bits don't match the
VMA flags for an RMAP point of view, essentially in-between clearing uffd state
from the VMA and clearing uffd-wp bits.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

