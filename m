Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEF20F46112
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450CA6B0088; Mon, 23 Mar 2026 09:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427DF6B0089; Mon, 23 Mar 2026 09:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365446B008C; Mon, 23 Mar 2026 09:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25CC86B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:43:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E020B5B83A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:43:58 +0000 (UTC)
X-FDA: 84577446156.06.ACC4EB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5261918000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:43:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=srPRDA9y;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774273437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7YP+qB9sJk1773FzD06z+m+hbk73RC7zQtOk2w4qcs=;
	b=SRQzD3cHOOJRid+7v+UCyFaTkPE9X5WzCjuDJgfZV2jBYhZmXoTpTvvQ8HSg4NRuXoy6Lj
	xZb5+f9J45HrTAzW2HVoADgxTsaaIB98ESMAo1gxb77N6HW6aFDL19+kfvjloEzFpnMhUG
	b51bAV6aNeGI5raZUVCh9PEGmgUAn2Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=srPRDA9y;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774273437; a=rsa-sha256;
	cv=none;
	b=0XLHQ70M9IKcj/tyZHXgQB1Gt/winOg2ooskAwJKUaECigBifUv1PkXVlIGiDDB+uRo6LV
	lks6VboR+EOoR6fEd+mghNZXGsQTRFOc2cB3K0SjzV7G95mVP0IITBr9Xl/7xe/m6rj4pz
	CZ9/MA67OMQpx1P3xocBoHFyE6d4Rr4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A683460103;
	Mon, 23 Mar 2026 13:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A6BC4CEF7;
	Mon, 23 Mar 2026 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774273436;
	bh=R7YP+qB9sJk1773FzD06z+m+hbk73RC7zQtOk2w4qcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srPRDA9yRhiPLbMsiJDPRUPs9V2ZzT1YQObGxngCh3yI6TMcMJqDDMptnr0UFNfO4
	 H8JYgliPQxwe4TjOVsrO2hlq9Yeot+FMTiaTSll7ozxIMV1uNBqN/1B5LyFQxwn+cz
	 Jor79O5R5NBW4rA4q1hADdJyVQghSwmybBUhU3LaTQ6LyZw/7U41CYnKCv/c7OqNSZ
	 EczkCypYIxIZwkeRcxtH9LK5FYYpT7jvswnwmsaOGqP2vbr0jvOlN8VVnrgQ6hnBkV
	 Fc+Tz1kowYl6cvREIp38CzUfwLEb22AZ3FKb9GpXX4r5KTV63VUFrVwk8xNyks+3mj
	 4bEqunXHbXUZg==
Date: Mon, 23 Mar 2026 13:43:52 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, yuzhao@google.com, 
	shakeel.butt@linux.dev, willy@infradead.org, Liam.Howlett@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning
 address space
Message-ID: <65cb38ee-2815-4b11-929d-3fc1528cc620@lucifer.local>
References: <20260322070843.941997-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322070843.941997-1-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5261918000D
X-Rspamd-Server: rspam08
X-Stat-Signature: rsdxa1jto5afp9c6zf13z6iwjtyyoe6k
X-HE-Tag: 1774273437-753244
X-HE-Meta: U2FsdGVkX18CpjTzHDTe5NXI2necSy+jIOhvBuonA1LRA7TwYtjFI9wTgp5jHwSkj40j24AFeh09qBA7uTd1yV6COcwiPIDMCzFSgsCwkIGRDqHX/oNcNHFO76zC2ercyqGc3fbzVdmyku6zBen7qEMs2JBJEIvRPp3uuZG19+xsvRHlOhamPzogQ4IcgNLhEX82gI+iSbDQISp0AqpxGWiekhQLQ/cTYDx8SoVxMpXSP3R4jHu+Uu+waCCM+w6mkiTFruHL1eHmiEVAvbxE0ogZqVP7vlXajPumlhEqrYhsBEK3S/f/BcwSXqcv5J2E69M2MVlNYBMsJ6fUbVMRxpI/eiOQEckI9Z5vezTQz95XfJXB4h67aHraQNVmLlslACYXANKAQZKnbyPe46uyStNTkKTeKt2K0zV3WUK9jYBvB67S92+dkz/A3j8THX3GlbP9ue5LJefzAJoAFoOACdrlg8FJvHTJJ+SYkgwYLSK4PWAQwv06KXhogKyDPlRMArWh4p1hob2YxlSwLW2aE4wzG3FCG7M5hTHVI5mCGNKoQMxyyL58Y1d+EQsaQBa7uZhGHy3L/HEPkcfxKS39Rst9KlQVTAqtbXcG2/j1qNzEIn9qtjBxisYnH449Zm40KroiexRsak/UQaRfYyCnOva7R2SsBUm9TelNI2dstTecXEV25bEoKS4DsAd0S45A6cy8pv+/FITkFEpRWGQLAEDs/+JHWyUbKpiAtykeqU8CPyS4ke1cDY0Hucg65LkbMatmD1MYuRQFy27a0j+2SwoItrG2NHa9G7/ojyhrn+JsYcUlDRDf3r6YnZ9LkMeEoVB0my3FL+ou3E52lbrrSCD1qwkowWrYy8nq20tbcOxsrjChONSTiyUDm5bBAQWeGVRA1mBXxfBKaTNHNEwttszVYjGyY8VJkTzn7V9yTvNC+kkxaX3gqtWRFyNbV+Z4/W+4+5LQPkDKFxoaHy1
 7D5aCwI+
 Axkjvz1LlDDgTFWoa7uaErD82/htCf+XPEZQ8rU38zWoYWEXdpCOD7MkhEdYdL70aN+zV7q/keq9IswiVfBvp0CMBFsOAn6/hmzYnKCHtweBhEeZqRHrrCNgVORnBZetanPAb4kT1SuyoQQt+GwW/FPp5CetJtSzsRonbrC3uc0KgKhpKeVkXdlFLd7g42NDKPIMCKb0xc6Xo9RpNXuEaxKYk2cjZNiY1LvV9DvPq4c+Fraw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 12:08:43AM -0700, Suren Baghdasaryan wrote:
> When shrinking lruvec, MGLRU pins address space before walking it.
> This is excessive since all it needs for walking the page range is
> a stable mm_struct to be able to take and release mmap_read_lock and
> a stable mm->mm_mt tree to walk. This address space pinning results
> in delays when releasing the memory of a dying process. This also
> prevents mm reapers (both in-kernel oom-reaper and userspace
> process_mrelease()) from doing their job during MGLRU scan because
> they check task_will_free_mem() which will yield negative result due
> to the elevated mm->mm_users.
>
> Replace unnecessary address space pinning with mm_struct pinning by
> replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
> within mm_struct itself, therefore it won't be freed as long as
> mm_struct is stable and it won't change during the walk because
> mmap_read_lock is being held.
>
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Oh and sorry, missed this - do we need a 'Fixed' for something that's just a
perf improvement?

This doesn't seem buggy?

Thanks, Lorenzo

