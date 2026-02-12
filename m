Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6FF8E9E31B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF566B0005; Wed, 11 Feb 2026 21:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46CF76B0089; Wed, 11 Feb 2026 21:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EC46B008A; Wed, 11 Feb 2026 21:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20CCA6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:19:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB9E25A37F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:19:05 +0000 (UTC)
X-FDA: 84434197050.30.2AAAC78
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB33420004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:19:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mk40lBKh;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770862743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7ZyboKdgs42pmLBAilt8Nx8nDtol8v/v25+THvNzqFM=;
	b=WNWgClNgcEZOieqt6rtMGmpSev/2uXwx+N/RE+URnCXgYa06nwfU+kaRM+fFj6krOmyGen
	WVFKF0us4XQzSK0o0fxwiRRdsEgANRUxpEbjLme5tYpszwu7ICm5R8TNsgRzLL0X27+uWN
	+LuLQb8rQvL2d3fQNiw5yhRXzjsKu0Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mk40lBKh;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770862743; a=rsa-sha256;
	cv=none;
	b=vzJZZQnMfr/+btYQMiZaVrE8UT71a1VIxwLJ3ba9fTMvmik3K+JxIw08/CwLQIzHueN2QD
	EATfEPeFV6wAaUJSiHOSDRMuDIDzI04JSAV4b1+7CyvQsV2saKDD0Od7FlMYnVbCpDW5xb
	A1bx+SC5wW2rFg2s3r1LbmEUlXe8EFY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770862743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7ZyboKdgs42pmLBAilt8Nx8nDtol8v/v25+THvNzqFM=;
	b=Mk40lBKhETqmyiJ5xR3TFnqiO9NHEZ4GcpuKywB+DqY1dTywFvRTROUf9F64u51G0lMd2S
	g9kUHSHD+yqy8g8T+o/mDMMcOsltTKxkaCxgxmb8Vf5q8ErfrhdvY8oRIMdx0vAQjA/eOf
	KlR3dBgR0Eqqek7s9JCRxxB3fqP7qgw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-b5-oYFY_McCoT2o5mQijjA-1; Wed,
 11 Feb 2026 21:18:59 -0500
X-MC-Unique: b5-oYFY_McCoT2o5mQijjA-1
X-Mimecast-MFC-AGG-ID: b5-oYFY_McCoT2o5mQijjA_1770862734
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B0281956089;
	Thu, 12 Feb 2026 02:18:51 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.91])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 87F011956053;
	Thu, 12 Feb 2026 02:18:37 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v1 0/5] mm: khugepaged cleanups and mTHP prerequisites
Date: Wed, 11 Feb 2026 19:18:30 -0700
Message-ID: <20260212021835.17755-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cBWfFCPQYoRaYl1xmwg_mmhowKchcYXbTHoWjaeAJFo_1770862734
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB33420004
X-Stat-Signature: z7155j6azy9ffoohk5bd6izmpyfhbf8h
X-Rspam-User: 
X-HE-Tag: 1770862743-453860
X-HE-Meta: U2FsdGVkX1/dplcOk605q0+/JvvTjg3g1dIo165OPF6HJlmkaPdFb6htCeIsYzhCAd/iQdf+B2UN4qaMH10fy0MGsEYXWI5cVQ574jxYNF13YWDSKD0/8qzN4UIxeXTEFE7s+1DyyWlSLsDu0d529fwaL4h9V/2/prfwXmi2nFYiBV3DHbsi1Rd+pmbEMPHtYjoGsmsuEXQM8MqtZSp1pM2j2z8fbqmbXhCliARb0hmvkvQOq5t5aTC4ZbiWarjJl96JWi8GX0AE49LZJKSU12frGEEwTGYx74RhRJShdt73xlCuDJB7gllQ9mxEoyoxxI79BXIpIr5KRgAHcqCilhWnPdBwRfhj1404doWvZMAmCPfupcI9F2ePPzSyiylCFQ2BhInWi50BgvlhHmhZOL6eKYDbSAHSJGArRkfyzzL03umcqDToVbciXllQGNc6oQFx7ABAtqiO3C2NVdkMFhJHp0Hw5W5fIY+e+owTp1Dxx+EKpVCcNhPhf4PLdJNR7KMea5JSVpmeF6m6p9zoOQ83fwWJJWUIUheQsL2rpWiFtkoG9aSwE6QjZeUArulx03j/SVWmqBx9qIrSK1RCa8TRUlfkCTftQchQ21C93ZuB9RS7ULWyN2s7KiRrzwaOkBRJ9Ib1S0k+/r+8FfPmmiKKmuPnoEZIyTDuG0oWSiEso4xcUatIkenOwwk9v+xtCdxCbD/tny4ipqcphnigw58HeJkc39NzitfQpAdAjNMkzFw6WULkfe/RiKAcERDP2vdkIHYDQKv4vpH0eOTfgWSVdrfbzsH8OkVKJ/h0V36eVEyk9PNa3yoF0/rWfgagHmcPmT7Jml5wkAi4+jmRjInGiKqXER/IwnwRcE81sJFgook532lFSesKQVxiZt25WqZEYjCqCZH6V46/WYxUjddpawFRL3sISasxAggMtOj7KlOnBIRrffF3us9k71vPOuF+MMHG2+q49dksRBQ
 ksHmNA1W
 GAlDCOnvxUXIBOtf78P8Tiy4NLD9DLC27CgKznuSWHaZpgnqciJ2d8CReld6mV4zIXAaKqgAx1CDqbuCWw224CSWbMxb9uBDQS+M9tXQnUTdWXedim8F0VT8r11M9QNMRIlOWDyxm7OkcNWK3NxlTfD1WqRw7VCAN7fqXxFtGYa7ltpjvjXBZNXaI+VYumQg64HABGWOLFUwKAAXA+BBLoHz+BCmk2BxDX2te2vaIKZlOL11mwZq+Z4T4541rL3lQoAIw11efRFBpjIZONjA4kq5hhoVkmOCpZ3kgLGLitJ8ETV6eVGvF53ULPmLh77RgAtl6uE/sCeIXEkfcOmsSKIEPrWXCSAPzd6GwzlqNNA7ztCBpKI1y/obOE2+kEVSVZo69yz/y2zizzRjWSpgbObXWJyvtuPXz2sKsmIKdQNkI0JnrZz9QygD1EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following series contains cleanups and prerequisites for my work on
