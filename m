Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3E3606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZkIx7WqT
Received: by kanga.kvack.org (Postfix)
	id A8D786B05B9; Thu,  5 Nov 2026 16:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64B76B05BA; Thu,  5 Nov 2026 16:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C146B05BB; Thu,  5 Nov 2026 16:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C12C6B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:32:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10689C0601
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:32:34 +0000 (UTC)
X-FDA: 85402364628.21.E8C4342
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 41E121C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:32:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkIx7WqT;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9gbDgDsUJAtxTTttS67Zy6QBKff1k+BGmZ9q8ms4as=;
	b=8rtJWURYUdWDYjs5ZGIsaXcIDhxcZvRdzadZi1jOMYLG9A4mL6OKPLPlAY7oVU82c3xCzF
	gY2JnhYqwmPiKfnu+Hq5t1sda8SqTQjFXYnQFn7HvBSlStwT0j9ZPtU7BB8+Hzd5bW+hie
	XWImJYSvb0lixDkVfiLXVLG1HsTKWmQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914352;
	b=TgORWXclcT+Y5paq2U5zP4JLeNY6bb/IAPne30YShUNgI1Ebgl7nng6t1pOHtWHBgXQMJY
	GYwx+IstIzyv5iUcmq1h3KSdpKK2ETdeD5QN0LWgMI+CEKwPUb2V1wOfitjQqVOtNQ8C8a
	7c3HPVTOh14e7c2i9EwOsA41VsYl7Lg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkIx7WqT;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80D4E41402;
	Thu,  5 Nov 2026 21:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CD71F008A1;
	Thu,  5 Nov 2026 21:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914351;
	bh=R9gbDgDsUJAtxTTttS67Zy6QBKff1k+BGmZ9q8ms4as=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZkIx7WqTlWLTCBt9NpIoUSUzWdaGj1sZTB/NJl369icVHSJO1jDaGZYx9ZI0V3ngf
	 NS/Z25C5Vs19d6ihk3w8C7/oUqqe7K1X+FB3u7R9B4uFGPgsZ4o0NBNDpRc2THUVb3
	 YkarJXljffQrrFjkCSeJk3R7eEWO27dzmcz7apYY0Nmwm6IP1anOsY1CUhI73l3eJ4
	 CRpGJYjjhMGN2rrNn3vNOs2zqyDLTDI5G6ndMz8NUUszR2XbiFwVcW4PxtfSNJPcO7
	 RIKm77NsGvQDigbGTMtdIKn8KwNNkqm7Sk4pc7DPIzfEkdFiNAbLMI/R2RkXQqgwh8
	 3vRlOOITx0Kiw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:30:54 +0000
Subject: [PATCH 03/13] mm/rmap: convert remaining VMA flag tests to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1522; i=ljs@kernel.org;
 h=from:subject:message-id; bh=eZl8Nv0dTN3HlhfbDsqgjylQKfweYHLkfOK2djhDL8M=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF1mJfT2QdPRhoV88qcu77rHLbdvR7JH9HZHWcvUt
 Zb/rtkxdpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAin+8wMvSLM4R/t0nQTnVV
 f612NLDw5tS57Hc6+SZ6ftJWcE8sW8rwT2vzspehQh9PXindsm3+zgqliazNBicUtrCbn1vpy7J
 0OgsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 41E121C0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 4cndjwskaoi4omfycq6wxogpkbmsqsgt
