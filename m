Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3BF5CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 20:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BAC8E000A; Tue,  7 Oct 2025 16:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF37A8E0002; Tue,  7 Oct 2025 16:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA508E000A; Tue,  7 Oct 2025 16:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A88DB8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:07:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B4BD119719
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:07:58 +0000 (UTC)
X-FDA: 83972404236.28.5CBD714
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7CE1120007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:07:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hjoUeec8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759867675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZWtRPRAS5M/Mqu6Yq+WEzz+s60+D69gx4sl9PmcrVQ=;
	b=nLz/7WR3uo+yjRXjSzRq//V9kUYBbsnVVkU3Qlw41fWpEZgWF57TL1tfsxa8nb0sDQstMc
	ETj2VchYmQvB3gztvsI1UuHJYbOS9aVQfjgeqPmDLPH6jXH7FI4rs/WOb5wbdnsGQvERNf
	TDlwRgn4O3lC9Dw29n8bVEYg2hYf/lQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759867675; a=rsa-sha256;
	cv=none;
	b=gw9hlBzwcDc/VLTbd8rKy/dtVsueP0c6veYfvGO/qEvI4fZKM16m7f3BQ9FPaIMskcKSW6
	aXgLGyRDa2ns3NoeL7Ue4WAQd9HzJPRJtZ068xaz2cKL9S4S05jiQQnsHenfzputKazEB4
	CkJPw6Nu43jlZOlss9nDjodNN4SKgcg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hjoUeec8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759867675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KZWtRPRAS5M/Mqu6Yq+WEzz+s60+D69gx4sl9PmcrVQ=;
	b=hjoUeec8XVLz22qNNPU3jJuyJLH7/9DaRVtq4XmIrgXv5WtOs+rdgOsAX7pNFUi04nSpgR
	7z+gOdrmzzg/6QyIHf+Y8sS0/Jga7Onh0VAMBL9j+QNSZAReBMt9TWFvaACKRb/vWAYvEE
	MbVD3C14QkLt3vDWXizcJWENvrcc9aI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-dXTZ6n5_NemsDYKotK3ZQw-1; Tue, 07 Oct 2025 16:07:48 -0400
X-MC-Unique: dXTZ6n5_NemsDYKotK3ZQw-1
X-Mimecast-MFC-AGG-ID: dXTZ6n5_NemsDYKotK3ZQw_1759867667
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3efa77de998so4033272f8f.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 13:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759867667; x=1760472467;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KZWtRPRAS5M/Mqu6Yq+WEzz+s60+D69gx4sl9PmcrVQ=;
        b=SDkH6UUyTB/YrV6tALQUI+lb6fcELucNmHkVUKu0t6zDeLfYZnh1rpcCm3VHr3gg6a
         jsTrEKFqebmNw5WsNE9lEl9J4LhxjL38fqMqyZMCkGP+I+DW93Bw7Jflrrl69HvOU6pE
         AqaPAbTTtyqP3d8ow4Muv7zp+p2uAQlpgOoN1AaVxCZ7XiOS7fMFvlm3Zzp2VaRzUEYm
         gyxSEXbos0JYxOMAC535yjBkD/37i4jHi1hOKbceI0cv4Zc1dKAH7Ls0M5tuD1TUw8w+
         fA6g1EwRBQvQ1FZwPbu/z2WhvIl71ZZXZuQk6BpWt49L7O6Hbn+VZcvZTpZULPy9yNg2
         EvYg==
X-Forwarded-Encrypted: i=1; AJvYcCUa0D3KoraCG262Q4GoMdIVbggYW8Y92xRqudieiPwbAPY2MaoXO7jt9FKToAR9uxCnRa/0VMyQ6Q==@kvack.org
X-Gm-Message-State: AOJu0YzhtsLwnz3GV/CN58CpSYpoqvDRPWnUJT0eaqDQ/9ahOgMiiW3R
	VwBkqsmQpO/RDAHJRPwqN1IBB4oalPrStpswc1M1RjX7rkDRcTkBBIm02D0qqgKy0MVORt/xlqY
	H+jUk0VuKAbEJ5J3tzIZSuKfluTPy8su0/cW/POitEP//OFEQbGrK
