Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2545C98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 07:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62A396B0092; Sun, 27 Sep 2026 03:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DB2E6B0093; Sun, 27 Sep 2026 03:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5184B6B0095; Sun, 27 Sep 2026 03:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33C936B0092
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 03:28:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 455051C399B
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:28:49 +0000 (UTC)
X-FDA: 85258715178.13.348AFC0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5BCBBA0005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:28:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790494126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iluSDimAFHR6/f78wp85HsIAJdPT7YGnO3GEEIScE68=;
	b=FdckKx9TNW8X6262ntQ5LPRtGNrpZKnJ7+dSWyoU+3vrHLY5WhDyulMV5tszA2p0Wd8AuI
	84qsGdFd30xHbHHgvDX2Zm6DoKagbXSAt34u7z3BWAKObk2weT612jEKU9BYudeJxsp4B/
	fyMnHhMO1F/Ig5UiImggIW0cuzXfrfU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790494126;
	b=e7YoywlwlSFyKf4QoSWSMLdeGeWQRSVXWGRbf4KDyXRkC/7bX8Iazptn9Q0dxJQMzj1JKi
	z7xZL/foy74/LypHshkzqSXSqdGqnq1suVATGubq+yKMDsKrtf1KrEvsGIRd3mFv+fUE8B
	WVWja6M15oGZHpmMk/CeILt5q4lOq64=
X-UUID: 0c7a6684ba4511f19a56ed5b684f684d-20260927
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:6cf48ef6-ddd9-416a-b059-825af14198b4,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.19,REQID:6cf48ef6-ddd9-416a-b059-825af14198b4,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:12b878dd324cbc016a0191149a79bcb8,BulkI
	D:260927152838M6OXUQWH,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0c7a6684ba4511f19a56ed5b684f684d-20260927
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1191654343; Sun, 27 Sep 2026 15:28:35 +0800
From: Enze Li <lienze@kylinos.cn>
To: ojeda@kernel.org,
	boqun@kernel.org,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	daniel.almeida@collabora.com,
	tamird@kernel.org,
	acourbot@nvidia.com,
	work@onurozkan.dev,
	sj@kernel.org
Cc: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	lienze@kylinos.cn
Subject: [RFC PATCH 4/4] MAINTAINERS: add entry for the DAMON Rust abstractions
Date: Sun, 27 Sep 2026 15:28:12 +0800
Message-ID: <20260927072812.2393456-5-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927072812.2393456-1-lienze@kylinos.cn>
References: <20260927072812.2393456-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aq4cnzogatq1t9s9cmumhe6e9i4wgn4h
X-Rspamd-Queue-Id: 5BCBBA0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790494124-406891
X-HE-Meta: U2FsdGVkX1+VrtC97MuhtejgnrifM6KxRXnwoeJn4irGnooF+FLJbvk7hw/H6uos24LWqx7vPB8bqhJONJv8XNGsLb5fiVbIiu5TGNmbfU5j3pF1wBqY0L8rRHl3rG3rUX1uxi78sWHXZxYwwk5OLjFoUAqcem8Z0LyytQDXPxVPqwreEL469pTORugB6q++tg9MqGWg+G2hR+Qz6VSOl5TYEu+pqbvmq4CRcUlefbMCrezpeOuntDEf1T4Yla7zN+29zqVoz5fOrnfFarBxAR4sMCRYWGeprBD+mBEpf9gq3/4oqfbq7r9FYZf8EQQTzygFPnY9xZnQtO0c/k0g67YdMFVoV/TOpvFMF1MdMaaEE61Hbjl5t9p2sOeQnxqoLg+PUYFZfPJOzYzOBtqoYpYAQTxXHp9kfcAYpGJHgkwohiJJctuSpsExa1iAIkJgDoc6dsbZMJb9mMZyxMWjiRZlKy2/eJyu+gjh6aP1BH945y003WJExfUdZeGYfBbo1VdU4mw6RQGBI9gy2Krm2Pf3gnEfPc93ljbr3nk53i4H6OwYy7GjxvKPplqSQUZ3BwVkJke8r+RHgx/3iUdzDT8grvXV2Zfkv3O8ljQ2N4JB5ZSNWQfgjlUu2KdyFdB81f0qSPAfmyW8Yf4o5Gi0Xdb2g/gH40VyWVtZ7MyXNH5j+JNUBd5vPYarVK9t3jLgpwNqz5na0H1zPFMqwTM9tVm/kz/mmk3GSLmVj//jlGj+OTYXDWrBxwCttTxvhaJVzj7pYO+Ry8P0uvA/EG2NgEduvCqFHOog1p0lQ1+h/xzCc2DxjbDZiEAahUIwCn3ASagGL5Rzk/iVjjRMy0384n24HyqPmEXK1ScvBFnbG7KOmgPH5cP4/xOQerFxcDtv5L8Y8lR6y/ORiZQl0LHCWvvXD6gO3wYBTeb7zUFjGJRg5kUbNaAeraGEFm11evfI58BlEKgFN21zPY4ojgC
 k3pWEYq3
 h2hPhgD9lzsvRIoFHtDE+s11/LzaSoUIIBLhj5sPf4Pf2nj1i5TaBZneEzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a RUST [DAMON] entry covering rust/kernel/damon.rs and
samples/damon/rust_prcl.rs so those files are maintained by Enze Li and
routed to the rust-for-linux and DAMON lists.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1fc1cb1d1c49..37136171f08d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24007,6 +24007,14 @@ L:	rust-for-linux@vger.kernel.org
 S:	Maintained
 F:	rust/kernel/bitfield.rs
 
+RUST [DAMON]
+M:	Enze Li <lienze@kylinos.cn>
+L:	rust-for-linux@vger.kernel.org
+L:	damon@lists.linux.dev
+S:	Maintained
+F:	rust/kernel/damon.rs
+F:	samples/damon/rust_prcl.rs
+
 RUST [INTEROP]
 M:	Joel Fernandes <joelagnelf@nvidia.com>
 M:	Alexandre Courbot <acourbot@nvidia.com>
-- 
2.43.0


