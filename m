Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65638CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FAD88E000E; Wed, 24 Sep 2025 08:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB968E0001; Wed, 24 Sep 2025 08:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899AF8E000E; Wed, 24 Sep 2025 08:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76BAD8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:19:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AAF05A270
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:19:45 +0000 (UTC)
X-FDA: 83924049930.06.D2B6EED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D22C4180008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:19:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B3pFtyCf;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758716382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feDlKVbgflPMvpEdG3WH6y88sPLD5tVALdfsMXcoOyw=;
	b=neRQucACXFAVcmDEqcRtHrg8yclxo0zbWxMhSzDD54zHp4LpxQFuW7fz0Ev6abiJU+RYw5
	Gv04I+2quvFL5fJr5TYQ7DxgpiS50Lexqi1ms2UtboVgV2r7cLbcmCoUsw4ZiVEG9LAFs7
	PaRwk14640ZbeVaQ7EW3Df4lW0jQhKY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B3pFtyCf;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758716382; a=rsa-sha256;
	cv=none;
	b=vPR19QYG0CEVGtydrkpaAZ8bPtMBgYv5uG1NZ0ASWuzh+Eor14khB8ja3gtVctEIAbtDxH
	RBN/LBRAVT4NqVW+2oWbAGx6hbll2X4MaQzLoUqLd+kpQWSgjn5BOk3/TTgL/yGkGM6Uyr
	PZUMDNcIpN4eio0DdGFnPGm1ij5x0ss=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758716382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=feDlKVbgflPMvpEdG3WH6y88sPLD5tVALdfsMXcoOyw=;
	b=B3pFtyCfVsHd3BNv1sFiZCkCDwlXqJfU9rvLRvET42R6Q61aBJXfiG0b4ulfclDLgUM7It
	boL8SIVAOJK4Ji34zaCyL+gwNtEIMYLFS16EaDkh+KMTDXdFbWscaFjXhfzAf3aTPR+d++
	4Ie33uP/7eD0JDJTIgyI5CO+769oJUU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-LIW_Ze4IMRG_WdFkP1p67g-1; Wed, 24 Sep 2025 08:19:41 -0400
X-MC-Unique: LIW_Ze4IMRG_WdFkP1p67g-1
X-Mimecast-MFC-AGG-ID: LIW_Ze4IMRG_WdFkP1p67g_1758716380
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e1b05b42fso18588365e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758716380; x=1759321180;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=feDlKVbgflPMvpEdG3WH6y88sPLD5tVALdfsMXcoOyw=;
        b=n/dxw/5tvBI/EhD2gs8mC7+erjmrg1dPgSvDO+D8lnQJ71qI5/COoNT6Ubs3VMzZbW
         EKO2FqVigMvrF49jPf72ObcfoIak7/JgE08k+sAaBrorOuMlFTq87wpZVDQunQdsyiGu
         PuAAG1M5gKjxrV33WGWkPvZAsAyygO5pzW6ZCoHyTW2urXGlOXkYb7JeKfz5iiWnJC/g
         /EBke3DBSKYGdYEnxq/wfdoE/zSE2kYqO6jrYxJhUBvnI9GM2/aVJpzAwzgAXyG1BBrU
         6dtU/Cm9EQrjIPlwqQdmk6/P77Rbc7ZJrSm2G0i/nu5/dAF11+05dIbaJYs2a0SJggmD
         7bpg==
X-Forwarded-Encrypted: i=1; AJvYcCU2OxxayDCEjEelKrDdZRU15LTR33aklOqv1Cnn8LHKvfx13/RhClaO+mRqGvm51dwMlHdBvN5alg==@kvack.org
X-Gm-Message-State: AOJu0YxtDSMv21F9AkyRIkR9knVLDn5CuBvOfMfjbZZ7F76v9GsFBRbo
	bLgDYl+1253QzH8xFSefvOgInrW4cj4Gl7biENBHoayeR5+ltyb6L20KKRg7P279uve7V7lvrGF
	LpLabBLXGutHvWwEF+Adt9bYAh+toNjSBjPrRAL2CQ+ilgUuFjyzT
