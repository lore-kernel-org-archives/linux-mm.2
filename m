Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344AE111224A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F7C6B0088; Wed,  1 Apr 2026 20:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0866B0089; Wed,  1 Apr 2026 20:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F65D6B008A; Wed,  1 Apr 2026 20:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4D56B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:22:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 906B557F3F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:22:24 +0000 (UTC)
X-FDA: 84611714208.30.9765634
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id ECEBC2000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:22:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KbJhuiDn;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775089343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZ7SX3eRFZJ1J7/BkXbBpWEJdfZLLi+551b+oWva2Xs=;
	b=JtjnmoJKjIHqHzFqsA4LDW9v2bEkSQ6jOeM88xDioNKrc4nDILCbPSilzToCuZHMCKWigD
	tPoK1yceyog6OCmyP0SWAqBYc5wlmUkSCIj9EjXalRcywCE4UX27CM9g4jqkl8n0S9g17t
	X2VM46VkVMZhNhzEnc/Ah5gV3tzN7gs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775089343; a=rsa-sha256;
	cv=none;
	b=MFdF6yjcLXuwqcZkDPDjcA+jE40EvjbFo7ZwCfO0n41MeiRcL0F+opgTYwvWnatyKYQ7Nl
	T6zNuFTDjUxSUKtUOKz9mxrduJww1p9LXsDZyHs/uLua3nE1JVvlRKdYyxbsVifAkSL9Ib
	qFum60/PstMopgcqheL3bAvubMBaYGo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KbJhuiDn;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 42A02600CB;
	Thu,  2 Apr 2026 00:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C80C4CEF7;
	Thu,  2 Apr 2026 00:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775089342;
	bh=6AQsnG0JZdnHJ4ld9U9uqtPepg0X3Ro6biYSpZ6g2EQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KbJhuiDnCBiM2FY/KxGIRstF6pSM88+XbZ8r/IihYwoqssckicdLwHVvC7YNutDv5
	 eUo5+W4iF3BF5+16Sji7MtRwm2NoLEugkfJ2J6BQZ+ZLa4qde0BEnfPcdW5Hd2fC0H
	 nvnJIw4+2+22Vt0z5bcXJlgYhmeHa8g6D19qMV58=
Date: Wed, 1 Apr 2026 17:22:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ritesh Harjani
 <ritesh.list@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang
 <huang.ying.caritas@gmail.com>, Juri Lelli <juri.lelli@redhat.com>, Mel
 Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
 ying.huang@intel.com, ying.huang@linux.alibaba.com
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
Message-Id: <20260401172220.fff999a33e3ffcd0d1fa8929@linux-foundation.org>
In-Reply-To: <20260323094849.3903-1-donettom@linux.ibm.com>
References: <20260323094849.3903-1-donettom@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: eaaxd3gyicpkhw5msjc9ofubz3w9c4pd
X-Rspamd-Queue-Id: ECEBC2000B
X-Rspam-User: 
X-HE-Tag: 1775089342-685436
X-HE-Meta: U2FsdGVkX18zNpDSlE0MoG8tOJLYqWp402zGbFIzrIiUOo5bbBRl0gayd21Vclrzpi2XW3EBliXxdTv1ZlZH8ROSQSWcxtehfDzcIcxqU0zYbweqrfwfLntRVpABJbxjEq3odDeIOjMkpXAN4ue00SbuSHRdrDEOOMIVmZUuHEXLtwgYmyL+omNzL10fOlLJiP136K29m1frf8fYdUAQFo+URbQ0y15MgCh8umUcy2rOu/ZaNvSHSSG0XAhz3mug3VIZLmylYcRhiCTZYdKu0CYYpKVx/NufK4CRHdMEjz/cLNncHvcdysHudsbmoZT4ObnouZ2zY66TCIyj46VK2URfTS/Lzq9Xz1GsH5D7n0LxSQY/Vvaet/sbzw8tI1z67TRH6FmyVMrdz+4xyu65T7HmhxwE88JGRiOhhokMc/5LKPWZx9yQ+LECOG5IQLGuEBEF6BsCNOVSCNgD7f3Ouvm2dwqLnm+x1xzYGquMyT57JMJVv/VK0wA8OanwIBk99nVmOjd7pzW7rzkN++6WR0sG/c0r6JaZ37Z4B4MqicJhjDgWP/M/4UaBnTjUU2lUYc/m7snetp3A66ZZWzNz+uOPyvBt3Uh2M575MLgfGRlIor4s/pbuKHjRC0r1oV2BSqBVSqr1Mp54D2LNIxZic0c05NIcsYvfMA8Yvkfar3wWQtUBiivhn/yDgNUpKGS2TbBFqeQJPE8CXVFbj9WDOBiW87iouTuEdTSMps8K2V5LFJ1LMsPu1AficFsGGNXTSrmQVOLqcbXyyo5qqq2n6nGoJI7N9hJES7QSqsCgOLC9LfuaXMzCZSHfgvP5sOu60+IQDW9XzKf/maenSC0202c4ASV4uelpjukEmat8iWmCHudQdNOGC3Qv+V62KYyIVtAqWdIT72WCCh6/NS+lAIle0bJiI7HL8Gp/OxhdvfZeyaQW/jhDbd06THCQ1gMoCmq4L0mCSbl/gm0pUtL
 iQOCHbXj
 n+ly48YltUkNdzmOvg92Ccrpv1xolQrRw8FVifcI+/xn2+20xzJ2a9Hgh3iEhSz4YLyTjRzE70NSQ1iz2ixN8UKg9LZvZkoSvrFAyM+j6QDssVOHBEAfJnCDi47Fw8NUFXIZGHBpr8Lw9EzD6R10tTzl69lNZjcGCPc6QXFBtMxiEjpghi3ks7gKj29lC3NYOiey9hBnnMPteg2yytCPdRAkRD4ryzfTC2PZb2rE3bqV6oa5+1UqXnsxJsBhqJyTTqmEeNrBlKQFTlpPyG0g7zjBOTrj92wsMesrbher3H4WidvQxmEmZhxStm7WkcbcLBE86Q7rp4MngucWXSwZl2kZmIHIoVeEm/H6T3T6UlMlLjtoCl5iTPVyA8F0I9tyVBkRGmGf9mleZo32NceDOAzXdqi3lJXrgiZ1aaQx+z9+pq/6sveij0vov5D1NRuKaNE0+4sB6DUjRM7uLFqxk5l4ruhQFfBZ84663RWwTSCYLmgKxXvhOEJlLTaMF/74Hsrcc9N10I/pgvzaJ5VjEGqZBxAF6Bj95SE4kG65XtK74ObN6NZMfa/I5jUH5clOYX7ReGx9Ci6R+vpXZu7t20ix4cLSD7DyxfmYQJMvsgKOJ8ezLUZk7Pid9ljhoXQZqwmBDHcFXOhbWXTLDcb8IM5eNPA2qnm5XkM4amn4NXkKJWhtqLuSWByE0eoxJQW6eulrpzU/7tzdgH5+5bzs7l88ki9k3puE4LuWrk/dygicgQobJWCBAUoTyay3jD5Qjqg0fUMD7/1PDW+XMrfJN5ZiGHCK7v6O3jxIhwp82NzlK8fc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 04:48:49 -0500 Donet Tom <donettom@linux.ibm.com> wrote:

> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
> disabled and the pages are on the lower tier, the pages may still be
> promoted.
> 
> This happens because task_numa_work() updates the last_cpupid field to
> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
> enabled and the folio is on the lower tier. If
> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
> can retains a valid last CPU id.
> 
> In should_numa_migrate_memory(), the decision checks whether
> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
> tier, and last_cpupid is invalid. However, the last_cpupid can be
> valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
> evaluates to false and migration is allowed.
> 
> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
> disabled and the folio is on the lower tier.
> 
> Behavior before this change:
> ============================
>   - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
>     nodes within the same memory tier, and promotion from lower
>     tier to higher tier may also happen.
> 
>   - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
>     lower tier to higher tier nodes is allowed.
> 
> Behavior after this change:
> ===========================
>   - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
>     between nodes within the same memory tier.
> 
>   - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
>     tier to higher tier nodes will be allowed.
> 
>   - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
>     enabled, both migration (same tier) and promotion (cross tier) are
>     allowed.

There was no feedback on this, nor on your v1.

> Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")

Ying Huang seems to have moved around a bit - let me add a couple more
email addresses.  Apologies if we have multiple Ying Huangs!

Rik, Mel?  It's a bugfix.

Thanks.



From: Donet Tom <donettom@linux.ibm.com>
Subject: memory tiering: do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
Date: Mon, 23 Mar 2026 04:48:49 -0500

In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
disabled and the pages are on the lower tier, the pages may still be
promoted.

This happens because task_numa_work() updates the last_cpupid field to
record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
enabled and the folio is on the lower tier.  If
NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field can
retains a valid last CPU id.

In should_numa_migrate_memory(), the decision checks whether
NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower tier,
and last_cpupid is invalid.  However, the last_cpupid can be valid when
NUMA_BALANCING_MEMORY_TIERING is disabled, the condition evaluates to
false and migration is allowed.

This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
disabled and the folio is on the lower tier.

Behavior before this change:
============================
  - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
    nodes within the same memory tier, and promotion from lower
    tier to higher tier may also happen.

  - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
    lower tier to higher tier nodes is allowed.

Behavior after this change:
===========================
  - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
    between nodes within the same memory tier.

  - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
    tier to higher tier nodes will be allowed.

  - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
    enabled, both migration (same tier) and promotion (cross tier) are
    allowed.

Link: https://lkml.kernel.org/r/20260323094849.3903-1-donettom@linux.ibm.com
Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c~memory-tiering-do-not-allow-promotion-if-numa_balancing_memory_tiering-is-disabled
+++ a/kernel/sched/fair.c
@@ -2024,8 +2024,12 @@ bool should_numa_migrate_memory(struct t
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
+	/*
+	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
+	 * and the pages are on the lower tier.
+	 */
 	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
+	    !node_is_toptier(src_nid))
 		return false;
 
 	/*
_


