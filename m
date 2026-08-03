Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDAFC55838
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7686B0098; Mon,  3 Aug 2026 12:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08EA36B0099; Mon,  3 Aug 2026 12:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFBC6B009B; Mon,  3 Aug 2026 12:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAC416B0098
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:44:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 593A5120751
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:37 +0000 (UTC)
X-FDA: 85060531794.24.ACB57CA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 468B480008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oI+Ftq7Q;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SdaodsKJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oyC4x8nG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zhuzRUQD;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785775475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=QSbS+VlX5JzUm807AlD8/QBng0V5VacZ0fBzVCadCouX9mZjTTZ0cSLTJNUtNYXCUcx6ZE
	nfriN2ogwVFJfS/TpjiGm3TFaIfTHd4u5EDuwAzkBbg0H3Jju2dVv/4yQYWGLwK1dvMBV4
	IfSvfmHfvBaiKEa2Aky2YgPEkShjFL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785775475;
	b=SISqLkEY3/11Qj1L/5bEqeOXT8tSnU/Rzso1jpQFlAMZvOSAVmylZMP3r/o5uqbaN5c/yW
	S/m3sBuLn6fltwW/00OskKNKY+1BXjgI4ChOiCpUYnSF+s4491d8qY0LwWyC7qSmGjsutV
	MOyU/68z/t8xfyCNJz9CDke2UsIHM+0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oI+Ftq7Q;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SdaodsKJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oyC4x8nG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zhuzRUQD;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 04F437F29A;
	Mon,  3 Aug 2026 16:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785775462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=oI+Ftq7QHwNOamWLfQlxR1s+VH5H/xHD/n59sLRhbDnUPY9Jvs7OPu/wS6fnjjFWyQ94kH
	L6sBuRsm/vM98uxrAHA2p0PLJrArW8I+I4OKkUUSbVrF7M8JJrzCSxgB3JFmrDgmRulE9/
	pLR5gNZLJOIdmogEzhi5DC5wm+3GtZo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785775462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=SdaodsKJpIffkXl0rAXcmAW1realq0Vrdd5uFSKLcyUr6W4xjRiWN7LDYcdlxw7f73wVY0
	BSW6Vv0K1rRX8ZDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785775458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=oyC4x8nGdSsYhE7uDhFy3mpsZSTObX+6KaI5+nPtQCCSmMzdAbivpkEH580bXfATRx/499
	/rnbBCrFvwRNm/TnnaBO6iCsti8Q5QbYfshEt7TrUbVEgvi8IhaeAPJYfsjflNMtSyP0YU
	D462sgy/vukAbxb8Zj7r80eCdhkeJ1w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785775458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=zhuzRUQDrnP+Domlzo3/1FCpIz6k8srBWDErZHHbFo3HOpyS4OcSjVjI8vhU471Qe7a4LZ
	81LYndPgkMk3LsDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CBBD779E7;
	Mon,  3 Aug 2026 16:44:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sB/XA2DFcGp/SQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 03 Aug 2026 16:44:16 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 5/6] mm: constify generic pte_get*()
