Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A08A0FF885C
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A6C6B008A; Sun, 26 Apr 2026 08:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A406B008C; Sun, 26 Apr 2026 08:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4AC56B0092; Sun, 26 Apr 2026 08:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1C8D6B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:57:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5DD388BBC7
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:43 +0000 (UTC)
X-FDA: 84700708806.19.FD3E332
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4F96A20009
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AW+EiCrn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dPd1hzft;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AW+EiCrn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dPd1hzft;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777208261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hjxeVCVft8gt21g5txFUGcslMLtnS0XxEcIIj3NcHI8=;
	b=iOd9fX6kVPKYuqxmT15x1TWFHg8HUYTCzTL7HlSSRm4KvGIHvZPDDH81VeXu6ASKN9IWRd
	iWoadaS4RAq+52gp07yBRTRt9iGd3IzVg2zJg4L5pQXoG+ZXLHJDNZlLwmXGjQznlQgoQ4
	mRkzm6bNjbwmmkyPOwYuMzx34UYrn1A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AW+EiCrn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dPd1hzft;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AW+EiCrn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dPd1hzft;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777208261; a=rsa-sha256;
	cv=none;
	b=wLqJoUseXMvxrDI0emw/ixzswgc7d1OAlmwOhRLkdjn5J7AbFawgxPLvwjj2U5JosqzWvH
	v1g8Z7ZIdAjVF1tCDg2lVyPxiuBs4X5NfdwuOvXbtrlhJdAMFPiSNF5gcqYS81t/Yq0KjF
	LzE4nWF7McLXVmrHoDYc7cqYv0jh+uM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A75FC5BCF6;
	Sun, 26 Apr 2026 12:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777208259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hjxeVCVft8gt21g5txFUGcslMLtnS0XxEcIIj3NcHI8=;
	b=AW+EiCrndp2jboSl2snJvaRhrtzCCT0J53Mjx6wFZWXyXWE+B3eucnkigACO5UkDUg3lyr
	AXH0gYLWK27O/KDstBscCDyO+sibzOjDcABvEcO/BDvBgrGhaZea9L3N9H1UCpcX48Wpeo
	XJl/rxuki3cn8VQAfWsqNHNrQp5ZXNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777208259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hjxeVCVft8gt21g5txFUGcslMLtnS0XxEcIIj3NcHI8=;
	b=dPd1hzftXULltqoTZU1XKIrlUGVSDAWS7Z0GG/iB9s6PgPWquuPG4974V/IvE7Rhl7D3Jf
	w965utFV4zj1TPDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777208259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hjxeVCVft8gt21g5txFUGcslMLtnS0XxEcIIj3NcHI8=;
	b=AW+EiCrndp2jboSl2snJvaRhrtzCCT0J53Mjx6wFZWXyXWE+B3eucnkigACO5UkDUg3lyr
	AXH0gYLWK27O/KDstBscCDyO+sibzOjDcABvEcO/BDvBgrGhaZea9L3N9H1UCpcX48Wpeo
	XJl/rxuki3cn8VQAfWsqNHNrQp5ZXNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777208259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hjxeVCVft8gt21g5txFUGcslMLtnS0XxEcIIj3NcHI8=;
	b=dPd1hzftXULltqoTZU1XKIrlUGVSDAWS7Z0GG/iB9s6PgPWquuPG4974V/IvE7Rhl7D3Jf
	w965utFV4zj1TPDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F702593B0;
	Sun, 26 Apr 2026 12:57:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I1wnDcML7mmtRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 26 Apr 2026 12:57:39 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH v2 0/7] Implement a new generic pagewalk API
