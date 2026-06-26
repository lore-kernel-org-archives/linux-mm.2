Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 876D8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 683B66B00DC; Fri, 26 Jun 2026 11:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634596B00DE; Fri, 26 Jun 2026 11:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524216B00DF; Fri, 26 Jun 2026 11:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3AF6B00DC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:34:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F6251404AD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:30 +0000 (UTC)
X-FDA: 84922460700.29.18BF958
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id C7669140002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YFtAnpCN;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782488068;
	b=ztz+L9+OTsHNSFpI9wXw08dWBjTX0Q2MBgvDNDz7xx23kP1jDjxpdRAMGP3xsGF2+C9I+q
	6Ng1r2iD4vbeP7oh7sjEskclLCCv/XlS1Hkhqkvdf6HIDtk6Qe/b2zoPmEJIJl+N/1vA9R
	OO6RONODrlmCDoJUkFtPgRb/TNDkdmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782488068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8iQ8ZAOfomvlKAvDlJjkPZEGiTc5LVdirLAMiAfeKJ4=;
	b=iNTFgDQtUokhKgFC9lmiPO+ZxmjG+VSrpLgr04H+N9zLNicwULm8BB9cMGMQBeMnpEI7h7
	FtSm66XqU6K5nBJsMIjnY019kRgUW8SDjLQPkkEavt5sdmhtqett/4IDdE6oaByg6rjJr0
	3kMNTMJz5fdinPmA1QLuNX27fDHx9V4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YFtAnpCN;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=8iQ8ZAOfomvlKAvDlJjkPZEGiTc5LVdirLAMiAfeKJ4=; b=YFtAnpCNF6ygpzWLETRT2McKXB
	WF2flj3KJt8g3EI1ab7ExJJ30LafPKDsjEtD0XMh8MoaAfqvxsBBHB1jK0pKCuK6lAzcvUvRMx+m3
	1nU+c2102HHQcZQpD6hEvflmOlL/DU8HA+mQxfTUeIoirJwM8zF8CWbUwmMveFrGmKn3bH7OIEnYU
	IpQrpDnFUhYb5ip+yS6/M6hKm6WCYocDCi5q2xc5r0aAJPxIgJRCixOPCae3p4mZ0C7WIpsx6aFRn
	g1bY3qJJ0bYT3zEOm4kvabg+2DP5uaFjBUrrsYAZqNMzZ6MSOcNIXtw9OrJUbi+UVokG2dSQl8Ry5
	zBg5O1xg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd8Yc-00447u-21;
	Fri, 26 Jun 2026 15:33:31 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v10 0/6] mm/memory-failure: add panic option for
 unrecoverable pages
