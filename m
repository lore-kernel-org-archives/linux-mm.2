Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A20EC79FB6
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 02:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93ACE6B0096; Wed,  9 Sep 2026 22:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9129B6B0098; Wed,  9 Sep 2026 22:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8298E6B0099; Wed,  9 Sep 2026 22:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 348BB6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:34:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B551A03F1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:18 +0000 (UTC)
X-FDA: 85196283396.24.CC8A37F
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id DB1164000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VpLh2tS2;
	spf=pass (imf27.hostedemail.com: domain of 3JheiagoKCDkeocjpbcojibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3JheiagoKCDkeocjpbcojibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789007656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HN8r1OTKJ5otXSKxSHXxiuMnoDfjm4NiMKL8K3DQtoE=;
	b=o5XcOGRgTBOUW+KzjuZGRH1F1JRQKqTSz0sNOwO5eTc7e15ZyOppCQr4ARl4nbuMtJ1mPJ
	feybXbRlAZNeOW1gdiE6xWGt3JK6gK5987bgVPVGcrNPBKMXcrbZwAhzBhuFJLWgpFlI0m
	jL93gSFaB7squA97qGtNYCyXMUqqL2Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VpLh2tS2;
	spf=pass (imf27.hostedemail.com: domain of 3JheiagoKCDkeocjpbcojibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3JheiagoKCDkeocjpbcojibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789007656;
	b=imGGCcCQvXtLGXHBr7GiYKM9/FV1k5DIjFwd5aceZnQmRbrL35+tA98rDuck/IyMhxuPJ0
	ZgoFlEaGenqJ47/pA8ynjjIT79kfxGwx2bW0y57+3dhxGQS70jh3foJPO8QUPvpp0UgKlF
	NLoaw00gyIt12tfgam5zJaxCr9pZbf8=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-848568a6f62so6489790b3a.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 19:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789007656; x=1789612456; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HN8r1OTKJ5otXSKxSHXxiuMnoDfjm4NiMKL8K3DQtoE=;
        b=VpLh2tS2pRWMHIuRC5iImvZQlV9piHOlbpipsHiCiQxJrhr3ZnZOGtTJaxZf489+Lz
         1TRE/l+k6M8OKtkwrO6i9NGOadzaimLlaGxIKphhDtvDAakyp5ZYGMCusoY8NNPYl2YC
         wpxPMjmFO/+oKtIy9EPAZVzw4noKl8u9gq42bpiFhMlrcUqgohIJfob3c18M2QITpMH6
         SHDz5VSF1jYSXHJctG9oo9A4CUOOyda76h220W1O/7JOmUr+DbGC2mQ4ual3ZHtdJM7n
         fr9OzKHqtJ5OqAbHiGEueMA4srNOt3G/DdCWCeXzItyKjV665HNRjtfqaHAVP9yGqFpm
         T0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789007656; x=1789612456;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HN8r1OTKJ5otXSKxSHXxiuMnoDfjm4NiMKL8K3DQtoE=;
        b=asG4O7W/Nh2T1faYs+ETgnhogxz5TxkK0+TGFvrz9o/zZ8oojITljCLs889k1U1K9o
         zvJzhJ+cats+UDcDspuUFCJySdOYCVek4pO5URvaqaTfd2Zs4/y/U/y85fgsy2/C4Lkq
         dIkTNj6UZcF9mKb7WifXR99SW/ueqZ+qW6XDHW+XOXG7LDVMzbj9BTsWvP2I2pOIGSZe
         V3gWDNo2sxYge7GEeBDhzz2sAvFVoRbgdFD1/wbN2VoPghNQ2+5KOx+NjIrhaK0t0itD
         OoZfLyJGIqnP1F2ONeNaD172S3PmFqjI+Z9CrmwieYxcQsIW9VGtj5D5G3P1A7lMcajq
         s+eg==
X-Forwarded-Encrypted: i=1; AKwUvBwAa+kWL2mGu9gFm913Chy1Uk9sJHvdSkn8Som+aP57iK3TwSTounAyy+ncwaAZiRItyv+ylrR8jw==@kvack.org
X-Gm-Message-State: AFuF++kZ97+CzqLYGe8YpsGUklOe/rPDPeaoFXS8YXlJU4gbBX4KyVrk
	JcYT7XYsPfGo8lZy58vh3lG9YFDqclWgPOLDW9m3v9EONpZv1yYrB9CY4QNBke1FBVo6en1JEdx
	OYy+Z5Ca/Z1ygOFo7VGIoWA==
X-Received: from pfbfy14.prod.google.com ([2002:a05:6a00:828e:b0:868:6325:1e0f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:17a6:b0:857:7384:b5fd with SMTP id d2e1a72fcca58-86948e29d5amr3444561b3a.25.1789007654727;
 Wed, 09 Sep 2026 19:34:14 -0700 (PDT)
Date: Thu, 10 Sep 2026 02:34:11 +0000
In-Reply-To: <20260910023411.514987-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260910023411.514987-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910023411.514987-2-jthoughton@google.com>
Subject: [PATCH v3 2/2] mm: selftests: Adjust the MADV_COLLAPSE uffd-minor selftests
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com, 
	hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB1164000C
X-Stat-Signature: huisze1hegw4zj9rbe6ieqy5retzpkip
X-Rspam-User: 
X-HE-Tag: 1789007656-27876
X-HE-Meta: U2FsdGVkX18eFKnhVMwi8iIgwhetolcTc03i5XeFsQ7aT1/PEzRGPkdNci5meSONQ8hLaFEFMfdaPeIBppuGz+N1BreS1js8srn6TVSNFFLMyuPIkQZekwpoN2IphpKTieBKQIeYgfpk8da7wfUvZG6tn1rjQHgiZygJ/TkH/MeqzCRDqnnlNrBGlsvx6Sc4XZdoIu00SZU7z+tKtH+5ot0rwVQ4IzBBG9yYf6kVhkBs4nIfR0wxC4xIJBUbYTj7WUMAHcKVSJL1hooxv1/bCZBe2BLlUTcyAtO/4kmGBV6RgmOxq41Y3xRCRlDU5Ac8fbPKYhxlpjEACA5pLxzhTgudgyfVmE81k9inkhyKkzGcL427yXZvAnwTBM1waLmFDB3XHsJd3WHjHBhj04LyitKWEnCDglNHierIF6QwT/VJ2xYBUMTstdiADKAMjZjP9bTo6Gih0eEkwcVmTxhQMYfkFtydQbPEb3xaMik/A5MOzY4lh/TSTwaM2UJphSnQeJqkZrNE9XtrxkLoMYN2Ny/sApqIHHdyfbIlbGjl9hxzhSQmR9xj1JH1Si4jWYnUBlPj+1vtebWWeeuNNv4K3pmFwDaaqfIo82F7jTjjOoumbshW+uqlDO3y1hsPvtaGpcKbhXN6BDzAEI0R10NhXoTSsdgkoYUgt80ZSkrxGPVbpuyefnFUyc1rIE/EjqkZkCZfGK57YfhAdm7LOBBY5U4sIeXVb4TLqJon8CPjGxgql9sOge1deIcEp5ca8/o/O8x3hxxxXhVbChQDsw7pk51aP2JCaU01Mf7/JYrW9c+o98j4ggRo3VNWONvTSViOSLbN1WOeooU6yxFaJHiTT89KR+18pLJ9M2p8jn4FzDLFK4jrLBia0AHSEn5ckDzdOV9HS1gdswJPLxkXx7htF6fu8xBXNnGxa/LzELz4a4OuGH5B6svguxH98ZwgPaDdKnkZDWpao6NLlXo5LS6
 Z/lpZY9r
 dsYY5Y6e50Igt8z54u+EbARPLcXn5tY8gZd/lpPE3+mC2RrbRyU1pAjQran0cNox5EChg6Yq6HkbwRr6nsIcwtYUioxWQTK78QUW3FGABIDm3OMBEXb6dJGu+6oR9vW/9rmv790ZIKGjgPWzFlS6Gz2iQRsGKuaS8j0iQydXk3URJ0pj/6DaFH4XsSmDDM8ly1Vw5ov14RPNMETJesihPuut6R2XhRe+DLObfrBonXt6RLfvEbAvrDYcGQRJTsmgN/Scr+iDFR8mbnVRM46jt9HMLaS6DsNHTLhdjYta/32q3Kig+PDTRtPJHe4K8Y7bncRUZTXmttDxxna7AAMZP/WSxGz5INLhhYXNawyZm21qp/Zp8xzak4WgnXVYcZHzZ7XKACfdATFl9DaF5rT+bxpaQcmgq3TuCQph9XAdDbLltcTqdUoqPynSNaPu0RLZTRGE6kaC4TFZN+HYdrHTMdS0MCW610gwYtnvvR/13bC3AxzwRLdCyCQvl1im12lSUix6fD3lHnafMACPOIGOOsc7OFv6V0eneHRRCrQiVeOXCpLO66ZXDmAW9Cpzz4YIxPuwT1+m5AhFwfGk6OAaosNyLYUce3+ZmApEoMCXNzfrE63P8MgqGs6qEmejtmBfvZtDTtGUbLvHH2nq/ixqgDgW01w1LamVrqmPm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behavior of MADV_COLLAPSE with uffd-minor VMAs has changed:
MADV_COLLAPSE will no longer install PTEs where none existed before.
Update the selftest to demonstrate this new behavior.

On an unpatched kernel, the test will hit "unexpected memory contents
after collapse".

If the selftest is left unpatched but the kernel is patched, the
selftest will SKIP when it gets EINVAL back from MADV_COLLAPSE.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 75 ++++++++++++++++++--
 1 file changed, 68 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index ef9b3956bdcf..6f2360f9b75d 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -518,19 +518,34 @@ static void uffd_wp_fork_pin_with_event_test(uffd_global_test_opts_t *gopts, uff
 	uffd_wp_fork_pin_test_common(gopts, args, true);
 }
 
-static void check_memory_contents(uffd_global_test_opts_t *gopts, char *p)
+static int __check_memory_contents(unsigned long offset,
+				   unsigned long nr_pages,
+				   uffd_global_test_opts_t *gopts,
+				   char *p)
 {
 	unsigned long i, j;
 	uint8_t expected_byte;
 
-	for (i = 0; i < gopts->nr_pages; ++i) {
+	if (nr_pages + offset < nr_pages)
+		err("overflow in memory check");
+	if (nr_pages + offset > gopts->nr_pages)
+		err("out of bounds memory check");
+
+	for (i = offset; i < offset + nr_pages; ++i) {
 		expected_byte = ~((uint8_t)(i % ((uint8_t)-1)));
 		for (j = 0; j < gopts->page_size; j++) {
 			uint8_t v = *(uint8_t *)(p + (i * gopts->page_size) + j);
 			if (v != expected_byte)
-				err("unexpected page contents");
+				return 1;
 		}
 	}
+
+	return 0;
+}
+
+static int check_memory_contents(uffd_global_test_opts_t *gopts, char *p)
+{
+	return __check_memory_contents(0, gopts->nr_pages, gopts, p);
 }
 
 static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_collapse, bool test_wp)
@@ -539,6 +554,8 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
 	pthread_t uffd_mon;
 	char c = '\0';
 	struct uffd_args args = { 0 };
+	unsigned long checked = 0;
+	bool bad_contents;
 	args.gopts = gopts;
 
 	/*
@@ -564,24 +581,65 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
+	if (test_collapse) {
+		/*
+		 * Read just a single page and try collapsing. The collapse
+		 * should either be rejected or be a no-op.
+		 */
+		if (__check_memory_contents(0, 1, gopts, gopts->area_dst_alias))
+			err("unexpected memory contents before collapse");
+
+		/* MADV_COLLAPSE might return EINVAL for uffd-minor VMAs. */
+		madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->page_size,
+			MADV_COLLAPSE);
+		/*
+		 * If the above collapse mapped pages that were not explicitly
+		 * CONTINUE'd, the below __check_memory_contents() will not
+		 * fault on some pages, resulting in incorrect contents. The
+		 * PTE for the first page may get retracted, so avoid checking
+		 * that page, as we might take a second fault, flipping the
+		 * contents a second time.
+		 */
+		checked = 1;
+	}
+
 	/*
 	 * Read each of the pages back using the UFFD-registered mapping. We
 	 * expect that the first time we touch a page, it will result in a minor
 	 * fault. uffd_poll_thread will resolve the fault by bit-flipping the
 	 * page's contents, and then issuing a CONTINUE ioctl.
 	 */
-	check_memory_contents(gopts, gopts->area_dst_alias);
+	bad_contents = !!__check_memory_contents(checked, gopts->nr_pages - checked,
+						    gopts, gopts->area_dst_alias);
 
 	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
 		err("pipe write");
 	if (pthread_join(uffd_mon, NULL))
 		err("join() failed");
 
+	if (bad_contents && test_collapse) {
+		uffd_test_fail("unexpected memory contents after collapse");
+		return;
+	}
+
+	if (bad_contents) {
+		uffd_test_fail("unexpected memory contents");
+		return;
+	}
+
 	if (test_collapse) {
+		/*
+		 * MADV_COLLAPSE will fail unless userfaultfd-minor is
+		 * unregistered.
+		 */
+		if (uffd_unregister(gopts->uffd, gopts->area_dst_alias,
+				    gopts->nr_pages * gopts->page_size))
+			err("uffd_unregister before MADV_COLLAPSE failed");
+
+		/* MADV_COLLAPSE should succeed with userfaultfd unregistered. */
 		if (madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->page_size,
 			    MADV_COLLAPSE)) {
-			/* It's fine to fail for this one... */
-			uffd_test_skip("MADV_COLLAPSE failed");
+			uffd_test_fail("MADV_COLLAPSE failed");
 			return;
 		}
 
@@ -593,7 +651,10 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
 		 * This won't cause uffd-fault - it purely just makes sure there
 		 * was no corruption.
 		 */
-		check_memory_contents(gopts, gopts->area_dst_alias);
+		if (check_memory_contents(gopts, gopts->area_dst_alias)) {
+			uffd_test_fail("unexpected memory contents");
+			return;
+		}
 	}
 
 	if (args.missing_faults != 0 || args.minor_faults != gopts->nr_pages)
-- 
2.55.0.1007.g17ff1f9808-goog


