Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E4FDC98306
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EBA6B00A4; Tue, 22 Sep 2026 22:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EDC36B00A6; Tue, 22 Sep 2026 22:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28AB56B00A6; Tue, 22 Sep 2026 22:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF876B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:32:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6FB3A06AB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:32:03 +0000 (UTC)
X-FDA: 85243452126.29.8D40F4A
Received: from out-2z4y-a152.jellyfish.systems (out-2z4y-a152.jellyfish.systems [198.54.127.152])
	by imf10.hostedemail.com (Postfix) with ESMTP id E9FDCC0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:32:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=pqPP1eUl;
	spf=pass (imf10.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.152 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eY2FwUhC+QO6BDI+/C9DuRURjCy94COvOGbyA9JIVXI=;
	b=dT4/5yZTdReQlzlBeaY9KPmnaDT3iOWysO3koiFoPym3XdMCVeLR6LlGzmWT2+KvvEm84F
	ikQuJ2rs9yedOnXG+YmQzizM7fJvrojE69C+qmDancaKO9GBQkRWIhe0BZIGLOiwqIVLPI
	wx7VUjjLuUVZgNkXIbF/dfgAYNMKYLQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130722;
	b=iGrm4hmd7SYEHOvj95t+FSZPAf3Kz6AhSPoTDgfSckPCy43boUi2YONY/KBPeyDUXgExfe
	JnLxeyMmQglIrI7J1ltCMC0Glz2bRmy7EguTBosJK6sKeUF10a9Qws7qrrln/hItJ+214v
	Foqyo4MS5R9A7LuAx2plkF2nNTF5ovM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=pqPP1eUl;
	spf=pass (imf10.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.152 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
Received: from fedora (unknown [120.199.7.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqLZS3Tcqz8sYF;
	Wed, 23 Sep 2026 02:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1790130707;
	bh=eY2FwUhC+QO6BDI+/C9DuRURjCy94COvOGbyA9JIVXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqPP1eUlaCDTUv5yCrMgjH2Wc/3DT6OkW+73aUgF1rN5slTP+4VSHmpSU3PFtP6Sf
	 9+2OlvqjVW+bGed9UI7fz9L5qPAvygnMpQQ5bfpVf3ZIsVzSnXY0YMRfSjiuzguuRn
	 4aTDwgxNHI1FpzJaGcVTyDkuNtWvoUOmyPEgaIuwh7/IFPjYd1eaDEbvw9EvQNNIYv
	 qHyvBfuoCA5UTn+5tF8yB/W9W93XPPMqw7uu9ijIL3WOllCaQvdH3uKN8L7mtJGrTG
	 BR9Fv6Vx0S9ky/PKpnL890E8FcFT4nIBpUR+gQCjcYFtme25oYZLLm4KYCxUwdRxWc
	 hetsWI7wL3cGg==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] tools: use __pa() in virt_to_phys()
Date: Wed, 23 Sep 2026 11:31:25 +0900
Message-ID: <20260923023126.1910311-4-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923023126.1910311-1-hi@tychen.cc>
References: <20260923023126.1910311-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E9FDCC0002
X-Stat-Signature: tzrz16s8jarbch3ou6gezsgswjmotddh
X-Rspam-User: 
X-HE-Tag: 1790130721-670361
X-HE-Meta: U2FsdGVkX191DKH3gcd+FnPehCqjSFwnRZyJv5q/yWyTt5fFbwQcnfNm6C59eUjyhxI1rjJT3AcG2Zom37Wd6nrgjhMVBlRMg1V0yyczUGhqnNtJpT0eWf1+pMyheV72y30UbCkfkJqPMf1SNEnoCe7RABbT2GsdA7SEo98lQuXlyr7JkxG8wDe+6++pbViZqcMCHRV+TK5mxSG5lwDYpl5YHihCVhZ/lwy0b2Rh7xz5/wVR9IUpUlhyds0h7v6M69wG6UJDNYc8T/Gp3wdzAn+Rn/tLb4OLcBtBYXyQJeMhTRtw4fsbjARP3O9L3BUDe/uCPTiKhtDm5OPVOpCC7g3D6ucHkdxnv6PFfRyoXYBSa44qBeILV4jm60N9mfJkHZrCj3i9ZAXM8o8YKuhm9/O4wkVHC8OTQrndkLZHK2v0WkRYS3nSX3yImjZpQqsklYCs5kx2u1XOxP/gX9iaNowZ48kIv8hz71VO4+0ylkEdrF6h1WhvuARkwSEFEFhnpZnZMPqiEK6a6YF3PkHCMPUQsHmZOObi5AtfM+D6gdjKja+W/VCnY6BGXNeUbbCb4+mWklchDqkOZidGcq38ZPrZFfiehB0561arn9KKZ3brkgnDqGNzI4JmzHWdbmEENyEPWni0PuTg334gJNLIsMFvAG6iRpqzrjpRILeK6ZOO61TyNwLtDqgJtaaht9VcQ1xoLmxfpAAmP5wzDvrasnzKYam2+YxUexoLmTMQsVOQmsB+H3kBxjOGAJJSNZHR4HehOfAICvHWvz1kTjyO93I80KsM0QpJl+u9VWSfQpE8DXY1MdCLYK33EYZ96/PON+ygn+S4kUIaRuskUlhnewI0JhG72oxSpMz3FrJMaVYrQP9sXQy4b9IcuO5zK9+gp91+WXy/xix1G8tfX5K7eMMFo9oNyPSFnKN1x02WtXBidFaho55qM6VaHqds5vft3ObyJobxcYOm81kFzq1
 PRAot5Bb
 KwHnyS5bXG/FaWhSynOE1EYrwM2pzoWFEPYJ1FfOoIAXKOWkumm3sCdFw8EUb44qto/8J5n+BGLzHkOqyC1H/UKYuuMCQQg38gRvR30FSK22PhSvEubSLhjY1oADF9y+KxRipONRbivlRJExA8ZtvPJqES1X4AYYdM9mtb4efPOw8mNxve6xdvRrjHaeF0ii5xmU6MiqrLaUmCgN8Txw2OSDldJuAVHoI3z2nWYlnFM8cOg9cC9CtuRxdy2rH2DurXpV+slk8kWPEbDYZhaXmz1UFNbkRdIBvGF/wvqQO0SxC5WhfBXWDYee67WzPonQWsy9SNcCXBjhfcGfyZii2Lb+nAInoC1Zg18F1SQHxb8gkL0ySiu12A5tSn5n5BnQyd1iJRwQo0hdMu6+hwwR0IJyTCA7OCOjlOBFjoF0HmO/uIeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With 32-bit pointers and a 64-bit phys_addr_t, GCC warns about the
pointer-to-integer cast in virt_to_phys(). It can also sign-extend
pointers whose top bit is set, turning 0x80000000 into 0xffffffff80000000.

Use __pa() to convert through unsigned long before widening the result.
This preserves the unsigned pointer value and matches the other address
conversion helpers.

Reported-by: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/r/179007180279.508753.4595268983388589280.b4-review@b4
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/include/linux/mm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index 84b5954f66c3..480526de8d65 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -30,7 +30,7 @@ static inline void *phys_to_virt(unsigned long address)
 #define virt_to_phys virt_to_phys
 static inline phys_addr_t virt_to_phys(volatile void *address)
 {
-	return (phys_addr_t)address;
+	return __pa(address);
 }
 
 static inline void totalram_pages_inc(void)
-- 
2.55.0


