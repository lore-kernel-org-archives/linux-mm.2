Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E60BAF9D0D2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81926B00A0; Tue, 14 Apr 2026 10:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A3C6B00A1; Tue, 14 Apr 2026 10:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DA56B00A2; Tue, 14 Apr 2026 10:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 840B96B00A0
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C8DCC18DC
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:20 +0000 (UTC)
X-FDA: 84657381480.13.EC7D8CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12E67140015
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dyHCKV0q;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176658; a=rsa-sha256;
	cv=none;
	b=UemgHlxmQXevzLgWvA8SrZ6dRPfhKLOycPhEe0h+oYtYvQgv0xzBcLndHkQtTuHWNLyRXf
	6L8rsZgAd4+JV++m8lIH+U2yWaCufw9+/FbwWIj5KfpyJTH6IkdrYLy2M/RvEs4o8hFU+U
	ZqVKmXtXBR/Ks5CjF7rM9A6TFXzf5gk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lPLmVslJhyro/YuJDeXYmIG0bDN8NQX/9tn2rQtedI=;
	b=GPqQNdz2IBXU+D1MNtMYEBhAGYbgOjJwD3WBk5FCRjthxaPpaZpmwMI4D3U/4ioQhCkJc3
	tifizw4GWYmjstMHwHLpxmqtfWSflRnlvZcKtqE5UmSpf7pxpAbLD6nMk7y8SDe5VmjoCv
	BpjcuV3zAS4z0nwqV6O3okIXY1+Xj/8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dyHCKV0q;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B94784455F;
	Tue, 14 Apr 2026 14:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C89C2BCB5;
	Tue, 14 Apr 2026 14:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176657;
	bh=E9uRJ76OlqqumyeaXsGedT7SJ1A+HCyjfEbuV1tzZtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyHCKV0qo2zi1d5qDNF0EFTOh65ruVcvJwrkWK09JRKej+PuspN0jJyyq+hMeK2XY
	 6kqj9CyGRyPhtkYcB0CQI1za8guadvwkwtRxER1KMYvWORC+Ftpv/DD403IFW8QWiO
	 Du2BqowmVBsUI8K65kyRndVfovOLR9nBr3mv2fIKaZMshj/WoK1/X4t+N5+dBb3Rkz
	 /3cLEzaNOtHWmMcODRsmVhIilS2kUnXnEubjkVFDMKnmxeXastmM7CyK4fTuTBD8aR
	 WpypYWf9xvZ9m5Js35lXLWyvhlIYkuykSufIvha7PO51cPFFrtz/OlgfKE9nOwjQ4K
	 UBebfEQybzITg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2F1CEF40068;
	Tue, 14 Apr 2026 10:24:16 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 14 Apr 2026 10:24:16 -0400
X-ME-Sender: <xms:EE7eaZ1arCxTLhH-pdlnYPAd7oAiyY7De5r9AsVV3DIgfhzxCWU7TQ>
    <xme:EE7eaRj1dj9v6uvhEitOTI9kmtCHfvIAhLJxcBULo4b5AB4L05QfoDwzJ25S4MafS
    -I6q-D8OvW8yXuPKSv3p1bjPCtOlxdVgsIuWLk5m1Uzaj7G3UVfAZsT>
X-ME-Received: <xmr:EE7eaVQjsMwFWfrsnMKYrmuLdVPmmg33eDC80U2wbfmqV-wCLRFLs4weMkbx6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfgggtgfesthekredtredtjeenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhvdefvdevjeevhefhhfevudefudejfeduvdekheeludfh
    iefhhedujeffffeigfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeduledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghpthhtohep
    uggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehs
    uhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgt
    ohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:EE7eaT53i-q_nSVLHE6aO2yPo6jnMnyxjKLBIGarDLGupbX4UKLxLQ>
    <xmx:EE7eadxQfVgCiJUhBce235PkAGNWhyhND1ubjZ8ohSYEmx1Qpojbww>
    <xmx:EE7eaTBeHcol6HQcMzLP5HW-i-95PeSXirXIKslXm7nk7HYoYMAyjQ>
    <xmx:EE7eaVaJY8FE6jcXjxK7f-drP21WXBs7hKSktiOhvG1jGKWnV_j16A>
    <xmx:EE7eaaGkIP36RqFDMfJgJ67vjLVSSMZXg9qQo31ZKawi6w36DGJd0QlY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 10:24:15 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC, PATCH 11/12] selftests/mm: add userfaultfd anonymous minor fault tests
Date: Tue, 14 Apr 2026 15:23:45 +0100
Message-ID: <20260414142354.1465950-12-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12E67140015
X-Stat-Signature: b84mquua9otrtqdgzixyqu65mjhqqp3y
X-HE-Tag: 1776176657-783569
X-HE-Meta: U2FsdGVkX1/sqzAqIXWCaJBVkVjGZMf8uZA3Ki4/aAjyCFfPXsmKBBrHpSPBaCAFROXrZeHuLjzXzzViU8iow7IRRqC/MmUYiaN/6Yp3yaur9GxEFC04ErK1jg7sX8TcbaNL+2WpuB8D3de3tRA6OA+zR3ySn8CqTDP5/lI6oMh6dkKcNj5s2gbhK+hinTda7nzjxK+UAWkxETIwg1CPHH+zrQ/46sGtqaagIJx/Wie9Tx2+OUqle6LUZ2wAo9H05GRhC7kq1z/FCExI4T5pd2nrMIWb+UvbglwgfW2GweZT8KeiOIeRM15bpjoYPsarJZ9cqeYz/nExjzeIqEeJPFXFSnKWGGiFCMCOICtnJkhDkc4o8OVaKGC3YLliBBFqYbo1otNDxo8xqE+a7B+i32IkEz+0G9zMnWvNX7yK4MGqvKCEz6LyjhgK5v+XPdbEk1vBbnOjuRDxGKw9duZj0YmB0UVLkvVuxgIU25FtncuVPL7tcI831FddqF7h3W3J5f/uONxMZpEIPW0jyDs5oWb69GCfoEiuxKwrvdZzqcphdwhFugzkkjmaFPn86zdUtna/RPXismIDWMd3S5lOX75BK6wBxfX30IFabTl8zyLDGc1S2Wk4H8V7RPymfv9eCNEyu6vtntWQ6Dx5rjHZJpvpApdHLt2XVsgp17V6R5liJ5iHSFuRhq0MIqHC59xsfUe1fvjoEpd/8OJtcePz1RqOod1eGQGqHLi5i2lYpDhMI9Fk6mpkHhRES2/XnmEw07KyidZUFdvBloehScmNvEfN7KfJiw0toAS4Qz6bpXG4MEMhNFX8FYL9AWISl6gi+oDgCmm2e3VSp63AoisaPqBoGU70tPL/AtgeKJ0GqPaoeERpsGJsfgpviVfnN5b9AN5r0SnsElHZpV7nI6QkhWDGEqG/MhNbk7zHv+5GvCriCtu/m6xQNIQJ1y6TNZy3Ig4emxHW7Fi9y798FjC
 Hc1hUqtK
 tpzcP7hA0kBds6gg61VV9Umw9oDJhlT+OXjXCiImXITt9UTKzgL8SVgE5TngUWNsxkXWQ3DtRdAw8HN5+AbphdJLDDYUxMrG42u6QYxd1TgDwBcKoiI3FA4uo/ohuobZblkalLy685O2/ztDoUzVYqpty9ku9vmiiaIt15TZPpAbxGQ6g3TxtaxyOM4YWeMgV2KqsJKhTRU30fLGFUjnil/qmgQLq1G3H8UZgzTy9Fsd5quMEbxmhKNjQB9WAcbC3hygG8OimHeQN1j7zhn9ddKb5CkxzVU9JfsLy2xKzkMvDdto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tests for UFFD_FEATURE_MINOR_ANON, UFFD_FEATURE_MINOR_ASYNC,
UFFDIO_DEACTIVATE, UFFDIO_SET_MODE, and PAGE_IS_UFFD_DEACTIVATED:

- minor-anon-async: populate pages, register MODE_MINOR with
  MINOR_ASYNC, deactivate via UFFDIO_DEACTIVATE, re-access and verify
  content is preserved with no faults delivered to the handler.

- minor-anon-sync: same setup but without MINOR_ASYNC. Verify that
  each deactivated page access delivers a MINOR fault to the handler,
  and UFFDIO_CONTINUE resolves it. Exercises both PTE and THP paths.

- minor-anon-pagemap: deactivate a range, touch first half, use
  PAGEMAP_SCAN with PAGE_IS_UFFD_DEACTIVATED to verify the untouched
  second half is reported as cold.

