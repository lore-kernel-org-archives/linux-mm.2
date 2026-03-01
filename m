Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD450FD0072
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18516B00A9; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5A5B6B00A8; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD056B00A7; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 705536B00A6
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D7B71B8909
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:36 +0000 (UTC)
X-FDA: 84498216432.24.F0AC228
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9491C8000A
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rFnCwPnh;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/N5I5kJjkEZIg64PkYpdtlaZKZ0JKdMBYrahzLr8qZI=;
	b=fWxysUJVKw84xG01xDVtflZ4ovd66FUItIT8StkYlatLQ2Ou7XoVdx2iklmhMkJu2El4fH
	7JlgLuU9g7e4qHnpwPPcgemgW0Dj63PyqMsOZciJtFxNviiG6OiGYdlrXbkxO9Ss+s8Pub
	Y3TYwCGyHP9gZddVkmfr3fSkNKaa+eU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rFnCwPnh;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387014; a=rsa-sha256;
	cv=none;
	b=JpFSCBs2NOxjM9lnDWp5XP4+6udRogYAxfCsOntJxOXYNG8tItmM0O46Cv8T9/7uIupied
	v0GCBEbXtt9gEuAzvWtqy10lWVOd7rl0troTJls94XG28gWBHLYlfNtzv7zHOWv6iWJcui
	83qguJE+pRn9IH5urfEDexDnF58iR7Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EAC9860131
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8C8C2BC87;
	Sun,  1 Mar 2026 17:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387013;
	bh=iYt3HJjJZ2u5nNYQJzA/aRcSczmrsEXHtQU6RM/AfoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFnCwPnh++xwuWwRkrY4CeaxcG9bnQGTTsPkXqxRFt8lBulCdn2iwJDmW3m1DzqB/
	 oFsYCPGve5Z5apDfTyBNBnqBDhZYn/33mlrHakO7fXrFuN1GX16HBnAK0ZmNMf661+
	 vasUaayX06ox+vTFt+Z969t+RA8EhSzSRNoMA8dJaqzcYhSuoRQXl3oaUqGtFogb5m
	 D9ZZsE2smZ89GQIOJivP5SQFrvRmHCxk/HOY9VnNhIpr7TJfK8iAm7716scLjCnlOz
	 CYET4O54BaeyjJl6g0kzfm4mOTeVv4vpDKXoiiIx7i2KwhmMiq8X1Jof9i0rDJricX
	 atK970Ql+BjsA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 10/10] selftests/damon/config: enable DAMON_DEBUG_SANITY
Date: Sun,  1 Mar 2026 09:43:25 -0800
Message-ID: <20260301174327.76849-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9491C8000A
X-Rspamd-Server: rspam08
X-Stat-Signature: x35i8kin6euf7nywfobtqu5zhi4rtm6j
X-HE-Tag: 1772387014-61850
X-HE-Meta: U2FsdGVkX199wWDkAz9/5QFIA5NIJd/1/wpLbl7DbilvTfoLaqA4829OW4DpCM3qzNERXAzo8m43XuPBbxTppZxgUmx+2FwqXxXz3OqugtkiRC+CdRc5cKXvD22kq6v5DQbA4jusdeZsDPpZY9VSqRa6frPbnqQh7i0pnSmBEkvEW7/FbX017g978y+OqSnMSRxCeK89PiW85XdJaSU5J4EZrINQoCCtmFLL8wE/vKnPD5Lp/GT8yG1iOdTnk0Fm4eT+AzXbPI4/9GnvmNPXG8zRtozv1InnqHvi4/8uAf/5yBhSbskuokC9GDOAioT+Ql/7n4thMSBhX4L+Dhfyczb5RGRqYRZHRarDuq9H2r15u3+rJ1wOx34w3Eun+vliOQAzIS60Sj21umzbNsRiO4PGGDuYQImxAKEC65680Q+PdKHZWVeNJoFWceW8KXmyNEqUjJU8eMMyLL6HNecVy8bfYkAOCXwvMZ7gEKqQUo+XjQhzOqdqeic0lEnT3GK5KAalVmSa6z+l055kUHUjJepI+R91BrNpWJDNJBtlZOnAvirhkFJ/n8XdaHGiVf2oTpNc/14TQBm78Mm90bgiGR81kZPXU7D0amRK3kFiuUsD6r/C2GOmTRRMqE9V4f0L179R1Gcm6R4+OgJbaLzMoerRNVyt4CnQHThdulZ7hW/eWxyfEZ/Rv0COQBrgTjnzvrxQ0eAAegHJhXTyroruolBPKPwm5OB31tiylvj2uAq8pD6/C6kJeePFYz//V6oSxTPiIv8LI1MJeRLEp8gstYG1TAWJHP48RrVMy1+lpmKlMk7UJgOGvyWRtKTRdHIhxigkINAcdJlGJxTCxwUl0V030y77zg5mYCY/9P81JqNVHZjxF49VfyburnHgDevoPz/xaID6u0DfaLq9qhVUuB5ZaOOxYRyETCI4Gff5phG8HzcHyW2S/QrFvjNoi4ttTwbi/kmxm689YMZwQhH
 zhxPKYK6
 LfkxPl6Yvdhbz/E6FaaYYxtskF5l06WI1f52GC1mWuLIPSXmJpJ455aegn8W2u5zussLWLzSRn2szKCy3eBOAkIGdyNuGFcRiWw+LpaEiTi/KB+yImqK9S4JRwS0x9EtWodWg7VVd0IMtjCj9Rjqtx0yIzUv5vufiANTob5s6qkJA5vxDpcJ/wPGhl71YPbWSVpRrtAdpRRMmdJumspLIzxzr6Zu6Nu663vvBI6b1Kscqr6bD3PKg9pSjAJEZS5sBxZiwu18mmjJpZl4ps165IFAaabhX6fSiND1yDM3RTx0ktucetKnPeVlqMOYySoZxv+E/29Y6MxDZ4i9Q2WTddfsN94GJ+vxGm0yK4vxohXNisGYMn6T2FUw/a04xjKNLvjoe84nGHMiN9+FWcJuULy9e6rQ/cKMm9TNKHK2xPcZCk8LSBWZcEtpIgezvEK1qKTEHKNyKDAMj1WQnTsIH+E/pDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_DAMON_DEBUG_SANITY is recommended for DAMON development and test
setups.  Enable it on the build config for DAMON selftests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/config b/tools/testing/selftests/damon/config
index a68a9fead5dca..6304adacb741c 100644
--- a/tools/testing/selftests/damon/config
+++ b/tools/testing/selftests/damon/config
@@ -4,3 +4,4 @@ CONFIG_DAMON_PADDR=y
 CONFIG_DAMON_VADDR=y
 CONFIG_DAMON_RECLAIM=y
 CONFIG_DAMON_LRU_SORT=y
+CONFIG_DAMON_DEBUG_SANITY=y
-- 
2.47.3

