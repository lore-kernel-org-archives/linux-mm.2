Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E495606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dcYKIC6l
Received: by kanga.kvack.org (Postfix)
	id 5317A6B05B0; Wed, 28 Oct 2026 07:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1FA6B05B1; Wed, 28 Oct 2026 07:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7D86B05B3; Wed, 28 Oct 2026 07:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 171936B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:33:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 700A5140C1A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:33 +0000 (UTC)
X-FDA: 85371824706.28.59F328E
Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 794EB1A0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dcYKIC6l;
	spf=pass (imf19.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I8Qx+rwY6H3jQ6L89yvvvHh+9fiYuKQUWmXchJSlClg=;
	b=P2pN5SShNYcwKICYNloMA4zTw5+ivNl9sLaoH3YyMJKkJXgQdMIzJDPW7WqmkmKbHpkl57
	kNJsL7zQWPRbFCg1euQsm7OJsexkBN1OesrKfGsHxfc5cRmFpLxgeFQZtjOXdZM/sLT1Eu
	8OJohMywh5wba8457tg2xlCfuPPwBLg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187211;
	b=71Gi1iNz/R9NW4WebaMuzjbyj6DanD2O6XmDJByHqFKkUE0sWIvXiaGPtSjDMidBeSjLfp
	Mx3fYLFTRffdIZDVUuZcvDp4FwsvCMrVHGCiiNndiJW1v7qfOBpY/mV564S22yNie3NDmi
	sEaIGBRU21LHkzSCcwbECn9HubnJ2fY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dcYKIC6l;
	spf=pass (imf19.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uj6DpQ+dYHugok4ARQkYXSn+IV5soWPeKjdz94Jwpd0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793187209; v=1; x=1793792009;
 b=dcYKIC6lUcS1vobgg/rKKtcTKJh2je3fA4ESE5C9StvQp4g1Q5nDtijXXaa3vuKczCjMUXjK
 4nEfNccXRaZbNCV8gPRGC7Gj6CmDVYzgXNWnBLDZgEO8JyIvM+W4Trv9jMDPJPczdnN2H2OwMWR
 OMHD3l4lkrbm7KnTFyb4v6Yc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 33cbc6c67f81e8a8;
	Wed, 28 Oct 2026 11:33:29 +0000
X-Mizu-Trace-ID: 33cbc6c67f81e8a8
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Frank van der Linden <fvdl@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 0/3] Subject: mm/hugetlb: fix CMA handling and surplus allocation accounting
Date: Wed, 28 Oct 2026 19:33:16 +0800
Message-ID: <20261028113319.38544-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 794EB1A0002
X-Stat-Signature: uh4mg6no61t4pueffgfo3wr6bc7jyhsc
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793187211-314329
X-HE-Meta: U2FsdGVkX183U+tJ6iU7rs4LX9eU2B2hxaFaG7eSpHAnLUdTTzRfoer+qPCOl98fRxE76x+G0l6gzSwOfDZe1f/rlhPW/MnBchudB9GO276IOg1sVVeBYWokyPuZ06mbjfBB0JQibiC1gqiP30CHHrRg9sWSFNFSsYxcA0+oFw0bhie+DjJmGEpjITi7aZNrzEgvLEanvWdidntTxPP2Gtn2MWdzOzngDeFzp0cq6orUdEATzNwu9mAnX7qF7XVWhvhHLzJ75L7W0AycEjjTj+JpBns8YsZObR6JoJ5gVf88JPNm4ZlSGno/f2HAw2fmaGSsIekV4ogaJlvv+7AhssUhfu9zC15mHTjswM6zjPCAoawDh632/OkrzzRY5NIizxpZK3x2atQEczZdTYGsTIfTlGyinfcxEm8+8qTF61buyLPqxoolR3QDAX58UVzTOR00MaUIWT7kStlLGPYfoELa7blNJ6kWWk2YCr7PhsdqF5rp69/k3EYOivy84yXU+qsSpOBlXiIaCzeGA5SZJ7JeeB6qB0uCi/Gaoq6Cer0SKcC3s7zaXwpNfvMCHN5nW98hPJ+YLol9lFbFpQm1l6vUfVcDO3gXHpFgoALKTazpD1pPLy9Vyj+MtoqgoiQjwMTgkYh8xwtxGQ/nkKaFTJd/q16KZju2vA7ZB4cXzKTQiRvZN3t41du8qDIkTxghcmft/wmydzELo+pam3Yijpe7XNKPgonE6WQ6s06Ffm9dBbQxbsO5tWSDEljRuZX9R7WSZn5rxQjIahlmMPO5BCXi+RCzVOib8dE9dnFCWz6x7/3/r7bjGWhJXCCRFQhv5J/R1lGomev79s/b7YyJuwjSHwPgwc2gOcMmM9qgUr9qJemgLiTomDtMaZZNsjVhWSi4m9Gga2G4Uqaf0Bnlkl4j9GqkrV7PBIdN7sc+oohe1kdIWu4b6LkV80a0J3qq79Tx6FDC0Ii5j2LRZye
 CUlnTeh+
 82ubu2AcJB+RnjWfrEpn7XJaSnB5PBUYu4dOniSz287rpmNRb4NYwv0lQJCmablibgfOwAbqx7dpA8WWv0rrWzliqKWz/9M/0zDGrYeKBfkW9nppY3PkdT3vgRx7a6Cm7Itmrzx8vf0B7S2Pcl0BbShu51iMAZ0qkOPr8GIoJfupyD/ahaLGJ7cpv1Fmz+txEKRyrNz1CQN0lCzbTuh3YAwZQIo5kJjmDb3iSE/q9BLKVLWrEi4xDv3cROWGDMUEW063i64t2kKCD4eoswwQ6oH7SHhFx/LUWikvDOibNI0Bvx5weYeMKwcJ53g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

This series fixes three independent HugeTLB issues reported by Sashiko,
covering CMA parameter parsing, CMA allocation state preservation, and
NR_HUGETLB accounting on allocation rollback.

Patch 1 rejects a global hugetlb_cma size following node-specific entries.
This prevents malformed input from overwriting valid per-node reservations
with an incorrectly parsed global size.

Patch 2 preserves the CMA flag when a folio is returned to the HugeTLB
pool after vmemmap restoration fails. This ensures that a subsequent free
releases the CMA allocation correctly instead of leaving its bitmap set.

Patch 3 fixes NR_HUGETLB accounting when unused surplus folios are freed
during allocation or reservation cleanup.

Kaitao Cheng (3):
  mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed
    input
  mm/hugetlb: preserve CMA flag when returning folios to the pool
  mm/hugetlb: fix NR_HUGETLB accounting for unused surplus folios

 mm/hugetlb.c     | 13 +++++++++++--
 mm/hugetlb_cma.c |  3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

-- 
2.53.0


