Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FA7606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXIUP+Mb
Received: by kanga.kvack.org (Postfix)
	id E54776B05B7; Fri, 13 Nov 2026 16:45:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C746B05B8; Fri, 13 Nov 2026 16:45:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42956B05B9; Fri, 13 Nov 2026 16:45:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4F566B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:45:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD4E840157
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:45:52 +0000 (UTC)
X-FDA: 85431428544.15.5E4079F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0837B20003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:45:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXIUP+Mb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606351;
	b=8qsrPQGix87WbsSkuj3Y46QfJRFNfWQDKzC3jvzLFphPGUU1gVxNpUrFY4QjZBVwFqpDWL
	p2hZ+ikxS2pLKrVuX5wdX175C0YWIrFHjZj8L/kXIxcsOY7JX3bMavVYMBLDROjduFyaHN
	EAPtUpYyBMeNj9o+QsB5rbzaLmFa4ys=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgUeD2OkgMqdlzQH1t0tTDMBPVlxaf4oY8m5ckbOO0M=;
	b=rK/78S4nM0FRV8itQNMLQ8bT1ymMncz14p/Bkh7xqjsRmhRwOdhF7MuJw+2Ce7tuBu2xiO
	4arNyDedt//rVdvsTwbRVEd4+XLIZRIPmtUVy4HTlHp3SNytQ51qFSVuwSM577weOIVO/E
	QRl70cIG1DX5J5yOr4CdnAkkzqthrnc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXIUP+Mb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83B8F62B93;
	Fri, 13 Nov 2026 21:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DBB1F000C5;
	Fri, 13 Nov 2026 21:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606350;
	bh=tgUeD2OkgMqdlzQH1t0tTDMBPVlxaf4oY8m5ckbOO0M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WXIUP+MbGYgY8WkluriT5V941F9mGcyzgyz4ZwegCQUOATBrCUVKn2eSGzyNlPh+S
	 6l/QDGlRcmALMqE2FjI3YH5S7NZLg2rncLUT2UKbzy+IizCywVssa7GBYEfTlSTYHO
	 sFdcXu/6zmXnVBxVqFIjx9bTzzwYZoZWWHx8+6yBzz1QxjlLa0u1b3EMEZ8o6Vk/jk
	 Gmg6VsktRQ6wUiaIyHTAdMixA6D4uy1cn6DXkJbf14ovFcfkaxpKcETrvTk/t9Bvlt
	 6TKBkda2q+wPFkRKbvcUkvt8nbA6UZ8ESZ8ZifoYJz3mzNf1jPtjfuDDKvp1y0mL2g
	 ch4XvYd92FBCQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:19 +0000
