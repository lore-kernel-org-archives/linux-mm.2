Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85948CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46958E003F; Wed,  8 Oct 2025 11:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E3D8E0002; Wed,  8 Oct 2025 11:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D408E003F; Wed,  8 Oct 2025 11:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEB728E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:43:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5368A59D06
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:43:32 +0000 (UTC)
X-FDA: 83975366664.21.ED58A72
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id D621FC000F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:43:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G0jy+nMg;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759938209; a=rsa-sha256;
	cv=none;
	b=BCbe1FTzKSkGISQL43sp4SoJoOn2tXpbxBOrt2BV8c67/zm+qXsZKMxtp6T/myYP16VOC+
	GOWduSNMZW28Vvt656p69ANwY8jGwaglGiAnoZBTqwGNFgElrGYfoYEe/AfFcyYGvUkX6T
	UfKMC4nbgUpp2zpY19VKsM+qLE3aZms=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G0jy+nMg;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759938209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUhSb2gRG9q7wfoqgmoV/rOSyHa9AmwtjacpyBWGooo=;
	b=5HAMZxvSEGUfQp+nHYDZiYfiPC87vNykDlbZiHP/xTJ1RCMKY27VrW4Ly8Pe8Hdq6sHt/4
	x072BsIRbOJ5Ij1YVZBM6xYJ8seMlrtR2UtBqfVyvYI+xLUPZztlgZksAnnIVX23WFrfg8
	Q2cmGCQzDeaXZuH2CiGasTXe2n34kqA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759938209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YUhSb2gRG9q7wfoqgmoV/rOSyHa9AmwtjacpyBWGooo=;
	b=G0jy+nMgii99F7EGr5iZ/7JuNu0x3qu/y2h0XwlZtJphzo3mwSxZhAoqFpUnGdeBkIYHS1
	wLQe3a2DoEJqVd7/9mA2cKJam/1COn85A7LWwdp3jhk0t96/DFDRQI77wZQGADe594MAoN
	bFzO12lLqjhQOfrrwUc1xHVuPcGSzO8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-2Aluvz2iNJGDlpAO0n6FYg-1; Wed, 08 Oct 2025 11:43:28 -0400
X-MC-Unique: 2Aluvz2iNJGDlpAO0n6FYg-1
X-Mimecast-MFC-AGG-ID: 2Aluvz2iNJGDlpAO0n6FYg_1759938207
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee888281c3so68974f8f.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 08:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938207; x=1760543007;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YUhSb2gRG9q7wfoqgmoV/rOSyHa9AmwtjacpyBWGooo=;
        b=YOhrJbWNA7ZCBu3gTQ2ut5lyKFKUp082ezjFXF0U9W6C2aYhVOSz4s+pAeYbeqrviO
         dIZn/ISkZz4UGmA4IGy7IId5ipZ5CqJf6fG12WtH8Jmv91knLXI4et7IE5HZA//PY+HF
         kiuTPAL9msAWHN+1YOLa3yV/N49cTgm+4IbMKl0cuKOyCbz0W5kkhtuPrAQ6DnMFLzSk
         xbgZPgJ4R2pPgUKumvlvjGdScdeQYWlMhcf2GAcqVRXvJcrjl1Y5o23nlgjd/BPvxPnC
         lbDiwch5QNEXmJll+Ec4/+Cam3AqenULxBLWXkzLOE0PbV13WtE/F2sAZ0s5PT1EdmpZ
         vqsw==
X-Forwarded-Encrypted: i=1; AJvYcCWb6vJpnCQSX9+9uNLlie3PfxlCTAYLzcsL0U76jqBAv6FDTTyyX7uB346HCuHO8yl5lVme1/hUgw==@kvack.org
X-Gm-Message-State: AOJu0YyGNzKh/S4vRs3l+IImvlvD8IZ3EpW1AtAKWuiN3D7nMkAZONDd
	J4chRci/ffLqYO7syNHU5rgdvIdJcohT/sGBxohdF8puPetq36sFnSSSDjwx4YR/zUnBRVlF8NV
	k5OLpTQWvWVqigi1F2iC/mBnfSnIv+1v7j1IKejS6G2cwGMnK5Sqq
