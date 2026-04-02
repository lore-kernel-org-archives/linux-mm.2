Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F59C111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 658D66B0088; Wed,  1 Apr 2026 22:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A166B0089; Wed,  1 Apr 2026 22:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F7D6B008A; Wed,  1 Apr 2026 22:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 429976B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:07:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9567160304
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:07:49 +0000 (UTC)
X-FDA: 84611979858.30.83B8A78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7ABBB40008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:07:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pSbYePcU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775095668; a=rsa-sha256;
	cv=none;
	b=7X9DNrTJ24hQ9tWizU4uJHIjV1JZKWoyWvjT+rfrwMC4tbGE5xXXisiebfBXDX+fhNfqaX
	LeuRdE72GGOfkCp1URh0hMQLEjoyIpsbgmShkmIg8zXiDkI2GMP0KcxxlMPUvR/F5ix8J6
	CYdGO8CBkA9WemIe31OmhR9gfzEGOP0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pSbYePcU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775095668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRdErPSCMRxCQhMA6/+fFtC5ZZMUNCI+gfAPHU4CojM=;
	b=ZfA9K8uzAE0actiiVPO64JU3GdD9bXBcsSHQs+ES/h9Hlvm2lf7zCoUrPVWl11QQ3jNF8g
	f9jUjCxUlHqqQtHIXBjJ3fpgQMZE8BasOue1dre4YNnHo2KXvjDxVYKTlLPQy/GX+ujtMa
	HJGnef+wKqtqr+ivxDdnXMhnNKKtKtE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82E5661843;
	Thu,  2 Apr 2026 02:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AE1C4CEF7;
	Thu,  2 Apr 2026 02:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775095667;
	bh=7fWpk4Gb6mbBCpnHLamijCOUzylF/piEazB2Sm2XryY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSbYePcUY+Qt+QuSS5KrYUfKigRw7zQGPLR7J2Kldh27J8+A0Vn/ST2v3YvTJ5Pio
	 JTB96YQ3t4ES/UK//c5Kic324Idu+t5CygT3Yh4FEnsmXWxg8YWPDygSfaIlwjnMJR
	 Rb5+pE96AgpXfmFgxVkYFb6UCK+G9bPZyTIe5+uJJKmfDKjmq3bxLFgw1sQAtv6GO/
	 oB921pAGMCysuTxzf0t8dQF01o+vrwHpJCBIbr1DCY6qDc6aE7XfMyam0buLcHxqZw
	 3RP4hEqME3uL89XZRxeFIPPPC0j2vpBA+DWcquCfRgD8iNvSnxOT4C1QMaUkZNT2ae
	 cGM/PimH3Sh5g==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Wed,  1 Apr 2026 19:07:44 -0700
