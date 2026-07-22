Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 489B9C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1304D6B00DC; Wed, 22 Jul 2026 11:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108836B00DE; Wed, 22 Jul 2026 11:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39686B00DF; Wed, 22 Jul 2026 11:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BECA86B00DC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:32:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1D331601E5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:58 +0000 (UTC)
X-FDA: 85016805636.28.E1B3BD2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0E7734000E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XyJKsFxP;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ujq0wotvtM4mmyTxdoNvQDl08/54QE5mDlWyvsbn+fQ=;
	b=cOAqx/zIXfodhQqapWokPsRDGiZiqyVrdWwzB2UXv7Q1oqqvNCOygFQbPmA2JUyGjGpSRU
	h1po3jmreEAlSaY/SOCqoaIJThjq6EdBvXLINlwVKmbjkzykphHRPPMlfKeEKjwzjlPGrQ
	jREbd5b10PSkmoqV/Q7ZCsf9YbdOmDU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734377;
	b=v2qLmBUeZCERqb9GdtN5OR/CGxxQglS2HpXXjqWi2JoP59C9P6ql5YstOJDq4jwRnTO0b5
	doeJ+60H5DnSHGtv7tFkVcivBguBXc6AN+xXUGunBY4fdX0472bUft8B7RkLl5i4E1CLXe
	d+KNlL/zcdBu9nj9w0LvWLTn1sReYQE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XyJKsFxP;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23D0D168F;
	Wed, 22 Jul 2026 08:32:52 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 814893F66F;
	Wed, 22 Jul 2026 08:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734376; bh=Rrla32h3UFOwfDCIJ6mk+qS084GnFvMqrfkCfZ9JSzY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XyJKsFxPiHVmHyMB5tdKC0VZOaJ5wDUT6AKN3Lte8vHdVyPzXh/uia/Z0HVn8xxLZ
	 MJpub7dt7bxTTRhnbNvCnV3PmBb+Vtgk1WPyZ7OiGixI1C5hpGVoPBrfhbhS1kEDgb
	 lEXOBfK4WlUhNlmJl4mGFF+ZmyhWn0p25in03lgQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:27 +0100
Subject: [PATCH RFC v2 19/20] openrisc/pgtable: drop __pmd_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-19-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=881; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=1xb3Ozyh2JOl/Co51IUX05GaQJt/5FuoyIGgUorDpg0=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIYnrk3rC8ElTnTfer6SHj2oBWybBYLfju+d
 4SncyB+MwqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiGAAKCRBt1cPRWsUx
 M4boDAC/KmDndZaDO1jJrApOeQCuvkJuqhLMfdqukXrHibqTGpXvh7Lwc4sNcH7N5YegBcGYZnV
 j8OQzx42GbLagf+9QG/YfGPDybE4rC2OL5XPwimSbLMb+WN4I8/lilSnKa7wUaS7SL/b4GC2vkg
 8Jq/RbDvH+rgu805sIkfBKek5svMwWjMRRI14lIYZMBfgew6aO6qlqM9ztketbWrILpth4EwCEc
 cSBBO3cC/Pg7wWs25SiumksIV8bHn8Ze+9gPUFVMnrNwv9tddfeydkYK/jz7okv12hujP/fvdkj
 LDxJHLgKAtFsXVIjaQzaCp3WphsglIEJV99pn+5cw/JahUqiDyGT0p7IQT1hBvRb4s4d4fUo+Se
 D+tYt8k4B/cELCEj0LrTzVGfuWx+FVIESJpI0CfO6g+/Xzmfr7HkNrp4FAXv/nHkZbTes//Vc1B
 +otIwlYp1llqRUcFvB/JSLg+dlLxLagbPM2+dPFj+lO9ocdyz9TFn83w7Ns0+BMZmq00I=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0E7734000E
