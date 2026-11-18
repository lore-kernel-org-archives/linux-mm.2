Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F06860A2601
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kog+7qaZ
Received: by kanga.kvack.org (Postfix)
	id 994F06B05B2; Wed, 18 Nov 2026 09:28:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91EA06B05B3; Wed, 18 Nov 2026 09:28:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810826B05BD; Wed, 18 Nov 2026 09:28:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 634DE6B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:28:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4F3BA0797
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:28:39 +0000 (UTC)
X-FDA: 85448470758.04.C2CD8C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F7EDC0008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:28:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kog+7qaZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUT52vgyJgPuz0uybFsuYJgMVSReQWxsEW446+mnG/c=;
	b=CV9FuGxrhelSjC1qHKsmtMreOeunDT897Zu+6PLhTRazx+tINM3IwjEqu8XcPLH0ubayQ1
	cF8xuT5Z4A9xcXrjvDx0BDZvzwbNqp93OLEcV35OgebrMZDX7tQyXjHzeFsCwJlq7fe2XT
	JBxAo6OIhaqFCHFht13x4UHSAC57QcY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kog+7qaZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012118;
	b=lvJdNdcycjcUtGnQMavKcwlpWjWmNwxxN9G47INguMucogcKlk4bOm8i5zMObwme1jSizV
	yiSDwMsN2siVTpM6EbezTf0Is5ynW4/v6W8WLAQAy7Y+qZH9rqr7tdjI/d1xa6Lv9tvGaN
	p3bF46E4CgTVUu32q/PnFMsgXhXXT7Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F01341289;
	Wed, 18 Nov 2026 14:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1881F000C5;
	Wed, 18 Nov 2026 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012117;
	bh=GUT52vgyJgPuz0uybFsuYJgMVSReQWxsEW446+mnG/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kog+7qaZykWYE2vmZ/oH75pfch5xTnHflU8PorPT1BHhJGz7cxBdAf4dIILq/VQgq
	 Hit16GWSGZjpiJxNbNDcRNaXe0uZj7X9F/UwdTcUXH0+V3En5Hk21w5dxkSXxAnwvL
	 rwrk+GinlXzbEaFMRyUodCXQCnPz1OGSvdemf2P/q6uiJfNYmb27xjRhzUrv7H6W+g
	 OXVohld2oiuFRgPx5r6mO7wm3Tt3oSomxX0dZymKO6RvQMXWyEIQIACJu1eZP7zk2u
	 uI0yMdf0idyVkZagkDkHqKqAF/Gw5yq3jlnLeGMf7NgZM2FK6kQnsw4rSrpO3hFEaZ
	 fo71rGJpydlIA==
From: SJ Park <sj@kernel.org>
To: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/tests/core-kunit: add test for damon_call()
Date: Wed, 18 Nov 2026 06:28:29 -0800
Message-ID: <20261118142830.90113-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118063755.37749-1-saileshnandanavanam@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4F7EDC0008
X-Stat-Signature: y6nni8b3fsi67m3je8kkq84pyphfeutn
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795012118-495049
X-HE-Meta: U2FsdGVkX18corHND4qIi3LaIOAGYiRXXsgUZX0ut4SKs7IQLmrG7BK2NdSb+y76k0JSnq7uwtCm0PyTbdZOc+BDRSFjG5k5nH/W1pHYnD1PVi3u4Mv0TgcIH4443MyELN6gywk6hfuzZk8d8Q/RJTERVH1C9c0Dn7HOyWmyMRVgDam4DCPVeDY3jZeNTSwp2upE1whWTmgJnuYCWFNJiP+yuKjqPiAk99f7zO4YPf5lKgWuUq810UJc4UZwwvRP6mkbuP6Ed8dbQV6n84LpZAIxGuAMJFub61i8y7JA1WIqoDCBN8+1zrnG8kv7j8XdPNCSt+CS4ahMMWibx7Lkp7TWm5mMOr679EH5Y+J6WFZ97o7Gu2bb3jcVvBDVQHq4j5YoYCBPPRX1gNrQrnSMTeQUEwFv/qaNYM04WsrT47GNUjTyl9UBK9xg+zFi0eLSqQ9Mb4V3f2TmEZe8cjZFh9OrEb2Ey7jor77XilKSsADb1jGdJaixuGu6gn5QcxCz+85xW3Ilr326YrH/poko7xVgxSC5br3B61ZLzA17anaTilm9495mP7Xa9vtWPJKXlREPg7p+bhse236O1LizoDNZBLd6aQ6DOZHSdWp7mWzRQqK+55KyOksx/jcE1m+Ihp87a2mQzZkgcUtJuHZfA7YR3uh39ZrMDb/cd8rY8OLMwKn1WPmjT13TJKUhoZCYfhIJ0zf2nXwMS/mnSvn8/brcqzIjx07G+onVt9XNbABrO4VYsXkKyNu9Wif93c4mhGBVDlktNKPHq/0DL41pYTZ6Jw0QVOBgahr/9+UAA8+MIEjQQJcvJnXjXQJI7QA4XQ673GujcX9i+o5HNhfK7zj2t4unIjsVA/uPpV6I5CTpW+s1bHfYfZqwlyICoi2+4MUIumvN0RSV+avUy722iyRjdjtR7TMgCBi4lk8tGYaT5yJbeSf6ItvspOxUKM8CVSRnAkEOEklU+x2whiv
 tVmJYgDd
 wBRoRwfHEH8YFGX3kxXp5d8CtuWuBWrbjM7/rxylUI2xGWSZsIR3LxVkQZvzDNKTOYGUnzTT7yPrW22JPX0jtxW+UF3eZ7un22J+GROz69mSRYyPH3p8N6jgM8YcdDSGpx/pBy2Y0uVHwwmY4ERDPNvTZV3qg1gMnJoMkzASqKmCma0Fzvf8UNfSydi+XYLiGsUTiEuGiCO0s9bhE3AFsLo6BPQ2fN8awH019WKcxlrKCma3mNm0pzeB+DUBr49mwXGeCYnrortk8JMwEoncFMjOzJ3vbQJx7iITzFaOEHFwCMwcZOUdW5l5c/oi6oL2Vn1v+z78ZzI1l49Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Sailesh,

On Wed, 18 Nov 2026 12:07:55 +0530 Sailesh Nandanavanam <saileshnandanavanam@gmail.com> wrote:

> A newly allocated damon_ctx has call_controls_obsolete set, meaning no
> kdamond is available to handle call requests.  damon_call() should
> return -ECANCELED in that case instead of queueing the request and
> waiting forever.  When call_controls_obsolete is unset and
> damon_call_control->repeat is set, damon_call() should return 0
> without waiting for kdamond.  Add a kunit test for the two cases.
> 
> Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
> ---
> Changes from v1
> (https://lore.kernel.org/20261117172219.26725-1-saileshnandanavanam@gmail.com,
>  https://lore.kernel.org/20261117174834.29182-1-saileshnandanavanam@gmail.com)
> - Merge the two tests into damon_test_call().
> - Drop the list_empty()/call_controls.next expectations.
> - Drop list_del() on the stack-allocated control.
> - Post as a single patch.

From the next time, please ensure all discussions on the previous version is
done.  You could do so by giving more time before posting a new version, since
the last message to the previous version thread is added.

[...]
> base-commit: 20eef29b7c8465ac98d7dd6d6f2ac07a8d8056ca

Seems this is the mainline.  Please use mm-new [1] as the baseline of DAMON
patches from the next time.

Other than those,

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

