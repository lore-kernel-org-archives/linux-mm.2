Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD3BD29FEE
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0010F6B0005; Wed, 14 Jan 2026 06:18:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AEE6B0088; Wed, 14 Jan 2026 06:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D166B0089; Wed, 14 Jan 2026 06:18:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D54EC6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:18:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C0C38BAE2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:18:34 +0000 (UTC)
X-FDA: 84330321348.26.9564B73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id AA315100012
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:18:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GM3XGH6q;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768389512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzyrBmqSAAqFr9ClVLULfIRefi9jEcNxTmuRT9lwr2M=;
	b=TU9tTOehw602B0htlzirQijyshp0//YxJsl766+v2e6OonyM+p73rE8DQ3oPrPqBXNy3Wb
	imLVjxCeTAT6BZuGxLOEF6pdlg0Zp3Zf89kJVoQh6blw5+Iu2Cziuu3I5hnk0MahToiyBT
	OfcWzBAXHsxSnesOlDEtFbpc8SpBLm8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GM3XGH6q;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768389512; a=rsa-sha256;
	cv=none;
	b=D3Mn8XivYLHmldPpi0/UcLVO63pFtzt7XJjHKeBxzknzARDL4ojBXxnkY25F8vwqxtjHzQ
	2nyErTCA0+9OEZQcKZpBaYlM7J10yamc9dwjrIYLDPYoClYGt/Dba9p2fugt8ta1m4SkJ3
	unIRaOw0sELDYPm4WhMrAdhoROEjUCU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FEC16001D;
	Wed, 14 Jan 2026 11:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36431C4CEF7;
	Wed, 14 Jan 2026 11:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768389511;
	bh=GXzJ+yUfp9XANjqi1yZT8WBcSpKtfiye6aaL8wZUsR4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GM3XGH6qaq0giaJbLi7IiZASEJJdj4aadn89uMm1v1Gb2HffgqLrfYU2Tewjn1DC9
	 qpHfCGeVi2bSqU1N2994EKZdplfN7vdg0dM5SwxJNjeDXRJipkBJpFqlU80bfUsg/y
	 5RQhhIdT/l2+8BjJdjv0jMbGNt6SG85w+wyEtv+WLjoh6qJdjt/3IQiz6WZq03WLgZ
	 BWb9w4azxFML4P+NeOiPr1US0/8zZwpkqt1ay7+WWMZW4xAfENWwnIP3yR0lw0k63Q
	 9DfKg0ouGb2kmfhQypNFbx2KSA89+8O47L5exU9SE8W9AaMxXwTFw7Cf4iqsj5hQx8
	 ZBbJF5MFDIGsg==
Message-ID: <512dab18-483a-4cf0-976b-d37806d3da35@kernel.org>
Date: Wed, 14 Jan 2026 12:18:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-3-yanglincheng@kylinos.cn>
 <69c9ac59-4fb2-42fc-a8ae-32f583e47de4@kernel.org>
 <zc4yspu5rq4he64std2f6l7mnyua36tudnwj7fgqmk4aioevzw@ungu66emhlgf>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <zc4yspu5rq4he64std2f6l7mnyua36tudnwj7fgqmk4aioevzw@ungu66emhlgf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: mdr951hcwuuog4h9wp6owchwfgfutcnf
X-Rspamd-Queue-Id: AA315100012
X-Rspamd-Server: rspam04
X-HE-Tag: 1768389512-563885
X-HE-Meta: U2FsdGVkX19RKqn3I9a3vF0mi8Y2ehPAjCLtxNI88LGxX/p85EFXfNJFX/QULx09XZ6k05o9dYmFbJd0G9jpEcwAIxN7RJHReMsGDKim15xykMg0i6+Tu/8cLzh95/eoAEF2v7xixDwqYumZCfh353MJFa0tbSiVakfYa93g+2FyRy7Y3mcWfDTohjFL61pDCSp/fsP9anKrSj6ThP4Loi3A33TFHKh1w+f1Z2RHbpyqo9QRoCpYnmYdgUCwFcGAtKIhsaezR84cIjpFP4SGMe45R+v+9sHLiLYLqk3dkApnXZKkQoV+vInB+3AhXTVIzeO2mWcQ2/8R66EgMkhsnBOs0MM63vW0/UCWopIvo14JvMcwY+J6A0XUId/K6gQ81zdvtEfKzF3qQ6ZFw2zb8am8rfEUslqh+tUhlCBEdC2ydIL5VqBUFoiligBhqymJAu+ng8rcxjtbuSWcBa8S5A32KSXjphqXemfVUE89KAYqifl4Eldnqwp/nYnQG53jHmLM1yd33ZCp72OTiegpkUDUdfG+LNaph1ZBoq3RoQ99UIF39HqD+bkDTi62bxdED3uAu0obo9quCACfP/0mBIF7VhW7Uf3ML/M9gt+7m1wvxyfu2Z2dg482We74NHOrreCLOqycIi/qBfgp0mqzv7AiRo5rKP4X2yCKas2LorolCtFYEgSf84u2iZFsz/aOcV3EOgP8SC2rBNNHYMsbTLGf3cDi/icije8zmRRLsajdjKefv51s8ZLXvEyF3R6AeJHpFeNO1k331ogdxRbGZLR1Wx0Lor9NbIrwk+LE1uLLHUK+w6YkIoNcCB1gsL7Ic6JE6806ZcVcOFWQRl7invKXX42nO7xHF747kKbEDwVLOdQ3KH9uhny7Yi7VSLS59d7ZhUuIkJlAU0S+7pIfv57gVR/pY2wo5hrU4BFL5t/Dg7z3f5Q+Ys5cD9ncxuXB9bK2eQBDXQ5OXd+R6lw
 To1yFWTr
 nFZdePDB+oRMTcB8gtT2Tj/nhefYLV1aFIxPjGrWilDt8F8fv/sUIvYIRDvRxx+Em1Np/IhHGpOHGxFr05EnhgTOaeJdamiTu0bQhxg1I8RAwVvBt5h8ymdC02Zbhz8/lKaAp+3e6C6Vdt/Sw/98By2iI4zYkS1zySZg3adCO4gh+imm4c1oS+n111csx8ji5z4pm6qmFcrYmBvTmun5J6fDpxG/7OgrW6yp+hNduE4NucYXdihONEtQR8Wwe5vtBV2GMuzPRwjr+5Pp8W10VQLjsTWAMXm1Hvosv9Ob/FE+tIwoZAydIX5KvAdBXXEMNgKo2LDs3ikde6Hn/98w/4Njv5qn5+VTLEcvTNr7euohPY7oKwP62X37jtPtui2WjvWn90BW9ml7CXVjQiQb4J1G1+51kZK4P0kx+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 06:55, Vernon Yang wrote:
> On Mon, Jan 05, 2026 at 05:49:22PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/4/26 06:41, Vernon Yang wrote:
>>> Currently, each PMD scan always increases `progress` by HPAGE_PMD_NR,
>>> even if only scanning a single page. By counting the actual number of
>>
>> "... a single pmd" ?
>>
>>> pages scanned, the `progress` is tracked accurately.
>>
>> "page table entries / pages scanned" ?
> 
> The single page is pte-4KB only. This patch does not change the original
> semantics of "progress", it simply uses the exact number of PTEs counted
> to replace HPAGE_PMD_NR.

You used the right terminology: "PTEs" counted.

It could be either a page or a PTE, depending on whether we collapse an 
anon THP or an file thp.

You make it sound like we always scan pages.

[...]

> 
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> ---
>>>    mm/khugepaged.c | 31 +++++++++++++++++++++++--------
>>>    1 file changed, 23 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 9f99f61689f8..4b124e854e2e 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1247,7 +1247,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>>>    static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>    				   struct vm_area_struct *vma,
>>>    				   unsigned long start_addr, bool *mmap_locked,
>>> -				   struct collapse_control *cc)
>>> +				   int *progress, struct collapse_control *cc)
>>>    {
>>>    	pmd_t *pmd;
>>>    	pte_t *pte, *_pte;
>>> @@ -1258,23 +1258,28 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>    	unsigned long addr;
>>>    	spinlock_t *ptl;
>>>    	int node = NUMA_NO_NODE, unmapped = 0;
>>> +	int _progress = 0;
>>
>> "cur_progress" ?
> 
> Yes.
> 
>>>    	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>>>    	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>> -	if (result != SCAN_SUCCEED)
>>> +	if (result != SCAN_SUCCEED) {
>>> +		_progress = HPAGE_PMD_NR;
>>>    		goto out;
>>> +	}
>>>    	memset(cc->node_load, 0, sizeof(cc->node_load));
>>>    	nodes_clear(cc->alloc_nmask);
>>>    	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>>>    	if (!pte) {
>>> +		_progress = HPAGE_PMD_NR;
>>>    		result = SCAN_NO_PTE_TABLE;
>>>    		goto out;
>>>    	}
>>>    	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>    	     _pte++, addr += PAGE_SIZE) {
>>> +		_progress++;
>>>    		pte_t pteval = ptep_get(_pte);
>>>    		if (pte_none_or_zero(pteval)) {
>>>    			++none_or_zero;
>>> @@ -1410,6 +1415,9 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>    		*mmap_locked = false;
>>>    	}
>>>    out:
>>> +	if (progress)
>>> +		*progress += _progress;
>>> +
>>>    	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
>>>    				     none_or_zero, result, unmapped);
>>>    	return result;
>>> @@ -2287,7 +2295,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>>>    static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>>>    				    struct file *file, pgoff_t start,
>>> -				    struct collapse_control *cc)
>>> +				    int *progress, struct collapse_control *cc)
>>>    {
>>>    	struct folio *folio = NULL;
>>>    	struct address_space *mapping = file->f_mapping;
>>> @@ -2295,6 +2303,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>>>    	int present, swap;
>>>    	int node = NUMA_NO_NODE;
>>>    	int result = SCAN_SUCCEED;
>>> +	int _progress = 0;
>>
>> Same here.
>>
>>
>> Not sure if it would be cleaner to just let the parent increment its counter
>> and returning instead the "cur_progress" from the function.
> 
> Both are good for me, I have implemented one version as follows, please
> see if it is cleaner.

 From a quick glimpse looks good.

-- 
Cheers

David

