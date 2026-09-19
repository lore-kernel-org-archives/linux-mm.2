Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747CAC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A4F6B00B5; Fri, 18 Sep 2026 20:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E57D6B00B6; Fri, 18 Sep 2026 20:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB8A6B00B7; Fri, 18 Sep 2026 20:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F17756B00B5
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81E9980165
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:18 +0000 (UTC)
X-FDA: 85228617516.14.66F7E80
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf06.hostedemail.com (Postfix) with ESMTP id 830CF180007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H e0n/kb";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=cegSi7EI;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoUp1yN/qSNv1NBhj8IRdHW8JRjYh6PqAm057ehiBQc=;
	b=5d9/rnxlkqhgcIQ9nwpOOoUKtkhkqLRrjvhbL9UgfmB3zGlKsONofKS31LmJ3teVKBIA0E
	ieoFDwsnxykpdQ+8jC0fDpgYNdBUAly3vMmemRQWYbAEY+eMm8oJI6A3M4jCNOZbPgOVCI
	mBi/B7gQ33DfiecQ7qLJoeG7pXJTe7Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777516;
	b=k+c18gbVqVhP7p8uEw+SKx/OPUZIGP35vTy0nB2WUzqjCbJrWWtcWbeLWquejNCULo/KTq
	rE2lhJhYOiybgOmbdOsYvKxozIaktxZIJR1SRRZqvA1M3XA2uEQPMmlJCbL/KW+svod1cy
	BmXLnA8HWTHoZ3A8jGl6iMqIL9EwmzI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H e0n/kb";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=cegSi7EI;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 188E51400165;
	Fri, 18 Sep 2026 20:25:16 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 20:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777516; x=
	1789863916; bh=JoUp1yN/qSNv1NBhj8IRdHW8JRjYh6PqAm057ehiBQc=; b=H
	e0n/kbfBbLnAEMjZSRXH0qlyrKZwW8xWxZ8J27bU1OkkXMqKMCjh40M+KE3KTGhR
	LKN2tWeD4BPhs1EsM/i3sXXxIEjH50QNuQyRZwxB4/CylPilQVrCMQ5ZVo+x7dt2
	QjY4J13QH+fVczJPjPpODHABUB9NhvSW1ZOoSHZ6Lf+xNPQ4XSHYKvt0ILLw7RTe
	SsAi/+2SfeOCU/muer/wI9Pha88pKR31AJ1Q+DmQmpWvuBMVTEgNDO5FEdwKyH8P
	QwTJ+PVoPIw59K/HAxYaXgP8GbvgPiZ348v8eMlbLZ4Xtcea5O25JSd1KIy2XYUT
	q50t89Tc0Qk05C1O/mazg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777516; x=1789863916; bh=J
	oUp1yN/qSNv1NBhj8IRdHW8JRjYh6PqAm057ehiBQc=; b=cegSi7EIBCDaGg6qY
	D6hu56p/UR3ekYX+I+xqQ0MdjtS+vDalshkbX89eq61EvugLKknY/lPLK2hKbLyl
	k6sG9oNjZX4Y5H6SOe2+Bn+dhYTp6S+P7xlxwWxoa1/ZekVacO6xdj3s0WGUAnxo
	o5CmmpHcATnFbteaCPMrfqtzkAWGWQa5v4P/Etfjw2fvD4ejElQeqnrPzUfdoiaz
	gogW9XX6GTWHUr063uoKl9K9o6tdf7VPN5CLHBeXnPH0nRwsgJJYDyxWqrwMyxwd
	V9QUzAlFLy5L9pk4WC1SVjRCtBfFQIQJjDGEOe6SKmemB2QEJSU5EYGBwDIbhM4u
	pdLZQ==
X-ME-Sender: <xms:bNatamjVvN76Pv5eo5CVK85fKeftYQ22wh72LerWpjcIESAB3FDgLA>
    <xme:bNatavblRtQ8j8xL0kQuJKawf9ySkavHl7BREhizpm1mgXvzWUB81TLVHZzp-Ttz1
    GLT90D4eaNrb5tT6m5mhJwp1Yc97Hhv7pmu0EYroydPoHc1eAteoKI>
