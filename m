Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CBAC87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 09:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9076B0092; Mon, 28 Jul 2025 05:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663006B0093; Mon, 28 Jul 2025 05:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52AB06B0095; Mon, 28 Jul 2025 05:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6CD6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:10:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAD6C10DE60
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:10:53 +0000 (UTC)
X-FDA: 83713103586.25.6CBB4A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2FD2C40004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:10:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Apb+PQhA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753693851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnIU+p1vADjcsZojWJn5Yv3hV3lAOB3Vh76xjsPZ41I=;
	b=f2efR2m5DHoCiRgKFEZiyj4fyC8oIPMBY79Oq4MMSJOqH+vYn72SvJkfZroTiDu3Mz1s7H
	NVIg+PN0kQIZ3u3WLq+VGar5gW5bouialxUBrGZiP94DH6xYikPatfMtql0QapusWrTtHn
	vdbRtip+Kp2xtUpGLWp8zHMpyKzyo/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753693851; a=rsa-sha256;
	cv=none;
	b=Nd5RDnLX38ubOEYPygVn1Vexa+Hw3eDSSluTHFo6YITP9KdFc49OzSDF4FNTcy+TXGljsA
	jJ7ml0p+m+vxvbahaR4K494LRmVax7ujdWzjm+5SkhXoV2SKgDInJvI576btlSdKzELnLn
	NcWaLXVM7m84z8HRsNhsEVNkaUbibp0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Apb+PQhA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753693850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VnIU+p1vADjcsZojWJn5Yv3hV3lAOB3Vh76xjsPZ41I=;
	b=Apb+PQhA6eDKfLSz7MWi255QLM2bdGLUT/ZEhCD/9M1vrJqPUjYweNDvs8POnErw7ravK1
	3oBtqoEOEotE3TRZ8Twc41t6MBa3OIVS9N5S63bOz+8QM5aBHI32W5QNxwDnGr4ZlBhns2
	tPrBYJAFgovmsfSdpEkjxJi/fhVxFEo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-P67cYykaPVaBis0BnqVTxg-1; Mon, 28 Jul 2025 05:10:48 -0400
X-MC-Unique: P67cYykaPVaBis0BnqVTxg-1
X-Mimecast-MFC-AGG-ID: P67cYykaPVaBis0BnqVTxg_1753693847
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b78c983014so7163f8f.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 02:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753693847; x=1754298647;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VnIU+p1vADjcsZojWJn5Yv3hV3lAOB3Vh76xjsPZ41I=;
        b=mV3ILOaQdPalFv8l1QGn7C8MoWHSd1YkZ5eT/otCPWm1RLRwHxHlH2gDto4fxeeTzm
         PELuuQ/TAVirB7Msy5bknJwv1RrD7iIe+Tbpyn3jZ6dlFV86X3K8ZQgZCZp6IYQ/+JzJ
         ZVnC4lmGQU94oc18ZJN5mFxiRs4yzy+72j4VgZ08gZBsKyrcmXgNFpCB2Ec8GfYbSvEW
         qPJjL4Tv9cm6SlFPb7jupqqv2ppDbXtjZ02ZRFBLwXQXSgkD6wn70QG6PsGpczpTPvcd
         sYRQsdIIWrTZ8KJoD5SI3o7qOLG4S88yy5v2MQr7qgG/yzvO7ysUHq2aaofXX6DPuZ/0
         zuPg==
X-Forwarded-Encrypted: i=1; AJvYcCVOob9xOZlxOU8qzep7gpwDc9xFOdDuqz1tbX2PtqG3wEXA+Au7jchJtVYB2a6x8k3ATagaRdXyLg==@kvack.org
X-Gm-Message-State: AOJu0YyuOwnIevOmrDJ3smTzeQIX8sqd/+Hx45RVInNgPk68V4gzFGqe
	UlqQKjEza+xfwk/x9KLxL/v2dXjuz7jXU0xYsKMFVPeXgc+Esce2WSl5xiM4yyT2GjQP4lv/jiI
	1N6yoscCK/KAiUBKjLmOxUgs8UTG51TBpafQMAqwBvd79P0iWTUyw
