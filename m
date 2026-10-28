Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD261606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=X/r8BpWb
Received: by kanga.kvack.org (Postfix)
	id 61E936B05BD; Wed, 28 Oct 2026 17:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6556B05BF; Wed, 28 Oct 2026 17:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475806B05BD; Wed, 28 Oct 2026 17:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13FA56B05BD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83878A7699
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:46 +0000 (UTC)
X-FDA: 85373301972.28.2854F94
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8B27220002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="X/r8BpWb";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAcEs6XFMJPdLRK7Qq6ZCf1PAdLxwqRv800fWic7tw0=;
	b=BVYdJdg6ltW8I3pBK2DHk7ZO7J/WjF3rlXPdVT5COjSGTNxpswSVwYOJvxO8FoeWWvwk/Y
	RWDt7dQGmO30E6YDHD79ab3LuqmFTTDrjIEpxZN6x047AVfTli3BUIxzNLPZd61ZktCkng
	SC99YWPE0McTDIP6yNbfcpDp0u6hCqo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="X/r8BpWb";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222384;
	b=C5c1X7IdIqtYxP1CHEqNEc0mCCdrSoPZrZX0Af31lDnpx7ot3BiFeRv7ZY5c6+tcMayU9O
	6VvLPMxgdYDAkPHE2jqUPhqWAT2BdGaZrwFEXOSnxqrPukmKpYNDHshgplISfO4ObUE1Fk
	LfM2V9vZZRgHDPgHXrZd6ZITNGDu9HU=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-917a64f28d0so1533586d6.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222384; x=1793827184; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RAcEs6XFMJPdLRK7Qq6ZCf1PAdLxwqRv800fWic7tw0=;
        b=X/r8BpWbQCZ0s2WRspLOwH17Tr4F4eMH95QU4/Ko3XkFkIL9GrOyuVTiuTFAsKHBGD
         PaXzrYAZyKUZPP1BLcsYcX+hebWpOElKe0RU5s46xMXBk/SzN+qBtU9WwS9RIAnR1FFN
         IcjMTr7abjkq7myxrRsr2nkRVTRUqHMrt+Zbu3TSRVsW8M778DVSp2ZBhs5M9Svak6pd
         SU8dkVqnWVrkdx5f2ZPQI/DnCzHp6JrmoKjzYtoPFM8EDHTSwsqvIqXRtCcXiO2+Jjsg
         BTnE4sBh6Od7N+XQ7tRkpavOCD+hdJITW5cvo+mfupbGsfpyj6KXKG9s3flTKqku2OIc
         FI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222384; x=1793827184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RAcEs6XFMJPdLRK7Qq6ZCf1PAdLxwqRv800fWic7tw0=;
        b=Xx9Gi+lvrUo6NRRg5qVt9Qw6D+fIKpCqQm2jZ3CjDRoXFVuF7DuytGDLRskMvoHxsq
         ltzKsVVDXBc5yHdnValnnti5wYYMuNYBlkE/iFRXG6dd6HCZNsl4OCEuVyXGQ/jwyp2f
         NSfRZ5u3FnEbsh9kjxRQSRTyqU6jeYTZ8crkou6ttEC8xWXBNOXkfPLlBR1PyBFt/czC
         OOIQZfY2NlUJJ+o15aOTmoQKqLd4MmtC++OPWK29OlrMJtSOuPaPFhwzkwoBTYRiTDeA
         cOM+XVI/J2sziej8xtl6oUS2DFOQ1eq4tZzU/0w0xvTxg72Cy2j8HLThEu4XGVQO/NI0
         AiPA==
X-Gm-Message-State: AFq9FYIRhkkyI/N/TzjB5mW0LNZjynWXZVHpFeohyIDE2dIZSce2/UI8
	ATNm/yuM7joujXvlXl3xQRusBty0xah9DbChe2sz/F3icSM58VvxDUwLhgWaYwTMzk4rERtA5tJ
	PnZLkS5w=
X-Gm-Gg: AYBFou3E8JVuAAGutRVkwiWicNRAD8MMZp4KeIEC9U27bwQzb3qC440X5P2vD9lwTQi
	OrLiCoHop2CKes8MBGoRBtw8lDQGvp3JryXtb4qIDl8YJAOFznuj3ORIc6hCNMx+Dle51WAK8VC
	/bO9Mc7nQAG7jx6KzxDSGduyEv+IRjFkluudAY/Oj3vT5gIZnugM8nyZEpabFq0o4T6N5xLwKGS
	Bvqjk68++JYPCS+vv3gvQBwI/vCm8gE/fl3zI4NXIiMyVjvyCjW+ZQ2Gb7+miPEJKA0qscCbY5+
	zsp435Hc47uJhLncV6+VR97PQy3l6mQH1CrAJ9GRTX2p9/Dsxz7wb6r7cDXAH5135b0OjdwqEFJ
	cABaIw/ziEO3OVZr3GgApfJ9/FDtZG3pKPEK7XN52d+fIhxhixQ/aDR9MDqri/qSDpKJTiKp+KN
	PiZG+jgnEOqyA/yEqvIrv52063xqomhnTKz/YjvK3Dd6vBb312J6zq/3baL+VBtwFaGQw9P6/Ke
	HwTSJQvtjDmzMigjZ65y7ZTqfCnyFQiLj3Scjh4I7cP7EkPK6GQJnHgXk4f3WvLMODV//wEnesy
	zxWaQkf6fYwQ/pkDnGeCHDxjJOJlyL34mHhT0VkhVnx4vX/8oxZm6El5tSn4FT442rA+5F7pR8K
	+P82zcmjveX9V5hwDGxN/uMOL9iPdzjoUKJPn
