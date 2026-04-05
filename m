Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE833EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6B06B00DC; Sun,  5 Apr 2026 08:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166D16B00DE; Sun,  5 Apr 2026 08:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D066B00DF; Sun,  5 Apr 2026 08:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED2996B00DC
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:57:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7660BC8BE
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:33 +0000 (UTC)
X-FDA: 84624503586.18.85CB95B
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC88F20005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=H5SitiL8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393852; a=rsa-sha256;
	cv=none;
	b=R/oQ/vcLCRxnd1NWms7ximt7lwvQsurt/jYG0nfs40KHKWuziupqumulez94qc2HmqQbVm
	tLSQJX2V1F8k4AjVy4IHtNnKhp1A7YfNBeyricn+QO9PlWhIYE0erC0JkOgiOH0v4yI5uo
	zC37ZnQnrLfagGNZHsL7S/4VppXDc0c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=H5SitiL8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEhjAbTiZVKX8bAZfBAftf7xoJQ7IQs8AgKwKN6i98g=;
	b=VTeovyg7641LCX79a3zGNwH1JkjdVqzhX4s8FOY7Zs6zI9vTAaYpDYcmdZ4s+aJeJYgC2Y
	q14USS8CIS9tKj+8T/+VGk3kWuGIWTewuA0CtIHy9FcciTYnCOKTSrgemJiQuLkUeuWxRI
	dYrnycqK0GNfga//eZfFnpC1QJSNsKM=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35c124d2613so1750827a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393851; x=1775998651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEhjAbTiZVKX8bAZfBAftf7xoJQ7IQs8AgKwKN6i98g=;
        b=H5SitiL8R9WrcgXvBZ1+jOivUCWFUE359vLFTsOzekagf+gj5bRnklcjdH7PXBA2sS
         6AZoH6j+XuH+qBfpLZ2sm+dwBOWjzSp7rdrLzzHBoEcJYERrsxV5qkxI82obdWu3Yee4
         R8HfGWDKcKlfoBYjAc+24ZZSIJV2BxBGr5e6Ah1Bsft3C8csfIVnO3EcEppycMABReQk
         K4zpNE3ygqZ5cWy6qUZV2g7eFn47qTgrsR994pQnufusKr+We/lWr+Oh+EmozS3JSH/G
         Rocei9FFxFvm8jh63dU3EF+IPfnOUuZchLXtJlAR3F0rQ4OBd3dA58QlMjh7Ur4KjBnV
         rumQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393851; x=1775998651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yEhjAbTiZVKX8bAZfBAftf7xoJQ7IQs8AgKwKN6i98g=;
        b=XjYd19OLyyHR7443KbSWkqpwn1KTqosyxddkc2BHNw/bQj+drAvRip32r42FiqsHHZ
         ctpEh3U82mNFeaDmvGhr+R+ayCbMEiSbLHncdDYpcShaENqnpIUQwXgi7HoDVmHpcPZ1
         81X1RYTUrc+iPUNFHm9zHfs5xYeCm1nsKcvkry2fwpqnLPREpMYuScE9q/mRtFaQGErQ
         O4Yw35v5i+SIXVRvLgMITXDzVOlM+jkluBLp5kJMaZXrCJF1a7ooftm3Tbz1c8hurie3
         Mzvo+FrxxXmtZSf8f/rU3JNTQU6lIFo5LZ38Dc6H2v9vQ3kmK7+jpmMbj4pAT6ApYyE+
         TpMw==
X-Forwarded-Encrypted: i=1; AJvYcCXP3bHOWsWDIzCnvuoj/tp4HRAOmIb7PC1FSXewuFoInOAZ1Y6qQORpEoJ7ge1EAS6iNWDHF6V1PA==@kvack.org
X-Gm-Message-State: AOJu0Ywpvu7YQpCyRcsmKhCsJnGm+5QX0oWNbjrIfONGQbkpzyo+jnQC
	vByymy71+O8ovrA7tz5/hlbMNyaNoF5/KDiwEVka+OeZbxgx1/8Xmonk++CtfbDr2Gk=
X-Gm-Gg: AeBDieu6buTGl+e2P7ZUNp1SZWmb6wzVHvd7iVcc/jxE3vs/fHMv7OrT6CyZ2O7z2LR
	ANU2u0Q/6D7FHgt6zJb7RJn5aZZ1Kn+/nw+GdytegLgAsnvn/l1SLz5Bv9CJ5V7la8Y6I2b357H
	YtB0/NRC4hrW7ZPo9XjfTZ8gED6jQBou/L1Ea6XcLHQkfwKw8iku69BdXbboVbYBnifJdBvPWrj
	pwicUY5ry36Ci728S61RZeMOEywc1r64Wq5jJaDxKfggF8CFcaSF75DTkoHqJ5G2GomWtQYgBxL
	EVybb8dlNbDk/7XKCPvvtfjSD/TvdHVZRYXae4cJ57nCZloBG/JT+QDZqGQnMgiShI6RVIDNe3l
	HZl2POUGsXyij1lGasUu6MRNdht33DPBZbEa2JhznlyoO2aXaf7Vuj6DowBTyLQsFVV11T55T7y
	Qz7Lirsa5RHxIaqqX285qBJSs5NoywgbrbnmHsIsu97vY=
