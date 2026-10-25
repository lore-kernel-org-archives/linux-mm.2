Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7306606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jqs8+H7i
Received: by kanga.kvack.org (Postfix)
	id E71226B05BC; Sun, 25 Oct 2026 13:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21676B05BD; Sun, 25 Oct 2026 13:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B796B05BE; Sun, 25 Oct 2026 13:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6D76B05BC
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C4E1405D5
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:38 +0000 (UTC)
X-FDA: 85361863356.15.F931874
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	by imf26.hostedemail.com (Postfix) with ESMTP id CD85F140003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jqs8+H7i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3RNZWA4Vw9nvvnFumtjjNtTb4RFaUcDB/rCF/xLRA7k=;
	b=h76DFs6dYIy7RoJdKGJ0EFseCXuZaIEG5bR4vemW+ewbsuGe656gyfNUH5sR4sIhQzlzIj
	xEOge0kNq+dzjpvoeWTsUtnY4Rw3fXxQpmiIO1XwrvQC6oAXWEB75WWTflwxdzfp30cal0
	ce3KzunWfhkS8u4k274AOvzcpeWGkzE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jqs8+H7i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950036;
	b=cZgodZ6wVscxn5KBh1+A0jaL6tdcbDEgwj1EKTe80fYenfYXlwIN3KAKAV/SO0yZDhKglb
	yEb0JNpHYFXtj3iAhOI3+6VHSwXwy5Mx10qGU8wP24C9FOzJYfLqm7QvwXIMSIzGGC469Y
	IkPvtLcKW+yzweKKIHAWNDHf1UnyXY0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JEPOtefzw+ZIKLKGXFOvsCze207bnrZQqzXanSKG5k4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792950034; v=1; x=1793554834;
 b=jqs8+H7ipL2rCVjv2KfyGevaTnRgSXzxJNvdmh8xNS0rSuxyt38jbF3CPUAP/Sy7n/ikX9nW
 ntVExNRq36W/xZVM7Z6HoP6Z6E/K2hnGjV7rpqEuzJLvPHio1K3eGLgAjwJK2JIfbP45Dgh6ryK
 UNKwF91MISUSVdDuuuRlpacA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c2b717936bb992ce;
	Sun, 25 Oct 2026 17:40:18 +0000
X-Mizu-Trace-ID: c2b717936bb992ce
X-Migadu-Flow: FLOW_OUT
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: [PATCH v2 0/2] MM: Tighten control over zero-page remapping
Date: Sun, 25 Oct 2026 11:39:45 -0600
Message-Id: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM7QpAQBCF4VvR/La1Jra4FUmWwZCPdpCSe7f4+
 XQ67wVCjkkgCy5wdLDwMntgGEDdV3NHihtvQI0m0pgoG6tRprLl80CFttUGKcU0NuAvqyM/fLm
 8+C27Haje3gbc9wNdCsU7cAAAAA==
X-Change-ID: 20261025-b4-ksm_fixv2-2bf062e92946
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usamaarif642@gmail.com>, 
 aarcange@redhat.com, "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: CD85F140003
