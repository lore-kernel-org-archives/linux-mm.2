Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D25F4CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445A66B00B9; Fri,  1 May 2026 17:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41CA46B00BA; Fri,  1 May 2026 17:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332DF6B00C9; Fri,  1 May 2026 17:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0A96B00B9
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:14:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4F29C1442
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:14:08 +0000 (UTC)
X-FDA: 84720103776.20.A100766
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A23AD120005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:14:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qgCn+zcQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777670046; a=rsa-sha256;
	cv=none;
	b=49SPulf3GBP5KrWQwMBOGdItC+uaILFIxdWR7a5EyZdDxVKPA6o67MHk+Fuu6phCeFZkb2
	qrb0PieLsAuSD9nMMKPPR3o3u4tE36L7vYSssSt4LHLsy/YsobC24D8DAnM9HGh31axtUd
	4aHQmBvVycN4UvTDXjdpDWydbUR/YKk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qgCn+zcQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777670046;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgXQaxsxcBhykn4L950KPxOQoO/M28tj6b2J7MpzTgQ=;
	b=IuYfPLs5J+0L0py2Y29Ck5u4WKzk42Q+XqIoAoq6FEZrmQ3mUIUJEWCRFwD68eQNBLGwtS
	CDfOIWctxr6FYse0izOdNNa9avAkswmUkevneJKXuUkXDjZQ3fYi81JoAlMGNicmBZL0gA
	5Fh9BIYaZVJhyYmYSsSCfcC+Bl1Znw4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 555F144722;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35E58C2BCFA;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=CpnKWsO08wiB8cn9JIys6r/uZDfOE9UFk/t21QroBUo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qgCn+zcQB3xec9hvFg2q3r7Bc+7E6ej6hyfkKHfddvOMOoY3qjN9PfqjofAuKlhyD
	 df590To5SsJAVfOC/QHT/HkxibWVqHQQf7A6esRMHxd1+TbnwQmOgzjHifWr1RQEbX
	 sZKU5sIJ8y2I/riJOPQxGENju7YabOKWVQcOIu8M1W5cmtfIk5pqa30DjA+AzraO1w
	 uJN4pdHndGbBmc3Rlc2IRjDn3DS198mM6gxXmCsEFGgU4K39C7T0jYLZUR7IPwzokU
	 m4txlLiP1udkMfoUiOOVU0n9WFEf7o5cEu8XRQQ6+nJx5W6bu7W7J53JrCOz3Bwxs0
	 Q9tzVmTF6mWzw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B720CD3423;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:02 +0800
Subject: [PATCH RFC 16/32] mm: convert folio referenced flag usages to new
 bitwise identical helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-16-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=999;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+5qun8U2KQYDmQH0ZIm/6ejG1bASGFZfAJQuD/re23Y=;
 b=lSMsnUvxGGUaYG0E/v+f1nxrr3TYC9U+s6XCF5kTjEYfQM7zbRpIjFFhSJ4RiZ/Cp9u0YGRqE
 oaQcIqhCOdFBSP97uzGceWG0hU5snTAOcZ2U8TXEw2Y4nZ5E9KEBA6c
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: yirmq8kgcnuahpoeanazd4wawrb4xkbk
X-Rspam-User: 
X-Rspamd-Queue-Id: A23AD120005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777670046-842527
X-HE-Meta: U2FsdGVkX18PeF8akYjGihnHcwvSn7hZqGOvevmjK8YjbTOHp1lA1lSQkR9kvtNboe5HOi6X79EsY3yLO2WchbwP76+5IZU+n5vn/CtRB9QhpqyXFy/KjeqH8MlO+PH+Aca1yV5GeySjLZ1y0w+M935gDXqhrYLRhPrBS/w9xXFQspg/K8NeXD8RAUFRgv9L3LEbf01V9oA5LTy7zJGmLJgh17QXg+vcrM/PS2nkxOq664T6iKPnuCe0zUwkj7+O+QyD2uDMm35AlDwFDadFVDdTMRQaFHzq1/Gg+6Q5iumkKA7IRC0rZI7vUyz6C7XOP4IsI8ro54odueXKNTcGbxn/kJBaJSOEA8JFqIum5APgpbBAtUyHaFxnurqeyRKUwwe9oYV6h4bCnPuRJZRWNvLcJmG5l1f/rGfZqid5J498uXiKE7nsGOt4ICHNSyMEVHfjQcuuP5eDWFNeUFlJZGkrVd9zwjfX2wguUvJHx1b7s4QIQe3Q3oU9KcowcntYbGkmG6qsY4kJFdejheTNhrvRPiuM2gqh1k5v/3TVJ3+W6nrJKla18wozJ5iP1CiDrtR2zy5pnzJdM1Mjhs+6csuEuCzFaesdS3eFsQoxWsX62DG0K5oT0jkHGJMgytqXJ8Xkwj5HRfjI7LelPfi1mhqAvUdKdIujnLQPRwV/Nj9Fv4ao/9aAp6LDWt9jJdccCc41jY7CoQJSdp5OdpIBrLIYCuouuOnO0Lw6ThGnMyk7uDa2xN845gRY4pS0KZUDFKDUveKe2GVCG3lkamDjS7p1kBjS+HYVULVIzL2uzl6D9DY7Y3JO3KhnxqLE7DDyYnc3pIW20BvhKqD9cwASULBPE1nzABjMBvgqvuUDoxuIr4VYIV48Jpf9KlBIEbZvfvcoY6qWG5mfZ+BI4Owlcd+rmZgzi6Ea/gf0oZWaQ4GnspIFULUUXNnD3q6eyOH2pRMHFC4Www2mFtHRFtw
 RejkZtoC
 eE11bVH7JJutSk1VdJwtk6RlykQt/S3TOccEzJiOqXcQCL5sl6LqoJwQfoQ8fzX0UbX8wXA8Aw76PNtBMfjEkQToAY2NMMZHc/KApvp5dssqGfOyjrOMhN4dRKQ38FVylYjjNAISq2dkrEX0+7Ry9CslPyMXGUjcL1Wx3pW0dWJhlf7oT5Muenxfi4vN8OzOxiUOywizsSyF2oO4VzAAR7smP+t7okuVLLL0uCRfPS+gJ3/oM1rDgmIlyPfqJ/VflpHbFxBB7+lr2IMiEcucFl/En2bNOY45ncO+llii7cD1gt+oQxA6KwoNzs8IiLpRKqkOhxMmXogxj6JLpmODF0ApcG/xnbSaPdiNtwh5Hr3bH9WYo/zZ+sqmA6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for removal of this page flag, use the new introduced
standalone helper.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 6e0397ff881d..2250d9db1395 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -525,8 +525,8 @@ void folio_mark_accessed(struct folio *folio)
 		return;
 	}
 
-	if (!folio_test_referenced(folio)) {
-		folio_set_referenced(folio);
+	if (!folio_is_referenced_by_bit(folio)) {
+		folio_mark_referenced_by_bit(folio);
 	} else if (folio_test_unevictable(folio)) {
 		/*
 		 * Unevictable pages are on the "LRU_UNEVICTABLE" list. But,
@@ -544,7 +544,7 @@ void folio_mark_accessed(struct folio *folio)
 			folio_activate(folio);
 		else
 			__lru_cache_activate_folio(folio);
-		folio_clear_referenced(folio);
+		folio_clear_referenced_by_bit(folio);
 		workingset_activation(folio);
 	}
 	if (folio_test_idle(folio))

-- 
2.54.0



