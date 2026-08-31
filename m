Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2769C624D1
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D806B008C; Mon, 31 Aug 2026 09:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEBE6B0092; Mon, 31 Aug 2026 09:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3CB6B0095; Mon, 31 Aug 2026 09:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20BB26B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:35:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B21ED1C028A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:35:46 +0000 (UTC)
X-FDA: 85161662292.24.23D30FC
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf26.hostedemail.com (Postfix) with ESMTP id E33C714000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:35:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=SRYIzDVc;
	spf=pass (imf26.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788183345;
	b=oIk/tLSVLF7U/urZ5zLnlg5P/ciYUuWIji2/t2p+NTzeVZSPNC4lH8mUvxbmBNauXsIBwH
	QtHIpY9tn6D/hAp6rvUv3wRdXW2vOPxAsFWGz0ZCbH9toxWLl/xYrNo0OifOLzz7lJq7OP
	1gPpv7/l2Nr/II9gYMkOX8tPTHuAvkw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=SRYIzDVc;
	spf=pass (imf26.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788183345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MNIhhVbw7X5/d7sVTwXmPhv3XWWu8nVjTkE+oAnGKMc=;
	b=a8bAyIe8Lr3b5njdG4b2UE5x64qkEMZRwjZL+pIXpzg5qfN7m77LXyDTU8jqRyhaGXU4/W
	M58bOykHNp6GHxLRnsdWlpRqQr23TH/VzsCWIKnphNcwSNhrDcQLDBZABmjgCi5sRpmuSb
	QWcNac0i23F9TNssSkwPbsej28CTvYI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=MN
	IhhVbw7X5/d7sVTwXmPhv3XWWu8nVjTkE+oAnGKMc=; b=SRYIzDVcRlREcSQMkz
	IUXwLG1D/GcchB+9+Cp6maBH1EKJcpddPcz7v/tQm+YWCOlALd/qUSYKY9GgrYV6
	uzDIoG9ZJ/aTT+o2tWH+MXnih8rUbg1MmsS0b/+pU7OMmRQb0fhDZn+9MRqKpFip
	ad9AFMtPCpWFwG+LkZKrPHp1U=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wBHHmEbg5VqFKS5Sg--.13223S2;
	Mon, 31 Aug 2026 21:35:25 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	mike.kravetz@oracle.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH v2 0/2] mm/hugetlb: fix surplus accounting and availability checks during demotion
Date: Mon, 31 Aug 2026 21:35:17 +0800
Message-ID: <20260831133519.2505020-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHHmEbg5VqFKS5Sg--.13223S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr1kWrWrAr43uF4xZrWUJwb_yoW5AF4Upa
	98Jw1Y9r1kGry7Kr4fZ34qv3ZY9r1rXr1Ygwnxtw15Jan8u39Fgr1Svw15Wa40vrZ7uay8
	Xr4UAr1ku3W5XaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbWrAUUUUU=
X-Originating-IP: [39.144.46.203]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+B3n4GqVgx2NgwAA3N
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E33C714000E
X-Stat-Signature: q8j51jurie44juemj7x4sxqn8i6ampjc
X-HE-Tag: 1788183342-441208
X-HE-Meta: U2FsdGVkX19Mmj3D2SVpTc/SZCncokAAm+J4yTC3Y0s7YPJxbgkTYtXTSmEAq0h1Pz0Ap28vRz/8SxkqbXfnl8JAdEkbdwZ3KtwdK3CkwvPovefJbIgAOdMm4nQk9/N4+LLVqnIYD90WROQG7CfW1SW1W2h4byZ0tSuA2G5EnnUch7SQPBIEgFYWGnyd/vlGCnS00nt7rihtO8o2U069ceAcoBtEEnPnM2tLHl1YjPkw8nW6m4xhNdqxu2Fu9Ykl9roVbqRQWqmay2yNWOQe2gQXtteU5mwi9G0wWTHjJzrNytwNWA3Gj0AsPcZUaO3OXtYWd6i7ISWcToP2vQS+6D2JKyvb9eQjlOAT6DALqGnYmDoqIEJrE+fu/hNs3/56YUyoOASBnt3d9w+WPZDCffWa03N7dGmCawVtWkfbLh4/8cIJa/dY5G5EREKS/3csq4/YSZ5urWsYwg+Z5wcdvRXXp0QqGU7h8laAImQoqUl79qlSLK+fyP1Qj9Sfto1MRD7/O796xOrC/4m7FdxUojc6XJnHmRF/nvkO6/Smed0nrJj5Xi0tMCF8DQHZuHiug3a5+ivbk85bbuscPCHjB4rsEtOTgXMoJ6v+wveHRU3SiRdi5Kro9teEFK+ZMLEuMgPu+9DJTYdmiifmHGXarXq02PJ79lojgdih/+fM14+pY8OdJ7gV7QmdIVokqYL0Rb7ovt5B0EH4qKKtbQFWkXNm4LkgM7mFZLKPKoylmazef4hxpk8AjdcgQROObNCe0jhaWwjUrARagqbPuOInHWgoNXfh7vfN4iOu9hJkaRarz/+GntA6sFiOoAilAS+yV36UPFKix62EAEkxXxg1eED/igUeSUpqepd5j1sYoOmh+2bSuLVVq5V6AWLiIWL2b11GU7vN49ibbm20W4Ho1p8aejDauFImVEHZTQM72StumydeFyB4xgGVws0o2ZeS6Cz/i3fhWEQfWfT9iNZ
 F4X0QiRb
 QOWvFLDdZEkeVriQWB9lp3p3wlxDF+4FxHKleg8lRkxmks4vrUWGycS/9dOERxA8oNBgDLNT1gKMArDK1fuVt6CJFTQJqgGL3uuVquMFPNWzdA76FkQ11QFIvgH3X/2M6yoNVD5J+za1vDWObqa4aKYh2Jx7cmJlxtMvr7BZyvQ8sBAuftR52apZ9TYc9+GE+iyMT7C2tTrLJA8LIammGc5ECvUlmk1TCEocCAsNcVFc12UfK1W3QPN4zqmWof1eUNkpSGwRY6ECiXhbAryXt/83UyiEIS0FQWTq0UPWAJ/OUGYQWqOpCLarK5OiMzUpevkx9H9CCefh57T+2QX1dUV1hiOwgz4bD55BcUS+wO1wgiLlSbQgdSE7Z0jv2Gj6nVv6P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

This is v2 of the two-patch series fixing surplus accounting and
availability checks in the hugetlb demote path.

Patch 1 fixes source hstate accounting when the free folio selected for
demotion accounts for a surplus page. Patch 2 prevents demotion from
removing free huge pages that back reservations.

Both fixes were tested with x86_64 QEMU guests. The commands below use:

  hstate=/sys/kernel/mm/hugepages/hugepages-1048576kB

Patch 1: surplus accounting

A vmemmap restoration failure is difficult to trigger deterministically.
For this test only, add a one-shot fault injection that makes the first
attempt to restore the vmemmap of an optimized 1 GiB folio fail:

  /* TEST ONLY: fail the first optimized 1G folio restore. */
  static atomic_t fail_next_1g_restore = ATOMIC_INIT(1);

  /* In __hugetlb_vmemmap_restore_folio(). */
  if (huge_page_size(h) == SZ_1G &&
      atomic_cmpxchg(&fail_next_1g_restore, 1, 0) == 1) {
          pr_info("TEST ONLY: forcing one 1G vmemmap "
                  "restore failure\n");
          return -ENOMEM;
  }

The injection does not modify the demotion or accounting code. It is
one-shot so that the later restore performed during demotion can succeed.

1. Boot QEMU with:

     hugepagesz=1G hugepages=0 hugetlb_cma=1G
     hugetlb_free_vmemmap=on

2. Enable overcommit:

     echo 1 > "$hstate/nr_overcommit_hugepages"

3. Allocate one 1 GiB huge page:

     nr=1 surplus=1 free=0 resv=0

4. Unmap it. The forced restoration failure leaves the folio on the
   freelist while it is still accounted as surplus:

     nr=1 surplus=1 free=1 resv=0

5. Demote one page:

     echo 1 > "$hstate/demote"

   Before this fix:

     nr=0 surplus=1 free=0 resv=0
     surplus > nr

   After this fix:

     nr=0 surplus=0 free=0 resv=0

Patch 2: cap demotion

This reproducer requires no kernel instrumentation.

1. Boot QEMU with:

     hugepagesz=1G hugepages=2
     nr=2 surplus=0 free=2 resv=0

2. Reserve one 1 GiB huge page with an untouched hugetlbfs mapping:

     nr=2 surplus=0 free=2 resv=1

3. Request demotion of two pages:

     echo 2 > "$hstate/demote"

   Before this fix:

     nr=0 surplus=0 free=0 resv=1
     resv > free

   After this fix:

     nr=1 surplus=0 free=1 resv=1
     resv == free

4. Touch the reserved page and let the process exit.

   Before this fix, the access fails with SIGBUS and leaves:

     nr=0 surplus=0 free=0 resv=0

   After this fix, the access succeeds and leaves:

     nr=1 surplus=0 free=1 resv=0

Changes in v2:
- Add reproducer details and test results suggested by Andrew Morton.

Link: https://lore.kernel.org/all/20260823034307.1072415-1-xialonglong2025@163.com/

Longlong Xia (2):
  mm/hugetlb: preserve source surplus accounting during demotion
  mm/hugetlb: cap demotion at currently available free pages

 mm/hugetlb.c       | 57 ++++++++++++++++++++++++++++++++++++++++++----
 mm/hugetlb_sysfs.c | 10 ++++----
 2 files changed, 57 insertions(+), 10 deletions(-)


base-commit: a4ff2be345d0abc943da8dd8da98151843b750dc
-- 
2.43.0


