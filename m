Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 783F1CD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19ED6B008A; Thu, 30 Apr 2026 21:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1066B008C; Thu, 30 Apr 2026 21:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDFEF6B0092; Thu, 30 Apr 2026 21:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDD176B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:24:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58524160427
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:20:07 +0000 (UTC)
X-FDA: 84717094854.17.EB89392
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C34BC0007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:20:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=cVJ5Tr07;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf22.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777598405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5o3nM5EVlRJoNz5ukY0K6ieimgMHdk0LSx+1vRWfGac=;
	b=VwVANJjF/bcFZ2SCA0XoLMtndm4wyJaIZ8WGWizLv+EFbHSkAWOE49HSMHm8csiRnHYOs6
	fcCXucl8C6gxnTSsCAGn4fFZeJ23ZfM6DWs3fKLoTkh4cUNMxzc72SXN7nK/hIZPwCLy20
	WGjZdA5A6huPzwIYOUW/O/MswfkPQ5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777598405; a=rsa-sha256;
	cv=none;
	b=J17cbU4Yxxymjah1cTf9EFVDorwzyG6Yjre2+UAnIQ6Oz4urJFhJaY7D/A7OnxX4RC4jDS
	jtHgmq8R26OQ6G9pj9mFDwP2/B/TR6qq0tSHUtsmZbqX0sRAwZmUNCofxaLUSa9cHC+aII
	Eb2VLUuzeNcgdmCO7FMDcwnWATtToxc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=cVJ5Tr07;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf22.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com
Received: from skinsburskii-cloud-desktop.internal.cloudapp.net (unknown [4.155.116.186])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2870D20B7165;
	Thu, 30 Apr 2026 18:20:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2870D20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777598403;
	bh=5o3nM5EVlRJoNz5ukY0K6ieimgMHdk0LSx+1vRWfGac=;
	h=Subject:From:To:Cc:Date:From;
	b=cVJ5Tr07tZ/FaAC6+vEXHo3ppds1Wokaw1f/8dI9rfLxXXR9l7Qtymk/6nQ2S0sI3
	 bi4Tbzn71EGUOiBWgEC1Hfukic5GOgS9N7uDUMAp9FV3ptkAeYqSh9Psx1dy5lO747
	 0hyEkPr02WK+j3tCMyeUe4Aehe6e2HCU0Hp8RxnQ=
Subject: [PATCH 0/3] mm/hmm: Add mmap lock-drop support for userfaultfd-backed
 mappings
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, corbet@lwn.net, leon@kernel.org,
 longli@microsoft.com, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, wei.liu@kernel.org
Cc: linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 01 May 2026 01:20:02 +0000
Message-ID: 
 <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C34BC0007
