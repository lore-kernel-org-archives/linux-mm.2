Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D16A4C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A30F6B009F; Wed,  2 Sep 2026 06:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42CDD6B00A1; Wed,  2 Sep 2026 06:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CDFC6B00A2; Wed,  2 Sep 2026 06:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 049066B009F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D76480175
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:19 +0000 (UTC)
X-FDA: 85168505478.27.BAC7AE7
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	by imf24.hostedemail.com (Postfix) with ESMTP id EA0EC180005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MNf+OGdW;
	spf=pass (imf24.hostedemail.com: domain of 3pP-XagoKCF8SALKKBCLOQDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--vdonnefort.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3pP-XagoKCF8SALKKBCLOQDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IlzRHwAUXMpKspjrSSJuu5KTpj2eywEkwws+9IOUBiI=;
	b=fAkB4UGSBKJI5rFXK1RAgf+E7TWIQCK5EfLkIsEEm4/BV6EcZA1PaO0glg/YprW7+limLb
	M9bB5jvUmlZ8kqb6rvbfLd09IgdJmyIELa1LTn1pU4qpjFB/r2NKrh2MmrhOo2k/75sKl0
	1T1acUK8DtwpcJ812EKXV3E2KEf0KOc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346277;
	b=409YwGnPhKlBgm7LjL86NoTHFA45h55fI9DrriWYCUKu2Zcitx8zAVatur+FGa4+zGtWvm
	FEVcBJGCTG2tGucyupTzsK7Sz/QkSwpVgbtfJZ4rFfa2fUYcGiYyBaLonINf/QNal72nrp
	FHHOvdGVsB6cpht1vcliPg9IM6xjA7Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MNf+OGdW;
	spf=pass (imf24.hostedemail.com: domain of 3pP-XagoKCF8SALKKBCLOQDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--vdonnefort.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3pP-XagoKCF8SALKKBCLOQDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47f4bff865cso612279f8f.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346276; x=1788951076; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IlzRHwAUXMpKspjrSSJuu5KTpj2eywEkwws+9IOUBiI=;
        b=MNf+OGdWCG5vQ5H4vgaeveRh6UR7BjEJBixzGtdaV2rnSmKLtaAL81gCdSC40MmcWU
         010PBM1rV8agpgMSYg1fpAVUtrR1g1nNEmMApsfp7EhzHpcRtyKWnper5yDkv3sfGjlj
         Bj5bnjBoez8Pg8fevfOmPkqB7uzS64aOAmpoZ+E0SeOgR6gh/Ub1r198VomaFShnAyM3
         JaInfmsa6SGaEuiv7S88hw0/Mf1C69UjRF5GDro49mD7p60OAMkk2fconOd+uvo1reBy
         lipEGZIsWv65hHcpBUNU3ULr2Qw4JRN8WeeZcrSRjBo4j3uRVLAEjAbFpCWnoWUzMxDU
         kTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346276; x=1788951076;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IlzRHwAUXMpKspjrSSJuu5KTpj2eywEkwws+9IOUBiI=;
        b=Wur0RKr02qm5s4Qq7Z7p9SzKZ2b6Oi5GFxA2GUdQ8gqmye+SnhzU6PwvuwHJcNQWeD
         ESMuv/QtFV+NYpe6U8RNrO0RGKGpoKomsYJN7vV2EtekR+sElV2cKA7s8b//RvTA3Qi3
         i+t9vnKaICE9uf6Y1ezGu81DmQWQr0UOJhvkt+gVcWlXnJNExejJoGoruUDQoCeyIq80
         4Hl72Vl+zSQtcbHHzXXSgWAQlHrm89PGIbgxx/07EKmP3BbPdzzc3QpPdfck2kg/Flkq
         EIhLDS2YOqfHr2umVGaXu4434M7g1bkdziK+oiErtYQjqxrRu5qAkuvNcxG8iVKIt6rD
         RpLA==
X-Forwarded-Encrypted: i=1; AKwUvBymJVTexbWVqMeYPzp+iLTpVynYaKX2YEUkUjghS9GL+YkAkOKMTc68Pv8wisxSmDHN9kICIxjMpw==@kvack.org
X-Gm-Message-State: AFuF++lhi68sTEvrZ8iGAFSUOEgCj7YK1AVA1/07Jtf3DX5qXEW5DRDQ
	RENm0VeBORECSox0b6aVlsuOZSSNzj2mKi0TeZu3aFk/cTDTU9AbVBakprpprMyy8G7pN3JWTpO
	1FPycHIIc15DrCGyQuucapg==
X-Received: from wrqr17.prod.google.com ([2002:a5d:4991:0:b0:482:abe4:58a8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f47:0:b0:482:fc30:a1b4 with SMTP id ffacd0b85a97d-48488e03952mr6019121f8f.5.1788346276079;
 Wed, 02 Sep 2026 03:51:16 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:10 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-9-vdonnefort@google.com>
Subject: [PATCH v9 08/10] arm64: Add support for MEMBLOCK_LLMAP
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA0EC180005
X-Stat-Signature: wsnnepfnam7fc4wgf3tkegdizx56gmok
X-HE-Tag: 1788346277-317235
X-HE-Meta: U2FsdGVkX19Gc1WXdDp/q3CjKviNQXS0EVW63hPkqJ4zgAbf16Og5uPcO8y+9N1BRf25SRy184JK77wxu7u42786bIFDW7IbeqdOopOGL7ZWZSipYEifdGLiG7DJ7cIb78F75oUGOmlctKnjUlpNM+0JAmzmctXP/xEofopHcJxAIsGwPg0Dx9FncRXDO11mE0eMNHJbDrCLCHjViyS28pf7CyYeZ8sHNvFekZtzYplDMUXFO8PJHLR9eLbOgegkm1/7ccFQwGoYx6twA8MNLM3kz6QLkpgsSafArUe8cdgFWyFzCHMc+b7oODH5EKoFWFjgMeBIjCsGkxQ0E0iQGqkqGb7XjmIdsrigpsP9lJmc3174OaMFvhjhZGEzYjSimgF8YnkW/2PhYubeFMO8Rd8oOPjx3uO4NfBum90IwTMJNOTctizyR5GfUTQ+a20La1ca6tfDqV0HYIualfvA6Ghyxi7LBYmZBwCj2KGS8AXxRV82sE6Qc0LJShAjGnxqNs61PF01K9Sm5fsQZZS3dm37fUjlwsTESzo3s1E3N6AMbQJQF1rWxAwqL+ojiXJkTlcklnh7+/26Yi8GZQtn5jmJ2uk2OHarEMlHs28twKh13vqfXrIXpb24868OlFU2dgpkK7yrdRtRw8bA6jRUuaPeCBllwgAayunz0tCjTt8SS7lpBC2+XlK23B8khM5D7O0V7IfcMzm2by8r9rFvMXYQFj6B3DZzy2NkyLwKnuH03TcUMNfIF+tJ34hpcMhh0WXhKac9/3OGpesvJ9acckn3qSpcudKsZXHWzhQC+KB2b8XaeJc36SehDPJndqc/fS/8tjl5uz6w5OXqc2BZL3VrV06KAW3sOUo8UbC8hLfzuHohxb6IKv8OlJyYHmgKqdps2mrQQ6Jrg7en2SXDL7RdOMfUl2Hu2qPiLT6gx3aARVMGMsQMbcKYafyme4NunXO+1qpkzzf2DLRYWyy
 CPgFEXPM
 4UuVpYdcbv8WSEpxo6t28k+vdQL55S0M+pW65xIDLjDIZZch6uSMolPMPgIQdUC03xlllwIiUoDIsakRrxPKzlpF628aJf1SV30EHVrM3o5qG711v5HW7AbieN9KikOrm1Nto/a5iLQgvB2LPfcLI/cgU5qhk22siC2zdOFK0wBB+Nv+dzzFtkNv3Vh9pfPy0YQe+cjutaH2u6VmjMpmZS1V7YiPPnOJbCTy7JTN0sLmcTp79Ro9QmNtsyovs+67leEn98MG9skfTk96LaICJfHJZ6VjuLi4qO/A1p6tE397atQ641o3Z0ado9R6ycqMz2gecgiRxxCTk0UTK8WO3ryygG1IkyxQvnIHANLXUZ7Mfjtsl4GXOTSfXztbO7+A5Ibs7cwIgYg+U/pBiF1QcPL71NKSRegRw4ph3DCf/9MakR8DsU6x7HZY2udGAkybwnNdItlKu6to/UbUsR9Z+rPDs11clIkjGTSSm2ihhO9dOwkLAAuSWnluy0gQzE+eqxVy9jA4MRsF449V3ZFyZQ8WEpg1woiZz04vR/OQCdfoevpvyeyyEMoYb6N9bdtOIFTD0xnXfw1WnHTQPnxNK06caA8/2kG+T2V6ruz0E4l+dzl3+1WzcHEdwAkqpCteM0iVTEq3/SqNlbsIExf2m9538Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the MEMBLOCK_LLMAP flag, force a last-level mapping.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5d..c0fcc76914d1 100644
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
@@ -1226,9 +1225,13 @@ static void __init map_mem(void)
 		       flags);
 
 	/* map all the memory banks */
-	for_each_mem_range(i, &start, &end) {
+	for_each_mem_region(r) {
+		phys_addr_t start, end;
+
+		if (memblock_is_nomap(r))
+			continue;
 		/*
-		 * for_each_mem_range may return sub-page-aligned boundaries
+		 * for_each_mem_region may return sub-page-aligned boundaries
 		 * after memblock_mark_nomap() splits regions at byte precision.
 		 * __create_pgd_mapping_locked aligns phys down to PAGE_MASK,
 		 * which could accidentally map no-map memory on the boundary.
@@ -1237,17 +1240,23 @@ static void __init map_mem(void)
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
+		int rflags = flags;
+
+		if (memblock_is_llmap(r))
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
2.55.0.970.g62bdec98f9-goog


