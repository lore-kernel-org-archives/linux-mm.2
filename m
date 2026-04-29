Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 504EFFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 06:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00726B0005; Wed, 29 Apr 2026 02:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1926B008C; Wed, 29 Apr 2026 02:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 879126B0092; Wed, 29 Apr 2026 02:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 780AE6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:55:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1081C14070D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:55:15 +0000 (UTC)
X-FDA: 84710681790.03.F372B98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 52CFD40006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:55:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hdJ6iT97;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777445713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BG9p2oeSFQ+mU5uxkb+qgOLOXHTa0hoWJb4E/7JpMcQ=;
	b=3zbzyHUsNkeXDLDc5X5vO/vpe/jaCztc6r6xT0R9A+QfUHQT28FwfkIeH02gdMDSvJ8UV6
	lVvXl8k6yRKfZR7U5Nv7RYhchPcpxxorpA3klUBL31shY66eEJPuIxSX7peOQCbCc3OcHJ
	Cvi1+WSpg7XyD+g/3BFjWIkwMjMKUXk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hdJ6iT97;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777445713; a=rsa-sha256;
	cv=none;
	b=tno0UhuByDIgXKsHxGe8vlPUNw7bqP/BEz/kwCP/W1rvLEUnR1H1v6JAjcQOSjcW1f/NRP
	/hPUWxsuP13WFRa66LACglBWp8uQ4hXE1Lop7OITBkz/HFOKTs0GVlI7h4f4KCsGVIx4Fq
	a8ciAkq1Jy99GKVmZjcVbu9lvID/X14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF4DF61143;
	Wed, 29 Apr 2026 06:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7199C19425;
	Wed, 29 Apr 2026 06:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777445712;
	bh=S//ZUSDHXmEXXFLqbYSckwo7GVZWx42vw8SW7eXhN1g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hdJ6iT97bLNPBFWtH7fyQDqnSSThZ8IyvoDMj9RRO+SjLhEOWyOrXQIyrK/nSp7Vu
	 v8eu7ViZW88Linf8eWsiZ0DwvDr9bWCESSMSvikT1toWu1DlD40c6XJqEhzomSK/Zn
	 sxW+GA8D0hb4phFs5qo4L91sT0Ac2rt5YC1F5KNuqP5tnxAwXo+l3nA8IF4g6T6m2t
	 nef0RtLVov3uuaFnZC5jVQ1k6I937QkQZTHvJFEKWNOLEK48xwc+aKttF/l2LZVFVl
	 JfpXoP9o1KIYYTVlywqxlAeF++L44oCNh+Vrgur+L6abO3AU/W+gCCG0R/sO7OK2+4
	 Q5aSR3kG5KfJQ==
Message-ID: <413feed4-6aab-43d9-b7e5-a9386fa79f4b@kernel.org>
Date: Wed, 29 Apr 2026 08:55:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: return true if
 split_huge_pmd_locked() split PMD to migration entry
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, Gavin Guo <gavinguo@igalia.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
 <20260415010839.20124-2-richard.weiyang@gmail.com>
 <79e164a2-47ce-4a02-82f5-164515760b6d@kernel.org>
 <20260426091957.a227zxgkqapibtud@master>
 <c71930ae-19d9-4b3b-a74d-3de3261c4d43@kernel.org>
 <20260429024913.iepoi7cit3xnwca2@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429024913.iepoi7cit3xnwca2@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52CFD40006
X-Stat-Signature: ohuuupw9yxoi3ii5dcy5k8aa94uebah6
X-HE-Tag: 1777445713-705351
X-HE-Meta: U2FsdGVkX19wPBoBk+dDrshfkEhgx5o5iFrCfewgrXF3W43j8G+qKZltjXAi7t4U8cmZHpb4GlI/wub1/Z4hGihHxr60GW5PyfNNKSoRmkVxjLpD6pFc9qDLSL+T9qBTBP1t1oRj7pNF3ubsCA1c9uqbEhxLe46BTndGgbiwWOX+Khp4TedNiZx2kxXf1mUWNdC3RRXHD3FweAG8UKrfcWXBCG3vvxVvQ+R94tnJS/tb0MPOPzh6Xvwl7KojMuYnSTC6XCbBzYNuZMZzzzRHhjTm52acp3wLjM+NSkGuKA2tuWLs1LJqr5KO/ZE+KJFZ6Q4YSIj37ogHdKHw6LC5e7M1NfBlc0lvy3f4cMf0sgklI2XariMSWjpCnXT3CykqBeaWB1yxaAEyTWdgiQrNdS46UWpSzchx4dtfw47adMBoLEy8jOIY0N6B7ffhQLzIIbzjrMcdVSya02AjiT/pPjE2Rm/2g/1y9eudkMZfqr+jYTfJK4QE65iBsJkmpllNbXzLI2v+XHy27RkNhYFxYGGbAfAk/HxFRIcX859oj9Q9kB9+CYqRxLjdleT44/ZPDG96EWblu4IrnggB2M/KLCm3xwwgBWzJm+/RjyQdzM7idGxVWnjTE1Sq9itzZLX/t5AFI6H/qfcSWBndb6D2AHafmzqqQkQTAUnc+hmJOgD26NATSlSga5sLpBnOATYf7oWOFwp0+ME5YxcurCI25zR4Ip6PhCEqnZkqOO71WJ0u8A5DoIh/UHEC8UG4pSOFzzysOKozXYOglgUPQU2nmkcGZ+8K8fAQQvtl3NsDpQvwy/WdsANhNIrX9H037iEWmOBgmk7U9DyxUrRYdtR6ufrIOB8dwOIsbbGadjFASKKt5gsbfHmiYv4uuDw2rNcxQR7O4eg2P09p+IxLbhFP9/7evk0HeGa0d3TdUHx+gi1VZf+wHCouDTG88MM3xTf0NEjZnfPXdJiKBj4Pmy6
 xvPncFfj
 IbPT3P6qz4xedSZds3h3mQ8MsT3ZJUI6YIKXRI5YjuWP5soRPHsVVTdby2GxTI5qSQUKttqRcwRn7IhOoki8Fwg2vzxSeVxo+hwgnAArynbnu0Zc95wqQoR6Ps2doMdFGEwz1wzbsXi9HoZJRVTTIe6DJBtcmTvCnayu+Xdx1qH97qP+WgjCvsWdcEJ4wkKaBKL8mFi/EF1uq23UdFHJWyHYInwDzpm+L4hRCi7dfuHhSeGZ7KE0VgdldVwiNqScdlMOn1q5vgdomftkKXBNfUfeiZyhZ83wqSq4IM1rh3saPJgUlqBN0ozgGSYDh4moEBqNCn+nQlMrxQfPcmP1HybkCjYvukVnfShmncmIA4RzK7z+TJHGRBrba1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 04:49, Wei Yang wrote:
