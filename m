Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460E8606A881
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ZVNqsHCV
Received: by kanga.kvack.org (Postfix)
	id 628006B05C6; Sat, 14 Nov 2026 02:10:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594316B05C7; Sat, 14 Nov 2026 02:10:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D796B05C8; Sat, 14 Nov 2026 02:10:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11BCF6B05C6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CA871C1BFE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:37 +0000 (UTC)
X-FDA: 85432851714.20.2BE8640
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id B985B140007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZVNqsHCV;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LMm4cY2G8/N+lvY6+YyUeSTrUdIgOLxyZozNrk1mUY8=;
	b=OtiaBVh2pesYcfpaBlcD5YmoGTWT1ybpfjbxMwcGnf/9L6mtCiB7sLkj9gykgNxCzm2Bvb
	zCkTKTfZU6WmPEUSlsZTwWoUP8vF7urzYKjKG4NS4j0WgtJ6pZJA32SiiLg4Ql6VCnR6z3
	oLEk/JZSQ8FGtp7ySEokqr5NhVmSKL8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZVNqsHCV;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640235;
	b=1KOE/PwfUy3zQ4XKAnDOE6Lvc0cJImYr9Ervv3fKO3NY1IuM3qxHtzrBmEUckLjOawTBhp
	5mGJdCA7A5c2mLM4ioc4mm5KjMxwW7q9cVQZeXBzxmGknZIS4VJ1hnQdJlBpPCkln1HKXK
	j7WkZNGJ6LzoNwmp71cDcHrksjL2esg=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91f2b826fe9so19623766d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640235; x=1795245035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LMm4cY2G8/N+lvY6+YyUeSTrUdIgOLxyZozNrk1mUY8=;
        b=ZVNqsHCVGcb5duS/UI6hFhTI7qz5b4qW3m2wmZvjxzyEg/4ytulHQuScc9BWJBZ6o0
         O2dP8SmvWgBM88ReI/LJZ9opUCLM8XC1D1l+3EN5vnoM6n60jcE8MVPyLBXVfZciuNMx
         JJc96dpzLT+1XYkyFqQFdJm7MCF2Uop3Bu0ImKJvF3JBeOq1u4DlhVDPk5iVLYD1LMP1
         S5qk4uaGUhJDnS/GzKCbdd4x8FTOkJ7FG2rcmKjCk5pSlaybiJVzfOk/m/3bTFeO6+SW
         +PUhCgq590KYPFjwUE6GnwNySMGvF3hc9c6xvJYpWk1wdAgl/9pZztHMK+Q3YTdrlrQl
         5n4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640235; x=1795245035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LMm4cY2G8/N+lvY6+YyUeSTrUdIgOLxyZozNrk1mUY8=;
        b=QZzARZUkaZDexcgqb3l8x1LLUYwvkcR4gzr/ckyStFKdomJtUk+4tQtzZkTFzk/L00
         rTZKLJTDm3j+eM7zqVAs35gAcl1uxeOl13n89EIqg2VtrkYiYpJwcNFM+tT1cXnHSCuy
         S5HT/J3CFovlbO2+l7cmX8xTK1vxWzea+/1HhezR9ucQ8MeYq9x8jmDkWQhJLpiwJLIM
         It2EooQoYiGLahOEfVsWmH74NIwjZ1IUCaYt6fj0NInlndZbtDvhW3PbiCOjsURZRhiX
         DA3ZwndkmPN/02i0OGE1tJeFOz2A28WBXPvnjY1ceZ4IR23zCSefB5aLz9Kr+ztV2x9u
         jFQQ==
X-Gm-Message-State: APuU4Z/vkqEtJsN9mm+vlX8NYvWxo4Lq5Uj5yu59CFBlL3RsfS2dultk
	OjrzuXJRQTI+kqITrerm+qS5T8Uj1KpG3EFBX57Tqip8agmAZiK6FdVbKXC8DLg4/vbIBWE8u7j
	Yu8IG
X-Gm-Gg: AYBFou11+E8Vi8lVLrxzK/WQ4cUhYZg23+yjINyUA4BkF1BSQ90ncO2Fc/EStIq4vGh
	8yj85IM4slGzHN58Sla5J0n/xvpLjJ7Udb6sTkrYFpJV6JZK07YO3avpJySKYYwu56Zfl4xuq/L
	YUvFFO3IY13XMg15Zu+ukwBfQnPzVcooLTsGnUyBwKeifZY63KXCRXK/yhOlKhG3oRTvZ2VN1LQ
	2zzUg5Tvj5Km96Pk4NNCSnsuWrgMXN3Drw6c3CiTFGQswELBfZOTwWhudt0VI2NJLQS8UIrCZ1O
	iCoK4auwgn90tyHxfgOCHkK7YyoWIjE+nA8gaFIn6V10LJ4SQNj+imXeqfspXfJwUBhjg0GOUoU
	ek2CagLC4GMBWVCkXPKKHVX6/FT2LRl0kvDXaDfZ6TgD+br0yUFqTBVMigiGQW7U8lwmEk3X5/P
	kBle2wpWpr4Ze9O7gmcOlNYEzM9Nn8s5DBWsC25htt/vea8DL2IckxKIMc4yJMTqi7IFDPQ19H9
	SCuI4wWPvIA2kgQF+z5oiHHiOdPkyKHEMuuzRXxYtIM1rURSqh2GbFs37Gy0Gayg+u2V8qu5TwJ
	1ExBNutivm4eYZDA33WtyA02l/si769r6+krCRxKJDFNMcliPhDpCxCgDTzTYMXvYdy92Rl7T++
	Kw0j6PzEmRKMpW1g=
