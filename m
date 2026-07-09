Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D82BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C18B6B0096; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE486B0095; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30C46B0093; Thu,  9 Jul 2026 10:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDBD86B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BD74C09C4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
X-FDA: 84969412374.08.A5D3E0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C6302C000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kn+mcbgw;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	b=kXQ6l+EBbc+EiaUmNnaZhopb9SyclnqFrMa5YJpK3NFVsnySkGeTn0NPZl4qlRO7pUmNWX
	CjyCpS2f7Gy51nX0JMxplGwmRJRxHcoJzOW3MIWj4uKtZtHI9f6nnEJjnwksie1we9kfln
	2RPhjl0HpvTAcQLXeK9ckpE669ZV2Z4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kn+mcbgw;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605965;
	b=PVCRdQOtTCW98AqK6lz8KHD2Ui6JmN3UXaynsOcOvfiwwRz+xuqV4km/vI03BFtvgGB8l6
	QilUAkVS+mkIMY3GBzdqVXcyeHT/DS7SEhrWiOTQ3bweseOot5iMJlrmewNHsSQovGFQJ0
	l5LpfES2dkA6Jve5V+a+yTqD6IE3vt8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1944A42D77;
	Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0BB1F00A3E;
	Thu,  9 Jul 2026 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605965;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kn+mcbgwp2zvPHW+COUjmO1ihT1Ei7R32zOzj7EohG69YDOQBWD0vzPjMOxRUG5fk
	 iePqk9X9/xucR5VPmeluUrkabQMt439s2Av1cWD9VqAwoxWB0povfkqhF5GqnO4HKW
	 95SkKCGrPNLXtuvlMmC05ZRBDEZsIJj1GfogUEiLve8NVJXW+Mv4i3tAV6ZlHltEE8
	 rzRK7XB+pfnjOVpnE9xMbbPzJ5VGoW6TDjuhCQkIpRiWBj3vYfPTXzLsyALzK7yn1S
	 RX4dh7lR4wyzjJFce7tBXyn5pIQE6R+hRRhqg/bjSe0blNn5sph/TirM6xVuwoPxkl
	 gqCB8j8Y9sEHQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 03/19] mm/damon/paddr: set samples in apply_probes() if requested
Date: Thu,  9 Jul 2026 07:05:41 -0700
Message-ID: <20260709140600.90950-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4axuj4cdc5wmqhn9koiiz4hf485d35tn
X-Rspamd-Queue-Id: C6302C000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783605965-786966
X-HE-Meta: U2FsdGVkX19F2onMDDLPSfnkE2aLrQEFrSfkzDCdsrpHy81cuP0g62bhFq03hEp0XxUgVgGPsaQBs3mz5WEk9JsTzFmnnxhasgNz3alsZR/96CG0GKsGW9DuqimiMGzy0mAe+7f5mttzG6g/XCNRvh8HtsmBi3BkbJHaAM5hfJ/IYLRnUC8i+9Vj3eiXbZHCr+Rle2ZKeLKLb4ZRgxI5DJsyxmO0o4wRKHS6IEAGH2VZqYAPF//UXGh58yI0sew8DpHcXyB9V9FAYkcIw6lSSsdRZjOL3c6Xuw9rZuSD484uB4ywPMXS7zP24wT24va8YWhV8pVhTpSkr7IW/vaBRPn+2nZw3JB4fGREWm0VOisMp+i9EDZJd4Gw43Eo8/zrdmsfGhpK/CpyVHZbdi0QCmuWnnIJhNurjEMGA+OfXSaPhqIb79fY6MKzGw5QUpFsPwMvpf0UO76bh139Tg/rxTdCKXW9IvAp84PLuqchVECuakY2wB0/1OLrukRuT0Km1ZBLhf8OjNg8NH0ejK6TeTfohG1YnwJ/jw/0Xg9X8hrqElMtEj5sGj7xfHP5Bebey9QXdqpeuZir/NCVz+K+W1tMHxnygETNdv85SzQ0xJc+nq1BFhPzpZBnQVZJPLYntAYNoBFFtWmWVE47IhaFeLOXR3uV7wGBUjHw0P4wtWRdzEdTZUW8/Pkm/3P8oykBjqgDR8uKJUo68wH7/PCfnE3uYFQY7b7CpGZ8HNAF9Rt4IwvnikrZlkFx5kB2ksrH13LquU4OHmuuVS/KQ299gTc6c+veLoTtMZS3gkEsW1w/+dVeD6KGTr/B+V6dl41QNIT4NNPII5MBpRR0JOsYjlij7Ao+SHIuTFahy4+W1PeO/44lWWLIaRT66AOAxMmVQ+vT8Em/Dgw5TYh4CPW0UrNSENc22JaDOWPeDee+hflEZlrOHiTUvIXQyut2PQckLK7w+FSYSCvTLucG11f
 TS1Md1PX
 +mdGxFBfNW1Xi2FRZJdERyQF1LPftu/eCm5encuBYo4E7a5OMsGAjQyFrRsoMpzokmj3VzkDxbFLgKR+XAmD1aPKFoCFUvUaQ+KcpOuYOBvh5b/alMfo8TXKtkkSIpYh2V4b69li0qhFCxnH+9h2rszOg9b+WxWCSrzxu+A/YDYNBroUozIh45t9wiwMj/EiYkGUcYLTLmOB6gdfIxMWRvi7Z9tzP0fHeWf26HthVDTOShEIEcbuu/AKYwWd5UCWrCFe9ZnTmLIN5z0VkFeAScgtE6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_probe() callback implementation in DAMON_PADDR is ignoring
set_samples parameter.  Respect it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b13bf7c6eade3..ff4fcca949660 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -178,6 +178,10 @@ static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 			phys_addr_t pa;
 			struct folio *folio;
 
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
-- 
2.47.3

