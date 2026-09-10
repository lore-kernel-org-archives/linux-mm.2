Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1528C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468C06B00A5; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A076B00A6; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30AC56B00A9; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04C006B00A5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:09:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70FC41A03FE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:27 +0000 (UTC)
X-FDA: 85196523174.12.5836DA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C99BD1C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIhR1Thg;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013365;
	b=HjCaK+miPZ5Smzcuv/l/RB9nkMUrcc6kodaVRim0SULqhs123JjEwZAUtE0TTTNNBnYlno
	RzszM/W/s9ywfg23P1jU3epjvf4XFzBP5nFR7ytEU2OiE+Bdi8/wPy+2DLfKELs8WND1cj
	PECN4VyhR6hXr4+HbjHJydSCMSnYm9c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIhR1Thg;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ujxj5yZhRYtIbo6ExzhErsIpeWFwIc8YKBiGwvcIFOs=;
	b=ErmGQ602LaFHDmeaJxEyj7ytAQbB94YAnTduY63I2kjph0k1YWX9MZVqRl8MM+qztugQFN
	lf8kkeIk3ya1f+57b2pl6OK+jIfAN3dw4jGVJrE9wYzwU61AEJO6or99Hx5b8Q1V3rzGr5
	M4tm/2j1OsfV7TCJgh7YeptscCcNlgw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28CC3436E4;
	Thu, 10 Sep 2026 04:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C8A1F00898;
	Thu, 10 Sep 2026 04:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013365;
	bh=Ujxj5yZhRYtIbo6ExzhErsIpeWFwIc8YKBiGwvcIFOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIhR1Thgx9vaGfgneXncEsrPex/rTuCb4Dcvr/ZFIG/8ScICVZcFNGt1stg4m+OH3
	 o07rKZIBUo5URg09BH/D7ka/GUT6UICRItjHfzITK+I8cSkimROsi/x4Y1NXu7ugrj
	 wZmTD+k3lU29mwYBaDGN+ZNyu9RKTjYWY1GeqvgUGqIFUpGcBDUgDUzFVqowoXce+R
	 YipQKJAf+dSOIO7SS1JXQnyZ2AUlAsfbnTzkCFxO363F8NQlBDZMQeWhYL63LHAvYv
	 lPbK3JyuWJpBELAItLs/NJfGfE80vn2fKXY8MxXnGpqivVT+1O2XMZgNjdmjZzgvNQ
	 egd0mE3TLpWSA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/5] mm/damon/paddr: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Wed,  9 Sep 2026 21:09:04 -0700
Message-ID: <20260910040911.148273-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040911.148273-1-sj@kernel.org>
References: <20260910040911.148273-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C99BD1C0002
X-Rspam-User: 
X-Stat-Signature: rcwsh8rtkyw3anmxk1z5yt7g3icetscr
X-HE-Tag: 1789013365-217890
X-HE-Meta: U2FsdGVkX1/Hb2cIGXRqm2cDcTCZ55Eabdov4GXId/gIFQu78iOzakRxU6GOvJckenorTefm7q4N81HDFpdzsG+McbuV5moF3GpmAawJw9g/CpQXEi/kygu+MfXWkoWc1BGbgG93ixDBTiO5hYGzHgwgjUQDUSS/cL/8U0Ls/5MgqmsM4eOj36PQyQJosvIUBtXZGG5fGVHF8p/Cd39SlHD3XyC8ghtKTkTAH9YQpx7m/m3AcHI69gMoOI3Spp/GSlpufusTXm6hrywbWslReAAl5S8oLfLpUSLyYFvyufRNeTHUqEFwq849PNfAAMhs4muAdt+vWkTWheDK5Jh0e4ddK6mzgPtubbOxYBXHcgzRNei82S7xvwHTRzSu1o6JRi22aQ9wR/xnU5Ork9Ao0OS9r6DCSz59qIDJOPYP1X2Vh6t+VNHHGCgfprx1EyXFL3MDmqwF1KXuSAoLgfMjq09xjVZG4utrA038CTxLRWsUiPfT6nXgh01EPv/Q14pcoXcikGN3uR/5c2NWngwl0t1xAs8NUQ3Vqal6yH3kwC0OsAOKe29eUVbJqiVv6D+y8JuUTFH/oHzXZS8aUbiNpXckJJ1/fl8CiMSsv8l8y/EyGX0o5bYm52vvkFRNu6kRnCkZ9FNeVamSXzJnqogTdHRLjiKTn58vdfRi6hg6q0MMp1lUMmj6pgkAPLvzU7rQq5T7epUOEKAj+GoWhHKq1Ag4dW7WcB1f2UjKsErUxWr9JMp2H2WWU6QANGm9XRldBu4wHMzgrUHzcTwFMhjjz3cfLjr6I70BYdOkWS1kWGQHIbzv5dmkjPM73YIyt0KRm41PLefcuLdEwYboUtt2BX4mKxUJfUSwOq+IB/REyABCdtCu/hQoP0sJqUGvTc3y9EnVrv7xHfEqAfcpi2V22Uptfjm9JsrMf5SsS1TkbOy+NuO7ORRxNoynCB5T7TS3RUlvcd2Uq06BbtDGwTT
 RsnEVDxi
 U1zqtIyHT8K2QNrsltdy+FdnUUHNR5BhosaYgyZCJiYyAEYHiHz67f97CirLnckFRfwczdh+0u/7XEId73/hHk2tvoUcJu/19/1zq980P91NckHoiI/etm/M0/5ZDMpJbt+6Kcouec+QmyDYXHtcFbbpKsxpXdnfAXXgnr42GSTjP3bchwSwzsSG784rl4ccdFLQuMy1F0VU34fFpHNr7ym/Gr7d9stc5LHWWuqv+UJSk9c3mvoeEyfrhfP17MLERBpsyFjpfZv6ztpPrS8gaTgoj7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement DAMON_FILTER_TYPE_PGIDLE_SET support on the physical address
space DAMON operation set (paddr).

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b8f4d28165dd7..5abfabaa339e0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -151,6 +151,12 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		else
 			matched = damon_folio_young(folio);
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_SET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio) == false;
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
-- 
2.47.3