X-Gm-Gg: ASbGncvYBA9VoVSkLxCi58q1YQOJoPsuT0Iany2Kxn3vRamI/ZmxOU2A4IVzbJLGrnp
	YLcENI/p831AaTVdxofjQcVR8Tra3EZ9cEP8yaZdZzzLrnD2OypmaNB/wfg+ka/WVoCUNzevSfp
	B/Fyf9lkWcQjZApPGqO/o5Fgu0uKrSRN9JQ35hxYM1LWCDPRKBeljrs1oYaDf4TbeA+VasOuseo
	8gtHzqBBGH5OTyt5E/Ps0cKzywMv631/GScuJopVDEah8v6YezGuqFjWlIESrvyiRi7dTojx3Zs
	rtk6NiDWfuAVLoQtgnWcxcE59bDAYbi7E+K8orUMebjSz8aDs8tOg6MogBn0ng4TgVrKNzw3XRj
	THDcxI7sW
X-Received: by 2002:a05:6000:43c5:20b0:3ee:15b9:97c4 with SMTP id ffacd0b85a97d-4266e8ddf61mr331883f8f.52.1759867666859;
        Tue, 07 Oct 2025 13:07:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEr1PW4m5/FF6BmhJ8u2j1Qha4jH7rsLR7j9e29PZBO61t6Syb78H/Hp+hjsbAb6k9W8aBS5A==
X-Received: by 2002:a05:6000:43c5:20b0:3ee:15b9:97c4 with SMTP id ffacd0b85a97d-4266e8ddf61mr331868f8f.52.1759867666391;
        Tue, 07 Oct 2025 13:07:46 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d6fb41sm6808515e9.17.2025.10.07.13.07.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 13:07:45 -0700 (PDT)
Message-ID: <4e832570-32f8-46a5-80d0-40570db862b2@redhat.com>
Date: Tue, 7 Oct 2025 22:07:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] s390/sclp: Add support for dynamic (de)configuration
 of memory
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 linux-s390 <linux-s390@vger.kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <20250926131527.3260733-3-sumanthk@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250926131527.3260733-3-sumanthk@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z43N6BK-ovrBHHlF3eNk_L74A-H6Jx5aoIyeH1W7ztY_1759867667
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B7CE1120007
X-Rspamd-Server: rspam02
X-Stat-Signature: ft9n576tz9dwxt1tizc3psz7kc3nanzk
X-HE-Tag: 1759867675-656955
X-HE-Meta: U2FsdGVkX18dHuTPfV+mIq0yYStjzR64C3C5WxXdCdUjs5WgAWMw1RQvoddjvOor6xY5YWPYw20ra4TQnAv/TruHNWTEywm9BPsLX53ZBsS1qifW7eq4TcNmJQJflC27d7uxmuswcy+s8DQhdR7hQPuK2d7zHbcPKxKc0+8PBZ/5tWLaB5uHVlrY/47pBGbiKXMK/qhw7VNcQHuKGYZW+SXJd0UyddZkC+mQtT1elv9nfYVavHb2YMJTmND755O2eIVSIRvhugaCqSTuZy1m7qalpk5CjlG23XkxVgxldnGy+pnB2H/8ItluXJ73uvZ8vZwy/kA9TGZmahrEpEbNjxquI0QaaNtGe4aKTqgiJj4tQNzOOqd+C3vnoV0sRhkz3p0GfTZ3napDxUvhYMv7gEtpKyYULGNttYZy38xgiumC4cGIwK4GSd2khOeTmfetvz6iXOW+AbP+/4HB1/U15Zo/alVHzt+n3H60bU/6MBwrKNdUVU0vB8UYZIi6QXZ+pccsnQocD8GpmdzwD3BYKWLymKORmX3H4MYTep49xZMysnq0Ht+eKnCMsKnR/tBa96VzYfYXYoFBoqa+Wsd9MhdH0mzC0MVkd77AGHkZrshtdYPNe/MUnIDDFnJvGY1qP/1LHkEqL1vAgR39mo+M5wRcTjVGwjJeaPoXymWMMUnwo1xudHgqUgHhQlWWWfQ4GXuT142xkLK7amloEhQMmFVA3DI9EAZnVO9EKpRDDtRF71Kz8tJ0WfaZ0SpNvqgw/GPZ7qA82iO4ZspbPq5KY2oVsFNdRYZzttkK3//AFthp9Ey0gCs5Gb9Lb1mZNjl5QHgkocvGqaBeSjptM9NGJBc2iwBvr7F7tPWiQAt3piEsH9kMvEzYNXv/d8k2Tm5vZklzbrO3nkNDdEviYGFTHopQmsf4FPoiA1rVDzDBariuJ1EBm2xWPST8esnfkslfNOKM9XF1Tx3+UCKg9In
 iwk7SYEL
 RrGCiPOCCOMbiHk84iy5yKIM1AK+VNxc0oqdTp8yg92YQkPvg35VV8otmVqVlsAMdbDjWcpL4AOnqqVFbHgBZfrS/QYrG+mj3y5hvAj1cKb+LMU9QTH+VvWL1b5tecKPAq4T4503z9acKRW0RC0MktdC4CwlMqHGVScr4Ng7v1Nmx8X/ow7RabhiqzYaCtxRVRMr8qPdkejCM6Y16Rlr6WNt/VjS/1KfHIM7VIX025+f+RItIR+xkUT+kRgGkvA+YUcBoYUYxHTNySlm6GNqzoE8Hb7obWnFZ+cXBGTVAeux1muxilCD57KKKm9+6/WTenfo1SS5ozTImuklbxlbIbeLao9lK6ANR/9U+TmPksf10qTK8qiL8C1OvusImVp32utyh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> ---
