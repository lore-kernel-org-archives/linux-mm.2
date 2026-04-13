Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6462AF34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2766B0095; Mon, 13 Apr 2026 09:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C558F6B0096; Mon, 13 Apr 2026 09:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6BFC6B0098; Mon, 13 Apr 2026 09:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 96BF96B0095
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:27:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B3F1C08E9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:27:11 +0000 (UTC)
X-FDA: 84653608662.09.7196400
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A9C712000D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:27:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QBzc305O
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776086829; a=rsa-sha256;
	cv=none;
	b=yIyT9WNiTAgDU/g3yvAdJKSVM9C7L/F4qWVamIFvOOZiO0R6EHPJPBk2Rb6Afhg1vezrpJ
	yO2KIyIWOzy63w7mxtvUOgyStFs7bFyVPzaV54nyPiZ5oX3shb0NrVBRZKeh5x62TuztIp
	saaMHs+TlIgWo0Ug79arcj2XvBuy/+Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QBzc305O;
	dmarc=none;
	spf=none (imf29.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776086829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbtwqqP04/XwB92jTwUHTtIQvE/SEZDBq3VRc3N6Y6I=;
	b=XwqskHUdCT4PqsFIfHkUh2KjNRQHzNAbYDZLyodFR02USTJRkM4e0HclsJNaR3MiPGOOQ6
	fnpH2p4te2EuIFXBpVrQV+VRWZv2HToGFLS8UbNm3PnA5Qs8+kzWh81Ecu/Y79Oz/z5wHv
	t4A0tYmEh12LFo/qrwo1JTbhrGMsiR8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=nbtwqqP04/XwB92jTwUHTtIQvE/SEZDBq3VRc3N6Y6I=; b=QBzc305OGUU3CKBmxPvJpBa4Oi
	I+/4n5il8SogHtoZ9MYMe5yABscVp4Uwgzh7udwzt87tchgUBR60wrkk3013QEZGquOerBE/DLD6y
	I+rFCji1nIzcCUrJJ++zbGDBJANL6pQRdpdDLuinvsc9TNjaujyOLdviEwyNIbBayln7o509HIBre
	Wic1Em1XHS3+OKmfW9u9rOJ1B2ipR/UxyfAneocY+8yVQKj51+KYTOvC4M2+068/5Nc0unBm+gz+2
	6yfunAVklS9x8MwaYjqT5W9Tu0FsVhUTnxel7+gKsAbEs3NZc9MtgWZazik+Kr8QK9RHHvsfede3r
	voQFxuVA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wCHJa-00CKEj-03;
	Mon, 13 Apr 2026 13:26:58 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Apr 2026 06:26:35 -0700
Subject: [PATCH v3 3/3] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-ecc_panic-v3-3-1dcbb2f12bc4@debian.org>
References: <20260413-ecc_panic-v3-0-1dcbb2f12bc4@debian.org>
In-Reply-To: <20260413-ecc_panic-v3-0-1dcbb2f12bc4@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3210; i=leitao@debian.org;
 h=from:subject:message-id; bh=Mp1Qv6rhhs0jzy9DwGJSWL5EM4TqsDFHcgB+US1rhmY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp3O8OOxyyLmnEVBgYOxqnlJRNzEM32jMwRHuJl
 lp++LJaOeOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadzvDgAKCRA1o5Of/Hh3
 bbCzD/9leaOJbS39F2fvv+N0M66/TmFRtRCcOvuRaKUAiQBKdSD1YSoEQj/XTjfciF6P5hnM7xz
 z+aS5nQ1qmxSLt/HRHr7rxoCfaSg0I+P0ltripbJMdGICH4kW1rvmfUcGQT8wRwz/4lipjlOFec
 jFublJBDLwhJmN9e2X3x4uXgJu4D4w8QWlXAW/ScqPcOYARBsjIsbWn44+1JoehOLSovAcWL/Pp
 LT+uIQxpkclyud2f+JDVRHE+vZDjl+PIgNWUBQBLCHWUmTCmxgh8jkkpMgVblybwg6t2113OfPw
 fHUQy5kQesNq2FKEU7QUESbLK0nXapRElS1AFOJvPhm7hkXbtTsa+k+39jLu4/zxFv8ToGhG6i/
 PQWe2A/8s9edOQR1dEQ6MVbsrzZE1gduOsoMmFv2REu4gqWiEyFdDynidGUS6evfEBTgOV72gSd
 nfFItHI9Iha6SBepQQB0W2IGVk587944kax9CtNXIWL5JOyt88lDUXkZy7h/L0R8rP2jlRPWjWm
 bpiDU2XojNGjjJeOJiQHh20p54N+ghvu63JKOZeeNlw6/dKxYqUFTPznWPwtm4NGxsO8+V10KmE
 3WopOzwuVW+t8nmq3ORD19ijF9bZwM8FQsKnklTlw19aTltDK+/URDsNvwZFEfveAYI0aJArQeU
 m2XO1b/mwZvaQ6A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 5A9C712000D
X-Stat-Signature: s74k6zj5jjc81rujgjxmnm6t95f41oen
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776086829-299053
X-HE-Meta: U2FsdGVkX1+lfBmroe1ORi20rydj8zBiTrj9lkubEmKAz1OZd+G8v967dHpBm9fiNATIYbKj2+mFVgoATJ+4GduK0ErV/r+Z+oA/sSTt43Typdzw4jI2Je0/IGMzDG0uliU6EZBSZ+Q3CJ4dm821UpPhorfXc6pYrcRhwc1hInQZYLmqLhNRwvKHovxCBDSORS9EtlnJEMTGZaRR8DyQonF8LYaThbqZ5BR4B10wm0JzB4kM7kZ1d6kWK+ujA1DhhLhh8xo7f6lQRS/rAoeXyrrhIVMoeVMayP6MUSMiAg3NC4AH0HU+l7g52rFabJYLTq689aQ9Vjo+efhI08Cb/A0dsjtCIrqGc1/lely4XyhbqDQNAcIU40+f6LZwfMKalEJ0N1A6bOm+PGlKqQYbInmaqtlgvmLu6M++xdUGJ02fF0UZrXCWhWuwrTazhOk/04n6gsbDfd8ogom8bsl4a1OfOHRPEPP9HRlvFu+6AYkL4Yaag5UOKLhZlIgFlSyaBkzxpoRlVQSMmpnVsYQZ6E0DqhFVHum2A+VLFsHvJQPA3NwzuMig13aMAgXv8la1DL60to1zep0a+QzISO17veS7KgB1hJmM1YzyTYznmuI81awLA3RFrgBS+QelE7YdOwzsSAxowjizczWcC3S1Z9IkSPHGVeVDFmyN0RF83YuoEmU8g/SxhFd7tZHnF86auyfk0fGJOYHpbQDP0dVNirjf/D8M6BUKQ3yvPKPkTLf0s6K2QZ2IgeqRBQPFXuXhv4TtzvJkhbSFVCEQ4ppFStc0+AIIo0ol+ZSAj/kgGdqrHEAnUDKKqM8+AkiruwX3diLdkAezCjt4LK4PDYgTLek2buhMTm48zt7T8/+C37ZbbdPrTXd81Tv0U0R0AvUqbwl+kUujVfefIu/VOi9HmBWUDgFUo2joJiYRzCoE6DZ2YfcBZkG91nNKVhbq/OYne08ipGZec5tD1+8YbLy
 DKClLdGN
 7TSGvDFpi1g451AfhWeYgJTSJ9dnRRLit97mKwYPwsC5OqZikpmFtgbLylpvIC5mG2dUopovZbPANB7b811LvADCa7swq0DrEtW7G0D2/YtE+fBmhLEjXSk6yrTcDevthlt05YnsQhCUvcVGruQas4WJ4DAmlHcC5sHCGHDBz0aR5y0WaN8fzsJdqCd3ji/MW7q4XRPB1qfWBDKIDGA4heUTi+ATIa4puZbxlWR0E5BdMaLy4XlTv43gt9cR+8Mprlusw/seWev9sQy/zMOJ+N1L9Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the vm.panic_on_unrecoverable_memory_failure sysctl in the
admin guide, including the CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC kernel
configuration option that allows enabling this behavior at build time.

This follows the same format as panic_on_unrecovered_nmi and other
panic-on-error documentation, providing clear examples of:
 - Enabling panic at build time via CONFIG option
 - Disabling at runtime via sysctl
 - Enabling at runtime via sysctl

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c9..af545869bc1b4 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/vm:
 - page-cluster
 - page_lock_unfairness
 - panic_on_oom
+- panic_on_unrecoverable_memory_failure
 - percpu_pagelist_high_fraction
 - stat_interval
 - stat_refresh
@@ -925,6 +926,51 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
 why oom happens. You can get snapshot.
 
 
+panic_on_unrecoverable_memory_failure
+======================================
+
+When a hardware memory error (e.g. multi-bit ECC) hits an in-use kernel
+page that cannot be recovered by the memory failure handler, the default
+behaviour is to ignore the error and continue operation.  This is
+dangerous because the corrupted data remains accessible to the kernel,
+risking silent data corruption or a delayed crash when the poisoned
+memory is next accessed.
+
+Pages that reach this path include slab objects (dentry cache, inode
+cache, etc.), page tables, kernel stacks, and other kernel allocations
+that lack the reverse mapping needed to isolate all references.
+
+For many environments it is preferable to panic immediately with a clean
+crash dump that captures the original error context, rather than to
+continue and face a random crash later whose cause is difficult to
+diagnose.
+
+= =====================================================================
+0 Try to continue operation (default).
+1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
+  machine will be rebooted.
+= =====================================================================
+
+This sysctl can be set to 1 at boot time by enabling the
+``CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC`` kernel configuration option.
+This provides systems with the ability to enforce panic-on-error behavior
+from the kernel build, without requiring runtime sysctl configuration.
+
+Examples:
+
+1. Enable panic on unrecoverable memory failure at kernel build time::
+
+     CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC=y
+
+2. Disable at runtime even when compiled in::
+
+     echo 0 > /proc/sys/vm/panic_on_unrecoverable_memory_failure
+
+3. Enable at runtime when not enabled at build time::
+
+     echo 1 > /proc/sys/vm/panic_on_unrecoverable_memory_failure
+
+
 percpu_pagelist_high_fraction
 =============================
 

-- 
2.52.0


