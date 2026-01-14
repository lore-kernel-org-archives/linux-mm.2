Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1EED31A3B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9836B0005; Wed, 14 Jan 2026 04:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187976B0088; Wed, 14 Jan 2026 04:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089A46B0089; Wed, 14 Jan 2026 04:46:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF10C6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:46:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AACCB966B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:46:11 +0000 (UTC)
X-FDA: 84330088542.05.B45E164
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C6DA640006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:46:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Emln45Zb;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768383969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2tbL4BBFEtr0FzmdFRllWmOXo7mkFysd1cive9jANhk=;
	b=ZIKYtGNgc0jgtvvkNnDCLsCI6zlOZ98wE5jX6Vqgd4Qg9fskk9WHpUz5qAnypFizwYwQrN
	Cx71CnPbjV2/MqKu8nYW0QSrtA7adQ877JJscbkoKeEmZzvscDOZp0JQIM1+G3nwNQMRGu
	4ij1etewE28aqrSNhZAKb82GQeD8/PQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Emln45Zb;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768383969; a=rsa-sha256;
	cv=none;
	b=G783w3bAR1PIyoFQXbNiUdP2SKuKoKuw7HSJoHH+Damb0cCNhpoTgJ7WVj/Uuy1lCPUDSM
	lXKbFJtxXnfkGRcn/s0lpcyYbQHkWSkhBubnsesq/3IkEgFTtj/Eu/eYao6SYUcIsEPpAa
	kx7/cuSDT9920vAhhv2OS1qJrKwzOrE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD8C640D8E;
	Wed, 14 Jan 2026 09:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ECDC4CEF7;
	Wed, 14 Jan 2026 09:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768383968;
	bh=18qz/N7rP2+o1CwTclwkrkeekmMdR6OglwjJ1t5rog8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Emln45ZbWCM7QQvnvlsfZ43WqX5pz05VeteZ/MTBRtyNPqZb+hLN+LffuwucTSzby
	 ujMVmDLTG1sZOX4xFO54vrWhTnyhCFm8Dy42nhBLFEzbWLm5Aa2FqVc6HIC2+dJ+5B
	 yJJhWBS3nPXXYDIOYv7k0lTEoj398Sr4KNjZazgMUFGx5H7HHx0hXMNzIOEX1U/PEM
	 hy0VzPmD7+5XSE45HtWcpuzru0jmLKC1I6rViFSw5cPamii+2+5m+CFoPkcuAc4StC
	 pVAL2HP0AYlACXFzMfMDWckJMmqJbzEaunEVMpLgcx0mSbG49zXsoXmaGd2JyJ0kYn
	 5UYO7bmk/XXkA==
Message-ID: <a69de6b6-bec4-40ff-8b17-f24f7155dd57@kernel.org>
Date: Wed, 14 Jan 2026 10:46:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/memory_hotplug: pass online_type to
 online_memory_block() via arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-2-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114085201.3222597-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C6DA640006
X-Stat-Signature: tediafemrgh8r97hy4sgutgbfeneeuwg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768383969-726170
X-HE-Meta: U2FsdGVkX19P+mzy8qS0t3LYeHM/52PZ2NB7aj4d5sd0h7Wi59OhVJKC6SHvq0G1+NNtEFlstTOnIMgjuErV/COWY9NZro9Yj6gLZ6zrROcm+fspaYDgV/MCuvS/rcnbMCYCFrnFelYWhKNlofGgTx/eVtuCIjFU+vNZA7+s6l0QY1HiCE5bqCOhc2l39P2hhc1+lv0OaAU8ZLPFa6vFy2STHQlI7S8fAYjiV9voNrKkTHAA62lNZVYHdyJH3fgIMqh9bzKYceLgmoTVnh6s6f//5dRlAtJlqaH5ljN4akHUz32JCaPSx1E+I2ghzu1clfYobJBLJ3EArE0HHJnSJ9xqEAqbNt+KnFkH8IgjgmlAcO+CoWqkD2OM+6e7WYI6nV2SfSzIy0Bh1c1v9qF2nzYW4azxzgcbAM0ckXJnvswBS5dt5pJO0k7F5WUezQFJA2jKxM3iy+TS3gdGrnBP5ZK5VnDpm3HHTKs3BDtAvwD2BKFXbp4/CMRBuCnCoQZnzhXRSPpahrSPvwWhGftbcJzaPWoe/1Ai47m415YJHSrTl6LsGj6xRFrCnrqWAJQT8YNDy0vkP+XrJRz9Fxm8MckGoLAyW/KHZfyq1EAGTdeY0akysgRVaR+9Umd4GTvD5PaSJ0Drab9+Pnsh0XEqDnBKFVvy0C/YtaYRv+Yg/TCkgAmmjrGo6rQ4UIFdKu2oPCiLBHGT1gOggh4wMiraS6F6OPmiBbbNi8Cezfn3SXbZfg5FxBMwl0cFL6fLaPBj3IY9weuPN7z2XDE7YeJuqPS7/w6Cc0rvH/oGjzBe+8E92Z33wGQxme0B9KmPs2HelahxnN4LdPhX+DfOGQ77FMrT3lnx99aZi+uy8+fYk6WoPHF5exby8p38aY7JcwXHU3H10cPmCmNfw02qz2B6NHx/wiUbx0hcTh5yLINPlF8rYQMuMqug7AiTU4NMm6B8dHWBu1e8qpXc5ED+SBI
 PxdcNdXP
 TlXZCk3O+97tDjDW3AO6VsMPamEpsoP5L2Ht+xhnM3iDm+cVZqah+NJ+KVjp9IxmHnasra2YksH+xK4mtpcdjRMChJuJSSIRzso++WhDGnzhRO1IZT2HWKLAlJDorQyODyLC3UsreQSYfR+kuTA7+5n63tEvccfhxDIRHZmlU/1Po2O+xjdJ+bb1n2LetQTJfxtwGXGZcsBdG7SEtKuwagvZVUZ2GR/JIaBBTRHTmjPfenVD0u0PzNHyK8fO+uazGJYZdwAU/Cj1AMGe+vmGMLYC4PKLY3qW/bTW6W4w26o8k2Rjuhrv4LSVykc4lJz0ESWoDkFZvdRQTVy8q6gxx+wmQ/8XjURh8TKCXSWZFV4ZCzLE5CeC7c7vQLwkXLx/PKXR64t+e2poNqcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 09:51, Gregory Price wrote:
> Modify online_memory_block() to accept the online type through its arg
> parameter rather than calling mhp_get_default_online_type() internally.
> This prepares for allowing callers to specify explicit online types.
> 
> Update the caller in add_memory_resource() to pass the default online
> type via a local variable. No functional change.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   mm/memory_hotplug.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 389989a28abe..5718556121f0 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
>   
>   static int online_memory_block(struct memory_block *mem, void *arg)
>   {
> -	mem->online_type = mhp_get_default_online_type();
> +	int *online_type = arg;
> +
> +	mem->online_type = *online_type;
>   	return device_online(&mem->dev);
>   }
>   
> @@ -1578,8 +1580,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   		merge_system_ram_resource(res);
>   
>   	/* online pages if requested */
> -	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> -		walk_memory_blocks(start, size, NULL, online_memory_block);
> +	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
> +		int online_type = mhp_get_default_online_type();
> +
> +		walk_memory_blocks(start, size, &online_type,
> +				   online_memory_block);

I think you could just pass the value by casting to uintptr_t and back. 
Doesn't make a big difference here, though.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

