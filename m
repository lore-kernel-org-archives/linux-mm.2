Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CBF1C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 09:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660756B00CB; Sat, 27 Jun 2026 05:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611A36B00CC; Sat, 27 Jun 2026 05:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5024C6B00CD; Sat, 27 Jun 2026 05:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0426B00CB
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 05:34:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89045406E9
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 09:34:10 +0000 (UTC)
X-FDA: 84925181460.15.8AEA9D4
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F5CD40010
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 09:34:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=qvbKsJjQ;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=v7B3S3EF;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf27.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782552848;
	b=MjEj5ThWFxmYpNgOFw43jASTUeaOXT+BFElP84g3ugjESWz9K5uA52FmvX0ieC9FkRDSVZ
	7C5DkEm/J/TwNJI6KDm6iAiIP3Lb6ODgH8SPINOVQphJbotrB2hRp24edNCinlQrICFH9T
	iaT1Esvwofmub+eMlFOI6DoTFWjUiyA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782552848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YlWKjk2m93Y20GRwWu83QevunbPgZPbwOz1dqg0rweU=;
	b=cfiokRJCZlQf9vMYxrdRp+opIFrTqzqkqreb8FZo3d2fSRWiFypZ21Kw860Fomf4Ylc1e5
	PTALkkQ4+GUsjkhQ0ZneKUZY3eKc7B2GUaaUZxs7C0MgM5NBT7Kr7KMaplolLzAAzcvLEs
	aIX74FIAfQ7mfSHvzuvpX1hilstoWsE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=qvbKsJjQ;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=v7B3S3EF;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf27.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4gnS6P5xX2z9tkC;
	Sat, 27 Jun 2026 11:34:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782552845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YlWKjk2m93Y20GRwWu83QevunbPgZPbwOz1dqg0rweU=;
	b=qvbKsJjQ/Q1b5F4v5ax1na89TuxGq9hkvDlGOOP55H9yQN1XBSSIICFzEVjRC0HuVQdl+I
	vvLztHxXcJd6l1NUUe5xatLUN+fTy3HQqo7F+kMWTeLRsmtkwcGFKj5PAhYO1csCr7zKsB
	pbN+yysQDmg8Zz5qLRptP7V+OeTK9PWehVSKY6/gxqw9TOeZuG//Lx6DGTM7plmybynXE+
	yh3G7L+umtlmR6Ch4D3Dm+VuJ1aQSm5Fle2mdev6fHQ1vV4MGyzD+X+E8+So1NSrPbrUpu
	hERCmKlHJSCUlUbpWqr/vjWcvOpm2cPpFjvXF8ryU2yRhi9rg5VnSjReu//x0Q==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782552844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YlWKjk2m93Y20GRwWu83QevunbPgZPbwOz1dqg0rweU=;
	b=v7B3S3EFx9HgRlGsOBCEhXFOJoUxvfQHyiZC0x+yw+/SLqv+0AGZRoS5GR8lUda0BWkcQi
	of4zz/zY+WzzC/ybphi6qUfv6Yg6n0kc8edUKzbikU0SX2cV0lFQwnvcr//7bkTKo+ywDu
	q2V0gBlEqPOmOf1GUPSH7wf0yTNfFycuf+Xg+AymztVWAMkoigPPfTN3tQ6nJ+r/naZnux
	6SzN9oLUIaQwoXLaeSk/epwrzaKF+RlPuw8IoXma5/LxIYZtD71yo72/qs1OX6lYAiAlwM
	9ovXyOq6FlKZyfGwjhWqSK2QxGgOlabYsnr6DD1onvg/Zl9uUp3P7KzTK99N9w==
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org (open list:HMM - Heterogeneous Memory Management),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	linux-kernel@vger.kernel.org (open list)
Cc: Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH] docs/mm: Fix brackets
Date: Sat, 27 Jun 2026 11:32:59 +0200
Message-ID: <20260627093258.31265-2-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: g9h6im1gwqhbb14o9nrdfej744p5ujkd
X-MBO-RS-ID: 2c037404ca6d556e29a
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F5CD40010
X-Rspam-User: 
X-Stat-Signature: mz5d9mas8b9ku6wehzophaps7oghikxq
X-HE-Tag: 1782552848-434793
X-HE-Meta: U2FsdGVkX19Wn4pHaHm5ID+7wBsx2yxIo11v6QHr+YRe8PlhO6HP8RTJkqwZH+za052wClI41ASCoEAQNl6eq+IEubX6Cr1J2fY/cJxjW1K9abXtwWjoBb6FzeZjBKywFnIaAdwAIz6JW+u3bn9lyDjPc/SKR0Yr9J1aWGZkqzv5zg9s2G53MthaE3MsBSlPVTowh+0yyshvj10+YAU3pBLwlyO5kkuNdGtxUaOoW0XMgcDSrzp6n1EIBt/uN80g3HyuYhytsgZuBU5BaH0P3pKERmubxPICD+EyJcWZULVXjRgCHvWXQR7+T23/yYhLQiONvTvLg8sapVPPwhqaMQq8ZYvXHFFeNDg5pP2ZueL8dq81yHybQfYs4goDgHx+hQm1vnve3jBKbsPtgXHFCSYaUCJeV0UhqWTjT9xsHho9ouzjyH8BFvkcFg8VxRb8dKGYKbV/+mm+hWAdTIhDtUDwqfL57s/5WUp9jNtd0Hluy3DdmkSdQCB595FUHGBW8iN3EGcu+YVKNptUK2rjrqJ2pFrYepDNKbOLrcC4ZaqGWugIvPxCQi+PaIJ5UwN3rm0MEjQ2xaeIZcmqoKU0twyNMMaBo2jojho+Ua8FKezzegKRIhTRVnMkp7LU/oUZXrjj5cFLfrR0iOY6l6PhcJEXVV/7rblROvPx4dp35lIM9xDf/mPb4OAr2WQ4Aec57q0WDv83RftNTmIljRgQbBW7/m0qmITx9Klu09iia31MAncOSJgNfUnqfloG4rbJmcIZP+QWX5+bqptnBS2+rDSKXiFNTFvp2Db111aK0SZsfox4MZzB4aF7Ziz0kDXivN29x/d0hWNPT/3zflA7lbvBoo5GVDKluhRHEj+NDFktqXYRJWHwNXYeKNFHnbSxNhweMCVzNgY8d+Z8LWWhN8ZmwJ4YPO4T+tzlbzxw+XN+ibpqOhxPkk9VlqQkQIlr9g8WzuozwBpqLb7oNUE
 7nnlAQzH
 fwRSYfqmWE4H6VhXWHQK28b4qTcgWeSd7S794UPyRyO6uoImH8YnFqVOcOZMg44mgijR0H4+jrldLClbXjk5S0yGABVyzguO81mIXrnJG2dmXxMjMMHfweQwimCLRp3A9nUgCW2MuB3oLb/RXgSOa0ngvDwEP5saevg4hP6JqhDFMSbT2CoiTRPff7nxuwixRqPMpWnEBgr3nXXWj0iyqHo1m7UF7bcQDon4HVNR1O0wXbs7rJ7y+Prcb2oVMPhBQGrVqJggkjFZEJiZQ8fPW4dNpHinjd3+DM8bSddmbb6upm6pFHvXxZq6V90fdxhbVRtm5lVTDx651Jvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove unnecessary ')' and missing '('.
Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
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


