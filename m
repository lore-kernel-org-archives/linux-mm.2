Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94EF6CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B083B8E0045; Mon,  1 Sep 2025 12:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFB98E0016; Mon,  1 Sep 2025 12:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF388E0045; Mon,  1 Sep 2025 12:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD2F8E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:46:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A83F1DF0B6
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:46:58 +0000 (UTC)
X-FDA: 83841260916.02.28CD4BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id C102F120011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:46:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RAWY9GD5;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756745216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvn18oPnLd+zvAZSKNse2+rKolpo9zqjbywvQFctj6g=;
	b=OUsBni+V8dOg/Wt3vSXTFUGhGDtsalszU0wRLmKVclZajVktUhT6wpEqshMIKI8pk1XZo6
	EjH3a46LjqPlpVlYO0qAgFuqzuf/xB5Ba92MkM7tBXIqME3HteWK/kGhb+vfwaexbpus/d
	9xA/mxyhLvf2RfWgwCjDWJ87bkuxS1s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RAWY9GD5;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756745216; a=rsa-sha256;
	cv=none;
	b=nU2ZWxcYHL3/s1nPp7X/OSUJA99UvBLm7ickL1EXk6atRQKbnXE/RzQVuxx6S9H8Y0g1s+
	ZAwfzwgOQfcXud7zuiw7n3U96LpZswkuWUwFBVxXZj4UWU/H8ZiIX1EXHdpXdjAVRR6Jbm
	QA5H8xoftFxebA8WmrkIQb2WMUaqc+w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756745215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zvn18oPnLd+zvAZSKNse2+rKolpo9zqjbywvQFctj6g=;
	b=RAWY9GD5lCaK24KKlAYA9mz3sW8RDEXOzJmV9O/fAJ+0tN2ZWH01EoZyvfV5CDposGZfUI
	0uO7NTm5xoFaQri9O/uGk//BNvrd71/Uc1vITIyJBxphYjLb2yWXT5yOvq5A7SNbNS9jUP
	Jp3sUsxG2bw6zuiGeST39/6INW6vhrY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-tDqRvu_XPKuvBcyIY5Lf1Q-1; Mon, 01 Sep 2025 12:46:54 -0400
X-MC-Unique: tDqRvu_XPKuvBcyIY5Lf1Q-1
X-Mimecast-MFC-AGG-ID: tDqRvu_XPKuvBcyIY5Lf1Q_1756745213
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b869d3582so10252295e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:46:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756745213; x=1757350013;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zvn18oPnLd+zvAZSKNse2+rKolpo9zqjbywvQFctj6g=;
        b=rA0QSTSLH70ClriIUMPIzyi+ScIEl5S1Yu6+sAuHOvBtXUKo00w4aH77FagU5C9yQY
         r4pTLo+Bkqc/gJZs9gpH4NT8w6x8JDSznOTXJZVag1s3WBEFpK1UooniWNt6DO/8MFSk
         JimwsvrupDzuPa7wf8/22HZyaZ8uHqUXWM9tzIttmTvSeE6VeZ2X6J/dhLkIjTgq7PK9
         tTnYuRH59ynZ8B2FTJdBWXeGvIFXVEDPpO2b3qr/Xh9suTbTf7bgSyp0puEJAlceGdMD
         J8MaQ3Tmq7R+2390+Kvz6884/MEzGkIipn00eKZ6Z/lJi/YLmA6Sb15CG5RAHIBSCzGM
         Xj/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV9Hf+Zm34GtSCY5Jk/jfhnOpjmglL3dImoJ3Yy1A+MOCmsHEDyHmYvI4sKWTPgwLXr3A7OP/CHdA==@kvack.org
X-Gm-Message-State: AOJu0Ywy0fAGnjKCdbnm16Gbk1qQ5cB2Arb5J5+6alcf9OOUimQegd65
	w3t1m5Uf2Z2TI8ARy/DA5ROzJ8V0+QugWo4ZDd+nVV7ulbKuI/KEqZYd/KCoJktH6OGpms/CAZb
	xJO9ziRGQy3cVpN92NzLoRKBup5/fB0RlNhGnV5LkRnSD3rY5AZPD
