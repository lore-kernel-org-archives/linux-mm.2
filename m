Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7F41099B43
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F486B01A2; Fri, 20 Mar 2026 15:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63FA76B01A4; Fri, 20 Mar 2026 15:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B926B01A5; Fri, 20 Mar 2026 15:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3027E6B01A2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECBA013A8D4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:33 +0000 (UTC)
X-FDA: 84567455826.29.A5FCF8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5312920010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vAwxzBvk;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQU6YyVXPfQPzB82gPnob5DtpDKG7VKTASIF2S6ms6A=;
	b=Zpn6pLlHVgqd0Ckh+2YwqriLPJ1gVHmYhg4gaI3W1EEz3WauOe2+irU1XZ5Cr8GzCu4rND
	XRqLcYqD5yiMdxdsuEBIsTzC7uU8ROcRwVd4RV/KUoIzQeCIL3nam4q3cFgtS5NFteO69Z
	PQe4NiKbE9Fnx6wu8ujhPiTvPhMO+vA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035572; a=rsa-sha256;
	cv=none;
	b=VPvdqBoUs5iD9Twi6uQovf0hXhB0HRBGg94TogqrRA+syIdhwNT12DdS0himDn7RzNGG3t
	GG2B3SOx+T/Q7q3tspcrzCCvAe9iNpFZsMLuF0BRmogNuBMYYSC3o16dIehYDKeDxkMlOs
	WJfm+P+tVgll9lUp+sWujBGteWWvD94=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vAwxzBvk;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A62A560145;
	Fri, 20 Mar 2026 19:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70A3C2BCB0;
	Fri, 20 Mar 2026 19:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035571;
	bh=iW8PyaQGY3GlJfRuD9IYEogcwxKab0EzWBI+zvgE1Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAwxzBvkn0PDDQdIMJjA3kM9WwNqMqvqcP/J1sa7H33MhBf29nqPX0POpKAi6uUiC
	 k7Nnh3gGcOt7WSsX2qDhXvI8T6i4Aep89h+tZMAdiai+sk75Wp7ejlJtaOW/HWNsF5
	 7gESjOmyzzOp2WbZ3Y4IbG/FsefBuko8nq9VtgxXPJDUqZsWLpvXaVty16hltae7cZ
	 nXHC3d/Jfp3RTMocPaHcxgrtme6xOqYFdK+ANYBwoPPDitvFhxmMrjufW1iyJ6Ohto
	 FztcPcOvruBSZ1U2g5aQhkjWOMTDKFqO/N8I3UMyQgvUyWFNvhMnDV/Bwq8EO0r98y
	 oesaEOzggNQ7g==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v4 20/25] tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()
Date: Fri, 20 Mar 2026 19:38:37 +0000
Message-ID: <f5da681d3c33039dd4a838188385796eb8d58373.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5312920010
X-Stat-Signature: fn3oxzhq5wigya63k5m6bg8u655xbw58
X-Rspam-User: 
X-HE-Tag: 1774035572-635354
X-HE-Meta: U2FsdGVkX18DdAaNFLW+mBSqk/sRllMuR9D0Sayui5mO4TJD2MktcR/yfv3YlgMtseQgXwwLe7WNPcTF9YDQGSRNf3VsZRd6E/K3ZMuPhllt2ZGvios07bM+PANAUb8LEA/yZQy9iO5pdPmMyqfnMWBFpO6ZoWFZVF1lkW6GKFvCOZ9ekjhMm33Mnv9ScyWAUvlIlMnjnPFFsdI/RAlInyVm8gUaMxd75IDdAe41qRa0ed+lmhWTUDBtgUeIpmRl5wW7/dMKf1d8HxU8k40VT89YaXXOm7Btk0jVfk3QkvOmpOCNDE9Hz+a7HPj7DehQPtfS9XLmYbpBVCUX3xqVc/3vIFOjaAYPtgHoJZH+J1k7CIkRwvOetcJWpC1XY6wEB+u9AkUJ/DlelPvkcZKzmjEVqv5sXumo/ghZX71IFQj0VZL/d/P0ruuirq3gDxJpsL00Uj1PUD5tgkwnD3R3zzlO+hMCDsXP7tEvYyiikC1/v3F+MZKkdnRGPCgO8qRDDprTM+s7xuGvcEQt/W4i8GLQFKhmGeKMCc8whLw8DQVTOBkfgkUOgIFAwsWRPJMJIIOkf+R3Uf51B6WJjlYMo+wezQmzwFxjT1evXnculPIUnO2G2ENWtzhESYpKhTOIp3vI6+GeTmtTATNv0UvD4qWNtG4x5UjXYQa5m7TkY5yo/RQjAuemRYDVI6OTVmN344Z6cdI/y/DbiE9AEdbdcF5CQq29dQ84DxLc0I5xWIiXzQSX6U/JXTqpF29hPVy4wqTJJ3suQeBkVT2wWhcIvmOlEBe5LOYQlE09+Q+PPklSRFunvCzewHRzvTVl8MqLHkWOCuBVTNMAtGTfuZp/EbNJgAsY1eVo0Zry+Opt/NZMzQYq24dDXv4M26A0SqiiwgUU/KwVCEIPBMthjd+aP0U/kW/7GwjVPp4IXDaaCdqb+tfYK3gsThs58EC8f755hL2BG6yUG5DwQbrWVte
 eODVtB5O
 fayPd439IOTExu9dsvZa56CeI+1VhTVCgNZ9v5AWLS2nHxtZWlv60jqkyVDdJSoBv+71iL1A2Ajla9/sUXpYTfF/ws7rtCHjzZ/5uSHrTSE4XwmiRNEjeE7Nz2MUUn8fmxQsdGMEjz4UWCyv4bogRCnDZ7SdkZ9VxkFG12oRq/98NgIuOO6Gwzh3YffEIlRPS9BL3qRgp32svBQ9ns6SqgQLguA3FEYGBUR13c3Hjde4+1kguF4MgWjUjpQn0oI07t8Q9ebl7KdAb3yur81IdC1D9+/ElbQfxl20/sOkPWhOLjryM6hlMwoN13kT+PuuPa2Tusw27bpx+J8ppio08oIE0aWclGFiAFzsw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tests have existing flag clearing logic, so simply expand this to use
