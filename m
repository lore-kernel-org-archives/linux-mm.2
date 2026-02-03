Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 200AAE7FDE0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 00:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1186B0089; Mon,  2 Feb 2026 19:00:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E976B008A; Mon,  2 Feb 2026 19:00:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591646B008C; Mon,  2 Feb 2026 19:00:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4570E6B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:00:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D00F11602FF
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 00:00:39 +0000 (UTC)
X-FDA: 84401188998.04.B78D4F7
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3DCA120002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 00:00:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T0iqsllC;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770076837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbvMPaqv/A6c1xhFd8174Sn7MBIjDpvGdBQf/z5G8ds=;
	b=DgMNtHMEa35Ofy2S76PkIT5GIBjETh5V5aA1T10uVJuZGU4JnJ5Nerk9+rn01uaMtbw+8e
	euGGOpz9qYYX3XshCbOxdJ17Ezu8wLkeh3IvXdxky0425b2Vu+9cwxGZ8hfTS6xHDvoXjB
	+WwBLnxSMpvGTvKNzfi7CXuoD7wcIoQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T0iqsllC;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770076837; a=rsa-sha256;
	cv=none;
	b=Egg4prvrLuzHUhcbWPnOFzAMQ+E1mrHFzVOUufY4yBdKKTx9UD/+ngCwwCl6NVH0PAh85X
	LpDpL+ruKUpff7sY0fw+8s5A1NZgUiLjaLqV/CDYT7oQpm7Uv955YVnc0YvU6p9O467C4r
	k9rxc8pY3DrnuBDZa10Q/3KUzszss4U=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8845cb5862so789949866b.3
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 16:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770076836; x=1770681636; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbvMPaqv/A6c1xhFd8174Sn7MBIjDpvGdBQf/z5G8ds=;
        b=T0iqsllCiD+lFYygfV+Tdzoc7kEZOta+MCBpQQ7g8b1yyAwjTsymXE/CGo5IcrfhFE
         GpMeHxX4C01SSCbbGIfTCpbWwRaLGykNdH67naFWdMXl1Bu7iA63zMm03HFOgWWt497z
         slpJHkDarQqzOFpch3+Bhfzn/OK2Z2NArsWkWVOTVAD0XEQMtlIEokGdAwfbBIWIvgIt
         CMXhQ9GD4DtGET71O3U9rWrH38bXMW4+bYloJnrzi5BAAuiVlnBSM9PPgAcQg2qCsZat
         h3wh0GZQtKPV4ejFSLyj7G6Jrc5kk/t4wkY2TuCxPC1zH57N3A/9gOSJeu+JJ3jv3GS7
         6rjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770076836; x=1770681636;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lbvMPaqv/A6c1xhFd8174Sn7MBIjDpvGdBQf/z5G8ds=;
        b=V6lT6lZKv1Xt0iXIiMILmUkdLPIS8n2HUplNcHGPftvRklzy1FkmJqeIfm9JXCQ7gm
         8gMzb6GP+QIxQnOGURz6kR1FjvLTkr829ZhFSlXE6x//0DGRNJw/v5Yh+1MHmkf0fhOv
         3ZbyMmTO6FXLeEhOgsMZbMLtO4er6J3UNVA/kSEYnQEIa5zoVvcKOZgVaws8+saxAZkG
         pU8bGF86tGs7moEXQzaheSNJ1RvireBmvcagrKruL15AcQeQxGXa+q6EvMQ+u9ovmLlQ
         hiPUMGGuBVE3IxdCS9Y0D31yBq05/228hwyN58ZVgAoqr7jf+QWpVTH/7zTfSYuFtaEc
         /sNA==
