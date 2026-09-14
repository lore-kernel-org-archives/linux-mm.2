Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3392C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C946B0092; Mon, 14 Sep 2026 08:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D586B0093; Mon, 14 Sep 2026 08:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32646B0095; Mon, 14 Sep 2026 08:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92B396B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:30:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 303C7A4FA9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:16 +0000 (UTC)
X-FDA: 85212300432.10.D7B467B
Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	by imf17.hostedemail.com (Postfix) with ESMTP id 205A640007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V/y9rhSj";
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389014;
	b=MHFS4K+JyBnFJ+PEqxpCDI6cRKQEc6tKWCqEu16HeAkSym2jLZw/kLATs7XHitFtvrXz9K
	okz2C/d7ydZY8w2iu7Q+iGJVPNgmmh8HKN0vj5fnqLkEPQKWjJ3fLeuOPRcyyx6YI+oT2E
	WSzhjlkFUQfiFRG8MOYPEMx/0kaSclI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V/y9rhSj";
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh2CaV3HTSL+pXGerZZn+jJw5LbMQzFJUQAW2lEC2Zo=;
	b=cDXD4aqe26BHQKr9CSQmITjIjLTe4K/TFR0HFY0PRUN4xbQjBwbbSLpf70Iyyg25XbZNI5
	xFVShz0/ommfp0o9q2P5OqZuu79A2y4W/dGJdJFCl2Ag9p2aBQko+rjwzI3K3scTQBKzlp
	iRdgvGvuOAccCmdBxztDzsSfA39OUDs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tuISWPJ3M4ynpVPzFp7v67YsNxfpcndtSeOMAgkqq08=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389012; v=1; x=1789993812;
 b=V/y9rhSjwCmUsjpIGRSLD6l4BDcP54NoJsEXgAXWP4OggZGQ8YW8DMSshPIebJkbqLHNNOhs
 9JwXbruyY6XN5MQHwQqSJhR/2qg44mWO/5zI4H8YoU1Xepm0MsQZ+W6FLCZbdIJ895hjmd+RleM
 JQfcd0npynvVG5CPbC/N4GFI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a11a52cd755f1f77;
	Mon, 14 Sep 2026 12:30:11 +0000
X-Mizu-Trace-ID: a11a52cd755f1f77
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 01/29] mm: rename pmd_to_softleaf_folio() to pmd_softleaf_to_folio()
Date: Mon, 14 Sep 2026 05:27:51 -0700
Message-ID: <20260914122950.3283997-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 205A640007
X-Stat-Signature: miifndu8ssj41mrooxhinx1b4akqef9f
X-Rspam-User: 
X-HE-Tag: 1789389013-924989
X-HE-Meta: U2FsdGVkX184ro2j2QWjKrie4HqKCoNIfGML/YJzrw0o4TtPyCTwyoutoJtafqbC6M00Yngs0Jd7Y7WsvPQwA3gvB+gaqNZcQz8bZXUxHgiUMle8BvNl+FCyVHVAfkeRHwjla6eXIfQav2jGgUMu4GnTOLBq0+AI3IDVawPUxgsS9SUFWisLpU2aKvzNV2LyDshfxNTaXEEi8cb97DBapOEeMM7pTI13VOycQ7WX8sP/6cuwtULnISE11G1zayBqeUDQDONnjpgG/EZsapV5aP6BE1tyvyOKza49ROqPBWFhn3cHDDGGD2qAox8eWtojqr7zaSmTd33nhoPNk53nVQjtiCT+ak/YFvb7OxhjHrPu6aDnzoNFqysI7t6oxyQ3km4F7ZtaDK529XmkyhHbt1ti+C0P5ojcMKYDJ4CdlulzbeK8kjj/S3TK3iwCXqTLztBK/UxZYMhN9b9aGKk/DT582MfsnPeNhpQErxFLdbRxfoocn+ZlVM+i+GM4iYu+CIyEE7DBYe0gUz8152pEloLBq9qJuaRDKe8z2edpja3NfS1vreUewvqeKXEdo7xcnAgJ7zIa29ZD/uZO8jO4kdhUyNR6eAAFRRkml46ZJlX7aRoWN54L66auAsH0EYWpU2uoNrlTBNvf7V4n5z9tmyCwdYpUblxJ3DQKhz5P2CKtQy/871/lwl4zGosyK1kL4qlLk1r/MVWnDC165BTRU43FnufOyXa/n1MIEkTQ6Ij/eGdAskNZyWvfFnj0Q7HRx/ixOyGT9m1d1tapNZp3Q+m13S3o3bs7B1kd2/lcM0T+wDxcW/Nn2zHz6z8Bk9wkjFNX9TfIZBaYu41BOO4ePrD5GUBnWy2ZFJwZXnMDn0MDnSGrllFnXwXVd80iWlLqKa3x1+meF6atzvNip77br5VGx7yLdL2/qt9t+QtWepcHrndG3j/ByhbSTGJXephGkDWdJOQ+9vRxA0WYaP6
 twKDdmKN
 QZkVlnbNl63YxKypu85Ozzhumod8OE4XZqWghzK6m7dX2frxvL2oNvqnCGBxFUwahS9mWHkrnWdgEjwi7NNqYOopEhr7zmo+fwHfNROorIji/pa5nUZue0ekQvx7nHbjRu0vFeBvAdhaD6I/V7gN7lmz7aNScpa7ww4Asyx6qG81dp/oWPn5VG384Rs/9YgipmXHVJE2B3Smd+2OOZoaJ/MzbDG/lZyVrQrpMENlzz04WVtpGmKIa10pDCjYfaPUzDoNxNhnktY0cWfMGbphjGiFdsncalVxKlE0NF5rcsNiHrV9yorqXg8oTAibjAZh4Ai9VwZnXkk9T/FsyJOnCyH+IvRPRz5YXaSLInjLA4E948xW7O+CPLb22C4hBClHBx0qb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pmd_to_softleaf_folio() reads as if it converted a PMD into a folio. What
it does is decode the softleaf entry stored in the PMD and return the
folio that entry references - the direction softleaf_to_folio() already
spells out.

No functional change intended.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/leafops.h | 4 ++--
 mm/huge_memory.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 4c1476ae32343..7c13c58a5e218 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -657,7 +657,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
 }
 
 /**
- * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
+ * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
  * @pmd: PMD entry.
  *
  * The PMD entry is expected to be a valid PMD softleaf entry.
@@ -665,7 +665,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
  * Returns: the folio the softleaf entry references if this is a valid softleaf
  * entry, otherwise NULL.
  */
-static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
+static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
 {
 	const softleaf_t entry = softleaf_from_pmd(pmd);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7140a1031fb2e..ee8d46827ffdc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2518,7 +2518,7 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
 
 	if (!thp_migration_supported())
 		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-	return pmd_to_softleaf_folio(pmdval);
+	return pmd_softleaf_to_folio(pmdval);
 }
 
 static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
-- 
2.53.0-Meta


