Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B74C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3494E6B00A1; Thu, 17 Sep 2026 23:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326F76B00A0; Thu, 17 Sep 2026 23:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7276B00A3; Thu, 17 Sep 2026 23:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF3AA6B00A0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:59:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 579D412049E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:59:04 +0000 (UTC)
X-FDA: 85225527408.25.1448C18
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf06.hostedemail.com (Postfix) with ESMTP id 40636180002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:59:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ydKkrnd+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loQVaTQd/RKm32T1IKVgII9zZSimhBFrCIUTGWgc3Hc=;
	b=0Ff+mtq8b5FU7U2PaxQmmbWKgzmwM0eHkyeC07u4V427Hcz840tZ+XW50k0ealczWIu3+9
	2MjyPSnDMR4+90qPxpChYlj+8ikGTRVQCA0QCRW6peB7fTfCKtIl21W1MRLlmeHfyUFp4M
	RLZ4Hr/h80oGTH3/oK136KJ1/c8u4Fs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703942;
	b=SpRIgbHkh25EoKDjnPSN0Eg2y/8OyXKEoX6jC5rW6Ga9eRgWwFham12tv2oAgXpVOZ/qQw
	IqubKrurBxeUHDhNqPW1DUlsmeirbAiChf5fFZdgPJZSVj1s65t3cRNC3nQBe+OgS+vuad
	5K8thq1Tt6BETH5UvPUUqZEWXRJ+Dwo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ydKkrnd+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703938; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=loQVaTQd/RKm32T1IKVgII9zZSimhBFrCIUTGWgc3Hc=;
	b=ydKkrnd+BCMCU5dNMiP2CsRm1gZMmejq7P7odVf3kKNqBNGJpW8/RP62/ZKPeytWBQYj/ZIve8qu/ctMuIZpF9utqYtaWY9m+aex95kY0lHmXzQQmdH62W3gmQ/u1tTPwluDPjP5bAnc0a7Xs0Qv6cT4qCTuSHMTpPLoWITc77M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9tapk_1789703936;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9tapk_1789703936 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:56 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] mm: khugepaged: allow khugepaged to check all shmem mTHP-sized orders
Date: Fri, 18 Sep 2026 11:58:42 +0800
Message-ID: <b32edd4990591d2f5af75d97bd30827d563029eb.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 40636180002
X-Stat-Signature: sx831s9hqrtk7wjsh6rbkhtkyks1x659
X-HE-Tag: 1789703941-821217
X-HE-Meta: U2FsdGVkX19xkgWGuADEjE2y767OhFOM1+NAk+ldLWQMFT3qXRi4H/h3/DgDIqT1AV3RR8N9Sg6BxPLQMsetqFiCctWnpKovl92jSiOc0EPzquvwxK+lZoudtJ1GQO8Ph00S2UqGpYxTb5vp37/nJ2ckQW5z1ca18OYxNQXH/GdHI9SOnbvaeJPCkX83JdfUwqRmGl4zN4R/3F+J3Ezb8WChSM8Goxb5Hq0AX+gXTZ/hq4Ah8Tn43yv9J5nCsuxZNN/agFME0ATevAQ/EKTOr26cwJLga38ed2H89VLFg3Ve+ncqQKTbi8cTrE+l9V9sxU0M380UPntnV0w680wtTYyX3ooIm2iKBXD+Br/rX0MAgUY8/Yaf/ymtoS0pfRiv3s0tfHwNaB/jo1APl6o32rIoNNObH1MYeg05/0Af4slXvIva5Vk+VE3FFEQgdiqDy95ElbTJTIjT45girQ/8YP1zPWWHOH/mxJ3fDGhHIWotl4KKzLsoKxTj6r5CeNsmY1Hp1ba3ggwl5ITzojrwsS84FVTgnp7CUa8b4IjaNsRsEqvccFfq1qVYCz3JjcOPdXOGp55rb2nefBPGKuLQDKLSrolJaj7mEOK4Sud0Gj1X/iu6+1Ft/LxR74WSKLBPTNZi2EJW2Yf9fj371jZl/CD9jaHTr0regEgpqIULbs28PkFIpVbEAhHumkCbl6bcAf8uYE21t0ln8xuqPTvfvlJRIp2KRY2tR6WSXxegUXrLlz7hUidly9cRh0qzL4+/pqeBMPQWc9uKgI9okzF2Y9/JRmYUr/5Je8QoEmJV00V973gwB5qG70Mcf2mBGgMJOsdErfff/fAaZIFsBd98ETzzJU+TNNhQCUeXtYSU2xYhaDyBDpfI/tUkZpveiJHS1XwRMuumA6i9rjlmg7thii7kVocGvgqU7KoQu59kVIKTtNtT3yAQvTZ2AvcrcCr7Ju1MYXbhAeELMEIMNwQ
 DxFPMDS5
 wZwyOFrqwEzBN0LtfpBR53IMGuXKKGtgcTOHMJqKUuzPMZzn+7IbjDPyhPLC7riHnK7qSw38YbRNHbLAj4yham/6vh0m2wa1avVp7GrMII6ahdSCt6A+S27mIUebA0tD50g+K+P6etLiFnDgWLGoFg/PkoMfZua/OHbLB+5JLWLNxaSOY/ZNpdFyAkyQR5C1Y4cHPYdzo9fbluCdTapBeolmBjEcPuwwpH3pQ7q/mkc0RtO615m1gNty1P8qXS7Ad6Kpt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are now ready to enable shmem mTHP collapse, allowing
thp_vma_allowable_orders() to check all permissible shmem large orders.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5c477ea16c6f..4b5e1f8ddf87 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -493,9 +493,14 @@ unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 {
 	unsigned long orders;
 
-	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
+	/*
+	 * If khugepaged is scanning an anonymous or shmem vma,
+	 * allow mTHP collapse.
+	 */
 	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
 		orders = THP_ORDERS_ALL_ANON;
+	else if ((tva_flags == TVA_KHUGEPAGED) && vma_is_shmem(vma))
+		orders = THP_ORDERS_ALL_FILE_DEFAULT;
 	else
 		orders = BIT(HPAGE_PMD_ORDER);
 
-- 
2.47.3


