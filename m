Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A94ED58CDC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 06:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0DB46B0005; Mon, 23 Mar 2026 02:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEB76B0088; Mon, 23 Mar 2026 02:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD40D6B0089; Mon, 23 Mar 2026 02:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0A126B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:28:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36925BC356
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:28:54 +0000 (UTC)
X-FDA: 84576349788.03.0C42A04
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 72167180002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:28:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WqMxPXDh;
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774247332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZaMFHJ60YK2GwvhaQ2zq0URWS7aXAsOoU6EB4xwgTHE=;
	b=yz5GXPGWyZUfyo9TZegrBCIGzRFYJP2lFZesFM6r87fzUXAs/k9B28PDBdBHNx00NJhOLX
	jBs4rU66ltQKYpT4E4PhN9ndugmdNZrx0kuYI3qQmrvFy+Q88vDlfRw3MUbc/U3+oNvlaC
	usbT8D2ZlJ8xhiWXHReFdzisrZA+Upg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WqMxPXDh;
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774247332; a=rsa-sha256;
	cv=none;
	b=cK8jDYCsTwg7LzAEaThismxyph18iNKuTOHrebM4deMPsqejuBkVyTN1CC7FuIMfnY3kaz
	rDwtZSM1R/YhpmJt/qPA4xNZnHO0108pW+nHHOjgekxKUD3trIxdORlWbRfa0eZqPpJKdZ
	X+C/SypwJnwttydNnEb/gkcy1+3YdL0=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439d8df7620so2435593f8f.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774247331; x=1774852131; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZaMFHJ60YK2GwvhaQ2zq0URWS7aXAsOoU6EB4xwgTHE=;
        b=WqMxPXDhp2Sjo6ooGvBvCvYFp6q8zh/TSZOh4rPFRMPHgEySieeinsfudJXYpE8jzs
         basVoBIWcmt112KnLG2USvxh/kgS8GzzPHiDec1oDD/Ggd3X6VAUbtqJ4/+ccsj8X3SF
         h59by3Y0Pso+EZNjT3Nxa0citjUmVRVm1+bfJVa04/s1aPzpv+UO/GSlrEEZ2A1lZIKN
         PXas/LKjJwEmljreoN+HJ1e/B51oEDTWyR8htRv3nngTQdFJGG9VmzQHK5rvqW0NlGdB
         0Dcld9onvdvJOOVMwGQGtMzeP0lJPXKHIawmwApuxG13+swim+J+FKDgBGvCdHR40kME
         mh0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774247331; x=1774852131;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZaMFHJ60YK2GwvhaQ2zq0URWS7aXAsOoU6EB4xwgTHE=;
        b=efDe/TPoM61sTQYOe5DqS9dqcgHVCPpViP3LL8488uz8YR3TuQHVq0Mm/3pksjoIPu
         N7MTurg55Y86fAg8YSmaa/qW5VAinp2Z9p7LQ1W7cfbD+D8XZfSV3M7lrT7vDizQOejE
         fbyt03dRVu9LoXYsWcpsBsP3AyasLwuTwKGCf0sd22gTbOx+lBO+5y2NZJCcCK0oO+Ab
         qLoaIvqMGsUrxhfRZ3tZeRphc+MJo60HjUsH0V8pZriv703CrZFFaGgvebN9ymAcpSYM
         RDm/x/3V4P28fkg2BxzCLc1sw1E2CTXilCz+/C9Kh7QrH/kw6v89h3lI7UlffEQFjssN
         JHGA==
X-Gm-Message-State: AOJu0YxzbSLWC+EDsneczBlhJqXWYsXYA0NY60PDIAS8IA1Qko+4X/Rn
	wJOPHbB1V0bd0pnLgGUIkdR4GYylIbKK8kggezowN7x63hysgDP63IIX
X-Gm-Gg: ATEYQzzSGzN6JuVb4RgxINlcRoQtjTNRk/IOKZIMz5fTHOOujbi7/us0w1/vQbBHmdK
	Jg9A8Lkedes+uXhRYMCCnziqOUwda/ujuVSROz1862aDOb57cWOtuatvNvRyns+csSxZM1ElLuI
	2KsoSxL8Fae+K3TPOKN0hhQxrwFTXy4pEa7m3jba50otyiQquruvIfli4bumLfzf1IW27msmJ3F
	CxymlKCJMJPbSqh9DjhkODJB3tRxO273/zcorUDp8klC8vpe2IiBM+CT98bq/f3x+ej5NjYaTKW
	UvPkjKENarvA+2AJJuDiOB8nA2mOQuIvQFUKgqxPyfrh5+qLx4ZryijJwt8U2HGnG+X/MxU/edq
	dOWvbnc2qIHnfP4Xuo2rHRS5H/0R04fUiVCHckuAsUwMT4MQaRqCbdWmCkiBtm5D8F6+IcDmG1Z
	6jAZsKnb6eWMSVeaqd9O57CBNGpK9VfSu12iyE8KtRkVVsSlrIig7e5/did09v/wtdpx1IpsQcJ
	KcAo6CI6nkO
