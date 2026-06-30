Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEF4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2D036B00A6; Tue, 30 Jun 2026 15:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9F36B00A8; Tue, 30 Jun 2026 15:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEFDD6B00A9; Tue, 30 Jun 2026 15:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83B856B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:08:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18FEA1C71B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:49 +0000 (UTC)
X-FDA: 84937515978.06.8E2709A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4CD3F20012
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="cr8NiA/q";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846527;
	b=JdFDcwSgN49qN5l2KenDRk0+WY16BILoJpDBjQ1j9GuUJM3sg38fmfClGFXRoTzg121V1x
	grM6MyDkNSS8u+fkb1gqFBI1kHA+Nvh7KwoHNNDouGdaL4KmJt/prCd0baJBaz7jR4PRUj
	Cp9gGd/dZ6uogIY7Q991dybhFKhYrK8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WLDkhJ49sK0ZVXamzbGj7uDasVQ2fboJSMeGcLvAidA=;
	b=tMasLyCjYIJMRZEug+Dqi4b1MJYTHzMishbWxIbOrj+9v34BW8rCPv3bn9fzQlMoiQJ/Au
	Qs3eiWH7BAcUs+t1oUE0u8jcUrZWzdZT5z6t+yjhG62wHIPOC8BLNnA0Z+RNxut6egjsXY
	CNq6h+UiN0x3WbZvhga4MueRlyxM4OU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="cr8NiA/q";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WLDkhJ49sK0ZVXamzbGj7uDasVQ2fboJSMeGcLvAidA=; b=cr8NiA/qj6FaBnYxrTA7ZR0NsB
	czLlkZ4R34VoBDPrtkXmnPcuYqk+50uyBgC3VDRLK4oXqE+gq8Uzix0lyiduqnN+alqr1++mrDCDk
	7R6KZaIkDCbjiLpzz1+ouZSYjf1XTHzxbyGVA+7N5Mp8pfmGfBBInhqp8L90b9hly4FHYkdZdXBxM
	umflLkQ5+dA8KX30hSqlaNEXiVuVvGC8or0j+i2PM6R0DQ6HaUcs9jYSobDNZ4rJ9AlGyFXxMaQpp
	UEHgaufoW5PLO4/HlRZEl4iM2V14GpbpVH8DD+cUvpe9Bg5Y9uMT+JKEDbJ4e+2cZybFtFnCfxkox
	SFkVHnKA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedp8-000000005nE-0bXT;
	Tue, 30 Jun 2026 19:08:46 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 00/19] maple_tree: lock checking and clean ups
Date: Tue, 30 Jun 2026 15:08:24 -0400
Message-ID: <20260630190843.3563858-1-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4CD3F20012
X-Stat-Signature: 3mmb5du3ptqu7qi4b5y8rx97mjhd8rsq
X-HE-Tag: 1782846527-857114
X-HE-Meta: U2FsdGVkX1/0NSel9xr13f2UUEIV189RCYzvaHPM5VvyN8T1u6F+B33ybCmqe7cwxEKFFHP1slsMPSjnSdn9SDP1ePNMtfVUxNg4Gk1Hd+r4IQkQGX7dufep0rnSD3ABuxE/tNgeqYyw4bRJ6vcsibS8arA1E3sKnD0Yc7sc1eb/bji/HTyuqNVg3J1Q2BXVUjaoJiMlQSbVfanTsKwymDmCP5+NbiIQzfMGgvNKG4jH2IDpgvXTjMMV2yuI0xFljt+aOLuNPViuP5jTfvrp3rOrAkugj7PAOOn1Qye8hMtOk13YzqnCm429yyems+TImT9i25tgiYp0uHhvpbaI2HA6pqr19L18j5d39UM/lfB0S+PheYpUYx05hUNBwkd8bvHP7tn1XV5h+tfwOANaKv78dpEz+EIZnc/XiT6MU6QAmOoD7tg+OaUHB+htKaWnGXz7s85okex7BTh/Eb2/sHQkWunQyivWPCW18TNwwL1J3KJDOxO+264duEXOJGkuL8hGBlCq739yrQK1+nwWhfaipHVIdSTNMVipHwJeawNSH18A5PQHcya0jkzYxerDQ5riCKVcnqsOnJlsPaWb3qqQA+OdrFCfhCFdVYODPpPgR8e5Ih2ThWS/mGSPEOC8oIAVGa9LjXpt98Dz8ZX+5LfDqPyz5Mab/6OUdzop3L1tXZy1Dr70ayDqdBsQkal5be+ZGH//1KrlX/L4rfH+GMliIW5LcoOqmxmE1gvz2D2vQf9Y9yhvvMr/otmHUCHaojZLQxeLaRNuBc6DUeORtBSI36Kj8Zttn2yE0YgRZx1qslkMAQxlcwjqfVQ2M3c0hSm+xAt0w9NpmVIgKBHqi0HvDO4OTuxOvvNY+UuZ5zkELPOWBcN/A5Sj5VrnE+MWW407trBh39pp6yh9Kmrxe46rue4s1l35Jg36YZo9K9B18JE5yGjYWogk4jxdxuZNymTArF6mjwKJAeNwrxf
 Stbo8OkL
 hc0cmSdWt0+q4CxYCNMj2Di1w+bGpxdYldnRKJnuxy0x3sZgYJN4IOlLY1be5ghj/44zr4BedvsHi8c3Zfi8vZh63o0hyo+ds4NQ5vLHgkwfBDKFy2WfIc0auf0exx1nsTR+HswPaWMXaFwqZZd1ADTIpnBBAeb3OOO+GzqcH2BqAs4rUt8ldLvZ4ogAlQLSClUCZlGICUDOO3ENvV1OTGDWdu+xLM+Lag2VyZWAoCm7VknRffRaHPXd1akD3evrdwpQoGkhMwiEFoNb9xC+WjHVWInvUOiGy2Jn4kPVK32dgjs5ICpAfL5/y3VUbhC79t6tZdp1htUwfofvTZAABgeVyMv9P92IsL3V4KnR0JRyB/ZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The goals of this series are:
1. Lock issue detection
  A number of syzbot reports are incorrectly pointing to the mm exit as
  a source of the locking error.  The first three patches attempt to
  help users detect errors in their locking - but they still have to use
  LOCKDEP.  I guess it's still down to hope and prayers.

2. Documentation fixes
  The documentation was lacking clarity, there are updates to try and
  help the users, especially around the erase() cases.

3. Two benign issues
  The cyclic allocator may have a race, although no in-kernel user can
  hit it.
  The erase functions may cause allocation issues if used with the
  incorrect locking type, but none are present in-tree.

Beyond these goals there are some test fixes, some general speed-up
patches targeting extra work and cycles, and dropping dead code.

v1: https://lore.kernel.org/all/20260629144145.1572283-1-liam@infradead.org/
Changes since v1:
 - Relocated mas_set_parent_slots() lower so that mt_slots_locked() for rcu dereferencing - Thanks kernel build bot
 - Made mas_lockdep_map() static - Thanks kernel build bot
 - Added mas_lock_check() to mas_may_activate() when restoring a node to active - Thanks sashiko
 - Changed mas_lock_check() aliasing to use mt_locked() - Thanks sashiko
 - Updated __lock_unpin_lock() underflow check - Thanks sashiko
 - Updated checking the lock sequence based on the lockdep map - Thanks sashiko
 - Add a comment to mas_wr_node_store() to explain why the last slot isn't cleared. - Thanks sashiko
 - Drop mas_set_parent() function as it is no longer used - Thanks sashiko
 - Clear the mas_alloc_cyclic() wrap flag after storage - Thanks sashiko
 - Add might_allocate() to the mtree_erase() call - Thanks Jason
 - Added one more cleanup for making maple state walkable.

Liam R. Howlett (Oracle) (19):
  maple_tree: Add rcu locking check when LOCKDEP is enabled
  locking/lockdep: Add sequence counter to held_lock
  maple_tree: Add write lock checking with lockdep sequence numbers
  maple_tree: Documentation fix
  maple_tree: Drop dead code from mas_extend_spanning_null()
  maple_tree: Drop MAPLE_ALLOC_SLOTS
  maple_tree: Clarify comments on mas_nomem()
  maple_tree: Use prefetched value in mas_wr_store_type()
  maple_tree: Optimise mas_wr_node_store() when not in rcu mode
  maple_tree: micro optimisation of mas_wr_store_type()
  maple_tree: Add bulk parent set helper
  maple_tree: Catch race in mas_alloc_cyclic()
  maple_tree: Document that erase may use GFP_KERNEL for allocations
  maple_tree: WARN_ON_ONCE when allocations fail
  maple_tree: Document erase and allocations better
  maple_tree: Change two GFP flags in tests
  maple_tree: Fix argument name in header
  maple_tree: Avoid extra gap calculation
  maple_tree: Add helper mas_make_walkable()

 Documentation/core-api/maple_tree.rst |  21 +-
 include/linux/lockdep.h               |   3 +
 include/linux/lockdep_types.h         |   3 +-
 include/linux/maple_tree.h            |  10 +-
 include/linux/sched.h                 |   1 +
 kernel/locking/lockdep.c              |  58 ++++-
 lib/maple_tree.c                      | 353 ++++++++++++++++++--------
 tools/testing/radix-tree/maple.c      |   4 +-
 8 files changed, 326 insertions(+), 127 deletions(-)

-- 
2.47.3


