Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D328FD0651
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10A5A6B0005; Wed, 11 Mar 2026 10:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0871D6B0089; Wed, 11 Mar 2026 10:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB7E6B008A; Wed, 11 Mar 2026 10:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C948E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:15:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AD581B7075
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:15:46 +0000 (UTC)
X-FDA: 84533980692.06.95BACA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C256314001A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:15:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n3DndFFE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773238544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Clt0DQs60d/ZG03TM9GIry7bo+puyERJ0DzramOvtvg=;
	b=oiGxhpNuPFJln0OIoL/CyjPeg8w5MEzc92lt7p9oj+l9Fief6+owSDr99oZKpJTbTIP7Qq
	fJsRpmA8Fl5vyqjfEOuoCU0dZWwXk2Z88Vnb7xrma4TFDNDDvkJONm+boTAeb1Lu0xu0pf
	9z+qFs4pLK5YO8w9Ge3GV6N5YQihvXw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n3DndFFE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773238544; a=rsa-sha256;
	cv=none;
	b=CRm/YMMbqQBkfHTlSMTbTWWBk3hx1Lpi64cIOf8r5CfjzUtpJTZSLDi/q3gpuew9bTsQDq
	Lj3t4DTgPproDxjSNt9+45DDdSZ3DxGdIzXCvpn4ln3kBVrep6MC4/tNFg2ulWOM6nLEnz
	ebmc8pL8eKkwFBiKlm3MHkdW0bxsKqk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 679A4600B0;
	Wed, 11 Mar 2026 14:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECB3C4CEF7;
	Wed, 11 Mar 2026 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773238542;
	bh=gJf2hT1zxwV0L7MQvy0u3llLuP0G7FBCE3sa8wyOois=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3DndFFE9UkffnsBBonl96rB5qoX1Z3uyeu5Mj3TI2ljDgv3/9fzJ89O/jXyrvw1p
	 UkszehXje7Of9U7WRDkWoq885wyPcFnnN6v/CkwRAMuS7HehWQq7eWkySs3TvKCD+1
	 B9cJIeCm603PxlOK17q5MhQiPnrqQL9qwVFPWm2t9EuoyC+GTTUc89bJZ9go7RkbFq
	 yZdianXHsN0JOaeOBsx9vqASMrYEQuXHS/FprXofvqFCaL/8J9G1SRdgMxQFzDMhdX
	 wdurVrXQesYNuBEgARJr6+oQVEh4UzIG06lBd3KpADdGkJKryfMuh1PHogzbm7ncOH
	 CDiZfZfU2bGRA==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] mm/damon: Generic context creation for modules
