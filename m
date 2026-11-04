Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0614D606A32E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xt8dPoZP
Received: by kanga.kvack.org (Postfix)
	id 206E66B05B1; Wed,  4 Nov 2026 04:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5896B05B2; Wed,  4 Nov 2026 04:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7E46B05B3; Wed,  4 Nov 2026 04:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D65EC6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:36:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D3B2A0557
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:36:39 +0000 (UTC)
X-FDA: 85396931718.10.30B1628
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA46F40007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:36:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xt8dPoZP;
	spf=pass (imf01.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784997;
	b=yGjfzM2BCm1jq4pqRoIwJ2T3sZxKInqcB3tnWDPOfB/ofORp0ZPxtQ4R9+ON0mIOj+NkGk
	85yq36lO8JDrVW6Suyoe5kDUzvyg5EAvKkZOIrrv0MN9v7CQ3t/O/DwHXpWwpPKPCnyDis
	tYhyeZQUrD3MdMUgRsWmK6RR94k1nKM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xt8dPoZP;
	spf=pass (imf01.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JsLxVuR1g1JSvibC9g9YzUf7PO6/MZgJEB3OXBOD4y4=;
	b=tPZqIrFcWPBiyCe9Qdg4UAbh1KfT3z//l+1rHrqoBuuQvPNsTGI7/dqTIWBnVPXmamEy9f
	NqRXvcH4OaSa2psP9mr5DuBLLiOOmhvcYATs6zGdyFYGUODHq0Ru/cbAvrcaSSKoNccM6X
	XOaBpcVVQIGVS3SJtDRLmzF0+acoF9k=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso287555a91.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 01:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793784996; x=1794389796; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JsLxVuR1g1JSvibC9g9YzUf7PO6/MZgJEB3OXBOD4y4=;
        b=xt8dPoZPy1Dml9QJntHUhfVe28eYu48ZcH7El3YSEGVKA1iOY+XAVxdZwN8JSyOkoi
         89ChSSO7JZJcGCTyWeHH8/Y8lti/PLzPDthND7+/R0tbHR5JdVO5Qmp8KtX655BF/DFA
         dRnUipO5RelsMu4QgtYK4B4D3z5oDaShxRc6mr3HLa+7uhDZhJjPjBLy4xC1Dz5j6neO
         syQBbx8Tn9941i1les18Xo1rMi9aNB18ajjP134L2s7pZHuiyFZ1ONI2RKgKTIdghIE2
         e1mD9koWycJlCtqRm08v9a8h8GN1OIHy/Va5YdZSUyteVNVZR9P3BUiLphWsoGslzOln
         1b/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793784996; x=1794389796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JsLxVuR1g1JSvibC9g9YzUf7PO6/MZgJEB3OXBOD4y4=;
        b=1pCU500sttyGmVNP4wmJKXiUCT8gMzD6l/AJQNN7vBB8RJaZR0gGAR9F+stAl/Rh4T
         OYtHfypophLcxpBK0wpCXhnmBqLBdQ1g9vjFQzJyk1+K2fV89hnx3xFLr70dcc22BJxc
         QYln5SViKQsOUEa5E6RwXHopv3dfREJnlGXJsbdoSga3J4xDUdsqe5I6fcjBjGIj2bKz
         dmKez8OMHDGoHIUGCIpQP6bPHBGbcurs7avQcslHR/pFVVvNpPV6n7EVAxCj3uWm/Z03
         tvIkIt/8PMHt+qy6YrVl8ABWJBnsuPLxn3dBmkcBb++NlwLSdGhAwmzMPmfQTCzJ3di1
         CZjQ==
X-Forwarded-Encrypted: i=1; AKwUvBwkuYZbw9RsojfSPsXNAHH7UHgoftPu6IKy5Z0sMkaWTV8OWyMXK8xAmHEBtZ9BP51LNiGLIe0elA==@kvack.org
X-Gm-Message-State: APuU4Z82Z210o0CNfg88EoGS0guGvd2fSSMCwCvuCBF5A/r4fQ4EnmLA
	96+GwZAon1sbxDMHvBY3w50ib4dJqqc1VrHj7Gmb+uDAtRApK9Py4zpu
X-Gm-Gg: AYBFou2YbzLouXs04lziHTBk66KQa1Go8cWpvWbBlCxTjc6CasERilCBxLeMEfMsG5d
	SWEZCmuoBI77n0IQHD9AJdcW3VkPMAoQDsht1rGas4n9louzw9IlzCcKMdT2MkHukpt7hrvgub2
	BZg8Xc/5TPbyrtsLnFpMKgL+ajEIyJ9WWZ2PG9jp6PqOsl2DDh/2AQ8n9OGAxU9oaYZ1BpT5loZ
	aZCQeWYM8ZN+LGTwXQIplFbMh9PpeCEujSjbdcaoqs7fxganwvF50P3+I9JjrAKYdvUeDO5rTd/
	PxOeJ/cpCsKaxYZ7d8mrqZKxzXF/LKedS0n3mRFYF55d5ufYbiOsfwmM7GKUgdSD3ps0IsGBolt
	c3mMSZP4Cp6WJm76Hnu5+H1zFxNvzNz+othqLAHSfyi4Hj35BvsgbHR5aKa5FzYqTwHX8Z8wuHn
	+VXGDN6lq0JtN1rxt0PODT4z7pSVAIj/ECNYAOHv6avtXgQ9M1ETwn5LrUaADowJg3DMwWkmBqI
	zor5uRuUxaC2us3lzgrlbIUKcWegkBV60LdxQoy8M+gFvS954W/A6NtKhKO4B5acf3schWBbCGe
	BZ2TrIBnUMLXd8j5qnZhoMxVEgT0l0LBp2IbL0+rFPWAuN5gAUD8C8adP0ChvytMPo+A3ukm9Q=
	=
X-Received: by 2002:a17:90b:4f8a:b0:3a4:ca46:840f with SMTP id 98e67ed59e1d1-3ae896f8655mr12708132a91.8.1793784996534;
        Wed, 04 Nov 2026 01:36:36 -0800 (PST)
Received: from umang-Inspiron-3501 ([2401:4900:1c60:e7b2:951d:848a:7f25:3900])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c7e087csm8569454a91.4.2026.11.04.01.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 01:36:36 -0800 (PST)
From: Umang Pokhriyal <umangpokhriyall@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Umang Pokhriyal <umangpokhriyall@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] userfaultfd: validate the whole range before changing write protection
Date: Wed,  4 Nov 2026 15:04:57 +0530
Message-ID: <20261104093457.152245-1-umangpokhriyall@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fjkdc6oeipfogxy5xcwt54w468ii7aim
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA46F40007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793784997-254075
X-HE-Meta: U2FsdGVkX1/LnWi1YhTDfcfBb/lxTayAVMEboSEgDrhHaviQb+RwrGyWyDByDSTWEMmsdj+4GG6N3ZNsLEzopC+O19OgHItqZGSnvgWL2Ri7thTnd7cIZFm6RmtEsmOenPdNNSJmd2UyT94JAKRh0MP0peGhf/PntikdYWp1wknGYTlGSA1HolbAzpyriumtQzhwchnNJjbgDF+UsqIAS0FGw1czonh5UBzzympgd18MlxO/IABqzEdgJeLa0CxnAEDbtAqF6yyiqaBYDSNw3h+naYXhQ+mlQG/qPnRP3QJ39b22S6DGKc/SxBxlpxsQGYQ/53WGjSj1f6PcOSFxluYtB3RLT/MH94YNrllyFIMrcUkD9gwGA4tAuvb5eAWpKm8PrfySCaiedl4L6W/yL9R1kQMkvXla7XWcRMdRIioJ30aTxrv2x10rKREev2kbD0hnpR+TcFF1iwwg2TC1xDCm9RL3V89I9Sn6GjnBumeZim6J70Larx6rnIZa7yzb0GNpj61dglWym16rVL1BNPugxuz1VZXZdZEYZLnGtJpSASg2eMnGWLRTy3TG32QdGTbkghE0yhc0RNUTrA0fskYy8lhxFUPH7ltnztgkV7vIMa0P8/lyh5mQJa0knw34eWOLY0/xzcvixj8xoQRHbN+H1EIMy6rztoy7X61gXkq7hGO3pNoQ8dhQNhUsshy8rxJAoxnd6+XGNLIiSOCJwl2GomJHeUMMUOPZriMmJgzT+FrsNUS4oeQ4+QbiPl26fgpYL1n8zOWMFwyQtCWJKEmKGIhFty4r2KTb3Q7TPdA/jrHAVwSmcbwsjf2+uTXIYsTdWpiYCphl7rC3+pvnbhKeim4R6aAgFIYDc3A8GaHWTt4ju48t2buSKH7F4c1Wg81hfsiisgxuT25TiVNoPcBAkQHw8pG/Va2NNrsTLwjszkTE9+yFXxVGK/XCcDXOw0nExfDwE6NchexS2G0
 5iutwBCF
 sCXpqI7GXbv6rs/A3dsnjYdR342yMMh148xyno5egiSFy9FqcaTrkdwx6JWNFttfHj/E7zRV6EBgrH2r2xs/4Bb9/v8LsT5CQhiR4rLsUdNp2lR1H3yZk/5Iq6lkxygC2nUS2icusqrifU/H1wQA5acCyEUAvJ8TPYozVmnfGx5JsAIElxDRy3HlJTbxj3I9YtA8435KbVGpfluoHg4QyMoHRzj9JnDeDv5CGMtx4EpF3gH04lVR9ozXbeyG5Gmbvvl0q6qGaxsnsY+odOUeRXvz6gbmR6JoeH9BFR7Vxrscw82oAgyjwVe7W3O8MQeNh6OQ/AhxRBf+TUJrZxPiaSOVOQvo8QmKqBhKP0/gwMyOKeeQOqXdJq5viLauTdiEs6Nq8lbaktTiZ4RHKshEqO/fQgOroRhNZH7lKEACIrCPwTZLbKkhghG4rhTtyMsQfX2xC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mwriteprotect_range() checks each VMA as it walks the range.  When a later
VMA is not registered for write protection, or is a hugetlb VMA the range
is not aligned to, the call fails after the earlier VMAs were already
changed.  When unprotecting, userfaultfd_writeprotect() then skips
wake_userfault(), so threads blocked on those pages are not woken although
the pages are writable again.

An unprivileged process can trigger this with a range that spans an
unregistered VMA.  It hasn't been seen in practice; it was found while
reviewing the userfaultfd range ioctls with an LLM.

Validate the whole range first, as mrwprotect_range() already does.

Fixes: a1b92a3f1498 ("mm/userfaultfd: support WP on multiple VMAs")
Cc: stable@vger.kernel.org
Signed-off-by: Umang Pokhriyal <umangpokhriyall@gmail.com>
---
v2:
- drop the redundant error assignments in the validation loop (Mike)
- drop the selftest (Mike)

v1: https://lore.kernel.org/all/20261102103621.156928-1-umangpokhriyall@gmail.com/

 mm/userfaultfd.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 87da92526..1b7320d0a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1105,21 +1105,26 @@ static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
 	if (atomic_read(&ctx->mmap_changing))
 		goto out_unlock;
 
+	/*
+	 * Validate every spanned VMA before changing any of them, so an
+	 * invalid range is rejected without changing part of it.
+	 */
 	err = -ENOENT;
 	for_each_vma_range(vmi, dst_vma, end) {
-
-		if (!userfaultfd_wp(dst_vma)) {
-			err = -ENOENT;
-			break;
-		}
+		if (!userfaultfd_wp(dst_vma))
+			goto out_unlock;
 
 		if (vma_is_hugetlb(dst_vma)) {
-			err = -EINVAL;
 			page_mask = vma_kernel_pagesize(dst_vma) - 1;
-			if ((start & page_mask) || (len & page_mask))
-				break;
+			if ((start & page_mask) || (len & page_mask)) {
+				err = -EINVAL;
+				goto out_unlock;
+			}
 		}
+	}
 
+	vma_iter_set(&vmi, start);
+	for_each_vma_range(vmi, dst_vma, end) {
 		_start = max(dst_vma->vm_start, start);
 		_end = min(dst_vma->vm_end, end);
 

base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
-- 
2.53.0


