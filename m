Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD5EC55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A818C6B0099; Wed,  5 Aug 2026 17:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A38D66B009B; Wed,  5 Aug 2026 17:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948246B009D; Wed,  5 Aug 2026 17:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CCFC6B0099
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:29:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1F111605F7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:07 +0000 (UTC)
X-FDA: 85068506334.25.FFD21A5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 508EB2000E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lbm9vEcx;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785965346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lDWcoHFVU4wxDffv+bvNmFatPp5AtNCjgOLFP2+Ns8=;
	b=4KQp3OwLqW0WstsLixxkHtgm640EikUeRw1BZCERP65iaxpVwZKTl+0sg3rtmp2ibnTfDo
	1VeK98IAfh2S0p3ZWIJ7QMoaYO4IQo/XkN89DPaRjtxSKV//7VyqWpGzPoUiSZ0gAwgHs1
	qf7Xvfix3IUNoi7iMPZEtYawoo0A1to=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785965346;
	b=eVDluFKvilFZinvQZAM5eZz/NJWoq4zGVMPy7AdmFuA8Irr/gL33Aix98CWJ+99Uq3rVQU
	vY0klld6RJ0jY4s0w/bqpDIn+zMVOVzmn0HvlvYTn2PPf/Or3uWCizO3UqNbI2q5PpTD+J
	YXXG/V3QmE/uNoCvhkzoQK0wD25CWbA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lbm9vEcx;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=6lDWcoHFVU4wxDffv+bvNmFatPp5AtNCjgOLFP2+Ns8=; b=Lbm9vEcxjN77uyC+iUuRjOCXPZ
	AeIJVjtI+irJAxkfW5viw65PL9pARg8P0ZJC58R6U2bTLJkcaolRYAHKrXhQD8BYt52CTvG8HD4pL
	b+xu6j7qKf8CMxeTRau+tkmnQ2yiGewhi8Pj30rF0b9GClnHM3mK41bclqf+DW2Bkm9TEXIO8DvEE
	ikn27RHNNSV12Kcsx4ut44aXD9X+XWGb1tJlL1MN50aWhIlt/N0E7D01zK7eA3EJOvEr87G69x82y
	r9RQ2PC0tFOewBFY7TwEABARFoZewG3mSfw3gFmWasA2knu0IzXxK848VPjssEBQR7pgjQwc4Foue
	5CfurTEA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioK-00000004h6V-3jn3;
	Wed, 05 Aug 2026 21:06:00 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v9 14/15] filemap: Add support for authoritative mappings