>   drivers/s390/char/sclp_mem.c | 291 +++++++++++++++++++++++++++++------
>   1 file changed, 241 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
> index 27f49f5fd358..802439230294 100644
> --- a/drivers/s390/char/sclp_mem.c
> +++ b/drivers/s390/char/sclp_mem.c
> @@ -9,9 +9,12 @@
>   #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
>   
>   #include <linux/cpufeature.h>
> +#include <linux/container_of.h>
>   #include <linux/err.h>
>   #include <linux/errno.h>
>   #include <linux/init.h>
> +#include <linux/kobject.h>
> +#include <linux/kstrtox.h>
>   #include <linux/memory.h>
>   #include <linux/memory_hotplug.h>
>   #include <linux/mm.h>
> @@ -27,7 +30,6 @@
>   #define SCLP_CMDW_ASSIGN_STORAGE		0x000d0001
>   #define SCLP_CMDW_UNASSIGN_STORAGE		0x000c0001
>   
> -static DEFINE_MUTEX(sclp_mem_mutex);
>   static LIST_HEAD(sclp_mem_list);
>   static u8 sclp_max_storage_id;
>   static DECLARE_BITMAP(sclp_storage_ids, 256);
> @@ -38,6 +40,18 @@ struct memory_increment {
>   	int standby;
>   };
>   
> +struct mblock {
> +	struct kobject kobj;
> +	unsigned int id;
> +	unsigned int memmap_on_memory;
> +	unsigned int config;
> +};
> +
> +struct memory_block_arg {
> +	struct mblock *mblocks;
> +	struct kset *kset;
> +};

I would avoid using "memory_block_arg" as it reminds of core mm "struct memory_block".

Similarly, I'd not call this "mblock".

What about incorporating the "sclp" side of things?

"struct sclp_mem" / "struct sclp_mem_arg"

Nicely fits "sclp_mem.c" ;)

Something like that might be better.

