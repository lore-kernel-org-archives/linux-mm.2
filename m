Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73564F53D6D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49266B0319; Mon, 16 Mar 2026 12:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC836B031A; Mon, 16 Mar 2026 12:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4B26B031B; Mon, 16 Mar 2026 12:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 866726B0319
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:46:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 349F8583E2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:46:11 +0000 (UTC)
X-FDA: 84552503742.19.446199B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 78E3C40017
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:46:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WPHomySG;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773679569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6tb+RCgHWYd2lU6UiOAiP8dhBcwWcYDtz/CUBtcHuw=;
	b=Rg94Se7g6OQI4TEUgjZrbBC8B9HF7HlM2kyNkjWMdq+GZO+OiDGK2lQ7fqhEPTHFq/QFGX
	SoqOpDqNkM2NjvxR3/p7uNodzo6JfWUMvRtpt7dYFk7dK/MHXo5IlDeiwsyjuvrpopij1R
	bigWitUUDH2eGorkLcS1phzP5WEifcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773679569; a=rsa-sha256;
	cv=none;
	b=neeg1b35jTBtZKf85hrsLwFE0tMNnChvdV2Hwx3WY7ao9lVu1y3kttAusDv07iDGfhONsX
	5/iXLOPmVznJa/cy7PnRFlPwKFSjmu5fE1edjO2T1SEje/jjyy7Spq7Qb43Nj8NBf17f02
	Cpxji9or1inwV0g1cfpRAY/4TFn83Gc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WPHomySG;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C66AC60097;
	Mon, 16 Mar 2026 16:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063A8C19421;
	Mon, 16 Mar 2026 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773679568;
	bh=x3veN1AGSESlcaN8+BxreAHIRIscaBpWO+zEr/eyVJY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WPHomySGC89wv9b6Mtcd5hr61L8O0Xaydp6D/YAjTfwvS6hW8FFu54i3BJfF14jKy
	 lnf7xY9dc0wa+/3gyYKkdTTcsennhI+Y2RZFWAjykiCnu1dpORc6Q3Jh+tWpQgwgag
	 gCCjO3lqI0A1X4YXAPgnA2O1aFjx4lWARTKPIu9k=
Date: Mon, 16 Mar 2026 09:46:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: axelrasmussen@google.com, david@kernel.org, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, mhiramat@kernel.org, mhocko@kernel.org,
 rostedt@goodmis.org, shakeel.butt@linux.dev, weixugc@google.com,
 yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v8 0/3] mm: vmscan: add PID and cgroup ID to vmscan
 tracepoints
Message-Id: <20260316094607.d59eeaead6e7a79df74d9476@linux-foundation.org>
In-Reply-To: <20260316160908.42727-1-tballasi@linux.microsoft.com>
References: <20260223171544.4750-1-tballasi@linux.microsoft.com>
	<20260316160908.42727-1-tballasi@linux.microsoft.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 78E3C40017