Date: Wed, 11 Mar 2026 07:15:32 -0700
Message-ID: <20260311141533.96435-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <013c9fcd-bdeb-4508-8495-9ce9cd65b578@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C256314001A
X-Stat-Signature: q3awi3znfc35t13dor19xkoygt14iuai
X-Rspam-User: 
X-HE-Tag: 1773238544-547820
X-HE-Meta: U2FsdGVkX18LbVHROU8nGBjqJ+ULCGi0NgxImmzeJt92xmxa73xzUAXaYR9H/Wi6ZGqLFer4iTNQgCxYX50pHOVzo0GD+6IxnIhhxC9GUOzCStJT36ygoAn0d0K9x55kSPqLq++fyKdHm99JycTjTSQ63n8M2Me3b8eBTzWfeHOX+MqGdsoJzVqenc7LgFxu2x+gTCnsvuK2kc9Zt7ZCdmGM9V3UzUGhAgkl11NrEC4p4O7uJ/dKfz6sCXqbmLSQ0aZLFIwuX456iljlMIgUhVJIG08rcIYcX3zWC48+4ZEPiANgDqn50/lzPFbW3u+Z5NNO4XxYmeHf5yhBQOxxiZv0ewN290jokaCC+HrdXs3YN+WoqUOI4IcAHnCzmg8IxtCKIoQcYNhL9pOn7ObwHLBPHAkb0MlwC2fog1TMEMuXZggM5bsGQsVBNHHLwYf7+uNJTBAvT04sUzLZ22jkAT2xVSnOUbeDo+7AoDfKi8YI+xWUiZmCwTy2oVkLuwzdriFXRqR+SdicyxtJasNjr+nncEepfYoG9ny8Po9jcsWo+zFTmp1otuWYPQh4WVzsTebwwHUtfNNRQ0g758YxzD8hWHbJhIsWHFr9mzht/OaRKkWE76MJY9RV6Ab2+cfmJlGM2VeXOt8GI9ehGPqxgLJrbjBMcO6t0NaqsFC8YRLoUInwLRVkTl8/7WdUEW8TvWir0dg3cNUp+OOUNCcQeC1rlzHRr9uks4eKXMW2CiFt6om8stGChuLhbKUWfLsYH+xrFQpMJCOsEhnNvbejAcddbj4VhbfRaBl0GD6NiV+PlZ7Ont8EKmkvjP/nQRJZq9/M61BGXAmdqkHqciEd90bdH6vBakT+GE0ISg7m95wHSs0aZK7FYNAHHJl5JWQ8qPKibAOSwXR8shE1BYiQNqNcXShL6vYfeOGt8WCDdAN+SmOS15wv/ij/t+oIJA9Hw2CMRkCrst6wb5pDXqB
 ZkMecYfr
 oV02w4wuXyDgyiJaQP7W55E4QCkzZQfFktumDBVzjZSKtU3Kf39zy/hFezKedAwoI+z43/hwIClL1o1M3iQ75t4v93N5oHmcNQILH7X7w9YCdnJEBSFkf6SofRlqgec0Re+CVfhgC//gRunz2YJnsav+frG68PlPVSrJ853xL18l1V5etKV2iEJv34VS7cQLXAqF7Il7y7r7Xws554heMIzC1ODrXWWT83mmsN6F1uGASosgOP8OnEEwgXJQmPI5DkvMyiAGHBesTnlGld+206yyNskPwfaAbe476
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 16:10:19 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 3/11/2026 3:57 AM, SeongJae Park wrote:
> > On Tue, 10 Mar 2026 16:24:17 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> It is more elegant to have a generic version of new context creation
> >> which receives the mode as a parameter.
> >>
> >> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
> >> ---
> >>  mm/damon/lru_sort.c       | 5 +++--
> >>  mm/damon/modules-common.c | 6 +++---
> >>  mm/damon/modules-common.h | 4 ++--
> >>  mm/damon/reclaim.c        | 5 +++--
> >>  4 files changed, 11 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> >> index 7bc5c0b2aea3..143ee0b21da6 100644
> >> --- a/mm/damon/lru_sort.c
> >> +++ b/mm/damon/lru_sort.c
> >> @@ -287,7 +287,8 @@ static int damon_lru_sort_apply_parameters(void)
> >>  	unsigned int hot_thres, cold_thres;
> >>  	int err;
> >>  
> >> -	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
> >> +	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
> >> +				DAMON_OPS_PADDR);
> > 
> > I like the name of the function is becoming shorter.  But I'm not happy with
> > the fact the resulting calling code becomes longer.
> > 
> > I understand you are doing this extension because you want a version of the
> > function for vaddr.  What about introducing another dedicated function, say,
> > damon_modules_new_vaddr_ctx_target() ?
> > 
> > And you can avoid duplicates between damon_modules_new_{p,v}addr_ctx_target()
> > by implementing internal function, say, damon_modules_new_ctx_target() that
> > receives the damon_ops_id.  And damon_modules_new_{P,v}addr_ctx_target() will
> > just wrappers of damon_modules_new_ctx_target().
> 
> Sure, I will do it.

Thanks for accepting my suggestion.

> 
> Since this is some generic code not related to the module I am working on,
> maybe I can move this to a different patch set that we can upstream. What do
> you think?

Please feel free to do so :)


Thanks,
SJ

[...]

