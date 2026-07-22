Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A8DC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA496B00AD; Wed, 22 Jul 2026 11:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA28C6B00B1; Wed, 22 Jul 2026 11:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990976B00B2; Wed, 22 Jul 2026 11:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 738E16B00AD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A3B41A024C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:12 +0000 (UTC)
X-FDA: 85016801184.14.51E167F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id DAD3940008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bYolj3D9;
	spf=pass (imf01.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734270;
	b=WNgPAJqds0en5WOG7p3QesE/kIUbUGbb3Ts24y9f6qgF3QDNzFHKFCoWnXX3A9VGTZuTXi
	231VX14zRYi9r8FyBEKXgnTteXqq/cX5SxV1ROdAXVZsF1FBnA3YG+hAS5BZs6p+NFMVPG
	b1BOhg3PRGF+g+7qgN2KnWK4ndXy0qw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bYolj3D9;
	spf=pass (imf01.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5wdAprYK92d9yfsq+cUXf72FfNel0HhTEHxnd8re/c=;
	b=fhKifiQlYhGTz3asqsJhDG8Wm3GyQW3xsp7s4gPUvPwOqrnP47HdZbyJm0xJdznS3CfU32
	ebzF7+XuKbrAYDX56kGfz3L1uyvpZO0LPeVtcOaSwC7vvUPZoEf8YzsQORa+3uXtpo0olQ
	GPvv2uIab74KRIAwwr+XvvdYnu9f6rQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C53141595;
	Wed, 22 Jul 2026 08:31:04 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C0253F66F;
	Wed, 22 Jul 2026 08:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734268; bh=j0suFj/k8Gjr4NVwWjc1PSJ1cuCmTYQ6kxO/jY4zAXM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bYolj3D92O1Bkcb60RbrELEOeLxC7qGiqrMWoWtuCVK9o1rROA8BeSTEehzqczBjF
	 eYwaWgknouSSn8Jr4x8hjddfjdjfPza4khbR2hWMic7OBD53WOHQBqO1G9dCqsrvXW
	 gFBujbdyV1Mk5pLV6+vLyHnOJZ3ZEHNvXsqCp0Ew=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:12 +0100
Subject: [PATCH RFC v2 04/20] LoongArch: mm: define pud_leaf() only when
 PUD exists
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-4-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=985; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=XSgg9DU4z+fpwZlmcppVFAW3W7NViUDDiwwjek4Nc8g=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIRg3ZFYgpHwFK1On9j8uxrxy90og7ahILe6
 1yqnuhRWRWJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiEQAKCRBt1cPRWsUx
 M1QWDACgUOyq20o0bRU6YzrYy+b7sre2Ng1kMqamUWE3FtJ3UDmIzrC5o6Iq/xiJuQ3V8mER2+u
 sevnTIQQr89vZ9/I5k+KZosUXZ7NfZlvXH+uxw6usioIMN8Efb/0o7XAhncpDgnrhz0jqJReJ0c
 1FeAfWsc6PjjC+VCtxvXVgha6Xl8aEoKHnRFFsFgjeWCpMSQSvWE5cvMWaPhrkMA8dipKjE9B3n
 uJJ9l4UBtZuIa+OiF0higvwhEHRNZWiJvfJBssIZRq4J+qNjYnJmWaAfiiEEJtExocw3XkhHcZR
 bMflTxQkLe50zAegke/F3vuVZzXG0oSAyz5bDqzjnCYTY0YLf4L4C+PVKcIeOg8L1CMkgY7ZuAs
 jzmsrFaiIVlZeT+2qxJHempmPcEYOFmjrXOS+OlUA39p1kZ8vQzlvLM63vb4Ync4R1M4lQ7dOhq
 guDP4rJuLCL73MzRDrsWdrcsvjAB/6UlAUTfuSNeyvc4TBQH32QYx3FAtAbKB/T/1YZiE=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: 6hjffg5qs68xiakkmc5fjky51kyp737r
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DAD3940008
X-Rspam-User: 
X-HE-Tag: 1784734269-842192
X-HE-Meta: U2FsdGVkX1+k68boh1VEknYgjU+T0nTjOZUx/JpUgHzjOzEZ+Sh1cO/jQmevxaaHxDqHpLSHYzbRXYim712Qb6shRpnMeNIYrhfmGVMH7CYkWZFwleUBYCafq1pEUVQO4mkgcYD8wrnFdT3qdZZy4gxA4boUJEYlD123wI9CNG6KNiErnLifF010vW00UK9IYCzuKJiIYZCd2+lJXNhC02rs9C+atwmFHRy6/36wfq4hwAOioJq+dTBKmskVf0faRCoyBgBBTVCkJPwrCKqQy1eS/DireO7V4/tb3XL35Isyj7Qb5hUnc5Mkt7+4VQVfaKHbIBeO0P1BGs60p6AR7BcA5O5i4ClkVFcxjkuaMiBea/JTV0dc0su6VlyfAoPOjtKeck3w1eEAf3tKgQ8amGAQBYAfGfLNGKLpaWO8w0R1HSa24X2Fsok9pfV8oqYINXSCpLoJY9rduUCASrxGU1vyvYNWtMIjQza/GhX1dgI3XZnMBeRi/3J6uuGDb9m7WMGWPftBCrLBIbdI1aduOovE78Oj52M1XPtDSygPDXvRNIWkoE47zGU9x/ieewaN9r37uWs20vR2wysQHOJzW0soVT1UbIVaieulUXQUgsCFdDbf4LpjMifcDty/wb1+JrwHVGTuCn3schSzzujqANPffMYOv3NAbMJv3snnG5UWolbEfZ0asyLdFeK3sOvIZu1ter07ieeMUNl8AyEYbAEsR54UyhHpMTj9HvGrpIwzGU3h4vkn1lU6Am0lxZdwecd99o2JW6sPvW0v4n0Ttq/Lh3fApdFOKF2KsyrpG+cD5RK2M/kGeHjK6iGk2SEddizF218XAQLMUgfW583lSZ9+Uzzdl0/8JI3sPkiQ4BTpTqQHJjp4L5XDQFpu629pBqUcL4ErSCr11Ep6wCHI+vInSTKh1RleH9LjMYZSz0p3jNPtuMzOoWOlnTAX/EEwDbsmzQYfNgNHwbbdi71
 MaEIYrsR
 8jB7ulrrUZwecZH2DZcZdjXYntlLQe7PKaTIrTfVIIy9CoQbBdYR1ISYygEv1+mNt3bkkjhQce+yiKGtc2vWfoYOPo3AItd5obhrArAoKmqLOd9WLk702eCj7OxYUrOsr/KMD/RxGblIdwMVdSC3ow2f0GcvIjANg/4w0iEOo+2rgYtUOzv3gMH9uhelkH9MoBNKK7OMTtZajwkDNzg4UWgwn0MYPSsfapLGWF8Tkfz+9OLoIf4+RCnO4QjAoKBZrqhpp6jNgJpIJs7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

In include/asm-generic/pgtable-nopmd.h, we do have a hard-coded
pud_leaf()=false inline function, but we miss the "define pud_leaf
pud_leaf" part.

To prepare for fixing that, define pud_leaf() only if we don't have
__PAGETABLE_PMD_FOLDED.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/loongarch/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 1952e34bc8ee..434e5b483466 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -636,7 +636,9 @@ static inline long pmd_protnone(pmd_t pmd)
 #endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
+#ifndef __PAGETABLE_PMD_FOLDED
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
+#endif
 
 /*
  * We provide our own get_unmapped area to cope with the virtual aliasing

-- 
2.43.0


