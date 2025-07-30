Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E130C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4A06B008C; Wed, 30 Jul 2025 09:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685216B0092; Wed, 30 Jul 2025 09:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CE76B0095; Wed, 30 Jul 2025 09:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE436B008C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:55:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF5A4C0479
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:55:30 +0000 (UTC)
X-FDA: 83721078420.27.2CB8916
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 59F3BC0005
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:55:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U4D8eQXA;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753883728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VcFQqoev4ndFVh1DgWdnNI6LwW73kLIz7RUlLHtApU=;
	b=NwKkkC9NC7x/uJV2ik1h4P3ipK6b7wlIayfPpqiEgVOX3J5+CI57Wu/q2JlQ/4Wpbzr+5k
	xtoYhSG4nNRJcI9L8NpT1ba5rwacYAkg1CdjFgDYdSym+VEi5mgmVOQ7y39EkgGEePnbOq
	1uJHKmylNFTGBS7BJprsoD6mRhuhZ50=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U4D8eQXA;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753883728; a=rsa-sha256;
	cv=none;
	b=nO+olkRYU0B4u/KIc2mGiKAdkNKjZZMr35/8XOzOd5P0mEUEk3gfNeHPPLjXeMkQgMU0xV
	7sbngmynb6mNiVczMzKtNv6EiKI3poSXn8gwvVCsNMFbsHREgJ4vuTzpKRAvVwBT39B9XH
	StjWIXN74Td5mJwnVGRBcd+eyl7x97I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753883727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3VcFQqoev4ndFVh1DgWdnNI6LwW73kLIz7RUlLHtApU=;
	b=U4D8eQXA+5wuPHvqhTS/DElTxJb5SXU6AfRUn+4VEWgSUlULNE0DNEbTLXvDGBlLex0u2A
	vLlZ4YGleS7WkEKJD6ERsdKOUIXqM2ALqE+DL0lWroyURD9blrIRlXIG52lYYh+AZWrJKd
	agq4jY8v8Ve2jUrRzByL9YpwHrEPYAI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-2zhDCIwBNdG8ktIcxVvj6w-1; Wed, 30 Jul 2025 09:55:26 -0400
X-MC-Unique: 2zhDCIwBNdG8ktIcxVvj6w-1
X-Mimecast-MFC-AGG-ID: 2zhDCIwBNdG8ktIcxVvj6w_1753883725
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-af905b8978dso54371166b.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753883725; x=1754488525;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3VcFQqoev4ndFVh1DgWdnNI6LwW73kLIz7RUlLHtApU=;
        b=vphFP08JavBmd/R2iO9y7/AEvNITqiApNm4PiSasxSU2HaPnQLqmV0G+Rf196xrcBf
         JofN+RLzeUXd81LfnfN6OKoTmG0ehg5kHe0OFz0UudYE3bcl4QRxjqn2YpXPHZSr6enc
         EDuQJi6Oz5nPod1pM05Gi1QoDuf0RoMlf22ZKhGHNunrGegorZY1i+TMb3468soYpwyw
         yDcnF2RMYKplNcg1VReBhEr1CirsEz2WaLDLjjmymToD3VT10kbymCDiztz+isw2IjIw
         3dC1nppEnDFZqIAMUP8BvLXYKMYnEpp8T5VxDU3US+DEdSR2Rho93mRQSxtncPDCQrnw
         MyAw==
X-Forwarded-Encrypted: i=1; AJvYcCVr6X79QCewmGtw30LCTHu8apeyrqJ7MYQ/wdHlOpvVsQH7w+m4kLOdXu3OR5bFxO2q/I+j9CodAg==@kvack.org
X-Gm-Message-State: AOJu0YzzLMdJ/wHyGenkgGI04V7nBRdamvcfqPi8B4oCozuRI1FpLG8R
	cdxCzfoM5gg2LOMcfoFpGNv+MJT+kILEFS2LphTLdrNBDAyvh2ZdQtJLQ0M3fUvbKXDfMG4R8Kn
	ehn52/r7u3gCRK1LLxvf/tCIipoWI7Y4iM1zUMrhUXXZ5dMjCF5Nt
X-Gm-Gg: ASbGncuFQZiVDGGY/PLU3DxtsMK6/KXKBqHSnQN/YNHKETOlsdBDGH2WEJmhT8Rt66O
	JVvG7J81fEvMxci6Id78ctN6BedbIchQ4+2Ddzx5UjhVdwmFbkJomBUgXybA1Mc9qUctr5hhxN3
	HHGSaeYixile+vSTfyW7ga+Zd6XklE4m+2RjCEdW2/d0GRnkFOCxelbH/bL0q71N4slRIHJzJK1
	MFHb5sODDb3pU5iYCcNgyAEUQ26lyHZsGypY++iUEAFnjwT9xlloiXq4DvNu24gvB6NX0F5yeH4
	fS9EFEyd1JNI3TI/Hc0z4IukjyU9e2v41myPX8Y9e40FCHrCv8BbBbNoau9v9g==
X-Received: by 2002:a17:907:3f16:b0:ada:4b3c:ea81 with SMTP id a640c23a62f3a-af8fd957532mr381802266b.39.1753883724937;
        Wed, 30 Jul 2025 06:55:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnFvdC4+f6/eJenyOa18wsoa3h5I67gwGBhJ32KqQ2TAENVXY/DrKoXNbTnHSurkHrTJi8SA==
