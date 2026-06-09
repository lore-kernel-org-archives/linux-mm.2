Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C54CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343776B0092; Tue,  9 Jun 2026 09:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A716B0093; Tue,  9 Jun 2026 09:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2573D6B0095; Tue,  9 Jun 2026 09:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 189256B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:13:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF1A01C2B9C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:13:37 +0000 (UTC)
X-FDA: 84860416074.21.EDB0119
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf05.hostedemail.com (Postfix) with ESMTP id D4E85100013
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:13:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JgWY+XUA;
	spf=pass (imf05.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781010816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A0tvLB5YUuFv5cwftes5RlfOdEv+BFowRNJ3KqYcQJM=;
	b=zPi6bUijQ5X0D7fuI2D7phzOUpCW3Ajnq6sVM4Pbe/wu8LEoEaVs/53ebkKV0DzXvs7TMX
	6domCYBh9ff1rHQ+6Ayd6rElg8eH8XRtKuzswiy3FDhESgKmVeDI5mhWhrhUHGAop6cDQc
	oJu61FfxGtJWu5yvjV4dQ8UZTiSfeaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781010816;
	b=ve/IKS9XCFbwjDI+A2lNDXcxyYOOW0su1FkkzK+c+llXvFhzLfYfAtuptPZ68ife4jOaIn
	R7LJWOVGDsyJDSESToPEsbWIxGfXMF3TAHRX9pA70mN/6qL9rpASzvwkjbdT7FMMAZomr4
	+NjGZwd3JSrwZWJk17daD+cZyJRzLao=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JgWY+XUA;
	spf=pass (imf05.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=A0
	tvLB5YUuFv5cwftes5RlfOdEv+BFowRNJ3KqYcQJM=; b=JgWY+XUA2ppeD8CDgo
	Qs37i5s/s647ojAG2/VNwqFq/x7bM8f3Ek9302nvbb3enn4wetL+CC53OVIUgeeK
	FrR8ST2UPNH9M1UybTj46nEzKj5J76CragV3rAnLDowrWX/QDtr7L+PVaZqoUMwv
	hE908Ali84eGMhp4XaYM19i2Q=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgC3j71TEShqyBQjBQ--.54036S2;
	Tue, 09 Jun 2026 21:12:51 +0800 (CST)
From: ranxiaokai627@163.com
To: david@kernel.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: [PATCH] mm/huge_memory: fix memory leak when kobject_init_and_add() fails
Date: Tue,  9 Jun 2026 13:12:49 +0000
Message-ID: <20260609131249.89288-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgC3j71TEShqyBQjBQ--.54036S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZF1xGF4UKF4xJry3tF43KFg_yoW8JFyfpr
	93JwnrK3y0vrs7X3yUAan5Z348GwsYgry5uFWYvw1Iy343JFnFyF1FyFWDZayUWrZayF47
	ZF4qyasYq3Z8uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeFAJUUUUU=
X-Originating-IP: [117.176.242.114]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxhP8SWooEVO8qAAA30
X-Rspamd-Queue-Id: D4E85100013
X-Rspam-User: 
X-Stat-Signature: c15wy9dm6qbmrpabdp6thzziu8anre16
X-Rspamd-Server: rspam08
X-HE-Tag: 1781010814-654151
X-HE-Meta: U2FsdGVkX1+4AfmYJqqOFSBlk4jywtSnVUn2RABLlAEC9NdKM9iDGWnzrpDtBsVxX0y0/Q6v+S751GtrbIHcTMCy4q8qn72ZWBZdQ66T8b2ITD/06jgl1uHEquhxYuT/bjl4ECbm2N0QI0BvXr0w/ysGrjGiM8j0oX/CpxOvCBkPMyubnuyesQX5zlgmhyQikS5k4L0O7DSZr8tMOms3yoDLggaAIzQ2QCcIfIiW8Duu46zb2RcoSIMPz9KBZo9m+zEJj05pmZNsAQHR7WPxraNDUtgKY4S0QcK3tZa3PoVNi0eiOe5amBHZA9R+stAGtR9qZypPxV8LkiTgUFMbKccVtHLCYTQ4vBOVsmfC5oD1f+R/ezXMBHQZ4fcl1Kx02QDNK8IHS5nq3uTNp7pYbfBCpVzlz6Hgo/I+I3wqOhDsvBYq/klv6ElkF5nMvLjHdciJhETpnN4O+Qwpnl48AjWfCUciXuFENVyHUU1zO9lNCGrQSDfNTtWtYyQ23tg3T+pmiB8SCJTJ0zdgtyyfPVg2qv0mykMwyuHpemQR5hScPRDlpinN5EPhYoieLHzoXBDaBMjX6LQK1LolYYK08THzMMCBHJIJF7lBgOr8ShVzZD+udDYqRzh+8LetXGyeiUcVpJ//WBI31LHKFfLjTnqJrA0opCK+EIQZ/TQtdBAI0gS0+drDLmn7ib9Pp2FgKPxIfrgVeYGPZm1cY7s8nNtwcpjCYZ2akOfEJZXZFQDWNYJIHDYrcjo3X63fgtHToQlbDfy+HYMgdP8zKIWP1Go1CTlmxmDYbmNvqGzgD+uC7yPR6czaxoy0xsu3skPO/GwZusUR1zrMJk9RA8lr1Ea85VRa17y0IPCL2bXHKHN7n7EVpQv+S4mNo32lB6raHGFd45Fq5hPC1sxuqE25SGA0BIHHim55OveJ6jqHflJdQTvaPrrht0eSQo0xQmpUV8vP3Q32mbtcZX86tKx
 SxqMtmVG
 XQRL+FcjpeVMbwmJhyf2O7wBpeTRhTUlNkjrOEg3YTfdCYXUBmhJdeK4uQlTc4X2P0SXfWW4MVv0bEa3jxYMH/RIBdO232OYBDzo3/Zy8PZXSSNsYwnv4kYCbKh2b8BTlAsszChv5jngi5BJiI50IiGzO0MHeWI6c8fW3YNy15pkAFDNrKKaFZHXg51VEX3k1r7iHii3rU1aDDvM4hEDpywvxiAYEcJVR6Vo+ZMAu0KJM6fGYrfUT59w5uSDSo0y5E8z2CjHkZMHzV7UubbeyQVO2KgD0OHRLdOtNZ/+MFxHoy2lZu7o9hH7BOREZd1eJPp77v5TxkDBVJG8pigUXtT8awRnzHDw6MtFZI8FCKzIQ3mH3DuB5M/ME/nZHu/v2trnIS+cuoUlJYPjaQINTygqhvLauXQSlroWWnOs86k+ChXN0p1lK/L2tU/82jKSDGdco
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

As documented in the comments for kobject_init_and_add():

"If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object.  This is the
same type of error handling after a call to kobject_add() and kobject
lifetime rules are the same here."

This is because kobject_init_and_add() may have already allocated memory
internally for the kobject name (kobj->name), and leaving the refcount
at 1 prevents its release callback from being triggered.

Fixes: 3485b88390b0a ("mm: thp: introduce multi-size THP sysfs interface")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/huge_memory.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 653f2dc03403..601750dbe79f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -790,11 +790,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
 
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
-	if (ret) {
-		kfree(thpsize);
-		goto err;
-	}
-
+	if (ret)
+		goto err_put;
 
 	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
 	if (ret)
-- 
2.25.1



