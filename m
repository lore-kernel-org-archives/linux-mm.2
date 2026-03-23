Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AEE1EC01A1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107696B008A; Mon, 23 Mar 2026 03:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF606B008C; Mon, 23 Mar 2026 03:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37286B0092; Mon, 23 Mar 2026 03:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E20026B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:49:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81E311A0812
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:26 +0000 (UTC)
X-FDA: 84576552732.08.71325FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C79D520005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I5My3+MQ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJzb2fLH8dZQbmaimNfUiNnzxhnIKEQ1hMjT2Y397N8=;
	b=tkJR4Qpi6s5ULUCcjXl9gG23eJoC69g4/ZBR54uJM19AZQiRLgCphT4i2Wa2J7LCpfOZmZ
	uMO2IjusY/xnZpakW4FovgF9CbTSNruUoD9MpxIQYZRznt+L92wz6MKBV8vmg0b1F0/gmM
	gJ1JIAg7T6AkGdNtMbdG74rsb94rcFU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I5My3+MQ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252165; a=rsa-sha256;
	cv=none;
	b=UfqGmj6tiXUCjsb/mb4pLBkzcTi+PbUC7kAQ9oSR2TAdezieLX2NCC1TCxMww+HkQ3Gyug
	SHJ46sFi4R2RVW7G2lExworCDNtGQ6+aCWDf1McZ25+kW5Gt9n+TfraqV6Fhd8rbmjifTd
	u1kZUG+Y1j455RpYvGzzpyFGmMxToiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F20A34181A;
	Mon, 23 Mar 2026 07:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3804AC4CEF7;
	Mon, 23 Mar 2026 07:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252163;
	bh=H66xl/BIJkTq28ukNF8WEu/fNAsPeeebsB5A/nwWYaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5My3+MQvuPzdJ/eqnURHDufO2mFAIraPI31J+w/BDj7mSnOzz+bBSQ1nkIe6BHbp
	 XVpJh7sZx9NFenINTf9GYQ137cP6vq3WlrCC8bnp6YDsHPgO8DCjw+QUFpZuyiQRev
	 4ZiDp6rsouY8nD13d6IOzKlDukyiP/rqJ1UKAgnZiOiYzFhPGMGLMTbUTFoLqAqxjQ
	 tmiRSnujVaLodu+eJjuLWv5yflUsq2SZE3WtD7/jj+hDdLQLtnmbP8EpnzzEK7QIi7
	 D0NRQA1iQ/GFpfYatJJU9GNNL+T6vp+PtI6c81WogxjFBeSkYizd+xg4X95TFNbYpb
	 0iF2JqU+gfR1g==
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
Subject: [PATCH v2 3/9] powerpc: opal-core: pair alloc_pages_exact() with free_pages_exact()
Date: Mon, 23 Mar 2026 09:48:30 +0200
Message-ID: <20260323074836.3653702-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C79D520005
X-Rspamd-Server: rspam07
X-Stat-Signature: 4cems4uhyqn3hwekkqh3fqhguffnz3wx
X-Rspam-User: 
X-HE-Tag: 1774252164-230963
X-HE-Meta: U2FsdGVkX18XpoECbD9SDlkpFTZahobl+jjMyF9jJlebLj1BH0ajrGrAlxbN3hMyIZCFU4KNMtYFdyVKEEeb3OXA/7QdJMfeHzJGRBNhUM2AHSvUj2TIr1zxnNBlI2TJz0/Q59QwnPFQrFlazicLAutD3efcC/HkEwjmBm8ktT7wZO4jyOkkgLNPWw0/Yo0pNRG7a7U1iKPhi4Xizt+aYJI4zLy/1ROwVt9g9Uff9d4cekKuzuY3EocvBb6hinNNihE7uvNloqzJJ6Mm49lnTkzSg8tLCJGJGQtw7nmVDO8mKXhPB4OGpN2gc3WJWWXt26CRjVxZ1TZ22RPV5Bob8HiTFK1Cw9a683n0/avyfoP+c5gn2IURrsSTds6MQKOaZIT4KDWqBVbbW8HaV8Mz7GgA964KZ2g5JzWLNam3BDDXF8l+HWnV8hKyEjFPNzH7yliC7gNFmzIkR68e4Z7R6HeuM2itrNHWl593uINmG3Rrinvnq+zxFkkWIY8Xgp2UIJBl//eEv4wkkbWJpDInxvhKpePx3KmVvB2Lb530IOL2QVOiJ8nAg0Sthwkyp5bequ6jADrUgGj65Cn6IvH9ACbWv+wKBY6p0MTN7c76w9K6V0zMDGLfsXGjKEsEpjMxAf905tcGYsdJznqupm+wZKsovtLzczRt3+ZJ7Az90qVaVkkJreowoCswXucxnoNY8Z3YZ1R8jgUNQQNf99jQROU8K7J9ms0KULawU4LZ+QuWz5okXp4s/2JkKitJrr/zlniT8golXqnKytHl27R5rE4JeMzo9b3I9jWSVPVKv5aFRYpsUjnI5PMv+AI5GtmjwRwLHe9IUP4X7AtzL3o5tnrceD6mRTlJulxxknmdO3DtZ5M/2hoEusnfix0UAsPl/n2xg0mNCQ43dgZhbZjZ0TZFpHY3bHxv2pR51CYWVAfxJQOmoFGSH7y5/7WS3Tbest8uWwQKuof9uKk3u/W
 kRAKRzUV
 usCHMKInSW2SXlCNzERe/U7Hxtyo/6fghz/bhFswVJkvB4eugxEvpr8Hkvd1b4XoG7m1RvjoBjF9poMiCzkFtnb4Zytqd1mrkJeP8SY8yUfmH8eB+SuHtU1bOjbU2xexsp7iNxU4jFD0+tOZr1OXcuZUJaXkjuP77AthSnqWF6JcKfSSew4m2bjQbB4xUwmzFLarW8xDAKA0yByUY/aOjtyBjFPdu/WW4wKXFPwBiMFamlo9FdhOyxXrdjm+jVTErmpnA+gjO5tZl1x/iLyj5K4fTcT83XjwnDOb41a8Ypo38CqyQgGwYWvUCg/G3KMeEpGoK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

