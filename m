Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E411C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536E76B00A6; Sun,  5 Jul 2026 11:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8916B00A9; Sun,  5 Jul 2026 11:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424FB6B00AA; Sun,  5 Jul 2026 11:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 172326B00A6
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:56:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AE67120145
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:09 +0000 (UTC)
X-FDA: 84955174458.06.55A2FCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D4EB0180009
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W1vysxsp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783266967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BUtL0wdhRHBCOaPZNQsX8fjUI9m5nC+jbrg8ueFSt4=;
	b=d7hGwUaL4LnDL7y9RZSxHaI70ZvMY0jPIpFhEQox2PL5q3Z1SnTPM7QX0if7c/RPQ81XgB
	dkkiDZaoL9a+tn5hysl3vcWNkfUoS+a0NdIATx5rbiblHV4zy+F+YWQcaP+zNsw8CsagZX
	IrgaTpEMKVZqSJHbP7u1//0DaOr2Gig=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W1vysxsp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783266967;
	b=fS8LvYFtRyw2Ym9Kbhz77P5gs1+MkZbAsSYVa0dk+/fCf8zzolT89wpfAQJ6W2qkTk33Hs
	IjK3Ddka8ySMzCsqgQPDBwecTyqQqtMxqeMciIWAREP4Vwwtk2nn/oqsTrbfMcyPx2Ogfb
	SmcJtWxo5uztfCzmFLdHCXid4Noc03o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FB4543C05;
	Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E165B1F00A3E;
	Sun,  5 Jul 2026 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783266967;
	bh=3BUtL0wdhRHBCOaPZNQsX8fjUI9m5nC+jbrg8ueFSt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1vysxspoNVNerQHqeYs1WOShiAUesk47rJlS2XseKeilVAiJAfy/laIfMN7rN2Xr
	 SGWcCNHcK3D0hxQ+jTltWeV9xbUVaHTm4OYscVuop0sUDX+OLRPcl7AkiDQmfke8YP
	 q5jfil2myF0r87r8pRMIdPTj1DKnqyXxwXbcAIItqutcvgo5GgNH/nXNfAHhL2duzE
	 8BRLAPaUF1Mh/zTYvUe0mSsxrq9fgXCjc+W1grxkZkLh8VQXEwP0W9ewuA5EReBwKT
	 vsznSthaXo+he98sczBi1JLFdlmYMouTsETGm8HtnIUz5kc/+i1jWINyNT9+Ih2cA5
	 mS9dEVMXjRtPA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] mm/damon/core: remove start, end check in damon_set_region_system_rams()
Date: Sun,  5 Jul 2026 08:55:58 -0700
Message-ID: <20260705155600.96555-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: <20260705155600.96555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D4EB0180009
X-Stat-Signature: 84tubku9kdfsdhdoxhkw9onx7dtia5uz
X-Rspam-User: 
X-HE-Tag: 1783266967-136083
X-HE-Meta: U2FsdGVkX18TA56GSdcR/dqvXmT8q64eBn5ojQ+kLqQ0A+HVtXUVxdNXPGLyindZMVZzSrlohiYDuBWgMK5wbVRXeoABYUJDeXLSxHwpI+TbO/XHNIFOgvcBVFiynV6pjtPMXuVXNbK0Vr/CcUc6tuEbbPUC1+dkDVO1/f2nZjLZFUda3Vj6Jc9ms8P9Oc8xbANTcggoAMX2oRZm7t+cmxZ7SQLhMknnd+j1ePdfX5IvRSOo0f96xBuNHeKJwZZaS0js8rkAsFVv5a4+fA5pPRg6Z5G2ZaUI9ePV4QEviPLDXABfYL5oeesEy+IkUA8Yz5Rlr6Fv1jWgXk36NlMUeGS8F0gzxYN8KLYl/0eRjaHkAFe5oA6qkSq7g7YDxdro2x2SDco/e7P7QLPxrfhwxLEWz3+lGpKhwIZnWLCwETzIq0y+OqxuZmXswU8HkDMqGDaz4inYnXEafQ9GqfaNVzAs0mgPHiMgdJ0JQtkt7eU0o3OujdnKjYrgV0QKPQipX3FoNuEuINVsjgtWvCeQ3Ip6BbedHSv5qcg1aGpIY2+LcV7+1a/tiIlhC6NzpPoy0F8pwsHzpi4VMys5vl9qvDyDemfZP3G+30CNPWOVlr0M7KB01waS2dwt45pB27//Kx+uhje4c7F6mmQtIjPfOYr1FcCOmQzEMnEo0EkyIRRfbReGKaR17GRCQ2hp3IWdTzTkhT4dSvselRc6wjvqlsroOKydGPbz+eTr2zvP89fjRorTpSe+Si1FPgBzGBo4Ak6U+Ig765+8cSXnyKZA+3aou6+wkHOgpgZNmCzWM/a8BTDIQgDLVc4pBPqqrgnwyRG7oLnx5LxxJYD6mNTyKskYj4BhNkYVmjOMidiNWlhVOY7wrwLiBvEX2u4NrfDpjZh39qXe5PUhBXlsBe5anWquG7arirufK4x2q8pxu41eTMx2VHXtoh0KgbLKNjkQZPm4GJtJmiTzr2AkM6t
 Hp0m8VYA
 4QAoVSxbjYyjCHtsQgcySdBi9l5qY65dZbRoo8pejsU65F31IKbqOJf09Qdjgw1dKtVmmj8pd6N4Lvv5CrlyEk++vftfQQr3CvEn03LvLE8e19a6mQvUFlYEnpPCu5kqofzOGGJwlKAIo08oP2QnwIrR7m9WsRG/0lzNh0qZiIDSP+NhFBUBEohN9gml/3C1O7OHwD2ah+//6WWoL+mIYbi4EBpZC1pmQRr8ZwGSLolnLT/kNyeXz74LG2Y/EvYhjnl9iGMohV7E+ls9+dQ1YYvfJVyyPH8lMsDfBY7tUhbxPN7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_region_system_rams() validates user inputs to avoid creating a
negative size region.  But DAMON core avoids zero size, too.  The check
is incomplete.  The complete check is done inside damon_set_regions(),
which is eventually called from damon_set_region_system_rams_default().
Drop the incomplete and unnecessary check.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ca301abcb9ec5..3c5a46e1c079a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3846,9 +3846,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
 {
 	struct damon_addr_range addr_range;
 
-	if (*start > *end)
-		return -EINVAL;
-
 	if (!*start && !*end &&
 		!damon_find_system_rams_range(start, end, addr_unit))
 		return -EINVAL;
-- 
2.47.3

