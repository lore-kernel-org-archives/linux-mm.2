Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57511606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K+Uul3RP
Received: by kanga.kvack.org (Postfix)
	id 43D816B05B5; Fri, 30 Oct 2026 17:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4149D6B05B6; Fri, 30 Oct 2026 17:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B936B05B7; Fri, 30 Oct 2026 17:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0552C6B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:35:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75CEB408A6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:35:34 +0000 (UTC)
X-FDA: 85380599388.03.BA9B4C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B38C0100003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:35:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+Uul3RP;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396132;
	b=2SKY6ETfUKGfyYsYtupLesMl3UhRRAp3hE0aS9sjvitgu5BUkGnNvu58LmGibsfawYo4Ip
	odIafJhxTjbWf+1cJl8dfyP0yQnfd/e3kWZRyMF0S7888NjNBbuVMSzxdKanRz9r6bhfLa
	50GzaOihLzxx5U1Hjy4Zxu4hnUl1Pe0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+Uul3RP;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFGvX1O5XH40DuwZagPTb2HzVcVMR0CH+Fn3DV65/+Q=;
	b=UhKtq7dJy5DJ0L0QeQkjlrhXAILQkDAJi9kGjAqOFWAR55GwfSooexCjx4DktytL5n2FM2
	YlvrIZqPjXwxwAqzPxnMwR33rCjhnZJgmm512KIgeI1eUpugDsq2mg4aCGl8Io7pyBaN9u
	ImOHxmjW3fulLyNwpS52Zsw4BheOpSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41FFF601F8;
	Fri, 30 Oct 2026 21:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4828E1F000C1;
	Fri, 30 Oct 2026 21:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793396131;
	bh=NFGvX1O5XH40DuwZagPTb2HzVcVMR0CH+Fn3DV65/+Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K+Uul3RPxqnQzKU/UJSlg8IcNV2km9MXmAb21nyK0G+TPZTX4wr+9B7Qkb1LQlRGN
	 8atZJJn2WqeKvHMRl1PtNJBQWwNZHJy1N/pb3nlqVRLrMw+7KL0hwY7c09/g8otQja
	 zJuLUktQ/hOEsgLp9nO9YHK7xofG/cDDn4FndojTwIqluTGCW2vyPHNZKtSQFqtybV
	 RnE0RQe1bPoRVRHh7Ow/VD2k1HR1rnvnHA9LPw+A2gmuLH0wY9PjNEt2OCFk7lLe6P
	 GRA2K2++J3LWjRAh+o5qvKzvzwPbhq8yxbqruTeSlChYj9Xzq0m+xLHxp0l6SA4WJZ
	 Cb+CTMluF3X/A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 30 Oct 2026 22:34:27 +0100
Subject: [PATCH 3/7] MAINTAINERS: add Zi Yan as co-maintainer for MEMORY
 MANAGEMENT - THP
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
To: Alistair Popple <apopple@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Byungchul Park <byungchul@sk.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, 
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1097; i=david@kernel.org;
 h=from:subject:message-id; bh=LO3W/epE8pnx/LXnvCnHeDTK5RYQxoY93j4IZ+I1qVE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKe8ubpPVTqWF8q5NO9LVJQby63+NKA5cenhzlXL/x81
 Gvr+5IvHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkRQHD/7ID5nGrXuRa3deY
 FNN6p3Az06Ew5uwMb9uzy9y2fN8vGszI8HCbWnOY74n8G6EfW++XX5tqOttvXdWzxvY8uzCF/t1
 N7AA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: B38C0100003
