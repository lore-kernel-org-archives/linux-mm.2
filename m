Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD84606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oal93E9h
Received: by kanga.kvack.org (Postfix)
	id 7CF536B05B0; Mon, 23 Nov 2026 07:22:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7797A6B05B1; Mon, 23 Nov 2026 07:22:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A9F6B05B2; Mon, 23 Nov 2026 07:22:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45ADA6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:22:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30474408B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:22:57 +0000 (UTC)
X-FDA: 85466297994.06.52FD1F9
Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	by imf05.hostedemail.com (Postfix) with ESMTP id 28476100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:22:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oal93E9h;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795436575;
	b=A2/FLAdRNq8b4gA7N6lKNWYMpeFVEsFi/zqGcUPBG72PV3Uzy9aqrYm+FUfgjbOL0i10WG
	wBpTw1CdgJlUL0HMNmTxlhhBitf4AvR4MkuvtFabTk6X3lkuX9ortY1wLyo0lZrNtR8A02
	rEU+jtDJptAlWwh7Ys+gklfLfU++AOc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795436575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUmWSh6uTeixFFkyYnWFbJ+QiEm7Y6IWZTbXXFJX8T4=;
	b=oJacAiGNtIQr7B6QKPCUXuqA+cykMgOPCNIEBu2spWVjxtoSxJty1E9kHyPBlcN8X4tfso
	pfNB4W3a7Ge/Ca4i02GSSfmF2rJPDLuBElUQZAc7qT+ShToKOoRWfP5U7H2AMSEBEQ6Hjg
	rmW9KIzjlaXuVfGVs9EqUYJDcskETVo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oal93E9h;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HBiS2kYF8PVr+vkQZ7k/tuC2TvlwZKRHilWszpQnZcg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795436573; v=1; x=1796041373;
 b=oal93E9hrbrvToGf8btCaPuf8tsAauiJkAeAIN4xbW6hAPzHSIlO7tyEFJJJINeBwKyjUuzR
 Pj7j4x0zUY5oCYaN74tJN48MqYohM1lea8nWqb4tcWkksmqQMQ7uP3rGWN30XWtk4BrxD23iMvo
 Re/LM53lMMy229SlyvQKYDcw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7dd95ba535c2c3e9;
	Mon, 23 Nov 2026 12:22:53 +0000
X-Mizu-Trace-ID: 7dd95ba535c2c3e9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 1/4] mm: list_lru: index per-memcg lists by memory CSS
 ID
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261123105334.2524066-2-qinyuntan@linux.alibaba.com>
Date: Mon, 23 Nov 2026 20:22:36 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 akpm@linux-foundation.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 mhocko@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 mkoutny@suse.com,
 David Hildenbrand <david@kernel.org>,
 ziy@nvidia.com,
 baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev,
 david@fromorbit.com,
 Qi Zheng <qi.zheng@linux.dev>,
 yosry@kernel.org,
 nphamcs@gmail.com,
 chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com,
 Kairui Song <ryncsn@gmail.com>,
 gourry@gourry.net,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4520D630-10BD-4D66-9FDF-279A07F5A4C0@linux.dev>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
 <20261123105334.2524066-2-qinyuntan@linux.alibaba.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 28476100007
