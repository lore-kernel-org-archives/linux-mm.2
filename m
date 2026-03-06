Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BBEF0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689006B0089; Fri,  6 Mar 2026 07:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640D26B008A; Fri,  6 Mar 2026 07:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A246B008C; Fri,  6 Mar 2026 07:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 454436B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:39:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9679B8E02
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:39:49 +0000 (UTC)
X-FDA: 84515594898.19.890C82C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id EEB4C140016
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:39:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tQTiC2Y4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7fWIWTImvNF71LxdmXyLO15hWAJaM+X+968gLMH/VM8=;
	b=1Ae2CX01Uy7EzinksShI2W7YyBd5L9NZUZ3eNfNN6p2w90HluPGUzBGdhFoE1JqqaV+t/0
	qFLzbAPNNND0YcteZZVGz0cS53oDw+VCquDlIs5LxGqUFMkeUysvWqnikdBlBuYkjS0hUT
	95zjQ1kCMG8C1M32Du4iubBOLyUHEnc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tQTiC2Y4;
	spf=none (imf26.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800788; a=rsa-sha256;
	cv=none;
	b=nC8gBVz1QcOq19XvjYFCHM0MA9hd0cuGEMEJUMVcuUH2R8L6IU6bGTvp4kEjSCU+ZwS28b
	WnYBSGr4C+LIcYPWhKaPKOchOQSB2c3jx/I+XE9bv29ZNNXlyvo6PYfOQcePt/FTZ9fcHn
	LQrZmp14OcCvqLhXZKeQ+f+G0ubDHBM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=7fWIWTImvNF71LxdmXyLO15hWAJaM+X+968gLMH/VM8=; b=tQTiC2Y4ZmJ8kiKYz6tfF7kE9Z
	gFy4ay+bnzXyIJfcUkc0mcoNjaCRe2cMG+xedSH/tnPlvkDKFnGRVw5KWIksbph89DJ7tY9sFuaBZ
	yK6qubmZ7j+vzZd0/MaBTO9hQ6nmFxQoiPgYqzGvrYbauEG8AcZDzS/VFGvkSHTn/2uboemFoYonY
	XpVPnbLUpV/3T/OOODN+aKlNTPnmELCoECm0HgAojgWos0hJwUaC8XHkO2wWwrDBo8hjwiO2IXMsQ
	84SgLzjkttenem/F4r+k3PEE5T8xuvA90CSPd4Vx3mMRBjm3cEyMCQhmhbRlwOHTUkGhfpKLu5IqJ
	GEAmdkWw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyUSw-00HVQm-PP; Fri, 06 Mar 2026 12:39:39 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v7 0/6] kho: history: track previous kernel version and
 kexec boot count
Date: Fri, 06 Mar 2026 04:39:19 -0800
Message-Id: <20260306-kho-v7-0-404d14c188bb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPjKqmkC/23OTWrDMBAF4KsYrTNFo7+RvOo9SheSNY7VQhzs1
 LQE3704ouDgLgfe997cxcxT4Vm0zV1MvJS5jBfRNnRqRDfEy5mhZNE2QkllUWkJn8MIRJLYR8U
 9sjg14jpxX74fLW/v9Z6/0gd3t41uiaHMt3H6ecwsuOWeGxcEBJMp2KhMjoFfM6cSLy/jdBZb5
 aL+kJMoVUUKJCAZShh1xOwOSO+Rr0iDhITZJYo+aKMOyOyQwooMINjO90yUnJfmgOweuYosSKA
 uy96FmNQ/yO0RVeRAgnV90ME5j93ze+u6/gJ5BD4dsgEAAA==
X-Change-ID: 20251230-kho-7707e8a2ef1e
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=4547; i=leitao@debian.org;
 h=from:subject:message-id; bh=lTSkdOOL0IoKlvxUJCVsNH211AcVUPEFFdVll3QRwhk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqssGyQFqpuiPB8uN92ofZ0vEKSUVyN8mNuaON
 p6Y25NedrWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaarLBgAKCRA1o5Of/Hh3
 bQFvEACVRR+fFIXeg0+fxkMt9oRmqo0Bn84nlxAybPAOtx/V9XkqaZVQqjfR64aE4rbXY8odIqX
 u5HN5qDDj9rgZJxRbUrv1evtrFzHa+ilV2/zbLvSSKGg6Yywtt9KdClmnc20AZcqnoynjKTNHjC
 s0rzEhZtmxApEyQ+fZ2EQrFjm5jExDI4eFe9ng2QHE4COx1+7tr7Ln84hPDV0peGcNCbe9cCX4q
 N/5pBNRjRXzkOSNA6nafIhM6d4iy0Wv2fKKE3WkOXLWrGSozgDF08+vcbuiPLOWMzBbkg7rvqgW
 R/jsoqjplddVK6I7Zu0MzE0NDdC1brv2tmwV2yIuc9PAX2X9NhTDe7X9680GbIIahcNb+lM/CVr
 03xD+7MYRrJp5mXZyfmAEGEZI+kZ9NzzL6jAmX3eXPuFCmRUIZef9sK4GLN1l/y4JQmXDy8lBuZ
 c56EZJDVwewl3r7IY7w7Rc80nyyIsbTHd5BcDW/oxmhyk9HIrgpFz9XqhuXdQVQlSvl3T7BKI29
 IGYmW6TI7fr1U6gs1rQxlLgsiGeszwIvInDFXekkQtHWqaixZbiiuk8yAGmih8QCmt2mYb30h1R
 MXDBvLtcF6KVCCW930pQ43JF1G9Z6y4Mak3S2M5Et7QItNCw8Bqu8DMWv360DzvTrERe95gz+tH
 boPMl0AzFNHwtqQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: EEB4C140016
