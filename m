Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D9C9F5510A
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2982C6B009D; Sat,  7 Mar 2026 14:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203C06B009E; Sat,  7 Mar 2026 14:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B0A6B009F; Sat,  7 Mar 2026 14:54:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD2CB6B009E
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A83D51601C5
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:11 +0000 (UTC)
X-FDA: 84520318302.06.C588405
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2C89520002
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zfm8IcIz;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772913250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1RLHKkpXheA7OxtR6zBBg7bxlkt1ilJJhOfgDtOjAA=;
	b=h9VCa+LDolV7FX/RRu53ineNLgSaKtQtP0/AdJ4+KS7huIOCmWckl9eRppMKpxwW6ut/OV
	TEEpTF1halncxrivxtloihzq/9qt+EVxetbGiPjTR5yb42YkAmR/uyWDR+4VNqBZjUYSsQ
	4317A+bxmLMu1BXfLLojUlkkgi+rUS4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772913250; a=rsa-sha256;
	cv=none;
	b=sP4lUWH455c9ID+mBI4rTvNTknJnTwtzcs0IEgHfKEjYuLXOppPsB1ziWIx6MFY2bAfZYO
	qFbEfJgYHR3IMA+IA2skhGzDZr8DnNgIf6c1cNL8p/XQNdhCjrbJyKZ+36pmhUaHMRiAZk
	3HYDZXVXu0fZKLBfgVlPwtnZ5eW35Kw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zfm8IcIz;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF24A60131;
	Sat,  7 Mar 2026 19:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7B1C2BCB0;
	Sat,  7 Mar 2026 19:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772913249;
	bh=j1nhe+UiGfff5E3sKkGedNU4ILDb3IrXge2niBaw9Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfm8IcIzwKBjgEdFr5ilU2FR1Wnuj8tGCMfMRx/gq50o5ayXhw6mC8xy/KPocNVkL
	 MR34iZVDuwQSl1D86BxFp+s2BLo33olaB+M0xjen3Vng7mDi1XVHuDgDDAW6SjtsV4
	 yhwjlZdDz/ZXycAzOOBsX9BIBlGEA7cYhURRJ/UrRZ6XFGYFh0fZtLu4rNjUV0+NzE
	 LIemH8X5Za9ln8hQpvoBBUxzm58mFMIQ1qiShRJnfxaYjjvY7x+EYKTlX9wGhELioV
	 S4RYlbEthuPiD0+gwsepw1Gf5NieO65DbqRzr9oS7+mr8OMAvNjo4xtKJYxtiZclD9
	 trvfg5wDHS8+g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH 7/7] Docs/mm/damon/index: fix typo: autoamted -> automated
Date: Sat,  7 Mar 2026 11:53:55 -0800
Message-ID: <20260307195356.203753-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307195356.203753-1-sj@kernel.org>
References: <20260307195356.203753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2C89520002
X-Stat-Signature: 5swu3sdz6158s6y8w839wjytdpid8txk
X-Rspam-User: 
X-HE-Tag: 1772913250-236549
X-HE-Meta: U2FsdGVkX1/VIti4jhRFTaJj4kwIj9XsbjSW6Cxpo0NX6Ra6BwNag/5FeOCiYOAMADhT+ZndR3I1/hTMog3dCdbLAaK8NgEr/SED1bJc4pHekaHqCsi5SYdZrU85iU9QlDKury1f2T1PHK3ioQV/qD/c4Pe+D7/pnfH1JQJ/tYghGNpR9jVW6yLz5ejGlgjvI8mSWi/kwPkxSfPsxTPf9RlIE197U1bhMUow31qPYktvAPipErYckaqIIVLl4Q/FXFTmyQc8Nf/GoOUAtwI2GeYVo/bjDqxql4D+cB5L0c1Kwnn3bC7gFCLd3GDQkA8RN52XHMhaZgFiUsZ2PJD0kTHhLolPSORoDFptPOyA7wO46GV1RjcDXLKwqbLvzDQdVhPcHzk9GPgxfQjlULv0s2WhzwXjPb+nW1UvgD4MRMJ8rQHKS55cJki7ZLYBplincmYamxB8nHItywj99eVczraAnnZt8FN6ZWU1lzZnOjj7RpRrEfXG4dLuaK5uPqwt72T63Z3GSqUwV3hvejmDERSJJFGLlVzwsQV/1FDwWMyh7TESlM5da2sCufnlpP5iCG3mZwEktZZLwivK3K2wAxWFljJdP4v8f3tZh9tEyZPk0ym78sz9EM1e2rglwDrD9frO1JTkszY4wagEge87PbBKZ7R9GVO7JIBRDlLTrg8Ooqoyn4xvt7bGaKcjDFpGQKN69wVTGrCfWy/wb5R4gSZeO7RlzYWVuDInrLnP0eWlfFGW0owl7/tSuyQzAPzfLX+7NZ+Nqdvvprt1c7bt5ku9xPKnHGX+UKXfibLz4l54hPZbikBkqIpUZKEv3u8Kbo1gSK0Uw5fTcU42XFDskDTvOeLrtQ48iffsWZkq8C1Wg29Yx+cd98SeTiL92L8nFTQCYk4TBnB8TwlmywwTYcPZBKITY8g2NtTYcUhhP8Lwv9dWctGqTIfs0zryNyk6x5cLgrJuFEp8PLEV9nC
 0dFvrpfe
 CkoF4lhZvyHZNEz+ouexcfdLjMl8TiUwwDsFCIMcdUBWhlqwSmTP58pIFTVCX1lrT6wSh7ji7OK9LtiZcCDTJt5XscoBmA7Lc0a5T25jthnP6E0ftjDziC0Vppby/SXaxey0Zq/1EjAj/SDWANhkfRMSbS3Kn591EruZo6T18DZTpQO3hWIvveZFES3a4gcVPXSXwBUszxIDjKTlUejqlwUIiku3NWSSBussC0Vjyhc/TgwNsidewgH9IW89GMu0Y5t6I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is an obvious typo.  Fix it (s/autoamted/automated/).

Fixes: 32d11b320897 ("Docs/mm/damon/index: simplify the intro")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/index.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/index.rst b/Documentation/mm/damon/index.rst
index 82f6c5eea49a7..318f6a7bfea47 100644
--- a/Documentation/mm/damon/index.rst
+++ b/Documentation/mm/damon/index.rst
@@ -12,7 +12,7 @@ DAMON is a Linux kernel subsystem for efficient :ref:`data access monitoring
  - *light-weight* (for production online usages),
  - *scalable* (in terms of memory size),
  - *tunable* (for flexible usages), and
- - *autoamted* (for production operation without manual tunings).
+ - *automated* (for production operation without manual tunings).
 
 .. toctree::
    :maxdepth: 2
-- 
2.47.3

