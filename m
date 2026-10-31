Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A61D606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=B9nsVoQ0
Received: by kanga.kvack.org (Postfix)
	id 5DC9D6B05B6; Sat, 31 Oct 2026 06:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4426B05B7; Sat, 31 Oct 2026 06:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3136B05B8; Sat, 31 Oct 2026 06:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF426B05B6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:35:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A223916090F
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:45 +0000 (UTC)
X-FDA: 85382565450.11.C823EA9
Received: from outbound.st.icloud.com (st-2005b-snip4-11.eps.apple.com [57.103.79.23])
	by imf07.hostedemail.com (Postfix) with ESMTP id B31D040008
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=B9nsVoQ0;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf07.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.23 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793442943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMQ5rkZkdm3KfZdw1UPbqupcNAtLUin9ixCalXTmBXY=;
	b=tAJSbUUGs34LBjC0j1y4/qDkN2eCI3vgSouFdCrzBsQsXWqyAB6RX84k11qkxgEqONo5yy
	jZOs8YOt7lgHqV+1Ikiyf49OKAorAWDP6HdiSbPk4sy7DKHnhn2Dm/RNUxBrzHuZUazlTF
	uN5sGBnuJPj+nOpBnoKVrE5xWNb2eC4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=B9nsVoQ0;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf07.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.23 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793442943;
	b=rrknUjiFT5e90eablIqVxbCmt/5U9OVH5M38wrX2bokc64obxAvGNMtDkQzd/0M2ZtzCZx
	DF3naGMl/6rXmQojC4xXt/S/MCgMtbezfYWhlIhkUcHCn4UyRIv7Kj46UkCOmGhgWgKRd+
	CAE1b0o5YuxPOdwQ8BcqLjs3UXGIHIg=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id DC24C1800293;
	Sat, 31 Oct 2026 10:35:39 +0000 (UTC)
X-ICL-RepId: 01a19187-839b-746f-9289-dbbc02d94298
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtJCkMGXwFeCEADQwZbC1BcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAZcEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKVwBAC04CXQRaHxJYDFAFGh9eEhQeXxhEAx8GD1UAQAZSAkUKQQteDg5XE3kMVgNUDlwEFxtcAAlLRglJHQ4EVAddBV0=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1793442943; x=1824978943; bh=mMQ5rkZkdm3KfZdw1UPbqupcNAtLUin9ixCalXTmBXY=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=B9nsVoQ0steZIfz2Y32E7nJV5NP+B0C4+MxUDKTrgfqaSguYupUKcdr/e3wBxmp2PptFZ5PoRY9jKrHaYOHoprM7/LNM9oYk2duGmDNwfAv09TpSLRiisGmUzjROkBFN9m8WpzVOhOziSLcVElPbgeeJKPdGzHoLFfIfdPe4zCzrGWcEYL5mVAqZBMQlerUl5Epu+aXXsz2xfxg47jSMMWrFcvBqgzXN7kbtnauRIBxwY9L/aAWbQNN/lTxlrhooDkwUDuRa59LabRcVmmOP9ZaSeT/NTGECHM5KLbGTcD4srViArIJhX0O5OpdyjyNc9/aom75VBJ9MCah4O7kpEA==
Received: from [192.168.5.15] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id 85E55180028E;
	Sat, 31 Oct 2026 10:35:31 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Sat, 31 Oct 2026 18:35:10 +0800
Subject: [PATCH v6 3/5] mm/vmscan: extract folio pageout from
 shrink_folio_list()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-batch-tlb-flush-v6-3-190539839eec@tencent.com>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
In-Reply-To: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA0MiBTYWx0ZWRfXwymSmREJcCGd
 BI7OVdonGcOuDP4kYgO4RwOOnYI1awVALgpvnyrm7up6S2D5K2VfXCbFe1gLiOStKioX62t6LvF
 z8T97cimM1FGeGr7w1n3zxvGw1BE9l23/C3cZAzC2qr4CcuSt2FKoolNF9WpSG79d+xUihxCeKh
 edi16D0P3+6GEffN9kqyZ+jpYfNoY1N5KxP0moO41EYuJM8NjvWPEsMsm4/XEFYbreyNchouLZ9
 fVY1zi7GrykRO5KAbdm8KNTPxtQuxoBRHtLbHMXbnfbvRTfo7d2QYdYgQyZHr1sLjg5Oh7Vpv08
 TJX/OBtZyRD8h7ZrLHwcsAAFRan8F/xTW7sVM6r/dkSWceKo5g4Izumn90D3AE=
