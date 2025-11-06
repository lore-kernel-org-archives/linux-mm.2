Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 469A3CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8828E000E; Thu,  6 Nov 2025 06:08:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A2D8E0002; Thu,  6 Nov 2025 06:08:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668948E000E; Thu,  6 Nov 2025 06:08:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 512F78E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:08:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06AE3140682
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:08:05 +0000 (UTC)
X-FDA: 84079907730.18.CFBD4B3
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 042E216000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:08:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D329YOQY;
	spf=pass (imf08.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762427283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KemrrCvE16IUsPvIdPc7ZklZCJchRhA/4dXIse7pcqc=;
	b=rqWI/uNcn2w0zyrCeFTR3ruosafDOJgec5vxlxNHjvdrsEi2VhNXa8NcCRn0JdKbRmn0J5
	GtoiflgIwbj2UkKudmj6Us7X9nYiG0cXHEcHwHtZMGmdBtkhyByf7ZKVOVuUg6RQPgblIj
	HYfFyUHMSO1fbvLpvlQZvSbjX5WOgBg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762427283; a=rsa-sha256;
	cv=none;
	b=cqZQQbk698YVf+GBJaK6c/tzYrl5giORCRZQS4l5OOA36xmLuZZPV+v3GqZN4rkTVxMYVL
	L/3+ndCTZsUbfJndCnUY/pbiyjQ/nyhwko7Rb4Pl1XVGtPRlFKmRf4ENDqWUCSbGCLBq68
	oq3xMhpyW4z7JkcEEgWJsso5tSjrRho=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D329YOQY;
	spf=pass (imf08.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-429c82bf86bso589441f8f.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 03:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762427281; x=1763032081; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KemrrCvE16IUsPvIdPc7ZklZCJchRhA/4dXIse7pcqc=;
        b=D329YOQYCSv0TcAFgPeiOvDLujGfr+ZTwmMHp46wQYcAy9r3L1e5HYH3zWhUFOP8vB
         l8pVkSv7cSdejcHpptCJKcf6+pOU0qHcR6wmY3EjdSRDF3PCEGbHLc/GRYfh/wJzPyId
         YQefCmyYHI6vj8XL/0nYOEXnPghSo2ICXsD84IdS19DikAwkrAW+5/DjzQrTGULCdqrm
         VlgVHAS7q4upjaUMrYEP5EgVVXrxX5ArSFEe2o+KoQBXzMfIl/I+hQnd55GU9gfVeibI
         zuUgdIx9pYxzqGWv1elHpbRxFnJ4YBHY8F60ysbqzSqAAIIguuomKZm1aJluLCgJ7/QA
         azZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427281; x=1763032081;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KemrrCvE16IUsPvIdPc7ZklZCJchRhA/4dXIse7pcqc=;
        b=u+ER1BZEshEHkFsypAqY3T3YnBGJQCYrnW1lsegxDay14cRfB1O/GpJShJK/XzYcfw
         TsKvXLZpcGmCZLSPsXiBNaxIf2aUG8QHNsFQKs1k0KVzXb8Kxm+Qq6OpXIWpsoCbb3Ds
         rIZMJ3sKYizO2zLYlqEGi4Ki4R22fYzTm4JuKt1l1LlCCmYJF1M/hKRdmT73T6ljfSWc
         2nbTdSjNnWEe+dL9NwxSr88IcAv6dgmFsgFvEDEgYOmBDqzfXNzpOsSWmgmEe+sY3Bhr
         HzwkNm6Lw8LrRitYOVeV7dO3eHUU2lepHCQD8BtD5UCP2lUaZrIShOtxaZ1+FTO4JrX3
         R3nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJ/Eoet3Pd0FSaS0IpLZUtbh1XJ4aAGTJsI5vd5SRzVfHwavvKLdKjUF9Fi1V/cMFvbq0+I2w1NA==@kvack.org
X-Gm-Message-State: AOJu0YzfhHMLp8pFchwglGSE9nG+KdaRFA2apZ40homct0xq2KnovQ3V
	Rnu3wtCoMnH+cEOiHbT0hMyrpnz7HLeLsE/kqjU77UeA5FysDih+tluv
X-Gm-Gg: ASbGnctG8IGbMhGPfLABNs4TxPOOBYEgsDQEZGZzf/3J5EdGV0vzD1CZrfct97MYXQc
	KbVxyXQMA9LY5RA2oUAAzZEsntwGK+gVR0bgFDhE9684nNe+9hQe+4kVtihdDJDT8KIFwUQi9q2
	qakyS010sYCb11KEcwYa7ybZc6DjH1sg1FBLnb7RZNWOrbc+jW+r1CiB5lrbxMZa/DhReaRZjc1
	sV4u6wXSWw7okx0DrqC8k1lIUlWRpFFHOAr9HmOJ5AJcrB3+w4wUjAOE4/D1CWg7A2AT2s1Ue7v
	yn5+EDVNOtyj4z+Q2M3CvA8HtO98zHanW2FUdKrVU4l3AX9BmhOUO1VJav7CWu3J+Hs4wQH8+M1
	9ASuFVN1agcymnYY0VKfUiNp05IxPnxvvTnQpbZeFMk7UF+eK6KEqruy83DFoG5xiId8PduVAOH
	p8sGzTEqLIsNsl4qz2y5XSOEqt0n8VXE1jnxLeJvKzyzAvq+CjhFQ=
X-Google-Smtp-Source: AGHT+IG/WPvgkkz5ima282cKyz2di1ByWQE6/QNBfZEdI+atynO653MZ5MMOXdVnpoH97C2BXp1trA==
X-Received: by 2002:a05:6000:250a:b0:426:ee44:6d9 with SMTP id ffacd0b85a97d-429e32e3595mr5318368f8f.21.1762427280858;
        Thu, 06 Nov 2025 03:08:00 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb403849sm4648357f8f.1.2025.11.06.03.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:08:00 -0800 (PST)
Message-ID: <785c9d27-23e7-4ecf-ad2e-202ba506f2e0@gmail.com>
Date: Thu, 6 Nov 2025 11:07:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-2-byungchul@sk.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251103075108.26437-2-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 042E216000F
X-Stat-Signature: xibpxerdws4oq8g9m1b9jxkn17pq4pzt
X-HE-Tag: 1762427282-558465
X-HE-Meta: U2FsdGVkX18HHsyJTHBhBxxH0zufglXI49mxjeqa1zjKcvMcCsjuASccXN41W9ZMTG8Fa/ITAgI+uxNoWqdSIEuisoXSX3qPK1awtW63QJDBEXPKuUyu0qU31dxmUPnIYIscrDRw4tVd50JXM1qX5yxq++OMWNZFa//W9H37YBTvOPXiwOYNH6L5lui1qH3sb3POnp0Xh9LvKC//M4MpffboH+2rfYHw74Gr2g7VI1o7SdnNlM8veNNproN9FTrTx761pumbVf/1W5PKBOLP491tzfT0wWDh/mdViUsb9TGnqxQxFhENhGsBN4ygAwnnjIHlp/ecMWyFMj1G1DOiePBH4iEvkwsMQN7ZBS2RxzZLwRD/Bj3b5zs7xlDqrZUY4BRawbq/RHsLv13Wr6E1J0Kvhfvy0Y2qrZOOLFP1DyrGtMiJ/F0w0RYLnLoc87TL4kKzOglDPufJ1c5ary+BbUlkgOB0d5FHRmXnGFxaq2fcdv1DSg0qZoLDuoGuIOS+9nYEEnuJNiLuCNXz2E+pG5Ep9hEgisQAKmcYrGA5K/ifB8vDzQQci4J/h4XW0G5up4v4NHhi2JeqOPVV5xoedu2JzMbHwWbzA8p6cnvr2z/1FjBmGx7GrfOhb7lj6U92GNX4CGE7z/l4Fh3R/5lcPp85BxYR4g3cbYkDBCv10q5B/sbUR8R13KN5rbUY+OIc/6BE1n/F1sFZe+3xk/i8hxQzDMU7tWom4jwAUzFOJ+zyyvqYQz1EKHM1+VZd5fy9BYtTcRdDasm2pk1JYgproltKrHdXj2CT67+SlV+pvOWvGHZBOfBO/acz/+2t6dhW+gYhP7PQ4nPcADq8l6QUWkc584KQjnhwbzfh1Y9nHD08iGsnvpK98xasma7xXPQLL1Ab+5Aod6yTp68j81YpjBKIFy65wIurhzWR2XUtuCNcgWxT69w+4JGOFcAcg7w6HINwFu2NAewUMOv3h3J
 LOKWS5Gj
 8324VpGdz9UX0tqS1ce3M1DVROsD+DhBrxEGsVIotnquji3MzvuENyMqxI1Crf8ayb+iXUWkWWX5jXllLlU0nLWEgjPUKty9MayGU61iRVhXUArYxalxCm2BbdC0bD9yN4HpZPlEgVWvy1XS/Iyiu2KNzk4q6jbRLLO8eJyLdUpuV6j4f+AijhX4k9JLPpbuI0bA/x+3+KyBBRvWfkK/VEV6/kYT/ihOmeryijgQ6fdBtZw6O3N3wAvT66y1jvGDLnOiW/l+ZfN87a9KVZsSgzqcCxa4YlgfJhl2qd4P/f9JR8oc5E2yoUzWcpO2e9gbu7v1pEP2sqsbpG9VzJwZ7kzSZcKP4VAcVYclnbyER9E6CPHXZDcvZmAIRywkZFF13mXYWL2075BYeTCwjVb32IJMZ0TSXgkB3g8wvnX0eJvacjGJ/OKx3HlQIh6R/VMZESXjFB6qLGEMY+BPI5QbY4eDfmr8/KYoy26tYAxpSKvfn6fRO1PhkUq26T0zfeuD+Pr85bhxnh9AivQ7q3Sg1stVMeThMcAJSeYcv45JNlunh0I0bTRM1QC00nhI9NsYzV1ES8b2Hv7bbih2amGuI/Hpw/28obUz087TDJvO2stM13YYsm0G4RBjKiEuQGzEZvTXd8USIGVdGoBKF9Hmxa6wDxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/3/25 07:51, Byungchul Park wrote:
> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of ->pp_magic, we will instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
> 
> That works for page-backed network memory.  However, for net_iov not
> page-backed, the identification cannot be based on the page_type.
> Instead, nmdesc->pp can be used to see if it belongs to a page pool, by
> making sure nmdesc->pp is NULL otherwise.
> 
> For net_iov not page-backed, initialize it using nmdesc->pp = NULL in
> net_devmem_bind_dmabuf() and using kvmalloc_array(__GFP_ZERO) in
> io_zcrx_create_area() so that netmem_is_pp() can check if nmdesc->pp is
> !NULL to confirm its usage as page pool.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


