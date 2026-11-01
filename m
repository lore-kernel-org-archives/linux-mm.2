Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FC1606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=rto3nCZs
Received: by kanga.kvack.org (Postfix)
	id 9D87F6B05BC; Sat, 31 Oct 2026 22:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9897F6B05BD; Sat, 31 Oct 2026 22:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802976B05BE; Sat, 31 Oct 2026 22:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FEA76B05BC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:14:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF4651608ED
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:06 +0000 (UTC)
X-FDA: 85384930092.25.DAA520B
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1E67380003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rto3nCZs;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OD9fGDG1XeSV5EuZqC2PA5d9y5CBw/VD1h9p8X7G8nY=;
	b=tHZ17nXqSo1F0apMDGZLIpQylpabyXktykC3SqfS+UElth7lv+QusFL9Y6Qc86J9BnzsSN
	0+njq7QcjBtBnRFRqR6dt4JyLYg/W6RfnHuI6DcHL0IKOof0FlPN1A/Kr+AJXERCyriE7w
	j+j6gs/vPXvgbFqZDih9y9o4zfbSog0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499245;
	b=n8nAylCkajkkbAUfIuC1gkQm9WDlxF8zfaPOwq2L3NQ2Lhy4VszHM9jw/wzaujIgrHjou6
	/9igpjjfvUeFBIpV2RuGvNiTHo9UuarppbJmlUzn6S6TV74Y2N2JLjNgRCvCHfeuXPds4G
	N7Atcqo3wg7JuxNdig1nUzCRUufCnzU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rto3nCZs;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f2b8cf037so169438685a.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499244; x=1794104044; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OD9fGDG1XeSV5EuZqC2PA5d9y5CBw/VD1h9p8X7G8nY=;
        b=rto3nCZsRp5oP+uRjjE6wU5LAX5uYgSRbPaTg7D+aGWBzlhzfzHp2Dxwovs1Q2wglW
         /VSfgUfaP9c8rBODhiQFGAJ+Ur6tv1FdRgpQ1OP0xcUwfH448sMUR28/EpTpYMeNAXxc
         agIBj1zzE9MO5p97Qvhe30W/far8IA4EjmvrFdD2mMQIsgrzOiucHUzhHmUeThlDT80Z
         nBlQw1UXp4zf+ZP3rYD8PbpZaJAdPq2v6hVkWxRi8ngSvS7EAuiKlD4JNRWpEWkTtT7z
         D/ruQsekZenLNZT7RdsYASeY1DIoavSQULSovsUg0l3ZkQka8USF9w+v71sRwNNeFia+
         UP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499244; x=1794104044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OD9fGDG1XeSV5EuZqC2PA5d9y5CBw/VD1h9p8X7G8nY=;
        b=JmD11LdbRV6KRW+pWsgUTW50AZz5L/S226WBJd2V+Ac/s596Z1gzxk0s0ZbIEpYfVp
         5Zwl1wgyqfaZUwLy4SlLvbKDZC/5xjZgrFhnFInTlQKyutSMVTI9jZhouNesKT5K4nz/
         i7IFl6XbCx2q2bKfHU4tiNcBWMTiGyWcz+b7zTxKc0q87vEVZo2xJHqzSez13gqVYL3g
         RnXsZTbkPxuxrpWSFbk8R7AxB/8pVQFo1qupyX3DrP4vq4rPbLpiI2QpDX92k0Qwyvck
         TGcfZ+RCt3Ied6JcYM7Sfdc6t4vVGkx7OPaAyZHWozNhv7rzoVMr5jwRRGTbrCmgsh5i
         jUrw==
X-Gm-Message-State: AFq9FYJ/MMl5BRQ4kzqb4d3jJLrY5bQxfQRardtRnQnjoUtK+F2h+60j
	sPARzl1lDDtF/0O6iXdxA9sADlO6LBLkZHS0qPo02fvzsP3n9AHkkZvMMDBn+8309zlkPWWN8bK
	wsYOf
X-Gm-Gg: AYBFou0neDPQJzuzwPqTu4bKGGxI8N7k46dDXMeBePttPLQovyH7mRp2U+wAlH11Hbu
	4Ygy7AcmnK8XAXbaGGOKUyAYljsmuDLNNqO33CWoduhExv7ivxIyFRjjQopUqQ34PJxMAZz6TlF
	iFWUr/LhSj2etZgjKvylqsiFM9oyfJwWJrnCwrpuSoXzvGuw44zxyMmlvPiAaJGmKbKIPO/pLPh
	GEwuMUgz7QqO9MHUe8p/bkF9JCoVRks9mJwl9Db2xBYHwcvJpcT+yfujupVDqVgIyWaNdib7I5U
	OJsC9CzOG1OvpNVP+c71srmuLMQXlZBQvESA5XdErxiJmL8L6JwqcbCAghS0q33lrvH70sOZL8V
	cH33eYNV8LUxhYexzwEhumMzaUra1yxTE3Ct1qc4Gab3NyrEZcUdlnBmqUtLOJOf3gLciqZ4GOh
	TDO3VO5jEYg8mDA+GvgM2k870+1sYviZ79xNWrmaxP3YlbDeGVQf5wMw4XDwdNMGt1FhJQBgD+y
	BJvsUeQUk6e2fL787Gi3+ka+l2Fd4d8p2Y9YvWyuGUXfg0q5xcmij8K3yUY6umx/ry5tPzPjQZx
	eQCEByHWx4dgfwRQRdOpnI1PLQCcOMIGdu/KKMsOvs6uIIlnHj7HfxNlitsTfHN/MDef27cYxAT
	8///eS0V9fA==
