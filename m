Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E35C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5C66B008C; Thu,  9 Jul 2026 20:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86556B0092; Thu,  9 Jul 2026 20:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5066B0095; Thu,  9 Jul 2026 20:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A316D6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15ACCA030C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
X-FDA: 84970969524.09.44F994A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 71033140007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g6uQQOD2;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	b=MAonXVyEk80bM8aTrUir14Mk2ff3kXYaqiu8Zjofc8pYLKxSbc6SX2dqkThFYqUfy1Q2zY
	TrtNnfOsV+Kjj8ZCNritiusGotj3QIY6T6JscqRX9GOAnCeBT+2NYe5suPV54aQbPVQUPc
	/QaWJHrBBr5SVl2/3vapi6GmMKelsD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643040;
	b=b+Nc6lKbXx8f5475cPF7J5j69UbenslOC9DeTI4pLbN+2IvlZxf3AXaYLBN8LbfDvhGOKB
	Ik+AIZ3dC/qFMWXdsKLJCAct2H5ZyRKiCmvCypsG8vqfd9nATP7AvIyaXBlAwWZmbomUA4
	onujxSbBaJXfiITWzoRu4w2iA0gHlfM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g6uQQOD2;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B178344079;
	Fri, 10 Jul 2026 00:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4F71F00A3E;
	Fri, 10 Jul 2026 00:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643039;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6uQQOD2abNdpVUmW4Q//rXdEFonp+j3IZcE3TB5fO8ayGwXXurfopmhSyOgBNBBk
	 C6JzjYvS6WKLgYB0jh3MY8ouVimSz2x5kktY81Eiu5Njdm9jh7EKHVVEJWi1VVh3Xf
	 LN2pL77fjVgj6l1zOb4DCSE9UlCae/NGW7udXKbzzSZCHUxCBsi3/qDJztXHHrjB50
	 ZmJXsNWO547J0jHYn9lVyD+1dQr5j0McfcUH52Zj8+aygnhWa6zscFFiFM1/Hg9Nii
	 +mqIYvaRYw6+lxcZtVll+yCUspxlpxoaqzolYZ3gC2snoE5r1wXprb4Goz4PjvVi/O
	 RaDpl16libW9Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 03/19] mm/damon/paddr: set samples in apply_probes() if requested
Date: Thu,  9 Jul 2026 17:23:29 -0700
Message-ID: <20260710002349.111414-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71033140007
X-Stat-Signature: 3neo17h6g7cko1dbig44pzfspmp9rxzi
X-HE-Tag: 1783643040-462858
X-HE-Meta: U2FsdGVkX1+8xHrxZcDiwMyyXuKjteNwsLmkBp+JyOLUiJaW3e44U1TXeLyPuRwAJM0lse6s4jPhoNPgS6Q5mtVDeHuezZmyiZHY6vz+nBYJpLbgCUaU6fSF8O+1v8ao5f/20PEwS6M+nUsPtIgxThRTWxjnPMZBpDdp+2yQJEUKeQoRYFLOswxi7xujBCd9yv/PxtPqlF28VQLR/cuW+MRXPegaKxpHpywuPv6TxStnyAFT/wKWjf9RyQiiNPamoaqiNajAPN7WZcy6SXty/fPAkn0NMX9JAkaBD0ODrSc9Xknn3Of1FetlRVUBZQfz7L2fFJH3GIgIveezqS7cAlGPvf1DeY3U84YwZxcli5uy1dAgiSiPVZKzAtHTCrUJOz1NZdP8udKMwJ5V+3WtQFooYExlZZgS9AjH7eoHL7oekE9ljrjtmEPLFdFefd38Tn9BcAgz3P3y221QoNwYTVgmDcUOUqIxwoP7Yzlob6HS/LNpL+dWw9QeR725BmFuq0x4y5QblMl1uEpdGreKBAhJ+VV0IpAspiLtldd0zLmNWPZELz4HvKDSPPNUTCIRb/03LiOwFxycstaBZetWMH8Jeldbx2Amh3fGv0uHLsAwknsawYB7cFt9yOTyymuArLpEoF9M3XHY7ejnFv/Hxd7D920TegST2PegAuc86cEh8Cf3b1wUKgMJSnaqL95rWK+wqlFV3NDTBhgNxUFjrOW96YQzOo1LqHY/6TXmCo382Plt5d9gHXYetjU6DdR3rGmv780wNu4IayWmnkOECvHqRNxb3EvhReyLX5be28BiL9qR8H08COC4sZdKbdScTLhO8x+C6whF6kWu2sTVbSRCwlgCvmitI1KKQp/+80VfOxd5p1BscIgG2+tKVaUrysuCH/vkD8anLBbcOFqxWFNukar6fLjPNU5/0vKgHrArIgVNqZ8O2/P4pO315u9lniiwwQuob3KZDQwXwHc
 1kcsJer6
 xjoeeGA5nhcLs9dkzF0YtkQ3iMGEAjN5Nsugq00W9TJ1yPzuhJWlMwCSyMUDl0TfGDz3FUItXgQMRCKng8rEenVfrJ5Xk2Q/mkRohYdAw5zuDgFKKX5lU4vEFJN/O5N40/Y8LfhkXolJ9v4KCq8fJWMXhEswI8gK++/Gv2SL922DpsOVS1qQWia1wTFSs7r9FbCW9DfG4IUHafgaLpHUMQ3yUL/R9newMx8zvLqj4AnmQEZvnfINXXBj60AMobXUXNqP6F4V6kwsEjm+JgwonL5aR+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_probe() callback implementation in DAMON_PADDR is ignoring
set_samples parameter.  Respect it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b13bf7c6eade3..ff4fcca949660 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -178,6 +178,10 @@ static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 			phys_addr_t pa;
 			struct folio *folio;
 
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
-- 
2.47.3

