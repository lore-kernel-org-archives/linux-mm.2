Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA834CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 21:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D94D6B0088; Tue, 23 Jun 2026 17:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889F76B008A; Tue, 23 Jun 2026 17:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6F86B008C; Tue, 23 Jun 2026 17:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54A9D6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:17:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3E0D1C46BE
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 21:17:44 +0000 (UTC)
X-FDA: 84912439248.14.0076A99
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf31.hostedemail.com (Postfix) with ESMTP id DECC920009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 21:17:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EiiAa4bX;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782249463;
	b=XZJILtNNGZg+Tvwxj4yeO0FXuGGYnb+MBfDopV5uokzjgeslPaBDQAD2oOck/ylGMrR6c5
	91pFrzNcC1pGmjlmJWRsZIMEh1ldm4sq87q3LKss4iwuwYXj/8jcNB+hWicqJtpLasp+Za
	Y6IBjH8pv0bU0UCWNRXKhxQ/kr4lYx4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782249463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3MOrrXNnFkBZPkEQOlLJbV9bk56PLzLI3wAWmrou28=;
	b=4JaeCwlALVEjaeVnRpofafaWy15oOSN0sBAb3BDtpWCekHxtvt1aKGzb94M4dU3TQmbAE2
	tx7GJksvP2YsSyFnsXV1le27YsAmBBWNh/9lJHdwsePY3ck6xt+pOicT09zgwtyTb5ZRVo
	7kPzU8aV02QQB/OQArGlmaUNOzcl5L0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EiiAa4bX;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 23 Jun 2026 14:17:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782249457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p3MOrrXNnFkBZPkEQOlLJbV9bk56PLzLI3wAWmrou28=;
	b=EiiAa4bXexlgD2tCzip5KVShTk55r+tRf39OnOz1UwDf/PGoi5WCIozL1Ojag+kyli7rgY
	OEV/xFU9XpGHPab2WVGmAAE915MwDmFvwZ5vEkdyl4hIoSIbHhkg43Lz6LoYKgzt390LSS
	SOyFlfHYa8fRWhM6g3neG4A2VnYvU9k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	fvdl@google.com, linux-mm@kvack.org, usama.arif@linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_alloc: use existing highatomic reserves on
 the buddy fastpath
Message-ID: <ajr3uCOXe9qf9zhT@linux.dev>
References: <20260623004600.113347-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623004600.113347-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: r9qm1e5i87s6q89gan9aq86of97jgyde
X-Rspam-User: 
X-Rspamd-Queue-Id: DECC920009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782249462-94991
X-HE-Meta: U2FsdGVkX1843ZQkMsVEhb7nQ2zBCwAi0Dfigohk2urOzna5KWVQGX1td9pLGNxHyvYVGXbHGTWGEbLibUQebVMVQm12puJxWbyrB8bPzWlYVjU/DhB6N79nq5ThU/fRuJ8FY4yk1rll3HBZiH3KZy643PipiSRCEL8buDKZUnKtCXQXbjfLdWjUjCwq+rpv5MPKl71rogkgHv2DX525xZvoQwxDAFUd63Q2fQHpBeo3QY6M6p3IVGunJVh+R30F5l5Q0QCh9Y6vBaRLKjHLNmRZc7x6jAWGOuUDB6F4jof66NgUaWDNixbg76nJrdADRSInTDVpCErZz6GEEbdHLm4IQdaSbj1HnDn4+p7QiDr5Lh4KwXek1QirbQMcAzDGvX/nKxbRAVhTKAupkHY13NXxtelrXgE0fGL73uAmPPQEM5DzQtfTaKPvaeUvCZ2xc+kFmLnkdZ8QBJ199l3ZF2r8w/TSHJGVObbUBl3EVYv/6RoAL+ZQGhxLPS6DGwpp/w84zxYY0VhCbRQm9mSQApAfzVwjl7S0EDIGGWvw+jMHSkpvgsxWKYlEoDr58Bt84ElY6P1Ge6btofdQMEKsxRj153X1+apeDJuP1Ypk65nR6G89qqCVHk0L9B3xVnaEcqkg6o+Lw5vs4HsF5IPhVH/7pUKC48HPRoJuD9qEU9h+2EZum3JfHlW5yzEuFZCu3pHyZ1hR8R4vJPgDd/qbaXEbaFw4lStGpqO75Azm/QJsxETq/b2oBHWBP77cU8tQA5EPzWRZS6UY33WjGDs+JHo7ndoz8IIsqX3mUDQ+9DhYXCRHHG/FPNsG9rORWG0EhXLkNEV5hGWUqrimSYeskGxxKpbLT9HOOfYwr7cGJXhx/+cTykcZYrsmyvcvot61/me6NgGc/Nf7ueSZ7fJYkzW4u/gYYCnYOUW+gnM+Yf/MxRBtj657zFidL7nYrn9WrUSKrTLILAl/b1hdoZ3
 jzDVtXad
 8CXfbGs9eOQpuJYlDyzxYoQh2ADthhezUEbOpe9pbZk2zduDuK+BlNSDD/6wsuLHNGCDUIkR+LLLOUgLVNHNyFXfUHJXjExAQB/RCAIA0xF4GLhF5wEhK3xONcwalrHBe/f0CFdp5IcB0zXWNDFHZS2gaFfAdkWABZ5c4o/zHis5N5eZ58DwmCliWOIvmvgRdipueLEWB0wXEzO5OQmNO7IGP2ohBAst6EZjronF4yDNCdyn4Fkhn51t1SNqm+iZFDdm6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 05:46:00PM -0700, JP Kobryn wrote:
> ALLOC_HIGHATOMIC currently provides both access to MIGRATE_HIGHATOMIC free
> pages and permission to create new highatomic pageblock reserves. This
> makes it unsuitable for the fastpath.
> 
> However, the fastpath can reach rmqueue_buddy() while MIGRATE_HIGHATOMIC
> reserves have free pages available. In this situation, the allocation can
> fall back to other migratetypes without trying those reserves first.
> 
> Allow high-priority non-blocking allocations to use existing
> MIGRATE_HIGHATOMIC reserves on the buddy fastpath without growing them.
> First tighten the criteria for reserving pageblocks so that growth may only
> occur in the slowpath. Then allow fastpath usage by enabling
> ALLOC_HIGHATOMIC when the GFP mask describes a non-blocking high-priority
> allocation. This logic has been factored out from gfp_to_alloc_flags() to a
> new function gfp_to_alloc_flags_nonblocking().
> 
> A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
> available in the target zone. Before this patch, the workload did not
> consume these blocks. With this patch, eligible order-1 allocations
> reaching the buddy path consumed existing MIGRATE_HIGHATOMIC pageblocks,
> with no highatomic misses observed. The workload did not grow highatomic
> reserves and NAPI page-frag allocations remained healthy with no failures
> or order-0 fallbacks.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>

This is awesome.

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

