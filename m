Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 675E0606A333
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=VT0JMyEI
Received: by kanga.kvack.org (Postfix)
	id 7CEA26B05BA; Fri,  6 Nov 2026 21:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E5C6B05BB; Fri,  6 Nov 2026 21:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645946B05BC; Fri,  6 Nov 2026 21:29:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21CEC6B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:29:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A40B8A0203
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:48 +0000 (UTC)
X-FDA: 85406742456.30.BB94741
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9641C80002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VT0JMyEI;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uCFWqPMTnZRtCRRA9qkII40/o+YhydxwOfnXOzxxvs=;
	b=Npw9jBwMQwjYbZ4bEw9YQPsa0Q0fSLCY9v6o8amLe6vuegw+TnQAWDAuUTCN0weaeuqfRA
	0RJ+IvANDIO+IMAzKHkPpU/VlbV+XYjm3vtKQGeC12RIUr37hTCxDd2wpXS++6YYvLsWDM
	L8hswIGPR+7s1TK58VfoXWrYHg+I8Mg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018586;
	b=TOSz7QP/bc4GK0ANzOFooEuNFf9Ih/bVqEE/hARTycA097U3M22nM7I+3g+UXPoA+NMqzZ
	ipqBFcNgp+2t6hgP4Tg7WlPZO8P0C0zFzHWvXEg06RhqvKOcyu2oVCgPs4iOCaa7S6PelJ
	F3pCxgEFe0lcPO23Lqi82Nwa/WKfieg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VT0JMyEI;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso1898985eec.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018585; x=1794623385; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4uCFWqPMTnZRtCRRA9qkII40/o+YhydxwOfnXOzxxvs=;
        b=VT0JMyEIcsP/lZ/rMs/jCNMZGx3AAtFIBq4qvRn0zoW8CcNx/h4DXraePgvrJ2BDUs
         2064DrtamyZUOnybbirX58aVajV/NNxWLaoTe1g086qLIL+hLXitEyDyXfDTDZHjKU1d
         ITUYqWO8EPg9MKyWtF8B0ilDQ2HtqqEsXU3BmFKa+vup02hOW9XCyosi+3p/Do8FHdmZ
         l67Cv9qoa2vLDllkTWTdSQub+kSJiEgDbkDfPq6Y47i0fkThzR72MGJn4fpKlOjtiGe6
         uGoEex8Ax38HahkF3sDsv3pWYw2P59jQzufecySPavxQoKO5gQMITyUJBLi/trWTp+RX
         cLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018585; x=1794623385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4uCFWqPMTnZRtCRRA9qkII40/o+YhydxwOfnXOzxxvs=;
        b=P/tAXkTvOy5H5anEsr5XQABKwmn6hQ1/eS8VfL1kBdhWlW0YBnUpl7yuC3Jp7QGAOZ
         l+XHmwAv3E4953Cm95d6LtIqBgqqECh1/vN6toi8ZurmRTNFAWV5fMRHO0SW1E0/gINQ
         sr9rOc/j4QROBRkLRF9iCFiiupVt2Ju+7shkAqX6Yp+ro83f+Zr3O55kI+CtU07rE/Yg
         3Tkok5El3hOUpeax2uXD4yWkn7+kH0/uTvjDfzWty5hVA3tY5nVlIfOUC44C+StRtH4e
         v5oUj/F0MP1J1CIzk6RfgNZMhxmqRRL1PLZVERayqypezujJzyc4kmu1npkhUGbnJIix
         SFyA==
X-Forwarded-Encrypted: i=1; AL+hErF9FYo3GP7TblM2VYzSMn1I3+fLrneZ2bLKSx4QkRf5W8dMqMssh/NtLvpOc+wQfK/1O3qQqa4spg==@kvack.org
X-Gm-Message-State: APuU4Z+sDQ0WvqErxIqLf6MqCwPcF+8jo+EjaI91aIdFD7756hTf1cE4
	JPvNnBo6D4vzTk4Ov/9m73Xr7T9JLnKzs2EFghgNJk4wbWiTXRyYG25YLZqp73NzrAE=
