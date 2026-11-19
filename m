Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8588606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=hHLUDObh
Received: by kanga.kvack.org (Postfix)
	id E5CDD6B05B8; Thu, 19 Nov 2026 02:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7626B05B9; Thu, 19 Nov 2026 02:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE8A6B05BA; Thu, 19 Nov 2026 02:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD3E6B05B8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:00:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2389412097B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:00:26 +0000 (UTC)
X-FDA: 85450970052.27.DF9F69F
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7BA0520003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:00:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hHLUDObh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPhQ9i3kP4x8JhqjD5K1C3dirUBtl6z9jPgg1a9BJHE=;
	b=4tXEtiTIPqxEEyIwKy7gSaSv1qw+u9BFByG0BWURKeuV6L9s2+wczoF60noJpGXwgIhsfK
	YEQmW1mkRsqoX7FFpuuPV2oHL3uu6hxIFwUzX8KqohvVuFS4Z5uxWBQj94WP4nB7cvtrWG
	7dlV8PQ/C5NfpWEMopv5S8JeZazocTQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hHLUDObh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071624;
	b=JfCWJlK6kQprxgMQ8AwJYJ+yDGx0mfmhMIHTQi7+FvFR3sDZVH+l9tKXmOYmaafqXYAllR
	PzYWlZ53kUO1nQrCt6OOudFzijvdj7/Uznw3tgeHWGFMR/2CRTkHfe6sRaz+cT1Mwo+Ifv
	DUWlQ9wyf2lcFhYfPdhN5zBB0Q7FuOg=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b094e649d3so1280775a91.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795071621; x=1795676421; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kPhQ9i3kP4x8JhqjD5K1C3dirUBtl6z9jPgg1a9BJHE=;
        b=hHLUDObhVKMOFeYhuO30WXnBzPHi6ltL9FmerTHJWzklTU4lPj8nexaK7DTPbq2Xm2
         jnmYU3NiZEM8FAM1sPFr2u+bjPTp/nxxVMsUMJ5fczrn40gowuBAozDuFN3TyOm87QlH
         dABgWFq+hVhktbfh8puW2zMBDvaOLJDJWH42CxjojZjVkbuHnaVW3apqn2/E/dSha7Nv
         AafbDt8kBj48YgWaMm/Dlm66bwr44hHF7JIcXek/w0QcE/mCsDXJVdorKTzjg7BuRDx9
         1O0hNjh1CX4Ypme/cXfrJMTuNQCJMwnYvs8hQRTp7uw6HBtdLfaUqxh8LQf1Ga9/wmem
         rGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071621; x=1795676421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kPhQ9i3kP4x8JhqjD5K1C3dirUBtl6z9jPgg1a9BJHE=;
        b=Rciv90tqB5ejvwRfrzqhDUGi49PAHRpDBBBjYQMhQTtqeAnkO+uQN5hxpNLmKmo1IG
         zuzauByJ+hefN+YP4lpJ/bqQqaynXVbY05wRJjmH8lb7gvxDk6eWCYbqzT1NPdsdZSvt
         9YFUJWs9aTkAwxob339AvHel9741kdJ4r/19cgtxUtKw4r3e1+YQyuoe6Ukg9jDV7KPx
         mByCNDdStYbNjcykLhOXWvZe3qKwJ0X+61rvkncQSrzzviOkfTtChC5dUOkLhdqBHNA2
         fX5gxFonmDWK8LGjXGcIwXRpCeorn1JqA0nH0E4jLaQXSddS4o4zCUGpBxvE6sa8E/GG
         ZmDA==
X-Forwarded-Encrypted: i=1; AL+hErEh17FnRGflHHlZha9Rbgw9HbWav5AU3QHpdC7tyPD1eRtiotXm0Ra6exJ/GeGcHWJY6Xg6BfY4Bw==@kvack.org
X-Gm-Message-State: APuU4Z9wBlzdzIDgSEYadSTGlc0wKL3rKzwN3PcVs4Esjm+el+MfnPqf
	tDUxKzBRENwaADNMBJmxRcgghAj3AeSgj9ACauhnAh0ktcIVP6xT2XMG9wQdGaDl7k4=
