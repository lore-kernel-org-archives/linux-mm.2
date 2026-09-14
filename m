Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D54C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DDAD6B0096; Mon, 14 Sep 2026 08:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6536B0098; Mon, 14 Sep 2026 08:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4B36B0099; Mon, 14 Sep 2026 08:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3252C6B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:30:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D199A0397
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:51 +0000 (UTC)
X-FDA: 85212301902.21.2C613F8
Received: from mta0.migadu.com (out-116.mta0.migadu.com [91.218.175.116])
	by imf14.hostedemail.com (Postfix) with ESMTP id B6C17100002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OAinCtuu;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.116 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ngq0F7L/BeBqokcJ/7tksYoJGvu3lD1oc2u82chsQc=;
	b=w+oklm5JQTi/On1c+s52NqsvQ8w/uGjkNzpLoQ37344NYNn2fOzJ9Q42R5cPQJRbrbFiyR
	rSzKJSABPQAylwgpG2J8P4y0lDnPBLSC8NTmXo6MFP28O4mBhW125glL9NEsakz1fMeOLT
	UTTrWAPoFZQqiyN3zP8GJYxqwmZolqo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389049;
	b=ibSvpeGbmSSQd+odMjb4gSOiob0ThCAbYussYID6daQ4vtqrDYzLCb5H0xCLrRW78KaarK
	IzzLhz1iOHUN/Z2+cl5H42Lw7hcROQ/mG+fqt7slK1BebAcD4KvmP9K4vU1aapAAO/gUqx
	GK7QcuGpQsMnQYkfVzXG6OhNiOMQ6Iw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OAinCtuu;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.116 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QiAy/7wN1ydZlsQx7DI1Vjrn3FeWZdoFpSxlDD4vX6A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389048; v=1; x=1789993848;
 b=OAinCtuupAMpJPULjtCJAIGtBGG71/6/dhf8cIE0WOAxUZHlxw4motUaVppxuVDpasZS3YDx
 exGS+XGpG9xGjy5X0fn49XOnJvqbkIFZiisEuC1wUMK2z70Bd2B3r/165VonXwZ8EFmAcYk7T/S
 QJnoZSshB0OnbVgxCSr79Tzw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 208b78021ed50abd;
	Mon, 14 Sep 2026 12:30:48 +0000
X-Mizu-Trace-ID: 208b78021ed50abd
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>
Subject: [RESEND v7 03/29] loongarch: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 05:27:53 -0700
Message-ID: <20260914122950.3283997-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6C17100002
X-Stat-Signature: jcjumandba453d56f93uuzo1s81seayf
X-Rspam-User: 
X-HE-Tag: 1789389049-241852
X-HE-Meta: U2FsdGVkX18bTj/eDdeLOZfuIfsGwv6ugHUJdhcIdVsvedAN6fTjXV3Wo7UKVS5K09mtbUWySkwI0E3IwYVcP7G/oSChsDoOa8gFPrYDmpaaQfzS/PQSbA5mYAOEzhsuNN4AjzNUNmIPKgkHlorqxIWypoe/qCMQ9OVc/YJPTscBwDV680GKXZi34rTp7U0hvlkYxt4uBCsr4p6R8pM4T8pM0lOzP3tHII4SyK7jN7pU7RrjaGjnhV/DURkpG4Haw/Zchd4giJZw0v1Zdb94lnHHLe1eJ3agx7q7hsgzg3X2yAfkFz2SuZWnvxEa//jVE2w0TQ+3YsnM5QBFnk/k2iIXzOhLyC+wk1+pBgje0BV9dJoHvfposaAt0cRr4C2WmMEPW3628MXqOHLLThZPvrjVVLGf6M4G7+ts+2OME+sy4+mhHxq8kaTUUbkDJhcH71xeLk8sQmYLUtF57zX7vOk5nQJa8ITLoE9lKQLJXkV1ckurNPNzM22FejgVBaiDuc96q4io68ylacq8Lnq3LwrHmxpUti4h0rrkA2FMiKweNIzSOY58BKQgaPnH3No5DcrK3EleHG+4bLAZQJ7pwwBT9rWz1KxHx8mgfX3T3rLiaqpBO657fQ02dqHdOoD/1vJ4a7n/IhFWN8AeoEU8iRgkBTytqgkyBUMTl3T6qoPXA2WTGn/vsBFGm+NrWPqp68oZ+4eG5dEi46RlhHfF0ULCZJ9YRjoioVKmpN0KON7ybohNQdzXNsxx+eckiS2yODg5tSNSWbjZ5Ys3u22MlD/UpbmjLAc8VxGV5F0RF2jXd7cvMukDQJvVXNc11QsAUdgbEW5qksAghVN+Y0ITINK7lrEvZIrfEdfLjVoSOuRbsEmyATxC76XaFc2N8A6D4Iv9UgjTgsaVmf+A6vWdTAAhFq9DZx3IjwNYw8ckSP+go40a4pVZ0fLOFjOCsSH5eJmnAL0ZJw2dwc7PQZd
 Tkc7RmHd
 UdC3UqeQNG2PDPe2yz6OuOUZ4XZtvqlrpJld4D/zzouITo5c8fiAVXxNvN9/krjL7pGrsOZ1IsGahvl8RsaaStouOqAtq3R5niLyNyjIXzOGP/IIEpDL4c4gk9JyAENKCARrS+3NCEBGEPJ1xOzA5cHvJc5MOMlJ2qfVRWYYido04qPmR1D2qmWmpYjZfh/pzc3XCa+QPWISYuiK8+w0NRPkE5LC0SKPIVC8BEYhAmoHkEeCQsjwjYGd6HM1ztGJRdtvSw4f8rS5XnTH9n4LoqpDkbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

A LoongArch swap PMD is the swap PTE value plus _PAGE_HUGE, and
_PAGE_SWP_EXCLUSIVE sits outside both the type and the offset field, so the
PMD helpers can use the same bit.

Cc: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/loongarch/include/asm/pgtable.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index cf29a4c8ac593..87fecc3a51001 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -351,6 +351,25 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte;
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	pmd_val(pmd) |= _PAGE_SWP_EXCLUSIVE;
+	return pmd;
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~_PAGE_SWP_EXCLUSIVE;
+	return pmd;
+}
+#endif
+
 #define pte_none(pte)		(!(pte_val(pte) & ~_PAGE_GLOBAL))
 #define pte_present(pte)	(pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 #define pte_no_exec(pte)	(pte_val(pte) & _PAGE_NO_EXEC)
-- 
2.53.0-Meta


