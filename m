Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C492ACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34E3D6B020D; Mon,  1 Jun 2026 04:49:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3040B6B02D9; Mon,  1 Jun 2026 04:49:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7106B02DA; Mon,  1 Jun 2026 04:49:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06EFE6B02D8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:49:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCB8414060E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:10 +0000 (UTC)
X-FDA: 84830719260.24.D37E1BB
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF785140009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aee7sTuj;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ct8LTm9E0tar8OtNDyCoaad0P31p+YAvHyjb0MDrcWY=;
	b=CdFII/9u090qzy2zcySzUE249Xm4xDfdSc1K0c9E2BJ0ctvCehNw7TLVX3wMfrNo/IB/xh
	vfEISopkZdJR/sT3xvOLIQQ7GDTdcO13HIDn6C4PRj0VQ1k3el5lUlpdlKcr1sZAIG9Uan
	3yZq+ib4Qhnr6iPrblCwskrHGmYzvas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303748; a=rsa-sha256;
	cv=none;
	b=b571F92x8EaSYjbCFhlCniOmUYZfFJ0WyfVLELurb3e91HYsZgBLgFSj2ZrWREKK5Q6w5u
	Mo9Db/EAcbc2i2WDs2L6mMMKXqvQafZrbUv5KqqCY6MKEBRMqfrUZV73TUolXOpXhzTiXb
	5+NFTK0acQSY9/Hd2O6luQ3acVLc+Gw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aee7sTuj;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8423f626a65so351132b3a.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780303748; x=1780908548; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ct8LTm9E0tar8OtNDyCoaad0P31p+YAvHyjb0MDrcWY=;
        b=aee7sTuj2nwKqL/rjIne+i7aTfWN/qW9bletuoL94UrHqpaEpw4RCQ/iD46bX9qDR3
         +kKXaVXrOLXYL8YcxYoQEIfY6Ck4MAo4fUBFDuLHIxCQsgsdqE5hg6/z3K5MwmgTZvYm
         jW4tMJ4KylLTEmkaPZRQIhPZlcWLe6K3iXH4F3NbQNWPcmBBct5bwtNMLEAaaCD9sRtZ
         IlvOIOZNeG956AUemdVdIRYbO2EsThGZ72UBi2lVoaySi6jS9vY3Gx6vBqrBUqAQBJU5
         nE1xygSdSAKrq0GeRxB24ytTCOAfi3HZJ7V7Yj0rIdkCOMeFCB/b0/IUV5aNUgJUoGFc
         NLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780303748; x=1780908548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ct8LTm9E0tar8OtNDyCoaad0P31p+YAvHyjb0MDrcWY=;
        b=TiCGnP+YOSvfu6Ll3Os9sbYVbTW0MJFWu1Fe5N8IA77BMYhDQa3CtwuTiFbTRLC/F+
         w1RQ38dqI5DMaTYrId1UV1444wF8D2qIY9KJpnmDRA1/zxxiSipqtrpjL+ZQTQLq41nz
         PCBJXose06RTRFMqsX4v+0UqH5Zz01uz1cq8xPO47NDS9QA29mv0QojX02Zb8QXM6Y9h
         Lk77VRGsbJs3+wR9EaaTOEJUWGl+xWFErZcwBmVE9z8MO0sv8JAVMlaLoiPHETynhvHh
         Juci5lzYRPJNFqzUdtwEcjsM5mzT9yALJPWHvM7Wgrru3nEbToX2jlbDlhkRaZ1e0t2o
         r6Xg==
X-Forwarded-Encrypted: i=1; AFNElJ/qmJ2/PaBCE4QP8KwJovj/k++7z4X9t9fKiEZ5ki6Xk5WiGRFbx0Cvv+PonQtFyFwSY+dJfx8lNw==@kvack.org
X-Gm-Message-State: AOJu0YxaeTKCoj9KV9/u6sAmHKJGN//xrrGmYbCRWOBarAiD/OuE3sIb
	XNgBFIRNNFVQYlc6DbYhpGqCz6Fu7AeYQNLJnZjvFs96igcpX5CdOkcg6fiC/4m6KVA=
X-Gm-Gg: Acq92OHTan+dMlgg2Qx/QgTHSEElkYxmbGm+zL4scs+ViMKf4evC/Ue/btWeNMWei7u
	WVSDwfQyslbJTUApBhIceGEby6DtO3mRvk960De59lffo67hD+BsG4zMejAPkYwNTlAUnrQkhln
	FIlHKp1Ctuso2Py7/un0gG4rASZpLVKKVE+XckMrXCk1nL6WRZmH9q+amgZZ2qdzGK3t0EqBmZX
	Vh9ix3k2VksThRjjwiYTEx08YAH+QaW+o6l4camo5UryxTzw+169stG04reoTTlVW6tVxOgdNeA
	hwDHKSbL6Yd7k/m6ZtPxKHDd2Su6JGWZEGI9tgnfK2tbSrwF74LkSvo61AkgJ8NHWX40w6MkPGq
	B4jvhOLfsqpt0zT+ZVGhjpvDuv6YrwJZK2BuaqWFFe4vtaOCcdf00/GSJo+PMdJN8VTeo1fTgIX
	QzgnG+4VnaCBfxKdLfb4VZBfxUaQfKPG/rQGQmrJV0nuM/c5ggCKNWXg==
