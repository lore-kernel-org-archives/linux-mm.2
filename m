Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8188AC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4B96B0088; Wed, 14 Oct 2026 15:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486456B008A; Wed, 14 Oct 2026 15:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374506B008C; Wed, 14 Oct 2026 15:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 131A36B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:05:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98C1A1607CA
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:05:42 +0000 (UTC)
X-FDA: 85322160924.19.225F219
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6752100003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:05:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2KwKket;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792004740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YyINmxXO7pd+spEYBHJ/vCjoSEPDem460Y+EQItZG60=;
	b=41WFwXVKWKXiaOl4rO3w5NA3X+oRxM/zppXgQvMexczhL+c+oT36NBcPlF8F8rYDu7tuZs
	9dzi9QQ1fwf7v69G21DHwM8xDmFKj28C0WmWgZ086nwrc1NlRt8dxbM6H2YkZwKyJpfVUR
	wqJegRHGqhvDpykreJBDjlmq5ocrhJc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2KwKket;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792004740;
	b=E0PxHF5lUteLtvbRGD//snyx9VcZEuyFiermDwRXzRTNWzS+O1lvi6UUb6aTfzRKVJaD0r
	+EYnDME77VSxtOjHFPWSgshE7dmt1ycW5w4GqMwjPJTLXg6yN5xkSpXjmkby/ulq+b8qEK
	uVrZ5DU1p1KAIXKUO+Gsa2ZV1ztdXAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 062B442E14;
	Wed, 14 Oct 2026 19:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FE81F000C4;
	Wed, 14 Oct 2026 19:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792004739;
	bh=YyINmxXO7pd+spEYBHJ/vCjoSEPDem460Y+EQItZG60=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T2KwKketgjd78ySIjWZfpm14SK8fmn/dOIHeg5mSexSu49wSiIFL09CZgoCSlNZmV
	 dRSwwOOBSwSht+owNr5w6EKvDRfvqfCX3RrdYlgV427de0Ct/6OnNgMEQGoNkZpZhS
	 XWq+FzHLiklU/hnG3eZKRkX5HJ1Wg8sf8lMbt9yEO3ukX4BwkRnmng/FuAXpg8ONTn
	 /dgm3svw5odmG9ltLLcFDAC/v5bC9DoVDcIRhA/kfudaDw4H/lRAY3xihqBbQM3khC
	 YVFb15bIeGtRCGC97m61q8Syu2fhAEPXlV/DeFwWk5ytvozOGNoeLdlAb74nxTwBBo
	 ROPpDl6OXoiWA==
Date: Wed, 14 Oct 2026 09:05:38 -1000
Message-ID: <0bc5d58533f10b4841807be3025daa11@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v6 3/3] writeback: switch a replaced cgwb's inodes to its successor
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-3-1991b4e2dcff@honeycomb.io>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
 <20261002-wb-dying-cgwb-flush-v6-3-1991b4e2dcff@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D6752100003
