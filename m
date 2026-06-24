Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80217CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 18:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CAC6B008A; Wed, 24 Jun 2026 14:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD626B008C; Wed, 24 Jun 2026 14:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BDAE6B0092; Wed, 24 Jun 2026 14:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEDD6B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:37:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DD80140453
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:37:04 +0000 (UTC)
X-FDA: 84915663168.15.64A523D
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id C95631C0011
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:37:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QzZpiOE9;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782326222;
	b=A9qrOyQauFfhxrcUkO9VADzXtww7PoqsTeWKdE58CeOUFcDclKk+BLPSW7mY4U1IXAKfno
	I1quoOBQpVduaH1AXrsh8BOiLKR//68V4hxrG7hB0vPVCn3lGUq6avJrhB4o9HJ1JdfQc2
	/GDa1HBGp7ia+lNvK1tqD4Jv7g+AaAA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782326222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zbWIs/KwOpEaTVlvMb/98rnTZb76+gA0HeQzfXkUtFM=;
	b=GzI/hzbJ+tCicnqowsTZsuX2WIlnWGW6BrTUF4wNYkPWCzIeRz6l7weHhXMw5vvzcWKO0i
	p/je45mO3sXwzXjPDEnzgJSFgEpl5kkHY8ivFd1EsZAPai5RZtCULVaQo2BhjfjkI0vQ/t
	HZrnRqkaqAJI/FWMiR3TAKIiz3AJDGo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QzZpiOE9;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-447a81776e9so676809fac.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782326222; x=1782931022; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zbWIs/KwOpEaTVlvMb/98rnTZb76+gA0HeQzfXkUtFM=;
        b=QzZpiOE9h6EulV7Y/t2o4ylX4pfKU8ARZMYW8rj8joi0igA+V8xOWlvRIRTSIp0KXI
         oPwiwQnjELDfLFOH3Oa5Y/JC7bw3a7raCqxludTQzo0GzFihPVG6EseIQKuFRuyBSfN/
         1v3tc/rHD9dYBA//UmzLACSV/pjYZkyK9HjScco4M/Jik3GevsLfRm1TI4+jKI8Cj7t/
         wDAAiZB9IRRnPetITvnp+LsxBESdwD+ZGB1W6rqFOEZKFz7tKg9xjZaSk2yNmgYLsWC8
         zkUoQ/jnwgKMUzVGwCiWBPXJgmRkvK9ziFHuQh8KfGjm6tJHTN436NGO5xEd160kL74H
         5hUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782326222; x=1782931022;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbWIs/KwOpEaTVlvMb/98rnTZb76+gA0HeQzfXkUtFM=;
        b=dRR8/FTKADIOTQmdihPhKUnmpEFT+vE7dkN/Douw2dMxxLjvIEkplLPqAkn82L5wFS
         LBEwwbgmeIvtHY9oRPTzFt7AWRyKPcr4LrdgF6rMfi1o+VP/3tXcRRgGiNTrvMP7hZ0Y
         u+4stlebM+Jtz6jaw1Zf1kI/r95aJPNytBYIob+O/QMmH/8eAYqNkF7uzeql+wBtiLJn
         XULzUxunXURT3DJIiN/Fy6UypJFyJJ2SxxrxhCxCfzwORTxEs/FevZsvpQQwX0hmkMCS
         hUr16PxotBtEoUSlVSN3HcjLpu3bvhKNeZlpPypTHr/21CZxQ8cdPBqt0h4HV/JEVtzK
         rOow==
X-Gm-Message-State: AOJu0YwBEbpAI83uo0kl99z0zqpDe6bN1Y/2uRgiQsYGawi9AZXRS+ag
	js7XpzxYT5NAmjEVOaf7kx71Sy1AmbB962DEbyTCRK7CQ3wjqnttOmFhqCXSAQ==
X-Gm-Gg: AfdE7cl4dYIRHuFvOVXwjH121DMOSazBPdlpF4yvyISDJsdQadTLRxjPtKBeeV5VRkC
	xgNR6iEzqmuxuMJKhKpgBxwR2ihrHvOqxI80o1EHpJ3eexgYw/oOSxvcYFZ2Y8nNyVazWuVukXx
	TQYkgRzctZw4fyJGwMJXDKcxNjUkA+TjST2lrdtJSCjGOL6w8RJG21CY8F7qjmCyp6XCeTqZ5mH
	8gmNcztAhuak7UlOt/WPhI1b5gyPZxOa6LbP1nEaQnhOV0CTDcEKnofyVjD6Fduprn693RaSO5E
	AJsu33JXhfzIQmprkiWL6TVc3UWvtP8xOqPgH4sV137MR2bYxwAl2TymkXv39AtIC6Xt2VGQ4UC
	EII4p6Kc6qgks6Hqnf/keE/4JiGUDYitVsAAXiob38zLk3yOV8B/WImhfbcg2GfGP+nKTEm4uDQ
	ewpLI2PuJ+oq7smd9In9KMkWJJWNn8pPN1MA6tcHgHww==
X-Received: by 2002:a05:6830:6412:b0:7dc:dd19:7f69 with SMTP id 46e09a7af769-7e97949c243mr6906170a34.17.1782326221861;
        Wed, 24 Jun 2026 11:37:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e944252015sm11789254a34.18.2026.06.24.11.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 11:37:01 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-kernel@kvger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/memcontrol: remove unused for_each_mem_cgroup macro and cleanup
