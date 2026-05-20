Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C99CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05D06B0005; Wed, 20 May 2026 10:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDCB96B0088; Wed, 20 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCBCC6B008A; Wed, 20 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB0876B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:09:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A4CE8C2C6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:09:24 +0000 (UTC)
X-FDA: 84787980648.08.000FC50
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 634C7140003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:09:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nThKiN3g;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779286162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=umF5ta/ZCRrJTgwIAtcRYeo3cZUAkdCQZi2umN2kMZU=;
	b=t0dz7zDeq1FjRBLxNMPZespFMvKOzCXF7id5RoVQT4GgXjbUGAih9RNRVsy8BBbXlamWP2
	uIN9mtrQTyUh/5Pa2rS/C8LeCRd3H5o63dtx8QzANog4pR1y1KSnn7uOpmJu3VeQMFjg2H
	l8mlWTeIQ2kYCdLoaUkoTd8Dt5ODi9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779286162; a=rsa-sha256;
	cv=none;
	b=LOblh3Soopn7G5tj/Ii/0z3O5UuBPFEBKLJNH8CTNdwTKsA2hY3LOBegSVsQG59HSqMTec
	g0bmetBE9nZJqPrc8OH/EBJmQYhFRPFLBEKjYz10VRRzBYKsgJb8G2HsrIpctiEg6X25Q5
	igry4EseYRTwQEElgxugPWBraIE/6QE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nThKiN3g;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c70c112cb61so4059935a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779286161; x=1779890961; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to;
        bh=umF5ta/ZCRrJTgwIAtcRYeo3cZUAkdCQZi2umN2kMZU=;
        b=nThKiN3gzEblahG0TrSbnYTj+pD1pVmKQXaS0UdelPG8r7oEofKOv49ONOBzM62Z9L
         kWD+ePvD9CCzQ1va5VSUUpZ53ZHSaxR4M6oYgKyz5UR17Fyg33ozjDwh69hqd+ui7xcG
         XSo2CjS+He6aR6Le0rfx7Otqs/9Hyh6wqlZb5Y9IDxPKnWvSKLt5kXFOLl07VzkHM22o
         UQDYbqaTHkY28DXaHwG3bMB37v2lk9J1f2961cLUE00L6gX2cqv3C/3VX68GMdkRbQY4
         iaJDpLJrE19k2EU0woHrnc1zBGFoAAMv0w6/U55v/J8csemCQF4YBK4rWCbjGD5awX0X
         PFeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779286161; x=1779890961;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=umF5ta/ZCRrJTgwIAtcRYeo3cZUAkdCQZi2umN2kMZU=;
        b=cexAOjjmx4QeKhtWs3JFFc8uGGnK+XOqHiGX47UIteSym3m74SNAYlv8xUQeEXdiel
         fb5JiCFRwtVOSl7kpVpPYvD+TQ0oS3krp8g0GVo8A2Z0chq6+dlzeVZIGK/o9m+AuNHJ
         Cn2+EIW335eWUG7w41tZR/wtE5EMIjL5YEXv+jRVSJKn0Aqa+fsFrE1R58xvPaKQeKjK
         InCN49FSZLPB1shPdOG+XZSQwzlTBkXQ45xdZArb1cxNmWLqlT1boKqdpmnbcVkSr+TO
         09RT3WFXU4if7Dw0JJlpfyS4U9YrEEx8vrkoq93rKj/IQcWMDSVetVXWr/H4KdU4cgXR
         XBbQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ftCgqvfZleY/oOQUpyAWSqC9Z4B6iFvn1IGulSk3DZgwxZMrY4ctuZh28Wwh6D0QBrsH4MfLKWg==@kvack.org
X-Gm-Message-State: AOJu0YzuDXURH6Ku39h2zbV3YDOQDsumjIgu/XadbNA/oUGaqUfTHQjf
	pEs8pWkidBBaAdRuSBKed/+rUec+fRo/Qs7hc1WVBnML0gipPVsB0j1/
X-Gm-Gg: Acq92OHPCiQ1SpiSc/qDFyeM4MQaHfvP6/NKMwF28YpCkbVxmUtrtztt+8t5y9CzIRE
	Val489UGsqAAdGNj+N24miOiWLUKikm7k5xvqynjw3y5Z/AWuAPc+OGjpk49A0+3Yp7GEkTKmCF
	XGq8NZSn5yLHlAy+yxlN9NtAkleBZ2CgmoxpsquK6lyWSTvHI7WDKpcZWJZKNre48KzGatBOD9/
	puQhmM99t9A4oOunhQMkYJ8dA68SePC4FAZv3JsVbwI02Mc/Ezso2wgRCrtZMNamHUlh0cK/rg8
	MtraOE1U0BgMM0lZjxamhJyYkk/WAJ3YUze1AlvXyOOhkp+eW0/aOy3xSLxS7O5S0KkeXn4BxmU
	Dgja9+WQqdTa+aZoUqb7pSItuVEur6CH5tMKSqnnsX2ptlRBzOdecoH9lEYL6xPhLHKNHo2uPx6
	aF9W2V/cL2n3tog0e7TOpUGQsVqvjIrF9kzYng9t9YXpQkBPo6GgtFTyu3FSaUTobwWAR6cG6Q3
	lpAO3MS
