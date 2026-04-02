Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527E6CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796BA6B0088; Thu,  2 Apr 2026 03:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747126B0089; Thu,  2 Apr 2026 03:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635F26B008A; Thu,  2 Apr 2026 03:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8EA6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:49:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F32FFE0748
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:49:48 +0000 (UTC)
X-FDA: 84612841656.17.1112955
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37E7C4000C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:49:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsNLcciS;
	spf=pass (imf27.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775116187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hr2k/7x2iF+eHeC+QDLgLpQnsMX7glQGr6i0KUtTTkQ=;
	b=R6sSn91548oBfN9UcT3vVukOHaAY/MqOvFMSmr0AfVRPxCsHXpKATbTZ2DhvlulacUmjRU
	y/4Xg6OL2JIBqSheJb2HJerwak6MFmwncbdevMBTDpQj89HHVcqVUL3Q/VXQQZFpS47doJ
	a5p2CzRxXPx4Rstt2dB+5vPgqEwOPx4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsNLcciS;
	spf=pass (imf27.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775116187; a=rsa-sha256;
	cv=none;
	b=o0tub29QH9ivrD26qpJ9PBhD2DoOIvGlbPekd5wS7pfcLekaB9NzchCFuUGl2eEpgckfQk
	vPEL1s6vyliYD/R+wL5u27WYJl+pJjIlNSwfdnHazYKVBuLA+qFuqYtbPyqufqjGF0musZ
	wwpKBH/bQedn+YLlpvUJMWUCz8+AMlg=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2c7e5f38b37so882578eec.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 00:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775116186; x=1775720986; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hr2k/7x2iF+eHeC+QDLgLpQnsMX7glQGr6i0KUtTTkQ=;
        b=XsNLcciSRjCLgQ1z07Tm0S6l0W0d0m5sQqYuZ4shnQxopVQOeTuxE+Hyhi84FGKPSh
         UY7bLBkUzwiCsGjljr7diE4u2tlQdWp59/C39blGESvw0w1KOGTeNZa5LuuIsraR+AuW
         nRiQp0NxhwOsfr2lBq3esupimR9j1WLWH2hBlWyMM/iia2oq/2GwmKccXvn6xNpkWqws
         6nb3B6sBk9WbwVYZKpWQxuHoel4pn8F1q3ef63jsTJdd1DndEgtAK6M4tlDwWHPnLXF0
         zL7LMm65tYROHyqaODvIPMutSY16o+ntRCrUKjG+ErFXwdsyetQshacsqX0vDf7iUSO/
         vXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775116186; x=1775720986;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hr2k/7x2iF+eHeC+QDLgLpQnsMX7glQGr6i0KUtTTkQ=;
        b=ioUicIeXfTA0CoTf+Q2qL18gcqaJlap+wabvIv8hFCRAkR/6rrF2t7JaDPPi+6xqaU
         iFgpV+ATqMAPi9VNCermMSun+5HtxplyYop3/n/QD2sSkTEAm76v+ndmWYE5WXns8X7S
         T5eUtEjqcZrWRKNdSMzmoSpA4VSu4psuPihlQc4Y/b61WQkoCXeO0+/MNJzC0HAi4U3t
         Wt7yMld3/SB3H3ZPGUIa9o6p19GSiai7DxYYrHvwY6aIvgomWi5vrj5fhg/n0r3mqSLd
         bN0hSgArmQucyMgllq6MFYH6fhS0BTLpWmownl3VGzJwnqGvaLS426kxxVso6kC+I8oh
         icRg==
X-Forwarded-Encrypted: i=1; AJvYcCV/xNDp/+ybxkQenxDikDB9cLKw2pDwxlDI5KPbyxl2ly1G+7XNEnzY7RU4DHFksgLFOErQKNMFJg==@kvack.org
X-Gm-Message-State: AOJu0YzG/Knmnxk5a9MvwanJkJCuCL8er5l1Do8AlXAh2na1WNielyOH
	6j4JCkzmtvcs+46SKxnHYGlHSXWgPJTMN6pNMteFs2V6akBczMbmUTTa
X-Gm-Gg: ATEYQzyj6s9FL2h1Yuzt+t/PVxT5xdEGCSccYeyXnNo9geLRa9OtY3bsumBIobmQ6w1
	Aza2qbRYKS6saQxxYhRf1wKlKqHw7JtPWJTQjhspWLthAv49NkVUn+Jw1bxSeCOgPHp6Ua1salU
	V3pw6gBHc4nvfO2QGqT870DDlgseGaA6YxftAZtwTYFy06bmVU6zvkMfz+DZbe4JfC8+v/HOrSl
	VwnEPVeE1WhRgorn/Cm75881g6bDkfQEftzoJ6RKuuMC4hwNkEeqcqMzIbcXozxwrvj3tRhq0xw
	2So9QarwNHP+FDuwJpJuhyANhhtMTonphhHaZ64+nITg+pY8HkNJ+S3atYiPnM8tobCU6vB+ESB
	PcICbjUFnQnnWdNzS8X45QgEL2Qyo0d1qCMrEzkLE5Co+DCVCVLqiAQxDSZporcMRmSZIpHqiXN
	hNIKX5+AAMCVzYjN0D6ZpyGrkw1SZf9+NepvWVuepKkBXu6ln7ap7OYTUgMPWctsgZA9sQYt57r
	jCShA==
X-Received: by 2002:a05:693c:2b15:b0:2c8:7172:3b97 with SMTP id 5a478bee46e88-2c931170d0dmr3594312eec.13.1775116185778;
        Thu, 02 Apr 2026 00:49:45 -0700 (PDT)
Received: from [127.0.0.1] ([154.17.3.126])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca7c9df90asm1650202eec.21.2026.04.02.00.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2026 00:49:44 -0700 (PDT)
Message-ID: <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com>
Date: Thu, 2 Apr 2026 15:49:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
 <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
Content-Language: en-US
From: Yin Tirui <yintirui@gmail.com>
In-Reply-To: <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 37E7C4000C
X-Stat-Signature: dwsw9y7s4e8yi3o8hbc4ui3uf8spbubf
X-Rspamd-Server: rspam06
X-HE-Tag: 1775116187-380034
X-HE-Meta: U2FsdGVkX18LjAo+DAz5sxVaB11l1Au8Ck8zJ3RGKd/D/JQbUdGdGb34T0HYxNLPnkPtVlFzwBM3T4MgFEyvQpAEtmdIK4NffVRBAVsceV1dWc2AJGv2q4t+EEj8U9vK++YxsRjLdHQ4luG89YQgzlFuuZGKrK7p1bjNtAkUcUH+hqq6w4kFJ7s+Mmh+Edjy79JLTh4WL0hpH8ukduSdf71Amf/FEP9MY3GFXKMzZEbO3iIkV2fuLDHVvSa6eCcgLqclWeiOtFrFzO1Q6dgYttIt71cGOQuiDHkn3r7MGtNRVjb/crUttK719O5i7GJ01BEyocIbHHkCKeou78+5n8WDG4/RYCN4YEWGz1T0+NCTOyNfJnONq7fvqB4tlTovuAbQiM1MbJJa+hLkGhtEbSpsUe8liyeVpqMkd/jbN+VJ8OZTlcMotBpxToxZNYO0msqY55zpDRIvQtqeGDDeg7RolnyW3Sfl0WGAPFUDL5QMGoO2yBEJyY9NV885gU59OZz3Kk8oAX02MBqMzRMUZoQXFWqPg+S2k+F/fqmncHqPV69hmKNYX7W7MJdLym0uqOQPoSMeuuxT9w7xUx6h2j/d9o7ONQ1hZ3AygJY92Xz/BB2jBcOlXBZbvc1FScKmOt/NusOvsUspOKh2ZdKZ9Z8ouVT34guaW52VX8qKcl4Esa22l3vRT97YLK6B7ohnI9OAvKD6Oyh3ljuV+81xcde8/H9JAdYZ8VjntxN40b0itSqtVRkmC+anJ/K9SHKafAb04CCf8qbs7Z/UB9hZXJpvlfsGgeBoe+FyJG7aZRpDf1/OWiJXA/PCLBqNAsgLHav7hTfXdz6ycU4PoxFAyHXqNvBO4Dl46OLIKg5mdPP8oOJU7j3H15gFOWlF1pk4MGPK2QCC+PBZ2AuGZDp95q0eTlZqr/HApL8kEGUAWCpDpPtbuuxOh4QFHudvgkVoVMb9H8VR9ued30PK105
 IlgoE384
 33IKZ5VMRNvT7nGQ0Xug420sefkk0CHwYtSM6LZxJE/SRU+pThYi4V6ewxzi5htN60rX616RYfB3bHONNOOHV/eY1YhEgEUsAWVUU56aWosQgWbOfNRHhnYxKTz6iQACW0V1VOe0eQxPRvdg3Rz5HSehaxJhT8VgY+o4sMkXsIgzLnqnlYqiTb9nAvieXKUS0cH1L51XuReh8UFBKubgWdzdFviCb+7w/1FC5AmDmhnM2DyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/2/26 14:46, Lorenzo Stoakes (Oracle) wrote:
> 
> I mean you would have needed to handle this case in any event, since this change
> is strictly an equivalent reworking of zap_huge_pmd().
> 
> But it seems that doing so has clarified the requirements somewhat here :)
> 
> I haven't had a look at that series yet (please cc this email if you weren't
> already, I do filter a lot of stuff due to how much mail I get daily)

