Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D249CCAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364A78E0010; Wed, 24 Sep 2025 05:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C078E0001; Wed, 24 Sep 2025 05:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203598E0010; Wed, 24 Sep 2025 05:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9D88E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:40:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1B1FBB64A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:40:28 +0000 (UTC)
X-FDA: 83923648536.21.B7293D0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4C3261C0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:40:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TVmU1PMO;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758706826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5g2huPHmUyw3NpDK8BXokdT/yczIG51iBSq9Te/XQg=;
	b=Tubm850j+wbaDWIsWrHKZOeWeAnIN2TPQdHA1Gxqv6qAKehyWAmgUueFnkvwsfmnjjcPHm
	GMTD2SaZnlQ78uYsdsT88yF8sOStaXR0l7A2Nu318V7n2qsKTuhevLVulr1GnnJTbp9fS8
	6BCiYQYsjOaIii5vccw0+Fvp0Ud1TRI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TVmU1PMO;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758706826; a=rsa-sha256;
	cv=none;
	b=FvQDOES6j5LWv5KoU1fGILvcIOZ0JCkJy8wgdF3NCSriTpvLnk11WSk/zOU+iD+dEq+ony
	9s+K+IHekmAivXJQpiuCgsjwWC9giDdtEU1gFyAifaDgHyLqeqt5LwrsrwJWlFeihCJcck
	xTxkIiHWIlqB9hLxKqAVALK44YBeO5Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758706825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Y5g2huPHmUyw3NpDK8BXokdT/yczIG51iBSq9Te/XQg=;
	b=TVmU1PMOiBr4ODBfHaW1v31bp0indEDKnZN6d0PfxEoeOE5H9RAzKbUWSBTLZS2bv1NQGG
	BbKSnqqNo/wRZxPbzLssPJgh9qIJlOiEC9PVHMXEOslDKd6odpFK9hAfbbt8OzJsYWMoYK
	qw61UR0nh/qEifMEnAd5AUAdPMrbyKE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-yhVjg4N6OaSUR6xdIVIpxw-1; Wed, 24 Sep 2025 05:40:24 -0400
X-MC-Unique: yhVjg4N6OaSUR6xdIVIpxw-1
X-Mimecast-MFC-AGG-ID: yhVjg4N6OaSUR6xdIVIpxw_1758706823
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de18e7eccso31412275e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758706823; x=1759311623;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y5g2huPHmUyw3NpDK8BXokdT/yczIG51iBSq9Te/XQg=;
        b=S1tTtwBH8KhRMlESlj8IDsZKowRfHNPYdgZGhgwHlxlmJvzGFyslhf3yNpH6bhsnGi
         f757p0O0JBpoL0UD5p44Och4yrfOFz3PCHOvgSscBgH8YYdQI5DyHSktTgKAduBxXuaM
         SsCk1wmQHYLXy0T8go/ARqgeqKkxuyO5+Ldz3Q0vXddx2o8LEj1ZL6FDGKByo5AGqvOD
         9g9+fl8MlYSk0yAHM2MZLmQh2YirpMyVmgLwGy6MG+CG941AB28Ya5E2LPDPhAMb52Rr
         WJ8Cv8H5V9H7UWGOeWTVgoiJ/h2liUIsyEFXKBJi/sqQtGjDIQldR6470A+YuNzb2O/J
         M8Hg==
X-Forwarded-Encrypted: i=1; AJvYcCXCWqHK2glB7n1rgheY13c1OhmbZoKNDYQ5TioaEQh/vviBpdyoi+Ee+kpfraQllDCmGy/aQzWcVw==@kvack.org
X-Gm-Message-State: AOJu0YwooMZdxlKaM5qfwbXN8WA3su3rby++6WD2dq62m60wrwgbN7cu
	4Jc93Tq7LhOS4h3jSTaoalToMOH2YVvY3Irt/hi0BWJ65q++IQau+YuLIaFc1i1DXi5EPVrrXKF
	NOmo1oVqrsP+otZm85dYABdZgVKKGQRvIvE0SL0v0jCm4Z+dCfJNa
