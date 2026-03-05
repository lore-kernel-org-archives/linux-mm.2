Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16C9F30946
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287D76B0088; Thu,  5 Mar 2026 06:16:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25FBC6B0089; Thu,  5 Mar 2026 06:16:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B7B6B008A; Thu,  5 Mar 2026 06:16:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 040646B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:16:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACBFB13BE6D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:16:11 +0000 (UTC)
X-FDA: 84511755342.15.10285C0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 049671A0018
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:16:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gwRCWLIT;
	spf=pass (imf19.hostedemail.com: domain of 3-GWpaQgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3-GWpaQgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772709370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAPg6eWb0oTea+TfR2D6Hy6n2JsKfxvodDgnN4a5J6A=;
	b=f4CbsYa2kJHJ4y1ic1ORpxRXttYow9W+WPVBvmsjK3z3y6quBlsYRaknzvABHcQPzA429s
	OLnQBuxYbTG7E/HUAVEgbFc5eBJ2DSt5w0SlJdcoWr2ZxKUZZDI36WuH7dzr5XuSxMF1wt
	gFkbweNNbTgz3heMsX/Umb5+B0av2rE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772709370; a=rsa-sha256;
	cv=none;
	b=eaTFwom2+HSJ/HTLFWdytfwNDjXoLoNSRF9EGuzp6cWy4yt2f8zUu9d1IoAe+T+30knHf5
	7B6J7y7zOy/3oltOqg98aGhl2LIZMnKV5htfvFhuX7+dPpIfmOTpOqw6m5MeBpxIaRCkbr
	DWuH7j/vr+NU+mndE1gmRhZhj7g0Ay8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gwRCWLIT;
	spf=pass (imf19.hostedemail.com: domain of 3-GWpaQgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3-GWpaQgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48379489438so77507755e9.2
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 03:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772709368; x=1773314168; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FAPg6eWb0oTea+TfR2D6Hy6n2JsKfxvodDgnN4a5J6A=;
        b=gwRCWLITS2N8EzRdCGwQzvmp3XlFb8cYzJPO3ID3+0PiC0VMD1TvjY/OyjJXjJ+hEO
         GBy+M4dks7YeBwGPWCn4WW6WhQQeFxJpTJnF8jziPoxOndNjF/soEgLRhkcxinfS9jn2
         lpm7JEOvzGRYfNsgleP+hmqA/r/SmqrvqQvMIDT/Vxexo1Ne4xwr2Ln77mSFMTyi/IYI
         ZUCPG1M9kJNKqs05sxHck2zKgxkRsuuskJDA26geh2Wcd13r8+mtHAyzJDfiQMrOMzgj
         al7dNsDqc8fGlXw0W0FB6vcnFkg/Uowcg4AOtWYxuph+WM8dlZDiD9mujgp1p+lqfWIA
         V/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772709368; x=1773314168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FAPg6eWb0oTea+TfR2D6Hy6n2JsKfxvodDgnN4a5J6A=;
        b=tXu+JA4nSqPzeDyw9lbeub6xDsbFeiCpFH9uWMbO2vbhcEWpVEmTbM/Uyy5gPmXQCT
         G0OVGoCzzwhx0jSXex3qVHx9m90DTEuYU+Sb+LEWG4mCFDBAEinNoSaZ0aDIRVC+0nIz
         lOggfp0QqYA7YrNrkXKT7QfHtL/nBWHYv+tnQ1kdPM9TuvlasEoe3vGa5zp4pYZCB34K
         9xSKpgaPFEJnPLRdslffgV+LmTGQwmYqhrZ4slMkuNpJ5CQL7CPVbgjqjQv9AWHcSddV
         fCUfpvrLZYYECgR+/sUnqkDmqy0HroU8LTfPhqAkIkUz+PpsllcV5PXNWnSqq+KvdtbA
         eV+Q==
X-Gm-Message-State: AOJu0Yx1GvhlFXjHVVw3SQfp7FCjCxj5HhQ8F1+vjWfki6aosVoy9wOc
	9+0w4sUIpLBzWjVo+7dpS3yOGwKt3hUn/FusDCJQkQkGPgZ6GGMMDkMyT0gYJfou8AINWpnpmZo
	0kt4BiwXnnzbaow==
X-Received: from wmsr1.prod.google.com ([2002:a05:600c:8b01:b0:483:944a:4936])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e11:b0:480:6c75:ddce with SMTP id 5b1f17b1804b1-485198b33a6mr103114855e9.33.1772709368216;
 Thu, 05 Mar 2026 03:16:08 -0800 (PST)
Date: Thu, 05 Mar 2026 11:16:07 +0000
In-Reply-To: <6206d021-e6c2-4899-b426-cacd71ebd5ef@kernel.org>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com> <6206d021-e6c2-4899-b426-cacd71ebd5ef@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DGUT0WT67V0F.32RH4R5HZ91VP@google.com>
Subject: Re: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
From: Brendan Jackman <jackmanb@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 049671A0018
X-Stat-Signature: 94b66uiyhqo6i4ybu9bu77hgi6kzwbnq
X-HE-Tag: 1772709369-910540
X-HE-Meta: U2FsdGVkX19s4WeSnz1pXLdiHQd33XIWsMt33kkptjdwEk8282pnHIZNM3Nhh93znM7njAIPnQxpgJS1mnuILqV73vtKOskBbCgZXNnswzC4M8BhU+MaPvjz8rDIZRpF95T/AXDzOMY3GCUTKh06YVkhyx5VZH43u1XLCd5MB/HKjadMZtF+5aPd+06RnFcj1/KzPkiqXmLdy8CO7ut3Oh0YgnSPtBCBF/o0z/gF4Dm2HsBJAYDLBdvOarseFP79lzSIrIICO3eCeqfbaZejpJjv8e6Veb3Kl1Hi8+rr7cpaADv8ccmL4T/Us3SN8cAmtTtis6H2zy4H9FFrkumQkhbv3/yeTItpmfFqjrom3yyRV3xgv2JB0Y94boHG/PAmwKlhRDzy9vOjF7ghK0652x9TQ+6lV0ka8fiUxqYeM32O9ybJkkBM86tmVshp7W7WNGTBC2YJbpWMATTMASvOGVtpq5rk+1IoatPDF/ZKQbHldERuQQ+gaDiEXc6ib3vVj+Q6wpaS8pMHxSwk2B6Nj3g+n5hhWz9hdeEKI7QkCX20YMOVrqbvgD2eMAMGIl3BRxTX1SzyQqto9XN7LcbimHsILwaIv4lDcjF3VerLgEcOyPloKjYivK7B3OP/6wEJbzoSX71llPaFI3KsQGwrAqF7KzWRLmgvSUS1PVT0f+T+ULQKNbzFbMTS6nj6HpVIMmpUUuY95HBmdCi6Xy2zg9DLzepUC1sv66io/8U+f8iDD2zE7NDX+T+PRvUw0faIxHRrSWh9C0V37hH0u8vzo+jf8Y6xwr1dyR/rTWilYkkRWUaaF0ZwkMa99ky30c+3hxmQbSlR4I4kftlF3b2D616i/p9HCJaMWe9IzsyMLFmGYpfCOES6W28f0oRM9Lo1ZFvfyn4YA5xCYIX1AQRHmfeDZVb6ZNpI0fOGZPr9DhFZ81D2NgvAJSBvIVfQrvwtvF/NibiIezgNyIS0Fvo
 Hl1/58PA
 mur9wCqpZavA9GImC7jzTd0e9FuMJBD6baA6x8L8+3M7V9aJUuOBtb9im5gDOROOTOkCS3nLBXBCPqTS4yWSUAqdsyQU2Aee4FkQ4EJJ8WTaG0qlx8kmmPlVpzQJ6FnctF/1+KOyNlnuQDF36mI1mWt4eaXwG6Rc7POcjAyw+imQMglydrySApF7ouZNpJ7C47mfPBO/dpMv5VZmLGl9pcI4IuuSr4tMwDjkZvSKNLRovmLLixbMH4uj9Us8S0u9SdCXN7q9LYCXq6DIgEyyscMPukwrvmvJDPpYlavyM3b0WMOHcDaato/ZHDsfCUsUQfncU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Vlastimil, sorry for the delay I've been unexpectedly out of office.

On Mon Mar 2, 2026 at 3:36 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 2/25/26 17:34, Brendan Jackman wrote:
>> .:: What? Why?
>> .:: Why [RFC]?
>> 
>> I really wanted to stop sending RFC and start sending PATCHes but
>> getting this series out has taken months longer than I expected, so it's
>> time to get something on the list. The known issues here are:
>> 
>> 1. __GFP_UNMAPPED isn't useful yet until guest_memfd unmapping support
>>    [0] gets merged.
>> 
>> 2. Apparently while implementing the mm-local region, I totally forgot
>>    that KPTI existed on 32-bit systems. I expect the 0-day bot to fire a
>>    failure on that patch.

> I don't think you mentioned (at least in the cover letter) the mm resistance
> to add new gfp flags due to number of them being uncomfortably close to 32
> already. But I see you've put the new one behind a config. Together with
> point 2 I wonder if this is where we can start making some flags and
> associated functionality 64-bit only and change gfp_t to unsigned long?

Yeah, making __GFP_UNMAPPED 64bit-only would be fine with me.

Ultimately the fact that we have KPTI for 32-bit makes it sound like we
would also want ASI for 32-bit, so I guess I would still want to add a
GFP flag to support that on 32-bit. But that's a pretty futuristic
problem, I would say we should focus on __GFP_UNMAPPED in isolation
right now.

(Just to be clear regarding point 2 - that bug still matters, even if
__GFP_UNMAPPED itself is 64-bit only the mm-local region is separate
and needs to be correct on 32-bit).

