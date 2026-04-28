Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F989FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 12:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95956B008C; Tue, 28 Apr 2026 08:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46DA6B0092; Tue, 28 Apr 2026 08:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35746B0093; Tue, 28 Apr 2026 08:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC3C76B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:29:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 605301A0105
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:29:05 +0000 (UTC)
X-FDA: 84707894250.27.F5538C5
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 73F7640008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:29:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rfTo2Jo5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777379343;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TXcCY471zeTwyfOocDx7ieLgk3K5M2DX9c2HV3C7GKs=;
	b=3/ESwRb0UXlDU2M4q4j92z/oStW+xRFwFIU+mntLJGsV0vW2PevLkXd4UMDjQmhq+WQc7n
	5VWlaRisaR5OOh7dzgKrtllwJkS1z75tmAJjpNdFfrYzRNl5Ky+FTgpGI9GAxcXfvu03j+
	mp0kBBWFR38BRimW4mLCiwzPp/fLt5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777379343; a=rsa-sha256;
	cv=none;
	b=pQnElLwH4CP9qvPCWqCFtAI901C2M0yd1n4CAl3aEmDWyjRlBhgNhve9bRt4GlDf8WbZza
	Nc0nhy1TLopTfWQEN5vAFjpRv4iouYXBbmQKtX/JfTOACn56DUa98nULKyHVA602onlS7m
	OPPQzAxL0Ae0Aor47H7EGigM82t2JzE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rfTo2Jo5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso98274035e9.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777379342; x=1777984142; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=TXcCY471zeTwyfOocDx7ieLgk3K5M2DX9c2HV3C7GKs=;
        b=rfTo2Jo5yVqd1sF7ZEuUHEActW5H6spCVG3BpRtAstdYgzyvUd0290jtvy3Wae+nPG
         ZW2bGobk0qv4yqR13YRH9CNm+ZqR7+J8rNXXpsqwXUtO+DotZERtVL7X6/QOZ0MT7LBG
         pAg4q3o4CCwGxbyyQjKs3riG8V8ExjQx75l/tU+maTq7xn7gfvIUrk88fVlbjdWUaCnI
         O28dEJZEUgTzwz1H5AUeC01qdsHEaxvRQpntFvKTZAkge6oCgkC9f1Qq0w9pxiPHg0Kp
         iYPrS9y+W19BHktaaprTPSdaBh4FmjhGI/CZG0ny0AxE5NiZZQshN79A9vFBZvBUGAOi
         t3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777379342; x=1777984142;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXcCY471zeTwyfOocDx7ieLgk3K5M2DX9c2HV3C7GKs=;
        b=LTvO5YiVvXVH4Jq1OOIcGH5vD13F5QDrrkbXWYqjWrN10WunqUlblTnQ2Fj+qQrYgQ
         RE7u43tPZo7nhxHe9p5GEpUCy3WMyaHAbv+sN85wokYSZpVCPq1yZ9Fb4fcqL9Ku6pub
         yqONZsfnu36b9qer2ARTk5vYPCA4mbcoNIuKfpE61iWV2E3dtXcTj7szXIaUncrWBbjF
         Tbat0s4w+PyhPNWVmKqRs96xFi+6jeYee2TnqAMDso9L5AxFoQOasEgN7PEs+yFxXMxX
         UTVwpQap5/DzggtIeOg1R9ukGrasjsmzzaLrpwdpelL2PtqmQMZ/FbwteYI8nEFgWvaA
         xWgQ==
X-Forwarded-Encrypted: i=1; AFNElJ/hCTqxVIA+8KuAcIFXfDCLsZT1dL1LTyDINsa0DVLX5s2A9KVPBHwOHZ1/pR54PtNmGKwmaRua+A==@kvack.org
X-Gm-Message-State: AOJu0YzV7WERbgXYqB0Q9GtZWc0dHsdfCSTtiQCfLG+i82++WoCISL1c
	rU+EwFq1BZ7hX85xcGAbFXbYllfBUtSBMWpAQ37MyDeS1yzNuq0e+4TY
X-Gm-Gg: AeBDieux42jrsc12j2//90bsr+lpSSY2xWY6jezgy056qq1K9daR4ngm8VM84bD24Ra
	TBe21cHjA3jf6RuRr+087JBqxyi3LVCRaW23FtZdTfYakNDBlY386MsZIqa4by6wMTjtK4TZPZo
	Rv89KC91RMEU5IPbyJdQsObR9zdzL1VArj9ELb/yOZh9wDBXqUl6EhoYEY/SY9xeUCbON/KsPC4
	Zw9CG/OkSvd7k3E8kNuxsuocvKUITqoNXv3pfWgcwNCxqflJs2G5RiK7KMNmVljRGsMRBk6UVed
	muHH1Ooj+jBIqzHonEATw59QfaE+h8fq1g58S1SP0y/PravwbGPvVDdP4gagxb8zYlJHYl5NL34
	RtPu03kahdkTAosVQ2MtxI4T8bLNpxXSJ8ZeslRzbIC0kuEeol2JQSo4sFuw/hyHJv3wkdnE14n
	nu370gqmSa2SbWK+vQRDrKnZBRO12dOLULJUfooeE8PMAyicFTfoe8FXkuGLFH3N/oyXqQKCzAk
	g==
X-Received: by 2002:a05:600c:6304:b0:488:c40b:c8bf with SMTP id 5b1f17b1804b1-48a77addb16mr46796805e9.2.1777379341448;
        Tue, 28 Apr 2026 05:29:01 -0700 (PDT)
