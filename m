Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BA5C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB2D6B00FC; Wed, 12 Aug 2026 09:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ACBB6B0104; Wed, 12 Aug 2026 09:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8E96B00FC; Wed, 12 Aug 2026 09:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EACDA6B00FC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D61CE160366
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:24 +0000 (UTC)
X-FDA: 85092683928.27.A0A5D5A
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf28.hostedemail.com (Postfix) with ESMTP id F381EC0005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u njqq8I";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HFCJV6Mg;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdpQk+Hx40PJfU17MORiNeZLHwz7nsmGHrsYbIXLhW8=;
	b=EyqKi/i/MjORlzBCF72T0jPBnHNDClpQ6ep7/QlcmHq3ntHugKIAiJeJKE8+vbMkDYINjw
	kSCX1bN4z5dGXE6F74S4oFt/xSESUHP5XMi/kh0F75COcwG0YDhdgAvdEQZfkFEX/9RWLa
	P9z4hHg1Bn/dFtA+485TPzXYzkexaxo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u njqq8I";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HFCJV6Mg;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541003;
	b=pZvGJiOH4t5KjntkFN/0OvIpxLvEOvIMu6nRDA1Io1bMFR4EkOhiiZkwBp/SOLU0icnHOu
	2TtEnb6J3JF80zzy5p9ycLkEQjxtSgpqTeUfzzQe+Y1uMI1nIfcJppfaZqBiQv4zRkNIpv
	I/OjRiy7NulLB5PaZrzV5O7f6lyoiT4=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BF1927A00F7;
	Wed, 12 Aug 2026 09:23:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 12 Aug 2026 09:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541001; x=
	1786627401; bh=DdpQk+Hx40PJfU17MORiNeZLHwz7nsmGHrsYbIXLhW8=; b=u
	njqq8I7a/k1zSPjBpZ+XKODmjpe5C35qprcsdSvnx2XIQ3ve82Qx1uQ4M6Laeo/R
	nWIhP4zft+towIzrF7n67ZwLl+OMiwCSzcDqQI009RMGbe/PatfaQ5HLppREC3QB
	gWb+c2ntNYXwaJHSHn+vCNSskNbwxG67Pc7p3k2/fHBt8d5zAsRuoepTxNAvnsuU
	HE/fl6NV69rkqIQVwd2AkcViKJ7IcVDXKV6ZOJ8BMaxjFgDbGmrwMqoxDTy0tuYg
	2fm6f3MY5E8ouTM8DAQR3AHDx205hSds10qD32gR1WCSxV7ktnJZuav7FpaHabMH
	ofmo/Pp1vhFbKB+4XmsHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541001; x=1786627401; bh=D
	dpQk+Hx40PJfU17MORiNeZLHwz7nsmGHrsYbIXLhW8=; b=HFCJV6Mgjz/2NAcDf
	T8guo1yAwxL54jEcHRCl1teK01WRTmYb4YCfUShhmNYA4lTcFRrhrgsC34DQpXSJ
	QtPjkxpj8M1XK/eY9KwT4jZvY5NDm4Hgzjzri/TEkrZMJg283ipBCCsGlc3QOnZf
	FP7oOss7Ogm2LGRoCwi2xpcyF7AA2D/FdQLwIgIinIkA/YmJtJgXTjTnthlbagR7
	fkZXJnDusbLfqTXL18S177AIdmQLQomG6Y5Y739GljVeTNWDuWPZRa3d8pqOrpVN
	Fs7AiBdRatQkCPbNOHJVzhoJmnlvCJThNLJgj0BhOLfshXCYjRszBgIh67mLjGx1
	gEjug==
X-ME-Sender: <xms:yXN8amejkCpLVxqovKI9xNnCamz5XsPPefNA8e6rQdBfTOn9vDlH-w>
    <xme:yXN8akJkgtUxgnHs8fIiKQ1QcCshCupyCGKT075lX13B3f3Ur1RbJ9EBMqt3lRo7n
    g208JI7_fLVA_XJ1JBUDsbtTg59p_V15devv5VXaVkJ4po4CYexFbM>
