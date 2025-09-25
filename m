Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070A2CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63BC48E000F; Thu, 25 Sep 2025 05:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614348E0001; Thu, 25 Sep 2025 05:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5296B8E000F; Thu, 25 Sep 2025 05:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2648E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:37:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E19351603F1
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:37:26 +0000 (UTC)
X-FDA: 83927269692.18.7074C2E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9139A40002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:37:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ih5sINX3;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758793044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZteDAWiG7VxkIsADkOw6B3yeLgEfE4eGqGu+VCIiwE=;
	b=1eHj9w8b24oGXCYgP0tZrNgzvpXpdCyUj6DttWrpFfrovgpTWz2G9gpdmO19Db56c42YjA
	fGkCbtYtG1OUlmBrCMdeNkknmJK+wuBaTD/rQXLq3AqHv+38wCI7P2Pdl8iCbBySrKxaLx
	6JjLfPeWabFX9uRYb98YoZwXY5v52PY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ih5sINX3;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758793044; a=rsa-sha256;
	cv=none;
	b=O4o0L4dTsxJap1Nsbyxah4L2DdYwBFjOrbZfwdbYyegw+G4PHqd2rKppB06djZcnXhoG6i
	EzX8kXcXaioIfO/I3GVXHuyDSwKvf5CiMPEu45iQL36/Q9aOxH3mUtUzaxifrk0XCUbFJK
	RrqC0dJnDC5W6YZEgMjvvQZCi49xIsI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758793044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sZteDAWiG7VxkIsADkOw6B3yeLgEfE4eGqGu+VCIiwE=;
	b=ih5sINX3Shj5u8N+gVj8wa0Sti/rImyMN42NkkSetvfyTjcHjqHOjb8zQjwYP+IbI4yy2s
	4Of3fBP78v02aOC9HucR4yK6bzKbL1wrcU751vcl9/uWSiOgqgh4h8T/lA9yEXH1/a0zs8
	ejLqf2oN0imK82yK8oDFIZLahFwHve4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-PtMvcecvOTCh0HQvxF_Djg-1; Thu, 25 Sep 2025 05:37:20 -0400
X-MC-Unique: PtMvcecvOTCh0HQvxF_Djg-1
X-Mimecast-MFC-AGG-ID: PtMvcecvOTCh0HQvxF_Djg_1758793039
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so3555405e9.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758793039; x=1759397839;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sZteDAWiG7VxkIsADkOw6B3yeLgEfE4eGqGu+VCIiwE=;
        b=vANc22Va/1t3Ur9hPZKdfehivS+nlvZJMPaAWYIaIKwVpKvwuwqKy2weGuJiUZG+FT
         ydxgAOu5QgD1Gt64MDdeI1ukbgxS3ENqPno0OR74FUnoLDumy00ZHbELFPBLDGuXtUp1
         4o4IrrPgcJASRfkFYbUbcag/vC1xl+gOw4GemjmFjgsvERUdv/VbFUV4jwBeQ4gDkJhs
         gKfp0Ck4CrudhYlzGWTF7d5qmM6BotQy+Mza2/0g5QSbFBsvZUQEeJc+cwXoPLujXpIF
         AXQ8jhBi9tYz5f6DGfVA+Dl6PDpDzl2bXdCCuqpOjrDGPFwm+bO1T4XmhLb9/a85qNWl
         JI4w==
X-Forwarded-Encrypted: i=1; AJvYcCXTdnOkkTLZI4i+ZCQW1Fn51xsryGi1JEtNbSplM1j1ejPcO930EvvKBkM1x09OA82S/luwCWvPJQ==@kvack.org
X-Gm-Message-State: AOJu0YyTdut1I9G7+eI8LAG+LT0OTKtU941mxjecx9aHI+IiI//K79uV
	Mgcg14Uu37LeqY7ESQEX5nryw80T/GUTclrgQBXwVTF+19f8yh9aMV8dW3mMxS3a71/zfk7dRai
	UGuR2jMADry15baBayrx9n3jiwdkvNR5OUZe0RE5wvi9Ue+u/pOWZ
