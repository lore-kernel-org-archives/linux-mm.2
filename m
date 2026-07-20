Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0014C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 06:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD746B0088; Mon, 20 Jul 2026 02:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E0D6B008A; Mon, 20 Jul 2026 02:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893E96B008C; Mon, 20 Jul 2026 02:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6393B6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:55:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF80D40724
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:55:24 +0000 (UTC)
X-FDA: 85008243768.03.D553F7F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC5E620004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:55:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="A/+Oo2jx";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784530523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pX7v8kLWZe5YH1slEjXUOdncIrt7Dpu96dVtH7Guhwc=;
	b=5/qF/C8bn1OOY0vynkNxNZfsMD3RJEXD31sPgo/BjHvfEzXUIFhCOKKC5/SrFnymsHLBqV
	xc0VTJ3yUPhV3I0MO+0mHjuCgjty731F8WnS6dL1dKoFOB8j13PX57HzTjPs0MUsGlJEaQ
	91TQ4Pu+N1+PDMf3SXqcz3sbCZxMm9I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="A/+Oo2jx";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784530523;
	b=XGUdUDwF6wfpMS71FhmPpx68OzvB+kvor+AiMKzSYTeOMSy1qb8Yza69W0P2NaQYePtGzY
	aV6R1ejsP6/VMbWRvIQNQELciVxrNUAAZhM1uzEwdWbOV6ORme1kW5fk08PsrR09ZzjTYI
	W8KSn3tNdZvkLacHST8KFx7H8u+JGHo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86ED51476;
	Sun, 19 Jul 2026 23:55:17 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 97D413F66F;
	Sun, 19 Jul 2026 23:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784530521; bh=wkjGK8fRc2rGzQ942RtJdjvvUs/pTL8q5/SjakNwvrQ=;
	h=From:To:Cc:Subject:Date:From;
	b=A/+Oo2jxtzqkZYSDc6ZmDnBVnH1PMLfO0BMjJJFtyt9EKLEyBTqCnu3cf3l4Poe75
	 pDYMmZOyzHOl7lf+b+q78NE1oItDYdqlFRECRqvSPWAou3JAeHcHF9Objkw+UwwBdu
	 hm9HffNzg2FbhcGa9S/oWc2VOJ9ChCc4vbQSVYGo=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 0/3] Batch unmap of uffd-wp file folios
Date: Mon, 20 Jul 2026 06:55:04 +0000
Message-ID: <20260720065508.2695106-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC5E620004
X-Stat-Signature: z757ixz6gzsqtgnya5gr6cna97o4jg7d
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784530522-867880
X-HE-Meta: U2FsdGVkX1/1E7yFTUtiZr61ZTaAWlTA9U1o3QrU9/+XNE04dlqF/KqC44RWTrWHsdkaGONr17oYylcQkcO11H0japX6FkcPaupD1C14S9VvnAURRQekqqAXDvCGvpBA047ZYjvtAlDkqp0NNSh3iMr8xKZBoVCw50/+W/RZhNPWHNLpUrqM4jw8uldOWeiLmY2wPUCpRlHInHyjjReWrDfPdP4SMHYAB35+oF7H7V2UM9dGWsVMdDDubfk7dSbfGGv+frHRONnA3th+ITu3WulZOqkD/kSdIT15VvDrdgA50N1MMtlwP859V52CyXiCnIW3LD6YqWW6Z8KrQ3uPUxYNdilq1Tgh7kJZmd7cNDG0vhxne04APE8iqMoF+kBRJUqsxLKgLeUuq5+tm8K+Rg1VA/AZTs/ERt5sdYhm0X+tymh4Aq1DLcxDkBCXvhuUPrHWnmJCu2GjIulM/GZPc2ldico1uDbsfNLBuvif1UWqzMQFy70sFZrdJv5fr7TisCHRMnlwd2OPOAhRdNRsPzESGHNbfhV0iaSk+or0cRbsL5xMi0mrC3YkQ0uYkyNLpAVUUpqO3Z3sNWY1eGRfYyoYUSqJl5W0rLUFBwbi8OfCPzRh1eGKdjLEopIVrySPvgi7nfM08YnzZJ01ttpFmvHH8llefB4t77VcIwTDOZxy/YvgsdKJ5YILr2BP1ELeucYS+tn829ciW3JxDNIa8ENstMZdbG70Jp/s6xS8Re9RvaQeZZ0UJ/n+ixIbmk7UXAarKQIxPGwRS9fpFSDAzerxqM3CSwxqZevKjSFPG3etfPPvbNVWY813hWyCX+Q9QxecMvOnTHqq0yVOdz14u2p2Xhcf+YcieKLAYbaQf5cu3KP0MGaMhS8xJ6Ds66Ok3qGZOVuB+rKEIcyHYJjxrDJiIYmL4gM4tHKvu4SgsFGFhBqGG57fPMBXvH1iKLSM2GEyCRdBw7s4qkW4Dv2
 tKkoC39n
 hjsPhtk8dsE0JQXK96/BszSOQJ2Oi+wk8VCwdfuzvA1SL/pIPXyrAQtfOcDEMTTEw34VQ4VwyNqGgsokvU6+xpscDIuYGFYQjImwW7x7SM2X0Zqz9zx8QkQ7Gw60Eadzos8QEMieKS+9etOzOoqU/QTLeGVtOyRAjlErEHqIvX9rRfAS68sHZb2J1E6YvX/4+rETCH3E1r4qsUhqSH+JnbpZPDHc4F5dJo8WOFT0m+RelFq00FhTCt0gHxiijP1ACmqXAO5/ZO2WP6W4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, batched unmapping is supported if:

1) folio is a file folio, not belonging to uffd-wp VMA
2) folio is anonymous and not swapbacked (lazyfree), not belonging to
   uffd-wp VMA

So the cases which are not supported are

1) folio belonging to uffd-wp VMA
2) folio is anonymous and swapbacked

It is easy to see that this adds a lot of cognitive load while reading
try_to_unmap_one - we need to remember throughout whether nr_pages == 1
or > 1.

The uffd-wp handling in try_to_unmap_one is regarding preserving the
uffd-wp state for file folios via pte_install_uffd_wp_if_needed (for anon
folio, we handle that while constructing the swap pte).

Stop special casing on uffd-wp VMAs by simply adding batching support
to pte_install_uffd_wp_if_needed.

---
v1->v2:
- Move declaration to mm/internal.h
- Use two tabs for parameter indentation, use for(;;) established pattern
  for batch setting of ptes

This is a split from:
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

mm-selftests pass.

Dev Jain (3):
  mm/memory: move pte_install_uffd_wp_if_needed() into memory.c
  mm/memory: batch set uffd-wp markers during zapping
  mm/rmap: batch unmap file folios belonging to uffd-wp VMAs

 include/linux/mm_inline.h | 53 ------------------------
 mm/internal.h             |  4 ++
 mm/memory.c               | 85 ++++++++++++++++++++++++++++++---------
 mm/rmap.c                 |  6 +--
 4 files changed, 73 insertions(+), 75 deletions(-)

-- 
2.43.0


