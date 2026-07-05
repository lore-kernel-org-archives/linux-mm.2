Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF45C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C0B6B00B2; Sun,  5 Jul 2026 12:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873316B00B3; Sun,  5 Jul 2026 12:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C61C6B00B4; Sun,  5 Jul 2026 12:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 429246B00B2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE68516713A
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:55 +0000 (UTC)
X-FDA: 84955188990.01.DF22AA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 31244100014
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJnISSxk;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM2Eb2ExS7GI1ym8vhWA/m10zp74Amrd4zSKSC4zHiE=;
	b=zV7KnnzVRMVY1dfhtc+/cSAsYusFwgNW7PiNS6woPhAMJAHMYuYE4hpIqaUdTTXHVvZkc5
	xy9iUIBfMUcoAfWCuJ0ZxhMxDLkPrgEzvxbxrhkRrgGmNKei+J48KKBCPviwSW7mI6OnOW
	YaJc011j9pZzTTOB4lQS/PllGMuOkow=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJnISSxk;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267314;
	b=CK15wM8A4Iq+xrfDxi4k9EeUZJwgS0bq5pDYGbAmrPhSEhBkMeKBNGs8Fpo7nVttpzRgGw
	FGC+7baH5wUD7KH2tH5zeSzKiqTHtz2yF5giyUXDopmTyYWJfL3HNOdN4N/RdaZN6vsR3o
	dk2zW0E304mElJvjF3sVv81F7KbUWaE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C606437F0;
	Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD5C1F00A3E;
	Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267313;
	bh=iM2Eb2ExS7GI1ym8vhWA/m10zp74Amrd4zSKSC4zHiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJnISSxkkJUzL4ggSYDFJhQIFv0Z32F4ZOl0DDmnFxH4QsbgjxHoqbL2ds3NMBJaz
	 0Vr0Z5z40ckxtJCUW7Smftjol20RmwFJKSxqBOkhEQinU9yabVVVEU8bJlCT1WBtgz
	 hjQzUfvuyZKA2a0OeDMlbiv6Bql6E+DfPgHuTb4JhyDS+Jamk71ZiSfjJ1AWz0r585
	 1OyKPBrp+UwYqsQfWijfN3bq+w55tHPsd71mh/+e4nPbs6iBycY0Mzrm0j5vhSuVJX
	 7kdfg2OM/yt4ewIYs4EpNtOUaB7/cFkk3AkPBl+8WciDRScYkjTXdoAtW5KagLSd8M
	 0OHTULEOutL1A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 04/11] mm/damon/sysfs: ignore damon_stop() return value
Date: Sun,  5 Jul 2026 09:01:31 -0700
Message-ID: <20260705160142.97308-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 31244100014
X-Stat-Signature: s7dj4s8e6h1if7hfw7p6zu7kye4b86yr
X-HE-Tag: 1783267314-457072
X-HE-Meta: U2FsdGVkX1+dzGyg9e8qtLxKoel5fskZkoUn2VP+TS3lPeGwa+0Cqees4qV4zl5jU1diYs/GUpj1EM8a8jmfkI1A1a3qsGTS9G20MzYildbUGPljrMFxx9Tin1kKJB8olQov87coosw6e5jPxpGl9l+BCujahhjWYGvsgT/XYu7wlOjGpvUauYkybkVq0FQoxAm5ovKlVSigo0n91ycmiR1y5GLQZsTThKkc3NrNiuWjhm+JvjaNA+qglvRgZ9+DO9g0Nd9jgUBW5DEXgsNBmEYu3tEOrcuPwz/UrHAZOngJU6iev53Y3tOO6dZnNpwbj9whfwxAvUZUSeLt4F7PBsGvDvEBkErHOtuDQrFpBtAWLlmgsmJpGIKU8dcGtili0sTIt81eUsbGPmamF7PVVYYUOxtuQ4yc7rkxkHZE5qyz6okeCZWKxBZBhYRfMr/w2R8yGVHupeat0EBpOvthLq2ylZKHc0KqKPyqDES0EAIZph4TDfE85ICVERgE2e7krUs7lw+774yIsPKBvEx00x1gvm2UcLTvkfvOOlTnJ5LFlD1GwjskF57vtl+GTGEPFJ0zJ/yUusaTi/6UgCXLTUH3kiWHuHg2lUiDwYuv/2X5dCXjC883fA4WAcbaPEZrJz21qqEvQfe9vUPFwwfw9NaVkx6Ea1n0ixe12E+mv8DOdedh17+nfUvr3MWJpKxXtgzwxKMUOZtzwprEP/PO8CSi0BUu1C6FB+eVdhuXpS6P0sUA7UYEvjsuioarm2dt5F5QCZBEPaom/maJjrRBDEYdvQ9L9bPD0notevCnMou1iS6qLgkaehIjUuTY7MOG9cLg5+t5UF/5YbEy8j2me8faxSA/VDMA4IobTuvetjf/PM5OeeTh69ta+4VNpjMdKYqDuM3mS6Pw55NEaob8KAZktR74fNcHQejSE4kgcsETBoflLSddBPejEWgrdpmMxS0jTH45q+xBNyNiqZ2
 jTINJCE9
 wXeeSkT9IUZSv3+eBJoYoVoUtlCIviKJFsdf3lG4WiHC/jXF75D1xB3dsLiPxLinV8nlbjd8Pe695d6xIsJlt16O4WJtn1kRQogU2fxPeXYy8zlbGsH1pSy2nzn8MKvuzcyFFVlAETOB0cMSupzc9QFZpe11jGCNawuWFxWrYYcqk7A4axvJ6JqmgsMWtTq9b2ziSya+OzeaR2Gz/Nx4U6c4fkfE8236YhTMlOeJ+jI3NsFzmHHEKtRldAU8CvwaQ2WByXiflGYw8GCVU1+FgYreDqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() return value is guaranteed to be 0.  Ignore it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b65651498e0d1..6d7e36c9e509d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2262,12 +2262,13 @@ static int damon_sysfs_turn_damon_off(struct damon_sysfs_kdamond *kdamond)
 {
 	if (!kdamond->damon_ctx)
 		return -EINVAL;
-	return damon_stop(&kdamond->damon_ctx, 1);
+	damon_stop(&kdamond->damon_ctx, 1);
 	/*
 	 * To allow users show final monitoring results of already turned-off
 	 * DAMON, we free kdamond->damon_ctx in next
 	 * damon_sysfs_turn_damon_on(), or kdamonds_nr_store()
 	 */
+	return 0;
 }
 
 static int damon_sysfs_damon_call(int (*fn)(void *data),
-- 
2.47.3