X-Gm-Gg: ASbGncsjKJqUQiB26JwyDLmQEdnLjPkXOcPxpesh0IwwUeZznHMRvLP1yeluNSL1Xxf
	K9JEVq+ALEfwHVBZCVv/DxwI3wNfVTo4brr+/NHj7QzrScnfjKl1jCb9OJIiBbGTpvM0LqCc1Lj
	hNhHBRLSjxJUz9C7RG93kildtGIe2sIVEHQ6vh9+zHhMNiTSJ8QXy72FCqNV+lzjVXzm7j8BArC
	Bj7ZHv5UILxJE/O74sSB+E3qLEe/JU2RdLkC7tQ7pYGnJUpElY3GeWy2ueshbW5ug71dAUS87b8
	W5jlgG7spEr/rt38xFpQtGXPXfBYQUh56MYA/s/P71pdEY1BoZz4W54PW4Q9P+lPtvDMfxzn5F8
	WO0pGRkuEMdaJ+NFDUkajp7hSC9p0fSvlMx7WD2X2Pg8rNg7TpkBDz8kZ81FcnXl9cQ==
X-Received: by 2002:a05:600c:3152:b0:45b:7a93:f108 with SMTP id 5b1f17b1804b1-46e1d994a15mr60069115e9.3.1758716379814;
        Wed, 24 Sep 2025 05:19:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEa9IXF1wic1pJNoA+tWLDZ5nJ8EnruIbFXPluMJpZpYxM/3/H6dzQE0agUT2hz7mpTisDkpA==
X-Received: by 2002:a05:600c:3152:b0:45b:7a93:f108 with SMTP id 5b1f17b1804b1-46e1d994a15mr60068765e9.3.1758716379370;
        Wed, 24 Sep 2025 05:19:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407ccasm27885367f8f.15.2025.09.24.05.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 05:19:38 -0700 (PDT)
Message-ID: <d21d6cf4-404c-4a28-aab3-03974eaf806f@redhat.com>
Date: Wed, 24 Sep 2025 14:19:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
To: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
 <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
 <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
 <760C8EBD-9201-4680-8B9B-CAD7641A81C4@nvidia.com>
 <aNPW4Ynrxyn23Ko8@tiehlicka>
 <81a827ce-24f7-4038-bca7-c96dc558cb38@redhat.com>
 <aNPdkABVUvJESoqm@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNPdkABVUvJESoqm@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JKXeaXLNDZtGvl9dcH-8B8BeAZ9Y3vTk2SmWOwke__Q_1758716380
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D22C4180008
X-Stat-Signature: m4wxr64xictw4s5q1n36ybms8em93au1
X-HE-Tag: 1758716382-567283
X-HE-Meta: U2FsdGVkX194WG9wblBg5AFhbrN9cT6EMWDA348y9GM+78qdOmT3yXM/+Gi5tRdZjVuS8cNDbAvFFlTiRbmgZtfpfVwucp+N6HuxLnZsxi6jjnY3fZFz6BltN2ivCsyImKvuhtOLwdqSqG/V/M4bRwko2vFP27nDYuuMAu25HYgH1Wmz+ArCbV5oBE7RuRJWSWXR9Faj3d7udE8+6h4PzYfZLzHjZZDzgIUQim7yhDX7/kWvWltWCSD5CyQiA15QOTZDfZ58Pa8mRMtN4wdNxxfgnWh6M2pHOLh+xL9FW/F0F02EgDY18eofibH8+2LMSFnwRCkDtqfRQelg3YfWF7x87717YCF01edI+DR20ICJ0d+mbiQHDh/MRQEi6dm7ewJe37O/kIvhVXwW+cQf8OoAO1+xBfTyA41RUJYuIWZoTtbzfz1iuS+/U+YChX4qgFWXfsWTnhBKGDVdpzGxy+Mu+vOcN3B6y7zLRHpqu66bUAsIjP6YMTyJxHZtBtrp8QSeeslZHHMEnRmJqQg/+c+F5AVEOXqLByj+mgKgq5J+812vGFvhf3Dstonl/forfNfsXEaOe8PkXF3rtYWhmk8+Ep+Apmj/kGV9Oe0htOLMSQFPBEpE2Elv8aNqHp8tYFUnmfT7Y3ZwXNuxlfsNPcIpMls4DOPTHzprDlrpu3ryDqIoYwpXyTM+MNMe4MgzrunSv27h26Q0zqS+EiJ/GNfiLBrALj2yyZ3U0drwFa+whX0PvkA54NymL23cCQUaESIQgHTdRzzDxMKi5wcFWJiSvKkKSm6aSmCGUK054g7ug3RKasHQHaJTT/PP/rBKvG8hTSafN3rYMrmuKXIaJRS4z5cG10ZWzxk+/J/TokThlabiyZDLiW9nmlwCOd23P13mO62IjoYCqIU9ufX7hTJHqfRkvRGe6LYV0CtPCSMpFxCyl8hZdAOyz8NkQNED4MJYINlvYs0Kp/VjwTX
 IG/e/B7r
 J0tpxEw7Lh7obXXpJQhjqd0LJAZG56MsxQyZHuxcY/zjY0lJSGA78lGbVYqbp4cHWhf/1iyeJiZRXqo7xT8S+NaK0zQIQdvcvXQoMs6++8+7C4XJoPM09iNRVNKiWzsOb58HMmz5wO3VP4YurjjCT4K+9g9ZpALYjiigy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 14:01, Michal Hocko wrote:
