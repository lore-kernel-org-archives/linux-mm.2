Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F73CCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79E08E0010; Wed,  5 Nov 2025 11:39:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51398E0002; Wed,  5 Nov 2025 11:39:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67018E0010; Wed,  5 Nov 2025 11:39:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B47238E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:39:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 768C81DDEDD
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:39:08 +0000 (UTC)
X-FDA: 84077113176.21.A87C4D1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id E8E86100003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:39:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A+rOhbrv;
	spf=pass (imf05.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762360746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DDwUEanHIf5XFFvGb0OEC6nQuQQ0S85vv2/8gZzaqA=;
	b=sUf3PQGZNhLkc+JwuK+tRAx+hvw8ERx7tqkzBBUbqLrfcABOkVXKrDnyvaYACneNnu0Kq9
	R/gv5DdBum1htyJd6oGGNZSM6f/Nc103sGug92acNdaLLsIJ46bQV/fNxVsBvP7x+FupYD
	yeR0wYvGMTKE0rYAOmT8MvZy09zFcsM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762360746; a=rsa-sha256;
	cv=none;
	b=U2arHs7ifJ3qO1R4N+XQXiPYlC75MEvC/q5V6MWbKA7hhoOu+Oi7xHIcNhVvEXAEmQdH7k
	Wmteb/7c6Hm5T5MZKtXXHRwWNHFD1nd7ySigbd3xofDcrJra80hVlHpM6qurGHkbHb9GXt
	w7KDN4BM0wBOvgVmlZy2UeZi6bKVzEk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A+rOhbrv;
	spf=pass (imf05.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762360745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DDwUEanHIf5XFFvGb0OEC6nQuQQ0S85vv2/8gZzaqA=;
	b=A+rOhbrv29XjS/gTBK72bVMCflf09UMf6E6wd/wr/qUmJV8u3b1M0UWQkPdWMqioejl51r
	R9U+ChCDjGp+a/ljVzV3Ysc0B+Nsa0XyubCnqDGGoK7Itcki1FsbJqQiFXfI04OhTU8MLU
	/1Xod/WVSbQlfc9d+aQwQHiZEm1kRuw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-a7BQnb5IOPm8eCrvoVTe_Q-1; Wed, 05 Nov 2025 11:39:04 -0500
X-MC-Unique: a7BQnb5IOPm8eCrvoVTe_Q-1
X-Mimecast-MFC-AGG-ID: a7BQnb5IOPm8eCrvoVTe_Q_1762360743
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-429c19b5e61so19668f8f.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 08:39:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762360743; x=1762965543;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5DDwUEanHIf5XFFvGb0OEC6nQuQQ0S85vv2/8gZzaqA=;
        b=csGPiq2qPZygOXItphz0SHgZbMF017jn4/MgRUwuYx+8idOHDp7t3MmtZwvXjY6LOa
         eDGJmlvj/JUdaiK/FLpfJK6vZVYvZ0jlWaebAsi5b7nq4G1sJ+gWDVN5C+Ku97PhPncf
         uS2Rlu7F1T/gT84Phwcaiudwv2Pzo9BPSPwA7dsRiCaXHXadKb/8d6gtSu7iiJvqWFFQ
         fyB97nAxB4MLVZSQmfyHOVMpoYI1ICXPSaf1Agl8EZxDXp32yt7i7ckKd5meGNm+LN2P
         A0c/pVBiqc2YSnulwoxDzxnvA+eeoBDEiBLfXph86IqfqoogHSGPwTDGlt+Rtzt7wQTE
         VHsA==
X-Forwarded-Encrypted: i=1; AJvYcCXWZRAwOFPFsUg9pT5qzHBYZfaQAshRUx9l08lSTyvyYBuY6z2QwG8zSZ7MCncXkBd7S5r+MC9uPA==@kvack.org
X-Gm-Message-State: AOJu0Yz0pFNsMrvlsv5o77pZ9jUj9ZHxXrDjDG2Gtb4EuYrP8evnBQMW
	Esmd5XLJB+zdCzhsQ/CEarQmm6bnu9gOplzSFWaREp5LN+PtiR63vpl2yLeViQ7V+yz71pQaeFg
	jkO37n3wwz7KS6FWHeRMPzzKd+nuZrG0JVJnk5ZI3NbCWnI64c8iP
X-Gm-Gg: ASbGnctzbDC2X1WqzR8ZIji3x+smOwLk4E4dE+AeZa09Kg391B+B/sXQWRezOB8f9gW
	X7ITwoZlALmVzjRdfqxOayJJuojDc+ViT97pd36hWfpiG0jol37870a+TxQIWN1aXq+hDFY9sKX
	IuPZ/zndLoITko+NQBoicIYHbD8ImjLcS94sqV7cjm8VLcajvqdy3v68k8YXJAXrqm1RN/v3BXa
	fEaEQWh9nIlCUZIu0Z2BXZmb1ndN6/Zoce0MEU+2U9kHSOLli948t1VcFfmFqaETDSHGEPln0XE
	8q1pQz8XYaWMmWTdMYs65wZCsxq19QdyRwh+xWfIiq4sIgiI1jzzxvEzifsN5MOln1+m/RztNqp
	eJtFSO1R8wsss65wMsJHWccqIkhgMd8ZJTIjayFVOOHWkjS9OK7E8oGcg+cWC9n5trNQdbeHyCr
	EBEPPfjxn07eXMgXJ8+1wOt+0=
X-Received: by 2002:a05:6000:144e:b0:429:cf03:8b1a with SMTP id ffacd0b85a97d-429e3309cbemr3444651f8f.45.1762360742901;
        Wed, 05 Nov 2025 08:39:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuh/61JxchnbvDD3t9otzAnckg9PYa/U28Sk++DnkiTdkTuxAxX+B0W7YZV5+JgZgZiAf29Q==
X-Received: by 2002:a05:6000:144e:b0:429:cf03:8b1a with SMTP id ffacd0b85a97d-429e3309cbemr3444613f8f.45.1762360742399;
        Wed, 05 Nov 2025 08:39:02 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc18f40bsm11263373f8f.1.2025.11.05.08.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 08:39:01 -0800 (PST)
Message-ID: <547b6ad3-fb62-4549-b1e9-8bbfb246fbd4@redhat.com>
Date: Wed, 5 Nov 2025 17:39:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
To: Oscar Salvador <osalvador@suse.de>, Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1762310125.git.zhuhui@kylinos.cn>
 <aQtcMkivdFHbW2lK@localhost.localdomain>
From: David Hildenbrand <dhildenb@redhat.com>
In-Reply-To: <aQtcMkivdFHbW2lK@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IkGJAtlepf_QOhvPhjAfEa-4sMOj7Ep_WyYb7KW82DA_1762360743
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E8E86100003
X-Stat-Signature: uuebhkdmbudhcnwe8bgnryukpwhet51n
X-Rspam-User: 
X-HE-Tag: 1762360745-781300
X-HE-Meta: U2FsdGVkX18gyQPY7fJ1hXnUnK/9sq2+OGv0VXAc6Cl/UIMa7eRPl5M0gHDEkXj+aT+2JhRHTXsqY6rum6tV6TzKG+EWnOUaUHSAfuBeOoZkm6XbVwiYgRvOCcBVLnypnOo6PTm27SRHnPdcJP9sOHwHMOKAcSO+mVrPiUfj4RIjo4Y0g87yYhFpqTlpRdIts7fgq9A2paesxTqT7+3npFaPWMTo33C6Fn/kSF3DfIhtma4i5Z/Rsbj5kmo6u/OcknDwODbhwcexq/sdr6rSEnHa3PhMFeHecyELNVUtOyMU0VXxQOy+DnrJ/Q8o7hbPu07NIC8B0nemXOGBUuKH1lzF2RFxBa2uH5NbRzBgflkohvmAyclBZHesqq1QzqecvYzjv6yq2QATTA2qrxujIv3CJITXa9LbTpVuWz7Fb0lP38e9EHqxacBky6KQ1MKfTUWE8H7N0Qb1Ce7yTCoyY50qG2e+MnJUQk+UZqpNBOlfWypbH+a1d0w2i4iwQXwwcOcN8GHvhb01My324dN6p5qmDorEaZ44yZUz572ad6OUquDmqvxbotXPgfup1GiGzNzQPG4ZlntT9pmW8d7DY+iNT3HxqzeEHQBj0p+WYdwMQAnYrkIyhH9nxQ8pICH4VCDI9qtpwoJ/liF/rJERokkCOGfqXUKc1b1vrgQr2aJi+1bfJC92PeeGu0sC+3wuPWZWQ4LTdiBDR+eR+7555vZiV6aR9nlvL4/KqZrovzLpHeGSpgyt3iJs3b4Sofm3F9hxpRMVMQJA+A+Ipn7vpraFALITe1jRvB7I8WQY10B95UDBlAGe+PGzy3O8Am/FE9qPDtSvRK67JsgX69y2L5sJls1RbuvqIVV91jiFfOalQGJoszy31iNF/Z26LsGapd3KyI8kS9CDK8R8ihBrRr0Ly8DgippRI6kHi00uwmpqHP292uLDX3Z96SfoS/oLA3fS4rkQQhHkYsuxaRb
 bXcPmRLr
 VwYZVTm2VejrdGQbTXLvJHq+xctO+bQrXuNaIRa4L4lpvIgQSDYOrSackSexTWgK7Vh+b8mqbUuE5vZMBgZ5sI7W7f0jNyksndgpm0Jgm6G0/BIl4F3HHP+47Vy45tjPE48rI5YRe15hzaRHIxlF9kG5I9FiowpoBGFKpMrjkaf9Ma8otZqMwsEtbhEGzxrXVN0oGg5PrzMZxShsBMxzy4ePJc5SG+Wqv0dbGuX71jF7h1YWA7+to7UizNplq8EbbV4v8qHAtxVpyum/eMzMWf+XWSCGFMf0kp3YntdUGalr26vfwRDczuI6uMhQWJUqyfq6prihp/mo8+190C/JcNsydMHmUPB/P1eGuz7JsEOMuSjqqTMk9EeC7ffj7WLhbY4/qSuZmoVz5NNjyFbqsracjbnm/NYho31qXig9my80iEiIerfCWvH2tEFDtlyWfOFxnAmQfz3quuca9YX20Ll0PGvZnAews/awbZO11WnkcSVw7Qkv22CtIM7g9rbQ+cfVR7a/msPQDocAxi6ESX2rLDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 15:16, Oscar Salvador wrote:
> On Wed, Nov 05, 2025 at 10:42:42AM +0800, Hui Zhu wrote:
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> The hugetlb.c file has grown significantly and become difficult to
>> maintain. This patch series extracts the sysfs and sysctl interface
>> code into separate dedicated files to improve code organization.
>>
>> The refactoring includes:
>> - Patch 1: Extract sysfs interface into mm/hugetlb_sysfs.c
>> - Patch 2: Extract sysctl interface into mm/hugetlb_sysctl.c
>>
>> No functional changes are introduced in this series. The code is moved
>> as-is, with only minor formatting adjustments for code style
>> consistency. This should make future maintenance and enhancements to
>> the hugetlb subsystem easier.
>>
>> Testing: The patch series has been compile-tested and maintains the
>> same functionality as the original code.
>>
>> Changelog:
>> v4:
>> According to the comments of David Hildenbrand, add copyright of
>> hugetlb.c to hugetlb_internal.h, hugetlb_sysctl.c and hugetlb_sysfs.c.
>> v3:
>> According to the comments of SeongJae Park, updated MAINTAINERS to
>> add new files.
>> Removed the wrong copyright in hugetlb_internal.h.
>> v2:
>> According to the comments of David Hildenbrand, removed the wrong
>> copyright in the file headers.
>>
>> Hui Zhu (2):
>>    mm/hugetlb: extract sysfs into hugetlb_sysfs.c
>>    mm/hugetlb: extract sysctl into hugetlb_sysctl.c
> 
> I am replying here as a response to https://lore.kernel.org/linux-mm/58d3c50f-2b4a-4053-a846-613434d5bcd9@redhat.com/T/#mf694af3f5a6ca56b76adf66352cbb88d022fe36c
> 
> So, taking a look at patch#1 as an example,which moves sysfs stuff into hugetlb_sysfs.c.
> I have the feeling we are moving too much stuff. It is true that drawing a line
> is not easy, but e.g: you mention
> 
> The following components are moved to mm/hugetlb_sysfs.c:
> - hugetlb page demote functions (demote_free_hugetlb_folios,
>    demote_pool_huge_page)
> 
> I __think__ that moving demote_store() into hugetlb_sysfs.c is fine, but although
> demote_pool_huge_page and demote_free_hugetlb_folios are only called from there,
> they look more than a sysfs interface and more like hugetlb generic code.
> 
> Again, drawing a like might be difficult, but I think that e.g: we should only move
> sysfs entry points functions into hugetlb_sysfs.c

That matches my comments from [1], right?


[1] 
https://lore.kernel.org/linux-mm/58d3c50f-2b4a-4053-a846-613434d5bcd9@redhat.com/T/#mda7f5c2ea07233857af094367b573475011bf0d4

-- 
Cheers

David


