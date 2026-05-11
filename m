Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 091EFCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F98B6B0098; Mon, 11 May 2026 03:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9A76B009B; Mon, 11 May 2026 03:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5446B0098; Mon, 11 May 2026 03:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C26E6B0098
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:35:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16333160542
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:35:27 +0000 (UTC)
X-FDA: 84754328694.18.1D68444
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B529100016
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:35:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eeOJ/iWz";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778484925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3CkXWIilw8UN3GoYJIclPz83PpKjCkHbFgLYvKf3Y4w=;
	b=M1F8C07DomFL5f+gO+vySiWebPKGwv7SIgoMZ1GDrfSOr58qDVnKJUoIPjm+IHRJRRT4zn
	0kYDBA2ZJyhCX/9yP7UsKBCRPj5+6QxDvJdgLF82sNLQLwXZtLt8D+/Ng8eqhz1D+gofTO
	E7fX/2TILQ5UjZeS1x39TERak2Oj2Ck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778484925; a=rsa-sha256;
	cv=none;
	b=sszIBmefngMJVf280sFhQhUVztbYspLR2G4ljNSftWIlqxSfDfVx0E9zxaV1xjyGinSnLD
	A8w8qrWqhTG9WO8vHBkMTQxU6zE2UwXizYS7b9B++SOYiaRK2z0bZwruN2xpqdwah3xIGv
	SgXcuApa2X8mSomtaNE858/VhOniiDc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eeOJ/iWz";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2b941cd869cso23214525ad.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 00:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778484924; x=1779089724; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3CkXWIilw8UN3GoYJIclPz83PpKjCkHbFgLYvKf3Y4w=;
        b=eeOJ/iWz1z4pFL9qvC2LAPyCVH0PX7a4nVuZriXKUJJN5ZRlt19cslCUGk6AdCI71b
         1k8KxP43wq2wzyDvmrYTUnW4zeaiCbPsCtM9dAXSG7EV8D6qXgGJ3tj1viRPlJb6THHY
         6x9pV5IYHTpbEGa5IkvjuaxUBWJWcEm+uERD6iKAaE0YtaX+D2lzhXjitGHHVfjxB+UX
         1ci6mWKFXGDlUWyJeHYZjGgSCytKwVDrgajrtjXIqtCPuRsTAJ6uPUPc+xkirKrBqQCa
         EHmZLDmLhkPNvOCho+vrNrRZKoaznd6lkX9LVFJK/y/yM8XHr245tok/qqOJ1p2CM7Dj
         ju2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778484924; x=1779089724;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3CkXWIilw8UN3GoYJIclPz83PpKjCkHbFgLYvKf3Y4w=;
        b=IOflN5+27FtpuCwqJjjR5kUT1n5Zj7XPvg2Ar8O/PYW6jDosR9ta94K+4b7BxiqM4n
         1KTFfSsNS0Ocl9vPLY4QYfoBnHj6/dedSLXNOGS3auKwpnZT1q/NaGMwlKANarEpekaR
         fg3ZQNXyqSRIsozzMGvembpAI9FKY75PIOvOQu0MT8tMcInhDx0nK33jKvAuVqyyUgOj
         PvyzjE7MRbMyTpscv0SYMBp9TSsuHQhskZbSt3A5IA5Qsf+PINSG8zdKoEabwN2IRgUs
         Xg4JNAAGZsjdlMWswF1H6+KGRgJvwUIRWY/Lpd5q4+EKeBDenHRrux0DfDG11Qr0CoFO
         hMKA==
X-Forwarded-Encrypted: i=1; AFNElJ+Ll5vx5GcXCsZ806mFGfl+tZlV0dqR9DKEdoNsERWfyRiaopHkSg/WbqD7LgbpowiLirTLKd5xWA==@kvack.org
X-Gm-Message-State: AOJu0YzaOjgTZfaVfBnLG71hFDKH2r5M0UI7PHPK8VWPDyUCiLHhjA/r
	fWQcp/rDPGRdW1E6b+N51sVX9PGwqSyXrFJIR7DUlJ/MMotHi1rr240W
