Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5045CCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1038E000D; Wed, 22 Oct 2025 14:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98C58E0002; Wed, 22 Oct 2025 14:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9877D8E000D; Wed, 22 Oct 2025 14:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87C678E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:32:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3247C16083C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:32:12 +0000 (UTC)
X-FDA: 84026594904.19.D3C88B2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 861F420006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:32:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FVwuqM1N;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761157929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/JbIxWbVPjgjOtLlLqeo5HXZLCpenJC/fAvBvHGrhY=;
	b=e3roVelt1v9SoLJLjNOVzyXn1wF1GuowN3/8uZi2w/i4gmL+mymm4WXgfmn8taObl98MES
	G4RRkikYitNXUp9jGD1ugcOpdpNYkwtbsppP8DKvK7tnvSfYgzil5T/wj+E4nTK1TmoUez
	hAAWDUxU4cIZjc7nFWkhq7vkDy38vmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761157929; a=rsa-sha256;
	cv=none;
	b=bawt+wDndV1Qx2My07dKdlMihI73SWVTf6YAYc1xvk8AXUpnC+vtQjh+n4HYOGADgvjxIB
	4ATYCtNTflAFODFawKYX4DBM9p6eGC/tNsxDvEPgvlnV40/oZvTE5gDrFD6Ycoqm4cy+yv
	JuQfPN2TdHacxbca3t4b2fbv9pbwX5M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FVwuqM1N;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761157928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C/JbIxWbVPjgjOtLlLqeo5HXZLCpenJC/fAvBvHGrhY=;
	b=FVwuqM1NAqVXPL8xsT75j9scipSWnSh8HNmq0Qu++fwIFMo2u3y6EWsogtQoDzhu5962mg
	JMUa6PfbvxtlvC7gNWQU+5YX5oR2W93InliEqiuEwLEKH+lrmOUlQ9WRaue/oVJ6ZJIRte
	8N63peYIwGnWcp2jAXhPP+h7b585aDQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-iAnLq3pQNJS-eX6Miy-QRw-1; Wed, 22 Oct 2025 14:32:04 -0400
X-MC-Unique: iAnLq3pQNJS-eX6Miy-QRw-1
X-Mimecast-MFC-AGG-ID: iAnLq3pQNJS-eX6Miy-QRw_1761157923
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471005f28d2so28211075e9.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761157923; x=1761762723;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C/JbIxWbVPjgjOtLlLqeo5HXZLCpenJC/fAvBvHGrhY=;
        b=FIuVH0cZzQt0vf18yowiQWT+rDMuCtzXo/Om6XJBiDJfMTCpi8baf0KJTz10jlKvFg
         uG+zFuHy85O2G/yWwCdJeAMfQGWlQAeoGpJf6Ak/73g/e2tYywPtjw3SNmqYoaqc7Lf7
         fSdbjkjqhIHyKoUebtnmupIpCidiAIb4EulhPwZMNnkvqGvOot8PQnGBYnoqvZGrgzUd
         fi4DGeAIJOFB2m1b46qM7Wxb5UZ+2S0/yOTD05ItSfbbDpZKMUoXIU9mnsxcRUQ5mySo
         JjO1JScZj/YbIC1gBwjpgXZAAwq841meH7X01XLGtf3WbYuTXH7CUe4+UOW8TmRzYDaK
         299w==
X-Forwarded-Encrypted: i=1; AJvYcCW4jN4IrStYodmFH51KSZnAhY8lpntXrpzUT40WvqVZcIivU+XQtajdc743k6U2jp2TJzewTAm2Iw==@kvack.org
X-Gm-Message-State: AOJu0Yz3hDGwc4ljw37ra1YHBUTChh6gVovVtfYZ7rIi/nv5C/WtaPOa
	nrRBuP4MTeld3wrooZsD0sJjNKra++d7Ut2zIS5PNqdx9+f8o9+7lrpTA01NPaGCAZSA3zD4rhh
	FoBHSGJvGvrecQJSL/JM7d7MMc1riGqT3W/lOkZoZ0gaUeCRyialV
X-Gm-Gg: ASbGncuGBtCy5cxOaUhrMpBz7T7wnsONpwE5T9wzKjXKJWcCIk/Y4yQfyAamJrg5UDP
	44V6TrmJPjd1d/94HEQN+chlxeXR3aNKJ2WuyqxGlx3eUUKbiTjNedXvp7i4dvk7/SSiTRySv+T
	mzgLGBQxHaeE3d80hqVyXo8yYNyQsg4XNQLiNi7yyi2TEfRkgUMr1voW1P1aOc/50zMv5PqTglN
	Q2BR/1TNlVHkFRBNoAd3mBlNMKgeCO/6ad2vmXBmA7EBXTunkRKReiJambCyRERGP2dmXHkNOOr
	J++/KUh1opiUU+i/OarEkBiOaxYbFJE+FaGmGfIVJiUuYune8MPS3y9YrAZvbiLknoVUCf5VJad
	RHA/bG4f6/iCK9yU6ovl7o89hjVRmTJeUfu56WbcKdbh5IViQ0XL6qBqEcRgATZD6y6XD9N9SE0
	yca66X1vA46uhlNDTnkUuOhEdq7yQ=
X-Received: by 2002:a05:600c:4e89:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-471178a236cmr148583415e9.10.1761157923150;
        Wed, 22 Oct 2025 11:32:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkqa/ppk8VcHZoDFi34/v5kHVDgvIPPynsre7cySVOZE5NngxycVOpUfHTE5B9ULebelTd5A==