X-Gm-Gg: AYBFou3vfJJUW0wsIihbR467BW+Kc9N1cfXSKg/jFVvrjeRtac2z8aDHHogu0QFZuis
	dmgNAdpnX7a4LKAKmUbAnVv56rmm06D/PUmhbOsWa3pSlPRe9799B/vPpcxu99dYbStKYOYfsfM
	ckFCdPTXc0fjuFZWzgx9GarkIvzWaz/TgkBCk0YLvLJy5oV4MK2kG0RtdpKZ81U/+ywOanh3T/A
	lPsnwv/A53yO2ffx2xz1rSeVCXkDudtXmUE6J7v55NBqw2ux06H9QPaOmmO3HdIlA+YhrqLTl4Q
	XL6e4xUzk+Dee1a3nJSkopm9I2v+W5ov7W34ap6xTDQWmabxSL7IO4PK5/U9ueq8tjx4//uW/Kw
	KyJr/UldYTaBkBkrUlwAHRqguLq++BYpNhVangIAxJob4TZGguOF5QXv6FzyDm6tJQWGEGNOKd6
	1s2BLQEELKzBZwVXIueRFPpQmcK+6ckrWQwYvkFDIr3FLQXGp5pPxpLfi6J1mp3h9GFk+pkeDGc
	Q5CbEYPbQQk3KyCREMbxvJhMH3a6alhw98MPqpXfBOkURvxS2B2Ia2SA0iFs4UIeh3y08HD79w0
	04wTDcayfZ0jTM4TWNAm+rAXdgYjL5ddxteDVl+MafO/qh1orT4QiuHcDtd1
X-Received: by 2002:a05:693c:250a:b0:36c:c483:7077 with SMTP id 5a478bee46e88-36f75b1ffefmr5101945eec.14.1794018585212;
        Fri, 06 Nov 2026 18:29:45 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:29:44 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 06/13] mm: hugetlb_vmemmap: unify writable vmemmap page preparation
Date: Sat,  7 Nov 2026 10:27:49 +0800
Message-ID: <20261107022756.77731-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hgktt54edjqk9u8kc1dozpqeyy7u7zpb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9641C80002
X-HE-Tag: 1794018586-580236
X-HE-Meta: U2FsdGVkX1+iS7uNr+/W1IRNKjobt9/a/LVyAaCy3jUZsNStwaKlheLHgV58Zd9KsmXXzV5evROel19wMHmCVtRorgxlNN6rnToH8jsByM1051dO3oedSxbaBLN7GllP6V+dyrzoTHWYQobSLLtR91wjETBy6CUzo1/+wkE8TTfxNZdrLdy6Lj8wxWX9My7ZnnGA/zRT9o9rYzkzUpae3KvWqqojE6KQ3TEW07Lsj8vXhZiMSSAacBgyDYluwj9kbRiRCQUo/8sQ5qBHU3uAvO2j/lgQ3VmoybDb6wTZDQrF96cXagnpKu/iwlTkXtnMgFbAJLSad7m+vrAFmj4cqL9Av6B8rlH9BliPCWvWFkR1R79FA8QrPT7tVCQCS34GrgC2a8mAxtEK9G0GrgxCysAOfYX3AmIrc+GdkSxMH2Tk9pheRDrMZUkxYP8W2aaY7YbFb6OPf0+Y25tURqptdgH0oa13cpd6D9Q4pyJvPvUuY3MawN/1Wb2GkDqysMWm8fowog610HX+QQsifqC6ATVxR6dGVW5MgqeSWBtmv57FLKQUSHa/on62oPNGwvFaCafjMi7McRUGqeQQBjg8NavfaOk4R5cEU+JaaF4HLsT9hS719Con4coKXz7K8B4BojmQ32Y5tMa+bzTD+89bkaURxxqLsxCovcKcnfwBOi8ywHrJILzgUkgdwb2V7/U1/VXeV6EWtm5np3Bo7zbw8lBmngmYvZshxG8oV6BXeT5WW5j+2It/fkygBwidFm9s+3r4Q60wL7tkIG1gUAQIrrrbNOFDquH4zombrjt0EGtawyBRisnkwsAZGu2RiFtahhVXxfkEqs2ndqxFWl94TsTYBCIHhoS6v+gAyTt4FIjeewcbCq4NMY27B7tZ5fTem8l4FJuBebIq9h8wWmx9joxicQ2jwFKGJIVK9dIu69f0qQLzpjGglcnjJrERv8MA2jhlzRQNeBkzhXqRJ9L
 7sOB4wgk
 pf8QY6sX7oo+sxPn0VAVmoKXVGAU2Ve0qY5mxWbOmQNK+D6Y+s01D+t16EstRaJ5VlgFLXnZKACPFX0z/MBhHbS6hSgREu3bfwTMz1aLJ0jL07/GCzi5NmsJkyX7L7EWogu1leiPsMXW5yp6xRh9p66geo8ykKQlwLDIzlRsknpuVukeSUPbU5COi2QONPzm+xYLO2ALgfBqFcZfPn0rSVSd+f7zhP/4aSJKiLobROCcAs++kCKjhYu26fIHOn3KcOvNiZgIgyturiJkcKLHOB9ZJ2Sdca748fQN/DQvqZmgBbs3+tbspYUMS9jTmauINxXrcsM3AmSioWjo7ZYorCS2d6WBrvpPJV3LsSrmaZ2AE5Tp4JZXfHLrTlRwQfU16CRPjg5paMPF+HXZd3AQj6vCH8eky5nU38XsTif8Joe/40gH2uH0LwGCdHrhwv9S2kHBs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Installing a writable vmemmap page requires consuming a replacement page,
