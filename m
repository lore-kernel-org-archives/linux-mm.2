Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3EE60A380D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Tm8E1pkK
Received: by kanga.kvack.org (Postfix)
	id 93BAB6B05B5; Sat, 31 Oct 2026 22:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC8A6B05B6; Sat, 31 Oct 2026 22:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEFE6B05B7; Sat, 31 Oct 2026 22:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 566576B05B5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:13:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D108512023E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:55 +0000 (UTC)
X-FDA: 85384929630.01.A36B454
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2367640005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Tm8E1pkK;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IX83IRV13zUjxpE8+UB16/ReS4it9bdD0etB9Kv5xx4=;
	b=sCQ8AFcSx4xDehQaPLptFjR7yT9la2FbXun6aLphjDTCnkl9HlCLc/GAjvMbezXezjPlRo
	lKfXpp0QcNH9QKiwoO25l+6V2I8va0m+ZOb1WxgGzXMqgwfnNTT3HHrnDaELRlFRZyuRju
	o7xrgbmlSjk7vTFij5iJggJJHuZB3l8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499234;
	b=eJGnI3OsfNQVdBgks+C0R2NjFi8A+ldunhN+e1BAGUGFxGfKY7OoS2tsBfcAFzFCoYyuSQ
	1MK3MHAwdot3jjAh/D9N8JyAqbXQzbUakCMcFV7IihiVRvhuLbhIUK14zwWZPrbjrogc+5
	lFqWHREP/2xEG37utmw07ZWUqjUZQlw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Tm8E1pkK;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93ece7a73b9so258162685a.3
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499233; x=1794104033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IX83IRV13zUjxpE8+UB16/ReS4it9bdD0etB9Kv5xx4=;
        b=Tm8E1pkKOFwYDVWNiO6plXrAtyeepSqSGW6TfUBJ788NR4+y6iTjlWl+wuZaadZmGi
         aZjkMN2Q72OvA+cye++HVTQ+UUup3PFGivuB/UAHx9KuiEhLuxBFGc+28CP6KRCgoWrB
         wPpAEZl2KFR8LnNvhmMgGfzefM+4hw2rue3umx+AH9gUg6hg0haizpFYXFQpJTsIFWsH
         aVywmLxu2yrD4xDSm1TQC4ucCptZ4zdB1WX6+TLOyIBSxOKXWhdYhiYBvTw8TbuQ06uR
         ehuXuYRXm2DKkW+gFaAhtcm43NNeng4muzYZoXwIefXembfn1N+TQWxQ+p/LOIAUCImt
         FOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499233; x=1794104033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IX83IRV13zUjxpE8+UB16/ReS4it9bdD0etB9Kv5xx4=;
        b=JyfjdcqNyWLgwojj91kwFZZuniOQ9ofE7lsQcz/kbTMF+1dC2lXpxyEiGetXw7snGB
         wlw7mUdJaV3QbAoSsG8f7H/3x5s/Zgst3XTOu1NaQUpPOFFUrl3kaYN4hs4FwYQA6S9o
         4AqBgIltRZ4hKXRaTmqq7AlOot6yLjRCHQq8+kblEkVQwDJQ1LGeLfUToXxXKkFmJ4dK
         5PPBJ3D5dEJfEWcN5gubTkW+eeJFZJA3LNIH+rHnS0bE6IhVC0m6IuEoVSfrJ5qUVUUU
         s0tjigj5obstcmZtdDq/TGslk02y9qrn1+We8yQDJ2QRdcs9A4osbUGc7n5nMPhRF03G
         5PwA==
X-Gm-Message-State: AFq9FYLg5ORRLzP1eyomdKjE9ZVN59blg6ssvib5Kj0PzfTrHQpTC9JA
	2ewQgVHk1Ma7uoVqbSsrFBraeGb6N5uyoMJLwzy4SSVp5Vt6FXUF3zs2QUEkHBe8gxpdNlrkUo5
	GxWBW
X-Gm-Gg: AYBFou3878E2Xrs8omsQZQSbAQOP46+bZP0aFWYw/ObmgddGg27pVLF+IGNGeihUw1u
	zQVTeYMNJUEqAZ05fky4MnBh/hHat6gkIc9M1htBtTCWACnaMqnmhIQPWJXX7KqVaaE7Uykoq8u
	7ZoT5P8LnA6JRu3np11ui+EPKSyBJXeOQb235Q98h8r4Pdyp7E6Ja+Oz6D9ryxUUUkyln0WDZ+7
	9pfUapy4tmgH+CjrZs/8Ptwfvv+59ghSCmyC8b/CWU0RZPO+q8foHj3av/mBNzNOrzGzGTxXGmm
	rxd/gDkuICVzGQ8VoD60avIm+kLAJswPIOSm6Tkhoz0YLM5ueMO+jo/WtP6GWnT8TTGJnNjmvId
	gc2yrIU1gA6zAfuvjZdYGLbOK5ryH7x7J7XtRzOQ/UqSDpCdrQ2694dQ0VVCNSEJ8RGoalT+DTK
	9zmFHTt/qNqduiVfbuRIQx3xsvQ4cjZndddXoC6gDKdfeF9X+o97CTWefNuc53rg/oELuWsYaYM
	tXFpDgTm2xP37taalQ0/yt2SDDTd20mlz177D2vuv7FNck33z/RtXYy4Zjm8Cpv2Zds24nXahv7
	4LRR55DrXkShuiO+XsG0yvmxdRqRB9u0XS75wTEPyqGeIBIySgy5MKz9WxNAox4aXjH4qFxA+Ff
	M1lJ4os9b4Q==
