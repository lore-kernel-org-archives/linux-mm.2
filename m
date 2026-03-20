Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163A31099B31
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DDD06B00CB; Fri, 20 Mar 2026 14:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5AD6B00CD; Fri, 20 Mar 2026 14:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F21A6B00CE; Fri, 20 Mar 2026 14:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18F1C6B00CB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:04:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B080D8B3AA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:04:49 +0000 (UTC)
X-FDA: 84567217098.18.B823FD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 13915A0009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:04:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QZ27rco1;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774029888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcQ0Sdq7MubbYaFxKqat7D7t1mE9+R5njCQKtCJ9D7I=;
	b=A+cnqw+UkY/sFnZBV1eSysU64TEgVvIyfIdTe0VLzw0NFtZZ6LzfndrL6PuhrQL8Pw0epr
	Wzzn5E6yXuMq+qUTii7MDAXzCFlTY+sOixoc3iekfDAIGfY5f88HToyx0gl6KJSSEWzxwh
	DJDUhIZ1gES8/oZaeHHI0ytvMVHkPB0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QZ27rco1;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774029888; a=rsa-sha256;
	cv=none;
	b=5/UBSpO6g6bqSIG/oYigsh7wlGM7zXmaCSpzz7M5rTTJaiwcushaBguibY+1JWfk2MmjlO
	4wmWicx0VveNXT7PwnmpJBZytNoYavL8a68UuXEwxfaWwq54mooEpgAmRPBZZwUqN/t+7O
	BmLaqe+ejbR1qF9mz5K6lsQJ+Rk9PxA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 557AC60128;
	Fri, 20 Mar 2026 18:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72E3C4CEF7;
	Fri, 20 Mar 2026 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774029887;
	bh=unEPL0G7kl0V7ExcXjxu9/JvZIzmQqH2o3lcKsyYewA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QZ27rco17AvaGnAfGjFv9fbjrnbNb/BfO9dekg+xvlPU72urVZEkIzQpheARdN7oX
	 Vs+NgmZp+tgmAcl/lUCr2UacLZ4Wxpf7npLq9DnOZT3HVnH5Yk4s4isbLmGzDB4MvF
	 oKCYhNOBcuUByFR8bTJ6KnUKKU5lIxVvKIpQfayYigwTI55RVHFL5ZQ4weHd7bGSqd
	 SygD3bA0+6GCLc0tbuV2U5dpwx1KjI2k0/7rKvD9CqKVfCZCWfWGU5abrkU1SRTj2u
	 4RkQ5sTSvE/IAINSi62Vr5lR00XN1qvOb+/BEVRBRspH02p8UXpvsau70MqGNd3rOq
	 T8IxDYaCzldog==
Date: Fri, 20 Mar 2026 18:04:40 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>, 
	Eero Kelly <eero.kelly@dfinity.org>, Andrew Battat <andrew.battat@dfinity.org>, 
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Message-ID: <def912db-ea7e-4cac-afa2-8e0b9c279549@lucifer.local>
References: <20260319190409.294523-1-ziy@nvidia.com>
 <6b087c27-a5d5-4f49-81e6-1204209b0c89@lucifer.local>
 <D60C0C65-11E3-4060-9295-B67F90E9D774@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D60C0C65-11E3-4060-9295-B67F90E9D774@nvidia.com>
