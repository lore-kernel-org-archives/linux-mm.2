Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96ECBCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015D18E0022; Thu,  9 Oct 2025 15:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F268E0002; Thu,  9 Oct 2025 15:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E4D8E0022; Thu,  9 Oct 2025 15:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D10CB8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:29:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80DE8160B1D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:29:08 +0000 (UTC)
X-FDA: 83979563976.10.52C9E30
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9CC1818000E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:29:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WWxtIr6s;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760038146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYizE6uG9dNRCx3B33Lx7SghCaXuP30ktU90LRwaflI=;
	b=6qlAVaeaQ4hER+Fjxh/AfQecsqhLamjobuTBHMMftcZCq69LFAuhSdd3tvIGMipMX4CVc/
	Poj7Fz215yQ9LAC/TDTCV+7NNOK6veByfUboGFgANNRGfgsdxDhmpsfwFxK0fzctUACUAo
	KljvVuMXfvWmEQP5N6pPVFnXhhdo7BI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WWxtIr6s;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760038146; a=rsa-sha256;
	cv=none;
	b=o6cVybp5YljnEqnziqQvAHbGhZi39RIOninWQXzlb7wfQhOgOLzRxLlby8eL4Eq8yc/QWT
	BCRXwr9cyeHtcRyuu4WNvBQtRvVKZYhr8GW8Yq7RZtp/6ccK6IEJ96XD/JCtDwuJjr/b+6
	CiTds9rrD8lGKOATRjwTfSkrrBXBiSg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760038144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UYizE6uG9dNRCx3B33Lx7SghCaXuP30ktU90LRwaflI=;
	b=WWxtIr6s4W+dJ1A0jcdcOF0s1m1PVmGySPdBY6o2cmXCz0D4umNqP8sWJkf1cdh8wRCTx0
	WDZsQ5gFevoQq3DryCPH2+x09/nndftSIHJ0wiaz8c61ncjw/PMFVPV5jgYSK8bxPl56Y1
	RVLLUVfvO/0hd1IKM4Xg9u/S02UqlQ4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-VAiE0e_mOZeHmsUTwjYwhA-1; Thu, 09 Oct 2025 15:29:03 -0400
X-MC-Unique: VAiE0e_mOZeHmsUTwjYwhA-1
X-Mimecast-MFC-AGG-ID: VAiE0e_mOZeHmsUTwjYwhA_1760038142
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f93db57449so863585f8f.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760038142; x=1760642942;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UYizE6uG9dNRCx3B33Lx7SghCaXuP30ktU90LRwaflI=;
        b=kJZjcctvAph/QUTr4BhU4wGAMr/GHldCMRLmrKu+mS7Sgiq8HPwWO/Ef+TM1RpCtNi
         Mw9e6j3F0+b6LgnqXDo2bdcL7JLXE4r6lFo5c7WR2CCh+9dj1cQCX4wOcKBwnI9LtUqC
         aOqolxZTxDenI6YZ1WbT01n7d162SQiFCWAc2VHe//nwcNiPWkLp2NbOHQeSiYp6X8sc
         uXR7T8bSErs/4wNbnFSYHRJyE8jvgxZ0N8QCIR3GHpspbYzUET6UawU+c68Rwx6qIFgA
         uidamwaWheCvua1CbaumJar5acTilenSYadde3I6NcRGWt+KR6729tHAarCXBtxTkPpv
         9/Lw==
X-Forwarded-Encrypted: i=1; AJvYcCXa8SRqllosVdJuh+T1V1uxRHbucg8JTwv4FROgp0OSGWjZKW3LCIvgeUaBLZdaqnfZqLJCNw7T7w==@kvack.org
X-Gm-Message-State: AOJu0YxaFi53gEv95TIii7C/ylKvEiP+zBpjICquMy7fUb2emsAV+Y7A
	OI25YdK+RbRzr3mMogkQWr6vnMMgKcHxG4ukqF8waWdATvQD46S1ZCJ8hwaKsXQjcI2Nmxc/dOp
	2wrIqN7czaDu3Sd1pKh/MAB7JXY7wL2YWhnit+OkUoLn/GS/5+SZ5
X-Gm-Gg: ASbGncunZuflsKtwShVtW61lULHXnxGlFo0QJ4l1WNcuw3/XK2VWelvvipeoSr3SKDF
	pxYmW0wJJF+JRffaxTPjdnRyqOZBilHz4M3sPzURxdngMznX7XZJ8AoDpaaWICokBxq7Ud1taD5
	eYkt/2CQcPJDAKNt7PSnKNI1yfT15vhpZSzN2u2fVJxk0inlN4pZ1hm152hLhQAQBiP2f/sX82u
	XuWm0rYi5AqQSXQaZEjGB2xUUsQHuJTxyEI7Ipu6WNR4SNAedxAulAzaxF+d0y/D8S/Jj7uVki8
	UWRRNw96z1aS11pRJwN8iO7wpum+tcO0fwJs5DAliDQbm6Zsl3j8QKLefiBvnhMFLTq5ksJLt8M
	UE0VXYlyG
X-Received: by 2002:a05:6000:4313:b0:3ea:6680:8fb5 with SMTP id ffacd0b85a97d-42666ab29d5mr4954548f8f.2.1760038141765;
        Thu, 09 Oct 2025 12:29:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2gGT2xa1+bv3tEdvDcUr7e+R3VDfPgA0ByjD5pwZbjp/sJ5A191i0yd157sCivGgarXbQ8g==
