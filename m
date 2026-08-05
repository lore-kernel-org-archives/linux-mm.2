Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BA3CC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2BB6B00A0; Wed,  5 Aug 2026 05:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77AE06B00A1; Wed,  5 Aug 2026 05:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8346B00A2; Wed,  5 Aug 2026 05:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A35B6B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:49:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B36E240419
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:49:01 +0000 (UTC)
X-FDA: 85066742082.05.B80A4D4
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id C656F180008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:48:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=bdUXnjOx;
	dmarc=pass (policy=none) header.from=yandex-team.ru;
	spf=pass (imf24.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785923340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEgYGOPyUdkWmhmw/xLhA86o+THVk2n1bh92QDcf71k=;
	b=MbVlufYdikjzAOEtYZhBH2FI08AWJwiEmKoohTnXTwliSinlVBZg0lIgQs+DNOl8PHpWdt
	np8LYZ55UtNvw/AEVKiZBTnhHMIS+lmL4mbrvObb61xwE0RYKa396VtkxoOyfjELpe28Rr
	LyzPUVxFG1rqbEd4F7vefZohWcq+xLo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=bdUXnjOx;
	dmarc=pass (policy=none) header.from=yandex-team.ru;
	spf=pass (imf24.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785923340;
	b=Im4/fgWrV8FRb2g9HPNnmYHqzL7TYZm0ti/ERkVtaJS3HWP9YBLxaLSRvRZQkpsKso8K/r
	5Tfl2hYvZtFi6WaFJkI/7uvi3bO5xU3VxUJKjqXziCv9FDsZns22Q6y8+Oj7Ir2O6w0Amf
	6hLjzamnCySMlV7ufQnSOwIQojwDnR8=
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:43a8:0:640:574d:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 8713A808EE;
	Wed, 05 Aug 2026 12:48:58 +0300 (MSK)
Received: from i101646577.yandex-team.ru (unknown [2a02:6bf:8080:43c::1:39])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp) with ESMTPSA id lmErQB23hCg0-GTyl9azN;
	Wed, 05 Aug 2026 12:48:57 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785923337;
	bh=OEgYGOPyUdkWmhmw/xLhA86o+THVk2n1bh92QDcf71k=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=bdUXnjOxIJbJYiNdTjGbNTzkBxiVQ3SdcnT1P5qghHticrfxnq1e/xKGktvs/H4xA
	 S+zvLyi/kSOot3/D/cPt8SM6z6/zUKiBxFU6T8y6y+S8nkrLLo29v9Dl1tt5b5kK80
	 nwPiHJBSIQi5MuYFDRVX+vXLa5poj+IolBlcaHhY=
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Hao Li <hao.li@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Daniil Tatianin <d-tatianin@yandex-team.ru>
Subject: [RFC PATCH 2/3] mm/slub: count kvmalloc() allocations forced to vmalloc()
Date: Wed,  5 Aug 2026 12:48:42 +0300
Message-ID: <20260805094843.292134-3-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260805094843.292134-1-d-tatianin@yandex-team.ru>
References: <20260805094843.292134-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C656F180008
X-Stat-Signature: mp14dc578st6wspie6px83b7xfqxtsqz
X-Rspam-User: 
X-HE-Tag: 1785923339-852379
X-HE-Meta: U2FsdGVkX18XpnAUO4vgKrH9dkIQmzd1Y2dBKzFg+WyrB2Azdq/K4p7v+jiteRpZeTAKF1ImnA3EA2/hMkKQs/WTCtR+Uij20aSwOcDNPcubTa9rHfi8iyO418l22Ly0u28CBYlya66h5ft5/so3++rfGtFLNfn35Q1N0XgrD8cmKsy7Ub1rzzubcv8O5HLxV6nkTUQMv8XzpopwB2a4S9uVP7HreRdw/Di8N5xyKBEeOHnITCuQqd7HRzPADjbNuSEhb76lTRl5C+dOCJTQ4nWr6lZV+OLrGc4DtW2h9biRIeazhBqyzysO0SY1pOcHiUc/4Pr+3WEi63hUGFVfgbs/NGXGuZcmU2WJ30NKeUrVO/QAO532RlGa33I4wuxrJVxFOpUgmammARWgxZ1TOeVC4SW+HTCb+zNf2y6vHwA++x3pf7x80daXn3dbZM+Z/O13tVffnvI4gCjU/1n3J7nkoqd7O7+GzWKilXeGLz0a7boKUtVRxYyEeIPaoDsXQkuGFyKIithBgS+66586Jx2ESiI8KKXCXrbRwqLEAOx6oAayzCjLtmei0mgfP3/RMbY9lcy6uEM50TwswLK9SzMF8E4JL4b5QnHI8x3j5b97Bgyx3DvhI82ceCoS4mReAY7LM/BhX04Ig6B5AxhkmURHZ15l1Tu4GTTheacqrnkWZuuzdk4KNFYbt/63+BtQnY/mK92cxfdrYTNctlm1CgK0U52bCH5g1w9ls57DEFWclxyuGnpSq3Hc9wGGchHVHIJKqEFrmYJoxTgLw9T0eVtBzVg+xueSG97XspgNtobRre7MV+wU6lY8SCwucvmPvTmL++gpjucLswcfjTw4oDCgL4wE5GyW76wSNTI1byq5NyeUSOdLmSgJq0Dr2i7EHpuPtq0M2exeIVlFPPX+aLbkSaEb5wJcgzt//yHV/qC04lFdJqI2wOaQqwy+z2dIJ/TCUye5COxsE/tLZUq
 /Bq6oSL+
 2StGfYHee4FX1dVGB6ZED4d9b7hT/CjefBFNvD/UQc2Z3UTZGD60mYvDUxeeVJapUqAByBpCmxCdm4+sKIU3dCSdh14q04gefrgiDNJVY4P6y/+OY1E3/qRHh5pYG+FeqZUH+EOPc7UulgEKL2qFEwr3O6Z7fZbZmY2CN8JWTqouolyXhX2hC7LsWudWp4C+nUSgzD80uXJrdrGVA7dEyB0cU7fPb8z1DAqZlEqALalx6FUiKQnIbChCGtgx/0QyHbXCRyTjHxoSwmo/kz8Q3W0NjknV33SLPQEWtflcVLu/TuyJNNV1PixSaO0s3BBGFlbmnSenPH9JHpoo3qcBeIcMynmZ62YAfGLP5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm.kvmalloc_max_contig_order changes allocation behavior silently.  There
is no way to tell whether a given value is doing anything at all, or how
much of the workload it affects, short of tracing kvmalloc() by hand,
which makes it hard to pick a value and hard to notice when a workload
starts running into it.

Add a kvmalloc_forced_vmalloc counter to /proc/vmstat, incremented for
every allocation that skipped kmalloc() because of the limit.  Requests
above KMALLOC_MAX_SIZE are skipped by the limit like any other, since the
attempt would fail regardless, but they are not counted, as they would
have reached vmalloc() either way.  What is left is the number of
allocations the limit actually diverted, which is what is needed to tell
whether it is set sensibly.

Note that the counter stays at zero while the sysctl is left at its
default, since no allocation is denied in that case.  Determining what to
set the limit to in the first place still requires tracing kvmalloc()
directly, or setting the limit on a canary first and reading the counter
there.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 Documentation/admin-guide/sysctl/vm.rst |  5 +++++
 include/linux/vm_event_item.h           |  3 +++
 mm/Kconfig                              |  2 ++
 mm/slub.c                               | 15 ++++++++++++++-
 mm/vmstat.c                             |  3 +++
 5 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index bc669052c50b..4581fb68c974 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -394,6 +394,11 @@ the order of KMALLOC_MAX_CACHE_SIZE up to MAX_PAGE_ORDER.
 Requests above KMALLOC_MAX_SIZE end up in vmalloc() whatever this is set to,
 since kmalloc() cannot serve them at all.
 
+The kvmalloc_forced_vmalloc counter in /proc/vmstat counts the allocations
+that were routed to vmalloc() because of this limit.  Requests that
+kmalloc() could not have served anyway are not counted, so the counter only
+reflects allocations the limit itself diverted.
+
 
 legacy_va_layout
 ================
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..c060c06ca2d2 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -145,6 +145,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		DIRECT_MAP_LEVEL2_COLLAPSE,
 		DIRECT_MAP_LEVEL3_COLLAPSE,
 #endif
+#ifdef CONFIG_KVMALLOC_ORDER_LIMIT
+		KVMALLOC_FORCED_VMALLOC,
+#endif
 #ifdef CONFIG_PER_VMA_LOCK_STATS
 		VMA_LOCK_SUCCESS,
 		VMA_LOCK_ABORT,
diff --git a/mm/Kconfig b/mm/Kconfig
index 9b1fcabb6d8f..0ca7fc5321cf 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -262,6 +262,8 @@ config KVMALLOC_ORDER_LIMIT
 	  This enables the vm.kvmalloc_max_contig_order sysctl, which caps
 	  the allocation order kvmalloc() is willing to ask the page
 	  allocator for.  Larger requests are routed to vmalloc() directly.
+	  It also adds the kvmalloc_forced_vmalloc counter to /proc/vmstat,
+	  which tells how many allocations were routed this way.
 
 	  The default value of the sysctl preserves the existing behavior,
 	  so saying Y here only makes the tunable available.
diff --git a/mm/slub.c b/mm/slub.c
index 0a9910602cec..7287949ea247 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -51,6 +51,7 @@
 #include <linux/kprobes.h>
 #include <linux/debugfs.h>
 #include <linux/sysctl.h>
+#include <linux/vmstat.h>
 #include <trace/events/kmem.h>
 
 #include "internal.h"
@@ -6916,7 +6917,19 @@ static bool kvmalloc_order_denied(size_t size)
 	if (likely(sysctl_kvmalloc_max_contig_order >= MAX_PAGE_ORDER))
 		return false;
 
-	return get_order(size) > sysctl_kvmalloc_max_contig_order;
+	if (get_order(size) <= sysctl_kvmalloc_max_contig_order)
+		return false;
+
+	/*
+	 * kmalloc() cannot serve anything above KMALLOC_MAX_SIZE, so such a
+	 * request would have reached vmalloc() with or without the limit.
+	 * Skipping the doomed attempt is still worthwhile, but the limit did
+	 * not divert anything, so do not account it.
+	 */
+	if (size <= KMALLOC_MAX_SIZE)
+		count_vm_event(KVMALLOC_FORCED_VMALLOC);
+
+	return true;
 }
 
 static const struct ctl_table kvmalloc_sysctl_table[] = {
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..e7139c0947ce 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1459,6 +1459,9 @@ const char * const vmstat_text[] = {
 	[I(DIRECT_MAP_LEVEL2_COLLAPSE)]		= "direct_map_level2_collapses",
 	[I(DIRECT_MAP_LEVEL3_COLLAPSE)]		= "direct_map_level3_collapses",
 #endif
+#ifdef CONFIG_KVMALLOC_ORDER_LIMIT
+	[I(KVMALLOC_FORCED_VMALLOC)]		= "kvmalloc_forced_vmalloc",
+#endif
 #ifdef CONFIG_PER_VMA_LOCK_STATS
 	[I(VMA_LOCK_SUCCESS)]			= "vma_lock_success",
 	[I(VMA_LOCK_ABORT)]			= "vma_lock_abort",

