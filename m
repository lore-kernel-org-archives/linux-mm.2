Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 159E1CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ADE16B008A; Mon, 25 May 2026 12:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785996B008C; Mon, 25 May 2026 12:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BC16B0093; Mon, 25 May 2026 12:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58BB06B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:55:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 094991C0A9D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:54 +0000 (UTC)
X-FDA: 84806544228.12.ED90BAB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 183A014000F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mG7R0VI/lZ8KXgKD/G9nc0nl6JWJhfPrhQ3JnQqpHxM=;
	b=668KVTbERvtUw7ZrvjXM44YSyZCCllExD8rQ0Roi74o2f8sh12Gfkr1YQA6v0OH5hEYm89
	t0XuFQiO4riZBomgdNkDOS2PpMlcj4vJQH0SPi4tgkYon5ilyNILitsSnT+y63AJG5VXGB
	1XmP9saZKc6OW8EReQvNiS6csSihaa8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728152; a=rsa-sha256;
	cv=none;
	b=Epc8gQ97pZgzzvAZOa8EqLDP56ieZ+TLWmBUZK+8thBx90moR3NRmNmOxGhv3j94tm5KmL
	bv9Af3oxgVpboc8jnqbDWay0t37y29f2z2lx3eB1LE2pa7E8DIV8OtjxWNMV1RsvLgeCck
	RJaOWnK8tPnRk4mIpmm4gZ9Ai8tylJ4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EDA686B871;
	Mon, 25 May 2026 16:55:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8924759D4B;
	Mon, 25 May 2026 16:55:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cPJaHxF/FGrlRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 25 May 2026 16:55:45 +0000
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
Subject: [RFC PATCH v3 2/8] mm: Add {pmd,pud}_huge_lock helper
Date: Mon, 25 May 2026 18:55:22 +0200
Message-ID: <20260525165528.184397-3-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
References: <20260525165528.184397-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 183A014000F
X-Stat-Signature: 3yudg4xqxduisfriyhkdgcd71ndakdqz
X-Rspam-User: 
X-HE-Tag: 1779728151-285957
X-HE-Meta: U2FsdGVkX1+N3RFhuaSQTzQCOmq5bjdI/XnTTbrAIxSUBQAcD+Lg+wEttBjzCYZMhYZ2ppoeEmeOh73xTXbfhDBQG2antG2vq+d70/Lke6kSKR1J58wEv93b0fZ3nsRUw3leHNW9VgiuZt3CX/h0vbCUcZnaysO+lylftdl44GSEh3R8gqJ5Ya/gGS0Viu4Y79MReoB9MSahdQf6hzfpFeOCd+gMH61uGeW6eEyxiZQHAUgjQY8jgXlZ8NAvQCO/kVwMXpV50X/4QMczdryCpJCbXMPcXk0+AxwEBVrhvgR8xhgOPCvwhOgtezUISpbzLGoZqA1OLZzmLhAKA9yl6RraiEwi53BsvkSp2avedzzz6am7cG1bYIBh+wXSJsDpNk2X3yWTfVSC7S+DZeKNAXjcI6H/zpDugh8hsxw6wDA6f/sxn5taS59TWrpqYWZHkAqIXnbtYe1/DhUeerh4ePnw2bYbMeqGa7Xhu4aBC0ouKI/Idc5SlKcoRkKGann/3TpG7GFPFolS+hOh7lUselv3BAtAUtMvHtS7ORMyTvmkTmwhw00PTaUCaYyefj9eEu/yP3WbVxCBFebWUITixZafIvl78lxx6kx3HRM9pUolLy2wAbpVG/yl7EWuJcsPSy4kYoQGBitF/72MpC0fO3VzLZcJbJ/XKwbm1zRclEZ3gW4KbG5zW6hFOLvK/09yYmWJTt8YI1BSXNVoxyMewi02Bd4cjKbohF0xpC3Kf3QGYL83G5oLHVql+uT3/cZhReAscysdC3KYQWF8yItTgg+CcK/kmkvvY7IDaiSLlZmkpjmyhSWXMDffgTFt7sTyujJvH8tCYmXCl6kmVIzqGNBRs7pDfqzeCr8E92btou3iRpANhgc03D6ewQn7l5v890yjAN2XIzUY1sWdW7p6XUCSesvfhwgNjcLMHbwvB1B/cEJ578AIoMT8jJeNWT/IJtWTGcpNahXwqll0hTT
 kgwVlH1X
 +hDf6hEZ+0wXLrt1PJ6f1QCdcEjcDasTb9r5HZj/UZ/IUG97UWTZPOY8sl0mhTf/bkdqvKUkocbCYbp72J37eCo9ZQpts+HZuZF59Z+dNQBlhtYvXoVFUDdQKo6eyw25mjjCDKgI7moMRs7ATERE6Gkf3Asp7cgjP+bds7nwjWEhkRSdELYBqoR1mQQ/uODuKKToz38CEsz+lQ1w=
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
index a171070e15f0..93637890cbeb 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -667,4 +667,36 @@ static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
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
2.53.0


