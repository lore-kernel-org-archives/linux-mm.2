Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0565BCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534128E0003; Thu, 23 Oct 2025 03:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C168E0002; Thu, 23 Oct 2025 03:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421668E0003; Thu, 23 Oct 2025 03:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 317238E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:44:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D26B9BCBA1
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:44:25 +0000 (UTC)
X-FDA: 84028591290.01.43F44F5
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6F7DA80010
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:44:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761205464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=NrvZYHR8Tbs8XB19+gRKgeuNI4QtTnB0BKJl+xcKKCU=;
	b=BH/ChlI8/HI42HYjJUuvU//il49PbvEOZ4dBKdnRIvFDikQWymvhGWiJIa9gJN2Mdnt8VA
	U7cU2NrJb77FF83smIS2TgsIRHG7aXellFsDUiXAHyZ0pMK0HUal13bw/eh8rHKdgg4X2+
	izEYzcIvDC4QKhb9f7K3tmMP67vSPmI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761205464; a=rsa-sha256;
	cv=none;
	b=C2cKUQf8X5TxqWrEdjg4crnOIyDt1oQKzE2bWFR5Vqz7aEu8ExlRI0nuojem063n63m6xv
	cj1mSLrpOlFkCLWpYs+sN7V3BG1QgGvoEq52rqrBk7bLQx/4exCun1IlMKrdzg2RKctQVn
	Z3p+4hazBHg8/Fm04g9094yHWRFmsYE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-4f-68f9dcd425f0
From: Byungchul Park <byungchul@sk.com>
To: linux-mm@kvack.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	pabeni@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	horms@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ilias.apalodimas@linaro.org,
	willy@infradead.org,
	brauner@kernel.org,
	kas@kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com,
	almasrymina@google.com,
	toke@redhat.com,
	asml.silence@gmail.com,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: [RFC mm v4 0/2] mm, page_pool: introduce a new page type for page pool in page type