khugepaged mTHP support [1]. These have been separated out to ease review.

The first patch in the series refactors the page fault folio to pte mapping
and follows a similar convention as defined by map_anon_folio_pmd_(no)pf().
This not only cleans up the current implementation of do_anonymous_page(),
but will allow for reuse later in the khugepaged mTHP implementation.

The second patch adds a small is_pmd_order() helper to check if an order is
the PMD order. This check is open-coded in a number of places. This patch
aims to clean this up and will be used more in the khugepaged mTHP work.
The third patch also adds a small DEFINE for (HPAGE_PMD_NR - 1) which is
used often across the khugepaged code.

The fourth and fifth patch come from the khugepaged mTHP patchset [1].
These two patches include the rename of function prefixes, and the
unification of khugepaged and madvise_collapse via a new
collapse_single_pmd function.

Patch 1:     refactor do_anonymous_page into map_anon_folio_pte_(no)pf
Patch 2:     add is_pmd_order helper
Patch 3:     Add define for (HPAGE_PMD_NR - 1)
Patch 4:     rename hpage_collapse to collapse_
Patch 5:     Refactoring to combine madvise_collapse and khugepaged

---------
 Testing
---------
- Built for x86_64, aarch64, ppc64le, and s390x
- ran all arches on test suites provided by the kernel-tests project
- selftests mm

V1 Changes (for patches coming from [1]):
- Refactor do_anonymous_page() and add helpers for use in mthp series
- moved is_pmd_order patch to this series [2]
- added a define for HPAGE_PMD_NR - 1
- moved rename to this series [3]
- Dropped acks/review-by on PATCH 5 given [4]
- moved unification patch to this series [4]. I also had to make some
   modifications from my previous version which include moving the new
   madvise_collapse writeback retry logic into the collapse_single_pmd
   function. This prevents a potential UAF bug I introduced in my v14 when
   handling the conflict. [5][6]

A big thanks to everyone that has reviewed, tested, and participated in
the development process. Its been a great experience working with all of
you on this endeavour.

[1] - https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.com/
[2] - https://lore.kernel.org/all/20260122192841.128719-2-npache@redhat.com/
[3] - https://lore.kernel.org/all/20260122192841.128719-3-npache@redhat.com/
[4] - https://lore.kernel.org/all/20260122192841.128719-4-npache@redhat.com/
[5] - https://lore.kernel.org/all/65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev/
[6] - https://lore.kernel.org/all/b824f131-3e51-422c-9e98-044b0a2928a6@redhat.com/

Nico Pache (5):
  mm: consolidate anonymous folio PTE mapping into helpers
  mm: introduce is_pmd_order helper
  mm/khugepaged: define COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
  mm/khugepaged: rename hpage_collapse_* to collapse_*
  mm/khugepaged: unify khugepaged and madv_collapse with
    collapse_single_pmd()

 include/linux/huge_mm.h |   5 ++
 include/linux/mm.h      |   4 +
 mm/huge_memory.c        |   2 +-
 mm/khugepaged.c         | 194 +++++++++++++++++++++-------------------
 mm/memory.c             |  56 ++++++++----
 mm/mempolicy.c          |   2 +-
 mm/mremap.c             |   2 +-
 mm/page_alloc.c         |   2 +-
 8 files changed, 152 insertions(+), 115 deletions(-)

-- 
2.53.0


