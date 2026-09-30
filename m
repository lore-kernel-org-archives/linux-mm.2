Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62521CA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 23:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC236B008C; Wed, 30 Sep 2026 19:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EF26B0092; Wed, 30 Sep 2026 19:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A7A6B0093; Wed, 30 Sep 2026 19:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E244A6B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:46:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71AB7A55F1
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 23:46:35 +0000 (UTC)
X-FDA: 85272065550.21.245D0C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9F8FF1C0006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 23:46:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dCl3evOG;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790811993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhQGe+RD+fiFkRmm1C/pXVjw/6OQ02jTbbVvy16bHsU=;
	b=moD5qAKG01z1gO/ylgOp1DsW5r7dKz5kGbY64Hi7J5eyt8EeODCCA5WqqS+56H3tmDLt6C
	2TBmcEJ9w7xB/xNmlm7thwuP6Mouv7RzTRomVu8k40YvTPKbAPddxW5xhH1WC0YEsh+x16
	GKNwTom1rhXp96MGx6IOoOHUKLySvec=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dCl3evOG;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790811993;
	b=wjcJVL/TegpUoG/pAMWnkraobtzkPz4iqNJNSyzc+TGrFPLrsfsLTPxnAWO4XysaFPsl/d
	CNDKzkm3KjVvuhYR8/wEsxESBnP84yu6HDdXsihRbZ2ML2Pd8RQGlzj0oaDGYfN4R7TsiQ
	duVwF6kdZrfXrY3oqvYp8Nh4DPCP0OM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD1FE601FF;
	Wed, 30 Sep 2026 23:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7AA1F000FF;
	Wed, 30 Sep 2026 23:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790811992;
	bh=DhQGe+RD+fiFkRmm1C/pXVjw/6OQ02jTbbVvy16bHsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dCl3evOGSEmQqqbpP8nVEYUZD57g8vXRpyjRb742VDor14VGCaX3XxbgTizPHqgeU
	 9S4l6sLZSg6Rqqf7bz867wLT9RqO6NUwsgwIBbrxSm7ve0Gex1suI4GVzThhE1wUD+
	 fnrAhjq9ziMf6pPpkWADQ0xTF3JfRCjS7wvJwoQU=
Date: Wed, 30 Sep 2026 16:46:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Down <chris@chrisdown.name>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Ying Huang
 <huang.ying.caritas@gmail.com>, Kelley Nielsen <kelleynnn@gmail.com>,
 Vineeth Pillai <vineeth@bitbyteword.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, "Rafael J. Wysocki"
 <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] mm: Make swapoff interruptible when unusing mms/shmem
