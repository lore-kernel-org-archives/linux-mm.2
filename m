Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D728FCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 16:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323528E003B; Fri, 17 Oct 2025 12:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4528E001F; Fri, 17 Oct 2025 12:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E96D8E003B; Fri, 17 Oct 2025 12:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8818E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:28:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 621A413A231
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:28:36 +0000 (UTC)
X-FDA: 84008139432.30.FF2EBB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DEACBC0003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:28:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvib35gR;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760718514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyiafsZ0Mfts0KO/fNhIeGvjyVj2CpPQYnnGh5OHsu8=;
	b=hJzA5VmahXHLLUQrGMDrdfHbBlIXX19FNh5UOkBkxg17jN2nHxacXO69vrzH9mcwYCAhTR
	A+E4wyG55YbaXSuTL6cWj3sCj5gVloHppPHJ8URz14ProZtn+qYShm2PTIN827PJLAIeCd
	2nT4U+E5ftOfmOK4ty+rlXtJ0ieXCwA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvib35gR;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760718514; a=rsa-sha256;
	cv=none;
	b=g/CUHGSrMfwOko8WIpkaDEjBf5Mq+Tfq4RBd/9UNvAigjq1yB8QJ3e5iPZ7B25XuVwQFVD
	C7CfuAoK6itxdiuhQX6nQkLfya/azU7Ujl2X8FD4ERUu5DJkiNbbwpeUWzrCLg0Z+edqhC
	RCw2wGfCOQL1Bnn3xWQFZYV7kHPb6JU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0804F6052C;
	Fri, 17 Oct 2025 16:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D86C4CEE7;
	Fri, 17 Oct 2025 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760718513;
	bh=y6vYbALsJkMlFJydwFebCPjCAMuCiquwR51ZP9B99Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvib35gR53GA95T0WTt9rTSAbf8JRkzineRX9qYxrL0MAZE+MbO5z2EXazWk4zd0E
	 2X5u+UvXa6WaJFaRocHXa4iaq7BRw2i+XYLLwSAEatPT9e1r6g9LNGlIc+qJXq7ASH
	 /TVIPLRKcWPc9/1VK1Tj5mR9hCqJutjQBBfVVzubKfr5HHYmVMlOy4gEfGIpNxrztL
	 hnPwIAhuOeggTsP1KQKhG6S5dHWC56rfxc+SXJUWx+dBlq9csN5Ph6M3wFXrYXYdRc
	 0hGgvHgKQDmqEkdYK3s/aARELIJ+jckxlkIg1NGZs8pr/BSkY/hG2RzdcCgVijcG60
	 mlvcBx8ywGjMw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH] mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
