Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A8D6CAC59F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 22:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6768E0087; Wed, 17 Sep 2025 18:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DE78E006B; Wed, 17 Sep 2025 18:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA7C8E0087; Wed, 17 Sep 2025 18:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7AB28E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:22:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47976C06A1
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:22:00 +0000 (UTC)
X-FDA: 83900166000.04.680A90B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 816C840002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:21:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oReXAf6E;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758147718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDBgDrq/ZdlJVCNF4nW1jMUOWPiNkvEIGqsYFzgifCs=;
	b=WYklgH79Ihp+FpIdg4YIe4JXPxbfW+9FdhlijQHKmW5+e6eFwwvDLr7VfCHsvKu64QU2yH
	tmutYKezHcH1x2aE3KxZd9b8FKkU1bzCGzFr/zklWWTVqf5QdXBuPLorWCGZ70aXbC84+7
	nVOZFtYpPX3/g/N4HKklm9URUSY0pzw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758147718; a=rsa-sha256;
	cv=none;
	b=4eTZU0W/COhjPgallwPMAUKUz1qwrjK4Sngz/jEPi+iK0siI4VuIf2o1IxIjDGsbJ32jv7
	PbKb50RygpHM9yhP9ystQeftisDlx4oAMWsxAzzVhIHKV3ubKJ68np5pjoRpv9GAkhyZwC
	Aq5YnrCfC5z4jnGT72xqrE3ak8M1c9o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oReXAf6E;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 359D7406A0;
	Wed, 17 Sep 2025 22:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C461C4CEE7;
	Wed, 17 Sep 2025 22:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758147717;
	bh=d/I3F+SuENOGih+oN2UVEhi35uxE/59IR/7jTobGBAo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oReXAf6EmxNcQZWKaO7t+7pSa5yMM6yptNscf4mqfORdLrgSUCzidDzZDoR3ky8k5
	 N2PIHnKVw/AQONA3R4TF56W77cO4xyJFsi/i9DsQVMqM8YOwWvQs9ixvxNuey3WrSA
	 fwIuB3wx9d9gaza+5Ag52wG4vAP30CwSbBNYIt4s=
Date: Wed, 17 Sep 2025 15:21:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
 tj@kernel.org, muchun.song@linux.dev, venkat88@linux.ibm.com,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu
 <mhiramat@kernel.org>
Subject: Re: [PATCH v6] memcg: Don't wait writeback completion when release
 memcg.
