Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD9DCA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963C68E004E; Mon,  1 Sep 2025 09:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2C58E000C; Mon,  1 Sep 2025 09:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FA38E004E; Mon,  1 Sep 2025 09:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59A1D8E000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:23:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08E8A1A0873
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:23:32 +0000 (UTC)
X-FDA: 83840748264.15.CC8F6FF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9F317120003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:23:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K0i1LV80;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756733009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EHyQASudRpMIxAo74+7riZFD6rvogYVCRTIssUbz+k=;
	b=fw5XOQGwO5avtXfmFtKXxDzmkJgmjuowihs+2yFfWfyUnqtjOIOsuK147x0xFQUUxMXu6q
	caGTmggcCXr5o1Qq8DFN0moLfeLbjn+p713ts/GQHGFd+vom4cdJZcaU/fUoL/beIYEisx
	M5dNmOcv6VEoNaxKEtSKZfZImUjRN4I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K0i1LV80;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756733009; a=rsa-sha256;
	cv=none;
	b=izHQnpQBtciT1eeoa18AP82JBhVoegFaMOULhQz1aZ8hOsfOplrRG7zuuS4DZo4MoZze79
	FEeNq1cEMMdXkNDMkMdg1sz1bfjAVkBPFxS8h/1sEMpbVUWJDgYY0q2g0ro5EQ7+VEFk0x
	Avn/Ytz5b1ELjYIrj8LHh4LlFP5TxOM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756733009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5EHyQASudRpMIxAo74+7riZFD6rvogYVCRTIssUbz+k=;
	b=K0i1LV80LAuqEJ2R9PqYsZTibZEQMQ2VqtzxSxQzqZ2W2mi0eyZdkagxPPWbX9l6bHsArx
	f+dKIV2LjX0h3wFqFDEsEFQ5Kgv1r7hjbkXv0jcyTIOcve22Li//kKM/s0LhM5bCSYuMnC
	vWCeQZf7NEuk5cJfteL7JyfwuFkBjnM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-kCiYGQQ9M5Gk2-UnrLY6TA-1; Mon, 01 Sep 2025 09:23:25 -0400
X-MC-Unique: kCiYGQQ9M5Gk2-UnrLY6TA-1
X-Mimecast-MFC-AGG-ID: kCiYGQQ9M5Gk2-UnrLY6TA_1756733005
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3cca50781ddso1844318f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756733004; x=1757337804;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5EHyQASudRpMIxAo74+7riZFD6rvogYVCRTIssUbz+k=;
        b=gS+xrAF2LIiXvzOaaHIkMxCkChzCc0lXF4D34n4i4QATClCClqqm3XxPAn1UFaivJt
         Jj05DUI+aNKKOHVAe90ps1mn3zP0NGS2b/L7pqTl9BaZjxEOIqgY19Ugi5FcZUVktmrt
         u5nEfo6ITlQ1XOj8cmS6N+5JBALP6OuQZ3qU1zycjJKCWRG7zFGp69hSgE8+WDiLZXfM
         v43clkQJX3CxQ6mHq5L4jDKFEnSnrJUlXdFe+1zKDncrRy1UlBU9xtB/PwxO8YqvTl71
         KiApFUhljSImh+zf34kAH1jMByi3xiQOtJ/hPO40+vvjUpSwqWx+tLe5ba3NjBO5DhLA
         QVmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqro8PPczyonGVney2/nFzBGxggCztVsQEc/q+Tmi7I1DFoLaFvaKd1RsW3+khecQIhTYhKwc3XQ==@kvack.org
X-Gm-Message-State: AOJu0YzmYYchWWHhnDWBN1gC/32KFe4xX48KMxV166eQo8sLXXuMhUcJ
	fuWqow5cogzTAHL+rVqNfYCsPD/nTrnCPIqORkaMMuvVGq2lQGnyAYnbiHcC7Zh+I4U0IiCor/c
	nh0wfUo2gDQj+dRfFLPpjiy47F+9T8ElYzDve7Jf3oMPRNtaoKa74
