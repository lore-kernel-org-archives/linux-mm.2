Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68013606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tychen.cc header.i=@tychen.cc header.a=rsa-sha256 header.s=spacemail header.b=QFssQDBU
Received: by kanga.kvack.org (Postfix)
	id 683A16B0616; Thu, 19 Nov 2026 06:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AC36B0617; Thu, 19 Nov 2026 06:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570946B0618; Thu, 19 Nov 2026 06:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3867D6B0616
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:24:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBC8CA0A8E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:24:33 +0000 (UTC)
X-FDA: 85451635626.05.5747093
Received: from out-zbxj-a76.jellyfish.systems (out-zbxj-a76.jellyfish.systems [198.54.127.76])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF3AD2000B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:24:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=QFssQDBU;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf03.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.76 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795087472;
	b=Oy06nujh6r3oQf+C+x7oR2JYHKRlAmea06AYyt/a0+GWCSTu8aSrcuWmqxvAxUkSU9Mb/0
	IJTbW7o93ThygpgnRIwL0iuf6Mjqbi3/KlUh7iLD9rY6HRIjrFAPTh2ZbAXDorHQ7EDVim
	bVbzaXX789up4MgD3btR5QGucJyCBjw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795087472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Y4HSKGmKLqBmv82uN8Zw1yJpfCCeKgGfjpKz1LLlzs=;
	b=2J0zJ659mGNvKtp6R9t7zhmlGchhZlVwkKmRIo308NnBoSvdiAAu2J3tUpK8yMMqnJ6IE+
	HN7Jy0HZDqpuVZSDpQTxSt4WrTSQcC9rC46FpXk1PIn5tGL1GB6zPardTNw2KUqbsMqnui
	3Kr1yM++gSV0ZrZMhthyufp3j45EET4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=QFssQDBU;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf03.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.76 as permitted sender) smtp.mailfrom=hi@tychen.cc
