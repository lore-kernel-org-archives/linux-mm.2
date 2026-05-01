Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4145BCD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90AFD6B0088; Thu, 30 Apr 2026 21:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1D06B008A; Thu, 30 Apr 2026 21:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F206B008C; Thu, 30 Apr 2026 21:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7026D6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:19:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97DB91C0565
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:17:53 +0000 (UTC)
X-FDA: 84717089226.27.7EBFD85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EC7D34000D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:17:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MrITKq7l;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777598272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=joUyppQgdibpHH8nlY55E5Nv1prQF4Qm3z25YXZEpxQ=;
	b=apLMsd4BZBoLvRtTgjBWjgNtEOS/2mepEzDy7ETzbaoMEiWRu28uU49Zta5+fPfL1r9qif
	KoOG/E+4yyeTjuxlB8n2yrAsf8eq4blEm3XIJj6gzHy7kGBIpC5Gt6UmekqUTG2T7is3fC
	HBZMYAi+ZHkJns2WLgHxjTDehl61GUM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MrITKq7l;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777598272; a=rsa-sha256;
	cv=none;
	b=EU8DaZz2H83Hqcmen9evC26FT1dYZ/5nDx3wEluOdTnPPIheCujTNtWPZY+uO7Pn6jiZhe
	f5Ttaiup/tFYoV4J2VUADVlN0XsnigSMtr0adbV/2PIPbkHzxe/Z78tdPaY/LZNzrlNP5d
	L+tN+z/Hb2dy/tXX1DOp8MMIJxCNIoE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 202AC444D8;
	Fri,  1 May 2026 01:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680D4C2BCB9;
	Fri,  1 May 2026 01:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777598271;
	bh=FFZsipR5HDi6IaWQyWowYhDwh2V2W3Kfd/0jWX5YUQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrITKq7lAL5RkvU47QDpv8ARuoAWk9lqcC9SkwgKOVLGwhQv5j7KVZiqil0SeEocz
	 PvJhlDWl+kfXmc8WKAhkQNRVRsxn7vHmNQtuL2U4LLtLVG66CYXKOh5bkU7W+cMkS0
	 ymH+KGHB19vEfr7Ilz1R63PWHC/sScZZnal86WlxpK8UvW+cb1+6S8hwTUIro9TWrK
	 xQbcQgFumw1G3nkix5nq+R410zB6gO2wpiRmwDzieP/4hFKVQwmkI7gLyyP/+3UFDa
	 mEg+apQubBgU7rOg8nThCttU+b6I3WTtuVIDkR3ghUpnN6DmFa1uJMvETXXC7zCNNE
	 QSGjiKCTrqjWA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] Docs/admin-guide/mm/damon/reclaim: update for autotune_monitoring_intervals
Date: Thu, 30 Apr 2026 18:17:39 -0700
Message-ID: <20260501011740.81988-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501011740.81988-1-sj@kernel.org>
References: <20260501011740.81988-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 11jfthrwuzmyjw19z8xi8wyhqjwkyg5a
X-Rspamd-Queue-Id: EC7D34000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777598271-794854
X-HE-Meta: U2FsdGVkX1+CmAwF5m6bEod5CFG47PMuS5sdjLKZ9IoK8FQAQu1O2I4gFIvkYFSFVBysQgiFeH6j9iTjSHGVLCVitVGBIz453+tvUm017tAohVylQOy7IUQgTlMxxPFWso/BkhGuuKMGCHwQxZRbUml5wMMSfWZHUcN55yPpRnZ+HA/zSApc1IHETqdrBP9kzRv24qUFX9kZ0b01Iv9cVRk2736jvvszH76Mt2hriJ412ZNC2FFpBezQscQOd9JeGkVul9I9FDC49B4yRTfM6tqLl07vkQM8VoUg22cnh2/WH23erMuo/6cr/16YU/vRzv10rgiqRvp2fh2Uieg2SmdbtFUNnE2PkiOLcD/iw2rbsFtZ8WfyfSwqtNYMSThiBdGAe7fDsnu+KvQfbDBl5ajqeIhPOlSk7gRAM5e3Oc5757x9XdyCoGZyuuyHa71eg/c9PtZWWV0GZK9qOat7drIsKkUfyONSL1mpfLS/M/VhHLJHwrr6AwBWysVo21NmvGE0kzbyPthXPlq8S7PXV64ZVlrgOpXaSwT0cdZ/LYC0JQxl0E0SP7ULVO8kl+PZdTMXbtFCmb9NsiKFailgxPSM1JyiCZ/90v2d/RuDSoqs6qqSAVkdSu/xEW7KyQ09/82CAFr1SDuXR8N5NHvtQOVzLRVaI2JjoTGjWk/FIbup0wmlER3e8o6J4f4RsaG4etweF9UTs7K6LKs3l8psWs1EWQ/7D6kqktD6BXvYED+7clhqMELUzOLVgXJHLsCfJRceBP68pdMgt0L+4ladiFhNwf9Xkcl4x3mygQ5KiVFfDuHZrKr4BxcA64orhGN6J0UOE9MZnkHPhTq+6iQO1kUJDXkntNzk5MW3C1EAJQDywlkp4Jv+byj2tTN6Gq446dNAY3eSI9IUjCRwwNFWUG+xcOgpndmGUDZd5KoONOLx2aXyPkHX2Tmq766ToHXy2Yb7k8eVhLMjmFh5TWg
 7sHympjj
 xGf6WIm3TNWvQxV+vKbyNM9RRiPTRUDbE9FRaYLvGV98ldiH7L9hyeHkt1kzjT9944jy+ET01RU1hYpQfiN7C5vmjzkoRbTW6NkzYyEPWFMCb+/9QwXYcB5066gXLTv8eP2rNIX5iu1N7A+IO4f9jftrwexEOAirSK0jd8xOEnlrMKFMZjmfAeQVtlVBeIQdezDrUpUsw8atMVDY7qPIisKvsqp4sFvM3SAwCejeoqhLdky7MnxqSffSSEFyoHtWQXlV1XtK/R45cXbrAkcIQcP1umlCxgYu0nf4H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_RECLAIM usage document for the newly added monitoring
intervals auto-tuning enablement parameter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 57ab8b1876506..ec7e3e32b4ac6 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -85,6 +85,17 @@ identifies the region as cold, and reclaims it.
 
 120 seconds by default.
 
+autotune_monitoring_intervals
+-----------------------------
+
+If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
+amount of access events in each DAMON-snapshot, while keeping the sampling
+interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as
+``N`` disables the auto-tuning.
+
+Disabled by default.
+
 quota_ms
 --------
 
-- 
2.47.3

