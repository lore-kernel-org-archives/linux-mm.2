Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFCEE88D80
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 12:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E775F6B0093; Sat,  4 Apr 2026 08:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E7E6B0095; Sat,  4 Apr 2026 08:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D326B0096; Sat,  4 Apr 2026 08:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C49996B0093
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:21:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BE3B8B86D
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:43 +0000 (UTC)
X-FDA: 84620784486.28.561B43E
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8FD0418000D
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=APg+mqax;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775305301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKWhZ8riqXkPi9FKF5J+KPNzIU+feG9TnbkhlqmMtCM=;
	b=esDf8DsR/TtYZKiz4zzEsDPy+Iti+vFicLNTrXdRl81DjU3gvilMEvb7vVr8PgWNID1XlL
	Iwy1nER1abvN3+DQ2z1sKm6Aen5DGHLiAC0C/mqVBFOaX6ZcTvBNVmeIWsCt5DwZnyWFrM
	A0mu9VuI5gTymHKlqWxnUELBviDWyPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775305301; a=rsa-sha256;
	cv=none;
	b=xr6bZp6UaJCVGVgwtWxE017DYELas3+xhrdyLjXNflZvJIeGRxggy5oW00EtMDJrv9whnU
	MTjDziJbkaBr9o1oNnrj5k8bXMEqI90U2dbIx6XB/EOosBb7QzpaDEndpCJUl0zgwe3FQq
	/OD1zEAf+Pkplct1FccTd5cBcqGGE0Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=APg+mqax;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82cd98be655so1820154b3a.0
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 05:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775305300; x=1775910100; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKWhZ8riqXkPi9FKF5J+KPNzIU+feG9TnbkhlqmMtCM=;
        b=APg+mqax6bTykHYUWvoVFDWspdOEfc8SfRMOk567NVRoDYqbnfVi3j2kMB7dj5ttQa
         TqJV05KKKLR4lJAp2a+sCGMvPbaoJaEj9PKPv6DNY8WFgLHErbdor2k1As9zPBvawS61
         HmbZInKMHIPOAI6wINXuexYfCOyBaYM3IyMLDtQJEVh39flHpO0VQLFJwEKxzdE1kLEq
         PI3pIexsUZmZ1QKmCNRi6DFi26I2VbVWz2zjqMmRyyqhUQhNxgt800ZZJGZ4uJmq8M5X
         wsSvQVeLTxlKAgM3n8JAlj5TBnJ3j4h5ealbecu1JV+YasHVz1lLZTgWbSjPvAdMauwF
         r1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775305300; x=1775910100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xKWhZ8riqXkPi9FKF5J+KPNzIU+feG9TnbkhlqmMtCM=;
        b=HRPwRr7IprL6igV8AcVp9H0syppYbjDkOcuR7phr5aCzvmi2vh+9hgFDRGwoGtZESc
         /SYcfbrVD+1BG3k9tUlCSoNYbfm9RkTR2Ook6MWQKOC2rHNqFqhZeDNgfwdzoZZr40W3
         BXcnM8qyBYGcUS6dTvar66fY1uyDkuj2zSVgNW1RTZoIKaIygTmygYW5mgZV4Gb/YpB5
         sRF47cpyV/kQgWE4YYV3PwbfaTR3HPXXihIWbVuVHbHv170BnTpQqZZTJqoko0w/cKLX
         MXiPtoUL/kvpU7fgYiWUot3XgaWcZ8d8vwBWvd0u80tuvlzEGaVGBsTUr/GZ8tj1+vfZ
         SxWQ==
X-Gm-Message-State: AOJu0YyqpHDJL/J/Yz9FfJpBDaXXtpbdMyOxVdR4pQejsv6bXVDkKHn+
	s7+Ciuy6kzOKrBXovJQCXK/KchC3hGYTBOuI7byLc5ms1DrwDuho355t+I/98UN4yj8KiyL6V+0
	ogKF5
X-Gm-Gg: AeBDiev/6n9sVcTSVxXLIeMR0k3xMRI+tTcWnm46HkZA6Oc+0LNDBg/oxYb8xxrzwoJ
	GJoJ8j+aaa+Lf7OfssqQdPNCEkGD7vXITHkkIYHVKlQX/ZPMeWVDCZcnZ1l1GiX/+ySx1VFtmzr
	AOGp0H2/4ITxyzyJE0/G94tLMPRIegtZD7Mj2yYJLBWTOZaMQnH/cqx5rEMyqIOAJ4Cgu//ytQV
	nqPswo9end1SSk47z43hOCEXwQrYgFWPkPoyu3eexnpSFIBjFz8UhZP/dl287D2Uege8K1uczKi
	GiAsMa3oxjaGmWl3u/yMxgEkzOCFDzQLlqvk9kVEj058U9SX09u4UnjKYo1e+db3rtnUE3xJhDn
	3M7dgvNFVP/+k7/Xpf802H8U6zfWxPbx0jZ3BGzi7yuZDrRSxsunvrW/aa8coD5EVM7pAI79kxI
	pbrpOeHQ00K2a2lHMFE9zdvqOqHeFMwFkM9RLkGuZ+ZNg=
