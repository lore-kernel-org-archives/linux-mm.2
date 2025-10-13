Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBAB0CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418A58E0030; Mon, 13 Oct 2025 08:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF7B8E000F; Mon, 13 Oct 2025 08:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE1D8E0030; Mon, 13 Oct 2025 08:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA608E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:42:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8D69B9725
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:42:10 +0000 (UTC)
X-FDA: 83993053620.11.0961402
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2FDF220009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:42:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QerSLHT1;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760359328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GV6V42eNmRofCKO2ajQk2DVZzbVn5SWQi1G7vlqlVt0=;
	b=1C7ofHBBfhbctKkPsfdIIHpDZJ0whA17VuNBG747TImmVpxqxq62OJqWGXaTVM5PAhHQrN
	YzYKs1w8oNmD520SwLABcaoL0OGGsuVVq53aycRwX1aIdmWgIPudBL9uCKdQWsOS69u+p5
	M/2lx9IRGsuCtG/xnNTw6MWVtXtKesw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QerSLHT1;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760359328; a=rsa-sha256;
	cv=none;
	b=OQd9+KEGd6nysWE1GMzbVfm8fr/Joe9hMBZVaFGCqu9hP9m40LzZGFEM9aGsl1QwKcozrc
	/DujIXFxWRy7iObIKdaaepHbm5ohNAMFAZ2usDgYjHKFQJl/jwFuK9ydkhPvmp/8d6cJCx
	APScs3DTvbitwePHeW1EPenMYOmeNm8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760359327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GV6V42eNmRofCKO2ajQk2DVZzbVn5SWQi1G7vlqlVt0=;
	b=QerSLHT13i98G2o11PZ7P0W2qZHvXdJgXKcP/McpILQeqA7bqexDr5xGG1gKnwxhAYJIy3
	hpvebKC9egjaa+PE8mFRyPsUH6jeJiWOdVoA0f7Guh+ihSAEZApDa5rSi8SYaisvH1BE4y
	Hbw00pjnulYLCVnw1GbOfswMNFZ/ZX8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-NgZtRwKvOeu6LcLtcZjEYQ-1; Mon, 13 Oct 2025 08:42:04 -0400
X-MC-Unique: NgZtRwKvOeu6LcLtcZjEYQ-1
X-Mimecast-MFC-AGG-ID: NgZtRwKvOeu6LcLtcZjEYQ_1760359323
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e7a2c3773so21880035e9.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:42:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359323; x=1760964123;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GV6V42eNmRofCKO2ajQk2DVZzbVn5SWQi1G7vlqlVt0=;
        b=pmiyxKdOGdwQAxz/Cvq1uyayJGCcxSf5w1Ju5tWgnAc4yaKRa87lTq6+zRad14NHpE
         7br9sp2AN6WQN+mI/k+HJzuqHo7tc3s2aSjP97NnShFEgRmwUDA7OmeUW7s08g95Ug+m
         uFJ9+DYN+hKz28csLjF5VbTYq00ue62MeL+sRTV1rcWoa6m8KNvkvqTBzDpxuQiccy4e
         FOT1O9Tu9bWM/TaHUYNjeUK/L9Va4Iv2Yz8yzYnByJ0+smaTQUVf69BlykjoHnQZQgb9
         TGQJIRoRRRWjuZNEfni0AZV0OrxKmmalNMBM1+WIEUU70fy7zcab2KMGnUtvjdKudPQT
         EkvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBHWBQkUVHKmQRmf3dmdCaFZB8SJ2sF4tlane3B+CHcPRUgbs2Tx3QbGbOFG4SY7VTKn4POJFvPQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1CiDgwHcweC+fHd018puA1/8VK8BzTaB5eervAsKGyk6TGwG/
	wcUFFD34rIYKLM9SUDvuG92Z0OeyHKhxEh9Dkr0eBHxnJRnQKmqMYGpku+0k/QEm7yJCjesS4+0
	s0X8trCcqzmZfev1Vn0/oWL+wWdFTiAsL0B2ZBF/xPX7A3NXfHcJ5
