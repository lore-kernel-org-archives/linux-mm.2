Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B05109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C159A6B0092; Thu, 19 Mar 2026 14:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E316B0095; Thu, 19 Mar 2026 14:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F376B009B; Thu, 19 Mar 2026 14:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 952326B0092
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:31:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62018C23E2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:27 +0000 (UTC)
X-FDA: 84563655414.22.E6E48E7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3D726140010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DVxcO0GG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0v07ZlIi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DVxcO0GG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0v07ZlIi;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773945085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anyfiV6rgUNLqvdloJydtyxRF1ee9QavRldGPaFXcPE=;
	b=r1/M/F63gQy26IGft7B7FxevzvazXE0RLOMtFSF9wc58AZRvfa2eWWR5tq3Ou9mXoDe1OK
	Lwg2a8omZx/qBJggIzQURiqcRLRJ59q5jJO6rxzg9Cf7mP9E3XOKTR+qQWEebkJuZHDnUH
	iN5sTszAjt67oVRLu/e2wg6OI3NDaY4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DVxcO0GG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0v07ZlIi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DVxcO0GG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0v07ZlIi;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773945085; a=rsa-sha256;
	cv=none;
	b=npcZapnuzPmYPN1PoCGt8Pgyf/MBSu0zBNzTOtxReCQJ2Zc5zCiEtc8aVmfX+91s/zCBUd
	TyI7yJDXPj14F6CQsZZn2CPaPpnu7Mj0u3hnulB2KTXIAmuLOr3dBsoJJrD+00zMC+RYWt
	7W9qnhUiTZu0CzCi7111YeBNbmXehvc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 95B3D5BD97;
	Thu, 19 Mar 2026 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773945080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=anyfiV6rgUNLqvdloJydtyxRF1ee9QavRldGPaFXcPE=;
	b=DVxcO0GGwaWmy/iEVsxUuH0tYC8PxAyd7+ebKCMjH1hkrxKNaZZ1c/OpwzZCNtJfWVRum3
	PNgjxzs+J4qYe7G+rpGzOyIC3BjujeBW9wOkwS4PvcObGlYmFp3OlRBpUaF9XbWix90SEa
	kIqV+/xduLezQ3Lql0Pa4O69pfwBB8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773945080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=anyfiV6rgUNLqvdloJydtyxRF1ee9QavRldGPaFXcPE=;
	b=0v07ZlIi0C8yO71HGvvpk3vQzMbgZvMWWi8S1VhNwwmjASPjgMtxJGzQafZPd4l2akquoB
	bi3ovs60pdo4tbDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773945080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=anyfiV6rgUNLqvdloJydtyxRF1ee9QavRldGPaFXcPE=;
	b=DVxcO0GGwaWmy/iEVsxUuH0tYC8PxAyd7+ebKCMjH1hkrxKNaZZ1c/OpwzZCNtJfWVRum3
	PNgjxzs+J4qYe7G+rpGzOyIC3BjujeBW9wOkwS4PvcObGlYmFp3OlRBpUaF9XbWix90SEa
	kIqV+/xduLezQ3Lql0Pa4O69pfwBB8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773945080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=anyfiV6rgUNLqvdloJydtyxRF1ee9QavRldGPaFXcPE=;
	b=0v07ZlIi0C8yO71HGvvpk3vQzMbgZvMWWi8S1VhNwwmjASPjgMtxJGzQafZPd4l2akquoB
	bi3ovs60pdo4tbDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAB8F4273B;
	Thu, 19 Mar 2026 18:31:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4PcbKvdAvGmbdgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Mar 2026 18:31:19 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Luke Yang <luyang@redhat.com>,
	jhladky@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mm/mprotect: encourage inlining with __always_inline
