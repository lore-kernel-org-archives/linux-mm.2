Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4884D767EE
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1446C6B008C; Fri, 19 Dec 2025 06:58:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2916B0092; Fri, 19 Dec 2025 06:58:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40A16B0093; Fri, 19 Dec 2025 06:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E48BD6B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:58:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF633C06F6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:58:38 +0000 (UTC)
X-FDA: 84236073516.09.6CCC602
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id DDE1B20010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:58:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RVcGVFBw;
	spf=pass (imf13.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766145516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKBIZ7X3YGqQjD1QrQoyKYVgf0OWXgKlCuUAkiD9UlQ=;
	b=FvMUmMhhlJm20ZI5CeSDLjo/VDsXLy14POwV7Nn1NWNpgYbCUFXcYfQEOzh3zN+V7EWihy
	ml/JwfnekCAuL9E/IKWep1Kf5Snf5zRv9axt6w0/39AXNoiFdw/0LAUsXlVEWpnOGQIOHQ
	b7YmjiM1M641kDVoMy3vn6Vy2LG/Dpw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RVcGVFBw;
	spf=pass (imf13.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766145516; a=rsa-sha256;
	cv=none;
	b=8qHwVx+IgcVe4CGhCijzrZqjCmcYacFeEO05A60kvl/y3fHa64k6oVf9+ts7nuUAq8A0k4
	A5iQ7sTcFz2Go1o0jwa2tZjR7NNAsk2U7v1g0lq4QXy/XiI5FIwd8yKTEHiwe9fryUyEN6
	Mt4ijkexe0ss5JvM9N4xe2aeZRLiCWA=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7e1651ae0d5so1336224b3a.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766145516; x=1766750316; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XKBIZ7X3YGqQjD1QrQoyKYVgf0OWXgKlCuUAkiD9UlQ=;
        b=RVcGVFBwLJy+CJEP7xGjTLIPwhC9mPc4zsM5b3fqq2NJkO1FTzkU5Au3AUJjx1x7Tr
         jtga1zqj9tHY0wlUcx4HeIZyY269ndLs54uGDW0o+NyeQkfq2RsQps4pJqUJmxJRjbIj
         Uq1aU6e8pE0M+gCKpHlXIRrKY8Vdonv2Axaw5Uf3/dKFyZ60RmBNlaVv9AMeaZc78yX5
         GujFEMOaQxDjdATSo3j1NKYdQArVPYuW313+6OUvRMMGMb9McLJ9dwdwvWJ8PPHI6eZZ
         HWS1GhBsML4PEwwaTc17N+BNG4NRneNhUJH5xOZzI2BNaTllsirxZiAXHrxABDEhOjDo
         P5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766145516; x=1766750316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XKBIZ7X3YGqQjD1QrQoyKYVgf0OWXgKlCuUAkiD9UlQ=;
        b=duX3QRtmCbUbd/lHt8qGqA8Qf4w4arT1MDSNnUNYM560/hP0z8vCvs8MJHh6lN3rCV
         fmd+39vHHe7JHFFFzUEvNFL3YfyGGfvksJghiNzoRASRs19a3XGF76LSnWWFwppK+I3h
         BWbtwiJNCFK8TuxI59pqKl0OAXItNnEmKtHZDG4s29X6HqpVFX4T91wT9mEggMrVrfYm
         KlB2uUSN2V2wwgvLZ2JzYjiFgeQpCbAcnazT+2jU1mYM4/Ws7ABBFcc8cSgq/5u58S78
         CmqTVYI80LGqkrVT5xZMOrrCbo/expNb/wZ/QFcALGix47httZpp92U49YIzfTu9ucH2
         MqPw==
X-Forwarded-Encrypted: i=1; AJvYcCVyOBp7ljjik1ILUurvM/yNvNmj15dbWc/yuF5I0ZO3eiBJSIPEK7uHXnCdyDiNCKoYy0Od5u/y7g==@kvack.org
X-Gm-Message-State: AOJu0YxhWA5JSNtWpHptQQ+gqQLLuJWUcsOWKwkPRr8AOIgfrbzV9vKk
	7K+pNWBaJ0Y/a6f20XaEb+Ancl39Esvw8IP6CA6PLz85XboIPSsRlXxv
X-Gm-Gg: AY/fxX4ox4qM2ZNZczRlFgLhC/jVXiHBMD1CEp4D4oSO8AXImxXWPZWtJKdXavtLTMK
	jWfy42jdDg0SpiGU/l9AmgOZdUshlXYkYqmoFUmL5czwYQXcmLgw4xvAd8hkm9PvyZAfgU0ydhc
	6duC92viOC1MAi5r+G47HzGuLW/8ZiTs6Dxmj9scwCUPKWXW87x6DXOC+7reC6Assu81BR64rEO
	PHIro+i1vbVcf5lqFkGMqqYEUrURNMBQzqdgUdA50TA0szS+BeABTO+3kADK6VzGLYgK9XIZUhy
	xaY80c26iV964s5Ry3qSMomVZKxqTDzuihbbnRRsZ3t27EDq/CfzZl58E52fR0/0PI/1Xw6m6TR
	1sEbI5gF/PKLUqKnrsn7XFYxTew5q2+MQpzzr7c8FELoIxQ9qcyzhyuDZsKiJwIlzc5i4eN56FS
	dmNlSZb2YJNQmnoDbjWiuSo9LmojwpC8snseflNgpbVhOcWcpy7nGw
X-Google-Smtp-Source: AGHT+IGo8qcsBU7nnRMisHe+3/ZdYryGUHrh6G2oCtGYAIPB39ve/9QZxztOzFs0p/0RxiDANxcA3Q==
X-Received: by 2002:a05:6a00:801b:b0:7e8:4587:e8cf with SMTP id d2e1a72fcca58-7ff66a6ea42mr2101088b3a.66.1766145515736;
        Fri, 19 Dec 2025 03:58:35 -0800 (PST)
Received: from localhost.localdomain ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b127b00sm2258560b3a.21.2025.12.19.03.58.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Dec 2025 03:58:35 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 1/3] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
Date: Fri, 19 Dec 2025 19:58:10 +0800
Message-ID: <20251219115812.65855-2-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251219115812.65855-1-pilgrimtao@gmail.com>
References: <20251219115812.65855-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DDE1B20010
X-Stat-Signature: shogcmb9aqrfarz74gyr4sytg6bnukeg
X-Rspam-User: 
X-HE-Tag: 1766145516-86357
X-HE-Meta: U2FsdGVkX195ZeTdQ4BnvYExA1SGNV5fFEf2Pyq2eFinYi5jHjWsvis7sCwrJ0+wWxyKb0tO2hCzWbnwl6baWNcMpweNltSaCrFdQL2XrwWTQuVfpD7wIprTDLYjfqiuDoamz35fKO9RZR/k8xR8MMnONy+tIMU78wSBrPiLJFnylXR3RfjWPm/ZN+8IuRqjfk+uDTMGhxbXtw15d55PzwZjsT2O6vlRaSfxbjurC7avwbF5ZuNCmeqntBRRlna/xLWFBOVZAdyTWhwGpydM4s5pkKPVrfv3WZWFxIfAchk+pX5np/k4EaIjxLM6rkmmE9lfTF4TPjyjz6iHiyEnQX8cI7jwntAYtl3Asc/cL3dxVpURqHfdqU2ymR6jWvOVxVsHI6nc2CocZfAU+Pvf1mVXkY5OsWTp425OoBJj7Y0bvYSkJ9SnCP/UwBGYLAzOCXYQ9dFEGR2BeWEyQGgD8kIJO+173CjZ7uzA0NKCliAdYG61FK8lLR7MVjg9/d/Nsi0ks+Xs5QMkxV0eRlElv95d2qz3B8PIVFDVP7SLPEIR3KHHJfFGJjXE6ThBs/A8WMFeHCxgvDlgRbNG3nGvegry5EdAWUzVnH50HKRnvvdYvQ/ime8ptZcH7wUvZi+b83bOrvXicagKh7DzDQ1W0mgfhiWRm9U/FpWYNH1Zz3AffGdjs/qGIiQyd50LynwIyZ+fbngHPYg+2EdAbg1bgqvqsrEeCjrtl+eZMKKzgJfAr9byk3sXRtubTF72SYR2JEjbZxeB2J4xwYZVm0BNt3wyL2mfaRYZN8P04BXSbhpna3JTEImg3p1TIG4CATqNBgQzIaVC1/sEvefy7jPxBi42UwfLmD5fSJvXtt4fAcwW2C6nxhTtPT1BbFyXhsk/HjfbZlmAijE8Vt5msjAdtfytErGrk35GFaEPR3D59ZtB92DAkJvapEqoibABV0KYb7FyhD4huEKe+OVolF7
 TA7s9Gmi
 Lhzg8Y/VoaZc2uBjY6LUHm+J0Mt5Vclobi18566BlhWlbz/xPjWCUeOgIxar2WxU0PIPYiLpgXLrSlvYD9ooTv9ugnBofRxZF2Rk1zd2JFzRBJHi44TkoaIQqcXEBvSgo3IouTPgScOsRc7G8W9Y5DCbuqDYtuRcBtGlI6j8Hcaf9jduCghEIOal17eDQvM4OX3OIGRfTSmLfXqJJwZD2yOK297ulf6ynEILRt9b5sXEibLMnXc+Bp3btlFVPpgXuz0dCUvLDnVVYw/upSpkYxIxe26a0sRVBgQ8mRB5L6U/yj4xrizos05g7jd3yvUwLGbGe3qikJGajrPAkQauWQmybokhhSuT2F/odKPPyey5pMl7/2rkkZpqjvEyfM79TZ36NR4UtDmjKaAJEO+R5Wd9mMCHXtgaopY9k1auTv1C/6bvQPqAgcYEaPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

1. In the SPARC architecture, reimplemented vmemmap_populate using
vmemmap_populate_hugepages.
2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
when vmemmap_alloc_block returns NULL.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
---
 arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index df9f7c444c39..858eaa6615ea 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap)