X-ME-Received: <xmr:yXN8agA8LQDE27_PvAm0ylWNMrUl_llNz5lKF9QVk2-KjU0DNF7MSNPwoTc>
X-ME-Proxy-Cause: dmFkZTEWZPjKBYDoSh3uCuJ0ogiZvSuDj1RAgMuSmimalRft9LCPvZxyrluChLfTbkjo2r
    KkCK8Ttm4mqxi+W2/UjRoyI4gRuaMCGjIyoE2sYafZhhTXl0iIGCKEOr9/WVtZfHPc/pjz
    XsLpzK8U2Xu6F30SrJOujIlp1bmlomKUtpU/iiXSkRy6wwaI7NV8wAm1PQ0lHgRG0nCRKX
    WKIh8TtevEly/nhHwG2deu/klJhGkXN7h/CDYOOyqjOIkeF7MAFsC6fZtQDVeVkgzM4xU1
    Py5NrFUehZdXXi5LHUYxqNjNVNbuxWN2P2YJW6J2IL8s+zlVHHPN2YdKOlFVuMcbnWK9ia
    7TYo9q4qWL1B9/s0ZJakCaEATTtG18RYcIrguVUBbR2bL9tTJafJsGwoPXNytH5YxGRiu6
    grTOV7pH/QxrbEPmMc+dcw1Y7/X9Z+NuzOj6vvbRXMRBde1CMd4VR9QSWb29CJBNaP1NOD
    b3c6jdZiHR5SvgFJNuvNN0AwxRi1gijWos12yTPYEG7xZiHfVS4xTvEgPbYOFwtChmIH92
    Ioi7m/ZzGvHNgcBHduYcHSsixX8oCToRzYs5Fa21Um8R9L7Ekq5wd0lvGHFI8CbKDz8Ljs
    qp2yzUCSeZqnn1hdxCqTSHIW0VPP3E7kwG9QfvDF2aTFTcUZHJ7awAq7rntg
X-ME-Proxy: <xmx:yXN8aticBnkQds0kUFhD91i_MltEDfqC8nHqWh4hmpMwJm3y0ZvMNg>
    <xmx:yXN8aqMqoy5mwhAMEAXJt2P4cCzufUGKwAgLk5_1zxNisPV-iJYgxQ>
    <xmx:yXN8akarVBsdXLcuQyKAbQoIFZCDz1FZ2q1Ic984IkfahHhLNuzZQw>
    <xmx:yXN8av_2Zp3RgaT6zIpcIElctbdrhN4bkPXMDla0YU6ASyGF8ZoTEg>
    <xmx:yXN8ai9YE_vfR4aJKiuFQsG_0hM6FIbdKEmVk922RsZq42iYMp2ojAuU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:20 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v3 05/18] selftests/mm: keep khugepaged out of the swapout the swap cases set up
Date: Wed, 12 Aug 2026 14:22:51 +0100
Message-ID: <20260812132304.199287-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F381EC0005
X-Rspamd-Server: rspam07
X-Stat-Signature: wbdbxy676cmh9ga5buroqb79ipzmpgnt
X-HE-Tag: 1786541002-445193
X-HE-Meta: U2FsdGVkX1+QdGxYjZ4xOFi8CWjBZIF7BdtW+XNIhoX50u7KqaNURUeeiEXFkdLeJAxkxbAcbxuwXGZ+LLbyv8ZeWdNCOi/sZaR/aoyUV8kVq//sV5uHPKFxOB/dCnaMyfZGBjBNGBVFl+55aYnUBqJHXSO51Cg1K5nLHy98uSlgFudcQVxhv8R3ukIzq0zr8CH2By/9VwOyDF3Gp87fOsAHPwLwIGO/7ieUAEyKJuXrQ6aawEURN2BgRbAUrHGZKMQzFpwnkRAKqG1eyxXwPzQTo+Xco6br7IMk/HasGGLU7PbgnY7iF0s7BQNxBxPQNaXpj5V+eYMLOWNvgD0OBKZ6lgNNMc9ea7WiTkb7ty/ELuW5WKT3Q8ujwTRAGEM8EPfkk9VfdkLfME+2KYJQqkrMLGHaFyx6PQFCs5BcmmHxekmKQLfOTZ90x7NOcwcmpKx9fNpF0q3wRR1gD4HZ8fvE0Cmpkru2Rxz5dwUl/NBltTFI9eEcm5ZmYop01yxGifXxuZRAqbm0E/LerrJOv3E1SZe2hfv9Vh3fsPpi9LdKbnAXnux+0J/nhDzcBKRgjeAX9HS9Lfz4DgaUixe6sdWzWcNPQjTNyEql8jSTNlLPvgmVBOqxX4xZchHyY6/squwYqQsrZ2lo/kdM3mcBMlTgWmT3dSh72v/Qh/dgIo9psiT2xs25Rx4wmkADge7dkRKMXiRkyJh3ImRe0T+2RTliYeSxmgUKSx8dVZjsZGeILRVdbivMZe7YuNV9XN5gUgFTfEHQTjI4ygqGtUdaN8y5+Nj0Wwtca9ozFVmCnmQ2KutFSwusoxmYob8TWa9ilTMwYu8We3MkV7ppoGoGLwW+nAJzNQT0gbhxZZH1NNdwSk2v74h0hK0ReM/iHVhVAwuR9u8PM/DZoaBSIVuN1meqaW71hSejX/FxYVHZ8QwunIkWOtPVgzTse8dRvs2Rm1BREfn2BZQPnrFNwmN
 +6l9Ldxx
 cdiA5QVs3ySG10O799WGSftm8LfE4zDzYzTB/5wtcAPpxHAtWKEkNAy4oNC9n7lppuiS5MT74sXqi8ujSluGxuNr8KwlCbBuavxpJbX1xY6MLXT3OWhJd197hyk9uRr084bEGf/zITjQXFMYgvfiY8+uROvxeNpFBQ3Nk2lAZgGElOK2aAp1ylumuKrxcv01snzGu8cOiHRt9mEqawuc7LobVZd2W1zUEgWoN4/FKkiLZQq14dGNZzkKBqtBP/5e2LudcbzROd7FujB7ygVmBZ1aVyS8G6ngoxV7hkYSR9UvsH4bcMHBcmqmBUZUSXXt66zwQ+cnXYu0JkTtYgvH2M2Z/RoFO4DGcTWjlwlhVI7MPZs8rpDaJeNQ0YXMjsrTlcqBjQKIX3K13cg7xoKVFwtRHD0PyIbRmrk4uT2IdUQgCCPUV0h7VBpo9QlVTqBbcuTH0lTCYLu4wbW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_swapin_single_pte() and collapse_max_ptes_swap() page a range out