X-Received: by 2002:a05:6000:2c0e:b0:439:c279:32df with SMTP id ffacd0b85a97d-43b6427feadmr17606438f8f.35.1774247330495;
        Sun, 22 Mar 2026 23:28:50 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bd38bsm27158274f8f.10.2026.03.22.23.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 23:28:50 -0700 (PDT)
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
Date: Mon, 23 Mar 2026 06:28:46 +0000
Message-ID: <20260323062846.6262-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72167180002
X-Stat-Signature: tkkjmpefo9kysnf6bune8cs4e3uz3egy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774247332-563185
X-HE-Meta: U2FsdGVkX1+/BJti0JTCbioKTruYOPB9DlCmK0jq1IK84EDAyCWssd0r15WjSc8UurdB/1cTfyoCx/EoGCCN1qphvWGwAqKegzekRwFipagISuQRhN4ljJJ6Go3Ym+U0+31zmVPphSGn7bJ8nJUM1V0/u6mgInGoe469uvEoaIlQ4DfUmi+NZap+H4eJRcNEFO+DHkFqCRwKFNRMkcmA+8iYAt6R1xwyTIWozNhj74v4Tx1b2MoSXj5sdBDXGeQYJvz+/AuB5Rm1jdbPSq5Fvk61TwLXS3XIG8NQ1+ZVJE9Dg/QTZsR1T0bwnWnGoAwp8BvIT/QF17jt+QJ+J2aj3eP/t1anKYF5nEKl7QGtFOppe0c7pchNQzD1wIsnva/XdVoO6NxV0iXGgA521KwQSijMyL5r/9323oOBg6WOo4Y95DE6ewI84eZXpBgbGS3kDzNdf7j9O5a81qhK5K/MIMeT3MWb9SOA/JbGvGFL9YV+QmGhyEN+iUiRH5qEQWqn5FjTTR9ptzX74d6qaJ9KZ1aB+8KO95We194o2aW9XWJ9jVu0iJjkpF0IAYzVEsJKQ3U99vCO9I7pmfCZrM38ZdsR6DLORl5nQwoqSGPGSJofKrFEq5TTvtlavbMfKbdnkGYtMsj7auGQIfvJUEbaH9YVzpe9+WpjEBRJYMkl9YYp7yrB0zcVg/hG91K6DUWQTQapjnXPkIbUmfzgN8zqR6Wwvb8GugRR1dIauTEmd9IhEV5DYSGDI3T4K9p1/rRUzykGMw15cdnzkA6oYdDQcOGE8lROpPLENQCY9oOsCaPI/KeNmCdcw3aIDNt+iUiooq2Dn+A7po/pgz34P3vcFNW01MZjewoVwG3meTVGVQfDNj2/izeyxeCJfNqjKwj7WeScsxp1+4X6B8yHcF1ERRmePbV/ib6ORl1BXydbW7M5uAH19tHpdROVyRbhae7NtyiRWQ/Zw1Yu5b4/0f4
 e5wEVZEc
 RNYMOs5I/nOixlH53T4f0iy58yQP4uoTEXhhULFgSPUTvDa8TGPpx/dTNBS4/fNc/lhnyjDWb0bBfX9/4RGOZqxvyi6dDSABRHhpnhgpPAQ1mWcjI5jvkT3myORvVTB5l8LhJEDlursFd6np+8gli4aj3734naA+PVjsPusza8/vSCt8D4ieAU/Tsk6on8P0RyXs3s7Hs6urUm3jebFc7huTlEnQb+81tGLw7NkKDqYLIAqbniVsINxTOmLdtGEOGTHemNYwW+ZhRpVfSoj++O+SLx/bC9pRVzdnDsbyMgK2pN3QXuvLg+/L+Pe3uGE0iMqtnPYpx4+A4TrlCj0RKSZvo77sNneBoyRqhjX/AV+w8+upkcMA/SFulRGR5SvaRVfUuAJoTrGwg0c+EIfEzgmDFt7YrpoUt5e17PgUUdFLmF1dgp0iaK4M1YHMiRndDqo+qhpsp5U0XDVc=
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