- minor-anon-gup: write() from a deactivated page into a pipe to
  exercise GUP resolution through protnone PTEs via async auto-restore.

- minor-anon-async-toggle: full detection-to-eviction cycle using
  UFFDIO_SET_MODE. Start async (detection), flip to sync (eviction
  of cold pages), flip back to async.

- minor-anon-close: deactivate pages, close the uffd fd, verify all
  pages are accessible again (protnone PTEs restored on cleanup).

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 458 +++++++++++++++++++
 1 file changed, 458 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 6f5e404a446c..8bd5a642bd5a 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -7,6 +7,7 @@
 
 #include "uffd-common.h"
 
+#include <linux/fs.h>
 #include "../../../../mm/gup_test.h"
 
 #ifdef __NR_userfaultfd
@@ -623,6 +624,423 @@ void uffd_minor_collapse_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *
 	uffd_minor_test_common(gopts, true, false);
 }
 
+static void deactivate_range(int uffd, __u64 start, __u64 len)
+{
+	struct uffdio_range range = { .start = start, .len = len };
+
+	if (ioctl(uffd, UFFDIO_DEACTIVATE, &range))
+		err("UFFDIO_DEACTIVATE failed");
+}
+
+static void set_async_mode(int uffd, bool enable)
+{
+	struct uffdio_set_mode mode = { };
+
+	if (enable)
+		mode.enable = UFFD_FEATURE_MINOR_ASYNC;
+	else
+		mode.disable = UFFD_FEATURE_MINOR_ASYNC;
+
+	if (ioctl(uffd, UFFDIO_SET_MODE, &mode))
+		err("UFFDIO_SET_MODE failed");
+}
+
+/*
+ * Test async minor faults on anonymous memory.
+ * Populate pages, register MODE_MINOR with MINOR_ASYNC,
+ * deactivate, re-access, verify content preserved and no faults delivered.
+ */
+static void uffd_minor_anon_async_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+
+	/* Populate all pages with known content */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	/* Register MODE_MINOR (uffd was opened with MINOR_ANON | MINOR_ASYNC) */
+	if (uffd_register(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size,
+			  false, false, true))
+		err("register failure");
+
+	/* Deactivate all pages — sets protnone */
+	deactivate_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size);
+
+	/* Access all pages — should auto-resolve, no faults */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+		unsigned char expected = p % 255 + 1;
+
+		if (page[0] != expected) {
+			uffd_test_fail("page %lu content mismatch: %u != %u",
+				       p, page[0], expected);
+			return;
+		}
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Custom fault handler for anon minor — just UFFDIO_CONTINUE, no content
+ * modification (the page is protnone so we can't access it from here).
+ */
+static void uffd_handle_minor_anon(uffd_global_test_opts_t *gopts,
+				   struct uffd_msg *msg,
+				   struct uffd_args *uargs)
+{
+	struct uffdio_continue req;
+
+	if (!(msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_MINOR))
+		err("expected minor fault, got 0x%llx",
+		    msg->arg.pagefault.flags);
+
+	req.range.start = msg->arg.pagefault.address;
+	req.range.len = gopts->page_size;
+	req.mode = 0;
+	if (ioctl(gopts->uffd, UFFDIO_CONTINUE, &req)) {
+		/*
+		 * THP races with khugepaged collapse/split:
+		 * EAGAIN: PMD changed under us
+		 * EEXIST: THP present but already resolved
+		 * In both cases the page is accessible — the faulting
+		 * thread retries and succeeds.
+		 */
+		if (errno != EEXIST && errno != EAGAIN)
+			err("UFFDIO_CONTINUE failed");
+	}
+
+	uargs->minor_faults++;
+}
+
+/*
+ * Test sync minor faults on anonymous memory.
+ * Populate pages, register MODE_MINOR (sync), deactivate,
+ * access from worker thread, verify fault delivered, UFFDIO_CONTINUE resolves.
+ */
+static void uffd_minor_anon_sync_test(uffd_global_test_opts_t *gopts,
+				      uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	pthread_t uffd_mon;
+	struct uffd_args uargs = { };
+	char c = '\0';
+	unsigned long p;
+
+	uargs.gopts = gopts;
+	uargs.handle_fault = uffd_handle_minor_anon;
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	/* Register MODE_MINOR (uffd opened with MINOR_ANON, no MINOR_ASYNC) */
+	if (uffd_register(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size,
+			  false, false, true))
+		err("register failure");
+
+	/* Deactivate all pages */
+	deactivate_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size);
+
+	/* Start fault handler thread */
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
+		err("uffd_poll_thread create");
+
+	/* Access all pages — triggers sync minor faults, handler does CONTINUE */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+
+		if (page[0] != (p % 255 + 1)) {
+			uffd_test_fail("page %lu content mismatch", p);
+			goto out;
+		}
+	}
+
+	if (uargs.minor_faults == 0) {
+		uffd_test_fail("expected minor faults, got 0");
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+}
+
+/*
+ * Test PAGEMAP_SCAN detection of deactivated (cold) pages.
+ */
+static void uffd_minor_anon_pagemap_test(uffd_global_test_opts_t *gopts,
+					  uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+	struct page_region regions[16];
+	struct pm_scan_arg pm_arg;
+	int pagemap_fd;
+	long ret;
+
+	/* Need at least 4 pages */
+	if (nr_pages < 4) {
+		uffd_test_skip("need at least 4 pages");
+		return;
+	}
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, 0xab, page_size);
+
+	/* Register and deactivate */
+	if (uffd_register(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size,
+			  false, false, true))
+		err("register failure");
+
+	deactivate_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size);
+
+	/* Touch first half of pages to re-activate them (async auto-resolve) */
+	for (p = 0; p < nr_pages / 2; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	/* Scan for cold (still deactivated) pages */
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		err("open pagemap");
+
+	memset(&pm_arg, 0, sizeof(pm_arg));
+	pm_arg.size = sizeof(pm_arg);
+	pm_arg.start = (uint64_t)gopts->area_dst;
+	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
+	pm_arg.vec = (uint64_t)regions;
+	pm_arg.vec_len = 16;
+	pm_arg.category_mask = PAGE_IS_UFFD_DEACTIVATED;
+	pm_arg.return_mask = PAGE_IS_UFFD_DEACTIVATED;
+
+	ret = ioctl(pagemap_fd, PAGEMAP_SCAN, &pm_arg);
+	close(pagemap_fd);
+
+	if (ret < 0) {
+		uffd_test_fail("PAGEMAP_SCAN failed: %s", strerror(errno));
+		return;
+	}
+
+	/*
+	 * The second half of pages should be reported as deactivated.
+	 * They may be coalesced into one region.
+	 */
+	if (ret < 1) {
+		uffd_test_fail("expected cold pages, got %ld regions", ret);
+		return;
+	}
+
+	/* Verify the cold region covers the second half */
+	uint64_t cold_start = regions[0].start;
+	uint64_t expected_start = (uint64_t)gopts->area_dst +
+				  (nr_pages / 2) * page_size;
+
+	if (cold_start != expected_start) {
+		uffd_test_fail("cold region starts at 0x%lx, expected 0x%lx",
+			       (unsigned long)cold_start,
+			       (unsigned long)expected_start);
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Test that GUP resolves through protnone PTEs (async mode).
+ * Deactivate pages, then use a pipe to exercise GUP on the deactivated
+ * memory. write() from deactivated pages triggers GUP which must fault
+ * through the protnone PTE.
+ */
+static void uffd_minor_anon_gup_test(uffd_global_test_opts_t *gopts,
+				     uffd_test_args_t *args)
+{
+	unsigned long page_size = gopts->page_size;
+	char *buf;
+	int pipefd[2];
+
+	buf = malloc(page_size);
+	if (!buf)
+		err("malloc");
+
+	/* Populate first page with known content */
+	memset(gopts->area_dst, 0xCD, page_size);
+
+	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
+			  false, false, true))
+		err("register failure");
+
+	deactivate_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size);
+
+	if (pipe(pipefd))
+		err("pipe");
+
+	/*
+	 * write() from the deactivated page into the pipe.
+	 * This triggers GUP on the protnone PTE. In async mode the
+	 * kernel auto-restores permissions and GUP succeeds.
+	 */
+	if (write(pipefd[1], gopts->area_dst, page_size) != page_size) {
+		uffd_test_fail("write from deactivated page failed: %s",
+			       strerror(errno));
+		goto out;
+	}
+
+	if (read(pipefd[0], buf, page_size) != page_size) {
+		uffd_test_fail("read from pipe failed");
+		goto out;
+	}
+
+	if (memcmp(buf, "\xCD", 1) != 0) {
+		uffd_test_fail("content mismatch: got 0x%02x, expected 0xCD",
+			       (unsigned char)buf[0]);
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	close(pipefd[0]);
+	close(pipefd[1]);
+	free(buf);
+}
+
+/*
+ * Test runtime toggle between async and sync modes.
+ * Start in async mode (detection), flip to sync (eviction), verify faults
+ * block, resolve them, flip back to async.
+ */
+static void uffd_minor_anon_async_toggle_test(uffd_global_test_opts_t *gopts,
+					      uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	struct uffd_args uargs = { };
+	pthread_t uffd_mon;
+	char c = '\0';
+	unsigned long p;
+
+	uargs.gopts = gopts;
+	uargs.handle_fault = uffd_handle_minor_anon;
+
+	/* Populate */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	if (uffd_register(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size,
+			  false, false, true))
+		err("register failure");
+
+	/* Phase 1: async detection — deactivate, access first half */
+	deactivate_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size);
+
+	for (p = 0; p < nr_pages / 2; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;  /* auto-resolves in async mode */
+	}
+
+	/* Phase 2: flip to sync for eviction */
+	set_async_mode(gopts->uffd, false);
+
+	/* Start handler — will receive faults for cold pages */
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
+		err("uffd_poll_thread create");
+
+	/* Access second half (cold pages) — should trigger sync faults */
+	for (p = nr_pages / 2; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+		if (page[0] != (p % 255 + 1)) {
+			uffd_test_fail("page %lu content mismatch", p);
+			goto out;
+		}
+	}
+
+	if (uargs.minor_faults == 0) {
+		uffd_test_fail("expected sync faults, got 0");
+		goto out;
+	}
+
+	/* Phase 3: flip back to async */
+	set_async_mode(gopts->uffd, true);
+
+	/* Deactivate and access again — should auto-resolve */
+	deactivate_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size);
+
+	for (p = 0; p < nr_pages; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	uffd_test_pass();
+out:
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+}
+
+/*
+ * Test that deactivated pages become accessible after closing uffd.
+ */
+static void uffd_minor_anon_close_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+
+	/* Populate */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	if (uffd_register(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size,
+			  false, false, true))
+		err("register failure");
+
+	deactivate_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size);
+
+	/* Close uffd — should restore protnone PTEs */
+	close(gopts->uffd);
+	gopts->uffd = -1;
+
+	/* All pages should be accessible with original content */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+		unsigned char expected = p % 255 + 1;
+
+		if (page[0] != expected) {
+			uffd_test_fail("page %lu not accessible after close", p);
+			return;
+		}
+	}
+
+	uffd_test_pass();
+}
+
 static sigjmp_buf jbuf, *sigbuf;
 
 static void sighndl(int sig, siginfo_t *siginfo, void *ptr)
