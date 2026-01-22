Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9398ED3EE84
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9836B02A9; Thu, 22 Jan 2026 11:39:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84006B02AC; Thu, 22 Jan 2026 11:39:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0E96B02AE; Thu, 22 Jan 2026 11:39:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6AFA6B02A9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:39:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7056E13A9B0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:39:21 +0000 (UTC)
X-FDA: 84360160122.26.843822A
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE90340003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:39:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c+uQA0+Q;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769099959; a=rsa-sha256;
	cv=none;
	b=SnQMGyAbfllrGjbITBAelYBclMCMOmiF2fJv+kjWGu1GEYiC0X2tINKODTEmqDqUk3Wars
	Px06lwm+Mp8nxUeaPhiFVqFMwgjjZmthdAgLbe4Y+zFSjfvRVExlQTHJ/Dmz3JraLk+Cfi
	NzprAk5I8hNhDQ3/UIU8d67XlSTs740=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c+uQA0+Q;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769099959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26F4T6+OWgQyYilpWpKxSqIZyd62LthQzewXe3OU7ww=;
	b=FSxKMa1qi/UBagGMkrqpCOLDPw2Q6TKZFtwzqSmdJWReuVYiOOrl2tApFqY5W72mm43VOZ
	n0LgQpkIOLaslmC/ZT2gVKZ6Ybp0JRWmSD789jTpWcdTaYCseXNbKFoM1qhgjsd4atIH3t
	U9cd1QIE2I56REk4zwjW8KOMjcCPTtc=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-502a98c66f7so9082631cf.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769099959; x=1769704759; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=26F4T6+OWgQyYilpWpKxSqIZyd62LthQzewXe3OU7ww=;
        b=c+uQA0+QeLZx+QeFEtZfcvBuuwFLpSIMZos2gCfk92nmOTCPGTqbvNtZNsUy8rls55
         iXUGqzPbhhSr3m9Cw4KL8DhnnmFR6lEOiG0z9GgoA/GEecxJKsHwBtzfTnhu6XpAdel6
         tbN1rbHDVDQgANQIB5qiauRTn/SKAxZzT82Sf8z5OJTdpx7OtbHM75yadSQgUgShGoSq
         7jhl4JaY2c9JoM0M6L9fN2uJucZfpodNqIhbyZbqJELxl6EsbdE5tClzebgk/BnjIj6N
         oq15T/MGfDkZw0aWim4ItFdX8SPuB3Zes3ptn7S5MNt+niZqDiEz6SczaAmokCLTw4Jr
         +T1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769099959; x=1769704759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=26F4T6+OWgQyYilpWpKxSqIZyd62LthQzewXe3OU7ww=;
        b=TdJ6U1dRVWYaZ13YchdXEaOE3HrIypjR4rOhsMQ86WBqC2+W7gd4M3z8XLuAAm19Hd
         7LJQJPOyP34AzxTHVlo1TiP3GkLIB+9PZ8ZhjhM+sFB1c+//ueu4gReTlg6BZmWLut+f
         QHsJpXIH9niBfHZwzVAzSqfK9/3193iBSlWs4eWTtZ0y825LAmTk/I4KvrNvp0sOpKcZ
         1bHbMpUJlF3CbnWYHjJGGPtZSlXyG7SxRHAJ313EOq6DJQC3JOETCjVSU9STwlTYNguo
         38AFyxrSbAdmR5N7HF5AoyrtJW2Ura5CEEbuEQ8wlARsmvmA/z9PEqL60HzC3JV0VBz1
         kE7A==
X-Forwarded-Encrypted: i=1; AJvYcCVouN+2VnZHKDgnqAggcwwfY1yj+0EvgRetf41rqnVOCFq8Rpb5MKD+sOWPeuCDhpQkut0zo27yhw==@kvack.org
X-Gm-Message-State: AOJu0YyofUMxBGT2hlvVv6+j1Qf4gPug8yCOuhCUCJbl3AvW/KL5c8PN
	a2/+i6UqzZzNHc8GG6BqCcg7uYIIi+oGS85Fe5JCiw+A+nlmTgFGa/8IO6xAD6DjYNQ=
X-Gm-Gg: AZuq6aJW82ZUluAt2ceyFT0JcLGr+/Ktb4s0mcabTFaHSks+etbvIzL+QWYcIaKAewZ
	86Vd5W65nhELfbjH7j3flvsrqOOe6aRYfWrHKA0YeoRtNlmNcPeOncSWKv7YzbFuuoxleKclmK4
	hLSB/yogZV2asm8yQ7US2ursZMRNGQRqkjLD+zbIwddPq0InHrCzeCYvQEBlVd5xaE1ognn1koZ
	/PV5X1e1PjWUd8VUHVvH3yq2x5cLnYekY10C/t2R7LSTNof1eeLODMvEhQ4jO6y6ZhL6Kfjbk/C
	gpo0eCM1ymGzLLcjegiLfhBTv2HOvQSt6j6sC54xgsTNk+4iNNspwgo/qo5XI11UGs7C5I2MaNP
	gZN3E4Jjxl8MQzXeXKU7aTu+yW29Uz0SV8Spi6SxTkHKWZ8dKL/RKYgldrg992X35ESxNjckvqD
	njB/esifRCjOmVaqZ8eWk5YUXItKvij1p/2ilDjGvHThuwgY6Ys/0NOiOEWfb7JO7iL6fgDg==
