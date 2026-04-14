Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1082EF9D0F2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208986B0088; Tue, 14 Apr 2026 16:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9736B0089; Tue, 14 Apr 2026 16:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0266B0092; Tue, 14 Apr 2026 16:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F08576B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:00:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 520C1C0D2F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:00:21 +0000 (UTC)
X-FDA: 84658228242.16.8229F38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 32E4714001A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:00:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h653xH12;
	spf=pass (imf26.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776196819; a=rsa-sha256;
	cv=none;
	b=24gJchPkfBepc2pPT5VSTVcdiaQC8EKoUykJIoBMSAGRoGM2t/V0HeA8AjACO5vpXAXDGw
	Z4IQiMcwqygotLktfMBq4pIdPi5oO6jn7Cti13EJDoBf39dndx1qtto7eZRl+d7z1lzRyK
	aJnwRiK1HuZ8yUWsPnNN47NwuNdfM+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776196819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDjreyRRfTGxPx+TOCY+2cqZ8+eWWsniqY2WQgZtsPA=;
	b=X8b7UNUslFccTOjRodp0/TNj8nCydZnF8pZEcDNqqfchdQGNWGM2M5rCa951HLFyLA57RU
	4D5ymTLQyItWOHYBKBgTzW9oE4vJDPTzGw+EFBwgTsP8zuYEWrjcNsRDj29Mvh+QxzmiOJ
	CIeKeyp18vS75sKe5v0BIqgLZgcu94k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h653xH12;
	spf=pass (imf26.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26B1160018;
	Tue, 14 Apr 2026 20:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856E9C19425;
	Tue, 14 Apr 2026 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776196817;
	bh=E++00pwx7ahLkiLbRIEGgnYWDaPnO/diQWMC/2yTE+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h653xH121WtcrzTO8qU+B1JgZegJwKSjxOfBwYj7ZTot8Zew364vr2gOo/ae39m4Z
	 Dtdu6roTTYzRnfBHMdyX3HUZuzP0uVD1iGDx4mC202t6z6Za7e1bs3REt8Nd/sVh7T
	 Z7+D5WHKPc8t+oeJBgwnpJHTDUvANrt5GDcqbmD2B6LwgsbWgjc1pgFx+bB59WVlXT
	 acPnqrO5wg0B6yjIVgEMaiYDUj43+YQb2VW9Ey7WDf6VThJRPP/ANT+n88rrPMe19I
	 rOYgXz1lfJ+HTvmvCwV62MhNZQmhdEwfD5oM/pAWVUhf5oyutbvOk+nsrISqFFC5ck
	 F+D8Y5lupeU8Q==
Date: Tue, 14 Apr 2026 13:00:16 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <ad6c0DN7AGoOQ_Iq@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad3ldU4DZxga_J2L@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32E4714001A
X-Stat-Signature: dj8zbbhrrwq3zr5t9ey6g3dfi58xscex
X-HE-Tag: 1776196818-803465
X-HE-Meta: U2FsdGVkX18iLXTRCQYqRQwt2QpP93ImQhAg9Tb7xs2k/0TraY/MgSnvDDo6H0VHRvttdT/i8NCpJllMF+7PbdM/P1pOz1pXIgYAKwDOuryYYLJNWE+agNoJZwsfSri9rSQLKG4UilpCLsfBYpEJRxpEgLchpZmyVHepEy/41+jNWLMUjWMH+TRWT+4+3/JHJImYxbOpmwL0Th6AGJqs/gJSWuWf1e1bca0ty7ykkuuKkbNm9iKMoj4i0sJks0RubcXKXp77NhDYdpYBK2L60gza8JZIZdl+NMRWIct7gP1JKkHAsOEtdfGA1+x6Gyi2YRBH4wq20xlVinv6pTNjVAwb1Nj/TlmhGCisPTEnCthkYZCFBgc3gAYJcZ8BVreqlwOsLoJYHbtWrioq91LC0q18a9YUFTx227hFygtfWACtqY2t8YmOdL5KSs5OjyviTMz7P443f5oqQUH1wAXQ6u1OTYr8iPsaSL4qjKKocsZvLQ1zpQ/7RtHZzOl6rkSlvci3fGx3fbtD4pexCWlCg1U9bZx1HVD4OApmyh3lh6ECyE+2SzjIm8nXKACAow6OoLTZGWVAMYCtCOy18Xe7ciJ+vTMBhVgmFLQvII9SijCcJ+69E6saIjDow8hL6wsl8MxRRTeFR0SLAkDYSQn4IfDcNDWWCQcBmnEcdh6ENKv9yjD01Oq7fA/dWq1/4DEX2Ue+jao0iK8ABxve2kKSHemegtx+ufsMAeQbZDqd2UhE1c4CUOoAZaAs+dyCDnQC4b63EkDRCCYpiher8+e0oerT4oKNiY3GGaE4Cl7/xFI+Rl/TrXpNCJuUq1wOkFs3bdANB1WbakQtf5Qk8b1az50aaJ7xg9Tpr1uu4BeRvUI9zeTPSTMK8ku7HCbcvJWcsCxRZBs+ndGcf/kW2Gov6aubmqynWtxFT3e+DUXE0ctpxwsFzPF7CsbIRVh9p3ru8ZTr5QRnG5HMqk7LKQU
 80jrECZH
 gk6Hnxqt9RMjZwJ6kQgBxHNSExwPzkd7KJATwkDvGNA0K4XBd1TGM3hCU2CN3lACuo0fY6OTyLNwWh8clipbGKyF1FJu0IgWmfH87hdA5ljIKte1vhUMG12ffQSuXrEoJ6/ES75kqNTSJJrO446HLd0Yo/ANQyr4BYNOA9t+UkskYi7tmxcWmJx1u/+8VYe6LVRT/5ZW87dJB0u3NZIQS7DEYr+H7gleTSD7AcpHDlA+xM8HQVESls1HUMxH3nLeQkXwuAZqi2SmtMeE6dYpVyWOvnEgMVeTvP4RDjdA6mNBEfKA3marmDQJxR/DJLx20qWejySh5TUkG18FutfFS+AW1pjDVtq6rcR5Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 08:57:57AM +0200, Michal Hocko wrote:
> On Mon 13-04-26 15:39:45, Minchan Kim wrote:
> > This patch series introduces optimizations to expedite memory reclamation
> > in process_mrelease() and provides a secure, race-free "auto-kill"
> > mechanism for efficient container shutdown and OOM handling.
> > 
> > Currently, process_mrelease() unmaps pages but leaves clean file folios
> > on the LRU list, relying on standard memory reclaim to eventually free
> > them. Furthermore, requiring userspace to send a SIGKILL prior to
> > invoking process_mrelease() introduces scheduling race conditions where
> > the victim task may enter the exit path prematurely, bypassing expedited
> > reclamation hooks.
> > 
> > This series addresses these limitations in three logical steps.
> > 
> > Patch #1: mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
> > Integrates clean file folio eviction directly into the low-level TLB
> > batching (mmu_gather) infrastructure. Symmetrically truncates clean file
> > folios alongside anonymous pages during the unmap loop.
> 
> Why do we need to care about clean page cache? Is this a form of
> drop_caches?

The goal is to ensure the memory is actually freed by the time
process_mrelease returns. Currently, process_mrelease unmaps pages, but
page caches remain on the LRU, leaving them to be reclaimed later
by kswapd or direct reclaim. This delay defeats the purpose of
"expedited" release. It’s not a global drop_caches, but rather a
targeted eviction for the victim process to make its memory immediately
available for other urgent allocations.

> 
> > Patch #2: mm: process_mrelease: skip LRU movement for exclusive file folios
> > Skips costly LRU marking (folio_mark_accessed) for exclusive file-backed
> > folios undergoing process_mrelease reclaim. Perf profiling reveals that
> > LRU movement accounts for ~55% of overhead during unmap.
> 
> OK, but why is this not desirable behavior fir mrelease?

In Android, lmkd kills background apps under memory pressure and then calls
process_mrelease. If the memory release is slow due to LRU overhead (~55% as noted),
it cannot keep up with the allocation speed of the foreground app.
This delay often leads to "over-killing" - killing more background apps
than necessary because the system hasn't yet "seen" the memory freed
from the first kill.

> 
> > Patch #3: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> > Adds an auto-kill flag supporting atomic teardown. Utilizes a dedicated
> > signal code (KILL_MRELEASE) to guarantee MMF_UNSTABLE is marked in the
> > signal delivery path, preventing scheduling races.
> 
> Could you explain why those races are a real problem?

The race occurs when the victim process starts its own exit path (after
SIGKILL) before the caller can invoke process_mrelease. If the victim
reaches the exit path first, the caller might lose the window to apply
these expedited reclamation optimizations. By combining the kill and the
release into an atomic operation with a dedicated signal code, we
guarantee that the process is reaped efficiently without competing with
the process's own teardown logic.

> -- 
> Michal Hocko
> SUSE Labs

