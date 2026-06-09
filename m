Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BADE9CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221C36B008A; Tue,  9 Jun 2026 06:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9066B008C; Tue,  9 Jun 2026 06:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EC26B0092; Tue,  9 Jun 2026 06:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F41A86B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:57:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6E771C2923
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:37 +0000 (UTC)
X-FDA: 84860073354.01.2B3DFC2
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id DE19718000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=M+Wh8aO7;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781002656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NUw1no3vQFX9EOgXz+vtElmwkxf14VIbO+M2GscH20c=;
	b=Rg+Mkcw9bln7EFBa9X81vxEvpW52TuvvH+FHzsTevMUmE5AJBPlbCw1u5QNRGw/Y7zg8cb
	fQfuNnGxenQ3M8xXyC6eDtzJdoY0fnp7BlDDPXqM4spygZP5QIyn8xVWMqSs48asLW+ECq
	uvrl32NwS3VUl9e4emu90i0eNOdLQPA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=M+Wh8aO7;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781002656;
	b=H75BqceY8YbyYZe4runuA5WoLECgEgN4XB83miTewcO3T5ErjqDBEJc+mS7Zt9+7vZLQyN
	bKGXrRt5+2GXXXTE1yhovye1Qu7352EGtgBV2qOCChGef4NeNtGgibFaKBq6UBrtxOrJR4
	D+xmD5wOIJKQmB4if6SpvSEWGW1LTn4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=NUw1no3vQFX9EOgXz+vtElmwkxf14VIbO+M2GscH20c=; b=M+Wh8aO7KjNIpVrFdfYe2R+Q5+
	8pqjwVB/Lbnlj1UbRqsrjN1o45LzWlzPhkQ+E8pg+YzOBWYqa87cxCw38kdhKJmWkpapKAwjcMmt4
	osg2G+PTi9g4m0LC9epOd77n8V8QF5nGxF8wkRv5pWVrsfeckeIS1x1ggkwxLodMqJMlKMecrDfbt
	2F5FNCAPDTuriAdt6uZ2rG1u09UlDOxe3Vp7Vd4UcquVdzADCPLD0za1FQ0yLCUtfJDkaGD3oZDLI
	fm9n1w3EjdEz/hSLaznulIbgX+6pD614atkoaahOxuFiYDI6ptnN86NOEXsn1tE0OJqzLZCjQTO0N
	VlARR/Vg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWu8q-008Lt8-2S;
	Tue, 09 Jun 2026 10:57:09 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v9 0/6] mm/memory-failure: add panic option for
 unrecoverable pages
Date: Tue, 09 Jun 2026 03:56:54 -0700
Message-Id: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAHbxJ2oC/23QyWrDQAwG4Fcxc46KpFmTU9+jlDJrMj04wU5NS
 /C7F7uHjHGPAn2/locY81DzKE7dQwx5qmO99uLUHQ+diBffnzPUJE6dYGSDkiXkGD9uvq8RVFZ
 WBifR2SgOnbgNudTvNevt/a8ev8JnjvclYOm41PF+HX7WYRMtff/lTgQIlj0dmSybqF9TDtX3L
 9fhLJbgiRsqqaUMCMesMGExqli/o/JJFW2mSkCgFEPgQhyi2lHVUt1SBQickK0trhikHdUNZdV
 SDQhe6qKCRsU67qh5Uk2bW82ysJNIHLxNKuyobenmVgsIIXPW1mVDaf8m11C2LXXrhz3G4smEg
 Bs6z/MvOdJnXFICAAA=
X-Change-ID: 20260323-ecc_panic-4e473b83087c
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9278; i=leitao@debian.org;
 h=from:subject:message-id; bh=4q+m/q/9D0qk1AYIowkmaI4NFqQWTn3bCYXkUMG87eg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqJ/F+do7Ut+FBaddOPG1+2qVEDpcVf8ikfWZbA
 7qewc7PmmaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaifxfgAKCRA1o5Of/Hh3
 ba/ZD/0YWvdiczpAWmvI6ykiRuMzvIr3wTG4PKKiC1VMAplKfaIlQwVeuLVjJssclzNO9cgITHe
 1D3Kgtla/irdCqhN7/1vywoUHyxD5Kmq+ViPyJpckeeQA2vck4NeXMakolv6hYLuHBew+yUsV4V
 0aqliEXX0aKG0CYTiJSNrOMhyaCBB2B0pZ4UtyjCrmKDbx7U5C3q65HIBfkdUGmxxSGHL+xrkpq
 XZcshhtNTOOnQmMIjuP3jUM9bvz0a8nb2LwDC1lhg+/eHoSuDZIdEOUWtK9T6EVuqyl4s8X1zsr
 H6dfb+nafbXc6vDu9u0BC4aky6EXIufdkoVcIOfmBu/X4wSivucoWrIA6nU/XwTREHO2DqywUct
 qYlLVrPC4LqNyil8bJ7jXeV7AgGElF0adr+td/2lIKP5T9BsNZfS7Px3dyb5qXFe2cnCFlHr5mn
 tQUvvWKcPmVw700SiPYKNB1JeHR42j3293/qof5+TPD0qIXumNMZwMzOx1p/i/zYg7kA5Sp5r7U
 y1KW2vQGJKE7s0Bn+RHMJivnHyKv2jZci1P4mZuvLySNzlP2HcgaJWj5xSiY1xXlyUnT68LmoDa
 ppk1wkudwX7t9s4SFbBPd2zcFmf1LL9iIpNfKBYWj/0c2LoAUPTTLJxHFjizxjzZe+KIZQOqxu/
 uAECt8H4sHQyxhw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: DE19718000E