Message-Id: <20260930164631.0468fb0caa7e47f60c9a1a9d@linux-foundation.org>
In-Reply-To: <ar2YlFYjYUZ49ZA5@chrisdown.name>
References: <ar2YlFYjYUZ49ZA5@chrisdown.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tbmob3pkzh73yxx3w5p1ffsccnapgsk8
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F8FF1C0006
X-HE-Tag: 1790811993-859734
X-HE-Meta: U2FsdGVkX1+UEdqM+s61+2e/wbhAY9P5Nx6+FYR1qKjafJ/RskYT33eUImXSHFKgDL9s8/RV7qxxMOHGJP+bcKwqmX2wYoQM5VNm2GC6+lMj1fDklDXN8/M6oum5FL+TLTX2D0KKoKthTtDDZfC7EBy1YGw13RdIGdukG57hx1r1oETEXdmJZ0z2/bbYPOH1mykqK5nQZmNavWzmI1hk2QULKhyT4Z5Qqw02yTasMNahuKdYBgy4NgQFrkL+x65yg7yP1504sAA/Cgbi90PFoPPXI9RAV5zWn4hgaJ6fSGQIZnIXNSvTHvnhDqPfhObGf2Of8tLpuOj+QwwiwJiaf9BeoZi9S3CavhFUDqnkD33OZXeZhCDGbqmg5yT2l5NxfXxL5NcWCqjVNQP4undcmjQrMaVpmarafR6PT6nMAqlvdkZBwpZIPyf1ZwPzO9y4bdALF+LC5yKNgtneZyOCrGukbSfatCeHKp5enxvfahSWVhP2A77QBedshg3Lp1uGNoiTCFiv68ElbQYsqmFNk1tc1fgNILiSrCEmY62wJ/+boaiaCSiMX6bJZL4/apHJPs5WqTJkvPe2Y3vHtois8vEgpGfJZfkdPsRrkscc7DMf66QQyL96adwcGZoTtxY3vZ4ABHmg5f3ewiR1PmLK9ko4We4AfkeDMA3DJ38SZ5hM/lM8uXEDve3Va28jQh2ezHkM7odWjTURmwKX2MzLQEqcEWzT6RtAeKiesFd2OYnvNpLahN/g0YnEzPpeqSek823EZm3j7jG1SXY02xs/2eNvOnVfF/DKowEOsy2Kfrqlr26+QxxGJmlcfSomwwyLhTXzIk05n0Hdmlzkc/uSUdSeEHVc4KjhmdGpzFF4QGT9rdmZ5bgpxA8hLHUPJ/cOMGBgXyQHeMat/bSA5lWZHmITQuMJ8pcFE5ZIWn9f7kHDOvgpKp16uxBgwM6Yt/mqcsgCUT+ycojrbaXXTVL
 poIAmlIy
 SE+1qHHV0vLV1qv5F2uhGEErHqhridMRRYuJIlvS4k+3GZ1B3yBGmFWPyNM11jX4GzUB4rGVnP4LRRcLBgkL10OMbkXpI2e9rmP/zl6JIhQAKCM8bDDCkTbnulCRbUqJ6X2ePkWtZUNyOZBrsD3G9ieveaP/McEVLjONPQAcamCOHado6Ao3kKkewRo7k/ldEWJJTcWjpnIVNkYPEeoy+BfBb5cYaAzPryERW+erODnJV3tQUBXdUCPxlscXrXLuZxkeSu3ttbG9kgYCXa8+l36W0jQ2GOFoKNJMZXOJWjSn7YR6ehTh8gziHZfmH3+w9fMd+0WLZ7pOU+P0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Oct 2026 01:17:40 +0200 Chris Down <chris@chrisdown.name> wrote:

> try_to_unuse() only checks for a pending signal between mms, and
> shmem_unuse() doesn't check at all. That means that once swapoff gets to
> a process or a shmem file with a lot swapped out, nothing can interrupt
> it until every last page of it has been read back in.
> 
> Just as one example of where this can concretely show up, freezing tasks
> for suspend or hibernation has to wait for swapoff to notice the
> freezer's fake signal, and gives up after freeze_timeout_msecs (20
> seconds by default).

(cc Rafael)

> Here's a facetious example where one swaps out 2GiB of one process to a
> swap file on ext4, starts swapoff, and half a second later tries to
> freeze with pm_test=freezer. Writing to /sys/power/state then fails with
> EBUSY and this in dmesg:
> 
>     Freezing user space processes failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
>     task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:2955   task_flags:0x400100 flags:0x00000419
>     Call trace:
>      [...]
>      io_schedule+0x44/0x70
>      folio_wait_bit_common+0x1ec/0x3d0
>      __folio_lock+0x24/0x40
>      unuse_pte_range+0x2d0/0x348
>      unuse_vma+0x158/0x248
>      unuse_mm+0xfc/0x150
>      try_to_unuse+0x104/0x3f8
>      __do_sys_swapoff+0x220/0x5d8
>      [...]

ugh.

> The same goes for anything else that wants swapoff to stop, like an
> admin hitting ^C in a panic, of course.
> 
> Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
> try_to_unuse() was driven by find_next_to_unuse() which checks for a
> signal before every entry, so let's restore that behaviour.

So things were all good before that change?

> Just as an example of the improvements, here's how long freezing takes
> in the same test while swapoff is happening on my computer:
> 
>                       before                  after
>     400MiB anon       8.925s                  0.028s
>     400MiB shmem      1.639s                  0.003s
>     2GiB anon         failed after 20.003s    0.011s
> 
> Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
> Signed-off-by: Chris Down <chris@chrisdown.name>

This sounds like a significant usability regression.  Should we
backport this?

otoh, it's been this way since 2019, so presumably nobody cares much?

