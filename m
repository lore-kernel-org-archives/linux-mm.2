Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE709C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0CB6B0096; Tue, 28 Jul 2026 00:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C956B0098; Tue, 28 Jul 2026 00:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449686B0099; Tue, 28 Jul 2026 00:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 129266B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83971A0244
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
X-FDA: 85036864710.05.4F39842
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DEF21140002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxhTal6M;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFWrh4xOzIaVYjLemNkzYWoT3xqfoUiMT/45TgdX42g=;
	b=m2sN9dO8g1qMmOyMSx6awa8RjSFTqb2JxkJnVur0lOR23q/XhYSEnkJvU+ksNLbmS9wkgQ
	V+w19AE4D9VpEv60PFM78qiqMVXakTb+64mEqKdTklEMSG30soTsVrR5E6MPiMh7ILwTAs
	EZ2KbfcybIkjZ84nt+9roNFbjMVxnQ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211973;
	b=P0yURhLrXnOEvmBV6cNXQ6XI72zURiqREt/6A4+wKYOEBMgxsg5m34K/9RCMMs1Xwx/vmK
	a5DSyea/orA/l9Q9XUYpcc6EqxBiPmMtYomg7X6HANK8Slg4f5KdAg9yPo9FYo0rM/xYfZ
	ZZyCMtQXdmWBideBQTEADubfjOodFxY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxhTal6M;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE60543D9B;
	Tue, 28 Jul 2026 04:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FBC1F00A3E;
	Tue, 28 Jul 2026 04:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211972;
	bh=DFWrh4xOzIaVYjLemNkzYWoT3xqfoUiMT/45TgdX42g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxhTal6MMeichFrwfRBQOj4DGX3b2tJtM7yIdNaplDjfSdKvyAsHKLuHzvpPYwTj+
	 oA8F5F7gixVPOQcRoUQbHyAGqiHF81NQPIPEIGEY+89Rxt35Di5ygsmdz+s973n1dP
	 9YNz77glA2CgBHQT6OEgyX6x7U+hYEB1uu4zXzuXNOkbRpq3Ij/mDfwQaiuZng2FKB
	 rV6hCvqAL8zB4lLX6/MHEkKGfianI4hZbt1CmLIRWcuZmDNbe7thaO+Us/43D66HkN
	 eGQ5933sNTJedBbFTtas3GLA7VPyQwT3Px6fC2N31PsQqL1CCPeG/OSiuFmbTIxSpI
	 5G7gavndbOKPw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 03/17] mm/damon/sysfs: support pgidle_unset probe filter type
Date: Mon, 27 Jul 2026 21:12:24 -0700
Message-ID: <20260728041242.187380-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DEF21140002
X-Stat-Signature: z15z9bmmwi5wdqufwwep7qwmeig5cusw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785211973-415454
X-HE-Meta: U2FsdGVkX1/oqwXYUYzxIBaiINqHesB6pIRtK9cV+nbcQEtTakbqMsdCMYSwvFUHd42r8FsfxEuuruyVRJfKFTv6J55tMdCljFIwb1YinmA/D3yuOz6nW5DmpNhi/YJZPDBGrHf8vis+eMapSehAMKn5A4TR0gXtIkSusHQWz1I3FdnzoaO0XVGVXoW7IR8Jq7ijRKHiZxk8MNb9FAh7HmpcWkF0VnbjTrXT2xJlqGQMO4OcBPr9o1f/pKKUGqLulNdyUDIoV2BNMZAXQuX2Dolp2Fc7PQTvaTAnTURpi2Smkn8Ab1c1w/7iVbGJPwBbRKfsHx2GtYXSz/ItniGKKSn9xASwwR2LtHhgxmNRYchy3V9E5io778ZlyC4DVyNZBhEBewSiZ0Ump1tkhaViAmfcWXLp/40Rmkjyuq33QnKImih31brLg2Eq473yKGivY2plDUNsNYUutpBVG3G15ZN5tcsF3zYbB7dXPcg6HNl/w2zh9dscHHsn5SoMI7rfq47dVYjDveFaHaRzvzOMna2mJWoDQsIsGUN2sa/52wVDfR6C8Z6NXRF+NrrHDQ1lI/f1xmd2PBrE5T2SdbwEQEkV4jgv7JvaqwDN8hePUyubzdgZjY5g2IFvTa0q48Zcl+YHcxYJA+Cp/PXx3+n2X9o/q5FFzpf6Bu7izuCkYmqRck/UcOJbX8wHQQyDjyArz1WDK99OvSCzZWbsOS3R1K5+igXqNQAlWMCYvn/JwczLTT/Gob5S8egV6Gb0hMvv6PGi7vvZwazlvkLhNMmjYXvKgzKX+ipjXcnW9WnjYNuSSlhNQoDDNKEsmbXzkRJ4xDjNW+NJc7K3Rtf7DqbABfFSTbiYzLRrRFyT2tDwBp88r22FjIePBsk6TAN0hYxTs/Z+/PEcwCJGbWSEKwxDNQ4OGDjfOQ5cKWIHRwrIJgNgtcIjIb86gqN09khsHJwQhxGy902RBnEJBUgQlP/
 nU5zjLRr
 z/G24AYk6DsGd07UCWRLO9939+ZM7VmrWXD2Mq4KtqgElJsYdaSnSD4/r45yt+fj4RBN/iWbnyjFKe9MkGU8g1pslP+sWbrRnec2kA3AFFzWxQTAdg2ItQXHH0hlLnZsY3bkz97F4tu/I9qM/VPH0gbXKg7Zl2+VCLBcVhqTaS5MFnqJk/fde9h/LV+9wT2m8T61ZIp1mY54z3QNRdwTCZJLvysOR8YpA27FNpHa3UVzi/xQDKjD04TXZe5UOc+mwPEcllNJCw/fEHrBZ573hMoJMLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to allow users to set
DAMON_FILTER_TYPE_PGIDLE_UNSET by writing 'pgidle_unset' to the probe
filter type file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e3858ffab4b22..50ff1c172d746 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -782,6 +782,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_MEMCG,
 		.name = "memcg",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_PGIDLE_UNSET,
+		.name = "pgidle_unset",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

