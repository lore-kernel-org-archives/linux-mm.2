Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F17CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0DF58E000B; Mon, 15 Sep 2025 03:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEB18E0001; Mon, 15 Sep 2025 03:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADB48E000B; Mon, 15 Sep 2025 03:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 985888E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:42:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A2E3B99ED
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:42:36 +0000 (UTC)
X-FDA: 83890692312.20.DD0ADEF
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2E7CA40004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:42:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LlQJnNYE;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757922154;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dU39viXD9o1Vds9b/Q3cia74+JnHatGhLBFawrOwC2g=;
	b=KUnUoWfAVxW+G559umTuyJWej4I3IqdgOVzy6VG5+c12esof8sggnchDExCTta2LXw8zTh
	WQzwbVYcHNFxsgY1DqTdvD0LRDcX6t5AkxUJhwacWfuIM9t0t/rWREoKwvgevQ29A6hZJV
	oQ97b1EtRwI+OCxBHyqirj1XOtXpvRQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LlQJnNYE;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757922154; a=rsa-sha256;
	cv=none;
	b=YWoz1NAZ3iNlS6QXTw/uYdDuHneIQeyW1BSzqbOH+LVbMSdNicxVUhjxbKExHPV0bQc2vX
	CI1msUsZ6yKoaWeYFXEpoqvKnabpueBFUOuQCBkFMsahmTB6mRc2DP/Z4KujW118ITD5xL
	isalyY9L/6zgscOYgYfNJCG7aa+WiM4=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b042cc3954fso694012866b.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757922152; x=1758526952; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dU39viXD9o1Vds9b/Q3cia74+JnHatGhLBFawrOwC2g=;
        b=LlQJnNYErAear6PljdXLRToAPmuXQDO481ZMcDnJlhlQ276T22jGKbSDev6LargT1V
         JR5GRI4wOph8mHxz/h0cVVSQWII6WjuhMmDYmx6Jn90s/f0REX4ycQLVmyA0r9cU5BIg
         lr5zUOel8kSGIld8IPbbOc2KAGDDddE64v/Y647zYspjK66Kjau5+SIEvg6kAypaJ3na
         x3QBA6zkpcf1kBGW7NnbaYTPAMwrU5++gIuD2TLVdQkN7LYjLFP7X08+XN4A5BLMsxjD
         njh363qb2X0l3qYbjp4scvHwIxoWrKdBwuEPmtQOPwXLwzgK3O1m/YQs2xER5Ip1Rl5m
         yrUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757922152; x=1758526952;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dU39viXD9o1Vds9b/Q3cia74+JnHatGhLBFawrOwC2g=;
        b=IMv0/pcprdK/NbUyKbwJkb/oFnMUsgV6UQ+AO/rNWgyfBL6CSxmXzsRUCvo+QED3NG
         yo+LOfZ9MFPQ+++z4DEJm1Mb++BjWvZ8wktUWCnrW33/qnoF8eIbnH/jddTc99ttZOd0
         ZjD1TWOdfhGsEAMT5p5jniZFftOiN0ZhSdw3507uqameEk6/M2+S42mcex8XiJcTSthV
         KggcCQQEPBXZfVo3/JYsCcDaMKPhQuQH92z6DwAM2FRuvw/tvyYTIwcfq/yGVaUQi8T1
         KcGBtcJkO42vsIq+m097Yufqui9V+swn3Uk0+MG0iZUKR8bwWmQSCJdWOHyiNb54UVzs
         Adxg==
X-Forwarded-Encrypted: i=1; AJvYcCXMp+CvkymuvMvpLFHR5cWIROfgozo+e4z0RvI1DFeEfEwvfGjjbRKNPc4JU7o/qsBgQPcDfr+L2Q==@kvack.org
X-Gm-Message-State: AOJu0Yxk/f+xbkNNROJmsTn68aqOy+3qfWP6EZcY4DNi8ptZgpg4LEY9
	GpkkYCmZdMMiEB50ZRXTr12rXLFaf4xwm/CUKp7fgyMTzmeQq1NTNppu
