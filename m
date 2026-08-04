Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1672AC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182DB6B00FB; Tue,  4 Aug 2026 15:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132906B00FD; Tue,  4 Aug 2026 15:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F976B00FF; Tue,  4 Aug 2026 15:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D992A6B00FB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:26:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EA46A02E6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:26:21 +0000 (UTC)
X-FDA: 85064568162.05.6AA186C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 38DFF140012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:26:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gryoVr3u;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871579;
	b=0LEPH6EPib/XUvCNg5PcAxa0iNfN7whpuzXwxHxH2uYrjlwCeLgo+Fd8UndIznMDKHwvwe
	qwafGNlF8kQs1Ulr6nLQJIdXtUWhMuy1X6jqjfRW40b0TbtjSTA+UmQ+YjHevkaKxlgYPE
	jTSPN0zEpxKkgORDqV68+38DZiGwWv8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gryoVr3u;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdJmti4wVkf/3TGhFwMCUFJImTJ1GZ8o71ayzmFONv4=;
	b=CRo7qUhJogsBRTTHX/stfaZtP6pMoRQEjQqifGs+RjvQmSSoOTQrTtyFBDO1uTXuI8CaWd
	8bCtdtendgCwZcR3QWugg7kOGqBUqy3NvGUFsNbgiEfmJG8jgaiIwfGo1sKWGPEXmVxtir
	kxmNmPIqVfPdWl3YDO0TjGYrmjvDSf0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11C4743454;
	Tue,  4 Aug 2026 19:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346101F000E9;
	Tue,  4 Aug 2026 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785871577;
	bh=VdJmti4wVkf/3TGhFwMCUFJImTJ1GZ8o71ayzmFONv4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gryoVr3uqUvPBfWyH1Iv27KhOQyNxNNN4NCtw5V0qWGkoSNqe7m15N2vC6lm82AOk
	 LAItVjjQIG+cQGKiBSvhfyBgfGrNOhR+m3zlJgkABqJHuE9ZnYjzK4KfQqvFVNyvEh
	 LyR5BdvlhJg1a0CZNb9VNWK6RcVaV0+jaSrdDFng=
Date: Tue, 4 Aug 2026 12:26:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
 nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
 hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v5 0/3] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-Id: <20260804122616.46369067579b2bf7d678c03f@linux-foundation.org>
In-Reply-To: <20260727162550.2032-1-usama.arif@linux.dev>
References: <20260727162550.2032-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 38DFF140012
X-Stat-Signature: rycm9gy1wg7tbahy4mapwucfubzauycd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785871579-326361
X-HE-Meta: U2FsdGVkX19WpLIfTkCwrPqgV7WA+OCFqI6aMPkkDi1KYm2WhrXa5PVtZxSTWJM7y5mvtNVHM3Yc1Oivk2hnt5gi+PAafCVGHEO+VjOerEnrMY39++R2x54kF2I6loGvf4iHjPWyFvMG37POrQjtVsD8XyzE+mYR4ZPEbDiQ+C4MBW4fV2MzSOPYBpEOqvkxsz4ahimO2aa13Ebfu579oazSERHQefqdav0QeKHFes9I3vTQI5x1IcdIJmZuLa9OaEjzzRwNo6bH/VuXs6tpWNwah9mIqiioUxTCRkRJ6kOaeo0HsJD4CKRLRlNO0PG8z0nXrMNyXirtOmwVBHERVazZLvTXH3BvMNtylK46swDl2JfkyVepfKdQr+dC2EvZ6zaZRoZ2IXLpxjBtPJIRiXZgFT0orEQ0nvrOxNfRLCjqSPOo3UZKeFD10a3YvgAeYv7/Yo2g9UcMe4QNy0PYnRJT+CA07aPtSgQRjAXi/hWXcfjmqwfh8iYkbpMnPMqnaAe5udI6/CzgttjmquoId83hDQlpVuJzkvow6fsmDPaATWoQhhfy3mVa7P36+IwItYs1uyVbcN8ELQaW1i5KvCz8nW6+hrUxCxSI5t1uIdWt0M2KBaihnUTWwKYIjzY0j82KQ1PkVrwVRZvNLjEM+X2Xaa2PhC9jgCNxSHIbODTpy5MIP6IfoygTHSy84vv2zRu6MXdWAblwT0Rqnw7BSX4Wc0Ts8+Ztax/XRJwSC2khEBvwNxLmuBn1N9yEPULWT5V9eOZ4F18sW6tPiUYkZTjwNxc41iOLZA14VPhkwhAciMithmIoDxXLE8Mwzjtti3D8qj+6lEgB+BJMgS0yuT4pYoRnb/9auRqwVBJnaah1uXrR1IlyO3orAUIInapwP5HVjbNS9oNUCjkN803948AEY+6rTsr2FqYThxaVjXDGVd2UAni/Zk57deF4ZeAyt5TEnxtyhwHK1WwJ3sZ
 ZRKOwvQU
 mJXb8SBDwS9W1Y5d4GGvSKRvFE/bL/64vXtMcVHPK5UhPxplvvD6mFgzmIRRp8fvew9WsBN870ySL9TE2OLetIigv1ueffn6fVaJPBVbwQzrLFMDpR4Blh10C2kZWCp1g4q+Fd5ybqlK0t9hgXSo+TcLabZ8lofpmVcZiEewhIR6MxET37zPVm7uBpHrL4TRzNmjmpsoNo8LUtDKlrpJmc7KkEBF9vHh+8fTGIUUdpwXhd9IPGuqusAjxhyc15o1sAi9JpRtPOdHS7t6ZgmyAsUe5CXleD6dKqL4UyKDWA4VyKyhiNKt87z8ZrJJzLj3VmrfN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 09:23:22 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> The actual code between v4 and v5 is the same. The last patch is
> now split into 2 commits and the commit messages are shorter and
> cleaner.

Yup.  A comment was altered.

Thanks, I updated mm.git's mm-unstable branch to this version.

> v4 -> v5: https://lore.kernel.org/all/20260720164207.450685-1-usama.arif@linux.dev/
> - Cleaner and shorter commit message (Johannes and Shakeel)
> - Split PGROTATE_{ANON,FILE} definitions and producer accounting into
>   a standalone patch, and document their public diagnostic value (Shakeel)

Here's how 5 altered mm.git:

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~b
+++ a/mm/memcontrol.c
@@ -526,9 +526,9 @@ unsigned long lruvec_page_state(struct l
  * Do NOT use for non-monotonic page-count reads where a transient negative
  * reading from per-CPU delta skew must present as zero.
  *
- * XXX: This helper (and its node/global peers) exists because we place
- * monotonically-incremented event counters (NR_VMSCAN_WRITE and PGROTATE_*)
- * into enum node_stat_item.
+ * XXX: This helper (and its node/global peers) exists because some
+ * monotonically-incremented event counters are stored in
+ * enum node_stat_item.
  */
 unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
 					  enum node_stat_item idx)
_


