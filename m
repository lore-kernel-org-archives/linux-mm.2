Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B477E668A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 01:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A2F6B0088; Fri, 19 Dec 2025 20:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50D66B0089; Fri, 19 Dec 2025 20:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69BD6B008A; Fri, 19 Dec 2025 20:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 957DE6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:07:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 425D68ACCA
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:07:11 +0000 (UTC)
X-FDA: 84238060662.26.84F8D94
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7052D140003
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:07:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g97rdkIf;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766192829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAphKjrqjGtN1vzz2t4LPcLdAhrEHZK9BY0S7mNcbOo=;
	b=RiUQYRFQnHW4LW4cJYpfjbgbPlCSk+UcoSVZOkm/bb808EAkStHizh+bps7uRVmebK56mo
	t0kX9ECb3oGm9lTqS4BpSTFSGhPbRB0Fxgn69ZYBXX9DfXWxIlCNSE+6VfDl8uOSh/za6B
	12A2gianNvbNjToLQOTvoXcjpxfU98Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g97rdkIf;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766192829; a=rsa-sha256;
	cv=none;
	b=udhfaGgyl56IGHM5UkW+put/B032hLXivI9nb9G882snNyywjlGq2iLc/k87a4gFLkPXSw
	pjm+c/T8z71/+jRZuHC7dnLWU9oHkl/71DJs15We9JemTg1mHoyP6zyuFzBFi6bOKIlsWS
	5tAEXfu3LVrZg6kAmoHfXSF/hYtYVpk=
Date: Fri, 19 Dec 2025 17:06:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766192826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AAphKjrqjGtN1vzz2t4LPcLdAhrEHZK9BY0S7mNcbOo=;
	b=g97rdkIfpKg5QZCcDhxIFJj91XdkNfq+KPIsDhnCs+oGBSkSRyLaIrD2sN93t37sWEU6Dy
	D711jbRqsHUL+u2X9oNbjKz//ZUGa28D65CER8I/7cZC6Gm6cKKxdM5bbdqdTm0Ak/Eoog
	Q6RWmMkUM8kVxoS2RXd88NyY2rnd5jg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 16/28] mm: workingset: prevent memory cgroup release
 in lru_gen_eviction()
Message-ID: <o6eacprzhnuyewlcorgx6l224jhga455is3kvnunpciqdn4lqx@p45cggmww6lq>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <86b0573753db20e40315c61f5d6e01bdc6a8313a.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86b0573753db20e40315c61f5d6e01bdc6a8313a.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1k3zs189tg6jj6qwhckiqikksrpho9cb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7052D140003
X-HE-Tag: 1766192829-921656
X-HE-Meta: U2FsdGVkX1/HsiHkYP90+bTChH8H7ee37Td64j9NCdaU8/yLcHD/nRbpJeXPp+idfdAeu8isX6n6thqzs+Ik62GsVj2n6IRljFatrUpNZJcKNXIc2SI6iepfFFYgBIo5RHhjTwNFFxmHg3DEfsF0WqMCV9C8Cb9LO4bos/aRwhnvK2c3ZMybYxRTOevX1Wws22ubwgNcizmd7q0IYdjZkEAoeiQYlU89LVShqb1bVkNH9w0A/UdgtGQjlzsuEcufPPDnNQQHyvT8EXT9hSz0kkFOzSSarD2LTnuX8KhFTVpmTm3zJy1ANTZZaYBCW8gWvjf8iHbeaUNx+4GDpx1ExiZdWiY0nW9knM0u7/exlB3SvDYSVPpWMPqZ8z6dStGOh1Wsb99nnE2JqSVYLZilxljCfwfGutuDinNbNgim7KdFnSq7LGyynwR2bFBDo07md1uH3m8VyZFkiReI35Zf80mo7008kweswcWBkReS/zP3VzKmMtLT5RNYrIm4yLwQ8c2CV5O8wNDcd7ryPUO7cze+10bdWsLtNsUo0CKBoRhOX04EwXBEXiP1TGvPt3KzO1Dv4GF4djes/KP9iljVf1YYh5HlqhLRS7IlgHukQEPvSzWsmiSE/M5gTgo2c1amZpOMeizNEIoMhoGHSjHJxz4iB50vuakKFx1BgXulhnDRV9iix8T7KvldM2sUhLdm9v9f+AII6r3BFQTdMB1zKCaTvgs34QvKWd93j7xsRHAf7trG5b+HVFICytGfkkrh/tEJVv3LFzUh7U7ETqlAstn18DXzrnMFLqMT+bXvwMN4uCFlPEeWu6sy11nzWxpfzTqNoJ1lRSxqNgWOsn11E/DT1E8hugQoS+kd8jRKEYR1tWvhLGjxDuQfcc1pvlqq7o6x8dr8fWBXe/ZCpgZCH5sSypmWb0GsMRswARdLf2SKDy8YWtPGCO4KCWUAiM26YF6pKAAa8Px5nwk0NpD
 Y6ryyA01
 LgeayZpDWsvkuM6o0xSbLzmn9gb7oiCNUp7RjwIgJOwZqzuEprHkMOCD7whAAzMr1qrz/LbFgo+lU7LJaMCwEgahQILK/LFm61Q5Akpr7mcbHss7jaUmTWDyOl2KWJXNm5ItMF8gbsc5iSwsdwu7qSzepvaQy0PJNb+DHaLdntjOf85eKLKr+XGVqE3VN2ya/MMo/rtaR5KZfwggqrqrD4Mw7Z8ocerw6/JtW92rRrv9FcD43kmbwe82cNk3cEufhxa2WGvVh8d6QC4sUxjiGehjHKZTDo7mytbImBfSzi4y1/n71JYHVGvXKJnLy/rUzk6h6Oh0mXyfADYg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:40PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in lru_gen_eviction().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

