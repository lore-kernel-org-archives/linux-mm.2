Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D29DC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FCFD6B0095; Mon,  7 Sep 2026 04:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4D96B00A0; Mon,  7 Sep 2026 04:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EA6D6B00A1; Mon,  7 Sep 2026 04:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31B426B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:40:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC74A40694
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:40:16 +0000 (UTC)
X-FDA: 85186319232.09.1C06532
Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	by imf24.hostedemail.com (Postfix) with ESMTP id DE22D180005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:40:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mimAj+tN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788770414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frSm7DWW8zJv/ucf5mxKFj7Ad5c5kQn6P7YVOYouEyg=;
	b=UN6WCZJD/qe0aUEB0vAgYdIl7chrrV5o7qk2PI0nRjicamw6FmVfwymVcB4CWFW6Zu7HtZ
	8N3AQ78UGgjdNVsfMpvEJmXyZjNwDPoZ2yDk4D/42dNc+gj2Lx1CFxlUcsIaS002QrSodd
	UULDDSb14GZHDAD5YWIJ8UgPH91fsDg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mimAj+tN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788770414;
	b=DWRbC1qNWtttpmhX+uP6Z/4fVnt2dU8hb6lXne/dUImvrX7WgDz9nawO+Om3wr7wlResmw
	nnYCkfMzKqzdkvxO0s3uBn275U/M9dH4DlkbB3pB0SFo7IU415kuW+mL52WKD7WCmy77kt
	js9tvRs8kSPkHXvQ6eIdwdJVZaE2On0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GGO8eqN6d+o+o/h/2jMfZ75tLsSl7Qm1XxnpQIF2MLA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788770409; v=1; x=1789375209;
 b=mimAj+tNTstS2NFREbTdf492Qym2vL0fMboNBRUtTW4JnNus1vHg07l/KY9ZSBsPuNdnYjwS
 5aij5txNcIc1eshgmoO4YYSvlu00Fl4r/nxsSX7V4vOVAPfKV5wczM4OZEFH+ooSNYTHPJac2LB
 0luQVYqVunPm76ui+FWJJhNQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8cb33a948e3a62c7;
	Mon, 07 Sep 2026 08:40:05 +0000
X-Mizu-Trace-ID: 8cb33a948e3a62c7
X-Migadu-Flow: FLOW_OUT
Message-ID: <f1021240-ccb6-43dc-8e02-b94f0c4f5fb6@linux.dev>
Date: Mon, 7 Sep 2026 16:39:54 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v3 1/3] mm: memcg: redirect stats updates of dying memcgs
 for all hierarchies
To: sashiko-reviews@lists.linux.dev
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1788514750.git.zhuhui@kylinos.cn>
 <8a3fe5e6a076cdd9ac997125cb6c6a0948e1a6b6.1788514750.git.zhuhui@kylinos.cn>
 <20260904102113.DB9011F00A3D@smtp.kernel.org>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <20260904102113.DB9011F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ai3q4kx3yfwnzwfjnzxdw3qd614ywt8n
