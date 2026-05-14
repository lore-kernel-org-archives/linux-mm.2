Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9037CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F104B6B0088; Thu, 14 May 2026 04:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC18D6B008A; Thu, 14 May 2026 04:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD72D6B008C; Thu, 14 May 2026 04:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0E066B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:33:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DBD7A0543
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:33:38 +0000 (UTC)
X-FDA: 84765361716.23.E9BD8D6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8E9E740006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:33:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=s+I7jphZ;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778747616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3MsbT6y0QkRMCsQwhjQy5RNV8DfFy7/Kf2n33VVPWmc=;
	b=abBeS2bnwp62YgyAoOvqYAsN1nP/tN+SHgR/Y6ShscCMFovVVVcd6eOQ9RUDyyMkQI/3Ag
	MuXpSBTwi6E5+p8FYlVCLhJlzqOF6RAgsYVmn4xPrD9TnKCTPLQOD2cmRLYTSXTrD9p9p5
	4GWX3fpj8BwWHJ1/1fLzcfuVxTCqzIU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=s+I7jphZ;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778747616; a=rsa-sha256;
	cv=none;
	b=rMRTnMD1XgavdoSM8EgSXBYYEEJb9ruQ7kbf6bY4g24ZkhIVx/CaliGb6IKkotYJa3R01L
	OmTuqrqu1Mc5GevSDxhQGAJzP7/4cpMkmd9mCDOFk4NVDVV+8QjhvSWVTvDBjhwWhDzQbY
	Us4etByPZmrp3r8qj4TmeTPCZnslyaA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3MsbT6y0QkRMCsQwhjQy5RNV8DfFy7/Kf2n33VVPWmc=; b=s+I7jphZie5b0/huV3ZBUqsNj+
	XOMpxJ63W3/wS7OhOg68xWq4trwajG2+2SxNAIjlSMn7huVEcUTAuhhGZCwzFzpSyFgVz7kgaGPG1
	DbJ/snCgeCGs4Kzs075GWbojx2Ng2QEUn2909lgPW6A+X1zOl6cmdE/97bqKRCW/sFQWaKV1a5QDi
	F7EfRTScMazQOdLZYxoJq7/ufnSyJ0MMlIcSuEheR52jeMCZJt0ofkSST+mgcrbENH2Rkk8jTE0qN
	yGGBh5KKjDAHDYGpYHEjrTkForFNsa6nItSb29qgRazK/hcjl+lHZ6YTCz9NbP+IHV30DOT3qeKCo
	Ju4YIgpw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNRVM-003oLL-2Y;
	Thu, 14 May 2026 08:33:17 +0000
Date: Thu, 14 May 2026 01:33:11 -0700
From: Breno Leitao <leitao@debian.org>
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
Message-ID: <agWIbTDCoLYmuszC@gmail.com>
References: <20260513094508.50888-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513094508.50888-1-ranxiaokai627@163.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E9E740006
X-Rspam-User: 
X-Stat-Signature: u8ismgdrgfk685wnrhdgzde1qwxs3crz
X-HE-Tag: 1778747616-600576
X-HE-Meta: U2FsdGVkX19RWl8qOLX7u5E2W9JaVFcpLCc8r9lV3NbBchPNLmGF4nI3TCH3NcKAMn44lYLCLmUTt/nkcPKEUlqsmphsCv7vS79hyzhy7lcGuvRZq6Hs4iTr3YklP8F9LjYUO2yoNTTigNOvx91Wlpp/MsUw2ZEiesMJkygVd9BFfZ5lXNEniSduz6PTzvdDrK69tPgTQBOVnIgNQirbKavX1UfE02rOJyvaCiXLmW5UXr0lvo7GLLyX4G23cYb/vDYi0CUv6Z7NbbZR1U+PLZXUJj7QmB5CQ+s8YhrD+XwsLDC37e6vCUaX0Ws7xGJmzhDbijvb6jZtLVeM8oazy/lYMAWB689MZUBJl7i1NZ9SNPQ9Srn8VjcV2D32Cfr2uoevpiKo8p33SBrPuuJE8N5LsUX0kMoaH52o7g/Xv/zhX+uVm+/yV9TulRLoJaozU4VZQ6mLTTbfS6OjQM/x2pj13AdsVztkXvvR1lIHBB7z+RUeik+0Ekqu4Xo3zOjMMPVeh0Tz4dbWQZBfgViQ5h7QjHta11GS8UkJcMBfIkp4kwwtXh3+Z2RYSaBRT6fNfCoQJXg6Il5VS4xyAkqGXGkmxbtUDFot81csQdjcgT3yFmVDq+ReeW7t7ooBWX3ABGSWjA4lBpEILZosrQGr6a5kspVJ4YoQlykoQA2e7e8T/fOpUnhUtwzVl8ALsKUv00SDaNqMw01y7H+cyJ1wUIk9diMMvz8Ogiz5Lb5r/wcOHMq1WlU2yeTky4P2HEhtLn+qqBrpeaDG+Gyu3Ypa718RPIMo9b273qYfhramD/8NDSp5GFi4SMJrZZlScKcuWDGG67PND+4U8vJac4wW6HuLgsJpaD7XkNRIek93QN1zgH5kK05vQysPmrZLqajQXCgm05cp374yLrsyW8LMUFbVskuweg+IPAZrXXUDTbStRg6Sze8yrV3LIeRxSIGJTatUrJnfi+Mz14vniuA
 5NYoqrHm
 7AfqYVtzxp7gAj3hUHrX1EjoSBoJcw/J+hhiwFqzmuve/JTOlXPLcpivZXjTSrWZwlV6NJpCQ/aD4g2zWhRlBBk3pVQwieMg5a7JImdnoKkzHDShQ67VwddNmUoB19lthSU1MM6Juyr5pMZt5lhTDiJeoW8xQG5RXoRtfR6QS+b7h/pGqKHzo2MCcC9XF+46yGJLtFyfaf4yFRtuZ7sXulNscb39+q/l55UsVwF1b7xr/X73TgEVDGUgj6k5v5DDJyMjVdLGjPqecyC8iMaj0YhRVsxa1e3202dIZ7IFK54Fz7Jw6aHNi7xU+xC8ZOQkdw16J5GEiE3UtbHnUHEkl1XgKZ6AISfxIY5WNiUJV6JrkIkM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:45:07AM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> thpsize_shmem_enabled_store() using sysfs_match_string().
> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> calls across all branches, reducing code duplication.
> 
> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> all test cases passed.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Reviewed-by: Breno Leitao <leitao@debian.org>

> +	/* Do not override huge allocation policy with non-PMD sized mTHP */
> +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
> +		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> +		return -EINVAL;

This identation seems a bit broken. You probably want something like:

	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
	    shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
		return -EINVAL;

