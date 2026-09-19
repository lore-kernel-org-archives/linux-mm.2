Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5C9C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 16:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02736B0088; Sat, 19 Sep 2026 12:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3616B008A; Sat, 19 Sep 2026 12:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB6F6B008C; Sat, 19 Sep 2026 12:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67CF66B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 12:07:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C3701A026D
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:07:36 +0000 (UTC)
X-FDA: 85230992112.05.2E7DC04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 145B1A000F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:07:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcnzfZV0;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789834055;
	b=MaXSmwND7GYq2f+xM453WVBoq2jBtHRu3jXb9tSIE0pBg2oLIDOOwNzYoNGJyU8zrWtX7U
	ytN6KPkLI82H7poDBpkxYRAtTUZ76uFm3SsRCBROm9As99jcFeC6YECHR9E8FrMfsBy2bL
	rgzg5TDfPxIWVCsbncwrJL914HErqT0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcnzfZV0;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789834055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQHa39SbYUNszRpbhZJPTtwB+DOrWIjoWgUc5UFfUZA=;
	b=pCBHFGXfQ1uEq2Gv3EcH/gP3sZDWWk4l3kwVW2qepY6ZnGT3GSJaX89ldTybUfVxpzNz1N
	aB0JZRVuDYlC8l2WpF2nlVaO4JqS83yMp6Syh28NgIy/zfjkgiEYEKw6QymYKUaaTSsa3q
	KDtyoIUZhSpDMnKdZl2BgtDp9CkAV9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6B60601E4;
	Sat, 19 Sep 2026 16:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2641F000FF;
	Sat, 19 Sep 2026 16:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789834053;
	bh=wQHa39SbYUNszRpbhZJPTtwB+DOrWIjoWgUc5UFfUZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcnzfZV0jfozeaH0PTAEYh1w4FxYSswdPyKtVUe7I5onhLQzYRsjcBsnJ6PfYwrUI
	 /SQ7eb0aaKAOjJIFvmYp2mXykwN+0PIPFCZG81ZoL8i+ucysh3PFFL4CiaJkOLylcq
	 5A82Dfm4UtMfPFB4PHb5ucPYcMLmCd4Wb2dUIaeBii9chXlLnWoNyjyL4pKY1GPL9b
	 UL8HpDBz4Dfa+0IDb2ZYKzw8TLZOz7pOzQDUoYzhhwsnE4cftsgRhvUPXk3n2MC9Fi
	 lGqb7jVuOrqzH+0AYzeCZF9hfyftMY9YG2a2bgTJQcgGOgGgxbhxga40lLoj4gILKe
	 ToZak5MabqyRg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Sat, 19 Sep 2026 09:07:25 -0700
Message-ID: <20260919160725.86256-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919080453.628679-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 145B1A000F
X-Rspam-User: 
X-Stat-Signature: 81uu1k49kkpcetbp3g1wmxouqcbzmq4g
X-HE-Tag: 1789834054-47865
X-HE-Meta: U2FsdGVkX1/u3vtAy8BAWqN/f50ud/8NwrtygLWUwXWMSbnGgBVZhPTq94ipQJJsW5lc9AFQ9s54iCkMi8LpAQAWrglKslMAWnjNJY9rTsp3rCQxvVmQzpH7Hv+9Lc755ZWpfxv8IvwPUr16GLIS4KSvXuZ+tHk6eXGxtDQOoKY9PADIfyW1FHsvp+lfCD7ayxeHwI/XzGAF3bFmpus0s5qzg895960A6t8r9gXjwBSZkYYS8/oMi3Uooc+msNkD8qTHT2V4JbbBDLvMzI++3BDZqDtE53uZ9CxB4rdRPiOy3m80iPCAImVyl0P4z2yjnm7idaFuTHxJIC6UqEWPy4XTxFV+9vzmqkBxupBu09pTy3n6umVvXvGWpD1khWiO0ObgFix92FTC23lm2oGeHnbBQWUizJVYwhPAgm/F0KBcty1w6WiacDTZ5D+YiVukuNwMNwZ3fX+r03HsN0KaOSbsj2rKFEkd/2HEL77Vl2JkPyf3ElRWvLZmsd276bGYgZKyHZUWDzvUJGqy67Q1DPw3mUF0uw4DBqjtNbvXQkBtnVT+PATsYeYmqhBwan5Zp8idcVCn11xX1Y6oAxlp4IFxbStg9eC0E9nDjAOB+gbGZkG2hXHs/p6ZeH5Ziz21PoXE9cb5j8+ARustp+V8QzlFJbSW3KTVpVSvejAVne2RrSN057DV9PEnPX+AEZTSOgkcg8TPuU+PMBqnTQqB1yj9evroF3ceHc0+2RxS+jGDUQPt9XyFVKwGERMk+6fCISmMHW5J2wf2lV4W1rnhHSiQP9NJb020ht/aCYz4YB6qv35+9oX3fiZIjSy/tU31F/qm0tmqehMiKDXnTodjSiGA8szwz/vDbSEYUuawuGpO6Idjmc4Gs6NpwcCaf4t0yA1bCq7B4QURRn2m9+IoI4nTonq73Gi1Yt/iU/6ultgDo1v9Rw4xY7FUwvm8Yhlfm567QthMGpzx25QNTeo
 eBMTUCHx
 UffJVSceTuFYtvmYm3B0z9w/AC5TBsB4NHwsCTo59Gv10sOAMvsUMLnSTPNkVokGHFbD1UVOOeK2XCCscsGsVw4CHx9jxG3zCnv14jqNJoYfaqrEJNQz6JohcIwpRrZgrbtRVbiXF3jtGrMGYPqLrW4aWTYw3WKcIlqG6F6vBtHshnKM1SjGdVdJOJmDOl+4XHZkkUbIG9ozC3iEDQaC7mpjy9EW9ErTfgM7U86/D/EZwpa9gkXaraKuE/qGi7CX/pxf40l9IojAx27ADPSAE/c20Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 16:01:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Commit 50585192bc2e ("mm/damon/schemes: skip already charged targets and
> regions") introduced a minor issue that causes the last region to be
> skipped before it is processed.
> 
> Example:
> 
>     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
>     2. Quota is configured to process only 100 bytes per window.
>     3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
>        addr}_from is saved at (Target, 100).
>     4. Window 2: The loop reaches R2.  Because R2 is
>        damon_last_region(t), the old code unconditionally returns true,
>        skipping R2 entirely and resetting the charge_{target,addr}_from.
> 
>     Result: R2 is permanently skipped even though it has never been
>     processed.
> 
> Add a test to prevent this regression in the future.
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Other than a trivial style that I commented below,

Reviewed-by: SJ Park <sj@kernel.org>

[...]
> +static void damon_test_last_region_quota_reset(struct kunit *test)
> +{
[...]
> +	t = damon_new_target();
> +	if (!t) {
> +		kunit_skip(test, "target alloc fail");
> +	}

Let's drop braces for single line, as suggested [1] in coding-style.

[1] https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces


Thanks,
SJ

