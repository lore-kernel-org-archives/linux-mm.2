Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24EF4D58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C90E6B0089; Sun, 22 Mar 2026 17:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C02B6B008C; Sun, 22 Mar 2026 17:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF286B008A; Sun, 22 Mar 2026 17:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3EE6B0088
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:43:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BFFBC2C5A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:43:41 +0000 (UTC)
X-FDA: 84575026242.27.C5D8463
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id 312B2180002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:43:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=UEoD6V83;
	spf=pass (imf16.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHfw9ceLzpOOGcaWO7lr+z8Bam/Q09h2DMbLR9bZIdo=;
	b=QDu98WsYlkUeaTMrh+b8yUUiXpbLhkfWsK6RXByFbeRbDqgcf86n6SlAobgh04ZK7euqSR
	qZzgerj0MjZv8Dqnhguy97abcC42Xa7joZkBoilIfaa1h8fPwJdvpwa2aVqeBukeOL3RRE
	vvTHnkTYEqaqfbEQeMNw14jHWRrUdSo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=UEoD6V83;
	spf=pass (imf16.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774215819; a=rsa-sha256;
	cv=pass;
	b=bye8dxPMtXj9JZGgyJhuvUBnnMr90QZFqPgEsVbWg7XZuvFBmJcLN9HgCCbHxUfXbzEGCc
	es2RtATfR7TEDsAhcaZ8zJZQ+eY6nyXCvnR3Ytag6n3Et3IBAK0gt1y/Sn871H7RXxl90d
	+X5GiGHIt5USS0HkeWBFK9o7OKUtkYs=
ARC-Seal: i=1; a=rsa-sha256; t=1774215808; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=g3djrmfnwM1wF8ILuforzESC0t4OfSCDibNFkxXY2tfjFH++eO7eHvDlHZ37y5FKogGTpwrhCxXy1rGayGGuXr/hx9PC/BsOaCr4Ed7Jwx6HUWwKQ49i1btEuRq0QA0dckLEyfZDmNC+6CoPwiWFK7HRrnz6246w4334Dj20CdA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774215808; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=RHfw9ceLzpOOGcaWO7lr+z8Bam/Q09h2DMbLR9bZIdo=; 
	b=XeWScmsA3lkdXBw/5yIV1tK/7QjSkvmrKnb7He+G7gcY2vZDAPa/5E4kuQewtBUXueJp+YKL5/KtL9H8OvgGp00Zva1vwP+MpwZDR8lUSwXYtJumHU+30wNLACSsNDGaf2HH/DR1ejCd3UHkDix+TTOnt++vz2J1qZ000Vqexi0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774215808;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=RHfw9ceLzpOOGcaWO7lr+z8Bam/Q09h2DMbLR9bZIdo=;
	b=UEoD6V83DTDz4mAiQ55yDxvgqpYmJC/+dqaSeZ9toRmtIGmBrJOc7Mu+RuB4Yrlh
	O1cDI8exUSlsCY5TVwaoPh4SHzkuq/2bnCPjyHdt02aPnSWeWa5RQ2DNtngwwgbrLhW
	f8CMBhoJxrNkcnrgPxMuTJr+tGvLpmbgPgXREwjs=
Received: by mx.zoho.eu with SMTPS id 1774215806856109.11691678942373;
	Sun, 22 Mar 2026 22:43:26 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v3 2/2] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Sun, 22 Mar 2026 21:43:25 +0000
Message-Id: <20260322214325.260007-3-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260322214325.260007-1-objecting@objecting.org>
References: <20260322214325.260007-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 312B2180002
X-Stat-Signature: kpm4g1uzknhha5sows44b9ucemaeimtn
X-Rspam-User: 
X-HE-Tag: 1774215818-496650
X-HE-Meta: U2FsdGVkX1+iC8TbW3Tg4ropn5kCuzQIwPBRwpEFI+/H0jtOk0/VPTWQa0pYO/5ZQW/WXIPI3ANM8iLICyAaeUp59WEhMqTz4gwfKzlYycOXrMNK0ul13plwk4RMFemj77pIKYAjC55ofVWKHE62INEAU/SnjqnTHE6mP9RpA15oBtGL3ZEBQql1k5Q3OqJX1+ofI07J9WVwpNYtN9wXE6Ylsh4a/ysaGpO7VdBQIjW0yJoRDoOoQ5VqonV+PdD/eEZ0qjVWRIzzPErcNLB7YfSOKpsy4xmM5jkExTvj4fwyyZfB6UECCso2rX0wLJ3sB/yBy3wGKWFQKPEx/fgQvLkTmBwwwS78kPTK5HyTfzgyAZeK1k/a9svw53Wfak0yh3BcaGvGuhjT/c1G+QK08SOMXpKj4o28PTt8JkLGvDOx+6heSM6bc8yDka5bCWOIrCuwAM7qM/KT4eKI3wUjJt9ILWnRcnYCNEXWxC0Al7DvoBkq2wke8ougCziwUkzThNnUk3X0p8+qGRWT/d+DG9Nm8Rqnz95z0pRlOWoyh/d6DMAZq3QXxe1qLaMRR2T/aIf0XsQdLu0SIaVN+Sk8hTqop+pCjiNqAWSAvX6owU28gMrwYTQzBIwF22nhtYBte73H5hFbDaS9NfoFCJz1Ug9cl8Hjp91yuGJ540Z2MgFLaeqAQGIAGBwJwJqAHsTkBOAjm9AfbaL+y0d8aiz2My2AXkDfpG/YD2h8mdtyXi4IFO7vi8pMeVbAlmieow2X7neYCzfbVfgYy6AMkD+L7kf6FzvQK5pI+B5c6eFYGQO50T3MWm9UUmK+JGmoWE09i+Z7NiP5q4TBFMQmGarHwS6PXLSfXXvX9yYtEVhakZsURtoQA7Dm7lu2ZqTKTHR02ecA/JV/kfWVL7yqMhdYTXncmb9FGGK7XvrRkbjkI+uVTiRG7ibCBYA/mkes9Ns6f6eKE3LVl7lUYtK9YIL
 swojhzYo
 fbyAig8JlfUVYGxCoSalaeB94cpQWNKzFAW7aRHQQ6n8Lhmz6Ssz8CUYzwoTBuw4C9NYwl6jzPt1ZxMHlJmgcP8vtu9ttA0kdggU7Dyx4kuNXyXk29orH4Wb3hljkyODGQqFtOKOTCoI83I81vADSV1OoOYD7KurBdmUEZmEQQvYHsdjj1/zIvQ2LNMrUjd+0qJX+9niv7gNO/6U6kiBCJmxKvfgeYseeGBBd/llYqljT5Z0smYqkD9ee3R0fV6EDtN0hZq36zMYoMq8+hC2OZUAPDPRjGt7gUUMrOyEi/yrB5kM5Y5EydmyMJQV2p38ok00e7H1FcP+vXJgg0QClUcK+CozVMYxVnh9+kUjxk8Xpona36O7wlJRWVLLKaNYt66RLbDf+pJPSiv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware integer division is slow. The function damon_max_nr_accesses(),
which is called very frequently (e.g., once per region per sample
interval inside damon_update_region_access_rate), performs an integer
division: attrs->aggr_interval / attrs->sample_interval.

However, the struct damon_attrs already caches this exact ratio in the
internal field aggr_samples (since earlier commits). We can eliminate
the hardware division in the hot path by simply returning aggr_samples.

This significantly reduces the CPU cycle overhead of updating the access
rates for thousands of regions.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 include/linux/damon.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6bd71546f7b2..438fe6f3eab4 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -960,8 +960,7 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
 	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
-			(unsigned long)UINT_MAX);
+	return min_t(unsigned long, attrs->aggr_samples, UINT_MAX);
 }
 
 
-- 
2.34.1


