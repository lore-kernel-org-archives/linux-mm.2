Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F36C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 683F86B00A2; Wed,  2 Sep 2026 01:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659006B00A3; Wed,  2 Sep 2026 01:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571BC6B00A4; Wed,  2 Sep 2026 01:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38A9C6B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:48:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C395C4074C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:48:01 +0000 (UTC)
X-FDA: 85167741162.18.330CF5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4612340006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:48:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJBD+xhb;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328080;
	b=eS8NaDsa426m5Ipc77e3f9DSOodvKpbeXq9n6wzoygPVQ47TazHx40eOjuN23gSjmD+ZcK
	eLNoAZ4YSo8KUFG7XIM0tfyuTc0kKufCMwi392tpWyPeLbSTUu4N1qNvKp8fCS6FdNEKUK
	fCMyP+Lq4OCAAIj47fS4jveW8yErgGU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJBD+xhb;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTkFqCNT/LseVbtXKhwVw4AevH2QQucXk6b0DrI2IK0=;
	b=H1WAiH8IwC/yxYxn6N6+zqmnceH+LQ/4A74lNL8q1ZUj9Ap/mO5XfoC/vPCyZ/hZl7vg8m
	LU4S+A542BBbO46TR38WrysTn93yVKOtXM2B6ecqIyblaFHHSXj4tchJxf7xHFIRv+Tvo/
	HvOtTnUKvI10fsd3Mug1D1QUmfhjLZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBBDF602D3;
	Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307D91F00A3A;
	Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328079;
	bh=FTkFqCNT/LseVbtXKhwVw4AevH2QQucXk6b0DrI2IK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJBD+xhbGsbTbi8FntI+zlKjLKAHwo5WB2UcnafQzV8jHHYe5RCEmLlQ+PohvNbt0
	 EazBZCYqe9sA55ZsKS/mhMtCUHty+EnfSWeGOo9VwXf8ZgxbrlZLQUz2re0efopegt
	 y4FuWHEi7R2ofbeC7dWcs9ztWVGtQ2RpGyL+jlmTzIye55vYmFhmPlaM2Kdnafepn+
	 pAtMlZUHonTYibPaqirBAR+Fx69M2mIxvFTSERvzX6WuuHtUHpSemPLPVRiCq58Mb+
	 lin32ZCuP+S3UiCMKwqRe3QPV2jQDZ/sjXzQn2j34DvAv7TNXnlRj3vUTxZhoLPShS
	 xvEdWNVNsVMmg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/12] Docs/ABI/damon: recommend subsystem doc instead of admin-guide
Date: Tue,  1 Sep 2026 22:47:45 -0700
Message-ID: <20260902054747.99370-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4612340006
X-Stat-Signature: hae3j44qq37c5zdijegu4igf58ozhyf1
X-HE-Tag: 1788328080-814647
X-HE-Meta: U2FsdGVkX18ItHOUVbbzkSaSadGT70aYSQ2Jj6hvQ6Qve/kQLIs6g/D0BEiN+ytyBeLcKJ2mfT4UXcoCBu1hz5KxFyF+l4/bN1wi39wYJQcqUjojndDYzgFYrtrgQXu9umkE4YLZvdHcnJu4yeAYwLtI7xXFSRXYaEC0byY7SQWKwLQKHelRKMpRWj7WsjwVC6N0o8Cj3nAHex22ajtX9EahxNR0SMD8XQnR7lmz+uzUVQGWYbKjpnkp+9t6zwjUBD1OnNKsPlbm7sUTKlHgFqpvmRx7oNLOJWvlgr8+e6pqu0xHPSzwYq+CPszTUXk/B1VLSpXP6n+4vcAs9rH6HZZwbLAVuARdUvTwC1aeqyyMI1EvzeXr8o/25zYxRS1Il0P4aY20HTwnFmuF1C7yizZ9/Mig+K8v3anQENYHjPiqcQ9xuxvpGqiM/InKdnmiI0H9Bu4j5KzQt2HSC1FZAPl49UXq6430CdtQz/iKYgBpjhmAWl+9lvn3av6Os0dEzZ5xNq47iz70zKklHnvEaGm3sXG+0aXVZ3EmA4SE+5yDdhFqPEPl7m2e5XcFDc6/NhDHTHsi73vn0jMmiawCT7ou5k4/4Is8ge5gI859r1z+LaiwC4fu5LXQXmGmPPjHXAf1tEDILPap24l+mzMPqs53xuhnQMZ/8pbCw6bKqxFepzx1ljIn8X+60bDzkHgW54/iw4Am4OCWlus+KT3pgD3AJ94JTsjBEHTcSmfz7U5sjAVqaso/cxhWIQjEuWxCE0wUDE6nyBfQnFLRM5HAnVahVmz7dT47o4PIQm6G6t42p4P3a0UZfL5DZpBz73aIaGTfSTqD6GNUJBaoEYp29lcNh5X8uWhKWldecZderaazbQIFJRAA82P+dZQIhkfHeuwU5SbCnpSaxhcwmhkqX3lKw5Z6KJPDnoki1I+po0geJUu4GRcgxYihM5kbNsd3ViyfgroFuTBT0WP3WnO
 oua5IF3/
 7m9bV7F1+h8zNN92Qb3J45DHHyOckCHw20IxzZOMBlSY4zPO24DiAkoV/W5xr/2zrgKHrVC0jcEItiknLz1vnYpIZQ4PDtyihd/XAYAJOWKYTz6GzcAbC7VEweBLdZ9htFbWCFGem/XVKbh5g17Ls7iObGhBa6nCiJcK3227OAZcMfSMuXBDdT5aH5+ggqtx07jnpkwUOOYX7FGT2N1pwhr53tcx0XFLxyfu7TvVTvMwlX9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON ABI doc is recommending DAMON admin-guide for people who are
willing to know further about DAMON.  Nowadays the subsystem doc
(Documentation/mm/damon) is a more recommended place for even beginners.
Recommend the subsystem doc over admin-guide.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index f8d2601e82904..ad21f58f3c912 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -3,7 +3,7 @@ Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
 Description:	Interface for Data Access MONitoring (DAMON).  Contains files
 		for controlling DAMON.  For more details on DAMON itself,
-		please refer to Documentation/admin-guide/mm/damon/index.rst.
+		please refer to Documentation/mm/damon/index.rst.
 
 What:		/sys/kernel/mm/damon/admin/
 Date:		Mar 2022
-- 
2.47.3

