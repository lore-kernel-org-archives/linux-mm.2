Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC1BCAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70C58E000C; Wed, 24 Sep 2025 06:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B215F8E0001; Wed, 24 Sep 2025 06:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A102D8E000C; Wed, 24 Sep 2025 06:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90D5E8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:09:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 381F813BAEA
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:09:11 +0000 (UTC)
X-FDA: 83923720902.03.7A6DEFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id DEA51C0005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:09:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X7HTDTRm;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=il7lqPYlgoghQVJNZl+xSBhsGwAog7MJ5TbZtB48Tf4=;
	b=ek2BLnl7i+K+bx9Fw8iIoPaYgr+cRW7TbhkjQui9+ye6W5v6qGL1PNZyqFxV1t8Gf7rchu
	ypQwwVHHP+602zGdl3PrbIlVae14Tg1DDN2LHF8+R9Yux/u0MxsEBieKC2+HP5q/Bv9I6r
	GJ8abZfutVPZU5BiM+Ruqe8g699MiiE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X7HTDTRm;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708548; a=rsa-sha256;
	cv=none;
	b=TwBETCSzV//j3CGdhor5cqfchXaIIlz3EhIlP2EHe66JXn7L3+xid2/hqBR/E0tnkuY+sp
	ox+lhaH5dKdYWhjySNwyJCRQBJ3lB0MsyBbtF9LzohOgJy4ylyG0SC+Lxve1lE67Q6KtT/
	MwUPbnZgNaIc/FcrfdhUidBVvtAv47Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758708548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=il7lqPYlgoghQVJNZl+xSBhsGwAog7MJ5TbZtB48Tf4=;
	b=X7HTDTRmBgOAllqFqADZ3YVvfmo1SN7GSD4j7r6QKo/ppVivM5QQp1Wg6j8atlSUIpUxqK
	eT0FoEchXCvn3lZSY1wK0qLUSG5+54Iv/wdZkk++pc9HgLZTu8dXMb7eOdWJDXlS2ZIFeI
	C3C1dESXp0GF/wSMuLoZ5v6WJpnUv5M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-D8bUyEMKMYaK3faqrY9LVA-1; Wed, 24 Sep 2025 06:09:07 -0400
X-MC-Unique: D8bUyEMKMYaK3faqrY9LVA-1
X-Mimecast-MFC-AGG-ID: D8bUyEMKMYaK3faqrY9LVA_1758708546
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45de18e7eccso31589515e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758708546; x=1759313346;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=il7lqPYlgoghQVJNZl+xSBhsGwAog7MJ5TbZtB48Tf4=;
        b=Kf8q7mwTGbx9U670tySh/9nVlA3kHhRLIWJiCKHjdy0hsHJiqMig5x1+ZH+Txt9KTn
         rc1fgoU8aRn5MmrTDsUcjNf8k4S/uRiGYM2rOhx3TFoExv1tAAOT9400x9lGFnrZPKXU
         Vh8B0FY9KmQ9j2ZyUp/GKhiJo77bpGS74BJXrj86YxZGQmVf7SmOIPy2NIwn3WbQHhJv
         7Kgt1HT9xkd61pNkmPAxdnB9TXD0yMkiHr7jS7UGwNvZB0nIP92ZNBtbnwTydXDLTUuB
         ukgyrtCiDuytGvVaZRUsmzoeRcTDnd0f7WkxA6LQXX/orC6ICF+QxWKx2lXVPVsKhw4T
         df5A==
X-Forwarded-Encrypted: i=1; AJvYcCWLmeNtbdk2iX+NcUsa6IXiZ6W6bfSMJC6coRcOrx71rqEmg4FEPl1pULQprM1SyRFUR3cieQJ+Eg==@kvack.org
X-Gm-Message-State: AOJu0Ywv1DGzhrHp2V7RhxIPK19YcrzICPtv07KEzXqaWAy030KBkB1K
	kYQ9uXYscxvz2/ZRBUhvyg0Sd7se96l19hGo0SFW4XqSAJz+ds4SZinifFlTLu1hAzAD60sNZlH
	EN7dNdQ3giC+Rq94EZ+v+Z1Pw0Oq9cC5UHnUEwwwFCLXgZfGH8gtf
