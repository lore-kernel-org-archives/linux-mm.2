Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCD6CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98176B00A8; Thu, 14 May 2026 20:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A136B00A9; Thu, 14 May 2026 20:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2D46B00AA; Thu, 14 May 2026 20:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A602E6B00A8
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CE9EC273A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:59 +0000 (UTC)
X-FDA: 84767809518.24.9A9A5BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D790E1C0009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GJpnyRce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mX7T6z86R6JNTr2PcXQhLE2lhMsHJyo0qZYTtEbOWWE=;
	b=k5yhQrevtBcpAD9wKeVSomIFBdY/lRf1YMOoKK8NWqz1DHd7V3GhyjEGr27BPVDXwFF6er
	LjKzmlWvWtt+SHk2rGnetr/ZvCBtnPSCV3mo6sr1mjIEPkkRrgO0R3tuLf6tRiHJia4Xrj
	htLHFhTghAn/1Jfet/43kB4jVjkOGCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805897; a=rsa-sha256;
	cv=none;
	b=fTI0UJukzkq7UI5U9X61KUEykNDq6j7xA/V5N6ESgvfYJEgPZAPiqZMHBL67oi221jVWfJ
	544Ga35ZzS04Wy1DaiVNOE2w6wQefjzAHnSbl25fQCUjuRo9xZGmzEUSEQelDVtLT3YD/i
	Bo4ZjD06FgI8h1Dz2LhRQvUDuMCSlhY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GJpnyRce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 596FD6132D;
	Fri, 15 May 2026 00:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF0FC2BCF6;
	Fri, 15 May 2026 00:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805897;
	bh=lR5soWN3IOVMOAa5jz6VmMJ/WG2kTof///VJp0cNoDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJpnyRceOgoYjh64htKLDtHX4VVkUjh+8Gu5d+DFH7Fsl5eodlbpjHMuJq8DeIDEl
	 wJ8T7CvOkwLPL++m7fkvjF40gjIFQQTu4ZkeOe7gDKQ2kBowMKXc+0oCL+eNvu+MQt
	 npJfGTCVkfgXIeUq2ML77DpvLxNibMuqhUGgjZ1J3JtfT9fx3eDmqDaXQg3MdUBke5
	 sENoSXqjkBwKIOX5hGatLf/31uqHFl8lrgzRyHCeAcbAt6u2sAzWxNYXWVzSm8OPnc
	 jEoXlCHuWPmrfSxY0Lld3APgm6jBc5rg50QTlW/DvONAsHU12L+vuSK26/U07oDVve
	 H7wTWOkGt6JEw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 23/28] mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG
Date: Thu, 14 May 2026 17:44:24 -0700
Message-ID: <20260515004433.128933-24-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D790E1C0009
X-Stat-Signature: c6aypewkps7x7ejfdjs5ucpabsghcz6t
X-Rspam-User: 
X-HE-Tag: 1778805897-707734
X-HE-Meta: U2FsdGVkX1+yAah4sGGP5qnZmnLnO8ZjKASscqHHXF5dN44/3QYkhTKpKRpHstpkmY1etqQi38CejCAo89hjP+kYlnIzhffLucDOBTnnf1kGBGUOxyJWHnJc8A2ZmX8gNk36JiFAStBnwQ2wDkGYmQtUyP4xr/EWiTrPEsppPFGDE/JNALiRjGSHF2MkT/+LalkxEkli8KIvcV31ZiBF5KE8U7riuUbDJhjwt1fRNKSK5bmJMxURQyKdQ4SqBeLU0/eLz5w8PQIuRclm9FqunApr1eCdOYw0LxfE2KsYGi7ZY4X6G6mxxQINw6LNW0RuVDmLgME2a15J6AdfmlG4BcygcKejh//MGjcZHE5OHhN1E0NuyFU98t9W/dXv7x6nqM03S+n8fJfwfunideMsjuwvaYYudh9Bqi0IaEHnQwx/ajAVuIq3l3A9YkEdUVAZ34+3mTLpGrgN20V17Xp0bv66S7lpxbduvXF7xl7R2z8tgN5t3Z4FjJgfmWoGBqONQqH43SAX6Y96pO/5ZiTEQvFiIQq7Bi62HafP27m0S37gSuSnWL+247Jj+5fCI6FpdKe4umoRVei3480Twh5pQ9ompij9fF1SakV9xshKnL/+Xelm1iXRPA6TUS/df1S1edmPhwdx/UPFv99wEBJFAtVMz0Ba3f8kzRaW26CoGYBRfCPkegm2x8rdIkFstEHRNpKZVj8lQsf5j5DiIs6Rtvn1eTtxOxQHhAWK9Bb3Pg+jnkLE66OlJMXXzrYju9CfYTstJD1uoxjBzNBiZqk7LyXc0XwSQr3TS3t0ZpGBXqJ0PiTmHUHos0b996BIYKX3fbGnAKFLrATz8flXVavjjA8y3MNnOzAGODulRy/KIxyL3DM2c8k/OJiYdPSKWoE5ZNE6CLDefvvrZvxEBgd3hDTPY0kkHZf85yHqEKG6C+cAXH6bcHpzZVANKL1cbyEo6X6+MTphsbOJ5QhA/Rb
 fiucbvW3
 tT+13BnWbzvQfsLIB7y1R0KotdVXPB6iebBKe4l6qTOy5igZ3DmqL5oqyZj8VV6S7ltm8sq+SA80ZjoqqCd9vOxd06hiF3Cgp6tqYGJTfsxumZ4O1aEXRA9PyA68bCWtnSWPzVDWUlG8Hx4lbFeX8ZdcoCoCqm8PTb5Az5MtWZ49dD2fp1Jkm9tkA/DWyJ557DC4eTY6QkT+qS6o0uVzwTf7XdxVnSnNbtfPyN4Qdfs85KYk7tPs5qy+aGLsiaa5zWuL14hvGNx97jFw9KKwRz0hmDw==
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
index 493bcca8ff104..c3adccc2e6c71 100644
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