Date: Wed, 24 Jun 2026 11:36:59 -0700
Message-ID: <20260624183700.1152742-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C95631C0011
X-Rspam-User: 
X-Stat-Signature: 61y4jum5uhqnsuznqktnsn7sc1zapqdy
X-HE-Tag: 1782326222-910348
X-HE-Meta: U2FsdGVkX1+5Eik0tkKnKq0+qZp1Sim7Rq5yul9r+tSSIAcBcbg/Mkth+v16raff1zFeWxLYIwvb9ZMuCPFKM2F/wafao4S0VkbtyHeK4Afn96VVZ4h5gG5dhoSbdQ06ckaw/65HqiQqKP/+1tjj7EW8VoABliE863oHfvNd4fyXt8dxhCDyXq3liBp1Qs7h9JMu1aeSVdpsz0aJq3bwHSKSddqn3ZWj0pUOOdgBWxcZAZjfd6q0kiisWQXMdmOkU4CjtedE/MRVJ6IadF6IJLpwIt1AYKMRgbXw/UhNFwpZohRLz52RexnnnFiAiqgk8pXQsLKZ6xJV9kdSA41ZghUNZLRy1fIVp/E0N2vu5wwsApTumTHvyfKkYoGdHJfhNQ+QjBAvDgXTb/Yf8Bs4tY5ZdFxWL5yorzOQDZXcOIyAtFbPnzEduZBJ1fZv4ExpRf2ih0zKreIV0Y/30W3JsoU4jsvlHDkvYi1QA4DkGsgs7FG+G1KGwY1+ooohrX8igNr6OfpTnYnYQmqflpkGke+ptOvEzdQhu+0YyHlK48khDtkzNmuLtNtS9fyhoR3lEGrq89gL8XHzgZpRjbvoj8qBTLRGAOpSWsmMe7W4ROm1C8XqV5fb+ZFDagAYDw2NHFQTi1Wmj2bukTKFKcL1BtWsiA2lPoIw/1rBwj8BGezsU5Mr2M4618a3qVCk8cWzR66VA45zWrWoE2IoRjF7X0aipK+XSgR8+zwAplALVPE3cPCiYtDKXhfv3Fh4Paj62YpUWINYpKmhwwtcSnenNHyqqTCsWShBlBWUFmbEcv/EOvWeO6zhEscqz/knPSmIl0t31ZREWRIFevpQ89EqeJU1T1pRLfbzIImtql5GObADys7NHmfl+oMwmo0rlci6k0SXz2pu+cVLqkRyPkql+ErbldDDLqRR1tLd9awbwtOEi98mWlkvnRvJ45sPO3fsSUP4XzyeMhKgNNi5txl
 M3zJk7ms
 zxyFOyraO6gp+Ggu+QlwY6t/KLbC6dtinGNy2dyafxBB4sTh6gz+SaSdIDiqVvSUOCbJ0zH0/0UCL1laltT2dZK01GLW8jzqOFlwMbeCkJ4trrlvM3uSWSKZrT813uL9ywGbjdqh6/52FRSL3q/ckK+Lb6PLOxrncTu9DAccgVJTbttaVWXiIrLzH0XI71AjNtgtLvvMRK0KW3Z+E0pxosrAjCV/oFS0U4H3cErIQizdL6yfx7RsmT3UFkmkmdnKrVzz4ZW2PdAM2LZezDbGNNl+jg0aHDpq5zm4PXHfLfT/T9pmIvsNSFtM/Wd1A+TenS4HeoZgLG/YZqnqrrhstic3CHOhXnMrtUS3V5jPFuWUUzyhJmpy0YWLrLv0NpILavVnPBrON2Afovn5TELmccrWhYClbM91K6sEsitTI8zvKlXWpO1ySc40YrZXbFcnmFRf/Mww5+F14Jre+RARRn4hNUkxsidzEgOhwzZ29nQdeWXz8j/cZzCAwPbdmqZNv+VORBPlO0t4p3iKIJ69PQht/e5lxRPnIMqVBscPVEriWdOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 7e1c0d6f58207 ("memcg: switch lruvec stats to rstat") removed the
last caller of for_each_mem_cgroup back in 2021, and there have not been
any new callers since. Remove the macro.

A comment in mem_cgroup_css_online has also been out of date since 2021,
when 2bfd36374edd9 ("mm: vmscan: consolidate shrinker_maps handling
code") open-coded the for_each_mem_cgroup iterator. Update the comment.

Finally, 99430ab8b804c ("mm: introduce BPF kfuncs to access memcg
statistics and events") added a second declaration for memcg_events to
include/linux/memcontrol.h, duplicating the one in mm/memcontrol-v1.h.
Let's clean that up too.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
This is intended for the next release cycle. Thank you!

 mm/memcontrol-v1.h | 6 ------
 mm/memcontrol.c    | 2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index f92f81108d5ed..d3ed5b93290fb 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -17,14 +17,8 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(root, iter, NULL))
 
-#define for_each_mem_cgroup(iter)			\
-	for (iter = mem_cgroup_iter(NULL, NULL, NULL);	\
-	     iter != NULL;				\
-	     iter = mem_cgroup_iter(NULL, iter, NULL))
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 int memory_stat_show(struct seq_file *m, void *v);
 
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af082326..e171fe36b0711 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4216,7 +4216,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
 	 * by the time the maps are allocated. So, we allocate maps
-	 * here, when for_each_mem_cgroup() can't skip it.
+	 * here, when mem_cgroup_iter() can't skip it.
 	 */
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
-- 
2.53.0-Meta


