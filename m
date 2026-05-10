Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8717CD37B6
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CC36B0099; Sun, 10 May 2026 09:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D2A6B009B; Sun, 10 May 2026 09:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8136B009D; Sun, 10 May 2026 09:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D89326B0099
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:56:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77FD41C0CAA
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:15 +0000 (UTC)
X-FDA: 84751659510.28.88EF128
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DDD304000A
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KD0dsLZQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2liTgSvO1E8qVe1JSBsn2i8QFZBLTHOLL/6YgQ+uvUI=;
	b=06r8PgHmvJgXmyw+VWSYcs7OoRKYTq9+HCGl4PlAC6kvsH7aNbEBOxaClao0jKycVQZC8W
	mehIlQnWhqLwzfIkvbZRyVkrEM2cE9OvEg5EHd58ofqEPFm/a1fWiKIbk7+qmnbuvXdJta
	ZAm+KeFRnmRBgsNq3zG+pI3I6m8ZPSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421374; a=rsa-sha256;
	cv=none;
	b=aOeJwY2t6CNaJbUHDFQIab0zrjm93VGOPoHQYROhYs8yNMkRJftoVbwrBl20hqjNr9hy+6
	oLljmToJEYtXwl1Ht5HzcFabEbGKhqH0E3eI5befWfabWk/iOHC1rMNBUHSvKmBWCX185Q
	FVIi8DGB92+hnh9t1GluhRGc0N+E3To=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KD0dsLZQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 100034445D;
	Sun, 10 May 2026 13:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C20DC2BCC9;
	Sun, 10 May 2026 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421372;
	bh=tkwfagRVJukzEnsyKj09sXQJAa9mnqv0b5T/g9FZs3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KD0dsLZQY4aolmkr1gau+yr6NpTDiaJQ4wLWAigE+m0YYMN8BL86IHL7HAz9P3MAq
	 zTKtMaLddQ0wGCkvdp4K36xZLTLHNgd1OnYz5mEeakDh6geUhW/6h9JwnR01/2uWtk
	 w9e869Jc7W+ew7iLIiXkHfqfJmwZczH7IQUnoINX0pzfosswBCWg6PtMhY4GKSkeRL
	 QXbd67mSE5PIuP8u2Kcq+PryQmE+t72JP6eaL8PUO63xYQJKbXvNL60rNIuB4IFe7l
	 66BMMFIQCLb/eydQhhPfZUNT3ylau2HS6ctxUMwYvRjOCzrd/lThU/8zLgOQEzXIkT
	 hlrk2CL1XoWuA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 07/10] init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
Date: Sun, 10 May 2026 16:55:43 +0300
Message-ID: <20260510135546.13554-8-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DDD304000A
X-Stat-Signature: qfhybm5frp3kq4kec8npchh3i8moai4i
X-Rspam-User: 
X-HE-Tag: 1778421373-41408
X-HE-Meta: U2FsdGVkX1/Mm/LRWOd7AZWt9Wda9oxYFmyjVvUtupL4kbAlXMPdMuN+Da+saTCnzXeMlGLPsQJbAQ8utgVitbDXzpAx5gdkqmuKOfiDw0JUcRS53x6MOrrWrp+qUTmduIX56lcPnNL3kyS6x/CLLXZC+eSbLQq4V0/rb8zIB9jVCVMKT/S+uabqZTx5WfGQgRkwVnOH9O08TfzC7mcm0NKEunKATrUDm8kSey935nCz3k50VieRf/+caB9YyCzOPPpOl9+UfJq4DYMKI/+F5lhASFG517l986mNn19177pv6kpSoMIkXYuECvdpTNRmh6eLTZW2Eyjq/NgehBQ4rWqoyjtQnGbWE/NxnmstEJIs3VVq2ntcV5m5MlgJtma12dN/hd7QPMVYaJHceMTfACU24L4jt6yhdZTwSpxsqONvPHhYW1hGauHi7Ml8xqz20q7+Vl6NQIMivQ/1UW+nXE1mPz64IN8I/9Fcp0ydIlJHTzNasndS/BmcAHmFS7j+iJXaAfs0RdJpgHIgPLbkiLi1YW2Z/ILozdyjuyJAslbXknryg6KVKQyZIH7A6N9K1wHA0PX9DyEvamoFC8z5buwQkrecT4QLMlL7IfsSqp6fTUGllPk7C8x3JxZ90bZTezyRiScR661eYQTNDM0ADxlu00H7TC9OXnY3swi1ppjfED/wjDseh8Bvud2LQySwI4BdyoO1Qb3h41449OO7s8J2V886qeg3cCh1AynlD2qGQCSzq/t+KPQ62DXiPw3jfZl0EUC1/x5r99mzyJ6g6dIVGQqH7V2YnJG1eJuh1g1DSsNisrVQ82JGO/dB4fPFgxzkKNpyItLkPQchP+APNt34qarnx//dxYrXtTaG/iPFQIUKrY6PG+DOCsi7TafsM7iAVffX9GuGnde1Ysib/vE67t7xOp1NzFGdEHbkWU7/Y0h7ANo+ohlW8W3+8/xU3STnIPOGcKIkaha/Fvn
 7NeJycS5
 2f/oIUEDcWOjXfVTiYMn+WeM2O8X99wUUDDo9yssM7+AkyilY88MZ12IoaXdipIruokUh/LCjMf6TEucLO1T2bBv55qUXeT6lxs+nTUQ0LdvUPBWhpcnK1tz2+eNWEHWy5esCbW1ZGCH+/uKSgckiw052N+jkFeHpEPK7JQIFYiECJT+445RQ+1t+x+FTWvrnsLo6YXAyX8EK2gHPrZJ00O4BiZG9GgFNIe7seBez5zCu6sFgAwK0+0KBxUYJDuo5iKp8fs+dAODkG0sy39wkr9jvPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

sh was the only architecture that selected ARCH_WANT_NUMA_VARIABLE_LOCALITY.

With NUMA support on sh gone, there is no need in this configuration
option.

Remove it.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 init/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 2937c4d308ae..33337fde1197 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1001,16 +1001,9 @@ config CC_STRINGOP_OVERFLOW
 config ARCH_SUPPORTS_INT128
 	bool
 
-# For architectures that (ab)use NUMA to represent different memory regions
-# all cpu-local but of different latencies, such as SuperH.
-#
-config ARCH_WANT_NUMA_VARIABLE_LOCALITY
-	bool
-
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
-	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
 	  This option adds support for automatic NUMA aware memory/task placement.
-- 
2.53.0


