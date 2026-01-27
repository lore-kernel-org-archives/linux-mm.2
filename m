Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3513D2F038
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95AB6B0088; Tue, 27 Jan 2026 09:38:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B775D6B0089; Tue, 27 Jan 2026 09:38:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79C46B008A; Tue, 27 Jan 2026 09:38:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94F746B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:38:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 428B41401A6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:32 +0000 (UTC)
X-FDA: 84377999664.03.365ED39
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7CBFE10000F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ecNE2xXx
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769524710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QgONMmf4BXh7xFRKkGrygm3gsVIDoPskYWG8ACHeq6w=;
	b=qNJCNrAUIw6bJlxLDw+cdZ+Z2kO0J9JQjDpIrc9uUQBochDlCaQ9TCvp4gYwPdSRVec6dt
	0H89RX4vD4Wavm8mRTEdShchbrXUP6wEY1cceGwwicsesrOzMtWFEn9vlS3i/GR/Q8iFyc
	uqEWFEZM49hrs8mjXqbSLZJbGRLrN5k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ecNE2xXx;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769524710; a=rsa-sha256;
	cv=none;
	b=nu7Suxg6wy8zcMSorc3WOIEsTnzS183vkBwNFHIoal1TKQinDRWOTv//mJixNkoA/f2cDM
	bZRpYHTq4ScGzQTsZclya09NPWnSccTM2eJQ2TkQiqsDcuORxxIxX/t0J+1jqOgn39xr+9
	IxCyKwWOK6JB2UOpJz1pZaFG4pQMBZo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=QgONMmf4BXh7xFRKkGrygm3gsVIDoPskYWG8ACHeq6w=; b=ecNE2xXxfNF4vHKPx2DbAXENAM
	ayBMBpOWZkQGDoGn9035mWq5C7bgXeHltn67+UTx31WGsaLZO41JeCdIqX4vVivQSKcM9aoWtDmaa
	9fcEENKc8QN1OIbYA9pOnHdE0ZgwRFpmOh3J2etGkgFYtdd4ZqgZTrib0GG+n8Gck8H9/jw02sudU
	uiSIw2gqFDLHY6RYh5+SwrTCUMOzyFnXp2CX5g28AQXII8dHWOFAjpYkBblzf/3kwSzqHCsel3EQe
	+kJrARgt/AFa0/2Q249IjDbriMlwfh+H5yjPxPrxUqOznVvhCRPOZokLjrhiNsWz0uQ2GL+YhjVgI
	IQHrQTjg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkkCy-00H3b7-G5; Tue, 27 Jan 2026 14:38:21 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v6 0/4] kho: history: track previous kernel version and
 kexec boot count
Date: Tue, 27 Jan 2026 06:37:35 -0800
Message-Id: <20260127-kho-v6-0-56f9396681c2@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALDNeGkC/2XNwWqEMBDG8VcJc94pmTEm0VPfo/SQmHFNC1riV
 loW3724UrD1OPD9/nOHWUqWGVp1hyJLnvM0QqvsRUE3hPEqmBO0ClhzTVxpfB8mdE478YGlJ4G
 Lgo8iff56VF5e93v+jG/S3Ta6LYY836by/Xiz0Lb7W1wICU1yTR3YpNDIc5KYw/g0lStsyYV/k
 dWkeUeMGskZFylUgZI9oeqI/I4q1Bgp2eiCbyrDJ2QOiGlHBgnrzvfiXLRemxOqj8juqEaNrku
 6t02I/A+t6/oDjHZbI30BAAA=
