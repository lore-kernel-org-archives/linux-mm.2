Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB70606B9B9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mpS7uuVn
Received: by kanga.kvack.org (Postfix)
	id F07B46B05EA; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41A96B05EC; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09546B05ED; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91DDF6B05EA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A884C012F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:03 +0000 (UTC)
X-FDA: 85456288806.12.F474408
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id ED2828000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mpS7uuVn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198261;
	b=WN9EtZCwpdkvmiHkaNjHkQYV/+/lxWMQBTls0Mgo9jn58bxSRBkJ5l9hmEJyAXIFe7rWkX
	oX4AFNDyT2gn4lSPhUv/p/UqGPrmcKOe2Sn8Cdb6D2ix3E6NnpWbDSny1khifnWjzS6+ZK
	yqC8NUBG9iJPoLmes1MCIPoNMa0hhBU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198261;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ah7hRwVf6ds4TiFuASfnE4NQuTk/w//pBxssLX2GVTI=;
	b=GhCz3XWGZlOvMpqSYwzax0ODtGUVfPTkzK8IVezofPaRXeGXJ3kvL3JHdlWA6U/JEj4T8P
	0CpzINg9+BPtaAhuKPW1YtV5TLPi29f3dnRRkD7LEUnFmgtEMsURO5IuG5A9zkb22d+P2k
	1vLDOM7Ya6ytXu3HnwhZJfS9G7qLQfc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mpS7uuVn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 894A263440;
	Fri, 20 Nov 2026 18:11:00 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198260;
	b=B5gQAfZQer7tgsEX5OPVM26QV41HZqMfe8R2TLU5X/bw0lFcBIoFFjKKSFw/fo7MP7ZP
	 LHRoaqG7JNW7LxIml8g4zBi/PiXFVFkCAee66gSsAkjF8Ecb1ov21jJCSRKfneToW167F
	 0tj0Jrpejf+M4AOGB60jYbMvydMpFnzPEmYHDrbW5jtDCErJHpol7wM/6I6zeRAwT2d2y
	 VucmkqgmW3B1w9MSwWoOvbCsEvTfXI9MJUqfXoH6SM61csM+ekP2a8LyjyUsr/hpGcFNT
	 OSRwyUbsyYxGK4smLdddLsXOF8M6wxixdcBiHGsoKLNmwZgIMd4ggglZGMAwRCHGxsQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198260;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ah7hRwVf6ds4TiFuASfnE4NQuTk/w//pBxssLX2GVTI=;
	b=CbeItn3dwOphfS2bmOyB/d+0rd23sSqjFqYN6IWj1ix2XnNPZJvCOm+WENDAHNtq0WWc
	 UdPMBqYjoIjYtITNK5iB7iODzdUidtjplAHUDPWIkxrv06OmTqQOweu6c9G9voKGVMfbG
	 iCPJSS1GxNInR8R/DMoup/b7AwW799hBzkwEVDTiTY9tH1RAKjFjfgYRLhSr0BPZqpcvx
	 URKixGzQyKgpftTYvVt3PCQxky8/kHzQUEth8A4FFX0CboOQv090Ul143WVWiSJtKuKXc
	 muzQQwAB/LmsC/WCd0OpR7pVdQqfvleYshb20Y6Ik3AspJBCmPYV3F1jIeA/l3oTCPg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 23A4D1F0156A;
	Fri, 20 Nov 2026 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198260;
	bh=ah7hRwVf6ds4TiFuASfnE4NQuTk/w//pBxssLX2GVTI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=mpS7uuVnQU/jQIheyMg5B1AUq5TdN4WDQMD9X17a3mOf9y8g2lIqTsO35YbmAn8Zg
	 Bt0SyEIWysED36TK9QhH9W0/H6xnOARXdiZe+OrlkndYyhWLm7k4QJcFhLzQnH6xOK
	 RmD0TjTAENbOq/td5TxkobpHEmdc7nUy7ZLFF2Q6RuozSz5yFp3oa8kp1XDUQV22lk
	 DTzih+HBC/j9vPXsCBbfmQML1QN7xEB4H1etnV7WKD/pxskeOCVQog5Bp2OZhaquyg
	 gEBiRD63+mbTTJLMezJsBR8W40j50hmyjO+qv0K/9ONeofrwLg77+KCidWOm7piKWl
	 1G8uCCeTeM8eQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3D19F4B94D;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:26 -0500
