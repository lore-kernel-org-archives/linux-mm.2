Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4FC9C4450B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04936B00C3; Tue, 14 Jul 2026 10:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC056B00C5; Tue, 14 Jul 2026 10:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19026B00C6; Tue, 14 Jul 2026 10:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD416B00C3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:06:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19025403B7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:38 +0000 (UTC)
X-FDA: 84987557676.13.DAB9290
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B69A1C000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YzY9thwi;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM8SB61kZfRlZBBjK1HisTzxprKerLF7NioQQq06LHM=;
	b=g+ttays+ZE+ja7+6x7jRt3ZSErIi5Bes188eyG3mjklQuQSisz18CJqXv8VU85VoHL6eNz
	LQfOsNzncWrOcEXRQ0EqJxbeP9Z2mFQdBsWPHdU/G0rD7XEbBzflWBHzVeU0iOJkewFx+c
	yOyzkGeXwKWAKDxGO/lDmnzG4ROyPLA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YzY9thwi;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037996;
	b=1eFfH/t9zmhfgYJycTiIBpV6jG4140X95sh5+Q5dNzDIPU7jbgy0OvzesAHAaZyNQ6Hw2C
	Tpscaj2kFYpbWgx52pJ1SDfETfT/ko3Atmv/MDZF7ACMT/xlEY8a4IqIpp5p2rYEp/80Fc
	3ptUsq1/Zbnv2umMQ7YMVOKHqctye4Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8A9E1BF3;
	Tue, 14 Jul 2026 07:06:30 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE3913F7B4;
	Tue, 14 Jul 2026 07:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037995; bh=brubU8ipNy1ujnPWOSJsU4D9Csfsl5oNxDWj3XnSBxg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YzY9thwiHc65wNiUxU67y6/tJ7ZmfWCBeoA2a4LNQMo0O7ibHK6ctA9ComeTUEm9C
	 I/qi+0IpZSq41xPb+OZ7Z3/G4uCkw9cLd6IhSMUabwxmOQOqx2sF6D5jJAoetl8ck9
	 oA5zuyScXswzHCcI9ibhnX1aroPeO+YpvDY2p/3g=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:00 +0100
Subject: [PATCH 11/22] um: mm: use mm_is_kernel() in TLB sync
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-11-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=784;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=brubU8ipNy1ujnPWOSJsU4D9Csfsl5oNxDWj3XnSBxg=;
 b=/PzTb9tRgc6q7ZO/WLmLmpzghLV5CdRWiA/u95e31NiKnKwzFm+3cKJU2/zrnT5S/P+reJB4V
 ezvWWMbftRCD/SWI9ofvYfumKl5AhLTyCVWAwhB/2VFq3mOJHXdgNVl
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B69A1C000B
X-Stat-Signature: 4nmkstjg6dmxd6snmhasdgo94tkqewun
X-HE-Tag: 1784037996-53288
X-HE-Meta: U2FsdGVkX19poVmDitjTXtqi0mNuosVCYda8t6SP9AuIdtAN3Ru/XxVk/l8Oddc7XGFNk2Bs+uZfnleS26wIe2BGqdVWOTh/sn8V8R83CbcsZgj9DtBD/V0K3swSy+B1iS2V9+82CGlnqTlFdcz0QFhoPqrrghdY4SnOW1cCHRDFbfJAIjo0FoA+A3bJfhydeiOy9bTDLb3XQml3+lbl1XuPxRGHcJ3J+W0NFclq1T2cR6MIMW/rsJHGdujZAaDCkBK3AY220KRlhFUa96Ob7ZAYSGiDFCB2YTr7T9COGLcpHSO6yXrkIDQwaZ/5PQnO/gqo5ku2cD6qMplVBaGm6va5Ec5v02MpFyl/8FZ/mc5c/pPaGr6iIFQvUPpBqwfFRd08SnTNC8baVsIW2KdZ+vJroeQCTemYwETzeSJwY42reXDkyjg9MJaRJniqqUdG+p9gAfD+QTCAds08Pvcs8NnsFldTOXu+BLlUW8avdRSU8mCbCQ3fVRkgswnqjPsgFGFTOcgY2z5UQ24ss6w1rMbV+eSOw2IOGoCu3afbplOd2U3ZfA9fQluuSa08lCDHh+N+dqndS5nbLNy2WQiBkubrm4yx1n330oeeFN22VapNhGEXovQY9AVVyb7O1vMuhAnj+OadEkK6f3LIwJnOXz5M4gkmER39/pdQnut43goEFi0GXRud0FBQjQyJtg/V8OOP0IFTuhpHWXf5KPogi2UZXUuwFJpHgjhiHD2eN+URSGx48xxEnOjjDiKliLetjvl9c4r0LzmEzo6WCayxJS0SMQSH4SLugZd89sxix1iMq1zh1y3MlRIXm//Cj/NTS36y+Dnm7aPfqdGhsXtfH317kphZqgdDUtwLg54pLYBneFXh8lX9SreUx3sSV/oBCkXUm9UHimI/+YEXzh9U2UrU8ReWYsXxZlhXgxvQ5GrG4CVFRQSFF5OfkJ3s3nxIN9piMz6SwMEUUCjlwAP
 7WLH+oui
 GyvAKAq7t2RPzxqsmXpTWGS/XEwnECoj6b/O/e0/7XNQn9QxMVBc50L8hOBidfJo1zaRzqFTOS7hyaSITuXap4IKU4oxFeupiJBoZQX4YKACS85h/bt9hPerrvKW2VdOCkwkqCSj+UqqPOLBKxw6vrYecBlOaH9fftKVqc7hnVsy76R4t6yJ6OnHdpLnexzNj2oHarBA+uEScMxtNt3k0mLIghIdc2u6DOr85svBppIh878InTi4L5lRDrXxe2kApNp/xlXc/varJnmd3omVCPvQ1EeArMNvmdjjp44VhiN+APpsOKs/aSUXHHEb4A8PY9V4Img7ejeV6fp6XM3mizVjzMsZ+XrhR0UbRwC/BIyjod/1k/uVtDxILnTC7hJrzVGdL3kzc9ylvniQZcEsKAlpcrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

No functional change, as only init_mm has MMF_KERNEL set for now.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/um/kernel/tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
index 1f175716b474..fa34a710203e 100644
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -171,7 +171,7 @@ int um_tlb_sync(struct mm_struct *mm)
 		return 0;
 
 	ops.mm_idp = &mm->context.id;
-	if (mm == &init_mm) {
+	if (mm_is_kernel(mm)) {
 		ops.mmap = kern_map;
 		ops.unmap = kern_unmap;
 	} else {

-- 
2.51.2


