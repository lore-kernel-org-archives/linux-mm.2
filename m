Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE47CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC106B000E; Wed,  3 Sep 2025 04:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3056B0010; Wed,  3 Sep 2025 04:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2A36B0011; Wed,  3 Sep 2025 04:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6A66B000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:00:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 022E185F20
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:00:30 +0000 (UTC)
X-FDA: 83847191862.09.7C4456A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A90A100013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:00:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G4wpxX+c;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756886428; a=rsa-sha256;
	cv=none;
	b=0xvhaMUamg3rL9vGvHDfrwwb8hTUOwUZgqXHzBOkKO3+m5+mveFrXdmbnE03kUiZRic/iQ
	318SmuSs077Hl+W9uTYmZnQr5wMn8ecRIgBqwGFyOtTMVnJzRUT732/yG7mcFXdA9fV8A3
	ErvxnhbvIriBg8jyJyl1zkQV7Od/TKA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G4wpxX+c;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756886428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBh6cegRU5vIqxeNtdbA8Z6LWKwX6vsH3YnVQj1SefE=;
	b=wXnFhgLJl1ikhsvE4fg8ecYHUQq7yBGytN9BPVdMZK4B8aQ2ueY7Kt4xAOukzbGAb68zYH
	ODE6d4LTsOzYB/bavlqtd6D/Iw26ySb5khaUGsOSTNBaMBa9csn4DLq+eA0hg/NuKyI0ch
	3Y60tS4W+8jXQOSgz8MUiSPm1zJv6Eo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756886427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oBh6cegRU5vIqxeNtdbA8Z6LWKwX6vsH3YnVQj1SefE=;
	b=G4wpxX+cMupCToG6VYjbN28x+7SomXiGDJNAT7U7TjFqttqCt7qxYPjKngypxED83dByij
	dCpY3GtGIrTtYxqZ7bW6I1slNqGftgefdcOus8yAmUHeYJxZpNSCyTOF0Hf0XxDBC+AvGx
	LfNDIIedhcKNsWH/SdxlzK1eQLPib30=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-OoXPzePVOoqQvDasZnShNw-1; Wed, 03 Sep 2025 04:00:26 -0400
X-MC-Unique: OoXPzePVOoqQvDasZnShNw-1
X-Mimecast-MFC-AGG-ID: OoXPzePVOoqQvDasZnShNw_1756886425
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b9c1b74d0so7476055e9.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:00:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756886425; x=1757491225;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBh6cegRU5vIqxeNtdbA8Z6LWKwX6vsH3YnVQj1SefE=;
        b=VDJU+n6fdZTYyLZkRchlZ0WrCJdU6eEn72y4KtOtkrMz1p+hHvc00VlxPFplwSfCQ/
         PR8xt45sWNMOhbbUxYUTsqvgYi31iJ0srTyo5de8GVw96U0d2/z0txSbg9qlulSe2/b8
         sdMu2cilk4Y1GeGarq51y116r9+UmM/GiSENcTiHTWD1tBDxPS+cyO8vUOHAXcSXDG2B
         c7GXfNIE09a3mbr4mf3ULbANlxPF0LeslPxUZaKPoaflPcP/XOX3gBSkkxyCC8tv0ZD2
         HyDfS7FTYCnf0299ZHz/43zLxjrj18qp1bsccdk0+ZX0IGCU3QLdkQDfOTE/aepgL33A
         K9Dw==
X-Gm-Message-State: AOJu0YzfNcne6q/JocHWO+ZlqOP+4v6rmDUSnUB4uYV9EwVEOgiZd5RD
	3vkE8NpaFnxluEy0jKDrEo+UAHOi2sxD/a0MQvEnUT3VhZHfTaawwGKBhMqMhaEZR6M+gCwS8gV
	MwCf/Ao+N08oM/zpQJCCsvzRIrBsLTXnd+b7qgXTqxPwpCdmFCCU+
X-Gm-Gg: ASbGnct8mrt6fi2AA9hrjXJlN+HL36tZBgDGQ5oQZU3e8bKvm03tZUacFzNjRifiJtr
	bHbDmDs2qTOknUlgdfP07+vBMa/KU5BbuYYAx5R7OH/sfWvhT8UGv8Ls4voys1V6nS3enLjPpI/
	VdFF5nSvby68asYmAS+3QRFuGrmhqp0zc7H9iOW/osJ8Ifs2190Sa/3szuKrD8XDnPqVufCfw2i
	C85OlhitD2+CeeRnldWFMSM9fQpDxJ7rwl+xOcsCEVeaXliDiSCHvBkd8s1ND+zMEvcTMNeIzvr
	MfdU0hlLPK4QWOMi3pW8er7QYXqTr2MM5asDYDn5/5LlYoPtmvWpBbKFyjFNHk9kcw/jSgaJmb+
	KyuqrpWs97KYJn4usOml3A4cYIvldU2fBK9DKiiSiARXt8LRRRZ67h9RJQkjDaecInmg=
X-Received: by 2002:a05:600c:470a:b0:45b:8b34:34a5 with SMTP id 5b1f17b1804b1-45b8b343742mr91308155e9.23.1756886425030;
        Wed, 03 Sep 2025 01:00:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvBov+2sCYC8kUy1LMz0NKTPJSNfIKJ0Y4Pc9pD6sJfPp+mtZCtKL911g00Hjd0GsxF29PUw==
X-Received: by 2002:a05:600c:470a:b0:45b:8b34:34a5 with SMTP id 5b1f17b1804b1-45b8b343742mr91306835e9.23.1756886422976;
        Wed, 03 Sep 2025 01:00:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6b99sm310327755e9.4.2025.09.03.01.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 01:00:22 -0700 (PDT)
