Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC62CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 08:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0546B8E000E; Wed,  8 Oct 2025 04:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20998E0002; Wed,  8 Oct 2025 04:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10948E000E; Wed,  8 Oct 2025 04:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CFCBC8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:05:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48D2658FAD
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:05:46 +0000 (UTC)
X-FDA: 83974213092.22.5919AF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id E8DBD80015
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:05:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ErINyHjp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759910744; a=rsa-sha256;
	cv=none;
	b=vxYT7Bpf/J5Oxl49UyNBBqwdKJPE1yhnn0yK4TJHLT4OhPWXKPQkunSZaE+IyWkefuKmRU
	b2CChFTO/ot/wwVgxbvZsft0Vv3RMlossLo7TwIyHUjYsy81Ebs2w0W6so2t+Oy2STpYya
	cZV1KaEUOuXNVL8AqseJyxV+fkl3k2M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ErINyHjp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759910744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fckckqu8FhSLe+YJGblmZ5Veu3gXLrLCsl3rTsripxs=;
	b=V7NKMyKcQJfCiag/751lATvPvbgRcIjmH5k2kzfjBbNCzYGXClptdx2z3vujvmR6d52DF/
	XjUq1NcWCPotIXauuVRlBaZeIEyVz7UhvSwd7bTIxUSeWF/xJaU0emnL3JtBgc3+e3msEM
	L8EOOH+RjXaOrOzm3m7T5jMrNbl0XRE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759910743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fckckqu8FhSLe+YJGblmZ5Veu3gXLrLCsl3rTsripxs=;
	b=ErINyHjpcPMn/buFcwqkkyl7/ECnVH/DPVQJb6X2mWY3ioFBpzcs7J6wS9FNyZY810vTOG
	bxu6lGSxvspMEOL+VbdUIDcDycRrZXJCdT6MichQdnDYrwL68b+AqtpWezRJzrJ8fnDaj8
	xj9Fq3A83jAaps2N2ODbeZuwnErPpwQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-omd15FybNnGUMTu3_pJABA-1; Wed, 08 Oct 2025 04:05:41 -0400
X-MC-Unique: omd15FybNnGUMTu3_pJABA-1
X-Mimecast-MFC-AGG-ID: omd15FybNnGUMTu3_pJABA_1759910741
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so35648175e9.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 01:05:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759910740; x=1760515540;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fckckqu8FhSLe+YJGblmZ5Veu3gXLrLCsl3rTsripxs=;
        b=XcsqUAo2EQt+Bx7pi53KHA2nMUuNJeNDzjAuIp/13lICaYpYzIBrjveNk6r92fZw0O
         5xNlOAw8RQRLhtY0hjOPNU3T9A/X/tdIygC+GUvXRt7cIqBKqpFgL8j8mRnTQ7ThfE7I
         KBE2EuRwa1t6RQJzX4Pjd+p/794FYdMZtnpvryvKQ7Ryqem1Rd3oMFryuO9B2QRvDVh2
         EXO2XjrRj5nBswE47xEghxOmxL92+LAldSQpN9gbqfw0BKZGDDtNAK9i1d5h4zp0MK0/
         bbzEhd4TmCZO3QM2GpLIZ21PwQefET0yqmYkz/Hek8krC8KR4osri0ReGFSVTom2JgY2
         Zb0w==
X-Forwarded-Encrypted: i=1; AJvYcCXypZfUpyozR2UwZpiTzt4IF2CO/MTPkoCYR6n8TkkgmJXCsEz5ZSK+PaQyirNwL+5wPioVYUbtkA==@kvack.org
X-Gm-Message-State: AOJu0Yz/L3uWW3HWH3Mf7pe6NbEiISuCWhRrtF4korq5aGfqOkFPLje8
	5evi1pnuWaVt7rYcA1n6UG0gfW4q9Nw379Bo4ycZZ3tyoN4PYvmMkSj9uUonql/xINQzZ6+AxXj
	DM/IDG/Q7wGMy8Ch+DsCr+b5Jr+NyTY498s9VAjXflvQfoXrmkhl0
