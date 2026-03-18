Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA3B103E162
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519E66B017E; Wed, 18 Mar 2026 06:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CAA46B0180; Wed, 18 Mar 2026 06:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0AD6B0181; Wed, 18 Mar 2026 06:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEAD6B017E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:59:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1A84140639
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:49 +0000 (UTC)
X-FDA: 84558888498.06.8830698
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B1AF40009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+3CqX8k;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGZdk2yyLanl7/KR21xl7ICRk/hytBhxSsWv14rub9g=;
	b=lCH19rqy3PhnraRZ4acanM1qqL5sEekUramV6/2XSyYKnlMmNrV0jZRlcaD2sHizCsRhte
	uicGasBYm5jOnqgyFeCWqRGFnBMnl9+zb1Dd0Rdu1n2596SUeM1Ghe/U7q+v0vGPIuR5DG
	xTQ6qH9D84fD2Iz+XLeEjoZu1qnIZ6A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+3CqX8k;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831588; a=rsa-sha256;
	cv=none;
	b=uxfaMUXpYtgX8xvEF2LmMEU2+LysHO+oPAFWki/eFriK6RzrAr8vs9WHs1TtQua4H+EFLa
	K33iD19KYAJlo8KFgd2nutqsKdi8dtUxNB98AWOjoBE0LCxELHP5AZ7IG7BJCrsCROqqRr
	Fu/bHwXthZHMedxIpo2UuBEZSBsbX+4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB6816011F;
	Wed, 18 Mar 2026 10:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A1FC2BCC6;
	Wed, 18 Mar 2026 10:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831587;
	bh=zHz96zz0ncBdc90iHfU1esNDP5VS2vFvp/Tz9M9XRk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+3CqX8kLBmNikWLF7a8iVjXMFKms2g5d7cGj+DkSwb7SWZfJl3UUItFy/h005Dyb
	 px8WulbFJMFk9CqcCuNJvWEv/rGujYRCx2LRV//5pAJM9mH2dWdmdTheM2VFzL4fRQ
	 y8jRDky0b5dIJmL2lhrOXQG3ilJYoi1yOuBZKgPG03bS5GPsemT1iu8A5Zn8EVs1k1
	 KORZT0VeE8CibV/qbEteKg8rZeVO6pjmW8j8RmPunYEJIT5qfACmdTvXQzFne51AZG
	 jjNVTjP9AFMX+Ii+jyxIlaK2lRkFLfqVjcg6XRabaz5r85dBmBz4jDrGVKYrPFx+vI
	 1IaEk9XK6tBNA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 6/8] memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
