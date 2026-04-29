Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A4FFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559996B0088; Wed, 29 Apr 2026 04:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509F46B0092; Wed, 29 Apr 2026 04:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4466B6B0093; Wed, 29 Apr 2026 04:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36DCB6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:01:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7C9FA0642
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:01:28 +0000 (UTC)
X-FDA: 84710848656.22.BCC7723
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id E58F820018
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:01:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=c8FaQuzZ;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777449687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZgTX+gVOkVV7nUMiKXD4ocpW5cTuBnrdpljyNN6o5Eg=;
	b=jMPcAyRiwmxXew3QcwogO4LNU0XmJUneLW+FSJmlVtUkJ0Nc1Pq9SzZ3qpOKJySF3vTsRR
	V1vVBsk+eogD1r95agxlrH7DzQ7mOOxhQek0eWYkBxQLGNywx60KXm4kYDfoQWzvy2LE51
	4FNC5jrO98C7SuxMKtHwHh0E9/J0Q/8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=c8FaQuzZ;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777449687; a=rsa-sha256;
	cv=none;
	b=0eBhCTrpt0SBHEz7a8WreXQ2nlDljlrQI2l+dKQmnNXw4VQowlIxjuEkOAH9+WDWzGz7JW
	AE7uIAVf6st4EvhglNqphdVSntNrXpnTNUQ7SUz++c0cQzIc+1KgKaWNNDr7TuyGDPIFH8
	7MW7a+VKgMKHtxU/o+X06xmUWWUZ/yo=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891b02a0acso9617205e9.3
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777449685; x=1778054485; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZgTX+gVOkVV7nUMiKXD4ocpW5cTuBnrdpljyNN6o5Eg=;
        b=c8FaQuzZ1QTbhaYfZZlRNpHhMfxTteZt8aFvxf4AYGLL5CDQt+bErBOlzP+/I19qGk
         eK7lVyIcguiesF8oAbsgR9zEp8nYj/bBqx+K9RdeDSmtxRR9F4Ys8WK+HtCSKejcw6V4
         lDvp6IPbwWUkPnGAzOvc0KHBAxanSsAKjVTGMOb+bRFug+tNXEzQiyQ6Kj9G393Q834B
         DG+IX7ihxZgzIuaST+OuB87p9JUtKwMxtPbEHK991fkceMxguj9Q84Z1PptYgW+PNEyi
         iKnfyTnT2nLDhk5zWFAW9cfEAUSbhC7G2aapYcI9FmY1h6dFrnVYHiZVZE8QaEO9ewsN
         HFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777449685; x=1778054485;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZgTX+gVOkVV7nUMiKXD4ocpW5cTuBnrdpljyNN6o5Eg=;
        b=feWKT7PZvnH1l/Ow6VFAAhxNTQsmhS1/tCaz8mQl1HwsKNm9Rvvaroxq3RF2V2XURC
         Of/LCCSTl7UrekAiMYXGx0LY9uTo3xr6LXS/z9SlcyRYgf58VZh7CnjMFFZOaQ3T0Y+E
         yd8ocBRxNaA5q5HGyDkUPnFKCOOejhFnyfI7J7LTz2Pkay5/kqboBkF3HvGd0d0XBNpG
         aoSGBvIFnExOEqwoHmQMon9gmOXWmKJx8YzOlpi67ksRH1eShjAcv2iRfKwBv0Kqv8IS
         /K2ZaZYZzs2OxXJr9CUj/UPHQhK8VmS4k0IQ8hf/th5Jtb1/61qc+pjEoPLEJVlKIX6X
         CJRg==
X-Forwarded-Encrypted: i=1; AFNElJ/aHvH3xFOzHPS2A8dG/pcbDskXD2NhD/wBtLkh0LJMnZRvfiP8XaXTqFVjsYmkNJVbkrIfi8T0sA==@kvack.org
X-Gm-Message-State: AOJu0YxMLs44QkcVyCq3GHO93HdlQfLszle8KE9zSIJMfcqhzlEbRTeU
	uX0YhS2YS+96v2rgACxYXI+CmOV2ru2QWb2qaQZRQ1yOFXvtX+j+F7OBy43ioAaYcTU=
