Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E883EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3ABA6B00B5; Tue, 30 Jun 2026 12:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBEA6B00E0; Tue, 30 Jun 2026 12:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA106B00E1; Tue, 30 Jun 2026 12:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDDF6B00B5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:42:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0911E4058B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:09 +0000 (UTC)
X-FDA: 84937146378.15.180EE4A
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4BFCB14000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gsWUKCdg;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837727;
	b=5yeB9MM52aK2p3iINZghzxhj/TPRCVFMUHUcFtFdL2Bt/CF9b7A/0H49Bw2gJhNMZi7NzY
	oFB+SbMVH9I3YdBt9BWjK3aYDjiwykib1WcvmWb8t9YY94tQ/qwDqgfNODpFFrEGNfRQqu
	i9NJPPcbuANRzteVhxOTlXUIWdJCCOA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWxKWelYN6VOFhLaKXxrOAvySHVCOpFgMq2qLns63vI=;
	b=UvSpRuQ1V6C7tCi642rz56y+RT5ndAx6t6RGv8hxsfJ0ReY2J4/tJHehHJdlLWZyTXU9eQ
	L0jUgy3huUEHtxsbcpI2T5Gn4bIVaUnXcF04hD9BnNXwyuotOJ0H6/NtfE/CYagtCKRVnd
	p5gihYGwoKrrP0gfHOwMNbwS136czuw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gsWUKCdg;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782837725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eWxKWelYN6VOFhLaKXxrOAvySHVCOpFgMq2qLns63vI=;
	b=gsWUKCdgvKr8KWrX7zZ5gEPQA4fmpiw0Oys2HzltArX0pz0tYEV7SzII94iwWuvs2qJPtK
	rglBXqUKr0B3hSm57ZpVxKQSZYpp4bLpaKDjMBWleaDqFHsGFYKBaZuatPNp7brMPIZO84
	8GmdNGmPtTGVg7SkaF6na/pePzD1fns=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 3/6] fs/proc: use softleaf_has_pfn() in pagemap PMD walker
Date: Tue, 30 Jun 2026 09:34:40 -0700
Message-ID: <20260630164143.1595669-4-usama.arif@linux.dev>
In-Reply-To: <20260630164143.1595669-1-usama.arif@linux.dev>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rrho7gjcbtt7sdqwpgx6dan1hd7cagbf
X-Rspamd-Queue-Id: 4BFCB14000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782837727-127597
X-HE-Meta: U2FsdGVkX1+bSKupZE2PcEtzyxqKWqCRiIO97RlDseCH1h4Sdu35sZQCuIIluUxAByj+eN3UwfUtYOcw1D7Lq9RrgkTzGRrNrc4ZH8QNlC3CIiwY9DD03cV3stCCLXEoHEqTIGqBaH+vfN4FDB+hKn6gnfpDYcm64KBZXC1hY8c9DEPwVGWhR7DHNjoqVbfwyDEWXV9yFJ6z5B96CCSLI9bh4PePxY2UPRpActmHCQYtwhsj5cwRau2EtlW9BQVfjieOZtbcISbYfLaSt49a72LIdBvzZ9Jo04VB5KT4roI4ieBc2G9z2k9bz4JzNoqVFe8hW9UdIZcDFZBavlnhGuJ5fDu5bT4pN33FhazqiRw+5qg7Hs8oV8dwfQQw7csUmSaoVgAToPEbQIsmwyI2iJG+gJXh27DLTRveRWAg3X+1u28Ozkfwu9qIR9BfX+/VUTobsYOyH96XtQHzQr8fN0iInnLy0I2OuU3tL0Fxj00x7sJbsPKxkKYkKPH4+a7M7EakAhaWDFKbeP9ormSeQSsPF5riwtpU+ItA1XHrNvxVzYUO4YquAiSqnDsWTM8jUSBCej9ikGsmYoAcGrCwy5Xvj9CwS05dtoewfCE0Lpl8MvSJ+0g2Vup0OrXUtIiWANYSPuRTyZ6bPEAUfxAhnME7qqaa2rt/w4tCEhxuZVU96gmqQh5BWIP+ByFD5z4TXlNxTpkZyu8u6qOUKJ7LAW6wUCC1cEtwo8AFLaKrTMAqXeKjOttU5Gh2EnKdWkWncNG9cmZCtNyoZdNuUtSLPP0609SnQ5aJ3rsFl+K0r1nu09JQVGXpTr9uBvlNP3Ql7Y7z+z3qJjX5DlV6QVgTtfa/RVyQIYOWMThSFsyC90lMrvgksRkQQVP7mr7Up0eMM5pwD/XkGoLN6sgXnUcJGvfK0kCYP0lkEdLeQaVCt/x4Mq1BB8sjGQvkUv1dE4FXuywNbeNbrAasjqEPMmX
 huu0wCcs
 Ik4sKHM39v7ZXQ+axZsMQGHW268Wyc/7k9CazC4EXTUjtFV2TA5ghUIjUQUGZr7jlxRWlsaqmvT4QYGcwM+rdFDlb/C/FoaZsmfLvbaMIWJ5gwX7rzMlrrXpc7ZcNCwqqC+nwx9ETB6HKK8+LpEVPRP4zR1VJSXYqHal+tCxxhBUM6Dn3uraGzDw24BxXVJDtsVyfpGK3gBRamyVGjFMylQNFGb6CH6KJEG+dUh/JFkvLflXPBUxfy4Ts+0yw/7Ja9v2IwRbGUpZybK9cnF7+tZ8ry05exhRb1/o7D/ovI4qKxPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pagemap_pmd_range_thp() assumes that every non-present PMD is a
migration entry and unconditionally calls softleaf_to_page().  This
will crash on any non-present PMD type that does not encode a PFN,
such as the upcoming PMD-level swap entries.

Guard the page lookup with softleaf_has_pfn(), matching how
pte_to_pagemap_entry() already handles non-present PTEs.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d32408f7cd5e..1fb5acd88ad0 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2129,7 +2129,8 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 			flags |= PM_SOFT_DIRTY;
 		if (pmd_swp_uffd_wp(pmd))
 			flags |= PM_UFFD_WP;
-		page = softleaf_to_page(entry);
+		if (softleaf_has_pfn(entry))
+			page = softleaf_to_page(entry);
 	}
 
 	if (page) {
-- 
2.53.0-Meta


