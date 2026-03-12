Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2789B106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5786B009D; Thu, 12 Mar 2026 15:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C746B009E; Thu, 12 Mar 2026 15:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2856B009F; Thu, 12 Mar 2026 15:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA046B009D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:17:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E85E016035D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:03 +0000 (UTC)
X-FDA: 84538368726.01.CF929A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0040410000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMJh0BE1;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwGOZRbwhBdf5acnHMPso1glGeuIqeOOIoOqiLq32Eo=;
	b=VX6cdn4U/5Ir6dA8CKPEIf7TaA2iIxaBomMzMlGbfFaucHn6Wl4oIHhOFSXuDBljtA1Shh
	GScRYk6MOxWJ1wPT4yZEsYf0SngpUSsoT+4s/2Fd4T7Fh2vlNVkESWMHyrtAqkZDEJ8O72
	ADBbXc/IWFWh4IfXz85cnnyozYQxE1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343022; a=rsa-sha256;
	cv=none;
	b=3UA6Z6xehwayUkhwq//Mxz1m7/hOkIFm2jFG3ckK14tnc7EH2g3oE/0hw4LoAnnYe/qlZm
	NRxPG0TmBGIM/Ab0577KaaUWNP8uHISylBMhAWRnGEioAQ/Jum9yGI/Twacv38YvVCwF4n
	4JYY9Kqd6HFDFpk99XnGoGdOotZfurw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMJh0BE1;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F905434DB;
	Thu, 12 Mar 2026 19:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C000C2BC86;
	Thu, 12 Mar 2026 19:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343021;
	bh=YB+Prps3NXNgyZK18AV53Ial+ZlTulYn7HfTP5zg1OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMJh0BE1l4pIrUpBOQOh9D0ec4tGxSzEvRYmthhi119lf9iOWb5fcVzwx49BnIuUB
	 VWRKKNEjlXklZ/MKcv7E9t7zFb59I8aEqvkXuVrDSllPkBxGHpolum72wTTsrJTkiF
	 spDfNyLhWiSKFHWQGTVB1CTVmT2QoazGq+/sClR9wwRC9VCKIplL93es7Lv21glqdQ
	 CZufPhsaTQS2n43UB/AzEjxhUY7DikC3bKimUKGl2QZqa/JNpaabr3g6beHKXS7pyn
	 87i8vn+8SWsQ5SYUtU6mVrSnrjAtpeGs4vonxtw21ga3DSoEIPnbwZPIZ/ZFWaaY+R
	 YnxNze0QQkOUQ==
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
Subject: [PATCH 11/20] mm/vma: introduce [vma_flags,legacy]_to_[legacy,vma_flags]() helpers
Date: Thu, 12 Mar 2026 19:16:09 +0000
Message-ID: <b5c3c0f9a2f4b016bdf032dc959b988f585f0afc.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0040410000E
X-Stat-Signature: rzjq47qdka3swwjhgpeateaxkrjwrear
X-Rspam-User: 
X-HE-Tag: 1773343021-370957
X-HE-Meta: U2FsdGVkX19h5Alcf9wEEECcMuxnBLOLql93yRhAPT3AclmmnML46p4HZs/5pxNCwEcXQwi4PwmaRC1gifQU9oyFmBQLzybhdrntZk+MqFH9atvQIpcizmcGFFXao9DEeLrFId3GaG9wNWwCSY29dNi/LtLkqdxQ8fizwaqFTk3G3b47qFaWgbBX5nU9uMDBlG3HD0a3dfEaxC/nDkeSNqWV5O4iRIBzoOX1QGrVoNHGaOEQloRP79G6+soJoV7XEIDNRM7emziKUKB96qfgONqBDZMVMPUlFlglJHsSH7nIkZA+h6Upn1oPW3FAGeAPyQDhe6uXp1PmdOpkFD7U8WgPkdp9tkQaYvgCj4EVca3+UmTtg1mjv9p28SPkHLf/gLxmFMxgpTwlxWqbKISiWNiaFxTQ1aZHSh9Bz2GuLz44Xh9MICDv9IS2viBiLAHRU0NH/GBnQxt21CdmUyprPNad+6rotKQzWmOdfyQRbfoRzhEWuFIk6YFU8sjxtJbtY6flf3N8oIvzLdiYsMJ3MlH0TqipXl2CaxjPyENgSc7bpJhnA9FAGwoWu6IAw0yArDCCpPJueDR5vTXvLlghdfXAeMxAykfm9TCXLga3yk046iuecS4aZ9jov1TF9zDO/uG8ZoVJXid1VM91YIJd7NzjchykMRlYF+wN8GYebh3zGpwXnkW2WVSNDGyUAZrZfC0xkzbf7QP8MmuM8ZgYrTAxevjIWREUqxBgISaCr9YieHBeSTFzyK9Mva9H44LzRt3rGf/Yoj6juPvJRM8Utt35azaEEpJJwnJY6K+A0XFMleXsRGdIZ8WqhpStwhMbCiY5eGCnZMdP/vz60sWsC56G4cBvXofTCD79/m4tQQhYklB3gGwo2ZU3MNqtjPr7UGZaOkqqKpN6qjxrGFNfpW1cV9WqjOLh0q+woetO2vA7g75FBLDWXxsSM9GezCWUf3j2v/5osfxpumTQa4I
 NhM+jZB4
 +daOa90VYJC4vl8LqfSIBVGTo4im+a0+Q4pN5O78zK6KSxpOiup+eDEl/oD63fdyXHKtFk7Me/7ex9rME3opkhv7DRUfgV6TER4Hb6bu2d5q3+zhzkNrxjFBiz2WVSEtpgFxLpI7qIf9iwoZexCesGS1Lgu+2jbphxCPCrOfULAwKAUpcT0iHGx5L5CDCr4vV7yN9ORZ+rL882LvwiclZk4i9D4hgAgYojITS3iBsFDHNvAeXUMceAdHgXsqYzDgUXOhh3/g6tXxMuEOEgnM8DK0c/sT0fblW0wafF2qwhLHpBj00C7lCBsnGfYeNIZiTMt7xB5ykVFeuS3Fd9pAa7zGsK43KHhEaBaKd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While we are still converting VMA flags from vma_flags_t to vm_flags_t,
