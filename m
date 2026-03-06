Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24901F01823
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896A96B0092; Fri,  6 Mar 2026 05:16:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7E96B0093; Fri,  6 Mar 2026 05:16:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E48C6B0095; Fri,  6 Mar 2026 05:16:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56BF06B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:16:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23CD9C1E5E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:37 +0000 (UTC)
X-FDA: 84515234034.07.E277D80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9245B18000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sfMFKTIS;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772792195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4QAwrW2GLBTtbMQBlpjYhRh1mC/IWhMZm5cbOWtGeM=;
	b=Qu7owRO/luqh6SCVAsRIngVr6vUMf4IbKYnmguoXteKPSCd6f33d0PB2oSqWhorpXoANUB
	V/7tlDx+nAFQVCE3rqPf37IZcxvY+B6TCJvFARe3qEFbBQeD7QLSKuf6xlYjQ5GMEPJ+dM
	CFsCIU+8KoDMh7ttRkJaFjoeX0mSEuY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sfMFKTIS;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772792195; a=rsa-sha256;
	cv=none;
	b=ieB9th9Z/TwTIkfcgmPPJI3Xn7YDu9LuMeSYooCjDGbogwU6ZvlQv6fwwVdS10R35YkCHY
	6G4sfqfcL6+nb7o8i7ik/QJcpSkadMePZJNZaOJZgY5mlJWLPDX1gfUBUrjp5As4lfNK/4
	LmvhUp5yKj3jfjwZev931IAYSWxkG6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CEAB60130;
	Fri,  6 Mar 2026 10:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D250C4CEF7;
	Fri,  6 Mar 2026 10:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772792194;
	bh=ltugaujY6fYQ/bBQe0co3tDjQ1T6cgZ91J0YQTonPoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfMFKTISWy6XmE2PIb9BpEGaudJtZSFT3m04+Td9Q5T7Gtl5odhVnpSKvAaWekMq5
	 YHbT6av2ZV+y2SZEABL2S1pqe2js5staTWbWCHUQ4B7m9ij0IMohuU27s1qBBdgbPv
	 /xvSBtXv6lHzyCRnpv+esgazI7+0+/ywXmzcHmgMjvA3sRdXUm2hLsggmuK9Ra3vRW
	 01wq2YBeDQDBfoijNG5nKwFgIVYW1Tdu+trdWwEzNjdxxjyrd/WSFkp0EGvSNT+xvh
	 NuY+Mjb/VVLtIe/Vr8TymfRbCZjTQbk4VUHJmhMxLi8b0TxsdAUHDe6yKXN4FWInAE
	 fumJUEFoLAn4w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v1 4/4] KVM: PPC: remove hugetlb.h inclusion
Date: Fri,  6 Mar 2026 11:16:00 +0100
Message-ID: <20260306101600.57355-5-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306101600.57355-1-david@kernel.org>
References: <20260306101600.57355-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9245B18000D
X-Rspamd-Server: rspam07
X-Stat-Signature: cjasg4grn8b7yx413j3x4ycoorqsc16b
X-Rspam-User: 
X-HE-Tag: 1772792195-616864
X-HE-Meta: U2FsdGVkX197cwhrugXIA8V/8t9ocX0s7vvjkS1REIgc73KjyvRaR1ZE+XasfODkWmROS9Zu+mNyiG8rOoPAj+slc0J62kkowFIiJR3gQaVC4tHDzmpB/41xRVlndwqPL60tL8vILzMCZISAf8jT41BSrK3lc8MXaWOLCsQa7LmTBMIYJoaU3A5Pyk5YUF9EYSkxAO4Hw2aX+UHQNy95TjPBMEiWjvTz9v6n+n/lJZYmn6K+vjHOnbRlr209eM2rV6g6NQkjQ2rKgahvjzvBzmriLurQbW9zlJQ47tZ1KV5QEK6KRxoNJGgoafC/fpwoZbZUPRg1alHw//nUUBXBKt9RHb976PhXSoTmcdG2Ts/CM/8MLyOjZ70Yd/kQ82JxkA+gGgAbK0wxuNRLcw664QC0TmEDiO8wwGTZKOW+O4TzZ5Xod/VSgmMoN7Xp4yMKXPN8Y4gLaexDX2vfGYcRN0tMOIqzFuoKpz2e8wpRD+KGM0zxgnqS0TFJYZtJxVvkg0f7awrhK/IBRHXN/wbdGrNW8Q6dZ+Hwak0DemrVwWSWFEZenw3YkePNOh7wuzQHdNHMAhjZn8lu1gYToR6p1khQ2AtZE4CpfldQywMYfKrsFe7c/fdSEgSu5opFPfXMYAX2l1CZjCmzoIkmjYxsZI1Fpaprj2fO4lhE7uauvl4JrQ3/PDb7nrjwBrWHs3iQTqWm7NbXyCAHKM2lUx02SqCrp7TIwxZYvghCbcsD76JwIH3Xab9YMfTW5oSBSkQvEzrMVXUBM4HUuAzikbONo6WYaqVXoYlo078e5xfMC4rqusS+1dKdzlNbRkJFBpz4BRZi98kQ2WoQzB+bozEEJjiOrsA+2hlWHPcf6VZnCRvMRZuLMFdnRyJ6bbV+6QOb/Wvv5cUY/sudUCAeFsr4eisHMF3eUllnt/piNHJeTWmgvPkENI/S2M+5qfMDx+RHYg+9qAEU3xCk0Jb646t
 ON8WgQwk
 UJdM9VzFqrT33vgNlJuH61XTYI178br7Po2T6MJEU2zoUOKJ+DhHY95LSvfGJNkV7Y9QbZitv0klmkP6Ent4r2I6mJPtx99aaWPyKNB108+TReK5TbzGDwgr+IvG5qfe9ybFQBj3ENPK6lr8Sqxy3TuhGZkwWU61gAS6tDTP3JSDy6tzr4blZHBAMG9D/t8QBtTk0MXiodLIIkhwmLvuUqrNF7RXmJKE2RNT/dDHgEZABZf1cNY1ld447b0L5P0g8r9Cj5zrgjhl/GjpsJ2ttwY5dhTuGqYezsz4HCVOV2sXh+r0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb.h is no longer required now that we moved vma_kernel_pagesize()
to mm.h.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 08e5816fdd61..61dbeea317f3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -36,7 +36,6 @@
 #include <linux/gfp.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
-#include <linux/hugetlb.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/module.h>
-- 
2.43.0


