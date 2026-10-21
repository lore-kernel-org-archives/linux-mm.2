Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415F8606A323
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ELioA3Yj
Received: by kanga.kvack.org (Postfix)
	id 4B4346B07F9; Wed, 21 Oct 2026 19:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4656E6B07FA; Wed, 21 Oct 2026 19:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A626B07FB; Wed, 21 Oct 2026 19:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC016B07F9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:56:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E732A8056
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:56:24 +0000 (UTC)
X-FDA: 85348295088.10.D67EEF6
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id E7BA620005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:56:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ELioA3Yj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792626982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pdvW81URxK+kguHARyBfUJeLatdEBh9Apj6t7huNpcI=;
	b=Dqwf5giiu2q63httrw+Q7CTNnnWbu2NhNGIjyfrra8Fk+OxJqLfGqIYJC1KaChyRNYQ7Sc
	D35/v8Uukg9LiOVCCsSo4zDKHI7sxv09cw/u4/GZWcUvC1+uh2shSoiL72OREjrE03x7U/
	nPxR31w1V7kNewcd0VcBVNblozmjoPc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ELioA3Yj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792626982;
	b=zyUtF+OiBeTAFZvCZPCdRtarmv/+DhLPnTGzT9hKfkjOfQP92KbqGRlO5lJPcJtCGLxATJ
	iIBTH17e6UfrY9Fz3hL6X4OAZvvoLSmyeDh+be7zwlO1+WEpubWm0DRzvo7k316W/Zh7vf
	keV7y5djfytQRm9vGeelDR/VpgUHwbo=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a07078200fso544349b3a.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792626981; x=1793231781; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pdvW81URxK+kguHARyBfUJeLatdEBh9Apj6t7huNpcI=;
        b=ELioA3YjdHV+30fQYrz/qirYLiBZjVJXpjzFqxTi4T5Gqknvd/CFAULcxXNJNXbzWd
         UGOL4tdLciUZyWVjfRTwU4jyi36YjdBS0RGhtHpzlcxwkJ0nylmSV0F31+/kzWJ6/2DI
         o1+Z1gPJIiMspKhdPlD7x6UlO6jMV16SORItstQuqUKVuap8cccfHn2LrghePdXK6Z77
         /gJ8d1MfpeGXYV6j7N1CbP2EkZOSqiv3UByhkDTk5uAU2ul2Xm87wntdp3J25EFAbEs3
         s2NuoZey3wsuwYIbFXlpgbmhWj2sF8z8dr2JbdkOZbhg/bgfgyCz0Bonzo+I1GNIuCH8
         8EFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792626981; x=1793231781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pdvW81URxK+kguHARyBfUJeLatdEBh9Apj6t7huNpcI=;
        b=LbhMG9wqg3o7NZumGdcdcP6NMZFIvx47h4c4DPbhNb6I2XZ4eqOBWrpPykzjAmKW7P
         2Fn3yfVyT8hgJXDXnlRF/oMAP7HABX94eitew588rGkYnNaHa2sjdfcOFYheddj4oh7J
         +Re4/fWm+EIX1AG8DBMmLecCp/Eng57YO01Qv4HfoOBttBwGboeq+gVDlVMBr6IvFn9m
         b4bnqM1fo+KGdafNzl2Ry4kVZEsmyb05Ain4M5rlp/qqgnI0FtJK5V6gQoxTzzaFyZFp
         gehI8XZ8dbp+Qejatcb33oj9g6yYDNMWCuXUTFaDyjN8cd8gfZA3tS0mnqyeGD8WMfyl
         CDfA==
X-Forwarded-Encrypted: i=1; AKwUvByZGGut2l0xNuIrUOTpx/cZDxeu9uw3066E9b/N/alzZQT4sGUshqsg2VzO9cmdd0DZPBAMvACAEQ==@kvack.org
X-Gm-Message-State: AFq9FYIn6esQXp/O26eHGYjLkMkX9gKPGvh354atLKj9ZlMciM2yeGiq
	qaiaIBpRUJSIys2+7OQWBVC03VOTy9BV1VBwfR24Pcox1DJFbSiPatxW
