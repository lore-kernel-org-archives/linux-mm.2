Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C49C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495E86B0100; Tue, 30 Jun 2026 10:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445DE6B0102; Tue, 30 Jun 2026 10:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E116B0104; Tue, 30 Jun 2026 10:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1386D6B0100
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:50:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 815D31C35D7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:50:49 +0000 (UTC)
X-FDA: 84936865818.24.C264425
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D8C3FA0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:50:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWL4hHLB;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831047;
	b=Elop05LvXwrLvOZhfGjmfoJfhFlVEdjYABB2R4KdZue5d6o/smnJErx8dqev8IuLD4B0RO
	aIcDgtY0YfBCGr+cRoqjaNQgHcAsu/gKQQOexLKn/ad2JHZFyoooYsQ07FA6ee8/8kly9Q
	EEs0YX01Ttc8YaYtDjqVGYKB6Rvh1eg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JN7uBRPSVFgxr8lo91sF9pDzgRuTFCqZj5C/tFQXtwI=;
	b=A8XICSRHVBu8mJh9ZPtmCk9fRuTMhXitYtVEGZFjY5MH2e9FrcSKsCScS9sbXN/D/zNEM4
	lUjAmRJtUHeDP7kzQiB1mdQT/wVN7uSn478BeUdSlVT45CE9scTdTdX4fuTUbH5MDraLze
	g454Thse8HmOH0LgKVyjQbBjnA6tyj8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWL4hHLB;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBA2641983;
	Tue, 30 Jun 2026 14:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AC31F000E9;
	Tue, 30 Jun 2026 14:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782831046;
	bh=JN7uBRPSVFgxr8lo91sF9pDzgRuTFCqZj5C/tFQXtwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWL4hHLBIgba6EJXfqBc82Vac+QTKWtgXVYmDn4/CYzwGjgF8051LfbfjGuWR+53M
	 oHc2lPTCvbPPS70LBwkNnEmeX4YNzgq7bs0r22YzFBUuJJhGZMLPXqe17YPdmvwUQn
	 gsRZmBovl5Dl7nHdXWwn4RHTJdVdYilXOGNW+2jFd5GT4qIQtfQF6N2qqPg86gqEMg
	 7tXop52CpsR70fffKJIcnu3BNt/RPZYZd6H5AauDkm1rAl3Rj3h20c/tuZa3rrA8qh
	 4F6a9qPeGa7YL1gBsu7ryBcng7jIzXP49YtG2oiNBro5F0URGeKEMvJDMebvykN0tu
	 xGmJYpReCweQQ==
From: SJ Park <sj@kernel.org>
To: Igor Putko <igorpetindev@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/vaddr: remove redundant RCU lock
Date: Tue, 30 Jun 2026 07:50:39 -0700
Message-ID: <20260630145039.92859-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630102400.reply-damon@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D8C3FA0009
X-Stat-Signature: ghfm8a8m1kt7mzx9x3zwkhym51q1zd3f
X-HE-Tag: 1782831047-86184
X-HE-Meta: U2FsdGVkX19g5mn/ziGF4cn8vfdkVgw7bKE/2zwf2HUUUJj5F26WOhTKCX18EPb6SsxzqnpbUB5rxPzkY5J/RziKszVCwmLS80OWacKwBziiVLYc8Va6PVdwbvU42Iq1J9kPFfM07EwZTj53QUS8lMl7R3K1ItCS7QgsMxT1H6F8UE5FPP1uGbwfAq+6jLCwtmAPMWqNtSl6WNK13ufAle4VfqBj9lKLojlusPyOisAYv7EmE9PODIjaCwryUKvt0m9F+O5+MxPGdEWSvrRKhYcSFxoim2B7RaxizOwmNHI/lLKEQIN/1d3ixDHELpnA/ICVHRn2UDkxlaGxSn1yPdKlUFXv8hMDpKLKAXocu58SYrPavWjQJ7spqIvLsXBx6bLpdjxlOhczDMqPKduNfov7djCAr7oRRzSA2KwiBCAq27JknKj01jBpZam5QvjcjT+ZBPWX/mVEW+E7mM1Jt7NFbzgzXAiltu9GuZNZ9xsDd2z+deMAd2n9vUeVYx4LOo1gHgdifXNR9K02gytLdYjJtrWXwe6bXXVwoYV5X4EQ5jQm7S1MnRgtSHn/Pev1GQXphaAf/3PGbXbtquic01voKb7SBZ7vQHGbIpiRbxY4tGGqV0n9mMJr5Uz4ljJnFN3C2ATolx+E04PHTDUr211OEKLdBlFbrfQyCJAQG84pHI2Wd3jXWQMobnXuZ3kZeqGk9Q5kvYPDMK9Ej8bE5r7nWh7XlibFmewnPWwgpEu++1pkV2rsAANqyN6wyMYM54rkFv4MvUxjYnj14MGyM3xaiLMhgee46Ro2wgCCi3WpUCc9gDrzYYxVlBYkRGeeEcs1hYI4lsvQ66YDMkbnYPe1F3MPfUCybifo0o3AzjxWBVkYbAGSBrxd3iCZaOjP5gmBzoNXFm+EHnIo9dbw9OaYQgb1BefQaBNNun9fJ2QDqjHvQ+J86bWBqMIUtEzrGCeXIWWfy2NMjzy3eqg
 qUuu4p1b
 0tFY3QAU4NaGutdIHdRzUWHsoJReT0gD0RumIpLGm/hA3cfx7TYBujO/tEHSE1kJyKFLqngbhGG7pYL6mO59do5W73Qew4N8ScUmhdjy/iLbUe7bYhop3NMiG7L+4GD2YCs3IGUTm/UN13CD1ZsHgn76vvjJI41wN92thGooYAMSckReFxNSA1fOYXK1pRCfmmCfzY7t/7cUsrAOXFImZv4hx7ZRDO8jspLeL6jc78JPDiKbyPSpqRN7HRG/pIfDpiZ2JWOhYd5rTvP9RM1JVsgS2kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 17:25:22 +0300 Igor Putko <igorpetindev@gmail.com> wrote:

> Hi SJ,
> 
> Thanks for the reply and the pointers!

Thank you for quick reply.  Nonetheless, from the next time, please reply to a
mail you are replying to, without top-posting [1].  Also, please wrap long
lines for reasonable length of columns (say, 80 columns?)

> Regarding the issue Sashiko AI flagged - I dug into damon/vaddr.c, and I think it's a real bug, but it's isolated to __damon_va_three_regions().
> damon_va_walk_page_range() is fine here, since lock_vma_under_rcu() handles stability on its own. __damon_va_three_regions() is the problematic one: right after mmap_read_lock(mm) is taken in the caller, it sets up a VMA_ITERATOR and runs for_each_vma(). But mmap_read_lock doesn't stop the OOM reaper from running concurrently, setting MMF_UNSTABLE, and leaving empty markers in the maple tree. Walking the tree in that state without a check_stable_address_space(mm) call could lead to a NULL pointer dereference.

Thank you for detailed explanation.

> Since this looks like a separate issue, I'll prepare a dedicated fix and send it as its own patch thread, so it doesn't hold up the current cleanup. Let me know if that approach works for you.

Makes sense!

[1] https://subspace.kernel.org/etiquette.html


Thanks,
SJ

[...]

