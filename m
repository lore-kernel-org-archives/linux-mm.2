Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91B3BCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F019C280018; Wed, 17 Sep 2025 15:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0DC280002; Wed, 17 Sep 2025 15:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7998280018; Wed, 17 Sep 2025 15:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF11A280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:05:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70B071404EE
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:05:54 +0000 (UTC)
X-FDA: 83899671828.20.5A1B994
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id F2297120007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:05:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G1RiB5ql;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758135952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iYdTqhfdz9F3OSmNWg0L2Bcl9ZF1XfZz244Dszls6io=;
	b=1wGcsdwOiCRiux77tegS6w9r3XdRCeQvTkj+1d7gOpB8mX7drkn2E6nH9F1GfyxA6IiO/9
	7Jyade6n76o0LfCRnEGZQleJfQn36zbT1L3KziBfaCS7T4NNtNASe4Rij53fhncTEBl6Fg
	Qx7kasvVk8eBdqQFv5eulmG6/0h+HTs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G1RiB5ql;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758135952; a=rsa-sha256;
	cv=none;
	b=DvUZWzNjlipGYEfJbVDoTXZ3kVxPEr8zvur788ZM4oeOAoilGTEUWLQvAphJPf78KBnDwH
	36r80pQWH8o2OKwb+zmTxrI3N5VajCnDcA627rr/XfyE5nl2kczCXYNYTEz/UF0Dk7mcFh
	cV/ifyWRJmhquqxn9UWZtPPqgl4QN34=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758135951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iYdTqhfdz9F3OSmNWg0L2Bcl9ZF1XfZz244Dszls6io=;
	b=G1RiB5qlvpnPm6CnS1p3/Xs5XNpJEOAaEhdCFOl6Hfj4bLQ7nRD8r7+zwF3WudFJseFC1Q
	sAv9F3/zvCkngIkJ6QTIEItfCz5Bu564U8MZQ63JS24oTwZhvW6cBGSA7evrjpJrxL9FsI
	y5t47PTIieTv10idDoIaei/kKAg9HCM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-jkuDn7BfNPCL07N3XG-A8w-1; Wed, 17 Sep 2025 15:05:49 -0400
X-MC-Unique: jkuDn7BfNPCL07N3XG-A8w-1
X-Mimecast-MFC-AGG-ID: jkuDn7BfNPCL07N3XG-A8w_1758135949
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3eae869cb3fso37217f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758135949; x=1758740749;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iYdTqhfdz9F3OSmNWg0L2Bcl9ZF1XfZz244Dszls6io=;
        b=a/+c7mhKKR7ImfLb4gHOxEl7dhvB8esL/XSnRR7r4NY0tbAm2fTwiUSBXE2U0cyf+V
         ibpZhYK8qPwAQ+btFjqRNiexG1U60Wnq5OY4yDUeE3tqC7ysQB9CNSBUm5gfa86/EzSs
         v9ISRfEPuS7cYZ6tjJcUdGbbdkZxx2PHic0nnUl53LGo1009TI1NCFKZeCGyz/dY+fvL
         cHCnLudnnEAsIkPRA/pgYXKQqBaaSTAC2Q05fO8hp4I1i7obs94YKAG8ndtc7RS/+nfy
         zoQ2a/ieTPstJTGSw0fMOWhBFZ2Md+ywv7Vx3c6gHb+prKcGL4iCqr6VkSTh5aZdGJRS
         j8wA==
X-Forwarded-Encrypted: i=1; AJvYcCVyxQCGeeFY5qP9sB94/OUaa5B5FKxItMpwB06ndrWLEle9gjD8R19JXL8HtvqNlkmYLTR1g+IfPg==@kvack.org
X-Gm-Message-State: AOJu0YwyCH6HRLjDEnFYSrfSJxz+6JhL4cS8ip6HnND5j1Qx/bBzTLGi
	1WMHY/POXwN372AKczoApiFhxmBZV9jQerpbh3rHEuVLT8SA+tuqNR1lt6OXmbk9s7c40ZNUStw
	GN/pjtZcXx7HMeBqocZzZ4wxi+Uh74DYbLxyQzVcG7jILC2ZOcOsM
