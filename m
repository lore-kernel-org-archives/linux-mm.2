Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95F3C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3678E6B00AE; Wed,  1 Jul 2026 12:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1D66B00AF; Wed,  1 Jul 2026 12:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E06A6B00B0; Wed,  1 Jul 2026 12:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E562C6B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:08:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58A6C168417
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:55 +0000 (UTC)
X-FDA: 84940691430.03.77EF7A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 731201C0013
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gDKGsoSu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922133;
	b=BNJIGKD9bRJ4Jnpteel2cDvSZVT2mhCM3QA4proUcZYywaFusbqtIlw+z+RwW57+X85WZ8
	PG+dd6ZpbsYAuomI2PDSYZDLgeGKGSDvpjdpuApDFprTcKZQSon1EZi2IFwozm5i9MZrPi
	F87tB0xfyzUMx4iWMCBfvDjtA91U63I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4svri2kKaEffu19Oke4jQpVS/UKAzGmltv6WEa4/xwk=;
	b=gI0CE3T73DIYfgrE196Pc+mJk8De3wtrW/OsuOBXSlRZWaCrmljHG7kuy9+r822SgDT/Uh
	NN1ZySBGQaMAez96NeTMFc3pDglUUjH/rFIg8SjOsAKMFY9Xi9pZahEaBE55ElaY7tB35W
	gXWAU1Hz80WBOSawWXcwm0ELt/EItr8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gDKGsoSu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B007E429C4;
	Wed,  1 Jul 2026 16:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D934C1F000E9;
	Wed,  1 Jul 2026 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922132;
	bh=4svri2kKaEffu19Oke4jQpVS/UKAzGmltv6WEa4/xwk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gDKGsoSuoX4y4+MxDGlxgvPDvWfjgJkJqbd4Z9YYZpHz8hxnq0PT2TzxefRMxVAa0
	 LLxc0gfXz+qgZo48WkXD5vaITziU/QoAPNRgdHmevJCl3HtlfFa8V8lnaN8/lPSoPG
	 p5iKl8CJsukVWbfhFl8WXyUsjdOfJnyUyxwTN8lF7AaXcwOjfoawTFhSMighESuZ5r
	 YEe/SUMdBjlGtyX5rVRWovUn0rzPNWNqDvBxJdBLtHjc3eCV8Gyyi7+WN47vgNUBTm
	 7jd0LJecHEfHZckFVTdLIX5rxFoXf27BDwP0eu3Fdmr93ZkcEmdf6rFk/LkbhdGvTl
	 McmYvWLdY5ukQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Wed, 01 Jul 2026 18:08:15 +0200
Subject: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
In-Reply-To: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Russell King <linux@armlinux.org.uk>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>, 
 Chun Ng <chunn@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2551; i=treding@nvidia.com;
 h=from:subject:message-id; bh=G1LDIXegX2JsIizEgI4OVqdVWI4H2qUqnDjgZImq5XA=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqRTuFpaJPLzRyixdVeDrzwyjHz8TdwopYr+lh2
 QtMV/FTH92JAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCakU7hQAKCRDdI6zXfz6z
 oYHgD/9DX2Si/rXRk+uCTzgU4FnEHIC0/836XVX0PwE8Ma9Ts3J4Ee1/5z4Bu7fsEBHy4B5nsYJ
 5HY7goBFPkb8aaQuFHph3Elh5ghlrSLBKMwuM9bif/EjTZCy4cJvzDmW8MoMxwShmrhItxDbn2m
 wDriAvc09QSZbZJXHGas0SwlZbJrBfz/L7SGZpaHlEuK0/18CNrzsihbkF03qYcRhI+bIbyKp6x
 OCCsizV8aNU6Rdv6A76LYBE1opYbwXE3hBvSoEb0rdjK4pwc1M9VrGaANO2WFhSqtp3p329kiCR
 t3M6Tcq9VW6OhNoVWjtbxSYsH4AyO/4GImvYOoBBZmABxd3BYGtDyx9qiSxwTnhIOkowltBwDEC
 r8qcvoNnhp1KLdYBeatZBsgshi++YY+yJDNl7EnvEnHwAsIe0yhIyirKeSf1eTvj/1j3R4XXu5i
 w2FAaNtlofPzZAj/5aiWC8afRClCczkiKN/T527UzBH93xC/VZFX214PjZama7wpFXNU98m3jDG
 wFusLKzUfW0WuCLubnpA/ais9Yz78tToqcJdtGAvP/sN+buHI3vnWH44We1nPHow3pKyFXOxngI
 uPQWSO+yHz2FMkvwy0UDzziwfMQNIiMuzY7FpCKSivOCfIUKmjoYRUW/GLcGJqauaMlNBlwCoMm
 8wKqeTnYGGDOWRw==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 731201C0013