copying the current contents into it and making the copy visible before
publishing the new mapping.  HVO currently splits this sequence between
the page-table walker and its caller depending on the remap path.

Centralize the sequence in the walker so all writable replacements follow
the same copy-and-publish protocol.  This keeps page preparation with the
mapping update and removes path-specific handling from higher-level HVO
code.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Keep the caller-selected allocation mask after moving page preparation
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Use two tabs for the new helper parameter continuation (suggested by Mike
  Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
- Replace page_to_virt() with page_address()
---
 mm/hugetlb_vmemmap.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 290dd8f31738..d58f7a369c9c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -199,6 +199,20 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
+static struct page *vmemmap_dup_page_from_list(const struct page *src,
+		struct list_head *vmemmap_pages)
+{
+	struct page *dst = list_first_entry(vmemmap_pages, struct page, lru);
+
+	list_del(&dst->lru);
+	copy_page(page_address(dst), page_address(src));
+
+	/* Ensure updates to @dst page are visible before set_pte_at(). */
+	smp_wmb();
+
+	return dst;
+}
+
 static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 			      struct vmemmap_remap_walk *walk)
 {
@@ -211,16 +225,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 
 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
 
-		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
-		list_del(&head->lru);
-
-		/*
-		 * Makes sure that preceding stores to the page contents from
-		 * vmemmap_remap_free() become visible before the set_pte_at()
-		 * write.
-		 */
-		smp_wmb();
-
+		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
 		entry = mk_pte(head, PAGE_KERNEL);
 	} else {
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
@@ -253,15 +258,7 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 
 	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
 
-	dst = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&dst->lru);
-	copy_page(page_to_virt(dst), page_to_virt(src));
-
-	/*
-	 * Makes sure that preceding stores to the page contents become visible
-	 * before the set_pte_at() write.
-	 */
-	smp_wmb();
+	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
 }
 
@@ -501,7 +498,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_head, *vmemmap_tail;
+	struct page *vmemmap_tail;
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
 	int nid, ret = 0;
 
@@ -534,9 +531,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (ret)
 		goto out;
 
-	vmemmap_head = list_first_entry(vmemmap_pages, struct page, lru);
-	copy_page(page_to_virt(vmemmap_head), folio);
-
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-- 
2.54.0