X-Gm-Gg: ASbGncuTJp20ISvr1kfHKm0MBtYBe1whrdJ1+j/Br+oqgl2Q/J95oIgOo61roRnIywF
	eS1B3oc0+u4E7hBbvIRIdow5DuXAKwEwIlaaGmT+DH99RgmNm7apJDWERQIe4dW7np59Yyhf5a7
	PtJRwCPbVmN6TAIzczgSuMbgj2hG5UMsQe6JDVyL3qEBNSZbTnjoN9x9MfeV8PckqVrB3BR6/8o
	X2WmlRvLyneWPijHlE5wwpWWsIFLKo1BkECxw/dpPeS3FboF+qGJNBkqqtZVg21QIxZoISO8Bve
	5qCJJo4OFo0EV7Jv3PlXn99R3P7Lvxeb5UtDdYzENwSmbiIBdTm0P/Lr2Z6yn0rLqSQIpLb11h3
	8WkNckzNoUy/S7uNNh8nl9tsBqBtrcwewySELV36VkYdVF/J8eIEHqp66pHY90McvVUIT
X-Received: by 2002:a05:6000:3101:b0:3eb:df84:60f with SMTP id ffacd0b85a97d-40e4cc62f3fmr2681551f8f.48.1758793039375;
        Thu, 25 Sep 2025 02:37:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFA9Jm8uD5qp7JBwQIe1Kc6nNA+w35IPqMMEbFkiOgpMPy54NFOFR6LoswdfAvKNPYZ4HWLEA==
X-Received: by 2002:a05:6000:3101:b0:3eb:df84:60f with SMTP id ffacd0b85a97d-40e4cc62f3fmr2681517f8f.48.1758793038927;
        Thu, 25 Sep 2025 02:37:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602efdsm2323755f8f.34.2025.09.25.02.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 02:37:18 -0700 (PDT)
Message-ID: <95080e61-7009-4e5c-86aa-25ab7356f840@redhat.com>
Date: Thu, 25 Sep 2025 11:37:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] drivers/base/node: merge register_one_node() and
 register_node() to a single function.
