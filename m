Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB2EF3C263
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958186B0089; Mon,  9 Mar 2026 09:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919416B008A; Mon,  9 Mar 2026 09:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850436B008C; Mon,  9 Mar 2026 09:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73A786B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:42:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 156D6138AF6
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:28 +0000 (UTC)
X-FDA: 84526639176.16.2309FC5
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id 497E740008
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cBy1Wchn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kA1EryOehNm+a7EFry/ptsVIzbOSOAR5v3wv4RxFa2M=;
	b=65Oqb/Iv+rr636CMNZxtBooOnU5iAKpyJFc447joCybZnY8FWzi242mjUnba0r1YUJ+x+d
	UyhSa2CtIjGXHFH0fACcH3Ib0qUq5ZOn1SfoGsjziMNmSbg0kMLAEpdl2uJun1W1AGs//d
	Zxmrvbi/B780yPjKcxfqYMUAB9Tnq0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063746; a=rsa-sha256;
	cv=none;
	b=OYwBJqwHK7zcY5M/BQhPbZs885SImiF/yu7iEDqRJOD6H9XvuQ/hec7G9VUVjtd4V0c5ze
	lYqFGyEYrztzu6i+xFBSe1NnHerOMnQhZgycs8KNuGWXWxryOj4SkUXJ6jHo5pkelcJdwI
	NdJesAl7OR7KJNve+LGd/o1N4G97siU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cBy1Wchn;
	spf=none (imf27.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=kA1EryOehNm+a7EFry/ptsVIzbOSOAR5v3wv4RxFa2M=; b=cBy1WchnxLXmf55KnQhrgvGVzp
	8G7EGe9DOlhXMi3OrCYSbcdAA/I5tkX/UGU64CUjl0G19ELarMuSN/DxDTQ94//t1noPBzxKjS4Ey
	b4Xa1v0I/l6LngWo0/QS0QPDNVv08INi0miZ5g+Ae5RL8MNoYPiV+VZ42I6SPVsJGdJShwMJELuOa
	96/KJWN7WMkceCrlNo+Am+GIjISnrbWEl0YxddqA+/BTsnBu1/lnMRKJrcLVfwibR1k6jnrPW7T7x
	D8SMiGKcSJ85W8o+/ggOIgeDkUi3DuBcunCuzRM6KPwgbqLDvxb75kd4CT80aMa0KqJhRg5pepw5U
	tqBLQuhg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzasB-002G3B-8j; Mon, 09 Mar 2026 13:42:16 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v8 0/6] kho: history: track previous kernel version and
 kexec boot count
Date: Mon, 09 Mar 2026 06:41:43 -0700
Message-Id: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABnOrmkC/23OTW6DMBAF4KsgrzPVjG08Nqveo+rCfwS3EkSQo
 lYRd68IrUpElyO97725iSmPJU+iqW5izHOZytCLprKnSsTO9+cMJYmmEhJlTVIhvHcDMCNn62V
 uKYtTJS5jbsvnveXldbunj/CW43Wla6Ir03UYv+4zM625x8aZgEAndrWXOnmXn1MOxfdPw3gWa
 +Usf5FBQrkhCQjEmgN55SmZA1J7ZDekACFQMoG9dUrLA9I7JGlDGgjqaNvMHIxFfUD1HpkN1YD
 AMWFrnA/yH2T2iDdkAKE2rVPOGEvx+B7/IYU/SwwIGnUiHcnaEB7QsizfsuKRj+cBAAA=
X-Change-ID: 20251230-kho-7707e8a2ef1e
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=4751; i=leitao@debian.org;
 h=from:subject:message-id; bh=JMa0EXK2ERazXwyedUlbDfUy2dFNns/iAuCHS3HSjQE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprs4yriwTxSLkaVVSJDn1xLKlIr96i02KqYq90
 Ka8YJguSA6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa7OMgAKCRA1o5Of/Hh3
 bVXkEACM6MC3wIDicNzzeOJ+b/Q1gpyCUbfiJo4/ykM/LwGsUDitQKvlE4Lm2daQ6/eqJZ5n06D
 +wwMuxZ0ma7hr3Oiuj8V/c2XclEcSbfv7eFC36+o0e4kzsFPxkvdu2Exd6m2KD2WMH8xdUVF8pb
 renj1SIN73Mjoy79fhnfaZCMs009cH6YUpQ90gub9B1OWkUpY/jKs5P3tmhyDhzzwkLe3QbtvSs
 L8jCouQyHfowuOpLvS2a/JBhPbfHe6ztKZPOpr3u7yme4WT/L4WhbozPxWDjfL2zN8AZTV1z+hZ
 acKygDcyG/M4eZRAufznz6alMhRAXcDVT5xGCmwo30K6WTekCa7TqcVG5KeTgGtogm1REuzBixK
 vi5Ndxec+y025325lA4V7RRiw0cwx+EIeXsU2xvyNAXPM+nON1ZQf4cCpuv3EtlAd0Opiev8cNE
 J9zOZ2lwVmm5Ss3/magls1out/suIYHy5pYLXaS6GUMe+SHsciqWalA0mc3JVzYDVuPWl+1LH4C
 Qpzd7jo5NojgmXPDD5RB7X846hjwfy2DijAAEN4ToDcr64I3eNYyECGtJictMMcWsFU22slM2nr
 SsyLTeZfCvhknMEhTnoOjMus3Mex8EOeok3v4yGC1dMrGXCld8EPXjf02zj2rUFDYRvT2Pw4eem
 Cyn8k1E677XY/IQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: 779jp1hm5ixn8jmmxud4km196tbkp73w