Message-Id: <20250917152155.5a8ddb3e4ff813289ea0b4c9@linux-foundation.org>
In-Reply-To: <20250917212959.355656-1-sunjunchao@bytedance.com>
References: <20250917212959.355656-1-sunjunchao@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hb9yxchnehs586pm4yiyrdm6ci3wf4r8
X-Rspamd-Queue-Id: 816C840002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758147718-43883
X-HE-Meta: U2FsdGVkX182jczuinYB2Vfc2vtrgjM2JcqXPts3xgz4+d6SOMuMUVNe8fKhAGtL4kOPdOdEyTbyhdeAhw2gHRVsgdYeb/uEL5hpk9TOC/mvMAOnMDB4NbYrX2/Nyuc9znOKd4KS7rOxHMw3lNE7qPEQQ1kgbBwIYx+3BCbIXCp1RTXRANHTTNxdqojOONJPe8ZPUmePhllYmhKbsiixVpFUWclDyG17gN9Y2tAgdZ+ck2DOH6yjfJ9Sbi2N59vvY7sFe5AIfWcc3AEBC3asKTVzrIyxQgStZ5ztL5CuieDVTlnDovGWmwKo+ey8N81GGN2t4q+dp0DAvDIhZVdQun2CZ7R1m/iOQRKfmwIcjHLFNyScL8a2mIErM2BDwbbCspw11M7cOXwiDvfpV/5bn09Lbjq5al5pJ8suN+MXf5wIA9rkiH/n9un6nE2rVKKzmkeLAOl4wW0rPjWM25ztWJmOe39e4hRpvVfcv+0+4KT0mSe55Fgxz8z+yfnYiP+Wxqp8EWZ/FsvvycovZO+og67jQpHta0Hm70B83JwFsB5hnEnGvPSBVAZvTp8yqiz5f8aacEEc/xCumZnLuyQpe+9n2x59EIOSpR3b2Ll+rK7CFp7G9kIrSM5K/gtW66VMUAWhN8VHqRPVYwXpZD9u+xnR1ycVG0mnUmTKPC6CocUjH/JpJne9y7oHVY5y/aJVOeNY47ZAAIi40ctg63qNdzFjaLLNyyHlWfxfeMoK0udTlcVrLX7RPwpPRwpry0D/QDyPInLdapfX+18bJCatpzIwwDvKjSa9fL2pbd6tqo3suwIXviPf/rjSBpI49CpZf6Hm1vJ7WRws+QBExkZqS6ZvUqcET4dVQkPVujkmkgc8aVDhDTyh3DijOeLm5Iws+yMGvvYOQbYERTQg9ppGk4t0jyx4fR6EBAtF54e050bF28/wRX9oD2HIne35PUPHeuHMGNNJHTiikIE0mds
 0CvEs7Mv
 kUA/62fkTwvtM3xS5udRtHBAtTfFaEC0dlhkTrdX3MNw6fg1Nrci27qmU72X/cNNd+kZPycd13ssrhcNGFHIfYN4QtHxAb4VqwsMzLsYD/Dao3GzWHB4xmLNUJybBr0C9T+ewLFUH8vUIgW2YXoXVIj9UAsE1XjXvpm8/3kJzqET3m+mg46whWU0Lckgo1jUbsnZiFZmLwX0EY8Xp2c2O14XUhk2R2dRZqov6n5Wfhc/CTnl0nN7qc2tC3mfOCEKmCDUPF61nLOXwetuCi5IeluuuiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 05:29:59 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> Recently, we encountered the following hung task:
> 
> INFO: task kworker/4:1:1334558 blocked for more than 1720 seconds.
> [Wed Jul 30 17:47:45 2025] Workqueue: cgroup_destroy css_free_rwork_fn
>
> ...
> 
> The direct cause is that memcg spends a long time waiting for dirty page
> writeback of foreign memcgs during release.
> 
> The root causes are:
>     a. The wb may have multiple writeback tasks, containing millions
>        of dirty pages, as shown below:
> 
> >>> for work in list_for_each_entry("struct wb_writeback_work", \
> 				    wb.work_list.address_of_(), "list"):
> ...     print(work.nr_pages, work.reason, hex(work))
> ...
> 900628  WB_REASON_FOREIGN_FLUSH 0xffff969e8d956b40
> 1116521 WB_REASON_FOREIGN_FLUSH 0xffff9698332a9540
>
> ...
>

I don't think it's particularly harmful that a dedicated worker thread
has to wait for a long time in this fashion.  It doesn't have anything
else to do (does it?) and a blocked kernel thread is cheap.

> 3085016 WB_REASON_FOREIGN_FLUSH 0xffff969f0455e000
> 3035712 WB_REASON_FOREIGN_FLUSH 0xffff969d9bbf4b00
> 
>     b. The writeback might severely throttled by wbt, with a speed
>        possibly less than 100kb/s, leading to a very long writeback time.
>
> ...
> 
>  include/linux/memcontrol.h | 14 +++++++++-
>  mm/memcontrol.c            | 57 ++++++++++++++++++++++++++++++++------
>  2 files changed, 62 insertions(+), 9 deletions(-)

Seems we're adding a bunch of tricky code to fix a non-problem which
the hung-task detector undesirably reports.

Would a better fix be to simply suppress the warning?

I don't think we presently have a touch_hung_task_detector() (do we?)
but it's presumably pretty simple.  And maybe
touch_softlockup_watchdog) should be taught to call that
touch_hung_task_dectector().

Another approach might be to set some flag in the task_struct
instructing the hung task detector to ignore this thread.



