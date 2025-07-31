Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA7AC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 08:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B471D6B008C; Thu, 31 Jul 2025 04:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17BC6B0093; Thu, 31 Jul 2025 04:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06626B0095; Thu, 31 Jul 2025 04:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 927386B008C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 04:39:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4854511452A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:39:01 +0000 (UTC)
X-FDA: 83723909682.18.4A61AB4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id D5A8440007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:38:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WxLzntyH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753951139; a=rsa-sha256;
	cv=none;
	b=59bIJZYdvzhV4oBk3T9+1hZmLLW7SVK6+XWSrSZO24RSDmqAnbTcviw8Ni5vTlGU99mL9C
	/5FVlTe/HONSehH5D6t4AMyB+iPikgsdmO3Q0sIIxxHTQVtduLMwUa/y1QFFAiRcsxINw3
	Y623ra/MNPUZP2Mo0NlshiZdmT51/y4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WxLzntyH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753951139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AA41OZkq4L+02/o/hLRiV452c66z8cfHQCn8I1NCXJw=;
	b=lsSZLvo69wNXw5LJip8buwM53zx0uN1dBFwYP9wApoGDE8x2XQdRahYnXROD0HdToTzuYf
	ohCOlQkZqk/CFt9fb2Rc+pQOQeuHI45/imbO+/OUHpnSKnwt/dSR45M+Vd9CKZy/ZpYTC/
	fhjxlb2uVMZMTuTohlZHQ9g4qSQrQmA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753951137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AA41OZkq4L+02/o/hLRiV452c66z8cfHQCn8I1NCXJw=;
	b=WxLzntyH7FyDk511AEbZd3fTiwUZWYlWfmCDbiq8QcWlCwDxFxm+rv3dvf1XD149D8aTqG
	wSE2ThGrgFj0Xswcdd7JJYT2LnFRk5IgOT41UgAULZx6eFL/EprBYrNCGRGlNgHt7dxzEw
	CrGoPm3NYf+oIoQsesLAiPsGebp9u2Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-wWukKAALMeS3zsZyCXIczg-1; Thu, 31 Jul 2025 04:38:53 -0400
X-MC-Unique: wWukKAALMeS3zsZyCXIczg-1
X-Mimecast-MFC-AGG-ID: wWukKAALMeS3zsZyCXIczg_1753951132
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-458a533c069so1532495e9.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753951132; x=1754555932;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AA41OZkq4L+02/o/hLRiV452c66z8cfHQCn8I1NCXJw=;
        b=O+WP1CpU7dq4E86dFV09klHIvbuH7i3TzaKuQGWd0/KNTRMVns4Ngms++VrfwU7mHD
         ZGD3vyw8YKFW29Zup3lsd1ZGjlrkxbF5O1feN4ZZ1tIGK5sOYFZEx3Ko8iVyILEtN+ey
         tb1YMHeJ6i1GScfBjjituhe8oSLga9p1QZSVx0Hegg7lubXPfHMBuOhpm8ynteStYkkV
         eqIZJ4Cdb7o2sxRH3Kvxyllhvy3aclYn0DWsi9GkqxEBGXNo6DeyVr9fdOuZUG1k9WNc
         Oj97IUXeFmlUbaFflaECYJ+JgsJjT9SKYrndceDYBpMecd3lycwP5YREgeqYFjVfItA0
         t8Fg==
X-Forwarded-Encrypted: i=1; AJvYcCX/P4uYuE9KBWSl6ibkXrPX9kjlTnWmFNl1WsSVeNnCPf+UWxJHE66BBZHlcHwfDPKJM3DNlH7Cgw==@kvack.org
X-Gm-Message-State: AOJu0Yz1CpgyFjGf0viAqlURApqunHfhhzXKLtJ2HxrHftZmI8wyat1t
	Jqu5qMPkhclCSqgwTiEWH8XIZ02vNUfeFT7N4DfP/XBoHNTPkUL7BNg44I7TyoOmFkkdzP3Mpr9
	YYo/29bqERRe801ZaHPEXFrwm1atWWdxlovRGfdWJI3pZtnV7C/Ic
