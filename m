Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF30CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 12:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56658E000E; Mon, 15 Sep 2025 08:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06BA8E0001; Mon, 15 Sep 2025 08:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A79E8E000E; Mon, 15 Sep 2025 08:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 807CE8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:59:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BC2E13B7BC
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:59:33 +0000 (UTC)
X-FDA: 83891491026.18.CDD4891
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id D2D31120003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:59:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NiruaC9C;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757941171; a=rsa-sha256;
	cv=none;
	b=6eTNuoQU3iILcxSIFuMGXiZOKAI37mSapKYcG05TKZXWw95JGjEZEgJwtJQ/tJPzjwc4di
	MODYxpUQXEwRKV4qdvi8QRK/sn4iRqFA3DzloDfFicZ0RwEwetr6QC5/NYdQszU6QgOza8
	b1mw7Lv5P1/MTFUcBhYp2b1EA/7T8a4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NiruaC9C;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757941171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9AyUt4haocv7F95i9a+JlLpc0x0YT4r6qftqX3qLrs=;
	b=Kv7aJA2i8JcXaCA54UJ5PFWMJ/KozU9qkDxjge/NwGWBaim+cs0ENRVxnpj41dfkjdebUn
	zhdkx4jicTmJMCZHZfYmP0pl+9vfOi/hL2iveqaSAA/Nv1ARYGDFYBNmQBqMD2RtDnO8xE
	IDtCff9YFi5huTfgviu4esMIKNSC3Pg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757941170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z9AyUt4haocv7F95i9a+JlLpc0x0YT4r6qftqX3qLrs=;
	b=NiruaC9CsOz67LTVNjFTfwqwrMlWRIOHIGK0QvYqdB57wxlDZJMap9sdUtfwC1z6ATwuT0
	WtUJ4Uj0IKvS56okyjFk0v1GfyXqql6Ql39DGqGnh51UvVA43rEnwzqzR45V8EJxkI5Fvc
	5Lf+k4HCTUkljZzpRt32jI/YEwXBV4M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-UQxhjPs4Pm6V6Xe2tRNDVg-1; Mon, 15 Sep 2025 08:59:29 -0400
X-MC-Unique: UQxhjPs4Pm6V6Xe2tRNDVg-1
X-Mimecast-MFC-AGG-ID: UQxhjPs4Pm6V6Xe2tRNDVg_1757941163
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45f2b0eba08so8037565e9.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757941162; x=1758545962;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z9AyUt4haocv7F95i9a+JlLpc0x0YT4r6qftqX3qLrs=;
        b=YkIO60zDsvbpBrqZE6+zWLofJuwQP1NmXmkaATqBhwWIjFbkexMMQAR7jJgb9ofIFO
         enom1EHKwPFGd4+73UQCGLYNmDEbTpmYHtpbnbh6kbKcqszPkpMpfTJGx4+LDK9pORcc
         gqN4iZPYt+Mk/X0cZ7camDhK3ktWZW7U/vaxmTh/yyC8H+RUmfyHseXH7GCdrX93/wmG
         yY5F3pkOY70aT/GhldBuXM4rDz0OW6BHpKahXV+s2SOyBtSedDRAIcJiw6A3j/5ZA7bp
         lfshIQtvP6ZnHk49+gzOVTjgQR0lQk/iWypxvZ0bI0xo/ea7oXhv0wWAocBplfUnh6i0
         57aA==
X-Forwarded-Encrypted: i=1; AJvYcCVfDfS11xbviHIfHlK1fskF0ORnBRKhvmoNd9HzG9VmxW250DEuPpMEQV55JR+u81HsI9Amub7ywQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+074yr4EXFG2Ul03V92qNSjNGBQd1GxdjRrs6FhmAS12ysac2
	ID+VV1fz5+wTzeDsg8gdyL8Atlswm/ICsezODCaoNZpyeyQI/igZyUV0ALM1ngAVf8d3/RWx6Vc
	Souc/pzaCkSIirAx00y6t7UKznULThOU76wNuExshnmp/zy+7iKd9
X-Gm-Gg: ASbGncsPTQiKwVqZcBSkY4SFFJGluyAp2daypryb++I2wLdwnFoqeABk6UCQNEzdlw/
	OQlOdZMbAEpflEzfpgcvZwTWBMCEcazipe1z6uIjYuDQOO/RwnMpLrfo/pLhbJmeKWpiJ4V0Jgf
	MGb0TmFIBJpJ5TzGrPKMTbwXFSW0ussrR6mP4fjLa/RolTdS4+t5XYndHGImL6FV0zkNjf11eku
	y1VmT1G2q76OcXBbFG22Ca2n8q4dI79AszFKAbYma56t1kfnSeMDB/4NE5+Bas+tKGvuzDi6Uum
	mhJdTdJj0SHy8nczeqkef8BN1sArRKJXNemOSoXJqedTywr0BogWNWMJYdlCLzq3Y6DNVg/stBu
	u985QKpvY3SLkwMjj/GqhIaKNE+eznt1k8h6gEyveZzIg08wipaRpjXNsjEKa6pCtme0=
