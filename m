Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94548CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3AAA8E0093; Fri, 22 Aug 2025 05:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB0F8E008C; Fri, 22 Aug 2025 05:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB44E8E0093; Fri, 22 Aug 2025 05:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6D068E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E4641A01FF
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:15 +0000 (UTC)
X-FDA: 83803942950.19.ABB93DF
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id 45E281A0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMQwBnBBP5+VROS/fzRmjMjvBPSMHFQ5vje/ziRMtMo=;
	b=MzZ/LvCR9oS6wLuT8Xn6Up+hs5EObCA4GUz9kiRlfgKANnvJMFXJFv8jlF0QDqoah6R9IB
	S4PkFC3CRNsjxRfxD1j2MuPuLbPoh+U7CRWyZUzUorPmWf2ifY7eA+9d18f8SnJRMmX7UO
	u9NRl1aW+GL4CF+ITRJiGhpC7iAVh0M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856693; a=rsa-sha256;
	cv=none;
	b=7PDpYZmj9btq5GJs6Ow1vxjcc+vQBve7TbCfM8COawoFWfGioSzLpWO2vXztnUV+OWsqX3
	TJBrvySjHv0LlJq+OaOfRGAemKKKMvv2ff/OUXCwRY+QN58x4ciwaz5L+s80iDrwQHlsc8
	88PwAAyaggfPnp5zL5UNSXIwi2RUcI0=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGl4ldxz9sSH;
	Fri, 22 Aug 2025 11:58:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4MzYiAzePFXF; Fri, 22 Aug 2025 11:58:07 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGl3zRbz9sSC;
	Fri, 22 Aug 2025 11:58:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 6EE2F8B775;
	Fri, 22 Aug 2025 11:58:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id Mz748sD3BeoZ; Fri, 22 Aug 2025 11:58:07 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 78E258B780;
	Fri, 22 Aug 2025 11:58:06 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Andre Almeida" <andrealmeid@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 01/10] iter: Avoid barrier_nospec() in copy_from_user_iter()
Date: Fri, 22 Aug 2025 11:57:57 +0200
Message-ID: <9aa2e04f1c80d45151e2c3d06a45b6a4f29ff576.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856678; l=1324; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=btOGI5kT/X4BbGkbG9xKSloQXaxXSRXRdA+8gWVdMNQ=; b=U0aP36j9qq2Z+EzK6fHDU51410l7VDxWduQrkADDOwWueGyv0Sg4bw5dV64YBIg/yRboGmHiq A0ibcHLG9K8DbJhbI+wPLCKPMFbswE9LEUkmxBSkb4CSYHqbanY0rSP
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 45E281A0004
X-Stat-Signature: 5t6e8qq4mgui4iwgacpzdeui3b4cnhu5
X-Rspam-User: 
X-HE-Tag: 1755856693-93048
X-HE-Meta: U2FsdGVkX1/zrVl6WGMQTDpSYDFOrTPG4eIMhgfgKjOL+ZJA3OGyxZdf0d5TBvbcbWLNwArdbGSLULsufI7AwSHLdWrk57mo5vnhZxLE7GqE0kFIUD3zn57SpVc2uE+9UHuat2lU4IjEUuHkcQUNkxS8ALYLyp78dRNBIhlgxx1Gd9AW3Os/HV+GZyQcfkgk0RFT2qYdXOXl3WR44I8z39HJlwDhtnc+3A636y7x+KAWLl/jyHOngPOM56XxqXPl/EEQlTyGPiO38OlY4dG6VkAYcjywP4uqPzKQeSZw9LYyW8bqgQV0/3F5urWOL8NaOJx+xS4PFIJbEFiHIc1TIH5Srl28aREySajGYpabG5taCbf9HljhXE33M7ZB5H4HVPEFG9suLYrrZbNsc0VS+2wk6YJQ+Rzxls1Q1Xoh2NAhSgBW3l8hl8iI1lxLQGZla19AdOXLDLND//x4jYUdZltqJE+uTH1J9Foqg1HMvoqGU9IAxkAV1b5qoBiQrUQ3lu8BohN9NBbgI76E/OZQkhut3kdPtCsiLmXYSv/qonLklRALPWnlsQnStls1CTYByQt8Jb3KkGRPXbP6NQbSc/TZhkO9+tOPa4MBg86hCBpGMgR+IVNHFpEHTnOJtA+5NwK7VVgsoC06iIJxvc9CTPJIZlvruskakpsxQp7JWtsS2uABP5+q3oSuE5zW8/oZyM+XDeUx4V0uLQHGGjFxYMM+Utl/D0p12OgYxMrIUnGPp6WBKgL7vlBz6L2RciyT+cRRKpbnZtBTCkuY9wYqwCHzyUKHoyVsD1RVbeKoBwxzyhicKVEsQ8t7sbeV8Y3Bv5KEbaZpTvDy3NCbQqNR4+mH2u0Gq3jLrcCkqJ80HVDjKXAeDoGh/gBEOJRQDE2H+GKkxiQxkr4YB//IWcKtBogyZ7/PFActN6j+oI+qL993+XZXfV97p9lrlmbkK1sWfMeuCaRdzYnhcxQhOJA
 SFQKi8xn
 1HUuWuygRJunKhPln7ZOgbr75SvzNZVqrHeUat/IykZ2/AypVPOgQZTIIwz+LWDd8YkAkmR+eMTQcCDGeirN7/G7ds7it+8DrGfSVGkTzJeXkbTdJ8/dJceWikYSHZ3XZISArGZ4ZPYy2jSN/Otm4v8ag39177Cu83afce7yYaz4z6MoAy5z72OZ/UbJVRl6D3DRVcOlVXkJ7B4xh4FNSc/j6Dv2XJUnfiW1MaPEuPjS1G7NXdAAM4rNFJ06DsgHf0Bqgevd7ab6NLi9Y2pIaq+S/g+cuZ4QahZ3r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Following patch will add missing barrier_nospec() to
copy_from_user_iter().

Avoid it for architectures supporting masked user
accesses, the same way as done for copy_from_user() by
commit 0fc810ae3ae1 ("x86/uaccess: Avoid barrier_nospec()
in 64-bit copy_from_user()")

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: New in v2
---
 lib/iov_iter.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index f9193f952f49..48bd0cbce8c2 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -49,12 +49,16 @@ size_t copy_from_user_iter(void __user *iter_from, size_t progress,
 
 	if (should_fail_usercopy())
 		return len;
-	if (access_ok(iter_from, len)) {
-		to += progress;
-		instrument_copy_from_user_before(to, iter_from, len);
-		res = raw_copy_from_user(to, iter_from, len);
-		instrument_copy_from_user_after(to, iter_from, len, res);
-	}
+	if (can_do_masked_user_access())
+		iter_from = mask_user_address(iter_from);
+	else if (!access_ok(iter_from, len))
+		return res;
+
+	to += progress;
+	instrument_copy_from_user_before(to, iter_from, len);
+	res = raw_copy_from_user(to, iter_from, len);
+	instrument_copy_from_user_after(to, iter_from, len, res);
+
 	return res;
 }
 
-- 
2.49.0


