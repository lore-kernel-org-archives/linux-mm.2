Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B9510D14A6
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6D96B0088; Mon, 30 Mar 2026 08:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E376B0099; Mon, 30 Mar 2026 08:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB566B009B; Mon, 30 Mar 2026 08:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8C76B0088
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:05:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8A04160799
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:05:29 +0000 (UTC)
X-FDA: 84602599578.24.4D372BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5B6FE180010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:05:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QLsx1xUI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774872328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i8dtSua8DnR+s6tAIdJT2aavCtb51f3jEiPJrQ5lvIU=;
	b=2RmyaaDEwrmjecCB+p57Zh/jG28ZSJOIItRUsmQ+bno4g5CAAjl1fKFW0+0G08PlXBf6au
	qntOpav//bPFFDQ4Ua7jdb4oEWNBrvrQNVzJBOw0VrEscvIxow/0RicD+Ehdba76zsWwwC
	Sc6dXYfH8uZG05S6SD1JA8hNsnwSNBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774872328; a=rsa-sha256;
	cv=none;
	b=6sZsUJFlVykWOyEgy0xfchu0j3n942hUtcyM+TUxjyJkYmP+iM8vLd6JaZQIzGoaoIt4HT
	s1/bfXiNCEhex+jWfRgDPYIqSkYucs78mdPIXGueDhSg8A/x0Rq7OC2LIELTXnlcr2oauC
	7ZGwHMAzD2Kgd2fF9XJyOehLP00Ubro=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QLsx1xUI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C8E360054;
	Mon, 30 Mar 2026 12:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B899C4CEF7;
	Mon, 30 Mar 2026 12:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774872327;
	bh=9bCx12bjazjLzKumIzbHh00Pgfuh2RWq835dYR5A924=;
	h=From:To:Cc:Subject:Date:From;
	b=QLsx1xUISY1QGldWkVlvsB6hmjYcZnPICwI2+1k3fNnZwgTPLbUIQpMaCksxR94ZM
	 kq8lTiKqDwnEElMXt+IOSS7Oj6hN1BTbjlogoQE/ncWf/R2EcKql34Mgpe5ENcwj25
	 4qo93hVqAD0JiYIMdcmNX0jy4VFS2H0D0mfJk0a+hDjOh6VoDz+TDbbU3ysgaL0jPN
	 vDmVXPflTgiUzC+XgPbWSGta+pE0lQbEAbziN19aRUG+05F1euR8IIC80a02vXxu56
	 55/FaTDnrI9NCH2zCe7mVumGbKUbKrF2amhSgoA9zW0fWesHeBoBsancfRYReImu85
	 6vNCiAVU7AU9g==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH V1 0/2] slub_kunit: add a test case for {kmalloc,kfree}_nolock
Date: Mon, 30 Mar 2026 21:05:14 +0900
Message-ID: <20260330120517.104743-1-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5B6FE180010
X-Stat-Signature: 5mr5656iwa7j58poihzdsxcrrgbt65n8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774872328-558604
X-HE-Meta: U2FsdGVkX1+Uvdg1X48EeRcmpLp0yLuh9JMZsK27C2cMWdFcYrFyhNbXTUFXw5Tb9n7ayctkXT6LFjHnPWhJArqLIGahEWCJOUhrt/2c6PQuUMEBOIdZRLTwA181zkGb8Q20WmlOfFFlBid2N1PlSaYnK+0sJhDy8txWtKWFf1kPf+1iVFqd4dE3DQTQ+kPLwc5/0g+CqvQegIskxC9fxz1nMYA1y9/V1n8zVFyIvcDpkncpeyaE1Gki8sj9j/JcVwJbMMtnTZrL95dQGWEQMZwTM/iXzHUi4UEDtQaCxgdLiNkb5DFJYZHdpiuhh49rc2cuSQOFuCaa8p+AUymhMJip0v7R+jx/+Ss2rsYLbyndWswxhW7+0WkCE0L5RnwSAr11cPifPCsw/vtfX8BzKCJDrp7JzTcxAXI2qLpcQ1Om6AXCJycJl2jip1NPLfUTx2QY2eSVhAGNXWmizEQGypwPkHPlq5rtBSHRRz3EG5wh4ZmHxu9LBUOQh175D1nLVsIVJPZlxLQ9pIYLuLUxHU8fQFixYmYYH4O6itZ9wU2F0Y4XkIq09crkylFgmpjQEAN1Dkz865+zfDNWpEIfaW256/UW/bRKvUGg0t8ptaGlVozXv7LThARNsVuAjBfzGrZEyWlCmbZ3UsZADi2/8w4UadoX8ZyiqtL8QxutNdbCxJNqKDQHJ2klKIlHDaYj+N9PvEMvo3c+wERHRBREa7a119ZfLPO1/XjuxZT1bSZ//Q/YfgDj8HpmSgbx8IrZjBnzQDgkLK3At23t3/yJ613LKr5oMHL0v0ZUENeDdYvw2BqLxbg3j0fXqd+hNiRJbATQmG0DFssagonPdXpYlnH/I6xCZRauF7YIjxfg6w44+j5q8C39ZFK6rQYZDiu6s4uDcbNxcSCAs4ASmszGfEywr4rbRDuZhCcGa1RYNtcIyStD9LD4i+r0yMXbd8CZCRZ3lebzYjVKlsv+unU
 jS/sTumf
 6L8CtpXF/3xcgdf3W0ZLarudAhiWA9KntgnC0BRSGzlB6bHa61Dgq7JNw+jdcz59M685zhdrgbr6YmhIJqnNie9JCefVWDoaI0jTrY8Fb+HhoaKr5myS3V1ygDP9aWWsj2Rjty8gwNg/S1R1I80M///g13qSwgvedN8DQzaOY+VSxBuAzTS1GDlBZnaXid7OYU0QH/KkJzHJtHiRtxBoIZzdxcmwB7OAs6KuszJRjeu4ABX0RayZPjLh9/JNXWP93IyKK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This came up while developing kvfree_rcu_nolock(), but even without that
it's worth adding a test case. Let's add it in advance.

Probably a similar test case for the page allocator is worth adding
but I'm not sure where the right place would be.

While at it, also add the missing MAINTAINERS entry for slub_kunit.c.

Harry Yoo (Oracle) (2):
  MAINTAINERS: add lib/tests/slub_kunit.c to SLAB ALLOCATOR section
  lib/tests/slub_kunit: add a test case for {kmalloc,kfree}_nolock

 MAINTAINERS            |  1 +
 lib/tests/slub_kunit.c | 88 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)


base-commit: dbc785fb4d9cfa0115e69e614fe20b4ab90f8366
-- 
2.43.0


