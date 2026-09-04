Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B20C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96FB6B0088; Fri,  4 Sep 2026 12:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46A56B008A; Fri,  4 Sep 2026 12:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35F36B008C; Fri,  4 Sep 2026 12:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9506B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:53:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08654120149
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:53:55 +0000 (UTC)
X-FDA: 85176676830.22.5AB8F67
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2782640005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:53:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DMtRMTgI;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788540833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Daql0pFyC4jJPjBVxDEnT2CRdATPbJ2eNQ+01EFAvg=;
	b=iVEhhTyHOuSmCt2UgVZrxUzOZWbh7ZvRVverO6mNyw/F3+lgk9VFc6nzqDnI8UOfIpWgYi
	pGBRGIs8IHqHIYEk7LHnKMzLZQDIZfd6x6qVCxHRrc861X7AIa7dKZHUjtsYbzl3kKmZq7
	IPS3VCjhOOay7lwElLIvsAr3mf1bUQA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788540833;
	b=Dg26RFbRUgXJtGg2kdpR7B9RcNgmni1UGC/aY6l6scQjZRhOhlF3X7CaJ+rS4wbtWCTLJJ
	mI6+CnLbpG9kgT4nsXN6/Jnpsoxn5STE9fq9yvXS/gp2DDlGQkaMJ1Fc9UkLHmztvUsTkz
	8pUfeQ1EHmW+d5NxnrCIKbz1DMF3wRM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DMtRMTgI;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-4b1fcd3b1a9so684358b6e.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 09:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788540832; x=1789145632; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Daql0pFyC4jJPjBVxDEnT2CRdATPbJ2eNQ+01EFAvg=;
        b=DMtRMTgIiVleKh1b6CbBP6yKIf7hDBDcYu/vzvcVu7VbnMb7AG9BTHTajug7HfQbxg
         JtwdIeqImsPK30xHjXFMp0DzoHA7/awKl3mH35dbBSBu2PWVMY7fGq7BdwXRprFyjBbM
         cktN9lul+iXNVqu+E314P+33xMW3s4RIl/QHhXGVOXpMuIZSBtLuxaMWezg9zP9nbOwE
         XRqOJyzyoK4vqnSV60owD/EGGjHT7Pj5g7xC7qYnQiSp1K1tRmYDGujf5FwrzEDJUKz1
         kdbw9FQjT8/sbpyW76xQNo3snMrRGJBAOmRihQ7CE6VUDDWiOIu7FI0isbbYKUomPwKE
         +RqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788540832; x=1789145632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0Daql0pFyC4jJPjBVxDEnT2CRdATPbJ2eNQ+01EFAvg=;
        b=ocWCCXwqCri8YLyxKQtHxTzEPsS33lSdLpslg4qG1oc+JQYJrxdSBIkFZiJYIOGSHg
         iK47JlGooNfxHvpNZFp+u7NYt1MxP+tDgE1EJAYUTSA7NmMXFwnI4NFhuPURbG1T5R34
         sWBH65p3aDFcY+M3koh7imgsqkwsnwsP0730HuF+EDH2PjzGd2nnZ2jY1pv5iesRfGJs
         JOEbwWqW+JkGWuopdOv3l4tVhECjqpPcbPZ6dPmhX1KXGAFfMQkN/cqIaG9kNZaC+c34
         L0AiF9mwgEzR8JkWzgS/P6uZkSJ8o49nCePhxlu4quuKczAI6OmRd+3JZuUFLR96kJZe
         jXIA==
X-Forwarded-Encrypted: i=1; AKwUvBwRa7aDDVKjwcxkuBBFstBwJE+X3TlAnOvElE7wc6r0VC9v5+PHy8etgFF0OMHtkVUkR0U1tUezkg==@kvack.org
X-Gm-Message-State: AFuF++lmVRIuWCKVvzEfilWeCERoktYhmqQ3QEHG6WSqQgNXYyDLqZGF
	9/AYUSD23htUxD2tn+v20qLmRiKWKD2CB4q9voKuhoZBjAR4qVAxeURu
