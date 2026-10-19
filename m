Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87DABCCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84176B0143; Mon, 19 Oct 2026 02:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5A586B0144; Mon, 19 Oct 2026 02:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970A26B0145; Mon, 19 Oct 2026 02:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 681056B0143
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:42:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7A991C3EBA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:42:37 +0000 (UTC)
X-FDA: 85338432354.26.9E47DB3
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2AEC120009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:42:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XCBaS6ev;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792392156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fCpTvdWPIdjGXF0xCoYGynFxh0LgUrYpyRnN0Oo9VE=;
	b=g5xFuGlGj+4dOfa//zJPZC2CWsvof9LIMgHOzscJ0snvEJXc2YcK7J8hk11+zda1lS0cUL
	dZyIf5Q5c6+ww2vozAm5okNFo+Qd+QosGwFJZ5ZJzAIpFcXj7sZj8ZBcg6ptTDLha5JzL/
	vp7Jcy7uKy7u/hzlq2mj7AFBdyUl/6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792392156;
	b=leyvH7XGIq4iVmW6jX+YZopxn+4gP8I3Jc9sjj8N6LkJaAF6ogTpR8GpJoLAICHTHBRHRi
	uzceq1XkBeWETb9Htws151qBy/tMatSjPWC5YqECFbN4mLpdEZ1zQy88XBfHJWeIO0XjsL
	8/OUMf43KGtGxAmAYy3Wjl1jsLCeeOE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XCBaS6ev;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cd61a2dfd7aso442227a12.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792392155; x=1792996955; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/fCpTvdWPIdjGXF0xCoYGynFxh0LgUrYpyRnN0Oo9VE=;
        b=XCBaS6evp+NJ3uTEh+As+IqzFyIJldm0l+O7qhCCjAavqkxe+0wt6DV0M5ZTm93gkR
         U0utMKLqiuAe0VhE5uILwUrMdUDqwLJVe1smukpWIZJowdkn/l2X5iro/xUjTxo6KWli
         w3P5PPZrid++NpkUD0zHyfVhwMaQC8nMOW4mwg9sHdbkyXUl2BBQHtM7atbEilU5IxH4
         nk09IsaVEb7WopypZ3CwOs/StkTRXe89FC1ZoMELb5scBl8N5M6KHY1shyb5UXUD7KVe
         Fwe+qiKn/W5/peBdJL087dZZFCgaRh1opdl4xPC1kfNbtTthiJY0Mi7Gn07GmpBIJ52Z
         REWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392155; x=1792996955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/fCpTvdWPIdjGXF0xCoYGynFxh0LgUrYpyRnN0Oo9VE=;
        b=DDD0ygkM1Gwp3H8nAUv1DQ0NUDf3ClxPuW3NDhMO0My6kpB0Q0venjop6cuN1UGlaK
         zaBgxdg8ZayzjuW6zvf1ndPvK4w5Qk3JjTFo829Mnw7NVDKpvTkXvJ4d8nsyd07qlwPg
         w8Nl1c9pea8801Aj1grxKMtym23y8HI3mo3YEJHXOv9bAdgFgvHaPSyShRdHHnSIpfYP
         XF6mem3NVnoECzZX+mgQWiBAwhUQO421jPZlUf4KwGTCm9msqzdHGbr/gKxRyTTrvsyH
         vvzTt6czZ12/Up0UgX6doFmmKfU5EoxUq8bIYuPqn/sfu7BUCSExRGpWcQCDWDM55nw2
         6YjQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLViKOs8BQzL/2YGLGBHLBbwkwG16wldj8kCRGrIUK9RwBPIFEeCKgbPK8k9B+1Cy+C6q7VqNfDw==@kvack.org
X-Gm-Message-State: AFq9FYJyrGtZ8mb+GG9awabFEQDALWWEzrWpW50oShHpOh7FGYBc9E0G
	LovISrXQtID3xe4wR09If57sM5BaQE5Sj52XwRCf+yhDBo+XuWA8tCxr
X-Gm-Gg: AYBFou1l/VRp+lgrT/Za5KQQ+mc1MoM9xb9XhL3R06unIBA53bTMAo4ZAWb6m1NnJXI
	OIwEzFV/DG7pYXLq+LY/Fr9uAe2z69hj3Q1cEfkxzeaJ6qP+/afm1CEf/FGOf+2EU4RM+qIklwx
	Gc+3+UiC81EgBSllE7Fwg8UIsp6s8lpVV2Ty3m9WOfRMDn0eHFwA/5sKzFO8NYSYv+NMEu3xfaF
	uFIq3cimKN9vpEsyzOlRjKIHBLrUDLkcFw6iOJVM0wDyv36puFJjIwCx1d0yWakiC9MyM6ROu9J
	WZsadT+NyKK5JObm+r0KCiiW3pJPNnRqrPbrUCEyCMZav9ZezT1nCCYHD/o51uzk9d3ZfwaLraq
	EtOvA2stgBR1sSTgzrl7QykDJhV4ZPPERnEdvED20sv9heP5R0X4odhjJ00NqypiYotGsAWO6gb
	7QfwHtDv3/+JW2VSp+4wEztRbrPeE3Zs+HiNPc6zpdNzspvRwMZVn4w+pc734pu3vtg0mq2vsZh
	82/AQKzvmqmvqFq8kwXUV/SMtPbcVnzoMgRLikN1rf3BVMLwCtGz6jMHrp/ywTpWGV0ag==
