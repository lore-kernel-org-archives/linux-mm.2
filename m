Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6941099B5C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 02:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9157B6B00AA; Fri, 20 Mar 2026 22:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC306B00AB; Fri, 20 Mar 2026 22:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8020D6B00AD; Fri, 20 Mar 2026 22:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF2C6B00AA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:25:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED2E4B990C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:25:20 +0000 (UTC)
X-FDA: 84568478400.08.4BCC174
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46235180003
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:25:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e+/9ST3P";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774059919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8HdDLKNInbu0MIEwPmfii742c4QKVowsUs8rLFBltb0=;
	b=ieLp0ddc6uf1UQlI155adrDavNH1XzxRmHj8BJNlPa83l20hkkDfKXfjCwma4L2W5TzsSM
	iYx9BJsRYac/nORtZTuutgN/ERqZoRveFYsDAYFdN3MAAP6JGolcKIY2vwWJ8LEbt9YWA5
	MHa/QKv8mjEg1rGrd4BG7PmY1nTMz9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774059919; a=rsa-sha256;
	cv=none;
	b=Aqlf7B4/lYKMM7gvRv5EdARuagsX4vGUHdWgwAqELwqhGTklWZNstLRMM1cw3wqQCrkS+C
	zf/6sSfFmtRBKVgAss9BWtvqVM5WLz/rWsw/78MSRqP/TzR9wHlq7No2Ws19eC73NnuUEV
	60ifxrwzHioSbVVP4PI/fNY8tCmVJYU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e+/9ST3P";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26E94434A6;
	Sat, 21 Mar 2026 02:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC94DC4CEF7;
	Sat, 21 Mar 2026 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774059918;
	bh=odSqb8C84HqMzpdiY32+MdnK999M7twGXHvwdKhHd58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+/9ST3PGkPi1y5hG0RIrAS/NuJn6hslhp3Gipi/d9GijnRwr2umKOd8vR8sHoAmz
	 O7lUlcHrso/j4ZRWPjacyR/UOTGBjKqnpjkMF2FXF/yBsvNmDzLBH6uoSNthDMK2Sl
	 jfoIbroFu8FIx4yh5ZoyzsG/CQExbhl8lynXDfYvu98Yjvy6ZDJZ50VWdxO8Vu7rmc
	 D36WHitrvXq7Bb7Nw4/TEp4De02IWlJ+1LjzOie5vWv4L/dC9ZPQ9ucn3EkQQLbztY
	 2+SKiyOrW0r9ugf0EdULJTTU3F8XIJEXOdiz3LB2Hzua7iDs8bYbTUtCp9jNvfDIjX
	 Vmsbly21Hloqg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: avoid use of half-online-committed context
Date: Fri, 20 Mar 2026 19:25:10 -0700
Message-ID: <20260321022510.79038-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321021628.78887-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 46235180003
X-Stat-Signature: 987to1qw9t4kq3g4o6tkabubhzm93hm9
X-Rspam-User: 
X-HE-Tag: 1774059919-944971
X-HE-Meta: U2FsdGVkX19r0BLTRSgtHxJScEV4HM2AyEu8MGy43DiRuDqMLw0KoIUMJ3z05yf4546LYnkHs5OkJogKL2OC/PzE3GVRxJlClLplq+rCTUmMGFKnZXbOO5OLiuxwvlXqhmAD1NthyaKtZqK3BBRdf9D3nZB7WIiPh7shmATyiMj98FeJCrkr5ouWJRmHTB6tBWio3K6dmzjZxZ0O7nm3Dy9hCdmVMks/o3n3gSXEv1k04ELgpxjPzOhIWwTbzuVr86v+Ne0cGG+Rmji088awSwEZ4TAgTZNElQ/oEbAKayy88MtaP0DKOAsWLDreexuCEEmRwv5XwyxYbQTHSqZQloavqZ03+RLRGOaAuoEXEUl8JBwywb1tMhijD06goqora7bzEju0ftxFL3MDbhtf1/nkq7ukI/Hx+lOgzSStqrzE1KueCrcbg72DPVj26iOSKfbw4D8pR5j4eHMsCEK6UEF6lcK72iBPYwKTDLzsHGP8P+9uJg6iFX+WIDN1mVJ41+plXBR2qAKg2pPMuElDyX/vxYd7YHNLuRrvchYPv/xgZ3sNvwpNsqfLY4AQqYe6AjyF0BkssXfyNqxmnaZ/o0RFcQ5YKDZDiinkD3k4AdV3Z015YJTZTy6zeNXuWYsuakmGunzQ4x/19khR1t+OpHsgyCKcHou5rL7elJIMzcyl2vXi4m16+Z9qhRA7Y88STbqIWP9vypnZarqEkqf9H+GjD6Bv5qefmua+eB4JE3m4IOTXVJdnNzS93YiF7cAYofDSE4YRmOqjwxog0ar16KeJLAJ7m4BKUpgRdwbsMD6vEkn1HLd5R+Tvm9PMy8rbaGCOc4/cfSEGI0BCX/Q10RSO36imzYz6V7WA0H/8savDObEQVEZrqxPt7GjgQZGYNego92RkssfTMyhm1QAuiDTWggqsAw9EpiApph9PXA0ZvOw5m5lzR0q9BzoRq/KuPfOkKMKSsSeeJV3DaTT
 l7n9Myd9
 c2q3z8vE/AlRNlrbLpwWtTLzZOA7FHfqjYkZ4pDtzqxy6t2XLUaujcaxnKSo88v2RnH+MY4Ufa3ASU1xgGmiSCzntnhw/3QFEckPjMTokZkpcUUgl5yBoXOa3VfugUwQBHIK1fmDu6len1I5dkwrXLq8AS+DE6lv+07cD+w85x66NWShJm06v53q9rSpjz2ugwyFNhsv0eq57RH4BL3d7HU0WMmsypzE1ZgO76MUFMgdqAiTSl2hcEbjEDv6iGLfPfbSxWE0ggnPhQSSKukudTRJMmVtv2xKpyRjDKlOBRzf/WyduODlaRLiXUvOV3wmg0TOtsa/mAHXqEp7eEi2+zsJ0fHsRQP8sKjJTY4quo4lCofIcBywUePeuZT1Xs6KyfcSAIVSZcrvCDwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 19:16:27 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 19 Mar 2026 19:48:49 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 19 Mar 2026 07:52:17 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > One major usage of damon_call() is online DAMON parameters update.  It
