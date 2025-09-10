Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EAC5CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8341F8E0028; Wed, 10 Sep 2025 12:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3FE8E0005; Wed, 10 Sep 2025 12:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D31B8E0028; Wed, 10 Sep 2025 12:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5B88E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 006B7140132
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:03 +0000 (UTC)
X-FDA: 83873824566.25.15D5B95
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1CBE640005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DYdE7wwC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520542; a=rsa-sha256;
	cv=none;
	b=EgbomVm1R7kr/OQkNLh8bJz4Qpnfccbvc0/UPsTL+0pKMxe/4FVDAxWe891fUt0aI/1SSq
	kEBqBaf9O6IucVvF2C7WLNbEw1stWN5oFCUkFWa8VhfUpZxNq3Iaqug8twWroqaPPL5e7w
	wB36ACkhafymgIkl1yeX7VjTfz3/qMA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DYdE7wwC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520542;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvXia67Cq9g+cEA2tdQsRO5nx9SORMf8wIBhDb/3W4o=;
	b=P/n8zoyO/268JjbrWETq1WpgBb7Um1QyhOA4I6AA8FOmyzLIhQtZ7rFgLWCYnbt1GOcsuj
	bHcVbYWRswmGOyyUBB+kP7KRFLqRzuDRToARCIkpD1ywvnZUCAaNDJMj2i2Pwb/VLkMj2y
	Vo5g3e06GzVL1xFHdoJgqJ3HoVWJ0kE=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-323266d6f57so7852361a91.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520540; x=1758125340; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xvXia67Cq9g+cEA2tdQsRO5nx9SORMf8wIBhDb/3W4o=;
        b=DYdE7wwCgfqtkG/QDcByJhYthIgwCALapfSoQM3MQAQPmW9srA2jwCsELUlM6tMhyw
         NTbrvbsUgRaxPCl3dhaVz4cRMHKgci9gggAG/AjPXgxzNhlAqhXvMqV9kz9B+FOWZkhd
         Id3imROyuMi4Wt8ZaRAUgtmi4qMT5q7Kwsu2obIgfK9MCx1UroNJMkQW+OndNj3Uogfc
         iglSnu7DH4E0KJmZ2cXSxq3a0nBw1x9crZBl6udyhGfj51YSGVKr7fB8Tc7wc78N6Pov
         OMSraPVLfswkwuJynu4Lf4nTcZSN5jUtaGwRxTUdJSTaLJeObvV+CWN74QuqqOEbAOPz
         wEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520540; x=1758125340;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xvXia67Cq9g+cEA2tdQsRO5nx9SORMf8wIBhDb/3W4o=;
        b=caH+nT+mGPViVrkxS4YG9oxpoEyYbW6zWF4dKhqvANfuSfwD4cOYOAIt1huiK4BPdM
         qiRJIpjggWIdrJ4gGcptSkFclryuq1RhjpJg8fNoa2c6j8kEAnhmSTDcyrk4GtTJNEUN
         KoDi5bJzwi+JVpq/SY5OGML8bUiCY1dn4ZM4PDJ/OuowM9a7b9T6W7XBIl8IBtAfNUfP
         0LBABP3idBoYxq87AeRK3o10YM+BB+Qc+ErOi6fSP3oGzCAs4B4z7Z25bX/tp2LwpkMs
         l8tZhb0GGnnaK9x3C1+kSPh5sunYBq8eO2+ROouSDUUuB+wTwzHzDy16w2cdOspU+6eE
         +zkw==
X-Gm-Message-State: AOJu0Yzh6vekkTjo/8YA/0NdO47ydO5pB9jVEEp+xobrGjsMGgivQJ35
	s6MRI+Nk7VQ8TdmWnDTve+1zpy9LOBdVeTGwFRLX+mj1nS4YCo4GChEohkO9fUXPxHk=
X-Gm-Gg: ASbGncuQ43pxvrjMqJ9wO+hxK+vvqi/cN8ZRdttnTFRoKbH9wh5QCbW/2029kVA8boG
	pzc2yoye1FboNYxx5Ii113K533DKc+z37v59sst772vgYTLgntNHDiyiNRVw4wCTpk8M/grJTf3
	MvvZpN+yncOilChUzuGqCCegjvVLE/bsUvvlIEQANbk155XO11WQf0+uOt1Gwf+G4gQV6ZqOMcH
	mMTA7mnJFT0s8af2fPyJJOtEdPfyIdxTgMb4sunSI1oTeQnywIa8JFlEOfy8YDHFM+7AI8Ke25A
	TBQjuADDD2OqLaxSLzkqWRHAUJIgLXeGmzOKtu+PalMl54vnvoGRDSNdJNBrrszyJelIPKLDtdk
	PlOgTx+fYvghLEVbPha9qt2fOAnaUnB229Ncnot7DYYK0pPYS2RzNpx0PAQ==
X-Google-Smtp-Source: AGHT+IEVwQm61s1dQOtymtJfnxETL8PNIjVzDNadoWh1/HbK11a27qV9e2wO2k/6lR4hXgcT7hmMCA==
X-Received: by 2002:a17:90a:c2c7:b0:321:6e1a:1b70 with SMTP id 98e67ed59e1d1-32d43e11be3mr22608409a91.0.1757520540507;
        Wed, 10 Sep 2025 09:09:00 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.08.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:08:59 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 03/15] mm, swap: fix swap cache index error when retrying reclaim
