Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F4FF43693
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 11:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23CEF6B00E7; Fri, 17 Apr 2026 07:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215706B00E9; Fri, 17 Apr 2026 07:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AC46B00EA; Fri, 17 Apr 2026 07:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 001B86B00E7
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:58:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EB8E1A00E8
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:58:09 +0000 (UTC)
X-FDA: 84667899498.02.208A390
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C737540009
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:58:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XsD5zSOq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776427087; a=rsa-sha256;
	cv=none;
	b=IhRmrmjH7fm2cwEYzkg0fpPoAyUPSZBJrBJ80AGsGpLskZgEamp6L3ZOeiJNjKXdGWiRv8
	ZacvmPy16HoNvdgKLlH21gPYHtgmwvSbMus/BIRN+jY0u4y4APsQwdnZztz9/8194zP7QA
	8MA9NdXzuFLXshBgq5lHD96aCJUxpNA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XsD5zSOq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776427087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZQbrfXsTzPzECARueUvMfrq1WwqCmNDpweWrtj6WQ0=;
	b=gv1fSViwEmGP2N45kDTe6dlQN5SdbUespNmCi97WtwCIPdVhFItCGVznGSezFcVdf6UN3j
	+vYotGieeTUteYJY0DkjAL3fampECqGVBflGvTeH42mAo7WuRdBsYriTi+CJhPPtnpHcFB
	qoINnVn4hVCAQG2UG07MuCpDy3EGkMg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E938E6012A;
	Fri, 17 Apr 2026 11:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66FAC19425;
	Fri, 17 Apr 2026 11:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776427086;
	bh=xhQnXncuO0tw+y17tTHOqzQNM1XVHhISnPz13HWA57g=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=XsD5zSOqyCFf945CFny0tBQPXjvuOOwLUlQANOvR9JiZ1ZodUnC6TwwglTUdDw4jI
	 MDe8p6m5H0OOy6wgJT+gXOkUoIEAToZlupdkQWmbsw1FMs+c/CQiYumN17Gvtd0ue5
	 8mGicZBvz+yT5Esgj1Vu/Aa/ON5ZUNtlPxP1T/uFqfzEjiLpgsByREuMKGVS17Td1c
	 2k2XndXz+79agXCdO+lRA4ZKlF+AQU3N63F8BDfZ0RS4xtX7nS58Ik2Itp8XJG4iiJ
	 OAuwavCdgHOYPaoY3ABy616K2IO21dK646ae8gKfPT7GaeVRP62dQHaWnB0im0iZEg
	 FfliC+RhoEEQw==
Message-ID: <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org>
Date: Fri, 17 Apr 2026 13:57:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
 r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260417011606.1089985-1-gality369@gmail.com>
 <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C737540009