X-Rspam-User: 
X-Stat-Signature: h58ixizxjkwsrwbe4qjgxrohq54unhg3
X-HE-Tag: 1792004740-20535
X-HE-Meta: U2FsdGVkX1+q62BVaiYu8nvXL14l1VCaSWKxF9TQXkI0Dot2CGg8nDWXv46jQdRNEhpdVfH83EZelHJdN9i0+c1ZrCyAtp3QOZ/S0jysDx5BR2JOdDdqrECA+A1x1SjcdZ5ayTXqXbOu6faOSUOGQWv4EmDYoBNQ9mPF9t/+PGw9r2w6tVRTmCDbEAnxBrik9vsjMEYbyyaj0MB2Sp9ZC50c4VjsmQVV8gQWn02K+7t9LI5cJioyBFq0BsyT9HfW0b37lKgIzCrKgalePcKJBdHH1VA4vQ+neTG3T4ydUqsdnojVtt9sFTzFQTSjpRTI4IbFVtC/wD/c3jGywOEscXpz24TuP/zTNez6nZnj3otENPPcN/uJJWSffOGyrYeNMaBdZhFiCn4ZbiE6YPMwrp5Eq2zTag4a/g3TnyESADLeTDlZILRp0wqLoUrhmfaZYsYND/zWmIM4oO6BzTEkZ0F7fkfjsxyioCYrKhQo+o1kwt6NqSV05UXGAKg1nVNscPbk0het1NjYr6eIMac5l2ezIGt4YMB5XTnz5p4ovl98HoTkq8vttSUNND4SzxYJrAWE758fWa/c5qmKZjDhIhs7L4aw6izCk6PKbT7gnsF5mX8Cjz9I/Vaou3WeJsLbyTJfTSS/DZ9jv6wjiVJAVNeth2VNl4mtuKkOV61LqgJGBf07adQjszMCOYubb7ft9frtmWKjX+S7wGMh8siVJlbT8u6+cBCTQQHsQg3KyY6jwBuWuC3d+DUUEHmJnA3G/ZU1GW5p8yOunSXw/r4M4UIQ9x6RpTg7Mp3vWGOGHMaEfGjNfSmLNQemKez0J/eyZvParAyViMbQ09vUpNvgQSTyKn2ENb2BuAPXTRu6XQbQDYMbEbN2NA7i6fcIkOPDUyiuZiNWq25+rXuf6j4pu2yhhYjOu8cj8A1Rq4+EncZqMuCmQb8//Yiw3pNd29WvWHfMn5G0b6Q0uo+so+J
 wL8wV0iG
 LZpVdOoJuq0ng5mxjWXAfrsEk/HGtLMomXYKpuoaMfizDr3Oowny/oTOe314td88fChVIf1W2ULGMxCpWAlp/aZo9IW5QsyysOCpYv+PhP2s0XgNnSqd+N7k42iHFHTaoO9yl+g9wgPmc2ZPkyt0LvnCSBAdV40zs9o7tLsXvlF8KeK3irn2L3+Fh5cTcOpFMb7FNVOKqf6n2by3uEN6wVtqfTbJn2feUEmWfyLl6bntR2YR3kKrXjJH4im/W33K/lKci
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

The following is a Claude-generated review.

On Fri, Oct 02, 2026 at 09:40:48PM +0000, Liz Fong-Jones wrote:
> + * Switch all inodes attached to @wb, dirty or not, to the wb that foreign
> + * flushes now find for @wb's memcg.  If that one is already gone, fall back

The scan only reaches inodes on @wb's lists, so any inode attached to @wb
but on none of them stays behind, not just one from the
__inode_attach_wb() race. A clean inode switched over from the root wb,
which keeps clean inodes off its lists, is one example. Maybe say "all
inodes on @wb's lists" here and broaden that sentence in the description?

> +	spin_lock(&wb->list_lock);
> +	restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_attached, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_more_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time, &nr);
> +	spin_unlock(&wb->list_lock);

With f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by
rotating scanned inodes") on mainline, isw_prepare_wbs_switch() moves
every scanned inode to the newest end of the list, and wb_switch_rwsem
keeps switches from landing during a sync but doesn't cover this scan.
On b_dirty, that can make a sync miss data:

1. A background work on the replaced wb yields to a sync_inodes_sb()
   work and leaves inodes on b_io.

2. The sync work fixes dirtied_before at entry but doesn't queue_io()
   until b_io drains.

3. Meanwhile, the memcg dirties a clean inode, which goes to the head of
   b_dirty.

4. This scan fills an isw from the tail of b_dirty and moves those older
   inodes in front of the new one.

5. Their switches block on wb_switch_rwsem, which the sync holds for
   write.

6. queue_io() stops at the new inode, so the older ones, dirtied before
   the sync started, are still dirty when it returns.

Maybe hold wb_switch_rwsem for read across the scan?

> +/* called with cgwb_lock held, possibly with interrupts disabled */

cgwb_lock is always taken with irqs disabled and lockdep_assert_held()
already says the rest. Maybe drop the comment?

> + * cgwb_kick_replaced - switch inodes away from @wb again if it was replaced

This queues replaced_work rather than switching anything. Maybe "queue
@wb's replaced_work if @wb has been replaced"?

Thanks.

-- 
tejun

