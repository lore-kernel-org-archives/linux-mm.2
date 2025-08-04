Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67117C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0805B6B00C1; Mon,  4 Aug 2025 08:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22CE6B00C2; Mon,  4 Aug 2025 08:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEBF76B00C3; Mon,  4 Aug 2025 08:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDACC6B00C1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:48:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A9DFB8059
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:48:35 +0000 (UTC)
X-FDA: 83739053790.10.EEF414C
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id B72CB8000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:48:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RUgs6kAa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311712; a=rsa-sha256;
	cv=none;
	b=sZCItNoUVXF2504OijcdLUJe2bbypZRFzkxv6MhwdEpiZu9ahXXNQjbFucTJhfQYMyw4uB
	zQ/lgnXFZpt0nkJOIC0FYI8h+B/V9cD7kZU1/1i5i6ysu7WmtLMSazP9PCvCrcSIJH0SNL
	JMCBCg8GMeS/Mnj6FsRkI7KaiAlRQtg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RUgs6kAa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311712;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCUkUsybP0r95Xn1B2ng6LvjzI31oSGDocoPaye/oQc=;
	b=PFyF0O+rL2hrXkiCI8HSJcEYhEeF4r9YUoutSII16KK5V5fs371nzNpDnr1+oKHLMacUUG
	xpwcPKlEmlkHW14LUhFfdazB6LButDGafCr6vffzFfAGLXNYdnSgu5VxhqY8o52+7SB5Bm
	Qmf0MAgECq3YPkyU9EJINtSwfIpajaM=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-af910372ab3so847080166b.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754311711; x=1754916511; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCUkUsybP0r95Xn1B2ng6LvjzI31oSGDocoPaye/oQc=;
        b=RUgs6kAaF8+T8XwKfy0fKD4nSSg8cEvYuAGcohQbzOGHvrRB3Cq4WBvu8MRxv0QvyB
         b+3hCm1hcbixnph6pDtqyuiDT0sxygHv1vxL/AadpEhpOvbqQJE2Uagmq8rXvYF8xd8n
         XGmVorQYfmYAluGhjUbBf8jFtKjiE2YYhFXZ66+bCHRosuAuydkTcxaUioL5DPUKl3DN
         kLiAbJPYOLwaRFEmeh2c3N4XUNZDNmujMjDq6KelJwxf4CR1QjpjBmtKG22qmlOcRixC
         fHgJdpuoEaHHFsw/EhJo09OxQqh1NJzPJEC9hrEPk275On5I7yN/6n5ABQY/qhs+JbVE
         twfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754311711; x=1754916511;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pCUkUsybP0r95Xn1B2ng6LvjzI31oSGDocoPaye/oQc=;
        b=v5J6ZyW5c0GtiT12wmXtXmYy0RVxuKW242I17qtwi0VKOi3Z31xGCM+riHe4xAhE4q
         EoZx6cPa1qRQifyXZvRAarDIY9D9TIuNvcaVFy8jix6vMb2sOj4BlqRlllJzM+d+tdxm
         81y7HbTyxALcc4ogvvMoR/16Q7mVVTwjWSJPdtRKJd6/wOB40yCtjLLLaxHRZqjbxFDy
         LWUpRNnfaaTnA5PNYG9xphI2i3LdSITKDoxGxy0vE/nOEyAMvbYJk2joV9eX21zbVxtU
         fEuPBsd3Lnc9NkWNryWZOvF0l2MnTvFUC9yqAQk9SEdL7fOW/Yxb0N2pKB5LpB1WF2jK
         i5vw==
X-Forwarded-Encrypted: i=1; AJvYcCUg8VF4K9NXNPvF0CsO1xOPg+8/ACRQaNq0WxntY4AL6pM51mm77pYfPhoIba+JdB6R/wtY1GXWAQ==@kvack.org
X-Gm-Message-State: AOJu0Yzo+LBjTCIikwymI29bOBMzx+Fu6ggONVcfh+NWTCY10OJuQnAV
	2djksV6SKcXWAG1QX7HkS8oGEmANYCUNR8AYLgS0UlatFQbyhRpVy731
X-Gm-Gg: ASbGncvM+KVQ82MV1SjWMzTW2zzr+YBFoROqfQWp4S/AR2T3+1TDL0+7p22XFCC5pi4
	MULBdJKuYZaPfCsO+O/I8fWzDmwH9w/rvUrqDigooZ4W5rEloXN6WSXEZQyRg8XIAHcGQjbRXRY
	suWJPAKx4XnzT5oJxk7k/xNDv8ncKgb287lcK7upvEoFKo3QTPvmjuvQ59URTpC0CHxFRVfdiqi
	BhYB7jmAtoHmf08GTXL5KgWNF5W8Nr2ydwJQIp7+/UIrM3K/K2pEFSgxIAfjFQhgqUSqd5T6nGI
	ItQUi3NnHV81AOUk3j6fxyTt1ENA2Y8wkhH2ITZaIc/mBAhNtnKheyq5lJrlv/X3qBXmIoSizO4
	z3g0mdSoMbUBwsZAMVTHX/nD4x9OEvFFc
X-Google-Smtp-Source: AGHT+IGhdZsPt9H+M8+u1du1qZCNF5yi0T2vfwoLRESy+FbyKOjYyO+GJmVHdBr91ZmkGeRynPPt0g==
X-Received: by 2002:a17:907:3cd2:b0:af9:3f53:ed1d with SMTP id a640c23a62f3a-af9408a1522mr1016946966b.16.1754311710964;
        Mon, 04 Aug 2025 05:48:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0771ebsm741669466b.6.2025.08.04.05.48.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Aug 2025 05:48:30 -0700 (PDT)
