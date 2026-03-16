Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BE7F506CC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1560C6B0274; Mon, 16 Mar 2026 09:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100AC6B0275; Mon, 16 Mar 2026 09:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30BF6B0276; Mon, 16 Mar 2026 09:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E322D6B0274
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78DD61BC73
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:28 +0000 (UTC)
X-FDA: 84551957616.12.0188095
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id BEEB7180012
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nbJID5/G";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ruei/IAGEijYQn5JRTXgXzvj3Ub0bUp/Frh9jm9wYpE=;
	b=8gfjeu/49C5E3of5KoFiSpcgrA8xO7Zd5xpF/ChIJguSdrP0tnHkHVZaL61XM0yXMdYlmc
	wGFTAnhnYjLjG/oCWUp9nExik8axIv1ZByD+jN3MaEdKQ2p1U/wU2Mz/0MHjcCUa+B+21y
	tSXSKB767/xHJ2YlhSaDuCj9WljnQ5s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666566; a=rsa-sha256;
	cv=none;
	b=nfgAn6/Zy+byi92yMOmhGlOtqEFysU2vZZfxxCXPtZ1pn+4enUpB1Ro0S38ujGclcZjXvI
	4b0QqUt8soQ/UUdQicZiWOj9g6s1RdTHQx5eRw1EPOpl1IjnXxEZ7lK+7vEF0wwUQmkUtZ
	PEn+oj/6ldACMvHqpk8/+U5DTpRxbjg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nbJID5/G";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAFE841742;
	Mon, 16 Mar 2026 13:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDE3C19421;
	Mon, 16 Mar 2026 13:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666565;
	bh=Nd91i74SbHF4K4mlqvqBUuCkT/WUSKpdJLLX9/d34uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbJID5/GdPCkHFc6dOnKw0Wnw18nOCtRLAO0Ocf9N91X9/g1IwwwjfH7YmqkhYfvj
	 iow0v5NAiYMiIXhNSxV252ZjRcKVUvaX9GmZnyyU2S2eekBLV3jIKqAhr29YFBBsdC
	 UjIwwkbfFNWOk1Y85lY0SpZ/MQXZ5uJ/S5ED/6HCbPiZtvPmkMQhMf2eV+ZkUJCIZO
	 tu+stnPbneaWWZWauUltgZlyJfgHpcM7a8g5OUX8WfQydzgCmIYJBFREJzDFtbGkXR
	 E2gKKC2uQEt2qBcRIbr24GJZyE+MCPTNGgRL4pBJizNIq66PIUFAMYqNrU1sYM2mgw
	 7OxmaEws1YY6Q==
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
Subject: [PATCH v2 11/23] mm/vma: introduce [vma_flags,legacy]_to_[legacy,vma_flags]() helpers
Date: Mon, 16 Mar 2026 13:08:00 +0000
Message-ID: <19cfb4297cb691dc16c75e9e6a24f6564743407e.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BEEB7180012
X-Stat-Signature: dby6hax9e93by7jjbfgzoicsqqyzkexe
X-HE-Tag: 1773666566-541480
X-HE-Meta: U2FsdGVkX194DL1ejAxzSEs02TfMv+51KVOUzsS0fbEg1P4QpbY7UcFSbQYSwGgjKJxOSdG89M8aW8RYXrLPDcouG67snK2UppHmPbQtPjpMsGYDz5N5xXe4LPNap3B8SrXdBYkIo9TTRUbYHxT90Pf/9JJmboxkfxcXdSt1pNyzCyMBmwUoKqjm2IT1+aYWUUUX176VAqQRvkm39tQpAjCRFJc4w8jRJ13iDE588Xfna2sHllJGMOC160RbYYptMV4Psp0bCt6M6qkQD8i0Q5yvgkj7kwZrhHUBS7DmuKbB8BDh9KyE70RMQCDd5NHnY4Ee/Hlru+Pg38PkCyL+QA59KdqUFtid3ApLFesMCGlxBJuL5KQlMXeuba8d+ooY+MG15T2OPzbMiW9slA4qPANKnpEfl0FviO5cnSWwG0bX1GtcGub0oZ/BZ/wIPklziHRGdPsr4b7EYyIXVotZU/EfVW3wAkAuRxgzJlmLjzXuHbptLnrd3xh+nqJoyuHsjKzu3ue6LvWsVwPWt9cHNAR/R3Y/czgW1pvOmD9ANhP0BtTpTC9y5Q5vBzIbBwcGIWqiGF95vxrXcfNjPyOD6bitsV8fUtjr2ycaBeZkELPZ9z4GaSLVTikABcZzssrcrqaxHNwT8MVCruuD7Cu7sUmr+xZU00fpnmLR9vRaZ99jBKydO9jLlT44ZnA6mlyUXsSqmrA88epCla4flIKm0nU7lzACKx+rkEleYal+/tmPPkpaznR+edI7RkTq/rbQeHIdylpMZ9GBfXlwu1/ciJO4HvwZoebzQIM26t3WC4SdrBuEpVWeVSBIBZtwl7YGvHNeQfEn9j0UMwEdjP1fKlX2QmmSX2KolR3OWE+47t6n/cNFWC5m3wUr7uxjSLk458c8OypkZKXbFnrEM22ndPjL0N6vVWsozzassqvGZSedYfXrSFt6q5d7BOM+0dhxHJsW2drLLhYyp7z0TSZ
 Bm0z6LMN
 A5V4+JRL4UeBkI8EmOI41QAYLRzb7qxaSze9jrawfk2zCbrSAzF4BdENW0yHLip4qAi7biTt2WAF2fznHpLgjG37GLQtn/MwqvmDHxG+lCj6sLSLqQVgmWtA7MVOBReri318iZHpf7mSR+EiI82qCRM8VGG4n/ZlFjiNPqgiMGdiOgq6pvKvvWkx18rBV0weRIyNy0B5HmdVvadncb/t71IsDWqXIXSgaNMEPWgrYx1POIrEsvV1qr11CyYtdIVRkoXe0Keta22d7ECgxFCzNg4Avrb90rJ6hB5Mk5H2QLcjGSLo4swS9/CGIM6kWx7ee/AStH8iLpayAKm9lvru96kfYvi6j1ibyzkLp
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
index 29a6f62b01db..7c22aeb736e6 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -803,6 +803,32 @@ static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
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


