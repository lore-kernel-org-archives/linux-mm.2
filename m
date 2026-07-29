Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 300C2C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90306B0178; Wed, 29 Jul 2026 10:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A416E6B017A; Wed, 29 Jul 2026 10:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E0B6B017B; Wed, 29 Jul 2026 10:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD556B0178
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:57:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A9E61206DA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:14 +0000 (UTC)
X-FDA: 85042117188.18.DBAA29F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 625BB100002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cf9x6aKI;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6LH/9ecwG0QZVB1+/Q90YQFyR/8a3d86KWwBNZduCQ=;
	b=GIAIk5aH8Rg1sqdClCtOWVEuuzKYSaPQcuh7AmIXKFKMa3GYMD/fPNXv11n4sINfpdFRWh
	/z75cJYcMGABhSBSjW5RfnapLwiPzUythsqikeoCzeBLhHNm+Dn2XsWBvWk4LarGh2j4Wl
	Azd6j1C6gL8f+QjFopjUol+eD2jwEqk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cf9x6aKI;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337032;
	b=ucQbMGg6Sjl7gQqOEr2BXEF9l7szJoe8FaER0QuYe1oCQ+5yOOasbqNyvqdMomGSB+Gcer
	aI3AfwXG0ZnnaITVDuetRhJgATIBslizaztCc9nulL+dLD7Y/zxmRSG2nMzjcDFLdrMelh
	niY53v7CIYgeqKFPoH0rmyDoYiJ8XR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE898436C9;
	Wed, 29 Jul 2026 14:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691941F00A3A;
	Wed, 29 Jul 2026 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337031;
	bh=q6LH/9ecwG0QZVB1+/Q90YQFyR/8a3d86KWwBNZduCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cf9x6aKILYb0+cw9MvgfAPR4eTx8J1YEUSEbB5IC57Vqco5iXOQWnbTPfH5GlANDT
	 Uil/Us/GBd1g+LL3XbKWeaARmP2BjQvLQr6gmt36EMRmhm2pq61t4O9y1R8tnizkmU
	 ct0zOuizvdy0TH8ulOIYsvOSkojBi4HPOd6n6Phkse1Wt4CU0XoB/k2tvknBTYPPYf
	 W8M0c0kuqgVTx7in2/VrkwdvPNJMdhO6k5qnDUzbYRHB5w1wAcKbUPR5GNMxmD8M9G
	 iCZVCSqWcF7Vbx6c0lFWJmqoygnD8O171erW4Jbbj4/KBPeJ+TqDAkFMYkFrTd8DhO
	 4gnuina7wvXLw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 19/22] memblock: always include KHO headers
Date: Wed, 29 Jul 2026 16:56:04 +0200
Message-ID: <20260729145610.2827231-20-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 625BB100002
X-Rspamd-Server: rspam01
X-Stat-Signature: fz9u4jipt9s8y5qe9sbt3fi965dw9r4j
X-HE-Tag: 1785337032-821049
X-HE-Meta: U2FsdGVkX1/ZcIxd0CP17IfsnNlYZCQKeh9YIZ6lziYG2cRBM7wS506zwrQ3/4bAvMc/O81xuAdMNILASI0EOMJX9ilCi+aysE9rdKODkQwlhsKN26ltr4w5z51C0Dsf7ULj1S8AEVqEj+jQhgFTSUiZ8nJsM7hQOew1xeZyVYbaCU0nd+Ae6Toq7ELjwoSt7yjK68hzi+IVJjXVeTaRB4uEsyspTA83mcsbu8/VjATWoOXe/mkdt+ma/TFqL7utFTg087d3UFZ+KbrXXsdhqBk1vWJ/dF9T721EAX3iGJBwhUjhOtkdAYnN8UoPOFeleF1WcaBdynQq91ptCU44JWybtGqA8DFG/p/euk3GoyQoJj0d73PrjoVWyWJIyK9DKNDQ2Z1T+GASLeZIU6iFu8cytbMzhkcDymwVABzTOq872w68QSiqi2JvSSVcyio3QT6yUXqHB8IwrN7SF2dN48lM8T06fawYMc92H+biJxd3YYWE4O9drpe9ZinfYHpOGeg5EYRvGeRE31g7znlK+OPdKpbni9ONyVAN8ZAbH8GKdPznW2uw23cMJT6v8PcFPeZngT7mPtI/HzkEEhjdkhh4gJ/mGcjIA0pfQWbW5p0ptlAHtv11LI7PcRAwapeJqWIdMW3O5eyHCE7CDMKSCMZ5+i0+heKivyy2yjkBGLR/WGnz+dogdmkHng+3nr7+OlrRJf8BbqOQXqVTftyVFsBEDYrVyW/MNwHxSC2Mq9xOy6O9AfkLOa99BYukSrtt3IfC3bVWpSpiSJ4iGwwOHkwChMACJeLFjP+/TXLySNPk+JyD3jHFSZBpUceninC4NVD+yCMi7l0jwJGGmw/YYOnjLiQdJxbXoupnOPWOggMsAHOMquNYdT2U/LsJiyOClC+9ocxIUW8opOdz6BbmuyMLdDzauVsn459SOmiFgmbwYYNuEYBtnLwuTS5vWes0ublwSfNXLlNx0EJW2X4
 TSG8Bqrx
 amaqfdGrzEpv1dgUejnigkv4lPdzW153N4sw/QdVRlAIEL/oaWzdBzzuClpe3GcTRx3GRm1arI1ije9uY6/NBDczDYjgCTA1kVPEZ3PEI3ezG+H8EG7a+sAUmi2/usOvSIBCxuEuuNzy1qhPyJShKxXwiWS+UJflqqLK56E8Q4auH3eUwfs0y/ASUKNYSsphsldPpadc8AuH6n/Jz612qG1NZRCwj5abaaR+xD7h9/SqBgnCFgPkyV1U7oj5m/8noX0WoXGigafRMxvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

