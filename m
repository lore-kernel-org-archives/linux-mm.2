Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD84EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969246B00AC; Tue, 30 Jun 2026 15:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F38C6B00AD; Tue, 30 Jun 2026 15:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9496B00AE; Tue, 30 Jun 2026 15:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 413C96B00AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:08:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B9A316836A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:56 +0000 (UTC)
X-FDA: 84937516272.25.89EF98E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 21194C000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ihv+3f+C;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846535;
	b=C37mw7AjN9iRsTm+T34KUct7uAXcT0PiNTCOUd4BaIsvofjJgvo08OTcKRRav/PO5gXl8o
	BtPpPoZvobCks/It0jY+Z8WyH4QZVBs8rlftVJV1lyKVTeK3xPWTMI8ucyYNsA8lwK3r+C
	UZsHWB2ZUU+rEk+tdxrMil+7BQ7G0F4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bme1R0KydCT471vE89SzSzHkPBH2aH3edsvHBOUIvRE=;
	b=QY/NegKidGMhWQ9NBj0lkrZLz06k67P8q4QSUM+KsTotrWPqep/59Ede/tIaaOF2vWClHp
	QSSz3TH1kHAHPzCBBaWSAG1wdPVYHOqvfI7E95Bdfo4tqT8vTwgc7P65PuumKX/t9Md9fL
	vUU0OHjCCZ1Tk2I+UFp8+Hbc5pctvhM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ihv+3f+C;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bme1R0KydCT471vE89SzSzHkPBH2aH3edsvHBOUIvRE=; b=ihv+3f+Cr97F5QYNZudldtY9bc
	L1QX35N7kfQIchhMQJupTYWfIBcxhyKFosTfuu2f2LDwclXpD0ER/7dOW671c74sWdrVTYROb/v0J
	namy5xUL5CIEqSqhZjP7Q6UjJ7yzC0XEQZ5S3xQ/jseRHasY1BFKjcGrebbxoKqfoMY36S2z/iOkQ
	wR0aYKY/3T7o2lx/D+9gE9ZGe6YNN4w77w65WndiXkJ3YuP1oDeYHhBIiJ2fIoUELOnz8Y38sKWCb
	IzzfMECCzNninqXw/WAsWowRVqOOiLNLhMdPDtLVYuz/QN1bnx7IBKVOAb3ceNsMNA3RzDKC23VNt
	ygZwxFvw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpF-000000005q0-1EXy;
	Tue, 30 Jun 2026 19:08:54 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 04/19] maple_tree: Documentation fix
Date: Tue, 30 Jun 2026 15:08:28 -0400
Message-ID: <20260630190843.3563858-5-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 21194C000C
X-Stat-Signature: y1ykm5po6f8dpi1tdxgxs76ixu587axm
X-HE-Tag: 1782846534-511373
X-HE-Meta: U2FsdGVkX18QRZfO4ySiXdATy2Lxg+tRb3MojcMPVxhgC71ayH3zvb97Qpnqkc4xXCLoxCjRS5A7OBboQEpjoHsLJce3GL7iOQwQqfEktUGvW/EPawzmJBaoUV7CJS+M6bRFj/PCOwQNNUsvwnjrtlcjJTlP0Iu41GeuzdAJG8bgSX7UmykPp8bkRBDa9SHi6j/a1rZ6l3GP2/Pj2z/2EMhgnmQsXpTNVv0J2Ih5etLIhQkjyAsvvQ0l6pgySeUj3+E0Wf2Zh/3gS9ECgnhQAAIKXFUi6HkPrB1J9cvXbTuJP76MYH7Is03X1pL5MvoRaLI6KWNZXuG0sorjMG5BxOXCy878sQo61jhcC8aczEaeitBiK03KxYBjJxIiHcEpyfXL7Qp8y6BUt1zLUari9UHdXnQGhSDyJAlqdoLQwllZRW7PzDfiRjn7SYI2hm7xIm5Qo4LniA7ZwhVO9uF8lZebl/buNAf6a1npfPH1aUE4cEVByDiw1KFPoLNMsFe0A9Dg6L8GVmxbo+RmdM0Tkjkda5Ws0xCH1Dmn5m5G9KSicNB6DkWQSf03gSb1KdGjwDF+LJP5J5vDzE7O8SKSg2O7UB6ojw1vqjRRGz6lhlUAcnMl/6jTWA0PMo1SrmEm6FA/ZduPRDv+a5VawsKgFfSGW/smAMGeKnNPhDHF/H6bPV5g2pDysHRoNsW8vHypbc2CNnoGGXSmPvOG6ec7uw/WNzE6o19PbaoqeI4PPLOQAHTXD7TyjdIz3Vb9dPINlVknq8Eper+u2dX8ebNRuD85/5F/bAAhR3eABdp0HpU1jegmQHpnlSB+XBRsEYd439XjQUlQJPp2esILXhn6QWDUR9d6vUBS+ZR71YWL57yHAiVcXaQ3Zx+7TFctGjGFHuKksFBL+r7J2usXvVFa99kpMjkPd16n9zqVv1H5WbK/37PedsabBqb7jJF/xF6X6cRYh9fTDrjS8hBqkJo
 GTujszzw
 GDV8ZvRNnLmhuSwLAw8I0v+BJDj5rmtu9tLZe+qaOD7IuUb0/SEnJJ2g/VdkODV8eoIsS/1SnGm2mgxJO50QmizXUzffggAtZ9Om8LCk6SLioVCv17uViMelJrBuh8d/pNAZKTuU/e7RsnoDBEEuq+3YC/7BT9TwFi2NPuhXfagZRT1Vm/pHgodBB+Uhzy6D1i7AktQFaF1sJuhhhNiD8pCC85WxnKw9hNx0Col8fQRjk9cHMW11kH56DTTAEfvU4TneVzJKE2Q0szsW3RkIfHS7q+UILTdjtJMWT029yTRoIPkw2Hw63NB2k+vFVA3UyjgtY1h/p2aHa3rfvpFaAJqgGvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't include the word flag in the quotes with the actual flag.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 Documentation/core-api/maple_tree.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index ccdd1615cf974..34964ec88d179 100644
--- a/Documentation/core-api/maple_tree.rst
+++ b/Documentation/core-api/maple_tree.rst
@@ -211,7 +211,7 @@ Advanced Locking
 
 The maple tree uses a spinlock by default, but external locks can be used for
 tree updates as well.  To use an external lock, the tree must be initialized
-with the ``MT_FLAGS_LOCK_EXTERN flag``, this is usually done with the
+with the ``MT_FLAGS_LOCK_EXTERN`` flag, this is usually done with the
 MTREE_INIT_EXT() #define, which takes an external lock as an argument.
 
 Functions and structures
-- 
2.47.3