X-Gm-Gg: AYBFou0RTYj7uzI9xeDqQz/kA9WSmI+RUobqKt8UitjTBHBRHsdRLKALergv8KH57Bl
	bppvsOkf8+1AaiGAU8SZVLIVNTR8JslQ/a8wGSM9DO240dCuyH5q2cTAhobEzwqZgD8p3QBWEt4
	rvzIpH7+AVhqwP4H1xKw4blVO/F3m/NPc1wXI33q+vvDmcUthAenKWluT1hBpLq/LrCMWdlHmFZ
	CP9I6Z2r2hmO35pARtewScDe8Nt9eyY2ND5SKe8ZUfsGcwCKqJv/+9D7FgFq8Lg0Wiq8WTTw40v
	pHK0Iab4mYvr8UIdSprUKv1BoX+Ik8ZgMH75utF/Pg5d0N9Ao2RpZ6UuJnqTmzpDUHB4ng8Sdzv
	INA8o9PAQ3vgN+9f3UyGjdjdCsyj4sRAazFfqUvi/TjLeaiVNvBM2T1Hwtumtt/X7XQ/OdWGJNs
	lmhKdiCOrktdsulBcUp9dM6P22oHkfkl+ZJFilUeRhOgcyE9MDLH4zWbuYHslN2qzxi2SPaf6t4
	AT4RCg+Mp2BqcRcyfk=
X-Received: by 2002:a05:6808:2222:b0:4b9:e5fa:8a1b with SMTP id 5614622812f47-4b9e5fa8e8cmr3156448b6e.32.1788540831911;
        Fri, 04 Sep 2026 09:53:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5a::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b97167bd69sm2864168b6e.13.2026.09.04.09.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 09:53:51 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 0/7] move stock from mem_cgroup to page_counter
Date: Fri,  4 Sep 2026 09:53:49 -0700
Message-ID: <20260904165349.4100321-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qsddcoe3eti7qqfudy5cxqdoygepgdof
X-Rspamd-Queue-Id: 2782640005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788540833-266558
X-HE-Meta: U2FsdGVkX19SUpKXHSfAj9mQAOODU0h1kQq2Kk9Eh5JD1ksWJ86CUtD/ZHG0mLoANClIPtpVAKJtZXVz1EjRYsHHh3KKIdnhsMcUtE6aBJfoj7FufaH690+3miCOKTcy3EUh4YTYxejPRlaFf01bVPNc8pkJpfTNMH8caJxy9KDuyqBcmvSoijl4EtINny7M8qAEi1pMnkvjjRHB9q28NzSVyrYCvLKEhOfjJeggydaJdW3iMlfjzobnUryDupJVM3pPuuHy3qbnw+4/G2M9jPrzVgfSpwJa36U2xUJh9OQaio9pPSmlRdSONoz8mxi0OIvxKLr67KEeEOQfBIGqbZ2iX4OKLfDZpJCCDIZanQS21dQh8Z4IvD55av93Xl50uOAxYyBQSCcaMuZ6kbJ2JuiTtfkevfjzGDi5PlLCJi/ADbwjvlSa9+khvdm4qp6wHXEva2CjV/YhWlvkrO7w2GKo3SzrZcGINVHA8PfyCiW1/0RYVEvqIOH9uBJTMffPKL5Wo5X5ObK+7jD+zjuQpWkLZ/Vndn8XOPT6xPJMyIlGSb2FjTLdWT4KYWVRk025tUpFzYoODFTBCJDCRJ1Ek0qajVQhYr+DoYhg/9cyqkqiX47OdIMQ/4t6gL1UtNeRerob5RksVPKfltBVl5PF38RPztnvelh4UpP/TmI0giqODpUPqlSSRbLpUKmjuxIZwn0SwkcBW+pCsI6FG0MJ1VCUKZiDl+zM9CcIuwf2DUjZZ7VquKtyowyVsY6TQZqrGmr+5KuUrZKQsNZwlsyeKvqtcm8FCYjn8VNcQ6fat7jR1iZmVTBqNB9Rwh+TkmUwGpzgkee6U3QS1hg/dc6JKFi5H41kmiA16NmfJp5H3GXgSpDKsC9T6S5rPMGEpwmq6c6Rlvn2qNtmRYZxVk9i0OoeDn6dD8/9rn+KyWXA7RdCcCaLGxKX+7pdgSThAABlXp0K8NkwIjMYgKoQ5tU
 +sHPVt54
 JoVRqJD6fLJTqP6L05k6Ln7jZjpFZP8r0L/d1XWM28MZMCfZXaAnodU2MpCYyqXI3P56mVMLxX2EiaOw8hLVSaVvwWkKhzbuuBCTAkSApB5XmTw1Jq/KMSsf6JJFHLvM3np483ZXSM4jdw8Lq3gUg0Zk71gBI7AAReZOR0uLW4lZl24VF9QhSUCPXQBLfTrKChrAai1KfBKnPNmoPXqbLMDqaXgPkPGGQo9Z4yApdk7OAQUb4ZQAGQv4o4Sd6q83O9B82yzi1dJI4cpwiHyUa/dmiR6pDaxLZdgUNgbMyIw2tC9yTbeRVFxAuYbmNtN9luSYaKBB5xy3+oT8kX5mhoRaT9GFDxi04IhryZFFRsK+GgykNKO4Q8oCB4yoGxoFYQKGHglYGirPnNnHHU34DKgauMDuMZYqp1Jr68E80TXax46KDA7i+ixRO4eHiWFvyRqTRToheQu/sDFMyoqgCVsxGzWZUnysAbr9YGI+7lI19M90pCNZ3vHBTCB5Ut7wLOVOmzOYaWUdT3B3bsk4fHanjuj+4/c9ZaOlO/woqyqkX31NCA4PkAr3WpR20qJUMjbY7A7nczk7sTKtv+ki6/XXNIu01A5Lyvlc7uGY2WZiGkULtatPa88BmpuAxuhFzTVRo7si1uwbst1DiE11sf/d6Rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> v4 --> v5