Date: Sun, 26 Apr 2026 14:57:12 +0200
Message-ID: <20260426125719.24698-1-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F96A20009
X-Rspamd-Server: rspam06
X-Stat-Signature: kf3jnm9wirfcha9znjt35ox1wjw7bcsi
X-HE-Tag: 1777208261-586246
X-HE-Meta: U2FsdGVkX1/KINbo96kQuR+gg9PATY7VSG0sA3+hIDkOx4X72gMMTS/4jmw1iwVZEFWxycnYQ7gV3gDVQu6U5JGtunbXAlTCcDn64bTJugfqT/4XTp+wK/oJiEXteu+UGA79Uy+D1dvPcnauICxXlXGyh32LPXbgVVu9NnMidO35DpcN6qhrm3/PasX+sIPPhnnKRpUUR8+DfP8EpvOYmD4arWkzLEPqIc1j2T706WR80zcEof5+yHj5mPSKIom3mNU0pQRptORoMrvIrTux6dclX1ZevJKwx+CRKFbxGrpbokepca1gjuA6OJSipc0KoXl6TCkyykIuY8/irXQ+GGzWgJG3rJAyIPDqPda1GSxB0cZ25a4aAAjzyEou9sN/EpvblT+6R2PBxaSfdFpjCMpmxCT6wWqnbLSh637Cc2enCUgJemCTyL+OjmdaK93wSyz3APXAvUJ1/FoKKcm4zKONCh8+Fgi9Jy5KCDiJVrSta5LyvKrsyyAw9gnxXfPlPqDS/oshK2+5I9WeHdgQSbcz712VoUI04z+7Cau2fYzFNqwzPno+RZKoz7eIDDdegK4QpZxQwbtqA1mBxxrb4ng19EvGTTrE/UF0aKwH7OO5R+oEEbuOho3Xnl6GTOgCsmYGvvcUf9eZ6Qu30q0adNiIEzG09qK3o+7WUHye/TFoLHOqRFHkj2/AGIlVAMYCLMbQPghwuKkbNtcHUJu59Iua9+DxlMO6vwZgBYVwQJ1Y36Ov0Z9xAech+6TXU9x0RqJ4yMCUFiDXOfyZfbogHweTCilmPqv+9DxZMU1vgncpM6G5Rur9gzqJOOSzg+adMO+NK7wldJE5WB6tEL4jwQ8QwXmBOrNgvFdutwSVQ2GIZJxx9UJ6zcYzUqdn+zLFQHoSUFzUo/A/pBlnqaA2AIUoSO5aVHpyRA5QiHtdS1LJGBb+vpg1HV9yRxF+zB6MqhNN//FmyI0hslQgbZ3
 CmVh0qy+
 g5qVs9vAb/GEW9RtBDAnKRd2M+7V/AA/znQMTrRXt2nJiphNCJUKpgXivFi4HbRQmR9PEnFVdqMJZGG+IfjmPDl3yl2/4DWU8+mdLz2yP4s3FTxT/TmjxscPcG81ji9aBfjPakIOmM4h/7xNXhfUKG/kkw2F6ET4NRP5nS1p+bR1451EcgRfVK9LnozSek+PSl0Ze2vuTDlDQav0WlwKJ0BJ1LROhW3K2IfARfLQ2HCoAtf+K4S7UQBL/SMpViWxi1ofS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
 rfc -> rfcv2:
 - Add pte_hole functionality
 - Fix pagemap issues
 - Fix shmem in smap
 - Testing with pagemap "testsuite"

[WARNING]

This is not yet fully complete, but before investing more time into it I would like
to know whether 1) this is heading into the right direction and 2) this is something
we are still interested in.
E.g: one of the things that still needs work is make the new API being able to
take other locks like i_mmap, since that one is needed for hugetlb to protect
WP vs pmd-sharing in pagemap_scan.
That is already a WIP, but I still need to make a small adjustments.
Another thing is to convert "make_uffd_wp_huge_pte" to normal non-hugetlb specific
code, and that is too a WIP thing.