X-Gm-Gg: AZFdTZfnhrn4Kf+Kou8QLjhs3B63dquOh90wSXJh6FhTzd1W4GgUYJ8qXG0zaNFTMHN
	4MjMJLZtwerg7+4gBrYI7v7KT4UY92eHTFgiSTdtpNiSK0AkxtAJ74LHYG/qkICoVtRYSYLYtfF
	s5TGIBXDtwjvuG2cNA8oV4OaLMI8NJcK2z74odBMLZkwVPaqGn17X3Yy73j3XIOx1GvlCRgG/Pj
	6UsEs34wFVROW6boQU3OI2hB5seRCOaqBv8CG9l0bZ7qiFGEfSiLsk2Te+3pSTRBfdRbPnSDxyr
	k8r8ip12gqXMae/bqex4dTKC3KHCf1NbaQaoh0gSQQjdEvWQSjCmNu4UcrK36K+bKqdEKZSq+cn
	oLdWi0b4fIONiB4+SSD750VarNR0gi3RYp4PuMgTs5gBhOTkiW/tiPp8gtHBEU4O5QkUNEtz+qX
	0E613COTLxARMAKvsgRp/sVTBJZkfTPkBH7DRI5QJSIPZ4M/VeFE0NJT24HgWN3Gx5Oah3pBdGt
	bH4lm5kWkEbqCiv3B/PTzQ1j/RmOARKQeWoEtc//7kFZsKbeRoJHJYqqGWC02eIP8u6InUxDLcj
	Pul8S64/1vIywzPUY3kvTqtgLovJ9ZAhJg/rR0rG3rA37/j4i6q9gtDDIVc=
X-Received: by 2002:a17:90b:1802:b0:3b1:922a:7b22 with SMTP id 98e67ed59e1d1-3b3d07c66b8mr5528227a91.60.1795071620802;
        Wed, 18 Nov 2026 23:00:20 -0800 (PST)
