Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48804CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 04:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2928E000A; Wed, 10 Sep 2025 00:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A1B8E0002; Wed, 10 Sep 2025 00:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0478E000A; Wed, 10 Sep 2025 00:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 790E48E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:00:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A01813B528
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:00:29 +0000 (UTC)
X-FDA: 83871988578.14.0AD9053
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A5B4C180002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:00:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F51/FDg+";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757476827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DKpBZaDCy7oZv7sRvIEsynR4ii+k1uKwAPPvtFrvB8M=;
	b=UtQ4Z+J1aD9OOFOhgzIe84UPlrcfC6kiBhTdOkSwpiBlIjcT+nxIR3891MLU5Xu0qCgdYD
	iHw0bBmCyL5BWd7B67dY/sju72QAKE90hv3t/pDN9Eua7SKydJ+X3mnObw+bpIzWp2AeS7
	yaF5KLGC0xGXXJ6oYfdwwkg2GQOSBJI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F51/FDg+";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757476827; a=rsa-sha256;
	cv=none;
	b=RmUbBYkbKMKYf3lSPG+vZgA3qQu1sEySjOFxCVXVsLOaPzEPCd4OPrSZ0MFS0oRU8M0Pii
	9tPDfwK6GNjMQS13ZCFwaOapJleJQyryFCfhzVPumduqVGKV8prsatzNGuIODh5VSlRjHT
	nl6T3ZUye5j1gIsIkJYfTVT0H3CGewk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E924C60230;
	Wed, 10 Sep 2025 04:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7499EC4CEF0;
	Wed, 10 Sep 2025 04:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757476826;
	bh=XVQm/ezzZOJcJYBzuueA7pTOiZ/IJc3OYpKjbETFs6w=;
	h=From:To:Cc:Subject:Date:From;
	b=F51/FDg+uIp45MA5Pk5Ny+yXxiFF2Tw6bnhlvN7bwRcn5NL7QD/dvCntAL4pZcHQj
	 Clada5Q//btVK1p816mXUNxx7ATviSMgRN39lP3smLyTH4wgC4yfMUzTMZmaA7OJ1v
	 alD6d7lweRLonrmG+L1iywfQ19N21t9cGdBGFOxVaO5HCuloriUsVVS+JP/L1bMT2l
	 Z+IFH4HcpbRSv6nxq3OiYXs2nCIcCUSBKyzKfxwa+3Ssv++h1ujaRdNTm1iJse/Vub
	 jIJRjYCsMS7AwQGf00D4rVFvfJpGt3MT15zq/CZRlhm31UOkjtfbyz0pW/Gkie4Sah
	 inWt/35FUa5tg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/2] mm/damon/stat: expose auto-tuned intervals and non-idle ages
Date: Tue,  9 Sep 2025 21:00:20 -0700
Message-Id: <20250910040022.168223-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A5B4C180002
X-Stat-Signature: ny8y7gsxn7if4xi838i8n8w5k95om19t
X-HE-Tag: 1757476827-392571
X-HE-Meta: U2FsdGVkX18G+L9aMnSoznREEWFyj9SxvE2z4dky9i++NQyGVdh3czlYQbU5ybrfwsEHKGwEjAiCMO4lXxsvUAnQRFF1eCT1ntOr2nTmJ4ggPiyk6jJOj3Lx+dYgJPkTtoaobrvA1WMHpwG/Pkua33cExmh0RPJB3I34M9OqK1uXLaCiVcWywgJTuTEn5esbZvWporj/9UcOjNEfA42kPxlTF4kD/CisnpIbkSKf7gZhfCHoXw1VnRyuPf56dY3UQsFiRQwhPHR9U9LWadGP8rcdSO2VG2qRDHNVrgKNmWUmbxCU5yv+3aptSX20IF+55v+uc6YE6CCqMZbjUTdOfzDNnUKgd1bxLo8HUDTfwMpnSpwsIJvvrsCkDypYLJSqVBF8rcJMjkB538s/iTgmfOJ8bpToDrDF0HBKfBr1F97yz7hA4SEqzEz+Hx8iMUjXiQSATMS1lk8hBaIRFuFnx84s8aplR1FQYMHoK3EYlQddiUKuUVEYVAS/ZaDAvcye3RMnMK3Su+0ANNNcpbcHDkEG6aYYeuXa9BY0D65jKZBroro559I5duyiGVJh/rN12AULNhQMGbhYfQ6+m5ygaTuGptjEhwByq8+bgms/KMau9L03WCAb3Yyhdw5ESS2c5tTZofOyNGR7qeeyY5y7u4FTtxbY1WxRzA6rQjPfAipbGET1v6m8F9RnyIHPkMGQMzSB5Lo6wfgx3XRsKd6nWMW35W9Tjh9sUBiwm3KCaDgWQcHINM5t8YQS73P0C9nvr4Rg2Tei/WRUeNzElevhGqWntgSKbNgbgtQLGzXJe2GIV3OB2sfyF6yJa+KEy6O4OAEXNkFtB5nM1Z+RsRp/qO6pTf039B2ET+i/57i0KrT7I1+JJjZWAYzE3U0ifNMNiU9EJ58Pj8b35Xtjyf8EhPkINxB2fALXMlE+mKlN7iwK277CkAx6ALPhm5JlUHqHMnKR9qlcSlS4s3fqQ9F
 E/rKXyAp
 B8J9aUV7L6WyHI8SrJDYlV9yawsha5TTUvgBueEQREqlwOn6o6XADZonO4YlIMhWUNvq2fHdtZzs9M83LPz9qgAnxdO3ABjfjcKb9LraB6bIj3UjuLQT9tLhdAPxNhybD9fz/Di8+zH4PUl+cJedqeUVgVgkEm1JCndrigC3DsdEPay8eJFjOzOgjM2DSubBFiIgqEzRDDArpCso=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT is intentionally providing limited information for easy
consumption.  From production fleet level usages, below limitations are
found, though.

The aggregation interval of DAMON_STAT represents the granularity of the
memory_idle_ms_percentiles.  But it is auto-tuned and not exposed to
users, so users cannot know the granularity.

All memory regions of non-zero (positive) nr_accesses are treated as
having zero idle time.  A significant portion of production systems have
such zero idle time.  Hence breakdown of warm and hot data is
impossible.

To overcome the limitations, expose the auto-tuned aggregation interval
with a new parameter named xxx and the age of non-zero nr_accesses
regions as negative idle time, via the existing idle time percentiles
parameter.

SeongJae Park (2):
  mm/damon/stat: expose the current tuned aggregation interval
  mm/damon/stat: expose negative idle time

 mm/damon/stat.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)


base-commit: adc22cc8eb821b7d8274403ad7bdafb411fcc9d7
-- 
2.39.5

