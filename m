Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF3E9CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 14:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185756B0092; Fri, 15 May 2026 10:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C256B0093; Fri, 15 May 2026 10:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073016B0095; Fri, 15 May 2026 10:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAFD56B0092
	for <linux-mm@kvack.org>; Fri, 15 May 2026 10:34:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98BE885F4C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:34:12 +0000 (UTC)
X-FDA: 84769899144.29.2814035
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id A50554001A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:34:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QVWigkSJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778855650; a=rsa-sha256;
	cv=none;
	b=MSYhjqbKDo4Ov1oyi26CJNMG5CoGYwat1ZolsLLGuFLqegHHMpx/dp/fTjA7KVtAgjl+Oh
	gi6Lbzdngcepu3Ti6owHpnGbRMNE/lUhFdoRvapwBdhV5pKhko6Qo0yAhTQU4ZNLjGhQsz
	xbf5VLdv2S+p5P8JlMnhYCOBdeo5aoc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QVWigkSJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778855650;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CP8Tr7a6FXYhK3WWrIhZ9hJMiS8gxETtFl9vBtd1V4k=;
	b=vrOaVhrft3edndkp+tpnZSALZgg4iBbScWBwkk35+TzS3XkEku6R/phFijw/bdBdzLeI0V
	kkJvAPSpDGR1KF9jPD79IfKjqEQt/rqoIK05wYoJIgo1mT++tumabBJb9H4sqd7TG8gqbC
	Jjy7KXuvIV3RbnePZfDalG1jEJWCKmY=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-44e1860558fso5996031f8f.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 07:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778855649; x=1779460449; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=CP8Tr7a6FXYhK3WWrIhZ9hJMiS8gxETtFl9vBtd1V4k=;
        b=QVWigkSJ630TrI/07KxzsooRHIOADEkTtb4aaddF/GqW2JPfKm41mCbSyXDKV+eIjs
         Xf2Y65sL3+ZRoO61yuX7f94WBNzAxTvXibz0QKXD44r3Khc+6CEktv3Jr/dxZpT5ECsi
         /MaP2B9fKSeaXc29R2pcpmzINP0RDDUOzm9X3fzAy6yW8jfRKdQ7wlXYhKq3fcH2/O9X
         tca4/n3nmzZymHAQ8U5tIbpt2McQHYnhF2M5bWunVMyc+rOmKxbF25P0CDefgECZdW4Z
         qvqAFYqMo22O/5EUSmhMud0qiQHplrXZSo0yBWt+x+L8mgcBmpvjCv7Mb6X/FzdyRkQu
         3vxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778855649; x=1779460449;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CP8Tr7a6FXYhK3WWrIhZ9hJMiS8gxETtFl9vBtd1V4k=;
        b=p46jbvoXUwhdKCdWb9e9QAdJMKOQQoZmiYvYZy34p05hMosB6TAXeL/IoxBHqle3aB
         aDizDM4Njk8P+cC3vOPD1OzyLO8cgvzzvHUvSux4kta0RzzSWFmCVLfZUVNfcBnXPDDn
         UxBpzGTMy88KTG0mndWd9IpxkQd9bWjPyfmksA1FBH+1eO2EkSr/XCvGn90zobiWiM/v
         7JVFn6Elu+y+XgwSzv1iD8jwvEhQUawvW09WHbqBMQ8RUCcxTpIu5V77giGj6wi2/Gyh
         qyPjmHGYbkL+/0JlxtwWGfuuqWs2FFasv8TVR+XYTcqq2uD7G4KsjYwR6Z0Sq0PA7uon
         +rHQ==
X-Forwarded-Encrypted: i=1; AFNElJ+/0qTbi/5ma02UUWlKOeaTrKTuCxUHmYGOMlvCUBhOgIioJJBYoIQgHL0DYdAD38x1tBRS4Cl3sA==@kvack.org
X-Gm-Message-State: AOJu0YwAAOqlAN1QzzDWIentuvS+bRIwPs7CHklhtTyWj4G/8W3fQ2M1
	w0zFeDueORhWiEx1TaoMvKd+/3cayTR5yqJYb6luNoy8Qtmo0jG93ehY
X-Gm-Gg: Acq92OHiKq1hW0sGtCOD+qFKOqerCMpN1MEwnxZhI9i4DVJv4oD4Y4ycQIby4W7wsx2
	M4rFCzrMYuT6IxO7c6v801YZijgmW75FvIitxzPnzmh8/VIOdVf1ZAgfSdQGxZoDSH8Tr+NHMfb
	JW31ut0wmaobudNL7BpY+cjQcL6wfFaNTp4sPEv4/ntK1VBqer/eaYgVGZ7DhHnrVaQ2ZgWxKY3
	aXViin9e4UZT1a2qq2uQ8pSw8NXlJhRwrYf7S++3hzWMVzd9jmmWsfwUKi9QH/7oV6re1ewD8/k
	NX4UJhu9Ltmcmxfl77hXBYdhsyFuzPgSu8XxtiswOB1bDbIUVEewME3tdgFAhI5pC+7coxBPw9I
	o5JoGjk9BPlUiGgRAJUb/pUgELlrcMW3pLi2eH+ae0kNxcbWsOgeQY+B2k4AAW3Y1ulZGQJYms/
	vJn39aUDKKmasEVa4xhPnoK4//
