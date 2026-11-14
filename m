Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D808606A333
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jGQNHSLJ
Received: by kanga.kvack.org (Postfix)
	id E741B6B00EF; Sat, 14 Nov 2026 12:42:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B216B05B6; Sat, 14 Nov 2026 12:42:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60BB6B05B9; Sat, 14 Nov 2026 12:42:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B720E6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:42:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E7321403F7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:42:41 +0000 (UTC)
X-FDA: 85434444522.30.22BA70F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AECAF16000B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:42:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGQNHSLJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794678159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqa0FzeWxF+NdVIavyzYQpx7SrVw5PS23jn8ZooNPKo=;
	b=8azWhIT6fku32/h3dLoU34dMBgfwiyqX6PiPiTBirMCPi4ZCaH2mA+bPjD5bN38PonsoLN
	ZCglO1diF5F/ATm4eobiucMfVea2MJpG9r/Ql/PCyPHzem++124KzEiBj4shpIFPbWLWXN
	cHrVYRCPquCJ76f3+T1M7s7yJOicYKU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGQNHSLJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794678159;
	b=MuQwqsZDel5wTyZ0+V1wjvC/h8y8s554YJolt5T5AqFwS6D4GyxcaT/F5AgeyQ0H1+4z9p
	zWwXwzPVAvAkKuoskIk6151ViFCiXI5QMdnV71fm5zpZTED0t7vFFB+rqX9Wi0FlnG+eN1
	1lcpdnXGPclQnfNP31DrU5vKoA1Asp4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E926C46271;
	Sat, 14 Nov 2026 17:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43381F000C5;
	Sat, 14 Nov 2026 17:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794678158;
	bh=gqa0FzeWxF+NdVIavyzYQpx7SrVw5PS23jn8ZooNPKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGQNHSLJaRMpNWaKocOb5kVC1u8T6ym5tspwQCNo28G8KEHUB0n+aWcXjBr/AAsvC
	 b6XmShoXN0W7vdh2RQ48t8St2Lt9hfRfa59KmbMo1dfPsBFt8ZZMKAdpXfi14186sj
	 MPwCRI8MViVbDQY4mc/ZbRbTv09loMvCd0GPh6PH3bvQAc0ZekrECsHw/VTfdWizCq
	 CFP75JSOGM7L8zCGtidO+1vz2Lt9em12PIE2im7h4CkpT2+sNwlYla6G1CjketcsG3
	 Fio09EVTMRbJn0zG9342FQtwikFjc9ymAX02BhIujq+ilEF7U+c/P2v2D3zv93g6gB
	 NgPgGU21JZY9g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	dipietro.salvatore@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Salvatore Dipietro <dipiets@amazon.it>
Subject: Re: [PATCH 6.18.y 0/3] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Sat, 14 Nov 2026 12:42:22 -0500
Message-ID: <draft-agent5-0011-re-page-alloc-iomap-618@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261113110259.2901456-1-dipiets@amazon.it>
References: <20261113110259.2901456-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AECAF16000B
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ouxq88atnrq46o1drjaxqqx5664zstic
X-HE-Tag: 1794678159-713722
X-HE-Meta: U2FsdGVkX1/x+wP71QyQQUGXeUHaW5lT6vq/rlj+dD+ScRz6Ygi1yLQhCnHd0Boxvx+x3IowKfrD2rsrlhm5Yei5y3tKSHrYjIcG69yKQ9qASnhToVwFRxbISdWhhZD5cpy9R//39NHIRqk/PBtL0CdHJu64qyjizShfrGw3IPBUiyedRZw4Y+nCXD++d/dX8Y3koRzuA5EConcYEPvH0T+BYVcZFuvrFBW/Bq5icbs9lp2Hhd00VKAXGmh2BV0D7JcoBKeaq3mKwHiARN89x5BCuXLubYwtPHJaqsl60/Hl2AWVjQUHLek3ocS71Cql6uGRp4GOL/8uBj83+FdJjiR4RsUzgUxoCwFk/IdsF7EHT1xtryOq7jnfCTEveyZtO6FkrmI8v2uJVisgVN4UujtSYieSenjODcs+Mdlp46KRSf/BwnUAZyTn0YWT8v6uj5rpod1eam1vsDs5Ya0wPw19gNPljuFP4rkhtZPrH3V37DrYfOLo/n095me/y1P3V+sOwe/6A9hjk+HM8+treunjj+4ddFbUIqSs5teLCGFV73KqsAika+lcP5aIlZ6Xcgu2Ns54JaVkUl6SJJIh9FqWRCZGvSJiWtEti2yVg6AIsDsOo9MpC0kXO2G0kqMsEod9Xoby/r1YK4k/7qgzevN07Kj/XtRwLQdlJaTdg6gen4jtajJ2F01d6UvwqLleDyorTzpZbucy3yeoI4j+c3J5kMm2IepJg7odc+cQp2sZjvF6MPRTsfyBR4W6pw3KswPafHh0/FuxnITFSVEs5nXg85IKiRifeZYtzEkLttI74ZayQBsO21Je/xHKAX+uS6rjQn5c9UDLpg5QC2lyqURTyX2JBRrwt86aF5bmydXUh1kIiq7O76ZKjfbIHAgBCmVLRVY5Y3dwZ2YUREJ74ptlJnKiSXUQJ4Hed42WaZ/Aox0wksXwA41jaWjXiYwwgfBVtwwyCBU/8eqc00h
 lwRyN7+f
 bejIbWTBgwTRUEZOPCVbBMx5wegu42NaiAJK1KtVTa66vRiA8XmIYgEo900AZTr5WdOaIeZsHGM8bBlRIXjubJ4+31ZFT0P33IzgL00G1tucam1MI1ta/u6Dy3bbicJiXT//ROlrsjOqbQ88jNwNZ8tX71ZkG4pQAH/fHxaRbiHBs7Z8VzGlSH16YFHSyLyTmksFdfhWVbe2VFiA91OyuS6kOWuQ9juV/k5mDGpWRWX8cHBieQs4ezmP2q2PMeCnomab72geMX8rUu3BqYqoJhNnfw5lNDdcdqDhvP36ZKRrw8yriA4jgmYlFm3JXYcuOo4ip8ib8U7SZPb1HjOniihpYkxAlMghz2Ly/il6SXpl3FTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13, Salvatore Dipietro <dipiets@amazon.it> wrote:
> Patches 1-2 are its prerequisites from the same mainline merge (Cc:
> stable), only moved from mm/page_alloc.h to mm/internal.h.

6ee3d87b9408 ("mm: page_alloc: do not give all non-blocking requests reserve
access") is now queued for 6.18, 6.12, 6.6, 6.1 and 5.15 from a separate
backport, so you can leave it out. A v2 only needs fe21f930d1e6 ("mm:
page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES") and 0e05a469c294
("mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY
allocations"), with your Signed-off-by on both.

-- 
Thanks,
Sasha

