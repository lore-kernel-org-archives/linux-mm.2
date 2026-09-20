Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81CFC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77736B0095; Sun, 20 Sep 2026 10:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C284E6B0096; Sun, 20 Sep 2026 10:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16286B0098; Sun, 20 Sep 2026 10:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A36C6B0095
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:25:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1768180450
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:36 +0000 (UTC)
X-FDA: 85234363872.01.A143EAA
Received: from outbound.st.icloud.com (st-2005k-snip4-11.eps.apple.com [57.103.79.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0FF63C0007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RsdGaTtH;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf22.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.73 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RsdGaTtH;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf22.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.73 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789914334;
	b=keIyO76LDNHBA+tkMZHxpxlVR3yJoVVsWi0/AbS1CLkTG4tfd5UCIJ0FFo58WMLT9JImgR
	F6P3T0QV63YT2fBRrTeDO7IoEDzLHeiy7Plu5x1/izd7bINGtOe7Cw35aUrG1tq47VpsLj
	9VsfR3ilW8jgzbUjjpkA887rCArYqls=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789914334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnK6ar0vdpcJ83fX60CmWT9hJg4h0FrTaZNGdd2kMoQ=;
	b=bgx6GrwEIQ1tHpFvsy6RGSYiB8uWwuwYJuBPbjrvfjEmMfycWWPkC2GJrlafFqn46qst95
	XYeQS/Ptc/yWCld8/I5WgvqJe+wdGtUoBkih8vToxzkF/Xw2vhwDadM96K0PPD0S634ppe
	KTBqAmJv46hGCC8/YssnSbSUeXiv9Yk=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id E09B61800BD3;
	Sun, 20 Sep 2026 14:25:32 +0000 (UTC)
X-ICL-RepId: 01a0bf35-3eef-76f7-affb-bdfa3850bd61
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKB0MGWQReCEsEQwFbEhVdRUkERxtXAlQXXQZSEnIZWhRcGFNFUR9UWFUJCgJRHFYNV0NUBF9QSxsOXABLWhVVFw4CQh9QH0wWV0NEHxwZWhRcGFNFUR9UWEMZRVZpQQtPHV0ZWxxCZFhXCQoCURxWDVdDVARfUFQRV1ALWQJCD0gKXwdGRB1KG1IDGhlXFlgbRwJFRkRBFEoeCFRbBhQOSVAPAF0DME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789914333; x=1792506333; bh=UnK6ar0vdpcJ83fX60CmWT9hJg4h0FrTaZNGdd2kMoQ=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=RsdGaTtHGC9EUPcCnhq0NmbX4P8wBR3DB70FjUI/smNOV2Cv2HPD6LPSEAqb3TA7in78d1nxZ6c4h4f27RY6TeP5k/uF8GWxTV/GDE9ctGDlL9an82BOZl0X3dVtBnCuGqTYTbYjpKnYpkoifVBgYGYGH7XZlekoXAJAILomYbpQuf1/U5XfP7ERoQ0GoI1CzQIY0ZlqnQJuzg/uuNFlJ4BIEOR98jOWLK3t0RrrTM/0gCVa0KmmVhlsHjlkEPRHndNOL6VjoVWY1317hrzDVeVhXWpLk60NOuTt/fdTp/U3G2BRywnrdXh7kJkj51MDwzg68RDxqEciBW8acEqWiA==
Received: from [127.0.0.1] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id 507201800BCC;
	Sun, 20 Sep 2026 14:25:27 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Sun, 20 Sep 2026 22:24:15 +0800
Subject: [PATCH 2/4] mm/vmscan: extract folio reclaim freeing from
 shrink_folio_list()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-vmscan-refactor-v1-2-ec04d71cb761@tencent.com>
References: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
In-Reply-To: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDIxMCBTYWx0ZWRfXwCqadkKbx2bn
 xuLwADAYj95SdhAGOAcXFhN62BQQ/9fuBEv2jd+WlGBR3WL9sEfXYHM3PVNKDzMtbiQABc3zCnJ
 f37RwerIpCky4Lc/rfLDwpzI2+rLUe7sa/xHDcP4Z8omIPuKR1s0G+A+hOWSC1ZZ8KFmSisIFIi
 VjVWJY8tyutDINLCooAN6ebF87ukYcZrLkvqgzqwL7gcBvldw9vzDSjM9qu4EXNasZMFzgR6Hcs
 V8Oxe4+fFTh3dKGRMTUQKjakXwknFn61xtcNH15WgbNdwA14piBRxFTsX/A7IDlO4wyf4nd+yUS
 WxzlaGjaek3E4W/EXaZrfmeHN/8rS6vyoS6OAdzTJeQMHr3MAq4wW6xGCXiEpo=
X-Authority-Info-Out: v=2.4 cv=DJaCIiNb c=1 sm=1 tr=0 ts=6aafecdd
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=g2Kr-gMdqZl5o2Fzx-IA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=J6hPbylVjWXjVQVODqME:22
X-Proofpoint-GUID: mqXOafUsAJpD_o3H0FeAN_cAHp3fOALx
X-Proofpoint-ORIG-GUID: mqXOafUsAJpD_o3H0FeAN_cAHp3fOALx
X-JNJ: AAAAAAABCiLVt795WGKO9TjdGYKasr/k2G08BTTff7nTgoRri5Fadf2+CvaJwIsim1oQ3fRkUe3nSz3fuXMgumHXqu/G3I2sRagvOgnTCA5BCTvTt0YTclli6Bb6zv+/paJbqwe04vyz6ssCXz049Kmdl+eaBkiJfhSEQZ4nxnbd7SrjlA8MgK0pAUgPmIIw73uJAMul3PE20rO5ygb2TBB4iNxnxJ03/leeuq/3lcY2/Qazz0z5D17S8F9KtayTTKlhKqcr+ttP5lqT7I/31awgzDHcS3oWPAJvfALN2vmz0LqXTyL6wTU4ht4yfvtTxH8CTs1GiTuh+JvmLJs/0pUGFrgPpHoYqqFgJTbVe5hHg/PWx0f+sVeaPkTdx/JHcFDBf/s0Pe3upb4zw7zotTCQfu1//Slp+gzsLqoSlqwFKZcJrjsrtM7w3GjTJdH2Rg0NttbakwpF7PIB6ggkjy3FrJjxAEbFqO+mPPpPGn+4CmecIkc+zukw4hJI27QpNWNXjGt/rSGsXsr4Ul9luR0nt8RYk7xSDX/4pQwQKB0QFd26MjXYsP7h//NTKnIIvzNFqx35ssHyIqzG/ZCCsyjmQmHG/SW5MTwQCCb5jIW5KJELga4p1puzjS/2x0iLttSmAFQGUdsQ5qWSN2mOn5Cfkthq6+7egvu1SwElTA5oXg2cOLRe1HRKxCgrlcSQOhFyW/w/mubniGCfQFiwjTxI7DYXVcv5cl0D8P1cD42dWaIRISV+qj67m/1gmzR/TlrM+cskk2DTggZa5rbhj49ijmdXGOClha9oHOV+mvr7AcvU6tXNoqytqcgHjjPfkrWbnfyJknUGQ6DZ5zRzj28BpZTd/9WKQ+3g+MuNejp7oxrN6+wgH+YEjsx7YrpM2uIoovmkvlSiF412JEylfLf/HtxqueTUzg==
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FF63C0007
X-Stat-Signature: 5fqmbgpzjr3ws4t4uoy3t1cy1i7ern7y
X-Rspamd-Server: rspam01
X-HE-Tag: 1789914333-576917
X-HE-Meta: U2FsdGVkX1/LqY7z2cFzrDyNilrU2bG3RV5OJhVNAIYwQ9HRalg+dmqcnWghLDkAGgLFldKwxzDzboYA+SlpsEfBj0UtlobzAVPFBERWg0zGnxAOyIMxDTIu4E1k+FkYxUlUAb1vb/ko3kd1+WfkaJZ7PxQ3+0fe+IdQKcJIjru8B4MUMHXE23Oy9sGPn5a1LuXZhbJT9m2CNXJHd/9TPjm4y3zgIGih+0ot6B0F4HoZbZsWBVzM8FRkMhEGFqqqgTeH4TFl77G+Z582pfrY7M+j80NfhsdvlPlIAbV1ZCczfBBFMMGq9cjmebv4GJu91+fz+Rs/xLx71mkRm9/VMcgnk7QvjKOE6CyQxBK5xo0GKCzTGvRWAB2dKAqtaAd/F8RYhFOSZZVAdapee6U/pyKiFS/J2DzVctai2XP3kPsnB4EpMBXIGoULn6DbYW20dQ4O0uHE8/otKeaZI897kbHwq3+Hblit8o7BrERcRm0sDbHP4gjjVfgvCJTvWWAxJ4UIpiTjUtqB0iFpNDb8XhrwAd93SBJ574ufkQ7KSMR2OToJYyZ4cKNbWY3Jha1uHCOI+NsVCX5qz3YMCYUu2cdjJQtMLIr/sGL6ZM/jnTrWwkUGNMBbNfpUIHh4GCY3wQKOHzvdaY9ntQ+Xagbh5hXqqG3xNA8ThMZzh7kfWWUNsGDPudCHq7sJa9n8EFT17qtQ1OrWWLg/PUM/KcxZPtwrdsa/M346xAjhh/WptNWKmuYD17GUYLhZCyCd9B47UaVRbliuwdJN+l3TFQT9fkS/IPfn/sw3DjXAy7WSgV8JJaldls3NJ23fTA75TInwpBLRB1p0CTPmtewszfb1EtfqX7qRBnVH8+6r8joYcTPj8ZQSF+31n6a2ijpvnHbqP7l61TE1xy5Jl7AlKoV/D+HNs75r36ziLfV0zvIPIBehz1s+9A1//XPrOEUaSbMQ18N0K+z95Cl2rsBZd/e
 D4ZTNZ3u
 Hu6mN8rJoqcb8UXxkEtlPfz/m80si/d9ipyuoBfR4BViZw20WLqWFO0AXdisSwKYlK3ETL65ffZx/EDJX1YLV3UF4mtsB9qouo5hXQvL2MSlsqyQkdIG1Lf1mzmGvC6ZeH/cBVxbk94N5SbnEAPWvOJx9qsIUyOL6JlsMrciF30pE9Zrt4NZSVYqU+TgB70suc+V4Ov2aVTlsJw0jjQvM/UimLhffwq2oaSebSHQonRuT6kebgir8d5DmPWqCosb2I9NzJqH1rFbL1Umgafmm3xi++aGRy0BXnqW0Xv6yMmGdy4XyPAvE3T4s2pToEeo9kKx5UIatfN7NHhpKbfNXo/nytvRvdcWgohbpIsjpPGNNu/QFXAyDkBnVhjNEiUYNfNXSXrkRbhrzMlzNUR2/AXr5JKB3eJgkpFXsj0fdwtvgDxje9O6n9EYMsEJHfWvr/DS0/56dol14gcCrsjzwj4Oalzcigj/TzvHKJdE0ci62yRgteW0KLmnXVrZPh/NYihFKa9vXPR9qpWXuFSLKTGzljPlgIvKneT4D5OCDxgEhxwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() contains a self-contained folio-freeing section:
buffer release, lazyfree, __remove_mapping(), and folio_batch draining.
Extract it into folio_try_reclaim_free() to reduce the size of
shrink_folio_list() and make the freeing step independently readable.

Return an explicit result so the caller retains the distinction between
activating a folio, keeping it on the inactive list, and reclaiming it.
The helper leaves the folio locked when it returns ACTIVATE or KEEP and
consumes it when it returns SUCCESS.

No functional change.

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 171 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 96 insertions(+), 75 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c6beca88079a..120085dfa2fe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1177,6 +1177,95 @@ static void folio_activate_locked(struct folio *folio,
 	}
 }
 
+enum folio_reclaim_result {
+	FOLIO_RECLAIM_KEEP,
+	FOLIO_RECLAIM_ACTIVATE,
+	FOLIO_RECLAIM_SUCCESS,
+};
+
+static enum folio_reclaim_result folio_try_reclaim_free(struct folio *folio,
+		struct folio_batch *free_folios,
+		struct scan_control *sc,
+		unsigned int *nr_reclaimed)
+{
+	const unsigned int nr_pages = folio_nr_pages(folio);
+	struct address_space *mapping = folio_mapping(folio);
+
+	/*
+	 * If the folio has buffers, try to free the buffer mappings
+	 * associated with this folio. If we succeed we try to free
+	 * the folio as well.
+	 *
+	 * We do this even if the folio is dirty.
+	 * filemap_release_folio() does not perform I/O, but it is
+	 * possible for a folio to have the dirty flag set, but it
+	 * is actually clean (all its buffers are clean).  This
+	 * happens if the buffers were written out directly, with
+	 * bh_submit(). ext3 will do this, as well as the blockdev
+	 * mapping.  filemap_release_folio() will discover that
+	 * cleanness and will drop the buffers and mark the folio
+	 * clean - it can be freed.
+	 *
+	 * Rarely, folios can have buffers and no ->mapping.  These
+	 * are the folios which were not successfully invalidated in
+	 * truncate_cleanup_folio().  We try to drop those buffers
+	 * here and if that worked, and the folio is no longer
+	 * mapped into process address space (refcount == 1) it can
+	 * be freed.  Otherwise, leave the folio on the LRU so it is
+	 * swappable.
+	 */
+	if (folio_needs_release(folio)) {
+		if (!filemap_release_folio(folio, sc->gfp_mask))
+			return FOLIO_RECLAIM_ACTIVATE;
+
+		if (!mapping && folio_ref_count(folio) == 1) {
+			folio_unlock(folio);
+			if (folio_put_testzero(folio))
+				goto free_it;
+
+			/*
+			 * Rare race with speculative reference. The
+			 * speculative reference will free this folio
+			 * shortly, so we may increment nr_reclaimed here
+			 * and leave it off the LRU.
+			 */
+			*nr_reclaimed += nr_pages;
+			return FOLIO_RECLAIM_SUCCESS;
+		}
+	}
+
+	if (folio_test_lazyfree(folio)) {
+		/* follow __remove_mapping for reference */
+		if (!folio_ref_freeze(folio, 1))
+			return FOLIO_RECLAIM_KEEP;
+		/*
+		 * The folio has only one reference left, which is
+		 * from the isolation. After the caller puts the
+		 * folio back on the lru and drops the reference, the
+		 * folio will be freed anyway. It doesn't matter
+		 * which lru it goes on. So we don't bother checking
+		 * the dirty flag here.
+		 */
+		count_vm_events(PGLAZYFREED, nr_pages);
+		count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
+	} else if (!mapping || !__remove_mapping(mapping, folio, true,
+							sc->target_mem_cgroup))
+		return FOLIO_RECLAIM_KEEP;
+
+	folio_unlock(folio);
+free_it:
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
+	*nr_reclaimed += nr_pages;
+
+	folio_unqueue_deferred_split(folio);
+	if (folio_batch_add(free_folios, folio) == 0) {
+		mem_cgroup_uncharge_folios(free_folios);
+		try_to_unmap_flush();
+		free_unref_folios(free_folios);
+	}
+	return FOLIO_RECLAIM_SUCCESS;
+}
+
 /*
  * shrink_folio_list() returns the number of reclaimed pages
  */
@@ -1564,83 +1653,15 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		/*
-		 * If the folio has buffers, try to free the buffer
-		 * mappings associated with this folio. If we succeed
-		 * we try to free the folio as well.
-		 *
-		 * We do this even if the folio is dirty.
-		 * filemap_release_folio() does not perform I/O, but it
-		 * is possible for a folio to have the dirty flag set,
-		 * but it is actually clean (all its buffers are clean).
-		 * This happens if the buffers were written out directly,
-		 * with bh_submit(). ext3 will do this, as well as
-		 * the blockdev mapping.  filemap_release_folio() will
-		 * discover that cleanness and will drop the buffers
-		 * and mark the folio clean - it can be freed.
-		 *
-		 * Rarely, folios can have buffers and no ->mapping.
-		 * These are the folios which were not successfully
-		 * invalidated in truncate_cleanup_folio().  We try to
-		 * drop those buffers here and if that worked, and the
-		 * folio is no longer mapped into process address space
-		 * (refcount == 1) it can be freed.  Otherwise, leave
-		 * the folio on the LRU so it is swappable.
-		 */
-		if (folio_needs_release(folio)) {
-			if (!filemap_release_folio(folio, sc->gfp_mask))
-				goto activate_locked;
-			if (!mapping && folio_ref_count(folio) == 1) {
-				folio_unlock(folio);
-				if (folio_put_testzero(folio))
-					goto free_it;
-				else {
-					/*
-					 * rare race with speculative reference.
-					 * the speculative reference will free
-					 * this folio shortly, so we may
-					 * increment nr_reclaimed here (and
-					 * leave it off the LRU).
-					 */
-					nr_reclaimed += nr_pages;
-					continue;
-				}
-			}
-		}
-
-		if (folio_test_lazyfree(folio)) {
-			/* follow __remove_mapping for reference */
-			if (!folio_ref_freeze(folio, 1))
-				goto keep_locked;
-			/*
-			 * The folio has only one reference left, which is
-			 * from the isolation. After the caller puts the
-			 * folio back on the lru and drops the reference, the
-			 * folio will be freed anyway. It doesn't matter
-			 * which lru it goes on. So we don't bother checking
-			 * the dirty flag here.
-			 */
-			count_vm_events(PGLAZYFREED, nr_pages);
-			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
-		} else if (!mapping || !__remove_mapping(mapping, folio, true,
-							 sc->target_mem_cgroup))
+		switch (folio_try_reclaim_free(folio, &free_folios, sc,
+					       &nr_reclaimed)) {
+		case FOLIO_RECLAIM_ACTIVATE:
+			goto activate_locked;
+		case FOLIO_RECLAIM_KEEP:
 			goto keep_locked;
-
-		folio_unlock(folio);
-free_it:
-		/*
-		 * Folio may get swapped out as a whole, need to account
-		 * all pages in it.
-		 */
-		nr_reclaimed += nr_pages;
-
-		folio_unqueue_deferred_split(folio);
-		if (folio_batch_add(&free_folios, folio) == 0) {
-			mem_cgroup_uncharge_folios(&free_folios);
-			try_to_unmap_flush();
-			free_unref_folios(&free_folios);
+		case FOLIO_RECLAIM_SUCCESS:
+			continue;
 		}
-		continue;
 
 activate_locked_split:
 		/*

-- 
2.55.0


