Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 255B9C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFB56B007B; Mon,  3 Aug 2026 02:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560436B0088; Mon,  3 Aug 2026 02:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477126B008A; Mon,  3 Aug 2026 02:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5CC6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:00:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CD8B805E6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:00:16 +0000 (UTC)
X-FDA: 85058908032.24.25A1E1D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D4C980002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:00:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZaGXM6N0;
	spf=pass (imf02.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785736814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=38ifa3p3bAJn8Qeu4dsywFzpgC8vkwE9sgEJheZbSP0=;
	b=M3Q3LruFfKRlkgnM8vE5LdTm0wgU/1H8RvayZ+J14R1MIEqTh7zg8p2kz+jamjdPLrVAWu
	bJJloUQUNeMzfGocMDvldQD1dIK7cARzDM9ZWYwftaMRNe5roKXSS96zH0IGHjpIYQDpOV
	qu052/weachU51L3XDQrFflc8tAvzeY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZaGXM6N0;
	spf=pass (imf02.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785736814;
	b=toMmsWlD/we1Lqr3/7lCBErg3S8dSkeAIP4+2I9EVCCvQk6L0wvYNtHPb+rpVXlVcerJpq
	ViULlMDaKh27WoaG6Xx+avJcZ6bp+5PDkFmI16C19XjUltYbtWqmjL3NS0iC7fG6sECfem
	zu3fl/WeA+Awm0bkeoxu3CIoopHjOH4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=38
	ifa3p3bAJn8Qeu4dsywFzpgC8vkwE9sgEJheZbSP0=; b=ZaGXM6N0BhbhNC/DXJ
	+C6/NHcn3WTW2qhGnIH6SlCMo6h4HwaCSWvOL8sumS1PNJvh9+kOwktlqSpu+AK+
	p3abxNxpICHIJ0DmszMatI+Q2b395xgjw7QOTq+5J4feBkGM280CMZDcmU3dmbU7
	gC6EXJN3SpJgHgH08pfnrezdU=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wDHAm1jLnBq2twwMg--.447S2;
	Mon, 03 Aug 2026 14:00:04 +0800 (CST)
From: dayou5941@163.com
To: linmiaohe@huawei.com,
	akpm@linux-foundation.org
Cc: nao.horiguchi@gmail.com,
	linux-mm@kvack.org,
	liyouhong <liyouhong@kylinos.cn>
Subject: [PATCH] mm/memory-failure: fix refcount leak on soft-offline LBS folio
Date: Mon,  3 Aug 2026 14:00:01 +0800
Message-Id: <20260803060001.800638-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHAm1jLnBq2twwMg--.447S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zr1Uur47JFyfWFWfZryxZrb_yoW8CryrpF
	WxKr1fJ392qwnF9F4IywsrZrn0k393Ka18ZryfG3Z8A3Zxtw1qkF4xCa1jv343Gr1xJayU
	Zay8XF12gan8Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOtxhUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+QRbCmpwLmRdeQAA3Y
X-Rspamd-Queue-Id: 0D4C980002
X-Rspam-User: 
X-Stat-Signature: pw6ssz4np75m81ngnhainaq5tnbrgfko
X-Rspamd-Server: rspam04
X-HE-Tag: 1785736811-169812
X-HE-Meta: U2FsdGVkX1/XX9GL4CtX/bsTdDRHuyR9XL3gbaqBcOIPlK1q4TsjnXrT+v4mRWOOOMW1pU0oyZkERXh7uj9VuXZ6P/RNo7G0WVAnnH2cm62nzcC3yW3OhtKz/VH6X4/8nArZSChq4r73PpSY+eZUxeMf6Uy6/wr+A/Q9+mXByWLPq6a4RlSWsQ/g1sRIxhbTmknHv2vtVPDJqhOB0jYYLquvHqeHoy6hOkbmPN4WkuXL1J1FeuU+l4PX/n47x8BjgdgUP6RLg7Q7AdC+jUiE+yvbgBt4k3IOI56anjVQlK2y3UQi78SZyBJNk46WM0pV97b+GeKb5yts4EYzISKY05ZbFjXI8lscxuONmtliVGTewANOWI77AWpHezO2ps1BjSi2ls5/z/Nq2ApBZu7cy1wDcMKLcW/UGbkua4yGdTk/Whr3Up8fQVySn6tuo2bVu2dwg2YkwX+9JxwQAwMC/VPtpHBnkkr7FXZHRn/jWAajsmPcS/dvD2S7PooGPjkqBg967WMM8cImkTuX7WZbohIC7UFtwHFIn4TH1CDdi5i2J3UeLJxkLy3jSzlwSqB4MaCJMexuw0PR2B0Qem9IbkW1B1afeNYujHQkIt5IHGQGA9tmlo1YRvMvNygy5gVttN5e/yZRUBMG8vgwmUyWMcGgXXDl2Jxxj3abjojto/VEs3Sg3yBKW/Blw7Vu/1al0EhVLPJDyAvUNE2oYqIIt7Q78ypFLyICGnr8Epnkhhgx4tAa47bgfShCsL/f6oX6cdd1oJhZkVH8kaAyaMMrUmHgktmBLPO/8jMM3HPrzRGShkl391DuTofJ3FkPoT666RCumiA7dvdHGmcoKEbRNEjpwq6eJcyzoM90tEXpr0e/pHw+N51nTW1en+NFgdBJ6QHtiBwZMqXcdX2tDUfecDzRdHmebrPl6T4IB1Hx82q0UUzxWb3HTdkyRmTeDzaNcz6mGmUlcUDh9VtUDsg
 epqNGbbd
 PMFr484GyQiP9pU60O69a5+nXMCaOfvpv4FAwRhH8PZJIK7k6wxwsmIhSFY3fxSNTWGOv3w6vWxRX+Aa7fhHMORBVxH3s/G6kOnw1Tna1PLRLWa64Nh4CEi1g4UJOKkW1W1w0BaEIBGYZbE7UOyMYaBYTxsVVwIs9Z/C2aMuEJ4NtJNXzS1/UgEgGfjoiqyJGrrmTo7gKtnt+cJlaJHxAymsDwpW+a25M5WMkDpo5DUAMmXQq5slyr27nMbh7YE+eScEZ4fjOZJOykxQh1ZvfIGP7GrEBAAheOufj45lBPQdppyv4UfcOLPcWkjQ5rcjtxfe3vO9s0z1MlHAgTbvDRJ746JWDm+litHxjNjvW/yXksejQLwDtUIyCw/d9lbfIWS/YKPuHoR8XMSFX9O4J0mr8n+heRmP9hWcu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: liyouhong <liyouhong@kylinos.cn>

soft_offline_in_use_page() runs with a folio reference taken by
get_hwpoison_page() (or by the caller when MF_COUNT_INCREASED is set,
e.g. madvise(MADV_SOFT_OFFLINE)).

made soft-offline skip splitting when min_order_for_split()
is non-zero, so large-block-size folios stay intact.  That early
return -EBUSY path never drops the reference.

The other failure path is fine: try_to_split_thp_page(..., release=true)
puts the page when the split itself fails.  memory_failure() also puts
explicitly on its analogous unsplit path.

Split the new_order != 0 case out and folio_put() before returning.

Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
---
 mm/memory-failure.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..b14d4d42063b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2801,9 +2801,19 @@ static int soft_offline_in_use_page(struct page *page)
 		 * NOTE: if minimizing the number of soft offline pages is
 		 * preferred, split it to non-zero new_order like it is done in
 		 * memory_failure().
+		 *
+		 * Drop the ref from get_hwpoison_page()/MF_COUNT_INCREASED;
+		 * try_to_split_thp_page(..., release=true) does that itself
+		 * when the split fails.
 		 */
-		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
-						       /* release= */ true)) {
+		if (new_order) {
+			pr_info("%#lx: order-%d folio cannot soft offline\n",
+				pfn, new_order);
+			folio_put(folio);
+			return -EBUSY;
+		}
+		if (try_to_split_thp_page(page, /* new_order= */ 0,
+					 /* release= */ true)) {
 			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
-- 
2.25.1


