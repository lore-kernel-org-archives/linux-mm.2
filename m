Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7179FD88DD
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 02:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C526B0089; Tue, 10 Mar 2026 22:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0400B6B008A; Tue, 10 Mar 2026 22:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5AD66B008C; Tue, 10 Mar 2026 22:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C27676B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:23:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4489F13ADEC
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:23:51 +0000 (UTC)
X-FDA: 84532186662.24.311F8DE
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F73D4000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:23:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mHBNcdJh;
	spf=pass (imf07.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773195829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMltWOW0k43bLww3FIPfAmLCchQbUS14K7m8AEoPvKs=;
	b=OTGOQiCSMuUkX/HW2ZuZJrBpNrBVSWwMDWTSqBFPctul8rgSYeHYKGBZxvfMPo9AfCmgtp
	iU3fzR46vccbJCKio+nQf3eif1j6kc1psSaL+6OWueQnH8cUzfWe0bFt51Lpo2u50GGOxP
	65YLALQpUlDcM2MLdLcBFnMBXUmv4cE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mHBNcdJh;
	spf=pass (imf07.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773195829; a=rsa-sha256;
	cv=none;
	b=SLpllZbIVdc8C0Ez6a3XeQIXUzWPzVKalgqkmwadMHQ7kK6xLKVJ6Mg6dsymHEhYLN5TfQ
	fptDflHPdQH2EVhWyF5KICjP07YPQ8Iwjb81SwBCoetAITFBgyUCQt9jsCNhb4YOH6vt6w
	r8RXeMC5hFLyVUMoyzElGe71aRw05WA=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3591cc98871so6131292a91.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773195828; x=1773800628; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MMltWOW0k43bLww3FIPfAmLCchQbUS14K7m8AEoPvKs=;
        b=mHBNcdJhzvbOo3N3I9Df0boVrSgxkolnJDr1359GpnGfPBpDLFwRHxpMGEdtpMm4Zt
         3sP/1vi4swru8GLTgd/zpN6ER4i5XHxYfWuECX2mBWa/vvp26QdCJBIkgGuQLfwkS7CV
         Gft8TykemwsycCZcfS0pRlJhzeSB8pRxR4+f7j9INdpWci48AE2qawAFEZD62Xrwq4yj
         V85UkjrS+N0jYkdMNySqXA9xYK7PkcR30CrbEm79754TtWjhAsNkp50s5Eibw7YDs4D1
         BEDLAIUhSMTylUyLx+y2txT/GkPOK7aCpWn9krEhKIjRRDsrtbdGolvzR4o5EFU5mIU2
         gWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773195828; x=1773800628;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MMltWOW0k43bLww3FIPfAmLCchQbUS14K7m8AEoPvKs=;
        b=CBkd6L40+zl9PQA7SSN7pOkwNg4qMuwPpKoAW5FwSICfzPLC+Kr7UAkIN74HWMANCd
         OywAd7aS/fxGZhJqBLGUHz1E3PdcXdCjoHh1tokFGJ0ODcy5/YT4FT0nKTY6PjJi1RTg
         OQ/wt1/VGKxvSoBz5YRQnTUPHPW43XcrNLklCsMKAB+JBbzQZe2f0y0ZLMoTEW9HBhnX
         hJ5Msm7fmh0qYhTuW0mzUtJGs1KPFblGqxOCq5cUDIWW+1V0mVUUMBW50bjUTpANmYjh
         mgSBOL4cDoyHzraW3Zv22Ih0NzbNJvNn0rHUs2yqiRKbLlwgJJShNdgoPofsygNY5LhC
         H1dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWo90v/MGOFZfNx4NuW80zbVyW7c3mh3x4gD6uflqPRFvjog1MYd+tkUafcyQX80vpY4irfMq0cyA==@kvack.org
X-Gm-Message-State: AOJu0YzzdxrfRqlKBlj3bEg2sFtOcg3/tQ7yYPQSRr5A3+MWveIJhCO7
	XtBUrrsXH3F9FVbeV6chC2IOVen0zvZrS9Nq7uvcDdQh3YDz6Kjjaj8QFr8L4vbI
X-Gm-Gg: ATEYQzz8QkYZb6kQBScbpthGJYg+CSnIIp6+JYvIXfSD/4pmTELlM9/ReLisACQ3B8Z
	SZ3p/RnvcljtrHt1s6vLgJvqMaemcAB5zV8tlVMdQ2n1vJHhBmWwi6hBwU5+B+sMov+7BJbzQP4
	VaMAgworaj99JZ8ltK+O7FLH6Og8bscYOhxGJXbR+1B9hReof91tP4hD0bwAzwuEPMjc3RzMOo7
	/TL1slCbn6/nyRQRDITfkaTV/fED3jkJ0SSYhR5T7eF/vDK4XVxb5uSiotA98L5O8a5H+c9txl6
	fVLxSnAPDIpVKFRY6ZkJ2vOrS0OnDB8uLTbOIAIqSaef2pgPvBrAtG7hVf7dnSZVk0bE9WzTbpf
	/vijN+783/i5LYZ7plnc0XdPfiyrrHSAnLepbwTG9Idie636RHp+BfBgV+wKejkn7o63IXiCWBp
	SaXnQ+Ymtv/c0jYPURsxOcKg==
X-Received: by 2002:a17:90a:c884:b0:354:c593:b1a8 with SMTP id 98e67ed59e1d1-35a0124b91cmr932718a91.13.1773195828309;
        Tue, 10 Mar 2026 19:23:48 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359fc97356dsm1413731a91.8.2026.03.10.19.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 19:23:47 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Alex Williamson <alex@shazbot.org>
Cc: linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Christophe Leroy <chleroy@kernel.org>, linux-mm@kvack.org, kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>, alex@shazbot.org
Subject: Re: [PATCH v2 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
In-Reply-To: <20260309154637.3abf76af@shazbot.org>
Date: Wed, 11 Mar 2026 07:50:24 +0530
Message-ID: <1phrumxj.ritesh.list@gmail.com>
References: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com> <20260309154637.3abf76af@shazbot.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F73D4000A
X-Stat-Signature: 5nf8ycy4exf8jymqbrf5axrfmig6yocn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773195829-506941
X-HE-Meta: U2FsdGVkX1+OBZnK9sxFziqID2ojFC0GquFNuMNTcWgNRvu+64P1YqhcI+EDA3gt2QUsVwK4t+rWtg2HPYfCqU6zgI0+16QOhLSoZV0LfNS+Nw+yqVxTCckS0RB6JAz68ngSljOKThFBivedSZ16qRQazp7pPfn1G8PFvhkTxg++ddJ5MBkzOjsFLu7XtzPjuUzl0dMYjoluP91IyCfwuh+5ReTPveZJ85MSmKvhB3P7dZ61V8q8dHz6FJtOO3Q6QgOGbuPrjIqAnYwxCBcI63oaB1W6IKhMG/wXfMAJg/fpxMliJsjbLouVXwnw/eCB67Ek2ws5dJrHBkRmsvw0kkJTrvN6xiODNyD/wcV/11AxqctFS+flrQD9mYTylzBf2gtWUmfWSOxU4tPm217t67g08pAPUhSMc1/HEoSEfEO6SqJuXj8bgfp9FwBK0DZybAOC04l8zfiu6KiDDYHxzivL8ql/ESKwBcvfSPlWKBsCKQRjSf9KCret0OZFBRSY5QLyRNQvP1Gqk0kEIk95yL7gNic+/HDMY6uUwMxVWiqVIJeT1pErXRmHLmbR1hUejvqBzeQPdBk7o1aegUj+P6rKt3LgN9PUCrgwVZuSDWcU0n/wD0wgDXjM+mnXyOXXOJTyM+xPN6h4gRsEl80z/zlGKHUAqUWJF5ewgphfMf2V6y1RePVaACPFbOgjOmhwT/RFYsUQbiVlbQ4HNq8ECe3IrtNTfOds4YJypN3+6HA0xMIhRx8kLirUSdBwu6Ygl6fJY1mDTL0Kco6YKbax6AT1rzaAJIK2yTmdAUPcMSzjJF2IH1fdtf5lmkzBaaFacxI+ER8dcGRVQGSv/vfKJB3FN0sV7GFGwUC5LpDzYDVhSR4LXzCzV2MrbMcsZ/1dJqEbSIuiFUyl2Omwi27PEdr2iBfcTLuNQWbm0oAMI78in4rfYntfuH0i5tZAmu47g1UB3iisX7CAjujmkTQ
 5WyoFvcw
 ba7qPGoPHpMh9EuHCPxmlrzhrsjeobeTvY4ernqME6eYGkg0eAZ0/5H6vETBL2RnSG8CHQ45XFRBfLnRrW9Eh7cxXTHxdLQRviBjBIygL7kKrqPDPRWmn5/W6M0aocvvlzIl3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alex Williamson <alex@shazbot.org> writes:

> Subject prefix should be "vfio/pci:".
>
> On Mon,  9 Mar 2026 18:08:37 +0530
> "Ritesh Harjani (IBM)" <ritesh.list@gmail.com> wrote:
>
>> Architectures like PowerPC uses runtime defined values for
>
> s/uses/use/
>

@maddy can we wrap this in while applying?
Otherwise - please let me know and I can re-send another version.

>> PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
>> at runtime using kernel cmdline. So the pXd_index_size is not known at
>> compile time. Without this fix, when we add huge pfn support on powerpc
>> in the next patch, vfio_pci_core driver compilation can fail with the
>> following errors.
>> 
>>   CC [M]  drivers/vfio/vfio_main.o
>>   CC [M]  drivers/vfio/group.o
>>   CC [M]  drivers/vfio/container.o
>>   CC [M]  drivers/vfio/virqfd.o
>>   CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
>>   CC [M]  drivers/vfio/pci/vfio_pci_core.o
>>   CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
>>   CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
>>   CC [M]  drivers/vfio/pci/vfio_pci_config.o
>>   CC [M]  drivers/vfio/pci/vfio_pci.o
>>   AR      kernel/built-in.a
>> ../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
>> ../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
>>  1678 |         case PMD_ORDER:
>>       |         ^~~~
>> ../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
>>  1682 |         case PUD_ORDER:
>>       |         ^~~~
>> make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
>> make[6]: *** Waiting for unfinished jobs....
>> make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
>> make[5]: *** Waiting for unfinished jobs....
>> make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
>> make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2
>> 
>> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>> v1 -> v2:
>> 1. addressed review comments from Christophe [1]
>> [1]: https://lore.kernel.org/linuxppc-dev/0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com/
>> 
>>  drivers/vfio/pci/vfio_pci_core.c | 19 +++++++------------
>>  1 file changed, 7 insertions(+), 12 deletions(-)
>> 
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index d43745fe4c84..0967307235b8 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1670,21 +1670,16 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
>>  	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
>>  		return VM_FAULT_SIGBUS;
>> 
>> -	switch (order) {
>> -	case 0:
>> +	if (!order)
>>  		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
>> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>> -	case PMD_ORDER:
>> +
>> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
>>  		return vmf_insert_pfn_pmd(vmf, pfn, false);
>> -#endif
>> -#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
>> -	case PUD_ORDER:
>> +
>> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
>>  		return vmf_insert_pfn_pud(vmf, pfn, false);
>> -		break;
>> -#endif
>> -	default:
>> -		return VM_FAULT_FALLBACK;
>> -	}
>> +
>> +	return VM_FAULT_FALLBACK;
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
>
> Otherwise LGTM.  This appears to be no change for current use cases, so
> I assume this will go in through ppc trees.
>

I think that will make sense to take these 2 patches via the same tree,
so that we don't see any build issues on powerpc when the next patch
enables huge pfnmap support.

> Reviewed-by: Alex Williamson <alex@shazbot.org>

Thanks!

