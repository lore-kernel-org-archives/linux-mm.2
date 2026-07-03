Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B36DC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3526B00B6; Fri,  3 Jul 2026 04:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98AC46B00BA; Fri,  3 Jul 2026 04:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A10C6B00BB; Fri,  3 Jul 2026 04:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 636C76B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:26:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3BAB8E14A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:26:51 +0000 (UTC)
X-FDA: 84946784622.17.FEEE504
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 87738A000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:26:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783067210;
	b=HSjVlN1T+1fIWz8QulckuNyCxHPsRRRbcmpzll8FMeXXYAht5LXLpl+iU9xC2HZDvaMuI0
	OFW8g+gotTLCXmDN4KuZgBRUxmO09i1Id/A2IZyG5eupSwFKz2HF6SGKReaMi1VyVRHEqx
	wAnyo4/zjUOFtW+woKNiHJBhk6yQaDk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783067210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EBB4wecgkxqTMhzqlEtVZRPk5suuyk6Bf1KDV9tHxXo=;
	b=7Wq/euoDdnw3HytmgSIslrkCQdG7wMqUGQZGEPX3iau82bkZ2KOawaU9NU0DUZuvf7Cl8k
	QSgc+C5DCK/8lOM3Ta+gtAQrKj40y9Gx+PH5EXaXgBAuHSSqa/gNU7ASxB0jbLXnvQRnsv
	hiUOOg49M32xaDcYGonbUEj6de9AsZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gs6Kz1RJPz4yjjH;
	Fri, 03 Jul 2026 16:26:47 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6638QYiB046414;
	Fri, 3 Jul 2026 16:26:34 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 3 Jul 2026 16:26:37 +0800 (CST)
X-Zmail-TransId: 2afc6a47723dd8b-98915
X-Mailer: Zmail v1.0
Message-ID: <20260703162637070FU4ekl58Hw_Z7OSuJryZB@zte.com.cn>
In-Reply-To: <20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn>
References: 20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn
Date: Fri, 3 Jul 2026 16:26:37 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYxMSAzLzNdIGtzbTogYWRkIG1yZW1hcCBzZWxmdGVzdHMgZm9yIGtzbV9ybWFwX3dhbGs=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6638QYiB046414
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 03 Jul 2026 16:26:47 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A477247.000/4gs6Kz1RJPz4yjjH
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 87738A000D
X-Stat-Signature: rtzq6k4o6gmdt3sdm6xy8j8xjsyzqfne
X-HE-Tag: 1783067209-929075
X-HE-Meta: U2FsdGVkX1/WFiNbF2ffBG7IlxuEuuvgLpgpHh3+j110ooK8UV2jeDRD6OnQZjSG6A2N/mep/Zz8r1JkjP+OUqba1o70CsfKKIN8rDnbqadbDl7vq9dxm1wT3djlNxnJjs80yOo0KpcA3r+TfA2IzQFYe39zgjqMWs7zcYCeqRa9eY0AEhZcNObRt4SpoMSz45BsgrlTw9wgteGGVNLqKZuICdIK8BfrVNNPRNb/4PKdJ1jh2Jd2LXspG55F+gPqlgD+YrnWTsBE64Www6b2p9mI4av5k10uDmnwiuslVWLBFlzoTv0e7lw77WnG/38GYWhKyd0LjjgLCkftSQJZ2trYsK2ynPbjNXlumFuzLddABLeqzkiIPyLvEYtqAtKkGhSQeCIJE1n5oFT5m4C4Yyqkuc3ylb5SWwuR0xB15859dYtenoEmmbbz8SRm/Jy748DvLsSn/gECPeca6V0rwEpTre3wRf8NbTIKcXUGPxJAzNX17xwIC7FlVDmdMJYYhysIINk+pzYEZBLSCbxY/GqH4b4hc78y11TEptnMKxVfcWGekhAtfpWfi+tO4pEn5PnDSMHKIse8aIK7mVPGqdzOdvbTuVnuGipUBscN2SWKbe0diuXW2BHV68/25C9zzBHFYlxcDF7vTa1S2gsd52mj5pNjR/oguCO46X3qnQrzqQ5juEyTK78h8diHHkgDqE6teX2EdMrMH1EK5K9ajGjSk0+w6LHd3UC/L1AJN7cRMDd9gmchH71R0IIR9bf9g7efZI5pGDfBWw/6KbsFjX018Gw/2ZMAO8kcfTKECkLgrm5SbsWUWNmenM8nuESAA80gtBYRh9jbI+hDXdlK/EpbbsIQ/W9p/1ctRjjIoHZWcOXs4y9XiB3HQqcNQTxReT9nz5grMqG03jqaW2k/+OSObgrZdEDu2NzKVbh49lvxGTC8b4+l6o/pvZrD6Ys2P1g+VM0UC2FMTcvoB69
 2MiRfY+S
 CUVbCzP+YycbqihijWyQpumpt4TvjUNmLAbYZ5OBpLMaKrkMxLNsSGLXUeacWjh44ao0EZcSfU+vQovoNmitmXA5KvBG5wkTujNYS5BpfjCn1FX5JH4o/6Dsv40xjG2orGrRgaC7tfy4/lYsg+pyrJvaGApGoYR4wCRYNreGEjbTDvEE9VeDFJZMM46DOpoSxst2sF2W/h0IySytE9bLjBLHZcMyNrXaej3yIwMJjmx8hs70kwSWVnS7fOy8RxENu2NiYifewwQGYf5nhA41UQeL4FPtLeGJTwn5JpI3ZakpOv3gku/HQP4f0lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