X-Gm-Gg: ASbGncscomukrMfCARPnEo2uOeExhNpBBTRIZiKNNrtaubxyDeOwJx+tlSYy3RNm1Xt
	/JhFWO5NdSyqKW8Fwz1SgPxEg1zAF033jHnM9zb8QQit0ddSU8N4KQBtquFvslagmsnCczsq01c
	c6gchu97ch/636JwaMleDwiPkZL8cmMg8Uztxzvp0wyGcTcX84PdadIYd+fi93rUZDGc9h6Y1p0
	sDS9eBfFmgmh6m0T1fv7qjvITQuJrH4gqKdFM0yxSx0+1jW+safvhgrKwdWlEW49Wk2uY7WqY7R
	E18q99QcBjK68PLXXdEtpv7DU38ok77Uj9DYLuWFwlVKzTZQkgeHH6DEBIMA+ZM9MjHLUlyCZ7q
	eRBiP3/f0cI/fTxkK/jB5/fFUIPB88y/ihq/Od7Y7ujAr7UaeCFTm526AEUBZZyR1
X-Received: by 2002:a5d:64c8:0:b0:3ea:e0fd:290b with SMTP id ffacd0b85a97d-3ecdfa0d2f1mr3067870f8f.40.1758135948716;
        Wed, 17 Sep 2025 12:05:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkB9K5+m3ks5tDl26fGtwUBcSZFKAuJY0U4QfQl4kZMxsZJ5NivU//n+3kzLJsG+tBhuQWwg==
X-Received: by 2002:a5d:64c8:0:b0:3ea:e0fd:290b with SMTP id ffacd0b85a97d-3ecdfa0d2f1mr3067845f8f.40.1758135948270;
        Wed, 17 Sep 2025 12:05:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07412111sm453030f8f.28.2025.09.17.12.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 12:05:47 -0700 (PDT)
Message-ID: <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com>
Date: Wed, 17 Sep 2025 21:05:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, akpm@linux-foundation.org,
 corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com,
 jane.chu@oracle.com, jiaqiyan@google.com, Liam.Howlett@oracle.com,
 bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de,
 rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
 shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
 linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
 <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com> <aMsDJ3EU1zVJ00cX@hpe.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aMsDJ3EU1zVJ00cX@hpe.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SrRNu10QfRtZ2OiO4itFBy05kYWCqCAyyhCw6boXhXk_1758135949
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F2297120007
X-Rspamd-Server: rspam05
X-Stat-Signature: idc5d94c83kz349cfrskqoicesbkndzk
X-Rspam-User: 
X-HE-Tag: 1758135951-181227
X-HE-Meta: U2FsdGVkX1/VKPRLsnBRqEFMXNIx2KXdH2tBzIiWY6WaElK6Q2QGGICujuy/JbQtlmzemsAiyj6z9Yr2YvJbWSqLZ+MzeuRBx+LfMeoQjbRizaBusp4GXv1/CokybMaRF1PjkBAXiPqrC0zJfx+zRjhi+5eXzarcBl9u1VG8fQ+gzc1gyBdBl7tO/bDCVPOTt3uUr89funou+WgdJWUht1xFy2EBKT4sB60Rw1FzQ8TxFbAA6c/nI/MoS1lJNhdSy2GkEq4eqx3UcU8ikYcVUHfo2N45zLjfx1w8U92wK7Y/XAo8X0mam2N2oD2O7MfVjijccbp/xrwOCTZEBew3RsMRRIYjoEs0FO3caG6Pc3Iod+Fph49DSf4EJ1uVvkDEv8EXbA7pUQuL5D8P/Zd/R9MWFFxafuSWSUZgYDj8cc2JiGsD79DoQ6MGFliEeC6v6lT8KRAQFCMF7Ix/Xa/BlkuOf24PJQzOGCSZzA4bsWcYI9uMh35WkdlNabsVhOpdCH/hpwZUgc1nfbdNgK+UbCxxfT+ojRuOu9RilpM4BWkfEVo+PY58FnRyZ5xmgZzBzQiTGOBHJEs+jncGVQp8sq79lpiyhIMblRYHkIEzhiBvOinLho84kNnUr762m4J2p8jNlAiTUXYxLbK/oCJc3IJCt70PMniMTTeVSZKnksEHg6OllVQLiEi7q+lJytCIr5D4eRux5unWOv19HHubJYe0aa0xdRXAODLnYq2kQ8rc+PU4Y6eXe/BXAWJvM6qUECjfXzElZGhC65fwEMe1BD5ESpcJjO1f7/LHW6B16FzaFfj/rzuuys6xLnuqV0TcmI0zuOKacU+/07GpYQuVvhZ7AzvfydceFr7u71s7v835HQjViajunKhVgaE3gywTWl2HNuxzA2cjMyB3w4HnvjCcB9KhfodkQ7vECEJvniKpU+7JUQfSTGsTThewpXM2rWi23qutzQSKGljxPdM
 /7y9/3BD
 vA9zlQqsybzr7h/XexhxMYqUB7GlulZN0Wr9zg6p3Esz/JRJR8QG08s0bxYqulFWONwhiEwTmXdfTque7A9lO9qNTseNRYJ7tGZkZA6jcRumBbLK0+cPB5zpgVOeVLruC8fQcklincVb+cDuaZomjMx9LcZyPyzZoUkduXDpy6BxFoR8O5E65PN4wqVwqGLCJMMp4IgQsERVFnCtiLXn3cFrGH5odHg6fxo+9f5U52qXJT0fsS/BYuHSSeJE0VUxhfhrqNmoBTipYxSYu8tZl/0wcy/WVzluY4xagu0IHJwLgIxhT7DLHrw13dZG8VzE4FFfLKeMY5k04tGpJtJZdIIJ91hve+qJsIERHTvZ/iSj+nAzRpNN1WviJ3QdXgQ27Fen4TD0R302V+sKmyR4Y4e+J0s2LlamwoWkFPeZH273A27gy1mY38tJFjIwtcsn1lnwVZsF/Bg1jIdMTjrFDyAxWKjW9GQ9SvhcfvosC0DWucBPRaBOj8U1dZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 20:51, Kyle Meyer wrote:
> On Wed, Sep 17, 2025 at 09:02:55AM +0200, David Hildenbrand wrote:
>>
>>>> +
>>>> +	0 - Enable soft offline
>>>> +	1 - Disable soft offline for HugeTLB pages
>>>> +
>>>> +Supported values::
>>>> +
>>>> +	0 - Soft offline is disabled
>>>> +	1 - Soft offline is enabled
>>>> +	3 - Soft offline is enabled (disabled for HugeTLB pages)
>>>
>>> This looks very adhoc even though existing behavior is preserved.
>>>
>>> - Are HugeTLB pages the only page types to be considered ?
>>> - How the remaining bits here are going to be used later ?
>>>
>>
>> What I proposed (that could be better documented here) is that all other
>> bits except the first one will be a disable mask when bit 0 is set.
>>
>> 2 - ... but yet disabled for hugetlb
>> 4 - ... but yet disabled for $WHATEVER
>> 8 - ... but yet disabled for $WHATEVERELSE
>>
>>> Also without a bit-wise usage roadmap, is not changing a procfs
>>> interface (ABI) bit problematic ?
>>
>> For now we failed setting it to values that are neither 0 or 1, IIUC
>> set_enable_soft_offline() correctly?
> 
> Yes, -EINVAL will be returned.
> 
>> So there should not be any problem, or which scenario do you have in mind?
> 
> Here's an alternative approach.
> 
> Do not modify the existing sysctl parameter:
> 
> /proc/sys/vm/enable_soft_offline
> 
> 0 - Soft offline is disabled
> 1 - Soft offline is enabled
> 
> Instead, introduce a new sysctl parameter:
> 
> /proc/sys/vm/enable_soft_offline_hugetlb
> 
> 0 - Soft offline is disabled for HugeTLB pages
> 1 - Soft offline is enabled for HugeTLB pages
> 
> and note in documentation that this setting only takes effect if
> enable_soft_offline is enabled.
> 
> Anshuman (and David), would you prefer this?

Hmm, at least I don't particularly like that. For each new exception we 
would create a new file, and the file has weird semantics such that it 
has no meaning when enable_soft_offline=0.

-- 
Cheers

David / dhildenb