X-Received: by 2002:a17:90b:2b4b:b0:34c:fe7e:84fe with SMTP id 98e67ed59e1d1-35de69aec1bmr9125066a91.28.1775393850723;
        Sun, 05 Apr 2026 05:57:30 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:57:30 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 38/49] mm/sparse-vmemmap: remap the shared tail pages as read-only
Date: Sun,  5 Apr 2026 20:52:29 +0800
Message-Id: <20260405125240.2558577-39-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC88F20005
X-Stat-Signature: 53mcu3d8yzf9kgrb1qgcoycjyjkshbrg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775393851-80295
X-HE-Meta: U2FsdGVkX18iL3qf3SHdp3UA3Gau0wXsyAH9aDrbLoeox2YCjOgRIC9dVQDvwW/1tho92tczv4rP9egthOf4Cx1nSPVXH3SoSa8FwrokMYo5OE4r0vJTSVRsAW3OJ5OIImsV/obOx65KYDAsfAvuiIRL07PtKAvrXMHdVIWxufLC7dHyIWBxMrU5jl/vDbcjgN25fHwBPC1IgjoCwnGdUXuw3TytA/qOAaXsV3fv8w0jsg35bUK6BYSABV8cD438Q+pzDyrqIwhM2prop5OAj9qUwJnUGxClhxO7+Eh++TGZkwKrkNu9RxOuUBI5J/vALJHASddrdEKmEkDuVIyl8opK84s9IfPoc+BmGGBnZDz818Nk8va0+H7mE7wMLWC3j+7bQwjPbvMfbjZs29uHtIP4ERosk0t+i2CHVF04p8rWf2DJbGDC/bB/BdDxf1eOoy3pYb87MN5EmlLutkdDuURmCc03FX5UJcykRikfa9qhVldZlFq7y14qQ76JXdZ6WlgeGTS3Hhzivg9fuiofw3y7ZYQA99NVM2zq1o5iBJTq25+5dLCZISRALrYjpYWJz+FO00ywM7S1mbZWP6IAQlV4+fvhUKE2t7nBunYXhQhO4oBaD4but+u2dpZQBgIrIf8Uoe/cLErzBmDXtbfY+wNF8ql7sx4wcQY7+nViAzFIyQfxjBJGKwgZYMfvILMmsB7HNgADM1X9m87sbZaApritxPG0Bd+ZhdhRItwdQT4V6ilu0YtWmkMf4NzV2Q7Zkxj7caqdLCTvf+dM0dZq2LXxCuEGygRpTA25lztZmsCphicGJGlnGAw2HyNn1mWcnw0SW8jLVfa1KWFRHhFvMqZxDcAf972cM0+Bba8NnwYkTLfRdcYwV3ThMFsdEIRpKeYNMTvI7QrKcJWhawWKMZDWdc4+CMpI0/l3L0JfXYMXfBhagAFOASQSpRB1rz4deilRHnzxtrH4hCb1738
 1tyjspFJ
 GyKfS3xVmwGMWRksPY/KaOc761Ar/dfBqun4Uyq/pKOcZ1vEJoZ8EWy8NcnFT4yzEhEc32b3lmCg1Os/4Dn4aI7IFPLflmMu2+bIeHaGjPUVDRXsMPm1c6OKP0Dm3KSRDFetExSOxzHY0vDbQDC8jCYYeHudODOZCv7ELloX38m7U8JmjfWHH1YqAkPKaLiI5crIuBhaXs4HLW2WXRMBlkEkhPYdy6iHYDYscLdHKbu/yytF9T+z5+LkfMkRt8z9c0bc2LQZ4QVYqrFa03IcDA3kkWCMv785JPcSTYu/XcW4uRsb8pxqn5/gGGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB enforces Read-Only mappings for HVO to prevent illegal
write operations, whereas DAX currently does not, which introduces
potential security risks.

Now that we are unifying the HVO logic for HugeTLB and DAX, we can
remap the shared tail pages as read-only directly in
vmemmap_pte_populate(). This ensures that both HugeTLB and DAX
benefit from the read-only protection of vmemmap tail pages right
from the point of mapping establishment.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index fd7b0e1e5aba..c70275717054 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -176,14 +176,17 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		if (slab_is_available())
 			get_page(page);
 		ptpfn = page_to_pfn(page);
+
+		/* Remap shared tail page read-only to catch illegal writes. */
+		entry = pfn_pte(ptpfn, PAGE_KERNEL_RO);
 	} else {
 		void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 		if (!p)
 			return NULL;
 		ptpfn = PHYS_PFN(__pa(p));
+		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 	}
-	entry = pfn_pte(ptpfn, PAGE_KERNEL);
 	set_pte_at(&init_mm, addr, pte, entry);
 
 	return pte;
-- 
2.20.1


