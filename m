Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D21F3CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 15:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D276B000A; Tue,  2 Dec 2025 10:18:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45106B000D; Tue,  2 Dec 2025 10:18:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B6B6B000E; Tue,  2 Dec 2025 10:18:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9A386B000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:18:45 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7698A1318AD
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:18:45 +0000 (UTC)
X-FDA: 84174888210.22.89B6101
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B03E0100005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:18:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i+VyfNuO;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764688723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoBD9ElPDJkBGhja81nVU/LM7buDp06FGoP9Bt/EWmo=;
	b=rHl86aIOK8L0SA5EhrgpJeqIRl6ChpqW/4jwX0vWWUujz8wLDoLO4tj0O5B5mFNM+KVSYG
	SPEY3nh8bsfPvALKzY/d4rCcH8M2ega2NdSk2mIWpCeZX2XVp6lgJJo3gagrLkBcAa0mZa
	HCajsoZ3AUk5/Cokt1Hq3eLnKk2XCMs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i+VyfNuO;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764688723; a=rsa-sha256;
	cv=none;
	b=rsanntywS+M9b8opOAhO4tEnTh6Kv66ZaYHP0zgwcvWJp+9rkdJI6qpGWQU0dy9f9aAAiK
	xyvQ0aKRmxVdlekSnVmvhdXGJjGsiTbNcBF+e+EFBJnGWSF0QbOtkptSN5aA45P8I8T9+9
	YY+OaMR1lYDp6/7Lh0LshLdLjw3x0zU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B932401B4;
	Tue,  2 Dec 2025 15:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2D2C4CEF1;
	Tue,  2 Dec 2025 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764688722;
	bh=qbmJH+Y6AaiUoxrlO1VOQ4qf+8ySubPcHBqOgEH9sTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+VyfNuOQXhNnh9z9Eq1KT87Xznzivxq1E2aHhiICcVoSWu3zLION/YJzd4r7BLcQ
	 v2R0+slolfoPx7rReLYlx+1KwOBwGMlOmc3c8ESbgPlGe59ONOSEwOeCsrfMrIMeIS
	 C33wpNLL89bbkNBdjV5iJgV97siqAw1Pr0+/NPPvZ9JKvEajliQS/CaBWf8vbi+gJY
	 N/MR1Cbs1BHLcaFL0g3tdA9R5NpZcqRn2AuQdVBUEPUnqDvWoS2PhhL7TGAq5sKQ/h
	 5TcI2U4g62SyBKY6IKd5JwZ+G4ZiGjpYdWOiOlzgQ+NMWIciOF4OUavGm52D3IfYko
	 j1Jd7etsLnA0Q==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: fix memory leak of repeat mode damon_call_control objects
Date: Tue,  2 Dec 2025 07:18:34 -0800
Message-ID: <20251202151834.68713-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202082340.34178-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e8ekw6yzjnzcr7s855xgrjuubkhbbaac
X-Rspam-User: 
X-Rspamd-Queue-Id: B03E0100005
X-Rspamd-Server: rspam09
X-HE-Tag: 1764688723-62562
X-HE-Meta: U2FsdGVkX1+yodfjI9NGOjZENChHRyPi6ck8Ppmt8ZLrpIyQQmSeoLxJLs8OT9/wX6liswNhfHBF47cCzhWrXggtdskN2PaafX2fUPI3KuKT2pCO1w1uYmHAbWFytAKcYaWEDpwYpmvBMTCIzRQBHYHP4YtBkfA4sVj6h8vvBo+HGIpQacuG5ac4q6zmNegJDwzs4/uvGd1uaS3uajpxgi3Lovwsi/PdUJX3HjQxVQ4uZYPbWTiaqPx2SrInCo+5A60pjznoW+ZG/jL2rRzQZS2lQKXGufNayNejLi0bj9+5P3rIqFwQ5VlLTNbmxkZ6DbVw0/2tJpuNeMRLFS50nu/6jYC8qWReSs3XfM9C7BZ4lDfb4DGomp6+tb6tPunRHGg3jXVCQYsF700NOiZpEq7Xtt7Ei2SLvmWpZ501N4sMghmAuNtW03cZNs0ZB1hCC76lfpjglD6qc3AVa/aN8MqRzJhbYI5im99UFeJFub2GKxiYd5Xs+ebwh7P0GpOU0qEt5ZU0GFg+MPC7bYg7E8OY1zU5xbfIb5W5z3iZor7Zf6mXaNGj9a2WYKsZELbw7Y6a4eVrYM7GOt48WgG1w0cXXlpDMwMHbPocBgedEwBtKt8l+zmpfpv1MNOetOGRhk5pcX8IfcWPQqHur+rd05f0do6efwBAnPArlFIxD3OMicj8NGpM0lhEmgNeFtCGD11WJETdZ0YvzRxPnZo15Q5Pdt7z6n4c45H7sPGF2v1zS7LsVrtVzjfjR2wZNnHuynQIvx2uK2vIXbnzgm6Pyohmaod/UOYysto6qvwwlBY5kUpDUsd3riv6w2XT2Qn5gV4lxDvm5VDT/Uv77a38w8G8qWSgkRprEhvT+gXDjzuON3EQhb0WcNGedFbs7G9kWCCdacXM+/g+vNXm3DxLCglEgzQWYys0f9mlEZdj0Gopr30e5brRirDBhn/CzycN1gB8WsrETVHYMzJwdPM
 O7ME21wd
 u31w69cWFx8Rpt5ThqVO1RNuKNzWFgZngltzZkLdP/8TZtAaFoqNLzTmRlOblhBxCFSFqBV7dbnqGa2JtBLWq0qa43IEf7XL4dbG11ilf9dbLeAVG0OK/vnEBfSt/c7Wwj4XTbFd1ebc520PK37VCaJBNvX/KqJ0nWW07timrmZRp2oWJwikncpxYVO4SatGwwvsbRgRguthgfCUFEVZ/zMQD4gGT3f1VAkOHESfWv7/eG1IvdOTaALxhRpi26XlK4u/v8hjPN6m2YGrf1uIY6j35ZDYXxpTJ9SKBZFjdgIkgzAd1yZT9uGjEDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Dec 2025 16:23:40 +0800 Enze Li <lienze@kylinos.cn> wrote:

> A memory leak exists in the handling of repeat mode damon_call_control
> objects by kdamond_call().  While damon_call() correctly allows multiple
> repeat mode objects (with ->repeat set to true) to be added to the
> per-context list, kdamond_call() incorrectly processes them.
> 
> The function moves all repeat mode objects from the context's list to a
> temporary list (repeat_controls).  However, it only moves the first
> object back to the context's list for future calls, leaving the
> remaining objects on the temporary list where they are abandoned and
> leaked.

Thank you for quickly updating the description and sending this, Enze.  I think
it is also worthy to add the real user impact description.

Andrew, could you please add the below user impact description to the commit
message when you add this to the mm tree?

'''
Note that the leak is not in the real world, and therefore no user is impacted.
It is only potential for imagineray damon_call() use cases that not exist in
the tree for now.  In more detail, the leak happens only when the multiple
repeat mode objects are assumed to be deallocated by kdamond_call()
(damon_call_control->dealloc_on_cancel is set).  There is no such damon_call()
use cases at the moment.
'''

> 
> This patch fixes the leak by ensuring all repeat mode objects are
> properly re-added to the context's list.
> 
> Fixes: 43df7676e550 ("mm/damon/core: introduce repeat mode damon_call()")
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> Cc: <stable@vger.kernel.org> # 6.17.x

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

