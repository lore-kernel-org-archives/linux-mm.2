Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF41BC5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 22:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536516B0095; Thu, 20 Aug 2026 18:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E74E6B009B; Thu, 20 Aug 2026 18:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D67F6B009D; Thu, 20 Aug 2026 18:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16ED16B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:49:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BA7B160321
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:49:17 +0000 (UTC)
X-FDA: 85123140354.08.50C3D77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C979340004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:49:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hOb19F3A;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787266155;
	b=u7Hjv9Gnzn+WbT4B/Hm/Z8su7qWmlA2nWMIdbt8TnP9I1soZMAuVy4mP4IzROnj8vqp89C
	wbxqMjnPfHoD2KCAixUJDAgaNEAJhUsB9fCtq56el9NPFCnC55Yi2WDUBXxhuuKPqgAkSa
	QMlFsj99KB6t5VRjbt+vDXL6ZMQ0c2E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hOb19F3A;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787266155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1tHcHGbIPLaDej5OevvXkdwoi/qHvPdSwnHVriPzTo=;
	b=Hs2AmrRBq4zv9nm1qvgK0XqMQLVqvCVsRtUJZpVEJtCPJsGLh/tVGz2U7Gn+IEX001JPVx
	GU0rnda6QQI1izHLnY/rDr8z26n7oHkKzFK8ezJxHrK+6DlNzeqmyznF+5+/QjlGT7Hc9M
	kuHjgCB5n6Bf7xIpugAXjK6q+8/xruE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0362460A58;
	Thu, 20 Aug 2026 22:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449B71F000E9;
	Thu, 20 Aug 2026 22:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787266154;
	bh=l1tHcHGbIPLaDej5OevvXkdwoi/qHvPdSwnHVriPzTo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hOb19F3At/3ryOyPPVSG++D0gS6NZEK8Cqy1nDreUNxcrQj5l7g5N6OlwLxZ3hyRg
	 FrTDB7BfjA9sjdiAlQGJOo3jJqfz+3r+X8h0O45h2yHyEOy0QF5Ks2nYbwMTvCBlug
	 g0AneDFXAN7M04L743USCvqSJwkS8MC56NgJ5CFE=
Date: Thu, 20 Aug 2026 15:49:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Mike
 Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: add per-order allocation slow path
 statistics
