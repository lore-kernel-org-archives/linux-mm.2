Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3142C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB186B0088; Sun, 13 Sep 2026 23:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8720F6B008C; Sun, 13 Sep 2026 23:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787F06B0092; Sun, 13 Sep 2026 23:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2266B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:23:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 422E71A08DD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:23:17 +0000 (UTC)
X-FDA: 85210922034.29.5F683C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8A7D414000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:23:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AzmM2RxT;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789356195;
	b=MPL62az4zOK4UF1edHVYI26IVr35sXrKdTFycxLrDQjgtJ7TqJtqc7h4vqL9rGosYhKZrH
	ruaYuWZ5r3VjbDkDO27R33eSKJw6R5pg4leEEm+0y/uNPDVBPE9YR/xnvJpr2bjeewG40m
	9QRJD/ud4vwhjVzJ8oICYyM9l/8g9kc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AzmM2RxT;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789356195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sg3f98BxUMWsi0jHBDrkEMS50jrFIb0Q1qn6f4dy2+U=;
	b=d9hyZhLNatNszfJWOrhkUUH79I+x4xHzgzJg+baxV7atOTHkA9woUUgOOr5R194U8dzG5Z
	Q6Nppyi9V2VJqjGZh7GmZL2nOw5oPdOAbc2jtT1DNGBVkkuYNp2ODG762sjHb72bYqhsuA
	DvkD4hjx6izrLQtyC3sIm9zL38Ofwp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0695B60AA6;
	Mon, 14 Sep 2026 03:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618721F000FF;
	Mon, 14 Sep 2026 03:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789356194;
	bh=sg3f98BxUMWsi0jHBDrkEMS50jrFIb0Q1qn6f4dy2+U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AzmM2RxTMzOeloRCcPj3pFvD/yvKblAnyPrFI6Z9Md5JhDeA+WTxOvXz2EDDjwCrR
	 3YvQsujETxFUV/8J6j/GCLTTozaLIIBk5hn2qNG+snxduDo9vW7EWEtB72igXqQt6Z
	 R+zE6wrRJNPvi9Bd03F2gJI7/oTmETzwQirgN4/w=
Date: Sun, 13 Sep 2026 20:23:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qiqi Liu <liuqiqi@kylinos.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: apply per-task GFP context in bulk
 allocator
Message-Id: <20260913202313.6c9bf636f773fcacf573af03@linux-foundation.org>
In-Reply-To: <20260914024555.138125-1-liuqiqi@kylinos.cn>
References: <20260914024555.138125-1-liuqiqi@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A7D414000A
X-Rspam-User: 
X-Stat-Signature: 5pqfxg3w8ozpjs1aimirdsqko9i96q7e
X-HE-Tag: 1789356195-256286
X-HE-Meta: U2FsdGVkX1/KrDogTIwd7a3LAsVxj+K2oluVBNJ4aO8OsEwFboeeNSgMV5kZ1AYHk5GsQ/83ZpytONadwV0u3kTTQFDyl4hf5A9wn9DLUmNSTYZPZzKDxVhPx2W9Rrz8vpvvm/xEMgC+/xASrrcirM70ky+IaU/as9TAq2HmfGoy4hIJtb/lCiFE0c7SHt/VftQbth9weG/9IWBcRM6k/9x/Ck55uwrpAIt5YEzKhOd1LKiczcRrw5TxZx+zN80YA4LP3FcLrQF1vAgbzrJdS8zmB/jmXetyGXOqSDFM224BnE32uG8Liq2wRoYByqpRi3szo7E5xiwetIVcH7GmgJG4Yr18VFacx17hF/pZOtTA/X6yxhWN/kHtgSaE19tqFOQPxOBBFZ6m6bxTnrQ6x+uaiiXFYusHhci7i9F3DFU93XJ6I59v2qj3X8xOWpB4alHit7xJzD8mEK1nviP6AOe4x8VSz2NiFzgon1exZoVOKZWXkTmTmNtH222LcE0zg+StfXC7MXO3sa11OP1j4i52rF9lPVGFVT5wbw/+xHcFvFCV3gkT7angX3hILODFXfb01jeEtZH3MCF9NpSrpA7sIU0o59fz88BTYeTScYQQmi2FSGWMCDlRoS9kIl7VoyYUGUtIbe3HxlftWbZdD2FWXSD+OSvC5ZEvbGV8JWhqg/30UxfuFO24spAczBZzzfB44OWJXWkc8bdv5Uo2CDpG+Ww4egX8vkfs+ll2FI/E/KtQpYOp672EFbBhnVAs3rtl3Zry47FjcUXav/x8cwq9EhCZXLlGOr9t7fOVb0ilQpaDL6afUq7TPPNaiuGgzZ/B0qwo8t9FG2uiE+1k1xHL9mTvUXQEzqyx53JtZWaQahzgkPVPudu2pZX9Ulmfo8ZAGGAIpN4XdHziwEqvZ9cSMS0J81uO3j7O9ZO7FsXVvdHq963SrNgyal9R2P0C+H+Y2wGpYpAOxiJHT0D
 iRb3tVVf
 byrxMQdLFD94DtMk+rGXYcdI4zZXksjHFcWXMLqj/tec87ZLbcRzc5qpYb31w8XkHdW4ln5+E3z3CTSs3h6pmIiGkAVqP80VL+x1SCHHjuBa+NljQdnZEfEOr0hE4YDJGxUJVHQYDEwN1mpHPx43kwCz8BbDHUwnfEUBxw3pA7RrXwCcDRlA7v+uoEgEryrSalTRPXip57JVv4xrEpePXetMJcDwDrMImGQUTvtCR6xAPopVp7SUsIe6omty+Yb6iAoLl3Jl+bLrk4LjHBkULK+t68BpNUp4XlXb/Ie4N00uJsQSAbF1M4FaE5nGnsN0OKYvG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 10:45:55 +0800 Qiqi Liu <liuqiqi@kylinos.cn> wrote:

> alloc_pages_bulk_noprof() does not call current_gfp_context(), so
> per-task scoped allocation constraints (PF_MEMALLOC_NOIO,
> PF_MEMALLOC_NOFS, PF_MEMALLOC_PIN) are not applied on the bulk fast
> path.
> 
> The most direct consequence is PF_MEMALLOC_PIN: without clearing
> __GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for the
> PCP list, and a task under memalloc_pin_save() receives movable
> pages from the bulk allocator.

Thanks.

When fixing a bug, please ensure that the changelog fully describes the
userspace-visible runtime effects of the bug.

> Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
> Cc: stable@vger.kernel.org

Especially when proposing a backport.



I asked $LLM this question and was told

> This can increase fragmentation and interfere with compaction or
> contiguous-memory allocations, eventually surfacing as higher
> allocation latency or allocation failures under memory pressure.

which wasn't so hard.  Please update your organization's prompts to
ensure that this information is always included in changelogs.  And, as
always, carefully review the LLM's output.

Other useful info to include in bugfix changelogs:

- how was this detected?
- is there a report from a real-world user?  Reported-by:/Closes:
- is there a reproducer/test-case?  Did the patch fix it?

