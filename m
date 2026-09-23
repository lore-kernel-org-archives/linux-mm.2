Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE67CC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E180E6B0093; Wed, 23 Sep 2026 02:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA15A6B0095; Wed, 23 Sep 2026 02:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69F56B0096; Wed, 23 Sep 2026 02:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC9A6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:28:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3374F40578
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:28:49 +0000 (UTC)
X-FDA: 85244048778.24.B389F3A
Received: from mail-pj2-f18.google.com (mail-pj2-f18.google.com [74.125.227.146])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6042D1C0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:28:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KF6NwplK;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.146 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/fcB7RWsYoduiGVrXMcsoy9SKXwqPZ/B+Usu82ABAo=;
	b=DcGKi9qJOCfGzra/t0o34ckYypcG3eD0Wkxe0QiTelbR3KbqIwcjMSGy3lbEpbDHf/4D9D
	2zXJrouCvSiRRZLofXUFane2nryCB18bNlx2cfN1UAp+wCKtKxBdgQrXI+em+DD3YmF+fL
	oak28fqZNDGlI/U1R3AbNDz4iyQU7yA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144927;
	b=hhPsX2m69CDyVuloHufp0SFaRBQeKoafUh8s5Z9aVWZ8OIlVaqYUnLxeBFp0DEkX82+TmU
	J/nedVhQ6LaoS3gOp7tegemwqI3WXsAuzkICya8EYPCTEHOB+euRI7QIZMGed7F6zORej6
	U6zbCqacEihUlegmyDU4uAn4ByLHQVE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KF6NwplK;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.146 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f18.google.com with SMTP id d9443c01a7336-2db22383fe8so2352755ad.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144926; x=1790749726; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7/fcB7RWsYoduiGVrXMcsoy9SKXwqPZ/B+Usu82ABAo=;
        b=KF6NwplKBtWwqg6tcqypRMMHYE0x7La+49+aB5x+eq75wfu3CDPrfmCHVcv8iLHLFr
         RMf84e93hr8EaQ2epW9f6UgBRBzggVodoP5gMjh0BBpIEdPiiiyyJme6ms523G8SkjGi
         K03reAPLpItLTc/en7F72Oy0WnmdeLSz+6S0ixugm5jAbTqN+DnNY0HrgLaSUF4f8gdX
         DRxYY1mFsPb8F7APdEa5nhbcajElqIRnC1ZBFaCldmHYj3mkpx7wBpi51U7ZbzjGSYaU
         X2g0sW1jnktM5S2QNlq/UijGVhST/7MChVbVv9oR/Jp20VosNCek80lxtUqOGzbapkO/
         CK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144926; x=1790749726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7/fcB7RWsYoduiGVrXMcsoy9SKXwqPZ/B+Usu82ABAo=;
        b=oeRvX2G9ZWPyqI1hJCjNH9O6iOyJr0xJy/ZYkfGO7xpZ2jOx7rrnLFrCxwpK7AWVDZ
         /ovUJOIkgNRjrCPCpCBgFrZgpwJwaTpmQ0x/B2eF5xis0KoUsLmh6zuYsTqvP7+IQYVd
         FbIoMOBL7ZWQrkIPLSaqgeUWP1/FxZ7n6IY+lcfBUCtG8+xruQYNY7lwZzcBBx3wO1fa
         aXZzOYWANW5a4IzmeEpv6jM+EIEVSYjy3tVu/O6gXx35QeJgJFYgow1Ji3p/SXCqc851
         8LoDlwV562lpQYvXxTGYIUrFtDwCHvUnYd4skZq9A1XgoXDqHsZqlsGb/W5S6C4Ij2I/
         fwyA==
X-Forwarded-Encrypted: i=1; AKwUvBxggAyrLN0NfF80aLutjQrfa4WZOxO+GZ+Y/AlrFpqaYsJJD0ids2NsU+VMlYFxV0el6PJEMToLTA==@kvack.org
X-Gm-Message-State: AFuF++kihLxm7CYl8ZFtBQ65lk1atsqbVDJUnVP0YqbbXvCM/eCHJFc/
	1aVZvK7mqu/8W0DmHl2+4d5xSFtgd2c5u82BdMND1Np3TdQgbCJ+z8b/
X-Gm-Gg: AYBFou3R4DiEbZcdcwgyvulXwCyHu6xgqJHO2zMdpnjNpJ0wuiju+PWDaxxsYmU9viW
	+wj0CPGyh8Vz/vp8JwB9gUVHKuLIhefLOeUZUeX4iGM3dZGPUqXXw5UXA96I8LLs+9IFP5En/pr
	bvvg9XKbj4OdYdnCdMfJWW1Jvh8ZI+Q6wKwXdPPObGzdxLAYUM9EMg5mTsRrxgc2SLSTjBC02wE
	bX0Bb0afBSdMgyAkSnxl6Qds4zBinQYZc/T0Ut/k7Jdl8Gr5V50PQQ7XmIbfF7pOVbaH8jltbFM
	p+W+TzQRLydq6PghlCNfMlxi9DbYvXkdAzCh7zvqATPSNCmelYJjOX/il6K2ttL1tEHoaNE/0Y1
	y4I0t83hhX5l+/wUC2HpgyBH36cxiRmC8QY3bWk6wwSfkNoHBctDJiHnOAPBryP+9p9ea7vJX4c
	nhE8WIxjLWdK0pDGTff7j3xyHlBjc60OaSXlOctSzr5vsUnRZhXDwDd5igKqDeL2jgMz7GaXcnq
	22/FwlZfU3uLpiQFXmb9Q==