In a coming commit, memblock will start using kho_scratch_overlap()
without a compile guard. The compile guard for the function is in
kexec_handover.h and provides a stub when CONFIG_KEXEC_HANDOVER is
disabled.

Since in memblock the call will exist unconditionally, always include
the KHO headers.

Including these headers unconditionally breaks memblock test
compilation. Add stubs to fix that.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/memblock.c                                   |  2 --
 tools/testing/memblock/linux/kexec_handover.h   |  9 +++++++++
 tools/testing/memblock/linux/kho/abi/memblock.h | 10 ++++++++++
 tools/testing/memblock/linux/libfdt.h           |  9 +++++++++
 4 files changed, 28 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/memblock/linux/kexec_handover.h
 create mode 100644 tools/testing/memblock/linux/kho/abi/memblock.h
 create mode 100644 tools/testing/memblock/linux/libfdt.h

diff --git a/mm/memblock.c b/mm/memblock.c
index 8b2e551435ae..ea735bcd4dd1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -19,11 +19,9 @@
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 
-#ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/memblock.h>
-#endif /* CONFIG_KEXEC_HANDOVER */
 
 #include <asm/sections.h>
 #include <linux/io.h>
diff --git a/tools/testing/memblock/linux/kexec_handover.h b/tools/testing/memblock/linux/kexec_handover.h
new file mode 100644
index 000000000000..bdfd9445b1fd
--- /dev/null
+++ b/tools/testing/memblock/linux/kexec_handover.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef LINUX_KEXEC_HANDOVER_H
+#define LINUX_KEXEC_HANDOVER_H
+
+/*
+ * Header stub to avoid test build breakage; we don't need to actually implement
+ * any KHO functions as they are not used in the tests.
+ */
+#endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/tools/testing/memblock/linux/kho/abi/memblock.h b/tools/testing/memblock/linux/kho/abi/memblock.h
new file mode 100644
index 000000000000..71cf6982a2b9
--- /dev/null
+++ b/tools/testing/memblock/linux/kho/abi/memblock.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_KHO_ABI_MEMBLOCK_H
+#define _LINUX_KHO_ABI_MEMBLOCK_H
+
+/*
+ * Header stub to avoid test build breakage; we don't need to actually define
+ * any ABI as they are not used in the tests.
+ */
+#endif /* _LINUX_KHO_ABI_MEMBLOCK_H */
diff --git a/tools/testing/memblock/linux/libfdt.h b/tools/testing/memblock/linux/libfdt.h
new file mode 100644
index 000000000000..6137b788fe8d
--- /dev/null
+++ b/tools/testing/memblock/linux/libfdt.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _INCLUDE_LIBFDT_H_
+#define _INCLUDE_LIBFDT_H_
+
+/*
+ * Header stub to avoid test build breakage; we don't need to actually implement
+ * any FDT functions as they are not used in the tests.
+ */
+#endif /* _INCLUDE_LIBFDT_H_ */
-- 
2.55.0.508.g3f0d502094-goog


