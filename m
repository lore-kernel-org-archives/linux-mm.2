Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F895C531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572B16B00A1; Sun, 26 Jul 2026 13:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FC6C6B00A5; Sun, 26 Jul 2026 13:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439456B00A1; Sun, 26 Jul 2026 13:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13D5F6B00A2
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81397C0511
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:51 +0000 (UTC)
X-FDA: 85031640582.14.9160321
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C4DB140004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NfGf5ZjC;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5EHzuEPBttna1pHulKblhjSxz0ZvxjVFhC8U+crJAs=;
	b=quV2haBZGfe+QShJtEOohdMzetk6Af7ZkPBMM5AUp8BxWJ3Fyqu3WuPd+KeNjSIG21Jem7
	ojCCw0DO/zK2FcD586WIIXJuGoNkCb5BuagiWp26BN8Ph/uszqENlady+kSvXDnHKNaigc
	P76ATlqZVf+aLEQ+QMICoGaAgS238ZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087590;
	b=3cftPZ7xS7PQQADTqRNmWyVTLid4YMffI4UoI+Z7t0oYHf+oUcMU6ySRDdk5VrAAXZyyLJ
	0MoUvFIjopo6F4DX6Wb8Y8ukYVBm6jzeMdvQFekZCi9uH4ALiTcxhNMtMScXkSN5iqg7os
	1BlQPm/r5qfiLwBVdBp+MQoJAhnBYTw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NfGf5ZjC;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4ED745147;
	Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1ED1F00AC4;
	Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087589;
	bh=W5EHzuEPBttna1pHulKblhjSxz0ZvxjVFhC8U+crJAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfGf5ZjCoPczUVUyo2w9UWlRR7cTcOzBj4vEF4PRENKaDmWTXkTty3M54wnKIIj5G
	 widdhobeVKiPvaP0hy3o3TOvF3f122pG42A53/Ndg5BmF9qY+HUb8b39fiXx6zVUGx
	 jiKTniwxzg/35RE0zXe60F5iE6YqGShJTAnJsJTLhBEvn4yrCplWUamNFu8Fz49wz3
	 wNc5joT+EdngFdatJ/AXkac723R2pgSPmkKAVpx+kUB4r5pkpBjuTyC2YIlqws/mbn
	 ywp6HRHa5v6spJ4f+fK2TIjl5bAHIupbLkkmK2AYuiO8rWBq4pIyG3BoJ2BfG0RLRx
	 qDmSbq26LG37w==
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 15/17] Docs/mm/damon/design: document probe preps
Date: Sun, 26 Jul 2026 10:39:31 -0700
Message-ID: <20260726173935.94046-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 861aeoobuzpu174pu3mzs9jesns4b1cc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C4DB140004
X-HE-Tag: 1785087589-138477
X-HE-Meta: U2FsdGVkX18V6+VqLa300l43hAQ/NXXJ1D5NIIAyoU3guTZ/01ZJR3APZJxktU3qdJGQ5KYHl+MOzomSV4Hf+dnPLg+uWDnVusBAFyZ9tZ+tw54RAFh+IHxjCF21BHWQ390Ym93sna/HYxDNHBneoUB7uMpT1bf/+A0cWF0GKMW5TuXWNnb9zcIiClcDTEFEgOaACXRawb0hoJ93L4qLCTlHzwEHxMKS2ae1xfU00biww505B18DdjgTlgIw3kQJnA/uT6dPL2GGuDXRuOPHlnT3EcEQS0c0yTjHnmlzJClxJ8TG6DbnVjNo618uU/oGMs4a6gvFj6A3MceS3/A1Ije2mZ/OPDB4dbpyu+pQT/Sce+S7PIiVwP95LUajdzD7+1WVFl3nv1ZPvdJOT5c9klwEHEkY3nXU54jb72CPP/zo6osnjjFxxshvSItuNOcAUdstpZROO7HzSZec3RIklOlczDeq9VSSicRQ0Ca36U3eXcPYJgVvim5XOE3i4nFUFJ9g3o8SIoW+/A4iWvJKQsodih2htd1SDjJC2mEBvAPHWdQFPI5WZfQKR4zzFJdQ+8hAznmtCMhSyFeZfAoQDOTRzxLSL2SioM0kzFj8OnNBaUpjmsA2b36woKtVfLmgEUpRYl3JTuj2e9uV78pTzBzE9mwBDxzH3zl4Hhntr60uQoYGYvnc8rfTOsa+FuvesWp9Ir/sn2/lyBDQdAsd4o5rz0DIvaQVYplJR0y2mbFrbRu2bGP3LnuLdvogxoIzqZbmLxwWTHxOdeuu4tPHDt8Us2/HzK+R7JshZ6aS/5BWRtr3K6qyN6siZHT+TDRAfZUQEoXMcAhVeqhLQWtotvlHEN9h+6OkTyLkb0zk8dsQgKFiTC1xiK6O8MCaBsZaliQmDcIu40Ux7Ayglsm4YqiAcZ7elW1T3EJCm80RPZ/H5IXNqiR1TRpyccM210OrA/g0slZMoaYJZo6Cj6z
 0N1AHHeW
 Nvu6KoyLUeYHEZ84gOgVpQbuwXUeUz58q2v/erzQMBQU4hG+NhRajxsrD2yVc9mk86XWdwwAVI298dumxYtU9VxUWQAuNXdsNjJxDyZuMeOZRIoXDJ0De9/69jCwJxFjHD96IoZE6EX3nPyvk3SbDfZcDUKs7PybDMbD3N1ry7mH9BdNZvWalLAfLhroT+qG629r1Hn0dDgPV49nNkJJXpz3UVv1zPvxhoeGi1wWjPhQ2fDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added DAMON probe preps
feature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index c4830bd09498d..7f983e0c39b80 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -309,6 +309,13 @@ Users can therefore know how much of a given DAMON region has a specific data
 attribute by reading the per-region per-probe probe hits counter after each
 aggregation interval.
 
+Users can optionally register probing preparation actions per probe.  If such
+actions are registered, DAMON applies the actions to each region's sampling
+memory before starting the next sampling interval.  Currently only one action,
+``set_pgidle`` is supported.  The action marks the page for the probing target
+memory as access-idle.  This can be useful to be used together with
+``pgidle_unset`` probe filter.
+
 This is a sampling based mechanism.  Hence, it is lightweight but the output
 may include some measurement errors.  The output should be used with good
 understanding of statistics.
-- 
2.47.3

