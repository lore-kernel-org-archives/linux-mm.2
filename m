Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D2A41077612
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9BA6B031A; Wed, 18 Mar 2026 16:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91D76B031C; Wed, 18 Mar 2026 16:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7A56B031D; Wed, 18 Mar 2026 16:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBDF16B031A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:40:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79B5B1C141
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:01 +0000 (UTC)
X-FDA: 84560350602.25.5643016
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0B82D4000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:39:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QVHEw6t9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AFPIISIY5h/6HIyWlqz0/Mg6XEgtd3F9fg4vdvBLUNk=;
	b=Ps285buFgsZ7jsqisScfcGfmBPwwcpp7cVOgniD3gjOVGe7Q7vQdbGGJ9oTYs4mBIKcXp+
	AsPeHoM+4juG2YLWMt94TCwStstM6t+Xand6ZUgIlxsP/7XTKbDdogMjdQ27sjAgwe9cHW
	KJCQAqcQWwo8OCA9yarVn/VWN7w+pX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866400; a=rsa-sha256;
	cv=none;
	b=NxYDohpCHOfUmVZgXvvY8gKQfTD7PvAAs5jJo20d0O1pzq4xuFRKLZ3e+RLys6hGg8H0nd
	N9JhyQ1YaiC+opuhynFJ4Qsbj07P+n211lMyU2hA7cjxNxKVh23F07t3cs0AjjupmH/icO
	Epunl5G2o/cvID1FvZ+1SqYTNtktN28=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QVHEw6t9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6342060103;
	Wed, 18 Mar 2026 20:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C848C19421;
	Wed, 18 Mar 2026 20:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866399;
	bh=pYIzPtSNloAItmJiIn0iH8Q4EDjnMU64MDsdWgcCmmo=;
	h=From:To:Cc:Subject:Date:From;
	b=QVHEw6t96bKEDLTYzSSy8Fsu+Zo+ksc/uUSRKP3j8a5tnS9RLaR2k8R2Q/8/mbIRN
	 TvobnKtOSi7C1hhRDLLQN0KnLOTBG5fUDtVKq2YAfLCCCd7b9SgSKRHtfKl/M7SCJw
	 dYciXiyC5sv8otBNkyBXgS2KmcD84HAllJgMMuY9YxIEFdR4R0+cLH/MX5HbFVZ2QI
	 7E2qQ4auT7iSMMVsCswvtH7olv/QZ9hx+AbJo3qaUGUQJmhooh5N/wHIDJQLqpmQBo
	 uVGpBLQ1D1AQ2lmzBjxrnPKpE0vh94W8Rm2hjOLOz/4V+JX5kFHrggH+M+lI2m92Ze
	 CfjbZ9uVDd3/A==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] mm/huge_memory: refactor zap_huge_pmd()
Date: Wed, 18 Mar 2026 20:39:22 +0000
Message-ID: <cover.1773865827.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B82D4000C
X-Stat-Signature: ooqa63wdbczgy18pryiot7uyy66su3aj
X-Rspam-User: 
X-HE-Tag: 1773866399-257254
X-HE-Meta: U2FsdGVkX181kihEtWOz3AB4/sFuEIAj1WbwT6k1ktUk2CaQ+oJ/NDQeSBaGniCy4F+5u1GiyGI7DV3E4SC+rLh94p1oYjReo/mGUV8ijwREF4goLpiy39DwXARJBOQqyu1qC8lmWm9/OCrUTvMtHiAU9RP/nzrXBvMoBnaR3++MqwEqNisaOyLkUjc9Yb5o2ygvNwudzhf5qcNdPKfEUorMDSf1KPQ3x7gkNRmOaHZQjDTFNWOdh3kpmoefdc06s5GKZYNueWK7pefbcMWhDmS97Bhnk3eeECmFuGYZX0S4w5i5enFS9MQfubia7NNs4s58dX4NNEIqsdKfAKYNWdN9f+jQ7OFfZ/fjAyfDvs75Oj2uF8ioFT68BhZ0X40+2NYMTH2N46drV/rHBGT0/N+zUU/pxffJMqE1BpE/4iCKp+kIsRk1+EsrIaoCSNktXfDaiHh8syeT88VzgsWvoeP/Baug8TAkrvQOyKSHdKags9O5gvotQGAovggAE2q9oHlypIkn+U68OWdF2QLxEMl81upbhR5lOA7ND3oiT5yodDcl68Zn4mW6pS2bAAgVIQg/myGlVwZKzmPTxP9VOtZMuG17GHRFydyGw+AlfBXnGi6rT8x0xf+83Xh7QpoboTBw6T91DFQ4fPZ7nxK7quWrH71vz2KVQqQChCb4K5wIJc/7lRepHvORkQPDmAsbGzgqQh5Bbe5gkxht5GEiRG/YCmqqgz3fYsTmZeNuGB08H2SufxFXzY/hc/ddYEYsKDj102fZWJs4H7bPGOVi1KbQyTsJAqT/a/GcQMgAT7X+K2d8DYLoWM0Ov4b213KbBECgFAp4rMRkKBjHu3m4jr6NvY6X9PwK+7N9623JbjQ+w1xb6or044yxBy1mtM5vVwl02/Sgacm6xuCD+JvE2omdzz2OKxCv0fgZxcHkzpMq7MowMikl5TSA4PCBre/feBmSDpENe3Dt5ecSNR0
 FNBSksbI
 eJV8rGtvHkBPGj5uMDvxFPjeoyawl400JGA0iC5T4+aREzvicuquBs2gE7pwUi/EihG1Q2DmNxG9L9NvO7tvjS+fVK99R1otNT/uHEi1S4awRh6gP7Qw9R02OFVshj8nVT1FSYIl/qy1LHBlHUqLKi/yK2vxPJYOmiAUy8mMH6rB9GUEUSGY/T4S/zaRehXVkI0KXzgTknyhfcwHUYmIIgIHSTk7ptCKT1LppCQc7KbKpeeAStZxPYrR6tAZgLpNM7qPyXJ08jNuDlSXfCf5T7UKNcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zap_huge_pmd() function is overly complicated, clean it up and also add
an assert in the case that we encounter a buggy PMD entry that doesn't
match expectations.

This is motivated by a bug discovered [0] where the PMD entry was none of:

- A non-DAX, PFN or mixed map.
- The huge zero folio
- A present PMD entry
- A softleaf entry

In zap_huge_pmd(), but due to the bug we manged to reach this code.

It is useful to explicitly call this out rather than have an arbitrary NULL
pointer dereference happen, which also improves understanding of what's
going on.

[0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/

Lorenzo Stoakes (Oracle) (8):
  mm/huge_memory: simplify vma_is_specal_huge()
  mm/huge: avoid big else branch in zap_huge_pmd()
  mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
  mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
  mm/huge_memory: add a common exit path to zap_huge_pmd()
  mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
  mm/huge_memory: deduplicate zap deposited table call
  mm/huge_memory: deduplicate zap_huge_pmd() further by tracking state

 include/linux/huge_mm.h |   8 +--
 include/linux/mm.h      |  16 -----
 mm/huge_memory.c        | 145 +++++++++++++++++++++++-----------------
 3 files changed, 89 insertions(+), 80 deletions(-)

--
2.53.0

