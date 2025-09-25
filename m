Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20585CAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BCF8E001D; Thu, 25 Sep 2025 04:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC348E0001; Thu, 25 Sep 2025 04:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3EA8E001D; Thu, 25 Sep 2025 04:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 352308E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:54:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02BBB1A039B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:54:15 +0000 (UTC)
X-FDA: 83927160912.13.4B77459
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9601040002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:54:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L8qNXfFe;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758790453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gsFn/xU4RBQz6XkcOaHJDRKfU+vBnP2TcZFpNfy7DE=;
	b=hWGIfRsuQFBdnYqIDF4wkpyQX18tNSeWLRDS7jyUJLEbdsow/gGhg4vQ09Kp7egUjrSl94
	iggmHujoxHDq0hD4qOGrOCu0bB28bG6CNgf+06y52ajupcf47qeXCl7T5zGFuXg3kPYDPr
	5qEr/C/YCx+KYvw2NrNObxKLp7CcqTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758790453; a=rsa-sha256;
	cv=none;
	b=jvEAT26+/sQSZ3otrA4j7hALWyYRVOOYsOSsI5dB/YWubVCKwCgNTnhdapZCm+JLH68w0j
	gNsYanX/4c5+KmzV4EHeQofQXl4WYYbWu+EnSKrvI8gsRDbD8lHhgq8TiCDcOR+8mLYrPI
	6Vszx7UzqzY8dfbsG2cTayO8HIUwQtI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L8qNXfFe;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758790453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1gsFn/xU4RBQz6XkcOaHJDRKfU+vBnP2TcZFpNfy7DE=;
	b=L8qNXfFeEOLppvPNn/xJwOZgG6U2A0lkFx6BbcTlQv4/pH/bQtK+PXeLxTmMRywrzzv19c
	dXI3TTAtDCVtQv9FIT6CBWw3t3Tur/IoCWXnts342L5TqD3EQPtYihOkdCEoGqnWkgnBFu
	NHHg8p0tNNZO4v/UOtACCI6LY4WAoNw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-DvuVSbi-NEWjG0uQVCKkJA-1; Thu, 25 Sep 2025 04:54:11 -0400
X-MC-Unique: DvuVSbi-NEWjG0uQVCKkJA-1
X-Mimecast-MFC-AGG-ID: DvuVSbi-NEWjG0uQVCKkJA_1758790450
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46da436df64so8062855e9.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758790450; x=1759395250;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1gsFn/xU4RBQz6XkcOaHJDRKfU+vBnP2TcZFpNfy7DE=;
        b=BWmxC4A40jGqAzfnOG8KktpIGNJ8jKh6z6R9E9LSpjknkmpXIAu7RHmKx45oCJLu2D
         nxHSzGXXefgYRBWfvRbS2AWF/+AeNzMVqCYyfpjIglx87s/Kh1vMweWCaJ/V6RFpOJgG
         DyQmfnKaKJKv1nOUqxtjzqcfb8ZxbYxDQtH2S7VNCGbRInYtvX2xe9Ih4KFFHSBLk/eW
         QJI8KQwipV8JNzuk4MDsVoF5UhSlU6+N5xNKoTiq5KAXmo0HTxasEBH2uqZcseYGQFS0
         Ekw0G/IazQ4kFdMsT88nLryXWRBD40Vs+Rn0UFZo6kowslhqYv4AYbSCQ1SL3B1paCv+
         n7CA==
X-Forwarded-Encrypted: i=1; AJvYcCUTjniRXkmgULywQqKGpoIUqBtqEHVJE/huxajgoPlxtyip8y8xps1KcWyYNVggRyTOtJBEDYCpTQ==@kvack.org
X-Gm-Message-State: AOJu0YxlSCogYWHEzfLyr7xpIFfoF4zQoMX4lTobqcNaqGD1rIezHK10
	YIch1U86J4iUS/5ytJTujGWUUSoHDNSw3yRYbJI/zrz9G4XU5xjpNK7+t6dCpNILVH8UgXHHvzd
	5OKGPdLoJrl+w5KX6epeg0y2gFXk3gyVXygVGP8HL5PeUWipgTNc6
