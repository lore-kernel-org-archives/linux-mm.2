Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED853C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 03:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1331E6B0095; Sat, 22 Aug 2026 23:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD6A6B009D; Sat, 22 Aug 2026 23:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0C56B009B; Sat, 22 Aug 2026 23:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B80356B0092
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 23:43:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2875D1A0269
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 03:43:38 +0000 (UTC)
X-FDA: 85131139716.06.3D18C36
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf28.hostedemail.com (Postfix) with ESMTP id 68DEDC0006
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 03:43:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZtrRxKqv;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787456616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZX/O3csu16e7u2YujhVvxNnuWagxpbwnVSJpm7UbvMo=;
	b=QevX6dzr9hOSRLtjQ9zd2h55Db0ToPgN41wBidmbo3Cpt3KoxtMZSSusXJaFeqgI1ZNAa/
	2CxgOu6YVBQ4KXS3cY1Ex2efUsMWxZuTQM7nruzhoDYQJPfPzTRQ0Ps1PVs03RGgpWTrtH
	9g+1WF88oSexfbcPx0CJMQzW+YHwjJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787456616;
	b=AgHClLmzK4ARBWa9EjQM6bRH8uYYSKwLlvPXlmJTh+Oi/Dq6Qc7cErkGQSUNZeXK6OyOV5
	6Dci5FyY9YuFdjDwz1cQ7h1/pszpf9AzIz6ebe3sfiUmxTypv4EC7DJzWP0HXnyDBGNB0d
	EIPBx3TAalXZ+9p0stJv6f/Esg8IfQg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZtrRxKqv;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ZX
	/O3csu16e7u2YujhVvxNnuWagxpbwnVSJpm7UbvMo=; b=ZtrRxKqvrBmj2npo4+
	lgxnBQgpWpWmzv2SUWhmRuweLei/R8mRgNkZzfsHriLmz+1JrRb43dBFtqgjrh5d
	NMKZ0d3Z8dBwNhsKT9MQ6yny/gJd6vwAfpxmqpP8H6rSBTwARq9NKKtl/tPf1Hng
	TcE00JN6659HGezUQFxfW0UNI=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCH5exMbIpqBB8uQw--.11509S2;
	Sun, 23 Aug 2026 11:43:10 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org,
	mike.kravetz@oracle.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 0/2] mm/hugetlb: fix surplus accounting and availability checks during demotion
Date: Sun, 23 Aug 2026 11:43:05 +0800
Message-ID: <20260823034307.1072415-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCH5exMbIpqBB8uQw--.11509S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw18Wr4DXr4fGw1kWr13twb_yoW8JFW7pF
	WrKw1Ykr1rCr9xJr4Svw1jkwn3uw4Syw45twsrJr45t3ZxWry7Kr12kryUAFWxuw4fAF4I
	gr4jq3WDuay5ZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjtC7UUUUU=
X-Originating-IP: [2409:8d1e:e12:7fe:fc27:3a72:bb72:5709]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+A5rZGqKbE7x+gAA3w
X-Rspam-User: 
X-Stat-Signature: tt7b7pkceuj97eogm1ctidoiyeyq4ku6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68DEDC0006
X-HE-Tag: 1787456615-780752
X-HE-Meta: U2FsdGVkX1/kQbJcNrSomxUfkb+lf1z0FUjYT9fRC4HvziWUex0l/KqKLxxvMXMaazHdoHfhkjHrp7Cg3zNJxGTMD3Nnh81LW5oheA72rds7pDt4pKAvMroIuI09wcML4OATibmqSIcf6/xQGwB5KZpOhb4/C/RSTm+rLq2QPvnn/NtwX6zLcErdarr8khhi7rmT4cGa3BXjo0eBaUyalHPXJViaAOAbmnuptkvNmaVW3+Ze7ioK1hfw7Xqo1edDLpnAeh+vYWqcywogFpA+r6IOsfXCpQ4ZHPZzeqMjvwAwck2I890C8+UaB1zc6XaWtJn5gmjhJvqc8zaG47r1OZrMpXJgnxdptvXmC/YH9EJkLSVXlOYdYifgo6VzjfQFtq60vt15O5X/W6MgAsKuLrmoa+h9QAhM7anBbZYMWb6E23kSlSxCo0Go3fL9VKEDOQBiDoTMz9tmPfAmTdXrkfTahkQ/yIJrggVkNzSnPNBQFmUizGeb1tk2iMAIH9zw5svYOSmfzcl5giPjbEHxEsF/mfzEzcrBdEAltEJyHRwCBwraMH4Pr8igDOhnapgz6AkZXkaUDmMMqec7SLPcVcbCvd5gTEtiLBAsIbmWV9OQJMvHIzAX0ks9AGbHRZ5TUZs+imf1GojrXmmJU/y05raUj0GDmpWtJH9+Hq5tqRSJDlx2i1PDMxRtYigVs4+gZXHm8maHXsVp1SICZNGgr1VTCrtzgfbt/telGk98Ynid2wqE+2/4r9opwHIo9ywRkmEj7+kMKRNgquBvwTeo6RaCQyi3RM7Mcvpi6A3x7iPcsAavI1v+HzhDzHQG698JXkQ6Ee2Ic9YxM1ZgpXB0N0idoRN6BI1gvCEr6isDoZYKnJYdHuU7ze7df5AHwOH6AYSJaTcZmgVwLHVGMw6j6Ko2i6Afg+PicPc2SBpkLB/sInHFHYfXj/0p/7JYe6PMwaH37O1cRHR/4CfDFOb
 wI0xN/CW
 Qv91zONv3SFPmnUYjS0fPT7p4/Icr1sYJ2hFQOfESRpMoLctiB6FkyNdTIhLIs6YaZiGGDXrnYeMryCo9DpcOvH/TgdVYe93t5XSGLqPi+yMHaRsyYKz74AbF7Iub6lGKvL880uxvAcFtR3+ehKstyt64N0AAL8xKfQxHAqdjXUJm05aBgAT8w/YlGOVZXJR8Aa/u8IC4pV28s5eq3ORL6Oxr1bwOWb2P5FcQ5KVuLH0w7DaUY9vBToxdk9Key0oZopqtY9xM00B0sH+g/D5pyt/8U2nfrj8hQhF13s5A9lQnDPNU7YeJP6qeSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

This series fixes two problems in the hugetlb demote path.

Patch 1 fixes surplus accounting in the source hstate.
demote_pool_huge_page() removes every source folio as a persistent
folio, but a free folio may instead account for one of the source
hstate's surplus pages (for example after a vmemmap restoration
failure). Removing such a folio without adjusting surplus_huge_pages
makes the persistent count underflow, and later subtracting it from
max_huge_pages can underflow that counter as well.

Patch 2 fixes an availability overcount in the sysfs demote path. The
sysfs trigger checks whether any page is available but then passes the
entire request to demote_pool_huge_page(), which can remove free huge
pages that back existing reservations. With two free pages and one
reservation, a request for two pages removes both and leaves the
reservation without a backing page.

Both patches carry Fixes tags.

Longlong Xia (2):
  mm/hugetlb: preserve source surplus accounting during demotion
  mm/hugetlb: cap demotion at currently available free pages

 mm/hugetlb.c       | 57 ++++++++++++++++++++++++++++++++++++++++++----
 mm/hugetlb_sysfs.c | 10 ++++----
 2 files changed, 57 insertions(+), 10 deletions(-)

-- 
2.43.0


