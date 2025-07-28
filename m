Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FD5C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 15:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228F76B0089; Mon, 28 Jul 2025 11:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201176B0092; Mon, 28 Jul 2025 11:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0086B0093; Mon, 28 Jul 2025 11:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0026E6B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:15:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A3F358766
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:15:10 +0000 (UTC)
X-FDA: 83714021580.24.47C35FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id CCBC1C0019
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:15:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i12jXtjY;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753715708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFu6x9LoVQ1xdj0Ds1jK1/RRFvn+MmOixRu+6RDQgAk=;
	b=c3Qv+QBEAjbPiiI5plbpO0exKE2nC//NvBPa6i3yN28nVlnOI1LFPPqp5gNXS9c2Gsb+xK
	nMztZS63z/XltMkEvoCV1R2HXnbpNv3xjdMhNtGwXPOCi5gVEBXW3EgtL/z5PSkc4tBWK1
	yGDo7It4B2y5QoduKCk9RLnE2aPiyiU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753715708; a=rsa-sha256;
	cv=none;
	b=tvAiTyGTSvA7T1/4XvkewPesGW1QMKphz0b2Hk+ziI31mlVG4oPk6PpFYpfN9mKiuV+MFn
	R+EhbCgC/zeRx3Bfex+2AcO+ilpJxQeeINpu7vB3/wzFFKHsJN+8DRQHq+K/EhZzKflLIA
	+bzIeLphi8wuGiY1aId9fuQQoRYLaRk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i12jXtjY;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753715707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cFu6x9LoVQ1xdj0Ds1jK1/RRFvn+MmOixRu+6RDQgAk=;
	b=i12jXtjYUt0/u7lEJ1sb1Ts8WtkSX56CwudRjRjUJdRwaQLG+KAm1BNfC0BtL7/41j91AQ
	pzn+ss8U8zxj65xNpttRm5ZxL7Vb8+JwgYzfdNuqrB6P2R39NM+zenslpZurX/3zFs0OUx
	m/3gueGrNcGZqLu2K5N0ccTup5PdPPI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-GNqb9ppzNZmk3bW5u0RZrw-1; Mon, 28 Jul 2025 11:15:05 -0400
X-MC-Unique: GNqb9ppzNZmk3bW5u0RZrw-1
X-Mimecast-MFC-AGG-ID: GNqb9ppzNZmk3bW5u0RZrw_1753715704
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-456175dba68so27165605e9.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753715704; x=1754320504;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cFu6x9LoVQ1xdj0Ds1jK1/RRFvn+MmOixRu+6RDQgAk=;
        b=AUvT8cl2I1ufcMgOQR64mBPzwp8xUqoHb2D160HXaNAkXnbVsT2fwfl9ljruEX1FHH
         nwbLeTlbtFo33gUxFqNIigM16NbdyriETdD5r2wWJrTs3XzrIQPBf0mmhLEo+TT92/L7
         /ZLeAZAUMg0i+ogz2YjGfNdQR0feRYzFquJFF0J2krGy2vPPbJTs4iIIIAp+Ygx2V3PB
         ArBiWi0DMtNetfhEPI1lpnIe+T1PrkDK1NIeMbpJx2W3x+JFnoRySCh2oJVECyFcaXtd
         XTOO9PVt7YGOZn/+tLJVLCOOsHvhHu8nL6PYiXKm1BzEF9JyQ1xzlzwZtg6etz4ggEy1
         faIw==
X-Forwarded-Encrypted: i=1; AJvYcCV5bJx/UPMUA62PrPp/A5qqGuhfwI4ms465wrn9aTg+XdXv29y42TFAPpoIFMDdtDkhB157zqrVdg==@kvack.org
X-Gm-Message-State: AOJu0YwUpkTQtI/q6SOcBJLQW9r8XZjJ2ZAp/7mtaRngLqX58rTGx/ym
	dfTDBQk0TW3TZ0dLKIcvDO3izxOEXsiEFX6pyF+7cASuJ4mcNXFtfeWODDQn7UU0sR83omVLoom
	h0N/+bu/gf5DBh880hgNIl6A8z1X3+DWsCbQWEqdCUZiZujMNEMQ8
