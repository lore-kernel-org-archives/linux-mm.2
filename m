Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F32A7CD37AF
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 01:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E317C6B0005; Sat,  9 May 2026 21:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2C96B0088; Sat,  9 May 2026 21:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8296B008A; Sat,  9 May 2026 21:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1DB66B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 21:20:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 508EEA01B3
	for <linux-mm@kvack.org>; Sun, 10 May 2026 01:20:34 +0000 (UTC)
X-FDA: 84749755188.24.B03A81E
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 53F3840007
	for <linux-mm@kvack.org>; Sun, 10 May 2026 01:20:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hk5405i+;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778376032;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPeyCSpilgNhYSZ9AJzQNjhonaLltjeBimOAJhldfaA=;
	b=PKrgQIqAjqO2KxskeG7EM2in4bG9oKFxom1t5XJhA2roQaDErIFSuEpoSnZF34X2fYxXD0
	9HNFCwE9xa1FvnVdYiCQxgh4JMzMalBIPzOD5ZA2PGEfqgkJtP3ib3M3NHiOs337yVf94K
	61Vgv8vgQ0wN9zJBhLKFmFMaxkPD+rE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hk5405i+;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778376032; a=rsa-sha256;
	cv=none;
	b=Qbgctkok2DN9oyPGzJnDTE0rJRIkLLhLs4b/1gzDt4KYwJcwI1BL1puduyET1z85NIZukQ
	hp9MZ0BNf1znM04+AYlqO/JEuk9DVCwUdjdkejDa0CiXgwY7oQJmV6SeR9hbrjVQlCdUJh
	d+aXaS+F2LYCIQojyrYQrFoeUxKl+7U=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bcc9fdc959cso88567266b.2
        for <linux-mm@kvack.org>; Sat, 09 May 2026 18:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778376031; x=1778980831; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GPeyCSpilgNhYSZ9AJzQNjhonaLltjeBimOAJhldfaA=;
        b=hk5405i+nA+jhwLsDZdRFODZPVEg7vlWXaTQ0DSyPPGS+QaTtNFWX6ALNi1vImgSH6
         l4D+KBk0RFGtt6cfA7Moy0FV556dz3mVokNddVDidno5rJq5hVxuOqiIFul2PvpbhuCK
         wbsATB2cCrgwjICX2Ld9c04C4UtCob2Me84oAXyfkeZ5V0zTZZEKYjbrODoeEmbynrSs
         N6tzUlbNMtC+VAbF/NOTL6DStjbylGOGVsnnNfb5i8fDETvf0cAuPuWr7w7+oqh9Si5G
         y2F4LGtIsHdeiC6lBUVebZdMLQMLAeiA1x8j4EskeijYpy6jj/hKZHEh1YiGCYyYdPct
         6R0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778376031; x=1778980831;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GPeyCSpilgNhYSZ9AJzQNjhonaLltjeBimOAJhldfaA=;
        b=GPxoh9AejW6j9PthzSMlByRsRy2IZtd3dL2E5P33cgWEDn0iewPCy5L9jC+RQG0t3f
         j7R6Uginc/BWWIXmUIfGCyTYV6fgST/mWoys50FqH5fqA6mdZWuPqSJXU9LSG20ehInJ
         em8kuqhlsTtB0V/DmM6apN0YqMg1DweCWzW7QsyKvK1C35WTSsJy7KsVD8I8wq8Uf8HO
         sJwpPAY3vzQ/sseb5oed41x9R5Hk0/oLWto7kTsTclw5SXM6bcOpUiXO1WPx6zWHKEdI
         JrljYcPm0vDBfncqooi4gdFVWNWhphd+vShCkMBcUlAKfzkeHd8/dvWWzze8zKBjEJ79
         IHwg==
X-Forwarded-Encrypted: i=1; AFNElJ8Wx9Ey20femqK1NTMULyRgSx1cXVsMGVF/lOyU6nAc5fYt+QZs1sXlyag2BFk7GCKPP9Aj42fh7g==@kvack.org
X-Gm-Message-State: AOJu0YwIqisslEhK8d+UCurb838RzFLUFfLMb4s064Pe0TCEfBgnnvHl
	feWJPoRcs3Vgqm+8QelLitAgIyBCua4JRJQ22Q5KGmBirFqhXsQPSjNa
X-Gm-Gg: Acq92OHhXcJjlRAChpDw3M3jcGjfPSE7c5LPb3EAPMt4EMu4+RpFw/Fn0vEnX9aQ5LU
	kHrias6xUoIOsJZ/Hk5sCTOYDPCwTYVGo2Xolxq5GQZc7xcS0Jna4fsFMMT6Mm+TELMNXO2Q78M
	Gtzf+TkqYngY7GgN3xSZFLYvAu5YpTu0T3X3abDufNidG74PbJt4kWKH0Nf3AFOv+tsw1BHKUZ8
	uGIOl9cbwPbazNORDwEls7EGzaW+Va/CmyPerlu7yW8I3lQpoH46KAJgd1igHL4vHemFJlAbULX
	AJ5mYkmqoWBIfVsbbqGZnQREGQZkyanCDVKucqycCUcv44e7DDJuDAaotA5coId+xhtu3tg9bZa
	EVpRwZSxj3orkYoVkWceeLXoSXIextemoMGZbkItfQLRqa+Y8XMoP8TkpHk/f9PrUjGxej+7Imm
	ggiPtAJlz3MdMmCyMKPfGL+A==
