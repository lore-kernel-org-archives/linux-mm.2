Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7ACE607AF05
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mNUo2i26
Received: by kanga.kvack.org (Postfix)
	id CC9986B00F4; Mon, 19 Oct 2026 12:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7AAF6B00F5; Mon, 19 Oct 2026 12:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69776B00F6; Mon, 19 Oct 2026 12:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE5D6B00F4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:06:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A32D40767
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:06:20 +0000 (UTC)
X-FDA: 85339852920.30.51BEED9
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6821210000E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:06:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mNUo2i26;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425978;
	b=fRmItx50cqEn+HzeDrg9gbPY1ckuzjw/k0J/OulP8DqAg+vWYbz2iiApVI4llPkflvPg6W
	5qJkzeURzVBOPfJI0znfUUkidr0BYsx97uGCHgYiaVe7jgG9xtNdqc2/My0cqz6/SXftKz
	llwYOfy9/qyCj2fOW7G7THuLfDYgkGs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mNUo2i26;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=E9RGSCGYGB/E4l/ib4WPi1HDJ9J2vhJoK5I5QF5CWgQ=;
	b=dfKoNT9WTDdjlFXRen8vK+5DqhKpW7xY6kPK87lyv8W4ehnjKqQDDFTcZ21LKEu/AZ1CRL
	hVjWR1wSgmgqrqVubZQ9xReRAppOW4qo0aswp2tkyiU3ceUOSQIf3BCezl7oInspkB3P6U
	i/zXa1u8TKj2B1H9Y77LXCM9ThNcFJM=
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6deb848ddd7so1473832eaf.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792425977; x=1793030777; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=E9RGSCGYGB/E4l/ib4WPi1HDJ9J2vhJoK5I5QF5CWgQ=;
        b=mNUo2i26UhT9aEU2F3w4fI+7oqewQDa19NrbT3OROptL4LAnBcHz83diFjRMmgRVES
         iIc+jZOslVh55oRZkRNyP6XE1+P4SKWJABCHT5cvMqpmIZJsXQQM0pRAlQCHeHx+Qn4T
         WekyH7tS4HyocfvtCFk9hLVFP7EAiXqUH7SN0mKDWH+QHAt0SR5REn0mzt03SpPdSwbw
         bRq8pbJgfvK6GM29BvxQsxNYyUt5b9wDdWvW8lC6DK+qMbN0eUmzOZdcwbhsUJGxU/u2
         l4lGjYV26Bz8xpPkgLib3UBmco2Pg18k10y9WwHoC8khNZ2uZBFvWT4XCMRSZcGfGd2A
         P0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792425977; x=1793030777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E9RGSCGYGB/E4l/ib4WPi1HDJ9J2vhJoK5I5QF5CWgQ=;
        b=p7vVRoaqFLOZmNymDyEIBQhHBP43lg0Raqzq3l2jz7sA8cqAf2ViR4yHcRYph3bWO/
         KtuXMW5+t8v2U0z3XrqOkqPG/5hjTLHUzXgxjvIwyL1XhgzdMZOWOWf5bOK+Qxo+xzZM
         wJazbs/bvUyUbMfRSG4X+9Pcbcr8BCnMt3J25Fh6w5Y6Koy8E1nwcCx3e9fwmEIx9/D5
         acez6k0b+URdin/LIdTTNjhWIRhuU3wYi6ZgO1YI0TVcJzHELCwG/pmJmRnW0HEsQGT4
         +TBvt2LQZ4dRJexeDoV03GNx1ErFb/86V2sWUmdr5EoQy428u0GBsqh42uKqY7rqbP1L
         XF0g==
X-Forwarded-Encrypted: i=1; AKwUvBz3VKtLMxAJL4S+taUi7hlLE2yMzfX4wvfTZDd8VP6V7WUhqVIkDIzuF3NSxfiRsWLD7uTAqiKy6g==@kvack.org
X-Gm-Message-State: AFq9FYLLxYCWRVdmxSb5vKgBKQ50ATJ+YrP85GHJFTGh+8BpuEOQaROp
	ojAyGIdHbYZHCIu8mXWCg+tA6t53BJsx62BPk4ZtSUGEMaLWIvSVXygzZtLSNv5T
