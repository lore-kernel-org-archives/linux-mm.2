Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 575471099B3D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4F66B0167; Fri, 20 Mar 2026 15:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCE86B016B; Fri, 20 Mar 2026 15:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2EF6B016D; Fri, 20 Mar 2026 15:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2D36B0167
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F24211DC15
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:07 +0000 (UTC)
X-FDA: 84567454734.10.4DAA9A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4209010000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QktC/L4w";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qw1fJgZxAmJTvtiklKZgUvTgS9NPkNuogar+KC9Y62Q=;
	b=MTKw6PAcAw7n5zfEBLzaPL8Cv0tYa+e9r7QHtmMlQSTx5smvDZonkH0qcfvGpBTSq5j3Ww
	QR9DK/frAxdS+P8Sn9+iCb82np8VHlXidnNqkEtVWUYgu8tVsmHkt+CM/5edbvY+075feh
	GPZlmGeDO6dJvaC7z0Z2Ess/s7tzku4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QktC/L4w";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035546; a=rsa-sha256;
	cv=none;
	b=ngIf/oDNpuOpYWOj5Ba6VqObcJ0sjrc2z44nfH1zNxnPo2/hBMJ13ARKzA78I0D1+7IxH4
	Emxgmww+MFS/TOxWnB7aCOOKF2Wphs34la3d6gVQjl9VDF9Dqu9Nk4Yt9DUkxVwjdmWrXL
	NPK0FEK2dEVLRW3tSFROjJTVCVVFBdw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A40F437CE;
	Fri, 20 Mar 2026 19:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD63C19425;
	Fri, 20 Mar 2026 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035545;
	bh=CbVUiCL/t2srd5zwtc07H5gs2GSHrFH2Iq8wD8euBls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QktC/L4wbp/1+jtfvzyaC1YBaaZ405j3FT+qY9c8DzyHjrYSCgARzIsttYxQPXSTF
	 5IP6bO5/V5uODmlPlfjCFSdI+1k3IG9yCmcE4rVzoN5BwTjPXle515+puXYIQupNfM
	 NexDI03mM3zGtWpW/rpXnII+GPh9iVy8wH5RmoR4tmEIya15IT3DNr+qc6s9YtuHxL
	 rP1DO3D+mLGRQkQ7s20ECO3loi/z3vnHR/SLZ+zENHsCku3jj45DSx2Md693rpiCFM
	 0W+FH6YAWVualTLsfTSIUPcdNgzfjAB3I1/VIyKBsATPPSOnGCuvIDxCt8/8foWR4d
	 1RNiBZcMRRo3Q==
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
Subject: [PATCH v4 08/25] tools/testing/vma: add simple test for append_vma_flags()
Date: Fri, 20 Mar 2026 19:38:25 +0000
Message-ID: <eebd946c5325ad7fae93027245a562eb1aeb68a2.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rdyh3bbpqpfb89a9y45u6y58dja68kem
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4209010000F
X-HE-Tag: 1774035546-760010
X-HE-Meta: U2FsdGVkX19Gm1WJ7OFOuYT3X0em+m95GRS80AC7Da/r8y231iahafx+ZVzoCVmOKoo+6e7CGJTkPcgM0xcs9nCN7wZoYlO/Qjz96pWlHd38yEAk4F9nF5aXNd4bIR5U4b+McRz+UsX+w1yfbb4P+kdbM0rUSGpH6iY7kmhSZRSETgSlG+LrtlO0/loD5D7rODuUELmvPtuDDMk6RBVr4/CBFyRWb+cHTamk7WwU7wq+G2CD/nJ5yA7OWj7zUvgw+2PZ1EwU+M6GZjsjlFLibwFM0UxA7/S+a2SNSp4LzT3rzRNjAO91cHhgT17lNJOtoTZeEZQDjrPCbmwo7RJOgV10fajIqddVMhCsfFu3PT9KPMqPb0VxLm6RLOUG9kFcOjE2AjBIeFrkWv1lspTYjzVAmWCOdabp8mGDMa9xdZ1NtxU47539/G0VA2egIk/HvKTZ2HMpgjSraToiPEWqb15kdW5DoPeLMkjUgDbDrVd1pjf8aRPnt5oUy5xtxjT062JHtC2jy+ClsYNyDHa+zdR1zGbgLitEHL/wMAEwmUUTgLNfI2FmOAk0bUVU1iZqGi6P1ASRmJyjZk4QWIH/R8EZfV6fhtwLnfL1a8ySt9FAiePRvEEe38dLlQox8AQjCUP7dahBpTFhyJNwHCPvq4wdAtQTKiTuZvAOSVIAhrfhV7cuuJgYfSO5GFOF6/PkzH09ERnLZPGRM2YY3msSjY3SgMwwqDuEMzIiZ24vL8zDVupKnDK1Tk9kFs14wTQsq3t9KWrn6iYINnOJTyeGg/7N3gNdfgOHFnVfHww9P7jP59Cp4baOm+x3q9nILalXiHwfAUfVNcJL8oL8gHBm2oPdfAhUV/wx0YY8hnRmWLt1/scmV7FX1Z67p/0bf/Wj2N7c920ClhH22srMKUt2kqzwWUj4FeRqrICuUbVd1+iviZnm8+XbMzaWmcxAMZZMG3TLyOuZl8WSMphqlrn
 OrPFJCcQ
 XqffalRcsOq1nhJrHzScFa6RqE+2xHUvwDc6VNDXCjV6mLYrHwICPwyECp5bcHys9fxpYniYQp/wOCLk8HXPAVLcwJuWK2Yk9UZWAX88oEDwj2p6aln854PuRS/sXiQdAiEcfS8giu5gOc38F0aeT8JljgubNg6TkPtl+GehiFaeM54gaeT2d/Sr7bojWiDNnw+kg2pBpPvH9dBXWbA0OWv4UqMDaw/n7r9KZn1T5oRiVaRKj4wE0WyKmkU6fKFKV4t4+W/NgKk9mR55FjpqMLbSSNt6ypKAILnTsgGsK7He1mQr5L7PWd8UE9lolLE8to8yIJpv7Jb+z5xT+vQG/D6Mef2Rmdd7/UvpP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple test for append_vma_flags() to assert that it behaves as