+void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+			       unsigned long addr, unsigned long next)
 {
 	unsigned long pte_base;
 
@@ -2595,39 +2595,24 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 
 	pte_base |= _PAGE_PMD_HUGE;
 
-	vstart = vstart & PMD_MASK;
-	vend = ALIGN(vend, PMD_SIZE);
-	for (; vstart < vend; vstart += PMD_SIZE) {
-		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
-		unsigned long pte;
-		p4d_t *p4d;
-		pud_t *pud;
-		pmd_t *pmd;
-
-		if (!pgd)
-			return -ENOMEM;
-
-		p4d = vmemmap_p4d_populate(pgd, vstart, node);
-		if (!p4d)
-			return -ENOMEM;
-
-		pud = vmemmap_pud_populate(p4d, vstart, node);
-		if (!pud)
-			return -ENOMEM;
+	pmd_val(*pmd) = pte_base | __pa(p);
+}
 
-		pmd = pmd_offset(pud, vstart);
-		pte = pmd_val(*pmd);
-		if (!(pte & _PAGE_VALID)) {
-			void *block = vmemmap_alloc_block(PMD_SIZE, node);
+int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
+				unsigned long addr, unsigned long next)
+{
+	int large = pmd_leaf(*pmdp);
 
-			if (!block)
-				return -ENOMEM;
+	if (large)
+		vmemmap_verify((pte_t *)pmdp, node, addr, next);
 
-			pmd_val(*pmd) = pte_base | __pa(block);
-		}
-	}
+	return large;
+}
 
-	return 0;
+int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
+			       int node, struct vmem_altmap *altmap)
+{
+	return vmemmap_populate_hugepages(vstart, vend, node, altmap);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
-- 
2.50.1 (Apple Git-155)


