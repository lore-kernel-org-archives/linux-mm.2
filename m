Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D03C1C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40E16B0098; Thu, 10 Sep 2026 02:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1ADA6B0099; Thu, 10 Sep 2026 02:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EB36B009B; Thu, 10 Sep 2026 02:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD806B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2FAD8040E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:28 +0000 (UTC)
X-FDA: 85196886096.04.5047BDF
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 00FF5C0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QOH15Wkx;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022006;
	b=6LaQFLDBq2fsk86LPTEV6Mxxu3+H+2WY0fbgUozvjNGVNLpEa083C2sYA8PKgGevty4zMD
	XoEZlk7wvEYzW7Geat/KgOPXivGU9GYcc3CP3OTXHN6Qtgkx6dm+Fehq1USAEgVoFuFF82
	EHB/xPQnoTJYXhL/yC/YUhXHe+3dRtI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QOH15Wkx;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6DfREAR7YFflJsvomdeYa+yVOrP6yNKuV6EJKciTVrI=;
	b=SKpEDT+r7F3w+APTq391hThopO2828JsAMgDlpjrR5noUSiMUEHIOE6wgNu+QLAFItHWTv
	YV4vlW6FHHZx5g5rQTEAqnfKLqec/lwDUirGnkQ+DRbaMuMx7G2BqyAwc1fGcIuzGo8q3U
	UtqwWtqUu1H3bqC78VEG7QuU4s+lCaA=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c96c92c0980so3687897a12.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022005; x=1789626805; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6DfREAR7YFflJsvomdeYa+yVOrP6yNKuV6EJKciTVrI=;
        b=QOH15WkxCy3+NzE+BvY22B2/8XesdCxbDKOZpgkxkvdKXVgcqhAGfZDg+UdEA3sRbq
         EJi9Pe1vfvd7xzx925+vs228KZqnCytLgzB7wCo71TCWuJz/C0h9aSCHFYvXXvXdokvo
         qXZa4wBNQVX8avRP+y0L7lPOnEpd6xvBIi556yTGzBVbOlCGg/8GODATH1OxE/hDh4tB
         7iO3G38KgiEDDbE/VL3uFnJhK2wcf/kNc1ir2F7tAaAAvKzW2gTxE4VxkQ2PwN1d9Xx7
         lyYd2pBfKyzOI1CQIR0BnDAYOKSAt2py+FasSD/Smr1jHbNV5MpgCPhxK6/JtkWdkhpT
         RNZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022005; x=1789626805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6DfREAR7YFflJsvomdeYa+yVOrP6yNKuV6EJKciTVrI=;
        b=RFzqM4NyAaOADs60lAv620N+PI16dILxeD/fz8sw5iDynk+M/njFQEBwgwRrgswpBo
         U8H5BH+o5lE9ea1scasAUh71FGdYYrTLq6pyBQW4aTPIJaU02z//e+/SID+iYEVnKgV3
         t8byv1wM27noNcsUnGzjdqPsRTsQUpJhQbexZFHyDp21PQ4+fvF/r0QZgwVoky30Oz9x
         mxgd+MEdzHHRDaAE0vEaC/8otFUfNx6cfbDnU8k/SiscPuDW+CdAv38BsQHQ02DSrDEE
         FKaPk7adls+H9tE499qVV4vO3D/NTgYeT/CK7jFnETXS3lxRLKviYlNmDZAusdw45E+b
         7IqQ==
X-Forwarded-Encrypted: i=1; AKwUvBwPA77b+loDXa/9QoBLalKOaNQD5CqPILpvSWVMpQgvn8cG/dxpT11HtE6m141A6PBV7NNeOLzcXQ==@kvack.org
X-Gm-Message-State: AFuF++n4QEXhuHYK73TsENpcsmow4ikEDSrtZ4Ps683XVeztBxs1B4TM
	fBNvI1UB6c3/pC7V0eojDEYJ7lYjD0DSVdqEJJxiFKhLtkqr6y87SD/4BrJpnKml3FU=
