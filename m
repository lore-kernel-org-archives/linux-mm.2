Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63865CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47C46B0005; Tue, 12 May 2026 22:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1F106B008A; Tue, 12 May 2026 22:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5BE86B008C; Tue, 12 May 2026 22:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9689A6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:40:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 398B1C1C1B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:40:15 +0000 (UTC)
X-FDA: 84760842390.11.81F951E
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6FF9340004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:40:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=EQGDynGa;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778640013; a=rsa-sha256;
	cv=none;
	b=F782iuKphmzb4YiPEwQ++IDcUa//q17kYeXNH9Ds36qUU3kU5B8RQvYdil5TGw8Qsg1DP/
	Gaag4tXp2OtTthTnYynb2LMsBdXG+VSN6WTXVl7yLKdEyba3QOuBIYlTOUDY5bM3iX9BhS
	VLaNnxdCXmAlMYac7m7GsC7NzEmFOAg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=EQGDynGa;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778640013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N1s5sw3nWN7BWqRr46+3WhMMbM99l09M/gxgDWbQgaw=;
	b=PC3XKDToHqD1r+33LApkZCXaUDWwhWvSZzeT1G/loybq0p7j+6aXpQayjgMUlO00tYSmj3
	IOO8vwyDUD9W9GVoaOvZneJlFX+xkbRZtRGnfRta5i/T3D1DmsOXeH5EagUkFZS0LT1S7W
	rcjSbxbQAv0clPVs6Nv1A6oBBmmmMhs=
Received: from skinsburskii-cloud-desktop.internal.cloudapp.net (unknown [4.155.116.186])
	by linux.microsoft.com (Postfix) with ESMTPSA id B45C720B7166;
	Tue, 12 May 2026 19:40:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B45C720B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1778640008;
	bh=N1s5sw3nWN7BWqRr46+3WhMMbM99l09M/gxgDWbQgaw=;
	h=Subject:From:To:Cc:Date:From;
	b=EQGDynGa+VbsBVPnZCkybUUon+onLL7yFtkroe2aWMi37uFiayo/oC1P254OTPr/D
	 cXKYMtYpyTmpafkmEG9S/5EIonuCx61Wbgp/R3OJSdVE6oWVKV7nCWSlHtnzrKRVYp
	 9Is5oC58U1I8KL+l7nE9qIkm6z5MpTBsgT9Sc3Do=
Subject: [PATCH v2 0/3] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Wed, 13 May 2026 02:40:11 +0000
Message-ID: 
 <177863991557.82528.15288076059759579141.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbhr16bpdtn51gwei1ei7d79o8e1chy4
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FF9340004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778640013-399288
X-HE-Meta: U2FsdGVkX1/Z240X0vUYcgn8zXULp6FCk6AWFrcN+zh/MP2PeryXzkkd476Bbb59aAsThz9BqNBxtWfuVD5/vbuQq3IamDCthmcRRA9+gRC4yk1d9/P5Ll5VH63Jmq16MZcAdMXsmsJvCrMQfsUv9eyduFE/ETYummb+7RZzqsDFWsBSANEndSR1HxGLvRqo7VuSnhF9l4qVqg20XqkctGp+/N6gxplMx1RkDC1OgwM6GFYeaHCY/FrdC+OKZhip763NYG2y0vK7hrhrX8C2VQkgK0t53hC6XS6x/TkdritJZFV60CFqp8AYxWP9BoW7NRmPkryX7qNJemk6MHI65bjCdYUpIkHehIxdZm+TmXJQVPkfyveKoU7Ri+wfXkOasYHwkEaUvTcpp29p9HfV/4z0GOPjgYu+8ApG2pcXwJwENQSfgcE+L80DctAPPu9RiWMym1YrpYk0xCWyE6fOY9N8H0C6KlSvdc3mi0vM9KlcoIki9vplgcZmIB5mVUF8+v5brOxAa0QMppp8Ow4p8eypFKePnfNR3e8ZeQOACvx88clFjDpmyEc0Dhu/avDrO69IDuOrUN+PYZ3RZ6ecB9sDxV+JH7xD9N/J0+OCAP2oGWYpGkJqwLoNCUBlwrmkMs40ljlubCpMjBGQsOtmOJjNzVkrexWsjiC/SqGIHAYpsimURteHdUQPNX2iK9EHwJS5yoRexkdnwmpna2NOzZvkviwIh4CcwhuuXfJuHDKzNlw6EQZyJfQZ2RrLJ/fiTJCQAz8RBRgkt5LGGTT5VwVdMBLiuYgzoz1zTjLKOw+EEy33uyq4gdo0SwyOaaUMZMOY/9IUNy1jwYgWw7kCB1OdHVzTG4af/rGAtqqRRazZ8p8/J6K4Q422zl2GxHRa7EmZ84GlvmFLX8MXkkhgu7TaVQLMPk9QcTxZiAuSt0S2/Lskf+L9jAPmwKG00jZ5otcSU4O0G33ZVyNw2Nz
 h6xJg/iK
 UEeNpgaBvDeH1B8rIdqSVOdT4VDXZXmjtMbDf7UcnjIGUvJricLWAsG4HVmC4MsWvszY2yApw+T7DrG8WejQ9Jnnp2XbssD2IDJHyWY/ROgZDh3ifoMHNZURNBVdMqu0puovlrcCvQfoz67IO3BZyT81JX/IMeSoq7SXmvgzkLKhF7O3V0g8Z/ammF/BKXZdbncJ5OBLusOIzq6EpGr8q47U+p9pA1aGoFw4T6mfypviTTTvpKKmWDCdX92hP0F7OvM/jkOsP1K1vh9wZvfUkspNk9S12PzTbM4Y2KVTFDMe7U1o=
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

Changes in v2:

 - Split into a preparatory refactor (new patch 1) that moves
   handle_mm_fault() out of the walk callbacks, plus a smaller feature
   patch on top.  Suggested by David Hildenbrand.
 - Hugetlb regions are now supported on the unlockable path; the v1
   -EFAULT short-circuit and the hugetlb_vma_lock_read drop/retake
   dance are gone.
 - Distinct internal sentinels for "needs fault" (HMM_FAULT_PENDING)
   and "lock dropped" (HMM_FAULT_UNLOCKED).
 - Outer loop now re-walks after a successful internal fault so the
   faulted pfns end up in range->hmm_pfns.
 - Kernel-doc on hmm_range_fault_unlockable() and the
   Documentation/mm/hmm.rst example match the implementation.
 - Dropped the mshv driver conversion (v1 patch 2); will post
   separately.
 - Selftest converted to drive the path through test_hmm with a
   userfaultfd handler (new HMM_DMIRROR_READ_UNLOCKABLE ioctl).

---

Stanislav Kinsburskii (3):
      mm/hmm: move page fault handling out of walk callbacks
      mm/hmm: add hmm_range_fault_unlockable() for mmap lock-drop support
      selftests/mm: add userfaultfd test for HMM unlockable path


 Documentation/mm/hmm.rst               |   62 +++++++++++
 include/linux/hmm.h                    |    1 
 lib/test_hmm.c                         |  122 +++++++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 mm/hmm.c                               |  187 ++++++++++++++++++++++++--------
 tools/testing/selftests/mm/hmm-tests.c |  132 +++++++++++++++++++++++
 6 files changed, 461 insertions(+), 44 deletions(-)


