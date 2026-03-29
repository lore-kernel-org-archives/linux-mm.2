Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB19F3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142B96B0092; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A6A6B0095; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24746B0096; Sun, 29 Mar 2026 11:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE55D6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:30:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A82F13A8CF
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:30:58 +0000 (UTC)
X-FDA: 84599488596.19.838B69A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CB73340012
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:30:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OoMqxdD4;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774798256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+VJ+lDaQo0WoQLAa9rP73UfABPA9Nbc9ubiAHVMnm1k=;
	b=jLPhQ9pOViKLtZufggDa8sPWAGIo8PC/WoiOIMrl96AXnyEYEkC6v54hzl7Y7cjY8izghC
	o8bL4DyR+AmiRi8BHpBM3gwOCWbbBqxJpG58tct1yUd2LZf74YJq1PW1ttmKVlMmRgGqjW
	Pb9vTzWktKG8MbZgHrceXOd5BgrBqG8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774798256; a=rsa-sha256;
	cv=none;
	b=NXEiPyj7AHwq6F9ae+Ziupa/RgBD0jFUBEnlvB0xr5sU8KyPFI8TGEYOT/YRKeWRBfX0MF
	1b9hHkRCyM/UZIXMHCyVV3TXqr1nChyfLJnrTGqdxwmc9c7h4YlmSP1J7XKLFnf9i1E2UG
	KyEkyrmq94qK+HSrmpp/LPomThTYiiI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OoMqxdD4;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D994440433;
	Sun, 29 Mar 2026 15:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C75C116C6;
	Sun, 29 Mar 2026 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774798255;
	bh=F6rB/oSgunb1Uwn0bqw0CxoNAheCQwZDVnE4QMMy5W4=;
	h=From:To:Cc:Subject:Date:From;
	b=OoMqxdD4hnvNwAN+Z47Q+bFg6GC+0rO7D2sCDao2j87/P9P9HIT8Xb+pU77OCu0vj
	 fmCTFc+aUORYySWRafg1YanIftfU8HBzPHj8qbqLey9pxOwZ9SfwRK2asFD77QkKH6
	 8k+trMTJ2fzffR/wVXifCFEmhdTRVp632zkjIhWnGPxdeKhvclme8rh5r2heIDgwYU
	 WOIEYdFHamiO+hHwSrIvO4lxvjHCt/7rvTCfWTjoXqXbxynbSDEZcGOSR8yKFolm+d
	 ipg27t8KFMeK1IrDwZRFnPmgty/0vooOe9/zehTZPvuJRInBM4hFa9huywxLTJ3Gs1
	 a7L/d1HmF62BQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
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
Subject: [PATCH 0/2] Docs/admin-guide/mm/damon: warn commit_inputs vs other params race
Date: Sun, 29 Mar 2026 08:30:48 -0700
Message-ID: <20260329153052.46657-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: owb9kobefp3orrrqgpgquwi4hoxs818n
X-Rspamd-Queue-Id: CB73340012
X-Rspam-User: 
X-HE-Tag: 1774798256-390504
X-HE-Meta: U2FsdGVkX1/7FJdG4iBpeOgWF63fMCUhMEVKNPuT+la9aKg3uN8HjgWNk+BPa87ZewBalJp0ZoEmpsmqmip04ihE4h8u+ZSSgspJNVjA+aBJe+XE3gDtDyoDbv+WhByPBLS5HznrLLFHDpL0k8jkLtHOUVKWrOL6apkYhfGIbb4LjsgdfQiL2CBztL6djilovoRee5+8lqTgnA09tRdn6yHQ/uWXH0JkY6X4Nr8J/21dVzltA7VnIyyhCodlIB5Qrci0ijRNI9QYqpNKisCJ5fCP3H2oolCbDDY6CuC6L9mvEzb1D0m7CM6AoaEZzVnwcqtrx41vR+j7y5UbGCMqSHTwXajUB/O+a4uFuClEQrUaItOCKqJzmeVOKb4sz2VGgUroPMuZTefeXkQt6Zmt/NpF/LAtp6E8mhzNwC96PlKLlhquaWJ/mFH56saQv0LSgk49R6rK2knEav3dPYDgZAUhBtX5yhS5fvjoVKuRgGORe5pxImezlIntRDPknHb3GmTJbxFmjp14vymF66d/ni7dil+pg6dq0woinIpgzzyBK4cmfqdr/AUc8GT97Tsz1g3lTJeT9jF0ra4aJtdEZ3qUaNJALKtKAmJwZv/W/o0q73ShcQHUxeCfC4lvVRdCn1LkwEcfquD7QVPghtXe3GEmo0S0Oxtz+k0v5ieJaSi09bwOtUybfJcTv1OBwG+fRS3A95j5srf5WDrRC6TwmKIkaQrAGpoDD0qSz+RfTq9DSOstxGRDcS9dV9rU3xRw1+3029dRbU8TWRp5TgoE4v6Rkf3YDVnn7TxfqzP6KWlfNxPQhVossSNIWMXKYm6B3MN+1EVDEIX5CpW6z34zIIsnRzbb1AyxqCamgnmaJcizYGzgo3tflw9V6PLY4UOjt8sxIfP7qApmYw9iV01nTBf0k4QAABjvx+1Shi/8qcZRdQGGWdkGrgtm8GIci3YGmlk8a2N99I6QDMep7l+
 2m1tAITm
 qDQqWv4MwRceynW7dV5ew4TEYcih132x26t+iGMkL1g2CFDKf9fJaIwh95Fe2KGOiFCLuuw/TC04gvWtcUv6g81nTZb4ytMKqGBuLLo4ly5RcAMekl6tQ8YkHsyACyHoeP6IvwL69zPnKEeBmbUqfgXY/4s8OGwvfJh7oh79ZikkTW9x/lNunVEwBxzcs4q1yT+2C0Lgia5guQhWR6OEGa7xYWwxS06YriCChA2CUhMjmumtGlR9EYa1RKBc/Kd4S7ofzkbNSslq9cHs3Bx2MJfYlXsw01Bb+YvArWuTwADYOrEeF3UFHGEA3Eyl9kiU7iUCkHkkZS101gNp3mjkuVXFTUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing 'Y' to the commit_inputs parameter of DAMON_RECLAIM and
DAMON_LRU_SORT, and writing other parameters before the commit_inputs
request is completely processed can cause race conditions.  While the
consequence can be bad, the documentation is not clearly describing
that.  Add clear warnings.

The issue was discovered [1,2] by sashiko.

[1] https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org
[2] https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org

Changes from RFC
(https://lore.kernel.org/20260328172415.49940-1-sj@kernel.org)
- Wordsmith.
- Rebase to latest mm-new.

SeongJae Park (2):
  Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates
    race
  Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param
    updates race

 Documentation/admin-guide/mm/damon/lru_sort.rst | 4 ++++
 Documentation/admin-guide/mm/damon/reclaim.rst  | 4 ++++
 2 files changed, 8 insertions(+)


base-commit: b761d53965a239abe1469f2e4e2d4f7d69fac9bd
-- 
2.47.3

