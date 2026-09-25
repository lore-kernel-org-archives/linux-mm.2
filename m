Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FF1C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 08:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4919C6B0088; Fri, 25 Sep 2026 04:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41BB76B008A; Fri, 25 Sep 2026 04:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330CD6B008C; Fri, 25 Sep 2026 04:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFE16B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:47:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 843E7C05AE
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:47:23 +0000 (UTC)
X-FDA: 85251655566.21.0E726CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CFA4940002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:47:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOy3UInD;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790326041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1vL/yQufHRzS8007YyJ1BmyXdeunRacUZuSMuoGx+M=;
	b=s5b5KBavKeHjHE2DGw+bTbPwMPHHo/0uWutbaOJQWH6BmzE/rDR/kCVH9dFkvpVFUKur0X
	YzotB0INR7QfnENgqL2/gYGg0ccciakWLKWlfhZtDnGpmReSGEeV7o1tkBHbBHq7cqWTvK
	oDKfzH5V1MRAvoVH3CNb1XeZd/7VO5o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOy3UInD;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790326041;
	b=Mlwsx6ctaMpsdYw+uBuG3YbCzArY4OEgIcJIqHJUwrpgd86+Pc9Vz+Aa63YACMqyPqiyhP
	/g64z81rt1+gFN1N3xWnoMkN4Y7VTU1o7vxudVGN/iQzEHEa4OU22p/0rux1yaoOLP1QOG
	3dfIPWj5Hi9TuI9lwCVMZN8mIQZiDF4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05FA943EDB;
	Fri, 25 Sep 2026 08:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6C51F000FF;
	Fri, 25 Sep 2026 08:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790326040;
	bh=y1vL/yQufHRzS8007YyJ1BmyXdeunRacUZuSMuoGx+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOy3UInDQUVb2Icb2GdANrlDOqYm2WoBKtKvwZCUfs1S/oGOxGpZkfziC70GyA2/5
	 2cyexKetRbt0vlFJKsIJcWfVwRR2Jx2f/bHhgsr2eMaSnvnmDN5tJswN6YcsxEUMkx
	 EkrelxHCJjCdO0grJXBaMOWOxZ5K2sc5U259jiYv2hZcofCoL6ufST58P/IQx/IHVq
	 WV4iwNyyXUrR3ENvaFkivya5BrKrNYR+WA3NigD9XEAdBP7jMkCeGFBAFCCz3wAOxE
	 bQzFwzB9xHRvtpwad2yJeA9MRRqmxdccUR7xF2GG7C/jJmSg7+83t8plPVTxb4/536
	 Jf+/PaswgN0DA==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/damon/core: preserve the quota passed to damon_new_scheme()
