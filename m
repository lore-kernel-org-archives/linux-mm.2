Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35817CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61AEF6B0005; Sun, 17 May 2026 14:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB946B0088; Sun, 17 May 2026 14:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2A96B008C; Sun, 17 May 2026 14:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB576B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:16:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C926114050E
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:16:36 +0000 (UTC)
X-FDA: 84777717192.12.632F258
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2BEA11C0003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:16:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=llW5hoWy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779041795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnK8Y4I8b3A9ZA7xeXp6IdYCIGxo0eaT42beYbC2zVk=;
	b=vkLZTi28vnzlBQvVa1y8kuQEJVqiCJhorCoeb+eZvip4v+BfwXJdxXyFWcuG9n6MtUH//r
	dsG+E8dFrR659WaXJkw7jX3Z/AP1TbtQnHGRsOkdQjUuQX7LfYoJXeYaWZh0HKfxSC3uoF
	pIPgAFM2ewN2SB7/GkG0iZsJIa5DFok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779041795; a=rsa-sha256;
	cv=none;
	b=HSCdOjmHZaNQFnsFeGiZbpzfKXDrGaFoYimR8PMFXg/D9We/WgCjqr1kL+SJ/HIVFoSV+2
	UiJpf1i9JnC2pP53/X43cDw/noBcG13x8vW2AJa1DLK/wVlGl/jK41zjVxXasBSdyvqBeS
	smJ87DjhJ8P6ohXWtejcTNyEV4YmNs0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=llW5hoWy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10912444E0;
	Sun, 17 May 2026 18:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D74C2BCB0;
	Sun, 17 May 2026 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779041793;
	bh=2LjQGuHt3gJmMSN1V5zTjOPDreXxMJTzVUenpE4AQek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llW5hoWyA3xyVDIgX27lTy8NwbkEMuA3Qrv8t/2vYHuGeKeb7abfH3H3NvZOl7r/f
	 XCZvTs+0b+QY8lLv28kXx5Q08z0c8AomK7ues0nwgsuatcq6MKmAGHSqPHxIs+cE6z
	 fRHYbjspH3Xe2Gk0JojMaFO3o445zI31wQjMdSNNpwZ0CNsHl5wtDt14DbwrTDcTys
	 CMeIdNXCuUM0o0W2eqnlyJxKsIWC/hsBgoISeqYI1s/3srSV/OTISVnhACxkOr8a5K
	 R+UlR3osIjrKIOXyGSJF2nHRjS6cqXjKndeqMogL2ea5W/MaU6iBzxI/h/TOFujjUA
	 xfP+EfKEVcMQQ==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 1/5] mm/damon/core: fix nr_accesses_bp underflow in damon_moving_sum
Date: Sun, 17 May 2026 11:16:25 -0700
Message-ID: <20260517181626.4104-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516210357.2247-2-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2BEA11C0003
X-Stat-Signature: eg9gu3d3sqo3oukquackertpgeb3zaf7
X-Rspam-User: 
X-HE-Tag: 1779041794-184077
X-HE-Meta: U2FsdGVkX1/GpmPvnQz8N3XuFyVO2Qw4M+mnxwRU/l0N5kA9kA/76KIkX3wRTsPySvBH3mIA5lhmkDaaHe/uERirm/PZKeuOFLGD5Yv/19aRG6CbDnmYSfGaZMNzIhqTJJukd+BS/xE35SdDSNTjfboOWIXdUCplRtq2Vi9g4vLyPklQVZ9lIqCXEt1rt3WOxvDNtI7CV7Def6sMslY1TJVSqE9UE0HCzVp2AWvNQW4IwCec78Kdgc+CKRUwcCp1/XJbolfebAh9Al2wIFu2au+wMFzRl37c+jDoSaPrzHshCGSNdEnjqbcjlyYfr0ozoUfdJFv7gU3nYZe4GPpD4ximcAsKSM5CNXILYb32kFEm/c1T0pHkxpIz5Tt7Ft6KRd/hNOsTai6R6EqaSp8sWaTR9+oyLYUctgtX9AXNlPg5aE5AfX+MiSm1zEtmklOKWzjddwmidv2LqWvK+6vh1bpxdWsr60y+XSGV8O6xm7ZIR5Hz9LbTtnouN4cs2VnfjCIY2QZyEKeVUnhCtJtfY8MV9XV8M5tiOCQs5ty+M8jBlMU/BIDGh9IbOlr4oRCYxofSZ5zhsXA0HGzvG33V6dGPLZj1vAElpH+BliRGAAU0iJV7t04u2MFZz5gyLaEkVRV2UnYFieREQPOFCVmf6EK9Qf8qoKnhY3D5Qvbc267ADyzp3Q0dsU7clHloJ3g6Vcu0Np3+Jg7L8TiJMBk/KgANOEQwi4SwOeOTZ83/hX2h1Tnu72bj0bfRNWIhsr1xO6SGX17B9drBaESjKXbWUakh9sTdIfrDdyon2e8xBghGRnMIAULmrzscuSzYc5CMWYc/XNWx0F7YF4pVD6IH4Tgg5NmlbuLgqMiHR7O5DC5wdOLrTDcltaiQwGYpN9O95Nx6vx1+c7D9T6xS67Ol2j+FObeCNO7EROl8ix2f+edKg2dsxdbPXPfLkGSIgkJx/5+oFJwGzMfDrrYEQCS
 rRrwoODD
 kaMZbGwWwoZKrtGZLpozlYSDufRzViTjOiCl2RYMzkuz/LWwWyi/JwQFTTh6p3BvQok+5tFuUixg2daW/aca0jXgPmiEL3Nj0DTYxJQR/E45pgGP7ElbXLdrJptDA2MQbDh1q/+fZfxEU2iHzvOihpX3kNsw35M8y1dqsQtSYGL3MJeTauOiHKrEZcBtzBmbsAD0jL3RkF2sw9w2IWlLyM+oue47hMeddfsmDP2iOyBs+1FQNBH5/KdY9UfhZKpukeGQVoqYhJE2iZCv4HFVChprZS8lexi7+w98fa3EHvFl6ab9e0UpII0ptm1ZsKJjhzc5q9vrF0Dd5dNA6gZiaSwh6L/ZRBBBbsGkX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ravi,

On Sat, 16 May 2026 14:03:53 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Guard against unsigned integer underflow when nomvsum/len_window
> exceeds mvsum.

How could this happen?  mvsum is assumed to be same to nomvsum at the beginning
of the window.  Hence, even if there is only zero new_value, at the end of the
window, mvsum should be exactly zero.  Of course there could be a bug that
breaks the assumption.

> When that subtraction wraps, the moving sum returns a
> near-ULONG_MAX value and corrupts nr_accesses_bp.
> 
> If subtrahend > mvsum, return new_value: this clamps the moving-sum
> estimate to the current observation rather than wrapping.

I guess you saw this issue in real, and this change should fix the issue.  But
I think we should know why and how mvsum < nomvum / len_window can unexpectedly
happen, and fix that.

Could you share more details about when and how the situation happens?


Thanks,
SJ

[...]