Subject: [PATCH v2 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-1-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4364; i=ljs@kernel.org;
 h=from:subject:message-id; bh=8x8meuO1qhGN77hxGuh4qyBOF3+aPhUYnTt1ixD9eZU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/zYcinW7iafSlX5pR+xumxp+75t+hv23bjTxTD/d
 XzO4dlNHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgIRwYjww8OmfkMycor3xZZ
 2rCLHdwlWZE8a2XL0iafMuvLV3a94mRk2NiUummq+goDKdsPVf/vzTdicZt8MbhpzZeX0dyVqaG
 Z3AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 0837B20003
X-Rspamd-Server: rspam12
X-Stat-Signature: ytbuyatuddhwurbqo5sjnfkju5szu8ar
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606350-404136
X-HE-Meta: U2FsdGVkX1/aJGKcGs/nbOv9/seFiqoB0034Ce0aXKiQdvbBQoY1MorW7rVGrXJULGxiKBl0Q6rkVi12+XdVuZGOx/5kWTZnVcG4yAv+Px1QdprMccq3SYV3w+gAwWB/z90vwkq65CyCo3MqdTh2Z2TB7lRrZkAjtwYNrRK5U5odtUUeIS25hFi8ELZbmuXtUMLw6ZbuadwvUL0S6vK5D9aJaj8ZjimS2sbN1lIyxTEUNANA9H/Y0EAC0LQv3or9LRodtYjkdIPMQjSUEtU7gp+q+LnduXB8ZJOek+gTZhStIDsHNcTxS3sCjuyByU3eilbbfKtlH9NcsCMZ8bNjRvOZ0Glhp6mEHNR/ylrYrGO6FXN5uXd6Zs8H0BSZuXQyR4oq6ZHXC6+p3syFqcXuWLf68MLP32uKi9pMYAgaoLMYmQ8uf3lESSV+AhEgvoU1zBN+JekP4MIKnCWgsiO4sbjBBozBSz1IJFSETZqD1yeTNSiTuqf2ikLihcfaF51pNBIDxg4RIo4lGqKjlF2NDxFygGUTHBhH9y4ovV/01rJzgC4Xbcke191mf41xR6qbVLwVOIdKx0jS94mH4QDrW91DcVZREAOe8CyK6qU5mLBPrXY7nC6lCZMncPmsVLGNCP2x3JdqPWBaY9QQXgctE4XzFBTjzX9Fahc8eBpBd8k5/Ict/Mbl5cqI+pSE0srQkg6YX8sopcYSnDb4uAJPNUl6i/3AsNzfpGPV16JnFQwPHJHrRApZsGq02LomPQXFJ/RKVWlnvwVFHZz4PMfBb84JRbExftqegI5SXX7ptutXCotYwi+N0h47M62itnOGS8/ukiK5IiMwARlL8guM5ZB+L0uEJZ2NU12gRsu1qoFBRXl+EwYUA0U/a13TLrL3ghmI2EnLp4Iq3I6n/gq33Ii1lTL86S6LsxtLy5YVmazHz6VV4KpTGuiTII9gRpf6tkm60QtTt2IJ21gYLc3
 bY3UzQdw
 hSzPahr6Cz8OQQE3+DUiDqvc89bt3qXLWC8lTWrKgdLKUjwtWFAeY7ZC/ReomxEjn5ylgZQjOEYhvl+67UaszMObu771gvAnacVFba8JhauVntPK9JSHvECYM06ecw5yjZmD9B9owZlRyOuLZeIflzhuM2P7oD0J4Wy7BzfUHwoyW9z8EZrsMx3yVRiTPIZIkpE/fc9ZZEV4sayyXcw9pqrRXmNdvOAuCTZvEYqcf/krbwuX7m5hUMKetyKN9pXw+9JvYY7sGqibN3rmm6IngxD05cZIBDV/zznstHwix4zUeHqHuUotQf3I0+2n7iAWXaB2dILUYTIhAa58k2d4WecjpPlQB+CFJP1+hqy/QxRGcWAnateobstxuHzDzYqn2py5lJnU4nchOrcN3qW6sO+KVzbaTNdtHT9my2rQ/9QHQJXDriXmeNjfKk5ppe8P0yZkehxISyDiweF8SV2kei6C4bPHpfTsFQIA0cvHVNly7HjGUiQo2r6gvJ6tHQAmAS9UbzrQgcxWzHvym4Tm706Ke7ZmAp7bEjZ3xJccx5tzM3JwBSn0ok0yNKBOGaKzSdSFG1FVAiqUzWenBtMNN1qPQzfyUiqRhSjNHl6poEh42PnWvMam/qXKD/ZQzoklNMqXG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The OOM killer can quickly trigger again after having selected a
victim. That victim might not have freed its memory yet, but its mm will
be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.

This can cause the OOM killer to kill an innocent process when the first
might have freed enough memory to relieve the memory pressure.

exit_mmap() marks the mm MMF_OOM_SKIP once unmap_vmas() returns.
However unmap_vmas() does not free the last batch of pages it
gathered. That is left to tlb_finish_mmu(), which runs after
MMF_OOM_SKIP is set, and the batch can be large.

Fix the issue by freeing the gathered pages of an OOM victim before
marking the mm MMF_OOM_SKIP.

Note that the task which calls mmput() might not be the victim - if it
took a reference on the mm (e.g. ptrace), it may hold the last reference
and release it when it calls mmput().

Therefore we cannot rely on current to tell whether the mm belongs to an
OOM victim. Instead, partially revert commit b3541d912a84 ("mm: delete
unused MMF_OOM_VICTIM flag") to reinstate MMF_OOM_VICTIM, which
mark_oom_victim() sets on the victim's mm, and check that.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: bf3980c85212 ("mm: drop oom code from exit_mmap")
Cc: stable@vger.kernel.org
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm_types.h | 2 ++
 include/linux/oom.h      | 9 +++++++++
 mm/mmap.c                | 9 ++++++++-
 mm/oom_kill.c            | 4 +++-
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ed35d258d2e..09e63ff12b04 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -2030,6 +2030,8 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+#define MMF_OOM_VICTIM		32	/* mm is the oom victim */
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
diff --git a/include/linux/oom.h b/include/linux/oom.h
index 00da05d227e6..a9390cb70541 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -76,6 +76,15 @@ static inline bool tsk_is_oom_victim(struct task_struct * tsk)
 	return tsk->signal->oom_mm;
 }
 
+/*
+ * Use this helper if tsk->mm != mm and the victim mm needs a special
+ * handling. This is guaranteed to stay true after once set.
+ */
+static inline bool mm_is_oom_victim(struct mm_struct *mm)
+{
+	return mm_flags_test(MMF_OOM_VICTIM, mm);
+}
+
 /*
  * Checks whether a page fault on the given mm is still reliable.
  * This is no longer true if the oom reaper started to reap the
diff --git a/mm/mmap.c b/mm/mmap.c
index 7618e72766a5..4cb18b217048 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1313,11 +1313,18 @@ void exit_mmap(struct mm_struct *mm)
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, &unmap);
+
+	/*
+	 * Free the memory before marking MMF_OOM_SKIP so a re-triggered OOM
+	 * killer will only skip this mm if it's already freed all it can.
+	 */
+	if (mm_is_oom_victim(mm))
+		tlb_flush_mmu(&tlb);
 	mmap_read_unlock(mm);
 
 	/*
 	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
-	 * because the memory has been already freed.
+	 * because the memory has been already unmapped.
 	 */
 	mm_flags_set(MMF_OOM_SKIP, mm);
 	mmap_write_lock(mm);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5d48bd862c27..9de57a23893c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -752,8 +752,10 @@ static void mark_oom_victim(struct task_struct *tsk)
 		return;
 
 	/* oom_mm is bound to the signal struct life time. */
-	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
+	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm)) {
 		mmgrab(tsk->signal->oom_mm);
+		mm_flags_set(MMF_OOM_VICTIM, mm);
+	}
 
 	/*
 	 * Make sure that the process is woken up from uninterruptible sleep

-- 
2.56.0


