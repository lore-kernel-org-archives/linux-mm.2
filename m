Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9895AEA3C4E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3D66B0005; Thu,  9 Apr 2026 08:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4D16B0088; Thu,  9 Apr 2026 08:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA146B008A; Thu,  9 Apr 2026 08:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AFEA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:24:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9EB51407C4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:24:30 +0000 (UTC)
X-FDA: 84638935500.16.3CC793F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38A32100010
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:24:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l2cYqF75;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775737469; a=rsa-sha256;
	cv=none;
	b=gR0HYVkCY0qphTgosNIlvfeQ5KhdXnihM109Dba9Qncjzka7eFrwxOtCcpwE+u3aYmCRdy
	Y8EanvpSGmeECZ2kvR2KFd/bs+15Hav9h25H6AQk+hjbivcoo/IJFXzOdmIfySTfTE/fuF
	aixL0e93jYrxZjR0J57Nt+kn2DqDTi8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l2cYqF75;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775737469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PM7MaHriNUEFB+o8kteuM+E2BmDYwHKcJQAl1Jgg45A=;
	b=exsaLY9AKrTvKBwFROZIaQ98gpT/6l0EP5SAgRbb1m/fsa4mB+M8WSkeOpz7R90ymEilvW
	x9dL9fNCgrLHiUznLxMXhZ6S5sL5BZY6Y31ttA80LRGRuHXkPK4tBauAbEcwfK5xbBh81f
	mUNuz3MO+b0ZuwP4oOMa2aspzQ1l5Vg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 96D13600CB;
	Thu,  9 Apr 2026 12:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18FEC4CEF7;
	Thu,  9 Apr 2026 12:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775737468;
	bh=fBTfRQqFhKeXUAFRuAg3wvuxeu46K2mxZlXpU5U1ZnE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l2cYqF75xpVjq5ArP3+qpb7TGko+QkdgQ00Si6Qj2xLK3NzjIATCMoGl47gk6ierl
	 5HL8Vn4wkNYdXQDrmvLRSxqt0t5FR3+6aagQyI6btzwMa3n6cgwew0u/SdVQECMs5H
	 Bdbh+rKb26cO9JK4hlJU6Sq/WlzDxfBpGaTx7MSnk2nU6ULJDLa0jZosS5Ac+y9SoY
	 lHYyjvxkZehs6G1lBIu93HyhReESpBnCn33jYMhOveGV8HOeiECvUpAtzawtX1ys04
	 GsW1VUKCB2+JdqIrpwNN9EzWlnjlRyFvSIamlw3EvvduYzV+zxP3KGetqF5P2H+GRN
	 0p763Mlk7iIFg==
Message-ID: <1bcb477c-a9b8-4615-a5c2-2aa6468935f7@kernel.org>
Date: Thu, 9 Apr 2026 14:24:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/vmpressure: skip socket pressure for costly order
 reclaim
Content-Language: en-US
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, linux-mm@kvack.org,
 willy@infradead.org, hannes@cmpxchg.org, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, riel@surriel.com, kuba@kernel.org,
 edumazet@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260406195014.112521-1-jp.kobryn@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260406195014.112521-1-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1sip7we7rwuc781nkiesd6f6m1phzhka
