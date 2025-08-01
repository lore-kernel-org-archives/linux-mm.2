Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B392C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A232F6B0096; Fri,  1 Aug 2025 05:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8A46B0098; Fri,  1 Aug 2025 05:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E846B0099; Fri,  1 Aug 2025 05:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8210E6B0096
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:04:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A9A481AA8
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:04:10 +0000 (UTC)
X-FDA: 83727601860.24.D7ACE1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id C6A6C40011
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:04:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eyByzm2/";
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754039047; a=rsa-sha256;
	cv=none;
	b=z+uhzzbxQjSkBCuc8cGPfeA14OXleK3oPag507uvFxkxYP88bzUMQUMtMdQg9m4IaOB66+
	KMOgnKmjhDhkodP7yu10g7HkdE6Irs5p4Fj/mpbtrShUS/U1wh59ynRsdpAeljAPesIj/g
	YoqKKEbA9Sl4R16zEAjjJgp9S0jCacY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eyByzm2/";
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754039047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRD25sedaIjZXj+qDAPX+BDxoHBPtP+iWA8E9uH6ICo=;
	b=hhshu7J0MkebUZT0tu7Hh0U5DepNmWjQht4xf6tqzfN9oy/cn59p182n9zofawzcHiOEdx
	TQL6APa0CDNqgks18bD46mCvea+OROSsrUXT4/P3MotEFHW3NDyCwbwmvM1HLnyCGLoMRI
	7d8Bq9ZyIaNxjAFZlKd/4vFAUgPvlCc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754039047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cRD25sedaIjZXj+qDAPX+BDxoHBPtP+iWA8E9uH6ICo=;
	b=eyByzm2/Z5qDD8fuSalYKf1Oqj4rFLPJ7lGI8JvKs8E3N8lbbOPefEAsvSEG9qRWd6YG7p
	BZYsCY0hmTZZLTsoOzdL3DXyo7saRZnMcz4pk6mxQQAqeA5XYsLTIMqedWDtF+Tmr2mei1
	jF3+McbHpJgDj9bX2XxmMboerupJO9o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-bqPF5iKMPDe5QJXAMAVN8A-1; Fri, 01 Aug 2025 05:04:03 -0400
X-MC-Unique: bqPF5iKMPDe5QJXAMAVN8A-1
X-Mimecast-MFC-AGG-ID: bqPF5iKMPDe5QJXAMAVN8A_1754039043
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b79ad7b8a5so1179069f8f.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 02:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754039042; x=1754643842;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cRD25sedaIjZXj+qDAPX+BDxoHBPtP+iWA8E9uH6ICo=;
        b=oUIHAZTcGr4AwsIdjGljjDJsgkx9sx2GDCBT/BpMgE87wOKKaPyysmyGU0hu41U2Ne
         lyhIfT6D4yKblEniEHH1gM7cTJvqHkWKSmRmDInunYKckJWhKyEs8t36thKmJxJwADbC
         y+jXtoKa6L6P2Y0CR7WkM1tVS+NpU2srvYDQU4tqHSoiN32yZdnOwRw37oqn0CdA3hEa
         bcRvYZmVqPZbggobeaYSMYQ2Ahhp2dOf/7Mm2ywckpt3ol7Vjfyns3j+8e+wF8UTjBmw
         Xd27NEXSqM5WTzzLb4UwpgOdTj6+jaj9H8zhzTpDuNe/H3A9NSyGaUz8Zw7EE/CY7GUy
         Si+g==
X-Forwarded-Encrypted: i=1; AJvYcCUCZty9jwPQZ5Twcauk5hbKlAR4UBsApoh9Lgfk3DRMsnlBEp4kLXS1QwZYbeT+oTewAXfHlsYzRw==@kvack.org
X-Gm-Message-State: AOJu0Yw6eTgVx2SF2pdtYoxpciOTu/NVjFMmUMCld6SSM8OyXDHkmQrQ
	V/VPyKAGU65zoOna5lvJoe1cgG79LtoTptcNo2i/C9cNq+fRBRJm04bflBxGE5NtfHhmZw7IsY/
	dbN5I2y4ArDG0ew1OAoRG2iksH204rOkKYGRs51mk0J42kwJOzVu6
