Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F3CBC88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 08:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC816B009B; Sun, 13 Sep 2026 04:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C47E6B009D; Sun, 13 Sep 2026 04:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DC086B009E; Sun, 13 Sep 2026 04:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 252D96B009B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:41:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D159805F0
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:41:16 +0000 (UTC)
X-FDA: 85208094552.30.FBBA538
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 929B080003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:41:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YVbXd05u;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789288874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jabfOFZH7nclzlLV4JN+2R4So1RYw+NkC6onyGlhulM=;
	b=ZvkTraTRQtMziBeqFGrGZ+l0Si2/MT1ix5lLNnj76G+aN9FcCtfDH6WdM3QWEnJ9j9t0c7
	LNU1rNOPUYWuhVeRwTNzzrhGXG3uDyg9XC5L8jcB/XBX76X2G7t9uIWulBTV4W6VhCLhGe
	8QK+u6iWsHZVREJmsRlwDoZiVVd2mZc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789288874;
	b=be7YaAsjBOZn7Akyx+jM0QMS1yFVPY8cAu4rlTTTBl4lxfDUHLiA7AhxuCUFbsVwhIfXT/
	+B4LlQSaJqgv0rl+SG7DMWWxesJdkUpsCK6Wdhlr0A+tdKZZAby2k693vV68ejE60xYebR
	BJ3nJFBKJsiWc3SDSEDT0LFt1ivngEk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YVbXd05u;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-86b90133ae8so851496b3a.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789288873; x=1789893673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jabfOFZH7nclzlLV4JN+2R4So1RYw+NkC6onyGlhulM=;
        b=YVbXd05uP5Sbrrq1UqNfwfk9yIQsb+MyHXCYAkUbtM79rK7uYIbrz/wv7sl7p5w6dB
         tfoXtXgu1pOsFHjvdg6JrbvmfXvc0ZhSLNpsfyngNZNkdAaKLavu6V5s6rNMGP4oaUVC
         5aCpYy9qbbeU6QKgYaCZVW01WNdxo3C8kp7RLgChfhEVB/sXIi5y2wXs/boSTlHzAt2Z
         vCVE0/pc2PLV6yi+zvOtWb9HlDX8AacImDnZPqwI1zBHlSBNuywEtk2iyutiStGjsF1X
         +JOcb9PCtLA2753h900Rlbd3V+ZrQWfIYuoBFAu7Sk3UwVi3PWkXO6+C1cxI8+YWlpUC
         OwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789288873; x=1789893673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jabfOFZH7nclzlLV4JN+2R4So1RYw+NkC6onyGlhulM=;
        b=bbHxzQvPYTKPkOnQrS0hF16pPE2K4Sr8Dnmobm39JFQafp/H1U41rxhCzi2xnQ7KRW
         5B6rDyvx/6xDHg5arJGy6CaoTbyrTG8tmPPRLwxjQ7qxAtYQz4Ct03beN0z05DinZgxd
         M5FDu1wqOcpqavFAeNbCnuLFS1jP3l3iEuTK1mNSnpVyaSM3PbG5X77OZVfVcc0XF4zr
         qoB4cJPEUKkdwIuOXQ4W4PUY7xj246DKdGW92J1pNtaBo+vh0RfYSp5EQiSXSrzCqXVE
         gOq41qzlEeDeUAT6zqFgwykc4zWvm9y8o6kG3VdCKIQdHtP7KpUqlQf0xMpeqCTUpte9
         dx/g==
X-Forwarded-Encrypted: i=1; AKwUvByNrY//r5lJU82s+XAOzLM0Ik5N8lGyyeQ0Fz0eO0Au36HJ+8wmPYUrY7lJRdm0JAQqcjOWmYWISA==@kvack.org
X-Gm-Message-State: AFuF++kXtGnZMUcHpufoicM7l82MBAttZESj6B1J1dZ08L/c0voXRYze
	zFXEugIMYRVH18HJRO7xEp6GUrewrimK1NF6cfK+qWcVdh9VViFn6pxQm0kNOl9cPz4=
X-Gm-Gg: AYBFou0hjgPJrzJqN+E1MAj98Z28Ij1oyHEkpOOCRACKzwP0tByDd0Sy7fv3Ub++ohk
	IswpnwAUbUXqjSqavKYAyV+AIx5yKmzUmWUHYY8+d1locvdJo/BQNA3VZnp4aQGbFNJkvBA4LL/
	pjQW/6FTymcwl2Ggjh9eqSPJUnGROXcKskJ/THpMYYWe02gGFYrIfb8TMNYtKN8FwnTcanZ37WP
	z1NfdcrWqXCqwoLLhwQ19dOtECUL9Ljm4Q0hrU3e3n9QWi15yOTymzOsOZxND+dI90m9eDl5okk
	3FRPV5oQV0qG7pQ7ttJ9LAUxu3yMWVQKnd2+TAQ/pa0M0Q0gWZhbyBFhuhs/rZRPYORUrLGdbau
	tC1pGtYATxsK7wzCuSckLn/dVPvZfRzfHnfWQ55qjIUhG/M36v8sBgntyRDSBqLqQSR3PfNr4p4
	JGWoaBd6b/kQVFOLdT9CPxvnxfJOJrBLvOSn25mEAJRGwks5AfsYrHXNRD/ybNl4/Xgh6NQ//Gh
	IAHmJUQ77ropsG2pWwQf82eaSQ=
X-Received: by 2002:a05:6a00:c1c6:20b0:86c:52fd:fbdf with SMTP id d2e1a72fcca58-86c52fe0a64mr9440575b3a.20.1789288873401;
        Sun, 13 Sep 2026 01:41:13 -0700 (PDT)
Received: from G6L4RL2QG9 ([2409:8a00:1832:cf0:5137:990:100e:cc7e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29cbb0d3sm3070531b3a.42.2026.09.13.01.41.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 01:41:12 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 6/6] mm/sparse-vmemmap: open-code vmemmap_populate_address()
Date: Sun, 13 Sep 2026 16:37:34 +0800
Message-ID: <20260913083734.86802-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913083734.86802-1-songmuchun@bytedance.com>
References: <20260913083734.86802-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 929B080003
X-Stat-Signature: 88jgjdxd7erdmu7f34ysncfquex5xmjw
X-Rspam-User: 
X-HE-Tag: 1789288874-542749
X-HE-Meta: U2FsdGVkX18SWTZaRv8C3UZLcAG3ZMWhtYj5hBo77RJdz66zFI3Bn4K/b+qYUFO6H9f2JAucYcB8QNrZdMIL7lU9ZkIsEwfF4HiyEAZJiHUPFR60k88FLGNHmrNAdsp4SjDPp6jEzC8ebUn5STVBFKENRLknD/DV3Kp8hEs0VjyT9XINuyoSya3Z7A0XU1LQ5Diu7nBl7rJAdGB7V+H2JThGQzQylyUIc8RBZ4P8QaUKoehc8o7L3glwXspYaouNeodHr/Yf6sQ3MxDdwuw/3Hdm/QfIqqwlKzh8ubcmgKjWz3M5QL76cOQQPk0Dj3ffZWIUt0sDYsQ2p06rxhyyYL3YtrEea17EDM5flnMm7G+DjaiXw4GdbSZaxcLyY8cPUk91M6BjttPF3F0C1PM31V5lt9iXOikJSIcAEv2Wxd0+dO1Gi9WdNOWKP4aZxra6kd67Ou71KS/QGsO9Tq3unwoNaKhUTvb29GS6SJOeq1MvBB5x8HLrsL+JSi3OXZXaPWGdauoYC5cWq05WLXtnJLrBBK4WqIgqxkTd5fkNqpUAGDaF1gAlk+XDBnfWRZNvrJSde1nKBvMeCFbZGSWMrahMQ8xZptTPWVAauAQEg/AtJX/kQtKgmVcNtn5NbyR1Xk8RB44nPpI2zwYrVy6UULXMr8ywz0UoAVxvrtkbsOelGVZWcKOq90ah9w26Cp+jo6avPAQRvHfbpwZH64gx70AF1flISjUzSyry9hm1oCYfXcA3t1zqTcMlw28O0zwJ1R0C0s7cRxV3I5jspileyUXcuUgOmnr2y84McT5+oVCKF7UQJCqNgQK/DEc/UdoQW2He78LE/2lM5Ot8Afg85bAWkjhksKBpHGG029+kA34kfpJIYaTo0uTtkSEQhaZKJCIiyseqAcQ6E8c5In/N1HJoE0Q0NQ48N967dIhiBzBv7uElrZ38JCeXCON0x2RAgsxYUdv2P5rV9EJQe1P
 2/1ItRJh
 BCDqLNCsArRJx3GM9GQOfUO6O0F0t0wvRcFvcMJOISRmJqiLLT40+xyOJIu3BUFVSGHcNPE8QVcH1BSZAcNN0TkO/xJo5hHXtLLUAeu4AoyJRWVXeoEmdckCBhdfdLaecx2Dsf3uUpgi6nidMEznU5XSQjn7+OfqzYsTRWcrvjXgXmEGh8wduUE0KBHUSEk5G+i8UDtm0OhImKVRbYm+7sglmuQ36fSVFJ/4qZD62wQX0V048Ww3OZs2THmTo2SRjCuWm1peXdzktj6gN/005GRV8IJVO2AraTMmxSs5Yk10jM2rZdO3PHvLgm3NTQ7u4MZuZGNAtN8Sr7poLuOn4JPn9lGhIsq6hJlMzfNXsYstPx+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_populate_address() no longer has any callers that need the
returned PTE.  Its only remaining user, vmemmap_populate_range(), only
checks whether population succeeded.

Open-code vmemmap_populate_address() directly in
vmemmap_populate_basepages(), remove the now-redundant range helper,
and return -ENOMEM directly on failure.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 54 ++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 8b4904d9c65e..5e0e30c77431 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -303,8 +303,8 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-						  struct vmem_altmap *altmap)
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -312,48 +312,28 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
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
-static int __meminit vmemmap_populate_range(unsigned long start,
-					    unsigned long end, int node,
-					    struct vmem_altmap *altmap)
-{
-	unsigned long addr = start;
-	pte_t *pte;
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap);
+	for (unsigned long addr = start; addr < end; addr += PAGE_SIZE) {
+		pgd = vmemmap_pgd_populate(addr, node);
+		if (!pgd)
+			return -ENOMEM;
+		p4d = vmemmap_p4d_populate(pgd, addr, node);
+		if (!p4d)
+			return -ENOMEM;
+		pud = vmemmap_pud_populate(p4d, addr, node);
+		if (!pud)
+			return -ENOMEM;
+		pmd = vmemmap_pmd_populate(pud, addr, node);
+		if (!pmd)
+			return -ENOMEM;
+		pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
+		vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 	}
 
 	return 0;
 }
 
-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
-{
-	return vmemmap_populate_range(start, end, node, altmap);
-}
-
 /*
  * Write protect the mirrored tail page structs for HVO. This will be
  * called from the hugetlb code when gathering and initializing the
-- 
2.54.0


