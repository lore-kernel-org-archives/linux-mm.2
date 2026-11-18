Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E6F606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IlOt8/qH
Received: by kanga.kvack.org (Postfix)
	id C8F3D6B05C8; Wed, 18 Nov 2026 16:04:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66DC6B05C9; Wed, 18 Nov 2026 16:04:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C146B05CA; Wed, 18 Nov 2026 16:04:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 729E56B05C8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:04:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6209A0417
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:04:03 +0000 (UTC)
X-FDA: 85449467166.09.92EE96E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8EE3F120011
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:04:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IlOt8/qH";
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035841;
	b=HSgQ2KCghg0XYzBC9/y1vo05bTDyRH3RsE8AaPhX9/C6XdEMPwj4xoeUvjY+UntViwBCUm
	ISPgt79TT2O/OK9M9c6etCH2nfNGoxwvHSsrtwM2PpZ0I2+i4LDaqCQCDyEOFASDCIcL1X
	JyyNPvsakx2BBROhf89/+Ej/tT/hRgs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IlOt8/qH";
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umd+xXOtPmpwln7D0djKUtVYi865RTVPW3Jw9yIwv+I=;
	b=G/UDrNweDGEri2beF6fQeoUd34lan6tx6PMCRYZGr2PJlf0qQxuaP4JC+4Y8UnJxRPKdFc
	vUax19HOgv34ohaegbPaIcjmlgwoh4EWUA7MiTqWET+HimxbT+dceZ7KAKEH9yvu8CmyDM
	2ycN2ClsE4uBrijRvYUxFpu7dU1oW2E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A13FB47599;
	Wed, 18 Nov 2026 21:04:00 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035840;
	b=dS7pPnfypK8Ei6Tly3N+lQRq0r2FYKWhjS/TM6N1z5OZihg50btIJvatVUn8DY9wTkqv
	 /r2QIGJlfPp8XgrvUiTrCU6GbwCXVj+8vOD+b/wb3Ldy5+wzOt+mUVXhhW74PZJx91uIY
	 ohEFFkqLDM695hKD0nKLVFp7/UfjBeOkSHAiFLGB3MrX+gXyiKMlsF9jnuSkE48hxshlD
	 RxjaeuJq7Rer58cdW1JIjt0uWA1uizqWb1blP1wulRoYtedSaC+Zh/42GOptHaW2m93Mk
	 GppGE5T2psBCS4rDSejHrvjo0M+R4QlOTjZ9BoYMtp0dlGwnJ/imjH+RthCLqQaH2ng==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035840;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=umd+xXOtPmpwln7D0djKUtVYi865RTVPW3Jw9yIwv+I=;
	b=xGagCxkHeY4X/o82V3nUNzvq7oS0Tuqiz+s8B8m5w3FohDr1Gi1/WB5LZXfG1iIw6ieH
	 wvXorFfExJ7uZ/MuTrnJPkDHrkBtFmz5I86eAMaiuP6PN/ct8BDhIzbf/EtTcAE90EnzB
	 EpFgg+eFQIpVqAHKm5PhweLOxelVNPnLPkETjLs/ID8EYIt21e8EaFnMfkc/6nPefCXYA
	 Ys+gI/t4XSe2YIDm+WvvILXh+XohLNZuGnQ5c0v6ubnw+r9hDsJdAO7qMhYuwKjcK88NT
	 QcUeMZsON/iOtrHnaktEtgHd+4GP7jMIxYDZ4pv1boEOuSYDRNIEAzk8uNmmM0s7+eA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5B8071F0093E;
	Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035840;
	bh=umd+xXOtPmpwln7D0djKUtVYi865RTVPW3Jw9yIwv+I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=IlOt8/qHTTE1yeQHLPyAY5nfE4pdbip6wRKgOE/IYC+rL0gbltUUHYzslnMOl6VqI
	 fUJO8CnbKqojy9/pd30BW9lbXoQ1U50g8/Q8rTflFI8sUzzsrlJzsQnJwijSC1HHlv
	 Q9BcdlCrBvXogspV+h8DGCZJkdrkrwFvY8t4doiPwvhkc8qMnNvYsJw+YzqYAkxsMb
	 QAHcMva6lmfTM97CsVnFqAoJWnALX0Q8vmivrTDcetLv28nQObWGruUfvwekAhQBk4
	 kihpEmnxoYzSsAShYCgOb0hg3rwHx/IDp8OfOCTSFRaTo2oHZmWpcvWZiSCAwOTQnE
	 a809bbEHofIig==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3B3B04AFB0;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:43 +0800