Received: from localhost.localdomain (90-181-198-146.rco.o2.cz. [90.181.198.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a77af1b86sm47479045e9.5.2026.04.28.05.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 05:29:00 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v3 0/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Tue, 28 Apr 2026 14:28:24 +0200
Message-ID: <20260428122826.339550-1-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 73F7640008
X-Stat-Signature: qmik9duinwhsg6kx787qpee5rri9dy5u
X-Rspam-User: 
X-HE-Tag: 1777379343-163881
X-HE-Meta: U2FsdGVkX1+zKS14BzzSSqDFMezYutzPXceGxrFM78xIhoBdERqQDwWQ8JzwhLZAoFwgNwGYFLXYS5RGy8fnXB8MrhPvxSsTIUaWqHJinsIuX10onqeQs81OsfF2/uJkXX23JBxLux902pfh35OYB3PkOFoCIgv6Abv7uGF+9qkYO+mSfUKiOs5nCVdxRK/1W6iiMi/rYX120SLluVHtUcboOjuxOBSLkjsuvYushCBfKM4g5+THu2zaBScKQs47+GmjEFtwgtl3Ty1NDa1TRDDVk3O+O7UMqCozJFEjXhU+ozCsRKcUaZTjfRNobsnUYCSYXc1LsnlMTx1WEC2Lq1iw/0IpQ92RxH6RPXVSZFNWPh19o1lxb49Zw/4F4IU9fGcsilJokPpA9+4s1vzM5yTGEsl0adeB0ncRGmUJnJZskNnOUNta2SVKDCfl2iGBz9ywO28DQGqc82AQwwDH00+dk11lALs+wpaTtIqzJ3WdPVIROG/TmVu0qIB74m7bjotEtdgMijjKnhrDcyrPgiSCef08k3uWzdc8MxxEyuKm1/1qm9PHYbzD8loL6Q+U5WGAutCS36SPyYcX7sOBhoDXojjlWOpLKOTh5zztKQ9F/gyqh4toEA34IA89iskugsTIn8AK4PS54xLKKLYX38vcR3in6d+paMMQbd1O0QCm7Ltv5Dtou9H3pGiTiMOAPc+nsGrrle1yqzJB5D8m2os9BR9rMGWm77yoz5xN1P0Dav3gzvRtO7pfFSQ+dxbfRlZsksi/TPQqNHcvJW8GJtEfoSWBntoMduSpyrdLOB26TmXvD0nS96HMufjafrddyH+schDd0egtxZVq7mnNsV9aZKavt0KfxbH8ZUCRIwuzy9K8hsjnMTX+3af0ZD+3TpR9nC+C4yfvunVyClqsOqwM1XnEn3bQ8IuNKQ3wH9JSUybLQH8nx/ARd78+EbgmAyCFvxmw1IS/lPsY11n
 OsjLJzm+
 6rOLvcyGzbR2g+daKyoshmVm5dH7arnvOVSncDgej5OHS/e+bgg5rkgR3aWwVXvvAyTuFVV/MbNF9HhGFWyUgZRLBLLgMdF0CW+bnMHYBsSyYO9P6Vur8Y98Zkp+Rz4x+KX8YLoEG7c8i0vjBwb65flKwxm73LlI9HpWfdr42ToL86vjq5JH1R9IEAqJjvDmSGlneUiMfcYfn6q5SlRmbdZQZgcXMPF1WV7qJI8C+d5E8x5Qqoz4wPQx0Rh+UQH6RxAlueKWzzv06uwWyKDMM5lSI05ONR58JeGMsCxTvdVtjiWUYpgQr9HDoXrg/gdHk/fSZo0vvjiX81JT1elAAeN+zznOKMHnpTQYP7L8xbrshyt41aui97UooNiSQLqVnRcXQHle0wqRs3w8DWF551emWcyBHt7NUetEho0+3otpo6Cup4dGoGCCnRIT7iHdyKt/45yWqSzIHbjAdmsrpQyei4Kpl6D/y1Fa4JTkI4HQhdk9IHV/NrMaaD3Dw9PQTLsv5LQfVUOYZfkb4rnUiI/hLcX60+oOCJRODNK9pfxyKL1mBX4IXn7n+fTSmNYhpGDNPDhbZxSOmbZ5m5FKJHYDncM6LOgxR3NcpMa5PVNfJVu9+HiZhMtmawH76qSHBL0T3+R5MBUaZFrCQuXkDRnoSA2u5eLhFt0zDI1K6C+e33OE4VeDyrye/rk9jUAFjhzoq
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

v2: https://lore.kernel.org/lkml/20260408145436.843538-1-alban.crequy@gmail.com/
v1: https://lore.kernel.org/lkml/20251118132348.2415603-1-alban.crequy@gmail.com/
Sashiko review of v2: https://sashiko.dev/#/patchset/20260408145436.843538-1-alban.crequy@gmail.com

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

Alban Crequy (2):
  mm/process_vm_access: pidfd and nowait support for
    process_vm_readv/writev
  selftests/mm: add tests for process_vm_readv flags

 MAINTAINERS                                   |   1 +
 include/uapi/linux/process_vm.h               |   9 +
 mm/process_vm_access.c                        |  34 +-
 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/ksft_process_vm_readv.sh     |   4 +
 tools/testing/selftests/mm/process_vm_readv.c | 421 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 7 files changed, 466 insertions(+), 9 deletions(-)
 create mode 100644 include/uapi/linux/process_vm.h
 create mode 100755 tools/testing/selftests/mm/ksft_process_vm_readv.sh
 create mode 100644 tools/testing/selftests/mm/process_vm_readv.c

-- 
2.45.0


