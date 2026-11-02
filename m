Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72FB606B1C8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Jdw9tJn2
Received: by kanga.kvack.org (Postfix)
	id 3D07D6B0656; Mon,  2 Nov 2026 10:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357926B0657; Mon,  2 Nov 2026 10:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD4A6B0658; Mon,  2 Nov 2026 10:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5C346B0656
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8173812017E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:25 +0000 (UTC)
X-FDA: 85390583250.19.890649B
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id C48851C0011
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Jdw9tJn2;
	spf=pass (imf21.hostedemail.com: domain of 3Mq7oagcKCI8E1816B0z77z4x.v75416DG-553Etv3.7Az@flex--vipinsh.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3Mq7oagcKCI8E1816B0z77z4x.v75416DG-553Etv3.7Az@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633843;
	b=SE9YEAgWc2NyC0GcxLeTb1HBF/hS97hyg1NAMpv2+zGLF0IuZcJDQGEtUEirN2p0U9Kdyb
	mNO2596OGmvuRpNM67JSva+dbrzYxwG4AnsLDXcZwvtxHmtV2M1QbD70TnGJn+gkBMAWpW
	Wm0vbeSAN2xyY8J2yRxGayIJ0JLCAho=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Jdw9tJn2;
	spf=pass (imf21.hostedemail.com: domain of 3Mq7oagcKCI8E1816B0z77z4x.v75416DG-553Etv3.7Az@flex--vipinsh.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3Mq7oagcKCI8E1816B0z77z4x.v75416DG-553Etv3.7Az@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Pjs45S57+QYe3zCfvXOSLki7qU0AqGmneDsSzoE048=;
	b=XlcgHXuHnZ8NvqeGl3brhmmVTDnYQkLmF4H6p8OwLtMKMY5oZAd+k5B+WmxZ2gU3CxG8w5
	HUCBvkEAy8q1QDjDoTvyfaOnKR58ytjgkWBab+qph4SID0hQW9p5tK3DrgUvvGriw5GOTB
	jE7neUy9wDrniFhz+sXOOXKw6s9YslY=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso3599076a12.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633843; x=1794238643; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Pjs45S57+QYe3zCfvXOSLki7qU0AqGmneDsSzoE048=;
        b=Jdw9tJn2Fy3VGSB180ui5Jp41WG9s8Aih+WjYBkJmrSYu4vnS4sptmBzCpOsHDF73h
         Khdb924Qlhu0F2T2s4OebO4PMVzCCZ66e8DN44tMMCJEYH7uQrHooeTwubGJoJTlQPwq
         MJP3SBj2u7MGeFcek5t4AYJinqR+IAxULxAVhYjHoi1eWL201oRcObXgsmgrHowN2Ywn
         4Lv8+DYEsrpzKsk4cq9y2WWk3G1xKH1px7VDbx6nNzeCJc+wvCNcDByU4qvY8fS8Sb6W
         FHLLXBDVqMQZdrTQuxjeNzhYdejrUv/XAJFqL/ZCO6vccxdZAremmbRffZoe5MEaU5TX
         5FKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633843; x=1794238643;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Pjs45S57+QYe3zCfvXOSLki7qU0AqGmneDsSzoE048=;
        b=PdM4XHqqTbd4k6bTpbJ65GqtBu+ifqQOurzEqBd58qQ//fqVXxvewNGQTnkHGZS0X6
         /h5OagMJn9ytHLL/3BuUW95PLAXK1/sgk6/TjdM4RXuElq5kF8C0kPpzqdvqkaRd3+57
         yQOZuZhxv/0aWK3jbHR9zSUzdmpazKtYBgYFkvhE7qeYpXPMjxwKnh6SDYQZ29o+c76y
         Hml/sdXwPjpIjyd2XlmfERl0pBniLVgddfta5o7Nwpi1WMpJE/8fK6nVKw6xIfAO8kQd
         7SEVnqU1yTgqPBdOZjNU1325bSUBAbjKme3r+uhc9xD1u1ZqtvoW1LKW5LSeMhkI5fIt
         480Q==
X-Forwarded-Encrypted: i=1; AKwUvBwER+ecRrXrjtmEBjia104Pad2NrCUd5kFHUijoJ4hFuyIe0a+Sgp3xpAQRxlRbnzz6FXCe7rEbEg==@kvack.org
X-Gm-Message-State: AFq9FYJ0NRXArO7BX5MdOEv6V1qZBnj5elgrjTOeOTqIvo9rYxmWBfpF
	+BxPXfeRDsJku+JdYbdNEAS26O0XjTkchsEomKhVfOVeVp1lK61g3WVaxKePDFDRUcNr1rr5MpJ
	GKVeXvTQpHw==
X-Received: from pgia4.prod.google.com ([2002:a63:e404:0:b0:cc7:865b:2dc5])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4cc1:b0:3e2:778e:3cdd
 with SMTP id adf61e73a8af0-3e9289abb68mr8817317637.37.1793633842371; Mon, 02
 Nov 2026 07:37:22 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:50 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-22-vipinsh@google.com>
Subject: [PATCH v6 21/27] vfio: selftests: Add helpers to map DMA memory at
 IOVA == PA in noiommu mode
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: C48851C0011
X-Stat-Signature: bhxg9fz57t47zm6cgm4njwksztyqeysu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633843-997432
X-HE-Meta: U2FsdGVkX19PHLt51w2s0YNnNSjZVMRZyjRmL3KxQ4mRkMVY45YnHYjyOZpTuqKFzmRXPN8+5hu2lEcQmTSsUUlA9xmvAs43fdPJf3BAZfttp/HGMYVIh9RdEzqeTanDayUyUR1I+T+Dxj1joREKw0ZGZPD52YW8kUpBVLS9bnL6gojPJ8Bb8yCbl8x/nnV1F/3URNl03RgbLHe6TS0sW1wulomRQbvLaLQWgEaLaWEddtNsjyhRNSuIHAJ07Qyec2fafnyajQv3DvPWfV9FncDI5AGGyK1f+pVdVfkr1A7up9HVGPald+GJgnZY1YdK7u5Q6DjDxnbwIVNZrfjjv2DIqjA08gC2ABZDOWSsH0p7AX551OxQyiqhIFRCG/Ckx4qbfB98nPTmfrEs7kOxNrZoJrcczaxN3n2rpXuV4oz4JUFpjBGk7R8zf9kalqffN0r73cql+9CUU7aXYQVj2cHjHX912DZaq8FUA/0sdtjqXO7bJLbAtYWlCa0c1M6YyTJRZeNoGOuVykB5fmbCvY6NmNJ2qGXuau6+L/CfP7yFpknH+ZFlo8XTO1cVo2M7YLsThVImrXk1h2eoTNCSVkDC1NilEQBdnR/p8ob0fWGAXifoTJN5a5fgiWo4Pof5Mx1VbIrkyrlJ7gilYVkKNYIbYoNhaY2VwM178uRSp5GrSpFEOhJ85OmdWmZ4uutkmahRssEqeAG+/8fII2yd1ubMFUkGgje+mw8ziSGvOXep8Kh+qCoaP5HPRnL1R5NlyCmSVpTvTeShI+92tkPGrJL47jKLLsTLVLEKSHxilqPyLpex2D4rZLng2rHJwz9wYwf6QvUiBTotIyIGyDzBhuuEMfo/qCY2Je2t4jnyrUjWpZ4bQGOvOgRCgd1X2C9vq+eO5e8532OvF2q9owEY5UPvwZK93o6MtiOdWkA6clYosVWk/0LDmpL+8Sp287yWIgftN9jjtCXo8DeCANG
 fAaqQuyL
 ewCdXoBuBkgH/aNeiRHyWH2nd7+2ePbG1WtcpA9kX31yG6LsEkKelN8eUtUyRnF/fT3x95cxf7950XWjkhiH9y9y/qj50sdc+ojjPxTEtjeVw2rDcOF70LZbzz72yY48qWDx+8/v0CfxMDZbVfB+xv+17w2VCcSXaLiZZxXI8MdSXqyZ9PIKy8FEvz/dKFCcgNgI7z/Jf8lDKVdqO2wfFNwrdOCfPlN8qzDjp5fjdblcaZe3Xb4K2wRR5qnn3sRu80PgTWINETbddS20ZsYj9jojN1pT15by37WRNU3FtwRRdnwlOOEn512l54/u3D/I9PTfOvfy8GVr8LJv8MoEaVK1TkM2E6zGVFk80TAAOV18SMUT0wQytDO7vudO3zliWFxOSjAEEvJ1XyvA4Fq2GWVpMSuQcoA4TabdxzK2+FvBVj2RSH//0WcAdeP46/5WMkhb/t/9I1k2k3sj4fBtmQ94+AwQy7X/20M3g+gL0jhBKe72Q42bUcOl7J1T+f6qeCLu6KnF24dOFSbJ/EN8aVC9QlgfY94LFtlAJcRNHvKD9UEGOBUYaUJi6/NjdzmVUAibB6hAqqxVf3xc7GEo9r6JBw7crPoL4Zjrpkxn5hm08n3otcNGwSH3ilw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Selftest drivers program the IOVA returned by to_iova() into the device.
Because a device in noiommu mode uses those addresses directly as
physical addresses, DMA buffers must be mapped at IOVA == PA so that
to_iova() returns the buffer's physical address without changing the
drivers.

Add __iommu_noiommu_get_pa() to wrap IOMMU_IOAS_NOIOMMU_GET_PA and
iommu_map_identity() to map a physically contiguous buffer at IOVA == PA
by first pinning it at a scratch IOVA (BIT_ULL(52), above the 52-bit
output address space of the noiommu page table), querying its physical
address and contiguity, mapping it at IOVA == PA, and then unmapping the
scratch range while keeping the pages pinned.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../vfio/lib/include/libvfio/iommu.h          | 26 ++++++++
 tools/testing/selftests/vfio/lib/iommu.c      | 61 +++++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
index e652b8caf5bb..d449813f9bc4 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
@@ -65,6 +65,32 @@ static inline void iommu_unmap_all(struct iommu *iommu)
 int __iommu_hva2iova(struct iommu *iommu, void *vaddr, iova_t *iova);
 iova_t iommu_hva2iova(struct iommu *iommu, void *vaddr);
 
+/*
+ * Look up the physical address @iova maps to in the noiommu IOAS of @iommu
+ * (IOMMU_IOAS_NOIOMMU_GET_PA, requires CAP_SYS_RAWIO). On success, *@length is
+ * the number of physically contiguous bytes from *@pa, at most @max_length.
+ */
+int __iommu_noiommu_get_pa(struct iommu *iommu, iova_t iova, u64 max_length,
+			   u64 *pa, u64 *length);
+
+/*
+ * Map @region->size bytes at @region->vaddr at IOVA == PA, and set
+ * @region->iova to that PA. Devices in noiommu mode use the addresses that
+ * drivers program into them, i.e. to_iova(), as physical addresses, which such
+ * a mapping makes right.
+ *
+ * The buffer must be physically contiguous (e.g. a hugepage or a THP), and a
+ * noiommu device must be attached to @iommu already. The memory stays pinned,
+ * and so at the same physical address, until iommu_unmap(@region), which must
+ * not be called before the device stopped accessing it.
+ */
+int __iommu_map_identity(struct iommu *iommu, struct dma_region *region);
+
+static inline void iommu_map_identity(struct iommu *iommu, struct dma_region *region)
+{
+	VFIO_ASSERT_EQ(__iommu_map_identity(iommu, region), 0);
+}
+
 struct iommu_iova_range *iommu_iova_ranges(struct iommu *iommu, u32 *nranges);
 
 #define MODE_VFIO_TYPE1_IOMMU "vfio_type1_iommu"
diff --git a/tools/testing/selftests/vfio/lib/iommu.c b/tools/testing/selftests/vfio/lib/iommu.c
index 0df49646d016..46e9635cbfc5 100644
--- a/tools/testing/selftests/vfio/lib/iommu.c
+++ b/tools/testing/selftests/vfio/lib/iommu.c
@@ -11,6 +11,7 @@
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 
+#include <linux/bits.h>
 #include <linux/limits.h>
 #include <linux/mman.h>
 #include <linux/types.h>
@@ -244,6 +245,66 @@ int __iommu_unmap_all(struct iommu *iommu, u64 *unmapped)
 	return 0;
 }
 
+/*
+ * The noiommu IOAS page table translates to physical addresses of at most 52
+ * bits (drivers/iommu/iommufd/hwpt_noiommu.c), so a mapping at or above this
+ * IOVA never overlaps one at IOVA == PA.
+ */
+#define NOIOMMU_SCRATCH_IOVA	BIT_ULL(52)
+
+int __iommu_noiommu_get_pa(struct iommu *iommu, iova_t iova, u64 max_length,
+			   u64 *pa, u64 *length)
+{
+	struct iommu_ioas_noiommu_get_pa args = {
+		.size = sizeof(args),
+		.ioas_id = iommu->ioas_id,
+		.iova = iova,
+		.length = max_length,
+	};
+
+	if (!iommu->iommufd || !iommu->mode->noiommu)
+		return -EOPNOTSUPP;
+
+	if (ioctl(iommu->iommufd, IOMMU_IOAS_NOIOMMU_GET_PA, &args))
+		return -errno;
+
+	*pa = args.out_phys;
+	*length = args.length;
+	return 0;
+}
+
+int __iommu_map_identity(struct iommu *iommu, struct dma_region *region)
+{
+	struct dma_region scratch = {
+		.vaddr = region->vaddr,
+		.iova = NOIOMMU_SCRATCH_IOVA,
+		.size = region->size,
+	};
+	u64 pa, length;
+	int ret;
+
+	/* Pin the buffer with a scratch mapping to look up its physical address. */
+	ret = __iommu_map(iommu, &scratch);
+	if (ret)
+		return ret;
+
+	ret = __iommu_noiommu_get_pa(iommu, scratch.iova, scratch.size, &pa, &length);
+	if (!ret && length != region->size)
+		ret = -EINVAL;	/* Not physically contiguous. */
+
+	/*
+	 * Map it at IOVA == PA before dropping the scratch mapping, so that it
+	 * stays pinned, and hence at the same physical address, throughout.
+	 */
+	if (!ret) {
+		region->iova = pa;
+		ret = __iommu_map(iommu, region);
+	}
+
+	VFIO_ASSERT_EQ(__iommu_unmap(iommu, &scratch, NULL), 0);
+	return ret;
+}
+
 static struct vfio_info_cap_header *next_cap_hdr(void *buf, u32 bufsz,
 						 u32 *cap_offset)
 {
-- 
2.56.0.317.g454f8302e1-goog


