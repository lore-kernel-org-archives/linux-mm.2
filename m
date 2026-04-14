Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A66F531FB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4846B0088; Tue, 14 Apr 2026 03:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54FA6B008A; Tue, 14 Apr 2026 03:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944C06B0092; Tue, 14 Apr 2026 03:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F12E6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:36:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BFE38BA44
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:36:53 +0000 (UTC)
X-FDA: 84656354706.10.5E21C78
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1725818000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:36:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YJPAI4f5;
	spf=pass (imf06.hostedemail.com: domain of yintirui@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776152211; a=rsa-sha256;
	cv=none;
	b=oqVoKnE2cPBHLf9P/yIodgQbwpC0Bz4/asVg4Q26xgp4nKrAqCJ4MZ5Af3DG5JaHJ95CGX
	my/Ba+LD7Ht1n/dwgzzGUb/vHdPOYubiWdJXa2NZACSqza+8Uw1hZQqFeIcv7AzyjmRIXS
	K3pCwyCMckhzt1DaQPzyJQoy+38fYns=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776152211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0ogmPgdwUipHOmKcnr8RlOytrha5m2as46j8FW3cr8=;
	b=riaozQ/V7jeAoWGdXPBPIxHyH2WBTsTX0jxb7YX7RG8oCtee/sFUmrA4VGi2BvoTZW3hcv
	xnvo7phs7UnUF51R3YrVggC1zPojHsHAbHn1+IMH22QrCsbakKyPCoWmgYjBBEPc1GfssU
	fBZBuo3Pgp2UxigmY6hDobRmO+Y5GCI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YJPAI4f5;
	spf=pass (imf06.hostedemail.com: domain of yintirui@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c76eea1672aso1806796a12.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776152210; x=1776757010; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/0ogmPgdwUipHOmKcnr8RlOytrha5m2as46j8FW3cr8=;
        b=YJPAI4f5ReTh4ujY0/lu3smkluIxDaMBTLS+fMxWBh0EQ4uUc0wJALHONyl5NK6AnA
         R4Q5LTS6xMI1sdGvqQC1Cib5KQR3e4n9DSOpvKB47fWJAtsDmhjzZudVeB6fvIszUEye
         GRbkxWycmxME8Es2Xf9gj4oC0+jYGD6Qp5jVOcwMrxrNRk3Lpso/e9yRrS7xlJfA0HBO
         b5pJQGVhi7QtfK4tAierUK2E2eeNwxiwd8sn4vVJ5qH6Ldq8NikBryMgEiJYWGMzSnOW
         +hc70XJa0GtGnOglX9AZFfo09woGmExTfOxvRMTyL23hGDCoju3lNV+2U9HEKoH6xKL5
         TTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776152210; x=1776757010;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/0ogmPgdwUipHOmKcnr8RlOytrha5m2as46j8FW3cr8=;
        b=sJo14jtC8qT1mOzXtXul1LSYKMoNI+JXLDdznWK37PuR7fu2xb+8G6UVCFz6TqRBXS
         oez3UifIakoTYcBcRxQf//fBUufM9l+J2TaCJ/qsEzL6sb91V4ilbGOqgxsoJ8CgX1nT
         ZJ5Hw/RBGqWDpEd3AXX0bOpGz2oJVHv953aigQnHFzvXe88oPaVqnXPFhkDVfl+B/Yup
         lmleZ5GjoZmAAG2jeS69L3GAxHvrqyAq6oxlvo6nGZ2ThxZZV6SkQJ6sP6mc9LyWh+Eo
         FA1xJVezB7tYeLCTwR3+UGexWesEObZc9tHdptgb5rEQmubmkOHsj21GzI+IK7iN02A4
         7U0Q==
X-Forwarded-Encrypted: i=1; AFNElJ+GueABKmgOcng2pURNEMPT1fK8ddvpA3j1hO+1G+4aMvUozkhfR3a4d+NEEEP+h/5C4WUdq2i2Kw==@kvack.org
X-Gm-Message-State: AOJu0YzLYtygE2mCfvM1RPpBFAOcS2ccZfMyVKAWZ5CowHdlhamgtDvO
	oxLI3VTubYCb8fetkP+mFBIabkAH2ha0xf1QsJPrhvfxPXo/JVS08cw2
X-Gm-Gg: AeBDieti+mo4QNCW866MWWEazBPF+0HtujqBsalrzEIvmwGJnZWY+rDXwBYzGSd66Dx
	Gs71QN0TOYR4eyqw7uHJaiz4OqULbuWOo4OnOoZs3hanuQ7DkIN62fkjjcaj3x154W+qnyQKX8+
	Kv2TX2/EaqpP7S/fBrD3P+eCmfPzVmAv1095+oFe0/TNZ0A1FKERmGh2PDf2cmNNUtN2DFECOTA
	w1LPMJOLIRxfI+QeEb+8UCh7UN0Pk6S3uknoLlVeCPqQ5H3PFvq+YKNYBlI/3SKuAw0hZB2gon3
	yYL1cknqFf+bgdIkhTOMjnO+oi5dj5bQSkpXWhaHcgZ5zgXbL+4a6Eh8+eMPmk+o51JkRJXENxF
	eAQHHoD8aZoadP3MwrSYdB6OUEOx8o/1PQO3p+THicSaM9XLJb8cghO6vkRdXIA6MDMF3K4qNvV
	A55QDvbrzZsxa+ohimvct+2aJ62jwhipFsqC8nZsT46H1ivqFxhE+JYqEKzzRswEUPSpp2K/Agr
	qK6k5rkc7ys3rn0MmWhsWjNbyqiaYKNvNlG1O5ruefiV/GxkcBf7Q==
X-Received: by 2002:a17:903:2785:b0:2b2:45b7:306e with SMTP id d9443c01a7336-2b2d593683cmr115063175ad.3.1776152209649;
        Tue, 14 Apr 2026 00:36:49 -0700 (PDT)
Received: from [127.0.0.1] (211-76-176-101.dynamic-ip.pni.tw. [211.76.176.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4f3b299sm169494335ad.73.2026.04.14.00.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 00:36:49 -0700 (PDT)
Message-ID: <2f29f66b-46db-4925-b922-4add61b633bf@gmail.com>
Date: Tue, 14 Apr 2026 15:36:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
 <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com> <adTb6_xqQoQqK74Q@lucifer>
Content-Language: en-US
From: Yin Tirui <yintirui@gmail.com>
In-Reply-To: <adTb6_xqQoQqK74Q@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1725818000B
X-Stat-Signature: j167g3mq6s4y4djty56nhzc6y8ppup85
X-HE-Tag: 1776152210-13536
X-HE-Meta: U2FsdGVkX1+FLeJBtibIkjRjOzZz+nznijiBv/RrWfMHavt/iMAjBHT08XyWbQxC1Llz0Vtc85u0xYxALFRnX2Sbut4ZZ4GVIbWu7L1psPbQr3bMUkhkzZiEUimAC+80bBuGlVdOL8I57EvUK/905/cGc/4CsRNxka9YlKzvBCIbmHt2LUV0CVRdgbSmvtfwhMIEBmmbKVveB/fDga6pu0KDlxMBUuiRo1VFSX0fnwATXvjZx60f/YBce8Q+KpJ5QHiehu+g0YdMAuKipA/PE8Ju3Ha2R5fa90IsSMjrIaclXtvlcthDydKUCIhrNleWmlUSGiQfEt3ZyNDLUqF2+xUPjFdSQP7caL64jzSE81I+q5P6g+cQ3ewIanEk+a5hksYRZuPwhxPW9FJZrc0okX4khmYTdehM3suzFE18vkGOixPzcrersALKhvUhai9jEzzj8KHNiyua539eRjyVW2FJTSsab147TX8CbrZ12nlvMBDlI3YJ6COfqPILPsgFl+2EyFfMgqZsQ0Z/EZTvSCqLuj7Lr/1jkWtJkIuhdtKuJzHij95GafA9uYd7X+ERO5vdXCPi2IJ41iFWAVNT3BQGsTWjutVIkLbzVnsYfY9YcZ8XxDEnjkQhJAmzHUimX2DAjMJHTdsH4YoNgl1MenlR0AwimYp5B24b0LT3CEanHaTOI1LReZBthcLyR2Sv9MUczL25nZ1NU3kuxVaMTAw8lPFtO9iLanMpcAP/3do8Y/7cRPji5wT7IH7uVuNdrpFwA5Bn5vuxu+fNRTLuod3U/HhLb+3qKE1Mlxp14GEz4fAUK1fW/SA3cpS4+pUFSHJaUedJ8mGnT8CjPZIc//JwiJ32JaMlPqqk87rGQvLIumug28K8+GrUsaXxDzXy5fQURpF4V0P4NBy0smqkHTu2+qECB2yiDzQyrYqtiugFTolfO2/Vo2i/cqpJOL7aENv2UdU6OYnulZkrylM
 uDBncb6u
 bRbMoTZ6d7jycA4/37wW4iEGrV4ga6Jd/3t+dSBKupl8DSQmw9R4f/eXOOfCbNT77t2rxFagyFM3wgfreEXQPQSbm16uUiw3TERLmqGjvrxFyHdsHOycN6hxo9rK3SgwLfJoX2nCMsgtQt+sejgEZF1SCW7P84B/rZIlbKnuf4nF8aL5gSK4m4E192nk4zW6opLzeo8RwQj9vONamgrbDlmgVlexHnMa+QouZScxH4JGxodosSg7aZblG9YBIZfWyqyYD62bX/HtxmhZFaVrKniU6TE+ajb7EwOEZAjPrqjxxnhJUEyYQIsIOEyvlhEB25h3RDEqRFVPf8814Xa+muGSUn1q+3KbbqppW0Q5i59yVOKV1FW2eHNTufimyX95JpVBo6MWzXPutjosKESePkCb4zt6yvFmHmv1Kv/pV3J6alIxC2+EhNU07qkusZKo7ixLtmZbVRF+LTD6QZRpQICUu7g60+laoAbsan2XkjSYXMlt03Q9scHLBQ+/yMLCTUQinEDDHmzDZLey5sViAf/0DbXBWorLyboEWFK8vWxEtC36QXeeL82QV76LJeKh0fWVBeUDQAv9Hsnc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo and David,

Sorry for the late reply.

On 4/7/26 18:48, Lorenzo Stoakes wrote:
> On Thu, Apr 02, 2026 at 03:49:35PM +0800, Yin Tirui wrote:
>>
>>
>> On 4/2/26 14:46, Lorenzo Stoakes (Oracle) wrote:
>>>
>>> I mean you would have needed to handle this case in any event, since this change
>>> is strictly an equivalent reworking of zap_huge_pmd().
>>>
>>> But it seems that doing so has clarified the requirements somewhat here :)
>>>
>>> I haven't had a look at that series yet (please cc this email if you weren't
>>> already, I do filter a lot of stuff due to how much mail I get daily)
>>
>> Hi Lorenzo,
>>
>> Thanks for the quick reply. I will definitely CC you on the v4 series.
> 
> Thanks.
> 
>>
>>>
>>> So if this is a PMD leaf entry it will be present and PFN map, so I'd have
>>> thought simply adding:
>>>
>>> 	/* Huge PFN map must deposit, as cannot refault. */
>>> 	if (vma_test(vma, VMA_PFNMAP_BIT))
>>> 		return true;
>>>
>>> Would suffice?
>>
>> Here is the dilemma:
>>
>> Currently, VFIO uses vmf_insert_pfn_pmd() to create huge pfnmaps on page
>> faults. This sets VM_PFNMAP in vfio_pci_core_mmap(), but it does not
>> deposit a pgtable (unless arch_needs_pgtable_deposit() is true).
> 
> Hmmm... it's only the VFIO and hyperv drivers using this.
> 
> Wouldn't we generally want a deposited huge page here now we're allowing huge
> PFN maps?
> 
> Or are this _special cases_ where we have a PMD-sized entry but are not
> necessarily wanting to treat it as THP?
> 
> This is a real wrinkle in this whole series no?
> 
> David - any thoughts?
> 
>>
>> To resolve this,
>>
>> Option A: Force VFIO (vmf_insert_pfn_pmd) to also deposit pgtables. This
>> unifies the VM_PFNMAP lifecycle. However, since VFIO can refault,
>> depositing pgtables here incurs unnecessary memory overhead.
> 
> How can VFIO refault as a PFN mapping? Does it intentionally sometimes
> clear PTE entries to effect a refault, and implement a custom fault
> handler?
> 
> I guess having a fault handler makes it refaultable...
> 
> I mean obviously that then contradicts the suggested comment above :)
> 
> That seems to me to cast a bit of a question over the whole series - having
> PMD mappings that are _sometimes_ THP and _sometimes_ not is weird (TM).
> 
> And it'd suck to add - yet another very specific check - to determine if we
> do, in fact, assume THP for a PMD sized PFN map.

Yes, exactly. VFIO and Hyper-V rely on their custom `.fault` handlers to
dynamically build mappings. In contrast, `remap_pfn_range()` establishes
static pre-mappings.

> 
>>
>> Option B: Introduce a new VMA flag set during remap_pfn_range(), which
>> we can explicitly check in has_deposited_pgtable().
> 
> Yeah would rather not, that feels like a hack.

Agreed.

> 
>>
>> Option C: Check vma->vm_ops->fault (and huge_fault). We would only
>> deposit pgtables for mappings without fault handlers. However, this is
>> fragile because a driver might still register a .fault() handler that
>> simply returns VM_FAULT_SIGBUS.
> 
> I mean again this is yet another check (TM). But probably the most preferable I
> think.
> 
> Wouldn't a driver doing that be being somewhat redundant? E.g. in do_fault();
> 
> 	if (!vma->vm_ops->fault) {
> 		vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
> 					       vmf->address, &vmf->ptl);
> 		if (unlikely(!vmf->pte))
> 			ret = VM_FAULT_SIGBUS;
> 
> And so can expect maybe some more redundancy if they also happen to map
> PMD-sized ranges? :)
> 
> And the only two callers of vmf_insert_pfn_pmd() - hyperv and VFIO both
> implement actual fault handlers anyway.
> 
> So I think this is fine?
> 