X-Gm-Gg: ASbGncuJPg+i1nA2WxrjgNOppgCjeD0J7wmG8eUV53sB7ApZV/lVeK9zFHJQzLYpj4f
	lTyVKSmZpfp543NafznvSmDoWw7Hcs8T8VPNB396K7Mp6twO4M2oeBIAKBXpm9f+L58v2VS6FOn
	Q2gjeYmu/Z+8Bst5rdv0fkKM+a90WiqptYUnjFcT4uRRnQRlGj5TO4llSclezaxCrB5STrxIZNs
	UKIjSYAYaJBA+WkpOhIDuYSTjJtWX3MLJ8eow2+mCcXJQ4Fk4CKG5wfBbzE9kIC8F5ASClDiQ1D
	gwA5kT17y0ii/eghdaYbaQpSh4ehv4W+29sWTkBUJhzF/pt8dgG97yRxkI69R0XI8zKSaXqNu9i
	l499PeM8vRLHBYVw0Ne2u+/jXUQCcym53jXPhGaZWDQngpli+uBg/gxV4t2XeQdqxXLc=
X-Received: by 2002:a05:600c:1f8d:b0:456:1d93:4365 with SMTP id 5b1f17b1804b1-45892bb8915mr51541715e9.5.1753951132296;
        Thu, 31 Jul 2025 01:38:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWD95wueftWd+w+Ju5Zdgm6ricJYeJUQ7nAZmLx6k10XU4lqB1FnCitjG3I7CTz+spdVnJqQ==
X-Received: by 2002:a05:600c:1f8d:b0:456:1d93:4365 with SMTP id 5b1f17b1804b1-45892bb8915mr51541305e9.5.1753951131670;
        Thu, 31 Jul 2025 01:38:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3abedesm1647621f8f.3.2025.07.31.01.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:38:50 -0700 (PDT)
Message-ID: <36cae7e8-97d0-4d53-968b-7f39b34fa5c0@redhat.com>
Date: Thu, 31 Jul 2025 10:38:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com, Matthew Wilcox <willy@infradead.org>
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
 <20250725162258.1043176-2-usamaarif642@gmail.com>
 <8c5d607d-498e-4a34-a781-faafb3a5fdef@lucifer.local>
 <6eab6447-d9cb-4bad-aecc-cc5a5cd192bb@gmail.com>
 <41d8154f-7646-4cca-8b65-218827c1e7e4@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <41d8154f-7646-4cca-8b65-218827c1e7e4@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _ZhjIMxMlK9i1rdZITn3ZmmwL_QDGJKo69-aY7c2hO0_1753951132
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o3sxpw9ew8eeyydpnz5u5z6etrfzooyq
X-Rspam-User: 
X-Rspamd-Queue-Id: D5A8440007
X-Rspamd-Server: rspam02
X-HE-Tag: 1753951138-945942
X-HE-Meta: U2FsdGVkX18oVOe5QiuxBWMXb3KlYYrrfxpkbUXYBSP6zh/g7r1izAAACv9wdpCtg4xIm4O+BRqSAbjWmC/epXzzv+UY97t3fYr6M2bWO8x/YFJN4TZmBt7FjpGqqew87k8vA2+86074smdYxWJ+lBFVkxdkQTh0iCz3mmUnsgtf6YwKZex2nc4p8nwFljKYp+n5AWJW6FjtkcrTmLH+iy/apBfdrN5KIengys2CH7b4F7cpATqXyFvU3O6krgWG3zMxj1aDW0M4QbelRhFCRMOFKEYCFZ0T2SolpKiPi2IR+mbijGABjW8FPafySq3xBSynP/qzxVnoI9kcSvZoAMgf9/PK8dQ4LiWMBHR5eJnB3N48hNRdIfeHDvonYmwzoenJs8QCA3AjIzF0NkGLQB1nWh7MoYQHP6131Exo1d9IiHds+ukcF7u6RbK9gCB68pufKN2WdiqL5xHuyGe0oingqpn0SUG+HOgrbx0mziygUAjWzJGctyLvU5dml8UfknWh25j/+KLXG1Vsjawu0ROdlbiGhya1vqDCwgSoTDmF+nElu9G5V6QpJQOBa7yJCPvi5YSnTr0UV1Oy+Z152wGByUh/p8Hgs64iXctVUVeIZfaCCTdvVifbiBma9GNbpNmm6xWKlNzZoJJv/2Uc1WRd0u4KlAczijCog8Scph/HWrOm3tNZjXk49ozyKqCs7gXGmUGBEDRkoGEQf++QHikDEdHq3RJt5PnoXgQElDz+lf1q9U37dADMQDCp19El92GLzH1Q1bIQIxFkVa6WfgSWdTGbs3R7FGx5IjakdfMmAu9jSsomiUGMO3VgNAl8yjxkIrvmLlgw6NyPVVFr0iXRTb6Q48gQ4k6U0/JqO3l65E3QpFSVfTlajLm+/IAYuBunyAdOyz+1RRiLKLgg6Kmk00Ja/ZMMeXvYdWWPNgmlF5s0k/17eUK9Kxlz7TMV2i2tRi4BK+uwbvGtv8Z
 Bt72fU2z
 /DaVIMULO1R5UFjOE5vsb0SxWhgmSCg+ks1vLM2eGTGo/ka26yQqvB3CYVMmnLwnK4VNuDqTGhWr/Jw5xBH9EgmtlDZ6qLXnPbNBJRw3mEQsqkl7Y0wHte3Gn2O/IpPLR63THwSMi01JJMcnQwkEbFSaSr0PDXf3dZAnbN3VDbiDuung5qi5JK+RGDpteHmrDx47M3LDh0bz5rhn+BAH3kFoW4yOfyTGr0cAXVz/bdt4Ih6tvghIcuNGL95/WJO6a0gYr8Z9G5fnlFA4bQfiMazV0ZwWpn7EN9QvC9ttjnhqsRDz43bvIzD9L6ZvB71OFgzCm0Z21vfMRV6CxotsRjgiq0R118BVjb7L+fyJ7+Aes9UU/YjYp1lLwjTfnNDdFHiTozADbVTfJOx1Ar2XcbHyHETqN37uxsfgr/6qy5pzRR2YKD3cIBSyQDTuD1B4iDM0Mwjn/Wk5LppRPsazYFy3C5D2pHuYskUtPerrjY77Eyg8LrF27RdKO5mJ4WHtoUl3WRU6y1uOBeapmR4q6BMu0WPOSNYeU+ohtk6xOQmI7bLmpgXsNhO9Q1OgcGkY5fIXWz0XCak3JWXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Lorenzo for the review, I'll leave handling all that to Usama 
