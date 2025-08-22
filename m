Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B924CCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 14:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF59E6B024E; Fri, 22 Aug 2025 10:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECDD68E009D; Fri, 22 Aug 2025 10:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDC36B0250; Fri, 22 Aug 2025 10:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C870E6B024E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:10:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CCB8B6E52
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:10:48 +0000 (UTC)
X-FDA: 83804579376.06.D015ECA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id EFCEDA001B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:10:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eBxixElE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755871846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4Sy5j6GyLKa/6POtPURBhOkK7kt59z0IbjXNHFAuis=;
	b=VwQbuzagCC29brGZQqAydf0TrPAAgyslFAtcERH6QOiN1fcCHn8r4iFBmaysZN9+VMrBQA
	7AjSLdVtLNOrnh9KnCQwml8rQxMk0pAK5oL5JXr9veWONHmWfIDpJM32KdkXm80+sdPm2X
	2RY0q96ZIkaOEkggPUCNh3uPgHWmbvg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eBxixElE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755871846; a=rsa-sha256;
	cv=none;
	b=kB+IZ4pXD5TIoXFVs5bBjrsuMXthVt8K8jwIq7HvUOG+sNUqQc6CA/gzbDG8KKlU4De6A4
	kTc95rTydpNf53LHmbpNCABvYrqf6TU1794Vaj0wAxRE5sZYRr3Ct01uSQPva1s4bs/g3c
	erv+VF+5++Q+2kzU7xp0P6urgmVgJSs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755871845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y4Sy5j6GyLKa/6POtPURBhOkK7kt59z0IbjXNHFAuis=;
	b=eBxixElEZJAnJOVcO9zIEHfhpXF4JnyRILtouIOMZ6IogWHo/yHc3UHQVoj/wUwujVmCvM
	9nc4rpR0y/FdASef0WzcPqVQZD+6rJ2Qx9ic6kIKET15nWcrD+vTUTgDydNXkJe3OvlDy/
	rWL7ByMBC4JFxLThrchrLw2455TZjf8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-YeJJ8RXANG2XPz0gvFRi4w-1; Fri, 22 Aug 2025 10:10:40 -0400
X-MC-Unique: YeJJ8RXANG2XPz0gvFRi4w-1
X-Mimecast-MFC-AGG-ID: YeJJ8RXANG2XPz0gvFRi4w_1755871839
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9d41b779aso1294439f8f.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755871839; x=1756476639;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y4Sy5j6GyLKa/6POtPURBhOkK7kt59z0IbjXNHFAuis=;
        b=I7kHF9Xee51r9xoqNIHj4BedDwSp1NkFdjyBGbapo3PROfHdN7U1GJeSAC/oTMuZcw
         eCMvuCZmQH345YwA2wj5uahi0lt8Cc4puYjcPzhIQZS050Z45K8yQOHQAE0gAd9ZqrDP
         59BUAexxkqaY2wMt84MExF0rc5ek7HgRVxN2EkYiH0zeYlFO6NYQpnqMxSA6MHbOzb2y
         T9SqIerRPnPWbcv+suPG5JhpKBcm2pKnKCpiIZLAfZuPDNnxPrmRMz9t7diU+s5x0s/T
         DEOipP/KAEkIiUjv7nYX17rck7wy2jjO8usPiARfHFAhRzL39ItZn+Otvqexduegkib3
         Bm7w==
X-Forwarded-Encrypted: i=1; AJvYcCXqIR4GC62sALcKLSJP24h8GIBu73y7xYDWe6w7iOi4YtCTjsAzyhnHTphruBvnE24FTMfbtaxQfA==@kvack.org
X-Gm-Message-State: AOJu0YyEcCNzu9JxXxv7ROaHWDypCqYu+W16x5MZSHOM4tv2SEyZN60l
	QRgALI1Kghb6S7kMV0gYIwNOC3Q5DMAcRno9DC6v3fRHxln1R4cZqeuE4wrmMv1KHxnG3I/G5PQ
	oBFTEOziYe70HY4SBvU3K+jGO4kFLTgExXYMv2BYpQ+mmzNA88H0y