X-Gm-Gg: ASbGncuv6UCEemL5TshIsmSljZ03FAouHmSKGtFDNLMl6ua4UN15nnxR0zHpcFKw7ke
	TS2Dz1InzOexwbo+vF83JvlZXoFl8NERqK8t8yEUz7ChlEon420wzp46mjT7MIKlW67vDp6PrVb
	BM9P2buTbyVCcZjOblLKSucJ0wGB+UYXvYfTfLRqT6Yt5AvZe7M1LtHoB0sz2pjrWJnoSVlR0Mw
	6nE0s8i92WNHkDQ/o1X6L6WTkhkaKJ1tndwPrz/urAFGYPRkAseqUrLQQM2SJnNDHRRRrzzXMS8
	New8pgbVzRa5w5YlfEVTelaxzJs+4KCzJbu1n7zW19SqkHa34Y/zCJ6MTlw2hW0UY3ICe693DJq
	lAIW9YGitLVLFeh06l0qog2lg0IH+aeWiuEQYMESWZ+SlVGWCZ8Na2BH+MwjWXO56zA==
X-Received: by 2002:a05:600c:190e:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46e1dab8219mr62794395e9.24.1758708545742;
        Wed, 24 Sep 2025 03:09:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHb/UWjyQ/K+jR0UH6mjTp7X6CxLvDJ7mmWZGXZm/dcX2LF0fMn+fBmi5CevkXi334Hn8RckA==
X-Received: by 2002:a05:600c:190e:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46e1dab8219mr62794085e9.24.1758708545366;
        Wed, 24 Sep 2025 03:09:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2b610cf3sm10737785e9.1.2025.09.24.03.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 03:09:04 -0700 (PDT)
Message-ID: <ef32e31e-d04c-4604-9786-adac33591980@redhat.com>
Date: Wed, 24 Sep 2025 12:09:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, linux-mm@kvack.org,
 Dan Carpenter <dan.carpenter@linaro.org>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-2-richard.weiyang@gmail.com>
 <27storxu4seijr5smul3xx7pofe45ittjrchii3jtwbntalsiy@2cu3wf42drwa>
 <1ebbfe02-1cb5-4f7a-a640-68d5d95cb99b@redhat.com>
 <viz42o4iscxkpxystnikuvfnqzwwfq3anivizgx5dncm4qyqvu@4kymskstues7>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <viz42o4iscxkpxystnikuvfnqzwwfq3anivizgx5dncm4qyqvu@4kymskstues7>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4YR13mwwp0yYTUr1AhEfO49KnyWSUMDB618YDpbIhdU_1758708546
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DEA51C0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gsstobajpy131k8yg5ea3qganae8su6e
X-HE-Tag: 1758708548-572923
X-HE-Meta: U2FsdGVkX188mbXHxzOdcYdReHbZE0nbDL4cEpE7iF3hQZwLoNzVxxRwaVes24sSYwYUxjxY1aUigQIze96i0EjU/8sRyQ+RfQGFdgYMXWVBErCUaVOKjDBikCfHvAYUQTS9/OteXcn70Az3J8J4pVqXlNcvlcAWM10Tu2N94UWaA8xO8IgTO4B3x221ZF6G8uYhxY+LtkBNN6tTYzQ21dqcTnp+WMd5Exsw09lJrxnlpOVFQKkO2POaNNP2RfXgwlVo8Ub20wcqdibkNmzdBIUxeymrfoPojtb3qg9dong+ru9seOJT0wbmvx1NAR6E3KKf4V58Va2PkXQYHvo5ow3en8fUL5X+tRv1/x1pa5qk/Ud3CzDo6S8Vn334x0LNNLKlGFoAsSry3eke+8uqkn0sDTgy2ckj3biBpJphR3E7+jcy+Hi/ZLCApjiDWlWsvVXawwuBMQ97Oa14cvJAzLBUtqrl7vgQ1R7GpHIfrcKHVoAte9s824kRpYz7TvbSqYxs1CtoJoHqDpkbcPgvgbnA2MybS1Wv4xZzYDGNjRMW2MQUAkC3BTPThMyqJ3TpuUtnBFyaAYiJs4F6FNuZK/dgeHm/jjfwKRMEVst8OfFMna1gvspASomO9Fl8URsxpYuLomO+PeP8fGQOK7SUGL/EbzR5YoomQkgjqwKR/5GWmC9400AN04JqSKYjHXhg7e3Ox2yl7VxnfhRaLyYFE74KV1RC/dHleX/CFf2rE9NXc+oq1c6/g+tN5mXISqxAX+9qc3/TbBhY+SMJdfM8cqmV/ONlZya5LKgI6t3fOXPVwXFDXvIJvsG8i+yZq5Xxv1rBzKjuCmj7vhJJu7vrHAmS/2dfcW17QAcZCZgVdI9Ps6P57CVR663/Jtn4f5uMymnkYKyzLtW+CbB42RhH/o3flfkNqOvPhD15cJkDlihNbrz50NJS1RAN9HkzqakvEiS3W3NI0lJ2973qQ6S
 jICodAa2
 P7p2A/IrIoKJb0qoFYDnf7s5Zgpzwe1gj5ESWhvvmLwXdy37bF39sB3ybNAH6tfJ/SWH5GG/OnMQS+JOPbUYnJrOkpEXg68B0+uDK37GsGvQbzl7MTw9AY190WVUFD6Atch5npumu3dWWyn3fFJAmAVAqsK4MZftaK2AHumRzTbuVDCbJ4GUlmZDzHWUMDGXckNf7UWkELJMvFmiTDkiqwbJb3+oIViuDbTIeFPvcjjRjIkmLmgYyAAfOXWyndZDchgkJ2AuAgwTt0JIl9GNXO2A9fU9BMA2Sn4nVWwGmItdxyzB4wa0FuhmVZ0XpXPyv6iZUXyv96Eydzz8D3YOvNaPffDsMXFWS1ZHn5GTofDW0q7iHF5t78lWZsuGriA8tIS2UfzQxZqOERPHzukhJpjAcaalpO9YYUcZTFW+Zyg/m1OQiVSkjN42lEus77rn8CcVomg+jk5rzA/rk0Fy4B7ft9f2C1eiTSvOhEQ59iKCY/hMgPg514uItrVYY61HFCT0999XBKS4vOtb/Hb3BdFLD4GSPj/E0U+ucIAjY8oWNkIyfv7trJe7IDd3HmGq2+ow7Wiy0dFmv2c2SnC11tqtXsbBmW84NN4r9XqDC1n/Y2T9joTGMo22c8OOar/xrKMc2nFgpbv8Z6mBsFJmq+HG+R9e0TcJ9DR67NSARU69HRlb4+tSPgFGvMeMMUCFb7ob1S2SKryLy6L6JJD7ueO1tKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>>    mm/ksm.c | 22 ++++++++++++----------
