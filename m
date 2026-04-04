Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C8CE88D9A
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 12:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FBE06B008C; Sat,  4 Apr 2026 08:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACBC6B0092; Sat,  4 Apr 2026 08:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E98E6B0093; Sat,  4 Apr 2026 08:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6006B008C
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:21:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8C14C1967
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:30 +0000 (UTC)
X-FDA: 84620783940.26.A3AF7FD
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id E5727140016
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hnxXDSmX;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775305289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kI3rlSKvLXjOnIGBM/nCi97GMUjHxk2mPfVufcNpMfw=;
	b=WE9co3/mOY+BTEXqC9P6Kk0FzPPQn0gWgEys7r7Y4UHTGiQhl2wvdeeC0OfEZgbOk9i0/T
	7Vf1vVFtt0rXnOmULU+BAFFc7UlBStRYgxx49dr5diB+KGk0MbbnAfOkA11iu9cfLeeQ23
	+tQA6GNQRuDEG7BSEZC8bql4YlWYgRY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775305289; a=rsa-sha256;
	cv=none;
	b=zhyKnncs+iJvuX8j0WF20ka/QvjyWPSAsJw93BiJ5eb3QSMaTfBEg3ob8THb8W3/3GgXg9
	luAP1kz1w0WJnx9yWYKi9+kT5spXU96ZJ5MtCjiYYVIHXMbT/OnaSeAF2XtvzR8pK2g8QB
	g5NNS1C+rzcnqgAZlh4R6TTy9wiKrBk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hnxXDSmX;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82418b0178cso1230630b3a.1
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 05:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775305288; x=1775910088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI3rlSKvLXjOnIGBM/nCi97GMUjHxk2mPfVufcNpMfw=;
        b=hnxXDSmXMF/B1YXmWJc8gSUDy8NCWHa6MAtWZda2wgocBRSgOz24ps07LY37keS5Hx
         UYtnTVCC8pVhjIb7st8zB6J7CUabgcsVV3e9Y9yuKQbsscl20UuEsBEm2PuXQj5jJz52
         lCDOFdSBnZ+PHLAcuLDEPeRTbvrlv/eA2L9akDpV1Ipz8dsJJdwyWFX8ramK3w/FCVc8
         T3RI/N5SxmJsLI/M22S0hgNIeLCT7IhcDiLdxR8o5qY7xEkd2Ba/qKNpAtVMrMSTmq8p
         B4BKYlX6mA3TCM0KfjEQgH0eRLN4sMeMY+Jq+qk31hXoKmrIX08U0v4DL1FAzPFMl5JW
         Qmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775305288; x=1775910088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kI3rlSKvLXjOnIGBM/nCi97GMUjHxk2mPfVufcNpMfw=;
        b=JX10KlMjuoWEpt14BukRtI7r5E9AGJCfkbEmyCcqgfumF7JPnthN5yFYYj/X6pf+J/
         re0tyZWVUgJEPAZ/SH2n9HtASVUyyBdD8y/HsqQZQo+Nhw68YZ23dgGWDlBEwHeReukX
         xEPC/pYlxj6lw5eNWHOtZyQy0rcrJ7so8elZHS3QuTWEkaGBb05kUDW/fr13OP4HvIbb
         X3T1aL5Fe74jqy45dWuDkNIcpqUBA17A31sZFPdXnrpABgYOEEasj2Zs3NB0sQMA98tW
         dE3YkVoF9k8AM0eipPFbgOenfHHo9frTrfXN4aPe/sgOTOu6UCYa3dHOaNYsUBX5mV4B
         HYhQ==
X-Gm-Message-State: AOJu0YyMY2/0emL/qRABG59XD4HNQMtuTzbyd2AhoojzlQF9rnhJFE2Z
	CM/z5xK+8gPCfq3MFT4wFE7D6pQaQ8a7X41eSKkMA6VT3Ic5FYJQVGf5edYqA8ST39Y=
X-Gm-Gg: AeBDietlPFNFZpG+axTgHZDYS5JIYtCXBUiGlJE45MwRxphLD98qlK3K9Zjur5ctBAt
	ljx28nD9fM38e2TVhpRJV6K1gXtowE2Qe4GQkIon/E4Pg9TBon6+NIwKlZzRa/XFSTl4Bwgzvlw
	vtQUxhIykHw0SVQeaFdoivtEAJF8p9a/OJTFiJKe86nPvHboFHjRG5+MpYjozaojd/mSJXUJEky
	IeZ6mdKlUCBdP7VOnnqn84JWEnvmA+RkPi2lp8ik/ISIckCn1f8iIgd1xCA5Kky49XcsTIysQRc
	UTM2/ZCXy6tiItP2CLsTtHXFKmSOr9IatdXe7JRTykjfFtQWScYJrP3sqHLPEb6td8tYXkR62WD
	l7U6mGRiedJXfRMDYLJNJDJwt2KtrWg+f4YZFwynBIEG4W39QBJpdjFFDFWmRPooXLgqwMdLWHc
	hz6KCa3UDDGxcgXc4IdedMdZTDs1ujxLruS67ZJ2WXh2k=
