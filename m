Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 334D2CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515A26B0098; Fri,  2 Oct 2026 20:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49EE06B0099; Fri,  2 Oct 2026 20:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38FD56B009B; Fri,  2 Oct 2026 20:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14C096B0098
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:19:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99373A07A3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:51 +0000 (UTC)
X-FDA: 85279406982.11.7C7F1A8
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id E286F40007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ga9Yozt9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3JErAagoKCBc6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3JErAagoKCBc6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZE8POibTlx81KQbGmprkmVIECJXXinoiCqckkz2u65g=;
	b=dLdicNoRXYSpo8G6t7KAVLsCyt7MGEyghmRK1q8oWHQqcE7rUD6tyz+Gtk/yvv8qKEHKQb
	+5ICr+VfeS01Dj5AjJ04Q8NED3TgOZDmkH7YkcCHy82x82R5tpIHpQtMhoBdtm0c/Njw8M
	52Q8ZTfwO4DIAa+vLnXI47XgQz5yRww=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ga9Yozt9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3JErAagoKCBc6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3JErAagoKCBc6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986789;
	b=JepYzV/RNT8IrbrZN/Aya1FZBxOA6qhSSyB1nt6Yg2zxKtlsfwXI72c5uG2f9oGnl5t6DF
	M3a4XHQzaJGKkNp1S7pYSz82nlV+u3qSnzvD1Vhz6ffZJzLwtS5boCZPu0wkflVhN3HOwp
	BMQ0XvBNMtwSh4XpqsFwPJsPxMPKHwg=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39deb05ef51so61192a91.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986789; x=1791591589; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZE8POibTlx81KQbGmprkmVIECJXXinoiCqckkz2u65g=;
        b=Ga9Yozt9VQEdmXZeHF68n9gYr96dEShYzD5JNAWj5wDjVX58NMGpk1EvxkuISRWL+k
         WadE0nTtHgYcZ7n4bH4puPGNTZmQhWB1umhba+msOjVkevLz/nfGcaZZ4dgPqcW/S4CU
         A8VOvo+TiQdOwoat7Tn+/sZuUW82unNkujug94gTaHmGYFh+ZtmS3zHarWh2DM0czvSY
         y8leZ85rNqHkOg6wxL9lc+w4qRun+tx8xY/5V6ahDzMw5OYjE/V4rhq/ZMpBrCAlpowK
         0ZpCrsim26TWMmcRdveDlPrlsam/hSqWJTozg9YDRzaMN+yUIUSnn11OPWJ47NC+s8ec
         jiqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986789; x=1791591589;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZE8POibTlx81KQbGmprkmVIECJXXinoiCqckkz2u65g=;
        b=23uVywj0uqtJstkWWzJP1dojlrktivbCmNrfviVPsVoP21N8SyFQy5SLtWf3OOHzQ5
         ctAZgaFvxyMXf4hWhbq+IsnXW7ArI+LwUeT0LlWAOGNTTdFTZvQpw6jPsvy9B22jQ1tG
         F1y5Oc+6xKUCNrLJgAUtM2+YMpVxUcsrgI+1M+f7cCmVgiiCH/LMnrtr/meNoR9US3Sf
         qYaCzwv9V9B+UAalPr16sT+RHogC8tCbsWk3q9+GEW4CBH6KO1kwxmq7QqVTKSN8Ha2k
         cCEacSswxpujAIvWecMN3iHnERFPfPDtDD+JsbJsFxeM32VF4J/oczLSwUGto+aPJoQh
         aIBA==
X-Forwarded-Encrypted: i=1; AKwUvBx+QoKXxjb5j7s34CZd6DCyG81VgmhkQ2u+menpXfl/unEhc7RTOVmgpUX4UzeFOaewyMzzrYU2pA==@kvack.org
X-Gm-Message-State: AFq9FYIkwMIr7vHC29x8Lx4O9PBEXdNuGSO96CIrRwT6vW9wBwtWn/OZ
	Dta4q1iugOu7B0CelG34+8k1da4GRISH84sWr83jN3uxfxm028rWgqPCJ+HA8NUG3FKKimltmgx
	Bfd5BAWbGsQlEkG7HISs1Tg==
