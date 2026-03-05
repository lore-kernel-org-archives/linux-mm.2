Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7148EF30930
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0ADF6B0096; Thu,  5 Mar 2026 05:50:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB50C6B0098; Thu,  5 Mar 2026 05:50:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBAE56B0099; Thu,  5 Mar 2026 05:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCE1F6B0096
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:50:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79E6A16093B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:51 +0000 (UTC)
X-FDA: 84511691502.07.F72CC69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C28CE40007
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K69d4D5r;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owoM2jdF5fHOsavpMLD8fR4J8bwGSxjTtC/5RQdL0mY=;
	b=NlKJZ98Qm05ci28nE0y+EabTY4BadufNnxRt8qy2r3jX1hho1zIoxKSbGTYGxk8A+TBKgm
	+WG/B2jKooGTnQ+ZRmaE5ZgxanYxx8imHEChfvtAb8FyMnyLc8g/PZ1uB1RK0+HL7b8XmB
	yz3zkRj60f7lFvhoMfm97+2HmkmFLfE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K69d4D5r;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707849; a=rsa-sha256;
	cv=none;
	b=0jLD4yKE5BMDpjqtLN4dLs5AbMs2deUSloN49maNuaTTf7xt4zhnc3tssm51wPWSg3K25X
	WrG7iG+Bs0+OJsE+Im1YUXMzoXA11jCuauW/URfA9HtSXI4oE7z2o9IXOdrPEIAm0DtNja
	y1ztyPejf3fwCTTsjW4aLQQsMvoZMWA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04F7D44592;
	Thu,  5 Mar 2026 10:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5D1C116C6;
	Thu,  5 Mar 2026 10:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707848;
	bh=TF/Y8m2ST7SjfkcrUaxHq0mGyE5PLPgmgeUh4mbmrZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K69d4D5rkvQAOQO0X9LY14GVr8nxRsOyTxPOk3HOl5lilOcGooMFJ1RSYabqmcbgi
	 2Kb4JKE3xl5ujn+rVENRM01RMuTqfN5GJwiDujdpNrnz+/bSi+4/iUwDcrGQaZHKos
	 WXzPNA75E+fgOcKflJ9S1lqO3dtH7VUiIB1E7Hc1lEg87BCGJu+oHuw3etXLaH5ZL1
	 rOurPfYGNpyXfojRseUPlcwfGElAUfDsaU0vtsWbc6yGvwoo83oJQDYFDfivlslCRt
	 kK1RuRQF4zkVJg5hHHManDOSl2kFut9lIrxZm0xduQ2NivqK7NLhoCGGzPedfWaFhz
	 XSvIMevRPsU1Q==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-mm@kvack.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 6/6] tools/testing/vma: add test for vma_flags_test(), vma_desc_test()
