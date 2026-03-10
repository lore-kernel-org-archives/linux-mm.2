Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E0C3F3C27D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3046B0088; Tue, 10 Mar 2026 05:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426956B0089; Tue, 10 Mar 2026 05:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308396B008A; Tue, 10 Mar 2026 05:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4A66B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:12:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3D7F16024C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:12:02 +0000 (UTC)
X-FDA: 84529586484.23.F296A9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1615D140010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:12:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rLelnm2x;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773133921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEp/VHtS7tP0sYFnG/pY6WV9P5XMFalCdOru6TF1eSg=;
	b=tjk6Yft3bksKRbfHrkrWNKsRKhYXndcCdhxqEDZspE6/UMDH1lEJdlAp9cAyDoY5NHrSsg
	4dqXnMUxqcr3tIN8R1ppgYGlcvogQLyD5+5Z357GFY7rNEBJ2DEucC5rQs6umR5ETdHlqL
	tKgPHSyax2m+Sb0DfhEoYh+UPBt9qWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773133921; a=rsa-sha256;
	cv=none;
	b=BAOLoZ8VRL0hsdR7OM+yVH5YaaUNVgqF1pdu60tZexe6KDisdB/1NJ/kQBsuImjjlcE1o7
	hRF2fj1eK2kv/0lap38hbCAl9CfkOVcTw5RawiEeb/oe8YYgg9B8nCIBYABa/jWgUqvJKX
	yN/Nz81Ou46NPMDusQk4hDNPSocm6GU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rLelnm2x;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48260600C4;
	Tue, 10 Mar 2026 09:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C1AC19423;
	Tue, 10 Mar 2026 09:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133920;
	bh=2BDyZyfqFWbjXRsjJ1VfZxSCSc8a9G8thvSqUHJJhjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rLelnm2x+/tJnH+oLPTKndoHWRmM+haSoXC5xfvVUglwXC/Jc5GZGqTUmlM7B3UJg
	 nLPCtMZWmIss09pLDPgp5tHL72SfQxm48w12jM6/3YqeUXDXmCLMX+PFWtXtJI5flh
	 kSD0lKXZhmwunVhu6acWmEurTpy0ay7TeKTbC9PYRTVA2dpB6/cslSnD/ODgCa11YE
	 v4uOP99XBTtOH+lajmlrSKQ6gntzxA071HbCY7gWYKp/NFzfGr5fDCAT+S9Ub4MHeL
	 acM2gKfvMqVND21MZ07TXiqx7Kg5G2IrUdBKyHROyEOe9Fdx+psCME6HdAtQ2eXkb0
	 mSfJeIRd3AEgw==
Message-ID: <da2ebc9f-ec82-4c55-851c-b27110efdf8c@kernel.org>
Date: Tue, 10 Mar 2026 10:11:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
To: "Boone, Max" <mboone@akamai.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alex Williamson <alex@shazbot.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Tottenham, Max" <mtottenh@akamai.com>, "Hunt, Joshua" <johunt@akamai.com>,
 "Pelland, Matt" <mpelland@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
 <20260309174949.2514565-2-mboone@akamai.com>
 <51eeb09d-d3f4-412f-85da-690fdc0f8e6a@kernel.org>
 <CH2PR17MB3797A91D5107B6E347EEDD97BF79A@CH2PR17MB3797.namprd17.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CH2PR17MB3797A91D5107B6E347EEDD97BF79A@CH2PR17MB3797.namprd17.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1615D140010
