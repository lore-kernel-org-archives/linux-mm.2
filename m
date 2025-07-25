Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B348EC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493576B007B; Fri, 25 Jul 2025 14:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442776B0089; Fri, 25 Jul 2025 14:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331B66B008A; Fri, 25 Jul 2025 14:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24D496B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:23:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8A571608C9
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:23:13 +0000 (UTC)
X-FDA: 83703609066.15.5BA203F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2429A180007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:23:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dc3F547n;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753467791; a=rsa-sha256;
	cv=none;
	b=PrfKkzPqDyvj+Cvvdh1IsLahO7N3khE4mZLVUDOrz2VMjYvYAl+eFadQX6/C3GcG3wVE27
	08ALj4ZVhYV64Jas0m7/lCUB/oOBn6PkuGOMRFFHtYghieXQNI7nRSXtbldTJ4O+kY7YN8
	0RUqduxXtwNfFpWjjRs6W1wwRp0Laiw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dc3F547n;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753467791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mXykL/F/ZsfIcI+5pjRPHMMuGt9p/dtOhJ8qI8ma+I=;
	b=wNYCC4pEWKm9B+eRzf5bgSat9cABiU1yOE01Jj5bYGrippAYE4iQh/ac491l6mZA0VTaL+
	Si5LgKpDpNnj8iYxMBE4B8lMhX9PvjA61+q72jycNjh9YDAm5UaZ1w+bjjg5Z+Tio8KPM3
	zIMawHOcAgAOthLrkE1pCu6OfRzEtQo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753467790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3mXykL/F/ZsfIcI+5pjRPHMMuGt9p/dtOhJ8qI8ma+I=;
	b=Dc3F547n/aWSngsHibUh6B9R4wEh4JXExrMUUbqyHyeFTGxNcJHtmg3ygSEkdTqghSz0VV
	29h0fMDbM0y8oCN9DSqtSYMy/ZN9BThTX0cAB+/k6JhACMSXK/5cRrpYEaL6Y0IdVxjBwX
	NwkIhSOTmM0UiVlX83V4EVdKv1mP0HA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-n3qRkqy7NpKVsKtXbkdx9w-1; Fri, 25 Jul 2025 14:23:08 -0400
X-MC-Unique: n3qRkqy7NpKVsKtXbkdx9w-1
X-Mimecast-MFC-AGG-ID: n3qRkqy7NpKVsKtXbkdx9w_1753467787
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso1403127f8f.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753467787; x=1754072587;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3mXykL/F/ZsfIcI+5pjRPHMMuGt9p/dtOhJ8qI8ma+I=;
        b=A1WHCezXWd0P2ptNKXf3Qg/rqsQBn+Zn3EqMlnGZenolHiadd2bF4Mub5t8F+lep9v
         bapO5BIeAYaI1ipjFHi5Hkx9kPHf3Ndu2war322jsNq5CGOfP3AeQ+f4PkrygbHI/Nff
         rDaPWRYkyTst4q27V9TotxBA30u010I0S/kGea2WDsn6Pzmz0tphpsSVZuLiZ9UMO09W
         eGx+Eafc9Q/sMJ31+rGnAE4xVmY2dI3BqXWbXkalUpytnbL4XaEQi5tQ088nac3JWrGw
         qxWG1t42rFJ2/clHwml00M2kSxayaqY6venU1ts9OhOLlU40kPceKlNZQFeL8522WJOk
         8jbw==
X-Forwarded-Encrypted: i=1; AJvYcCVym8q8UqwYqSTXVnIQY578z0kftpCH14g1e4OYPgSyQE5fHXGvkeRdT46iYbDUdUew+cuDODenXA==@kvack.org
X-Gm-Message-State: AOJu0YwIafyTKpfvZuN5aKo0ypYr0SEOyF4ZOkgJH5KHZXSJtBJExw85
	WLjYmYpEwirpCIhU/UsVpg6e7c2+rPdAsf4tPCU1JW1FA1dCvmS1WY7jCLJLdKRHo7kiOrIfUFu
	qabMRcXz7FeYz3dVah3xBZj2hVbh0PHe5GDBf85a5fsON2Om6rcRB
