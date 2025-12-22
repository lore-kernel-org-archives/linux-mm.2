Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4533DD68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB26F6B0088; Sun, 21 Dec 2025 22:25:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60106B0089; Sun, 21 Dec 2025 22:25:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C936B008A; Sun, 21 Dec 2025 22:25:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8184D6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:25:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 222935B92D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:25:15 +0000 (UTC)
X-FDA: 84245666190.15.6BBD25E
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 53373A000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:25:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sdi7U+P7;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766373913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0q4BK1/oVFhcJwzFlC5ht870mAKf8HPK6uMRHcO9Sw=;
	b=FFx4v6g5s6z+X9w3Ac4hOmy3kFxvXiS+k7gz3pyJRjPQBcQswW5jYzyV1DxGYdGNA2yfC/
	4svBO2R1l29kGPDh0hrqWvq3tGfNbw6swVOn5KzeTF359MkiUWXkbM4BSHaUefnnqgMkcP
	CBTB2lVoOkg9Hs6dA47UzFHMtvefySI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sdi7U+P7;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766373913; a=rsa-sha256;
	cv=none;
	b=ocMCUm89flWUokXEgzmy59AteTazhTF7ujAXxBspz5M5oOJelovTldeVMn+pjEiaBFZ4O+
	zFAEY8/GiiChX01KQ1z6/4LIdIaV9G04ysEjCjxM9yBxk0E0UvMzZhr1tdRqjk8w//nyOh
	8KMfqdFAmTjqSJ6XHcpcmJWP3Fd0sg4=
Date: Sun, 21 Dec 2025 19:24:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766373906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b0q4BK1/oVFhcJwzFlC5ht870mAKf8HPK6uMRHcO9Sw=;
	b=Sdi7U+P7Md9MMdxEhS9bY644UrWGJOemPmiAhz09WAvxljkfCRmUjyFOOs4VreUHeK52Vh
	SNBV2yIPsXL/iVv56ShDHATEYCKpkwEUFEgEBkqnfsbl7jpLS0CG/ivFbn9k+eVvqD8lg6
	6xQVyC40N7IsI4mFWm8Mc3/JO7HJKPA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	lujialin4@huawei.com, zhongjinji@honor.com
Subject: Re: [PATCH -next 2/5] mm/mglru: remove memcg lru
Message-ID: <ytbajfyzgazpgx7qftafyt2ar6xzpxiarkdih4p2xiihovxci4@ugdmji5uboih>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209012557.1949239-3-chenridong@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 53373A000B
X-Stat-Signature: eq7b9u9cqpy7opk76kf6enq4g8fiynm5
X-Rspam-User: 
X-HE-Tag: 1766373913-46000
X-HE-Meta: U2FsdGVkX18b2BfrvZB1QZlExyHACh6PrBoTgqyeAh5FcpFVXF5y+jCGPbdJpmQn4Wzg7GRMi5ZLAhsqHt9gPmH1WxvtMh9+0e4zghwc01PwkbeRO/tVWd152NzTwD7uoXBTZsk0A82wqQal19doXGo7bBMdJ2woTRV1nOMiWLKeg10dydg6GhFZ2jEY2/0LanoJTTo4qAe/zpLUwovV6G+g2J5KQcrDNnRZf7Ws5yW8tAuAB/hgS3aJd3Agz0sILTwarSjLGaNxaVN4+bsuielI3TyX/0m0NuzXh3UdUcTSKp5hNp6iGvYovO31o12CoDNKnyNSgsF5cp83ZOxx2fJ9mbjXCxEAzY5LovaOc0vlDHhLnO4YIsFz5wCDj9VNTDWBLe4ASSiX/10OUx0+Re0ccwiCpSoIY3KEZt1MSINEQEhmjRp44HdcVfVOWZRVBswi03oh7qf4w4zK9VxfUU/7JANMASmV3ILYfUfwu4iiEVhDPmgVvenTA7VQIXUPYlX1JTEEDP2odp0VX+kvU5fs2HXdCP7ba+WmQCuOE8MOB9ALKLjOpuKnu+MjJytIrJAL4dOdTpzSndt3dVYMjRNQMwR6eOPwXlvvKfN2gYR0bZe2sxerPKviCseyBy86BTyC0fSryrQDpH6my8covt8qW0JgttJ996EwnyrNLbYS1U03nLTu8BJqG+W/Hi9QvQw8v6A/MqMBywaTiGvhY7XdFw5eEu0FkFMAQSMpMxiEfmkOQe6LvDybVJYEVN3tC6843LgBC1CNosVIFPOa1VaLJmmSoLMCbWaKdxv7VOnIw2JDKy65St8NPlT94plB46Sse2R7VUQAxYoLULGRBddm8GFss8T0+8gR80nlhWqoNGVvA8dnuPlpvpEv0E/kP4aGXKxswBgO6YHuHhTFVDrnsgDMdLDs/RNKMwPQ/M9GL7KvqT7ZIa4kF+MWVTZzYpmzGYqM2HFpXHZwySu
 SwZ3ce1Y
 Ii8yoPReIzwsH9sh537TfTA8dGIBjeaPyYq9t/OHzCm8zL71BNDn5fhIey+rt9oNk12ebzqGfzca0OgPa/QLjlYvwpdqs1vgmCi/hfp9mAQXq5Gr1slhfdBtCWEVB5jCH6nDjF4D08ogzAS6u/But+oBvGnmMs1Z7mrh1FYKNoE9FUw8hyGSUGwosAvW0h1uyN2SArHWZ7mW3zHV7Ke6HeW9QoaPGmrnnrQgMrYsoO1U7iAULH8g2S9mDRo7CpFRA6btNZ5PZYcChWnz9UanqsKk4d3KQRo+Te4Ms
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 01:25:54AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Now that the previous patch has switched global reclaim to use
> mem_cgroup_iter, the specialized memcg LRU infrastructure is no longer
> needed. This patch removes all related code:
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