and then require smaps to report exactly the count they asked for.  Two
things keep it from arriving.  MADV_PAGEOUT is best effort, so the count
often turns up a moment late.  And wait_for_scan() leaves MADV_HUGEPAGE
behind, so khugepaged is still working on the range: collapsing one with up
to max_ptes_swap pages swapped out means reading them back in, and the
daemon empties the swap as fast as the case fills it.  On arm64 with 64K
pages, where max_ptes_swap is 1024 pages, that is 64M a step and the case
loses:

  # Swapout 1024 of 8192 pages... Fail
  not ok 10 collapse_max_ptes_swap

Ask again for up to two seconds, with the range held out of the daemon's
reach while asking.  The collapse each case runs next puts MADV_HUGEPAGE
back, so only the setup is affected.

If the pages still will not go, skip.  is_swap_enabled() covers a machine
with no swap; what is left -- swap too small, full, capped by a memcg, busy
with writeback -- is not the kernel under test refusing.  An error from
madvise() itself still ends the run.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 53 +++++++++++++++++++------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index c049ac997def..8458cd2ff0df 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -241,6 +241,41 @@ static bool check_swap(void *addr, unsigned long size)
 	return swap;
 }
 
+/*
+ * Page the range out and wait for the swap count to say so.
+ *
+ * Two things get in the way.  MADV_PAGEOUT is best effort:
+ * shrink_folio_list() leaves a folio alone when it cannot reclaim it right
+ * away, and one still under writeback from an earlier pageout is the common
+ * case, so the count the caller asks for arrives a moment later.  And a range
+ * an earlier collapse left MADV_HUGEPAGE is one khugepaged is still working
+ * on: collapsing a range with up to max_ptes_swap pages swapped out means
+ * reading those pages back in, so the daemon undoes the pageout as fast as it
+ * is asked for.  Keep the range out of its reach; the collapse the caller runs
+ * next puts MADV_HUGEPAGE back.
+ *
+ * Failing to get the pages out is the machine's answer, not the kernel's --
+ * swap too small, swap full, a memcg cap, a folio still under writeback -- so
+ * callers skip rather than fail.  An error from madvise() is different, and
+ * ends the run here.
+ */
+static bool swapout_range(void *p, unsigned long size)
+{
+	int i;
+
+	if (madvise(p, size, MADV_NOHUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_NOHUGEPAGE)");
+
+	for (i = 0; i < 40; i++) {
+		if (madvise(p, size, MADV_PAGEOUT))
+			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
+		if (check_swap(p, size))
+			return true;
+		usleep(50 * 1000);
+	}
+	return false;
+}
+
 static void *alloc_mapping(int nr)
 {
 	void *p;
@@ -855,12 +890,10 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	if (madvise(p, page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, page_size)) {
+	if (swapout_range(p, page_size)) {
 		success("OK");
 	} else {
-		fail("Fail");
+		skip("Could not swap out");
 		goto out;
 	}
 
@@ -887,12 +920,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
+	if (swapout_range(p, (max_ptes_swap + 1) * page_size)) {
 		success("OK");
 	} else {
-		fail("Fail");
+		skip("Could not swap out");
 		goto out;
 	}
 
@@ -904,12 +935,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 		ops->fault(p, 0, hpage_pmd_size);
 		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
 		       hpage_pmd_nr);
-		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
-			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-		if (check_swap(p, max_ptes_swap * page_size)) {
+		if (swapout_range(p, max_ptes_swap * page_size)) {
 			success("OK");
 		} else {
-			fail("Fail");
+			skip("Could not swap out");
 			goto out;
 		}
 
-- 
2.54.0