X-Received: by 2002:a05:6a00:3903:b0:842:2382:a0ea with SMTP id d2e1a72fcca58-8422535fc9bmr8854602b3a.14.1780303747688;
        Mon, 01 Jun 2026 01:49:07 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84232ef8172sm6316230b3a.12.2026.06.01.01.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 01:49:07 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 2/5] arm64/mm: drop vmemmap_pmd helpers and use generic code
Date: Mon,  1 Jun 2026 16:48:41 +0800
Message-ID: <20260601084845.3792171-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601084845.3792171-1-songmuchun@bytedance.com>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DF785140009
X-Stat-Signature: t9ikeiyihb1tndhere94u9fqcidnwrs7
X-Rspamd-Server: rspam06
X-HE-Tag: 1780303748-773814
X-HE-Meta: U2FsdGVkX1/4CSuinGOOBGPrCyWS61CVKHoTP9X02SPLQTzLFOIOAy9A4zrq4ozENUId+uX15QKyxczKbZVGnouYO93UEhNKYTkKwR+ttNVs8SzmhVRuu7zy7UyqwzM9EDnNj7rHaODdGq3NXHCUVK/lS88/c9yXRHTEjeWmNA19T5bUB5SDogTXxpkCZkApgwoR4ulCPpNTiYlPnVsyvVlcvF1oMb/+kGwb4ZncmALstOrEW5ddyKkazEBPBlFuX1whOd3N2Q6QKMXn6li3KBIlj730g/5UhfAEZRUG7zFOxPDYJklG6Q8TIHbiiCtQkROVHcz8khOwd8i7cxUD9HNBTjF1KHGHlo2Aw06QejtXKxdbYojInm9Vt7EB1P6ZwUGokN9ZUsX6WTh7Op/ncT8v7jSlw0bMdPXgtsZOwPX6PgcyrkMV3ipPKxjyPoBlQsCpkssGVqhicys/0GNBS1jRivRcxvStLEbxt8a8Vhi0I0hPq/K/GrLtqbY5vjTY5fl8ogxcRKCY79AXXGDfp5sFM0KYBIYF8I8dzV69rfVppO7c/nUuWakaalo0KyHCV79imm/8uLbcsUe67BdJDCcSYgGlMIM/8MDmLIpyKWfQQPboJ1/kumdJSq28YBeHzC+6l9Y82xyem5yldXpe6kcp5UGhccvuymvMJTAkswP07s59d5Wo/KcUa5BGcUs9K0CUp9cTaZ+CTrI3jIZbxDymn+u3E0dna0F419miH1Bu+0G71yQ+bxmRPuvAdqU7Oob1z+Xy9KzOu0JA9bsqxS3wlMXLy1dHFgdDhdoPcu3xtUguDg92MtASJeHwQF+3a4yIlinrhSxWVMls3mLrkJAkUKmbm3+JHDEAa5RuIn8L2JKtsA+jezIJH2DNdQLz7V/LO5+edcACbt5u+Wo+2BRUSp8tO9NhjHmHq9+7xXxtqzIS+y8AZBpg93f2AIGcB9Q+T8BxFEIgCQZNkI/
 nkbXZFtt
 A3/xYdntb9eTZ2S6ClPaZB244E/SK16VgGctoEQFQ3vBwT0+GeSrqjGcMZdejD1n1GYl2zkTslTfszOCj1l5WP4V3Ly6bKX5OLGF07AyVJSW5lmX/r7s+62Z33ekrgDMR4dpAkcvwgWjCXAjfOCft6+Lu6s84ps2HJag9R9KqvtdwDPXbY4QJHn5mS2T5ftnACCPflvKvkl+SNdAD7qW5l0Zu7zJNJbpZBWJsbhVi1eqjPoWEmsPwdTXTQmTpnPbX2fRUjSWkjr588QKbFusC6pLd//lt1MNQWHv6rVMZNl+TR8Lky/JhMAsFZp0MDaQ0qwrLP2d1gskBOJl4GmXuAn4f1DVX+509T0nTPBXkgqa9xiQqxF9XGoNxrsqe6m3R10nV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic implementations now suffice; remove the arm64 copies.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Will Deacon <will@kernel.org>
---
v2->v3:
- Collect Acked-by from Will Deacon
---
 arch/arm64/mm/mmu.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 24388e5c727d..ea10b0ebecd7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1776,20 +1776,6 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
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
-	return pmd_leaf(READ_ONCE(*pmdp));
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
-- 
2.54.0


