Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B849CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FD926B009B; Tue, 26 May 2026 09:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4E86B009D; Tue, 26 May 2026 09:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5290F6B009F; Tue, 26 May 2026 09:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35A596B009B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:06:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1E9512034D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:06:06 +0000 (UTC)
X-FDA: 84809593932.21.6C10E1F
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf28.hostedemail.com (Postfix) with ESMTP id BEF81C0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:06:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=HkPCh+NH;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B 7u3p3U";
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOz+0brXo9TSVG/xiKRnhSykq2dVBP2jzZ+IvBYXcOM=;
	b=Ko565HjE8IdBj6wmII6k1pgQL3bYD5os12roydfOiisCh5P4k40VgdAh9+jGHCME2UMLmk
	fQR4qWN+6mU7SGb2mw9RFZ/AR/Et1aOtOmfH6NPUNS0R5wdk0QjWMXDJ7LTKuvk+7yjmph
	cPcg7mlRvoAk65E8qm3mGnZ5r+ncRYI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=HkPCh+NH;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B 7u3p3U";
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800764; a=rsa-sha256;
	cv=none;
	b=odh7ZYHgWl1Sr984QBYmEHCJ/n5T74snL9Dvl/02lEZ2RznMrqql+53l9qruCOKhJbq+xE
	ZbLuXT6WItKozFl/kN3OEQi/TPbEgtZbdbyHehZWJ2se/b8tyvuZz/g1Op3N07abSxvv4M
	atrK34lt1BdOJEbZV0fRbDxKcigBI0c=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 983197A0176;
	Tue, 26 May 2026 09:06:03 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 26 May 2026 09:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779800763; x=1779887163; bh=eOz+0brXo9TSVG/xiKRnhSykq2dVBP2j
	zZ+IvBYXcOM=; b=HkPCh+NHQwTr+ian2JPVFnUaSxtiRn7LfDKcAPkGpzsoL0nR
	G81z42d3nHL7pEhHozpPaxrNFhNt/CyFvxCwo7ZWnZcoHY2z+N52jd3hPQm82AMP
	+X60UbEtFM8V2M2MEQUFnk/IzAGvnE5EUfylxBSXc0x4jQkh4Z9lzQt1jlKLVpcK
	JxABYGjCZpByUmdCDHsb6c98DMMzz7Dker882IS9OBH1MXth40vuzqumZV/F0KbR
	Dr4o40fc6OZWJhZsEbXp5PIEpAwM6TFtZ55YRmAKZa3aBk0DP4xQO6a2GyOTSCLj
	fPaiNFCpYmfg6XJ9oqW+UyRGFr/XuUUzZTCaLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779800763; x=
	1779887163; bh=eOz+0brXo9TSVG/xiKRnhSykq2dVBP2jzZ+IvBYXcOM=; b=B
	7u3p3UHDvz/GV5rsArcC26PET9qGWp1Bsus2dnqtsgDmmpipEVIVGfzv/YW3L2tf
	Gt5dCwdsv1ZZu9VkC7cozbahR5ikeV8A/yPwQ1k47fJbHM6eTPaDEN7gfQR3abbE
	c2Q0fyofQcY4Wmx8IXP84HSLX3uaLQuhfXhrKgxwucWXN4WqpmvPY2Q82YEcsRx+
	Ddk2rQY/xrikq8ofOVFL5Pl55BiaK0PN/8VaNYs94doM9svDzJOcMzJw4boTzBQw
	kExMATsH1TYN2ySkRwvJKNjCRqM6TF0poIcHTXVGGW2HYSIqjwGpXCANJvm2gxI/
	gjEjfFAEGVKDt4dtlCLXg==
X-ME-Sender: <xms:u5oVajiVDbmB_jHoLWxvwsQi4v9MO4OD0xeM3jmo80VBqttlvfzY4w>
    <xme:u5oVaj8go-wgbG5Es4bCW8uliDpD9bQQV3Xkp599uHwLg56fHVmmxeFfBDseGQNHw
    MsayXS7aM19oCCGOTTFxGRei-x78KD2tiaRPDCGezQtCsgVP_U-GIs>
