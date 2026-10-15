Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A54DCCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A28C06B0092; Thu, 15 Oct 2026 10:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9B56B0096; Thu, 15 Oct 2026 10:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C88E6B0098; Thu, 15 Oct 2026 10:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 694276B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:29:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C91351C442C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:29:42 +0000 (UTC)
X-FDA: 85325094204.29.93D1067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2719F80009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:29:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RYKJd47h;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792074581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPAts+uUcTI+ZJqIZJfnKHgPxPJV/e6f95NzFOwiLqA=;
	b=mGpeSJaP+cF2rsydFyKJTNSRi2NznFa63EZRjaYXcHxJu0bE8QEY3fd3d+hK5RVFJrKend
	9dgJdmzc1SQUf1cFlGMYetG6RsIP0q/OnLK8h3biAPJoNCbYhT2to8Fxoqw4QP60xMt6HE
	gtTSHjHvj6UDjjKf2LgqR4fn5M3kN9M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RYKJd47h;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792074581;
	b=FHM+6UdC9gSmLNue/HROE2p8b7UHa9YpPJKMH0R1vSpHxRiHKkapYViSe2Dm5Q1edu9Y64
	NVJx1VQDExzKBuvM2D3p93G5ZerAjXQHX/XO2r/UFpiuCceCzoADSnEpDHuvpvJOycQyv+
	3hKzdbHXzvg4vtDDfOhH6jlh29fYILA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5180A40DF0;
	Thu, 15 Oct 2026 14:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063BB1F000C4;
	Thu, 15 Oct 2026 14:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792074580;
	bh=SPAts+uUcTI+ZJqIZJfnKHgPxPJV/e6f95NzFOwiLqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYKJd47hiyUzqHs8MMIh9FIivuj2meXfyydKxLinzssikP8bqOVeKCS4lU/mRu/RB
	 KBQfnN6Z18soRyxT9PwnIE5wwaZWphUveb5UbF2SjwrWof6w9q1s6oVSl4Jr6ZV22c
	 GRIqqPKGakOgl9e5VKAsjea+t/FpSdwk1AhptsS+B1VFYStzCxA+NS3CnjZME2lLK1
	 UqcVxkfY5yLi2AFeosxtglgQtz4eDph7AkPwgzVqsIq0jKc7y1dWKmAS7JHh5+etdP
	 guqtz9p9yUWFy+YCjNBoiQ3hUtUhDTcbZoLNQ0VIOr4p9AMCHowrh6wok5eERQkF6g
	 TuFMG89luTMkA==
From: SJ Park <sj@kernel.org>
To: Suhaas Joshi <suhaas@s-joshi.in>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] mm/damon/core: Iterate over installed probes instead of DAMON_MAX_PROBES
Date: Thu, 15 Oct 2026 07:29:32 -0700
Message-ID: <20261015142933.105760-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015135533.18761-1-suhaas@s-joshi.in>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2719F80009
X-Rspam-User: 
X-Stat-Signature: wakjs4mouaekw5qs51t1i814mn9zkzzh
X-HE-Tag: 1792074580-834695
X-HE-Meta: U2FsdGVkX19XcpzjZhswL/ArxE7LatTz3Y7rxkyfnjISqoG/e/LC6thXNH3EvfGSBf2gPOi0YdD5CTRK67wBz4H/cRdBjcSo600pUvX2WOlEM8msYJNExA6ctPLUkxrelz5IMmR6zP7K41jGH9LukA1c8NxmouHhaAcoudJUNEQEsD+Rb0hsk5t+LqJL/Lb6yRbbqPs3f3C7bWf5ryb23qzgy5+SKdWSnLk/nQdvVoZLoG8WbftrUkPjgOVmhw+eASimIeyVjEur7O/wRTuI9EZY/NUf6G2/RBH+0RknaX7l9rSIlsbD4Ai0XknoiGGkN65v28jDRFyBTSrnN3jVRD2ZU23+c6h+4JfvJBxe2qLdYul7JXf3+U/jwFYO7UZNDyN1tx3Yqs9eaK/qGf/qiis0VJqDeWK9JePINaRZGSS7ETRIxUe2x3r8ZMmmIYpL525I/u9D8QKGf4+47jv6aCU29tnyxWsC7p1zim5whg06TcTutUi5sG5SWa40XDnuFm1bw6h12bgA++UdjXbQBIld8dFShKkOMqiMFfYqDrM9dpnYyBNQS4/PoFgRi3KIMPWkNXDNOag6xEQoeVj3GzNxLfmRaVSl2ZtnKW52p0h7dI+bA8qE277U90ZlctCO92j7618Fjy2Et0YQjxg8KZSceOlpx6jZHqJ9dC0Fes7c/Wu4sqZLlJng6a1mLiJQF4xkEIcRNAuSw3CZbjLPqMDOFxOr35u89OOOl+qpUn4mmMAtevZ3IAN+uO/dvTuuk7Yvi6YTcC6Qiyzrw+e9a8NXpW9fV4Z5cUKtMwvZyiEW/OCMGmbpNnCcAl6e/IRHgQu8AEX8Ysebx0l0+Vz4g3MNXE/oZPYjB3vxcbsluAFKOzh/mcqLav8HTXYrGcMmwHMzj8Wf7FpBAtnrIAnwRxAnRQhAXjOMFUNbP9NlxCILr1k+REZCT47ycTRM2hjrUik3HYYeGjkQWgmJ+H2
 VtnePcRW
 YqO7r11o1RN2Ew6qdufvqoThtepvmSO0pqQV8A09JADS+SdDa2MOo2KZ/69r1GWirT5/H6itYZiMeTXlFmkn7xcIvDPuQWTara2f20AvqishpL44UxuXfd1gVtJCfufgh8CYqP1GuStli1WN3AkNDgHDKP+SJDL0w3aBGRe6LjS+d8f+g0SiX2Kh/g5hdXyFrgN8Q6LlSVpBrMM3Nu3ZToc66O8hC1zy9HjEfnqHDgHftDX8cLuhCJp2i/dUHrRg+bmb1YFkgIeKBEbWKL7P3cFHjYUU78msZx/F4rdO8dxQE2fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 19:25:23 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> Hello,
> 
> This is v4 of a series I sent earlier. Please find changelog below.
> 
> There were two "todo: " items of the same nature in mm/damon/core.c. Both
> of these suggested that we should iterate over only installed probes while
> updating (last_)probe_hits[] during merging/splitting regions, instead of
> iterating over the entire array, which may have empty/unused indices.
> 
> So this patch series does exactly that. It replaces the for-loop over
> [0, DAMON_MAX_PROBES) with a damon_for_each_probe() over the probe list of
> the context.

Looks good to me, thank you.

I applied  this series to damon/next [1] tree.  We are now quite close to next
merge window.  It may better to focus on making mm.git more stabilized and
therefore ready for the next merge window, rather than adding more changes that
are not really urgent.  I understand this series is not really urgent.  Hence,
Andrew might not add this patch until next -rc1 release.  In the case, I will
request adding this to mm.git after next -rc1 release.  So, no action from your
side is needed for now.  Let me know if you think this is really  urgent.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

