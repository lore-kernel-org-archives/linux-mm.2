Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C29DFC88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880326B00A0; Mon, 14 Sep 2026 10:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6F56B00A1; Mon, 14 Sep 2026 10:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A73C6B00A2; Mon, 14 Sep 2026 10:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34B0F6B00A0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:20:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C12CD1C0752
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:05 +0000 (UTC)
X-FDA: 85212577170.09.9F61D80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2EB861C000F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LLAJKd3P;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395604;
	b=bBFRUwSn+p650dVPugBQnktwlNwEdA3QplIAAGccvQ8ENCPitNQD+zOTAvaB8p7TKOXZrp
	m80sQ1l8RmWkNkQlW/juB4DCy47huRT2+c/FcpXsw1Y6Fwc97WLn+OlWXu5TPaRpaO3bqg
	IIuFa7MotatuDqin6s9MthguJJz//QE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LLAJKd3P;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgI5/uHVhGU/u/lFuomzDRYuBHWw9s688+WF+gpTSJY=;
	b=PbzJt2RArIQn780o8tttedJld2pn8hOPAscmSHXu75lL5AsaYP2e4Gg+B7TACZsxJyLcdl
	o88j4yIEdC6qpQ0mhxADS0bRyiio8WnRIxk9lHgmCgsvexVwFC/K6LA67LMZ5wMIUnkxOT
	DDZ7Rwuw+yn5lsnxg3RhfW5IvwAmE6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD2136020C;
	Mon, 14 Sep 2026 14:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA581F0089C;
	Mon, 14 Sep 2026 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395603;
	bh=dgI5/uHVhGU/u/lFuomzDRYuBHWw9s688+WF+gpTSJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLAJKd3PZfZJLA2mghR2o10iU2ZFbouGRqCNO/Ce//Yu5KWtT1Fb38VyB0L08FCuA
	 ncSquZ0pmtNWj09L9+9wH2JgvSpzPbs7SgODgo6YgH3GSKvF/qjQlYeTePa6G5siUg
	 Bdkg6gHk7rP4yAUkljf3cR/u0FwM7Cj2fwmJgMDjiFuBju+cdwiJREDEMEH9yQgYbO
	 ET0CLVkg/JmOcmT9J9rFgy34S3fSuxjIQ0YUeeiTvpQJ9720JaTYJ+mHvdGA6WdHWp
	 90jegwteY51FeTim7QjFIXDEhCh7EoyJQSAdw/7FXomE+LQsrBn3qMa+PV60IZjwTR
	 9hmHyPPPeai3g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/6] Docs/mm/damon/design: clarify when qt_exceeds increases
Date: Mon, 14 Sep 2026 07:19:50 -0700
Message-ID: <20260914141952.91465-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914141952.91465-1-sj@kernel.org>
References: <20260914141952.91465-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EB861C000F
X-Stat-Signature: yk5q35itp6prrbxaidh3c16u337ef1eb
X-Rspam-User: 
X-HE-Tag: 1789395603-512650
X-HE-Meta: U2FsdGVkX1+sERTCrbW6RCjZgXjft9aFJn2onAgS1Lk46eNyDB90gERxYPlx0MTNp0/ydEMJHIrJ2bzWVN8uvc6JRMrktKm4KHBw6mUZi1LSrptdfiE9U1iugIvvlhVk8EcFrEjQcN6m1Kf50MvIvKJYIqhnE1LQDeugmM0dLe002ZEq+kYFVQEtOgjjopF7zRbMZlojKyrvTjijd5zNUVOpFE2i56G/eGHvNtxCxQ+D/zP2M/8U+VVsC2ffaGD2Je5eYxWHl7e/jVE89p/rIBeS5k4xmJrmsZynUTpTIm/iqeWGUh/Uwb9guOAQhPUGvkU0DOHvtvpvcgDnJyn04DkZU2hGHJ8Ga420WkbJprFoV7vQn0KUKdXwA0KEDoSAZYUPaIxa0+K/+So9sqoLdv3q7rHVBZx4/8a4SAMrwea1amKnEjE7tod8rUt97WAFclwuCGzNLoNCZ4dDG24z/CTwint7SEzEmUmk+Crs7gej43ByjuPPKEnNZHiQRnonrKGcLAzVyaY1R4gSH7fUdhrSWwHHI88e4Bf2RjpOd7sfB/MvhX3nrpsjKEBUYTGHuTUHEDILidaz7UzVdIsYX2V3vHhswC/98hd4khq2ipHdeISVAMWbkPJNwvz48znmYr5/yrCm0JBUrmuDDRYyrmU46euL5Mf7u/Pfw2X1PcrvR8H4x5wX0u6b3X5JbUfIbLjSn5OHYlDbaAkis7rLNI9zhkESp+TKJxBWl7SEjGUU+zn+7t6GcStcGhpU3i1g7CtjEewN9kTSTQohsIqpqNwQHdOv1tFSUODUvt9SHc7C2Gz5Z6hb4f2aQEtXJaoeNLaVRZnWLky1HCFaIavN4vkW1scBZiBns2/LZRJ17AH51em3Ef4RBsSWvU3sJVPdZZdgR+D47LMEu8nif3gCR8jdpcczbIkx2sKWVmNmF7j+urn5gbMVLO5QEfv6XgrpgsKsfJOg4fox4Fj8az4
 Ed9EvCMZ
 v0JthkMeqf6uBy8egdHjF+fzVLu16oFMXnz+ND20idHani16+2NX9E3wi3oN5RZgzp5T2U/mnDTGgh9/7q79JszkpUgS7dR1Uq5ODJcfRnqDTkjmac5NAcRUomZ4BdGxFlPsuifXhjjevuK8XbXu1EnjGvz1efpsb8s89DnkaHycxN+vNPlRXJp9KZn9vPuFRU2cTn0f3kfUrvAcIwOVCK6WQYazQxHS+tmeFRwW5J/ZxnikhlF8RqYP9Up7DrqxelVFuReqVbk0suQtsjJMGsHHrmkPHhJFC1U5RlpT2izsYaseSrjC3/jUFPud3RgN/JQBQxVan2h8001U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

qt_exceeds counts how many times a scheme's quota has been exceeded.

When using the temporal auto-tuning algorithm, the effective size quota
becomes zero once the goal is [over-]achieved.  In this case, the quotas
are still set, so qt_exceeds keeps increasing once per quota reset
interval while the goal stays achieved.

Clarify this behavior in the design document.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260910112255.157012-1-aethernet65535@gmail.com
- Collect R-b: From SJ.
- Rebase to latest mm-new.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/damon/20260908175105.42558-2-aethernet65535@gmail.com
- Simplify the explanation.  Do not provide a complete definition of
  qt_exceeds, but rather explain only the increment condition when using
  temporal auto-tuning algorithm, simply to prevent users from becoming
  confused and being unable to find any explanation.

 Documentation/mm/damon/design.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index cb116a82ff20b..ad09416dfb21a 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -696,7 +696,9 @@ There are two such tuning algorithms that users can select as they need.
   fast as possible, using maximum allowed quota, but only for a temporal short
   time.  When the quota is under-achieved, this algorithm keeps tuning quota to
   a maximum allowed one.  Once the quota is [over]-achieved, this sets the
-  quota zero.  Useful for deterministic control required environments.
+  quota zero.  Useful for deterministic control required environments.  Note
+  that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
+  <damon_design_damos_stat>` will keep increasing in this case.
 
 The goal can be specified with five parameters, namely ``target_metric``,
 ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
-- 
2.47.3

