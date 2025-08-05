Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B33C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E537B6B009C; Tue,  5 Aug 2025 06:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2ACE6B009D; Tue,  5 Aug 2025 06:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40816B009F; Tue,  5 Aug 2025 06:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C677F6B009C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:58:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7469C114C4B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:58:05 +0000 (UTC)
X-FDA: 83742404130.30.3C9B418
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id DF31920009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:58:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ESBZ8kcm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754391483; a=rsa-sha256;
	cv=none;
	b=Pp/tV/aSKV22jz9oEX99xTsoAPou9pMxaPyPPXsLWQ76TH0ln689XjbyuJInioxf7DnL44
	UGfXkjIV9XV5iL8Pd5WgrtEySVlXIfj869YGZOks/LQ/ZcE0x3gLk+LYm6ytq7sBQITTYl
	cY/dfCSxTDI0CHvAlVnMaVssRDVezOs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ESBZ8kcm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754391483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5BMU5lGJ8RNX9gIIEKL9KgpFrlX8cIqx5sp7WULqO4=;
	b=5bV1vjBfL9gbxsrOWrQK2spFM70/85/HXAWst/69WDPgfFGr6Gdb+uhQDB7q+5CqG7EZBf
	L5Axmo2d8FUOy/TPprFAveRXblD+l9A/XCsIiooCdh3kKoZRPRfI+mY9VFBj+wSs7s7+CM
	xPpAXpRYOEIpBMC4tDiHdHecgSDq5yU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754391482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n5BMU5lGJ8RNX9gIIEKL9KgpFrlX8cIqx5sp7WULqO4=;
	b=ESBZ8kcmuvMv9V0TyCbtmTtsojJKVtJdv/VIS+wnsXbLc2njaFSlxcp5rXZzLg7aKDTLam
	v3XNylM0tauqiJOiaZfcxOJF8J0U+7bCQBGPkC4syTNTASohdO1ixcWI6NBJgukHZ6V2Cu
	H093Q55E3QQ1IJ0LTZS2J1bGKPgqhAI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-CrTCOyd8OQacYnOPri_5aQ-1; Tue, 05 Aug 2025 06:58:01 -0400
X-MC-Unique: CrTCOyd8OQacYnOPri_5aQ-1
X-Mimecast-MFC-AGG-ID: CrTCOyd8OQacYnOPri_5aQ_1754391480
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459d7da3647so13452915e9.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:58:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754391480; x=1754996280;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n5BMU5lGJ8RNX9gIIEKL9KgpFrlX8cIqx5sp7WULqO4=;
        b=Et2zXySNRhEPhz1F3LoVr6NcmL+iqqV6Qwlc6i5t1jcUa0hbEpsMhLC86hTDAr0VvF
         ETzJpnI3KjQJWPcFYyO9zcDctISw1pZTdjcKaO983k2/EWB/Ivun6iCPDzICr/0kLeBT
         9uwuYVVEOXiYvbgZIFcbFIWQkvPY2JitaFG0UPot/iw482rhgFq/QXeR+7pzUjBrmSTT
         +5C0OJeB9g7lAhtT/w3xXhQZX2iWpxLv+nDUSwoeQiqcYkNvd+1ZdBcRl3CA8jddccBX
         lyi58oiYsvF8xBTN7Pp4kRQQb4Fp0EjIGDCJy5eDm1Mlbkc1ZedeZOfcIzEe4FWlwdTx
         Za5w==
X-Forwarded-Encrypted: i=1; AJvYcCVEGuLDuuke1yknu46CQY7TY1zTNOBWzqvNz/NEjc4egoqfZEmryQ3lxzJvD431ATlvVS4DFFVPIw==@kvack.org
X-Gm-Message-State: AOJu0YyKHV0tfKg0fQusnw3eRIn9uuOmr/icklgz+dSGd4ledaAjeFy7
	kA4BoiTw+GMHdCWB6NUpJHiGgelVJMTds03XM7S1+4lWhggAG3g6M99Qpbcw5KdEQduuU30YJwh
	6CaWMVc+vlLdAGID1aY84+sZiEs/mCcLP3Ws6SikOPd181yFonbuH
X-Gm-Gg: ASbGncvDBScRP7xp4EOpPXFkE+NW5xdRUWZTHq/dioboP6fL5bIQCS5pw3KrToO6Mjp
	/zCEWaKIQ7LRBgFrJ4aK1VYkZmPHaKSC/1BKk4h+vORPL3wrjkT6i8O3Igvvih2Oy63Y63uPrym
	JNQWlhJUYDTvtjNbJr8OKlT9fkF3Z+tCT1s8v4iYsNSdf0fK9vOGl4scobta//4CjPT0RpPZb9F
	ec2YKfY0R1/k+bXsLC8IGeyI87uq4NWiK4dVsMhdnsLPRu61dAamHqmawZhIx2XbjG+vpDb3Lw5
	UkaP38nxkG7z2tEW3YHOkDz14U7MaQIo1xv5x21Bg98NFlkNeKXE6+7Vc9X1QH1HzCEgG8+NHoo
	ym5zXsCOhTlpPOUCx4ozP7vCGFJfsIgI1/765MNboZVFAdGJIoL0dut7Ud+pyetzyHyU=
X-Received: by 2002:a05:600c:181d:b0:458:bbed:a827 with SMTP id 5b1f17b1804b1-458bbedaab7mr62785165e9.1.1754391479874;
        Tue, 05 Aug 2025 03:57:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZS0DPqvyL4hZcBu/zSvjFODPXrIdMTkSTToGBYD4/CSW2xPIeZ33vTtYp0ch0Ef/n0Jv5CQ==
