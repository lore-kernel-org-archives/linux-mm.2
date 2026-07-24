Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2451BC531FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169AB6B0088; Fri, 24 Jul 2026 06:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F24D6B008A; Fri, 24 Jul 2026 06:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAEB76B008C; Fri, 24 Jul 2026 06:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C47876B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:20:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A06A1C080D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:28 +0000 (UTC)
X-FDA: 85023275736.15.5DDFA56
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F9C4180003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cHeUSfZE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ACnpPWnC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cHeUSfZE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ACnpPWnC;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=09tYejPsGQfsVWqEcfAsghcLeMGa3UPh5rDucVOapd/dPveRxMTidP1rM5fvYtA/I5cRE1
	Vl3E+oy6zLorLl+XiRToO35utaGF89vnogWs5c3OdPRhfHvo0vDlcmef6ltD+jP/1N2Yfn
	QL1aEhmXAv/t6CE+Fb8KbNZammHRKAs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888426;
	b=EyWtqBZg5Uwwiu/DqQWwozL5qJYsVQIMIH7D7z5lD5trKvN82/5+jCedCRb6VPVTccgzb7
	ppKWcyqFQ4chl0+QwgF0RiMz0bPHrlKQ2pcXudo40e87aYCbJR76lyiuPYJWqnevlOe2VP
	AfQ33rbQgDQAMxlG964wM5X0Tvx0/L4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cHeUSfZE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ACnpPWnC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cHeUSfZE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ACnpPWnC;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D52A57B6C3;
	Fri, 24 Jul 2026 10:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=cHeUSfZEQjvzCd0c77DqG6EraQum2jJKCxbJ8sDSWzmdA2y3VrInTakCZgF8Sl4awfwq5O
	hcO/m9801AN+rHBUlzNQ7BmFoZJBpv6za0RGLkGZ28pAeHn9fnSjl7DbekASs9PdVCq9Hw
	02pyH3jPjM1gZIufEt8NseQnVtN+7+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888424;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=ACnpPWnCmxUaP0K9DkzaOyiQdJOcz+1rKZMn5Hr79jFIMJwKeHe0Tz+qstTMn5z8i4Qqbi
	24zSdxSXu/F0RpDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=cHeUSfZEQjvzCd0c77DqG6EraQum2jJKCxbJ8sDSWzmdA2y3VrInTakCZgF8Sl4awfwq5O
	hcO/m9801AN+rHBUlzNQ7BmFoZJBpv6za0RGLkGZ28pAeHn9fnSjl7DbekASs9PdVCq9Hw
	02pyH3jPjM1gZIufEt8NseQnVtN+7+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888424;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7EZt6KO7lG8FcX9WT699sYwppoB9LUKhBecqXvd/dQ=;
	b=ACnpPWnCmxUaP0K9DkzaOyiQdJOcz+1rKZMn5Hr79jFIMJwKeHe0Tz+qstTMn5z8i4Qqbi
	24zSdxSXu/F0RpDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73A8C779C3;
	Fri, 24 Jul 2026 10:20:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mMU+GGY8Y2oSaQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Jul 2026 10:20:22 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
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
Subject: [PATCH 1/5] mm: constify generic pte_get*()
Date: Fri, 24 Jul 2026 11:20:13 +0100
Message-ID: <20260724102017.141532-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260724102017.141532-1-pfalcato@suse.de>
References: <20260724102017.141532-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6F9C4180003
X-Stat-Signature: jay8ssj1nibpi1wsfucpdxcqpyarp5t7
X-Rspam-User: 
X-HE-Tag: 1784888426-104420
X-HE-Meta: U2FsdGVkX19xTTxcsBV1J8AgBE/HV92IjxJhQLq322hMiJyXlf9clAb59xyKiwzGv5G98FU3Dz4/3mgNglOUMXBKMom2lhhGazrDp9HHWpHwTxm0+UwugtOzl5t1RRR4X/caUFSJGuGZAmka2wEaXL5wdDtgiEJA+Z7M+Nl5PG0ke8UyDayZyuzX16tTLbhYBFojx2NCyn0HsOt3PlUaoEwdpfxAdgRn/InEnk3e9jJ7alXV630nMwOtRBoNJNPilTnkXKjqd2VI6s0VN852a6jHFqFKAEbZq2m70NmoLS1TX0uPX43yBsIMkzigzj4U+yAFmmJULfH+YlRmsr4QZHqGIoslnhW6LcP/N2iLa25V95DvYBQ2sKMEgU+IyXA1CxQmGbyVudTmuXWWtrmESiofXWlpekwU/4MMVWrW/eqfqpsIh0dkN0HQn8BRHlbEhU5molFwAzkd7zFTR/2P2bmmOdk4Q5YxiKxcnVXD/92Ud+LYshlR0hDQ/n0D4Dsc8b07e6+cLU+mnHrCQyJVO8Sz85H9xc2qalke6Ee5FSRMGwoc8Y3Y+ka/5ZGPH93PEFPnHUQL8iVhiUaCteGWozLbC69ukBtcuxP/jGbwzM7iaS9TOTmQhw7AA1pdn7t/Gk7DZt9mZnTju41CMfmqu1rVIZ+ROrSF0FnhJbuyl+cgPsCIujA0UL04h35pGCyJUfj2CnrRjEqxK3YGOJY2v6/4o7Pz/nh1CmEmj5SoLdf3P0ry7btJgqrbAE6sgjS7mEyfsLIoCnyziIVNerPxUMBtkib/U+aNnuaGWODtCn7IOqATkL2DY26OeH4ryCIE5g8XDCHdmQWbWhpTpLKkwRSM9Ahnzk2hA6GfbjWHW1HxR0ZVEwNuAp/99+f/9LPFryQz/xmr/3nSKEIA+NaEdMkFQK/3ppToR4x6DnyiTYLvFOMykLeAuRfiLGpSBtgxZkBuPOPclpsNqOWr1Rq
 wO3kE78d
 NFj+Ub8aZO/0SE8fx03tkahHw/IR+Ac/mFFxDDSYrzifQomQa0zMwqlfnh9HErakn2V8LZQLvZ0542RKXoatxFgAk++ABTiY0+FuEzwXJ06zlXZLJVBVnqYu5VczCGjiN04rdqwksdBs9Z6ZF0QaNBA+WBqg7i7Dzq3GawdXqH+x9THBHYfeeFlfh5zgzKlN+PmFmp5MhCrcgCLc0ivezXqFzpzECOU94gfH77qtQoo3LBmf1+twsRSvgZdgynBOGFNPL2Wj9cLhwAobK24dT8EBmjL7vOoXOmFA9PmKc2zQXiv6e01Dmw1Q5k19zZttgQuBj3opUtZFgQ3bMHb4GV7/gIhdRhTGLhSF3EsDookj/+Fyt1E4rbD46l99Jw5txaBMa
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


