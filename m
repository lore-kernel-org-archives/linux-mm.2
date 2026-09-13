Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC0AC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95906B008C; Sun, 13 Sep 2026 13:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46866B0095; Sun, 13 Sep 2026 13:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961C86B008C; Sun, 13 Sep 2026 13:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE3106B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:11:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8480D1C2D5F
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:45 +0000 (UTC)
X-FDA: 85209380970.24.F81849D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E2A90140007
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtpSJuGT;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319504;
	b=yk3++J8HHfUI0y92g1zvpyQgoCu/1zeNVP6LsfuRfb81DUxhQJK+8MROjhpvaRNUC3OBxT
	JKqOE61nRLOMEc5XgPxjERp1fmKUkyQuzZADhKh/exNTf3zNEo1xUZqbFeuvrnL1vbih/p
	bYkSTP7zkJb3Jn2Tou0nq+3YMCOgeZo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtpSJuGT;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsrL2oFK9840WoIrM7QJPBsnHu9HVCMK1ZcOyqnJN44=;
	b=LnkWRnprz9Q5vWS9kXBwm+j7MJPZDAoEtLqN/r3HHwUGRUFz9/byvu4P6EJUaeXo+CkFL1
	IUQG4cJ2lAmb34aLuD1GQ/BdpWINJzyZq9aGb95CK+hkgeAa4J+TLn8X0p3c6WzDOHv/PX
	Ln54pwJLvy9RNOJBeP89ziFjZdeoftE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EC0343E92;
	Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3931F00898;
	Sun, 13 Sep 2026 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319503;
	bh=WsrL2oFK9840WoIrM7QJPBsnHu9HVCMK1ZcOyqnJN44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtpSJuGTPgqTlFmj05Uz0j8VHGqk2zb3TqX9YBZ1LJs8dgeSMQoqsxMQTrEiSVHJd
	 oskQcoOPLIJzBYIVOPfGFwIbteGteElEN4qaABZ3KK6WUoXy56rwVsMSlRfHK/l4d4
	 0T8lkofqxYK48n0Nj+jJxv/75zFEP+gmLLYEEn67AO1dnB6CWCOfwbE7pAx/yV+v56
	 a5W5+HcLAdeCzBlV6v7I3AtvLRbYr4QTdqp3kTi3yIaaApNbDkBROGxXLY/hFXb9MB
	 Nyr/+tn0womjaocaw7Hg5e4myo4WsM5P1sABle6dqmQZjzM6k9RZkrAIf/CZumeu/w
	 j2/Irfe8hNaRA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/8] mm/damon/ops-common: support hugepage_size damon filter matching
Date: Sun, 13 Sep 2026 10:11:25 -0700
Message-ID: <20260913171133.102366-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171133.102366-1-sj@kernel.org>
References: <20260913171133.102366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2A90140007
X-Stat-Signature: 363w6c4a33raocckjifijgcm79ni11jm
X-HE-Tag: 1789319503-195289
X-HE-Meta: U2FsdGVkX19F/tm71zV5V8/ADNAnbyYbDWFtF9y7r0Epd2NHHRIk0fi26XtTpu3hCK0CsuomeP2kzR4wInRO49Xrvf+ZamslRoKlLXnCwc1hIhIiEeMwCcbwDH7VR0GednS2EVxlgNPGZDwLdpaNVrXHm8jZcrXkr3kr3emj0RVsyklLKX913uL9hK7lhSjyj27yr14BmUaU86EYiy2v4vhUDcardcwDzYlKiipLva3wBxUw0olXVEICXTdP3FtxO0GOMiP7/qBmeC8HfWaGmtb1c0offbNG2qWwzJKLoBH79TubIs7wxqxZt5XVbcZFbzvZiA2cTAoq8l/FIiJcDhba3SdMFe7U1JL7LcfP4cpqdcJ3Anrno8AHTsvJWiPcGZVduLCq4nqKL2Aylg6lCmCYcedtCvuoPIcz8EYsNBQt3rZVga7DidIfGyD4Nwzklnx1NE2V05+5ze7pIBhUdEOaXhzl7rh0nsBbR5S20feMDd9vLuhjsBK+X9TsE5upbnRNmlxs6CvMdfcLnMwYLeebSRdbFJP+XaOBMHfwlsVeSiY+Y4OZgpkPy3T0WVMLyErKuL8VqzPH03CfzU8NACdNQ95dUlpMmppqimA4mxCo8pU8gjPb+OQ50Hw2QjyiWQ7k5ek6FHvBsrV4ObO1r3KPFnlaG472oeLXak8of+ULS3Gwywzi/gxWC9eqtoVOKMMpN/GiSjpNLhS1Zrp//vZIvrc7jHKFEteQdmpSkIsKpLiPPH7eO8DaCTAt/+Zo022QvO8nqAmiGiRZa0uj+9Kdb2CA9T+WYUttoNg9pc3k7P2vWr6qRIm1siD8CYPfXqQCK0Yfk4nglh47Oy2wV0lBECXDcU8kTAG+P9I6yBsiqUjGn/LAAW/PiAmrgmhR+wyZA6MLMYmF91KxZDr3RoZC7FVygKhxdDWASlhypIBZF+GJmkKoVkFkahRrt2nMBHIUetDyYvmPmK483y9
 gpjHTmAb
 dGEQ47UNTgfEBJkMR8xaqldfNo68kZ+90dzJIsHRDEZqKc+0AB1WEK86Z7lOiqL8U+jPrPH29ckdhwN935CIp6skTl3yePZJ8oQbBwQd3p7p0CBL4G7hU7UNrCx4l1RMlkPMlxQJenmbbhLqYlDo4XmkFJM//5q+6T/92FALlh5IoFKyiM9NQt7Ne2yR3doxJuXHR4O2DOZOmsVbydJ1zW9op88ceEUi7tRPemgHCvj4zKF1bmrinIGGVxmdhGFlrHbwc9N+yt4MhLhqppJLHz7vYng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update ops-common data attribute filter matching logic to support
hugepage_size filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index c36cc39cd2c70..77366f42b3e5b 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -536,6 +536,7 @@ bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
 {
 	bool matched = false;
 	struct mem_cgroup *memcg;
+	size_t folio_sz;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_ANON:
@@ -558,6 +559,15 @@ bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		folio_sz = folio_size(folio);
+		matched = filter->range_min <= folio_sz &&
+			folio_sz <= filter->range_max;
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