from this point :)

On 31.07.25 10:29, Lorenzo Stoakes wrote:
> Just a ping on the man page stuff - you will do that right? :>)
> 

I'm hoping that Usama can take over that part. If not, I'll handle it 
(had planned it for once it's in mm-stable / going upstream).

[ ... ]

>>>> +/*
>>>> + * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
>>>> + * VM_HUGEPAGE).
>>>> + */
>>>> +# define PR_THP_DISABLE_EXCEPT_ADVISED	(1 << 1)
>>>
>>> NO space after # please.
>>>
>>
>> I think this is following the file convention, the space is there in other flags
>> all over this file. I dont like the space as well.
> 
> Yeah yuck. It's not a big deal, but ideally I'd prefer us to be sane even
> if the rest of the header is less so here.

I'm afraid us doing something different here will not make prctl() any 
better as a whole, so let's keep it consistent in this questionable file.

> 
>>
>>>>   #define PR_GET_THP_DISABLE	42
>>>>
>>>>   /*
>>>> diff --git a/kernel/sys.c b/kernel/sys.c
>>>> index b153fb345ada..b87d0acaab0b 100644
>>>> --- a/kernel/sys.c
>>>> +++ b/kernel/sys.c
>>>> @@ -2423,6 +2423,50 @@ static int prctl_get_auxv(void __user *addr, unsigned long len)
>>>>   	return sizeof(mm->saved_auxv);
>>>>   }
>>>>
>>>> +static int prctl_get_thp_disable(unsigned long arg2, unsigned long arg3,
>>>> +				 unsigned long arg4, unsigned long arg5)
>>>> +{
>>>> +	unsigned long *mm_flags = &current->mm->flags;
>>>> +
>>>> +	if (arg2 || arg3 || arg4 || arg5)
>>>> +		return -EINVAL;
>>>> +
>>>
>>> Can we have a comment here about what we're doing below re: the return
>>> value?
>>>
>>
>> Do you mean add returning 1 for MMF_DISABLE_THP_COMPLETELY and 3 for MMF_DISABLE_THP_EXCEPT_ADVISED?
> 
> Well more so something about we return essentially flags indicating what is
> enabled or not, if bit 0 is set then it's disabled, if bit 1 is set then
> it's that with the exception of VM_HUGEPAGE VMAs.

We have that documented above the defines for flags etc. Maybe simply here:

/* If disabled, we return "1 | flags", otherwise 0. */

-- 
Cheers,

David / dhildenb