Subject: [PATCH 35/60] mm/mempolicy: keep private nodes out of
 migrate_pages() destinations
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-35-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1114;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=H9nkzUJ+W/B+CQbALDD5SyhxQlr5AVXp1jZnonCs+2k=;
 b=qYt4WGgIFvq2RJT+D/LbNX9eFwn5eLa1APiNG0q/gFK7SazhE8Ij9A//vMkPQj7FL/v1ICdhS
 jrfi9jSAKC+C0aiThj8fYRh2F/Gs/FtXJaqopNXu15BKaJfgfgG0QYs
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ED2828000B
X-Rspam-User:
X-Stat-Signature: 397getw9unj5hw9b3ruhjxi67i5ezeha
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795198260-402967
X-HE-Meta: U2FsdGVkX1/t38gUbW3bjBgVw9s1O7Fg93M8vjn2SwAe+D+CxKoHVIf85UBQUBWqMnUvuIoYaWEvIK1URhAWpFkQ9BiumLi3wZYJ9E7KnCnIGn1ckzCDIcwYvGuvfN9IjGVBvoYvKZcBEdG+I+ZoDam85/SqFFlu8KJjvV0qfOHBPtmgB7SvVz8FG4OHMWwVV+wyTLhPxlBGBjQbY9vFN11yHU5lcYxPYuXqNs4ZHfh4WAKZAIppUr3aXN+5NQ566rsOsktHorM3unuKmKftAGAeB9J2EvfntUxSjit8vBeH6hJpPqnq770qPMeD1QVYE90OfZNy5MlzNkIcrDRDOhM2N7KvTkpL8rjlkU+dzetrLq++h2lD8jd/qcsuot4ZnfeaRm4ClXyl/JJP7wL2R2Bb1MwQdNUe9tFCCWaAB4zA8TDKfshx/hbAAWjpYGjPTwWXD5ROx37tBzvQ0FxHzMrOwSjf35AvwZmoHP1U/wx0NfVl2YQK5nDnEHbEW5Ay53mhmFHdbSYvfAp0M5pTIiVv8zyRdc8VIqSTc0E2Ygzxmf+lB5m4v55D3klaT9GPyaMdjrhS6dOMewMiGIL5pYP18nfYkUKNWgnTIo7Cl4kVFEiESpOcDoczWKL/36XTt9ahlPM3vFkEWxNEhcixHhBdigz3J71Y0V94Yjg7OsFtEKgKhYRXNoCMYJlmUg1QA1WjMaXiGoS8spuMzlL59voAPV2X2tgtmy1rseJ7lPiuPEwGp1+qhie5eumnQ2SP1z2rm2EJ6BMzB3g813YX3cBoa9tQWK4Us7TRTWywuZqnQ1fqK/RFuSa1Kf+c3JSOIUx9uWjm6Wdfxy1CTOBGUQp19fNWywXstHXzI3u0Lh3KSlG1q9Ajoh36w9tEVl8jYRQseVTSTl6/jm7nTharljfzOPsZCnioc9x1W5c3VVXsmat+yzXXSoDedGrjdk8QlfmvRYUJTiDTsEfwFvS
 kpPABrah
 GYXrvl9GogP/8peI0Uv4ApSo9HsSVgjUJfNti5ij4wVbkmYf7QT1GltPIA76rg/3nSb6vrniKHwTreksBc9s539J+ygAIn1KiG/0B2xVzmownJfGrnT6IQx/erqAw66J6nMB7VTOFXT5QL3I2qYFM83eq5nEaoPNPUaVj9AGwpfZBSelmn3WZ8QjZAlRCsGwFPegZ3RdFVtKwnzWcw2xRUBbA4+kK2QslCDEO/MoQ8xbRPjGuJCnqoPEd3zttkAlSipm84EJLIuJfcYMrEG1rUR/ELAiDncojEnl8k812zqOWJ87Lqi1WDZ97sqq2/QTx4Y6SogiWEYh4wg3I2Iu0Bf+yq5pJ5HN9Wy+sTHcffhQaKw8tzchrxaZKVf9Eg3eQWHa0M4LkTXN80voyTfeobPq1gdZAQw/A2aTn2HgT6Ze7QkaRw+R+PVe27lVwXKSdkqXlz0Me/21sdGrLda8x9O3oqkyCZUmX2Mp0ZeHAE4vv2sRQm8YD4uF26qLd/kHpZ2Nw4ZKkY+GKZL/tzpSzHG//j/ElNTEdkPoOCQRbLWZJScHywiDPFGs17AVq3Ldkg33CGEMnml/vTrbntX25EdFZlTPrCOibItpsvZz6AacDC1iYwLNKCuiIhT8Z11igyJBkHkK3DjDVvmr8uM1CPjZzfBMgq79T9g85fNelnXLnz2WEsoicx0EaoKrk0SCTpUUz/jFIDSO51MdiOeGHR+11e0izEexNzzvQIhi1pERQFiSKcq35YRPUC0ZYfcBxelq1S2qTzd2gRzB+DFDTV3PyMKdD7eUpcT0AmRJzima2aRlkOn/jZ0MaYT4OApkr5NmQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

migrate_pages(2) intersects its destination nodes with the caller's
cpuset, which can include private nodes.

A private destination gets mapped to some source node, and every page
bound for it attempts a __GFP_THISNODE allocation. A private node is not
on its own __GFP_THISNODE zonelist, so the call fails with -ENOMEM and
logs an allocation failure.

Leave private nodes out of the destination mask, as move_pages(2)
already rejects them. A mask that names only private nodes fails with
-EINVAL.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 81ccc481cea1..2bfe8b2b6287 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1958,6 +1958,8 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	}
 
 	task_nodes = cpuset_mems_allowed(current);
+	/* Private memory is not a migration destination. */
+	nodes_andnot(task_nodes, task_nodes, node_states[N_MEMORY_PRIVATE]);
 	if (!nodes_and(*new, *new, task_nodes))
 		goto out_put;
 

-- 
2.56.1



