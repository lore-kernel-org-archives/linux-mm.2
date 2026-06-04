Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343BACD6E60
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 01:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934766B0088; Wed,  3 Jun 2026 21:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5776B008A; Wed,  3 Jun 2026 21:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB696B008C; Wed,  3 Jun 2026 21:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7C96B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:47:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F25608DB91
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:47:10 +0000 (UTC)
X-FDA: 84840542220.26.7BF92B8
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf05.hostedemail.com (Postfix) with ESMTP id DFC93100011
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:47:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Kky2CKkp;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780537629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmYRbsUzzfhOIZDdazuLRX22nS9Q9OoZqwgs/MwD5ew=;
	b=BwgPR/2aQM/T9+hmmIdc4W31Xf5tmFYegecIX0w37FwNL6zONzZKRwXjNaIgpwi9HgYOth
	WsTRbTBCnUZBvXeBKXpn9HBBxIjQ3nyTpeLoAopaNYhEzdH8wZnkq9QcADkG+WObR8qV40
	vHNRqSqVrc9IiewsTcfxe2dhfRS6X+8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Kky2CKkp;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780537629;
	b=L9nVM+fw9zcBtRDMstvZ354C98Toj6vUKsXu5g9tWCGSCgM7O6wpRqLfT3Yg/q0XEmB5cM
	trbriqTdNLxXk8Sv1v8V8UNGw5v6oT6UFsMdIrC94wUy1+OL5PfvAXKxc/F3sZWxlkcg1H
	XWEmwDJ0o659yJaW8efSa4lJTph1hKs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nmYRbsUzzfhOIZDdazuLRX22nS9Q9OoZqwgs/MwD5ew=;
	b=Kky2CKkpIKkIiFLgQmPPwG7cQe9UxaNb9i28B0sWpbx3oZWP6hOOmLKmRDFBYu8rxmAKFPEAx
	OCX94y2KYER4lXeDL3X/ArevaOfVzOkM15HGN9zuCUvh4rHUJ7Uo8N7pc0q0AnLm46X8tMZ2zKX
	nWBkayu36w+2WkIMe+YQBLI=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gW6g30YpnznTVh;
	Thu,  4 Jun 2026 09:39:11 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id C2E4840539;
	Thu,  4 Jun 2026 09:47:03 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 4 Jun 2026 09:47:03 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@kernel.org>, <qiuxu.zhuo@intel.com>, <bp@alien8.de>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <linmiaohe@huawei.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
	<mchehab+huawei@kernel.org>, <tony.luck@intel.com>,
	<torvalds@linux-foundation.org>, <xieyuanbin1@huawei.com>,
	<yi1.lai@intel.com>
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
Date: Thu, 4 Jun 2026 09:46:29 +0800
Message-ID: <20260604014629.3144-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
References: <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFC93100011
X-Stat-Signature: 1w1fucgao9ijk7ja59rgq7nxz9ffxiej
X-HE-Tag: 1780537627-121687
X-HE-Meta: U2FsdGVkX19kl+YgFDA+BOFiHl2q0A9e23mab6bHnjXzB864d+rCilLJd0uHo1w5a6msgbKunYu4nReC6X8UgqdbCqPHM5E3TBc0yBaCoPAILAaLR84kfnJAQfG+JulxLHt4OWPx5XAqkPNe/U4YekVY43dOQNmeRFNa76NtNYMvB48XIb2ZoBwAdI6SBeTDKMrpcWHRN7VzY5BcS3sWtKrsDU5sa9eZE7paDXA6GhgUy0m5aEJIxPwgLNOEEaog8WE1Ykr5LbKv09M7NP8NXiD7sAUYx4viOQKHtph0g5/zjmcR+cWZ5tWjjXiaL3MedkHtp4zRtU+ddPAc8Ebpg+swt8kXS5EUDi+wLUWhWYjkxRYb2Kwp+0VUC5U0KhQgm+ByI6JO8B8/GgBGOz4UNS9m5aVsYNhUMaN4PoheB53iWPp2Y24bnuH6KS6PW93Cav/BVN6S+qp+P851vN0s88mZo7G7LKGd+8eLUYou1wOlxoyTYRpTKdiaH+KgDNTDJ2nrhlifwe4RG844FrDpXbPoKgY3yokVUf7iAbcp0d33OynNzSlDalZ5Y2zGLnVMc1yygVj9JIA0NUMGJG6dq+YeblIJj672PtXwbr71HQIcHTkLp+w+oFvOgbUmtBNh5gBn5cuYxy+mm98AStybPjJcXvpEjfG7ma0n95+JOvDCnDDM6YJi0jiRldxgn+h+4GiKy7U8maMz1SbCqd9OSWzpp6kRolj3+FLJWabl2PNbfw/QUV5v9e8aELHMriGrtzw73YxufMs41Ip8TdQtV1sv3hQk0FvtV/aUzUENsGhs0YFqX/MpE/0WaWzDYwdfqex35A1dz3LX5A5SB8f8dbV5UiQhiQ3YZKM0FT3+sQMwG61fd7bA0A80edhuYnEfA1z9kOlTMVLItVKb5yNei4aSs/acxKUbDt/V/vy28/z3Tv+MGVrA90GtsoOI0jmaWAfLrLYU/EYhCFOL20P
 jTHQPsID
 4cQexaV6/rBOX/Rj8Dqz7hs5sx/q/vHBkshn/mgB3EtVASMZXFtWMt0afGR3mmWfoX8Gbz/1orQFzeyP0Y8f54emt2vfphbjIOhtJ77hNQvk2Oa+dvhWRQQ3E708jvtLdSPRVoWm4f+BFSXQxGSLpLlt/M2u1dd5OPCbTWd48cUwSixxBxk5Ef189ELFiyhlaRvvss+822jVFDDj/dkL6++r1jhmi9bVNhGGcNYzItYMhfSmvLh9zI+zJjoK0CG9ypgFEGCbSC6ihoOsXxyyZCO/wmfDnVIFgjo1R5MdrrcrwkPsE587jPcUQWq56T6gLvENrQkckvjJ0SnBSQyDcY34He0cyF7t3slIzxrKA4eU06g6l/IIwHOIk22kXqTI7b4HcU0b8KXnkghZ89ZxyvOt4dtcOBKgdES3t4PjQwPz0o/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 21:13:30 +0200, David Hildenbrand (Arm) wrote:
> Would the following be sufficient to avoid a full revert and the dependency on CONFIG_RAS?
>
> diff --git a/include/trace/events/memory-failure.h b/include/trace/events/memory-failure.h
> index aa57cc8f896b..c46b17602578 100644
> --- a/include/trace/events/memory-failure.h
> +++ b/include/trace/events/memory-failure.h
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #undef TRACE_SYSTEM
> -#define TRACE_SYSTEM memory_failure
> +/* Some user space relies on ras/memory_failure_event */
> +#define TRACE_SYSTEM ras
>  #define TRACE_INCLUDE_FILE memory-failure
>
>  #if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)

Yes, it should be. In fact, when I sent the V2 patch, I had already
considered this issue, and that's exactly what I did:
Link: https://lore.kernel.org/20251104072306.100738-3-xieyuanbin1@huawei.com

However, David Hildenbrand advised me at that time to completely
remove the dependence on RAS:
Link: https://lore.kernel.org/01b44e0f-ea2e-406f-9f65-b698b5504f42@kernel.org

