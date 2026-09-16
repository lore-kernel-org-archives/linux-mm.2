Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B22C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D156B0095; Tue, 15 Sep 2026 22:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D726B009E; Tue, 15 Sep 2026 22:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4084F6B009F; Tue, 15 Sep 2026 22:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 199AE6B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:35:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5692405B2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:35:49 +0000 (UTC)
X-FDA: 85218060018.01.5F69487
Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7E11A0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:35:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KTPyn9x4;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789526148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLgJcow7mE+vem7svEgH0820PCuOjwowdcejmkMOrJ4=;
	b=A1NgYormfgzz9Db6epKRvRQ8jVLpK/nZAzWRDfqph0PQJwnDhnWlQWoMUWL2M5lpdMkSpg
	hFr/dypk788C3R2solZKYtmhpMQyUgoZK9wE16CkcN89UblSWcLUdiZKlWmtDwtQS2wbaU
	O81aL8Y58KuRifV4GDrNpAJkLz01dtA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KTPyn9x4;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789526148;
	b=bJnmAowWCYpI8d4+cOsGjovsAPw12qYDwTNI796JLYMHvfyoPIt7jktLoOJCafC1CXcLzA
	UdyUUon+S1kjc8EKOlZ8wVj5imQhYb+T5Zq+E2+5DeS16BcwKvgOibc4oLuxUrSlaZhWRx
	lO0jR98Aj1W5Yt6dDA4AYKv+DeFo6SE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TvWzW1LVwKvEvLrmGXalaJM+zsGwELVQfJ+2EaBSRlg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526146; v=1; x=1790130946;
 b=KTPyn9x4PqhGz0UGzuaeiGFeeaWT0YM3OsRPCLSrXrIjZwAWcV/3kbgZn8g0xvAoR9EgJLmt
 EVD89zcG8Pu2iL1ftSs1ceoq+5UaG/pyiuKwiknns3FRqnhu3t9ST3vCBMhcscG+e8r5pKkDKFu
 aqCzQ0AZKmF6Rch4ktgAJqrs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id e4a3c3e71545321b;
	Wed, 16 Sep 2026 02:35:46 +0000
X-Mizu-Trace-ID: e4a3c3e71545321b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 08/11] mm: memcontrol: constify the memcg and lruvec
 stat readers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-8-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:35:24 +0800
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
Message-Id: <41FB90C4-30C2-44BB-9719-43CB9F70CF05@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-8-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Stat-Signature: zn9a955w8f7nugfjj36h8kybhsb6pw9g
X-Rspamd-Queue-Id: E7E11A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789526147-799448
X-HE-Meta: U2FsdGVkX1/XXzfS0LU2xMNTWIfieMbj152Jnc0y0Ghl+UiB1sd6JMaKIcU3NoQ8gYNlt2r/0HEPPB41Gm8Mu11dYFuu1Qb2WFHlemX4Q3Fot9JO/3MRwJxqcBoNL5UOVFWCp3bOiNhEGor0r4xZODME0ZxLqimK9Fcu5AmHyESi0sD7RlVEkCprtMTn2k6LcY/QuZsZHoGO9wUlX1zmvJVe9m38hjQZeohCABsK4X+VULs6atrpabi/Vtf1AkAFvSKAVSMumPTnh/p5xwS2+I06JseNC/D8h2hlneDrhv9LmPgXC4OwThELihmYOrltrtXDYtugo3UuNNAckL3cT+4bM3RM0W4cr7nlOV8QUh4hLT5wy0x4kqnsD6WQ8buCSCWXxDZHwTF9QKbKONEmZLg1u8/2H49NvaBnlgmZyIujpQ8sMtq+zZ8z4BnmaeGq2Gb8b3PrnwdoJQDnD2+Q+t8l5WC3v5kQLAoul69R1Qk19dz8yHVtkJPy4Vwahmr7ugbP7z4SLVs3vC9f4eyxG1/7GySkTthIntIjzfEWzKKsSTLOI+iw1P/M6SGDvWU5+AAZaAaFxAicRzqEdytyBrlfNjSLJh5SCbbMWgRri0rpT7oZWxl4/DgvPUEXaxl967pe62o4kX5Ztuq1AQ9E5fEdW46klCrfiClEy7av2ms3nzWyE7JLa/UqptaQd/QLRqksj3z90O8Fj/jCXJakQzv3HhI5od1knz7ZGX4cM3Slr/WjIbm/rF4L8o3V58ex2c/o0NEjgXuv+rTumQbOLx3qnqljwb1q2CpYacofI7Wcv5d5ekvKdcWv4NTOlobroYGQ9StX6gz4vvpjfmJK8jdIJFi2hFyvky2V6b/E9EZbmR8Vwda2wSHhqT8nTYLii7gfLrY0de+0rexE7siCk8rLHCzsROb4cI99wcTC/W0/oXF0eD0J5XU1xXAAxzaWXGxU5h5h2F1LZYpYZKy
 4ctxjM6X
 gUlzZqM7FVFxeYSXbfgA18UeSDPadJSqCSC8XlkgwAooHqYVC1ebDfKhMPT/H0hSAZefqgwO/D00wa3X/jgWdKBm251CeoJOVd2ayWma6knbiMzOMMCHW1SaPqg8IcV7hedfnNzZptKUHDMmxh2ccmzJFtVH3kPIF9z0LEcSx8M77onMiN2wzAMiRRphEPWm8YUyP+BjxDnrY1iI7a0sry9OvETubgn+S7Q37l7CCmp3Mpx4nvk+FxSU2CH8aKqNrlVFq82XPPcJuRBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> The memcg_page_state(), memcg_events(), and lruvec_page_state()
> families only read counters. Constify them.
> 
> Use container_of_const() in the lruvec_page_state() family while at it,
> so the const isn't silently cast away.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


