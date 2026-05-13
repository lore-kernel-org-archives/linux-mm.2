Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7554ACD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5876B00BF; Wed, 13 May 2026 09:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBCA66B00C1; Wed, 13 May 2026 09:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC0A6B00C2; Wed, 13 May 2026 09:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA7BA6B00BF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80EF5120B75
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:38 +0000 (UTC)
X-FDA: 84762428436.28.3F5BB70
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 934194000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C7aaAQTg;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0ssBedciqiVv0raptLCn49uzFGNVgYKzMgS4u/pGVs=;
	b=rNqcxnIFYi0HA5U/fj8nUUcF2Jr70NpCyMqHkWwaDogQLYHdnO3hmeAOSfdP7uvDbhwnio
	82vuq/zClNX32Vt0N9d6V57WMxW4CUMwGE9NmJl/5X64S3KstfLP7zeRgUvWX8SN22LPph
	ytSrqnfj/BgJfR+YkLxkEEWGbIf3Rik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677776; a=rsa-sha256;
	cv=none;
	b=tGqej5T1xR77qemLMUXVtrWxOmQVvZdD2sdJ1S8oYb8DIB4TmnN+9jrqxiKaCjmH+HfbE/
	dA1XN0LgeFZ0qkPbT1idCZGzJcp1VyFLzXXMT7O4xoYDriCFMzvEihajnb3/DOcVo+A3dg
	gFHrJmvnnocWSmcLPj44gbWwgBpQIGI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C7aaAQTg;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c8016d642b2so3639546a12.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677775; x=1779282575; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T0ssBedciqiVv0raptLCn49uzFGNVgYKzMgS4u/pGVs=;
        b=C7aaAQTg9wGlCHnSJ62XciEOxJoREtC4pmTRv/cV5s1+ZTd1bQ+IukgyCY2LqbXZEO
         c+SzGgLIg/XTLnkpOoVc9vMljCdULWzbwIjcerEDhSpZcZ79ZLzUGeS/m5IRHMzS5+jD
         FYew9HNuHzG34hDwkySEioT+DVtUm03jhnbm+BNyrzxpvMj1Uwi8ncJYHGtoXfVHnok4
         viCDl/CVcXkxuNUbKm7ZklDK2qnE5WDlbeBKr/2BzCoydlogldpqovXAY9+eQQ4z5Ikk
         lXwaIW/Myo6Cx4Wcn6lBtz/uieopnW4IZVDzWS2oEDgf8WC6JY45f9TlyuMQVEnxY2g+
         xKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677775; x=1779282575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T0ssBedciqiVv0raptLCn49uzFGNVgYKzMgS4u/pGVs=;
        b=GIzaQ++G2gPG5QdYBwos9eigQkMwR9vEQoeFrXisNNdBTB5yLyPewrxpE6b83Q3uap
         CN77vay/+uEL8m2lDGMJqZcohsSY4QjjG+w83JCpvzF8mUHeyoYUj6vIXjlV+8ZJdaKN
         hLXlJq+V8Cdt38z5iFfm4AgRokcS4RIwT9Zpwv8WHINNpNgmOMYnBHQ6Bs1bzXDVF/fv
         3gDNWz8dhJ4JWVuCGbmxOvaJhbF/llPuSJb/0rz6PkisNi0usM8lgMv3hUytByRMq1Hi
         5upKKDwkecNpfugSK0rGKFXoMLh+at0KJpDZcDWjyB16a1h1t2+Lj02CF7L1IiPOyB60
         MtqA==
X-Forwarded-Encrypted: i=1; AFNElJ8FMsXz83aQLKqNsBU2DzB/sxyBZqNcchHi73OsVwRvifgy8AT498CThJLow3b9EmJogHLUXkwfew==@kvack.org
X-Gm-Message-State: AOJu0YzYdWV3e9ym92zfWHF1UVDd86vs4U5zTi6CG3HJJl7HhWWft4vj
	EWm5eGEOu6Sg0LyIXEl6OC/wAtSLILkPitaNceBAh3FHUHiSag9QSrlfGvTD2wN5U5M=
X-Gm-Gg: Acq92OEhIXhrP6f+Ety6Zo1LCKv1mTbY/PttANFEq2F0y+FR1IAG+WGtCp884jcL1wW
	4CXG4KJwYjBoSnS8Thts/s+cWBNctC//NqOcewemAHlBIDve41oiYRVzM0w+DzgXgaMJWdwRL8e
	QjwNKy+g42pQlljdXJ/bv7oeAjErnZkgDVmPe5AF9T4k2E6Ixjcl5rViSiwBr33V/HxldKMJ4ZR
	QJUZ+jcVTWYmTcDgQvRIDquw6uFlJulrTlcnPbhb2oTjoUMcrl+kUTcOubk4LtaHmZIE5FGT5f3
	HKnA166p/bsSWVLRkpZO2r12fAJNt1nMQJXljwUh0ZU0xpHeLMr1RAy1EFVL/xVulvbDpVeD86S
	wz04jwkfhjybzDDr4YDSaeCeZ6orwIM4OTxzHfYEMBRg9pbz5ELWBobYpseFm3Fl1okWtygbWNB
	7pXyl9J3JiBvomt9rBrw+gnyuf9i+MmEoCPbuJ6hPH18MiSD3gWmkpdi1s3kU=