> > > is done by calling damon_commit_ctx() inside the damon_call() callback
> > > function.  damon_commit_ctx() can fail for two reasons: 1) invalid
> > > parameters and 2) internal memory allocation failures.  In case of
> > > failures, the damon_ctx that attempted to be updated (commit
> > > destination) can be partially updated (or, corrupted from a
> > > perspective), and therefore shouldn't be used anymore.  The function
> > > only ensures the damon_ctx object can safely deallocated using
> > > damon_destroy_ctx().
> > > 
> > > The API callers are, however, calling damon_commit_ctx() only after
> > > asserting the parameters are valid, to avoid damon_commit_ctx() fails
> > > due to invalid input parameters.  But it can still theoretically fail if
> > > the internal memory allocation fails.  In the case, DAMON may run with
> > > the partially updated damon_ctx.  This can result in unexpected
> > > behaviors including even NULL pointer dereference in case of
> > > damos_commit_dests() failure [1].  Such allocation failure is arguably
> > > too small to fail, so the real world impact would be rare.  But, given
> > > the bad consequence, this needs to be fixed.
> > > 
> > > Avoid such partially-committed (maybe-corrupted) damon_ctx use by saving
> > > the damon_commit_ctx() failure on the damon_ctx object.  For this,
> > > introduce damon_ctx->maybe_corrupted field.  damon_commit_ctx() sets it
> > > when it is failed.  kdamond_call() checks if the field is set after each
> > > damon_call_control->fn() is executed.  If it is set, ignore remaining
> > > callback requests and return.  All kdamond_call() callers including
> > > kdamond_fn() also check the maybe_corrupted field right after
> > > kdamond_call() invocations.  If the field is set, break the
> > > kdamond_fn() main loop so that DAMON sill doesn't use the context that
> > > might be corrupted.
> > 
> > I guess you saw the AI review?
> > 	https://sashiko.dev/#/patchset/20260319145218.86197-1-sj%40kernel.org
> 
> By the way, I am also doing monitoring of sashiko.dev for all DAMON patches.
> It will be much easier once sashiko.dev's email feature is ready, since I
> already onboarded DAMON for that.
> 
> Meanwhile, the monitoring using web browser is somewhat tedious for me, so I
> just implemented an hkml feature, namely
> 'hkml patch sashiko_dev --thread_status'.  It receives a message id of a mail,
> and prints the review status/result of all patches of the thread.
> 
> E.g.,
> 
>     $ hkml patch sashiko_dev --thread_status 20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com
>     - [PATCH RFC v2 1/7] mm: memory_failure: Clarify the MF_DELAYED definition
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 2/7] mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 3/7] mm: shmem: Update shmem handler to the MF_DELAYED definition
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 4/7] mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
>       - Pending (None)
>     - [PATCH RFC v2 4/7] mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 5/7] mm: selftests: Add shmem memory failure test
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 6/7] KVM: selftests: Add memory failure tests in guest_memfd_test
>       - Reviewed (Review completed successfully.)
>     - [PATCH RFC v2 7/7] KVM: selftests: Test guest_memfd behavior with respect to stage 2 page tables
>       - Reviewed (Review completed successfully.)
> 
> I'm planning to implement another feature for formatting and sending the review
> result and inline comments as emails, probably this weekend.

I wanted to add the link to the commit that implementing the feature, but
forgot that, sorry.  Here it is:
https://github.com/sjp38/hackermail/commit/cf1b4e167067e5684823137c5296dfb268364175

FWIW, iiuc, 'b4 review' should also provide similar or better feature.


Thanks,
SJ

[...]