X-Change-ID: 20251230-kho-7707e8a2ef1e
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-f4305
X-Developer-Signature: v=1; a=openpgp-sha256; l=4183; i=leitao@debian.org;
 h=from:subject:message-id; bh=K/gjwc3dmtHGoO3mUbyViJhw/1HKsI1mVxpRQ7XIlp4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpeM3WtZ0BK88k5/Abjvky0EFVZjtM1JFEayb4F
 nZ/hrNKLyCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXjN1gAKCRA1o5Of/Hh3
 bUQnD/wLmAoHoJ0uyREnAb2E/ciYIfTlYAxD/+eRVjHVtzNW1tW9le0JnXWRjvBg3agGwRNAERZ
 keqccybJhJ8Qlp3jitnj2hjy+VbM9vIGIi0jXwJHvBVapP07fMwJzmMVUqqIEN+t9Uep+30yynx
 jNbjEo7UCo7AGYE4tCoDmw9i98Cv2LrU32QIy8j1MZn775zSmmKw6Q8NMJLsA4x+cQLcrTEOD8N
 XF/jA59MG2BElxCedYkYxGwoIyT94+VAfS7RUhGFlXk7W2SQWyqUdTDV/xeVLDjy5VWPMPGQcVS
 lHzuqaSl7Wyv2ENMTCHGDkUvYB4GNyo8F8lHEUfgAwEPqFz7l7NnMOZqsd6TWREhSLVrY169p1/
 91lhAiC+GO8FRjmbywvczlbiURLg5v+HRiYjerjhNpLX26F8haIgeUHNAFxBmPMd642oHJ2yXgl
 ikobrlyZZgWJV1Ad/iMJKh/OK2b/4URdffTLXiKmBcVzby6MCaiVylW3jkaNS6/yMFDUBxJiPky
 vOQnlHdDR5S0qpwmVkR0a/Gcempv7NDEyiyCM9w76KPBSS3GBo+vuTOZEfzahD+QC3dO2MRrd0J
 A3ovdh8K+WAv3kfZSI/nCJlzhIrpHiE2qAKda/GO2NrZfL0YfX4BHliet+AQac9xGhki0bnvjUF
 CEJMYWseepXi5PQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7CBFE10000F
X-Stat-Signature: 1tr7o4o3zzi4kfhcmetzx3x1puxqabas
X-Rspam-User: 
X-HE-Tag: 1769524710-737418
X-HE-Meta: U2FsdGVkX1+mGDuS610ySOu1QiAlZ7rRVPYnHy7gxi17VAODI4xrcLW0oQm5QvpRjQucwhQ4XVm7qfMmaf8gWfTib7Drdkm/4ZY93HZVDMVIRuY8Q3GQZhtWL6KmW8lYjVzVTBxa+PXaTxPV2GWeb2CVQHabx+Aj9+agpp/o0ayIhhBy9QEVQAB22A5KvVexCF2iq6u8hfJkIRtaE8kaG7fsoVizh9I9ZRDr+2S3SmqgMg5kAEmOQ6m4L3RZkGlU+lNC4aixs2TqNPWjd/PcyATC1olmbrGfXebbHL1QwUNkIxdiDuCGgy3EMNMIOqH3e1GglFfW8egSTItGfSwhbgGdGX/he/qbm6pZR/8hRQ9UVszVpcA4x1kPvBkSSohhFU0rwNbdgfcEFomm5eSGPSIhJBxd1hrBFHo1A5Ks3MszPu4AVT9HuXz542UKAJOG5RKETJ7ptZwl8IE8LNCL+PQvXbi6cfMI1NaSgobypfRym7Lfrvx0CAY7NwJfH7BR0MLnKHxbJCs3TwGhzQ68VXL7NMH0qrOJZoBlow1Hhl1cbkRzqul7c2trclwQzFW8IDVjmP3l1/6Jr2EosAZhjCl5VNulkFAVngr0tqvrppSQENRqAzjfKPScopaca+qYzZH8dEbdBBf0qoGwu5mafxa9MKehxU+Qp4cy2CSM8Qz7grHm6QQJitkVgNCFT04pv+Ahx1YTZvbcXnJ+NBWpAeE6GCLyeFBR7K5wGEiwmTgZBOAYQ5xwVUEKMCUv7ZjGk3pTLqZ2A/VTHs8HgqUQt9ZJ6JWuexEKpeMXkMIagmt94Xt8+r+siw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use Kexec Handover (KHO) to pass the previous kernel's version string
and the number of kexec reboots since the last cold boot to the next
kernel, and print it at boot time.

