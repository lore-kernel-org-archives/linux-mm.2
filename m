Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7DDCD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 07:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7356B0005; Fri,  5 Jun 2026 03:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE6D6B0088; Fri,  5 Jun 2026 03:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3956B008A; Fri,  5 Jun 2026 03:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE826B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:18:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB69C40A88
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:18:47 +0000 (UTC)
X-FDA: 84845006694.19.1B7CEB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D8FBC120005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:18:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UFKSoHsq;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780643926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+V341z4AFJZZMWBuVoX5xq/8STGfWgb2w/e64lYkj8=;
	b=dTnRIrsYJLvGJvwbyooiIdwum3av099/8pnP4OZ7icxPdUhs/nlOSgPwr+PF+HYYOdot9s
	uQ4KZJpkXMBcoUalxgAEDDvqQAj1oxjvMd7wXH8MfcCEn+UKhVO95k0fovFz+FxxBBZGkd
	RpBWG9/GH6zqQb2dkoeTt0SF7nBe3xI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UFKSoHsq;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780643926;
	b=D7p4TZZKIUCKiFFDNocMJG/6DomJk43DBU40ntPJs3bmre51NzFNR4wOHraPxHPGlTqSbY
	SuJI932r+bZB4vlszfWjA9AViGOflIzPcoMpcN9/15BXaPscCe0foh8eJcCC+5cw+z84ZL
	3QKrOFQS7gC7l2GZVZ4K+jTf78OmWvk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD930406B2;
	Fri,  5 Jun 2026 07:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689791F00893;
	Fri,  5 Jun 2026 07:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780643924;
	bh=3+V341z4AFJZZMWBuVoX5xq/8STGfWgb2w/e64lYkj8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UFKSoHsqpiw5gvp4gxvIEeJV+ca7a8BTyA6Fv3MGXG6GJ0w6FjqLoAmGNkrI40bzi
	 LPiHrU5+KmRBiz308PEbAzP4ENiIfnH+V734xr/2xp4sCaeu+zcMgecxFNyfqSjb+v
	 WgHMFtYwkcSrA1pSkQ4v7Vz+wEkoqzQ2+YcHMqXkD4dWkMnKIGsUE6Gms3U33ndlPx
	 YEzC14yJ1npKFNlXHQvj4x2sIQCn12AgtAexYzvK7XvBVdBfb0Yr4JhkqRHnpuQseK
	 3jQOBtfcUkG3FG8kYz13aDf522Wg8k+yRie67+W03EZFQpEHhxZxIU0G0rzOPDryev
	 ng00bDx57SfaA==
Message-ID: <0ef96c28-9e6c-4d04-90ae-ac43c81d465d@kernel.org>
Date: Fri, 5 Jun 2026 09:18:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Nico Pache <npache@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
 <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
 <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
 <06d9b665-945f-4967-9ed9-b06514478996@kernel.org>
 <CAA1CXcAeEGOsqp-ywAQ7GMYQzXEeco-rUxUkk2hEF69HybC4=w@mail.gmail.com>
 <CAA1CXcBSPVG4CJFCBDvbuodcJ_7eXoDQTpK0ZN0HEhkDPi-DEw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcBSPVG4CJFCBDvbuodcJ_7eXoDQTpK0ZN0HEhkDPi-DEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D8FBC120005