Message-ID: <734e09b6-9100-449f-aa77-75a18b634db2@redhat.com>
Date: Wed, 3 Sep 2025 10:00:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-2-ryncsn@gmail.com>
 <e22b8472-6d20-49b4-b49b-78f79f126294@redhat.com>
 <CAMgjq7Bqffjm3dTZ+bHALisCkw7ASao_1h4ZZVM6kd14YdKzmA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7Bqffjm3dTZ+bHALisCkw7ASao_1h4ZZVM6kd14YdKzmA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rb8V13x6OUQ_XfkzMp0RTKk5VmCG1IFiAfOR3h45n9k_1756886425
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A90A100013
X-Stat-Signature: wf61j3qk5o6m1ke5xdso5s7r1e5qp9rx
X-HE-Tag: 1756886428-631307
X-HE-Meta: U2FsdGVkX1+I0BWOhmie/bTRIXiE4A0yD9qFKbsfs0D2/KFsu+J0ld6G5xvZ0mxuSeCDSzMcD/F7g+yHf1s4QnX75UYtdKWddXJlAUM/tqQbImgLYKSJ+/m2kkR4zVPaEBoP0C4WQUL97KlWFSReB8aAHN/qZK7Wni4ka8e/ZdM95bUcPcEO6mB5s7ZVl/nE7LrxRqePbZMa/VaaIROJ1onrk4fvwprYQcX/MxA/B/NutQRyU1NDa/Jqvl88xzeY/wK/FJEnjZEwTwHx7bXveO8EPCUnBiNYxYoe564fcEU0znn0HR6Ral7cHzDFli5x8hOLI0sM+nzOzeQ5aw/v0IB9GqUIVRk3lmZTPBc/jVX4ksGzt0ZHhsPnzxw/ruWj2iJhQlXAGYI3GQWBO/6yv+TJfZ12/8v271Wdpn45deL7IkbZDg+wIYF/Fs9xxlOHjaTl0MZJNdN2wjcanDhpWkVUofLuIsC9WSq8nTC3z0fGnD/Uw6t6m2hGHzDJkmSw+trCO3ZUS76NQGUdfHicefHYCZroOIFhCBt3G2veePnG0xafoAgWrt54KcEe5DipHBxE6Vl+H76F71JIHwkd4TWhjQBk+LcfNg/axf3M8cbHhQGR8BDQERTqZqpRtEIS1u2bzOnnH35n4Cc8hQ7APEbYt7NBXtpqXtT7Hz51g9z1lfrzVysuZ125hyVgWb35oF2CcgphC/kFxnfTeKofP9cSgNbjPb2+WvRXNELrPgO9zshXLRLEhLR4BwKbB5M0Bawlvr1bGenTptDfKK3SWeTzocH8F7nJljNmA2VQuFvlqC6l50f3jiDm2NOcBhwdgKp00NF4Slf3AdcMgW5DPOAoWOu8dd8U+pD0GMb8Kogplst2hzTJ1Qn6m2Xt5qbyoIXB8GMmJR8F5ya0kZDPve9zkByL0NIhtFXNCYoVAwm6e6eR+YFtAEdNxooRIjosayqgXF7XC1yy8LnZR+O
 dYR18a0A
 J0ndLyx8/oRW30ZH8nuAsjM3w+TeSV0PEfHptuI/VivRhmwh2/Ii5CANZ9bNOCDRIP9SlOqJko92iB//Y7hBNZiQpa1UMnAv5vREUs4Urpx1CRGeOR9WoVqDj2C/zffTDB1KdCVcYW8WnAF6RhkU+Xuvg1z8A1G7YD2PZC7iyK0M8J2ppyVMppJ2C0crBFp3e2MG9Q06awuCPIvWQe+CyWf0rsexUM2hcstwHN9LGs2CFwBc0SD95ahbRhz25Ul036rlYNXsOJ4zH9hva0K1F+kIWLSoS2a6B5bMTYufufMNGh2xhcST1bjC/a26SjG+a7fRynln8bWjBkrSRX5sRKi6igIoXIHAs/+GhLnaIJTCciluSwTtajkxbct613i5QN6UPK0THsDvC31OX9R6jytHyqqMEsLpkRqOcoX4XgDfiH1u3euItMi6q5h0/de5/WSseNbDsz7YGOnbByGvpRGEW9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 19:13, Kairui Song wrote:
> On Tue, Sep 2, 2025 at 6:13 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 22.08.25 21:20, Kairui Song wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Always use swap_cache_get_folio for swap cache folio look up. The reason
>>> we are not using it in all places is that it also updates the readahead
>>> info, and some callsites want to avoid that.
>>>
>>> So decouple readahead update with swap cache lookup into a standalone
>>> helper, let the caller call the readahead update helper if that's
>>> needed. And convert all swap cache lookups to use swap_cache_get_folio.
>>>
>>> After this commit, there are only three special cases for accessing swap
>>> cache space now: huge memory splitting, migration and shmem replacing,
>>> because they need to lock the Xarray. Following commits will wrap their
>>> accesses to the swap cache too with special helpers.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>
>>
>>
>>> +void swap_update_readahead(struct folio *folio,
>>> +                        struct vm_area_struct *vma,
>>> +                        unsigned long addr)
>>>    {
>>
>> Oh, one thing. Regarding recent const-correctness discussions, "folio"
>> should probably be const here.
>>
> 
> Not here, swap_update_readahead does folio_test_clear_readahead so...
> 

Ah, makes sense!

> I'll try add const to other places where I see the folio is const,
> thanks for the info!


Thanks!


-- 
Cheers

David / dhildenb


