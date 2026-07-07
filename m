Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A29C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF6C6B00A7; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D506B00AE; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF10C6B00B0; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5618E6B00AC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D091F8D2AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:26 +0000 (UTC)
X-FDA: 84961031652.29.4687E15
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id B1E6710000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eu6JmtJgIul75mz77yq6nYehbhrcFVoONqY/cHfOqYs=;
	b=n86+Nf5Gi5lqfddG1sTkQULJ6+RuiWb9EQWAFS/v2SOCx8E1alPZTv0uYX591812TDkOt8
	12EQyOS+FD9eO4SKspS2mkS3F3rHoPtvzUCGZMxn/TyIUKS4MItqcu7f4kvbw/O9ABp9nf
	fjbzC53/JFStHVy9hRjpEhU7u8PF7pw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406425;
	b=ut0vI3aQJf6ELZF1pIeq1V8JFzXqPi4Usm6zk8aBzHvvFHTc65HH77wM/HFYRCwJE1kskq
	WpyrS3PJaXezV/fcjP3fpJZiIVNxEes6gosCTpfrmrDW3QGoxiAEPQNqPIqlgCZ6MCz+Ro
	EMBW86f31GNomDVbChwfY4UEBJIvp7Y=
Received: from TW005.hihonor.com (unknown [10.72.0.123])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gvWnH714QzYm8lp;
	Tue,  7 Jul 2026 14:40:19 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW005.hihonor.com
 (10.72.0.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 14:40:19 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:19 +0800
From: tao <tao.wangtao@honor.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>, <kas@kernel.org>,
	<ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
	<baoquan.he@linux.dev>, <nao.horiguchi@gmail.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<pfalcato@suse.de>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <damon@lists.linux.dev>, <shakeel.butt@linux.dev>,
	<ryncsn@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>, tao <tao.wangtao@honor.com>
Subject: [RFC PATCH v2 08/13] mm: implement anonymous folio rmap for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:33:03 +0800
Message-ID: <20260707063308.29176-9-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1E6710000A
X-Stat-Signature: 1kcb88jjkeiowg5mmj5h7xq9s5xewy37
X-HE-Tag: 1783406424-820200
X-HE-Meta: U2FsdGVkX1/SZMbqTYx/QeGKitiv6SYHXMqEn11UtxlvxW1NDqgEtsp/XnHRnlTIdOb/VI7Ph3MG8L9MceamI4QJElFipisOjDCtUy2lDNUaPzEZy5osaG0K9WX107snZrTx7bsQjivPql9OVwNdpf+E1dI62OD8yuUt2+Outy9Lqi9VC/Hqarrut2NeFKG0+fEKJo+y8w2UpSdviAA3ZPSOnZtvMyIc6WijtfxJwYaJ+dv7OZQvkfBHju6+nUMSbq0tjS6g+vdxAYL0/HG1h4fRgEkpQCc34cKcyizH8xDOCrA1d/i9TwX0QbdPavEvkPjz+3iOtfKkaCvBBWZ6xsbBp+K24g3Eb2Bf7ZcmAmjFhQT7LlxMMw9hS1xKODRJQK0ZDyMn77NjBMBqq9AqdkfAnXnvQOu0z1BGAT9PCv3n1q+2NncdwFEXpcMHruyDbZAKQRxiXFURpkYWs2jBCtLfpnDkendIpg0/hIOBJ+Mr4m+jtcRBWr63qzgJNx+3Uv/qcjqQFCZsJ8i4xAkHykspf5Op5Mw8WMsT7kSY002Iuvb1VOu7Q9cFLnk7bL/BzIYSSV2FfPyz+rgY6EFhhbtszZBr3QJkhlC80fhuNBmagFsVDr3qqbqdOXxxx7DkYLREHmzpZB5m0jlVgjkZPw9RFWDXJqgpxgdSpIzp3KwJeySsYnynDz3WzTz5DaOrbafkBqLQTBZeKJlF3u9CCNmJIjUxJDqjQVOmxn/fXMEYBdjsEPNNJdrhxJTQR/1N0MN7OCTQzruQ1GYwD0WMgOX8wQTNepKzJ2gFpEyuhjPb4ey3R7GXzwdNMa3zxi7zjTxMlCsU5z45Bxga0ZbfOuJXoDgdqt990vjtSiM0n6eJJs8+5GIRNLq53/MAQ9wSq/E5z3SeYaR9qCAiAIUtO8skeMjyqaiAR91cNdoLWGJa/PYwsc/i8r6H3r4C7UXARanqyx06/DYaZR7zUsF
 4cPp+/6B
 hLMaWPemb5YSCVPhMNbKSr06REOsyfPMgn/iy3oYMQxyD4IRCA57mAaTujI+C3ljbNRKkPpxF0oRAMH9luNl4OomkX9LkwcgaK/4XgQ0OEWlFh7Re42GLtlJoGXcYZ6Fr3UCLe6vCVLuuuowsrthQFt8NsS8z+Ll+a6hGWGF4lFBBpiAkAHO/j9mrSsl+xiLb1mcZSF+Gf8yc+XUNvUJUftEvHYON3CN3F+ShlPSobRXrdMp39Js/OqO10ds3mPWDsmwmuFo6t4F5HtsOYck7t1QR6hPa+dckGA7G5qFUvR65h3cT1lvXKfa/57bwbc3MI1hjg+RADdkqQ5xuNs0m4B/g9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the ANON_RMAP_FOREACH_VMA() macro to encapsulate rmap traversal and
hide implementation differences from external users.

During reverse mapping of an anonymous folio, traversal first handles the
folio's own anon_node, then iterates through its descendants. Since large
folios may span multiple VMAs, VMA updates are used to advance pgoff, and
pgoff is used to determine completion of the current anon_node traversal.

For KSM, the VMA is located directly using the supplied address.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/internal.h | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/rmap.c     | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index 970f11b1af50..b38c7b4c2a8f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -296,6 +296,55 @@ static inline unsigned long anon_node_rmap_count(struct anon_node *anon_nod)
 	return atomic_long_read(&anon_nod->rbc) & ANON_RMAP_BASE_COUNT_MAX;
 }
 