X-Received: by 2002:a17:90b:4c92:b0:3ab:b764:826c with SMTP id 98e67ed59e1d1-3acef134becmr6190292a91.12.1792392154938;
        Sun, 18 Oct 2026 23:42:34 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2100:3fed:6938:3f14:63eb:c479])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a3a592sm3688960a12.30.2026.10.18.23.42.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 23:42:34 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v3 bpf-next 1/5] sched: fix stale get_pref_llc() stub for !CONFIG_SCHED_CACHE
Date: Mon, 19 Oct 2026 14:41:53 +0800
Message-ID: <20261019064157.29885-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261019064157.29885-1-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9dnbipy9c4x9tyxp5wownpk5116jgnoc
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AEC120009
X-Rspamd-Server: rspam10
X-HE-Tag: 1792392156-117365
X-HE-Meta: U2FsdGVkX18j8EqyB97BgDaqqv6RA2fhIyLYI6s7g4KGxdGudyi5K+/MewDetFJqoyNvoduzBOPMe+ornkOWT3BbIceeQMy2puuwmA/riCLCG0o+wxKf/JkYDj6irH+uRdBRNjAxl2DGaXaWmiDr9hYNfmQGe1TeJYQp9LVMofOA9THedv92wqb5WJNGvC1f0B7rl+ji3Qzsw65ZlEI9eyafOC2q+MRkBaUR/qZLPhvhsYESbGJllLx1OKWAm3PhHpy9WvuvoV7DDdY1ztx1ReJ/7p9vUrcRvBzt+/9llsbZzlr2fhMbcEXKyiiWHSBsFethPTMGoERE3pGeLC9Ht9hfyd6/Kv12TsBN9JSwZcXJOIdI4ZrMGiAVL3WFc49DQBPcSinrpr8aGz7CbdHdZgiUUGK2mzMPylUyDhqUwkw84FcnxKxpTi4TpkzWmtiP0gcyLGVfXZtrdmUsTOXkPEE+gJ53UE0rh7+pWVx/IxkLMiPJbEm548Z4uTTUNQ2/B9bRmyPLph7UcESxjVJkJFSxjPHKpsf6QF9UBnDNoSvJteVXxCurs4tpEHSP1klJP6ZPO/2b7+yIPfKj8IMKjv+eO0sE+O48KXB4U6zq8Zq0ilrhCjvFvqSvdB9zI6NUOyBLAEw1+KE3yvNMoY7nUXbJtSloSZZhLRydgbEkHYtBJUhEq76v683jqaHul93Be/kAqxTG38PJoiXWiD7AqTPnFVkURHbzVY0rdaCC3XaOuw6y6bQlENZfdj1Uubpt/eX0iz+sUMDZyceuRpdNQTIW8esuPcL2jpG27E9PYetQqQPNxbDvtivK8D3gWA0RJtfBFPmGVPcNfYzDC28Vl9l1woZG8M3Ki3KDUu4ogSb1+fDaQ51TlzGYmGHAVJkaJ/DY+FK8m4Bycsu7fzz4qVLLYQo16A0YTvT1+eiA67fb201Fb2z3jJVGYqMlc7+6JVU15RsEQCQR/Ehw+xe
 IHh087bD
 uREW/3me3Jn80xzyRhvFtxjiDe4+pf7zKBd91PqL+oSeeIkuI2LB5ewBA2X+Cq0ZlW5Xb7Vj8GFZAfE38beixI9KgsWsbD4YNAbQde3p3fGynJCabi6AzYPcE3D7el2u/RqvOEDsgqdUZCQ+2hp7oQdDCFbEGHVNJWsP8j0qIFgN9k/GZQGzVlJfAuvSMCI+oVdLCsIGDgeZr5R+/8IVeW5lek8SWKmpB0GniZEv/kpG4P+hdVfZCjiMNJty68vVrugRgZa6u5cgeTlDvK44Krs1bn9HkczWLDdABrFDzATqwGps+qkEhHxCcZeJbAgjK/Bznftj+xut8w3M6n+qW6ciAyBvyIgjNAMCgQfN8FDdRb7JE4F3epVn3bel3NF98UA6/M2yZzkfWU059WXvA/GnnMllxoSbBgBtGzSynVrLlFZSnKdiiWOaPDEYX3A/OEieR630P2KTAzdYQeHbWzP5BgAP2dUI0+zCssWfy6zqbJPeeJsbTc6Wzy89jeOKwtD0k1ShXi5LB/OKv5rnYSyqYAiyGfIZ5UHg40VGzori/xGVGAXKRaVwqN7Yocy9w7NRJEPg3DGqChHDruYgt4qPWsp6itVRRM4zA6U1hDuDDCU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp
to fix UAF") switched get_pref_llc() from taking a struct mm_struct * to
taking the task's struct sched_cache_group *, but only updated the
CONFIG_SCHED_CACHE definition and its caller: the stub in the
!CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.

Fixes: b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp to fix UAF")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Chen Yu <yu.c.chen@intel.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 57360f5cdde4..973647ad6c2d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2194,7 +2194,7 @@ void init_sched_mm(struct task_struct *p) { }
 static void task_tick_cache(struct rq *rq, struct task_struct *p) { }
 
 static inline int get_pref_llc(struct task_struct *p,
-			       struct mm_struct *mm)
+			       struct sched_cache_group *grp)
 {
 	return -1;
 }
-- 
2.52.0