X-Gm-Gg: ASbGncu4bHVqLGHQsOUvHWi1W3YpslIueTaSYs6fdfPPLR/0xOA9zScUKeq2dyNdqV0
	/THucSERnMRxIgBX04H6Phd4lAwZmyaDb2Nl/sUd2ICgnJUFtncerNCobxeMo9t+xaFz6OGn6lp
	40KoQbWii0q9/guTCPE+6uvYQe1x8W4au1f4yErXYOE9NLqQEfxjeSLE+z+YPLips08AkIP/RDr
	0Y8TPGdg7QhKxo71oIxG+GyxDfWngfIemaOrlK2o7C9VpzEIdDHgHDQfUk2gJyRCxcQBIjE8jN0
	1ZYeZ//pfdP9xYltn7IeuaqMDQ2rknpMTicWs6NhkGfJjMSr8esmUSlLh/z12QG0u5LPMaKx/Mw
	VRxWu5qwYcjVjgMMvz2PDGJxPS9cHGigf
X-Google-Smtp-Source: AGHT+IEkTEqk7ovUaAeG8O31BDNJk+nacYF3ASrLEXOOif+lNEKszX2YKu82m6jZoE3imLYpI2xgdQ==
X-Received: by 2002:a17:907:d08:b0:b09:6e9:cbac with SMTP id a640c23a62f3a-b0906e9ce3dmr787398766b.56.1757922152333;
        Mon, 15 Sep 2025 00:42:32 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07c59a963bsm703494366b.42.2025.09.15.00.42.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Sep 2025 00:42:31 -0700 (PDT)
Date: Mon, 15 Sep 2025 07:42:31 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org, chengming.zhou@linux.dev, ryan.roberts@arm.com,
	baohua@kernel.org, xu.xin16@zte.com.cn, dev.jain@arm.com,
	npache@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Message-ID: <20250915074231.xnjzoqozqihqetwm@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <3a1adf4c-9931-4cdb-a024-37c856b1702b@linux.dev>
 <20250915014738.slkw4nwihb4aavas@master>
 <e368ffcc-0de9-4c8c-8e9c-6cbf8cdd22ee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e368ffcc-0de9-4c8c-8e9c-6cbf8cdd22ee@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 2E7CA40004
X-Rspamd-Server: rspam05
X-Stat-Signature: gi9aogsnrec6d4ads69971gcxwpx7mej
X-Rspam-User: 
X-HE-Tag: 1757922153-636896
X-HE-Meta: U2FsdGVkX1+uCTa5XRdtk8oQ0bvMVb7Ds+6wFwkxeMllu6wwsI+rJeda5qeLiRcfUG97W/4i8SvEGSPl6bYGITl9APenp55SDguuYjtdFGWKgX8Oj9mf5b2KPIf46lbNqoLF0s4aGR08Kay7eIX3KlQp1q+zApKWe3GzQKkgFBolI+PpdNmpttBE37pol2Zp2MGcOQzAvgawc5jVdW8imYtZxakufSksYywaFiV6kw6IgokqoZvCvoA73cDo6h0mPH/5+2thjIwK2nIRY6dbnqM8E8/495Kgc15r0o3yGpbbsKe/Ehc/+HyoGpoD7OIxffJruj6VPYp/3eTbYc9cMDYDk1RPs8+spGnAJZJDZF/SH6v8ynoA66IMnuCtf3m5nor78E2jRr7wALgKHmUhq6U39udK0NDUGY6hW4PHDOf76Laik7ryIxKUnvMVsaIZVcOQRSzeqjBajbL7aVtI6YD2jfts74azJbsCKVmyjrWvBY5xRnC64J+/fiZp9T3FLvMlm/gQp8kV5Cnb8e4tx5VlyYWyl6f0ou6t9hlcMOZKTt9Im+yVe+JL8kV+ljcM0IOZ/N+3lCxnQ5zCjYGJ9Aoga7Y8tWbhb3zcfXSsTuyCwMsc9xvfkq2NdBKlOn/h1IF0x/Te5cWZMw5dKXbdVqIt7PiUyAx/QmZtcrrt9BqDrcX/A2HOP6/KrpqudlH0g8A42RvyzYrwnsC7erWzjuegNy9qvwp0frFLkNy/EZxS3E3KL6OU7Pgy2vb25s8xEYfmorwJcFjof7hVNr9INGOS993q91dLev+y0stSbyAOs8g3GyDEVkqKvAT21qgc3b43ZDqiJUsHXReZAEwuo2o0CnmZq6mYAIJ8fp2KRSUizi6C/QQruO4BlDA/Lv5QfMxhP6cOMIhgdBuzuKZ+01kFFsw51DsGsGJtFWFEIK0QXPA3Cc7K242c4FwAworLOiZsVhY6boTCd/NTSyl
 1ptPHYCB
 v+y0vUyZxyWpHqMu4cvdaIY8zSPSKRRu8dRXYaaOSlogxgiQvlDb/kYD0AEiJ+8SSvZ0FueUuume5HLocAkTTjmkqXlsHXq5A3F6ALIlpsSX07/IZMuI8lX3EBzY9lnZUsZ0Lt8xCz0I8nSV/VpKNPweOfzczUWoSypnJOAd1Dxwx+X5pCmimLYZOAl5SiSnLAzHskKbtPcPxXV6GQcJLGosO5r1Ase29s8cxG4Brw4sOXHB5QGmxOrnLb2C79Dvjrwp7FfKrvzAy2bQ3W8fEkiobe8mzTTxhU12BVUaUvvATKtC2crABpH/FJeBDJct4Y9mGERushMqz1SmFidbRsBNIPMT8bcDTbNhsVEbd7PFQMsorgAhZf4lLMjWH6VLyumwUeuCOiVZT2NimITnUc2gG2MZ+6Wsx0ewe795l4NalbQMXhLokpFvDBjj7xHdbSB+7sEbWgSn7fyniIdmd8m+JStdrjWXD6/xwGVkFGbKnIw8+2AWfBKOGjvThVQTw5IZnXief42DTczP/8yXy9GG8Ya6jd9WnZ03F3hSfXWdmoz03z8EHlEf0JgUQtdxdUdqjneU9sTDQfWtLzKjcKJ0H6d0wNJkKqZTrlRISpiBnG/bHHf15p4kkfBfMYGfVrjdZgYly9L+eBlKxVxMmQnk5YHloVeVktlX2rNkah/HlS3jq/J3V/9uHGkecUjxH+QQPEI7ds75qN/qksBHCSpkMcTQntmqdX5SNpZx8p46GpKfE9Z3VdziCXnOWNSTyTzKYnPlKrbvXVBfdPXjhv7GWBJDLzkRK2z4sjkjjkueVe9JWlfpr3v7fww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:32:27AM +0200, David Hildenbrand wrote:
>On 15.09.25 03:47, Wei Yang wrote:
>> On Sun, Sep 14, 2025 at 01:05:48PM +0800, Lance Yang wrote:
>> > Hi Wei,
>> > 
>> > On 2025/9/14 08:00, Wei Yang wrote:
>> > > When using mm_slot in ksm/khugepaged, there is code snip like:
>> > > 
>> > > 	slot = mm_slot_lookup(mm_slots_hash, mm);
>> > > 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> > > 	if (mm_slot && ..) {
>> > > 	}
>> > > 
>> > > This is only valid when mm_slot is the first element of its wrapper
>> > > structure, otherwise a NULL slot would converted to a mm_slot with
>> > > negative value. And current code thinks it is valid and continue.
>> > > 
>> > > Current code works since mm_slot is the first element, but make sure it
>> > > won't be disturbed.
>> > 
>> > Good catch! That's indeed quite brittle ;)
>> > 
>> > Just one nit below.
>> > 
>> > > 
>> > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > ---
>> > >    mm/khugepaged.c | 5 ++++-
>> > >    mm/ksm.c        | 5 ++++-
>> > >    2 files changed, 8 insertions(+), 2 deletions(-)
>> > > 
>> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > > index af5f5c80fe4e..668e74ad33b7 100644
>> > > --- a/mm/khugepaged.c
>> > > +++ b/mm/khugepaged.c
>> > > @@ -108,7 +108,7 @@ struct collapse_control {
>> > >     * @slot: hash lookup from mm to mm_slot
>> > >     */
>> > >    struct khugepaged_mm_slot {
>> > > -	struct mm_slot slot;
>> > > +	struct mm_slot slot;	/* keep it the first element */
>> > >    };
>> > >    /**
>> > > @@ -2382,6 +2382,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> > >    	struct vm_area_struct *vma;
>> > >    	int progress = 0;
>> > > +	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct khugepaged_mm_slot, slot),
>> > > +			"slot should be the first element");
>> > > +
>> > 
>> > I wonder if this BUILD_BUG_ON_MSG() in khugepaged_scan_mm_slot() would
>> > be better placed in khugepaged_init(), like you did in ksm_init()?
>> 
>> khugepaged_mm_slot is defined in khugepaged.c, maybe we don't want to export
>> it.
>> 
>
>We should probably just use a static_assert right nxt to the struct and make
>sure that offsetof(struct khugepaged_mm_slot, slot) == 0 ?
>

I am ok with this, but Dev suggest to fix in the code.

Hmm... both works to me.

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