Date: Fri, 26 Jun 2026 08:33:14 -0700
Message-Id: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIALubPmoC/23QTWrDMBAF4KsYrTNlNBpJdla9RylFv4m6sIOdm
 paQuxeni8ioS8F8bzTvJpY0l7SIY3cTc1rLUqZRHDuJh06EsxtPCUoUx04QkkFFClIIHxc3lgC
 c2CrfK+xtEIdOXOaUy/cj7O397718+c8UrlvANnEuy3Wafx7bVrnN/Ze7SkCw5ORA0pIJ+jUmX
 9z4Ms0nsQWvVFEla0qAMCTGiNlwtq6h6klZ7rYqQJAxeE9Zkg/cUK6prikDAkUka3OfDcqG6oo
 S11QDglM6s9fIpENDzZNqubvVbB/uFUryzkb2DbU13d1qAcEnStr2ycjY1tRXlGxN+0fDDkN20
 niPDR2e1OBQ0wEQWJGzjEjJ7hu+3++/gF/xRo4CAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9489; i=leitao@debian.org;
 h=from:subject:message-id; bh=+Qv0AmX9SxO878e+kPGU2PxI7ydYk1weWhapG5e4OJo=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPpvE6wZK3aFOFYXmYC8uzEAFKxkjNxH7sFsDc
 +n8+/OJ7bqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj6bxAAKCRA1o5Of/Hh3
 bS/aD/9kLCZn9Km/9jGLItmu9ctEQ3XK4Lf/gWLugqDJUWNxSseRmD4Y/BbRDKbwng/+0jnmfpC
 yoEOlRSx5Ppw27RPq4d6j/r47SvTkey/bjAEzbw71UescjGajMX5ESALSEp7tMkbIgoWUvHBSr/
 x92xNUsKLgpPBRLXUhkx8Wj2aFpVbeEA/yelshFMv2/GLK7LcuMkT+LtvXc3lCDWa5uIapbdEtP
 qM0YVVdUnEbRUlPhD7A2AdXs13ph9Rizqv3cwpoUPgXxsasxC0+8m7Kzo19Xg0nOO8VftUi+X2x
 QAjGsSvFmT1FrEMiYX2J1INttpt5RFOr34WCa3fzMsgo1KYpIgHwJAbRoBA7ZDuIBzqOB+fW4zM
 Vs+4Ozm+/1RGCPkWyt5b8bUxLUmhlwXFj9QXZLy6367JN1ADm1Gk7pIFMExuAqqrYE7P9L2XFpn
 Vsp61bVeetpQvDsJE0PvyCr+LnQftQ6rgVV0Hgg2/zJmjfLZiz0dt+kMmtnZ1hPur+UStHA/Jny
 bZvDOgFhljfOHi7PSw8I5zOHIBNK0NDgyU6TTdMnGgZSc5K+cWBvj7PEPD9UlbOXOPEisELOOfu
 3x4ptPSED0lQ+7/3xcgQ7BGwZxAAWk06rl5gPC4rInl3V9s41lAzQXTeAd5b0yjkYv3hiKkJ0iD
 3mHX2nRVpTGXZNw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C7669140002