Date: Wed, 18 Mar 2026 12:58:25 +0200
Message-ID: <20260318105827.1358927-7-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5B1AF40009
X-Stat-Signature: boe4ohheurxjyj68cztpo7e7xpsquarq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773831588-456528
X-HE-Meta: U2FsdGVkX18JvIBu97/FcGw+elhWiGDZA2Vc2KswJpBD8Z3avlSDpW728ZHZyPNX5yqVUSoCZDF8nPTuxOkWubgYFaA2dDe9Mk3yFVS6erWNtarYVPiZgE15VEXu2evnEZhbg9If2PiRIAwIHD3gNbrcpSg3jrHG2c/7ST19uUbd9Uj8+4dvIW57udVrwA0yFETjCbIC5pzTGwftuypVUKje41cuYECJ4hK3RB6fEaWYGRqJmRqSGXWMmBqoZ4ATMiVD+l4iEdIhq3tdj1azieTjVLMG7Xyd4IVUS7XHywHBZhkJgxEk7L9RcUa2ZsAJagYu2Nva7MVEJRl4c7Gc8kF7Wb+s0RkSdHZ9/2aRVXQTvgrXG4i5bbDTBkyiKEMYFfzg4WqvMZ6pL6KNF+sZFz+5JWLyjNQ7X2QwJu92Bt9EQgtRFFMuDkbjKspsaRKTUM1JgYJuZQ6oHctoOiKzmbpWzaeBjd6Lj7IjT1NnmTZrbyi0nZV1LAqUEQQI5WRnPsfHWrGiOTZ+oSFvj/4jzYyUGG3ErD7P6LeiPFBvt7Vv5A9bzEhs15J/urQS1NffNH7F9T0OYuZumubDQ+hcgwI5MU5BDN92GA63B7FjmhWLa86wUEIfVf9VrKWTOkrEmuGuzaMv2SGRDYrFPMBQdtyi8sEjFCrpNn7Yz5PVV2Pp31mClcQoxOxRglV9oGGSpmtAfO2oOgJ7VEtZDnTJqZZ+D1eSl9l+E2CmOmBYGdRxUP2mdoF3FGf7jchtipq6Dw5M/zFEDb7Y9AqH8p0re3GfQbLv/r+aTIGJ6h6axjZyTtjIsxeicD8ZFQY/XPoJgDqlB5vY91f8a2B4wJAFKNgirn8rEMJ/bEdBFm3y61BYJcnIUJQySgTuwqLTiPMzhJ3Ldx3CuBYeTkKhJazO1TZ7XXR5KC69TRuM1SjUwj9hd0FB2pDV6qUH95CjTP6qhre0sT+0sgDXJHIWDZ9
 If4HFIrZ
 +fG/nXkrojWJuxYHubB5hSEKCxW47upSz/nn6qa5QfN6PAKfMFXgalk1H+GPZG6KT14FMmFBzP4C69GmWO+Hfy6doAZTiPMq7yHWL4P799ONtJn5jXPt87pcVVzqNGTVjaYdO6c8idmKX8kqHJJCHvgg05ZZtcjLyknhC0euhMX1RzlJ/V8nhVM++4thqliVjd3SKA4LCFBF2j4YzZ6dFqCY1vevDOHDAuzSVcJEqGFFHSD0KNEMMyGH1PNGbOaw+GEuJtSnRoJ7xBlkjvBxudEo9iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

On architectures that keep memblock after boot, freeing of reserved memory
with free_reserved_area() is paired with an update of memblock arrays,
usually by a call to memblock_free().

Make free_reserved_area() directly update memblock.reserved when
ARCH_KEEP_MEMBLOCK is enabled.

Remove the now-redundant explicit memblock_free() call from
arm64::free_initmem() and the #ifdef CONFIG_ARCH_KEEP_MEMBLOCK block
from the generic free_initrd_mem().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/mm/init.c | 3 ---
 init/initramfs.c     | 7 -------
 mm/memblock.c        | 6 ++++++
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 96711b8578fd..07b17c708702 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -385,9 +385,6 @@ void free_initmem(void)
 	WARN_ON(!IS_ALIGNED((unsigned long)lm_init_begin, PAGE_SIZE));
 	WARN_ON(!IS_ALIGNED((unsigned long)lm_init_end, PAGE_SIZE));
 
-	/* Delete __init region from memblock.reserved. */
-	memblock_free(lm_init_begin, lm_init_end - lm_init_begin);
-
 	free_reserved_area(lm_init_begin, lm_init_end,
 			   POISON_FREE_INITMEM, "unused kernel");
 	/*
diff --git a/init/initramfs.c b/init/initramfs.c
index 139baed06589..bca0922b2850 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -652,13 +652,6 @@ void __init reserve_initrd_mem(void)
 
 void __weak __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
-	unsigned long aligned_start = ALIGN_DOWN(start, PAGE_SIZE);
-	unsigned long aligned_end = ALIGN(end, PAGE_SIZE);
-
-	memblock_free((void *)aligned_start, aligned_end - aligned_start);
-#endif
-
 	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
 			"initrd");
 }
diff --git a/mm/memblock.c b/mm/memblock.c
index 87bd200a8cc9..9f372a8e82f7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -942,6 +942,12 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
 		end_pa = __pa(end - 1) + 1;
 	}
 
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
+		if (start_pa < end_pa)
+			memblock_remove_range(&memblock.reserved,
+					      start_pa, end_pa - start_pa);
+	}
+
 	pages = __free_reserved_area(start_pa, end_pa, poison);
 	if (pages && s)
 		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
-- 
2.51.0


