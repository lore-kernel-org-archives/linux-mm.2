Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064F6CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB708E0034; Tue, 19 Aug 2025 11:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C638E0005; Tue, 19 Aug 2025 11:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892428E0034; Tue, 19 Aug 2025 11:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7061C8E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:54:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F6AA160115
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:54:16 +0000 (UTC)
X-FDA: 83793953712.20.D634674
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 88E574000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:54:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WuER1DPL;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755618854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PG0zliYVlI6AQ64N2YXt0bgLSgwMGhnFEXp7yOr1q0=;
	b=2Fyvfk3fIDVmVI4WAt/auFZQ1gHqj4URQSFiuLnppe2G3ACA7eFnaN/U3IvzoVQjprhZp9
	q5XwbvEU+n+WyBLF9NXS3k6FuZXrF8AYusRNcJk4t8idD6V8dYegRnIFYPQPtvYqfBMT57
	uKn9vZ6evUNlWRKOhVRegDvxgggsY0c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WuER1DPL;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755618854; a=rsa-sha256;
	cv=none;
	b=2D/kSG4l+QbnIx/Nok+pxvIJRPF6Ba3tgel0BVQjDdf8fm7k6yv0kmr/8fyYqotrXXyL6/
	2I+5AH/phC3LZGP/lwfXtesP69c1QefGxeD1ixUOlqWZV2tN24Hhng5+VfCrjWIGNjEvy4
	HtEmpOVDhqIVTDhU5tDnbpgDsrfqPS8=
Date: Tue, 19 Aug 2025 08:53:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755618852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PG0zliYVlI6AQ64N2YXt0bgLSgwMGhnFEXp7yOr1q0=;
	b=WuER1DPLc5dv9K+FyrJfrMwpUJJ39XGue0LfyIYiP9IkGL50Xa4nQWocAMWSUEyJ4XnJSX
	qr+xmCcAi3gf6D6p302Om9D+BIds+i+at2NEgww8owRtPX5TNtYzsfg/6QB1zdez08VD5c
	UcIL6KrKDkNBEfiDIVIIIvIrCtb9tJs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Boris Burkov <boris@bur.io>, akpm@linux-foundation.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@fb.com, wqu@suse.com, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 2/4] mm: add vmstat for cgroup uncharged pages
Message-ID: <tw5qydmgv35v63lhqgl7zbjmgwxm2cujqdjq3deicdz2k26ymh@mnxhz43e6jwl>
References: <cover.1755562487.git.boris@bur.io>
 <04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io>
 <aKPmiWAwDPNdNBUA@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKPmiWAwDPNdNBUA@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 88E574000F
X-Stat-Signature: 9ccgo951msb1y4krreenohpha9zfteaj
X-Rspam-User: 
X-HE-Tag: 1755618854-506208
X-HE-Meta: U2FsdGVkX19k9UldAhQ35+18S7rR+/EGpYTuftP7BujIyTFjecaGbS8htQXZ6aDfpAvDr0meG9fOaVE9T8s625g2E852Z6o9206pZQQ9GfArXnA8dSkcZEkwsShHl6Jd4olPxSOwrNfO1E3xtAitIuuNRkIrrIaBsFBpR7UDpRNGKZE4blN10Sa/1EH+AZRaVhGlWDkVECT6ZtyTmf7mu/BilXIOnPusSIOi86yzHwrRw+YELBm8Lp08XhH6ikjvwCHXp/21PipO3FUDggWVjdoKzmzO5GwwfBXM6eJhChijKa9T+t0B+xCZ01jMwkildKw8wt//PUj+xSYyxfEBa2e5tUQ8QK0V26HXbrGJM99u9EKLqBkQBdQKts2eKUokvt7lh3Oz3LODrVasAhRKRBBkQ8LUVBG3+96JCAEYPEdyEWbYidaTH82RHEJVQOL+F2+cIGQeCzSB9zzIlQ+SaH4TTKz9Sw/Wd0sZh67FOedmCmHDBVkuTAiGpAfXDFK1r0KQqRbY3ynUZHdao/cvE+ESxsHaSxbtrcoMlRkXwud2ZEKY05ex6UysqDit8tq/nSTU4dpk0AbBUNz+jsJDMipHzCyo8i0mtwQcCL9qfoWFemkLfy3VXAizYUHIDNWOYUAGIyu+X+CcDNcIIIIaaDOOGyW9C+lrnadoMFIAQR9YW+QEQNjS/Kw6qyfqYjwkNgPQ5tmovl36J1be6FGxFkGMZM8WGHj5UKMdcByn7PypiNNlvhUZdpObzFURm+0ooNFuon3OHWu/e85iJ3t+5OuCpZZYWqnux0v1yRJVmwb7tSr/Wm78UVdWy9ioR0pNg/MzkOze0g/Bc/osiymDtkbmCthjGK9zAY4dLSk08+6SJe5vHFQYRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 03:50:49AM +0100, Matthew Wilcox wrote:
> On Mon, Aug 18, 2025 at 05:36:54PM -0700, Boris Burkov wrote:
> > Uncharged pages are tricky to track by their essential "uncharged"
> > nature. To maintain good accounting, introduce a vmstat counter tracking
> > all uncharged pages. Since this is only meaningful when cgroups are
> > configured, only expose the counter when CONFIG_MEMCG is set.
> 
> I don't understand why this is needed.  Maybe Shakeel had better
> reasoning that wasn't captured in the commit message.
> 
> If they're unaccounted, then you can get a good estimate of them
> just by subtracting the number of accounted pages from the number of
> file pages.  Sure there's a small race between the two numbers being
> updated, so you migth be off by a bit.

My initial thinking was based on Qu's original proposal which was using
root memcg where there will not be any difference between accounted
file pages and system wide file pages. However with Boris's change, we
can actually get the estimate, as you pointed out, by subtracting the
number of accounted file pages from system wide number of file pages.

However I still think we should keep this new metric because of
performance reason. To get accounted file pages, we need to read
memory.stat of the root memcg which can be very expensive. Basically it
may have to flush the rstat update trees on all the CPUs on the system.
Since this new metric will be used to calculate system overhead, the
high cost will limit how frequently a user can query the latest stat.

I do know there are use-cases where users want to query the system
overhead at high frequency. One such use-case is keeping a safe buffer
on a memory overcommitted system (Google does this and measure system
overhead every second).