X-Rspam-User: 
X-Stat-Signature: a7hbayazywuz5imgn1sruk9nzwn715wp
X-HE-Tag: 1782922133-842164
X-HE-Meta: U2FsdGVkX1+/uFBT3NdCKoHqlzdvQ6DmDkW2PiMQQ6xJ3g2XQ4ZSZNPV4qtWVDEBs+wmQsyTh0Z2gjVOpa2PaYLJhfFZVaRrl34iluLTbQpgGDYjummXZlcpQuHJrIQNDxJztGW17lKd0Pb24il+n7HzOrVAED05Wk0y3158Ga1HJbaMu3hBpK5YkHN+ohaAchNebEiE91/N5QwN7gpd5fBNVGxPMYV0pIBj7eHf1kRmCdW0PqwK4vqdXAyxQEQx3Xqx65ZESfkk/H8JRxDFG0uca2b3K0SXfFEZjTe2Q6VC8uQYq5eWPL+1KP2GTb3uTSRXlh9hpnGYp20B1xpkuQn5LJqONu32XcFKdFwHK2Xm1re2mTvq/L2ttRahbV/0jcSinFTxcMdeWcihgyXr482LIt53/rkUMfKC3Z1Ga1En66603f7y4dfexnNzvI0yXjF/YGHGI8A36DQ2I8y9mGxZH4UmJEIQmrbNjNwkgZ8YVKtgNWN9zYerAEWevVvVl4HxilFr4Ia60vyYqWIm/jGWg9NPN4TiNrPL6JeRDLswMgUnixWosCT3B2omPDghc/xwW9pSnQ45/RL7Y/LZ5z3qpDQJJQTqefj9MmJ/5MKRpAOmfCmE/QVkYeZYPBPRmVLhg2GDbQyW3+gTDsEfuVlbJqE7a+HTmE19eLqVkG8gzLq82C92/HfKkSlZXl2MXlkeSdbC/z+QXBtSd7FlsqgoRtb4R8sMH4m9MeqgbaFGndxQgOXMRPZZ0XhLRYWmXX0zF293HB/CczhsD6qPL6y5+3DI5nYSZQ8sbDIwpXD5weWEzvq+LeTC887qCGYkbFWayahwb//wfcgd/CWvbrQVtR2dDjQSK+rJluIjSCHp7o+jc5q5b9sTZP9SFd4LU7UMsy/GAOfZMMSgWxgdFW1Ug1MOXPKOC77jkKpnRzbDPrBo/u+ZbEVHEfjwBZ7fgA/NIEJvRegePr7MnO9
 LOAEfUhe
 6ru1KJQ3jvNYZMhmoeFcl/8A6kzPdObN3OCvlZ9j1nn+rnFqp1MHl+gjigbGaPNJCa9puZ1v+YXT8KSvwSUJYyO8P9pR6z7FLiV+rcLTJaPDq+5ZQgQ5SwNsmltrAJ0E/b2iCBEbUA/IH0at3mkdmqUdtVUK4pnTXIDI13fRHF1nN6TOzKpn4PHxEiU7NFP5aFL3xEgzBTugVw5rkw19bcszcry3xTGqoD194Fysi0I2kC80zYke/0eZKE0osGhOEHP1ve5lgr89MtG34qsrF3mHEGrkn5OxamGeAzJdVJrLG+7fiXtn+PnAdDVCurK7McqtmK7RhCLJMLhYwLzI+zsUFT+tTKSy3iAxlvkQD/Tg0PtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chun Ng <chunn@nvidia.com>

Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protection bits
on a kernel-linear-map range.

Signed-off-by: Chun Ng <chunn@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 16 ++++++++++++++++
 include/linux/set_memory.h          | 11 +++++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..6a7030609789 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -10,6 +10,8 @@ bool can_set_direct_map(void);
 #define can_set_direct_map can_set_direct_map
 
 int set_memory_valid(unsigned long addr, int numpages, int enable);
+int set_memory_device(unsigned long addr, int numpages);
+int set_memory_normal(unsigned long addr, int numpages);
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..871b59a6c9ea 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -251,6 +251,22 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
 					__pgprot(PTE_PRESENT_VALID_KERNEL));
 }
 
+int set_memory_device(unsigned long addr, int numpages)
+{
+	return __change_memory_common(addr, PAGE_SIZE * numpages,
+				__pgprot(PROT_DEVICE_nGnRnE),
+				__pgprot(PROT_NORMAL));
+}
+EXPORT_SYMBOL_GPL(set_memory_device);
+
+int set_memory_normal(unsigned long addr, int numpages)
+{
+	return __change_memory_common(addr, PAGE_SIZE * numpages,
+				__pgprot(PROT_NORMAL),
+				__pgprot(PROT_DEVICE_nGnRnE));
+}
+EXPORT_SYMBOL_GPL(set_memory_normal);
+
 int set_direct_map_invalid_noflush(struct page *page)
 {
 	pgprot_t clear_mask = __pgprot(PTE_PRESENT_VALID_KERNEL);
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..abcb11378fdb 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -72,6 +72,17 @@ static inline int clear_mce_nospec(unsigned long pfn)
 }
 #endif
 
+#ifndef CONFIG_ARM64
+static inline int set_memory_device(unsigned long addr, int numpages)
+{
+	return 0;
+}
+static inline int set_memory_normal(unsigned long addr, int numpages)
+{
+	return 0;
+}
+#endif
+
 #ifndef CONFIG_ARCH_HAS_MEM_ENCRYPT
 static inline int set_memory_encrypted(unsigned long addr, int numpages)
 {

-- 
2.54.0