the new VMA-specific flag clearing helpers.

Also correct some trivial formatting issue in a macro define.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index c73c3a565f1d..754a2da06321 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -347,19 +347,20 @@ static bool test_vma_flags_clear(void)
 					, 64
 #endif
 		);
-	struct vm_area_struct vma;
-	struct vm_area_desc desc;
-
-	vma.flags = flags;
-	desc.vma_flags = flags;
+	struct vm_area_struct vma = {
+		.flags = flags,
+	};
+	struct vm_area_desc desc = {
+		.vma_flags = flags,
+	};
 
 	/* Cursory check of _mask() variant, as the helper macros imply. */
 	vma_flags_clear_mask(&flags, mask);
-	vma_flags_clear_mask(&vma.flags, mask);
+	vma_clear_flags_mask(&vma, mask);
 	vma_desc_clear_flags_mask(&desc, mask);
 #if NUM_VMA_FLAG_BITS > 64
 	ASSERT_FALSE(vma_flags_test_any(&flags, VMA_EXEC_BIT, 64));
-	ASSERT_FALSE(vma_flags_test_any(&vma.flags, VMA_EXEC_BIT, 64));
+	ASSERT_FALSE(vma_test_any(&vma, VMA_EXEC_BIT, 64));
 	ASSERT_FALSE(vma_desc_test_any(&desc, VMA_EXEC_BIT, 64));
 	/* Reset. */
 	vma_flags_set(&flags, VMA_EXEC_BIT, 64);
@@ -371,15 +372,15 @@ static bool test_vma_flags_clear(void)
 	 * Clear the flags and assert clear worked, then reset flags back to
 	 * include specified flags.
 	 */
-#define do_test_and_reset(...)					\
-	vma_flags_clear(&flags, __VA_ARGS__);			\
-	vma_flags_clear(&vma.flags, __VA_ARGS__);		\
-	vma_desc_clear_flags(&desc, __VA_ARGS__);		\
-	ASSERT_FALSE(vma_flags_test_any(&flags, __VA_ARGS__));	\
-	ASSERT_FALSE(vma_flags_test_any(&vma.flags, __VA_ARGS__));	\
-	ASSERT_FALSE(vma_desc_test_any(&desc, __VA_ARGS__));	\
-	vma_flags_set(&flags, __VA_ARGS__);			\
-	vma_set_flags(&vma, __VA_ARGS__);			\
+#define do_test_and_reset(...)						\
+	vma_flags_clear(&flags, __VA_ARGS__);				\
+	vma_clear_flags(&vma, __VA_ARGS__);				\
+	vma_desc_clear_flags(&desc, __VA_ARGS__);			\
+	ASSERT_FALSE(vma_flags_test_any(&flags, __VA_ARGS__));		\
+	ASSERT_FALSE(vma_test_any(&vma, __VA_ARGS__));			\
+	ASSERT_FALSE(vma_desc_test_any(&desc, __VA_ARGS__));		\
+	vma_flags_set(&flags, __VA_ARGS__);				\
+	vma_set_flags(&vma, __VA_ARGS__);				\
 	vma_desc_set_flags(&desc, __VA_ARGS__)
 
 	/* Single flags. */
-- 
2.53.0


