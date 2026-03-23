Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89557D58CB1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 06:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FD06B0088; Mon, 23 Mar 2026 02:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16B76B0089; Mon, 23 Mar 2026 02:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A541F6B008A; Mon, 23 Mar 2026 02:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9814F6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:30:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34B4B1B8E4F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:30:13 +0000 (UTC)
X-FDA: 84576353106.29.313E95C
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4926D40007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:30:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O+ib6AyU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774247411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaMFHJ60YK2GwvhaQ2zq0URWS7aXAsOoU6EB4xwgTHE=;
	b=e3vGfgK9IEUPOXSKx8gcBKwMVoGIy7VxRfDdLrbMCbIY0WIsNvKZKayCYo79yJS+g4WL4N
	TGCb1Opr6RC253klJOywqT1uKM57jCwAdYt1MLkgXMtgvisAhFxtGmBdoTWS5rw8lVpd2H
	llVpDFm668vMSmcZHqD/FLyB9d7BHkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774247411; a=rsa-sha256;
	cv=none;
	b=Tta/ILU1iiYlho4sTNKQgK8WWiAqVzajbWLNZMxEwtioUXJEjnJrTbUjAYsy9N3umYZ03C
	ky+jV7Vrr8tkoQBKmyMxigw7uXT849P3qeYAsqKp/GGiGK7iPKjg3qeXDn5qBGBv4xFl67
	WsbSyGmsjVjmzzJpK7EGCc3aBw/DSBo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O+ib6AyU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-487035181a7so10591455e9.2
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774247410; x=1774852210; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZaMFHJ60YK2GwvhaQ2zq0URWS7aXAsOoU6EB4xwgTHE=;
        b=O+ib6AyUka849UhaEkf1Eo3uEUs13nV4b4BQk5GQt82iLPADdnnsIjr1iGXJvGp2s3
         QlnekyNGlrYaNshIA3cymXNKHPm7mCBIJ+R6sbE1udHxUB9lIDHO/GYS6cniZDZEJBh2
         aL/mYF6G6dX5zc0H6YJfS4+v3r/SHjSg7in+sdwSCxCCB4zlvNWvT4LzWDo+bmUgTS0s
         iEjKG4dPJDWX3fdpgfVqQ96BzWejMAchYv1qBkSRF091JQwyuj8mGYn0wnaaeGugBar0
         VMcKYHoZc21xaSV107islt69PnlQ/BBTGbgj0Z/GXVgN7X0bqKfKGxWuVlFu+omDDj6C
         2LEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774247410; x=1774852210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZaMFHJ60YK2GwvhaQ2zq0URWS7aXAsOoU6EB4xwgTHE=;
        b=K4Hut6CEoyKLenDXWuvAFNKryfdraqLSLOCTN20PzVAwI8MyHQnsCEbBr9ogXp6OFX
         gTgGXsktQQ5+219uHn3ZAtxQoiDM+h0lX6eLeXJSrVtPMgYdYkW7SSUm68zXtfGIzYpG
         Ne8DAUxDf02+8BAwKHdGnEYeA1tU/L4uP155po8X4ABCUUz4zRwI/kZR+CDo8hBVlOif
         0HKvxL/Fyj9pv7DsBS6+zvZqAmdW5li8YxqG0vu+TKmZAmqoQzodEDamc42GcKf/XFFs
         3QD17HBGOm47fYC+0aDf77gbmKSWamZx2wVPBoT6uz9dszdy+TTQy6WA3QU8++VtvZkR
         MsXw==
X-Gm-Message-State: AOJu0YyfFLYpXqvquLVM1+0rEqDQLr1yZKcHtZnMN5tTVtdq5veZBM5Q
	tZ9B03ZXVP5lmgPU315aplR25s6GG7uut0d9Biw7sCFnhc41kcRxyEJC
X-Gm-Gg: ATEYQzxalfeoJ/aHPqyp9TsDgkzP69Ppb4A1Ebhx6nTb9DQZLf/TaFLijQuNPKhfrIp
	bJCC73N1+lVEkvPmny3W8qaYXfD4ZLqDZAs0JOevw/C260ZSSIIvWjDy4/2y3tkbDol0BCQuITq
	iu9NFBtLpeaKCLboO4E/qSKhDg8s8mSv2WFV+o1Oza9kF1kd3xa42MPOgk93IP5KdePPeCzqJp+
	AMrTimgSzZL3gWRqw4WYpp/Cxs/TAIWYfYntm7ajKMmEKC1H75wP8gqn03NkFP8kcQwyLhq5Tbd
	7/q8L9OBgjlapCR4mr2BiZdZUKYwdidcExGKxKOIahFX4ZdWPioWwhtY1OwAG90LNA0S1A84pRS
	iycBa4FHTh23kxKGZFlPEuM9DbNbQE5T2yGsaStAa7cqeZN8xCpKvXkaz3N9jhb5M2IIZYTplJ1
	4WEtmlpbDci2Xi+dcflZNPVWF8yNysvXNw5PQ+3QDbaarNPAKRQ7JbM4Qebv3zsT937/+3kygpg
	FtgpiF5X1b4
X-Received: by 2002:a05:600c:4ecd:b0:486:fc61:541f with SMTP id 5b1f17b1804b1-486fee2e5b4mr144692445e9.29.1774247409649;
        Sun, 22 Mar 2026 23:30:09 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64714decsm24770769f8f.31.2026.03.22.23.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 23:30:09 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH] mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online() error path
