Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FD75C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7196B0093; Sun, 20 Sep 2026 10:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B836B0095; Sun, 20 Sep 2026 10:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4ED6B0096; Sun, 20 Sep 2026 10:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 255E66B0093
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:25:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A33C160479
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:33 +0000 (UTC)
X-FDA: 85234363746.08.3B15D72
Received: from outbound.st.icloud.com (st-2005a-snip4-11.eps.apple.com [57.103.79.13])
	by imf01.hostedemail.com (Postfix) with ESMTP id 260C840006
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=CC6rXqpY;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf01.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.13 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=CC6rXqpY;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf01.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.13 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789914331;
	b=A04od+/8U+Cnn3OHY6SpqSQa+BmN9E46TeQgpxekaI8OpqEoUMG3aHQ+xIM6CVkO/hPh7J
	7YjX9BJt9G7eoywsqexIwfp2mc2wvj915iTP8bC3GlituRmPsaSMXwFxoh0Lb8OSlt3G1o
	OxdnOFXC5EpnqEs610PCZVNCec3vezk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789914331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itZXbhu1geEQDhiB21pBCZPn2boqK56cKpNzLhHjS5k=;
	b=4DcTgo7EIqaeQlY5UFnJQHxAodkk0McB5yekC+Dx6cBEzw9+qHPljPVFkEI5d6ol/vdmJV
	sWhD+SsAc4gjFIzKYstxDtqdLEz/Gi2qwd7m+TLwvWpRIKfCfDX+ekQJqsqufiZ62hO6Ok
	Qlry8ryHcd8bFUtSGZoVvIW8W3kG6M0=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id E553118005AD;
	Sun, 20 Sep 2026 14:25:26 +0000 (UTC)
X-ICL-RepId: 01a0bf35-2754-75ac-958d-7cef7b974086
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKB0MGWQReCEsEQwFbEhVdRUkERxtXAlQXXQZSEnIZWhRcGFNFUR9UWFUJCgJRHFYNV0NUBF9QSxsOXABLWhVVFw4CQh9QH0wWV0NEHxwZWhRcGFNFUR9UWEMZRVZpQQtPHV0ZWxxCZFhXCQoCURxWDVdDVARfUFQRV1ALWQJCD0gKXwdGRB1KG1IDGhlXFlgbRwJFRkRBFEkeCFRbBhQOSVAPAF0DME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789914330; x=1792506330; bh=itZXbhu1geEQDhiB21pBCZPn2boqK56cKpNzLhHjS5k=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=CC6rXqpYdJt2iWT+YOqGeKKa1bwsdtIgiMTKa+hKVReinjnwzVLGPYPw9nk3gsijeB9VM/xG0k9vf8PjXkUzOlHTqJJB/s0upcXlVKO+3eK1++8TuHtN1/NVm4drrKGvsplxm4+MrZaHt0WK4Yh8DTbl1WlwYnzmgge3SErkt7LiPIv/5CAXQkVfX3ASoELz6AjGMNapNgnJnyAtzzJNHzWPguh+xKBGodDIbu/3j23+jY/VWAUgo7TyirGwyxOfsRQ5wAAobyVcQ0FfsSlWhki8QfN5LVadMPxQb58joDLsgzc5Y0hZjzwA5RzFOH1QTITPHPbUvPb4LTldnKMf2w==
Received: from [127.0.0.1] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id 7136F1800BE4;
	Sun, 20 Sep 2026 14:25:20 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Sun, 20 Sep 2026 22:24:14 +0800
Subject: [PATCH 1/4] mm/vmscan: introduce folio_activate_locked() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-vmscan-refactor-v1-1-ec04d71cb761@tencent.com>
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
X-Authority-Info-Out: v=2.4 cv=fLc0HJae c=1 sm=1 tr=0 ts=6aafecd8
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=VwQbUJbxAAAA:8 a=SVDCxekAgo2Xo8Fb88MA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=J6hPbylVjWXjVQVODqME:22
X-Proofpoint-ORIG-GUID: tYUsyATkRx1G_HLt-XrwRX7bTfu0HAgP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDIxMCBTYWx0ZWRfX5wHKd7rfIJND
 QHzvqKnxnnhc8FS5rmfpafKEsAyMErKxYdeSRU2Z43pIXIDvF6T2Z4GGgQgC0un1oM2wp7HbbO6
 S3NVgma1rQaUanjHfk67Z/5pOOcuE3hwt45zMYjyAZNDmGWJxo7AfYerRlH18eS0dMuJeYBGTGH
 7v9OeLHquz5sJH7WB0sLKpFbb5Au0+0jvL3w5S2COXCFVJcMp9swn4ASc4RNN20rHm3fhrn+SBd
 i+2q09mAIiQJDoJBLrDNTU2nPuN0p73r8kccYytZGRcu0couLLhtyK7BYzSmeUmSJ81caRdzpdu
 8g9jxSUrXiYvz5jt0CyWWE+vzPvCggCdNCmq9JFZmbC31Sa3Vn3YE9FAl0pXHE=
