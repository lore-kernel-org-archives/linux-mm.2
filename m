Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B5B9C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4C26B0095; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DAB46B0093; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1D46B0096; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 336C46B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF2A41C892F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
X-FDA: 84972993126.29.C2567E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B4EE20015
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oiOcr6Dm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	b=pH5v86oJguIPVEvwwxBDpJ7qk8gFL9EbSbNjSivH6xcVBHZkaAJ2WwzboqAyHe9SZYUjFL
	HZuOi9ykSY2SbOTj4VhmupXWAfUnE3X51/JR3S2b1m4qF+Ry7ewXzjX9YsqB0U6Rm3FAU0
	hAGSL+uod5aV1DOXChx18h/8/lOQcWM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oiOcr6Dm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691222;
	b=tv5qSCTJ+3eLul+F9VNanys5tWHv7aMC7XJPvFEU3lxOWpZ3rX3L0Mb5lzeKhtOVjR2D/z
	PT7uAS7RqgKjrsQl2ms3/5rXVOrvj8gsDqn9bgu/OAwGuSJP9h8ktyGmlF3hqttDTnv5wX
	xZ9xtl3lmvBNPEkAlOGnfS9LWUoZv3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88E0D43C4F;
	Fri, 10 Jul 2026 13:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449111F00A3F;
	Fri, 10 Jul 2026 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691221;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiOcr6Dmh94dmKWV3A0I2BvdJp91mwGZdLaB5ePDtBfTVstyBCeEO08SmKiq0Y1Q8
	 USjp1vA33eU/gRHhzA7Z+8SiciWLyRJSZHaY6qdtYJimUpA8RiJhIxdnSDfGeyDK0n
	 +eOuStmqTcP5WfqWjY8yWw2LGumOhexAOwc3OC9newKii115fGg92ijE7drBU11i0F
	 IkNZrGwo5wkbuyqmgGmCSiGnVILzVmSXL+h5f2NzOMW8QzZNzuo5NWZsmZgfY3GvHY
	 tnNT1Deuf80OVF97N6HHG1+FeN0pHnckThmvp9TiLzCswtiUBUZFjh+2vdG/FQodbF
	 A9wI3uZwLHwtg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/19] mm/damon/paddr: set samples in apply_probes() if requested
Date: Fri, 10 Jul 2026 06:46:32 -0700
Message-ID: <20260710134651.18084-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B4EE20015
X-Stat-Signature: 1ii8b7cgbmka698rpmkm7osneezp4dgc
X-HE-Tag: 1783691222-823310
X-HE-Meta: U2FsdGVkX197+YS9iyD5Pd+xV+Sb17mXAsJgHIoq0noMBKrtIb1NtVhbc6JNOIiZM2jjo5OgXbJqy/mkjhFF/OSX5XwFS333AgW/QGEY6T8nm3Ta3FjEzP5qjptU5OEZsGGBOyLsbZjyoesucMnVqCo+kNo3sjYBWEv3sQlVobjZlQDmY+jzjbvl5aGdYIwI+tAzgg48tYMpvrQHXKDYS/J0uS3nyMA1Y5KJpbZc+zrqU5CZYVkwNIy0XEQcXJ8D6FAePJ1tRSS4VLIB9SwktgO5dxGpV7ZH11GWaKgp0bu+UalSxdM9R2aBYEfcyx6CoOaR+cm7DJErm2dcmckRsmv0rl50TaKNJAcUsXotpYp4ThZ3DkwnsziyE1ByB1uuuqMfDn5W/OmMUDVg0yJiM4nNh0v2qdNgeCYk8ZdPoXHTDUo/2z7HVn0Y3FsQIIV9fnk5MNhDZDWAAEzZt7cs+K4Lb98syINTPeVMJSz+Y9C51gLkDWubhm4TFiqdjPIhmtKVqZMzFp7ChzbVyQbunspziPPGEiuHqwEXg2UB1pIbnha+vcIFnoRL6d2HwP/G8aFk1mj99spR+JXarRBAQL4l3AquUnwaBQ5rTZ62hphT+h9GisV5v5pjreEGEf1NrJomDFJcq6acUBaJNahZNLaMYWzurfIzzfVG7Ni8Ltm3n6gVIq0dWdlN3TkeUJGpeIX45Yz5q/Va9gQawow6k7YEEsNkSK4J92ktKASVNCezozp636R2Yygr8OX9Zs23TNJ6GtPnd3zfb7lhruWhadSZBWMn1VJaJD0SChKP23ExwWyvKe6KjsaKx/RzQ1X5F4eTve8jz56qGymznZ2TBz6x1U95qJ6NpkuRC7ZQgdtG2cP/wOKzfSss9/h0hTclEI4FJzkH6HJX1lmoM639O4x3MoH3QGX4FJfenHJRkBCgwC0ySEe/hQ5WTKzqcUP8SV8NgUKPoDMkxJjWi54
 3+SsJ26H
 uMsd0nSfP3XDrvkjradkj3jC3iiJI7br9oCiIkgYHhl3VWapxFr+46XMM3KU8e5/8fy/t/W4YINt0cMYw8b91zC/lT2VbkrsMC25YLQwKsaS1yqbKs83usLaJc5bpxBSdP8zKzSS5AEGSmt9/K1RmcIVM42MhFSzYcjOWYXe06IjGH7M7uk0K4TD73lQUfnfGoECdaEB5AizJAn9zeq8xPt7wHepsvrt3XXEPyEfC4vxrt7pwMWHW5gVKljuf8s+LuV71h+Yo77exJvipAkvh2fjKJw==
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

