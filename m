Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F068CC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030536B009B; Tue, 15 Sep 2026 22:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22D76B009D; Tue, 15 Sep 2026 22:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14276B009E; Tue, 15 Sep 2026 22:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC23B6B009B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:33:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D20B1C289D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:33:04 +0000 (UTC)
X-FDA: 85218053088.05.F2AA313
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D44F40003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:33:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vl+EYyYQ;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789525981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtzRreG5mvrnqpBuuHvyHi0W4HoPHBlfILTUKaW9cXo=;
	b=NABzGVGyQacT0bbdN4e5USR+suKhldXeSDPmfnWtfkpQTDuULgBNIeRm4rfnap0zrfhus0
	mMdeTUp4xlBYaOpDZqpFRUMNFjT7BZOIYimkQczukaxTVqBYHMI6FG0aD/JtIuCXXGXBH9
	+CWq4GemaBsymGJwHcCUaetCXyz74Cs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vl+EYyYQ;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789525981;
	b=P0/wseHX12liCwWh+WOalUBce80bNtgtvIxsj1ls1ujh820A6iEW19vMh8M4//PBMPgU3A
	0KLvnvUF4RScTgnrlzeO6kXTAIKlYtjxXLFtyqTgAw7x5uZfaG87UnPiAUt1qjXyYVTPTn
	/zv5g0Cs3H+4r/6YYss6jiyFQkamvSA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EL2OlE49I5JY81apAvNWZqvNiNlpta9PbuUy1mYyKIM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789525978; v=1; x=1790130778;
 b=Vl+EYyYQbU6OEG/du4v/iP54LiQa1SuyPS2vamEpynw/r/G5sG1zzqaKuGm7YLKtgOrrUGzx
 YQt7erpMiIVhF2GWnBb0Z2LnOH6Zj96OwDmbjR/HqjiN8k3JrXxQFoGoPLgvgudTma0K93nqTQK
 QToe55+12PflF64iVD66MCak=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 227d476b07422197;
	Wed, 16 Sep 2026 02:32:58 +0000
X-Mizu-Trace-ID: 227d476b07422197
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 05/11] mm: memcontrol: constify the mem_cgroup
 accessors
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-5-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:32:36 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <B130AC93-87CD-4FD9-88FC-B57798DE33BE@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-5-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D44F40003
X-Stat-Signature: 63kknbxfer183p8psbf5wjwrh931xxu4
X-Rspam-User: 
X-HE-Tag: 1789525980-719822
X-HE-Meta: U2FsdGVkX18sJy/yVOeiDYJP/xK00eGyNNn9Ax7WrzFcpR+fRMY8wm1WQDQJGs5C1NkFqjqt6n07tVBsWft9I/gEl0+fxbZiBMz7NrWyULl40m0Wqftxi1IgEI2E7DRZgDH9gmMIRH78ME3VBF7pcqezcIyVio3el9DJk2GRMO/cndyPGGkpx3zmydzMvWGVvySuniTh8uxPmwGQtJDA1i81/cjMofU7DTk98978BPdNEbCXWqYBm12cJtOSBTa3Qi09xPZ3yPaaylRQA/GcDbOza9z+AvE+Fw75huiHjsNj5spOOdW4Iw3LtrD6Jyx99JSEltwptpySU0WvL5mmFHj8zJfDPQasZOk0MB+492ZfMT3B+ZEJfh5ScTk7G7JDta9IudBT2YeEO9+Sit6MZuX1n3Evz6WqLEQntSW5vbdH1C+kEMIfhWGFYwSk4kbZRan9CT5U1K4r5EohvRmLPEs/ISwdt5R99mjz1i5u+yM2ApYMPtS1TmlovOStq+2/F96CI/qCFgL12Z11mPDwpZCU25WJtQ6KFAnM+x3MZada4dSgi7WtCgMuOK1PAanjI9vjuctOrQ1wfUIDcoHlP8sGKU340VtPtofne6qmE2Vk9NIsObwlRxFZj+JYZxcGRecnGD7i7IQB16jpa6aXppGbEoIqlb7vbcbXCyBaUXj4V+4Qs8vIQ0XuQwPkmXDzvAJT7BQVRfNO3PfNL5Rp9g/2znTefKDcA9IEJ9akL9gVJ/y0o74zvM2UKtkHrZYys2w7ltybdTnw9FMH61q8SaTLwrSVJqMn0KeR10ZbwI374bPT9uIXjyrwH0kq+xdyRWO+eDtKvmWkRGDcssd9+2SQoVH5Sp4PFh4UEHWSybjLYb998p762pXwcabWiOUCacXsdHFId6e73peJLSdwuTMYef7NCa2L+ag5Cs/tEmzq5FNWWv5IJcycVnbMweP8BPeLxjrC2YDvC6hB7Lt
 gUTdB5Jc
 aofDPjjhivf3rKNHQpg6Zhju1htNVkjGksYahB4yjfyVe92WgEUXarpf17aPPSMqO+r4XbXRuy4oj/qP9mbcoz0Syjn+iq1juk8nW3yh7z1YUt9Jv3xuK4TgVOHy9gPTK3mgpd1SS9/Xaj3/bCqxkE6UvCT5Yy8ingVzxpakSBUmiTZqfVfs+4pAnlFT+k5WhS+dhbbv6FAKoTZq1cOq4BAtFMazOhzrb3NysEt4MV5lTijMqtjzRIBjoy+pEvO/5oEvStC5uUIyS2lh2EhdJd2gPx+bkGHfpFg+Sy6Ty4LX9+5YgsvoTqyNQng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> mem_cgroup_id(), parent_mem_cgroup(), mem_cgroup_is_root(),
> mem_cgroup_is_descendant(), memcg_kmem_id(), and the other memcg
> accessors only read from the memcg. Constify them, along with
> mem_cgroup_shrink_is_root()'s shrink_control.
> 
> mem_cgroup_print_oom_context()'s task stays non-const, as
> task_cgroup() takes a non-const task.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