X-Received: by 2002:a17:907:9305:b0:ba7:7f6d:be4a with SMTP id a640c23a62f3a-bc56d132a0amr1076366066b.26.1778376030451;
        Sat, 09 May 2026 18:20:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcac02c82a3sm285137566b.13.2026.05.09.18.20.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 May 2026 18:20:29 -0700 (PDT)
Date: Sun, 10 May 2026 01:20:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, riel@surriel.com,
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, sj@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260510012027.rez7v33w44rkbtyx@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
 <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: aa63dnatb387xqnza6psbsg3e4p6qaf1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53F3840007
X-Rspam-User: 
X-HE-Tag: 1778376032-958731
X-HE-Meta: U2FsdGVkX19nONIMRN+R2uLvJT44T2bighlauDC/td79S/EalE0hW4VNa6a2d/QnzmSLyjiyZqmbIszO1TjdukcWdpOsnDZ+8LwkjtyV0WRtheD1/b2rvfYoR2VBpn3iwCiUd0kwL0meuXn3xmUQ8Gbd6kkxotatQhCj7RPkFFE580HXT/gXy09m/OXZdHjoQQZvExlWNSVYWWf0onGM9cgvu68q2SZePxbUZzKyKld7A50omievHbDz3qwUorvZJuz2xjpa1t4JOGdNGq+PAnC181gnqfmZ/PnPw7PNYdQjn0XrYkXMH2FT9Tet5ahHtSuS/WR+3kW8pWPv+OUIlfrmrhrtNJVuj6Aw9c2LXGMRgKR+S8JvL3oxwRSaJH+/YSE06vOh5iwm92jNxZymlSk1IDuAC4yIlO99xWwvEQ15NU0iNNpdg0ZTcXMiz8xUgi7lvWpWCoRiRo9QAgwgEzuAa/aw3doawBOsobNvabHLGOPiHIn+batPnP+P+0aZsKu1wh0OlgmfZgLa9Hk5R2gyYt6OxyUtcZra33PeFrEHQfVwDdrbCZbMiE+FCQ9iPuG5v5SrQAgTjK9hVKx56JdeBCWS190vzc+i3C0tVpnvQ3F1BA3WjTKnPF1rlHTl6LkzySld6lndbVl15FRXEiz/nJSAtVahVUuizNIbjeTQvKKAaDc+Q8L2bmGV827Uth0KbYk2QJ94TXQqFCf8ODf1eiRmQ01NXvXVTIeTC/qc7d/L4jG1cQglKZPX8VA7eDaFUihPBDdUGdBUhJCp7H4lgBkXbCmHjZNRfr8MNbsyTr+nwwkotAfD+I/rcmuG6toT25IHyCzg9umvIw2MCEPlVggzMDGSwMYlCJeIwLVst/O3/Gs7Ic+doo0XW2arFBaOVbdlXL57JjY7sdXbVbKhZf24bPwPBpI3D5oOeeL6YEM4o28LQg7fD0hGsqPzEXowd0ewBmzk8l8t68b
 TseTO0jg
 3YHACYFiqG0uIXiHMFmLAUuRQuU3XqBcYNNRsFrD7qXO4fS27gs1lieDy6cQ7ndZcg1KF00lbiGEi2wH8CH9eg817OcRQmymtJ/lRaMhRK4X2PSFYTRsfJyko1JrDYo2Au6XLOwYFyOIjYcgN3amR9HKnNPiaRiGTbASh7luTULZqL5/j2az7cY32RssakWjCiu5yEbED3S76otPUUc5ULjTpIOPPcpazGas0oYO1+GcJawOSFgYS7FlQ7/QaCmFZj7J4jNwaw05eVTOyEPBOh0ZMocIZrVcyJN2EZCkMVtBuz4J4OVesF/kFqKxPEtj7ZqHw9cDHRaKZpp3cd7Xt5zn6/TvU/asR+HuIWyZhn3jplPyv/cALeJph5G25wOndh11xmHww53+OAxLIKxUZqhWffMpHENmWW5p6hv6uXZ0AH+DB48DQ0LC3kqaVOPvfjYuqNrA1A++6wzv28QrUlz0IQei0GFvH6MmV3JU17Z6GRWuRXsbyW4n7Akjs4jdH0WWZl59/WeDqlF0mTuyWlBzy4ygiC3JFwaXYPu20MvRDiImPeTEIyH9deYenGVg9kErGL+H5zbXLFUcWlKBLbjV7nShg1/wvZmLLWIs01UY7yMNXZAvne05MFvXPegz3qhHs2qZYdIv7WxO+WokH03chi/H8WUWYu2xoxDmxyijdFUe4Z2nPedA1pnLUbwe6Cu8aAnp05JrXg6Ypl4O8OxatX3OaQGsdWyeyQoLuhGAhub11kIJmfth2L/hZVwF50jayryiWb++vbupJsIGjDVq6vDhmJqMZNoG12T7+M218qmfZjHFumlfvT09Y0GGTbfV1dS9Q19fgT3rgZUX4biQHXNNxYmck9Ekski5LDX89eCyiB5dk6mmikuirNVRH+Ira7n50G09EsX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 09, 2026 at 08:48:37AM +1000, Balbir Singh wrote:
>On 5/8/26 11:37, Wei Yang wrote:
>> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>> before return the pmd entry:
>> 
>>   * re-validate pmd entry
>>   * check PVMW_MIGRATION
>>   * check_pmd()
>>   * handle on pte level if split under us
>> 
>> But for device-private pmd, we just return after pmd_lock(). This may
>> lead to inproper situation.
>> 
>
>Could you elaborate a more on the improper situation?
>

For example, in remove_migration_pte() page_vma_mapped_walk() may return true
on a device-private entry even it is not a migration entry.

>> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
>> support device-private entries") by following the same pattern as
>> pmd_trans_huge() and pmd_is_migration_entry().
>> 
>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  mm/page_vma_mapped.c | 34 +++++++++++++++++++++++-----------
>>  1 file changed, 23 insertions(+), 11 deletions(-)
>> 
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index a4d52fdb3056..5d337ea43019 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -269,21 +269,33 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>  			spin_unlock(pvmw->ptl);
>>  			pvmw->ptl = NULL;
>>  		} else if (!pmd_present(pmde)) {
>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>> +			softleaf_t entry = softleaf_from_pmd(pmde);
>>  
>>  			if (softleaf_is_device_private(entry)) {
>>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> -				return true;
>> -			}
>> -
>> -			if ((pvmw->flags & PVMW_SYNC) &&
>> -			    thp_vma_suitable_order(vma, pvmw->address,
>> -						   PMD_ORDER) &&
>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>> +				entry = softleaf_from_pmd(*pvmw->pmd);
>> +
>> +				if (softleaf_is_device_private(entry)) {
>
>Do we need to check softleaf_is_device_private() twice, can't we hold the pmd
>lock and check once?
>

We discussed this code on [1], which spot the difference between
device-private pmd and the other two pmd case which re-validation after
pmd_lock().

Do check after pmd_lock() share the same pattern as the other two pmd entry
case. Also lock is heavy, check & lock & re-validate seems more friendly to
system. Otherwise we always need to grab lock.

And David suggest to use softleaf_is_device_private() again, [2]. 

>> +					if (pvmw->flags & PVMW_MIGRATION)
>> +						return not_found(pvmw);
>
>Double check, do we want to skip migration pte's (from remove_migration_pte)
>

Do you mean skip device-private entry?

remove_migration_pte() looks for migration entry, and tries to replace it.

The semantics above is: if it looks for migration entry, return not_found()
for device-private entry. Since device-private entry is not migration entry,
IIUC.

>> +					if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> +						return not_found(pvmw);
>> +					return true;
>> +				}
>>  
>> -			step_forward(pvmw, PMD_SIZE);
>> -			continue;
>> +				/* THP pmd was split under us: handle on pte level */
>> +				spin_unlock(pvmw->ptl);
>> +				pvmw->ptl = NULL;
>> +			} else {
>> +				if ((pvmw->flags & PVMW_SYNC) &&
>> +				    thp_vma_suitable_order(vma, pvmw->address,
>> +							   PMD_ORDER) &&
>> +				    (pvmw->nr_pages >= HPAGE_PMD_NR))
>> +					sync_with_folio_pmd_zap(mm, pvmw->pmd);
>> +
>> +				step_forward(pvmw, PMD_SIZE);
>> +				continue;
>> +			}
>>  		}
>>  		if (!map_pte(pvmw, &pmde, &ptl)) {
>>  			if (!pvmw->pte)
>
>
>How was this tested? Did you run hmm-tests? Is there a broken user space
>that caught the issue?

I didn't do device-private memory related test.

IIUC, device-private memory is device related. I don't have such devices.
Or we have other workaround to test it? Glad to know if so.

BTW, this fix is from pure code analysis and discussion. Maybe it would be
better to include you in the discussion first, then I could get more
background on it.

>
>Balbir Singh

[1]: https://lore.kernel.org/all/c71930ae-19d9-4b3b-a74d-3de3261c4d43@kernel.org/
[2]: https://lore.kernel.org/all/413feed4-6aab-43d9-b7e5-a9386fa79f4b@kernel.org/


-- 
Wei Yang
Help you, Help me