X-Gm-Gg: Acq92OG105otw32VuSIto/rMdFGa7l/SMbgT0ZmbsqKlcuJndL3OLT2zd15iKQ+EeWy
	Tq/jytKivqDFV14AckHPxAg2VCteRWG+WrUgdnYjyNW9EsJWLYY8jRZPMeDpoCWa3dMGajWp8FC
	f9Yj1nE5QYS3A4sPmC1Un4M55niaEODP+IyeQ+wuR7ZAuLiMqxptwql8q3oLJD1UuOuSxjLI9th
	MKn6GF74HKxUFs7AYPJjgbp0/7WuYK0SOpr1blDXlU/p3s5C9mQaZly8hT8Q0wyxcTiPzWJGYUb
	RAUy1GpzMj22JlHK+Sxm9mnQRSPTx6o4ohk6gRVSmeRXxcbR/0AQaULSDDuGd6+5oT0aQGt2Zn2
	QIYDKXnRSTpCEK22AlM6sSS5+l+aXZpVwPlQtKMeRsRB3DW+FKm0bnlPgjBDEpTOEdgNB7eq0hX
	0nYoYis4dQDokUXzhVSbFCLPaMBXvsOLs=
X-Received: by 2002:a17:903:2ed0:b0:2bc:b80f:677e with SMTP id d9443c01a7336-2bcb80f698bmr48255615ad.25.1778484923962;
        Mon, 11 May 2026 00:35:23 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e358b2sm89703165ad.54.2026.05.11.00.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2026 00:35:23 -0700 (PDT)
Message-ID: <4e3d0c1b-af33-470d-acb0-1e6540ba312a@gmail.com>
Date: Mon, 11 May 2026 15:35:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: avoid underflow in madvise_collapse for
 sub-PMD MADV_COLLAPSE
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
References: <20260511065701.799006-1-chenwandun@lixiang.com>
 <cff99673-ba36-41d0-add1-e2738f95bc4a@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <cff99673-ba36-41d0-add1-e2738f95bc4a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2B529100016
X-Stat-Signature: zfx1i15hqy8zjybutkwt645rks8ihpqb
X-Rspam-User: 
X-HE-Tag: 1778484924-143857
X-HE-Meta: U2FsdGVkX1+1JhD7OxMXwIfrZS72ll9+0SV+iyuvJMxr/krkGjD8Wte9ZGeUdJ503FZIXZGK4GTt1bjEqt9V1r+8hB/O4WbgzHghs4NiS+0mWxc/HY+jE22kSdAMjscksa6KRMZa7CxJ5UdryjKdqmCVMj4gfNvaMGyKTmPe6slkjdyD92YytWVtEqBpVspj7Crl60ozXpvtJ5IZ0gAFyCnA2f5XBe6GDeT9l32OvDGxPsTqZvFUei+dvnHYaG9N83mQFKQEdZHHvU5rrcDCHnraoIgWYpkDCdIJUNucoGeYDg8TKDdc39CJspgxc9/zhrq/zve3ixRsfR+GdZsPCDMTPcge+6E/F+tKeNBtqDAytqCVbBnumAlBsoAZea03Ed3+OpdItJltKzN5kSj6iUCnyR+Md5617e80b7FNtSS0bC8gnZZpLZ7B/16rVrckYSsFXzExR9OxMJXkIPmAaqHw6Icc1OTtarsVDYC/O/3hKH4Hs0qTfP5j/m6VG1ygwG8HKTllLZqA56AdL4OOV9gQM0CmWTNHPrAjB6Y0RyHVYUCw7WnFC8+xnAKfiIX7ZpkhROr49e4I59I6lMYTVGsOZE82S3mYqQVNvp72QmLKk1jtlf3vMdDUsglHh1cioF/sS0vRjEH/X9fA5mRkPJrA4S/Z0/etrCOHqP+i9VgwhywItj+GMLntlb6Ez3sXWgOsSmzOUPlY9BxyIqw/c5ayifx9oEYmtaFVZ+QpWwwebrBN0f6XXMPfb3FMCaUxEydYIMP3wXUYbf3m4XIYlRG5+xEwt7Adn18gfCQdQntj1xfFzg78hXo21v08YzS726dGiACfJl3ZGP327wdg7ue9iyUz4g0qzjT/nJfwZnvprlFW1zj6+xTLdiaN9Camd1n83hBxd4U3kbmDcZY53S3hmgUhVjJAw57y9S3RQFB6Yd7BllPYqya6CHknjwfFMWZ+34qwQtZCciuwUFy
 5X7r1a2T
 +iSvm2Q+YFrl0sCWWPGZcEHkSS2xxrtB7dracrenuD5f6oThSp+xmt2xxDSSwUdAuVSG1Z4UVd/YvKALkFHgX4QKOnu623etKMTqaFf+dipxmzqlY/OdLi7WwBwWz1FjEJd3nXCVA0Jk96fHo9VSgyGZ6re3m0c8CPreG7gD9dCzYugdxgNzyJA1q0AXOQRGs4Y0mpdfDgR6AXBbZj2vQxTAkdZtG62ekKNSy90p1UieKo2G1r+UOGWlkkKWk+XymB9NB4gyjlk96lcD7nMUuQHXvP7c8nSMNCpZ+GfcAzGT3G71/tV7O/nkbHHAExd3mZF7zm5at9kk/EjbOnfpbLpSDPKv9setUxPp2TPIo/MkhjFQ6flm837S+JR2f8ZzDUliqVih3D7dr9FzeAuswX9W6YmGtuBQ9GOmogvNp5bvNTt87ZzUGX4lkQH9C1t0XXpyMlLyG5cDOFF+/dFV+QnrjU7y2Stga6f21BOIp3+tHK+mV9/vM72cXks7velVnv6MnOrvzu80he0hvY0kdb2CVD6z4t21MCVoUj6L0epJSyj7jgDom6IWZI7PGE7NOvFEmVG1kW1kKRGoK3BQJwEH7tgP3B3XR0XlbKbmCJWwclUciGYUsn0Er0tBQ4Ao+XUHk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/26 15:17, David Hildenbrand (Arm) wrote:
> On 5/11/26 08:57, Wandun Chen wrote:
>> From: Chen Wandun <chenwandun@lixiang.com>
>>
>> madvise_collapse() computes the THP-aligned window:
>>
>>      hstart = ALIGN(start, HPAGE_PMD_SIZE); 	/* round up */
>>      hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);	/* round down */
>>
>> The following case will cause hstart > hend, and result in underflow
>> in the return statement, avoid it by returning -EINVAL early when
>> hstart > hend.
>>
>>      madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
> Ok, so providing a PMD-aligned address as start will result in 0 and a
> non-aligned address will result in -EINVAL.
>
> Didn't Lorenzo agree that just returning 0 in both cases would be clearer? But I
> might have misunderstood it.
Lorenzo suggested retuern -EINVAL for both case at the beginning,
Later, Lorenzo add an correction, suggested should return 0 for
compatibilty reasons for hstart == hend case.
(If I haven't missed any information)

Best regards,
Wandun
>
> That would also make the code easier ...
>
>> In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() are
>> unnecessary when hstart == hend, so skip these operations by
>> returning early too.
>>
>> Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
>>
>> ---
>> v1 --> v2:
>> - Rebase and resolve code conflict.
>> - Return -EINVAL when hstart > hend, suggested by Lorenzo.
>> - Drop Fixes tag, suggested by David and Lorenzo.
>> - Updated commit message to be more explicit, suggested by Lorenzo.
>> ---
>>   mm/khugepaged.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 28a843f30b32..36baab17f098 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2837,6 +2837,15 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>   	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>>   		return -EINVAL;
>>   
>> +	hstart = ALIGN(start, HPAGE_PMD_SIZE);
>> +	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
>> +
>> +	if (hstart > hend)
>> +		return -EINVAL;
>> +
>> +	if (hstart == hend)
>> +		return 0;
>> +
> ... as it would simply be:
>
> /* Nothing to collapse. */
> if (hstart >= hend)
> 	return 0;
> @Lorenzo, or do we want to keep the (questionable : ) ) existing behavior?
>


