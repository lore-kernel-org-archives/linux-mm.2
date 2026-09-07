Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21873C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327BD6B009D; Mon,  7 Sep 2026 02:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D80B6B009E; Mon,  7 Sep 2026 02:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA106B009F; Mon,  7 Sep 2026 02:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECC256B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:53:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A14D80685
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:53:53 +0000 (UTC)
X-FDA: 85186051146.05.D51CA55
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10C3AC0009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:53:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788764031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=HSDgKTUWgY5kwiqDOAHVVdAshuS6ab2PANPt+E2RdnE=;
	b=WjP/UaBHANsos6gru4SHsgI/xO2XC1MxjIQmJ+cnhhX6FZKIS9aGtEuwob8NGnX1NK7zuK
	1mJtKf8vUCuaRSxrRhv9kYF/9pHyaVRJkcAoTxwBbq3ykB9nnEmDqg1V0doS+7ru+EXHWI
	ABOG4sIV6q9YsDd4ffroUzvF8MJXizY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788764031;
	b=fw5q0zwUTZYRAqaKHO14dqDC9bIn+Vkd4vx2KLk35mNGbw81S7UszI/LM1NczUTzT43hHc
	GCYVgoQdAD3DuuMCHmBBxU5zCoYFqhiQI/93r2HpPGAt9V3ZfEGnF9UE/zZOvoaQmeHlLx
	l6MLA/MnAKrUqbmugSar0JDXIj74Abs=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hdd8B61wkz8Xrrb;
	Mon, 07 Sep 2026 14:53:46 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6876reX2046712;
	Mon, 7 Sep 2026 14:53:40 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 7 Sep 2026 14:53:42 +0800 (CST)