X-Gm-Gg: AYBFou0ijGhZsSb1tyQjah45/A7wOVaHd79p7C/qmdQey3ZkT4ExMyT90UygxP5Nnth
	V7I8Ei9tlE2J/CHN85HY58nnrHUfiH8yIiwTmgfmKnk1STNA/fKrpF1tQnRwL/Ios5zXESur6UP
	hjKhliUY7DgJEEL4mul/Anyor12bfMwamzUIBglPoJZnhPVQjW2qrHYFRZ3pBn0CAdVd4dBGn2q
	EIDJ/CAmA0YSmiD7qvoIsMRvcLgNK1ESdwOyjKDrsXt+AijFPLvKy8+S/KnZmjXxmPoEMSFZeP+
	34N+qYh5fckX9RuNb5kirt8XCP7WjffW16qC6LLXUZKcv+AdlSV66Mi7FhgiZSidv4BMmMGH2Xz
	wyaViPeG13mY2tjTCOtjHGB89c0BEclk8k5QdDq4kJ8kBI1FUAcfCYAl5VdtMfOeckaYmYB9Sbc
	UIzEA0gggH2gjFg3bEMNBwvs1qIovnK/uSzIFGbROon1ti50+9kP7m6hvr8xaBu36quwj23GVA6
	A7S6IDqbPqYAfMwNjPUTe+CZV4LTFQ/NYiQyq4uH36B3WWsUJ+yVtWth5z3HrdLdrsIJoFY0cZy
	A7S5/Q==
X-Received: by 2002:a05:6820:4b09:b0:702:31a1:9049 with SMTP id 006d021491bc7-70356aa41b7mr5416083eaf.36.1792425977222;
        Mon, 19 Oct 2026 09:06:17 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a73b63cff2sm8248666fac.7.2026.10.19.09.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:06:16 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm, swap: revalidate populated clusters before scanning