Date: Mon, 23 Mar 2026 06:30:06 +0000
Message-ID: <20260323063007.7783-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260322080142.5834-1-devnexen@gmail.com>
References: <20260322080142.5834-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4926D40007
X-Stat-Signature: tkkjmpefo9kysnf6bune8cs4e3uz3egy
X-Rspam-User: 
X-HE-Tag: 1774247411-661028
X-HE-Meta: U2FsdGVkX192mWzxTeF4REbrqrIFuav+ctlcYmhUF/oNQAQq4EEZaEJlzWsBWsjb1ywD2njAGM4BIZH3GJlyD25UfW7FktqViV1bh+WtL64ySIizMWNCEivXoAMSHMRPJyc9T5zSKHGQWnIFYdfm5J+evEQ1sVNmIevT7/dHb+K+j+j6dUAwtK4F6giSjfwQgD0VAWqiVuG0fiKLEzAtK/7pDWDy5qfvRhKDvH8Lhr3kQ3iSudiqU/K1qbnOwnAteelNyEMMx8QuW8l4hrdydm9LNkHNNLPYsx2ocpNbsdS9YEcImq/4UQYYp96WDXVKRs0WvvCG0QMZUmCJpJoJ6DDz0flDTXGMRm0/yckKRw/cuqhPKhl1uJUbgZpmP4VtVZpA4nggxlFcL2k346VWFrRw9mXOULvvxnuoadq5Ppx+ocUvMpIUpYX3rAzWUkFfvNM2pg9C8554ojF5z6sPCGYsbSN8YFur2rgGw9NL03G4f/gwtMe0P/TWvHst8S88IAbpPa+aeZar8uVEivM2dfeOEGAZ+d+nTxj5bE5BQHwqHBxPVqNlfJocX3N+hqmXCErf8lyH7+XQLA5yecgDadAADN6UVKr8uDBYRi85X/IuCnVsjTy/wBVhQnqaTOltE9rW1d72w9ZyfN3H3abVD+JdPfAxYJA/K/yFpncEDgchFL1zHy5BHTULSTTQUOUvaIwzHlp8+iku41IpT3mkF7hA9UqlNUD8W1iRh9rybvJKbapZ0I8dFwR8iDsNt6VmHsx4DC7dLw0Er0BzTAZAd5MUaRwla+sfFISn2Y9toV8gNsAFvoB74DCrWCNpFeE0cKLewiT+9Q5o6p73ciNyO72985NeFLwVoHbPjNhI196CHvZbNqjB0hIIb0qBseCohCFQPlcBT57xdUBmAFmNxp5Vf4sa82sfgv1v03Bo+DJzlZKlVdS2tRTMDRRPpuluS2ysDhZvEAOyP8pcZDH
 Z73upJ6G
 auLbvICkniqdfh3MG/B5AODAfYiAPQSFHaOXN1Ol1hVKj3ZBC9k4XlOGKfs1Iw+tdxm9PIQkx4jlr3NxwWE53SD9KEV7E9vpdnEk1t5ocuKbrHXd+6UhK42PNRvf6aO2bzdRn1KftLFnEqptmM49adzqZGyVhB1STnksNwQnFSioicGcesX1Nf60hE6OvDH+S6+IL0vcEIcCOmTMZxwR4k4N18rzMsKyMCRRB98mSTqhsG8Uvt1QOfHbNIIypAj3+ktd0y89CL2Mc9FI7/BSsu2LDpCiv6InU6Kjr5CflMTlggXmzxU+paTskXLclrzwJzAmplalZxFnT0dtXkhxXgckv5DIWvpKPuW2r/WLnENg8eEkfaGi024gW3SGvBZ/iL0BCU25fomOz86HY9i7FnIy4M9L42kjt2vD7yxU2RzdnYU1UYCoIb8p59ZrXKyWVxbdXhUD603mKwNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When obj_cgroup_alloc() fails partway through the NUMA node loop in
mem_cgroup_css_online(), the free_objcg error path drops the extra
reference held by pn->orig_objcg but never kills the initial percpu_ref
from obj_cgroup_alloc() stored in pn->objcg.

Since css_offline is never called when css_online fails,
memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that
normally drops this initial reference never executes. The obj_cgroup and
its per-cpu ref allocations are leaked.

Clear pn->objcg via rcu_replace_pointer() and add the missing
percpu_ref_kill() in the error path, matching the normal teardown
sequence in memcg_reparent_objcgs().

Also add a NULL check for pn in __mem_cgroup_free() to prevent a NULL
pointer dereference when alloc_mem_cgroup_per_node_info() fails partway
through the node loop in mem_cgroup_alloc().

Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..e361f42464ef 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3936,6 +3936,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 	for_each_node(node) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
+		if (!pn)
+			continue;
 
 		obj_cgroup_put(pn->orig_objcg);
 		free_mem_cgroup_per_node_info(pn);
@@ -4137,8 +4139,12 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 free_objcg:
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+		objcg = rcu_replace_pointer(pn->objcg, NULL, true);
+
+		if (objcg)
+			percpu_ref_kill(&objcg->refcnt);
 
-		if (pn && pn->orig_objcg) {
+		if (pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
 			/*
 			 * Reset pn->orig_objcg to NULL to prevent
-- 
2.53.0