X-Gm-Gg: ASbGncuUIj70FpMEx2N7a+sO18jsYyN8Pvl/rRIgvXJB0vc+vKShXhkOA1Z31/BHDrb
	bBOKxViMrYns+3KcSeJHHQmDkBQHyroKxxnSiv59YRauSpGfYPnRTXihBjCBMjMAqtu/ZLUJuxG
	JMGl69jwmlqul8P6HHIV6KLDSaEiKGYXlJY35pXgduoEI5D6D2qd2Gb6hm7xVVrEGOi48XhTwhY
	/dZr/OmAOnSGGSh/PeWbl7AzdvaN+bu5ay6tGPqUe5TxEONba7NgLx6e8Z8kEzqChIlyK/6Bl/V
	AMAw7Lt4a7wDaVxCWH3eF9mxpGHsAYG4pU6FRL5ElxSQhsp0+yt4ggF6NU3eBM2tFOPIy+pyUy+
	UdaPQctf4ettcv1h1WRpi0wTB3WUNwBOK5AC7PVTmI+OfYKs/arf7IRMlxGfPzkp9
X-Received: by 2002:a5d:548b:0:b0:3b7:7865:44a with SMTP id ffacd0b85a97d-3b77865059fmr1349064f8f.46.1753467787382;
        Fri, 25 Jul 2025 11:23:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9ZyDRXU7hDTQHV67zP/BJ6+oks9r39nLAiVs6AH4du+89qS89MMKpY9Q9iqAlOzaotxa3yw==
X-Received: by 2002:a5d:548b:0:b0:3b7:7865:44a with SMTP id ffacd0b85a97d-3b77865059fmr1349045f8f.46.1753467786882;
        Fri, 25 Jul 2025 11:23:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f36:e800:2f2e:cb5:13f6:f884? (p200300d82f36e8002f2e0cb513f6f884.dip0.t-ipconnect.de. [2003:d8:2f36:e800:2f2e:cb5:13f6:f884])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778eb9c01sm556520f8f.19.2025.07.25.11.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 11:23:06 -0700 (PDT)