X-Received: by 2002:a05:622a:18a7:b0:500:d108:275b with SMTP id d75a77b69052e-502f775b653mr2055011cf.5.1769099958557;
        Thu, 22 Jan 2026 08:39:18 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8946e7fa675sm43565766d6.35.2026.01.22.08.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 08:39:18 -0800 (PST)
Date: Thu, 22 Jan 2026 11:38:46 -0500
From: Gregory Price <gourry@gourry.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	bingjiao@google.com, jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aXJSlv1_K1uQCN16@gourry-fedora-PF4VCD3F>
References: <20260113081453.8293-1-akinobu.mita@gmail.com>
 <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka>
 <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
 <aWfXHKDzoQBsHxAp@gourry-fedora-PF4VCD3F>
 <CAC5umyg+wubKoQSfpDQvNh3K5Y7+iOEYn6_BuKFd53kHDVE7aw@mail.gmail.com>
 <CAC5umyjOgZE0Qpa3W3qZ=sSkwkuf_md47jctXgi5UKWuG49o1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC5umyjOgZE0Qpa3W3qZ=sSkwkuf_md47jctXgi5UKWuG49o1Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BE90340003
X-Stat-Signature: 78tgci3topx8pxrd6r4mjoznfges1tua
X-HE-Tag: 1769099959-873832
X-HE-Meta: U2FsdGVkX1+vp/bDwJPkxwlLIZXQsnM6+M8XzeB7OFMpLuYfQx9e2n3sVyhVpEnFRtV/Yewts3vmQSS7jcmSG4PZPyUZRIyt/PzKjdN6wvigq5w99PNzpcTAd4cCBFl3rYNhbIojs+9wwGqq+syNFehZ6enhak9mJvcVGuiIHcpIi7eIvlMaXJNLWV4llq9ONWnZJjQXRsLVIRK6cMtPkGPKWUSCrZsjaOOuZ5VTliEtJLxkgEpZQuaHLLmbtKo9ERXCLJGip4eo5cDX4DL1BBtpMQtRn8XYOtWEZIDGJYmshYzHMc4w01P1ZuoP57iMhO/EAZPCuTQBRLqnTOJ/GVKwnPDaJZIi69TH+6rqFZawmfugTGX21smWDPW9PThmJH1MleHQh0mFDZZTvEeFkeTMIiZ76qqCX1WEwnW0cSedARpWTcjgqj12FFy5fXZ1pttORoY8NgWnZ9t0Ar0jpaE0odv88H697aE/1ukolxbjaYedRYAhH/606v6cIEXojdLZiLNYlGpRBEnRn4k5GTzjtS2VHy6MOwWHBo6DrgXvqEcIlxUIifC8238KQR/72tIhRkQ+5ak+foKPnSqRIsxy3HmYnJtDqXnAQhPKEVkpm0t0f3OyoNN9kRuxAnC12zU4MufkIe4nM7E4DHl01RvvD0Gdq4JqY56CdnblEzTsYkZi/rIs5FNOrb1NYO6Dis2i4T1NTAS4JWtNSZc5GCl0KmHbhisrPIgdSQOPedjEqIlsV1a7e8MvjUjo5YZ1+u1C/XhJkBexWFNnJAdHCVRSnO1Wjys1SiGF6IVQsko92L55quUxCRpYLMaQxGQWmMPimv+AsmT5VZyPTzoFxuw3kozxL87k33K6uXUoYHwtxpD/ZlIcb9ZVetnT4Z7Zs63XQy1Yolf2TcW4acIR2lwb9cvuTDvbW6xJqdrMjK6NGfXJEBoblBVV0DmCJWNMqIrRbkrqUH8sGjjx/0r
 lIiBM2+E
 OLOL2HvnnoADMMcdsrf1KjLMgb0JJpq0YbuOp2uw/0aw9kGEycQ1OSXRTnCjCkZL+Vss/nZF63YPoIDPJee+DMSnBlNDPup5dICaK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 09:32:51AM +0900, Akinobu Mita wrote:
> Almost all of the execution time is consumed by folio_alloc_swap(),
> and analysis using Flame Graph reveals that spinlock contention is
> occurring in the call path __mem_cgroup_try_charge_swap ->
> __memcg_memory_event -> cgroup_file_notify.
> 
> In this reproduction procedure, no swap is configured, and calls to
> folio_alloc_swap() always fail. To avoid spinlock contention, I tried
> modifying the source code to return -ENOMEM without calling
> folio_alloc_swap(), but this caused other lock contention
> (lruvec->lru_lock in evict_folios()) in several other places, so it
> did not work around the problem.

Doesn't this suggest what I mentioned earlier?  If you don't demote when
the target node is full, then you're removing a memory pressure signal
from the lower node and reclaim won't ever clean up the lower node to
make room for future demotions.

I might be missing something here, though, is your system completely out
of memory at this point?

Presumably you're hitting direct reclaim and not just waking up kswapd
because things are locking up.

If there's no swap and no where to demote, then this all sounds like
normal OOM behavior.

Does this whole thing go away if you configure some swap space?

> 
> When demotion_enabled is true, if there is no free memory on the target
> node during memory allocation, even if there is no swap device, demotion
> may be able to move anonymous pages to a lower node and free up memory,
> so more anonymous pages become candidates for eviction.
> However, if free memory on the target node for demotion runs out,
> various processes will perform similar operations in search of free
> memory, wasting time on lock contention.
> 
> Reducing lock contention or changing the eviction process is also an
> interesting solution, but at present I have not come up with any workaround
> other than disabling demotion when free memory on lower-level nodes is
> exhausted.

The lock contention seems like a symptom, not the cause.  The cause
appears to be that you're out of memory with no swap configured.

~Gregory