Date: Thu, 19 Mar 2026 18:31:05 +0000
Message-ID: <20260319183108.1105090-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319183108.1105090-1-pfalcato@suse.de>
References: <20260319183108.1105090-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D726140010
X-Stat-Signature: fxxzhf35icoenfnpipxpq5sfd388wbh7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773945084-204273
X-HE-Meta: U2FsdGVkX185aTvk8vBWHq+oOoezumpWBVWYdEQBCHaxBaPcEdNgnkDxDzG+GyHuGeEPbqD/ya1P3xKq1bYQWB7c6VTxut0tBgWDoKS3Gn+57nr7fpYW+Mk/aFLWUATp1NAPQkc354Mi8/172Sj32bGnK/AlkspJ4iGRxQnPWCA/MfdgaZPQwPOs09jSpkmedfG7FX0vKyIhh1gxGHZsCX3mDkn3yeHIHh9qegjhNWMAYJsk6TIqs+aaaRDcXaLR790OAwYXAWopVEwzPV99WN+ZESE+7PMmEY+VIPj0dfZAV9lO55DcnHH3QWxdIa2XXXtDjikSoJfA68XjS/yNg1GySEfE1JzFAemdu2Kd3pndlf8IpSXw455r3A5NY0besyByP0KqK6rXqLqUbxuxebbFUvB7ZZs31lSMcXNYpcLoNVv2Wu5SmZRhS7wJWMaBvJhIZAtkgS5knZDhQFYAjy8r/QFnnGm/QvMgVN1oUKfCOSXdfe7YSwAFcyEudLymUG2oZZm7CTVOGY5N0zkxwRYpi+hlykafWSSXQfkG0rXe4uv0MiGkMALP+FvF+mmxok4GVEDjlZ+SVxqlEeEneSjtab+kp1J8abi4PQueRFkaqmuIzq/qhIR5VALkX6uXI2NNVOZkFWC+NBwf1aiZ58JifnO2eWJJ58smoq9wen141+RqZ7X5ASfSMQWz++J1OgDG91upp1iQT17ipjZe2rTygXl9+X9HNEwDedvaqkvdSCM8ztt/h5jHb0hHlmmVWPfT76GukAfnf96BulykEK0STWx2l0nPRbqYO0iBKxUOuIGemGtmEDD9+NYELJ0OqTMf/fYXynjJcYjNfWuiVUAm1J7ZLlEzUV83GZyD/db+z9m0ACElvFjr5HuSlPwPbSxDLEeMK54Kh5XylpwGeG14ESB+M80bk59UBn4lxxKyQXWkESDFMWXAFZKBhgguDcvO2e29i/fr8VW4CdT
 Ol3gEmaT
 Z0ZGajoEi5FoJaXNFJV76luusXNBqA18xkmyLq5Me8J594RdoxaOOAuSTFyeTcgZF6e7sNu2g5rysvHxWlLCddKHyt4Ks41rHkEfvThFTALARj27tqM0Clm+/sk6mr59yD8ohjdoVXvNdz8L1YFUndMJno5JU0mr7YCeeT83ijhZxfGt+3860CA7D3QXrCcpokZZ9h9TfpIsZxWwsTBOtRtXcg2E72cA1mU5u7cmbUm1SmGZKV1a+Kd7xoqWlx+nipGh+fdJWr2X7EspD2PXVFc2HLYy83L7UFSi3O2/hFagJCndzyKplUvTuQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Encourage the compiler to inline batch PTE logic and resolve constant
branches by adding __always_inline strategically.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/mprotect.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9681f055b9fc..1bd0d4aa07c2 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 	return can_change_shared_pte_writable(vma, pte);
 }
 
-static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
+static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 				    pte_t pte, int max_nr_ptes, fpb_t flags)
 {
 	/* No underlying folio, so cannot batch */
@@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
-static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
-		int idx, bool set_write, struct mmu_gather *tlb)
+static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
+		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
 {
 	/*
 	 * Advance the position in the batch by idx; note that if idx > 0,
@@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
  * pte of the batch. Therefore, we must individually check all pages and
  * retrieve sub-batches.
  */
-static void commit_anon_folio_batch(struct vm_area_struct *vma,
+static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
-- 
2.53.0