X-Rspam-User:
X-Stat-Signature: tgd6f88q7ac5uhoh7cp5phyif1qmbp51
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795436574-617261
X-HE-Meta: U2FsdGVkX1/m4tWtMOdBr72kSHnKKmZp49tNNVU86NC+t+HtX0FGrUWd4Fayv1lk88WdhrONbEzlhMn9KT27J0yLRQZLlC4Q36OTAiVYjSA4UYYoC4cXjCYXENZy/pQiIsZQggB58LgN3MiN5DQKbSHe5w2nGZGbYImyrZQtVHAP+ZJ9oJeCnc2DYj56cNXKPGeSFHc8iear8xcD/2cvPRzEpAyQ9utkfHToirzogVGKTzK12DF6agsXW4+WNNO1ibxPPObcPUZIrr4RWXA1X/XBHB0U0r/r9q8gZSU3cwrRByDFwpsL2brDbCm78d6acmHMaK1kc/1UDr2ImG7HS5NpoSBOi8lm24ao0jR3dLQppz639XJSO5pz+dY7wcMyjasnlC/zkb8DKMaQjt8qpkmunDcXCOkixcGz2tyH4WeUgwdL58XGBiTrXAsYsCDAW1SacPO2V0srdXwR7w//PeZEvWh+RGfnn6KPFXYmm5SjexsxNZxL4DMl1NauvSkotdnhnS9iOhq3o1f8vxNxrVtVMM9OsX+Azb2VA9YNLOIIhBS64Z8fqcnaHxzt2IQKv8xTDvbyKRo6XOJizI0YBfiDyyZrFdMrTV4ohJKOeqFcumjhUEP4TVY7mfykth/aA9Mh+9J1X0f5TnYKvw4iBxocYTHs+XtgdcsVVy02IRynVALGSjV7sPxnno6+r8j3IuH6upHAi4gtWlWajIImAdfa4mhOU6J3uRqii7T0e8eM+V1glYCIPUX+nssTcUtwcCYkGAxxO0rKSpiaU//ccgkY7eEQbNbrs638E19d7eeYxk2hcaFLse/MXBSWFPyQhKYLJFS8Ug6e6+He9F+RWAByrYZfvNmCcIFVs1kZ9WAUGjsGI75iu1Nw6TehdRLiVD+lgjZZw4EXExD9Raulbzq60vl6nweHuqRcPBYS+ol4wdg80Pozx5xPe3oz8qg/FzoVVcHoTy80qLOAho8
 VqmUsoYJ
 zkLF0X5vHH0XtsYwMUzjKm7MGjs+2jRxclKXqr8eKMhQC4NcbgLwGgAr5asIYgVpqdA26sL9wjI7J9nkJY3k+zFh5txgaoBI1McVCFJ/vnKrq4HvzvTvrL8FmWABza08nSL8eHvSvUHrhtXtcSd7Z5yaAsj2wcOJuYmgcgCpsIg99tFyX8ybkwpBf0yl+Haaw5vADj0wIEIRASaMvzS6riIpbCuJd1aUzsltfHzuz0g4XWiYTk5fGSn+x92vxDdAQ/faFXB/Xvzsc8zC8mb9fY1D7SNaKucOceJNmmxDsFRtT0pVq5JwI/G2fGUDc6QZOiYpzGhwnZDNTfthxXOgS1KddR+iJC32PXKN2kBu/rBpawCqm1LwyOH9FaSnJmc/xNlB5wvn6J7b/g4CMz/MZGj+vXetMnmQESuvJRuwIoI3TJKTBSmbMmQ5afIYF+UqkRGGMjq++5VJonShLVuOgmWARDdvzya8HiEsV9L7i3NRoPuQ+JCnORZ+dVesVtU7+U1WhYt/8kh5LYgVBiFaKFvxew/Uit/giEQtlBrDaVrE4CVFLIEG/isjblY2ME9Y507Dr2h3azP6fmhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 18:53, Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
> list_lru uses kmemcg_id, a copy of the private memcg ID, to index its
> per-memcg lists. kmemcg_id is only set when kmem accounting is enabled.
> Non-slab shrinkers need an index that also works with cgroup.memory=nokmem.
> 
> Use memcg->css.id for non-root lists. The ID stays allocated until the
> CSS is freed, so disabling and re-enabling the memory controller on the
> same cgroup gives the new CSS a distinct index while the old CSS is
> still referenced. Reserve index zero for the root, which uses the
> per-node list directly.
> 
> In list_lru_walk_node(), hold the RCU read lock across both lookups so
> the CSS ID cannot be reused between them. css_from_id() can see a CSS
> before its online callback succeeds, so check that the CSS is online
> before taking a reference. Drop the RCU read lock for the walk and
> keep the reference across restarts to recheck the same owner.
> 
> Remove kmemcg_id and reparent the lists before the objcgs on memcg
> offline, including when kmem accounting is disabled.
> 
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

Nice cleanup.

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


