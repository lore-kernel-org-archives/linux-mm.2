Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D05606C941
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AD9lIo1b
Received: by kanga.kvack.org (Postfix)
	id 0D5476B05E3; Fri, 20 Nov 2026 13:10:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E1D6B05E4; Fri, 20 Nov 2026 13:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4C46B05E5; Fri, 20 Nov 2026 13:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B20326B05E3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D4B01C1C6C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:50 +0000 (UTC)
X-FDA: 85456288260.19.1B1C8A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 23F7B2000F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AD9lIo1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf03.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198248;
	b=Rz7G6zFjgBG4VGSaPP+/IUX+BFU3GT4zznt1COjofVayJEej+AZlBggbn5LUZ9B5Dzlkbc
	GPBNbPdm/q8b3oNXlVQVrswXxGdi6cpwjuOKiZeNys0zd+BVTTFy0+2c1fBeaxnPWIC4fu
	WOMCLCiYGGko+D5S+7ZbX48Ci6q/dV4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198248;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBy5UCo8x8GxER/KqUcslMwbrqch/uKM5MuNKEpgn9Q=;
	b=ozz9bsp87Q4iTUwytINVAwlm1awrTvyDO+O62rjbtJ10pTAqVne+u1ncU1pfIcdaXaobUM
	swxqS3jhysQH1lFCMtDIpjR6oXMJI8tPnNQlAEZVXJq5GKeg6ylN07jtKxRnyKkkAFsBNr
	wZxmEj0BJARDaA8RP+0wx3k7HLYLxSo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AD9lIo1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf03.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5CC963412;
	Fri, 20 Nov 2026 18:10:47 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198247;
	b=SUtuXjErk6RvGfcZwwHhOHxFmRulKN1sdH7y6mRmbMra6pIjW3yGlXCTxVNy3EQE9I2q
	 FztYSbTNaFen6rILMckNOgQi3yRgBqvwZlZoaNp3dCL1AZ1MVrVlvcEFbbWE0KbPSaOc5
	 l7vkXlt9ETuvtxV2mS2Vd85KXavFgo0GNLbWOJySHzrHlRuBl/2Fej2Rsw+QAfLUNRT3Z
	 0UZThiPpKHt2FIy5zWp6SQMTSnxaMWLP22KOE/UeoYJshYcQVDZbcZC90x1G49Oa3Jnt8
	 dqIuDLsXopptCMtsu42neKNKZJSr6tRkqtbPVCVr0/iGFSQ+IFG6ByebwPV0WTelHcw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198247;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FBy5UCo8x8GxER/KqUcslMwbrqch/uKM5MuNKEpgn9Q=;
	b=aiEg/I9fNumJEeEBISpGIVCo0VaM0seAgyV+CVdt0tlFvwsopcbOnjEoLBsY8pCAfyCK
	 c1wgubDSVvOqt39X/qEIZv4cSOJPap0XbYSRrGebkUdhyvpT2cLMW4VIOzM8+8nLzq84v
	 mpU74HvpWmdPOx/lK/KThtr2z5KANqLSSU82Z362nmbDpnN/0BIHXjj3+Cfnt3bElB7xC
	 vVyUQXYV86KXmOzCWFXo0pVMRr5hlm1ZxYl8lkikW5TShwHAmLN7n/DutI7hp7/1tc3Om
	 cVDDlG4KJhAcDFX/ryqe0r7eVR3m7sSjvYpnFEIF8CRncB73zl8AkTnk7oh9nS9iyqQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A34B61F000C6;
	Fri, 20 Nov 2026 18:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198247;
	bh=FBy5UCo8x8GxER/KqUcslMwbrqch/uKM5MuNKEpgn9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=AD9lIo1b6JnW+FDdvDRw8ObPRM2ThVqMwgvmJrSCn9PpIfZcdpmZMHBQoTL655CB/
	 xLltDXY9PMSV2Z8/mCy1Vtss5hz+/Mi/psaW6ReHKI13IspPX0KEtphqLK7ezIDLT/
	 YIHEDkT1Kplfm0AiRg5Hm2VllZ3q+ggCAefAjG0zK/oHG/MBYOMwuvW548NnMpnyAS
	 14pKawyhM60vhrbI3nGjDAWrfWsfjuLsiPLDqMkD4ZFFra63mxjftZZFiujXzTGVlN
	 FnrgsM6sF9z729s5oZjIxBMYL2c2eCa/xeYF+K50pgmiLSZff+y+R1do5OXJvF+l0A
	 NDo6JZJNQOovA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D4DB04B941;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:23 -0500
