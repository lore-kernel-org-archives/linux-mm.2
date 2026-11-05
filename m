Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164C460A2611
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wTx5tVhB
Received: by kanga.kvack.org (Postfix)
	id 394CD6B05B1; Thu,  5 Nov 2026 06:43:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364856B05B5; Thu,  5 Nov 2026 06:43:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5266B05B6; Thu,  5 Nov 2026 06:43:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCA26B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:43:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9503540989
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:43:06 +0000 (UTC)
X-FDA: 85400879172.30.DBED201
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id A7609120004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:43:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wTx5tVhB;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793878984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1YKZbg8+xkzFjxNfBYmTVfbfxOb/7eggQBZwag+I5A=;
	b=YXY2NTT3/F7EXBfWakApDIRrDTbnARMv3b06CacVVWmw35M9mPmBxQ5dAzA31lsEb3BwJ3
	sElZN/voVt/kdumnKb+A2x8BqNcCqNjjANVC7HxGxJqqf3FzTtBRUAlCo9xTXDaBPJj/ps
	ny8c31H/gHZ7Urr8hClIeYXasSBx2rk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wTx5tVhB;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793878984;
	b=QFAF+ZZMRiZxNxdN91gkoB3G87C3VujGjik3ZmipR43nv/y0QGINg7ad0Ma58AqdZQtC0L
	oIzubhrn5t+9x6D2xUTwlDGfhql5GkHCz+skbEvDRpd4Ef06HFcTR6DnR6I5GnCWNIHhdH
	YthITGOYoM4bab2UIozRh7Adi4tarfU=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso16267205e9.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 03:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793878983; x=1794483783; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E1YKZbg8+xkzFjxNfBYmTVfbfxOb/7eggQBZwag+I5A=;
        b=wTx5tVhBjpWUdl7KUVfMSlqrauHSC6WBOHHL1tN7Lt/CRonGgPUkhRc7Kx+m1AT08O
         1wYII1Fh1NbFz48cPdkQ/m6X5Hy4bODF33gbuQO8paG68s2G1/ca7aoNw9VEI6hL9g2F
         rr+PVhaUcxo8ded6eFu5SoaK2XEilxP1l8QjM5zu9VC+d1hdtuxeHKaaObX4fFTKbGUc
         XJj461okcbxg2xTlVqMp102UycolYp8O0P9/wAc5fRkT13H1n+lWozq1X4DjAylqi7Uq
         eKnXamVdh4lWObieHH9lhNH00iMZMLQaGKRAvrgnJRNLc7DeLgsbPA/ZGeAZyPqjbERp
         qJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793878983; x=1794483783;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E1YKZbg8+xkzFjxNfBYmTVfbfxOb/7eggQBZwag+I5A=;
        b=CnzTWrCZdSxubg8roh5i9DGgOttPaCye7BgkkC0THqPBxXv+Ve1+QHDHBgxkukNp/U
         VNNdg1o4Noi4t3zgoTf2GMCuF4naL6Ex87bTsruVZn9by5BdDMBjXx0HlTtj321JkIdN
         nrxNA9seMHSFMurYsqSRHc+8NJlisBiATK7XgP0XMZvMuiB1XJ4IzHCiYec2kmASY/KT
         h2B+2U9+HT5AkGgsEJbBiAvmnBeKia3EdKD1ndzfdvksJRJbslEiU8xlbt+y3yaXcLCt
         otvE0DaMciSwviqVOEIy/sYjBO3manCUQKx2+A3KJCeNCRM6+hDwr35rBIqPbwdiRTEL
         bzIw==
X-Forwarded-Encrypted: i=1; AKwUvBysXCP7L/luH1I2Dd5EaDNl4lOK6elOS2h2RoIL44Hf8SnBSuHEZCz/EqZ5RvkpUmJoD7kZfGwIFQ==@kvack.org
X-Gm-Message-State: APuU4Z+lYMgHFnNf5SXa8pUqAoCUEUInFnBA68iEbysig+tQKVpuLmyo
	QiiOuMLLHrql1K863ialKr+dFmb/zqrjifR7iH06wFqF2x7NqtiWcYtK