X-Gm-Gg: ASbGncss1s9V8885kdtbngBj841wkLgHrrPGYmCWbBo3N6pBs1pBgy43NtvrZ/fAtkC
	2Ws2bBDccxexiskGEsSsoB4sVB0k6XQLE9fRRZydoNcKWHrqryWa1Ctbs8IgUgCL55QGycNZrHK
	sokey9xiXoGh5HQxdILLE/huS2xfck8PCJjhNkVWnqyk7CeR6VRr747v8oc+BTti0n3Q70LXIfx
	2ZGqumXBNZH8ExiJI80k0ZaW/aOZiXTmw/qmz65jpzt9BRlGng2MkBsQYoqizBNcxsGsVWxwPXz
	c8qe1fsL7u8izSfIcHpaIuwBgPzpWhgtBukoFiTrzkbkXtGOoOLN1PHjyw9CQojhUZ9Ww/2uQ6W
	mI445hTAd
X-Received: by 2002:a05:600c:1395:b0:46e:37fc:def0 with SMTP id 5b1f17b1804b1-46fa9a9efaamr17049975e9.9.1759910740319;
        Wed, 08 Oct 2025 01:05:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG01JXdA7zG4WT7hRXme96s2VqM9oTOcf5aTlv4lkpg5WkgJHOM8zu4tbyk7O6KwitLxTnxnw==
X-Received: by 2002:a05:600c:1395:b0:46e:37fc:def0 with SMTP id 5b1f17b1804b1-46fa9a9efaamr17049655e9.9.1759910739866;
        Wed, 08 Oct 2025 01:05:39 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8ac750sm29018283f8f.24.2025.10.08.01.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 01:05:39 -0700 (PDT)
Message-ID: <60066a80-4758-4034-bbd8-25d9c24861b9@redhat.com>
Date: Wed, 8 Oct 2025 10:05:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] s390/sclp: Add support for dynamic (de)configuration
 of memory
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-s390
 <linux-s390@vger.kernel.org>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <20250926131527.3260733-3-sumanthk@linux.ibm.com>
 <4e832570-32f8-46a5-80d0-40570db862b2@redhat.com>
 <aOYIwEGgrjpNMGKD@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOYIwEGgrjpNMGKD@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XGZj29tr7MOdOnvIKUxHR6Pf1-SLmzE2UMSgNOLMTlc_1759910741
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E8DBD80015
X-Stat-Signature: 1xmo8k4n7c4ignwmf1e7dryrifmt1m4t
X-HE-Tag: 1759910743-215055
X-HE-Meta: U2FsdGVkX19MXKLvQQ0Qg4Je0w0gwgY18Fy7FII/GxgLXD7ROHJimrwaqpZG+g+cyBF8ihCaTj51LBjxfzMSGvE4Kzerfyk6xD+kf9Mg2/dYTnIXcZZ3x5RGJYcLsG3asVxBur32mkPre63d9HWTJkryAsvgKeVVhOG3MGyWft705Z9h2lYLLE9oMR9edD3bZcCv2H4ySnpcrrZNX7h6NVS/9FfIHtmDDP/hPNg+7OBUmIoS3gY0GDVoKU5q4G7xxpb2KmSJuOaeO+Pg21rK1rT0Ys9LXRzFscr4fDAjaah1IW3mmh+nE9tI3bvzMHYcV8yIoeOnbEX9eHgI4VU8/J+XTmgB9u6pBcUOc1NyDPGtqVrEo42e4hpujXUBGpCQC7wwn1DPxatbGOX/6x/bL4vZHEfLInXqq5bNOCy1ZaD0VSrj8Yu3mqzrjFUn3GgO5hSY0qzv+YLn72ZFogJXeab6jMSaRvn9uWIzudemLTG7H+TOyyJfvvKgA8LncXuyRuQ8SI+i6w7wbz0X89nuFrAQ0MiapOMl1/l4CSzvPkwFz8L2lT6u+Y/nJhTp/yYQ3hhyKqzU/zdAg/kE3Lhgk/FRp+APBmeBWlpAqjt+lezeZZc24iH39M/Cibn8k5YkCNVls0GIPlGZLk0V2eDy5ZCe4+KjPjeUtzIcPMv5PoU0lTJBu9fRd3j822wwbh97s4Oz7PvmWZzVPH6lXQ7nb4pGIC0A8bh4Gg0NM43ysWZqHqtVD1oapusIkXFj9dMK+sOw9pGC7yO0SetXf62cIcUlT3+JkMBMIqnVYKUY1FxSZSeqr5SuVDP4xvgBOLJCq3GtgeoyPXryCe2cINaTrGmlp2isErCff/HanPQBnSUSWQGBLMS8IbrQnc8+Zb6fVRhoRXB/dOG0LvD1/Cp8R00t3i2VtYKczD4+CVugwxbeteN6Xy8C3AMx7uOL2ERxL8mrrXheLdh2bt/97/m
 NO/1NJia
 +f5ue3xBbMqHxnhFqAfubxfl+LwJ1vzAV5V/1lPq4VeJ+M13s+ZW/GkfFCHPuDcZqfBYJCndNOg0ODDKda47UvngoGgueLyDWm2EG0dw6o1CBN26cX8gDMrKgb0UaJetay+CaBtC4dSoDlXf9wMWb6yjOm5E/tlgAOmsLqUJvmZ4pTaUUDLVVVZHpHmECDZ7lUit2plfGQTb4BJogAlXbKZLqbxZnxjLqGrl0FiydOFX3nVh7KmMyn1PITS9OUksI7gPZaflmPbXlQ3TtmvzvceY3T7fAkIqc4pb5lm4cPafeWKk+TOnmNX7VpZSi+iCMrDJeU+DOkJYtRD/r42dbo5QdAtn01DEfj3mUJ7cZ5n5fRz9p3A3tdi4usp8k+8myEXmb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Is there any reson this notifier is still needed? I'd assume we can just allow