X-Rspam-User: 
X-Stat-Signature: qjzgrdrizougks1z89n7xtbn8ah3n1wb
X-HE-Tag: 1782488068-599925
X-HE-Meta: U2FsdGVkX1//DhcbS0tYshLVKh7ZB9E6xJ0SOLIIxN5AxjEJtrLsqTFZU4HnSEjv9QEpcGhceF95qiywsWOcXyvrdb97jaAkin7x/5FqH8wOrkNn11uK7lsMmI5nGqePx0RF4kM0fn6UkaOY/+TxwNAfCDpW6QoYFMbuntDGZLpcJTI/7/ZvKHfYETwN85Fp6ZfXrhfridiqk4CYDDVguNTnEOVwaxRcuRPRjQjOTzELipucJ9slyg3k/GsH+wU4LEHV65KLgd4WXu+zZIcrnTqI6mEwkQz8SY/dyrEcJulvM9mT70Du1XPz4wzm3JYF6Bdb+NOscabuggKgJndmONRAdmbg5wzX1l34CZh9bX6ECYesRrYDs7soD/3gsBDNdDKg7y3ylAHCdqJiiJRFgAM80MnsMAxBNqb3HA1NWaDlrGzU00FQD5EPi43Icv42ac3cIq+fIzQBGY2Qf6hiUpvbmKpnwqDWL6KcVTZOvDJRvHwun2p2bd3QfWJvylOU0LMzDwfNtQENv12CYklmWAqWAZQ/b+ybFr4JST+I7yZ1s+ko01fpHuheZo13rkOHNA0qgZa1DlHLe1S2ygFLyZK2u6L3TaYjo4wt14OmDr4vE0GUuhu/yFyZYUO8syq9mHpf9UW71bPApi1PcB8w9LKZ/CByb1QZsr2rQfUAvmEj5Y6vYNHQyhbHQbGj2wBreVQA0HIOMZBU/J3M46m34uO+m7TyC5cEcQLspaiJtzvDqWSRKcQ1PgAfTazjnb/DxNkD/ay6imF+66agqvZPZgihgDP8ljPzAHKgGQXdAdRbOmjpfWrmCf8PdN0d82zUA8CQwMrTPMr+gRpSoEvLCenik+rwm7qTXZp10Zwv8WQGgnJ210kd3p2JA71AtGHweMK1k0SjrCWI1OiUM87ej13q37rXNmlEP7MQbjwdCBBBUS0d+zMITMOQVIxdj1j+/CMWodz6SBVa/XBzeU2
 vRDm9wTv
 KKYH3bI61r6+W5+UrKrQM9MSwMXOWChrXo0DKJR1Dxpc+4OQkfuyYEIcTu0UVJDQ02z2lcnJ+68rBsUluTHPHeh2GiLTFGJSla/mWIkBJljnAHSpSuTzqT084t/y249+2Qz1L4c2EWXCfj6AvRecfWZLHTtbKiFJp9YjYAx0z8iGuGSnoVf5nSqvEBPbTSI8kK69qhzx6zfzKG33fvW1JhglVB+GoHUm4ZPDsK4JGppcMve23HIj+muQu1S2L4DO+KTxrRzjKmmLl139Vwxp+wdlSF7BsZPCJQcQ5EUVk80+fUVYRRn1gOaTxpJi6kQEiGDliy4UwynEUqdCiT4K2rdBEa2+6coBdVtifFg8R1oF3Qso3nyqLPt7Rl0BxYc1iqly/pCmHF7pmcp3LVGtnzdgAvYvCVOV35YJYwcVhnQ6MC4XT+Gusk2srPS5We3qfgQ1Hy7NvWcdzbD/Sq+4KAjY0cEc9TlhAb19tgqJkxSF2tVcjuhF8GSwQWQmoTcDE/DkUOCKMAF/yQVFOSMeK2/HehiNEXBLpIZL04FnXeAkNU2cpIK6VYqmWDoXsBJXoS9XlbY5ytufnxxuz3g5VYBA/AtMhs0twmKP6mRLeIe+Q/RVxl2AIH9x6U+l9Gv2c8pI15dTuxdwednjXv2lYreibgadCSuZ/hi8i4MArBuEZ/K0TmP3QfOgjVDWk0ZLywRtpu3qHLZRtFVPq9BO6TpQtDJn2LlCHorjSgMI9dh8gr1f4wwYGos2ulNGYZ9k/G5M52hUsFA76KMvGdXCK8n18aXb2DtQRdOA8lKiq9M/kj207Y8cjyi1vqXQIChHK3YSqQnQMfXGc/3+m/yAK/L6KTxFofNx6arG8YSlrO/4V3EYFeoxYYxeokT3/kZ+zaRZyJ7d2JtGezUQMBjcEz4V1OaXefSjqCDUmEizXiE36602eSCgdbLtFlS3rts1OI1dak7psbO0UD5yvHK+GLM80I2ts
 Hn6JpIuN
 SEm11eL7LZM1/s7YoToeV92d1ua+nvMSLIryj+xuyiA3p8hjtJEI/A==
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
Changes in v10:
- EDITME: describe what is new in this series revision.
- EDITME: use bulletpoints and terse descriptions.
- Link to v9: https://lore.kernel.org/r/20260609-ecc_panic-v9-0-432a74002e74@debian.org

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

 Documentation/admin-guide/sysctl/vm.rst      |  80 +++++++++
 mm/memory-failure.c                          | 104 +++++++++--
 tools/testing/selftests/mm/Makefile          |   4 +
 tools/testing/selftests/mm/hwpoison-panic.sh | 249 +++++++++++++++++++++++++++
 4 files changed, 419 insertions(+), 18 deletions(-)
---
base-commit: 30ffa8de54e5cc80d93fd211ca134d1764a7011f
change-id: 20260323-ecc_panic-4e473b83087c

Best regards,
-- 
Breno Leitao <leitao@debian.org>


