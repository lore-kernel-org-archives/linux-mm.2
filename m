Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A456EC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 21:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D126B013D; Mon, 17 Aug 2026 17:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127C06B015D; Mon, 17 Aug 2026 17:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34F96B053C; Mon, 17 Aug 2026 17:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA8486B013D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:01:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 314D8140949
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:01:23 +0000 (UTC)
X-FDA: 85111982046.11.61FAF1A
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6B8BC80003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:01:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=A5sD3cWK;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787000481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H37KXwW7bbeTt69RENbuPKZTQxTdS5bOb1mp2xT1ICs=;
	b=WLq/N2wBse5n2mFelwEJL6jD2CSQ/EcdRlu9Xop8GxmJKgaztAFxiDzQ3YuPCb8tDnYrKD
	8WHWpiGjJI83TfuR3LcmrK+QaT9J8aD92S5qc5um7NqfOwjSnCbW7Li9grV/AX1btkmvfg
	YgDnnrrSGgih2/RmKeCoLqx8pZho8Yw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=A5sD3cWK;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787000481;
	b=PGqrm5GkQ2upD4m0NhhN4gj7WEXW6M6xMMgEb8eizqP/gNzTuImGIardU3vXUCbAyTUt0m
	U2WC/E/DJlg7R6T6NWhMcaLRkScU/+7ZNkdAyN0YFMackxwHYjk9Z0WSSd+pFYD1DBzUVV
	W11PAIRBsWiqDL/zVKesS53/QM4ewxU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=H37KXwW7bbeTt69RENbuPKZTQxTdS5bOb1mp2xT1ICs=; b=A5sD3cWKNEfBHrQuj05YweQ6CW
	RNmsjrgeEmncyNTSKtRVfnVtKKinS/8HqFJ0NJKK9fRFN1lS2GHLpT91zOT3ciZfH7MqlRctdnH2x
	6Vnh1pxRNPJliFc7V1bU6ncps79Dh1FUyyqQIBHd86z+UtsD05K6tNpbwV2EvHGR0Zp4djzVHL8QT
	M2d+HiaTWcEPYO/i81/2lAE2d35kvxKAR908UR1N7QF06+1pC5KLHwWjknj8qBQBKc/4vKyvPEk9y
	A5GWe1Snl8OXE34lI9EijwO1IOoEFWOL+G9s0CE8Lp7cy4obl8hknLvP4K/YGklnSjUJ//k7YagmY
	KPfvfE0Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1ww4S7-000000015EY-1jJD;
	Mon, 17 Aug 2026 21:01:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9C9CD3006DD; Mon, 17 Aug 2026 23:01:00 +0200 (CEST)
Date: Mon, 17 Aug 2026 23:01:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: jim.cromie@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Boqun Feng <boqun@kernel.org>, netfilter-devel@vger.kernel.org,
	bpf@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH 6/9] locking/lockdep: Fallback to folio_pool in
 alloc_list_entry when static pool is full
Message-ID: <20260817210100.GC687043@noisy.programming.kicks-ass.net>
References: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
 <20260817-folio-pool-v1-v1-6-0c1d230aa3af@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817-folio-pool-v1-v1-6-0c1d230aa3af@gmail.com>
X-Rspam-User: 
X-Stat-Signature: s8pc66b1qq1fawg46onmiutihwtrqe7g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6B8BC80003
X-HE-Tag: 1787000480-500414
X-HE-Meta: U2FsdGVkX18XqNh32fSpRSUdG8zU1kEa+nJdHSgu4Rc9wn6Us08YuB8TOhR3Or/tK8iCSp8oUvbNmogz9Vks74M8iJRHzLKhxEKTVw+g8i5sbcyw3oGE+UWZIlXdU6LwB+Js7CtGbdCqQzMwVkL5Pdh5UIH1GogTpYEXLHTuJBIkXtulctnu7Utgx2I9/T+hR9f7p6t6aFj4XhSieXN4sK4DDbsqGaXRYZOfOX03kDHRR9u5fv0Ih2Jm4EhgF2ab4u/G2wJXNiK+6NrExDxvlacOfO4LbT85qlswGK8Oawx4qDvHtKJ7/MaMZMfV6peqskM9+U85f/7BCcbVNddD9yH2VnHLyoCQthrl0OpbMA9U4WfDJNf8s9hbiwvVA0AwSrl3a0X68XQIODoskr2y/fCAz7rg8af8+iUOMHJLKOTj6x/VQhOK4RNP7fi8qvfeAqVOVYEtVDTnKpSA//0UxJUdDQyVfPJEUKRC81ElLfW4OKOrh8A+UYbSYiNXfc4XF56I2F4TKSjqU/wKCOmqoBmfYaoHS3k6zTmCOYFNQmPnC11EU6pEvXIyYRg1ByKMDITaYWp6f8wzNL5ZfdJWaNDEzh8ek/WeS/ZcCE5gFiPYOOVpgx6SLzEJileoNemYb0ovn/aKniOgpZVMtN0JDy1137e7rheJbrRHXYV0eA0CD04cnQFbc77gNuyX/Hb/o8GVNptYyUQaTSK7CskLQ9EkhlwIgfO8zfeLyfO/xBVbgEPt7eW4wsP3G6mzRD2nY0EYCukILA5aN0VZ58gGz0qHDAuvp6oUxgYkm05w1KoaAhcSqIxvTw43qIlIke0uYF8DCdzmojb668vefdORZD3qpzm3mLSAihj8q+fjaAnQl3xgdDgqOtO1RGWgN1o3N8GLD8yBozHmCtSD1CKplsgjBn1HTA6ZgzZeWkIDUaGfhJCPaHcMheRKoRpqlSipfXQUfxJEaUxuK3TgzB6
 wNYpG6eM
 rAPiZeOIv6mEMBVP9gm1yxJ24AueecuDCkTQ5KzxoDZ10CKMYpfDKn9SAasJR8a/X25eG1BmbFpOoapH+wc20Rum4/1qPp7r/djA+XyJTKb7sMqIOD+hy7HUNklcrV31W/UGiBvK2q9ACTvXInu6CYJtKnl9/dCy4JPPVzpAyDNbMxuJRuG0lIYwqz/7wOFXVtH0tMaXmU9iXfIbNyvJetaDefLTLDiPY3QyVz1KceMBN1UVRykOXXZjWaIz5OVGLHu3hHlGvn3i9xLcRrn9aXNiRhDND852JPW/IuC9R81rzm7lus+Bd6Fd6F5wNQCHdgwc6c+f5ZTYg+Qyt27ZgODMNyp7dvwSdYHbB6xPyqln59Wp98o2oLWHKXPpSh1dTR7Wi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 11:22:20AM -0600, Jim Cromie via B4 Relay wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> Use struct folio_pool to dynamically expand lock dependency storage when
> the static list_entries pool is exhausted, avoiding premature lockdep
> disabling.

Since that thing has locks itself, no.

NAK.