X-Stat-Signature: 9gbpq6bh977n9kf1y48rnefozbw4371w
X-Rspam-User: 
X-HE-Tag: 1780643925-256920
X-HE-Meta: U2FsdGVkX1+L73K4zudj3DOL/qVq6Cx7we7XbUpOm1dGwtjdMXhJbh1KCb5RKT+vKPRU7lNUvydczV/s1tT+MRTWl9bWkjPt9+q9CmYMvKm7JlZczxmeCxoXkyckAJHVbrM1iIU3EVfBQfX0ypJBNKC7Gyzqpv1t6JLrCFNOf+Pa7U6B9JUikwiSLBRc9hkrBUhC7NFTOw7DuOK7TV4OBYgGNRXiRlTZ87cQAVZOWnPeiuIFvAMDH1ZaGcuaWFSUW+ktq0Vcp4gYkLz+hGDkcQR44FW2EYEjP1QbPm2U1HEgW9bou8EmVPIVgsbZj0p399kBzdw7eyyQa/8iOEpghnscTEa+UV3AIDPpA9ZYJDqlGUTwFUXOkXKgK8UISeh/6AlkRwOVST2dMWxphQLs7hTV4eLlUdcmkPtUWFZAPbRwb38wMrB/QoxB/683KSYQbcANSeJ+Rx5Zfv6PnQU7QII+FuL13STjyx7PnrMzpUtjEcgl01Jj7pocjPnKTmknQNBIrkUsVMgwYOXnQ7Ih30Nxd/PRXVCu1EPBTj7Z4ojEy0kdtQP4cZhycLuPVPDLc/c7hlidosgWoa0cX7ElpAM1HNEu+Oibepcjg1HKV/KbYCGAf9zjMmr4q6N8AGfQ3VTdJcO++0U3wv8XR3o5XxVgnnFoDzxbwvBPXe4Abz0AmVyNv9QsJdAeD5wtZQ4GLHDNuIciknNXy57lwndFZPnV+FWgzMCRo9dpkeXE9x7qwTW8O/k7uEfg1KZ9+GL92OKgPEiBiLeE48riVsSILeh+53XdSm3iykmc1xwDz3ziQY6ypqNbDSP+v8KBgGWsNBwnev13+DzEDZgghuxhWkIVhw6oEFlpS/Cu2nkJvu3orBKq3EE7vmStMot3SPZ3XqITzFm/YuJqcJhPO+JH6ErO3sGxuj4Wrd+5/Yny363zI349dl67eMb97JohJRSBYjwzX3jHXHRlBZTd5ae
 iS5zJORh
 8WUMpOp11RaYuFQdlIEpBUQuHgE3vmlKjWRvsCUggtAQLqUyELOmVtRQfGLXJ9CwaJSXIIDI3zvmix5VrNbsUW2V80x5yYOf95mWHygz/MbQ3Fq0tNtuS/7b6p5mRQa1610timyDzwF22LUazsKMRpcZ1gQokrNmdzmqZ5Shcwi6R7Yqk0G62qD/TzWV9c+7k3DIi7Mzgfnq/0QFwmkmB9HoCllh71Ol7c7TWx4B2aXsgPx4CzzmsJERWUU5XJsg41LYIIMY09XKRLdHc4iHDMFG4YpVn/Rv7qXcjuDaojgqTpJjbHWYWYLH+s5vMI5nI9v5utKoGlMwg2EwuOYhKTpH2KH5YiEUSsuUBem2lXWvWE4zF03TYoVlRgYePvetY20tToDgBFR1rgqNXSw9J06+TjgOmWNWZwqxQXZz8xdM/L+WPYPt4Z2ny56UEpMIq0uengs9AcbCDGn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 19:04, Nico Pache wrote:
> On Mon, Jun 1, 2026 at 9:00 AM Nico Pache <npache@redhat.com> wrote:
>>
>> On Mon, Jun 1, 2026 at 5:14 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>>>
>>> Yeah. BTW, I think we'd need a spin_lock_nested(), so @Nico, treat my code as a
>>> draft.
>>
>> Okay, I read the above and did some investigating.
>>
>> I will try to implement and verify the changes you suggested :)
> 
> I've implemented something slightly different actually and I *think* its better!
> 
> } else {
>        /* this is map_anon_folio_pte_nopf with no mmu update */
>         __map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
>                       /*uffd_wp=*/ false);
>        smp_wmb();
>         pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>         /*
>          * Some architectures (e.g. MIPS) walk the live page table in
>          * their implementation. update_mmu_cache_range() must be called
>          * with a valid page table hierarchy and the PTE lock held.
>          * Acquire it nested inside pmd_ptl when they are distinct locks.
>          */
>         if (pte_ptl != pmd_ptl)
>             spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
>         update_mmu_cache_range(NULL, vma, start_addr, pte, nr_pages);
>         if (pte_ptl != pmd_ptl)
>             spin_unlock(pte_ptl);
>     }
> spin_unlock(pmd_ptl);
> 
> The logic here is that when the PMD becomes visible, PTEs are already
> populated (no possibility of spurious faults on local CPU)
> 
> the SMP_WMB makes sure of the above
> 
> And the pmd is installed with the pte and pmd lock both held through
> the mmu_cache update.
> 
> This follows the conventions used in pmd_install() and clears the
> potential for local CPU faults hitting cleared PTE entries.

After the pmdp_collapse_flush() we'd be getting CPU faults due to the cleared
PMD already? So the case here is rather different.

-- 
Cheers,

David

