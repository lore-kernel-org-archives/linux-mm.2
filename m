Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69921C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6F76B0096; Sat, 26 Sep 2026 05:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557DC6B0098; Sat, 26 Sep 2026 05:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46DD26B0099; Sat, 26 Sep 2026 05:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2501D6B0096
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:26:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A635B16087C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:26:54 +0000 (UTC)
X-FDA: 85255383948.20.FC000AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id F262340008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:26:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOuRxBEY;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790414813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ESmr6c9B3f3nPHgJ9uIGzyifAGO5yB3Lw2nHs6HrCGI=;
	b=D9q/QCwauHaqwSpLqFqPXuuZ7U4ez3SpSZK32dltQVhOFoZ+J+2GOtAupvGYKekjpzhsRy
	ye6y7649msq66h4W+u0ZL7exw2dW3Av6w/kdzz35fLLqz5c9bxnNvxZgHtfvc5qtfmNYvu
	QL4EoD0/quhISv4Ej5X/38Ae2PqD7u0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOuRxBEY;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790414813;
	b=faE+FSSsyxA/ZDPuV1E3e7/eNh+jQycmrW4f5mVsPCUL/YTvPaD4GHs1NZ9UwfQ+1s3SpN
	FbVfd4PU5jOEtbY4yz82E7hZhFSEuNqZr5xyblFSgy6v/XdA41OHfiEctqpxeZ0gPwsLS4
	nLpnzG/pPVtJF8Q5Oaiw9AH8oxF4QMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 285B743E27;
	Sat, 26 Sep 2026 09:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340D41F000FF;
	Sat, 26 Sep 2026 09:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790414812;
	bh=ESmr6c9B3f3nPHgJ9uIGzyifAGO5yB3Lw2nHs6HrCGI=;
	h=From:Subject:Date:To:Cc;
	b=FOuRxBEYB8jZsQc86a0abbiPSCGuVnZ3dl/ZVCDQpDGwhDchPhx1mx2qZmuVIUza7
	 dGG6SHxZJAcUWQ+27tgUyQVZXe6sK7yxODc3PctEl0fhb5ElOINWn4LjJD0z78SoNC
	 GHvsSvYyUrAoArg5BT4dn7DNtFKaN5/By8CPJflPSPVlDbomVkiTgdjzEl4orM+q9Q
	 OU+vdQCb1BQl+r30ju34Nr3McD6Wp4PLcAGmlxgTl2z6gkUDfuPflHTHpTuTETX7pX
	 1w0bJrCQKiurLmCqfhaRxZpLR9J33Kslw+R5p2cvobTUR3PQ33Mz1eLKm4Rm7K6+EE
	 t9fa0m2bP+kEw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/5] hibernation: make safe_copy_page more robust and
 remove debug_pagealloc support
Date: Sat, 26 Sep 2026 12:26:29 +0300
Message-Id: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/1WOQQ7CIBBFr9KwFoU2oa0r72G6YNppQQUM0EbT9
 O5CjQuXb+bN/7OSgF5jIOdiJR4XHbSzCcpDQXol7YRUD4lJyUrBWi6o0oDeypg8WgtWQSMQ2oa
 TdPH0OOrXnnbtvhxmuGEfc0Q2QAak4KXtVR4Z46I5GUNnG6KEB2ZH6RCdf+8vLTxn/drrv/aFU
 0brsR5GidUAyC73tMPH0fmJdNu2fQD97zla3QAAAA==