X-Received: by 2002:a05:620a:3703:b0:93f:3120:6c84 with SMTP id af79cd13be357-9442173fc02mr1051691885a.36.1793499233173;
        Sat, 31 Oct 2026 19:13:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:13:52 -0700 (PDT)
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
Subject: [PATCH v5 04/12] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Sat, 31 Oct 2026 22:13:32 -0400
Message-ID: <20261101021340.2251928-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2367640005
X-Stat-Signature: p57p7hg8ocoxcsz5dqcdnw6tq9wxhrao
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793499233-72439
X-HE-Meta: U2FsdGVkX1+qp+vRDO4mZT4ua/u5FLBvw4CanIqWWsY+jXSPJmDebRCH/CGfZc8PIzdIHB6t9Y3RKNdj2uMk4IFXMwGRBQ+ssKUua+yVCRnPO+BaZNidm61KKd4xCYqp88I/jhpoFiFMlpMtDCOpbU5RlgcbBZC2u2z5K7M/+G4dRMyVXKFOqHFbmgCbU3Kv0WIzBvd3gmjZzqf3IMbyArLN+rb5q2dWcLgaYoThC02ugDNGQ7ko2f7JKRuTkkT1VykbkPKVuW5DlqGAOjoGrqbU9hSRqYQhIKbczJpEUen5KWc6x1SFKA7GLgexwANRk5zyv4iKO3s8uCPZYVzGKWmdZTQkNL4s7/Sybmx52QdVHsSQzHdp9/7KXXMwz3ORgkaeQsQALjNJypdURQQVMLedH07vTHSIeK57mn9QbTaKOIwj/WI/xoFpRzMrHtssiK+ESd9TfR/+YWTtno3kv1SjFyIDPpEHH61y/uybXcu16muGQPrUgR54QE5jP2b5qEqMLUJ5pqblSYk5/HMiAbzBMK+lP30O4k5Lg42ZhWfK71RcN8bixwehdxxnrXQp4IkuaK4CSipmYxXkck3ZxyGw9Mn3gGVRAQpx5vJf9jsX7W7/YQoor2PIKJPo79uCj6yu5Bz4bypovczg5DcWv2oshNg8i3nTBQVHuUnfLNL+sosOBySU3zxBdmArXUzp5NHdbW07zqwMh+QnENPQZ2js8kfAGmi0P0UlSRZW3CCiFzK5lBI8Ds6y1sFuDt09oIvdu4FLeUBGwVW6f2lXY+LadiPwXQESwWJjp0E90W8AJfq/rbHVgYW5TQNqPph4ikS4nYfsuE5KD5/ELHGYvcCysmRsJjv2Ee8X8/6otahrLqlFbs9cMS7lcqbW1+sj3+6abA9Kh5e89k0UtN9VlhwDABxAIslOlLTsOCpoIJoB1Viet6RQhsrzHf4jvzqvEt6SV3+K1CGEFH2vlW3
 V5d4SD6t
 oYkfjnLBRpNKGcypLAerI3VBWxBMnRVfqlHRI4X+aVs4ZQvp8Ep7CnvQsnQa/HfgWN2OFeGFIB78pyCmwDnD4+F2Z+vTVgGM6u4TfoHI6xVskBDl9P6itdE/Yu98AtWJiF5hjO31BjP0Gsur28dJrnkqrcZ2RZewQtevs76dphK+L24XcuikKgoVKd/IvQYBFMbkA5FFtB/1wMMJZVL9c9cdw8jcKddWOZFpdZ6R8dagpM0e6QAODmIhWk6HRBMx1R3W/p83xEL9WZ3YMTUchm55xqUpu6r5c4iJRJ5Qk0Uqwo0YktlauYdbXa9JDPuk+fcIzXrj2D3XkTlJifMM1NM1NcviVIXm2HqStQAcd0pZ2vZu88WbY0bBmA2n3r+S25r5moIlpphv37HLoLcWi/76Qz9gvuS/D4rLRui32BANrOutAXp/4rdv6iFTI0ZVDov7K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The zonelist_update_seq retry was limited to CONFIG_MEMORY_HOTREMOVE,
presumably because only hot-remove takes zones out of a zonelist.

However, build_zonerefs_node() rewrites the zonelists in place, so
onlining the first block of a zone shifts the entries that follow it
in every zonelist containing that zone.  This can cause a spurious
allocation failure for a __GFP_THISNODE caller.

For a node with only ZONE_NORMAL, onlining its first ZONE_MOVABLE block
rewrites the node's ZONELIST_NOFALLBACK list as:

  [NORMAL, NULL] -> [MOVABLE, NULL] -> [MOVABLE, NORMAL, NULL]

A concurrent GFP_KERNEL | __GFP_THISNODE allocation can observe the
intermediate list, skip ZONE_MOVABLE, and find no eligible zone. With
CONFIG_MEMORY_HOTREMOVE=n, check_retry_zonelist() returns 0 and the
allocation fails even though the node has free ZONE_NORMAL memory.

Gate the sequence checks on CONFIG_MEMORY_HOTPLUG, which covers every
configuration that rebuilds zonelists after boot.

Fixes: 3d36424b3b58 ("mm/page_alloc: fix race condition between build_all_zonelists and page allocation")
Cc: stable@vger.kernel.org
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e14d550d4128..11be12b443ad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4404,7 +4404,7 @@ static DEFINE_SEQLOCK(zonelist_update_seq);
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4412,7 +4412,7 @@ static unsigned int zonelist_iter_begin(void)
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;
-- 
2.56.0