X-Gm-Gg: ASbGncsU9D0xNxkUdxzHwcsnxa/r1nS8OcckokG3teHvsc6y7ZMjm8gvsePbKxy8ghx
	WopMFs6UhzCTHLq5rHFmjeT9EdLTocPfqyqD0Pc5EsDba+bf9PIDqChE2kRBUZsXWOsYsGkZY8c
	lky+e07ngihIXl1vtsbmOHc6n1L9cM2ximJ7SG3VBbgRp6LIpmoxELYz6AVBjmlRF4CZ4wl80ZC
	w4G6zvCJovCX9lb35mdBb+/JCWyLZ+2DBEvav1lj/H62eDHE0cN7dtrWNuK1s2NFfrrtNremqg4
	JHZ7Rr73mMqMz2U04wO9KObe7UX9x73O1vsP2Wnud7+wLnBkBtwWCnQdopNsJTGadwOxxn7RuKs
	eNhPj/qoYNQaRU8C1V1wbl+FQPO3hYfRaKNQfmErQAuSlEptMO2vhuSsRG33hlWqY
X-Received: by 2002:a05:6000:18a7:b0:3a4:f644:95f0 with SMTP id ffacd0b85a97d-3b8d34b0ecfmr1768525f8f.54.1754039042405;
        Fri, 01 Aug 2025 02:04:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGK+KG8xlZVg9JksCn4O4NiosqBcdHpE5fmX/CIoMx9dQCMWNiuz57r3wjBfzb3dQXnmbtcbQ==
X-Received: by 2002:a05:6000:18a7:b0:3a4:f644:95f0 with SMTP id ffacd0b85a97d-3b8d34b0ecfmr1768474f8f.54.1754039041904;
        Fri, 01 Aug 2025 02:04:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee57922sm57069765e9.22.2025.08.01.02.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 02:04:01 -0700 (PDT)
Message-ID: <3939866f-e57e-4caa-919a-558bf6866b82@redhat.com>
Date: Fri, 1 Aug 2025 11:04:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mempolicy: Clarify what zone reclaim means
To: SeongJae Park <sj@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Brost
 <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Alistair Popple <apopple@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com
