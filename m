Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B371C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 05:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C332F6B0088; Wed, 23 Sep 2026 01:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5786B008A; Wed, 23 Sep 2026 01:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC126B0096; Wed, 23 Sep 2026 01:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6656B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:59:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7BB0A06FC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:59:45 +0000 (UTC)
X-FDA: 85243975530.10.BDB0F42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3E96F4000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:59:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h8VgSOXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790143184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0q+UNTS7TEJdRtDKrLfE/EvgmECHCAwTbTZ2Ttusqc=;
	b=7SCmdfJnfAgJN7rHabPqnIhm1eYnu6DwGLUd7sjNuqVwQAsjWD+2TWuhZkqaXe5hQbXPGA
	KoeCFiKb31diNLQ5ZWfqEJ9Y/0X+Pd+TMvan/pbMdFSsV2bHy26XZBTaKRKtX/qYy9aiIS
	5YAMEznj5lWEmUv86H9e8lKSLR40oYo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h8VgSOXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790143184;
	b=zc+Bs5ZTWl3PZw6Tmb1BYI044U0htVVTI6ZC7iJ8cB9Fzdi/abTpV1TZrs9OKsReRjOKxE
	ByKDjJemJDBDI1IGXQBducK9WA40QCksMzuciLrI9GIy92x8EAHSZ3F+Qutn4OnyaUeJCr
	HHiGLSrHe+LYmEd//uSW7VQpLMK16Sw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71C6B43434;
	Wed, 23 Sep 2026 05:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1E21F000FF;
	Wed, 23 Sep 2026 05:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143183;
	bh=T0q+UNTS7TEJdRtDKrLfE/EvgmECHCAwTbTZ2Ttusqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8VgSOXe4RBqqrmytkAtjUaYqpFZB31iG18EYsKuzTkeYHceZmdu1gDbB9HrOqDlJ
	 uFvavOa8tcq5OzbHDrc5SnPNB5Q/MWDsCtjjDliUFCs6f9dtytrKzPMHJXp/jj9Vaw
	 G/Y9OjeXbYQ6DKa82i2CCcwLx+79TmTO1D+d1bdOn605DffZKS/Y1jvfqkJm2D0PiN
	 i0XHJXfBg5bR8fDO6CnT0FCgMVNTeieOiZnYpQBS9FFylEFTIZMtO/Wvgq6GnQMxWi
	 PSDa0eKT3ycmB/EGiQ9Mwl/i8y6Yd8yl+ugUEoNDnwvPsAZegiIULIwVcS3jBheejI
	 l9fUoogPcOIkQ==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Tue, 22 Sep 2026 22:59:38 -0700
Message-ID: <20260923055939.3495-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923002600.1825448-2-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ygsjimgismaftw4antwy4cnh6xmmt75s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E96F4000A
X-HE-Tag: 1790143184-970173
X-HE-Meta: U2FsdGVkX19B4JsWtzGnOqoOrHx1Zy4unwmIh8MjCZtCB/J01jOLMi4rbWOSwZbqILAIeAXk41+GgPEwYlFk0E8ZzWUt1xwO+6ZlAXqLio3z8un+vHByLq9TdVchu7HcDtzB2VkJ/6tzxCAZHv0gj/bJ3SPVxBBK8CCZkGBfJJI8LFLKhJpgoZBo2COXvVB7gLA9Yq/Zw3ibQTr55m7LMsqzSABwzSR4TmLBwk/SjqQgYI5E7hlVOIGBFF0W6xTcZTPeGRlQOLwz+2ay+58A9jZuh2RaTCxDJkr6h+9csukqVX5yiUq9tA+Q2Uke1nZDova6TVOH3ZEkwjl0caClHCPTQxfIRrV99cGp4PkzKaQ1RRmeCZznMCg/5ITQJlTDuEqb0RFnXIna57xG2lHax1FXpmDt9ylZ5+ONBjYc289d61owyVo91gg8+Jrm8SKBn2tP5P0fvCZ0cpbkRAteht0Yhw/sByFR+hKgfaX9azn51zUwDp32t7HfUEG1DK+bmFdwHX1uFQU4r+M7Hfuqr1fKOZoTmpCPK86+Rnr51CFXdFLr1SPsMQ7Kd8sRFrI6uZfXOm8GTGZE/iG4zxMYVp7SkBelI1uQCOIRwIIsd+r2tAr7SJZ63oG0QCMZI92hAJ9t7Bxcu/QfaiR4sg9QclrlEDhLjUX8c8OSjvZF25GdQUbUaUi2C0mg38H8KatVyMPMaKQ2YW1o2UFtGQaqbnD3xY2qfea7Wt/J1KH/FEfzNRsN2Z8RPK29Mi0oD33UmSw/CKMVCmu4R9hPXHLI+Mfka++R1e5XUTTLJ3Xg051THXF9Y5ePrcnB6TAGLoM7qPvI7s1dxsGL3GY9izjbRFQLzcxtrDpmH4YztNnSv+bnXycgBMjKD8UamuoKzSb2ORt2vokE13s95EVxma36wXiKS3XuRXp9o5EJLGK3H4uYIrFsQzW3T/uecbnibp9RccuVYFHXm1G5ncytG0f
 WNNwCJnL
 byrrbueA8iITrVvmXbVGE0N3xbUEf2O3RHbmdBE28kuyTRPx4eNfkYe/BEV0IS2NgaoQyEmX9STE82zwOdcoVXkY/pvfZFSF2M+paXTynQcM+kEBnCLPNa+yi/0Kbq+0pW6zvB36vlkCdSaVYDnLJZUtrVaBWHK2tt9VlhYOdfAiNJ9wR7mBgclmo3hXFNKEBoJxmSQ42kPZGid8uoVxrux+kLSC1KvP2yzke03Uo7uJEJoYIPRgdSpFV8UANFl1st4JZGohrLH5L29eam4OnL/WYjRxcDeAKjK+ury7W6S3kPgVhb+rONkZ6FJwLF8YnyxxNycI/kyIgAAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 09:25:58 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> damos_goal_tune_esz_bp_temporal() converts the scheme's size quota
> into basis points with "quota->esz_bp = quota->sz * 10000", both
> unsigned long, and damos_set_effective_quota() divides the result
> back by 10000.  quotas/bytes is unbounded; bytes_store() hands it to
> kstrtoul() as is.
> 
> On 32-bit the product wraps for any size quota above ULONG_MAX /
> 10000, that is 429496 bytes.  A wrapped product below 10000 divides
> to a zero effective quota: 429497 gives 0.  damos_quota_is_full() is
> then true on the first test of every charge window.  Other wrapped
> values are wrong without being zero: 500000 gives 70503.
> 
> Triggering this needs a scheme with a quota goal, the temporal goal
> tuner, and a size quota above ULONG_MAX / 10000 -- 429496 bytes on
> 32-bit, 1844674407370955 on 64-bit.  The scheme then makes no
> progress for as long as the goal is unachieved, which is easy to
> notice, and writing a smaller size quota restores it.  Nothing is
> corrupted and nothing leaks.  This is unlikely to be hit on a tested
> setup.
> 
> addr_unit does not cover this.  It only scales the numbers a paddr
> context writes to quotas/bytes, so a large enough scaled value wraps
> just the same, and vaddr and fvaddr contexts take raw byte values.
> 
> Bound the multiply.

Looks good to me, thank you for finding and fixing this!

> 
> Fixes: af738a6a00c1 ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
> Cc: <stable@vger.kernel.org> # 7.1.x
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