Received: from G6L4RL2QG9 ([2408:8440:c38:5ca5:3175:932a:757b:716a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402e75223sm597488a91.4.2026.11.18.23.00.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 23:00:20 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>,
	kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 3/7] mm/page_ext: always use vmalloc for section page extensions
Date: Thu, 19 Nov 2026 14:58:08 +0800
Message-ID: <20261119065812.89959-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119065812.89959-1-songmuchun@bytedance.com>
References: <20261119065812.89959-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7BA0520003
X-Stat-Signature: n99ttjgxg1kpzcoxhrmraa9amdrujn8t
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795071622-131825
X-HE-Meta: U2FsdGVkX1/MusSmvaCbbZC24NSzknogZcbFQullN5yrYNg0/As9pTH7/Eoub3ZXjd1O3N08b+OTk+D40Lx+yoW5voBnoXUEqOniHuaByddhlqfxTQKW1APr9eeqcFzc2TmBPgm6gWMaFw+TcOUGDn4YnrMC4p50w96B74LVHfBsCFUR7WLwO9HlTRmNnDBueZkftS4B9gH8jehWGJ3NfutterbR6OWdxWjoRBU+DZdGVxpA778W+O/qnDMkejgAE3MVo2HYtvaWcGPA/7Ap0xiBpBjY4t92ddu2ESC5ay8KIKed984FD03i5Ff1CzqCDEfDJAQyRYJowqX/3KiKgKWTV9DPBMdJnd7jAEuzFPiqlsd6HNIczGCtPPXuOjakW3CBTBfvTCCVK1vXevbNID/r586yJAXglhSOU+XzNmHDEqiqvEDBNpf7akRqqj0FceSZyRNFoHVawLTH41JWAROASWWM6G7lirdo+2nKkPNGevUq2pZbvV7UU8gSpLmciNO3WiUBbmHptqgyK2y4DA/kSml8MJPUUu27T9idFI/egDLz6lS1RGuuEg0HAFD3MtIdrQsSv2gSqg1q+OjR8Z6kz4W3NTURqjJaIsw/4qR3bZbUkDc42xxLH3xpJTaDJnGrQQ1wbd1UmIq1baCoQ/M2POYdgry3A2kkKr/Bwpd5vyiWU+JJNwG3ssMksTbrPBN+XSxytGuxES5NjtX0czQZwMcHvNZscf1jNXFFwPyDgJ+XJkk3YfJpM5MR6GTMn3KWlBeXEmpYfreULQ8RX3/aSB9PVaGviVpujkGS1nl5KFA4CJT3tFkh7SOmLFB33m7m9SBEAu9JyfPzkYaDOoK7OIF9Ec/8A4uu8DtqpSyLZoFByoic3aRuTKAlFFTGZpLUU8o/f5U9ey/c8jy0yvRLMsUopgokN3Gzgs2kr1zrkCw4hTmJC9NOPMy0G4WwfPpuOiFAKnfA6BASXBA
 1BYNeezy
 giyPas8C5g+GEVLpJFYOmD0NPYYcZdefa5pJTQ+rqYEDHIW+t5PqM1fVYVU6YMJ9vu7lXNfd/8RKSKEam/sgRoJRWe1h0lfadarZDDMyqtV/vQ4OYJ0d1V9RwVrVQiGKGFayAIyWKx2phKUn1o7R+6XcbSZSVZ2npSN8skxBjpZVqjQ0VcyzIapnOdkwaVA0wcsCw/wNpSXVxcQKJlKedmNayCEbmNaTW6phRvmQNMgKbgWMKXvrjo+TfqSqPMm/8hQa6ssayTd007E3tvIUQ1b3GInMR4MYeSjNXa+VxkovTt25gwMPtiVBLg8/LEvkreLtgL22adduiT9R1hetPaRnd1KjooqOTJjkYVswE+biOPR+BgrAtDVtMrzTCE0k1b9weunFZhHkWvU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SPARSEMEM currently tries to allocate each section's page extensions
from the buddy allocator before falling back to vmalloc.  Boot-time
section allocation happens after vmalloc is available, and memory
hotplug allocations do not require physically contiguous backing.

Use vzalloc_node() directly and remove the buddy-specific allocation,
free, and kmemleak bookkeeping.  This leaves one runtime backing type
and lets a later change add memblock as the distinct boot-time path
to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
---
v3:
- Collect Reviewed-by from Mike Rapoport and Chris Down
- Collect Tested-by from Chris Down

v2:
- Add a preparatory cleanup that always uses vmalloc for SPARSEMEM
  section page extensions (suggested by Mike Rapoport)
---
 mm/page_ext.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/mm/page_ext.c b/mm/page_ext.c
index 39a4464fc979..6196bab6868c 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -290,15 +290,9 @@ static struct page_ext *lookup_page_ext(const struct page *page)
 
 static void *__meminit alloc_page_ext(size_t size, int nid)
 {
-	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
-	void *addr = NULL;
-
-	addr = alloc_pages_exact_nid(nid, size, flags);
-	if (addr)
-		kmemleak_alloc(addr, size, 1, flags);
-	else
-		addr = vzalloc_node(size, nid);
+	void *addr;
 
+	addr = vzalloc_node(size, nid);
 	if (addr)
 		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
 
@@ -344,19 +338,10 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
 static void free_page_ext(void *addr)
 {
 	size_t table_size;
-	struct page *page;
 
 	table_size = page_ext_size * PAGES_PER_SECTION;
 	memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
-
-	if (is_vmalloc_addr(addr)) {
-		vfree(addr);
-	} else {
-		page = virt_to_page(addr);
-		BUG_ON(PageReserved(page));
-		kmemleak_free(addr);
-		free_pages_exact(addr, table_size);
-	}
+	vfree(addr);
 }
 
 static void __free_page_ext(unsigned long pfn)
-- 
2.54.0


