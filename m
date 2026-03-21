Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4821099B56
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 00:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136D96B00A3; Fri, 20 Mar 2026 20:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E6E6B00A4; Fri, 20 Mar 2026 20:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B286B00A5; Fri, 20 Mar 2026 20:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7D216B00A3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:54:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B4C658CEC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:54:26 +0000 (UTC)
X-FDA: 84568249332.16.939E101
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CEA73C0006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:54:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mnrnE65Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774054464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkkhBu411aNcP52HBifRBU3AmM4vjRkNu8p4QLrHErg=;
	b=fZIYwRNpE03aeioNV+pTYHhDoOg24Mhe1ok32LZk+labUUmkcWWfMf7I/hRGAJ5bY5QkMl
	Q4C0uv0vC3RpNDr/mcQKzgxNSK5x2/x9ukpSOG1tJxVLXSc/aM+V3H8mqd7JkK5dT4Kzh5
	g/hiXb8vX7/XfF0Q7pEjBF/G0A/Y5wE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774054464; a=rsa-sha256;
	cv=none;
	b=SM1QcxazXFExHJdVHoYTB2IhKXUF4L+m531td3+seSE7xy5yz7LVH69EROk+Ry0PJ4RRW8
	TL560zvGI4bSwqzpu1u+u2NsHqoZfHCxPjcilvYj2JBdHc/IP23zqDJUWHFh7I8pL6bPc2
	3VJaaZgOEseZ/zB6Jj60glGTy/78MoM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mnrnE65Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D596F4436D;
	Sat, 21 Mar 2026 00:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E51C4CEF7;
	Sat, 21 Mar 2026 00:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774054463;
	bh=PEeArNKfdFtHas/K96y4Ll77SY637LRRo0yTKUiZYcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnrnE65YuUXx6wnZe89Pe8iU5GLqPwOxRUTc/lGakGTHrXAe056KH8+F0/0eC9+hd
	 OuSgVk6eCFkMm1LUPnYjqoGChMnSnkildU6yWNvDyW7PFu/vSK+4HKx2pBaD+xUcgQ
	 EUrgbXRoPKLRgDaLDX/I2kverlCh6icZ2CuahrzwSOCYjG6Fr8xic5NqUrOz3CbYGo
	 txpfW1U/R+sbbMGNi+IY/AD5mar9Wm2MNK23PGQvJ93YrALvHjotp2RmWZB7jRkqts
	 grePXrbvJB0zhp+wP3oMY34PmU3Vt8Gt+F8MNCh9RPK7K6VdCtDT6ODEEHEXjS6Rc8
	 szJr8/dx/SiNg==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Fri, 20 Mar 2026 17:54:19 -0700
Message-ID: <20260321005420.80596-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320163559.178101-3-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CEA73C0006
X-Stat-Signature: rxixqe8zjwd75x5noa86x3ygjq6m5ieq
X-Rspam-User: 
X-HE-Tag: 1774054464-393765
X-HE-Meta: U2FsdGVkX18N0F41H2CyYHH4jHUiaH+C66JLhi8rtRE/jrIETUdDHu+o2Bugixzj+GHJKA1945JGFAROXrcnn+dbanIBhKWKpRWVvtHGBUakgyWbnAfohzospOL7OQxgLK/i3NZug7Ito6Y1Ppmle3j+VMpJHbQx9kwB2e+4Jb2R8Uavl/zfXSw5hnzXDHOKzwfE2GJKJT0iaqNtJpo5Hvf9imqNj681I2Hm+iCXKzdtb5b+PMYn3xXQ/zsQ9JEbWoYXp8BfdghKfmPU0mxnxjtE8XIlVOyKQngT0ARX/z0FN0I76B613WXCf7j51z47v1j3NLlZgkcPiM4zxLe3I7jtT1SXyzQqtWvfazye/l5bItHkqxAU1kXVtwhc8TjSijthcWpK+Lqz5dI3477or6W4JCfHUJZkgrXki+IgGGgmsJejtlK2jV1jwsh78vKE4Lwad/PbaB2l5PvBqsA0PYrM09cdlKCNJTEJ2AycWnYYUPEBQtgxSZU4k3bZsvmQIO1qQoh7gffNow6DAY63GVo57s9lgh55QlDUvjy7ndAKuc4EzhFgPNIEMPKSo1XJp4teLLcNa89U3hDHCuK/x3rV/5dpSI6g5d8h4UTd2rDvc5igT+Q+Xbu21sS3O26I3LiUAu9Z0L6Bk6JW+PW4eA9E39mqy+899R3SUKE9YOjErz6+loH1UZWHEpgwTRDx2myt0IFb28whO81eY5x6qFyXSIvvZdMbVK92SSRJ8Y2rK7pvCxY2Wmhz4ZiuWa79rIlZGV1uYMCgIOmWSszudi7XN/r7Fmk2m09tvCtDZNSjEjbw95jOvTpa+IkbakY7kiTH6owtXcF0OK+A7fZix9FhQGLYUNysutVYLCiqGkrfUUtjKV7PW+3Yod8d3YE9m8P+EfYxm/80qHZiIwu5Q3z8/yllBGompvMzs5dcSnOCHmj8nRjLe4GrXJ48AzsR79lnrWYSWtqmNjtroB/
 dweBI1gY
 N9AoMxfqK4xOrGJ9JHztSaVDlk9NzqOU8U4RCx5udmLGZP0t0/baJPzy1HYqJMkJRSUIz49wJrSxAA78pD0z1VIvJ2oalC9F5HI4ho39myGWQZ/MXop/CVRlXWPE0hJf8E5d2S5bdqVT1gUB9J9jS5jSZCowEoquQaXeIs6pp3FsDQKptVdPtj1SuDL6e+MRr5AKQp5RFE/jwpka8xz0qQCzKhGBUySl+E5oV03KHAGelWyWZ7SH+437SB18BajDdElhZjUeJrUdxiJPqluzZFis+hyQJSU+P/8n4GfJmzivc+woFXmop3LlPDjPeEbPRYQfU3IwDH4qN4ALYrG0Z+8LkJXWHSiPp882pI8ax+aeMaix4vmp5KnCB9Y/dCT9kbOQVBIeg3M67Ogg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 16:35:59 +0000 Josh Law <objecting@objecting.org> wrote:

> damon_sysfs_repeat_call_fn() calls damon_sysfs_upd_tuned_intervals(),
> damon_sysfs_upd_schemes_stats(), and
> damon_sysfs_upd_schemes_effective_quotas() without checking
> contexts->nr.  If nr_contexts is set to 0 via sysfs while DAMON is
> running, these functions dereference contexts_arr[0] and cause a NULL
> pointer dereference.  Add the missing check.
> 
> Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
> Cc: <stable@vger.kernel.org> # 6.17.x
> Signed-off-by: Josh Law <objecting@objecting.org>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> ---

From the next time, please add patch changelog here.

[...]
Sashiko also added comments [1] that are very same as those for the previous
version of this patch.  I replied [2] to those on the thread.  In short, nice
findings but orthogonal to this patch, and I will work on those separately.

[1] https://sashiko.dev/#/patchset/20260320163559.178101-3-objecting@objecting.org
[2] https://lore.kernel.org/20260320020630.962-1-sj@kernel.org


Thanks,
SJ

[...]