X-Proofpoint-ORIG-GUID: 01U2c3acoAQQN9Ai1jAI3Tcwx-5X8OWZ
X-Proofpoint-GUID: 01U2c3acoAQQN9Ai1jAI3Tcwx-5X8OWZ
X-Authority-Info-Out: v=2.4 cv=TZqbdBQh c=1 sm=1 tr=0 ts=6ae5c47d
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=qi0cjtEbl7ftujh0onEA:9 a=QEXdDO2ut3YA:10
X-JNJ: AAAAAAAB1R38cbLzfbycO7rQxnl1oTH2o+pk4SqoDVkWFXZAHpOKBDVR96BRKfvrnDvrgq
 7xyT5cayYESLv8Za1L9HUQoopxZdFd/fYI9P+ID+IACqm52q4u+xcg4Sm4du3OB8/jopP/
 eK2MksS042VXHc047wdx8KuUp/39VBHXxLDaLXjsQXhx0hQipW9MVlzBl2ZalAUAeCMHT8
 j2xkYyqH7yD4myLxs5W7w+fU4jlgjpO4B17NkckZsp9lc1jtzfuHhDFbrhly0mqLmF3rMk
 4P8YwNVVMADwrBtCMGbIElWW9dcJGXgG66IoBagi73CZ3OaGrw0sE6tKY1gsGx7xTHLZfA
 T9nzZdgSEwML4nr1mMQivChpWAxNOSMQj+5pxH5ucdGgRBAkT+SHz3Lxs87qUNrnscSjFj
 /iCsu8T2pobhTJ429S5rlqgyXOBZIQxOqJoR/uYcz4JxQBiVEG4RMde3IqKpw5eY4VC3cH
 rMswfE8XSJvU1UUq/A1Sz/rYDYPto2lr6ijsL/7bQH5kOEvddnFl46w6gtxAJ/PIXzM12+
 +SUDO8yh0qTgsschCPIrYrj831PxaUVRC7YebVSXKAyBZ4vT5LLoeAY8ba3ElH8wSwsZqL
 prGO4e958cwXhLGAZnGOJ1SLR6bG2x/AZyP/uhCOulkiN8iOGF6mxRHpfw9b2BVqH047OG
 F/ToIOM/e3IhnlsgWP0TO5wli9cCZAX9V8eugELlIoQqvrGDrRtiIteBxwHZtoECtiPfnr
 cBFNwyR+7F7c+0aCISGPF5q+m6x5GRdBdFz52s823u7Q9/qqrDt5oS2RgxqNnj8gqT06XV
 NVHoK0lZgGbi8M3pk7WdPUaCF4Gl1cGKXIqeY1MIujqMROodxy23LFH+lSeeSdOLYS1QzB
 tJDXoRFVsYnBrqiMk6IR4NBZUIVv7+UwllLW5WElJGxmp5784ThTQ=
