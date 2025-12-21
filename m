Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9312FE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 15:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09AC6B0088; Sun, 21 Dec 2025 10:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB85C6B0089; Sun, 21 Dec 2025 10:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9BD6B008A; Sun, 21 Dec 2025 10:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C97456B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 10:49:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B36FBBB9E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:49:28 +0000 (UTC)
X-FDA: 84243912816.09.77BF1B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C26CE14000B
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:49:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EalTEbZh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766332166; a=rsa-sha256;
	cv=none;
	b=gZS4PoGEMYgLMxsIb/9Xdr2RjDlq8zTyalxw/50vUS0TRaaU/JT8dfSpZiuFIDJT/W3NRb
	Mraw11oQ7BKKMORVukdUaVHzcqx4yOXWWsy6KI/AkK/m9+SZZsJwjbo4yAhb6JgaQAj3Uo
	nBnfUBSipJXOD7pmGWtcFBbYeNRMIuk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EalTEbZh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766332166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGvG8mchnhSMPJQpquHaoBQvGzaLpX/CjA5KyHjwBQk=;
	b=7IzsuS5Kyf5HYeqDYdlP+JGlbOw1FO/J5CXZoevyWk0CvsDL6Dikt+YouFgj+q5WKCpA+b
	3LzmEWcQMJdf1ALAvCGxfC4TA4VH35on1jcZk/SMYpBUeeb29cam7P/w4DzJOy/CehU+Lt
	UOf4X9B4HhGwWYDptfT+JGEf/pASa9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF44860007;
	Sun, 21 Dec 2025 15:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008C5C4CEFB;
	Sun, 21 Dec 2025 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766332165;
	bh=p++ab+scdeusI2vZJTjgYwM79xzmVgySoMmqEdRkErw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EalTEbZhrGgrW+WpgUJ7P7k4WQW/3fCqLxM7be1fN7KjZbdOrmrXIU2zNbdexG8AT
	 X9M0Xx59AFPBGRIBTvEyV/FLah2Fp52ZmYMCHcpORBjJpb19YZxl7tK5qYKxb7BwiE
	 +WuDtoTYS4sIGkxyiPphIrapYgLBR3bgKpAXHTdJeAUMD8jm0mCOjXNETbAzDOh7Hz
	 KoutTTWwFMp3JQg8l6XtGa9fP+JX+JF4lu1S77QJ/nn318DCYpWcDLdG4yMf1Np1mT
	 c+21uigte7TXnEjX3e4IzAyoMEozEmjnHqDj+eiwIl9EOQi37usKkd1oNXPNRBTTK3
	 1brEb9KuoorRw==
Message-ID: <a3e218dc-7e98-4254-b051-77ea930c2da0@kernel.org>
Date: Sun, 21 Dec 2025 16:49:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm, hugetlb: implement movable_gigantic_pages sysctl
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com, osalvador@suse.de, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
 muchun.song@linux.dev, hannes@cmpxchg.org, Mel Gorman <mgorman@suse.de>,
 David Rientjes <rientjes@google.com>