Date: Mon,  3 Aug 2026 17:43:59 +0100
Message-ID: <20260803164400.531199-6-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803164400.531199-1-pfalcato@suse.de>
References: <20260803164400.531199-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oyj9k85ftu5od3r9nzi7y55u563bd8hw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 468B480008
X-HE-Tag: 1785775475-192323
X-HE-Meta: U2FsdGVkX191Bs899sF84k+PU5diDDOedyaOnvMRHWwOCvodHrEL/8WBcIoQkI200j/XvWkCZJr8Z6ELb/f438PUuBGIkgJ2XnYbyMte4Njr4UD4TcMFblzEKXUGMlNLUXpQqIB9KakMdWdLYy11kSvfomTFFJvu0khKEHdFf2gob7jryrY0JBWr3Fd27uN0c8Z2p3PplwADyN9azPoveTyvwMTKKk55zG/ryRL820Eh0oMYvuU6f9/qy3nUbr1tZBt/BwI0GcOm3wfvFdFs+kvKXNir1EwWPhyR5y47V/hys9OImwRtDAfnDprButwGbm2OWwkfjvHPsWtaT4Oq7RE3IO0UTTWwlQSlhzgct1byNIEcT8KUyRV36sjNdFUHEmKsZHvXkDgqDC5G7YunTT3JOBd0olJgcXgpOiNz/37pnzqGqIOaog+IJX0ukzNxRSkFp2eMkkov9FlUK3o75elPH2H9Gy2e28K01Gd75iyQt3ler/xjgRnRNR/wmGrY34Wu8P/ItnKXlYp6+SLDcNkw26hm2qmy6NwKMenDIod6rXg6Z1LWJ8KOFT/T9cpW2dwYPU1oQ+d9uymJnUqP22bqzBcKsAG0xfZMA9l3MaeYTBQC+V7ngKUn4y4s9zWJEfCmaTpqPIBFLZZMUWly1YqRGrCNesMLYDg32jGo0BP5E4nzMLw5xRQMAtsYOoE5Sr9q6Qtc2clqH8aAsHmyKvxy8Kv5hCd0mYlwLtmvVjYH0iOU1LupI2ZP7F5D9zX3tt4hSgI6UvJdtUYpVFJEXO8H/W8eirrfj5V6AzYTxqBmsah6hiT5tUYZN413WckFjoX5MUxjp9DrXPGZIX9UDyYUAF5j5vahmmOIss2ZqFhpFkqcqLI7VtAjX2L9QaUbrCxF5Rpn+ZxkYqcOP2hc6MsEo1/Afg8AVFxcK4/UyV6sya1mJuVK7nGmo6688CxI5juDC0t6bP/Hsezav7k
 uq4cKY67
 2pADEEgmMn1Xxw8EHx05cAkGf10olt8/RyQ5WurAyP37vNeDEexWM5nQpEWmzAioMFH2PfPf2fXr63P0xGbrGOhEAhtt5IwWVLsJf2L/ZxnPA4nR9jBmNz6QvrQfdMFmc7atYQi45GbPW0M/sRKg8KWxTnTdVdhpxi7hPj6smN89+cwiOlGVXutdJJ3hFs2bRavQZvciD0zJqO0M6GRVx9NLqXz1FiGbZ8M37WF6WqEO5ZqLAjV+xe296lcB1fJngMaPCp828WDv1y1EMpJq3nh3D17a4+0CxwMEfse88tb8J+vxgpo/NSD86537lixYE2E09qEKdXMvcueCrt0NBfB7jRoQ0jvwoMf1neEIJVBYOt8QmM+tDjSfJs8ZCLZDYYhViiBICI54WkcftjDBUN5zLq9dv+Msa4i70GGjdR1ly2iJ1uefded2C0eSdQip5RArXBM2P3MLunRC5MFU7iTNWl0k8BDKv/ZxX57rz/jq+B1cwkRJalqjZvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

None of the helpers need write access to the PTE. Constifying the param
allows for const typesafety.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 include/linux/pgtable.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..dc418553e57a 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -490,7 +490,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #endif
 
 #ifndef ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
@@ -739,7 +739,7 @@ static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
  * present bit set *unless* it is 'l'. Because get_user_pages_fast() only
  * operates on present ptes we're safe.
  */
-static inline pte_t ptep_get_lockless(pte_t *ptep)
+static inline pte_t ptep_get_lockless(const pte_t *ptep)
 {
 	pte_t pte;
 
@@ -777,7 +777,7 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
  * We require that the PTE can be read atomically.
  */
 #ifndef ptep_get_lockless
-static inline pte_t ptep_get_lockless(pte_t *ptep)
+static inline pte_t ptep_get_lockless(const pte_t *ptep)
 {
 	return ptep_get(ptep);
 }
-- 
2.55.0