X-Stat-Signature: kouagtp5jfaaa9994oep3t6d4oqjx68f
X-Rspam-User: 
X-HE-Tag: 1777598405-917833
X-HE-Meta: U2FsdGVkX19aMt0f9MIt+YEBclTEN4lIveRsBq7WR9KAXMJ3Yi4tzgXt05JOYPZSbru5JX8YZOiQSfca0zS6SCIGHd29VDqdeI7CBcioT7W01fK12z/RS9KUoLFQOe5A3+7UgmpfpYZo1cqobsC13PJFnemitxqwsHg5oE+K6hNOqjBWeUu/S/8EBGzQZOynTdKexX6xthyKhsh5pjn6Sg249sMwTRe/YnfUehGSNShIHBGWdX0zI/Xy8dx0asv9a+KgF20z8waaQ+baRoAswo6QRPUX2MglP48ON00RPdPiDIYbj4bKx30sxUTrbPMzKhnLJAVgJbkTUnbgFrEZpSjmPmjKwa7yRLZ+UnTjqQtgNz9rvwX0HCwzL5/Rq6kz69uMeY+Eckauz8ttkwol9EEu06TkUsmZ61+2hElLoleUWPm0fV26uxMtg3c+MY7u3X6WVrMSbbnT23uw/qztsfwCgMhbXuC9wXiXg9+TcJHdYfT/KC+Id2kWGUKcgWQOif8Lx1xawp7f6oTK2I/4/sOb6GhbtX364PwZczUerrLIfHKQKSkVDCKeYGlzq48/TcrCQHch3YDSNYTU2jqZACm5qAs8LeVcY7pyPseyocG1EMvxyWffCZ1Cxc0oXm70rqN5ALZRE0shLNWsUgTlc9uQyhk7XdZChuHKhjd9qSC8PnApjXSRpaPoiHhlaSa166W1nYAqSzipfodYou2vVNMl1wKYyh5XzfPi1fs/2vP1fvPGtWsE0AMJj+YEy6j+r2Ngxjy6QpJ8JxcoMLSePYltqwIcKZI+olcUrVxIF9RUFc0ShjPkxFLEKIgkYabaV6LVUoQAFcgcOXL9nUjRcE7sk6BV0DwZIrjzUuDbWxLWZjGf341coBsXnrjGJ9U7jPEYwIwTFJyleLwkibKnfY86ORnCNHo1m+hGci/ZhW0WlsHhPZ/1zKb2NDLPXilF8QTDQcRuadvBSVI7XKg
 CxesUnfy
 iRRVfKLoDevx9lgO3Gyb/xAjEMOtIFXxbrrwQs2LvuPi1n4j7OMVS6yaFcAiu3FbAtBvvrhmPIqcbWIx2a8dH8YUH/V1X2wT1Gk7+xUwt2XCi1hTpgXCXx5IJbFFVwzX3A822t1ABOQytycvH062RFl4Pj57hk9/TGCtUyfZS8iFsT4tGVyGb25HJLWsxYKDfxlHja2NTZY84EOh1kKdEtcvZ8+MLWp3LocBudGj5S8kW6zw7UT2Gd9xrgnXV7BNgbHe/AL3kuV3UD+PHypfA5+zMy9oi/P3fc6Y/G0446zM7X9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series extends the HMM framework to support userfaultfd-backed memory
by allowing the mmap read lock to be dropped during hmm_range_fault().

Some page fault handlers — most notably userfaultfd — require the mmap lock
to be released so that userspace can resolve the fault. The current HMM
interface never sets FAULT_FLAG_ALLOW_RETRY, making it impossible to fault
in pages from userfaultfd-registered regions.

This series follows the established int *locked pattern from
get_user_pages_remote() in mm/gup.c. A new entry point,
hmm_range_fault_unlockable(), accepts an int *locked parameter. When the
mmap lock is dropped during fault resolution (VM_FAULT_RETRY or
VM_FAULT_COMPLETED), the function returns 0 with *locked = 0, signalling
the caller to restart its walk. The existing hmm_range_fault() is
refactored into a thin wrapper that passes NULL, preserving current
behavior for all existing callers.

Faulting hugetlb pages on the unlockable path is not supported because
walk_hugetlb_range() unconditionally holds and releases
hugetlb_vma_lock_read across the callback; if the mmap lock is dropped
inside the callback, the VMA may be freed before the walk framework's
unlock. Hugetlb pages already present in page tables are handled normally.
Possible approaches to lift this limitation are documented in
Documentation/mm/hmm.rst.

Patch 1 adds hmm_range_fault_unlockable() to the HMM core, refactors
hmm_range_fault() into a wrapper, and updates Documentation/mm/hmm.rst.
Patch 2 converts the mshv driver to use the new API, enabling
userfaultfd-backed guest memory regions. Patch 3 adds a selftest exercising
the unlockable path with a userfaultfd handler that fills pages via
UFFDIO_COPY.

---

Stanislav Kinsburskii (3):
      mm/hmm: Add hmm_range_fault_unlockable() for mmap lock-drop support
      mshv: Use hmm_range_fault_unlockable() for userfaultfd support
      selftests/mm: Add userfaultfd test for HMM unlockable path


 Documentation/mm/hmm.rst               |   89 +++++++++++++++++++++
 drivers/hv/mshv_regions.c              |  127 +++++++++++++++++++++----------
 include/linux/hmm.h                    |    1 
 lib/test_hmm.c                         |  122 +++++++++++++++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 mm/hmm.c                               |   91 ++++++++++++++++++++--
 tools/testing/selftests/mm/hmm-tests.c |  133 ++++++++++++++++++++++++++++++++
 7 files changed, 515 insertions(+), 49 deletions(-)