X-Stat-Signature: om4fqb4exxhtxq384fei5o4xmwiq7rf6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781002655-912657
X-HE-Meta: U2FsdGVkX1/cb9Vt0XxIK5XcOPWADtSN2eIMkanv+HZh8q3peZBMpKrH/tBAZMjGzWT+GJUHy+4q9wdctUrK/U9KvU30GIpa6RLlbpijtZpPLySJX1u+ZiU4f211T8X3/FI5IP1k1JtMrhmnVIH4rSKWqVmAa4ECMH8djMFzRhV3eNggjNb124QdZyq1XERhy1Vg49W/c7sYmF8yA1VFdrQAV60oKLJnysHNMEpEspASle6uQhL4Lgrx+eZFZkcQH27+LNH3cu4DpUOCEw8dT8/88TZSEO48e8fvDuBafQhewpP8faICt8NrpnxXLq5KHt8WaJ1gBdthjCICNKXb/Po4kZ5j/ViUSWfO53W/+R2ycOEB8Ng7yWU7x2Mmz5/I/Dde5RX/rG+yU9u8QmNMUvoyLKoQuUPBOgmdHOV2SH79/yOBd809mTxyt/yRWeKwwZxa38U6C7iUdkxhNtsnwevRHwDGUlQ5tNWNXzpjRwDopRNOAcrOWLDxJcUqkGahERZl0PU+JkFRFKLO279D7TjHjDxWtWhNLbA0m0Iro9W/yk7odZ1MplxbVbAdFePHd+tDWJtBoAdERpedeZlxcM2sp9RVuXrmbhIMgeKg3g9gwU4TrrPyaSaowjTLbSo+bjFI5cuSkAeQK8ykW+UMnylBla2OJa5CvyjszCn/IbWx/C2mqoWaxPYe7P/dabR6LYyP6aT7+6TUcYYqVnVYWleribAeF3vJ067zsZP3p2ccbPFFg9AHUXAV4lTew9sP75tNf0zW4APfyLXbNFXKyZTSJf33dFNjlwO9LzHKue8ynJ0DDt06EUf03hqYhT39pohDajCf5vapFWyQrWSDkYGvDxRjsjIJp+8LA88HhA1+bW+wyn5jZNw1mPLhQuTNw7DKw6LNdqpEXcNtTDusGiK2ol1rVMx8v8rRAQe83YES36OsucWrHHXWGbdfvJczDDfO21ji0g2BB30V9ee
 ba49I0EC
 1DQxpnpgU2fxr7gw3Rdw6VVGTdMno0kEziNUKKmQ2UhOk603PTUrK7WYKWac7W3wgpwy/EMcvvB1zMZ7ZJbvbej3QUM3thwbDvhgkn030m3U4G+Cz/hoNW8ED59uLUN/QzaKK0PQMQ71hPg6iHeNZ2Wbvak62mFtq5uNumjF2uz+NGsDehWp8zPG2pJC4Dke1AXITDPXVrMeyu/kE+zdCcc47D2rbP8BuPZ+bPFzBgklzA+0EdcdYOHUN6nDNkV8kkkCkn3kV8hPzdoubRYBNSSupAoxjkQRdTbnPXhvkcASzVVeI/YmrSCog4cxG0xptXHImhqWNHmvE6C03wDK+Cc6O+khkzbYtmgdk7lg4sdhpBVOhT0LQGwiTNQBjB/LOIeRod+tqjTeJaIwgQIL/SfsnJ45hz+xm+Fy7hlA7bBGLpOp4N/Qf1sIzeRpbATlwXYefhfUHT/kdgEpBSUal7QFZUFwQnDEo6joUzaOb9CetmsKzqM9y7kt1Ktu7C9Ryl6SCTgr6i0Vjt3w4siaTwxeIowCOCiuNyw/Q9JXXOM8VVO7mRerUUTYG3kFP7aaVPci7nt5dIcXtypjD+fX9zPEk7mUyhzm+HHCaOnhpsaANgBs0DX6DGE++LZc6s4xscJsLONKQVMCn0y3qs/0LBA5wdcHh/cs4h0cvj0NZ878NEdioKypgK1tmkxgITwxP4zrMkh7ZSqYxPWbb3bmevnhmY/tScJVcJwZI8qsADOJsO5JMAzCoR1AZgFh6zVfI1o/DVnjvC7jzwirXPSqMhUsGg+8c8rILtbsZkRTTX0EPc/ITMp9rU1fqXVd/iXSPa9w8BKn0TAlQmM5cir5mXc8wpOMVoHLkEEjt9KYQE4ZUQ9xFxvON4YmQezSVUB8sjObS//rL3P7mNOixPkCj4xYgmr4x3B7Ld9xO+JMreHUVtzBEoNST2nRe1ZlIRdplNlRZEpeJkWge5hcL7pSjjw5vaFA0
 GAa+DnrR
 bQkHmpF7DZhsgn/2O9UpI3ERzQHWf6WSd17xLSdi4EeurVcWV+3NWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A multi-bit ECC error on a kernel-owned page that the memory failure
