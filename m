Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253A0CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6C16B00AB; Tue,  2 Jun 2026 06:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE0D6B00AC; Tue,  2 Jun 2026 06:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50AEC6B00AE; Tue,  2 Jun 2026 06:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA4D6B00AB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:09:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD309162625
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:09:55 +0000 (UTC)
X-FDA: 84834551550.30.C746B55
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id E85734000B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:09:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cyVzZBT2;
	spf=pass (imf12.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780394994;
	b=3x9DKDK6oNVowaWDhmyQfR4D88gEbfjyhhzqNXkbAoRdyVBO70WupqcbAVR7vfkFq+Vpk+
	CWW46Gzw60vsXFHrfIc+Tf2dKSG3jXS1AGuMfm/VwFxjFiCrXQEPFM+K4zaTEtDfpSggoi
	3zHxcXABAozB9UY952YuvmeHm49KBso=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cyVzZBT2;
	spf=pass (imf12.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780394994;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hLX9Bb+0vsl3gqtKqEOJsR8jG1pZJXh/fm/ACRLNz4I=;
	b=sG5S7LjemdRoQqBAawCel3oIUTXWQzrR5pVSrLLfnbIDaJxfPG6LfyZVndPio/Sj5SozhJ
	yGmOieo6qe86SUaalibTFpNVorlR8HeRiHuSBo75fF6H3+0iFoer9ypUKp1QCM/kUAWv/a
	mL+7n7z036jaKwTFfjaecfQWZxb16hI=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45ef82204c6so1767177f8f.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780394992; x=1780999792; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=hLX9Bb+0vsl3gqtKqEOJsR8jG1pZJXh/fm/ACRLNz4I=;
        b=cyVzZBT2sMqcsL5/buFR8yIWI+mmVA2yCXJwI9rIkeF1yS4+VwI8nSEgcZIuRf16Sk
         fHUHwfgvl2hjvhuufEsPNvK5lhM6x9zb4rqsfQvx/c0tvY7pMLk5ivYImSRkc/oRwjkI
         E7CubTXxfVc+jJDoIbZsIctxQjpyIL9W/nKrPrQNnCHvhvps00fU6+Lp6EnaxAm9TMso
         /9M7cMarGyFc8u6zqHZP6GSmcccSuHe4df8TQdAmaw6p8iSliur/gzxv5undnIQpQuCl
         IY9xzaI0TKFVTENh3ZuU4re1tB35Xg/Q/z/iAfeW+tJSJJCTRnDb8jGgZaL+bqKT48SA
         hwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780394992; x=1780999792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLX9Bb+0vsl3gqtKqEOJsR8jG1pZJXh/fm/ACRLNz4I=;
        b=clCb0zvKNTzXn+yHYIXkpGjj+P/RRRvYYYoGaUu83Ot2V2qGqC8bQ1DWEDevm2bE0Z
         EMXbj4HuxI9V6VtrwiboPoyu80cNtYxDc+fhS4aoWL3xkLD/Xt2Tn9RnPdHrb+J63Rn9
         UxbGXYkPRK8hn3sjOA7/Ew6kCgl7YDg3bEozsWZqov+gPwuiTDRV+hV8tFwRF4NlJ2DG
         svqNn40NDcfuLUqozEF7yRiTRAu1+Qgt7jeoH/8C9BzHhDEOfSjtE3tBygx6a/LNXcpY
         3YRS2Jw0AsCCxSYoC4UW0vE6yyHUOmZ+y4t/Sj0itcJLVZFK0mzPsoBsjDXqbrRgTK58
         Hylw==
X-Forwarded-Encrypted: i=1; AFNElJ8nGiKCZP/TYZVVBxkm+j/Zsc3qY/fD2SjyRXezPz5r/X1sCCOG6kAUhBa4HbjRRTKNYhxcqVrgEg==@kvack.org
X-Gm-Message-State: AOJu0YweojARXF+6STtezKR9piEy43yds1jHAsTmj+8xy7ZctuimMNPY
	PeppOfy4lERGeYvjHjrTzC1G3QQ+2rqr9asarAms9Iox0A84OeW5yxPY
X-Gm-Gg: Acq92OEberr5ADBmb0LRiXzBaLmL5h6LoTZgIJxKcrn4/v5AEjGKa0zj7ILafDifceY
	zhJ8i/F2UAm2ikwoPehMcMqZWgD8mbOK+Iu2/5rEpmwCUuDpRsNs6irl3lXXGSoY+eCX7F8OIH1
	uLzIUGHim6s8VwYqz+28aAZUSgNo2KqMvbpAufyZZCTX/IsXCeq5w/F/xtkSebdY1czqEdoTPaV
	3sNT0EbSbmxyXVQ15SDH6o93QkhWMrroXpG1pRMrEcGKSwFfO6SB02gBKTBow5Jh+9wkz/GkbET
	ApMUR78NYaqyWwSzkc6PjofK8RSjkQABNt2SWJCvTWsO/mEyBWoHKXqXiewnGn5bLqcVoNpz+hW
	/ILKj9Qth3ILgWiQOlIiGXp3JGvQzgyS1tkaDlZ/kGJiS87d+ikHPGvg8jstF2Eejcucvi2sKKk
	hf5KrRW1N7iGCsKhmbIFztU1o0CYHy6eWctZ5uUioA6BuFEw==
X-Received: by 2002:a05:6000:25f6:b0:45e:fb69:f02b with SMTP id ffacd0b85a97d-45efb69f3afmr21424039f8f.1.1780394992164;
        Tue, 02 Jun 2026 03:09:52 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::d167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354cd87sm30636722f8f.24.2026.06.02.03.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:09:51 -0700 (PDT)
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
Subject: [PATCH v5 0/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Tue,  2 Jun 2026 12:09:15 +0200
Message-ID: <20260602100917.3641359-1-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E85734000B
X-Rspam-User: 
X-Stat-Signature: 19br1jwaqh9qwfknxj3iux6diwsanqd1
X-HE-Tag: 1780394993-954570
X-HE-Meta: U2FsdGVkX1+JZwj0iJcs80RMw5uezQst0Q57AWRJUFrwoSy2twXkoWkyvVQ7ehDRg66ZrubFsegtsUnkDxv8+u+MEZg36TTDGyQr4Au+mt+Ipko6zApOQ31yPEFwTav5NuCTwSByDCcUUSP71Bq9Di0+0YzJoQeRRK9dh4uh6qt5IrjZ/dTHl0ThJef9kabrIUea7Jblgzo5iFJyujFMlGAuJlat0eL2Knh4/c0tGmnxyr0TeOCaNfV9wbq9Ma+z70paXRAqtwONNdMUeNDfDJKUzIb612i/alOTtN5n8OFRwJdnl8DZqfncfPkozYXSA+aWMtbZI+1ggNYcEQiAQm9XESYLfTliP0eFiI1+8qpcnK2lwgTkQy06NPbfXIkWfJ9reJY0VhDjNdhscs5z+v1H/P70S6DgysWg2zXaTRwGrcX/89IgXWUBwowIiqo3k25h4Y7Hy3X5D6WhuikBR1Ji4Y9/gCfav2gmiasL1SWqT1iEza/CPkWCWQ9gPW8yLiQPrAAKjWslT8AhssPjSjlGOn4whFkoUJe6Qjfn1IpFodiMrcFcgQsCA38KwiSN2WdQ5eor+NuFA4izO7m1vA6ybJQRefRZjdECsJNfgc9tBZPO6XC++SP1808FXKGtoYQ+z1haFAT+hAGWXfQm6hTKZ2Nutr5uBaCPVv06vWWSq/rX1bXYVwpZ9x+OUQfqoNZl5BC5NHrHj1C3IhppzV8JHrCx2LaYRdQJYSlz6bXqnIagkjc94krddR3J4NWpCfvC95LXczOl0pa1Ubhw3hkWKXW7idvn3dRPMJ9lHdYEUS6AszZ6ptVLI8Le10NGn09K9b3bZW/W9AWWvkiihAuEg5pt8Ba5m/MuwgTMeFHL1xHOpUkqxf8Fr4Ez9pRChRTWMcco3mDKR+YfD6OA1Sy5zgQLLDT13oIg+Jtcihhzfy49KxjPk3CdPDprsqaRy3RcJmRvrqPMWNRmSan
 XnFl0PhU
 mXBjaxWKZTqutGQEETrMVWy4bD2zFB3yTelcSV1KHnFefstbtCeqsYS8gw8w6QpVW2LPQwoWfXZeEhWmgULel9+2U6fR4JTNXVqeI0PjhSDXHl7r7vJtwxoatTY2WbSEWvpw3rhM3mhD/549hXI7YLLW8RZ6FvIFfWVhYbkm6rNPMGGStyEkYOgJrwiF6ZOdaEdfaBuXHipVuaCKgQElDyMNir1uXYOKRd/vb2dVxDTNmS1oNP/5z8iFS8P2gDosatX5UpJ8QRPMbmflBHIIhIYJor/3zzlpUO9GKtyIOLDU3M84cpBnRdSQMqSqwFLdIwhvF742qgscJ36GmhQcdV5tkRp0dsLA44ohgSoMAKzy0p2/vNkC10SN9vC77AlnLEM0KdeLBPlvvDz6Iw1WteyCjpIX4i/Dw3CXKWcArvJf2U+8V1n8w1Dx91tmTKptdbGiGqU/XMjEfDmDZnSUecyad6thlN/Ouxbmr7sAJip70wqxO7uCpkurtgT3G+LLahDB8Zj5sIouHErS5NtTJbY45ZUu3M8aQhXQrko4ecXXMHDX1xs7h7ZIP5q5TTbcL7Fk/GvFtSoqc4YeOVun8dS15ig==
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

v4: https://lore.kernel.org/lkml/20260515143335.739511-1-alban.crequy@gmail.com/
v3: https://lore.kernel.org/lkml/20260428122826.339550-1-alban.crequy@gmail.com/
v2: https://lore.kernel.org/lkml/20260408145436.843538-1-alban.crequy@gmail.com/
v1: https://lore.kernel.org/lkml/20251118132348.2415603-1-alban.crequy@gmail.com/
Sashiko review of v4: https://sashiko.dev/#/patchset/20260515143335.739511-1-alban.crequy@gmail.com
Sashiko review of v3: https://sashiko.dev/#/patchset/20260428122826.339550-1-alban.crequy@gmail.com
Sashiko review of v2: https://sashiko.dev/#/patchset/20260408145436.843538-1-alban.crequy@gmail.com

Related man-pages fix (corrects pre-existing partial transfer documentation,
not the new flags proposed here):
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=a0b1df86b0c951beb896d468f200be7fd44631e3

Changes since v4:
- Add process_vm_readv to .gitignore (Sashiko)
- Use ~0UL instead of 255 for invalid flags tests (Sashiko)
- Use volatile uint8_t instead of volatile uint64_t for page fault-in
  to avoid alignment issues on strict-alignment architectures (Sashiko)
- Use UFFDIO_UNREGISTER in uffd handler error path to safely unblock
  the main thread without double-close (Sashiko)
- Rebase onto v7.1-rc6

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

Alban Crequy (2):
  mm/process_vm_access: pidfd and nowait support for
    process_vm_readv/writev
  selftests/mm: add tests for process_vm_readv flags

 MAINTAINERS                                   |   1 +
 include/uapi/linux/process_vm_access.h        |   9 +
 mm/process_vm_access.c                        |  34 +-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/ksft_process_vm_readv.sh     |   4 +
 tools/testing/selftests/mm/process_vm_readv.c | 591 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 8 files changed, 637 insertions(+), 9 deletions(-)
 create mode 100644 include/uapi/linux/process_vm_access.h
 create mode 100755 tools/testing/selftests/mm/ksft_process_vm_readv.sh
 create mode 100644 tools/testing/selftests/mm/process_vm_readv.c

-- 
2.45.0


