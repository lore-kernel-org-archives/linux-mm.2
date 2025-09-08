Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C1DDCAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02EA46B000C; Mon,  8 Sep 2025 08:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3756B000D; Mon,  8 Sep 2025 08:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE39F6B0012; Mon,  8 Sep 2025 08:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7FE46B000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:48:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A2AF138719
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:48:18 +0000 (UTC)
X-FDA: 83866061076.20.6469491
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id DFE921C000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:48:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W1uoCkuP;
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757335696; a=rsa-sha256;
	cv=none;
	b=srHCYFD1wwCOxiJpqy5GaB/qxrvXyOwZqRxjs+PdndtPMUmV3/U06XHktNwJpScoMqGemO
	OGzVKQlIhttTzIUGZT4lP9fj3TCU0fR/gyZ7Q1IQwiRUDoUZnWbghqU5jiBeOFghFgxvI8
	3DT4yUk1+NiHcW1vkAiFXUZbTxN/m20=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W1uoCkuP;
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757335696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1wY981ud5Z3idUNSxCEbfzkX8eAnGBWH4r/ijktaZU=;
	b=7iW7OxpIhlbEefYj2kKvYtcBJv2FU5MFpD0uxLdTwG1SD3WPTvEfr1T+qFAaFnkb1D3V4G
	U2SFFXCic5b9LYA0MoLbELtDJHX75YynvV2OHwe7vjUGC6Kefdut0sLRZcpl6ojKITHRGQ
	D2luZ0Do87erGMmpP8GdwK5mu9NAqOg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757335696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1wY981ud5Z3idUNSxCEbfzkX8eAnGBWH4r/ijktaZU=;
	b=W1uoCkuPsgBcipDlWZiSR5NfVPl4p1MmapTKIhmMnFyeeqKIZwuxuwQTjlYEJ5/UoPrxU1
	4BZcRJbnp8jIrWUBgTf3J86ryInnelcDA1daxhyjbnM+BVUyLHD4UmcM4od8sZluQEY5N9
	Tt269j9I/PnYwI/4ZRZ10r8b5SbuAfI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-354-bEnPIl8DNjOC7LI3ZP-KAg-1; Mon,
 08 Sep 2025 08:48:12 -0400
X-MC-Unique: bEnPIl8DNjOC7LI3ZP-KAg-1
X-Mimecast-MFC-AGG-ID: bEnPIl8DNjOC7LI3ZP-KAg_1757335690
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5675F1955F27;
	Mon,  8 Sep 2025 12:48:10 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB92E300018D;
	Mon,  8 Sep 2025 12:48:04 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	shuah@kernel.org,
	linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chuhu@redhat.com
Subject: [PATCH v2 3/3] selftests/mm: fix va_high_addr_switch.sh failure on x86_64
Date: Mon,  8 Sep 2025 20:47:39 +0800
Message-ID: <20250908124740.2946005-4-chuhu@redhat.com>
In-Reply-To: <20250908124740.2946005-3-chuhu@redhat.com>
References: <20250908124740.2946005-1-chuhu@redhat.com>
 <20250908124740.2946005-2-chuhu@redhat.com>
 <20250908124740.2946005-3-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFE921C000B
X-Stat-Signature: g9bbbw4n3i913s5cxqcodja534q8qura
X-Rspam-User: 
X-HE-Tag: 1757335696-711562
X-HE-Meta: U2FsdGVkX18P6G59/2eJrXoiRjdt2cHDNgnaNbZpL8Tgdq7lodrDk3ybwC8/XZBxzp8Ds0tGjvGkna1oyly+PWoxm9BAGdpKNL6aYHqpQw7injUBN3m3icYFopWYeb3LaIASZfCW90oQEjHx3sDq5d9Dbh+jv9b48h4JZGFNuSNcspmPn2UPOvr3iLYDuKH8+LYZt+DHKCQ+kLu5b9McFQ4Hr0ycOpwcMNGbOi91gVFN7GdKKt/M4lqD/nJ5s3A3g5mlQrq1I57gVkR4K83ZCFHizsH5BSlvcOSNuU502hlPSXE9KoRsesMh4Tf6RKEYED28dHXem4nXrXAcPXZtRYTnepheOCzUut8aVnO5evG1K/ELTEq0XhDdvO+xZ5Zou+wGmB+8qlT+pJM5sD0ZB5v1xiwXVW3tzwcMJLBYPevAxbHF6fv7Su/cRLIn/kdWYcgaYncPCIktEywBuNqE7coJIRUlUwOnH7GmgUntyxuIRFJuWwZwxkde4U7mxVXjn7bfV1oOaDJZEdc/J1KvkdijF+728Cw6P8npZjhULSfGKk5U5N0QMmZnzEY6NTCcmWvN2TXWo2tRUF02gEY/euOo4ZPr5UJuiISUhUksdn5BLelih2WhqIq3e9Hid3pZ3oWYeN+k17iwb7DWGStgk85KGH1pzulQjHIbxS7Brqi7NguOjzt2DEptR0ez1hn4BgjPTIFhgZD22VXUxmDVHAcNcbJ/VQg1jVjFYtrG0er1dECnhuH/RpHWe4LM87ztv+jcS4H/EyPWC5rU0LxnvUmtRtxTXNyR4XVcxr+lVpSFM70F97NRz96pvoo0qXVSY1iVx/DAdtejdhIam4PxVOpgFYYvMEEegFl9P+lqzYf+6XFAG8W90AXHfX9A6+ccBJYU06UBnjatcheo/GU9EIT9/N+niI1iHWJ6gnrjgTOGuLMYx2ixS+PFzTht1Wzm34e5y8gdJnEqplh5CP4
 9gjNizEb
 XhS1+hSgdvBnNpGBe1P9GP0jbIim+VjUZQWw5JgHdHQhBbGWNrUe7qoZfpXKzVW26TuRF+lmG3pyu21aX/GSKZfo1OZ3pv5kGc/dqbIrd1oJk109+ezSiDw/+/MpBannSrkCJsnISfLhxJ5JufRFR1Qzv/dV8UWV5YqwD2koVvDwrfaP00X7phAok5RXeHWfe1g+iS0magPPVVy//Sjd0CEMvpSPYAZgWe9QE6jSggf1WdPEgswxgzIRX2ENHBpH+i/vii6dv+z0aEqDi0HZ0oMmypccEKzIpGfFKDnD89K18Au/D8nCLG7dCBBd8NURhqN7PAOXsEtnKa5ThEogMfbckJzxWXbA/Gtm3FSjhEY9/dBAXYoC04S5is8/n+y4FTsnh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test will fail as below on x86_64 with cpu la57 support (will skip if