Subject: [PATCH 32/60] cgroup/cpuset: keep spread page cache off private
 nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-32-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1224;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=U/hUJktwLNtMpFnMwtT8ZUgdvPgOHOmoMK5TEsERPVo=;
 b=6zBGjHr356XwIzle3h4wX/iKnG/2+8B5GuEfHIteJvz4xCnBp6ubmqH5bkGYDUttwW2K1KHpu
 JKpw6/sCtwuDyKwjrhDyjB+1mRZE/zXC/EcJ5YWA5D7ZKOSyFjgOwu9
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23F7B2000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cccyxuxdt8rgbe3g19zchfn6tjuxwtgk
X-HE-Tag: 1795198247-864148
X-HE-Meta: U2FsdGVkX19ANHOVV1p5AHQ8x6RZ5kaNCKu6VqO2RsMCplACfb/7imBYiE0+9Ru8e8r12ZMItNiDiZpp/2XVPOyxdx/zPFyvYKHcUF7tgzRKUgClGBH/fFlweK4Zcy5LN38Cx2ChNZd13expFkW4FLodh2tBjbEveVNZlD9AmKP52WnKEPEaX8sH6f0pDt0OHIKbbi75ULr6kw9rsUmrHp5XpOucSwPAsVGkjmilLZNJJuMa8XEinY0FklEd/5qxvwilnrFqtAZk6u0k37wZJevuCA++0+EZCBEJx68hk8JvdxDbV9lNk71PTuPA1s1rS57cSeJZRBfdjTtKxp9pV6MJwtU2SV1quCKhaGHTiThucLp4ZYD1GSfrT7G73nLJW1ku1ZOYmt1jTxH1S95iLmlbIbs8x2ube05LnXF8GjU0Rf41+5tT6p/l455E9XrWNZjrPZKgEhCaqaQM/HejP0y6Nb0xGUx5eKv50y0/2/8dQy2LBMy4vlVYPbif9eWsu88amU7oHlVTzwtOlpKlZhojxrXBPVBSRN45lDNEb3IvGL2kFrhMx5T0+kYRfoNyyPl/UUyHKVCrgw/pbC1mrG4+caEHkgIYjgoewWjjG5XCMHsbcpBMvlO2gpvfCdzrBFhTeX5gZF4SjiLH/rmFRmKIgUGOkogc/TVdP0aTpiWgesl3XAVsbZiJKkX6dL26wNt7/7XScTkZ/mQk/TIbSPrRiy24pysOJTBc4ezVOmKRW0Dxgw8sSM994Wpi56LfatR3W2TWAu9cv5dcTFdVfdsIC7HAnEwSWA9lqigQ71sxTdXFClLZRi02AbJRYpcZaDDGmF8cH4ntYyubUL25ScqYYVVBdTE7CxVyZYJk0O5djxxqqCHY9O5D9D4cJJPJuwbNv7TZE8QPBkf+OIHRA+UrjQN5tJDwcM8/StIiBiY/V7ZRjKOuHZx9Iyzwnl5gz+rZAUPfn5DhYg9F6Ut
 1yJFgmV+
 6lUb6kP0IfftDVGwaM6laJ9JSZEDvJWGdCb6xgzJezARLk7TWUhdH3XKQu9h0BfnauOhYqvzx1tkndhHBBuca416Q8/5VHiAL3azBegV9RZeF9jUDD1mJX3TxBxdUKg3gObtRvs5KafhDfPLXqQnEaUBENIWy6U/6rXz7UZPaQbJDi40oJwtYQIu4ZvRvioRSdEJHbrZs+wCl1hTXBdSymsnPEFfS1iqNMMI4OyV8TQn7k70OLj0m5mmCytuTZ4TMWk+SO9K4lVXRSLI1kmRUZ8Z723p6Z8zYsVHv5iEvadNxgLbzzXX5dFvV4FOKneMQlbdTsAf4nmhU3CarIm8d6rJ3e0QihjneQZh7R3yrQ2tT3809FmS8I/PP/2bQ+21xISu5bzRmllfFFJjMQvULqsRpXCbgeZb7bz6V7QllzQ0cD1ds2b3oTV5QL0PtwNBEA++S6oLQqSj3WMED1YqTwtyAm/gfDu7WMGPt72UQ5SeC/co3dS5wcXaf1ksJAzze7ON2tJ+pMpy71Gv2YMDb+sEsfMJ6R6Vdh6TTVcDJKmbNUcXKo1U9OrSeaRM1FL33eaAhpIt1DV3/QLnby39yOQzTIAjd33VsCHqIvBBrPS44j90YQdRxbOpd2P166RUrTCBw49kg3gVCm3yCIZcsE6OeKqoS9SXQUWb0yr8bb/EEm39RlSJaGvhR04Eg982qEcJjzxWKouYcgPJ+ENQU3nuw1vYU7qU2wWOYXwmjTN2QAWsDocw+JYuD3qDFVeQQ7N6hblEVsRnLB1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

With memory_spread_page set, cpuset_mem_spread_node() rotates the
preferred node for page cache over the task's mems_allowed.

mems_allowed can include private nodes. A private preferred node will
fall back to the nearest common node, which takes an extra share.

Rotate only over the allowed nodes outside N_MEMORY_PRIVATE. A task's
mems_allowed always holds common memory, so the loop always terminates.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6802ca13c46b..8401b69ee3da 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4600,7 +4600,14 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
  */
 static int cpuset_spread_node(int *rotor)
 {
-	return *rotor = next_node_in(*rotor, current->mems_allowed);
+	int nid = *rotor;
+
+	/* Spread page cache only over memory that ordinary allocations use. */
+	do {
+		nid = next_node_in(nid, current->mems_allowed);
+	} while (nid < MAX_NUMNODES && node_state(nid, N_MEMORY_PRIVATE));
+
+	return *rotor = nid;
 }
 
 /**

-- 
2.56.1



