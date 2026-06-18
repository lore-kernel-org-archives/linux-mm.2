Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 141BCCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6ABE6B0088; Thu, 18 Jun 2026 08:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43E06B008A; Thu, 18 Jun 2026 08:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5BFD6B008C; Thu, 18 Jun 2026 08:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2B16B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:32:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67791166844
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:06:29 +0000 (UTC)
X-FDA: 84892603698.04.15F16C3
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8EE0F20009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:06:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b="xau/ycbc";
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf31.hostedemail.com: domain of srv_ts003@codethink.com designates 188.40.203.114 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781777187;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nVRtR1gAUE6N5S41XmFtwd5wDiRa6bjAvj3xCU45a9k=;
	b=V/+kWit5bJHg9m2echQb9UTthRfp3lszccBy7oPybUosPtd4lhOsDxNRViiVCE5dh5XxZe
	VAkzKZngIcNH7m/REWSQBEOKtIky+d3snvX4mcleXoFiLSvsXzZA9twipUXWnoJJ7KqCMW
	GnxtpaPtXLfKArNgW0Vzn+B9zsKsY6A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b="xau/ycbc";
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf31.hostedemail.com: domain of srv_ts003@codethink.com designates 188.40.203.114 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781777187;
	b=iFWiBfwNU2zP/8bBs3emmFp+HY0e6M1mekSh0b2784NMf/Lclxx5CJgg6dFRszXFx1z0Fl
	UrvmR9g+20Cdk3UES8P9VB/LhMw8gx+RWxSTG8z7ZiXH69renV6Bcf+wdgiMgnF8OdQrFC
	4Uo98y95/nVCo7+MjbGjwiK8b0jrmao=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=nVRtR1gAUE6N5S41XmFtwd5wDiRa6bjAvj3xCU45a9k=; b=xau/ycbcmL5NDx
	SCTL/oRVL0HHm+vZUZxtq1A3lkaHD8Y2kvk6NrzFZhqti3sNF/fPfWBnzlEJmKRHJpmnZ5TxwIYtC
	aRPutFwjnhSL7Td+bCWYXNx54RK7SvofFtCBb3krlAW5mfLB7HAn1aGdquV6ctbBarKSckTq32d6p
	dxXJcY6iXEbsfHn7WyM0k+xXZxNfzMlM/ZTq8Hgq6gk3nNzqjJRySOXFV5o42GeQ1qXoEW6SH7TcR
	goEPaKiBLNUr6IZTl9Ehb2PgjCiUUHTG5Jz4vH49C15eNpjP/LczGWA/x0XnPSql5w3vJSaO5qn+o
	6SLgeDZzd7ZLqiNieNCA==;
Received: from [63.135.74.212] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wa9dY-009jvA-V4; Thu, 18 Jun 2026 11:06:17 +0100
Received: from ben by rainbowdash with local (Exim 4.99.4)
	(envelope-from <ben@rainbowdash>)
	id 1wa9dY-00000005Xtz-0WX0;
	Thu, 18 Jun 2026 11:06:16 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] mm/page_alloc: don't build vm_numa_stat_key if CONFIG_NUMA=n
Date: Thu, 18 Jun 2026 11:06:14 +0100
Message-Id: <20260618100614.1321950-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: y8bzk3wryyzxhbf6knfdo5a3f38rrnix
X-Rspamd-Queue-Id: 8EE0F20009
X-HE-Tag: 1781777187-411937
X-HE-Meta: U2FsdGVkX18mwU16aBBlygSlQml0I9K9f1ShZvnOzupbsYuWeOTqDRMIIlCa3BS7juLSPNBPIqHhofhRJ4SB0iL4BcOI/cNNVI5BSIse9KcY8xkohKl9BZ/3V7BryKKMUTV5XX3gxPTuvkDOtoAWVkXbnfp05/iQ/l0GoqaDf7+dbocKHqOv38IwMG6EmYHhEE1QVY4X1z/6LH3Cvi4ARywhnFgYy+tna8FKofKTSYiFeUwufhfdwWSlbacYxPGM/Hin1EsyaFVHN5nZgdC13lUnl1ljJkX8kxn2rd/jQtduWQIZxQivAQrrYKofQeA1c49Wxmy+piwetuVAoXQ2fZ8t94Ej5v+0ssDmYHenGl6XsBL+dTzf4ggx36/1mVsjwN1/UjEC7ca0WxpvxGczD3Oyx7OSFHWqSq5PEBYo5Mp+w5qowml1WNh6+y+YEihXHgAz7l1ev71I2bmJ4QnAoS47fBYhvJeqGpZg7muoLuFEyI+09xF3OFaiOrMGBKrDCIlE9qkRNMOZtmWRXia5St76DnvBPwEf5XbQk/CE1tBY5ZX8nUv7dnf9U8GvlXQKZ8PhKlRxPcOzfRYJay/UU0uz6zm1cLy6EvvrkP4/3o2l/DpdjAdVcJ4nntG6JrFPD6fqh9jmT3zJoOiz0kmOztzklLazWp21YRV5OYrYaLh17FZdzLG6Lefk34jQ3SmmXvELKFYmWsSmsP7/iBvbuEjtpz7EEfqrvPtXJk4aKwmHcFxvjeTrxEnFVF/nVSiPRvtq65ZuPdGe4QiDbTWSj3PotEodJNe5zKs4nTRlGmTRj4GsM55UK/lLIXOoNr0jDQO/CFvuLWjvolsLKnvzXuReOcetfpIA6ASae7tKxmN8TpJSaPY9KeK2Gjf9YkJIt7O6ZNVVe/jwjq8Pvy5AtAi3jWMUFBFt4+3JO9O5LejvPbgUxqvjxIJJ2Hlar1dPFGfGe9MfWKxZLCID0iU
 0SSYJPlB
 oNgFAoZM1XDyAk5dDoTcxCnBOPMHHFAe88XNwBlvoasWBBi4ehUDEpLC2+Vl+N3rF5IADPylghvy26J8F9pGDRPyOSS5jz899m/0x7gK/HYNXvyNL5aKSbUAs5MAV5tndLRrgwSeYN9JRx5xsa+TZkhT5BFXjSmSG/XcrvWXG/7BX2XynaU+pSItetWjvk1hAFdmMcHjlPEgqDINB9bB/caEGLhyMXHJL9Qye0fdM8Nvm09113Uf35esa8lVqStuo/Q3QT+Ijc+K0Cc/ZtpScrNDnHmCm7WslC0/UN9utKAAgbpO0FJdGkGQd7PNA/9lDkxbuJ5rHLXdgE5TTaKEDJowkIfBqB3Oqhy7bcEUf3ntLpVbbzj8WzbNHmPyJ5Ks7ytVe6mRlHM7WGfcdhKvaC9tKkkrdvqAetY5Sy7vzYWxO49ZkJTYLy4v0ghbPMGtrITNYAUVRKFxnPnjSu7YF5GX79ZVrsJMccetoSJKcl71K3jYVDCadWn547VvcTvgDLvACdAmdQur3FjnDg5Bu6QaoLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vm_numa_stat_key is only exported if CONFIG_NUMA is set,
so avoid the following warning by guarding it in an #ifdef
on CONFIG_NUMA:

mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d49c254174da..b7d303a94cc1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -162,7 +162,9 @@ DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
 #endif
 
+#ifdef CONFIG_NUMA
 DEFINE_STATIC_KEY_TRUE(vm_numa_stat_key);
+#endif
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 /*
-- 
2.37.2.352.g3c44437643


