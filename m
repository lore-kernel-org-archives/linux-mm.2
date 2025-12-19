Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3DCAE668A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 23:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C786B0088; Fri, 19 Dec 2025 18:44:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A5A6B0089; Fri, 19 Dec 2025 18:44:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2265A6B008A; Fri, 19 Dec 2025 18:44:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11F486B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:44:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6F2A8767D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:44:20 +0000 (UTC)
X-FDA: 84237851880.19.131BC63
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA72D40007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:44:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+TWJuFR;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766187859; a=rsa-sha256;
	cv=none;
	b=N54aaz1EP8W/LpjCNCWDOkSD8dW7G6Vzpo1CdWlhsyki3dfojZYc9SMo3IsmEaZc9bLnsM
	75iB2M9tk4hVksk7qWDuMmwapdLb08NbuWWZD1Oz1ltbCkcQwfoEO76Humpeq5MN/34d2S
	Reo85sq+BDjmYAE2yhchU/YTZSHMUuY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+TWJuFR;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766187859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCNM7CKQvW7IiJWIjYWIMSk4y/8kklTp5sAV5yymdxY=;
	b=OVd9QqxapvYtyGy/ItFJg2CQSk/vDK/4KWqRqHAMCMYE2Bv0i+KzIzz54fnlFHPIHL1onk
	ZfERgcyyIDBjo6rnj/SeXjnhhs3stnx3O5UD4TPCI6F61U+Rj6DPbuO5EZNhQMdK+vHauD
	sO94G3RmSlbUrUU8tJBYM3A8AY9nG9k=
Date: Fri, 19 Dec 2025 15:44:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766187851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lCNM7CKQvW7IiJWIjYWIMSk4y/8kklTp5sAV5yymdxY=;
	b=l+TWJuFRGO7tbzkNJUMsZloXTqpansr0zSj8/bmjfFY+sDbfgD4v5O45o53OsXFM8IhqW0
	Xoddxj09mZb+pRi4/CNUW3BOI1JGweiasx0O5asfdb3ebGENJH+QaZgBJKf0G0iBLY3eQL
	erqHVHZVd58wzuk4zuQUYtqHdEVYwfA=
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
Subject: Re: [PATCH v2 12/28] mm: page_io: prevent memory cgroup release in
 page_io module
Message-ID: <2vypu4pg3mfhmwyhwmlzozhdnjw4xne62sxe5hpqdohm3s2bjz@sk53oaivblz4>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <30588f984137d557e4663ae8dcf398b8c408169b.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30588f984137d557e4663ae8dcf398b8c408169b.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AA72D40007
X-Rspamd-Server: rspam04
X-Stat-Signature: tuxwqmcw5ur8yr1nhhq9sta5ofnd6dt3
X-HE-Tag: 1766187858-33201
X-HE-Meta: U2FsdGVkX1+Mk1BYEi8WaQtxBlmxYSoFgZnQBfLNvXY8KeXlviduQ3fj4bPdYuVsILMGy6N0rljr2m182Fw2v9bJbXv+t/+bDiCFtN7vUF6W3lRCvoo8Nr224YuNYm0KNPkZZrsoUIWATAmLwWwV0aOfejGSsw1ZASsJulerZckpQ2/iODtpqFqW/LibvbXEl6tLMkALBSn5zjkuyZzPfFx3kSMTBmiHwlXmP4LYkEjN8RrTYMrA2Mu4Hxrumn5tm8H9ZOsJrzAHG65QTO4tTX5Bj6YOi3k4GjO7zVE2fxbPYqeq6hgLBvUnblgx10iF8m1F90UcOl6oddv1EnOybGC+P+r7vynpYeT/tgTZlY4Oge8NLcsmdVFSss5qR0C7TSfDXSk+FPSe4z0tz4oLAukCi30u38SzC54o8lmkjsbWPoP6HPq+la2GLxfL7S6D5u8afOwqG7T6JbwY5m4EnWNCOikkA+dOSsKatKKiKxDnfWevP+fJ+ghjl744GzaKEf5Nuc7VbrfXXBtLCOM/7crDFrmNdlGlVGoMfIJKQZoEoxw5SRcE+b+zbmFQQPD2ssz8TSG0aLybej9weZ6Kf7PtXW6jYn5yG7lqhACYHCjIK87Kqu7bWOO/c46iBl9bRH9IR6Lqk5wfxrSHrgKR9UDkECx4aZT1ZCALUCj3jwDnBvAhVjbslTEzyGkELKqMXHwUR6fyI0WEsCJB1PnZUh6flZRwsfg5iy5FmMiGXxSWZhEt3nBnyMnpfFFgWOI2YR4yK4Zc2qe/61MGi8AL3Gib5NE2JXheWvBC3xe17NamtlS/vKKeIXwJd2aXcJVwRYbXRtkw7B8GBZVGMMHa7R5EjJPIdFJepU1fJ27KFtDu5lrNTFaIFO7Mcb92/bY/KwaRq2IAvj+RwKx66LOz3fIH7jo5DFHdvE3wOD/wrqwUDdcjR/j9phCfHZpnvSwiw2aqwRctEindJEe6Zwb
 oraIAVFS
 YdXQOwQLjbU8NvWNFqgC4RvyTsJJKIYjNg86YMqn1qy0myacY5MG1Jp6o/90zVRmw8C2o3HCWayBywSzFgq/m+h/SVYD4qheTwbksV/6PtsgSlYs5W6b7V+ttRlaISuPLmJ2E0twkLD97CWjmxg9Rgtq0yUSrjtvFrt6xrGQ6cxk80MUTNZg+J1RTt3yE6HMsXy9M91RzMUChSKbxm2NHfgnqAADKyFwz3UQvvwul8gYX9mpCSC1xBGdli9PwuEdpwwqEGC5AH3Dx8Ofq7EFP7iH6lP6nG70UycBLJCMoaCU3tW/CBL3hvoR+qSwgDU/ZIpANtccMAsmVOoQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:36PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in swap_writeout() and
> bio_associate_blkg_from_page().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