X-Received: by 2002:a05:620a:1712:b0:93e:fa30:f1dc with SMTP id af79cd13be357-944217ebd9fmr1124363485a.72.1793499244292;
        Sat, 31 Oct 2026 19:14:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:14:03 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v5 11/12] mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()
Date: Sat, 31 Oct 2026 22:13:39 -0400
Message-ID: <20261101021340.2251928-12-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E67380003
X-Stat-Signature: cq6rduwmempe85tfirwkdfdgpgfwe5mz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793499244-123864
X-HE-Meta: U2FsdGVkX1/Srfwi8enGQ/+EFyuccs8TBy2HqGm4altydqYM1Ojf4/UAGIzZpwulBCQQePjP7iaSJIADNb0SGbIIJF7OqqOWidqUch6MucjwTU4QbFC88IRaru9ENr1ya0V0/y95n9AGhXy9LIdV2jRouICC1Kfn65oEwP2bdLr2OkK/gO1OkWicHWcalOQkRrTPIgjvnefYGeD1ZFNms0ICtIGh7S+Nr5H4XRqRHy+qNn8mz9uWqJsgLK8wytM0gX+36WVXi1KfS2B6xi0deYq7glHmX4E42DyRirjLUkyjve9mjap5D43uJk0YA3NmAjJwANy3osFsNL5fIWDM3f6cO0Ict4TamZer+cQWqzgKhPk+l2cA83IIJcm5CiSfZdqoO2aMhPSELowjkwzYKYrIyLEPJhyD4fZgpuk+LW/1dzJ5EKoycXE14gU3fzELnTuneSzg28m3aqnniAKr0E1xYM21Kw9hkOFk0gHOtxHONO5Irkk1vH2osCKJ9wFuhkS6lT076u1t0AhRNaa1AuaPxDafY2yu+5WrT/djuurSe5gU3BkcfCZTESg5Ex3q9AJjvZuL2VEE+yPWFzt36CpBHgczE3JYVnIAD18mrcBN7FzAA8O5JStNTyipHiK0cGRdBa/SqIdyvh85Oi9wWwFdMjWdXE7Tt6k6VnarH1yxQqZblkKItDUt12Q1og7mPHzZD8cIeJvQ+C7jvTplBdqutkfKk7SrIELq8nTvoAQ2nSSYjHJZtjRktvyptAvL7cHjjA+xOrcUBlH5byjz5Np/68n+1TSWxIJ3ztPG0WD36lFUyC8eQdoumv5Z7FYMRdsz0O0iu+VjmqBCCkuJBI/f1oFm6Wmd0qJx11c8Y0Kz+shwB+0WtPUapycb/Q7gdHzQruBeEtrlE9Afd7tF2rcQQSmFWBNAoHqFVZHwNxz/UqQWkkSOWf02NJ9p2EiYv5EsTX5weyZr5RPw93z
 tipn3XFT
 5+3fN1kYBc1zr2sAZj6ve/5vyIw87zHCm93mPg7j0BMmF/UEAnRAw9+3lr3G/DZYaep90yYp0yiBiHv+VsUiN4Hb5NxL0ZolQcPeFjw8gsEzIEuj/6L6vjBaR+X2FRTVrN+YJq2h8Edg5a5naIw7lbwYGPYGWdhP3iXKqd5JfRccq9Zlihh2tKa0HyCHt+PSXZm1n+rc3UXFBQ9JlLStfkYc90Om4Ia4dtGXpc8PoFyPf2hhtspkyWKKi53Yh4DQ/ASA8YsYqdY+7b1nszYIrqMFStJG6UCgmJPY5lUg0kfu8YBiXqq4zsXZ0R0ntAVZ1qC4mH0UBHFaAF6MhmSiZ3OPouVPWKYbyQ3jswaJOP/r1EwiOxzUUwTWLS+wrK0Phg6yOMzxwxhe15A4czL0LmwMOCyy3Hh2eREKC+bDUjYGcKGRjZ7Y4f2bRVENQgPK0eOg/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For a bind or preferred-many policy, mempolicy_slab_node() tests the
first matching slot's zone for NULL, then reads the slot again to look
up the zone's node. Offlining a zone's last block rebuilds the
zonelists in place, so the second read can return the terminator:

  CPU 0                             CPU 1
  mempolicy_slab_node()
    zonelist_zone(slot 4)
      = node 2 NORMAL
                                    offline_pages()
                                      build_all_zonelists()
                                        slot 4 = NULL
    zonelist_node_idx(slot 4)
      zone_to_nid(NULL)

Current GCC merges the two reads, but nothing requires it. With
mm/mempolicy.o built with -fno-inline -fno-ipa-sra, holding a bound
task's slab_strict_numa allocation between the reads while a movable
block earlier in the zonelist goes offline oopses every time:

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:zone_to_nid+0x0/0x10
  Call Trace:
   kmem_cache_alloc_noprof+0x294/0x610
   do_getname+0x34/0x230

mempolicy_slab_node() and zonelist_node_idx() are tail calls here, so
neither appears in the trace.

Read the slot once and use that zone.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/mempolicy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670d..cd63c3e2c029 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2176,6 +2176,7 @@ unsigned int mempolicy_slab_node(void)
 	case MPOL_PREFERRED_MANY:
 	{
 		struct zoneref *z;
+		struct zone *zone;
 
 		/*
 		 * Follow bind policy behavior and start allocation at the
@@ -2186,7 +2187,8 @@ unsigned int mempolicy_slab_node(void)
 		zonelist = &NODE_DATA(node)->node_zonelists[ZONELIST_FALLBACK];
 		z = first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->nodes);
-		return zonelist_zone(z) ? zonelist_node_idx(z) : node;
+		zone = zonelist_zone(z);
+		return zone ? zone_to_nid(zone) : node;
 	}
 	case MPOL_LOCAL:
 		return node;
-- 
2.56.0