Message-ID: <20260402020745.68554-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402010457.66860-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9jrced3keqrewzrsz67xchnc9krtfkrf
X-Rspamd-Queue-Id: 7ABBB40008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775095668-637881
X-HE-Meta: U2FsdGVkX19ze0QSVuM/AUf2FWNq0CajoQjKyrFqt4DxFjV+MBBvXvBar3iNZ+5D07hPzBk11sEn4JuA3dL8F+poh+e0Tj8ci/MjjlCEryJ+XkUwGeQQmrYtQWvLyzUWWfKMRNT3xaD/X0v6wYrMaRl90i1bHPg8w/gBaldZlBYi4s0MvgMjRgu4rOwuE0W4Qxz85cYo3fTOoD/d14DDcO5ErPELj9QeaH3wsFlR1BV6mmzqf0R2sOmuZmJQGcJ4dq1ltad1OiKoJKgnhh28TchpsWnwfECnLJpHfZGc6iUEfBKcv9CB73PPjSYuKGl65djoz+Ms9Z5h4X+L89RKgKTfe8A9oWPD9ySSXVlNnz1V9i5y5NgIkt1T10ZXt0cwQraoXDBzNrjdi8PT5raDAq/4bw7uundOfW4dSRIwU5q/09iHRavbFrxcjkVS3XFPcM0cKCZz40qi3/AbmXk3M1/HMpjtlRiWuQFFXq+wvwHfXxjmToLK/sWE5AFYk0nDzsD7sg3BEClWMKQL8pf/2cB3Dzq0a2k9ypyWdLjsCWm/R+EuD9xYX6v7W3i8N1e04Xj+J08fyPIpvDZbbB416mPU+XbSGTcRkH5pREKByDWr3sU5NMnhqHHkh8wwclTfRYnYGkvF1yCPQx7qPIIPuN3pa5QL4lfZR7Jv562r04NGaCfuU+4HMLHDQ5DSnaAX9yGoig7xmRai5DE4rwWnowPz2BvrXN+g2Qk9Jk2ZA3C5FaivVoO2+x19GqYlksPMzWXooxzuT2CuILr0a1ppxtDkAMlLhoZWFeNDDV6/MRu7DjKKVF0fgemTqFFP2qHbTVXiklaTwoRV2WX28rphKndr5fzs0UyDVof8eTBCqJTbnO7Nd3QJKCWhm0zI7/OvidB5Zy3FW3lo9/mtsIU4Ip3W0mw2LKcnkT1nPx6Y12CaFNdRkHyKM2JcgkdE1ZORecVXzD1RwdztPSC1kum
 IZrJ6Wqo
 aF6Jx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew, please drop this patch.  sashiko found an issue, so I will respin.

More details below.

Forwarding Sashiko review in the usual reply format with my inline comments,
for doing discussions via mails.

> # review url: https://sashiko.dev/#/patchset/20260402010457.66860-1-sj@kernel.org
> # start of sashiko.dev inline review
> commit 1d53bb9291d3fde393f37b143e637f0d25b6634e
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
> 
> This commit addresses a memory leak by deallocating damon_stat_context if
> damon_call() fails during stat startup.
> 
> Link: https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org
> 
> > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > --- a/mm/damon/stat.c
> > +++ b/mm/damon/stat.c
> > @@ -257,7 +257,12 @@ static int damon_stat_start(void)
> >  
> >  	damon_stat_last_refresh_jiffies = jiffies;
> >  	call_control.data = damon_stat_context;
> > -	return damon_call(damon_stat_context, &call_control);
> > +	err = damon_call(damon_stat_context, &call_control);
> > +	if (err) {
> > +		damon_destroy_ctx(damon_stat_context);
> 
> Can this cause a use-after-free?
> 
> Earlier in damon_stat_start(), damon_start() is called, which creates
> and starts the kdamond_fn kernel thread. This thread actively uses the
> damon_stat_context.
> 
> If damon_call() fails, the kdamond_fn thread might still be running or
> in its teardown phase. If we free the context directly using
> damon_destroy_ctx() before the kthread has fully exited, the kthread
> might access freed memory.

Nice catch.

FYI, I initially thought damon_call() of DAMON_STAT cannot fail, because it
synchronizes its damon_start()/damon_stop() calls with module parameter
handling function, and it doesn't update the context internal state, which
means the damon_ctx->maybe_corrupted cannot be set.  If that's true, this patch
itself is not needed since the memory leak cannot exist.

But, kdamond can fail for its internal memory allocation failures.
Specifically, if ctx->region_score_histogram allocation is failed, it will be
terminated.  So, yes, sashiko is right.  There is a chance.

> 
> Should we call damon_stop() here to wait for the thread to safely exit
> before destroying the context, similar to the teardown sequence in
> damon_stat_stop()?

Seems that is a workable option.  But given the fact that kdamond is already in
its termination step, it feels odd to me.  I'll take more time to think about.

> 
> > +		damon_stat_context = NULL;
> > +	}
> > +	return err;
> >  }
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260402010457.66860-1-sj@kernel.org


Thanks,
SJ

[...]