X-Zmail-TransId: 2af96a9e5f76471-521a9
X-Mailer: Zmail v1.0
Message-ID: <20260907145342529uOGtNYWTAzrSCFnghfgCb@zte.com.cn>
Date: Mon, 7 Sep 2026 14:53:42 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <xu.xin16@zte.com.cn>, <xu.xin@linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: =?UTF-8?B?W1BBVENIXSBNQUlOVEFJTkVSUzogdXBkYXRlIFh1IFhpbidzIGVtYWls?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6876reX2046712
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 07 Sep 2026 14:53:46 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A9E5F7A.000/4hdd8B61wkz8Xrrb
X-Stat-Signature: oz5f5u5195eh1ffgnn3s4m6p3b5xzsk8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10C3AC0009
X-Rspam-User: 
X-HE-Tag: 1788764030-431045
X-HE-Meta: U2FsdGVkX1+6HIPbT8TpcrxkCNbyW0sm/XhA1hNW6s8LD7lcRd3dcZTqo8SD1VVUcfCYDfaOfpdm3BzZ7MHDUX/OGR26ij9YklIPSzdh9122ECPCXnqm6liBfU49scDJZ6yXeoPmE2UyFSgN9JdioUxzfG6lS/L7U1cnHFp2wSokHEQEXQ1PbuFsPqcOIu4qDZdNdx9Mtj+iEE7DyDKNaicNZ921SoO4DgA27OuPbySmk/mkwKodU6I5uhjtCNZuhIoUIWXdT7J2FYHoieLU8PvX7h2zORvsErBndWptKNohHcYMqwVNA+/jYpcmyxTremR/y1T581eLe4JcAon+gGI1KD88HotHYxIJXUII2pJmtnP/IdpJaEbEfkHD07m07BYxRHZqrqLElCUOig3v3L8Jx1TnaLvCFQknFCXchp+eZRRwnh7/ocN3jc5HERus7yjsd/FhdCuPF8OBWAT5IOTURSqZXXgkZ5wZp34xtwaVqqjROrv7NLvmgcQb9Jd6Zy5cUs2fiHNzh4D4sPf1FdG6j0uarFkn1HDO83kRKBigdygRA5zdR2XImfcGdMyPR5ysbbF8c2HjhJG1nqQYMaeH7mR563ihv4ksskajmkLkyMZYfU3MEYVnjuBHKewgXlMqp3QOPFgi/uZrNr8INIjeoJsG3NGnz3DHMWwGeExa+SvHxtxDVeCcgYenFQckA//wLvjBUxLuJcvD8Cq+THrNFdI2zlWgvwIteg+zckEr/8nHousanB/0TrUGShYDu8BF3NUn756JCUm6nlRjYeZvNA136ZN4n9dcMAZancRXyXul8k565KsUypnQrogkKvPETKTmfH9QyczQZZix3xXL2afPVf+q8xSTZUqTX/phGyp88Y9hjga4ao6SD3byBeI0JeU6ESZSiHchIghRPM1o+nKFTKfomjsn/KTl/0Dete26q9EzTcw2yCdUTmaK6ZRmg9hS0fX1QPhw4cd
 nmx+TG7/
 ck/L5+DuVxY7QYpVqqs9LyX9zsb+bhHc6pHAWocpJZessi7j2ipCcs1PgFa+LA0D2XjgXvb131sdN6vrfIRn+kL/Fn5htew595M2PFk0sGaG5ZfEtQaeqXBRtfSAPx7+yWrrx8BZXDMuac/0wy6rbvjB2fuMWL8++frQ9z09X6FlCoWHNmAoroZuSnkL1q/g0BODm4GlgAfL7A73H6/+B4MGVesBkbm/ECpP2P7Dk38VPMBw9xxTE7S0phVLq2Rj/FMPpTXXSkLA4gl51Hm3OQMHgdhx9+gNYjIaCr6jDQY8CNVOkSm2W+GNTpcZ70L72IU5uJnDaBfwXTJZHzvnRTvp/HIcVemAPUkGQOcudn+Q8a2pcIapf9/WOYb6ApYZ6FjkcDzYfJ389hvNNC27qmoFvZK4vFMg3nri+IODJIvsd7+3sKx3bUgboJ1Bc9IXr4Fe13eYtwunKnT1s7LfWdARmdqh0Wku9TJfbdKbAkcxPa6N0XaTUw7lcOE60z2QsOfc0dpvClDnv/CZAMQYBNeKTljXePv6AeP8GkjDlZQPdnfcX1uGemf2k+6IEVuvLLacONHGGOoGKmb4HDvIIPS1n9zok9yFdiegv2lv8RbTRGop/oY3cAC2dJpoJNvbADIvvMaF48hzf+dw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xu Xin <xu.xin16@zte.com.cn>

Now I'm moving to the @linux.dev account, so map my old email addresses
and update them to my new address.

Signed-off-by: Xu Xin <xu.xin16@zte.com.cn>
---
 .mailmap    | 2 ++
 MAINTAINERS | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index 5e3e1ed3228d..5c9aadfe656f 100644
--- a/.mailmap
+++ b/.mailmap
@@ -991,6 +991,8 @@ Wesley Cheng <quic_wcheng@quicinc.com> <wcheng@codeaurora.org>
 Will Deacon <will@kernel.org> <will.deacon@arm.com>
 Wolfram Sang <wsa@kernel.org> <w.sang@pengutronix.de>
 Wolfram Sang <wsa@kernel.org> <wsa@the-dreams.de>
+Xu Xin <xu.xin@linux.dev> <xu.xin16@zte.com.cn>
+Xu Xin <xu.xin@linux.dev> xu xin <cgel.zte@gmail.com>
 Yakir Yang <kuankuan.y@gmail.com> <ykk@rock-chips.com>
 Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index dd9a3370ff31..4b5fe98ed01a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17240,7 +17240,7 @@ F:	tools/testing/selftests/mm/gup_test.c
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Xu Xin <xu.xin16@zte.com.cn>
+R:	Xu Xin <xu.xin@linux.dev>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
-- 
2.25.1

