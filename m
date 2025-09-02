Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC048CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8AC96B0005; Tue,  2 Sep 2025 09:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3B926B0006; Tue,  2 Sep 2025 09:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2AE06B0007; Tue,  2 Sep 2025 09:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C064E6B0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:18:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E4C4B63B3
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:18:39 +0000 (UTC)
X-FDA: 83844364758.02.28ADBB0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 03E091C0016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:18:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RQ/u55W7";
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756819117; a=rsa-sha256;
	cv=none;
	b=HCMi/RKq+9Ud9RmG9As0XFIGtDbROR8r4EzINAiWT/wt8tnTWO4Dhhq7iBy/UqkQhFg184
	fCmbi49Kzj1sJxuNZX52bTr8Ivix0m7jfAPJcL9S6his2JNs4I56zy0WFZLc178MpHG1WW
	Z5vh/snO8Tv6XzmSofTS3CpU/LzjpE8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RQ/u55W7";
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756819117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tauw0lGXDfZgbslYqi4AXR3FVuYc5diqrD24hdNXLOs=;
	b=1uutNE4Mn33yJ5q19PEmqgFlwgx5L7Icenxfc0gCMEA3Hp0V99tx+m0iL+P/JAEc5JTa4G
	aZU1pCzUsu3yfEOCZaRBOkJH6GWN2mdkvrB3tXgejKz0nmzakwDwBt+t9pHHoW1pTnt4LK
	aaOuhLmkear8eDVADAYRswz9Agd0UnI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756819116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Tauw0lGXDfZgbslYqi4AXR3FVuYc5diqrD24hdNXLOs=;
	b=RQ/u55W7erY3JvScMV0bMlBQzNVA8pRW9GDnA8PoyMceI28WLOQKicxANZsQk+pfBFXaM6
	/DSNcgCDkYDiVZhtjpFgPT4HojmwG4MOEYaxDjk5QkgQ/vaoQwIgt6h4/YsRYMQg7cQShJ
	3j0jE630mNR+A4/YeluU7mJPzmmAZzw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-4EsAqMenNbqcJeoa-VaM3g-1; Tue, 02 Sep 2025 09:18:35 -0400
X-MC-Unique: 4EsAqMenNbqcJeoa-VaM3g-1
X-Mimecast-MFC-AGG-ID: 4EsAqMenNbqcJeoa-VaM3g_1756819114
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ce059e3d42so3256071f8f.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 06:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819114; x=1757423914;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tauw0lGXDfZgbslYqi4AXR3FVuYc5diqrD24hdNXLOs=;
        b=pz1wNfudE4wFCgblkx9h3g2FDlgO6+2P7K+i7QYIbaBvuIqofVdE7/QgpWOLLAEVzy
         LGJrlknzGoujjtpcjlJT/MJfYWL94JUAUdcBDwXlscqfXbB+idGa/6V6XI93QFQfalKn
         PyHJ1V473LK8ZPVOcahHJaIqj0tn/YebXH0koBiPflYvO5xWNGKX4FOGm7p5KqsQOGaw
         UgeeKcHpWnTSYO0YL7YHGqKRK5CZJVexdrixDzZr1owcI/UjzCtNVqZUS8Zu6V6hkFB9
         uhMKkPjL31DmctN2Lpafdhan9Wnf2JyChjTOQxGcC0G+8LBtzVCTYWPtijoU2qHY/E3b
         cG8g==
X-Forwarded-Encrypted: i=1; AJvYcCWMSEB5eXDlnJWiTMS1+dg75X4GeBNYsq8OollkPxGqSR5vmwhRMbS+A9apy7EyAHMkSWWDUqRYlg==@kvack.org
X-Gm-Message-State: AOJu0YyZgWHSJp4LOyqKxWEHzVfHjJNkuaGBca5ASbsCFE4YQtxCH+Sr
	qPc/Rf7Ac6NppkvnZZ+n0is20D0ghF0cPE1gVFIqK/AolcWGk1PhO/xq+HBrHafv5Rg97bTmnY0
	T2FvdO6UrqVfpcDwM11ShaXAjFS5DqR+SY6UTGzVlCMPkbkstPmvL
X-Gm-Gg: ASbGncvf+GVenuZkZmaFKrgK4tHebEBxVv8Rf4RVj3P0KO8C+SSKJ80oQy9lpJtSTIk
	waPjgmXwBWiWVWLqvWQBp+zLkvVNH1QRASLRA8f1MgMNkryDWnTHwFh+6hGhBvVZWA4SrjpQL6/
	7DdEzqQVDuLcXW3wYBOAax9Xx75QHoT0SwPeXkoSU/m38rqHUr8zYzbTbOff5+A+3xInAf3VOyG
	d3pQuAcaIxi7Xy1uG8CITrdJhTUuGAuLsw2pYYVBrKENTcKJwD6YL9qVpeaDH5oA833g5PXhIlC
	Drff3CdGFGbHsoHIp+us/k7MPli3UWKoonixJeps2fOVS1lEqA8NoOFXXKn5aseqiK/gyaOsooZ
	sPrdlk5yvvJWpI6CoWUwW9hprLpZMzuzZX6GpR9lObgZR1ZXEQuBUsIZKhWjkBZd/Crk=
X-Received: by 2002:a5d:64e9:0:b0:3cb:46fc:8ea8 with SMTP id ffacd0b85a97d-3d1dc5a23a7mr7455996f8f.3.1756819113913;
        Tue, 02 Sep 2025 06:18:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGI1e4lWU+SGZynM55On7nh2fJP5EUS3ZCAumq/CVhgP9Ba7RNCmp3gmALPbTrmLTQCfRpFfw==