Date: Thu, 23 Oct 2025 16:44:08 +0900
Message-Id: <20251023074410.78650-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTYRjHe885e8/ZanBYVif7kAy6UGkXujxdKIM+vB8qivxgJdTIkxs5
	J9NsBoKWoGmuq2S6aBXqdAtz5mXizLybUGoZJzI1IwVvxTJzTlzT6NuP/4/n9+nhaNUEE8zp
	4hJFY5wmVo0VjGJi2ZPQD31e7TbXdQBLmQODfcYExYM1MvA6RiiwlFYhmPJ+ZsHvbkXwq7kN
	w1iTB8GzJ9M0WN6lM/C7bJYGV+0IgtG85xi+tw6xYHceg4GiYQbqMqppGLrVjiEn3UeD2zvJ
	wrUaWyBckcpCV5VZBvdnC2moTh1k4X2tBUO/wy+D4cYcBjrySxj4mdtMw4A5HFqtK2G6cxxB
	c1k1BdM3H2HofVhLQaW7l4V7PVYM39IHEPQ0DTGQO5eJoSDNjMA3E0hO3p6SQUFLPxseRtIk
	CZOm8R80eVnyiSIf8+4wRKp/QxFX/heWWJ2XSYVtE8mSemjiLL2BidNzlyV9H+swac/zMcT1
	dS9x1fyiSM71SXxixRnFgWgxVpckGrcePK/QTtzz4/hRpSnb0cmmIq88C8k5gd8pvPK/o/9z
	RuY4XmDMbxAkybu4B/HbBFvuVIAVHM1nc8Ln+vJFsZyPEp6P/EELzPDrhOwO8yIr+V1CZamP
	/RddK9hfNCweC3whJ3zrzqL+idXCa5vE3EZLrWhJKVLp4pL0Gl3szjBtcpzOFHbBoHeiwBMU
	pcydrUGerlONiOeQepkyvG1Gq5JpkhKS9Y1I4Gh1kDLpdGBSRmuSr4pGwznj5VgxoRGt4Rj1
	KuWO6SvRKj5GkyheEsV40fjfUpw8OBWtnj2kuhgif7vbt8Xa4G9Wt+Nr3ZMW3fyVkBNRVP5M
	yRgf+iDNVGHpUllM68tP1od0S4Z0d4N/4tlTdcz8Rv3NKb9hT1b1fsNhm+3H41tHT0YeOx62
	r7cvYly/OeJTYjn9eLjAnFHVmniJjKXUP/IeaYnMkRe7rSbPnxFPvD1YzSRoNds30cYEzV9l
	YPpMAAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTcRjH8f47Z/9zHC0OKnXoQjCLyEi7CY8V4RvpX1FEEFFpNurUhjpl
	s6FJZbrQNNfFFt5ZROY1a6Vuplabl2lBNbUWVtqiJFtWauacYtPo3YfnB983D0v5v6AXs0pV
	kqBWyeNkWEJL9mzJWNvzzqNYV9a3AoprqzFUTSTDnQGzGDzVgyIorqxHMObpY2CmuR3BaGsH
	hm+2EQS3bo5TUPxCR8Pv2kkKLI2DCIbyazB8bncxUGXaDf1lX2hoymygwHXZjiFX56Wg2TPM
	QLq53Bd+kMaAraRTDC/r9WK4Pnmbgoa0AQa6G4sxfKieEcMXay4NnYUVNPw0tFLQr4+AduNC
	GH/mRtBa2yCC8UslGHoLGkVQ19zLQJ7DiOGTrh+Bw+aiwTCVhaHovB6Bd8KXHL4yJoaitg9M
	RCg573RiYnP/oMjDirci8jr/Kk2cLV0iYil8zxCj6RR5UB5Msp0OipgqL2JiGrnGkHevmzCx
	53tpYvkYTizmURHJzRjGexcekmw9LsQptYI6dNtRieJ73gxOHJIm51Q/Y9KQxy8b+bE8t4nP
	zHLjWWNuFe90eqhZB3Lr+HLDmM8SluJyWL6v5f7cEMBF8TWDf9CsaW4ln9Opn7OUC+PrKr3M
	v+hyvureE+oKYo1oXiUKVKq08XJlXFiIJlaRolImhxxLiDch35vLzkxdNaOx7u1WxLFINl8a
	0TGh8BfLtZqUeCviWUoWKNUe9J2kx+UppwV1Qoz6VJygsaIlLC1bJN15QDjqz52UJwmxgpAo
	qP+vItZvcRqy17xafTc8svSRMSy6p+rIhjXTwdFB94beT5fq9925kHQ4ypso/bq5pzldPRCC
	cd2njarURetR0cdf7mVdAU+GYu93fF4w89Qy2huWYGhIfBuZai+tP3fAaD/rutVN+FXcROqu
	tsmH5oSCG4+fh+7YH6QrP/gm/NzSmJwTngDiyGRltEYhXx9MqTXyv50GY8HiAgAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Stat-Signature: ss1ad1ujbwh8jj3sjt6muyadjyeer1bg
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F7DA80010
X-HE-Tag: 1761205463-327169
X-HE-Meta: U2FsdGVkX1+nD6rEf2eUhE2oN9WtmkzheT76xk51/FkgqM8TkDmsbk7n4rtsSEDRNebip+X8GIJQXUYfrFdhI/8DrO5GqIFSjzW+2aMndPymK9NawSTgHKLWWOVEgj+kKCdwb6VhNNsdyXOxSfRRxwLr9L/OPFVmEfVxg+m07SAlKUFDqZW1bUWSDBEQHETAgpIAl9S6zEGNFGTgblLCAF7Oj7a03i4T//HzYR6SQdfS4ZmmlIo0QPJQGFS3vJJxzi1435ERl0EhNQzaf6dgnQwct/zeRHuPzEU+/XfDE9Un89ZUowOiywkEiTF5PEdOyFuoBlZeXvuqx60v3pcBjxODR//po+KN/m0rxS+7ceJfcnDE72R/dCUtrtPFU/l9gyQzcueLzkchzbxs/NqxVVswtjuuZish0HVQQtgrUmge8bwtfxVR92kLHBStJ/iGFxo28LQ8EHqaVhis/FmrjD8fi3FZE7KSpWXXfOhSHeq1k0vFr2BB17GAj1ABVXmpR9HV3poD5PXOj8eqWjH9SuQja6zys59Y5pMKIDWjghyHllUBz08k6X+BZ71JX32EE6itvRmyHulyxe4/1secvyhY7vigq6Bn47c33nvJvxGlv/QDEWeEAj/DnHyoAu9546gxRl8ctWcvmtcwt5ncz73m93QbXF7oClIOY91txx5xA3ch3wpiUlTgvfs8T3TrJeqa8V/mHNqSavpMk5s6dX7j5MX7hNIhlYV35cu2MO1scG012TWRwisD6rDqsUMvrFLaR534yxASyCuKrsG3RFEJAYRc+Gbo6lvU7ksGNXipQDx2Xx73QE3bKQBLeOmx4C2tuegFAgzPnz/b8l6cNGq6tZ40HYNL+pJE3TdWhkHgFk/hFHJH2KrPncTQSz2AF2XCSBU3M820SyF7u6YdvRuRL+JFGh8pDda8JksuSMx8Xw9lj+l9or29hooGaBeu+z9Fo+OyCnABjOnSEyd
 IcfAkI73
 l/Yy+Q2rhl9QwdzQdsKXOBOh9/J3Xv3DmWDqSVOD+QNY56z1BU8EO8cYOy0NdU9jOZ5hpiJiY7e5oQTwf6eZ/qVQ8cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch is supposed to go via the mm tree, but it currently also
depends on patches in the net-next tree.  For now, this patch is based
on linux-next, but will apply cleanly (or get rebased) after mm tree was
rebased.

Changes from v3:
	1. Rebase on next-20251023 of linux-next.
	2. Split into two, mm changes and network changes.
	3. Improve the comments (feedbacked by Jakub)

Changes from v2:
	1. Rebase on linux-next as of Jul 29.
	2. Skip 'niov->pp = NULL' when it's allocated using __GFP_ZERO.
	3. Change trivial coding style. (feedbacked by Mina)
	4. Add Co-developed-by, Acked-by, and Reviewed-by properly.
	   Thanks to all.

Changes from v1:
	1. Rebase on linux-next.
	2. Initialize net_iov->pp = NULL when allocating net_iov in
	   net_devmem_bind_dmabuf() and io_zcrx_create_area().
	3. Use ->pp for net_iov to identify if it's pp rather than
	   always consider net_iov as pp.
	4. Add Suggested-by: David Hildenbrand <david@redhat.com>.

Byungchul Park (2):
  page_pool: check if nmdesc->pp is !NULL to confirm its usage as pp for
    net_iov
  mm: introduce a new page type for page pool in page type

 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 include/linux/mm.h                            | 27 +++----------------
 include/linux/page-flags.h                    |  6 +++++
 include/net/netmem.h                          |  2 +-
 mm/page_alloc.c                               |  8 +++---
 net/core/devmem.c                             |  1 +
 net/core/netmem_priv.h                        | 25 +++++++++--------
 net/core/page_pool.c                          | 14 ++++++++--
 8 files changed, 40 insertions(+), 45 deletions(-)


base-commit: efb26a23ed5f5dc3554886ab398f559dcb1de96b
-- 
2.17.1


