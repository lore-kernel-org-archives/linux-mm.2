Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1BB606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=CrjLUI6N
Received: by kanga.kvack.org (Postfix)
	id 260496B05BE; Sat, 31 Oct 2026 22:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F8E6B05BF; Sat, 31 Oct 2026 22:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1259A6B05C0; Sat, 31 Oct 2026 22:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBC0A6B05BE
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:14:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67CB31A0838
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:08 +0000 (UTC)
X-FDA: 85384930176.20.DAF0560
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6EBE180003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CrjLUI6N;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AqB+6Y6YIFn0HjqudvdVztXfdpwTD/bMBAeQqpR7bQ=;
	b=E9yx5IX01Nist1ecNdGXUzrwct2UhtpHDGBhL71tOcKmf4MVP6Teh+2Lhw52nONCXid3tq
	7pNqVzh0v4DOdb9RAV65gtflcJcYzk57zwR1Ja50T/Nn2Fq9sssKjiA06iPujPSPUP+ZsS
	GoSUlUFHQFumLl9l/zYsKnbGhotm6Hc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CrjLUI6N;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499246;
	b=wuSkVYIs8Jy9Z/oKkigjwiJrOSNPH/9ABeCi4Nco1H7cGvBOFutnj/giEudBIiXG0k8wJD
	cphW9eYM4IQd/gSzTEfwDH9TMZN3DHK2gvEtplg2e2k7l1ZaZq47bPaUlTMMOeQAQlNeiN
	mAiGK9G4ZsE+WUoe6JjhIk3eAkBllJ4=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-945ae2daa3eso39856285a.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499246; x=1794104046; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8AqB+6Y6YIFn0HjqudvdVztXfdpwTD/bMBAeQqpR7bQ=;
        b=CrjLUI6NnW04S08hFKPZ/XRHBrAy0kMF77MqdEG3oJ+LB4Om5t9wyoUy3zvG+EZMwH
         0fC+/P20Wm7+2Khf438xJuYN1AMq0mEIjpVZ2WlJkJxJgfbXecG788zA43Q/K8A2ULIy
         mYBOGhNWhPNhOoQ3UxO0cKwoXbzsgBttvfRttavvWP8XwFR3yvjxuYHjOOPrYFeXMYh7
         g8QjLw5u5tHs3aNCMmnDGJrpYM+92lv/+NBkNn9uZtxMf/Pou5xczaDoLFyLhpfVeLTc
         sMIG6mS+CkPsXSm/CkMwdpjeeRIXg8842Xj9f3aQuJGT0UfaIV3G7tGDzDxvayoJBcLl
         AISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499246; x=1794104046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8AqB+6Y6YIFn0HjqudvdVztXfdpwTD/bMBAeQqpR7bQ=;
        b=zcJ9sNFROEcNXjvf6F58UHDAFFIbcrQLuetiObUarD+bOz4LIMbTBNpisJxLRdm/x2
         YslYyo6J62/2VEQAhiMLhJ60m83qQkZctpM5a3fQLs0a8Se22ccFOM8vW7Sh22MXwAGG
         tCnCxEIZ+rN1Rw3hJovzN+OSe7/qYDVL/0R+rvC+QB05HIbGc9c9qHbFmL7LGj1JyNLj
         9ibMBB+zrdawEjsxF6W0l9O/IoAuJnLnyeV6lVIDAjFDZ89HjB7o8bRvb45yAOP2h/mU
         /JRjI5vhbzHmvfbPzNxtZTo8v+Zr6wr2WxF824Pelvxxa+Ev3zbN4521MYJL6dcSFpNk
         u21w==
X-Gm-Message-State: AFq9FYLt32/yd3dsa5oqFHmPFf9KoGLKtK7fD3X1sV9VAW2PC/GiL2S9
	F6LFTsOJGbFVxPlxA+wE5Zas13A05ting9vNSzQSD5YnHe4TGP7WZUzLOo5cvDvzob3L4A2stum
	47hDe