Date: Mon, 19 Oct 2026 09:06:15 -0700
Message-ID: <20261019160615.2348500-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6821210000E
X-Stat-Signature: pmpx1iscm9okwk8e6fd8ea6dodgtgjiu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792425978-972416
X-HE-Meta: U2FsdGVkX1+39pYjnkS3fPxXfthpYKW9+QmPqfHa09vxgtOnE7VstPqPeNvj3wro68lmvDFPmCGoJ+dYcejh5qCockd0Za9M1KF6Xjl0+driJVw/xrk9oHfPoStt11tM163YRBCC5S0BBLEWoebIcxb+jjhESdYdnfP+E6Rp/ta1RYgp90/m4sZvHY7BTDabF9X5AR9BTloCwztTaxrdKUidraYFHjlEi3cTYMf1x1eVNC+TiQk4s48mR/vmv1uBzfLvVzfqH8V7Ze1z60+2Htjdy3BKYV5CNx9pTmRY2mWW5wfT4E19FUVJxbjFEFkm6T12OfYFUJhwZmvMZEs7aYharlb52GAR1KO4yuNKsFzDxfkAN1jxj7ElLMMIS99PJfK77frHzQrKg3SSTXrb3et6h6DMjMbCkBcYjLO2pXbWmv+76SyAtu8R7DGheFiOuE9ZEzpyyhXc28M1pzTHOoGtN3fsd8/xjIB/yAdsnhTgJ5EZfQHoaQGZ5K+qgfBg1A32upBKwRT2Hwx5xJOqkFY7SefR7qppASbXH9f3UXilhBB7mS/VlQpnnx8s/GBSkSYlgn+J51Kati0W5ACH03IzfY4l8hgIEeyzsArX6iS6qW2VRj6RNSZ9ca35YLCkGgfzWqA4zJS91aFhONFVosqSGQ9GqN21X6DcPfTfJaHT/uhKdYKH7hL6l/sJDSCRSWiFe8dudR2zoUN3TWwUJn0cIHSi6OCxQl1HKUE4mKg1sMfrXrboPEa9BWLrMagQXxKJ08nNXqVtTn70qJBVxFWl7GKdlKMVgFc3d/MiymNc8kJ3BVX+gdJydKkneMC06383NN184dfBiVTCZn2c7oyAboqQ7oeTTH1YZG3HQ9Jb5bGRy84bb97maUtd+y/OyioNGWrFeXQbfm6tATCdS4mYKMVLdvo7hbgof6aLrSJdD6+8ZVYSc9/C6U1h9r2KwdApA/E5cUiFNjBPZtC
 WadfgLW3
 w9ZEAXaHQWgHaOnqlYuXbdJQ7iEEMrVKcHcEPJ6T0fV7+kamUoljs5odu/eJBLch1d9Z0Ckn1Ri9RMPFczYbEJ3sS0hyE7ofakUgWJI8uPm3hofUvWypPkic8dEy54zbqs51GGhAXgrBH81BvfwCsqKlhQixCYSqV22wpCkEM3RiJrxyAaqNeWRyAtzrIugrF6K89gSnqmE8mvHBRbPCpfQZJqVgiLw/meDY5/nR6uEnsGhc3WS/Mt08wudHKKDmE5rgcB8rwdX8BG/3QSlx4/BOfqXI6Ewc4j1lTLkbG9b6dYVY0x2K2Bwferd/k1KxLhoJXYKmItrUoVKoepD6loxeeKft5c4ZAQbA/xrQvje5OCTYi8RGT07SnJfQmpSoVviYe5DY1Khpk6vSxOKSqESJN69fTf+tE13SNrW1BsnApiBXJFlUXy0ccXinr2tY9a6dX/glSnMWHqEhiorTmpx99fGwW88WXn681zRpYZ0soM64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

swap_cluster_populate() can publish a cluster's table with the cluster
lock dropped. A cached allocator can use and empty it before the
populating allocator reacquires the lock. The resumed scan can then
dereference a NULL table.

For example, CPU1 can retain a cached cluster offset on an SSD with
per-page discard disabled:

    CPU0                          CPU1
    ----                          ----
    swap_cluster_populate()
      swap_cluster_alloc_table() fails
      spin_unlock(&ci->lock)
      local_unlock(&percpu_swap_cluster.lock)
      swap_cluster_alloc_table()
        rcu_assign_pointer(ci->table, table)
                                  swap_alloc_fast()
                                  local_unlock(&percpu_swap_cluster.lock)
                                  mem_cgroup_try_charge_swap() fails
                                  swap_cache_del_folio()
                                    __swap_cluster_free_entries()
                                      free_cluster()
                                        __free_cluster()
                                          swap_cluster_free_table()
                                            rcu_assign_pointer(..., NULL)
      local_lock(&percpu_swap_cluster.lock)
      spin_lock(&ci->lock)
      return ci
    alloc_swap_scan_cluster()
      cluster_scan_range()
        __swap_table_get()

Reject an unusable cluster under its lock before scanning it. Relocate
it only while its table is present.

Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c3288910b3e3..988b7316e0a1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -981,7 +981,11 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
-	VM_WARN_ON(!cluster_is_usable(ci, order));
+	if (!cluster_is_usable(ci, order)) {
+		if (cluster_table_is_alloced(ci))
+			relocate_cluster(si, ci);
+		goto out_unlock;
+	}
 
 	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
@@ -1010,6 +1014,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	}
 out:
 	relocate_cluster(si, ci);
+out_unlock:
 	swap_cluster_unlock(ci);
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);

base-commit: 4dbe24720eb3811563cd56b35d87ddf3f9beed2a
-- 
2.53.0-Meta


