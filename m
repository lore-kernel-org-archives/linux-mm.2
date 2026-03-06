Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13B4FCB61A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5697D6B008C; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473896B0092; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3245E6B0093; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E72F6B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D672D1C460
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:25 +0000 (UTC)
X-FDA: 84516022290.23.B2679BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3380C40004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i10Odjcx;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q96gGoQlF7U98hvpGvjCFYsnd7QkE1j3lim2Nmlz+5M=;
	b=RYXt1hfHNEUWEz/BjU0h7FNtlgBMv3NyebJIyjMWq7hPKhiXbIUy+3P3UABMqTQDAX0wBO
	ZrgYxqt2notAkiPT4j7LcVnCmNN+5xd8/oWVNqWE5DNJPRQ+wiDACR3QIZ+v3BHdXOoU9x
	2Vj6/k8ap4hlA2vdQCrsmOrYNiE8JTk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i10Odjcx;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810964; a=rsa-sha256;
	cv=none;
	b=H+zkY0mtO8rvy0RKqvpHFkbBQY/6oX2wuG0J+ECHKHH4nksU+RFgYFFk/23vKSUKSjAOUG
	OaYMQ926qxmbo4M2ELgMJNXgDMuEUgOH6B4O4i2DV7LHtmaTbEu8faKosjc4ovx/8TNpn7
	lZqdN004DHAnHh0KJyMPxMRcLxX1aGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0A30443C4;
	Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA3CC4CEF7;
	Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810962;
	bh=h0Fe5csr3sldzD6TLO83VPiRoEMNSXNoD5pNU6aZzIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i10OdjcxbIIELF+N6tlSux0gYDg0CoQs9zRPvDBH7PxK3Pv5+MaS73hoMBgMR6UVj
	 UlbnKTr0kP2i7z+BwDMbJpSrnxIeK1Ddrk2QqZ97vlQw3ARgIgTDRGPRkHrHF5jTww
	 238+MOrpYZDHA80e9LktKDClyiA2A8n8LqVsQbm2vGiINhRlNrDokGl1lm3HYB7kn0
	 /cPj6g8pP26AyT+oOeAbw3OEb7FYJinyuDeGNEL1C7atJrjXJIZODMLX0Tp1FCVbLe
	 O4M56BR5HSjEnN12cWsdGEPnVTvDYlUZ30tjs3k0NHFZ8ridz1L/GkgBr7X5cX4BQR
	 WFvLOvKYldZag==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/10] mm/damon/core: add damon_del_region() debug_sanity check
Date: Fri,  6 Mar 2026 07:29:06 -0800
Message-ID: <20260306152914.86303-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3380C40004
X-Stat-Signature: nt84mmf5ewznzfubbuum6fdn64r6w5q5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772810964-708845
X-HE-Meta: U2FsdGVkX1+kQwXNzqvUEI7IDABSa14oH3/gaMgntW92HwFirzoWXwcTzaj6e7B7q73P9EqbtAhtrLSgRKIGRVoEUqumDrTlOjZZxRUOlI+hj3bU91+w+Mix9wH+fwTDjRl9oQSz4EMBLFN7MV+rAVKJhS1Lx4qActSdbW7mrJQvQc1P+3sTeNmdsHeOhiThlhM2K3Sa5aLq5mnLuqbIpQyrLEbINXAtXX8eVJdpuLzzzj9xzrsYGj2TVsb4YPsbnwUrGbl4YLhlt418uJZJ9YVQznbarlqYVS2OWNPXiiIKIC9TXT+LjSAV+mDfoXPcHk5xa8nIWmJrsiB9idbI5SC35H28mVgDNd2sy8Kz+UTiP2RwhRTAr0KMwr1R2oBxa43iERtJdn1k385XnzVVXwqD/tL/PB5PR0Hv2jrg6ENn9nEtHxDxAspBOWCK5GyjyXzp76IBLTqC8I0yP3HykTlKFRlUOaRprrpL9jL5sJmsyPkJRIguY/AMTxRtpfWAraIakLQfhTXkHofq8tID3XyWv2cU3YPamL8fHhli0YASEDbmGPHSQtZAgY65LGxOQsIk8Z/clPjjrCN1Uy1k6t7+PrIecR+usiJZ48DRJbt+YgNhT0tbrvcVSDAA98boMjXFEbZSZotybP3IV3mq97pTsata5qULPPO/w42IesxhbAtXWz5Z/IFDDVqPnip/BxLscNwWhwOCeXR9GPcVG5KlUiy9AodI/l2mjBh00kDHz6P/wxEJNIW0CW1cXsP7gvAQcNUkMtwOUly9eMVCVLmnTQXN5q3RGf4lei1mNd0ekHI7ubJhSaog5jxZaS8bNvv4pYrX145AGLYweOCN5U/LspJSz+7BFWEQ60xMYDdILVVsA3XLCWvdPxxknpAWqQr/C6IkrXXQ6/phyw3z5C7Vak8vD0Tv9TF6o93X14CdnbQHPmglPDRwYjnfsZ1HsL4+C2shkIstPBldjgu
 CY2Tezl8
 yJpcRvnlC56ncxxGuSlqdJBTgvaNwsN8FeDSCzKZjecXrWKVAUyOB6Yc6lttPBkth4dkpMVPASlx+DPvBeKWrM08eQ0CFwoHtC8KuPmRUMnHRfP6E7sbnJxszJeeeASM2Esfln2i5K3+8ZaZ/RyPjz3NfGVx0aPITwQHgYOJH66NP541OpS36yJgMEjnZJ+jIU0NKeAWeVmX+2IxxiIjn632erPx3KQ5GQVmhRehk4HvhEvy9dELFqL+LiLCk48tWHE68d0aPvMNqTAWNqCfT3EfCdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_del_region() should be called for targets that have one or more
regions.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0c1353164ec81..92eac5eb96026 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -152,8 +152,21 @@ void damon_add_region(struct damon_region *r, struct damon_target *t)
 	t->nr_regions++;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_del_region(struct damon_target *t)
+{
+	WARN_ONCE(t->nr_regions == 0, "t->nr_regions == 0\n");
+}
+#else
+static void damon_verify_del_region(struct damon_target *t)
+{
+}
+#endif
+
 static void damon_del_region(struct damon_region *r, struct damon_target *t)
 {
+	damon_verify_del_region(t);
+
 	list_del(&r->list);
 	t->nr_regions--;
 }
-- 
2.47.3