Date: Thu,  5 Mar 2026 10:50:19 +0000
Message-ID: <376a39eb9e134d2c8ab10e32720dd292970b080a.1772704455.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C28CE40007
X-Stat-Signature: 6g1y7ytj5q1sc4fec9ofh4oj9pxan47w
X-Rspam-User: 
X-HE-Tag: 1772707849-884248
X-HE-Meta: U2FsdGVkX1+MW3bH2RJEF8d9QSAc/3z8M6pzizW2bsy68heroKmheDeKXzsl45yFs/+Z3jignjBsoCa4Gs6NWwyM6SBSpT6/+gFlfGkhuIlCJvk/VZ3LYA31MGe2eMcoCdlQOHHR/C6M/2jMkRRq/CsbpqXmg6TqI8vvnMDzLzpMajEUsYoajCoxdisaZKMS+4kC6rxkNRyYTcw2bWY5gZ1xMZhDjFRZDYzdvbO0+yksAqg5O8M1macs4FNEmE6SY7BBExoAjmKKkt/cJFwnMzbe4b25Xpj1wE33uGXEoJ1ZIeppKwmmrfANGstAGM3U2Ah19v0x3rIrRMEZDsKrFIJHQ9J2nTAlqdfHcyZtqIv1+n3W66bkENeJKTEWZXwviY5sFO/X4xC4H6VPfMtz4StOZA4o6RnDuIqpC1bKLrj+LTo//ECc3X5nswwvGv8wrDPNI0SPHSinYqgTLqPowuW/jfCd+6waf6DkpK0FlagenDgnwUejXaNMg7mt3M73Bb24VUbjg61L9HLCMfQ7sbiY3/jJ9JT/xoUKuWI36TX8wVPvpFi4RsVrB7lLoZLw7FdjfYzTuRbXzZ0OHbU8qNzAwvPWGZPFfmlPyXNUO0tTDH1QlZRrBeRjja258dPLo51FyXhLDl7NklvxWVMw3GPHl8z8ODEG8hnd8G9FQTLQhBzQnrNhXAZAxK5yZM8Fx6yBEaBw+BOhTMGW/pGDZZdIvkn6s8C0nO6E54qlERFLGliX0uJ7O4Tp4J/Om3UGjRrCVJ2fSzhubaX9oDIi4dymt/qwNykJKE++EbTEql5RiFOGAsuj1WAkhlvsfJFRvO9+CLb9mIXMPSSQ07uES4cvfCX6DoyhDoCmyR8Kn41D8IAAtAUO3mHkSDIjm1/e+FIbZ6aYN+W2yX2EJAx0R6XnJsSYxMAYOZcEF7T0HqzzpwM5zN1/Sw286vxiedX49pCs2uRP/ejG3GGoAFk
 D4m20PbL
 EkAUjKpwAexVYcMSjclAeNf5S1S8RfGHpjcMN4929V/lwwkS144BUgTTFqDIkR6uI/j74NRqHQMBuJek828WRxH0zeHMnWgF1LldoY4K/Lfa41K+sNEVqrEbfTMViG5/b5rQQtV/064FgYdf/MxKCTBNrtddXmsXczKWRO6U8B7qTgvIxmmMKuHGL7GwW3LTPjLkPQ7jKkrci4Ps7BkfuxLjbD/eHRI4rFy/5QrvriWChhJ9+viZjaRx1fwEOEq7dbNOabGDato+6SRjMvAQXBE9pGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have helpers which test singular VMA flags - vma_flags_test() and
vma_desc_test() - add a test to explicitly assert that these behave as
expected.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 36 +++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index f031e6dfb474..1aa94dd7e74a 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -159,6 +159,41 @@ static bool test_vma_flags_word(void)
 	return true;
 }
 
+/* Ensure that vma_flags_test() and friends works correctly. */
+static bool test_vma_flags_test(void)
+{
+	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					       VMA_EXEC_BIT, 64, 65);
+	struct vm_area_desc desc;
+
+	desc.vma_flags = flags;
+
+#define do_test(_flag)					\
+	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
+	ASSERT_TRUE(vma_desc_test(&desc, _flag))
+
+#define do_test_false(_flag)				\
+	ASSERT_FALSE(vma_flags_test(&flags, _flag));	\
+	ASSERT_FALSE(vma_desc_test(&desc, _flag))
+
+	do_test(VMA_READ_BIT);
+	do_test(VMA_WRITE_BIT);
+	do_test(VMA_EXEC_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	do_test(64);
+	do_test(65);
+#endif
+	do_test_false(VMA_MAYWRITE_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	do_test_false(66);
+#endif
+
+#undef do_test
+#undef do_test_false
+
+	return true;
+}
+
 /* Ensure that vma_flags_test_any() and friends works correctly. */
 static bool test_vma_flags_test_any(void)
 {
@@ -334,6 +369,7 @@ static void run_vma_tests(int *num_tests, int *num_fail)
 	TEST(vma_flags_unchanged);
 	TEST(vma_flags_cleared);
 	TEST(vma_flags_word);
+	TEST(vma_flags_test);
 	TEST(vma_flags_test_any);
 	TEST(vma_flags_clear);
 }
-- 
2.53.0


