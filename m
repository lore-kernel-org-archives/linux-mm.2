Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7B9FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3EEE6B0005; Sun, 22 Mar 2026 12:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9126B0088; Sun, 22 Mar 2026 12:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890886B0095; Sun, 22 Mar 2026 12:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74AB86B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:49:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1595AC0284
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:49:53 +0000 (UTC)
X-FDA: 84574285866.21.CEA84F9
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 666F31C000E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:49:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SVGtxos2;
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774198191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWjZGVQFq+8rxchM7WYzJZsANmNue13rkhqmq5WeFqc=;
	b=6SuG59FDlswfkPv/z13yoCGaOC8DQuSqqv/R1ZsKuX/dKYqLyms8AH4+j59iWEGq/p/8K9
	gku2Nhg24DX9EAHG6PbQ+BdF2yUTqVE0w6LzVUBMUHfJw1EcZA/sLCip7aZzbW5+gCRLU2
	HHpbG6xTpL5XL+75oDZ1lqwEbiwxRlU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SVGtxos2;
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774198191; a=rsa-sha256;
	cv=none;
	b=ulzkW+BKDib8uPv/Zd9x2BNtdBhvyqo4etsS2zqyhmpTg+5HzLTWYqoLFawryhQgY/qSge
	ZPVVt9t04V6MEp0e89r4VnLe6n2JZBWCuMWuQ/k2zyucVVprXZ6qd81fZZ4nLE1OIEKvSr
	sfozbopBPjdOIV9YqcPdUs3nhuThb74=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4870206f73bso10897065e9.3
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 09:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774198190; x=1774802990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWjZGVQFq+8rxchM7WYzJZsANmNue13rkhqmq5WeFqc=;
        b=SVGtxos2glo40S+RHqUOIfJa1IBr3JrQ9xkPQUp5nxwLlCab8e531ZKE7+aZ4NlUI6
         DQwpb4dtFfQHvy7a8TjPX1irCOPgxfRzrOqIyo6csYSQvqLRxPOwGpLeTxgDd1d7IAub
         YQWb35An1ieeTiH1Vbxr1ya39XUGb8wPE8JOZ+2iWmUBhTEyDLAyyAf6PGH1hXsrehrh
         /F/912Rfn1jGakDECkPSInTN051cQ7/yZoaH9pOhT/M5q6fmrwvf6jRhMkTkadxMUP+G
         LZdDS3aYa7K9CmVfUWhhnDQ/wC36xiX03q3nU1ITOo/yEhseGuQwxL2PnCUZ6S5EZrlD
         gx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774198190; x=1774802990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JWjZGVQFq+8rxchM7WYzJZsANmNue13rkhqmq5WeFqc=;
        b=IJOWAhKUpn5UKnx+U5nrb43uyrHxlFZVAxtwb5Nj+RMR5yfPAGgxd0aZb6kD0bzl5U
         2dUyeTIMGIKJ3wwUREbItFmaECU2fj7OLT39cdzJyf6kgVRly1pB34dx3B/Noorten05
         sMbe2BEwCwV+KG0e5Hk/EIcYXPIlJoInMLVVW9lrp8jr8uPCkAw7FTj3hcT2Zgrt7MTQ
         A+Ijq5SQru0if7wGvBWbmuWffhiczCNi4HSPv8GSxT61bVOfHwO/VXeddBwZlk+fsh4c
         AIq9A9+iANHETqSipIZsiYPmbDuK99ZQmuJvaDJk9nVTWk0SK69FA0GsqtA64rSq7E5X
         AyEw==
X-Gm-Message-State: AOJu0YyfQwcV5IcbJNkFNBcuNFAucjpvW1Bc5pYaUmipfxGlaslyxyX0
	ViaWBQ5DibTxCXwDfho4F3tyBVc6eXU39+QafRPzIbPJ/zjHEpSUdF6Z
X-Gm-Gg: ATEYQzyDQHn+9CzPw8tB83JTQLepZgrMA66SvWVqw1Bb4e8jR2AYSTH7IV78Em83/Zy
	MOO1mf9NaGaz1Od8aCbVQfDr5SEUP+I06qo50a6EKTK6V1OmHXRaKrZ3gd8YN5XD1Kc6tvyzvnd
	whTV0/d4fFbhF08lg7hHoHoyEowhnDiXR3mSKscT3heHNm0SNfCywpEex5nu5+vEJJeFkZwFSzb
	fF4wDwX7q2jj/bBiPbx/5uFPXScoYYAoxZeti/NJtBgJxzCVSgLzHRJs1GyveUD4/Nnn+17ik+f
	U02wenc9XOIWcsZzX5iKOQIlrMc1j3B0sbADazQOd88qUEBbHgweITJOGSO6SFkBbMAaCjM6sXh
	iY+TyrbTvnvUASSAcEx9STgpk6dh+m9fcQA0DM34u0H2b+7U5DGyvAZf9vtmqzH35jnz2HvwTOA
	OnXnHu3KXRpmhEs4YY4utE/+C7LgqfTmEHHFT/+bqu28ydbLvBEj7k9/m56PdAxpnMKTa/85u1M
	4DYIxdzY/bF
