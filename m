Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16578C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671796B00A5; Thu,  9 Jul 2026 20:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A036B00A6; Thu,  9 Jul 2026 20:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537B36B00A7; Thu,  9 Jul 2026 20:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 156BF6B00A5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 853C61A0311
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:06 +0000 (UTC)
X-FDA: 84970969692.08.AC842CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id F0BA21C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHRWloZ4;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LCoQX0bHg1OYdjWEvzo4RN1ftxPbEZ5h4yD4yU742Y=;
	b=sG0biUfJDG1nTT02TOdUB/MWjqeMVS5kOygtTezww6GFr1/xJHyl2ARhFTri842dsEERxl
	BrBhdKuJAYYLtMHpnNY7j0UCdTJTbbXLbdX4A3mZjeq0tPmhm2aD7gRngFeXj/b8yqfHEB
	yZA5VHS9jzW0FpGgYR9DQDe90bmPL30=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643045;
	b=gj7XDeIk1zEvNP7dBnGSKS6DJNFlVDBYcdGVy51EbxetIioW+eZ5FzhMA4e0TYDUKuwpOg
	/VnLHg107emRlPxGUmtywyTOIt0xoPJZNzOL8gSRMRjlPcdzCvzYcGIDk9X9ROc28d30vj
	BTQOgduIyc57TgCVOPpKU3jCBstWGyU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHRWloZ4;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BAB454513A;
	Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2511F00A3D;
	Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643044;
	bh=8LCoQX0bHg1OYdjWEvzo4RN1ftxPbEZ5h4yD4yU742Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHRWloZ4uM94rK1QZVS2GzqB/SDuJOJaBqIX1pk+SGQ2TcO1+jVAT/OoBvjYqZXQ6
	 kbNuzs+Bop1g5M0Ax1bnWvWqdB6odFC7OcuqO37ZFhVfzdGm8Zxlm9qkGJTWY1A+40
	 TGdN8U20JMaZvPf4HpN8mqhBUdh8w/nurNCZIcSPKFtIT0ANXdMAVvWiwlj/ruby7+
	 SHEFp+LebUAbwqVK3uigNqvnMUBcY+B2L/MfNt7/ZhI2zHJlJaDOi6RfAfgHldR92s
	 eCG89ZzSaLMmf9ou9nDAD+Cooh7Q5NpvzQ9Tagux8qSNUV1IHIkAH2Knw9bw0HuHVn
	 OqMuhhYM+1Wdw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 17/19] Docs/mm/damon/design: document attrs-only monitoring
Date: Thu,  9 Jul 2026 17:23:43 -0700
Message-ID: <20260710002349.111414-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F0BA21C0002
X-Stat-Signature: 865i8xs57bjedxhwh79wspz3w16obsny
X-HE-Tag: 1783643044-402999
X-HE-Meta: U2FsdGVkX1/wr2vYqptEqigWHIVQoV7ql/R5u0Fa2+K++TzF7XZtAtL2PRrfvLLnQAb1Hvy6PrQbdNlMLP++2aqdDKZS/Q8LYYox0A3L87IRot5ChCfc/cgaW9i7AjhA7CRTYDVwiaoM/xxMkYtPGb3t0dcOFjf50YMRronCoQcQvYtqL+fBeX1QZt/nzDNTrZoDnX4blDG9DBMnremCEVdpN9+lJo05m0dCB8XtDifaAGpWKyL9uAD1onMLBEWaj8B+DJMoCnsR4DDGsU5kdE5pwg9bLnEiZbIB3NFzCkMTqvgxV/6a5mIbEQA8Eo6IoZ1m9HqbDx/frcYen/0RJV8P7cEibv0r/y/iO13ta+uY1GC5e1RuMsKRapKoX0CVZe2eRcb5RW3Ww6kUTEeM6E79g/WzHEEQseirPs5LK8znvaLPfbz8XAXc1y/Su9QvXCX4NLJJo4eUzpYB4ybFha+0G6xUr/hJIcWJkP/gD/B3z3WkySooXnxscJHImjTjfnjWWtesSmrcaN34TQuWdmhaIJtwpq9ovCKgB/hTq0KkgtQipadwDQtHeU2IEfvZFYZt7wn+gVC57a8qy1Rg2LWA+aVdKXS61b6yoGB8E4Ewgq+xvwLoc9+zbZBVmLHz77APm0KLIcCzYMmD5N16rbcI/Z2KZ5GZ7V4QuDFaV8HR0313kV0tTuJYloWjj6zZm0iVUufG7pdftglRBkDBxY4zUo9kOjG6ubJDChtglOnAfL+8Zs32y35V3r8Ms0yoS9i+/AnK9ywczvLNcOlBJ7I6/rAXTYRGwcTMzheuTBR6AcY1XYbpl41dlSq0hLlohdqA4jbLAwnBu6a8OCo/giT43vGyVW5fVsu/dDteobIh9kSzJkpXguJuu+L/ma5YxPnwoY4uT9IGiMQ3PqX4tDOeAGTa5OOYAGHiYsrq7mCixlfj26VFyaKK0VqT7qcwlR9pbHGqfVY2rsaXFN8
 9EBhHhDH
 XBOzgYui1p21/qdTbF2w0xkzP8TPpnHqEkVBLrxQAS4N7uQrrs+5/5DIZnA1SU619WrqnBEUS85kL9GLhCmEgD4ytfaE0txAB1NtWqgJUgWGJPqg0w9JXbOrzLKMy9XMHgiyoak3bPjK3nP6EmVC4aWy1U0SejRmkQwT+9nOpIdyQJ/oVHH+leqkicM4a7FEolyMO/F+60zzf5LmMHFey6kGRs7gZIVkB7IucsY5/2lJKM3DFNAGdQ4jzHHAOFH9oBxux3Xjceh79nLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the attributes only monitoring mode.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 457d6e8bc7878..6d79e7d69be84 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -316,6 +316,26 @@ Another way to do this for higher accuracy is using :ref:`DAMOS filter
 information in page level.  But, because it is operated in page level, the
 overhead is proportional to the size of the memory.
 
+Data Attributes-only Monitoring
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Data access is the primary monitoring information for DAMON.  Hence it
+:ref:`adjusts <damon_design_data_attrs_monitoring>` regions using the access
+:ref:`counter <damon_design_region_based_sampling>` (``nr_accesses``).  In some
+use cases, however, users may want some of :ref:`attributes
+<damon_design_data_attrs_monitoring>` to be the primary information.
+
+Data attributes-only monitoring mode supports this use case.  For the mode,
+each attribute probe has their priority weight value.  Users can describe by
+what combination of the attributes the primary information is decided, by
+setting the priority weight value.  If the total sum of the weights is not
+zero, the mode is enabled.  The regions adjustment mechanism uses the weighted
+sum of the :ref:`probe hit counts <damon_design_data_attrs_monitoring>` instead
+of ``nr_accesses`` in the case.  When the mode is enabled, access monitoring is
+automatically turned off.  The access counter (``nr_accesses``) will always be
+zero and not updated.  Hence the mode is called Data Attributes "only"
+monitoring.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