References: <20250731224155.1646-1-sj@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250731224155.1646-1-sj@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q-B3PYSpAyxyOyhbOYnEoNRhgBxQSt2q8XDW5R1kbLw_1754039043
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C6A6C40011
X-Stat-Signature: dh9w7g36bqnaxhmn4d7xo98qgiuthmfk
X-HE-Tag: 1754039047-907168
X-HE-Meta: U2FsdGVkX1/tH27YmpLL2ZlYXZciNfJHhQHTFrDvjVioHOzdpfGvQCjbLki8VUJa24q45b0jnQXNOKUL3Syywx46uQQYJ+kQvh/REQRCGlCAT7DUWNKJZadiAMcpsLDFCiVkxYE+5XhLPVTQ2HuA97gM0cKwtnJdL74KrLd+02P/o8aMQVN3+CmytAOBAn6+BEZlUbYY29ZmUqP9LbWAbQGhqXe1DKPTgo31niYzxtGOtS5XYWU7VWyNS73c+zin6aynTdVXWAT0NZsL1KCGVNnf4AB7Icfz70WaI9Q+as8sbr5mEydkMCdocQBsXBTj2JFHf9uevfKDCvnO+qvI7tJEPA7OfL0Vpm8aqVXHcNeMllUHmNdU2pAZI7ZDMG7Sef55uFqXHQS/4UabNO9bV/QB4OBAPAtq8DFnK5hCo+KbH1eWYw0E91xQhxi5729A+W45SE8oBdCMSLMKARH2AdurlFHio9CN9xuAa2hhngFt3gQTLwg5h4DeWdeztLJ4H9c+cxPi+bwIrYY1MS9faMH9Kn+c8bRc9WqmkrB1Uugrt9R9zCzEjqbHa4iNYlqYIwDrXBlGxTlfu66uKgMj/OPqlbCmlx5LJEbOuvoRI6on48XUxeyM0f1vv4Dc+W/boFuWcqjXoi9qubUbIplpo/Ew7fshEcDrlpzzg5iUQ5XL4SwIZTEra3MCEcf6h50mXJS3qD48pzTlV+2rGc/mzIGUNgujTRcG1AnxhDAs6adB1S+1pkAZKZvQHCrHtLpIcFB/L1HSocH70HkmndaEh348d3GEsZxiUc+AAGYgq8EQGIGMYwh297BBGUaCZ/f4vlaXqIGUUlq1rmV3UhC9kyZsMJu1AgT8Ulat4IWfEN0NGzdB7adAXT9ny/RJM3TiBk6EbkWf6a2x4+NaU4gVffY96+yEiQW7mGDLgsd2p4U/H2pk1+dOIFAXQNgfspdhK3oLnOM7kCaWywNYolj
 SIEDQLCd
 BLlaL8ELmSr8v4HpDPNGQfvOmDDwG7cx1uWzUdjo8tKRljsiVtGajmQUzByx1csEtfSSqUR1QFFNG5oJ7RTZQgVgFsauV8cqXFr6aLhk87+2VU3NoKVyOrpLeDbvb/B/5KSwTCtNSERQ9qa1HP+wDk/pyoVxNv6+qGZlE6jV3ODDc76he+MXP2+iPTixAh32abGf/Vdm/VXCkBnBbjpW4mJr5T44dS/PBU+O4rGDYC1JhZ3P6KmYrXuc9FVgZo1lQra0OiSqu26hkj9DeGsBxuOauy5rRw2IfkHCaWmpyQrHoQOOhAs0yptkzGu9McqdllwCRT+OlEL9neRW+n8JOr7uD045+n4/8ugDlHC4GwbQG0gCZhtnJ+1D0fR8R6deFXCTlky4lxbdjQqDMf4Q6QGDkn77nuGmAy444D6ZIje0cQkdXfd4vfP2acsbrr37PPyzzIEOPxW+SfS9SeB95R5KJPVCvdH4KwqwBAQ96itRE1og1ixw2AfrocWKnU/KJp+tZPvjucQz2f5Tpih7uxIdrxY6OBRI9yxMBdVobMl9JBKeiumI8kGUZxb310Z1rhF1wwbvEyxBr5PNHFWA1s6+sd1pJ1A0YvPJsWS2SqG9Yg50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 00:41, SeongJae Park wrote:
> On Thu, 31 Jul 2025 14:07:37 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
>> The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
>> memory. Contrary to its user-facing name, it is internally referred to as
>> "node_reclaim_mode".
>>
>> This can be confusing. But because we cannot change the name of the API since
>> it has been in place since at least 2.6, let's try to be more explicit about
>> what the behavior of this API is.
>>
>> Change the description to clarify what zone reclaim entails, and be explicit
>> about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
>> past already [1] [2].
>>
>> [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
>> [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
>>
>> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> ---
>>   include/uapi/linux/mempolicy.h | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
>> index 1f9bb10d1a47..6c9c9385ff89 100644
>> --- a/include/uapi/linux/mempolicy.h
>> +++ b/include/uapi/linux/mempolicy.h
>> @@ -66,10 +66,16 @@ enum {
>>   #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
>>   
>>   /*
>> + * Enabling zone reclaim means the page allocator will attempt to fulfill
>> + * the allocation request on the current node by triggering reclaim and
>> + * trying to shrink the current node.
>> + * Fallback allocations on the next candidates in the zonelist are considered
>> + * zone when reclaim fails to free up enough memory in the current node/zone.
> 
> s/zone when reclaim fails/when reclaim fails/ ?

Agreed, that confused me as well.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