X-ME-Received: <xmr:bNatagRGV5J81YaRScODasbq-KTtIH22ZOcA_DngImgMSWL7Clw6Piftqyc>
X-ME-Proxy-Cause: dmFkZTEzseHgHAxanvosBbYuJPOsY+n0X5UbYs0PPazNY//kQZ3NkUWvwvZaeFG4K6MaM1
    51QpOH4aelOmHBptEhruNIkMmEsuOQeZbGrvL7mQj2kdmmCNYrJ7V/Gxu8ar4BzJpo5rV7
    vKP2ia7U0+Vm59vAPsz2JcwivFHP+0OmSoqV+JfA3yKlcOkTPrhdGkX4AgOHLm4XJUt5mM
    HeqMESXl6ibr/xrgjBd4IZM9oAbU6DWk9Q3+fqdUek4rHv8tNSmXbmq+2iLXuPMZjgN42W
    gGRNasGU39A5UL6wnmEy31YC46agADHTZYQX6KPmc3+B0CXfmIhRtSns1d+buSvmpYlDQ1
    Nct0DJqYbFtgMLBwl0Mgq8h4lDVNt7z5slUUQuGUTarwDhgKg0aPdeteZazVyMm9CiA4mk
    tE4dt4mV9xRAYcebFPnbh8QDNGw9dlzxhAqpOEdyHhcfRGPnnU9J6vEXGzPPGEtJRINDqC
    MjmY0ZAinZrxX+DA8VHF13sgIl3c28QFzc0fO2nrcVUB7C30VnGnNGH6pB8T1shIN2dixa
    AyGX6eUBscu1tbWunQ8qNN81NNYQS6loqJbBKGnbLJrSZ8Pb+V8ikSaAGT6fHT5xBkC0Wf
    tamYsYP4AZSmYN4GLK5UiKP4j1tfXqC8iPxzBE74LuMSImTM2UI+wyyTitpw
X-ME-Proxy: <xmx:bNatanGZHq0i_zRQAYpUeGxtajSYCO_mXOCd3VsVT4hHfgr7mdGDsg>
    <xmx:bNatal1E4O-So9N3UdN8XhsaMQ0RNPRyOOgnENzmKIwjc9rXyUldrg>
    <xmx:bNatatsItI8cZhNdsbQcjLCM2Aesqh1dAFYHcKjJ4v-sF8r6-VgHeQ>
    <xmx:bNatakkxcqcwxluvUkyXQNkRvHQnAddG9UjF-bIJDihQTgCN_ux6aw>
    <xmx:bNataiKhTSk49bJURODFP6d9lI1dcwlXGGfEz7X5BQVPY_Vaoz-Bu4MG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:15 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 09/19] selftests/mm: add folio-order detection self-check
