Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A4B7F433D0
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5036B0005; Wed, 15 Apr 2026 21:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ACB86B0088; Wed, 15 Apr 2026 21:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2806B0089; Wed, 15 Apr 2026 21:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5EEEF6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:33:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C87613B500
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:33:13 +0000 (UTC)
X-FDA: 84662695866.07.4B62774
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 141724000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:33:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AWSyFfy3;
	spf=pass (imf07.hostedemail.com: domain of yintirui@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776303191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQgdNunScoEK1wjg3coA/JSZQspmY6ZwsZhqd+cVzz8=;
	b=PcE3Cpsm+1TnMDsPBYclhszUJJiWCYdsZi8F0YoLVybLOIGMAB8XqgqDXLQFokyCtKItCL
	cvtrheMnycF6qpT6dIyYpp2AaG/udC1ViZGOMeuuQvnJY8tHSNNuNd/hVjp1+UlzPmlqMB
	CAeZHC3LK2AvABUnizo02rBuDaamDGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776303191; a=rsa-sha256;
	cv=none;
	b=GrowaqrgUGqTfEcl6nHXwhjdpAOMYhY3bQ9hCycpUaVUR7A4ElUnLTgAh9/a52Y8Ztn2JL
	5Z6ug+LEGcGrqMlzIGPFDr4gtrEzjeDFJc4rWEtzHmQ+HGYXxmwD6CvlVSOqODRTxTh+3U
	Z5Owv4sB259ODopEiTNh/iyj5o7EpLI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AWSyFfy3;
	spf=pass (imf07.hostedemail.com: domain of yintirui@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35da2d35eccso5458570a91.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776303190; x=1776907990; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQgdNunScoEK1wjg3coA/JSZQspmY6ZwsZhqd+cVzz8=;
        b=AWSyFfy39uFvZRUIOZyRmzsybkw30cv/dMx6GNGXJk43d6E59jVFGGbdXPgqk0gB4e
         dhEfpmRSm6LC33klFdkw8NVKVCK/lUkblGfslzzRUcs3w5QUg11vtDXhIOdCM70Y5b40
         NtrDPsoPfpCHUXYkrre4fme0vr8+YorUQik6fwYA4szW18/IyJdiLzeeVo+7IHsGdu2u
         Z8J1RH/S/7HlwaAGcLsOm7BcFV6bV8rYeT6F8sw82xzrWHyUlWHsfjxV/qR+LcWAfvHl
         YBUKkjEYP8gVQ5j0DVjcdxZm9yoF9IX6Lz7lO/cvPhgvcG4s+Lmgg6t9Blho+G+IQ0Ge
         Qkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776303190; x=1776907990;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aQgdNunScoEK1wjg3coA/JSZQspmY6ZwsZhqd+cVzz8=;
        b=HRhs79pyK/iRodgmeFSWizuODMTdMcs51sNbzgecWSf9HPSA4hWROoyKeoZDspy/oG
         mh2nTXsBoWlpBxO1rXvm7jM8sKy7+3ZDJb3Oo1xCnVG9DO5EANusWQo/mlzdd0/DAR4F
         mmXxsOQgSgT+sfOjZxD/cIjzCZCJl1F0CfnKp/ipsZy7HRFNzdJPc9di+LiJTXhIpGrN
         G/cq9lsnYy3qcl9du/gSa+XLaD+BRavK4NSqLOwQ7Vbs0Qmvf7lix8szUPbB7CzKHUqX
         BkjsWu3XUBXFZDgeraXa+3in1PU7wf/FARmOAu5tKlTXctoXrY2c6PalEf7KkrshawCb
         YRbg==
X-Forwarded-Encrypted: i=1; AFNElJ/zzxExclyQG1RAhELN7+V7/ososy+YZbbIyjTe5h0puKvErdasJbHDnr3YqzJ/fwyMC6knFZZq+Q==@kvack.org
X-Gm-Message-State: AOJu0YyHSMl4yr5316DJnIH67c7u3yeJ1Dm4cv75lOHBUgWAB0Qto3Pk
	NJHl4c17qZQ5zJH6Y/zXcZiadtPDxhP/cuY+eDupxwtFVuDb5wzVlWqttjGjRzLBbwgzbw==
X-Gm-Gg: AeBDiesmre+KDRdnjBdWW+iwr22c1d3xFOt6AZQSNA2UX91cdkahB+sE/PjuVGn5c9S
	pKYkCeD7KN79gkJDTZZXODKIzCcpLJU/yzcnKNpeL8+4vnEskeDMUQ317aw0ddesNmJPLkPH2o5
	b98WJITHU0MlMw9kNuloxlLR9gsnYvCSQnPGSSgjwXAwaD+94dfXXTrZmQHHfmRHbvY0bx9PKgr
	1x35nQpdOu/TsjCQIhuEuxFm+oS/dQo3NBjPhgU3TiY+r+hytzz1MnK4D6wVG18Py5NrI230qIb
	UnY9hwl5QIDDKDVjwg7s6bjnMxyqSurpLOfAZhPpB1CZ61Jo7/0Zx/eRkF/lG6JxQ1MnFEtfLyN
	RVzg+xY8qsduJkrMx/Y0RcSVjPeT9Ehik5U1HEp+9lL6OZgEWMdIMAhHp9Y1+Wl0msMdC0dYN+L
	f1RbOAmTawCiZ8s/OOSMb/xIYjH7l9Prd9xpZJKPSpNbQOvlEd4TVp9/RtGbk68l7bKOQxYs3oh
	Yd9eQVQJmQV21MOKGaO9f6Z59zzvQmsQT6sKPyeQs1FYcGDlVuZsQ==
X-Received: by 2002:a17:90b:4c4e:b0:35d:a2d3:5c31 with SMTP id 98e67ed59e1d1-35e42858252mr25610929a91.29.1776303189780;
        Wed, 15 Apr 2026 18:33:09 -0700 (PDT)
Received: from [127.0.0.1] (211-76-176-103.dynamic-ip.pni.tw. [211.76.176.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36132c8b96dsm432340a91.1.2026.04.15.18.33.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 18:33:09 -0700 (PDT)
Message-ID: <66c7d579-c6f9-41e6-be43-1ba3c2229683@gmail.com>
Date: Thu, 16 Apr 2026 09:32:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
 <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
 <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com> <adTb6_xqQoQqK74Q@lucifer>
 <2f29f66b-46db-4925-b922-4add61b633bf@gmail.com>
 <53d748d3-4150-4e7b-8c1f-4c58587e9183@kernel.org>
 <6125defb-3aa4-494c-abed-982be684f839@gmail.com>
 <6417587a-7e43-4615-9e2c-50a245842f59@kernel.org>
 <f7f26a91-5346-40d6-aee3-3b64c3249ac4@gmail.com>
 <6edde1e9-0f42-4dae-b0d1-3f2895f2111b@kernel.org>
 <2987ed25-bba1-4218-a776-0bb98aa87bbc@gmail.com>
 <4993bd8e-427a-47b4-894b-d003d6717909@kernel.org>
Content-Language: en-US
From: Yin Tirui <yintirui@gmail.com>
In-Reply-To: <4993bd8e-427a-47b4-894b-d003d6717909@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 141724000B
X-Rspamd-Server: rspam07
X-Stat-Signature: fjcyzepkjj7frn1os548jr9kbp6b4r5a
X-Rspam-User: 
X-HE-Tag: 1776303190-346898
X-HE-Meta: U2FsdGVkX1+1RFOXKRaxl9P5jECwU64S1yC5M/PPCuBFW3dfSinmOyH04ufTjZ5yv6+72dZmEPEVOrTehY2c8EBe7GFQN0402rRSsFQvfau5nwGy4Tb02KBSjj2GssunUjECl79Cm6DoggWAVBuxD1S4rTjgOZRBPBj8rkhrRVOcTLmJbAELqJysuRfJQXN9i5gslYxXylo5/KzokEHvENyBJ2TTGBcFpKJ7r/4IOCWJBKh9Pa+/2awxe1GBh69BLpj0qG+X0dc5gDAGRJahL5z0WFhmc3LsPpkqfhARI0D9qTJqD5lCKc9Pzk6Dn9Dr8V1P2VoW2BxlJ+qDqAxQGVigp4HYNnHAUCTaCXmbtMEWGEp1iNWcFjycUVPUjqnXjU+3YTVSTt+5Leo8GlVaE4Vzak5VAf04HqAEWNzGnzKu3rrpfcrgyUPS8N8wG/8K9iVQmyfs90CoHsSxy/26JKhmgMyv2z06o+CfrFGubuB0lJz8IHtgsFqNFw69PdeGUuqxPypZE0jenH0fcCOgg+Pnbq/oZ0KkvUcyX9J5evK5f/rEETeSFPZ8rP0FhYXn8vx14z4+HDJqHWgBZjUzfDw7oRrA3nK5P/poyLyMxiQ3Ni4lpt81LEGjHFr3UEvY8vvTHiUmRv9+GYYhSTw0A8O/RTf6goHHWxZD57P6VRANPyPs7gJ4MtMQdNPSYXvRoOkUfu/ogXHgVuYuWLlqnSYwHBd0TDzG5A1Q0C5M/pBoNmQ8XhUot0JoNGDkqK/OTUP3oI49R73g+vk76IS7rGOOQ8hjFkNEGWaQA4axag60VV++gbxCwBFr80+YgCsVr6Qj62RnET6QX/QClU/9nMIZYqXuq9MxstpNWuzCcV5L7dTs6f5mtr3Fr41VOOqgLbDpEVl6LDH1q6LzjyrGRIIIFfHsxra+9T3Gayk/q1xQt/I6faLkT9ufXuMLZx1eYhkHrGvHkR4LrZ5NYpo
 eeYa7xs1
 8IZEatQ5w3agDLO2koxqNaJAvu4PaLB1SDXq+3HYBsrEF1ppbxlGpp2jjT6qnOOOOxeW9hqMxS6seoYVo9SvyXPV11PrQjV8KUGvwFinU2Nvz2eJEkISszqVyg2xEnz+71cSAPGrklsoBsrWUEhNMebg+3L4CpKrWRT8l7fuqnYwwUMcMNLrO/tFZn9/9r2+nCTG70qIuoyiVQ+JgI2/Htozu7A+UYAdp9DiDRTduNvaMDpEl5qHiXEnqkcLwvDp+VS9K/gfq1sJe/mx8+bBsn0sj3FiadqTMiBJP7YygEHNUtanQvR6v9Slo7bOOBKB+tkZdsOIH77wTgQRMdv1iWIjRUj+E1/yED+M1AIc6T98YsHcSvY2TxqbwBy9K0qjsOGYswypHbhF6J+YmC2RbC8DR24X85CA1P1g2TefCt3LCeFJXqVfF4jaJxSn6H4NOhOyBg1rD1JtKWFKXA3B6LYfw7KtYoEMZwtdXiVRNM7WcG7RcJorOu0xrbO4e+hG/0cmMFieCDS1Pk5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/16/26 00:06, David Hildenbrand (Arm) wrote:
> 
>>>> Then, when we encounter a huge PMD, we know for sure whether it was
>>>> installed through remap_pfn_range() (needs a deposited pgtable) or
>>>> ->huge_fault() (no deposit needed, can be refaulted).
>>>>
>>>> So for Lorenzo's `has_deposited_pgtable()` helper, we could simply use:
>>>>
>>>>     /* Huge PFN map without a huge_fault handler must deposit */
>>>>     if (vma_test(vma, VMA_PFNMAP_BIT))
>>>>         return !vma->vm_ops || !vma->vm_ops->huge_fault;
>>> As mentioned above, also considering vma->vm_ops->fault;
>>
>>
>> Will do.
> 
> 
> Please make sure to wrap such a check in a well named and good
> documented helper function :)
> 
> 

Sure! Will introduce a helper for this. Thanks!

-- 
Yin Tirui