X-Received: by 2002:a05:6a00:1ca4:b0:82c:d861:3caf with SMTP id d2e1a72fcca58-82d0db7e9f3mr5730138b3a.36.1775305300317;
        Sat, 04 Apr 2026 05:21:40 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cfebe5b23sm8327063b3a.59.2026.04.04.05.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 05:21:39 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	WANG Xuerui <kernel@xen0n.name>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] loongarch/mm: drop vmemmap_check_pmd helper and use generic code
Date: Sat,  4 Apr 2026 20:20:57 +0800
Message-Id: <20260404122105.3989557-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260404122105.3989557-1-songmuchun@bytedance.com>
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8FD0418000D
X-Stat-Signature: tgp6iz5bhsqgcmyhnnqp76sku6uqd1iu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775305301-589912
X-HE-Meta: U2FsdGVkX1/rMAdV8Fws/SxLqeHU6D40K3OhctV1FkdWx2QTnJXaGfAcIuJrkc5p72zNEYc+Bfl1QUb503DIuJxaQIro6Lx1vsx0KhE1JsM/NWEjW5Op/+u0fBzSQYAD7fvYWpI2ppToqV+nChXtDHod3nauZSKf0LfH4I9X0lvfH6T/yOzlE5c/E4/mos4VPl2mPbUOQT3ldLhMhCacsDQBL8T5uHPylAS87lj638OpzM+Vy0f6Zxx9htJVgNyxdUj+wAoPfPeJvik/sUURQGYkzVJlAkMF/YZejx6A0A1sj161ACnbFzTSj0K2nfVSdyRHSbJ5BgK6rNwuMw9nlesOLjxlAL/7Pa3n1vEAC1+jpIZGrPJS0f20Zt8+E1S6pMDJv6oORhgnFwQ8AiJmQGlycXYMxrVCYg6EZ1RfGUd620ztinWTTe1oPpfcwNP+4kS5tmxCtnSXq3VtOjKne1OeU+AGq6FOIAizFimXmBddjcRvFLlSA4poT5CKgUO4hOyy9oXm1XWBvYT9kBlQcBcN2671nqfhXFnTPx0J28BR9MKOYxR4YrSPcvaIoIrbStTgtbxuBPVruAwhrt5ZGE73H/gM05JLVSLPBgQeFJChvz/IWL0QCYr38fqMmJ6LVPMXOM1fGDYDroVgqm4/QarU4Atrb90HUviyUBuY3K4i/VGFAxFYJsMStbfDkGrhXK34uWfn5TeoIPpkVC7fZnXWvZ0at9k89BL3YylLuFbJhQ/g3K90rbJOPHtt+AbNXlBRVWo3+/gKjfSk3TUfdxbfeE9nzDPE4XzyJrUEMIkF7SKirvueEzgUcVASDRoVI9fjaKVMxgo781du7YrT+CQ4Czy6Vg6gdwonvJEVdirw75g3o0ZpnGhTJ8flKmZcq6qEiT3YmnsmcpZ0zOsVuYnVHJMxmca+i4NjRmk5OrZLIDjPcKnBQJWZ+knuI1Q/ngPbTMNG39Q2qZ4t4wE
 Pak+uDI4
 EKgeMI02L6YqKgTwLHbCxbcYTcEkB5qpXSWCvggvptp++5KzC8rDsv/rVF77lX9/JLU1KFybeJWLpTOXpR49WixqbD8yAf2NkIfPLmTBOCl4qt+KJ+HtQVGZ3MBQfynjhxWLNXDYC7Y5GjlxIRYuiNFYx1FD7Jhm4blXfh1VTyn20K19+mawqHUVPlUgBVdlgk2jCIJ/ohqbkXZPBGJXGKNBKCtJIr6wBhAXwtApVU6SwlYDgwR78u2eYjlY8syEJpQ1QzxF8uI0eyJmkECf+FaOIWB2BKykWk37wWFKymx0OiLT9/lcGn0pXl+nnNRRhhugYzL93xB/a77YjcJCW3oV61y0LngBB2V1eQTB3K2zFZ6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic implementations now suffice; remove the loongarch copies.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/loongarch/mm/init.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 00f3822b6e47..7356d4eea140 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -110,17 +110,6 @@ void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 	set_pmd_at(&init_mm, addr, pmd, entry);
 }
 
-int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
-				unsigned long addr, unsigned long next)
-{
-	int huge = pmd_val(pmdp_get(pmd)) & _PAGE_HUGE;
-
-	if (huge)
-		vmemmap_verify((pte_t *)pmd, node, addr, next);
-
-	return huge;
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap)
 {
-- 
2.20.1


