Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBCDF4BB7F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 20:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3F56B0005; Tue, 24 Feb 2026 15:04:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994E26B0089; Tue, 24 Feb 2026 15:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8812F6B008A; Tue, 24 Feb 2026 15:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 731D56B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:04:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18452160323
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:04:10 +0000 (UTC)
X-FDA: 84480426660.03.C56BDE4
Received: from mail-qv1-f67.google.com (mail-qv1-f67.google.com [209.85.219.67])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED426C0007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:04:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cs.cmu.edu header.s=google-2021 header.b="Jj/ZAN0l";
	dmarc=pass (policy=none) header.from=cs.cmu.edu;
	spf=pass (imf22.hostedemail.com: domain of kaiyang2@andrew.cmu.edu designates 209.85.219.67 as permitted sender) smtp.mailfrom=kaiyang2@andrew.cmu.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771963448; a=rsa-sha256;
	cv=none;
	b=gfiSuOsUOVhwQG41djfixVj52D6EDlXrZ8w7C0HX/h3t3Y7TtOD2fwvvbUxPnQZmDUQRlu
	yYBFTzmYZHam4FlDHpiAObKKFAcrQ/Zh86OoxE/PL3u5aKwMbUN4+tLZbxnHC1klvgZL7C
	2L/JC7751qLpv8R0q1Jn1v/2nszyybg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cs.cmu.edu header.s=google-2021 header.b="Jj/ZAN0l";
	dmarc=pass (policy=none) header.from=cs.cmu.edu;
	spf=pass (imf22.hostedemail.com: domain of kaiyang2@andrew.cmu.edu designates 209.85.219.67 as permitted sender) smtp.mailfrom=kaiyang2@andrew.cmu.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771963448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kez7XbtF2ZH1d8xoXH+eVokCW4VeclXLsEwDWocfZR8=;
	b=DbbuDUZoulC+KOEC+YCB92kq+Kl7fPMpvLu8F0zy2Lao8H0CeP/+BuXhXvSmIVmXthDsgj
	+MCj7XXbJhdMe5Dph97soBO7vNSxtlXvrh7nxyQj2umQw15xeInRCTB2t7oMu0tRtxvklI
	Vr9wrruTAaWuxnQIt7QXQWSagcvlePw=
Received: by mail-qv1-f67.google.com with SMTP id 6a1803df08f44-899a9f445cbso12205026d6.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.cmu.edu; s=google-2021; t=1771963447; x=1772568247; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kez7XbtF2ZH1d8xoXH+eVokCW4VeclXLsEwDWocfZR8=;
        b=Jj/ZAN0lzxEdnaXYw4aPAOeIhyxo3YxH94otuXnp3OojhYqnLFQ7ZPNZaazhyCpWay
         DcA3bqpjE5zMBaCY3Dy1gomwXSH0VtJWwyUzMcNCdc4H7OJuesAlkPNhGz9IKo22+2/g
         SxHuRHdCbL0eI+iKYURqDL7c9cag8AwYCbVer+alh2OxOpQre4kLviOlbdhZCw35QO0v
         AnOv4kmP7EJ9Mqx5XXZiV5OKTnZpsDcXT/Gdvj+pB8ZowL9CvYOlBzS8lr5myf89lVCq
         B7LLXG8HvUQe1P7/fbyCfkZEbJgHvF6K0HT2xZvLZ1V28/PMwKt0biuzxvyFEs+iXuHh
         MbVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771963447; x=1772568247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kez7XbtF2ZH1d8xoXH+eVokCW4VeclXLsEwDWocfZR8=;
        b=EE+TedNWxqZHwLqwpT/6kRGP9w7m5YG+NoCUTPFIN0MVjqwxt/8RDOwIHHCHCizKmI
         q8FlLr76OTbZK9jj2eUwS0pJhEiGmDHKCg0aE/N9z88MQoZu8NHW4JRfNQoDjPHa7pTh
         iDK16fXJXJPR4T00DbLMSP5D80j6zwT9RxlNXeOyRPJ5l0xoMIJSTaMnDydArHQxs4Mg
         ZpTRoSZEWIbZ/OMn049XYs4f3CJmHJsEiPDeScCchVvndCuEpl3OUDaR/oWDpdpbFGSC
         dZCdp+ZCDTvqG5A6lzHVneYkT0SwvcluGQtqYvt3aqsIdi5JM3Ekc4HThXd9XMb/KdS5
         Gjhg==
