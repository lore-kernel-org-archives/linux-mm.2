Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB10ACCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 16:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164838E000C; Tue,  7 Oct 2025 12:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1164F8E0003; Tue,  7 Oct 2025 12:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82BD8E000C; Tue,  7 Oct 2025 12:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D988E8E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:11:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4FAC139D23
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:11:23 +0000 (UTC)
X-FDA: 83971808046.30.7A61FB5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 59EC280010
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:11:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BC7WI6mo;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759853481; a=rsa-sha256;
	cv=none;
	b=EmOb5oDBo+YAJR5RDFcjwRRuKqLoY/DCzC9layAGWO/2MdNExH9g1KwBOPt5yq3SQkpEv4
	0p79pcE++gQ0VMRQ1w7TnvC9RunJ3MOyS/KCGC+978WzqsaYK8sMQgECDZGwG8Ao8G5qA5
	Vu6y7VCLPxaM6o2G/8910jHAXym8IPY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BC7WI6mo;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759853481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1TG7fNWBYED87Irl/Zr2hY86eg+AQbf2b3fSmJLhsM=;
	b=cygEvuzpR8JJPxIYDYghhnhRyJPLQLaaDdxlylcfStDxKh2NUkHBcECT7cBQOk4MwbWlNy
	69qZj9BW8o5ZS/J6qCc7gFtY0Y3CoO9Qi8HfbSpdVTCDnhAuqohl6QUEh4zIsIqOAIKv71
	+b7DHKPli6bTg1MY1izvceo/Rnr1WwE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759853480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l1TG7fNWBYED87Irl/Zr2hY86eg+AQbf2b3fSmJLhsM=;
	b=BC7WI6mou2OSCHBztVg8FRr0/omkEnNPvN80u+8lm3Y0hHPKvWq/ukfC3YmoZBnh/utUyQ
	Z0SmvjfCxFGUEpbkVZ8n6xmo+AEWm5tBQZL5DzO3raeqAb2LASAPslM8nYEGCu94LRdhrT
	cbpAjaz1GhuXP1V6RV2Nk5pF2kH4IqQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-4OC3ITIHOJyjSM_OOcL3oQ-1; Tue, 07 Oct 2025 12:11:19 -0400
X-MC-Unique: 4OC3ITIHOJyjSM_OOcL3oQ-1
X-Mimecast-MFC-AGG-ID: 4OC3ITIHOJyjSM_OOcL3oQ_1759853478
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ecdfe971abso4627806f8f.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 09:11:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759853478; x=1760458278;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1TG7fNWBYED87Irl/Zr2hY86eg+AQbf2b3fSmJLhsM=;
        b=CdRepLSolvbvyG/4p2uVb8d+gM8MlQzIjOyH40sfGv8N+0Osc1oCJBDZ6u8WY4uA5x
         WhkspyORFWB8OAVLIW8lPUAzahsTRR8NSHOWIss5cLg3Cp2E5N0ZTsrUrMYOLEfShRkb
         56NeLR1cNHopBzz5tRBtx3DNkXVe99N6gEYSBP3W7tQSD+QxcfjlYfuwJR0MvesVsE0Z
         abQWQeVuV2EGQRBdJD3k46HsxC5wUXe0c2UiXt+igDcg8v4vFLGj+xl9ThAJV3dLF6mv
         s0dNeNL1BsolOsVr08ua0IkiPn9xzU7nlPBk9/6hSYSde8kvaDnChA3hMiwb9Q3gB4/j
         fK6w==
X-Forwarded-Encrypted: i=1; AJvYcCWrK0DWNP7HDQyipeEEgJhGi+wXosky9px7QhPFqGvGUzlP3v23RcDCdJfPRIuu6BsrC9f1g7zyuA==@kvack.org
X-Gm-Message-State: AOJu0Yzogv9elJ8/Zo1ZMn5gICbW9n/+ulrf65heOox158gx1jZdL3Va
	85TOCeU6VgNcl/QWDwlUWVgSF/FzoQOf8D1Fsxgyd7EMWfme6fZFf1VY64DCc/Koj9GWE/U3k5o
	f0OaXoBLjfrYTGmtebE1eL23S+ekFYJX76ce/vwyXcYNQnC1ro5vh