X-Forwarded-Encrypted: i=1; AJvYcCWwtDb7hxdPGirp9W0DgX/Txx8Q4E2SDUIEhT2oH9axiF082RMxkmWVcYo0jlL+pCtQJIoImjljRg==@kvack.org
X-Gm-Message-State: AOJu0Yx6Sv/kCRU+CcfMII7LOzYuy5CJdCVyc+Z1Zqavea/NmQe5vHgj
	ympamrnyMnX+YlxSAfmfLfi+gOXpm+5xVVg7pCmlfKMzmGTsBZ6ZIfYe
X-Gm-Gg: AZuq6aITwzuCtI3MLM2oCtePECYi3Du8HGwQRkKMwWg6JKpJ1l66+oZrhDRHwsvNshD
	cSX/Siusqi+fEClArWxAr6lOc2XC9X8zWypqZw2luGAISB1y4q8aEldbTyBXr1MWcUHTYQt4Bre
	zBkIKB977DWy/nKmy+mtNiKH4JUpzqkRJgzfVVEkB0ZuqIdV1ewKBk1V4RKRw2RLiymlWm8ZXQN
	iuaLHPN85NYlAUzM9dpw+meGGPYG/UYEH8yLj5GQTpBiv4Sg8mUOdTrPxNJegsA1DLfmzUD/uUC
	Vzdf+PxDJaNqOxFhtRv+fTOjcxfcH+IolWZCCIMNirdIsD5Pm+nklAoASW0CD8mcd1gLbz9pE0h
	QD64w1VU3lZAwdOa5IJLxevLiOlRsnTvtmXQThxp1ZX08ZUZqgJ1IMKWZd4sHEa2cc7idYyaZCL
	IFnmp1t26IXA==
X-Received: by 2002:a17:907:7b99:b0:b80:3346:496 with SMTP id a640c23a62f3a-b8dff6677f1mr869096966b.42.1770076836009;
        Mon, 02 Feb 2026 16:00:36 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8e32a91885sm466312066b.18.2026.02.02.16.00.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 02 Feb 2026 16:00:35 -0800 (PST)
Date: Tue, 3 Feb 2026 00:00:35 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Gavin Guo <gavinguo@igalia.com>, Wei Yang <richard.weiyang@gmail.com>,
	david@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, riel@surriel.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
	jannh@google.com, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when
 split huge pmd for shared thp
Message-ID: <20260203000035.opgq74myrja54zir@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260130230058.11471-1-richard.weiyang@gmail.com>
 <178ADAB8-50AB-452F-B25F-6E145DEAA44C@nvidia.com>
 <20260201020950.p6aygkkiy4hxbi5r@master>
 <C620202F-685A-4B9E-B51B-078EBE5BF0C4@nvidia.com>
 <08f0f26b-8a53-4903-a9dc-16f571b5cfee@igalia.com>
 <4D8CC775-A86C-4D80-ADB3-6F5CD0FF9330@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8CC775-A86C-4D80-ADB3-6F5CD0FF9330@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C3DCA120002
