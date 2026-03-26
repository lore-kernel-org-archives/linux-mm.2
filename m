Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D0C109E54B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 06:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8B16B008C; Thu, 26 Mar 2026 02:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69BD6B0092; Thu, 26 Mar 2026 02:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F746B0093; Thu, 26 Mar 2026 02:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A927B6B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:23:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4059D14070A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:23:57 +0000 (UTC)
X-FDA: 84587223714.19.61E54E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id BCF8320002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:23:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E+uJC85q;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774506235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3Onzn3nk2+kHl8zVhn2m+flJ3zAZLKiAmchW6HgIfi0=;
	b=E3GSFJHWf00JKUIYvXMA90H3eckitXijbfdZg1WyFxTX8K3fWWfdyeMzuMNeQ7H+LTsCDd
	FvqDN046W/R8H4k5wlXKroF8EuAAGvn8L8F+TuAD5G2XdWCgmODZJHf2Gq3kH2T5JdD/Zd
	7jaYrsc06+/TwMCYQsID9jnnG84z4GY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774506235; a=rsa-sha256;
	cv=none;
	b=IeSg3Dy/5LxTdWq9j1PtfdYnbNXOeUa8oOpW14I5zNHGqyrk7euTOdNcOt2jy9Y/Lmz5xJ
	IJBiud/DzuTOgtXHJuUKjNc+ixPq1hlT2QEqpOx4fEXwCKOXrJT2TrIUCZyvBcuv+GHaMA
	/VgyRPNfMtirq9KXuReloZFbtqtfKac=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E+uJC85q;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3352160053;
	Thu, 26 Mar 2026 06:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C202FC19423;
	Thu, 26 Mar 2026 06:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774506234;
	bh=dMVkNZI0wrZB9u+j8RryzXGldt03j6+1zZalaSs4HPk=;
	h=From:To:Cc:Subject:Date:From;
	b=E+uJC85qyaMArvOTnBRnTOIzI4VauEoEOhqf0nStY+z5t/FFcqXGpbFx/AH74OfUS
	 G+bI4keNhe6LqqmZQkrSv15BhoDe/xX1e5AtPc2mXm3DjmWrC3KN3RbOd7k8X4v5ZH
	 WA+xmGusGmJm2UbPkk8tKUwiQbxtdnD3VVw0J1f3sRE5/lH5ucl9aorGg++Ze82Kxh
	 4dCVtUZ0kjLxImpsgbVn1T1kAcFSOJzgsDicafpg1ykPaU3GyllLfzQ/w4EJvAzwPe
	 aDJwGfpFiz8Ntl/JR2+nBCKSMZ0/um82NFCuVmw06tBGQRPfpjBcHGpPnSmg7sbUNa
	 qbRivVt6uLi0g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/2] mm/damon: fix damon_call()-related leak and deadlock
Date: Wed, 25 Mar 2026 23:23:44 -0700
Message-ID: <20260326062347.88569-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: e1s6j34edqfqdi1sx3jt1dw5wuj3j1dh
X-Rspamd-Queue-Id: BCF8320002
X-Rspam-User: 
X-HE-Tag: 1774506235-158707
X-HE-Meta: U2FsdGVkX19EorIigMUpFTJH8p2nU2mi5Xdy/hMXug/diTpRo4wlNjp8hke0UQgNR3WrPpTlxGjSqp3Gg24JZuK8w5lQ4Cooill6/JsZ6BcZ3KMhfv4s3HoYUME+o19kgkm9BOWGS9rqc/4usZggtmVvqgWTCdvcYo0c4EfP4bgAB3SS65C9bzEL7+syvwzzShBCZnfD2f5OliXLIwSYHwF2hTUCLTvc8y+S6J1KOrti8llBzs3s7o85VSxS3hAJUGlTyxtXBsYSFVWz/zre4MWJJALoLQLZF4n8izjd7RxGCGdXMXNUiXtdCnnqBohyJ4+MQl0O9SykKObsqrwXn67LAnBq8jIxvavZSA6cCN5FE+RRBYJISR8iplTA+CJn4U5c8a9eKiPBdFQF4qlRs95eHC5iYwSw8RIfTiJxBOkIHBvUKfjbgM7jdvcJLSWjmGgF2wgGMc4L6OLIooKo3Xu4xx/Skzv2rUsdcVOYuBlLGyUUwnrAfS02hxxF8vXFpYU9BFNihe5wueHvD6nFc5cuwxbC+45+MFd00z/6NQsc1xAHFPPj8CGjlQ1iODQwGDYxMDkI9I7GSn7ykScO9kzgB5RMY6Na7cHL4CW4XXVD+n0gqjt0agV1qO1UF6ussrMT9+Mc9AC6i9XTm5eS1iRoca9RCXpxGkWDiuUWaWzFIYbm3NfV/ytDD/EFGeiGQ4DmLAx4udh4qv6PrB5rGbXu9A6pco7Td8tiv+hMJzNiSxFzfe6v1fXgXFBGFXmjrP4TPDRw8yr/Xv5B8vPtmfTTd4ZotQLUABPeT3vq+MLMxGvFCnwPihABB+jh6ovkbl2MxD9pdUyuVGGEQ/2NaRkWBbGz26MG+UNupDl+4BQsQbXZFvqZYMnP7+OfDNZODXUNCFt/dOfElxSW7NOXNAAFa/mbazBqBt+m0dQhNK343VtsY4peLntpRl6mhSQ9imv2+e90Mo3afJP+nI4
 KTx8fDdu
 vUvSahCgPZ6Vxdazi+oMihe2IuP3KNidbEyfmVf29BtG1K8tLs87DQCklkl4RD/yhtFWWbj8ljmRd/W7jK7+AltrufDg53Kp60cbiWZiFQj0rlc2ZmMQ7QE1bSlvTHr28/dmbJr0CuzEx9+NiF2dMq4z7yyclF6wzbbwPvSugKufoIUKddAxj0ItrUZvtivQy/p/IndE6Uh7MqlNGHGlC2+G9+r2MMQGikm8Z5+87U3njlvRf7h0bWu77RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_SYSFS can leak memory due to improper handling of damon_call()
failure.  It can also cause a deadlock due to a race between
damon_call() and kdamond_fn() termination.  Fix those.

SeongJae Park (2):
  mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
  mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock

 include/linux/damon.h |  1 +
 mm/damon/core.c       | 41 ++++++++++-------------------------------
 mm/damon/sysfs.c      |  3 ++-
 3 files changed, 13 insertions(+), 32 deletions(-)


base-commit: 2b3fbc1796d335685d9b7a825c621914a1c97d1d
-- 
2.47.3

