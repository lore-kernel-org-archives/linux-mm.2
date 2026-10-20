Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F9560A3818
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=AB1WHqBt
Received: by kanga.kvack.org (Postfix)
	id D27DE6B04A8; Tue, 20 Oct 2026 07:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C640C6B04AA; Tue, 20 Oct 2026 07:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04336B04AB; Tue, 20 Oct 2026 07:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF206B04A8
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:59:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17816140145
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:59:04 +0000 (UTC)
X-FDA: 85342858608.19.BECED9A
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB8B120010
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:59:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AB1WHqBt;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5dsk1r4CpLxFzZUxacgQtAcApMHxSN0UPdR+VrmuZs=;
	b=b/Fcm6iZ3eZp0tHSL3MU1SCTd01YsUOL0Tk4WrtsBLdDb0od93U31JjjdiidW5alV+Lek3
	m+NdX6GoFjaWsjyqW3PwQrlyJ+xQeu0ZnwABJyPdCsoTDQZ2t1UtMZD0/Q1ZOKZpc7qAmq
	ZtRisWRkkSk2q72LQgPr5lnFVJJYSSs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AB1WHqBt;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497542;
	b=04viQe9sH7ueDiQsjt562XL+Y5p4PsI7LNAmt55ws/Uc/ba6ZgyQeUgN1XJbgZOf6dt73W
	QORkcxT53UhswO3/rel3ToOUlvHd8LLmHS6zdmdJqs1tWUk+wqKcOBwWbgfg+/bkQtvkb3
	SWT4hWzJIK2HZ1QKuyMOaj0r5qW80Z0=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so1011729a12.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497541; x=1793102341; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L5dsk1r4CpLxFzZUxacgQtAcApMHxSN0UPdR+VrmuZs=;
        b=AB1WHqBt6Gk1as/id+caADPIxCkZTsqFbo9P6k/JIqaFT2qHEeqatgASAcJquZLtJG
         1Zda15NOSFT7tbVLsfBLAKuK2ljWBFNqUHL5bjKwGeS/XZGU9RJry5KEAoSPBVDtEJCe
         TkmZAOCpoHkHWxOFlqEtyFvWMF7um1G5Enz/GJ+RiXU0bCRbRU9zu/8hVa7Xfsg1ntEj
         mGAAMM16HdUAho8qw0FsOC2D9Qia12LkMb7D3JnsLwTDmgE6RcdSqr036ORb6bIPUmP3
         QtfK7gnVj0l/FGwr4oQd0YnDzNBInY96IrtZp8xyys4AsXcN3k3Rt9LW7+XACBF3AZGG
         ovWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497541; x=1793102341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L5dsk1r4CpLxFzZUxacgQtAcApMHxSN0UPdR+VrmuZs=;
        b=Lt3GdNTYfWoaCaQh7EpgF/SnlrTTOCqc+Ea6vw3NRnzYNaFu/M2b0DBAD8foaXNSgv
         4qtlpHQTTOfpxPypEKBXtBPnrE1kOzXiJoy/aldS+KNtdKSXrujUs/UFEUyBCNi1Ki2E
         SX2xYv1LJ21ZOXXeG/892GOETaGbTBpTj+8j641R0VYK0AjDyBMSXI/UQRkyzGM77eze
         n84G0iam9U+nnzNqqcfvZ6tBtQ2TXaZh/vWD/Slzixarsip5hROjBMxlccMSK3RhrFM3
         iyC2Y1YF8lbWvp1ywfT1RppnApDG55m0GCJ59TdNeLoc6lHNXKQFrHzKTncCMXSlLlSb
         m0xg==
X-Forwarded-Encrypted: i=1; AKwUvBwjA7M8gpQ7sKYL3RgPYXqEeGPRhRiNHLqBTa3yABVqIz993fk0rC3Y2C55hVZJmrO6AArVM/TZJA==@kvack.org
X-Gm-Message-State: AFq9FYIHnE516n3qK5KjgahxrHkKKM4c2YfOCQV8H+qF3CznR6t997y+
	LGtcbqbtjlh8QK/6P0nuPgZ1kJ75MvZyK15Nlkb9ehVTlpuNbY1RNo7wk/c0WE/ptoA=
