Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B51C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A38D6B008C; Tue, 15 Sep 2026 02:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853A26B0092; Tue, 15 Sep 2026 02:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743406B0093; Tue, 15 Sep 2026 02:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC116B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:32:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B36D7A015C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:32:12 +0000 (UTC)
X-FDA: 85215026904.03.1CB08D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id F303D40003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:32:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w+mQa4vO;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789453931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5llc/XFrwgAZPw+/nwYOk6K5xOZoxnoq0F02YLYa//A=;
	b=kutL7jWTcuHsEkxqRlu8Q9+fQWozFQmeprL8jirT5OTC4T/gphfrdC4M40DKYYNJX3SnFy
	jYH9qfe63gQuo+9Ai2AOXKnftsyyT+UKH2dg/GGbNFTakYP6Vg//BfGMc8uHHfHJO6ptp8
	GioLNLjFbVD3Si4sUXOOfatXLczXjUU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w+mQa4vO;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789453931;
	b=Vvo/5U1rckuVR3uigX8GbJdYK0FZfAtfq1yFsKW/Qn5Q/qcrhS1IGnwx23HcsFaZ30bmxq
	B8JDOXHHHPD7JeWufyjrXdK/Aec+kyNLS1msU0ZrG7niankzqTWOYkCdPIND5bRYKiTlff
	C1VXItwHllv1v1zEQn73LoeqpHo94rA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2411C42EB4;
	Tue, 15 Sep 2026 06:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E011F000FF;
	Tue, 15 Sep 2026 06:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789453930;
	bh=5llc/XFrwgAZPw+/nwYOk6K5xOZoxnoq0F02YLYa//A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=w+mQa4vOvtao461etFNy2bwuQJ+upJnsGwE652+hpGOEoMlk/nYky6EIgrV6KXRUy
	 1cbKTVEQtCFd10rtBgeGldl1NksNKCc9FNi+T7C7F2GF9AA69QyHCrBJJxrwrLvFDK
	 PlNehJyAmx3ZMc8TvdW3h/3/+TR1fL97TQ1ZPl6s=
Date: Mon, 14 Sep 2026 23:32:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org,
 jannh@google.com, wangjiexun@tinylab.org, sashiko-bot
 <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart
 fails