X-Forwarded-Encrypted: i=1; AJvYcCW5ZgF7McrJlFBXtiI8ZERybJyHPriogbvQl3eQkluCZCm3jiG5hB6wCDp/N4Sgvs7YYifx6AjVpg==@kvack.org
X-Gm-Message-State: AOJu0YxvC/9jnc5qCTbBS5mb63pJt7w5IdJrVZtumY6KJzRygO8qYTjj
	/VjD8ZAo6rJ1YSXDXcoOMLMzdnQgQcbRvVVgFXCE+ArhhUKtYOpowMVIBxHPCVaLGKGBf0d805/
	bxhDg9pJRrYjrQ/YXQvtAMQaQBV7JT3USN/r6W8KRdSvU93v6k4Md8j0yEja17Lyg20vccIbEO6
	YEINUrMMquZisakIYPfOS1xG3I
X-Gm-Gg: ATEYQzynFXbpzoDKVA3kpL7aNSd34N5V+BX6uDelDs6TW36/A6Yq0llAoVCVBFYE8Xb
	HfrufOoDw6oLGsdgTqU7PIczTCGOhOVye6EVsYfOHye3W2+vDJIyyQkWhOhZSd6hEwY6VYo6KWz
	C6L+5K0QSPOmlYnuL0SFEQbsf7g/1Fq3RI2104We4fCnXNwc16S0wcIG/d0/WEmAFC/Q/Q75giU
	tXv1QUYP+Ar8pUbOqGcHO159ixwZ0d4TPI+g0m6/Z9e11OnzN9rIFzR501O0wn5fpRHpohRJ1cF
	sgbTN/TPZegH5uynK4HOSeYE7h/7YMRJWRt202sV9NxYyuEYakUPdsU5PM3HpAyIirTMX4rzOUE
	OzMd5DtEve1+NAVhKWKgID960ljlfEg0V+z+GIriTmV4BL8GxhbNh0gAaCqljTMRiho/51vyu8g
	zMABVSBGWbfRH7y3tQmzq4uNWyy5mmCQS/xeklveQh+A04oIvlUkusJ/5Q3PgQ1RHUvWlNOlnzw
	0GBRqCc
X-Received: by 2002:a05:6214:194d:b0:895:4852:ef55 with SMTP id 6a1803df08f44-89979d3b10emr224487636d6.33.1771963446716;
        Tue, 24 Feb 2026 12:04:06 -0800 (PST)
Received: from localhost.localhost (pool-74-98-231-160.pitbpa.fios.verizon.net. [74.98.231.160])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899b3863159sm7696406d6.24.2026.02.24.12.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 12:04:06 -0800 (PST)
Date: Tue, 24 Feb 2026 20:03:59 +0000
From: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
To: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/6] mm/memcontrol: Make memcg limits tier-aware
Message-ID: <aZ4EL6IlaSi0KjT6@localhost.localhost>
References: <aZ2LC0KPF0xsAwAL@tiehlicka>
 <20260224161357.2622501-1-joshua.hahnjy@gmail.com>
 <aZ3ysV-k1UisnPRG@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3ysV-k1UisnPRG@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED426C0007
