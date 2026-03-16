Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B4FF506D3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB62B6B026E; Mon, 16 Mar 2026 09:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B899F6B0270; Mon, 16 Mar 2026 09:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62136B0271; Mon, 16 Mar 2026 09:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1D56B026E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C720B72EB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:20 +0000 (UTC)
X-FDA: 84551957280.28.C0C957C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86734100010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kYw7DD7g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4kG0RbL3l029ryDrxTmQzkYAT92Dc0c2piFlYr1zFA=;
	b=R5QoCqWl1Dj+bRwdowH/yEyMLExzfOHYfCKm6akG3hAz3KTHMxeaIt07eg1LRsvnemq+yf
	zRfYg3MynHgQ26vIM8Spa4dyyRQSKY3/FujV0MPsssfGu7JJ9oq/N01/WFJ/8DaC5K4I/1
	amqpxGVykTmOsEOvHAo1d/xlQeXrcLQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kYw7DD7g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666558; a=rsa-sha256;
	cv=none;
	b=7S6S5IluU02SEgPrFTK3DElxkQDEaDkPUlaZIuDSb8AiFkUKU6apYZwbdhiqFd3mp1h8/z
	1SyDIB2N1Zy070+OoxJdbU3ERc5IRb75PIiw0ve6nc3IZq9qGYItgzy/piYyuGIcbwWb5+
	hkMRL4aMj57x6jHpkPXeweL/Q7cYdwc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2796445BF;
	Mon, 16 Mar 2026 13:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FEDC2BCB1;
	Mon, 16 Mar 2026 13:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666557;
	bh=VG9qmmmFOegmFxOvw//0MFdBoWLaQ29ukQyS87tCN9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYw7DD7gHjlD8HQJ1arhnEYfasRRA/k4Bstjh5nze0eUneMwI7Gat2tEEico37Joq
	 YFLs6klU3jz97aBpGDKboLlJ4lZ8/Yi1vy11O1+GuvU9L5qByshxed7GjngGpUWAfa
	 8VQJ2KI6kNkiHuDMI+sUWk7sKWjH9XpgcxRvHBw1PgPTCh+Wllm4lHTjPLxF4v+no6
	 UfyF4AvrJ9cWuhh94T0mwyeRO7Z/PcFvTv5c9oCskCIS8sQxvubdRAPlzoanyeqmu5
	 MsmeTurX8AaYhahNG8wyPPMrR1L+jCuqqomTjL79sIBu3wRVDMEUb+CXX69VnE9mBS
	 e6f2HZNziUBqA==
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
Subject: [PATCH v2 08/23] tools/testing/vma: add simple test for append_vma_flags()
Date: Mon, 16 Mar 2026 13:07:57 +0000
Message-ID: <8253a553f354e6ef9b1ddea4831c0033e64eb796.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 86734100010
X-Stat-Signature: 3mq5p9hfyez6gtoew9j1f33fnnrkou3w
X-Rspam-User: 
X-HE-Tag: 1773666558-354528
X-HE-Meta: U2FsdGVkX18XlkjXaVSnKwwgxUrR4cw/rTXYBv3Af3TFqKmCYuavc12UOVGcbw6oJDTHY5NuO+aCYV1yXxruvnjhVTPV6dUS25+yD4S0g7bQDaTu3/nGsq95ed1FBVZz16nZAmK4aELE6a+g1GNF9pJ/e2EWgEDs2raGOF7IhuvsRszTfgSDwV/rqWX4WbLKSBWtFgSvw/SAZSjcqaZv0T5GHyvWIA+JVo+DlNuv4NCTsQ58uaOCYD3DposNrwUP97a03ocKzA71Qs2H3bqq7UbmsKO9WTaw5jelFWEMA+Pp4IKb7Ze3lIiVo1yGedAB38hH+HoD41LpyDwzjvJPMn0EN/ISHcXGE90uEYmOoFLYE6ANPVJnmAMNPhT7JoZF1OPa4+PiNzw+Vw3ZnsS+eBm+3Rfqs+Ph30qtYzmLPXWKcYwXAjJOb5oPikGvdD7k95SJ99vozqnrLq5oFlS0bAogrG2DP3Fbvg4Kbrauz2FiND8vX7KrZdlFRz1vTqoeV4Ue749AkOpSaxY92urhaebbg0Y2ixqm+Y6gHSRC/Nsg4w/VMBxItEfIsx4Kg9ZR2Pwmd1QL3Ro5SSnC2Ynpw/WyPSbosIRWP1mkpzGbp9zleGx77NOHk3nWcSTCF1BLXQVy3AwT9li+iT1ussts+8lJiuaV+91L9YxxCepry99oLkH7zPdc0djweYsAnH5wzMFUQ8Y852zz2vrLjzEqQF5lTDVUIpiF/QO661aD+oEDUC6cpD4o3JU9KnzB0hBqqqJpBlNCaO0h69AlWVpawnQOKOBATyr05kx316nBzGm5HB/uooIv86B4C9uau5RTguSTg9dxp+PKAFsApZthTA9fnrYwe787I1+aDy/kOuhuYLD+0SO9TEYvbtJBABvVDVks/c2u3Dh+JIfACe90AVVrDE7ESsoDQU+QyEov8hmvHggMBHSahiPxPsL09qEhO0usTnEX0tPprm/Ob1S
 IWQkcQ6W
 MnJfSzklF3R5x+OwbMiYnY6uOmUyXaSkcw5t967mT9Ketf2zm9ZiMEE0isiUkuFAirs79Fzcdctnq8bBqorPpKOseNzDc8mD6S83h0tcWACgTaV0G84BWZSWn7fRqoYsUHnDRO0j00v272PNeTmV7+Hw7rD3nhffjZvWWFcWJn0XqA7j/mfD67mvSZ6ftN61Ggidg/xfRFEL+oPv+T04KhKT2KfOLEFaWp9oSo6T0E72xZJffLpoWpf5qGxZVBT8TXvOx/CsbhleLl50J9jE1UruuKR2ncyxYCg1MhGrw3zUcqp762THIhZJNau96Yvs72V+zEtkvtq/BwaaTcJqMrO1JGmEW6nBreWhY
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
index cbdeb03ee7e5..47ad01c5d15e 100644
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


