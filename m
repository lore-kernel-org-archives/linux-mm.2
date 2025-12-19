Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60286D711CF
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847016B008C; Thu, 18 Dec 2025 19:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7998C6B0092; Thu, 18 Dec 2025 19:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65DFC6B0093; Thu, 18 Dec 2025 19:24:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5182E6B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:24:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B34D13AB1A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:24:04 +0000 (UTC)
X-FDA: 84234323208.05.FF9F797
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 39B8F140013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:24:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RZLJt1u5;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766103842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0+oX+rExeXmom0V9N+9NGQb1ojEVAyEotZoi27S/X8=;
	b=OKFQEd07D+HeaVt3oVjPQ/l6mCKPMu8J4yK9zUNwH9Td8IBrIUH9c5Poi5XK68tI0BP2f7
	m8ZQap279kFf7ORnR9jKKVQkJzpWGs9o+bYI85MLdTBJqC1wmNdFdNcIkZ7hEK+vhNpLT4
	lUVUWQMZdZVI7aehY798kDgdRvFbNbk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RZLJt1u5;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766103842; a=rsa-sha256;
	cv=none;
	b=ZaxyOcA0Kf7yvGiwskOc6/ODlFUIEP8yrtCak2E3M+FxCrAXmwMeXmrvCZzQzg7nakpF61
	tIE24ylgpJEcArhctQqa4P2nKJwk9k4wJUMln/OcoqqVveehaHsPnMZ/4CbGJ3CcBvFzHR
	zrWUZTrXsX0DlA6d17CaBoRajOqFNws=
Date: Thu, 18 Dec 2025 16:23:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766103835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0+oX+rExeXmom0V9N+9NGQb1ojEVAyEotZoi27S/X8=;
	b=RZLJt1u5LXNALiyxSmprVDFAeGIC8zaGmEKBAXGhMBXumB2jhDT9m3Pk3Lz9HhjTREr/Yo
	c2X0SVlJ3bCSJ/afGcgX87ZYT8QZyUalb/341yZwsC7GC1bCHFc6AHuhiul32xy/6y9QkT
	4hPhtTx8JW6Rth5C++VhaPwaCc0lHD4=
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
Subject: Re: [PATCH v2 06/28] mm: memcontrol: allocate object cgroup for
 non-kmem case
Message-ID: <l26tcucw2mwym44dftd54m2ewdfty3m4zwzewqpyj3bl7zrgf2@avxii6qcwp7k>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <897be76398cb2027d08d1bcda05260ede54dc134.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <897be76398cb2027d08d1bcda05260ede54dc134.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: zs5p9h8d17p7qysc6wrbyrp7ibn7eajr
X-Rspam-User: 
X-Rspamd-Queue-Id: 39B8F140013
X-HE-Tag: 1766103841-362548
X-HE-Meta: U2FsdGVkX1+Rnfkk1yxvcUODadNrVwIlo3/3InljG4goHpUVlu4H65kyWZW7GNpZ1ZVrEV1Vy0ncMxfwZSRSzXSVMUZQ0XzyPqKFoiXAXZ7uT6KPMqmYaIB+QjDt2gM/E/BkEhu5kRrqxHetf5ZQC4U3TD5iPDQlTcnxBCSLb/rgaVVo6Uh/oXODFO+o2TTkYJ0JleudknNwziKBJrs9CROZC+ITTgjasOJpL+ueHnGVwvQ07WzU2oxx7Kc1SEaxMjf/OJtzvV/E0K8I7k+xBvz5uwsIBJ6Nxn4s5ozW7vpcnJZREafldpeBGLhdtG+JIXXLet8OD6PZXFBE0SKsSs59BMU43PANnNqNDsnVkL0hiiDjj2EW1FlMMArEDY3+Ol/HH3P6mLgA+WNp/E3Pxw1in17Wcp0+TLFlty+FlP4FZokOJjcgP4cz4Q0qkuemROdTlbEaWF+0WS0KJq3Pwgfhrm4B7po0PvsnCJ9ekvNlKgJlI5f/abBXAQ6ke5bKlKdzjeMaA2AzUHRJ2j2gxmh6iOERSnnXtu4UuQ6WgSqz/DvmYfiKDOjtzb1rGDqT9PPvLkRCgd6sAduZpSBTOO/KbSd12nKOVCOXTD0jbp1iGONZI9FD6l3lFgVXxKC627sxfcFtl1X1Yo2KCclIWHJh6Lh9tSJLJvFv+XfehCVh/Od0EPux0yR3J8X9yRaECDYwJACS400ByaHXdxqdNWAcKymoORKVpoA5F2yr1SWHTlP3QtgVPkUlPBcDhAxlHu+WdIBNkwDgKMnBkF2bd5/bv42nkPGn0wbFJusrdm5j3J3/xFNIA5A6bkLwzLI3kzhKPjGl7r9iNXg0Pv8lKKB6i0Vp5/joBl+V0NsDLtIraLUAggbjEyUbf9eWAXaYdzURkv0GBn/mIhxYlIs0b2u9dBQZygUjtILwsvFJ3wc5dlt0qcCHGcEDxj6KiQpf8rvga8QYO+cWOnLoVDv
 K20Jmv9p
 bCrnrm+j0OwEiPLa6qNm4vt9NsVwot9PQvQ4x1KHYYulVMS4zqZpz7bO+GZ+S/a6WM7rLUa3aVR7wKIyRmz2LI0z508Ww2YeY9qd3Z7L6Na6EHsptNNpoUKzz8bBxkItCn6IE136UH0sJqfBvJn4+H7Oouqdx4JS+BZGlQN5OzXUOLJdMYQfxuiRZwCMbvvsErnymJmpZXgiYT+CgOFCpwABWerkr/WiHDsQB1dLBJwHcjP7COS0bE9v+MY8IJEeyEkrH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:30PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Pagecache pages are charged at allocation time and hold a reference
> to the original memory cgroup until reclaimed. Depending on memory
> pressure, page sharing patterns between different cgroups and cgroup
> creation/destruction rates, many dying memory cgroups can be pinned
> by pagecache pages, reducing page reclaim efficiency and wasting
> memory. Converting LRU folios and most other raw memory cgroup pins
> to the object cgroup direction can fix this long-living problem.
> 
> As a result, the objcg infrastructure is no longer solely applicable
> to the kmem case. In this patch, we extend the scope of the objcg
> infrastructure beyond the kmem case, enabling LRU folios to reuse
> it for folio charging purposes.
> 
> It should be noted that LRU folios are not accounted for at the root
> level, yet the folio->memcg_data points to the root_mem_cgroup. Hence,
> the folio->memcg_data of LRU folios always points to a valid pointer.
> However, the root_mem_cgroup does not possess an object cgroup.
> Therefore, we also allocate an object cgroup for the root_mem_cgroup.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

