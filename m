Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE8CCD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CEE56B00D5; Mon, 18 May 2026 19:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E516B00D8; Mon, 18 May 2026 19:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25A06B00D5; Mon, 18 May 2026 19:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA5FF6B00D5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FF178E1AD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:36 +0000 (UTC)
X-FDA: 84782164992.02.DD8858C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D888CC0008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d49e4zgQ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3K+bMfTag6W8Lpmd1wy26W4UKe1uVuclgWdsIWrEmI=;
	b=IYE0RrKSHItiISJSbGF2LG0bjqw1TU73fbR/c+8jycJ8N9H0+vOucizegEHdPhFLYIBsKP
	oJXn3ulht25HQPDYiGR7mdL4H2UCvgzI6OyQuPveTkxKEjEk1FLaVMYSJQ1mGFtJ2dg6as
	xysADksLgSiGngaCpK/Xn7qeRSRqHPg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d49e4zgQ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147694; a=rsa-sha256;
	cv=none;
	b=zjxn19uz0PmjPxama/TPap40QJuOICKdeKugyJME8yv2Krf1CruK4Tfvj13K4QLccHgwCz
	J1niTQNY4kpvrvR/cdi74uHC9hjGnYl9Ip0E6pGVFnj7TIlGMqHJViJiT7Ls6yuh/sq7jP
	3xZJ/A/hAUbJZozyJMlDtjl+IaEn7K8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A7C16020F;
	Mon, 18 May 2026 23:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A08CC2BCB7;
	Mon, 18 May 2026 23:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147694;
	bh=nrsABmJnRfG9DLDHrsalCtHOuyMv2VWZvo4tqHnGPDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d49e4zgQExuGINRxEf5AWO8nZAgQXWtelBWGpn1NMEWBzaksn2d3KfKUKieotlrpt
	 h4cwaSTq82DQ78IKrFyL4vrwbAAANtYApc45EkAKHec0cCfWKSoAFVqTJz4C4phgOp
	 JkGOcScHZ9Gbb6SN+oD6pCnmPxCPaUfZ6Wsh6K4QtqyLmUkqACBAXwsex97lntkS4c
	 bWfBiQFPEMh+0qUofHh5TfyXJ2/h51vsZJHzlka6yPmYMiXnjbIfAFJeNC/VbotLjc
	 uB7786B+psNCQx49QDu4fqK6gD0hKvud+C5xjEczoZ5CDUCU9mLwtLUD2t0GKJ22Af
	 hKQ/cykC4X+HQ==
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
Subject: [PATCH 27/28] Docs/mm/damon/design: update for memcg damon filter
Date: Mon, 18 May 2026 16:41:15 -0700
Message-ID: <20260518234119.97569-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D888CC0008
X-Rspamd-Server: rspam06
X-Stat-Signature: wymqzjxokx3i4jfki1c1o3rwbnbm3acn
X-HE-Tag: 1779147694-283004
X-HE-Meta: U2FsdGVkX186f8mEtzKH7fR052UmYneNMdygJN9ztMLbyMUvQbPoQoh4HVNQpWyw1GftO3YRL1rsEWX5pG5sSldkKcf+K1kNYGubortYLp651fgiyDrvYSkMBqxbP+htoe7+e8hc49BBxUldORs5v6Wvs3XmMsa02bL3lES90OBvipDfJdBSQ7Oc76Abrybz+dUsDqANPJivhCmZoKaJMGOZncihXnTeUWlxWlZKYcU2ABZtl1GHlsJnhdDDb2tKXNkQdixPeItKnBV383KmSd+2KhrVv2+KcmCBljSGrDN0zpZQfRVGO5c0jfDxfHAqjZuPnvu4YIiSYHtypupRS5VE1DEA4/P95xlgxc62T7Wbg1Cem21mvU1UmCQMVvqYjsWyAzXSta/gr3CrhHjSFK8pNo/UARCSxbKCcWwSQj1eXo7pjaQWsCgLjwdpn06WoX8fs99HgmHUL1uVE0CcXKpPVJnK+XDNRfHLIiA7ksPb+WvwS19Uze2FIWa7kEMlLIt+DOvKmsEZb3m1XsJe++8iBQx6y0py0WAijcI2YTU+148e/0IDePsZ1WV9ACtLLGSEOUiQuDNlcv6d5oauVVETdAD9fy+LkdmgEz3+GBRXsQ8ASeyp4BSD7hh0MtkyovAwoUMqo/KmtszpQByGnESEsfFIi62Ddr/UHsgfVadCKDKrhJgNIT5p0ZhwSqhyrM1MJoRs/w+QmTkHOHMWEkyvKfH5N/blgIZvplDeJR2jpiAcNpAI6D0vYH2C13/tyeyDfhqPs4Cat0iR5gXPi1Lq4sRGqXyhLL28BEfpjMTkk9fcmm70wKakVnfby+2yMg5bUj/LCmEUFr4NuodafwahgqLNwbuIXZwY4Chfs/BBC3W9CMb6n2ZoxqTmSYDC0uYdTucAnWd/SqKkJsViFOteP5qGpESKFj1JPErH+jkYPcIPZnBtxSoCWn+QIofVVZsQyawUQbJmuNWZEQF
 uv3KaJkL
 PB2WMuis8Ow4UkKF4H3JABKteoFcydZh+dHqlP6574YXYM/NSx77eld4ptZfP2loqn3KvB3svwdRwDmlRM1jUcNExG8AOX66Pq9Am4Cm8jo5HnvUowqNlfy+4eRm5Ds/f/U+TIEFUcog4WfWaE8tL6KIOXXMjCZ3I1OMF/mur6xErgM64HaOclMTOzsXh+uO8/NkOFukpnSecEmKaOg3u06VXh3sgU5Et9C20WLAwEcEFJXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added belonging memory cgroup
attribute monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 937960d2b6d73..2da7ca0d3d17a 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -293,8 +293,8 @@ registration is made by specifying a probe per attribute.  Each of the probe
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` filter type is supported for data
-attributes monitoring.
+filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
+for data attributes monitoring.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

