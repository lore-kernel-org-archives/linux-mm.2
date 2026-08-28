Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B6EC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37D36B0088; Fri, 28 Aug 2026 10:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8776B008A; Fri, 28 Aug 2026 10:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9254E6B0095; Fri, 28 Aug 2026 10:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC516B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:45:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E700EC03CA
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:45:11 +0000 (UTC)
X-FDA: 85150950822.12.E817341
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B2C120003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:45:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Au9yP3eB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787928310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2svEyFOZsFh7Z9gUJnKXJmkUHjn+t2fc++fT9yfnVTw=;
	b=GL6j385xBwf6glc/iy8y6CFOC+XlHG3ZeSFa1h+BX1vOc0hoQ5OQk9+pzyVo/0IgyJVE8e
	Vs8leiQpRN0eHUrURLC9wl9gAMqSzt+XRYNGKFtC6RHIu19GUByCPPoccZqk0vL7OO09FY
	omJCOwe13zbNxhThFboiQ5cIYLZTux4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Au9yP3eB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787928310;
	b=KeXuMm6z9tIYvdxI5KJQqAj3ZnENGHmOuYMkKHe89I5xmU6luxxFB9xEIN243nYNAOc0GA
	hYBARYHJQMB6CXcBrQtEJ4hJw7f7zdBZv8WP07eyLOQLc/lqBMdOZ5CbP7+u8i3hCwumcj
	Ta8qe5wqbzg2e5QkGfYPKAIKOjnJJko=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2svEyFOZsFh7Z9gUJnKXJmkUHjn+t2fc++fT9yfnVTw=; b=Au9yP3eB6i4vjvt53lDNHwLHlH
	7GVgsID/l2OoVPVxPQoAzsrTgC8xDr62Gl7PzX36y4pzO91NYooNY0VRMTX25aDzYsXrWhSrKBfD3
	eEknGtS+cIS2Jfadq9c5/IK4QycHdXAqPY9FFegcrduJNbHVrhcWLe8n2+/j92MRChzgCnB+QWMLc
	kS9VFW/sxoqKApZL2rhQ7eCkQjZcGfK+3oIXe6z752aOnqF9Fxgl/p5zCePvciTBNIXYBjU26qejO
	l16qPsRAMGjpvTTFFhkVoUX+1zgiHnca29azGuoTY/oUB/KYztdt9eCJlLUFx8X7gHVqh1JO7kz5T
	BFCChTlw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzxpF-0000000EqNL-1I6b;
	Fri, 28 Aug 2026 14:45:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C4B2930116A; Fri, 28 Aug 2026 16:45:00 +0200 (CEST)
Date: Fri, 28 Aug 2026 16:45:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Stevens <stevensd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
	jstultz@google.com
Subject: Re: [RFC 00/10] Reclaimable kernel stacks
Message-ID: <20260828144500.GW776954@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260828124758.GP687043@noisy.programming.kicks-ass.net>
 <20260828103328.633bbfbc@gandalf.local.home>
 <20260828143540.GV776954@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828143540.GV776954@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1B2C120003
X-Stat-Signature: tgxhgu3yj89u177up8tqqji1kehnigb1
X-Rspam-User: 
X-HE-Tag: 1787928309-671256
X-HE-Meta: U2FsdGVkX19lMdCPvQ8fafvc2Vsli9D9vTz6pnWRkjXZnxa4d8Eojj3qkbPns36o1n7cGNsFv5Xp4OtVjoROTXu3my+cfe6Sd/MqWFdeo6WM9qQNanzhMfRNRCiyLQs1jR60ulm8VpAygDv5xwTxj9McR4LelryhWiOeqragF7nIFFjD2aR2YJmXHLObXlGnu/YU6QbpnGtAGJCHpa6t5ZHDD1vGsWpaW4heO5exmS1Q4Ocsxxp23rmHD9tXQYfBzJ6dbM4aAu3NFXAYf+7vH2rPOpubjmmpTnfDjNEMeqIN8B+MuFhWD8NM4IZJwE84PaFBXkYnnbWNury5kQj+usAahigx8/AAhYHUPiqV0PXXJFbdIw9bkqtJ2sm0S3UFa6fDrp4yCW/hawAxfA9OX2gFH+/kEoPxV1Rle6Hg0aILK4JkO+FbhqdxdKPFJXcCNwIp+/Ys4ZKgKminsAKMky/1fQV6g9L0JvrWAUUHQwbHcv/t9PJuJh2t85Ke3qulVv+MNB7c44amZTUo0693Y+SQ75JuepG3v/1m8j60LKf6P8/hR4/9ZiyGQJguqRqTKCcLzVp2s5vV+gk3fq1SvsN7i6/u3T9wVe9bEenmgi2jjbiKs07sybpNtfDLl6mC4HwWjJ6RvSNVYHm4l4sEdT6oSBaKOkdPltsJ6JXGBV88kOQ5B6YQAqoxA5/dAi/zFpCNpBCbc+Ksx443Kt+p9COrVjt+p6pgsdl2P+40UIEbT5prGFoUWn75odwG7/80OjmZ/YxE8fQUayJX6HPvonJSg6q918VoiVSY8HLU+AkwxeUwul7WN4G/Sr3lc4TnjF6goQCercWHVEUUPf2e5/brKMRE6zjJEN/Q1IfVNXJG+/egfM3bCTBu4svEXyDPV3RDAF4gy2uQT6V0XFbw7LgTMH9dOP0cCEx4HhwV6OF1JOUe+79nnlf8UJNdVDI6nJR7kMWrV3Y8MxFNlAV
 cJ6rTqQv
 LrhoBDRqY3GvH+Rh6Sn67dmSiStNRjxyVRugNiIa5AhVH6F59TyxEEp/g5TXx1WMYnJuEpgghwBYdjxQjfU3DXSCz/NMNBUjWk4nrovpjQ1eg2UFg+N8kMcMd+tlI82F23K1c37P+Hgu5msfe76k47yLJRYxR54lMEdrRnLVbrHSFG0nTZB4Smt1eWPEC9bqXRG59KzOmqAQjWlbVW2pX7OMCTd+fF2uG+SEx7VjfY4NaJxi50AHZ6C8wtSMuVsJXqZ2XehvJYBNQ2XFUwgrh/ctjrJG/w2TBDav3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 04:35:40PM +0200, Peter Zijlstra wrote:
> On Fri, Aug 28, 2026 at 10:33:28AM -0400, Steven Rostedt wrote:
> > On Fri, 28 Aug 2026 14:47:58 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > > On Android, system processes typically have 2000-3000 threads. App
> > > > processes add 1000s more threads on top of this.  
> > > 
> > > WTF ?!? Why does that all spawn *that* many threads? Perhaps work on
> > > reducing that some?
> > 
> > I guess you never ran Java ;-)
> 
> Of course not; why would you want to do something that silly ;-)

I realized I actually have a Java thing, the kids have Minecraft, so I
booted that up and I found all of 108 threads. Which is still kinda
insane, but nowhere near the 1000s per app as claimed.

Reducing the thread count from O(1e3) to O(1e2) would win far more
memory than any thread stack shenanigans would.



