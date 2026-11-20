Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2BF4606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=h8TiDe8J
Received: by kanga.kvack.org (Postfix)
	id BA1586B05C1; Fri, 20 Nov 2026 05:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B783F6B05C2; Fri, 20 Nov 2026 05:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8DAD6B05C3; Fri, 20 Nov 2026 05:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83F206B05C1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:10:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B33840E47
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:17 +0000 (UTC)
X-FDA: 85455077274.18.515EB5F
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id A7B7E100009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h8TiDe8J;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169415;
	b=EwkGsfoMTkgbGCerKdiZasNCVBtarU8o1qGKe3Hf6FIetiDhZai3uB7+qlfivF+5Bif2TZ
	N5N94bTA2QGCB54TDwZd5dclLmMhxxfOFG/j8vZbVD0ea4p3Zn24o9JoQuRChHNjl1jf7k
	3GqvoFHTj+GREia/THtaf/gqMbLeSXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqMj7FcIuyq0vRRF9cXEEeA76ZKra2Ioy2S+xhdtfRg=;
	b=lLf80sHwJn3iyPcwskCROCEBf95i8KdxVBEZkieYdHF9JByT/Rdh+miotuYXfJ9n8ZxSDv
	C3UcbTXkOe9tyI8e+RHau6qa19mJSAAqULMwvCEsseMvNDD22a33aYfs6P890i/zLiaXcA
	3fYIR1mAgCt6x6+iid4eO64wakvNBVA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h8TiDe8J;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso1676549a91.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169414; x=1795774214; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DqMj7FcIuyq0vRRF9cXEEeA76ZKra2Ioy2S+xhdtfRg=;
        b=h8TiDe8JzFHoEjrqULPYxoO45Le/7WQANd5ADSLY2OFjznqp2zOSfk65aV5qGckbdF
         F94gPOfxTch0KEs2a/n1TPpiufkOYMpm2zM1CBOLkZiwyAtB9QBv6XBj5xFZoJPyx+tB
         FZXQtmnKcxnC7x0YvcabdxU8Epy7pcjuwr+QI0eahD85uk+s3nthY6xCYrwgb1zvBSLq
         XVyiuEqs9VNXbaAzqdh3vjqc4qDDzcj5IAg/NX/pFAAc6VC0+1OdbMPNixcuvNpUdTgH
         V+mafvOvjdy6SzXn3s/u0Zmu8yx/ccV3pZzpXFHiBfjZb8YMDUcsMhd2mGBkaEtw1N3/
         HZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169414; x=1795774214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DqMj7FcIuyq0vRRF9cXEEeA76ZKra2Ioy2S+xhdtfRg=;
        b=c38+fxzCrAxiO5c1wbZhxnW8gdL8ya/0NILOaHDi5c+eg/gSUmixmke4iy0qxQGpjl
         WGhEp2r3hrPS7435OFMtolx/94YTAuEBlrxR1ch+iohj+A8hNmx3hUQnmyJCBpDbXNxu
         NV9s68ebvQQH+UxWn9oDAY6kQVkGtJr7RzQLkIBF7uWDV/CiYvJSRGuiMju5rGjB9tza
         fEbqkNyH25LDtdy+14YxkAxHwf6LWorQmwpD6TNz/hh/3EB/T8iVuqevEopWronmr4t+
         JUt/Y+HVL29XZglJjcIqVNycULXlfIikj3zjhopkGqZ+udEYfRZJd9dyKQKbwzJgMFdY
         R9Cw==
X-Forwarded-Encrypted: i=1; AL+hErE6Et0iMTsOLBT1zTsLuFR2sPWrRVV2naNxMQ3YWlOKuVfmNf5h3fheXDg7DCEYwZdCmd82rd8yNA==@kvack.org
X-Gm-Message-State: APuU4Z/GCKc7mTDdlC7sQkb5NMtM+YF6ViXaQN2js7VN+ZChJTmm12oc
	T454U04I1ubOVACo+ZdQfkoBnakhqZERdaQ8+JjTd3/yeZm5k0anhNn3+B/AnGakSUk=
X-Gm-Gg: AZFdTZdtn85zeUn/86tByHSvX4B4xrmBXGyaFFpblbc2WWDI24KZvsOWh9UNc1bIRr+
	Gn44KzvGOFbhNgd2QZOCWIfKiHLPgfhIRA1RmlD0EDM4x2STgru3/9zl2Klidiy2lLs9Qk08t1r
	lAFR/br4DUSSTeIDIuQtUzS1K9tGSwIg/jqSi6LlFX9cczMea4S9C1l5xxzLOuMOqH7oRWTKeN1
	mR9viKlmkHxCewVh40hEFcCa5Exai8S19KGD1WEdksr0RuPMN3hjPIcezLhs9XMkO1yUW9Ekf0q
	34fpddBUPfw1nw1ie0zYKwmwa4Rm/qxhJqx32pvScCdwjURDlorKz2bKBgDQZ/vbMQl8dmmdghp
	Js+rzV8kjw0w1aV0qr1j9fcJkqFOMjzOHhQuwNXnMYn1Empkx+hWl7bt//xB1LzAZDjrluDR6vo
	KRYSHQIxsVRq1Xd7Kq/rtlambNH5HLrBnLF/uQzuNWIugF5JHAg0g6A+PsJ/C/p7HTXtSKefEv0
	7SH4Ex0+qicgmGFWCzKXQgM1iFm7S3jZAc5rdm7mwEoPZWmbqUZd20Gnvz2XchoSHZuMFqAV+QC
	IwZTgz40VQDgoQVi7tePdI4pBB5o+p3Og/LcVIYWUj/qgf5ZbBv4s/AmY4NksxWoVEpyqg==
