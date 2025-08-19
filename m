Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F19CCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 04:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16F56B00DC; Tue, 19 Aug 2025 00:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEECD6B00F5; Tue, 19 Aug 2025 00:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04C76B00F7; Tue, 19 Aug 2025 00:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D96E6B00DC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:33:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 413A057920
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:33:10 +0000 (UTC)
X-FDA: 83792237340.17.3A446A6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id E41B820004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:33:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Otr9Nv3N;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755577988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qG/E26p+ZfYqeJl4XChPlBI0YsV/ZEQedBJc5ags4o4=;
	b=0NyA/s5VXjvecCbO2bRzi35rwt1mq5S8T5OwBm4JqSC2vH3CWj3jvGD+KVrtLpg3CL/dWU
	MqGj3m3O1AS0/0SOtI09pF3GSEaykCo5r1UfAdr2poMEiJ0jyaVraOzqjL4bs0BYTFJsg5
	yalk0fTmvZLoCazLrePLcLv3P8zOGqo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Otr9Nv3N;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755577988; a=rsa-sha256;
	cv=none;
	b=Ck4AkZzhs4C6NqC5/hTJesW500JsNr47X/Z79LnpXZuiHCaX8AmiFS6vt7/tKEBuoOeRzt
	/JiZbBQPQfAqCT+SKytNb13sXgedfslQIqXbCNPsdW5GvyCJy0m8pDGZn/exSGpI2zqnda
	XN2bJBzufuDNrJE1TvMSve8nA7VfK0E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755577987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qG/E26p+ZfYqeJl4XChPlBI0YsV/ZEQedBJc5ags4o4=;
	b=Otr9Nv3NSCASBA/1iiKiMQodH/4c7KdPzzvUQeZoZ+IYsktnq6cJKWnVwXcTiCRPU7JcJj
	FVChue0eE1whzsaVQXgL42lBMcPLYQKiJNiFaDkjVmjmpOl772YPVLpIZF+HzssKoGVl5F
	2gzkw5BIiQFlU4WhByZZoRpezyqB8uM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-5ziAYgFUMl6EDhlQOx4Phg-1; Tue, 19 Aug 2025 00:33:05 -0400
X-MC-Unique: 5ziAYgFUMl6EDhlQOx4Phg-1
X-Mimecast-MFC-AGG-ID: 5ziAYgFUMl6EDhlQOx4Phg_1755577984
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-333f903c00dso18310191fa.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:33:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755577984; x=1756182784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qG/E26p+ZfYqeJl4XChPlBI0YsV/ZEQedBJc5ags4o4=;
        b=nMU2U6JuUOGcWHF3J4Q0Jd+zsFlVFOu9vXm7ZZYLCYOehwA5NNxJMZUH5lvLkV+J7J
         OMIHHV5212tjkknWtkmIjJaGittvjLIF93MpX6BzW66MmwzeiTmJsD/QQvJIZFAaPnKi
         m4xxmwZlnPNv8rjtb8bTMeNp+sbvYHk9feix0JGOK5iiOBST6Qct15gpq/iAor6GFmEB
         dUwSZ8UzUaruaTavZNlGOhmeZWZGkQEBH+5SqtRIlpw8nsg76MUQfldakwbSlgCnJeJ1
         i0ZCRniD2QFnxnnywAI3q6NVCiXBmPAUnBM+ayq+fWOJY+yr6XVKbN1tbmck+3ScEh4t
         +U/w==
X-Forwarded-Encrypted: i=1; AJvYcCUZVpRmzRqsn8U1opJTnbZfc48zkUTgcx0bLyQGJ/4cJf6kIwCiXHXtCTo8VNlaY/CbKk5j7Fqk2g==@kvack.org
X-Gm-Message-State: AOJu0YwZmNlGbJ+DbRYJ7kpOglxeHbhUL/rDWiCn8KTK3hays8HgOagr
	dRv+71a7z1ZAWX/xeDdz3shO5WNXNJCEuhTb2JfxLivfsQLGtipmfIO882UrclREiaoxnToLQxm
	0LuQgOYCGhK5vQsDFJkUD4CV5X0qpwIOB6aTlXuZcnDL0Ocp6raI=
X-Gm-Gg: ASbGncsCd83S6m8ztbFwJz5Edgvht3eme/+OvVR/DPbNTVog3uqDk59vud53esHVJUH
	YZWIInxUvy4kh5n6rYABla2FUQ1ClZ5DodFur5fSsRY631WgrDBhAWDtAMcgsHZsl/B9zv/RRWq
	0ELwzGBTEgcH41+mQyEu9nYk3xHE1WlMCC8iJ0j8OKwAErJ3p6diy869kpxy1Ve7J6U64BeIW+l
	p38yBi7Ue4ZbRRZvHhyt+MQVtLdfdKYDhrynq4T/Bbh6LEUaojhvYAAaP01+2DETiUEEs/5HU9E
	BBVdyQ3k/SiahXjczppO3eeraO4SzucPu43Puv1k/px3Ck9LhInh/lxO8tpqUMuO3A==