X-Received: by 2002:a05:6a00:181f:b0:82d:29f:d003 with SMTP id d2e1a72fcca58-82d0da2af95mr6055941b3a.12.1775305287696;
        Sat, 04 Apr 2026 05:21:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cfebe5b23sm8327063b3a.59.2026.04.04.05.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 05:21:27 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] arm64/mm: drop vmemmap_pmd helpers and use generic code
Date: Sat,  4 Apr 2026 20:20:55 +0800
Message-Id: <20260404122105.3989557-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260404122105.3989557-1-songmuchun@bytedance.com>
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5727140016
X-Stat-Signature: 9bxzxc1xg6s4nwycgyrgzrwq8rsfe8r1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775305288-815593
X-HE-Meta: U2FsdGVkX18G02C7D+rep6nnECjfHH/8aAA7VIakLnqH0d2ypSTuPEyqqG2GNFRzS5c+nw2mVNSrqYkrKc9GwJQFumf+AQJpRbkOjkcQYd+T/r6ZAHSe/AbNtrz0sm5oIYKULD/2GwLhWj8P5s5H1GSOnUDlKr0KzknPNeEPQseUg92K509fU80ho/W1JK1v07bnI9zU0gHUnPJPfZo8zgDjCqloL8ij7LvTYlOAy4c19OUCbGrf6FmciogT2lnkSEIfjblRYUN8mai9lZJcdX9puDfrJK7yXZIdwTtWZEB3CuVsWZbTl6uPEdy8wQZjaFMkU2si5cq6eQYxMohPq0elesAALl0V4gxIh9myy2nSPo4N9rxawkc0hq4WWYGJhzQCLLMAVOVhV1zpVXBFP3AnGVS8GTX78/+dEHiNBbnUp7nRnWYiDRMUSGCtq0G6MXGcdO+6FOYUeHG2c6rVpmAwcS1wC1cyCNqfNKOnz6LSQw6iHDNdQdjynKxsFga1RgBcixZ0v+ZCQuezbWYaecZEysV61yaJkdVKFI6ouFbdT57TMhTS7g5rQO4yeKDwYoXO6LEzTviPRP/AfRXrp+/IyBnmmDXpFm95aejPks8YCb0wQSZkYNR01ivSa0gcvyPu8W9vFvMWvzdf2SNFm9ypO0lfwBzET41J6xcn/uUfn5s+X/DjwdU5o3z7cWuJKGKReJW05NHpGR56BncbXrFEVL5f7I3ckjBNkdq3yeQQAqOjiW0Hd8q5v9LZmcsiphLrVXGgy19Xe0CenauIuufCmJ0MXgVdEvJByrZcuYGxCuZCmHEi/jJciHkfJGpiasD4VGqeDAS/4EJi+vgUI8vR7JscXVvrj3RL60obZ0FPGD5MdS7Uv7rS7TtUl22OF5E6G0CQvjM3hEZFrzuybbperKxm/uSxXLnl42XkQJG6pQcKQxkxeee5G0BYyYXYPEu/d9BvvbG486I8eHL
 15HjC4Bb
 RYZA663MX3XMSZq5HFuruTOE/LbMMfGDe8fA6HF/Gp0mtE8cUXyRIWv4ZDQyvRVNPP09Hr36zXN01cZuT2M5lnj3/Pm8zWCBPf1qM5dbt6TqzpiErNM/UdR17sIpVfG486LJShkc/F4RATGFyZzFTDFcwjL3pBS+9/kIagH947UDBJuxtGp6vx2Nv6qfaOX22VUAmn2iCN4cQqTSzOPHMNqEN3plShQHXco8arloLRFDe1a5wZhskthdfotwPIUVn9L55habtfBj8ywb4z6ZLvqvp957QjSYmNnRQKx3LEp8hSTe3cblLYrQt2pXc/KgDUvCL5cPe0+riIq9Qo5a7Bj4+EA3Fm//cgzVHme/oPz/htpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic implementations now suffice; remove the arm64 copies.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/arm64/mm/mmu.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index ec1c6971a561..b87053452641 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1745,20 +1745,6 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
 }
 #endif
 
-void __meminit vmemmap_set_pmd(pmd_t *pmdp, void *p, int node,
-			       unsigned long addr, unsigned long next)
-{
-	pmd_set_huge(pmdp, __pa(p), __pgprot(PROT_SECT_NORMAL));
-}
-
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	vmemmap_verify((pte_t *)pmdp, node, addr, next);
-
-	return pmd_sect(READ_ONCE(*pmdp));
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
-- 
2.20.1


