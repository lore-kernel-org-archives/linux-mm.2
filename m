Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22C5EEB577
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 00:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D88A6B0088; Wed, 31 Dec 2025 19:52:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086C86B0089; Wed, 31 Dec 2025 19:52:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC74B6B008A; Wed, 31 Dec 2025 19:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D93B86B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 19:52:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 443EA13C634
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 00:52:53 +0000 (UTC)
X-FDA: 84281570226.11.233AA21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id A9B7820004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 00:52:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AmdLyjeK;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767228771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfKdA/EcFs1RblzZ8Anlxdgrf5i4YA4DwU0xmhZ33eA=;
	b=e5pvu7+BuZyp2M5HcTqqu/PHFCqmmrnIXhAMUpcNc7Gu/vKFAYnuSdjFd0Puq8JjxOAAO7
	fQI1NxZGn+RGkUh2Xll2AezoUaz9lXVvcIcyNGLZ6UoXX86k4oj++ZNZiXzMri3WBGHWj1
	/vjKaF74fAPKJejQm/ip9P69wr1DBD0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AmdLyjeK;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767228771; a=rsa-sha256;
	cv=none;
	b=ubarSHZwHchESt3uLrfDEqnlB8sdUyXOQgMTxtVPX9GrMnNYIwW1O7dkRiCianH1XVokc0
	vV9ostoyW2OPagW4MpQkvOQ4Gv0p4Sp4JfTGg7L/E1tpHD37fpoeNVrIZgsK9iT8zDh9JC
	N0FrxqVD17ufbLfM6dqJx+1aVhBzfis=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0207760008;
	Thu,  1 Jan 2026 00:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8D0C113D0;
	Thu,  1 Jan 2026 00:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767228770;
	bh=uRFI9tQrnCYxWpT5BJj60ROQreng33NJj7TDugKTC0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmdLyjeKJE+Dr8YmzkZuoR+GC8w82koPUFL5eXmgfMdc3wHxYZiW38fhI7YmuVPPa
	 KTub+t33ztfKcTpasShLRy2yJeg/55WB4CKm1u72Vgyp3MBv1fuiCuocqJCBDcjPhx
	 cFnapSrqsul1Bzk0uS9wOzEpfAuGARrhYIksuSMGQYJLesP6sZgRyXSgqAYA0NSJCp
	 FGgKjC22I22lHTgc6lfY04+WDs+WAOI4eHBoHzdM64KxXjJ09F/ZtwAqtOnHPEPE67
	 2PrbdvCU99S5vUGzaB315+SJjvI6uQvhLphYpPYMr2kREhGWgg36hLgGjWmgur+nqI
	 XGkoWbrfvIUOQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Aaron Yang <yangqixiao@inspur.com>,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	damon@lists.linux.dev
Subject: Re: [PATCH v1] mm/damon/pa: initialize 'folio' to NULL to prevent use of uninitialized value
Date: Wed, 31 Dec 2025 16:52:41 -0800
Message-ID: <20260101005243.84695-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251231070029.79682-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 7h8rt8dphmrkadegx44iygqdryzzhgx4
X-Rspam-User: 
X-Rspamd-Queue-Id: A9B7820004
X-HE-Tag: 1767228771-379607
X-HE-Meta: U2FsdGVkX19UdZndIfmTRluVd+PO148vcoe/sueb8c8VXHo++QAA5lSQsB9XHdNQAaRUNXxUDNmimLrVS5x1YU7YgczKdBewDeKDHNp7s/8jszrlLXkj1/7g3WOO+NAguBsfSe6pwWg7BG272uXBFttDma2rYw2k3wnXwFugqFgfe3x6HlJ2Fur0ILGlcU5uv4GYDTyhKi7z+tE8UHN68xAXi5H++8x/tKpB//cKt2Hx+P0XDYkT6ZWltQgHctjyQcighhISWUMAIdhj31foVGlPBQXa4Awm+l1zLL63P/kJ0E/XStERUsbNc5fX74B1usUGq3kyZljJ+xDlbIfvJIOA5f46EAekoWBsFqG9dtbVwmliFK0o1w7DqVhoH+E1FgUx+LNzfAlggykNXDDiodpBZCYBg3yrcYXPXPTOiVhaKN+zAL3bJLuFp3DN+VACzHk345R2pNiNpinQMO6op1FP0W73Fkae7YzjYK9hidnVZo66S4KgA1Nw9kTseE9uHNR6vrS5Wh3UV3005YghZK86gpE3Py2W1UwDSxB/n7vZi4VO+PJapP9xpXi2wSvuGmQkBkvgYTXuVXjc1MJ0A6Iu88FQP+8X6BO7V/i4PIizT1h2y/k8rLlnaOQontF1RSowSIPDszd5Ubtafc1BdMC77/NJLwFNjBm/swTd0JHSLDoNKnUCgdmoQJ6OjzhZkZ2+tCvYGLsRdndLF7PY6ijvTGWbBVN5DKSTfzvjRatrxuMThZXGgqa3KsfMrszYa2aMlM36aw+kmktAyHc6/Msf59YWocA1v0CfMwQAt38/K1TgaeCXfQWgwp6ZSy2n4q+pgqoK00Aw5tDdmujBfLqDitLavq3dQl50KuXBLIqO8DurOwwdgoMu4QcBYruSiFI+QKIajVGYZvK7rLaPYtSbWhHahad0M3KsE5AjCP8uhWCPbzwLvz2xCRYKwNjvND6fnFXbwZ/peWTg0uB
 koylB8yI
 0eJzU5ei1pu77X+Vx5ESDRTVBQXv01GuiZucZ6l5/xoLjzP7FyHSlt1l+SjchhybKTW5u58iqztQ0C+S+jynlhhezGAUQP8dDefQcL4oHKE0W+Ou4gLhAUOJyCczUq+3jyfGuYek31MOX/ci+iLr/qbrx9K2DLHgpDuhQrlAree3HSPP3cKEzBM/ErZoLKfDUU7dOWYC6PFYbwWJ6fIujXM34yOOOY32zWCtP5CMZidgy0PdmRlgK+vvR96gd6gaHvtzp6ZicSUFx+jhLgT1aGceu7eG6Tvwtjbte3iLDWho7fG7NGR1bVMm2dyspy25XZFtg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ damon@

