Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B99FACCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C628E0019; Wed, 22 Oct 2025 04:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3E48E0002; Wed, 22 Oct 2025 04:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3238E0019; Wed, 22 Oct 2025 04:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA23C8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:42:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B86B213B9CF
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:42:25 +0000 (UTC)
X-FDA: 84025108650.09.2BD6449
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 31F1B40008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:42:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d33kXwSF;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761122543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+Qc4y5CsxpArpC14yIHodoUnQoI1Il2pOClkv+r5DE=;
	b=x4KiXIlp6APhdlknGm0eJpRv7GjlDVwKMlArlF5eaUpQdY9ZinOHZktBdo9wE+9sU9EtK7
	FnrDs5fC/OrtnnBWGE8sZiqlgj35DIlrkSYBQJnI/TDOnEK3jzyU9bovQsjd/CnFgDYkRn
	apFNCG7LVVwNAa5Zld+k6yaydYsF9Ks=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d33kXwSF;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761122543; a=rsa-sha256;
	cv=none;
	b=u9eCCsiaeDDJbbW6byVAnnxFYzHBaxlaIu7i0S7Fo7YMRPkqLVs9Zj9lZ9pQLnWa5uxeJu
	wS37iS1D0ryLJuvQyy8UMINCsD3h/LJyL3LBW6Ief16jk7K5cvZszpDxfaEfe2LCWT9Aim
	uSWzCsZXBtnGz+zVc5Vk57W3qe8Aopc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761122542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X+Qc4y5CsxpArpC14yIHodoUnQoI1Il2pOClkv+r5DE=;
	b=d33kXwSFgOCh1PI/Om3CZe+jUrY/uvGwvOm/5CgZwNH30xbAmjCkfCec9HQ2tJqarCtOf+
	UME1hx15jk+EGArz1QGag5Qa54j4+QB6BH0L1fBo8dMRXRIrmOVRbaFDfYachzjBgfrhR9
	fKIqur8LItAckrJigBTWzXy7scUTf3w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-7aR1G_msNcWq4m771io0Bw-1; Wed, 22 Oct 2025 04:42:21 -0400
X-MC-Unique: 7aR1G_msNcWq4m771io0Bw-1
X-Mimecast-MFC-AGG-ID: 7aR1G_msNcWq4m771io0Bw_1761122540
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-426ede1d66fso3317824f8f.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761122540; x=1761727340;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X+Qc4y5CsxpArpC14yIHodoUnQoI1Il2pOClkv+r5DE=;
        b=VZohNsqMnrwiNRBe+nwZUViOoBZGB3eVC9hHY12Ocj0H8J/2at7Vu/F1kGWxBkS8v4
         fKzroN+/AVU1ThllP0XYoO4j1JuxN3NqGlHTGdRS6TssvH/kRx//3PV7AIummFubkJmj
         nW0f0Ga0HxPlTRV+au99CzznExRQrL2diM4pwHiWMJYxRVo4k++/BPrIeqKmzM2L1Xe+
         mW49Q+O8CqaJzPIB7/VpIKWpOEFsnK11FwY55xf8GuPCldYz1oYLzUXNelXaF6ey7nCb
         M1TKhsSsmabTFJ164U4KU1Sc+gr2di6SGICH7SsVxZaxvQlGsOGEqiA1C+qmTTyN6Q4N
         igwA==
X-Forwarded-Encrypted: i=1; AJvYcCULhpl8sgSyiEnKWnCDlNfCuRRrB6gAeKfsrf+dGUvKL3ngTafw4WTcQwRgl/Ur+TGgvQHS1AX2Ig==@kvack.org
X-Gm-Message-State: AOJu0YwiDVa8XlGbiolhG7lA/XcQF8L37ZTu5sne1/G299ubogWyo4Mp
	GufPoUhTxwyDI2mWnkMUABFXvCv25Mp92ApNtiEQ4ttR2gUcJapyqeBQYL5Kg3vqd26g8HgimDt
	xAmdDoZyXqUOm0FMGiizbTmj6+vAKvz53Jvx2m/blD1d/oJTprbYW
