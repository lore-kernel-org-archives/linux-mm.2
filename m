Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8007E606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2eZCaOa
Received: by kanga.kvack.org (Postfix)
	id F1B556B05BD; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1AB6B05BE; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA686B05BF; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5BE66B05BD
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3707716058A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
X-FDA: 85460344494.22.C6C701A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 842BF14000F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2eZCaOa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294825;
	b=Q3RHRxWzE61ZtreDVXhBNpA0KYrBQMo4szsh1QYxAAt60OhX5l5yWMZBfGebm7Zum5ndWC
	rY4jgyQ/2PICg3Pracb8NHJ5uthtAQzHocLhkOqzXVSmRRNBAOOEdSiaM6MPAwGEtRuKv+
	BoguoQOKnhGtOe1G7dErg5d8YEEpQ9g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpJsxUs5k/v5Q/BJmFbBidw7iSSRFrTJt5QonQhU+Vk=;
	b=nge7sX2kP+cvjPIAUbIOHqrb/Po1bxI/Q6m3N9MI51f6I+XlsooiOcUb/N59ufEC4Fjpq4
	F4kp0Mb+jlE4j33TPl6HnOrRiJnB/EXEX1bKRCAuA+sS6bqoPJslN6K19RsNdnZcK9iaMA
	TkwGMypGphIL+UxElE0UbC0O32D1IOY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2eZCaOa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 251B661CF5;
	Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB71D1F000CA;
	Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294825;
	bh=wpJsxUs5k/v5Q/BJmFbBidw7iSSRFrTJt5QonQhU+Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2eZCaOa2aKMd/CrmQXt/qgrdcuyJzM0P/hA2y8q8H2Q8EGdaVcKQwdJdSSXGaGBk
	 VFH2UeFQFh9lNY99t9n5BuByJ8YNrVzgrb6dvFYtK7CeT7ytYleSBj4Qvbr+ajC2yh
	 QX3h6IdTxg5PQJl6CoDvskpoez1hXthjlcIMAkdwv9lPss6RLhizttIBJZuvL3l4aG
	 F0CzqHihb75pbd+Ey0d1toKveTD4BdKSCVmfRCU1QJTwId/GxKu+1xHOKNqaUE+qxe
	 TMNjd680UYMuWsy2asKwNu5p/FU1iy7JPul0NUVS19PVqQn0q9ldrWxthzTh98yLv+
	 DagXLNwbadCtQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 11/27] Docs/ABI/damon: update for report producer sysfs files
Date: Sat, 21 Nov 2026 12:59:55 -0800
Message-ID: <20261121210013.130397-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 842BF14000F
X-Stat-Signature: 5yw9dz83tfpqun6igzg1efkuou1uw73k
X-HE-Tag: 1795294825-484293
X-HE-Meta: U2FsdGVkX196fvZgfLl7Bl1xrgefuUZAWDqglOrOwsaWZNHLLcNqzqsHscbbRCsNh/5hPRIaG4L2Gh1x2SJV2lS0DywYXqOaUQ1JXkMN9oOaGQ1bU8WNhS8LqL25i8yM0ueq8zr3IXC5GNf24V5y+O3fj0MUpb/mF2hL5mWxr2BWd+tLdufDjj6UasrYvWMyKfUx5tSzgRIq/vzNvQKIsDHSD8wbM6qmkdp+NR6Afo9jBa+DrUfO9BbVTE2VjT93qPYRnbW3RIDUIArRFhWSMEkXh2uV0vpODwOnbYQgzRksdlYmYbhlU1FbQgIMgua8XDkihWsWt+XJ/Or+v6aRPEYt3pBrGDaNe1YMCIOGN2+hrRcFPDFk9cTiHfXbpsPnZtLynqo/v0t0BK8CPTxiQEscycSkBJetLcT4oKsFMjFmv+ziit14SsQY+l5NHB9tm3E5Dt8aK6KHMovEWBtJOcv7/ASo1X86uBT6eLl7Ck1dLuLFMQoQoPxQUte8Bue3M1GbQqDwo51G6+ntiusyC7tgMOTxR1bNmLNXOTXyHKVX3eogz7xZkXEwbG9Ob8cDe57UlrcVwtLW6nc3CTdyqUxC28K8siihWxIVtzdj8iED13R1lE1sXaLRS40Ox8QoZWMQ4Hp/kldWI7AE0ZEFvYMYfRW1C8DDIzwGefMNitZ+d2jng8zkvtRiP9pdw4NHh+5eS9SBUh81rUbxPdXU+I9oy7J50FbDMV50x8I4zNzE8yWlAd8XbRhgCqEbERuvrVhiHaq/67yNDOajNejegCbbZf+BTDi4zi//Nw9w/qqptNG+12Y34W8XEsd3TlkZr2y9tYR3baXa9wo7/mSOgRrJ4AIyy7YWesqhovBaDN/KQclewXW/7XpvDCQkN7Hgo4rWyKUYxqvdQEx3dp/Vh3ad2ebkwWVIDylpXwArRpMPPTYiXhy9ojmo3cyJPHTlvZ+JKLuDchAkBgyZeD/
 eKeO08Lo
 7iEdcG3ftkdzzukoDZ2poJRcJD8khHPhImh820cRcbDaTS+W+cC3Ldw5fa+yRnnSxcGiNiZj0CZVYO3xN5Aa9IUscjiyQQboAAnf5RrPqJ+8QYrEXYBa+wZx3L+cUz6Ctl1ZmeX/1Wpvn3S2bfpurWZ76+qP/xgKR0epUCgmEH/na9jdOGSUFvR6Hujk3y2zNmoVudMjEsfNU+32PsgrEU5d7G2Xu1Ms2mX1SMQ7MB1Dyq3wx/Rdzf6HwYC3g/O/N+cNdxj7arZHxa1+lLs5Br6vTpIpAe8qslRQUcE0+2PtCLpWJSpe8gT5IqigLz/5s+6Cm4NNf7swwnl5W09gAbcjRHPZEp5EJHfbjpJcr45ydMLSuz6WLNK9w8nA4fGoHbX9I/o+38qe4ZcUMfg8CL8A8H8ID6GeUVA5KBgM7YGsOKhwFjp+w8+M5jbpvzu3Xx806D8d2LNVpA4MjaBo8Ded1sVgTN3FHZjg68eu38nw25Kb5LRFx2qu2wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added data attribute report
producer control sysfs files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 4acb2015c2f4f..c9f718f126c70 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -695,3 +695,23 @@ Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the number of data-attribute
 		monitoring probe-hit positive samples of the region.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/nr_producers
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for controlling each DAMON report producers
+		named '0' to 'N-1' under the 'producers/' directory.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/report_type
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the type of
+		the reports the producer will generate and submit.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/producer_state
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	A file for requesting actions including enablement and
+		disablement of the producer.  Refer to
+		Documentation/admin-guide/mm/damon/usage.rst for more details.
-- 
2.47.3