X-Stat-Signature: wixep6gfsoawuq9kufau7wpcmr3wi4is
X-HE-Tag: 1771963447-955435
X-HE-Meta: U2FsdGVkX1/q/nmi+cDFhIAI62J2po0LhUY3UXG59W9wr/F2gZr2jiWopildKI6ojvr+44gd0araAQIjod37KNbQyupHEikNwHuYYNy23SLUY7RLBLCHE3pdmUXySJUTimS9aq24c8UP8RHMe3lGOhxGtc6eF5BgeS6EtQC35NK9VNANN2TV3iH/PnIBao97Dc0FnZcK9U/Gi7mRVjjZYZA3fh7PvtgvAbm2AzB7FhfbsqR+8R+llMadMgpkti5MQzbqLwn9VO6C7SoxcFgHS5QVfwJukMQlBtqjlYt/bcq2k43sHzjR12k7BuOUZXkMpV2Uwb3pPQvxzkRU+xsqZe8xcY5T80fZhRnwDqInfyE7P0U0YSigyaL2UELUPevZ6jIcCZ54skAr86tlMeLIBOUxl5gwDfUz0PR810tXoO/QpM+FYEmTPJpkYzqX2e9j+jnKd5j0tm7+Zu9Z7fVGOsk+gZO9RMDzRaoIp2Cy7ByBu1KcSfSKiSv4yIeMwoaTPlW7NQl1AY+VkzcIQgfiiOEs0bJankROLS3mF8XhHzTUAa/oKUN7lFFLVR2uW2tWlWYQeuSA3KyXtPjpawRtl5uo/iskuN2wiYnBLcCBvVm4RXT89zKg4BAqgatoVKC/73Za+0TwEeRCODnJg3M+2QuzqJiGe2OngkWK5MAJmPQqGxf1mB1R7ZW8sDNs/KhzsSwHV/jCOnpxVWSba1zGK4o1BlXSjNmFGSJlbHgDwUp1vsCgKP6rIarSbX0PfN49QmTnU4Bfnla0xP/z25YIJtHDEtfSSbzMzNfBTd6T7tYhaUjzm9bsRf0acMzTC06dp+GN6CD2gnwGTCAkat9sXidOwNxLC94ZcScinXVMti90i6gcJ4G2NfDgM7buPaBUgau2FhP2gIsDKZzNbUJYBGytvaVTLYQC6EswBysipPs2l7zqbZ5mOLwFe2b+ZIBgeX+rLaC0ec2qt1mcZUC
 8nKASGLr
 I7hh1bTlOF/Q45OGjEDobrH0N34bmmGIUXjx9cpoFS1W66Qyruv+BuOOtn6mzStvx5X/1FP2ztDoWPp0klj+RUsmut6TUiz5rTUhL8S+AL0iwnZ+jE1lDt4P84fjgdz9H1zQSKDS1uO0tUIlMj6dKTuAQm+sWMZUHRlv2P/aF0dNEfr+drCrmRcJVKxc77Vu88NS4PT0mKiuaIbpi0F8byJB0mQZfu1LHHj5wj+Ch8HN4kAD8J/1Ev0RqtMdSEgCSebvkOFZqKx6RTB18FasdMxiqVrAkLOQxYGgdvy8pA1qGtSrY9jZNtI3AXd9FP+K8Kn0OOek6JbQUc6/mwDOwF6joCrEDo2on+W1KIovheniiVOwlbHiebRdT1syUtAcnJECAhZbQyVJTyfQ7HbsfCSPaHh630BR4oNGWTOCLKiQOSw9nZDs1ruRrtjW1XcUOnGdnt2c+/cGRP9PutUStJYCW7CEKSRNEbLs5xucf06u+fF53ae14qaErpk6gGUJJXWH6Wi1OQWZzrpMcH757JhoMuYrNvh0FLoAMYWkrHiKl1wIP81/LVZDTYxhxLHsgW3NBEG3MgkXBwVKEXz4PqkBbI/gZo8QoGnBo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 01:49:21PM -0500, Gregory Price wrote:
> 
> > 
> > > Is this typical in real life configurations?
> > 
> > I would say so. I think that the two examples above are realistic
> > scenarios that cloud providers and hyperscalers might face on tiered systems.
> > 
> 
> The answer is unequivocally yes.
> 
> Lacking tier-awareness is actually a huge blocker for deploying mixed
> workloads on large, dense memory systems with multiple tiers (2+).

Hello! I'm the author of the RFC in 2024. Just want to add that we've
recently released a preprint paper on arXiv that includes case studies
with a few of Meta's production workloads using a prototype version of
the patches.

The results confirmed that co-colocated workloads can have working set
sizes exceeding the limited top-tier memory capacity given today's
server memory shapes and workload stacking settings, causing contention
of top-tier memory. Workloads see significant variations in tail
latency and throughput depending on the share of top-tier tier memory
they get, which this patch set will alleviate.

Best,
Kaiyang

[1] https://arxiv.org/pdf/2602.08800

