Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB037CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4626B00CA; Wed, 13 May 2026 11:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4653E6B00C8; Wed, 13 May 2026 11:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CD66B00CC; Wed, 13 May 2026 11:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BABB6B00C8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:40:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFA43A0147
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:39:59 +0000 (UTC)
X-FDA: 84762807318.05.4A979AE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id E1787180006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:39:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BB7ChYnN;
	spf=pass (imf06.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZHMWqcUJvGieXh74sNoEmf+K/vMRbAU66tA5tncTCoI=;
	b=0A1kVHHIJ40h6VoenY+N2UqYJYRwJmd18oL6V8VTodhMTWJOUa+Ab3Sw13KGff8DjZtVb4
	5JGI6ohmLfxmVrgltFArQdZsDKX9BqpJRB+wAX4uA+nnd1RDP3e+oWOVTGKk7wtIMcCGF9
	dRqVGXHj6UuPIfDwfAHyWVQO5CN6PTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686798; a=rsa-sha256;
	cv=none;
	b=XFHDdIOGdHtrcbCGQHpPIqewQqLV/rQ6dlTwIZqqOAS5LxHenTRso2v4qW42rouHFDeClV
	mqn/pFvtzNBHWbF0Sj0Av9Kag1MwLiNFlxTYbHmhevhuXori+3bZi7rDIeEAz09/FePDJl
	MpVhBAcGdy7DX1UC3sfJm8utZEfWAHQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BB7ChYnN;
	spf=pass (imf06.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ZHMWqcUJvGieXh74sNoEmf+K/vMRbAU66tA5tncTCoI=; b=BB7ChYnNfVz4Y0o78c5eZvaY/o
	V+tf+IQz3nn12YbLXu2xaasSjduuXENB87/gymyUaKYfHtOkrpq4CADG0i6Idr7IOPCu2nda+c1iE
	BMv8X7hB/RMyHLqYW8yblubckKopLTLV53zzdxi+7bkyB6cqEL9n8rZZh6FascvhAVgid/LazKtim
	EXMIX+iNaFSkqJJ8JaTmhEb+aS2LZRSrMH3IyTwz2fK3zUYEIMMUtazgqJgsNL0+/dN11zmreEtqj
	phNlOjqYHeSlV+vSHwwTCNvZPxrydEb8Nb87OQbnF0r7et/4E6BdqgiwFD6P1XXtHou3XeHzysW2Z
	2bTlsyHQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNBgW-003GTi-2w;
	Wed, 13 May 2026 15:39:46 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v7 0/6] mm/memory-failure: add panic option for
 unrecoverable pages
Date: Wed, 13 May 2026 08:39:31 -0700
Message-Id: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADObBGoC/23Pz2rDMAwG8FcJPldDlmU7zWnvMUbx39Y7JCXpw
 kbJu5d0hzpkR4F+3yfdxZTGkibRNXcxprlMZehF19hDI8LF9ecEJYquEYRkUJGCFMLp6voSgBN
 b5VuFrQ3i0IjrmHL5eWZ9fP7N07f/SuG2BqwblzLdhvH3WTbLde+/3FkCgiUnjyQtmaDfY/LF9
 W/DeBZr8EwVVbKmBAjHxBgxG87W7ah6UZabVgUIMgbvKUvygXeUa6pryoBAEcna3GaDckd1RYl
 rqgHBKZ3Za2TSYUfNi2q5+dWsB7cKJXlnI/sNXZblAbQRg7PcAQAA
X-Change-ID: 20260323-ecc_panic-4e473b83087c
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=6267; i=leitao@debian.org;
 h=from:subject:message-id; bh=bbxp1Gsl0J70OpOgud3HV52mLKTRxVimVS/VK6IaNXs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqBJs6+Aj/VQHB/ziZBcEMP8ajQ/fSuRJCu4CP3
 7TC2W7J5Y+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCagSbOgAKCRA1o5Of/Hh3
 baopD/9k+b8ymfJoBaS1v7ItIZSwHeHYjah61HeZoCf674mQyx+QLSU6b0HFyU9MfGxz82804sq
 voMcSWl/GywgJjbnDZAK8Of7zSgy9Y41uNbxjEnxV7DVwPeBv/2EzQQAMmIqYlQ5rnDh2UY467v
 8QxfcT/36Zxos/wdARZw0QOkMBjuFwpgsRr4R/jLlK+0QcFUN8uBJRwBIiz4xcMVa7peJfrAF4P
 hEOhQa/rUrkgX3TlMV+f/uCivJYgZgK8JIn5Fl7/uY2T+vCTCuDMdg2kFOOeSfSOIG9XHYTvK4L
 I8dci+eRfSoPwoZtSHKt35Cc/vbREb31mUWQLT6xdEbJ92jUEJNk4yUSe0u2GNrynVhy6/qPIxb
 JBYyxGItHmeBiloxA4siFgOZumsi71VvZDGCgW3qx+kjYA4RVL1CxVJhabJlFzP+R4BYcKdbuh3
 eJgpgACKRv9BQ1exr+mQ7wqvqjwZqEyHZkWe8++/7pDe7DGjyJzfWGd/TL6iZoCRFOdmqtkZmKs
 oJyJE+Oh0cKhER9uA1dGqD5Dh0iODnEEjwlGAe4aXOC0Y12NlZSKcGv0PexgLJBwm7QY6m+1XPA
 ed/w4g/Xj58jZJGL3cPGihdXUmrlRd5Kltjh47qdK38FiGt7VFvs155XDtvimwKW/uupbq60Bml
 qPs5Ec5qhouAiCQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E1787180006
X-Rspam-User: 
X-Stat-Signature: xrppzo7sm6ueggidx1t88oyzzddrnjmt
X-HE-Tag: 1778686797-385723
X-HE-Meta: U2FsdGVkX1+9lku2PxM+XSD5duVGslKx3F5NqTxzGw7s4/gWkv0RCkkRdophx8YIBZErzTUSv/Z+fg14PsgT2K8gy0n4CBtnMsZhOXRmpD9rP2wT8KMImu2NFGk6ZpWeSrOoh0S0nIPaPjSUFVjnPleqp8MRH2Z6SzNfTDajgiKPza7HMpOJ/Q/09RQWD9LPYIBKI3XIKhroh0Yjg+YCMnO0D+xoFSunI07iA+PQYUSdV6/DcP8SXoABFjXd98XIe0i5CYGcT5Een+P2W2mrYtJ/ALaM9ddl3tKIRKbRjFmDK6N7nou3G+5AANle4+mXxqEDQ1gHfZJOPZmb2FkDhP1PLVf7QBRVkLmk0FFR2NUC+otjCNVXgLDrcjFDIXRyidVrKcWOOl2KE8TCy22W8FCT4n8AcDtFzTIl8orKmvw91WmA8uED0lgJQ6PKNocsOc8vwqfyZj2qgOQ1guIuLc5imYcPUIqqtuhcuyDpZxsQ5ZmPk2t5Z+3zC4mUJFjEMAmXgpP7OYUYERRX1pm7woxoX35SDoXUI1B+08YRgst81QmBE1PY2JLgfl1I1rrJmR9zRrmDUZsbxloj1dnUDcG64T8m3E0p0CwWuFNnh5QwjSIp6k8STI/rbS7YantnlX0wy8pATep5893fn8hFSadjhZq3hFZ36Lblt5en/Q772X2nblFB3tp7dgAtK2xz4zhang/WHZhKK/tugLNdUUnn0gK7PD+bRvTL2/iQcUGPrZs2OBKAxFddZntAbg0JVSfOLvLl4ckQz+wNI+6AUf9zhWSr+/v7bQBWzzJVMMFhsNPD7je2qX61Jbuju3C/ntiidqPeZrx5ggmrBqROnYQ3d+YI3jHVIjyYdsUeZn693SmZWiLSv8sSeohf2VUfxgIE9XMA45jlAUV6pQi2BpbJZdhJ8n0P2QtGe7srRfU1ZawUaP7wfZHoUAmQ4wop99v9Jq6q0IbBPu43yDX
 V09RXn6O
 nyuw28/INCjnp7GCAvyX8IxT/KCW03gvIi6mXlnT1Ix0noeO5Xvo+rQ7WOlWY1uelLhFReWLnogkIye+n/nUsCafUn0Pg3hV/+lkg21r11J9KMkPyqK19u7vwpDa1+uF2Ko/OjSTA+BzKURqKYkL1Ch+zZGwckh7RqcPl81mzrwPSQdoUiGwzNbkE2gIoLCp9NIbzn0Jbd+nd3K0ABi0cw5ucwMsex9XdbOgX8/rzFAS6Kfv7kNffzlBOf7efyYYpamC4fd7UbEpsAzoNLqvJEqQWGVuu7RMs/pwyFQzQ0PSHoVYGWnTevqeghxtQAOeaGDdY3qZztiEMFbydZbugpjQGGJr7VV8ZzU45/cO5qe9KFUsTJRkfbjpKtY2jmQDeXZI0SOBO6sYy5F5gIY+WJRZf7ac2gLDR/w2kk7bXlFhEFMlgFdqMgvF8ifmzhWQdCNA/32LoIuvio+16y7VX0qPZ5pfuiBcmYW+hoft0fIjnKX3/GD1XBYLTLU4h9CBJMs3MmAvmHPu48cwpcqMCmAGKuqRek4ObFpnemBL7v/UaAEww/R6ewlu+BapDwl3mN5WN5CiaIYExng5c4XpsnzzOYUeedob/kcJ2a4Nu9+Gy6LTym22YySIKEgMSFQnhoBMmSGYLpKD8hGDdKTs9IbmLgd6kJxkEjNfKwLdkJFlasaob2HtysTMFiHYujmQ/N2b+4DCxTWO2hAJhnEif3ZfRTsSRv2CgRFXEghjEhcsiHpVHn/oZkosrozqKtgtrnuYYzEklSvynIxSaEzp1N6tXh4MpdQAK75q6xaTsj0Tz9r7T7U2V0TouMnuv99mA3cBNqdS7odh9aaw2kCk2/7C58mo5/cfCaitIzjPBQ2dDTU+j+u1dAlOzAoF+k3a8plCs3f8CrvRvVk5a0hGepCN//KCFYpNfI3G5PQxFxTNv1sGsZmEgcL3Qm/R1fb/hM7buvHR/zJZL9w0gBMw7xhlZ0g==
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

Signed-off-by: Breno Leitao <leitao@debian.org>
---
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
      mm/memory-failure: short-circuit PG_reserved before get_hwpoison_page()
      mm/memory-failure: add panic option for unrecoverable pages
      Documentation: document panic_on_unrecoverable_memory_failure sysctl

 Documentation/admin-guide/sysctl/vm.rst | 80 +++++++++++++++++++++++++++++++
 mm/memory-failure.c                     | 85 +++++++++++++++++++++++++--------
 2 files changed, 146 insertions(+), 19 deletions(-)
---
base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
change-id: 20260323-ecc_panic-4e473b83087c

Best regards,
--  
Breno Leitao <leitao@debian.org>


