Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACEEB606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=egySUPph
Received: by kanga.kvack.org (Postfix)
	id C24746B05B9; Tue, 17 Nov 2026 04:57:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFBF46B05BA; Tue, 17 Nov 2026 04:57:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB9F6B05BB; Tue, 17 Nov 2026 04:57:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1C36B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:57:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16628A7E59
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:57:10 +0000 (UTC)
X-FDA: 85444157820.08.3EC3B87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47E1940006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:57:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=egySUPph;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fY+2HOSK8rfddtZoh+t1ZJeqxl8EMfCbjk7Wm0pBYA=;
	b=ygQMIfOSvH735K4owNFDSui4IAyl88CrwzXMkG/3NYUq+XWoqgx2XXYWbny8JKTbwiHtoE
	71b2Ulzix10wXhG9bnfdpkej9t2DS2gPmLADGinR6dweBx6KtsEIab4R80HOYwmZnoTl5k
	7KTfUI+NvwcB25hTpYr9FOLmrLNAAZU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909428;
	b=uKPn7PwUJDH3dSjU+FW9ufclEzu6qbZmPc6b8mbTYHoggs0lK/cYK+YFZggvFHDYVU1k0T
	ttHJx6kymU1mQdDVxkbR+cJ9BHMYJgGo89qnYnuDA2xeZfMvszYeGQhrndKpSEjyfcLyW9
	6ae3UIfv2X88j/O3r6RHGhqVSxdcdZw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=egySUPph;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A9E943A03;
	Tue, 17 Nov 2026 09:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9231F000C4;
	Tue, 17 Nov 2026 09:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909427;
	bh=2fY+2HOSK8rfddtZoh+t1ZJeqxl8EMfCbjk7Wm0pBYA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=egySUPphbrhnVdGPvwfDbJ0S9W2WlsyAyzyHcQEZ+HXIW8r+ekqkM6CL2VZpQH8UN
	 YSpMF40egtUW100ztPnYDttbETFhQ55M1qsALTyEuKO3NV4aXhBhoIQtSO6sggkllq
	 iPnA+RjkzdRg4U/mneZ/ts1UD6ZEu4JRi/MqH2sKIHLdVbd/zsByzjSoWuaEyiiUMA
	 pXJUiDFYIEQeqQCAyPvGOTtOVKZQt84hXjYD0/6uCo6UxA1wOMcEFXMfdS03gWwugj
	 C0GqvbLW3wOVuuPjvVreuZ2vQN9wEkoQf7Tz2jWTntU+pKTm0NXu5PfQL+4fxo0jLQ
	 KEFiqUkb/ZgvQ==
Message-ID: <767ba6ff-f153-4fc3-9b56-f2421c793bcf@kernel.org>
Date: Tue, 17 Nov 2026 10:56:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] fs/proc/task_mmu: write-protect device-private
 THPs in PAGEMAP_SCAN
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
 <20261116-uffd-state-fixes-v2-5-4397a0196479@columbia.edu>
 <38750bd8-6bb3-40f9-901c-44cef40a9de7@kernel.org>
 <cc8daec0-c3e5-45be-9af0-d58719a43953@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cc8daec0-c3e5-45be-9af0-d58719a43953@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 47E1940006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: wz5os5zj913e9toucsfkkc3596pjbkey
