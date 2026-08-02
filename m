Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4982AC55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9CF36B007B; Sun,  2 Aug 2026 12:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E566B0088; Sun,  2 Aug 2026 12:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C647E6B008A; Sun,  2 Aug 2026 12:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA506B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:08:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2791C160516
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:08:18 +0000 (UTC)
X-FDA: 85056811476.04.E904A6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7658E180003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:08:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fViHsPsw;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785686896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+4xx3fRKee1b0QajtvgZv/bFYWSicihtcsfxKrpyj8=;
	b=m6aa55Q6PUM1MEKMjIy2nVQR7uz6f63n+6YNn0kG+YDMikcCq6d8jvggwp5GNiZEvieVHK
	rr6skQBDAbI/9k3VAfeTTE98GWwdqsz/SoVRS+oQtSXqlm4jbaiUXyCblnHvcYFS/xGHTG
	BINm03kFmSfwEyC7JOX2rN8dYEAjFfE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fViHsPsw;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785686896;
	b=p2kFV4USisUFhFybkDFUh4RtDHYtKKGhi3PDEnivTHK06KoPuMbFHHFtjr+RiAsnCj39ev
	1aPHQPSAUsT9vNaibJ+k9DjfpntPh5Wsflt8ZHwqMRwsNKwcOrpsGNojnaLlzrQP/N/dLQ
	e3hDXbpSrgqLudICRXNWkglBC4IAX4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44BBB40F11;
	Sun,  2 Aug 2026 16:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56271F000E9;
	Sun,  2 Aug 2026 16:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785686895;
	bh=H+4xx3fRKee1b0QajtvgZv/bFYWSicihtcsfxKrpyj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fViHsPswWigTKEfPBToFcw3DBd7G4MxypKk/ObN08SNRwfIiSmB1gi58BxY634oTS
	 xhYBJ+W7P76Del+d1V7R746QWJ78Z3CXuTXnLUV36MKbq+smBuiZ7QtNnkOSLfiyRG
	 iR0iSBZRvR+u4doaVnz2BhahCK0dqGkdTWfgPYTfkB4663fXF0CjqEy/0/fDFHoNf4
	 HVYE+1sPqqQr3lV20HM1tOfTLYPCEt141ysP99Zn0nM6lgDhLuS2NwJE7+qmnpPcOy
	 7l7nEOSihJlcHapONkZ4xBGdIfVJGu+j2hgR/mS9vxOd9b4eEjb+2povUvxI5HTGVT
	 JMM5BTeXywfUQ==
From: SJ Park <sj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: SJ Park <sj@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Fan Ni <nifan.cxl@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	Wei Xu <weixugc@google.com>,
	Xuezheng Chu <xuezhengchu@huawei.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: Re: [Linux Memory Hotness and Promotion] Notes from July 30, 2026
Date: Sun,  2 Aug 2026 09:08:10 -0700
Message-ID: <20260802160811.88983-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <fe8acbf6-a631-c280-55a3-3a6fbf248ed9@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7658E180003
X-Rspamd-Server: rspam01
X-Stat-Signature: xs3abpw7y7crur9ih8m4pdr3c3nu17dd
X-HE-Tag: 1785686896-304437
X-HE-Meta: U2FsdGVkX19jsOVrBOBp97+ywjria174kurspA19Wr8xk6ga27NTTqrXEV/7TxtxgQnQOzK6JVGY8lhCx0HZhOXLsb4NKqg+KgP5uiTnlkLBfQNHNoqvanKG28Fg/0v1gA9cvg6UxDxNnwdUuw6v/bZIVjTVxmkjRE8bMepjfnFHt35HHl/Ze2fn/yAgxdU0lPVpzShCHzkewTH86RQFP0GLMeUr2Z3T+EMK4dN4yOVDVCqIgjIEZvBvMXvL26so1/hZru3J2p6OYOSLKT9sr2GRPnqlsXAMUOU8yED0ly5+KbIZd1WOOf9Ie4tUWzQ753i/XLEEZC93bI0dive8rBgXVa1gufLHy7EW8Q8QQODQeEDNJVme2olggj/+g5LMCiX1WgpqIYgUlIuP36WkfwV36z4R2rskm/pAVpb+gAdJzMiPpAyZKU10NWORzrwcIKWvYT6eSX9BL8jeLMPxx+fOSdN49Gg8x1RsVlyxv1FTWmlbqMvjUzbrCdoSE80wkO+FeL/mP90dUlW8u0Veico+23CPdbMYjFLwoqC6dQBS8ItXyHbUxXz1Q2ImP/WuILUGc6bRYOaNcEg5alBuKZutadGQMRW8/DYoD9CQ+YIoUsIgHbhTcJ5mO5kHKP3bwZccrErtDPJnKzL8Rd1kAVnF1qJ02A4a2HBF+ygZBot0jm0ry5GwVz22e+K4HXvc4NeEfrKTAHxwC7Ymz+MD6I4iw+FGUuC0P9JscXW3c6pEiZ8QqhpCbQHryxB0guDWldrvcmoGvxzanEaWh/D0LsAzkVZsKa0vvbQh0uclJVe/Ug5RZCBj/nUvp6g4Ge9sFHceGC8NXCTTmGms5X5BPb4wfxYDYIcul8tzo01t+j5SPk4GDkrkQs3/rZZDuEQfqXpk1dJG6TDVl5oG9RyRLEq9PEEuO5ZiMA/JfpK56KiaR4g7qcqiuP009TciOaCE5ErK2HVX8rLwPZtKjOf
 6rIbPloo
 2Y/YrNq7jPP2msaxW04N00wkBPJIdfg3WErWqLK6//fatdUu7vZeJv0WPFFgJFasTIwmhseyDjoeow3HV8OLLiyADG6E5G70lUk+J43qW2ULRtxU2UOb4Rjbne9U0wKdsraHmy92QhlJ2p1MhGFb7itnb7BPd3iuxGZd8RllmaRL990bVtgRZxAdEo1KoAq8Bd6J4/wXNFORCkIx52g2ss0KOFwAKAYkRqBi/+WAfzc7qDxVTiSIjO1lOGjQZSRqJqopoMY247TyMbZemjFc0qdHOumXQkIZbxnIAzH8K4IQGPUgMDFc9LuxL3VehGM4byVgH9KopC4RtORfhwtMqDLEavdzlwoq2uIFKW2k/JHAZ2v1pRSvXpEpFTjI/jHnGc4us/K86wCLZ35wl9jkGKyX/JQUA5qR/rxHHJjxMltt5qE/xKORLyUVMxFwRGxfSpMzK3OlAsjnaHtuZpTZUUq/Cmhlk6Bi36gOh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 1 Aug 2026 20:40:35 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> Hi everybody,