handler cannot recover is currently swallowed: PG_hwpoison is set, the
event is logged, and the kernel keeps running.  The corrupted memory
remains accessible to the kernel and either drives silent data
corruption or surfaces seconds-to-minutes later as an apparently
unrelated crash.  In a large fleet that delayed, unattributable crash
turns into significant engineering effort to root-cause; in a kdump
configuration, by the time the crash happens the original error
context (faulting PFN, MCE/GHES record, page state) is long gone.

This series adds an opt-in sysctl,
vm.panic_on_unrecoverable_memory_failure, that converts an
unrecoverable kernel-page hwpoison event into an immediate panic with
a clean dmesg/vmcore that still contains the original failure
context.  The default is disabled so existing workloads see no
change.

There is a selftest that test different cases, and I tested it using
the following variants:

  ┌─────────┬──────────┬───────────────────────────────────────────────────────────┐
  │ Variant │   PFN    │                          Result                           │
  ├─────────┼──────────┼───────────────────────────────────────────────────────────┤
  │ rodata  │ 0x2600   │ Panic with "Memory failure: 0x2600: unrecoverable page"   │
  ├─────────┼──────────┼───────────────────────────────────────────────────────────┤
  │ slab    │ 0x100032 │ Panic with "Memory failure: 0x100032: unrecoverable page" │
  ├─────────┼──────────┼───────────────────────────────────────────────────────────┤
  │ pgtable │ 0x100000 │ Panic with "Memory failure: 0x100000: unrecoverable page" │
  └─────────┴──────────┴───────────────────────────────────────────────────────────┘

Each one shows the same call trace, exactly the path the series builds:

  hard_offline_page_store
    → memory_failure
      → action_result
        → panic("Memory failure: %#lx: unrecoverable page")

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v9:
- HWPoisonKernelOwned(): wrap the head-page checks in a
  compound_head() recheck loop so a concurrent split or compound free
  cannot leave us trusting a stale view (Miaohe, Lance, David).
- selftest: drop the gawk-only strtonum() in hwpoison-panic.sh; do the
  hex parsing with a small index()-based helper so the test no longer
  spuriously skips itself on mawk-based distros (Sashiko).
- selftest: move hwpoison-panic.sh from TEST_FILES to
  TEST_PROGS_EXTENDED so the script is installed executable rather
  than as a non-executable data file (Sashiko).
- Link to v8: https://patch.msgid.link/20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org

Changes in v8:
- Commit message rewording (David)
- Add HWPoisonKernelOwned() helper (Lance)
- Removed patch "mm/memory-failure: short-circuit PG_reserved before get_hwpoison_page()"
- Broaden the selftest (Lance)
- Link to v7: https://patch.msgid.link/20260513-ecc_panic-v7-0-be2e578e61da@debian.org

Changes in v7:
- Move the PG_reserved / unhandlable-kernel-page classification into
  get_any_page() and surface it via -ENOTRECOVERABLE, per David
  Hildenbrand's and Lance Yang's review of v6.  This drops the
  is_reserved snapshot in memory_failure() and the mf_get_page_status
  enum / out-parameter introduced in v6.
