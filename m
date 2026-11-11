Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D20CC60A2619
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DnPJqPlu
Received: by kanga.kvack.org (Postfix)
	id 06F626B00EF; Wed, 11 Nov 2026 13:15:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E8D6B05C2; Wed, 11 Nov 2026 13:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50E76B05C3; Wed, 11 Nov 2026 13:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2A5A6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:15:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C146C03DF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:12 +0000 (UTC)
X-FDA: 85423640064.02.943C604
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7459440018
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnPJqPlu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420910;
	b=Ty08a20UWNJVLvCcB2Z0fxC/O6F6Z/F9ow5eoic3TUUe2NRMqnjIM5WyUx15icr0NlRuh7
	A3tsQKDtQcRIehHzJ0TSch2FVQAsLW0ASEv/qSuUwdBT1qcnKn6gysM5rz3iC29PqqElJx
	1pVP6FsV60q3GMzvDyMYNUNj2fLjp70=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NaCGdAZFU1z2YSGcCoqnUOLBqNj5/a8OsE72YWxUAAw=;
	b=0yjQoKQQvd8Cpe1rNO7O9VT073UjvFMUf7taDFPe6YKzaXAlNMgr4hXBmLvEOIqfXLpeiY
	PCoNEzWJdceGBvFrml3ZfGozpl1u34r9mITIyIdbwC6H9Kk/aeOMg+adVT+EaeXy1EO7tm
	VSTTNgsSXoHSsLaRngQPJVq0DOvpR5E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnPJqPlu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2027435BB;
	Wed, 11 Nov 2026 18:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BA91F00A05;
	Wed, 11 Nov 2026 18:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420909;
	bh=NaCGdAZFU1z2YSGcCoqnUOLBqNj5/a8OsE72YWxUAAw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DnPJqPlu4G7knZgeHK4wye/RZiaNpcz1rdYnJCH5Se8RJTolf+zsB5C0WYDsPiaKp
	 NtNncTGwbiM3I+lHGCpYN+ZuKR7AVKoCIr72MLOehDdubOkD5r1vpnYdjUUNyzwjBZ
	 VP5p1i8f5XfSaO+eqNMpTEy/olsQJEjokv7GEOYrMDswpURevS6doBi+Vlc7UtPtET
	 b0fNxuqAnm33ZuTrlAbzJv8SNNPqmIAa+FlGwNq/uWwCfShq+P6wapgt0EuaYAwqgp
	 Q7EkYdhTY3uIqfMJOCHHJxttp0vv1bhrWU4ThZxRlHPbb5euj42t+ODQw2FJNTHMV0
	 p2pEs8ac20RQg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:20 +0000
Subject: [PATCH 06/13] mm/migrate_device: don't let go of the fault page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-6-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2760; i=ljs@kernel.org;
 h=from:subject:message-id; bh=W+/JIRCjXf8mo6Ivny1TOt/IqNOFsXqGJrUphYME/e4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMi+HPonq1B9CYvOzr6G64tX9q1xWX5/S6b+zSNbt
 KYbsEamd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiB7Yy/I9vb7gcLi00xWP7
 JiPxCi+O1G4Gln9OT1POzl3t5PdT4yUjw6qr7stSH+xPtUwVnhi3JWSWBL/KNcluG4ONf65eCYp
 axQMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 7459440018