X-Gm-Gg: AYBFou3zrXuqgOAHPt1cwuat8b7s6ohkIuvlF5WZP3He/sp8tEC4+7DdKwOSnLheaa2
	fkFYm9ED+m4C20DtPaTFNK25vusCGXf4YXpep4N95WI9ypOCWMy/myeJLhk0fOtXh62SvYX9m+C
	piOzUEFberGUludwMsT/FCICvjfrKyxVJfmVNU3f35oQYI1PjkFAuwnYQE6nU3DGnBcNGmV0eJ2
	tbilnUuokalCFz8BJmuoW7myKhRK16LyZovjw38lWP5RLHMxsbH/MYYfudETErlR6O32tcQ4RrM
	n9D2vuEdLo0cm5shrQVwPNaFjYmb6jrsEuByug3vvfXtb/xwj8lUxbYycZIf0oGoFZ45BzgOnTA
	Gr3WHoRx9neVkUFCtBIfbymmBzEP2MFRWBkcwkYPnMpnSEK5kHn1FYNAwvTyCkzCe/MfhJaAC2t
	TEuUy6rlCtDfxbUVYkIt/9eJPknf+JinMv6N4jmGosYlkbso7G6yhe9m/xRIuaal7t6s8Sd8xOm
	UCeB8jvrAJdrGoXJ7DHB1L9rmNVzghseavZi8jzkvl7GCvW5bAg2QttwOXeRbFvRv2lVlDo5hrG
	KCc0CyruShNGBA428IBAZdA=
X-Received: by 2002:a05:600c:46ce:b0:4a1:f625:2108 with SMTP id 5b1f17b1804b1-4ac18a88820mr418201725e9.33.1793878983138;
        Thu, 05 Nov 2026 03:43:03 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b413312a4fsm60741345e9.1.2026.11.05.03.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 03:43:02 -0800 (PST)
