Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2483AD2CE11
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 02:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF666B0092; Thu,  4 Dec 2025 21:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D74C6B00EE; Thu,  4 Dec 2025 21:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314516B00EF; Thu,  4 Dec 2025 21:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6046B0092
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:57:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE59F132EA5
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:57:38 +0000 (UTC)
X-FDA: 84183906996.23.14D4A39
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf30.hostedemail.com (Postfix) with ESMTP id 95FB980006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:57:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764903457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O/Di30vffiHIvqb+A2NydyaXMbrPD0J5pK6PZKqvhUM=;
	b=bIhHotQRHVubFNNxwAwR0hiSAc0kjuB+a3VUkalZ3wlQbmT02KkqGmpHoP7YRSdUgDjLDk
	W3HzNOjMcI0FjK2R82FTFXrQNlcEh9DCk9OzczczoiHM9IrAdJ+rgqNO2ULenE0NeALn8n
	5gzZRZL3hQGaumxe2Fv0c9Ze83ao9m4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764903457; a=rsa-sha256;
	cv=none;
	b=M1Y0K6GGHqRLsTJ3hlsBMelNxShwHVwiF/RLy59+8QAfzHyXwpHI75asdYvl0ZUDPX4465
	n+ta72ujjdNCsFp92tce6uhXEi7YZqs0cCQC7A4oNX2obNH9XL/+69LkzjldFwY1I9IWUb
	tlagKrU6IhdgdcuUc+iAmNqPN3IqzCE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dMww86G3JzYkxrJ;
	Fri,  5 Dec 2025 10:55:04 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 5 Dec
 2025 10:57:32 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 5 Dec
 2025 10:57:32 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <hannes@cmpxchg.org>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>,
	<axelrasmussen@google.com>, <cgroups@vger.kernel.org>,
	<chenridong@huawei.com>, <chenridong@huaweicloud.com>, <corbet@lwn.net>,
	<david@kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <lujialin4@huawei.com>, <mhocko@suse.com>,
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, <rppt@kernel.org>,
	<shakeel.butt@linux.dev>, <surenb@google.com>, <vbabka@suse.cz>,
	<weixugc@google.com>, <yuanchu@google.com>, <yuzhao@google.com>,
	<zhengqi.arch@bytedance.com>
Subject: Re: [RFC PATCH -next 1/2] mm/mglru: use mem_cgroup_iter for global reclaim
Date: Fri, 5 Dec 2025 10:57:27 +0800
Message-ID: <20251205025727.8324-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251204183437.GB481418@cmpxchg.org>
References: <20251204183437.GB481418@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95FB980006
X-Stat-Signature: 9mkwaa7uodu1ud4qs17oouowmqk1s8uh
X-Rspam-User: 
X-HE-Tag: 1764903456-630056
X-HE-Meta: U2FsdGVkX19ZHmXzBp8kN7yvVlrQT/oJuV66MIKVoP6e0ay35UopyTHgKsN+WTOdk6j8zEjn4H1B4sZMTxQHzJfs++gPUjuOZfnY/CBvoTaXckMeREIu9Jcg3cjd2TwG9kVSnRpIQ1KLUz73SusGW7NxLYJMi1zyFTuWuL+j8C5Lk8Kq++AvGi20UE9PXXCZ9t9e8EQ3TZk1oIET52SYr4GQQceD1Qhaf1Yj33i1NrFBwKRyKoSMFsJCuUrKVxPnld+3f5X8jjYuYeKd4ffHrwnEItoEQXGLix4CwKVXM23LZ4E+kfKZyC4ABkn2ebn+12kDU94rInpQt1dkIaiRUbKfKBBVSoMfYdYvIzYZ7GNA6X6CtpaA558nCD5FsKMXFCCf65o2r7yh7tm72tur5Jmglgfb7xBXODLnENijiRic0y010p0Z8m17h25hfqvzOKjxX392RJ9ID0y7bM8EexDayHiT1xA1aNY7x4xU2qeOg5uM81vPvBZbb6imkobWs0FTEUqeSiDmse7Ei7OC8VF5KqPvhC66ccDNcuYsXTMp301oqN8/9RHwMjQDkGP3IXnLSoPzOIiklQGsdTbVvk+LVQV8k4crPVHRIBIG/TQjA1e3cexAiUDE2/0c2zM1W6YGksoBZHnqbNB1+vSMHL8Jiws8+iXafcmAxKQ3tz9UxGKKzjRTMos5c5DEoXQMQg7Uk9Ac8dg5m+Ja4TUdG+tDbB+jtwnZK9kFH1AVvNFN7Bnls+O5TAneILdOq/wnKMN+KrNU9FYWiRPrxL3aeqVUYlYcbSWe+7x8jYsIFZcgJCJ7Y3e2dkl0EinAn9EE+cWZPKkreOhwG9pWKzDnt8FWBlqwPaMN5ydoW9SuEXj/Ay9KVxm5gVpaMFrSmzzaGOl55tWlM49wdCaRSaj4dHRCeTl+nrwT+Z3E0KTpAJ7LbxholZdYAQQTKUPljIRcXgFBaHKVAQjb8ycaKni
 O1K0utwE
 GM9L6UJqSHfB/ipFbf0nmlLenkYRUQf7Pij0ee/n6NSy4bPsGFg4NEBxGilUkfcYGAEuiGLLo5YZCKsqDz0+MbutNDkvD1xgYKBk9xQ2wYLu5f3M/J6ciJisIs8gBn2/ifa/5oYD6e9lm95XRpdpAP4FyVgKkQUltZ6AiKgSClz7Ta2xWDPmx/ydyyLe3QFJyzRf1rBzJuf3KECmvosyszchE6XK78CF4QDXxPrlF5VAK9fr+3jqCBzOpHYxJ9gKXTNAyRpZoU1uMN9RyoKtcQnOmqiJ3adFypdIK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Chen Ridong <chenridong@huawei.com>
> 
> The memcg LRU was originally introduced for global reclaim to enhance
> scalability. However, its implementation complexity has led to performance
> regressions when dealing with a large number of memory cgroups [1].
> 
> As suggested by Johannes [1], this patch adopts mem_cgroup_iter with
> cookie-based iteration for global reclaim, aligning with the approach
> already used in shrink_node_memcgs. This simplification removes the
> dedicated memcg LRU tracking while maintaining the core functionality.
> 
> It performed a stress test based on Zhao Yu's methodology [2] on a
> 1 TB, 4-node NUMA system. The results are summarized below:
> 
> 					memcg LRU    memcg iter
> stddev(pgsteal) / mean(pgsteal)            91.2%         75.7%
> sum(pgsteal) / sum(requested)             216.4%        230.5%

Are there more data available? For example, the load of kswapd or the refault values.

I am concerned about these two data points because Yu Zhao's implementation controls
the fairness of aging through memcg gen (get_memcg_gen). This helps reduce excessive
aging for certain cgroups, which is beneficial for kswapd's power consumption.

At the same time, pages that age earlier can be considered colder pages (in the entire system),
so reclaiming them should also help with the refault values.

> The new implementation demonstrates a significant improvement in
> fairness, reducing the standard deviation relative to the mean by
> 15.5 percentage points. While the reclaim accuracy shows a slight
> increase in overscan (from 85086871 to 90633890, 6.5%).
> 
> The primary benefits of this change are:
> 1. Simplified codebase by removing custom memcg LRU infrastructure
> 2. Improved fairness in memory reclaim across multiple cgroups
> 3. Better performance when creating many memory cgroups
> 
> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
> [2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

