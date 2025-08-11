Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C262CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F89A6B0113; Mon, 11 Aug 2025 05:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8C16B0115; Mon, 11 Aug 2025 05:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871536B0116; Mon, 11 Aug 2025 05:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 736CF6B0113
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:14:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA9545AC3E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:14:45 +0000 (UTC)
X-FDA: 83763916530.19.61F2E76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6395140008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:14:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y+GYFecn;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754903683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fNyDVtwXcFVF6hLJIgYOOwH0KI1rT63plVaXWTcfnI=;
	b=qa46ZxYvuM0vZ2+Tl4Oq88v8bZPr4xXOJ1RC6tmcpXRopQmvtTPJyB2vkFqQrg8624udtw
	iAY3wl3YaJG5VGUXQNsK6dbPPXJeXpXUXE6AdNC96lUJcaOiow2sHht+mfwNxRnBOJ4kZE
	jJCPOFTCeA0q7Cmyt8i5mx2NFPn7L1g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y+GYFecn;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754903683; a=rsa-sha256;
	cv=none;
	b=68FrtQwxbmDeGKWfDL8Wab3F6nswFZCluT9WA2RmJF5jPtLzqDNATYEJp9xKiAsJHtJ86n
	oz4nkLP+0QH1M1XiiFuTaDprWrx6OUiXu6tgWncc6RR6T9hMZZyKirs1OA4VxiT94gTrD8
	DNwQKYYIccPsb4FFLmW7JVSeZL2eI2A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754903682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2fNyDVtwXcFVF6hLJIgYOOwH0KI1rT63plVaXWTcfnI=;
	b=Y+GYFecnBHsCkTIsXIoJ4nvdGh/tmiiTS6xLbpsC0ZboVfHIeK6i9eM7Y4qPxSraWrAjW7
	G0gD3fwdFj+0ApEKZM1UW+oCtgtneMlz3W9VWcRvdv41hUVowWlG/pgEPFX913NzkH8Ftu
	UAe8OTDYf9kvfNGZtSgn8I7H9ZLuJNU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-l54ijIwYPj27cfG5fxCV9A-1; Mon, 11 Aug 2025 05:14:39 -0400
X-MC-Unique: l54ijIwYPj27cfG5fxCV9A-1
X-Mimecast-MFC-AGG-ID: l54ijIwYPj27cfG5fxCV9A_1754903678
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459d7da3647so35228195e9.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754903678; x=1755508478;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2fNyDVtwXcFVF6hLJIgYOOwH0KI1rT63plVaXWTcfnI=;
        b=QbYOD4KJFfvsB4+Z6M+plRt6PwdT9YaF3g4g9l8qQBR1RHkNSt2Ur/OD1jd2Baw8HC
         kra1tVDALym8dEVj2Hw/LSm2NM9RX8o2/GbwUJuxei6pmGp7ZUiqWic/pAmNgfTxVP8N
         HyWM21pXj+Kit4j77avyewouwgd6cfybAD70c8Rs45FnX0OMtdN1MsXKGOQDF7L0oWlC
         PpGBXdgqoZooJRCf1cHACZqqfTDYGh9ODoduKnIE52Z3bqltjWf/35kGXOteKSDPUMnt
         D5dRnIZw2ZxTBzhVQHIuYtyHqm53nMq0zdtqN3S2A6aBKvGSRQFYfppdR4xz7n6tTTqX
         oNVg==
X-Forwarded-Encrypted: i=1; AJvYcCWfhJ/3TMMx5Gz1ylomvIgEgADWYGaMDgBPpyOFgu7e+qexsQvQBzdoSaAeT1rkFXVtKpLqNEVpZw==@kvack.org
X-Gm-Message-State: AOJu0YyLGBhJAvdMSC35qtqlgkiV4guWFCkvmX3OIJ5V7uENfFF+fKqz
	KSAIoZkh64iqoAKxe1cXmPZwfL0ewYqsEAQYv/eLwgtVhTWKKjWbuJJWxQeXuGQb6R4Yb0P0Yls
	rMHidiQDfH32fJokC283DcebKl6QtsW3CATYCl3M7mQEgfHHw6tkr
X-Gm-Gg: ASbGncttQ7WujFK5LmIs4oCPzcu5pTyIDTHDP9E4bKWIrioqmSYS2b8wtWP1EyYO6TV
	I07LfM2a+cwO6Yo+dILJEkrZCrVLF7enTwKo3J5Vf6CeSlMzgw+MxlQ+vLMcyC5VKapUrSJtdI6
	vGSUhlroc3ceCJB/QxH1B0H+7jxBsrQVhc/yrIUm+yHpyag+TKhuiTQcFINU+o+ZIYiCjIMtdke
	ctjBveJxELve09EJyHKBoclM3T/unl2m74amdChPwf3deFagqjKyKhVkAEpXTJCrBRFJn90fFM9
	IyfzPu/LPzAnq0cuElyzvCtDe4J7JGiYbR3oQJ6mrYfiemzQ4nMnq3DXobnE/d/xkx/syDk5Y81
	kNSwa9J03olUK7EKKcJNE2sjw+u/ixfH/xLYfkQNhQVunp0O5bExqFT5D16YEhT0zEE0=
X-Received: by 2002:a05:600c:468b:b0:456:25aa:e9b0 with SMTP id 5b1f17b1804b1-459f4f9b5f6mr103953045e9.16.1754903678200;
        Mon, 11 Aug 2025 02:14:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPHMRHycPiy+F4MFFVFoafh5fxhbK676vx41t1mXGx/HiUt0UauyCHEIlhjR8E0T6r8o4KUg==
