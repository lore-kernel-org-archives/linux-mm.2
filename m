Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35533C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F236B00A0; Mon, 27 Jul 2026 12:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24FE76B00A1; Mon, 27 Jul 2026 12:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118706B00A2; Mon, 27 Jul 2026 12:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D33166B00A0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:48:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5159D8012D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:23 +0000 (UTC)
X-FDA: 85035139686.12.B00D541
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 987AF1C0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FO4F3Zw2;
	spf=pass (imf20.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170901;
	b=4uRE/A0zHRQemW73yL7IUcVf8Pn/qzfwDKb8ypvQmfLFM6vTqIzx1AFwut/yiOY3l2mkI+
	EGpoTOcv8xpGass4gfDh4WiH7QPPJ+wOINJBL/AgzTjf+VJ5wtoSD3TWWUKsxDvdlcwMlS
	M0pMq7FcwuP4vusDeK43islLBUOmXEM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FO4F3Zw2;
	spf=pass (imf20.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mWCBtkVx8btQG/x1SgEzIKusEEUXTec3q7725bCEWM=;
	b=jPpYIYCWoBCaN6cE4cgZ3UMvmmiXmfA+u4ft9E0ueZPnPBQ8LRaLsdmnN+iALVvWMs+IGK
	Cbg9yiyFgzjPRPE2XsNnxXwTktb7DiteXfSwtaru/B6N5PLunV3o0GV3NHQB1H1sCE3tZ2
	k2IrpRdBYzQGFSEaVU02pxfpF3R4gzo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A84A01758;
	Mon, 27 Jul 2026 09:48:16 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 124133F86F;
	Mon, 27 Jul 2026 09:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170900; bh=qIwnegDzdMrafDzJdJv9H+LswsYD+bpRBZRtWzKb88Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FO4F3Zw2hXfsGwPhUj1oZO4YZVZFDjBN2uvHs+TxtIa/K4rUEej4TySn/fu7EGLY4
	 vMvQADIrGp/sqI/eek2J5cHHZ8KXrC89o72EJBMI04r1d0coHNWS1Z85TZkghA7MLv
	 xBWvePNCX4gOsv+djUzCeqIiU6OEAmaaKyQdaBtA=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	ziy@nvidia.com,
	pfalcato@suse.de,
	agordeev@linux.ibm.com,
	ryan.roberts@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-parisc@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH RFC 05/11] mm: convert PTE table entries in ptep_get()
Date: Mon, 27 Jul 2026 17:46:56 +0100
Message-ID: <20260727164715.2866609-6-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 987AF1C0009
X-Stat-Signature: hggf1xziw9m7pcqcycngwsjm5xi1okb5
X-Rspam-User: 
X-HE-Tag: 1785170901-199853
X-HE-Meta: U2FsdGVkX1/A1CEPnEXgzbUIX1Ls6l/xTRlL4inmqDr0OBrYkYSgA+b6C1b0BGkr8EC7S6xTgUsTO/8AuD15CZ/dyWKe0RhAiN6f2Dj6G+SQVihSirtzsRz0AfZfUnyIKsmeB5UOh3uGbpP/UP1AYanbeOpD9lCOtzsxwClVo4VYHtGq3YNeKnLSxLlFqe1r/tKuf/Gr8m9hu7RW3yAPTr/etVfEbA15PItpfB3Ij+vvERuWgN01iwjBTFCau/0Hbo7JRglewt3r8LVGS/0KGy3RWPL8LTTuvSrUYSDpGmbvmREk0ObvxZX6pDINcEh6NR98vZXxUVkMbR4RElMFlz7pfEd+rhwSbtobb6zTa9/Sl5Yc5Rl7wlHvKXYrO3G0Zb0t2iGppqYhWSoIeCZmbVYOw7qsJZvxeh9rRrG11Czg7ooRz6y5VSZF/JXNC6hft3Qv3F6ntrxZR6Udm92ELfFxJzoPv64qp01U8WauLMJH9a5bUPWE/+lEhRsZAhdzpz/tkTz+JnNqaBU/bIaSR04cuixjwsDFqZAFSAKh0VWLQ5XctjZIqS0mlNhnmkUJ5yBm0e7pjf3XTsg1nZd4xmZXn885KUAAxrys9Z7z6YIO5WdkedgVJFfUoSg6uUuTF00DoguB9czf3kkAP4SQcHZVFDQPn73gI7pCq/NEHufSaEhYrM4t59U8Z8C8sPGV6iud7mZaMb6/qw6BnBR5v2M/oPxHWr539uY4IDk0rG0E8vJ8v6QhR+MzbB2Ln0F5qWKaZvf8BqQ5XMN7oN/m7F7JW/QSXd/fR8aajE00kzhqbH+/CWT5p95PG5zYvPCvsD3danLduxfgZCM3MQNJITGPUwagbVOPaYLxdrv2SEy2D6oeqhHFpeNCO8irwYXbIZ4xNv2kP+JolYiNykV9EbB3qbDsDVOxYeHHEHMW/cC4rkQEu/e/WlPI0i+PuGeUWh68F6Bm8267TyxT/7W
 /z10iTx9
 +cFcL9Fe+0u9Ouq2tW6U9nKf1sQLJ/vEut1goQL/i/w2Tcl5A5G0ONaR5w51sNnW4kqqu+RvbcaAz7POambDBYEakn/A/3e/YKCLB9qxYMcK9LYWzjZ3N6Jp5gHbzqizcbLOJumxm+VU4wo4oGN4ePvpd1//0Uq+I6Pr/TyaKhxOfqV7IVlcsh5S3GnyVZMvIMLnz8nxDNe4gQKd6BfX27DVWxCXLqN1GmNs7m/hWHiPs+hs2mvqCTRBKU4swFPXJnOgPidrq4A2TMMw0kkzSWsDhd+Gc7/bdGpM5nI5ywOVLGNRsQ/gey/3N+JF8NQ0p2SGBaGW25PUdi+gs46WD4P4dIp8ay9V7MbWJOhrqvaOy008=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
return a logical pte_t value. Add __pte_from_hw() as the conversion hook
and apply it in the generic ptep_get() implementation.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 include/linux/pgtable.h       | 2 +-
 include/linux/pgtable_types.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index dad80d264aac2..3003ac9cd81fe 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #ifndef ptep_get
 static inline pte_t ptep_get(hw_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return READ_ONCE(__pte_from_hw(*ptep));
 }
 #endif
 
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
index ed5dba42a4f8c..61afe27307ec2 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -6,6 +6,7 @@
 
 #ifndef __HAVE_ARCH_HW_PTE_T
 #define hw_pte_t pte_t
+#define __pte_from_hw(pte)	(pte)
 #endif
 
 #endif /* _LINUX_PGTABLE_TYPES_H */
-- 
2.47.3