Message-ID: <a2a3b527-8ed0-45e0-be15-85ec4ef1afa1@redhat.com>
Date: Fri, 25 Jul 2025 20:23:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Add missing headers to mempory policy &
 migration section
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com
References: <20250725181745.2494226-1-joshua.hahnjy@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250725181745.2494226-1-joshua.hahnjy@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1Ivr8Gjj3O7YHZsEeJIH44els_Ii0j76FTZ7ViY9CE8_1753467787
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2429A180007
X-Stat-Signature: pghb4ahizxuxrm4tzjomeu4gp1huwh9w
X-HE-Tag: 1753467790-400112
X-HE-Meta: U2FsdGVkX18Kmf8RuGCSoX9KNbFntMksvERwRyto3GXXCMC9rXE7kMAeWM7HrNZ31QbluDqhw6LoBvEH9lpwSTVLexGTO+qRKrusmkEsstgjUyP5VdZqPPtj+S7pcEaylJdAGzeUuDSZwDjRh+4sILGEKLenZovbJSpasyM4NrWFJoIJmfulAvdIeT5L3TQjnURDfbzZrI2z8jH+zA30MiIxdHHRXV6Yn5OMk2XcBoEYvTBIE46ztPlIWqcvY9IdJPBnkSHxjapwB7vqiQkQSaPdsWlw2p4eCA/nSpRjvQES7AWB01ihDXvxZ1krzDrhBpeNVO1AzixiLGJ76FLKz5xAqDKtTrsPqmyXVhL92LtcpMYo+o3xEKIwycn6SovKQpZyBh+1SFMyR0otKCxQz1mPQIgI7wy+cap1ovGDiI+ywn+9oO2bPvAw3d6JWP670wWQERnQuntnOM7IO6Ou3s4RiVHa+wsk+ehd8DMvnVFBqGc/U/G5NQfM82zKZ+nu5iFvGMKOHFzgUUFg84/bsQUevWlU8qMYb7J8YFm7qInm1CoIUcoEUWPfn/yrQyQzB8AL03aV21V4tx6mse4LtkutcTkiNghNsVb9H/7fQlzVRsohGjDKJzH3wN2x7CLg+fhF4lWoK+qWy/lCQnMdXB9eLZ878R2dngkfn8r2JE9oYeBI4NvNc/1QRd5F9R/SDYRTINVz1VcFKb1L+YpzmBHldDbdmIrfnFbo8YUwCRLKKDkGL5wqN+qkfIqmi1EuewUJIWwUE9SeLDYNj64xijprLHghZqdeXgNNwzm/WzP/leLW5rMxKEE8+hsrGGAbSN5Y7E1cr9T2Z/KsOVbrOBh4FZTsXTiVjGkNvAl1mg9RZmRnrYSUkFxh1IPBS/pglL6wbUoYtXgYFiWnHjYnk1NdeWOB9Fuq6x6DT7ICE4FQYeKIxIhw/pwlvaA9azsqjOrW2o3Hv2DLU4QZ2cF
 XWt1fMTt
 Y4k2uWpno7ADCBnlUIHsIAMxF+bf+C+CSYwk5HYEAVZFboMfCfT5Wdow8tdN4SdLc+TYd4SduPU/fnky9NNblfiapIxr3kXmyyKhaW3oraQ4J0MGwBzAlmqGsulEiAjyK9+KPsifuSDUc49/CHMZ1mO2By12wqdWXgUNbplt2cLyKo39gKrVsSEKn78w4+xWqZUxdFiTStPClHS2Ol2KSu7BVH7XbGNH18lbNJDuWIh0MZia1RTXM8QdaNkheSB/lBefyBYkX3oMgRXnBFPHJdIyfRXTQ+bHqvJQLcXR3jg1Hy4kUE+UAAa6UhrBcGmmCe0kvxnxFqoWtRTJuyy7GsqrSVulqxlcV1e4JTujSN84olCkJcLPABaaJ6X9/+vkyZ9A6S/wwhQ9WkD24V/aNbOe8aGa29TfnQXbvjkYIzgPjDzAFRBWFknAhcJZjjIZmFpzBJhelO1QmR+jLxpLqdzSt7mrvgSK4hE23przsSz+E8StAuBM4GVVOnuyv/qmnoG94UIyIaylNOE+zn18jGdB9B9W7VNCe5KOqYCv7OcJ70WmfJJIcJe7rByoid6uJzvgpGXUOY8EtsVn/5dHjnzmYQPNgSBucoryjkNixLnJG9epkct/PlgQTsXrjR7medOOp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 20:17, Joshua Hahn wrote:
> On Fri, 25 Jul 2025 20:03:09 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
>> On 25.07.25 19:56, Joshua Hahn wrote:
>>> These two files currently do not belong to any section.
>>> The memory policy & migration section seems to be a good home for them!
>>>
>>> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> ---
>>>    MAINTAINERS | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index a8bebd0886df..dec8db8b5cc7 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -15838,7 +15838,9 @@ S:	Maintained
>>>    W:	http://www.linux-mm.org
>>>    T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>    F:	include/linux/mempolicy.h
>>> +F:	include/uapi/linux/mempolicy.h
>>
>> That one is already on that secion on the mm/mm-new branch
> 
> Hi David,
> 
> Thank you for getting back so quickly : -)

:)

> 
> Unfortunately, I can't seem to find this file in MAINTAINERS in mm-new.
> Perhaps I am not looking correctly? Apologies in advance if that is the case.
> My HEAD for mm-new points to dd811f4553a9512501205ba8e58ef1a6af4cb291, for
> your reference.

Sorry, I was completely wrong ... I got confused by the other 
mempolicy.h file that Lorenzo also recently touched in here as part of 
the MISC section.

Sorry for the noise, I shall stop working for today and enjoy the 
weekend (and hope you will do as well)

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