Date: Sat, 19 Sep 2026 01:24:39 +0100
Message-ID: <20260919002451.496763-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eqysj3wsx8yn6z1ky69p76t83tqox5rp
X-Rspamd-Queue-Id: 830CF180007
X-HE-Tag: 1789777516-120476
X-HE-Meta: U2FsdGVkX1/l65NoREYxAFnqlVS+0cFXVufMA0qc4PZakdj/67yJGpTIZ4epAp5cyZujYldAOPsyUQRx1b57TdSLtKT0L03cGxsDaftfhC78NCSe8taogkfAIELtd+qBVnGZm6+9xTxapLIW8yrWstVww8p1voxN8hVxS7mVzrDrqnL9JY4iNIICleY/VB/9YLBdj0R7eLQXPxyNejk5Dksdphlahje+AkXy4rn4WQIyUYbQmKuX5xLiaVSXFJZ0vdCDeIe6om0Tf186dxquzhUrf4VeHHNmKyn0SXHNrCrJH1M964TNMDwkkI8p77Y2v8NYtGMF/hsjie9wwFFSAS7csoGANqKR1twcnAl0JnXvckdva2i+KE1TZ0x+ppg0IlV6RnZLDJwLzZKjoruN6iRhGFDnNKZN2zX3odm1jZ3Ayg1ZKojdIYUDgrjQl1fGIe39N4LEL1oOxmmCFtOv7MUyCY/qgyxR+216R5fb8aVrSf5t+9Znx1x8GJrgH00ytGClcx9W4b39y6y365uG7mLxQfQNu7Ru13xbz3KU0ikrH0EU94fZaIbEpvDq6I8VejmNbc9TmQ55RZKGseC0gVCCIOqU0FqWfDoocYbJQsqDfLw+Rqvb7+UH112RJPAD/vdGwaoqAbCXTxssIXhq8cmWDssYdwNEY+wAslK803DxxnLGYoIqZBSZMx/ePPdhwrbNGDmzFTzUEJVxC4CL9MHZiQCPRIqgyOY0/53g8xX+GfjwVW6dEYGgVNIE4eCo3g3s44Rw4/dSlGfS6toXlU0IoG5uEotBatQhkG4iCjEcMGZDBqac11saNa2DZZxvo7taUjAmqdZhV/gqvkq/q0zua309ZQybUpevkj11KYb12P6eH0wUbWMdDhcQG1PkX9VnKd7hr0DUT5ViITQWKMOQxBw9JBaGqVOnKG8crlZTSyVLBA2BSjUHIBoHjNLfdBvmSsTzcG5BDTt8ED2
 l0uSx37t
 lKyWwtR/YgTvG4JcKvx29V1yhNY/8SO8CJuPdOHr6c93YS8MN/TVPKxvl1CFHuSAwfYi0G0qWboWeWt9dXrNoE/CrCbE/U+3KD9xnc1MVZt3LBZNx8tzZzkmo9rwscXsBVzHJaK0IOiyN92Q4DicToDzSaIQM8J0dVWsK1Eghw83YZ96rg0JZ68fY52WE7iSJSopVqqJTYNbyD9m1kb1z1wBJNGgjc5uN4DGfUmsQS073aF65rYPrYJsLdvhX9Au1F7CykgE3EmZBBhHUlhJezDwn0nAIN23LHP8dX09C/0/RqCyd0vWBDJC+86hs+UP40pBtmX5eY7oZcbi+0I8a3TO4r3jBKR0TGow/pJdX9nLYkYpNStqaFu0uU+iJy9t0bLJ3dcSNWIvs0VseDY2yvnEYmzTiu2xKxvT6xuSUMQpzsqlUZgAetcqR9LFgwnQAC3JbMzIvJaudVPbNa+J/jBQAUA5VLxYDB+oQLhfZizmiQ16JKuLb1H27+rHiWyMqyv8w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The khugepaged mTHP tests detect collapse results with the vm_util
folio-order helpers rather than smaps AnonHugePages, which only sees PMD
mappings.  If those helpers are wrong, every case built on them is wrong
the same way, and nothing says so.

Check them directly.  For every anon THP order the kernel supports, fault
memory in with only that order enabled.  Require the helpers to classify
the backing as exactly that order: not the order below it, and base-page
memory as order 0.

Run it in the thp category, ahead of ./khugepaged, so a broken helper is
reported as itself rather than as a collapse failure.  Verified on x86-64
4K (orders 0, 2-9) and arm64 64K (orders 0, 2-13).

The test needs ALIGN(), which hmm-tests.c and migration.c each defined
privately.  Move it to vm_util.h and drop both copies.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/folio_order_check.c  | 122 ++++++++++++++++++
 tools/testing/selftests/mm/hmm-tests.c        |   1 -
 tools/testing/selftests/mm/migration.c        |   1 -
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.h          |   2 +
 6 files changed, 127 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/mm/folio_order_check.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7d69baeb93f4..cb32cf5d867e 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += soft-dirty
 
 ifeq ($(ARCH),x86_64)
