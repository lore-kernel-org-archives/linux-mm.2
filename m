Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB81C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3893F6B00C9; Wed,  2 Sep 2026 05:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3126A6B00CA; Wed,  2 Sep 2026 05:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200BF6B00CB; Wed,  2 Sep 2026 05:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F299B6B00C9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:04:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 706451C0089
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:04:21 +0000 (UTC)
X-FDA: 85168235922.08.B34F0E4
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by imf14.hostedemail.com (Postfix) with ESMTP id A0EB2100008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:04:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b="g2SNlN/J";
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf14.hostedemail.com: domain of liujing@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=liujing@cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788339859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tKsVwZ3mfvo6a6i11lVYbo8ab8Agwpqf/25cAKwEuZ4=;
	b=dfJszMb8U84ClkgitdZB7cOKeTsHuzw6FBKuR4KCdNxWCn/KGhYLhlpsowOUoVENyb670h
	iwWg21Ch8WfrqwtvV1OAVQBGciS1Ol2v/JyMp0mwnNNhkh/WH06uqCU4yV2uKEbsg1R78w
	MlSr5TJKB4+IrZ0Fr6PQVILdaG4Mcnk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b="g2SNlN/J";
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf14.hostedemail.com: domain of liujing@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=liujing@cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788339859;
	b=XTA6wHEuocg/FJAhgE2YY36rkcR3DbD452AurL2IoIU+4l+8fgXWTdNnuAcvsEu4KcTkqR
	Xsz8SttZNKIxBPXmrqoB2mAIGDEaMBoRldEFjfMp6kP64d2DO7t291VGfMlU3FJKtSwDWg
	9/B1jGJQBSLzMcQLOPCLB+Kwm1d8l2Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=g2SNlN/JczMkJs7a7TXc4W0QX7yYSpNlnPrZuE7kaFJmbzQMgOoLrW1s2M41CddLw+3z+NRPogH0W
	 4XglbrZawWjkSUgRiHSVydSuoKJSCmyOYSfybPyHbH2qYWGlKN3KDT9md/VWFREdzMc+TXOD0C+X57
	 kOMxPL1yu6kLig58=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66a97e68dce5-6e884;
	Wed, 02 Sep 2026 17:04:14 +0800 (CST)
X-RM-TRANSID:2ee66a97e68dce5-6e884
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.98])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36a97e68d044-f20fa;
	Wed, 02 Sep 2026 17:04:14 +0800 (CST)
X-RM-TRANSID:2ee36a97e68d044-f20fa
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
Subject: [PATCH] mempolicy: fix div-by-zero in alloc_pages_bulk_weighted_interleave
Date: Wed,  2 Sep 2026 17:04:12 +0800
Message-ID: <20260902090412.16445-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A0EB2100008
X-Stat-Signature: czg37bijdhkix7j46i6jg6m5tf45xwsh
X-Rspam-User: 
X-HE-Tag: 1788339858-28549
X-HE-Meta: U2FsdGVkX18FaYW5LYrdpKhKaHcphDFwyT1Nfh1WlD2z3lbSN01UvQoLHNSgPXNy6aCB5L2NmApAFXoGVRGxX/5bD4WjG/lGfzMb2lxDKl0V3oEatXZl20DNOYUrLeMd3mH9SiNbkslIg5ljOE6p3C0Sv0dM5wvUeZ1r6gdqonEX6Mt0THAAg1wsnI5ZabBYiE30fYoL7t6tm3tUXRXR8KM61FV6HtNFUFaeLMwDftU32g42rEOej3vH0mIeA54HUd0enpwsKSYWsoDgne1N+d3RDamUUMDPntMqxYFOtKqRfzm+NFr4Zczina7QNr/YZhXvdhSV6trYUXzuhZn3Wb1pkQ9yloU/CW1Ato5FU/MgS4wmrUXEqIhh4TXZ2UtXF37qASMFCUhEatju5WAl52PK49ZrGFF30PyxVrPErZWcmQOr3qCmb4Q56ZkAIL/Mx2hILRdGrkbToNvYS14g7psHA2cy1Ntg3+clVWO4CPa2OYVdY6wYq8nWCLWfb80G4eq2EsVdTQmqkBo2f0pgGzIAON+R4e40ZOSYpUMNtxX9VQpN858TnG3bnIY0dsGVLj6disqZYbGMWkb+s/pZZLhT3aLeWoxzMmXAi17CIjWaOz0oTDvpJObXJEfiW8onVdPlLrxxO5AzmsL6hnLD0yW6e5IoCvzgyhBHE7+P/2OR0pKWgGf+WDWNyqGPK61GZuUA9Lp5ebJgBFVbRTuX0e5wDE82VZyW2YngJUR6aDY74FPvDoc6Qfn1QsShDudIcywClVQJM9AZkATIX2nuu9Bd7eYnTbLwaEHQ52TA2uQckpt6xHoqcTNw5qw2blq/1jolAuLKOMqr6+zNIMfAXgmuxJwQ8CYM9JMcpVRjSsjPuDppK3umczWj74Nqvm0+M+3KMcQEh289AO2QeU6MBR1dZDfGp3u6T/VUslGqu4q7u81cSdvMXgLhxujJpGvt/YjJ2VU5vSo0nh8Iu7P
 TiDQo9In
 hVlus6ab3eo5rIDnK3SFDH069bVv3ExhESIT6+C6LSP3b6werg8s6M0kN8sOApjPRqiG6LURk5wf1rWm4KcmcucMOL4/541OUNXKfHlUGYOqqXbi4QIjDxCn5vWpXegEPsmQQHjCW4A5w3X9Xr0H0MBfIZJ7rBFKEESHRS9e4nBBY2ubFPi18OEgxdGODUh+BvjBAuJm36MCXwR8hAOlGcZsIw/3NJThnHTTnejIUBUMVTxt+Sqk7En9JHaFpwAIHhqw23VfHhopx1t4kZgYfmIAuFmPvfZYQ18caiSKBuurTh/fCSUlQJ7tk5XkpAlfQZEYmSnol7XD91A/GEC5nK8wa29eKnAC4FPePvW0YYsgxeKumceo7hI2uvMgeCDZQzPlOHgn/HV2ZWLvwk05/jGa8Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_pages_bulk_weighted_interleave(), if the iw_table contains
all-zero weights for every node in the policy nodemask, weight_total
sums to zero. The subsequent "rem_pages / weight_total" and
"rem_pages % weight_total" trigger a divide-by-zero panic.

The function already guards against !nnodes but not against a zero
weight_total. Add the missing check, freeing the locally allocated
weights buffer before returning.

Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
---
 mm/mempolicy.c | 5 +++++
 1 file changed, 5 insertion(+), 0 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2697,6 +2697,11 @@
 	/* calculate total, detect system default usage */
 	for_each_node_mask(node, nodes)
 		weight_total += weights[node];
+
+	if (!weight_total) {
+		kfree(weights);
+		return total_allocated;
+	}
 
 	/*
 	 * Calculate rounds/partial rounds to minimize __alloc_pages_bulk calls.

--
2.43.0