X-Gm-Gg: AeBDies0O1COjCGiMalx8OC1/LeVXp5OnlE//whjeJvZWyGeypZOjY4oVlF2cb3NDvK
	KozbPWVgGLMoSE37WjDFWbLyBprIplfm2K9S1qHkyhUOqgtpYZStiJK2GN4RBV0ew7X3ucVV31C
	dIv8wJjlYPlbTwRmxyzktfrVUrpDAhFo/AoSFR+igRkw4NSfzjg1Y9RCpHEpuXzTT1oGOueXR9+
	SsWQTghuEeJycizvxmfhfLQSHyAwVHy8Q5hzW9Og1FCZQs9ZO6dmMypXaH4Z8yK5MTLFXMUZina
	OB4Ag4x9WLxIiDz12QY322tP/CTOrdh+1mph9AbGZ+QNf7yaX2Lm9bQdV8B7AvXiDHu/r0o9AQa
	D/HR4KwBEo4towuHF3yPJXOz42u+45sejppQ0lC81xKiQ/0g0nfkrfhUBD5XhmRLw06seVsRo9l
	Zee/n0kittbCmT2gwH/SCZ9lowCgHfRHX1HhqSx+ubHhEAYPFSx9gA7HX+0OmwO3xhWjQt
X-Received: by 2002:a05:600d:8448:b0:488:a797:f099 with SMTP id 5b1f17b1804b1-48a76f7a55dmr48377525e9.3.1777449685427;
        Wed, 29 Apr 2026 01:01:25 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7bc12bcbsm63364245e9.1.2026.04.29.01.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 01:01:24 -0700 (PDT)
Message-ID: <e85450b4-def1-41f5-98ff-e88b18d5201b@suse.com>
Date: Wed, 29 Apr 2026 10:01:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] Documentation: deprecated.rst: kmalloc-family:
 mark argument as optional
Content-Language: en-US
To: Manuel Ebner <manuelebner@mailbox.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
 Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org
Cc: workflows@vger.kernel.org, linux-mm@kvack.org,
 Geert Uytterhoeven <geert@linux-m68k.org>
References: <20260429070759.309110-3-manuelebner@mailbox.org>
 <20260429072704.311603-2-manuelebner@mailbox.org>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260429072704.311603-2-manuelebner@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E58F820018