X-Stat-Signature: sm59n63xz3kfi5nwtkz4ejrxddxgmd51
X-Rspam-User: 
X-HE-Tag: 1773679569-549156
X-HE-Meta: U2FsdGVkX18dfZOrDwIf3Ouo1Sv5O+mwGlY7isfSuu6uyFl6m4w21xnV1q7WpSPqHweJgcaH7VXpYu8Eqm7Lqq/jpsz4ZcIsK9efda+cjuf/ouRH4nPHsjwrlE+XD/Y5KkK37VtQfPAWrCota5C+rEUjgT7DU4R2vSB3jED1YZJ/LkFMMVxgiWxK16MXMpIeR2a9/5maJ9alJuAMrQUEPLzHko51h3m/rQF786tSm1N9/r1+MJQWdA70xprRpiu8StECb8M8dGvQsb0nzBRxSk2KHAL0rtlTeMOPMW/VJ2vz5tdYmLuilAxAOw816hLql6p9449u2TrLMINvhf0z0OJgFvd765sAOJNwi+jAtbTOuKafzrB2sboN6ubnhU+UNFaUXcr1U1bm+OsJ8bXVe/znG2Y85VKXkZYCZOvjqrjc8ZDBaXBr07TC8F8JMM5KFeQC01+4lb39yFPxFNIJ8Xv3Smpq2HwWhtEtFxWKBYHeCgw9vBWR+03YUr/y4N6QceDGR8/ksDEigx7xw97nvECxpT0dw+w2HD9GuaNLKJFD2bBO0D6WcwLEoj+lgxBsro3rMtZt/9oWyDa7H3Qxh1560i27XZwt3M7LlS8WtEayRK29jcX+VQdw0Jx+E16jjWfqWopb1eMdrl9gMmgvryM21G1p7CwLi9wpfLGdG2BqgjZmn3+gyH3w3pXnnkBbiiOe2IKnTQRZ5c59kePu/hWSHYhIalrXe+qA6xoioljWREczZmDwFqylcj4zn5cBecDbAMxNmAIoBbAaldyyrVXUpZ95rBdNyZjdc7ciWwpqzIhLl0v5baYc9vdpYLEOpbbH6gNx/Z/lPYkdkj9Zi52CkwYagta0/RWI9OV8Z99aRHY7Q92iBvLhmDm144jo11TvngVUXGh6jMwYfEXYuEBGD9TJl+Xh8mRl8pEy7jEJysluC6IYgZ4kq104xysvFgUUheC5e3w8Q68FO2R
 GY8+UnSL
 KzOwgJd+t2TbrjAWkwuoskA2a/yk5ZsQZ2TluCN1BP8bCMwb3SrP8A0u1KRWQjscSxLcWX1oHxDL1seHQEWvIWAZTFHuTI+Tf0/a115/f66FSaq4uaQwLF18lnm6vjfUnMlpMR2JTBtjIAPIe4XgGRC6iodh3xnWW4fNPDxlwywUWXZtlkNQKzAzFkE94+4jiwiSZEEnWc1bE+L3s7PX4VDe6Hsg4xPe1KR0FYtqBpEfH/7zIYYVXh3GvpwwpBs2kJtasidLRtD/me8tc8w/7xoUw+FOH+61kRHxg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 09:09:05 -0700 Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> Changes in v8:
> - Removed in_task() mention in PID commit message
> - Moved __entry->pid to __entry->ent.pid
> 

Below is how this update altered mm.git.

It's a minor change, so I'll retain Shakeel's Acked-by and Reviewed-by
on the first two patches.


--- a/include/trace/events/vmscan.h~b
+++ a/include/trace/events/vmscan.h
@@ -132,20 +132,18 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 		__field(	unsigned long,	gfp_flags	)
 		__field(	u64,	memcg_id	)
 		__field(	int,	order		)
-		__field(	int,	pid		)
 	),
 
 	TP_fast_assign(
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 		__entry->order		= order;
-		__entry->pid		= current->pid;
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
 	TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%llu %s",
 		__entry->order,
 		show_gfp_flags(__entry->gfp_flags),
-		__entry->pid,
+		__entry->ent.pid,
 		__entry->memcg_id,
 		__event_in_irq() ? "(in-irq)" : "")
 );
@@ -182,18 +180,16 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
 		__field(	u64,	memcg_id	)
-		__field(	int,	pid		)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
 		__entry->memcg_id	= mem_cgroup_id(memcg);
-		__entry->pid		= current->pid;
 	),
 
 	TP_printk("nr_reclaimed=%lu pid=%d memcg_id=%llu %s",
 		__entry->nr_reclaimed,
-		__entry->pid,
+		__entry->ent.pid,
 		__entry->memcg_id,
 		__event_in_irq() ? "(in-irq)" : "")
 );
@@ -238,10 +234,9 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__field(unsigned long, cache_items)
 		__field(unsigned long long, delta)
 		__field(unsigned long, total_scan)
-		__field(u64, memcg_id)
 		__field(int, priority)
 		__field(int, nid)
-		__field(int, pid)
+		__field(u64, memcg_id)
 	),
 
 	TP_fast_assign(
@@ -255,14 +250,13 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->priority = priority;
 		__entry->nid = sc->nid;
 		__entry->memcg_id = mem_cgroup_id(memcg);
-		__entry->pid = current->pid;
 	),
 
 	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d %s",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
-		__entry->pid,
+		__entry->ent.pid,
 		__entry->memcg_id,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
@@ -288,7 +282,6 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__field(long, total_scan)
 		__field(int, nid)
 		__field(int, retval)
-		__field(int, pid)
 		__field(u64, memcg_id)
 	),
 
@@ -300,7 +293,6 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->total_scan = total_scan;
 		__entry->nid = nid;
 		__entry->retval = shrinker_retval;
-		__entry->pid = current->pid;
 		__entry->memcg_id = mem_cgroup_id(memcg);
 	),
 
@@ -308,7 +300,7 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
-		__entry->pid,
+		__entry->ent.pid,
 		__entry->memcg_id,
 		__entry->unused_scan,
 		__entry->new_scan,
_


