Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58EBBCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF8B6B0088; Wed, 10 Jun 2026 09:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0346B008A; Wed, 10 Jun 2026 09:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD416B008C; Wed, 10 Jun 2026 09:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D00E6B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:55:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4474812010E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:58 +0000 (UTC)
X-FDA: 84864151596.21.1F93D78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BAD60C0004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LxjGmrz8;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QkcNeccX3GDaT1+8qzrbll8lI3ayPx76hs8xzuucw+M=;
	b=gzeRsIJYr6tblS3i/8GUTWdm1mroSjQ0NFAmdgokr9KBrUw8UjdXCBD4QtcFnyB8hTLMPJ
	XFRVl7pCweNWA452D1GeeLmKh29lifjMxy0M8i7wtP8AtaeVNCWXcPHPuo6LUllCul2c/5
	P49Z6QP6FO2vBL3+h81qPp8UCu9pCIo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LxjGmrz8;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099756;
	b=ydzp1qho9BpXZfK/RODzeUiaVhaahJ5eAwF5F4Zy5uWza+aO4w1gM/stT9HmzJLT3f9lDU
	CwWqBW8v8IhJegElBj0jiaH1AZjumO190dekkGjt+e4SCkSWmMMnILfTzdSYqfFOd+REks
	/7k8CfGdxyELCVqQ0HydgtYX2ekoefU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA492429E2;
	Wed, 10 Jun 2026 13:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1301F00893;
	Wed, 10 Jun 2026 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781099755;
	bh=QkcNeccX3GDaT1+8qzrbll8lI3ayPx76hs8xzuucw+M=;
	h=From:To:Cc:Subject:Date;
	b=LxjGmrz8aAeDCcGDnVRRCm29TcsCIjFSmrJYduHfx3OH1L2cQyP2BXv3bhOhl0y2F
	 r3yYaqPPVJa5sKHH9VGFM3lTYWCqa9w/akkQucPYxiJldSXC2NWImOpHA+dCadRxeW
	 Y5gvNRS0RUrX/j8TBrtUuCb8MNaNhIn5on/aVuDIBS6I9IXW2oX+NNffxJrg33qGHa
	 fkJ6svkJyujN1T1azb8EoXUMdLxoUW5GhuXtVZTPOCqLrmE96e8HMqy1ADMSCXoD+2
	 0jCGw1YIZNnJtP4Oe6IjEnohZhBaz+aS/RJRL94M5TxNX6ySMTowyuUvnJy3LzkaZt
	 jFRHr2Q3DPOBw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 0/6] samples/damon: handle damon_{start,stop}() failures
Date: Wed, 10 Jun 2026 06:55:38 -0700
Message-ID: <20260610135546.64943-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BAD60C0004
X-Stat-Signature: ua1nx49ztizs3s9sya9kik36tuamfqis
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781099756-797494
X-HE-Meta: U2FsdGVkX1+zABzoqnt4b50P+GkJ2uHN7Gzwj8pp3zVpdehVYE54d7+hhYasGjvaZL+pQ6KPwtJP+40Q0DDLuV12vF4AvGy3sudPRqN+qCDiW/gqIdnLdeDnpa3rJ5j9i0pu+yLU5Wa2kAT+N188UmR7LV6KBZjbX4gaXnzSw7qCe8Kvy0zuuInyf73dPOeYWul+sGivXyhQi+zA8va1TmJGtJzR9bZzI/zIRJgPArmoLrB30Aso7ACeQbsURSnpJP/ZtexV/pfONaoV3xm/bhc+frAkRPJFILzJt8WFDzX8/fwy8JZC3zUwBVqs2yLRAca169Al1Z2XlEm8Pq3Gtym+KSz+mZHtOKAzlNoQMuZaRmzbUOHAXJOuK5tT7egIeBXFTQUgowBvcliYZ89vPH703HzQwKT/gOmo1r5fiW7FqbO4hK7+8+SEHH7uEzWCJN6pGVfYZkuNLBdaiwbvPX1e4KfCnB2SCD7qP3vq/Qu78vWVxqDt9yU5A6HN8LdorzYnPAWKjwpwOnbFsn1zZ4XdKHCxc+4bgi7nx7w1dJsYIapyWVlYCkBwu9jphJr38X0R267wXeIri00dR9fs8cARbXGkgeFz/0T6aCZ4lhlbLgmI3Xad4gVlnx2Ts5fgCnntYclQN3kqpSQchT8kzP4go358sdLjSi6Gun3JBZaSVceBPJ9qWa8hvrou5PYMtExS6jC+2l7MOQ5BpLTt/ZlM1cm3GX4hLhrtud2xiEWKUCeQdsrOKUexo9hO4hPdzESysC/flXTiDKtY8+wNLB6STWGW7m9nxE2RuoK+TQ5fLQCMN3bJwSNqJx8ZSm9bLEbFy7dW+nOAdK8tVNCp35W0THsfUATIzZPTFQkt+pJz+p1wxwY5o+z8HsuZm0g7RPzH2AmUmnLxA900VOro5qCzhAg/BsVAEhdiNg5BKFR54zXbuiF/NeEEAwbBqDA6f1kzMO4noChWRQYkhBh
 1urYsNEJ
 0Qdq76immPDdXwaahxs9p5K1jYyzFkgVLszabv7kP1LcTaOsGTphMkQU+KRthjGWh6AsFF7XKr+DqCwqQ6RAce1pkLwv9+C6d3D0ECEeQHs3q1XwQrjcLv15UpZc0GhnjZL4lyCdrshJt9TMX9r4YLLucNwJnAFQNnACqJkamCIchsma++9vGQlMax173jb9esD0VJvUuSurZv7DT5FpVWVv12FP/qzl1vTXpUKl3DlrKVfP47KPRI784anZiwetvNqdvxYJORlxQdTaqs5c9ZnA3fA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All DAMON sample modules are not correctly handling failures from
damon_start().  Among those, mtier also has an additional problem for
handling of damon_stop() failures.  wsse and prcl also have a problem in
their damon_call() failure handling.  As a result, memory leaks, next
DAMON operation disruptions, and use-after-free can happen.  Fix those.

Note that only the damon_start() failure caused issues can reliably be
reproduced.  Reproducing those issues require the admin permission,
though.

Changes from RFC v3
- RFC v3: https://lore.kernel.org/20260610011420.3018-1-sj@kernel.org
- Add damon_Call() failure handling fixes for wsse and prcl.
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260609142119.68120-1-sj@kernel.org
- Add damon_start() failure handling fixes for wsse and prcl.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260609005443.2122-1-sj@kernel.org
- Add damon_stop() failure handling fix to the series.

SeongJae Park (6):
  samples/damon/wsse: handle damon_start() failure
  samples/damon/prcl: handle damon_start() failure
  samples/damon/mtier: handle damon_start() failure
  samples/damon/mtier: handle damon_stop() failure
  samples/damon/wsse: stop and free damon ctx when damon_call() fails
  samples/damon/prcl: stop and free damon ctx when damon_call() fails

 samples/damon/mtier.c | 14 ++++++++++++--
 samples/damon/prcl.c  | 11 +++++++++--
 samples/damon/wsse.c  | 11 +++++++++--
 3 files changed, 30 insertions(+), 6 deletions(-)


base-commit: 1fe919b2e7b6455d0b976d75dcbe44324361a83b
-- 
2.47.3

