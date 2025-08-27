Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19795C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 07:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F5A8E0129; Wed, 27 Aug 2025 03:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FDE8E0105; Wed, 27 Aug 2025 03:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216FE8E0129; Wed, 27 Aug 2025 03:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4318E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:52:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD3AD1A04EE
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:52:42 +0000 (UTC)
X-FDA: 83821770564.22.69D4DB4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id EDCD41C0003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:52:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CmBDOZ98;
	spf=pass (imf21.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756281161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1wY981ud5Z3idUNSxCEbfzkX8eAnGBWH4r/ijktaZU=;
	b=2ULNUYpx5nAXBjrOlTUVEV50OHg+QzwyANqwpycCbCMaryFpB5FLSYXVYw7pNcuMy5WzUh
	VJZHhCRTop6Y7s+gnXXjAm7jurW/mN42p1d+Q5ArWhYY17OsW95O5rYRQiQgcpw2WNX+4S
	HsX8DNnh1nwEClQTTRp2cYmRWKsXenI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CmBDOZ98;
	spf=pass (imf21.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756281161; a=rsa-sha256;
	cv=none;
	b=YW4zOBlRjPiXzWhrLu2QriYUa0PzwSSVOrlvLo3dRD4hEvuoFLeaR484qKwGAS3teegVo8
	Md/sBPNKgZ3B0zJA/h4z5ILigqHhhpLm2NUhmC7zbxDbqfu5MfOALpmgOC9pYuILobbyH7
	cSIX2/iATcEDlTDWYQ3u8QG8N2bX6Sk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756281160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1wY981ud5Z3idUNSxCEbfzkX8eAnGBWH4r/ijktaZU=;
	b=CmBDOZ98rZgaRazAM8O5QWAykD4Kkreiq9QPammKRPdeHGL492AVa/9wUREVPE4nJoKROp
	dFt1vjlgcNw1RfOgodX5glXcJECKM0c2ylGQoMEJGtyHmj3BnoF/Rfi9DNBjVjBsuIhsZd
	ckV0xQXWiEy48RHwn8Pceiue6xGMOOg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-7-GMmW_7OAKFJQWdoOe6_w-1; Wed,
 27 Aug 2025 03:52:36 -0400
X-MC-Unique: 7-GMmW_7OAKFJQWdoOe6_w-1
X-Mimecast-MFC-AGG-ID: 7-GMmW_7OAKFJQWdoOe6_w_1756281154
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EEFC1955F01;
	Wed, 27 Aug 2025 07:52:34 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBC631800447;
	Wed, 27 Aug 2025 07:52:27 +0000 (UTC)
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
Subject: [PATCH 2/2] selftests/mm: fix va_high_addr_switch.sh failure on x86_64
Date: Wed, 27 Aug 2025 15:52:09 +0800
Message-ID: <20250827075209.2347015-3-chuhu@redhat.com>
In-Reply-To: <20250827075209.2347015-2-chuhu@redhat.com>
References: <20250827075209.2347015-1-chuhu@redhat.com>
 <20250827075209.2347015-2-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: 89jypuf5n5x1i3mrgob7h748zxh1e4c5
X-Rspam-User: 
X-Rspamd-Queue-Id: EDCD41C0003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756281160-933527
X-HE-Meta: U2FsdGVkX18EEqp1XHGbx6kFBauBUz7SDCTHXHwxNlnGiRPi8BZoWAsSN81NGvWPWIOWshDw8/EHzztHjJ1wd1MTI6/2dWWAxnZOvdnF5cedDthAnsJRU6P6HUUmLK5ks9dEv+2boS5jW0j77zo8oHDcWWdZGM0FzeVY6L8IjuTHYmszEZPfv6wVuv7WbqnLJBJmVGueILWZGbdbV9EpYDnS6pOc2T391aaqeGqW58EksNtQ/47rwxziUJLWG0XSBJx6Py9wkucEswdAss1oaet1mANbhh2MwZ8jIti3ySqCWv2dIHeAUcCfsDuaBllecNet5DxUfwZTpN1rP5pzRwmojloqn4U8xfque4smLXCa0qcOmGOiTm+bq25sCPyutej2ivJ5uA/WlCWO23mjNK0XY7s73SptPlsIjIWRc50q4P0LqZ7HHx+G38NnF5GNLVeOZkjp6cmaOGCt2qnXFJA/r1bpgTozH9XC4ulQD+CCvdWkUAsWWsMwb+c8tZ5pk2bm4CteI4JHXMTI/hlypd4h0uSm+kfwPMhWEdlt7YoBb1USMpaQgbpdPLgrDxoTknIaW3UhzjPckAObdv+ILA0aT+KLakprSCyGR0U0wD9Dm26zPwaoEZ0vXwq4sVJJVp9Qz85YtPNbYl6rr7izCfgfyxZQjKPaJWtnAVShLc0t2WyOrlNZyK6V0aB/nCZ1s4Mwx8uKpTpYINiBLmFIAsFpMKCl7grYUNm6W3tSWCgZ0LtBBQunHqs/aEhee4F/Olv+Zl0l7hcSjnekSQ9tJcN6Su7jHvAvsRdLM0q52uESeJRkn5PYmJI3uI9in60+VkYoJ9R/wr9jk+O6JAvVFwdWJmfTDM34hY0Af7FfTtKik+L4LBLgimzz6FGwtYDw/15xL7ucIjWerBCzJlUMeUV6PyLRb3fbCeVQlaonV+0BOKJ83zbrWaScwWdynEec25xL6OfkIicZ7Fk6C0A
 qwoEqLlA
 G1J6LmWEhLcSEFor0nlZ76JvLn1YlkVuA8jaTsuFBPCcmj7RaksPjN4J30LJmUUmoucO4mJJ9R+o8+3N8tVzn9jLIGU558ASz/EK7sDmr8cFjUccZXA6vMXVynU0x7tx8C+HY0DgH+Go6vwe9WgB7eN7Ps/dhh8iOP2ulV78XP0fFseRMq2Wxcdk/bmfcA7m4UxBXjCJMKtHP+q9Vh9oicwC2Q6aneI/PSzt4rLZ4bNZiR07ZLkrVEU3sE/IczanBgRDfl1Izsq1v/VADCKQvcYxz2yC4goGVIY/DjoCCZniqvvWzvLB4l0dsO9btJDvMePEzA6LXc7uLZup/75njHKIU809LYEr5cPwB7jF89Wi6q0Zv3P2V4x8QL5lVf20uooJ8
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