To: Mike Rapoport <rppt@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Ritesh Harjani <ritesh.list@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Danilo Krummrich <dakr@kernel.org>, Dave Jiang <dave.jiang@intel.com>
References: <cover.1758736423.git.donettom@linux.ibm.com>
 <40257b5228dec05e5b252f02438608eb8d681a2d.1758736423.git.donettom@linux.ibm.com>
 <0de65980-4333-434a-ae7d-2b7be46c2cca@redhat.com>
 <aNUMnK23qKTjgEdO@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNUMnK23qKTjgEdO@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pm62PegFstV7Z-ygrwv_jfhVx80Xmf6ywp26D35QFIg_1758793039
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9139A40002
X-Stat-Signature: 51tnfw9zehu4wnqf517hgt9qndy1n14p
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758793044-472135
X-HE-Meta: U2FsdGVkX18V+K73ptBokEY2ijmViVXkPMrh6SZsuaZLq2Dqx/V3lWigvXdO+A0I/CCJ1s+xl1L8EyBufOMhoIhMO5bbmUOTRie7WE/M+CKa4MKOXuq1FsYJ5H7K19hEojRvVBMNm1Rxt7fDy6pydi9nCoQXSnrxeQsYge0H9YCBC9eWOWhkE6G7Yq/lU7IXWc8nKq4hwfgRACeOg5vRlxXvifhQlTYg0OIX0ik4oWwg2sDYrk2mhqhlaztcf9Q08OA91onHhvY71ceI+00OvoKQzCnK+Ka+GIKMLkKTCmKgYhEA9jXAJjKj7oOiXp9hWU8S0I8W+KarudFDXOLBgKA97+zCEw6aZjr+Hg4ZMBoxIGCnfMM6gcilcyU+EStTf1NvNVKMujTRj0m7WCbkUCmjLlFV0tIn7CNFwOkEh9PlmvdHHuQwX72AUVwqHaHmbVIzlA7SSAmuI5QAFiR+fXdorIIpH177pp4IdEv3/pAur+rpVekkVgqJYycQW2fKQqGTz6JtpTPbBoBN0/L/QYmV/rduQ6vq/0/BuHGqq0a1YhoheW+2YpfnNSw1AULHQVCw3LwKOikC8ck/Wimicg/oaoiG+z6w4s39CVglhEGfT2UdeUxO4VPFBb15KukhaJFoyObuBxq451H/5nZCZOFr1pAUoSeghw+uNkf77qwy6zPvKcDjoEP48H9Kpz6HzVDIuylPMsxfrA3eUXQTzOt6Bo2ymSz/QDXI5UzypGgFYGwvSR59cEOXgXbTAyNRAdu0lF7NSXDiE9semHh2QOByBB/TmI+0puVjjBI2abMQYX+8cXoeP6W2gaV9O8RknkzJGEM8UkWyb9xtMumPk2/WyiTsZQHieDL28/tqmqFlh+vvSBB6JERhXLSPvbzrvYWjAOXEcqYltip7f88Yj1OEiG3oRt2Ud/+4yRXMmol9zZ0qNSN2goRf+3P4gygHUdtX1x8MA/0jxWgdqoR
 jLQE8M//
 yWs4yGPhh3W3CCU+/TUOvINAHvmyi+gva4MS39lniaRpsN1ahpfiQHfVhGucbky1NGkYZw8+wR40jDUnLqNgh8zX/azgM2ACvixRw4kAEIzW9pF/VEtbFTUYOlhdpUGY7TZyM1fHUERQ+mYEHoLXSXILdFa0/+InUK/8U8eu6qqKRbiT4ecjR7lCyTBeKPwY7KFFqsVatBh27kGc/sQhCsnv4a7tp8fdKCYx1ABq8hJpDBIfFTu4g6N2H/fNtB5UZH55EUJEllRQal1R/6gzbqWDRZaxxGyFrSiOXSdM0K8HfnHQzQea9erI/yvR6cmY80FXdSOD0UDB2YOEYzbHQxF9mCZ0hs4pbAqSSJEmEDL4E/M27M9ssnkpV/5esO2NiRrIVAsRvwnWHV58veJl+BjhooafhC9OJ5hqqa93Si6adT7vp3JKsVAUZCoFXQXxmu+SG7P6iHyQ4XwiPMtucqsAvuF3mX4Km/fscn8iaQ4fMguueV4r7z8NQIYuPo6VTmcYI2Bt5hR0dQTDXyS9VDQ+VI8dhZT0CrvDpzmlfVJorvpvjFKon987pHmlPlLvJ39O+3Xnm1ztX5WgarcIg4HJhFDVcCyMGoTLBRBunaCWEOcpllBBO+fRQYQUipMYnD/u5CUPEHehAy7t73/OxoliYTGDlWxTHD6cz4xon1vM3dpniFxYNu2ZuZ8rebFqonsX2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 11:34, Mike Rapoport wrote:
> On Thu, Sep 25, 2025 at 10:54:07AM +0200, David Hildenbrand wrote:
>> On 24.09.25 20:40, Donet Tom wrote:
>>> register_one_node() and register_node() are small functions.
>>> This patch merges them into a single function named register_node()
>>> to improve code readability.
>>>
>>> No functional changes are introduced.
>>>
>>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>>> ---
>>
>> [...]
>>
>>>    /**
>>>     * unregister_node - unregister a node device
>>>     * @node: node going away
>>> @@ -869,7 +842,13 @@ void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
>>>    }
>>>    #endif /* CONFIG_MEMORY_HOTPLUG */
>>> -int register_one_node(int nid)
>>> +/*
>>
>> We can directly convert this to proper kernel doc by using /**
>>
>>> + * register_node - Setup a sysfs device for a node.
>>> + * @nid - Node number to use when creating the device.
>>> + *
>>> + * Initialize and register the node device.
>>
>> and briefly describing what the return value means
>>
>> "Returns 0 on success, ..."
> 
> For kernel-doc it should be
> 
> Return: 0 on success, ...

Yeah; I recall that kerneldoc does not complain when using "Returns 
...", but probably it will not be indicated accordingly.

-- 
Cheers

David / dhildenb