X-Received: by 2002:a17:902:c943:b0:2b9:7ad1:bf2b with SMTP id d9443c01a7336-2bd7e927ae1mr272535545ad.29.1779286160874;
        Wed, 20 May 2026 07:09:20 -0700 (PDT)
Received: from [192.168.0.159] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d23b085sm221782185ad.84.2026.05.20.07.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 07:09:20 -0700 (PDT)
Subject: [PATCH v3 0/3] mm/hmm: Add mmap lock-drop support for
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
Date: Wed, 20 May 2026 07:09:19 -0700
Message-ID: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 634C7140003
X-Rspam-User: 
X-Stat-Signature: fjsbnwxa1w66nb3i45nbzs5fg1bsx883
X-HE-Tag: 1779286162-984753
X-HE-Meta: U2FsdGVkX19ji+hLi9Fwg/CBRlSjN8su+2AyS5nVtMBzeElv9tiuwUth+7mDJQvD2VZQe/mUC9pd33SNBv4UckDgYWdeom9EX4bmb1vKM9pvJZCiMxFy56oNyWYANqf17ifflxavMNp8FtPSUFSUbJrrzxkG+knTRbwLlzBxmXMY0uVVxS0mmf3SF7JuBtBPkjCwahdY6Odg5DQqXVmb/YoNzJ3KwA4ac8iWgKpgoz+J1NzQFhMq4XnEgAyPW9BIc4pdLWsf6DO7nxO+R6Cg9NPwy3HKYgALeSXZgLXjkr+/+nPIHudta5tkPufA1I0CGfPG5gWxtGnLduHb+D1KAzll8TmXq6bjPAHRFvdnXIFH4cZ0tO/jYYXRU1Q70sz5/YYa8NtRCwW1rpqxnvzMdU0vJXGfyVGsxTomuND93jVYSzlaAFF2wsyLFc7mELv3+jXe/IKd75sR6ROXswWRBTbvmpBXzjbycYK7GHRcCa7sW6QP+3OWoeOjuvBvHS+i5t0uOsu2etkfyVXLjQdkcImB5Z8/0saCvpCOU2MjbQMBWAZarFewDiXKXJ11vcmiOEyOqiSbjdqu8+hyU2K6vQc542Isgws06mxiWph8UviHlFBgJq0omLvuknj1jt9QhhBhibS9/AxyvSH3E9FSLMLqsLHYpC+Id345qKg2ZuJdJTP1kSgzq+qQl9Z2hxDOvVIZvvcU8C6Zx19fr6sfXtJWr8AK4Sck053Omo67SBkxnGVXFsbgfNQQMLN8XNOFmtJAYFaLxNw+WzoajBzBEVveF6DFnUUEK1mLjYle2S9zK7x3GFUaSdyRLaVVEPaoG13AZR75QJZz0u+STo8gb36ZGpnkZkxZ0YQdABLS0/jFFq110Kru0I+1zH6SDKtC+66ky/EAbR5DqjPTwpUM0aXoSkrt8yVg4OGB0yo+CVlaq0HVUwaHowcPEsWcCE6GSIxOlbAxj4CxJMZZExd
 W87srOOo
 Yz86zI+3qRmN+pXvpDOe/msbupbM8cEAoeYAWJN89DJK8CF8QfM9bX0kSYbu/3khGDptJtcgScLnelnpiMp3gb94QO9Me8V++HNUCArvU+h79+tD4ay51E9o669COQqyNmKTSOnQW0eXvALJYroWJXqaX4ICubgyF1cLrL2zN/LcJFEgctfWurvFdvjoYylxX7seYt1pp/dt7NjTP5cwUHsssqCWWPC4Y56MYkxa1FQGolfpgZYhxpb5OuDolhG3vVu5QBy2/7eQqow2CGejMQM4LHmWDzTpgpwMCsfOsNz531Q2kxWSP6VbLQqQIxs/AJDvVtuLrMSifncWAFPlz76rpDMmuH7Mi8lff7yvzt2L/xnyyubqPUDYcy4wyQc0FcwgXN05MtCrhpISrIEDA2Y2vj4pkSkjkM7TZJUsran/Jv4oa9S8in7n1YsdzSI9cWzdw9dOzpy+I6WbT0GRrbHYPDPTSHtz6OShf+JvjT7zMcUUZzVEMRy4qbIpcdpDxpRkz/3BGVSxOpkTngdNzJdkfVIfCZ5rqAs6X08A+/OkAU6fMsmwOJzqkcaxsVheMRDo2ohLSgZ4jhVMaCVQQDxRsZ88Sc9LNqk+P
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

Changes in v3:
 - Return -EFAULT from dmirror_fault_unlockable() when the mirrored mm can no longer be pinned.
 - Add an eventfd stop signal for the userfaultfd handler thread to avoid waiting for the poll timeout on successful test completion.


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