I agree.

David, since Lorenzo also asked for your thoughts on the overall design
aspect ("sometimes THP and sometimes not"), what is your opinion on
this? Should we proceed with checking `!vma->vm_ops->fault` to
differentiate the deposit behavior for huge PFNMAPs?

>>
>> Do you have a preference among these, or perhaps another idea?
>>
>>>
>>> By the way, I am wondering if the prot bits are correctly preserved on page
>>> table deposit, as this is key for pfn map (e.g. if the range is uncached, for
>>> instance). That's something to check and ensure is correct.
>>>
>>> I _suspect_ they will be, as we have pretty well established mechanisms for that
>>> (propagate vma->vm_page_prot etc.) but definitely worth making sure.
>>>
>>
>> Yes, they are correctly preserved!
>>
>> During a PMD split in __split_huge_pmd_locked(), we populate the
>> deposited pgtable like this:
>>
>>     entry = pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd));
>>     set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
>>
>> The newly refactored pmd_pgprot() correctly extracts the exact
>> protection bits (including crucial cache modes like UC/WC for device
>> memory) from the huge PMD, strips the hardware-specific huge bit, and
>> returns a pure PTE-level pgprot_t.
> 
> OK good :)
> 
>>
>>>>
>>>> [1]
>>>> https://lore.kernel.org/linux-mm/20260228070906.1418911-5-yintirui@huawei.com/
>>
>> --
>> Yin Tirui
>>
> 
> Cheers, Lorenzo

-- 
Yin Tirui


