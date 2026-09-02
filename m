Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE182C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D9F6B009B; Wed,  2 Sep 2026 07:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9646C6B009D; Wed,  2 Sep 2026 07:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853686B009E; Wed,  2 Sep 2026 07:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60FCE6B009B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:57:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC7A380164
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:15 +0000 (UTC)
X-FDA: 85168671630.22.112ACCA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 17C3080004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QlfFMcIg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OB0MX0rk+wHc/9Dcyaw8LzIUZVw27SsC3vQgcDHBTRk=;
	b=MMIgTbmQAXXlbolMKEv9lfghuShyOasBH5b2sInRb89bk2xQRV30WOn+DbE/BJINyzvfsw
	G9wda2psUgZaYmQnoXeOeYo2Hhbo6/s2IMMlQWPT9KPgVLtirtKqOBz9cwt20rXMjHq6U5
	yV1p2zNSN3x/V/p9dugWUrwMYBO0YCM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QlfFMcIg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350234;
	b=K8moHmkt0+IBZr/Mfqpw7smHt52K36O2SaGn6j819iKTCvKl8zqjKRkJibI56KEWucJzxM
	xrUGvvK75rFHCr2cWuSjk9V7mfhCOhvDJ0QJQL5Ou222baR2uXJvocn5oALWcZ42sdWNvg
	gRzSf+Z/dSmqGiJDlxehnPkHrx3nDU4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F91A1684;
	Wed,  2 Sep 2026 04:57:09 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AFCC3F85F;
	Wed,  2 Sep 2026 04:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350233; bh=Wt0Z/oRBkZT86NkETNbvCPFl/jDrFm+0ICRcmx2Gpw4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QlfFMcIgpV3JYZhXIz3ZKax54n1D+5p68jpTNDA5ds52moiQkyj5mRrWZ8+El2QFC
	 ZYc598eW0tD/p3pw7LWjrSJnCEErawQmBKD5wWOQ8mCEinmi6VGrTVN6m+aN/4bVG4
	 iTzY66nzYxKk2Z4nlAfCZ32Tz9TAvUrC2JoDv03o=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:07 +0100
Subject: [PATCH RFC v3 05/21] MIPS: mm: define pud_leaf() only when PUD
 exists
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-5-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=950; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=r6k/TjEKlLvF6QYrAiLexU7+JoLa9iezYFCnVRD7jlk=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7k1BasbENs7scYH6YCwuMubOtsGe1c3+4m6
 SOomUSWrtuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO5AAKCRBt1cPRWsUx
 M3hGC/4t647eElOpB391p80tv3+7NgML6I6J4DGdbsBSvNkUpOdiEDJxWt6dXvZJprZIM65I9gL
 pzwDOktDu7P0q/H2ealDT27R5xiLJiMSYQJD6LtqjzaTOUCJqcBBsdwvvfz6exPz8jg/3s6owof
 z8kanGk2RTw/R2pBX7mz7baBXd/kXIAh+VtdG/yriBIJvw54oV1NawZ3QLH8cT0V++vjSvtx+6I
 U305Jn8DD42q1uSiiXgWq6uoWhAFuydp1y6fNV0XPcX+OG4n/bLcApPCVxGhNfqD+h1dlYA5xUC
 3o3jHz8nXtffVSV1y2NX3+3BoAGkTj4JNftFb2oWfopLzLA8/jyqMEbV4QfTRMUcaPy94LAC9cb
 Je+vi6FqOCznR7ehsyiVNSUNOjyc2vcdlWDc8a3Efj7eElfAPuFNaiYMc7XIK+Qbpa8CgPR7Wqs
 gDblJRw0/WUPCu6jYlUuWd5gIEIzWHCbXriyTy4PEaG9XfbRg8ExE6mc4ZXlJ2wNcj26A=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: ryg9qc1frmfww4j6pyu5d3r6g68ahi1w
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 17C3080004
X-Rspam-User: 
X-HE-Tag: 1788350233-473723
X-HE-Meta: U2FsdGVkX18Ll8dz1tnSn3Ovzqanwm0/xEIeRHR1jGLwWfUqKE7Pn1FBsA4VzbUTc0j62r6FE37NkqY0RqZg/fFHveWrEe0ZItL3xYxIYC9qY/zA4yAuMGniM+eOUeqj0YSfmSTKypWNPZvAFZ0iU7CWHpSjTj5nOfAjBRSQi0kZR+0NnNORIxeSXnBQ1qeNEFSMxQgODylvXRw33EQh+pyhz5fnCChO/e8bpgq4y/rahgRB66XoDB+yGXr+dNrfE44fsgAhZVZm0uUNJrvlwOAWOAmQU5XZsv6Mi4S7GaQj1Ley9WmDKvrmKgO0LH85mAcY9rvp47ikNZAX8lQUy5HQDNv+bNsC61FpS29Y2BrZKDUz5ruf3Qyx2wIfjASAFikJ568HwZ7WfRZRrASXfHMI2OtezhwyupU046109HGP1wbaW5E/OD3ZdOS2V5qyi7uGgvN7GvP6Zo7zEkHsNvgdy99FOUseUXKQ6mOwqnZw+0XrQcbM4KkCqNsN/hmkGqXEKmd9xJhrDOtt+yYnkBXBr0JS+FHwquvImiGFsqsjRSPYyqIdAeMpzKosbNBMP7Mr/PVZGILtVMzzFWYergT7EgnmyxFdnSKrQZRDQz3YovCEs7NYgjAXtOSm/4qW2TmiAR6GbooTzdwl+ZqGVXauHm0YPANPzxsArewEOtDQjmBVXrP20Qvdd3Wag/jkUqJSaSDE+RDp4z6ow5A/DEoshPSlMZv1e2apj2g7iVHseK2yEbu8Ta8YZ7iAVMgq3SOu/r5n7rY93eS05l7m8ye5VBSQYzqqriqm7ghVPL2GudtWT630URKB5TRXsucNAcU16OA/yRCl5RBFdtQWFaEb4V+wvzpekyhSvIZCQtrBVqoXHcV6v9ipzqWo5LeyLEpbFC/dNP23y6ea+Ij9LXQyX1ZpdCawy+hUR4sQzxulcHUNQdWH7zUS038Yxu/90EzLuqKd9jE9SiyfKc7
 bHxgrKkx
 zdOmJ5FIyX4mRk6WmXAw7YedDnS7UbxBiN/pap0+HLzL5QO1jRHJ+C+1jJ5y9O0WMP9gsItSxVBWssfVAhU0Ge2tkGRcxsOlJk7x9B2SM/XdMK2Nflr517BIbmopPxOhMZSIewKjYqEm68wmlvu2mwiY9/59QFVqFp78phGdwPLzwMkBDKPeaOxx0Vdnmu2qSqBVZ/Q9RAv9C9h6CAkNG43i+B7Ct1Tb6rCwJov4Q83UyPzCssenxOX3nr8p+Jdnw8ahROUpM0o4C6P8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

In include/asm-generic/pgtable-nopmd.h, pud_leaf() has hardcoded
to return false as inline function, but it misses the "define pud_leaf"
part.

To prepare for fixing that, define pud_leaf() only when
__PAGETABLE_PMD_FOLDED isn't defined.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/mips/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index fa7b935f947c..151f4d15bd12 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -745,8 +745,10 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #ifdef _PAGE_HUGE
 #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
+#ifndef __PAGETABLE_PMD_FOLDED
 #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
 #endif
+#endif
 
 #define gup_fast_permitted(start, end)	(!cpu_has_dc_aliases)
 

-- 
2.43.0


