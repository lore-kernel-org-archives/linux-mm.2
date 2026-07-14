Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40784C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940056B00DF; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C77F6B00E2; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E576B00DF; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BED76B00DE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E53D914038C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:59 +0000 (UTC)
X-FDA: 84987631638.07.3767C8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6899412000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHVsmuS9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsJ4wwCCUmuJy3/ZXQ2uE1d89EPU2Gxwaw+AywiLsUE=;
	b=4V+z6ol+SJtzeTRsQMXpL0QiUR4euvcJYlSnDroOW3U+cpdkrpdXI1xWiChzqStxAeYLhq
	kezJYs4jiNR9SEd93kQG1olLE5UACxDlM1uN17nNhcXYk8gKIfqZuVm4ShSqak+k407hXH
	iPyLhWP3INh0Rp4ZiXneQkcRGZSOuEc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHVsmuS9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039758;
	b=qoabwr8SZTdyTrXp1zvdDprfIQGeYraFhugfaJYeXqkpDxQ8XKzEmqOupOCAQJrafGmIEs
	VZDhZD9jb0wS1zJ2d9nyknUTzR5TJu6JV3CswbORFueNB0BGcw2SsmtO3PrZkxvZGm1qEE
	1vWhKSD5HtRYrnVGsyyAqoiuQuh/D9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06DAC61375;
	Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7291F00A3A;
	Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039757;
	bh=VsJ4wwCCUmuJy3/ZXQ2uE1d89EPU2Gxwaw+AywiLsUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHVsmuS9moeWjE4tXVfnnYQuqO+Hokd4h4sU2eeIZX7PWSuvAPLdNNEfqMIw7orJK
	 RQ+CUztOvWnC0IL13lSQaGTmdo4FIqueuiE0pcva7klegfFkWM+Vh9BZWMJ+24CikT
	 iNoTjKGfEFWXgfQBE0W0YOIj7WaUdTgAJfyfkIVbb3pU7xfVq+ezJrSnVVyKjToFYE
	 8gOzsB1ZwPaDrsHc8XHxT6yYf0icrdmAEeN0C7CJYA93YjCrD4bxQ8ZS9617AGKbvl
	 UojG2hXrMdm9XKw/GGql/hO32oCCRZzTjdP11hxMnpFGuo4N6/sBE1PosYjWHfJkqg
	 Ic2egsfroHcTg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/10] mm/damon/core: hide private damon_probe fields
Date: Tue, 14 Jul 2026 07:35:41 -0700
Message-ID: <20260714143544.101305-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6899412000C
X-Stat-Signature: 413o79z5yzqgfbehppc4qqwd41p54e15
X-Rspam-User: 
X-HE-Tag: 1784039758-705425
X-HE-Meta: U2FsdGVkX186ICk/4Q18abg4VI9oSRTRrkKtuHsuRkDyUaVnOHxCgNGOrjIcp8rwaZqtPJys15NiMyBMxs3DKnc5q+ETrp/H4sjy/pLlSGW8lZqLFxPcykiRpWnDFS7R0BJJtJvQSWtLPH5hnLMyIbVD535R3SMbKH3KBYFLfTRJmN3Bt+6qpKdS/AK+ZbHQCuN7772Qyn3BbGoC5HgyXB1v50TLSa9FpRfBj6yK1OV4AHY3cfX1V2lroTY4UpuWiBYN2Xk/bXr0W1w64F0W6jPwztx7iYJTxDrPnQVHqUIc5Z256ilY5kw/fE3ftT69YP+w5BCJE8TzQdwNj/zNNPn+BDnFAj2JPJTY0omEcIdl36j/+M26VaWia6YveyHVhAEljnKqf27x6hfrAwPJg8wuXnbJ+eciSz3+MWQMCf6eckiqnRjN0wQCOsH561t06///TAeCKhnhAB55GMKHOuEt788LIWlgsiAKwEHT7iv1huW3BhjSx1DZrRq26lvcawiojTa59H574ob7mY+yAkCOosJ0N9lC8cYKicG7R6tdI990nFj6DqRTmnHxcmwLpenE/NW0kLZI0kqv5WBt7g6HHBZNJ4ulL48u4edT+jgj8g03Uh02gCGOv8EqRxNdWls+UymZNTKtdEEIIWptFSPdF9n8xzHBnpIZNbO38dqb0h6hXNsHE70t2Za2lfkq23z91UQ9qf1yp8QsI3+7GZNhBrq1yArYZ2gBWeuPGkgRSU5CZiJ7jcyWINY53duFvGuFxB7ZHHNYTQcBNpeTjB5yU3bKSkgzulrQH4+4mqQqvPpj4FAldhhLU9YXNFNSVEOakY2n1EKPFqGozVfmlxwyjZTmkGxQ9L5IeetHV2DdwM037uGyqxKpOerWPJsaZkaFx6zOGU4vxZLTM/qcTGGwBznDbGHVvrNnL1oFnK/cN1B5Qpgr1qnKCFiyrwd36P0EcowKh6fUibB5UQH
 Zlbh9KTC
 YE9oRYLz2Xqhy3R9tWBZcQjvcCw1mi+5kVTolCiIR9VVmODLdttbd0QNvi03HwSvi0nfeTu+6H5nbH7xPmeAxlAb5IF+K7s+O5d+iFtjqxtQTheoWC8rRbGRuAy0Qh/47qMQC5abVhIgHbBW7k3GyBv5u7NZPvhix3tHTFsQ23ZnAVQ0zrCl1J1DfSUBPUubK7CLzB6mJHHHGv6kzKxMQtkkizKv4jKdPIgz5pD3JdTMX7zBQhV+Y9HpILv3eoKGSs+vAmFvb3dIbI4n9Ol65ofV8KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'filters' and 'list' fields of damon_probe are intended to be used by
only the DAMON core layer.  However, those are mistakenly not marked as
private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6c3c7c75b6ca3..537e59bfd7072 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -775,12 +775,13 @@ struct damon_filter {
  * struct damon_probe - Data region attribute probe.
  *
  * @weight:	Relative priority of the attribute for this probe.
- * @filters:	Filters for assessing if a given region is for this probe.
- * @list:	Siblings list.
  */
 struct damon_probe {
 	unsigned int weight;
+/* private: */
+	/* Filters for assessing if a given region is for this probe. */
 	struct list_head filters;
+	/* Siblings list. */
 	struct list_head list;
 };
 
-- 
2.47.3