X-Stat-Signature: bj8b8qu5ktie87ayfdmjmc5j8yr66j8z
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792950035-485474
X-HE-Meta: U2FsdGVkX1/QY3fqlYNWw4WsRgVwbqEcZssBh16+4eTF3V+/xjo9hzmeK7nluqYtRdhxnC9Nk2TYDWkgEriE4vHOKLcG+P5volmVKpMeUqMbLdhZrZm4UJAHxZ9yPkCPlCW3YrIkj0GF3Zteoep0+RttleSoVvMEbizo85XtdG6hOYi4CB9CX1bqi9mzsD32/MxQA9Nfc4buRY7yh4ZoTS+1IUB6RrGhwrDDbVRnuSlXNCnpw3AsdRtmuGVVbANIn2F3Ff3cLGIH1TerwwrhmKn6BLg25qgs0OtWWjyK5/wnpcyKGeJW9nWMij/hhi0f0NKLoza2bnxcc0yZiVLaACJF3S6pyt6WW1AxRMxqL+bIZqWn8ZD+XncANsRQnG0rOfBO0LOhHf4x/Hxf+1mROgEp6OfIC+0tSLlny10yoAcf750Qm7bjY9qm9siw1OV/Enr7gAAX8Q+1NRDsgg+0nZoMEJRmHiB9QVvCPvQMEL/f5vqMbqqT5XUvw81A05Tonwd3Y8YHoXjbDTwztRInX5GgxU2p6oI1o9ifyXCI0ibcUv5ya+FOP23coULSwW2qc1alht99BoJ0yvwwid2L09Pd2wrO0R3nrhUDWqJklzUQzeZ2oKfVX7RD8q2rDdSlJASjMVUxgbK0s8njhydskiQo9mFb44fpwwKbcjdGxHQORhDaGpVewnOD3Voll2UATmEfmHWdstaUJM3bg7JoVx4CBf9bUk9xvwYwqEoXRjg2jvfKfJmpSQo0vSNDQMGPcksztdxOgjhdDnZOw8eah98HfyGgZUCeQ6U8c5rA4H6DI/inf9EPTZf0ZPQ9d+wgtM+QytwkRW/pr42K3hmvWOmhpQ8fAGYtqZwhcezxdm3/QRZ4i7PvJIoX3s5hu726uBbYr2zs9zrU6aPa0f/wpmoCpw6y+HXbOf/XCWPOpSWr7H7CEn/8Xwt98+53cnkFhNbYB0HCoz663Q3RfQZ
 qF+RA9Cg
 nBfXMmrFt4bBi730zJ/V/ZrQTid+/UsJltt+MFiUkRkiKB1yZGjZdE9MFY8y5vULieNqL6KP9PTrG4Z9nby0Cc6nM0yhEy+PWMFy8zRP1j2QVZgckU7+rCfjVCVUWMkpfRywIpcR+YWNKZjrUkz/h/mIeLD1viyLZNlVjB80vKuADWdOaOpK7T48DzLCh2fXl+USt6+RKPUZfTo87eOjK/JXI1DKbg97xCKVyUGKSM+8py/IonPDaCs5hUYnZ3ju9celJO+lkveZaF8DwtdS+z6gTwON2Y/bphgVTswb/64eJP6nHKUGP5jMwVm/VloJcb3wuAcdFwp8Jzw7LQ/YY+WkzXE7HN5ih1nRbCuaFVuPnmF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This patch series fixes a bug in KSM where the pages_to_scan limit is
bypassed and the policy (use_zero_pages) is ignored. It also gives users
further control of the zero-page remapping that occurs when a folio is
split.

Commit b1f202060afe ("mm: remap unused subpages to shared zeropage when
splitting isolated thp") added unconditional zero-page remapping when a
folio is split. This was sold as part of the underutilized shrinker, but
has a larger effect. Since this commit, all splits do this zero-page
scanning and remapping, even if the user has the underutilized shrinker
disabled.

This unconditional zero-page remapping was also problematic for KSM, as
when KSM would try to merge a page, it would split the folio and the
zero-page remapping would remap all zero-filled pages to the shared
zero-page bypassing the use_zero_pages policy. When the user had this
feature disabled, KSM would then waste cycles scanning these already
freed pages, causing little progress to be made, and KSMs performance to
degrade.

In this series we also gate the zero-page remapping behind
split_underused_thp (the sysfs for the underutilized shrinker). This
provides users with more control over this behavior, while also preventing
the KSM bug when it is enabled.

V2 Changes:
- Dropped ksm_is_running() and its EXPORT_SYMBOL_GPL (Lorenzo).
- Replaced the v1 approach with a narrower check:
  introduce current_is_ksmd() to detect ksmd and only skip zero-page
  remapping when the split is triggered by ksmd itself. This avoids
  disabling the underused THP shrinker's zero-page reclaim on VM_MERGEABLE
  mappings when the split is caused by something other than KSM.

V1: https://lore.kernel.org/all/20260609114619.144416-1-npache@redhat.com/
RFC: https://lore.kernel.org/all/20260508170509.640851-1-npache@redhat.com/

Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
Nico Pache (Red Hat) (2):
      mm/huge_memory.c: skip zero-page remapping when underused THP shrinker is disabled
      mm/ksm: prevent zero-page remapping during ksmd-triggered THP splits

 include/linux/ksm.h | 6 ++++++
 mm/huge_memory.c    | 3 ++-
 mm/ksm.c            | 5 +++++
 mm/migrate.c        | 3 +++
 4 files changed, 16 insertions(+), 1 deletion(-)
---
base-commit: a2abad0d7f453cc9902fc8bf7b871db5563a652c
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm mm-unstable
change-id: 20261025-b4-ksm_fixv2-2bf062e92946

Best regards,
--  
Nico Pache (Red Hat) <nico.pache@linux.dev>


