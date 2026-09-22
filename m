Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75D57C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53BEF6B009B; Tue, 22 Sep 2026 08:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED3A6B009D; Tue, 22 Sep 2026 08:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A3B6B009E; Tue, 22 Sep 2026 08:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 225646B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:28:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A33561A0433
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:28:15 +0000 (UTC)
X-FDA: 85241325750.13.BD27672
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2785E40009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:28:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOMlpXB6;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790080094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAPsKVQUv8IOqU7rxK33jeBLp/R7c5bAQs/dZ2U9RP4=;
	b=xFZuB4xBM0m+NF51dSk+/dp7uVeA50clvHwYLA9ekY3nTF5budFlzNw15ZCCc7wVS34jpQ
	H80nulxzCHwykmhZbOg/VwrjYRAAjGelj/Dm0FRWbk6v+gsKlAU3RE6wGStCHadxVNr+nk
	w7/olrY4GpDPaCKoHgVJKz/wt0/Kab8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790080094;
	b=MYBxzcdfaXnEmj+KExWr0/d+eAOYmOPwHsP6VR8FTOgLfHRaNZ+jHuN+vkcMnQfyBGeUuT
	5JVBC8z6M6ZP+1cqXjKQWi7wyrvz43uFSg3tz17NFgGNdaKMLM8sKWPkioQd1+eOJ5DviG
	bHXT4EoV3qtY2BEHh9khydkEsbcjOPU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOMlpXB6;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF8D96021C;
	Tue, 22 Sep 2026 12:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C305D1F000FF;
	Tue, 22 Sep 2026 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790080093;
	bh=uAPsKVQUv8IOqU7rxK33jeBLp/R7c5bAQs/dZ2U9RP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOMlpXB6Fp14kHIQ98lrV+zKTu+DIcI3LTzpb2qkCj2dg+VWDirc2/qEQXFWDyCKF
	 YTmhffCenEUFn9BXW3Cs9B/R4c9x4Nkocqkhi7bnJNJl5ctCz5MupkcjvATe5yOr5I
	 GwY3wlsjuGDjugyibtsAC67LYxui+8O+TZWdpWnsDhV1iicnPs+5CoAXxAciFcwyBy
	 4RB35VIsyRM47Dh4450fXYfZBR+fUx765j1i3VwJZYBUVY8pNjlqiyVLRGzFL6mp5/
	 jQ6cQ5abSxyaZX5uoOiw+ZwBuhhLLNxRn2kgSQbFWzCGQU9XjV0CeXd3Np9hgVY9HS
	 fNNqzY/gPZ6Uw==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/tests/core-kunit: test preservation of caller quota state
Date: Tue, 22 Sep 2026 05:28:08 -0700
Message-ID: <20260922122809.2589-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921003047.12041-3-kmehltretter@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: r7i3h4kp89xfj696t81w8sr3onsnc8ri
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2785E40009
X-HE-Tag: 1790080093-691167
X-HE-Meta: U2FsdGVkX1+ig6CHawfEnNRXd7sqKw5uZSE5QfbavnW5hx1YE+5T8fKuiyde4wtVLvoSa5MKGY/Ps7NCK8lu+zrKacTjZm56yEf6zEjmR0J2nkTyQzIcQ4SYgs/wzlVgBvEc3c8YDKS3ppFBCO3ticZ7X6NUDHtvI1Yvt4XYOpWjIg8fBoHnMY9rZwWf0N+Vmbx+WM2DMf2NaAxBxK+rXaIGVo+oHXjqBxdThXtttaRUEujQalnkh2QOegX/jN9e9dok2Negpa8bst85+XAIzyRUVT6zkzZ1qJykWBX0FNeiAcoBJjIhwcBIK9gI9u9gnh14QYl1GNnieLPMpXXbw9I7QsgTjEUgLm3ytzBcM2cwNIZhkuc4pW39wcQfgvHrAF+eY9vjlfNtBcMvy2MKfIvdEiCiJ0QVcjCW/fDYJtitXJqIxChM6xkuQfFdBp4YbmfC9Yxvh2ErAD5QlpTvzPisJs47CuaLowlqEpC6yiQkksJ1/XuV6CBcILxn5LjlWWDMQRsSjOV5Ijwmj8obDIfc/6/NLIS4rIW+7k+8HLttNejYBsDiUCZWeaG/QMfeQC3JiOWOjP+aKpatMGV34sCy4ucbJT6+b5IcrL6YW40b1tUMkFoyxNb/FHsNIg1JiAD72982qBEJ0f5ibOwG5ihHb5PGQu/LR2KZc3zoNQerl1D0KOyRMZjSZbndW++lmrJLe+3lK9q9+A+a1N0FHwsZ+kGhycqvzp0hqP/ROQ2i1YzKngwrg2Xkn212oie7XyR80q45vMGAZE6vJKh2EfkbfnEAd5+N/i8OI5Vl+eKicP89XFwVtTLf2gzYepTaJftBbcrzmzkFV24uIgEXdfGDyiLDFhZqHeM2gB+lvqXgbbdUuUGuEkM4on3IzAtem8A83tFLiFxAkhFyWj1j3JvtfYA2JKbrnl0OzDt2as4diZl4NgSunQmpnMmMPCzlyXTHVpj0INZ7t+dJtD3
 a0IBwsG9
 pC3zcr+M/81q7nPmRJRoskmhXDwfCNPdtz29K2TlxlXXxBrQc9NK6ZG2M9uSTxyLArrZ5A5AwgkC83kutRi+OlbFvN+m2lZzzwMHUHcOBck0gTw2mUzpzN+/XMe6TR+ExpXxm0TrJDQJ3cE0j8wagaPEqM5jFRcyH3JdIJ1+v1jolBdQGpm5bH4KaJ91OnfB7YQmk1V/84SspKlawo+wWAx2I5J4ufGeWWYNPKTIpLwLNtNravQGuO6DPP6V20xLSq1pHgkSMXdhQqjUkhUdhnZzWJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 02:30:47 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> Check that damon_new_scheme() initializes the new scheme's quota without
> changing the caller's quota. Cover all eight fields initialized by
> damos_quota_init().
> 
> Also check that damon_commit_ctx() preserves those fields in the
> destination scheme for both accepted and rejected parameter updates.
> Use an invalid min_region_sz for the rejected update and confirm that
> returning -EINVAL leaves the running quota state unchanged.
> 
> Without the preceding fix, all eight fields are cleared in the
> constructor test and in both context update cases.

Looks good to me.

> 
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