Message-ID: <e5865932-ccd9-4f7b-bb64-e05a6f7a60ce@gmail.com>
Date: Thu, 5 Nov 2026 12:43:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, vmscan: make kswapd unreserve highatomic pageblocks
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, JP Kobryn
 <jp.kobryn@linux.dev>, Frank van der Linden <fvdl@google.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
 <75540cfc-0577-4d91-9369-d1c4fe9c3096@gmail.com>
 <76431b4e-27b4-4922-bc59-bf97516b40fc@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <76431b4e-27b4-4922-bc59-bf97516b40fc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zesutxe7qoyd771w6zmdo73tgfpu7ogf
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: A7609120004
X-HE-Tag: 1793878984-41707
X-HE-Meta: U2FsdGVkX1+qUI1OsX06fT/QjsO20acqQ46mgtKYs25m/oyXMTQ+eMXtKw/9WbNBdfiV4FtHPWEZBBNgOu8UY3hFvlir6RBkjBB/F54h7pDfTjDe9+k1JaZrme4GlhEJoBsVz54E+XvAbZwdjLi/cEsXI4/cDyEL++4SX+04oJYVEZ+Ki3xhX73wujE9GjxrIIvTrIWZaN8/ew17wBXDAA6Ovyuc5V2WBvwUuysVKDH7oFtJsG+4IjkVj/yPTZ/Fxj9g1OkCs9FKfGewrrdrljPBxwwW8+jn+b+z2W/QC3uD+PM8EeiACbFsYTJVHDOg6p6a9/+e1IsFV0O2poTZS5WOlZYzSWebKuCzhu3EIxg+1G2K1qCuLm8agx5MyaZtEOukct162dbkE/QrIuEd63VoT+7s/wyRwOfzsjPhKHtDKgB3nNnzhVJF3qOrvIzFQbQ5ZUFFdiaDupZL9Kctl/VXYjiHVhTUzsEpOtoqNfVqRPApV6/tz5YU8ZAZbxy79QABWaHuEQ/Cwb9NaBQlQwaO98O9bOkWhbDX8TFlPlUtPu/bz0xxnjGQMBO8Hvb5wapFPlXv11mQFCBEDJIHZemuwnSmMwIDdvaKZUIusMKugFvegFHI0QqVQgp2ourBshe9LkigSmEPkCOqlDv9ThGkdc/LtcTvs5lghNPQAz1rFANB/QYg6odhXLebmZNGJtgwnwUb5iCX/JxFf8glzG6b6Ub9Bv/BKtq+Db9ymoG5sk5PTbHfbK167H1OIVO7pIpAIo1dQfYThqyrTTZOCBoq35rjpJnrcGqSbWRTCPvuT5UcvpSx5pkljYfwqoyXIngozYusFOFQIPYAEFmw6SI6vbqReE/7+dHwVhZCcg0TOALH68xGZ9z6PdfpnfOnomBqVQLVrKVLj3NyKhpuWNjOCYWCmESYWfDCle8RitRYg9wx+A5WwuO6Qtm3QanilnD7tSYn4AzkK/0cqYK
 JVhYvR+h
 R6RSl58XndXMW4uzWbyXWg0P/aQ2/mFkbZGLkbIv8waV0fj8KNirY1w0RaabtPp4vMhi8+qbLvAt8PbWn9VISp2S6jVCGbMVTl7dxHvYwd2mhGVJiEZdzQZkX5j0uQWhd7GwDROsbL6HDz9qxCAabYIhYYx431ZQDJHjua9TGI5cO2Moii1xy1Nio+wJPKcQKW8Ab2Rya/bUKZV+/T/VpYx6YNXRmKFCwQ1GXXTQpb0uiM8fXPOdYYSrNjEhycz+VGNo1FvzgLyUYxwjP27vMknHlW9k/r4qmssM7pmp94O/PjLOrcFP95W2fbIkW6eItAejDRqifGZdSmkm/RhSz10WHvRStBG3uTGzC7yo/jejZRrgkI4pp8U5kHxK6Vqm9xfcClPaa9YcphVFFfctD9/x4flh7aNcCzy1liVgp1Y3J5ahE5o06bts6Ua5CPp2wYE6P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 9:02 AM, Vlastimil Babka (SUSE) wrote:
> On 11/4/26 22:56, Jose A. Perez de Azpillaga wrote:
>> On 11/4/26 7:38 PM, Vlastimil Babka (SUSE) wrote:
>>> Hook this highatomic unreserve to the moment we are increasing kswapd
>>> reclaim priority, as that is when kswapd is struggling to make progress
>>> and it should roughly match the case of direct reclaim failure.
>>>
>>
>> isn't raise_priority true after almost every pass at DEF_PRIORITY, stuck
>> or not?
> 
> Can you elaborate why? At least at first glance, kswapd_shrink_node() should
> return true if it scans the requested amount of pages. So I would assume
> that although balance_pgdat() will do multiple iterations to reach high
> watermarks (because every round of kswapd_shrink_node() will limit itself to
> SWAP_CLUSTER_MAX per zone for sc->nr_to_reclaim) this should not be raising
> priority if the rounds are successful?
> 


it's max(high_wmark_pages(zone), SWAP_CLUSTER_MAX) per zone, so the sum
of the high watermarks. by default that's at least managed/500, while
DEF_PRIORITY scans lru >> 12, so it can't return true above priority 8
even when every round is successful. and sc.priority-- runs before
pgdat_balanced() is rechecked, so a wakeup that balances the node in one
pass still unreserves a pageblock per zone.

-- 
cheers,
jose a. p-a

