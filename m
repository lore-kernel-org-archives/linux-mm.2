Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDB9CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4D86B0005; Sat, 16 May 2026 14:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E556B0088; Sat, 16 May 2026 14:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C826B0092; Sat, 16 May 2026 14:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3FFE6B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 980B11A03F4
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:27 +0000 (UTC)
X-FDA: 84774140934.01.040EEFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BE4E4C000D
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E0G+VqSx;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUjn4VM6HCECCOLwoFQIA8RXV5nFXwPqDZ3mG51DVmY=;
	b=wTojiLigNKIv4zGO6019JnHExVG6QZGleytDoN6JYBr3ge5R32GhL4sOTham+8olOdMnrd
	j8n7w6Yh1ixPnDrKK2fCLZe+rZkqSaXApXd4qTGGbK1oGSm/gbfviogrJG8UzkxgMqLx0z
	cNmaS86PdA9iPSbB1fOB5O34dC/t6GQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956645; a=rsa-sha256;
	cv=none;
	b=sFspPjV9ycbZV8u9Dkn9yizkDQqSeDKr5nEHBlrmDHq3tSnMFRcvoaqWHqTww9SrFv6sjo
	/Ka4kGn5dfH3RQGHH/YPqJqbZpTYA9MeuNpTkLrpqz/5N6CC+KN1NXin7JWp9Q8ZvqADNN
	MYWU/fKtsTQRr6l264zifyowDMY8qTw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E0G+VqSx;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E213344520
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EE2C2BCC7;
	Sat, 16 May 2026 18:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956644;
	bh=8LT/D7TOnQRawE1lXMWBuu0a3XIQelloreA4qB43lWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0G+VqSxQqhSNOCbM6wsCBGh67QTMlXR3OfSDjxrOghE6HDSvj2vv202wLhLeSPeN
	 KROOkX9U1IrIzXNSiHPgtoW+TqB8mfvmn8eRDBeNIEPC68ZPPg6mqx5SBtuuN4DC0a
	 r8lSkbV9G0zk9XBIuo4k2tQ0UeEstaXv+JP91An35qYeqs4b46geQzdKuyZRNAg1Fd
	 h6diPSKky4SwabKoMGvaZk1Bz5c3dkji2+e86kQm8MaLWFRTwS8bB5/Zb4nhi/S4C3
	 dngs81oA6Yk3r0SR8WhZoPSNKsIMe91NXhqykxlY2DybUxMquevnAZhlQ7p9T64AX4
	 BkUk8bO1TjBBw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 01/28] mm/damon/core: introduce struct damon_probe
Date: Sat, 16 May 2026 11:36:42 -0700
Message-ID: <20260516183712.81393-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE4E4C000D
X-Stat-Signature: 8m3u45ozejpr3aiuyxqobdam8wp6aq8j
X-Rspam-User: 
X-HE-Tag: 1778956645-162443
X-HE-Meta: U2FsdGVkX1+iyX++Sfkt9Sv4LVZ34KvoPlPaPL0BcTPvBBjzH9GpoRQJ08fIKH8K6UubnRsn7My2drzSawevkSq9q096VdodUiMWd77lvi0YLq81rNPteaGrzNJf+iC6/f4jp/60CzWEgjjkrEqm6zIoYg2YonWmiV8D9wq1iI9z95Rktu9rLxaLW5Owc78XZJrFZNtfB0JnAztsVp7zKk8P2iO8LlK9Ga1O29OQRJZQalBtWTAZeB2Zoa2D7GmtbhoP+cL/4OoXfzLOg/+YqaSaNNCHeLeuoKpKlAfqQ1T/gn6gyABBULHS1r13oXBma1wSqWDt7GDH8RCCHbH3TipiV6OjeA+sdO8z8HWJx8L1uoQMEs8dwA1L3/l0DESNrdRfQQRSLL8apqaXXxTbP+2jKM4CMS8kwD2zLciIhihJAOgavac2TlNb+QfGOWgQoigCB0BxtQfKhemz9T5cV2I6W7IAWW6mwhW1w4Yqy/Dy80f9z4yCkqNtIfRmFaEw5CGNIexoEK+UWlQFpqFLxOVOn+fSfCScdaD88XV19CJXWbKX2xTIaoGHosshgoKoEIWoPunrzsdVd05lm3LEnfIvjjaBgYEOBb7WwyGmhvop93FwPeb+BsLrJhxBbBsCb073hyCIXqd5eZ+sDb6Db6lx/z4tzLFG9KcxQWjP+TD6+Zvzuw4xzg8p2JDEdkXTck+5bozAz3K9rHIQZ6i2RT6n9qgePrhEIxPzpnAqjmhT9zVHUsZgo5zrKyNJPLe7OdCysKi+yhuG2f8ilJkYQ4l8uoAhDj6eHSHpcbAJFjkA2plZtpZ0pYBFap69Yye8CZjQDQG7IifWUk5o+NeJgDAHn8hF3NxX+Q+6xPJDSo4brl6W7v9eyALRViSCZZiziAxpZv5TOAr/fC+xWtSJpxXrABWoWUzIA/BjXN5DQXn0lGt71WXPwssrUKZAFPnOzZjDMLBzaaul0eYmJOv
 cXH+aMnp
 LskXwLCqM6kpGCJWpX3TaDgH7lyYqHRDQn3/YXHViCDJM/t7s9dNdLkXafQZg1azmDF4LJo3yLYTa+7ayiqru/OHxINj3YqOOk3bwQf2oqbdMJNu+Wq83jbzdlkjH06gtmbSrCdpWk27bqDtcwb/HlmB3xRWm+gAYqBnbQ7ce/ImjXP0ByBc1bzU8BSNk5mETn+eLgBW3kRnUzbQ6kSEzIQjQBr56WI+b9FgGzMGCh3mFgIih+X1hYDLAEt7DPkIPNimdtXBmJnLa2MhrPCr0b9H1coB+DiY6n61VE+Ub37xw75ksQAToixArhuOOuS4VDJpotnjnk94TXxc+MQ5ALW7T5rj7TNyvgkRrJE0ALstuHwTGMssGSwMPGlC7A0QNJm5z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a data structure for data attribute probe.  It is just a
linked list header at this step.  It will be extended in a way that it
can determine if a given memory has a specific data attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f2cdb7c3f5e6c..a8fff5325b010 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -721,6 +721,15 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * struct damon_probe - Data region attribute probe.
+ *
+ * @list:	Siblings list.
+ */
+struct damon_probe {
+	struct list_head list;
+};
+
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
-- 
2.47.3