>>>>    1 file changed, 12 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/mm/ksm.c b/mm/ksm.c
>>>> index 2dbe92e3dd52..c00a21800067 100644
>>>> --- a/mm/ksm.c
>>>> +++ b/mm/ksm.c
>>>> @@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
>>>>    void __ksm_exit(struct mm_struct *mm)
>>>>    {
>>>> -	struct ksm_mm_slot *mm_slot;
>>>> +	struct ksm_mm_slot *mm_slot = NULL;
>>>>    	struct mm_slot *slot;
>>>>    	int easy_to_free = 0;
>>>> @@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
>>>>    	spin_lock(&ksm_mmlist_lock);
>>>>    	slot = mm_slot_lookup(mm_slots_hash, mm);
>>>> -	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>> -	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
>>>> -		if (!mm_slot->rmap_list) {
>>>> -			hash_del(&slot->hash);
>>>> -			list_del(&slot->mm_node);
>>>> -			easy_to_free = 1;
>>>> -		} else {
>>>> -			list_move(&slot->mm_node,
>>>> -				  &ksm_scan.mm_slot->slot.mm_node);
>>>> +	if (slot) {
>>>> +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>> +		if (ksm_scan.mm_slot != mm_slot) {
>>>> +			if (!mm_slot->rmap_list) {
>>>> +				hash_del(&slot->hash);
>>>> +				list_del(&slot->mm_node);
>>>> +				easy_to_free = 1;
>>>> +			} else {
>>>> +				list_move(&slot->mm_node,
>>>> +					  &ksm_scan.mm_slot->slot.mm_node);
>>>> +			}
>>>
>>> Indent level gets extreme.
>>
>> You call this extreme? :)
> 
> Emphasis on "gets". :)

:)

I would prefer to not make it okay to call mm_slot_entry() with a NULL 
pointer.

-- 
Cheers

David / dhildenb