X-Received: by 2002:a05:600c:468b:b0:456:25aa:e9b0 with SMTP id 5b1f17b1804b1-459f4f9b5f6mr103952825e9.16.1754903677809;
        Mon, 11 Aug 2025 02:14:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459db13fc9fsm319376765e9.7.2025.08.11.02.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 02:14:37 -0700 (PDT)
Message-ID: <ac364fac-4ca7-41a9-86c2-f19388b32ec1@redhat.com>
Date: Mon, 11 Aug 2025 11:14:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: Use max() to simplify
 hugetlb_vmemmap_optimizable_size()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250810214745.2368-2-thorsten.blum@linux.dev>
 <aJk2IygsxWKYf17u@casper.infradead.org>
 <7fb6ce41-a5e7-496f-979b-775b8e30e764@redhat.com>
 <C6C36750-2C87-4C2B-B683-9789F55D34C2@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <C6C36750-2C87-4C2B-B683-9789F55D34C2@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cPH0YZ9z82n9PllYcuUwS00ppkLWdJp-K8nkqmnISl8_1754903678
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y8a7sdcxprxwc4d34ka4i6whkmnocuyi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6395140008
X-Rspam-User: 
X-HE-Tag: 1754903683-669124
X-HE-Meta: U2FsdGVkX1/bRB6sjisJxSr4ZpO4TkRPowLCbQDqSzAnuf5zpIgshRycJfSqsBweBZ3K4GeSP0OWNkyA4Gi9VxbYgMr5MpCq6oNiNbRWfaf+zpPJgL/BUigsBvC/99m4TI3KfLwBvzyt/C9EAwvwKT3md3Amz3CcMyqFMm6Us43USTui8+r4d21NX1TMDuqq6kZp+Ffbh6waFL+iRhCsQGjS3WV5WYkmH8H5ndpbUzAs3UjmzTSJ/LxurKU0gGlGOCwn3JXH9hdLgXQmpLe70f9LbxImT3OEtDlK/E8dRZ6pHtWc65VSG8j5gCUp7nC4kApzZDxMNoh+roRwSzq4zC3/q2KWraC9wcji8/AjLGG1CpbPeC05vzOoNzRsheuM2lDszMBqYR/RUZIzJGsr0ykdpmG5UxbHWFivzfncBzOslYIRAjte0kI/g5I/m3w/9yHA50mjg2Ye6l0d2R2NIoTs69ecxkhRomczbx13oB0nxQKbY7Jkx51hWFXIIa2YzXTnoh4VuZ45jCFXqPsS4tFcCjFfJtG1TRU0HktzDbzpypWHmrzF4w6PrKTm5whqDfCIlIKHRNUMXkoupYzMbd9g8M6pAvYRrfQnjCUhm16q1L9qSloR5moNfBMvRFfd1d3BxP5k512rRIfJNLCf4T8qVx0W00hFJoHJfLXG/bNlFkgEyWMAeDxufz0iJyGt5hHV64RaKbpJerPu3V++QJ26uAgh7U10KvhRes7JuYcGvDyfORg2eptj+fHras5Bcqf6tM9svHZNEaIpnMdbT6LrY3Y6jv1HYWgbNEJNSTT0NxDJ5oHf3pC3UCaqDsTIAHZxr/Ylde8nsk1clKumaCy7ORapxMIIjVZBoKKwCfMSX3VNjljvNM9hBOz2A0e/rqCaYPJBPMAoAqGNxjR78HykD7sexP/H8rTL58C/vxzzBavVPCnwpWjz9NlgaYNykcP4noTk9fyApJ3PHxy
 dqFH0avj
 tvyYlitQl+A2jh+m2GthOy9vIo91Z+y1hsyKL6T3BogXhdxmBi6KK4AS5sM9aBPP5eOWTIhhdhW79EVz3LqlO2sjO4mILGOwpS/cvH4cI++VQ95m3xpfuoChWr/6PtAAwaxwnStwkOaAPQWuRfcnPryF+Urb5SVTn/Fq7whFcDhhb6gLPIKTGdj9Mfe/XXr/G18b4vYd++CvgHRKmAZFmuedUZpIo413CW24tRFBJRtJt4Gp+CLcORAC+esyVsZOJhVMeuL5hu3R7dWa4JaUd4/jmM4Cm1oMsuIsAQifJnZhDot0ccDJRCGgG3mEoqiJ5wX2dWH9P6bzztA8P/08IC1D2Iej6b+HZ4CEGxdwOBvXGMSgTqCAM0eHXC4fsmoWovsNrxU5bVQS1FBaqXXkttDUO4sem/0JlrzpeKKusj5DYEWfnwEgaaQRVeqSpWadnUjv8xYQIU2INy4by+9qClSi/Cde3lRambBzISP0aOpoGLabMy0FPQxTKBBV6aOPfgJtM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 11:08, Thorsten Blum wrote:
> On 11. Aug 2025, at 10:26, David Hildenbrand wrote:
>> On 11.08.25 02:15, Matthew Wilcox wrote:
>>> On Sun, Aug 10, 2025 at 11:47:45PM +0200, Thorsten Blum wrote:
>>>> Use max() to simplify hugetlb_vmemmap_optimizable_size() and improve its
>>>> readability.
>>> That ... isn't clearer.
>>
>> No, it isn't.
> 
> I guess it's personal preference. I'd prefer max(0, x) over a ternary
> operator any time.

if (size > 0)
	return size;
/* Nothing can be optimized out. */
return 0;

-- 
Cheers,

David / dhildenb