- Restructure the post-call branch in memory_failure() as a switch
  over the get_hwpoison_page() return code (David).
- Drop the "reserved" qualifier from the MF_MSG_KERNEL label and the
  matching tracepoint string; the enum now covers both PG_reserved
  pages and other unhandlable kernel pages.
- Squash the former patches 1/4 ("MF_MSG_KERNEL for reserved pages")
  and 2/4 ("classify get_any_page() failures by reason") into a
  single classification patch; the series is now 3 patches.
- Simplify panic_on_unrecoverable_mf() to a single return statement
  (David).
- Link to v6: https://patch.msgid.link/20260511-ecc_panic-v6-0-183012ba7d4b@debian.org

Changes in v6:
- Dropped the selftest given the value was not clear
- Get the status of the failure from get_any_page()
- Small nits from different people/AIs.
- Link to v5: https://patch.msgid.link/20260424-ecc_panic-v5-0-a35f4b50425c@debian.org

Changes in v5:
- Add vm.panic_on_unrecoverable_memory_failure sysctl to panic on
  unrecoverable kernel page hwpoison events (reserved pages, refcount-0
  non-buddy pages, unknown state), with a recheck to avoid racing with
  concurrent buddy allocations. (Miaohe)
- Distinguish reserved pages as MF_MSG_KERNEL in memory_failure(),
  document the new sysctl in Documentation/admin-guide/sysctl/vm.rst,
  and add a selftest verifying SIGBUS recovery on userspace pages still
  works when the sysctl is enabled. (Miaohe)
- Added a selftest
- Link to v4:
  https://patch.msgid.link/20260415-ecc_panic-v4-0-2d0277f8f601@debian.org

Changes in v4:
- Drop CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC kernel configuration option.
- Split the reserved page classification (MF_MSG_KERNEL) into its own
  patch, separate from the panic mechanism.
- Document why the buddy allocator TOCTOU race (between
  get_hwpoison_page() and is_free_buddy_page()) cannot cause false
  positives: PG_hwpoison is set beforehand and check_new_page() in the
  page allocator rejects hwpoisoned pages.
- Document the narrow LRU isolation race window for MF_MSG_UNKNOWN and
  its mitigation via identify_page_state()'s two-pass design.
- Explicitly document why MF_MSG_GET_HWPOISON is excluded from the
  panic conditions (shared path with transient races and non-reserved
  kernel memory).
- Link to v3: https://patch.msgid.link/20260413-ecc_panic-v3-0-1dcbb2f12bc4@debian.org

Changes in v3:
- Rename is_unrecoverable_memory_failure() to panic_on_unrecoverable_mf()
  as suggested by maintainer.
- Add CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC kernel configuration option,
  similar to CONFIG_BOOTPARAM_HARDLOCKUP_PANIC.
- Add documentation for the sysctl and CONFIG option.
- Add code comments documenting the panic condition design rationale and
  how the retry mechanism mitigates false positives from buddy allocator
  races.
- Link to v2: https://patch.msgid.link/20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org

Changes in v2:
- Panic on MF_MSG_KERNEL, MF_MSG_KERNEL_HIGH_ORDER and MF_MSG_UNKNOWN
  instead of MF_MSG_GET_HWPOISON.
- Report MF_MSG_KERNEL for reserved pages when get_hwpoison_page() fails
  instead of MF_MSG_GET_HWPOISON.
- Link to v1: https://patch.msgid.link/20260323-ecc_panic-v1-0-72a1921726c5@debian.org

To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org

---
Breno Leitao (6):
      mm/memory-failure: drop dead error_states[] entry for reserved pages
      mm/memory-failure: surface unhandlable kernel pages as -ENOTRECOVERABLE
      mm/memory-failure: report MF_MSG_KERNEL for unrecoverable kernel pages
      mm/memory-failure: add panic option for unrecoverable pages
      Documentation: document panic_on_unrecoverable_memory_failure sysctl
      selftests/mm: add hwpoison-panic destructive test

 Documentation/admin-guide/sysctl/vm.rst      |  85 +++++++++++
 mm/memory-failure.c                          | 114 ++++++++++++---
 tools/testing/selftests/mm/Makefile          |   4 +
 tools/testing/selftests/mm/hwpoison-panic.sh | 208 +++++++++++++++++++++++++++
 4 files changed, 393 insertions(+), 18 deletions(-)
---
base-commit: e7e28506af98ce4e1059e5ec59334b335c00a246
change-id: 20260323-ecc_panic-4e473b83087c

Best regards,
-- 
Breno Leitao <leitao@debian.org>


