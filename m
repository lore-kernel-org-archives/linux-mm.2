Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C28A4FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 20:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A769B6B0088; Sat, 25 Apr 2026 16:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF5E6B008A; Sat, 25 Apr 2026 16:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EEA76B008C; Sat, 25 Apr 2026 16:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD7F6B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:24:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CB574038E
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:24:53 +0000 (UTC)
X-FDA: 84698206866.29.BFE890D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8C270C000E
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:24:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kr4kLGcz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777148691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rTk8CMOri8tGHWee5nrOt2ZjV+8IR82yi+Gf3ddfiq0=;
	b=MMuqpynGQ5yyhx3t7txDJc8/DusSIjegunbDJ1iAVm3xnIM8Ag2kjJnW2xki++QOaEgMsM
	xGT9wlnfV1zaXdupgshgYadV+lqSDiy+Jo1E/elR1BwG2ljnJ46AuzGXONylL8N0G+q0c/
	ICHhAr/BzRnxMjhiawsGacC2yJgzgX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777148691; a=rsa-sha256;
	cv=none;
	b=BFb71g3D0PW4P0l3gFuuLnedDz7C8jD74Zg0KtTAkX0hBvACj0v1m85xWaDJnZPS/9M+5v
	DB7JJrgnV4EpjmMXpR9OMK/7xLL206frCUkxSoa57c7bXmikLtZJLhfc1/egxhV7HvgH07
	h9BTEOvjHMi7AHWSBr7R/ZyuU/0qB6E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kr4kLGcz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD6E760055;
	Sat, 25 Apr 2026 20:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE4AC2BCB3;
	Sat, 25 Apr 2026 20:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777148690;
	bh=ZxomxQePr7AKqbVr8jYWuTL2wbyw82jIcBeFpsB83ZM=;
	h=From:To:Cc:Subject:Date:From;
	b=Kr4kLGcznmVP0L1rZP2VjW4Zfh/wHYrk6Kl855ccaB1ty73vkAwZnvIOPUQ3waZit
	 Xc34bRh9XdKhKW2NYToGQPbzwyzPpAjH5V1+1kTiGREllW85+aVcLtgO2niN0MVprV
	 3H3+XmSj2DFSG4TmQBbIrLTdpMOmwcnceaPsMoHASMU5kAc9nPxOaWbSue2xHAkqnV
	 naUmtvLsl/8J+yPCCxM8SFSRdd9IXX2SBiCR4oO2jx3MhlPU2nrHRNVN/gfUA9E7oK
	 y5qEcb9msNlDhG8rXjQf5/unVAsDXmanlKu/At9e1Lpg9vvfiY3/Ueel2f09KkioNN
	 gAm7SLYzhPEnQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 3 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/sysfs-schemes: call missing mem_cgroup_iter_break()
Date: Sat, 25 Apr 2026 13:24:44 -0700
Message-ID: <20260425202446.108095-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C270C000E
X-Rspamd-Server: rspam04
X-Stat-Signature: jfemh38guma5mz1swkz4kic7t6at18sr
X-HE-Tag: 1777148691-155809
X-HE-Meta: U2FsdGVkX1/RwE6SSRke83VcLh4QOSgCKC/W/TLLv2OfO7DhEbgH1az/aO6LPEKzLFLvwYNUlwEyuhFvfWgh/LNSI7slnggtOif3AEMCZJhf24oEYmyz3U0iYbd7zLHFZnA+8u5/OcdTNwXkHZFsyDzI2nAXUP3O6gTgtkFbz486BwdQDFBxSVVCsROGDUREPE0P1BShM7Opk6PirB+uoHuRxxnHrlDsXArd2JuN/uTMOly1ujCD7Gx2mpK+vpca3ThGBo7MPgikh5S6qrW32AJINwJ2lxEPXvzFzN1x4TZfxG+ZPG2yRGV/8gTITsY4JDO7MORmi4t+oWA9u6mRqHkDPMKYXAus5sl8swOMYYQlN7rw+FHQnll92qotyfFs/jVfkQ6tP5WCRm68bOtoLsHR9JVz4anMKKUZrELl0WvqM3J28vJJ+AtOg+YfFz9m8iArIrVvJxtHUol0TmnmSTc6mqxCcxfyKuUSUyCtTOdxNMYXGPTLLIKHbl9kKW8aqpoGfKZQT2HHdLqhqeK5j3uSM5ZHBDnjcYFTMi6ujGgTVjch5vvryb40hRG00PYz6DLV95dbSyb8NIq0UgR3u9GcBqOtVFv2K5VcCB8imOB2ZeGsZSg1pBsUmR8cuybQlT3x7iiTM0FnR6NG5hxRbpXsDHQRxbQCRZmCnS9L4hQx5eqw37RU99nk5t/Tz0s/Jbsu7xKKpbw6OjRfs7JHwi7xIlPAUC+6CcTXkbiVGqrELr8xCEi+NkwdA8WJmRlhOKnRVR7oFuJIyLPM1g0dl4CAorbA3I+m9Wkma4qs37wMpvm2/AEadNTIvM8DDLNCU+rbtg48rEMfoh1E88UujsiQyQfTzBEZdCftwf3xhbiz5s6r52n6HnZKZAAe9zP7RqnL//lxbvhBjzs7PaK+Hm3v0o1tSrOQwkDS5Ppiw93Cra32qyofTa+mSR4Ib0bGD66MCBqxSElH+i7MYRI
 BTuQ5mAt
 qSoTvBN4/3xqDabadeu4Pk2vywoQgGTPbLVfvxGFKHiifg0Nxq9Nt72fA9pbcqBWEaNUttjBwGhyUcBzYfBz8XIhnYuJ2CGx7V1ALWKNUaU0o6VyLa6VFQqFrIZSsvFbHw59Y+A1/nRSDlQz9ZeSQgtB7II9VzaJiXViVaX92c3C7Eonz9P1QwaWCiLeKSP+wxMqVCHfDi5Z5udDtlditalZ0m5rltT3rkdL8GI5uO3FJXMTBsrevFXYFkX2QUtaytzfHrWhYbhcj9Cdnu3TY/iodJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_memcg_path_to_id() breaks mem_cgroup_iter() loop without
calling mem_cgroup_iter_break().  This leaks the cgroup reference.  Fix
the issue by calling mem_cgroup_iter_break() before the break.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260423004148.74722-1-sj@kernel.org

Fixes: 29cbb9a13f05 ("mm/damon/sysfs-schemes: implement scheme filters")
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 245d63808411a..04746cbb33272 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2594,6 +2594,7 @@ static int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
 			*id = mem_cgroup_id(memcg);
 			found = true;
+			mem_cgroup_iter_break(NULL, memcg);
 			break;
 		}
 	}

base-commit: 8aa462c5a7540f9f8882cf8fa6add712fdf38c91
-- 
2.47.3

