Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DB8C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 927016B0088; Mon, 14 Sep 2026 03:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D99F6B008C; Mon, 14 Sep 2026 03:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECA96B0092; Mon, 14 Sep 2026 03:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2D06B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:09:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99547121192
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:09:39 +0000 (UTC)
X-FDA: 85211492478.18.46C878D
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf28.hostedemail.com (Postfix) with ESMTP id ABB53C0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:09:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=M3Gv9R1q;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789369778;
	b=j3C9toz3N7DPRJrNFZhUOxqOoomJ8Mtn9Uj/zHQBiVlXX8dMuFRX2bfoYPR3k7YwCDkSsV
	pYxxj6P9EFXPNeWhucPTGT280H97mzxDFf9sEv5pDgS+UOO5MK6kghR3adUYH1Fu9G6EZ4
	RYjAZQGS1FTMwc/o7pxf4pV5P9/S8wA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=M3Gv9R1q;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789369778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dY/tbtHXJyrWy4yy4iw+QpX+GNXsYElEvogCXMRcIqg=;
	b=qZCBU5iyf7J3KILDoDlMtbanHKug3b6So9XBddIrvdFvxTWGlbAGElxG2tqxiKxh0zJatC
	DrRgijbaN1aLtrB15NRpTr59tOyAHTJzWfqqK3AlT/D5xzH+gfAN4abcdI5QMuJ9IDshHi
	1xN9cjpK9Jy5kwPiH9E1QfRUQRBZ2QU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789369772; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dY/tbtHXJyrWy4yy4iw+QpX+GNXsYElEvogCXMRcIqg=;
	b=M3Gv9R1q9HThYMM90V0YMMBL4OO2m4lZ5UO9dkdj4/DlqoNoOpxD4unL3KWTQPooQa6qZel+LR85x7iRrpa4Apr2IsGDIlOwuT599UknwfTAY88IzazrDyhPZTI1j6q9KSsnnY6+BZOWY+Huj++C5UYQpHVWSHDtviEaDQE2WMQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAsx57d_1789369768;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAsx57d_1789369768 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 15:09:30 +0800
Message-ID: <093148f4-ed10-4e41-939d-be82e2844fc5@linux.alibaba.com>
Date: Mon, 14 Sep 2026 15:09:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/mglru: factor out lru_gen_seq_nr_pages()
To: Ridong Chen <ridong.chen@linux.dev>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-2-ridong.chen@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260911102939.2485750-2-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ABB53C0007
X-Stat-Signature: suy7om8arofqotoarbboppychoag98h5
X-HE-Tag: 1789369775-116130
X-HE-Meta: U2FsdGVkX18NRAt5YUHspvIDvstOyzdsM3RXEQXjxd/snoq1yXWJ2zT9xJs84oMqlKtLwg4+damHnqjDGCDiPb0X7CGXCkqGSD+W3OwwQDr1CS7w0RVSf0OKzLlZGJta11KrFaZvq0uj/VUlTyTKeMde9vQTFXvgZ+CtARJELl21pKEVa9U82wX7VpwJMiRtViHHt3C9Cm0GyDE+Oa4ZhBL7U4HvhC24JDNj/DmnxVK++HBasuRg+mbXyM7nJdbVqx4VRvxTkd6eLPotRkxnG0ajHRP3V7nWJM9xQffjITg1Ev9G9tNvodNIJtyVGNkaeF8qqaM5KdMVLndDzVgiPhnmqYHmYs8ZIk1gl8G8Jk6HpYvbdx70JoVovP75T4VXqCjnMzKoefJl7R3oaU4j3BdvqIxnUad2Ah5Jm46ELCjnr/cjb7dENvq+YNyUXQF63ZyfB7BUx0Zd7oEi7voF8jYvohgeOXCMi+POCJWb2J4+OLmQJxf66cUDZ3E51c1rYBbpRXjG3m6St1J6PdmjrW3NnAhNH6Kmi5iKEHPrugoTxizYejnXRnwY/Mkib6nGyjr6ZfNa6Rt3eakrd9JhOVy7PIPPPSeLSLxgvrHgq2F/EZ/Ixwof1KP9HOXbMKVuwWOTk1POZN85kYwuSLz6+mrdg6SCP8LBA/Yb21heRiXzj6dHNaK/5yKVNZxAGcb2lNolYoHc2XQrAY2VI24oAWPo9pRV+vBUNn6l5RJWQZeuESsoSqHVCnWoitaVA4IezIjOH461DCEY209J6p2imrmnlrTYfQpnmACi1sSi/t0JT0VuWNa5USR2+bCxVWSJn5DATyIHXdUrffmr/HCcgXE0Poep5EoDGiUpwdraeJethqQq9ZMqwTmzUDH06J4Z7KTLbyn99dP69oUExl0q0/d0lqFYFgsolJw/PIGimJS22t+YWDocQWetW7DMyvttr08wPXDnbkHx4f932Nz
 9qJJNqi0
 kG81XOUT/nsmOYKX+FfM2hYyWKQXdK6pdIZjfbFM+5jYEgODn4yi5OuxNZ/0SFtnmZhBt1nkI9mfYh+qbBC5d0vMjjPlLztPENo8zwxxN74orQyQ6piYEfoMS7BVa/fycuanXP3cSWf4bBpdXi+xrRoO/COk2QPLc9IURyPzuI59CSJjISZIVwoPuiHDk18MNGDzRFyGoSmw0if4sMVMLAbZ45sc756SHaDb4bzNt2TVpwc3WsHt0d3/9cH5Ojjr6CYzjMn+KEkA/4wZymKeXDISVjJSRCSCdMMzraF3vrPI8+kp5xvzzhDqOkmrnpCUKcLPRps6D54kL0itxAu2AEgPh6T83ZNmfndE98CWwTowxHgwABljMYoQZUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/26 6:29 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Both lruvec_evictable_size() and the debugfs lru_gen_seq_show() compute
> the number of pages in a generation the same way: sum lrugen->nr_pages
> over all zones for a given (gen, type) and clamp each term to >= 0.
> 
> Factor that out into lru_gen_seq_nr_pages() so the open-coded zone loop
> lives in one place. No functional change.
> 
> A follow-up patch adds a tracepoint that needs the same per-generation
> page count, and will reuse this helper instead of open-coding it again.
> 
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

