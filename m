Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D34FC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC616B009E; Mon, 14 Sep 2026 03:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA7D6B009F; Mon, 14 Sep 2026 03:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB686B00A0; Mon, 14 Sep 2026 03:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66F5B6B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:31:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3F2F41132
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:31:06 +0000 (UTC)
X-FDA: 85211546532.18.59E5DB3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id E3252140007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:31:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kPB08EjG;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789371065;
	b=p7Ef2ymQGvVwpwFyT5slBOpgUYfpXhQpblziHkJYtBDdAR5yp6dApJdobpMYd/s+coaTTG
	B6n0j/UDm19gTB3frUrFyEWL9IL28lNlLPviLqHT6A2oqjN/S54dvREnxyz1CUji1Jx/n+
	hg0bNKxsFsYJPnJL1FfwYk8YekKEtwk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kPB08EjG;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789371065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aGLAStuaaNNOTL5BPmdBMRjWmnwGxEnrOyeQgcLCQ+s=;
	b=1kU4FHJWZBvNycEM/nQMLHLdg7vJkHoviBuakubfqPJ6FLaCdvNkYtdOBV9qHYD3Bcr3Co
	fBlCxDOqOdrkW9odJjAXnwFeIfpOCHV5VuwlxJdiOK9OmxLN9nh9ZrxfYRKsGaD/W0i6Pd
	qi5fK9hyfNZkOhUhvY/cOpD2CCyOgA4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73DC71576;
	Mon, 14 Sep 2026 00:31:00 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FE8C3F59E;
	Mon, 14 Sep 2026 00:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789371064; bh=izQCU7IUhvJ7QRLLcnoy3tPOfrjmRr71yMTllFN+vlY=;
	h=From:Subject:Date:To:Cc:From;
	b=kPB08EjG6xAt/80eBymF2aYquxso7lT4+G9qJmu3rbjSvZ2my504OLDKkosGBxASe
	 f1OPLN0swFlTDdECDniZhgPYB+IXFZCv+iHuufr/BBKQ6MIkOHjSBfCcTEPy+zdcl/
	 aTEAtwMawJZV+mR07SbakMxWQFrY5KZCnSxApB+w=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v3 0/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Date: Mon, 14 Sep 2026 08:30:45 +0100
Message-Id: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKWip2oC/x2MQQqAIBAAvxJ7TlisBPtKRCy56R6yUIhA/HvSc
 WBmCmROwhnmrkDiR7JcscHQd7AHip6VuMagURu0aNUh7xZu8rydtKdLOUJjiXGcUEOr7sRN+Y/
 LWusHAWLtQmEAAAA=
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5213; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=izQCU7IUhvJ7QRLLcnoy3tPOfrjmRr71yMTllFN+vlY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqp6KyXsCpV93AkxG3X6hqxvw/KBfTNi9mgBjTH
 sVjdigSSmqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaqeisgAKCRBt1cPRWsUx
 MxKVC/96AgGeBKcHO8ZFEYTHoR7Hf2y9tgl5K51d+qp+Qu/iSmXNHfVouaYoBJgIXbU/VFQ1So7
 EnrOTJvSYmB1W8IYrKVmEAbVFDsv/WBWinyS62lAudLWX5gU9lj97Xc23qHDv7mnpvfX/0+kgvE
 dxMbEqBbxd7U2edAABzcy+8FqHRilFRFnH7xN6Z7w2e14Xw33pLw6+v5hSlZPMBtRC96QP2OwTg
 D1sLT2IQfp2scNzBbspCl5zYrIFeF95N+r8trXLYTticsXaDqdCLGiyAgwk6959foBmAaoEiWa1
 U3r0xtF27SHXapYza3MHSnk08lXSuzIX4fRS35BOVFmGOdrVbi0fY7Fk9D9jT/wnp+TiH2tTr/E
 MIdQufB0VsYHnT3Jy7VG/eX9nUKLhJtTtDoEaeiAKaGF7HLb6oVw6bopsSveUl6CnGcnQSwlavY
 MyGK5FL/rdneotQrcvxa/p6LwwFLghpHy60P+v6g3l7hbFEirJO+D4GIHP8Bk6tdi+I9M=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E3252140007