X-Received: by 2002:a17:902:d2c2:b0:2dd:c0ff:e724 with SMTP id d9443c01a7336-2df69de446amr13040735ad.54.1790144926198;
        Tue, 22 Sep 2026 23:28:46 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:28:45 -0700 (PDT)
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
Subject: [PATCH v9 01/10] arm64/mm: add pte_set_huge() and pte_clear_huge()
Date: Wed, 23 Sep 2026 14:28:23 +0800
Message-Id: <20260923062832.479455-2-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8okjw1wewo7q9bbfg7r11yimbzxqwmfq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6042D1C0004
X-HE-Tag: 1790144927-835834
X-HE-Meta: U2FsdGVkX18nfaue/ay5475RJ21F0CtGUktJV6OSPJ4aqpDZ40SEcNiOLMK3HoQutPV+ueeiGwPxmHrrojYjQmfl+hBpSGWy0P8fe/ePxWucWrQfOmCXQx8jreqRrZe+IvL/wxVOd9NoLm7oGm58gpDt0bu2JajVJFnkcEncA8mFpnsWJT+oi7tYAhHY/I+iiuW9ycTMoe1ziNRoucgFR8K3kMFIX+EuJNyyz5E55rRIGRFos9COU6X3iBwl38shPsAx5RiuzeLEw09XLTggRafnpUMhcRL8E+xtDnAtyfak9agafdbebGY8dCEG2QOrYrG1sv9oNrFYb0lgroPBYKloOBUPXu9ZjcdooA0nUxn3u09hXDttKGVTMstfd5W+qZfhQiLg7x0XxvJEORrO0pJgvVInTcRT+n8IWM21PV4zsirZSw28Y7a7OEfcfqOEza9OYFkeS818wI6OzQP6wz86DaneDH6d8+XI1SYG6n0U8/onczju3ZlM9OPWN9oPXP2KvMgiOxB2bBp3QK290Unu9vqDGy3pbFFIk44ZVcx+r8TV8D4muQNNmhnF7qZCF+hyw5I8ebMrRE53eySYRZ3zXJeDFj1dJhw145dWbqTBO/T2amPEnaKDbe+gqh7n0A1x5YpHEoW8M+fDvg50Fg8F0WYFOoY4HtDyzWz5E2GvHMwfKbSfur2HsStVGAynR4FvgIixegq/rf6efxgBRR8f0crrAh6hbqHRjvMpk4n/YxGLIh8PMLb+CpAMon2mk2XlIVHRwZAqkFKyXHRn36Wli0dKNn4lEr3dB21DJ+OBl257oAhRBa9Xvq87o7jArVxhmZ6hoJKQYV1+9GN8Z6sdUt2UpWRRCmzSxDqa3VBHubHd4g/Xe8RhtBFjRstUuNxYbTK8UyF9VFLNBqOBODOSXpaEoz1Z+s3ULdFKzjens+klavJJGaDsnx5eRSiUWIyRbWTDd/xG9O+mvyW
 +2Ivc/fh
 mnOir9yXnvfTicsr3SGloylXDT5rez8k4Y6aiIQzxCqvY/CBCn11FzLacpl61aD7SvPoTMXhRXNFp2rhmkUqUnWXtR/9UW0/XE6nUG7oGbVeN6+MU6f7FtY8398u/gkhxa7ld2Lr8jhoclgmyJlfnGsVLfgTtWX9lpj2F0b84CjhNV9ASdS8X4UY2qyV6yM3r/TaY+/gB6ETflaoqLRDnp+LLYn1jZCU55JuBWrISDczNG73nfbbMoY0PW2jybqsmHzyow1wy12D4Vc3hhFsPOHIZqfeWBgAlRbHmHQUe3n6JDCkvRK4Y4PK51+Y6HlAgFCxT9nPycvid9T0rVNBsF444uC4ayRh5AK7qPi7GMSIuHSq6fpj4DoCSszjfl78kZM+ZAycp1RBEdcWf5SCy8UmU1mlrDfZffaKNp0R5DJWz95HnS3tVa7YDMiY6btjb9ZBaK5b+vNKkRvpcglClfA0PieAzvu5ndkIJpTeNDZxDZNE4utzqSNdqCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
unavailable on CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to
HugeTLB internals it does not otherwise need.

Add pte_set_huge()/pte_clear_huge() to arm64, joining the existing
pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
__set_ptes() and __get_and_clear_full_ptes() directly, so they do not
depend on CONFIG_HUGETLB_PAGE.

There is no caller yet: mm/vmalloc.c is converted later in this series,
once the generic fallbacks are in place.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
---
 arch/arm64/include/asm/pgtable.h |  6 ++++++
 arch/arm64/mm/mmu.c              | 20 ++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6000905a2e865..9b762eb68cff0 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1978,6 +1978,12 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
+#define __HAVE_ARCH_PTE_SET_HUGE
+void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size);
+#define __HAVE_ARCH_PTE_CLEAR_HUGE
+pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size);
+
 #endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_PGTABLE_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5dc..4a3d084bb7556 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1912,6 +1912,26 @@ int pmd_clear_huge(pmd_t *pmdp)
 	return 1;
 }
 
+void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size)
+{
+	unsigned long pfn = __phys_to_pfn(phys);
+	pte_t pte = pte_mkcont(pfn_pte(pfn, prot));
+	unsigned int nr = size >> PAGE_SHIFT;
+
+	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
+
+	__set_ptes(&init_mm, addr, ptep, pte, nr);
+}
+
+pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
+{
+	return __get_and_clear_full_ptes(&init_mm, addr, ptep,
+					 size >> PAGE_SHIFT, 0);
+}
+
 int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
 	pte_t *table;
-- 
2.34.1


