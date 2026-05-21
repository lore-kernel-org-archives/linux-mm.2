Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFDECD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A9C6B008A; Thu, 21 May 2026 04:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB466B008C; Thu, 21 May 2026 04:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18856B0092; Thu, 21 May 2026 04:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D03EF6B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:48:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D70BA0577
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:48:14 +0000 (UTC)
X-FDA: 84790800108.14.1317236
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id EAA9540008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:48:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cOpbSrFz;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779353293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNVsGGEw95+5JljDAToyIzMIwooJ11i63IvGijfxMd0=;
	b=Ei3/Z1hJpUP2pwK3EiwN4ZgIoGdHFLVXkZX2IAigL89MXN5vTp6OeDC2jAgcYJu7aDpc2h
	+lW8vlt7Rg8pLvYO3uwY2WKZmbiKDkbPC8RVi/SrndooZJb5d4giT/hlR/CGMhE4F09AkI
	jHRmYrOouR0lcUQ2FMog8F8RiTYX/TM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cOpbSrFz;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779353293; a=rsa-sha256;
	cv=none;
	b=sxWRpc8pP/kkNuLEBdRHrspdn7JwEIMhNJkC3ZzbkGPXFH5uxwb4eGSBpumHY5Qd2KeEPV
	BAxKNp72sWkZsIPVB2rQ++OTaTz4tjs+vHD9KUWDhAX1wPQK+VyUAeFH0pULYNAImHUQuU
	E0Jbu8Of7sIHKKKJxWTsM+ahBvHWmy0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDD9143C5C;
	Thu, 21 May 2026 08:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53151F00A3B;
	Thu, 21 May 2026 08:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779353291;
	bh=pNVsGGEw95+5JljDAToyIzMIwooJ11i63IvGijfxMd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cOpbSrFzsblkU4j9n0Wp5hApJp6HHtqth4BLp5mqQylFoFVpBQLyizxeuFSskWeFa
	 unbfwWF+CMHyHZhuzLn07kjn/Kc14bQKGonAKQhRQlNZO0+zt0sCYryD0vA8D1KDF4
	 ZyhOtsb169teI+Iz9hwTMqpp/q+/RP7snvnPdV7b20VLoVUV7Y1IkQOwPEk29Ck9WZ
	 RghNDZcyHkWWTdEbhavRfM2fd/DTjZIxOxrizTIZD7iF60xEwLYOw7cJ7iRZyJti/l
	 Gt06s5FGglq3UBqraRava0PtZhQFOVQF2Z/Qqg3MA19wwLVy4DPWekWmLw9kxcn8Jq
	 lcXVUxWmCYYuA==
Date: Thu, 21 May 2026 10:48:04 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: mawupeng <mawupeng1@huawei.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	mike.kravetz@oracle.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
Message-ID: <ag7GxM02D92LUrLd@localhost.localdomain>
References: <20260520020128.3506168-1-mawupeng1@huawei.com>
 <ag1tNtzmjNlrj4Xm@localhost.localdomain>
 <4ffe8dd7-86b6-42aa-a979-a9ae941e068e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ffe8dd7-86b6-42aa-a979-a9ae941e068e@huawei.com>
