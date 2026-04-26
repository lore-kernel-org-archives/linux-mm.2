Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F65FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3966B0095; Sun, 26 Apr 2026 08:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54616B0096; Sun, 26 Apr 2026 08:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9901C6B0098; Sun, 26 Apr 2026 08:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88AC06B0095
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:57:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46EE11402FA
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:56 +0000 (UTC)
X-FDA: 84700709352.08.B0FA2BC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4F8CFC0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777208274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdCTR0tCpwfzVsn5q0RVh1DnLiRFbAD92h9WzaCJKOs=;
	b=0CxWljRPuByT3Wi0oAb1Rq0fKw9yC8U3pvLND009sNDqVhGyxWeO1Ly1Dw+Xa8PMtjckXb
	2IRewuzXE0YHEfVJNpl5tj5d41gQhIn/mXa4QY9k+V+QV3sKVrtvTAgbyosLBC/Ceq5rNA
	ScsIFS40zYx9EFHB3cnpFUySR/ecJHo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777208274; a=rsa-sha256;
	cv=none;
	b=nNfVIbAmoteScgnylpzLSEKceqqxo5BvEIb0LrFrrRXi+Pj2Zr95ia5ZT/T/R2dGusiQNP
	E1QmcylM//VkvcCFVAq8toHHISiBiDqCxPoGafNUgyggOi9qKqc9RzDDFQBD+8nj94NbDY
	O8+VFnV/wMNCz1p5gEjovE6L/4q40Nw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 960865BCFD;
	Sun, 26 Apr 2026 12:57:40 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34412593B0;
	Sun, 26 Apr 2026 12:57:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aLSrCsQL7mmtRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 26 Apr 2026 12:57:40 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH v2 2/7] mm: Add {pmd,pud}_huge_lock helper
Date: Sun, 26 Apr 2026 14:57:14 +0200
Message-ID: <20260426125719.24698-3-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260426125719.24698-1-osalvador@suse.de>
References: <20260426125719.24698-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F8CFC0002
X-Stat-Signature: 664rf59ztszb7o8gkskgk8dn6hhap8ju
X-HE-Tag: 1777208274-868298
X-HE-Meta: U2FsdGVkX1/c7Dl0C0uQXeum9ZBnNAS85kAzahnPVAcfCXnk+a04FCS5qoNnmIXfG216WuEMulGjLCX4aUE3EOl0Q0xGbEaGDaUULKpQ0qE5hAaO70reg/Pp11tAMkBVylipt2+/COizphWerV/w5ukAI4XYqJ45/5WW/CyYCgpStLDNbSYDD7/PoI1R+aTqnF3gGE5MGFuxi+qun4v8JxxvXLNlxsm8dAIsplgfDexNzFCkN4P7rP9VhxcYidqQ1tmijF8RiW3ZdtBfJtHCfyTW5O0YQATMaWpj6guINZa+hyB/eFW/wRkZCSfacdsOC6GF8bKG+YNFWFhS4C9eoeHsCgk6S7hLX08k+u4kA1dX6aVZs0DD2QmpGmzByPcNAOysetrN7ZiPgebeHjb26X9AFcAQjSGVyDdhbjlI84FTYuJuYJFJNKyk3UXrLvdXzShiXigXAERvDDgGSpPxtlE8ubr1wSAchY+J6R27sAtRF8GaI+zxT8RE5u5PoGbjy8veP+gk3437q9bPULlydEKYBIzYNsiO4kmho+nD1jRLAVd1qzQwK2Utt6OOvj1Y1X7ZCxhdEtF+cblGfmZXI99RvGS/6oKvsZEMxdidvIAblFZMHeTPCdGeIA/tGignXnDzBokOS8+bORF7smCqI94l6sfoqW6ihMvFPq+70CGQ7P5/o8Q8DvEoPf6ckXh8i9FCJm8BJ7aiq3hbqalCbBgqI+g0vytzCubKCewsclKD8lgKsFdNLxxRt8z73mOv/vpaezvEIVbje/bI1vIAfyOKUzs29D7+rUKyW/lpC9uXqYpBafiHCSkDf4vs8IAJSgskQMgUA3pa6LIxzSFKtk/9ncqzlbXVG/j+ZfOsmBSvVtNFhzwcdw9NawZuU3T01eEcM7AduMDQc1PrRknwJKoZE2v/5JPUBm8mO+aSTWC1Yxewz1eqPwl2JRYXqVfFrFCD7zaLpFTgLnGIF6C
 qjw8XR7x
 t+ytFcpClBs0PPCZsEjNkC2RQyrlkWWKg4GOV7S9pABLNZGJu2tqG93w+dIdqC2e1b30QlX9rqvPuCbfqKFaVTWfPc8or6zH9A2I+nMzzKsDbr1VNPYU0fREu9KkWG7go94oxSX2hRzWKwXwjB4vzYia8oPWChoprb5o0YfRmmvTWacBQGa3Si2rlQNIhU6LhnFSl/etu7Wiq2WM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB and THP use the same lock for pud and pmd,
so create two helpers that can be directly used by both of them,
as they will be used in the generic pagewalkers.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 include/linux/mm_inline.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b5..3ac77b50e91f 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -655,4 +655,36 @@ static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
 	return i;
 }
 
+static inline spinlock_t *pmd_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
+{
+	spinlock_t *ptl;
+
+	if (pmd_present(*pmd) || !pmd_none(*pmd)) {
+		ptl = pmd_lock(vma->vm_mm, pmd);
+		if (pmd_present(*pmd) && pmd_leaf(*pmd))
+			return ptl;
+		else if (!pmd_present(*pmd) && !pmd_none(*pmd))
+			return ptl;
+		spin_unlock(ptl);
+	}
+
+	return NULL;
+}
+
+static inline spinlock_t *pud_huge_lock(pud_t *pud, struct vm_area_struct *vma)
+{
+	spinlock_t *ptl;
+
+	if (pud_present(*pud) || !pud_none(*pud)) {
+		ptl = pud_lock(vma->vm_mm, pud);
+		if (pud_present(*pud) && pud_leaf(*pud))
+			return ptl;
+		else if (!pud_present(*pud) && !pud_none(*pud))
+			return ptl;
+		spin_unlock(ptl);
+	}
+
+	return NULL;
+}
+
 #endif
-- 
2.35.3