X-Rspamd-Queue-Id: 13915A0009
X-Stat-Signature: ryhpmpyco4h893t7ztubcwch3i4tm145
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774029887-88738
X-HE-Meta: U2FsdGVkX19AycSQRmT/+EK/iwc9hfczxekbr0/imbd18/NkCKN2dq0mU7BopoO6n4gACgPRGnizQq088d+2V6wWUeTGp9eZSGzpuar9mjVbpjHPpBlQTR/4DFWCNHd4rpr+zUN4ngtnSOTCASx8QRlt3QeE6XIHzen7PUVm6CUzMDwzXeVziZJfBw3jq51lLhrnW7Lpoo3npDb4Y9cMbchzGEHZopJF2kPH8MHz5GTrh4Dkvs7iLpuQhX94bP56lOLASERXPJAIe3hJOKZMAyMldteNZ8XKTi4QWlyqB4vRQd46iCrjEdl2U2vpa+40rV2/aXWIofVQ/RTjKmgkyce++5VMeCWouqvtQOBDcitLPrM+Hl4SyjigqzLzVmd5pRtQcWepqTdwB4MCZ57y3A+zEvEdW9mzDnbIMMocBCl3m4nQyKvhIeG0l7P6POyaIK74ZTMtxRYdlP0PXGmd76wkeTdgZOAf1Q+TFTkp9SmJie3MS/NJWhgO2obIGI7E8SRK3dVBmgkpZF27WcVXgDnEBWUIhA+HqtQzgEgQtqCh4teMvRp6nglVKP+CFzYYLvYleS7Kt18kTDqz9vl7GF6yFE62rKB5IFIcl7F1bqTqQJfaJIst9hyKomhrrTBuYh6crEqa2R9imOh3Emfz8K/LtoppcAdhNd2gBFOpikJqv/WSy8LYYemMbzYnVzPigkuAivr54nAapmtrDUr/UNFRb4Mmoks2zhkYw/GamuJa351IUgeM0hPicNyr9Sh4QlMeez8UqJ0g39MbYYUBYK3EWzcflfbA5ECz7SIQJeSW7hwFGf+cXAVYLvxGZ2bHjyrrMW7tBymPEo5hqK9Pq/g8zIGvCJqoIiamvcjv9Av9hIK7oVXOWh1uzmM6gENSkP9hchi6O58S5vf3DcmPQhnj406DfHOF/nxfD6wWmbbRVcFj/mqXEfHwJygXJzEoEuPAp68XPIk9OFBusnO
 AadJ1LVj
 rR/Rywu+DLhUy1XoTOWzCA/NXImpjM9X6/2MmGuY/Sxonf+O/2XYrX643qbITIy87iMe24diHU3jWleeR/RMBpg1RXiAUzaG3OeryCEMsIP0vmU+cesytNmdKkcpwRFcGdL/j5IFnLTTZGBag9o5ddDnBicum3FopBnQi8Ja6UqEeO0jGT4GXUp1epu0aOu++ZW706qx9O0vWTQrMeirhpIdwaG6B2SCx2Et/fAhhhLYnhX18PJkcQgRsAoosZojPdknKNyzC+woyg7fnPxpS2EAH8I9UqjkOQcw56KU8PMGEXdPuWQgnBQWMeRzrMr79eTj0joxmA0sTexg6sun9YbuKMxyNzvVI+A7zHZvxC9qeb7XWzO4s8n/Q8B+IsGv97OKZ8dkheUkladIjhhSqmusyqz8xKaigozZm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 01:58:18PM -0400, Zi Yan wrote:
> On 20 Mar 2026, at 13:53, Lorenzo Stoakes (Oracle) wrote:
>
> > (-cc old email)
> >
> > On Thu, Mar 19, 2026 at 03:04:08PM -0400, Zi Yan wrote:
> >> The added folio_split_race_test is a modified C port of the race condition
> >> test from [1]. The test creates shmem huge pages, where the main thread
> >> punches holes in the shmem to cause folio_split() in the kernel and
> >> a set of 16 threads reads the shmem to cause filemap_get_entry() in the
> >> kernel. filemap_get_entry() reads the folio and xarray split by
> >> folio_split() locklessly. The original test[2] is written in rust and uses
> >> memfd (shmem backed). This C port uses shmem directly and use a single
> >> process.
> >>
> >> Note: the initial rust to C conversion is done by Cursor.
> >>
> >> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/ [1]
> >> Link: https://github.com/dfinity/thp-madv-remove-test [2]
> >> Signed-off-by: Bas van Dijk <bas@dfinity.org>
> >> Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >
> > No .gitignore entry? :)
> >
> > (Just saw it flag up locally in git status)
> >
> > Linus says don't remove, but he doesn't say don't add :P
>
> I did not know about that. The fixup is below. Thank you for pointing it out.

To be clear I'm referencing this re: the .gitignore _removals_ ;)

https://lore.kernel.org/linux-mm/CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com/

Thanks! :)

>
> From bd164a7090c0e8b6e3013502c64c161214e38714 Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Fri, 20 Mar 2026 13:56:04 -0400
> Subject: [PATCH] git: add generated binary into gitignore
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  tools/testing/selftests/mm/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index 83ad9454dd9d1..b0c30c5ee9e30 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -61,3 +61,4 @@ guard-regions
>  merge
>  prctl_thp_disable
>  rmap
> +folio_split_race_test
> --
> 2.51.0
>
>
>
> Best Regards,
> Yan, Zi

Cheers, Lorenzo

