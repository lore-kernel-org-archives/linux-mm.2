Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 903C1C44512
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ED426B0093; Sun, 19 Jul 2026 22:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577786B0095; Sun, 19 Jul 2026 22:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465C56B0096; Sun, 19 Jul 2026 22:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 173686B0093
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:35:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89AF5A0712
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:35:13 +0000 (UTC)
X-FDA: 85007588106.09.DF27833
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id C6B9D40004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:35:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TymK8j/3";
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784514912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bq4r4xhkrQH++cSZOcH5rqUYb4Fh/bIgoEGtfzQfnnY=;
	b=M3QdrC/R61PqNrjRx++eyHfymT9bNX+BMgUwM/2a9yOsaztkgPIZ92urEkSXe1GyVUTGZb
	O6MdLJ1OaKB+if9WYtpRladLTRE69Dve89uiCDiDccmqRVQ8sxMY0mhaO+kHz8Z5MiuGfT
	hpsHh7Qz2JiYeGWfIdQXY/YXLvjxY4w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TymK8j/3";
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784514912;
	b=IIilikPSBZgw/bWTKZcP13aBEcLSCUQG9rUvBJ/nglW9c9VE5O6hViUogbc4wltCE9xS+Z
	PVqzdiHMJOsO06bkQOFr64S+n6gyYkpnDup7UmgZDxsQhePiOw/hhc/vuqot9fxHGdO5zS
	9hZMXiA3w/jlfjyaZvJXBhCcAUJPiro=
Message-ID: <2f11e175-90c8-4b04-adcc-633c3e7edb54@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784514910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bq4r4xhkrQH++cSZOcH5rqUYb4Fh/bIgoEGtfzQfnnY=;
	b=TymK8j/3huISra4w/srHkkSLcA8RMDKw2QFkZpHvVL9yAUmlYTqakkoUNohNks5SUGatwU
	iokVS0rJzvzU6cBkcgBU90HYKgDBz3cwKswtIt6SFsU2VbA4Hsr5196/IYmId+CE90F5Z/
	A/+8J7+ehq7hB/dyerbSnSD7m2xeiI4=
Date: Mon, 20 Jul 2026 10:34:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/4] mm: vmscan: drop unused gfp_mask parameter from
 __node_reclaim()
To: Ridong Chen <ridong.chen@linux.dev>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev,
 dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
 <20260718095251.82937-4-ridong.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260718095251.82937-4-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C6B9D40004
X-Stat-Signature: oa5azz38b6wino7jbz6r8nyiasu931a1
X-HE-Tag: 1784514911-79937
X-HE-Meta: U2FsdGVkX18GWaKbyyFmXiGvv018iBW0p/HdPYBffM8bagGSXtdyMrFP5LPT2SuiuTNdOlETMqvQ0gUMwOU3jqU6i3jlhJcIWN9PFHMpub44lDS3O2E3+DPa2nXNanKUj5BpZCNpDEg5ejVS0af2br5AyEdQU3mHUxagzj+KstfFpkXNWjCc5VC/JgISOtQVEqdpMrReY9XTbP1cuHP1VedY+qv9Kg1fJZDDu09FvRKRg8gjOejken/rhdujSnswb2JFdQuEmMqtBwGKKXbtsJYj84EG4f6eU4IpdxsXvni68XZLfdIK0ghbuy0ntUAL0VCLeAxn0JnLJGk+RDOQfW+43YQVM6IUGuzUA37mQ70FzFzsrKxXVNMhah4NMySDHRiQkngNxKffnRQq/FVyUnzioIQeC+6nq6hzITawSUUaTEytXZ5L0pcwlUI8lo9pcvQg0ziKr5kGS4FTbwO5CL0lBC/Rm6ewvOPjw10lp1Kd3IoO4oZix9jijcXZ3lum4rpDDO++rSB1oEw9tpKwxS1wDU8/LDzEC9gksyohdTZ++1DDfD0tOyMF9+HlR+JHjV/X8+NMd12KlrsskFy7OWdgwrOWmEuHgOM2JnitGFQZfRXGE9lmymhzKcM2FnRR6OLRoGWxGS4c/Ne3Y1Y0aBKptFjJTVBIK+QV2+nmED5m9zCRqBS2j5+J+HLPrMuFasiDrcItOF5DUgKx4peSDCHffIER9nezlfspLm5MhqCd0dY3z+Hocu83OfGaKYJdBYjspxiGjxTuL4LNaDBI+398ko9UO7cktgYwNyO1cvn1ApD3hrbfh5HojRxYyvJ7SPDhsWbuLpIInVpkBQa2bkbJXEmRqw8y3Xt6uFF1/QPMHdsJdxcaQAW+Y35RkQinf+xhYC2KMOjSwcXV+UQOm3ftiRqFDHIVY5pV0QzQ3K74hjBkNwq0qsGH9nDeNlsAe9+/79MZQeO8b1bqQpR
 bqHXRO3i
 awvaX5b+MZt0JqjCip/kgC59sXSQhLdIq+6GrSPGbY39n20gyc5LCAZTU+NgUpCdUjA0KjZG8lyT17r7X9G/Wmkcaf38M7siAlRCXwSvvlFHd/AHbR/T4Z5CJZabNrFkjOMeJ5GIUhwT4xJ9T5so8as2YHZSJBkw9cu+yHgLp1oH2ykszldNoE21wYXMUClKdzn0qBuLoOjjmzco85EZNB09X9Zxvch7EFWJDwOcc4mX0YSeZByqHAHQOuQp4BhyrGmLvfiGfAM+xE4zWyCWD3eeOKGsrLOJn+DGQ9t7qdJDfj1Lq6ckcFFg8XnKeKKoD8Uwma5++FC6HrwSm7e0LhDSc/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/18/26 5:52 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Commit 57972c78e678 ("mm/vmscan: make __node_reclaim() more generic")
> moved the scan_control construction out to the callers and passed the
> struct in by pointer.  After that change every use of the gfp mask inside
> __node_reclaim() goes through sc->gfp_mask, leaving the gfp_mask parameter
> unused. Just remove the dead parameter and update the callers accordingly.
> No functional change.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   mm/vmscan.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