X-Gm-Gg: AYBFou0lWCGClQZjynExXOiWRjvcQqUs8SHvdOddobXi8OdDhCLjAvz2LUedqqPYTvh
	Pam4gzX4+sDNTL5uUK8XyVrqjS1XQpQu4JIWjCic/Uij0uHGzc/HaBi06pGjDVHjQdXBl4333x9
	i6/uagVlYHEpp7tfVkG180ZF2RG+Eu3Rkcc929fEM/Ja4QNRpqJ96YNCtlBneMMLTc/1EXyFVzy
	se/lgj5SqSbnkFgOiG/B0GBozxzysk0XPMWLOYC95FAb9Bz6nzvvm9S20l8R7xDpA2KHqc4ypIO
	aABgX85Y/5jBYBEb+HBKZVZ989FipaOm9sEp3p/dLTW6QdM862OtZj6eeDHO7FY66zYFFDevrIO
	r4XIYULwKJeSsWkjXth1xNlL/LH7AoY+B3LKjKqQQs1tkK6qZ/kWa9M7TVwdBI4Pp328eYV4aSO
	JF2GfYKA0Q8hAgSmkv/P6HIAGCMSPVTf5u8+jqwoZ8SzY9EWKKTe9BsxEgxNXNXhe7mu56vaEZy
	GcI8gMzhfivnpRdtj9oUbGaWt08Ksq1R0AIQDaIu9e5ULED1o29qURoYgIgTTKrvVLkEGH6YKfk
	0aJH/ldueyhux87ChLhskW0jFT0yJkB5R5jwhAHGZAx834U1RZXTxE9Cs84dgHWJH8quChzAytO
	5ALrRvhFGYQ==
X-Received: by 2002:a05:620a:461e:b0:93f:707f:28d2 with SMTP id af79cd13be357-94421712d14mr1095889185a.26.1793499245855;
        Sat, 31 Oct 2026 19:14:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:14:05 -0700 (PDT)
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
	anshuman.khandual@arm.com
Subject: [PATCH v5 12/12] mm/mmzone: remove zonelist_node_idx()
Date: Sat, 31 Oct 2026 22:13:40 -0400
Message-ID: <20261101021340.2251928-13-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A6EBE180003
X-Stat-Signature: 1jbhpopymxprrrig95frq4h4aw67eowc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793499246-223038
X-HE-Meta: U2FsdGVkX1+6aTX7LeS8Qnc38A1ryyN4sPSNUUfatU2Cs5vOLKUl4lXGRqZvzQ/oWDn03ZCo8KyHVVO5ZEPRI2pi2HcC7CMZoTLDQv92CyOBelLmW11uOQm1524t0KEYa0FSZ4Q9608RMN65amcPf7niFEqDqMDSdKmN5phQG7tcpbXPXAhs7TZMu3dxviAIz5eiwh+UuorrTMi+FEvTqIhrTA+5f+VdUkfh4q1UiA3N7x7+bHtepI0tvGL34HKHDdattxS5MZ7idOjJ9yaADoSyNmGO7aoi8Z76CwIXOxAluX9C/gY7+uWYg2Rn9VAZg7iXE5esXbKJof/3skaYbhFnjGR0hD6LNITv7VgYcQslUuLN8GnJAuVUS4RaZBzXh3W5spP52R3ee358qeXjgUo63mUYHj8sPGbXF2DyoQ6qK3Ip+ZzkzQkt24FSmdkO/WVCRm1Zo0ZhYDplm39a70q7k0ZBqlkid15OtMwc9V9ZdS4JbBG6q0Wb/74vaZaDAIrD4MHMAHmSU0wSoaDaBAtx0UKodNtDieD6CFPFwZfQGioezFgovYpbeyTxMgDPydGv7Q89y7v/8yl7sZmnkzZ6sieQll5p/3YyKLgJES48ew6fklEB3Pq7cduR0A/s5+CAL0/IGszGvcePeY1+fCgkLdwYyoJ8rMqw7jPVRomZhLw2RoQc7yCIJKWLYjQeeRSYh+I/wqcQZ8Wb8z13d9ocpGXebc2ZaxdWi8JfJJaFRWjWQ0bmmwbL54Mab2num1JQnvDXK3mT/N+ja65PWf9VJ7s/g8sRIpp48EDal+o+4SKGgYyiC0W4PnR9LfZ21ZF8W8tCj+SZraaqsupRE/pQAsadxRtwoaEb0MLXNvdScmHb2JrqrexrorEzN23Nqta8svFxjo+g9vCwvqrovIpCMiRyKA7ZNT2gzYcy/ZWUbUD+UOlz5Cqlbg0yU+CUsKNuznbKdT39FOUbADW
 ptHB3heJ
 ekYITFZcnYIIo8VLO1KXmdQIARa7+mqMF7QRXqmtWyq5zEv//9F44FGC8/2gB6uCRHw1nfZSjkYOhW2c94LUYsIK6O6UVtG+9RJTRjfG1mBWeb5nR9+ufVXBaEbOE5kXPIOajMWoVofCsbYLxxpGfjsQZPw43qE4Q5NLyzPZGfJbA45Etr6EBuaxsncC0lZ+OT0ymLhWLZtTVeEAhpPnvHUVaivpbMSBnK1rT4IIAi4m2Z7K84mEh/sw4DhEHslL1BOur9hSgKDfHWULCyEPYpTGGF6j/xNY0ke9mYdYNWaCLk31EzBG2PFr/NMkGxOZGt2j8xGHo7FcqUo77X2JAf+VdFednex+oQlfpTrQLwZtLmIYHDw4TTq/Cilj5siEtahx6zmixDBgBx6ekAD3hk7Cw4S/KITCQZRB99Y49xISwrQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zonelist_node_idx() looks like it returns a field of the zoneref, as