> +
>   struct assign_storage_sccb {
>   	struct sccb_header header;
>   	u16 rn;
> @@ -185,15 +199,11 @@ static int sclp_mem_notifier(struct notifier_block *nb,
>   {
>   	unsigned long start, size;
>   	struct memory_notify *arg;
> -	unsigned char id;
>   	int rc = 0;
>   
>   	arg = data;
>   	start = arg->start_pfn << PAGE_SHIFT;
>   	size = arg->nr_pages << PAGE_SHIFT;
> -	mutex_lock(&sclp_mem_mutex);
> -	for_each_clear_bit(id, sclp_storage_ids, sclp_max_storage_id + 1)
> -		sclp_attach_storage(id);
>   	switch (action) {
>   	case MEM_GOING_OFFLINE:
>   		/*
> @@ -204,45 +214,201 @@ static int sclp_mem_notifier(struct notifier_block *nb,
>   		if (contains_standby_increment(start, start + size))
>   			rc = -EPERM;
>   		break;

Is there any reson this notifier is still needed? I'd assume we can just allow
for offlining + re-onlining as we please now.

In fact, I'd assume we can get rid of the notifier entirely now?

> -	case MEM_PREPARE_ONLINE:
> -		/*
> -		 * Access the altmap_start_pfn and altmap_nr_pages fields
> -		 * within the struct memory_notify specifically when dealing
> -		 * with only MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers.
> -		 *
> -		 * When altmap is in use, take the specified memory range
> -		 * online, which includes the altmap.
> -		 */
> -		if (arg->altmap_nr_pages) {
> -			start = PFN_PHYS(arg->altmap_start_pfn);
> -			size += PFN_PHYS(arg->altmap_nr_pages);
> -		}
> -		rc = sclp_mem_change_state(start, size, 1);
> -		if (rc || !arg->altmap_nr_pages)
> -			break;
> -		/*
> -		 * Set CMMA state to nodat here, since the struct page memory
> -		 * at the beginning of the memory block will not go through the
> -		 * buddy allocator later.
> -		 */
> -		__arch_set_page_nodat((void *)__va(start), arg->altmap_nr_pages);
> +	default:
>   		break;
> -	case MEM_FINISH_OFFLINE:
> +	}
> +	return rc ? NOTIFY_BAD : NOTIFY_OK;
> +}
> +
> +static ssize_t config_mblock_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
> +{
> +	struct mblock *mblock = container_of(kobj, struct mblock, kobj);
> +
> +	return sysfs_emit(buf, "%u\n", READ_ONCE(mblock->config));
> +}
> +
> +static ssize_t config_mblock_store(struct kobject *kobj, struct kobj_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	unsigned long long addr, block_size;

"unsigned long" should be sufficient I'm sure :)

> +	struct memory_block *mem;
> +	struct mblock *mblock;
> +	unsigned char id;
> +	bool value;
> +	int rc;
> +
> +	rc = kstrtobool(buf, &value);
> +	if (rc)
> +		return rc;
> +	mblock = container_of(kobj, struct mblock, kobj);
> +	block_size = memory_block_size_bytes();
> +	addr = mblock->id * block_size;
> +	/*
> +	 * Hold device_hotplug_lock when adding/removing memory blocks.
> +	 * Additionally, also protect calls to find_memory_block() and
> +	 * sclp_attach_storage().
> +	 */
> +	rc = lock_device_hotplug_sysfs();
> +	if (rc)
> +		goto out;
> +	for_each_clear_bit(id, sclp_storage_ids, sclp_max_storage_id + 1)
> +		sclp_attach_storage(id);
> +	if (value) {
> +		if (mblock->config)
> +			goto out_unlock;
> +		rc = sclp_mem_change_state(addr, block_size, 1);
> +		if (rc)
> +			goto out_unlock;
>   		/*
> -		 * When altmap is in use, take the specified memory range
> -		 * offline, which includes the altmap.
> +		 * Set entire memory block CMMA state to nodat. Later, when
> +		 * page tables pages are allocated via __add_memory(), those
> +		 * regions are marked __arch_set_page_dat().
>   		 */
> -		if (arg->altmap_nr_pages) {
> -			start = PFN_PHYS(arg->altmap_start_pfn);
> -			size += PFN_PHYS(arg->altmap_nr_pages);
> +		__arch_set_page_nodat((void *)__va(addr), block_size >> PAGE_SHIFT);
> +		rc = __add_memory(0, addr, block_size,
> +				  mblock->memmap_on_memory ?
> +				  MHP_MEMMAP_ON_MEMORY | MHP_OFFLINE_INACCESSIBLE : MHP_NONE);
> +		if (rc)
> +			goto out_unlock;

Do we have to undo the state change?

> +		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(addr)));
> +		put_device(&mem->dev);
> +		WRITE_ONCE(mblock->config, 1);
> +	} else {
> +		if (!mblock->config)
> +			goto out_unlock;
> +		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(addr)));
> +		if (mem->state != MEM_OFFLINE) {
> +			put_device(&mem->dev);
> +			rc = -EBUSY;
> +			goto out_unlock;
>   		}
> -		sclp_mem_change_state(start, size, 0);
> -		break;
> -	default:
> -		break;
> +		/* drop the ref just got via find_memory_block() */
> +		put_device(&mem->dev);
> +		sclp_mem_change_state(addr, block_size, 0);
> +		__remove_memory(addr, block_size);
> +		WRITE_ONCE(mblock->config, 0);
>   	}
> -	mutex_unlock(&sclp_mem_mutex);
> -	return rc ? NOTIFY_BAD : NOTIFY_OK;
> +out_unlock:
> +	unlock_device_hotplug();
> +out:
> +	return rc ? rc : count;
> +}
> +
> +static ssize_t memmap_on_memory_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
> +{
> +	struct mblock *mblock = container_of(kobj, struct mblock, kobj);
> +
> +	return sysfs_emit(buf, "%u\n", READ_ONCE(mblock->memmap_on_memory));
> +}
> +
> +static ssize_t memmap_on_memory_store(struct kobject *kobj, struct kobj_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	unsigned long block_size;
> +	struct memory_block *mem;
> +	struct mblock *mblock;
> +	bool value;
> +	int rc;
> +
> +	rc = kstrtobool(buf, &value);
> +	if (rc)
> +		return rc;
> +	rc = lock_device_hotplug_sysfs();
> +	if (rc)
> +		return rc;
> +	block_size = memory_block_size_bytes();
> +	mblock = container_of(kobj, struct mblock, kobj);
> +	mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(mblock->id * block_size)));
> +	if (!mem) {
> +		WRITE_ONCE(mblock->memmap_on_memory, value);
> +	} else {
> +		put_device(&mem->dev);
> +		rc = -EBUSY;
> +	}
> +	unlock_device_hotplug();
> +	return rc ? rc : count;
> +}
> +
> +static void mblock_sysfs_release(struct kobject *kobj)
> +{
> +	struct mblock *mblock = container_of(kobj, struct mblock, kobj);
> +
> +	kfree(mblock);
> +}
> +
> +static const struct kobj_type ktype = {
> +	.release = mblock_sysfs_release,
> +	.sysfs_ops = &kobj_sysfs_ops,
> +};
> +
> +static struct kobj_attribute memmap_attr =
> +	__ATTR(memmap_on_memory, 0644, memmap_on_memory_show, memmap_on_memory_store);
> +static struct kobj_attribute config_attr =
> +	__ATTR(config, 0644, config_mblock_show, config_mblock_store);
> +
> +static struct attribute *mblock_attrs[] = {
> +	&memmap_attr.attr,
> +	&config_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mblock_attr_group = {
> +	.attrs = mblock_attrs,
> +};
> +
> +static int create_mblock(struct mblock *mblock, struct kset *kset,
> +			 unsigned int id, bool config, bool memmap_on_memory)
> +{
> +	int rc;
> +
> +	mblock->memmap_on_memory = memmap_on_memory;
> +	mblock->config = config;
> +	mblock->id = id;
> +	kobject_init(&mblock->kobj, &ktype);
> +	rc = kobject_add(&mblock->kobj, &kset->kobj, "memory%d", id);
> +	if (rc)
> +		return rc;
> +	rc = sysfs_create_group(&mblock->kobj, &mblock_attr_group);
> +	if (rc)
> +		kobject_put(&mblock->kobj);
> +	return rc;
> +}
> +
> +/*
> + * Create /sys/firmware/memory/memoryX for boottime configured online memory
> + * blocks
> + */
> +static int create_online_mblock(struct memory_block *mem, void *argument)

"online" is conusing. It's "initial" / "configured". Same applies to the other functions
that mention "online".

> +{
> +	struct memory_block_arg *arg;
> +	struct mblock *mblocks;
> +	struct kset *kset;
> +	unsigned int id;
> +
> +	id = mem->dev.id;
> +	arg = (struct memory_block_arg *)argument;
> +	mblocks = arg->mblocks;
> +	kset = arg->kset;
> +	return create_mblock(&mblocks[id], kset, id, true, false);
> +}
> +
> +static int __init create_initial_online_mblocks(struct mblock *mblocks, struct kset *kset)
> +{
> +	struct memory_block_arg arg;
> +
> +	arg.mblocks = mblocks;
> +	arg.kset = kset;
> +	return for_each_memory_block(&arg, create_online_mblock);
> +}
> +
> +static struct mblock * __init allocate_mblocks(void)
> +{
> +	u64 max_mblocks;

Nit: why an u64? The block ids are "unsigned int id;"

> +	u64 block_size;
> +
> +	block_size = memory_block_size_bytes();
> +	max_mblocks = roundup(sclp.rnmax * sclp.rzm, block_size) / block_size;
> +	return kcalloc(max_mblocks, sizeof(struct mblock), GFP_KERNEL);


I think you should structure the code a bit differently, not splitting
the function up into tiny helpers.

static int __init init_sclp_mem(void)
{
	const u64 block_size = memory_block_size_bytes();
	const u64 max_mblocks = roundup(sclp.rnmax * sclp.rzm, block_size) / block_size;
	struct sclp_mem_arg arg;
	struct kset *kset;
	int rc;
	
	/* We'll allocate memory for all blocks ahead of time. */
	sclp_mem = kcalloc(max_mblocks, sizeof(struct mblock), GFP_KERNEL);
	if (!sclp_mem)
		return -ENOMEM;

	kset = kset_create_and_add("memory", NULL, firmware_kobj);
	if (!kset)
		return -ENOMEM;

	/* Initial memory is in the "configured" state already. */
	arg.sclp_mem = sclp_mem;
	arg.kset = kset;
	rc = for_each_memory_block(&arg, create_configured_sclp_mem);
	if (rc)
		return rc;

	/* Standby memory is "deconfigured". */
	return create_standby_sclp_mem(sclp_mem, kset);
}

Should still be quite readable.

>   }
>   
>   static struct notifier_block sclp_mem_nb = {
> @@ -264,14 +430,17 @@ static void __init align_to_block_size(unsigned long *start,
>   	*size = size_align;
>   }
>   
> -static void __init add_memory_merged(u16 rn)
> +static int __init create_standby_mblocks_merged(struct mblock *mblocks,
> +						struct kset *kset, u16 rn)
>   {
>   	unsigned long start, size, addr, block_size;
>   	static u16 first_rn, num;
> +	unsigned int id;
> +	int rc = 0;
>   
>   	if (rn && first_rn && (first_rn + num == rn)) {
>   		num++;
> -		return;
> +		return rc;
>   	}
>   	if (!first_rn)
>   		goto skip_add;
> @@ -286,24 +455,31 @@ static void __init add_memory_merged(u16 rn)
>   	if (!size)
>   		goto skip_add;
>   	for (addr = start; addr < start + size; addr += block_size) {
> -		add_memory(0, addr, block_size,
> -			   cpu_has_edat1() ?
> -			   MHP_MEMMAP_ON_MEMORY | MHP_OFFLINE_INACCESSIBLE : MHP_NONE);
> +		id = addr / block_size;
> +		rc = create_mblock(&mblocks[id], kset, id, false, mhp_supports_memmap_on_memory());
> +		if (rc)
> +			break;
>   	}
>   skip_add:
>   	first_rn = rn;
>   	num = 1;
> +	return rc;
>   }
>   
> -static void __init sclp_add_standby_memory(void)
> +static int __init create_standby_mblocks(struct mblock *mblocks, struct kset *kset)
>   {
>   	struct memory_increment *incr;
> +	int rc = 0;
>   
>   	list_for_each_entry(incr, &sclp_mem_list, list) {
>   		if (incr->standby)
> -			add_memory_merged(incr->rn);
> +			rc = create_standby_mblocks_merged(mblocks, kset, incr->rn);
> +		if (rc)
> +			goto out;
>   	}
> -	add_memory_merged(0);
> +	rc = create_standby_mblocks_merged(mblocks, kset, 0);
> +out:
> +	return rc;
>   }
>   
>   static void __init insert_increment(u16 rn, int standby, int assigned)
> @@ -336,10 +512,12 @@ static void __init insert_increment(u16 rn, int standby, int assigned)
>   	list_add(&new_incr->list, prev);
>   }
>   
> -static int __init sclp_detect_standby_memory(void)
> +static int __init sclp_setup_memory(void)
>   {
>   	struct read_storage_sccb *sccb;
>   	int i, id, assigned, rc;
> +	struct mblock *mblocks;
> +	struct kset *kset;
>   
>   	/* No standby memory in kdump mode */
>   	if (oldmem_data.start)

Wouldn't we still want to create the ones for initial memory at least?

[...]

-- 
Cheers

David / dhildenb