X-Gm-Gg: AYBFou0oV46VA2CS+L0WFXlTYMd0q1dPpM0cUDgGg9wnKrukFU6oHx5bVE5YVX1H7Ei
	0DiDyl2lhPqMHlkAlfHpRCp40/Ou6zzMXBBreTzqu+5C4ykyuE5H5bKbHwdmaeqWjZUFI9wFKSo
	//rmzOll+pYuq/QKz/cyUpxRHJMEWfUSe0/ac9u70VeUkT+iW5yaa4eddsGkiFcRXnqRMVpCTq8
	yAqa1q6wOkgr4A3MVjmnu8MIwjGFfRwQQieg08TQPpbpo2VhKEApe5C70PmR2Pkjr0JupnCZth/
	rIrpxqHOmZf1/49QBdv3EWSm/Q7T+nC0xDE39oEcqsLVvFK2y6eUjDV9SGP/nj7W0VQ+a37K+7l
	79bOV0MKjZPpG0rMsSNBKHTTgLZPL3fGd1ssa0Vul7hXseITrXi8hZC8lm9aWp6/bAM/ZajCvQN
	VCFYFjytCNH1eR2i6w4Q2MHBO4Nu6hHhja68n1PDBI2V7Crltk7ljjLK/3tE0CXZ1FoqIFyTPMT
	1MUprBhweoeidxQCbi3LKojbDljQic40mXedcPBPwAjL9jcyaV6kD6F4zSOQsHu8beRlrN0YD85
	u4SiOqMb4NupqeeASANp8EU3LBYb4h1WoqUeGhLuew2pzDZfD6PILoDSmqLM/05LfTyFrcX6baB
	M/CT1wZpDB6IEbHWIrOY0n3JqxZuvnuyJYcz8bGiBAKbrIcrB6yTVPZoGXGN7ThV/HAE=
X-Received: by 2002:a05:6a21:3406:b0:3e1:482c:77ca with SMTP id adf61e73a8af0-3e287b9f8f7mr3134349637.5.1792626981460;
        Wed, 21 Oct 2026 16:56:21 -0700 (PDT)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895fa696sm1366733b3a.45.2026.10.21.16.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:56:20 -0700 (PDT)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	apais@microsoft.com,
	rlmenge@gmail.com,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: [PATCH v1 1/2] mm: multi-gen LRU: use mem_cgroup_lruvec() in get_lruvec()