X-Gm-Gg: ASbGncvm27rAAWBd0dLEMHrDONXO5B3xsv5CHZP58ex9lraKjs7XcZxmHseRHuNkJWP
	FAagm2ujhHMx2Qo1lcNgBSPLlDIE71XrixDcvXpmX9902AlQhoWbkfJGUOznVAnrhncQOBKX3iU
	o8LWHqhw2b1I5noiuZkgZzc31MT0SAnrTOXK4w4X49vm2IqgKIx7AvyCW+1LmQfYVgWZKvZblcJ
	3pBcP9qsMV8dCctUh3t/SwThqClL9SH5fdMKbFqZ4ziAElCdCiszNfK5G9IzIAOGnmb//a9455T
	SEZI/qATyCk2ybWZ2Ck0bF/Kgxy+Lr/s7fvpxiNehSZB9rc2x+HQT45gOBLaFMgR7sJTM5PQouT
	snxug6YpbqBNpNDoGSc+aH4KQWPsXQKcZw0++ptnVYCRnBBJG8f03XMYvQ/xGVlpzO1M=
X-Received: by 2002:a05:600c:1c94:b0:456:1442:86e with SMTP id 5b1f17b1804b1-4587911e78amr76809145e9.21.1753715704281;
        Mon, 28 Jul 2025 08:15:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYgLa7yl+fyDCD5pCKzn8BbvKweRCfmV2xlQtPD8ua6fwJTJSoqSSEdQnuHq68gLQ0j11fEQ==
X-Received: by 2002:a05:600c:1c94:b0:456:1442:86e with SMTP id 5b1f17b1804b1-4587911e78amr76808825e9.21.1753715703645;
        Mon, 28 Jul 2025 08:15:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705377f0sm159681105e9.6.2025.07.28.08.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 08:15:03 -0700 (PDT)
