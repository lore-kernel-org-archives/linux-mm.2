Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3478ACA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CDDF6B00C6; Wed, 27 Aug 2025 05:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67EBA6B00C7; Wed, 27 Aug 2025 05:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51FC16B00C8; Wed, 27 Aug 2025 05:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7CC6B00C6
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:18:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFC27118F0C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:18:04 +0000 (UTC)
X-FDA: 83821985688.22.B4CC312
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1AB44120010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:18:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jEbFQona;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756286282; a=rsa-sha256;
	cv=none;
	b=Py7Q2rkjfHL+kiOgb5hdcg5jIlHqAsoPZ31vLLyt3Mda58i2x55MmDekD0G2McqMUdbJLB
	cU8v/f/1bKAls87crg4Weybqc6Ywb9dKxAfi3I36d3+N264dFc4aYE3Bs3n0lxiSuOxQ5r
	/BE5Wh6pda0C9yDJHecCCCOCsQjuMrM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jEbFQona;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756286282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPdRdfa3itFIpv/sdIBtoejHMA19COoSLPI+kRGgDDQ=;
	b=IMq9DR+wLp7eyPj57tyjxsTLWLDTOqKGydsiHZTQltAQHRLpcdj7TxhuPzIVRV+JTSyh88
	t4E1905eO0Dtwa9OcY31INW6GympAJvOLqm5BmDmBweHYk2eJGpHn0SKWtTIq8gIp6iBUL
	uSZIqZDbbT/vWBxormIBcGsJnA8ZBRc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756286281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fPdRdfa3itFIpv/sdIBtoejHMA19COoSLPI+kRGgDDQ=;
	b=jEbFQonaXqkJNSWatt4Fb+Q4VHPLEQSg68RTaC36Rq+FJOG0oBzEhTDzvH3mKhAv2+7J2/
	JqgMtEi/UvszaMr+LaC2k230iguAWR2/AELfCvpw9HTp+5bqjlc45wCTFtzOyDJG4BfKqY
	YPqhELCS+jLnaq5I8zD8HFOqQoAFTxc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-PpJ15sNJNWua5ySSoVlemA-1; Wed, 27 Aug 2025 05:17:59 -0400
X-MC-Unique: PpJ15sNJNWua5ySSoVlemA-1
X-Mimecast-MFC-AGG-ID: PpJ15sNJNWua5ySSoVlemA_1756286279
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e88f379fafso2349649285a.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756286279; x=1756891079;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fPdRdfa3itFIpv/sdIBtoejHMA19COoSLPI+kRGgDDQ=;
        b=JwIIDDptnOWVneW/81+qdSQ4sz3pcdhHcHcZo1moc3xKgH6Zl9Uqs403+28liL+sw5
         nqYgoNXQh9x/mg8TcyaSOmt7ZCk1RZTZiCxdj7QZQFPA6+grPbdD/MVRuts5l5eBFI2m
         OWURF/pgE4C4bHV+WAaMbOG+gNNVmpXSz/WKiw6ZxVjRec6sOs7aBSVBZKNWSnYh68TE
         uC4Ky0HEnPMUYGEoIcI6V89DeFk4OAnQqxTIQ5Yiwx/tJYc671z7MHD43e2qgnEOKRKl
         rdy+D5pfgjRe6Tu0N4aeh3yfJ+1UDGm8sDW7hKj2UbAQAPA/QgFQ+YndP/kYRCOiKxFp
         OCtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJJWJWHmcKN1MyAbS+bHNRrWCK3xRVWqGHWmwUhuFDlXxDo8EZ03pz28CNXib+OzKaSRLrZ40KNg==@kvack.org
X-Gm-Message-State: AOJu0YwYZ0uV1BoIwcVe4y6Tf60cnzcBTXohTLRMzE2LKBmVxuCpA0pc
	KYDRX/xebyphgBeMw3tm7AeKm6L3voasw4kc+u84U4+mBKi0KVMmqy/dgyXfuTg4AaHGiMjZoTg
	CilBuRN7MAzfXwEvakMQ8/oPoacdFEZhXhOW7vlDjQvZV4UPW5UQr
