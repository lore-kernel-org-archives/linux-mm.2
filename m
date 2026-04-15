Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0A7F419A0
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1410B6B0005; Wed, 15 Apr 2026 08:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119696B0088; Wed, 15 Apr 2026 08:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02EE16B0093; Wed, 15 Apr 2026 08:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E86C56B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:52:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75B328BA09
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:52:49 +0000 (UTC)
X-FDA: 84660779658.27.DF25BA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC83C100003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:52:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mG9dgdzG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776257567; a=rsa-sha256;
	cv=none;
	b=gTCmEChmHevqH+NH6n4NBT+v3P8Ejov0Zdcy5EGd9xDHQdHA4GVG7YSBGIqyrAHQC5fohX
	hT2jvP/nnj2xupQMz03Kl7Oy4Kbp6tq98RYWTnbG++FNMBP73UOWTl+C3bNRoZoCeo2zmV
	VDjGq2NN28cFThzbXDWkf+ODDMMabOM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mG9dgdzG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776257567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMP0HGID4JEWG409oHNwym3bH2jRbyJwu4CCwe9DgOc=;
	b=oCPu2uyFy+winjGUQRYwvKZ5gbuXzc+2R5MMOqqV5SB2eQs2MvGGzTnQV4f1D6n5pqPkuB
	FI6z2Eg1uYJbuj9FxKcBHhFnoZkBFX9r/DergiAxz4EH7II/DomQJFcUvsRuVc92WUsWJe
	6UeDOaetpDhIZJ4DhOBL88/1xQpkPl0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F389A60127;
	Wed, 15 Apr 2026 12:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0638C19424;
	Wed, 15 Apr 2026 12:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776257566;
	bh=gq7KXSOC5+mZVKjUhfqoFacHhD99oZi0rh5YFtrpo1c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mG9dgdzGd/EoKCzFJ6z+hRUX35HLLa/wSjkfuyXACrQ/GsjULudK1OJWQTvjxkfy/
	 t+znJniDnUjEHtF+f6Ht3RgCs/OxTSZ7oS4zv1jwM1gPmavafQG8VFPrbTuT4NY9jy
	 M6kSMU1NwDZltfD2DRCBMzqCmO65Li8zsdcf3uK0nTOt98pjqsQoUVyB7kVQ3GjstK
	 WQNFQRL30k5lcN7lJ7I/3q9T6WExQrrhN4r1/lyQBZLK0RMecPVk8argUVcoZlqeth
	 /CGZTyXZsdJ/D/C3WAx4sQ4H9I1cHcRh1RkjtuugECI58uLGF988ppgcBKmdpGHhuM
	 sObWb/KlniUzw==
Message-ID: <e5fcb3ba-6494-4295-a8a7-191c3ea0aae4@kernel.org>
Date: Wed, 15 Apr 2026 14:52:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] procfs: add contpte info into smaps
To: Anatoly Stepanov <stepanov.anatoly@huawei.com>, willy@infradead.org,
 akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 wangkefeng.wang@huawei.com, yanquanmin1@huawei.com, zuoze1@huawei.com,
 artem.kuzin@huawei.com, gutierrez.asier@huawei-partners.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
 <20260415192853.3470423-2-stepanov.anatoly@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260415192853.3470423-2-stepanov.anatoly@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC83C100003
X-Stat-Signature: aoaxjwy9hfbkptd8xh9ni38wcqziotwd
X-Rspam-User: 
X-HE-Tag: 1776257567-180323
X-HE-Meta: U2FsdGVkX18qfkHIMXdKKMqs5BQHaFd900IlKEDWwhHrW6iN3vJIhUcWmCl0BfoHiFYTUgEjzOLefp1bi2laWEpYflhUaGSd2uzsGQt3JdPDRqjQcsurzNlC8v3NifCITYuZcrgycKnm2pCEasknGScZF0yGBn9zhjmG7GXBEDRA3YEE3kwfCLaQqUWU+UWbZ62qiJpzqU5YvBmMtSGZcHE6l02MyvtURE1nLy394HH3n0JMinPsMjFiui+anwnHsNivDk1E2MBSIs4R0mD2dvxuB7t82RgJ7BzZYX6t6cwtxyYymKIrACUXp+KwG5SArwMRdauXKfJ5cEpoo1ispJN7xDET9lU4anl6rt+YnMuTcDTQYK3WnMFKZIknPFWjxE0GCGOSIMWNrpefVsPw/tvrr1+mkOfx7MNs6NW6FKYVqJYkDHoR0Fq6PDXEVL2zdmcYzR1bWOCnzjulOF82zUr9BQv8px9fl4EEl8V/QzdpaKfWaXjHebPEpKfTwoaDhwK+vSEws1nzynAz8LtDEYK9PL8+HCIJSf++8UoII4ZJyHiS4w79zSbuwUcum0ntoLVjPNnYvnKILqHkOmie2gMiBy14xKpdiE+b9JZJsuvGF7DkosM1Hhr5MN1/Ll3fC8TW7EpiMvLHu41KE5vw5WYepNlAajS855GQu1vVxP5WC2h/JwaEAT/rGXgnkUNvtQmPvF0xjicR88mcykkCdBRB3L/O4R+Pp6HMS6poQeA/ZmvzeenxnyI7miztWKibtJczU8f/BhxR3y7m8oeitEXeW4+pzFA/GIpP310jOI23gfHyjdk0Ef3Xcy19JtlgxyTAeK6rqCCi6YOQsRaMx6EOJCU1uH8wk+aFA3A5y6eZx9LKT5sVii8kxVtL69BhODkCfWeD/M4VrjeGyAfVRzUnyr0WoyDs2RG43xsQ9u0EmIry/0ARv4lZ6qFrpErSQ7NDgGeScPPpjnQKDUx
 S81Xrb0E
 lJXuCgX1BL9UQnRX4i50C35tSAWudtXfZVbj1nqKAX/uMMtuDuXcEgn4Ou/2JpJJHJbajPW9R4SWLPRa3u55yfu0/6SdP9WluAHzddHwLnk6CagtH9xGJt1JWFOhZ+MhK+L2U9nZkLf14A/s+PtnkTwUTjxaQO8DBk4UKApe5c0RhZ8oCTyRiWDKd53gSyb3Uqf5FMUOgTaYIRFkHzePgyWb6NTMM7ZlS43A2jDiZ4LycGwN0+65Cxh7aTvbq88fv2Jp2AAwhWWt7CgjZSkymi1El8asVIlzJq8S6OaRITucsheNubuQ95r0QPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +#ifndef pte_cont
> +#define pte_cont(pte) (false)
> +#endif
> +
>  static void smaps_pte_entry(pte_t *pte, unsigned long addr,
>  		struct mm_walk *walk)
>  {
> @@ -1023,12 +1030,14 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
>  	bool locked = !!(vma->vm_flags & VM_LOCKED);
>  	struct page *page = NULL;
>  	bool present = false, young = false, dirty = false;
> +	bool cont = false;
>  	pte_t ptent = ptep_get(pte);
>  
>  	if (pte_present(ptent)) {
>  		page = vm_normal_page(vma, addr, ptent);
>  		young = pte_young(ptent);
>  		dirty = pte_dirty(ptent);
> +		cont = pte_cont(ptent);

No, none of this low-level pte_cont fiddling in common code.

We have folio_pte_batch() to batch over folio ptes. And we want some
better page table walkers to just do the batching for us:

https://lore.kernel.org/r/20260412174244.133715-1-osalvador@suse.de

-- 
Cheers,

David

