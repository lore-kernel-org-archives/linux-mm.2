Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD28EC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA83B6B0104; Thu,  2 Jul 2026 20:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58D36B0107; Thu,  2 Jul 2026 20:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946C66B0108; Thu,  2 Jul 2026 20:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 583B26B0104
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:40:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D187C1C6647
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:32:40 +0000 (UTC)
X-FDA: 84944531280.17.4E25C36
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 163AF180006
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:32:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dgFqhtzA;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783013559;
	b=FFG/Lh8YpDvjNicEprXUzw9K4lzAmU3KuTgUwAUodu2tpDfPYyVwMlpO2oCoabxqC3MY7t
	4IQAEx/vToHsEwdfbCEyAcg4Y+kpNV/EecutwLhhzh2em/11A37Wsk4KwJ0OYBonnkFak4
	6Lr4/0NbgkFFNRHySoS85golc42wYqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=26WDDaYqRuzzMsOBQUpbaxL8aqOoRshWZ4hxrJuUv/M=;
	b=1tLEWCZadiZMf+weh9iS2M9rB2uq92fS4iMoWvdf/klh37yGvaYQ3LIAXnli7SmbvzKHWj
	Ss2/i4+tomMqLzPeQ9ddLGD9QhMifuQwI+lUrb41Aqp+hv8bSonzK7sTKRrXkLv+8U8jh8
	Omr0+nWxdBT1uX90RkpVFwZCpMuC0Ec=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dgFqhtzA;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8479f1a86ecso1463464b3a.1
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 10:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783013558; x=1783618358; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to;
        bh=26WDDaYqRuzzMsOBQUpbaxL8aqOoRshWZ4hxrJuUv/M=;
        b=dgFqhtzAlCULDLXzpyC0lfzYKysgJBVgMIuFdUkIK7qrYUbDorBZch3bXn7flT4loH
         oeH7RN51PTWPqP7slTyGDA5M0FUNNdd7OenowmGr63t/IhdeWs4eWT7CEurvDKf1pa0t
         JQKvOYRge07NpdGc72brrMh/P+7o5x73z7/BaVP+eeN+sPL3fCM60GKiwhqQKYs29iYs
         Ms6Q1h5Dw7VFDBWFh0scTVOFpRe4H7skNoIUNeNShopADXpklu3EWnNXGew8U6sSIHDB
         2fNLf0u0B5TqiWvegGTmLlZ+I5XsXFsTz1ZbaWNXaSy8abLxURYr8nI6SRq6NTmqq0Sf
         4KhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783013558; x=1783618358;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=26WDDaYqRuzzMsOBQUpbaxL8aqOoRshWZ4hxrJuUv/M=;
        b=AamyIs5SG46ZGLSDToiTciUAxXmS/J/pR0yD25Icr7N0VIbYpV4BaKiMtbxKqT2juN
         dar7yhPF72sxT1ZeHStIaF03JFzcZWhNrLWqvZzwLhU1UGpU9Qw+TemUSIVgnwpClSHI
         GVsTQXcXIbmnI0WsfuO8n6y6e1m7bzHOSSMu6//mlXsfcemfeIEVtOw0GMiB7sKbelIv
         XXuDUELG1nZ+uWFQmytcAOyGBB3qXcYU5atngFgV2Me8f02t3XvPjbd6C8DleMs6xg1h
         GJ+YYrKpG669P+jWyOkTpLMeZfocmZs2Wzywfwf0Z/UbCTGC8XnfvZxUoGZ7dWDWsFc2
         H9FQ==
X-Forwarded-Encrypted: i=1; AFNElJ+XhRG6U3smBaAWCLdLdcoGfJFy5R/q+Uum5ilhhVo2isDDc8cbuMM/Bnlzr6iTf2Ms+xRBxLKoBQ==@kvack.org
X-Gm-Message-State: AOJu0YwoswbrcU+1mjOhwefOvW1lAxXpMw4kak0c2hn4abRTXOuveL5R
	nglCfaY4YyGyEAWMrsxLLXetEzNdxI5eTs/1b1SQYhm/uW37IvSGFhYS
X-Gm-Gg: AfdE7ck8FYuCp8/fVXWAalMaKq3Yx/GcX/dVXpo58D4vB059ukVmVvvbEnmqrhxb6UQ
	s9sn7DeWM2tPhKJT9Zauh2TOufJ4ItmqnPZ9955HrNB6OsAt4vF3rexKa2Z8W8yQVYe1j8Fq3Mh
	gWB6VtQW0gJtNp02K4aWWUtAi6UTxhSSzUlZBDYRSzb2jDQTMaJP0KwBWBG4aeoiFmu84QqtBnX
	V3ATBmy5bnKLhmy0cGW0aoE9s2+nIbprAplUlzfvog8vc2zYAMU83Rwu+0ZQ5ZfSuo0wp6uW9Og
	0ZMwP9N3qoorFm1K7ypACDK+BKDbQ330bE76cKg9t4YFkioaW99ay/7jU5Shv98miqjr4W1XSAj
	grQA3ed89W/AqQQXylqdOjhr9Pht80REIIhXaAQSjvwZBf/B/AQeNX89jfbmMHYepETyTqBQpNf
	ajlVXhdopHMaK5Z9xm7nz4WfomuHHts2nDJdbv2H4IEkW5iB4PhgWzvW628Gw=