X-Proofpoint-GUID: tYUsyATkRx1G_HLt-XrwRX7bTfu0HAgP
X-JNJ: AAAAAAABWCOK1qoNcNK+506RHFFGeBNptfW73pDup1dpgJCCKC70b7XS6Zo0GCq8tojvcUlwX4gMXZQzcBdQQQC8infduJkkFUXAUbY7SviKI/S2i6LagEHi2qLfbXrrBq9uUOmINdOcO7sSKE3iS193tXpRX8A558VDXxqmUb9jYiW2O8Y/WAj1bBClaqLW6zhucz1qtwyQxSJOC2eNYmdBhxn3nhPgqZP2LPbIKuk+lIFa09yQBdthIgIo5UVMnBvgKOEs01vmY8sIifjYqWiNBnRI4qspQ9ePHP6hk89LX/sMvnqo+wYZ6RGrGjk1Ws4gWkiiflRbSBFwkLfNnuHj6q5x2wLJGeM0KI3aBOJ79Qc70FX072Mb8qgvg4Tu4K2NDCL+uVwZOydbi6qgeoQhxApNyVjGU3msAvAJoR/eFeu8V30onPIdYm1LbvEjz5EIpM2d4JuOacbC1or5kMHX8sE6cGnjw2U50oXmfAGuyEv1a+1uiUdet+Zm8Ow1wV/wVervgOvxlPhSsgrWUDoqsHrabMPUNhprRrJLwx+YMLHTDodjzWY80YK9t16C8SSg6amMSV7Oi5vdUI0gd0htbqRD0RsBkmrwB7sfBjTsz7U/qR4BdlC9qeFusz2QR7APcFY29GomXLLNsWR3DXIm6pISA6dubTauFIjsTPx7M1t0UPtA54HkzRkrjLNoeOFSNdBy1kBTroUU2Wubn7Emddt5zpSU20ewKYofgHJ5inwQrQN8yJjv0lx4sbzkgkcO1l7Lc9aeZX0kHgrG1u17D98yeA5ZR0q9OpXX+bGSID3KzheW67GF2wTzHgKA+ZmCz3mArHVJTZvY2ESNS1F2LqVzDT7Ui4qciXX1A87fnuvNhEveFPb1CyL5QOfnhoHWDktwISYgJAdgvkKAAFu3rDoNIiWTyW/VaQ6e+MphPSEsEjlSNeYZgGhR
X-Rspam-User: 
X-Rspamd-Queue-Id: 260C840006
X-Stat-Signature: ugbit9joqp5qnmcihf7s536e3htmwsn8
X-Rspamd-Server: rspam01
X-HE-Tag: 1789914331-574028
X-HE-Meta: U2FsdGVkX1/yzvYxZwuEQt9pmwqrO8HoD4R81MMihNvoXiwK9JZ46mAjcj0AjQJc9kjSo8GFiSd3uB2lD4Pgr8j4c294BQWjMmBTbryRTx+KM3wtyLnnsg642uAT/SZebxsUxZVB567uzfTVoa49kQ+xLHc4b74ZkjdWJidKgInWs/w+X2UBIr4UeOspO1NEH5x+YRJ/5GDgNTtFtIdAkNef8x4PVmnkiABvF58InyfdYLxsb/IRtgyCyiioFpqybL6TpO/HM24AirJNfA++NbcawX2cKKO2e6QSgpaVEkvcVQOeBMbFxYWd9nibDuHY7Uz+i+Y3R34ZBcDXmc66wqiHsTTlGifHXEhPvfbK9wYubNMUTzMz1Aw+S+i1yiOkjNLCwyyMmp+W9IuJDQ8Ns8KRnd9xz0jU/CPChI9wAm4mUYVgfCo1oA3JdUp6E8wuFQgtbyD6KQkWL5YS/1k9oQv8gex/hUOvUrr+9p0DSXwCJNvIesbnMm7IBMAotDgR0Um+Vn5ZzpWDTb1o4vHvhpc976PuRziOWe+eMN87OiQZzld2QlKstoj5y7jF8VjroPvR4SQSafiY5d50bPqTzzedHFcKTIuNqdQeEv66EPksZpjL1VebCA5PD+JSGmJbbo7Sevpt6l3Kvy6OkayLiP8UgG2P539e2a6UKFIbZiFCstJrFRKZrpsAiFvXwUyqaTWJaNcgi8Y0ZqCH+npEJakNNy8Anb8vCUjuGy5QziLCPHrdI3WkTv/TNDgWtOXJn/guNw+E8+LdCaLvJLU78lm5dQJmxh6P8q4i81xYr/KFE3CMdzkkuBZZDSI24QHDA1Z7hMnUaHXM0s8gCdDUNcc292of8TYNBaerbCrrwMKHVIaO1/qheFrFf+Dxq0rvCudXNmuU4dKJ/PWPHI+OHpaVPItKZpV3d+tnx6cVY4zcWQvzCFiswLoLwiphnmbh0zkqWDe1idmb1mTuW+b
 LxMO8h4p
 MUtQrM8AodI0wQu2Ck0ovN45UxGTfcDa20a+NlBgeFreXR26LAdLhrc5XdNuOPGKszg1UA7Y6Ifoo3dTubXfQUeGoDF3JwELURJ1wd4z1ODggSCxNqgv+Qii//RAH5DD1mQ3uIRlg0Zlu9cbEGCblyJwvoS0J6mN1rIQUhH5jb255itTW8oh7Ssdor7HjCbhg3ZKpEQgJXjg6k908QjQfunernnL7cySrlATy4eNDnuE4LVn8cHRtKANIj4xZrJMsS1cVb7xQchK+zvMQTuSzPbtI8RTkLRdRG6ubHZvFKwOghETm3LrZ+8zCwKrTRIn03P0hqkcatPRlA9KkDK8b47nurhayrzHcaqoqBjC1QSFqEB0Kwk9TvtMgwQ9PUZCseaoM9NEORL53rL2ze6qrH+Fvk72xL0V3lARxiPW1OIrZ6OdQRI10hNTiSHnhs3TGoOPqc0+cyNei2Dnm/juUOatRiW0RbcgYGeHq9IJxX4V//Pt1rqaNXsAAmgv87H7aJr84nI7ppjC3wXF8y5ElkiwrUtzcfcVVxJ3+B2nut+LZFzt8u41j7U5qZE03U0wfksDk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