Subject: [PATCH v5 11/17] mm/damon: convert to LRU refs based operations
 for MGLRU
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-mglru-fg-v5-11-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=914;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=juJQDvh6WPvm4O7BAbP0QPsVPdfMcO7QrejsQWUOq68=;
 b=4R6elM1NZFwkimFZRIG8TAjoSqNylkU4BwWWediOGKFcIWwn5tKSC/YO+Fj18DbSAz4kMZPeo
 2b4D2jz24raDp7tNJsjjsSvda7DyWgkAgvzBwtc53YRgbzeEiQFCSXC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EE3F120011
X-Stat-Signature: goswtcwuje5c3mdh4hmg54ho9d91ukes
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795035841-595197
X-HE-Meta: U2FsdGVkX18UuhXEFwp4DkkWcF69Z7OhX9K4zZFnOphLtzcnTvb/Xn+vDTN5Hb5+hBZIkGJgMQKqRAQtDtPIjIVpIuwt0Zgjz2GYhlG/RBvHTEEpDJe6KSZJOIqtM3DtqnHRroCa/ZK9mvuiZdeb0JK4AXjMkJTwtmWyMRxkXzCuI1OOnUq1EPI+LrRPA2fS8sSiUKxY5U6bqiSEoKgKkk4Pd+MvOI/pQM78tnxWGsE6K52AXGfKDd4/42CrqcAo4uTex3INYi9yB0M7l5nAqJrvr0E5kiPj5CGSjhWqHtbIqY5BC1XoiC85sgT0x6i0uzDCGhszXVH62Uo/9tHzggA8dK5Ttx93HYYpauXYy7if+Y3nciB+FETQ3o+LPdop3HxvdTftEIW+9nV0V4qCiuOY40+b6qIkJikrEhbKIGO5U3bMWHZXV8FSP7gZ8Lwi+ajpCADU+sMhG6GoqzWjqJ1Iv4vL1uDlbXJvDs6zo3GuSJZyexzzTDDUKcIJ2vpD4ATKBjrHZG0VDs+hbhHdz9iLDPizb+akHFG7e7l2Sk/6q+UprPGtgJlvbLCZu6oM3iPeZiPi8STT+e70ntGm8HjJlcXrYAhnKBH9mpq1HFBKhPABMV7zZB0qo6WnPe+BM4UasI0uG7DvjGHN6N1zwflmKCKKrK8C0YxNa1AFgKiaox05AVExVq7UNfT8R6jDkxdCQzF9jSHaNHhV4zRxyxAwIRmFT6BsfPLnfr5Etq0xuWVK1wVrDcZa2Ccy0AFYZmHxUFgeZJNLh2pn4XqEyhiTDEfgpDai7SzMPdk7KplnRohWVO3rq6zGBqgC+gsC8RvKAS22gl4Q6ujrlFyPMALipxzP/w+6bUxxm0KGDOyd5eWa9+2yqsQK9pShMHh6jIWn+ZvPvYXozPIriVP5GdIAtBJMsvgXHmsaPgVH7ojT0dJbkeeeoXsTlYXyNAldUs8ES6s8VqAo53ufYuT
 YJs7YVpC
 j80c7Wnf4N7xjYQuviO+mg27Mz7t0ok/+7AHQNTC/iYWIeNiCG3fYwAMnXagLis1glrC52KK8jgnbsfXM7efHHYIfea/7wK45NYdPT4T1KVokQoaH0YVTyIGR5NtNv6dS1wU03nZv7CxJjJHGuRr4/HGKhH2Riylct2BqGf27LPecGwYO8CNuhd45/tWCqiJCF/f48j7Z+zRdqic6qHc8XK1ePpp4ebfao0s0+gD2XcdH+1eQAbLCkBTlWPf7NqmkMa8Dg7oXpMzEHK8QGb0aEbDSVz73iGgIOxNa5o3lXI+L7BUiYMbxX87qAENOAeTtIikLQoAPbUaBwps2XuiHosiScODkWVQCkGTxRyPDvXve8T3qstdE2kpkqjAiWE06qbJ7tdexKcNcvGc42gtePjFmJRMgmqaLeniEtAiuc+QICS+EBfVpuo3+V6iIAp19KcEOClOWBewwxKD3wu5d2ChGQISQFdC8AYafCkMVZqyDMw4+xUC8tUtdusjxjrLXNemmc2qPorJVbyOf/in/Tp6fYr4D6jwF1AwKhXqSz4B+vFuNg5Almadrv0nevxRAw7AZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
corrupts the folio's refs count. That flag is now
bit 0 of the count (LRU_REFS_FLAGS).

Reset the count instead under MGLRU.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/damon/paddr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e89cb14ee17b..411e1d557ba3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -279,7 +279,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		folio_clear_referenced(folio);
+		/* The region is cold, better drop the hotness info. */
+		folio_clear_lru_refs(folio);
 		folio_test_clear_young(folio);
 		if (!folio_isolate_lru(folio))
 			goto put_folio;

-- 
2.56.1