X-Gm-Gg: ASbGnctYphovvsZTfnhhkhL+/H2StwfWUsVEz2PP13jbagJSWxXS2GqUIJs82l4yOnc
	lckrsATXbOE8W4pR+tkG1Gnck8lnMiCDHHOL/9puHV8kzQGkW2p/FhhA0zf1hFUN7CwKJ3GX78V
	NKZH34kngMumWSm+jXyE6x/hCGuisx7zn6XShlcl1EzsRNeDJEJ0OM72JIEueeALCRe4bjohApX
	pW4+Ykc5KbdH0S1XTiW7qjnFTbsHPVb6WBx9p268g8GGzZ/UF04PbhyecyatsUTWX5iI/OCjm/f
	nte8MRmm2NRM05D8VQOcTKuYhNh7ULfrPYeno3fymjpx8HJHUU2MeZ41tOM27A==
X-Received: by 2002:a05:620a:1aa7:b0:7e8:4675:1f98 with SMTP id af79cd13be357-7ea10f53dafmr2141536685a.1.1756286278598;
        Wed, 27 Aug 2025 02:17:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBr3cAa9rGP60RmGr3RR5lnWG71BcgyOMSMlJMRuSKqAUwXZHMAmO3wDBrYZWvji789LhWdw==
X-Received: by 2002:a05:620a:1aa7:b0:7e8:4675:1f98 with SMTP id af79cd13be357-7ea10f53dafmr2141534185a.1.1756286278002;
        Wed, 27 Aug 2025 02:17:58 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebf43617cbsm825346985a.72.2025.08.27.02.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 02:17:57 -0700 (PDT)
Message-ID: <4fc879f0-5578-4a67-bf19-a4b8c8b2b17f@redhat.com>
Date: Wed, 27 Aug 2025 11:17:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 2/2] mm/pageblock-flags: remove
 PB_migratetype_bits/PB_migrate_end
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 linux-mm@kvack.org
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
 <20250827021121.13645-3-richard.weiyang@gmail.com>
 <9D5D10F9-0D76-4C31-B03C-27A3A2B526AD@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9D5D10F9-0D76-4C31-B03C-27A3A2B526AD@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hcO_k_HBIvsK0zVGtpPo0-G9kZpHFjE-DGdIe9_kXxE_1756286279
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AB44120010
X-Stat-Signature: yerfqq767d3hjrzjknezk7wjudnjs7fq
X-HE-Tag: 1756286281-485415
X-HE-Meta: U2FsdGVkX18hWmJEPuSICAvxzuYHd3MD7zUelgVxVIH1HA9WRd+88eh8hZ4enQzJ9q2bN0KaaesNYv1EkfQKM1nkvxgKc9wWVEstRQ7I6dTuubssd4SaoWS9hVaAGF7u1/x98+kzaOj+lxICCTushzzlFa59fzMqmWGQh0pepDW2ietKcmfLe3ZKyeAQQzTVTn7h+EyX9WKly3cb68rcDE0e4VgK+pvneLn9WJ5/qf1wul6exOn8FNidfILOh6pKWKRAq1f3DmJ/mEcUJgj6JsHeOrrArnUxqkEw3PlGZsFwIsd/OkTetQUol1M+ummIq7fd+xbcZiajj8hZOXFz6/Cl51rfdXQ3BBNb1owlQ68r2+8IJn8rLmWG3Knd9U4dOGYslXZ6ZwZL/nQccqcHiiX7HkmCl92ryBjUqLp4NrGn6VqHdx+QLYnIeH16FHaIi/y2kuj9swm9yEYwkHjha9lDDfUpJpWrEQjdh5uHYhshsLDcD2kk1EHt4bAYK+68FvWZKEm7zTqJeRer3qYYnAnF88utxp9mB4OlJm8QkPqE7mJimRNBO6/0bQSvul4sSJ/YWlXm4doKe8Eewe6grCe4t2Yck3NKbC5a2XW+1igWpjE4O8RDHcTe2uSRMwo982HZKBjzls2O/RMxzDfd/T0Q+BrfpYaRVo2UF91M98qPl6J+sXcc7LAAXB1xGFWYD1fRf4YZwQHQuQ47FVgICBySGxgydPs7JGb7TaMIRlyaCUXUQCx6txzSMFF+iLDJWhcm7nbrZEvLrlKK14qfQvCqjmhdA1BDeFDzKxYpDYah17DRThA2Z9Ems0ROqypadLBnRBmAIVDpiQ2HvkaxhDbw4CsU3tZsRP5q0MzLoi+ivpUYLsg3A/lhydd/+UVlnSrwJzcfRHB7Ih5SqBOmHtQd0g8idVSRX1xnAY/rbvRTmVkys7ACAyAe8IVZfbL5s7/2S8Jc6hHDkKlAGY2
 WnbMMeLW
 +Y977FdgwZu27nLEUEfjmxmsHsMnpE8TEji8azhseTdPnmwv6cYNjBXfIHWuKxqeA9UCfv6Gihh2swMm661qNJMvdrQsucinD4muFQ4z/mz5FiUYqExg+KAjFYgcxiursxkrH9w0j7T5BZpaW0tevH+sghL90o3pLUTPvLfsakBQg2rlIJNs054dbYkp0mGhXwukXr8ts99eIJQBe4k6BtOSPEwp2nBXQhMvrP+xvIWLQ92SB331Kkoom5cil5i+6rBlywzxIk7SbEaHJIWjurher31rU1S+NT3adfV/C8CLXQDj7jBC+XcRW4rmGGgKeMfx7ng3lG2G37wbCfbAZROkoe7if5OaR4CNwOuSxj9uJAfPwbVE6+nVV/2n9Y1dTn8ZMGeVofd4SeXrSTBWR0VrcIZSKsO+GPJdN/9Y1NeRpPo6rxLu35haGf3EBrGTHKTjcCvlR+M8RVer3NUmCiremxGuOFiBd1wPITbY3GJS+ACzWwmkQ7ngXYPMkG/13nSEEHEsYk9ZVvNsj8prH7pllpsjgrJ/4V/0weEZSOIBnRaLUF8vMWKGpzq9rw5oUT7BC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 04:21, Zi Yan wrote:
> On 26 Aug 2025, at 22:11, Wei Yang wrote:
> 
>> enum pageblock_bits defines the meaning of pageblock bits. Currently
>> PB_migratetype_bits says the lowest 3 bits represents migratetype and
>> PB_migrate_end/MIGRATETYPE_MASK's definition rely on it with magical
>> computation.
>>
>> Remove the definition of PB_migratetype_bits/PB_migrate_end. Use
>> PB_migrate_[0|1|2] to represent lowest bits for migratetype. Then we can
>> simplify related definition.
>>
>> Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
>> Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
>> cleaner.
>>
>> No functional change intended.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: David Hildenbrand <david@redhat.com>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>>
>> ---
>> v2: remove PB_migratetype_bits and PB_migrate_end
>> ---
>>   include/linux/pageblock-flags.h | 12 +++++-------
>>   mm/page_alloc.c                 |  4 ++--
>>   2 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
>> index 6a44be0f39f4..6e4c2da15706 100644
>> --- a/include/linux/pageblock-flags.h
>> +++ b/include/linux/pageblock-flags.h
>> @@ -13,12 +13,11 @@
>>
>>   #include <linux/types.h>
>>
>> -#define PB_migratetype_bits 3
>>   /* Bit indices that affect a whole block of pages */
>>   enum pageblock_bits {
>> -	PB_migrate,
>> -	PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
>> -			/* 3 bits required for migrate types */
>> +	PB_migrate_0,
>> +	PB_migrate_1,
>> +	PB_migrate_2,
>>   	PB_compact_skip,/* If set the block is skipped by compaction */
>>
>>   #ifdef CONFIG_MEMORY_ISOLATION
>> @@ -37,11 +36,10 @@ enum pageblock_bits {
>>
>>   #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>>
>> -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
>> +#define MIGRATETYPE_MASK (PB_migrate_0|PB_migrate_1|PB_migrate_2)
> 
> I think David meant
> 
> #define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
> 
> Otherwise, LGTM. Feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com>,
> once you fix the above.

Yes, with that this should just work

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