X-Received: by 2002:a05:600c:198f:b0:45d:db2a:ce37 with SMTP id 5b1f17b1804b1-45f24df556fmr95539135e9.0.1757941162491;
        Mon, 15 Sep 2025 05:59:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKriu8iaZGvf/bFu9nYRr4M1WXgTzDA+G+Qti4ilusiGCyEBdwFxvpcMyyGZ5HQLQRNLOcSg==
X-Received: by 2002:a05:600c:198f:b0:45d:db2a:ce37 with SMTP id 5b1f17b1804b1-45f24df556fmr95538715e9.0.1757941161998;
        Mon, 15 Sep 2025 05:59:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e04cf2870sm94355605e9.1.2025.09.15.05.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 05:59:21 -0700 (PDT)
Message-ID: <2af510cc-8173-49fd-87b7-a6f9c59bd104@redhat.com>
Date: Mon, 15 Sep 2025 14:59:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Nico Pache <npache@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <CAA1CXcD1BhXqYM7oOTLuqPHyWSztdCEk462sYXFXxJCmOpe_Rg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcD1BhXqYM7oOTLuqPHyWSztdCEk462sYXFXxJCmOpe_Rg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X5WO-RENwUANdO5s_J3x6IHnPwbHidgC20_dmf9Jp8A_1757941163
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2D31120003
X-Stat-Signature: whipj393zej7gfh89yd548omaucae7zr
X-Rspam-User: 
X-HE-Tag: 1757941170-631259
X-HE-Meta: U2FsdGVkX18vlMiSWxqOhAzjfMT0BrThB8eqvD6byUooXtQ2vgS+nYB3sx9fNUX034hfieTsqP+ZO7mvIToqgWNDb4CL4yDTmZYbANmQRjGUCaMCF9tnrONYMWb8InmsySsu3PAI82xgbqeqYpYLBMMUXqY+cJC684Q/zm9ZDwADophVY9UNH+rUacN/Nrvga6GggHJTGvUoIcv+LggJazAZ5TQ2EPZ5cfMFifd5Ld9VcIb4qNeWRV1zKKG71tkNqYEyQ+oNJkQ25wZ99a8TuOQ88m0IwodV7y60lPen7ITIyTy4OaaZVKnKxMjtGDv56ZcomGlDWPlSUDMLBLuCYZI4Omh7ksmraEoXQeCtVXmTPWlXhryq1nIGzFVlHqdFRGiAS7J7FWCnkDcFCGi0fJCecWrDzoR3Zvc56J1pyTvk378dr0xzhHiCCSEgJJ5DW/gLe8T73gaZGhCvkea8pqyUsQwrvCNzcRHt8VXbU/kAfs42q8sx1wAu6Y6NTW7K1ib2VGETx7BFLo2s3ft220BIo3vvcami4dCfmXGOI10FtC1qPDRN37AZnmusjbm+6C10rbiybeyQUPyWo+lfvEticEaBidtMkJr22mf8qb1pTcN07LP8NObtRz+E1qb8nTFjTdTEo2zUpHolEq5axt1cvGHL7uN7ajY0s3P3v6Irr8ztzGpgOpNSRfwUVHWeFsA2MtZZm69B3VleRCFnhul9V2ihRIW6nXBf2cE669prCSnb0LyFqakzOJkqjSQH7iwybMTN909jzDmeuTdUsjujAk+1dBbAZqjjDVj2sexRoi/46oIFC8Aed4eqzXX0PfG+Izi6QUlAhbgPzh2eFGoEGHuqFZUpXt89vhBY5yoLCepi+oDh8vCeD+IBH368ZT9m5oRawGk058/AJKxsxODxZV8jW1YIAZBJk33DHBQ48+8ucs2YJJ9kWZjVngSxm9hxsCC2KY1Mq9Ssz3T
 2m1XlC+C
 TArD296IyxngU/lgcSJ8jy9FgRcZQlRUNAcZdVtRl4Ju/24a7Lwip+OUQL0sp2d2RJZ46SwiregSSvwAX8Mippy4/Cm0fMZV62LCBA+Wi0VBU510fU/RvxdVLmup6H68Ody5z+s7qWjHHdDwslpOt2gP269jiGFuy9r27SpCDiKrmSPmMJSr4rWYqMpV2zx/htTKtKi6WTg8qW8fTRCnJiSDREAb5s2DXyuh7xyNKtXBT3tia+kilHDxor7pFdDczgdt2ouCESqu46eTySTI19AULVXOqPt7ASQ4uZrjmoTsPSMH5cMbSDpraKim9o1Ti5mjbNupOD+umROpYxVg1PiPvtshMHL5j63rh0z+FSduGFPos1abHDnEyw8I/zECMEBfvPQ7YCPL6PjrYRtltdnf1p0vyHnE4shjaz2nnTMbMRDBcmtz1EOB37TzuGdXBYj047buW1sVGBOwT2iGd5CG/uAsK6Wo0th3Gb0HgyPUlxTYnSG+AuHq2gA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> ...
>> 10 -> ~0% used (~100% none)
> I think this scale is too specific, I think it would be easier to map
> to the one above for the reasons stated there. There would be little
> to no benefit to having such small adjustments between 4-10

It's probably best to discuss that once I have something more concrete 
to share :)

I yet have to think about some cases I have in mind, and once I figured 
them out (and had time to do so ...) I'll post something.

-- 
Cheers

David / dhildenb


