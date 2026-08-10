Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05238C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69306B00A3; Mon, 10 Aug 2026 10:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19D36B00A7; Mon, 10 Aug 2026 10:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F5B6B00A9; Mon, 10 Aug 2026 10:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A21D26B00A3
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:57:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A2421C043F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:57:08 +0000 (UTC)
X-FDA: 85085662536.20.F6E011B
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf13.hostedemail.com (Postfix) with ESMTP id 525792000F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:57:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786373826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lwwQLAArigZJZaxTz9WM24Se1zZinRspMjIsL3+hq+A=;
	b=wT9YMjPeye9dVJCdSNHUYJFReEE0MmK9Qu75TrWHEUOKV2sSqTxMZhzaUZKpqMpPIZQelj
	yX4S0fM/9Q2MfGklxRkNuj0Ybv8afLjzHIO27+0AJylWAqx1MfRIHIcNwpzInjcyTMZKRa
	B3KpKmwFRYOcfNrpjJAMVFI4c9pyZd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786373826;
	b=y4CDGhViK0e2i+qCLt5tbUXHfhnn3ZwKIiIcbrBSRN9MFCjGBdbIGjxQoymmuPnLEau1m6
	X1eVEJHJUu8iCUnwPh/uMWWIpSB1eET3AY1kEAE/hAgDMvWRbiR3WYzTrbfS8Z2lsr+FOe
	4ZmNjJ+uOepjV2M8ksmsbBtC4dAeCKw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	none
Received: from omf04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B644401DB;
	Mon, 10 Aug 2026 14:57:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 187EA2002D;
	Mon, 10 Aug 2026 14:57:01 +0000 (UTC)
Date: Mon, 10 Aug 2026 10:57:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Xiang Gao
 <gxxa03070307@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, liam@infradead.org, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Gao
 <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] tracing: report buffer memory in /proc/meminfo
Message-ID: <20260810105710.6ee5e493@gandalf.local.home>
In-Reply-To: <anm0SMuVpBz7wLac@lucifer>
References: <20260810094025.136705-1-gaoxiang17@xiaomi.com>
	<69df3080-a719-4131-a247-62bf47bda8a6@kernel.org>
	<anm0SMuVpBz7wLac@lucifer>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18eSPQyM+UAYA64F5aCSKfWzLW/KGo8Kqs=
X-HE-Meta: U2FsdGVkX18h8BsaxnBZAiAxJA8VX0jouYReEtmoXZzeqYdC7OsE9ErsPr+uP7COKi2SKYjalSNBz6c5GD5lNsjnnZ7rOAFkQ3BESknYuLHfrLiQ5ob+FjhOeeRFKVsmae5DWFY+VgGWXlPqXTp6/KD101g8Dtn35p7rqVg+D0Ll6lrBgAmjYd42OjtfrPYAW/HY++mYOQhb9DrXrLLvsAwjEVO4/HggwQPlqoa+tUDg5Qm2aNldOy+/R3Th+msxwWtDEkDCjq6gibDnBsRw0VD7FBw4Pu3H+vJesyPbzeBfwrjaXneAgKUfu8YXsEPTteeQz+xDHBqsVR+O302VavjgRUO3nW8M
X-HE-Tag-Orig: 1786373821-994234
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 525792000F
X-Stat-Signature: 5jywzf45yw4bun8sqydd5xakunud61nb
X-HE-Tag: 1786373826-51613
X-HE-Meta: U2FsdGVkX1+2tZtfxSjt2nBdVsQ8Y+hQipfErROMtuYi6SQKnCIBMBye7Nl5UTilquRqeLDecI3U5+mbOQM3NsnhqZ6mzWRAqwklWfvHg8yIiob800bjlZW5fVV31Q1bxhCasELKcZvjJRmyPq2mwEGkITqIOaYbgUgE+ZkUtUT8BePTsVNIz1aTaC0ZvswX0zVtmgxQotV/FD95WfTMsIJ8FuEYYXopeBlj5wSted992Ll9uZv1PlJSirUouC4iHbS/8mW/GSJyMWIkGieVltEHADFDjIMO6vJw2CDBZI55AwabrD+PYTK1Ohaa9hZjjyq/72wH9qxS/zfcOXxpd1v/LDHI7sXzixaa8GPq/jg4Hd62ZSWJztlxY7ZN9+LqbcvCvxy2ERcOTD4akDXZRk74Fi7GSljUljUROs9zyZ+yKjLQivQdl6++xfLFdi9qPE4DzN9u1E+vr5nzTJEWzmJl9q5z/Dq0l/FvTDZP9Oi92tjX0XDYX8c/IHrwqy6XH5TjGphPAorSh/SH2JD1ZhHdNc2h+l3VqqkUrUEwkZidUgxVZZTFNB3OwPo878gjC0xEATN3d6lYzPMtlC7lwI/bpiXpHZ+4aPcXxbIwQ5koeJFPfYw0+5jBrnlmym6dIdipASXcv0VGHHKg1y2/g6UOXW3aXXKE+KUMhIXw4A/J81iG4AnGagbL689dIIlRO4KcVbMk4eaUJM3MLyW8Iyj2UmJ9ZFd69iQZqQNdDZM1g1yxk6dt5Uum8kGWjgW88rqYutsYTXsVVW9plJjiOxxvo+BjXyXN0etmK8Kd/oT6sm20xeRRAzUN0cLGZW/dsG8rTAod06wKqgyR/InHmX5f/5x6sxHcBrmbrDlc8Z9bUAD9o/anyI7tHyysczbWxoaYkC6mGlDr2Tt31AMAHVN89ugc+UYxdyNNEMeFJ8WHofPrfWHJOpp6fy3BTmbsPe7PAZeoR/dgfH3pf9K
 GCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 12:22:43 +0100
"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Mon, Aug 10, 2026 at 12:52:38PM +0200, David Hildenbrand (Arm) wrote:
> > On 8/10/26 11:40, Xiang Gao wrote:  
> > > Report the data capacity of all ftrace ring buffers through a new Ftrace
> > > field in /proc/meminfo. Include the main and snapshot buffers of the
> > > global trace array and all tracing instances, while leaving ring-buffer
> > > metadata accounted for by Slab.  
> >
> > why? :)
> >
> > To report a handful of KiB as in your example below? Doesn't sound super helpful
> > TBH.  
> 
> Yeah I think we need to stop with all the proposed additions to /proc/meminfo :)
> 
> Also something like this where you are making a change in output that it is just
> your opinion that it is useful should be an RFC to see what the community thinks
> first.

Agreed. This doesn't belong in the meminfo. If you want memory statistics
for tracing, I may be OK if you add a "total_memory_kb" file in the
/sys/kernel/tracing/trace_stats/ directory.

And break it up for memory used. Ring buffers, events, etc.

Perhaps even add one per CPU as well.

I'm always conscience about how much memory tracing is taking up in the
system.

-- Steve

