Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8236FCD0A1
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 03:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E346A6B00DE; Tue, 17 Mar 2026 23:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE57D6B00DF; Tue, 17 Mar 2026 23:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB446B00E0; Tue, 17 Mar 2026 23:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDFEE6B00DE
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:54:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D47213ABE7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:54:05 +0000 (UTC)
X-FDA: 84557815650.09.4F7ABED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id AD05B1C0007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:54:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gCFRJ0rv;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773806043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xO7PmGHBtk4aKOpUcL+0XS3BMisSLh5n3+QPDF3uW08=;
	b=ypxnrfX388XhnPRRZiL5rC3UXzrdH9dnc5qn3D+vGtt5Vv6f6VxVoc6+rDp57+1BbXX6OX
	zoSrB6B5+BOw6no0VNkzgO6eKnzZuwPZA2Wv9K3CrDvb9r3o7mEaqsC3cdxRDakVw3H2JP
	8PuLq7D3pnIiwJMEtnGEtaeUa0fQLjM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773806043; a=rsa-sha256;
	cv=none;
	b=HR9GC31wiVzUrQLqX8F+f/mzO/Tl009CKeerqoLVGuOIdfak9FILJPcbC4NNIjjKFDvzGS
	qfYbeZ1xb385p6KGcTBDwL4/gBYeG3sCVp91JmbXicS7ggNTnoC3GZ1fKw5aho872tMOWE
	MLig/pZ2ToBsOTV68r9xgJhnsWg2IVE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gCFRJ0rv;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E9D7404CE;
	Wed, 18 Mar 2026 03:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DDCC19421;
	Wed, 18 Mar 2026 03:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773806042;
	bh=6CatznSLTNYV80vtabVt4rhKS2msE5JzlPGM+/AcAPM=;
	h=From:To:Cc:Subject:Date:From;
	b=gCFRJ0rvMNhZZOKla+65Id6mo9bEnsay0KZtgmg2nEc6VVIzC5cFtHevqyv52Rksi
	 r9ADgxA+jitpnSqdWc3Eli8zBEWQMZwPpp0gbyUi7+01NwJP71eBwMHEpTStmkvGtB
	 cJego1Qs71MlgERmEFO6zXeJVvHVOHVaXA/EzT8ll6sJuhFyyRknQzWK/knQ2caqGw
	 V4V05yPZfzLbnHGPi4ShQPpqOCmnZ8TP/NbeLDxnbGfxrUEVu4Ie9CpXaXL595Q3YK
	 LF3iajum8gCSHtU3del9g4xuaOhFOcumXDIxP3OoqpY9HBS1PzvxUDJSb9ngCVglSe
	 /enH9MZq/cLrw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] Docs/mm/damon/design: document DAMON actions when TRANSPARENT_HUGEPAGE is off
Date: Tue, 17 Mar 2026 20:53:47 -0700
Message-ID: <20260318035349.88715-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD05B1C0007
X-Stat-Signature: 1n69f1aef3iui46ka6qq5go16my4uiw1
X-Rspam-User: 
X-HE-Tag: 1773806043-748023
X-HE-Meta: U2FsdGVkX1+tCtbGI0+1ZOGZ5Z7NZVNmyzDaE/AcA+YoEayUZprMvZEwKpWLTCArpGOGR42GVIYH5b21HHPckBmi/3x3j8mENPq1kiciziAbB/Abpx0M+Hlc5gSjKX5UYXHUf9HZG7tP7e2ahuYHDWo0PCtXF2fjbJWGGDwXX1c0e5f/H4mz+7Vtfcn6hmG67T2z4+Tmjm/ewpmKg3WYqbdXMiuw/nGnktVZkTvqI+RTQdQX+vc416QjLAAdoUR4/iwRY+Zuu2L+el8H4mSvYN27zj2vCgdVyNTOgynJWRTGNYeeWSDCl4l7xaqC+AZJjPdMFwEVkGhNg+fPtkA+2H2qIm9kuUu3csgefGWB2WsHqOT1/JD+44Z4tU1FtgUs2ife0WNF8RcNMbMXp2xKs6MFxqeVhTeMwmbQb9fZqVyFoCec/MSiSpRcuTaxhaTIPTrFpyYxri1at4Qk+aQWCh7p1Y2vghdB3V+OawXGI37ZFuwjNkDAReW6AxeUNh38WseIIssvCabwCtVdR7O+VOzIMpJ0tMhY7fwflYbuWAPDzeDUYGAa6LWzzinn93/bfHA4m6jjLcrt3XmHnn8SRlLoS0e/rY1FV8M1clSwYjkYQriDhPNQ+a9BLe2hQYj0hySjTvRXUJqnS3h9eRNjSrvU2/UXTtafRuLy6AudLmkRuNXF2kbWNkAPwEjxOE8MkhVdeyLsZHcSxJ68AcjwXd5P2H9kzdxi63S7exoKMgmjO/aXOWN1oM9TORxayKarKj0j/Tcz+aEWNARThhRWZQxi5qtkTBMHFJxP+Fd3Ri8wSVrLqslXWMfhA5wje4lOAk9zKXv+nZKbdh2N8el1f/RTSsA2QJKiepx7ej9d2Ea2fGRBkv64Sp1NjY2kpKmsalQBr/tAYFqNNPXyHSFKiGQ0aGTbhU0Iwh4wqA7o7nHttTvhJ2FOcTv5EpAq8shfmlvzb3spu0qqI2O4O6X
 R6qkne3m
 7afDDwVPtihKYvCCJj9rlToTA1T0MPBh4ufKoSbigLZhAFCYwi3pDcU+/xHlSv2XJV5BkOwyHdAnyu8itY1v/WCXFAZxBUg6atXvY9QOhXag4notuom9R7uufpYuk2XrSJVu/2q0cPLR4GGW6hs1kHJpOkGERSxk+H1/Rv1UsL6g4NneEfbkf4AYAJ+UJsKD55ehiNxvVuKSGDLMMsHCafiNrY2dA1z/4iwBuoZCarwQ4rBwgowKzJNzKU4toWQvXTEgNj4TFjEVJQ756cDWu0O+KB68GVJ5mAk9aTyHY5j/fCrrsBD23GMKX/TfC6W1rdgCfNWRkUWsi9NeDXzopPhNfew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

MADV_HUGEPAGE and MADV_NOHUGEPAGE are guarded and they are not available
when compiling the kernel without TRANSPARENT_HUGEPAGE option. The DAMON
behaviour is to silently fail [1] in when DAMOS_HUGEPAGE or
DAMOS_NOHUGEPAGE are used, but TRANSPARENT_HUGEPAGE is disabled. Update
the DAMON documentation to reflect this behaviour.

[1]: https://lore.kernel.org/66131775-180b-4b9f-b7ce-61a3e077b6e6@huawei-partners.com/

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lore.kernel.org/20260316140822.2033181-1-gutierrez.asier@huawei-partners.com)
- Wordsmith description.
- Rebase to latest mm-new.

 Documentation/mm/damon/design.rst | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index dc37402c0fee9..838b14d225193 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -460,9 +460,13 @@ that supports each action are as below.
  - ``pageout``: Reclaim the region.
    Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
+   Supported by ``vaddr`` and ``fvaddr`` operations set. When
+   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
+   fail.
  - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
+   Supported by ``vaddr`` and ``fvaddr`` operations set. When
+   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
+   fail.
  - ``lru_prio``: Prioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.

base-commit: 809b8b9fc1374abb1b1b50fbd0260085b0832b2e
-- 
2.47.3