Date: Fri, 25 Sep 2026 01:47:12 -0700
Message-ID: <20260925084713.46887-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924201615.4478-2-kmehltretter@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CFA4940002
X-Rspam-User: 
X-Stat-Signature: gy8tom8goe8oonqy6nkhnoswqhgs1qsp
X-HE-Tag: 1790326041-373302
X-HE-Meta: U2FsdGVkX18AjTFu4j6dmPZagj08cQfRH9YGY6sHN82new/VKiaiuVz0aljjpTwouuwxmVBgAj46URa1/wNDciwU6f+qbvSZvquuzZg2R1i23lvIRPfJXXQluT8IF0ZNNoradURnGvdbFMCzRUHJL7l0iURPay6MYUlJvIrn/1NjOvOoZnbSt1NAxrHVEQPrPxjBwHnvvAKWhK09S/f1bGNoQGJBLs890no2SVF1fJlZd/nUrgeyZBy/GA9dTl2U7II0Mg2+IcncJAquuWe0mCUlKMERVO9fBgEvJUFP8/MQ/dUN5e80rMBqVgCxM/HRomi9Kb/ZtDS08hJZrpj6qoiuGcF6UsLXDgEqIMMngvTtJ2Pb7io4Kll+ZlEejXQPkxIf8vJqG47Z/UlabyNW8raY6wOTUS9yoW46TU214bGx1SsKXB6Q6Slmj49ctBdEWfAUXSHLcJ6n3UuMwIIeExfS5dO/PZhRtcpqgw6TBKbtT8XY2bbW2mtND7c23BAuTv+q6gl741JeCl8OdPgkj4zY/4+zR/136D+0H3dyyGc1ywneF+8nLDd+23L/wrKLDtayBHjS+2b8I1yy5VfFAooWEiikx4DCKjhqB6+9cGga1eKNrSoVwwTylmCLVAg28AgXJ8ApAs9jpFgc9rQO3eS3RBkRdYNQGb21Y5UiacjgVW2qq9Q9AyfD/Be8ovsjB+I2ZKlVv2RwdlK1hbg0vTDFaBnywYHeSsRy00fDJ+C3KtMcPdDU/eoCW5h19qiLwakUx8OQuIyhDn08Ugcsln/xfOgI/S0QiEtqgzA63MEXeRHjLN7LA7N35jS9bqp5pEGhrhtZZpovGF+LW5RW5UJv+417p9h/AtFgk07bKqVxP+VZfqRZU/HiHil0YUTpCnTZ6jBwfLXhxA8Gar9ywkQFSy6OForRt2Q244VLeuka4Q0qFLjdnlIQABBnJlQExjvX3XBtsyImtVz6LMO
 LmJ8x+LY
 9o/9rzaX/PE3MFUF/qdf+QVFK+B2xJE9E6N4qxpVLPY88qGE7Mbgy/W+fZLUd3Am2zIr+/B8iHJ6ushT0gaPEumFoyH0se257y+Xk9PTfbb805SVn/xvsdit8TmM5uVn8hJO/1aaQRCUu5Ish2j2Plv9gUkbvm9bPE75aAegIjsBS63PuHizwV0/rn7+BxcwDWWQuBCVzDXPUOLHPNFc7vy8wGGg9ev2MuPO79/aBFArc6kHtIe/WUDCudnFqxsIvctcveHbnH1VX79kdmBdHJD4uQEqWlu1tfbJw6QJJFfpYcC3xo2rChamLCIVx3tKOn6FKiEB+3fZGNq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sep 2026 22:16:13 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> damon_commit_ctx() first commits the running context's parameters to a
> temporary context for validating proposed updates. When
> damon_commit_schemes() creates the temporary schemes, it passes the
> running scheme's quota as the quota parameter of damon_new_scheme().
> 
> damon_new_scheme() calls damos_quota_init() on that quota before copying
> it to the new scheme. This clears the running scheme's effective quota,
> feedback input and charging state. Even an update rejected with -EINVAL
> loses the running quota state.
> 
> For a size quota, this discards the bytes already charged and allows the
> scheme to use a fresh quota before the reset interval has elapsed. For a
> goal-driven quota, the consist tuner loses its accumulated input and
> restarts from its minimum input. A time quota loses its throughput
> estimate and falls back to the initial estimate.

The end users will show DAMOS works more or less aggressively than expected for
online-commit updates of quotas.  DAMON provides best efforts by detault.
DAMON parameters online commit is supposed to be executed only occationally.
Hence, the issue wouldn't be critical on sane setups.  For user_input type
quota goals, online commit of the user input score is expected to be frequent.
But, for the case commit_schemes_quota_goals command is recommended for optimal
execution, and it doesn't have this bug.

Karl, if you don't mind, I will add the above user impact detail to the commit
message when I apply this to damon/next.

> 
> Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
> destination") introduced this problem in v6.19 when sysfs validation
> began committing the running context's parameters to a temporary context.
> Commit b90408ef1163 ("mm/damon/core: safely validate src on
> damon_commit_ctx()") later moved that validation into the core API,
> exposing other callers including DAMON_RECLAIM and DAMON_LRU_SORT.
> 
> Sashiko reported the same side effect [1] on the RFC of the core API
> change.
> 
> Copy the quota to the new scheme first, then initialize that copy. Make
> damos_quota_init() return void, since its return value is no longer needed.

Looks good to me.  Thank you for finding and fixing this, Karl.

> 
> Fixes: 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic destination")
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20260702212143.0CB6D1F00A3D@smtp.kernel.org/ [1]
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