X-Gm-Gg: AYBFou3dAwE+ryihigoTw6nOjX80fWyaFx3imi/4mWPLNKfqbhfj/rwWODyLJiAm53O
	B15X8qyDKgywtvNHTPr44bSAPSHMkX+EtgAwrLSeNTFoasmfwf/B0ML0TAkiZdHUhq7/B6Lwb7D
	ZIAfmDIWuInB77ZFGy+L1l5zh2ybPs0WfRs0zJqxP2N09Nw/VmsITfJS/EobqWW9NrIjPMwoTu+
	IAYxiLrYeADSdxuQMnBLH8MsCGbS8NwQGENnSVX0M9pQ2lu+yXwlaTsQSg7J81x+W9Aoua9tGoM
	IKSge2dHYG0moJfDcJHdTykcaNDzhhBW/ZdtooOIO6/sYCRpyE9ba5tmOV2iYFXfHCKxE0JNQFS
	xLFikSoys0Wxpy257+x5oulCy3Oo6+iRNBXZwmYz/bPGA8LWzd2VhKDDKeGRykFTMkD6hvTGAqA
	YBXZ+Ci8PTt3YXeSVg7u1fsCEoc/fAxUgWKZY2A+0j9Yk3+ZuVzKcKB5roZL+PW4h7njvKBYwib
	Pk6OwjermW95iMQov+NuWePmwiCUjUqsfw0VfTtBuJKXaKs01jyd7a0vBCyfVJoX36/UfrLqDHO
	fQ==
X-Received: by 2002:a17:90b:1cc6:b0:3ac:c005:cf07 with SMTP id 98e67ed59e1d1-3acef3d6405mr8700493a91.42.1792497540565;
        Tue, 20 Oct 2026 04:59:00 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:58:59 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 09/12] mm: hugetlb_vmemmap: make vmemmap optimization folio-oriented
Date: Tue, 20 Oct 2026 19:58:21 +0800
Message-ID: <20261020115824.823278-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB8B120010
X-Stat-Signature: e6zs7kztxna6xmmjq4knzpfdr7cy3u65
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792497541-907058
X-HE-Meta: U2FsdGVkX1+6kjbjxo3xtq6J/vovYJe9kmKbTnoaaqCcAti+ztH6y7Rl5+Kc6LDkXxHUygu61rcHaqM/mvES8N+jkIgf2KPguakqKq41JoYqSCUaa54Fcd+a5QAsCZB54H9jTHpVuiLOTjNXN6FDTXlaZnHurK75JMju74qT8Q2IbQEe7CaRUGpnuTDmxIYb/unjF1ZGXnbfQYoZh+Nxb8CMX0Pi+Bnr/auBg/nY9rYTWmVvq5ZiVkDg46/b6GRirtrLgxboYVg/kDDL8JLxjzW6nHIMp1DQCgKCxL/Qt0Pafv7BMS3JbAZ39voN2lGp0xa5YeiyOlS5DcNgMHtUuuUJ1tzFAHREyqFwszn5CARwi+4cieKFAN4JX346L3+Xa/lqdpygORA/IhzEVD7B0oEr+gNSu8HeUCUoVEePup4KfTdXW0Ucu6H5hzCR8ypSBsr61NRcguxO7hW4YdxW+xjVId2HfRg7CCOANePdkRN7Uf5s0LtEBgJVjjeND1wYbSjYlWpQ08tjB8dt2dvxXnwLgQddma1t/bqhl2uj8EWKUIr2U9FI9vQ9wRSSfGflfWTrXUdpnzGGqQs9UxIa1gVN4QTaEfJxiB/Q9oEKWpp+ZHJdDd6lH4AlwbZBNc/Q2GywYoyV6xH+T8Ie1RAsDQpQB5V3m/PHkREaBgbtK0RU+k4MN9wIPFJr3gfmJlcqAJc9huSXFpe0OGqmhzN+kzqAG7V+JnCWfu1jSHhrYy7vyNNXmng26PDjFXkczOM70b7vXyuawq/OeYyUby1UrD/CZOwu0mW0VrZt7QZAzN1RzwQEWqX/BN1pGbTzAm/HaSTXAmiI6AwPd3GP0AhNdb4kuJzuSucK/qTrZCSryhJZkMe+K6DDOhiFlnVrp0TWs1jO7wkjdmNnMPfvjJDr6Qfx0DYpoJpzIeFwed/WAUMo+4YOjlDcb1LWqUYxizhZIaraHCSgyU8lreeDvK+
 jiegAf8U
 oGVF/jxUnyywE5+lvY76+fH6j2kUyY20alcB1QAHI+aDkbI0qXYZEfOEG/Us1eYMifE5Uzy08dKlLpT2XgtirK4NT5LofYbhsA3/PMA22gFpItjxhSCqpgQohbZ3zWakwjd7MQonqrn/SxEbuU5qhFxw0qj9+ZKwTYWhrA8flxC7mkgzHm17jD3WyBdLmaoGWowQU9wUZ95XTa60X3kDHQFD0ZD+JkV+ThZGzl362hUYiTEtwOztZeYrvdYNaLLxGEiZnm89AARZsgkLt6ISXTYi/u4k1386g3EL8ATK/qPQNS3aUgiJy6nVWRywrPcOgCKwiJBTjP+PWQN964Yi9vbyt21kBXYK7uZ+q49oPsImH4u4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap optimization operates on one folio at a time, but the current