X-Rspamd-Queue-Id: B31D040008
X-Stat-Signature: o7mtth675xtoeitdkrhq7w77cuptkaj5
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793442943-902973
X-HE-Meta: U2FsdGVkX19FEVZwzwSMaMJocXKRoo27lUASmjhw7GJH5/mjsB2A7bthzpAFF9aWqkOIAJVsT/TrrB0Yj8+5Cq4ou3x2xS+XuNRNU5kW8BZgR5lsPVMH5c0sZB04iR4COWtG8YygqZ7+4a1Px+/N0ZnVJexgyvf+iYvIG8sIiYnF7phka3galJNRKMdrkh38i/RfGd/Bkrx26L3bKNcTc7gyhfFtWbLhnOLmO15/yALZKH2fA7TQIpcJ4mVm8QI4tx/cgkEdK5qcpfEjWMp4VhlTgAfPO//0ZnBRTMaagsxC/a3/vkRKVnHF7Cd1iONh0T4YpnYVtyLkM2f1nJ0/ImwqRzsHPsZ0zfYdybHbwOtJuFCJ3IfNtntF/Odi7cbRQoG/UhCuty5slq1WklgnX6EHjwT0tXar95mDslHRhnUrBnC/us6yeZ2AypwHOb7kMlBqzW3z+W6AX/c9UbBwFRwIImEq3kAnCCSpNaCfggAbnRUE5XqmMfpV8nKuUiCNVFQAkAlG+lRpCLCBlDFaHclt4RnrEtkKnAhESE5XKsHcaR3WAOV4hRHfBvp+Ekhro2RiDhAg8Z7ttPBdtoIhOjitKMPcIZ2P4/2eQuxgkoufLy0kNgwya+211KXeAThjUMfrb2VpwiNE6AYp+cMqlZnKoOhF1O3u+enald3EErKwTnrZnX6AaAP2G5qer8e64czkQcgM3rwP0Fy+Lut7lr0F8q3fqAiHM7q98WEMXuAsgAylI7faQUfqS+LQlwf/HhEOeuE1Qd1txbk2RmMQTTkzRAd4nCrZqvia6zNAm0OphosSIZfj5lAiHurMZm3ktKffi43P0NGqNnKR2rHlULM9KpMeWRBP/LVSjZSrEo5/GOqy1A0frGiibNqJ+fv7Esa6cy4a9E1SCasAWQzOrlvEnVdZTs8XW1gg+nxnH+9LYU/1udcPZeCwNR3aYWxPWnJEr45t44qHXLHR0mJ
 JeG7YHx0
 VfwWf612Df8i6N7HyEquKOtt3BNZnV6twlcq2vSoZ6ZLv6WyPJc+WTXNdsBUZc1OZkZuZ2T+IeJRkbOx5Km/7Tf7VkMdchmn2Ru6IrXXV9RdIZXEzV/YlwASSb2+haWi0+ZaZpf8XW2lFuAsubV4Xhibc9tlhVH476SzSpZd72d62ykz22ZKUui3fQZi83PL+ngwxIjer5Xp3TGzRlcxFHMiLIFoYY7mAoK8/8Yt0JaXwZ/bH+vMXmlnjOZUa8pS27frP8GhL6gaJnpXHAHXy11pOpVS2Y7ylLi45lK4cwET464oIeR4wafO47vsW0mKTmLvJAYrGBJcCwqZEcRcPfbxGIAycaN7uSGR2hvlc5LyX1adIBHlGH2R+cEwJ1AbRz8dh7bEL91VG6J3Nxzbf3hBUsOR24earViR4lkJFdLFuj3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() contains a self-contained pageout() dispatch state
machine. Extract it into folio_try_pageout() so it can be reused by the
batched pageout path.

Return an explicit pageout result instead of a boolean. This keeps the
important distinction between activating and merely keeping a folio
visible to the caller, and also records whether a kept folio remains
locked after pageout().

The clean and synchronous-write cases return FOLIO_PAGEOUT_RECLAIM: the
folio is still locked there, and shrink_folio_list() then runs its
single folio_try_reclaim_free() call, so the reclaim-free step keeps
exactly one caller.

The PAGE_ACTIVATE arm no longer normalises nr_pages to 1 after a split:
folio_activate_locked() derives the count from folio_nr_pages() itself,
which is equal by construction once the folio is order-0.  Note this
makes the patch depend on patch 1; applying it alone would over-account
nr_activate for a split shmem folio.

No functional change.

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 105 ++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 66 insertions(+), 39 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9ac125f2e317..36e3f0829f08 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1277,8 +1277,65 @@ static enum folio_reclaim_result folio_try_reclaim_free(struct folio *folio,
 	return FOLIO_RECLAIM_DONE;
 }
 
