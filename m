Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1C9C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17D46B0096; Tue, 15 Sep 2026 22:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8616B0098; Tue, 15 Sep 2026 22:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B77B6B0099; Tue, 15 Sep 2026 22:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 687CD6B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:31:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA98A1A04F6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:31:19 +0000 (UTC)
X-FDA: 85218048678.14.AF40A08
Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC7ACC0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:31:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MyZjqqw+;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789525878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b52r1ibrwDHTJRn4CQG09BagkpWVtc0wFTymVPpcoiQ=;
	b=2Hhu4qJ+8/fnZuTwSRpP7/yRusX3XBxxQYD6grzLt6t1bOlcZdhX3G/m+a+E0QFoHa9QBS
	WTTl3Ro2raKS5+mxh8luSeWXQ9PJhPnKN4+9IKBO44VDRiX121QWU4hcELlTP60NeVN69D
	W3urMhKK5N6BL9yNXbOCAdckjG9SuGw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MyZjqqw+;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789525878;
	b=DqLVvJPud63OVqF+jcfbu9G/G/uZeECITFtCjLqoxw4r3vjU6neT47JFEJDxVh3fFnvI1E
	eo854R3KvIGa1/mc4nAp9UkVf6x8KWPNsYhYFe7oDWXRqvDXcbQXjl5rjkDZutVIOfFgz4
	PKgSvuhAA7ij6009iVtqeyD+msZuVqQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aDUjRGX3cNyAfEzDUTqJDrpKeLfR1gBoMctSlKhWMck=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789525876; v=1; x=1790130676;
 b=MyZjqqw+t6Gu10wdaEf6J6Msmlccn2DAudItCnZwg+7lFGWQmTCQ08uSyOJeFjsf1K9aUc9P
 yZzs2IvCaWC80nzAk+/kbiSgVMKrvem///GpaFispRdQTGWbWgKei68DI+rPvxck9oUBHQoSrYO
 2+4v3tN5DiLBSPBMtyAgCddI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 1cf33dfc7e28f54a;
	Wed, 16 Sep 2026 02:31:16 +0000
X-Mizu-Trace-ID: 1cf33dfc7e28f54a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 03/11] mm: memcontrol: constify the lruvec helpers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-3-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:30:55 +0800
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
Message-Id: <3509BF39-2110-4705-B7D1-D333AF54BF0F@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-3-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Stat-Signature: 1qirtm1djphpitch4b1wttzse5ypka39
X-Rspamd-Queue-Id: DC7ACC0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789525877-418368
X-HE-Meta: U2FsdGVkX1/ZbfWiqlyqMqHrQDNKPrM9rL8BdjlQ0n4viKZl0L9RGZNouTbd+DBMypIubWaslQKrVjy69IpwSK6GjjUnTRh8SaCPDGQfmNkYOXHyRNLVhVFYjLV5AhlNSbc9yqNb4EAnIa5PR2uGZEPzqOcwiRyeVIxI/oLFgQv37QSBG1e9Mic9K+qUfdeiExpkx1IHhMxyjPN/pD2enuzgY9nV+3zcMoKYaKigxJzFfOyuMNxTJL2dB8yLjHO5wJWxTXygYL4B462fAsAGZ5JVyG5dm0wPXiJcS79Bj/+XyrnuMp8uUmk5McnTGapI/B6sf1LDnxIeDzQ6nW5mwzggP4MZ3syBhcalVKa6C6OMK1rzP98AeEL6bLBSgZmamjyv1/MVpt6asvpkF0Sm9wxOrQFCV+X3uAWHqi+g1x3z4eH0LRydMPhEMhS4Vs7P/tDE1gWVc+YzLiWWFtZim2ZFSF3DF0l33AQoNl0wTAVklvkTSVT918hm2Fcgp8joJOp5IivXZbwQv9c5oq8fv2fg9Q8sZfE2GVXkqtOnQbr5kKPNwOCFJyNA6TmpgS+it+zHa1EuPlyEp7xE40+1NAO1fKiz3e9Acg7G0SOrvrBZPJRpV//IeJMXtGIjqIzl1MUcrf2RfeKirkTNPGDap+k7todHVflzUyg71kV0lde64n+DM1Qoa5Z+yuWNKA1TWF+06A/pvJEmA4nvK6DHx67fP44Qok/tcimvmMbg02gdb74pb0L3FDuGo1VKv7UIk0xlxu5+XZzzvO8/oeAP/fXXi6lggjbtlS5o4tFfgaPgJ4UgSO8zSu19YRTNLhrsCTjM7YdEVgWEbpThttNUDrCOk1RdMGEVrPX15X12czgPgxNhtSjvFwZgXWEQNWUVcVK3PcPTjCtT2Fd6khtyyTi/1zxiwQ+WNv/s3MXwkFeHLXgdsULy/56Z1HKm+t/XKA/WsCI+DZTge/4CnFy
 yvMHQzz2
 nkU4uQsjuH8aYnWxlsodNDeOCQJ3a3KRnJl4RBAYPozlOEAoqdVjRkxw/PLi2CGKOKbBikFhbQFIwiuKjfzVilSRfq7ze4T383Av5GHA3ZxYY/Fh6AoJ8OLAm+vwobdiQM65kXnes9xNR1FWihvbNvefrnBpFUPF9mV+yTiZgeTxB9YqsZbs02t7FUB7P9yiXmsnly9rgD2tCbgpS36TQ9julUKJa8l1gsRNXkHeQZ9jy2+FOYBIRQ/u/FWb6flmfK7hdFxM2heoTkTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> The lruvec lookup helpers only read from the memcg, folio, or lruvec
> they are given. Constify them, along with lruvec_pgdat() and the folio
> argument of the folio_lruvec_relock_irq() helpers. mem_cgroup_lruvec()
> may update lruvec->pgdat for a newly onlined node, but that lives in
> the per-node structure, not the memcg. Similarly, lruvec_pgdat() still
> returns a non-const pgdat and does not use container_of_const().
> 
> Use container_of_const() in lruvec_memcg() and
> mem_cgroup_get_zone_lru_size(), so the const isn't silently cast away.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks

