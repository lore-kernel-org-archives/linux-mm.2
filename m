Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA183606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=kFpW3UO8
Received: by kanga.kvack.org (Postfix)
	id 94B136B0AEE; Fri, 23 Oct 2026 02:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9221A6B0AF0; Fri, 23 Oct 2026 02:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838346B0AF1; Fri, 23 Oct 2026 02:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51AEF6B0AEE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:34:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8504A018E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:34:48 +0000 (UTC)
X-FDA: 85352927856.13.9A5E72D
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 768041C0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:34:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kFpW3UO8;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rturI3iC2rqsVMr8++V5T0eWydBVkbRvFCJtmlAqnJE=;
	b=JC8frJbO22pIwoaoLKH3ov6j+1BCXVU1wG8r7UYAnV+QEvTkhljz2q0WZvPRk+ytnxkxYY
	aANE1X8af6AOnoDSoYtVuQqjYjFldPlA5wkwD7GMxVZH3odceJj06ZoVd7k5uDIFyXlQz/
	+GLkIW6IXVzgLbhn3OAYH3oaqiyJAUY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737287;
	b=eIQFa6CewHOzweTvVgsX2l+Q2Q40V7cB/nUzDtI1xTOYO4vqUZbJ8WFg4UJdJFrFkyRyP0
	dGfj6fBasNEP+AIty6GqebfeORu7Jmdq8XHOg5zwuYf3UcW0rbMkjgHfTVkHhKAU5Dvepe
	ZnpszWwQplz4uwCOY4sbl0b0b9bvJd8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kFpW3UO8;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc7d154ec4fso229510a12.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792737284; x=1793342084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rturI3iC2rqsVMr8++V5T0eWydBVkbRvFCJtmlAqnJE=;
        b=kFpW3UO8NDYd6F9Lxz/HmPPYbL2dHgdXWxWt5E+GTyPWq/GxT8Ql7/ctWNYzu+TDCj
         AoHMtaFM7JjcKyysipBgzF315LFBVHup6svkn4CEV2aKqVQ/C0teyTwsXry5a/Vb1vg2
         9+84JG/rc90/gsv5dRXnInZz51o/O2QN1vDXlYKRDG87GVfLxmI8KlP9JLQGxXI+Iykb
         cjp5V742+sOEDHcwZv5OrCbMqH+2ee+lbLiITT+XWcqKIGjCCFuDDKw18FymMqdNX/bX
         mf/mke+jQUC9WgMeX2E3vXx7D/Z2ajKHCF5051fczJw1DdIsOB4KQYdw6whX7gm2k+fe
         Ewxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792737284; x=1793342084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rturI3iC2rqsVMr8++V5T0eWydBVkbRvFCJtmlAqnJE=;
        b=1eyvP/6VIWq8dHQm0izovLzuAlgW5CT4o5xiMx0xdRS3jk508Nv3gca2CTGpXtljEl
         vQfl7z38PX1jOMNBt7W3la8TnelFxJgbYUJUwgfBj+dPspyeVURnFPAvQKBYoP5kHO2u
         1rEscTpgVD2C45fCVu+Pz/Qow6TygJ/Rtqpr5MU7vAPeD+zrFDdZ78IG5nmSC6/1+IHj
         eWT2uNuxDi6GTzdv6UVF8l88H7QbIUcQaSuoEp6ykdxyXKEKA8dnxI5tk8exkDlmsD7w
         oLlXXrzoRUcqFInNzgvs0+dYDgnYyEWNhs25nFQP4QphIm5hna8DunlQYBv9JN1pYLe2
         u/pg==
X-Forwarded-Encrypted: i=1; AKwUvBxCKjdoqTnLKguzeRWkNagFocwpon3m0lsxYhOrEzNgAqEQXblg74PXeYoOVgiY68m4COUbxFfnXw==@kvack.org
X-Gm-Message-State: AFq9FYIxYrJh7zXAcw4KyylLF9tUARpytoRSlOBydV5TzGX9Xro06lRQ
	jA+bEQrlpQlPaPrZXIMzuF8KDN1o7k370noIkTNJI7v7rImP/SFSt7XQY/1QR/JV0XU=
X-Gm-Gg: AYBFou1isy3WOZyr3QdKEZGX5ybXD62J8U05IMj2VVwB98SZXJaNGv7pOSJjPbHU7nb
	fWjMZm4JIJvL9684UrI+xikxdCpPEMyEBLDs8y69WfGxbTDVee0hc45Tjfty86Qrg+bKCH/udv6
	nl+BDpyl5k35H63Xz+0OAWy4M77PbHxlIZkK4DQ21p5l4eCobQo0K+DXEcv57Kf8wnOdDLG6JeX
	Jx2aiT2+rqyDjJO6/mwuKkhT0Hu9HBcolPHAdeL9PT1uoubZSkFyWjvTXIdEqwlsJlEsgQk85Hu
	dpINOcsHiQmIW+us7fNF23u6oc2VXwonZFg85lk4LnZW33U3lp/I4+wGWRZG3BM7Lf8vSbuGDxF
	I/5pDMc3qFVa7g8oJNHNjpxzg5Zp++NgDR/MMWtRTedHh+Wm7xa1BxIUWxstollZJZPAxPXuSX/
	kbvZQTQq5t/GUNZdU8YAAVL27L+RP5USnKRZIHpRre9Sncu5GgkJ2KdZwX/Ov0b5CdSHoe1aqWP
	9AnaHKzwdhy1N/BqmiCHSLX2ijrSMz8VJ0m6RSOQiUUdZp2RJbAH2NbaMlT/sxr9oCean4RcRNT
	6w==
X-Received: by 2002:a17:90a:f945:b0:3ab:4f1:4f76 with SMTP id 98e67ed59e1d1-3adce7dd585mr1009938a91.24.1792737283991;
        Thu, 22 Oct 2026 23:34:43 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3add246f308sm575202a91.0.2026.10.22.23.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:34:43 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 1/4] mm: fix missing page-table destructor in pagetable_free()
Date: Fri, 23 Oct 2026 14:34:25 +0800
Message-ID: <20261023063428.3658761-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261023063428.3658761-1-songmuchun@bytedance.com>
References: <20261023063428.3658761-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 768041C0003
X-Stat-Signature: 6u43nuq5s3utjmhj6d3au7aanfuqtzye
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792737285-10479
X-HE-Meta: U2FsdGVkX18zoCe1aj2kDjt5yfw+dsVufyrSB1fru5Bxr9VHOYNSd7gCH61di590CojnP8A0x9d6SJo0SzRINxnAFJPGPYD6UcZzOu55vMFvnK6PSA5jOYQQEoZa56oUDd4qIpXTGeUett9rqsFg8DZ0jwkr+UEFvJVx7wIUZ4A84tC9cojqMwIBGKpwKOTvCLXEWPclLVRQTkF51EnRs21Fc2+TqlzTLKMnndbg0Z2EDRtgs9gWaoa7R06FVsQYvZqKpf29W3V7OSEf3JdNSAoeviyGCTC5gXWXcv9I5MWB6zNhcidqmjjHcYmmdCU2MbvAznZ1pzsxT1o3N6juv2Mrx0s0WoFZN/zVVBVs2pohLUIZk98AH0pjgXUXJmY1Y4sa/XEzwQb+Fo4td/x+Ky+CCKFR2jGSzPM2m4qORl92pvKOg/e0Gip7D5+7YigOl0FDWNTldlz25q0l3eYjjCkIDYeX1sCQ3jIFoIhuIaejyhX4q1MHx/HNXmuWLbi0kMYGD+iDK+T2yChBnxDh5ghn3zDLeYSpiYDCGX5L/+rp0wbDJHlR5tpZ8B5kNLHfFB4pkVxKXmR4r8dYtGdmLR5SaOvycdkHlO6MCd4a4CKjuOUtiTv0hBj+NgL3bCEe5CfoUH3Z7Dg5DaixBfdFGeCXMJWFrvRA6JLltTZIMHhtKlMyQ0+mzbqJqFTR/IPzJiba5Yq5gpIO2eqkvB4mECrNPZXeWuW5n1yDIM28K/kE/1H5KVFWoYt7sG++9E3BiHdt1W29RKfDr+KKDzgS1lStCuwMDt0yMiB0nHJ1ruYj3AX7zQWyIxnyVV9gzsiAjKUJ7Lc8ci6/bB8wWYNx+GzU8gyKRziXFRw2IZ6LfaQva9cK48LalOEOUL1mvh60Fn9sFHIQds/lRe/6oAnb2FtGXG/BRMsN/UBUDR1ItQE+d0XaQXZcWKTN56cQ4Ddz/x8zS2LjYHq3F+WHDd6
 4i9eeG6n
 OOklZllu5byjkRzb3J9OsA6oatj+0pLQtFk66+p9oGW+zzXOEFMD4ZDpSOFalTsLU66jodbsCTzSObQrycCqFID0TQkR9k9PxBl5IEJX4FCIORGKR2CCp+CXbWRrReqrTY+XX+XYjDIZhen2FBUW6xW3iNBTWb8U4uEmtKfDy7/7Ac82IykOeyswujv/3N2zE+40ZbtxpcOg90CONkPB188LQCbq7sbNd0WJ2BzEY4p0tAL9J0sR4Euv52LWEjsRRGzqGjt5TL+Si0w24zb8CM15JZHksSmYuOoCa+oozWggJjaiHkJ4QLZkwV0ie7aIUfRJWWTC8tn4wZOjtTCIthW1fGhBsQrkJfnb8sgSciLWZ/6bx82/E8b7P+E87sCKIyVmNCWuE2eaIrtJ7SBDQCrV8N4oc0aMelhRpHS7pWwYwYdD3tLPbUHh+/E6nlITV8Nz+JthpZQjpdi4yiR+Z4qiwPOjjj51B3sdE1qyBKtCVv+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
tables.

HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
splitting a PMD. Restoring the vmemmap backing pages does not collapse
the PTE table, so a later memory hot-remove eventually frees it through
pagetable_free() on x86-64. That releases the page without running the
matching destructor and leaves NR_PAGETABLE elevated.

Make pagetable_free() the common free-side primitive for page-table
pages. It checks PageTable() and runs the destructor only when the
constructor state is still present. Callers that explicitly ran
pagetable_dtor() have already cleared PageTable(), so they are not
destructed twice; pages that never ran a constructor are freed directly.

Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
Cc: stable@vger.kernel.org # bf9e4e30f353: x86/mm: use pagetable_free()
Cc: stable@vger.kernel.org # 39406c05f8f1: x86/mm: Fix freeing of PMD-sized vmemmap pages
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v3:
- Explain why pagetable_free() does not run the destructor twice
  (requested by Kevin Brodsky)
- Add x86 stable prerequisites (suggested by
  Jose A. Perez de Azpillaga)
- Collect Acked-by from Dave Hansen and David Hildenbrand
- Collect Reviewed-by from Jose A. Perez de Azpillaga and Kevin
  Brodsky

v2:
- Move destructor handling from x86 into pagetable_free() (suggested by
  David Hildenbrand)
- Trim and update the commit message (requested by Dave Hansen)
---
 include/linux/mm.h | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..466875c5908b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3812,23 +3812,6 @@ static inline void pagetable_free_kernel(struct ptdesc *pt)
 	__pagetable_free(pt);
 }
 #endif
-/**
- * pagetable_free - Free pagetables
- * @pt:	The page table descriptor
- *
- * pagetable_free frees the memory of all page tables described by a page
- * table descriptor and the memory for the descriptor itself.
- */
-static inline void pagetable_free(struct ptdesc *pt)
-{
-	if (ptdesc_test_kernel(pt)) {
-		ptdesc_clear_kernel(pt);
-		pagetable_free_kernel(pt);
-	} else {
-		__pagetable_free(pt);
-	}
-}
-
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
 #if ALLOC_SPLIT_PTLOCKS
 void __init ptlock_cache_init(void);
@@ -3921,6 +3904,26 @@ static inline void pagetable_dtor(struct ptdesc *ptdesc)
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+/**
+ * pagetable_free - Free pagetables
+ * @pt:	The page table descriptor
+ *
+ * pagetable_free frees the memory of all page tables described by a page
+ * table descriptor and the memory for the descriptor itself.
+ */
+static inline void pagetable_free(struct ptdesc *pt)
+{
+	if (PageTable(ptdesc_page(pt)))
+		pagetable_dtor(pt);
+
+	if (ptdesc_test_kernel(pt)) {
+		ptdesc_clear_kernel(pt);
+		pagetable_free_kernel(pt);
+	} else {
+		__pagetable_free(pt);
+	}
+}
+
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
 {
 	pagetable_dtor(ptdesc);
-- 
2.54.0


