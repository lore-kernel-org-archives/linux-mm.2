Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673E660A3831
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=B4Gt3o48
Received: by kanga.kvack.org (Postfix)
	id 5317D6B01A2; Wed, 21 Oct 2026 02:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A206B0642; Wed, 21 Oct 2026 02:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445B96B0643; Wed, 21 Oct 2026 02:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D37D6B01A2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:22:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18D57C02F5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:22:02 +0000 (UTC)
X-FDA: 85345638084.24.FDEF8FD
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf13.hostedemail.com (Postfix) with ESMTP id D02BD20005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:21:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=B4Gt3o48;
	spf=pass (imf13.hostedemail.com: domain of guanwentao@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792563720;
	b=tamggm6u48GzkVu48utAu8TaslUNRO/gTbnDcluTG6n1BU3IBgxz9nddyZe1VnuMa9LUlx
	zuglkOxgckiAntLGs6NUmEVTv0KuoohCS1LyfiJNVUnHzqN+Z4jXk/atEGBBb0BYSPS4cE
	DmOqkv98bpuiH7MFV6V2NXuHwxE8i7Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=B4Gt3o48;
	spf=pass (imf13.hostedemail.com: domain of guanwentao@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AsQZnRDvC0D3gP3oQhOuDZhnSM3XMIz82czrPE7tuD4=;
	b=3JU9h66YaxYnz5RgUmBxinabBtUzUb93XUYC99lsahAjCyv+cdgyR3cMWe9SQwTPIgdy7o
	sLuAUyHVZjA6f8450l57fz5NzW/6G8kgV3mmlHyJ8Mhx3GMt/hHk3watO1UhZ0eELc7KO4
	gnV/QRY5AuFfhHy4dC8R8yFYEy7C6gU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792563701;
	bh=AsQZnRDvC0D3gP3oQhOuDZhnSM3XMIz82czrPE7tuD4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=B4Gt3o48CKZcdUJM7kKyfvejkS7Od6tMdMud4VBGnIpcWwLkFFYnZwMkKuCHQDNe9
	 EoASmRmAbdE2jN6D4rzQz9ByZH/09MdrHmLifYDPOIPAG2t8VFvq07aIgUXpU0EL9u
	 5Mnb2ojhNhjDuba61y7Fl3A/VVQowsG26fW8x9Ag=
X-QQ-mid: zesmtpip2t1792563681t96cc3f72
X-QQ-Originating-IP: SGYOyl1bUWSgKy+cMFiCAF5bJZnqzi5KC2bcPI92i/4=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 21 Oct 2026 14:21:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6018804124745603915
EX-QQ-RecipientCnt: 10
From: Wentao Guan <guanwentao@uniontech.com>
To: chenhuacai@kernel.org
Cc: kernel@xen0n.name,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [RFC PATCH] LoongArch: mm: avoid backing vmemmap beyond max_pfn
Date: Wed, 21 Oct 2026 14:21:15 +0800
Message-Id: <20261021062115.116922-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MjZkc9TfnG+XR3/U2Vek5hNImTnjycVoFb0OssoGpvRmDpaVdTaHlEYh
	I8xIb1fcBjURPhyXLJ/lUNrVI+jmJ/0Pm03Ye28Fl+h1WUkLZYSWUjdHQETqqmfDhs67h+b
	uH7ORoE9K0YBoMxSGEAxRbZoeKyDz98WE3PmkrJRukX53rRZPGxMZg9rvWIZheRd3Iu6DiG
	YN7pfIWW/BAaUPHjvK+JzmbKhCKEmGVyXoOn0GIJnz2QkhXMmqjcjg1AicDBDPAXv61ZYI5
	8rq6SjP9+28IoOX2EuGY/lihMXP+scGGU0gFIRKf8uQEBEu2EvzJCaLCmheOf15n6c6qy+/
	rDjitIYzvXBCVgMH5T25bJSXlY0l2O4ad4kL+yeOsWZZLqxbCUT3xXMuWXCB9qclPiGNwgC
	+UXBLlU2ziFZX2r5K1c52P7rE02GGahzcMqLSAtG7iKTvo1ApqodvtLy1zTN8XWOx5j5V2H
	5b8mSgNHZk9yeFUOCHLLHz048p7kvsJkndddaOmiNt3pvnnqM7+fRVoR5GzrXOGvSNM3/4w
	klkcAp1jlXYSmbEX2y7yaTPUoPxQKwrdyXFdWtHSyQ6PAP0Ml6vhTS6IZQ2R2CfrgumkQJc
	5OfXTdvbQnLUTVxdi2Db42yn3QodxwLzt+4YyZHwU5TJTdavc8ieHbJbhBfmZmHgy5W6Zdy
	hDtHPkSI5GoZ6Yxtpu3QqERonqdRyrn+bIebizcmGvRZ+s8/WwYmcqkSIoXVbwje2L7gdn+
	+ZHA/f0OmJLGyYEcgR8m36vlX0T76CTRZ0TxH4QS/xSvFNtdvLds4ua1Z8wiss5c7MpqnaZ
	2RfxsS16AVPd6VgLUihsAj87+TPX8F1Cdqfk1EP6tvEFEVjOGoxGAueXHiKiC5ZfrmrEURH
	ttk9bPWnB657lkYplt83LLrKh1A+2C76etEFvK4zzLV3F7iFOl69vx3ldruBi3TCrw1jo28
	IsRD6mpjJ76SqUOy4H/eYzNeax/QsWr+PKPyLzeMnlEJqYcM5zqGk85dFAYB+Vtev+BfIjx
	fSvL2RTT0Pz+E8e3MMkowRY+A0NHSBP+7I6aq9scrU8tPYZxUL
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: qj6w4zqrq96fxb461t76crbkk9ep49jc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D02BD20005
X-Rspam-User: 
X-HE-Tag: 1792563718-926850
X-HE-Meta: U2FsdGVkX19Jh0fP+Z7UducgCj4iRKmX9eqnvNk6XLm9T0zUID5AtUJisiRvOLkYjOZslfyMgSIFfvUxfuhAMsRwMMnF+k+vYmOYfRP2MnIqn78qslywSm3wPhVwylUghZp5cLseaAMXLWONg5HhVDw/iQAtLmmvznvwhZx6yGPf5rp6+Fd3lN2i2PdHA5je9m/PaspeK1vNzCB5qV53gzTYoUFqCoTcLKg1wPpxM0N289WQSou0BUOAKDSx8+S/21NLs+vQf7uheHs7HNTYqQv5aPOsYMqaBSydVipkMrCfSh6ByMYSN1knrEtfIQQTdjihKYOGTLjnmOUgM9+qz1dvkS6f72wz6mXPNl9ADUtqbyvOuCLBhDTglBnbMCgx773ixzCzDeQctqG0+gK/H5sYdB8KxdQgsWO1nfK6lHUEBl7f1EODM25yIN/W7Gjs0FU09cCXdj0z7SmF1sxGmgipr8J3nuVvU4sjUw9uCScpXQOoLHHyDvGC+8LlUZKLrXXNL2S3FBSXlBzmfmKs4c7gSWEgXZltnr4+c777baWu+e/yRLx/5KTe3oesZAsKRcz4utKifd7zTkvC4pXWGEggnEw87byGYgt32FAgZe6BPycXr71rQ2OIhwk6Po0z/+9lqV3WB/z2jNe0JfHK+PJXvb+aN7q5gja70HvouZ380j61tShJsYEMBS3JBQEGt3VIxZwIo483/WZ3T7HvRVYIBtceq2dpIrvmxL1Kurtz06eo/jdinVUsuiAmeSWTAdAzS19iNUVPSJiNgpHzTH1YOe83NJEcbyxqLcP94LHaaHqZsJR1cNLdDFDjg5xenb4EdiPcS3PUztSbzuqWVzAA3R9hn62OhzRE9q42ztxCPNdo//S2iNJqNwhCszs19ztstC402eVRI8stQ8gO43mdMwzTvFspVR+70tETDOG6X9M8GMDKq3aZ4OKQi+/g1LGaIlTzdMUrOvJyLTw
 fD5HacJA
 Wi2ErufZYi2fCHkhqqLhBNJ8oWe1+gpOHQWkx97l+ag1ZN08gtbyb93kJm6iutzMM45LcXxTk5ID3r3zZ+zLukjyEvqYF/DhIJDPKpqhPXfrnKz0coFN/r38Qg+8IBnkCRZQsZtqdQy2SRuch8/WMeDy3+zECNSwRfTD3cjpsWplFB4xlagXZOxs8f+vgCee+714HODYKtc8RLE++yUmdKJv1gWmBcSC5UjFAPddEEiL0eu2JdEOS0nb4Y10EyBz/sVlbvdpa8unKj0pUiZH2qWsJIsHOaitQwR6J18KELeQwfEXQjZDP0VmnZxEo46Sy/xDrfguLVS+av2VJVCsvQrRKvNft5kVdw+te
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A PMD maps 32MiB of vmemmap on LoongArch with 16KiB base pages, while a
512MiB section only needs 2MiB.  vmemmap_populate() is called for each
section and vmemmap_populate_hugepages() installs a PMD mapping for the
whole PMD, so the last PMD also backs struct pages for PFNs beyond
max_pfn.

On a 34GiB system 160MiB of vmemmap is mapped although 136MiB is
needed.  The extra 24MiB describes PFNs that do not exist.

Other architectures handle this differently.  On x86, arm64 with 4KiB
pages, and riscv, the PMD covers exactly one section's vmemmap, so the
huge page path never maps beyond the populated range; x86 tracks
partially used PMDs with PAGE_UNUSED for memory hotremove.  arm64 uses
base pages for 16KiB and 64KiB kernels.  s390 deliberately keeps using
1MiB frames even for partially used PMDs because vmemmap_populate() is
called per section and falling back would add page tables.  powerpc
radix falls back to base pages only when the altmap cannot back a full
PMD or the allocation fails, and powerpc hash maps the vmemmap with the
linear mapping page size, which can exceed a section as well.

With 16KiB pages the LoongArch PMD is 16 times the vmemmap of one
section.  Moving the whole vmemmap to base pages, as arm64 does for
16KiB and 64KiB, would also remove the tail, but it would give up PMD
mappings for the 128MiB that is fully populated.  Use base pages only
for the PMD that extends beyond pfn_to_page(max_pfn) and keep huge
mappings for the rest.

The altmap case is left alone because max_pfn does not describe it.

Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 arch/loongarch/mm/init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 4b46c5d30708d..bb7a17bdb0e51 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -146,6 +146,11 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end,
 #if CONFIG_PGTABLE_LEVELS == 2
 	return vmemmap_populate_basepages(start, end, node, NULL);
 #else
+	unsigned long vmemmap_end = (unsigned long)pfn_to_page(max_pfn);
+
+	if (!altmap && (start & PMD_MASK) + PMD_SIZE > vmemmap_end)
+		return vmemmap_populate_basepages(start, end, node, NULL);
+
 	return vmemmap_populate_hugepages(start, end, node, NULL);
 #endif
 }
-- 
2.39.5