+enum folio_pageout_result {
+	FOLIO_PAGEOUT_KEEP_LOCKED,
+	FOLIO_PAGEOUT_KEEP_UNLOCKED,
+	FOLIO_PAGEOUT_ACTIVATE,
+	FOLIO_PAGEOUT_RECLAIM,	/* folio is locked, hand it to folio_try_reclaim_free() */
+};
+
+/*
+ * Called with the folio locked. All results leave it locked except
+ * KEEP_UNLOCKED. The caller retains ownership in every case; RECLAIM
+ * only allows a subsequent reclaim attempt, it does not free the folio.
+ */
+static enum folio_pageout_result folio_try_pageout(struct folio *folio,
+		struct scan_control *sc, struct swap_io_ctx *ctx,
+		struct list_head *folio_list)
+{
+	struct address_space * const mapping = folio_mapping(folio);
+	const unsigned int nr_pages = folio_nr_pages(folio);
+
+	switch (pageout(ctx, mapping, folio, folio_list)) {
+	case PAGE_ACTIVATE:
+		/*
+		 * If shmem folio is split when writeback to swap, the
+		 * tail pages will make their own pass through this
+		 * function and be accounted then.  There is no need to
+		 * clamp nr_pages here: folio_activate_locked() derives
+		 * the count from folio_nr_pages() itself.
+		 */
+		if (nr_pages > 1 && !folio_test_large(folio))
+			sc->nr_scanned -= (nr_pages - 1);
+		return FOLIO_PAGEOUT_ACTIVATE;
+	case PAGE_KEEP:
+		return FOLIO_PAGEOUT_KEEP_LOCKED;
+	case PAGE_SUCCESS:
+		if (nr_pages > 1 && !folio_test_large(folio))
+			sc->nr_scanned -= (nr_pages - 1);
+
+		if (folio_test_writeback(folio))
+			return FOLIO_PAGEOUT_KEEP_UNLOCKED;
+		if (folio_test_dirty(folio))
+			return FOLIO_PAGEOUT_KEEP_UNLOCKED;
+
+		/*
+		 * A synchronous write - probably a ramdisk.  Go ahead
+		 * and try to reclaim the folio.
+		 */
+		if (!folio_trylock(folio))
+			return FOLIO_PAGEOUT_KEEP_UNLOCKED;
+		if (folio_test_dirty(folio) || folio_test_writeback(folio))
+			return FOLIO_PAGEOUT_KEEP_LOCKED;
+		fallthrough;
+	case PAGE_CLEAN:
+		return FOLIO_PAGEOUT_RECLAIM;
+	}
+	unreachable();
+}
+
 /*
- * shrink_folio_list() returns the number of reclaimed pages
+ * Reclaimed folios are counted in the return value.
  */
 static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct pglist_data *pgdat, struct scan_control *sc,
@@ -1596,7 +1653,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		if (folio_maybe_dma_pinned(folio))
 			goto activate_locked;
 
-		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
 			if (folio_is_file_lru(folio)) {
 				/*
@@ -1617,50 +1673,21 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				goto keep_locked;
 			if (!sc->may_writepage)
 				goto keep_locked;
-
 			/*
 			 * Folio is dirty. Flush the TLB if a writable entry
 			 * potentially exists to avoid CPU writes after I/O
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(&ctx, mapping, folio, folio_list)) {
-			case PAGE_KEEP:
-				goto keep_locked;
-			case PAGE_ACTIVATE:
-				/*
-				 * If shmem folio is split when writeback to swap,
-				 * the tail pages will make their own pass through
-				 * this function and be accounted then.
-				 */
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
+			switch (folio_try_pageout(folio, sc, &ctx, folio_list)) {
+			case FOLIO_PAGEOUT_ACTIVATE:
 				goto activate_locked;
-			case PAGE_SUCCESS:
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				if (folio_test_writeback(folio))
-					goto keep;
-				if (folio_test_dirty(folio))
-					goto keep;
-
-				/*
-				 * A synchronous write - probably a ramdisk.  Go
-				 * ahead and try to reclaim the folio.
-				 */
-				if (!folio_trylock(folio))
-					goto keep;
-				if (folio_test_dirty(folio) ||
-				    folio_test_writeback(folio))
-					goto keep_locked;
-				mapping = folio_mapping(folio);
-				fallthrough;
-			case PAGE_CLEAN:
-				; /* try to free the folio below */
+			case FOLIO_PAGEOUT_KEEP_LOCKED:
+				goto keep_locked;
+			case FOLIO_PAGEOUT_KEEP_UNLOCKED:
+				goto keep;
+			case FOLIO_PAGEOUT_RECLAIM:
+				break;	/* folio is locked; try to free it below */
 			}
 		}
 

-- 
2.56.0