X-Received: by 2002:a05:6a00:2d0e:b0:847:968d:b108 with SMTP id d2e1a72fcca58-847c5202bc1mr5573787b3a.57.1783013557733;
        Thu, 02 Jul 2026 10:32:37 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb73936dsm1809806b3a.14.2026.07.02.10.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 10:32:37 -0700 (PDT)
Subject: [PATCH v5 0/3] mm/hmm: Add mmap lock-drop support for
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
Date: Thu, 02 Jul 2026 10:32:36 -0700
Message-ID: <178301344866.373695.16044452017467686329.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 163AF180006
X-Stat-Signature: ykyepspd76ckxxspaut79qxzifjsciwc
X-HE-Tag: 1783013558-753188
X-HE-Meta: U2FsdGVkX1+9VE3BH4BMeDjGQbGmeSVncbjWSJFHCTSnQVtg9wL++CLber4Bc0cHmIoPn3CU5Kxmho34X/iByfSicu9zdLH/CRuZwqcRo9qbVVyVN4lKkVXvwE4ptviJMgfONrCZWgcXKxzIxoS/G7Vx0s1hxYkpzi92j8oKmbxPyoBdbdqnL9ruxUojI0af8IvM8DhfKksTSOGpcgpEHuoUR6GMnBe9kww1IE7UYXacoJEmajvLArUJoN1X9v/6hz8U9khQRhU2ZWTe5e5rZ49K/vySQz+e8suPQPku3KK0A+LFXbrrnnKbjqMtF1S/lPsWfM893uQI9h4IkWjeIzLBnjbx8u3qXk7/Donj9NnqPuNoFtyFwCbJXX069ZbM4jEE+c8bua6kC0BMUPj7x6sgw2FjD3mqSPE1Fxv0QKPn0+dsbSLpyiLcF5iFzmHJsJdcaekHTIlV3B3Edh3wswmbD7CHFF/CIoO/gpKulC4uyCMSo/eagnthVZtsTaE0LR7pXYCy5yaa58L6Iw/m7s5GtOuHbN37h5s+TFichESBlv++q9hThwBoanLOZ3dboWtJl5n1VQqZrrsTA2BFKOKthwRS8ifzg1tm2TtTJu8YAJdgAP4grz8a33RWHksmEbiX5Iz43rI73BxXqiqkqjjljHiLD0hSZOuysEWF1RJKDbW4UbZMTDyJGFzQgmH3+hnLzDxCNQR1t85snFxHPKVgHnKrm4Ic9i5+XTdZjlANfn+98ayjnYI/SOF3UnRRafodMK2M2IGHMTvufqDrkiHSgqArF2NzSuLqD35Uss3mZxhDfaHTfSsvdDhhrBQvJs0qbA/myyPHZxP0v+fHMvVQ4CVM5NHMEkGM5Uv6pnB8Bpcto6SL00dPY4lk/7Wy2mYnuQ+PBRWvA5quHcgJjNOYzZK8pEw4I+4uGFiq+SotzmWMFVyGr/vL9CigxaH90zzHEX/8I608fH2DyHy
 ehkhx5Rn
 3PjBKqbux4vXE1X9C1wL9JNHimX2K2cuduf3HBjHFkF6TgHw7lhSERcDepBipoj1scjg8fLTKegtASXfkWlQOS6d7tpMJzj0wddcPXGVGKyNwL+IDWLyU1y3iqkK0bcOFrRRorHmsMSw88pFdxyR/B6qi/57GU3qIiJncT3unMMyRWKi16q7xrZ4rR7mmocDagSfOO/QE6cYiyT+lCG/XzwEaVw3Uc2LCxH0dOmiy0bSOXir4y6k2p4TIhChpTuZG/F4c5z/AJoNCLXsO37z/6gZBoXD8s9iuZnAcs2VIWn5/KK8GNeY/iEXEsY+ZwsbnpH9N9l4OSt00DHpFPCEcMOyzsvvSG6LbPymJ+2YwhCIfFTZa884/5Xx8Yh0CqrYyNArFfMw5AbptnORR8BWnuilp1orwIxWJrhDnWnlzeW5wJ/f/fR2fNiH3VqdzzGX3/1QauONjp6gtEiAEqX0YNtTWG1Z8K9c6XQ97FROPND5eR7ejHRiJ6cMg9KbaFT/PqtHC3mskJx0dMMQ=
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

Changes in v5:
 - Rework hmm_range_fault_unlockable() retry handling to retry
   VM_FAULT_RETRY internally with FAULT_FLAG_TRIED set, matching the
   fixup_user_fault() pattern and avoiding repeated first-retry lock drops.
 - Distinguish VM_FAULT_RETRY from VM_FAULT_COMPLETED: retry faults now
   reacquire the mmap lock internally, while completed faults return to the
   caller with *locked = 0 so the caller can restart with a fresh notifier
   sequence.
 - Document the two *locked return states, including the -EINTR case when a
   fatal signal is pending after the mmap lock has already been dropped.
 - Update comments around HMM_FAULT_UNLOCKED and the HMM fault loop to match
   the current hmm_range_fault_unlockable() implementation.

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


 Documentation/mm/hmm.rst               |   66 ++++++++++
 include/linux/hmm.h                    |    1 
 lib/test_hmm.c                         |  122 +++++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 mm/hmm.c                               |  209 +++++++++++++++++++++++++-------
 tools/testing/selftests/mm/hmm-tests.c |  149 +++++++++++++++++++++++
 6 files changed, 504 insertions(+), 44 deletions(-)