X-Received: by 2002:a05:6000:4313:b0:3ea:6680:8fb5 with SMTP id ffacd0b85a97d-42666ab29d5mr4954535f8f.2.1760038141331;
        Thu, 09 Oct 2025 12:29:01 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5833dcsm468974f8f.19.2025.10.09.12.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 12:29:00 -0700 (PDT)
Message-ID: <4858074d-f058-41ec-a581-a8254b8cc2d7@redhat.com>
Date: Thu, 9 Oct 2025 21:28:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] mm: Introduce deferred freeing for kernel page
 tables
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-7-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250919054007.472493-7-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dgAhItM7E_RQUiMLk5HaSCKZj8DsFA8GZh0tfLArI-U_1760038142
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 16fytky8kqtg9t366ead6m5k6a5hnjef
X-Rspamd-Queue-Id: 9CC1818000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760038144-479091
X-HE-Meta: U2FsdGVkX18MJ0gMUc7BtR/5d6a+0NkMfFVTW0kr+7QRFXYD4hWRMqji5U9CH1/ceWv/GLyocX27p6egC9Y7Xp8vHUFKM99FYNuFSpQ1ocr/qQ9aIJcC7q+zX8qlQTjyYnu1NdSdc4YJ/ms1uGUgm0S8i0YtbQs8qyIwNylD6DK9P4yP1FE2VDkNeWFQmWl6qoTS/oeVAJELDiuG2+EFrqlkp6OpmfPfl1uHfDUlHSoH/V9SOu/QNTZvdizyiILMGrIik26gNUw8691zV/j/sPKPFYA0m27kCwDnl/IQa4vsKfV8NqQOWKFvU8hm6b0UFw34mYibYFRirtdkrDVVGGBDUpvtQolonpsdc92nO0HgoineYTq8yGKX7pDPPumO8ybCVqIfmFgWYeaI23PTWdm1uqSVh0IvAdWWz+Lp+Qc8MMw9puoo5KqOxTxZ03W2eMMEogIpcH90Cqnisz76HG8xuR21KUVh4bCqS9EoK/UXrgL++d2M1e8pUkDwAoQUSP5sbRlvCrpW2TxAP6CD2AJUWl/fA2Vz2ZC8UVBeI9UJxRyw/Nn0apcUqs1Tv5P6cTkmtI/Mer3IbJuU+ywjRq3ynd/X9HK3Z6zZgdPv9ziHNAh9MvLwnLiMqOOJz7n8TW5pG6NQaD0zyonIe4cQLfmZEgPS8PUrPH+/5qjXbxwih9YTo9o2a0XQ3rUQLi7/uDs/o1Y//WusRJWF9vjP7BBEwtRwcS/KNH3oGJBdFzkQYrDMo/X6t99A19wCJbLa0aEPE4fyMqvMMqyJOp7+UJJfrZN9w0vvQKq5zI3uRB131oNDxoq0SnPmu4iG1sUjyfq0FS4V74be4H69GWC+aRwxQljvBjcg3mphGw0LLfssgDHUf/tfOeGN5viFwzPH3d8ITGwBOgiGEsPo7cuupOMPgeRNrSclmtCnUtMyKngct6gi3NaFmfmSuL0TAGDUYQgquXXAixwcLqbkwP/
 FVKNHy07
 3kbvk58u91ZT2O1BRw3e2syi2uWeUejagRQdM41SgBTZ7P2DTib62G0/ejV7y22xeBmeyMaGouXjbsTLLFsshQ+HzXZkJ+hB8OYDcbZKRnGBOomlt+BqP4y+zaaoM9ms5bMkvFpq/iFwLnhCjtLzoMIm9Kur4EFB3owTgG0v0vdBLj6wPN2JjPy3dwTWTy6u8Q4qQ3+7YmeKTo4MWsYzaTjRLhCWvWySrKgzBm/wt7d7aRZ52opuYFkjvczg/LW1ujVEE3kRfCZgv72K4JBl5cxz6x+RZdfOOcbbBnAkC+h4RH2NnkVunYIQ84hcaDbFLhqlpqMP4oVQm8H6LsK6x9h5wFbIcOLKnIb2DsXO++Ushd73s7k7Q5NrZAllfcnJMhannON/+YS5jJUrKoaYF73NT+dIwGWL8+W2JeVww+iguQ9IuaKeTGm5FXGztTj68q1W1vrn2cpN0rXchEAVRplGi6lZ4SLJoawhWAHswzFS7UXT5FbyL+AVbEGqPphy7oR7yDLwrw7swQ4T+WQjV8scPgKI0kFQ6qc7S/Of0xo07r+qbAx/w3BnS5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 07:40, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This introduces a conditional asynchronous mechanism, enabled by
> CONFIG_ASYNC_PGTABLE_FREE. When enabled, this mechanism defers the freeing
> of pages that are used as page tables for kernel address mappings. These
> pages are now queued to a work struct instead of being freed immediately.
> 
> This deferred freeing provides a safe context for a future patch to add
> an IOMMU-specific callback, which might be expensive on large-scale
> systems. This ensures the necessary IOMMU cache invalidation is performed
> before the page is finally returned to the page allocator outside of any
> critical, non-sleepable path.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---

Can we please squash #7 in here and make sure to call the config knob 
something that indicates that it is for *kernel* page tables only?

ASYNC_KERNEL_PGTABLE_FREE

or sth like that.

-- 
Cheers

David / dhildenb