X-Gm-Gg: ASbGnctbqUZz5xEXugYLu6iKqqH05NWWIaGjNexHTys+Jz4VWLOcvxqjROZFp8P4ZaU
	zKYfReRDMbnbJpB1fL/H+f3s2aTF1EO2gldNAYE22W8vS/iSxcOw6IRQI1XUv5MxkLwmw3gtF8x
	SbZgYluOeF2Cv0Pd0eKdyT76B2B4o03fDcQDfzoCt4NsmuefPjee6Fb2YamtWJeXl360EihRgvK
	xcWx28ZgZXnI1A2JVJ4rmzDPNR4kCNFREcnbS7cD14D1PLTLQQ9/CY5LZw6c5RDaLc/TCpgViuI
	YJrZqwQGrAABgML3iBLO2HpyCXzhv7fmY+VVA6UVU6yh0g9ehB7yT7zvOQRhOGwAlYanszjEDwE
	3pdBn002RjzM41lue5t4YZvekAZQuehplAJq74Bh0WrrQrwYkxcf+E2Cm/TyTVvXDyA==
X-Received: by 2002:a05:600c:a01:b0:45f:2cd5:5086 with SMTP id 5b1f17b1804b1-46e1d97463dmr56052335e9.3.1758706823077;
        Wed, 24 Sep 2025 02:40:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1SPfc+AjS8YKJC3JYF7rr+BGI/4Dkb1jzNcjaRzwJii/fosxGNb9VJb9nXiJZmMesquPXnQ==
X-Received: by 2002:a05:600c:a01:b0:45f:2cd5:5086 with SMTP id 5b1f17b1804b1-46e1d97463dmr56052125e9.3.1758706822689;
        Wed, 24 Sep 2025 02:40:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a998309sm24176775e9.4.2025.09.24.02.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 02:40:22 -0700 (PDT)
Message-ID: <1ebbfe02-1cb5-4f7a-a640-68d5d95cb99b@redhat.com>
Date: Wed, 24 Sep 2025 11:40:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 linux-mm@kvack.org, Dan Carpenter <dan.carpenter@linaro.org>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-2-richard.weiyang@gmail.com>
 <27storxu4seijr5smul3xx7pofe45ittjrchii3jtwbntalsiy@2cu3wf42drwa>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <27storxu4seijr5smul3xx7pofe45ittjrchii3jtwbntalsiy@2cu3wf42drwa>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VPkmznMXZwe2wDnFuAefI-lz37ERDj0D4a7hPUPOEoY_1758706823
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4C3261C0012
X-Stat-Signature: 9xnzrq947cmypntaupw69ztp6uiykdi3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758706826-247595
X-HE-Meta: U2FsdGVkX19P/uo7izWco+XMIlPTwpJgBxdiEsPI7UlQ8S/+CA/5hUPAd/ir5EU2eN7h4Y02LOFWfF+yH9bgr2oVwgmq1W7dgSW310byHOOmGScLD6IKP+nRnMhPIsvCa6lkG9VkSNhJptlRT22C5Gpj1pua09hx6dW5nGPpMsEurhGxaZkpz/oyYSF9zFZpkjcZG2LuDkdkGn7wK36cwwGbcZuwSBz1ftEzFOLpkWIKqrNyDw6IrucPN1MvQVQ1MoAmgEA6+TKIYmINMDIqOV4y7J2jmtMkx9c3TIWlbqa2XezZQDaO8nIdxLUBAqdWTFSTsLp3SIFRI92sjKICxAGxDpYSWJyYWqC0KVDVL40nPkyzd4nwsLJMEsS361aCYtDKwUBRPCsSO0g+VJ+yZZXTKeKKd0CumdP+ZJngtyi2wK8f+L0s8kafBmAvhlpF9FSNefyV+wPdyE+X6MmM9H/RcTzFRJtMKSm5cLC0Zia6gP+19//Ow5EVE2kIGar8/7zI7mRjXVbLrM5iHu4yK2gDlesXxAEUqvrBxXRn1RonpFVXUAqj4nojsMkmaDDrzK6IChFFgmtw0X4BhXlTNVPmtTKQFugVVckyRkYiJ/+oulVTjzc2wkySQcqnukriTo86kUiBrPwKQIlplnyOPBoZwmQna04tVkYKmxJ9r2aXw0FxwrqEXgTz4FVlnnlVooAoCuRK6fsarJzUIU1RUKPRHjaDvKlTZU2CJBJd+DcvUek3CP/NX0i6LEeQaS9m0zuUq0OPcxSTRW8n4Mt15T2+ziGCCix2RbhcD/c8bE87NW5iG22RbM1eoDmoGJfQ+01m6oVnF4MwuLRahNnNT4I4mkph0QHFMdc825mj1a4DRwloTrejgaAPo29G5IqgTpI3/8QwqfU7Z5NBQNWamSIrjDXRWAx4TAficD5BlhKslKURH6dCE23Q7is/V5HCFIF6ksgCtd5VHpUsW5H
 9OcPYcaB
 gYFv7aYOr2cn7ITIQtehDBjVG0NWYTLi3L6u2Z52sdvUv8ZzefTIaFsvRyKVj/jF9XDz5ou7CL6XViUjuMSZbcTLZCKCmFJcJ/u2Rb+G9oqTXX4QcLjeA891eR3W227EcYesmTxfLAeB471Q8WPYksjUe2BlalnknVXJ5w6mR8VEx+LJIXsCoUcSzvr4enZ6ZI5PPsyfYIIjjqHGJb9w1NMvT1+gPV0t/JmX7FyTRCszIpKoJKQixsS8nf30MuRVefyo3xy70Mdff2uMB1V5NUwwWOWlN6ld1r7GfL5God6Q9LNbc2ShVOxJ32jXUM4xnU5vTBsc2Qv3FjtWHTay+jxAXHdhG8VVGGpwrrsjTETp9FtDF9vqqcQM2V9us6DhzOGvYFU009vowWWcAIu1fJGzc9UNFwhhqT7+pLfvq3AUbeeVScau6rhxZuPPmhAxj3TMxsNYoGqVoW/ht3j/dZAdLoT7ZWlVPFNkd5sIVtmLrGznqOu9keHQeEcfiLq0Yao7mYT3U2XD4YrM5DaTRJXIovnXeXkKJpxqOPcnQ63/hqyaelkYivHFb3P2Ix3q+t6CzgY+d6AS7U8+ZojZenephgjFopBIJ64B8y2UdfikUrA7GZGGC7VXrNLdVyUJrYUZ12IpgSRTsrFIGkgGl0Q55rK7S1egdweNLn4HcFjn+1+0WUpyY8kGDl40HFSxxnrl8R5hcf5/YwToAgPTGpEh29quky4l55NJZZOT9i6cjmnh5mj4VlBThLVbqAt+zXSunKDzzI9kAjh2I594hB1lPaUvmOttQZLSJecDmPTj0yOuEb/PvKTAIMYd7RucJ3lPAaygepCT1f4IOgH+0uZWqk0iekJjv1aOQVArkED4IlRRHeHsBhZ1f/KyZdikdZ9MItGpdNQcRC0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 11:35, Kiryl Shutsemau wrote:
> On Wed, Sep 24, 2025 at 12:48:53AM +0000, Wei Yang wrote:
>> Patch series "mm_slot: fix the usage of mm_slot_entry", v2.
>>
>> When using mm_slot in ksm, there is code like:
>>
>>       slot = mm_slot_lookup(mm_slots_hash, mm);
>>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>       if (mm_slot && ..) {
>>       }
>>
>> The mm_slot_entry() won't return a valid value if slot is NULL generally.
>> But currently it works since slot is the first element of struct
>> ksm_mm_slot.
>>
>> To reduce the ambiguity and make it robust, access mm_slot_entry() when
>> slot is !NULL.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Cc: Kiryl Shutsemau <kirill@shutemov.name>
>> Cc: xu xin <xu.xin16@zte.com.cn>
>> Cc: Dan Carpenter <dan.carpenter@linaro.org>
>>
>> ---
>> v3:
>>    * fix uninitialized mm_slot
>> ---
>>   mm/ksm.c | 22 ++++++++++++----------
>>   1 file changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 2dbe92e3dd52..c00a21800067 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
>>   
>>   void __ksm_exit(struct mm_struct *mm)
>>   {
>> -	struct ksm_mm_slot *mm_slot;
>> +	struct ksm_mm_slot *mm_slot = NULL;
>>   	struct mm_slot *slot;
>>   	int easy_to_free = 0;
>>   
>> @@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
>>   
>>   	spin_lock(&ksm_mmlist_lock);
>>   	slot = mm_slot_lookup(mm_slots_hash, mm);
>> -	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> -	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
>> -		if (!mm_slot->rmap_list) {
>> -			hash_del(&slot->hash);
>> -			list_del(&slot->mm_node);
>> -			easy_to_free = 1;
>> -		} else {
>> -			list_move(&slot->mm_node,
>> -				  &ksm_scan.mm_slot->slot.mm_node);
>> +	if (slot) {
>> +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> +		if (ksm_scan.mm_slot != mm_slot) {
>> +			if (!mm_slot->rmap_list) {
>> +				hash_del(&slot->hash);
>> +				list_del(&slot->mm_node);
>> +				easy_to_free = 1;
>> +			} else {
>> +				list_move(&slot->mm_node,
>> +					  &ksm_scan.mm_slot->slot.mm_node);
>> +			}
> 
> Indent level gets extreme.

You call this extreme? :)

-- 
Cheers

David / dhildenb