> On Tue, Apr 28, 2026 at 10:24:42AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/26/26 11:19, Wei Yang wrote:
>>>
>>> Will adjust related places.
>>>
>>>
>>> Got it.
>>>
>>>
>>> Here is my understanding.
>>>
>>> We get here when page_vma_mapped_walk() touch a pmd entry, with three cases:
>>>
>>>   * pmd_trans_huge()
>>>   * pmd_is_migration_entry()
>>>   * pmd_is_device_private_entry()
>>>
>>> For the first two cases, we grab pmd_lock() and then check the condition is
>>> still valid before return. But for case 3, after grab pmd_lock(), it return
>>> directly.
>>>
>>> This may give chance for another thread to split pmd_is_device_private_entry()
>>> to pte mapped, IIUC. For this case, we should restart the walk here.
>>
>>
>> So what you are saying is that we should re-validate in page_vma_mapped_walk()
>> that we indeed still have a device-private entry after grabbing the lock?
>>
>> That's what we do in map_pte() through pmd_same() check.
>>
>> Likely we should apply the same model here!
>>
> 
> Below is my proposed change:
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index a4d52fdb3056..6e915d35ae54 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -273,17 +273,21 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  
>  			if (softleaf_is_device_private(entry)) {
>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> -				return true;
> +				if (pmd_same(pmde, pmdp_get_lockless(pvmw->pmd)))
> +					return true;

As we have a softleaf entry, I assume we wouldn't expect to get any other bits
(access/dirty) set until we grab the lock. Verifying
softleaf_is_device_private() again would be better cleaner, though.

But really, I do wonder if we should just have a "goto retry" back to the "pmde
= pmdp_get_lockless(pvmw->pmd);" instead?


And now I wonder why we don't have a check_pmd() handling in there? :/

Should we check for the pfn here?

> +				/* THP pmd was split under us: handle on pte level */
> +				spin_unlock(pvmw->ptl);
> +				pvmw->ptl = NULL;



> +			} else {
> +				if ((pvmw->flags & PVMW_SYNC) &&
> +				    thp_vma_suitable_order(vma, pvmw->address,
> +							   PMD_ORDER) &&
> +				    (pvmw->nr_pages >= HPAGE_PMD_NR))
> +					sync_with_folio_pmd_zap(mm, pvmw->pmd);
> +
> +				step_forward(pvmw, PMD_SIZE);
> +				continue;
>  			}
> -
> -			if ((pvmw->flags & PVMW_SYNC) &&
> -			    thp_vma_suitable_order(vma, pvmw->address,
> -						   PMD_ORDER) &&
> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
> -
> -			step_forward(pvmw, PMD_SIZE);
> -			continue;
>  		}
>  		if (!map_pte(pvmw, &pmde, &ptl)) {
>  			if (!pvmw->pte)
> 
> After this, we could simplify the logic in try_to_migrate_one() as:
> 
> @@ -2471,14 +2471,10 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>                                  * so we can detect this scenario and properly
>                                  * abort the walk.
>                                  */
> -                               if (split_huge_pmd_locked(vma, pvmw.address,
> -                                                     pvmw.pmd, true)) {
> -                                       page_vma_mapped_walk_done(&pvmw);
> -                                       break;
> -                               }
> -                               flags &= ~TTU_SPLIT_HUGE_PMD;
> -                               page_vma_mapped_walk_restart(&pvmw);
> -                               continue;
> +                               ret = split_huge_pmd_locked(vma, pvmw.address,
> +                                                     pvmw.pmd, true);
> +                               page_vma_mapped_walk_done(&pvmw);
> +                               break;
>                         }

Right. But just to be clear: Let's split the page_vma_mapped_walk() validation
(which looks like a bugfix to me) from the other optimization.

-- 
Cheers,

David