X-Gm-Gg: ASbGncu5/21OUHw5EZHgobcL6uI/xZVVGDgrmZRq4/CKZQeUZEyeXi56wlygK8FMXpB
	vgXasIbARxXM6I3sH2MFI9MXoqt+2FbZfgovXna4qTlzAQdGFGs7CRRPXepv6WRalV5h0Ext1wR
	shXG0htnLVgkMTtxVOaac08ZlaZxGm46vst6Zp9tPTw9sw02DUzEVvQDFeY0ETXtnqPHUx8g89G
	UZgB5gs/IAbiw4S1K/3fk9f4Wq3XZJRpgMqPRBvDopvKPDguNnd8FQ4VtD3RaCLXcELEfFIVZUl
	8RtccOGkRFCyyv3sOZ793i2aRtqdmIFZu43//ABThRMHLYWtdhvDBBgi+Dpu9CIvqR+5G4sdagy
	gDKDlHeQO
X-Received: by 2002:a5d:5f47:0:b0:3eb:c276:a361 with SMTP id ffacd0b85a97d-4266e8dd630mr2663636f8f.54.1759938206749;
        Wed, 08 Oct 2025 08:43:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEg/1BjAZFBrqRhTVifCxpXqhRM9mNYNtgY3LS18mLzhLVabrk7varIJms3tUeaWhS9aL+yvg==
X-Received: by 2002:a5d:5f47:0:b0:3eb:c276:a361 with SMTP id ffacd0b85a97d-4266e8dd630mr2663607f8f.54.1759938206331;
        Wed, 08 Oct 2025 08:43:26 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4bdcsm30484973f8f.54.2025.10.08.08.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 08:43:25 -0700 (PDT)
Message-ID: <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
Date: Wed, 8 Oct 2025 17:43:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
To: Michal Hocko <mhocko@suse.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, corbet@lwn.net,
 muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 hannes@cmpxchg.org, laoar.shao@gmail.com, brauner@kernel.org,
 mclapinski@google.com, joel.granados@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, David Rientjes <rientjes@google.com>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
 <aOaCAG6e5a7BDUxK@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOaCAG6e5a7BDUxK@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fPlh9BN4oIIZ1iiSiVMlZsL9uo5rYCalcuSapN5x5mo_1759938207
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8gocjx17zpp4j6zpgqkng7qfqm1ph4pq
X-Rspamd-Queue-Id: D621FC000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1759938209-688147
X-HE-Meta: U2FsdGVkX18VfFoSeQXHZ2joEuYvQRYHoAcHhyPYoKegUVtBKjxR36GbtfEmaXp1lW3lKJx14N0/f9g5NruimxWmtreNc13SIEqWuDUucr6Pvj+rqejjWIB1wXgR4nDhzMEaCI7tQA/SCtNArg/OyexNy0ZypWl4LiL68FpPN8S+CGTXPlB+bkLQb2pQVIPWdoxFgL26is45Qvl8TVCLCBnfJdUsa0icSmu+xI5jvLfHnOr5HDw/vaBWJwQPTy6cjNzFHonCjIYBU7dEckGS+p7nUbDIjQbb1nBB8V/1uKjP4HKVpGPfZFB7mdypxIq6m51RSVf2Vx3q5vteHNO8pGmECKJNGiPYOs2F6KIXxWfkxlMxunrU4uVuPoAPOf3yF/gBXFRIF9Ow4hT42rZlfdZjJZk7kTqLpafNoRIRFgf7QW/4WWxykMBSCTImUEZSdbl5pswZg9Y3TDZDCgsv3lQH2w6LN1EdtVEQuWYfW2OJjTviFTyBgmiwWdYn6NFGsVUzXLuvdPU/+v0CfQugkpntPKSlBSYjHTUrZtLOZZucwNXFT8NYdLjlIi2SXt2qeV2X/WDaayFgWzjUDneu9KtUrZu0TCeDqCuR0QnHHYCmLG+pX01NVCgShxReqlnUTL1C6oBHqrgJrK65oyHJB0BF/ffuwDLn555/MihDe0bTXNzE/OImvxds3Gz00SxD+KKigbZ5dQZS8OfeWlONR6XrQM/xTfItwzZc99XMRLW8gedx2repewyM/JTO3mVOdQOt0B6A2uP+OZ484HTxUVGiRmd12jM7zPRbj5JFYrCtmyMkuW4JikyU7/hGFEX4GtOvPsLtl7PwT92nAKeC9DdYkKYHKhVc7yNqWrcMjbyzpZ9FwIfESuponZkslnYo2FFp0Zi2Rw3V23vN5bKZk7copP21cpm98L5D1pvpFq419l2mzE45s6lHg8eHaVgXRa44qAeG5kp86Q+8aSl
 3shMbPf0
 qK8U1bcqyuF2drpGPv2+5mFhKEW0OUGM0CnG8qEhmoUjOIPiaKAm8Cb1sTv/cNQdgfLxHugLnmAbJJkvf/c7Phni8pxx35r98UQVOHdoLinxiqOD5X+G6qXStvQ5gI03DUM3uvnacXrtTHIOIko8bX7xbuyu5uKsPixt6gxgtW/sA5CkvfaVOSikqsAlDXAApxxfoo065FsKVuqh3M96D//LHuWiJ/fk73rhl1qcQz7S/X4Tc1ouxpSW44dQ4zO/LSc78JtzUuB17tpgdbHKqdloRsfWrhygnwldcAq8IYusWu88ler1//CPyXvY6KBH1Pp6Ouq8QJ0K1am2T9+Og9JQnj+ai6dwCGBKuDWnfw90QQtJTuVLad+1ZC3rzb2wJ74POd2JOu/j4rhcSU7apt6iMYx61DPebzgn6FG9vtm68Z6NP+aGQA2eiamMfOeJuPYI8lE4Gl2cTcPVHbUqGhqjoLqiXWwU6HLNHvDn7ZInLqfsQBX3Ch/qvHN0J/x6PikRKSHJom+BAH4jaUUziZ5/gxEAyC0n2bEWHKq/rfAtm1TAqKml7IGKmkgnjgQzzq3RexHNlAxB5VFqVzIa8ED4dqID3hFSQL98L7LC+0FvGXuhjKWx/+UHsgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 17:23, Michal Hocko wrote:
> On Wed 08-10-25 17:14:26, David Hildenbrand wrote:
>> On 08.10.25 16:59, Michal Hocko wrote:
>>> On Wed 08-10-25 10:58:23, David Hildenbrand wrote:
>>>> On 07.10.25 23:44, Gregory Price wrote:
>>> [...]
>>>>> @@ -926,7 +927,8 @@ static inline gfp_t htlb_alloc_mask(struct hstate *h)
>>>>>     {
>>>>>     	gfp_t gfp = __GFP_COMP | __GFP_NOWARN;
>>>>> -	gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
>>>>> +	gfp |= (hugepage_movable_supported(h) || hugepages_treat_as_movable) ?
>>>>> +	       GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
>>>>
>>>> I mean, this is as ugly as it gets.
>>>>
>>>> Can't we just let that old approach RIP where it belongs? :)
>>>>
>>>> If something unmovable, it does not belong on ZONE_MOVABLE, as simple as that.
>>>
>>> yes, I do agree. This is just muddying the semantic of the zone.
>>>
>>> Maybe what we really want is to have a configurable zone rather than a
>>> very specific consumer of it instead. What do I mean by that? We clearly
>>> have physically (DMA, DMA32) and usability (NORMAL, MOVABLE) constrained
>>> zones. So rather than having a MOVABLE zone we can have a single zone
>>> $FOO_NAME zone with configurable attributes - like allocation
>>> constrains (kernel, user, movable, etc). Now that we can overlap zones
>>> this should allow for quite a lot flexibility. Implementation wise this
>>> would require some tricks as we have 2 zone types for potentially 3
>>> different major usecases (kernel allocations, userspace reserved ranges
>>> without movability and movable allocations). I haven't thought this
>>> through completely and mostly throwing this as an idea (maybe won't
>>> work). Does that make sense?
>>
>> I suggested something called PREFER_MOVABLE in the past, that would prefer
>> movable allocations but nothing would stop unmovable allocations to end up
>> on it. But only as a last resort or when explicitly requested (e.g.,
>> gigantic pages).
>>
>> Maybe that's similar to what you have in mind?
> 
> Slightly different because what I was thinking about was more towards
> guarantee/predictability. Last resort is quite hard to plan around. It
> might be a peak memory pressure to eat up portion of a memory block and
> then fragmenting it to prevent other use planned for that memroy block.
> That is why I called it user allocations because those are supposed to
> be configured for userspace consumation and planned for that use. So you
> would get pretty much a guarantee that no kernel allocations will fall
> there.

What could end up on it that would not already end up on ZONE_MOVABLE? I 
guess long-term pinned pages, secretmem, guest_memfd, gigantic pages.

Anything else?

I'm not quite clear yet on the use case, though. If all the user 
allocations end up fragmenting the memory, there is also not a lot of 
benefit to be had from that zone long term.

-- 
Cheers

David / dhildenb