Example
=======
	[    0.000000] Linux version 6.19.0-rc3-upstream-00047-ge5d992347849
	...
	[    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107upstream-00004-g3071b0dc4498 (count 1)

Motivation
==========

Bugs that only reproduce when kexecing from specific kernel versions
are difficult to diagnose. These issues occur when a buggy kernel
kexecs into a new kernel, with the bug manifesting only in the second
kernel.

Recent examples include:

 * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
 * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
 * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

As kexec-based reboots become more common, these version-dependent bugs
are appearing more frequently. At scale, correlating crashes to the
previous kernel version is challenging, especially when issues only
occur in specific transition scenarios.

Some bugs manifest only after multiple consecutive kexec reboots.
Tracking the kexec count helps identify these cases (this metric is
already used by live update sub-system).

KHO provides a reliable mechanism to pass information between kernels.
By carrying the previous kernel's release string and kexec count
forward, we can print this context at boot time to aid debugging.

The goal of this feature is to have this information being printed in
early boot, so, users can trace back kernel releases in kexec. Systemd
is not helpful because we cannot assume that the previous kernel has
systemd or even write access to the disk (common when using Linux as
bootloaders)

Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: SeongJae Park <sj@kernel.org>
---
Changes in v6:
- s/UAPI/uABI (Mike)
- Expanded the rename of s/fdt/blob to kho_debugfs_* calls also (Mike)
- Link to v5: https://patch.msgid.link/20260126-kho-v5-0-7cd0f69ab204@debian.org

Changes in v5:
- Add a patch to document the new feature.
- Change kho_add_subtree() to receive the size instad of guessing it.
- reworked some code path to make it more standard.
- Link to v4: https://patch.msgid.link/20260121-kho-v4-1-5c8fe77b6804@debian.org

Changes in v4:
- Squashed everything in a single commit
- Moved from FDT to C structs (Pratyush)
- Usage of subtress intead of FDT directly (Pratyush)
- Renamed a bunch of variables and functions.
- Link to v3: https://patch.msgid.link/20260108-kho-v3-0-b1d6b7a89342@debian.org

Changes in v3:
- Remove the extra CONFIG for this feature.
- Reworded some identifiers, properties and printks.
- Better documented the questions raised during v2.
- Link to v2: https://patch.msgid.link/20260102-kho-v2-0-1747b1a3a1d6@debian.org

Changes from v2 to v1 (RFC)
- Track the number of kexecs since cold boot (Pasha)
- Change the printk() order compared to KHO
- Rewording of the commit summary
- Link to RFC: https://patch.msgid.link/20251230-kho-v1-1-4d795a24da9e@debian.org

---
Breno Leitao (4):
      kho: add size parameter to kho_add_subtree()
      kho: rename fdt parameter to blob in kho_add/remove_subtree()
      kho: kexec-metadata: track previous kernel chain
      kho: document kexec-metadata tracking feature

 Documentation/admin-guide/mm/kho.rst        | 39 ++++++++++++
 include/linux/kexec_handover.h              |  8 +--
 include/linux/kho/abi/kexec_handover.h      | 31 +++++++++
 kernel/liveupdate/kexec_handover.c          | 99 +++++++++++++++++++++++++----
 kernel/liveupdate/kexec_handover_debugfs.c  | 28 ++++----
 kernel/liveupdate/kexec_handover_internal.h | 15 +++--
 kernel/liveupdate/luo_core.c                |  3 +-
 lib/test_kho.c                              |  3 +-
 mm/memblock.c                               |  2 +-
 9 files changed, 191 insertions(+), 37 deletions(-)
---
base-commit: ca3a02fda4da8e2c1cb6baee5d72352e9e2cfaea
change-id: 20251230-kho-7707e8a2ef1e

Best regards,
--  
Breno Leitao <leitao@debian.org>


