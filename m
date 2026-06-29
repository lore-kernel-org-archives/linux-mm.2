Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95DB4C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 05:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653226B008A; Mon, 29 Jun 2026 01:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62AEA6B0092; Mon, 29 Jun 2026 01:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540FD6B0093; Mon, 29 Jun 2026 01:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34BC56B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:35:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA76A167ED8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:35:02 +0000 (UTC)
X-FDA: 84931836444.04.A5071C5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD91B100004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:35:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P0itAd6v;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782711301;
	b=d8qUZO3O32RdvWgnPSrPmzf8xa5tVEVccxIR3MvVsQ+e6HJkUbGwZdZhYzb9pP/eHHfveX
	FD0cNWvlt9JI/kRThwCnC7g+ItBJkjEYWf3V8CjburxaftBZbxI65vFIWLPmAQ3cWlBUbt
	484zwa8uxW6/cfua4h8yqbeC24fZIwA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782711301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFTZdC/ypBfPAY4pNn4U8mNmQQinaG7nXifhwNWUsFQ=;
	b=uq4EV5QEY0mLHNwzeVk8XpePmWJvJ6Rr81FVriACuXl+cbPKWAxDR+y3DpUoOSyQJkTIPe
	Wm2PfF1W54Q4wzoVNr8lF34DdIqyImchiSERbYztwLKZvr/NGo5CRO/A4bHSzJX3KmiIFx
	OX+D4MauHVaJLjdTplxEw3nsNLy37x4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P0itAd6v;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 611CC1A2D;
	Sun, 28 Jun 2026 22:34:55 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80DDB3F836;
	Sun, 28 Jun 2026 22:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782711299; bh=NUHkiulByDcPD0LAw9zMG3d04+sAsSZ07dBbYP1Ch6Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P0itAd6vODdm2NYbl3qHV3hGeNp2VIPcAJ/V9Ivgot/IaB5bbw9qP+/3uXqGQgVT/
	 Yejr5kGsMbjZHOz47M9TnzmUdCks/F2WlQ9k8+M8r07TABDjtKigA3YQ2GB6XbV7/a
	 42wDAWuyfBStSLIydd/5uh9Z5opV+pcGsHnzDr0g=
Message-ID: <05021709-829b-46ac-92c8-fe64507d99e7@arm.com>
Date: Mon, 29 Jun 2026 11:04:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
 shanghaoqiang@xiaomi.com
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
 <20260618084726.1070022-3-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260618084726.1070022-3-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AD91B100004
X-Stat-Signature: gjpsnpansn8dy1ub4ehjgz9fcppwbcuf
X-HE-Tag: 1782711300-965941
X-HE-Meta: U2FsdGVkX18U9KNo6rwNex+t16KI0L3WvYUJ1PTMOX9WeMKK+axls/Jj955iVQFaYNAj/dBB8uDicOlrrekl2yN0lDZnOfAcB+2xfRHXoHIlyTK3sq6Q4/38dsObc4DwxaoQMdDTZMLumUzoTj5fuFpMHFmNM3ehbt/KE0Xv3qeayo6sBiWhKwqRLrNCSdX5j8BgBLseMotueQ/QVi3cEuRXh4A8s/PrA9xr/+6cf3MswOVJGYlXESgpcsa0BDnSItEgK5ZgGaJY2jbVbNJ7hNphWzbSDiQPocRRJwB6rQDRABh5LLyfJpZbJo114q3W9LHzEZZidbSTyS0Fy/Tq6MfuJSSu+GsVqg5CKxtxecLznYXPEcrnJSQO7sEGB4zvu+7ATzMwi/Ocp+xbtpaeQ7gTzpyS8HOeiWFSaCVqIiwAnJywqgrkyOj42kEq6V5oD0PjjqxMiFcxJSonC4isq+AB1yXTYkVJTqXgGoWyyS2kgsOxWbKDRhif+ffLlypUEEtF0zsGX11dddtzaY3b+kr1pVzA3cfKgq5JNW7mnF1SeBpIMvBI74aCRMdqBA1os51dc7QaiKROBt5h0NGW6Sy2S3aqRbsaKOO7j/RwHk8zsJli3ARDHGcsC2nvE2PEBIoYZZwrAMzzsdkySVQV6eHWA81cNZg0fMTS4PiUxRTE3ka4Lx9fB22DfnTs6iAgCa2cU10Qz5yMONzgYqjBrflWngsw4yV8QbnEeFl6VrxdRlGJVEIBNuShLZ6MhfTdwMI8LpNMaJQR5SpxlKdk2QENvfkhaSPHMt+B8TFGOqeMtMt7UjVXcF8XeyEK+ktVvc6jsBpy3FgzJevUUUxyMxVDFk1WIFrafx66dokePL/fxqS4Ov3GrUyheVUGv+zdLJdfTshix2rXE/lgov7T/HLqWmEBqVRYdFp11p31SAnGb1Vd5hr9xVEGlFtMpiTKu9jnLWgku6Kl6h/yiVi
 XC8HkUcq
 RfFtBG0A62WfBbV8kAzyGHLV9zp0QBV2ZqzFbAqgS6mo1SVlg8b9pH3BM8y+S4pC5z3DAHFFtVIYAhWClHsupUeN9nAnNFn5TyajaisSZmoT2Um92t5AppRTSd0mvILN9RQLu3cGsGU05mQ6xJ5RHGsHIYMCAlimHRCQKHxCEzJR7Jt7UdLOsoixye56JL8M0yOzbwvL1AoXExNEPe6ohAfPMuPrK2W/NNMtZKYuu4dbBKkoUkW41x3UvTB8ROoPJK7svMRFsOqMlU8vFJl7qviDvKsfnoebGFtx1J5QNgFJMbPJBhKGsnYxwNhAa7wDw9QmSwJTARkuX2gNmsDgruDhrwWzTHnkUSgFtRhrXkZ/+D14AZ6fpPYGSSUhV+LfzHHknq26pqUn7Cz1XzGTnMSW1ll449RMVv1GRsyPFW2W9Wf2ianSeRm2FMY+M8ne5nnyOigt592Vr9C3HI4tbAcUou4oyzWVRSlYrsOhYetSmrVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/06/26 2:17 pm, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> blocks, reducing both PTE setup and TLB flush iterations.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  arch/arm64/include/asm/vmalloc.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> index 4ec1acd3c1b34..787fd17b48e2c 100644
> --- a/arch/arm64/include/asm/vmalloc.h
> +++ b/arch/arm64/include/asm/vmalloc.h
> @@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  						unsigned long end, u64 pfn,
>  						unsigned int max_page_shift)
>  {
> +	unsigned long size;
> +
>  	/*
>  	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
>  	 * aligned in both virtual and physical space, then we can pte-map the
> @@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
>  		return PAGE_SIZE;
>  
> -	return CONT_PTE_SIZE;
> +	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
> +	size = 1UL << __fls(size);

Nit: I'd rather use rounddown_pow_of_two() : __fls is confusing : )

Reviewed-by: Dev Jain <dev.jain@arm.com>


> +	return size;
>  }
>  
>  #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size


