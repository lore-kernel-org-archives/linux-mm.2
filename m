Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59B43CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 16:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF0A6B0005; Thu, 14 May 2026 12:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF716B0088; Thu, 14 May 2026 12:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5336B008A; Thu, 14 May 2026 12:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAAF6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:39:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01331140621
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:39:01 +0000 (UTC)
X-FDA: 84766584882.07.F1B16D8
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf26.hostedemail.com (Postfix) with ESMTP id B3EC4140003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:38:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=UtJa3jas;
	spf=pass (imf26.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778776740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90sYDCP6cFQeYRuHYppH47Fjaln2BdNElNJWhH85jfE=;
	b=2ioyqKBly8h5gijYB2rW2pwKs8ims319zyPQ7o3rZMzifon2Jq+V5QpfESF/eQdQO7DXUL
	GVUNp7t9SkUQl8nK6L7BcbgSoTD0BYvddaZRt6GPdooptIEg0l+tqWbI2I2baKjQUKEYUg
	eSZfUOVOty9fX3aJ5SLvZmax+yohgtw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=UtJa3jas;
	spf=pass (imf26.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778776740; a=rsa-sha256;
	cv=none;
	b=6EesX4+trotplAIFdifTNBgV3lzrw5n+iW2CS0FvbZEsYFiFFOEFA1EzLXODS/7C8bwFSH
	nvpd6Y4txZYLfvCZxdLDHjcs6sVUpGAWk0OhdmVM/MhACdqUo8qvL1h0PLuArkoTMUSSax
	4aM0oO9BBJ2auaWvLVCJKVDUx8MvsSw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778776724;
	bh=90sYDCP6cFQeYRuHYppH47Fjaln2BdNElNJWhH85jfE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=UtJa3jasIovLabVthXPoVKZliAKRpQNmUBu/k6Nij7BFGc5+9lV2r6xmdMaA4id9e
	 KbEPEtgrtO+uXpIrSOF9my+73hksJ8zj/3DzLDlvYKVlvDgKfq5ooP+JIj8idRQZLy
	 /YvAok+dPl4abOLWssA+pSBRQMxy8NtjBYW9D9Ug=
X-QQ-mid: zesmtpgz9t1778776714t909b7172
X-QQ-Originating-IP: MYsk0LT490WrBPf+tCsfOZrAcwLQNMcMIuRTkPBsWlE=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 15 May 2026 00:38:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 441675532033700949
EX-QQ-RecipientCnt: 7
From: niecheng <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	niecheng1@uniontech.com,
	kernel@uniontech.com
Subject: [PATCH] mm/damon/core: clarify next_intervals_tune_sis update path
Date: Fri, 15 May 2026 00:37:51 +0800
Message-ID: <D3B0C1F5BB6ADCE4+20260514163751.3399513-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260514144102.120203-1-sj@kernel.org>
References: <20260514144102.120203-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MrhTsisqYA8gLo8633ivgZY/ypDo46XMHXBmmZPYvzEHhjOFNwogQbNI
	SrEeJF3qD1ab7SufvyiPC1YpOJNpEWaIXiR5jvJne7bmLWwoti2rQE9tffcs/KgVdzXucAA
	Pyu9wXjszvI+JGsQBJK0gN3t3DlNc6Alf7axIuX9UoRKWk7NMBZYALKVF15gEff6oKQFTY6
	1q74V0ry03H8otDM7Ztg/Fb1pkmL5XcWw5R5IXlyHUlFvaBZ5XH2PB1et425hKMyMBVJw4F
	hwnVeh0fRoBImKAsAkbwzOaPxyzbb3xJPrcXLaou3HRPwohvGEL0mBPipu7Hp7M0LJF5aKE
	MOt5NwX2IF/PQlnhBPQx1hUiagJ5ORf3ZTMZALI+D2C2KmjMPhihKqDVfP9OqJeAONx3qCn
	6XBHJcJcO0krDVOrjRuhfq4oBMTB4nSe9dIN3F46p0S/klD2QucN8hND4tc9yiG5TeeGyt+
	RbN2NpEQACLApivxYFUJm2rL0ERyMqN7MIndnH4AL1P38YUStzEdbcHy49qPzIHLZ2bu1xz
	73FZ4ULw9DyFkTwkm9SCc6sBIfvzDezL3GvQr7JHi249QqBLHuupNecUvx/u13ThyOcRwGM
	jj8Fe9Iyw8j2xVtf6edRmBweURviYjq41lUwdrnrDadETqaXo+BY4666C70/TPCr4111YRo
	KwYVaMuVgRpK9rMi1ravoj5ki1Ibkk5yp1dOclvNaqAzFv9Cc74ozJ+y9J40REYNcC/KyHD
	jkE08AVhkv2QWknLaQ68KAYOEkLFrT1Z7toxATPgYSgkM8HC3LZWFKhJq0ZhO8ZjkS81mg2
	/CM8nhmzmxnK9p0iRNGxV3vpAH1+JH2p5uxvAijCWa2ezLAeQ7jbxNuNhJE3JX12qp3NT/S
	xefTWbR/itkWBQ2g8t2R3u+MCkSN6ZPhU+0hhViSf9WQPSyvNa+M2hTtR8y7CMoHUSmP++d
	kgLasKM2Jhs16UcgKgPLHYAYeT0SHuwYgy85E4SBtYMcu4e0pmOPFid1zNwH6C9QSzNoJl6
	YZjoQFpPNFZbVdQeNnAOHi3avHnDyK1PN+bvIzQPn50soSeySDrnVGfLXooUGGowW1TVtO+
	V2LFOAzqab7
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3EC4140003
X-Stat-Signature: sfktas6qtyyd6wfwzncgzehnpi834cbn
X-HE-Tag: 1778776738-100992
X-HE-Meta: U2FsdGVkX18Z/9w42EnwTYTwW5R0LrSUVpZbKcrkBw9tKMdYUx24M5AYageLtD9FGlv6pCsQAXs+JFRhfKYSb/3mgPYz247F7xt6IAF2fwwP8ouEbDnnNcVpaesUVtg4S0wuwnDv9zSxpl314YQGA2gq+1pf2bx2Mk2UVSeqDPSzuZVkbnFKOAElJeo63LEb21I1QclOi67khfThFnDGek1t/KAQUpAruXJmSEOfze0VCw8xC71CyAo3TWI5ABOpzrx1d6fCT+qxTWXmPd28NTkoBaMHW4ViA9A1J8GYnkwyNFejj/wr/RXfJuJ+ZrA8/iUzNSBJDypEalqNXp8aOPTMN4EcRt0GqY3rqwCczQqqn4ZjXGHgw7XFHvmRmjK8JKFDvvEGHHKJDu6lkSxC+8Wc9eKYteR4wi/Ru+DWP5ZaYyoo6GVP/80zmsGccxfbwKA6nQR3UYgug77h3VNwsuggFKmBbZp/7yYRdtPd4nHGpWExq9QBUC8029zr7V1/R99mdwVaqSjI40XWma1ps2fz+4nlehGrntvbn9syNR7XQ4w1M9fFHcrsJ+2uUPPhQdK9Qx1MLmYIbDuj4Cbia5F9GYLH4fiE2hFSMkgE9pkOBHAnjE5fng7D86MHZcSMiwgsVPMUpELstAqncwAYa8GYpmWkBBUqX2uun4CP2e/4Qf4iQnTCAhTc5v1ZAUSGjuZGyQFlGwvWFR8cTkFDZY/zanut889JnCf0OL5AM6/TSG8XUQyRofyQmLriZJzVYSrUfhY1wWlOH1XyWfT79xbW1rNxietv8gRbdl3d/KZnnI6wLSGmGWCrv5EZlJwNTfrpd/N8NwMZK/l/1m7KfI5VQzx2JK8ouVc2Ir/lQNH2+NtB0MYmXpTNX6E09Ixpg5hhebjq4Q+o/DDvSfylqSAOn/YkKzc47NSQqkjIVoNfRiSkAcZsH5GV6t4DcSKIVHjl2V0+2vmfkcTOCHS
 A1lcTO4g
 Sn8DocJZTwYG8hU7NiggzUb39KTVYgOa78q24fhulUWnoH8y9wjqGiummdpg8FUdoFoeSMWNL8QXBrMUy1Zae3iAypHYcC6JYsAFMUGw+6LovdZ3YFq2tmde4BF/qw6Sy0pfqdeD/xN5MdueiztKyoP+z6fqWvCkPqX18iNydTch/JsCTUGqGVmE7odR5WXIwcKQfeoBuiOzgfUj3vyA5fKA0EOnl+n2W/96UZSTBwKz0iXm9XjYU8QMAJz9B3h0dNWMcPl50KQ+7ycTXC1rKdgCui7D99rOVkGNclLvXhiCwKGcenXeJ9sCM2d1/yZxoKQsRoMJL2o0hAUdg0lUwhKs6lgftV17xq31/IRRYMlHXlnxoQ8rcKMfjWoMoyGxJPRMgU2DvKz6qxPNy2GdUyggY94XD32R/DuIOq+bf9u4D+Sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_attrs() updates next_aggregation_sis and
next_ops_update_sis for online attrs updates, but it does not update
next_intervals_tune_sis there.

This can look like a missing update when reading damon_set_attrs()
alone, while next_intervals_tune_sis is actually updated in
kdamond_fn().

Add a short comment to make this explicit.

Suggested-by: SeongJae Park <sj@kernel.org>
Link: https://lore.kernel.org/linux-mm/20260514144102.120203-1-sj@kernel.org/
Signed-off-by: niecheng <niecheng1@uniontech.com>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3dbbbfdeff71..a21ae41ca695 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -797,6 +797,9 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 		attrs->aggr_interval / sample_interval;
 	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
 		attrs->ops_update_interval / sample_interval;
+	/*
+	 * next_intervals_tune_sis will be updated inside kdamond_fn().
+	 */
 
 	damon_update_monitoring_results(ctx, attrs, aggregating);
 	ctx->attrs = *attrs;
-- 
2.51.0