The existing tools/testing/selftests/mm/rmap.c has already one testcase
for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration
of page from one NUMA node to another NUMA node. However, it just lacks
the scenario of mremapped VMAs.

We add the calling of mremap() and then trigger KSM to merge pages before
migrating, which is specifically to test an optimization which is
introduced by this patch ("ksm: Optimize rmap_walk_ksm by passing a
suitable address pgoff").

This test can reproduce the issue that Hugh points out at
https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 tools/testing/selftests/mm/rmap.c | 81 +++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 53f2058b0ef2..1c293ad3f8b8 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,85 @@ TEST_F(migrate, ksm)
 	propagate_children(_metadata, data);
 }

+static bool range_maps_the_same_pfn(int pagemap_fd, void *region, int nr_pages)
+{
+	int i;
+	int retries = 0;
+	unsigned long first_pfn;
+
+retry:
+	if (retries > 10)
+		return false;
+
+	first_pfn = pagemap_get_pfn(pagemap_fd, region);
+	for (i = 0; i < nr_pages; i++) {
+		if (pagemap_get_pfn(pagemap_fd, region + i * getpagesize()) != first_pfn) {
+			/*
+			 * Retry up to 10 times at most in case of the low chance of page
+			 * compaction migrating the page while we check for pfn.
+			 */
+			retries++;
+			goto retry;
+		}
+	}
+
+	return true;
+}
+
+TEST_F(migrate, ksm_and_mremap)
+{
+	unsigned long old_pfn, new_pfn;
+	void *region, *mremap_region;
+	const int nr_pages = 16;
+	size_t mmap_size;
+	int pagemap_fd;
+
+	/* Skip if KSM is not available */
+	if (ksm_stop() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\" failed");
+	if (ksm_get_full_scans() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\" failed");
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		SKIP(return, "opening pagemap failed");
+
+	/* Allocate and populate twice the anon pages initially. */
+	mmap_size = 2 * nr_pages * getpagesize();
+	region = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANON, -1, 0);
+	ASSERT_NE(region, MAP_FAILED);
+	memset(region, 0x77, mmap_size);
+
+	/* mremap the second half over the first half, to stress rmap handling */
+	mmap_size /= 2;
+	mremap_region = mremap(region + mmap_size, mmap_size, mmap_size,
+			       MREMAP_MAYMOVE | MREMAP_FIXED, region);
+	ASSERT_EQ(mremap_region, region);
+
+	/* Merge all pages into a single KSM page. */
+	madvise(region, mmap_size, MADV_MERGEABLE);
+	ASSERT_EQ(ksm_start(), 0);
+
+	/* The whole range should map the same KSM page. */
+	old_pfn = pagemap_get_pfn(pagemap_fd, region);
+	if (old_pfn == -1ul)
+		SKIP(return, "Obtaining PFN failed");
+	ksm_start();
+	ASSERT_TRUE(range_maps_the_same_pfn(pagemap_fd, region, nr_pages));
+
+	/*
+	 * Migrate the KSM page; the whole range should map the new (migrated)
+	 * KSM page.
+	 */
+	ASSERT_EQ(try_to_move_page(region), 0);
+
+	new_pfn = pagemap_get_pfn(pagemap_fd, region);
+	if (new_pfn == -1ul)
+		SKIP(return, "Obtaining PFN failed");
+	ASSERT_NE(new_pfn, old_pfn);
+	ASSERT_TRUE(range_maps_the_same_pfn(pagemap_fd, region, nr_pages));
+}
+
+
 TEST_HARNESS_MAIN
-- 
2.25.1

