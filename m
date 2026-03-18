Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934D2103E197
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D406B02A4; Wed, 18 Mar 2026 11:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01DF36B02A6; Wed, 18 Mar 2026 11:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F3B6B02A7; Wed, 18 Mar 2026 11:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D03E36B02A4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CC6FBB46C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:39 +0000 (UTC)
X-FDA: 84559623918.23.098F66F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0FB4B1C001A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b1Z2PjBq;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQU6YyVXPfQPzB82gPnob5DtpDKG7VKTASIF2S6ms6A=;
	b=KQjYGKA4gr9I0+L0QNEzTaXq+jEnM6Q/mu70+HG1mpi3u+QjqPQldcXF+nhCS/gvDNTqSh
	hx61Ue0EflMbPPDDXXAndnTeDn2fhFNqCHz/lqP14C+zuLkdrULeIXBSQwJRH15y24Z010
	dwCxm7vGcivdsDsKv6zakAi9e1AkUgI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b1Z2PjBq;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849098; a=rsa-sha256;
	cv=none;
	b=U/bgwid62ze5bxuDPHpBQ4QS06sGHhdUpfhyAj6OK12ef81rdmAK7Wa3jy0DJg3F2ZhXar
	X5pbhfOfjOaOPTWtHdMku+HbI3vAAYvkL9rAXS4domF7MVqEEw3Mu9YJ0KGx4ix+NNdbYx
	T3keoSX/S3BlGjGcJC/4yE7GttS8ZVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A25960142;
	Wed, 18 Mar 2026 15:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CDDC4AF10;
	Wed, 18 Mar 2026 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849097;
	bh=iW8PyaQGY3GlJfRuD9IYEogcwxKab0EzWBI+zvgE1Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1Z2PjBqKzp0GfmuAIanbg5AtkQ2vJbq21vcreUid4pRft2yNMcWAMsHaeeMh8tJ8
	 RqyDrk+CO8eOTX1oBQSybsCDlMcOiFZe65B36NUvKKODmwNdhTZoL0+IG/GlzflXP6
	 GvnZ4ucdm0cDUeV3jtLJwciaZlgds1F3YHk5k4QrGze63EGkMzVXl5y64C1lwXZNs4
	 IxDOb6PcqmkxO7mFmLydMSZXJNLcm22sZbGC679SpdSAyrF+x1dUXwztCfrbuyQZ3F
	 ANRAFE3eujHK5OqsObkJCD5pJRyytH8M4WeiAHZplrwztTkK/SBHYOZ6Bu7LaFbjE4
	 hcVN9j6N4c/9A==
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
Subject: [PATCH v3 20/23] tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()
Date: Wed, 18 Mar 2026 15:50:31 +0000
Message-ID: <c2f83d5711753f5b0a6d9a69819f9207a997d728.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8bok74ef3y8siobmzs6rwws1mabq9wkq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FB4B1C001A
X-HE-Tag: 1773849097-541079
X-HE-Meta: U2FsdGVkX1/qB6ebN/3TMcK+PErrkbND1gfuUx+GOmbt/7+TS+raMzpmBRgg1KVPl2sEd+Tx0agmstnJfEGbLZU5lwEFYcK+LWRm9OxPFlpZDv7hpIGapivz4kkrGpiS591lJnkGaVDsCmXvaeqUtFbjaOjy8ywgztCqcemSFrWrzQZaraH1xe5JfyalSV+QsiZfeTs6Dm1oaTYTkXt1GQzKy/NiYAR7jv6G328KTg93DIhEf9dru03kuo3nXnakgiMEIlf+uzd4nib29KIXqa1/jw28yz0XHzLik09xSbSHGKyyNOrv/rAM6IpeCb4zt+E1sz4bzRkeJi6H4tdmOc97ocydRRSCXHWQ9E9RJ8umehchjNtcFY4L2HyeI9ve3XU7+1ePLlzkTKTV9n7AXJiOGip4pP6BabNPEW0lpyBvRVHBymekkeuQvx5nkaX7gyMPYOKA2AA9AQFh9M+szjSi7K1UfSKb5MPjdVTT0pCyuRSU+Glu4FE9SQsWnLpvSZmDPjjPkR4+4sEKtpby30bZXCWELkVVfDwQDJ35FZzU8gTE2wgAtZbK8nddmboELNLGqeJ4It7/8NpjkbI2IdTk6ZNLpaheJrKgm+XWaNmsmLVUV6SGjLDAZONuO03VH/z4djkwDFZdy6vS/qecB87PadNsdc3HJSxrSAqR/RiSbqM1n7jk8mcUalp/J+feNBSAJ5Hwr0eBgaraQUbTTJS95M14RvJHDzwRB3U3xRseE2ISmp9tY1VApygZ3Rou1DuDqCATcg/vPbFDQf/n92QCIS+uoozEbhDKT2T1S+MmKe5NtKg+FaU+gvxSntEFEfn6whMRhIRYppZW6WXmtgw1FK70HiCaEOqOhdrxzv0M4t0HTnbL0BhJ2N9tiVpLnM6iFhklPJFV03OD6UnksLKP4WadKQFVCd8cD9E9TNTTP9r7lTVXs9l40QdFokOlXrEDJLaJmpNuhaw9tla
 qNLjz82W
 6cBsA8sCAgDL83TSgiHL8mbPoqpLZP1mGpBPC3GvpXoKtKkhe00y8IjyU93Yyb2ahvGqsfLwmWyf6GJ13nGlTmFqeJ6XY991AEejOCQsABH+fCG9sJmCKpRg2iDAlqn5UiP4VEbtwxOYJ+GRCEj3uvGQG7IEO6/xUQ+LJsje8yfhZlo6+IvfRMoGvh6VxN+VzSuvvDV+ge6cIiTWtGkHJ8X1A7VwjZyEsHJ8ve9apEd2oln77WetOgASrdNOoxobZYcwtbgoUSFa6IrG5aHxgPPDc+sngLeuE9Ija7IPAQtVNnxdcaUzhOXlGcf+7Mamj+ojGpU22gVEPbTPhpbcNlLOEUZ9ForiQ6x8q
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