X-Gm-Gg: ASbGnct1WozRHLLGccGRRATQtA/uEe6upwomnO+qhd1DFmqjIau+K9emdx1SemxZbkb
	oBk9D/j3kZ3lb7iZAVuTqeWKMDNid+b8Rla09xRTzT1EkQ1d1bq9hmnsUPQpwOjladG0/I9Xk2C
	mtBApZ85OvBvmUsZBDLCsj47RohVlXjuMZM0mfwFq3EqB6ZzfIf7JYpFlK+zl6ovAIN6XbwSdtR
	kFfcSsq6kwNJ7n3K3gIWQFVPW5OdTpfNxa6X5126JvUBBXdh/Bhl3jqvQdWfR9npOSNWXyYYPNN
	zd4wS86Dxm7Ocgqrb5JR2eD8pyBzVvWUA5d4zX4XgW+Rj9IAZpFyhPy4XXs3fsY60HKD7nToUl/
	eZgiZdVrdg5DNwD+KwjxulG25flowZaIaDsfSuaC/l0JZamCWboemgNICNwae5GHG7jnYjF8UHT
	gUN1YiUN17RokiokQ7v4K7UlFEJP0=
X-Received: by 2002:a05:6000:4287:b0:425:7c32:d969 with SMTP id ffacd0b85a97d-42704d145admr13984360f8f.5.1761122540032;
        Wed, 22 Oct 2025 01:42:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMg9OoxIiF4uh2VUtESc9U54hkw2hijV7jLg75IGaXBj5fTyoFRtMVmXdqz1BIz6FYs6UDtw==
X-Received: by 2002:a05:6000:4287:b0:425:7c32:d969 with SMTP id ffacd0b85a97d-42704d145admr13984317f8f.5.1761122539618;
        Wed, 22 Oct 2025 01:42:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0f19sm24212592f8f.9.2025.10.22.01.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 01:42:19 -0700 (PDT)
