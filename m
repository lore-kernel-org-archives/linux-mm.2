Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6389C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3355C6B009B; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BEBA6B0098; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE886B0099; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED1A76B0095
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:18:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E2E31A0513
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:19 +0000 (UTC)
X-FDA: 85206071118.09.2E1A769
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9C3CF180002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSDnYgil;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789240697;
	b=3DHNgNfxTfvCh9S8DqvIlkthgmYi6B/D94JeMDCkcJstjMzKoTk+OUcwWG+4jEAYG/i3Fa
	nv9IbXTYzJSaayYeZCRBcO1yUz74DibU2Q3t51tZlE0aFoiWQZD9TOuVeR0dLTYKhkJExw
	6reA3xOxwwU/mUatDvb3GD++hNc9YS4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSDnYgil;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789240697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5maU5zzmZHDxR2AzfaTKL3DQf78nhgNoQRlzVqJW+4=;
	b=Pww7gCS+Jrpe9897lBjxKTqnuQtA8DFuYQfZAJUW8RTSC5SjFknCARY61Tc25ryFwKzBj/
	pQFX4BT4i8liljenOPtc7Saq3Vq8ZAK7N96ZbeqYb3PH7oYwdQUg0GB2i0ixMMujk4zdHs
	a21ppuCB1rOgPNqqEDz/ALRWeLp6LWU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20BBF600AA;
	Sat, 12 Sep 2026 19:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A3F1F0089B;
	Sat, 12 Sep 2026 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789240696;
	bh=I5maU5zzmZHDxR2AzfaTKL3DQf78nhgNoQRlzVqJW+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSDnYgil9MBGd5k4BYAZLCJOj9+ScoGA7iOy1ENZ2EvV1HQxJKVh3ZYcGuLQw+gPX
	 17X6y/h6zrIyGk6scu9KMcNCvh3IzV7xnRnNvFiX5r33B9qn72XXz5YKQX5Du0Thc3
	 RnbzbpyZZIjP0KnqDnZT6RtICn3w8COslSAngr0T6nX4bI6og3IhXk7Sb8WHc8IcRk
	 SF2qVg2ZW3bXaGs9eVBP8ooUisap4kWv+5Ixwo67THw1A/wjhkui2sdfgtKF2kYO1u
	 YZXtA8J+nzq0KsDcZulZsowyGvU9ZItY/la65zwfxvjtf/5XfPGziZVQzlChH2nZT5
	 FD42pwaD2QfFg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/8] mm/damon/core: disallow max < min damos filter range arguments commit
Date: Sat, 12 Sep 2026 12:18:02 -0700
Message-ID: <20260912191807.138502-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912191807.138502-1-sj@kernel.org>
References: <20260912191807.138502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C3CF180002
X-Stat-Signature: fhsrjjhgkt3chwjr7o7wkywu87i6erqx
X-HE-Tag: 1789240697-384620
X-HE-Meta: U2FsdGVkX1/cs3dhTklJwec0RXfJti+LfBKvM+HBzFHs88UHXKpwDG1vy/cAIJlipM/bB/1Xkre+PUmYh9bcUxgzkLM1Zj5ihLA55ZmMTcxCj9GReEp35hEiwPnjKBigDwwUMd3Hisn4YgaMO7aQhfJHSLKLKjtkw416/Shz+kxzCE+rjxBiuXW99FSX5BRtIPsAm5FRv4U7KNcH3CkVlbCR+fM7bLbLEsppOwuJM/MZLOYw7anDJ74z0LTUazgcUlvVODN8alrtrFJMgxK/J+39z9YJN5U+jb/5fWrgT0iUAJvYbddXQkJM+dk12JLKFqR3OrkjOagwk8XcdTaqM+T9FO3qlWC2kwDrEQHc+6kLQzIAaGkEdxecn7aSdXV1pVpj/7hpOUR06eY8uB/4n6rGP1qQNTaB+uuGH9woYrpJCChJwamX0EcZAZqC/g160G8c/roX7ZmHgB8rjHEFMobSrZ8oOBJTaAcwdbuhKCWi+BrbC4GbbL/J1/86WWk+8X3jsZbZyCUbkijtindob2MZR+9c5wsoo7CTgHDRdeCAsMpUt0iS7yUAHPEOYiG20TGEtPAcafnn4tKWAbuAYBjZHsXjoZfnEzfqHlRtGtjnOJUV/iRo0XIwwW9HQl6s9zIb//+luvLB6vTqKe6nzgIzj1hAfDAXLqps0jf9wULzRdQMwi9squbxtY5ADoJ2OAVjkcjq2bZrzqSXF257MHYsrYeHSF7yXtLO1oJYowJgiksqAYF6dkbCOzyGm7jXFXguPhk5NPGga981dfpnzWbYDMIqCgviImXdqCtk1t/ni3Y2mSTXNWKs+7Vg8uJ7YnryqMHieDI61FsD88A0rwNBZ06NKEllS9pPfTFC2A1Uq7sWQ+hYguckB24t6MqQq8yKpiR0fRhjEq7RCWVDYnK+yP+7tiz5I/iUD6WFd1Cnwvna9pTEvpss421G9WC3Rl78dPyS9QmPU2IOyc8
 C5rgPgZR
 KqV/kIpua8GcpElFV4DZTnt4WsC7aWVDlLjTvKTYj/M4HPUdMLm6mUhS+V0iSWdGHlk9K9rgY5N4xUy8ICJwl8pDKPFhIslkFHpS1GQaepwSkIm2yEqHhnh/0NyUh+XHddFgRgKmQF4cT7T4OpNKTMbhuusdzI2Q6HACt9VSBV3pzMqZVCO3vm6u/iTH2CYN5if98uUfrYexrP80K39bBuI1H5azmrV5nlosHqxwG8ORSyh4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_filter_arg() receives range arguments for a few types of
DAMOS filters.  It allows any range including max < min range.  It is
fine for the logic, but makes no sense to support it.  Actually DAMON
sysfs interface is doing the validation on its own.  To avoid duplicated
validations in multiple DAMON API callers, it would be better to do the
validation in the core layer.  Add a validation of the given range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3ad1fb2f21f3f..3dec1a8f7ed3a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1325,15 +1325,21 @@ static int damos_commit_filter_arg(
 		dst->memcg_id = src->memcg_id;
 		break;
 	case DAMOS_FILTER_TYPE_ADDR:
+		if (src->addr_range.end < src->addr_range.start)
+			return -EINVAL;
 		dst->addr_range = src->addr_range;
 		break;
 	case DAMOS_FILTER_TYPE_TARGET:
 		dst->target_idx = src->target_idx;
 		break;
 	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (src->sz_range.max < src->sz_range.min)
+			return -EINVAL;
 		dst->sz_range = src->sz_range;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		if (src->range_max < src->range_min)
+			return -EINVAL;
 		dst->range_min = src->range_min;
 		dst->range_max = src->range_max;
 		break;
-- 
2.47.3

