Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D14A2D3942C
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051236B0088; Thu,  2 Apr 2026 10:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028F26B0089; Thu,  2 Apr 2026 10:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE2E6B008A; Thu,  2 Apr 2026 10:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB89E6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:03:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89FAE5A17B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:03:19 +0000 (UTC)
X-FDA: 84613782918.27.E42F005
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 998254001B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:03:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jWTi41wK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775138597; a=rsa-sha256;
	cv=none;
	b=c0mB4NJQp2vTBZewhNTcApmonjvu5mgboS9kVOyAkkv+9kmm1HEEFNIzbA4HDy/l1XDHe9
	7J3SxsyjVmUzjAuq2Q44Fjdk7z8Hm71NFqbwGt+mXVLjkSO9vc+Nuxk/qWX66e6rxZwQJQ
	uwnw9m3i5FTbFzMjWU8V1swbCrsR7Qo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jWTi41wK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775138597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FPGcP+kDehIX87/6xfQ8bQRQAkRp9wKDBvYlBTnOwc=;
	b=dzmCqhTCqhSSpUQFKPkOX0jqPdkLW726OBWpBg/3sVugqyY6cbXxaUwF7ujlOdmF7RGPj1
	e6YTQpMFKNwmusOfxpBFrdSSuvGEIaH/gcJth+VH/GE1pkuWfKHbzW/AoJ+/cHlY+VgXA7
	xthyL9tmnEmhfyP1OdJSDRPQQSe9x6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80B5A43F55;
	Thu,  2 Apr 2026 14:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33041C19423;
	Thu,  2 Apr 2026 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775138596;
	bh=e6K5RHxaYPNsX/mOpQptU/7bBIEdtD7rePbNU1x6dXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWTi41wKLZzU76vbzURPULHn/VvvueDAbYVV8qE9QmF/cHJS9Ondz4nFT3A8aDvLh
	 v+X7Ni40TK4venaKYSXn74/LH7Y7g803UsPBUrLj07JCDvlCVwSlPLIDypaU1GPf6L
	 vghHThWBZxTiBmehZfAUrk4FHLV5eFGhHOwXpRHXTACInTcMVEaQGUA/QAzvSivtXL
	 CB7tQ0z+oSNtfVXUOlMuoCJKLg6waHCvKDudZcjcspNxCi3yYX/AJwHc9EqxKek0Sb
	 X/RSjMCMJbbeDElWXHluqNhDDcxU0tjy5oRbNX7cS6/k2qGAzPgIPvGrjAqBURf0H8
	 TVLJqp7DsgHXw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon: validate min_region_size to be power of 2
Date: Thu,  2 Apr 2026 07:03:14 -0700
Message-ID: <20260402140314.74600-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402053756.26606-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 998254001B
X-Stat-Signature: 87s9uomo1xnq3ut37shepjog6rodifqw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775138597-222496
X-HE-Meta: U2FsdGVkX19JTPWWLnZEXGKYB9JVZDOJcoX15GKYSNcBsM1MLFg7DNKaEGZ+U6w0M+iQy7QCLCxP18iKCTElt0KmomI+5YqaQydOHZld7/p0JC9rSWw6aM49Lhn1xVdnkn6aXI/bPK9HURgwU2hauioEAsL2drT9sDK6FsH/j9zKzdlS1pVDkc+ZUdZO5fqeMXe3Eyekm8WgGjuOh3iusDZLUa9XztGuslhLmSLi3eGfjNgwC53Wpo1n/5mFiIntDISsVp3Q+Ze7R4RuVELV7wK4YgVZ1fCscur5yJ2NhiVtvnnG+Qn6dFNN9zP1PWY2RhNB6IdqE/JjfQBhFjSv/UkJ9qF2Ipfv/jt5wYKV+IGZBO7AzAIFhfz2RP5OLgKQKnXJyNlGynV7xVuAptkf2iMngujML2ME3nbqDigTdMU9X5pxNvhhUWWz78u/72hiNY5kQmnkaBXCdsiKyr/tW7IvYv/PoXbWevag5A+X95Ccx+T/ujhbD/hu9e/egJ/R5kzCaRGWz81nTVh/8s8EoS9a3AdLxfKHJBecQJwLohWTJXXcc/41QOANYfEWnb0bJoPzlU62q6bmkf6Behh2I9maACL+O0HJXBR3sKAnVvWpNd1JhvdTTU9mmx6D9LsC/FBPfafIYtZ6f3YE2RdsreXB4WU7+GMT1I6LFyE3FTp/3k7inxxPPeuvPSVi761TbovDgDU1HlI28/WCeBQq8A4B0eqn0bDZ/Zo6CUomoJqn0JDK+poBitd+iB2+zVdz8PpX8M0t4ksoJsmhkZ1Jkk/6Nv4Ng/LfTf6rsUXkr4H5cKQGsbvAF6gR8ByXRyvLiDyGX882MYZOn21vZl9w+zbtPxmhlrsbTbGsaNdjLJcdE7NkeGyLVPjeHKQxpxowXfMBT/fKwkp7QPJ2NfF9bpRfUOqp4Avsh3yLMinRpJfgP3WhUZipyFxsGRP1/Tp9I850kZF2KQG1zZN8j+4
 ghy4/mHx
 WVhYqk1JnkoqPtxeXwzwXPU9tepnxAeqa9s6buP4TxitdQqUfEaF0RQWubuOHfQKJoGq1MopCveqJjef9K/85e0UAkkBhSDcdEOgvPEzthxyLJGQ6C09msDavjzCiKlHOtTji2X0BiP4XLdgbAHHqSOXM7IBa+V/KvZxc0VgrV3S4ZRa+jbwmwl6Ts0ZQ9DW2XKb37oKDnf7OsY2+I1JknTW9jam6KlmLz5r7JE2SKMVXf2n2yUgiTpjr8rR867ZRFEZlwuxcuvluCqBgbThSLDLp0kEWfgcsG5GV6kTv1HNCkT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 13:37:56 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> damon_commit_ctx() checks if 'min_region_sz' is a power of 2. But if it
> is not, kdamond will terminate unexpectedly due to the user's invalid
> input.

Could you please further elaborate visible user impact of the problem and
reproduction steps if available?

> 
> Solution
> ========
> Add the same check to damon_{lru_sort, reclaim}_apply_parameters(), but
> return -EINVAL immediately. This is to prevent user's invalid input
> causing kdamond to terminate unexpectedly.
> 
> This patch is a follow-up to the discussion in [1], where we agreed that
> the validation should be done on min_region_sz rather than addr_unit.
> 
> [1] https://lore.kernel.org/20260330233343.4083-1-sj@kernel.org
> 

Should we add Fixes: and Cc: stable@ ?

If we should Cc: stable@, and if the changes for DAMON_RECLAIM and
DAMON_LRU_SORT deserve different Fixes:, I think this patch is better to be
split into two patches, one for DAMON_RECLAIM, and the other for
DAMON_LRU_SORT.

> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
> Changes from v1:
> - Fix memory leak issue.
> - Link to v1: https://lore.kernel.org/20260331073231.30060-1-aethernet65535@gmail.com

Seems you forgot the patch [1] before renaming of the subject.

[...]

The code changes look good to me.

[1] https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com


Thanks,
SJ

