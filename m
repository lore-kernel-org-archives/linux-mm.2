Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B083ACA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121FC8E001F; Mon,  1 Sep 2025 06:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3678E001A; Mon,  1 Sep 2025 06:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC728E001F; Mon,  1 Sep 2025 06:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5B9A8E001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:10:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E18CC07C5
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:10:56 +0000 (UTC)
X-FDA: 83840262912.19.D3AC733
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 274E8C0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:10:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FqsaZk1n;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756721454; a=rsa-sha256;
	cv=none;
	b=YVIyiZeqpnfyRe3xcvfV6IXyegFw4p4DGdom2FXW+T2LXHqYLApNqIsnttMvq/1P6P+YU7
	tWgjyKWPJFMOVCarY/CXRXrmdKaQqQ+EEpjsXdVub0w6Vkcoi1PadoyECJ8aJJ+7cdNCOS
	c/BrFTdruOSaDFnqBRY0MkOvpKzgFXs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FqsaZk1n;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756721454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1r77G1I+YAhnNLUu7tbtbLLJ0PDDPLqHjMHvRWNWBs=;
	b=sHPSFlXUm4Yd00BOMDIGMiVmXpa04+y6rxnLFQco2CUXFXmCfF/PhcdMaKBBjtG02bt3tI
	6MCe4FINkw74YKQoNKxAD55znioyCRl52ZO5kz8mJDlzppQQHTHeDSs6VYzCFPDj154rah
	lmH7u1oB0YU9Vd2mQdCI6hpzNY6K09o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756721453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x1r77G1I+YAhnNLUu7tbtbLLJ0PDDPLqHjMHvRWNWBs=;
	b=FqsaZk1nU7ODNdVf/XwH9WkJtbFNA8s5sCe0k05AEnTfok/nyLdm6mow9TqYbqvcg2Uu5X
	T4G0PqeJYqdyd6aN4HLncDJ3FVWAFzeUICBX4zKqigCyK/BX4wp0AenFNCm9lOQ/AQJ9up
	Rhgj7BvM1cPeLnzojtxa43JasDz62Mo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-OBjloaP1MaCm-H9TZ7yEpA-1; Mon, 01 Sep 2025 06:10:52 -0400
X-MC-Unique: OBjloaP1MaCm-H9TZ7yEpA-1
X-Mimecast-MFC-AGG-ID: OBjloaP1MaCm-H9TZ7yEpA_1756721451
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b7a0d1a71so34819495e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756721451; x=1757326251;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x1r77G1I+YAhnNLUu7tbtbLLJ0PDDPLqHjMHvRWNWBs=;
        b=TzljJi/CD+17DYwLTtesJbsH6w/suivN58ZdhS1Jdh1pfbJaf1txIn1Cn2Pyk9MhWn
         VkXyerfzcGyAY8hRE6cFoFSsZHiF6PaRkNDsWi1V+iiKgnM8ZzozvDUTGX8iPdD/APb3
         mV5AoY26hpv/9UWYKEOzAgUAVcJuVgTG+mMFzx9lRwWCwcubUpj+PdlhTbO2ERp5b/74
         y+uuVW53hFy8vYu6wri2YCdvSOOdmIq91l5/iYCtXZDDQCqMwXGag3DAw/nX8rs5ZFaj
         8s9qd4/tf5EREeRTF8Ia2/Va4HWrVSzfyrpLEA7OOKJQb2H/6YOouJav6brzZxRafWlq
         TRKA==
X-Forwarded-Encrypted: i=1; AJvYcCVcuMT9I9r+lFDp5d+r2Gw7Rqtck7B8mYdcg0vxr3K9IfSQLNuZMyFutyaPlIenJTn/ACDfqU4x8w==@kvack.org
X-Gm-Message-State: AOJu0YzpWHnxGtLXEerapLfq2FGP2gG7Gu0I2fUg+6e/QmFe2R9VUhVT
	/izdmrYqOcYW21Fy/e30TCIv6L/MCkE3CGHbOqtUC0zB2vPhjk427xSdf1EiDtqwdRrPbYo54kU
	cBf+TN1Dp/g1f06bQNzxsQdWi7nuVAC0dUIuGY/8j9h9eQ++8W3sl
X-Gm-Gg: ASbGncsRZt4fB+pR2Kgv3sk1fYSslLr8Yhu/c9LLt1R5CW0pqWgY3Pcq77o5X9kRxPD
	9Y0EEornz/h9Ca51BnSW9HhTcE1dxZjCGTOw21jOTMGrlGkwhlRt63j5kYHryACjp+bLFDABBjZ
	0Wri4aIzAEn84n3XnJ6xygy+IxaRj2xWIBJNr8Dsobb5RHKziFvNxl9fMNTtAp2+hayfvkUJmJw
	6Q0NrKyl/NJ++b5jC9HGqC6N44UXZtSIfflq6KxK1dlvuYB6j+GRNc6wAHS/Qb6e+HZiNgejhoA
	WhfCardlAeCCIi67SGt88rCrvPmR/2oc0GdyR2v85cmoo03leJy0ZjUFIzMDqeai9wu+nkS0oWg
	FKSANbGhjVFU6SJY9WuzqCQ/5g6b77K7HGhCk2t9ofkofn4DQL4oXHpa/jkl+pWBouwo=
X-Received: by 2002:a05:600c:4513:b0:45b:7d77:b592 with SMTP id 5b1f17b1804b1-45b8553365bmr59920585e9.12.1756721451072;
        Mon, 01 Sep 2025 03:10:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/pB/nOXPtBGdoQkiiK9Gd1JB7dU2H/elG/tgXsoU6tepvnwbb4MgRHWoeOy6qaR11jLv+LQ==