X-Stat-Signature: s8bcqj5pm5xns59ywtmfm15i4k1riz7r
X-Rspam-User: 
X-HE-Tag: 1770076837-12818
X-HE-Meta: U2FsdGVkX1+Du8wKzj5XYrlh8pj+CPjEycuEBNenQDwAgmoCPaeeZobBW7wXA1XkW6aK4hwS81Sd7j2krRc1iYqrrqtIeRKrul5yGl4cWFcagiTPvA9Ykum1DWHQQsW93fKQvhACa2GyV4hNT5FZWVYuvx/2O8EP8BLKjd6uK79x44UAcg5kY308wd8uTqjGhTDaZG9W8j9J3uun6chlXOz2JuQsHGeMRmvLDsaEnEE1NGqy+R9v8Lp1TuMkNIipKORy3NdE1Nz5JChT94R8KOmitK/MajHB13RySR4F5mYUdKfdN47m00DuK79DIBhAzm+StFGo9ma8HTdUVI6MXFJDjMnDbOTuqC7NaF5yXtJhBOYNtZqiNMu7V6UGGpKZOAGUlE66htG3IkNB1rIX5yNtSNeY7aa9E3KM88ijm65h1GfwjPDsRm/jm/aXlqsiJWGY12wVcVG52BpWw3ls1Gz23CJuKzJB5b2x0uQf7uKKrfWqWbkZy+kbUVxDF2w17uZQqon0Sz9kee67w2nErEP3Isd/pBGWRQr2z7a5BRfPrJoJhHwWyPfshKuVedRsJm5OBLQp5XzOnC0uBjnhdkJM0ZS7JK9Zob3ABvnt+mCUf6TUQlGV95EvkKS3F7f6hHi3oKPtc1WRDGc5kkdpCF1MAqkiN1o/UlrhZ1LZpzSm284s4BjFjkkg5ZKyAKPI/YwwUaDlZBUE5c3UrgE6rlCARVPur07dOhJeCwXyAbRisXtMK7ma2vTBo2TkUvhcLmDjks/a7gZKegrrXzKJaWnUxQnX5z5aBnV38Sz+GhFvTJa6sNqaDl9S4iuguGBWWy2Td10litKZqephhncOdWuhsgrx+yNg9kuwP0Xez06mUsDNt3y+G4TvXpdxYmqG4woliGZXWH9QkmUaOXMF0tNE8n4KfvvaKNeshoIIvzfrxHvXiA0uVGj4Sa3O7ncQNMdG1/Panrq6ZqhZp17
 SiAxhwF/
 8dFcoQNHtthR8mkV/YVBrpAvKO0zGRHO/hZg0FGV3Gcw523Puqz2uSgG1Kd2D96ISEYJs8ayTxbc/Gi6uB5lWqWGJULsNVagshpm3mLqhOOFXVXSwIozsyfw5D/qqsXzYenPCqSBLDnRsy7k80efBpg8e57Qoj7ZWX3j2OCK9U7HJZRY0r4VSVZX4eHTWDFEILABsX05vJ8IYs11Y9rrfJPSCHS8Vvlpkh96XLqw8wfDnlYv5fzS74kVPBX/97mh5NJrkSfIGAGIzvfKA1frBsOhq6KRX1RWTnsvKR3vjhAZNLYJd/wfDwaCmsExqfYb21ChLAjWFOWpKrG1OP9Yz0AeWB2vlRRKa5mXFd3IdsIWmgd9OmloUa0FRzGL+D3+9Fwewmuw4tGyTKGXWJW7ZNogMlN4hkboZnd+HOhL75nOm7VhqJC3HCe5xJwtBtgXzAU69UGbQJ3AnhY3tzZca+YGbX1Z4Q66wAHgyOQV3JsEiwaywXNTW9cekPHOJLb+nKDtVraGVaN+T+/hBYDdb3qobMPJ5WAQLiwoL6Ov/6l1GQQbnXOjpbhwMsSJdIoW0ilR7r09YijpZ5cb9+R1ORWXcpppvqXYxGbJ67dmomg8vsbbVU5ihm5Oc3GRrsL0fVrLR7l5Wsz3KcBTSOWpV7hU8QZfPDW+0yX4w5gWvHogxSm1txPGUuGwTL8TD4ypS2xv9ggHZJfpNI/vElGnZ6yIwouwdcX4zXbid4f0wUsUTzNJrB4F/42MzQ8EC2tIZVUifVwn9nCp3AnI3Nwfy09lMXxP8hVrIeMJ5LqGw1rB0ZSjRatOv9dYzLyNBG9bYV+UF6FalMPvzi48Uk/qu9fQqjeZsuyAlPGqopsrn7IQLYxkpCcPkkWpVLdo7mDkn7/yPw6zhgvYGdSLhqhartQouGc8/o2Zjkr+hrBMRb64c83piJmhFF2nKiGuOdTk4ZmDfpJL2+TWiJxN7OKo73po2U/y4
 pjOLLhbV
 lVsOpP8hWMF7jkuH9190IA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 01, 2026 at 09:20:35AM -0500, Zi Yan wrote:
>On 1 Feb 2026, at 8:04, Gavin Guo wrote:
>
>> On 2/1/26 11:39, Zi Yan wrote:
>>> On 31 Jan 2026, at 21:09, Wei Yang wrote:
>>>
>>>> On Fri, Jan 30, 2026 at 09:44:10PM -0500, Zi Yan wrote:
>>>>> On 30 Jan 2026, at 18:00, Wei Yang wrote:
>>>>>
>>>>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>>>>>> split_huge_pmd_locked()") return false unconditionally after
>>>>>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>>>>>> shared thp. This will lead to unexpected folio split failure.
>>>>>>
>>>>>> One way to reproduce:
>>>>>>
>>>>>>      Create an anonymous thp range and fork 512 children, so we have a
>>>>>>      thp shared mapped in 513 processes. Then trigger folio split with
>>>>>>      /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>>>>>>      order 0.
>>>>>>
>>>>>> Without the above commit, we can successfully split to order 0.
>>>>>> With the above commit, the folio is still a large folio.
>>>>>>
>>>>>> The reason is the above commit return false after split pmd
>>>>>> unconditionally in the first process and break try_to_migrate().
>>>>>
>>>>> The reasoning looks good to me.
>>>>>
>>>>>>
>>>>>> The tricky thing in above reproduce method is current debugfs interface
>>>>>> leverage function split_huge_pages_pid(), which will iterate the whole
>>>>>> pmd range and do folio split on each base page address. This means it
>>>>>> will try 512 times, and each time split one pmd from pmd mapped to pte
>>>>>> mapped thp. If there are less than 512 shared mapped process,
>>>>>> the folio is still split successfully at last. But in real world, we
>>>>>> usually try it for once.
>>>>>>
>>>>>> This patch fixes this by removing the unconditional false return after
>>>>>> split_huge_pmd_locked(). Later, we may introduce a true fail early if
>>>>>> split_huge_pmd_locked() does fail.
>>>>>>
>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>>>>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>> Cc: <stable@vger.kernel.org>
>>>>>> ---
>>>>>>   mm/rmap.c | 1 -
>>>>>>   1 file changed, 1 deletion(-)
>>>>>>
>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>> index 618df3385c8b..eed971568d65 100644
>>>>>> --- a/mm/rmap.c
>>>>>> +++ b/mm/rmap.c
>>>>>> @@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>>>   			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>>   				split_huge_pmd_locked(vma, pvmw.address,
>>>>>>   						      pvmw.pmd, true);
>>>>>> -				ret = false;
>>>>>>   				page_vma_mapped_walk_done(&pvmw);
>>>>>>   				break;
>>>>>>   			}
>>>>>
>>>>> How about the patch below? It matches the pattern of set_pmd_migration_entry() below.
>>>>> Basically, continue if the operation is successful, break otherwise.
>>>>>
>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>> index 618df3385c8b..83cc9d98533e 100644
>>>>> --- a/mm/rmap.c
>>>>> +++ b/mm/rmap.c
>>>>> @@ -2448,9 +2448,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>> 			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>> 				split_huge_pmd_locked(vma, pvmw.address,
>>>>> 						      pvmw.pmd, true);
>>>>> -				ret = false;
>>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>>> -				break;
>>>>> +				continue;
>>>>> 			}
>>>>
>>>> Per my understanding if @freeze is trur, split_huge_pmd_locked() may "fail" as
>>>> the comment says:
>>>>
>>>> 		 * Without "freeze", we'll simply split the PMD, propagating the
>>>> 		 * PageAnonExclusive() flag for each PTE by setting it for
>>>> 		 * each subpage -- no need to (temporarily) clear.
>>>> 		 *
>>>> 		 * With "freeze" we want to replace mapped pages by
>>>> 		 * migration entries right away. This is only possible if we
>>>> 		 * managed to clear PageAnonExclusive() -- see
>>>> 		 * set_pmd_migration_entry().
>>>> 		 *
>>>> 		 * In case we cannot clear PageAnonExclusive(), split the PMD
>>>> 		 * only and let try_to_migrate_one() fail later.
>>>>
>>>> While currently we don't return the status of split_huge_pmd_locked() to
>>>> indicate whether it does replaced PMD with migration entries successfully. So
>>>> we are not sure this operation succeed.
>>>
>>> This is the right reasoning. This means to properly handle it, split_huge_pmd_locked()
>>> needs to return whether it inserts migration entries or not when freeze is true.
>>>
>>>>
>>>> Another difference from set_pmd_migration_entry() is split_huge_pmd_locked()
>>>> would change the page table from PMD mapped to PTE mapped.
>>>> page_vma_mapped_walk() can handle it now for (pvmw->pmd && !pvmw->pte), but I
>>>> am not sure this is what we expected. For example, in try_to_unmap_one(), we
>>>> use page_vma_mapped_walk_restart() after pmd splitted.
>>>>
>>>> So I prefer just remove the "ret = false" for a fix. Not sure this is
>>>> reasonable to you.
>>>>
>>>> I am thinking two things after this fix:
>>>>
>>>>    * add one similar test in selftests
>>>>    * let split_huge_pmd_locked() return value to indicate freeze is degrade to
>>>>      !freeze, and fail early on try_to_migrate() like the thp migration branch
>>>>
>>>> Look forward your opinion on whether it worth to do it.
>>>
>>> This is not the right fix, neither was mine above. Because before commit 60fbb14396d5,
>>> the code handles PAE properly. If PAE is cleared, PMD is split into PTEs and each
>>> PTE becomes a migration entry, page_vma_mapped_walk(&pvmw) returns false,
>>> and try_to_migrate_one() returns true. If PAE is not cleared, PMD is split into PTEs
>>> and each PTE is not a migration entry, inside while (page_vma_mapped_walk(&pvmw)),
>>> PAE will be attempted to get cleared again and it will fail again, leading to
>>> try_to_migrate_one() returns false. After commit 60fbb14396d5, no matter PAE is
>>> cleared or not, try_to_migrate_one() always returns false. It causes folio split
>>> failures for shared PMD THPs.
>>>
>>> Now with your fix (and mine above), no matter PAE is cleared or not, try_to_migrate_one()
>>> always returns true. It just flips the code to a different issue. So the proper fix
>>> is to let split_huge_pmd_locked() returns whether it inserts migration entries or not
>>> and do the same pattern as THP migration code path.
>>
>> How about aligning with the try_to_unmap_one()? The behavior would be the same before applying the commit 60fbb14396d5:
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 7b9879ef442d..0c96f0883013 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2333,9 +2333,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>                         if (flags & TTU_SPLIT_HUGE_PMD) {
>>                                 split_huge_pmd_locked(vma, pvmw.address,
>>                                                       pvmw.pmd, true);
>> -                               ret = false;
>> -                               page_vma_mapped_walk_done(&pvmw);
>> -                               break;
>> +                               flags &= ~TTU_SPLIT_HUGE_PMD;
>> +                               page_vma_mapped_walk_restart(&pvmw);
>> +                               continue;
>>                         }
>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>                         pmdval = pmdp_get(pvmw.pmd);
>
>Yes, it works and definitely needs a comment like "After split_huge_pmd_locked(), restart
>the walk to detect PageAnonExclusive handling failure in __split_huge_pmd_locked()".
>The change is good for backporting, but an additional patch to fix it properly by adding
>a return value to split_huge_pmd_locked() is also necessary.
>

If my understanding is correct, this approach is good for backporting.

And yes, we could further improve it by return a value to indicate whether
split_huge_pmd_locked() do split to migration entry.

Thanks both for your thoughtful inputs.

-- 
Wei Yang
Help you, Help me

