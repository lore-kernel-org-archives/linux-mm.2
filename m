Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A17C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB466B009F; Tue, 15 Sep 2026 08:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C6F6B00A0; Tue, 15 Sep 2026 08:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4D96B00A1; Tue, 15 Sep 2026 08:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C211F6B009F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:54:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4EE95C021A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:54:43 +0000 (UTC)
X-FDA: 85215990846.05.F8F2F16
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 941B2120006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:54:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Qcf3QIz5;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476881;
	b=eQjt3HcGZf9Rq/aED0lcpNvCRxmBbQgCG5QUt59bTw4w3n0neulgwURwQanZzHHPX17dRq
	BIPO2U/eTGP0+YDUFlE548RgamXepU5jBZetXD7FgS/OzaTrQOJuGs05QzcbiYiBbtZTj1
	Bhgk/21N7KAZZvvzYyHJEHKfgGgem2g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Qcf3QIz5;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06TheYrO+RqVpiOeLZzO2sVZrEIqfAB0lq+jheypzUY=;
	b=ekZKoNJrvqC0uTnGcmhKT103z9wm3rsjGoby1ZOOlT6A9PMtkFU39oGmawW/0Nr9RDnyjN
	qRzgWowheIJDSSzm6AQJNOjja3t2R6/LuvOp1x1Zj3eMkF2mewQbroXsEQps5f6BHwYEmc
	Z9TK0LYkW9tf1GjauIfy+4DX8SJ2sCc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=06TheYrO+RqVpiOeLZzO2sVZrEIqfAB0lq+jheypzUY=; b=Qcf3QIz55CcoaSldbU3zzTlL9y
	IesoBAEM54qeIhRkKwKFUEMm4nfEKwbtnDTM2Kwd/9YFqHwXxGoIriQlWqoQ7M5qGa7U48T1BTx8M
	DG1/EIn4i/N3wGOau9uP2DnOL3mq9IE36OTH+ACyOXN/gBOSOmzbXk9ZVPvdlo96o0jM8zTSCTRAZ
	w/lj1lQEIxmzspaxPkyvhiAs5vTFOfO4ATfnvHd+Ral4CQZ+gLnhbwATUF1OJc1jr457gY66mVZr9
	AqOKMoDcCVXOb6Tff4axnEA1/l9sQiiL4HEI2zrLGLxVnHMLBEzeJRxf24fQ868QdNF9UqbHy4YMW
	ghNx9N7Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6SgG-004P7U-0N;
	Tue, 15 Sep 2026 12:54:36 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:39 -0700
Subject: [PATCH v5 5/9] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-5-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=3575; i=leitao@debian.org;
 h=from:subject:message-id; bh=OD6lOfDsuQ3Gx0O3nG+lnSFgQ/uCyiBdpWhEzT0xs4w=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/e9fGRdv2ojIBIylpv+WGyoKgen1RPvA/py
 wfutQvXLwSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bcZOD/9tYa5c1xoSwHHUjr+PBSVX2GYqBV2gH0IMO8Np0WO5iyG9Uz1fsyag/5SdmAC3g8xbHCi
 SU49YEZF/BxnxWXcegM8Hq2aRQQ/PsZzDmwpiOVkh1Yd0+m23cgfkxAHTeObj79QrvrpupuB0ZN
 ZfenMCr6f9nmRuuyXJgGAdN3SqmKKkHp/0pLf9jhrJVQppAmkL21OL/dcIL7MUn4ViSzT5ay1rg
 9bKerw/vl7i3oNZKiblmKUgY1iOw28hN1BLbiZ5OJAiotlCciX210WGqifZUCnD8F4v9XbMcL88
 GkxIZrs8wOD30AS0yt1/Hp6DziMWkY2qmOjX+0oLGASCVf77CT1Ki6jFrVtp6AwYJhTqVaTTviz
 VObWrgN1tVtc491/NDobzNW8fcbhu6gPkS6kU9dTdpXBMGlSjBGkdkhrmyZuarbh9+yY4cgwe+6
 lGdYm1vtptAfuVdrjaBkWTSEO0HaYCWL6UfQ1TBPZbU3oPBsjerrrMSO8RiB0OVDgkaTbgFHvMY
 1XsGOXMKOJm1ZBfnZ5E06uWG8cxlbQMS47XSWNyLn95gNQKRh2W9OwNwfvFxN/B5oyjgx0tmbmx
 aeFo0YF6GMWpENLcwZT/pidl1kpqjp6Tc/kh6QxZA3JoXkPIZMg0nTE2piBle5FZW0X0wk4m2kJ
 hAkVzZhu0+0Hnxg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 941B2120006
X-Stat-Signature: c69tzgy4ma9bjdciaxohpsgxmomjpysf
X-HE-Tag: 1789476881-670562
X-HE-Meta: U2FsdGVkX18kLrovI+jv5Af5uN/ApQ7Shhw0OF0Ki2n9NxudRhb9w3pcq1nhkDUzL0X65QdlA66XsZmmdpfBe1gh/oYjQe0UTKP6X0uPAQFvrKzrBQrulweke68vERaIqNxAODKseDkS4rZx2q69oQoQM4WiWAP2drth2cKnAdt9LOEXw8xXyC+5E7sLLo3i9ViMfUsZLvwnJo2XP3cUfmwHcH/dzbq6Ck8jcxta82bcJt1kOrMdI3EEQVuX2VcVw1FmwQ16tKiV/fI8DIlSPVejpyhAo0ZB09im3JfuCsNDHx1ok+BggdYyM60jBMUI/hSrH9oHp3w9Vv5Y8arYZli4uz3ndS1/FbLV9qUT926VwaVq0ZywgQD2TqAE+E4eSDSzfPqrVqijuIRkbtir022XbxbRsbFXUHCU7Wd2Pv+T6biqu/vAjRWRZxlfAupPYCtEN99MfWkIXK3QDC1LBda+51k3HQf1dhweeaK7bMjUWGTJTkGw+J9LvPpbYNjdp4tSfAQj+NOeTyARh1dnLImmNGZp2+opPxWJSSsXqXfFpkuPt7tmsp4f3JW8fnsXut86lORHbsbHdMHLcrs954faaf/VwZpU8DWQ9tNVq+Ww/73FGzbGazADDBibJwqClosHfVO99BNCrNKQko6eWp7XIhws7f8py8DNp7SdXP2rWaDRt+NU+vuls6GcmwiDZMfA+orZ3OA6SJSlHhv+UdovlFpHq7Fxh0H3DM1evMNZ6ETrfXFVDpuHyvVAqUJP7S9y26olE0uwaMaCWjIvqqr86tF/BPe3lv2jb7UhyE4ga84/49bx+dDqfvPY48yVdS7DCIZU8Gcqr1BKyWIRgQdESX0ydcuiK5zlrglh/2PrR9oc9JOwe7gBaWxObJ4PjWYlDqfhPki7yRIvytFMqrx63y78HSlIEJOv6crcgipiDR8aQSdS7yltqdHTl+wIa8/xqJ6FfNJnYUXZVml
 KP0ZRM+O
 Bk7SlWSYxlmNhofk12BAgiRs8ToWIk1f+dD+qmbUnGje6CVgrMgRxTYgHgqsn55UdUrHcH+zlawrsM91kfhx4apbR0ato2W3aGqqvOf8nIaxfeiV3laRtbGjbuHhXvjcNRhSX+RRyY6PSECgd1GGZ1+5lRETyLc8+bOIxc6eZPCTq7fiApwo44gfIYFLDTcYZxF8LjQmkmLo05LPfL7kvanZGwvmG5eJR6FIJxK+zyk8rosF0TqKHQaMUDoUSZ+NUQqNFGa7VnrVqJ+3t3rrdUOhpSOO0aPR7fQNpFxvxsiQMgQTsgvrUgPw4LUTOSnqPVNvSqQjZIebBf7U2y4xiBuwDl3EUgS9Vd/bxsPek1V9gdgTZ5OVSQBg0hjx8MTuvBDnQddjZGLY1Sbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

action_result() is where memory_failure() reports the outcome of a hard
offline, so hook it to set the frame's bit in the
LINUX_EFI_POISONED_MEMORY bitmap.

Soft-offlined pages reach num_poisoned_pages_inc() through
page_handle_poison() and are deliberately left out: they are still
functional and were offlined predictively, so recording them would turn
a prediction into a permanent loss for every kernel further down the
kexec chain.

A bit is only ever set, never cleared, given that multiple pages can set
the same bit, and it is not trivial to decide if the bit should be unset
when a page is unrecorded.

Unpoisoning a frame therefore does not hand its unit back to the next
kernel. That is a known limitation.

memory_failure() has already taken the frame out of this kernel's
allocator, so only the cross-kexec record happens here.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 27 +++++++++++++++++++++++++++
 include/linux/efi.h           |  2 ++
 mm/memory-failure.c           |  3 +++
 3 files changed, 32 insertions(+)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index 3f12db3dc9b844..847592862f01d3 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -91,3 +91,30 @@ void __init efi_poisoned_memory_reserve(void)
 	memblock_add(start, end - start);
 	memblock_reserve(start, end - start);
 }
+
+/* The table, vetted at parse time, or NULL if this boot has none. */
+static struct linux_efi_poisoned_memory *efi_poisoned_memory(void)
+{
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return NULL;
+
+	return phys_to_virt(efi.poisoned_memory);
+}
+
+/*
+ * A bit is never cleared: it stands for a whole EFI_POISON_UNIT_SIZE, so an
+ * unpoison cannot tell whether the unit as a whole is good again.
+ */
+void efi_hwpoison_record_pfn(unsigned long pfn)
+{
+	struct linux_efi_poisoned_memory *pm = efi_poisoned_memory();
+	phys_addr_t addr = PFN_PHYS(pfn);
+	u64 unit;
+
+	if (!pm || addr < pm->phys_base)
+		return;
+
+	unit = (addr - pm->phys_base) / pm->unit_size;
+	if (unit < pm->size * BITS_PER_BYTE)
+		set_bit(unit, pm->bitmap);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index dd3263456dd4a3..56402fdccd1149 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1288,8 +1288,10 @@ struct linux_efi_poisoned_memory {
 
 #ifdef CONFIG_EFI_POISONED_MEMORY
 void __init efi_poisoned_memory_reserve(void);
+void efi_hwpoison_record_pfn(unsigned long pfn);
 #else
 static inline void efi_poisoned_memory_reserve(void) { }
+static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
 #endif
 
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a2ca8df501caee..d9b8be696aac38 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -43,6 +43,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
 #include <linux/dax.h>
+#include <linux/efi.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/export.h>
@@ -1326,6 +1327,8 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
+		/* Only hard offlines are carried over to the next kernel. */
+		efi_hwpoison_record_pfn(pfn);
 	}
 
 	pr_err("%#lx: recovery action for %s: %s\n",

-- 
2.53.0-Meta


