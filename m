Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A90FCC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18BB66B008A; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C9C6B0095; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED10C6B0096; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2F406B008A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18D08A03C8
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
X-FDA: 85028522796.12.256FBA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 47DCF14000B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nr+4WRP7;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAfIlLPcU4sckuDrbS7eOEg3BQtpmGkcQ7Y936FLtiA=;
	b=a6x05lBEah8W6Tl0qcjhw17KUUEluEiSKj+ICJC+dmrR4t88PhJF015N/UgDsHmy8j81BE
	YqHMOdtuJ3etSvYpgqSvPt9qfQfnR7AMLvHscC39/YXxfwirETSGL+BvGDMQxoMGH7nXrB
	IiKjQOSIQMolYCKorhaqq1gBy/5k99U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013356;
	b=Q5xDNFWggf/TT7zlRUiHXMSxI4YQujUS/PkUmEGSrvOjGwi7k3vlN2G/5jIvIoTKYISGnD
	xCHblT5GPJ2byN+g9cYDqbJY2eZDuk971a1nww43Iwe75ATeoGmfvFBhKuoRDiVwK5cMt+
	JP2ExlNBa8UVUSlOwl9qqsdbCByFbgQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nr+4WRP7;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2E2E60A95;
	Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB3C1F00A3A;
	Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013355;
	bh=cAfIlLPcU4sckuDrbS7eOEg3BQtpmGkcQ7Y936FLtiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nr+4WRP71qblrm2lUWmqWW6UfL4uqUQ9c9EYhLUD1KyCnVt8pOPocsx9HC2bczb0Z
	 Kmbd5y0UPGxL3ojDrR8JUOWuLRiklD7zy9xCqX6ub/x2Q5uuw1b7iC4LbnSznxllUN
	 Jqv6hcWl95eki2RbEvsWHw7nuHPOQv2MMROMTRJm41CQg3H2EwzEp9l2YhXdQ4RxvJ
	 EB1SyWGhEWbLwyWMch0lyTPelWTaoN6wuvpVJEI3/ShoAOgTjqprtz26eChSKZmCIE
	 elHeYXdGjMcDS7gUri6wRcuLins0HFaTKJcxAH3wejzKrDSe8ufHmjOb2f1WfZWLgI
	 xgyPVHx87kSqg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/17] mm/damon/sysfs: support pgidle_unset probe filter type
Date: Sat, 25 Jul 2026 14:02:07 -0700
Message-ID: <20260725210225.129944-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47DCF14000B
X-Stat-Signature: 7ghnjczyw9cz65biafy1d3drnq4ihp8d
X-HE-Tag: 1785013356-431953
X-HE-Meta: U2FsdGVkX18zDNfl3e+YVMJ0RWvY8U0Yg38dT+NVqU9gr06Z1l06GjWqwZHFiEIAc65nlqZ2pkC9q8EcKjkLFwsHKOctCd1xdcek3At9ZUzBt7K7e6iIK4wxvz9caa4xTPaIv+IytPeazkUhYZbIzWNWihNvhCMaXTI8o9uvTOojNLr7J0iwZK5ECpbgpecN6qRbEkIIan9ikrOJ7ntlMzsUFgaUwZejK72R2zhAeeZj++mkWSsaJOOtKppx+TIN89jNTkSLIKS4b1Jjbsi4bA2s6L0A82iAyLDwlhWKYmkZBDNE/8BwaDRmB3gCsKiIk7YtHHSP5eWINeIt1wvVjUhvRGvuJfSsQ5WTrrM+WMtdqYqLCjQE9M8lTui/qDHMTNCZ2tgXENAzTAxwScf/MmYlEYBjhdF29R+b5ztgl0bI7vivU780b8fhttUuC7iEuyWh9YQePRAiJa/UdA/wxI68McxA6D1/ui8/9d+MhuXgWlF4HyoYCuys0k2T2p0c5bd07yu3tObkd70yVTY1IIXYfKXN2hjk4AIj147A3VGQr1o1IJ3GWwkUZN2eERkNvSGPgJswich9E3ci3JxK36rMpIgQaIPjLzGYvsBPIgsf9qwJfF6WayUPluiKbuSDB3aAFITnBudSbphPUbRpr0MqWnOPuMiEHlqH/GJOLjJx+RB8L1JuhzeY0TQOY+Z3FT7M3q5J4FcyTMsbM0ILcTH40ybhjNoXD9BpOGgs7TIMfhr2O3paWhU/12xDrxvXsZLAUjAgkZiVjORJH1a59b7N1A7xpTw2l4WOvakA7QGp/DCx9ylioOoWrW86xkBefHa1NLA36IbkMnYcxIhqBodn6JwyUvp8ZrxR4RxB9IOP3rPZ5Rd+WtYaLgMbqa2uXekF0X/Ww7zNaent7fLmrDp2idpuQUgU8eWX+1f6DNZtsfR1HVuq87fP+2lZaXF+rer6CbgQqzFF1H4hOM8
 nWvs+8+t
 hjQdwIP2+/EP956Huv/Y9g8BsYbvEu8glx5B+FV5rO4af9m0TX+g6Imrlf/ZIxIOEDMis6ozaInVB3X5crfKyQAy5TVbpwuc6FpwrPS1Ykq24blca6OIlUCdgEencC7BF3WuHjTNNPKNtS7Fxq/BGrBBUAEvzB0kcmoyR2Bgcb8LUlHz+H6CWtE1Fu2pA+G0HKplTCa28h1WESs7mWMJh4N27gQv7oEC/nwvRY85hFLn/b/pnu/C9SYj+GQ7fAErWDWzx1tf45tqtcUV4y5mm7pK/yA==
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
index 053ba2e53b969..376c6ecbd4bf3 100644
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

