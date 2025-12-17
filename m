Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A4ED65526
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489D46B0095; Wed, 17 Dec 2025 04:47:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430856B0096; Wed, 17 Dec 2025 04:47:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3672D6B0098; Wed, 17 Dec 2025 04:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24E926B0095
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:47:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8F35160997
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:27 +0000 (UTC)
X-FDA: 84228485334.04.4F4C6BC
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26E45A0006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eZbKdt80;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765964846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0pQYHM1jhSwp9PHWAhzAtLgw7dAo1EQ0j0b9Rhu8lM=;
	b=artopVapRR0hDnEHMuALLNQx0FSIYSxvSeZZj2vztKMyCrWSuUN9QJn0m9HfuucM4EhBKX
	n0nJNjQKgMXSCJNtxMb6dwn6aBhBUq9xYpObtpvlA9EYzhYy1uLWjsPGHuBokTe4lalj6/
	JxcU1YpszPr/nowQ/ir0pZbGkDmidz0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eZbKdt80;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765964846; a=rsa-sha256;
	cv=none;
	b=Mp/Aeq1Ci4EzNSezBG0PV/vm7MF19di1sgoMrjNXtbZ/9aWVA7QU//q/erdaOYpPGtKJJu
	exGO38Vh/4iTsJPv8BDuKSFFp1gcErphz3HPbEA32yzf2n61439VKPkSfssVL2CwKBVEIh
	gTAXz/eLmRQzRhhNWOjn7guedocXCMY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765964844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0pQYHM1jhSwp9PHWAhzAtLgw7dAo1EQ0j0b9Rhu8lM=;
	b=eZbKdt801jfBgSFgEebLAPk6aFKbypVWe1UElNxogEJ4s/53bKjwORbNSrNlyWSCOkda+i
	Lhm9zqaDBr7ecgDa//lbBuDtDX4Ri+RmkhjUGsFN7HRzueDoGBbjIgvq+DZgy/CSBkw0hv
	tJ2jZMUMODUAxuvOlRoR0+NH+XExscs=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ioworker0@gmail.com,
	linmag7@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v3 6/7] um: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:47 +0800
Message-ID: <d8f1206ed75231c66a3269149dbefe68c2dc1ddc.1765963770.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765963770.git.zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: irkzq1rych5nogycc4cmntg4hcdfekyf
X-Rspam-User: 
X-Rspamd-Queue-Id: 26E45A0006
X-HE-Tag: 1765964845-608939
X-HE-Meta: U2FsdGVkX18sUh2z0o54VJXumQ9Iddz96mV6yz2FdMwKSR6mWgAKidLlhayCtNXzfuPhEvbU2FlbvMpkzczPsRRhQRYVCBNpmL+cVU/WegVIMUOyXwQFWvphfzKCvu/X751VnlZu6rZhtV8MX4Rx+1pgTowSSq+f2FG/OnBTX2k24G82eJ59pX32A1g6giO05MTD8tv3qvUH8V076xiXX0b0M+YSrqPTUvuyze/NP92OHtgkQVVi9d6h7srpiVsHiwx69qgyJSyK1SlNIZSpZx4Fo57MawhDO1L9Y2lzrU+50SVqSe+fWxLVRyW8sd7AvHYnbnuy4IkVh0PqY+2zWjmu+Hcxml1efFuM97O8ght5KRWiONRghnG/BvpnXCQA5wJ/2mn4v0X11nJ5Z2KbSYhwrLahjIBys/KjU1R9S65vfgqLsy+/TCVyfi6mwDIzlQKCL1mplIU/4cTHWWKG2HAab44voZMzmi0S6rgE+UUuMgDKyu8M02K3+RQS3EnfmJqO5WnMnna8mRnFzPQfEHPdcZeORAMv0jAamjKEpRMQauWwfVZKMVw5TCpsarhPvZHnH3HTjDQPnrUIemiHqs85q/vJCNKeYraNwCwSOiTN2Z5RZYxy196ZdK69Xtu+fIr7j0ny2Kijiz0oQ7W+Jv+V4++ySGlHtkI+THL7AOv6YxFpdmVwL+KZGuloLl7dT7QvXsFKNG9s6bGN0lcA3S0TaNlHACdBgVhkdbC2KtL8y5Avo4jCryK0qo60aby6WwqtzILKbeuy3KbgiVDoy+xxlGoAK/giqiv4mHE/kP22SCgKU0xlrP5XcCqF09ToF2jQBLLir9Pq1icEEdE88rYpyKOt88Slj+NkN408K0+cr39HGs8gI6KZ2csqtCW1iVEweC3k+TXZahIlPAQPmcY4WnUH3GNgpic4yaii0PsU8JPxhaRLd25zo2WCLRHmGqX5/KyhO55MCgstcmL
 UY8LN0yG
 Etxqlj3IGLbkegVifLz10A+Y3kvVRJG9Ug7qNSBVYA0xSbhSClex9n0o9tfF3+pf7tpiJWv7GMTvP4xrq/vO0KsbKkvtREy1/ZBAfr3dqUz+zrG3c/8WYZg94Sv7eaNrssTzeJDOI4cQzdnC+cKmU5Rka3tHh9J2oMwPXRtLu8wYCWJil3ZL7CTVBTIwnKnSvjPXUZoIOUu00oLiLWjidx0+TVPpVG1MUsIb6yJAH3CNUIGtKTfVGHUY2B5Franu7BU06Z9pOO6yZc6kdXipFm2zlmgedn9a0UZ0uS8wDe7evw8JEuc9s9ZPNh39nTon1f8SqPbWSgtxFAMsYC+GhEAB624l0untz4wNF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 arch/um/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 8415d39b0d430..098cda44db225 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -42,6 +42,7 @@ config UML
 	select HAVE_SYSCALL_TRACEPOINTS
 	select THREAD_INFO_IN_TASK
 	select SPARSE_IRQ
+	select MMU_GATHER_RCU_TABLE_FREE
 
 config MMU
 	bool
-- 
2.20.1


