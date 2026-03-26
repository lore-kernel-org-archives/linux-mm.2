Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C43F4109C047
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 14:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DC26B0089; Thu, 26 Mar 2026 10:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF296B008A; Thu, 26 Mar 2026 10:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17306B008C; Thu, 26 Mar 2026 10:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E12706B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:54:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84EA41603EB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:54:02 +0000 (UTC)
X-FDA: 84588509124.23.0FD8546
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CBD6C140007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:54:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7Q6fhSe;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774536840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuWTe8vWwsmTSTvd4U44lfUvQDHR9P8cpvmFE5Ouoj4=;
	b=4WAqM+c2O5uvY1NKcFeXXzZ2AoDl7lQ9k91NpQOj0FuU5a60b88ZLuKCuOXaC5atRt/B2I
	bbtIEWqca8Sr/j3EknbHibG6+qZoRRmbrEMB7UqKLrStNyD1gtgNOKN53PKZdnAa1ulP2V
	H2qcqiP9toD9i++uwtwOw0/kSMQdyCM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7Q6fhSe;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774536840; a=rsa-sha256;
	cv=none;
	b=D60y6v5tJ8vt/RcPu/zUzVkSq1eTSnkeF2b3rucqbbpGMKxF2uLjvYloqDO1PryFrrDA2g
	GQmoVV+rK4nP8qmZ6Im7Z4lhz5/0J8OaGMuSu3uwaX/xZ1XimAOdrKsta9x/1+mipJTz7w
	tr24uhdQoCaK8/z3eF6OFP+WgGb0Vq4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DFF343B83;
	Thu, 26 Mar 2026 14:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656B2C19424;
	Thu, 26 Mar 2026 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774536839;
	bh=BLR/RJhF/jZELhqDin2ZuSm044v9f2wMVcye1L7PlfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7Q6fhSeG14zhc+CXBstEdP4CNpqQHZqzkK0i4Le3yB6kKm+tha4a1dgM0ckZUuGJ
	 jGr8AgqQQH6BZ15/N8bxNVB75o/l171t7qNjMFKJXFVzCQ1CyVB4t2gWKmq757gpYK
	 eXNZPhZFwFyrERS7KB2mn5abR2FL7EnWEkGYHQJ6NVHWx+jY5u8rgMTsnU8GxRdg3D
	 D7FwODquU+jZ2iq20B+hAtLYrTeezP6A6UTHEmcFdf/TT32BQ3+cW27ucdgb1WlyUi
	 kgZmxR67nCIjPF5qf/0+VX/0spUnKkwUzs1utSfQd3teaGJWlYSHgYcT57xwdlTdTy
	 p/wjkgh01+YWA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH 0/2] mm/damon: fix damon_call()-related leak and deadlock
Date: Thu, 26 Mar 2026 07:53:56 -0700
Message-ID: <20260326145356.92319-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326134209.90377-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBD6C140007
X-Stat-Signature: gqgss3x98rzmw9uu6u6iht6xg5cqj1gg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774536840-638738
X-HE-Meta: U2FsdGVkX18gB+h8uIuD0bImFbZlIyn1jtGNUqUxy4I8j2jZvA5woCGx6KwlmTxbRlhClIijA3oB46ac4/S3V4VYz1IBj0WxJetfvT/QPXsxtIbiPyhNVckhTc77RFNqBAre7gVBA91XXApZKbc5ca1aQA87uh1KpMcfmdNXATf8ZGzDGYYOc/fHq4reUHXszYgY9eW0UuUZ90B9AWvMUqfvGdDwLFMRJcsEDvSirB5+2+9q3THNqkmTGqqshOzSi6z31PHLfXnHKzCFBqQp6X2lZy7j+utDIBU1uz1NTtRT50VvsQKis14TpNHJftj5y0axhk3nlzNfkm79QkjiCMjt97g3MHczmvGHsLDkJr2nAENCcPrZC/UxC8ekz6nHoaf5F2TjzjhXSydmrauhi2si8c26vPGHqBLpzgcPKeKwttwCQtUI7kmbjZopHeA4V+2ILN9o2p0ukUUQL5YOCEdHtePrq0nQE+bLs2ECdbxjkqYqSnBMgBbAbl+FPP7UQ3QnaLZsGJ4DNMtrhD68V3iD7dBuSvnCs9rKwzEHYC3xbCQtB3wjlAhyiTNRA1PRBJkx3vn+hLwi1xay1PBG7UezQqYIB8IbOIXsIcOL2H72UKtT38BBm18SfzhaOTKfLJGIdn4CzKhMb5M1Yx83tiy5VI9rhRK4Eb6hQ5cA0szrRefCcp2Ztt38zkz6s2DIn6152sjZIFDZwlPU3ag3Y7IO3SLzYqV6P3dbco5Qs3lybQ8bYuGKvx/9enyUvRmiJ1VG6bQpwUURprJER8qaq6GHDfhOnQVIsQUY0CO2782Ca88VoGVxVacjYG4/m2pn9fVMQHYPBNO4PxvAp8+mzBJHKHhN8ShFvBy2v1TGV9ut06b06HpkiULOw/V0Z0PU/zUgOdTIM6mjeiOLfUudQi/aWPaNReBn3BTBMNhYmY84OYMvpoSNYxkQGJwmGZWrMZ9Mbqct2KjG3/Z8eTZ
 I9nCCoD7
 vHdql
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 06:42:08 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding sashiko.dev review status for this thread.
> 
> # review url: https://sashiko.dev/#/patchset/20260326062347.88569-1-sj@kernel.org
> 
> - [RFC PATCH 1/2] mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
>   - status: Reviewed
>   - review: No issues found.
> - [RFC PATCH 2/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
>   - status: Reviewed
>   - review: ISSUES MAY FOUND

The patches are hotfixes, and have no reason to be one series.

I will send the first patch as an individual one without RFC, soon.

For the second patch, I will go one more RFC round.


Thanks,
SJ

[...]

