Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519B5C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE5F6B0092; Thu, 17 Sep 2026 05:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485936B0093; Thu, 17 Sep 2026 05:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C326B0095; Thu, 17 Sep 2026 05:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21E5B6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:45:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D58A802C4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:45:00 +0000 (UTC)
X-FDA: 85222770360.24.A6DF2AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 074E640003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:44:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lA/oD3Xi";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789638299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1skJUV0DdBu4g2bOw3ZBlDk+5R5phbl6b1ujncvlfo=;
	b=uJdrX/KBPXY1mw0nKkhRhOwvQDVB1RkQvDFfVa7pC6wSoTNdWU+WnX04CopJIrAlf2p/bE
	hxrnK2AbIZVG1rHswuPoZqLCOzLrN7N5se5zP+rEJ4igTLnIVa/roTMm/nmbfjJ4aoW0R1
	popxDgexty1NBjqFc4HqN/o6trGxXus=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789638299;
	b=0HGEnUccWi0QaXdeiNQHYxbVOVRKn0l0RoHNwvLzO+8k4/43BQyPOH7MOzbg2HKjGLyUNm
	m6bMJ87EMJ+No6MXwHaNlqyQpyTsdrTeQUUarNptuEhvrtb7aLled+CzRa3KElQ9ONugn5
	iSeWyq7YiVhdmmxGrE5nzTQVmNFUDx8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lA/oD3Xi";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30BA44382D;
	Thu, 17 Sep 2026 09:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FAE1F000FF;
	Thu, 17 Sep 2026 09:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789638298;
	bh=D1skJUV0DdBu4g2bOw3ZBlDk+5R5phbl6b1ujncvlfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lA/oD3Xi/R7OGRfWv0XtB2ZJULQzeebJ0WnCL3HhKF5gfSpng//lWwlWDveRr1v3u
	 XnHKqt9K4kONwsNb/4byXHynuDo7i9vRnvTK6jwmJQVSv9Q14qvCMpo+jteHhUo0Et
	 QsdR7S7bppX81g2kyyWMrDikoznTWHTESjFjO/h/N7FnlWIa3GVRPceIS03Na96Puc
	 CwNk1JL5xC/buoc9Mm8Axflsv/VdtLgeXQhjXhyugkY0f4+a6k0+fyfYtWFphoUG6W
	 S3bvpSWujQghG5IqqSChyaaG9wwbRD9sHq/W4ji+P2RUHGdFIpjzZ1cPBCakka1Vfk
	 XvPRQtSdy0D9w==
