Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590C9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443286B0111; Tue, 30 Jun 2026 08:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B5E6B0115; Tue, 30 Jun 2026 08:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B066B0116; Tue, 30 Jun 2026 08:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 096D56B0111
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:46:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C2EA1204C5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:51 +0000 (UTC)
X-FDA: 84936553422.28.0642988
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id AC71220009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BWQLB8jU;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823609;
	b=NSSkAW05TH7G6O89oLYYqqSnBi7QBAdZRy6Z1zUetXvhyDETsceQg5Dm6j4mx83T9IsbDH
	qqnLD6xVriYkCRqXBbXOFC8LF3lR3cQrwJoEWXNhizMOPm+odNDFFMJrJz4pFD+Uhw0pib
	qH2Q56nsqkvvE2J8qPWdWRniYBNHvYI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qh4NiYPbRruC4mvjxUzpupWki3z36d7XvZrwd3TdvC4=;
	b=l2Q8kC2Wk6CvSb1dIq4WHUWuQkFezPibJKqNtcKQr4FUkNAnKykftoa4ucxe8dClEmn9AL
	0QmhyZo+gxQtLLg90NL1xdfOmSWEu4LsosPkDtX4qqeb2wxPvYFVd3pHA3XmnEas5vHUI9
	d9fNCrEuHpG+9FjxHdihh7T5nyQGlRk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BWQLB8jU;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Qh4NiYPbRruC4mvjxUzpupWki3z36d7XvZrwd3TdvC4=; b=BWQLB8jU6mcNh1heXB/lqQklx4
	s+07onfRthNaz50wY8ifyU7opExoLJIdyGoRUAqFDdoEJOib/cdAGDcy8AlDp9fmsS1xKFx3KK8Zb
	9ZynezgLH+gNqaO65ayOBcQo1XtJvc5puL2PS5V9fcZHYLXbHb3+9B7MZXQxRpk/WATuJjF4bT1IM
	bYY+8+bEfpMvDnybVPlTpMbsEDdZ7W7DCyh4OKby8yFpER+cVl/pOQxaNLbXBqD933nhNenr33aPk
	iXaPMpCWij3qkJgq9LxOj1uQ1+NkJSf8pOlXHiet0wb2THbBea1nty9g/jz4Suy7XWy+vTmaElIwz
	Kt0EGmYw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weXrA-0074bC-0V;
	Tue, 30 Jun 2026 12:46:29 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v10 0/6] mm/memory-failure: add panic option for
 unrecoverable pages
Date: Tue, 30 Jun 2026 05:46:03 -0700
Message-Id: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAIu6Q2oC/23SS2oDMQwG4KsMXkdFkp+TVe9RSvEzcRdJmEmHl
 pC7l0kX8eAuDfp+WUI3Meep5lnsh5uY8lLnej6J/UC4G0Q8+tMhQ01iPwhGNihZQo7x4+JPNYL
 KysrgJDobxW4QlymX+v0Ie3v/e89f4TPH6xqwVhzrfD1PP49uC611/+UuBAiWPY1Mlk3UrymH6
 k8v5+kg1uCFGyqppQwIY1aYsBhVrO+ofFJFm64SECjFELgQh6g6qlqqW6oAgROytcUVg9RR3VB
 WLdWA4KUuKmhUrGNHzZNq2sxq1g87icTB26RCR21LN7NaQAiZs7YuG0r9mlxD2bbUPTbsMRZPJ
 gTs6PikBseWjoCgJHurEDnbfsOEjWWzuQkEBJN8DM4nZJU2+H6//wKFSZUnywIAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9452; i=leitao@debian.org;
 h=from:subject:message-id; bh=rzlmeFMvKoMLceiaLrM0kWBbYhUIPGoUIe6rGm5ZwiQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqQ7qcJMsLrQMFVu0gEasMRTudO2rYviwaZ2bCj
 DAp2LspyJeJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCakO6nAAKCRA1o5Of/Hh3
 bdg2D/9vJwL8x5oEhRZMdlefW2IZJ6ulKZudvqfPju4Qy6uTsXeMJzGvqoK2NyLbohCn/5IEhzP
 ah0yHQVZCjhFX4qtdU8MQ9SbvCDUP3PMYYXb+zH1G2NdtGDF4F5q2gOmiTV3taQMF17y8hjMJqv
 hZ/2QC1wk3YFIo3OWhK0RbyIzpf8Kz8nuhBuAph6qJMqmakta85mmHLjmqttDde0MbSEoSxX0eF
 64VLj3lcUaZBa8OI7Qv+73Os0X0JuPgO9F5zv0/1xN3JCMjaXa5FHdFMdsnosVoSA7vmeDi0zZ5
 Mu1dkoPU+WVWI07SOt3IrcAmlGJ17ItESrsgaTEiPSfhP4v44kZ4yViiDPs9QReLbXwZXGL0xT0
 LRlq+s5py+UR/hne/rehx1o+lW43hITmKuE90OS7rd5G+Z0Pao6F/94xZHddgOPTP/OPmSZfGoT
 KuN9ebW4McP/lVSKp5n0tQTviVtMRUsv5jV6DHbZaI+OjIfu7SZKM1X2SRPK3Umkl4tLLIyp3Mc
 xiXpMw8Dl0wcUbwQw3pnhkdhGO3D0R8SDOOmWzYBIEBASrFw0ZLf9MfWQSv3ffamA6Cn4N+cb3W
 ENU42rWwbRP4v8DF0AcUm3fBEfc99LmCPIjg/2/f9+ynwuffVEtb8Kaw/3mTT+MRaWJSiKpSxM3
 OfdOCKNvSV9YOVA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC71220009
