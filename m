Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF9A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 12:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h7Nf0VAi
Received: by kanga.kvack.org (Postfix)
	id 6C8906B00EF; Thu, 29 Oct 2026 08:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678CE6B05B1; Thu, 29 Oct 2026 08:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540236B05B2; Thu, 29 Oct 2026 08:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 292976B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:04:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8950D1C3A0C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:04:37 +0000 (UTC)
X-FDA: 85375531794.11.DCE67C8
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id A825F140005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:04:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h7Nf0VAi;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793275475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJSH14qka21Pa4IF7UBG6kGZapW9mNIllQsE6kiy4uo=;
	b=AlJpDveo+WcCUG7M3pEP57NFcdg3xO9fLOV6p0q0BS7hpXxVMsTGA/sN5gzZO672FofOvK
	akNw6g7LQPwPuzsSVJJXnA8wqdx1TfmjN3qztFB3yTCyfi0uZOdShl5rnM4DAUj3cuRAAX
	M5DSwc7Rt1Su34CkNkO9YcXFuBmrGh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793275475;
	b=BY3cVb6OJiSqEr1MQHRDRcCufOzmrQxu7RDt/r/gOcQ2ywV+ST9qx0FUJZZlLZCXOvKEkw
	y3b5yryQLaRbSbhgNVfnTTM75phGqVTVyIx0Q7ANLoDH4bSnilRUlCEIsbM8XwX7vuksRV
	qAWEMgQ3kcY1ZbcCtgdtnWImPYdOpZY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h7Nf0VAi;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48e46e449e8so1217547f8f.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793275474; x=1793880274; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bJSH14qka21Pa4IF7UBG6kGZapW9mNIllQsE6kiy4uo=;
        b=h7Nf0VAivrIF5RvBLjMBTsgftJZrWxslcyVFlc3yuTo6GuXw975CnkuuSfgNr+28XD
         jCGPOYBcWhpmNGuQkGdoDioZtO4x6MpGvHExlGr22MXZkWIyDTq2EAq81e25A9DzSzOk
         2pbQYPCN7biFakDafzb7hVb1m8L/JDvnjK11dT98kfnZt96pg+hWzpEhxPQH1ccp88ni
         WeRUM7T8wHP3R7noBLNeOtOv0xWjs4mTsP5IShOELD0SqVXlznQbv4Ax+lg/FNU/9YFM
         JaS1rvtZA0p8jdlxemGrnT8JObcAn8QFbIPPcPIDzKkFQixc9pxkigP7GfNekma0NMRk
         jJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793275474; x=1793880274;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bJSH14qka21Pa4IF7UBG6kGZapW9mNIllQsE6kiy4uo=;
        b=VCU3yU+LOrd6LEjWshsEjOvC7/fbvNdhonFBCmAhnRhwlV0WMcbMiPui3u85flVCai
         ZH6xUQZ4vo6XuHYGqTqwacdHmA1AZHXhp3F271S1r4CP5SmpcT0r3Qu2jy//gB8kxQ04
         fSajR8mlLbdgO0ExlWR6uJ08eafO/DeiDQtvvW+RbOoAmgnDoLwQAzOO2agzcriro6d7
         tjmLYs8YubwW7zuBeuttYNOZS0+VjsDdx+uWmkcsSQ+nlToO40VGOWwQqy2QsTMJsLwv
         lEh2HMDwAQHqyGXGpyJY+YXn4CcbjL+zmhZOnOCuvIhQH9Emo9D3feOIAnBKDj/i28l6
         B4Ow==
X-Gm-Message-State: AFq9FYLgsY7hNjU3v/cYu861o7OjRTIKjeDC475J6nY1iq0OUpKVYkVI
	yS3cpxLtA9+HaCWA6jZc848Ei8iihY1q1K2hV5uKcehuAumim9SUoysb
X-Gm-Gg: AYBFou1A9DmGtwRa868y0PeSNbJGvcInsPsB6LTNMw85jXMyjofnWqbADyiDVNufnRr
	SQCt3w7tCBh1SxaV8xXbe3/3gCqwGPfyJgz0rd0DGe7XKVLB0uIKQay3yGSJkXm/PrKlI1WdiFK
	+KeEJvdqPT+OulhNgudtip+jfQaPokSIBbqY7dxbSpe90S6F2UeFhvMHOj1mRVZn+MKfqwjLpkq
	pljfKP57wDMf6LPYYlsOg/9f3Bh+Z4VTrdMl6Gcjxr77oW2qyDSWlaSMZ6xdJeyik9hsfB8MM+J
	fdXjgIZpC+D5MM+uKxFHdD8+JMlyH3rcN2xdrocZu9qw8yN8ItzC8G4CDiIetIGkiXf4M86pdE7
	594gIvQ0d5D7wGhrJzcma63j7bKP4h/2LjFB8PzX7M+Csp5dIfLnigahZeR9LeNvsZJRmzkgVK0
	674CIY5ZoM8zRjDrs4YLnDfbQ/KN8asDuOpM6YWSIq9xcBeCRelljEWdVDeLcCKMgvBMOdvhg36
	e0GQqQbRb1naowY1et7SESp8IuWiLbbJvtSnshtmqRxw9avHHmMeqqcBNSyPjbA0dUuN4xIb1lY
	XwGoz6IfWvLSeHE3CP7Exp8Fz8CZUmHC3O3iDP/8sLPMnQ==
