Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB354C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE97E6B009D; Thu,  3 Sep 2026 13:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0DA6B009E; Thu,  3 Sep 2026 13:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7FA6B009F; Thu,  3 Sep 2026 13:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BED8B6B009D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:56:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5091F1604B7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:56:27 +0000 (UTC)
X-FDA: 85173205614.22.D7D2158
Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	by imf29.hostedemail.com (Postfix) with ESMTP id 630E1120009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:56:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GkqDu/f/";
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788458185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAnaMADIqI3vW5lOzOVsgzb76ar6D/YslIV4RMXRYBg=;
	b=RTtpxjesEJlqGaeJIxdn9HnPoS/Ts0/BOG1JU4OU7d3VG6r+Z5xro3uWwKKjKTqI6GGBjv
	RB3M/y7Sn69F4tqK+5K5nW8mZK34DNFjHFgIASe3K3vt0jgrt3N5ZjgS+KEYj2zEYsQ/Eh
	/xZEPjnTb0RRawUpmpB47rUUWHDLq8Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788458185;
	b=F2lXXfN3UNZy5VPpwwdd5tcJFt43FyOP4WJghbPhTqDNBj1No4VxsjSvZ0tUTHGQioulis
	tOG9sQtDvJludD9u0h0Q4dfrVYUfpa4ALK61KE/Tw5e9R1yEXyMurwoyi18GmTGoSIzWbu
	TfqA1W8W+KPkZ4d65Gvl+laN39y6BqU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GkqDu/f/";
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L3+7YRmfESLibVZakMPl0uWAeXL3XzaW/tLxNhJw+VI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788458183; v=1; x=1789062983;
 b=GkqDu/f/acM8xjZ2oIqmjySdRKIgfYfzIbyQbI1tITB467RZ9GR9SDBOkcOjuTsW2gHWGL7t
 oAMyv/EPMr6u+9upWNjo6UdE3cX/M7xkOjAQ0kUCdEIeTGEPNfkfi6TacgOPlOfmM/5DFUs1Zid
 4JLRgvZceBtK9ZzHFZR2Etag=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a4bed8d3f0db8ac7;
	Thu, 03 Sep 2026 17:56:23 +0000
X-Mizu-Trace-ID: a4bed8d3f0db8ac7
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:56:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2 2/3] mm: memcg: redirect stats updates of dying memcgs
 for all hierarchies
Message-ID: <apm0nHGog6c0o3iO@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
 <0214c0228695db474b86d3b4778b681a6c47a6e2.1788169145.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0214c0228695db474b86d3b4778b681a6c47a6e2.1788169145.git.zhuhui@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 630E1120009
X-Stat-Signature: ja9jrt9np7pf4i6c9hqmoj8ohwm7m4rq
X-HE-Tag: 1788458185-981314
X-HE-Meta: U2FsdGVkX1/X9Yr7EdihgEUDaAD+DGz2ZkEmW/sJx1axYn2a85Oq2W0792ufMV0Dj2ACYigSwSMmJmezEHQfxLF8/LA1nq35OsA2Mt0uqYsqRCYMud2F62jGJ90MBHuQN94k8eUrb+9cr2SyRtfwooHA/QAzptPff2s6CgVZoaZxO2i/V/RTyzCfXtvPrNZq83bugu7m2JrH7i3ctG+tWTkJN760a14H8MfS9/8grz1cFNUIuEQ8UQTSznukm6iq2RTpWE9O0sg+PM901wSiJpuDwCXigt8lW5yat4X4STDhM8CcTRdUDYyRt6Qygb2w1XD9OtEZHO72G0Kxe8Epo+KQC0eD2zq1f3yNskW1j/7nsTOfDS1/Fpy9os7T38YG6e17hYswvnxUAKfZooiXWRASkezodfuuJboW9rnVKBAv8ySLp7OMWPFW+pwPr9nzInVv6XyAg1b5jD32wJ7l6+qmtg6WUjDZHFMjudXcer8iFYt+Rir9Einra2Kx9OYYsU/W9oBUpYTwYT3UO+8wwkGu/RGp9AW1ejiJQMT09YOoqxhE54JjIrKVMWZnmj9XT34cYPKAMWljrpQ0Gs//q5Jxox2qfcgku67+nQRi5nRj5KLK3ap1ruz8OuRSfXe5xMrnc/wa377cgC92eiyZSvoktr66UpkUjGZT1zjGavodiAJ5hzMidN3ZDvITiZIF/yXMp+wqKTAQqdegYKJDJjcKrNQdllFEz3hR1yzme8KqLuEerCIqJCljj9La0NLbprV8+i36XkwnTMQuSZSDBL37sGog+dN0BZ6ZR6SmaQjkYTOaG5n2BFplQWRiRcoOM4ZizYpEKpJ9Lgzv6XZVsv+6Od++d4UOTiPkCTC2qOKgxIEOz+JWcHEORJJLXryG7H6vNVUIqfd/9AdQ9FlTRTaEmKG89D6MkLU+L+4f2wi9cpOWuC+D4ydyLvYbYLQ8u5UFD8BZqDIBCDq0mZU
 nU2o2BZl
 0qET9bXII3cSuJGCNbUHdxu4NwtfsdNsKiZlpM8h/xxTyUQ2RPS9bk/j9gaM0ows856PKoaOFuUJ/aj0oskxFBQyhMrYMfE82htDlqXSVG7bqb2DnWf4fcAnQb5K3mIco7tLc+tuAurhgBRWxje6RpE9eCK5FM6NOEOyamtsEvUhan1c10dha7OKGTksxaYmFgBLOTahxxVBIiMukKllsIUKcdchCTpI1Js6fLsgL09ulCm3E0KjLxoOf8+oi5yhx9fxI6PGUymbAXLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 05:46:10PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> get_non_dying_memcg_start() redirects the stat updates of a dying memcg to
> its closest non-dying ancestor, but only on cgroup v1; on cgroup v2 the
> stats keep being accounted to the dying memcg itself.
> 
> The previous patch restored lruvec_page_state_local() in
> count_shadow_nodes(), which reads those state_locals on cgroup v2 too, so
> apply the redirection to all hierarchies.  Offlining is rare, so the added
> cost on the stat update fast path is limited to an rcu_read_lock() and a
> css_is_dying() check; the upward walk happens only while a memcg is dying.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Please CC to stable and add a sentence on user visible impact of the bug in the
commit message. With that:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