no la57 support). Note, the test requries nr_hugepages to be set first.

  # running bash ./va_high_addr_switch.sh
  # -------------------------------------
  # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
  # mmap(addr_switch_hint - pagesize, (2 * pagesize)): 0x7f55b60f9000 - OK
  # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
  # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
  # mmap(NULL): 0x7f55b60f9000 - OK
  # mmap(low_addr): 0x40000000 - OK
  # mmap(high_addr): 0x1000000000000 - OK
  # mmap(high_addr) again: 0xffff55b6136000 - OK
  # mmap(high_addr, MAP_FIXED): 0x1000000000000 - OK
  # mmap(-1): 0xffff55b6134000 - OK
  # mmap(-1) again: 0xffff55b6132000 - OK
  # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
  # mmap(addr_switch_hint - pagesize, 2 * pagesize): 0x7f55b60f9000 - OK
  # mmap(addr_switch_hint - pagesize/2 , 2 * pagesize): 0x7f55b60f7000 - OK
  # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
  # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
  # mmap(NULL, MAP_HUGETLB): 0x7f55b5c00000 - OK
  # mmap(low_addr, MAP_HUGETLB): 0x40000000 - OK
  # mmap(high_addr, MAP_HUGETLB): 0x1000000000000 - OK
  # mmap(high_addr, MAP_HUGETLB) again: 0xffff55b5e00000 - OK
  # mmap(high_addr, MAP_FIXED | MAP_HUGETLB): 0x1000000000000 - OK
  # mmap(-1, MAP_HUGETLB): 0x7f55b5c00000 - OK
  # mmap(-1, MAP_HUGETLB) again: 0x7f55b5a00000 - OK
  # mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB): 0x800000000000 - FAILED
  # mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0x800000000000 - OK
  # [FAIL]

addr_switch_hint is defined as DFEFAULT_MAP_WINDOW in the failed test (for
x86_64, DFEFAULT_MAP_WINDOW is defined as (1UL<<47) - pagesize) in 64 bit.

Before commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
functions"), for x86_64 hugetlb_get_unmapped_area() is handled in arch code
arch/x86/mm/hugetlbpage.c and addr is checked with map_address_hint_valid()
after align with 'addr &= huge_page_mask(h)' which is a round down way, and
it will fail the check because the addr is within the DEFAULT_MAP_WINDOW but
(addr + len) is above the DFEFAULT_MAP_WINDOW. So it wil go through the
hugetlb_get_unmmaped_area_top_down() to find an area within the
DFEFAULT_MAP_WINDOW.

After commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
functions").  The addr hint for hugetlb_get_unmmaped_area() will be rounded
up and aligned to hugepage size with ALIGN() for all arches.  And after the
align, the addr will be above the default MAP_DEFAULT_WINDOW, and the
map_addresshint_valid() check will pass because both aligned addr (addr0)
and (addr + len) are above the DEFAULT_MAP_WINDOW, and the aligned hint
address (0x800000000000) is returned as an suitable gap is found there,
in arch_get_unmapped_area_topdown().

To still cover the case that addr is within the DEFAULT_MAP_WINDOW, and
addr + len is above the DFEFAULT_MAP_WINDOW, make the addr hint one
hugepage lower, so that after the align it's still within DEFAULT_MAP_WINDOW,
and the addr + len (2 hugepages) will be above DEFAULT_MAP_WINDOW.

Fixes: cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*} functions")
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/va_high_addr_switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 896b3f73fc53..bd96dc3b5931 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -230,10 +230,10 @@ void testcases_init(void)
 			.msg = "mmap(-1, MAP_HUGETLB) again",
 		},
 		{
-			.addr = (void *)(addr_switch_hint - pagesize),
+			.addr = (void *)(addr_switch_hint - pagesize - hugepagesize),
 			.size = 2 * hugepagesize,
 			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-			.msg = "mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB)",
+			.msg = "mmap(addr_switch_hint - pagesize - hugepagesize, 2*hugepagesize, MAP_HUGETLB)",
 			.low_addr_required = 1,
 			.keep_mapped = 1,
 		},
-- 
2.49.0


