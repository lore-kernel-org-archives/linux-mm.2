Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5502606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RGLYR88r
Received: by kanga.kvack.org (Postfix)
	id 0EF216B05E5; Thu, 29 Oct 2026 16:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C71B6B05E6; Thu, 29 Oct 2026 16:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20446B05E7; Thu, 29 Oct 2026 16:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D48B96B05E5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:41:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 730694050B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:41:53 +0000 (UTC)
X-FDA: 85376835306.14.EF9494C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B08A940008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:41:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RGLYR88r;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zArSmg7yLUQusiUDBjlm/kScYeO/TmH/P9/Smu4iQZg=;
	b=rhU9SlASNC+2NnZCkxmhCu7K6D/24Io0MqjRMc1/yU/a0on/X9p4GHSu2f81U/CeSkCwtw
	ztXIw7qU0Xzq7ybi8IaALX6KJLJwhjJZudA8by3ViIrOXzyBXpnzK37ODyfHGAZcpxcNYs
	vjRCbvb66gYDlM9UClxMFVU2WqzlTxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306511;
	b=Y+F0QFzwAEJpO/35xKSPGTVlGNg78srKxgEGi+2tsdqGYi36id85w4cgImI78v54vV51Ly
	whFixvL90q5tW4KhcbO1DazoENTMiPdSrRPVcxoqqOpENWm16fks6rZ4cIVp+McX3r+Shk
	ov/GAX62k7VQruphgxFcPFZjxwVpiHY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RGLYR88r;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 439D1600DA;
	Thu, 29 Oct 2026 20:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D979D1F01824;
	Thu, 29 Oct 2026 20:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306511;
	bh=zArSmg7yLUQusiUDBjlm/kScYeO/TmH/P9/Smu4iQZg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RGLYR88roEEbDd5tCeYUTOpvVfraAhTmG++35UVmmW+MOOjtMfDoQbZ3JwNu9EYK7
	 a99vFMdfcGf8o5juAUZnbJ5xZs8mAGQ1+gjvsFf6NHOO3vpEmbqZVt3FCXH1tgKNfy
	 WHJSd4Lz8UjYheY8b6tfHXBpyMyIhevr0bOkLKm7e0YsAY15rmrqUd+JMgpP99OcGM
	 p5rxJpPQrcARGEcSkJF+8J7+1oI/T8LiSMX5XgFh2+E67ydfTgPDCA44s95fCGJaSG
	 Vvv0OX3xJ1ptZi56r/nPn2GsnNt0bERfJYkrF8Yyh5tqVEW86MP0+rqj4DGWD7vADq
	 jNLTFzqpOM9ZQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:29 +0100
