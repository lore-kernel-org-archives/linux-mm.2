Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAEA606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oigd/Phg
Received: by kanga.kvack.org (Postfix)
	id 341EB6B00EF; Sun, 15 Nov 2026 23:40:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F05F6B05B0; Sun, 15 Nov 2026 23:40:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0716B05B3; Sun, 15 Nov 2026 23:40:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED8816B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:40:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 522C5120522
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:40:47 +0000 (UTC)
X-FDA: 85439731734.17.C64DCDB
Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C848180003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:40:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oigd/Phg";
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.74 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794804045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lowWXPPa6IhhrsA8lYkt58nukDSxiG64mEXkGZf5zlQ=;
	b=jSNgl4l2o+AfXCTO5nEN9jK9XCByTmnipOJtKLiKlj011g6oT9dlITOB5ZiHs/bfptTf6i
	86YPBQx8v/kp0Q6x315PEYC6t+jNUz6AaDMUOr4TrjqMqjo9Z4/mcZANoJtcBoHA4NBknm
	7JV0jnrrvMPOJ5fFuuHtuTzV7ZbKArQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oigd/Phg";
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.74 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794804045;
	b=Rjk9keEN1tFN8N7xv+ZWceJlPYeXsdh3VGNZM6GWjih84EzQJtbij7Zm1DqCLN9oCov8J2
	OtIz/0ymKQtXfEMqnJi5fJP6ZtxasBRZosznXPbniUIQI791t9pKS+1lFzg76gRTA3GsYu
	51uK/YTj6IwIaQowaAiTYKLBnnW9n60=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wkYROWez3KV9qDm5oG/7+0bZbBndD+X98UIdC3VnWrA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794804043; v=1; x=1795408843;
 b=oigd/Phgsyk4OdqUgWyH+NzqwVgcNesOTcLQHok640M6/nfd01ErO4WGRF+dS7lOAIrNOeZI
 Xgjtrd2Sb/rhrs9hN7fI6vkBWztPRJXdqEZb9EedrtyXDB6r59mKKhQxO2COvc7xn+4v/gAeRsk
 p+E4iNTKznE8274Y8ogswcQc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 44426cc0f36867df;
	Mon, 16 Nov 2026 04:40:43 +0000
X-Mizu-Trace-ID: 44426cc0f36867df
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de,
	rppt@kernel.org,
	lizhe.67@bytedance.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	jthoughton@google.com,
	lance.yang@linux.dev,
	qi.zheng@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/14] mm/mm_init: factor out memmap_init_page_from_template()
Date: Mon, 16 Nov 2026 12:40:33 +0800
Message-ID: <20261116044033.26591-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261113033442.62970-2-songmuchun@bytedance.com>
References: <20261113033442.62970-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 11brpik6uem3ddd6j78w1c5pxowhsin4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2C848180003
X-HE-Tag: 1794804044-35288
X-HE-Meta: U2FsdGVkX1/x0wsdikPZ+JrZZqwsGuQvks2C4U1PuKSYpPK75rc0jAkkbcYt+N3MorraTNhIXHHsIw0ErgMCIndTgK8crKbPCfUlbo3MHSqYh2qxiIrQ2o0AWMQ092tyiYpp5pGw3EHokvt4Y7jw5K7xPyOpZdeFw8QCGb7pFUYjwCy7ROxjxp8dPo8J5Fijs7/LkIkWiIwQ66A0yEdbAAVxjdb2rjxlQHT/mf7sTw7TcNN9Cn2JX0HsuJWqv1p8eFeubqpXJ7XEMvWDZd63JkDtOgDICY9JHtvdYbq5Pf1+Jr9tS08gXX0TCAXZijxZn/G1IAPOB2hUehqcEu/PuH2nbVvRPbF1vA6vLcxPxMltrknujvHLloU7iBpvpbZZAuTdD/tc8nWEdxldJNw7FbQTfU/0H3zLb+eFdNkOIKpoefA48vgeurJz2QdZ8ketHblVLix/Ka1unhEbChGnaRvT2y/zOwM5lcZuEQlOZyJLVJFXSVyJ2CSc3/CbeZz1nDYo6mxvDXtjqdBgm7VYsFB3VDCdANSbiLNU5FHgfzjHIKxcR3eQLma3Ce+JjWlaiHu6AB8SJMK7EPms6YFvW0GrCo1TRSmWTlmlbmbdFn8GfWFBLEWZlT0dAeWh67Cpvj8vsypwGxrmHzyHesCgsmo2uVkpkDr/Br7AUxfum5d7gxtmOXAU+IIr0ZrzyLMbkoxtORsSEpBzhiEIeOrwPFDmPYujPQN3T1s96MhiGlujkApXkg3CMY4YJtC+7nvTk3StBjGr1m6nf0GR1+zDcyQnHyP6+jyJ4sV1tiRVxE7sljnl9s8T7WfYpR13Sr2igIF3lr3ImWPu9tmCwOgg0AIBZffsugxG5XEdPble4OppVWlzOj33gq29WA0rjwLBVa1ErX6/M6XgfSWPrgxbYZ2CXsXLqnQuTDtQMMZVZBHaDJ2jcqJ9bos9/2C98yJbIX4zMaDfZiVlQLzDJlO
 FAKw6Hv4
 GKlOTz/pJ8iOUXJ62MNkieima+8qHKl63rb7yRtAGZ8WrWmVu5luSLD3oEdrQxD9AyaBnK+Nt2+QI4ZiYqynJo9IaRZkLfnsAqmgPI6ecebLFEEMaJcOO/Qki3homwg2D9m0bX7wl4pcmmLWc5IYzm8I1toi/guc6nzQc4aKTt0HV28G+SVuqR/TpBve3YWW2Vylb4SW7i9W5tmSWeE0RIWGhhS7KHStL+mMT9C/qyyfGX3h3u/Z0DbuUXvcFw4xg94NR8jcRVkk9XDSZjtpqUlFpG6qqT/iJPVj6fQ3ix6dNHbHD4yB0oBRJvJnDbf7svqDyC9s3xLCUAn3L78LaSzg9ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 13, 2026 at 11:34:29AM +0800, Muchun Song wrote:
>From: Li Zhe <lizhe.67@bytedance.com>
>
>ZONE_DEVICE memmap initialization already uses a reusable struct page
>template when initializing compound tail pages.  The template mostly
>contains invariant state, but a few fields still depend on the target PFN
>and must be refreshed before copying the template into each destination
>struct page.
>
>Factor that operation into memmap_init_page_from_template() so other
>boot-time memmap initialization paths can reuse the same helper.
>
>No functional change intended.
>
>Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