X-HE-Tag: 1794909428-268507
X-HE-Meta: U2FsdGVkX1/uT5As9zepPv9gjcpZPy2hVxzjGxNbf3PGi+6RvZ50Je8xXnsnnPX+pvEjOXkOWgY0nlYZcC7W5CYBg/j3+UDHXUUVyrsctXB5KVxoyI3jysvWdlhEORmw3uv3peIFr2HbcdhaAK79vRyAWflU/ylyNtz9s5VsO8iukQizEN1Px7KpiIDmqUaaOZsdcD3xjslNxHPfLSo9r4AabhEVTf+PooChlE/iktCVlSNO/PLgMwEZrfXtXszihWmedHwtye2MwTCpvUryQ3LSws8nUzJJF84IA4yXq06cu5Mj/VRN/a27Zsd8gqNuFg0cfq3gKbsjnAA4mLxxOY21Lx/9yNESvpc2y+ldTcpflpUuST5IH8lRBQs95EvlOQqnsYfpTEVVBzXybbJ6LZ2JgbBmuMwLl4urE9oFQRZvVHHjaA5KLNpJwba3BneNUk4xdwkPiOS60/n9qdCrB2g3ll4RPZF2xUdKDx8keopkfTlhWFZCDQ0dJhMKj2ndm+Tn9Fd6k7MsXxKYtArGAtMLWdpmVFGH3Idp9tFVmivDm7D1SRhxWHrMIx/PlaDpULaJy3VAudm1qenk5c1KCxsypRClqST3mLTmryWT4f1ULoJdYMalx2dHWFeGRsmlejYXjDUst8AbbyLIMS/Wc5/q7nvWKA7CgQcH5Z+JjmgMrukClMCnL2j9k7bAh+/d4IWgEPir2cEaCIuBf23gxqzwIGvh5PWhu7AKNnxEk/3Qj9TiueRQUZ9RovuhNoMAMMORCo7SSXrJnDiRjkci7ru3B3OJ+cTYh91QgPuuITCmmalzhcwQ5MhqhZeWsNXk7pS4wixtnROtZsPiaohg7iOOqtaPncsxDZrih/vEZWp0lyHTteyf2lljm+h7R054m7QfGF8/ntVITMyIolXD41GsbioEE2bAk7Owd44QEeFZNlybvLusSSVHQjg8cCTuQKIDJdPGkcoLtvwOuhd
 KjhsRZ00
 i8j7CenxpGJJavIAi/61n8O6w1ulu7ZI0dGuYvgWsd/nK/WysOoi27NJL4GUBuOIxii19G6EFCGvj7bZGfD4eJJ6oweshE1MF8WmFNcY+gh2WgE4Wn+w+1MfqPDRj3pHA8UjnxpC+hOPWA1GfVWFWB3iA85/Kd31QVdoh6TnGBST6psuI8j6aBOaUNVd9P1bnWhwmFWVMKSJHp3HzXaNU6WsN9JKk6wGzDqpXTBCSRiUBspeW5BOtzIwZDS/81TAXhyb0qk/BGAN4FzmB77EZSorgYJf+h44JgKKOpO4ygm1skCrMb9MqrIKjNV9jw7uoaeqEX0/hmDDBEYK03Du/v5z7XRtURHdR93XyRTbZVPVL9KYgI0jPYLJHBNWAAoyNK1r7zS7S4b6hTQPCsqwWqqvfdr8ls1kn4AJDiX9YcQGIOhNFX+6UUQfpjpunSEw0erd/wsbAkRcqlhgIvyhX/ZtC0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 23:48, Tal Zussman wrote:
> On 11/16/26 3:26 PM, David Hildenbrand (Arm) wrote:
>> On 11/16/26 21:02, Tal Zussman wrote:
>>> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
>>> make_uffd_wp_pmd(), which handles a present THP and a migration entry
>>> but does nothing for a device-private THP. The PMD never gets the uffd
>>> bit.
>>>
>>> pagemap_thp_category() reports a non-present PMD without the uffd bit as
>>> written. A user tracking writes with async uffd-wp therefore sees every
>>> page of a device-private THP as written on every scan, whether it was
>>> written to or not. This requires a driver that migrates THPs to device
>>> memory.
>>>
>>> A device-private PMD must be write-protected like any other huge PMD. To
>>> fix it, pass any valid PMD softleaf entry to set_uffd_wp_softleaf_pmd(),
>>> not only a migration entry. It downgrades a writable entry and sets the
>>> uffd bit. When the THP migrates back, set_pmd_migration_entry() carries
>>> the uffd bit over to the migration entry, so the write protection is
>>> kept.
>>>
>>> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
>>> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>>> ---
>>>  fs/proc/task_mmu.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>>> index ee7f509d376e..013eeea7d1a3 100644
>>> --- a/fs/proc/task_mmu.c
>>> +++ b/fs/proc/task_mmu.c
>>> @@ -2520,7 +2520,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
>>>  		old = pmdp_invalidate_ad(vma, addr, pmdp);
>>>  		pmd = pmd_mkuffd(old);
>>>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>>> -	} else if (pmd_is_migration_entry(pmd)) {
>>> +	} else if (pmd_is_valid_softleaf(pmd)) {
>>>  		pmd = set_uffd_wp_softleaf_pmd(pmd);
>>>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>>>  	}
>>>
>>
>> This really should be squashed int #3 I think. Or what's the reason for keeping
>> this separate?
>>
> 
> I viewed them as separate bugs with different Fixes: targets, one from v6.7 and
> one from v6.19, so it seemed reasonable to keep them separate. But patch 3 handles
> device private entries already anyways, so I can squash this in.

Oh, indeed, different fixes tags.

Okay then!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

