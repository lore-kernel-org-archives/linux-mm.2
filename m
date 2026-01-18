Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDDDD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EFF6B00A2; Sun, 18 Jan 2026 13:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A6B6B00A6; Sun, 18 Jan 2026 13:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DC16B00A4; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE4796B00A5
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DF385984C
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:16 +0000 (UTC)
X-FDA: 84345856392.18.481E5C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DED93180005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ewvwYXCI;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768759394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdVqpnz/AN5ug5Xq7s+6w5HjEMxm3S+NX/t4w9e4GZY=;
	b=H7GK0OFW0lgK6i06k7Rm97JACbFB8UpqwYjWShjV+h+A6a7dpnZBFOII/vR02Dta1xWGKc
	zzPADvtLetG+XSbDTYzFTW0geo+4iQ4PCxw0qB7UwGLl3N5tW6vimycg+tQqNmebItDKqV
	cmvRnFFiOOQpXrF91ls3/V1P5SVq2jE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ewvwYXCI;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768759394; a=rsa-sha256;
	cv=none;
	b=5dD5WFoW4CcldX8Et0dPwcuuK5fcyvW2f0NydkMfaahHOYN7o3YCKT0OxHAL1dn3hjZdxh
	TWiDXJSiopi8hvvYrjZaWpQUqrAFd8FzGR4absWzWDgZBBtstBAjPcvUbRumI4D6ETWGUG
	yqkd7kYQX+B9zYgFFuti93N3FLZa/IU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72AB160134;
	Sun, 18 Jan 2026 18:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E206DC116D0;
	Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768759394;
	bh=1GRiXmsO65OYbfT1UpFoUJRXTsmQCXqwNCyc2P2HEi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewvwYXCI0UNZ/JjJAkjbGBLsGZjO414jRL6prWYBB8Pa9s8HysdJrNQwhL73sx3m+
	 ysed0jEyD+/qkThI/MhqbaYOJlR28ZO0SD7VRrSvI4GFwnmAeG3rpYRlC3pvkcwX3h
	 F9KY8x5EhL8yyGCX7ijt3lrQGQI0w/PwVN7E0Cvm2iYuKwejd2T7S+g3WAcyb7jpom
	 ZgLvgKbkLXd2T6QMNUJqbQL1sHS29cpaVjhMZA/dIfLn4l5D2eiwlh3CIdOc9hEv/0
	 n77vsWspqZaYxIl1CslTUChb6B4H7iAtHjF+oAbb7fMIU3L+smo2M7GMC8K4sCU1vj
	 d89MLT1AsQE8g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] Docs/mm/damon/maintainer-profile: fix wrong MAITNAINERS section name
Date: Sun, 18 Jan 2026 10:02:58 -0800
Message-ID: <20260118180305.70023-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260118180305.70023-1-sj@kernel.org>
References: <20260118180305.70023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DED93180005
X-Stat-Signature: qwokc6d7kbrbyh6rcardjbebujjc4tdo
X-HE-Tag: 1768759394-103065
X-HE-Meta: U2FsdGVkX19NZCVbYzi+EuVgHW04ncKHtoFm6W4R5WY/js++MZOTsJcoZp6yBojdJuo/Q46FbWsywtZ6w+1s9fNDO0M9B539c5IjlF6Sv2juYVDvOx3/f14jyw5k4W/MnVDTvypPTolpqrjqwfwyLQhegGSPCjXpPslDDmIY+IFQvT+oUsEslpIyGH7ur4RnsXlQuflTGGdvmi95d7d8i8dNeMv8zqp++PaeKq0bIcN7ruifPzi1DQIQO9VBqGqPncvFBs2BOODGC9lPyLUqXhaukcBzN0MLAK9ApRVhk+h78QznLFL826Unn4hI0h5g2231Q/eBCJ0+L2rrwHERfUdh11hAM0iVve9R3r356HCVA24ZFCFzVSNujdY+yAh50OstSO0mrcXOTEjkiaiItzTjXp83bODzlOIE/7BoAMeUvo6pkhbzfTGv0BHC5FAXm74U09HM5onhTROeysn1Vt3+jvLACgFa8EVyIXIP8qzRbzDIdZT47jpaY9yc5xuVidzqT7MrodyWPHcVJoasTzz/qsLD1p7RFpWcTY17aalWvRxRKjUb7/N8N+L/Jmz7fnzNTrN6Lw1SJNvGiSyt+ySzOovX16MN371Wy572NjRnGW7QtBttEcBcJrejo2vgh0wpavq1tkYwqFoar3UZHKdWx0n2JVXyEmgMIjoTp2Mvt7lumT5af2G5R+hcrbAT2NrqEo1O16GAVxxk3qnfs+9aW/PdWybBBVlzCKXO8IFdP2LyR50HM6K5okOWT4NEjLw0F+/4ByTCI4bRnBAVtOzo2BGErSfhlSKVtD1tBWu5scRISD17Mur4eEz741CVAMwrFW+Uu1Srq0+vVihu8QCY2xylq5hITz9psbsxIric3M4h9PIbslpi4U8VXwcnsylucNk3Pugqc1wwM1KJKvwdo3csu7qR+ICb6h+tlyAeJIs0F+5e6KZSUL6dUIerIvHLVrIcHu5qyydF/DQ
 XM98/ubV
 leaPB8Kxv0BcoE1Yr1ANL3GfHMiaIwWN4dLZ3pr1u8XN2yZ517Jp7NQdGbwiqZYaXPLV9EfS2Znxp4POGpkny6mrEraTeQjm58g/R2LXD9tCrJ9z8JhlhqYRl8zuc9LYKee9MC3WyZJ0miqQ9ubLHqRdrPWtmWfKiFzANOFhGYVobkpcFcsVDbqS1hkPFAf9SO3SEL00s5x68NKZhhQRepJTVb+a3ROw7E4ug5JpesQto6KiL9MpqF8rTO5WnZwY51g0g4ge5Fo3NgrG4Lqp4yqJO99vioTtUyfJr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9044cbe50a70 ("MAINTAINERS: rename DAMON section") renamed the
section for DAMON from "DATA ACCESS MONITOR" to "DAMON".  But the commit
forgot updating the name on the maintainer-profile document.  Update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index e761edada1e9..4fa06b21ec30 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -3,8 +3,8 @@
 DAMON Maintainer Entry Profile
 ==============================
 
-The DAMON subsystem covers the files that are listed in 'DATA ACCESS MONITOR'
-section of 'MAINTAINERS' file.
+The DAMON subsystem covers the files that are listed in 'DAMON' section of
+'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
 linux-mm@kvack.org.  Patches should be made against the `mm-new tree
-- 
2.47.3

