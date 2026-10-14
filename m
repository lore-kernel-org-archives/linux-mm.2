Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD8CCC6B24
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4226B0088; Wed, 14 Oct 2026 11:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84506B008A; Wed, 14 Oct 2026 11:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A886B0092; Wed, 14 Oct 2026 11:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5D366B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:32:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3ACAE1A060B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:32:43 +0000 (UTC)
X-FDA: 85321624206.09.133FA66
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8AFA1A0009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:32:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OakyNMZZ;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791991961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7drg1auP9RpxmrNbLDzwzOM6Q2TABIQBS9mj++ncBaE=;
	b=dkJpEdaLqL5dvebCZbq4EvMUZfdn3vrX7ZjFE0qIJ6C4wNadr73L2/BuyakWeIY1J//c+e
	fOT+ty8lFqmXuoB3uy8IjO87XUfFJy740VnFs62W+Fl2Dp+qSmghWn1ThaOWTUt3Ar3dNn
	0ukwlh0vpby/7ejyKjQYZkgorte08XA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791991961;
	b=XkJ4b+xnWeWoO7m13FCX41/QClyNLFuCJTnvkDzfz7IuoCRyw2XRVrD5FbzxCN16FEYRd9
	Flq6RBxLg4KKHE1S8ZXBgfYm+Ww3KU5sQR5dRjVqFA5S2+E9LrQ0mMT8qHMCS3oB9j0Sxt
	3VxnZq8ObCDmzbNKmUJlmNgSK73cydU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OakyNMZZ;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e61ac64ec3so37305555ad.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791991960; x=1792596760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7drg1auP9RpxmrNbLDzwzOM6Q2TABIQBS9mj++ncBaE=;
        b=OakyNMZZDoCPVMOPd+Zw6ZCHp88t5PnImUAVY5y7lrpuFZbT1xZzpvNNkzwc03jvj5
         rqoR22zmNqHJkInzjbEGNUUGDmQZWx8YLauh23+kME4SpjngzySzqyX23JbnC9EWMzLe
         CVmVu+ewtjN04q746qDdJDkM8mnjZQaK3juMVq6ERUAGImvsP6KipP0hCtwYVF13jz4/
         aqRRLQjCIZGzd45BmzcwdxJUm3CJakOBtEDI/6PRncz1I6iCPpaJsBDlwR2GxcNTe20D
         SEQnbhqTpDhcQ5iywil4yi9YtEa8WLDOXNQgUxlmBhvp5ScZug4dZKe7n1goh+xcK/mH
         KBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991960; x=1792596760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7drg1auP9RpxmrNbLDzwzOM6Q2TABIQBS9mj++ncBaE=;
        b=nlAmof1UpsnFxqcRDBd+bFFJ5AianhiIbgF3NvEhAZVdjPJJhG8V9elC9/bzLsUaC6
         Y78gz5mUhoHCXgUlDcjeoMEFaLr14+Ju6+WYJ8GbUK+EEFnt3vLJU6lYGnosMQR9JM21
         Sw1Ppge+6IfUgUPR2tfjwLZTGFj72zS9Pf7KUOhLLhlZJ4i9oZIiGnBdwBpqrsaUsCKG
         ZTo/Nh63BioKd/iuF93ZoaZIRGhjQpAZd7aTLhGfXWKPLx1naB9SWOeVUeoInWvbDlxG
         zhv54UqaPDbupmqOCX52mvKy5C9zptFNiv/IfpOzWw5pq6yhCZbsf9Qzqg4mdXPdqOOR
         6A3Q==
X-Gm-Message-State: AFq9FYLCpxBxKy/yhhcXhHNQBalGcpP2u7XCV0Tqv7Af02v4SV5S437k
	f2DStUdVx/JC67xEUsfCcFi89jxZN+R2NxZJdO4Ov/yeBEw2gfhNgk0aPVQtmg==
X-Gm-Gg: AYBFou2XBg19zx20obryeZa9tMf1USqxPxzG9eabFcUAcX3cudkBCb7sy1gRyI642TN
	giS6gySSwg0oaSkwZ4d502gE3KaGo4f/A9Rq6KLYh2BpdFczhvEH0kMR41neQqtiliQn6RdIwlZ
	KhDBvs4kQbN1AweeaLtlEoZ+pY9VuJuxqjDhHFp7A+ggcWTp9Y3b1o1S77fqCUiLEC221qLaxKE
	UXq2HWfU/7HmwltwMBtV1wP6WRB9bweDyeiFKc6qumxxGFXeRPCntT46OmfN7yVfxv/xns1GcAl
	urYVRXZyl/Aoo4G9vdDjf9Nhilhz2ZlhhUkVrYTiyYX/dPc7pulrEg9MltTeR1k3OqWvyBMwakP
	7fIR8V1cMOl9GkVPQWjNAtodyIuTUCHLzg0+tjM1oSiq9Q9Ndm0asWqAbT5lmjidsU5A2WnW+C0
	AkE8o1ZTqEyC7duR6n/IxspEVy8WWlENuKEklCtCtcsEweWuxIl0i21PLZY4ZtdNxqBZcd28ckP
	pF6kWqwl8cDyxthVmJAXd9O
