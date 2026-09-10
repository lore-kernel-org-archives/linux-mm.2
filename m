Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7899C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616E86B00A7; Thu, 10 Sep 2026 00:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52AE26B00A9; Thu, 10 Sep 2026 00:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCD06B00AA; Thu, 10 Sep 2026 00:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 105BE6B00A7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:09:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FC0EA040D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:28 +0000 (UTC)
X-FDA: 85196523216.26.3054818
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 86CBD140004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S2Qnh8QD;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tn9W742GaDY7vW9qUrTT7oroxJHcL95g99YMTLAp8qQ=;
	b=tlobhV4/ppPAKNascZxjvYZaB4oJRmqWb5f0/3y3IQ3w2AjsQTnsQMEqst5rWjlsRgMKVK
	sH/ld7jofvPo0BN8OafF7RoRMS6hgPvDTNpIx8LwXTyHSY6zW88TVqHFXnbLaFt2xblG1k
	bxzjd/3DihxJWqIcL7nKFdWpIZl0deM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S2Qnh8QD;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013366;
	b=nl2sT1/RogicQ0DbHgfn+lqlauQPnlJmGNHlBFVZVYTF6NqdKOEMYlQL0U2EdJ4NUhJS9u
	V+oLXP36MmNJplp2HlJGHU1Ra80gG4NT3VrNlrCxT+sH6ctc2gVrNwk+BB7ZmcyYfmaJJG
	zdmughA/CBuXZz/mJy42BBI/3isBOlU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7815043AD0;
	Thu, 10 Sep 2026 04:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349831F0089A;
	Thu, 10 Sep 2026 04:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013365;
	bh=tn9W742GaDY7vW9qUrTT7oroxJHcL95g99YMTLAp8qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2Qnh8QDjnl8nTroDHuL5cB+wM0QUKbNRJMwH9kuOKyITV0vdDi3Nscf6h2O56siv
	 UZkgEIb4ViAVvJXdiFVAt5YsO6jf9tt56JB7po9Wr2ATLf5e7fUa9vvucgMbFrLs3k
	 TnX76BlO1NWbNX5sET+k5ryRZakWLaMCFoBS3/3Jr9KJ5YvQKzp289sQ+5dUnH40JE
	 YraWIKZB69U/oUsIkWs4LRwfKdVcaLifUX52rf6NvHOjRRJ8pwGnzMQXDiQTzkS+dQ
	 Or2UDvuGVgxedXnRVwsappbAFcKl/jhcXeG8zbzd0cEW3UQY5qQzqAMPo1lt/1lJnb
	 MjyskET5jnyGA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 3/5] mm/damon/vaddr: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Wed,  9 Sep 2026 21:09:05 -0700
Message-ID: <20260910040911.148273-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040911.148273-1-sj@kernel.org>
References: <20260910040911.148273-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8mfdcdg5xwc4tqwkr619ui7eift9bthp
X-Rspamd-Queue-Id: 86CBD140004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789013366-690960
X-HE-Meta: U2FsdGVkX19sbNV3IPqitbCE/kyMMzMKBTrCHU8TqiYgNUdUo1YzX0RFyyj30IE+T9c/J0GJYAOe3RRoY7wH7URzLYAM1VmP4lm2Z81KcxeMmH+o3uuWdiYRPpVO8NSx6eoM8OR8s0Ky5okCqxmvjLyVncYivZ3w8SvrZlGu9xV5FtSsPeAFFEKqGrivkKO5SXX2pLvaNHacBZbBlbLdIsYkzGqZF6bo7RthHB7KJGaj4lXn61KBtUNMA6CT/ksFjxGG0lUJVQ1bWX0368sxarCPuZX4WxDf2SjlMv8ZXLwhzjjcqNjDcth4xsS9UegMrT/+NwemU14+xV07yDEJZpRUAHMecgYYCmdYbFXFWYA4/BlkFqnpv88zxx+hksPWR2L207KA2WsR44veL2cGr0sFNyoLIwfYC5uMg1fILxVOUwGMhalG/uwCLERhIfzcwckoWeLbllgYEgvQgR9FA7yXZNfMBrirDk1dfER3yNu6m+NeibLFdYG1rMUnZyuwZIIHMClLMuZuWIKWAMWos7JJykbtIlN0bKqsvD5JtfhmvC225AChXGwuXTKTU6Xj+jRmmbQmKKUZOotuuchpfo8pyE6uzD7hlMvpW/EU5++30swc3c2ZnpY71jh3AaPClX3z83jkyUr2yimVVbQ3PjYDjxynfs4p9gvJ7BwgaN/gY2SYK0rUGwPV6s1wuDHwC9ILzkc+cXsQ/35PZ3w/byYBQiSrqcWRq6Q1EmSt6b8DIOb14G8/oVArZPIIhsSsyndGkS8QL0181jE5++gNkj+rmeoYeEXyHIYaizCNsM6d8X++6cdTCzUJQY2s+JeR7Q8QXro+Dqe+xznmkytRJzS8Lh1PIzEiI8QQP6eqBUqxLkysRi6EqKWL6VThdGkORooVhr7n8Ye/qiymBnzCculNDNpSz/4yGSW2tqLJD8NLUcZCl1gdgnd+HLSqKec5IrIdHOaBb2UKVXq44Mo
 hnt0E6Jx
 RSF1KMmfrZoDh58UD06XMgo58udMjGbSpwGODJr7nRqYXaWSBdxiopV+lE1ob2c4Sqrq8AS20R4gneQMnWXH4ELVst81EcK+c+VapnsaN7EOhK+NsiEharIlmi90BkcKEEl+bkcwVKHYew/ArM7owOi7PHEGi6af6iMDHTzgxVKGyS12FbeERAm5sAbKQTzuC0qsjv2rLpVOd6uxa0GBiX7+DUdk8ZDrBDM6qOly432Ci+ZZ5x7DPsDdqaVkl5lBedKGjXXtJlIaj0CcwYLNrNj+EZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement DAMON_FILTER_TYPE_PGIDLE_SET support on the virtual address
space DAMON operation set (vaddr).

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4aecf34e39be2..d5dde97b3cd0d 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -550,6 +550,13 @@ static bool damon_va_filter_match(struct damon_filter *filter,
 			matched = damon_va_young_addr(folio, pte, pmd, mm,
 					addr);
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_SET:
+		if (!folio)
+			matched = false;
+		else
+			matched = !damon_va_young_addr(folio, pte, pmd, mm,
+					addr);
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
-- 
2.47.3