Received: from fedora (ec2-52-197-241-54.ap-northeast-1.compute.amazonaws.com [52.197.241.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4jVbhS4WPLz8sWT;
	Thu, 19 Nov 2026 11:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1795087465;
	bh=9Y4HSKGmKLqBmv82uN8Zw1yJpfCCeKgGfjpKz1LLlzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFssQDBU1bWgh5y1TGsTPlJBzh222++oczH4cleFn81Ik9KK1tcsybvy2u8PoG98e
	 9E0oFppVnJX46zo5smPRv7Y69CZiOxAsRIXtIqO+/mvKfUZJqP0HCPXqh2FYWHpkyP
	 j+7rU7BUV3pZQ+I+zOmYB05/vr5sEUJcKPu8NP0kDSEcazUaz6fCkNU92yM9o7mbYE
	 DJaYV3Kj5jLcKP4kHLAe7ycckEVMZuF0tIYhOIT0BV7idayvyclagc6LFG8IIp6vrv
	 mkzLXPapiNWtPHXOMz7nMy3835yv0C0JPXl1npzATBg3tix7i63IkvltjWJXkERgGv
	 wWfrRY4Li7D9Q==
From: Tianyi Chen <hi@tychen.cc>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SJ Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	Maxim Muzafarov <maxmuzaf@gmail.com>,
	hi@tychen.cc
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
Date: Thu, 19 Nov 2026 20:23:56 +0900
Message-ID: <20261119112357.275352-1-hi@tychen.cc>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EF3AD2000B
X-Stat-Signature: s6o4w6c8z16xdkysq85wymshmnnhikuh
X-HE-Tag: 1795087471-656311
X-HE-Meta: U2FsdGVkX1+AIRrnPVpOG3caafTfOoDtewozpkVB0hjCzdyUMJ3NVnDs7jNlc/xbhDKhWcMpB+9ZlMBMJ6dJbqylsnDE+7UfYncS+XlqfzpHcq3+RZBlS9ZVaB+DSfzoRGzymXEm/g+1x4j+EQxtmFv1dR0pVgkfD60B7v1lCIjuPSYe9hCXBmESobP/mWeL3Rx5eHdUKZOpn4Q7v3sQoU1ruiP+JCpNJfx/UpxxUwWjFUA0yRD8uyOjKIHi6Pz8nkmzQgtZE/fNX7JxokJl/Gj9RW0H69LoDWWl1u/kdc+wKpNd2FobSZZRrwFa74k7pbXGMDGRGrxhcd6PNiNidT+TC0yl1wWVIonGP4jJ5tO922JBoH91nHJR/dWgDp9pTWVFy/4FVogttt/L2Ydd7S4BkfIH422/rre8T0j6M3i58rHfEcHGAF6TqL8zkjTBHlea+igIJ7cOdVIm6XbPXo+XlyZIAsJXhGCV23Tn940xyPsKkWA3/Cw/V8XHVVVd473jEJaMfEgzk6KJrMPov8g3ZWur1XL9cWZmCphEcvoZSveUPRT482Glq35q6VAH4VJ1edyy/EsfAN/uQM5oHgeyKw37E8T4UvgETlv3qaguVlrYXYuMUoTFma0riGMmnmSex3yfOkpHGbyKOQWuXiRjlgAJo7JbHLHtYeV31acYC/vVVLoGo/Nw0yl+BjfnIJyDQdoH299BY/i1nz1aJZu8BhDB3oyWNQdS0r6VdNuKyu4ULIei26mNaeg5p5WNqpGwXN8cusQxg9Y42YJpsdR3brxxeCyLpnrgcK2raIan/ZPQE3OdT+wpxnDcFQUlheZeHUmbinDGj9mQyMmgh59MC3KGQyyXNnPad0g4HTk/92sMQ1Jg/i+hzhJiNGfm3syYf2bp2RcwU9+RyFw7M0zk1lGv393CxYDI998vvgzIn1DDjRSQjdvum9ewLNhqQdODLxQR4CXfw0j26Wm
 l/a7jgBS
 jBe9tyx2nkfXoMm201tTy7Tz2ui1RbcqUdhenPzUHtzx+KprB4hla8IUhFbQVXt58OTVclCV2ji3NXg/8bZjdOy3UwKunxJbKdQQ12SUHjErVI1QuEKebeaMLysYQSRUipDj/OgrJV4ObDpr8/Ep/TRqryn8qDAkt23b6A/SftKa3hN+fdr3Cr+nLr2XK6YERjl+2wM2djfF3FtkUEK3Pjq3gQlMj9opB1BdJr7BLrA21hBEp20cEYvXp4AaE7LjkRrVhUqUyMBeHaNgjVaZKfGb+SN9PjoAH6YJX1OQLDuLlNQlfkT2Tv3tex0ymLhgU7SOUG7DHc9Z6Klr9kSk2py5oM5zbIK4EvWKxzWpHFnS+SzZBsxS1J6MW2lyJlYvsQcxQB63EIV59XYVv8B4Pk3EjZsHdMH+7lLleEu7z6uMJtISJa9PiTu1+//xdB8ZkWrIJJrm+gW6whE96/2mDvxwSeGsKT8ac7vd2CORgTTYQIbYt7ov0Dk4vwVF0ikvpVin6Auf6GB1do1SmdVSihBvifak8Vati6ux1GBi+YskimFsA4ZgfzPJ3AalIufzlq8WRT5z4wdjHWrPbyzkt9HxQGjctCPU3K9jKfEUHs4lmjguavvDB+pGbVNWuGTUJhFkmwN70seSK8WmymlXAaTat5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 05:03:32AM +0800, Kairui Song wrote:
> That's because MGLRU deliberately disables hotness tracking for
> MADV_RANDOM areas while CLRU still has refault distance.
[...]

I ran the OpenSearch k-NN test from the RFC thread [1] on this series.
Its .vec/.vex index files are mapped with MADV_RANDOM, so from the
paragraph above I expected no change. With FG the gap is gone in this
test.

Setup: 25fee5b1762b with and without all 17 patches (they applied
cleanly), the same .config, and a fresh 4 vCPU / 5 GiB KVM guest per
kernel. OpenSearch and a one-pass 96 MiB mmap scan share a 1 GiB memcg
with no swap. 5 seeds, lru_gen enabled=7 vs 0. The script is unchanged
from [1].

Medians over the 5 seeds, last 1,000 queries after the scan:

                  p99 (ms)   memcg file refaults   .vec resident (MiB)
 base, MGLRU         66.18               144,387                 99.98
 base, lru_gen=0      2.09                     0                117.19
 FG, MGLRU            2.16                     0                117.19
 FG, lru_gen=0        2.12                     0                117.19

Right after the scan, base MGLRU had already dropped .vec from 117.2
MiB to 54-71 MiB (median 66.3) in all 5 runs. FG kept the full 117.2
MiB in all 5. All 5 seeds go the same way, and classic LRU is the same
on both kernels.

This is one synthetic setup and I tested the series as a whole, so I
can't say which patch makes the difference.

[1]
https://lore.kernel.org/linux-mm/20261119082441.196139-1-hi@tychen.cc/

Thanks,
Tianyi

Assisted-by: LLM

