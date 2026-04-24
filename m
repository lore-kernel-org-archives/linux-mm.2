Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CEA0FE5215
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 966E16B008A; Fri, 24 Apr 2026 08:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93EDA6B008C; Fri, 24 Apr 2026 08:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805D56B0092; Fri, 24 Apr 2026 08:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62F3E6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:24:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5396540191
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:36 +0000 (UTC)
X-FDA: 84693367752.21.B344309
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 526F21C000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XFtZL76D;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf21.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777033474; a=rsa-sha256;
	cv=none;
	b=lhLthvXbI9C23+1HicKfsfo4SLugHy9WsDZB/6nt/jLe2CdwgU8wiZ3vW7WiHuhfAZ56II
	JCbVC855TA8NquBwLz/80Web0oqc/tji3r1ti7SjlpoTBzu9hLNrnArH5B+TwKUcvaMe5j
	DH/soeHihM9vHBHUYvFw6BDi2NGNDm4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XFtZL76D;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf21.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777033474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kCY/q4tclfbP72dbiGmSdv+d95QO4i6rrytMRJvTj44=;
	b=zw1MO8b972tj/sE92RJFw/WlWRXXi8/EhBeBcMOwyflOtuG9mRFNuSdBEJ5n3fkn/9psv0
	s7R1PaeuyPXW/QOmx+s2DunR539RkevA8w5e+hhBVJ9NTV6UPIxLERK3sbp9999FwKgmiv
	6RWhBzaPiqbdmx8LjMAkrJwwhzpwYjw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=kCY/q4tclfbP72dbiGmSdv+d95QO4i6rrytMRJvTj44=; b=XFtZL76DHZa40jxuxLT3sHlWll
	E6EDi2xkfoaXXqnJxddpH0DD667wMv/FVue01VLUpC+GZ8mc1ODLyfNIIdxImazldaY+nDE+Vgjg2
	dDa6ekBYXL4N+0jo09ycUUE6jA6PYsy79Qj3jQISA1RoqoGYcFxXSUxU1BoKYs+ppLefUGvPQHdQQ
	9M4eQ71dKGTz9zEAQIrB5latKroPFFzIIBvdlC2IswDedy80T9qHgMmqtcd9vVGznk1vCRDQbfpWV
	88bxsCrs6JtzgS6N1Hif2YE1+/sWe+9fiNT4DfKyUmyotnJRHFOTdyW0V8ygrs1XELIVw/P4R0/bC
	3o0RpGGw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGFZz-003APX-0o;
	Fri, 24 Apr 2026 12:24:20 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v5 0/4] mm/memory-failure: add panic option for
 unrecoverable pages
Date: Fri, 24 Apr 2026 05:23:58 -0700
Message-Id: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN5g62kC/23NTW7CMBCG4atEs2aq8diJQ1bco0KVf8bgLhJk0
 4gK5e5V6KJBdDnS97xzhyolS4WhuUOROdc8jTA07a6BcHbjSTBHGBpg4o40a5QQPi5uzAGNGKt
 9r6m3AXYNXIqkfHu03o+/d/3ynxKua2BdnHO9TuX78WxW6+6/7qyQ0LJTe1aWu9Aeovjsxrepn
 GANz7yhWm0pI+FeDEVKnUnWvVD9R416+qqRUMXgPSfFPpgXara03VKDhByJrU196kg90WVZfgA
 EjypFZgEAAA==
X-Change-ID: 20260323-ecc_panic-4e473b83087c
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=5234; i=leitao@debian.org;
 h=from:subject:message-id; bh=1Yg49IhGr2YwCvs+IFVozhTPo6GCwWNF7i0sbY0fmz8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp62DtrHhNXOYVDOSXYRniu6HKfays8eZsIassL
 HqjFi7tWjiJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaetg7QAKCRA1o5Of/Hh3
 befJD/9awnGz38LRRnqkMpb8hdarn0kczxmQGG/QdI4fey4T1kHKP7fOwjmSY7tpf4ztvIcexGt
 Y8l9rip6qMK93gKcJhLxezHZe/yzwfRs1Tpq7+ODzy+nUuskr521fRGgtfG0WFBil4DGqEXuvvm
 9otADYxTcEq2yYFoilrFrkrmcM1rrEO4ryPaNI3QRAGwzKn67Elce/an/xgmumCZXDSgKAexT5C
 UkKXiI7XlLYToIhyCRMPz5ONgmjfgJHFS6lmcneTv+XIB1So8g6esolhnY8e+Yhv/ehuF+nRn0B
 TtU1evU/d8D9Tno7eLcdLbSFPQwuAqjdvoCyYpKUSpfyKBJjIq8nAjoWxPBWHvHdXSQAOvFaHXo
 lcs7Xu3Qbw/ct6Px9cwUzM+zd9vlJcb+TZr7wHZ07MX/IqB3CtifeQOR15WN+75Qoewoxv2CbJz
 5/RH+DqMdIjPYXyCZfnEl9np6j8zz2wL7+zz8nuLQdtMRLKtax4Kl6ggCS7er/+rwSFUcnqm4gf
 gp58yI15rY6NLAGBtTyAvBS8nUzCekRnldaqnL+UUfH0UCqpNXWXgHnW1CK+x2t9KKztB2ZEhGd
 /J8yjsBFulCj2GFCBWf8TuANKejT84rr0WGMDtuksRLTdvOl7qNfdgOIfCWZHShm072OR2FCZvm
 Py708WIpi6uYUDw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 526F21C000D