Kudos go to David, who was the person suggesting the interface and
he gave me some ideas where to begin, besides providing feedback
on early stages (in case there is something stupid don't blame him, blame me)

Also, I would like to thank Vlastimil, who helped me running this
patchset quite a few times through Claude, to catch some fixes.

[/WARNING]

[TESTING]

So far, tools/mm/page-types.c reports the right outcome (compared to the old API),
and tools/testing/selftests/mm/pagemap_ioctl.c only reports 4 failing tests.
Although to be honest, I do not how much should I trust that one because if I
add a few delays in the userspace code, some tests that were failing before are not
now, so yeah.

 localhost:~/workspace # ./page-types -p 1168
              flags     page-count       MB  symbolic-flags                     long-symbolic-flags
 0x0000000000000800              1        0  ___________M_______________________________        mmap
 0x0000000000000828              2        0  ___U_l_____M_______________________________        uptodate,lru,mmap
 0x000000000000082c              1        0  __RU_l_____M_______________________________        referenced,uptodate,lru,mmap
 0x0000000000004838              1        0  ___UDl_____M__b____________________________        uptodate,dirty,lru,mmap,swapbacked
 0x000000000000086c            423        1  __RU_lA____M_______________________________        referenced,uptodate,lru,active,mmap
 0x0000000000205828             29        0  ___U_l_____Ma_b______x_____________________        uptodate,lru,mmap,anonymous,swapbacked,ksm
 0x000000000020586c              1        0  __RU_lA____Ma_b______x_____________________        referenced,uptodate,lru,active,mmap,anonymous,swapbacked,ksm
              total            458        1

 localhost:~/workspace # ./page-types_lab -p 1168
              flags     page-count       MB  symbolic-flags                     long-symbolic-flags
 0x0000000000000804              1        0  __R________M_______________________________        referenced,mmap
 0x0000000000000828              2        0  ___U_l_____M_______________________________        uptodate,lru,mmap
 0x000000000000082c              1        0  __RU_l_____M_______________________________        referenced,uptodate,lru,mmap
 0x0000000000004838              1        0  ___UDl_____M__b____________________________        uptodate,dirty,lru,mmap,swapbacked
 0x000000000000086c            423        1  __RU_lA____M_______________________________        referenced,uptodate,lru,active,mmap
 0x0000000000205828             29        0  ___U_l_____Ma_b______x_____________________        uptodate,lru,mmap,anonymous,swapbacked,ksm
 0x000000000020586c              1        0  __RU_lA____Ma_b______x_____________________        referenced,uptodate,lru,active,mmap,anonymous,swapbacked,ksm
              total            458        1

page-types being using the new API and page-types_lab the old one.

 # ./pagemap_ioctl
 TAP version 13
 1..117
 ok 1 sanity_tests_sd Zero range size is valid
 ok 2 sanity_tests_sd output buffer must be specified with size
 ok 3 sanity_tests_sd output buffer can be 0
 ok 4 sanity_tests_sd output buffer can be 0
 ok 5 sanity_tests_sd wrong flag specified
 ok 6 sanity_tests_sd flag has extra bits specified
 ok 7 sanity_tests_sd no selection mask is specified
 ok 8 sanity_tests_sd no return mask is specified
 ok 9 sanity_tests_sd wrong return mask specified
 ok 10 sanity_tests_sd mixture of correct and wrong flag
 ok 11 sanity_tests_sd PAGEMAP_BITS_ALL can be specified with PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 12 sanity_tests_sd Clear area with larger vec size
 ok 13 sanity_tests_sd Repeated pattern of written and non-written pages
 ok 14 sanity_tests_sd Repeated pattern of written and non-written pages in parts 498 2 2
 ok 15 sanity_tests_sd Repeated pattern of written and non-written pages max_pages
 ok 16 sanity_tests_sd only get 2 written pages and clear them as well
 ok 17 sanity_tests_sd Two regions
 ok 18 sanity_tests_sd Smaller max_pages
 ok 19 Smaller vec
 ok 20 Walk_end: Same start and end address
 ok 21 Walk_end: Same start and end with WP
 ok 22 Walk_end: Same start and end with 0 output buffer
 ok 23 Walk_end: Big vec
 ok 24 Walk_end: vec of minimum length
 ok 25 Walk_end: Max pages specified
 ok 26 Walk_end: Half max pages
 ok 27 Walk_end: 1 max page
 ok 28 Walk_end: max pages
 ok 29 Walk_end sparse: Big vec
 ok 30 Walk_end sparse: vec of minimum length
 ok 31 Walk_end sparse: Max pages specified
 ok 32 Walk_end sparse: Max pages specified
 ok 33 Walk_end sparse: Max pages specified
 ok 34 Walk_endsparse : Half max pages
 ok 35 Walk_end: 1 max page
 ok 36 Page testing: all new pages must not be written (dirty)
 ok 37 Page testing: all pages must be written (dirty)
 ok 38 Page testing: all pages dirty other than first and the last one
 ok 39 Page testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 40 Page testing: only middle page dirty
 ok 41 Page testing: only two middle pages dirty
 ok 42 Large Page testing: all new pages must not be written (dirty)
 ok 43 Large Page testing: all pages must be written (dirty)
 ok 44 Large Page testing: all pages dirty other than first and the last one
 ok 45 Large Page testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 46 Large Page testing: only middle page dirty
 ok 47 Large Page testing: only two middle pages dirty
 ok 48 Huge page testing: all new pages must not be written (dirty)
 ok 49 Huge page testing: all pages must be written (dirty)
 ok 50 Huge page testing: all pages dirty other than first and the last one
 ok 51 Huge page testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 52 Huge page testing: only middle page dirty
 ok 53 Huge page testing: only two middle pages dirty
 ok 54 Hugetlb shmem testing: all new pages must not be written (dirty)
 ok 55 Hugetlb shmem testing: all pages must be written (dirty)
 ok 56 Hugetlb shmem testing: all pages dirty other than first and the last one
 ok 57 Hugetlb shmem testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 58 Hugetlb shmem testing: only middle page dirty
 not ok 59 Hugetlb shmem testing: only two middle pages dirty
 ok 60 Hugetlb mem testing: all new pages must not be written (dirty)
 ok 61 Hugetlb mem testing: all pages must be written (dirty)
 ok 62 Hugetlb mem testing: all pages dirty other than first and the last one
 ok 63 Hugetlb mem testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 64 Hugetlb mem testing: only middle page dirty
 not ok 65 Hugetlb mem testing: only two middle pages dirty
 ok 66 Hugetlb shmem testing: all new pages must not be written (dirty)
 ok 67 Hugetlb shmem testing: all pages must be written (dirty)
 ok 68 Hugetlb shmem testing: all pages dirty other than first and the last one
 ok 69 Hugetlb shmem testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 70 Hugetlb shmem testing: only middle page dirty
 not ok 71 Hugetlb shmem testing: only two middle pages dirty
 ok 72 File memory testing: all new pages must not be written (dirty)
 ok 73 File memory testing: all pages must be written (dirty)
 ok 74 File memory testing: all pages dirty other than first and the last one
 ok 75 File memory testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 76 File memory testing: only middle page dirty
 ok 77 File memory testing: only two middle pages dirty
 ok 78 File anonymous memory testing: all new pages must not be written (dirty)
 ok 79 File anonymous memory testing: all pages must be written (dirty)
 ok 80 File anonymous memory testing: all pages dirty other than first and the last one
 ok 81 File anonymous memory testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 82 File anonymous memory testing: only middle page dirty
 ok 83 File anonymous memory testing: only two middle pages dirty
 ok 84 hpage_unit_tests all new huge page must not be written (dirty)
 ok 85 hpage_unit_tests all the huge page must not be written
 ok 86 hpage_unit_tests all the huge page must be written and clear
 ok 87 hpage_unit_tests only middle page written
 not ok 88 hpage_unit_tests clear first half of huge page
 ok 89 hpage_unit_tests clear first half of huge page with limited buffer
 ok 90 hpage_unit_tests clear second half huge page
 ok 91 hpage_unit_tests get half huge page
 ok 92 hpage_unit_tests get half huge page
 ok 93 Test test_simple
 ok 94 mprotect_tests Both pages written
 ok 95 mprotect_tests Both pages are not written (dirty)
 ok 96 mprotect_tests Both pages written after remap and mprotect
 ok 97 mprotect_tests Clear and make the pages written
 ok 98 transact_test count 192
 ok 99 transact_test count 0
 ok 100 transact_test Extra pages 143 (0.3%), extra thread faults 143.
 ok 101 sanity_tests WP op can be specified with !PAGE_IS_WRITTEN
 ok 102 sanity_tests required_mask specified
 ok 103 sanity_tests anyof_mask specified
 ok 104 sanity_tests excluded_mask specified
 ok 105 sanity_tests required_mask and anyof_mask specified
 ok 106 sanity_tests Get sd and present pages with anyof_mask
 ok 107 sanity_tests Get all the pages with required_mask
 ok 108 sanity_tests Get sd and present pages with required_mask and anyof_mask
 ok 109 sanity_tests Don't get sd pages
 ok 110 sanity_tests Don't get present pages
 ok 111 sanity_tests Find written present pages with return mask
 ok 112 sanity_tests Memory mapped file
 ok 113 sanity_tests Read/write to memory
 ok 114 unmapped_region_tests Get status of pages
 ok 115 userfaultfd_tests all new pages must not be written (dirty)
 ok 116 zeropfn_tests all pages must have PFNZERO set
 ok 117 zeropfn_tests all huge pages must have PFNZERO set
 # Totals: pass:113 fail:4 xfail:0 xpass:0 skip:0 error:0

/proc/$$/numa_maps and /proc/$$/smaps have been tested too, comparing
the outcome with the old API.

[/TESTING]

In the LSFMM/BFP 2025, there was a general agreement that we 1) would like to have
a generic pagewalk API 2) that replaces the existing one with callbacks if possible
and 3) that HugeTLB can use without the need to special case it (e.g: not having to
depend on .hugetlb_entry callbacks)., which means having a lot of duplicated
code and also having a lot of special casing just because hugetlb lore.

