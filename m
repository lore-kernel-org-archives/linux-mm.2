Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8008CED7B84
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE326B0092; Tue, 14 Apr 2026 03:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95576B0093; Tue, 14 Apr 2026 03:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2926B0095; Tue, 14 Apr 2026 03:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC0DC6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:58:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FED01A04D8
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:58:31 +0000 (UTC)
X-FDA: 84656409222.02.59E51B8
Received: from mail-m82130.xmail.ntesmail.com (mail-m82130.xmail.ntesmail.com [156.224.82.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8569516000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:58:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776153509; a=rsa-sha256;
	cv=none;
	b=D4blsQ0srP3LCLtSQ9owAjdWar1wxv+KpEc0GJak8U/J8ySnW9P4mYBC3O3uN8XI9Hyykw
	omWpZSQQnbQZguhOYFgyd/1O4BDjm0goO8n1Xfs2tatYVUElGLwxbmrt6fHlydjjlu72iO
	rZLROJl+38eurvyAJvyFajKH20bz/AY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776153509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=/BWdt3RnnWJ8S6tEkChL+3Dmf3/tQ48LwzUATc2b7fA=;
	b=XJFyErTdo7F2daBfvWsLDD6wmVP0v7eCxyKCmMNp0CF2JNsI8jurkZrMAK95QTUtlqJXHD
	3vBC1KKVkBAIWyT5sCDZenSpceM2XaEDX4hPI/a9lp2qsyOJFG0KWAbwqXhsDX/4Eqn2DO
	dFe3qTdzakH1kPTXyMLtt7zh3hqgVL4=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 18e28d26a;
	Tue, 14 Apr 2026 15:58:22 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH] mm/page_owner: fix %pGp format specifier argument type
Date: Tue, 14 Apr 2026 15:58:13 +0800
Message-Id: <20260414075813.3425968-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d8affa3630229kunm9220ab7132a8d3
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTkMfVhoYGUsZSh8aH0tCTFYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09LVUpLS1
	VLWQY+
X-Rspamd-Queue-Id: 8569516000B
X-Stat-Signature: irt5dqgnzor4s58pasb9z5iuxdwxg66i
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776153508-178833
X-HE-Meta: U2FsdGVkX18ShBzTsBwKErkI1fhBT2JU4TIsz3Ne8k2a03LBFOeb2LmW9rbGSwWlr5JfkaA5h+iZ6oFnedPctgAZov6ZCt4Rcj9EAn80THNdXnNFNqYzI9+S90996K2pA8e6W4kwPXCys71imNl7td1YMh49HHeopZ7v6seDkSRHBMRJOH2JpxfKjE9wTOQTaokgPtwKdLUZqUTJCGmAqDE46E+oVnmUVWC0WVGlUSHX6T+e8IWif68l1WzH+gDGdcBrD9DUVHnc7XLBttCv6YHG5mBIlROFek48Ohu0KMRdDlaFjNP7ZVkAAfmtjuW8pw7tgN9A2im6XRaKq3QbnXa8uVL9YvKIScayEf8juMSi8fLAf8syZhSpU/uoX0LoKjasyZPEIiVYWhHtJZvCH/hpO4d8tKfSsSyAPWyCxe5sZypY5FfgU7ENzqkYJQ/OukhVztPlG+LSUvYCFu4pzetAlwHmktV055E08nt1U4IhnGzrChEnqRzc5VjFRRBsZ68cBc3uTS2Cd/hfAxLG/3tQeDDsq/P6gHrS+i+T3wR+F/WfBLyurIsvLm713lE95S15Qb32u/myQ5p3v5uxZ34Knbpn1ZzX8DzWEilpPk/j3hJCB+CDwFyJOj4GEfNsuEhKJKpUiyF0B4Lat+ZdjND9AAwC5Mu21ExuqJj2/ueDLVf9oeNK3xPwZkjbZ7g1s1xovDUzDq4nEDbts8Kxt4W+DyZhjL1QLrSOKKSV03q2Tfsm1UB/lglIBZ+lwWpHrhA092XY+qo3hqcUzP32Rjsxcv1PkaJ6sDKcFUTiJJLydNjfUN2QUtyU6erFymaSFWX11yXGSkG1EwYOdHFmztlXR6kSbYdKfkrBcD/YDaVZGS9v4vFjsMUbe9x49V3YwvrwFd8TvEMhLw1d+N/ttzunxXcV2l3zEKkBMIg4vFPNdA1YKznIY1YcEB2XFn5Ay7rNcFGA9exjQKbwv7S
 o+ZxNPKT
 p3O0vsTQltw4G+FbjnDqy4dGq8my1oIvCTSwzKkrhd7FtVHpmiTUfv48wtRDGz0a83I2+KJFPcXUGKNGUSh15E4I3jqTdiPr6NOdjSjnwgJVN7ypfdTwBsLY44IeX+rJ3tqqBH4MQqVZIgGI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The %pGp format specifier expects an argument of type 'unsigned long *',
but page->flags is now of type 'memdesc_flags_t' (a struct containing
an unsigned long member 'f') after the introduction of memdesc_flags_t.

Fix the type mismatch by passing &page->flags.f instead of &page->flags,
which matches the expected type.

Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..2dddcb6510aa 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -573,7 +573,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migratetype_names[page_mt],
 			pfn >> pageblock_order,
 			migratetype_names[pageblock_mt],
-			&page->flags);
+			&page->flags.f);
 
 	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
 	if (ret >= count)
-- 
2.20.1


