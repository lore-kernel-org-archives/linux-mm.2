Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF7AFC9EF9
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 13:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02B86B0005; Sat,  7 Mar 2026 08:16:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E864B6B0089; Sat,  7 Mar 2026 08:16:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92CD6B008A; Sat,  7 Mar 2026 08:16:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C79E76B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:16:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B8C914086A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 13:16:52 +0000 (UTC)
X-FDA: 84519317064.18.19905D8
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf01.hostedemail.com (Postfix) with ESMTP id B4FCE4000D
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 13:16:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Q2i0nwCD;
	spf=none (imf01.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772889410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShhLXfmi4XDHi0Xan3xm2hmkxBaUBNG7KGAvGxR0t6M=;
	b=nF5S9OTcNub8r9Xn6fpFJZEQRTJBWkeuommMIY0ILUFmYz8vtBjdP1WVFt9TaLO7JDGbz/
	rpiqKYypXR0S+qZKvdCgr569mQK0yhK8e24XX1+bdNMheAgd5qTn2qRCED6wSpLmNna7d8
	binpppk3NuWzu57fG0tm0bxtKPDORJQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Q2i0nwCD;
	spf=none (imf01.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772889410; a=rsa-sha256;
	cv=none;
	b=8hqnJwjDnLQUWEbz8NLwvpSnBPp7C6Cv9qnIwiucdWrEQMktybOHzV21fl9M6ubSV8YUiR
	jmCYm2z/WoPGVbkAh24ygEAuZeVmXDFFuHVR3n0aJdQ1KJ+vkE26ZNvwYtKcTXkP+YC6pS
	QeVGyLQTECXtrjUfiMK5GXzab4cg5MY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ShhLXfmi4XDHi0Xan3xm2hmkxBaUBNG7KGAvGxR0t6M=; b=Q2i0nwCDDsuPaCWYvH3CSOQLCw
	WWTpe5e4Y20X6V9wZmehitffjqAJXRfDYoRirg9KWfBlk+M+0g5PDj+1AZ3imMSOBUrdy/MyjS0mz
	8cd6ONL6Of45gS/xq9qDaMNIJ3jO/UX8fW8Hrakcn++NDz4IOyuH/H2HaRGngZblNgBLUcIZsq50r
	bt+i6ZP/Tq8AqV1wAUbMTH9DkG3KauqM2xrc1Gz8ScdEzTSxMDCGbekvmarqQrvSMF14d1ddTImbv
	/PCnkZlfLR5tX8wOO7DoOPJDBmZnu8/wDHybbdvofLDzVcjwrAPtshLlnBVoG/HKXFpA/rZODjhG+
	Xep1iWCA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyrWM-0000000AGNh-11jr;
	Sat, 07 Mar 2026 13:16:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0DCDE301150; Sat, 07 Mar 2026 14:16:41 +0100 (CET)
Date: Sat, 7 Mar 2026 14:16:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <20260307131641.GX606826@noisy.programming.kicks-ass.net>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: B4FCE4000D
X-Rspamd-Server: rspam08
X-Stat-Signature: ouk9sd8ubq1f1jjk5qw1an8agznkzk56
X-HE-Tag: 1772889409-606136
X-HE-Meta: U2FsdGVkX19pP8qx9F4Zx7YL/WmKO1clalgPTAXilehE5B3FXiY43WlxEZJ9yWKegrgJoLmuH5o8Zg+cIgOXsjtTUfK08lW0mTa1Mq8S+/g8ILkpDQrW+9LXRn+fTs1clKes94GqaxPxTQ39XorB3umcg3tj9vCTxuZACMDrzyD8VUSa9Pdh9QNc/qh2YoLUOgp7wX0s7w8a/LuisFT7/tn1yg71hM38giNFrVcx7hK8WWFsKeFFmYhC0pfJp4H+bwAqbi3IhKt0cQOhd4TjR0/K1EeJBMb5wQcACN5EsDOdGt1TLl9to7ajEbP1f1cumWlYRyAVyohOHa3yrgKUPOjQ9emnVBeBepa9jAWhemAuMfDnDBvi8fCCXSMhBD4iShrtcX8XVEIldEEN3OAmw3+5D0f2TAp87LQV/C7rtsIjpDJvZMAZXotlKT+X2q4K9rNkCiUlvTvwO5ZO2HUS6ZPAp3SnghOAcF/eZmKhLWpOLGRWGkpGGYOkhTQSNze2QLF5FIzM7ial8X902c90cgmFbr8sJ3ipvmROhYDPjdLtRl2h9voND4W3sVZkIc4z7G1xkzxsj8AnpEZFSh+E8jNqInfuBt6KzPvk85KwLcshWST6NoXUP+WgHq1QEqYHdeNpAweHBGswLa3B4Lo+hEHf6rV2MnDXZbYtgvOfl5gRmW6SYtw/YrD79cA5t5RnqcdTFaXWE5PbE4yGyeSE7Uv1mwMJU0dnPU5d0iJQGgSwXJJ12JEDTk8Vi+dZF7eH968e08AnhAmSMeEfYxGbyQevVPnvW55rbaASWoblGpfbFeuhHgnpLWQzxm0YttplqEdBaamFU5NE4McMc1l1WgwKt6i0bqiyBR2LGz8vCat9DI0zaoIB+tHNoRME347Y2TbllGX50/gLRFX/nXErFUFw356nsDBXK5ygakomP1U91aUA7xS1xUZPdfvny0af47w7aOQtFvEXODRa11c
 A6sXeOq4
 WSPMCNL/tRhd6KEGfLEviQ2OezFvuB9zQfJehLMLLTLHdUFm7CkR7IdhsV+pdT6lzORdUdGrM8NYfpYImpdcEywmFTK445BFw5Ka3OJj5r9I31zDo812fOcrMfJr2MDqcX8OAbAzSbuH/E6H6uRLBNfxH9HJHs/8tYystYb96csmHnClVBKDsdbzsa0lPrcb5bjsNu8MJZKCMSEi6pRb+hpbS8enUYpIj6ca4ywIUlYV+dJNNtjEy1nXMgHlmzmwVAfipn/CXWSGzW0sPokxiJuTJEg5NnM2lQcTWm+RXWjiHnC+Mh/H+ydPt3pEv0F+mUkXqVSd+nybE1LyYOZc7U571B4hIX+9G5IJlOCOi1vUhLLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 07:24:56PM +0100, Vlastimil Babka wrote:

> Yeah I don't think the guard construct in this case should be doing anything
> here that wouldn't allow the compiler to compile to the exactly same result
> as before? Either there's some problem with the infra, or we're just victim
> of compiler heuristics. In both cases imho worth looking into rather than
> rejecting the construct.

I'd love to look into it, but I can't seem to apply these patches to
anything.

By virtue of not actually having the patches, I had to resort to b4, and
I think the incantation is something like:

  b4 shazam cover.1772811429.git.d@ilvokhin.com

but it doesn't want to apply to anything I have at hand. Specifically, I
tried Linus' tree and tip, which is most of what I have at hand.