X-Rspam-User: 
X-Stat-Signature: 1cxjg7c1jo33bn9en54y8az9k9apxowp
X-HE-Tag: 1782823609-608973
X-HE-Meta: U2FsdGVkX191Jlxe8iazKBhiPxwreyflRQH6X/v9HKE+69g+iRE4uNOsme2gZcBm45JrLFoItQOurnA0i63+ROCvx4Mh/KY3Fn5gRisfO6I+V4cIkR3I+GJI/mtIBtO7Im+f7TPPmkuCOSDlBECidy6ZyTTWpggdo6RlOwcNvR1/NTOvTT3jmCeKZYkTHoGuhZJYbTDXV1S9hToMD2nZpa8xLrTVfpS9sqnu3GEZchamXR/SBGAkTuTxeNL3KfiF2DwlqFy12OjbrjMAdW48c80KhgDk40dnSYkNHBZu4o0BHZEoCb3uGgdv7E1t3leeRDv+A3ZJ+JZ9CBw7n/3I41g3laFcEJCXGpnASq4VhLxuQig8v3QMdHjRN5EDTc/4Ln0ku1QeuMXVCvcj99IT61fjvVK6qwA4fWNsBINqbsMrjGt/MHbMDKO/VneT5lSXi/dT94gODXpG57GPthHi/YX3tHbcMujpV7/im9VTMi9DgFczy5F/EeRgHDshTMVASgmj/AJLlGsP8f7ExhNn+O5asuK+ddfOEegSg+BJ728+ExOQ+E/52lyWFheIJKBXL7Q03hTsgHr1ENla+mLnIvz1ed/f1EnhCeEujZkfOu9k344U17YNDXumtY0Y3M9JUEKpAdCvOCMxM9dIOeFwPn/BpciaFGWwKT4umOKk0KUpoKbm/YzS2ZSNiH1Hc2iZct6+YWILFw0mpSex0L6o5O2aZJtHRQUOTspBeAilFWPRK7gvcpJEluNh8+1yCYqrEqdUWSmjFQW0qsNRAB4p6mAa7xWPEIomewiG6leWXw1SmtO1DqpTfCVZQ+Co4oXAbnplt0xFrdo7TDieqUVnuSgdTYbfi0O/uGo0HOR+ewhEsBXHKTiMjjNEIRtuiYr/0ynHyCmQJ5pz9Cm8jR4czK9Qj9SMLMFo9HoQ+s3H4/mL7RyGMtaYF/7xI40/sBLWxwLQg2IlP1OoQzgDAlF
 AWuHoQ3s
 CPc2gFdfLR55AlJ3izpYJ/R8/wVYK/frwt5jKVg5RnC67vuRhFAf+/AKwyhpY6LskfeY/1m2QgdGwmYZvMCysY+CxdZekmpciSTVkzOClEaVqKZ43T94W/WPoNYPbjHiXQsburpiqAZK/+3ljfWn3dFFW7YK6bdD2ih3sgStSV3DRgb0q7/ccq2jNHX9XX6sHLDYWyVieUwziKOJ1OqyPunj+gBvKeHnXfoHFeUyHDXNE4o7UXDcxhDlSg3VHnUflZ9z5PhU06gkt63hIUMPqXHjpIECnMhYnD6ml23B3hwCSVwZMmqEulxVAKQO6OlgfIa+sAuKP4VzSZJQVAsVgfNZ4IVovGZk7ZsHhTFLjvXoSnVVmkogVuucfgNpgVdkAQt7nBnwqqoM+s+IitwFRc7XiUdbx3WM9RTIsIY0i5hngC/5/SaWbHVWARmCbRZC7AK8KNneWSHhNMfEPL0cHXE/2OyHhVCnjvV/eSWsOXLhdxMjQL2T4ZmQBcj83a+ynilfYPq0tdeoCkKHn+GzcQ+XF4+vLsBtGx2QWygutwuz0kg7Ass8PKI+FFcs57dOGMLx69smLJFh4S2+sMw9Jk3ybN+ztNBoUXKrdSmTOcxWaBiQjnJCLzH1pc08uT+czDFscJUJBfMprBOCQhWXPkjhJEtBkP177Es7ckHsxtV1fOr9kSkMPBp0w3QId/nSxYf90rvzFa9jK94Gw1aV+StQpmbPXQahRcV6yTJrgksSz2fUrMq0orxIX+sCnGe+MdjxMk17eonTOfJRxMSVPyb+Wb/mlLvCx3xNRbZIiJaQIkrGEsemwKu/QEJCYBswg0v1nx8gkcTmINlOyVpybgaAnL0GfODdJSq2C9HZXKyiYdLKK61cqXZd56vFkWMYCmpZvxLTJjcBckpGYas/dvHGr1Bh0JeKMFwG/ZKQ27nCK2UELNzZnB+GaXH9//qAFcFFnIaY5MEVUcQdEBbtm07teReY1
 jHPmLbKl
 kDIlMn3BHRP9F+uaqANbxBROKWc9CWfbvOWd19ptK3M6h7n8OJ/DGw==
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
- Reuse kselftest declarations
- Residual race harmless documentation
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
 mm/memory-failure.c                          | 106 +++++++++--
 tools/testing/selftests/mm/Makefile          |   4 +
 tools/testing/selftests/mm/hwpoison-panic.sh | 255 +++++++++++++++++++++++++++
 4 files changed, 427 insertions(+), 18 deletions(-)
---
base-commit: 30ffa8de54e5cc80d93fd211ca134d1764a7011f
change-id: 20260323-ecc_panic-4e473b83087c

Best regards,
-- 
Breno Leitao <leitao@debian.org>


