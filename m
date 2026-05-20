Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FF4CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C0B6B0005; Wed, 20 May 2026 02:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6743D6B0088; Wed, 20 May 2026 02:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0196B008A; Wed, 20 May 2026 02:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5576B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:14:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08ACD140186
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:14:52 +0000 (UTC)
X-FDA: 84786784824.09.79348FF
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 42E271C0006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:14:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="K/EWTj2f";
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779257690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7e+jehEEvjjqFDVMHvCX7/NWn18MESwVkGseJjxy/2s=;
	b=m5cIL+d3ZwDwEBLBQwlYIiyy3kfBJ/GZiWq48sEghdKJyIsyX2aD2cbi1DV3d2369l233k
	Sx9U4IfIXQLgJge7yjEVDt99BeVgVgLeSiPZSxwkIfx8brQ94j7PdZp3Mu4S3BaRpP85z9
	RszoHDu/NlrH9Lsff1Rj8mJobAWn4C4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779257690; a=rsa-sha256;
	cv=none;
	b=UkcMuc65WhEjnpRY2NfsO+winPPcuPl5mkPUV56mjLB9ZbGVU7okBCg4p0b+hdV3xWHZNH
	VjXuy1sexyhDl3sAX2HaYbKLHToLUl2MgckXN2ZL+Y9wioN1L5qLEquNTzo2TVgnqmgGA5
	Px5ce/oJZrRMW87YJq73sVyPpnPp9Lc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="K/EWTj2f";
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779257686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7e+jehEEvjjqFDVMHvCX7/NWn18MESwVkGseJjxy/2s=;
	b=K/EWTj2fUFvDDc8uLbsWf19nUn0V3CeKUvpUzCv5fiWeXo6vBhWkzzsuho85530U9etXtb
	kUYnQrdnKjZI83DTJOQZ2NQRwt8Mf6z1Yyy21G0ZwJXyzBqJDyGOEGjl3QG4Z5aiK4N0OM
	9ojDL6eQmmFZHbsDoFHbm1ShZkIQ3zk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 1/4] memcg: store node_id instead of pglist_data pointer
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260520053123.2709959-2-shakeel.butt@linux.dev>
Date: Wed, 20 May 2026 14:13:47 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <0B4974B5-FB9B-47CD-956A-B13BCF278163@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-2-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 42E271C0006
X-Rspam-User: 
X-Stat-Signature: czx6rf8rx3okg36wjxxe9fdbns78wyg9
X-HE-Tag: 1779257690-499829
X-HE-Meta: U2FsdGVkX18ADc0RphpCehPRHByaES2rPJawlyfW/RPGtZW8DqwJlb0MUWb6AmpREIsQ9byB9fL1mK1xsQFGgg/yxz15w050AFX4L2kUhQwOeDLjV84RYVbnwHKtDEY7YKrcjK7pkOqkkLemLmrphx7LGCHrKxGjBPtW8ejaA70UCxIsGXzrlmqFbkyBQpQG+q2aXW5IoIJR/ukagpzcuTXu4D/cAAft4x5qt0Y9CWv28jwGTckgebb8/i72r42uBQoBLVzhgvwguYKbeXYGAlAh7lt1SYSUpgqaURzTj0lphQN26Zy3ZZMjyF42XyoLO9Tjx/SH5H16dZfX6ZCcRlFf8dU4etoGAR9hBKDatCfSbjmh02Y30Bp9PpVu4S9n2Xx2wJTZPoapVckalL0NfAeyksD0ykeVHwKrxnRMKLo8B6TBhgZcsSnGyXH0QOEWkYgazfW/s5HTWJHb8s1GT7YqS1q/Jk/QLDyvymQWNaLabLpzly5LH22m6UE82dphMYJpTo+GBTlRfUGnoBbeASCH87Japy04Fxmt/bQ7U1YWgcmdS4bVvDToFGhn6VMNZfU1MGSrCJjkriEWqFkCHHzkIp0QldjmIl8e3huyhlBnR0oSJiXG7+XMf2Cd0MjZrN1u+SK57d+sIiemg/TVG37yq1l1PUxa9zU0fH1JqSIUNgumS4fr5lwUvr1VHY6kyx3RPekNZgb0ibSR3057M59wQ7VsbmHVz0gskVxtDPJkpaQszwQBGM1L+tU0xbKsoJl63RLgT9gkAYasnNhEXAFGj3aJQcLQkhNRsi4+u8Do6jsqGfo43hrSOAtiWD9zFv3T9iug6WsPi7X7VZwsyeNkQtq+1ePuL1BnwNVwFy8d/NHoi01OvncZqorIXuybkKN7xqHA4XhA7Pto2/Z19fKLtV7ifFXD5+hTYgzv441ZST15QIwT7MIG6cTd+V2RBqlUsZUmnI5nbDC01kK
 DdjSDPOX
 QUj9PCC2/dsvJEYcob9WQnWI5eR+oWSIbtseGIw3SSf1pa9fV+SaPNywBOa9tzRg95O+o14AvCnfJnYwiwzX8r3Z8cQ1hifkk9JU26WABNd/BEtROaSj6DEhHjUN0DFUIuTTw4Chm7jHOjVkACZGyi6NWdfz/0mbvBEBOVgH/YyJjvJldu2V3TcPpCT3BPhYU/X0nP6yjN9zXuinhqm2NafHilDsRPmS4LQVM1ypVTPa36QXaKxle4/XHvF8a9zIg1in2LOoN1xxNShPZI+n13nsBW7FuqZugvo0U2va85wArWeVAQdSKu7kIT5EoEQBcLzapN7tpmCeDqiRABCgdHu7oIHu4704a0CU5nPgKvVYEpV81z++Nm3nNl5YhC8QHnaXKRfw+6/GYq51Yjm8w7BbmtZ9NqsKIIog7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 20, 2026, at 13:31, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> The struct obj_stock_pcp stores a pointer to pglist_data for the slab
> stats cached on the cpu. On 64-bit machines, this costs 8 bytes. The
> pointer is not strictly required: NODE_DATA() can recover it from the
> node id. Replace cached_pgdat with int16_t node_id and use NUMA_NO_NODE
> as the "no stats cached" sentinel.
> 
> At the moment all the archs limit MAX_NUMNODES to 1024 so int16_t is
> plenty; a BUILD_BUG_ON() makes sure we notice if that ever changes.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: kernel test robot <oliver.sang@intel.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


