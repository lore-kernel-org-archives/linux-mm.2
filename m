Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D3F8606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y7NMm/hy
Received: by kanga.kvack.org (Postfix)
	id C3E7A6B00EF; Sun,  1 Nov 2026 21:49:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16386B05B1; Sun,  1 Nov 2026 21:49:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53A56B05B2; Sun,  1 Nov 2026 21:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9810D6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:49:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78119160B68
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:49:37 +0000 (UTC)
X-FDA: 85388648394.24.B40EEB8
Received: from mta1.migadu.com (out-105.mta1.migadu.com [95.215.58.105])
	by imf18.hostedemail.com (Postfix) with ESMTP id 18E0D1C0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:49:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y7NMm/hy";
	spf=pass (imf18.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.105 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793587774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K2Pl66GiCtSnRt14sAo6wYdJhq6b9lHCX2PYrIZzXQc=;
	b=Fe0fjOQ+Md226DdPVThdjGd/FM48MrLb9f97sdu6H+Qgntv/npir8Zn7gR3VBfDmR2eoMP
	XiWWGZ9FZLehsV5kaThhLEO/IbHdJJkklGwm0iNSBqdlVFe+5Y22dYQDz0XXUfXAJfxVPd
	cmBPox9B1jk6MKPdTi6A6B2GDC7Fqfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793587774;
	b=7eifbXrU4eugCC4u4MBaWnStEqGFe0UqJb+r2sxeDzYA6DdRLuhAaSLAMHzW8hzqe9SWCQ
	Cta5QFv7eSMnhA8XIoLpoNSsZ4eRA2j6bPNFkPlU83KqBrtjocnBIwZF77sCqN2b7EuMzm
	K/UPEGeHTRDMdxNvFOo2vRYqo/Z4V0Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y7NMm/hy";
	spf=pass (imf18.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.105 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iz3xRoZLABnzuJqgORKF3hs5vSDtn7j2yh2I+RtFt4k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793587772; v=1; x=1794192572;
 b=Y7NMm/hy6+FZSncn4IkWDmJKlBOJCTZruBIb9D5QQKe3qNhZwkkYwzfjAJnZfT/VIpnvXClF
 Efda/uTm5JGWk1GKAvG3oK0pon11f5l2ni1rEO48LiKR/+XXOwRzv7vJ6Qj1wwKCjx9bZaBGJpA
 c1A6HCkXed0az8kA2oukQ7MA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 544bc17d499f049c;
	Mon, 02 Nov 2026 02:49:32 +0000
X-Mizu-Trace-ID: 544bc17d499f049c
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <kaitao.cheng@linux.dev>
Subject: [PATCH v2 0/3] mm/hugetlb: Fix CMA parsing, flags and usage accounting
Date: Mon,  2 Nov 2026 10:49:07 +0800
Message-ID: <20261102024910.31486-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 18E0D1C0002
X-Stat-Signature: pas7z6cbirkefkuyjc44u8a3xx1izycq
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793587773-478642
X-HE-Meta: U2FsdGVkX1/z60KiZty7QVE85zAp5aQ56ne9YbNjHlXJbhPAW6jNeqz/B3RLZ5tJvi+dyqskrc1Lxxf1DxBZ/+L6DcIY2XHh2wq2PVp/8Mi8ZueUeTkT9Sv/IAOzBT1sOTCihtO5mm7EJGXkc1NYd3jejiQkOSKoorZQ6AmVxXQjFHdxhnhOkFPS3W6X6In1r9G5QCv/W7Bn0x9QUgsksT+qjEB2Cw/lCN1/pTGFhKHC8HQalX6nRlLjWx8hx5DYWio1Jzllf5Tka6Hujfl8aCOREpSMVg7Q5Ojhm3i3nwsf/x+jgeuQ4bhK+5lVO4raytY1ByA33H4bR2xP6HLi7/bq82lZ65+d9FUAktgjOPo8+tDZ/YN/s+nz15y3mqrWCyKTsFIxce14Etx+diZun4acRbe+StkoAG6V3cEhSlV0lmwCjy64U2NSo+WjaDf8alfT3uxnWegsOCix39m71707oxhFcHD04mV6RDb30Q1nLkd2cjZLewEP5tdJGB7OipQ+Ya462lIuNxttewAUdk1OIvKEa2e7jZmWRIc2BqhChqzb31pq7Zjxp/Be1XsjGiLfbiuZwweVSRTQwf9H8tkmsrxYN+3wlQEu4Hk0IIBthO8ud2eEZrFXHH2/sgK11NwcZBkLDt2DmUUSxkcetU7MxuRymyM/la0FwV912zYDfD0sLrlUNnXF0oYyPQbP8mfQverK5d2zDRrJ3nCkrvR1CWf0iDZY3JV4B1P/LHfKjVaJezqAQoop5ZrJECwNavt9pdbM6CcjHDZfJWANIgnZmDEdt8i2+5QMLMCe4vYR6b+CT+SjDAVfiiTapH3k8WImOzHg2f+On9X5BfyvhgeQdE/+zuhrmONoV89mkuHc3Jpnr/1TxwMwpYU0+wkOMSL84iQwI0b1Rfw1hbC8DArBnUaSwW3rDIqmKPLLegVrbq8qDPY8KY5L9eMCYpOqxGdvhl79J/+hVYaGE9A
 I0bt8IfG
 +pl9dn+5JWES4gU8ce5wtgIB6a+tDGj/wdHHi+S+AYCQg3tZU0ovZKpkSpW8uIi0VYie9jsH4cbgWCzSJ/7r4TU7GNiN2+aZ/3RmltN6sCrPMVAW6PjDn3RPLQSW5/Z3O1gYMactl8/I6FsM1ZnM/6hO7YwEqy3vDkLwYHEfFxNk+Bik/bFrjbibarnZqNBhrCM7yvL4s3UHm51WWSd5I+8nvpw9nVZJGiHcVk4ehG5XaKJemOh/5rhPBgjhVuUTmz/RxLPkiT4xDyMm6RZkwYBCaGT9hxV5+qXJzq62p/uk3IR1ppyUSApBRcOFx4eg8DJnNhzwMgMg5A4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series fixes three independent HugeTLB issues reported by Sashiko,
covering CMA parameter parsing, persistent folio flags, and NR_HUGETLB
accounting on allocation rollback.

Patch 1 rejects a global hugetlb_cma size following node-specific entries.
This prevents malformed input from overwriting valid per-node reservations
with an incorrectly parsed global size.

Patch 2 preserves persistent folio flags when a failed vmemmap restore
returns a folio to the pool. This retains CMA allocation tracking and
raw hardware poison information, while ensuring transient flags are
cleared before returning the folio.

Patch 3 moves NR_HUGETLB node accounting to the underlying folio state
transitions and separates it from memcg statistics. This keeps the
counter balanced when surplus folios are freed during reservation
gathering or after a failed overcommit recheck.


Changes in v2:
- Patch 2: Preserve persistent flags, clear transient flags, and warn
  about unexpected flags.
- Patch 3: Account at folio state transitions and separate node and
  memcg statistics.

Link to v1:
https://lore.kernel.org/all/20261028113319.38544-1-kaitao.cheng@linux.dev/

Kaitao Cheng (3):
  mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed
    input
  mm/hugetlb: Preserve persistent flags when returning folios to the
    pool
  mm/hugetlb: Fix NR_HUGETLB accounting for surplus folios

 mm/hugetlb.c     | 52 +++++++++++++++++++++++++++++++-----------------
 mm/hugetlb_cma.c |  3 +++
 mm/memcontrol.c  |  6 +-----
 3 files changed, 38 insertions(+), 23 deletions(-)

-- 
2.54.0 (Apple Git-157)


