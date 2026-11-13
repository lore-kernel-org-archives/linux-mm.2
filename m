Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C51C606A88A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vQ2+Nfeh
Received: by kanga.kvack.org (Postfix)
	id C7AC26B05B0; Fri, 13 Nov 2026 17:05:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2AD26B05B1; Fri, 13 Nov 2026 17:05:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40986B05B2; Fri, 13 Nov 2026 17:05:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 736DE6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:05:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEE13402E4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:45 +0000 (UTC)
X-FDA: 85431478650.14.CE87BC3
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2385EA0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vQ2+Nfeh;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794607544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YgttlTwq9TxT/yyyrQShMeW4eBGuS6HklOlBPU6eqn0=;
	b=mboD3P8Gx5s/YKUafaEzhBUBE78dlC4LojpZNfFbCQdlW+jlKTs7atFLER6dg4lwN519m1
	nvQQoQaObheFNxHYEc3+SG1tK0TPwP74vJ23K4RZPCW7+NsPJyS8QIDyucxyDBfU1gOKPZ
	BWHHieWWpDHf5Ut2DXnxYfMf4i0w+Vs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794607544;
	b=odQkGv4xgACLvzPAjfRdkpUzNBXHdHAMVd3VjMAfDP/bZMdnPbYQZAtB4sLLGQRAc3FrbY
	SqjJacZUt+Vis1bpy+Cu1B2pumL2UvuAGJ8pKUAkPQg73QDxphWsP6Xi1IjdO849khH4Vl
	z/OoDZ0YtD0sAUuFalV3xoOudJIMOek=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vQ2+Nfeh;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-67d9a5e9bb6so381215d50.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607543; x=1795212343; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YgttlTwq9TxT/yyyrQShMeW4eBGuS6HklOlBPU6eqn0=;
        b=vQ2+NfehCvH5DTrA4GGhQ67Buwq8JHw8vswyodKbY28fyEvRsFBY4VhUwU1jw3R5gd
         xPvXAKRNl2TtCRDfN+lZZ1GjQ4mVephgUbyJqXq/2WyvoDqjFCnleIZ5KTnV3d5IxujE
         lK1+hVU/HCpM89uOs478ElcWKGhIeFe6tYWG6pigvvZ/PpKqK/fL2lnljKiZWergUgNO
         +XRdJBma+pdwnlShjC4axOOwKZFaAYw1lg/4L0TV1tzy/mOD2uDom5J52tAfYEcQHnVW
         G3s6IiU89+QbuhBc967q0asvyDbp2JQQYNOdPoWPTKIZgm33i0Ll5Yo8et4i2dSeNgG/
         CIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607543; x=1795212343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YgttlTwq9TxT/yyyrQShMeW4eBGuS6HklOlBPU6eqn0=;
        b=bjvext7gUsoEaXvDQuLk+o6x/pmsr7/I+BNGG0LbLSMs41FaxqIZE9kpZGUb/EEb7N
         RpMbE0MTxIJpdb3Veanjq/wRSVS7FjcNR1MBTyQTeuE0DSx484QJ/xuxH1Gxs0zEXjvS
         UC9NcbtkWZ+xebaYudVesku094w0EcZRBFCqoKe54vTWQbRrn87GSzffnmhDS0vBshOM
         G1QBZ4oj0FxlHxkGxJNBpYDoU3Fp3bhKWgiMoYDqAteKxwR0n0z+WHBkCnMIfY5RSRVB
         ASnNc9jDd5NpftaGDFryucG95rui4c/EVwUjspsiTbqCZMvZR6GYpqCG86n6azuGSb/3
         4Srg==
X-Forwarded-Encrypted: i=1; AL+hErGH4/lTXBOUc81s5nm/GqBFj5zXk8uWt8cSzTzSC4ZnQn1BBdlpwyih+Q/P+X3DIPLubT0/7b8YKg==@kvack.org
X-Gm-Message-State: APuU4Z+yI7dZlc3aPEvr2VPgEoEWtG+8h5LBs63/yKVm/kIWV5ujqlZV
	FqgY3qY857UHd05FfafHgFRs7q1vwaxMnCH+phV9Lsy2olW23W4VRkbi
X-Gm-Gg: AYBFou19nXSNr8Q1bTNKoDl3qg4IacowNATUAXuQqj5HZLI693L1ohDhsz+SCAnG5MD
	BrbfQHpxO8gPby1sM9NBz/zfs4b70X91sY/tExAuqr28uQIIBTR8ckB6qWyGgMkJ65p/lOxsFi9
	Qv1UcCrYBc99Ay17WaIiMtLyDDGOctMzr5qynv8M6AFJNb/+ErKXU+jb6ljOeM6QZMZORSuE0Mf
	I+qpryIo474LNXC/qRptgc6OSUjAdk9EH8uIWvdRxkYY5Cov4yVtoxou2ygvlH22ha2XCGAO9E3
	l3S7xUCEfQEBxYsNqrjdfwIFnrKF5mElrlMrCd0rokaXUZ4s8swjci8fRJG2bDj65kQNg8/ghCp
	gHNu9Tw2pGEZjMNgndbYifbTR2xNjcnvcahI32xLWZY+K/ZkAynut99HmLmhQBxtSX3GtZh64XS
	ZSeoL/EgacMLL74FzaeDnjHjxBKBw8CbiacKfGJXKva+LBtw7xCfnj//GOx8+H9heXjIweTRcP6
	uZZhEPeYHZcACrR+ACMzpylEILNI/IW/yYzBHnMtnwyvWyliNJF5EaUuLdJ0cD3KIGSWgcL83oH
	AGj0OOzOB+htwsnZwtGCuMvKwkgNMsmCp4lvx1MN/EcrGIz79EZBg8jBIM+oJw==