introduce helpers to convert between the two to allow for iterative
development without having to 'change the world' in a single commit'.

Also update VMA flags tests to reflect the change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm_types.h        | 26 ++++++++++++++++++++++++++
 tools/testing/vma/include/dup.h | 26 ++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ea76821c01e3..63a25f97cd1c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1069,6 +1069,32 @@ static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 	bitmap_zero(flags->__vma_flags, NUM_VMA_FLAG_BITS);
 }
 
+/*
+ * Helper function which converts a vma_flags_t value to a legacy vm_flags_t
+ * value. This is only valid if the input flags value can be expressed in a
+ * system word.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vm_flags_t vma_flags_to_legacy(vma_flags_t flags)
+{
+	return (vm_flags_t)flags.__vma_flags[0];
+}
+
+/*
+ * Helper function which converts a legacy vm_flags_t value to a vma_flags_t
+ * value.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vma_flags_t legacy_to_vma_flags(vm_flags_t flags)
+{
+	vma_flags_t ret;
+
+	ret.__vma_flags[0] = (unsigned long)flags;
+	return ret;
+}
+
 /*
  * Copy value to the first system word of VMA flags, non-atomically.
  *
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index fa2df96f9dee..c27fcfb50d8d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -800,6 +800,32 @@ static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
 }
 
+/*
+ * Helper function which converts a vma_flags_t value to a legacy vm_flags_t
+ * value. This is only valid if the input flags value can be expressed in a
+ * system word.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vm_flags_t vma_flags_to_legacy(vma_flags_t flags)
+{
+	return (vm_flags_t)flags.__vma_flags[0];
+}
+
+/*
+ * Helper function which converts a legacy vm_flags_t value to a vma_flags_t
+ * value.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vma_flags_t legacy_to_vma_flags(vm_flags_t flags)
+{
+	vma_flags_t ret;
+
+	ret.__vma_flags[0] = (unsigned long)flags;
+	return ret;
+}
+
 static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
 		vma_flag_t bit)
 {
-- 
2.53.0