On Tue, 30 Dec 2025 23:00:22 -0800 SeongJae Park <sj@kernel.org> wrote:

> Hello Aaron,
> 
> 
> Thank you for sending this patch!
> 
> For the patch subject, let's use 'mm/damon/paddr:' as the prefix of the
> subject, for making it consistent with other past commits for the paddr.c file.
> 
> On Wed, 31 Dec 2025 13:57:37 +0800 Aaron Yang <yangqixiao@inspur.com> wrote:
> 
> > In damon_pa_mark_accessed_or_deactivate(), the local variable 'folio'
> > is declared but not initialized. If the region [r->ar.start, r->ar.end)
> > is empty or invalid such that the while-loop body is never entered,
> > 'folio' retains an indeterminate (garbage) value. The function then
> > unconditionally assigns this uninitialized pointer to s->last_applied
> > (line 239), resulting in undefined behavior. Subsequent dereference or
> > folio_put() on s->last_applied may cause crashes or memory corruption.
> 
> Nice finding!
> 
> > 
> > Although DAMON regions are typically non-empty, zero-length regions
> > can arise during region merging/splitting or due to address unit
> > alignment — making this path reachable in practice.
> 
> But, can zero-length regions be made in real?  damon_ctx->min_sz_region
> disallows DAMON having regions of size less that it, and all DAMON API callers
> set it at least 1.  That is, DAMON code is at least intentionally designed to
> prohibit zero-length regions.  And many parts of DAMON including
> damon_pa_mark_accessed_or_deactivate() are written under the assumption that
> there is no zero-length regions.  If there is a case that allows zero-length
> regions, all such parts could trigger problems.
> 
> > 
> > Fix by initializing 'folio' to NULL. Assigning NULL to s->last_applied
> > is safe and semantically correct: it cleanly indicates "no folio was
> > processed in this invocation", and callers are expected to check for
> > NULL before use (as per common kernel practice).
> 
> For the above mentioned reason, I'd like to fix the code that allows
> zero-length regions, rather than making only this single function safe from the
> bug.

I still think in the above way.  But in my second thought, I also find no
reason to oppose to initializing 'folio' to NULL.  It adds overheads of
unnecessary initialization, but those seems quite negligible.  Meanwhile,
_arguably_ it makes the function more complete and easy to read in my humble
opinion.  The function might better to have further cleanup or complete
rewriting, but I think such complete rewriting is too much request, while
initializing the variable is a readability improvement for at least someone.

That said, to do the initialization, I think the commit message need to be
correctly updated.  Otherwise, it may only confuse people and encourage making
changes that allow zero-length regions.  Also, this pattern exists on
damon_pa_pageout(), damon_pa_migrate() and damon_pa_stat(), so better to update
those altogether for consistency.

So, Aaron, if you still williing to make this change, could you please send v2
after doing aobvely commented requests (updating commit message and making
changes to other functions)?


Thanks,
SJ

[...]