> =========
> - The stock is now a raw_spinlock_t and an unsigned long to more closely
>   match the original semantics of the stock code.
> - Draining is asynchronous again, we add a work_struct per-page_counter
>   (not percpu) that walks every cpu. This eliminates the concerns
>   of doing a synchronous drain.
> - page_counter_try_charge transparently handles stock.
> - Addressed the netperf regression by reworking the refill path to match
>   the vanilla uncharge path more closely.
> - Correctness fixes for the percpu pointer access usage
> - More testing to demonstrate that this series achieves its goal.
> - Included Shakeel's stock watermarks from [1].
> - Wordsmithing
> 
> INTRO
> =====
> Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> allocations, allowing small and frequent allocations to avoid walking
> the expensive mem_cgroup hierarchy traversal each time. This fastpath
> offers real improvements, but there is room for improvement:
> 1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
>    more than 7 mem_cgroups have stock present on a single CPU, a random
>    victim is evicted and its associated stock is drained.
> 2. When one cgroup runs out of memory and needs to drain stock across
>    all CPUs it has stock cached in, those CPUs will drain all other
>    memcgs' stock present in that CPU. This leads to inefficient stock
>    caching and cross-memcg interference under memory pressure.
> 3. Stock management is tightly coupled to struct mem_cgroup, which makes
>    it difficult to add a new page_counter to mem_cgroup and have
>    multiple sources of stock management.
> 
> This series moves the per-cpu stock down into page_counter, so that
> page_counter_try_charge() transparently serves a charge from the stock
> and refills it, and each counter owns and drains its own cache. This
> eliminates the 7 memcg-per-cpu slot limit, the random cross-memcg stock
> drains, and the slot traversal.
> 
> In turn, we can add independent stock management for additional
> page_counters in each memcg, which is used in my tiered memory limits
> series to add a new page_counter to track toptier usage [2]. Patch 7
> uses it to give memsw its own stock.
> 
> Because the stock is now a property of the counter rather than of the
> cpu, it is also reachable remotely, so draining no longer has to run on
> the cpu that owns the cache.
> 
> This series preserves as much of the old semantics as possible,
> including non-spinning safety by using trylocks for stock access.
> The old !allow_spinning semantics in try_charge_memcg are slightly
> different now though; outside NMI, page_counter_try_charge may perform
> a speculative batch charge and a refill.

Hello reviewers,

I just wanted to note that Sashiko seems to have raised no concerns [1]
with this series : -)

Thank you for your feedback and input!!
Joshua

[1] https://sashiko.dev/#/patchset/20260831163752.2193337-1-joshua.hahnjy%40gmail.com

