Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B95F7CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC466B00F4; Wed, 13 May 2026 09:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284866B00F5; Wed, 13 May 2026 09:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199816B00F6; Wed, 13 May 2026 09:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 063A56B00F4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA163C0123
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:07 +0000 (UTC)
X-FDA: 84762457374.02.53DED23
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 982604000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pr9TZ7fp;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmMHI/Oobz3lupMdXI7U03Ar3ucRA9ahppmUoHlMfZ0=;
	b=whS3gCdzvgXD+5yqcb2y6cLOIGgcAr4ubZRuvbRrEodrYAiyg05yLVjJNcH2RWN3sGI8yf
	B6yss75/JQs9DZVFZ7BqcbLP5cC5mW4Yj0NU2DYVicb7jf7BezEyWfE9RrgqIw3iB1ZLRn
	theIO5Eb3XScQmF+2G88IsZbV80xC6s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pr9TZ7fp;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678465; a=rsa-sha256;
	cv=none;
	b=U9zSl1vG84p2kHzRIqz/Qet5C/HFYKp6DDGzWE6NXGT9USeB5NO0zXoLhlzDv3SUgQDZ/8
	Nw6rAyLz94m/u2bCYasy9tcuDmbZPuI1Oezep4baLv0XuV7B2EgJY99IWIX8OBu63r3vns
	FtVqjcCz3RhJYOhvaBIcfB0ROOwnmws=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-362e50b4641so4196222a91.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678464; x=1779283264; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmMHI/Oobz3lupMdXI7U03Ar3ucRA9ahppmUoHlMfZ0=;
        b=Pr9TZ7fpf6AmLZwjbkSzOefVE3W+hmfgD+ZoRkeexzzUUB7AKsgeqdJmQ0NjCFbWix
         l7a+iqJEqhZJiF8V+rFsl87KpHkAOmmcqsH8VwDxklZvy7tk3OiJ4qyl6CJy9wMMPJyy
         PFcdjNAdfXRU06JqcftF6TIkuvG1ZcbW99LmwF2cErhu5V+R2y+vTwkcFjkUAZDOJWtk
         wwvykA6gvT0bCftcflQJocdSW0T+Lk1v0clrjZ6dilRvip/JxEonq6wVzgsOeJB9OdYA
         vVuRnZqelQApqbwCgxEin1GC1qf6M0pol0O85n6NQQJqpQ0p+wdwaaUIV07ixzPRdiWh
         eHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678464; x=1779283264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kmMHI/Oobz3lupMdXI7U03Ar3ucRA9ahppmUoHlMfZ0=;
        b=cmPVc9A+qsxIpBB2Sgdg+CEzY5Uxk4vhiLIQy+CUXpMVn94CEZ0yjCGW6WO0abvq+2
         MZSeNW5lOVBp2jKGYJbJd3VVuxRwIxD6EaCxns7NEvf3K1uaPHQ9B73cHOGAmGKu7WsT
         LTGnP8jhq/2Bps+RHsxjnGr7XMQW881C6WdfupUF5ksGbW4HdWYlyQd3U3SNlv8zpc/g
         DsEmrcQyLi/x4i+rbEOOd+toUewgfQW59yAe8OhKR4UdamPiarYEmenii5QYtQ7UFf4c
         d6Y4stbMPcy9m19EQz37/240IpWOD2e5OVao3go+FkJi8a5UmiqEdBImhL2fF5alTrpb
         I3VQ==
X-Forwarded-Encrypted: i=1; AFNElJ88HO4885WLrk1XE0uMTIenucfBf4bnN8Yg/W37FccTv+3jGy+pG9Lr+WDCVkA8tHnIfcMhXWBbXg==@kvack.org
X-Gm-Message-State: AOJu0Yx7fQJfFuiVeOvhH9j1buJ8d2cWqbXiju6kx76zKkRUXjCUU0Gr
	IMX3GvWlGetQ5e/Rz8kxKEj0Ae2qFO7XE68v18dmIbDQnekpD3M5w8xMPQEh/UulUVM=
X-Gm-Gg: Acq92OFeBq9s/mC2eiXI/wrxS9O2CH/5Zt4QbEZckn0mc8sWowZO0JQcbMMR1G1jTEJ
	VUcK3pitXv2Y3IiPXERMRCwc9al0KEcFt81tAR9oxafMdhbVP9A0XXxqkAa8eaBoZPs6tOtbKRB
	J7ueGNDjCtD+3ihudmtwei902jnEiBwMvo6jq8l1H1J5Vyh4GUeuLoOypWNOpXn54Izs9CvBV3V
	VcF4AiojpTSwxY4ycxVH/+K2azKQ1+wtl/vWuvp2ANsvasrF5v38wiW4owMVHwNAklTalkx1nMM
	uWTWTV5I9zWIFFmzyVO6GYP+v3ZlBCKUhSf7QhB529jps5HPJWzbzHMURgoQ+AYqOnKTJ7W2BAF
	Mk0zcVOZg+J/NQKNIf6JrDPk/ClkKpkkgZAw7iWBHAkqlR/hgkaiR/DplLz/XM553k/Gp7JyIyz
	rtayWzYt4rhWWlx59eVBdfYR2Vn2scGnZthZd5Cj5HcFiX8QoT3nEcLj9j2W4B
X-Received: by 2002:a17:90b:51ca:b0:366:3df3:fe45 with SMTP id 98e67ed59e1d1-368f3e43e84mr3548880a91.19.1778678463950;
        Wed, 13 May 2026 06:21:03 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.20.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:21:03 -0700 (PDT)
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
Subject: [PATCH v2 48/69] mm/sparse-vmemmap: Inline vmemmap_populate_address() into its caller
Date: Wed, 13 May 2026 21:20:13 +0800
Message-ID: <20260513132044.41690-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 982604000F
X-Rspam-User: 
X-Stat-Signature: 8rnydp9f84k3rak81i749mugi5wf9i5k
X-HE-Tag: 1778678465-55984
X-HE-Meta: U2FsdGVkX19oOLrnCusbvTolMDG5mFp4lIqiDLJaZrXZt2jdPLuJcSVbKssWVyA8oQ8urgKzItRb6H+BnIr1OydtCQ/HtwHFWRXYezHifa4CEe16UfvfLuS31AczT5d14dPCEfiXeb112TcNiv0Sl/x1KMCu0EUFRUx5iwPSYd7o9EaCD6cYg413p45bpJ85KsOCl2/KhhMPBPB6uF67fSTjavRiQjRXrcehdtjuFztimh/Q6HeDESk2+Wp2lRxoJZJeNlIypml1sA+ivLyOqzr9bVbcVIJHfsZ1YwSGceTbtVZZh7OSj8P6iAO2Zi71NP8jd0AUTrpdSz8uDMabT55gLTPqICliLZphY8xeju27uBWMzsz5qz62oxFO6erXYsIhF5sLkde0lKCDSh7raV23GFvewcRXv6M2+BnjOE+HUX82dwWSoEc9I8JrjDn3ompK5rKYU14ZtNObruIo6CvmRdELDs0d96Da2aKolMBuvJHvjqotPBAAMXFjKOWETYlgPMxs6T/MEJzmfvXaiGWSa3M5Qc19CB761giI8NhmGMAbu3jJyx8VDMvYsbPra/hyTL7EY8KqcH/Pa4aSRcHXunjCshe3CpTYmCENG7XgFTGZw7Sv0DZnuXZ4uvTBAmwPPg2/Nw2fRR8VpZlN0Xhz7o5NX62qsd4ibV9XyjKPHCdKgryw4V2NJc2IWU08rev8B9Iscjoy4DceJlbpYOULmcF7fEDlumDO24nUSaGskEoFmYNmlmkrb2juAl0kChsOquoyLO08ica9SyjQ4j/TmQ+XRgpnzdYa93Vbrki+MkMLxlum60byQfw3obMT59sMLV4poEaAzyInab1IsnlmQLnk9C6zjOAbRk1wvciAjaPOsJyrxHlcv9fB22SUvNdvCofu09bP9Ecy+kjww81XAaEunV7352oAUoohqMUbzkJNzUYACBdT8TrCEoBMY5TPHAp2WIHGjSQCllW
 +dDdUfrj
 2HXxLXHVWt/uToTNA1gYUjsYFncgSIFOJ+4diyySJ5ZiN0EqoaAGcw5jcLKS5hGTE/Au3bEQ1+/c69hCB5J8CZ/wVr8mfhOuQ1AoiD+vXAwga5LBqDv466v6U0F4RjRyU9f2gVRssv27Rp01wRsNvXARcR1uFn9c0Fs+sSWC3nuqU4TNFOxBto1003emAC2ykq3UCy9hc0qDRBHZMyjqd6IrG9iskW1vuC8HO6HkT5Z+MFchQwGnirn2fi9m/WQpxu8SZ1RWIZOxDlMAmfZoe2TW8YcKLhrOtgaTrG6/yi39kKxMJ00ZbTzCcdGNnajNinRk/j3iLvti5y6KXy5psAEGzsY8opyT9GaCDoaHz/FYpaGg4LV1k/vsrMMt38uZhkl7+jKyRKVAHD/ZFuU3Hb63xWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_populate_address() no longer has any callers that need the
returned PTE.  Its only remaining user just checks whether the call
succeeded.

Inline it back into vmemmap_populate_basepages() and return -ENOMEM
directly on failure.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 46 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 9811c92ad258..5d5cd5f73365 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -234,8 +234,8 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-						  struct vmem_altmap *altmap)
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -243,32 +243,24 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd_t *pmd;
 	pte_t *pte;
 
-	pgd = vmemmap_pgd_populate(addr, node);
-	if (!pgd)
-		return NULL;
-	p4d = vmemmap_p4d_populate(pgd, addr, node);
-	if (!p4d)
-		return NULL;
-	pud = vmemmap_pud_populate(p4d, addr, node);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_populate(pud, addr, node);
-	if (!pmd)
-		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
-	if (!pte)
-		return NULL;
-	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-	return pte;
-}
-
-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
-{
-	for (; start < end; start += PAGE_SIZE)
-		if (!vmemmap_populate_address(start, node, altmap))
+	for (; start < end; start += PAGE_SIZE) {
+		pgd = vmemmap_pgd_populate(start, node);
+		if (!pgd)
+			return -ENOMEM;
+		p4d = vmemmap_p4d_populate(pgd, start, node);
+		if (!p4d)
 			return -ENOMEM;
+		pud = vmemmap_pud_populate(p4d, start, node);
+		if (!pud)
+			return -ENOMEM;
+		pmd = vmemmap_pmd_populate(pud, start, node);
+		if (!pmd)
+			return -ENOMEM;
+		pte = vmemmap_pte_populate(pmd, start, node, altmap);
+		if (!pte)
+			return -ENOMEM;
+		vmemmap_verify(pte, node, start, start + PAGE_SIZE);
+	}
 
 	return 0;
 }
-- 
2.54.0


