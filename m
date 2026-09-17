Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9275DC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 22:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5638A6B008A; Thu, 17 Sep 2026 18:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514346B008C; Thu, 17 Sep 2026 18:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A166B0092; Thu, 17 Sep 2026 18:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE286B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:53:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BCBE120445
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:53:10 +0000 (UTC)
X-FDA: 85224756540.03.1CC1827
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5D544160006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:53:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=blq+sEHg;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789685588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2lwDIWkeFYzgSRZvfTcjiNWTjkHsJ7RpCepH/lAHRg=;
	b=blTLZyTiSOPTgV+6iBeBPqa6TLQK4wrJbFBwxfIkNfLuswvxof9qrSsvq1E6kjJUraLBPa
	T1TzDtFxhhBS/oVUceGPik9sx79NHtz0G0ACYf7jNvVxAFULeMYH1yIDZYDKh61bdZkBPt
	VGqlupgNhjZ4Ua3t4hHHxp8IM0+mOxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789685588;
	b=v4OdJZIMabsKyCSOwU8N790sPJpSPsDw9Dq0DJQkoiYORohKR1IsgSFqwPn7WBmQw5l4Vn
	qKWYBmdhK1vEAasDdV4vKHpbWpiE1OsWbrXT1L721EqMZIZPjiIYtz7z7zGh05ot6gaBL6
	MWS6Z4X2FozZ7iKW8BMkISR5YfsHy/c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=blq+sEHg;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A75D941170;
	Thu, 17 Sep 2026 22:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6E31F000FF;
	Thu, 17 Sep 2026 22:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789685586;
	bh=n2lwDIWkeFYzgSRZvfTcjiNWTjkHsJ7RpCepH/lAHRg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=blq+sEHgAElfZA9X3EQAQ9ZlGWOeuUx/GzEM8ysiMT6PGSSN07TMYIUM0AQuu+85M
	 Lbr7rsJgDCLbt6HZBoFrM/VEATI9bQod/jZ7pNVEz9OVVC5uqFdOAIkd0wCppxYIAL
	 /zVK/kE+enmxOObLdnKnC74anYPnIsFBrd46+hQk=
Date: Thu, 17 Sep 2026 15:53:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
 jack@suse.cz, tj@kernel.org
Subject: Re: [PATCH v6 0/3] memcg,writeback: flush foreign bdev mappings
 separately
Message-Id: <20260917155305.7a63e01ba3ed34ed0aea537f@linux-foundation.org>
In-Reply-To: <20260917065759.2643940-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wp8fqw8fjjy3u3435rgrb5ut77kjodq3
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D544160006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789685588-213772
X-HE-Meta: U2FsdGVkX1/GqI0HXJVjZ/48mkoEIgGpXLAHb4J08dfF10xnNMkeK5HBykh9WK5pdYcJLp7kSYO0IwMOzeupA4fkX+2nMGKtmJMGRIcbKiTJ9dd8F31wdsaB9jF6cZI6fBroir/rztUB1sNe9FjHK/NQjRt/svc+35y3ApmwXYtnVU8YqRjmB6NCxVMCb5nYdj+havRTE9rET7RJHhXtzaJ2hxDk3qiqKskPGsVMLBjWgP6YRKE1CzrU1fQfZoXEN6CKj8eStfYw4R3/TGqUIj8W2+Cn3hfnvXYgvHSb3BWay0yLxtfKPNIQj5nqSeL7KA92gnDFOjMNlf3Z9yeSnttT3g7vQCf1HgkEieDHikSqQyJ0NueUoiW0bpoaRpldVlzgDw7rdWManx/HUtXHRLtiybcYoiRPokAyGN8rqRUHDKlfvWcGOZxOTaLUdOuTatVsvae9xRww2b2O054f4DpeShoQK/fOBWCBGWDsNqMIIzcBtOcR7cK52WyqXHLZgi0sqizvQ7UD+AT8UCbHnvUFCi7ZqxCtlVL0F6+D8zNmjO5Oig7jm6DTybYjZLLnMFiIJGDF+G8xyUPYQsEDzepGSA7P5pSZ28wkkmyvpbDlRHb4aiwjkizfTAyD444+L5RCpnNu4OsnCN+OnTl+qGwWnmd1Bzg6Xxr6k2Q7/bPvdDvdR4RDwOvfA6VC+20VUPBtEcSmQTuCyf2vLQ6weeibeFdVsCYLk+ioK5HNOush0/q2Hxkd3Yfivgz3ZhmEuh3TnNhhD5OpAk1xTb/Ro+C8MJLduw7flJYYmUPvfUxnxJ8wGeQkfB7ZxM0AT3kfJtV2pXygQV3PYraIn0fNowDZ3EzK6+VgdtPoAWCKiHJvSXnhue39UIFEJThxqCK2ZEuz9fF6hF1qLLMkwB3cVjSerNRJHqq+01iNoLcfTdbIsD7fnnak6QgP9sFMUIfT3BE/fri0H+U1oA0xn7z
 TKHc39FO
 oa5RHhQvVsJxDziJr85LTaIC92esClOsUmjSulHl9B7iM+o+Q/yC/TY86CE/+an5jNRZyb+vU+V2vXARRE8S3/YS75qYuCS08CAHFNe6/G8doseQYA1VWFgQn7XX45ABTMgQPgtrlSD+2msDpHJAC6HAnozkiQJ8fSKVPoillGmNlMdOCnLJvcRJgp5yrcxy1y7epZkjNvckp9mOv55gWwf47W8ttiEPx1L10fVyKdm0otJmpZaba70IfKzCTyA8i+kxLE2pSCJlg0dAPCkmiSlbf8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 14:57:56 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> Hi,
