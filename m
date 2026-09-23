Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7736BC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F686B0093; Tue, 22 Sep 2026 22:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6846B0095; Tue, 22 Sep 2026 22:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D596B0096; Tue, 22 Sep 2026 22:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 216E46B0093
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:29:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B264780688
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:08 +0000 (UTC)
X-FDA: 85243444776.04.AD388E5
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0EA1740006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LIElmXmp;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LT17egyswwNYbdkKQlMC/Q3krO4NMxyBssaINTEsn5g=;
	b=jnghA40HqBokZuonjWgWJ4bg5CRa7IdYLOKxU+zgPV2mMV7asmR0HLKLUWYLc3ek5IwPzR
	mBxhlY5p2vAWecY/PbKAesLl6LL/Vfy5RAeXg5DDLhCPv6JygEi5E+DKawtIv7N4qSKBhA
	gPiSVEcUWUDOLdIRve4cxnXFRsm+TCk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LIElmXmp;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130547;
	b=m/BipHkDQsHRu6GqpVJ58JE0jscPnhJAW6UtpJKoItxZy6tSFRpJ35pQUstjbrMRUcTJHs
	a7/ZQTZ6ydL51nGfIJEOqcbs8+as/TlYasVKJPcPaL2tJ2irhbXczUE2KmJjJXi8Jfxexz
	oY8Jrg+vEckZ7ZI6kAx3eXy+bOXZXec=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93a222edc62so56085185a.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790130546; x=1790735346; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LT17egyswwNYbdkKQlMC/Q3krO4NMxyBssaINTEsn5g=;
        b=LIElmXmpQFY1FcHqWDmQs2iIvrJJK4lQfavYE/q0SbJ2fInW9J57TtNx5AoXgepAl8
         bA42APGO3zaM6b54a1qrj0puD5pGZNv9U5mkgw4EMvZa1B0vhD//8MJEzFoJfRJ6qNqs
         B8lCerWHUjnOSRWFXIKkkLleb8ICrZ5ZgqUJmC5h65zJfnQQps3w5dSpW+b+jdoC5oi3
         KQm2EwI7ZuS36kngJVHBzkDQdHVKWkMgYd7DyhBJG9PtTiq6jJZySEe17cjE+7+/q16B
         hA/q8IafsjJr0rfZ5Txp+GYNVgKEV4HYyung9bI5+d+gMRo+JF52I87ITbvggFt6EAY6
         cU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790130546; x=1790735346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LT17egyswwNYbdkKQlMC/Q3krO4NMxyBssaINTEsn5g=;
        b=268hIh58ns3rKNw+TJ/3FVbTQ4RtuCRNhipkq37aeuAxPTEqyAVT8037wKK392fObw
         CIaqrF3D5Z8gRA/u3Hf1NcTGJ5xb4GTnK5eOCjzX40czhC5YEPJMZpnopG9fRmCTcOdt
         ajJ8Xnz3EH2ZUbDUzh0JffSdZDy1s9RsBzqVniTM8oQ8m8YCzwL8KjCGkQgETi2wSkIn
         5QORu6pU5xGG8Wped3lDcl+UqvkuPIHBytXpncfZ8dOU6HkSNralfXFxIgKZjvSSwKqB
         +3s8NyN7mmx3zdiqZOZlU/dzntZ/K/y6Y8Uq671S8sBCINL6M9FYZwCaGga50ctcFu9r
         k09A==
X-Gm-Message-State: AFuF++nVoTxyASuoBs6sX0hVgyTg5qzQ0Cc5gf8RYiH6vfBBGQG32oVf
	8rnREWR74izRq4fscMaNd0914bhyEpMgROoPYaweU/RjTUamZiV4Gcau3gVEveVDwx0Z1Buj64r
	Nr5UAD90=
X-Gm-Gg: AYBFou3wvg5Jc2n2LBDr/a7J42ICfbz+ia+gP1u/a6lc9T/aPgXWCFg+ar8szt12tXt
	xVZdb7M0+TNIVa8pzhuvEijHDBNgX13yG2oZCqgw2K8Y8X/k+XqiTcackYwXGZ/l4t84gO00ejo
	eDsALBj1h3LKSL/c1XRwYVB53U+NIrDhlQRQ7VinSSRmpzLrnP5srYVUhBnewBVe0Nu5k3J/5UV
	B5H+jINpVA505u/R6SH5XRGxTQdQs60VLtoE7tHiURN2lu2RgoV2OKyQM239bvXvWm9fZSq8Guy
	1bzzNwCQPBTNouMIACCu3nJgLQfxmUozcwRTqpO+CxMDn41syAwwCd9ZNyLg4izWeE4sjTLvoPf
	JZrLx9nonkmjsEPUQJndmOPPVPVZskCk1PATBrnOVl/+A/q+xAccdttpOZcgbfZGZX0BJcSBEoY
	xofCJpEkvGw87IAbYcra42mcIQeOaDuGpj5MATgR+R5Q/vcgKQkPGsonpuBX1HpW1gAS5GGoHOs
	eNA8VPjCd5xlVjJjmp/qj/tLhsB2W8QHXwh3iHOTl+YaKlBWKgt427qz/tm
