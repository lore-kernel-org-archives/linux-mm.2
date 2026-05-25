Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5D9CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 20:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9618C6B008A; Mon, 25 May 2026 16:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911DE6B008C; Mon, 25 May 2026 16:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827BA6B0093; Mon, 25 May 2026 16:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF466B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:02:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27B4B1401D3
	for <linux-mm@kvack.org>; Mon, 25 May 2026 20:02:04 +0000 (UTC)
X-FDA: 84807013368.25.4DD2ECD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6B7DE20013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 20:02:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uXq8BWDy;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779739322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6/YknKdEA4x8G6R+IgJTIdlwuQ8G6+RHz4gavhL8N8=;
	b=quUkFlGoUGZMRANGk4mRFjDnT7KypG9z5AEMMDei8A2cqkrOtE/pvP7CJBk8y67ibO4Nc4
	Gudo4cI1FBGC/eCgwU186iXx14edoY2Uu0fSl4q7WRxecJ/anEzRpYQ4ZQbUj28Vw4/akV
	RuN4ZmsTuhlRdb8pJyXcd/z3XBSIgQc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uXq8BWDy;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779739322; a=rsa-sha256;
	cv=none;
	b=Rj5qx24r+8H5T7DIktyEC887b5JZdocdQ26j9OxNVN954hQUFtHWRwcMigj2JSDIi77dYK
	2ZSCzOmtQGnLB22QNvjsu4HhCnoCmYgY/qfYjBGRtEo2Cl/qpd9cH4tWauLy7e3fjB7BQO
	Vgiq9ndItmbMrFFnSnwrKx+viQSzIV4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7300243742;
	Mon, 25 May 2026 20:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED19F1F00A3A;
	Mon, 25 May 2026 20:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779739321;
	bh=V6/YknKdEA4x8G6R+IgJTIdlwuQ8G6+RHz4gavhL8N8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uXq8BWDyNGvkOFFNnaYQbloQHEWzuG3IdaOULAj70Gb1uUARS1DOl1yeXusze+6Ir
	 tnDmAOo7SrmrYQOZXJ7ny11Wnk5kf1wzP29s3okD3OuxDV35168eM1H3Kw2F+eecnB
	 DbiK3inWCrfp3ZxkXfZpLR7Dp7wHYZkrHpShvocg=
Date: Mon, 25 May 2026 13:02:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] selftests/mm: refactor pkey helpers and fix mmap
 error handling
Message-Id: <20260525130200.fa26a0456979d8f1045dc930@linux-foundation.org>
In-Reply-To: <20260525073026.27594-1-lihongfu@kylinos.cn>
References: <20260525073026.27594-1-lihongfu@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6B7DE20013
X-Stat-Signature: ygqr8kguxiy8qjrxdnxb9kmpn7k4tauu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779739322-541276
X-HE-Meta: U2FsdGVkX19YOrclGbnNd8UMiwSUmlH/DwzALxtGLdbyngkzEcwLpOpOFxNkqdXNnTwDj4jdobzBgjDyjzeGx6E62nEeU74P41tnuKNCUc4gXKy9OXiUcMytfXzhekBmNDXvkUco1CvX2yd7DMkLqetIUQKlo7hFMSoF7UHNVhO5qepgpMcInLEA0HEAe5sOC076XdtSJiqD1HKAxiPxK+ijLwBjhSlfo5oOQSs+FHwFyzcXP0ZIaHdKDcKplWu6xAfFDwqTtnkXH6ilYCh0c2iKyvbBSP1jMxzMitpdJF+KymuxI0zrs6PQP52IL6rXmNPsIP2LLhEzV8N+KYYVGv/TV5VPimtNChbSCLp6ylp1Vj9VSdYoRzFMbY/i1CfbUXSGAqUxramSAmH4Mu2MVHLSxj3nWbnqWrwokSgMwgbyuBVLbvfzz2PnxNo19eDoBmt7lX8p3oWQZt9NPcg++8STbp/P8uVaGddSNN7Up4azn2VfOOsY9T8JY7yx4DwMYAUDRjjWeWuqBrh8wpAlrAlDEDgjybBNHjO6Kee2aSMbDm7NVVsPM6qDzUvifydGAzafExQNdCtCHKHgQ8xzl/HLXUO8612O7+8sIvamYtfnizW0UX0hwf0ts3kK5KGEGGXy3ZhuN1b/5tG0swSY3xJPXBWPEGwGuCycai3uUJoEnH6pWZj2btbybJqPqDPkcxhxp5RzBMlP0zxW/FhB1yxGFnDjBJDw5D3tr2wxn3UbwYW3uhLdjxsZvFKgJCSR8Uug0zOkcAIlAMIVPbD0JIyghUsSZfiscrZHiY1uP4oGq2oV6s6XnKxTQnlCwIRbq9cnotQ6ITOkuu/ZYQ59BYDsHZH+LedLnhzwhzFgnbEhkjLP5uWSQIu0SGklRMtc+0Cxvwd4QWLFd9QmCGx8FzfEdRwQzRInXDN/rSl/320Vag310jNi4qob/uQ4zvfd2QXkXmxLYbiWAtISdOf
 bszkoIdL
 yL6ZdygHjPQtsXKM//eXPzFHWK8ho40RvAsEU4lJCfWZToSSkwMw5Q4g8Cdj4394DW0fTIE8QObm8CE4z+lIpq2BtXG0Kmy1AH7YqiOyFI+5aCdSRd0EoFTqwTVkwxjWEABjt5gTiXx6LxVej88m701fD9kqBLDj42fuKZukXZBl4z5aEmB9H+6H3sqo9Ju4oApHSojSyJ15eK7ktxMMb3avJVZXkETTwolxzSsdHAlxOjIs/YH40qEWDVBQMVAb8GnombGbmO40jUjCkz2LTTNBmb9+8O2nnxYsR6k3s+6IWDohrlTzmh2DdozsYomzP6HNDcClJGD+9fE8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 15:30:24 +0800 Hongfu Li <lihongfu@kylinos.cn> wrote:

> This series is version 2 of the previous patch [0].  In v2, the changes are
> split into two patches for easier review.
> [0] https://lore.kernel.org/all/20260518082120.3890552-1-lihongfu@kylinos.cn/
> 
> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and 
> per-test tracing for consistent diagnostics, and add missing mmap() return 
> checks with MAP_FAILED used throughout for readability and consistency.

Thanks.  AI review seems to have found a legitimate problem:
	https://sashiko.dev/#/patchset/20260525073026.27594-1-lihongfu@kylinos.cn