Message-ID: <09794c70-06a2-44dc-8e54-bc6e6a7d6c74@redhat.com>
Date: Mon, 28 Jul 2025 17:15:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Hannes Reinecke <hare@suse.de>, Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <f859e5c3-7c96-4d97-a447-75070813450c@suse.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <f859e5c3-7c96-4d97-a447-75070813450c@suse.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AjNqnB3ZFTmZLJt7Ph3ckkGI8_IWsAt7OEjaShn3Zak_1753715704
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CCBC1C0019
X-Stat-Signature: digy3xxjxrwepwruq3j6dtyb88kucju6
X-Rspam-User: 
X-HE-Tag: 1753715707-979538
X-HE-Meta: U2FsdGVkX19tid8IZRmTiRFJbd2AA6Hgdo2/2lVdRnun25IwgnfpsHYvsv+Hp4GxzFPIy8jSqiHc5JioYQmC0YrZXR1splcXssAdCjyLkMMvo20Pzw/DlqnaP7FNPSlS0+750In0/cfnbc4nzk9Kg8D2wKF21kJWjQAH6rgtAiabCbjyZahkXrUCmihwO1UGaDNoXIoVaAPox2C5zLbBIwdr4Ncfi4gF2h/+XUFjLKEf9nRtiYpOl30oCqVL5qjcddlQffOqjjQ5DqaJlJff7bkj0Gl29E2S2MqGcU0gRPst2arC4071K+96ZUqpkhqqJtkg3Q2NfIyBQfDazLO8S9KkCoOnlWswcMT/vL581Kcto46bPqKwSyNeNSALuB8fv9wh3kVq1uZzbvlTDoivwjbB4Yo9gxSJavAH9d8AmKXqRbxOIqfMTPuet00zt2p/7WyZlv5SgyfrAMvcqlBy7P76CuPN6L10RW41lpkdlwrkuWqN1FoM3eaagBp6dfZ5y1JmILsh3hslHqjR6/JDeHjDL10327UIHwtjYFMNG43gIehy3TXA/TIjgXUo4Sv0WGzmhTMpuNfUa8TiDt8qmS9SN4BtZQPfPfmbodi3/tzZED+rBoS/uJSsDx1a3ObNSV2NLrxIaIG83kk5BXhZrBJLBHIasrbXqFcNNEFn76Vn+wX5ehhvRKM2LLsrgOVlKTl+yJLWW7rhITUs9N5kbi6CyoCOEqkRCJTFCHMuYF3yeYDf7bLoZrK50j2d8XiyEypJ1VGFJOYKqd6YmX0rOQO5SvfBgP7t3hmThzA6/YFGB10k94DnpM6sjC0in0MXC3M1Dnaz+6qPXsSKszyVZBRzd/zVUqQEF7RYCoV1c5RxE1JnHtX9EM1JrTJFxOnu/Ex7BSZJ76Ky+L3BkuS+jtxJAn7B9ouEgF/UdhAAscEYwd6BC7nTevaT5w1DEnQ9TGBdonFlLOW2MG8JDAe
 TFIdrAgx
 dx3snu+qKJhYR6dMI5/H/if9RPSPHujoTJKkdUqq5wi/iP6lhULntzRs2ockR9xzlmdGpx/ZYe9Vs6Scvy0UE6w3kSPAohwlH17Ykwn7y5Y6ftVKosuLDtnhJsjKrxBJNmsiZEoeSqvoXL7m9u1ETPo+9iktgaq92Lc81P3ca7pQz9Sl0wsEv1AVjOKgfZq++kI4D2lhq0TS0lIDIW1Qs/K1huhRqMTl1uZXwLhBt8tSkKFJ1ZCezs08GF0bU+rOge8zmH7nz0rzO8agLWfnl6800/64HCBqbvwyATHdvXyPX6niYo/bB3eaBV5cJ0DhODOWGXAV87ST+1JWqjDphki9HVeq5xGBdrYG8baBnhr5sdTEBz71eTAC0/vkl3Kj/gq1T5XC+SddSSzzaMJ9mtmWZYFOZJMRT//895AtByeIoagUHkaTkA+tzvF9qJAxKClyLCHGrkpzWA0JoDMDtEEHgr1DmPdZygmPCMtY+EW3NL550c7aS5xjPjyzBo+RJeLkA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 11:37, Hannes Reinecke wrote:
> On 7/28/25 11:10, David Hildenbrand wrote:
>> On 28.07.25 11:04, Michal Hocko wrote:
>>> On Mon 28-07-25 10:53:08, David Hildenbrand wrote:
>>>> On 28.07.25 10:48, Michal Hocko wrote:
>>>>> On Mon 28-07-25 10:15:47, Oscar Salvador wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Currently, we have several mechanisms to pick a zone for the new
>>>>>> memory we are
>>>>>> onlining.
>>>>>> Eventually, we will land on zone_for_pfn_range() which will pick
>>>>>> the zone.
>>>>>>
>>>>>> Two of these mechanisms are 'movable_node' and 'auto-movable' policy.
>>>>>> The former will put every single hotpluggled memory in ZONE_MOVABLE
>>>>>> (unless we can keep zones contiguous by not doing so), while the
>>>>>> latter
>>>>>> will put it in ZONA_MOVABLE IFF we are within the established ratio
>>>>>> MOVABLE:KERNEL.
>>>>>>
>>>>>> It seems, the later doesn't play well with CXL memory where CXL
>>>>>> cards hold really
>>>>>> large amounts of memory, making the ratio fail, and since CXL cards
>>>>>> must be removed
>>>>>> as a unit, it can't be done if any memory block fell within
>>>>>> !ZONE_MOVABLE zone.
>>>>>
>>>>> I suspect this is just an example of how our existing memory hotplug
>>>>> interface based on memory blocks is just suoptimal and it doesn't fit
>>>>> new usecases. We should start thinking about how a new v2 api should
>>>>> look like. I am not sure how that should look like but I believe we
>>>>> should be able to express a "device" as whole rather than having a very
>>>>> loosely bound generic memblocks. Anyway this is likely for a longer
>>>>> discussion and a long term plan rather than addressing this particular
>>>>> issue.
>>>>
>>>> We have that concept with memory groups in the kernel already.
>>>
>>> I must have missed that. I will have a look, thanks! Do we have any
>>> documentation for that? Memory group is an overloaded term in the
>>> kernel.
>>
>> It's an internal concept so far, the grouping is not exposed to user space.
>>
>> We have kerneldoc for e.g., "struct memory_group". E.g., from there
>>
>> "A memory group logically groups memory blocks; each memory block
>> belongs to at most one memory group. A memory group corresponds to a
>> memory device, such as a DIMM or a NUMA node, which spans multiple
>> memory blocks and might even span multiple non-contiguous physical
>> memory ranges."
>>
>>>
>>>> In dax/kmem we register a static memory group. It will be considered one
>>>> union.
>>>
>>> But we still do export those memory blocks and let udev or whoever act
>>> on those right? If that is the case then ....
>>
>> Yes.
>>
>>>
>>> [...]
>>>
>>>> daxctl wants to online memory itself. We want to keep that memory
>>>> offline
>>>> from a kernel perspective and let daxctl handle it in this case.
>>>>
>>>> We have that problem in RHEL where we currently require user space to
>>>> disable udev rules so daxctl "can win".
>>>
>>> ... this is the result. Those shouldn't really race. If udev is suppose
>>> to see the device then only in its entirity so regular memory block
>>> based onlining rules shouldn't even see that memory. Or am I completely
>>> missing the picture?
>>
>> We can't break user space, which relies on individual memory blocks.
>>
>> So udev or $whatever will right now see individual memory blocks. We
>> could export the group id to user space if that is of any help, but at
>> least for daxctl purposes, it will be sufficient to identify "oh, this
>> was added by dax/kmem" (which we can obtain from /proc/iomem) and say
>> "okay, I'll let user-space deal with it."
>>
>> Having the whole thing exposed as a unit is not really solving any
>> problems unless I am missing something important.
>>
> Basically it boils down to:
> Who should be responsible for onlining the memory?
> 
> As it stands we have two methods:
> - user-space as per sysfs attributes
> - kernel policy
> 
> And to make matters worse, we have two competing user-space programs:
> - udev
> - daxctl
> neither of which is (or can be made) aware of each other.
> This leads to races and/or inconsistencies.
> 
> As we've seen the current kernel policy (cf the 'ratio' discussion)
> doesn't really fit how users expect CXL to work, so one is tempted to
> not having the kernel to do the onlining. But then the user is caught
> in the udev vs daxctl race, requiring awkward cludges on either side.
 > > Can't we make daxctl aware of udev? IE updating daxctl call out to
> udev and just wait for udev to complete its thing?
> At worst we're running into a timeout if some udev rules are garbage,
> but daxctl will be able to see the final state and we would avoid
> the need for modifying and/or moving udev rules.
> (Which, incidentally, is required on SLES, too :-)

I will try moving away from udev for memory onlining completely in RHEL 
-- let's see if I will succeed ;) .

We really want to make use of auto-onlining in the kernel where 
possible, and do it manually in user space only in a handful of cases 
(e.g., CXL, standby memory on s390x). Configuring auto-onlining is the 
nasty bit that still needs to be done manually by the admin, and that's 
really the nasty bit.


> 
> Discussion point for LPC?

Yes, probably.

-- 
Cheers,

David / dhildenb


