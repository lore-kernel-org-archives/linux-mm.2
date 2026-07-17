Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2734C44514
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7BC6B00AC; Thu, 16 Jul 2026 20:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE906B00AF; Thu, 16 Jul 2026 20:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A315B6B00AC; Thu, 16 Jul 2026 20:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78F1B6B00AC
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:30:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C726616026A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:34 +0000 (UTC)
X-FDA: 84996387588.11.8D6782D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3611040004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkibWEkx;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248233;
	b=5gAo/McN6UyZjz/UsPDO99FXU0KVoHDaEede6aRv7p0xrbUkFCbGOVBadvsiRwziRCGXoc
	IWx5673F5OUy+k2yXkPxXkseaO6iz4b63seIjz7on7xEa8w7F0ZUaXu50APK8eOqXXG3qQ
	Hr844VYFynhlNh2vUZHENaOSqrxCzNI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkibWEkx;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqlH4wneWbMAf8JjBiLX1bTl/sVQqX7skPWoj8yoesY=;
	b=b1pfx7ElUFRl6B6yYXqHAV9RrIHwGI6SrudAAMLVVCzdEi3E9D+jAf4WhX6dqqdl2TCipR
	jNYXA6eeS11P4jAqNA+0vR7ulN6x3BT062v0vEsCEI8V2RrAc28i61TN0WoRaD3l9liri5
	HQQ54L2vvgAxu47QBgR6XQPFsgMQkkE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EB6F40D78;
	Fri, 17 Jul 2026 00:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951B91F00A3D;
	Fri, 17 Jul 2026 00:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248231;
	bh=jqlH4wneWbMAf8JjBiLX1bTl/sVQqX7skPWoj8yoesY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkibWEkxEb645+nXZzhJof8SmEPgjDXdHTbm45OKlK4kuD4YBOW8QQ43Va/dMG/p4
	 F9153fCWi20R5wN2cEBvkAbpnBpJyylfMSfZbxFeXrzcvWGkcuS5ZuH0v1QqdNv8ZS
	 Q/xpdyMEjE5nR0pBeOu+Te3l0SfopwLaxm5YgDAtkvaHs40Y5dJep+bDHv0RPXs0m5
	 fILC0tOyXUFC5eT77uj/ncpUY4HmWBDVcI5dAbdgDNw8sPRn1ZRkHCWg/VuzzMrVEH
	 AX+S+zY9m7RE8oXplZwANRRtHrhJyD15fDISQR35w5DkD+VXaSy8WOyVSZDITP0Y75
	 DFDGZQUUX4FKg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/7] mm/damon/core: initialize damos->last_applied
Date: Thu, 16 Jul 2026 17:30:15 -0700
Message-ID: <20260717003022.119437-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717003022.119437-1-sj@kernel.org>
References: <20260717003022.119437-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3611040004
X-Stat-Signature: gms7exzfrm7cyxi14um9xtear48y38rn
X-HE-Tag: 1784248233-351217
X-HE-Meta: U2FsdGVkX1/OBtbGYhwtmCC+ceMslpdoDfrwwqdj/4Df7hr6lb8cy6bD0Ipa+d3g8TC1CsrxTiKR3ty+otvhDnLaUH5psAhdlpGi9p843mrp0nlpAAmwpzVgWczQBtGIxKax5FKLdd3FAY/647uxOg3xnNGmEcPuj2UsXETldEyZMWfQkWNpohCclRSiUCiaoH4uJlqSMQIq+VJidxKE2EwmsHahwQgD/koNYbdHdL9UaWOFF/Mk+v+Yu9vKFlDG9Bpnpl/2Ed1tJcwBqpURPVPAz0waguOD5MUeU75MBQ5axJBGS0Si9lLAvA26ZdgaYbibH7m9pzt95r8NA8CApMLvHPPC+5hRrEYVeVQYVFen1LiNSQQxTCe323Pvr7wCZm2xOmPjo9c75jawCaQq9gYd/Ef0kH1q5nD9cWyzfUsKBIu1qvpNzwQMZUNKqnkE1txYLxNtmitgKCWE8TuSj9lLhJzpK4LHWWTWxvHBnim8b6D+2Pi7/76UPVJgZFWchvaB5b/GORnOfJRvB6b6kbZADARfI7R2VoyRfHL+ramHWjeY5s1/udL85wHiYrcmE3AyAGIcG/6Mhrqw83aY0JPQjuG2LYmxuTAVnhj/KtRcXsurZEUfUj/p/4cA4U7JRPc1QVlmzWMtQXEn/A53LUA52iQI3OYTZfPAWQIDqkRx4HvcwJI4FiGvITHh3vbcmxJizrEHQFHH85WpB0tOpP6gHYdHjA+Iv+h7n2i4wJI1Ty+UGxZH58vzecEUcsn777Ap9u0apKQAtL9t61Q5RarJGR2tNnOOhPD1Wb+voUFXy9njfu7jVUpmv0ljD9N5W49Sk3+vUmsof90DH5LVEro2JwBab3vBTwQSo7qzcmokGbQzjDRVA0Y3/XzTPRhllZ1vEcqtwefdeFKoAXEBz3LYR58mAwVy4fyx+tGtLCrR/hDJ1nbrTsbxPXPIz6kfQ6InIn3QuS/n9QEUD92
 Nnz+uJkt
 13hCKpuvtssRcDq5Pvz1Gghoj8MGVWk88i7jaqWcnG56Nbd7inDON83K5cPEy74ixD3JmW2gjtp4q9PnkwB7gz3uC3kcuE7kos6Ozw3UUYvvsJUe8pWYGe8ujVqPlisBwsl3gaMW29PV0IecTDRySEnWELU2sYsBI5JI1FEHpPr0xS8Kas7ZXNP1wOVmnAhPxokFUQ7cDKUqL9oafzlnnct7VMxNr71BjdQ27Ohy9e/zW/LhGnjkjS4TmgZmjfHPopPLKx2N/guGy3ZGtD3y7vmOyhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Multiple DAMON regions could exist across a folio.  If they fulfill the
condition to apply a DAMOS scheme, the scheme could be applied multiple
times to the folio.  To avoid this, each DAMOS scheme stores the folio
that the scheme was applied to last time in the damos->last_applied
field and skips repeatedly applying the same scheme to the same folio.

The field is being used without initialization, though.  Hence, the
mechanism could wrongly skip applying a scheme to a folio at the very
first time of DAMOS run.

The user impact is trivial.  DAMON might unexpectedly skip applying
DAMOS action for one folio for the first time per scheme.  In the
DAMON's best-effort world, this is never a real problem.  No critical
consequences such as kernel panic or memory corruption happen.

It is a clear bug, though, and the fix is straightforward.  Fix the
issue by initializing the field in DAMOS scheme creation function,
damon_new_scheme().

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714055436.120034-1-sj@kernel.org

Fixes: 94ba17adaba0 ("mm/damon: avoid applying DAMOS action to same entity multiple times")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f464b4f0976c3..60255f5cd715e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -705,6 +705,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	scheme->max_nr_snapshots = 0;
+	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));
-- 
2.47.3

