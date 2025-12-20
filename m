Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A7BE67487
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 22:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18936B0088; Sat, 20 Dec 2025 17:16:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9C566B0089; Sat, 20 Dec 2025 17:16:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EAD6B008A; Sat, 20 Dec 2025 17:16:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B76BA6B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 17:16:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1201259BB8
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 22:16:06 +0000 (UTC)
X-FDA: 84241258332.25.54EF29E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4155740002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 22:16:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tMGSOVJ7;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766268964; a=rsa-sha256;
	cv=none;
	b=mFyr5I+md4KaUrEXMs7paJijwqucgQ3Xtqlu5Rf7mQQ34qQnFgqYhogH1hQKYgBlkkU391
	sEUil4Gh8sygvNim07shWYFhK6CdhHJbkZ762KW+8RAwY1ffrvKXtqhJfIPwkpdHrxZR3G
	cRCHjRy6BeUyyhZqfiKzw1IyFEsvJEE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tMGSOVJ7;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766268964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CtLolb+mpr9HB8mCDWrq88zlVuvUxrh2LkZqNu9zqM=;
	b=Nl1K40Szgf9Vmg9CLIc70u1J+9Ojh4LH6Gi2nDFTBpyY+Pkab8Pb+urBUPffwwI4hU9aJF
	5/QqKzYpeR5AAh5RLdsQQmmQ2mVerDW3buoWK1tALLgRMyCK0MlE6pR599MhNuk7xB05hH
	3e7FxWY8NLG/xXp9ql1yFD3wU/miv4c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E6B8435CF;
	Sat, 20 Dec 2025 22:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEF2C4CEF5;
	Sat, 20 Dec 2025 22:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268962;
	bh=eDFY+632LEAOsKRJQQq/wHU8+MniI96pKzXiKyVhIkY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tMGSOVJ7fM4y8KXLFuhaX2f5FOSPRx0b6ITrdy79OyMHzpfKgj80TDa1iNtP1h0hS
	 Oi28VPjZ6bMikXlAoTV9sPDM/2ovWxHFfb3frc0jxT+ofRcfo6k73rd96Xc8vpJ7lk
	 SqDcTC10OvCyvSESmjkP2gGuXSamET7nJnv+amSk=
Date: Sat, 20 Dec 2025 14:16:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Rientjes
 <rientjes@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE
 THP allocations
Message-Id: <20251220141601.e6694f904167bf12fa319a89@linux-foundation.org>
In-Reply-To: <20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz>
References: <20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4155740002
X-Stat-Signature: tdpodchw7hzj63abxwr8zofkjkf35q8y
X-Rspam-User: 
X-HE-Tag: 1766268964-496309
X-HE-Meta: U2FsdGVkX181/hlY7HzHlOcC/luRRzK0WpRdQKaRyG+EHqOyeYRY9AHZqlkww6bvRqEMfCDlpVyuaa3pPSQxTnt41UXDJ9KBl5KXRcY4touzMIwwoMtmIygLUc/LUTbSiC5o/vLqpQxnUDzOzm24UxdCh4ZRqhaMHbSUMnYLnTjJp6/Ic4EcimPx2E9D1FOenIiTiR/4FQzzDvE6lh6TbHnHVUMYr+tQ0DOGTI0SJrzzHN5e4C9pj61EYYlXRXiNF1KIae387yGD1sI2JvpkZjKZPYOXq/tQohunrO4APBOm6NjuRbEV3fSHsxQQwTnGFS72IphcmM9aoReDt3AVQUUSHZRiwovBRHSR1n74jE6FdxRJtu95APLkHav0a4FjurU8I3WLq8VvqhQoFCkNCkWSj7fPBZTE10q+cp4FbPsmYDH37fE8ubqRGIzSNMt4BtUEN+yJln0F1+9ObnQW6dn9RSNWRNt2y0kdd9gU33UuUBJinCThICpbr4mH1ODBvFXCfa6D2HaUwKqJlhWhp+vwiKFwdk94WTEn3hn9mYKHqvZjShSsb1fB3zalnQGXLICW04zzCb8WYFZWIWXy0lfgZG71FdQUAFmQjSoaSFUStyw6K8fItM1wcjunuQgWddgZQFrkXRxQastMq9mFIfrMUpUR3zCm0oW1NL5lkNYQZi6/PnKlEf5G+zyR0TPkEIpC1qYbd07/8fXMn7uvG3TIOYLIUqjmjkZhxclup+/fiVNYiqHGuXbXejrVhecsb1k2acexf4hyna+i5qjadnBTJn9C/SLXjb3VeKx0qwrJVfdtraoJSR2Pz5sPivWOoJlr+GkB0cjIauMilleQwY0nrfHx3SxOQ7tvJ4CVElyU6y5fCqTXqY5TLg3s8awBAzJ6ZkEaxupHss7aXuYpez8YTKw7abIYqlt+xvpJXcBr/RLIYyA4Cc26IigwCZu2vmbEJl2YDv8RDGzwFj8
 p+KOryxp
 1D4nxHkosre8pmvqRmQr8H68LzyntZGtS2A9VSMPoYIgqz0ysmuWYq0JMFqeHLrLh4BcpEAKtNlHYOVM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 17:31:57 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
> local-only and all-node allocations"), THP page fault allocations have
> settled on the following scheme (from the commit log):
> 
> 1. local node only THP allocation with no reclaim, just compaction.
> 2. for madvised VMA's or when synchronous compaction is enabled always - THP
>    allocation from any node with effort determined by global defrag setting
>    and VMA madvise
> 3. fallback to base pages on any node
> 
> Recent customer reports however revealed we have a gap in step 1 above.
> What we have seen is excessive reclaim due to THP page faults on a NUMA
> node that's close to its high watermark, while other nodes have plenty
> of free memory.
> 
> The problem with step 1 is that it promises no reclaim after the
> compaction attempt, however reclaim is only avoided for certain
> compaction outcomes (deferred, or skipped due to insufficient free base
> pages), and not e.g. when compaction is actually performed but fails (we
> did see compact_fail vmstat counter increasing).
> 
> THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
> which is not the intention.
> 
> Thus add a check for __GFP_THISNODE that corresponds to this exact
> situation and prevents continuing with reclaim/compaction once the
> initial compaction attempt isn't successful in allocating the page.
> 
> Note that commit cc638f329ef6 has not introduced this over-reclaim
> possibility; it appears to exist in some form since commit 2f0799a0ffc0
> ("mm, thp: restore node-local hugepage allocations"). Followup commits
> b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction
> may not succeed") and cc638f329ef6 have moved in the right direction,
> but left the abovementioned gap.

Cool.  What are your thoughts on which kernel version(s) should receive
this?