X-Received: by 2002:a05:6214:1d2a:b0:91f:17be:7c90 with SMTP id 6a1803df08f44-91f2424c199mr78511936d6.55.1794640234508;
        Fri, 13 Nov 2026 23:10:34 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:34 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 14/22] mm/page_alloc: count common memory nodes for kswapd recovery
Date: Sat, 14 Nov 2026 02:09:51 -0500
Message-ID: <20261114070959.3490008-15-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6bq7r15fkptzz5uhba4yd6qfpr5cx9wu
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B985B140007
X-HE-Tag: 1794640235-68862
X-HE-Meta: U2FsdGVkX1/FS6yIWGcRQc+3iPhvoNdtTrUGQ938JDUatiWhbg20AS3W6Wyd+Oj7Y+h+lqtoBt5WsgTLCQfNzbevNn3qTt0fCxPjeu7cVP6+7iCHx23ZwMMHaA+ELhfdQZufvZsNaRW1PxIpRglk93OBNNC4ZrImoLWbiZ45aS22gnFb2K1snWdTTdTAjnyPboJRyt2cDqXb/rnhAbqjXDODyJHyYj1tNOHA2waFnFx7vLjbr2WnS+FRBZiDekWD98b2Zp5Cw1L0/ANVdWVYC5pS5sGxADwVtepGSb0GATHyO86Kygnjc+26SV3strI9H5CYnIzMjUZCXqODKl3Tkm11X+j2Bv+07el/QjBVjh/teZswqZRTazeqXJ0VpHiP3QBGcxjKF98m4ijIRJA3W5wmA1+s35wVRJPpsD5ZkyNJsvfdYM5c8/Xx5JCjAPlrmCjvh5BKosmVX9HC0M6Q0yCL3E7zO5EfsjunJtruNUZMFpZ+Vfo2CrWwMFpHI27YZp1xYkbPnwrGUAzEvIAgjLEFd4z69Kwv83+oaGLrkDHap0tOsFDFznm43C+dOsYt66oGuv183f4KCszCTTAT0nPhpB7aqZWMqyfjhcph0JLNyPVe+16X8HymBdWTMJGkNbWeIxVeDtNjps824trSYtl4QeF8no00ymrFJa6pBl8i5Rlcof2KstPagPnh20DAoqVj4YEfN2RP0sryBsW4oErfrlvxeGhFvdaPwOCiNyiOByAMm5UpoubkM+TyZ9DIBovMk3rUJTCqmkMCSeHw1aSxix3zCTMYtUqsWEHpe40bz3GkndcyZ70nteZHeHKKo3u3BG7HGWopOBCt1Gx0dCLlnoa01YGy9aF2rby4b7Z+E87FNQbikLzQ9ZrRygp/qr1g9rccM5j2iKnXT2PsN0m6IlwzSevbnnUsMR9CFnW4lsk67M2/E4jUvW2eozRYZL6mywPLeMd203oORtJ
 22nxMRP4
 vP/9DR+Iuzkcws+jrH8MDQRB1H5Ltu3nveRK9Ix+0x0r9Ej6HMFxmJQ4IZSUodq0aI9McCDIinq9sx0yaMHvuN59ezFCtu/9Ds1GIK08mqyu4Qm9kVJSHTUU3pJFLH3bWaxJFT9b4ktuBs2i0zZJOKHW483/ZJ4l7fNj50AOdJsD6i7USwV4YZRNPpuv41Y1Rqp/o8oazG0Vl3iZPyucfdeusCF/0LvSLf2D66Wpaoi9yWbvygXdzBOGInl9ejf+vvg+HCn8RcyiGJa6pikXAZWivE2fWkbsde7a4Y4ftpeQ8orodKdZ04gY7wmfZJA44M3ddAcsRBEaB6frtiHfQF5QEk7D24U85J87CVRN2x9ZK0DjQF3A2Q4CdMit2HU0brzHZXQ8VZLkph/pxSWY+87GQK7JXuHEhVdqUODul0uhegzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a zone recovers above its high watermark, free_frozen_page_commit()
clears a hopeless kswapd state if more than one memory node exists,
since allocations could then have fallen back to another node without
triggering direct reclaim here.

Only common memory provide fallbacks, so count N_MEMORY_COMMON nodes.

All memory is common at this point, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 580feeb608b7a..6d98e213460a9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2949,7 +2949,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * kswapd work again by resetting kswapd_failures.
 		 */
 		if (kswapd_test_hopeless(pgdat) &&
-		    num_node_state(N_MEMORY) > 1)
+		    num_node_state(N_MEMORY_COMMON) > 1)
 			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
 	return ret;
-- 
2.53.1-Meta


