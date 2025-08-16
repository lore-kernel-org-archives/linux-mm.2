Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B082CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 16:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1D766B00E1; Sat, 16 Aug 2025 12:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5526B00E2; Sat, 16 Aug 2025 12:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A320F6B00E3; Sat, 16 Aug 2025 12:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8E14E6B00E1
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:08:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A11758F62
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:08:51 +0000 (UTC)
X-FDA: 83783104062.10.F5D749A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7917BC0005
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:08:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vGCzhrsU;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755360529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SO/U7U0AwmbCV/1zT73zuTImZ18RmvNwc0TIXVycBjM=;
	b=bJSfVz9m4aZ2wcRz/20p3jFl+ndtuw1VjeUBsHCYGdXzirkq3SBpW8jz6PEKvS8deaVw13
	ch4JjdKX9srPFHUmXoThllwoLU8tEVfj+qbZw4SlJJH44OvvT+Wg6CjaFdahKcxsmvyCtH
	oOULY3qZXEzhKMtvAQIfEG05mbuvHuQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vGCzhrsU;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755360529; a=rsa-sha256;
	cv=none;
	b=vAKckMdF9Y/lxJmkbmOn5oN5uUsoPLG8tmkssWbaB01a1xbQVcB7U4MBaVVb2i5SVQQEsO
	V3UJZj+CROBRAZKIibLlGF7Te22co8KCtn1RqlG+32PEJFD3LaEN7qyu0DDWUP6kDVt+C3
	RRaJgYBM3tf0xCWalJEVuU1ceycHFoY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7774D6140B;
	Sat, 16 Aug 2025 16:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB06C4CEEF;
	Sat, 16 Aug 2025 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755360527;
	bh=p6ysJ3B9QPz1TZGVAPiJzt8niKULf9on/9PRLjBIiD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGCzhrsUyBntZYjf1IBSt9I/9mCUpvDKzOydkPEW/sB1Vq2Go29F1JUkfs+aKJpo6
	 C7JUXhzN02Wk/dkPiZmNx9E2We74CNokxfTvhj8b9ZtY9fW5m+Umz5khTdS3kTAG67
	 WrOsA+kqHsHeRt4/WRF93tcfQ+mwWitwx8ZILFIGd4Oo3fS70cEgN4EvqaREgWofww
	 O8PGxxBB3HSQkyel+s9oNZEYFJm9+TZm9NN+MX6G4Cv4JrGyVlBQ73Kobps0wWjFDW
	 GWYrtZ33aqJVgKutXK7NGvx0F15wUds3HIMcIOMRqUcIhPiyzUd+pkkEt++pPXRAVa
	 It6fWlWlDQQ0Q==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 mm-unstable] selftests/damon: change wrong json.dump usage to json.dumps
Date: Sat, 16 Aug 2025 09:08:45 -0700
Message-Id: <20250816160845.63600-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250816014033.190451-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: irkkcgw3zzgnj5mtjfc7jhoc6zui1y48
X-Rspam-User: 
X-Rspamd-Queue-Id: 7917BC0005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755360529-507749
X-HE-Meta: U2FsdGVkX1/vTyHfzNfKm4BzMRLqSaNlYEpabHPgpdOfMvI2ie/DLdTTBsOPcl6oZmsVYMJ6UbMq0OamZJrU7G1reVXmhtucLb6QmZw6MsN26Ow9KOfIPOAwXWqwPsDNf9K2NEZ2/ps1wpUI7BDSWq/wsf7UPrmUqwB8M0VL44QHIAQK150JyL6HpvxvIeFNXrsxvqc4nlgN3dWmiFnvCDU5C0rJWTpjjmC4TknbzICZ9bIkOyndU0mL70HiB+jTCeiVPKWJNoFxymRlMqioBzUApGo9ja1kfVQhiPglW6kdIJMwF6i0uD7rIeCIyrvooqyqJns8z7+qDNoGykJldlMuEXlRmeeWSZfd92DzSvqpN9nXGvC8gk1iveZ+rR6sjTrJ0TATm7k870T/EdfiTvCQLwNZ6DoVbZx7eIrNFxmBi11V3vsp6ZI2NbCm8FBDhwlr7Dl6GhB2QArEyhG9tCG4NnHeAw+VM/rXntnvykryb9UnNQsC7qheRZL55b6v5nXXBADK+N1RhDwK6kM4/QHsOBVyWF66kcge0jlT/IG8Ibk9Fy6FzjT0kBNvIXwI/XbE20ou//n9+KWJBD7L/I8hkrDMV1PLhCKzlqJyJWSfDpYbSIuyMkPeRTe8HcL08nbsIYyJ0awwvK7BDk0RvZQ637stwUmHf4+hjzQEOr2Zk/poz2oZR/qS8Kvo74/bj9omScz0zcENCLfS5GSWNUFJGZ4UWP2iklInQs4eaI1EkUo+d0Qs86nChAD3kgnulqTwkEyHbCu0W4FQMwieWW2b7NAr8W3cXy9VqtS2i+7nn0s8rZfGSaHO6r4WDuDvLiH1QY2Naru97osaclH6Tn/wqHo1XyPt3LgkKt7ZbOGNyBpawGLZ0D/DPRy7QU2c80Vzej0d6JX5GO2G5bPk8JU9Y9OALYYlODl4cmLxP/5mxfh+2YimCHPGzgR/6U45LKEYlJK1G+NlY9cinPj
 AwHrgmwt
 cV3fVzfGzQG17MDUiCIrVbfVY20dGcWYrfwwGR5vmwYEjQi89FfHfV5f7xf7s+LsVJqYZbyb4lybqEjS4M5QRTtXF4Xr5nzBKyUapvgLyvJVQJ0b9Wx4O+Mpdvu+f0bmElEWr2BDH31AnTDYLcA008kOFB33O8gTyBv/ms/fwdrSP6UBtYoilGuHFCczwe2jZABN7f7yEiJlpbawVXbBCwnwM3jlfBOrSU0Bf+KgIXVTcxN4V3gza7fMFjpYNEdEYmNsS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Sat, 16 Aug 2025 10:40:33 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> To print drgn status to stdout json.dumps should be used without
> json.dump. Change incorrect function call by typo.
> 
> Fixes: 441f487d6ebf ("selftests/damon: test no-op commit broke DAMON status") # mm-unstable
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> Changes from v1 [1]:
> - Change patch subject with DAMON convention 
> - Add branch hint to fixes section
> 
> [1] https://lore.kernel.org/damon/20250815094029.133063-1-ekffu200098@gmail.com/

Thanks,
SJ

[...]