X-Stat-Signature: pea5hhdo17ex7ssjx9oh8bhdq466un93
X-Rspam-User: 
X-HE-Tag: 1773133920-484054
X-HE-Meta: U2FsdGVkX19NeTx5+8LbuK1hDc/q/Zvs2TKqUqoqL0KCm6GKAXKRBW2cRNmMSOsrKBLpzFCFlohRzVvc26SolAXJSCl5ZEuMJ87RttrW9cPyNq9r3YHXNJt0ANcAx8qFLAU1uUKLrG7F5SaWeQG0yTLMATIxqVvL3b/QaMvpGwgqWVNM/VOiMwtH1bCKeafh/PIk0MXFe38Ke9TUff5AsilDMlSOJxXQcdFRU7aunEFYVws5A8/fxKWT8IJT0+hde1KGmTEcAKnESG84Bq/oWXf8h3ovbbvmeBEwWfMLA6fwS0tN5v2mqc063EQVTIVhV4FLgsWm6rNZO/Wf62oX1PqYuEbmhuWrHwh63E1wcYT+EEKMBgearDwx/7PpUVGE/yYJMW5qxWL2Wj7XQNzSw6rpJrGnzuB8ywpcuCer1w09i6hue3GM/55nrrUshbzTWWLeDyhrcTl0Ttz3/YdJZJ9MtyMvfsRe0+6Z00Lj7v53Ldv5zrxHmYovVjexKSTkLJ1Stawtp4y1wbKCRmcGg3ODQ6G6OpHD9Uc8xZeYq19IbJgSr1FlBoCXpxEo4c+2tegqePKGOapkUzGd3ScMucwgauyYBc4AF9kWwYLGTcvqAEBhhqnZidukj/296kvJ09QV+WYxshwqbk/oaW9mlD3KnaZB0lvrG5eLx9mBDR81KITL0EGjrOZwNk6SX/7LqmV/NHedQEOyu54irCCYmcNiOeecbGn+EJYkk+fUA8jZ2ohF7WeK+dhvGBCSeE9INP+h+jc7+Gh2suA6l3ZdqG6YvlKPn8mzW1XN2QUbgJKHsxLRG454dSnsMnUByLvMB9+YiVm4tY1qYX+r2HZDRFSFapC7EMWepmLXhzrBd2BVIwKM0rkaDU+1MSALYqhvryOmQ/6i8s8i9LiB7KVMuVOo/tckCQn9r3OVa/TP4RIjZm4rooFJ9X2v7tRaYTQn2/XcbUyBHh/GwczWdvS
 DwpTnlFq
 0Trx42vhUHkub8juszTT3peZpZMmQDTyxwfVNG2IE0ZvPGJXry7btIDvIw3iKZ9kaPtvA6+ZjpxGhskAm3Svb8DGYyxmpaiZjbi9MMvQESHKsg5BXKrDG0VwgIzqv/uR1GQBfViHjSyOc0g7IIrCUw2WCGMxv1pe4/veccsF9uDM0Sl3qtFkLKUqIGJ/cAfpLUwtJI+w/9W3oPsed4BKaZ/W7CsIxPvtyVAW46fuMaUchSuu4JSzlPUw+gQIErU+Pv61AFSQzkJO9TPl2G2iYEWYAPMdB4mRV3u0NLZMfgUFK+O7v8dV36yjhP39shhmD8mLW3WgjpazRoYu0BlObZGT9L+FqmvDtRns/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 00:02, Boone, Max wrote:
> On Mar 9, 2026 9:19 PM, "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>>
>> On 3/9/26 18:49, Max Boone wrote:
>>> Don't split and descend on special PMD/PUDs, which are generally
>>> device-backed huge pfnmaps as used by vfio for BAR mapping. These
>>> can be faulted back in after splitting and before descending, which
>>> can race to an illegal read.
>>>
>>> Signed-off-by: Max Boone <mboone@akamai.com>
>>> Signed-off-by: Max Tottenham <mtottenh@akamai.com>
>>>
>>> ---
>>>  mm/pagewalk.c | 24 ++++++++++++++++++++----
>>>  1 file changed, 20 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>>> index a94c401ab..d1460dd84 100644
>>> --- a/mm/pagewalk.c
>>> +++ b/mm/pagewalk.c
>>> @@ -147,10 +147,18 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>>>                                continue;
>>>                }
>>>
>>> -             if (walk->vma)
>>> +             if (walk->vma) {
>>> +                     /*
>>> +                      * Don't descend into device-backed pfnmaps,
>>> +                      * they might refault the PMD entry.
>>> +                      */
>>> +                     if (unlikely(pmd_special(*pmd)))
>>> +                             continue;
>>
>> In general, if you're using pmd_special()/pud_split() and friends in
>> ordinary page table walking code, you are doing something wrong. We
>> don't want to leak these details in such page table walkers.
> 
> That sounds sensible, there is a check in the split_huge_pud macro, which previously included DAX memory.
> 
> Related to handling that macro, I see another proposed patch for lazy provisioning of PTEs for PMD order THPs [1]. Possibly adding a return code to the split functions allows a better solution here as well?
> 

Maybe. I think the behavior of trying to split is ok. We just have
to teach code to deal with races.

Because the very same problem can likely be triggered by having the
splitting/unmapping be triggered from another thread in some other
code path concurrently.

> I'm not sure if making the split (or rather unmap, calling it a split has been a bit confusing to me as it doesn't allocate PMDs) a noop will improve things - as to my understanding it will still try to descend.
> 
>> We do have vm_normal_page_pmd() to identify special mappings, but I
>> first have to understand what exactly you are trying to solve here.
> 
> Specifically for the page walker, avoid splitting and descending into the PUD-order pfnmaps that VFIO creates for the BAR mappings - as these (can) represent hardware control registers rather than regular memory. I haven't been able to reproduce it with PMD-level pfnmaps, but I'll build a kernel with PUD-level pfnmaps disabled tomorrow.
> 
> But if course I'm mainly concerned with fixing the race such that reading numa_maps does not cause an illegal read, resulting in the read process crashing while holding the mmap lock of the process (and subsequent reads of proc freezing, waiting for the mmap lock they'll never get).

