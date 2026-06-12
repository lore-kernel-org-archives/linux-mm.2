Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244BFCD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1B76B00A2; Fri, 12 Jun 2026 00:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372806B00A8; Fri, 12 Jun 2026 00:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287EA6B00A9; Fri, 12 Jun 2026 00:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 167F96B00A2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:45:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A867BC1BDC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:45:02 +0000 (UTC)
X-FDA: 84870020844.05.2374EB2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id C2B42140006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:45:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q+ywobdJ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781239501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOOCtXcGKd5JxZcYNa0CCaNDWtbGtVPpAZnPySAOdUY=;
	b=JwCVl4cq4xJcTQEn5dUvUA03OqZgyja/i5zeelRuHd72dXSIlUE0rIITlAfIEzQSHivPgp
	RzJXbs2y7ZrYLhCGF709aXlXogaIp2q4S7naUc5ILzMRz3CSmVQIIDDGXsBSiab6DYgMJT
	AjPU5SKae1t6Nn0OyKyfX23SXNSJIHM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q+ywobdJ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781239501;
	b=2SWeoT7Xqy5N6PPhNULkGCKJ2xkit6mWrbVziXMbkNGDoD6vdqqTXIwSiT6rrrjgAQphFg
	y8T43tjAm9q8vHzQaEklAvfMOHPX8/EUGTjJk42A01LgDAkwXia/Ty+5CR9qdV+EAar4qd
	984x0PFF4c4K0V7cCnULISROcnh7Sxw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C26E2E91;
	Thu, 11 Jun 2026 21:44:55 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2BAF13FAF5;
	Thu, 11 Jun 2026 21:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781239499; bh=b00TklBGecqQHLra7PJTRi5mE5kXZpjh3sOy2Gf7YPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+ywobdJtIBtiIj1Lm87NJAvMg5U5ZyPO3GOiZE5j7oUMWa2LPjn5dzWP/UcvIfsR
	 eAIppw1XHah98pdVj9WRrylHYixsfy899jM7BhUXauI0syxEiAplt27uUuk/UZ4Tct
	 1rn0H7QLZBrriUcOjns9J7XKs7UrCuhBG1BRs4Wk=
From: Dev Jain <dev.jain@arm.com>
To: ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net
Cc: Dev Jain <dev.jain@arm.com>,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	kaleshsingh@google.com,
	21cnbao@gmail.com,
	david@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com
Subject: [RFC PATCH 1/2] kasan: hw_tags: Use KASAN_PAGE_REDZONE for vmalloc redzoning
Date: Fri, 12 Jun 2026 04:44:23 +0000
Message-ID: <20260612044425.763060-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260612044425.763060-1-dev.jain@arm.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C2B42140006
X-Stat-Signature: rora5iazebqgsuoahw95cpfe97gn3znj
X-Rspam-User: 
X-HE-Tag: 1781239500-840396
X-HE-Meta: U2FsdGVkX18df/5Pdl4D4xTfxv8b2+CQPx7JbrdQoTWmGY+mexGr38uSu169/gYF3SlLz0rEw7+Bih2bVq6tTLH169gnbwVDXqVFX8cDNADYsAwpoxCo4U2fPEesq+HFqbFdd5JRW6GjTfd9vHY8K+4TOB6iAiFUB65C2i3jRLwcnrGjLgFt+FphX+VrIc3hIXJvT+1unIycmYa356gFp5yNBBffhyHu/R9wJm4ECenLy2yMIJsdcEvF1yHb1g63T7ojmQU1JvBh4gmtnvcY1k9mSx93m6/OzQSoKL6w8FPVN4NzRBfmKGCOe0oL19f58+0Er4SedYpBBqrGc2qopuA8TWJLnB+O9dkYj8ig5aJtcJG3Gy3rTKBe5kJZMQ7xRmo8gPEZMxh5heQK5BBMOb1bi+pujQm/kf4bqBOtzU0U23enejWZKWjqYMsGoXZJlm5EJ3Aph/gN7aNcC8cK8MOnFFAWxaW+m9SGFMujnKzaEHBjRGqO6zaUnuYV1H7pxiXT0qx2+bIMwHKZQcPV5WKujAO5LpE0DGrqUt/NR/h21y7wZLcUw+v0V3vAIta/V4l5K9PaGtLAvhsPvtcPnlQSDzHZz8jyMC51VSBJQJ3et1NgYFSyWxO9DZ9ECNKb8SOdIldHfy2wBid3oAuBNJ9OUGkcReBCWXT4wd+WUND2P4YpXye1g76GggHWvtFkNIikX/nN6C4HW5XEL4u/WTAnZtcWCMSVJbQkTrB+RRu321zQOzJLg0UrvYdY253vHfvbj5pBD7YSHs3TBkGS/3wnugHmZmkJc6w/9d5jPJTyWfIEg+Vea32kmx3nPeXac9oTA1Ej0lbXwHaOPy0c58/L65S0T8efEgR78RuJMy+PsnoMcSKsgO0uKfPQM5c2h23pxk4H1DHBUxtPZvDrxts7sInrL9bPHlr/3yPFq5Ngg8wU2QRMAF/QzhY0EPzZYRVtCtCMDbAYENSfgwP
 T4AwCPVv
 UrfZN/IoFgjoMvkvVK0+ED1zghYHbdrNFgW9mVfH41638cHeZDTxciY7ZOca2WH9WEyjwk03Mxnp1zeYRBsOOkenGTCvUpli3c0OBUZvUUcQHauZ2NrwOOMwOm4d4SmUsDYr1U3OW4UFoZWjtJkUviyT0WSg5/2lBJbbH00iInLzrDijo83rJrcJm+6z+MDxhJX95P5qGLi7ySqZX64RADDcBOHa0OJ/IgnyVCf/lV9AvbVo44NsZvN7Zc2q8mWyZm3eOgbBSHQLDOgSJEW+PuQhwQAKDC1dPr90X17s8XQvf++wa5mLnQuOtmFcWs+awFzMk9b0dnjfOOYA082PfiPV3OBIamJb1wxqX79ec9wwZqRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for adding "tag only on alloc" boot time option, use
KASAN_PAGE_REDZONE instead of KASAN_TAG_INVALID for poisoning the tail end
of the vmalloc allocation.

Although both values are the same for hw tags, KASAN_SLAB_REDZONE is used
for poisoning the tail end of a kmalloc object allocation, so maintain
the pattern.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/kasan/hw_tags.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index cbef5e450954e..c1a2b48808ed7 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -375,7 +375,7 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	redzone_start = round_up((unsigned long)start + size,
 				 KASAN_GRANULE_SIZE);
 	redzone_size = round_up(redzone_start, PAGE_SIZE) - redzone_start;
-	kasan_poison((void *)redzone_start, redzone_size, KASAN_TAG_INVALID,
+	kasan_poison((void *)redzone_start, redzone_size, KASAN_PAGE_REDZONE,
 		     flags & KASAN_VMALLOC_INIT);
 
 	/*
-- 
2.43.0


