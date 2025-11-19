Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CEC8CF2567
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8766B00A9; Wed, 19 Nov 2025 02:33:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9FF56B00AA; Wed, 19 Nov 2025 02:33:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC826B00AB; Wed, 19 Nov 2025 02:33:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE1A16B00A9
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:33:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEB36B8D04
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:31 +0000 (UTC)
X-FDA: 84126541422.23.A924CB8
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf06.hostedemail.com (Postfix) with ESMTP id EC1A4180002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W9W/9jbe";
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUnrWplutHBzvgR2dvaxPt91n3EUIlT8RN+kjzr9YeU=;
	b=fIr45/qoSwcps6adIIUvr4nYZt1G5jB/5b+hK8ksIh55lCPNeny2JGDKkB2wxA3yTm6KdQ
	Y8IcVMrzfgz9EXtI+xzsskHlnQgXHQoZjS8hKOI0YtrUbqt3dzB9eW4Byp8C8MvTDjQxRU
	0aFXqPCRZH7DFR6NRwmB3ARUcvYRz/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763537610; a=rsa-sha256;
	cv=none;
	b=V2N3Kr2vVaB1P3RyPUdSR3sIO6iMWiOCCsoHqXMDSQAQ7y/Wqz5wFhG1TzcAeKzU9IPDQx
	xHHjw+dpY6TWBvVh7RFwWMpC57gFJ8Sp4lDNOlwhHg6kDVlElASRGvCnfKVHXEwEm2rMF2
	rYSpHvu3H8bxej6bXrDlRPle3aWzOGA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W9W/9jbe";
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763537608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nUnrWplutHBzvgR2dvaxPt91n3EUIlT8RN+kjzr9YeU=;
	b=W9W/9jbeN29NpXBktlOeuZdun6gLuLfTHYgZNBEnwmUPS2C7HbpVqgtF+wOLSoQrCR+nsv
	lZVMJmsyMyvFqrgawPm3nejPEj5RiAp+GDf2+i+BBoiZ9m3cs51DJAzOJ7V5PQ2Bu8uOUa
	OEIRgNRI0+JvdYgQt5MLrxebdOjajls=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ioworker0@gmail.com,
	linmag7@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 6/7] um: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 19 Nov 2025 15:31:23 +0800
Message-ID: <16ab9e6ce0febaf2fc383b7e09e3f1fb2ad63a40.1763537007.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763537007.git.zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: EC1A4180002
X-Stat-Signature: 7t49a8t3mrbg6njbah1gfj7pdd1cu13e
X-HE-Tag: 1763537609-606195
X-HE-Meta: U2FsdGVkX19YYr4P9JouSmwGlssn1+hYJUkyIDOmOKM/Gg4jL9c+EbAlI3b1jkoLxAXk08xAyVxEW0czThfavsHS1SiIq+wOxz86ZjiaaBsVaDQbZEAMAyn/4CJlpl1B7ZvRI2L9krvz5UotF9dSNu1N2UPLnyaawxOmvJCp88vU8fdOQpybabj5nuhgjSB9D/fqbisusbNw3vY8u8h9MkpwFh4MR47W5yy27xKVRjKWX/XYhd0LvGY+9jKHoCiKI9OGm5nLO/VeFP2QNfR4IujvB9UBF3U5XA8rrPMVQBgPRoxFSJWAvm+SHdn94aGZ0IsmqvgNFBSDtFf83Tm6zoY1ZWaPBir/MF+VS2SUlYzI5f9Pm/WiyeIdOy7Zpyk0AEgC6j/7qLNbrHoFE2O/3HxWYoPqQyKJgAiYBcb80+pOP+Pp2yx1b+X1KZESY2BF0SLbKOvbKOV0Z2imH+djMGAPASaxmFGFPAhXibxOGlkWZbQe9e5oGGE21s74f0TrpueczhqN9BP+kbpe2WWJmCu/0sxUpEBtLWX8IGpSy5u+vqI7gdDmXM0cCDknscs+DTmSSr5V8aIW2ssLnwKSvik6vNykXwmqgw09BxqdgW4Oo75NqFhYrfhMSaomYZdog0CdrgkBUoU9N0kMMVdiaG8Lnq3MQUh4VIN5U0KHHEX98ec6/XMjsO3YCiDZmoSZQWUu85HpWN2c6XzjnDbEmIxxlzd7Rr9X4R3EfLo0Wykjte11imilrFais/Zy+qzNMQfMVPcBY10kxZKHRJFgGl2S9dYJpOo2PWluJwI4HkX1z2SrwZWag2slJK/VYqM4C8WEdKAkttEnTTwrSMOZRAzaYvej3PPZRjiJQZMz7iLbsO32rNz3Jt1OhzLQE0rNNYVobgLpxN/X79V4Rg8KW2hLsMdQfugOLhljAJFYu/lpgbElVz2uuMLS55BF47AEvIcPWQ9FLAosjvxlo8u
 0y/gZ9zs
 ugXasU2s4Xd2x6UVIDtLxQxUVIBPvJ40GKCSYaTdAF/AxKggZLj0mr0vGfQxIpb6PZ70EzFItzSzpOmp314t2D1f/5WbPWUUsFQAwt2c0dd9mvGbtRByRdIhyClcfFVe11bHhN+/2zyQsWTObjI01ujrMZEwQqnDU9BejARgfJda/5hBaUrXXKqHT0ZERj5ExUeOC4EK0o2wQ351EvdwiX+vNoAPiWcAT+o1R843MKeawqdqsaRkO5SFnMGnFdmDTUlvuePENuplk3nk4XfpEL/JvxaLhYl3GdYfJFzyJrIYZQf9r57+XQvtr0jVNkygsGzNU7FumTQWF0LLJeVVL5Op3DAEvJd8GAYeS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 arch/um/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 097c6a6265ef3..47a41bc77bb24 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -41,6 +41,7 @@ config UML
 	select HAVE_SYSCALL_TRACEPOINTS
 	select THREAD_INFO_IN_TASK
 	select SPARSE_IRQ
+	select MMU_GATHER_RCU_TABLE_FREE
 
 config MMU
 	bool
-- 
2.20.1