+static inline unsigned long anon_node_rmap_address(struct anon_node *anon_nod,
+		unsigned long pgoff)
+{
+	if (!anon_node_rmap_count(anon_nod))
+		return 0;
+	return anon_node_rmap_base(anon_nod) + (pgoff << PAGE_SHIFT);
+}
+
+static inline struct vm_area_struct *anon_node_lookup_vma(
+	struct anon_node *anon_nod, unsigned long addr, unsigned long pgoff)
+{
+	struct vm_area_struct *vma;
+
+	if (!addr)
+		addr = anon_node_rmap_address(anon_nod, pgoff);
+	if (!anon_nod->mm || !addr)
+		return NULL;
+
+	vma = vma_lookup(anon_nod->mm, addr);
+	return (vma && vma->anon_vma == (void *)anon_nod) ? vma : NULL;
+}
+
+void vm_lock_anon_node(struct mm_struct *mm, struct anon_node *anon_nod);
+void vm_unlock_anon_node(struct anon_node *anon_nod);
+int anon_node_trylock_rmap(struct anon_node *anon_nod);
+void anon_node_lock_rmap(struct anon_node *anon_nod);
+void anon_node_unlock_rmap(struct anon_node *anon_nod);
+
+#define ANON_RMAP_FOREACH_VMA(anon_vma, addr, start, last, rmap_proc_vma) \
+do { \
+	struct vm_area_struct *vma = NULL; /* must be named vma */ \
+	struct anon_node *_anon_nod = (void *)(anon_vma); \
+	struct anon_node *_nod = _anon_nod; \
+	unsigned long _pgoff = (start); \
+	unsigned long _nr = 0, _total = 1; \
+	\
+	while (_nod) { \
+		vma = anon_node_lookup_vma(_nod, (addr), _pgoff); \
+		if (vma) \
+			(rmap_proc_vma); \
+		_pgoff = vma ? vma->vm_pgoff + vma_pages(vma) : _pgoff + 1; \
+		if (!(addr) && _pgoff <= (last)) \
+			continue; \
+		_pgoff = (start); \
+		BUG_ON(++_nr > (_total += _nod->nr_children)); \
+		_nod = anon_node_next_descendant(_anon_nod, _nod); \
+	} \
+} while (0)
+
 #endif
 
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
diff --git a/mm/rmap.c b/mm/rmap.c
index fd22576b0f58..1551e9d2121d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -982,6 +982,47 @@ void vma_post_update_rmap_base(struct vm_area_struct *vma, unsigned long diff)
 		release_anon_nodes(release_node);
 }
 
+#define ANON_VM_LOCK_REF	VM_REFCNT_EXCLUDE_READERS_FLAG
+
+void vm_lock_anon_node(struct mm_struct *mm, struct anon_node *anon_nod)
+{
+	atomic_t *vm_lock_ref = anon_node_vm_lock_ref(anon_nod);
+	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(anon_nod);
+
+	if (!(atomic_read(vm_lock_ref) & ANON_VM_LOCK_REF)) {
+		down_write_nest_lock(rmap_sem, &mm->mmap_lock);
+		BUG_ON(atomic_read(vm_lock_ref));
+		atomic_set(vm_lock_ref, ANON_VM_LOCK_REF);
+	}
+}
+
+void vm_unlock_anon_node(struct anon_node *anon_nod)
+{
+	atomic_t *vm_lock_ref = anon_node_vm_lock_ref(anon_nod);
+	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(anon_nod);
+
+	if (atomic_read(vm_lock_ref) & ANON_VM_LOCK_REF) {
+		BUG_ON(atomic_read(vm_lock_ref) != ANON_VM_LOCK_REF);
+		atomic_set(vm_lock_ref, 0);
+		up_write(rmap_sem);
+	}
+}
+
+int anon_node_trylock_rmap(struct anon_node *anon_nod)
+{
+	return down_read_trylock(anon_node_rmap_sem(anon_nod));
+}
+
+void anon_node_lock_rmap(struct anon_node *anon_nod)
+{
+	down_read(anon_node_rmap_sem(anon_nod));
+}
+
+void anon_node_unlock_rmap(struct anon_node *anon_nod)
+{
+	up_read(anon_node_rmap_sem(anon_nod));
+}
+
 #endif
 
 /*
-- 
2.17.1