X-ME-Received: <xmr:u5oVarmUPvX0z01qyj-tzYQ9J_6YKI4VX_UkTeLCL3gLk5Lnniuqssu8G9O5VA>
X-ME-Proxy-Cause: dmFkZTFRxKInQFecwZPuEt+LuNBlOJGP8RsxGpm588gQviVhNq1Pa+AqWD7JQeVUR2Swte
    eyzLZOEYFGJPBoftF7cmhN7hkCk3wRua/o4v8Bw72KaC1CFplNf1sAsIMRN76GRZVrrXJo
    4g3If4FQDoPgtrZ9saDLAexzQgvrfsTwQ3/KP0AGKCFmLiVvQMOmXCsts9ZOCGk1E95eOU
    mgzRkXibxyISOqgf2hZqBdgrV6ktnG5u3x8/zXY22S6cQZP9xSB0eE/pqpJrpVnOId2p4l
    G0binpu+ah/FFZH0esjGo/wTdPAqY9SKUVzl+zWcrHaZzSyBzEWlNRkrUo/n9HkffJzpMI
    rBdKczXG69UeuPoqgq3OhcTnRfp8BVktpV9GIjADXWZcobs2IqSa8Ff8CDv5FMsBfjhSBh
    edLmMFE3ebqGb4wW/zccR0JxojNzk99oqMYoEBMD3rUuLzKMPZeqnskHcV5BvQBDKjx5iC
    C0Yc4A7Fl7pQTLDywDgzX7wuHks4kmSNkp7XCLPMkZKpuMO1p1rl/BoLtD1txNSXIi1+P1
    7cr9BzA5Ta3j/2pqYKq6MH5/kASkQhPYtCII2PMFRivC9/xsrt6N4LMgtJsG9u6116cXW+
    5nlqQoTTh3veHOLV6uwiL/pf5W6ZPvTPvSPDFZhngpzNr091Yd8LU70EOR1w
X-ME-Proxy: <xmx:u5oVap2Zq59XHQTEQM7Slei_wWfy5X1avIvQR09FKsqY-OE_LabubA>
    <xmx:u5oVaoTIl7ng5htYXm3FNnDmoRQtROZxLNPQYWeyCj3fiVbsirjrbA>
    <xmx:u5oVahMKwLQJhKOeIfQ7IIUZS0_RYgfFPEkwgD0rpQpR3ji3Ipepvg>
    <xmx:u5oVakiCRpKtwmtsW-fnJyUz7LpR-W-zB8_4B4AAcT5_I6uJ20U67A>
    <xmx:u5oVapgdaxxGiqmT_OVGX6OeKwNQ1weP3lhi4fOoBZqBL9TELYe_VHyc>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:06:02 -0400 (EDT)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 17/18] selftests/mm: add userfaultfd RWP tests