opal-core allocates buffers with alloc_pages_exact(), but then
marks them as reserved and frees using free_reserved_area().

This is completely unnecessary and the pages allocated with
alloc_pages_exact() can be naturally freed with free_pages_exact().

Replace freeing of memory in opalcore_cleanup() with
free_pages_exact() and simplify allocation code so that it won't mark
allocated pages as reserved.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-core.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-core.c b/arch/powerpc/platforms/powernv/opal-core.c
index e76e462f55f6..32662d30d70f 100644
--- a/arch/powerpc/platforms/powernv/opal-core.c
+++ b/arch/powerpc/platforms/powernv/opal-core.c
@@ -303,7 +303,6 @@ static int __init create_opalcore(void)
 	struct device_node *dn;
 	struct opalcore *new;
 	loff_t opalcore_off;
-	struct page *page;
 	Elf64_Phdr *phdr;
 	Elf64_Ehdr *elf;
 	int i, ret;
@@ -328,11 +327,6 @@ static int __init create_opalcore(void)
 		oc_conf->opalcorebuf_sz = 0;
 		return -ENOMEM;
 	}
-	count = oc_conf->opalcorebuf_sz / PAGE_SIZE;
-	page = virt_to_page(oc_conf->opalcorebuf);
-	for (i = 0; i < count; i++)
-		mark_page_reserved(page + i);
-
 	pr_debug("opalcorebuf = 0x%llx\n", (u64)oc_conf->opalcorebuf);
 
 	/* Read OPAL related device-tree entries */
@@ -437,10 +431,7 @@ static void opalcore_cleanup(void)
 
 	/* free the buffer used for setting up OPAL core */
 	if (oc_conf->opalcorebuf) {
-		void *end = (void *)((u64)oc_conf->opalcorebuf +
-				     oc_conf->opalcorebuf_sz);
-
-		free_reserved_area(oc_conf->opalcorebuf, end, -1, NULL);
+		free_pages_exact(oc_conf->opalcorebuf, oc_conf->opalcorebuf_sz);
 		oc_conf->opalcorebuf = NULL;
 		oc_conf->opalcorebuf_sz = 0;
 	}
-- 
2.53.0


