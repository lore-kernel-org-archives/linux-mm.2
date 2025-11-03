Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A156CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059858E00B7; Mon,  3 Nov 2025 13:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030E78E0057; Mon,  3 Nov 2025 13:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0FA8E00B7; Mon,  3 Nov 2025 13:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA1258E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:03:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8579087BD5
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:03:56 +0000 (UTC)
X-FDA: 84070069272.05.205B6F0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id E86751A0017
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:03:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kZL3LXzU;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762193035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=azEErvwdo7w/mK6w6XTMw8a3NZn/NnLohy5/QnHVzUI=;
	b=wsDObfd3+dz6aotQWbaR0xa1KZQOenp5Xpj9PqLglX3AusI3FfGJdswlRR8fauKFM5RiVR
	msnGKjHb6LgtAQlOArQouu/rDpydeyVLjI/4Vp1h1Ss//tCE9eW8RVwilvOxD6oBPtWuuh
	KdlvEIoGduZ1uIs3j6WNSmlS47/l2kg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kZL3LXzU;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762193035; a=rsa-sha256;
	cv=none;
	b=Jd0oK4wcs5xeTW/QSmRV/RrTbscf4oYjW/euiAlaa00VGwtjpvRL6ao45+xVfeLI1/ZUT/
	AJ1R1RGQX24cE0M1GP57JbubM9UwYAxNy1Lt7V9pXvE50ji3Z+Zkvir/XRLTnGhsKuepu1
	LDJZMska1BCoOeemPqxTfQl7s4rOHrA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=azEErvwdo7w/mK6w6XTMw8a3NZn/NnLohy5/QnHVzUI=; b=kZL3LXzU0+mSY+v6Eb+Cqs6FyQ
	ncvyO2ZBIUUymi9cMiWz5zKWsdn8V6E13tBPo1hbwol8JUvpAFxJ2tWGHcCvEai6S01y5y/gVsemU
	ti2ttCS32KDxClc+vC9dRjNG7mNB//B9omGY3LTtK6CR/AWx+7js58nRMpKnG11eU7aDtBKx2PxTr
	BUGfAS8l3wPaSqBY3aKP4lQ9mHyM0WMtKiGWDgZJ4TqG0xGQvbvAxr1o4FufBsy4W+rJBGHd2T6dY
	h3e3twUEM85zRa+EKysytmXtB8ARDFj+VOogWmFSIivXzOdVJArlie8KaRN8FePdmPFecafUOkS2E
	KR2hQxxA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFyuE-0000000E8RF-2rHl;
	Mon, 03 Nov 2025 18:03:51 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Chris Li <chriscli@google.com>
Subject: [PATCH 0/2] vma_start_write_killable
Date: Mon,  3 Nov 2025 18:03:44 +0000
Message-ID: <20251103180348.3368668-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E86751A0017
X-Stat-Signature: s6c7uijbujr863ro9xqoce6bg4isnuo3
X-Rspam-User: 
X-HE-Tag: 1762193033-549749
X-HE-Meta: U2FsdGVkX182c8YaancGTPWG2dOLBHs469e2vjtXdapE6mEGCJ+s0yQ/LiT+UYn+3/y4dN/N5YOeNeMLa9rGQf0tfpfsr4ynaTuF6WZ5+gKkxUkEnJGB/EKTf4m3NBwv1FiVg6xHRGpL4cssq5j8UhOTXwSTnKBJu4C3sr5/ODyoEA8lK7PphqzFfmIv6dELqDURpHlHDhIlP2FYemKWW+BfyYhU23pIB8y5uV6pqeU5X3KjrMD1syCj+W+YaMGkA522RHXEHKzdOm5egPx96n32gMj3jXXyExW2StOnT9dXo2cJaHYLI7ltjZIotR1mbzqzt1RXo5hyMGi/uUgwVhzrjc22Af6Arf2maN+h0ijOkCl2KsmLbaJ2FwBRuZr6livSrbmQ/QksI7dbulEY00CWRpLatTVDKJBDlmqL6Q28QIdeZmeDzszZc0nDblEjTQs1ZSh8NcTwWQXeY1sv+C8F/WHqnAkK2l2EaOH6Or38OQziQiBQB/jsh/VwoXRlfKEc5rXz+EOi/9DPRZJFB5QM2q5wGRJZ2KtklZQTzcL9iS22lAAq/B4QIGiK679v0vVF5jUspGkM8YLATrxBfbKo/QexrYQGX2pV/tgy5Dzb4W8ziwIc9mrdvisLRj0E2MMOU9aShc6DPvI3YnMNm2NlG/pMh1W1U2MDaBCXluVLpIhJNyNvljfiXqpBSEsslR+rV3V49sUfDjzL3NNaJB3FbxKPoqzZcW0UYPdHjiFPUthGhlYpIdWq9wiVu8d+MmHFDEFH4Hr8xo6xxWUtOy/imCE7c0woBRxAAxgA41WdHkv9MjGqmu0LoUqmxDGv7/tll1EmWbaUZLWlOZb05HGzMq0LgjtvIst0/Af2WLTy5BeDw/Xl5As0NcHcfSjrgxEkchfzRFLx20QD0p5Opo5NWDeeM6MuRqkfl01IdNLedYGKNwX7i2Pn5ovY1mBAJ9c66O41qoFl4pZGgth
 bpaIfyjL
 HEh2vQPDVUlJOuNfNfJTMSnnF8IzHa09Fw8o+briAcLizvnkQjyB25AxMSKStrG+TBK9UHdTm8Scft08Q0dXgvQv3S3gnSN8YXKmYfsjFRDqqLkRc0xVmdQJmUPShmxphGzPuSUGJjnfHwaZ9FhXqWm/+9mzS0oLMLzYOHRJ1m4q5ts1Bm4j2GRKWn6nZBhPeYyhENgIzkKoUbiDcLD78pC2rQAV2wn2pP7Z9H9aLp69+hN3cereHlT8zew==
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

Matthew Wilcox (Oracle) (2):
  mm: Add vma_start_write_killable()
  mm: Use vma_start_write_killable() in dup_mmap()

 include/linux/mmap_lock.h        | 31 +++++++++++++++++++++++++++++--
 mm/mmap.c                        | 12 +++---------
 mm/mmap_lock.c                   | 27 ++++++++++++++++++---------
 tools/testing/vma/vma_internal.h |  8 ++++++++
 4 files changed, 58 insertions(+), 20 deletions(-)

-- 
2.47.2


