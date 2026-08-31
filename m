Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF09C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0BF6B0092; Mon, 31 Aug 2026 06:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1815B6B0095; Mon, 31 Aug 2026 06:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098846B0096; Mon, 31 Aug 2026 06:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDE446B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:21:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75E611C1F92
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:21:53 +0000 (UTC)
X-FDA: 85161173706.21.7F2C68D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0E9DAC0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:21:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nadmiYF+;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788171712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yiR7x9/v4RMoVRI0sREa2O7du016hdua950VEmziwYo=;
	b=wkps1IHsXy4hc2DLNic59HLnLbZ7+6En2GEx/UVOLhf7/LgJ5t7wWDWWvNEcB7UF1FV414
	/V/rxVri5+DcIjQ/ESlXBlOKu93ktzxIt/gHvRn06SETD0H3vty0m1cbQzflIsRKZHAbFH
	WTcga2p4k7UfSUW9ufzwY7iNDWopYII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788171712;
	b=t1Xz3HEymGPZ63+uBvXNkd+vH7B76jrx7Ympk2DcU5Q7JZLxq1dTxHEw+qKYcJbGUgJbye
	KT/yqlmie89nx/ygQNdt8CGdLw1QxWwvEw38r3LJCpUtEuwL8FOI/k7uWkvf5lyLtze1uJ
	NQWVxLz/vaMxz/gaz76DfwDWi2hoSck=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nadmiYF+;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73C0160212;
	Mon, 31 Aug 2026 10:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F141F000E9;
	Mon, 31 Aug 2026 10:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788171711;
	bh=yiR7x9/v4RMoVRI0sREa2O7du016hdua950VEmziwYo=;
	h=From:To:Cc:Subject:Date;
	b=nadmiYF+WjxzCff8CEE9MFVzPy15iC/X3xVb0THTf7eFYTRCmRPErsvHK6wBkntA9
	 yLxm5EHTLTNsUav5UE62b5bCAiyXHMuiHtE+APe52/XPcbOPfdlbiKBWos1woglkE/
	 ZN9kKViEqFbxU80DpbpAW0zdKKubHvTFYYmvE1TVUI4fwYtN7qC8YDucmSg/TrkoRt
	 DhTj6cEvpSupOYeklNHxbqRpRQqXgHGUmcDOQ22wJj0oCyr473NQMxosJ8QkHiVhIb
	 NcvXKzjIMKI0PkvHrAbrMkDI4jWH/tDunHNonrGYzRiJhxWb1Hd/xl/NlHkKXLVFa1
	 aUix3kK3g5Pkg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update memblock tree URLs
Date: Mon, 31 Aug 2026 13:21:43 +0300
Message-ID: <20260831102143.69265-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i97eg5jkq6ujq3xuhaik5qpq6i4obeqc
X-Rspamd-Queue-Id: 0E9DAC0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788171711-577827
X-HE-Meta: U2FsdGVkX18Ac87Dr5Ltfb2WUvzJzZWKZA2n1DeE+E++s3ApPVqYdOIslphXxyLquqanhGGBaRiFK1ACtY9DZW+YPD5fo8ioQwRP9EpKNm2Gi8S6Hh7b1DnXBe1+xBnu38sJ4RctBZchoIyBULmmmjIqoXO3TE94s74FocPq5p+IjKwySyqAM3eYozybG2X1YDw7fYublabXJti4hKyKZUd5/QAEui7zGw/PHA5B0yYq7q6BZIjrouoXPmcVUvss3Y5OyCj4/ekY/fAABMI9HEV3zpd3JDdj4/L7ab4vsne+wrSySI5U68OmuJBDoLhuanKS28vJ9Q4u9oZNEXc6vgFOlzB88ElBRC0UIBrzIpC1z4oEz1RZVQleZMeIR6qL9sWWrZVHRMDFvmPpdfFEYwKIMucgH+iNbJ1ndeZXjloHCLNH+DboXClGaLfsbFgK6C0JmzZxg7x1VMEnWva22eOKdYWrqlXFsx8u+g7L5GRiZq/OMafEhvPdOjk0TsSlZWjQFuO6CuM3KGpZgpTPV972dKTUClF2lZCAzpdeL7iaOyz11KyljDdtwAAXk1UrvXbnnzaXz4+KY+HL+VtqW8ICUMn9RhX3OmAkemqQUfsp11FNfPB0QbKNqVRIIE4TfbtDcFUzImF9plp/V0XXYohgGifgIbp2Iz4SYvIMZm8RJbHpx93aFRUS1gIzPHYzjy9lrtRmXmaOX7rT8WIlaIq7iZFK2ZI3RjtmVQBG9V5JTwCNEg29rX/wLrD8FuQZQe216rWCq7ECiTVxsLZvKR8RONn2hYiMZtU+ulcoco1TvkUuS+cmKvBXyXOplCtNtrKV7rXiT0m3Y6rcXtjntKwT/YXZmkKVqzl6msAEd57E9XpnBu0MC0oyDcLfBPIPo05bKhXZS5B4vIuOoJTLhDeHnXHXqpOBzbz0vqT/+KGLe9Z8NW7u6Pqoq7dlwR7sPXW4o+WBnyAw4SNubCf
 5i5NTD0Q
 cGvmxUhtkojfUxKHAtHpfsQoIY7tuEMOzzTUSXBEeeUzKtqsZdzylwJAB/nYQOJVUX4mwfhLYCxl13av04z6pUjfKOGhqnABke/4Fy/XpXNW6tKL6vu4rx0pAx2lnbM7QrKN/hJElVAlmsIPeqg8g85ta+/ONePpYVZTHCe9FPGZ2K41ZluUOX1l6tTF5xPThK7yqd8ntrR1fhoAZWhsBQV6YhGcyJb/A9SnDmuJHxyXtSfq/T1YI0DKsHJitYuyg+zRQl5t5tcQil6UA3Gov1zAqEWEn4QHnSYHJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

memblock tree moved into mm/ namespace at git.kernel.org.

Update the T: entries for memblock to match it.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
I can take it via memblock tree if there are no objections

 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a19da74d00c9..1731d197c33ca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17036,8 +17036,8 @@ MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git fixes
 F:	Documentation/core-api/boot-time-mm.rst
 F:	include/linux/kho/abi/memblock.h
 F:	include/linux/memblock.h
-- 
2.53.0


