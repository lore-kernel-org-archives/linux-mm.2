Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFBF606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=K2pVTn/f
Received: by kanga.kvack.org (Postfix)
	id 90DD96B05B3; Wed, 11 Nov 2026 06:08:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5056B05B4; Wed, 11 Nov 2026 06:08:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FAFD6B05B5; Wed, 11 Nov 2026 06:08:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6161F6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:08:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3FE116028F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:27 +0000 (UTC)
X-FDA: 85422564654.21.EAFEAAF
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A69C2000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="K2pVTn/f";
	spf=pass (imf03.hostedemail.com: domain of 3qEz0agoKCHEkSdccTUdgiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--vdonnefort.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3qEz0agoKCHEkSdccTUdgiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395306;
	b=0tqN565cPpbsZAEa6eRVV1eW4HVDBJFE3SmVphv4fGYfcqbGdcE3KFqDZKxpDYiaClfw5o
	sbU6Dl09YcWenVrhiD21phevT0iWeF0gax7KTrExKp6KT+1ZbbMCcxQFS00xmrwHNvQVIr
	jv3vS5WIe1s3K2DFBMu/wXNPf0dn+NY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="K2pVTn/f";
	spf=pass (imf03.hostedemail.com: domain of 3qEz0agoKCHEkSdccTUdgiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--vdonnefort.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3qEz0agoKCHEkSdccTUdgiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pd2LkXH74KyjkxP8lUXKvl1JOnJh/9hivuqWG2OIXns=;
	b=MhsjnVwHakPEnby/o9N0Yc3h/n+yi4GRjGuerGRtY6sdI3799hKN4SeJytNU5e3x0r/J02
	AV5ulZ9Nlep2bsUQ1mdFMrmBhGmeQd7nk98LFVkaa/OtbXQgyV2hcSar4G4tGbP9cmlOsH
	hdQm/7t+uc/l9tqsJ5qcSNrPSrvTTUw=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49febef74e3so20062725e9.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794395305; x=1795000105; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pd2LkXH74KyjkxP8lUXKvl1JOnJh/9hivuqWG2OIXns=;
        b=K2pVTn/fCvskeUdXMJZSVqBAe17aPWFU6dI4ezaiZDfPg0lXGFLT8LPOU1TBGfBPsv
         uBkWT3ACJhAvLXsPrwH/9byxoYsDsiGeEGF3wd9AIGLEqn1J7CQUoMm4Spc4S4Buf7OY
         qdsQXSAW5UD9moWGRLEexji+MThcMFwCSlJ2Rmrx8cm1Hrno8Cfc/2/x0uSabqo/bo58
         VuueJBh6Wd2BoI6Wtc4MJ9BVXvzm98uU9yuHyPTpYdEFtTbebqoztiT/QxSthFXCEGnP
         erVgOlwBDS+aIi2UR0xoADZJ7FHUt2dUu3jwPAVQ0dQ4rTXBa+nyQ+ML3qGGlFAKPY8T
         jAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395305; x=1795000105;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pd2LkXH74KyjkxP8lUXKvl1JOnJh/9hivuqWG2OIXns=;
        b=avt2tQIatkZRi8h6rdE6P/HQNAcDjbs6mg3GmvYxgJlvFrTCrTYt+GaKS88222Wp+w
         pq2bW0yFPBlY3vSUkAUXZBzHPluqAIlTzHe6XjgXiVY6P5JB8BVYSK2YzU2qXuEuUJyP
         w4ILYBNXOcUPZU7XPCtrIfsEVbxABqFGq2SOhj+RxN5nfVn8XBlwfLs+fEJXDtoai9gU
         0wLEUC0O4IqhbuDiQZAdY8ZcmLuMCz7Qx99b7WbayCDwEM6H8DkrxUoU4lXInVg4qXzc
         WrvG77B0/QsYdGkWu2Q2Bx22we7+8xMNNRnQ0dQvjoJB8Yhn/7kZO08n7IEIebteWpKx
         +bQg==
X-Forwarded-Encrypted: i=1; AL+hErF4chg/kSVhG8SfG8g8h0UIwwKo0Y/cNNiPoHnz4OG/bOf+J4kslTSJ3l8ws8AcBrGIcXiZulx3Dw==@kvack.org
X-Gm-Message-State: APuU4Z8WWAVdsO2XdPJbpjdYg3FcO7CP47C0UeucX+FXG+Lx1D16O6/l
	Q1fMEAsNsufGpBnGwOYrNjmq8+8kcYQ63vdBNqWBHoOQI3YePOOkOOqdGJohhCGxC62qpcCp80u
	QvqTv+26DuNrP8y0qOWN+YQ==
X-Received: from wman16.prod.google.com ([2002:a05:600c:6c50:b0:4a1:e44e:ffd0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c08b:b0:4ba:4928:8aec with SMTP id 5b1f17b1804b1-4ba49288bdemr21813875e9.9.1794395304668;
 Wed, 11 Nov 2026 03:08:24 -0800 (PST)
Date: Wed, 11 Nov 2026 11:07:32 +0000
In-Reply-To: <20261111110738.872947-1-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111110738.872947-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111110738.872947-3-vdonnefort@google.com>
Subject: [PATCH v3 2/8] arm64: Add support for MEMBLOCK_PTEMAP
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
	ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9hqitmu38wig7mo4n98i1tzyu8ntmt67
X-Rspamd-Queue-Id: 2A69C2000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794395306-764464
X-HE-Meta: U2FsdGVkX18rxECGbGXBzfiOHCifh4hwpTaEnecSIe0Zoad61dx/S/MXRGMW9yX9QthSSvpzPxED7mBwi7oY+jDnGj8CqCco0gbsYAb+16ktYyrujiKr+xbLVfuvWU/g0r3YPnrx6Ppaurx+A1ejgCMXAZHoJsXO8HlX1V3ub7sULP5kZZXl/IJBsc7I0od5Dz3P+Ig8fZ1rLTGfGb3jLiFBANF3EB4v4PYqutLJ5igdHHQELdTXyq9VF2CSrzTGM5kK0BvDpYz3hwfqS37dQ4EmGYU2Xrnn/DeM4Bm6iV5blirwUo34m7QFbOK2cwqGbGOfwcJdFos1wcI02OmqV5VnlYwh7D8O3LHaHEzl7d+z/6bXr0rdGHpdfFIU5ottnAI3tlLsYn/04jpGl+r+mKDdpiSW0vHm60XyVQ77DDafbNUHi3NGILyyux9vwrloV9AKDzmOYG/bwJdE9r4KTDPJnsbAHoWMszAH4UZJcwzAFowmw168j8v6U4onrTecQHr508bOMr6irX+YLcUW5CkjKfPgoc7htb9g8/XTtI3kS3F6JRGPnFyzvXVPiahit5VCkuFK6Z1Wugg39mJFXg6bkngae6LZlJ/wIOZT6Zswfher4ozWgfNM48hvxZ1lkiw6NtRcg62ZC6iFEuiug+DRks+IGah4Hrh8Q6mWX6phb1z5+BJJQ1IAaEm61KWOVM0ZupDfErOfcxsqKEUiteV4VnpIpCpRjcNDZul2NiGHPUfNLnb8IyEJf0o5Exdg6QNaMAKXefVgiXW+GSWdMkSmjIpCuQpllgkX5XPeuHJY+IvzLA1Yxuzgj5E3RIb+niwQfL+Fj13BEQrhLJ7rSrnRXU2NDIAKysmhV/Fjh502gZmcS3utOrJjJl3UCavu7oP6YXInP/PWm+wrJsrui7Zdjp3f3vB2hydny03uG/dm+GuVFtq55FNgNX20TnWR4t/i1oqeG7bmUy+yXkj
 NbjRFi0g
 J15tY7Mejup16h0uyRtVN7CYaBwTDqgH1VbK17B+Ghp2Xm9XEqbEImd+s2DoJWqYZtjEco2jVwkHN8NYxdBiCZ2PsEBqM7d1v4Xwg61FPIDKF3C2sQHOmhwfE3uXyKcmESdNZOp6IlYfW3zWHho3/VRrlnmFh8db6SvKEJ6udVPHSPBYfKJDhZzgKJaoq/dgCyDu7EU50WOCwRbvUW1a+EmIUOyv5AMAw+EqP2psQ4eg3uFHKu2o8AZoEl7IoT0SQdYQZJLukLNF9dNIZILhmAnBo68s1JPo/h9lTb4lO+VlciYltPHShOTLD3eFITvH4l6nCrJ3Hfki3oI32H9D6jt9lo/cdojePkhVl9ruI6fKOtzfs8La1onwylRfWW44fIrqo1IJOZld6QNiFAjfpM2sD+11RY02dM8c7knkfGVgTnEQ6QP5HMC98gdNMaHgMyLFSDalDajr6jhUQePaWBnjh2BXjNsEdtvLSQf1S1/19M12NI04SvU9J1PapprL+xSh/EKWsB+lW+enJVUxDaudW6jBoKE6ouu/vep9WOUh+/diXLhm2o+qW5z7M1zfaTUMCb035z62Q4J3AV//DKhfsBDM9ET6NmTcH//4afAKfbWphYEuhwscyy/tAeV0GsfxiFf+RWVEi9olrgcj/ruN0obLiHEcZbT8ROYTov09pyh2Amq8XbGUdmfpEFyHs30wkKoLjjRHmgWwP1v90Pn+zqUsbriAfhzbo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With the MEMBLOCK_PTEMAP flag, force a PTE-level mapping. This also
disables contiguous PTEs to make sure any page from the memblock can be
safely unmapped from the linear map.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/mm/mmu.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 140520b351e2..a4cafafa1d82 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1184,9 +1184,8 @@ static void __init map_mem(void)
 	phys_addr_t init_begin = __pa_symbol(__init_begin);
 	phys_addr_t init_end = __pa_symbol(__init_end);
 	phys_addr_t kernel_end = __pa_symbol(__bss_stop);
-	phys_addr_t start, end;
 	int flags = NO_EXEC_MAPPINGS;
-	u64 i;
+	struct memblock_region *r;
 
 	/*
 	 * Setting hierarchical PXNTable attributes on table entries covering
@@ -1226,9 +1225,14 @@ static void __init map_mem(void)
 		       flags);
 
 	/* map all the memory banks */
-	for_each_mem_range(i, &start, &end) {
+	for_each_mem_region(r) {
+		phys_addr_t start, end;
+		int rflags = flags;
+
+		if (memblock_is_nomap(r))
+			continue;
 		/*
-		 * for_each_mem_range may return sub-page-aligned boundaries
+		 * for_each_mem_region may return sub-page-aligned boundaries
 		 * after memblock_mark_nomap() splits regions at byte precision.
 		 * __create_pgd_mapping_locked aligns phys down to PAGE_MASK,
 		 * which could accidentally map no-map memory on the boundary.
@@ -1237,17 +1241,21 @@ static void __init map_mem(void)
 		 * regions. The cost is at most one page of unmapped gap at
 		 * each boundary.
 		 */
-		start = PAGE_ALIGN(start);
-		end = end & PAGE_MASK;
+		start = PAGE_ALIGN(r->base);
+		end = (r->base + r->size) & PAGE_MASK;
 		if (start >= end)
 			continue;
+
+		if (memblock_is_ptemap(r))
+			rflags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
+
 		/*
 		 * The linear map must allow allocation tags reading/writing
 		 * if MTE is present. Otherwise, it has the same attributes as
 		 * PAGE_KERNEL.
 		 */
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
-			       flags);
+			       rflags);
 	}
 }
 
-- 
2.56.0.542.g3ef89b7020-goog