X-Stat-Signature: 3u9xu6fhcey46k7x97bbozr8e9i1guza
X-HE-Tag: 1777449686-28461
X-HE-Meta: U2FsdGVkX1+xQBWBRijxfr2mN1jkMLmty0zflv1hc0+8Z6ch05rBqLz5aLZyiBVt/xQfu2ARipPwJqtGRYmGZXo9McWG6AqeGWyaoV1cVqmSONG8Szdj8RjK03Kb4vG3weQwN9z+dK3ZvC5TMhWrTViRajzol5OEOouWiCACHHZXFNmooVl7llNKMkCqnkBcSzIGB9F2F51HchepolbguVU0uW4UrEImVko+T0k8NZGO0x4ns/jQw1SfthNcHFuVwpuvQLHajA/1aV44M4A2IC0DiSr8Cz/2dzeODOufJu/4ruxmqvNm+wet9NkdfOWG5PkoLYRS3uM2ZE1pUDZgidaTqtS9M8obd4cHHI0hrA0ZC0nNuZF+m+62uvSdq5siJiJWKwIdOPXMFr+RUsT4lFRBJSSSaQTNpy9i06xzW3S6RXwV3g8gJDDbLmZrAA8UMWEdWfI+hSSXSMaGFLsxTn3O9qU1O1h521rF9+Wy5uGCYBI+0AtRC5WYkB394r9CdJgt/4PY1JyE/gy4RgeasxiHQFT1FmYrm9/Ch+ZiIhu3RwYH3v+vcpL5nV8Tf/YFXeRrm+D1Z5m08dCOgomPbFYnmWoezwgTOMTHF/T9BUbG6Un/KlRqBRER+0jql8BTyZVWxbxJBNW3qL645J9YB16vRzv6ZQX7kw/h7p9GdtXmXIgeMnBCntJxBNeVCUGz7FIrinxru1XZ/JaLHGpXxX1GMk8S9EWuZkT777Mo1rmX+9k0oSjlbSy3DRRG0I5FWwcWOS8d2jociSUI3+76ngI4C3LS2nt1V/7osKkIhNZYfS0n/QIHdkkE7JLg0UK6IeZ3DccCxXfXOoglXfStwacLgsf/CYM5Dd0LD1yEsEjOS4f+URazp500QG4mJlraUNqyOpYJnMuUUY1gDTjsG+8jUxy+KBSJwb6sAgP/hUvxl+/VXiCGzLRHEovjDXU3NQzvJaBZ0/p0tAiap1g
 Hm7hpKmY
 /er7KENY7MDrPWbCAnsAZ5YdJlQgqHSQ9EbaEn8Aoad8UPi6uP2+ONL0hgyTB0l0JaiTLNAvzic70EkdwnT5s7xQC2A0pY32fTO5ZxwTbpVzReGmJwQ4p7LgvBeWyQdLM9tbFsq/sfSAi3Zxxp8CMeo+4+O32rmljMePbQdM5IP4YMoiTQCo0P2v8h0GbQ4vX80X1IjOiQa5UymGu11zCKeJk5BXBmxzrV7K7/dVHkIYkmlWZEzLv5Y0rBKuDkzMI0yjoMw/fwN3fMBvoZqN5NFsbGjKJz46gp0pZhf1wdXVI4Mx33aOiOTb1sWM+DHxe1XQshif01FgyCAkaFnhPt1Qi4CyVJH53q83aaBm7C6p9EzMeWad5GfD3eDVMEzXjUsNGcKp9El8Uj1fJQOG0ApWOJSTVI8HxjgC8zMT+b01YJro8UgUxVH1mXK4RBDZIN5PxgN4vlC6r9rK0ZKBDET8h8Ck3jxt+CM1SUO6+G04FjupDHeQX6jMGaQq0vEbvq7Ulk5CEWkVdJQSmFgxfDTgDSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 09:27, Manuel Ebner wrote:
> put the optional argument (gfp) in square brackets
> add default value = GFP_KERNEL
> 
> eg. ptr = kmalloc_obj(*ptr, gfp);
>  -> ptr = kmalloc_obj(*ptr [, gfp] );
> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  Documentation/process/deprecated.rst | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index fed56864d036..ac75b7ecac47 100644
> --- a/Documentation/process/deprecated.rst
> +++ b/Documentation/process/deprecated.rst
> @@ -392,13 +392,14 @@ allocations. For example, these open coded assignments::
>  
>  become, respectively::
>  
> -	ptr = kmalloc_obj(*ptr, gfp);
> -	ptr = kzalloc_obj(*ptr, gfp);
> -	ptr = kmalloc_objs(*ptr, count, gfp);
> -	ptr = kzalloc_objs(*ptr, count, gfp);
> -	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> -	__auto_type ptr = kmalloc_obj(struct foo, gfp);
> -
> +	ptr = kmalloc_obj(*ptr [, gfp] );
> +	ptr = kzalloc_obj(*ptr [, gfp] );
> +	ptr = kmalloc_objs(*ptr, count [, gfp] );
> +	ptr = kzalloc_objs(*ptr, count [, gfp] );
> +	ptr = kmalloc_flex(*ptr, flex_member, count [, gfp] );
> +	__auto_type ptr = kmalloc_obj(struct foo [, gfp] );
> +
> +The argument gfp is optional, the default value is GFP_KERNEL.
>  If `ptr->flex_member` is annotated with __counted_by(), the allocation
>  will automatically fail if `count` is larger than the maximum
>  representable value that can be stored in the counter member associated


