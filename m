Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C6BF34C52
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ACBB6B0089; Mon, 13 Apr 2026 09:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85DFF6B008A; Mon, 13 Apr 2026 09:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74DA76B0092; Mon, 13 Apr 2026 09:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60BA66B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:27:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 325861B6EA8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:27:04 +0000 (UTC)
X-FDA: 84653608368.21.DCC565F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51B4210000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:27:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hIA2wNhd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776086822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F+mjPhtdtTxQus0gs48zKH9AMTVSWSCrzylz5KeYQkk=;
	b=OExAWv8UoG0YqHZJH5hS7+W9P9EE7sPKcZsZqm0LhZHPzWLAoWign/6jz4swxCjYVkGsDi
	dEvTodAtVpDd/9DqlY1jUN2SvmvMtBrCx83cd7ZdY71lJ45r3IgJ3YVZ4FYAqfLLNMZb6m
	SA7lqhLZ3WTRQPzKUUXFZNVYcMNcb+U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hIA2wNhd;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776086822; a=rsa-sha256;
	cv=none;
	b=Hxa6+hjaRHTGZrGrX53Uwc+CCTLpXVilSRHnBP432N3Anj2uaLezhqpvSwIVRH1sAx9Keq
	aV8d8y6TQqMNeGHOMPQILs+G4AeKz3q5Uip5g5sfRRkMEOXZblbUrR3S2CYr3oZ+cnfo57
	at1SnzDtpH0ZfmZKG25KSpr8pRLSOw0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=F+mjPhtdtTxQus0gs48zKH9AMTVSWSCrzylz5KeYQkk=; b=hIA2wNhd/+4wulxxeljIA7XYwG
	+2uscT5CxkxKURVdzDvHl2mUF0t8cQU8CpleXfHwJX+J9YysgHXgIHtBvbX4/89YKuFAMBt/w1dmw
	SA9xGl7W4Z4Ye+iP/DXFTrpBDr2usBZKhDfPyj7UXT4DF+tGV4MjKLAFiIo345N8rd2zXExbPX56K
	L39axnG7g43ZTBZk6fJfFXQ5A8hwtLgrWfDc8Q3+qbm7gOVlXbm1knObNPI1VTGFxNAGMaCvAq+oQ
	evjbCuw0r58INU+nVkiOdirG9U7F+VslqpTiI/zsvaI06fwL3JE8pGgTQJdR5U1X8DMoVjMqSOk2i
	GkJBojdA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wCHJL-00CKDm-0P;
	Mon, 13 Apr 2026 13:26:44 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 0/3] mm/memory-failure: add panic option for
 unrecoverable pages
Date: Mon, 13 Apr 2026 06:26:32 -0700
Message-Id: <20260413-ecc_panic-v3-0-1dcbb2f12bc4@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAnv3GkC/22NywqDMBQFfyXctSl51air/kcpJcarposoiQ0t4
 r+X2I2FLg/MzFkhYnAYoSErBEwuuslDQ2RBwI7GD0hdBw0BwUTJpJAUrb3PxjtLFSot20qySls
 oCMwBe/faW9fbd8dn+0C75EAmRheXKbz3s8Qz96+bOGVUC8NrwbUo7fnSYeuMP01hgBxO4qBKf
 lQFZbRGxTrWl6rX5kfdtu0DdB254fAAAAA=
X-Change-ID: 20260323-ecc_panic-4e473b83087c
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3765; i=leitao@debian.org;
 h=from:subject:message-id; bh=6FMMIHFEEVygVWHKafUVcd/YxF9s04Zrb7o6EqrA+v0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp3O8Ob6dg1xqMSIH3qXJLaklmJDoaeBTtzRt2X
 SQWpO9pwg2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadzvDgAKCRA1o5Of/Hh3
 bSwTD/40PWCYKr3Daelwzpdbb8aF4Ipyr6hkcRy+2mCZwHKIcvV4KtYgwMmJA/AbJOKMDlv0iCZ
 durRLr++0jUx7UsEnsr3nmGzUYVBS+rT013fje/Q1Lq/CTHo8W4P5pLFesnyP220yqVjurCJN9b
 LAlgz5zlQip2ZpaVHUlJrG2Fj1XChT5H0d6CICtO3lMQgb8D7kTmIwa6I/gsy78UiDbUGopKfie
 Nwhksid9GwVXdk7PqQ349Nt8b7qLOMj3/aOA8WTzqlxAC+90iQKJT+0q3LrmJ9Os8CtyOn8ijSs
 wEBneOW3jtkm2IdaYfs3mkHShhbcmuRi+ND7sq8AG2wpwlmytus6reXRNTLE/JbNjUZMIqSx+ox
 HXS60Ni3lcQJr3JRfTr49sMXhLymTEjegz/vgxy0/JC02NOFWCkQb3hnZ+uxQhSSE4OTzADWOmP
 mDPuR1hv0C2pfOGTDwXUVFAKi6fjfcO7q83Lznb3t0+Q0+FFnYWVj97hef2dOOwxcr2ncU2OsG4
 vrmS+i6I+aslbpj2dqXIn9G8G3WjUJBV3uyFVSdHpur4hk7+swtwTOpFh97Y4TM0qHlD9SVv1nU
 MGEkkt4YJ9OuAuBxoVDkmoj5dPpIjJ+Z/dh3qJxvzMklVxOt4hAq1v71AMSteRA2yVc6n7adQHM
 pdBe/56+JcztoeQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 51B4210000F