Message-ID: <ce26f59c-8938-4896-aaf9-ed94723466eb@redhat.com>
Date: Wed, 22 Oct 2025 10:42:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/23] mm/balloon_compaction: use a device-independent
 balloon (list) lock
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-8-david@redhat.com>
 <20251021165040-mutt-send-email-mst@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021165040-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1HUNI18kPnZPO4ZzLOkdftqzYnTn5gN3yNKo_Cxi9Sc_1761122540
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 31F1B40008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pc33teunj1kyztiyogw3zzzdj9hx6ao3
X-HE-Tag: 1761122543-49562
X-HE-Meta: U2FsdGVkX18z+2Wc/+a4MCjak3T+tbBj9RVu75RiJv0rCAHZ/B8I4RFz19M3JilTf1hn/XRG5qE9Tv4HyU+WvYthuNX0Njl3veOAzubBtCAKF3jRl/Ftd9Q8sYWUsNluG7jk4F2XgBk/ntekeG4pFqkAiZzAd6i+PTYpG2JH3BabYNJRbcOgIeAA1dKbSvT00NsjUkrPDHLGoip+TJNR5PeYYcoR1dARe4qZZUd+Muo3gGrFQJNdWy+kZZr0K8uXKmLGU6HHP0qBcMVcbf6q0G5KhN7L0g8fbbaQiQUaQ56WrNfGku4Gyy0ypjljuTa+yfs+2EvZ7SklrijxAtltE8a1Iv7VNLWxdA8GtjV30poDOqxXpjG489GGJqqtAwVLcKXYRmRxDs04dLERG7PydHkOcgoKHz+ty7dCUUD2QQTWo5wtqSe+E8I3VnX8fiiMnyzTOd1yvIXyFchoi1p4fbnSRSzma4f2vhViWxzH1MuYuyiycc/YDE7RzfY0S0MwAWkpiYx14F39Y+OfcGrWqZKy4B0mZf15XhalulEAUGvSbxN/MVM1xBlfWLlCCJXvG08Y5cosOyDUGESJFAXKzT2WchZKS9vqF6PHpVQ+qvZa0Iu8a6xZnNngXv2A9vbYHDmacIlUz7lJ2CyrxRndUyN3hxuvbUzN8adUGm/SpyIuW4trKh7sNnpQHayj2vJ5apzdIRB+S8hKl67CM295fLPERHfVzyd2ePkFUWjj1EZGliKUmkh0VEyf4nEJVCSMEPGeoiJbzRrNZ7w/JhW5a7VyCtTez7KKus4ktoNPGBXhEdR82HbEVY2W5KPmK05W0PP0QQX4iWsNlCLt8v+SrizRKTOm8qVapaG0n3XC9QGLZ+wpl3zi1jqU2V6JzMfYyJETjWuv9dMGpq4pFsatgUmVMrf60iVZ9bt1Qv4uTQv86JGkEdJTncL2ZGoPlazS7ZdRaspGAI4mZeiazEn
 ZHFs9wbI
 teUXxOEwwpCa7eZ725jQOjcT6EQZMW+Nyg2z1i2A8XaxNAODgN10t/CGrperPt6h81S0B00+5Ye1tT8zszO95N/sl3Q57pvIR+uFXVKXtsHNgIj1h4yDtZk9F/x7nfKboAQZrTUlFLa4G0Pg3DLAzRopqK6sBvHfbYRSlPUDJH3aetfTtKsJcHoUYxtA8oADrRjcGQ0d/ebPVBr4pFDpiK2gHgUCpdB0pfYt0Dgzq/iU7vzijTE5lkovsR8ANw47FgXGMqLWt9LiptIUlhyTL5lVMMeJ1TeE53KZ/DTDvY736Mzkhhm4qDHXgG3YSA7eZfglqlcnERnhBe9jXB5EcrZNBK/Wtqv4AkWOciZMGAYi00JwxAsE1A66cmY1wwrG9MTzLybveaguEG3gT4FPclutRp/s56Sj7bqtL70XcoR+FCR/i61nACQ6lK7HylqU6JwtZlOn1ZjzJV00C6Z655d2y8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 22:52, Michael S. Tsirkin wrote:
> On Tue, Oct 21, 2025 at 02:59:12PM +0200, David Hildenbrand wrote:
>> In order to remove the dependency on the page lock for balloon
>> pages, we need a lock that is independent of the page.
>>
>> It's crucial that we can handle the scenario where balloon deflation
>> (clearing page->private) can race with page isolation (using
>> page->private to obtain the balloon_dev_info where the lock currently
>> resides).
>>
>> The current lock in balloon_dev_info is therefore not suitable.
>>
>> Fortunately, we never really have more than a single balloon device
>> per VM, so we can just keep it simple and use a static lock to protect
>> all balloon devices.
>>
>> Based on this change we will remove the dependency on the page lock
>> next.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   include/linux/balloon_compaction.h |  6 ++---
>>   mm/balloon_compaction.c            | 36 +++++++++++++++++-------------
>>   2 files changed, 23 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
>> index 3109d3c43d306..e2d9eb40e1fbb 100644
>> --- a/include/linux/balloon_compaction.h
>> +++ b/include/linux/balloon_compaction.h
>> @@ -21,10 +21,10 @@
>>    *   i. Setting the PG_movable_ops flag and page->private with the following
>>    *	lock order
>>    *	    +-page_lock(page);
>> - *	      +--spin_lock_irq(&b_dev_info->pages_lock);
>> + *	      +--spin_lock_irq(&balloon_pages_lock);
>>    *
>>    *  ii. isolation or dequeueing procedure must remove the page from balloon
>> - *      device page list under b_dev_info->pages_lock.
>> + *      device page list under &balloon_pages_lock
> 
> Using &balloon_pages_lock with an & is kinda weird here.

Indeed, fixed, thanks!

-- 
Cheers

David / dhildenb