Date: Wed,  5 Aug 2026 22:05:54 +0100
Message-ID: <20260805210557.1118966-15-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: x1b1ayh76am5udpp7qcbrojujmj1rwnz
X-Rspamd-Queue-Id: 508EB2000E
X-HE-Tag: 1785965346-375920
X-HE-Meta: U2FsdGVkX1+iTDhHmXl0TfHq2TqSmUa4IPM5p8IoQz8ODg4t3qTWgjl/x4Tlu5kCsKLJVsYaZvpgiJlTXvtOYumg9qMc4LrXvE3DJa2rimsN0p7/jaARo196dTlQ/zE0/JfL/kDrYFfHPF2VqyPsDOSp+zDkF9RE5J+HKjkmHbuTDIRdgBVY9FRSdTo6nZnf2stWqrMeN+3usK5dLiPyFQIjTT5vSNJF1ApOvTxIPcs/VnbUDwHuRI2JFf1nboC+ZmOatm647nmu5BqbNazqyZl7Zfe6qUZlzxpscZ44MRHWYno7e5rUy38D//yNtSHKmaY4V4pl4CyiAzdoOzo1Sovzm2LLoWiBIsQ97vggWNTBtzeFDruz1IZ/JhBySOucVaLAC33BKfRHm9ldOa6cs4gWfSnv/P4qzAnPjDzexiUpB04ZU/A9pGUhepHAoCcOD0ooL69ll+E6Dp6qw8cflwu0xmyczj3irWRMpXDRXF/j97VEmGVoF4NPLHLsrSnIkSVItrWBQgHTrZjUw7zsSM3gAmFC/oL3mbNaoIiUksb8yw1hxXx+u0HLqWhzQ9QeIK25p+JJCEccM7lSyDJoS96bINUiuAHJMl1rfuFIiidFKNthtT1b5LN0w9YxhAs8VUgtsKzrbYd3IrUWzPKBKDxPBvIAY5gM8reGl8HwBv1Zujib4WZdKzMFD4KBtpZAIaVyYLvAl6byvL6BN59Zn/fbPflPRSTHeP33PjZ4c6naCg57RZ4UuD5sRm4dzhd2z4efCZYMujnQcg9fe1WuSBaoMNfZfKtoT+TzxNsXYeI8XveQiHTPvmZablcQW9DV5sRauypuAP5BPI9bllkfmNus7XOo4FWTwKQTnOKjC9gMv1Q8CcDhiwSw5Vm1KdoKz+XfwCg69DobHB16btsRjO8J69N954LJ1sSmwj1w1rEhGMGkqg7ix33BFCzwSrOhHfQrs4teUVVepbhJSDW
 UtMPCN1u
 O6j05enbVlFqgLBq8OYXN3nXMFHRPl7krWnC4m3EUw/WEQh4T9smkG6Tfs+i//fsf64+som89lURikHnqtMeq88hFV7vy6z9uEqP27rbcLkUNPw1nL5JYTkDLGgem5v9TWUBtXQUlf/lwhtwFCkMmq5AWKgZE4BCsZVaoJ/vRoDr2sq7N+xfQwy9dFP7qSyNMLdX6XPRQDIwDleKhDWvPMMI6IZwGpQXxFF8RCgHRbSsd8225mkjTjpFxGrzFgAw7nY7YM4qe4dEzPnklvGuYIjai2YhhPrOOhfjbpYb+bhUqmA5JaO/RiU2qBXBNxU6ZON6G1QN62/Ov++xRqkJ7V3q7FA+AW9kMVRZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An authoritative mapping knows about all the folios in the mapping.
If read() finds a missing folio, there's no reason to allocate one and
try to read it because we know it's a zero region of the file.  We can
just call iov_iter_zero() instead.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
---
 include/linux/pagemap.h | 11 +++++++++++
 mm/filemap.c            | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 968b791cfd14..22d48935ffda 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_AUTHORITATIVE = 11,	/* If we miss in the page cache, it's a hole */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline void mapping_set_authoritative(struct address_space *mapping)
+{
+	set_bit(AS_AUTHORITATIVE, &mapping->flags);
+}
+
+static inline bool mapping_is_authoritative(const struct address_space *mapping)
+{
+	return test_bit(AS_AUTHORITATIVE, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
diff --git a/mm/filemap.c b/mm/filemap.c
index 26a5f18121f9..5a8cc20e624e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2697,6 +2697,8 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 	if (!folio_batch_count(fbatch)) {
 		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
 
+		if (mapping_is_authoritative(mapping))
+			return 0;
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		if (iocb->ki_flags & IOCB_NOWAIT)
@@ -2853,6 +2855,22 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			goto put_folios;
 		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
 
+		if (!folio_batch_count(&fbatch)) {
+			size_t fsize = mapping_min_folio_nrbytes(mapping);
+			size_t offset = iocb->ki_pos & (fsize - 1);
+			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
+					     fsize - offset);
+			size_t copied = iov_iter_zero(bytes, iter);
+
+			already_read += copied;
+			iocb->ki_pos += copied;
+			last_pos = iocb->ki_pos;
+
+			if (copied < bytes)
+				error = -EFAULT;
+			continue;
+		}
+
 		/*
 		 * Once we start copying data, we don't want to be touching any
 		 * cachelines that might be contended:
-- 
2.47.3


