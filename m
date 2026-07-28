Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA641C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759596B0095; Tue, 28 Jul 2026 00:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F826B0098; Tue, 28 Jul 2026 00:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D05A6B0096; Tue, 28 Jul 2026 00:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38C2C6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95EED1202A3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
X-FDA: 85036864668.04.7C892CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 00EB11C0003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FMAV/yKg";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211973;
	b=DlxK9RctfpTmegksz7EArzFXDFgyhAzMBlASDZazwfPqve13OAcst3vd/B106JGn6Um0H8
	V0SCHfuT5Pj0wWddVAjgXv1ePyLk8kLRZlWavwlQWtidIqL5/zwPtvbz0aqZszka5gWKR7
	9X4UPnZAxmaLGOvECD5+5Qay0re84LA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FMAV/yKg";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZDCgXboPWDjpqLBgpT6yf0F7vtlbLEb3w3NI8ROd0U=;
	b=sSryNOjLvWhRwoWAApFWZjrc4/yjA+UxlR9nmUXW5P1iljlkENRAY3ySbGZCh8DPZz1Ept
	3DRjo1Ag3fepymcMhok5xqtftujmxNRmmRGv7dQBycSJ3cfbkhgtKumdTKLVRYOAzveVa+
	ENTtiRCxF3ZOunO1zdFY6nvXNzeoVuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41E8043D0A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00201F00A3D;
	Tue, 28 Jul 2026 04:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211972;
	bh=GZDCgXboPWDjpqLBgpT6yf0F7vtlbLEb3w3NI8ROd0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMAV/yKgSN6qOzUST3yzRCnZ/hBR94O9YoOjLb9OY2m97U5pFemsAZ7aePTN+vao7
	 OVIWV2Wu9dDUY+/Tmk51AhPS4tvW+mxqgsg9LUdpzZ3Q5JMGLwX4SrfX+wUm+WFJGO
	 JU+8p5+KN2KQ/OkGrQOiHQTw+BXdmemTMGi+20d8WapCs/hXbBxDn04TUJ/Z9s1Y77
	 cz4fi42x2gKUnPK7OtcPwREp6eI/b9hWM3CJMcK6fqKjBspFPkMZ4+pQMQY3+Eb/s5
	 M99uAZcjqg4X7b950Agv5XoxgQLRE5+8LwUdVQ8cmBwNxAZ8Co+AGZ+qW8237P6Yvx
	 m9ijx7QjM0Z+g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 01/17] mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
Date: Mon, 27 Jul 2026 21:12:22 -0700
Message-ID: <20260728041242.187380-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00EB11C0003
X-Stat-Signature: 61iey88hiu6b457cruomjjpw1drt4ah9
X-Rspam-User: 
X-HE-Tag: 1785211972-217090
X-HE-Meta: U2FsdGVkX1/AVQmouD3DQVW1R1xbyv3EzRmrUm2cMHpp/B6F/F5aU2JUYVqkb4pycTsP0kEMRbfqqGUKftB8J6zlAb2GI8eko58xwn0BXRHgAbTwQq1syyktFyuuopFqnR38k2rBCLlykUGjrA7De9euBLA3nu5M8P3K/YA5EPjzcRsHkEQf35QwZOCXgr4jpXQ9ugMjLmpWYcTjnY3vlXJzpOipNaeXLJdGIbKvg8cEuxAEwtnVggic6vEo75ONfpK3scS7dXre8szZjxjJXOKqPD5k1Iv4g5S03rOdj1w7O9tcLfHmdFUHI+weUaH5ntl1SBpmEjAzXOdJuYwpzU758TJq7XWQwums/Mq6iX7RC49fz8Ij+Me347Bpw+5tI7uUh0VuMPVw9pZAcejOeil4QvaaR6X8EBK9p18fj5WwJ1/gn5QfX5Xyf/FeDZ4sRrLc245cZdeF6f69Q4Z7QfPMiDCbWnGMNa9CZ9dAcQgdK0/E5HQJvrsJKj0+mNrhRH7ISQMp91Hn7cvC7bJjuI2xlmN6zgn38UjEy5in2B428FAByI0FpbC91lcEH0cGyJ424XsTwTFHhQGE3oEWvnuCjmrhrwyxD3uUTzg8AvEzbpgzkaq5EJsKUFsLdyv6fx9mDuJHonmHIOU5JcbL0mIGpn3oPlnh/opMgAHUievA8Phy1tUCLMYusdrDspU4PoNvx4/jVfzos8AIRX03rP6pE2fwgxyzWU61l8P3Xh6YfeYC4eqAfuggoXGeV7grBsYlQS1Vc0Ugo5Jc9JGwSVxWb51o1ICAh/xlUvRhlLrsddeZYdQArDJG1/7Fl7EsuybeJIRNrvwVRaZYCXJbBXBG8Ozr7hbc2YNNYG/rMHS6J+Sh9KhMG8DB5v3w/xY4S7/JjUla8h7G6U2xAtNzG82cOM3641MBhqvSq2MXgKayvBERlQlZRKrEayfv5JhQAZFLQyIFYpSXPGZZQXf
 IpLoNi0E
 9MWECxRjMkJ2v5a+5xzxTCEyGw5j1P3LXj4aO57ZpYqWIcekMDi7eb/Gu2mexN3wC4K4WwM7NAdvl17Q4FfA6H/0+YhNrbDQKvwWiREn07woo+5DNsAnWfwz1sRkhgU48jYx9x4jr93RPl6zC2Ou+mKZ3+FksovwhT23CKVYVyGTKelUOEXaWnGIzEBao7ijvsSDEmrjQPDKH1a1z56RqRkLEJ80k3Ho/o4r6Y+X3qGqc9XrlukPywKlaHwW3os6ebQRZNRrrFSA3o4N8bI4j+a3JgB4MtUGJybmz8XsbWIKv0ShurLNFA+U+C/ZeqpRbdCeHKgUs1tZJ+rcieT/LtqUrXZgNEH4TZ+w2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON filter type, pgidle_unset.  It will match pages
that have their PG_Idle flag unset, or the page table accessed bit set.
In other words, it says if the page is accessed.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 8ad6ef2e063de..cee4b74761081 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -744,12 +744,14 @@ struct damon_intervals_goal {
 /**
  * enum damon_filter_type - Type of &struct damon_filter
  *
- * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
- * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
+	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 };
 
 /**
-- 
2.47.3