X-Gm-Gg: ASbGncu9hTbGm9qnzqUnVG/tmGG7wiht1tRFNdryVGUt11BIcGYqYR98XcsPqSMtFma
	O6lAIHkaAStN9SPMsYs75WeEmPjNASrGslmpz0iIlrvY/GIDHDEIre4h0GSqtxs4xxmmZ72sfgZ
	mUbL1SHono+FFF3kfJ/z9QJqwr6bOrvhEWnjYQGwuc6CPi0Dw3uY0Q3rtiVKI2xrywJax2sa/B1
	WJiAP2ZzZiyWvv1loDN3upDsCRlN7QNxsjUCq/Va7JRmJjZYpAXgXiRtQ7pijNDjcl2K5Mx2Ghj
	Au5+UVEKPBMFVoiEgr9y8pqNZHDfu1yVHBa4Gx3ssHaN2d9EUur0J70nb1a0MF0NHjPTeG+mE7Y
	1ynAmWMzX
X-Received: by 2002:a05:600c:468e:b0:46e:4b79:551 with SMTP id 5b1f17b1804b1-46fa9b092femr1336645e9.31.1759853478066;
        Tue, 07 Oct 2025 09:11:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7kxIG94axeHuIA4cL4kYLnzrOyY3qxXsr5H8R4EofA01FREwYYzGLEMnYegBwXYAIBqinkA==
X-Received: by 2002:a05:600c:468e:b0:46e:4b79:551 with SMTP id 5b1f17b1804b1-46fa9b092femr1336305e9.31.1759853477513;
        Tue, 07 Oct 2025 09:11:17 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8acc4csm25683339f8f.16.2025.10.07.09.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 09:11:17 -0700 (PDT)
Message-ID: <ab366c03-8c78-449d-bfc4-2d155212d9d7@redhat.com>
Date: Tue, 7 Oct 2025 18:11:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Support dynamic (de)configuration of memory
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 linux-s390 <linux-s390@vger.kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6qh-SLnlRwcXSV4-qae934rev6O6ukHWRAKfwZnwEYE_1759853478
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: z343hzkttsungazam4xijt55dqd4qaaq
X-Rspamd-Queue-Id: 59EC280010
X-Rspamd-Server: rspam09
X-HE-Tag: 1759853481-989412
X-HE-Meta: U2FsdGVkX1+b4mEj/7B+vUj8RCE/+44MAtBdCl8olfe7iYWG5mbmltEV8SLaYBHu2gRnwd9SWK73uM/FMWtCoyJo7Myo9QhYbVcoKM+9gpXviZ0qPg6Xy8TcWOHZNpznIMXtOgmiBUhjWqIwR0Lzk115+ugA6zstBUBaTa2wFkWKz4PgKS7dEozFSOknXZggbBvB0CPfq0y1vv/tTECqh5DHV3QCR+U0j9fFok4Uy98G7Qh+/41/JUGaZPqjZ5oZ8ZtzEm+Cbi9KWurmBSBOCaTMBPRR0yhIv3r8pHSID3mIa+4r7Fy7M0KlLpRqzSRBXGkYLrzcEXs4y69HXJEouUP1BjxJCtEMi53AUJXWFmvvV3BYSwUWPZt3O1/d2I8tdiKSh8vy0pMtdfBXGfKGmCgzGqw0w50NodM3lSrRaATejcBR8Kr/FH1T8JJ5+vp8/RTnwe0GbW6zjathiu25Qz3DfmfFHcz/+SIqjZtYSaeeVRVB8RGjYwkzbC3LYPtuAJ2skWbsxawlrYicxtVRzjxEC4F0okorZSAZ16lRWLnAMVKNTMseN9ReG08lszmEPLkEEQ+e9edQ1mYxjtRNkxJWSQd+IPvWsHfg6YqfIEgKkZVYFeiaKDyXllWeFoUtEOlqggaMNyWf0JfKZoj6gy/WeSZoFzcqihtgABmdqKThnpu3ofGxlCHquOpfVYeh2lap8A7A4UrXggRw623euZBZVjx0h+0YwUotkyuFheh5msgbPzN5kM4/PTOBUzU3Y6y8aUqCxtlIYI3XukB01BLx5mdOSAqnsN6/SE8ZKTyB7aTRSJztttZdYV2tvXXVJ+fUls89HN39ts10W56PKTTuSETqioo92GxDKdXKZ3TQo2+cGyjznEtnLiC3W6mYi9YIUJmWK0GIIL2v9h+sfD46GVNQfReSaD7YUR/fTFpsPsPFT3xD85UQPPx57DI4IeR7xjoDmcVxul4T0UB
 bbCkCXFF
 dKA3i39cSflmmxyWhGDs01lDLFaoT+t7NT0MLOqf0Bgeh+eN5v3r65yt9Q0QiO6xVnvCkGvcTZhzaRVYZLML/3O9ndoGN91ur6cOtGwePuhc3CuAfbqNJrJjEQN6AlCSpOa7IBqeIFxzFqRqy0yq376ew9uhwON4aAksOtpbcv/O13Hl1gm9EH4LsjW9ZDKQkLRCVcqbXT3Y/RUq4G0WM+sP7s3ksl42Y5V73zy6Rf7QKOGncxHjtluO3GVWNjo9RCf1xfTZiCQCajYmYVx/s16f2Y4ZIONN02r+auEvmspyu6d57k8vlSVoVaPsyGzKTnrkd/g7MshyeDdhfJSIMgbjrCyZZs1IaOuVGJ0TdHpVY6UCwpSWQ5lDDdAGFQhGhIjcQgG78MB0n6LwQvUPFi7uFAK/9ezQtlQ7SUpBf3ruECK7egQTlroZ8fuEi8IwUm+yaDaKs8kjlfFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.09.25 15:15, Sumanth Korikkar wrote:
> Hi,

Hi,

> 
> Patchset provides a new interface for dynamic configuration and
> deconfiguration of hotplug memory on s390, allowing with/without
> memmap_on_memory support. It is a follow up on the discussion with David
> when introducing memmap_on_memory support for s390 and support dynamic
> (de)configuration of memory:
> https://lore.kernel.org/all/ee492da8-74b4-4a97-8b24-73e07257f01d@redhat.com/
> https://lore.kernel.org/all/20241202082732.3959803-1-sumanthk@linux.ibm.com/
> 
> The original motivation for introducing memmap_on_memory on s390 was to
> avoid using online memory to store struct pages metadata, particularly
> for standby memory blocks. This became critical in cases where there was
> an imbalance between standby and online memory, potentially leading to
> boot failures due to insufficient memory for metadata allocation.
> 
> To address this, memmap_on_memory was utilized on s390. However, in its
> current form, it adds struct pages metadata at the start of each memory
> block at the time of addition (only standby memory), and this
> configuration is static. It cannot be changed at runtime  (When the user
> needs continuous physical memory).
> 
> Inorder to provide more flexibility to the user and overcome the above
> limitation, add an option to dynamically configure and deconfigure
> hotpluggable memory block with/without memmap_on_memory.

This will cleanly add/remove the memory, including the directmap and 
other tracking data, so I like it.

> 
> With the new interface, s390 will not add all possible hotplug memory in
> advance, like before, to make it visible in sysfs for online/offline
> actions. Instead, before memory block can be set online, it has to be
> configured via a new interface in /sys/firmware/memory/memoryX/config,
> which makes s390 similar to others.  i.e. Adding of hotpluggable memory is
> controlled by the user instead of adding it at boottime.

Before I dig into the details, will onlining/offling still trigger 
hypervisor action, or does that now really happen when memory is 
added/removed?

That would be really nice, because it would remove the whole need for 
"standby" memory, and having to treat hotplugged memory differently 
under LPAR/z/VM than anywhere else (-> keep it offline).

> 
> s390 kernel sysfs interface to configure/deconfigure memory with
> memmap_on_memory (with upcoming lsmem changes):
>      
> * Initial memory layout:
> lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
> RANGE                 SIZE   STATE BLOCK CONFIGURED MEMMAP_ON_MEMORY
> 0x00000000-0x7fffffff   2G  online 0-15  yes        no
> 0x80000000-0xffffffff   2G offline 16-31 no         yes

Could we instead modify "STATE" to reflect that it is "not added" / "not 
configured" / "disabled" etc?

Like

lsmem -o RANGE,SIZE,STATE,BLOCK,MEMMAP_ON_MEMORY
RANGE                 SIZE    STATE BLOCK
0x00000000-0x7fffffff   2G   online 0-15
0x80000000-0xffffffff   2G disabled 16-31

Or is that an attempt to maintain backwards compatibility?

