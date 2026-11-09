Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C15C6082BF0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 00:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YBaCPAGo
Received: by kanga.kvack.org (Postfix)
	id F123B6B05B1; Sun,  8 Nov 2026 19:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9F56B05B2; Sun,  8 Nov 2026 19:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF746B05B3; Sun,  8 Nov 2026 19:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD9A86B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:34:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93AF9A02FE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:34:50 +0000 (UTC)
X-FDA: 85413710340.08.360896F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E6D75120004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:34:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBaCPAGo;
	spf=pass (imf29.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794184489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMr/7dznR2e6AQLXjKgj8idxsvTRjg4+NbujeiI4b24=;
	b=jt4kNHsAWWldkfG5a40dvTqB0DcNtJUbDnB6SDG0+c/ejDgBdqTN9cddPTT/ZfffKagqmk
	i3y6BAaYoOyHaQQ2yAq3C+lp/9buiGkuPJqNrgf1Gz12TqS9GiYuy/zzItkpHEnJAXd6gA
	ugDXJvJMvmI6zNZZllxGsPgFU0sV8Uk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794184489;
	b=WlIQgcLRHcr1fl3E2gp6hOlaGAFz8tAGPHkvY0Vl5DfC170V2uKAEKFovv4jvxuj6ItFf+
	80/ui5uTWPeQCXVpajAR4WiWHPjhbMYSOmB6obn4g+D0JKPky6JGsCWnAbjXK0tQmIPd8o
	2CY8KHydOpLrUMWNESwktdUbQvMof4Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBaCPAGo;
	spf=pass (imf29.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD77242B62;
	Mon,  9 Nov 2026 00:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EF91F00A0A;
	Mon,  9 Nov 2026 00:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794184487;
	bh=xMr/7dznR2e6AQLXjKgj8idxsvTRjg4+NbujeiI4b24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBaCPAGo//NQOEpuqqqFHTSL4k7DihQA5fwABbTUg8mFsVngdSrCan4WHR3xrEGEw
	 thlrO3NU7jRWtIN2LXsyjoQznSo/5VWlk/QPbjjysMh+HGK0adHrYTsABENuzQNRu5
	 mAY1efcTJP5JcMpHB/+llojF6+prBkRXA/y1j7Z5BX2PXbvdiIEhCAbQlkKLEfpsn3
	 T/e37NjmtEW6RYztD2b0rM5yPY7UVjxACQu5Ds5s92FGtaUBQawCqKIsiP9d0lRWIX
	 +678HN/d2pE0mc4ZhOhTpSyqYoLFpDHhBtEceZLvjpE+9YsG+tINoPbcv1D3U561Yo
	 04ru7jwHv4nhw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	david@kernel.org,
	yangge <yangge1116@126.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Bundschuh <mkbund@amazon.com>
Subject: Re: [PATCH v2 6.12 1/2] mm: replace free hugepage folios after migration
Date: Sun,  8 Nov 2026 19:34:33 -0500
Message-ID: <2026-11-08-1-daily-reply-0005-hugetlb-6-12-v3@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106220835.2878368-2-mkbund@amazon.com>
References: <20261106220835.2878368-2-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: mkpu1umwj8inz7t9gsmcruk33zudx8gj
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E6D75120004
X-Rspam-User: 
X-HE-Tag: 1794184488-80033
X-HE-Meta: U2FsdGVkX1+yjY6cUbq1WVSCTHDdbfaQyBx5xQQ6+m50RzajRRPPsAjRM6WfIVUNYG5QOx/pxBWxiIMuMg+ZoIf02BEJTJvB1dMFWKh67G7VcfETu+pRxPVcxqs/+nvLSkqeVQng3mh5J5WExf7gX9nCfQH9L6mLe+zr5DyCe6DcMVhZKH+Ju64zeuswzcP8F/hatLTPajxKTlT/ArZhaHGr/weD5EAo5ogqq3V0fxrfwmbI7zwGFiQNjX32p5SV68gghmyny+M/xcrs15PVnGLkVPsPSaWWP50xc2ef4pqMEcShwZbCQE7UIjlPs9hw27zsz3F+Zy5IJcBScNIPUMlqDsdDx5txy2ctUS++XvdF4KSGH9jJSOY1zkpovBfiFSsQe4EcLpYJaTkA2Sy2FIV/V+6POoKsIQvrnn+pUrLTGdwSpcqHtYDflRR2X4Qhqhita8ssngKfJ5I/Lic5R3NoqzvbLiwQE7JSb5cuxHpUqefmyzkvVJ/M0aCV6cj/H1Z+8ymbpTtRgqLuW1/ucGko/bhIycpbRARVxU8OC/2St8fX84urvTUGu8rX6KS1Cb+XJqgmyFZI9ya7SY7GmJQ2sfcDoO7h+W99SB/pVuZvgI7uEs6drVG0miIURV4/A/NCCVPoAQu5xf5CM0DLp2VIk85gzV2fEheu+DZu8Rpqrd0LZzbWBxTvTn9omShlIJJakbVfczc4rHam4Sw3N3kJIGdrKaMf5aPkfdrJtDgTB0m49GF4OFyr3HzheKB8CELMj1zfhKOCVryxKjWKfdhX30zEswz4J6wqEo9puKiTGP6+SiFDLANnnToVlCXueC1E2JEhMwGDH34iAj+O6Iw2N/R/jTN/wLZAoLMD4HpPPqbOAaovXq0GCqs10VwwLPROcNib5yhGpnaTZoZvXaFdVxAOCtgFhOJRqOL2OB98R4IYeLfaHM9VJLb8BmzK3cyMSX6prIS+lvNrt35
 bK4jHqAR
 uci3uda8PQrj5/OhhKc+6Hm5c3zi65SaY/PexbqlrbJ9hvaVcGApfNSWFgfTzR7+zpyejs8zfNFs2rLHv3c5qImPZ7OON/7ZyNGfeNEEu0sBUS20ovJRVK+iUhGnYdgzI4A6H/RfrTEL2GU5/IkC0NIFAlfzDM6iMsL2IfLDmbhcKR9VEarHmMzWxyG/k9RujAhTqZG2fDMko5CB0rR0qMyW0YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [ Upstream commit 04f13d241b8b146b23038bffd907cb8278391d07 ]

This doesn't apply to the current 6.12 queue: 30cef82bc6e8 ("mm/hugetlb: rename
avoid_reserve to cow_from_owner") is queued for 6.12 and the
include/linux/hugetlb.h and mm/hugetlb.c context in this patch no longer
matches.

Could you rebase the 6.12 series on the current queue and send a v3? The 6.6,
6.1 and 5.15 series have to wait until 6.12 is covered.

-- 
Thanks,
Sasha