>> for offlining + re-onlining as we please now.
>>
>> In fact, I'd assume we can get rid of the notifier entirely now?
> 
> I was initially uncertain about contains_standby_increment() use case
> and didnt change it here.  However, after testing by removing the
> contains_standby_increment() checks, I observed that the common memory
> hotplug code already prevents offlining a memory block that contains
> holes. This ensures safety without relying on these checks.
> 
> c5e79ef561b0 ("mm/memory_hotplug.c: don't allow to online/offline memory blocks with holes")

Rings a bell :)

> 
> i.e. #cp define storage 3504M standby 2148M
> This leads to a configuration where memory block 27 contains both
> assigned and standby incr.
> 
> But, offlining it will not succeed:
> chmem -d 0x00000000d8000000-0x00000000dfffffff
> chmem: Memory Block 27 (0x00000000d8000000-0x00000000dfffffff) disable
> failed: Invalid argument
> 
> Hence, I will remove it. Thanks.

Cool!

> 
>>> -	case MEM_PREPARE_ONLINE:
>>> -		/*
>>> -		 * Access the altmap_start_pfn and altmap_nr_pages fields
>>> -		 * within the struct memory_notify specifically when dealing
>>> -		 * with only MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers.
>>> -		 *
>>> -		 * When altmap is in use, take the specified memory range
>>> -		 * online, which includes the altmap.
>>> -		 */
>>> -		if (arg->altmap_nr_pages) {
>>> -			start = PFN_PHYS(arg->altmap_start_pfn);
>>> -			size += PFN_PHYS(arg->altmap_nr_pages);
>>> -		}
>>> -		rc = sclp_mem_change_state(start, size, 1);
>>> -		if (rc || !arg->altmap_nr_pages)
>>> -			break;
>>> -		/*
>>> -		 * Set CMMA state to nodat here, since the struct page memory
>>> -		 * at the beginning of the memory block will not go through the
>>> -		 * buddy allocator later.
>>> -		 */
>>> -		__arch_set_page_nodat((void *)__va(start), arg->altmap_nr_pages);
>>> +	default:
>>>    		break;
>>> -	case MEM_FINISH_OFFLINE:
>>> +	}
>>> +	return rc ? NOTIFY_BAD : NOTIFY_OK;
>>> +}
>>> +
>>> +static ssize_t config_mblock_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
>>> +{
>>> +	struct mblock *mblock = container_of(kobj, struct mblock, kobj);
>>> +
>>> +	return sysfs_emit(buf, "%u\n", READ_ONCE(mblock->config));
>>> +}
>>> +
>>> +static ssize_t config_mblock_store(struct kobject *kobj, struct kobj_attribute *attr,
>>> +				   const char *buf, size_t count)
>>> +{
>>> +	unsigned long long addr, block_size;
>>
>> "unsigned long" should be sufficient I'm sure :)
> 
> Left over. I will do so.
> 
>>> +	struct memory_block *mem;
>>> +	struct mblock *mblock;
>>> +	unsigned char id;
>>> +	bool value;
>>> +	int rc;
>>> +
>>> +	rc = kstrtobool(buf, &value);
>>> +	if (rc)
>>> +		return rc;
>>> +	mblock = container_of(kobj, struct mblock, kobj);
>>> +	block_size = memory_block_size_bytes();
>>> +	addr = mblock->id * block_size;
>>> +	/*
>>> +	 * Hold device_hotplug_lock when adding/removing memory blocks.
>>> +	 * Additionally, also protect calls to find_memory_block() and
>>> +	 * sclp_attach_storage().
>>> +	 */
>>> +	rc = lock_device_hotplug_sysfs();
>>> +	if (rc)
>>> +		goto out;
>>> +	for_each_clear_bit(id, sclp_storage_ids, sclp_max_storage_id + 1)
>>> +		sclp_attach_storage(id);
>>> +	if (value) {
>>> +		if (mblock->config)
>>> +			goto out_unlock;
>>> +		rc = sclp_mem_change_state(addr, block_size, 1);
>>> +		if (rc)
>>> +			goto out_unlock;
>>>    		/*
>>> -		 * When altmap is in use, take the specified memory range
>>> -		 * offline, which includes the altmap.
>>> +		 * Set entire memory block CMMA state to nodat. Later, when
>>> +		 * page tables pages are allocated via __add_memory(), those
>>> +		 * regions are marked __arch_set_page_dat().
>>>    		 */
>>> -		if (arg->altmap_nr_pages) {
>>> -			start = PFN_PHYS(arg->altmap_start_pfn);
>>> -			size += PFN_PHYS(arg->altmap_nr_pages);
>>> +		__arch_set_page_nodat((void *)__va(addr), block_size >> PAGE_SHIFT);
>>> +		rc = __add_memory(0, addr, block_size,
>>> +				  mblock->memmap_on_memory ?
>>> +				  MHP_MEMMAP_ON_MEMORY | MHP_OFFLINE_INACCESSIBLE : MHP_NONE);
>>> +		if (rc)
>>> +			goto out_unlock;
>>
>> Do we have to undo the state change?
> 
> Intention was to keep error handling simple. In case of failure in
> add_memory(), we would have state set to 1 (not given back). But,
> subsequent configuration request for that block will not have an impact.

I mean, if we can cleanup easily here by doing another 
sclp_mem_change_state(), I think we should just do that.

I'd assume that sclp_mem_change_state() to 0 will usually not fail (I 
might be wrong :) ).

[...]

>>> -static int __init sclp_detect_standby_memory(void)
>>> +static int __init sclp_setup_memory(void)
>>>    {
>>>    	struct read_storage_sccb *sccb;
>>>    	int i, id, assigned, rc;
>>> +	struct mblock *mblocks;
>>> +	struct kset *kset;
>>>    	/* No standby memory in kdump mode */
>>>    	if (oldmem_data.start)
>>
>> Wouldn't we still want to create the ones for initial memory at least?
> 
> Intention was the following:
> configuration and deconfiguration of memory with optional
> memmap-on-memory is mostly needed for only standby memory.
> 
> If standby memory is absent or sclp is unavailable, we continue using
> the previous behavior (only software offline/online), since the sclp
> memory notifier was not registered in that case before either.

I mean, probably nobody in the kdump kernel cares about it either way, 
agreed.

-- 
Cheers

David / dhildenb