X-Received: by 2002:a05:6214:ccf:b0:91c:7ae8:fa2c with SMTP id 6a1803df08f44-91c90431fcfmr12968936d6.14.1793222383945;
        Wed, 28 Oct 2026 14:19:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm139778966d6.3.2026.10.28.14.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:19:43 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v4 8/8] mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()
Date: Wed, 28 Oct 2026 17:19:30 -0400
Message-ID: <20261028211930.3504634-9-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028211930.3504634-1-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B27220002
X-Stat-Signature: dtxudbhhi774cqds3e41epxiinwz4838
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793222385-179603
X-HE-Meta: U2FsdGVkX1+T9pLdrDuOruYNe2wwzSQMYKk2k1QjZEdz5PiEKDA/8LED/FfvjWTx+LRzojJBUeHhsUmJ6XNXcRhdtQ9u8GC+3kem5lHDAf+D7/2kIJdIIGsTn00RHDiDabZFWnuPpCm7QfND5XZiU5ZOeSu0WgJk7mEGi46v1BnCvWwtvGbvz+8uay/sdrkfjzqC4DiCwrRGbrmwatsXTvv8ZGe3c6ZJwBoKIgj5pWk7W3fNybIGAa7GcX39mpmKwf3qK/CaBdiHNWIEkcIlQVoHSOSX6cAJP3oB8z8D8eU3jfUZuf+UwZjrF9Z5VJDMsy6HpgqJNEroEtFQXQd/gCY7TsN6KOLQjsBmp1HAwhMB9Fuxd5AOYnvtXqMjS7PxsxOadpt/RAlj55v1rGteUtTJJAcZnLIbUuFUeru4F+GioAVc2Rt1LiqrpcUz89VDjGoZ8Kdj1h1yNiDlE4WU13Z0sYx2Kc6O+RbrYhCtTmUoDidSM8CUJQlhhavuG9HyBHsG1UmxZrGMNz9+DCgcmdjtbLpCdZJ3qPPAHyjWdS237HTXvqsgYC+r+m/7kpHe9mrDCe1NA8UWfMc6ZzLakq4AybhGp7ljVgQIG79RkGnjkHoedJucQGYkXflkdXh8T51FwMI3/SK58zMkkt7A/kT9pGKhqh8VRAjPoOwETGH7kJKuHqgYy5Rw0rmQl7edIsJwxApRohudq4jvXzI5Vh/6PsBpLM2E2an4sERz+ESxGsgXebEztH9bTHOEyga/fXckW9BVJzBLIyVGJ0VIfL2lJDkDw0SZhIMJTpc8zp78IgBrUZD7/TD7e3PBsvHQISGlCLtEY7G2WDIoCt7CW3IE3z1rBvPZISlFDtS6vRGJgKIbCaAgNZNoZ1O/Av3BLL50Xa6pM4CWWuQUb/iTwGYlDFzk5HZIrF+ujBy1v5fTN17ufxQ7X6pxqI8e3zRvUL9i0WQydfljf8SW6RM
 MsajLFxc
 onBe97WFoDsLGxfZjTXvbBq8mXBNT+3Ttz5Qknoc8yXzFPpa7nRwy3M6H4KykchlD48VO+c45ugrWLRnYWB7KCF8DRJfmtD+6YdN3XK6dJekUS+P7yUzwlabGRzcu8qud6aNt5ooPFNMrexXN9lUFVJSL8apZ93Iz/N/t4zi6qrCDIFtpwOvVziHhB5zxmCgXOIscO7Hbu/C9b4TAUT+sXpPOoKMQCKrSs7AzKS2YfuiF81CpLwZS72SR4dt0b4Um9B06L7K85a4fzzuQaTOz30SpVYLYI6C2q1vW8z3GKZHzJIdqpQH107vcRqR7CfIdHa432UTQCq6F+vhFi8kr58uJRfVGuOQRPbhbkGZ4tjCpd30hI1UwzA8fXiPTEuMJ2jLpzpROaylXcp2cp0HwtIMX7n7SuFjdWXhHiPcNzjngA4cDXikse6+0SN2ZmjJ1iFGD
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


