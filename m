Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8491C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C6F6B00A3; Wed,  2 Sep 2026 05:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5746B00A5; Wed,  2 Sep 2026 05:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695706B00A6; Wed,  2 Sep 2026 05:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF7C6B00A3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:03:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1EAE1C00A9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:03:54 +0000 (UTC)
X-FDA: 85168234788.26.20FFF2A
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by imf04.hostedemail.com (Postfix) with ESMTP id 521B140006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:03:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=WhPOLhK5;
	spf=pass (imf04.hostedemail.com: domain of liujing@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=liujing@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788339832;
	b=3W0mjVBRRMW9BYp9MzdceUqTNswNvgibzjfOCYAXAU9SpA7uts+IvFUGypUK8K5eZAoZ7L
	zmVIZgab7GSK4AzExxMzNj6+FPqXDplWRKysAMkR2ol9bQkXYiENCpVmB+da6eBebvaacY
	IaYLBKjSiaY1JhsUigxSPOyaB+hYq40=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=WhPOLhK5;
	spf=pass (imf04.hostedemail.com: domain of liujing@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=liujing@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788339832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fplNEK7bAafNUzDWqtSyFlH4rCzQGDWMHxl3XEdOrPQ=;
	b=ql6x0tV0CPOYJZ2QL9CAfGflOM00cwocnm+Jj84LzWvk49ui+Pez6LaKLEbRF578AvNu2w
	FR9sFrlaFiVGzpUuGOFtyX4w/q02HtLcru7VaVg58FtYp3CYHpAzch9bfCuaWexmwapbNm
	qqZ1BJPVCC0UjX8j1CfJ8thu8hZAVxY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=WhPOLhK5DAQNmqO9nekRIADjVRCHupfLTZxbBItPEVHNCGnyVb4amAad0gmWxcqBe3VDt45QsoBtv
	 FdN+nEwqGQYwAM452jqpM3iF54tfn3fdMtS6KMUSXcQArLkg1bJq/Qt6vRiNaicOz7k17SmbZFftbM
	 Mx2r/pq1LGUUbhl4=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86a97e674e13-40e5f;
	Wed, 02 Sep 2026 17:03:49 +0800 (CST)
X-RM-TRANSID:2ee86a97e674e13-40e5f
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.98])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56a97e674d14-f3f41;
	Wed, 02 Sep 2026 17:03:48 +0800 (CST)
X-RM-TRANSID:2ee56a97e674d14-f3f41
From: Liu Jing <liujing@cmss.chinamobile.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liu Jing <liujing@cmss.chinamobile.com>
Subject: [PATCH] mempolicy: fix mod-by-zero in weighted_interleave_nid
Date: Wed,  2 Sep 2026 17:03:46 +0800
Message-ID: <20260902090346.16429-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 521B140006
X-Stat-Signature: 1b7g4xbqbd31971ooh8q7oroqgxhp7mb
X-HE-Tag: 1788339830-4019
X-HE-Meta: U2FsdGVkX19+WbHl0WFHAXWq5q+9gCbwygnEDY9Gm/c2Zo76z8W7wI8TOuWggYIESBL9y6jspV7oDteGeweTAnOXa8f3VTpOXmW9LBkC6usUJXUl1ynpmmtNRn7XWRJ3lg1hrkR2N9Wc8sNmzN5acRWC6D9bATphEu2VmymvULpZHoFo2vaNQ8JvBcpWT2277cHTFPG2mBAHkBfRUeXpsNCmePBTH77TGTmoxNY5qzbC6i1XIQCCwgXz06tpl47NHUKdooNKh1fkONlGsZdMz8+lF0M96sLsN0K6woxI34C2sC7Vf2hjh4COQRinJ4MZ2MgZlmli/rRb+UEgH1MlGhre/CgKR54NHpycGi48vnQi1C77wbBsEabN0IW0DscejvjkAytimczVKHvxM6i0ZrJW4GIi6RXk1b5FggAKaNw4ST1ZGNuVgdyM/SXYkAvoKGZxy/5DYo8QWZucvqsCVjASx4Blx0aFGNPG2i4dFo+tEOqhzyXNKj0qdEgqsZqXAM61bf4BgPp4gmc6zoSGQQIv5lvufJkBsKMhARkAPh4+AEOY9/y7IqGqCWJJfKdj8Kn2Eh9gF1o2fGuFwKD+LbLyl0SPiRy6hy6RYBOU/OY2SGB9vhYBhg/SrxgVpTePV3iF4/EImyzPqyVSwaSglwBg+FxYRLzoIVELn4a2d5sRCYtTgF7DV52dIexXAb0XALUp2lugiwrlOP0lXBM/YgzYLZfPCr7hNDrgr3RJVaROJpoWx3EgQQe/WIZQBWNbx2VQX4FQxp+iOvm5zT8aDu2vPfw9yVBrjax8OEjEvsnS1bQJVDsHsbfaWgFYJ61GqPIfmy6Qayu7bBLb/94PQuLlqVLHnNNp1qWoc6fcolHLxseSQV521SiP5jCz/TJKZbXC2vNpix4BJb8QAd2CZillrK/XAY9BGCMNqsrKMAjHoMPIVJsK8W8GbpW8NwQ/ST+jFnadISgdYsiW2Zu
 hoAJJiV5
 A4OxnMTD7jOcB7GKcAXMRtuqxH3G9PydBEJHU/0yVxV1XU7rnvi6Qqyxk1s88/amZUPOW5zDQstfyry/yC3PsFc8YW2auwtlodIX77nNwZenUeQZ+3GIidfmhMfYLNs6tRr7mAGu5Ss7Q/8foCRq5aWnSS94EAzc4s8u51LnA0cySYbW5tGaFHcYWmQKt8PkA3fwfj1Nifc1tWkRUsSmTylHztghnfMJABnkCwZ6l9Cedt+Bo4BQVcELxSsMkwu17U87CuFfL6TLGvw3YxHrfCUan70Nv9q/B21753J+Icc/dl+S9BJgVXO2rvFzRNtIrXPqZL3j+WlafP06rY5SIFwt2AJSf4WZu+MvdC2T/OeD70Eu8SFgxgVt4N6RXdPWPFBBmTtaviFcSlj028TRMfUUeIXxfF8dnzWFpcn6dtLzJeG2Q9Q64mOBa7YXuwGAm98DFPqcJC8nJuX4Uss2FW6teKKJd3/y4iagkjYbNiof1ADgRSP2YGlP5LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In weighted_interleave_nid(), if the iw_table contains all-zero
weights for every node in the policy nodemask, weight_total sums to
zero. The subsequent "ilx % weight_total" triggers a divide-by-zero
panic.

Add a zero check returning the current NUMA node id when the total
weight is zero, consistent with the existing !nr_nodes guard.

Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
---
 mm/mempolicy.c | 4 ++++
 1 file changed, 4 insertion(+), 0 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2218,6 +2218,10 @@
 	/* calculate the total weight */
 	for_each_node_mask(nid, nodemask)
 		weight_total += table ? table[nid] : 1;
+
+
+	if (!weight_total)
+		return numa_node_id();
 
 	/* Calculate the node offset based on totals */
 	target = ilx % weight_total;

--
2.43.0