X-Received: by 2002:a05:600c:12d6:b0:487:1c2:6a4f with SMTP id 5b1f17b1804b1-48701c26bdamr67227245e9.31.1774198189586;
        Sun, 22 Mar 2026 09:49:49 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486ff109b95sm146464215e9.1.2026.03.22.09.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 09:49:48 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online() error path
Date: Sun, 22 Mar 2026 16:49:43 +0000
Message-ID: <20260322164943.37460-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260322080142.5834-1-devnexen@gmail.com>
References: <20260322080142.5834-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 666F31C000E
X-Rspamd-Server: rspam08
X-Stat-Signature: w7hxkyucewtfhru6ezukoxjy413338hm
X-HE-Tag: 1774198191-115953
X-HE-Meta: U2FsdGVkX18iOqZcqq4eEEhNo6xzegZz3uYIIKcLzq0UT5wb82/UJbVcklt80H7WjJg9pnVlGPQVTV+YMY8jK/Frc0vKcHiWflEcKfotP2V5e/w3sGwWxG0x5zElZpTxhgVtz6rJl8uLFG2ULV+UKam2QVNDSSVwORNA+SBXVSTfhHk4GqU0aby9pChcF25suvQtG9bDDmBTrxFKhsxEb4bc71oqyxZtzlHGI/9fxe6o9qpZRKn4iEK9lwpfKyxqKW+nN1RLeM2JII7UnHNDKfQUxrMraYKoeIFjnw1332OMN5p/J2f9Nv8bhffNcRTYhnoxPaONuftMxoPorHUpp9GYtnKsZ8dqe2y9e65D40XrLLm6XQe5TAQAvW6VKoJVq5HP4LfWwjzS0kxVdEaFhCzff6gzcO3PrvfWi9sq/zrMzusdUk1vn7SBGM4RQ2muhqqBfPWuWw0kRXggtj3w8ETHKv2vk4ErSTJWMWZDN/8vREsziS9QTwKycMcU1Nv143Tk07Js7fmoJZTV4mjbPEUqwH1zkb6+dcdX+rpPrQ6sQwCnwjMEnvonQCyRLm1Zm+4Sjaxf0h4c4xO2hworAySDY5aingf4WiclPEI40/+ltLbuxlYPKo9S/ngogWjpFN/MwGRj8VOWvxcz6B+9mjnrtbtYxjITXjhq9ZzqqAlqQ171NaPkIJaN07cNkzJ8113gLjoOwWGhq0Ob7CdODgR7dHAGWo3uPpIqwWetcm6iXbzKX9ZNnBxA5CwdWB1VV0rgmYEojIqWE0G9L90INGi4+OLUqe6/Em9SXjbCgMgPubPnD0OL/Ji3eZVyIBr/YvT0RqxffDu9MZt3U81+cThg+Fe1ev/oskp1AW3pykohoNdbDLB0GRrY8LCeHlDOSCcOeapCntumgO3YGHDy6ne2f3qWdFGiHzdOiumyhRH/UfPqskoWtZtDj6oJYNIorK5Eq6yNvyiLNBzvUTF
 pv5ugizl
 oqqvYrRLg4KT6/z9xc9qaoNyXOn4x7Bkxe9eQkXXbipO85s7VnV0gYw+1rK++ogDMY4aIlWUbGXkGVUNZUQhZoC2FoIUJUkTGc/dUJlwIxwS496o=
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

Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/memcontrol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..dc83e9d43eea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4100,8 +4100,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	for_each_node(nid) {
 		objcg = obj_cgroup_alloc();
-		if (!objcg)
+		if (!objcg) {
 			goto free_objcg;
+		}
 
 		if (unlikely(mem_cgroup_is_root(memcg)))
 			objcg->is_root = true;
@@ -4137,6 +4138,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 free_objcg:
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+		objcg = rcu_replace_pointer(pn->objcg, NULL, true);
+		if (objcg)
+			percpu_ref_kill(&objcg->refcnt);
 
 		if (pn && pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
-- 
2.53.0


