Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497F1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296B56B0005; Mon, 29 Jun 2026 02:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2479D6B0088; Mon, 29 Jun 2026 02:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DD96B008A; Mon, 29 Jun 2026 02:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E51BC6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:26:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6950D167F15
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:26:22 +0000 (UTC)
X-FDA: 84931965804.11.B4297F8
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8AB7B140007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:26:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=NTEXyNwe;
	spf=pass (imf09.hostedemail.com: domain of chenyichong@uniontech.com designates 54.206.34.216 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782714380;
	b=8DNXxSG4re8/v+BcX7V7q0NCEB9Wzl7RNiW5fkUG37M7GxM2cLC2ca/D5mhQ7NvY4EtdvX
	56zYfKbJ3cYM99AJTWOHV/vknjPxzxiM5tkYEGsk2PDGkWOGMs2S6IqDCTU9Mzvpg5DXI6
	F5zVHIUhjRabTC7TX8ZPBfxwGcl5SqA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782714380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tFQHxLTX0dibmKmXtrX097ixCjWL7DKuT31ZrIFN/s=;
	b=agt4To/gB386R3ogE5rTi7CMuJ/P3j0zryPzwrfP1Mgq57DJ5Tkqty2D85sstPJzAXeVQy
	Sp5zETrXiZqvldr4mHzrwy6D5TTrGMYRWnirbeaDH0kfOyhFxJNWPC0lRDTDf0nDbBc3NU
	n8WcVWCKV32h5MqXnhLRM5YWOiY1wcA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=NTEXyNwe;
	spf=pass (imf09.hostedemail.com: domain of chenyichong@uniontech.com designates 54.206.34.216 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782714355;
	bh=+tFQHxLTX0dibmKmXtrX097ixCjWL7DKuT31ZrIFN/s=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=NTEXyNwet072lcuW5q7uW6OgKKQF/NhEXXMqLwvn6q3bV05rWc/bE+D22fwniv9yS
	 PSxEFeBlQ3h5VPreUpJYHKYMnlJEiDBojpdxITT7EYNgOWfqfiSKGAFRUtpuZjas70
	 77zM4aLzeBWIi6EDf1kmRliewwbNhx99bGuFyMWM=
X-QQ-mid: zesmtpsz2t1782714349tdc5bc9ee
X-QQ-Originating-IP: MRRqws0X96a5pIiP0c4tXkNysJJ4vv85m6zaQ3EDsy8=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 29 Jun 2026 14:25:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17589445697565877377
EX-QQ-RecipientCnt: 8
From: Yichong Chen <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: vishal.moola@gmail.com,
	ye.liu@linux.dev,
	zhen.ni@easystack.cn,
	ziy@nvidia.com,
	chenyichong@uniontech.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] tools/mm/page_owner_sort: report get_comm failures at source
Date: Mon, 29 Jun 2026 14:25:46 +0800
Message-Id: <20260629062546.141659-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260629014316.130307-1-chenyichong@uniontech.com>
References: <20260629014316.130307-1-chenyichong@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MQPu5pFEJFN4PqAee0Zw3s0tAxG2u5g1WI6+c0n7O5JbW7gO+fodbZ78
	PHTH2blyLm1WUpp1kL+i272HX5NWoNXG4wzS9mKq/hYeUFhAhvq2g5KgBle3X5BDEEcoETY
	vuLsPsEOWmFpZCttiZ09ui8fXiT2pac27rR0FQHR7ULY4vu9O32LHNwUh39MEODam0jOhhQ
	pyiPZNaRBeZqJRR7xOYv0fGB16z2sy7m8GmthR3Dzolbr58/EklBQo4N16RJ8R5gl8ExG+p
	WwZH2mat5CYiLHW1nEdzX1GEyw+oiH/17COP3qeHnUu8Hmws44ngxvD94AVkFtSxkrF6MKp
	VuifyB52DoUe6zJrlnHd3whhZbLKtGb7CWiBNWHtVmMrMf51D7j7LYvQmKYrmVmJNjeM74X
	nugmkfNebNUMAMNY7KUCLSQ3z5WwElj6u7Vyw2XwCeFAGgoXCF5wezlNZ2VZJW25E9DSw3q
	jqZXAS3sY7akTGEUgT1fFKdjNDnxknk5Y0kHyIi4JrmtUkaQDnywG/Z+VD4zO8DxDVa3bNy
	GHa9uxo2gkJefbSODBOA5qZKMO3SfneRcusvhyMBtTrBwhNfjB1PQz8bRAVoRQ8PwiYOvaa
	9xBz8zw6y0pxwosYNo5DkNdk1xaIAc78U9bACpB8qd6ZzXh/dhiUgqecv2OVp/Qt21evtS3
	3yW6G/qJKyDITQVG47f/YWFG5fkKvmH8T0pwRmZRyM8YzYyznQZVS0aBW6+6a112v9elO+X
	F7Mn4v2gqRI/gAwb73EKHjyOXm2w8/AW95kjkpWH0tNKZWeNwZNBPYhxmp5lF7WE4AUva9y
	ny7X9BqHebN6iBe1H0qlKGvL7xHGGYCTTnT1f/EGJyGtuHNWgPwaVX2993nMaIlSsZApb9c
	kR2d7lMiCoxV0nxFl4jethygkrlBoy9Um8WqRArk17qjRRcpiANNPeN7xpZGGs2YOZ8kSJr
	d5Hsy384TqyovHReiN5gDkKBiOVFoi7Og4FLKVKko8/kShelHlGO3r7C+n53ec/LeTgXaA9
	wKg3Mcxnsz9pywBAbKExFVEoknzHBgXIF8NF4iXv/F1ENqVnjy
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8AB7B140007
X-Rspam-User: 
X-Stat-Signature: edt6x9n1zj9cum1hqpom8kk8te7b3sku
X-HE-Tag: 1782714377-727293
X-HE-Meta: U2FsdGVkX1+V0DvKTyM1WsQg9PicIsMWNZ8tYpMdLDrFd8278mECW2/uNUZ8ddnw/r6M1YwNQYJM0zve+ZT7GOD0rLPvkLXuTxpwbUmjmN+iaHAGyN7uKAozIxwolWo9fqlIP5rVTYz52rjg909gBgYItw8h3SxS6fp/CPuKywMLQVxcNpCApTYiQJ64TXN0bF7rrARc+7tuVOmQ3T7m9FL9MDay+Rg2pEC/EP5/bQcCDNyTtyypUh3hZX+Mpi6FdIiY9Asib3owbTPXYdhAzXe4xK8/Ex25P5U6NlDYX7XnnViLbp05CmQWvszAMkwSDZJzSZh1b2d0Eg4QeKLCGpm6L2jcxa4Lk2B++c8GIAqEU+bEym6OQN8W97PVu1bY6y82jjQP2AhcmktNY7tWNdJBeuy0TwwQoTIOOOQghdBDU4jZfPmS7k258MzeO9hM1N/3dGO0GdWNu5G70YTEj1gpQMXB1mrhVRBkC7LoOoPAneU96Ny3dd+C3ZhQ54G1IGj5qAPBsVPXvNt+CU5HAGMsK3gGdDsaERd7zhoODf4b2nrOv2KDv3XOFVgon7nwJUCG988+UTwYnZBCAy4+6m3zy40OZRWuLDFYge616U+gZWciS0CDVSI8iMqLmhN/cUB+BFJLOcFPbKDIeNCK++aoQ4pGi9S/Oc+e5Daky3SQ2Dn3xqXZw1eLyl7/us4V6SVc9RWAWKrJBhBtiTwFRmY0t8UgRxKwJ3RFHNo3SNNVeqISAvi1Iu2pzSrHadcJFgKa7Xg0DlVP18X274KQaGLGoEsJAPuJeQ+/UDuyHK/DkEcSNYiAk+X7wtQt3FNwGfS0OvR5YoYZ/D1XZ5EKBP2YjermB/YArctHO/OuueudjP4HuYBzr66edUS8WRstR2Y4L+XmP7s4otMUGbqj+PGt7s1qwaQiYzObB0oQkvpScQdQrfdJ2mgIvTDDc86rmEaGbL+1h5NOF7FHWux
 cJZHCV/e
 ONkLrPM97XktQBM3TQ6Gbt2T/MMnf3XENkyKIDAxlAqT/wDjQtBgKZmdjd2K+redjLPP/i9jxcZ8kRWvE+CJ+d+4rtrtR5A4Usbh6ixYmcW2MrTzR0Rq5CFDXv1Aq8yJSanBdIFsqVkOhtZ6WAUfvMt0pCxN84avdg7s4Hf1++I3Yc99l9v22QpRLjYjybryJTq09/AZCuD6eGJ9FW7j6hN3U2Rfbn1aTQOzk2MlUKDO/vN2SzxqBJl11nv6C13VQcINJcQgUZnD03Rguw2pL80S51zGpgEQ9yKdit6af9Yt+Rnomyor0LUqyjItNMokXHeQ2cWhkQaU+lZ5zZsOaWav4fC9532EIIjZTnsh2pnGgtjEI6IxoGDmXv8GIr79uCyH49pW9cbY6A4Qq1OeBWLoBtRu5g0/XwkKV7K7YiV9+ChfyXyg1wV06ESZlHrCGzYBbHFShoAVEVtL60n0jK3tI+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_comm() clears errno and checks it immediately, without any
operation that can set errno in between. The check can never be
true.

Print the concrete get_comm() failure reason where it is detected,
and let callers handle a NULL return without guessing the error
cause.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 tools/mm/page_owner_sort.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 35d3d254941c..30b3cfc7eeab 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -391,17 +391,14 @@ static char *get_comm(char *buf)
 {
 	char *comm_str = malloc(TASK_COMM_LEN);
 
-	if (!comm_str)
+	if (!comm_str) {
+		fprintf(stderr, "Out of memory\n");
 		return NULL;
+	}
 
 	memset(comm_str, 0, TASK_COMM_LEN);
 
 	if (search_pattern(&comm_pattern, comm_str, TASK_COMM_LEN, buf) < 0) {
-		free(comm_str);
-		return NULL;
-	}
-	errno = 0;
-	if (errno != 0) {
 		if (debug_on)
 			fprintf(stderr, "wrong comm in follow buf:\n%s\n", buf);
 		free(comm_str);
@@ -514,19 +511,15 @@ static bool add_list(char *buf, int len, char *ext_buf)
 		return false;
 	}
 	filter_result = filter_record(buf);
-	if (filter_result == FILTER_ERROR) {
-		fprintf(stderr, "Out of memory\n");
+	if (filter_result == FILTER_ERROR)
 		return false;
-	}
 	if (filter_result == FILTER_SKIP)
 		return true;
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
 	list[list_size].comm = get_comm(buf);
-	if (!list[list_size].comm) {
-		fprintf(stderr, "Out of memory\n");
+	if (!list[list_size].comm)
 		return false;
-	}
 	list[list_size].txt = malloc(len + 1);
 	if (!list[list_size].txt) {
 		fprintf(stderr, "Out of memory\n");
-- 
2.51.0