> 
> * Configure memory
> echo 1 > /sys/firmware/memory/memory16/config

The granularity here is also memory_block_size_bytes(), correct?

> lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
> RANGE                  SIZE  STATE   BLOCK CONFIGURED MEMMAP_ON_MEMORY
> 0x00000000-0x7fffffff    2G  online  0-15  yes        no
> 0x80000000-0x87ffffff  128M offline    16  yes        yes
> 0x88000000-0xffffffff  1.9G offline 17-31  no         yes
> 
> * Deconfigure memory
> echo 0 > /sys/firmware/memory/memory16/config
> lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
> RANGE                 SIZE   STATE BLOCK CONFIGURED MEMMAP_ON_MEMORY
> 0x00000000-0x7fffffff   2G  online 0-15  yes        no
> 0x80000000-0xffffffff   2G offline 16-31 no         yes
> 
> * Enable memmap_on_memory and online it.
> (Deconfigure first)
> echo 0 > /sys/devices/system/memory/memory5/online
> echo 0 > /sys/firmware/memory/memory5/config
> 
> lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
> RANGE                  SIZE  STATE  BLOCK CONFIGURED MEMMAP_ON_MEMORY
> 0x00000000-0x27ffffff  640M  online 0-4   yes        no
> 0x28000000-0x2fffffff  128M offline 5     no         no
> 0x30000000-0x7fffffff  1.3G  online 6-15  yes        no
> 0x80000000-0xffffffff    2G offline 16-31 no         yes
> 
> (Enable memmap_on_memory and online it)
> echo 1 > /sys/firmware/memory/memory5/memmap_on_memory
> echo 1 > /sys/firmware/memory/memory5/config
> echo 1 > /sys/devices/system/memory/memory5/online

I guess the use for memmap_on_memory would now be limited to making 
hotplug more likely to succeed in OOM scenarios.

> 
> lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
> RANGE                  SIZE  STATE   BLOCK CONFIGURED MEMMAP_ON_MEMORY
> 0x00000000-0x27ffffff  640M  online  0-4   yes        no
> 0x28000000-0x2fffffff  128M  online  5     yes        yes
> 0x30000000-0x7fffffff  1.3G  online  6-15  yes        no
> 0x80000000-0xffffffff    2G  offline 16-31 no         yes
> 
> * Disable memmap_on_memory and online it.
> (Deconfigure first)
> echo 0 > /sys/devices/system/memory/memory5/online
> echo 0 > /sys/firmware/memory/memory5/config
> 
> lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
> RANGE                  SIZE  STATE  BLOCK CONFIGURED MEMMAP_ON_MEMORY
> 0x00000000-0x27ffffff  640M  online 0-4   yes        no
> 0x28000000-0x2fffffff  128M offline 5     no         yes
> 0x30000000-0x7fffffff  1.3G  online 6-15  yes        no
> 0x80000000-0xffffffff    2G offline 16-31 no         yes
> 
> (Disable memmap_on_memory and online it)
> echo 0 > /sys/firmware/memory/memory5/memmap_on_memory
> echo 1 > /sys/firmware/memory/memory5/config
> echo 1 > /sys/devices/system/memory/memory5/online
> 
> lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
> RANGE                  SIZE  STATE   BLOCK CONFIGURED MEMMAP_ON_MEMORY
> 0x00000000-0x7fffffff  2G    online  0-15  yes        no
> 0x80000000-0xffffffff  2G    offline 16-31 no         yes
> 
> * Userspace changes:
> lsmem/chmem tool is also changed to use the new interface. I will send
> it to util-linux soon.
> 
> Patch 1 adds support for removal of boot-allocated memory blocks.
> 
> Patch 2 provides option to dynamically configure and deconfigure memory
> with/without memmap_on_memory.
> 
> Patch 3 removes MHP_OFFLINE_INACCESSIBLE from s390. The mhp flag was
> used to mark memory as not accessible until memory hotplug online phase
> begins.  However, with patch 2, it is no longer essential. Memory can be
> brought to accessible state before adding memory, as the memory is added
> during runttime now instead of boottime.

Nice.

> 
> Patch 4 removes the MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers. It
> is no longer needed.  Memory can be brought to accessible state before
> adding memory now, with runtime (de)configuration of memory.

Nice.


-- 
Cheers

David / dhildenb