diff --git a/tools/testing/selftests/mm/folio_order_check.c b/tools/testing/selftests/mm/folio_order_check.c
new file mode 100644
index 000000000000..5eafbcc1b4f3
--- /dev/null
+++ b/tools/testing/selftests/mm/folio_order_check.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Self-check for the vm_util folio-order helpers, is_backed_by_folio() and
+ * is_range_backed_by_order(), which the khugepaged mTHP cases use to detect
+ * collapse results.  For every anon THP order the kernel supports, fault
+ * memory in with only that order enabled and require the helpers to report
+ * exactly that order.
+ */
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+#include <mm/hugepage_settings.h>
+
+static int pagemap_fd;
+static int kpageflags_fd;
+
+static char *alloc_aligned(size_t size)
+{
+	size_t len = size * 2;
+	char *p, *aligned;
+
+	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (p == MAP_FAILED)
+		ksft_exit_fail_perror("mmap()");
+
+	aligned = (char *)ALIGN((uintptr_t)p, size);
+	if (aligned != p)
+		munmap(p, aligned - p);
+	if (aligned + size != p + len)
+		munmap(aligned + size, p + len - aligned - size);
+
+	return aligned;
+}
+
+static void check_order(int order)
+{
+	struct thp_settings settings = *thp_current_settings();
+	size_t size = psize() << order;
+	bool ok = true;
+	char *p;
+	int i;
+
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	if (order)
+		settings.hugepages[order].enabled = THP_ALWAYS;
+	thp_push_settings(&settings);
+
+	p = alloc_aligned(size);
+	*p = 1;
+
+	if (!is_range_backed_by_order(p, size, order, pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d not detected after fault\n", order);
+		ok = false;
+	}
+
+	/* A lower order must be rejected: the folio is larger */
+	if (order && is_range_backed_by_order(p, size, order - 1,
+					      pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d also reported as order %d\n",
+			       order, order - 1);
+		ok = false;
+	}
+
+	/* A large folio must not pass as order 0 */
+	if (order && is_range_backed_by_order(p, size, 0,
+					      pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d also reported as order 0\n", order);
+		ok = false;
+	}
+
+	munmap(p, size);
+	thp_pop_settings();
+
+	ksft_test_result(ok, "order %d classified\n", order);
+}
+
+int main(void)
+{
+	struct thp_settings settings;
+	unsigned long orders;
+	int order;
+
+	ksft_print_header();
+
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open(/proc/self/pagemap)");
+	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	if (kpageflags_fd < 0)
+		ksft_exit_skip("open(/proc/kpageflags) requires root\n");
+
+	orders = thp_supported_orders();
+	if (!orders)
+		ksft_exit_skip("No supported THP orders\n");
+
+	ksft_set_plan(__builtin_popcountl(orders) + 1);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+	/* Base of the settings stack; the bottom entry is never popped */
+	thp_push_settings(&settings);
+
+	check_order(0);
+	for (order = 1; order < NR_ORDERS; order++) {
+		if (!(orders & (1UL << order)))
+			continue;
+		check_order(order);
+	}
+
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index fa1a651963fd..e5f273ca84c1 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -65,7 +65,6 @@ enum {
 #define HMM_PATH_MAX    64
 #define NTIMES		10
 
-#define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
 /* Just the flags we need, copied from mm.h: */
 
 #ifndef FOLL_WRITE
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index a35e2b57e05b..d1d0989ed2ca 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -20,7 +20,6 @@
 
 #define TWOMEG		(2<<20)
 #define RUNTIME		(20)
-#define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
 
 HUGETLB_SETUP_DEFAULT_PAGES(1)
 
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 4cc1d1a55ebf..3a111bc9c29e 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -382,6 +382,8 @@ CATEGORY="pfnmap" run_test ./pfnmap
 # COW tests
 CATEGORY="cow" run_test ./cow
 
+CATEGORY="thp" run_test ./folio_order_check
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 0172003c16dc..ea48e6a7527e 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -12,6 +12,8 @@
 #include <mm/hugepage_settings.h>
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
+#define ALIGN(x, a)                   (((x) + (a) - 1) & ~((a) - 1))
+
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
 #define PM_MMAP_EXCLUSIVE             BIT_ULL(56)
 #define PM_UFFD_WP                    BIT_ULL(57)
-- 
2.54.0