X-Received: by 2002:a17:903:320d:b0:2b2:5070:8b with SMTP id d9443c01a7336-2bd270fa021mr26473735ad.1.1778677774883;
        Wed, 13 May 2026 06:09:34 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:34 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 22/69] mm/sparse: Drop power-of-2 size requirement for struct mem_section
Date: Wed, 13 May 2026 21:04:50 +0800
Message-ID: <20260513130542.35604-23-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 934194000E
X-Rspam-User: 
X-Stat-Signature: hdk8wjzjznkcr6krumndtcthypwoaow5
X-HE-Tag: 1778677776-672758
X-HE-Meta: U2FsdGVkX18i4Zomp0mxRDLlyjUmyFpI0Ap9JK8Zr3hRJLjmm59YghrCsVtiYZ10Iox8tiOFE8Y4rpjx7xCAAQoNqUMXbZ4N4uSMjLrhnip6zIoUEa+12/eW0JuarrV9FAnvkTFHdV4oeuvz58hkK2DEKqTSi/Ly0kb9hDFiZhMVw11VQMJppWfHUcHTp3eWlKaOW9Bh8CcYrmcIkLWSJZSAZmWs6YFYm0Yu+KrC9Q4IPk05U9JYHvlhdyFkx7eoSo09Iv75pMoAPX/kYpE0l8gBzLGPIe30kIZUIw4XILzXsXdYDWdClrCMecO6Kcw4MAEfLt47h1BgNq/L8VzQ+LXUU7sspNAOOl+BBnUucHke9HBK8RkYdb2+gjf/QsishlH2L1r8+hue60URTNAUY7lTrCTNaXQ2ZgEULa7hwfx673gtw5DaJJc36gMqgD36L3+cJoW5ECJnpGywzenK1KksINhCZuiTMX9vPDmldxOPy/FsLTDEj5/SIUpiioWNipFigv02OjKKIvQUIODS2TdrN7lJJeQiI0/zqJDklPXLWa+MOjnMuy/rLG/2we1PFwdbm/24+18vJQbM8Z1lN01En9FHzGwyaMp2iVLbOLjm4WGxk4MBuIPwDohMceEqSz3xznLZx4hgxbFsAw1dZqmzo6giIjSBjP3gsR4fsWw/goMqsQXv1ZstJE9qHL9eNn9dtaEecbJlxMCheBEPS24kPlcO2tzPwSKgcuvSTau3NwWp9dyN59Ws3BwlqVPTDoWzRt4A6vyUGyljjDriRlb5ezHEDOTqZVKmQ6j1HqXyIB5gJ+WfoPAWO/YBhQi0iddwWiX/YlK/XE3cxuFffBUVIQpmvIw/mIU/3b6sMnt7AdI3khtp3uQWB4ufJXx04QZO6Ou+8GXqwpYKNhrPgAZZQVAZSL9zw+iyL5GE0Q5l3eokgTOuEZSCsiqE7ALwiaLYGoLCiaC/Albn4Ui
 QQ86AbjP
 r1cci4iXyCi5IPfDkhaOdksh9QHvf/5OUDNZbECCXel+s3G1oTHWy7qNc1ucR9NOlYgUeKuf+18ckVq93B7FUglxvFs18NBYUlctbfz7ZYX2uOmVzBHdgfPFEPT6Myf5Rtri/JwnbWp096FCINKGUT0hGATYRuGQs/kwXwjZnrpDbhGc2IzJ0jR2ZNGkKxWL3287LfXBgTYBoijPPkHjfzNeEmSUDQxEWL8tJg5HYuATxKBvcXJf+WcbiSh3VUBU9ZbBadPNued9dTWc7SvJXU/MGBRnMHkWO4HWzBuYIFA/Vd2AtFfiUffvcLirSjFF5H7Gr0amEu4SO1qecb5GboEOVkX8MW+dPPyFl0iP+jJSZDMhn837RRqbkPTpxCHjB6OTB+XbtOs6GHrTgyfEvjcj3GzBEjdz4Cit1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct mem_section is currently forced to a power-of-2 size so the
section-to-root lookup can use a mask instead of a modulo.

That requirement adds configuration-dependent padding, especially with
CONFIG_PAGE_EXTENSION, just to preserve the lookup scheme.

Drop the constraint and use a plain modulo for the lookup instead. The
divisor is constant, so the generated code remains cheap while avoiding
the extra padding. It also removes an unnecessary layout constraint
from the type.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h  | 8 +-------
 mm/sparse.c             | 2 --
 scripts/gdb/linux/mm.py | 6 ++----
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 40b1cea98b82..ae0271eaec05 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2027,12 +2027,7 @@ struct mem_section {
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
-	unsigned long pad;
 #endif
-	/*
-	 * WARNING: mem_section must be a power-of-2 in size for the
-	 * calculation and use of SECTION_ROOT_MASK to make sense.
-	 */
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
@@ -2043,7 +2038,6 @@ struct mem_section {
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
 #define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
-#define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 extern struct mem_section **mem_section;
@@ -2067,7 +2061,7 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
 	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	return &mem_section[root][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr % SECTIONS_PER_ROOT];
 }
 extern size_t mem_section_usage_size(void);
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 324213d8bdcb..9457a4d6a6fc 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -331,8 +331,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	/* see include/linux/mmzone.h 'struct mem_section' definition */
-	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
 	if (compound_info_has_mask()) {
diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index dffadccbb01d..da4e8e9655a6 100644
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