X-Gm-Gg: ASbGnctIAeTDZQM6PxrQnpYBUylinZzBFxOrqGAK0naOZapWyyeGHGN7RonCEfHErM1
	b625+LvCOluxa9thToydyHmCFeGWpbfjxHsPbNwGOny62MMPU7hyImS5tQ20Jh69ryzpyvvFA2k
	OLdNXTIY8UugfzLjNQIUgrx85PWV4J+yrMsGCMzHOWhNVR3G1SbhqjzQUbRDkqjEyba8bJCaDmS
	TsImB2628eU5QC1+vUXDTi4a0V24T8cgx+Qbi91mzav6v0P1piHqDiXSclxXJ/ij3Qp59nRp9uG
	WFazL58FVMNgH524ul7LtD1UL5QJ69YbmKC99gh7ytkTrrk75/ZUc2uCTugVlqjlcHRV8RLVGZe
	Zl6bmlFyG8vj3n5mu1cHliMxxwKIVO4YVSaWbGcVQ3ZYXyOwltaeCqxpMj+z2RGicxOM=
X-Received: by 2002:a05:600c:3111:b0:45b:8c5e:5f8 with SMTP id 5b1f17b1804b1-45b8f43c876mr21537435e9.28.1756745212740;
        Mon, 01 Sep 2025 09:46:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+tnHEYgHg2xJrHLCrJvwVRM4CI/+qfgYSG+gAdqo4scSeNuoqAVtK5k8iywZ6wC6u9AF1Ug==
X-Received: by 2002:a05:600c:3111:b0:45b:8c5e:5f8 with SMTP id 5b1f17b1804b1-45b8f43c876mr21536995e9.28.1756745212302;
        Mon, 01 Sep 2025 09:46:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b8f6cd502sm15397475e9.1.2025.09.01.09.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 09:46:51 -0700 (PDT)
Message-ID: <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
Date: Mon, 1 Sep 2025 18:46:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
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
 <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
 <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
 <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E6DiB_sQ_V7H6qawfy79AaPFdrRjZ8TC5EpQW_XXyNk_1756745213
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C102F120011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ysfo3ecehgypf6pahaei6dij7szpu7f4
X-HE-Tag: 1756745215-518167
X-HE-Meta: U2FsdGVkX19PWBwNU2rWRfioW+oKKAg8TRyhJL8lBDRuhudSVR+czPmAioNd25ukq6hYX4TmGQaZVme02w0LoZNGy6Ey15dYsfbBLprm4m2h2tGC+51TzKQf68AzEF/33xF83S0SX65diQRcMMc5bpBRay7DyqgoJq6uIxRC8vDp1x4L63rlQZ290WZk44R0Yfe7EEJBXtJNhAVFNCXXX2EKVRg3WXJ+5GvzrZPqL0yO8CK/O4CgpRCm2IqFSNLlzs8tH5sj0lFfxKDxOgAknnt/HGXp07ah3EuhhXu41O8VVLbFJUgYToX6JIkE8hdMfM60CTrbk/q1stUs6H1ha86yysNpGnyLiLQw7vB3XquFmI48Jsj5zuy9T/FFfA2agro0seTGJuxRN7d4H38mROGzwF5xBXvK+49alAUOFGHpwWpc43Dj9rdW66ea9vL4ONjV+YxDV9FVqKzzNgeXXeROweBas12rNWaM1byr+gI6KEk9FUjZOgU1A7pm1XzVieqa7lEwdhuT1zWNHWzeYV7LvuRPWUrX3Zoj/OVMl8XmrdPgXdpv2GLl/apo/vxeEgakprZH9INtbIT9sp/iDFJXLAdI5DDP8hO1xtZ+2Qkf67I1TRaixcLS3DjIgCo1rTIyMjhf8hVSrm1L1LgjB4g/ESkQD/ADJGPxHtgUa1Da3waLlgP7PobDzHVyfu+dup41yJZqj40XqqK4+ggN+NkuVyaMUAVlYwY6Kt2G19emdP50WY/1OoEXU2stile43mh9vldMOyOpBvV9ybySDPBTUz8IGX5PjQ2Tbmak0wqHwB72mK/X2pWBtyRKhbErEG8gDnatjGMP7C9WGxrSYFvGLRypwHvqU1MXfLmlE0pybAWAbBJu7WQcJ/hP9FhObi3goWzGu53Ze9tJWaoDZM5RNj+P1t5TQEzyAH+dGL0tmIfwb0+y30qwlqphPyObWCnNg8eeW358BPSr1NB
 BMuElPR+
 lERzd2qk6KDEviSSabd6/k+/QOiMfsbv4V4Oywl2XcGq88+pPzV1KNtRCk0fl2HaQqMbo8A+4u6PcTkqy3CFgwl57/Mq0mnrXOoLhPPnAnCJe92mKup2vugiIcMWc3os2BvHl//hZ8ZMYQ7xRUPD4bo3nDRpENFP0r8G4vPLZJ/cIKjyN2aoCfETe0LmOOV9FvwQEpWHItwycQT2i+08g3tsPi9IEYEMsLm6xfMTP3it0NJnqNYDUrrwykJOlW4q7lNOUT/U64F/VbDyKR4VVL3cFZHgk4BHanGCUEnvv4GQKQzIKcrF2HSMF2YMMlVrV7jQIV9wggfi6sNcalBit2dZcOYhmCTTkbbfEXzfvbkKHIEkuSsR7W0BHiAoDexCVyy4tqNHJV+Jy5uowu8KxQt+YLggCZ/XSOH9vaZjUyU08sRt6drKdpoPZq0r06ud0oZMMmIO4o3fcjUcE+wC9mPV1IIT4KZNVt3mrSnAK0XjKmuLhLJkESNEtgYndruEOC3I1UfxCKE7JQFHmPgtyWId5SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 03:55, Baolin Wang wrote:
> 
> 
> On 2025/8/28 18:48, Dev Jain wrote:
>>
>> On 28/08/25 3:16 pm, Baolin Wang wrote:
>>> (Sorry for chiming in late)
>>>
>>> On 2025/8/22 22:10, David Hildenbrand wrote:
>>>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1),
>>>>>> but not sure
>>>>>> if we have to add that for now.
>>>>>
>>>>> Yeah not so sure about this, this is a 'just have to know' too, and
>>>>> yes you
>>>>> might add it to the docs, but people are going to be mightily
>>>>> confused, esp if
>>>>> it's a calculated value.
>>>>>
>>>>> I don't see any other way around having a separate tunable if we
>>>>> don't just have
>>>>> something VERY simple like on/off.
>>>>
>>>> Yeah, not advocating that we add support for other values than 0/511,
>>>> really.
>>>>
>>>>>
>>>>> Also the mentioned issue sounds like something that needs to be
>>>>> fixed elsewhere
>>>>> honestly in the algorithm used to figure out mTHP ranges (I may be
>>>>> wrong - and
>>>>> happy to stand corrected if this is somehow inherent, but reallly
>>>>> feels that
>>>>> way).
>>>>
>>>> I think the creep is unavoidable for certain values.
>>>>
>>>> If you have the first two pages of a PMD area populated, and you
>>>> allow for at least half of the #PTEs to be non/zero, you'd collapse
>>>> first a
>>>> order-2 folio, then and order-3 ... until you reached PMD order.
>>>>
>>>> So for now we really should just support 0 / 511 to say "don't
>>>> collapse if there are holes" vs. "always collapse if there is at
>>>> least one pte used".
>>>
>>> If we only allow setting 0 or 511, as Nico mentioned before, "At 511,
>>> no mTHP collapses would ever occur anyway, unless you have 2MB
>>> disabled and other mTHP sizes enabled. Technically, at 511, only the
>>> highest enabled order would ever be collapsed."
>> I didn't understand this statement. At 511, mTHP collapses will occur if
>> khugepaged cannot get a PMD folio. Our goal is to collapse to the
>> highest order folio.
> 
> Yes, I’m not saying that it’s incorrect behavior when set to 511. What I
> mean is, as in the example I gave below, users may only want to allow a
> large order collapse when the number of present PTEs reaches half of the
> large folio, in order to avoid RSS bloat.

How do these users control allocation at fault time where this parameter 
is completely ignored?

-- 
Cheers

David / dhildenb


