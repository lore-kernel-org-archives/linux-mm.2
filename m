Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A51606A33C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 03:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AsHsd6iv
Received: by kanga.kvack.org (Postfix)
	id 7E5E16B05B6; Sat, 31 Oct 2026 23:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76FF56B05B7; Sat, 31 Oct 2026 23:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661126B05B8; Sat, 31 Oct 2026 23:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41D716B05B6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 23:20:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C56E9A657E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:20:53 +0000 (UTC)
X-FDA: 85385098386.19.C6F486C
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9962280005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:20:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AsHsd6iv;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793503252;
	b=xkuSrJ5DgA3hpSokNI6ugameylIntc/Z3lQNc4mbZpiKRqyu9NDz9HdmjZJjHzstAfYU7t
	OaFMOD+xO/DUN3xYsmak3roiv4tpqqBx868NtkmW6V2few79EB5sRB0q9KNyhGAxGCLcI4
	OJmY40DG9R7Cja5o/5Q4M3U0HZ8QyMQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AsHsd6iv;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793503252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbZweDIxhmL7siggWffrhdl3D49Th5aeEe2VbeYB8MQ=;
	b=LOhbyqNv6uy9VI7aBNVyGxYmq0b4E6AjSpUhCmiR7MsMs4CEDXXtbqX/IHdvOgKP0oXVfK
	FGtZBPiR82K7IC4GaiBVz8xHYSnj7l6BaYJxCwrCH5+tnAI8ZuU/OR8WVw8LIuEhw7bP5z
	1fN2QI5M1J+AmPHGIgUQwmd4sSZg8N4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DY5Hprcbq1eAPJOCDEu5rT8kzGVBeBju20d+Mp3qU9Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793503250; v=1; x=1794108050;
 b=AsHsd6iv+QMCCWQMCEf+Jdxm7nXGSTHuufXbC+H9Va2YBuno7SRw/fjOnQnmLdqZwY8vHfgz
 3y+FEoSWmigW7CguhUpgy7DNRQUSOnQN0PKmPPF1N9JAdBjMFMOHHVB0prULwZrdVH3L/NTU66r
 v92lrCSOdpPT0Igh5kIZN/P8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 307f81ddaafada5e;
	Sun, 01 Nov 2026 03:20:50 +0000
X-Mizu-Trace-ID: 307f81ddaafada5e
X-Migadu-Flow: FLOW_OUT
Date: Sun, 1 Nov 2026 11:20:41 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v5 1/6] mm/memcontrol: drop unused vmscan tracepoint
 include
Message-ID: <auawCfHE-jUUZunl@bogon>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-2-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031090041.58574-2-ridong.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9962280005
X-Stat-Signature: 6yiofeppypnu65tqz1j8dh9y6fbnux9j
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793503251-900686
X-HE-Meta: U2FsdGVkX18vFn9Jwb0xRC+An70zKr1W639L/r7vwzhErg4cg8j1CwRcms6LI3FnXVdns2pTJtlf40Lvs4k/IpI/Jvejspclibs4PSq5tHE7K6YF5VO9yKgOhdKkkGx4Q9Bv/1p0wh+ZdmwJ706VfhLgZRGjEK36wlBODWXdDyyLDGeWlPD793mGBOsamTKfN4w+JRS1LB9qfBRi4r5t34cDGzzg00EXIG9xDHNLMqhBSM9V5gMvO3/V2oBfCUzrilkU9HufoeAT6LJFV3AvGfjkbk4fFcJwYEg9NGg78hoGN0mp8D3cxnjcBAiEy86GPf36pUCsyLTCpZVZKASoOxqAAvs3vj5mbm6TIkuvs6YjO571mpdHM58zt2V1M8qVaWGffx1L/VJUy5pQJ971WEw6rkaUqL3bCupxVNhPyb7trbzjdtzS2iUaLiJXXS74U+n0C5qcoMWyBYy69xH5Qn2k3kdVPq7b3DBH8uTOFmOswBcooDJDA7UuXnABqrLYXUmeRY1ZSl1g7mBEmWwCG40kHbD9kw8xyT6AAtyNdzGv/tqzgomo+LlYuvQAVkYaJjH+yxY2TaJoAyWh7C4CMeTMwktuOXftJpaFLNMid9xtNeaC2Zch/jS5490R8L3b+WH6RQk1JSVYZCx/Yya5+j3CnChdtK4OaS3dZbbDwoZXSXBu5+rVMqxWP8AlyZoNEgBbsYIFNnAy4P8Un+qoH+dNRZM3x86zUKv51Gih2ni72OV3XejMLVBpAxMzzwnntZbPbVC6bBD3ObCaZCG3F+dV1/9wKnSpvjJXmFasF80Onf5VrjegTd45ELRBNhALmEHNgFctDy2+r7wnKxxLX0On2jUrLxyjCKdGABwP4UcdL0qbkt/foCsyhgK2X1eqOOhkssYWOOvqxT/y7XJ6jnYlhLL2Qx2xOgZV0CS7Mhq1OoTjpeJjQpxRqsp1oLEwVF/aCf1zZCvtg0UsRzE
 Y4NC3ObI
 147ECMoKPf6k31/BTv3ov5atX+DAjxeJ5WMI6XqIMJos5ynSF7Zg5prYi5D/JSDbmX/KZ0a45LjTiOURqAkTPUWGFowV0E9pmG9trbwrFUi//nBcdP/4kdFuFRAuHuVk4It4ofIYBflVX6xqi67I7X2n9BXFqa16BKM3m0ml+sfqkkC+im06NkRWLnOYtyTMCSjleEQ1X2NvexkYGyZuA8+y3a20Fr5gNJJ+bIet5S4TU2O0biIeP9iGvH0wIknaPF7A2UxbNBu4X1kdAYyZX7GqhwuPyZfISb6wC/q4lsTRNZ6dY6S7QfJ+8I53Yp72UL3Td
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 at 05:00pm, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> memcontrol.c includes <trace/events/vmscan.h> but does not use any of
> the tracepoints or macros it defines: all tracepoints invoked here come
> from memcg.h and writeback.h.
> 
> Drop it ahead of moving the vmscan trace header under mm/, after which
> <trace/events/vmscan.h> will no longer exist.
> 
> No functional change.
> 
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  mm/memcontrol.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 84f4a8fd4d16..8a35f5b635e0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -77,8 +77,6 @@
>  #include <trace/events/memcg.h>
>  #undef CREATE_TRACE_POINTS
>  
> -#include <trace/events/vmscan.h>
> -
>  struct cgroup_subsys memory_cgrp_subsys __read_mostly;
>  EXPORT_SYMBOL(memory_cgrp_subsys);
>  
> -- 
> 2.43.0
> 

