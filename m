Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67256606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=L6u3caU5
Received: by kanga.kvack.org (Postfix)
	id 4134E6B05B1; Tue, 17 Nov 2026 19:00:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA9A6B05B5; Tue, 17 Nov 2026 19:00:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327DE6B05B6; Tue, 17 Nov 2026 19:00:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11E586B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:00:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 372E7A81FC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:00:33 +0000 (UTC)
X-FDA: 85446283146.03.E4AE9BB
Received: from forwardcorp2e.mail.yandex.net (forwardcorp2e.mail.yandex.net [93.77.172.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D3BC40009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:00:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=L6u3caU5;
	dmarc=pass (policy=none) header.from=yandex-team.ru;
	spf=pass (imf27.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 93.77.172.5 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794960031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7IO9qqU3wnMoibykZ1N5l5PPq7ErE0eqGwekZqMRpqE=;
	b=bXoQkDtTDyJ89nv8hVUPvMIvRddODzJl3pJbb3WyW55jvA7Xh5JwDeGDHPCwYu9vc4MnGH
	ibjh2Pn7xi72mOIzubs+JXyP5a80b3+8/3wwXzRe+utxXNfSDntRtP83gKRFLnUCxUaEdu
	Iy6NmblO+d5QRr6mXlNFV+XC57N84KA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=L6u3caU5;
	dmarc=pass (policy=none) header.from=yandex-team.ru;
	spf=pass (imf27.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 93.77.172.5 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794960031;
	b=kw6tz2uXlNb5cZcy61ptX6NJeVyBfTnxCT0v6TTy4FGiBcMnnodo7gJjsIGuj1O+Fy8ErD
	IZlycFXXMjp5Y7NF4r5mCKaXb8O1SuUD8PKMxRFDJWXxuFQWFDvTMwYSBohmf8N91CbVK7
	2ONB7SvfWUIJGPoyvyjF04rQv2r+W54=
Received: from mail-nwsmtp-smtp-corp-main-80 (mail-nwsmtp-smtp-corp-main-80.yp-c.yandex.net)
	by forwardcorp2e.mail.yandex.net (postfix) with ESMTPS id 52195C0053;
	Wed, 18 Nov 2026 03:00:27 +0300 (MSK)
Received: from i101646577.yandex-team.ru
	by mail-nwsmtp-smtp-corp-main-80 with ESMTPSA id L0NFxU0Yj0U0-eYG64ehH;
	Wed, 18 Nov 2026 03:00:26 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1794960026;
	bh=7IO9qqU3wnMoibykZ1N5l5PPq7ErE0eqGwekZqMRpqE=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=L6u3caU5HDhbgq9gNGbkegT7GZ25C9gWnv+Cczano/c6tPTYjfBNCFO13jqGgR/eS
	 igXD0bTj49EYDSYLvCJdgkuxvgy1atUs4tZBB6pwYj5x7WF4NJd5NM879JF4b8tAG+
	 fxYbTCVTregpSMs+qUzBJW4gqBP1Ubu03nVdCyOk=
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page_alloc: don't undo another caller's pageblock isolation
Date: Wed, 18 Nov 2026 03:00:13 +0300
Message-ID: <20261118000014.1474617-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i63i9ga3utswuanonyn3ha5tfar4bmic
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D3BC40009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794960031-483894
X-HE-Meta: U2FsdGVkX1+cGKNwdjqqlGfHaGatEfeFc3XHVdspK3T5U7xsfo3v3g3ckXzQAMk8lUfMyZpIvdUa31RR8Obmvh9ixc9Qf2O3Elpsy5w/+Adz7rMGtTCiaXLSxMaelrRF7eGvXnrRya3XKJdCJ5jbfEfRv3gLvgwT8NhlDCMcXfxL2SZp+mpumcoCNZ36EybCHRWUllISoiZrgaXH8iH2BodH0izlwnDu66yjBWcubMB1QyO5nKQDjfQuCNHa787v7kGP75W4zrSF8584o4/QRSU3iEtZaij7hC0BGPoaM8wXGPTg8x+bdtSBD/vx12ddlRtBy7QbWhrYhDRmAOzpSMeefaTE2Nz+AKQb0GPbB87BJHD70JRadxeOqXhH2FV8tLKmor4LFdfFtTVakax1Ufz3jXomk/HgEwQM18viwVOp/357VtlKIc9xHGNn7xjJEKwPaq1tgFgHEiHFe+EhhjQXIjOE6vzb85NCIpOolwCH879AHTv5DeQIeFXIPLU6z8rIFAnJobrtBggjG00dR+A7Ohl6WZdsb0lzMhYvYEXzPKD34yb7P9/RXa4PY+IhrTvVpKqxQG8IGeU2MF0batZV50Xnw/ZMLlVMstTYzVIxlaWYyhb40+RvV9lwZiKt3aHAMfgM0VtlkMXrUMGhylOX5iEWuiQp0sbjwt4aQRcDCq18oCvwMEIHaGm7koCnwVThogxc+xlmhZZfTRCZxB8Gz35XvwuM5ie0r5LzoX/PuH20MAGdq6z1ilP0xSP20Eu+hfE89/l+8ypKo9CGrLHGX2B3h4YP6qzWGjLZ10SWUJds+MwMz3kLIasRkl4urVM38nM2373BWfc3Ouk7ZCVgb1Nu+zuThqfQfa4vYKZYQSJHkxNn7QYG8VjGsqHE1WRsvcekBlUHQdq3wONRCqUiQpGd0OVCL33CW3uTAE4b4MvKaK18PVsaKRdD59cUpc+kBh5sgdnM5/HjZQ0
 eA2KkYt8
 hKm2SWHh8JCi6+Z2rxOE1KVnjbBUd2oPo9DvLHihfk5QSwxOmxJaRxae+wCUz522751FWG50gbpr82X36Mca/mj5MdILYFEyGwUDOVClf47wjwc48+cjereN29Lzy02zgqym5da05VgUi6ISzIxV3MylB0pNRi0Oh/vzdHTbNc2KqGdG9vwzyAYaDXOGtq/xBr7WgW9ixCoHEIo6wzSY7X/DMkYsGgBM+IdfzF/2/+6GX6x+QIt3SoGYpZBFKLPrU2YV/lb8kdW3m7eNY/dYXEuZLDvSWqa+rwgz7n9dDNvVDsDuMQpnp6rDa5hZ82vO0oQKSy2cNnSR3nvg5e1iS30TgqnIcNoStNKqyFyiGVh4aIbVevSPrvj+bTH17pgnWvBoR0KqCuZAY2hucIWA4IeH15A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

start_isolate_page_range() fails with -EBUSY when a pageblock in the
range is already isolated, after it has undone the isolation it did
itself. Commit 2c7452a075d4 ("mm/page_isolation.c: make
start_isolate_page_range() fail if already isolated") made it work this
way, so that users of overlapping ranges, such as CMA, memory offlining
and gigantic hugetlb pages, can use pageblock isolation to stay out of
each other's way.

Since commit b2c9e2fbba32 ("mm: make alloc_contig_range work at
pageblock granularity"), alloc_contig_frozen_range() handles this
failure by jumping to its common exit path, which calls
undo_isolate_page_range() on the whole range. What is still isolated
there at this point belongs to the other user, so this takes the
isolation away while that user is still working on the pageblock. The
page allocator can then hand out its free pages again.

Return right away instead, like offline_pages() does when
start_isolate_page_range() fails.

Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..151a8d64783d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7335,8 +7335,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	 */
 
 	ret = start_isolate_page_range(start, end, mode);
+	/* After a failure, whatever is still isolated belongs to someone else */
 	if (ret)
-		goto done;
+		return ret;
 
 	drain_all_pages(cc.zone);
 

