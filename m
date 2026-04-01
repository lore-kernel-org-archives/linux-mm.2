Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F1610F930B
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3210B6B0092; Tue, 31 Mar 2026 20:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9E06B0095; Tue, 31 Mar 2026 20:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6596B0096; Tue, 31 Mar 2026 20:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09E9D6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:29:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 998F659112
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:29:23 +0000 (UTC)
X-FDA: 84608103006.15.2EBED94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BA263100005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:29:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nSmrxFj9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775003361; a=rsa-sha256;
	cv=none;
	b=KS9eIWt+4FGLu1wcMSR1eGIjz1Snj0L3BZ3DpqguMbHBkAxuQtlBVq9nOD2LUeAfUo+dYc
	7Inl2amLOErRnvDXMPyRfUV6n0XhR73HgWpACcaiEHUkSsXEMxX2aUiIGf/eHfXhdTp4ec
	PILQ6LknkvzJvsf5Ak/r8vkGoB2ugRA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nSmrxFj9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775003361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9ZMnCOPDPbDj/JfE6ZP6zg+fuqK7mhkkg2yySPqhws=;
	b=eTTWL+Ya7OGd4iGZm99WXkwRbJvHNgihKmEVlbL517zoEUi0cu0c72rYQ/E+ei06syVqTn
	NKT3U/BNGrLae9wCSW8PPkfhyMh6BsHGT/TerGKO/ofK4diB/uiZZqZo5tMYQpWdgmxy29
	kHDgVmKueBNRPAH0EvQd60/EbMm06Uo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B834A42A0E;
	Wed,  1 Apr 2026 00:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611B3C2BCB0;
	Wed,  1 Apr 2026 00:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775003360;
	bh=Dbl7wQksRMs1lnHVTfv9r7xVfjWsvbXiAANR/E27KAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSmrxFj9kje8cZZfDG0mnGqN3+wIHb96ci0loXYGpHsrvIX2V4G7QelnKNhCGPl3V
	 YpgWLzZpBvB7QPChTQlcAwxJowrfOnOnGBJDVZKHo1fidprWF8qlB5KwLs+gEPOx82
	 6++IgTG+TNrIuUJeFp66Ou3AEimYktZoOImI6rR1cgoEpWhuV5CLt7vqUrkMuKaU9E
	 ixF5AdhT8C35BE6pldk9Sg3N5YV/npWDJe+62X066yqQPjg3H3UmLKtFaEq2o/wGfN
	 NTB3+L4UBykx9cJ64M9ruIzHdZxBvA9s3AlrUrfhp6qQOmc2VWz++qqEhtxHJ4cRWI
	 3o7f+XiHU3pVQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Tue, 31 Mar 2026 17:29:18 -0700