X-Gm-Gg: ASbGnctOVpRkYYg0OcK750xM/3hnQZgT6GnR9lYmNBr9Vw+V3R5JdwHAQ//1cY9D4HL
	Hb7pEDg7WC7L6O+tDQqQoUbtrdW6rJafMx4de1sxtxWG1md4q38vC6ksKc9x7Fho959w273w9hQ
	AYXftr5mZu6d8cbnhOisBtECDeBvYATRJvvb6K6YW8X+uZOjZUiJIfm3MrRGEVotAXaTy7ddlaG
	oBpZZJqEEJ8Ses9ppk0ZGefu20StIApOCT0d56tESjR0m0Pnh0Qp1Q3qpUdyP36SDFMbLUyMmXW
	yGX7lXnsdBvzukspbZxoJKJdsVM19JNS9sOoIgkWqcOjNDI5Vz+kVTlRGXrsaDvsb+pSd5eliOp
	XGnTgW1Uw67EF8SZ/Z9RVGonuR/CurlLFfMhmb4H+qpgPZyGWQt2t2Gl8p4JlX6ituk4=
X-Received: by 2002:a05:6000:250f:b0:3b7:8b2e:cc5a with SMTP id ffacd0b85a97d-3d1ded76f89mr7325979f8f.40.1756733004613;
        Mon, 01 Sep 2025 06:23:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpCndD0LFPlutircWKghY8QG8SUd+xV9esmudoxAzufTgNwxKCMPPfcvQOOFMy8QRFAF3U3w==
X-Received: by 2002:a05:6000:250f:b0:3b7:8b2e:cc5a with SMTP id ffacd0b85a97d-3d1ded76f89mr7325955f8f.40.1756733004178;
        Mon, 01 Sep 2025 06:23:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf275d2717sm15422593f8f.15.2025.09.01.06.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:23:23 -0700 (PDT)
Message-ID: <177f4c8a-1ac7-4fee-bb34-ebecc4ba9384@redhat.com>
Date: Mon, 1 Sep 2025 15:23:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memfd: remove redundant casts
To: Andrew Morton <akpm@linux-foundation.org>,
 Joey Pabalinas <joeypabalinas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>
References: <efbbe6093b64a5b19f974871d5262d6e75dff2c0.1756639225.git.joeypabalinas@gmail.com>
 <20250831123426.3ce56a2448b520aba75f8edc@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250831123426.3ce56a2448b520aba75f8edc@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7SqpMUAtY5ufBuOYFXlj6kTWrEXyNxQCu1Mbd3XSwF8_1756733005
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fje7t5fu6azi6zswrywai81wxopeauuq
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F317120003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756733009-892273
X-HE-Meta: U2FsdGVkX19EpqIBzqZLXUL5Usg66BIs2CLx4GyS0TWj+kWVa6iJjWG39ZLbuYXNnIal/1Wp6rI2075oZMZkFm9uJt1V0cCFizv72cgClimlC5FV80XzvNLipPOjTf+pgqfxY1OoDe2G0/XgZYP6m//LEV2qQSBLbnFEXd8OYaaEMDX/79eYSGlVFHqdVI9NCTnlS9gTN+bfuzmDWdBqR5KxNaNeThOFeaGFks7zKVh8nl+V5f4hI0JCvjHr34EZ/nfxM4atoqBsvzCxBBKLPl7FnZha2zxi+kyvql2GL1FftatLqhJuVTcFqvkysPjkzFBcwYzEQarcXdQ9r4aIUyWTKK/gMJ65CEvA4UXlFzbN4fyaDx4ere1Lc3H5AlH5c/c3rd3rnXMmDYiXY2+BcRzDnXKssdJEaztYVyxI6V8Lrs1+Osylj9esuDqHY2YH89x8RiICBWlWiIT1FWTk2PC/Z9x5DKwMpm8YlZqPzgpR+gBfAirbCdQyfZdV2K4GmnbRWYbJzwUQZT9rqSwerQpM8K5OVGU4YpI5K4Ya5yHKTNExdddIHFOIApJ/Nb9oDbJYSoWoepAvrJzwM9UEs06vB8w+MZxIT4rV5O+ZCLCIM98PuLkgG3EMZRmXUvbdZ0V13i/4AMGoDfHWNhvREA3WTopGsLnSuPpa5rR87kB7xLJKs9cmUs+qKXN5VZyA+0XAY4sEQrhkGD3gXyspIaoxHyJ7VdVjr8C41qLhF+kZ30wrTpn2EMkOkO/I1yu6QudBjzuJIKfz8DCMAJcdc61Z/OCBFUkBKnPId9nrUi2f5Ncopbd3ACOSWdQb+6W8Ul4Ylz9s589RMOez7VODD+bs1VJhIULclB6QMbKEDz+FK8zZ8P8xaFREpmNREa6AvSHwftQLKM+8mOER0x/tNUH1kPdLV4s42pa2EOXSTRFu/LFQaPWBj2LmnbjoT5dHGyL6KfwJIQM+6RMXFrO
 Pi7lATtF
 sSSK62Llj1+YbYCey/TM23nV5XBoJhRncOI66BmmI1f7M5c4vvEm9fJ0w5KvPnI7V3ZjN4f/jfYvTnbJ/qUyMwrEFr7ZJyDTEbZ4og5kQtilKj7j7nAL1RdYIZpKTWj3FihAvQxYuXUvWCbsH3fDzopgC/7UxuqkZk+yjNY218t/eI/OELEAdSk/RH1/ohNTpSlEoDtLP/NtiD+r6Ze/nEBru8dbW+5xVdOO2ihkq1bUzYdm+05aknaA3QeyX6DOGN/fUANLf01aV0TiSq5mVf5jBDg5aIzuammr135ruTDAzZdBlKpBkxGYJr4XqPPB1PA9sVLIW80SS2e6QK/+mC5d+6lMThHya5I0CczIHNA6sIVFs6/ru2xKzuWOPKJmFRw8ArbJFXK8Y5G9rTiQWaYzCBygjSXKYa9wleD7u2wI8wmDMr7WUD2SAfOPpuYzBCoH4T2mNHaBP7rklVCwy+URJVUaUVMzm+Qukgee8htBXK49FalHt/VWwn85tvXQX1b3T6gZ+lhSBisu3CbvPMi9nGnjlos5ps1CZpa2uLg9WgdDzIZcclsordjcnFOgrFXZ9v3FGVLcWywQXxT0N3IV/kTTMCZY2VMPq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.25 21:34, Andrew Morton wrote:
> On Sun, 31 Aug 2025 01:47:48 -1000 Joey Pabalinas <joeypabalinas@gmail.com> wrote:
> 
>> MFD_ALL_FLAGS is already an unsigned int. Remove redundant casts to
>> unsigned int.
> 
> lgtm.
> 
> It's rather annoying that the MFD_ALL_FLAGS definition is so far away
> from the other MFD_* definitions.  What do peope think of this little
> cleanup?
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: memfd: move MFD_ALL_FLAGS definition to memfd.h
> Date: Sun Aug 31 12:29:57 PM PDT 2025
> 
> It's not part of the UAPI, but putting it here is better from a
> maintainability POV.
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   include/uapi/linux/memfd.h |    2 ++
>   mm/memfd.c                 |    2 --
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/memfd.c~memfd-move-mfd_all_flags-definition-to-memfdh
> +++ a/mm/memfd.c
> @@ -313,8 +313,6 @@ long memfd_fcntl(struct file *file, unsi
>   #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
>   #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
>   
> -#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
> -
>   static int check_sysctl_memfd_noexec(unsigned int *flags)
>   {
>   #ifdef CONFIG_SYSCTL
> --- a/include/uapi/linux/memfd.h~memfd-move-mfd_all_flags-definition-to-memfdh
> +++ a/include/uapi/linux/memfd.h
> @@ -12,6 +12,8 @@
>   #define MFD_NOEXEC_SEAL		0x0008U
>   /* executable */
>   #define MFD_EXEC		0x0010U
> +#define MFD_ALL_FLAGS		(MFD_CLOEXEC | MFD_ALLOW_SEALING | \
> +				 MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)

No strong opinion.

When we are exposing this through uapi, wondering if we should rename it 
to something else that includes "MASK".

Quickly search for similar instances. For mmap we have the internal 
"LEGACY_MAP_MASK", but that's also a bit different.

There is this oddity that we store the hugetlb size in the upper bits of 
flags, masked by (MFD_HUGE_MASK << MFD_HUGE_SHIFT).

MFD_FLAGS_MASK maybe? not sure.

-- 
Cheers

David / dhildenb


