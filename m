Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71030C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16A96B00AC; Tue, 22 Sep 2026 13:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF026B00AD; Tue, 22 Sep 2026 13:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDDCD6B00AE; Tue, 22 Sep 2026 13:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDE556B00AC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:33:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C6611A04EE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:15 +0000 (UTC)
X-FDA: 85242094350.23.9DEF2D5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9DB4016000E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d3xeuRYT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trFjpGYQm/7aTKy/U9BT2hK3u+qGHDDjAWvAmM0cDcw=;
	b=OGjmzyJ24UPVNSWEbIz8uFPYrUPHfthOvVSCYGvJTbWvEFR+X2AV+UiGaUBbYbCw53qfJf
	lLhgrD7ZBSV+ejc6Ht3PYcGjl1XC6j2wwqS91SU9Jn9uBAuDjxlzl0/+WKjf3NHwMaQJ5k
	JIdEyatBJ4HELg8SyEOoGrooUIFTvCg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d3xeuRYT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790098393;
	b=8UnfXLOkF3OXpDUvizD7/CAJ1rI0IkbZ7D5bHnUHTKOytmIKLg0Yv1TookulfviJ3mO1SY
	r2t9RmKNk10AxKDDJ+7mrHgqcKqLHcj2dsFqkMVTiBTiasAvOFcQyetift6P0tZx/B2fmC
	XCboFxZacZsYDP342q3aF/0x4ounr4M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49DA01AED;
	Tue, 22 Sep 2026 10:33:09 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 616B73F86C;
	Tue, 22 Sep 2026 10:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098392; bh=PeJQ7fYXLGcw4P0kvfY82twCI/k6VJB344U1K7tkEMM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=d3xeuRYT+klOzNDSyNdM3rcbkRZj3fdN5cBa1D1YwCIZyxd+7f7Sy8BgbNUmU5al1
	 3s/0EsafMWeY/ZZrmT+pw9w6TaZJeLQe8kr+7niH1ZmkhigzCVK9Oe/kkhM5HFTKdQ
	 LdRNH7rjihzI3dDQ1qhnr2R8GM6p9/Ohat1pmPv0=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:32:01 +0100
Subject: [PATCH v2 6/6] arm64: enable a distinct type for HW PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-6-a3f1ddff0a8a@arm.com>
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
In-Reply-To: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 9DB4016000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3bkjxiq1c6abr9jwx95gcca5w4fs8aay
X-HE-Tag: 1790098393-77920
X-HE-Meta: U2FsdGVkX1+BQNUy2/FtZy5wGhSkFVffCAKA/eTgPpaZcJsJ1/5MQbTAWs1wJHjOPk2PmbDErW2/63lG6z2+R8WWJIn2+BQdqz1bkr00YgGtdO4noHtSslVNlU/7YQGnnn+45vhji8cXMXTFoQbInzWWGJxynmmIcY+mgFwZuj+aI6wjxswujkAwxi9rVqii8Fs1jiKqp7it8erOpUhGImlyuZwoW8X+TmJJmHJAmbqkt6r+o8LF5SQwq6HFUbCVq378uCxsHta8Jk2zmzeHEck3jaGLvJgcB0XTCk33/1X40HvmgBiV1hYfqh8NswqD8IpuKlqYjHnkQ/8b9BcYV8Y5va3EOY6vHb7VNIH4qRj/aNzQbIZ9lttnWdO0S6dPlMQi9V4GqpIA64jG2NnHQqg4YbTEESbusZR1LFFLlry8USjANjo6V+05tzKgc2tIJZsvYUFC4brLydZEEkfxUXGIjdKqvW9Me9xs/CXSWGBoGHbJ7WfcMRPxPk5ottrbUmev6QqFf/Ms7iEcV1pciaSL7lfsQuUXkeAyDGVTf5r4o1DErz83rt1F7S7RZDDdzaQAPONO+8uiNZEslcflRTnyxvbZCXYRgs4wxd01653s58SC3fxwXNdl7XFuLlV6PsX+Cu962N9SUpZRFnt6g1s5yWJW5zoWPS9MXEka+E6pYdnvqy0wuEe49EN2fNwZEhA87ZDAO5oGFSrJWnEBAyVWD2iT4jeNsMO4nnhQHa55QrIBRH03cUzRBhrlriGXytpUAWGVshqgnmwA+asZLDo6oYunQbuTr2oK3AFyaJ8GQFvrx2GSjUqIocyVsCuolvb/vqgCxoWbQDR5nQQU+2IcKvG3Z9DG6cnLaxMVUXdYy/wafMeLMZCvqBE68bzm05l3Fwon4Q3TmrSpoHawcbgShbKQlSPeyR8+3wh5lz5XEl3bmMdVEDyZxfdNBuqB8Ho3f77e4TXShgtMlUC
 UyPnSyob
 8fhPmRfRgPCY33yDULr9SBa6ISo+nGEgkR6mKnm/I4WJ+kBq6GVZdf9mUEsiO28y9lC/DSLIfh3mjJHLJx1UJPRXMC8MXCyC06r9o+N91+M/0obfSGefQiBND5Zw60uZJrpRZK/gTfAWkWHrAZiXxLBsg5nh9QDFLRzR8slvcApF7Hc0/KwFQB05ZghzWpl6kNYFiq6hJLbD/GzLD/IQVVOY1DF/eyazQLhUl4l73y7e7/7Eipw+CubFuv5mW37NAdoRxTKHaGVx3paBI0k0NxuCVTTCZTopcvIbPJmCiHlzaof6I3b8Psj/IH/O2FUI+wOC+m+Uat39FKrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With HW PTE pointers and direct HW PTE accesses converted, arm64 can use
the generic hw_pte_t wrapper instead of the pte_t alias.

Select ARCH_HAS_HW_PTE_T to give HW PTEs and SW PTE values distinct C
types.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2bbeded33da0d..42841d5e2ed26 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -31,6 +31,7 @@ config ARM64
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_HW_PTE_T
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
 	select ARCH_HAS_KEEPINITRD

-- 
2.47.3


