Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACEBEC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B119C6B00B7; Tue,  1 Sep 2026 01:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2B16B00C1; Tue,  1 Sep 2026 01:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01646B00C2; Tue,  1 Sep 2026 01:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DCBC6B00B7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:45:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05B161A034F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:45:05 +0000 (UTC)
X-FDA: 85164104970.02.E2BE922
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 59DFB140003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:45:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mxQNKj4W;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuLYgOKvLMEtROVzHb8GRMGectdFGm83ujIZhuShERo=;
	b=i8WZu+VdfG+FHLnPHnFC7WHjFlV0iDixd7A2ncR4YTXmozQpxo/mnFSbk7qFbtbfiGjIYT
	Ca6HRga/MXbm48DSzPbsNfzmz90OfGgbsmHC/FA8DDIxYBwpJYUC2Thym130br2ZZFPltJ
	Yyk+rOXgiLy0n5hD0uHyYBKuSrziOrs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241503;
	b=EjOcXMYyhiZtya2BF0uZfg4rrVAYIyda7FqlHctVg45RF1FJIIHQRwskQWL1Hx4ya75lfZ
	vHVBJn5/O9V3Wbud23wbI/5kjV5wx29Gpt9ww5XdJOpzPonxnI8hYEgart5OesxofEee3r
	rsP9K0td9A/7auGl34Nc7xljTAqS0vw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mxQNKj4W;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D512F1AED;
	Mon, 31 Aug 2026 22:44:58 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B6B9A3F85F;
	Mon, 31 Aug 2026 22:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788241502; bh=tmJo3rjw0Sr3OV0lC41Li6x3+cmR1t0LVTih0JfnMfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxQNKj4Wb0AEhmFu9i0suaBsQYFruZECm4SWTseJP7rcY2W3tIcJc2YI9lEycAGbN
	 ZsPZbxPAQokrm2WN4mK1Ud3PO6iU7lcQ+kcXpB4dNkc5H19R67JsXBZnnUMZTQD+38
	 NeY2MAeNqKc1GX+dQ6Zfqt+VNWjlIMJLzoHmT2n0=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 7/8] mm/memory: use set_softleaf_ptes for uffd-wp markers
Date: Tue,  1 Sep 2026 05:43:54 +0000
Message-ID: <20260901054358.4049095-8-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901054358.4049095-1-dev.jain@arm.com>
References: <20260901054358.4049095-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59DFB140003
X-Stat-Signature: f6aifjqhhnmn3gdxxetwy7w9kyce6pm3
X-Rspam-User: 
X-HE-Tag: 1788241503-604905
X-HE-Meta: U2FsdGVkX1+MzGgSKjD7IvO+GE6/M7Cu49q9ECss9dnlRNCzUwv3IrqZs1RffekkQAHoWtW3ZdJmGX+VP444xokiHJgEqwrP/j5rYGFNT+I6QbSZNDT/i9WvPD6GjfAavRRjMFEcHrUbGVDu7kTtE52Ri6a8dgDa8EnsU0etINh2529vcHzOyRsPL+jC36FaQw2B48fZlEuN8Nn95SQIKYbkhYZenvWH/VTJMbnAzOUXMZXp0oZWRotryZuNV8xgQ/ja3yrW6O4jvsHWGZA+XEE7GKHjtWXgNX9LtA1qFZAyNnQS2aZS9+HrxxaCL1ISaA74V4sBkuGH40wqu/s+d1w8vJdnhBOqB9QCHw5gRkFd2B+oZo1sSrZa4yEkPdzjgVARTvHi9U5ZVr79P1vMu2oPiUKhhzE88evWdL94aggd9HTAYpYk+xPbEum0MKzvoAxSMJyM+LoQ8QQ+GKgLT3iA0MdFz27Sz0YUPSfYzHLFhkV+gVLETIda17osvkrb1NkJTp+3q0cp0Kv8w5X2WjEluyD4sYL1wrlizs1g3ZzohYW+aaS09UdcwqhZCNhChFr+0IPcQXvjRjTsW3fTKdINbr2BSyMBcV6mzJQc0+RjZV79TfHXUjDoCypLtmBJlm2cWSj33+h7AjUS3gMNITnWR54CSNKWx8fPWpH6nMZLQNCkrzmeqdExV0pP/ytS6Dqb+GVWPgDKNnETLlK7haBaxC6MPChX5MjbcV0AudHP8PGK3sGrJ8ZgRom3gKPR5VKxMco8XjDB27AmfZ9Af5pvR2WwpEyaDD5RR9f4QsTUMIQ4nAyZq22cVu4W3O9jwgIykxlRdrl7ijfhmQ2NOahh1/9opz+1dQ8b18pjsTu6R/WfZMSxzTWpS7s4gIugoGoHr3npJ45jMjft/zVQw0IRo8YpcuJ1GWQpGrRX49Aw5VL6k1SoW5/stKJaO7AM239UYCA79Jz72AWZx/Z
 Wt5QUPgY
 FUisZJD0kJwBkR7RxjrUpDllXL+hANQlaZe29EvVUYQ7WTyotdglARZKVfF0f294+rkGN+sy0X522sR6pigCIOpa5FVj5r51cY1KnWs4zcxeAp1VG/g2jQfGOfGB2e/ACgWeGVDYhAkFCpLD4OLUt9YwSdcJW9IIVfEJCxooCc7dYExeMPIpBjRLq+tVKanCnzNwiHXOy0tUWflm8qWtoOuxHiZxQ7M7ZVpkJ/E0XJ0iDf20OfZqvspnJ6rGXaFoMe38k0TP/kezgoXeLOCD7lvPEspMiCBggeJB1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use set_softleaf_ptes() to store multiple uffd-wp marker entries instead
of open coding the batched setting.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/memory.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7ce8413a8117d..8c45fb25fd8dd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1737,14 +1737,8 @@ bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
 	if (likely(!arm_uffd_pte))
 		return false;
 
-	for (;;) {
-		set_pte_at(vma->vm_mm, addr, ptep,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		if (--nr_ptes == 0)
-			break;
-		ptep++;
-		addr += PAGE_SIZE;
-	}
+	set_softleaf_ptes(vma->vm_mm, addr, ptep,
+			  make_pte_marker(PTE_MARKER_UFFD_WP), nr_ptes);
 
 	return true;
 }
-- 
2.43.0


