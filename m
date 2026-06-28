Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CDD4C43327
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A3C6B008A; Sun, 28 Jun 2026 18:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314E36B0098; Sun, 28 Jun 2026 18:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166476B0092; Sun, 28 Jun 2026 18:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C96066B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:08:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22A121C34B9
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:08:21 +0000 (UTC)
X-FDA: 84930710802.01.65308FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 81144140007
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:08:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684499;
	b=zAISa4jgdbU/dlRcIkqErU2PUTZQhMB/31W/oHguHGFt/TnE9JjhOPCv9hEDWfIE7i2JBZ
	/eJGDcjnYnt5Ox70auvc6Q0hEGtdctyGmAVXGtH07g96xhpmyAbaoBWQKWyKn8hA1NM6mS
	DuhV2ZeeHB8R0WKYlCQFjg7OXMbHXxk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCvagwLBIdhVU2TgKRnBg1P++CrwsYjOSEmAd1VNodI=;
	b=qRk1zyYAkgx7hzlATQ3xb8fW6FwO9YGKPtr+oY8GpsLIQNNrjo/Yok4Gi9DIFzcWHXmy0n
	YpsqGTXYOdubg4uQMnHYne/J6PnYtQpU33G5ns0VsUfmwRBIp87kLfk5xf7yJOBikgv9hT
	DLwUBdFFqpHqDJdnvRASfq5AiMlWmvc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B36143923;
	Sun, 28 Jun 2026 22:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF9E1F00A3A;
	Sun, 28 Jun 2026 22:08:18 +0000 (UTC)
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 1/2] mm/damon: add a kernel-doc comment for damon_ctx->probes
Date: Sun, 28 Jun 2026 15:08:03 -0700
Message-ID: <20260628220808.98931-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220808.98931-1-sj@kernel.org>
References: <20260628220808.98931-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81144140007
X-Stat-Signature: ctc1oonagtf1yf9jyem5diwt9c1jgoub
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782684499-462972
X-HE-Meta: U2FsdGVkX1+iKBGGWLNtD63yVINQ+lsolF+L5ZWGdMBHw0LSY2QLVTcB3wN6dprcfvTBHIGjq5YuuwCgA/rQ1ntSsZmrd5wylGiznH83goE2iaU/bEgqjN5VJ4i7kj7iheo6b0Vn7IMmI1HTAAyNjfjmw3PErsjM6YedinVnBfgvL/Dnn/3N8l8KdfyuVceRpmjHSZzIlIoaGM9w68zfCSFZ/+0RjznrEaPI1wIKL72blNNkTO0tybhHGgvqdpVaAP16pEljBGIjtI0mkycl88exCOf10sBrlheWIdUM1fi649DKzaJ/hgsmCyRaJCTcv7TwNTe84y2RkgO9hd34tOrtS+cCHJ6dnrbc1kLKMkG/whXVcejru7X6ApGAnzqRIaQ45ka9IS1984WSiEm6wNr+gGrjR6wPZxrm9fjKH9C/LSvPXJXm3AeIkvhj4K7CWFDeF0L2buI1mPVNfjwtFlJ6ZyA0SJwKk0S+pe20br/k+41FTHY6i7AGopNtVSvsEE3bgUHGh+AwFLJlgB6i6ytzl1auGALk/E1T1vzmYgisD+7+LuCrTou+ZGMWESnwYfTeCSn542xrOzOqj4gaDfJM/TYIReAKac0i2o88mx+VG3M/Io1m9vVkTxTQGLqTt8gaMohAcIlaLiFBvMyzA4nmIBZG8jfNXGjDBv6CmuOeXupNPl+jGSvyC2pBRAXGXLU1koOqn0iknJnO5sYnJsyaDlVTj3LttHlvWQP/ItwVoyTIkAnYvRB+U4X4fpXBfcuu2WrmWDwS7jvfEdeExpanUeZi1tLKbfPhOseMufhin+Y43QODjHEDJhchsHsern4jQCzEVAOA6q5HGyGDBiyEoHbBwJKwi9UfMMBpBaqf8OIRU/KsQ4mb5mznUUKkPmQIiKfgVnRLoY5CYec8aPIAOjmRBeDc2A1LBzyPyRMGCnoMFGYai3662y+by88WinsuNEE2mBOPakzbMGH
 zKvUvU1e
 yKgyjiGAMlEFmEpqYHgqhB4rLpPLmMVkoXbvP354tEs1ToSfUYe7ez5cvNvx+3Hyl9Pi+zWVg9lwRWCsaabKE+w1+8cMLq2QYLTeLnkRPJGoXe6kIGup5eZ5cpd/5d3DqCiis2kyp8LUh8o30MLOFFayzmT4IcugClYoKJK/sCuP1AcTkCpfEoDh20p1QoXAop6QwgwiCkD/0YvitSz+ZR7wsYa3L2HRfzB8A2G5Jwd+87G0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix below document build warning:

    WARNING: ../include/linux/damon.h:909 struct member 'probes' not described in 'damon_ctx'

Fixes: 18c777859f28 ("mm/damon/core: embed damon_probe objects in damon_ctx")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/4df95955-b255-4e5a-90c4-35db02f3111f@infradead.org
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 783d921075f25..535f675625724 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -841,6 +841,7 @@ struct damon_attrs {
  * including damon_call() and damos_walk().
  *
  * @ops:	Set of monitoring operations for given use cases.
+ * @probes:	Head of probes (&damon_probe) list.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
  * @pause:	Pause kdamond main loop.
-- 
2.47.3

