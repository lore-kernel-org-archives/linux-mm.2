Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA350CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2E08E0008; Wed, 24 Sep 2025 06:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A628E0001; Wed, 24 Sep 2025 06:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1BF8E0008; Wed, 24 Sep 2025 06:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DDDD08E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:42:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D29311AD86
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:42:44 +0000 (UTC)
X-FDA: 83923805448.27.A6C4123
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id D25E31C000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:42:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JaJxthPl;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758710562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47KuMIrQ0XUzGsgIwg1xUs9syR/xJqZMVawW+n8AlVU=;
	b=znbpPQXlsMOKBUE+L0WWTDdSmbJa59+q6vUOTJUi3uONiw9b6CtImDl+I2ejm2HBi2KB+Y
	4zrXtOU7UCjwra+fyDXeUNRbNDYcwn8EkJL0J5mceFnJF6smFoLjH1Ia3I6ZebykHn5Ych
	SkFtkqG+NP6obpza+u4Bu2NGCjaBDAo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JaJxthPl;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758710562; a=rsa-sha256;
	cv=none;
	b=6QAgNkYgklihNph2pp3B7c+f4H3IHEVgdz2JdWr7fgwmjOtvb7bnO9/sS44aBFlQfJ77u/
	lI+JDMlScUE3DqNRwJP69bj8U3TFW6lo6KDBmudof5igeLPX00R3uE1KtpuyA2jfppOwyQ
	ded0Lk2n4wvdJ+6Pke8wQTUOKstLlEk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758710561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=47KuMIrQ0XUzGsgIwg1xUs9syR/xJqZMVawW+n8AlVU=;
	b=JaJxthPlIUiKPF0ljYhChyeH/VyeHOCKyXtKR846kTyDuPUlw58UctLJqmXtE4vZgZKYrs
	JcAOSYJIA0TmWNNov7iFIYqQTbNFjA4ZrSNbrFRgLgl41xX5ki+HRb1NW2aRe17HIvXzCU
	mSoDaAwkE6mfhZvtcsAShQI827Oy5Ws=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-FHC3FIM1O4SPW2vdL1Kj2w-1; Wed, 24 Sep 2025 06:42:39 -0400
X-MC-Unique: FHC3FIM1O4SPW2vdL1Kj2w-1
X-Mimecast-MFC-AGG-ID: FHC3FIM1O4SPW2vdL1Kj2w_1758710559
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45f28552927so54138645e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758710559; x=1759315359;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47KuMIrQ0XUzGsgIwg1xUs9syR/xJqZMVawW+n8AlVU=;
        b=HejvFxrW9PWJZcmp8aWzwbqIgWzKKh9tgKuqgmqNgPfb8e8gYC302MCQcz65W8uHY3
         +Tgyum4S7SI1AS6Ul84ym2+ZtfVFuP393CBVUvt001RKvXt3VNent9F6inVxPC3QWDzb
         nSv8grNMKEOk3gDxLerxYdlTimhXX6CuWK601vShMpToOVRq+UL8mH1/a3lujQxjk4Wt
         6NCByE++qm9h+9JaAOse4ID26i3KHcbNkWUmGJkjmXzYaTot49ik6KCYJ4R4If1Wf+YF
         wRYTDLKZ4gF3YkGyaA97xQpXRaA2KMrzWow4X2y9RdxGfAKSj0py+hsptQqqfS22xdvp
         UVjA==
X-Forwarded-Encrypted: i=1; AJvYcCUsLAqEwSQE9xdXoyrLSbXWG7bSiNHUtwxpYb+ccBwH4PpRQwD9ztlk3aEpLGmQD3TmJZDlIsH7XA==@kvack.org
X-Gm-Message-State: AOJu0Yyna/xsLWOIUjvkMD80kz2L9Pdpdpsjb119YTHVadyRh6uIizCe
	WXh0yJYhduc8NOX6yU0s/0ZQh1h+pGLZZCap+HMBxi5bo59xt7Y/Uwe6jjph05Y0cSmXt9pfi2Q
	0AUYOl9U22GBB7zUV9sMrXKrZNfaqyETi1fOKfbhwh7A/Cwf8lLTl
