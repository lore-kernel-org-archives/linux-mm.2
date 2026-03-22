Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639E2FC72CB
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 18:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2AD6B0005; Sun, 22 Mar 2026 14:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793966B0088; Sun, 22 Mar 2026 14:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9886B0089; Sun, 22 Mar 2026 14:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCFC6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:47:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3D6F13BCBD
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:47:10 +0000 (UTC)
X-FDA: 84574581420.20.2B8E2D7
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id F0EC6180007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:47:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Fm9olenF;
	spf=pass (imf06.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774205229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YQm1d556B3o+NaQlArCokCh5J8Tddej2YfKHsXWYfh0=;
	b=s7uUL3uIbOt6P7XmFzirjJHKHzOuwKHH3DbEzt8yLW8QGadDuo3dCFx37oMHm3Kq0rSW+r
	SunNj+Jd1jncL+D8zfXc2u7sI91FOJStfdlGpHNNKBUCBpVdqhCd2MQm+C4y062noqcztR
	DWstQUQ3JtJBT4uCAymAs0775/B1xow=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Fm9olenF;
	spf=pass (imf06.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774205229; a=rsa-sha256;
	cv=pass;
	b=H/+J1mSAFtyAMIqqLXIXqkEwcc4oVhRJZgf3JqzwYm5OIzD2UCxBeD9/40C4B+OR0rdEa5
	ZTtylZ30jkU1A+beALJuoWxwN/8peftoGaWQDgX4smF88Zdb/ujzfFCLcPSJKibUhxPhQb
	FyJktxkntw3ykdNiMwlH9VbCIUyTu60=
ARC-Seal: i=1; a=rsa-sha256; t=1774205204; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=G6qSSUmeIVPvaac9VT8iADN1XJY/eFQyZwhUO5zGkaVe9XzRVMxXjFwY0OE89tJutsUB2th32WiT5mc0zpqXf1Jm0dSmWYW39CqXLDA/Qs/8FCnMepEoYVRJmor+gnghGtreIVgNxpWEPNGv+TnDCKA2RpoDXrC2Z/mkmJRzX50=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774205204; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=YQm1d556B3o+NaQlArCokCh5J8Tddej2YfKHsXWYfh0=; 
	b=JwTiG/l88lM/FDXmHT8xDtTzxsBCUPCMOYX0Ibn1cWBDQL8foSjmEx48H3Nga/fbRRFc/MEaKOlE9vV5WC7ovjPzRtH1ZDsi27xi0s41UnzU9dBzTYaZqNoR4DdNOjw7H71ginb+1RtH88do25Lv8ib9PxKn6OZje2bm73jtiMM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774205204;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=YQm1d556B3o+NaQlArCokCh5J8Tddej2YfKHsXWYfh0=;
	b=Fm9olenFTvPJn4JqOUXMkYAuFW74wBtmXrBLDbQ6iunfj/83UacmwfDlxVc8RZgT
	aANrejF0QQe3921T8CinmK5DtAAPsT4tlQqUz0dR9z2HCzfh9f9x8urjx5PnBUpZhfJ
	jMPx/Am5+pR9AFKhItniIr171o9yE1XiULyxDB9E=
Received: by mx.zoho.eu with SMTPS id 1774205202996255.6842497561811;
	Sun, 22 Mar 2026 19:46:42 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm/damon/core: performance optimizations for kdamond hot path
Date: Sun, 22 Mar 2026 18:46:39 +0000
Message-Id: <20260322184641.251966-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: F0EC6180007
X-Rspamd-Server: rspam08
X-Stat-Signature: rcanagnsx9yktcybw8fmd9ypwipk91a3
X-HE-Tag: 1774205228-398398
X-HE-Meta: U2FsdGVkX1/e1ZL+uzyZu5buF0CZYSfsIo63YQUPKLQzsCr1JJa+0RnwEjpHgelQpw3wyXhIj+JY2or0blMBJXpZLmwGs6yXhHdU7qMGQOioCPgFF+8jttxQMPXIpCAgM4o4rZ0Ki+6JBOq4W5eA03Ufks1LqfZaSzqpF03YDIRr5bLfIgOmodNEr6MvPWaEhDNE/gGnTFmn+3mjnzWUXaJTOB1oTfxKLfWgcdWiGNOy/bl4PB/3YiJBLFHVfe805aRpV6QDUr74vHta9+1WzmJQbm+vg5gOshxJ1VyVkSutKFhii0cVlWVVxD3OcIdsJ7GN7Az9IG46yHxycGp6eWF87M/8HJh1i9Sxl9ZxXWABJrqqT99tXWqWi6Z/XYA6wfM3tc5bNYvQTR9oxnbKCQjUj2igmMwAipInr+AZ66IjGiQKBrXRbn+jBRB3jVNZZm4nVcBcxsLibLUMTY59Yv+SFkXNIhQ2z/lY8riA3Ii8gh3WMqEvl9EazG9/WEU8G4lXK4jJs7D3Rp2QoPXdfvnkYQiWiX3yy+cSBwz++SGw39QBQ/tepOCk8jt23Myr0L0oPgo65gidyfSNOnmh+ouCBlEZr37hwWC7SUYaM9RJ5obSRwYzE8gGY7yagEiPyshJqwz6XS9MswNM+8IKw81kE2GBDTcNzlDxNMul9HmQu6OCDAZC6yUyJM6sErtK6Y7zjq+gumNzqDtC5hj98zb3qkvGcKldgGzWpevQVkVpw+bhxkw2lUCwkpxucpSgzxG+5EMzuwF4rLsUi78lbetHRVi3eUFuosS88E4bbqVvKkszrARPgcPhnVjgtdV5izLQi8KvBLJMEYws8uCzOoXYj2B1k8eExrRzjO3q42fTabuFiH8qUQ4WDTbw+gqYjaytR0YWqmyoE6nTT/UeJr7WKvDFuNGMCJsr3XNsmIfcdO5w1ZbS5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series provides two performance optimizations for the DAMON
core, focusing on reducing unnecessary iterations and eliminating
expensive hardware integer divisions in the hot paths.

The first patch inverts the nested loops in kdamond_apply_schemes().
Previously, it iterated over all regions and then all schemes for each
region. By iterating over schemes on the outside, we can evaluate
scheme-level invariants (like activation status and quotas) once per
scheme and bypass the O(Regions) walk entirely when a scheme is inactive
or has fulfilled its quota.

The second patch eliminates a hardware integer division in
damon_max_nr_accesses(), which is called for every region during every
sample interval. It replaces the division with a read from a cached
field.

Together, these changes significantly reduce the CPU overhead of DAMON,
especially when monitoring large numbers of regions or using many
DAMOS schemes.

Josh Law (2):
  mm/damon/core: optimize kdamond_apply_schemes() by inverting scheme
    and region loops
  mm/damon/core: eliminate hot-path integer division in
    damon_max_nr_accesses()

 include/linux/damon.h |  3 +-
 mm/damon/core.c       | 72 ++++++++++++++++++-------------------------
 2 files changed, 31 insertions(+), 44 deletions(-)

-- 
2.34.1