> 
> This series avoids owner-wide foreign writeback triggered by dirtying
> shared bdev inodes. Instead, it tracks bdev targets separately and
> schedules writeback of their mappings.
> 
> Problem
> =======
> 
> Bdev inodes are commonly shared by many memcgs. Dirtying their pages
> can cause the owner wb to be tracked as foreign, triggering writeback
> of the entire wb rather than just the bdev mapping.
> 
> In production, almost all the foreign dirtying we traced came from bdev
> inodes. Across our observations, a bdev mapping had as little as about
> 10 MiB of dirty pages, yet foreign flushes targeted the entire owner
> wb. On one machine, we observed 599 such works queued on one wb, with
> an average request budget of about 43 GiB per work.
> 
> Measured impact
> ===============
> 
> The synthetic test used a VM with 4 vCPUs, 8 GiB RAM, ext4 and cgroup
> v2, with device write bandwidth capped at 200 MiB/s. Background fio
> repeatedly overwrote a 256 MiB file using buffered I/O, while
> foreground fio performed sequential direct writes. Four memcgs
> generated metadata and buffered writes to trigger foreign flushes.
> 
> We measured completed block writes to the background fio file,
> including final sync, and foreground fio bandwidth, latency and
> completion time.
> 
> Across three runs per kernel, mean background file write I/O decreased
> by 72.7%, foreground bandwidth increased by 23.0%, and completion time
> decreased by 18.8%.
> 
> Metric                         Baseline    Patched     Change
> Background file write I/O (GiB)    6.154      1.680     -72.7%
> Foreground bandwidth (MiB/s)      150.29     184.81     +23.0%
> Foreground completion time (s)   109.203     88.652     -18.8%
> Foreground mean latency (ms)      212.84     172.74     -18.8%

Thanks.

As I understand it, this is basically ext4-specific.

I don't think btrfs or xfs mess with the bdev address_space at all? 
But google tells me that "roughly 70% to 80% of all Linux machines use
ext4 as their primary or root file system", so there is that.

> Approach
> ========
> 
> Following Jan's suggestion, this series records foreign bdev targets
> separately and flushes their mappings instead of their owner wbs. This
> preserves a way for dirty throttling to initiate bdev writeback while
> avoiding owner-wide writeback triggered by these records. The existing
> foreign-wb mechanism remains unchanged for other inodes.
> 
> Tracking is best effort: each memcg keeps a bounded set of device
> numbers without persistent device or inode references. Closed devices
> and devices with a busy open_mutex are skipped. Device removal and
> device-number reuse may race with lookup.

This part looks plain nasty.  Why are we messing with dev_t's and
risking these races?

At the very least, this description should explain the reasoning behind
this decision at some length.

Surely it's cleaner and safer to grab a ref on something (the bdev
inode?) and hang onto that object.  Use it for these operations, let it
go at the appropriate time.  Clearly there's something wrong with that
approach, but what?

> Flushes run asynchronously on a dedicated workqueue to isolate these
> frequently triggered tasks from existing workqueue users. If workqueue
> allocation fails, the existing foreign-wb mechanism remains in use.

Unclear what this means.  If a kmalloc/etc fails then we fall back to
the current (mainline) behavior?  Fair enough, failure of small
kmallocs are so rare.  The main problem is testing the failure-path
code!


Also, and most importantly, what the heck is "frn"?  Would the world
end if you did s/frn/foreign/g?