X-Gm-Gg: ASbGnctZomBPjIKUwqH7XKXV1/PusUQm7Re+QpLLrZeeJKdC/1taxpYl2un07BMpF/x
	RDkWsy6cOXcAVZ8IhWZsH9xWHAYqivXlXLu7nYWA1gKnbvqv8YBAAGnU9CbWucdybqdYfCmFDYX
	8t5bg+PYWmO0KyeagfPAebj4nmAz5pxBjbSLw9DWc0ltdcyUiOVpgPR78AtSC393vNhz1COpXeo
	aO65r2FBt70w8WEUh5Upk3FRc3zhL4NkjgwY7/MsLtTCQQGM2p4Wn/yUmAjbpVK9/GTGxnQPoY7
	o+crHxSsTJ6kwBe/AK011h8tMCxJtkVeEiI1C5njSoTdgzIDPrjdakOLqtbKVh/xJqZM2JW6gqv
	NYdEIUCvQZ89RBJ7CnqDXEFZzrpTddqsFV3novXMVMWwkVSKIrzFoamf66AfCNcnpKA==
X-Received: by 2002:a05:600c:4f42:b0:46e:1afb:b131 with SMTP id 5b1f17b1804b1-46e1d975235mr66006655e9.6.1758710558643;
        Wed, 24 Sep 2025 03:42:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIVzgDnfU2kkSfT8xJFEvv9ole0vxQjh0rL0yGG4MlChNDrSlFGr0UWqwFJsEJrHlLXLnBiw==
X-Received: by 2002:a05:600c:4f42:b0:46e:1afb:b131 with SMTP id 5b1f17b1804b1-46e1d975235mr66006225e9.6.1758710558262;
        Wed, 24 Sep 2025 03:42:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee106fd0edsm26864446f8f.53.2025.09.24.03.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 03:42:37 -0700 (PDT)
Message-ID: <9ff04030-14ad-40fa-af14-073bd78cb715@redhat.com>
Date: Wed, 24 Sep 2025 12:42:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, linux-mm@kvack.org,
 Dan Carpenter <dan.carpenter@linaro.org>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-2-richard.weiyang@gmail.com>
 <27storxu4seijr5smul3xx7pofe45ittjrchii3jtwbntalsiy@2cu3wf42drwa>
 <1ebbfe02-1cb5-4f7a-a640-68d5d95cb99b@redhat.com>
 <viz42o4iscxkpxystnikuvfnqzwwfq3anivizgx5dncm4qyqvu@4kymskstues7>
 <ef32e31e-d04c-4604-9786-adac33591980@redhat.com>
 <hzwqdrkfdnreb3liohafhxkd3fpfnzbpmqzlosktevehzmju2i@5nck6ryrlgrz>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <hzwqdrkfdnreb3liohafhxkd3fpfnzbpmqzlosktevehzmju2i@5nck6ryrlgrz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H84d4jDf9duFBXafV1uM339HyL3XdCQ_mc332rDXvh4_1758710559
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D25E31C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qdbyrgr8ne6mnmqzan911k9zaesmjnyx
X-HE-Tag: 1758710561-685533
X-HE-Meta: U2FsdGVkX1/EAHrkPZFAMEefC9IOdFgHHbq65JMzxMRDImhLVhC6ItCSTZ4q7mKp2E3uVYZIg9ggMzu6iM+/HAxCs8ORu+MCgjs7cdw3z6hUjq9r0GXrMGVxfGzCuanHkq6qM34mSskOyv3IPMaZO45qXOy4GauYOjEdBqsKg/ziFDf0pr77jfyXTUo4XVfs9mX45j+881UQ6/QWNP2wclVw70YRe4OXbJxMBc23WpBfIHqj8iFPIb4YYGN8fNQfoYW7w9mRhlmq/BaccAAbe88V6b1v66Sii88x6Y+Z7gLexQOLAQQrcXdaQe9Ux+9JgOSfB7SPpHp9gBD65CInDN8iqTxrulr0htMA6OKMQ6rwkNsM4tA2NVS0SRYdTM5F7jbtCdsEVIDXSZn8EypyPgmmJBK1d7qbDSZnuzCbQ8Fs5jQigbcVsZKb5tKgPTmEVckjOt/vcj1TjyWBlliZdFpumxiy1pefmQFuWH9W/gc//z/XBdQXuznt63vrcIPxmxCBf4xfUMgVW1HHCUaD8B8vXHHHnDP5s5M0zO+P9PBl8H518NmrtZ2CqU08eVJvj0QUykD8zVp94uuiI9cCSdpZ+tja2R9WxLnYN+jseKA1qfvg+NRxb1PbqbqRHFyp7lHW+0LqZh1yQpNVouHAga9ogpYBFc/MMTGelR7FiHg0hEzmtegCpsuRjJnzWd78MphyHTPPaczMG+Fc5x+7Ddlpui0rkQ52TQSTDYh6Ag4MQTK6r9yy216Nymu3CE+5BPVP3kg0Be3KuWOvFM3Epv8efrOh9tOlXoTduey0HOdspi+c1WhZ1+hUcVbcdWq9iEKPYrOj5d1lxzj0MFRc5c+vEbI2i6ATu4TOoXGaixVcXXbpHbr4+BKnKrhlNZ2/I2nFhPuLTDxEXD8/CxvMt7ZlG6GS5Q2q9lHTNkFvBetrN5K7Dl7T+jQ5GFkYVrMFpMMDv+wRphLMGTOImz4
 2CIEGcjd
 AiPo0pXI23PJLFqNON/RR2pQlhLro5+cAhxS7dwuAjgzPiho6ImL8OM+qS44kQQoa+7TonXD25pdTdl8g1Nuzf0ciy0e/vD5H6+qiPVVZSWbd6jVq5Qv812nxv7Yrn2tFUB0Ht8AmHYNB8Qj67o3qLFxnyDhxV+vs8oRJ9+1TVrvMTM9AwYDYweTmuOpvhNkdS06SYDJ/jd/t6PXxeF3V1/cQ9pDJdzC/5/pSHb4t47RBocWdH2lNU5GFmy4qGmSeSQqvNxZ+RHNLmwWy1e2xQbOu+vVfW7LdTSPDWcbikn+ry/u9dHXxB37XJ6bvo6d9bcGfDn4eXKjJp3E9wPVbq3B8NEs0ySGVLYUCrIe4I6sf8N5x2EGvEiHtbBw5/5hfnxWRqeIRKPnpyzyM2egD2zBB0tjH1kwMlYuhzpm5LmL+G1qLW0a16bD8e7Gbkz+Y7Ls861CfXx5fw4wJOD0kMs4TbzJmAZd9tw3oxDZ3FxMn5UdeALnEOQ7FeAjEyp3/qmo9UngCd7RrClbAcv54duaI+WMnmPHgabzYaiYCo1fhdYWpBpjOYQtfmDr5zLc8G+7cjTxRS3MGaRv6Rz2OxE9QuDRjYY8wpCCEmNsVhv007TeWQGqCVK8GSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 12:15, Kiryl Shutsemau wrote:
> On Wed, Sep 24, 2025 at 12:09:03PM +0200, David Hildenbrand wrote:
>>>>>>     mm/ksm.c | 22 ++++++++++++----------
>>>>>>     1 file changed, 12 insertions(+), 10 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/ksm.c b/mm/ksm.c
>>>>>> index 2dbe92e3dd52..c00a21800067 100644
>>>>>> --- a/mm/ksm.c
>>>>>> +++ b/mm/ksm.c
>>>>>> @@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
>>>>>>     void __ksm_exit(struct mm_struct *mm)
>>>>>>     {
>>>>>> -	struct ksm_mm_slot *mm_slot;
>>>>>> +	struct ksm_mm_slot *mm_slot = NULL;
>>>>>>     	struct mm_slot *slot;
>>>>>>     	int easy_to_free = 0;
>>>>>> @@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
>>>>>>     	spin_lock(&ksm_mmlist_lock);
>>>>>>     	slot = mm_slot_lookup(mm_slots_hash, mm);
>>>>>> -	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>>> -	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
>>>>>> -		if (!mm_slot->rmap_list) {
>>>>>> -			hash_del(&slot->hash);
>>>>>> -			list_del(&slot->mm_node);
>>>>>> -			easy_to_free = 1;
>>>>>> -		} else {
>>>>>> -			list_move(&slot->mm_node,
>>>>>> -				  &ksm_scan.mm_slot->slot.mm_node);
>>>>>> +	if (slot) {
>>>>>> +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>>> +		if (ksm_scan.mm_slot != mm_slot) {
>>>>>> +			if (!mm_slot->rmap_list) {
>>>>>> +				hash_del(&slot->hash);
>>>>>> +				list_del(&slot->mm_node);
>>>>>> +				easy_to_free = 1;
>>>>>> +			} else {
>>>>>> +				list_move(&slot->mm_node,
>>>>>> +					  &ksm_scan.mm_slot->slot.mm_node);
>>>>>> +			}
>>>>>
>>>>> Indent level gets extreme.
>>>>
>>>> You call this extreme? :)
>>>
>>> Emphasis on "gets". :)
>>
>> :)
>>
>> I would prefer to not make it okay to call mm_slot_entry() with a NULL
>> pointer.
> 
> Maybe invert the checks then?

If that cleans it up, sure.

-- 
Cheers

David / dhildenb