X-Gm-Gg: ASbGncttMjRL9VcJOgHngiPHeQ9qbqldKCSi8BIodfK6R7ua6kpDyOhMMRz9SsZ/G4I
	Ws7kMx4plmip9q90FDOD5STeOYNppZ9C3oQg7in5Gpr8YJJuhw0FO7JHgojxw5oIw17IDsSBw9s
	beyJJZTwUlfjO3gUl36+9gXz/1FapIBHt+aGtWiFTY3Kv+OXcEwhQf5x74VtqZ23jxnDGYnBflh
	2E29o6WoZfVYUNvlanERyidgfubv73llRa8xB9a85gJ13Jl1NXHafAg5GpLzoEZ74UT2waZsxkJ
	LtJbGTCFhuS3KqtroOLspybqYbWW/evxaaOLrE889m4mVeLwYLhQf28u4qAri+YEocptMhOIjpr
	aVMzouy2o1M8cav8FqhzO6yYgY04oCMBWv2Dq0sooUbFBpmUqEXxZyB22GQYArVSXfnfb
X-Received: by 2002:a05:600c:45d4:b0:45f:2ed1:d1c5 with SMTP id 5b1f17b1804b1-46e32a26e4emr26084895e9.36.1758790450336;
        Thu, 25 Sep 2025 01:54:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7WIypjZMXxbyn5a/1aTfXoe6g5qRkRehIOgpqrXFKvpJdmOeQruAy+DajB3CSz8qmflRRXg==
X-Received: by 2002:a05:600c:45d4:b0:45f:2ed1:d1c5 with SMTP id 5b1f17b1804b1-46e32a26e4emr26084605e9.36.1758790449876;
        Thu, 25 Sep 2025 01:54:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb1a3sm2096184f8f.10.2025.09.25.01.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:54:09 -0700 (PDT)