expected.

Additionally, include the VMA_REMAP_FLAGS definition in the VMA tests to
allow us to use this value in the testing.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/include/dup.h |  3 +++
 tools/testing/vma/tests/vma.c   | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index a2f311b5ea82..802b3d97b627 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -345,6 +345,9 @@ enum {
  */
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
+#define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
+				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
+
 #define DEFAULT_MAP_WINDOW	((1UL << 47) - PAGE_SIZE)
 #define TASK_SIZE_LOW		DEFAULT_MAP_WINDOW
 #define TASK_SIZE_MAX		DEFAULT_MAP_WINDOW
diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index feea6d270233..98e465fb1bf2 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -555,6 +555,30 @@ static bool test_vma_flags_and(void)
 	return true;
 }
 
+/* Ensure append_vma_flags() acts as expected. */
+static bool test_append_vma_flags(void)
+{
+	vma_flags_t flags = append_vma_flags(VMA_REMAP_FLAGS, VMA_READ_BIT,
+					     VMA_WRITE_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					     , 64, 65
+#endif
+		);
+
+	ASSERT_FLAGS_SAME(&flags, VMA_IO_BIT, VMA_PFNMAP_BIT,
+			  VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT, VMA_READ_BIT,
+			  VMA_WRITE_BIT
+#if NUM_VMA_FLAG_BITS > 64
+					     , 64, 65
+#endif
+		);
+
+	flags = append_vma_flags(EMPTY_VMA_FLAGS, VMA_READ_BIT, VMA_WRITE_BIT);
+	ASSERT_FLAGS_SAME(&flags, VMA_READ_BIT, VMA_WRITE_BIT);
+
+	return true;
+}
+
 static void run_vma_tests(int *num_tests, int *num_fail)
 {
 	TEST(copy_vma);
@@ -569,4 +593,5 @@ static void run_vma_tests(int *num_tests, int *num_fail)
 	TEST(vma_flags_empty);
 	TEST(vma_flags_diff);
 	TEST(vma_flags_and);
+	TEST(append_vma_flags);
 }
-- 
2.53.0