X-Received: by 2002:a53:b84c:0:b0:67c:b95:6753 with SMTP id 956f58d0204a3-67d8976d393mr1422762d50.146.1794607542894;
        Fri, 13 Nov 2026 14:05:42 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a433a15sm3200910d50.2.2026.11.13.14.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:42 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 1/7] mm/memcontrol: flatten try_charge_memcg control flow
Date: Fri, 13 Nov 2026 14:05:28 -0800
Message-ID: <20261113220539.2275715-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
References: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: fne8q3obhd6cgforsgqy3ka6h1gw6dgq
X-Rspamd-Queue-Id: 2385EA0004
X-Rspam-User: 
X-HE-Tag: 1794607543-719885
X-HE-Meta: U2FsdGVkX18vuRPLXHov2RJPeNLgqYWsnul68HDkuaYxKZB/DXUU7eu/dkIKLwzewffGxPwn8Q8cD7eDAoAV81evAKmURcpFrSDHsbjZrMXvLw/bqEcmh3xOH/R3lu0PujMrNMOSyLFE5+LnD69htU2LQjufvNmb3HbEOBUuaOovPIWY0LzFxO9oAcellWu3rlJLaxZwF9P4ju46T66c7v0UYi239otg7t/viTfc5TBEVATVTaGVuxbtU/AXZeNv1PPWRP8UiG2YNWZEvqRIe7H6Ge9fXLWun+e8zyaotTeI3k3IowEq/mGDqVjNmTBewxoLVwlvOq65SK3vP3X+ZTRi5pA0PWmBcVX8vCcYbhFJJElGTqgBkQg4ZlaXY7WaLyhRLCcRduM+z0FSBrfLmU0+y7TlZ4hJSTdANQABjvGkpYNjhDqA1Gv9QCvatgbhQVT3ahJvfMU4TNZ2Or7ENIZA+AqdniwqIbN70Z+3gAJvqKVdT02SDnxO6sS7stYcRrXs9vSyrSH5S8OTWeeOhdFq9luDI9wo6IpLUhBsfsXD0iOfnWW6eQa47A+EpUdwMGtw074WpI9sTfNikCKjFHHK6pALVWR0eZOIlL9NwTj1TeAS1oaNA30mGlweFnPr6eFZ8KWkZe0h9ilh4ghRBe56jMCxy10s9Q4zooHVTsFH9QKvUPmkkAsz7Ip+8VdHqGi9vjq6EaX7ndd0ewVxQoZIw3J+yR/j9jySQVCG4tl4PXiGk9/pwvkSBnqRzZQ4G/Np7ZqKhDiyjeDuWXYZs90CqwnDPT9g/4rONeHWhmq2VXfH5wXbLUZRArL/aIuXv7iaV1ou19L+pfOKqq8OfZ85b1JMRa1dRoyQLCqttffXApl7abBQv17wUanjEthiyGvFunp/oVLbyRqryy03ftxwg47F1AFc0bfYzoC7j/68HNTF/l54wDZJ1kD10mnIQktKbAS98jKohr4dkuu
 gnJ01nrc
 7R2f5ovg/hcve9zxgmJ23Vxk3Ntf3zrYPLF7d9voOe8UdYMUEq+aaXqq/UBWAYfXKCe/D9EEP3iY36tO44qiIArtou/T8+6HCBsZ2WErOl077sXScbz4h1kr49em/fT+t7uOwilDrIg+vypXUmrNqvSF6QIFGy8lCraHKvOpcbEmXM5uBmA8diiW1Tek45akwjYg6A3A/CooxnECiinOVt2jW0d6dEuI5Y7IB1c94axNEcoS6d7f4X/+oZsZIb7yIMM4BVYqOL9DkeZHK5Jbw9vPqOEw0kYKX26wE6iUr+2qaIND99s4GtfeOJurpnIpV2hyKuUX3I+k1nelwl8DmHBM1Ol1jHbFMeC0XJ6LBd8OB1nV/v3wf9/J4LhWgnAsrngI2xIbkuWZ9oSUh97iTZO93LgOVeHv9MQO4Vmf1Q4SaG/t4IvXlfmNw34Wmht0bTsh44L8Y8M6t/lo9FUynPENur7LCat8iaVn68+ZVPFNTnsAh5YYunlLMi6cKJbPcr1Dfi+4dOCmSSlBQsUWUx5VEiqqdcxqJfqUvOY7kcZpqHlUiCGkNfVKwlVvQksN8wgqbIgo6xJGsYjrzp8VQgbUCdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf397..aaeef20eec06a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2815,18 +2815,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.1-Meta