X-Received: by 2002:a17:907:3f16:b0:ada:4b3c:ea81 with SMTP id a640c23a62f3a-af8fd957532mr381798266b.39.1753883724471;
        Wed, 30 Jul 2025 06:55:24 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af63585fff3sm750425466b.21.2025.07.30.06.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 06:55:23 -0700 (PDT)
Message-ID: <7ecaae9e-a088-4c1b-9caf-6a006a756544@redhat.com>
Date: Wed, 30 Jul 2025 15:55:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 16/29] mm/show_mem: Annotate static information
 into Kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-17-eugen.hristev@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250724135512.518487-17-eugen.hristev@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4zIOy91Th8NrkrxuFmUFpEF0qrOeVFrF_DfcEZHbe-8_1753883725
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wheu84o8yro3856jf4b4racbkxkiutfh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 59F3BC0005
X-Rspam-User: 
X-HE-Tag: 1753883728-891465
X-HE-Meta: U2FsdGVkX1+yARD0zzer1/NMNVQGFI+47kncE4lSpe1COdfxo0Roc8dSqnLNQY8b6/CeJbGKrojYKZRzn1ryyyf3XiDhIGdNnvOLTK0b2v+vzi3MqtkFjnAg80DtPeZb5x4nk9OBiUAZgXGaXUZbk1BESNox3MprWIAMtQ69TdU51OuqRjCGfFB1PS3jnNi8FHFAGhgcLIPotPRZVNOyzyOhzI3I9xkoflOgSdq9GCBI5uNNx7KIdl5r9Mn+URJ3zSN7ckeTsLX/aYT3kllb/0eycmBALDzwhnPMprKqfQ+zwG3HX8Q29XegW7JU9HyoMODcO8LPmf/5bjBz/52fnrs8bl50vYGhJC8l2vDJsePNSq3WYlLcItTq0aDuwqzb+sOKRrM0IuY7Z6cJzZbM9ghiUOLdpmVeLowg72k2pUOC8wnwdoFn5RWbzcppeToJjbe/n1cfOE0IkpoUKWhtiTRdaE4m/ZteQ3u9rmYH+P5FbW4T8fqVqNGCQ4RvGAlmDL3GyZ/FgAN4rPc6bXjjPuskVdvYjs3CAm/pTM0sUayCX1VZtraKaOVIH17OkxDytoe+Dmd/6znwR/JlNqVhhoiX2OMPo31Pl+DEvxfIKvGdFg7F56daf0pAHqaHyXrpjt7cqAla1+x4+5Xuc/f7m58BWgCWxqVA4PyPnFvBijevtHTSEsnsyzkVW2U6n2LcVpF//MtMcv9sx056Bn8Yjgpf4huaTc2EAhfc1Fzxi/qnqoFEf9/ZzBgywbqGTdKqZU/5pvaJ7InUx8pF5JkI7MgeU9z3hCJPtvi3pstND/oQJLkDpk+8wxreP0fOidtuyC64aBwhvFICW9jRfZarIcpeVLAjoWmN7fGJ8ap0zAx6RkWH0uORSeGJb+ICDH6m/mJEIFCIiZBMPmiuZ10cruOnVVF8ZBGbGl96VQgT4RipWZJWOYiMWz1cjwwhbx3PhQeD+q9zfWn3kRKsDGI
 IfK0N63B
 hkE32B6aqHcOXsZjlBi9fdy7tgVfSDgihm3esHelPltJMxeWyoHSSU8kpQlFC/69nMdhjbBl1fjzubng1CsSRxN6+ybPlGtqcN3HMkxcjHfGmJfEC3M6vvOv0Zgv/MsoL8AY0+ey5S58PusLYurxm+bGb6Km3QzYbmHM0V6WJmE/iBqlQIWN1EOUuEQlELuXohn7F726rPmG0wKVaB7Ixd3a3DskptmVd4Y5oXV/bMPT/VOFq0AAnvnDeHEWajnoC4bmBacAO6qukaHqEYtj9Lt/bo/wAxxC7FDlmOkQ5yXwPBj8wjnTD/I5AlGAWBgvL0dCdtP1KLjKdksMqhHNZesD9MuU4gEMi6DL9LHUIFvNCHY4iIrtgonXINah3QiplKfkFjtk51fU6z2H71RuEPAWrTZCxJIkMDUtuR3rcLCUW8d5ZEozXiXIUd1we555u6KIeZiwHh6iN08ybDqCR4Vogqa1SszEf6r99vSGWTEO5bPsAYXGfoR1JFS1tRcqh+w3TM40Gn4Rql3KyToMg04be/JOMOCcL5g4yscIxiW0edYlka29GuQBJFAWBWeVk35vOG1LaHG6R8OqDbRQbs8vVUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 15:54, Eugen Hristev wrote:
> Annotate vital static information into kmemdump:
>   - _totalram_pages
> 
> Information on these variables is stored into dedicated kmemdump section.
> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>   mm/show_mem.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 41999e94a56d..93a5dc041ae1 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -14,12 +14,14 @@
>   #include <linux/mmzone.h>
>   #include <linux/swap.h>
>   #include <linux/vmstat.h>
> +#include <linux/kmemdump.h>
>   
>   #include "internal.h"
>   #include "swap.h"
>   
>   atomic_long_t _totalram_pages __read_mostly;
>   EXPORT_SYMBOL(_totalram_pages);
> +KMEMDUMP_VAR_CORE(_totalram_pages, sizeof(_totalram_pages));

Tagging these variables that way is really rather ... controversial.

As these are exported globals, isn't there a way to have a list of what 
to include and what not somewhere else?

Not sure if any of that would win a beauty price, though.

-- 
Cheers,

David / dhildenb


