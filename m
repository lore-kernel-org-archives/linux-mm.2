Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EAC5C55ABA
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 03:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C96F6B00A1; Wed,  5 Aug 2026 23:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A21F6B00A3; Wed,  5 Aug 2026 23:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0166B00A1; Wed,  5 Aug 2026 23:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34AA66B00A1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:21:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EDCB4062E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:21:39 +0000 (UTC)
X-FDA: 85069394718.03.DB02F6A
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf10.hostedemail.com (Postfix) with ESMTP id A99B3C000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:21:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BibV7Vdq;
	spf=pass (imf10.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785986497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JU9JL9M7KCuO4C47IYxn7TFZVI1BqrawdZoB+OB86NU=;
	b=vLX9HFZpKYMFLhRbcCeuqMP8McCaA7200lUfpiZfcbCjIMo4Ez3vjI5RZkZnITdm77fwdc
	r1hSLuky3dQYoE3LGTLwuQIsObY+NKqa36UrMTOF8utgnDkymPbuA8u35Dzyn/VsBc841S
	hXhxViP+eE3FKF/CdFspz2Njs6Eat+E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785986497;
	b=zAEE2LdY09yzMdRMFnyyPAmubuyf3qhxks8PVPaMpcbgYxJGG5cB4mNYSQX+N8Y+glCWM5
	4xB6EF0e6AHFrr2BKoiOPVP13k5Zch4ATuwEkKYg4VyenszMw1R6z5ezy5Vk1RcVKXFV4g
	igg9SDiaTB8Bb1c11qR72bXTUKx3wIw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BibV7Vdq;
	spf=pass (imf10.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=JU
	9JL9M7KCuO4C47IYxn7TFZVI1BqrawdZoB+OB86NU=; b=BibV7VdqW1KzY2ut9y
	3ALUWvovaUAnI/w/3lHaMdeD0wH7KmDPlxYd73kMgfXtoeMqQjU0ON1N3VEd6Biw
	itJMy06D8CTJ6pHZNdSyDJc9Nny8tyn33R+jB5w0ynXliESOoYZD4av70xpTsGLo
	X2T+oZKjsV0MfICQknWGKhxMY=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgBHa+au_XNqtjfFKw--.34702S2;
	Thu, 06 Aug 2026 11:21:18 +0800 (CST)
From: dayou5941@163.com
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	linux-mm@kvack.org,
	Li Youhong <liyouhong@kylinos.cn>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH] mm/huge_memory: add VM_WARN_ON_ONCE_FOLIO() in min_order_for_split()
Date: Thu,  6 Aug 2026 11:21:16 +0800
Message-Id: <20260806032116.681060-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgBHa+au_XNqtjfFKw--.34702S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF1rKrWktF1kKr47Gr18uFg_yoWfJFX_uw
	n5t3W8Wr1rtan3Aa1rC3y7trZ2grn8CryUuFWSgF4UC34Yvw4xKr4DKr9F9rs8GrZrCay5
	uwnxCw4Fy3W7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1WrW3UUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+g4i0Gpz-a6WtgAA3s
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A99B3C000A
X-Stat-Signature: umuddrgi4srejyqa5mdw7owmzkaw4jz7
X-Rspam-User: 
X-HE-Tag: 1785986496-696134
X-HE-Meta: U2FsdGVkX19OfO8wXErvV9wB32QK0IPTaZ5RWv1/9/DWRlXCA2W2pGKhWAyDU/mPJXRAjXXOL2xG4F84rJG5g+BtNQwiyOXKh7UqRQCCdRKB7W/DTe3cuiSEbaSSPhVOsK498LelDy9SDrPI68s6S5AbzlmF8h3N2Mq+++3XCbjPDV+4+upsioqjUjvsHxLKG2clp/OLSpBKIjJKb6g+gwCRuGncvzJ/Yp1amphdWIF0W9ZzlHN3dJ14vlR4BbnKkYD84lWk0p7/wWGn6LfveCaLSiUmhtSxpZImIjOtsVNct8TgNiNnuT7Nkik8yWl+nPa3sIMmfSpJ7Fzd3Lok6CGqyhYhTOMWnLbjEKh79gUF1BSfb4YkYjERM4h/Y7Pr0dFRVlyRaqDssph2mhtw1dvkEm3vYkKQ3hQ6n6JH5NL3/O3lBVmTyDPTgXfwNQVmHz8un5xj+kW0yDyn2ORkItZwoJbeXGhN9o2WWwgQzdqlP408lOJp4IY8gXH8YqgN+lJoDLAeLcZpz+jmdVd5UmSEgv1KKr9K7Mzkm/LAKcRUDrK9/VXsxvmW+9WZiBJALAqCUOZ9+6lMbebSqeHOCzrfREdbRmq9SpRt1r4kGekz+11sN47zpn1KdTByAk4F3Qwy4plEQimqst58c8wlVE+c4y5Afdery/WmtNo76pmZLfyEDEY5OiWnPMIvvrSHj88io0AGUiCJM36D7RNygGdB0+WjePsvln7K+i+OwWkDCmhJ/UGOrzctaFeOpw+FuAM6hPiWL3zVd6/++tGwsrJ23RlZNMDyWvCVNPo5xo/x199r7fGFedI+pU48Ye18NL97pmmmO/SeOrKtAEsyGsU5Ql8t3o6z+ozdbqdLRTkpvV1yWQ1o2TccwrQJiDwoOD1uWhIGncPb/oWXl34sMdLrqrEVP7mj87M/C5+D8c9VS0W04enRo86LLZSNFCEHKRcHXVexYlMyTgc4SiT
 9uR7xzFN
 bEvJOezdbf28Diys8802dMPq9D70y2hbm4hdOvPBcBrAQU8nUiz14F72tDIqq8ZX0OXiTSYUVNuhuhie84zlBbwvarBW8MMfcNzB5aT/2vhKwrlW+swIsZ2bkFnwRrn9GqJFo6NBAC64uTQLSx14s7EVBZSJYfpQDtBibD2SxKCTaexepZNtB60dIS/yQuCk4P5yjJo7CtAFaeGKDz4xWR+3LzfqCxwL+AOV9OFYa+JDKg1t1BtHBdkiwyl/eoy9Ek7ONqABX1k/OnJSdIscVLjBteC4jquhmEt3iZ7zq5/C39R8l1kCvdCOiyBRExgnBsGm/d9wDGCh60ktbzXT+rI7/VJ/1/+yKNUUiiE7d7iqd1BBl3LcbHkwe3nw3mlA2qN6O+NmJ0cOChUM/YdYWnNakRz32RnW/CnxB+myYI4THysSK87q4gOTLnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Youhong <liyouhong@kylinos.cn>

min_order_for_split() expects to be called with the folio locked,
but does not enforce this itself. Add a VM_WARN_ON_ONCE_FOLIO()
check to validate this assumption and document the locking requirement.

Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 58cabe6af33d..e3f16dadc1d4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4300,6 +4300,8 @@ int folio_split(struct folio *folio, unsigned int new_order,
  */
 unsigned int min_order_for_split(struct folio *folio)
 {
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
 	if (folio_test_anon(folio))
 		return 0;
 
-- 
2.25.1


