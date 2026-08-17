Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45262C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366D66B00B3; Mon, 17 Aug 2026 08:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317BB6B017B; Mon, 17 Aug 2026 08:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2546D6B017D; Mon, 17 Aug 2026 08:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BFF16B00B3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:09:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EDBC160709
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:09:57 +0000 (UTC)
X-FDA: 85110642834.19.40AA1B2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id B4A3740003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:09:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JX5FVsx+;
	spf=pass (imf01.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786968595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7hH8SEbWRyKCE3jQdtxktQ3xXVtwKBmUFnlCGecuPeI=;
	b=PNMSbBI7c2nS15yvwlLkrqwdRe6y2vGV6lTJx8rL5EigfJytRpc9BV12P60uDUuBBCUF8s
	Gcgpqlsfw+v7bAEBGDr9jbmYrnwdjIOc2Q0+HbQbZaz/ZtAk+M4bodPXs6mwbNF4UsRzVi
	/pGxMYwLztXIa+OmuWGPvvVMV4TvR6M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JX5FVsx+;
	spf=pass (imf01.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786968595;
	b=Cvnhx4ZnmiAU82lPEa+3qpm71qVrjVTzyfNBLWbh9VeFnIhB1i7uNFP0rP++WWf5dsB2p6
	cX25f7hOz3kHhAeWXcLzq+l7RDSy4sBHoFzyxMN1vb4/7hw6aHNMxwmq7eeT80zu7qkmjP
	zWhYA0ujOAsgO7y7qBrw58NE/j8ZdCw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7h
	H8SEbWRyKCE3jQdtxktQ3xXVtwKBmUFnlCGecuPeI=; b=JX5FVsx+KFnEfak8/X
	LTICC4Ckg3PQDGC2luU/oyyijeiMi+tPSbzsx16V2WJI9MZk/wHgMG4oOpF6rfw2
	kDb2OE9LdR5W9WCDjz/zwAVZRfPzbBxgKrFSUhuTaQ0a6lXhWd+aKC1WMzYfIGHK
	1y1Qbx10ny+TA/dUETDDa3VbM=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCXL4Ty+YJq0YOTPw--.30266S2;
	Mon, 17 Aug 2026 20:09:24 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	balbirs@nvidia.com
Cc: ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hui Su <sh_def@163.com>
Subject: [PATCH v2] mm/migrate_device: avoid out-of-bounds writes for compound folios
Date: Mon, 17 Aug 2026 20:08:00 +0800
Message-ID: <20260817120758.669807-3-sh_def@163.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXL4Ty+YJq0YOTPw--.30266S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXw4xCF4rKry3KFWDuFW5Awb_yoW5GrWfpr
	4Fg3WDJrWDG347Kw13u3WxZr1293s8Xa1fKas7GwnakFZ8JF95ua4IqwnxtFs0y397AFyx
	Zay2qFyxZ3WUXaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piJUUUUUUUU=
X-Originating-IP: [183.192.101.80]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6RT2VmqC+fTynAAA3W
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B4A3740003
X-Stat-Signature: 7q8mfnf3aha57cbfosbstu48oi771are
X-Rspam-User: 
X-HE-Tag: 1786968594-795085
X-HE-Meta: U2FsdGVkX1+D0/YjkyFCm0oDXNTvgWx+7pxoXWE5mksSOtOq9sj0s0iRkiLg4bNXSYvoCvjYwQTasN7lmgxHzQawjSqD1n896gO/hEEDI8SyZ74/EMvLQJtwmac64ONmS0M+xQzyyoaLulyHcpWSwCxx75gV6Y/QD1SYLqLQDC/OjSCionS34jHIgyW7i0JP8RfltSGeTobjsnBTsYZkuXzWuhzUNRL5PqB0QvwNEhjVEjUCcCfvWit2nK9+buLF0+FT9LJ7tAqihoJF1EnLrQU8fFeM4LeNQ+Yew2txa6bEFUggxyumhZfa4a/jAZOIvpIuQplQnVmSBCFEBHa5EMU0mKMvpvbQcBGbsuBXBWnGc9/5mrPbu46eGVid2ZJCiPTjC2BFXhcrr71nh+PhfE8TSCqpAOO2X+mOVL5TIDKHXHF4/P/BHjrXRl/odt08OQ9tmz2I1lPpajuyS9biKcrbh4CIOpClYa42Gi6wAWqLdpHf0tD6Wrr9H/lDk4dZ7cW1c5RaT3YEYd4UO7Zkpc4SQ31vd0ALdQ6HidfgDGeYeMoHOn9FrWyZCdADC0Yj79r4erRwB+6wwy1+BfxhIwUoIb28CTf4UDGZqvsNwEhl8wo1ZiSx4VDJzLfiA9oajkaIpg5qv1X0ONbyD2g6F3gmX7JMEXx+Ib2hxrKDis1VVXMQ2tFRt5txJwwjkf8r3U+ChPMoee21DMHY4sYP2jqSBBdYRJQD8Qb2hlFdy/IvAkuVXh49uMiaxrUeJO0yOqOqrM/AOcOT2Sz4AYnogZ4HaEMyFqrPVEGN+uXNmn0whEsFVRmzLRcxs3XSaIDaNd9IZbxflCtO11UvR/d+g3y52g/1P7TLo+XUAv+Dd30RVJd03p0RWXZOzUOKkeIF+s8QyjCOMMlulNEN76o7F+/wtwV5XE8D4aK8N2oDNQqAaGKpVD7uAz9F38ryJDNmOCcXqtS1mawJ4n3ijr9
 mUIGHfN1
 62ik5dyCY+o3kFja3ot8pw8Otcz4fi7AnnDZ23ZCuozD7Fzifi8ufxgr1itBy5iUbpqZe/2dDV8hG+LCHBIPox81I8wCep7IZHTC0BDzGTaxFy++rjQX++9DfAiEVMnl6GtncQ5XIz4OIWnf1q3DxxH5z6HJrkNVOQ1Y/DhgJCHg1JvRAOsRwJ5RJzKkD768Uhi0lXIDp6bp85SuzEoo+/h4yh5S1yBUqfrM69qLQGxdRa1Nb+uNafr5NBH6SUYbR7hpR1tG1I/kUDob2rd/4qWvBLGiJaIj4QXc3a+qz2Uj3XxsfSkX1FL6oiEJ1aZw3zcrao9rq68PYN8aa2usBMg7ehYThZLD+6vc7zifgsgQyh7dPxkwMyUpvtwGiFqHisQUAxImKjopH/i6uSL9VRUUUb5igkbefER8AsXmGMdZBxjuBNPeShXk9XbwOCY/yx0Vy1535P7nOFjHavH7SW7UbY6GVYmcixHQYeLikIKs9XxX3ToW415IhlAc3y0nVc+eq36lzvc9MDBIbLGGvmviZLDAXXhQ0aDaFWhYbCn+Qaq1AtaLlur7zWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_device_range() and migrate_device_pfns() clear the entries
following a compound folio so that the PFN arrays retain their
page-granular representation.

If a compound folio extends beyond the end of the caller-provided range,
the loops clear all following folio entries without limiting them to the
number of slots remaining in the npages-sized array, causing an
out-of-bounds write.

Do not proceed with a compound folio if its page-granular representation
does not fit entirely in the remaining PFN array. If this happens, drop
any reference and lock acquired for the folio, clear the remaining
entries, and stop collecting.

Observed with a KASAN x86 QEMU kernel using the HMM
migrate_anon_huge_zero selftest. Closing /dev/hmm_dmirror0 after
migrating an anonymous huge page to device memory exercises:

  dmirror_fops_release()
    -> dmirror_device_evict_chunk()
      -> migrate_device_range()

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
---
Changes in v2:
- Do not partially represent a compound folio when it does not fit in
  the remaining PFN array.
- Drop any reference and lock acquired for that folio, clear the
  remaining entries, and stop collecting, as suggested by Balbir Singh.

v1: https://lore.kernel.org/lkml/20260817074350.442493-2-sh_def@163.com/

 mm/migrate_device.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 908d2d4ec43a..69b8d0660bab 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1400,6 +1400,15 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
 
 		src_pfns[i] = migrate_device_pfn_lock(pfn);
 		nr = folio_nr_pages(folio);
+		if (nr > npages - i) {
+			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
+				folio_unlock(folio);
+				folio_put(folio);
+			}
+			memset(&src_pfns[i], 0,
+			       (npages - i) * sizeof(*src_pfns));
+			break;
+		}
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
 			for (j = 1; j < nr; j++)
@@ -1434,6 +1443,15 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
 
 		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
 		nr = folio_nr_pages(folio);
+		if (nr > npages - i) {
+			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
+				folio_unlock(folio);
+				folio_put(folio);
+			}
+			memset(&src_pfns[i], 0,
+			       (npages - i) * sizeof(*src_pfns));
+			break;
+		}
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
 			for (j = 1; j < nr; j++)
-- 
2.54.0


