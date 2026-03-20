Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6391093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2996B009F; Thu, 19 Mar 2026 22:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C186B00A0; Thu, 19 Mar 2026 22:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAD6A6B00A1; Thu, 19 Mar 2026 22:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3FC06B009F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:48:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A198E13BAC8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:48:52 +0000 (UTC)
X-FDA: 84564908904.17.89D9794
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F773120002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:48:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BjGNWz7F;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSFVHUgeZzox5OgmuKywUxQt5O1gJp934Dw7MAs4W4s=;
	b=2NJHaGlpXwscEmbwHqXqJrafoTY9GAqlsM443J80ndJ1eVEglrLqAkkPtuNjavJrNkjwIJ
	8nu0U+pVZytwt3kAYt/CUb+4UZudKA2r5ZkX937y9zgtg7znseDx++cfDR3/dli3tzXl4t
	5v+LfWsuUxDg4fnVaI3ClhWwva/ADpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974931; a=rsa-sha256;
	cv=none;
	b=NWkJ2rB81c189yoYg9aK8LxddFV7D4GBz+TR6F8m5p739CNcpgaWlkHIiMvWEF6fjXHo/3
	078SAw4nxqxGnrDiE76Vr7LmuHw1Nalm9B5ZOVkRf6cbbAY/b4XB3kwHhV7MekBOTh2r+9
	OhPT/qU+XWkm/n3kMGdIj9DWrxr+y2U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BjGNWz7F;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A269360130
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3095FC19425;
	Fri, 20 Mar 2026 02:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773974930;
	bh=ZwzkqrrfmnwzSwwehE9MFr/f1r47yObrEGfeUmVXDLM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BjGNWz7FRCFlJKphV2wMLCwL/9jERXlzggS1owTY5OU7rCYTJDogUWtxO1TDi3tEO
	 LlAMxnBepVoIOzcHpUiuD3+KREjdThvJqzkb8cY4IJwYaI87qCc8EwneRXtxWcE2ki
	 6pJvMVrlcRTvbdjtmtHvfdcvfWXEMl0urNlsH2Ws=
Date: Thu, 19 Mar 2026 19:48:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 15 . x" <stable@vger.kernel.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: avoid use of half-online-committed
 context
