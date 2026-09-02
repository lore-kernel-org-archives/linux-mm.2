Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BC1C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5456B00B6; Wed,  2 Sep 2026 17:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D866B00B9; Wed,  2 Sep 2026 17:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA7D6B00BC; Wed,  2 Sep 2026 17:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED1ED6B00B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:58:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C06314038C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:58:58 +0000 (UTC)
X-FDA: 85170187956.29.2DF1E68
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id AA3921A0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:58:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gJiq+ZG/";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788386336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Tdxm7M92DTyoyevA43shvxeG5HzPMJi7QlM30070D1o=;
	b=1vsyiLzh5gqQch1MUcD/to23tw69kCD5CR8nePXMJxeNOwNkPU6a4rM4GSTHIYWo8qEFtS
	MkfeD3CNV2erwFcDZ8XfCTCcsDZiWeZnsuL/lCAG76WHUemJOReT5DBDFZYgT9RqrD+Fg5
	amYnsDqT7KkQzZ5CmW/MTiWi+tcN3oA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gJiq+ZG/";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788386336;
	b=nf4roxbaYJ5w/nXNjBU0W2CUl1iHBVoa6jhJlvobWXZoezGacKKdQ9Zj15Ff7IuCf43Prh
	Ep7o/9v2AZU3BLV0L5cLIJ0dO+OvuxxACV/Zhld6Rp38DddKCH4jlOu8jxTo4bS8XeMDL5
	MfdKaK1F29LxkYgnVBo8t91ubfk/H7M=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-90e7fd978beso23879596d6.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788386336; x=1788991136; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tdxm7M92DTyoyevA43shvxeG5HzPMJi7QlM30070D1o=;
        b=gJiq+ZG/zZNLZWUF0PwpDmfRwe/zSEQuS6Xbg5d+LPh2lqiWV6IhKOSC5XzvptLmGy
         96EXyMQ4HeQUKrnWz+/0WiInCeie+M15PEz9A2SyElyGcpTMGwRHGiekCm4LHiotZwKq
         fCloiBrNua47UGrcZBISl4u6LCYmyl2a62qLsK0+JMBzrZM91/5f54HusUdpWQT9lkFE
         HQP/lkfAkvRaph+u58wWnH0JRvPof7fqycrNcXz4GjBxbI8g2e2xlBlNXJkFdjSJmgSL
         nxOY96G8tZKDPGHdv96zfMuNbvidKUPbgzg78gWBcaEeiEIfux+u5For4gZyJz3yIlCz
         6IUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788386336; x=1788991136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tdxm7M92DTyoyevA43shvxeG5HzPMJi7QlM30070D1o=;
        b=mvpCEOL+xmfe1v4Y0VxR7pLjNocN+HvJd1szTus6gNIxOPM6nFUrURv2A1s0bazXDg
         9ob0Fsm+G7qVn+1eDsftEJUxrDU0KP14f/nHbmeFZSOTsMgYq9BvIeLKX3FMWP/9qfxd
         JTJF9yqY5Y++1sqhMN+0GzD9Z5A78zVKkU/i8XIHAMAUzRViMbcU+YOxUz7TQ856hmH4
         J4PhK9jLpPUtJvpnToSMl2RZr1KFtbYUzEStKs+63/oHVdJ3nh7QbSWT1vKozGoR2s6Z
         976kLgOCd9RqxCkTu7hFnVObP7l7gSJ++RFfDeBpiL0UlNT1PN/D+bhiN6lXP2LmLFum
         4zGA==
X-Gm-Message-State: AFuF++kPkZGqBwa1gV4j2YRFDZ7bkqGI6qpS46E1kI1r/M/QKdF4PUie
	CTxIsVfvUmdrDQYwKD+nOYMHtgi3ecTjAJpZuoLNZl/2LyA3YtzZJWEXKRDxrBtBBuivbKtz9sG
	G3cxC3qE=
X-Gm-Gg: AYBFou1NxnK5XEOmBlPrmp+ADeTIWuWIXDu9k0I+yh1Y/qlFOYT7dH9UXUuyyuiNjmE
	FXNClx1w3B1mMEVqgE1CuRn4mqAEO2ceGUr6yeq39Kh1+4JrZpsaOltTdzUit2KOKw0Xw1uhHBb
	MDJ44ZfzvTEAh6tz7qF9e42B27Qo0NZLAoq4aUobmkBS6tbk07BuG9VDFv7h0maJ4S0M+xdBdo3
	my8aEpzRfJyChshUj7RL3RCXTQxXc6/JzrwUKEx5rId/FfLaH471NYMG+Ra7z1s+78Xfy1nQl3c
	l6y0T0k8mSsJiklKCl1mh0Hh8A85dfdBCAq6cy9+E3Lye7rANhecFNSgGQEhltVUJ0zCL8WrUXA
	N96Bw3mdP222Ihgkp+FGPJQKtl4PnHFrnY+qpInVrsYi7+CO0zhMXyPOL5kIwto3ZNjtMDHHrUf
	+JUXJxTiNp+LhMfn2E8oCkk6+by3nyOY34+CrbBjyjaD3IzZPb/JbofNd/wY/ZmtMnHWrp5RODL
	YdqFuV+rODVWCcngURwntcBFfJiYSUYKyCZyYOA8sGJ8lji8A==