X-Received: by 2002:a5d:5f85:0:b0:48e:bf0:35c with SMTP id ffacd0b85a97d-48e5d2e749cmr13206928f8f.13.1793275473988;
        Thu, 29 Oct 2026 05:04:33 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm34237059f8f.25.2026.10.29.05.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 05:04:33 -0700 (PDT)
Message-ID: <ad048090-431a-4343-a08c-d8e139d52005@gmail.com>
Date: Thu, 29 Oct 2026 13:04:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/vmalloc: reject NULL pages in
 remap_vmalloc_range_partial
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ye Liu <liuye@kylinos.cn>
References: <20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev>
 <20261029-vmalloc_remap-v2-2-c4705cbf26c2@linux.dev>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261029-vmalloc_remap-v2-2-c4705cbf26c2@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A825F140005
X-Stat-Signature: dhoec6odqf76zrpmmurfhorwmnruzeoz
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793275475-103730
X-HE-Meta: U2FsdGVkX18zSBYms8wcjt4YxOp2csxs8ywuQNPYCNkiK3J9ECEYj+aEqayv7joAB26o/kGvck67vpKAgJTlTVaVLVWl3DGeQxbh4vGwdkSZiM7oQ+yrK1cLZOmYCY8uhWGLVtWRIaJh0la7EANy8AG9IGDTBY//lYm4QYWSX/pXGvl9/CHxkwc3XYxTy/I3ByLtgS7wWu3gjEuXxCzQlKZPOsPr9/fmODlOzYwf7aB26SpIQl+gZIzX7qgcyXXDJw0EHg4MeRwcnROup7/xiMx2Hlrfwaz4lBK2Cf6HgIX+kHUcIpgzO4ICDjFJLwZANfhiT+dbmRzcLW1Z53vezIz0MmDlTObYsHX0pXlbGAj5IecwiNKAhj43mGqfm9PDASjCMicIVrig/nA9oQXEZ4sGXEg2l70Shf+gGDWv7BekmupyUf7CxfeV5APvVR8jdajKg1IIcC4eSYbygODW8RIP5gFCBfYEJn18L4NWlDDxhnWauBFv5rvG5yGkKrP9lbTTwS2A1p/OvqMnR+/0dx3Gc7OuP01U7A4bdlL2AYAyGUYv1sTibCanckT6Dhdniw2uKeUqJb5MqC5h+0EVBSP+EJbagZe4NpvA28pni4CCVXaLg1o8vLtVXabhZKIP6cbwb7QKRelhxwJUFwTA0SrPhAo8wPXPLoGQKFB8YSZxBQEXu6Pw+Z8p29rSLANoMBFaBW+gYhKdxNmsMEES+hXKIa5Trm+FTVn20A64c2M84SDS5SkQDtP7rvIAUm1+CUE4IDh33utPYZm0MZ93uTf3RS28Bu+9pj0solhFu4BoK9bf4Qk8hgaHHfgzbfVrhTwo42LSsX9tn4KRnfrF8mhzjJnt6dd5ptXrPiej5O8N8xL7CYfTostwdGfsfXKzGl7DwK5shaqMwAY/E/CmLKT2eyeNaNT77MpYGqO6SGJGwA1M/CTRF9eOKygWlEf494cwNpOpr8uWcQidpoE
 YCyNcz3d
 Fv1Aw682Dpwjvk00yEVAq7cakch9I4jYT20DpRplFuA2tYNcD/Zz85VWFxLysW6yctAfl3h1Kc0ead6dknX5dxjvNSQmAffom6h1bE5vUqc+jIRBeroqos7W4agE1TRsM52U/RC19qV/h8ZhsSrJqF/0fPgNhoUhb9u3QKcC9v/g7WAwROPtlkizEHOmtZJvAQhGFD/Xe3VxVgqP4q3XSuDE9mx2tjYqg9w36mf6U39mFTSjciqyAoezwxzZV4ylNKmZXvPxOcH7hjFZ+WahHIHPiUFRE1CXnx2yaAVQZWKLLE2zIuuJpx+MAP7UI4mdNEb7NMXQUpl8QCACL8f9cy0IEaHBg74edw8VMTa/yCKxM2Kyg8aTpj70eTQjIdXXwAsjd5B8QgCSUzOM+1X0Q7catSxnGy1b1q79+QDgTJPDSxBgR3yzDghxssulyA7msfKXXD1qX7bqn0HKvOvdSg2fQ4OJm3PfDAFiUqc/klR2rPWjkVtlD5vLgpacjnm2NgXL9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 10:19 AM, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> remap_vmalloc_range_partial() passes vmalloc_to_page()'s result to
> vm_insert_page() unchecked, oopsing via page_folio() on a NULL page.
> The NULL case cannot happen today because VM_USERMAP areas keep every
> page mapped, but nothing enforces that invariant. Warn once and fail
> the mapping with -EINVAL instead of oopsing if it is ever broken.
> 
> Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a888eca016a8..dabef40ea88b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4906,6 +4906,9 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
>  		struct page *page = vmalloc_to_page(kaddr);
>  		int ret;
>  
> +		if (WARN_ON_ONCE(!page))
> +			return -EINVAL;
> +

thanks for picking this up :)

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

