Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C860C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EC76B00A7; Mon, 27 Jul 2026 11:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426FF6B00D5; Mon, 27 Jul 2026 11:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317026B00A7; Mon, 27 Jul 2026 11:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0726A6B00D2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:02:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 728FA160731
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:02:53 +0000 (UTC)
X-FDA: 85034873826.18.F7DC683
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4062A0003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:02:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gmTYl/c+";
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785164571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aFYOBMXp5dKkeO47Qf8glP6qHC1ahmcBq2ODbRBzDG0=;
	b=6LvTdcJxdKB3au72CuB70HT+56XsZ7homcTuG2BLmAxmqOfaCVW4DXWaCsFkptSa3wiTOI
	A3KL3QTYmYsFrHjyvC/ZTriXMurO9Lu1jxmSowlyA0YcQ2icoPmJLB+nBbC3R8b5A9z0zF
	CJF2Nv6GGfTNXBgUJAh4HMtLdAbmNsw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785164571;
	b=h8w6cbFzeqlBuk3tHvPXZ8wWWhufzyvr1s0NZpicERUsBw/HVrAhMFinBBVsL/rw//fYce
	wMCP8zEiQzfu2i9fV+4sj6PExuexNunfP9TNPQ/092gMUGtQv2zMZ3lQef4vZmKx946bW2
	elieye+QIRosPl69p92cgHfFfWCHmTE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gmTYl/c+";
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F7C1600AA;
	Mon, 27 Jul 2026 15:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E271F000E9;
	Mon, 27 Jul 2026 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164571;
	bh=aFYOBMXp5dKkeO47Qf8glP6qHC1ahmcBq2ODbRBzDG0=;
	h=From:To:Cc:Subject:Date;
	b=gmTYl/c+0ipQFd8NpHTkjpGs4Q/3jQRywWu+9wuxAhCoeM3efP0QblqxX3Af9lGHc
	 Nz2Z0plLNymVkhgTMkuRmp4F2lcLA57ghdR9RPQTw/rI3fEcNsoA3j4Io3hADdCZGL
	 mmUj2tD9ObqEv1R2brKr49durZgrC8VeKVi5e8kyRCt8TQ5Gjnv7Ug48Vn8CgZfewn
	 mxXmgO0bwMZ1SBTljY0/b7avVfA7xXqkM87bkOwsT3NoJ5ZsIdhUmDveKwowaC8VX+
	 NwpmMI6LpHZ+hk2RZgvGv+E4jiZltvM4rqpX1blqfHXzIrkJS4mWWn0H9FXPDSTwvn
	 uInTh38P1hm6Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] kho: fix size calculation in kho_preserved_memory_reserve()
Date: Mon, 27 Jul 2026 17:02:39 +0200
Message-ID: <20260727150240.889555-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4062A0003
X-Stat-Signature: 411hyk5ahaibtjmtikfe1iitmqwukms1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785164571-438774
X-HE-Meta: U2FsdGVkX1+ENNpATJXKT+4DONv9K+t69kc0XbPxCkeeMIKopcWbx390k3w1aMUHWzKZbIrZwUWn/a87qNYwekPOo41Dq3e7Y/gsk4vwBNkF56Z5ceI+UGTUoPLZeAOvI0psH+3jG9wpAxd+6zxXkh2TTokwA740q6R0rpVWLuqjzPlN8N2UatvYgiSHJ6uvw0HRoefezkr/Mxhj8Bsbce5pQ8xeZ6uYtv9mOaBtrAtqae/WI9+QNhUl9joa/r1UwAreaLUvXWqxBcR1kwN25uzRGNsiXBZPBtXJTuDUp+1kxOmmN8ZaceAomMzBqEMW4Elgvr88rCiJW4LsBfJAskDRUPztRzF5oPPczrFo0GfKbtw2C7NMzMBkAZBICVX3TqE4Y5LvnSOTcQlMgTd54So675F21bkW5tqBosJeYy36pHAd6qYLBVoefS0v+txVyE/MlnPFz//neGxFLFQQVII3ZnbLLsBKzQeoF3nm1VCsNmCi3ov64OXEiwvf/dPIhXy32lLy9kuSW6ItIZ4v3M3/dVU9NsYeAZ/fTCCeNr9uHaUilhKKYpKMcd8A8J4cMfifrvgi7d+oQzAupwBuHfd/sYKhEWcuFqua8dCp3OcM6V9jMRXLuJy/vi/DIpR3gg8g7AU25clhVlNqd34QR2ipBWZBl2kX1uxgGlx55pEbraN/T0QtwD7X4TIMV3zEU2FtHZ1Mha6MEp0zo90NdK2QgFJWjdcwZjZN6CrNStcnFh8VUCj9ZBX3Y2o3SCa5JPzEXjhmLmrUEUlykqnHU0/JYwMAb38eji8ScJsQSiq4JZ4F+nA7orLcy7vOVP7jgmi3UWGd8wLvncAOVJN0G2bhPMPnGF2DHzK6H/UVxOt1N02e2YoCpvyrRGuloX/RVYuwdaQPiHuUuAzKgQZ48+72kwYxpk3s0sNyCay5h2auU5nSUgakD4dXfOqZVdUTBafzVu50mMejfS7GQjD
 Xzf2S0SH
 YE+Tpgi6lF6qDGBY6lGKlTFA0MVrv9apnffTdCJmb85B+pCvi0tFm/KmULTUFmcBNQHOqk675GnEKk6i5vrtQ5qKOUr+/LjeeJAZLLbt9AqaOozoEvgEf5/LjRT4dRwgTFOarAZI3x7jeGPgt7GPhDxc/XBoeWioYh/sp1mILEcc+tQ0PDkAV+ZsWphzLqszrtr9CQ8jImi3A3xMUW25i6jNftvBvDQytdQe+7+hmBcGqmYTr10ivUMGcsKKPKo9kobJFXEQWCt7NB9RYYV6dLqqy+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

kho_preserved_memory_reserve() calculates the size of a preservation by
doing 1 << (order + PAGE_SHIFT). Since the '1' is a 32-bit integer, it
can only be shifted by 31. That is, it will only work for preservations
up to 2 GiB. Larger preservations will trigger undefined behaviour.

While preservations larger than 2 GiB can't be obtained via folios
currently, they can be obtained via kho_preserve_pages().

For example, memblock reserve_mem uses kho_preserve_pages().
Reservations larger than 2 GiB are valid and will trigger this bug if
properly aligned.

Fix it by using 1UL for shifting.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Cc: stable@vger.kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

---
Stable backport note: This patch fixes kho_preserved_memory_reserve(),
which was added by 3f2ad90060f6 ("kho: adopt radix tree for preserved
memory tracking") in v7.1. The bug in older kernels was in
deserialize_bitmap(), which was added by fc33e4b44b27 ("kexec: enable
KHO support for memory preservation") in v6.16.
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 175c08a6e41e..6fad9152387a 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -501,7 +501,7 @@ static int __init kho_preserved_memory_reserve(phys_addr_t phys,
 	struct page *page;
 	u64 sz;
 
-	sz = 1 << (order + PAGE_SHIFT);
+	sz = 1UL << (order + PAGE_SHIFT);
 	page = kho_get_preserved_page(phys, order);
 
 	/* Reserve the memory preserved in KHO in memblock */

base-commit: 5c4a03afcb21783987ffc64562b76ddd5a21b12b
-- 
2.55.0.229.g6434b31f56-goog