X-Rspamd-Queue-Id: DE22D180005
X-HE-Tag: 1788770412-616675
X-HE-Meta: U2FsdGVkX1+yndQUnCLdUSBpwomu3pkCJejwMdGhL36z8x9G7J25EDoHbuZ0dX5Kxp4XM3DlooGMtL8NtdrJ5fbjkRkmQMPwY3l/3I9O6vd/SkY7vMUIebDmv5gsKHUTLGaxOn+Yv3TXyrraW4uxoGU1mqhHizH+uUh5QaEosNQpaLvpOCTks0m2tFZIvfBjtmfNUav9Zyv23rJl1vIBYJzSXVXDmsfbci+Ov8uZEa365dBpn28HZqruZ7cJTiPaQpl+Z29GTqbT8MGz52thl5c6Yf0vVXNM8rfvKX2BfTBHektGnkjP23jtIpTw5kj/U9LBbvtHrh+jdUx6sbifItPkenUdZtKhgmh36lL1Z+L+WnEta8zYcmAnfd6vGDLeqvcacpvNuLZCMxxAF+7AnQGv/nxeCp2SzpFJ1Q14SMrvEnNZBs2PqkBEh/QCDa6Tol7VKyeyXvlYm0WngL/ZCWjKjzSje1XEHdAHPglaSbv50XkQxnb61w1pUtsiAxwpqMh6Q37AfOF4Gnq1CgL3JCgDEJ++S5LPDtqxCaL5Li6SvjcNwNgPD8HsOOW0RG3u+Sdt1kwwbOsp8i0i4lk+AwVbE3XAI836gtM5HCnHqqgwEri943Y1jdP5tLQug6yRgeifBvaiwCh8jKq2GFAsk+iuJzVWOscdsu7deOXuqNSV3yVadwJe6l4pFxNmcWBhvLpSQ5AwGS4MNm66FO/aN57GuxgvPMQ/bAkYa2zZA3PsF7XEjaGEcqb8UTBaITZzay5eNxYa8O9e3hP/A3MdGIavWIGDGMNQwWqha8lWAyxUrV4wNx1hxFNxDuBOAS1La8ohz+v37OdLnUAdnM+V9nczlVoV52YNq0v4L++dPL9X5y6HA4k/eB7+JW0k14/5VoaULaS7V7IrXgKYyu7tCBR3m/sowkeOe3hsuPpZVI4aoT7FLuVf5F/D/maWQ0ndKjn/9sOzIV60SB5x8uT
 //COb/mP
 D80bBOc8zE9yRFRRXofIaRi0Myd7fWXTfg42l5SUizU4mIX0/6y7AfHbaFX3HghlsU3FB++72fx6TTEW6IMLlMf6Cl8N8HUsHSGq4J4k4t+8A1xKwWd7xGk9irP9xUkoLKLE+lsmSSLQDUi9se8JhqgiQB+E5DNL/HCLnLLP7eW/QMbN5CBjOFEoNJDGT5AVvXuQJpVMj1GC7zD6TqqErkA4TWYysE2laADYknXUNfeoU3n4Qf+9w+SErH/rPwpmj1Mm+ULyCpssWDNEW4JLHz/RXQ0Lo81UFnfDjmcSUhxx/PBalaT2fYv4EOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Redirecting dying memcg stat updates to the parent on cgroup v2 without reparenting the base stats causes permanent negative stat leaks and underflows.
> --
>
> commit 106b19246ac20191c0af6a41927414095cb5d019
> Author: Hui Zhu <zhuhui@kylinos.cn>
>
> mm: memcg: redirect stats updates of dying memcgs for all hierarchies
>
> This patch removes the cgroup v1 restriction on redirecting dying memcg stat
> updates to the closest non-dying ancestor. It unconditionally applies this
> redirection across all hierarchies in an effort to fix workingset shadow node
> budget calculations under MGLRU.
>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 9a65d7148c227..64eb59bba61cf 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
> [ ... ]
>
>> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
>> -							   bool *rcu_locked)
>> +static inline struct mem_cgroup *
>> +get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
>>   {
>> -	/* Rebinding can cause this value to be changed at runtime */
>> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
>> -		*rcu_locked = false;
>> -		return memcg;
>> -	}
>> -
>>   	rcu_read_lock();
>>   	*rcu_locked = true;
>>   
>> @@ -870,22 +864,8 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
> [Severity: High]
> Does this redirection cause permanent stat underflows in the ancestor under
> cgroup v2?
>
> In cgroup v2, base local stats are explicitly not reparented during offlining.
> Looking at reparent_state_local():
>
>      if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>          return;
>
> Because of this early return, the dying memcg retains its positive base counts.
>
> However, with this patch, when resources previously charged to the dying memcg
> are freed later on, the negative delta applied in mod_memcg_state() is
> redirected up to the parent.
>
> Since the non-dying ancestor never received the positive base counts but now
> receives the negative uncharge updates, its local stats (like NR_FILE_PAGES,
> MEMCG_SOCK, and LRU counts) will permanently underflow.
>
> Because lruvec_page_state_local() clamps negative values to zero, wouldn't
> this severe underflow mask the ancestor's own legitimate positive stats,
> ultimately breaking the workingset shadow node budget calculation and causing
> the exact premature reclaim and thrashing this patch aims to resolve?
>
The observation is correct: on cgroup v2 reparent_state_local() returns
early, so the dying memcg keeps its positive base counts while the
negative uncharge deltas land on the ancestor, and the ancestor's
state_local can permanently underflow and get clamped to zero.

One clarification on attribution, though: this underflow is not
introduced by the redirection.  Once memcg_reparent_objcgs() rewrites
objcg->memcg to the parent, folio_memcg() of the reparented folios
already returns the parent, so the freeing path applies the negative
deltas to the parent's lruvec directly, with or without this patch.
The redirection only matters during the short window between
css_offline() and the objcg reparenting.  So the missing base reparent
is a pre-existing gap that this series re-exposes rather than creates.

That said, I agree it needs to be handled.  I'm preparing a follow-up
patch that also reparents the non-hierarchical lruvec state_locals
(the ones count_shadow_nodes() reads) on cgroup v2, mirroring what v1
already does.  Will fold it into the next version.

Best,
Hui