Date: Wed, 21 Oct 2026 23:56:05 +0000
Message-ID: <20261021235606.89545-1-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7BA620005
X-Stat-Signature: apiifuhaeqkjdkswg6qid441dm9zoohj
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792626982-224318
X-HE-Meta: U2FsdGVkX18kd1fwWJD5qwE6g06LJZ8xKuC1nZe0tSb6xyrhfQEHAEPEaeaFVyuveLEbKGDQPTFLKfdx8d8wG7ikS7LckaDT5E3eSh9PZCSo3PJThUf3GW5Ezt9Y/0fgtKcs6mop9VRNvZUosEOrWEkopGPgaVNhNefMpofQNpDdOc0MlYo5s2nOE4CQzQkrBOW1aNcWTegrs8r8fn8WRvc3BNSRlF3QAjN5SYU6qMW69wHPnsOJwVHt0+1TLlv1xL/+YvL34JitjPOCo/Ucz5fk75wPkdYVMV+aGF9yQzp8VL2o6/PXYPMbTUq1kq1zb2wxFosBpSadsratSdpbdoOyblN9Cs753aEkVHSErcRJVaIsxUglFzjVdmQH6kqNTbGSQBwBkW9hwu6l2qn7DcDNUQmTBL3bvWq96CpGHtiEnz/7eLMAhh3AKpYCYltplZIntqC1yCkBNd+Ql+BsVudUJKgMt02wrjOs5ynMNrNSnt6xHDZyjl06ug/cHelSGx4C/JAcKw8qzT7DD8KRscFTuCZq1Y2/qb80DOxEEYbbBcuvd1I9QSLhIuCubMjBuqxUuL69EzQAqskfRVx8pVn51SCnSNdeE5HLJyTl+hXBtAgrjqhnFR8LGaL7H7XhCViHwUWVpr1F9yq08HQKwbe0DRSNDcbW489tf1gzGSmZm6Uvpql77A6/41zikrOLI7Bg4zbGixPYlrf9W7x5FrFxghxkMe32Hwq8zP50qHMt5YSiqacdocfyXmRs67sxPjsEhYpL1FLz45OTfHdCS+jQK5YS0LTXwA0JFG3EopwaFLW7hyHPBoxTF2Tl27Ki7FwEnOJVcNYgfyuMDEnzvpPUoa3bs/6jxYC7Ux+BK+gCk13+Q03XW+OVMux62jsuPPg9OhsMpzwXeiUYDm+ORwmNej/nOPuYYU34Wtkhx+cq+ga7af76VmEMXziWYsO38bxt0YKFKkRwmH46Yxi
 f9d7Z4+X
 5Pib6Q2ea5VNHYAhIEdzNzOrJK8XIb2DYljbneXdd5j/fLNzpZPSQiF9Ve89iUsMtQNRQhQF8m7a7fMlsBNbSZanDgilaC2v0DKHNX/cwBxiH4QjJPhUy3/GhLhviHW8QWLyOYxJECRTwI5swgmBTs8VodagfnpqkXiklwvsFnMM9Ja78GyL5zE3eNwLGUM0/XtO8skJ48GISNzfE84BAjDZZ/1J78ZPvApaciAFpXRP/PXLkVsrcua0hZNUnZxhWyJnvE4/bRSl9NLpoZTfqT7ffkVdwkTzm7G0kP41YXBJ1WR3Rax5W570LkSqPGGaJ9Dq1Al3reidnsm2Goa7MWWNuXhpb8Ab0JFSvIcmjTf4bPJtvUylMf/7WAfNbZYbqJAnJAHp1MvBTb0ano7N6VFyKqnYIEHWDa3DjEHWSORGy3egNp8hUXCZq8Ka6g3A8qQtvgLEL0HJKUghJlFsPh+NkLCQ9hPwsEpQsAe66HaqqyxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Andrew Morton noted that get_lruvec() has the same pattern as
lru_gen_shrink_node(): when memcg is disabled on the command line
(cgroup_disable=memory), it returns &pgdat->__lruvec directly instead of
going through mem_cgroup_lruvec(), which initializes lruvec->pgdat.

In practice all callers of get_lruvec() run after kswapd_init() has
already initialized pgdat->__lruvec.pgdat on every N_MEMORY node, so
this is not a runtime bug. Have get_lruvec() delegate to
mem_cgroup_lruvec() directly.

Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
---
 mm/vmscan.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0c57e4f1eb15..99e9f07fa2e1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2745,20 +2745,9 @@ static struct lruvec *get_lruvec(struct mem_cgroup *memcg, int nid)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 
-#ifdef CONFIG_MEMCG
-	if (memcg) {
-		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
-
-		/* see the comment in mem_cgroup_lruvec() */
-		if (!lruvec->pgdat)
-			lruvec->pgdat = pgdat;
-
-		return lruvec;
-	}
-#endif
-	VM_WARN_ON_ONCE(!mem_cgroup_disabled());
+	VM_WARN_ON_ONCE(!memcg && !mem_cgroup_disabled());
 
-	return &pgdat->__lruvec;
+	return mem_cgroup_lruvec(memcg, pgdat);
 }
 
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
-- 
2.45.4


