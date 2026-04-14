Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C5CF34C61
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A707E6B009B; Tue, 14 Apr 2026 00:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA196B009D; Tue, 14 Apr 2026 00:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763496B009F; Tue, 14 Apr 2026 00:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 551036B009D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:53:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C60DB87C7
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:53:02 +0000 (UTC)
X-FDA: 84655941804.24.9E08720
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 752EF1C0007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:53:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5JKgRLR;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776142380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a16jw3xRydxSaoiHkOs947zke3LT2k21AOZy7EQs/Fg=;
	b=ug2SSi7wXZykOyMqUhy4jg7T31Wf4kRavIgCKr39yEaym/CsDz5b4ykay/09A9+X6bFzAu
	DGGi5JdNfg+Vu7ssklbjZ+OEOU+j6lDh5nfw2Gr2muGP0e8v8cXxEuKjtpWWJ6c3hoBdgL
	5We5XZ+HgT37x1UKgLbOubLPZbaERVw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5JKgRLR;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776142380; a=rsa-sha256;
	cv=none;
	b=DXMlTBIOOmtzdRusfVaWK2+eLx+PUzUrPuPKINlRsBdG3zR9S0tphKoi2bJNnKrtNfBeoh
	CSxgFupscCfpmDPMCVaJywXYUt1Qx9zLDN6zXAeCtjDmOs2RGTvJzOjvevVXbR3GeGrwb6
	HqCDQLKmojhcm5xqq1AgcfptGFspoGg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D974860018;
	Tue, 14 Apr 2026 04:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F5BC19425;
	Tue, 14 Apr 2026 04:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776142379;
	bh=BfEEDyBrJIkd6+k5rVK7zBS2eb2FwO/Rw5l0AYJHr24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5JKgRLRaK3TD/B3m5VhTQVcUENur1AMCIFZLkTVFmPS3sDwrdzLFRGQaEUFr4Umg
	 2dWFhSKCobfoSt1PEVryBL9RbBKWAFpcHjfU5uNI5jm85OyDj42RDOhbYjkJ3fplr7
	 iLbmb9phIs3VYY039eGwFOUYb53+JCLF06JToEf6Q1bwhw8XjfvQKZYGqJxo7ocCJY
	 qIdTxinBXRflpf+dAE4FG06nab3iXavRwuZz4qZpA+MhIbrIyL8ZLDZpV3Uy1m07i9
	 da4a+J9BRroAPQYrUicrAHjAYL7ffsEu8BBVkixKWf6Lz9h/wOpn/mhgAtYrLPbgB0
	 jXbP4R7oA/nSw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [RFC PATCH 2/2] Docs/admin-guide/mm/damon/reclaim: update for autotune_monitoring_intervals
Date: Mon, 13 Apr 2026 21:52:51 -0700
Message-ID: <20260414045253.88529-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414045253.88529-1-sj@kernel.org>
References: <20260414045253.88529-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 752EF1C0007
X-Stat-Signature: 8iz88mqmt1c83c8cfakwhccfucc6oqx1
X-Rspamd-Server: rspam06
X-HE-Tag: 1776142380-496184
X-HE-Meta: U2FsdGVkX1/2cu5y/zhFKzI0Jay+V8Rc/Z1HYQf81bhT+zWCUvsL11kA8BX2u7uv4far9UH9DdW8kresopO9F32mQJR48VD6gHbpbK1egoXSBtnzJ3NDcMChXzpiamRBDDtl0gjmUdjaO7Ep4h9WRzSZhATC9rxjhP+O9ou/spHNJi04mOxZyYLm9nooNN/fHALXonh64Rl5djvapGBlM/5wvqKtZuJzSqlwBy6Rk9fDs/Fc3UgiWlVxPwejSzRXbYKh/8idv7fiAjX8Zz3EVI8kMt+cdPi3Par7WA/Qh3w8Q6WjHdz79CrKjc0qoa2Cd40wN725UXV6HvlcCIdZOqGXXKs7t+5puj/apqRYJHTNxiNFdlTdvCw9Kihba+MsPCFB3opJLxAdBTLsW5ntGFxC1Vnwz9ts61yGb3SZo1Fdv9GJGTKSohL5lMPKKrEmKXqO1w5cnnxnEk20PaYsu7PBGl+AOLbA+XXRneAkjjnS1RXmdrUhBrFU7Qua2qmIAFz10Hdid2qT96/wFbxGDWluNoLDWo2agSeKX2gF/QtX3kVjMvU+e1jSCfcfOiqRhLirbgQ4N+Y9yWZ/XVPSCbgsH/PCruJfFW8DU3+tG685rw+Wye30Dpe/7CQCsbS676KC9BT0mBhs22ot8goDmT7bXYWzbGbFPZsYkomlPlMfedfCEk10Wxu8nyjwmclxgRE/B+Gd5lhkY+LnkAewFDOuVtnQHilmuUNUbn3qyZCFgKLllHyk59KRnRDc+NztL5wroT2ky3ktMUMu1jD/mmXUzpMUmG6sBIUkVZq6lw0h3j5qgAd9xr58u8W6KdvSb/NBpi2tu3FP93mVoHfPTNmTGDFGY+qf73NwMxTRUj3ZrWc3478fIbG2a1usglHy4nmjFql0Rb9Rsq4QeIzMp2QFc1fgUM9xKAwo/82fRl3gltkPtQHTaym3URni+hLDb5CnCK9RHm0vP9inhd+
 yCzIBs+7
 977vDe/kY93KIg0QvFRcWZiv5Cs3EzseHSzlEEPLN3PWfb1oDERpIXq+Wq77U3TG0W72bNgrD22gOfbSswnG7enkEsdn0yQzhIcsiPfFGHP5ny5J1l4auGaugRVUOf9WwwSW7AMFGe/80T/S6Dr6Xd9rBAUq5Q0jXYVC57y/reKoKSyzBuTn91A4WtVeasyXMHvjhAYjer2p+d+MGXItug6VxXqClmHOtzo2Iy6Amf5yf7xQNKMM19riv8QHC6bjGaCTnrC5mQnSo2gZpIQRzuoeULA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_RECLAIM usage document for the newly added monitoring
intervals auto-tuning enablement parameter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 01a34c215b66f..b14a065586271 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -85,6 +85,17 @@ identifies the region as cold, and reclaims it.
 
 120 seconds by default.
 
+autotune_monitoring_intervals
+-----------------------------
+
+If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
+amount of access events in each DAMON-snapshot, while keeping the sampling
+interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as
+``N`` disables the auto-tuning.
+
+Disabled by default.
+
 quota_ms
 --------
 
-- 
2.47.3