Date: Tue, 26 May 2026 14:05:05 +0100
Message-ID: <20260526130509.2748441-18-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEF81C0002
X-Stat-Signature: nr8q7f9a1rpkint4rtxxa5ks897bnn4t
X-HE-Tag: 1779800764-10488
X-HE-Meta: U2FsdGVkX1+zCzFMFf28NLp4GN/rP1NI1+QXbhM/h9gL3eZufU7yuPFIE+m4HZwdEYiUvn8KzfL1UKURrsQEMJ6Ej7Q9HnJC1aedAftsVHKloXT0/7RT/BYgY3eJW7+3Ss/C/cefXr9yqw6xdu29r/wTjg7dLak3/uBhdTDM+VEu7mhhNXtRRR97eqpSrewjyTP9rF2XFXQwFH3uxuCZB0vRvvsIuV0alHA8aSABYZN8bKYGBjQqeJuQVFN7q41PLjPeqhpeoeZouezbfAh+kH8lX8Y5z0F0/VcWkDQIMjQJ+M60r7uh7lo+8Ve7LFis1S8BaLXZi/DtERb1Aq9guLGZWY6Rkx/8sNiQGgTzHxyw8DBuYsHCzaiDRERuYhA/XSx0uo8YZ7DR3/UyyVYTeC95rZMS5YjOzYtp7YqdpkN0iszbCM8BpFgyJ69aJQSVD44TFUBUbRbeyRXq/pNNucBEtiotl5kPJ59qVETPDWLdMYmWU1Ac54wSd5H7HzHtAi+vS1Hw0MD1Lr9eSI07HKGRVtcLVnv4joKjIPSKrl5QLdtdextJ8+S6M7QjdrEATrgxCgHWvUWKq/gcP6rO1+piE/B4bcNy35/vMz9JaynFpj7EyGiSTZzdpMvIhRyd34v4BfMeyuO3WqY8Tzf3rEU07n9/sMFwtbyRDYqGEQuXzWgBCUcRvyhiIWFrCaU+bRemVu/7gKNbXSQtAr1u/gBa7FjbzvkYIiyE4MgOIhXn/EJ2WpHybAotG/9aHOZeQLtBp2K3v1NsIUTsd+2/LNSvoOuOSlgqEdU4UGXEp80OZKIxut+eAr/SfZxuoOT/iv3MyRV1gY2f/tQ+D0dL/bvFL5upyQ5BZTriwTq1jOLEsyOIpdBE7lbnivY+UY2wIa4+Y+juNnz4AslZQGRxbuwwclxbI8/rHduKZ+nwPSp5XhU2fmBwIzZEwgCK/a/EYJ6MV7dbDwsdc5LAkeA
 x0jC/m/h
 4v+lJf9fJZkTMWbJb3xWBXbUbxYZbD1b7pAi9JPPtJCnRWC+JAgbgsc3HulZoOaDKk/7RGxyw007sie1+aTBtuyR33KkzDDCZ/V6o8Iu4k+1FsEmGTUaACtYqFj79svMDauOZAc4GRX6SGLmhbSF4LFJELDiS6H45Gt6Fe99CtaNZAKjJBMBw2+Ma1NVV0PgViQChFVsuItVA8o5lLdhkxsRZ0+Iw4OcTnZv9RYp+k3x19Q2A0AbsbRg6/2/S2njY95jOEj+lp4XuI5pMcb5K+kIWIjdHR857bFbvZ/vLY7cjWs8lwiDV5Pzbbt8dPLFQU8dvBmR5FbL/3cukaDbkiZxeOd+dTSxHU0fg6kYqgg52KX38N44ckL7zSMvrYDtdELQjgUpSriHAQlIPnhEft6Kimo3HuaNEV8jZXWLEB+H8dIyODoXKisg7SQc0oWC/ONkGuWQH9fsPryAPJLszaiIOwWUuIorhbQSRxi4Vw0/cgCXTzOoiRAe3r9/zJfGp150MXEZRSLQk4a0P7yStY+EBFxR+ysccZz7iz+4+fK8HYAbBpNdnc1LOngq2riNT5tUwde3uiE3WwP5FYdGafF8mTgFZntiJtJf6Atk+WWrLcEJHo6zMdStuL2YsrLgkeNHzeJOvdL9HDJr7s8m86TCaDW2Ree8we69N
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
 tools/testing/selftests/mm/uffd-unit-tests.c | 765 +++++++++++++++++++
 1 file changed, 765 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index a6c14109e818..9f5a5ccf6044 100644
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
@@ -602,6 +617,685 @@ void uffd_minor_collapse_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *
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
+ * Test PAGEMAP_SCAN detection of RW-protected (cold) pages.
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
+	/* Scan for cold (still RW-protected) pages */
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		err("open pagemap");
+
+	/*
+	 * PAGE_IS_ACCESSED is set once the uffd-wp bit has been cleared
+	 * (access happened, or the user resolved). Invert it to select
+	 * still-protected (cold) pages.
+	 */
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
+
+	/*
+	 * The second half of pages should be reported as RW-protected.
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
@@ -1604,6 +2298,77 @@ uffd_test_case_t uffd_tests[] = {
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
-- 
2.54.0


