Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3F9C61DD7
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD066B0092; Sat, 29 Aug 2026 03:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D736B0095; Sat, 29 Aug 2026 03:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293526B0096; Sat, 29 Aug 2026 03:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00AE56B0092
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:42:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7930DC033C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:42:25 +0000 (UTC)
X-FDA: 85153514250.27.94C96A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id ED48640003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:42:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdOdwJ4L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2pnQ2VYIoa3WiugIYl7Jp3rxV5b0Mqm4HU5w5Xg4uo=;
	b=ST8DAobR7PK4f8E1pm1xtH6987g0gl7+fp/Dt+EoW1yANE2I2A00TkIdodwJWIFbOOUY3f
	jOBCTsCSQTXA1ad7/yZLaV1qBMP2J8mfdNInZnUxQFKPzzqhkhy2gf3z8QYP45Z3QuWI2v
	r4dkMIwPmcHBfh+sK0qrlpo56yEUKTU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989344;
	b=wVkXLd1UjFHUkKFOpdd2jVrwHpznrUgBKEnCIcUaevDuHhvdYOAXkXhenr8qPoHPtZBRy+
	Pw5YbBQbdNgQF0gH/ispGy4OteVxnVzBCXBYV97ofvSfNK7t/pFQKT9oow8yfH63Kxspxq
	Go8oNkK1d6YYcwYujBNzDgOKWCe+4I8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdOdwJ4L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E1C960055;
	Sat, 29 Aug 2026 07:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66ACF1F000E9;
	Sat, 29 Aug 2026 07:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787989342;
	bh=E2pnQ2VYIoa3WiugIYl7Jp3rxV5b0Mqm4HU5w5Xg4uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdOdwJ4L1EiMt94CheIbvvTHNp40JARJbaPYbLKdR8O16tMBHur/IaGOamJRA1IQr
	 Anbh5gB1YSRpAMeAGR8+BdMgXvvym5h8Lnc0DZCccOelPrSrVAjfkU4KCbhEEO1E62
	 LcLQ9GpnPEEJ0qAHuSwPowzHwy3hiIpHyaUM4JQAHUjcLWj9n2OPKES+hXvVwdgz8Q
	 BN4XJyxv9v69l7FveED4v8uH6UAAYTEyDzCs751U8H8gWGYHo+U+3M/83eC98MQKTH
	 ngSNvLH6KEqw7Ksl0hQ4DSnRAE1SDyWGY9sclcESg50ZZf7IJDzUJdGBQfOvT9ecHj
	 t7ohmgZveEDQg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 2/2] mm/mglru: make retry logic explicit in isolate_folios()
Date: Sat, 29 Aug 2026 15:42:04 +0800
Message-Id: <20260829074204.45304-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260829074204.45304-1-baohua@kernel.org>
References: <20260829074204.45304-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED48640003
X-Stat-Signature: 53mqpx1n3nfyj3xen543ayfwsw5uw3gi
X-Rspam-User: 
X-HE-Tag: 1787989343-515578
X-HE-Meta: U2FsdGVkX198+naM+ORJnBX7oZW8JW247cDBDi04AvMysOBSVHQoZADNkusa4AE/93uNJwFOSslLbSaKt2ysEuBLTalbwqK8Lz7gc0to8Ze2MHvTp1qfQM/UGrKlUG6erO5RUqmb2Fq3RVOlJKTQ8fWOsR4xy7nCyhN/g/hnnZJND/vl6Djf7bDYdqgrOOxEKQ0B4cpx30CTYGFwlKmXmYPQQqVScjXkk5mGXBY++zKS8HAwRQzBrXbghHhVzOuyRL6zRg09FXOAYKC8KneW1nqff1E1zGwJYQMbXJMlx9V5whb/c5marGT/Iiev0d3n4q1ou4dpCzbap6XuHkjTUExoIjz456npOqlDUKC+NdsVoIkN5Kc+T0EzpABZZRe1bpcPexWdqEW8M8cHj1zl1XwMYxiPEqi0FbF+9wMv95ksovvYafBrSf6XyIgMtGUk2kHvnB7R6nDgpsyW5byzecAy4XMXmjuXn3Yq8eXRyq7oAU/k4oYd1D7NcAnEZaBKckBzJbhHIUkRAecUgotsyov4+7jNFg3mSwIXUR9k3WZz9ICeImIY0rJJDeNUmSAF7ddhCMDvKubIO2sHjsheBz1XtFeVXms+v31IVVD4/3+YZsp93szgi5NqaeDLP58VdKpSIkGgB6ob4z5lBc8XBTibxH1nbYaiPDA9AaljuHr62uJ33U1XHDkgW3W1fbDFLAkYE1t8xudR7p0dvKrm3U+BkLs2QTJUV/sKeZbu8uN64L+zPngW3VE+BJXtMtSaHFzKTAyPTCBNgingdx5IDRgSjX3rAmsWRx5yyTm92SVXvCUY2wVVYcHr3hDlIykmuwkzDu2qLBgyo4wHZ/Rd32dpcq1b3d4rft2G49ugorB7Mto09whfS70FHhGNSi9Wiq9tG4sOTpL6YZTvlIjPagwhZcyNGP8QjtxZHnYXjrqlBV9sIHdzYTqyv5sAFf8Os5NC9daVcaEgvQL3igu
 +hUh2G5A
 jRKNecH+ibLiEH216l5oFo8JYITOaqRRuFHpp3SoJDn+qFs93C7y7O86zoae1w2yiXxjDRCTrb8nJVfmNuvNOEvqwPOKufxu/IBV1l1FwYPZQafRxAU/3Pa0NWxScsyW53+KvpU04D2lzKoERdrtU8cJ4thNTA+WIqmmzOMvdqKRdqkuzQwvg41miMov8mwJWOfuEN8FgyuNhrGiM+CwiFzStf0Plx9XFjHEScAqF+x9LweoC4lnpZW9nOgF263aNau1Egrsyj5o03uXC6iITpKqHxaZ5+B1X+6Pr2gLTK3RuSyP9v0ZWqKat/h7un29WDVoFgGDxOTrSj7mnozc9APVt4NU2+J0rs5QW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing mainline code retries the same type once in a rather
subtle way. `for_each_evictable_type()` may provide one more iteration,
allowing the same type to be retried if we scanned some folios but
failed to isolate any due to protections, promotions, or races. This
patch makes the retry behavior explicit.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35a233623368..718f59ffc688 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4852,6 +4852,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
 	int total_scanned = 0, scanned, tier;
+	bool tried = false;
 
 retry:
 	tier = get_tier_idx(lruvec, type);
@@ -4871,9 +4872,18 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 */
 	if (!scanned && type_fallback_allowed) {
 		type = !type;
+		tried = true;
 		type_fallback_allowed = false;
 		goto retry;
 	}
+	/*
+	 * We scanned some folios but failed to isolate any due to promotions,
+	 * protections, or races. Retry once to avoid a larger loop.
+	 */
+	if (scanned && !tried) {
+		tried = true;
+		goto retry;
+	}
 
 	return total_scanned;
 }
-- 
2.34.1


