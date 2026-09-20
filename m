Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C3DC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 10:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7746B0093; Sun, 20 Sep 2026 06:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887F36B0095; Sun, 20 Sep 2026 06:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4D06B0096; Sun, 20 Sep 2026 06:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA4E6B0093
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:41:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC0ED1403E2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:40:59 +0000 (UTC)
X-FDA: 85233797838.22.6A680F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6C99440002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:40:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jl5ily5A;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789900858;
	b=tMkws5R2nrAAOq/YFdSHdqi154B7u+XLBAawfrwq3Un3ah19L2TrDhRG6H0wARuO6VsWUM
	aN3ajdPgKxUvnA76kNMyiE1cAUufP1d0zEa1LIJx5K7Qo+rZB1lxA+0dnH2R0xiW+ZVC9W
	Egno0MIYoovcj5PCDQKTz8RBQk2WNL4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jl5ily5A;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789900858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0ar35JML3hYV9nkiEE/sXJ/W+HUlMH5GL/lIbPR8zc=;
	b=74rKenB8aVO3rGQ32Ya/gpYYVyw4iA+GLb1vFlaKMbzWFnpFjZm77j7X2sKHCg9WNxe8+M
	Qb3gVFbJ3Z2WHmoOuQ3zR0jf3vkbKBeRIUpJ5aPfWdNmdepabrcEYvWTD0UztkAveBCKnP
	mRSfIDTJH7MGkuYytIj05/87hIvCFMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1905601FD;
	Sun, 20 Sep 2026 10:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339241F000FF;
	Sun, 20 Sep 2026 10:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789900857;
	bh=P0ar35JML3hYV9nkiEE/sXJ/W+HUlMH5GL/lIbPR8zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jl5ily5Aits8qB1RPjNZHY6eIAr2FKO13WiN7n7BSp55opoujuaUt6nQdZyBQjsgY
	 our3hlC2LQUi7IHtRYByRJ6uACgKrW1nHX2Fb6ecqfTBYdOQttJv/mzJ0ioSKLbDHr
	 2evp68xCIuwALXS6zfVxcvhNs87rZEhcip2mvbC+KoERGKU4nLIbaFKNcXqz+0M+UF
	 l6M4E+U57XAN/2wLC4MkKlfBRihYBRClUnMXHBLGwUKjh4MjRX0vPRmVgUY4+OeFwI
	 gviArGiBD03hz0AC2pQi4xBOBh1bafQ0KlON4wut3plIh82Miq+nN3sc7moimQ2VI8
	 wMaU0p0JWvxoQ==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Sun, 20 Sep 2026 03:40:53 -0700
Message-ID: <20260920104054.47877-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920023111.2466265-3-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C99440002
X-Rspam-User: 
X-Stat-Signature: z3pzrixcuy79y7tm4u39kwnz4pxpkkfm
X-HE-Tag: 1789900858-188309
X-HE-Meta: U2FsdGVkX1+AULLTTbiBA6WDzqzDjPZWw06RELOtuEEcD4gqmGRXurtab9ody5oNkZ2WwEMELbDtK0ALeQEMRjNLlb1aRmglKZM19gR0r1WgDeE+HxVNg7xzlGfu3krXuXEEnd9QJBDfcp1+xCZh+jfenGmc6ga9cL8r1FAnkYhWkStTZwQUm2h3LMOV8dyBGhoLpyWEpuoTrcGRNVRB+yjNFpBvgnDIICjTvt258DsArjy0A0T4WjzK2HQPLagdfpq9gw12oBGIxr/zMVEFDdi8BKFNx0HhRo8oo7r98pqAqubr9LV3YmWnhW9BpRZG32ASvWe8HXHX5dbfO0FLbKA+fyld9ES4IWOaIOEIxg7JpkOgRenGdptU8cS47qhO3ymjv+PExeTpX1f8lXzv+6mmYRld/4SIuiQ4/wsjjIlx5V9BJfOjvzvJvND1TKX21H0uRb+6Xt5b1a6RCQHvS3GumFy9yQ7RMjSh26oq87paXD++iQ/FZAQQdcePK3VpWrwpsW6fsh3gPcWtmKX7fQbC7ycNHcoCFfc7MiwiMSG0aF37wWeH4F8osJr3u595aybzsOcV8XMBKTMFBlgu0cl2jcpvYQMwATOLtW1gjAnD+Ay+0uu2jJFkn0p8rRf6CSpwfqIMmUxy8mkmVjr1jLNeV2AmXmNE2UymoOhYfYt4Rdz9gDkt5rCotg2sa3EgvhuCYE85/1e/XZW9dUfrwJSnYB7SG++v2yhAkuaZjgC+jIKrCdQPZv3LhV7kEkZlOL0QbqMnue1fHiJt635r477K6rWwFmK7MpjPNvRge+H4jgTuPZ0uVkaRKRF+V9o5uyAfi5ydiSn0Zy6af8YP1LLKIJi7Dc06sgzxBLofa72XhoczgqZHTS2vMAlaUfr8GzaU/FOA7zH2aJ19mgeLtLFUVRdn3Z/Awglf6APak5x9wOZFCw1ykVNvot3LCNirW4fHCd+mLYCGscMyJSQ
 8bdNnH47
 oS+rIr0MhiBMpDT95/1Xn/98sMK1infcXPk418JIzoloj3W9aix/er6n8rd9RQ2l0rJ2lGDTeRvQTst6Qxl67hmu1iQP+RHs6NRbROBpPWIfR5+oq6EYa90FpASGGHDttRTEh783c5qO/G5h4goaaHEVEMAoqI9weG5wJQDW4eyboFjkXns6TSZt8rx4h9HZl6e+OAgfD/Ofyzs448n4/nbakesIl/N9ZzuO90VBGTViog1gzQWeCecVQMBSmUCS8tgDb/OR+zfir7nmttShe1JdECFT6SVVpFiE6Sg2DrJww6ONzTakAYSI+EG0d80C7j5l0Vbl1NzZz/tg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 11:31:10 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> damos_goal_tune_esz_bp_temporal() encodes the size quota in basis points,

Please wrap commit message lines with 72 columns limit.

> so the conversion is exact only up to ULONG_MAX / 10000.  Pin the three
> sizes around that boundary: the largest one that fits, the first one that
> does not, and ULONG_MAX.
> 
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

Other than the above column limit,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