X-Received: by 2002:a05:620a:6286:b0:939:6dfa:4975 with SMTP id af79cd13be357-93c25216882mr212753385a.52.1790130546229;
        Tue, 22 Sep 2026 19:29:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2482302fsm122626785a.12.2026.09.22.19.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 19:29:05 -0700 (PDT)
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
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH v3 0/2] mm: refactor zonelist constructors and iterators
Date: Tue, 22 Sep 2026 22:29:00 -0400
Message-ID: <20260923022902.2433614-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0EA1740006
X-Stat-Signature: 7jo8damzsj854trwxbg5czn1f5gof14c
X-Rspam-User: 
X-HE-Tag: 1790130546-617621
X-HE-Meta: U2FsdGVkX1+EX3UtliOZLiMXYZ34Z18+IMPxAtDQ1sRL0/Kpvrs5PF+AFTH0RICpch4iQ9qQ0In6/B+lUgfk5ohtA4tb6H76ZIig0u6aJbbEo3+VNowWa9rGbpOMe0Jne38waqpqtRYQDMaUFoEr66aroZOs/8ZiBqTdeR7sOOguhQUFqf5ayeIRL8C1Jpf68jtzGlHpwyWcQGE6cLsrNualU2p7WCwS4yti/BViQnQsGgX4tXYXG39gNUeV9r8q0kMS8Yp2k6T4VnZHz52RCRn94s2udQkKothn9hjJpJtkgoJkBxhLBrtqty4wLdpvb9REC9XHOzrfLieDHwZFIkOco5c/tV76FQ5Hw6BTqxtFrY8jQzc+gyvGqh/8hw0tVxWGPEAd41CElIm/2Vwo8yuOPLjkaaz8iG/phfO0rWPjO3mLG+vDfZmDIZdscLCDAx6DDDu78uq32eKVdsoDah23D0hRQE33hVmwyXA6agQq3XzQnMUNrh6p4T8w5ZuqMwl/Gu5YcPunmZIoVyuBVuXhT0UpjYH5YiEJ7QKtTouKAlTgT/hWa7Y0Xtf0/zBxYTeVxoUEZN5Y5FdXmIP4REjEcbA3kLOMr1mS+WrJFvywUm3nzgxR1PLFCrw+s69JrDTq6nN03KOiYUrV/9oJlLH8kHNIm3ndASU6P9QVrAhPFIqlJ9w66D6Q1/bCx6tzQSpDPqIMlnfCduhNwIqpq7mO+AXioKXrvqGyTE5I4PcEoOieqPQ/l1OzF/UtrmsslyaeSxhZmN8bXdbCMO8Hh3RmKs/gzUQpYc/oqQNWUB0qeqLnHEBy8K/LnEay4/SViLw5V8EQx67QV/UmP9ih1MatiosNiC6HArzMqaLhHIG1s3KQHeQKyUqYk4OupfI9U8T34Maw0f4sqTCrYV1p7P/6cBroiUzFDyYNbZX9+Ez+6yMyrZCTB54+3GfksrQd9M7VkSAJDUqO4J0YNkB
 T7mn32d4
 xm4jjQlglf4UXOEOWvH17r9w8QfIcrcBrSarwR7y3zV7vEf999omIFnEiob42O4jsio9xfMX1rXHFe5uou04XUZE4U7bFxhzjbvfdkWQ03F7x8dB5jpit2vCEPL+pfQ9vLooiCuAKet6V4kRXJptHEzWHY8g7Y1It0nc/Dn7dkTvWwudcjNInsJMbQmUTyHGXoVZ0pQbK4v1V8A/Dq1qDi2NjkWk672DHDQystyaBDAG1DToOMLU4EOonvY/x/yGm/n1oLKfIqeKXbFNFcFN9YJe1di1vOJ3nPcwe/+QbHcjIt4W6YEYa7zP6T0UwRUQfzz+C
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
and destination zonelist index.

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

v3:
- mention the new zlidx argument in patch 2's commit message (Zi Yan)

Gregory Price (2):
  mm: refactor find_next_best_node to find_next_best_node_in
  mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()

 mm/internal.h     |  6 ++--
 mm/memory-tiers.c |  7 +++--
 mm/page_alloc.c   | 74 +++++++++++++++++++----------------------------
 3 files changed, 38 insertions(+), 49 deletions(-)

-- 
2.55.0