X-Received: from pjbfh20.prod.google.com ([2002:a17:90b:354:b0:3a4:8aa5:b794])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:52c7:b0:3a7:f45:5cca with SMTP id 98e67ed59e1d1-3a70f4568b5mr732612a91.14.1790986788466;
 Fri, 02 Oct 2026 17:19:48 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:18:59 +0000
In-Reply-To: <20261003001859.502725-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003001859.502725-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003001859.502725-2-jthoughton@google.com>
Subject: [PATCH v4 2/2] mm: selftests: Adjust the MADV_COLLAPSE selftests for uffd-minor
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
X-Rspamd-Queue-Id: E286F40007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6nm89j36a767cfzkpmjpqsw5f77qfgfc
X-HE-Tag: 1790986789-576668
X-HE-Meta: U2FsdGVkX19uD7lRBYCSwbR+WreZeH6GJR8OhW/ncZgBxQHoI7Ql7MI5b5N55b9Cq+jw3C931FTsGmIpWn79T/kRbaAMRfFhPquFmnArAkjKWfvfpHSTl9N6z22RSH42n7WbFe4qz6I2ePgSS7gJxmC4IM8P+AU/bJ7bD4eAMN5LldyBeDGAfHFOoynreH4/m2DrKGXvzyjCAj7rno676dQcfOA2vPrcrNUqiSirtc0zjwQoj0tEb5ewC7I0RjY6J48Y3PB+B5xFco2oSv1r9utT/1izhTpmxsyfvzSleKYtwNtZk7IyRA4XaRUZi/V+Qq+nev88r1v02VAmBuL4bmixYncs+2zJd45/ROqWSW19WTjTUTopQY/sxBuSP6UJAIyEHzy4jjfYMRqTndp6pXT0TgHh/AiZLmrQsRzSXQxv/wIxYmuGhR9+5eX12K3JKbLLFSvPZvXRPz604JA4UPOv/SMwvjwa/JIQA4IzNy35caQj88UT4T/NT/NGHHyUy7UWTHgfSti1IYR4CN3jwMkzbMn1U4HMv1plDbvmUlM/X2n789S4cLR5DryIyFcd27EUhonIi0o5MiVxN3A0koSaCDVWgw+ktT6saKVgP2Q+01hN973YsGW+QLks9JfDiEAKXX+8Lt5HJ4ecj7/mdsQn+pTCaaf+7N0JGpcy9dZ+0Vghz+j7pTFrhei7IPMTfIubQTZN5PBNK/RfcAguixat/2hgpEoUJnKsqpiL7OtIvX5d+S5pT6iOAMxu7nKtm/0Ia7x+KQs9VL5Ag1LPZd89nEUyeZOJPf1dPwMhxj9W4Knwg8n/6xljJ1OSIQ37MZuITAaokyyHw4EpOMzrvhXXek0KLNVJPcSLK97VrVNXIyOPE/BbvYgqCtZZGzk/Xd09tQgE3wxtv09DnsTIHt+GkmtBQ11KQtPipj+Q7jjShq/ftvsNU5EltGPFq788WPc1Bb58qm7QDwtedY9
 VK1WDl0F
 D4cHLzg0sqsb2kWU9AgNU+C7EdzIbL7VK16jtcmSPeNZ5Qf/HQwx3OYwUvK5Xj7ap3kmp2w8OM8qHuUHvkkpwTorcFIvlIbKQuNqZ+c3lokADOgaXUtkKEsxvpY9IY3fqSSJYZjEjNmnlU7E+ickE4OLj2mt4JOEM1GgMrJnQouLpBgH5a59OxU0uo0lHwW1cQoxysZAEw8JL0+DTOB95XOtZw+ylw+yexd9LwPDtP3zrmjchRRHv9aP5TOAfTsmuOcwT3zEw+APzR5RVz797j/FnVnvkPJuBSQzf3UJsJwIo3qlCHmnvuQjmzMRQjtf8nvckpGd+OAtg42KAGX1Vugyx17cqTJYj3aiWaWU04wXHobbLE+2QgZOHLul2HOQkw82MQS60OTQLoDJVEkUB8zUlfN3Az/lH5uheQrNEhZPuv+uee/CjCH/ZkTuhmQfvvSbbvEXGvhVh6DfR8vEs/PaLxEwDWdT1UeFXXJTIcpeTfvWNK62QgbWyUneeLvSnVPQhV6AZXuSW0Y2oJwwoO61v/Xicdfhb1zsYDUqd1MnAuv+o69DT/L/wsOcLW4Og/tazlKILFka2028fVYpfK9VvBVkwS8q0QOkZ2UwpAsY3OvwNnD7dxr0T3aZo3Y18uTFkXCcsCHqNOkyyLyUPKugwjdhOlhWzfhaeb1tP3wMOsks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behavior of MADV_COLLAPSE with uffd-minor VMAs has changed.