X-Stat-Signature: rgpqse4h1h8bn5gupopia11tyb5587x5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793396132-557215
X-HE-Meta: U2FsdGVkX18oXZT3xD4cG0HCz0YZTSPsQxlJShQ6ooK3MeSLWvLm4LizT86PrRw0ut69MVv4S/Ax6Rx4m12hEiqYJCzik5Fq630fI6SnDee4ovjXQXAzC32whVajcsVKkyF0OqL23mywDa6e2LspsLhmGV0QLLcDwqnw0McE2Wy/dMW7aKIX3aEXKiow6TaScJFC7tzTY9CoznACH4AxPTuWrMlEooJtH+qELyHiFM12rKai6I/4lpklvB82OAeM+Sk+eJhq+E0sM4fGi8RJhzmqC5ZJOvGzufRN7i9kXCt6a5pLOCOfLY/JJVKxRZEr/ukzsWrbzq7AKc6tJ9cHqDhViYU4kJO23ZG8LpdZOopXxApnHk2m5wKG9uX4vkkokdkoU2dqIl6nyaWE2BtvU4sAhTaiIQuDMyinIbFDeYkj0kqLRLtoRQF2f+78g2XJHdhjOHDiXasN3hUkruVJ+D6BCNcro+OlACQ/AGWQSAqIacP4gat4YQPehKxWy7naQjTv7vTcXTnI/ePhzdWkPMmvw6HqeaKaUUsXD8b6emYM67m7UINlYgurBji36+ZLRUYJpns30K9BGfwSVBjLWc/a7UKDyCc7T1eV7kXWGn+91sVHNT/LADT+59POHiV/RImfQDYtfu3e7UhhOXQ9wHNQ8RkpQnkMNMks7cg0tFMsY+L659ABjgTt+HCW9izu5xosYKsQPFxv4ZsS2j7tfjRkrj8ljKQlTJogvR/TKtHfChWu0z2wHf3YtpmcqHjuPMrwFq7aCjAP7BUZw2GujrxMxZcY5fj1Rl9FXyH+hHRNzeA95be6jth+1iAW7mm08wSqDskzKctgg7nGkgL/YVXve3kA6OtmKIX6dBSeT+9Mg6pgBTUNfAJMqKOuFcoWHsR5b5GB16SweTTxSOKV5du0GCuq1nKsmMmgg6h0JlS6dYsx1YnqibgUaO+2RUjZ5cYpcY5UZ15QwNSpT6i
 Yoz68dRJ
 GsIB3a6D2oYlRkb5vZzX1gF/SyfWmM8grHkOXyntxzO53kZ3WbMRqgsWXTAnx5PHeSu1dPlT9nO02eSUbbVEPXq8Daa5dTCUccMHRN8zY2bZePYml2/z8078fiOBD24DFBwSc7VvehO47Wfzio54INoY8dxXMPVkH5RdI4H03PQh8m1sR6KvHNzN2Azp+p5qALTdJIcXuvbpFWxwp3zLHGiHfOsqtVezou9Ioeq182K0aG46XiL44Q1lXpSh7hHMuqJ4glnEN2+wxwThN0SwciJL/+FlncfJKNLwGLry8MnFz+mOGxtIk+9TmfHWVRsmcAvp44t7am7VYHE5OcQl/zGmMAAMRxoYcx1PQGpok74pq738VGM+U3B71yp0qALy2JZu3fVI8dHQtH7p7a+1cpB2uEBRkd135AlfvmaZKfPnvZHZPE7ZIwlLnzUJbWDNgqqiVkq5WQKhIpdIX2axX4MGyaU2HSYjTRkndAjb9rrnXd+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zi has been contributing to THP consistently and reliably over many
years and is considered one of our most valuable THP experts. As THP is
an especially active area lately, having a single dedicated THP maintainer
is not sustainable.

Fortunately, Zi volunteered to take on more responsibility by stepping
up as a THP co-maintainer. So let's do exactly that.

His placement in the MAINTAINERS entry is very convenient to perform
this change :)

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0baeb37b0dcdc..02b5b542f81ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17817,7 +17817,7 @@ F:	mm/swapfile.c
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Zi Yan <ziy@nvidia.com>
+M:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Nico Pache <nico.pache@linux.dev>

-- 
2.43.0