X-Gm-Gg: ASbGncvGRsO45yxsipVmzCA15+DRd5gvmf1e0sYhkng+iVrMGk6mQA4DLevV98rkyCY
	H2e1IL4RT7ZUdArJnau/94GF4trZMBQ4qxijcDg7u1BP4cyQNFH0pZBtBgQ4r3jtumHTPG3fXNZ
	Y4ljbgYuBIRaHi4xVogSUZrvG9n7lbwj+oxivLbjh9l1YZE/8xYqLZhl0E4u2rzwAbvWEZuoUun
	nkQ8wY3p8Sd7zaHxUrxgygkW9EP1fRPzp+8kp3poNw4G4Xm4/BU+r9loZ9T1oVhCKtqEGHtzEfK
	pfndbgbCNllCudxfNqTddAtBRRx0BEpxm3l8CN3N6gVDIJG+gdnc1KDGe4UdgdEXONzCMsb1Emf
	wDvTo+9y/4YEBSHPmnFhgVObgqx5ek6qybVxLRa4KiECGiTrlmIDYiIuFl1cC48cXSEY=
X-Received: by 2002:a05:6000:3107:b0:3b6:13a0:bb20 with SMTP id ffacd0b85a97d-3b77675daf5mr8553823f8f.35.1753693846873;
        Mon, 28 Jul 2025 02:10:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEazl7CS1NCDJ3qvW/s97bvrfSXmYjKBUMzcWrCBBaAi+pylS/P8t5QGt4045/NplxWthVSUQ==
X-Received: by 2002:a05:6000:3107:b0:3b6:13a0:bb20 with SMTP id ffacd0b85a97d-3b77675daf5mr8553791f8f.35.1753693846252;
        Mon, 28 Jul 2025 02:10:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b783ca028dsm4899301f8f.51.2025.07.28.02.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 02:10:45 -0700 (PDT)
Message-ID: <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
Date: Mon, 28 Jul 2025 11:10:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aIc9DQ1PwsbiOQwc@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pvu7hEvC1V8ftAPmfrR4xgyz3fS2yMvuWtFbFMN2j1o_1753693847
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2FD2C40004
X-Stat-Signature: r8rpdedthfuoi9weo4gzoe338d3e8bs4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753693851-625366
X-HE-Meta: U2FsdGVkX18sYMo1S8PuKfAxhjvZcuMZ0hCqP2SNWymX3IvC5nMujhxuQq/xB0HIwt715b+b/L1e/A2x8LKZkKC1HMY7+9k3MaPhjYoU7Eqyey/EDM1gw4LTNFWa+DbVBGS1c5EbJGDrAGcgREFf4yjK34JLL4QzQSMBKF44xhJ2phH92Tx3wCdvKu8aAPUTXxwbWT8Ge4DdQTci6dfuS3ZVClgG8/YQpzOx/Nv3A4S7Bf76X2H7MqJoiuhfxFaSHO1z46wywq/DfJZKr/tzNcA8RAcebkUreOih9ZQrGfvgGc1KG5Z7LTX0h4HDTTlum44WWtUk2ypgF1ymNTZuLDgiAZxb/jU0ZD2ei9O4yPChEKjn47SxC0AcYNGAPUs2sbKtnUZTNpglNrRoPBUa1kaSMghy0ayNNt0Q3QVmhjCb5TGUA8SYHohv5WclyrZmd/Yj0JPB332ebU5PggO6NLd94zZnDKEG8+PuiFRlt5EqFPjgtse8ZcJfr97rR52wLryFJJGoIoduwz4KPtxyAiNW0Rb3sgyg4DjCxXUEtMuv8oisGh0OqnPG6kBtYTjcaeogtKsTkI1pSmF9SAlnAox0G81A0ybVDCXlB4MJ2NKoT34a+d3IbwdAWofYtJTOs6tGlev4TlgDxbcTUFhcWCCbQgOWnYEPAhyrDJG74nCFwAoy2EGKc1HueheJiiiSDmV3q2wOQqCttzLEmGczgOwUM/avSS597YOS76bulPYFA/bt5jlbERjG4MMmkxrR1MLUHvYkCv6oocRARLYCxQVhqjJPPdyA9cOs620o/NGWVQlLlwkNUDK6Dr/7WYrO6B3GUfoWUwa6CDaQ09b5jXVJM+eUcFAGjDkwvxXFzOGr+Kj1Ch5X0b39Li7by1Z116MHs7tYa1bI7WlwblLNvD4L9XTy2RYbsPcoK9mk/1eLdUt1TpFjNiNqizEIVc41NFL0p/8MDnKNVjZCWQA
 +enP9qjA
 nu9UklYhSkD1e60trhxEBHKn9QS6coj1yhHpk1T6ATrvryWBX8w5p3UtllAU/so/jh+pAJrSC6RfcfFuXkT6I8c4d2iJFDipoM0p99en6Q0H+IxTsZ2nY/ywTRu4l5wSIm9OWzk1iFq8qKq+TV2PhW3JndnC3VqVIYv4ZftMfaCuPnHqP2PDqgjuilxGwbJf07YNmaOziBcrWb97U8rV09pA1PEIg+ST9ATswPpyaml0vASiGx/G7mi8saWkrBDCNMoYM41JQvWStdwEKeC0lB8NXiuPZxFFQrwsNeR4zl1BTvmQ+w4T5LSVR+VHUPyjO51/1H+ZCNkUshP8VAuKNcsF1snF0GfjfAH7FfvnC0N/f3GNSUErmpKjq90HYPth14Cco1gmJpIivuMI3z5BriRWX3a9K1bcCs+NKb0reSMgZlZBhgwZWYRL1dFs0xfJk41/YeTalX0AAbrQeMfhXl98zAvC2/aoVcGZZr/LRHKh7c1Y2bQ07pcxOqtYM5O4eaG6Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 11:04, Michal Hocko wrote:
> On Mon 28-07-25 10:53:08, David Hildenbrand wrote:
>> On 28.07.25 10:48, Michal Hocko wrote:
>>> On Mon 28-07-25 10:15:47, Oscar Salvador wrote:
>>>> Hi,
>>>>
>>>> Currently, we have several mechanisms to pick a zone for the new memory we are
>>>> onlining.
>>>> Eventually, we will land on zone_for_pfn_range() which will pick the zone.
>>>>
>>>> Two of these mechanisms are 'movable_node' and 'auto-movable' policy.
>>>> The former will put every single hotpluggled memory in ZONE_MOVABLE
>>>> (unless we can keep zones contiguous by not doing so), while the latter
>>>> will put it in ZONA_MOVABLE IFF we are within the established ratio
>>>> MOVABLE:KERNEL.
>>>>
>>>> It seems, the later doesn't play well with CXL memory where CXL cards hold really
>>>> large amounts of memory, making the ratio fail, and since CXL cards must be removed
>>>> as a unit, it can't be done if any memory block fell within
>>>> !ZONE_MOVABLE zone.
>>>
>>> I suspect this is just an example of how our existing memory hotplug
>>> interface based on memory blocks is just suoptimal and it doesn't fit
>>> new usecases. We should start thinking about how a new v2 api should
>>> look like. I am not sure how that should look like but I believe we
>>> should be able to express a "device" as whole rather than having a very
>>> loosely bound generic memblocks. Anyway this is likely for a longer
>>> discussion and a long term plan rather than addressing this particular
>>> issue.
>>
>> We have that concept with memory groups in the kernel already.
> 
> I must have missed that. I will have a look, thanks! Do we have any
> documentation for that? Memory group is an overloaded term in the
> kernel.

It's an internal concept so far, the grouping is not exposed to user space.

We have kerneldoc for e.g., "struct memory_group". E.g., from there

"A memory group logically groups memory blocks; each memory block 
belongs to at most one memory group. A memory group corresponds to a 
memory device, such as a DIMM or a NUMA node, which spans multiple 
memory blocks and might even span multiple non-contiguous physical 
memory ranges."

> 
>> In dax/kmem we register a static memory group. It will be considered one
>> union.
> 
> But we still do export those memory blocks and let udev or whoever act
> on those right? If that is the case then ....

Yes.

> 
> [...]
> 
>> daxctl wants to online memory itself. We want to keep that memory offline
>> from a kernel perspective and let daxctl handle it in this case.
>>
>> We have that problem in RHEL where we currently require user space to
>> disable udev rules so daxctl "can win".
> 
> ... this is the result. Those shouldn't really race. If udev is suppose
> to see the device then only in its entirity so regular memory block
> based onlining rules shouldn't even see that memory. Or am I completely
> missing the picture?

We can't break user space, which relies on individual memory blocks.

So udev or $whatever will right now see individual memory blocks. We 
could export the group id to user space if that is of any help, but at 
least for daxctl purposes, it will be sufficient to identify "oh, this 
was added by dax/kmem" (which we can obtain from /proc/iomem) and say 
"okay, I'll let user-space deal with it."

Having the whole thing exposed as a unit is not really solving any 
problems unless I am missing something important.

-- 
Cheers,

David / dhildenb