X-Gm-Gg: ASbGncv8KloFSS1ART4qbS92S77oMcXFuUDHeVECg1HmrIrObAh3zXk3/a4jw3rg4vi
	pFuy+r+yayJtj1ZsrPcH8Hrm8LlQoz/Ov3xVmtqutINQ4trdteevfcBVg8tVHyC+w1WyzFQ3yTD
	F5qZBL/Uc3Z08QTyWG1oooLSq8RQM+lzitOjLi0+a0X4F1n1AP2gDv/hyJy3sOUQ9IG2afJoRXB
	QH9RWCn+4yX+s97mD/NZDDFWzAK2csdp9AF8ewGe2YDSS9xFYMFO8Kx9OXu7ruxsJDoogW8EBr8
	TcgdFL4Rd68xwVKAjIp/xhjkdWQcT/DP3p9W9CZg5wlkjzp33R3Vjas1i6SCU+9pTWZ/iuYxelo
	zTIQBxvc+EhfCWzomX72HSzX5GK4toeo7N6f4APTxE7J+bYzCuEkjJZsgb52KTDKFZaw=
X-Received: by 2002:a05:6000:40dd:b0:3c3:973a:fe40 with SMTP id ffacd0b85a97d-3c5de349863mr2850229f8f.58.1755871838855;
        Fri, 22 Aug 2025 07:10:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGG3zymBLgr0oFAq5QBoFCFU2lzOHhnQpA7QCSr+J+SBt8FHvbVBMdDQMGrrRZe6+dP4YZONw==