Message-Id: <20260820154913.3d6a821f6ba5c1f81d134a0a@linux-foundation.org>
In-Reply-To: <20260820133659.712111-1-d-tatianin@yandex-team.ru>
References: <20260820133659.712111-1-d-tatianin@yandex-team.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C979340004
X-Rspam-User: 
X-Stat-Signature: 7hg3eb5rj1btp3q3aj8z4h3nb5qw8e9t
X-Rspamd-Server: rspam06
X-HE-Tag: 1787266155-89949
X-HE-Meta: U2FsdGVkX1+RM46foWCqJPmvK3E2kifZqS8eIMxrJ9u/JomswO9Y+SZmP4p68m2ESQWO7JhzHyqbq1cdCM7JfwF21rGstEZMomCKFhRRfU00FsPMsyWuihDR1S8CNvbZ78XmXZkJcu9yfnays723kaOy4dT9ICg7NQr09WXY1N3zPDOkUvrooicTU/I21iVqGblE7jdEQLER3HlZueOJWI/V+arRQCLIc1qP+kBQx1qjkg4g+bCtEetNUMSmHA9gveqsGZJK9M1S/1OFvQdz1Sl/VA5I3eIdHV4xDLWM+5gdxZCDsQ/Y/oUPgLeucmEgkg29CvQyaRkcmtxSs9MTKrEAZFjQPmSfxeOqmbajJ43c5D83UJRuHIgL5yDykFF5foTsIj8Ty9HUyuDuaQQlxyywDwNC1Ec2fWGbau1XI3urQnyU+LqSwTZ3nkrz6/B6F6ELH+i2kNXbx1PNYodAMwKQZVNMLMOoaFAzYOCeuPKyX1u2Dyn/xMRLOTcO9koV+cYuh5EB70i8w9Yqot67sKTD7gJLnHIfweS6Fi9vPH/xlxkmNPgSs9AEvjGoihaskVAXfoFXSyZBOevZuxjkS2mS8CYNXGUzjYoRQFrVDY9vQI92VYfkAfY1wGRDWNFF3TujlFugxVbKHVbD8PnO+tcOIqlvHjzx1py6/uF1ey+tm9PNlgjEl/cZAxcr6qsMACL5FdxuCI+TutR0nqPEK+Zxt+BiX1LbFhV1q4Nfs+pqF/8ITrqYnyRR8gS0nD+oovZ9LKsW9YAKDaszjvtW1BRbHHRjIHHJglMB7QWsdwjdXEbdQa0J5Y54bEyt9GkHSMxOX9P90S0wabcvTiHhquYIsDd/Q+tw9o9beUn00Bm9DdAmDtM8g8yDNKwezEPzs5zH59U3eIrA6tGWT1T0CBRaOynyDoEB4GRL1kAhipGLPbSz+C8gl4sE+2Yq/VCgyPyS4pBHK8wlaYmgEVc
 L9fYsiSv
 opZr2BiI/jaLxvKHNdh6sQOokuwFV/jBvxgu3+NIlvpqsqXed20h0TY3ZkAjRhb9U2kmobyga2xLNqAPY/dSlhkeXmkJuNyJeoreSqIIhOXjblP1oN1GrOyFU1C/4it/6x6uPk5zn+vQ/Os9NudU9gkof7M9W+s1kfWzoF/BXI4iRusgtLNdRouw6wy0zfX3cl0YhTjXpICYXf7/0wqc06gBxaUVT6zd6M2zyNPQdvQHu3ekYIyliMaxsPZMDrAyM9z2vX0P6NB07bUVgT1eGi+HQ1BzHBBxpmi+LclFvuBBIOXUs1AQRGLIjwruB8CxOPet7O809I7dv49wS6UNxuCIv80xw2H7wYXQAJsPyfSqpcGz5rMtjTvYj1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Aug 2026 16:36:58 +0300 Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:

> Production incidents caused by bursts of high-order allocations all
> entering direct compaction are currently hard to attribute from
> /proc/vmstat: pgalloc_* has no order breakdown, and compact_stall does
> not say which order stalled. Tracepoints can recover this on a single
> machine, but they are impractical as an always-on fleet-wide monitoring
> source, which is what is needed to correlate latency regressions with
> allocation behavior after the fact.
> 
> Add per-order event counters to /proc/vmstat, covering only the
> allocation slow path, so the page allocator fast path is not touched
> at all:
> 
>  - pgalloc_slowpath_orderN: entries into __alloc_pages_slowpath(),
>    counted once per allocation, before the restart loop
>  - pgalloc_fail_orderN: allocations that returned NULL to the caller
>    (including a successful allocation freed by memcg charge failure)
>  - compact_stall_orderN / compact_success_orderN: per-order split of
>    the existing direct compaction counters, order 0 is omitted since
>    direct compaction is never entered for it
> 
> All new counters are purely additive: the existing keys are untouched
> and compact_stall == sum of compact_stall_orderN.
> 
> alloc_pages_nolock() is deliberately not counted: it is opportunistic,
> never enters the slow path, and its NULL returns are expected rather
> than failures.
> 
> Counter names are generated for any MAX_PAGE_ORDER the arch Kconfig
> ranges allow (10..13), a static_assert catches larger values.

AI review got upset about this:
	https://sashiko.dev/#/patchset/20260820133659.712111-1-d-tatianin@yandex-team.ru

> A per-order split of PGALLOC itself was proposed in 2017 but stalled
> over fast path overhead concerns, restricting the counters to the slow
> path avoids that overhead entirely while still capturing the
> allocations that cause latency.

Seems useful, thanks.

It would be easier for others to understand the proposal if the
changelog were to quote some sample /proc/vmstat output.

> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

Merging patches from Russian-affiliated individuals is problematic.  As
I understand it (not well) it's OK if the contributor's organization
isn't on the US's OFAC list, and it appears that Yandex is not on that
list.