interface exposes a raw address range and requires the HugeTLB caller to
prepare part of the operation.  This splits the common mechanism across
layers and obscures its natural unit of work.

Make the folio the unit of vmemmap optimization and move the common
mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
eligibility and state in the caller while making the remapping code
applicable to any eligible folio.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 67 ++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 89f000227d4b..b76203e34881 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -232,6 +232,11 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
 	return dst;
 }
 
+static inline unsigned long folio_vmemmap_size(const struct folio *folio)
+{
+	return folio_nr_pages(folio) * sizeof(struct page);
+}
+
 static inline struct page *folio_vmemmap_shared_tail_page(const struct folio *folio)
 {
 	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
@@ -299,29 +304,39 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 }
 
 /**
- * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
- *			to use the shared tail page.
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
- *		responsibility to free pages.
- * @flags:	modifications to vmemmap_remap_walk flags
+ * vmemmap_optimize_folio - optimize the vmemmap backing of a folio
+ * @folio:	folio whose vmemmap pages should be optimized.
+ * @vmemmap_pages: list used to stage replacement pages and the old vmemmap
+ *		backing pages after they have been removed from the mapping.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Remap @folio's vmemmap so optimizable entries point at the shared tail page
+ * while non-optimizable entries are copied into replacement pages. Caller is
+ * responsible for freeing the pages left on the @vmemmap_pages list, even on
+ * failure.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      struct list_head *vmemmap_pages,
-			      unsigned long flags)
+static int vmemmap_optimize_folio(const struct folio *folio,
+		struct list_head *vmemmap_pages, unsigned long flags)
 {
-	int ret;
+	int ret, nid = folio_nid(folio);
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
 
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
+
+	if (!vmemmap_optimizable_order(folio_order(folio)))
+		return -EOPNOTSUPP;
+
+	if (alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES, nid))
+		return -ENOMEM;
+
 	ret = vmemmap_remap_range(start, end, &walk);
 	if (!ret || !walk.nr_walked)
 		return ret;
@@ -486,16 +501,12 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct list_head *vmemmap_pages,
 					    unsigned long flags)
 {
-	unsigned long vmemmap_start, vmemmap_end;
-	int nid, ret = 0;
+	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
 
 	if (!vmemmap_should_optimize_folio(h, folio))
-		return ret;
-
-	nid = folio_nid(folio);
+		return 0;
 
 	/*
 	 * Very Subtle
@@ -509,23 +520,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * the TLB and clear the flag below.
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
-
-	if (alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES, nid)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	/*
-	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end).
-	 * Add pages previously mapping the range to vmemmap_pages list so that
-	 * they can be freed by the caller.
-	 */
-	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_pages, flags);
-out:
+	ret = vmemmap_optimize_folio(folio, vmemmap_pages, flags);
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
-- 
2.54.0