X-Received: by 2002:a05:600c:181d:b0:458:bbed:a827 with SMTP id 5b1f17b1804b1-458bbedaab7mr62785045e9.1.1754391479451;
        Tue, 05 Aug 2025 03:57:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c469582sm18505270f8f.52.2025.08.05.03.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 03:57:58 -0700 (PDT)
Message-ID: <98a30c7f-8be1-4b08-955c-724667971288@redhat.com>
Date: Tue, 5 Aug 2025 12:57:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 01/11] mm/zone_device: support large zone device private
 folios
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>,
 Ralph Campbell <rcampbell@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-2-balbirs@nvidia.com>
 <dbebbba0-3c59-4ee1-b32c-4b9f6ed90d92@redhat.com>
 <1e307223-897c-4db0-9564-95d76bc3d260@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <1e307223-897c-4db0-9564-95d76bc3d260@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S65AalHwmu_FMXQuaK06PW85VYWocE3nZDINGhgkJEA_1754391480
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DF31920009
X-Stat-Signature: ts66ce519aopss5h9nbp69h83px4xaiq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754391482-368494
X-HE-Meta: U2FsdGVkX18SB86E31xrYIbZNGXyWqicJACpvKaeL3VkozB2PrShys5R092rUDnOzaMZKKK3SbnQNS9o5Msx/FjSUszLbzuVciH74XMtQBgMze09ul1QX3ruQLWCNMTsjUvBYtXpRrizpFKYxNiZEjSFX2vwwFyg8a61QywVKSLIFuqZgk73trCqlGp/lYnP3q/QBlodyBHVk5Ot097mSzRrK9JYTNV1F8cGoLK+rZR/DXoLLv1cP/BoHVZpMNfQldc3ULQKt5AnspKCGCoijX98MYXm2+RZiAw40M0rzWi3Ig1SRflJXHYITtoQ1In3A0p5s/P/UEG7zJ3jQ+87fRVaIz1H327b7oNtZLsK1MrFJj4dOMejQZHKPbBKDt7g+/URJie3D5D2kYX2CDw39G9G+GDy9erMkVDQPkWc6ZGO/XNa4ZmGMRuK9DvjQVnPNpfulRxHYncj/aPS7/SwxA/OgI3W8bVXBb8KwqsHZItM83i1pAWaHUphGn26Wommx8dff8uqqV5GHoBxHUdN7amK49MhI2S1IaZ3RWr4hb0/y+1gMur7XEto/5tep17ISOY61jNpexmIDYtCsc7wes00uGIXYWQvky2zoXFdZ3Q723I6Idf3V2wlvn5iyBb5De05JHVSwBWJ//lZao5ch+pVGpJY4ry1WdDX1oqyrW8f/nlRozBSXesUoFnr35r2+lbi02vS0IOh9TpoGpU2bEK9Zb7D20plMM7WpbvnYXjc4NgSzcUmvKSzQIEOVrU0nLaCMelrVl20fdk3EPay1eim0DXq2bycA4cBc+ZO+cnJghmYMAameOP/qgSU0IxTailTY1XgYfIgKfTmg7KRB6hYqy01sglz4uMz63VqgvBluh9ZApU+mZ0fKVnD6Qd/wQcFkpHPhquit+HLjpWA9rO0OUgbcj6uCEJpVs5/Z1tWNuXT1zWTkmnwza9JcxY4XZaP3LIdFZM5TVRlBJi
 Sqav0OLi
 tDdVN6MDB6wWd3/ttCyH3ZiYekz5agSXdXo73p60z0iiETTFWCHQn+PAAIpO+DT+y+GItfd+ZJTfDH1ga/8oMHGWtuaBMx1DL3GP+YCzoFAAn8t+GgR3EVwYvg8hf6GL8L+aQg3Xmkvuqj1mQqMrbzQaYvRuBtg/g86CPl9AVIO76jTVjLquvarkP2kzWxX27K8LMBQ583kdsNqj9Z6JJhOaPwh96LtgOUhPVj5yi4Zw1sfZSevQft4rKhb+zn+RhJ8fQJPUxHMWx/jttydJVFozit1kDUhKSq/pADoPqB4BvewgVgqb5NBxruRxgrKsFsnxnc/lxVo0bvh6THA8jVHOn571VAyrrmUh6Y/k07P53ynqT/Al3RLRNr6AYQjdiYx/U57E28oCummMLiolsNq1W0qWIdOUX2HRZ9uJYFohm1BBFxLfweZlvhFjLMDnZDko3H2bNC7MTz9pPfnKRT37DPZvV8u5DESR6S+/9O7l97laesX14iUpK0TgPMc4WNuWvXfsFx8fhJ4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 06:22, Balbir Singh wrote:
> On 7/30/25 19:50, David Hildenbrand wrote:
> 
>> I think I asked that already but maybe missed the reply: Should these folios ever be added to the deferred split queue and is there any value in splitting them under memory pressure in the shrinker?
>>
>> My gut feeling is "No", because the buddy cannot make use of these folios, but maybe there is an interesting case where we want that behavior?
>>
> 
> I realized I did not answer this
> 
> deferred_split() is the default action when partial unmaps take place. Anything that does
> folio_rmap_remove_ptes can cause the folio to be deferred split if it gets partially
> unmapped.

Right, but it's easy to exclude zone-device folios here. So the real 
question is: do you want to deal with deferred splits or not?

If not, then just disable it right from the start.

-- 
Cheers,

David / dhildenb


