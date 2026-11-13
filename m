Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D540606A335
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iyb3feCR
Received: by kanga.kvack.org (Postfix)
	id 79F8C6B05C5; Fri, 13 Nov 2026 16:46:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7774C6B05C6; Fri, 13 Nov 2026 16:46:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E716B05C7; Fri, 13 Nov 2026 16:46:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 369616B05C5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:46:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A093D1401EA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:42 +0000 (UTC)
X-FDA: 85431430644.02.833D35D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD8CD100007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iyb3feCR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YvYeLiyDo2WJY3A7jowQ+v4qJEjUUU9rQqDcUHgwvQ=;
	b=Fu2NhAY9HrDHewbJBbUE09oRCuLlcE67Btqtqch53+0eitMy6XT1t8f03HaSM/lTPUONTb
	SEfoCyiqEUYLO0EyRPi8a9bjUzHGg+P0IeYmrSda4+hX0mvE/AtzRJzIu3gCDNR0DtKZbX
	IUHNj+4st9Xt7JWyfW2MAfrYPfb1Q2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606401;
	b=JqIALXYxDhVuUAEnkOAHghRztc8s6fTWDrtHeWmtEdSRYVe283tVbbj/joBDwLnku3q536
	0txqThnqw39kDNmXF+eQDkdvBO0F5em1KZmMLhcs8GfFFXVKJUyHEmLxisUMw+/hPVkXR1
	8QMkmrtP69P7pGp0Ik0j0T4mSDrUDQA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iyb3feCR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F56062434;
	Fri, 13 Nov 2026 21:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DDA1F000C4;
	Fri, 13 Nov 2026 21:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606400;
	bh=3YvYeLiyDo2WJY3A7jowQ+v4qJEjUUU9rQqDcUHgwvQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Iyb3feCR/RX6uerHZ7ydY0Vp8mGc1Mc4S5Oo3mx1S+Fs3s+tMrTp5fGbvr0AuVDRC
	 ln1q1ur2lgU7rWtBP0weSThEceg7c8E5MCfTZoHwo1UgQh0/CeF4ncuMqkcqglDcTb
	 4hFmURSfLRGsJAOfkobYb+CphFQkkGlvA+g7NbAkT4mTnCRSrPVTg9kAd7vVdip4GZ
	 +h4BrGqp5Rce+I7bEuq6l9wvwDLguSyMik88B8XEURh5Emr0sUEGp8DbqOv1WH8hll
	 XnGTX2Xdg2QTQO5t1aybTRgtpRu+xxRuLW/xf4b+jLT4FJHrcdXCA5kpi7m5V8LkHf
	 8KMyp91i+i8sg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:24 +0000
Subject: [PATCH v2 06/13] mm/migrate_device: don't let go of the fault page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-6-50a2ed382b61@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2811; i=ljs@kernel.org;
 h=from:subject:message-id; bh=r+tXZxpV3ZAyP9/DK+jG5Vk1RL1Id83MUXHpqCwRA1Q=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/z8/0Lm7IunAp4JM1rK3BKUA/R7EsuF/3Wz+ZSop
 K1R1NrRUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIlIZDD89zT5cz3oTsi2i3F/
 HL2/2mzreDxNdv73xmOv/q88b1cT84Dhf7iOjbv976LUMu73DRNe3o646Cz88crzN+/CktYYTrq
 pyQUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: tox1rmyu84atrabr8ih87ngoix4gjzhw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD8CD100007
X-HE-Tag: 1794606400-400363
X-HE-Meta: U2FsdGVkX19hQBaBBB+m11PjWXqTexw3H3Wht3h5v1ipBf9/pXruvt3vVmmW7xwD7JRqvwEo0EAZj/fRg2lbMQeqC+SIvV+8ZKO2WJrl++FcsLpOW0WtumX55RejBw4oOP6MzqPsDv3V9u1KO7b96Qxob3mfcS45PneND5hR2v/tzZicpXjS08NAsNTTkljP/gyMOjilmV5nNS4cQs94zNvRPMar+nVxnP/Y5PzIEA0fZNk00Lbjo37rRLPUTnJmn1oFXxQcn8Kl+5E1r7nyXyDXGrub5R17B9ET/DAXMUMzP3ArOzQfSfeiJDJlnVe2PSwurK6cAdh//lAtZHZOFJoTb3YdkCmuOhbHBAXJmcZbh/YMuf0tLdu4gX+Cq/xWpNMa01boJn0zoKVTC1mNWj0bCaBxC2dhxwbiwRJZk78Ulj211Uzg8KRXxgc7N4ihn1DOimN5vAbMibseUNVTs1pK4ey3bgfDW2/ezUmQzVT/tnld2s8tQHLwApb3bCHVHmLuAZfnWyJuXuUc1AFpdk6O8TJHueEJRieIMKvLfMmKYi65ooasQT/e/ZMZI6svqro2KWks+xEuFtALGf8RC/qHNqNVHv/GU0UHP2EFnZzMnOFOTkmfAVG7mNCPNuiCnLvFbvkGqFZzSF2seQtEYk7c7MgiaFb6nwNNeOube5zPasACKTQd18/PwpS/qWtVF3LzMP/srpxpSBtRoW5w4oXsfWmu8MjkHXxR9gRBLq7obZy1xXnsug04s1TEPpTycD2QakWbdqzGPKZLDFsZqG/LjVlyKWKpceJwC6wXA3jT1nhmxnqKa+40Pk+JVA5Ien1Cv11eZ5uQhl9AI5wf/i6rhjyAIFuCWTwASoDAnAQPysN3DKp+Toj06DOeYOUI7cgmry5flamegAGdbBf+X6QAGNk3jV6SvM/JVg+RxAGTMKJGuVfPnEOqpK2apDYsEhDM0Mrg2DJHNeCvjtg
 jd53Cg1L
 xKDw9RSjpeSYtsyelavY0QSyLfG2ed6tsdmLtGM6avPPx05MGtyqE1DUpZSPy1p4Jd9Gnk9e/N8Rwy5VGn6juUjppuk1DkYaHpJ2ePvxykZ405csZCMWqutehbFXse/6WC5kaj5/Wa5HEWmQWo3/M8xp5R/uA7jYroYsplJpM7W/XeG5qc0zMTt1yifpZnCCYBNU3xKqvrsZke2UGboTTiDV2xy0J2PgKeLa1AiHlxC7e0Pi4d9siWHcUEnggaKxpDgKNhfA/Ssc2jfNTABfGbiSJrYvwmu5ipUb1pa2C6MxVB9CmqtEr0ZirSMIkkMa6canBFxUHlAhI3Q9CVCnqLwOh5ic3AbcsAg2dE3rDUWV2+/fjRRtbEj/eP7nIpaHBNg4hm4c7AGmcBceKvZ4eQO0nrsXxdVHJuChh7sdraysyMsYxK9maSipRac6d6TAKRx2LZHiTpuQCWAzHOeccClRDif82V/kQVznY6AQlikqCipc=
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
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ ljs: tweaked commit message ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
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


