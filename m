Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27EB1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42606B00E5; Tue, 30 Jun 2026 11:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A0F6B00E7; Tue, 30 Jun 2026 11:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33DB6B00E8; Tue, 30 Jun 2026 11:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 893B76B00E5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:21:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01557A054B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:21:26 +0000 (UTC)
X-FDA: 84936943014.28.82754BF
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3CFD14000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:21:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lDVNWsPH;
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782832885;
	b=u/5GkVuihQz6Sr6rieMF/5SPpf6NXEg6VvfSVVxWIF1NPte0u7NUifD2WHJDMPB3gn/dfS
	Kt1pN5v+omWyGuQDlyDFV7w+A5On03SzFzD/KiBN7RT0hrJ3WghdxW5n+6Rn8fQZNjRxer
	PCE1vXEg4+oOaxhBJ2GUB8GUwqTURak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782832885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XL7r3nX+4tuUw824gjUa7PzQu/yc0CIJbCIJiAlasd4=;
	b=Y9fELjoEqJkyCfTnm40Dw1A/RpSUln+qtkND0RIYmZ29AZTD4hbbC7K8iHTLbaSZs5+tNv
	bTHNIKRfGrE/Q9IU9UoYSg3u0Brb+j8BEFxcgPB0auxORVx+lnw3GqeGGs+s/aETQ+x934
	OyfqcmSMRUZ9p/MXSwI+XP0Gad216dU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lDVNWsPH;
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c9dbd00f1dso16998005ad.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782832884; x=1783437684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to;
        bh=XL7r3nX+4tuUw824gjUa7PzQu/yc0CIJbCIJiAlasd4=;
        b=lDVNWsPHu8e6D6zN1rIrkCwp+zf2+5b+wqdzXBTPMy3WwauIzf7TU3b0Zb8eWYSIX+
         HIJxG0/lp1kNM8Wo8smcl/1+dMSb2KlGHa83XiG1TxgIy7lO4kjD7DQAhJcYj+vUdN2t
         wpoZ/A4x7dNgmuGOt9+2sja1KAOi23DEisOgFx7TYwyuWq7D3EtBvCOPPjAGluN7ZVic
         zQK9HIooCCoyfUPsCE1ShGonBgheDw2gAU62ehsI/5v4IOCiK8dKY5M7FPrymTdpXrWz
         U6b8SskxtrUk2rpy4t1T7sTTuf47BNqDt0umTd54TJ7CNZEbnLtkLjPd6+89DKDgk+xW
         OKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782832884; x=1783437684;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XL7r3nX+4tuUw824gjUa7PzQu/yc0CIJbCIJiAlasd4=;
        b=LhYCe+GDKXoZ32kDA1h7viM4peG0BuUwUZSXKQRGayHakNZO38cjo6bjqvJ5aX1zDj
         jAmLSwC/qmHOyeOZQarWXKP5YtKig4nYr8SZh9nXtOuvLSUhzz6fJ02vPkIRzMXXfepp
         WTGwZ+ml13YeBObgUvqoGO/HcASOgELLcTC5RQP8z3pAfZo3Q5thmCT37dQIdfnCByHH
         pwiX4gFKmKhCrJoolTcXVm5jUYMOwY0emknUwYklCZkGe0vic51YB4qDH7CuZu8wBEgm
         kWjzCZov3fFEylHsRYBLl2RCn0TUyGSaiDD6gcrpSIhSK3iRb0YnM3MkMG8YAlky3Q0/
         ISow==
X-Forwarded-Encrypted: i=1; AHgh+RoDHeUWfMCXgte5Yvj02RAJqwBTrrJ8MSgFmvZgDmg5ZP1h+Gv5elIXgjUY5ngJ/1VvOLd+vwBm+A==@kvack.org
X-Gm-Message-State: AOJu0YwBxMifEnKHL1PMLWZjMGx0R71zniu57yrF+XrGN6IlhkH6mxg8
	vo5Rx6zR+kLIWeXd/K7W6ekBR2erz+u+8DF5jTJaINLVD6PD0v2sTP2HjQoZvw==
X-Gm-Gg: AfdE7cnAfKen8LfSe05T/xESy+fEL72wQIHsN0hK5pu5nq1rebaDwWz5o1sXHkbmKYu
	CuaHCH0MrWTqL9MuTX6Ms1FXMB3T03P2LgBTkWEstbRI+7bm28zRG7GwLt7zWZTsHjea8EmXYle
	GvuB1Edp1Un01TIJFXmjT+dEzhjhGARFiPM6mtVrK11T97a8BR6ByVlCY2042wnXcZrMTh2A91a
	oFTYk+aq7cP5d5oxIdJXFCuBbAvg8J8j4XennL6GdGutHtfNSi4N0Zbb6bCCe7R7sb623zQ8X9o
	RXo+osggODdiJHut2wmYZ024mEOGbjbioELPKhbhZkH1Y4eSpi/S+RxMRk3cJXRsqlE4autT2W+
	9s98PuI7x6f0Bc2+/vZ5wGkkOt2nRzeC6CgpGSChkWoBN3oVVuAInKgPwqXoU+5K0BrBZOrmREd
	EgXP3A9My+x9WpTfXbLyzIPiKI2HRDwqsVl9kkjqYu5Lb+NvfQr+qtAFPVlpE=