X-Rspamd-Server: rspam12
X-Stat-Signature: hy8o5icbdahdoqzky5fmhmnuwt6qs9hm
X-Rspam-User: 
X-HE-Tag: 1776427087-69645
X-HE-Meta: U2FsdGVkX18fgIfvFqC0NK1mI3L57b1/F1SxGV6CQrYtT4037q94Xws4k5XzSubWyHbcEMpvzjq01Jpo8Ui6+bUjOiYOl3FeGF8ZLrDrYF1Fppjscddl0hblMfGhi72Z8Ythaw7MvtQ4oXYLkoT9/fW1WAX/30MNlD3nxQ9UNAuLSlVHhV0HS3QBIFHzL1CmZLds52HR1GueWhFTDB+a15sxj/NHE5UTK452ee1hHGkrjcR70WuANxBDCMeyUJwr/ermdYjk7mFgzyoyEnMIDkJrNUuewWRln2JdyYmcnI2ddHSAeiwWU75Nn24oZVcUBwqcc4gkg+1innKNSXa+cdNLnCH+Jtdgf5P3BuuEzcqKVPHF82vIkeVWnPLPmVot5gjImMTh7PlwFWrT9GGxxYoQYfacJARKQNZsS3XD+nblRbDRb9wTYBG9PKmEUC7grhu3nbfteM6mhPG826G5gZkp5FgNUtwsdAwJBAVhZdjUM7MksFjEfFNrAWq7KbgwI0lcjZep7U/cvE3xC23meU0IRAcaZwdco3r3wrKp51aep3pcJuaP8yCAlYDmPTlGjmC9bo+3Rfhph3Ouqo/jb/+CCI2bagM1iM/3pfjNTY0E/2T8Ap1LpTXcCHcJeq/rrs915lz2NjbWg8aeyGsl5ThvC/BAf8FoudnpNgqS6iXBjYgYZNbf254wXmvuAutvA3D1jJm8MqU+4E4QAJ41zHINuBRYeGx3Zkn8Zm/0GmeC8YgtSEceXDk4S8+BkYeXkDOFKAfhuy4mhhkXUFXrHLIJyqmVK6ncvgIw7hET7ujP504FVzrq+ek7WfOcihrGbtKnphVJUxuWh6BAvh217vsKOR0tbguEYbWagHUJXc4fik+uyLLAlEcwHxxwdUt3QzYSytdidDQn9lwzz30oNXjooPwmRzMmH7WclXkYnC5hg59F3S410JZDc1nYENChbVMN+53ZEzdicX6AYNW
 5sM2ndvb
 sXCAPIXyE38Xist01YdrnfiK8uJgdCYe9PDu594GRSLXQxwAous+YmhUWeuvO1k6SXChxohmqik53zGRY/LxKk/P8pIgwY5MY2UlVVExWX7RFHpxXYtnGJxJu9lnlKlfdP0a7sPGzR32rEhsQ/hk5K7cZbmoJcVZga2pZNjoBbQEFaz7wnoqToYn1SxOJSjoIbwjwS1T/6I4pIFAvekqynQe9yHaMY1VYt6M6q+NgIv+iDAA1Nr47SxLchS94WWgqOotnu8wPc0cGZQK4QN2LeQcGz/gGAqawhFRa0FQNX1zGh6TEOGTDlCo/AOHsP1lzarRVZZPC5OZ0xxq6yb81fTyNUl6zk3DVzBda
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 12:53, David Hildenbrand (Arm) wrote:
> On 4/17/26 03:16, ZhengYuan Huang wrote:
>> [BUG]
>> madvise(MADV_HWPOISON) can fault a swap entry back in through
>> get_user_pages_fast() and hit:
>>
>> kernel BUG at mm/rmap.c:1364!
>> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>> RIP: 0010:__folio_set_anon mm/rmap.c:1364 [inline]
>> RIP: 0010:folio_add_new_anon_rmap+0x41d/0xc10 mm/rmap.c:1553
>> Call Trace:
>>  do_swap_page+0x14c5/0x5c30 mm/memory.c:4963
>>  handle_pte_fault mm/memory.c:6198 [inline]
>>  __handle_mm_fault+0x1512/0x22f0 mm/memory.c:6336
>>  handle_mm_fault+0x42f/0x820 mm/memory.c:6505
>>  faultin_page mm/gup.c:1126 [inline]
>>  __get_user_pages+0x4b3/0x3400 mm/gup.c:1428
>>  __get_user_pages_locked mm/gup.c:1692 [inline]
>>  __gup_longterm_locked+0x945/0x14b0 mm/gup.c:2476
>>  gup_fast_fallback+0x8a3/0x2440 mm/gup.c:3220
>>  get_user_pages_fast+0x64/0xb0 mm/gup.c:3298
>>  madvise_inject_error mm/madvise.c:1456 [inline]
>>  madvise_do_behavior+0x503/0x860 mm/madvise.c:1875
>>  do_madvise+0x17e/0x210 mm/madvise.c:1978
>>  __do_sys_madvise mm/madvise.c:1987 [inline]
>>  __se_sys_madvise mm/madvise.c:1985 [inline]
>>  __x64_sys_madvise+0xae/0x120 mm/madvise.c:1985
>>  ...
>>
>> [CAUSE]
>> Commit a373baed5a9d ("mm: delay the check for a NULL anon_vma") moved
>> anon_vma preparation out of the generic fault path and into the fault
>> handlers that actually need to install anonymous rmap state.
>>
>> do_swap_page() was left behind. It can still restore anonymous mappings
>> via folio_add_new_anon_rmap() or folio_add_anon_rmap_ptes(), but it does
>> not call vmf_anon_prepare() first. On a VMA-lock fault this can leave
>> vma->anon_vma NULL all the way down to __folio_set_anon(), which BUG_ONs
>> on that violated invariant.
>>
>> [FIX]
>> Prepare the faulting VMA's anon_vma once do_swap_page() has confirmed it
>> is handling a real swap entry, before any swapin path can install
>> anonymous rmap state.
>>
>> vmf_anon_prepare() already handles the retry rules for VMA-lock faults,
>> and when anon_vma is already present this stays a single likely branch in
>> the swap fault hot path.
>>
>> Fixes: a373baed5a9d ("mm: delay the check for a NULL anon_vma")
>> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
>> ---
>> I can reproduce this issue deterministically on v6.18, but I have not
>> been able to reproduce it with the same setup on next-20260415.
>>
>> However, I have not identified a change that clearly explains the
>> difference. From code inspection, do_swap_page() still appears able to
>> reach folio_add_new_anon_rmap()/folio_add_anon_rmap_ptes() without a
>> prior vmf_anon_prepare()
> 
> 
> If there is an anon page swapped out, certainly at the allocation time
> of that anon folio, there would have to be a anon_rmap allocated.
> 
> During fork, the anon_rmap would have to be created as well.
> 
> Something is off here.
> 

Just speculating, we had

commit 3b617fd3d317bf9dd7e2c233e56eafef05734c9d
Author: Lorenzo Stoakes <ljs@kernel.org>
Date:   Mon Jan 5 20:11:49 2026 +0000

    mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too

Go into v6.19.

Maybe there was a scenario where we could have lost vma->anon_vma during
a merge, resulting in a swapped page in an anon_vma.

If this cannot be reproduced on 6.19+,there is nothing to worry about.

-- 
Cheers,

David

