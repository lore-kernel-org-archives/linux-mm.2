Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2266AC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0FC6B00CD; Tue, 14 Jul 2026 14:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49F06B00CF; Tue, 14 Jul 2026 14:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D393C6B00CE; Tue, 14 Jul 2026 14:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2C46B00CC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:09:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2F1BA0559
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:00 +0000 (UTC)
X-FDA: 84988168440.02.53F1195
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 65BE11C0012
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:08:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FLCTSY0e;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGWLaE5LHgNyGyBZ/Hr6+ukHTVnQ5dW0HCqJh0ZEjKQ=;
	b=pl4+HUIi3ryDGMQE20sUBwxy/RPCGvMa3JkfLp85NrR1B+rQkz9cqIe0XD+6KiqeOcWSSX
	N3D6qLWv+zN/eOuQbwpNdgVso3hWCU/G5Gtt2hKkmJ8qxDAaYI517RXNNf53tySIuaabhf
	WMQC3TQOzSTqNKQ5Enh1Z2zIsPkgRr0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FLCTSY0e;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052539;
	b=oO+4+g9vY6OmuX8wPqyX4lkoZIrE8qR9dsgWMxazn8D6FuoxzEARD46bAlvZbwgKlcD3jf
	N75wvDkJu8iGsTWk4pNAgY8frEpIqzj2vCij2O71td1fqyQ34G64fjcC++uknzTCEM/+Ih
	R4HWD6yF5wXRE97kvvUHypG60QEA7XI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=JGWLaE5LHgNyGyBZ/Hr6+ukHTVnQ5dW0HCqJh0ZEjKQ=; b=FLCTSY0e+ZE58xViFxOqb9u3mI
	5l4QxS1C1D2ZpcdQF7G+Cf8y/QirOAcVIvBkj/BpEBg5rZyinNMyedMwqfOZ7Z5J3nFh4tpfZM75U
	JTaCEHeEwoNVJiOH+/KMqBAefe3QmB7qmP1L2t+Y5EfyYLt1plB31InXfB40krvyUuIc7REgTCevY
	WIv3wBYMC1cU0vB5jeXP9cErdhsTnNWQnRi8j/oNMwKHL/SjqByajb2RruJHUIM1KBUqLoD27ezQV
	Su1zQh2rk89NkPZIpBSKiTWoTbOsPUM3QDtdTI0lNZI1ozF9xgZ2n5qevDkXYoRD17G8LMYN7yYMQ
	+o5OdReg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYh-0000000Fegh-2Dz3;
	Tue, 14 Jul 2026 18:08:43 +0000
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
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v3 8/9] filemap: Add support for authoritative mappings
Date: Tue, 14 Jul 2026 19:08:38 +0100
Message-ID: <20260714180840.3731244-9-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714180840.3731244-1-willy@infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fxgjw3ojzrzf3xc6u74xk4fgy58d9swn
X-Rspamd-Queue-Id: 65BE11C0012
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784052539-607293
X-HE-Meta: U2FsdGVkX1/Jisytq5yOIPni9vgjf7gxZRGvnBoGSZOQ0LLIIkSxG1uiGRoBXQ4emlNlv6Bzq5JgiEeI15qgp/GGVlJprTe9hl/UP1ha6DdoliPHnokzuND8txawIlqqMgmuixwBgghN5KALuZWOCl/FuhwYZ3nBWeqlNw2X80qw54M+4fQpQehOiGonnX4I4sPBDKa67xzxuowJfLnocZP8ByuJxc7iHtY1aPf1s9es4W/Ce5yUSPGbWo79qT1BV/GXSBuAy0fgpnCo4prSWq/YCXFOWO1I+HTr+j5DAC22KlL2yVZgEMHblJ4+lyWjhEns1ZiTaGf7ftviI0BHzccRJNqe8WPKeShU1iOp1TYdV2BrddSWaZqAcbzHl1hh+OFJVoR327brFEwPIgA/sQc+Q0QuvWHC6H/ivq2tbmBjiypNuS9BxOnZKDSoGc6gi2frSC7k5x1OTbud+U3ZWVbfMQJxQlg7i5BudVx5MACgB0+SUfStgO3u4GxpP0LgFN1hUpKZcRV09GQksHxNSRyeP4hpH51ix+/cJVHF1pYDsBpaAyNsbnkgRd6b6dpyRgkR+q7IfKMxcHFV4lmmiFw2D2+T4nHhl1Df6XX5/Gy3LicZzWXUHhRWqlo2Uk7WwfKbbyVAuSFmqVhDU+fgAlzOwNpDG1AqdvOCWqXaKwRLIsIEdOK4y7MODMBw3z0fYf3HW4kiaiTmm1CmIKDT7EhBUIe2TKfKLFBtnNtO8d2PGcuZVztP9rQaPXWch/iGi18qcEYWQErhExS2ten4VxMvwCtEoWz3ozGbAluHLdUgjH2BPK3T20U/+npDV6SSt61sWUV2jmScL3gBqQX9dqUe8CmtxHLnNemJGdsPMYfWaITUiLX//I111THU+rDGm6kU8pg8CO4H/2aUakUCB3mSUGifctE187otQ896V1YW7Ylon+Rr5APHTsqLu6xhD/c0AnliN6iV9lAYjFr
 8qtzk8qf
 EnaSr/zlQsT0X8XcbEftgqrbnF8OBViB1/Yz9O3m18LhTpu1E6ZYYLZslklqL5YX/anO0gC2khEH8GBvV+kBIFDrlcsS/ciVX2VPeiIA1RY823Uxj42f+uwN7ACuMv2YhTzDX2vRyk+homs6Dd7YBYEAyK3960DfIXWKXZxiXOZAj5vrCZpM0ChQ22ugvK3ceWOO/3ZKMvg2k5KKQXDU/ocOtT5G/03IlYBtrp8ANRQ/fFAhO50sQjkmmtzjT7+XSwcN9l4BRLvbdLYPI0/pjFeFGA0dghVyJnlfQJLJJrwhe0+nFyH3K2q/AMS4GgHxLYC4PzQ4B8KBs3rg/L3zghEz7VNmb2TUJYdol5zTMhYEg7rg=
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
---
 include/linux/pagemap.h | 11 +++++++++++
 mm/filemap.c            | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 346b77fa95ef..bd6a6275a4e9 100644
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
index 0f3ada4d8cff..f662cda81dc7 100644
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


