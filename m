Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05294606A88E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SrCWeG9C
Received: by kanga.kvack.org (Postfix)
	id E283A6B05C8; Mon, 16 Nov 2026 15:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00096B05C9; Mon, 16 Nov 2026 15:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16D16B05CA; Mon, 16 Nov 2026 15:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A083E6B05C8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:10:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 306FC1601F9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:10:18 +0000 (UTC)
X-FDA: 85442074116.09.A6DD919
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 432811C0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:10:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SrCWeG9C;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859816;
	b=kQ0nZe5qwQ5AFnwNrgXrlw//pHk5nPDy1iPkIPVoFxo/ULQ/qnsZqpuqry9YnW1FvYfRMA
	thauMdoAbCASIbUW76YB4Dpqygra5050G2YhYGOBiMXzZ4Jd4hzqdwjNLGeqFJNmHhHBXL
	kh0G6lgBZ5j63wOmG4nScGmW9cjktow=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SrCWeG9C;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DnZY0R4CFWaA841+h8c4OqRg9398Cp2ZyZRKUgM0LV4=;
	b=HdghIlZk3i3YGJ3kI6KyVaBbkJmtgRuOvUTKD8PXl0mP4yP9YF/L24hpDd4t4aBY4lVU3c
	8lvUmDsXsKat1ModpIikyXC5g27sJ61VrexRIm+qMlCUrgb3j1329pxlbqJvDN4vD8Vq9F
	7aHy0tAV1D/BHVPvamnEcvJ/J/MbWYE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77C4245731;
	Mon, 16 Nov 2026 20:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA1F1F000C4;
	Mon, 16 Nov 2026 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794859815;
	bh=DnZY0R4CFWaA841+h8c4OqRg9398Cp2ZyZRKUgM0LV4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SrCWeG9CA1eAKSC/Tiu2df8H1SoSfnefW1/ZFb3AIH90QnNtE02+DN93168cqg+wz
	 C1QOjXXky/ZPZztUmEeCRRBdbXE6me3o8RF292CDppPRFPtAfXtQBjp9GOmFEiNGWN
	 VdNCL5T8GONGf19sCNQOI5a4GS19yRby73zsAXImG8fkrdFw+i03LRCUwGHRwi1mI1
	 KO8oDtnTnnG3O68W9KCN75GOvxuF7P4lgZGHF02at51ByAgZdayqdP0aelKtJuVThH
	 VXVvincUfF+kCDqY5AGJE7YL2BBGBcfV0Tr6/DsviVC+J3l0oSnx4LiopwTTfnyqMi
	 TPQhuEAe0adDQ==
Message-ID: <b58451d6-e90d-4aa3-afb4-13666953dd1b@kernel.org>
Date: Mon, 16 Nov 2026 21:10:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/memory: do not report OOM if insert_pfn() races a
 huge fault
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
 stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-2-537605643f6f@kernel.org>
 <998b00e3-bde9-450c-b50b-069e65d00c49@kernel.org> <avs6WWOurjIN-trm@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avs6WWOurjIN-trm@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 432811C0008
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 3rhf3jiqe3ze5ep9hzjb79hqnke6py7r
X-Rspam-User: 
X-HE-Tag: 1794859816-331253
X-HE-Meta: U2FsdGVkX18Ip6QIlCCAv3PcCxH9IfIb2uAh4d7hwW7uuaqItwNGP2F3PfYTgs7r0kuIyKMDuo9V4jKAwD3U2w4HUedaJz4Td4h39i1ZGhrJphLU7zdmTI4MqDa4RtDslTfok9IT3v6YWrzPXw9Dzn2Vpk5tSyqLKMR4AVvTwRflXkNH0zF+OwkbI0dsZCH3Zk9cSfTEGF+eg1A/wp3ybJB4y/aaRu5xP4jmYyWtjq3aPNON8bEzL/61UxKRBhRAG9F8NFqpOSJObTYAyRqyiTecouxkC3aOY4941ljjTzGuY936jUD5m58Du3fGjqua9f9WM6Qnwbif1J59S2LMZNx1rPNqk/BVFpg1a3yFIhM5ZQfLXml26Lqz8nsBPk/gNKOKBO2kaTmjICn102V5OTSkwfmhkxRTg0Gvb3QZnP7Ty8zfKzp4wLwcPZgROJoxSNRnw1T85QGGjxFMYFsmaMyNdIcbBGFZ/Z8hDfPkHcXeJHmjSrgi545w/K17jj+2F8ALfbsZamDODruq+LYukeCAZTZ+pCWnEWCZkoJGVIW+wlaoFUfigEDaHxmPPhNYcGkCM1TPgXz67LMm/UhibcFV+IBXqs7KF7k+v/D2YP+970Kg7sO9GSl1XPKLrEr/rB1UFK+0N+3H++Dp+WG7VRixUSMGYGzFxXfP1gN4va5bIW5G5/yTA8WtLhNo53J2XveWH9+CgSSTGrO4tzo0fBzxPOUIBKdvr23X0Xbj7vcP+RKVuqd+ugpXu0BY4+Ehvb6HON70p21q6FsQy8Y2jP51Qciv+UAoS/KqbihbttMBAa+/LNMIZB1TMevVzIcMgvgPKjiI04I7xUfgIKHpGNectyciwiZ2V6+hSx4NOhZRQDP3VvkrGm0EomzxLU3yB+tsfoG6z12fYPC+7avI7GH8olSp06PNjSlzw3X7ZpHCUD0uKf6jLxafT06nnAJ7Q8C+gJ11+zAN2wKK4hy
 YxIV1Pqg
 O1jmxgu/de6mYyyyguDkxrS4CGiwNo3sKxPy7Pz0+NcmK4ewTRZLwvHf4/iKXAwI+B18C5TcthEoKBr+/koO0Iz9k0Rq0kocfYr2qoaruqkX59wlVZTfkLclmtdRtz4j3g/PvAUVzoAoemKS+f9FNXBPh4+Oyx1bIoPtts5xjYudDgQbVSNhvHUncKAaImJRUNfVzTHsdS21BPHgptgJM6nWUlg3QwkKpWQr4Trm9ylcCx/K6GttQ6RrCBlbvgW8cndSqWieW1pHlna4vDdyA3UBgeARRtuIz9ElMX0o+5xNCKu+e8jzDfTB9Hm7eRU+1nlVuAMFBr/86iWtng+XIlGWquTZ3TPJzyTE3T8Dlro/nDG2/G4KUZAjf9Akjq6zXoPcR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 18:21, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 16, 2026 at 04:59:35PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/15/26 21:58, Lorenzo Stoakes (ARM) wrote:
>>> From: Eliav Farber <farbere@amazon.com>
>>>
>>> A driver that implements both ->fault and ->huge_fault must anticipate
>>> concurrent use of both.
>>>
>>> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
>>> concurrent with faulting, as that only holds the mmap write lock and thus
>>> does not exclude faulting threads stabilised by VMA lock.
>>>
>>> This is not currently safely handled by insert_pfn(), however, which
>>> obtains its PTE entry via get_locked_pte(), and treats a NULL return value
>>> as an allocation failure, returning VM_FAULT_OOM.
>>>
>>> The issue is that get_locked_pte() also returns NULL if the PMD entry is
>>> not a page table which can happen if a concurrent huge fault installs a
>>> huge PMD entry between __handle_mm_fault() observing the PMD entry to be
>>> empty and insert_pfn() being invoked.
>>>
>>> This can result in VM_FAULT_OOM being reported incorrectly.
>>>
>>> Address this by proactively checking whether a page table allocation
>>> actually failed, and returning VM_FAULT_NOPAGE if the NULL indicates that
>>> we were raced instead.
>>>
>>> The same assumption is made in insert_page(), however only DAX implements
>>> ->huge_fault and can reach it, and it serialises faults of different orders
>>> with its own mapping entry lock, so it does not require a change.
>>>
>>> Target the commit introducing the first driver able to do this.
>>>
>>> Link: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon.com/
>>> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>>> Signed-off-by: Eliav Farber <farbere@amazon.com>
>>> [ ljs: rewrote commit message, trimmed comment ]
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>>  mm/memory.c | 11 +++++++++--
>>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index e03110906aa8..cff39eccfd42 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -2866,10 +2866,17 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>>>  	struct mm_struct *mm = vma->vm_mm;
>>>  	pte_t *pte, entry;
>>>  	spinlock_t *ptl;
>>> +	pmd_t *pmd;
>>>
>>> -	pte = get_locked_pte(mm, addr, &ptl);
>>> -	if (!pte)
>>> +	pmd = walk_to_pmd(mm, addr);
>>> +	if (!pmd)
>>>  		return VM_FAULT_OOM;
>>> +	if (pte_alloc(mm, pmd))
>>> +		return VM_FAULT_OOM;
>>> +	/* We may have raced a huge fault, if so let the fault be retried. */
>>> +	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
>>> +	if (!pte)
>>> +		return VM_FAULT_NOPAGE;
>>
>> Same question, what if we would stumble over a PUD entry, how would we handle
>> that today? I'd assume we'd also want to return VM_FAULT_NOPAGE instead of
>> VM_FAULT_OOM.
> 
> It can't for similar reasons.
> 
> Actually changing this would require changing walk_to_pmd() a fair bit so it can
> distinguish a failure to allocate from that, and I'm not sure it's worth doing
> that at this point, better as follow-up?

There are only two users in mm/memory.c right?

I'd just make the whole thing less shaky right away, but whatever you prefer!

-- 
Cheers,

David