X-Rspam-User: 
X-HE-Tag: 1793914352-587402
X-HE-Meta: U2FsdGVkX19JbyCB3icuW2ranu42hJDPPaLWOWhcc/wLksa4h3oFvDcqNCgT5zJ9hyWiZgHZ/dq8D5+FuWDdgdqZL5YzO01RX0mfLXb1b8iuc7QE6ECkaJQwkVvMLlSH+Y1sObQaajlXdND3XocxrTxxLy4r9DTW4YvpMA7kbHdJoDXUVuth8ZPXEUHQpaBkTPsyLfvA4tXizQPKf/6eBZl1w0sVJBLkprW4MjkpYphyxfDzblI4En/8Oq6amxNPhvNZqpO/nv5vmuSnhdQHASeh665anh11TreGRS0UeY+uGAU4g/Q1f3LPoFzwBCvlvZ42egtF7v4JKQFZ1dKpM5nsMu/y0NA8ZO8ffyqiJMihKImH6VsD+QXUibGNUYvZC4Uk7qO0kKFBw3tRfIm44W/qr/h1CB8JVb09I7v6f+drzGY3eUT1rTRvnwtM60nTMTNy9u/ctttxbWOA+iKFmlJqNoVaP77QunKhevFr/u7Tev/5r6As3pL03BQmCbkiZwYaEyuCp9DVPo3d0968WjYeQIKcG/GXV2NvmEYPEgdDWDWndUcN82A4HK+rzh8co/r3/QbrWYhHLvOSZvZX5y//fT3gle6DVKC6/schzuGVtyLd77BeLnuh2QTEGjl5q4GcgonnJpKNxUrKAMXtiBj/sGErNCEvepDLC2NEatB7Xzt6RSKJpP+Ac3cKccDIMxpcPHHKJMSDpwZr6rFAQD6OWv1f5UKzBrWA0Ddjivi0BhJ5ilUl4plfLQuUgDJpUKxucFwx6hTiMwZ9MQkEVCmKeTM37xCVoWUiAOstm00DBxkWTGVX2y1unyi1HnhhRy43lWtRY+pab7ohKA7VzMcnojqhNGKHQh4UPykwDNzPkhJ88SsFCDSMgtGA6N3le+FuM30oEod4bSpkaalqOx0DFJxPGYzq/Hy8Afo9WvcZTeLCDms5O7+5y+KZnNRKm7oDGlDEINpk3118g0p
 ogmxqNhN
 OmH2j0du6p2E05YJq4ZERcxg0AdEglSV2R18w1WQME2599hS6Q+GIeNpm7dK5rvq9qymA8e5setWqjT/ln8Uv8kSUQvtedE5HpRfVO/Q+Mlq5jUAJgjZ7H4+g9LpKSA70hNpWPI7uGwUvw9waqZLL5wwxQLjFWLJv4FCwuH/Fwt1tsw6ldF5tvwisrIsVmVcM/WzLDo/J7oOhkgOAI/mg1DchgaHZoa436PaT/6vbxGr8BWEogFJPYXgiWzm9od06HKqY/rVPXKF2KUwIRXUj/zISkZitheFH4t4yOdbvke1yKcvjGtLrPMp3Dwm1lRZ2Cx7EXEd3k1FdpAlCW1HnGr7hYvy48BKz0mcJkN6pL0XCrwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace the remaining uses of the legacy vm_flags_t flags in the rmap logic
with vma_flags_t values.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/rmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1131b76bbbc2..cdc97fec8586 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1196,7 +1196,7 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
 
 static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return false;
 
 	return true;
@@ -1660,7 +1660,8 @@ void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 	 * VM_DROPPABLE mappings don't swap; instead they're just dropped when
 	 * under memory pressure.
 	 */
-	if (!folio_test_swapbacked(folio) && !(vma->vm_flags & VM_DROPPABLE))
+	if (!folio_test_swapbacked(folio) &&
+	    !vma_test_single_mask(vma, VMA_DROPPABLE))
 		__folio_set_swapbacked(folio);
 	__folio_set_anon(folio, vma, address, exclusive);
 
@@ -2094,7 +2095,8 @@ static bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
 	 */
 	smp_rmb();
 
-	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+	if (folio_test_dirty(folio) &&
+	    !vma_test_single_mask(vma, VMA_DROPPABLE)) {
 		/*
 		 * redirtied either using the page table or a previously
 		 * obtained GUP reference.

-- 
2.56.0


