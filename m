Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC31D11193
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 19:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531036B0024; Wed, 26 Nov 2025 14:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5085A6B00AF; Wed, 26 Nov 2025 14:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445366B00B1; Wed, 26 Nov 2025 14:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 317226B0024
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:00:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9DB414072D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:00:28 +0000 (UTC)
X-FDA: 84153674136.03.810EF59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F40E416001A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:00:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J0JkL9lB;
	spf=pass (imf08.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764183627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZP7IW+8viYE3pcNLPVFkXnhGpR9cbvFSn8tPWeahMRQ=;
	b=s+qfyzatT59mw/um5Jm1qXKtfz0JjbHhE5T/zOVvNpDJ/aLUCHJ8n+MPQVMJ04Pmv5U2GM
	2t0uOQcdyYHoSgwZYxeSkX3knB4NkmCEEe/z5VFpFj2tJo5ZxF2v+xjVaJah0fyM85wxNC
	okTGtHx5gYgR2uLNp3fOCOTHrmuvhN4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J0JkL9lB;
	spf=pass (imf08.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764183627; a=rsa-sha256;
	cv=none;
	b=wAJJIPan/SMqyK7YXrl4CTMgwNZenopoUINMaVsrWAkw8LekwUQN2et6epmc9yT+XhcXmm
	2wC5mEkRO3J2C9WoPZT5kixiQJ9EbrbH5tzGX6yvAE2pXOJ+ZY7DjLNZnU9F0SDpAf/unB
	nrQ/dUV3zAm4FLCKbwan6PR796c4bs4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3D90435F1;
	Wed, 26 Nov 2025 19:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96580C116C6;
	Wed, 26 Nov 2025 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764183625;
	bh=nIv3Siez8Xf9o235kbfOjSxJX+DKYpDTaovNj1ta27A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J0JkL9lBEj+bJEpZsIMnlGLtbUGzsEhtTpEMsGQJTOCOUYy06bSt7zPsjyWsAXFwb
	 MHklrZv1rxUK32wVEHuxVecXHnFC28Zf+syXCbZxl4o+2ZCqwEzZ0OmfIqL/pC/s4U
	 D0W2bFI+4YI7Dwz1f1ZFdoeAum8+cXFjS9SZQpV633decb5028zHizIuiQm+6syd5k
	 6AlJNxhH3kG2oCJsRStWtRLkYPZbQvgBwwVz/+heraTuhG02bALRVn0FtM2KZR19So
	 Mxzm/BMgyGiWNMW13L++5pAkOrxnzmepI7S8VEx3EvmkJ6hrQJ6WZ8N6goezeULx89
	 ubAIo3cyjp1Gg==
Date: Wed, 26 Nov 2025 11:00:21 -0800
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Xianying Wang <wangxianying546@gmail.com>,
	akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	linux-perf-users@vger.kernel.org
Subject: Re: [BUG] WARNING in __alloc_frozen_pages_noprof
Message-ID: <aSdORdgxGSOERQZr@google.com>
References: <CAOU40uAHO9-59HB2VmCBfC5OiNg3BZBd-32jphtRd-nkvhD6Dg@mail.gmail.com>
 <4cb9f727-734b-43fa-92d2-80559df76c84@suse.cz>
 <20251126111921.GU4067720@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251126111921.GU4067720@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: F40E416001A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bgbmhini7z8cm4rce8kuxchdf9at1595
X-HE-Tag: 1764183626-694809
X-HE-Meta: U2FsdGVkX18PswOLUvteZeDiVUlnyjeFEqBh1cP1zMBuIvsyYik6QRn5/ad3IVfXoCH4d/H9taxrgxkFpEVssQghnN0kBrwT3uDeLCh8qdgCAYrJxih/kiDc3ynF8Ul/Jhmb/ikyAX3rAsFmQWNSeMe1yRBg5CjG86Qi8EmjwJILdpZAK9Pd80bvzyVkkJ2a8Pk0NAmIO0vYF1yXrom8gchxaIc06B5gUmt7uomGWT2T3OECg4+V1gdh0zCM5ntlKJ+RHw+1hy/YTQGmFKyc217/39UFCRB9fbIx/gaRT4Z6wK43lRSknGzhASUerrF5gJ41xECX0J+j0hgrud68t0mg9w+9lask6hFjCHSqsXtyWpqjTt5URrpWHalkyAgQJ8UuGa6Xzlz1EcdCAqGn37QY0dME6NohVXQvy+mA/FvUq8G4zEDr4aA5sEucvHXzmmOTK9QSdVEuhTJFdnZrymFrNgedrkzSi15R3MYSPp9nO7zDaaVx/kC1Fu03eNZx4o5LE4erSGEOlRDhwykrWBBgTNFdVPxLQ8bmvl1WCpAapNyoDToRgbqrmn7ROGX0/pCESZD7Xqazg0/jt+cmIDE8gGoVWW2rOnSnnQTiwd4e1E3CQXlTnODor+B0Ch3UVNhMJftxyeUwWxqXl3De3hDo9gvV7VcTmPiDISCi+gXtP2eDBTfuOQfAdxSG6dCv7rf2iPaTaAszz7YXp4fRw8rcLh7/K3euT/WlmDpUV/o7JJmhGu7fNJLTGLW3niK/+cEHLPb1u4ZXyob8UJ+JnFd+xycYKHt8hni/4ZW1wKx5bg1lt0Gq8Y1NT8caRHzyTHQU7xqP+SfMk7wxWAn3nTbkrv7NoI5svJuI5zODwgx6del50tY+JhK9uCM1Pc5VvG9meTJ6NwJyEcLA6iwh3Qec/cLYhREpcE20PCSRpJApXfYS2/qq9y6yrPqw6sB8HLX8Ax6IT4OYcBLp3tx
 DvWz+kmI
 dM8rvW7/B4h3Cxxty5vJ8WGtZ+zd2B387g6UMYah44Xd3GAmF1bw/0HJgLiA9JJKyhhGGFwk0ERDtI7E/hrdW+Ww4p5nekan55Gn07WPF1leqyxMFYI5Goy3zWg5rgTMV+ez7esUeUrmQvtAicEx8QX5UNYUvxddbVhsJa0lKgNvnUvVi+veZ2cA4uEbpXNDTgOzrc7/niFQ+XuWueVctM90sWqYVo91N6tkLsJlqSrx+Vu1bXQstsZv9YArVQpOtpLChyG8gblP84Xn2bAz1oOILttpTR8qNNnUaZ1PHuAwxjh1R3QjSz+oWEmf5LIiT2iW6I/hjHDYssO9SSTSBcZoDWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Nov 26, 2025 at 12:19:21PM +0100, Peter Zijlstra wrote:
> On Wed, Nov 26, 2025 at 10:46:38AM +0100, Vlastimil Babka wrote:
> > +CC perf people as AFAIU the problem originates there. Should the limit
> > be lowered, or the allocations e.g. switched to kvmalloc, to avoid
> > requesting impossibly high order allocations?
> > 
> >         /*
> >          * There are several places where we assume that the order value is sane
> >          * so bail out early if the request is out of bound.
> >          */
> >         if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
> >                 return NULL;
> > 
> > 
> > 
> > On 11/19/25 10:07 AM, Xianying Wang wrote:
> > > Hi,
> > > 
> > > I hit the following warning in the page allocator when opening a perf
> > > event with callchain sampling after increasing
> > > kernel.perf_event_max_stack.This warning can be triggered by first
> > > writing a large value into kernel.perf_event_max_stack and then
> > > opening a perf event with callchain sampling enabled.
> > > 
> > > The reproducer does two things:
> > > 
> > > 1) It writes a large (but still accepted) value to the sysctl:
> > > 
> > > echo 0x40132 > /proc/sys/kernel/perf_event_max_stack
> > > 
> 
> Yeah, that is far too large. I suppose the actual max is somewhere near
> 8k, which would give 64k data for just the callchain -- given that a
> single perf buffer entry is limited to 64k (IIRC) and all that.

Right, we have u16 size in struct perf_event_header.

Thanks,
Namhyung


