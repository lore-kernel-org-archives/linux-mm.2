Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB9FD39421
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0286B0088; Thu,  2 Apr 2026 09:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438FE6B0089; Thu,  2 Apr 2026 09:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F666B008A; Thu,  2 Apr 2026 09:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 228C76B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:27:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B513BBA66D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:27:19 +0000 (UTC)
X-FDA: 84613692198.11.91D2F1F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id D69B780014
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:27:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=WQzXvC5U
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775136438; a=rsa-sha256;
	cv=none;
	b=6B3a+4XGkhapWND7t2mJWO5lAUZgpx9NglhA6CZ2640Hqkhr9AuBJs7OqJVu5k4tDLKVTt
	HBUHW/9wrmJlP/JMf3SkxY+kzfScX+Rnh+LiNaCKxyglVyLAY2VWwhGoTk0H2zwDHxQ9u1
	VMWjrJA3KX/Cp3YVx20bnP4f5rKrbeg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=WQzXvC5U;
	dmarc=none;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775136438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdzKOxQ14nFM98WmcIU2Nw6FkbUtmbmQLtarAg5LvJQ=;
	b=6Hf/uP2D+V1VpUtfwExrOUpTYKSUUaRik8GWvVLOvNa23uF7cCfCxK7na51IfnP7yGe1Xc
	/3yP9MknoqfwKcaND/MQoZfSz2YubysIG+wMVHreBYhxT7beal4uXeaF7pnUo3ceI/PrIE
	eUiB9uUoiH80DVOb7jDfKzqO4jxcAVY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AdzKOxQ14nFM98WmcIU2Nw6FkbUtmbmQLtarAg5LvJQ=; b=WQzXvC5U4kKkengYyoy3/e56db
	5XhOFTIn93mcIWLxbiaNfhlpaoA7/DfBvD3+dKxmQ2BeK0DJw1eGUesltdTYmVYVGBkM1ejORX0yt
	DFb829iyymGdDPX3kRQSVk0HTMmU6BDbQfHSsnP3L6C/fNxaNq08lHaxUG/ue5IJeQOTwqz1DvdF+
	xYCGlpd+Kbtu1Ihpq6bcErhETwebjuILwvFeFjW9GIRaNoaT0k6ieu85Lt9iiJ9v6ia+V8J/Ddk6b
	3iPVLnHCO5GCXe5lz3iQOjQKtn0rOCsg0/eRRmgBgbX0JRUlZ5Lf9AFoGDJfuZMhE/KVMyj+u2zXA
	Ls0veUbw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w8I4e-003nP9-0M;
	Thu, 02 Apr 2026 13:27:02 +0000
Date: Thu, 2 Apr 2026 06:26:56 -0700
From: Breno Leitao <leitao@debian.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac5trb9T6A8XLnOw@gmail.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <ac5l3myFf_dxtRji@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac5l3myFf_dxtRji@casper.infradead.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: D69B780014
X-Stat-Signature: t7w3c17agspiu7tw5k8gm1767yn9cmp3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775136437-589594
X-HE-Meta: U2FsdGVkX1+WDMmkJVV0eJKpYcuEAsdkzqtq+H+egfn2xW2QqImLR3Mk32mu9KAjcvRcgjjxMkgJ8/OJqh9E5Qjo9nw8UNUoY7hxori81iqeTKdWciwoe52qPlFA9mpNajhRtNpzgXAheSbqD6E4zlNMDBhF6tquIC1qW9pCfAUZ0HW01BAW9yRx9IvPCiQG8akS1gUeCzwh67x9sXOFahe+w2QbVhg/EjwdFrmuotoB2ejt+15ZCvbZKyi0tGAckax0JJy3tD+HOn9wEdm5oeA2mDBhP3nHzKHorN4BxmmHM7E5ZTfg0uCc8ln42ujv4FtKPlJwAxEjelsm9sZmAFvHNteS3L33imVSfEJRw7vGpawk0TQD3Gsen/9D/kVizBqvTcdxsWbvlSpmnOaXXbBu1CoONdTMGhdYvBqa+RDohjZyWC+nPIyvP5Cw9bTCvFiy2EkT8OpdDrKwbrpVLQGM3qTO4bwwjEtR/6SJv1uvsQD/NnsCwrA+hNRTmpTd7xROvi9YIeOse/WH4wP1WECssGUShimXZn3h9+DnoCgWCrpAdhEJf2XpFKSUde3lVK7jqAX8B+IeWhUZmTjFbGj9Q26VVU3CBcKye0X0wqSMVhFztvf16hG+Z4MYG4QUPXF66VaBvH9KGYiTz0oTwgHccibcjSnbnHb4wUBgJJSCnx5nSJXYSRj8fcXQ/Hdq+NcXq1d6tHdIJCuONo3IQT5ep0UZdXlymr1hYSBmi5flMtjo4vU4b/0d9FAZKQ8XwwMto34ZWvAJRkwBy3LBkQ5m3ZdgPdjIuoOB9U2zb0NahGzXCYNoJKbWM4ZRd3h9Pv/YpDsQqCOwTm8hJV5xUZgW4Ohv9gH/QtD9zK1aWCB6JQshRP6D5FpeThOCle+nEmn+u0k9Pzxqa5EbvzoRSfVmE0Z22OP/lucpwVaTZ6jLkOJzTKpzIZGINa4BeTtdBr78y48vgC1xhhh4YOz
 hPAkrnJD
 kk8i9fhQ9XKVtJ5r2k01o3ZSFB/4Y2BwFZ8GPo0ZnUD6YhLNUmkPqfENNx/41m5Y4zUg6XLx5vA4rbQW/i0FZmU/cRLw0vFwaWLDfnkBQM+VAQ2C0xyZLdFgQPulskyJ3SohAR9sxSAOopVSLRXP2mlajXAHE8VMsGq2fiEGKufEGTyWqQcFhzCXCDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Matthew,

On Thu, Apr 02, 2026 at 01:49:34PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 01, 2026 at 06:57:50AM -0700, Breno Leitao wrote:
> > vmstat_update uses round_jiffies_relative() when re-queuing itself,
> > which aligns all CPUs' timers to the same second boundary.  When many
> > CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
> > free_pcppages_bulk() simultaneously, serializing on zone->lock and
> > hitting contention.
> > 
> > Introduce vmstat_spread_delay() which distributes each CPU's
> > vmstat_update evenly across the stat interval instead of aligning them.
> 
> But, uh, round_jiffies_relative() is _supposed_ to do that!  Look at
> both the documentation and implementation.  Why isn't it working?

The documentation is a bit trick on me,  sorry. This is what I read:

  "By rounding these timers to whole seconds, all such timers will fire
   at the same time, rather than at various times spread out. The goal
   of this is to have the CPU wake up less, which saves power."

This is the full documentation:

/**
 * round_jiffies_relative - function to round jiffies to a full second
 * @j: the time in (relative) jiffies that should be rounded
 *
 * round_jiffies_relative() rounds a time delta  in the future (in jiffies)
 * up or down to (approximately) full seconds. This is useful for timers
 * for which the exact time they fire does not matter too much, as long as
 * they fire approximately every X seconds.
 *
 * By rounding these timers to whole seconds, all such timers will fire
 * at the same time, rather than at various times spread out. The goal
 * of this is to have the CPU wake up less, which saves power.
 *
 * The return value is the rounded version of the @j parameter.
 */
unsigned long round_jiffies_relative(unsigned long j)
{
        return __round_jiffies_relative(j, raw_smp_processor_id());
}
EXPORT_SYMBOL_GPL(round_jiffies_relative);