> On Wed 24-09-25 13:40:58, David Hildenbrand wrote:
>> On 24.09.25 13:32, Michal Hocko wrote:
>>> On Tue 23-09-25 11:07:28, Zi Yan wrote:
>>>> On 23 Sep 2025, at 3:48, David Hildenbrand wrote:
>>>>
>>>>> On 23.09.25 09:06, Anshuman Khandual wrote:
>>>>>> On 23/09/25 7:16 AM, Zi Yan wrote:
>>>>>>> On 22 Sep 2025, at 20:19, Wei Yang wrote:
>>>>>>>
>>>>>>>> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
>>>>>>>> introduced generic method for alloc_contig_pages(). But the alignment
>>>>>>>> calculation seems wrong.
>>>>>>>>
>>>>>>>> Since ALIGN() only accept power of two value, while nr_pages could be
>>>>>>>> any positive one, the result is not defined.
>>>>>>>
>>>>>>> The result would not be any value lower than zone->zone_start_pfn,
>>>>>>> so the worst case is getting an unaligned PFN range. I guess
>>>>>>> most of the time nr_pages would be power of 2.
>>>>>>
>>>>>> Agreed.
>>>>>>
>>>>>> Also as Dev had pointed out earlier, this function gives no
>>>>>> guarantee on alignment of non-power-of-2 requests. Hence I
>>>>>> don't have a strong opinion either way, but does it really
>>>>>> qualify for a "Fixes:" tag ?
>>>>>
>>>>> I'd say if there is nothing to fix, then this patch is not required.
>>>>>
>>>>> What likely does make sense would be that a non-power-of-2 would be aligned to the smallest contained power of 2.
>>>>>
>>>>> E.g., a 6 MiB request would be aligned to 2 MiB instead of multiples of 6 MiB.
>>>>>
>>>>> Not sure what the existing ALIGN would do with that ...
>>>>
>>>> Something like the code below:
>>>>
>>>> pfn = ALIGN(zone->zone_start_pfn, rounddown_pow_of_two(nr_pages));
>>>
>>> Please let's not try to fix a non-existent problem here. If there is no
>>> alignement requirement then make sure we document it and drop the
>>> existing ALIGN which doesn't seem to serve any actual purpose rather
>>> than make the code more subtle and more obscure for no known reason.
>>
>> I think we need at least one initial align because the zone_start_pfn might
>> not be aligned to the desired order/nr_pages.
> 
> I thought we have concluded that there is no user expecting a specific
> alignment. Or have I misunderstood that?

We concluded that for users that don't pass in non-power-2 requests.

hugetlb->folio_alloc_gigantic()->alloc_contig_pages_noprof() certainly 
expects a suitable alignment :)

I'll note that if no alignment is required, the whole loop in 
alloc_contig_pages_noprof() is not optimal, because we could be skipping 
suitable ranges. But I guess nobody cares about that right now -- and at 
least it's simple.

-- 
Cheers

David / dhildenb