X-Gm-Gg: AYBFou3XnSe1mixZCqDFQrnjEELtsb7owbi6qjcGNXTh3j/pwGOqoxOFkEUQttVHnHJ
	Jxhph9DMkdy1M/Y4HINxkkLPdkLmKh/GIuk3jr2r8G/7Oc5pVjdoupylg0jQI0fMK/TAqLB3LPT
	OrqvvxYBirjhCsJOk7Jl6I5VsgV6DpEQwljg9xAj1JejH1v7n7AZlV27DfiS/mqFXD3/MeAQYiX
	bwzJ0HvY1C7EWLxetjYojEqANvM/UR/9+MaGi2BfyoNv6bvNnOFU/meqvGr8hLxXFUtrbPNkjRL
	n+yu72GjOcAAle0PpfA+3yhOWe5+vhjYjYOF5YSNcRqtf7jfVpqdLoE7vknLoYnWxDM68zh4VWc
	/WtYjTDDAXujjQOPEe9Q3vGY4rcZfKdwXofZMzCrA1zF1MEq7JoHEh/Hi0YpWnJbVLRapwizRz6
	SO2qUo8jhYHaDFO+z2cE1F+vXSOviKkGkoaZoesLd4Fw1QAfXVvoN/ZVtVfQjDeU5fzANEAOkK4
	cQTktdsyMOByVfEwcVy+T9q0L5ELhQN7hQ=
X-Received: by 2002:a17:90b:578c:b0:398:e6b6:acc2 with SMTP id 98e67ed59e1d1-39b261e7649mr63026015a91.12.1789022004648;
        Wed, 09 Sep 2026 23:33:24 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:24 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v6 01/17] mm/sparse: relax struct mem_section size constraints
Date: Thu, 10 Sep 2026 14:32:40 +0800
Message-ID: <20260910063256.64386-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 00FF5C0004
X-Stat-Signature: fdfyfefg7w3dsbua9tetyq8d9n396pdb
X-Rspam-User: 
X-HE-Tag: 1789022005-817412
X-HE-Meta: U2FsdGVkX1/++WChkYfN4da1ukERGv6xPgw3THibxLAeLUOZgzJNSidxqBlc0cWpwa2A4gPpM+iSXkU17gBX+TX/0dhSDo9REV3ZKFFeQFzj6qMfb/6hvhnEAg1mhgKIkuyNzdxZkZc9RNFsV+8YAEqQc+MWX921PUnKNQssLeW6GeQsetjifXHfFYmW6YbknFT7GV27fbltKAhCGztbcjR1eISB7J6DjlDFLs9UP3SSqrxalb6Dy+o5JM6GmlgURYAQHtYXHKFXBRJJw7g4zXHpdlVPv44Vv1xaxVEpNljv4Ozz1P0P26a8sXpeFdAwEVLq85C3fqFE3ijFzG7E3s+nVGfRfPwrrLAsokGiJnfyXzUsqy3baKYE9f0NH/ymervqDVXOd8/owHR4fMBowSrzWNvoTsd6V3Hf6nMtySwkjR949Ar+6mAmOjfXxUqv6FL37vVlPCkC/NGSkiFe7qhUQb9dy5laPkfsPa3NhbKJIR4tgU6472g3ohGzomct/5MkhV7hSwAhV3DXU47uqf30teHDZe+zd6lTEZWtePRpFctvRMqixPM3yXrhtEGMFOiT/2J/TNPcTGhZxbSgbqvOCADs5wpfKM2KnUwaMemi56ZQAgLJzmgAdTecYbk7Kq4tN6WlcQlfTESX8CDsoJLTKX8jDKoUcF90uYxiXz/Mh7uzjIR+iYchDvLB02LZ36iGaSUxdnReAzW9c6q68Qw/B7017tvuyLByRjWaFnNGpl7Xecn4smYP2vGiiPOE56JfSMTLgW7LrjiQ3uI957k9/dVKnkLWj2x8zV3+rR1LKbfWAwd8eA1qicqULtcWgb5Isuuw0V6FDZv7wsIbTK9WwyscQzQgZO2A92dslz0O4SPGL7266PAKeFNI16d4JqmvZ4Wp2N7TcKwdytfTYZkCGzNYLxyRxrixBjHCi2zXc+kEMGoHvmIXQOrpJeU/p8ebGnRoSZtOwD/5q9g
 ilCG0dB9
 tmlvtOF4l3wP3L38lZDIyDgH2NTnJUbQfEZkTaVvjBnyvYtNR94gCSxyo0+DoQcrWLtTnPzkwl9wkw9D43YugVcY+tgPdf0wFpF9/Zai6NTfBpCSY+3TuCNIRgh+7LohbdgvQyO+bWfkdGjU4LtVuZlSsBzLe+FDiSY/dG7oIN8rI4HbqIqNrFNcepswfYPK5R+Tz2P0nFzkRpVaTypgf9TF9YJ/qgd8J6OrH65+7amZiixhpKiGHGLveL2WcjK8mJg8uQ4lEyyG/Z1T+VJmaGVbF9GC4K+wHO4S3/0boowDrvysPVo5apyHVaKOnSif+Mv5vwbX/VkPhg686CUo4fWuZ2fGmC0b3J5Ua4M5wBDMbVvtygNGIIH7EFBMSUfeRHsK0VmxTsms7nIflmrefKeK6zsfqCoNP4sf3HpgDG0w7b+nNIMcbtzzhEP65dmURVLMOOemqqp7LYVJZvqJtIW0hrHWCoN8qpKsB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct mem_section is currently forced to a power-of-2 size so the