X-Received: by 2002:a05:600c:4513:b0:45b:7d77:b592 with SMTP id 5b1f17b1804b1-45b8553365bmr59920425e9.12.1756721450637;
        Mon, 01 Sep 2025 03:10:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7fec07sm147030765e9.10.2025.09.01.03.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 03:10:50 -0700 (PDT)
Message-ID: <9a85a903-ac8d-4198-a8d4-01d70f23b443@redhat.com>
Date: Mon, 1 Sep 2025 12:10:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][v4] mm/hugetlb: retry to allocate for early boot hugepage
 allocation
To: lirongqing <lirongqing@baidu.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, giorgitchankvetadze1997@gmail.com
References: <20250901082052.3247-1-lirongqing@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901082052.3247-1-lirongqing@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 87m_GHpk3yHaVbjC1240B0uiYPW1xYpE-v2snmFXG4g_1756721451
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 274E8C0006
X-Stat-Signature: urh3xpygmm8rrfm6r8fqs79c8hrghy6g
X-Rspam-User: 
X-HE-Tag: 1756721454-429291
X-HE-Meta: U2FsdGVkX1+ajqQiyO1NBKDrwkO8DS7FWkN85KRTbqMQaXg1SZ/OnEBVuUebAuvTV4yRaJPhQBnaSrCrLJeHmYHsnOhfKS24WeWMQOZLyYHFGBCx+XOtjxfHYq4qocsMqua7CpalRjaDGBaRxB2se5EBE4sr9pcbydJ4qH81bCJm0R5buAxHEegwLDYBvOasdHyPeHTBMLRQDQM5zh2v5mgf9Eg/vf83N2DaCwKhTOZsZuEwZBHI23I2uri+jGzq2YLGkVvzWyuRLG3L5W81rjwfuem2sLLQW50JcPEkKpxlzJztUn/2DrgQKvqLifHafHGK3JDCfBBNlh2be2/O+ur3q6iRqB4VR3V5ep9+ryxMqszcEG70aNhFE2s2uw4BRLT8msB6XQg5wvQHuxU4NjOYXOfGidC3vzGE4uvk5c4tGfUA7G73VAbMAxcMgrlx3N41MwXDZTJlanUEtL9QqiuZO/tE4nd/XH+r0DSCucSOEYpLXeTsvQfyAFNWFBBT4eXYaH+Wl3CRSPRE7kAC2IiHPJiON7aEOfTgtfiWl7KUFUgb6RJub5QCPUjBVjGtnNdJ+OSplXlH4mtWYL3LMu3C/7O96VHtgBn9cI6oyHVhoP+3PFg3eh02rYcK98Xl2oVfIZxf7HnXZVkYL/Ly3SKnT7JKOq0B417xfEFU72YDAm6PG8ifeg5Z41lb1NLALZN7zAbpXgCX2U4eLMc1yqiznKcx58hWuCWH4TH9vtWK08AnrEJCAMP7pNHEINhm/lvhrEoXdzDAqOJ/hjlNXfIFpelyTcRZRwTRLGuH34Ea3Hjp2PpKV9MAMpR8H+Ub5FnOW6t2IOB44+GO+VraBrXdrI0GNSuHbLGsN9kdBaCJq+YS3I6vJIAqnriqkyTJ+m8g692sT0ZXgU71iBkk9sHTyM7+WqOfrwKkM5YAtXrglQH9qk5ErVuD+nb//8BNQ+mLitfy4EVJ0HJZqn9
 QEGLE+Jh
 UVh7ZvuMnTNkmNh6Pr6bsBqDjCtNFLfNDtuPdGq55aVqj69cFRPATyhtPGE41JEbHlteXTGU+axH+1MznA3r9yQ34eY4MWClLtw6WjBfIq3c2DEn7XnyJe4PKh3K3EZwUep3reacs1juNBlCRJSwUsHbSYfrxanLcDQ+7bZlwX421EQqtID5ODuiXWkwi7P/rHXEXAbExBm5bkqahokUgyWxYcxZyo+b3qk+Noz+K6iCJYdzOC2WIgZDLqi1BnVkF4Z6DnUHFuxV6PWlaKLgTgGzEVMoIawBqMGe9znUbIrVJSR4uXkXeirV6prHBl8ZkSaGBiQg390wMMgOm/wvdSxp9F23GtKUWcbUrPrlLLVyKxASNlG7HZucxz7GD7FSXUfHs2fFCoCl0rI1SUXGuSpkIgRYAAgAR4dDV4cA7hKN/9M4+Wm9QpSaCEi/KVZTsRslbdIAEhX2w01+egJHWRiXQK2oE020SJWiRbexNTcj6Ox/IsoXj2owLVxqS1VO4PdDnRpN2ljLj8usBcRZkE3SOhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 10:20, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> In cloud environments with massive hugepage reservations (95%+ of system
> RAM), single-attempt allocation during early boot often fails due to
> memory pressure.
> 
> Commit 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages") intensified
> this by deferring page frees, increase peak memory usage during allocation.
> 
> Introduce a retry mechanism that leverages vmemmap optimization reclaim
> (~1.6% memory) when available. Upon initial allocation failure, the system
> retries until successful or no further progress is made, ensuring reliable
> hugepage allocation while preserving batched vmemmap freeing benefits.
> 
> Testing on a 256G machine allocating 252G of hugepages:
> Before: 128056/129024 hugepages allocated
> After:  Successfully allocated all 129024 hugepages
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---

Thanks! BTW, it's interesting to see such extreme hugetlb allocation on 
machines :)

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


