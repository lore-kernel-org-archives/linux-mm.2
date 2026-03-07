Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C74FC9EFF
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 14:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B2F6B0005; Sat,  7 Mar 2026 09:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8BD6B0089; Sat,  7 Mar 2026 09:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA5A6B008A; Sat,  7 Mar 2026 09:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE4E6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 09:10:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E98198CEE3
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:10:03 +0000 (UTC)
X-FDA: 84519451086.01.8E399D9
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1925C14000A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:10:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="ujxH/YQ0";
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772892602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RM+Hz9YH+3ijyF4ASnaYHms+P4W04IcR81Vaa3/ZpsA=;
	b=xih9saggH8QyMRSuLlv6GqyTMfBaiDYQt5A4gHGT3CPH8lQ06nZ6T0rn3nUiNJjom1CL06
	o6Vvg+d09JrkN2LgfkTGO7TSsRbmQHZtjLx8GlxyvdVaBi35M4Jcgn/TpzP5DXxV0eanFU
	epGgflWlBRVZ83FTb7G9kvN++7Mfs18=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="ujxH/YQ0";
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772892602; a=rsa-sha256;
	cv=none;
	b=XyAv9iVdNrEvLSp6eUVrkXXFDzC6uoShLuZ4sy+ux8SNqoi8yMDtwjhmibEDlsNIsSUbj5
	D59JmASlPWE5td5iLCMY6kyy8RzgEgviW0+wJ00SvhisnuNaMGZ1rkYXRm54yr7dyxN84h
	42a2MLqSQ9sa8jNFFPwZ1i4pcR/JaYI=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 47802B3509;
	Sat, 07 Mar 2026 14:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772892600;
	bh=RM+Hz9YH+3ijyF4ASnaYHms+P4W04IcR81Vaa3/ZpsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ujxH/YQ05q9ZFNSDyFCZ1YR46Y6t85rj5qkuY775bNT3qzXYk5c0/A8PIyWS5RL2Z
	 o1zATF4Hj1rnDr/AN6RZFS1ROw6CX4gl2Mm5oNykswDaRbm98SHzc8j7DGVoc9wEqp
	 j76QCbkivRDwyIQXJscX+ujcDy20UUBqhToZ7FG8=
Date: Sat, 7 Mar 2026 14:09:41 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
 <20260307131641.GX606826@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307131641.GX606826@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1925C14000A
X-Rspamd-Server: rspam08
X-Stat-Signature: ucayw51njti8qwdbxnbkxjroyfeo83ho
X-HE-Tag: 1772892601-504626
X-HE-Meta: U2FsdGVkX18HCMn28K50VU9YroT/5JFcTMkIpgyYZp3bUUeRwhl5qElxock+I3IzDWTIrLiYynTAwoNrbrzRMKyBrXcUsLSCh0WS6/idXs5pzXxB/ei76bqXblQzF6TFWhUSmbS/MBJmsAe/nOslQXpA6GhQ39+Aq68nuNT0E/9B0lcM2DzMNBfKypurWKdVCXypK/ZCOZMcjkkBTCCBlYxwsgvhtojxWG12TJm4XmMEGdgaTd3ykFhlW9sTGBS1mijrQEjL30qty92/OfbelbWLsunVD79IwpOjcX6++JRr8WKmKPLB1iObhxqAMz8blVe2edET1pDkcROwGdfkmUrHlHHrjTEg946ZYv0zDFbsSo4/h93YkuybT9pS3PXFSWZocWNTJClSJGSgYNtrP0e2Ozxfe1QiX/spFvAFk6LdogpAw2UBfxry4Gs3HfO4RlDsU5/VErBAApCJVXXLSixTzslQ3oQY4ELTzni8rfbJoJVU5dyEAn00iQsWW32LnRQ935rSS/192QRPCf05sNLMe/RxlzP3DME7GSb6NkSfrYg3LYiqeL79gDE1lXJvuTqkkRHW6u4H7DQIIa68h+fQf/Yh5MH6sNNCCQujlrWxYB6fccP1wYqEdjlJtXFBPcCNq9FPMck/KPigCegHD072MpmN5CyXrW2AXnmdI91Yt2kSi9SzwdpIoFbhIdl1cbNSJg+4T38w6Ve+a36O0/sRhayD9/YM1KCUjMZpt8YnwJeCgT8235y34DhtoZVv4nb482+FRq/pSDTe4S4cTvwtnoMaESPKgasRcBVEIL4KReAzBw3bZkkmGX0KDBJ5CPrq5aWxmAcsTAUCJCyfe++7dgQuuoI75ysAYl93Bddm9u4QKrlq5xXdtxyxHLGcFGxnnQoZjzvJW9TwP1WiSRe2wrWuFsvWHDrPBrGnZkH5aMDo1a57ZR8/W3qR5Bkle9UGimg1KvdH6nzhA9Y
 +gZbn0Iv
 RzX5ygT1VhxWlbqbSNlfP4aVE4HEQ6ejVCEQN1Jw4ZKxMXWaXfX3DcjnbQhq/tLbpJBcqL+ugRbzPzjV3jmYI24DcQ181EMmmP522/3DbCND9NJCEETgjcmnme9SA7qJNSCan1m5U0Ly1qsBkSJICuVs3uM9zD+yZDRWlk2T/U3Gd894HcKzuWurQWHavl5kHEGt0K5LbGnJSDberqf2QohHLuH52thjME6b/NKeEGbaGl1Gnh95tXK947pfbfIHQAypkAOuzLFrkK64TvlEm136XNaGVnLGCd9etj8hjjNv/UbqQtjU/UbX4qxA5IF13gOeadRKyHKk4oSb6WQOOveibjvizCe8C/p98QLvjdoNq7s93ZpmEefvpt7k/4ZKvJFcEX98NQ5Xc559J1oLpqDUQMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 07, 2026 at 02:16:41PM +0100, Peter Zijlstra wrote:
> On Fri, Mar 06, 2026 at 07:24:56PM +0100, Vlastimil Babka wrote:
> 
> > Yeah I don't think the guard construct in this case should be doing anything
> > here that wouldn't allow the compiler to compile to the exactly same result
> > as before? Either there's some problem with the infra, or we're just victim
> > of compiler heuristics. In both cases imho worth looking into rather than
> > rejecting the construct.
> 
> I'd love to look into it, but I can't seem to apply these patches to
> anything.
> 
> By virtue of not actually having the patches, I had to resort to b4, and
> I think the incantation is something like:
> 
>   b4 shazam cover.1772811429.git.d@ilvokhin.com
> 
> but it doesn't want to apply to anything I have at hand. Specifically, I
> tried Linus' tree and tip, which is most of what I have at hand.

Thanks for taking a look, Peter.

This series is based on mm-new and depends on my earlier patchset:

https://lore.kernel.org/all/cover.1772206930.git.d@ilvokhin.com/

Those patches are currently only in Andrew's mm-new tree, so this series
won't apply cleanly on Linus' tree or tip.

It should apply on top of mm-new from:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