X-Received: by 2002:a17:903:9cc:b0:2c9:c083:cd49 with SMTP id d9443c01a7336-2ca5a581aaamr8392545ad.14.1782832884074;
        Tue, 30 Jun 2026 08:21:24 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c930e8sm16720955ad.37.2026.06.30.08.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:21:23 -0700 (PDT)
Subject: [PATCH v4 0/3] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Tue, 30 Jun 2026 08:21:21 -0700
Message-ID: <178283277041.183052.6873574850714079228.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3CFD14000A
X-Rspam-User: 
X-Stat-Signature: tm4gn3bbb4znzx8aeysz6673uae3qpud
X-HE-Tag: 1782832885-576965
X-HE-Meta: U2FsdGVkX19V0zYhHSiuRW5UUWz+gla9cGa3pjo/KEUI2y09AM2hbw1IL8iXPg6em7sORWjzr+QjST/aqZY+9lYfAuuQyyA2yXIlyasbj9o7dx2o7v8xQ2vrq8S51ZuoZ+SgTFy1DYK9iPypCEYcQWve1X6JnoZKEZa/gUWLBq/5UHrSJ3m6bn0EQcMjMS7WBvbMS8MQQaxK2ddC8EQEHnHMF/VVhP4z36s5fR5uTIShFsCK8qiSLmUa+GRdWu3O7RaEhHWgezLmj0TVPJA/L9mWDl0NEPCAvlheg5evL5wSy8w0k53AmhWzq7bcFAaC7XKi44PNm4G4LdnMPCPVe0pZ3SuR1t3it4xWp/jM8j+Rrl+QgWxmZAERG0nQAMLJWU5VWa3qPojXY9rlBbqj9BdKG39LsEW8CRKetKViZjWk47zFHhqRev+mP6VkbnLDjxk7HmfOKb93iDRXBpVpSRCnQhDUevE10qpYgZKMNDPWd7QhO80LC7AkSvqhLyh/i5eKUqNrnLppINTSbeLxW/XXlHWgDDCPyeS1HdHeEB8+0b4fCrG9d2nn/1FdNw2IxyvepL9di68IYhDZY38aU/8sZrvLre48GSEqQshh4a0SdphKLhbICYyfJ1/CBHTPvRFgokSlCTt3qGjowE08e3WL7Gzx9WxmbM6EDWoOUkDZpr/PxLQfog8LoOX/0J8uZtnAYhawYg4H3i+xNQGprX6HbjDoZV0MeRvkLpUHFmQb1FJLZF5g5LgBH7yFgLW5CG1AJFu/1UNy5XAnkAFmrp8OcUA17urBje35LmaHu00EXL0edq+w9VwbmhdRpG54pf/LysHbWrI22uVmydDonzxQ6zYr1MQju7NtakvWmD7h53sZfHhLvg4PatDpqxcRSIJjczIQkli53FwPGFgLX3chlrnwBWYm6zlMAda63ychxGPAU4Fd8ar0x7plcwYGjWUPt5lVkgmxTkxuteD
 pNFLm3km
 i0AUtmaD9VFw5pJ5/EcnkkjIUZQm8CTcrThwW0h8KkUCV7F7moJGeLwaf8pdDGuLJy1rF31WVTxYyVAvVvrbjuC22g3lCzHbysfyXtMn07L+ve74M+FDhFmu2UOdnZpivzMWHGljo18yF1HsPOpN6ml4tBzz0veFYMASWcZ7UyyYg7t4MsseolU26F0i6LlZMdJoajbbI6Nh3gO4695l0lcDNhAJRzJBdanTByq6bPtGNjHu1uGDlF4++EybVeL97cv9jBiTMjyCvRmLYS9qUrd1Q9htJmgvaFYq6TTge8QwslG1UxyVOst74mJt02RCGRIolQr3vH/iEAYp56CzHEXOBGHL3VxxvqDv00N+ThYUA7Y4dP3dg5bcOQ1tq1PzqMnSe68g0qvivvERwe0wY4pWhPVui+CuRF5+HftbM7qX5HqER5KB+R3pCdBVDiM5STezkxq9p6ALmQa/VavlQj62NREBCVFB4Tyz9IMiiFZPIl3OFJ3t1KlFsO6Sk1vPwuJ+c
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

Changes in v4:
 - Rebased on 7.2-rc1

Changes in v3:
 - Return -EFAULT from dmirror_fault_unlockable() when the mirrored mm can
   no longer be pinned.
 - Add an eventfd stop signal for the userfaultfd handler thread to avoid
   waiting for the poll timeout on successful test completion.


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
 tools/testing/selftests/mm/hmm-tests.c |  149 +++++++++++++++++++++++++
 6 files changed, 478 insertions(+), 44 deletions(-)