Message-ID: <20260401002918.85255-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331065836.4364-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nrendq9zcjzadc8any66wicm8utbr5k9
X-Rspamd-Queue-Id: BA263100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775003361-121808
X-HE-Meta: U2FsdGVkX18pnLkI85PjgxVkaigNFU8n+/S00uwKlbQ872kjwXLZy4lL7kK4M9366DVEnab+Z9nHEImT47uf/f0+VwmEfWlQTK+kwZ0LpDxGEE+FgODxQa9VESP1o8Y07HVnHuiSW4itu+kbHEIRhETUwejZz819NOOYeMn6LaM0YDZ4kEsKjvyMkqpWGQwOBIIIKvQm6U5jvvW2wQXMopzvXqlB27aXSanc9E0OyDkT7sN4P4YYdAYJ394FE7w5yeMNfhDzvsWMrwVbho04qbVAebOZUkv6oaV+C3oCQOk36+pn1BzaZUVNaMhQ4NS2VIJkaCyw8qa9bCmo7CybZ9uf85zoZxaoj+lqIjqr1u0Q+hn+NmVUKA96SEp3YrmtgduBUdlJLn6JKzt4W0lH72LK/fUqCh2tGdCzFjGJoFJd+pq6Ov51fQExGlSs1ULjOZviVF59C4kjixyM6PPXCtAvdCK1Sp2krW5dlQCHnnPRnf6DWJOmBwY7n7oVY3rKplhUdnfGPagD3oswC4ST+O++seIyI8I+wDUcLLX/PSmDXM86Q6xFeyrnGdzz1ejpiTRROTOAiakUfC9FclmBOoGzN0Ub3T0gFsrR4yufisONr0fX6LsoTgJf4AT5qRkj6RTTau/BLs7kVg+yM8IuMz51Ilw50vONnmn2uij63LvIsAIkxZOZHKdonpy+SiQnLUmdQboUtd5S9G6oX7xYNFvqogOcAD1Kex0GY2S2QiOb16bXDf4CqwHTYpdf3JXWr4STNH5fwUpkStNSL2fPw0WoXu0XEA6/vHMiAwJc0hY2azXSipMh4i5Cf7K7w0V8gTuV8PL55c2cuDU2ePrvdXTmtT4VH3g4OkxXwO+B7lkCs5f6vr+1jCUdu4XwRtNtkmXW5zLVvUlqZ+Y1Fn3NUomIJzG90qeha/txSTAJT30IIsqBmQusWD3Xwl8G2ZA2FObMz1r5WQ3TpngNTyh
 kNBAKlCc
 eD9CcwhkdgI8iJ9RfXywURAJaRJFXXiD03KI8E7UaQJRomCKzYkZf/w+dBX/qdlSeO6C6CLRUAK5G9cphgrtcNwa+Cc3UgWiRloyiEVVwzDJJQzMtnnpO1IgWjxXEaCXiQspOg+VyvA35foYDtM1mII9KePtMOFei2+MkH3ZvnuOQ1dQW8HV5//wlSEcbzIiw+6s0NHB4Scb2mTYo8dllCjU3K2kspGtNopPtim2lxzVVG1h8vLjNAUh/cZvxIIsBQ6tW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 14:58:36 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> On Mon, 30 Mar 2026 22:02:28 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Nice catch!
> > 
> > I guess this can easily reproducible?  Sharing detailed reproduction steps
> > would be nice.
> 
> I will include the reproduction steps in the next version.

Please completely answer questions.  You didn't answer the first question.

> 
> > > Solution
> > > ========
> > > Introduce a 'thread_status' structure to link the internal kdamond
> > > state with module parameters ('enabled' and 'kdamond_pid').
> > > 
> > > Specifically:
> > > 1. Extend 'struct damon_ctx' to include pointers to the module's
> > >    parameters.
> > > 2. Initialize these pointers in damon_lru_sort_apply_parameters()
> > >    and damon_reclaim_apply_parameters() to point the respective
> > >    module variables.
> > > 3. Implement damon_update_thread_status() to reset 'enabled' to
> > >    false and 'kdamond_pid' to -1 when the kdamond thread finishes.
> > 
> > This feels too much extension of core API for a problem that can more simply be
> > fixed.  Can't we detect the unexpected termination of kdamond from the modules
> > and update the paramter values accordingly?
> > 
> > If we cannot due to a limitation of the DAMON core API, I'd like to extend the
> > API for letting the caller detects the unexpected termination.
> > 
> > Because this is an RFC and I already have question for the high level
> > direction, I will skip code level review.
> > I agree that the current approach was too heavy as it forced the DAMON
> > Core to directly manipulate module-specific parameters, leading to tight
> > coupling between layers.

Please do not add '> ' to your reply.  This confuses me.  Also, again, please
completely answer questions.  You didn't answer if we can or cannot detect the
unexpected termination.

I will reply to below in another reply, as you added a few things to that part,
while cutting the above part.  When you reply to your reply, please consider
keeping the previous reply part.  Then I can reply to your two mails at one
place.  That would help my life :)


Thanks,
SJ

[...]