X-Rspamd-Server: rspam12
X-Stat-Signature: 4k5p5sc7aoq74zj615gqniw7fwgku1gq
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794420910-618179
X-HE-Meta: U2FsdGVkX19Ix2RnPD/JYQJb7umCz1ZyS5U4kt7LPHCQgAozdjdRv9I/9kOqK6xNQhpwlx6DwlN4Opn2w73YkTppF+Uz+iC74u5kYRa7DcdEGJoPiKUcQyrezIjMmlktRZ4lXEZgMXkjimWXlIgKl/y3lPS9aIUJBsxlYlB6IzmH3eU1YzH3dXpLZXBiHvvB+U90EwOfGYBjz5jKZRqZpOBqVQ99Gsi39COkHURVPeFMQ2xF4preg7AtqdlTaK+Vg03cjkL9tEBYDcU9a+66McZoQlvUAEHzHwS1udLMlm3T+LnDM/EDRj/PSDE7u1oJZa7EHkNCWM0F47yEjqykfkrSf90yC2brcLBsaggEJrZvWc+5z//bebKIynCaUkvFwEGYOjI/fa6C4ljSuqzTvejvVnmWmYgY+nOIy1gKhNcN/Zb6i9TMyLn97i40rQ/BUvYbm3wQPiIRntn3oK4sacM0sh5iVh8v80M2hPyqYVBcgUQoSdBo34WPdngo4HmSTg5yxXiUo78tH4I6kg1Cl/4UXGPyHY9T0vk9TfsmKvgHgXVe/1L6VEPA5PVcb1p9QKts8O57CH9oD6kWU9DHjMSsetkOuxiCZiIKctkeOYkN5QtDoflhfduZszgNXDTBkIZoH0CoSQNWvj5s2aCOxRWcWPXCt4bMovpCQ2tvMQDPFfAlxd95R1vH4xQQ9e6FkFuJldv6cOS/TC6nADp+edF4AsEO4kxc5bKfdQOyLdzT7bGQoDWFuz9XYKmAZ0U4Fffz4aBSb8KAj2Rw31rmRUNQkmHgKqO3SCX20w/EsEUodawjomSUBtNC7mxIygetGoC2EGz+Ze8dnGfvWjHo6gNbpS3XHuavaQ0x0VQfKv2/7JPpaUS9x2rsjmu8l9sCBwxASXoMZ1kKaMcuwSohXczecfSVlWsIHhxuivc8PmBrw74tWVV8OoB1j8i6+77j/ad4ZZ34YB8Tn2jakfv
 lH9YA7L1
 prmtqQlMgmRo43HlNyVWu94ZFXu0HfwdVnOGKIDR8cD71SVxu+gTQAgfEWl3aGbjHHjJNvFWuBRnfuiJFtczYZFY01J3mo47DwSNpquaca99SyiXgaqRIkUrBwYqhqebh2Cwa33gAgD3WjvZSF0w9tFNCTunADYGhGcMcaZmytY+aVV+ANEobl8ihJ7lN71mqHBCbQHQ3vd4AnHacpkQlXxL69LWt9gmNzpNeNou+4Hi1K5LpEKXuFhul2BfY8fHPwX42kpJ6vIvT3RZPMjWLQ8jtlHco53MXcxWURuJvcDI4pnEUATpvALhYnjmS1iLlY6rS28dXsJCg+Q11OIpXKdKuMrtQE4QU7PFiW/mL0r++nWZcnG8QbzknbR+kptWSx62EOiPjWxxwMl27ptBYkL0Ii0go8kA0I8h5NRpfIcsljUffe4bava3MA2tp0xFpKcQvyKqbwfpu8RFlw3QzIsdXIH3Z668R6MUWOsMnN49F1/l9sMvqhxehPFqLLAW9DGZiZGND2T1smD25rfNVWECTJqxdNI6gF5J9FdoaxhJwyLdmDpGeOac+JFjPc5N+5ufM4SLvjZD/1Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

When migrate_vma_split_folio() has split the folio of the fault page,
the lock and the reference which the fault handler has taken are at the
former head page.

It then moves them to the folio which now holds the fault page, by
taking a reference on and locking that folio, then unlocking and putting
the former head.

split_folio() has unlocked the new folio and has dropped its own
reference on it, so until folio_get() nothing but the page table entry
holds it.

Only the mmap lock is held for read, which does not prevent another thread
from zapping the entry with MADV_DONTNEED.

If this happens the folio is freed which results in folio_get() taking a
reference on a free device page, which the driver can hand out again at any
time.

In addition, folio_lock() can sleep here with the lock of the head page
held.

Utilise split_huge_page() which will leave the lock and reference at the
fault page correctly.

Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
Cc: <stable@vger.kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ ljs: tweaked commit message ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 39 ++++++++++-----------------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 28ed706109da..ae795fdf36f4 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -87,39 +87,20 @@ static int migrate_vma_split_folio(struct folio *folio,
 {
 	int ret;
 	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
-	struct folio *new_fault_folio = NULL;
-
-	if (folio != fault_folio)
-		folio_lock(folio);
-
-	ret = split_folio(folio);
-	if (ret) {
-		if (folio != fault_folio) {
-			folio_unlock(folio);
-			folio_put(folio);
-		}
-		return ret;
-	}
-
-	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
 
 	/*
-	 * Ensure the lock is held on the correct
-	 * folio after the split
+	 * The lock and the reference of the fault handler stay with the
+	 * folio which holds the fault page after the split.
 	 */
-	if (!new_fault_folio) {
-		folio_unlock(folio);
-		folio_put(folio);
-	} else if (folio != new_fault_folio) {
-		if (new_fault_folio != fault_folio) {
-			folio_get(new_fault_folio);
-			folio_lock(new_fault_folio);
-		}
-		folio_unlock(folio);
-		folio_put(folio);
-	}
+	if (folio == fault_folio)
+		return split_huge_page(fault_page);
 
-	return 0;
+	folio_lock(folio);
+	ret = split_folio(folio);
+	folio_unlock(folio);
+	folio_put(folio);
+
+	return ret;
 }
 
 /** migrate_vma_collect_huge_pmd - collect THP pages without splitting the

-- 
2.56.0