> 
> Here are the notes from the last Linux Memory Hotness and Promotion call
> that happened on Thursday, July 30.  Thanks to everybody who was involved!
> 
> These notes are intended to bring people up to speed who could not attend 
> the call as well as keep the conversation going in between meetings.

Thank you for sharing this note, David.  This is so helpful!

[...]
> Bharata updated on the status of his v8 patch series.  He has posted it 
> with some numbers and did not observe any regressions when comparing NUMAB 
> with pghot.  The initial goal is to upstream the support for the tiering 
> subsystem regardless of the number of page hotness sources.  Thus, the 
> upstreaming story will be about clean up and refactoring to support 
> tiering; David Hildenbrand had suggested that the current approach was too 
> extensive.
> 
> Bharata was also looking into performance numbers asynchronously.  Gregory 
> had been vocal on why this patch series is needed upstream, but any 
> additional use cases and support for the upstream series would be 
> beneficial.
> 
> ----->o-----
> There was discussion about what overlap this work had with DAMON.

I should have attended the meeting, sorry.  I show some rooms to improve
clarifications.  Let me add a few comments.

> DAMON 
> was noted as being highly complex

I admit there are many complicated parts in DAMON.  We therefore actively
working on this.  We develop auto-tuning and simplified alternative features
for users.  We cleanup and refacor the code for developers.

It would be nice if I could further learn what makes people feel this way, and
wht can we change in DAMON to make it simplified.

> and we reflected on previous examples 
> where this was a similar story upstream.  Wei suggested that memory 
> tiering should be supported in the core MM and not something external.

I think this could better be clarified.  What is the definition of core MM, and
why it is beneficial to have the support inside it?

> He 
> also suggested that we wanted to support hotness signals from hardware 
> (like CHMU) and fix the promotion side but that does not require extending 
> DAMON specifically.  Nobody in the call suggested that they were working on
> productionizing DAMON at this time.

We shared the plan [1] to extend DAMON for multiple access primitives (a.k.a
source) other than page table accessed bit in LSFMMBPF'25.  A few people showed
interest.  Amazon and Micron publicly showed their interest.  There were few
more companies showed interest offline.  We therefore kept working on it.
Recently a concrete plan with timeline [2] is made, and we are working on it.
Quite amount of preparational changes are already upstreamed and working
prototypes are shared.

> 
> Gregory suggested that our focus should be on generic support in the 
> kernel that ensures that we can handle these memory topologies correctly 
> and without extensive configurations, including from userspace.  Wei 
> strongly agreed with this.

I fully agree with this.  I shared my plan [3] for doing that for not only
tiering but general NUMA topologies in LPC'25.

I will try to join the next call for more conversations.  But feel free to ask
any questions on the mailing list or privately to me, at anytime.

[1] https://lwn.net/Articles/1016525/
[2] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/
[3] https://lpc.events/event/19/contributions/2066/


Thanks,
SJ

[...]