@@ -1625,6 +2043,46 @@ uffd_test_case_t uffd_tests[] = {
 		/* We can't test MADV_COLLAPSE, so try our luck */
 		.uffd_feature_required = UFFD_FEATURE_MINOR_SHMEM,
 	},
+	{
+		.name = "minor-anon-async",
+		.uffd_fn = uffd_minor_anon_async_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required =
+		UFFD_FEATURE_MINOR_ANON | UFFD_FEATURE_MINOR_ASYNC,
+	},
+	{
+		.name = "minor-anon-sync",
+		.uffd_fn = uffd_minor_anon_sync_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MINOR_ANON,
+	},
+	{
+		.name = "minor-anon-pagemap",
+		.uffd_fn = uffd_minor_anon_pagemap_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required =
+		UFFD_FEATURE_MINOR_ANON | UFFD_FEATURE_MINOR_ASYNC,
+	},
+	{
+		.name = "minor-anon-gup",
+		.uffd_fn = uffd_minor_anon_gup_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required =
+		UFFD_FEATURE_MINOR_ANON | UFFD_FEATURE_MINOR_ASYNC,
+	},
+	{
+		.name = "minor-anon-async-toggle",
+		.uffd_fn = uffd_minor_anon_async_toggle_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required =
+		UFFD_FEATURE_MINOR_ANON | UFFD_FEATURE_MINOR_ASYNC,
+	},
+	{
+		.name = "minor-anon-close",
+		.uffd_fn = uffd_minor_anon_close_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MINOR_ANON,
+	},
 	{
 		.name = "sigbus",
 		.uffd_fn = uffd_sigbus_test,
-- 
2.51.2