X-Received: by 2002:a5d:64e9:0:b0:3cb:46fc:8ea8 with SMTP id ffacd0b85a97d-3d1dc5a23a7mr7455964f8f.3.1756819113501;
        Tue, 02 Sep 2025 06:18:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b87abc740sm132002265e9.7.2025.09.02.06.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 06:18:32 -0700 (PDT)
Message-ID: <8ff181dc-b9c3-4416-88c3-58cc26b174b1@redhat.com>
Date: Tue, 2 Sep 2025 15:18:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>,
 Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-2-ryncsn@gmail.com>
 <c4a729b8-be9e-4005-aab6-91723fcf0080@redhat.com>
 <CACePvbVQGbyO=csbLG-0uP8gwY3JkS73nHCBb8Eq7xNwD=N=9A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CACePvbVQGbyO=csbLG-0uP8gwY3JkS73nHCBb8Eq7xNwD=N=9A@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kvc6x_zVdy6pxHD8BIpmDqnTEZOpP4grkYcvL9TPe5U_1756819114
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 03E091C0016
X-Stat-Signature: x5srmm7bkzxwdnu76fsxq88zzi5jhhe8
X-Rspam-User: 
X-HE-Tag: 1756819116-369724
X-HE-Meta: U2FsdGVkX1++toMHdOQiYvEwxqLZ/t2jOf6M3uExWZCOr6A5gD0PHz0Dkbue9XMXZIQGCkkFQHUGQWmbl6kpBeCSsADPzFWLfCnI1v46ztqkRIypL70LUEdX8UUjJyD+VuormFCHX7TYKftlPrF/PwH2ibK7nmKNobjv5zZFUXfuniiz1aXNQcOBBOMb6pxz8asqVOQ/RQEMwomKdQrY6kkMwPbjCboKool2uJZGu+0oAy6xMN3DbHA93008v+axt5HP9p7uSZDmcSvpKGdsPq4uqPkURYB13KgMMoGgjlJxBVs+iRbOvkrSPjGOOpyKZC+8XX6G+1w5pwHVE05avd/tBR97W3deO39Cxh3XDYYoJSVriL7WjWlwtWYJw1q53dqW+J8sSrnk9sKCRY07D9g+P6z3Fla/PMg9H/j+TKQqPWYuGlUC06hJpMECfYQlQz9ksQggp/8z5/jpmEuGO9TkaukS1ClpzyI+Tl4bwbxmg2duFPrtAIQ6Cj+m7DGBFXeFhp7TTyHBzLyzNBT9KW4YiTbXGXLxcwW93brRf4D1O6TbWxhydWWMaLrutXBk9bpmp3FkqkwE0lPSRE0jHSfjL15k1JXZ39jzsYn442ljosxjLor+NKkAE4iR5EeK2tNJ/fFvLcCwVqNFKu9OklxxNMB4DKn0QFNDOLxGsrlPPB435y8vlXt57OV73idCgw550m/69HxyqQ282egovnoJWJ+3A9QvTkeo2gjMnTfCkIv8/0kfF0KG0h//WnX8u8t1Y/V7NKtxfFs+G74CHTV6vPVQdjFWKcUDSKMyu5aNAcMdIq0Cj2WKlfKCqXTTq3FjK8TNIA2p6oo3AasnDuTRfSSPwjTTahqDQEvSCvOAIzABgamz2i3+OFB5LOnBuOndH4/FmptJmu5tYkUH2mE7Fn+TrYd9FAm4UgVajk99WvcmBLmZY/Oq4YSMfwOZG1zTaEh3/BbH4z+06mz
 ZO4MI03f
 GvQcQZbvNSlkiik6iezav/uan52qNBg5cBWPIdmcdruT9ChWt3kp67uO0Znn4xoVf1rz4OBZ2JmoReGrxftQ0YPDhyFL4oK8xVQswxT+FJKiYQ+NnXj6Nq2Wa1Iagkc5Al/hFMMBxXEaJuhOb7iSSGNv+y/u7+DctHu7KA1tVWL6S07xu+ixIOkWy38Jab9oHV+p9m6wiBjqH9zhKXRspGipJAULvaVf0ysh6uDxXQW8Bu2tBjGp0WMw/ntZFrtaBFq4G0UycMFLGMT4X9O2Oy1hQlog7VK2EWaAUWzw0WoQc8qiTLqlx3hmWhi7rm1uB9zHN5Q+nEJczp6N/JJ4wXJGKRFhG/bHstqqzbTtcxz+u9u/HaiK1f7KPdFtS7R33blluW+NkvqR8qmagNRq10pReNSL9w7WvzVNkJYrnVcOV4TOyWbl7pH+VUbDgtLYpxS9v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 14:32, Chris Li wrote:
> On Tue, Sep 2, 2025 at 3:07 AM David Hildenbrand <david@redhat.com> wrote:
>>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>>> index 99513b74b5d8..ff9eb761a103 100644
>>> --- a/mm/swap_state.c
>>> +++ b/mm/swap_state.c
>>> @@ -69,6 +69,21 @@ void show_swap_cache_info(void)
>>>        printk("Total swap = %lukB\n", K(total_swap_pages));
>>>    }
>>>
>>> +/*
>>
>> While at it, proper kerneldoc?
> 
> Agree, add the kerneldoc while we are at it. Those are important API
> to interact with the swap table.
> 
> BTW, I already submitted a design doc for swap table to Kairui, which
> will show up as the first patch in the V2 series

Nice!

-- 
Cheers

David / dhildenb