X-Change-ID: 20260916-hibernation-7603b86eb981
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F262340008
X-Rspam-User: 
X-Stat-Signature: 8x74yewfnc6ofpgeo5jubkcra1m6j38a
X-HE-Tag: 1790414812-699526
X-HE-Meta: U2FsdGVkX18f7Wdhi6Xwg0JY6oUMKCXVjELXT4zAfFu4ly6hYwWowc+4Km1o+2eWffKJC3PkGT64t2mrWo5lpnx8bsGD7xtKFZI53hODJ8R/k76z/pp8en2m3csbpl2w3+enIMBGk5N+ZCZmfOkFliSrnaZeh0h/p545WKJ340uT4D0CRQMhGjwGv5qHUL89yUE/v9r+zwGEs4PZmiEWTRPw2am62ieprY214wzBeTV+yJW4grVXnk3iZMic0ysELX2jJJ5iLBAOzb9mC4Igln1lU4SME7TwuwcDwmtSfiUyPkQ3CKsDlTr9Z6i2z86OUFLXz6MrAMSasYOVex7u3e3inAVuJH99ZzDA56f6vry5IIBby6XlsMvMhm52BvVFpYXCPRvBVn822S62lZj8TDU3ZnAL4ktsYRbXfhBQHblBU7xSSgKRKt5H741xSZqSTKNsz1zD70NQ7OpO4nm8akrFNKrlw39tpeJPy+6mtCsKbeSoUvEQCmWAP2ew5wka2M52TjfYs4SNOqYnYGlt1NnTGhXR30psYRGoAVA5b/y7c2U2IqYwUqCEDSG1JDNTlRvaspu/Cpu3PbMfJ7w+eCCxda9J7kWAmVmgq9Fv7MGS2tXN0lzbxX7M9c/e6Hn7z9FTH3e/OOSVZpbRz3gAcw2k9LsUDf5NTwJmHdlPfdR3BO6uqfcyd2bF72qMYRKkJwWibJyQRdZQ0cMaGxTlGTVvVUGYAfU2CJJ3kaJAP39ke+VjEJV1kIEbCaFKZyc6tNDt+SRokUyfQKo6qHTkyqTXfyHd947/wHbWLeiC0QQL4fGfZK5/7XPRkE4ysa8Ur7q7UY/rmINlI8gQTLg4sP0+XbaINVclBWPpfLSXXH9dFX0xsB9TqrJ/0q8NZ4Oa4TXWntJYpVK4a94zxazyv7Q49XefMtx7n73OQsSigZYGaB8FeCPDRxKKHIGjHLa1Yd34xOnt0ZqtfKcq1Rm
 A74JIdas
 RG4mTElhJ0pSQI805XYpP1409FilG5aCSpQd5f+oMQ6dKt/lYtHymhinBvXtt0YHDaoyKh5cEuXmxyV1qibMmndFV1P0HIb6YhW94W8u0gPaS8CRqSZWxGWg8vFCeR4EKxPSpVUImC9Uo4qaDauIA1VXw9zntxEEL4JIswHSkr8rIdff7HqtOBuVldIniOlP1POpRtQcqMzeygQGCP2bktss35HB/PBiNqF1eA8nZrkJ0IBelsKLSov0aNmykb30bX331/Oc1g6Ps383MOsZ//jEz4tTtdXzi//CiCprNyCet/oOiCrYCb+ZB0wVlVyxtutUK9WCAyj3ZcKFPGkq/Z25kW29+QdscR5txQLXAy+sVlK+8mlkUuiU2EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When hibernation creates a memory image, it uses set_direct_map() APIs to
temporarily map pages that are marked as not present in the kernel page
tables.

Initially, this was intended to support debug_pagealloc along with
hibernation on x86.

With the increasing desire to use set_direct_map APIs for hardening
features and with their inconsistent implementations across architectures,
using kernel_page_present() + set_direct_map_valid_noflush() to save
non-present pages in the hibernation image is not very safe, to say the
least.

Worse, some combinations of debug features, such as debug_pagealloc and
PAGE_POISON cause a crash during restore.

Keeping debug_pagealloc compatible with hibernation requires a complex
infrastructure for tracking free unmapped pages with a page flag/page type,
verifying that it is actually a free page that hibernate_map_page() tries
to remap and making sure there are no stale or failed page table updates.
With init_on_{alloc,free} and/or PAGE_POISON on top, this also requires the
ability to map and initialize these free pages on restore.

This complexity does not seem justified for a somewhat niche debugging
scenario.

Instead of a complex fix to support hibernation with debug_pagealloc, make
sure that copy_data_pages() and its helpers properly handle errors that may
happen during page table updates, explicitly enable saving of KFENCE pages
and disallow hibernation when debug_pagealloc is enabled.

---
Changes in v2:
- use hibernation_available() to close secretmem race
- rename kfence_restore_mapping() to kfence_reset_mapping() for better
  symmetry with kfence_force_mapping()

- Link to v1: https://patch.msgid.link/20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org

---
Mike Rapoport (Microsoft) (5):
      hibernation: make swsusp_page helpers static
      hibernation: ensure secretmem pages don't reach a snapshot
      hibernate: handle potential errors in hibernate_{map,unmap}_page()
      hibernation, KFENCE: explicitly map/unmap KFENCE pages
      hibernation: make hibernation unavailable when debug_pagealloc is on

 include/linux/kfence.h   |  29 ++++++++++
 include/linux/suspend.h  |   6 ---
 kernel/power/hibernate.c |   6 +++
 kernel/power/snapshot.c  | 137 +++++++++++++++++++++++++----------------------
 mm/kfence/core.c         |  52 +++++++++++++++++-
 5 files changed, 159 insertions(+), 71 deletions(-)
---
base-commit: 99d08cb94abb5aeefbda36dc8bd15677c6f76f45
change-id: 20260916-hibernation-7603b86eb981

--
Sincerely yours,
Mike.