X-Received: by 2002:a05:600c:4e89:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-471178a236cmr148583005e9.10.1761157922599;
        Wed, 22 Oct 2025 11:32:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-428566a7906sm3527685f8f.38.2025.10.22.11.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 11:32:01 -0700 (PDT)
Message-ID: <8537a80c-bc8f-4b2e-aba0-c7f8f1c437f9@redhat.com>
Date: Wed, 22 Oct 2025 20:31:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/8] x86/mm: Use 'ptdesc' when freeing PMD pages
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
 <20251022082635.2462433-5-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251022082635.2462433-5-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QoRuE7Jehq8SKDZU32GA4xEyywSapxbGaAwIHcZr0TI_1761157923
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: zeer86nfrjkw6reny4tn6pykjpgxoig3
X-Rspam-User: 
X-Rspamd-Queue-Id: 861F420006
X-HE-Tag: 1761157929-186472
X-HE-Meta: U2FsdGVkX1+7lXf7zIUgNxu4O/pFFyy2h56l9XHljs6oH3tgzIgMStNY/ODrc3mnHut9zIccQlOPXJQLorzFyQNUFkKFeg9LfL1uxrjcLD1/Eiu885oz7VzrGwbjS+uU/b12xy+K9He+HAhtLqrX4riqLfJWDBNhFIlAp2AFaauUOyCPOM7az7ewRTeDF6erMtGCWvZ1cdFsqPOxj5dBMohxeyQnjBCR+3CF2fo+0DbVdtnAGzYu0m5bD9upORymDuQ50upTTOvUmARul6reTfKtZzvg2pUFITPsO8aeaC5k6FrBJFy/0SLTKQ/1Azh4Cz6RbRoDOedO0rLuGZilHJjIMcg/dzPr4yg0Bh2P1caT8MEdSiSLY7gRHRR1HOIzT99lq57LywzpYYFx8qEGQwBKxYVKa0TmkAsJT5O+Zfsufsl6DizMyFGdvJ63Sd/PSIiuwVyO7EkYyT4oZ2pteJYTt1ImfZLlJS3Gi8n4J7wePDE4Nsc+AlPqzMYLH8DuRIzob5BCIvr2TD1bHFT3RL9GeFlFZSX6qUaLLxgRBJDixRWzOa5oGR19510CcW9+T7Opt0T29AU1qumjJ2ZSEDUtZiwQP6+z112FYi0QwxCqJ/MFLj0bqkRTsUdz6P9ecxqmVnRAqn8dssedcecjo8oqi/r+YFKBQG37+mwveLQEwrgXvbAatzZAfeOXMevHKfnizSUYZyMvj337FeBTMC2zsA3OgfWa/uW68jA2fc7Gvmqxxk5TzuoK79oyZMj2IbOT3Mfijuzw1oQqE8UH2cDkicQyjDNJ2EvJQOPqr7XwoRcJK2WNsRKe0hdApMHoPbyMjGKdf972MsDJ+I5m55Q2PFV9zDNZtr0VkjhCEIaefnpYzFkHIVkfvynn6rAYQz8T1BnNJHf01Nwupam6nPDBsRyq46Baw1GDsyfC8OLp/BX58t4db7oGZpARz+kbipBfNSQuGY4E8kIbck4
 Lr/Qvh/h
 y9vziDcqLuC/fGFc3SExY/zm1SiaDYXxt71ceOV7jEM5qbf8qWF4G8wKLVziN5fn0D9AsjZLuelOrhLYWdfPmn6WytpiA/o6msTLM7d2gj6NdM0K5NMd4V/8m7X6XgNPChds12+8X0Ah87aCpD/rtVha4Ul4fiv1LDwy0zSqLFgGrFIkOUTsHVikkkHA3wfm4Hx7QJZTwMP7kA8D9uKME5wBcGJ807uEbapn2DtkucpM98rR30GQQnHqYJkn+gegVnxKgxypjeset3Tvuo4hUo44BZVHH1643fjXj7AuS41+Dio9+36v6AiVj4XCWQ5GuaxR1MAVJ3SE7S9TA/a0XgoE5RD7wp7Hqp4SArLzBxXqhmOrMUXAno2VZfMVU/z/96LtZMEGAiXmyp9XrzKU866Ao5iJQRdn+TTX13pYGzdhwtp2QcT991gADAEo4QiRXbTAlyljvVl0+W9+u6phcOYBO5oM+pukWV6Tci/vKw5nLv8EFiTa5dpllXP24Lg2WrR96dur0N9rHBHUwgJIq9tpoi56/7r0LtI29tu9J8dxiD1A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 10:26, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> There are a billion ways to refer to a physical memory address.
> One of the x86 PMD freeing code location chooses to use a 'pte_t *' to
> point to a PMD page and then call a PTE-specific freeing function for
> it.  That's a bit wonky.
> 
> Just use a 'struct ptdesc *' instead. Its entire purpose is to refer
> to page table pages. It also means being able to remove an explicit
> cast.
> 
> Right now, pte_free_kernel() is a one-liner that calls
> pagetable_dtor_free(). Effectively, all this patch does is
> remove one superfluous __pa(__va(paddr)) conversion and then
> call pagetable_dtor_free() directly instead of through a helper.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


