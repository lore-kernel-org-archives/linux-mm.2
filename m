Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A336BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BBF76B011B; Mon,  6 Jul 2026 04:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893186B011D; Mon,  6 Jul 2026 04:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734336B011E; Mon,  6 Jul 2026 04:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3572D6B011B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE2EF8D1E6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:45 +0000 (UTC)
X-FDA: 84957726210.24.622B9A8
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf16.hostedemail.com (Postfix) with ESMTP id AA1AB180006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=q5H4+lO7;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="A KERUVK";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327723;
	b=6b4/dK36nd1plN1U0986apf2Wv4Xdgg4QKOvGvPOLLKRWJ8RMPG/3a0eAvijxolNwA7dZL
	DBVat4SUXfpqm+0p/HtiHD/RDyuVD4Lhjl27Er/rdFl4rEAc9HHIbiy46agShAWpEoE5LH
	H48b7cEaXCb/c2gXcUyezGxhAXMb1y8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=q5H4+lO7;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="A KERUVK";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKX3rMlDRmrpqWr5RCQjPRHFYyRAo9U/cf70M8B1oeo=;
	b=i3L19avWkwnryRH9hCCx+VWHt7IoNMd+A52eTI+WAKrWP/g9wwYsmIxzgLEzkjGuc5kJ8z
	7lJm2SrxaCyKuuChf8Ixpbl1GvPQ1mRRXulOQswoIlBwM0st1lDH8k1L9vjFdzF1yERk09
	ScDxq9yEoT8LVDIm+69SDOIRzzdBWTQ=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 846897A00F8;
	Mon,  6 Jul 2026 04:48:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Mon, 06 Jul 2026 04:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783327722; x=1783414122; bh=nKX3rMlDRmrpqWr5RCQjPRHFYyRAo9U/
	cf70M8B1oeo=; b=q5H4+lO7tjNEJoHuL1njXBAlxFBAZVgdSQtRq42eh5UP0oBz
	wrfyIAfkfi5HpksEhBJxa+qyt7Quy6gXFluuQsMHd5gZNf2DOVDbKHIV1dyKwEdi
	zOgkJsrhpM8BgRaATlTLm/MA4lDaTnvUz+CersQ2aO/zplciBgQKDNBaZFeQC+fp
	zWVNwNkbQ89UGx6770sB7KCqlyrnwokzNaBztHBDx8BSIbab5/Xc6QcTYqH6Helg
	rHkGb1NMJ3JKcbJUGqa+e9NYq47sXXEoZILKeYg/wHKaaMicI+PF5XtWLOhn1dwR
	bewkeyeG+uo8IrKQoQ9E0HIuCsr6JmtXxbwrjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783327722; x=
	1783414122; bh=nKX3rMlDRmrpqWr5RCQjPRHFYyRAo9U/cf70M8B1oeo=; b=A
	KERUVKp8JLLUNCnoN1yhB1/wsbcaleln4Z40wzB6O5094rG3H+neaOsN9MmESSnQ
	l/I1UYGuJlQ92rLHVq8kDhlrUn9BPDpKgAG8OblA3/kJ9jdESsdH26z/511uhO6f
	UMaCIFoU/ncEbkZLHqOpRgSJPTgXtdfTS9zXXcB92XCRA5unDvvtaRR+CT288ZkY
	wesFPsbp3IqWUcrdk6f1V+Buv5Vp4J8ZyCKasghbaM9cYvCdmUuwnBQgKdMVrhJS
	sa35vncKgRwSEaMU6s6J2L9lojpDimCKnfdyK1t+7YVSPtGyt8wjXjXLcAVIkRRv
	lK5zKGVIjqrDsX7AeEhPQ==
X-ME-Sender: <xms:6mtLaoVJGc-H1_w8WtKnnd3PJjRKnENRYj_V0p5qxa4lpmtVpFWVHw>
    <xme:6mtLaocLK0t5HIASyeZhhS6a9DzfFP_XA0AodPc4gkcAn7Fy7YZjZsX9phrfP3G5D
    4_XKTlV1lDvainxt-MdjahC7F5mgELd9MKGs2AcCm3sYlTDhFh6Xok>
X-ME-Received: <xmr:6mtLalND_9EGjvy5YhYvEZU7fbYpGAfkfHyN-YkCUHecEjC5ZSBMMZXcwSgw-g>
X-ME-Proxy-Cause: dmFkZTEwUsmfUQd+QrhjhZsyfy+IWD4Tj8ok02tceqZUWDWP2CYiHioGTarXjO1AaENioz
    jAfF/s9EmKxi4n2hyD/Wd+xOlWvIFRWeMD1ecFPJV0mAzsfJlE50d2ws0DxZMw/Kf3ijAR
    yq2cK2j+CJpVqxtBp53uWlyKBxDdmGK8cIOPx9OdbpKBlE6U6XeWUnQ/5uqgZ5WaS8abNN
    4BxgjX42ajr0xlFiZ9CvO8h9kQtGi7+LN6Fvb0xh3Ia9V1sXdj0c4xcA5Cnktf1U19ufij
    fVKBt/1B+8cX55jNV8uZedqX44n+TWaItvswM288j1jkZyW1OdwtsA6CYHPHj6ZiP8TpJG
    Pg8hNPTefFC2R2KUpVOwBANHVbo17H4CKWYNLn14tUGTXTzXsUcCGdx6B2vZGjRV+uBiWq
    7gzpH2QPRDuh598XrbEOF/Ni2u18LqLJkiOq93qCu2mpSaUY+U2/3aGeFkSYsme86DmBdZ
    /yxpiWSf6haHm03lrnj7TyVnz3vjVo+Skr28J+dMW+R3aqfTvyiw+A+U/DrUMsYMfpmSXZ
    +tkOlTlAW3M8MbBgDtsnP/TIdRltUN5QnQh88ClS99xcMDR0o1MFGbf5IrHATTmW8/dCNK
    kinxaG+r8O7IWEDGHEGM9YOmv7bDQvZn1UIn+zhlAt5sHivfbkS7PM6rvTig
X-ME-Proxy: <xmx:6mtLagKPeJnfigKV2t8MTn5ciQOHXKE56eTNaFAEI1dxetZ0C6i1PA>
    <xmx:6mtLarnB8TnkQVluavVhFmKU8KCc_vi3jrIdagCAVJdqwyVl9UgsoA>
    <xmx:6mtLavbXeDTO_8u9JTG04U1lgmy7ctClkTa3fvDOqEy_TqWqR_3sCA>
    <xmx:6mtLaqgm5axBHpAadzP9JDnwCczVFcn8fUS7OUogua1-_b4YiyEllA>
    <xmx:6mtLarHhHXWybhkKIB4ANT2NChderWD3Rriff1-rXaNxjquqUO7ZaJuo>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:41 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v9 14/15] selftests/mm: add userfaultfd RWP tests
Date: Mon,  6 Jul 2026 09:48:03 +0100
Message-ID: <20260706084805.8400-15-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA1AB180006
X-Rspam-User: 
X-Stat-Signature: ieopza3694au6bfif1776rdast3yag6q
X-Rspamd-Server: rspam03
X-HE-Tag: 1783327723-118715
X-HE-Meta: U2FsdGVkX1+QAMlBr/eQpNDGu+dNESLXOhEKUKZkJzaZXOrHFYBxuloR1uqSaIIDFQBh6GxMt3gBPfoaSSTpwAYlRXqBUWsUdIBWsnIgsgQUPmgViiYxo2q1s9RAi4egzLjFnUCx451EbIkDyiWK9AdB51K24WIepFeUNCRp5iDFAS80LjSRnVa9L26czRtTJfg0aBJ9BaIs7EbYkNFnkUqP9sO+Jqg5AsSW4ki9we2gSHCKFmF/YGvxS9fQRmKp4jDpuAnJqP/6+X4Y6/T2a7xx8fc0uK1EWUuBiPpqdDnL/YireHJdww428PrfpcKvNcpY0l7LoBbzjCn1NMDP6gQ/GIHxQsCfGYVVrcsrjb78UTGkIl7Q8vzhv5MoI5KxcB3LZjBL8thKi8WC/MwHuDAyslPW8ItdGHX2eiP2NIQLyu1MGKso4YNjYDYz3nhC78zTG9pdgat5/D5Sl6GvGVPL/1VG1vIwgpJpQBs89rDJln+doZETCYNiax5BPcZPE5Pkswrf8C8AsKaoW+s0Asd2e3ELq9zzKxH8AKzn1SG686ECCFSOIUY0li0ODx3GyMlYE1wV2HtSBWtu13MqWJQ3gizZM6PJMXJ9oNLFSXqmykwiVB2/s5BBa/tmyR/qe7ZD3KEuQ9pzKMToM90R+tdCtO51ewGB/moQ2cMHUjvobctErPNbQPHh1BVc3a+gg5tznkLXjtmbcLlMTeL7jMwoQvwLs69z3MpWDLaSmjZpRSTr6GG0j6Rq06kIE6u/tIkS4dBp9IRa+6/BVXQ/pXRzHhq8Ye+fmHNM39Fn2EdHAT5oZzfAWVtQLBcvckkXotst4h2AEdzm73EQ5dB0PaQpKYBhY2qy9v9aHugL3oUyhUhWNwHHcL1SJZFo7gjDh1/TvREMG/A9ihQA03SKXUBlxuSj0VT3DpYGOencYns1tktrUxBlcYZeyGHhIQTVlWGYEc5nGeDB4TiN/Jl
 5UKzlGj/
 /2qiFwsJ7Wjh87BpUC+ZMnAmGsr/PHLm28YEMiWO9aWSiUzsv85tgGl8NBZgE1LKY3kFHhBL0rESgKMYZi/Omy9ej6ejYtX4G8xuhTf06bpaUS9f//+Rfk6s0+VgH+HMWGp6eFlrH/5aLv+PQiiBQZo5VTFsl9Bv0RGjX9Z1Nc83xyHuVmH1SKLqGTVwuf3DWXVYJA/Qlkf0gFc3XhdQvwi31RJXc2r/gpA7jDBJKnMEOxC+bbxjyVSAfv8iDlKEC3Uy7wVhy8QNOe+2+FWxiX7//Usniuq306GILKMgEJkiNtUanUGZCUnKXwPe3FOYNevHdUDiyjHGH/5LY9upWcbqZ9BQXGsz1ZV3lbnC3jOWKtikreU2uKh6QH7NrL4lP/XY/KPPdYjxxjCSmX0NAOxAUlHv+DBfo1nTjGoTdhmcf+zIf4WKxIYivM/JCeHZg/KMwS8K04T4GxMlV7J3Dv+RTe8/d0b833oOj7jCTeSle887W2iNX438TrdllzvLu+63W3f2o+NRtKi4NIN7uA29GAEvPfZxmnXlb8X8XonyNFZVnsQ75Zl4oGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Coverage for UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT:

  rwp-async          async mode — touch pages, verify permissions are
                     auto-restored without a message
  rwp-sync           sync mode — access blocks, handler resolves via
                     UFFDIO_RWPROTECT
  rwp-pagemap        PAGEMAP_SCAN reports still-cold pages via
                     inverted PAGE_IS_ACCESSED
  rwp-mprotect       RWP survives mprotect(PROT_NONE) ->
                     mprotect(PROT_READ|PROT_WRITE) round-trip
  rwp-gup            GUP walks through a protnone RWP PTE (pipe
                     write/read drives the GUP path)
  rwp-async-toggle   UFFDIO_SET_MODE flips between sync and async
                     without re-registering
  rwp-close          closing the uffd restores page permissions
  rwp-fork           RWP survives fork() with EVENT_FORK; child's
                     PTEs keep the uffd bit
  rwp-fork-pin       RWP survives fork() on an RO-longterm-pinned
                     anon page (forces copy_present_page()); child
                     read auto-resolves and clears the bit, proving
                     PAGE_NONE was in place
  rwp-wp-exclusive   register with MODE_WP|MODE_RWP returns -EINVAL

All tests run against anon, shmem, shmem-private, hugetlb, and
hugetlb-private memory, except rwp-fork-pin which is anon-only —
copy_present_page() is the private-anon pinned-exclusive fork path.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 884 +++++++++++++++++++
 1 file changed, 884 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index a6c14109e818..bd3b9f41ee35 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -7,6 +7,8 @@
 
 #include "uffd-common.h"
 
+#include <linux/fs.h>
+#include <sys/uio.h>
 #include "../../../../mm/gup_test.h"
 
 #ifdef __NR_userfaultfd
@@ -109,6 +111,10 @@ static void uffd_test_skip(const char *message)
 
 static void test_uffd_api(bool use_dev)
 {
+	const uint64_t expected_ioctls =
+		BIT_ULL(_UFFDIO_REGISTER) |
+		BIT_ULL(_UFFDIO_UNREGISTER) |
+		BIT_ULL(_UFFDIO_API);
 	struct uffdio_api uffdio_api;
 	int uffd;
 
@@ -148,6 +154,15 @@ static void test_uffd_api(bool use_dev)
 		goto out;
 	}
 
+	/* Verify returned fd-level ioctls bitmask */
+	if ((uffdio_api.ioctls & expected_ioctls) != expected_ioctls) {
+		uffd_test_fail("UFFDIO_API missing expected ioctls: "
+			       "got=0x%"PRIx64", expected=0x%"PRIx64,
+			       (uint64_t)uffdio_api.ioctls,
+			       expected_ioctls);
+		goto out;
+	}
+
 	/* Test double requests of UFFDIO_API with a random feature set */
 	uffdio_api.features = BIT_ULL(0);
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == 0) {
@@ -602,6 +617,784 @@ void uffd_minor_collapse_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *
 	uffd_minor_test_common(gopts, true, false);
 }
 
+static int uffd_register_rwp(int uffd, void *addr, uint64_t len)
+{
+	struct uffdio_register reg = {
+		.range = { .start = (unsigned long)addr, .len = len },
+		.mode = UFFDIO_REGISTER_MODE_RWP,
+	};
+
+	if (ioctl(uffd, UFFDIO_REGISTER, &reg) == -1)
+		return -errno;
+	return 0;
+}
+
+static void rwprotect_range(int uffd, __u64 start, __u64 len, bool protect)
+{
+	struct uffdio_rwprotect rwp = {
+		.range = { .start = start, .len = len },
+		.mode = protect ? UFFDIO_RWPROTECT_MODE_RWP : 0,
+	};
+
+	if (ioctl(uffd, UFFDIO_RWPROTECT, &rwp))
+		err("UFFDIO_RWPROTECT failed");
+}
+
+static void set_async_mode(int uffd, bool enable)
+{
+	struct uffdio_set_mode mode = { };
+
+	if (enable)
+		mode.enable = UFFD_FEATURE_RWP_ASYNC;
+	else
+		mode.disable = UFFD_FEATURE_RWP_ASYNC;
+
+	if (ioctl(uffd, UFFDIO_SET_MODE, &mode))
+		err("UFFDIO_SET_MODE failed");
+}
+
+/*
+ * Test async RWP faults on anonymous memory.
+ * Populate pages, register MODE_RWP with RWP_ASYNC,
+ * RW-protect, re-access, verify content preserved and no faults delivered.
+ */
+static void uffd_rwp_async_test(uffd_global_test_opts_t *gopts,
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
+	/* Register MODE_RWP */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	/* RW-protect all pages (sets protnone) */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
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
+ * Fault handler for RWP — unprotect the page via UFFDIO_RWPROTECT.
+ */
+static void uffd_handle_rwp_fault(uffd_global_test_opts_t *gopts,
+				  struct uffd_msg *msg,
+				  struct uffd_args *uargs)
+{
+	if (!(msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_RWP))
+		err("expected RWP fault, got 0x%llx",
+		    msg->arg.pagefault.flags);
+
+	rwprotect_range(gopts->uffd, msg->arg.pagefault.address,
+			gopts->page_size, false);
+	uargs->minor_faults++;
+}
+
+/*
+ * Test sync RWP faults on anonymous memory.
+ * Populate pages, register MODE_RWP (sync), RW-protect,
+ * access from worker thread, verify fault delivered, UFFDIO_RWPROTECT resolves.
+ */
+static void uffd_rwp_sync_test(uffd_global_test_opts_t *gopts,
+				      uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	pthread_t uffd_mon;
+	struct uffd_args uargs = { };
+	bool failed = false;
+	char c = '\0';
+	unsigned long p;
+
+	uargs.gopts = gopts;
+	uargs.handle_fault = uffd_handle_rwp_fault;
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	/* Register MODE_RWP */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	/* RW-protect all pages */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Start fault handler thread */
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
+		err("uffd_poll_thread create");
+
+	/* Access all pages — triggers sync RWP faults, handler unprotects */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+
+		if (page[0] != (p % 255 + 1)) {
+			uffd_test_fail("page %lu content mismatch", p);
+			failed = true;
+			goto out;
+		}
+	}
+
+out:
+	/*
+	 * Stop the handler before reading minor_faults: the last fault
+	 * resolution rwprotect_range()s before incrementing the counter,
+	 * so the main thread can race ahead of the increment.
+	 */
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (failed)
+		return;
+	if (uargs.minor_faults == 0)
+		uffd_test_fail("expected RWP faults, got 0");
+	else
+		uffd_test_pass();
+}
+
+/*
+ * Test PAGEMAP_SCAN working-set discovery via the "hot" (accessed) scan.
+ *
+ * The working-set primitive is to find pages that were accessed: scan for
+ * PAGE_IS_ACCESSED, which is set once an access clears the protnone+uffd
+ * marker.  A VMM treats every access fault as "hot" (RWP here; MINOR/MISSING
+ * for non-resident pages) and reclaims the rest from the backing file.
+ *
+ * We deliberately do NOT use an inverted "cold" scan: that only sees
+ * VMA-resident ptes, so for a file mapping it misses cached-but-unmapped (and
+ * never-faulted, pre-populated) pages, which are pte_none and thus invisible.
+ * Hot tracking + file-level reclaim covers them; a cold pte scan cannot.
+ */
+static void uffd_rwp_pagemap_test(uffd_global_test_opts_t *gopts,
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
+	/* Register and RW-protect */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Touch first half of pages to re-activate them (async auto-resolve) */
+	for (p = 0; p < nr_pages / 2; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	uint64_t start = (uint64_t)gopts->area_dst;
+	uint64_t boundary = start + (nr_pages / 2) * page_size;
+	uint64_t end = start + nr_pages * page_size;
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		err("open pagemap");
+
+	/*
+	 * Hot scan: report the pages that were accessed.  PAGE_IS_ACCESSED is
+	 * set once the protnone+uffd marker is cleared (by the access, async
+	 * auto-resolve here).  The touched first half must come back as exactly
+	 * one hot region [start, boundary); the untouched second half must not
+	 * appear.
+	 */
+	memset(&pm_arg, 0, sizeof(pm_arg));
+	pm_arg.size = sizeof(pm_arg);
+	pm_arg.start = start;
+	pm_arg.end = end;
+	pm_arg.vec = (uint64_t)regions;
+	pm_arg.vec_len = ARRAY_SIZE(regions);
+	pm_arg.category_mask = PAGE_IS_ACCESSED;
+	pm_arg.return_mask = PAGE_IS_ACCESSED;
+
+	ret = ioctl(pagemap_fd, PAGEMAP_SCAN, &pm_arg);
+	close(pagemap_fd);
+
+	if (ret < 0) {
+		uffd_test_fail("PAGEMAP_SCAN failed: %s", strerror(errno));
+		return;
+	}
+
+	if (ret != 1 || regions[0].start != start ||
+	    regions[0].end != boundary) {
+		uffd_test_fail("hot set wrong: got %ld regions [0x%lx,0x%lx), expected 1 [0x%lx,0x%lx)",
+			       ret, (unsigned long)regions[0].start,
+			       (unsigned long)regions[0].end,
+			       (unsigned long)start, (unsigned long)boundary);
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Test that RWP protection survives a mprotect(PROT_NONE) ->
+ * mprotect(PROT_READ|PROT_WRITE) round-trip. The uffd-wp bit on a
+ * VM_UFFD_RWP VMA must continue to carry PROT_NONE semantics after
+ * mprotect() changes the base protection; otherwise accesses would
+ * silently succeed and the pagemap bit would stick without a fault
+ * ever clearing it.
+ */
+static void uffd_rwp_mprotect_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+	struct page_region regions[16];
+	struct pm_scan_arg pm_arg;
+	int pagemap_fd;
+	long ret;
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, 0xab, page_size);
+
+	/* Register and RW-protect the whole range */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			      nr_pages * page_size))
+		err("register failure");
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			nr_pages * page_size, true);
+
+	/* Round-trip mprotect(): PROT_NONE -> PROT_READ|PROT_WRITE */
+	if (mprotect(gopts->area_dst, nr_pages * page_size, PROT_NONE))
+		err("mprotect() PROT_NONE");
+	if (mprotect(gopts->area_dst, nr_pages * page_size,
+		     PROT_READ | PROT_WRITE))
+		err("mprotect() PROT_READ|PROT_WRITE");
+
+	/* Touch every page. Async RWP must auto-resolve each fault. */
+	for (p = 0; p < nr_pages; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	/*
+	 * After touching, no page should remain RW-protected. A stuck
+	 * uffd-wp bit would mean mprotect() silently dropped PROT_NONE and
+	 * the access never faulted.
+	 */
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		err("open pagemap");
+
+	memset(&pm_arg, 0, sizeof(pm_arg));
+	pm_arg.size = sizeof(pm_arg);
+	pm_arg.start = (uint64_t)gopts->area_dst;
+	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
+	pm_arg.vec = (uint64_t)regions;
+	pm_arg.vec_len = ARRAY_SIZE(regions);
+	pm_arg.category_mask = PAGE_IS_ACCESSED;
+	pm_arg.category_inverted = PAGE_IS_ACCESSED;
+	pm_arg.return_mask = PAGE_IS_ACCESSED;
+
+	ret = ioctl(pagemap_fd, PAGEMAP_SCAN, &pm_arg);
+	close(pagemap_fd);
+
+	if (ret < 0) {
+		uffd_test_fail("PAGEMAP_SCAN failed: %s", strerror(errno));
+		return;
+	}
+	if (ret != 0) {
+		uffd_test_fail("expected no cold pages after mprotect()+touch, got %ld regions",
+			       ret);
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Test that GUP resolves through protnone PTEs (async mode).
+ * vmsplice() into a pipe pins user pages via get_user_pages_fast() --
+ * unlike write(), which goes through copy_from_user() and ordinary
+ * hardware page faults -- so it exercises gup_can_follow_protnone() on
+ * the RW-protected PTE. In async mode the kernel auto-restores
+ * permissions and GUP returns the page.
+ */
+static void uffd_rwp_gup_test(uffd_global_test_opts_t *gopts,
+				     uffd_test_args_t *args)
+{
+	struct iovec iov;
+	char buf;
+	int pipefd[2];
+
+	/* Populate first page with known content */
+	memset(gopts->area_dst, 0xCD, gopts->page_size);
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, gopts->page_size))
+		err("register failure");
+
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			gopts->page_size, true);
+
+	if (pipe(pipefd))
+		err("pipe");
+
+	/*
+	 * One byte's worth of iov is enough to GUP the containing page and
+	 * keeps the pipe transfer well under any pipe-capacity limit even on
+	 * hugetlb-backed runs.
+	 */
+	iov.iov_base = gopts->area_dst;
+	iov.iov_len = 1;
+	if (vmsplice(pipefd[1], &iov, 1, 0) != 1) {
+		uffd_test_fail("vmsplice from RW-protected page failed: %s",
+			       strerror(errno));
+		goto out;
+	}
+
+	if (read(pipefd[0], &buf, 1) != 1) {
+		uffd_test_fail("read from pipe failed");
+		goto out;
+	}
+
+	if (buf != (char)0xCD) {
+		uffd_test_fail("content mismatch: got 0x%02x, expected 0xCD",
+			       (unsigned char)buf);
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	close(pipefd[0]);
+	close(pipefd[1]);
+}
+
+/*
+ * Test runtime toggle between async and sync modes.
+ * Start in async mode (detection), flip to sync (eviction), verify faults
+ * block, resolve them, flip back to async.
+ */
+static void uffd_rwp_async_toggle_test(uffd_global_test_opts_t *gopts,
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
+	uargs.handle_fault = uffd_handle_rwp_fault;
+
+	/* Populate */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	/* Phase 1: async detection — RW-protect, access first half */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
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
+	/*
+	 * Stop the handler before reading minor_faults: the last fault
+	 * resolution rwprotect_range()s before incrementing the counter,
+	 * so the main thread can race ahead of the increment. Stopping
+	 * here also makes Phase 3 a clean async-only test -- with the
+	 * handler still running it would silently resolve any sync fault
+	 * the kernel erroneously delivers, masking a regression.
+	 */
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (uargs.minor_faults == 0) {
+		uffd_test_fail("expected sync faults, got 0");
+		return;
+	}
+
+	/* Phase 3: flip back to async */
+	set_async_mode(gopts->uffd, true);
+
+	/* RW-protect and access again — should auto-resolve */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	for (p = 0; p < nr_pages; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	uffd_test_pass();
+	return;
+out:
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+}
+
+/*
+ * Test that RW-protected pages become accessible after closing uffd.
+ */
+static void uffd_rwp_close_test(uffd_global_test_opts_t *gopts,
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
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
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
+/*
+ * Test that RWP protection is preserved across fork() when
+ * UFFD_FEATURE_EVENT_FORK is enabled. Without preservation, the child's
+ * PTEs would lose the uffd-wp marker and RWP-protected accesses would
+ * silently fall through to do_numa_page().
+ */
+static void uffd_rwp_fork_test(uffd_global_test_opts_t *gopts,
+			       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	int pagemap_fd;
+	uint64_t value;
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			      nr_pages * page_size))
+		err("register failed");
+
+	/* Populate + RWP-protect */
+	*gopts->area_dst = 1;
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			page_size, true);
+
+	/* Parent: verify uffd-wp bit is set before fork */
+	pagemap_fd = pagemap_open();
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	pagemap_check_wp(value, true);
+
+	/*
+	 * Fork with EVENT_FORK: child inherits VM_UFFD_RWP. Child reads
+	 * its own pagemap and must still see the uffd-wp bit set.
+	 */
+	if (pagemap_test_fork(gopts, true, false)) {
+		uffd_test_fail("RWP marker lost in child after fork");
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	close(pagemap_fd);
+}
+
+/*
+ * Test that RWP protection on a pinned anon page is preserved across fork().
+ * Pinning forces copy_present_page() in the child path, which must restore
+ * PAGE_NONE on top of the uffd bit. Using async mode, a read in the child
+ * auto-resolves if — and only if — the PTE was actually protnone+uffd; the
+ * cleared uffd bit afterward proves the fault path ran.
+ */
+static void uffd_rwp_fork_pin_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *args)
+{
+	unsigned long page_size = gopts->page_size;
+	fork_event_args fevent_args = { .gopts = gopts, .child_uffd = -1 };
+	pin_args pin_args = {};
+	int pagemap_fd, status;
+	pthread_t fevent_thread;
+	uint64_t value;
+	pid_t child;
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, page_size))
+		err("register failed");
+
+	/* Populate. */
+	*gopts->area_dst = 1;
+
+	/* RO-longterm pin so fork() takes copy_present_page() for this PTE. */
+	if (pin_pages(&pin_args, gopts->area_dst, page_size)) {
+		uffd_test_skip("Possibly CONFIG_GUP_TEST missing or unprivileged");
+		uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+		return;
+	}
+
+	/* RWP-protect: PTE is now PAGE_NONE + uffd bit. */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
+
+	pagemap_fd = pagemap_open();
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	pagemap_check_wp(value, true);
+
+	/*
+	 * UFFD_FEATURE_EVENT_FORK is required so the child inherits
+	 * VM_UFFD_RWP and the marker; without it dup_userfaultfd() resets
+	 * the child VMA and the test would pass for the wrong reason.
+	 * dup_userfaultfd() blocks until the EVENT_FORK message is consumed,
+	 * so spawn a reader before the fork().
+	 */
+	gopts->ready_for_fork = false;
+	if (pthread_create(&fevent_thread, NULL, fork_event_consumer,
+			   &fevent_args))
+		err("pthread_create() for fork event consumer");
+	while (!gopts->ready_for_fork)
+		; /* Wait for consumer to start polling. */
+
+	child = fork();
+	if (child < 0)
+		err("fork");
+	if (child == 0) {
+		volatile char c;
+		int cfd;
+
+		/*
+		 * Read the pinned page. Only reaches the fault path if the
+		 * child PTE is protnone + uffd; async mode auto-resolves and
+		 * clears the uffd bit. If copy_present_page() dropped
+		 * PAGE_NONE, the read would silently succeed and the bit
+		 * would still be set.
+		 */
+		c = *(volatile char *)gopts->area_dst;
+		(void)c;
+
+		cfd = pagemap_open();
+		value = pagemap_get_entry(cfd, gopts->area_dst);
+		close(cfd);
+		_exit((value & PM_UFFD_WP) ? 1 : 0);
+	}
+	if (waitpid(child, &status, 0) < 0)
+		err("waitpid");
+	if (pthread_join(fevent_thread, NULL))
+		err("pthread_join() for fork event consumer");
+	if (fevent_args.child_uffd >= 0)
+		close(fevent_args.child_uffd);
+
+	unpin_pages(&pin_args);
+	close(pagemap_fd);
+	if (uffd_unregister(gopts->uffd, gopts->area_dst, page_size))
+		err("unregister failed");
+
+	if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
+		uffd_test_fail("RWP not enforced in child after pinned fork");
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * A non-exclusive (forked, COW-shared) anon page that is RWP-protected and
+ * then swapped out must keep tracking across swap-in. On the write that
+ * swaps it back in, do_swap_page() restores PAGE_NONE and the access retries
+ * through the RWP fault path, instead of being COWed straight to a fresh
+ * accessible page -- which would silently drop the marker for a non-exclusive
+ * folio. Sync mode lets us observe the fault directly: with the bug, the
+ * write COWs without delivering any RWP fault.
+ *
+ * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
+ */
+static void uffd_rwp_swap_cow_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *args)
+{
+	unsigned long page_size = gopts->page_size;
+	struct uffd_args uargs = { };
+	int pagemap_fd, go[2], i;
+	pthread_t uffd_mon;
+	char c = '\0';
+	pid_t child;
+
+	uargs.gopts = gopts;
+	uargs.handle_fault = uffd_handle_rwp_fault;
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, page_size))
+		err("register failed");
+
+	/* Populate one page (exclusive at this point). */
+	*gopts->area_dst = 0x11;
+
+	/* RWP-protect: PTE becomes PAGE_NONE + uffd bit (still exclusive). */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
+
+	/*
+	 * Swap the page out while it is still exclusive: a shared (forked)
+	 * folio does not get reclaimed by MADV_PAGEOUT. Retry, since a hot
+	 * page may just be rotated on the first reclaim pass.
+	 */
+	pagemap_fd = pagemap_open();
+	for (i = 0; i < 100; i++) {
+		if (madvise(gopts->area_dst, page_size, MADV_PAGEOUT))
+			err("MADV_PAGEOUT");
+		if (pagemap_is_swapped(pagemap_fd, gopts->area_dst))
+			break;
+		usleep(10000);
+	}
+	if (!pagemap_is_swapped(pagemap_fd, gopts->area_dst)) {
+		uffd_test_skip("MADV_PAGEOUT did not swap the page; is swap enabled?");
+		close(pagemap_fd);
+		uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+		return;
+	}
+
+	/*
+	 * fork() now: the child duplicates the swap entry, so the slot becomes
+	 * non-exclusive. The child parks (keeping the reference) until the
+	 * parent has faulted the page back in.
+	 */
+	if (pipe(go))
+		err("pipe");
+	child = fork();
+	if (child < 0)
+		err("fork");
+	if (child == 0) {
+		close(go[1]);
+		read(go[0], &c, 1);
+		_exit(0);
+	}
+	close(go[0]);
+
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
+		err("uffd_poll_thread create");
+
+	/*
+	 * Write the page: swaps it back in (do_swap_page) on a non-exclusive
+	 * folio with FAULT_FLAG_WRITE. The marker must survive and deliver an
+	 * RWP fault rather than COW silently.
+	 */
+	*gopts->area_dst = 0x22;
+
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join failed");
+
+	if (uargs.minor_faults == 0)
+		uffd_test_fail("no RWP fault on swapped-in non-exclusive page");
+	else
+		uffd_test_pass();
+
+	close(pagemap_fd);
+	if (write(go[1], &c, 1) != 1)
+		err("child release");
+	close(go[1]);
+	waitpid(child, NULL, 0);
+}
+
+/*
+ * WP and RWP share the uffd-wp PTE bit and cannot coexist in the same VMA.
+ * Registration requesting both modes must be rejected.
+ */
+static void uffd_rwp_wp_exclusive_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	struct uffdio_register reg = { };
+
+	reg.range.start = (unsigned long)gopts->area_dst;
+	reg.range.len = nr_pages * page_size;
+	reg.mode = UFFDIO_REGISTER_MODE_WP | UFFDIO_REGISTER_MODE_RWP;
+
+	if (ioctl(gopts->uffd, UFFDIO_REGISTER, &reg) == 0) {
+		uffd_test_fail("register with WP|RWP unexpectedly succeeded");
+		return;
+	}
+	if (errno != EINVAL) {
+		uffd_test_fail("register with WP|RWP: expected EINVAL, got %d",
+			       errno);
+		return;
+	}
+	uffd_test_pass();
+}
+
 static sigjmp_buf jbuf, *sigbuf;
 
 static void sighndl(int sig, siginfo_t *siginfo, void *ptr)
@@ -1604,6 +2397,83 @@ uffd_test_case_t uffd_tests[] = {
 		/* We can't test MADV_COLLAPSE, so try our luck */
 		.uffd_feature_required = UFFD_FEATURE_MINOR_SHMEM,
 	},
+	{
+		.name = "rwp-async",
+		.uffd_fn = uffd_rwp_async_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-sync",
+		.uffd_fn = uffd_rwp_sync_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_RWP,
+	},
+	{
+		.name = "rwp-pagemap",
+		.uffd_fn = uffd_rwp_pagemap_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-mprotect",
+		.uffd_fn = uffd_rwp_mprotect_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-gup",
+		.uffd_fn = uffd_rwp_gup_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-async-toggle",
+		.uffd_fn = uffd_rwp_async_toggle_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-close",
+		.uffd_fn = uffd_rwp_close_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_RWP,
+	},
+	{
+		.name = "rwp-fork",
+		.uffd_fn = uffd_rwp_fork_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_EVENT_FORK,
+	},
+	{
+		.name = "rwp-fork-pin",
+		.uffd_fn = uffd_rwp_fork_pin_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC |
+		UFFD_FEATURE_EVENT_FORK,
+	},
+	{
+		.name = "rwp-swap-cow",
+		.uffd_fn = uffd_rwp_swap_cow_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_RWP,
+	},
+	{
+		.name = "rwp-wp-exclusive",
+		.uffd_fn = uffd_rwp_wp_exclusive_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP |
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
+	},
 	{
 		.name = "sigbus",
 		.uffd_fn = uffd_sigbus_test,
@@ -1814,6 +2684,20 @@ int main(int argc, char *argv[])
 				uffd_test_skip(errmsg);
 				continue;
 			}
+			/*
+			 * RWP tracks protection on ptes; a THP-backed shmem/anon
+			 * range (e.g. shmem_enabled=always) would split on
+			 * rwprotect and change behaviour under the test. Keep
+			 * such ranges off THP. hugetlb is huge by definition and
+			 * rejects MADV_NOHUGEPAGE, so skip it.
+			 */
+			if ((test->uffd_feature_required & UFFD_FEATURE_RWP) &&
+			    !(mem_type->mem_flag & (MEM_HUGETLB | MEM_HUGETLB_PRIVATE))) {
+				unsigned long len = gopts.nr_pages * gopts.page_size;
+
+				if (madvise(gopts.area_dst, len, MADV_NOHUGEPAGE))
+					err("madvise(MADV_NOHUGEPAGE)");
+			}
 			test->uffd_fn(&gopts, &args);
 			uffd_test_ctx_clear(&gopts);
 		}
-- 
2.54.0


