Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EEBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C7A6B010B; Mon, 29 Jun 2026 12:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE016B010C; Mon, 29 Jun 2026 12:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCD96B010D; Mon, 29 Jun 2026 12:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 361876B010B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:30:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5ECC1201FA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:30:44 +0000 (UTC)
X-FDA: 84933488808.13.5D35745
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf25.hostedemail.com (Postfix) with ESMTP id 966D6A0010
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:30:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=OtWOq4ik;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Kgkjw0VN;
	spf=pass (imf25.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782750643;
	b=jcqeOAmmbwiHXHUswc76WdGSaHrimMWjNd/FThDRoFOhlga2p0vcghNspRbEAi8Zm0aOgI
	zgdyLKsVUFLZRe8SyAQe50F8HQO71JHIVd2+sVCnNtbwJc3ECuk+RmDZw+zsxqk1WO+S7b
	oeGXj/XBikQ6qB/4XcUDCkOSQkyoY3c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782750643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Izq61Gfdmn3fOpPis7spxvMBkAhgZwLG7r4XL2awBrw=;
	b=1AqYg1/a6AKAU5hTRUnM0c8UZ96QM+hjqBAv4Aqvtu+5cSLhPtfGecJyfjsSdxuddMz3BO
	8YF/B86Ycach4eVdaJcW02IaIiQAyrqgBVZZVdc2JCxCGJVl3Qdx2t+8+QntfYQyKBlO2N
	UnpcK1VZZkGN6DnT/FGKwiR5Hu6lSpE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=OtWOq4ik;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Kgkjw0VN;
	spf=pass (imf25.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4gpsG746ZCz8twN;
	Mon, 29 Jun 2026 18:30:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782750639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Izq61Gfdmn3fOpPis7spxvMBkAhgZwLG7r4XL2awBrw=;
	b=OtWOq4ikRWnlQNisfymhIs5JPXrTakP8Mg8CD77vjkcHqNglAfXYhg0diHKDAaO0A5PQ/w
	75HPUyUPp2nbY+mNXGGyyQzn5BH9eulmyLEHbaCtSoVazMI1S1g+ZQrxyZJeL1fzFQPcLg
	X5N+nVIyeDIaF7t2o2YKY4wXEP9xiSCIW8YIdoO/OIYSWEZj3Dad6BHWyrF+dXxmnvJZ45
	r+AjAvJScrNP05b+BLn/ja+y8RJsyHJxE5zg5K1jyfrinb3Mn9aTXQYKbuqsCjJL2zeDfs
	w8GBenccIg0/rukbTDWOqIpySxGkteFqSwLkkHYqt00crGtxGYge7O0NGXYtUA==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782750637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Izq61Gfdmn3fOpPis7spxvMBkAhgZwLG7r4XL2awBrw=;
	b=Kgkjw0VNjm4POD+1QDP30Qb9vp+eCLS0MYEjOlIORof049ernSl1uaP+F0lI1sVWC0GHDj
	yc2TK9Zn4rjsnyRkuzD6eVw8XDc/HWwqmc3vRf7cIygcsFQOX/uoYRPrYlR4SD1ztiaJuT
	NHvqinbzIBACoOIwuBc7edvKzbuyYklpJ4RtX+JphgspzsrqgtC8/Q5bVri9oTEOP6D+JT
	cajlxNa7stxeqZ5xMcdVerq39qGkN8z2gMzct0XL7qwiHQuhF077Q0UcV+Boq2bD0KOb1/
	EHCyHhjmDq/B9B7dc+CIcMLfBQk/zlJzDasYuYVfaTuEK+ytuXBMiNQRHKDifQ==
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Manuel Ebner <manuelebner@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] docs/mm: Fix braces
Date: Mon, 29 Jun 2026 18:11:56 +0200
Message-ID: <20260629161156.90213-2-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: ccad1faff904b96f4ab
X-MBO-RS-META: woghhkiocwkn4d56kdjf4ot9xkz6uyfr
X-Stat-Signature: esjxnhhjiimaeqbswps1i8xhuxgg5gnn
X-Rspamd-Queue-Id: 966D6A0010
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782750642-175353
X-HE-Meta: U2FsdGVkX1+myKPWt8anlrMahgjePvenP1XSQTRuvOtm4zipcs0ZW15DW1mVr8uuUWnOxrD8bfhA1XO8Iq4fvrW+y+b1i2jgy/EMHwOkTHULc/oPYlqjCFpKz650yXsgwwa1Cp1aXi+PO2Amm8Dhgwl4barpPUl+1aNUAXDf6eJYDhyA3hqPWq+A5ilm2pIi6hEjFOyfN7sEg8n/B//JKDpPTHQsAShS8VjBs3TnQkQEw4hEVzo/FzP4pZqoSpazAZORU5A3E+nXfY67ui/ApPQIoMSQQsO3vMSrki6BaIa+PNTv0dJ4vCg5q652bCORgxa4goKZYRbGELBGTEepVoZQv5Jc86vGwzTTqD2NZ+arY7U3RWsxQslhmqack8309ZBFQxJ73lNe3/VdIjSZtqK66cpW1Uff0gHxu9tf9RqqmNiWZRTqkBU7bm1MG2pdak/plvwRaUJzA1EhRZhVFs9DpoC39ujmb7rCBOEVWBVZ//XCVXaYhLP8ydcOfOphH7jdyY+8uxus1BvCVCls97oans/uUYuczsQyK7bh4w1i6tViK2s9wSssUi8b1Ru4POjA9PsMt11fCzNaIIn8tUJ0xNdMi5T0pIVpyRNm8xGrPL8bbYpkoKB1AiFh+EzlYUee28dBM8seOlHHRNVarqe2X8g7Rz8OUup8NHsZBRIYUVPqdE+LYlVC+LwG01aC9313iVtIDf2oAn2JTv45YmeDImOp7gyHz9F7yIegH1z4kZLZuAHtiXivKA+kE6RmD8nxPIukMSbwaTf2JHd2PqJMKL4u2w0N3YSpAj5d8m5m3sUJ2FRHhwGzBCCEuG1faoVmaIsJnIj171UPSEVAfq/UL/Tv4juKE12IQVefxh5PquYzqIqC20fFs6fpTNDIQrNuVOWqLnrEADb9kHRQ279/bqNWmYUc5b91B2RtChC83Qi8rjcu8TD0NJotIBf72obYO2Ve25mMAfvbkiU
 Pfs+svNR
 edWnvh9mCVvHFxcIwSIeRYGOH4t6sJHfuXGxfSSdMJQmKuctFcVZIMXwrqjBJLhSEsqmtGnkxu6hYZ3NthWMdeVc5cOJ71x3iDh/4Ig6J+UePSKtSG11AJ+glFzM76TReObXGkxsjNHbXAxdQUYeeHfbrFayLxscBtpBB+HtBwieBC482w0TCK3/gXFgnNCOW8erAHk3uNXtnNp8xXqDpayjpGbLFIX6WguhxR3SPyY5vKTZeGa40y7Ux8m5f/tkx7VOo+aN+gj8KbFh1Z98VWcp71CThPGH2xeKa0kRmszrMNwtK6YhrJbTcX2gBFqbueejSbFkkxqnqAUwl4PudQDxB44fZW29OFmG1+6fkf9+JDGOmn77TVEwpO9CEI0YKyoIwLMEPUfmR57cF9R20hv3/VhEZm0z0Gy7B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct typos in mm documentation by balancing parentheses.

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
---
[v2]
 fix commit message
 add tags
---
 Documentation/mm/hmm.rst           | 4 ++--
 Documentation/mm/process_addrs.rst | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 7d61b7a8b65b..54c461e7a143 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -191,7 +191,7 @@ like a CPU page fault. The usage pattern is::
       mmap_read_unlock(mm);
 
       take_lock(driver->update);
-      if (mmu_interval_read_retry(&ni, range.notifier_seq) {
+      if (mmu_interval_read_retry(&ni, range.notifier_seq)) {
           release_lock(driver->update);
           goto again;
       }
@@ -316,7 +316,7 @@ between device driver specific code and shared common code:
    system memory and device private memory.
 
    One of the first steps migrate_vma_setup() does is to invalidate other
-   device's MMUs with the ``mmu_notifier_invalidate_range_start(()`` and
+   device's MMUs with the ``mmu_notifier_invalidate_range_start()`` and
    ``mmu_notifier_invalidate_range_end()`` calls around the page table
    walks to fill in the ``args->src`` array with PFNs to be migrated.
    The ``invalidate_range_start()`` callback is passed a
diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index 851680ead45f..b391502fbfd6 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -724,7 +724,7 @@ the zap and the invocation of :c:func:`!free_pgtables`.
 
 Since it is assumed that all such steps have been taken, page table entries are
 cleared without page table locks (in the :c:func:`!pgd_clear`, :c:func:`!p4d_clear`,
-:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions.
+:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions).
 
 .. note:: It is possible for leaf page tables to be torn down independent of
           the page tables above it as is done by
-- 
2.54.0