The activate_locked label in shrink_folio_list() reclaims swap cache
when needed, marks the folio active, and updates activation statistics.
Extract this block into folio_activate_locked() so it can be reused.

Replace the active-folio BUG with a warning so a bad caller is reported
without taking down the system. Otherwise, there is no functional change.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e200ce3eb056..c6beca88079a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1155,6 +1155,28 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	return false;
 }
 
+/* Activate an isolated, locked folio and account the activation. */
+static void folio_activate_locked(struct folio *folio,
+		struct reclaim_stat *stat)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
+
+	/* Not a candidate for swapping, so reclaim swap space. */
+	if (folio_test_swapcache(folio) &&
+	    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
+		folio_free_swap(folio);
+	if (!folio_test_mlocked(folio)) {
+		int type = folio_is_file_lru(folio);
+
+		folio_set_active(folio);
+		stat->nr_activate[type] += nr_pages;
+		count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
+	}
+}
+
 /*
  * shrink_folio_list() returns the number of reclaimed pages
  */
@@ -1623,24 +1645,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 activate_locked_split:
 		/*
 		 * The tail pages that are failed to add into swap cache
-		 * reach here.  Fixup nr_scanned and nr_pages.
+		 * reach here.  Fixup nr_scanned.
 		 */
-		if (nr_pages > 1) {
+		if (nr_pages > 1)
 			sc->nr_scanned -= (nr_pages - 1);
-			nr_pages = 1;
-		}
 activate_locked:
-		/* Not a candidate for swapping, so reclaim swap space. */
-		if (folio_test_swapcache(folio) &&
-		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
-			folio_free_swap(folio);
-		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
-		if (!folio_test_mlocked(folio)) {
-			int type = folio_is_file_lru(folio);
-			folio_set_active(folio);
-			stat->nr_activate[type] += nr_pages;
-			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
-		}
+		folio_activate_locked(folio, stat);
 keep_locked:
 		folio_unlock(folio);
 keep:

-- 
2.55.0


