Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C4BCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832136B00CE; Mon, 18 May 2026 19:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B546B00D1; Mon, 18 May 2026 19:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54EB76B00CF; Mon, 18 May 2026 19:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01D216B00CC
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA747120AC1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:34 +0000 (UTC)
X-FDA: 84782164908.27.19F1817
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 37B6440005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pkfPHVX7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3/rxSUH94s0Z7vyi/h8BUf6BMmZqdMAhXKrbXaEYeg=;
	b=2XIoGSthtCxnCd+LTegQ3X1177VhUWCwcncK/3ZWC/mxx1XI6eCHDn3p1PkSliUyXSWr/B
	qj0Jvv3kW6atxRN7/8aA9BHjeMrlJsZMbKdMvdz7tYyigO7OiHY0yx+m0b/irHJ8fW+WxF
	THoUyMLCy149cEoS1I/GBDcw4QHyZIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147693; a=rsa-sha256;
	cv=none;
	b=70OtwIs/OTkIO3sxaNRiiYOrWK0vhKTYY+GuCh3FKOHYPVL0shJnEDL7LzV0vEooZS/OcH
	pn8US1rd5zV5Tl+BBMK+Q2GyLimot/7WmC4c8dtk7NoK0ZW54Kjjb47gHs02IuiJNc2xUS
	x75+4BszZbAFd04Kk80IDSXEHGMyS+E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pkfPHVX7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB408601E2;
	Mon, 18 May 2026 23:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49151C2BCB8;
	Mon, 18 May 2026 23:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147692;
	bh=nQkVs1zWTxTfa8xwvc1gaYrxiOp7sl8ZruOo6hvwVAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkfPHVX7GX8aIMQ/kJ/GD5EiTwpxljO4R8nUKMySnXQ9Vb+lulnQBcBIW/nNx2C4m
	 ClZoKjHJxKswAPf0joekMlk+8v0v/EcSa3o3mQKfLv3Ar52wfMDr8BD+yelnCCNxIE
	 JK2PiqCCw47a0Gilz4unDa3f46dCO/7Od9kBIR3pK9I0AtPfwjlBKou8sro1cq+v4c
	 WMwCJLs4ae4KK6G7lrM68CS8PIi17wGbjrlNK4m42Eep1f/ShmlBqddY3ucSqHquHX
	 tgrLIMXbARD07N0DVWPGPDM7zK2GsKQjvV54K/Kp/onV0anElv6sHl8GwY0UFczpvU
	 c+se8nMtaPYtw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 23/28] mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG
Date: Mon, 18 May 2026 16:41:11 -0700
Message-ID: <20260518234119.97569-24-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 37B6440005
X-Stat-Signature: zmf1czybnwybi9wgo5jak554ucyqke76
X-Rspam-User: 
X-HE-Tag: 1779147693-926298
X-HE-Meta: U2FsdGVkX18+vZIpLc5DqnepLCKpsRx1vjBLrN08LGTk6d4tT27uNLZ+CtRIu+7g6Z4jdEOBo9D3i0aBUqGIMSbb0PbtN22vTC5offqxW9pVQRV2KvFNhRBNQ4GT0fNmVnv5AadOmQUSLUIhVkqTX7/dkceNRk0N8DX/1iaf4bp5IloQzXsNBl8M/mRkdQJSPXkjEN9k4YCp59qznfuUDAFOmSIs79hB9L1yQZLA7LsqYoPnXmdxa4GPlJ8XIGpeBqQP6yEJtGylyAvo6rAtawiLkmSy2cC9FUkrhd3dV6nGaKEsKskbWB9Iu3irW9IIcZJhCUdkjlYWq++7PMjYNOxFoE8mOgbtICKl1oGf3YonTIhiqDA6Zr/DiywK7M2chObhD+2t1YtN5iDdM67Mx1+QvDRpzBkFvTvZrB3yf5H4fs+z0N9/cdBKJuht+3vbQ2RRFcTQZ1/4CmmsODLI7PwO4Eg8M+frkS6k8e6528lziz44NM5xJqX2yaX6XMcpd47zRO9gwSJo0/1sn9vXikhQKcwLnZvBuujSyZEKThZGqbVC7IwhA7pBEe+NgekoXJ2ujVrRuG3ZkLiRNSVPYnzD3F6NrcQZTwYe1IRlINfpzHNd9a6vkzdnPilP2u94gVLaqx2arLS2jSzr2fLe17Q4RBxHH9Ot9NQ4GRZbmRA3Pvw+k6Gj8U/DKokkDQYVcRshnmaSEfTrdIxhPQP5OF23CM8z0Omy4l18GY2JGIYnSErLwkyrTCaU6qA3jUwSq7MaebNX0yIvXDd/bajX/oboP5/670BHyaIJlxTZ8Bopi9WlSk3rGQ9pnL3Tpw5LDfmC/Iq/rMcsA3SC3+BQA0KthzOivJ/jAsaMNL6Ux5qx9pwucVQc6sq/+KPfhfbZfEYa6P02PfKnTuKNWZqvv8I/vt1+K8nQO8qvyPqatrzKsq92loVgrf8cruWUyxzI28rHkKlYCrktTex9UPS
 kIPZpp/5
 rKC+ItBMwq3yUXbbU8Z1YeioMtlNbvmgj/RPrGyve2uEp5ZJCqY/gPcjCKZETg6n7x6TOsRPCjl7SN7k50JuKnhk5+K5ZMlExQHk6hwv0Z1cf1jJt8vwBw3oWFcOkYqJjvTkWq0m43tfAUQPGXN3rk3P2a0adZe+4GVaHi59dSotAuJ47t7lUKbEipp68GnOPNmvclDRCN91heu5tLcx1fZJtpdASnieVVxzxRQbaL98/TprfUEqLl97sc6SpS0nSZy1g39IexmSm0CHTIEk2CcCAvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the support of DAMON_FILTER_TYPE_MEMCG on the DAMON operation
set implementation for the physical address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 9997c5174ef1b..d0598f5f26882 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -124,6 +124,7 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		struct folio *folio)
 {
 	bool matched = false;
+	struct mem_cgroup *memcg;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_ANON:
@@ -133,6 +134,19 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		}
 		matched = folio_test_anon(folio);
 		break;
+	case DAMON_FILTER_TYPE_MEMCG:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		rcu_read_lock();
+		memcg = folio_memcg_check(folio);
+		if (!memcg)
+			matched = false;
+		else
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
+		rcu_read_unlock();
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

