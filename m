Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D1DC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6E346B0088; Sat,  5 Sep 2026 12:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E956B008A; Sat,  5 Sep 2026 12:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934686B0095; Sat,  5 Sep 2026 12:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 703286B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:18:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03E5140352
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:18:38 +0000 (UTC)
X-FDA: 85180216758.11.6A7EA63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6FD5E40003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:18:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8zgU9H0;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788625117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztJWHNndszqVgKLDx1R/A4VohrYyreeFEhhXiivVpqA=;
	b=LWhILT1rSmJPxBarlioR7F/jpcETcP3Ckheur4rK5BqQC1u1wx6oy6EvJkEkglgR02eQaQ
	dks0w/fBbV/f6LHMpUnR8MbwcnnO2i3u/OtVHHPZYHSfTLOGU6CXxcVAWgiK5PXjjPfdoR
	fxb2kdmG878IGLEBzG/3fPtgDKdL/8s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788625117;
	b=085IHm5Z0A2Tgv+AA6KxAV7+vlKGPceToU+uINL3gUHvYVz7gwmJzsIgkl2qv1/aO38vIo
	gC83TL1EjKUWfr7b3//77ivbWQkPEnd3C1Jpfkv8xK5DgrsxwpNAg3LT99oVHP9KF3O2eC
	zaiJ1dcNMn7N9Sf2OhZtok//tq/+2kU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8zgU9H0;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94324601FB;
	Sat,  5 Sep 2026 16:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127961F00A3D;
	Sat,  5 Sep 2026 16:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788625116;
	bh=ztJWHNndszqVgKLDx1R/A4VohrYyreeFEhhXiivVpqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8zgU9H00aZpT70CsDofrzplGxWbwzHQdXgqfYP/hYddK7+05sSjsy0/uQ0qOdUg+
	 5x1hS1NIVbpNkhc5xBd51SDJvB/RKA929EuUuQGWIGGJ05/eQnYVfj9t2CVepYEjcD
	 aQ7MJCUS3a+CcfII222AgXhl217yNDg8HuSvMKLtKO2R+/mhBCjAhEuOXc9rLCBJ6n
	 hgp8ORGqLeIzMhWW0PYzETP9HXWpv8trvWguWjiUAf7JrPt8FTbLRlB+g+4CNBgrzu
	 jD6ISZ0S+tvoSenMT612tncv13lr2dtbWSM+CAKKSTfULK8Birn+BdUyA/+d5DgyXa
	 eYjEEB5M4gFnA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/damon/core: allow esz to be set to zero
Date: Sat,  5 Sep 2026 09:18:27 -0700
Message-ID: <20260905161828.82068-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905124706.3398-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6FD5E40003
X-Stat-Signature: gxanhoanumfntdmgxx4b6e6xhb88chgf
X-HE-Tag: 1788625117-584350
X-HE-Meta: U2FsdGVkX18zepDEKLfX69r3VijSJI2wpG9Ucs27nb+SvQIQsyOagNlYTnfFOjyZuxRWsNnD4TOd9e1y8FH4Yvdm4Ob0ZV1dHD+EyxwJxvTZReq6Nvv73SQn4jH1Mb6i1QO87qoADMg1mNCeQrpek/pvmQI5gtJjxgtJoSqxs7bNK8noO1ixPE4haPcRvTyJrrq/XANgbIv7On1i/wDQkoC4d2vmRJr8/MaqrO6bPGkPtkh3NhRTrmmwd0dRMn2eqcH1egaaOvqsU1Ih3C5Ldh5o/Q+P1cPsT3aYa9/lif8Kq81lo1y0uR/VPaxlJI69YATMnZhv4k2cx+Ex3vIAThR4YssWugxO8gt5VD0/6MChQ5jLRhsfHKI96yXvMbcMNy8rh1+ZIKfGLYsfFS2gOiJO9Kt8ahtv+A6UIVIx8Oh2lKCmk5zjoUFY4SXm99jHHdj5EZaNwYYBkWA4q/HZXda5bot9BEmHfLaVlPaVBEbuuIMCwYgupoqlk9Adb3jmIPpRT9yTymwZLFik5V9gyh7jQfWML2Wg6fFBr0Ir040hofTzipc6b0tVloCPVZtai5qfVxhclhpnxOnU73P3pVJ/mUmcr4JcTCKkDAYutwEYolePtOt1FvZz40ff9HVqWxYEVQu2Js614P/HNYAAXqrEl5AdOdKUqOVgbCgoIjeju3b70baV13Ez3Pygrq2ICX/AvT9j9KEBjGTUjhQZomq9CpYB93hJPXAJNvvTLpnQXzTj30zfdV+1iOgl30ieRqjruX0jXaStphLvwkzoSoHp6e2D/7X4NhXdABcShYT6vkoIAWkNmXOMdwki51n4dCTMAP6WMD+xhj1RUZq7CQDEz/Z8cyfDJxhUuwi71Rp8rwoZ0M6Idz+XO+hSIqlO7QdaDuJeFDFDq5XMa14XxZoRYpo2OE4GRJWpfGmWb4qfLiwFZ+2MQQULNjmTi2SWg/idlGSWFZcujSUwXSr
 lgUAUIWO
 5jVW/F1Lqk6hMqyCFzWTjO8wtw52lsLukA+mgUwupy7tUox0kg8UejxomPD1x2JxbKJnN5Jy41wIw9SG+oO3xrPmHQGhsUk3qyKmK3Xk30nmDUQWcCPWdkGAGDpEk6f5xc6XIIMRMc0AjEgaEgPxZKBRklIdmjfP9lHapkSceYQvsFAHEwzSVkOb82bmCeT0dbz0iLCEwqw1TqqwolvAo7w89dgX7kUjIkfpnQ188XuDtg0F8vHFcuko+7n1j4j2sQY1t5yrmWlvsU1+TV5F7DS68gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,

On Sat,  5 Sep 2026 20:44:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> When the temporal quota goal tuner determines that the goal has been
> achieved (score >= 10000), it sets esz_bp to zero so that the esz
> becomes zero.  However, damos_set_effective_quota() clamps the esz to
> min_region_sz when quota->ms is set.
> 
> This is a minor issue, the main problem is that it doesn't match the
> description in the documentation, which state that if the goal has
> already been [over-]achieved, the quota will be set to zero.
> 
> Fix this by set quota (esz) as minimum as possible.

Thank you for finding and fixing this.

> 
> Fixes: 8bbde987c2b8 ("mm/damon/core: disallow time-quota setting zero esz")
> Cc: <stable@vger.kernel.org> # v7.1.x
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees



Thanks,
SJ

[...]