X-Stat-Signature: 3d19xtpe8cerk1o1s8pu8wbnk8dmd4gj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772800787-733583
X-HE-Meta: U2FsdGVkX1/RFB0K9524ZxWGskk8zDGSa3ckDRJM6OHwr6bnyWFh1WCEAraZI3iGDiegvGtf7v69npgc1Z2jnjFqgBKodRUqPqHC1hSRNI93xMfiC0Lrcdpae8HjpvU/ZU7V+7BRZUFMvrnJSANc0u2+W/7Nudu6uSbt9h7kFj9rkdIwpNb1mqdRewOewjb58IzH7qSBN91VJQ0CRLv60QkZWGVvabdZrIbczuxcA4ZkvJTRVyWPwrd0CUDj/Wobu6ANwDl1dXxHtTy9dWMSUbuBCONtVTSgB8BLNHuTtkZ79HmJGMfYsUp8OTDxEc2JiklNQiJDA+btC7l47ZKF/FgTRvpge80p/dlRdb21h1S0LJJRwEpwXVKNw1FIU/0djYfklwFteFOPn0Ntax0frGESWXLJG9O/0RMBomJyH9fzejw1mvYkxb6NUCJ01DsT3+YYmF3Avd2Gjln0Tr0t4BDcHaEJFIeF/iqk9/btdVYDP7wKcWlMHw4DiC8l+WHYrWgY5TfVXYo5kvihvPHmLA9TFt6vmDMzpJYK7iUuMhrUPueDRhGFvPd7bHOuDJAS0Fw1uPYUjyhAIyI7Aq25Ai2oK6EUysr687PaXqSKJ/ORLlxH4i8QkzPGCfSltXd+CneXB1obP7dUC/W5xeSZHZjKx2nP+yXr+2kn+Ptymdxc/ZHDTbbrVllAVXjn0Ze1vcHXrmYrhL2W1wEc5g0KGZ0IQoNmuFeSXKnDJDgB8d6IuHBPmMuxDC18XTDH2is99eHfJdVCxDpeG8yxvJXiXx4edEbgJT1OFBDtdZxP2dN5Ozd7/dCEhKEZtYX6MN9DYf1VjL6YbzWjY6XxXM8+lyi6XfQMNF8AQ0z3OMJo7j83ZNI1dHEdrtmo/Yh8Fv5T2hsWrxXpQAJTlccSxUZaSYEmFkUyKW8t1YDXfeyU/nNTYvw/x6LVlp/olfmbcn4RCY+x7ti62xcxLQmvkXz
 BOg8Zc8u
 JZA4zp1WrpTdoP4eiaZWooW69xs3tvhp6iBhj8AK6tmT6m1X4oVnAIcedtWVasTFZIM88OlWTtKxiVhNl4aaCOQQtiumvVtYc05g9wbeAhf1LPY8MW+cSBIxdyrKnLl4ZYz9lUA9uGzDGGwfpPctmlJUM5+wL5eXREnRUOZWHNUNm7dTh7tTZ2Lg2sMuRT3Ug7xDirUiUrLOgH1Orx8LMhAy8j/AdVlUAok9rB5icecFExxJBbVYpNb7JRc7LyDQOwkNRwHcyH3sa+YE=
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

 Documentation/admin-guide/mm/kho.rst        |  39 +++++++++
 include/linux/kexec_handover.h              |  13 +--
 include/linux/kho/abi/kexec_handover.h      |  43 ++++++++++
 kernel/liveupdate/kexec_handover.c          | 128 ++++++++++++++++++++++++----
 kernel/liveupdate/kexec_handover_debugfs.c  |  60 ++++++++-----
 kernel/liveupdate/kexec_handover_internal.h |  15 ++--
 kernel/liveupdate/luo_core.c                |   5 +-
 lib/test_kho.c                              |   5 +-
 mm/memblock.c                               |   4 +-
 9 files changed, 255 insertions(+), 57 deletions(-)
---
base-commit: 3f9cd19e764b782706dbaacc69e502099cb014ba
change-id: 20251230-kho-7707e8a2ef1e

Best regards,
--  
Breno Leitao <leitao@debian.org>


