Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE3EC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31B16B0096; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F090D6B0098; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B956B0099; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5C0F6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 012391601CF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:39 +0000 (UTC)
X-FDA: 85227114000.04.410C838
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 705E51C000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TuycTjiV;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnIaLQ3JqTQKlYGtXSLMaRVuIin07S/F5Nx3QIjWklQ=;
	b=gGDnlzRsdbbPSeI39PMtHT1VqYhw2Sp1VXg/H6jGafVh2EdGPabBrtIinkEe6jrRM8tRGf
	p90kuuW7Gg1MzQyXNCuK83hXi0bibjN6HyefWpfTnUGiu7Im+XdBzRJuryvZzCx4UBBsaI
	SJ07oJpIfPMCld/18EOwnmxPBfgse+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741718;
	b=HgVMl8DTRu7aezaJ/JyqcQ2WSe7lh+r+PkWRyEajEqRkA4hVu/R2E7L5yXxzXac4j2NpCN
	8Hg1teFwk9VLrxY7mrHoL9cX5Ro7Rczj2zWnhHQ5uXfAMO0ot3TOedDzbA+/xP/dgOSeov
	IUtk/ESBRFyXF+bp0AKsJydZOP7wjmU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TuycTjiV;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7FD6400E8;
	Fri, 18 Sep 2026 14:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264691F0089C;
	Fri, 18 Sep 2026 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741717;
	bh=tnIaLQ3JqTQKlYGtXSLMaRVuIin07S/F5Nx3QIjWklQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuycTjiVoeVMzOYC+QdjBjiq2BtWAOT6mVWKFFYP1Q43SZJ2ylFR9x/qtM3GZAT+h
	 zjOFGtdgHcHNpp+9JwBfJTsNLBbFG2CZqKSUTHTEf7E6RrX08oaAiqv0tqrhCTraDE
	 6J2OVhxJYCIL4mIpl1F8U9fscvpS5y04kEKEGEe1ebq8On3ygxfxwPw787L5pZN7I5
	 j/RofLP4S0KKXUwUaOXn/3kOObyFeb2QH4164d5Qv7xMPS+LoKHc498YgRdZyGtP7y
	 1Igmc9WPRZ60staPoaoDWecFA5qWlwLfiqX5l4/7ep0D4/UnudyPmXl3LxV21brM83
	 bvpdf1PGF+ceA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/7] Docs/mm/damon/design: document damos quota goal complement flag
Date: Fri, 18 Sep 2026 07:28:24 -0700
Message-ID: <20260918142827.85303-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918142827.85303-1-sj@kernel.org>
References: <20260918142827.85303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: igc7tq67sxs86jdn1nai37ykf1m1u69r
X-Rspamd-Queue-Id: 705E51C000D
X-HE-Tag: 1789741718-698127
X-HE-Meta: U2FsdGVkX190PEctGThHoaPsxwF5H9fDigfz8Ii9dTed2HGvcy83RahULXE5CxkIPN1MGNDKz+MchVfFcqG1eGoGG1FkN+FX0rlIsEsU9A7OS3uSR2mokv4W3SCIBshvpwhF1sXwpXICVBUE5wIVC4GoQPW001bwXn73szeV5LorHh1oqKatP/KKC0nOUf0G43Q/u4iBCmCQJxdhJRU4Dgid3AWdb1ioA5wwIii84F2EwVW5jx4wc3QvQQK3645nc2A2xXx7QEN960ehcvn0dfSBzU8pi0AXGY9PXftTbDxGAVSzp3HadzodvyWT9v8c0uAk40y08F8RJToYbsxgjVRxl4eXTYHMrSd5/E/9FvtEUt0D7uCk3sqPFfHTkRSEXT+7LBtgyACg38CtxXKracD2oGi7DpS5tEk4MJI6Yg421OZm5dayjvglN0WKvpCJIZ+tJl8VSGOwJBT6zbLsf9WYbHWZnKXgcWXcxnBJa7rRUJfJ97l8H4V/YzvYLSisYwfrmURVyIUe0/uYlq6GeSWRZMwPVARDQCidddLX7amtSD4np7BpHFrrnlDI/b8c2Wt4lZSMzC6Edp8bvHXbDzlJcTVHBQRBK1XR/2aMYPhrrky4m/DZcPAru/uLNSA+UCsQ4cfJMLRcYy+a5ReejnA+YzFivIvcGn81unK72WsEL4Tt7oHTEJ6apCx+2OWYTRWljg5G5QHwXzcK8Vwv4lGMueXUrbSqlTz8kQr1IAnkawXPzlOY+Rd2FlfPJTC3Mlh68ZdKP3mDbnzJaFxyWq0SNv1Aa2M3k6DEILYgUxmSMUfsrUBONaZz6TmmCOg8/UBTDybA7KdgBlZjRGect3UeUDgNN4TsA2pvsiWNAdyLMJWBdyuaO2fvaM69BSwgBRktoVesPINT0CCYbCc5GPp1NSsTEGceEiXQKlUDWU+/5NiHFGl+xFuOhgOxVBPYu2Sj5Z1zYHcEPYWEhD0
 tJicGthL
 asIKANievglvaAho8xPoudh1X0fRZ4EFAtNgmlRuYo+xEESsV3zj65/+vABroQtIyXarMuHljgOgalJ19ZWKTfISNAzbDJ5sud6kGMpJzi5iYjOF7JmMncdyIe2Ko2leC/p1XvOJQxCtxCk9aizPzTyDdrrblC1f8RO5p1cNLWGW1TusMRTwdfQSCjy2/+SDjDH5lijcMPobqYNapABkfpPQFyMf073npacG9Z0mnmR2A/hA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added damos quota goal metric
value complement flag.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index e82390e77a70a..c82be80738c45 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -702,10 +702,10 @@ There are two such tuning algorithms that users can select as they need.
   that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
   <damon_design_damos_stat>` will keep increasing in this case.
 
-The goal can be specified with five parameters, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
-mechanism tries to make ``current_value`` of ``target_metric`` be same to
-``target_value``.
+The goal can be specified with six parameters, namely ``target_metric``,
+``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
+auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
+``target_metric`` be same to ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   has interest in for the value.  Use space main workload's latency or
@@ -733,6 +733,11 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
 - ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
   (1/10,000).
 
+``complement`` is a boolean parameter that determines whether to use
+complemented value of the target metric.  For example, if ``complement`` is set
+and target metric is ``active_mem_bp``, it is effectively same to
+``inactive_mem_bp``.
+
 ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
 ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
 point the specific NUMA node.
-- 
2.47.3