References: <20251221125603.2364174-1-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251221125603.2364174-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C26CE14000B
X-Stat-Signature: uzrqerwuhu9w1e9bgpumaq7ns5g3tizd
X-Rspam-User: 
X-HE-Tag: 1766332166-285602
X-HE-Meta: U2FsdGVkX19mL6aGfLxkidxLBQJj8vBjCkhNFzCh3Mwgv5dQWoryNawlOUJrOT60VGfPE6fN+IsTBAD+je7o1pmZY2Cxd4/i5K45gTc9Pz+1wen7awJ45vWoz6kK4pPXjcDOAFBPSqj6VsFFs4ZYTIRS+AFdtAw85WhiG7velataQsIfbXU4wsemrEdAk4ZMo2QhU2WxG1itPj8xJGjtPHxsKJzMtISMRnxbBmSUTL/2jYuo9cWGj3Ez4PNYR0+M8qWkY1YeZQVcUOWa1kxpG8j+yUg3kWG6/ImX3tUdD2CfCHRnMFdX2Q50HtNPey5vsr1YDzkT/vk9UzIVm7ei+Etixekkf8cmzWURSNw9LYXgXc/8XqKXgSqvVrvOMXkvzDnvjpR8GbPHOPVZCjVoq364eHVlsvkO/VbtGzH4nJB5m6YDCjQDsYo9pgT7r0KIsIQ6NYcQEItV2k0T721p5c6D0hDRDsOlsh3Sf8NdyBnBTQNAiTKmNNuq8WVjiDg5qt0nYJndShHBYLLaxkJoI6JdJBm7+auA7hNv3QbWAc9JDMxG94nTPmiWddBbA63eykaBWjrORYsNBykKb8X9pWIhItPRa6ekwyoOUer803STlhekfatMbGtEFzLGIsNXpomBxw4VNFiQ+F2D6IumtDq7LABAbmcF8SNAT67ZGECIwHmqcYfL3xHExbUF2r1Y7OEf5uQWXN8yrq7rPNq+L727Qiez45Sr0TTSrsj/ghwiQbp4KZ77Phx6y+7jmzBM+8IqsFMhd3S9m8FWizcNxTzF/vxGn4rN/b9USUKtQch9xtf/0PT6JZw+e6S+MPhCzGAW25p9SdqZAXxaSDy+SsYQyeYl4V7+55reQViyrnQWnu8dDBdcdAHlcvmSU8XpUpA3yJeJ7210YvaTYCp2v9v99EzOOVg+1HqHhVAKDUljG73URTNyyppNkWHOEUKooW+gkRtWrmcg19kvBds
 dppQLiB0
 fX+Zeb/Gi5dPQ4u1J062oCh92mwTDnVl0nZ796yU/xY4hTNVJ9vYi45oLAkNjUgqa3w4e57HmRHw2JYYEFNLEetVunoleZ497TpZOqDya4bUdJ0bL3lpYNvWeRpoMMfogFUb4ezeN7KXvZPuHX4KITAAYmrf4P2TX9DAIE9ytgWQSW99ox/vXpq/c9fgpP2eF26thAkOVlp8ageGXYnEOcTQErBZ7gxzovWzcJytxk36A7rzKuPVZOMhzRmiUXcBXpayhGpzYLOeytb99P5I/aihclgWbWuPOaSEbktIA0DGqc+MibWzTGziHjsVu+xnvh7NDqGGvayU3s3n3H9Jgp1sTytdxdstiw0XfqkxHjOGVMhs5lhKUgLBx24v2yJO56jkO4lyHdFC3mgwIXxxdIXplBfw9Bxu/nbHjIR7gpSBXtmM48FShHaySP40T2xkq0CQ1QPwOyXx4+1fUdzl7tT4+R1t4rBklhU9bBgA5/THSII6eUfD2C79BqoR9cTlQ5Wybzh/pyVJu817fqqG9XXZy/GELwJgoz53e6OXGRsKKs24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 13:56, Gregory Price wrote:
> This reintroduces a concept removed by:
> commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
> 
> This sysctl provides flexibility between ZONE_MOVABLE use cases:
> 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> 2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable
> 
> When ZONE_MOVABLE is used to make huge page allocation more reliable,
> disallowing gigantic pages memory in this region is pointless.  If
> hotplug is not a requirement, we can loosen the restrictions to allow
> 1GB gigantic pages in ZONE_MOVABLE.
> 
> Since 1GB can be difficult to migrate / has impacts on compaction /
> defragmentation, we don't enable this by default. Notably, 1GB pages
> can only be migrated if another 1GB page is available - so hot-unplug
> will fail if such a page cannot be found.
> 
> However, since there are scenarios where gigantic pages are migratable,
> we should allow use of these on movable regions.
> 
> When not valid 1GB is available for migration, hot-unplug will retry
> indefinitely (or until interrupted).  For example:
> 
>    echo 0 > node0/hugepages/..-1GB/nr_hugepages  # clear node0 1GB pages
>    echo 1 > node1/hugepages/..-1GB/nr_hugepages  # reserve node1 1GB page
>    ./alloc_huge_node1 &    # Allocate a 1GB page on node1
>    ./node1_offline  &      # attempt to offline all node1 memory
>    echo 1 > node0/hugepages/..-1GB/nr_hugepages  # reserve node0 1GB page
> 
> In this example, node1_offline will block indefinitely until the final
> step, when a node0 1GB page is made available.
> 
> Note: Boot-time CMA is not possible for driver-managed hotplug memory,
> as CMA requires the memory to be registered as SystemRAM at boot time.
> Additionally, 1GB huge pages are not supported by THP.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

