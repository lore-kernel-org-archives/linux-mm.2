Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C474C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA876B00DF; Fri, 18 Sep 2026 20:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B816B00E0; Fri, 18 Sep 2026 20:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A5B6B00E1; Fri, 18 Sep 2026 20:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 083666B00DF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:52:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FE6B12015D
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:52:32 +0000 (UTC)
X-FDA: 85228686144.19.4DADB39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 035C4120009
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:52:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jeUIT/4J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789779151;
	b=C9JyYRr6LL3DEczZOMEuJdB4iaiuIJEJdeu0RWZ8MyP0DMKWYLAwODpKB5Cnwgd1yRCOR3
	mVGGIjt6Uy7hKk3Mmw36z2JxmioLdrW032VnF/82S9K2CH4l+FSeyD5LNbUlp+IYsLfFaq
	CVbqOwnL5IUBb1V47powuypvx2zT5nk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jeUIT/4J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789779151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yocJRt7INhO2SPE/6i4fgtj/1ihi0f5vXImYQPJs+tc=;
	b=iTAIlhFldOegBCOqZPVb+P54bCovdlj81BxEyHbiTvEENvOfQpvVn0YiQKZG4fBzEsRuor
	Dr5fRYSvksZH7fsf8UqpmUX7QpxY/TnHLzjvB0ANB3TUANn+KA3CAhKEnpSVXlGyAiQpWq
	vcNBv0jZJzI8LKXDz8NQXFNmoZ4P+H8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F2606053B;
	Sat, 19 Sep 2026 00:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705A61F000FF;
	Sat, 19 Sep 2026 00:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779150;
	bh=yocJRt7INhO2SPE/6i4fgtj/1ihi0f5vXImYQPJs+tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeUIT/4JFcSEPoeuIbj2DApYpMR02vDomhp/WtVEMSTocITkL5yMMY3aFGcjxezv7
	 eC6th4RUAaadB/FhlAu8L9oXOgBMSNwQXQ0/7TqS1xhy22JIh1FDVP3vlVkXZNHeva
	 ppinlv2k0VfgkdY5LZbLyNHTGvnLLNDiQBpoNrJpgZIkveI9W2KFEoL6G3U8mgb9m8
	 s8konpYazp3rpN7UAMtyHkF19/iFvlGYw3ZVFJQMIJJ8PjEoD/CWm8dFkRjUkmmVOI
	 PIKA4oVOB1P+NmYaZ/NfOXba/awbP8r2Vu7v1qXa7drQh0qgSpwFAaHOEqS1t1W8Fv
	 RMzC0mSj67wDg==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: make Gregory a co-maintainer of MEMORY MANAGEMENT - NUMA PLACEMENT
Date: Fri, 18 Sep 2026 17:52:21 -0700
Message-ID: <20260919005222.87342-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 035C4120009
X-Stat-Signature: n8c4yx8z5hfo9p7ry7paocdbdcjjdos6
X-HE-Tag: 1789779150-427487
X-HE-Meta: U2FsdGVkX1/nqCcWDtQmc+34XBLGGCPCNcLyDbodUCAUe6B6tGHA2+sfsY6qeaCoYPARnYolO29SzSmETZsr0vPOcNvoVzsIVXKLQgdSQJZW0zfY26OZXef5j07ewpVckeriHOVmqlNHdEUC10RxME0GQ4yAonqFUXcp0mEViIu+MjRHsTVSnDndC97o5R17Dv2ZDI/IGNL3rAYRH/Ca9ETtzfIdFa9atge7QTl8yFVU1FhRTHrQRCSNekYBqVwNd5yXsqnPVqMSxtGVJWsx5UUGMnL8eRKQTmQbgI1t1ZhOp1DZcMnb19F6J9Yv5SlR4uyXXOFW85BEIW9zbmtosY025bF+MjzumNcamf8kAikxsys095EuyjAJ+XTGUV1rbME8/nLtVqt0A4GIBdheEMoZbDSI++akfixuKhujvkXnmmZQVfwV0hqdDulqVtRiJe2mPeN/PmKHWE6otiITg2bY3afWmyNpAO5X+C/cwROyocS0H3t6q+p9fFomwVUP2nswy7n3AQ8QzfWc1r+6JDT1W0ehKXltwNt4EuNA1cNFKgACVk6fw47qbvYTgxZ28HTtLarUmf7a7JtmbY/AZul2jfF+5k0QT+k/tSePshiNDy1hh0KsPlSq375I+h5l4j+HqPNyiA8+aFO1SPHN3MCx2C1artbNtwVt2dcEd4JsiQySaxNcL2Pwz/KQQglTU7e/W8zVMJo6mlDxb4ecsCR8zXfZOXGLafkBzmJSkDstmm05zxlDe+J74b62Rah3+9MAXAXszpnRKDA4iJHxsWxjf7Z1/xlYHK1nJTpk56DXaYyIxdOM9+PeLKmDxeq8Y0ksMAZCG/hckvgd0h3bNpdiWH2MxkVHElSgVnHnMjEUbcqimeL1+zTaQanpoOylEo4qKDwjQuwd7lTgFKrTNvNOIfyZjncD38npp1o2jbYVPDe4eQktMryiJKuq0EqHaj8VyBprv+CI99AdMgV
 7bPc9HL1
 W5dYF+XCcGNbFNwuN2CWalNvVfYmIYS8NBP+osjhn2jFEV68hyvfKJsQMZImG3k/qQ/Pd+sXCwbuC4E8Je1bwSi4Vh9v4v+Uk1uKx/Urw3jBSpf1dGG1X7HImkXopmTAso45ifKBtJcqVCrnRfFblG9WrDmT6Ln2IsZ/aUsuK39A6KpHs/bJLhCSdRUo9Rlgz350sDTldCYW8GoPc4hfW5f0vSef8jvHEam8IA6kO5IPP0TqpM5Ly8vEym71iZ7JLUmiqQReRN1nbS7ppwP1DLCppKbX835LlSJaSahL64O/HN+bAeIQ4YAReAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 18:34:26 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Gregory is extremely familiar with NUMA placement handling and volunteer
> to help co-maintain the numa placement bits. So add him as a
> co-maintainer.

Thank you for volunteering and huge congrats, Gregory!

> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