Date: Thu, 17 Sep 2026 12:44:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Priyanshu Kumar <priyanshukumarpu@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] memblock: Remove unused exact nid allocation API
Message-ID: <aqu2lCK5Nkw-9fHW@kernel.org>
References: <20260917081504.30426-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917081504.30426-1-kaitao.cheng@linux.dev>
X-Stat-Signature: 6qznuyziq6ctrrgwx5z4dcxq5akgrgz9
X-Rspam-User: 
X-Rspamd-Queue-Id: 074E640003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789638298-380359
X-HE-Meta: U2FsdGVkX18QH1gwE5nTqPWvpa9GGGF75PJohgf29ObW0MuA/xev77c9C7nVuXPksSu/vz9zaqB6uwGlCQutwp06AHvDhuG/qLwN4zgCvyM33KpApU2/tgFdE+8aNUqrNznWJt1VazxkLSxCIKgjpl65vb4mo/3oAQpzqpoBbrw4lc2iO2Y7B01+q9+htee/yxA83XBICy1qGKxMlcYpeH1XWNnQiuhwhc8Iy2YO7qLSzHu7f5ZaM9ivyCyapR9eysB1s0bBaYQGFVn9cK0nnEzG4q8K5ejq04NQ7emvkvwmc0NucBr6CZbtKVPJVDJYahe59NtdwjQkbG8g3jEaU1dVi1GIzyrsPhm4tRxZolSkDgl+KwHuajYdSDimEpViiiu4OlWGGD/lPXNtviOhQl9HFHYVSJK6XCOo3ApjlS0B4VRI9uY+j2FkEjWsz2O+GQx/KvK08dGHVD6BKkLo+v0qlVDOg5RiRVJRAEDn2ta99DuP8bpLPXc/dVNOIhzliX5W3WNAXAkiQwNGDj97Et409GXuehV7WG/t+H75yffQ797FwqoLgZxlsk28ZGaNPxdECP2+a3U4BZ3SjIor+NaxjFJuFgMF5p/WCA/WaD0UUEw/9cW+/jA6LFZlWZl0QsrDoXZ9SdUm1IKMqdo/tobSoDsITiNQ+P2Q42fset7Zriv9Djbovo/9j7A+TKaXVffyI5H9P1o1bfUZtF+nzSg7cdPbli1vLYaM+q2qIDPIPLCDgTKFMDRYY5q39l9522csPL7t98z4qFUKpxM3YqEfiLeAuI5qjxFEQtGIW8qB0MqzpA7EC2ITBNsoEqzC8Gas6h6v2YbzFJK8qx78lcgvmmyrk4KgV6KXSRrtXJufJCWnbUT3xkS52brEfLu5zTsc5NctmmVtvhn9FasN71wGzf8MfTFrsQWlDsuXTv80uhh8Of6iljYi24Fys8nmTz6tR9dvH6J1guscOBD
 q0zV1bvy
 a9C0dpswnUHxbbvwFHI1x52xIG0+VR9o3fPay8m0adNN1aFOcBhWxJrXvq/LsMIm2BZsc6k2gsxqVq69VhWex4S3QrlPqGitNj3Ko2/kmgrTcE1++dUt1TqByp1R6J3YFfvy4H2yZkv8dM/5fq7Z9X4NxhvgK2mWn83MZ++fUYILAXNM40PrxMVrrAthPs9XzKNAnV8bPtJdz4kN28SmVfNwz8u4gfTlFqrxqVrT6Dyv1ZEGjl+wpCJ7S2rG1mnsaVvjj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 04:15:02PM +0800, Kaitao Cheng wrote:
> This series follows the removal of the unused exact_nid argument from
> memmap_alloc(). That change removed the last in-kernel caller of
> memblock_alloc_exact_nid_raw(), leaving only the memblock simulator
> tests using the function.

Please resend the patch that removed exact_nid from memmap_alloc() and
these patches as a single set.
 
> The first patch moves the applicable exact-node allocation tests to
> memblock_alloc_range_nid(). The second patch removes
> memblock_alloc_exact_nid_raw() and drops the exact_nid argument from
> memblock_alloc_internal(), as all of its remaining callers allow
> fallback to other NUMA nodes.
> 
> The investigation cannot be extended to removing the exact_nid argument
> from memblock_alloc_range_nid(). CMA passes true when reserving per-node
> CMA areas. Allowing such an allocation to fall back to another node
> could leave the CMA area's recorded nid inconsistent with the physical
> location of its memory. KHO also passes true when allocating per-node
> scratch areas and requires those allocations to remain on the requested
> node.
> 
> Since exact-node allocation remains a required behavior of
> memblock_alloc_range_nid(), deleting all of the tests in
> alloc_exact_nid_api.c would remove useful coverage. Preserve the
> applicable NUMA tests by making them call memblock_alloc_range_nid()
> directly with exact_nid set.
> 
> Some tests cannot be preserved unchanged because they exercise
> memblock_alloc_internal() retrying below min_addr. Unlike
> memblock_alloc_internal(), memblock_alloc_range_nid() treats its start
> address as a hard boundary and does not retry from address zero. Remove
> those tests together with the now-unused TEST_F_EXACT dispatch from the
> shared allocation tests.
> 
> Kaitao Cheng (2):
>   memblock tests: Move exact nid tests to memblock_alloc_range_nid()
>   memblock: Remove unused memblock_alloc_exact_nid_raw()
> 
>  include/linux/memblock.h                      |   3 -
>  mm/memblock.c                                 |  44 +-
>  .../memblock/tests/alloc_exact_nid_api.c      | 454 ++----------------
>  tools/testing/memblock/tests/alloc_nid_api.c  |  20 -
>  tools/testing/memblock/tests/alloc_nid_api.h  |   1 -
>  tools/testing/memblock/tests/common.h         |   2 -
>  6 files changed, 42 insertions(+), 482 deletions(-)
> 
> -- 
> 2.54.0 (Apple Git-157)
> 

-- 
Sincerely yours,
Mike.