X-Received: by 2002:a05:6512:6318:b0:55c:c971:224a with SMTP id 2adb3069b0e04-55e00846b5emr289943e87.42.1755577984104;
        Mon, 18 Aug 2025 21:33:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKVeAFak+03265wWqjfT393ZS1nH5/RODtNQm950oP5LIYFdFv+RPj0sv4qkxSrGh+nFgPwQ==
X-Received: by 2002:a05:6512:6318:b0:55c:c971:224a with SMTP id 2adb3069b0e04-55e00846b5emr289927e87.42.1755577983574;
        Mon, 18 Aug 2025 21:33:03 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cef3515f9sm1972164e87.30.2025.08.18.21.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 21:33:02 -0700 (PDT)
Message-ID: <614bb7b7-85c4-4e49-95e7-8faed5372cf6@redhat.com>
Date: Tue, 19 Aug 2025 07:33:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
To: Balbir Singh <balbirs@nvidia.com>, Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Leon Romanovsky <leonro@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-3-mpenttil@redhat.com>
 <20250814124041.GD699432@nvidia.com>
 <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
 <20250814130403.GF699432@nvidia.com>
 <67b6e041-4bea-485d-a881-cc674d719685@redhat.com>
 <20250814141136.GG802098@nvidia.com>
 <c7bbbbc8-b9fc-40f5-b86f-e43b9a85aaef@redhat.com>
 <20250814172018.GJ802098@nvidia.com>
 <2982b6f1-7c14-46ef-afb0-7951f7cdc2aa@redhat.com>
 <pk4yq5kt5csh5yqd7f2s66eux6yvluxv3rcwrskaagyxcgo34j@6wei37bgqlye>
 <1e854923-c746-45ce-9f56-1c01a41992b3@redhat.com>
 <e054f622-69ad-4724-b12d-c2545d913170@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <e054f622-69ad-4724-b12d-c2545d913170@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SgVeoPkZ5fTaKxYKzy5Y2fry9IBAiu9Lae8wupKY3ps_1755577984
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbmq1jjmprunu7j8m91r6hm3hkreuw6f
X-Rspam-User: 
X-Rspamd-Queue-Id: E41B820004
X-Rspamd-Server: rspam01
X-HE-Tag: 1755577987-448638
X-HE-Meta: U2FsdGVkX18XNmHNyE5c11KYcoylAfKh3iFCM6vRXoCI1YH+GrXWEyRxp5o+X/OgHM1GwqIIS/4wSZtNVW/psPB8uY1t5UeKoPry45w8oSuh9GYM7gnNrjWm9Xcjd2NPtto3jwuOzPMb6THRaQARvxQDYwI1Eo2A9nokd6SMf6pXcPmxWEzF43Apnzaed399Xa5p/I4HJYEqAw9Fm8b8Dp/1FOx4auw1AQX2S805ngO6BGYaEd1YQGX0fCDYh1HMawGGpxN7J77DOKu8Xrn1wn9wH2y+exktkJIqBiwoGM8Qu/tG2RKFdWIq1IVg2/Wj6YGPuh+eI1n04GV0/IrhXjvfTUpBYN5TWVnDrLCyd+6RV8Rt+M9gPj0BJ8HkenB9hD4iWBKj4NMxAe22uU/bR7E+EADQO3fNN2vzIcTVI9mKMFNbR2N8FUkQ4Us+1JiDQNJWmOnTBTmazu90t5jGZbRD9bx6119J3xXN48vmOUO+YG0sooFCNCrNOJ7Bt8yfdIcx1nWCL3a2nZwFjDNeAMLRTVbmzaLds4v0ENbls1CNvLV/+Tzd4X1wokvFX37gRWYGGPD/fx0FXXnrWsK+MaxJ88yv0UOiF7kMUB/OSLYqIviQ1tQbeZhMKX73AvbID+d8Npt3JdbmP6o3dBp5wNvueN+t57v39ltv0VBN+pEM7xQI6XYrEdbHLxmkgkIBYTl28xS8cJKubunXT2yqSQs+YigLzPdyHB20g0dikgnWZabqo0DQj+mdnjkOoabQt0WvHNLiF+I/hhUlT42Wwf1V0HnI9wn8etXDItimJA6FxHmay7DcflpuW3aGdTGFRgTXguMhDBED+Q9QMi2LbLW1vZeLLn+HWWgftd2lva4+YOEKDkmGGfmgX844pJI0JqthVHboZwm29xHju7IcvqnMdFa0kMgLD04O6zr7wPht08uZhMopTf8QkjDoTywy7QbFEjhxYucYZIxvVqf
 xv4Ge6zw
 e5326RQCIRA1J2P2sGUIfy0PrJxXquOBHVmz5rePd2PqDONV7PuaKOAI2Hp+mTV8DeDQ1bvsbyXwxqFeh5fwvv1QtYhMtMmoPRCNdhngEsNKJ/PD+fHmxzA9/plbuSe5rant83OmuCOdSi/g3q6Y5snkROq9V3q+N99oZLwVs2R81PRLZJIBTAa88w6EzcRgepqBZLVBgPkpqjdJnMKk6u+gylxeBpr567QgDcJvo2zgL7NpCBXYtMuW0eNUkYf5UIzM3VbrWLx4MvprpUJOiB6Pv4qtCwGF3I/Y/4fKgml7HfsGdKDOQ7s+kfP8Z0zXEYE1xyBh0FMVG5L+nTzb5R1S0YnTbnsERTjsZHXfIMl1Ecv7z4MEzcRJQlNt9iBWOhNwKLCk6cJZh3/HTYTjioyVGlBNChVbXu5rNsLs0DlSPqnr7HQ3RtVO9bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/19/25 07:27, Balbir Singh wrote:

> On 8/15/25 17:11, Mika Penttilä wrote:
>> On 8/15/25 08:23, Alistair Popple wrote:
>>
>>> On Thu, Aug 14, 2025 at 08:45:43PM +0300, Mika Penttilä wrote:
>>>> On 8/14/25 20:20, Jason Gunthorpe wrote:
>>>>
>>>>> On Thu, Aug 14, 2025 at 08:00:01PM +0300, Mika Penttilä wrote:
>>>>>> as well as hmm test module with :
>>>>>>
>>>>>>          * Ignore invalidation callbacks for device private pages since
>>>>>>          * the invalidation is handled as part of the migration process.
>>>>>>          */
>>>>>>         if (range->event == MMU_NOTIFY_MIGRATE &&
>>>>>>             range->owner == dmirror->mdevice)
>>>>>>                 return true;
>>>>> If I recall this was about a very specific case where migration does a
>>>>> number of invalidations and some of the earlier ones are known to be
>>>>> redundant in this specific case. Redundant means it can be ignored
>>>>> without causing an inconsistency.
>>>>>
>>>>> Alistair would know, but I assumed this works OK because the above
>>>>> invalidation doesn't actually go on to free any pages but keeps them
>>>>> around until a later invalidation?
>> Thanks Alistair for your deep insights! 
>>
>>> Right, the pages don't actually get freed because a reference is taken on them
>>> during migrate_vma_setup(). However other device MMU's still need invalidating
>>> because the driver will go on to copy the page after this step. It's just
>>> assumed that the driver is able to be consistent with itself (ie. it will unmap/
>>> invalidate it's own MMU prior to initiating the copy).
>> And reference is taken as well in migrate on fault during hmm_range_fault
>> if migrating.
>>
>>> In practice I suspect what Mika is running into is that the page table
>>> synchronisation for migration works slightly differently for migrate_vma_*().
>>>
>>> Instead of using mmu_interval_notifier's which have a sequence number drivers
>>> typically use normal mmu_notifier's and take a device specific lock to block
>>> page table downgrades (eg. RW -> RO). This ensures it's safe to update the
>>> device page tables with the PFNs/permissions collected in migrate_vma_setup()
>>> (or the new PFN) by blocking other threads from updating the page table.
>>>
>>> The ususal problem with this approach is that when migrate_vma_setup() calls
>>> the mmu_notifier it deadlocks on the device specific lock in the notifier
>>> callback because it already holds the lock, which it can't drop before calling
>>> migrate_vma_setup().
>>>
>>> I think one of the main benefits of a series which consolidates these two
>>> page-table mirroring techniques into common code would also be to make the
>>> mirroring/invalidation logic the same for migration as hmm_range_fault(). Ie. to
>>> move to mmu_interval notifers with sequence numbers for migration, perhaps with
>>> filtering if required/safe and retries
>> Yes with the migrate_vma_setup() and collecting removed, the firing of mmu notifiers
>> and "collecting" are integral part of the hmm_range_fault() flow, so logical to use
>> interval notifiers for migrate also.
>>
>> I have removed the commit with the owner games. I studied it more and seems it was added
>> to mitigate a bug in an early version, which led me to do wrong conclusion of the root cause
>> of the hang. That version had unbalanced mmu_notifier_invalidate_range_start()
>> after returning from hmm_range_fault() with EBUSY (after done a folio split).
>> With that fixed, driving the migrate on fault using the interval notifiers seems to work well, 
>> filtering MMU_NOTIFY_MIGRATE for device for retries.
>>
> So this patch can be ignored in the series?

Yes this can be ignored. I will do more testing and repost after a while with this removed and
possibly with other changes if needed.

>
> Balbir
>
--Mika


