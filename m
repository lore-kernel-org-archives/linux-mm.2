Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F473C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858E16B00AE; Tue, 30 Jun 2026 15:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7939E6B00AF; Tue, 30 Jun 2026 15:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6826F6B00B0; Tue, 30 Jun 2026 15:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3AB6B00AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C26961C3803
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:59 +0000 (UTC)
X-FDA: 84937516398.20.34987E7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 339A98000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XhoFPoBY;
	spf=pass (imf02.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846538;
	b=jMfZiZmgeKR6NarcaVgwd1HX4cQqcTCfEn2/RJr6N0x3/Y44svROPiZV+v3we7dwdbb7+P
	U5/6B6GIJqOsX3jsRZ/TIqdRkK6QZEKfuPUALPAmN8APdYuriDudkQaN6y89TtujaRhDpG
	fI592wynbblRQPo/zU5Vy3EuN8zYadg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLih83L5YNlKQN9UI6QjpBHdMJhi1HQdwNwTb2ff8ss=;
	b=JHSoWuUX8xH25+XpanqtHu/J/wdXLJmBdi2Hf3bf35c/TizknOm9eP6rDl5fLQWH0l13qY
	6rGWhc19mV7QInw8GGSmhDhUCPJEsj/Ve+s9yHVfX8H73//q6LesSd52KsQJLiC07CPeC0
	0u+lzLIev3O9cM4/2al0UT2LeuQS/Es=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XhoFPoBY;
	spf=pass (imf02.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XLih83L5YNlKQN9UI6QjpBHdMJhi1HQdwNwTb2ff8ss=; b=XhoFPoBYjrXuE1jyewFY2WFj7c
	I+qCOXOirlJGBq+/1YFjjJpUnLk8lMKYCrg+zzaDoI++E6awv2TBvrH7O6HCmKTbk8SS5ln6KXp+/
	8DlDha2aJv9JQO35OBxaxsALoji0e+tyACvOUC2ez18TrX5nlJVpDWy9P+/k5TthMXJ1hczvNAZ9t
	IoOSMFVT3lIJtrtkj1UNC+b3Fi4W8hpuhl4sw8R4DBgOK8Dz1LjpslQ9qxWKdPVL5QqeYJ9MfyXKu
	+srZMwIpgAQQBcFNejVPyCYpU7WdeUKsr7U0mwH+uqlYZXfuN4beH+RphGk2D9CqWxp7TTSO7dPyz
	vGKLZXIA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpJ-000000005s1-0a0Z;
	Tue, 30 Jun 2026 19:08:57 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 06/19] maple_tree: Drop MAPLE_ALLOC_SLOTS
Date: Tue, 30 Jun 2026 15:08:30 -0400
Message-ID: <20260630190843.3563858-7-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5ctdjjxmkwu5afemoit7hmun9u3ehnpi
X-Rspamd-Queue-Id: 339A98000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782846538-361701
X-HE-Meta: U2FsdGVkX18RiqtGPzcWOjYHdhjABJKjoz8HmgO8m54yoppdiPkLDQP9hanrZ+loS4fs6uFWEwDgoQ2HFYR/NTDj3PIo+Jxjr5I+PcA5K5RzRmlHxP6KVexGMyN0v3eG3zAs0i3xpOz3En2UX3hhfcMd8KdvhUmViURROdBf4JBgsYICvV2MFS4bU2q5fcu2NsbjKoUrJQTNlVfedJxxdv7MsbgpONHEh+BdB/u2KK2rJWvgmWkSkgY2QbvXmcabOhK67Qp/F6cjxUf5g6p31JS/z6RWG2Yq1vuOnjXBP+QuSPxmGNJt+KBYnNdEmoN1Yo0Wll4FbE73CV7tJOyL96Ir19sZqCFQTYLclQwZXZyeRzGT1emuCBvZCiJjpu684rdRt++y1dYiLeCTrYm/lrZ9AOXLioBTREASu5Ez8X4IlGX2nCqxgyEBkf5ol/4G5PmIiWnS73x2iaX8GXNfSY3sKLPd4aQssbf6RZ0uBXu8Ggv+pArGc/tsL2B79QiDOgCreesz+YXKitNdmEKJmNRT+t2MoAl0/ekHmDu79zI1MHeiNeUgfMDdjz2F5DFAlVEzVJcaMNtetdvFeRaOYKuoeopali9yNon9dfU7uqOvIUWNd3NAgMW7Lq4TAxFDT3lHWbaoJ/Kr2uQ+1ZATJeNPPgeXu/oUSIQ71J7C/WLxSBVSHO11oLRznfFEUq57h7dXWYpkMgRSk/agLlCPVQEgFQNsbAaSznKKNgCjoCbjlp1vEcV7CjW9BaKoHwRtZTlxx+3tjR5/NfAgPrfeYKW6HRnwWRH/ibwUuwRHVtEIpcOnnGTsW6E2zLlxEh/xiP9nN1oIedfTxS/G1W5k6JKPdRnp7tY6JNfujjZLunNlYZZcYEm6toa3/e4e/5RoEtnoTFiZG0W2Jb/VYhQOt/QPz87DI1iG2UpzQm23pXt38gbyNqJM1OpqW3U/cXaa1wuJWtiQbLnuav09s24
 23J4KdTE
 kp+Z+S5f3o+rqhGZpJ7EWc0/8f0CZchYY8L9cE7E1q2xVtb7D+SkWq1ERAh4onEiZTn91xQxTr+VsVqGU2E/mCbcwFPl+B5jMyouHo2K6hpX0E++U6CWUuh1oYbZXhe82Ti4FQWZobnO0jeghOsKWWpuRgz569GivvXfiwu+5fowt0bVlye9oSVxnBJZUG4NSmfCChKqicxMhiOqieOdGFtUGTHN5pygRaY96iqrNGNUUxpReDF+MkPxRJIwYTUNPsroIowJ9Od6FInx+mfeIdSdmE6i10oHugGW5mS5+Yyzh6j2AKqiQnLuYnUojmzbxyhMv09UQURHGpdRBBedrDCyh7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MAPLE_ALLOC_SLOTS is no longer used, so remove it.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 220b380cdd491..346eae48cf15e 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -29,13 +29,11 @@
 #define MAPLE_NODE_SLOTS	31	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	16	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	10	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 1)
 #else
 /* 32bit sizes */
 #define MAPLE_NODE_SLOTS	63	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	32	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	21	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 2)
 #endif /* defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64) */
 
 #define MAPLE_NODE_MASK		255UL
-- 
2.47.3


