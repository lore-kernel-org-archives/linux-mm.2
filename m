Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E214606A326
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XmfZUdKj
Received: by kanga.kvack.org (Postfix)
	id 31D666B05D9; Mon, 26 Oct 2026 19:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5166B05DA; Mon, 26 Oct 2026 19:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B196B05DB; Mon, 26 Oct 2026 19:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0129C6B05D9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:25:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18D1114083C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:25:08 +0000 (UTC)
X-FDA: 85366360296.04.38A943B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B45A1A0008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:25:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XmfZUdKj;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057106;
	b=ElWL+hX+d0x3YQOk/ZQ44xuCuKE4+Y1y7a2oOrZXD8GBgGqDxLoex0EPW8ExbMCF4AOyK2
	T+VN2Z3oNDXk6bZKDaOfNc2ZYQGSa9dsosOV6gVLs84LRG88zy+2X+fZLly2L6GM1jEa58
	RjTS88n3FXlVdGEbjVTExtRGwkjjwlM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XmfZUdKj;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWNJ/XENAKSS8XJu2StXXvDx4pA/ZlIpefLloruQ3+A=;
	b=InXyDoKxDemUPv7ldOAysEt7wGkbbv5qqqmCY/zNVPCFzbeLucsgyk+TLiizxsSEsrqfLe
	v5xwCq+PUTo52yzxy8ZlilJyfE/NTgbnkPhZvtzGFWB5kflheIoGo4zz+lX6cbmTG0Hgz9
	mhsmq2KZ3pgzzC3H0VTUZiK8+gY+mPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90FCA43A59;
	Mon, 26 Oct 2026 23:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC9B1F01825;
	Mon, 26 Oct 2026 23:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057105;
	bh=NWNJ/XENAKSS8XJu2StXXvDx4pA/ZlIpefLloruQ3+A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XmfZUdKj2CDA3hO/9OSbirdo/tI8K3m4+KVIN68gYUkWYDqjcQkm5g1INwhB61XHz
	 B7RwKeG1CHsN5S6OJkvQsHmA0cql1QWmgbZ5b07svv40y4SxyrPzL9VUHMao1+/lbv
	 pDTINIXQaAyXCwuj/k/OuayFvhOlGgVfUtolZmXavmCRIrRKJuvsa8MOnJFaFRq87R
	 SIHKlLe+V7Ng+b4lAvM+DKz0SlqtEc9SiBdUFWJwiu2lctCWh0cYkKTc28rEazIUI+
	 jxN1CCeJj3IYrRDtRR5yXE9lyp4+zAuIjWbwmIF85IHU5AghTyKrUsQAlewE4xpgIz
	 p8s5ToS7ru13A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:43 +0100
Subject: [PATCH 23/46] mm/userfaultfd: write-lock the VMA before waking
 waiters when unregistering
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1288; i=david@kernel.org;
 h=from:subject:message-id; bh=SZZ0c1Ekk71/HNTctZ9IxQIrBH8id6NjD8hfDnFWvMg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/m/ShOQ+gHDwePwf/j9sIbLn+O83as/W7OorTuo
 pR2iufujlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbyTpyR4dflzBz7RJm7Wi7e
 fkozPU4pZU8RvNeV+djcwsszqL8ghuF/+r1nL/aekqm5sah+zstDGa/fJO6drqF1452p++uS9GA
 1fgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: gx4j47ekxs9gzh6ikj7gx6puqep6t513
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4B45A1A0008
X-Rspam-User: 
X-HE-Tag: 1793057106-625761
X-HE-Meta: U2FsdGVkX1/3UijAfzUBCHd/RNc3eFwyYTLVFPIfxt5wQFerxpl1cSNCVP+2Me82r/wL5zHWL5irDPlel817zo/W5z6sykK0dCo0dxLjXi2EWfi8DDK0LqZ17CdN9DKB0NPLyPUKBPlBhCJoY+WquIVQd/dUpMMRT6X4igvTUw2bX8FsUYcgzPCv7EDxZvn2IxKNisO97mUEkWe6F7ipWgm1ipddICuSncu9OGs4KCRu3hFj/Fq6YYzqYcoE5Tbgx07EEe+DPylxqmhc0puncQqLTlEZVL4p1eHVK5z4f3v9bQXM6QIEMPeCNfGr8V4bGO7uy1KdqEFTRDkFRFprBJubkYrBu+SEitrBxnc5FFayYU+cLL7THP+7doTsA5JCmNw6SUm3xCY6WoNyROCkVwdSF1S7mhw7Ly8Fyp97lM/zt1+XMImJJn+VQxv/itiZDlk81yB30HB8mmCYf6+IFYWamxqsG2ssjTI66SrDBbc3PAhl0fYwggk5h2OJ4IFjVyamPLj+VIAKV46TpWcN8b2UEkrVkE9anG1Uww5M3d1d1jBvw+jvCb/3qWX59dB13qE7+r22v8nayBlTeg+0sl5W2RjsvpMNar6kPoo8MT8HA4Af2sR5z4VhKZHxNe09L2AqTzP2VtrstuH/xC5lPSv74Fehm7NW0gy6ZKfVQNaFzCy+fzLcUKqWGMyxZ7u7w3xe3aZ4tN91qXR4Jhu4bQlUGo586Qg+/1vjDjQIyVdFQuogfHJdqHrvSJKMxr3rCHrWg4uh6TXYvfn1e9zOsJ2ggUNzp3bgGE856ONMp20bGiIsA7Mo16jbbk7NrEVcsFKV8eTja5V91X9SmUqn3o1vR367KBBV3Ll51hhC9lxAeefW+qU1kJ8z6vbDsriUEI6vbkUtnMGFrPi1pzTNUjQNsfM/Mxqep/1em4zA6nXbBuWwdBz62gWRSnTfWWDr09tjFL628h2eUbkqT/F
 3bA4GaEI
 4SOwnmJXKSerbuXBTzDewHwsz4DiuFMDLSsr1wiWuneo4lhy36DyX/ThrJ+may/1thumN71QMZ2BJ/XZ3+JcilQw0YKZ2McMqbtyR6VTaY2UuBrpyoAt2Obqz1Xxjaqms88MKPvjdXXSSXp2Uj5lFLZU5GCfl/hAKfOM1Px1b4p6T+cwhxqhhM1y926vvz3BE6kxOBX6PP4X35s4yY4NlRrkoT/GSeWaenFVW1uxC7gE0lb7PvzaJAMTrn7h9ikbZLhtamskVXgEyq2w01SxZiD1wZVuiv6+0VSAtmn0vBxK09MeRZklCLjCbB4BknZlub1Qzcr2wOrKyr7+GOFwG6tMHDOkTRjHFs7X5FBnag3TZwnn4ar7+ImweNPP34hmWlYSu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

userfaultfd_unregister() wakes pending missing faults before clearing the
VMA's userfaultfd registration. With per-VMA fault locking, holding
mmap_lock for write does not prevent another fault from queuing after
the wakeup but before userfaultfd_clear_vma() write-locks the VMA. That
waiter can then remain asleep indefinitely.

Call vma_start_write() before waking waiters. Existing fault handlers
queue themselves before dropping the VMA read lock, and new readers are
excluded until mmap_write_unlock().

Fixes: 29a22b9e08d7 ("mm: handle userfaults under VMA lock")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 669f71d485d02..7e30b5ff17be1 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3991,6 +3991,9 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
+		/* Prevent new userfaults from being queued after the wakeup. */
+		vma_start_write(vma);
+
 		if (userfaultfd_missing(vma)) {
 			/*
 			 * Wake any concurrent pending userfault while

-- 
2.43.0