X-Received: by 2002:a17:90b:4b85:b0:3ac:b6eb:e0de with SMTP id 98e67ed59e1d1-3b41c7bc5d5mr1647918a91.4.1795169414343;
        Fri, 20 Nov 2026 02:10:14 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.10.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:10:13 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 08/11] mm/mm_init: make __init_single_page() static
Date: Fri, 20 Nov 2026 18:08:53 +0800
Message-ID: <20261120100856.16929-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A7B7E100009
X-Rspam-User:
X-Stat-Signature: rqok85y3pqi91qjse63iekkyaxawht8a
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795169415-726796
X-HE-Meta: U2FsdGVkX1+P2HMC7QPxgmTuJmh2HkHfSO/vEc45Ysmq6t4cLJ1mhG14oBl2/T71cJNBADaecSatwoxIXrEpQkyx7g4psthzKCT2iIEoO7VMj+LBSdWuuqPgZ2Auc+l9k5gLodYu9F6tbx/V47GIrkFd6boGNHYFYZPTtcqZ4xNTpCpj/XiE3m+1j+2B+mgQhn7Df1TViItzuxz5mwhgPz+YdxTfPOpr5JntuFpE4Dkh0fvAM1aArqDj1zSeUsWzcduqYwHBU+7odq4NVY2d0IpO852/zhO20JOiu0bBQznUY2Vylddp0EzbcmqiFe1Vs9UpoUR6eZeDfrogT/2+pospNh89AcxR0qDNerf1M9+ljZB9wZMKNyW6Hb9RnL3Vz51qQHXKf7/q4lYZ4aZSWK4YoaycZ6Dk0XiqefNmBfo4JcrpiZ8H7YLwgGb5GBhpElF+/u6odOIXhaFFSaYwSPaWSY/LwR81Sh3NSzsPaYtrjJiGRfQW4/ZUU7OGE5vRoO3lHGxkFJ86lKhCDGvPyx8R29D5XiKuuA9fGb9X0f8z3OzBy7CeeKfgBVbl6e5oRhToa2AY6ynUt3MVa24japKNXuep+dh0HcpQ+uIagMmZcJ2lCpFP/b5ZIQ35dkdueMyVRSvDUc58B+LIq1q46/RWhPU5pNe4mijAE6NCV9G9QTCf7wr1kDYq7KEDor+rd8PPJ74tRuDNL4ZJfdSsN/XzLKuADZDKtGwdZlesshJsOTZV80tZlQ5RgpgR+cwDXTu+sreKXat9OQxob3YiPN/LOa5vTHGRx7yfZkKsIB5VPmdsCGzW6QtrEDipR56aF/1yKoMCpe6+e+vsBkxtm2onkiCZfIIzr3Rlam9GrN+eteyVwoMQYrePMMowBJs1AzaR8gN2QXn7tqohkeVO2Js+bZBsfwr9xZXdyrh6GiEk8ey0TYcI7QUZvD36WirwqBpVOVdf0K7NWLt/niy
 Og0Hu9Yn
 w1ejxqiY7UK6MntKSsRpDPxBmmFyhF2J2RxclwK7NotompvbEkkDQCpZe0VdJMKYJzaGYTMed0Umo/heCk3gMmZTs1H5QFompo+mx00njL4tu2CqTGgOqkL3hGEx3AeZ/AJVGHhHTfOc9tW+03r7jbPMLj3pDpaobI+enqYFpgvP5yWFuoCRfJTlZjpNV7SBWXoq0LrReM+gvzsGOSCkitRyiKC5C20q4PjWDudLV5ydb9/gDlI10bd90Zk/TjtbJMfeojHz2q4e9iSqNKMGbkfTqsHP5wdwxDJILOhAImPx2sMleAMe9wAANkIyIxFTQoH5VfjYIxKAMk3q+a8oOtGQ6JgTK5u68X9bUYzmkX5xRPr48MJE/BQl1OGmvvNtGDDhNFbuFFR1Hsx27IlIgAFwn/O8Snd5+BqrPVs6oyQduj2UPOipXABn+BPrehoHIslY9+2/jxAbGtOaF0I9dZoopzfFn3jOpF0Xm3EzWMNIPLli5twdF9s1glbEkBnRXK7UBDrVOiUocoDM/WjjqFgy8FFDkOzfZsOOqLe0gObPzu0ZirV2IRHA8//2piCDbaysjE5SCZgP96OE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__init_single_page() is only used within mm/mm_init.c, so make it
static.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 2 +-
 mm/mm_init.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 8bf350d5a695..a427477483d0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -617,7 +617,7 @@ void memmap_init_page(struct page *page, enum zone_type zone, int nid)
 #endif
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
+static __meminit void __init_single_page(struct page *page, unsigned long pfn,
 		unsigned long zone, int nid)
 {
 	memmap_init_page(page, zone, nid);
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 1e6d2f78afdd..c03413a090eb 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -110,8 +110,6 @@ bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
 void memmap_init_page(struct page *page, enum zone_type zone, int nid);
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid);
 void __meminit memmap_init_compound_page(struct page *head, unsigned long pfn,
 		const struct zone *zone, unsigned int order);
 
-- 
2.54.0