pt_range_walk API tries to do that and replaces the old behaviour of "in
HugeTLB world everything reads as a PTE" and starts reading HugeTLB entries
the way they really are, that means interpreting them as PMD/PUD entries and
contiguous-PMD/PTE entries.

In order to achieve that, we need some infrastructure we did not really need until
know, in order to be able to read HugeTLB pages as PUD/PMD entries.
E.g: softleaf_from_pud had to be added and some other pud_* functions.

In a few words, this API goes through an address range and returns
whatever it is in there (swap/hwpoison/migration/marker entries, folios,
pfn and device entries, or nothing).

These are the internal return types the API uses:

 PT_TYPE_NONE
 PT_TYPE_FOLIO
 PT_TYPE_MARKER
 PT_TYPE_PFN
 PT_TYPE_SWAP
 PT_TYPE_MIGRATION
 PT_TYPE_DEVICE
 PT_TYPE_HWPOISON


The API also handles locking and batching itself, so the caller
does not really need to bother with that.

In order to handle contiguous-PMD mapped hugetlb pages, folio_pmd_batch,
which is an analogous of folio_pte_batch, has been implemented.

More information about the API can be found in patch #4.

This was tested on x86_64 and arm64, but as I said, it is still
incomplete, therefore the RFC, to gather some initial feedback before
investing more time into this.