Date: Mon, 4 Aug 2025 12:48:30 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH] mm/rmap: do __folio_mod_stat() in __folio_add_rmap()
Message-ID: <20250804124830.6ojifqbiisy667re@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250804064106.21269-1-richard.weiyang@gmail.com>
 <d297547a-a0f7-49c9-8d5b-5e7d6fbe1fc9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d297547a-a0f7-49c9-8d5b-5e7d6fbe1fc9@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B72CB8000C
X-Stat-Signature: cdton68nyb4jsq1aqow4sr46amz3t7kd
X-HE-Tag: 1754311712-80155
X-HE-Meta: U2FsdGVkX19HCVOnBl31x/HMp5qEzmCapXskn1aGQzjduNJS9e+GkbXiQEnfdslAqquUDw1MbNfr6thlHtUvbAGL/BKifUBJwpyFD/boxlY51xEUWHuczW2noIXNF3D9O8czL/H79CJYVeP84h08nWl4egr11wU7WBe7IaS6ywelDn2RUjYHuzaTQ5M8jsYRoPVszfr8/O6grgsN1gqBNz2gfke7B0hCGYy3LdKUTbU9WhMb5gUoKdXAfKGFoVRsdr0Z/spTh/WpbPD8ZeaS+yHaCj+x79UKaH1Lo4NvE/cEjr0O+2nDkq9RkNTh/qglTHRGb95s981n9/xSfaFSJ56z7ys+epo7bgn69gZzdxiIPviRPlIVNjK/RG54xeXVoSOpI2nuiVenXnssT+Whavy/sfPF/+tizjxzL2VnniFK8DrS382PTHLaQ82EtjBdawtaAg40oH+8g+AcoUHpUKNzNXf09L3Q06GI1ydkG/GHKNECA+EIc5N/IDyHbp1xJHSsyq285wEQgWE01vUm4OBdkKks/6xxVaYyfrjxxfABmEEGPYYacaLE+tKgPkIASz1mK5O46IGntkE9UcMmdl7LfDrKSF+en++yCXAfcpI6JfGuwEyoKT6zin405V3auiabUnDjee+wRYoC1fh5wCZfNeLKSFukmdeRNIqzBT6s1UEqrT/MHjHlHtsHSiFVLqUd+0zlU4PttwwC46jsremTRLOEA+fhjsSWRJGvmFMX1dCpvod3MNfiB9Orw2q2PDqQQtDkeg3p4kRpslBQLoXdBvRKljYyi4N2MKJH16i9Fj12XanmQPrKqu39CWFXGQD3Ae0/7lJJDOHXOUvEs7Ek4zbthKKT7RZQuCbhyounRXtdGvX70EyBtBJKs3JLG39MXTUsN7JSPP1J/vN9GFnVlHudbwei4oKUH/y+mGLv1qVTloGPnv8Nk6/bGVH5QGgrx97g/VZc14dchbv
 sfPbtMXM
 2W/nmB9z7CHdbV+ZKcLN1YQ44cJ/2JZSaHAmVb6VoxiYhMMvkOYOWY5OZsmbpq5r+swQ2lGtfonsIGQy5lTPHEEawXImNCvJZLmV/eulicSp0h7hG5rWPUotF362zBsGsLgdR5/WKJBrNZ47aHyrKsltvOHAPDb/smi79bqaJGy9LoIz9/80pHEIJg1Fu+B/FnD4aROq9sbriIZ0uSDjW39z0MdwmvXj7gwNQBz0WkXWMaW0TUzoyjAtH2qmhm1sbCXd8d6XlAXq9b4gYOL+eCuIU/0d5p1OaeQtMS/+sbtsTxk1/ruV2IPcZ7mCISCYHi+LNEWHEFE8kM44vB/F31NyPD8FRmhS0xKsl9x5jALNIZ9RMVlZyjda69s4+ZRt8giAlTue6o8sNrg/hbwu5cdK98A/s2dDq2z2T5qP8qD6aDI2bhBAGr01HCdeNZOSb4GDn9k+gSFHDJvn9y0JrRHh4d61RcvceR49ZogUhRfoff6t3TtR9iRV4NGsRK+cnU2DlnX81iLMLoqCiWny9h0zEFCpoPCRNLiceFBjItMsk0XVLfxVaEfemkMsnQcwx8r/+noMiRK8BR/60KT2tQiuLgaaU6AEXaHmWUtknQirqsPJJO/09ftH+5LihD3fDZogDcjalcNUS/3p+jnGXbwiJX6VQoPOG/bx04B/zarDwrj/ws1IRJ8nnmJPczogyMLAKRnOGrfpvH+JEXXqno7R7rwu5ot1y08QNynsGYtp2O1LOoFrGAwkAQ4csKcih+S6Fm0zaSceTWTgX6LIObDYJ1LSgzJP5yATUCawWsZDaf8w+oQ4DBD0rPeAZuEJSCDAqrRI4RmXcAVnjwCAO8iTtCDyKj5555VHncvZ9Ca8xElOdajs4+oJ3GIGQySGKk8H6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 09:43:03AM +0200, David Hildenbrand wrote:
>On 04.08.25 08:41, Wei Yang wrote:
>> It is required to modify folio statistic after rmap changes, so it looks
>> reasonable to do it in __folio_add_rmap(), which is the current behavior
>> of __folio_remove_rmap() and folio_add_new_anon_rmap().
>> 
>> Call __folio_mod_stat() in __folio_add_rmap(), so that rmap adjustment
>> family shares the same pattern.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Rik van Riel <riel@surriel.com>
>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Harry Yoo <harry.yoo@oracle.com>
>> ---
>
>Looks cleaner and nothing jumped at me
>
>Acked-by: David Hildenbrand <david@redhat.com>
>

Thanks

>-- 
>Cheers,
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

