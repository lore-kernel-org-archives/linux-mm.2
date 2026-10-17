Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04BECC6B2A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 05:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5C46B008C; Sat, 17 Oct 2026 01:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71A186B0092; Sat, 17 Oct 2026 01:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A8E6B0095; Sat, 17 Oct 2026 01:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 207786B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:09:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A21631601F3
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:09:34 +0000 (UTC)
X-FDA: 85330940268.12.9E05BC1
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2A2FA0003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:09:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mYbVjHGU;
	spf=pass (imf25.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792213772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltltwVBtHl3kghO+WSesRQLC/X/BP4EIFkAkNpxFFq0=;
	b=sS4tYipbMhI6dJu5pSz1XYjMoBOAt2C8zxlGDFo0O/vpuXQ8YS63WMU7O6ZYmz/GW7Q2Mi
	5VfBhqYSPEvP7/ptp6RVHi5VW/8ecxkqId+sIce8KUJrhmR6A8rxqSIAkjfqzm3pRyXEIp
	wd0uSJkiij5tURUbZS7GW2hg5VR6OsU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792213772;
	b=aRtK8WCTsJcz0Q1C8WxejbDiqyjb4V24qSnkcSpq804+/Q6IAHs1YW5sQsHSdmO0o0OYyn
	fysMx9xke1LUiv9BKvdj+c8AW8tUEQncwIeY3L4DNgBwpgp759Nx9x4xQrf4J9qrNysIGK
	QGwfHhPkoA4ivOI9r1VVx2lotEsDfBs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mYbVjHGU;
	spf=pass (imf25.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-88b8f0a1bcdso408387b3a.3
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792213771; x=1792818571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ltltwVBtHl3kghO+WSesRQLC/X/BP4EIFkAkNpxFFq0=;
        b=mYbVjHGUSWrWH4EzreOfG9PX6NYGH03SpWtfDvn69jdnicT4VIpmSYql/ASOP5EieM
         kqJXI5NsPRatNKe2UO/Vmyf6abAqr2eSejYsO9+l+HmUQgOaJmC77zpwjiMOCVywp0YY
         ulTzqcCNcWx0vR8BEWItUT7k4Ne/h3nijxJxLFf/OFzTUgSuBvFZKj4m8/l/P3KtlRKJ
         YwUDRV1oN7NfN3xh+swSxGEBx8DzA538kT3ERChKALhhmPAYrxlR8MMP3oiXJ+HY5hge
         IDhowcHjLRsc2AKoRmj10I/FbLdwFYFPJFUNEsUlyzloZsRnLx2AWM65Y4HJlCDje3u6
         BBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792213771; x=1792818571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ltltwVBtHl3kghO+WSesRQLC/X/BP4EIFkAkNpxFFq0=;
        b=CdtJ1RP2FYPhgQS7bTVKhMNgH468ln3Iq2JDk/K60SPTkDBr6v+/RdzftawUGV8yR2
         78PV91KwGyQiKVS3zgdHD0p9mz/uwKidSGU/zZJ8+W00Mr7TE8OjnYxgp26JeUZihtRd
         E0OfDueuPY6E3T7w6KK+i/NnnKLMIwOUFbDM+2u+r6iturHm9cG4yMvS9jfO3yZctcQs
         oClZG1DtYRhU4H6fqdMD/OJk2ad48TSA5E67JXrpRlB0cSVcA3oDO5QRffXUJEVhOXFo
         T70T9dY+9KEeQLTM8M/9dsUr3sjfApGTxbghMlKbSfujBWu7R0Yg25U4Wh7k9CwxM7AQ
         zjSw==
X-Forwarded-Encrypted: i=1; AKwUvBzauUryeFM7fijlEWLZ0BtuwlE0LvCBRjei/WvvxJYI9zi+rd7Zbcc270cqFAegRWJnJuXQ+oDGDQ==@kvack.org
X-Gm-Message-State: AFq9FYJ5WRAkdd7TczkBwEbpWTVuEEuAwdhoaBb5AfxOPzLzb6Q/0dta
	wdbHqDBwbvxoVCvaLD6TYw7+kK6nJKHztZOLxEF5nKbqu6147esV4u3I
X-Gm-Gg: AYBFou3EzBSKmgJcWXl6x4H1/aL1oZ2Zx+7g5xlPg33RmgUo/kIV9OYqtuqYh5NW9yH
	kfqGGk6nMUDtqKKnfXtlkzFqQerQCpquB3yi4uWGotqSt0YN9JIDgMNwDIQRRUVSIBktXZ3AyO2
	yFBYTVuuuUdxGw1pEgBsCRswcttMnIYeCqfITvrFP6oTT1bHCstjqRkHTZ1NSPPGc/gbpXfhyHw
	APpLXBfGk+qD3ZB538+AF6I93ve2iJRZaiNgdv4YJgt6BTRBfnnXg0OVhSzFMVM0W/o3kOJk87G
	74xYIrZQ5izKGiUNzyU1G5MRIwgqcPORZvMGJviSztVmzfkh51+9naRbV87jkBnSo2tUAREprsF
	Z+ZscanVq8xoBsJuRpCcyTZt1BpWUO+jc2c0U63DIn06daVau5cJgpZ7AzQWY9Ld6tP7yUYg8Gt
	SrjBGM8x2ddSwdFB9WGAyD6P87QtJjhSmScqRyQJ9NOSwI0Sy9UVbUf6UzALEXhau8AZNRy+bVu
	7nAgpA2s1NcZDL2sNOobKi01vehwWAF/OoLUtrKFrx3WSnZluHldXAlVY6z4wbnVmUUPWw46A6K
	G/Ezr0wyih56QTYSIlFYbtNjoKXmOMqBEPgQ9XvO3cbecECPGDfjnMHuMWcx8v42JwKxVcVA4t4
	w0hP3VZtTGQ==
X-Received: by 2002:a05:6a20:d48d:b0:3cc:8f53:26c0 with SMTP id adf61e73a8af0-3e225fe541amr1150821637.17.1792213771457;
        Fri, 16 Oct 2026 22:09:31 -0700 (PDT)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89febdc2209sm1446036b3a.33.2026.10.16.22.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 22:09:31 -0700 (PDT)
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
	stable@vger.kernel.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
Date: Sat, 17 Oct 2026 05:09:28 +0000
Message-ID: <20261017050928.128582-2-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261017050928.128582-1-sidchintamaneni@gmail.com>
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jiop9o1hafq6bz9sqpgbgto8wjgjo6mi
X-Rspam-User: 
X-Rspamd-Queue-Id: D2A2FA0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1792213772-973637
X-HE-Meta: U2FsdGVkX19csMMeHRWTbfxL/+QwbcQEMdBSgTlTfHydjGQVj/9qZg3b1XIOLdlOKGH1ziU4FM/TIme4Kb4c3kXf0r45ta8xfUCW7tT8y3x6d/LDQltXzLAzYnZuGQyFs4EfySSChC4Yvx7Jdu5umOYhdEzNSazSqDsbHSu/Sl/Js4GlY0o6+XfmEDF/uqn9vTSNkJgwBYNOnaIdeHl1uXJFg7ne8SoabK2Jsuev01mU80D1KlbozVbrIkHkZHHxHTe4x7b2qE90KtbVJ4KVNb19J/olyxjqdr75g2RqPhbRdc6ws0xjXzOiGrAUYwp7iBk3CtFTiyMqfJO9qGrm9KU195AKgByJZdHt3Wx94iQDt0dJsZDkt5ifEOFl2n/rqBgO8k9TgQHLRvnLJGbGDmO56r0qFGiAUFOK+Y+egjk307Zgts9seofnjz4hv33MtNWsDdSF5ui0AT0hsgPTdREMJmq4MpYa0CFr0T4uTB3DyJpP+lHoPgErsVeptel/YPggorDY2WRrzqQHbe4qXmjYuUYgGajrxp1oXagRMGj8tNw3ef1QcNUwwhHjHGk/aPui3uaCyMg2caFq6iDg9ZQEwc0xndYh2+lvg9RJzn0VknhWtFafZgw6Tn9wfmiSgPhOQfzVzT4jM1vCWN1ZxFvhxwDahtWXkBOjounKbYirG7fZbTuaOLNeMbt+xTdx/m/tt/OePSQXotO1ARuwt2j6XKoyi0DUVL9aXBtsPgUabq6/wCsq9iSaunwinmbT/1Q6L7+7S2NJPChhXxnvFZhjiUlmScOdCfsqrFTiaaIEJzc5QaBUTcdOxpHmuxU4U8zJbDEz7qHDBCkM5cXoyDzBuAyXVBIMV1AC3v5ezjACg+yxxr/mU0CJWSRlOBtgJR207A/NAAq09OMTnnlZE9gc9pkkIFaBzkNtNKxpots5vxSQuxaHUAzPRc7BxBUZ24ZVnIzlrE8xFcZnDjg
 ZZ0hTC1e
 PzRQyUQRQhVer4B+a5Fw8mkJiHTgV6iUW7NqVIpElbphhwMK1BGWCSUkabCv21dlny9AWUtH+71j2e+vLsagAN8/z3dyua6dXip3faVo1G/lhhOcsjea3rf0f/YSi5FYIgSZbwdHmReczR8W4I7qpmsNbsjsoAidQu2iMS8vR5d1BqQjBBmgav0VNmdhJrDWBAyGMXeT2nQM9OvKkGhngqbyj6mFt0pAKdFVdbhljPg8NFQDPUPq0FKMplqd4sAMWasySEgRV9Lg6fi5JkGIApuehnDGL5XkkUXeP9AARcE2MXDULMU/xXErxAF6+M4Yy4dh2vXKwF2pMBO+iinFn46LCu+YfTj1E08jEx6RhGQQu1PtdMzIN4GGJqganKJylmla6dD9l1peCi6anhOhrJrMtqJ92agAfSwbWxOP/6NSGHMaM0es/b9w9s7sl6cbgvChKqc89oMCuU2A56m9B/wyNj8lQubd7KIUpQR5lF/CerEOGAnx/+VjfpQvrtGYx+gsD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton reported that get_lruvec() has the same problem as
lru_gen_shrink_node(): when memcg is disabled on the command line
(cgroup_disable=memory), it returns &pgdat->__lruvec directly and so
bypasses the initialization of lruvec->pgdat. The MGLRU debugfs
interface calls get_lruvec(), then dereferences the pgdat pointer in
lru_gen_seq_show() and other paths, so these can hit the same NULL
dereference.

Fixes: ec1c86b25f4b ("mm: multi-gen LRU: groundwork")
Cc: stable@vger.kernel.org # 6.2+
Assisted-by: LLM
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