X-Rspamd-Queue-Id: 38A32100010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775737469-110121
X-HE-Meta: U2FsdGVkX1+iCQjh1/E83o5xfwnFDi3RdyNsL/nh/rEdfcqActDC9zTKeuy6bmbHVnE7R8A6lROIxv3IiEpuqSAnozVqyAO6iDEAPnqcadeIZjTT3iz+/8cvXuBaaNCVwJ3QLGEsP+nHqknxxJKjiwkGeQ/Ct5AkRoLov8paHZdvF4UxlFoS7F6BSfL3yAq2i3CPgHDTvuuECS73LPtpeZEvW1LIY2IaxfYmgVgByRpxKkkhsHtW1yhf3YSxUp2a2NR63OUQTehb8zXyUocn+k6QMx3JgK1JiXn0nYjJKplNh7YxDwfuSgVu/CLWielaO5EYePcAtun92+XbFAOSWgNfEAEUyDkSAZFzZtH2ScBfVItzTRa0GVIzsIjAy3WYsG17y5sDEWfKHDrErlWp7Ak4UoU/Zr/WyL31f63XsGl14mOJTudmgo4dYLVnh+yKK/7kOXmc7iG4BoFmvtajekBeifC4yIBzoBjjP+tYN1+sBXCG291V3G+IyC2q5PDfzcjj4y3jRctiRFxQKYHxBvx9eOYgkUjkuq+PaC6aIXPu+opCSDAE23utEjfY5xbMEC0sMkeX6TqutHXQdKV2IztcFkhNUk2EIeB84alyMu1qNnkWM1q/94N+mMcRUZu5q9PZMjZJtSdW37d21OAHPuHWpHEiDldwTTFIyqIC+lKD97jVgj5cElNDg73p3F69B3ahTFYT8N6VWW4JZ6lKUpCK+WAbFYNeGu+ur6F0y3SVacVBmMNyoGQ9iGfW6jyJRTS7NlQ6uhMQlbu/Z07HJijndiu29QZ0kBU3M+70CCMNl7IsX1JqDiHSEvk3cYNX0WnwG9HqwiAgow8D3yGQPgA+S0Pmp5gIeF7r9mf2U91sSu65e/UIsc4FCQ832p6kRAkd7F5dHWYQBLlmD6NcYp+gbk4hc43mUoGQYT/2T4TAKIA+zmVQNonQyk7ZxDSJH8+yf9RGHsNArQRXbdV
 RbBJ4pr0
 hanVRbi8Ev46MlULbURouBJTQOrjI1aD7W315Be9m1uliHglco6CLUfXfTV+gdl02qq7PQr9R9WrfY1de1xvwpiO45phz7fasuDNB2cCYF/udnpy5bIusEM6rx8d29I4Cc4pWrNQ/crzg6pLbFUH+tFJn4DZLIZPIQc1M2G/yWy8B8AqVnfXqLjvEkf2GcFsWF5kzW8Gcq5R54LV6beEVarQ2/qxsZlb+8vbzT6q9vnNeYIHTepqONNIm7/bLDrnJralIVJ915yv2XjoCuFOcuxoCOi0IA2hS47PB0URjoYTjyWiyznIV0B6p3TcyDm/5FsTeX8kEXqWh5Fvgdbcn/Prb3LY6l6zj8IAroMO/gu5LebdMxZebVRfXaXmZU268zG6lI7V/M3U892pFqXA1BxmAww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/6/26 21:50, JP Kobryn (Meta) wrote:
> When reclaim is triggered by high order allocations on a fragmented system,
> vmpressure() can report poor reclaim efficiency even though the system has
> plenty of free memory. This is because many pages are scanned, but few are
> found to actually reclaim - the pages are actively in use and don't need to
> be freed. The resulting scan:reclaim ratio causes vmpressure() to assert
> socket pressure, throttling TCP throughput unnecessarily.
> 
> Costly order allocations (above PAGE_ALLOC_COSTLY_ORDER) rely heavily on
> compaction to succeed, so poor reclaim efficiency at these orders does not
> necessarily indicate memory pressure. The kernel already treats this order
> as the boundary where reclaim is no longer expected to succeed and
> compaction may take over.
> 
> Make vmpressure() order-aware through an additional parameter sourced from
> scan_control at existing call sites. Socket pressure is now only asserted
> when order <= PAGE_ALLOC_COSTLY_ORDER.
> 
> Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
> uses order 0, which passes the filter unconditionally. Similarly,
> vmpressure_prio() now passes order 0 internally when calling vmpressure(),
> ensuring critical pressure from low reclaim priority is not suppressed by
> the order filter.
> 
> The patch was motivated by a case of impacted net throughput in production.
> On one affected host, the memory state at the time showed ~15GB available,
> zero cgroup pressure, and the following buddyinfo state:
> 
> Order FreePages
> 0:    133,970
> 1:    29,230
> 2:    17,351
> 3:    18,984
> 7+:   0
> 
> Using bpf, it was found that 94% of vmpressure calls on this host were from
> order-7 kswapd reclaim.
> 
> TCP minimum recv window is rcv_ssthresh:19712.
> 
> Before patch:
> 723 out of 3,843 (19%) TCP connections stuck at minimum recv window
> 
> After live-patching and ~30min elapsed:
> 0 out of 3,470 TCP connections stuck at minimum recv window
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


