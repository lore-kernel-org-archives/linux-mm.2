Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21064CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 04:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DEE8E0003; Mon, 29 Sep 2025 00:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0766D8E0002; Mon, 29 Sep 2025 00:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5458E0003; Mon, 29 Sep 2025 00:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC18F8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 00:44:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FA3B84724
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:44:25 +0000 (UTC)
X-FDA: 83941046490.30.F1C2024
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3D4E6140002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:44:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759121063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9km3TTOsFYsfDyai+3IcmTkqC5YN4/2Z0p8DX5JCU2k=;
	b=aIby1RtztHPc55CPan87IOqJrjEvAkHcjlZCPdD5Czu6bdK6DoDLcG375d2oieANZoax2k
	N9tEq5O094hbfDUB/FV5Xcb3W/pjJwKVbQ6s4KioSInQ45yvXmgqnw23Rpjsvnf5gtdu2B
	EFoMY1ywtUoKbE4gCVOUCBD7Zivl8yw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759121063; a=rsa-sha256;
	cv=none;
	b=tN3vky4993q8dH4mhGewvNIcpgq+6msLqh4QuKs3DZ+b0eyMCPSGLBxilyObWYFUktXFNv
	KEr7wzFDxAbuo6TZqBeZMW9qNDMLw+KjBRD79E/1NFfEUHIVt3UcsOzQViSY1TbfpEE5c0
	04Y/FLH0VcKmcrJC7LjHxIn1eES1UHk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AA0C150C;
	Sun, 28 Sep 2025 21:44:14 -0700 (PDT)
Received: from [10.164.18.53] (MacBook-Pro.blr.arm.com [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37BD83F66E;
	Sun, 28 Sep 2025 21:44:13 -0700 (PDT)
Message-ID: <2065263d-a2c0-437e-a096-695c6d17f97a@arm.com>
Date: Mon, 29 Sep 2025 10:14:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/rmap: fix soft-dirty bit loss when remapping
 zero-filled mTHP subpage to shared zeropage
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 ryan.roberts@arm.com, npache@redhat.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, usamaarif642@gmail.com,
 yuzhao@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, stable@vger.kernel.org
References: <20250928044855.76359-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250928044855.76359-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D4E6140002
X-Stat-Signature: mk86tj5fdjsx56aikh75owrfjooo4w4k
X-Rspam-User: 
X-HE-Tag: 1759121063-747084
X-HE-Meta: U2FsdGVkX1+WvNbNpAoAq99o451Fu+uW9x/2ITF7/Q9lxm34hsRGKYZLduLCyqwyVcoFgAogghYUW/hFIBuVCi7OBqgGZai9Gf5CGBf6s8l9JiYW1Ea+1lVXMp3JhfQjyMVSptxYUqg8cVU+w2PjeDQFlufmndfcwjXXHIEkMPvDFX8+L/c1L2b95b5aSh8if9IyccISdewaguVKLuXvMaSt66ywJ9hcNRWqfmup3Ja3OuKMxVSx6ob081Ehzim7UOxYdriTA6PadLSC13SqnWmI9HqtNHJr2hK8Aaa5+RBCQSCK4ASd/Dgk0z+0s70Zz3q3IanvkdVJi2f6d4cP5+ORhmGVHgvhZg18+PqdRZmAAPyzFVsuAzaUq9xYaSYX4Qte0i92wNrvihd7EjAohkcxwjCDZijPV7uMpSJaTrA6puy9H2y+RPAGYxsY4oS922NhFd9m9wrxX1ZUWx8g5E+3v/Aa6CwKJFlDi08qE8rrc+PXuWg0k7IEdQjhdmT0Mu1LzhNKVTBfDtU51nlK8j0+jk4v21hvkdmAINSGOtM7jLv7xR/KFweGKGcUfH/oWWI45mJQxWspearE3iSMyqHutsjLwnOKBCOlyvuCRdhdTPJLPsMJQB00ODk/yFrGcpis0cHdmFCiG2bvUD+8yTUVNFZ9bfLF0d7iJvN/5dRgAgI43uHmPhQ7PyEsC7iq/UsfiORawvrwaegnDecexWZWZu7Jnf0FQazN/KGBS5Y1Yh87ep10G/uMrfQ3lsMLNqokuT4hmCJGFUQ9AFZOJs7dT99ey6UNfYocW0OlmtAiE37PelK3yLpEbEzpoVtgJppgOzpcJDm4KJ/+uUrZqyBC8pFllHjcEhF1hNTdBbJWp7vgcEmwqOw2AGb1vI+573Qgl9v4Qjjc8XXC75lmuQYFPwprgaPzjXjA4BVVPGc9VptdpNjizQD0h0gFUZ5TqAmXmhZf95QoctCOuJQ
 Fygs1LeD
 tmhugu2XSy5TagLj5+IxSvmNZIVguWpu3UE4UD4rZpmw6p+6QnOnkGu68HLewq3NBlB4k8EMwqgoexQuCIMqVauMAobXQy1LhnAYIIix8GePIZ0tclkD/Dvzrs+yK9mkyXzGod0ImwwDVjeFiorVsiX0qJ7cAYX2fUiCX7irK+XpQXj8l7jkrywwgA48ElyIzUjpy06RWrxe7DfrxU4gUhyuNkIZC5X2gTmoIZIiHiQ1hb/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 28/09/25 10:18 am, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> When splitting an mTHP and replacing a zero-filled subpage with the shared
> zeropage, try_to_map_unused_to_zeropage() currently drops the soft-dirty
> bit.
>
> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
> incremental snapshots, losing this bit means modified pages are missed,
> leading to inconsistent memory state after restore.
>
> Preserve the soft-dirty bit from the old PTE when creating the zeropage
> mapping to ensure modified pages are correctly tracked.
>
> Cc: <stable@vger.kernel.org>
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   mm/migrate.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ce83c2c3c287..bf364ba07a3f 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -322,6 +322,10 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   
>   	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>   					pvmw->vma->vm_page_prot));
> +
> +	if (pte_swp_soft_dirty(ptep_get(pvmw->pte)))
> +		newpte = pte_mksoft_dirty(newpte);
> +
>   	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>   
>   	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));

I think this should work.

You can pass old_pte = ptep_get(pvmw->pte) to this function to avoid calling ptep_get()
multiple times.