X-Gm-Gg: ASbGncuSxxOLdJjqgNP4Mb0GJPZoycLMr39hTWzF9XynZYjjT2DV26V/7+wvfSkMBAA
	j/RZBwu7sjwI4e9p6NEpFJ9GY/l23VwxXnb9EBdW/VKAacHC446xVlIyH67tEsm4hwmE5YOXjVq
	5bG3GLGRP22HRkgxhjQapPx3O/7gmgTIdAcz3QrWiXEjGhGeLD1gy1hnwNoTcX/wUNp+JLIfch4
	crmJ7YZJtOiXdpbmJEPATYmzspo+hxCLnW0/npes6XGI6G1vL/mfCqBn8yFQqiUYFcTSY//9jNb
	uTVSxrWVpGa7OPGXqukT1RyRQo+5STyuY7naYyexIKmyv+v0dMy6r7DAQ5rwKlNGBXSfSQadZqM
	x+iM=
X-Received: by 2002:a05:600c:674a:b0:45c:b6d3:a11d with SMTP id 5b1f17b1804b1-46fa9e8dc8bmr158955175e9.1.1760359323083;
        Mon, 13 Oct 2025 05:42:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHauSt6ruiV5Kk8L/+gHwRrp8105EYALDJNBUwgBgUbnyLWlMo37UXqi0DKsbi3Tl2D4kwzpA==
X-Received: by 2002:a05:600c:674a:b0:45c:b6d3:a11d with SMTP id 5b1f17b1804b1-46fa9e8dc8bmr158954865e9.1.1760359322699;
        Mon, 13 Oct 2025 05:42:02 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fc78559c8sm29186175e9.4.2025.10.13.05.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:42:02 -0700 (PDT)