Message-Id: <20260914233209.3fd5a6e848ee82d13e43a301@linux-foundation.org>
In-Reply-To: <20260912110832.3203902-1-gourry@gourry.net>
References: <20260912110832.3203902-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F303D40003
X-Stat-Signature: ne9qaizg9okf1g6ff73k3ghyqkj45uy6
X-Rspam-User: 
X-HE-Tag: 1789453930-167462
X-HE-Meta: U2FsdGVkX1/57qM+Z3DaV7RwHcFAXqtVruXISX6iM8/14VZvdr1FnU7p4KabQ2mnskh+QmSi3yNxwSNeMcXiM2hPEr7pxo8s+lFF/iqAI8dhh1v8Ik1dKvLruO9sFrgxw5L2fIch/pVG+Cu5qMl5bOFVtnJ9zeRzr8qI/w0J61OHpg1678emjqbvEuW29MzEb9v+v9fSiAK3toOz+U2D3BzGhPEoOC0DpGNkcYnFWMhP3uNjGsjQW+rWUGzoxqLwjZjQ8pjSoJgSGVgljgx1w64oGT4s+61pVA2HgAwpKhfjgmcGm9EinEMcbpR+zxKkq6q3xZKJh+dkiKkHqByYR3DT5DSaVNHvHwefk9opIgdGP7xFEojuGPE25tCFwUzyeTpSkgaWcoGFe3entVhu8+gEHB6EDPshj2SFXs+17R5qB2Qei5Rbp/5sAqB9fhgwW43iqVZ8SA0fzgR40LxRzKUXmaxoCVhjFqahQRtFM+Zrw0WcT5CUZNgeUMtY6j2SjGrHyakzgmCaSbxNeX9gybjRx/rLeJoSxgcSN3K0VLU2ZwQBMqTaVeRIrjrgki8IhwBEjiWefvHW1srXymjppe46JXTKfAC3UJaCdHDNF23zMF1D5S1ymLGg9SKKCJwrkV7nJtgdjR/RkCgVqJpp5TNPDuRYJ748v7QVH0/K2M+i3pkFhlv32L7cM9hD29DpwaQwrpw7FnCKL0laQzECAOZPsKb4QpJidjAz+H4dggvZEEv/1Kgg9X5Tyq27vN81HyRW4FLDPgaL4xeCPNeix0Wmegkcbn+0BBjYPc93HwoXg86jFyANF2ehp4YLDoc0yTcSqbUA/A8l7bada7dRshEUun5bUYV815VXs3i7TvrsrmYG/oMgoLj4xM9kWZ+h/LM4IirpM8jIzptjrm7dMHdg75vVzaXxEhTcan6DEgFzyeGjTwco1eDIbBEoLUNG9igrTe/euaWwjU8uPoZ
 ozwwAWQd
 5/Ga0HshNa24lWf4MOEZn96o18c660fq/l2dVF10FzDDFqUutDeD9WQKDeknJDc/Df0jo7bONKlp/C4k24C0Qel3NVByYRfYgZG3D0X0aqgBHAlbcBeKynIPgg16QAYFY30HQNKSVGAogbp+hJRnejIvt4VbGzR1gnrbAKezKR6m7WzLmz+Ua8QFYysSTZphENi9uUuzZnjC97sHZvCBHRRxeA2CLcxnMs+QbDZWfgUDTIrnSqMi1sZ5BACqhwRk12M9Mamon6X+a+ExLPjcYRFyxICJvPuOR0N+HgI60OUNFIAiakCZ5xq3+W357+jdUAhHTFPA1pvBN9HY1Xnst0xJYoJVpQ5sXzjvwQ7CUra2FBEvy1qVl9usD09TY56JQF9YrNZ7e2MdlsJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026 07:08:32 -0400 Gregory Price <gourry@gourry.net> wrote:

> MADV_PAGEOUT collects isolated folios on a local list before reclaiming
> them after the PTE walk.  The reschedule path drops the PTE lock and then
> restarts the mapping with pte_offset_map_lock().
> 
> A concurrent operation can remove or replace the PTE table while the lock
> is dropped, causing pte_offset_map_lock() to return NULL.  Returning directly
> in that case bypasses reclaim_pages(), leaving the collected folios off the
> LRU with elevated references.

aw man, you got so close then left us hanging.

So what happened next?  Machine crashed?  Permanent leak?

> Route the failure through the existing cleanup path so any isolated folios
> are reclaimed or put back.
> 
> Simplest userland pseudo-code reproducer:
> 
> p = mmap(PMD_SIZE, ANONYMOUS);
> touch_every_page(p, PMD_SIZE);
> parallel {
>    while (1) madvise(p, PMD_SIZE, MADV_PAGEOUT);
>    while (1) {
>        madvise(p, PMD_SIZE, MADV_DONTNEED);
>        touch_every_page(p, PMD_SIZE);
>    }
> }
> 
> Reproduced in qemu trivially with some explicit widening of the race window.

How was the failure observed form userspace?  (repeating myself)

> 
> Fixes: b2f557a21bc8 ("mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260821150912.183976-1-gourry@gourry.net
> Cc: <stable@vger.kernel.org>

#include "Documentation/process/stable-kernel-rules.rst"

(sorry, getting snarky.  I'm saying this stuff 100x/day at present and
it just isn't sticking).

> Assisted-by: LLM

Can I suggest you update LLM's prompts so it checks that the changelog
includes userspace-visible runtime effects and so that it checks that
the patch is approximately compliant with stable-kernel-rules?

If you do, please share that prompt with me and I'll put it in ~/.signature

