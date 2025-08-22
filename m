Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90B9CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0226B8006; Fri, 22 Aug 2025 14:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D5A8E009D; Fri, 22 Aug 2025 14:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D348E6B8006; Fri, 22 Aug 2025 14:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C11538E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:09:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A0E11402A8
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:09:13 +0000 (UTC)
X-FDA: 83805180186.24.4C108B8
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf19.hostedemail.com (Postfix) with ESMTP id CBAC41A0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:09:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M84mlTVS;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755886151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1KSE5/hthgUjaQP3h/G0rVQEi//acmava80x9CEG+4=;
	b=0jhy2FMvcDkoJxr7HmG+yNPZrX4H82UTyd+SUKZipMRRBCaHOLC5W0Du1JkFw1Av4u4x31
	8dOwCGLTJe16omAGQtBx32qX2QAAO2oHBHwbxjU1u4oMTdX7pmFM0jRaqJ9WXXxXI3ECdO
	Rnkd8QhyKUGoUDWTknycZXwe/JDSZvg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M84mlTVS;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755886151; a=rsa-sha256;
	cv=none;
	b=SEkAbSDIEKxNwd4fgABjjmAi5QN0IVV8e3d9yGDObHZy0SjDhSNYjW9hIdowBJqzJBzfk3
	ZU5DAOh3bzntg92+19TUi/ivS070SoCexrDe9CJ1qPBj94Imj2Q96pkH67Tzq77twJ3jp8
	DQjRcivD+BNsNUdWo4EYcMKGUWdDcUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id EB1655C0E07;
	Fri, 22 Aug 2025 18:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BD6C4CEED;
	Fri, 22 Aug 2025 18:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755886150;
	bh=/KBehcOkQXHDLRfsTeU4RhnSx3MBciIavYS4DUgCdFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M84mlTVSHJL9PpRAPTCrEoz6cimQc+Q8j8Xt8tOAEJcw24XKTwe7/h129KFpxNdrL
	 n6iAK7sMGMQ0QidfaTEK7Ek33iO5kBEEBNuXfdoaBG8CceMQ46KQhX6KqjUsnge+pj
	 WOSH88zo7WFoC1ZC0vlyNmjcBYJg2lP1iB6Ph3ELzhkOM1cSrHDBYB4vl6VERlrSEx
	 Zli4Mn4QTVj5Ge0VwqvnYH8ml/qbUKFFLyrxdLt5VkawwGQ6wHA7f8anbc8oBwVFWm
	 sEYkqGac+PG+NLhkVr0rwiyiW19GPCWy2hCLgkpf06hyz6emgjZa1dOcYyB205yxic
	 e1hCkf5hhveMQ==
From: SeongJae Park <sj@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove is_migrate_highatomic()
Date: Fri, 22 Aug 2025 11:09:06 -0700
Message-Id: <20250822180906.48005-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821-is-migrate-highatomic-v1-1-ddb6e5d7c566@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zq6xqd4dhbthmensp6y9q4sgswor967t
X-Rspam-User: 
X-Rspamd-Queue-Id: CBAC41A0004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755886151-340374
X-HE-Meta: U2FsdGVkX19rtdgLOeaFU+bQQF1lWVyFuCrgQLlE2AvxmKPqAC6u9tRm05Q6z7U3V9wpoBzDP6KFvELnzsyf36H2cci7f8tAEmxCEfwNzbU3s58ddNB7omo/8p7oKKBvLRFvbEaleJomjrlsjvqafZLliLIXV+OoLpOH3ZMU9YiBU1tj8oS39/LZHKAD7EXc8h633cL07XSSUSRwBNwxGIGXPXb4idPqWelLMnDbSxsDgvihLa6bz9vRTw+uhv3oRbN+DhQ1gUanJ6Be7wIIq5hDZLoHv4xjBqKvRcQYdcJQsfIbPuiI+2CkvEHXbFy4zMZOYUmWDmAMkgvlEeGhcX53th1kmKCa4T+8A4kjtTuoFGOWCD10i6Oy2J0R68Z+afI37Tz/FnIAk9DgAE7MRPYixe0ikU0ll7AfHYT7/oO/BgbM4uHUaPCK7/QhhvU9Zw0f5cKROh3Q2oU3wNRfo1vvBSfce0Dzd3M1lzeJp16nbj9PtwuJ1E7eCYq/IQpdgLJZZu1s68FJBI+7Bv+JnKE+xPTQGKYe7TlWWgaQtrQgr1nPhfiN/cZvSEjpOzv8nWxVT5FH6HyOA1xvtmzBWh4DYbb5fa/IKSTfNyOnUSR+2ScV/NrzaqoUjb4AffGQ4Os4kjXgcXFSpD+zxMRhgZOcxf+E8wBedCzo4HqAv5IV0P9c9EJJ1ZamTj1Xxb539s7c5g/IMLcS8LxofATmZ+Cl/fMnarwKPDpbHDg9ljOW01N+gURg8aNOlojZhsw4PZsY2ANypXx1JP/rDVMJXk22oQqXkPq4kyalx5G4HBqNvFAfyBeUR5IL0SVJ+GEuMl6IRUWWwb9zvQWZlK1gUjo9YIYJWtzMlOaXeC029N8YxktJLPyhE5tXgkKFsYuJbkWxCLei8vKTv9sp+MJeOaH/hcg3ufLmZQEDG1W0gO3GSmZT3ZZhrJeHfddGevoQ1Vz+CbOcfZppDhrs6kD
 wsG1YVoI
 zWilqaTtUss381lM/wgWJntTP02Q5HW9tbBFzA8oW+u5R6trtE1U6vaE1HTXFRTiq2DIgYKcMQiKIPJKBdsaowY954PiRqHhNrIZg+F52T4RJ9385LVjjHF1IdJPmO100heN8gWmgIss3AT4YrFuese+QBHMx+wYqDcmR4xXK/LorHK9O3MTlzklqF5Tga+uOlESL+096rFSA5gNAd9BHyrBV5FPeEF9ruXqxM4gpbkQFYbXqGcl+JzkzOkZZdDGg41VzJIWi6JG3qZO6U13xdRkWha3f7aBGLOCNELAsv4GOlKT+3441GX5ljg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 13:29:47 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> There are 3 potential reasons for is_migrate_*() helpers:
> 
> 1. They represent higher-level attributes of migratetypes, like
>    is_migrate_movable()
> 
> 2. They are ifdef'd, like is_migrate_isolate().
> 
> 3. For consistency with an is_migrate_*_page() helper, also like
>    is_migrate_isolate().
> 
> It looks like is_migrate_highatomic() was for case 3, but that was
> removed in commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
> accounting").
> 
> So remove the indirection and go back to a simple comparison.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