Date: Thu, 11 Sep 2025 00:08:21 +0800
Message-ID: <20250910160833.3464-4-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1CBE640005
X-Stat-Signature: xxejgqp3chucr5j77sct4xxoxyzxd7s7
X-Rspam-User: 
X-HE-Tag: 1757520541-982497
X-HE-Meta: U2FsdGVkX1+hPEtDQzKM1iYZb8h+pMy23IZLBs9rZbdv4N0Q2DFNic0Cgkm2jDCaamx5bfcJqhX5fa5YavNLTXb+HDb29iyh6UCbyDwKZjlBxfPacZsIlezqCdKHFoSgaU56pNhz5/jrV13KRoBigdWjL04f8iJ0VLjJgAtYfYbQ/0cSL680WIwlIFvntlK+k4F8RvIPHt1ES4692Wedk1VFCT3TppgHSLFMBkO1s/sU6aql/AGpBpYuTCrYqHpInq9WRtVI2zt6B101Hsgsx5a+/phQWWojsRJqdGmzrjHAxBpry3VgQIOQVRlgr/e6S5NU1nR5fk5ktlZZ+A+24Ai+Yh0TkmpKxqcTiMaFiv3XQWsPT7yKpQrU/D1u2vfo6Z0AemKfgbcJkBaBixxKYdeWKPjtMkHrCYocBDZQxwwvYLmTDhJ5tIBtD4JQbxS7mrAing2WdKDIVhFaJxbYbP3UksY4miGZBaq+nMTSzVyOxXD5EbLEn1AyrK6l3Wy/PsoHwv2BuL0FJsOh16JNOrUIyXxI0+q3Q1Tt2OAT0o6dGT5Frsu/eNyi4A5cUVcyQPUvbwl+SLjFHd7V2kX/0got9T69EvkxSpHo5y1nqWPhxBvCq9uOswfYK/eZdYyViUMh5iMIxRk26/VUWvZI499HzryHQt/8OC6Wcwk7C1Lyk7aIXisVI4EJDIAXIll5RlwPmyDrth9Ayr+Y8n7b9RAbZUqIiLBo7OixGbTyfMozL2BZ0CVhnbFjyHEnxw+hIYc501X9MVUlp2QRX1ZbbKB4U6jAWcH+SX1zVwBVN55HehytfKjBmju1WoDSgdXqOOxtHM2wf7TeKwK9d+PSK5Y+BBUrtxJ1hCftuIRbOKdRtEHESHwNxVc/Nl+GMtteW6+0wpyvk+0tstyWvrVlBKNwjAVig8/IwMjSDFAA3u2e0SSe20Z/0LIQOZhLorIRCFTs5l43Tfpo+h9oJ6a
 qEu2QgTP
 s9JLh9+VUu18xwRkDYXVe6cz202jRoUjzJ11CYxuPfBzap3VSACyTPvkG6GoZ7Moq6lG2SyRwE2YsFWBNLP2mtypHvBH92Pa7tdfk5OWIB7DFdFOeDJPAaxe7ovouX5QLsayHm4gB+LZ6pDgTzBtZNRmDs4bNqc7kzeRjEI8NlgGw6f2oSiqwdkAWZfvqb3julSN9YEbGPfOzc30cPgBCyMiK/y1n5mHOiA77uHxGRT7QCS4vo+NLe2n4+CSFzuE5/kdKVWRq+xO5ksuMf8vAbhVsZupbjbtZFU9BYpG1f3Fe+TvlcziQaJspLwkJd4BqlJwz0EieyKSPbwQ8BdCKv0Zt5e+0z/8ixHvuWGnYLNZSEm5y0XXRJihAngOSi+qqcuXx5X+oaeVOmLUSBZH0CMAo007SXyNMjfllPy/IGXIlixDnJtIUJdBNzbcsaJ0OFb6KAccs5QaYipNeCjdUeClYEt9pR0U1qubOzZExEpncq6OLgoaSdV57jbWPU6qKkSuIk8jx4eRvuQVGTMo10tw5A/53TW9YIZGwqj7iRFo/DGmnLXtrMrqGZLcCXaTAV9/vGrthkMlyLp88xE9Elr1mdINLQFoE2aq4qpwWbmmoaBFqhK7PQtQILXNjQl0ZeDulzl1nio9CAoOrTJ4isSFztw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The allocator will reclaim cached slots while scanning. Currently, it
will try again if reclaim found a folio that is already removed from
the swap cache due to a race. But the following lookup will be using the
wrong index. It won't cause any OOB issue since the swap cache index is
truncated upon lookup, but it may lead to reclaiming of an irrelevant
folio.

This should not cause a measurable issue, but we should fix it.

Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/swapfile.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4b8ab2cb49ca..4baebd8b48f4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -212,7 +212,7 @@ static bool swap_is_last_map(struct swap_info_struct *si,
 static int __try_to_reclaim_swap(struct swap_info_struct *si,
 				 unsigned long offset, unsigned long flags)
 {
-	swp_entry_t entry = swp_entry(si->type, offset);
+	const swp_entry_t entry = swp_entry(si->type, offset);
 	struct swap_cluster_info *ci;
 	struct folio *folio;
 	int ret, nr_pages;
@@ -240,13 +240,13 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	entry = folio->swap;
-	if (offset < swp_offset(entry) || offset >= swp_offset(entry) + nr_pages) {
+	if (offset < swp_offset(folio->swap) ||
+	    offset >= swp_offset(folio->swap) + nr_pages) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
 	}
-	offset = swp_offset(entry);
+	offset = swp_offset(folio->swap);
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
-- 
2.51.0


