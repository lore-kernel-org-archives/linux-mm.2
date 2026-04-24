Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75FBEFB44A6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 05:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B086A6B0005; Fri, 24 Apr 2026 01:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB94D6B008A; Fri, 24 Apr 2026 01:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF726B008C; Fri, 24 Apr 2026 01:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8909B6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:20:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 111D5A06D9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:20:44 +0000 (UTC)
X-FDA: 84692299608.28.611D5F5
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36D1E180009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:20:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DErWeeVw;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777008042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzSFr76VywT6mzIWHv1uIbUW5oarBczpza1ZqXVPhNQ=;
	b=HxAL6kgtPJebFDsIqDf7rlGjWTPrvlWRFyBfVlCBl0/61PonQmCM821+8Phjza8pPBN3gV
	93MV5Egou+bHMq+4KCEUYzHtK+aYjcnepr3HDyiaG+BvsbqTRpmURYr4UG2jevV9PZ8j5E
	d6buslwWFF6wCGMD7bPjQAAMmeTQYRI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DErWeeVw;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777008042; a=rsa-sha256;
	cv=none;
	b=hhE8kpgPL10Nuwg6LTKPUsGHYI3fsD4u7pXmU0I2fjgTCVr2Ug6ziWX+LRxtdcmBzQuUpH
	/8MYeOSAM4FioCrthBW5nWqIzpVAuSltwg+i5ZT6FafAbINRhwfMElftr5WHz7RE+P2bqV
	N/MrshlxKnFVMg1K3wBTUbWzQ5VBk+E=
Message-ID: <84e67f8e-7cb7-4710-bc46-055a2bb9d0ca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777008038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yzSFr76VywT6mzIWHv1uIbUW5oarBczpza1ZqXVPhNQ=;
	b=DErWeeVwVrnD0TSpf7Ktcrk/EQp2CqM95/ld7OLjvYvCxmZizMlH0nFpDSmgQ8+FMSLC3s
	GEDweT2SNYfK0MQzHu13h9CFRBxKdnq3ACWpjgnXUhv/9gygK4TdUbIwQpXooivd4WqXUr
	eSYdusT7dBqItD1zY/6/XWLHkDYcE48=
Date: Fri, 24 Apr 2026 13:20:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 5/8] selftests/cgroup: replace hardcoded page size
 values in test_zswap
To: Li Wang <li.wang@linux.dev>, akpm@linux-foundation.org, tj@kernel.org,
 longman@redhat.com, roman.gushchin@linux.dev, hannes@cmpxchg.org,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 mkoutny@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-6-li.wang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260424040059.12940-6-li.wang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sukdyq8tfwkp95rcfwj8gb5wuhc95y53
X-Rspamd-Queue-Id: 36D1E180009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777008041-378285
X-HE-Meta: U2FsdGVkX1/x/eZHWPwQW8mMw1iVFAV5pdROrQOuu7XAkNeM4nHG9NClFLg6Iv2LyvDcXWaReLBC85W+ZJtXbxMwx/5jQ1tdloH1Rh/6YsdplL257vG8XsjK46LujGN8SMcFsSomxkZVf8nMYNN1hF3WSS/xZb1rx6tKdoNGZnb0d/z1IjC4zP2PtdC/UNGoin0+utWC001UazTyknVJ27iS7iV7BUAw+ke8jcEWiHjfMt5xOv8elWoMwummx70ORoDSko9fxt+EvcowxFVT6w6RXgtWVgpib2HeDlRPZcCtj2wgGpIrcyuqtekF8cA9LwxJ8TR69GU/MW94DVioPynUO8WgZwdt1h8hdLJACSsKDxcvMELOxDF4VozydqO6vpbLya3fNrBY1fJYtXpYgOyXOYHcD3TjxD77E7/ZYD3q4/BJ9cLpwj2TxAqtrt053W9MLnGtrL+lEe38pH86jgIggNPJ5RLjJncjU3VKRs/LFcCQJ2Tq80vtF79d1352JjdQNCI/XByXSIp+g0htvZC7OB2wm+TV+Dzgp4TjBsduvbVc6sx/+hlci0pqKI6Klzx2Y0ySLicItyjWqS/mGi++725dUSKqyv1NZeEXW3op+wMg6mY2QhL6Gx3ulcwm18OH9u9iiErA0DeCNELeSbhTUMy+X5FBFRB5eLrYd/fAbLoS7FdORZm751UEpVx6F4gwNCAC6S77f+03UdelrmX7VCJm3HYJONWD0ACG287QHIRwtkl00AzkFdrJZfIjAJa38fS0793PQg14cSPZiaqF1Sl1eGCFrOz1QHbfjdxLp/VPRiELEvOjvgqrpLBUJkHhbLR4TueFHaqUKaXOTHRr0NuldJjqPVet4qy8iZoHSprlBYDZmLi/6ZYeE40UyV22/ovG+bjHk2p7x1ysaRHby2LFFFHBKv6eJtf3qWfP+/zHaoLTm+ljfA+yTLnwfpr57fcK3wUzq1pXXVJ
 oV1B/II4
 6Mun9++TW/zEBjZHuZDdEvOZMUtt0KOeIJDsHpm3F/2itBVIV6vj0fL81dFkhgIjcGu/I3G27AvHwxymzY20301HhxYiYBcwR9PwXnDXqS4d2UMxD7XwI4dh6q7LnX9GkhTgN1ld/5wd7VQPKmCt0zLf+rU4jJEZC/0plx7p0WkCbvlJtK36mhm0iS7ejzN42d2hs0kx5VCEmYQl9n49rEWDiONPSa9VCBEpwxiFUJI+dhmVJIPrO75mkqST1XStmewhcCf/SdXE0T/BgnGhbx+KIXwoEkSQat2Jvnuz0g0Onr8PeyWcX1J9Xh/N5KvqohpMJVCqOThkxKcRnWYWxJzVU/fgC5pQs4BPZGc3JrcfuP6S7t8EbKEjU7rhD6FOHCxjdsQjHjYcriUe18bWuxdAM0JGWFCV0oIepY7CWpnEqcXNF/2fLc6QbA8WjoOFG7Tgz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/24/26 12:00 PM, Li Wang wrote:
> test_zswap uses hardcoded values of 4095 and 4096 throughout as page
> stride and page size, which are only correct on systems with a 4K page
> size. On architectures with larger pages (e.g., 64K on arm64 or ppc64),
> these constants cause memory to be touched at sub-page granularity,
> leading to inefficient access patterns and incorrect page count
> calculations, which can cause test failures.
>
> Replace all hardcoded 4095 and 4096 values with a global pagesize
> variable initialized from sysconf(_SC_PAGESIZE) at startup, and remove
> the redundant local sysconf() calls scattered across individual
> functions. No functional change on 4K page size systems.
>
> Signed-off-by: Li Wang <li.wang@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutný <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Yosry Ahmed <yosry@kernel.org>


Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>


