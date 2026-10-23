Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE13606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 11:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=l3Zp4gkU
Received: by kanga.kvack.org (Postfix)
	id AC4856B0B3E; Fri, 23 Oct 2026 07:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9BAC6B0B40; Fri, 23 Oct 2026 07:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852D86B0B3F; Fri, 23 Oct 2026 07:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 548126B0B3E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:16:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA82E80393
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:29 +0000 (UTC)
X-FDA: 85353637698.02.84DBE2D
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf30.hostedemail.com (Postfix) with ESMTP id 05CCE8000C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=l3Zp4gkU;
	spf=pass (imf30.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792754188;
	b=FUe0J2KedDfBjW49pTJkMCSnpXs5WT+fECH/Qi74o2QyK2t9Uy5NAv/lEsFVW9fz31cANh
	j13rVzvb0w1gUxt//3l4ls0FSAv36wVaJTwFFu5SZiQfB8MlERQt8R7n8xiG2J0SYHiCfj
	oXDM19r9w+xxbA7v4wlQYfz0D9rl9no=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=l3Zp4gkU;
	spf=pass (imf30.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792754188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGqMJHk6LUVuJtb9sOmDDL50VOC0Sssl6rxAA31XIdA=;
	b=MZaZ+cdKfGy4krJXd3iYeaAIaywqiozyPUfNtahcdweJmpB+IrAuVT0/9dzL+XjOY6fWgB
	gOoD85Ls5mBRw7Knok5OrwLCVaJMhFRXBdRRVwzzO0WPtxn8yqECOvFoy98NXhVat4/2kc
	UpwGZm6x+jRmkxiVwyVJGaeIYnUSYrA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792754183; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=PGqMJHk6LUVuJtb9sOmDDL50VOC0Sssl6rxAA31XIdA=;
	b=l3Zp4gkUxMeF3lIIPkCM/jGo5ZCCHJlORzXBc3zlZXSzIk8WuaFNHU5fYnEZHyrRHvpHPy657kgOr3cj0Dc45kIg85+jAQz97TjgWJ2pmybPVzPXU8GcrlH6Vj7DqoKah12F/wx5X6PjlguSPD66PmnGg2yWuRQYiptY3DD2ryM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDM1n5k_1792754182;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XDM1n5k_1792754182 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 19:16:22 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	alex@ghiti.fr,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com,
	shuah@kernel.org
Cc: guoren@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [PATCH 2/4] riscv: Add support for kexec handover (KHO)
Date: Fri, 23 Oct 2026 19:16:10 +0800
Message-ID: <20261023111612.2134-3-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261023111612.2134-1-cp0613@linux.alibaba.com>
References: <20261023111612.2134-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 05CCE8000C
X-Stat-Signature: 1g4qf3xjdhjckm4atpjm6ss86ru341bw
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792754186-416722
X-HE-Meta: U2FsdGVkX18RbZpQbsTQUWnitQMmlO/tswj9Rf951l7mFCdnDM3rk8EQ08/6i9NQnWJDs6DkAy6OVICyWvfoJAjyIX4fLK4RJOsuNAj5kDjgd2inKfZ7wBdcycnKD7dmS3NT/B8N/4gyZr+xMb6wcHNLRQSdnTdDzc1DvadBJs2lXFd3w+/OvMwcCBrXhC0d3BhvzyUHwr3ao+Tm5mlm8xyGlnizYg/QEzC8RVz30qQ/ixbk9QN7t+rjSO3HRfXPUYvf4p9rvQn6jURTIT2Fl5DYcAfFRuMWsDu93ZtQtk0b19W4+hPJXTxRhmqCcs5GQi/qJ5O+lqsoAoE35XKErflRzrug74KrXanW29XKNLgpbRzCdFPsrzfGwJmQnyewjN/urRb1cqKFQP75Dl1480091R+w74LSj7qJoTrHTFOwH7qDCd50IUa4N6wZgAdIigpOxpy+lF437kJ00vI1pUURSiC4aLzL4BF9arGLp65LGsN3bDDY85Yl8aRmXZpYXAqJtxAWYO1Pwquo3hSJTuaaiYgiqwaxuRiCcG08e5SeQK35UaCRlQxffwfXFHpCc88kNi7FbqYnC79sbGp/bXSWfkUeMNRHbRNs06wvYfKrNvjs4LJByMbe1t6pjNiH6a2vehYWeXe/rRu4CTJl6TKUFQ8TUBVybpcGgvZ9dkQh+Le3zR7j7NGYNRcWw1yEyVb2RCovPyUVWIgA+M2u79JUFzfjGn0S/ypekJY0PxFWZGzwVX3XlSR/JQPf0TR+iTc2DwXuKNEdRhxqs2xjDMhJM+mx2VGO/QJ7grQFcjjU8oqRaH6C/CI0RxZtDuZaDsCW1Gk9m1t8bY4l0USFfl3hjL3XnRVFYemqNlA/qbvDgkBIHXbvdu9pUpeetJt20c1iNLZEyRawnEy4Z75PDPPUn+dkmXnU3XicBGq53hsKdCpN8Wj+wy3yI+5iOleQ2KS55dBjt2YTmCMKOn9
 VN5h+PTu
 7FshqMnneXr3/LrcAyi7yBa6uqUL3bmqNmN8F2JqvaSUFBh28dwRElef6n1CMPyE8d1tSaauYW6UT3l19bUFz6tElSVtc76kxA7fH9kRnP6AZjQR7r0g1b+f6sqCebe2sfEu4MdaEH0xTkzHD41DrdpN2HoWbfiLe1M3sfMq9b/Dk3ON6XLPYcQ2kd+SjlC+e7NdjyiirEyucTpps0GovAYWZF/iFb+KFIh0fPgacmTxzfA1tG4kzwSPY+HXGa54/19SR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KHO is architecture independent: the outgoing kernel publishes the
handover FDT and the scratch descriptor array in the /chosen node of
the DTB it builds for the incoming kernel (kho_add_chosen(), reached
from of_kexec_alloc_and_setup_fdt()), and the incoming kernel picks
both up while scanning that node (early_init_dt_check_kho() ->
kho_populate()).

RISC-V already builds that DTB in load_extra_segments() and passes it
to the incoming kernel in a1, so only the architecture symbol is
missing.  Depend on 64BIT to match ARCH_SUPPORTS_KEXEC_FILE, and on
MMU because KEXEC_HANDOVER selects CMA, which depends on MMU.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 arch/riscv/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 5874ca30f4f6..4f7d2f3f80b1 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1125,6 +1125,9 @@ config ARCH_SELECTS_KEXEC_FILE
 config ARCH_SUPPORTS_KEXEC_PURGATORY
 	def_bool ARCH_SUPPORTS_KEXEC_FILE
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool 64BIT && MMU
+
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
-- 
2.50.1


