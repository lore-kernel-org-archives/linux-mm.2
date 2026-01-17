Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41CEFC9830F
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB01A6B0088; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6C36B008C; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4A86B0089; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 713706B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B58CBD1B14
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:41 +0000 (UTC)
X-FDA: 84339819522.06.5CC9B97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 600884000C
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZiIzUxhG;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768615660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tMuTdRDeTC5h+THw1KUnsRQdsPglY8Rn9j8i/KyC1tM=;
	b=AenvyYoUyZF3TVPgcdPOCe3e2sFU/ndaQYSRlT4M8812GY4ErPsXhTJibYviwJdWUlGgDV
	ScQnEVZeN/qSd1j2TW9sN65lURmjp4rdEDH9JTHU68uKuGVVBf39ClzCdjGXg3Xw5y7AUZ
	LWmWhB7T3im+viYKV8QUm4Hp8OAOlS8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZiIzUxhG;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768615660; a=rsa-sha256;
	cv=none;
	b=TgZTF+HMVKzA+/Wduj8Wh6QXSn1Bo50NbTM5UQDq0Xom3BHwId/fW6jhpH3Na2Ca3dhbck
	ct+KDtQzH6GunzJ+plo9kBJESfoSx3UvNALdawJ8zH3yEO411Japgh0M9I1/TS2SL39Aro
	+8JWzxjBTIk5q1z3JKWXeTN7OTLPPQA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FF6D60131;
	Sat, 17 Jan 2026 02:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7F9C116C6;
	Sat, 17 Jan 2026 02:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768615659;
	bh=ldDDpyWtiSre042DeL1/47rOCg6vyXlOAiFVAnaZ3ow=;
	h=From:To:Cc:Subject:Date:From;
	b=ZiIzUxhGCq3SNZOl3oRQvfcs2C6g6pguzzZllXOOhGgbFCNCOu8AjPm/HvITzH56X
	 y9Gbu09aIwSIWlB8zOmR1YcUp/usxwgaaCvRxX8WG12d6MMt2jnZiSDkvQjWYlxVtM
	 G5TWiUW92dpw9zL/Uf7VrNvQxjlOgLWnz5BgKMwhX+wGZVm275IvvPXpJUtnns23xJ
	 e25K2Twcmze3LqxpCs6gsceLIB/W8KOtkZc7Zx9TJwPZdzb8Ae8BrOP7E0qT4sn8kL
	 ZDKqkv0HGo3zSZJ/5GJ0RlY9Psr6DaLCTJXmb7xQy4ZbXQ8lORPGwKSFCg9xARtmti
	 5Zl3cP1U41/Iw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/5] selftests/damon: improve leak detection and wss estimation reliability
Date: Fri, 16 Jan 2026 18:07:23 -0800
Message-ID: <20260117020731.226785-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 600884000C
X-Stat-Signature: k5e83ymagi3b6w3oybs1kn1bdmxrqtkj
X-HE-Tag: 1768615660-590492
X-HE-Meta: U2FsdGVkX19BQPr5e9mvkgWROLY7bHxwkB7b1oe0rJrNvBJBt/ZVm1thsnCNlvHRgRWb0I4H1EzUlyAEPzG4B+r5Kst+LMhhPY3Xoukr5+xGLJVo8RlOTvSiVvhCy7kZ7dqxIU6ds61PhJjXqZLTWZylO+FSEpBrPTEVzOgVu2ZsOrVXMmaVTgQmcrSUMygMtDcPj11T779vBoSQb4cOHoD9l8gUkLeIDYg/MWPipaObKIqC/wuHucJozI3fyDrSatLGra5yoa5X3x2JtLajOtnTXZ4q7zNYy7vc/WfpkfSOcnbsZEazghwPK/onEA8DsmoI/fx3QQWZR4+esF1YzfRCmZmp7x5g1rq9F6b4aPYYjoZywX/9P9TkyyAhGq/TIBSf06NP8J8DzbjN0hpY+rE7rHA5MQ1uZIJjh1iYydFKSUWZcZq0t8e0a/SR4by6fgzKhoh4HP8FL9yYrepelVE73Mz85WEq4txhm8HTP489EpCYJbcLC8JjXHxNvKU75tbuxv2qDZAHYFKs+Mi6iqwuw3FscYM2vOBpNNSaTNmTv+QuTi4gt3bg09X7iXRCKjGLaEFttd2WAlY8HzplbtLTjSI7vIes5BPgcpWPO1QRQI7WkjY36DKosgChPWR5ZT7ggyLiOSACFhFu4BOugqZZTCNearD0ZFl8v5gafcVv81oKJzCaEx4eE+h8ES3/PDEZAsCRvSgxy9hpPDTVhmj3/3TuJ9V1nLd/St0fkoV4jEF5QjyiI+ZiZdJApP+2aVa86PnClIXXgx1xepPJN+SRNtC8XnItgy2Xq3q9dQBt1Oag3FOWZwZxYNf6koL0PxrwJbk9ko7BzFbvPErHkHSu+GHTE2ZnNWmwZIg/8qP0xIAnFTalPue1j0aak2HTYtj0fTsp56IEk+MpIAS30j+yAndvQEKEIbvAfRtg8HROJUpqUNHUgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two DAMON selftets, namely 'sysfs_memcg_leak' and
'sysfs_update_schemes_tried_regions_wss_estimation' frequently show
intermittent failures due to their unreliable leak detection and working
set size estimation.  Make those more reliable.

SeongJae Park (5):
  selftests/damon/sysfs_memcg_path_leak.sh: use kmemleak
  selftests/damon/wss_estimation: test for up to 160 MiB working set
    size
  selftests/damon/access_memory: add repeat mode
  selftests/damon/wss_estimation: ensure number of collected wss
  selftests/damon/wss_estimation: deduplicate failed samples output

 tools/testing/selftests/damon/access_memory.c | 29 +++++++++----
 .../selftests/damon/sysfs_memcg_path_leak.sh  | 26 ++++++------
 ...te_schemes_tried_regions_wss_estimation.py | 41 +++++++++++++++----
 3 files changed, 67 insertions(+), 29 deletions(-)


base-commit: 3944e89e2ad1bafac43daae60b56d2847227ab01
-- 
2.47.3

