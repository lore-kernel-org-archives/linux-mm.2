Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9030210BA430
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032E86B009B; Fri, 27 Mar 2026 02:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A436B009D; Fri, 27 Mar 2026 02:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62DA6B009E; Fri, 27 Mar 2026 02:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4F056B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:41:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C9A4160FDC
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:41:13 +0000 (UTC)
X-FDA: 84590896026.08.137579A
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3E0FDC0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:41:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PgKrBfxI;
	spf=pass (imf10.hostedemail.com: domain of groeck7@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PgKrBfxI;
	spf=pass (imf10.hostedemail.com: domain of groeck7@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774593671; a=rsa-sha256;
	cv=none;
	b=8oTFdJBxBj0TzEsmkCdtZnTX9uHhQl+QuL4L3o00+Hfw8+gBDtDG8Okpv90BSW8XJs24c4
	2ALZBY6Q1p26u58aGjnlBKmOtmR/ocw0rmEmznPlqAymjr/sMKPvur+SWGfk9mPO6D5exc
	diSZffP4u3GTh7ZNA1eoIfPb9Ftp+Kw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774593671;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nduYtSKfpopTmuw3oAsPQi4fyD7F6EEZi1ICkUx6Cyc=;
	b=RDdwDYzKB8NnYlqZ3DXInj5eKm/3raPG6AsOyTx3aM1rFhTQId8Cb00xte7QeS0ak+mSfZ
	kxs5GGXo47tLAqqMco94U92TLKKHs0CGBzL/FdH98C5vRIsXFuHjcPzogEqXt5Jp7d44Ot
	k7W6kEyMDz+ae1dUSnKM/IIyLTbnAWE=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2c17446ba8dso988015eec.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774593670; x=1775198470; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=nduYtSKfpopTmuw3oAsPQi4fyD7F6EEZi1ICkUx6Cyc=;
        b=PgKrBfxIs29rrdrucgUveK05uxkdPJurr0NnpL8hfzmG82Ok9w9qIUuRvK+g5n0AP1
         AS0y5TZuN7W+wSrmoiogprbKdlCa4Cmm6U+nYztasMGJmZS4dOytzQBbtzJiuVimZJHE
         QUdOnw3WaNR17SertvM67BXY7PwU+37ga+5YSzNfKQ1ss+KJ33PtW2UwqF3bB6i9jKP5
         gv9kp769w0Lik9EK3QzbOV9K3N/kdWayLn/39xZOQtDJRmH61QSw2ZD+1GOxNieJvVsL
         l6ujySA7gXNDLs1yWXsjMckL4EFz0fKJOj4luCvEYTlPauxS2CCSyqh9x9ZdlshRTWKU
         zo9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774593670; x=1775198470;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nduYtSKfpopTmuw3oAsPQi4fyD7F6EEZi1ICkUx6Cyc=;
        b=Fg5NhsTAJe5EdMBr44Fg3JQ/VYAPQDn7GDCGMOD7alOANwky8peOeSHIVjdVwxiavi
         w40ZMICSRFHf2wF8Y0uKWJ27w9OvWDG/TzVOpeuEpZV9ifaK+TQmUtmt5XjD1PAprxSv
         xn1KcZbWEMEeWFOR3qr6XvareIb2lzvt+hT4f7etG3wwaBILvopQFuO4NRk2lrMs3qiT
         OzuEWPx4LbwNSj16bi55sjjgnwy3YlZ6F29KmQpgCfmMYx/zkjIKOwCqVHvUNBKfAn/2
         jJi0I3+bDgNRX1oPRR/4HQU+XjjPOsdf/vQgdKdCeiRu82Xlk4XR6TNgQka2wDoYxDuh
         YnXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZPFb5gDuiW1X1pxpf9IqN9aSi2BHMN6FojAO80y8OAHZGclNbuHk8KwaHeZNegWKB+vrQqNxEoQ==@kvack.org
X-Gm-Message-State: AOJu0Ywogn+aYc5Q79eSZHWHmovDVYiFFHXhIbsUeyZvJGrtaoOGf9CP
	3VqIyGudaEj9hxA/p/BbMFkYimdOAOGr/W8zhABGaU+sO2Whufk6miKC
X-Gm-Gg: ATEYQzzZZiagYoxfbdf5Ow/afi5BkXUK68XrMvPi0/Sb2OkU4G9e7uGaon4/FUx9Wsi
	QwN73WY1nfa4bewIKiSz2JcKRjfeecJV6Lrcw4W1vTmx0SdVDKASQ+OzTmSFurqZAbfmRIgam53
	hhV5InbAbCzgpSZvBPv5mKOvBzC5GSn5kNc8mUmko9aCER484xhAGtQUiXjTtuLU4u7vNiFi2Zp
	5YopNW0yISHuk4pc/rBljOVuVSsR49DPqTCx5CbWcOt3kqu5ZbbqACRPlHI4tp86g0wbM8i+AuZ
	BqwU6CDQwjSMoVEiXdi3GM39Bo9414bqSOPosT26K3UMy6uhBO7dnNEEXrynRYfhOLTxoQFWSKS
	/ObDOfdj/MMsV0XsOezv0BCtRbn0XUWLZYoAroQclZRFLADi9etlX0viY4JaZ9oq3D/FqbmwInu
	chhCcvPNUirXtgWnAMmEGkW/l/abR/uyfywTtH4n1hPaPepJC4G7sbuf+UFcdvA0S3G21Z7IAb
X-Received: by 2002:a05:7022:48e:b0:128:bae0:89b7 with SMTP id a92af1059eb24-12ab2fa1e4bmr488963c88.3.1774593669739;
        Thu, 26 Mar 2026 23:41:09 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12aa6e5beb2sm6654016c88.1.2026.03.26.23.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2026 23:41:08 -0700 (PDT)
Message-ID: <d5491d24-f7f6-48da-bfd4-dff07a15c228@roeck-us.net>
Date: Thu, 26 Mar 2026 23:41:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, vbabka@kernel.org,
 harry.yoo@oracle.com, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
 andy.shevchenko@gmail.com, hch@lst.de, Jeff.kirsher@gmail.com
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3E0FDC0002
X-Stat-Signature: nupyj9f5wxo7ro87cyeawhruwfzkj3jb
X-Rspam-User: 
X-HE-Tag: 1774593671-831426
X-HE-Meta: U2FsdGVkX18ugFsk23i9pDovfcjCL3TlIJgEJJB3MagM8h5rxzO4fjcu+JfYyG9xEwL3K7uk3uNbJkNJCdI+NzY4U/nLkMDOTY0x22yzm14EMDOwlHPLye4TafNPbP7DBGkFc/t4F8dyzxYQbfnDG2FP7fyoqPBj98VoKcl/A9bdjQF57ro1ApCMG/pLoa2s0KmL5BCkMDGsexddefHvH7AxPbjCs2ljEsC59ub4oL2IIBSaNcP3SC94XQSSWAcOE5C8TkMCbPwbC74/bHH0hXU6ZD/I0X1A24VFpnBjcmlVbNiOyn2flgf2U+OQQqzxeCc9hRWEcgSBiwkB4JzoYWTi+qf3cgvyC7lDCeq4qaTL242LlmUYqXoSEWBjT4uKweYKINNWAr8SxAtCFemLbR4ntHxKcdGbEX/8p6OLQbJTzw4y5OV22pZ98Aka/q6YcZod6KOTJVOooHGXT04e/YleE+tZ4sokL11WkYJmWWUmHnlOuXkcfEFOXV9fbQ3if6aXhRqd137T1Av8mvZrSjc2nTKzUN7uS0gpp1Tj6BeAzOJAMFafFrRySNEUeOwNNYQ9aefrg6N+lzmyGbTxSMhbJSKbOJa9p1czMiDTJBMS8SQQxFHu0Ghw9kGeUNf/TUKmfXcsEcXGRSblJzsEa/+9oCtJUv0QW02daZGc2fEWfp4Zo71aLX9NTLcBdPmYZjIYvVd+TyTrjFmFgSn5PUHqfRuDZAaBfxelBsTarzOLBN9h8y6FsulYS0MWdj+cuEuFiotu5q9XNhVTaZnHUAnk1xnQuoLmbLt3F2lkvB4yxEb7LvvvnUg5GjFpcbBWAJAVWenyI36IxTKFjK+UZAUUTHzWYi+f3IMjm+qkruK5DqdBjC3w0Pv0JO2ZXF4Bnctghiye9x+nR2C/e68yH4Am2Hi09Y5ybIU8Qz6X0UT1Pave9h8UTDwipwz9I0XYMNPUsq+vP0JLlDGv8pa
 sugWvJBD
 QDKE3OlAAOb/tacrFUgNBeNApKY2Ur1g1Nmtyowhtgs1ssVQ0YRBezI0//nKp68jlAva+iUiUJakxQ6xFRwuYBfIxS7MfXfmve38Swk9wAw2ZFA8pPpdSD0kLSzc5DQs+EUfyPUbt4Ln5Re0IhvxwXqBQWEDbgrpXQLPaSDBkc6sgjX/x7gTKfZKbKTPSxRVFLqUZkONjbja5rGbyZ3vzv9zkg2u53MaVw0PR1hSwS4nz4n8NAK9T7vXwPCH1mPwBIIPjgkI48qf9JyjQUUc730swtrW5/xnGo/g6Zw7CAiIkWvXSd4BAjQ3gS8X3S0BnAz8cd1ogbcafhkEahimr9V0rnylDuwEfyUwjcI2ZPuswhmzqUMhQYqePXLx91iqYg9k4bzNB207TDF4qyK23prBIGh/uOoIn11ofMaMZqRTVxMBllbfsuOZCUDA98C5kXNLq/0REY2IpM8OwITvRW3cIr8sunl6VImTGzTpEGqnN3D58FYbLFIqUe2ODZ4gXhA7fua4PAUerrptAsON5zuThZo+KtBHXeSyZ0pCgB/hQOYNUcWmswxW1R75Zu6CuucNp8bVmhBf0cbJagIDAcvk5dS7y6byOtjOIv3zRM/ZzdfiY5qi8NBUgW0Z3abeSdv8TO5BbVWfGO6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 22:58, Mikhail Gavrilov wrote:
> When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
> tracks active mappings per cacheline and warns if two different DMA
> mappings share the same cacheline ("cacheline tracking EEXIST,
> overlapping mappings aren't supported").
> 
> On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
> allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
> hub driver) frequently land in the same 64-byte cacheline.  When both
> are DMA-mapped, this triggers a false positive warning.
> 
> This has been reported repeatedly since v5.14 (when the EEXIST check
> was added) across various USB host controllers and devices including
> xhci_hcd with USB hubs, USB audio devices, and USB ethernet adapters.
> 
> Raise ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES when CONFIG_DMA_API_DEBUG
> is enabled, ensuring each kmalloc allocation occupies its own cacheline
> and eliminating the false positive.
> 
> Verified with a kernel module reproducer that performs two kmalloc(8)
> allocations back-to-back and DMA-maps both:
> 
>    Before: allocations share a cacheline, EEXIST fires within ~50 pairs
>    After:  64 pairs allocated, all in separate cachelines, no warning
> 
> Fixes: 2b4bbc6231d7 ("dma-debug: report -EEXIST errors in add_dma_entry")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215740
> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> Suggested-by: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Jeff Kirsher <Jeff.kirsher@gmail.com>
> Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

Thanks a lot for taking care of this!

FWIW:

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> 
> Reproducer module that triggers the bug reliably:
>    https://bugzilla.kernel.org/attachment.cgi?id=309769
> 
>   include/linux/slab.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 15a60b501b95..f044956e17c1 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -536,6 +536,19 @@ static inline bool kmem_dump_obj(void *object) { return false; }
>   #endif
>   #endif
>   
> +/*
> + * Align memory allocations to cache lines if DMA API debugging is active
> + * to avoid false positive DMA overlapping error messages.
> + */
> +#ifdef CONFIG_DMA_API_DEBUG
> +#ifndef ARCH_KMALLOC_MINALIGN
> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
> +#elif ARCH_KMALLOC_MINALIGN < L1_CACHE_BYTES
> +#undef ARCH_KMALLOC_MINALIGN
> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
> +#endif
> +#endif
> +
>   #ifndef ARCH_KMALLOC_MINALIGN
>   #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
>   #elif ARCH_KMALLOC_MINALIGN > 8