X-Received: by 2002:a05:6000:40dd:b0:3c3:973a:fe40 with SMTP id ffacd0b85a97d-3c5de349863mr2850174f8f.58.1755871838314;
        Fri, 22 Aug 2025 07:10:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2e:6100:d9da:ae87:764c:a77e? (p200300d82f2e6100d9daae87764ca77e.dip0.t-ipconnect.de. [2003:d8:2f2e:6100:d9da:ae87:764c:a77e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077c576b7sm15322771f8f.63.2025.08.22.07.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 07:10:37 -0700 (PDT)
Message-ID: <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
Date: Fri, 22 Aug 2025 16:10:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LkKhKJwY4m9el6jvWkpheLVHOVvR4_oHnp9L8cM-U_4_1755871839
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EFCEDA001B
X-Stat-Signature: d9z3pim311yj6foxa144t5q4xiudxmu3
X-Rspam-User: 
X-HE-Tag: 1755871845-820381
X-HE-Meta: U2FsdGVkX1/5nmQ1ScIDOvJRD4NdC51/9Tf3+OvdzSFlTN8kvjLL+VIiUKnUQrYGzBrD8ebuy/adBBix8wTXWkyYnpCqf5K27HRBAZ0pTYM6bC3NKjfZyWkByQqcinrUcJlLQxDnRcfiaueBlpf4ekAdGlLC7Lq1vw9LA83i4/FXS7+fPHw04ZBgdR19XgPJBV7LngjbliSwbT2qDbfBctEWEES4+hkEfzyvCb3B3VP/PhOyqYPBu8SE5zrNmdTanepPbo42Nr0f+KHPUWzuh9H8NUNJ5JUum641Ra3Zati/Ij1ePZ4vJceqRlvomCx3aGUFwae9rcM634byyUq2v+94QiuJHYct69vIw6xmlGJ7CuQ8xodvscq0OUMJ7ucnbj7qKYDodAhl2dTIJzxpVI5Ul9l/ZOam0Ge4ROtUKkTiRlwJ7FWnEHBEd9q8w/TWJqUewighqtqma3nwMBB71P6cuhR9u5JAexkLxlZzGKRlWlFisjIi26UTrN0/JxKJD1cIerRdi8vqxaYMDwg5/TjSexwBBhpcr4ymzZEaNpoFjBZBZX23Ozw5yTZvr8se8BNaYmvj2xBOit2NbCMh3m4doEMHR+oteoTNtTVK9Hj34l6RBLjQoNiYl4feggiZtF6/MP9kZ24obmfpvt3OE6cY5wW/GqKiShk5SYI1vg7HbP0HdVDdlOPVCHt/FWn1K2dIyfaqnPPiq58Lbf2B13ldpqHIjZZk/n/vE8zqp2dCwBClSd//33HFGhtBF7OstW5seKHAcO5b6onORbde1miOPBAy2EOGoZ/bXVqyz9KU7RhHhttPN3P97yrfxrE33EUzexvSvG6llHEmyOJUg+HFgCoAtAK4ft5d4kOcHMHnggc29gWUmvFIlaUjDaY8EaXt5MMtI1RUGzWIM2h/XER3ccz14mjhLmhXgwKXV7d6WI1fbwm887C5lQ2rxfhweBT26BJCd+vIRJp+Cps
 4HcaiOLj
 ZR2L3WaJQryQEplObbUDfydUHoQkWQ0RA62m9WR4pcYt267q/S8QQIaxAQApOfJwtQZOT2xqIJZ6XIYVTvOKfEpAasFSbBJ771zDITAObdpbtUMjXl8cILV8h7AWtUOVMvcFNf/o9dJ32MzEXPtMrvoN4FqrJcCiOPWIAFbLd66b3XnHlWffE9n6wexXY3Ev10hGcQOud0NVHaHwVVP3eMVafCfUwT39hqdF/Kg8shtUVNr02sy5eiw51aYi8XP8SqCvc/Snk5iqZ+4w+gxqpT08o1BWkw/kj7rWa+LUbLphbpFFDLbt+MAS5O1jaZnBWvwUq55V8RpyrfeFTpvdr0CbJgBZ+SC54VauOaHUFDKnNUGbLvrsAODM8ptuBl0Z+t1yVVU4VHozdoZTlgI/Nsri/kbREv63mGuVnzQlBD81VJGWOvPgNSvTODT23UchLPBo4lIG5nVtzLDz63SnGUySATOLU+s+pNBq8WudmU3cs7sxs3UddW0lpSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1), but not sure
>> if we have to add that for now.
> 
> Yeah not so sure about this, this is a 'just have to know' too, and yes you
> might add it to the docs, but people are going to be mightily confused, esp if
> it's a calculated value.
> 
> I don't see any other way around having a separate tunable if we don't just have
> something VERY simple like on/off.

Yeah, not advocating that we add support for other values than 0/511, 
really.

> 
> Also the mentioned issue sounds like something that needs to be fixed elsewhere
> honestly in the algorithm used to figure out mTHP ranges (I may be wrong - and
> happy to stand corrected if this is somehow inherent, but reallly feels that
> way).

I think the creep is unavoidable for certain values.

If you have the first two pages of a PMD area populated, and you allow 
for at least half of the #PTEs to be non/zero, you'd collapse first a
order-2 folio, then and order-3 ... until you reached PMD order.

So for now we really should just support 0 / 511 to say "don't collapse 
if there are holes" vs. "always collapse if there is at least one pte used".

> 
>>
>> Because, as raised in the past, I'm afraid nobody on this earth has a clue how
>> to set this parameter to values different to 0 (don't waste memory with khugepaged)
>> and 511 (page fault behavior).
> 
> Yup
> 
>>
>>
>> If any other value is set, essentially
>> 	pr_warn("Unsupported 'max_ptes_none' value for mTHP collapse");
>>
>> for now and just disable it.
> 
> Hmm but under what circumstances? I would just say unsupported value not mention
> mTHP or people who don't use mTHP might find that confusing.

Well, we can check whether any mTHP size is enabled while the value is 
set to something unexpected. We can then even print the problematic 
sizes if we have to.

We could also just just say that if the value is set to something else 
than 511 (which is the default), it will be treated as being "0" when 
collapsing mthp, instead of doing any scaling.

-- 
Cheers

David / dhildenb


