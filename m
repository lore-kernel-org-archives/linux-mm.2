Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E5DCA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110366B0098; Tue,  6 Oct 2026 02:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C17B6B0099; Tue,  6 Oct 2026 02:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A3F6B009B; Tue,  6 Oct 2026 02:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4CC16B0098
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:55:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53E7E805BC
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:55:40 +0000 (UTC)
X-FDA: 85291290840.14.2B243BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A4313180002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:55:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bvCl3lwH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791269738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COdJjkB8RgloxA5/tpxvNWdRqdglfQ2PJBNFE8IfdV4=;
	b=UYchFMVvdgC2S6IjSMMAr8q+WlfFaL9CtMn6UBaETDJhAJYp4vE8cy09kRxAIkWVZ0AqtB
	HQyY6YJl+qSkch0R2JbOb/+06eoQ+nslchrGkZzEpWU60yYuUFpXKCvDCFM4ix9CmHzC4j
	FeZSGrO0BjQXhBCXK11p+OhYz8uSjpc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bvCl3lwH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791269738;
	b=4KnCDAyriT/Vt12GHWal+ku9llriVwe/VRq24zy/eDmgLsPqTyjNhuMDR4iKzz2Ij8O25Z
	4GkxWrzIUQztP29Rum9HhAbcbCokCFsOOtiet9LKXGWnR+tcfrTiF27N5vJ0cGGoGePLia
	hXnU6JcwbiIkL4oFSm+i/Dx8q82K2Mk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31ACC60142;
	Tue,  6 Oct 2026 06:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B211F000FF;
	Tue,  6 Oct 2026 06:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791269737;
	bh=COdJjkB8RgloxA5/tpxvNWdRqdglfQ2PJBNFE8IfdV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvCl3lwH+wReRHRgeMmv6HNtPsXxtmTS3xTrV6iyy1sU5LYGWjzBTyl4LjrgF4T1u
	 FHX4MJcHEnVG+kZWYnt9HMUVZwI1A2O53GBFzYqHmdTy5ErHJ4mYpKQjbsHWu64gMK
	 9QwV5RjdhsPBw3YLgkCVx4aZh1TTsOftAJqR1v01fME7MN6WIpeh9b6crJBvSD0c2d
	 YYyIMZx1K51T1LqOATBAbsmwpXA/8JNZ4CshVg/Omu27hWCTN0YIy+fuShv4wNqntU
	 aF/RVi0+GgrxCYMhvEefdyIm9ru7tmNCtTw8TW8iqAQLpZ1towr2uZ5cDPHwqf/DFs
	 8NHlgZR21TJ+A==
From: SJ Park <sj@kernel.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	ahuang12@lenovo.com
Subject: Re: [PATCH 1/3] Docs/admin-guide/mm/damon: Fix various typos
Date: Mon,  5 Oct 2026 23:55:32 -0700
Message-ID: <20261006065532.41913-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006061549.627-2-adrianhuang0701@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A4313180002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 4btaokmxkbzer9o7sfrtrgrkntrrbjik
X-HE-Tag: 1791269738-902084
X-HE-Meta: U2FsdGVkX1/omjKsJj54u1REd/k1RRWLfuXcYTq31aCpOaOpNX9htb8P165ir3+prqwJxQDFLq+Vs9YmGU0PImUa9QA2NTK+8VijMmPXK5vSMZszgqVASDXza9AWTXHHWJeh/HAaxIKLhMUdaI86621Al7EjGCvelO0Y7VdumFo0D2QVtpctTO9y7UlkL8hmKCm0QhD9ZWW6r5L18gnt3PSJA6FLHlc4cahoz28tTJb/jCjpKVjyEDnipGAzZp3so8rBw2ZhYg4ChbDJL/Fg+11OjPVHLEVmtXgPgMq4V1Nk1zLziqjO+eieR2PnVfJuPXKzgqM44OImJX6Y97Lm6Nv/8+4/RCdA29cVR2TW3Yp6aZdyZqKO8YEc05xa1Q9EOZ0s2f/nzRRHNLMzpTAASFTaCLFpTyFDYQoXxCLVPEOPdNi+ez+2961wKTlkviWvigIiY7q30U30L2JRuzEoxCh+v9R8IvQ5muIrBBBrIX2ELNUNk/Kv2pZ851+vnizUHEutNZcwtAEfXz/37dzVMHLwa6FhPvZ/b+sAAX1YoEMLBmw6ws9KsOpRFt1fg5CPnhQIRxrZSp0u2rrA0O+8yhcWVRiJaUORFFnTL5D9q+/PlyUA+BtGHm5v+6cx3MvJi9D5iiskmbllEZIURUhkuO4AV813v5iIwcVQQpioRNBYgEK48K0ZD91e8uF824uw8BunTxtZtqN72N+bpw43wozH/6tiB+muVzIW8xjirRzas/rgggZXmFGsH6Q1J9fSnHSRjeztdshwDyf5JnyWC8mlMa/anrzmrnqjB0ebbTZQ9OImARkOpe3MSWpPqBGEBVWFUZ9qO+am0q/Mdc0xHAmw0hZlNvusFdvhc9NLQpPT4SnV3ojzWJXhGrGF4arJh81TY6xHsAfQxI7JpVsSgdmn2vn4UJzuhl/dw5uI31/gkcjsPEio6yXoUfwudQL0gBuxCD1Yk0JceqinpE0
 qvxiZr1r
 /q0RpvEQE0pLjZFpwqOtO6xGwEnG+nSEnzrOJYG14dvjy1r2FnPYJX+05Fum0hJSseC1rRTxrSOtRq+5nEDkD7UeWJ6RlLRqpLlIrhGsC41eW0KwhEsWsv9ZPCllY+6JLTKvHiSR4aHUWZUZNeTONhSU+XXkdGRfku22e3b5U5nHMCvZEHhMFhgR2GkTr3lQ+9HbYk5SVlM4+nzcccMu1x/1FbnwsP0yN/RK0U9huJSY7GPwd62jfT6QkcFh6aatNRFUC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Oct 2026 14:15:47 +0800 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com> wrote:

> Fix several spelling mistakes found while reading the DAMON
> documentation:
>   * trusworthy -> trustworthy
>   * DAMON_RCLAIM -> DAMON_RECLAIM
>   * charget -> charge
>   * hetmap -> heatmap
>   * colun -> column
>   * evelenth -> eleventh
>   * idlee -> idle

Thank you for finding fixing these, Adrian!

> 
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