X-Rspamd-Queue-Id: EAA9540008
X-Stat-Signature: 9ok8i1odefyc5quam3zrmwrapfg35mkm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779353292-504692
X-HE-Meta: U2FsdGVkX19M6WMnjaorVWIY9QRB0Y29c5J4UAAsR/MjIIh2au4ix3FiUj0Zg19zZTkQijBFyogtj0/h1XQWQYt5URpZYUg6JjivFDxTAUvnzYk5OBjndL+rhs5SOIHNfpa0FNSQs8vD7+ps8KTw/qI8JnJcD/v5Wtk89CItRgw6PPLl0X+QJ9QKpvPH8IwqOeA/6i8ex8kBakofFVk/4/lo60/vXX+ak4J6eGWCr+d3W3YbjfVWexkl9Qs5HvUEJJ/g27Qrs4k0+N3uaIzi7N53+d8d6njI4smeEbkW3EjqMOG5RKkEl3Xn7i27taDw0TanpGG5EwDkTsW4aGlzgZxy1ldp2ff526mbLYA6mw/TMqXEtxUVAXB9sE70BvK3RcCyXOIx7+VcFzSGmXPE7/J33kA6DeeWtUuIEFmNVbjcUAIZa5gy8GH05EZrpAwrGxtrZiBMqiap8l80/cfGbXOA6wbSAsVs7lOcLTxjwG25/CfKThDtaI1ovuw8BhIOw4jRkKrxf2ZVqgL8IT9bcJfIdSxtL75vPs5iYq/j4QQYQ3r3QFJitQHxsWpFCqN40EPCJ8hn4q7wdb0v9rCMZGxmowsT9LqGEDlxH4wnOz94TnQ7xwpuHGTur66wltbcpeVwEUx2TLS5vBNSLvM8pKjVb3UJzfliV1ZhFAdtQFXW9RyZRkgLY/MTCo/vssVvEUBKtEPPs4k2V39sizrbyTI/mqObmJpP166Vk7bR21C2ROwnvRapdSELbs8PHW5F1LiEIRslWNwhGtbNXqihHnqSyoeoMJLrNcf1Q72Z1ade7lF0q3GSlrgqznTLtbI3jg/lzv4n8qTllDbQ8xyhb/uliX1fG9EmA4SSALPofAtDp1U8XfWcv8wSvUdKCXvrHDwIbQLQy1YTt2FPsXeRl9SBx6WatFf+8ZFC60yLbRllPJxZkBkg5Zoa/GY3rAGoZELChMA+cwxDf+jxrq7
 oClAQrZn
 HsqZg/pEB3afApH2TvU6DAFegnZKn+zC9OKgv5gKLefNKIqyTa6x5kUwZ4LbV5mL7Yj/hUOACVYI/JDqYEZ38R7uZce9eOrCsU/Ow+AuRyHd4EIQsyT2FJKQF/RJTgDFFeb2jLL1B7783Cf8z+Z1c9/67/Bq4rrF01c1Q2cCMEPBTHzbxmKCSBhEOu3WgKrXHM62fypXvHUS41ibODtyCjSmqcH4kW0MHsova/nWQH+q/77pKT91lChc23Gewehn3g+ol66eATzBA/sI3fO1PRLhVUOMgKv12rc2LZX7fl8sqnBWPoIbKSuRh4VjDhXNC8+2p+qiaTGozsZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 07:24:28PM +0800, mawupeng wrote:
 
> You are correct. The refcount dropping logic in the `unmap` path was indeed flawed. 
> This issue was originally uncovered by fuzzing. Based on the initial stack trace, 
> we diagnosed it as a recursive locking (AA) deadlock on `hugetlb_lock`.
> 
> We initially suspected that `unmap` had prematurely released the folio reference 
> count, triggering the free path. However, after a thorough analysis of the refcount 
> state machine and the actual execution context, we confirmed that this hypothesis 
> is impossible. The root cause lies elsewhere in the locking hierarchy, and we are 
> currently tracing the exact call path that leads to the nested `hugetlb_lock` 
> acquisition.
> 
> The deadlock can be triggered by injecting hardware poison errors on a hugetlb
> page while concurrent unmapping activity occurs. The following minimal userspace
> test case demonstrates the race condition by spawning multiple processes to
> widen the timing window for the lock contention.


After staring at it, it is obvious the code is wrong.
We __should__ not be calling folio_put under the lock, as recursion will
happen if we are the last user holding a reference.
Thinking about it, I cannot think of a way we would need nesting here.

Anyway, this is a genuine bug, so thanks for that, but it all got very
confusing because of the traces pointing to wwrong places.
The thing is quite simple:

- We start with the assumption that a hugetlb folio is mapped to
  userspace and that madvise 

 thread#0                                     thread#1
  madvise(folio, MADV_HWPOISON) (we poisoned the page)
  madvise(folio, MADV_HWPOISON) (second call)
                                              unmap(folio)
   try_memory_failure_hugetlb
    get_huge_page_for_hwpoison (takes lock)
     __get_huge_page_for_hwpoison
       hugetlb_update_hwpoison
        - we get MF_HUGETLB_FOLIO_PRE_POISONED
	  we jump to out which does
	  folio_put
	   free_huge_page      (takes lock.. yaiks)


So yes, the fix is to have the folio_put happening not within the lock.

Please, send the patch with the right changelog (and no version) and I will ack it.



-- 
Oscar Salvador
SUSE Labs