Date: Fri, 17 Oct 2025 09:28:28 -0700
Message-ID: <20251017162831.116160-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <4c2e5879-e554-49c0-8f05-094031cbb64a@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DEACBC0003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7srsac9b9fow75qm73b6xjosiiin6wwi
X-HE-Tag: 1760718514-693852
X-HE-Meta: U2FsdGVkX1+fSAo20eW8dvik+/aZ5rezwJmJ7CcGwPUsurE5YhDzo9bQvbcI5aUFz0oGwzU2nGvElj0w18dQZiKNlE6dt+ot0OWO/sV0819GOUkEv8wzQejEu78pWYlAwFk9Sny8GmkVKvrSLtP+kgbsMWzydxBZ/nXP+vDz7sSxEtZyy4f3BpJmaDszUo+F9qdVS6gYYnU8S8MYh3tRJaXK/6fsPabSHVa/e4dGlamD0gbIazvV1VBI2zm7v90NoogS4qM3wCMgrk6SHtM7RYvq7EM7IjQu1m5wwu6HgJPbBSBqUjsWbT0bIow0rN5uguPltFvUtADIc4McmtOqAWfx+1Mp1/QFsUt98ZbxZtLl9/OnHil1yjqCAHEekCvv4t9ILuTWwvXI8S/iufXzgRnJS8VKz+MSxEJXLbd8Mfrfode9PbQ3hWcQjAXEn7aMI3ow58OGia9ymPgw3NS13XsmfX+hJbSiiQC/dgas1U1BOlI0DuRsBWQrrTXjFPEvOgFs9AUa5uUqR2G6xanuz1Zac3/FQ5n5hjQJRcqSbkX2SbP4ekMOfEdCmZEjCT4/TBtucDdr/LyvEivTKtxcfZ9EHypV6Y8wyv9TVDC27Ree6J3DndpSKBk3NW5Zph+l9UpmkEtWrWtHfWzqbbmQj9R/I2bojcOWLA3i75CGhURFQu37QPNVLIbahmkvpNShy29ryDortI7eSKQDC80sPCOlooyiV8/SXy9cp/O+o5N+iVilh3cg6pVoTFRjOuwKNwiZNALJ5o8HYpfqPgnlVQziFxhBGahygCqP6HZJbihh8cnT7FzHB2Rl2Ap7T942be51oXwZMGt6LpU1i0IumaW2tkK0PGDMJ64JcpEQzPSmBbethfHQGDCFBaG4WJ1wtET7o4qUntlmXePqiIhzeDQ97BFGB23vwm9QwV/rDoYumGpjndB2zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Oct 2025 11:12:00 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Hi SJ,
> 
> 在 2025/10/17 3:48, SeongJae Park 写道:
> > On Thu, 16 Oct 2025 18:47:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> >
> >> After adding addr_unit support for DAMON_LRU_SORT and DAMON_RECLAIM,
> >> the related region setup now requires alignment based on min_sz_region.
> >>
> >> Add min_sz_region to damon_set_region_biggest_system_ram_default()
> >> and use it when calling damon_set_regions(), replacing the previously
> >> hardcoded DAMON_MIN_REGION.
> > Can we add more detailed description of the end user issue on the commit
> > message?  My understanding of the issue is that the monitoring target address
> > ranges for DAMON_LRU_SORT and DAMON_RECLAIM would be aligned on
> > DAMON_MIN_REGION * addr_unit.
> >
> > For example, if user sets the monitoring target address range as [4, 8) and
> > addr_unit as 1024, the aimed monitoring target address range is [4 KiB, 8 KiB).
> > But damon_set_regions() will apply DAMON_MIN_REGION as the core address
> > alignment.  Assuming DAMON_MIN_REGION is 4096, so resulting target address
> > range will be [0, 4096) in the DAMON core layer address system, and [0, 4 MiB)
> > in the physical address space.
> >
> > So the end user effect is that DAMON_LRU_SORT and DAMON_RECLAIM could work for
> > unexpectedly large physical address ranges, when they 1) set addr_unit to a
> > value larger than 1, and 2) set the monitoring target address range as not
> > aligned in 4096*addr_unit.
> >
> > Let me know if I'm misunderstanding something.
> >
> > Also, if you encountered the issue in a real or a realistic use case, adding
> > that on the commit message together would be very helpful.
> 
> Thank you for the additional explanation! Your understanding and description of
> the issue are entirely correct.
> 
> Our ultimate goal is to have the monitoring target address range aligned to
> DAMON_MIN_REGION. In the original logic, however, damon_set_regions() did not
> take the newly introduced addr_unit into account, and directly performed core
> address alignment based only on DAMON_MIN_REGION. As a result, the monitoring
> target address range was aligned to DAMON_MIN_REGION * addr_unit, causing
> DAMON_LRU_SORT and DAMON_RECLAIM to potentially operate on incorrect physical
> address ranges. Therefore, we need to use min_sz_region instead of
> DAMON_MIN_REGION in damon_set_regions().

Thank you for confirming!

> 
> I will add the detailed commit description in the v2 patch.

Looking forward to the v2!

> 
> >> Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
> >> Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
> > Let's break this patch into two patches, so that we have one fix per broken
> > commit.
> 
> Yes, I actually considered splitting it up before submitting this patch, but found that
> doing so might make the patches look odd. Since we're modifying the input parameters
> of damon_set_region_biggest_system_ram_default(), all the call sites of this function
> need to be updated accordingly. It seems we might need to split this into three patches:
> 1. Preparation patch: Add the min_sz_region parameter to
>     damon_set_region_biggest_system_ram_default(), passing ctx->min_sz_region in stat.c,
>     and passing DAMON_MIN_REGION when calling this function in reclaim.c/lru_sort.c?
> 2. Fixes patch 1: Modify lru_sort.c to pass param_ctx->min_sz_region.
> 3. Fixes patch 2: Modify reclaim.c to pass param_ctx->min_sz_region.
> 
> I'm not entirely comfortable with this approach. Would it be acceptable to submit this
> as a single patch?

I think you can merge the first and the second patch into one single patch,
resulting in two patches each fixing the issue on DAMON_LRU_SORT and
DAMON_RECLAIM in the order.  It doesn't look odd to me.


Thanks,
SJ

[...]