Previously, MADV_COLLAPSE would install PMDs in parts of a VMA where
PTEs may be missing, essentially suppressing userfaultfd minor faults.
Now, MADV_COLLAPSE returns -EINVAL for uffd-minor VMAs. Update the
selftest to demonstrate this new behavior.

The selftest, if left unmodified, will SKIP when it gets EINVAL back
from MADV_COLLAPSE.
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 69 ++++++++++++++++++--
 1 file changed, 62 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 580178630ede..ab195c2c44d3 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -518,19 +518,32 @@ static void uffd_wp_fork_pin_with_event_test(uffd_global_test_opts_t *gopts, uff
 	uffd_wp_fork_pin_test_common(gopts, args, true);
 }
 
-static void check_memory_contents(uffd_global_test_opts_t *gopts, char *p)
+static int __check_memory_contents(unsigned long offset, unsigned long nr_pages,
+		uffd_global_test_opts_t *gopts, char *p)
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
@@ -538,8 +551,8 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
 	unsigned long p;
 	pthread_t uffd_mon;
 	char c = '\0';
-	struct uffd_args args = { 0 };
-	args.gopts = gopts;
+	struct uffd_args args = { .gopts = gopts };
+	bool bad_contents;
 
 	/*
 	 * NOTE: MADV_COLLAPSE is not yet compatible with WP, so testing
@@ -564,20 +577,59 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
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
+		if (madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->page_size,
+			      MADV_COLLAPSE) && errno != EINVAL)
+			err("MADV_COLLAPSE failed unexpectedly");
+		/*
+		 * If the above collapse mapped pages that were not explicitly
+		 * CONTINUE'd, the below __check_memory_contents() will not
+		 * fault on some pages, resulting in incorrect contents.
+		 * The page we already touched should not be unmapped, so a
+		 * second userfault on it should not be generated.
+		 */
+	}
+
 	/*
 	 * Read each of the pages back using the UFFD-registered mapping. We
 	 * expect that the first time we touch a page, it will result in a minor
 	 * fault. uffd_poll_thread will resolve the fault by bit-flipping the
 	 * page's contents, and then issuing a CONTINUE ioctl.
 	 */
-	check_memory_contents(gopts, gopts->area_dst_alias);
+	bad_contents = !!check_memory_contents(gopts, gopts->area_dst_alias);
 
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
 		if (madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->page_size,
 			    MADV_COLLAPSE)) {
 			/* It's fine to fail for this one... */
@@ -593,7 +645,10 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
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
2.56.0.rc1.315.gc6ed9934b7-goog