X-Rspamd-Server: rspam12
X-Stat-Signature: a8jsdfyb1guqgwny39otb33bodhfh9qs
X-Rspam-User: 
X-HE-Tag: 1777033474-844365
X-HE-Meta: U2FsdGVkX1/og1K37R0DOAO2EY/QUKmORQY952r3eqqP+23OamhsDug1Z0z6L/dylvJI7SLQfGlOSS1g20JFgEQ8ZEWJIYUTA1QDXCBGvaF36VDR300cCMFjTCv5rtuUi1J7GYtgm73j6m5vptcYjOun7K82YmXeXNIn+q0B3r7539R+z9xAEBlYRVTjk0hgyu+CVGkgK7xmm/vr23xZ1A93sw9M6hwjw1OQ6P7fynijGSKZq5Grvn5NxmmO10fOsNLSIuOtDOiUG8dM68huSCmzOID73v2O7ePqLibScf36rYcH6S1+q4xGFjR3fNGb7V5FfeIp8GeO98GjCjMl/Kum60dx3mOnCYSi+2GW9Dqtgytpkv9X3y0+hnbgbR9zYFK+UAVum7nknsmoX35uxeEcUab6SQ6K2SghhiQgJMMfgELdKJsj67UkcPpHYSvkeyheVXPalW1/0nhWoxfAxIlW6ojSYK20iTW0ZVjNOP51hpAecGJjuwKIPfHezoH7Xt6W5lrBdhkBRRXNGIXG+G7Cu53MaGWZAYHGDvQ3TFde5eOVVlZHWk7SXtCyC1VyI4ETCDCHAC7jP9RSF23J27oHk7r9NbEmXenh6DrRxwynx5qfJcSS0JmbGhrfA9SOU0Lg8lYB2h+hloY7wfCS80DKSqUzTjWTVdFjA54x1oz5FMfldekyxYLBQ4GaRSkGRdNa/7+bby1rNnbEZouoezRfiLiTjWsJOm5qT9L2xDJMCxiNUb8PfMcXx6hB6INrU0mtS7iKrSH0jOJ2+TEamFgSexfpFx6NFW9scl3I7Aicl3yDV3Lkw9BMhVoJF+bTVgBRH/jv3AnLVrVx+hWsJbq/EIGu4yAHS/+TF+yR2X/31266TbFDE8A7otdYl9yKecSU36AaCYO0337ClEou6hvlXu0Rrlm5L1tFZJWKBWFDGIW+wkIx6aeNGWQ9ykERtKBF7kDZuI35ulDnlDp
 YZpNDDkS
 GRPRfZxpn385w/y8s2iHuav6ZdO/iDd1Wv61J6NBfGMF5fENvfba7DYxxMPtRz0yKz+RJgj+fznpWj1uIXr6IXzDFWqOYAPKdbeL+VsUIQepP2m7ru/Ftt6LkiuwPj+2PNn9elXdqGIUUA1i0AbSCMZT4v5QmwQxdT0RfzVmHVriBQN83BmmvKKTrcvJHD+JE1/cp1cV3h4TTQo0rFIkV5nK39oB2nnsIoS156+yEj+MQ9OkrMC7wG7FEVgewGKTT+Iy0VB9+BYJ079nSoP2C9koJNGBUIG2LPbPc+MBYbv4dnt5/GhSMBM00GQoKVTFF4wAincKE/O1lHIW/OaK7e7AwW5DU0JNfNixh420dleQ4/dQRp4rYhE5l41Agyh3aMgSN
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
seconds later d_lookup() accessed the poisoned cache line causing
a synchronous external abort:

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
unknown page types (MF_MSG_UNKNOWN).

Note that dynamically allocated kernel memory (SLAB/SLUB, vmalloc,
kernel stacks, page tables) shares the MF_MSG_GET_HWPOISON return path
with transient refcount races, so it is intentionally excluded from the
panic conditions to avoid false positives.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
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

---
Breno Leitao (4):
      mm/memory-failure: report MF_MSG_KERNEL for reserved pages
      mm/memory-failure: add panic option for unrecoverable pages
      Documentation: document panic_on_unrecoverable_memory_failure sysctl
      selftests/mm: regression test for panic_on_unrecoverable_memory_failure

 Documentation/admin-guide/sysctl/vm.rst     |  65 ++++++++++++++++++
 mm/memory-failure.c                         | 102 +++++++++++++++++++++++++++-
 tools/testing/selftests/mm/memory-failure.c |  84 +++++++++++++++++++++++
 3 files changed, 250 insertions(+), 1 deletion(-)
---
base-commit: 4c406406070d57dbefeaad149181785330c23f92
change-id: 20260323-ecc_panic-4e473b83087c

Best regards,
--  
Breno Leitao <leitao@debian.org>