X-Stat-Signature: xjxyuc4ch8nrsd59dfxbmpmgj8arxr3w
X-Rspamd-Server: rspam06
X-HE-Tag: 1776086822-240742
X-HE-Meta: U2FsdGVkX18DCYuHhAQu5i7sM672N9Od8sIEIf4fnEDMuwZFqqo/P84HuY3gGKj06lVhas3B6a9BiGWDTemm0Q/53hHi8qjqWXBD3Dx/h+S0vyEDfH1j1sYcM7+jz1Yg/pec6NDK8J/pPg+LtDfzVULZHsf582QxjCTUxcc9WN2kQoGRu0QhAFuRqt9y63eSu8ChHencc5CaHMANwc1uuiI7t5GBrSyWmr3zyDxagbSdeLMdwCQqvhg5WYCeoZcQ1abGp3Y7oMz1GBznoMkHSWaUGSEQIMVQoaZiGXi5YNcj+mQKxZaIzsn/OZRueETMNFujPy1Kk2sEVc0HkhtKagyLXc34KJ+u9x61+Q7UtAGxQlUR/dmOq2SvAZ/5qZyNpQkBprdlh9QcnO+ZwLURQWhABSSw+k0DRT1aB8tXFjuCgy3nSyuPuUXdiZxZdY2XxRJFZB77kalClkycaJh6+aEeGWZ829JHEkWr1QHs4E2CoTb83Fnp7jEIiFeML2+2x1vsmtOKnsVKkcR8gLAuBP10D/j1lcPL2SYl5i4Ai0qUZY+Pjj6S0rbFUTVd9WTVNQVG6DxQqI/vgZ6NNrvG3QDFdakIzYDFbi2cjk8eMGvDpRp4B8bNjsdLwir++ABsZ3YCrqoAY+jY5CtRK4ThuyICBSKKldmVlyPzmmdU7xrfu65o5YioA0EMyY8ZaRSe8qezSII8UhsFbusSAw12k7WDYRraWyVsJzCoeQkTsP10PUZp0xpzlv6Ky/V7CbK51WRwR2Rgz0Kqr0px2XDgN1RvozeWYfBaz8skOD0YtxkilW9wx59eqh6yG56C8OcGR4MAOwfYOQ0t/EwZK0TKN3k/6pXX82baSHe1zsAZoUdfushsHVWE2EMtWSmiQ/N2tCvAlwVL6Z9ijnRrsCMNNh0WrDq07xNx9Oz/HJcjKE0Iar3VzgH5FZvMBRRvhZpse5kOGRO9a19NJVaeNzw
 y+GJyjpf
 nrho12o3ckolEzRPdybooantfEQtZSt5Tydz/gHzhY69aIWIkzOyCWAL7Y8Chq6+De3sruTpANv8uJkkpVSO9zjebdnD64l0JnwQyZTWOax5ROw3TWRS3PwL8CnZ1fvgizc/cMlv3gL5/HK7mBwYv5n8puuSzh3AOyHz4wE5Gsp/23wYwt/IUVBYxXSwIBcIyimFKw10u49FBP5AX+L4p1s8cNBobCt9MA39jsz2deapVFZQuwncCUKns2jp/ifmo3scPA6UFo1SYY79CFG55FmqtEnJQ2RFzZvBUycMl5c3GbXcNMFKxAaUW9kR+oJTtk8sX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the memory failure handler encounters an in-use kernel page that it
cannot recover (slab, page tables, kernel stacks, vmalloc, etc.), it
currently logs the error as "Ignored" and continues operation.

This leaves corrupted data accessible to the kernel, which will inevitably
cause either silent data corruption or a delayed crash when the poisoned memory
is next accessed.

This is a common problem on large fleets. We frequently observe multi-bit ECC
errors hitting kernel slab pages, where memory_failure() fails to recover them
and the system crashes later at an unrelated code path, making root cause
analysis unnecessarily difficult.

Here is one specific example from production on an arm64 server: a multi-bit
ECC error hit a dentry cache slab page, memory_failure() failed to recover it
(slab pages are not supported by the hwpoison recovery mechanism), and 67
seconds later d_lookup() accessed the poisoned cache line causing a synchronous
external abort:

    [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
    [88690.498473] Memory failure: 0x40272d: unhandlable page.
    [88690.498619] Memory failure: 0x40272d: recovery action for
                   get hwpoison page: Ignored
    ...
    [88757.847126] Internal error: synchronous external abort:
                   0000000096000410 [#1] SMP
    [88758.061075] pc : d_lookup+0x5c/0x220

This series adds a new sysctl vm.panic_on_unrecoverable_memory_failure
(default 0) that, when enabled, panics immediately on unrecoverable
memory failures. This provides a clean crash dump at the time of the
error, which is far more useful for diagnosis than a random crash later
at an unrelated code path.

This also categorizes reserved pages as MF_MSG_KERNEL, and panics on
unknown page types (MF_MSG_UNKNOWN), so all unrecoverable failure cases
are covered.

A CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC kernel configuration option is
also provided, similar to CONFIG_BOOTPARAM_HARDLOCKUP_PANIC, allowing
the sysctl to be enabled at build time for systems that always want to
panic on unrecoverable memory failures without requiring runtime
configuration.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
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

---
Breno Leitao (3):
      mm/memory-failure: report MF_MSG_KERNEL for reserved pages
      mm/memory-failure: add CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC option
      Documentation: document panic_on_unrecoverable_memory_failure sysctl

 Documentation/admin-guide/sysctl/vm.rst | 46 ++++++++++++++++++++++++++++++
 mm/Kconfig                              |  9 ++++++
 mm/memory-failure.c                     | 50 ++++++++++++++++++++++++++++++++-
 3 files changed, 104 insertions(+), 1 deletion(-)
---
base-commit: 028ef9c96e96197026887c0f092424679298aae8
change-id: 20260323-ecc_panic-4e473b83087c

Best regards,
--  
Breno Leitao <leitao@debian.org>


