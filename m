Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1E63C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07106B009E; Wed, 23 Sep 2026 02:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91136B009F; Wed, 23 Sep 2026 02:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58506B00A0; Wed, 23 Sep 2026 02:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6266B009E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1998D1406F0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:11 +0000 (UTC)
X-FDA: 85244049702.26.8A3470C
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 310F6160007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nmra0D3y;
	spf=pass (imf08.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRHIBzX1Ph+VWLlGic49OjVgc6epG84F5iB9tVuXpJQ=;
	b=o7+pm0ZE7Br26tNBi4crz20u1KoxdBoaLFQikcrIunsjW8GrIDrBtmFMCuhsNS8lbBFu3L
	vJxsVKKfPfRGOOrsBsfXflqd7oWtoSBFAOGeOlI//pVem3I2kGlVDWvLkI4e6lQuqFqbDq
	O8Wr3Uqr0sH9LGuYnQ9i7LivkQWTzz4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144949;
	b=phUaI4YXsHdkKW5wS5RlSHmZUpnmUbkZ8rmNNK8iiZQdc7P2iMJ/ah59XgEXEoh1R7FlaQ
	DixvlsIcEADHFFooXBHB7D3eueKyMoQjVIL5Qm3kLJS5mGKAkN29PVv0EOF/jm4wMEIfHp
	HHOpLsUrIMhYkCatnuqMuyOebMoldIs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nmra0D3y;
	spf=pass (imf08.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2ddaa08c890so2973105ad.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144948; x=1790749748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRHIBzX1Ph+VWLlGic49OjVgc6epG84F5iB9tVuXpJQ=;
        b=nmra0D3yQjqBH//YInIMLxMkU4ZtwQa31qdLvGcaJjg3D8i8+qLdarp5cJ4WjOSiNp
         BfasW9I6eNHd9GvRZH2mSD2OvCc9l4EfnWWXVXAdgkvnaHAiOCABFhJKMjQZO/VkVzh5
         GM+UXceMMRniYi4fP3LFFjn1YA99AtzWNW0xpDtTgkrhvTlBDNV2JiVYprvL2WUTlzEX
         y/8lzRGKq1aKyrSrtFOZWvoGIIYLvlPkLnDK8fEugJI5qUI7egMqQfVGAxlwAU6xsI0Y
         MuoJtofum+W5eSa/H09KXAahgxm5T8Z+HJ/Al8ugevCJVTi0XHS5VgnOuU3JNAG0OBgf
         CVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144948; x=1790749748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RRHIBzX1Ph+VWLlGic49OjVgc6epG84F5iB9tVuXpJQ=;
        b=hsuJuyHltiVVZVfo303SD3BPeuaFL7GGBDpv2ba0rYw9mejNyaCQ+nuvgUfVaqm2lk
         /6J6ktIeQjWqHIxT2sBaHHKArnZm+AihcCGfV6uxemGPKSUyGF4RwF3ceO2tMggGfiON
         JgvnA2BxdAwbx6M5a1I6joRMLQmD3XWcWm7B2tx8QLznuTTu19SftxGsm6yd/IaOBwa7
         ahC2mFkkt5BELiyJzeesmbtLTjtH7OUJq/4uGzRTqG3+1o5ixXkNhAFbuWCpWOHP39Qn
         vQw1ZaQDmDInXobinU7xTnAHpIMk9AzOuS37+wrQ9EGNjR7KNVP/o6lDs23shR+YSQti
         4Ebg==
X-Forwarded-Encrypted: i=1; AKwUvBwvWnvgpXjNbr0YPnmJt+dubtRFOFN2RV3wlrI195Gkp5193lXkLpLx9ud/jvOlhcbep7PDI3uRjQ==@kvack.org
X-Gm-Message-State: AFuF++lDTKgEngIvgxClgp7Xb2ZssSHfTiphWDNgChwJtj7/MUqv3FtD
	PP1lwbLBehtTaIjsLnB8JwG9QxZr2k9r+qvl363cdBwPJxuW2AbzXZe4
X-Gm-Gg: AYBFou0a3jJMLEc9UrlmUpoBO4WzhsFtFl/Tb8lHvOfKE8f8xOc82xH8p4NPRNDN1Kg
	1+pFwAWBWo8DxvfCxGccrvBQ1Miyi3AGb7gPRrj9JG54KmECZLnhhINNEB1tifzKJeJjeUc9Nkf
	auSCldPBYoZwZrIzalacYohn1ORFdNZyl3VCy2BA5WBFmMGTncnEf+LvCer20xngURlLpqP+F3V
	m3wb7JCWsC8TMcxEOftsC8Vl7ZyiTEbgY8iITsrWRZB1A7E7IkOFs1TWzVAHw13fKULlRTP716J
	uDkNKqd/9yQGekdk5p2RKVV7xAT788/RvkLKfXlpHRPeCjmKRlJ2zngRvtDdmeBnngzaw3xOfyV
	3dxTyK034Cgv5eWmt0nQpb4XVnp50CZmcn12eSxkEKagkMy/1x6f5s5ciXTxAImM0n5hs86itOm
	YFzG7Cc/zpRJqmT9ImzlQFyGx6/oAUfKSaEHJMQc2eyR+lefjl011QtwhMwD2EsnC6l5WkBB482
	6HrZwc3VGMnv7cAAXGmTg==
X-Received: by 2002:a17:902:ce0e:b0:2dd:ad73:5b6c with SMTP id d9443c01a7336-2df69d56537mr15363405ad.28.1790144948204;
        Tue, 22 Sep 2026 23:29:08 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:29:07 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v9 05/10] arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Date: Wed, 23 Sep 2026 14:28:27 +0800
Message-Id: <20260923062832.479455-6-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 310F6160007
X-Stat-Signature: dn6pzbzgnajcww71wamjxffdpaty3mr8
X-Rspam-User: 
X-HE-Tag: 1790144949-751788
X-HE-Meta: U2FsdGVkX1+Y0LE00GZUvVxVi1GLozNnrO0av8g5At8GtVZ/mAw0LFA/Ak8buAtqvQbel9yJK1cIAHJ2jTVNNQZNio5swnZ5XqNFNCgGbU2Fm6D7IcF+/OURnzJwaReEZo9MyBQBhrHwXmo7E1q0qqWumR4JPbT10OJdADi7ec00aDdiXGVnZQzDmWfTGjlMjvgU85PTkpVeVdjpWSsokWkdriRjV3A+nfNckwHsCOrsW8aA2IVSVdCIpT8oyd0TnJ59x6Nr2O5JsD+mCohirI+nJABf8FsACm3/bDbqeEeyBj8X6i8ibgfmQ7uANzfCnkIyBrkF/oCK4BLMHdwutg2lIpz35MXw48/EWdyWGwnsgih7xhD2oZwTqhYMap9oBu3uq07sXshSsWoN/zr+wN2ns8P3nbAN5qZmcn3Lc67kRQ+AiWc0t1VVy8wKy3QMoZVmgsDZOkkUt72NisQ4CDlARyvGdw3yeKktOvio9khoylofE8d/mAmt7g7YvKv1sHnOjW5QmL/qjRG0hu/oNODvphTvmj/wg8lsjjafg3S0mjcixHi1wvrKRJ3CqjYx6PwVwjdmjFpXWAftm55KFXQOZgovLJ+0Q5J0varUQydxjDbUL+T/QMbYHatDSmlLrDofvZAjvkMFYDR5IioSH2xh5Z9/2VN3GNgSq4nTICIkJtqWswdRX9/8RPIeZcnGrPxL4+ujrcnDJNShgQ9L9l858NT7jdBLL4vwVS72WN2dA2GjsRFqe9I1K/4kKp1MGnnxg4/4/7gj0K/9xrkrOURY7p9HqONlhBi2lhUeCAAN2SGVKxNdUfXufm2dCEArc8IqrIZi+sEfMv2yEWft6d+G1deDmtcnigNmyDkWUQNRCOCzDFJ6NDXwSmYGxL66XBViB9aqI8Pt90amz8+HTvaZ0Bi87/kbtHoFv2XyJmmTwXn2RjKc8UynUBCFvbEcD2ahL7s6rDpJ3Ki/DhG
 RSjmx9VG
 pHIFiQpk50+7cN6ICbTdXrnVDKlA9N/WbQL05Jn8nF1+7DDi+VO6nPnl52eG6HSwt5EjVy63NxjnWyoslcny8CzPyUrp93S4DI0cxCrrQLtXe71IEiYNNfTXEY9Xd/Mzs4vNsW9cuHAUCE2e4xXEG86dtGa6xdmiDaK5dPZeCedkXmnxCV8Ow2R7wZC/hcCJxmj/pGl2TOmirlJMMbQYvSljOkxcqb3FkTK/wnmwMLh0SxJVLVnveRgJ9FDmTe5jaupJ7QWrkzaBrWjYwE8P10/OaSqJpinwq9SFJGx7bo5nmeQkXkny4a4ZU1TCsfXrk0Z1Ro0hdjtGZdR3unfDEdcYriH6OULynQ8yqbD4SaNpSjBEL1dxZ8YxVoLlL9D2lOa3AncwYMLom9q63M3SsINWfqUpoo4eICb8o0K9bEiGoL93Caq0bsrMzVs6XQVQvAIof3z+G6LCIwGOVvqQ1ZO6Oirnrikl/cmCEE1I2gleXxj31wUaWC+40ojrLv3Dn0+paK4tILFAJDTzwtOe+BUrwZtZSTqiq0jyw4w8zdNwtygKqcLX9dG9+2BuGVQFivqx+O1Ip2eamHhR55ZzV3DDArnsFwucQ0vXd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

For CONT_PTE_SIZE-aligned ranges, return a mapping size that may cover
multiple CONT_PTE blocks, capped below PMD_SIZE. These sizes are vmalloc
mapping spans, not HugeTLB hstate sizes.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 arch/arm64/include/asm/vmalloc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..4053b1ec1902e 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,10 +23,14 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
 	 * block using the PTE_CONT bit for more efficient use of the TLB.
+	 * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
+	 * capped below PMD_SIZE.
 	 */
 	if (max_page_shift < CONT_PTE_SHIFT)
 		return PAGE_SIZE;
@@ -40,7 +44,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
+	size = round_down(size, CONT_PTE_SIZE);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


