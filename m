Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1A3C53200
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 12:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251B66B0095; Sun, 26 Jul 2026 08:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2024E6B0096; Sun, 26 Jul 2026 08:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CDF6B0098; Sun, 26 Jul 2026 08:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D68856B0095
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:21:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1E1A1404D3
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:49 +0000 (UTC)
X-FDA: 85030839138.14.9F29EE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2BB8320006
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QuEtF8em;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785068508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3Tpy/wzxEiLfJdRmM1ww5rxhETR55Vkf0Ib0Boy9nA=;
	b=Qdex/ORVC3ZlJTugCMYOkgNj35UJJs6+3szAFL2tpL1bg1lny6tzPaM7F25KsuauCGlqhs
	tVQNSv7wTtt0+GBWvB03FZ21zVAEenya/wWKGe2vvN5foha5UelbxHXlSgDwwPi9XUaXaq
	MLktSAN1IELYl8eyJ7RZSVc0+apk084=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785068508;
	b=xBvW+hS1sAG0Fp0xSFhyXxYrpEVvdaUgXK4wi5frtUpSuYnPVqBa5h/MjeVB4WvHURnYOs
	yvv9Pyt1MRwWmv85/TSwrKsu5kVD3Xc+2+drAKSftZ8LBTgUm3isUTYEB7gvj5vCE2l8pH
	0Gi78yKFN38F4oGqxxpMbvSJ12d11xg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QuEtF8em;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C57A960008;
	Sun, 26 Jul 2026 12:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52421F00A3E;
	Sun, 26 Jul 2026 12:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785068507;
	bh=i3Tpy/wzxEiLfJdRmM1ww5rxhETR55Vkf0Ib0Boy9nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QuEtF8emADZd3nUVu6RKBf1T046tPnG23cP4gefkFbl3peonpAXCR0gZMAC/7u5Bw
	 DG+yzaNjJCOv2OXBVcpU3x0dyfM3z/RGu14J102sRLXjx4ly5s59kRJz302VlBe6/P
	 cYB/+djpMsx2pdjcrp/YdvHkGI4rosj+wejlNgLrwekIWgYB/X3kNleg93wbd3qhXT
	 A2/bfKvHrwt5Uk2aYulnyWjxCl2S80ZlsDh3glPHrI+UMrA2NH1pzMfEC6rXIE39Pf
	 01DsPm4p16CH2Nsu62GcUAlUL+/m8gXtQ0HzoheddLXLahs63HpzWYaJzhPsJKNhDC
	 7Ui5Mn7ihYEsg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v2 5/5] mm: mglru: run aging if the preferred type has no folios in reclaimable gens
Date: Sun, 26 Jul 2026 20:21:23 +0800
Message-Id: <20260726122123.7614-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260726122123.7614-1-baohua@kernel.org>
References: <20260726122123.7614-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2BB8320006
X-Stat-Signature: ihcbxjtaiwnqhzp1aihs1ibt8wrhac6e
X-Rspam-User: 
X-HE-Tag: 1785068508-443980
X-HE-Meta: U2FsdGVkX18NtxoZg4hUSWvJHo1jEsIqJyFf8Eflyt1sqOxT3zfJvEouxxOZaG0eFWKyfJcPW6QgNYpmJ4MbzWElDMO+HRK0SK190h2A34RfIGiNc5U2mpUGXNoxAP8EbVVLPaEqSemGkCWHr0HnNG5GvcZ6Pcz9U0D1n5YKCXxV9q4xnkIXvuEpdYXWSnWW4vb8Vo9rCD2BdhoSErh4lVV5EnlxjLSVnQOpDAJgaf421kNRqaI/Y4KwqtxM3Z8E2YKOMdvXRnoOTNnN5qKgN9Sp3SOcyK3kjgeHP8jA57BehSFeOcvc4AAVkWNWVsaEyRPfDfLgoaCkm6LY/SVsxCmt/pqS8eG1+Mg42EGcqxc2vdv/8S51oXLWW3ViGY2wo6Mnvc43NjRaZNLO1l6WJgczhNq4oHVKfqgur0HuYdXm0uXDQbwOSUpEGn4bgRtxjjEq0de+KAyfop+4WFeXOY5yJIctw9sOwkkNlMt4BnJUb/HAg3dLAAM3MsIEOHy5SsiV1buV80xWAcg+p5aN1ALCHCwcj/K90iULxJ9ko/ZDL2RYgAOD+hpg/TNYg0+ym97JD+naxNXFrjJefQkbkRUD6mNMW+SKmFb2XWli90/jQSocFc/lK/kXW5yG3kCJ3mHLF6MemKg+bKbtagFdDKVsTNVwml9KzZ1WeS2S6E+SI22Quel8s2WxET7psz8eQ6biBO2HpFx6ijZ2h+FIJJtwkLBzJg74Vv32UfCVeemaBg3r6gPW3e5HecfNQ/gu2h8L9hUz0WlKNruRhhoigHSUHjpVCyqAYaZ5WrhM6VLfKcZTGkssKvEgFWUBhI5pnpyXnbKSRDkgZcPbP6D/x9v4BNqCT+Z5pqPPEDpuqLwVwYOP8OTLNM27i1hKJFdR3BvN+V0OUL/oVFB2ARFPNZs3wW73AWTBnlz6x7FGRiFmOrPs/XZC58/AFOkmQ/xmHCECOit9F2ydZ8p4jR9
 Q/2u3AGw
 zvaNQNT+Az2CHhQQUd70wRIR7VbnQRFfMI1vqQK38ABRdhKLp+f532CCEVxg2HO6R9b+ZHpZfgbgP9z/tyK8+WMtIU5XgIz49f8bNDPckUmdNpXWcG9I1BsoN+TnUqDcHXfBmRmbx13ZCmKD/p3zHq13OsPGHjgIxmuFfNAr8t4QLoP2NoeXmTCkN2gdXXqaQkWyGHA/wc3CEStomQjG9vYdPLlhF0F8PtaoUHP0tlTC5IbvnPPx4XSTQKW+CoKVr/BUw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Respect the type selected by positive_ctrl_err(). If there are no
reclaimable gens left for that type, run aging.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7c13dedb0b1f..d63322cdb1bc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4996,6 +4996,10 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
+	/* run aging if the preferred type is exhausted */
+	if (min_seq[type] + MIN_NR_GENS > max_seq)
+		return true;
+
 	/* try to avoid aging, do gentle reclaim at the default priority */
 	if (sc->priority == DEF_PRIORITY)
 		return false;
-- 
2.39.3 (Apple Git-146)


