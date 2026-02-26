Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A82FD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39BD56B01FC; Thu, 26 Feb 2026 16:31:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C2C6B01FF; Thu, 26 Feb 2026 16:31:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 288CA6B0201; Thu, 26 Feb 2026 16:31:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 114316B01FC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:31:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B91491B6DB5
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:31:58 +0000 (UTC)
X-FDA: 84487905516.03.AFC7294
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf24.hostedemail.com (Postfix) with ESMTP id DDD2418000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:31:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hn2ytuLO;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772141517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vnnQTlVdZ/Og5RtD6XvnKakZXItRdyMij004ePH1bw=;
	b=vE5xWTMi7HKypJIFg91oPhTFYyXoIpPNdnXEeHUD75txi2GlvfAvdpFtmBcnOz8belhn7w
	BmG+OTU8hzssWEhgRbOT130QMV3F9kL7geGz9+9XxHEdzvqQEsJ1kKVNJvxfTIlNxdBqaN
	Z9vu7jOWW4hm4EJ+2ku+31y+NuFc5gs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hn2ytuLO;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772141517; a=rsa-sha256;
	cv=none;
	b=IYzOuMBpZaEsk9mEj+r7jbgXywXgi/UB5q+ae5GN9R3WZixMmuivgv7fmIRMI9s86mU4Bu
	JfwgFjFSqEkuMRvcjaZAoakIzkOUzco0s1tXRbXeum6PkuWOg+iDLv0EQF58keZum8PVpV
	GG6CBznxO15VINaJbHkahVsMBXdG17o=
Date: Thu, 26 Feb 2026 13:31:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772141514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5vnnQTlVdZ/Og5RtD6XvnKakZXItRdyMij004ePH1bw=;
	b=Hn2ytuLO6KHfvcXYNvzmNp522fxz6wReD55jSQnK01E6iAgMZbR/2GbcXJUWEAuAgdxVmH
	GuBSoQ/Rr+Q0ren1UOzvnjHhUYHli3n7FF8VuS+4+vrOyJ6dageXcVeHErIOF83Dm7KXR4
	0yj7IllzR82We+0izRSBhfgrrIFltmY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, kernel-team@meta.com, 
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 5/5] mm: add tracepoints for zone lock
Message-ID: <aaC7S2ensAGTyujc@linux.dev>
References: <cover.1772129168.git.d@ilvokhin.com>
 <378089dd269249d3d7981fe10eb8b49ad551d353.1772129168.git.d@ilvokhin.com>
 <aaCbMwGNuUO1SbUb@linux.dev>
 <20260226132501.5b70914daf9438a1103189ee@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226132501.5b70914daf9438a1103189ee@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DDD2418000C
X-Stat-Signature: 9xrnwncik57g4jypnau9x6urimhi63ra
X-Rspam-User: 
X-HE-Tag: 1772141516-362264
X-HE-Meta: U2FsdGVkX19i7ByeNhbZ8og0HdUhxjSi37okezkNkKrOecYpthfR8KltyKZ8la39DuHf0qJfE2+9DgNrAmp81yiMHM2DBFaGx+W4KZ0OIb7I0l3Zt2DtNz5vEBjL1T8hQoYHDTUcRny72/Ql20WdQ269zG8czn1mVkzDa4/H0PY0FUwGAGPUNgf9ML1zntUFpkZj/SYIdC2/OqZ4mtiRxYtMBocTlZMKmD8rWeeDM4zCTgrfaNvh9iV6RuDYA9g/sh4Rfa8/PSzVtw99oBpzh15+fkPWvyILnHL1JZ45HwjwYQLbQptstkqZ6Pg/YKRtUzbu4q9svt+5egG4pzyZK0VrZyfX7Bwhdw15FivY43GPlzNHw0aDuUZwDmaYBJTXriyoL8ZMM+GiYFsI/OTKSq9Os3WKgFMp9SzDaYmInbgZErXtRqt0zmj1yAdTjQbyYB0tti2HobGqH6A2zw1d2rg2kLE3K1n/lm2FfZtiXDXCZM8SA4w1aIFk+yHgtxoBNRbo8P364qKh33PNrm42AHpeEU6IrR2bxuXzrWerJ4ijGkOMa6YifG8TuuWieICe8F3fzRQQZX0sMDbXvB/t/bZwNoNR646llP78LlJgdYH1QtTlbxPEfSp0BHN6Jjm9zvAqbD96v7C55jaO6xqRZforS92e49ZGeVaZsuufp/vLLiroOYPMAUOrFfhm0ZnX5LFwx3DwnuqxGlspUeb/hJRKXbX0RBb/CpFY4j7/q70Kv1ISdx6J+b9XfZJ/Bu2LVOR0Dp6PWwhnZO86ThjQvuHTec2DHBX9d1xH3orKmJemqnibf3cx1N02ymigSqNaXr2KUjUGeCMIbK/Vy0tRfGErQJH4twJbhDWm8kcKr+P/fSCLD1w90h40AoreqmkuKLhHU2jrwCFLJQqP3hxObekFY0vIEwhmbW2Qf6dINCP28nBRGIUZJCBRvQO3IFEeOz82qWtnKLrzWJkJe3n
 ipGWbVpF
 bfyDn8E8ZMem/V9hgPAm9dLYSFvnZAbpWZD3V/1yFgBg9HKOa9mF9bHrX+NOz6/7ckbRhS/ijJJLzCvnPvf2GV/pZetDku9aQZuHBSmQAFCpuxpyezflSdgrR4c0R5ANaaxvMHKpfyDjvWtnRkVNUk3q69/+zGC0FzrFAwOi63ybxOqq9hMW2QHcaxeBbOIZQ6aW8XbQGlUq8+/HrylBdZCYTH0jiEzhgOPa7FNcQr+Pp+ShdOW4dSvg4xjym70MrYIQzrSBCf77v+Ld3Wt6QD2RTrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 01:25:01PM -0800, Andrew Morton wrote:
> On Thu, 26 Feb 2026 11:14:52 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > On Thu, Feb 26, 2026 at 06:26:22PM +0000, Dmitry Ilvokhin wrote:
> > > Add tracepoint instrumentation to zone lock acquire/release operations
> > > via the previously introduced wrappers.
> > > 
> > > The implementation follows the mmap_lock tracepoint pattern: a
> > > lightweight inline helper checks whether the tracepoint is enabled and
> > > calls into an out-of-line helper when tracing is active. When
> > > CONFIG_TRACING is disabled, helpers compile to empty inline stubs.
> > > 
> > > The fast path is unaffected when tracing is disabled.
> > > 
> > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > 
> > ...
> >
> > > +void __zone_lock_do_trace_start_locking(struct zone *zone)
> > > +{
> > > +	trace_zone_lock_start_locking(zone);
> > > +}
> > > +EXPORT_SYMBOL(__zone_lock_do_trace_start_locking);
> > 
> > No reason to not have these as EXPORT_SYMBOL_GPL (& below)
> 
> Do we need the exports at all?

Very good point and we don't. I think this might just be copying the mmap_lock
tracepoint wrappers which might need the exports as some drivers might be taking
the mmap_lock.

Dmitry, please confirm (test) and let us know.