Subject: [PATCH v2 34/47] mm/madvise: fix data loss from MADV_FREE on a KSM
 page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-34-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1733; i=david@kernel.org;
 h=from:subject:message-id; bh=K1BVe7ZYRTk2Zt50NT+PN3jE7jOx7NQzRVqTDwh0m6c=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+04M4X18V1Z9xPSyy/e+WsUa9zSlnOmMjtRcs/1g
 NZP74686ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi+dYMf8Ucyw4tm2A0J/OW
 z8VXDYXdXeKvv2wMrxY7eGn1EVedZ0sY/lmd9HP2W/rCXJN5+ou8mx8EBQO2BC78+WrrK7Gc7rI
 f+9kB
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B08A940008
X-Stat-Signature: krsxu4d6qkozufwf1fdmze5bhk4f3po6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306511-627419
X-HE-Meta: U2FsdGVkX1+FC2AyXQaiOe+EDg+iN8/jcbsEnX9bHakuTrhXpRiHExMHG7EDJoh3no8/+rAP/ZCNj2sP3AdZkAps6ujf7ehRbQWm3OQ995SPPdSzptjAwFZQrMROKE100VtEJJeYbU1LOsgXEuC+k+vEJCWA/MB/4OjYoRIWzonn3KViFxziO3YHvgvMPHvoU3RntBIF7sluRxfJsiR+A/GBWpb773B8zP6TB6qWEtgL4szOYvNm4CEtnbw0ab7OoEVFYkbmIRCXDDbqy3362fc1jyhUSwEEyWGXf1yeG20PwYlzkPut33iZDZg2LuylmtKCExWxa6zvQp8mmLRJYmgpq0oHWuaRvFuH1jV2yhqlHB7WB9wQTOwInrdSzfERfFJEapof9Am9hv10Ccj0Ox/3pjEalutF/hcTAM0jTRtHd0kzVOuA3N+UbRpAvUl/NIUQeR4fiVEPiu+I/BruT1ZxmOt2VcPNxKSaVDvYe//572PB4GRuvxQCpstsYHbH8w1v2PzIhaPAh+rCed8IzBrEm9r+RQvAD+wgXUjM3rQ5zZn4C7ApBwO1aBxfPK4T/X7bWnlVJRTvtzlXDnhOaoEm4vs/z+fUih9PELnAtZVa0Rn0wEW4ILH1yXlh0M1cQ0bpVyDvw4fmaq2Ib85/nfRTolb+nKhq3jPGeQ1X1WuNq5Z9GmI3UaQx7LgIfpAgIAQF1Raz9RhUkSufccS9a8mHxNw77uM8y2sBNsulEkOkOGKrKqYR/hzUcQpuPIbk+/25194Gw/8E8Xqm2/pXRE+UAfcUd2UcDoDZ/oH0zg1Hxw/LDMF1EsyvGYmpWsjVfAUIk4ZtOPlPTRUksOhzMgeeXPcRnxx2I9O7AHwn4QT4dKeR43Xc1RYQ2lzbiR1bBf2sCh70BQO3ZI0BFhpJju7vFnsquTqzYwnqivRXU8nlTVcf2XFYzV6XL1EPJxvjUSKTflq1/oMHbg1DNH6
 XgYokVGw
 3FnVFuC46Ud7wE6IsGl6gksgbZMcf3iK8nCwGzqceN0EonzeiUgsVdcbiJtRPpgJe6yzUL7iH9di4OYVX5W8hfIWndBnGHD8jt1TZ7FYE9Ms7/bVNLrofRGjJpOZo0pGgNNvBCtS53pwztV2VpmEv0E5sr7P2RnAN5USPPCkCG99Vs0FLEi3+PdTfZ2sAbCjjJQvSN4274V+mh7RgQBd9vI2OL2+5fMWcB+aP5Y88uvjiJOMEG9dS2EJzS/A+fUUry0EMjUbharQatarn2vsERlmjPeniZnjSiD9m6BP22vlx6svf+UoYMqdhiBsMQzIPUpuEEyhFXNrLddYUJqCVZi6AG/HevZgpzaV3vux32NoGaVctW/Gmhi/iTr5tEd38sxAGz/MYSRgRpaKZ7pzV14lnIJOtRiOKu2C2V7CdQAVxiDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_FREE can clear the dirty flag of a singly mapped KSM folio. The
folio remains in the stable tree and can gain new mappings without being
dirtied again. Once marked lazyfree, reclaim can discard data that those
mappings still need.

KSM always marks a folio dirty when converting it to a KSM folio in
try_to_merge_one_page(). Marking a folio lazyfree clears PG_swapbacked
but leaves PG_dirty unchanged. Preserving PG_dirty makes reclaim restore
PG_swapbacked instead of discarding the folio. This also protects folios
that were already lazyfree when KSM converted them.

Skip KSM folios before clearing their dirty flag, checking under the
folio lock to serialize with KSM conversion.

Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Xu Xin <xu.xin@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/madvise.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 75b409e97dbf..a16e3cb256b7 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -756,6 +756,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
 			if (!folio_trylock(folio))
 				continue;
+			/*
+			 * KSM folios can gain new mappings at any time, so we must
+			 * not clear their dirty flag.
+			 */
+			if (folio_test_ksm(folio)) {
+				folio_unlock(folio);
+				continue;
+			}
+
 			/*
 			 * If we have a large folio at this point, we know it is
 			 * fully mapped so if its mapcount is the same as its

-- 
2.43.0