X-Rspam-User: 
X-Stat-Signature: tbk1gsbsjjs7y4cfu6rh4cuo96jmeaza
X-HE-Tag: 1789371064-40884
X-HE-Meta: U2FsdGVkX1/b3DAATUBAzEKXa+HLx8Qtv3sIfpplTHfhWl+jk5cgJv7s17G24Jv9dCJ7iV1TnT3EROZiAziQPvEeSIoEeWUfkLrb+vE41JyV3zuM9QKQ0BDIqTNri0HVOz5lIWIHMS0qaBRTJDxklunLTWWSPx7ods8uctVeYp4OjJEYuLEzn5auLpjzpRzNMtyl3yYKMgPPXqjNJb082yM9EdQLAbcWlYQHIioO8oJeTCsXT4zUDczbp3Oev7Jj6e3NHP6yFXs3Czmn+pLUfDH8U6ApUc9xOaDVu+hKBm7dANllrSHm3uxWgqC2Ynu/zxkWoI42JznNYjC6cFAaLG59jXsibtNUn+7i+SD5v+gRS2lZFJf/o/3LGnhPp2wM+8fPbXoSxbf8KBUhUyHwxwkcsnS8GUsha5mGQQFPact4MxWDFvc9mQHyInFFjBXAun2fbqZPm49cj/0Jy7rIpLKL1RC29quaAddZ4zPeGKkCONNIp47F/G7WAdNtMMKUlLsom+ExzcisRgps33TZsOoQy9IaupOpgKiRCqY4P09RGD1SilDx3YfFv+rdTFtDlmDZgKh5jmzo187QXzmFtxcNvbCzL5Zg0IJLE5Sg+CFAo0T5faK+QiGygZUMqhJLqepFD10rS1S2JvP1RK/LWZmMRMACYJd4rLjsTD24RyWYRYlesFP3y84u2IBClx5NqfJuWxEAjrH4t8h/Kr53SIK2wFOgRr+NX7r2h02wQVefUrcppBkE3UBRU7MU+ct5gdg4QX478tOufVlrZZ7zNt9hCDpE2L57JH+vcvk/Dj22CPnCoHT7qklitXOOxUgdVOyTMVkSsWOMcWzKWbtDvcrkDbV8sd1RGLB73/In7xGwfUQjIYuwIY9flT3HDxt15HlnwfOOvtKgjlII7W4W3EAI+Tkm6i4zTZ7yn3RnvHmwCPIWdUSsyIT5R0sjK8IG4AY8Si8++LAed818NEs
 +TXtnG/W
 lCDHzUgG+6fuKVsOFX/eupSFEQdMrbwgW/k4wkR4ncwnPR2k6SfZrz8XQSrGnpc7xmqrU2jhMNdf498G9P499LZQPdjHzsfuAVGkmZFiaUSs/YaoAqPsJNdmXjblT8bJnSMHmQTMIVxW1TONE3qEcfySPLjvd2RbMQhJ4+yz3XosBQzJaJWCnvvyxN6NCUG5weBgNB851sXhCi65ZnkHwQ7KEFC2xizEnzOkCau7yfLln1T+j+j7DaN76vTr2RQCYT6mRRmCtRkICRbEatjp1x2C3Ywy4eeZCIy2mAI0qoF8eATpBxQ7k0CQuAT7JXh/MY2ulBC2LJvaXbTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
When this macro is used in some test, test result would be strange in
the system where PAGE_SIZE is more then 4KB.

Here is the example with transhuge-stress test with 16KB PAGE_SIZE:

  transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
    3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s       2566 succeed, 58507 failed, 2566 different pages
    0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s          0 succeed, 61073 failed,    0 different pages
    3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s       2566 succeed, 58507 failed, 2566 different pages
    0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s          0 succeed, 61073 failed,    0 different pages
    ...
  ok 1 Completed

To address this, remove the HPAGE_SIZE and HPAGE_SHIFT macro,
introduce pmd_pshift() and rename read_pmd_pagesize() to pmd_psize()
to keep consistency with psize() and pshift().

Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
PMD-sized units, the test may fail with the previous size of 100 MiB,
which is not a multiple of the PMD size when the base page size is
16 KiB or 64 KiB.

After this patch, output of transhuge-stress:

  transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
    2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s       2585 succeed, 1232 failed, 2585 different pages
    2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s       2585 succeed, 1232 failed, 2585 different pages
    2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s       2585 succeed, 1232 failed, 2585 different pages
    2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s       2616 succeed, 1201 failed, 2616 different pages
    2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s       2627 succeed, 1190 failed, 2627 different pages
    2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s       2628 succeed, 1189 failed, 2628 different pages
    2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s       2630 succeed, 1187 failed, 2630 different pages
    2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s       2631 succeed, 1186 failed, 2631 different pages
    ...
  ok 1 Completed

Additionally, introduce size_to_shift() for future users that need to
obtain shift of a huge-page which is other than pmd_psize().

Patch History
=============
Change in v3:
 - rename read_pmd_pagesize() to pmd_psize()
 - introduce size_to_shift()
 - Link to v2: https://lore.kernel.org/all/20260907081509.924979-1-yeoreum.yun@arm.com/

Chnage in v2:
 - rename hpage_* to pmd_page_*
 - Link to v1: https://lore.kernel.org/all/20260902175611.1241118-1-yeoreum.yun@arm.com/#t

---
Yeoreum Yun (3):
      kselftest: mm: rename read_pmd_pagesize() to pmd_psize()
      kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
      kselftest: mm: introduce size_to_shift() helper

 tools/testing/selftests/mm/cow.c                   |  2 +-
 tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
 tools/testing/selftests/mm/guard-regions.c         | 11 ++++-
 tools/testing/selftests/mm/hmm-tests.c             | 22 ++++-----
 tools/testing/selftests/mm/khugepaged.c            |  2 +-
 tools/testing/selftests/mm/ksm_tests.c             | 16 ++++---
 tools/testing/selftests/mm/migration.c             |  4 +-
 tools/testing/selftests/mm/mkdirty.c               |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  2 +-
 tools/testing/selftests/mm/prctl_thp_disable.c     |  4 +-
 tools/testing/selftests/mm/process_madv.c          |  2 +-
 tools/testing/selftests/mm/run_vmtests.sh          |  4 +-
 tools/testing/selftests/mm/soft-dirty.c            |  2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  2 +-
 tools/testing/selftests/mm/transhuge-stress.c      | 25 ++++++-----
 tools/testing/selftests/mm/uffd-common.c           |  6 +--
 tools/testing/selftests/mm/uffd-unit-tests.c       |  8 ++--
 tools/testing/selftests/mm/uffd-wp-mremap.c        |  2 +-
 tools/testing/selftests/mm/vm_util.c               | 52 ++++++++++++++++++----
 tools/testing/selftests/mm/vm_util.h               | 12 +++--
 20 files changed, 116 insertions(+), 66 deletions(-)
---
base-commit: 6b41451631cabf9ea3b384c2a099088e1598f963
change-id: 20260909-fix_hpage_macro-da069ae04502

Best regards,
-- 
Sincerely,
Yeoreum Yun