X-Received: by 2002:a0c:e011:0:b0:910:3219:6682 with SMTP id 6a1803df08f44-91032196708mr46818156d6.23.1788386335770;
        Wed, 02 Sep 2026 14:58:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ef0ef6csm27578886d6.44.2026.09.02.14.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 14:58:55 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Subject: [PATCH 0/2] mm: refactor zonelist constructors and iterators
Date: Wed,  2 Sep 2026 17:58:51 -0400
Message-ID: <20260902215853.156267-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA3921A0007
X-Stat-Signature: k5st6ejupy86p7muou6zs5mw8k6cyh6m
X-Rspam-User: 
X-HE-Tag: 1788386336-864344
X-HE-Meta: U2FsdGVkX1/rkCJPGI42f8xLxFqVNyNXOSS0zS6tYAAVFiIovmkBPCHeoxWy2mfhXGJONrvdOqMFXtwgf098S1xWsCfJV5CtHix9RtdkLoD8Su0lGyzMkyHfBE1uooWA/fu0RP6eFrOwlBr4fqmqZPk0WRN8ADT2n9IXBkMj25i3c7ojn78EXthSvIgjiB07xeEd1RHs2jzkxSpUkrrfar7jdrjNFxBcY9aCVxtZ7OW7aCxIK6ap/NgL5JY4EDIw5/dTBL5NsR8Oasw3Uvt+JpFpbQmJ6bOKP6OjxV81a6W4UTitRLqNCMazZZXaBpDEJqG7dRLMoEMCTQTjlNq5HAxc1gSMBUpR0wScT/Y9pwuytEIh8WRU8qobQammzbSwYqdzbH/kJk4hQsna5jaq2O2jpop4bpAfjthZwqt1WaAzGEDNiwy+VCPWONGGN4SmxRbMfyUjiQ7oExGwnyPbLwYuBNtHd4xdkjkTcJJi1UQyqeqpIe8y25f2pk3iOzGiApiMZ1l01eVnm0KfPzE6MHz8ujl6hk4BZY/o/0oxtPCb2K2Z0ORRNUHJM2AS7Puz2deMZM3Kem/QIvStKs6nPjdx5uSLYBdNbcnHhQMOW+geL7wG0tY0JqKEcw19RP5X4YFnaeHSN9RYYf1sOjF1Ay7SZkFDnwNwebhHY2Sui2dN3gcUFlasOJfkZjPKAMkaZo1yd/iZ7YwHSGynXvTUTyY8nBiwv8imFjjK/dewi15qlISvAebjsTb8lxY9mTj/1uU+p6ig0klgkjMsxOBpwRE6nMoTb3VSfn5ThbYDAy0ywL7RrTzvehjMVT9rnBPFyrVgxus/995Os9rlt0+GpvTCWdWOGf+ONQmKPD88semIqb95m+H3HlAv8yM5EsVDy2hwpmIg5BeuEqwdJ6CyN1EaHOprOIHFAhCs58TXU/ziW+cFCrnC2ov/pynpdKTA5pKf6h0AfHTylsu1iiM
 oAYGpgCt
 pBZPFSsSTwqOjV7MeSyJyetAUyJCs8pFVj6sWTTPuLrb52RFkA9CA4D1kt+wa5yTEFMg/4NtQJ9N3wskHvSp+PRLjS6EL9v9QUyNTro4//lZ05SfCnZD51NfzjD1lbKTcPcHLmIsbHBDvzDbBDCjyM3zBepR+ISBkiyaoVGxCO4OGFiEZCuNvhUiK8NDqFLojxeCJAc8xs9gx+qcu0HFXwPa2PsBouFc9jAZBNP0Ekk7dLqL0ZCccwZgd6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_next_best_node() picks the next-closest node when building a
fallback list, and hardcodes N_MEMORY as the set it picks from.

Refactor it into find_next_best_node_in(), which takes the candidate
set explicitly.

This makes the existing behaviour explicit at both mm/memory-tiers.c
call sites - they select demotion targets in fallback order from
N_MEMORY - and lets callers narrow that set.

Then extract the per-node construction loop out of build_zonelists()
into build_node_zonelist(), parameterised on the candidate nodemask
and on the destination zonelist index.

Together these allow a zonelist to be built over a candidate set other
than N_MEMORY, into a zonelist other than FALLBACK, and iterated in
fallback order over a caller-defined subset.

These are prerequisites for generating a private node zonelist (nodes
unreachable by default), but are otherwise general improvements to
the existing interfaces so I'm proposing them separately.

No functional change intended - purely refactor commits.

Verified on x86_64:

  - find_next_best_node_in() compiles to the same 319 bytes as
    find_next_best_node().
  - Both mm/memory-tiers.c callers grow a single instruction - the
    added argument.
  - Boot-time fallback orders are identical on a 4-node guest with an
    asymmetric distance matrix.

Gregory Price (2):
  mm: refactor find_next_best_node to find_next_best_node_in
  mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()

 mm/internal.h     |  6 ++++--
 mm/memory-tiers.c |  7 +++---
 mm/page_alloc.c   | 55 +++++++++++++++++++++++++++++++----------------
 3 files changed, 45 insertions(+), 23 deletions(-)

-- 
2.53.0-Meta