Message-ID: <0de65980-4333-434a-ae7d-2b7be46c2cca@redhat.com>
Date: Thu, 25 Sep 2025 10:54:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] drivers/base/node: merge register_one_node() and
 register_node() to a single function.
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Danilo Krummrich <dakr@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>
References: <cover.1758736423.git.donettom@linux.ibm.com>
 <40257b5228dec05e5b252f02438608eb8d681a2d.1758736423.git.donettom@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <40257b5228dec05e5b252f02438608eb8d681a2d.1758736423.git.donettom@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MEzRIL20Foe6UtD4RJQQJtPuPaIm7DVky88dMoeLUFo_1758790450
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ofbkhaqwnrzmn3157ar343jexs3ai7c9
X-Rspamd-Queue-Id: 9601040002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758790453-188252
X-HE-Meta: U2FsdGVkX18roWgCOh9YAG0To1bm1TAEuGexR+6c8GU4zRnCS4MsjtXJEC4fPnnlESH0E59TYl3su2q8kY2f4EITsJ87j6MTpzj9Potaz9KbitfZjmCZ7twpuDcFRvseR174/+DSYSekBoGpttsWGS3M8XAm3vg2dQF21mLAqiJN7SMpKk080GHpWmELeCyfKc5+zm2BJCqWJbFr73M/MyPNuzL5fq77FmXJtE1v2Zl+LH03YnjbA/H6x6bbzS/jn6+0Z2d1Q8dhse8O7UEYzqzGy09F/HKH1SFGFdlFZE2DdQaD21kx2P8oYJdiBCO/wcJhz5oS2byy/ShPFmL5X1bhbhe0GuPD528l24s1j1XLQzp5RFL2v6GUUc2uxarT8Jeoa+nA5NBD7EKxmmTeZwpeabNIz2PYBq5fYT3kIAwKtKztSf4RHZ2FXnO4gZDFgcrFfOBY1FEB7YVQY5Qkh66t93yi17wQCORdBfuH2otp70U3ACCViD2VwZ6yExo/9qHgXhRJUN6slSL6baMRNm/ydi6afRWxhQDRsxe+TX47sJ7Bg6WQxqgT0u8q957LVU0AxYO8WV0OVvQPhnERdIy2MVQH2Dc8YrhL5t5rjtW5jz/gY4o39QbhGD1Rd8CZ6aJPxKqlu4qyQEBMBthYPCdyNL8mhYhPCmIXxr1fsZ8TS+PxHbIxKhJmZu9yoJCRsbH/hAm0hFzHmbzXxYhBzSOkqTtScyRq6ST3b3lfcNvpnh95SHidKxSkAYnDDzfW2lKId8DdO3gu+nLcr7oLAGZpmVYnqB5wmP1dH03B1hduARlFYUgYpGvQmOj6f99PJemk/Bjldj2xuCp6UDDQGtd0XzZdgMMTC4d9E9yfSzOoSUseX6ohgljLATzXHtPhlEcNwHCBIOgdLkmS8BO7urRUyNcNLde3996uzs9kC6dY8tel4G5jgcGxziVx2c9IQB5+7YQrXDSUHrFcSaX
 K80YhdrZ
 f7wwd3HYv2EFvjeZ6UnWoYFnLIl9M36UbmgmjMjkJjIiLsQrkcJ0T+XETaJkwTqt1+iopr8FYRwYKHdvc9fd8goR1Ko/szODX03c/8MrfpOw8NnaUdaY2g6fibCTKoA6iccrRUCgS0qNymVFsxGnDxP1V/ZOnG+/y10Kjt6LvsKiUt/9FwUruX91iTit9pJ7dnZuZD+T0B3Q+O54Dz2fUnm2/Q0FYHaEpckpMA8NbHP2mj252midzbG+VKoLKns52R+eamlFAsKURwJ7PQD//B6c4vFk8mBPQtuWEEiCn+4Pt5T53yp+9+T/K3EHltK2OTue36WVbDCGeLa2Jk6Cy4u4NESGPxDmhfyrUnwChPZaP4p4Y6FIAzdnmJYWyC5DSJUoL377j+JnLuQJ6IA+rRSd5dBH/SSqkOwkh/uU4YKr17elJ/btn+9jSARW+VvbL87irgWZ3e/j8tMOGR3PdJGn6D9qKRM6ZYAMbVGgzJQN/j3gMBND9vmZgBJkHZNl2cGrNT0hsy2WeXgJGvu4fy0+zHqODo3FmgBwVXsJ/RRqb7I7qCp3TfL4MqmalHrVylCeC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 20:40, Donet Tom wrote:
> register_one_node() and register_node() are small functions.
> This patch merges them into a single function named register_node()
> to improve code readability.
> 
> No functional changes are introduced.
> 
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---

[...]

>   /**
>    * unregister_node - unregister a node device
>    * @node: node going away
> @@ -869,7 +842,13 @@ void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
>   }
>   #endif /* CONFIG_MEMORY_HOTPLUG */
>   
> -int register_one_node(int nid)
> +/*

We can directly convert this to proper kernel doc by using /**

> + * register_node - Setup a sysfs device for a node.
> + * @nid - Node number to use when creating the device.
> + *
> + * Initialize and register the node device.

and briefly describing what the return value means

"Returns 0 on success, ..."

> + */
> +int register_node(int nid)
>   {
>   	int error;
>   	int cpu;
> @@ -880,14 +859,23 @@ int register_one_node(int nid)
>   		return -ENOMEM;
>   
>   	INIT_LIST_HEAD(&node->access_list);
> -	node_devices[nid] = node;
>   
> -	error = register_node(node_devices[nid], nid);
> +	node->dev.id = nid;
> +	node->dev.bus = &node_subsys;
> +	node->dev.release = node_device_release;
> +	node->dev.groups = node_dev_groups;
> +
> +	error = device_register(&node->dev);
>   	if (error) {
> -		node_devices[nid] = NULL;

Wondering why we did have this temporary setting of the node_devices[] 
in there. But I cannot immediately spot why it was required.

-- 
Cheers

David / dhildenb