section-to-root lookup can use a mask instead of a modulo.

That requirement makes future extensions harder than necessary: adding a
small field can require configuration-dependent padding or layout checks
just to preserve the lookup scheme.  Keep the lookup correct for any
struct mem_section size by using a plain modulo instead.

Do not leave the layout entirely unconstrained, though.  Keep struct
mem_section double-word aligned so modest size changes, such as adding
another word-sized field on 64-bit systems, still keep a compact and
efficient layout.  If future fields grow the structure beyond that sweet
spot, the lookup remains correct; only the exact layout efficiency
changes.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from David Hildenbrand

v2:
- Align struct mem_section to power-of-2 where possible, but support
  non-power-of-2 lookup (suggested by David Laight)
- Collect Acked-by from Mike Rapoport
---
 include/linux/mmzone.h  | 11 +++--------
 mm/sparse.c             |  2 --
 scripts/gdb/linux/mm.py |  6 ++----
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..0a2428714108 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2027,13 +2027,9 @@ struct mem_section {
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
-	unsigned long pad;
 #endif
-	/*
-	 * WARNING: mem_section must be a power-of-2 in size for the
-	 * calculation and use of SECTION_ROOT_MASK to make sense.
-	 */
-};
+/* Sacrifice minor padding space for efficient lookup. */
+} __aligned(2 * sizeof(unsigned long));
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 #define SECTIONS_PER_ROOT       (PAGE_SIZE / sizeof (struct mem_section))
@@ -2043,7 +2039,6 @@ struct mem_section {
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
 #define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
-#define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 extern struct mem_section **mem_section;
@@ -2067,7 +2062,7 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
 	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	return &mem_section[root][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr % SECTIONS_PER_ROOT];
 }
 
 /*
diff --git a/mm/sparse.c b/mm/sparse.c
index 7c15406e77f5..c84b4c7b8c70 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -322,8 +322,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	/* see include/linux/mmzone.h 'struct mem_section' definition */
-	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
 	if (compound_info_has_mask()) {
diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index 28d33624c38b..193a88d763ab 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -70,7 +70,6 @@ class x86_page_ops():
             self.SECTIONS_PER_ROOT = 1
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
-        self.SECTION_ROOT_MASK = self.SECTIONS_PER_ROOT - 1
 
         try:
             self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
@@ -100,7 +99,7 @@ class x86_page_ops():
     def __nr_to_section(self, nr):
         root = self.SECTION_NR_TO_ROOT(nr)
         mem_section = gdb.parse_and_eval("mem_section")
-        return mem_section[root][nr & self.SECTION_ROOT_MASK]
+        return mem_section[root][nr % self.SECTIONS_PER_ROOT]
 
     def pfn_to_section_nr(self, pfn):
         return pfn >> self.PFN_SECTION_SHIFT
@@ -249,7 +248,6 @@ class aarch64_page_ops():
             self.SECTIONS_PER_ROOT = 1
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
-        self.SECTION_ROOT_MASK = self.SECTIONS_PER_ROOT - 1
         self.SUBSECTION_SHIFT = 21
         self.SEBSECTION_SIZE = 1 << self.SUBSECTION_SHIFT
         self.PFN_SUBSECTION_SHIFT = self.SUBSECTION_SHIFT - self.PAGE_SHIFT
@@ -304,7 +302,7 @@ class aarch64_page_ops():
     def __nr_to_section(self, nr):
         root = self.SECTION_NR_TO_ROOT(nr)
         mem_section = gdb.parse_and_eval("mem_section")
-        return mem_section[root][nr & self.SECTION_ROOT_MASK]
+        return mem_section[root][nr % self.SECTIONS_PER_ROOT]
 
     def pfn_to_section_nr(self, pfn):
         return pfn >> self.PFN_SECTION_SHIFT
-- 
2.54.0