Hi Lorenzo,

Thanks for the quick reply. I will definitely CC you on the v4 series.

> 
> So if this is a PMD leaf entry it will be present and PFN map, so I'd have
> thought simply adding:
> 
> 	/* Huge PFN map must deposit, as cannot refault. */
> 	if (vma_test(vma, VMA_PFNMAP_BIT))
> 		return true;
> 
> Would suffice?

Here is the dilemma:

Currently, VFIO uses vmf_insert_pfn_pmd() to create huge pfnmaps on page
faults. This sets VM_PFNMAP in vfio_pci_core_mmap(), but it does not
deposit a pgtable (unless arch_needs_pgtable_deposit() is true).

To resolve this,

Option A: Force VFIO (vmf_insert_pfn_pmd) to also deposit pgtables. This
unifies the VM_PFNMAP lifecycle. However, since VFIO can refault,
depositing pgtables here incurs unnecessary memory overhead.

Option B: Introduce a new VMA flag set during remap_pfn_range(), which
we can explicitly check in has_deposited_pgtable().

Option C: Check vma->vm_ops->fault (and huge_fault). We would only
deposit pgtables for mappings without fault handlers. However, this is
fragile because a driver might still register a .fault() handler that
simply returns VM_FAULT_SIGBUS.

Do you have a preference among these, or perhaps another idea?

> 
> By the way, I am wondering if the prot bits are correctly preserved on page
> table deposit, as this is key for pfn map (e.g. if the range is uncached, for
> instance). That's something to check and ensure is correct.
> 
> I _suspect_ they will be, as we have pretty well established mechanisms for that
> (propagate vma->vm_page_prot etc.) but definitely worth making sure.
> 

Yes, they are correctly preserved!

During a PMD split in __split_huge_pmd_locked(), we populate the
deposited pgtable like this:

    entry = pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd));
    set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);

The newly refactored pmd_pgprot() correctly extracts the exact
protection bits (including crucial cache modes like UC/WC for device
memory) from the huge PMD, strips the hardware-specific huge bit, and
returns a pure PTE-level pgprot_t.

>>
>> [1]
>> https://lore.kernel.org/linux-mm/20260228070906.1418911-5-yintirui@huawei.com/
>>
>> --
>> Yin Tirui
>>
> 
> Cheers, Lorenzo

-- 
Yin Tirui