Message-Id: <20260319194849.64b0911e2a7a6d8b1c22005a@linux-foundation.org>
In-Reply-To: <20260319145218.86197-1-sj@kernel.org>
References: <20260319145218.86197-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F773120002
X-Stat-Signature: kcdpamknn1b58ju993h9k559emkk4bmh
X-Rspam-User: 
X-HE-Tag: 1773974930-40666
X-HE-Meta: U2FsdGVkX19v6XZIMZc3zNs7B2ycUn5gH9EeGHez3rJuVE7ZeEc0Gy/Giirv2T9nvDFD8wFjXZTZEn90s1H/1X41izfHPZOCZLlmrbloaLgLkhHm9Aj1wsfBrOnuScNkW4HAuoK65nJUwCyKAS2z8swG6VvuuueZjl3zYo5P7CTdv/00h8DJlac68xHvUIPdoVoIAMkuIm2jXvhejZHWUeygBx3k/+e5lRX/fUKwK/z1w9mHLoqT4mcFFeTQVptwoYMGoNTE9k7vDMNfdrStJN77wd9ACjkGXRRO46ATR63s0Ivt+cnkNYQ7M5vGITDZnU696/mLSIi2jVn8j366sqRrR64C/NloCWXu2xe3JXh2sq3Xo/pUbn+XgX8+L6O+xvoFTXyV4dLPP/DUxKIRnJZYyhsluETbxJe3KGHGXraO43sme57HE9Og29kKOyYP1lxnfIaqKFtIe4tBsTC1ScYwtVy7umlxqOTDtmqzsX8Sd8bqQeDl0HJ+u4vp0/kX8/AHGENUoyYLqv/wIXzGfhLSf0nLFa1JrqxRXLp1bdf1sIg9Cd530REbAmVU1fz+8nCCsb17ePA+/a3RbbPuVSvxooxSsytQ3CQrg1dctr/J6I8NG1rlg2gsnLRpuqoSghXaj/m45zGyfn69cWwuKnrEuY8zgtIcUsnp0gGxuWWdMUxSiOgpw78WsB/62IIjMAp/vfjNJz0k3MKjOuohxkQOPt0brKNXKD0t0oYR47XSNDnID93RG37wNgOS1gtgJ6iGx9/jcPrhILcW3kaFKjY2/tWPEzB8FAL/4fCVo9Ge2oHHaTvXaWWGX4k7lNrkWG2tjsihCnca/NaLcFrirtuTuyQOP/hnEIHrQAwJTuEPhDB+aZCkXRrGAhiojv0XOg2n31HG3ZPvRu0XDSPDFuWDwFCfLv0fU6wp3QM9y8kGY5jbgvZ84/A/VrXaxpQ7I3SqAMbunoUusKp+Lkw
 sBNpXGnR
 WiNcHJBGC1CKn7wXy4+g2Lgi7zimpEXH+WDYlAODED3hjHNGDnFYyIWGHSBVbJMKW50miSTzJD25ATj03xaxRuIA01b1g78JZSwzfYEmUN/lPuaZCHAZPJPjB3IHqiWZBmg/MWnAprTDLFy+P+HwVY7cPl/cobooO5kJx27tGpcAai17dMn1D83XJPgRJhvZav6lZaoBOafnEd0MVIdEwmwOwQLa8N5mvy2lg+hnGFsD+VMrhc9H77rcmzsacUka7MxDrZvdzHY06SWExwuAowAtGBEzaJAdQm2UAbijIscVIA3FSE1lp4EfZMAonPS7DZKRYsZbEOyfp06ik5PIDLPnF8HppjTp2fFXy0YyJQ+fIPYMA7m5j7l0voNepgvASQrQZ4QNjON1ZZYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 07:52:17 -0700 SeongJae Park <sj@kernel.org> wrote:

> One major usage of damon_call() is online DAMON parameters update.  It
> is done by calling damon_commit_ctx() inside the damon_call() callback
> function.  damon_commit_ctx() can fail for two reasons: 1) invalid
> parameters and 2) internal memory allocation failures.  In case of
> failures, the damon_ctx that attempted to be updated (commit
> destination) can be partially updated (or, corrupted from a
> perspective), and therefore shouldn't be used anymore.  The function
> only ensures the damon_ctx object can safely deallocated using
> damon_destroy_ctx().
> 
> The API callers are, however, calling damon_commit_ctx() only after
> asserting the parameters are valid, to avoid damon_commit_ctx() fails
> due to invalid input parameters.  But it can still theoretically fail if
> the internal memory allocation fails.  In the case, DAMON may run with
> the partially updated damon_ctx.  This can result in unexpected
> behaviors including even NULL pointer dereference in case of
> damos_commit_dests() failure [1].  Such allocation failure is arguably
> too small to fail, so the real world impact would be rare.  But, given
> the bad consequence, this needs to be fixed.
> 
> Avoid such partially-committed (maybe-corrupted) damon_ctx use by saving
> the damon_commit_ctx() failure on the damon_ctx object.  For this,
> introduce damon_ctx->maybe_corrupted field.  damon_commit_ctx() sets it
> when it is failed.  kdamond_call() checks if the field is set after each
> damon_call_control->fn() is executed.  If it is set, ignore remaining
> callback requests and return.  All kdamond_call() callers including
> kdamond_fn() also check the maybe_corrupted field right after
> kdamond_call() invocations.  If the field is set, break the
> kdamond_fn() main loop so that DAMON sill doesn't use the context that
> might be corrupted.

I guess you saw the AI review?
	https://sashiko.dev/#/patchset/20260319145218.86197-1-sj%40kernel.org

