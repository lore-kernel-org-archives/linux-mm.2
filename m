Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F1AC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60766B0095; Tue, 15 Sep 2026 22:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12D76B0096; Tue, 15 Sep 2026 22:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950806B0098; Tue, 15 Sep 2026 22:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78E1C6B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:28:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DAF0DA05C2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:28:55 +0000 (UTC)
X-FDA: 85218042630.11.AE44414
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf03.hostedemail.com (Postfix) with ESMTP id C4B9920002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:28:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bguxoym4;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789525734;
	b=V7oKFrTTXYyGndiQKCpa4ZU+HIj7NF5j7i5gdJm5KlBxMiDNKv25l7WFM2R/B/4g4T6n3X
	bgmh4kiBmoUjddCzrizTvr6VLxVKGMKQVsCku1/gn92wrCh5wzU+Qo4rwY+/UJ8jbE6OpO
	paInPBeoRrXA1RLS6xVI5ZKlxxoni/E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bguxoym4;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789525734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qHIoUIvbOmtiJ4vJQ6gCU9MsrMYH8mxyIJDAnzJP+0=;
	b=Yc9j+/bOOgdYSo+LCXj+VHbgTONUpzGUxBrWSlcJ3espN2CuMCLdJATn6v5CsWPEVRVu09
	lxTk9o1aneVLfTNZRHXLagtf8IjsoDYZGNbrlPz4qbMRf3or/OsbU0DRk1hHo1QP1pJ6no
	nrNiIw4PxuDQLgJuEtonun9t3aVr8fc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tTKmz98Lo5PgYCpRdlP0wUncPsKYuinX9OL0Z34CMXs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789525732; v=1; x=1790130532;
 b=bguxoym48gTuKTsek+zfr7nVSvfkOfFpTCP0Li4h0ISSG7k/NNlmEIy4QO9OPFIeNWOhVIft
 B7WqHMvU75M+4mhfGJMq7PsrXsVliQxbPDAMLhU1m/27/ELXpb3rzj68O5aSh9uLzRICr2CHHkO
 tvOibVlRC5RmPtC1KUN+TyC0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 519e8ea2ff9347be;
	Wed, 16 Sep 2026 02:28:52 +0000
X-Mizu-Trace-ID: 519e8ea2ff9347be
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 02/11] mm: memcontrol: constify obj_cgroup_memcg() and
 friends
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-2-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:28:30 +0800
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
Message-Id: <1FC4ABF6-E713-4034-9431-9B97C584B90F@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-2-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C4B9920002
X-Rspam-User: 
X-Stat-Signature: t651hhpssqqfu55q5x7xu8bdgt68jdfr
X-HE-Tag: 1789525733-256247
X-HE-Meta: U2FsdGVkX19iMGuP9O8yywJRbOBYLBKOfcyIvKGEhSwjFNpKauZ0JA6OBQk9MOEpGCJrNoHZBbl8Br5uPqrRFvo24V6g2Zw6B01+zLoZ/ZtviJVM9U5vHoURcSb6708ElguUP34MeVcdjJMLb7xbyOo/tk6GPetUAB5Og21k+ofgblgtU0sI1GwLg3vYCU+6tQK+uh3niBwaFRS1cT86i8zHF/sBvZT0qCHdKjtdi9CU3TmKsSZMmCjUEILzfj08/dBf4nFdH/dYTwfCWqXADTA3azbXIkG+ngUBzYuDN6zZYWiJUhEkyWUYmgaq6fyKLUV/htglS1t625anrIyK6gWO42/YDUQDcOP8SGQpkaXQ/6Dv8Xsjg9Y6EoJeec/23OSQSjkQxzT/HKpqOE7hPc5GWi8tsf005EnBwE6dJyXC/iuYdhqXkUXaICM1CBqb5UDWMnLnjFg8GJ0maLYKzoNaA8rTzzG6MHK3rhdiyUHCgeYTi6l5D+7FDcoQsjtawQEV/uifmwrx8+Kapn78UXM/Usa7zzpybWI1hCQTpDmyZ8gGap5LW9IoOPbAQPK4UGcG4C1mKzg7BPk3TAsa6eblQTK6l7/hivG11J2RPpYNW64LwQB3gNVXTATksEU0JWu+OSnzJZpquctbfzbEjgQyfxOvAFm0ZmChspqpN5iq1WZ+nAW+aLGt0/U5+f+K2rw3mEWuzNIcI0Uirz9fVU4i1mv1feriDmHjA4ILMVTqyGzIGyHkchBz3UUhjkZJYCftjtDw1kRd1oPc5k05s8KjFGj0BMBOcBDMqk4PbZrdvHwB/Vnmc3l2znTiOEBEbowcimGDuWvwlhhdj479qIdQJ7eET9CwDNW34plo5op7sOgFe1Y4nLevenx6UwdxEtdqZPm/+nkDAnlYAyy2cA3bE1AQlHIJBP9aa+O/iByqN89iWY/0RJXpI1GhB5ez3p8eY3V61maRqZ+4KZh
 WSVuWiMm
 GoVK4Ky+3IggsEYiB72opUp0A8g1PMHOI7LI+TEIje01iHaHqLFGamEupbQOLPchCG4zxM2/jd/B06zXYI+w2jGwLyR82AlkmpidPbz/J1nCxHBhjpZdPjMG/hisxAiJLey3H3xYzQgj1pz6/Z+PUlZA3hRQ1OYWVnsAz4CasJb+xSBF99taTmqZYS34hqr2KpR4NYyoNUT56iV7HoA8qi9WJzl2uh4POqt1fjY5wUeUs+6Ck7pKINnD1Y3pYnzXDiyMY0q300aWMxQVQav4Omz0OQQOBZOla+guw598uGqfEbTRSdkGBCVnZyXpmIi2phbaLJlS23X0BK+rP6DhRi+yw7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> obj_cgroup_memcg() and get_mem_cgroup_from_objcg() only read from the
> objcg. Constify them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