X-Stat-Signature: qexqappshe16hxxgxb1s5ymnrtxuo78b
X-HE-Tag: 1784734376-532800
X-HE-Meta: U2FsdGVkX19ex92rFCoB43FbW2EQg59NkwTNaoPIIdG5fw993/JCohRQGTPXF0QCBz7Q8MqfXn6zm4y3h+hz1SNXeegcb491XmN+SJbVdTaapWecoHHrVt6SJ//xYFeyM9VVtDLKY3Zw0QJcwHEp+LpF/anTVsbD4E7Y9YhFPUQd19ddfWGwYR81dwrx9GEEaRUkWmASHU/nR8WjFhKIDFdo6HacknMeiW192u0KfI5JnSZQpdh1uLbGRsZYNkumxZHoUvmIqs6KN+Eoy5pgCTB66TDqvJhkOCpYnqIDYWXPbOB+53KDEi4RD8rco81HwRfCkoizQpSVPWTvr6LXATCvnPwSx0b9UxMZWTCHCKbUVK+5OZ1VgXzOIoGJSR2k9jYZXxoSEhfzBjtSccqHVAo4LXCJKOJcBp6nM84e1sqE6dxc6YwDmGJG/ZHEwe0y9yR+KhOID4fdsDOJqD63bgLe6W7Jnx9IPnlmFib116UdNn6i1qGUzT9NBT0usLW77rPmHoi6CcTTheFMtwqygeT8h+MdgdWTcd9+8msGOxgsUdNMmB8CaAjlRPYgrOLiQH4HEaEk4x//NGE6Zg4iEBbHjUPiZRpaNXZIhJng0YmIsdnPSLhI3ztLHT4HWeNL1Cu2iax2iF4VbRxg5mSO6FPBpggWcvHE9ZtH5s/lCN7Y7RSFFbiWrQ4VgB42w4szPo1McrBX1kCHHL4J90veTA+bHohpr+H40PftUv7K/ype7xaHy0dKB0rzAWVk2uzFzZfA/rk9OfWeGIu/jaokyQuSI0bcl4GX/i8/OgHsQ8sneTL8cqSgnfMn4A6Q+Pi0H0kwwMCmCHOlpZZKBxNS4T4p9Y9bUrQH5EXNuatyXgtR//DwKP3gvdP9EMb/QgG+VV/WAD7t0aSLLsmf91udHTbykq5NTn27FWb+5gJ4iUe9/CcG+YKeHDl7a2FfS0Xq+ESL6ikTMUWQdnx8kZz
 wFbf33G2
 iYEM8faSuCiuFXAYZpbOy6aJ7BUEaN2YRznNDUO+CFdRxn/BYrrjDnlnI29J8v8hgYzoQpa4u1RLuGKPG9kWIwZPhet573zoP7T6Ovyu8yjEMIpBbi+Ng07QgK6aYXP/sKQc4dhRIznfQ1yYMYryvSaGvee38mKRgwLmSTuVqhSuD7sZQWhBckiuqqFxxR8x/SD7RcW93inK39eK3gc7TOIItZMJMqB/9R/C3iU72JZWOV4SHxDfkbiw/zqvQcIdv6bvzsEnzsqi9IVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

The macro is unused, and will collide with a folded page table helper.
Let's just remove it.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/openrisc/include/asm/pgtable.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/openrisc/include/asm/pgtable.h b/arch/openrisc/include/asm/pgtable.h
index 6b89996d0b62..5a491cd0f008 100644
--- a/arch/openrisc/include/asm/pgtable.h
+++ b/arch/openrisc/include/asm/pgtable.h
@@ -331,9 +331,6 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 	return ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK));
 }
 
-#define __pmd_offset(address) \
-	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
 #define PFN_PTE_SHIFT		PAGE_SHIFT
 #define pte_pfn(x)		((unsigned long)(((x).pte)) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)  __pte((((pfn) << PAGE_SHIFT)) | pgprot_val(prot))

-- 
2.43.0


