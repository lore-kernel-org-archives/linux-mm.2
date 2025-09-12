Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC8ACAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 01:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEF8C900003; Thu, 11 Sep 2025 21:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9FD3900002; Thu, 11 Sep 2025 21:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E63900003; Thu, 11 Sep 2025 21:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6434900002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:37:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B55AA1A0619
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:37:47 +0000 (UTC)
X-FDA: 83878886574.13.E3EFC97
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1545F1C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:37:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=czhWoQrA;
	spf=pass (imf21.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757641066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+D1zQTiTnlEZqnFCgmfLcL4sMppDPwHxOoeZoJwx6to=;
	b=FsPb6o00LQzMdxMDwSDQ7Ex1CEpYhWR3JhO7unA4RABtc5CDgw/Ccoy0lEryQzWHRKVlPf
	F4Eo8UePBjKTif0cLRMGMzNLuqajKJQ8eWmDJzW+/8NN6YscA6UF/2hCUMDcNCv5rTmAxK
	LyOAJCYf1r1cEUwqsjipGzOlOqlQFHM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=czhWoQrA;
	spf=pass (imf21.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757641066; a=rsa-sha256;
	cv=none;
	b=YFBVlggkpX7WrrOKGOSyNq4fwpi90Ak5xvWg8mWg2uLQLsG+r9HyAfYvraX0R3TY8oGXt0
	H37qOdrPjLlkGQXQX9wNcNcqGms8V6hIChg0mMI2xdnosJZ88Xvz8c3AVyu7PxPMhyaEae
	MjBD2/HDuX50a/cCbSnBKJdHqQEfmn0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757641065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+D1zQTiTnlEZqnFCgmfLcL4sMppDPwHxOoeZoJwx6to=;
	b=czhWoQrAAMmkTDUy3XtvjItrUc45a0Ct6/Xxn6PuxhswPgTh2o1fU51wu3rFUr9rTcTRNt
	BKqzhT+hXtBgLQFttrQKeP5LbEqMvr1T26XDvpRZSWCWNre8jOIllB+v8XGIZA4iZhEiT1
	bGevB8mM4CW7RS1OKKRlfyiLeGm/syI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-1IyLpvnVOwmbrj65fPzDkQ-1; Thu,
 11 Sep 2025 21:37:43 -0400
X-MC-Unique: 1IyLpvnVOwmbrj65fPzDkQ-1
X-Mimecast-MFC-AGG-ID: 1IyLpvnVOwmbrj65fPzDkQ_1757641062
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31BFA1955EA8;
	Fri, 12 Sep 2025 01:37:42 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A15B1800452;
	Fri, 12 Sep 2025 01:37:36 +0000 (UTC)
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
Subject: [PATCH v3 3/3] selftests/mm: fix va_high_addr_switch.sh failure on x86_64
Date: Fri, 12 Sep 2025 09:37:11 +0800
Message-ID: <20250912013711.3002969-4-chuhu@redhat.com>
In-Reply-To: <20250912013711.3002969-3-chuhu@redhat.com>
References: <20250912013711.3002969-1-chuhu@redhat.com>
 <20250912013711.3002969-2-chuhu@redhat.com>
 <20250912013711.3002969-3-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1545F1C0006
X-Stat-Signature: xcwmg7ysdho1o7c4geefkcea7ygaod83
X-HE-Tag: 1757641065-353843
X-HE-Meta: U2FsdGVkX19JsJw7u57TyQi28ccKv4wpmcGxKh1zVtJjiLkw8mYpl+g+zC3TGAvA7MbAyl2jjUT3fnvB/Vro+zfDgkoGSH47pRf7AUwsXBEOONrz5+HSzuydfhHJ2TTWwCcu1E5jwcDwqEPpyoBFGqDaW+Pn9Bm/DMADPOburd7UTUqDXOt9YnlPVMA0kwJnfVZ5hco7sXTLqDMibVz9OPjsjWya1Ehdh1RFY2ryiq/C4BS89dp7KZ4cUjne6mtpQecbS6BRqOKwoWizwhMrjHnLj6EyclZ1liVeT/ovvdi3Kh6KKuq1UGdY5rw8qWs+Sw6/MWCY41y4CIQ2xWlifLR5RD13auI6FGSBwlQ9PPPc5o3GNpDhrQ3rE82/Spj5uymKADWE/ex7wy63F7sSjYbzDFKaz4+GtpuQ1PdW2PPsj7dOWozjXjaPe4iTti2WMYkd6ZyDgo7xrGc9XvvAOGXpNPfcm8Ck5tZCDFTOHs6z4BNRQba1/NPv+OigKVvRT+GYI+1m1ckTehbE9zwQTA61qNfBSxoGuW0BKj2KsaDq9wxrbyq79mOvioDXhuJbObDhSdCbO0QEqcn+ufjmQPxMk2e4ru9p88A4LOUKs2g+NNRsf59ijkra3fYrlmkWkrO+HL89Gh2qiSeWd9y5ZY3vRbU7ivhRG9qUA9sGm2YOkof0vXyMqA3iu46q8yu+w1hd54TIu8GH3waMdjqNRUJYCiWQERT3il3LJgSH3/YFbL4ZycSOE4rY43bOQNXUtZj0G9zmm/PCjqnTgzI3Zq1gzL7GZP6EL1g236m/jr+fRMdW1S8W8BrzryZF07lfHY2s7Qs1reg8tWPkYTy/xHaVYSUimWTyHyDKlFRDR2qEVoRLahsl3wC3VdLOqzgOKIeKzQI1EL3yycLQzx+NKocgknV9amdLhxbPyRlVIsfBCG4rIrnPFfShlHKBnK3h4tnaz3QjFrTGFJlsdmq
 eWWycp74
 qPOyhvo3y10AWIjV+ivJ49EvBvOzzeZJeFqPGTzaxe6R+ahJhUyR4QPaHTtuWI/Uf7eNwcBuTiVyGrF/sz6Sne761SOneFKioXCgR7XRMIL8XmSoaA5Z67gqD3aLAKde/ZNGCzNDCGWtyyxLCtMU0fU2zT/4Um/EwHUfztzX4wboXYDonsMytCJG6KB0JyhrNhhBKVzHJ1Zeb6pdf1DQUT0S9FcbevVPKjcRuIUQAx1igcuTlDWSbJMm5AWKbN00D76tHcBbG/RTVbpzMCahHhyIWakDKplfDZbIeHrK7jIIEv7ZOHSmvETKXGIhqwvJwQMcVG7RUFXDb7SfNB5JsfO7AmL2QpvYCvzIt0fbld/IZZb6clX9xkk38u0cwF+VgLJPD
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
addr + len is above the DFEFAULT_MAP_WINDOW, change to choose the last
hugepage aligned address within the DEFAULT_MAP_WINDOW as the hint addr,
and the addr + len (2 hugepages) will be one hugepage above the
DEFAULT_MAP_WINDOW.  An aligned address won't be affected by the page
round up or round down from kernel, so it's determistic.

Fixes: cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*} functions")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/va_high_addr_switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 896b3f73fc53..306eba825107 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -230,10 +230,10 @@ void testcases_init(void)
 			.msg = "mmap(-1, MAP_HUGETLB) again",
 		},
 		{
-			.addr = (void *)(addr_switch_hint - pagesize),
+			.addr = (void *)(addr_switch_hint - hugepagesize),
 			.size = 2 * hugepagesize,
 			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-			.msg = "mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB)",
+			.msg = "mmap(addr_switch_hint - hugepagesize, 2*hugepagesize, MAP_HUGETLB)",
 			.low_addr_required = 1,
 			.keep_mapped = 1,
 		},
-- 
2.49.0