zonelist_zone_idx() does, but it loads the zone from the slot again.

Memory hotplug rewrites zonelists in place, so a caller that has already
checked the slot can get a different zone, or the NULL terminator, from
that second load.

__next_zones_zonelist() and mempolicy_slab_node() had this bug.

Remove the helper and open-code it in its two remaining callers, neither
of which can race with a rebuild.  local_memory_node() runs either inside
__build_all_zonelists() or during CPU bring-up, which holds
cpu_hotplug_lock for write and so excludes mem_hotplug_begin().

The lookup in mpol_misplaced() is unreachable: it needs a policy with
MPOL_F_MOF but not MPOL_F_MORON, and nothing sets one without the other.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mmzone.h | 6 ------
 mm/mempolicy.c         | 2 +-
 mm/page_alloc.c        | 2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4bc2318ac37f..72ffb2959c4f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1439,7 +1439,6 @@ struct zoneref {
  *
  * zonelist_zone()	- Return the struct zone * for an entry in _zonerefs
  * zonelist_zone_idx()	- Return the index of the zone for an entry
- * zonelist_node_idx()	- Return the index of the node for an entry
  */
 struct zonelist {
 	struct zoneref _zonerefs[MAX_ZONES_PER_ZONELIST + 1];
@@ -1864,11 +1863,6 @@ static inline int zonelist_zone_idx(const struct zoneref *zoneref)
 	return zoneref->zone_idx;
 }
 
-static inline int zonelist_node_idx(const struct zoneref *zoneref)
-{
-	return zone_to_nid(zoneref->zone);
-}
-
 struct zoneref *__next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
 					const nodemask_t *nodes);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cd63c3e2c029..267576054980 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3087,7 +3087,7 @@ int mpol_misplaced(struct folio *folio, struct vm_fault *vmf,
 				node_zonelist(thisnid, GFP_HIGHUSER),
 				gfp_zone(GFP_HIGHUSER),
 				&pol->nodes);
-		polnid = zonelist_node_idx(z);
+		polnid = zone_to_nid(zonelist_zone(z));
 		break;
 
 	default:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 91ad979409e5..81c1de714658 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5973,7 +5973,7 @@ int local_memory_node(int node)
 	z = first_zones_zonelist(node_zonelist(node, GFP_KERNEL),
 				   gfp_zone(GFP_KERNEL),
 				   NULL);
-	return zonelist_node_idx(z);
+	return zone_to_nid(zonelist_zone(z));
 }
 #endif
 
-- 
2.56.0