Right, that's what we should focus on.

> 
>> (You would also be affecting the remapping of the huge zero folio.)
> 
> Ah, good one, I do think that this race can occur with PMD-level mappings, looking at the walking & splitting logic - but given the PUD-level mapping triggered the (rare) occurrence I'm fine to focus there first. I guess it helps we don't have 1G THPs, but it would be good to treat 2M and 1G similarly?

I don't think it can happen for PMDs, as pte_offset_map_lock() double-checks
that we really have a page table there. See __pte_offset_map() where we do a

pmdval = pmdp_get_lockless(pmd);
...
if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
	goto nomap;
if (unlikely(pmd_trans_huge(pmdval)))
	goto unmap;
...
return __pte_map(&pmdval, addr);


If someone re-faulted the PMD, this function will detect it and reject
walking it as a PMD table.

PMD handling code has to deal with page table removal, so it needs 
some extra steps.

For PUD handling we don't need that. Once we spot a PUD table, it's
not going to get yanked underneath our feet.

> 
>> A lot more details from the cover letter belong into the patch
>> description. In fact, you don't even need a cover letter :)
> 
> Hehe, first timer, still figuring out the process.

:)

> 
>> IIUC, this is rather serious and would require a Fixes: and even Cc: stable?
>>
>> I'll spend some time tomorrow trying to understand what the real problem
>> here is.
> 
> I think so, the bug can be easily triggered by repeatedly booting up a VM that passes through a PCI device with large BARs while continuously reading the numa_maps of the main VM process. The reproducer script is mainly to narrow down to the specific part where the race occurs, the VFIO DMA set ioctl.
> 
> Should I raise a bug email to refer to, and resubmit a new RFC v2 (without the cover letter), or keep discussion in this thread for now?

No, it's okay. Let's first discuss the proper fix.

> 
>> But for now: can this only be reproduces with PUDs (which you mention in
>> the cover letter) or also PMDs?
>>
>> For the PMD case I would assume that pte_offset_map_lock() performs
>> proper checks And for the PUD case we are missing a re-check under PTL.
> 
> Have only seen it with PUDs, will try forcing the mapping to happen with PMDs tomorrow.

Can you try the following:


From b3f0a85b9f071e338097147f997f20d1ac796155 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 10 Mar 2026 10:09:39 +0100
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/pagewalk.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index cb358558807c..779f6fa00ab7 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -96,6 +96,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 			  struct mm_walk *walk)
 {
+	pud_t pudval = pudp_get(pud);
 	pmd_t *pmd;
 	unsigned long next;
 	const struct mm_walk_ops *ops = walk->ops;
@@ -104,6 +105,18 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	int err = 0;
 	int depth = real_depth(3);
 
+	/*
+	 * For PTE handling, pte_offset_map_lock() takes care of checking
+	 * whether there actually is a page table. But it also has to be
+	 * very careful about concurrent page table reclaim. If we spot a PMD
+	 * table, it cannot go away, so we can just walk it. However, if we find
+	 * something else, we have to retry.
+	 */
+	if (!pud_present(pudval) || pud_leaf(pudval)) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
+
 	pmd = pmd_offset(pud, addr);
 	do {
 again:
@@ -176,7 +189,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 
 	pud = pud_offset(p4d, addr);
 	do {
- again:
+again:
 		next = pud_addr_end(addr, end);
 		if (pud_none(*pud)) {
 			if (has_install)
@@ -217,12 +230,13 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 		else if (pud_leaf(*pud) || !pud_present(*pud))
 			continue; /* Nothing to do. */
 
-		if (pud_none(*pud))
-			goto again;
-
 		err = walk_pmd_range(pud, addr, next, walk);
 		if (err)
 			break;
+
+		if (walk->action == ACTION_AGAIN)
+			goto again;
+
 	} while (pud++, addr = next, addr != end);
 
 	return err;
-- 
2.43.0


-- 
Cheers,

David

