Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAC5C87FDA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 20:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E45E6B00C9; Sun, 10 Aug 2025 16:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994FE6B00CA; Sun, 10 Aug 2025 16:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883D16B00CB; Sun, 10 Aug 2025 16:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 739666B00C9
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:20:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FE601DD04F
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 20:20:29 +0000 (UTC)
X-FDA: 83761965378.20.BB8358C
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0351840008
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 20:20:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DKKdUf6E;
	spf=pass (imf07.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754857227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l27SIyY6K8c3MGvtKdMZemDVV/kUF03H7mYHi+f0BLw=;
	b=wXOwTt4/G9QhziVlYeRWWoPPWz852dPqr2QrCM93CVI3f96I//H/9Oaki+XnPbpC9kwljT
	ZMcjKjwFXykcMSTiirRKMhkkwhcgtYO7fajxxv8yotHeWttrV942fOm8I1gPE9xmwY8cac
	Id2hL8mXciFB5CrPpL4oY4WKa7c7hoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754857227; a=rsa-sha256;
	cv=none;
	b=UcPYEzf8kcGPDwqBX/T2j072Ub6N1KZN6/HSQxblLGQI3Oo6aPMHTyfGHWcuc1hhIM+HPs
	ax9nUp2sfNaZWpXBbL+roWLg7A90OX6SWc+iH4RzcZFwBQaowVmWsD9I0x2snF5vHZ9zFV
	Z49G/cBWHBomnJvQCeqRCum+49m/HMc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DKKdUf6E;
	spf=pass (imf07.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-459e7ea3ebeso13507545e9.0
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 13:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754857225; x=1755462025; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l27SIyY6K8c3MGvtKdMZemDVV/kUF03H7mYHi+f0BLw=;
        b=DKKdUf6EnDNKvfCpoqy2iYQLWnPX3OQYT3NEwYje4x33YMRG8G7DC/wxDLAtdiBxSe
         RqXvo3ZGzijmva9Tru4jdkIOePdqNFqUrTocYFqbv6w8mMCWC+X9LHekwDzokHf+lan7
         +E/zAy5asyX8F5C2PCxBUfs4J6OV+RpS8ElKedR6V5SUoVy94zwDO1hI6+4wkoFHojtA
         A5pC/BJ82cv2kN4tj4fyjeMy+dDLm+83R093a8kY2iRlc9oK5jaV+WdGVaSG5HZAZv3P
         a/LJJ2z8siC/bEDV06cY/x3IrtFXYtN9rgZAFocxDEqTsKu3roxAjyyXlNJbdyGxdH/O
         t3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754857225; x=1755462025;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l27SIyY6K8c3MGvtKdMZemDVV/kUF03H7mYHi+f0BLw=;
        b=CdviAq4QCTEBD81ZASFbYFrNGaM34PIEOVXDQW2O4u729O2uQ6Nxa0teWbbNB23UX9
         5pzT5Haf4tbk9RfCdFk51z4tO9uImPwWVY035Dp/FOeUQjnt1KBpB4uwVYu89zZVv4LP
         6f5TP0ItvqwNw3gwuq5324o+JldiwSTx6IjJRxtMFXSARxgPaH5WJlhUXRdHDvf+yyeU
         fc4ljhTEmLJXw5jDelI60YwtKPRSbdGndtWSIchVpTqXJ8VtgUwYHg6ud17qN7dm/0GU
         HjQ/iUIMvtoAQEVGa9qz4MAJ7/jOfqhehGiyVqqgp5cnMtFsTxkfZrx8xEuGSudPV1fy
         vmdA==
X-Forwarded-Encrypted: i=1; AJvYcCXiCByOwxZ8M0tzzjFpDeTcQIobq/9GiSy1pD2WTb4IO+jzVkXrDjJFZ90fxc7blofRGl4jf19qmg==@kvack.org
X-Gm-Message-State: AOJu0YzpEqIqEsgItkozVj8CUjFt0dlNdhn3+zVLY2UEragUbOjCkVv2
	l7ONAj2br5up8gKCscXaoHUBkoODQg5z9ts31Q+nuhoAbuIhBHUM98T+
X-Gm-Gg: ASbGncvGvTjxMH1kk0GjKsv9eL2u0Xg73gfPq2bU1gefqmj/3TFvOGXjdLHPpe/A6Dv
	ppbr6oQeYS2PIFQ/oNuBBo+JFvIb++rkg5g+Npgmv7bv49uyJ94x8mK1Xi/KWj3tmfZbBl7ESRH
	woQvIMmKx3KC2D6fUKESeWncKFHqCQMQ1DnyM9HpGyUD7v9t3xEa4nu1Gn3aig7HZoLlK/6zDdL
	+kNVvAUI8ZmyzcfO3iWEm4VJ0T4b0+zglAujH1eq++8O5+snj+jrrevUWa8P8tf65pv4Pw3Mt6/
	CjoMHr3L2aVf2l3x8oPBSFuuSdJyRtGb0oA8i7B8BrqJRefBLzocyno58uxWZ33NnncQqj5nXJl
	HlIXp190/djVsC+bJryhO/rEPjx43pSsIH5Prc55caQ==
X-Google-Smtp-Source: AGHT+IGk7vG3POgXRirhM3QifkV6PKInb2ftoINCwL8L4D+zlXJNfPRwum9XWmerF0tKkLVVBbs8kQ==
X-Received: by 2002:a05:600c:354d:b0:456:173c:8a53 with SMTP id 5b1f17b1804b1-459f4f2e6e4mr81715875e9.2.1754857225254;
        Sun, 10 Aug 2025 13:20:25 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e58554f2sm224218235e9.12.2025.08.10.13.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Aug 2025 13:20:24 -0700 (PDT)
Message-ID: <757b3268-43ab-41bf-88fa-4730089721f3@gmail.com>
Date: Sun, 10 Aug 2025 21:21:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
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
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au
References: <20250729110210.48313-1-byungchul@sk.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250729110210.48313-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0351840008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: go5cunjas5a16d871nr4wxb3eefmhhy6
X-HE-Tag: 1754857226-831845
X-HE-Meta: U2FsdGVkX19rrFvadtE4w4BXQLzKzhvxKq4EP9F/BUka7fYx9AVilEyB2s9LUC7I6cyGfKWH1U4uLQsCbynhbcyH8suJgcxmkAhcyxVbZDfbEy/JIOPGT/3plDRbJpVifWO9wmjdFjGYyJdzUEjP9MMHrbZenXUuUMxw/jY5TLdTMcDrA2C8USrLMFKIK3eWx0GiWbqUqSbQm65ML4nwoF9zC3aNS6tGtgvaVrjMLdsGcrB1lLgr7dgm/Y9+HLAw8LQOnsEdHn/HNFcp4e67CHOzvXRvvY3UK+fw0ZeFJ6kpKLj+eyYvTUk6/+oS4vyXtnI9MCX7CsWDfhrn2RXu8l5NZANfmLnk9SPEV4r6kOVb5Fi2AX8ECn5K+1/Z+fD1QAGXx61FFThz6iXeBGN6X3lYcUdtmPpuPAobVEFdsPP7zFPUJu+r11LlziXg7efQK0mCXgqmsjfFqvd1CTskksarv0FkO4orOSiGyO4K7aA0qYaHa7j5mFTCTQ6Du2PJOnixGoKM94TDGdLs0BVU8RoK8r0f8gjhhB05djioShNljEudH0r8bZGMnb7Wsi+yHMtM9Th4WO91kiMVC8k1QPDlpB+YkNAugyDrYUMy8ZV03dajp/zbW6ACWCdwwOSwC7l65Kku2B+lTqDHUcgFYqqETyMEjIoC4faA+JjloR6fFjF4Ofl6dJVc+ywYoufh7nuT+ed/HxtzsQWEHWSaRiJD02f6ic+MUy5MiW3h5Jer06LiTQZikFnjbhY84nZRzR3cumu+i1Dy395DEMavTqVdO2pqE+I33KvIF5tGylrdak59ZcWz+wrsEAGFa4ta9m+Nwm9ft8siSoS+Q4WVq50+q+jZaFF24hiEfGSYOfxiuIMjrjkuBeqmIsyI8eULbJKqViQi9jYlo5nf3KXTALHzvSE4yETfiLrQwtFkc+fCJB/jeVbW1bLpOoANbmBf70M1Bn82kouo/d2e2dV
 dgnTAfGu
 3YwtCnnJqFti/gn1ht0cur5QSKIwR7gMxLOlyyB4aFSz3Ad9uyitc9THOZ7/zcoutrS7ZQV1zwO/CGg1t6me4Hn8E/Hsea/UZ9doK9YVFhYBKyE7apXsaULnrsbQ7M1qzlZJ1+vHT5+bq5ZJgsQphNU9VfW7JiKj8k+PYPPM4tL/Qdai19c3tWjCm8m1kdAXIdb+gRHWaJ3KbUIEdMz3j/rsbZCTr0R7P6aS3uoAGzja3N6cf9lbO9UplLM8RqxNUtpPHsPF6NGt5kldTzfSUTu+cgXr7Tp53CpuxVdRAYv9Nl6GxL//Ts0wbmm4ztTnc1CgGDBE2vc4L531SUuv34YaTKA8bwDz0tlU4RjFWyd2LSQ/sZG/7d/hJpQLR3Kd27oKIxqlIFM4QB6YmxVXf+bVgsgDBqvbUKPkWP2aK87IJGpI58soyMHBAjW0rRp+hjQvIedgg8iBGiekGxfMvwpKO35Gl6mOmp3hXI/wNUojuHsTfCjL9UZqpq21SfuoYBR9le6BgItqLVh1Xmw5C1Mb/GvKWEIV870+5QxnPAfVsoXK9FmeHd6SjNHJF0g1rdTzgDm606o4LHEuibjRfFoSqhLpVJrtjoCL1+hAl9XUQCWJRFn2zfVZGhemS4ZLyjwzlj7IOKJN+7QL+Wikh7mZM9vJ3b6O2UVJ2qnVpK0kIoZO1uebo9XbUEvKqlQx4b+IF1+XbWaZawNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/25 12:02, Byungchul Park wrote:
> Changes from v2:
> 	1. Rebase on linux-next as of Jul 29.
> 	2. Skip 'niov->pp = NULL' when it's allocated using __GFP_ZERO.
> 	3. Change trivial coding style. (feedbacked by Mina)
> 	4. Add Co-developed-by, Acked-by, and Reviewed-by properly.
> 	   Thanks to all.
> 
> Changes from v1:
> 	1. Rebase on linux-next.
> 	2. Initialize net_iov->pp = NULL when allocating net_iov in
> 	   net_devmem_bind_dmabuf() and io_zcrx_create_area().
> 	3. Use ->pp for net_iov to identify if it's pp rather than
> 	   always consider net_iov as pp.
> 	4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
> 
> ---8<---
>  From 88bcb9907a0cef65a9c0adf35e144f9eb67e0542 Mon Sep 17 00:00:00 2001
> From: Byungchul Park <byungchul@sk.com>
> Date: Tue, 29 Jul 2025 19:49:44 +0900
> Subject: [PATCH linux-next v3] mm, page_pool: introduce a new page type for page pool in page type

That will conflict with "netmem: replace __netmem_clear_lsb() with
netmem_to_nmdesc()", it'll need some coordination.

-- 
Pavel Begunkov


