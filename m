Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C04CC44512
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 01:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81E06B00A2; Thu, 16 Jul 2026 21:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59196B00A3; Thu, 16 Jul 2026 21:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A959B6B00A4; Thu, 16 Jul 2026 21:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E44A6B00A2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:35:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0E31A03A2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:35:14 +0000 (UTC)
X-FDA: 84996550548.22.EFC0484
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 066A4180002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:35:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=thluSFv7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784252113;
	b=E4IxA3filvwn74hO0t3YejjBWlIEutEOqGqInNBnez8xo4B9q6XNKufPtznUuHsCG9Z+Y2
	XxRIKAnAB8FIhwUS70VySG/waC02MpvKmuXmP6sACobeNj0dTXJhY8fiSyb+gTnQeXFdwp
	cVzTFVrVs6BXM0zVj+s1UFO2FWevq1M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=thluSFv7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784252113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEYuMCvX9cGWxVz0he6+RioCqg0TNaupBeoE5F9gTOI=;
	b=XUXTF4CtmAE0V6Uf3hoFQhkbU2CeyjxWSMV+Tib/sq9Lio/NxBM1aGKDd49NDQ8sG3oKAB
	0X0PDEtRDSlLj8K9cSw2hBafehpFc5zwQSovoGMx5OagSIGIE7LutBLpuY0rTRAzPk7atw
	unkwuuIY5CFiJXAXvVaIeD1KJErpVgY=
Message-ID: <cd922756-a4b5-4666-af7a-4071ef902375@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784252111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WEYuMCvX9cGWxVz0he6+RioCqg0TNaupBeoE5F9gTOI=;
	b=thluSFv77ZXB8LbpbColp+RfznUIzmfFkNANm6bFbZhCI0Mj7bHQYUrq1uBavmsQH6lmym
	b+snr83+KaGxdSVXQgN6lCoKZvPITJ9DzIBQrX3z6BnfFHa0zj7EyUaogvYM4186wnIB9W
	YRkjEiFWdLNlNCFx8/NShH9n0+vMsFI=
Date: Fri, 17 Jul 2026 09:34:55 +0800
MIME-Version: 1.0
Cc: hongfu.li@linux.dev, akpm@linux-foundation.org, liam@infradead.org,
 vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, david@kernel.org,
 jeffxu@chromium.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/mseal: Fix range_contains_unmapped() ignoring its mm
 argument
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
References: <20260716093347.75055-1-hongfu.li@linux.dev>
 <alit0N1CBEllrD0U@lucifer>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <alit0N1CBEllrD0U@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 066A4180002
X-Rspam-User: 
X-Stat-Signature: y4uxjgprzkb4d8zu88u3ygawjynor47r
X-Rspamd-Server: rspam03
X-HE-Tag: 1784252112-560849
X-HE-Meta: U2FsdGVkX1/CvR6hf+zFTczkgzxMeoHadCkrOh8ATd/0fY+Xxl/XhGz3iHXyzWQEtMg54fFmzARySlPiBn2oqU2xSkxauyWC8o5bUU5+B3uTLJLSAOtWdlvp3llnVcwbJa6NFapnlpGq1M9OsYro4OUYwFNk5CXaWlj/XivwWHDhrvHJPBRsq4zQrpjPuXN8jIHU+q7DVgEilHcPKUcPh9O6l/SPDiLlSy1c2yM3k2XtcOcUGG0GGgqSTWtAauztNVdS8fScgoZV5W/Ad3Va+2b1o2e8ad51iAt3XvEOXH83pAvJ8wM9OWDeCWD273e2fWGlRspvgFBmtnzuEfgNg6XRWkri66qLR7liEmRa6uY/U/3CaCIhqYzrFcYft9oYYliTNNXna3A1KHJjSHsAfGB/tiSI3D2I7C/rT17hRk39Swk2mGC1EzISJ4A0LjXUf1xbUt7t2Xe3ZIWSvpWIvi+LEqtqPP9NKz1eXnIgQ0ENHRz6QrT4BIvZC/xOPtWDl/2H7G6Jm92yZfYeituQBdXQm/pYmEsKclZxyV16yNWXhVpqR6J/G6iW4OGJY0H8k8oASNJ5ioCuHOBqnXN2XlPwxAe48jxSKdscLwK6k3kbSo59AmrBmpoeKoMPwpE4FuhcxgdMu34BnszgM8FL21mWMjp7hCcon0vr3z3cXrrdqnZUgWgINl/AQZM5YkRVhQLGRfY/BW85n94vdpwL7RXb5K2FoLW27oayFHZlc8kuWszlK/fI7eQykAfURoVgtefxxKjkT2k2ps0a9QH9NUoaNZc4hsNyBFY700U8mmYNBIAiKfkfTKm6+fLCIovpvgfCS6siWzwamcL+8ZvV5hkVRPcUZEhIoGIIkOoI0HJvyH4rQFD+iTR/TGwnjojZU6X7ymFO1hU3aHpkf0G4/Xn1MW6yumEC0GjxywPtbhVXv5ecPiE+QR2kiRy3zTS6QePrNb86PancCHKS+Od
 Nx0m38Vg
 0cppHkVR3sDmH9gExB4zDQEga0cc6j2KnrmBmVR1MHNzuQJ5Afyt3NxVHWwmwP+OtQGFccufB+Kr7PjYu00qXy9UBSGyWJftgjU9bdXjnVEGx1zktCVRZbhZqA76oJ1FA9r4D5E2ScLhashNB8yALGEaJwk/kTt64RMgi+0+uTEl02e+7XYCBv7Vuh7+VCMKpPzVNLDPfgyRcKmQksXz4BxSLFCXPtlrKV1NbDsJULcQe0e6Pdp2n+OXl9DxRyhAsUZAQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 7/16/26 6:19 PM, Lorenzo Stoakes (ARM) wrote:
> On Thu, Jul 16, 2026 at 05:33:47PM +0800, Hongfu Li wrote:
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> range_contains_unmapped() accepts an explicit struct mm_struct *mm
>> argument, yet hardcodes current->mm inside VMA_ITERATOR(), ignoring
>> the passed address space.
>>
>> Its only caller do_mseal() currently passes current->mm, so the bug
>> does not manifest right now. However this mismatch between prototype
>> and implementation is a latent bug.
>>
>> Replace current->mm with the passed mm parameter to match the
>> function prototype.
>>
>> Fixes: 530e09096413 ("mm/mseal: simplify and rename VMA gap check")
> There's no point in a Fixes tag for something that's not a bug.
>
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> ---
>>   mm/mseal.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/mseal.c b/mm/mseal.c
>> index 9781647483d1..8d82e50900ba 100644
>> --- a/mm/mseal.c
>> +++ b/mm/mseal.c
>> @@ -41,7 +41,7 @@ static bool range_contains_unmapped(struct mm_struct *mm,
>>   {
>>   	struct vm_area_struct *vma;
>>   	unsigned long prev_end = start;
>> -	VMA_ITERATOR(vmi, current->mm, start);
>> +	VMA_ITERATOR(vmi, mm, start);
> We're never going to sensibly allow a remote mm here, and even suggesting so is
> problematic.
>
> Sorry but I think it's just easier if I send a broader cleanup patch to fix
> things up here more clearly.
Got it, thanks a lot for explaining the issue with remote mm. A unified 
broad cleanup patch works better for this code path. I will withdraw my 
patch and follow your series. Feel free to reach out if you need any 
testing help later.
Best regards,
Hongfu

