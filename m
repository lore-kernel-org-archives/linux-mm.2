Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC09DCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 20:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980F98E0002; Mon, 10 Nov 2025 15:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931D98E000B; Mon, 10 Nov 2025 15:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8244C8E0002; Mon, 10 Nov 2025 15:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70E438E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:32:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BEB95820E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:32:15 +0000 (UTC)
X-FDA: 84095844630.10.3C84531
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 978F3180004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:32:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VDVYayGQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762806733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=d49RAnDdJKPql1x4hnuUx4+e4IRWlHWKbvWRLXEJ1gY=;
	b=x7PynWR5B/nJoUPCh3vbyyhOyWLM5WtvYLgr8Sj0m5fVinojnWjsI9zm/UA9o3EzGCpJXS
	ivwQKv6/mA4WOFB3gHC9TVchIFQGoaGP8iaVp4BKnoHKQR50dtMJuHREmpXaOMscFWhjKF
	Rh/iDo5N7aCKQObGPcPLhCLIDmUvRlI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762806733; a=rsa-sha256;
	cv=none;
	b=XA99aAAPwJCeU8SD3tKBX4hHYkus8c2K+sxcGXCgVhqmnrTzVD+8Mzh2MFpbWW1vM0Tz5L
	dG9P3OFMOOj8GGctpVL5vBoSErU2FrU45YqmTP6OABFPbZ7W+hepGleYS///vAkagfoFsV
	wEFFm8D7ymbLY+vJ+drBZEgj1RU58t8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VDVYayGQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=d49RAnDdJKPql1x4hnuUx4+e4IRWlHWKbvWRLXEJ1gY=; b=VDVYayGQ/ZODGa2QcaPJOq9ALl
	CG/cNFarWMAgJOBrTeOoNx8iZVuoQ9lgydWZ1EshAQFPvHxlT2gStu4fTXH3ItT5Xfq8kCbXZYkYS
	Qw3VrQMyeUJHPc2uodJIUSQFDkWJZDjszpxioRQ1B4I0nBuaTme8KgSffGvTVdf5XP/a3uoiROuN6
	MEO11YGw+ehkOPrx6pBfGNDZO32e03BgtFqR7v190p7JbZgE4q6VU59BDv1ZbhLT44z7GxUgIkQLD
	fYuVBLCPtr69m7bY+NG10ZIe5QbyBgdpl0/39aZpzP202cEDlSNIFluLjOiKB3wS/EGylzEpl875E
	4njMCKdg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIYYX-000000066KL-1sVr;
	Mon, 10 Nov 2025 20:32:05 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Chris Li <chriscli@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v2 0/2] vma_start_write_killable
Date: Mon, 10 Nov 2025 20:32:00 +0000
Message-ID: <20251110203204.1454057-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fqu33h15rzks36mg5g4aptcgy71xu17k
X-Rspam-User: 
X-Rspamd-Queue-Id: 978F3180004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762806733-324032
X-HE-Meta: U2FsdGVkX1820RIk5em8Nkh47eIXB8cyql7aejlxHE0i6bfiB9IOp1HvNm0gmHCjVwDBlGr5xBr3XEHl1ciIh6j16wwvFmG7EI7ytAI7rtDvx7b9fSC3HvnsE4C3Yo6bbrnKiyvuIBjwlGHs+c/3FQ7mH9OSPaSGC/zdj2nHBdR/V4DbDIMqFOiAHqx0IqxI8UqkrzWyCxMeG7hH8y+myaVv3U1kmljNk54IEN88fxNeugTXxYOon3EDTIheAZ/ln8jEu/19oEa6DDN/TADECE7HXEL5RIABL3gGZ1KyLZ932KIbkM4MSj/XP/SeURzoUoYXF+uG2SOic2fwMXiN3EAm7Ap3vpBq9JxpWjQhjW+K0rkC25cCCTdno0dl3igiqRIv7J0QCkg0p4Hxjzy+fn6EeRnYDlUaVf97Vx/4bJiLsLZRxYTU+5nBJBJGyx7Ny+3aSBIJOvSZ+uTSCVir7MM/g69uxGnGKzoJJ69BD+XijHZE9BRtWi4JIcvpG6sIg0KnpN3uSMFIk+KEzgchVIzBTlsnfMEkPyo0Z7ld/++kMdEKaAi/PrryIyAoAxObLe+bU7d1TaWR6MNRUmJNu50OWBbMKEVCNYMLxyAeUiY0Va49TCenGRb2SNnk3V6UZC6muihGQHY5ccWTOdWWZBQhLaZA+KvlIZOxGo5Bglc9K2jds9viH04wVHMTv4D98yQ8MaGtBc/xa7GYrKBUuI4R7RKwl5rT7M5nes45UKLjOtoCQiQ0Ij0n9kDWrD53Cg6/lRuPVo0f6hif6VeemMwshY5NPaqIDaDaplcaH9uYr1IwO4582Eg4sRjD5LrZLF6oaUXUQTRKynYa2rwaU85CrX0oecoi07K9+NTv56Eohk1n9QzKzpsDLDZv17bhZel+cvWAA0HhUNqzaOGk1Zioaj/dWXo1fwwTBCHIJsWnAt1SetSy4vAxfhOIZdMU4nVRHMXv8M8PCc57wUk
 XvlzC87Z
 /MXty7QAFz/IU2Kp6HQi1+Wr+iZDKcOQIx/kBJAE4fSwCbW7e1BRH9amZkB+VNCyQRFKRxur8ubt31RGVPsO2UWVmd56N5RWOL/yTBtBFRK0juJnJjyNCbc7KnturlPyAG+crEEZ6t3AX74ILZdZ4ZrwaARDVNvjzhvXR7byeStlEfoMbsNfliugqkZhRlHGJqTzzv1YbkAf/zTNk8ce+ISk07bP8cIH0QnXmb6g96Zm08HX6IbpqwRNiAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we added the VMA lock, we made a major oversight in not adding a
killable variant.  That can run us into trouble where a thread takes
the VMA lock for read (eg handling a page fault) and then goes out to
lunch for an hour (eg doing reclaim).  Another thread tries to modify
the VMA, taking the mmap_lock for write, then attempts to lock the VMA
for write.  That blocks on the first thread, and ensures that every
other page fault now tries to take the mmap_lock for read.  Because
everything's in an uninterruptible sleep, we can't kill the task,
which makes me angry.

This patch set just adds vma_start_write_killable() and converts one
caller to use it.  Most users are somewhat tricky to convert, so expect
follow-up individual patches per call-site which need careful analysis
to make sure we've done proper cleanup.

v2:
 - Document the return value from __vma_start_write() (Suren)
 - Call rwsem_release() on failure to make lockdep happy
 - Reformat the prototype for vma_start_write_killable() to make
   both Suren & me happy
 - Add the kernel-doc for vma_start_write_killable() to
   Documentation/mm/process_addrs.rst
 - Collect R-b from Suren & Liam (thanks!)

Matthew Wilcox (Oracle) (2):
  mm: Add vma_start_write_killable()
  mm: Use vma_start_write_killable() in dup_mmap()

 Documentation/mm/process_addrs.rst |  9 +++++++-
 include/linux/mmap_lock.h          | 30 ++++++++++++++++++++++++--
 mm/mmap.c                          | 12 +++--------
 mm/mmap_lock.c                     | 34 ++++++++++++++++++++++--------
 tools/testing/vma/vma_internal.h   |  8 +++++++
 5 files changed, 72 insertions(+), 21 deletions(-)

-- 
2.47.2