Message-ID: <7176597b-006f-40ad-9421-860d80d7e696@redhat.com>
Date: Mon, 13 Oct 2025 14:41:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>, Tejun Heo <tj@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Alexei Starovoitov
 <alexei.starovoitov@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>, baolin.wang@linux.alibaba.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>,
 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>,
 lance.yang@linux.dev, Randy Dunlap <rdunlap@infradead.org>,
 bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
 <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com>
 <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com>
 <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
 <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com>
 <f743cfcd-2467-42c5-9a3c-3dceb6ff7aa8@redhat.com>
 <CALOAHbAY9sjG-M=nwWRdbp3_m2cx_YJCb7DToaXn-kHNV+A5Zg@mail.gmail.com>
 <129379f6-18c7-4d10-8241-8c6c5596d6d5@redhat.com>
 <CALOAHbD8ko104PEFHPYjvnhKL50XTtpbHL_ehTLCCwSX0HG3-A@mail.gmail.com>
 <3577f7fd-429a-49c5-973b-38174a67be15@redhat.com>
 <CALOAHbAeS2HzQN96UZNOCuME098=GvXBUh1P4UwUJr0U-bB5EQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CALOAHbAeS2HzQN96UZNOCuME098=GvXBUh1P4UwUJr0U-bB5EQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xNRgwAUfIR9kCf8R8Mp8Uaz6Q_RG4eMDOaB26Ih7Fxo_1760359323
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: amm9c5idufudni7fs3hryqeyxk8kak56
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2FDF220009
X-HE-Tag: 1760359328-539974
X-HE-Meta: U2FsdGVkX1/FGDvYBI2IZNG2WVaj/8jtf2LE/CtTI7DN+ggxydaXl245LNlUoJy4tvFGq0c6PTPkkllX1x7sFSUAtnpG09OH6yrmZAvFGKtcQmcrLpIVM7Z3H8b/JScZq/3JWcA6olBdLJpTYlPqmV393KSQySiOQRPlPgP2vpfNS0NNLI8PYBbGC0s/fE9fdK6y8iPHHCTjpePI3FzCmO7mKkqj2rnuNu5BM3g8QLO3F82SP8qFFU9bxD6AMvjbxUvDU54+pgOczQvBga4kLj0hdp90wqkT8UzLoncVmQ68+G/0YQOhFs0JyyD3Y1iWL9qM6vcelmPU5zUqSb3yiFVI4WEf+MzX/yRShXbOHIIaAvjdK1CS8+hPI3Xh2BktCuYpnI9bcae/XJlv9aodp5KnOLN8r1M/QULTcJxDsufkxFiQT3z+eqN2tTvyn85RP2d+1T1aKuTWuJkeehd3UX8VpwQwWbvWv5UngzVBgPE2dfGObvW84KyFY2iEXdgSk00d871aMCj9iuGcCVVQM5kTO/e2+HB9A4kPLRs4ts0eLzScMkDZKH0FpcopN8hRNIL7VTEsjoesAz3jqz7a8VdKq0ybuzr7bCIRgzQLY8B39eOTMzqfuKQKOObD7+9bfj1ZTswRhpNMUMuS4HhB0EaCPaAU5wrX8V34Mk2EV8+850k8xw/ONY8inWr7qPu6G7JonvV9R/AR2prRSIRkb/ABghpZuT6oAU2yTIDkguCw2tmpu3elydnT0gUf9lZx0IBm0+VSfQSTCu1A5HxcxNFbTXNajQgPp2dlfV64ALoLKkqfD/XvRDGDbnPZhb8AOzNLdmHgXe16mGQkr55sEzBlKagkqBlxQeOH5ATMwAh0uanjZeuXc9Cm4LddYlPUUGcgH/QLDG3TiClJXxXRx0Fpdr//MRCnasy1raypgXYUaXn96MSa+5vCbkARLGkz0YK8Ak1coZLCp37vnuk
 RmMihCWa
 G+GUD364sKOfclzi06G06JQwRMlzYRpx3Lw2+H9LBtbOtZhhIqc45Xk8n3WXGZCnaxCBJF1ES3tXAHQqmGAPKv7TfsO+Tbmx+Onn2hLjk3mAVf6hFJ2XkErl1irYjwzQsjiYruYU3bBZu9BF5A6wPdkRslaAuvbyDuQJT6SKR51jKebED9TGFFfoQLzABB6C3/KYm7rrDGDvjQiDUoQH5XRFrypPburBRUC9XVzb9nvVdH9wLI84mUOOqwOoyufXQXjnOjnp+i33p4KD0cp20OUp0WqDoawhYubCNJb3shiQN0UmPZL6/sSVdKHhrrj71IkRle38xbrzEd4uIr9K3xOXQN1YGeZ5dsblAACrie/sCvOOpE+bMPH2KYgX9x050jaDBjDdkyVccZkGLmC/11pHNGyM9yWMTkoIUc+FLwKFSDWbcJo2xccq5BbC9sAQZHjNeYKPK0PYNaVitDDqXOAxsnKMtog9zQ8KpSNNTq4Jag4h0ET6Kxw8WFzSCdxVcSEGCDNgnD9Nq/ExJUNDbl3qgSM5qzSasSt5CbSZFNTar/zU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I came to the same conclusion. At least it's a valid start.
>>
>> Maybe we would later want a global fallback BPF-THP prog if none was
>> enabled for a specific MM.
> 
> good idea. We can fallback to the global model when attaching pid 1.
> 
>>
>> But I would expect to start with a per MM way of doing it, it gives you
>> way more flexibility in the long run.
> 
> THP, such as shmem and file-backed THP, are shareable across multiple
> processes and cgroups. If we allow different BPF-THP policies to be
> applied to these shared resources, it could lead to policy
> inconsistencies.

Sure, but nothing new about that (e.g., VM_HUGEPAGE, VM_NOHUGEPAGE, 
PR_GET_THP_DISABLE).

I'd expect that we focus on anon THP as the first step either way.

Skimming over this series, anon memory seems to be the main focus.

> This would ultimately recreate a long-standing issue
> in memcg, which still lacks a robust solution for this problem [0].
> 
> This suggests that applying SCOPED policies to SHAREABLE memory may be
> fundamentally flawed ;-)

Yeah, shared memory is usually more tricky: see mempolicy handling for 
shmem. There, the policy is much rather glued to a file than to a process.

-- 
Cheers

David / dhildenb


