Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6552C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760876B0005; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA306B0088; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D98C6B008A; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CC3D6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AB10167D85
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:55 +0000 (UTC)
X-FDA: 84930676950.21.64EC49F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0E15640002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odQNqTH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782683694;
	b=0w9VTA4XgSVoXPphtw/yj/N6909dm9FsTEbiazoz5C2JgMkPxhyW/Owg/eLKhlgIU5geVi
	+jVQZYQUvHa04rZIJbZ30RWBYfIeM5yIfLm6oDmgxYnk3cAZGYxeVgb3VOIBTFuu2xINdl
	zezUJKH3Z//qoTXBIGcNtWqmzSwyJY0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782683694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wb/G2WI6U+bmHwkuU5P84fH/ZMN31r6Got3AOveygXo=;
	b=o4F26nEKfhn2hYOigpAuNYeirISWywq/hJ8/UNlMGuI9v9q0KOtgN9b3XjGUAoLD8RkiNn
	Fk7r9GMYJFVkY5He/7jgVVpjt9sGS31XPTydIZOtQQ99vwNh2D3pMNMu/uGbC9fKZYWYEh
	Tgi6E7OesN/iH+oafkym3Tuyi8OLa4I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odQNqTH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CCFE43707;
	Sun, 28 Jun 2026 21:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E499F1F000E9;
	Sun, 28 Jun 2026 21:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782683693;
	bh=wb/G2WI6U+bmHwkuU5P84fH/ZMN31r6Got3AOveygXo=;
	h=From:To:Cc:Subject:Date;
	b=odQNqTH2ZMrhe7ZozN5h/oAQeRqYWv82de3+V/fqJgmGDBk4t48gPKmL9/QgDbl3O
	 hFyMymvuoOnpaWxR5Qg5jdHIU8rv7ZTf2fJUom07/pKHToC8vka2u23rxOUJUQ5TRg
	 F0X0RE3Wl1TOgopWvBD075KKymx+dKmtqlbGxm3PrPDERUwc5ojjy8piMxg1fkRzK/
	 HSkLXPUm/qb8YSM5yN5WDE1RCcvuAhjNB/1Pk6K1DJ99Xcs4fcEwSqb6TXH7LUKKUm
	 LnGig2acjXxO5jfQ4/0ej89esSErXW2DdRqMWI/gWdnfLnGTPg5V9UVeE/7ytF6ueK
	 JUxZyyoShCbFw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/6] samples/damon: handle damon_{start,stop}() failures
Date: Sun, 28 Jun 2026 14:54:39 -0700
Message-ID: <20260628215447.96166-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E15640002
X-Stat-Signature: uppcgxu39qumaphjkqj5qhc3sgf9813z
X-HE-Tag: 1782683693-658269
X-HE-Meta: U2FsdGVkX19P3IXRXruq3fM8eBZQNz9Y1/wCamZBPCq7zsonEe6hvSlS19csBORVKadKVIwJS6G+rB/XQ60krXlFjyTwwqgK/o7vpMWAzDnB41Ur9UOvf3a9BnloJTwxLedITRbgi+nxezLWnYZt75ZzGn81qUMBl1qBdoXc2PZyti8VTO9To0IP+mwRON4ZdmQNpgC06hi1AAiDnNSkF6yo/L7pwY93rx/J3z/Oqxds7k+KObl4b8V4k2pqUZ90VUSbG5c6MYsoV/baIJiTw3/3RbPonTdXJ7ZUKkLkrewfzrbY06CxWbti8Hj6K/9iTVwLInGFQS8/TVnIeRgtT81LDtWEOQlumrWmO1Vmzm5Z4CkjLCRz8lEe7KKIlqQqHANg2lzVByPkEvahQgTr90oA9SLfHgvlPrWzrvNxteAq8tFjo6UskHs/D+I5x7JfiNk1xmsDUbR8Fbe9pcvWz+qmPIooPZzMRMH9z18h7iYGBH1Sxis5cfousNSMEckWj3nC3j+5ED+uzIFNw61KMpqghaS9BC2ZCcVcone+7qVy++mZREDcovzEQVsbNH0K0v3DjDVnj21banRbVzf3yME+p1si0TQ7u1vwQCWvZeMcrKCFQg/aRlg84SOj47EAZaMBH1pvQpPDdINDAko6MBh8xJ7EhOmMdMxvmFXdwiJJRyqRKLwqseSMg759rHGC3YOcAZr1xZE0eXzGdVanFu+U7wrg7E/HT9gWLONAwfe5ukWWdJtzrzxm2S/DUlcyigOD5F6YyQGeCh0zSGjFD+NHeGtz10ZAjZ/HxqYwkyUAUxmsxkNHnVtXT33zTo4XjiRy0LBcPfD1EFjYNVd2sL5+Y69VqxQkqOhvze4dzdegxkMpaxc0zvko743d81MVbOYEnD1rSZeW9NiP5IJjtqorZK7Tk8PSNDHNEe+B4+g0heMSWv9eFR+t/zdZMt9BfdB5q9v6gSSvWO0A/9A
 y4aOif7E
 KVUe7LLcALAu3fgedpKI2NmsHVTX3K7D+oR9Z9Hw2gkrPEnwzOeCzJXb5nSVh9p9X+Cy8GvXIzLekSbOiFda5MEozooy7zHrQTWm02Z39bjRco7LdmjcyUvaAgFPPRMHCXfuampzl4I01EGcMHkTJOUKnW57Krs99MGW5R2+aQ/Nu63XbEqkIVpj4pnVq/P+3deYxIH0bqg7leGR/o8LiHMvpTWqCxrtV6uUuztEi13c89gHeFLdijxn20UrXPHcxrL8NCFtKqWh7PbZNuqtMyzHcyw==
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

Changes from RFC v4
- RFC v4: https://lore.kernel.org/20260610135546.64943-1-sj@kernel.org/
- Collect R-b: from Zenghui Yu.
- Rebase to latest mm-new.
- Drop RFC.
Changes from RFC v3
- RFC v3: https://lore.kernel.org/20260610011420.3018-1-sj@kernel.org
- Add damon_Call() failure handling fixes for wsse and prcl.
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260609142119.68120-1-sj@kernel.org
- Add damon_start() failure handling fixes for wsse and prcl.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260609005443.2122-1-sj@kernel.org
- Add damon_stop() failure handling fix to the series.

SJ Park (6):
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


base-commit: 77fe35dfe005f7d55c8e729e1543b87cfc805a21
-- 
2.47.3

