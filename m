Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3945CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879816B008A; Wed, 20 May 2026 06:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82AA46B008C; Wed, 20 May 2026 06:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3736B008A; Wed, 20 May 2026 06:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C80A6B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:19:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14EF1A025B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:11 +0000 (UTC)
X-FDA: 84787400502.27.5B5FBB3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf08.hostedemail.com (Postfix) with ESMTP id 80B4116000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pD55Ilf4;
	spf=pass (imf08.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779272349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJQSb989Ft1cng8RSYH6fugEX9Hh0WZTKoGw3OGruD8=;
	b=MECIsgNC+LSPhOnPq90QDlgw0g7SEL9ydaJdk79hJIa6wKAkq2HT9P35SekblfK0aCm4Op
	rMB8AMXePN7l93xb+AdyktyOWxym3eVS+rwBjmqriJHvZ5TUI9SXfcIUQUK8GUle4xw6yc
	r/Zav9mAxcuCCTq1FVIzVzMOcZdp3fE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pD55Ilf4;
	spf=pass (imf08.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779272349; a=rsa-sha256;
	cv=none;
	b=c3JflYcD02sa7AwXreM0mAOoo6iu53CqMHhJV6QoUbTYsSyrz1zO1utl66wfYrAyL+59pC
	CkirktATPO1zHASWCDBt0T9qevetj1vb6xPSOSg1GRWTIRcbDXhF6Iz/HQs3vuUtVx/Dsj
	aUWUAigqPrKigWtfbvT5YcH0h2J/We8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=JJ
	QSb989Ft1cng8RSYH6fugEX9Hh0WZTKoGw3OGruD8=; b=pD55Ilf4nur0tnOU3G
	mx8swE2IrmRVcgZOcH5xJ6wXEP5i2Iww7dZ2JUazo2UZsnqUCQd0SsmwQWanpMxp
	Cg8d62lthDrQK0WnvTLCAazsnzvaCs6WZDkHMYyxMQzSRVtOOUcXSK5BpmqhevWy
	Okwi+hkZict3J5KTkTuy/EkfE=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDXbbprig1qQK31EQ--.641S4;
	Wed, 20 May 2026 18:18:25 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v1 2/5] mm/filemap: reduce xarray lookups in filemap_get_folios_contig()
Date: Wed, 20 May 2026 18:15:35 +0800
Message-ID: <20260520101538.58745-3-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260520101538.58745-1-chizhiling@163.com>
References: <20260520101538.58745-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDXbbprig1qQK31EQ--.641S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur1ktw17Cw4kAry5Zw4kCrg_yoW8uF4DpF
	43Ka4kWrWxJr13urnxA3Z5C3WYg34kWa15CFW7G3WavFnIyFnIkrnrK3W5Gr98ZrykJF1x
	XF48A348WF1Ut37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jSsjbUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3BGcOmoNinFztgAA3y
X-Stat-Signature: bzeoym6qg71f5m9a1i71sgrpc7uuaomx
X-Rspamd-Queue-Id: 80B4116000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779272348-87811
X-HE-Meta: U2FsdGVkX1/v80PTw0b1TJtJYVbFoFuaHr/AxCKjn+GzTn9BGmGzIBbhjqy4Q8oe2Y1M4OmIbf2/zDMQtgmgXv/6xng0MdLRT8CeJtvSJh23lu28yyy/1ozWdmynSL7MrMIqoB174wh34R1j7zDZypLWp3eWG3KR/1bs2G6zZ61p2OrT4magU2jLttQKomedI7hLm2XhnZJEx7BYLQ5ANNlTQM5N7RQIHSKaFigC2vNBjHkFiIHFwNt4waMpXhVnA4zxh/JToH+Ug8TtHvYo+OoOE0SAOWLH55/OXUgbCWOC9EDy/l+GUBO0mrtPhOJtbI+FNYFICUbeyJlqfT2Xlmktj+nGibo4BvWoBaGGZDCRGDK1pmPC8XEy/65aELBZHCUyJd7ZBY1xYdQSucjebSb8+K09vIayPyciaMOfEj4tBUSAxTIBDslGz/AWUUGFQ5b2OKjsntWJlufLfLh06q9Bp3axNCy2R4hY1MbsZRzZ3VrvZr5MBA3/ezG4iaFGSXsHRx3slpZkceHmORnfkquipfpKHJ7uW+MNYClaFzjOdi/Sp4Es21cGHNETqdOCK7UcxHUW/w3fafD5V6z/eByC+vJnqoKuese/CCvHyTSECIDsSdWRMNMmDk7f2vcYM8Q5/dFgQbuehdYDE/7xZvF11SXyjE10q/uMkJeBj0bbXyB11LZ/e6N2fM1cspABJ8tT9M/9OFpNQac9b+zu3TWvjaWIkYwiSKFrDfmnRHWdFtu5A08jj5D92cL+jBu8mf/it900o7oneizpMIVNlwEUnkgV1rIFuS2jMGp8WKzipkqh6tPYGCwS/zJca7nuO/U1QHEdjgN2r5uBpmPXYBz58f1LpvetLPx+nnhQRO7LuJAmsJWdbQEyfNH87IxIsxLcbobCqkmHayJhilo5Vcq+aLiYf4kdmg2dAMD1wr4zOTrds6LnbZcU4bPdqIn6peorlrwjUjmfrqVxEvo
 Kc1iYGbn
 Vq50TvGbuRnyFn9KCtQqzaQyRz/RXvBtDhqSIc+cZLypMzWAs0jFNF6/w4+shNofrtHX6hSpFBa90kYOmXXPr2AgKj2+tyHr0i4nqJi+SdXHJZkStBa2hdAbLJQSWk6ewCfYc2LUtvk0JRhzmDIaJHcEIV9s8+KQVYduwSHvz1a1iKeBGb1B7gSV4ydkSURkCoC5MajiXkDpYMngXYJM/chrCJeSNrTKVRjBTJ4AEGYHWP5BmZHj5zOWNnBhsCzLatgK1HmJKQOv4aUX5zdfv/YRR+uwAwAKUI4cvF0tfkgdV8/I/NQLQIQUvvPgzjKYpdE0Y8eq7c+hNT5RAMFdy7WHjgkAtnQ+0C7O7aRViDm8hXNqZIU97PohwVTu/aUfnUo21pSP/vTePUwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Apply the same optimization used in filemap_get_read_batch() by moving
the boundary check from the loop condition to before xas_advance(),
avoiding an unnecessary xarray lookup and reducing branches in the fast
path.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/filemap.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index d54450e529bd..5a5268a7c802 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2258,11 +2258,14 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 	XA_STATE(xas, &mapping->i_pages, *start);
 	unsigned long nr;
 	struct folio *folio;
+	pgoff_t next;
+
+	if (unlikely(*start > end))
+		return 0;
 
 	rcu_read_lock();
 
-	for (folio = xas_load(&xas); folio && xas.xa_index <= end;
-			folio = xas_next(&xas)) {
+	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
 		if (xas_retry(&xas, folio))
 			continue;
 		/*
@@ -2270,11 +2273,11 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 		 * No current caller is looking for DAX entries.
 		 */
 		if (xa_is_value(folio))
-			goto update_start;
+			break;
 
 		/* If we landed in the middle of a THP, continue at its end. */
 		if (xa_is_sibling(folio))
-			goto update_start;
+			break;
 
 		if (!folio_try_get(folio))
 			goto retry;
@@ -2282,12 +2285,15 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 		if (unlikely(folio != xas_reload(&xas)))
 			goto put_folio;
 
+		next = folio_next_index(folio);
 		if (!folio_batch_add(fbatch, folio)) {
-			nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
+			*start = next;
 			goto out;
 		}
-		xas_advance(&xas, folio_next_index(folio) - 1);
+
+		if (next > end)
+			break;
+		xas_advance(&xas, next - 1);
 		continue;
 put_folio:
 		folio_put(folio);
@@ -2296,9 +2302,7 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 		xas_reset(&xas);
 	}
 
-update_start:
 	nr = folio_batch_count(fbatch);
-
 	if (nr) {
 		folio = fbatch->folios[nr - 1];
 		*start = folio_next_index(folio);
-- 
2.43.0