X-Received: by 2002:a05:6000:290f:b0:45a:1b61:9f9a with SMTP id ffacd0b85a97d-45e5c57d2e6mr5872473f8f.1.1778855648499;
        Fri, 15 May 2026 07:34:08 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::bc35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e767d16sm15773464f8f.6.2026.05.15.07.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 07:34:07 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Alban Crequy <alban.crequy@gmail.com>,
	Alban Crequy <albancrequy@microsoft.com>,
	Peter Xu <peterx@redhat.com>,
	Willy Tarreau <w@1wt.eu>,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	Usama Arif <usama.arif@linux.dev>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH v4 0/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Fri, 15 May 2026 16:33:33 +0200
Message-ID: <20260515143335.739511-1-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pw7gc7craaj3d6i97rmxkzcercr4amnp
X-Rspam-User: 
X-Rspamd-Queue-Id: A50554001A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778855650-810051
X-HE-Meta: U2FsdGVkX18OKTHqvCTZlzBEAhIoe4iLnXCRZ7oE5D5GttjaoFn5ZZkQkiG64ZO4TIpWVcX6O/WV+oVMh+Db7Xa3nn9uY4qs7vcPAt6mjM0SKTrHSSeo5n4hotW+8eqkTnRUn4cEPSf4i/XgLSG7u8pBymVylNsZMtLc7zkzCsYcMfrz92wlTSkJ2G+QzoTiAn2fgWpJcmdhJO83BqS8SWBJ4DT2fzcwzMmfM6ZFJvL5/KEyOqdCZNPKmJkwyWQiInqZ/dWfWjowpTFBNJnxDclrM+5XNf456kGnYmKoGcakl3U0sXiT7aLPMjVeUydkfWGImnw+Ef4/Nh4kEoprzXl0BuGS9GX1i7/YlfRSREQTJ+4F+2EJ/f06jntAVkdzteiAvh2iaz7kahzX9/DcKm/YfoQuaXnmZX6xKDqR/hNzzOtwXJwrc8iFFTJMPbwi5qZt4AkBQ6P0Cba7P33k3BvtBciL4qi1QN8lUHdELeSaNjyqWcD4orhnIUyck/+9tij/LFL6SZ425dYU0pM/0dZTcRDEF2eBlB0GCshXmDsLZUZGPhginCbWsMivXJF9WEzrsNqToZf5Lwb4wxLky38nNDgOieUyJlEqaMoWBcJeIRhZrNwRXt+i5eLMkoGgx0C81bP6jfNSafI7PjS2ZwCo4z4ESplJ1s54wsIRtC4WrjQW3zn9PKsS0zXeUGVfc01IG6fPKaedIA7M4nO8+ESLCqbns/blny4a1xseBMFJgsBkK92YlJTOW2aKji3XD5pai7dwj0YWC4qjnzzGA29781z4lT0xLtRKaTYZtBo3d6EoIQ+MSil+Rak3c53VTm2pNCsxUFqhvtwN7RvfFpq1L3wLhBdvcDkahInB8U4CZnMyz0T5fUsLAn+PpooR0929cSB2EzRw0VGQIPLn/oxH60cXGDNMwV/TYcQ/QZTBSt014KzWWZDiuWialdZTCEQEV1FLax1EawKcIjb
 LiGPwlXY
 xG7CJhD4ynVVYcET5Sjr1/zzAa1ErzbvdHNWrjzXmUUqC4/nGoiMdts5qIG4w22UlK3R1vZjDZcUMc9Bvk0yWQGbl8o4jV2X7Oe7KQC2vZLlcut4QyYBfW3WdM4FAbfpbiXelPzJAjONtNEqwpEizV/gS8Kc+mfg1mSiQ6sdiju4mo6eqsnTlqG3mTANml70VzNOySJPs1ciYa0yC7G0chyoWQTXbHr8NYX2mxWmSM+T2wCWQ9x7afyL5CmNyF1tq09HoYo8FZgfEwfWWlOYRwrN/olGQPuEE1BdME+MiNzME7WWclULtAgbli2EDcvLuj9WZ2cMIA8ZNbiTyvcE8+SEVUUXuFYzQrczJVrfFYKTXYttHc3v+qxXZ1YyBDzyHdH4btCYkCQzR9zRaDLCgLAJEn6mfvRyjdSJfX+2oxS+CwyheA/NLJFb3QfJJtmwdkCyRq/xmCmuHdPVB+2851VS+RHIQo+3pZ9BAFqOHa2TSvFp+lTLxmzJZBq1360Mfp21NMnuLUugcBJKRPZNJ4+2uHYtv+4In0rKL5TMPtZOvVh05ZE9FgBAkjGbg9X8aVZvI45nSXCvabe3m6bUrPkK1iV9d7ZaymIN0BA+uVIghYsJrufO59B5EAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This adds two flags to process_vm_readv/writev:

- PROCESS_VM_PIDFD: refer to the remote process via PID file descriptor
  instead of PID.
- PROCESS_VM_NOWAIT: do not block on IO if the memory access causes a
  page fault.

v3: https://lore.kernel.org/lkml/20260428122826.339550-1-alban.crequy@gmail.com/
v2: https://lore.kernel.org/lkml/20260408145436.843538-1-alban.crequy@gmail.com/
v1: https://lore.kernel.org/lkml/20251118132348.2415603-1-alban.crequy@gmail.com/
Sashiko review of v3: https://sashiko.dev/#/patchset/20260428122826.339550-1-alban.crequy@gmail.com
Sashiko review of v2: https://sashiko.dev/#/patchset/20260408145436.843538-1-alban.crequy@gmail.com

Changes since v3:
- Rename include/uapi/linux/process_vm.h to process_vm_access.h to
  match mm/process_vm_access.c (David Hildenbrand)
- Fix MAINTAINERS alphabetical sort order (David Hildenbrand)
- Document NOWAIT return value in commit message (David Hildenbrand)
- Document PIDFD EBADF error in commit message (David Hildenbrand)
- Add suggested man page update text in commit message
  (David Hildenbrand, Christian Brauner, Mike Rapoport)
- Keep (1UL << N) in UAPI header: BIT() is defined in vdso/bits.h
  which is not exported to userspace (David Hildenbrand)
- Add selftests for NOWAIT partial reads across resident and
  non-resident pages (single iovec and two iovecs)
- SKIP tests gracefully on kernels without flag support (Sashiko)
- Verify content of partial reads in selftests
- Rebase onto v7.1-rc3

Changes since v2:
- Fix ERR_PTR handling for pidfd_get_task(): use IS_ERR()/PTR_ERR()
  for the pidfd path, matching process_madvise() (Usama Arif, Sashiko)
- Add selftest for invalid pidfd (David Hildenbrand)
- Add selftest for invalid pid
- Remove hardcoded __NR_pidfd_open fallback, use <sys/syscall.h> (Sashiko)
- SKIP pidfd tests on kernels without pidfd_open (ENOSYS) (Sashiko)
- SKIP userfaultfd tests when unprivileged userfaultfd is disabled (EPERM) (Sashiko)
- Fault in test_data before NOWAIT tests to ensure page is resident (Sashiko)
- Add ksft_process_vm_readv.sh wrapper and run_vmtests.sh entry
  so the test runs in CI
- Rebase onto v7.1-rc1

Not addressed:
- uffd handler timeout causing test hang: kselftest_harness forks each
  test with a 30-second timeout, so an infinite hang cannot occur (Sashiko)
- 64-bit process reading 32-bit process high addresses: pre-existing
  concern in the existing process_vm_readv code, not introduced by this
  patch (David Laight)
- EAGAIN instead of short read/EFAULT for non-resident pages: short-read
  semantics are more informative and consistent with O_NONBLOCK
  conventions; the profiler use case does not intend to retry (Sashiko)
- mmap_read_trylock with NOWAIT: would expand scope significantly and is
  not how other FOLL_NOWAIT users in the kernel work (Sashiko)
- GFP_NOWAIT for page array allocation: the allocation is small and
  rarely blocks; not on the data path (Sashiko)
- volatile uint64_t cast on uint8_t test_data for page fault-in:
  alignment is not a concern in userspace programs (Sashiko)

Alban Crequy (2):
  mm/process_vm_access: pidfd and nowait support for
    process_vm_readv/writev
  selftests/mm: add tests for process_vm_readv flags

 MAINTAINERS                                   |   1 +
 include/uapi/linux/process_vm_access.h        |   9 +
 mm/process_vm_access.c                        |  34 +-
 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/ksft_process_vm_readv.sh     |   4 +
 tools/testing/selftests/mm/process_vm_readv.c | 573 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 7 files changed, 618 insertions(+), 9 deletions(-)
 create mode 100644 include/uapi/linux/process_vm_access.h
 create mode 100755 tools/testing/selftests/mm/ksft_process_vm_readv.sh
 create mode 100644 tools/testing/selftests/mm/process_vm_readv.c

-- 
2.45.0


