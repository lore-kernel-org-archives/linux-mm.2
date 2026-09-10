Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09620C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5306B00B3; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C4E6B00AF; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A106B00B3; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF016B00B0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 687DB12051A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:44 +0000 (UTC)
X-FDA: 85198068648.20.BD95608
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C492318000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KrUOBzYO;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tn9W742GaDY7vW9qUrTT7oroxJHcL95g99YMTLAp8qQ=;
	b=looRBxAJYnuyBQYHfVXzWYs+Hz8myvlN6zLxp8i4QrKL/zZ6TApy3EteRQmdYH6ROWwDBq
	vwAuilFsy6kwBAGpqz2//qlqEGJWbJzgHFcpqj/IhP8AoR+QuFIazAZSQvzDrzRxU5goAf
	X/Zfel9bxu3lE3AnW9ZFsfnQGWDNwBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050162;
	b=bpkqxsG8TH2L8FAsJpTJUWr/bRA3rGcuxYzym+P94rLzeFFvHN2qfiTIw4aQBf6bn35/zr
	Qq9SN83a3xtB124U9nLYbnrYIuQ2v9OhITxfP3OJ39pEkW2lCaPnmsxwP+UvhxAmwLF5Ok
	kJyJ9HptNzRZtMqesvVJNujHg4k/yNA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KrUOBzYO;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70D8760209;
	Thu, 10 Sep 2026 14:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04D41F0089A;
	Thu, 10 Sep 2026 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050162;
	bh=tn9W742GaDY7vW9qUrTT7oroxJHcL95g99YMTLAp8qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrUOBzYOGFLH3xJVEyEG5PEb85RdtuCu6bBryCLW51DkVrE4i4pqJ7rj26EpP3PQj
	 vV1IVF/1joJqJUaE9uCuMAzM/3BaftvFPSMIyNmXn9v9KQp63n6nVHJY7zrvSOGxwD
	 fKxQr810Qd7XMCYrUifJGvbjUxX5xC5HMWEmuasxVjfOpUD23ClBHvGuQmeZIHmcHi
	 8NcCsobkCyGd3P/Zw0DfdmJP3pXeWQNnjRugfM6wJhJ9kCTiZmR50opX3OHlMYUXuL
	 bIQcYZPyr4Srrg1NXVGVugkMIdAAY5F7H/H3XkBQOkLOpQgApXTAedW/34LpDsK0/m
	 CJEzr8GSX5F4A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/5] mm/damon/vaddr: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Thu, 10 Sep 2026 07:22:30 -0700
Message-ID: <20260910142234.171562-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910142234.171562-1-sj@kernel.org>
References: <20260910142234.171562-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbuiozkf6czj18ryg6knjjnmbfcydeix
X-Rspam-User: 
X-Rspamd-Queue-Id: C492318000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1789050162-880498
X-HE-Meta: U2FsdGVkX19AWc9BgTVn/u5AOIcnIIUpQAiE48zYkYx6RaLHd8RwXRoMtHVqcDQocl1ASnuWlyVznN48B3O9XAEDat6yTo9MIzl3Wnh7RSA5sXTFsUVozYOyzN4utwjxtqyekdbSlEA3+F2AP47KIfp9lvtz6IBC7e1NomS+NaLQqxtwvyGc8MJugEveB8SLpdvsJe4prTCcdCjhBFtIDqtYfXUIJwmMsp7TpNn4Q6MbLKWAKw7FU8U2EeP7EqpJF2tblQORHO5XkQRG6fFJ6FI4agkIWzrRldt9c0SPH1xwB4IaMMESU9yF6hxHRjqm49XwuD+ZnUfPJcVI/QH2ioQB4sfHZvzC4OWjjqmX/ko289ZXYZzJpwkoQoA7X6vQQhuJIy8tnTIrYxGNrhE65w6DURHzI9rD2KSLT5ct1ZtbBJJamBApsKaxpdIuCUVa4A2u58mS1vUPZB/iLgFwBL69LdrL+1pXWPqXg3rXAiSrZZQ1+1knVwRfgMNyJWoMufBgjMznXiOE0cumug6OXi2BxsE6Iacqrhge48rGHrtd8woPzUxtxFRRHB5ZtPY4tBhlOxbB9Uur2m322FAgIY6sZpL/jljk6lGpRdtSXhpgkUqNWsQtvewFpkANMKZqz8Xjt2orLCGyBs2Qht57/HJ2DgT19DXityIZCL0dj6tpQmPLdaivezls+0fvmNJoOP1EkpX3Y5gsf1+8Jfa5DB4fZPuWa3KiyUzE9ugxu7CqdlETPb4CGKbFfqQPXPwDm1EZjZMqW6MLm/ZKaLl3nTSKBFXdfAvwVEfQrrFLCYvd/m9qLDY848R6Jwg0UbkEpD2zImSTZRiUyG9otWCxl1VgXF0x6IYdXX2hgWE5r9FBEhxY1lELUyZaZSz+Lr8j3G27A9EJqk0FvNPrbp2tPskcwV+s9cjBFx5EqWwRuGhYjSHqtbnl9Qq69fFiYxbFE58X8VBO6xdilrsNKAf
 UlCXR25W
 2LjKDhsAsJA50fjWEh40ItSq0l0e89ueyftXiEeeudGr6okVgB7/rz3x5XLWCiU5UF7pFZeUFre642uCGJXsTBnyqqp9YAXbo2XQZl+6CZCNdcf2UHbauA3Cl+C8j2fZoIwSfLfAUjf0j5csecdAkCY++GldJriI6XRZ4gSWDQak6R69zlNim/oP7Th3yaorIBGM2kRM8f1bnmZWBUIy6ijaW29Ba2OEvdtkcI8iyCqqgZf7oZlKTO5Zj8isORLo+8d5QoXUPsERWwfhkYGxKs/wWkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement DAMON_FILTER_TYPE_PGIDLE_SET support on the virtual address
space DAMON operation set (vaddr).

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4aecf34e39be2..d5dde97b3cd0d 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -550,6 +550,13 @@ static bool damon_va_filter_match(struct damon_filter *filter,
 			matched = damon_va_young_addr(folio, pte, pmd, mm,
 					addr);
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_SET:
+		if (!folio)
+			matched = false;
+		else
+			matched = !damon_va_young_addr(folio, pte, pmd, mm,
+					addr);
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
-- 
2.47.3