X-Received: by 2002:a17:903:b8f:b0:2e8:3190:74e with SMTP id d9443c01a7336-2e842e02dbemr136560325ad.57.1791991960190;
        Wed, 14 Oct 2026 08:32:40 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e9113d213bsm24771975ad.38.2026.10.14.08.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:32:39 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH] mm: numa_memblks: remove local copy of numa_nodes_parsed
Date: Thu, 15 Oct 2026 00:32:24 +0900
Message-ID: <20261014153225.741884-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AFA1A0009
X-Stat-Signature: tc1cui34zmmn84nzbuj7k6em97mwd94y
X-HE-Tag: 1791991961-256723
X-HE-Meta: U2FsdGVkX1+fEMXQeHb5fpkPlppKHoBphbRCy47nhj8Egs04nTXqfOumIDlTvL9o+/DIbUZDqSqq4lnByFHOAcq8PtMXMAzSgSDQNi3Sp5bdwxKuhJJn6pZmt3is5r983FisZByvtQTUWHSluWDx5ybWktj//O8scuskcICHxKD5HTumbSSjI5gJmIxW23AF1hGdD8/M/BhOn893JPxWcFrErqJhmcNmJCZ1yU/J7e/sFdHyiWPw2EpZ57yzfKf8KbWDZFu4AbLUegeUozokQ4AXDemT7/BL7mP3GoL1z9hhaFGiaMzBGNIpjGAHBr6k4AeAsjAm6FTTEgV389E9/VH52rl1HoeCf/Do+zkcFj8+u5c53US1um3cfXMfA5oE6D/bgU0Zz5exORsM1W8ltAecgEWXqidTBgLjnboIK4gZwSO2ZBNk8c3LDJBMVS9mm/yrJw/DMLroMnOckcmc4dvnhUAXnEVavUBcEVjeSCI3ZwOWV/ddLyyqhtVWpIqbJ1il5HzPVYeEpXdcst8VsSfBMN3gb30DHK1JI8pxSog9QgYg/ox7yOtL4RkXYlbPBUUKPdGkqTiKUPjgjHxnVhquYdHArXSxFsPRLDKEGFKNqW+zODL7HgWgeGEra2MLLpCaJvMdR0wkX2yl/pA5sgb+NZ9lM2vrGz6JcVdJvimwh23uWmGuFwr2S0WdntnqUsHm2umQbOTtaMta4n3J5V2XjiO7Vas5N9dClLTi9cfn2zldotA6hwKQWqgdhE7B2IJTRugxgM8awV9YFU5OD91V8+6NK5Osn2NJJo6dSpGcPvboBWOxWerK5vJLE3PaVTFR2RQXGCMlOIGNdzvyRqN7ayjQdSA36fia8yRzzubrShxBQdVbpK0bvaUSFR3fEVGdl76P4F4mG2yJrnmMGDNWlOalep1qCdIlMAp6QvALGnhxW0F4QxFf4EiGDgCTUgzbzONnOSm/4PvEA52
 T26bSF/d
 VLA6Wwd0w58NyVcrzflQj8QiPBMhZBjl1NjhNC5AJfNk7/OSJTQkPGjFR1XzeMForcfF2puQZo3zCYFkAH0VD5gqLfxrxxlpTB0O1X6a8pqCqwuw4wXnnSy0Etm/cAggTeDGUx47ZGr5l8TlW5tK4yEYhoCjeW7wIvohW8l4v69RQxPT6InNOhNkZAFSmZqwqlIRQtm+2wnA/n0br/0UyzglgzV89HopQYuU95dYlnhzTrnIPYprqchs2yXNkheUKPsPuHKCzwPA9G19RbFEfOjRR4azfleBtxpPw9sl8GnbDYRlC3MDVU6IDTvaSZa4QVC0rqZH016Joq/orE4yZFhvtcL9kR258PBIhb1seQfOP2KXK7zCl2wV4/1Iq7FEo5K+cHJz9KfWImzmiywtfdVJdLN7qafkLvc77C75VPDGEd58qh9FejDLcEaR6MWWIVDJKrReb4SRQqow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit a9bafc1832d2 ("mm: numa_memblks: remove redundant
numa_nodemask_from_meminfo()"), the copy of numa_nodes_parsed in
numa_alloc_distance() is the same as numa_nodes_parsed.

So remove the copy and use numa_nodes_parsed directly.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/numa_memblks.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index be6e7346f6c7..1ea6871c0eb5 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -36,14 +36,11 @@ void __init numa_reset_distance(void)
 
 static int __init numa_alloc_distance(void)
 {
-	nodemask_t nodes_parsed;
 	size_t size;
 	int i, j, cnt = 0;
 
 	/* size the new table and allocate it */
-	nodes_parsed = numa_nodes_parsed;
-
-	for_each_node_mask(i, nodes_parsed)
+	for_each_node_mask(i, numa_nodes_parsed)
 		cnt = i;
 	cnt++;
 	size = cnt * cnt * sizeof(numa_distance[0]);

base-commit: 5728d3523f12826a2b180c1c5738f74e33197e14
-- 
2.43.0