For now, only the /proc/pid/(smaps|numa_maps|pagemap) have been replaced
to use this new API.

Thanks in advance


Oscar Salvador (7):
  mm: Add softleaf_from_pud
  mm: Add {pmd,pud}_huge_lock helper
  mm: Implement folio_pmd_batch
  mm: Implement pt_range_walk
  mm: Make /proc/pid/smaps use the new generic pagewalk API
  mm: Make /proc/pid/numa_maps use the new generic pagewalk API
  mm: Make /proc/pid/pagemap use the new generic pagewalk API

 arch/arm64/include/asm/pgtable.h             |   32 +
 arch/loongarch/include/asm/pgtable.h         |    1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h |    7 +
 arch/s390/include/asm/pgtable.h              |   38 +
 arch/x86/include/asm/pgtable.h               |   52 +
 arch/x86/include/asm/pgtable_64.h            |    2 +
 arch/x86/mm/pgtable.c                        |   18 +-
 fs/proc/task_mmu.c                           | 2212 +++++++++---------
 include/asm-generic/pgtable_uffd.h           |   15 +
 include/linux/leafops.h                      |   46 +
 include/linux/mm.h                           |    2 +
 include/linux/mm_inline.h                    |   32 +
 include/linux/pagewalk.h                     |  106 +
 include/linux/pgtable.h                      |   95 +
 mm/internal.h                                |   75 +-
 mm/memory.c                                  |   22 +
 mm/pagewalk.c                                |  400 ++++
 mm/pgtable-generic.c                         |   10 +
 18 files changed, 2024 insertions(+), 1141 deletions(-)

-- 
2.35.3