X-Rspamd-Queue-Id: 497E740008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773063746-302951
X-HE-Meta: U2FsdGVkX1/uGYWvrog7bZEhY94Xv/AQ4rqezs2Bh8h8yLV3OADdex4CBrjic25xTRo52oZfBOtsiKDlT8xfBBOFyNdJigZhFNQ7hhckPFG5hYJ1ff46IRfgPN8PvyzAgB2WkptokcfGoqzoKT3nKnGMkzGSxe5WFb8g1XbwHXjY13EDWzXhySUllAWduvwkFW7D582X3rMF01Ym2ozRnadEdn0xjyoB04eYxj25XMv1VuN9in/Ng+Af3EIiroyvsu3XjFe+1EHtTs0b13uYSyN4V/mZhzUkkprmQA/J/r6qQv8kqsz8aggrNYjJEUv584vGaCNTm6HMqbIK6ndCvcLnpoPYMb2zXMcuCnUVsCQmelM0+HpLqj8TN7qFnJauQ7NisRSDj1mIPAPz3chCDkM6YwaC4TtFGK+aFQo/RZl8XWrR5t4eMqNFVYapnQGEQo1fAlGlHumDoKVs/yIWI5B/i+lrxVytkEutz/ztFquRYFxb3Owbgxuc4Uv9oXLdnw2MVdDSFsOMIwRFXMoHmSQLw0B/isKVeqmQPIvSHnCcRiY8WYnecoGhSClZF91gvswcjrf9F22B0ZIu4s1O2b1uz3F/l9Uu97fgsiys+SnaYCrub2IC9u1868NP4sn/umZVqDP2QxVD4duGk34cQIYVHDgPffEVz0r2gu7lqYKSXQ7nFJaGiKdcr5/vDmJ19sDEfKaoFzh4BqOZxU+/IhQzqIfJjBfRKtmwdwTd0JBAp7Iy1islmYULUZQY0vxKpSsOnYoV8A5XWPQL6JP7e/T4IC7+mAnreMZUeM3TQn/5EMLH0GTbUZ/4tMSQOEUYR2IGl+vIF/QyT4if2oDMtP82AIhHXJ47asGhJ319VZSEoaX4JqrFU/J3RmiHDiE1ub8r/WLFjW0POqLov5PTj0oVanIlyoEe1PwzOM+PARCb1mDOACduS91bdBF2BhX8giX0O+ZKFPDVJV4l0Ty
 /UK9aqrR
 Lp1gFlsxmDDd4zqEsbFgRrLpHo4uUx9C/5kmYNYozSecvxfUSX1jMUcHghLpu80eaA8JLjeelcw2W5gN93L3xZXpLyPr0Lyv1iNKkaY3s48SSy6I+EnUzbot764tIkmLVtEI8CjrIXUBOKRAWcZGTmLiNWjdxDhAFydZ419f3uYDoOMfTcFjBS+o+eNbrgyZ/kVrE0rUAuE6j366bkehsE24qUCNyKyjB0pgOuJETPJyKhESuwGsBiwzlIoD3BzxZGCXSo+hNOp3ujKc=
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
Changes in v8:
- Removed an unnecessary size variable (Mike)
- Moved some renaming to the proper rename patch (Mike)
- Link to v7: https://patch.msgid.link/20260306-kho-v7-0-404d14c188bb@debian.org

Changes in v7:
- Persist blob size in KHO FDT as a "blob-size" property so the
  incoming kernel can determine blob sizes without assuming FDT
  format (Pratyush)
- Link to v6: https://patch.msgid.link/20260127-kho-v6-0-56f9396681c2@debian.org

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
Breno Leitao (6):
      kho: add size parameter to kho_add_subtree()
      kho: rename fdt parameter to blob in kho_add/remove_subtree()
      kho: persist blob size in KHO FDT
      kho: fix kho_in_debugfs_init() to handle non-FDT blobs
      kho: kexec-metadata: track previous kernel chain
      kho: document kexec-metadata tracking feature

 Documentation/admin-guide/mm/kho.rst        |  41 ++++++++-
 include/linux/kexec_handover.h              |  13 +--
 include/linux/kho/abi/kexec_handover.h      |  51 ++++++++++-
 kernel/liveupdate/kexec_handover.c          | 134 +++++++++++++++++++++++-----
 kernel/liveupdate/kexec_handover_debugfs.c  |  56 +++++++-----
 kernel/liveupdate/kexec_handover_internal.h |  15 ++--
 kernel/liveupdate/luo_core.c                |   5 +-
 lib/test_kho.c                              |   5 +-
 mm/memblock.c                               |   4 +-
 9 files changed, 260 insertions(+), 64 deletions(-)
---
base-commit: 3f9cd19e764b782706dbaacc69e502099cb014ba
change-id: 20251230-kho-7707e8a2ef1e

Best regards,
--  
Breno Leitao <leitao@debian.org>


