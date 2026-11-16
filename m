Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B579606A88F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nnFTOXXp
Received: by kanga.kvack.org (Postfix)
	id A07C06B05B1; Mon, 16 Nov 2026 01:36:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F816B05B2; Mon, 16 Nov 2026 01:36:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 857916B05B3; Mon, 16 Nov 2026 01:36:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60D6A6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:36:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D37CE1A08C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:42 +0000 (UTC)
X-FDA: 85440023844.15.71E8BC8
Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8518140002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nnFTOXXp;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5zoxUgTuZ5PnFPOT8698Pc92IH4J9fnPH5OLYH4+2E=;
	b=CN8mSLCPW7NIyV12qwA6Pi514O9FMci91PUmNJtKgaNOgfbgoLPSAqKdcFZ5fc/T3SY5Rf
	0zKAFf+pHjPHZlkBYFhKHBmW8tDMFYdz8BjhE9PsKy8iMwwDosUhGOs32IsCWV3RV72Ggn
	Ie5o8fHbOG3PzLqFo0sbUGpD2ioAg+E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811001;
	b=SGUEsf9IUlo6yaDvDmpIvicxXXRb84Kulijq+D+DpAOtI5mPd2/dKHVCaTuJ78hBu3t+tr
	CmRMGjqMgg+VhiFE+YXqjljTsqV8JSbEbR5LyZ9plKElOHrmJR3PDQZVb+vYN0mBBUSYXu
	DwoZ44mrvKxaSpubn3cSXOhKySJV/3k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nnFTOXXp;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/734QEm9p6S53bt1CqBXUyRtO6uKUnd0BWySzLsj+7U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794810999; v=1; x=1795415799;
 b=nnFTOXXprSw+7ZkZJXRX+5kba0sYilWNw+7bwX0Ohs6tX5jQ3mdwGHSmVNDV/LaczhXs7XlR
 I0w3zwV4zVicP/wQIFybiUu8y4+8tTvRPi8jCUwP/2ttRUOVupTPYCsoy5kpfe+JUnUx9dJo/zQ
 z/tsDJ2dWcoFE7OUkN+iSU5I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id d552c4ece8e63456;
	Mon, 16 Nov 2026 06:36:39 +0000
X-Mizu-Trace-ID: d552c4ece8e63456
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/4] mm: don't PTE-batch a swap-in of a folio with a hardware-poisoned page
Date: Sun, 15 Nov 2026 22:34:56 -0800
Message-ID: <20261116063624.1382944-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261116063624.1382944-1-usama.arif@linux.dev>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E8518140002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8xg3xjgsx4yonfjxws1mejpt6ju5i6z5
X-Rspam-User: 
X-HE-Tag: 1794811000-536703
X-HE-Meta: U2FsdGVkX1+NooqGnmixBUOaOOmgjjkZi1+Nvug+ZscFP5DJ4oECWozwNh8FIcZge5rGi0Sf1LlGhliDEEVFtRPvMweZuTK0FXMsuJlryHVuXnODYgoLKe16SJ7YQD6YF8GafUPAPxaTmSYSslX9nRLeC6uvuNt28/quTaWEq+J337dWam3OlgEzMfy/IXaNAxna4LQzaKMWx8VKYzjSqcWG2pCSG4d+5ETElmgpklsrF6dJgeDZWQ1UI/51789VnMj7WcRUaaM8e4pinWVhQaNoHlPoXLvO5ldsL2RNKtWChLXHnMOQ3oFMDcvatt+wMF/KRNNWGMCoBRaGfVnTDXOqXLU1GkwgpMB13BFNnpB33pfgForcY8UUvDjTceJZqvTW+RC3jje4C9C/x3ngeL/gi5zYokXeHEpFRUrjvk2JXsh0w2QbQrwcWkI1zF2gqzgMmXE7WBujlla8o1pdxhXipiLKPlxF1uPLNKGYDcxvEss/fF8GgnohYxvrhxpwNB4fs6RkBXRYUu++cGoPFj8EvfYDRQPxwQYS7rZPtbJY83qatAlfFTJCL33WjTI58JS5IVLK3K8rESkkuLYgcICddfdRCYBQvkQIPBDAbIv6TwnzTal/oA8IDbSQPyUc2+JwETtw5oESY5vmxUaZ5jqefk6GIMWXtroS520rqKDC5HlxAoSt4ZThkPN2Fwmnes2LBoXIDDVt2vF38fDS88XB1uhX2WTI0U7Vr0XXJ/fVsuB6nO57UmUtVtuAOEWsutHRs+jneFKBwPhW+PzefnNiF8bt7pRX2YV3FB8d6wN3LCa86Z5eGFOPnPuYKCNAW6GhxSSrjDwhWzPQrIARhnI7rjK/qaNNyfEGMqg0gVuDXNN2P2txLQhD7TW1LkGeua/iVoO4icJGdLMvINj6KJMPn6J+SN7ayNRsMgGb5LdJApAQqOZ39Pq18Fmw5qG7W5IudhnJKmNk58OpV/M
 tvJ3G2LD
 b1M7qoLSZp8wSezScKDEx+LOSkHtrGfjfSd8Df0/2kGLYctrluIxKmffceLT+gYehpSPC2ljfnMX5qr2tRQDBB0tfDF1EOxM+pkhgqxzr5Tcd4PmT8RTH2K/wNjCHnHKCzqTrGEqAMVIQl5VSEbLO3aYR/u/k9dbxJA6iGZZe0/Oh0ALivhH4R3+Ao+iCzRfvglqVxEGjr46/H7WeWY9HD6UFZkh1OVDlSaoJWGSKuPniFYt71b6K3xvCjQiMoSF8GzGNMnEJ6eKXCWZ5m8g/q4jdJv05Fjewh2jqmW3WdxCHEEx7ajorGSuZjFMzQTAn84WatHjCZfTHvGg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_swap_page() checks PageHWPoison() on the faulting page, but the
large-folio batching path then maps the rest of the folio without
looking at its other pages. A poisoned page that is not the one being
faulted gets mapped anyway, and the fault that would have reported it
never happens.

Skip batching for such an anon folio and let each page take its own
fault, where the existing check catches it. do_set_pmd() already backs
off the same way.

Leave a freshly read folio alone: it is not anon yet and can only be
mapped as a whole, and falling back would free it with the poisoned
page still in it, which the retried fault can then get back from the
page allocator.

Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/memory.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index d477a4f986bc8..51e72fb40655f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5158,6 +5158,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
 			goto check_folio;
 
+		/* A poisoned page in the folio must take its own fault. */
+		if (folio_test_anon(folio) &&
+		    folio_contain_hwpoisoned_page(folio))
+			goto check_folio;
+
 		page_idx = idx;
 		address = folio_start;
 		ptep = folio_ptep;
-- 
2.53.1-Meta


