Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D060606A88B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DI6cec1l
Received: by kanga.kvack.org (Postfix)
	id B67EB6B0678; Fri, 13 Nov 2026 00:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FE36B067F; Fri, 13 Nov 2026 00:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C736B0680; Fri, 13 Nov 2026 00:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 787616B0678
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:17:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6051340A87
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:23 +0000 (UTC)
X-FDA: 85428937566.17.AA60439
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CC2DC180005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DI6cec1l;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794547041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeP31xDwtklkLCBDsJsARx3xlsMptNDNnDQPe92kOMU=;
	b=SB1IKQSttlhPzkcDvvk6nk8FgU8367ZuWgRZDjLUNlcrntq4oCPZ9sDL3BFE3fc3uEjvA4
	w9o0nEMmkUChjmYew/+AIbd+CC8I8gdshDlidzsp4FtYnVX6WRXynoHDqIqkfvsFr2Xgjl
	l3svxR2oSV6IcwB0QYM0H/gaeiedkuE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794547041;
	b=EBb9e3UjoCzP2cEESGrgLlUeU0E15emDzSN+UDvX6WY7TXjiUDwhJjQusAWNgvfbPhUxnX
	mgVBd2v6tT3Gf/P9XxZp0agxj88LSzcjKtZBhqLkpWI5FsNEjLhh6QciUc0cDOadQf4002
	KNmGKw4cXfzKvZRK+M/7ZooR0c/kIwk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DI6cec1l;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2703E4603E;
	Fri, 13 Nov 2026 05:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBE41F000C7;
	Fri, 13 Nov 2026 05:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794547041;
	bh=EeP31xDwtklkLCBDsJsARx3xlsMptNDNnDQPe92kOMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DI6cec1lFt8nmjrGEBO06CLJUfSSC0a4BWkepHbUenLfF+pTjP4iHYOLkmB8PSAA4
	 r5pUMB7bEhqPBrtWR/RmojjvJ0vlKVEDNcYG01IOBUSbRefGRBCFdnxwif74ZyMLqE
	 BaeG+uliSCOC09CuaZQeCsCw/efjvQgDfSmEaP/qhwVdN6YqoZmCyp0w7AoMRqdhFU
	 1cV4AxixDcFvYbDHKiiP5vewGsfSkAUAD8reJhbdvD7AWipadBUlnU5ybqNUkTMlK1
	 WJF4npA/BAcQkbM+yr4SLM1skaBp5R4fNs6IL6ezmVfxGA404PYlgtFOykjaSnLtuL
	 L6hzl0asMCdhw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/4] Docs/mm/damon/design: update for DAMON_FILTER_TYPE_ACTIVE
Date: Thu, 12 Nov 2026 21:17:10 -0800
Message-ID: <20261113051711.89274-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113051711.89274-1-sj@kernel.org>
References: <20261113051711.89274-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 496wb6k5u9a47f7trrnb4ywjwfkr3a1m
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CC2DC180005
X-Rspam-User: 
X-HE-Tag: 1794547041-499237
X-HE-Meta: U2FsdGVkX1/8Hm+IXU/UwHA01WNTxHOk0VSCFJkDX1PuzbIrbufAMFVola9kRKQDKaNS+GDXZF4EzcoRRJvFZKYYEoJgvO5QMnShmnvtwKzLMeGOzuuME8+QcOb1Mq6qzmFXbBQuF+I9B95WyOAHLksV27bejbn5qT3+zAzbls5F5BV93Lkfc9pJPTQOkHQoE6OQWVAKHoJXetnA8UoYKNbuLTIDeqEmY3S3k8CKMaXBgsupHGtrgYM5086s48eMUsaf7LAf0heI/LEk/t2GkLoWkdnnCXmziY4OuRpFv4o0c/OYNOwCMRyAWkTleAXqIEQh/7VfSFtMnawseoWcXUZZ3wBeERfZrafkqKymkwOU636ACC3zS4jHddlCg1YoUBXOIbo/aLknCrLnp1B3BLw3FvKM7t03Upg4HL8cHzYp1LmbzMc65Utpc4g72AwrKPbKUwmrprzP186CKksAr27bFibmo2zKnatc858dGlJPCIFybsthcjXdGMKcBzPhf2tsAo5twFUQqxNQ44sC6m+zyEpH1lqtYwnZobittQMo0nSMLz5e8NfBcgEbAeQH8YVeHo0IKppcxqBgTn3OwDvrTuKS0LPeBFtda9l+Ow4L/mhImBY3++8JKMQtkCEOzeiQ8U/xo+lUc7m1ndCNnfReDj1WxtQi0qN4ldCBQ7KXHUGU4mMpj+kqWfIvOLDV4UyFR1p+yg5wsutcgPuJPGYGxiGiFwPqQFY2T7I47ay8a1ZeG9YbMEQKD7N+8vcs2kks10YblO9JEySbMa8mVL+Y4Us1RG20pMxV+mpqlT093wYSfyflg+78JAJcwZK5L3K2RvFgdG0p/3owOa7t7ycOXN2bge8bGYZbEfF50HdIkFVncAg3oNPgy7lJUUaqEjd2uCSwes4ypTQ4reFidwK1jeB8+ZqLZP1GMW1C/Y69k0bgrkYOPlUlQO3xIS7xRwYGRkLeLNnmFOs23t7
 mt1hyJpP
 VmB12s0lDD+poevwXW7cEUHeITv23lFTgWhRgd5FVAv8rcNoiILb/OweNhvzEN2+XLH6L9j/NTFwTE9usmPT+bW5LYz2cV+4+7xsiMa6ipHvRB7AX/MoFHEVbuW35kCocD6x7NokwCKOOnFHnn9iCCKVeAd0QuOaKIGwqJlFLB6C5SrAEVtOzBZmrxVbRPIPLmDVLqBLvLokIvneXoeSTDDNP/HJCS+A6PYCKB0I1g8GHtYnYnpXy1xMwrFiFsxDTHth8wNcJ+rsvSb94Q+rCvIXw0D2f3aPCkpr8O1zJzqR+a+jMcsoMWC6sSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly added LRU-activeness DAMON
filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 8440c4954090e..b676be6971589 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -302,6 +302,7 @@ filter types.  Currently below filter types are supported.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
+- ``active``: Same to that for DAMOS filters.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

