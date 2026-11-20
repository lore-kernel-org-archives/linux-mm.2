Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700DF606A892
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ebv9L9Vx
Received: by kanga.kvack.org (Postfix)
	id 7D7386B05B0; Fri, 20 Nov 2026 13:09:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7882A6B05B1; Fri, 20 Nov 2026 13:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601BC6B05B2; Fri, 20 Nov 2026 13:09:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28CB76B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:09:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9644A80139
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:31 +0000 (UTC)
X-FDA: 85456284942.05.7996F44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 94E6140007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ebv9L9Vx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198169;
	b=wA9R9eQWSokJuu6JVH6X8KCqebUjyUNBLaPjipFrVcJA4FIdCZUW2mlmmgzBIzM4svS10P
	+d1kRg6YEp4uxIg0+ZoEI+m8gl1sTp+NlysGiBhklkgCBf/PseSU3Jy2kkPyQVxZtK1/is
	Fpxzy7XcaH1BlLTE+IQmf7MDyDmNUUo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198169;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDhBzinWWamnegvT9ExdyfioDJiSgPrUC+Mo3CWLBjU=;
	b=b3iGDv79T7VJ8QszxL5P8k/jwSLRXSdGpJlTQKN72D+VC3XOz0PrySDDoHNlihHTaFzjNJ
	Cjf/tRdkQY50CD2rHZTj8LiOhBU5Z2qQQiP4DhffoLaJ6hHptuyvZJ8miZnInzM+Z/eceK
	H38t76GxWs6fSSaIVoBZLdbcY+P6Qns=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ebv9L9Vx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3999562CB1;
	Fri, 20 Nov 2026 18:09:29 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198168;
	b=qYw9+d+WP4pB882BzhzhH7tkSHrxE/g/FYKnRL0KRxdfeJ7n1s963ZEDupIIbB/ZighB
	 G1bKEifDhJw4QStOOZeCbWvenh3UhRUeBh/6yRwEKQtgAJqHmL7X4LrVQPrOp/wI+3Y1k
	 rM+lQPFYm2QTQl4XnKJZamVaMydKTDtWzjM4x1aq2KGyum6Pf8ne660MNUnpeVCiM8UJf
	 x0bi0UQteVcpESaRnnB2oVT32JTyZSum6jbQk1EoOrCP/KvJtb73NfWcC49tdzR4MdE55
	 03Mhx55IKhveeJasR0s5puUX6NdGiEJFgkR5tUueIBN5B7RKbnYCx/EQUMfVVQuP5Hw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198168;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=HDhBzinWWamnegvT9ExdyfioDJiSgPrUC+Mo3CWLBjU=;
	b=TbEc5HGDtn9aQNXGdV15u3fW8rIN4FP7vCliG1eEYj0vj8via6d1OsJA0aLVzPq/g9iv
	 3xf3Hqy/Dn6wM9HcIIFH0F4I2TDKhfEJXpiFt5fAN8h7bBgbj1eTNZXXowYdqwmmnpsYn
	 gwgfE2tZ1LSYnS/csv2dlQn4CS2stWVWBsoTsV1Ze+jWn2fkSdnNvH0OqLksxFczEMNBE
	 U/D1/S5k29JGYe5LcU1oetzYgwfL/MB2HzeIKk/e+HWICm02VVsuf5K5aikYwfx3yP/xj
	 KyCOlKbii6M5JQFu3fgekCkVWA+qQB/HC04HWiRY87r5+413BcD3sYPYD4J1CkHSRgg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BA95C1F000D2;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198168;
	bh=HDhBzinWWamnegvT9ExdyfioDJiSgPrUC+Mo3CWLBjU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Ebv9L9VxIv84bkKLPkM1JLcxHOGx6l0OyAwYSUASk5DCda74oqnu9jS9Bf3bW1CZZ
	 nAaiTAiMshCsNCueW/p/sV6MdWp27bgkaUb7NUirrtD4S1Y/XHAjJ2GjoJ2NK4FVz9
	 gIn4cw/roDMkYeq1JdIZjf5tRlswclzK1iFNBHzA6DkD14uqLlJ4G3biBKQMhRe2ct
	 pNI9FZeW0r01Qcu4GDnQBRtrD1ognX36uHsKffiP11qot6Gst3sVEQjjQniROnm+7B
	 eDjI+5CXdIU2c+uA0wzz8ZfOmwz1nqcudIefIfAPcd+ng516AE1h9lZLMNkDYIw0ay
	 MXiJSAo6LIGhA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 433624B8C5;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:53 -0500
Subject: [PATCH 02/60] mm: publish and clear node memory states via helpers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-2-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=3460;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=bHuUN4m1rYdeHd2n9uTV5bvIEOwz0W65sMVI4gQRCFE=;
 b=5PaC3uuW3KE0lNJmW+SARs1O0zlNg2YD6FwQIBFs9Daq6H1QsV7mc6KO2+wYEThTdvpSt7rTR
 V6KaOerJChvCGaLx48xIa9FWmn4rD0/KaqOmHyfps7bojLi6JOB8mrX
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 94E6140007
X-Stat-Signature: gjim176fxs9495xjpq7jrkkheq3mzu7o
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795198169-511808
X-HE-Meta: U2FsdGVkX1/UnxUyD4QgbbTky9bOAXPZujcpC4HNbpDCMVX4RgTnO30EUhdiGsOiAi3btpPlseaMHDcB0XEVPo8tKn//Fkin9Zkv4e1cJ1KHkOJ+S3m4N8Qtd0u3WtPVNSVp1NevkqxMT68zuK53mU3Pl5YPL3F94CB0N1XJIGisXtZMwect3PSdNO1HjSINtmMPWtgISIDjuPvx1/n9EEKhO2xft6USEjjIWeaATOL95D1mUe6VrMcWHLjVURoKOjv83yZI6VF/YaRbqFpfEnZPAKTvYBZXpQqw7sqmBUXGG7VICQGVB8SrdT+oiuL/Jys5fIHkckzx0cUiymYUmbVuV+yC78H9EE0i8vg8Kzt924/TV9USBjf7QzS9kRCvdetPEhRAKgLp1pUPLusmz07GNemA5x82yxgWq18z266nsRmJ59PCl2FEpl5ZOhPy3e5g/Ma6jDtq4cgkiqAO0DzJSo6a1xTorFiWCLGo79/2cpLhwgxdppvJegD6BsIh3Y/zXqBKRIEUWH/Ndn1fGGb9qTrfZSsWC7Y++GcPOkny7Rwt9uCC/B0GHu+vArn2xPj2Aep+5B3CtXxVb68L0Nl7dGhii1+bHxtXnNrh5csVkPaz78RJLAsvizPpmghuwqNebgEnzDReDYka3+YFEARj0E667c+ZFwznVmAqchk2UFkkbm/0ihcuY4o0AwKI4zHfJH0ppPRlC/nI8QXRBU/OJkmKQIF+xhEmMyjzqethGnuqJftzj1qCGON5gACtJqE8neu3Qh4EeVe7CaVTetcOP58TiR84kZ/tM7FNl5X2pqNJePzkYa3WsT644xwTmybR+7vocqjmbQA7vCG3DUCWAX1KJ6wllMO2xKsQ3jRTp+MN9kLuIigfxU9XOjFjEtvwKIVy1H+sL9jxPR4MXN9hEkbiEde11bygqo0V3OPXb7GDJKQuS81NqgMoyXTZtSCvSqDaLX2YvqwlNz/
 UVnvz+Or
 0Emjh7yLw5pOUbrPlHKl1F/KLPavWsb19DuEJ+vaXJlyPv3y6Beq+ixKeQmMNoti91z/1DfMJmUKP4I6aaSf0vdTDFvJuirfCKcHSPi5xY2WyW248uMJaRjSoOuz79HqPg9zOsZV2Srsh7XruZ26CBjfbY9x2iUYFk/nWZ5294bq4SdnqZ9Vr5rJC6jUGT2VT00kTsZL/Tw/an+V+K812fU+cmsyj/cvEqDfmf5dTcpQ2YP2olp/y6oQQXjgqe+kP4+dOm63YBIWLXz2Da1lOlC/UzkW0hiZ2yVHRSOxwLAm/wCM82duq9cjnQpJqbQ8/VyMHnsRq461iDnzpesTTU1OeKyCYZdoew9H8iQ2AtWO2aFnvlFUsE+GP/3OVn9fBzJxWPQgB0dLEBdW0p5ogqE25ItlrzOAE0nIiWduhAhYwDZcWOL8V4jY0lXAVtalBXum//9u1avGJhGpqBdhJ9w8mnMsRMVedGEF/RXaowU7Tag/Q3anMnDHG0INz7ZGzmOq/WsZ5dTTA9PtoG74ctYPAr0YDe3ZiNfG7eh4NurQeRSXkFhhr4sndxlrHlefoDCUa4u2Jy2agOlDRKyf5VAFH6jztDs37YaVBTg0nWsXgpn+PL59CXBwEJuUSZ2ApMij5EZJ3+SrMqlWZWQU/CoIvP22q5sTUNunxkqKhcHXglMFceCkp/w5oXGkrPLPlG91zUP0Sd52zDPjoDGuGgAXomEGVaY9+GXvjmj23a1LaQE/ZB+HLyqkYyivCsxKuUmt5/r3+xgpsCNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

N_MEMORY is set in free_area_init() and online_pages(), and cleared in
offline_pages().

Centralize those updates in node_set/clear_memory_state(), so states
that subdivide N_MEMORY can be published together with it.

Behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/internal.h       |  3 +++
 mm/memory_hotplug.c |  4 ++--
 mm/mm_init.c        |  8 ++++----
 mm/page_alloc.c     | 10 ++++++++++
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index de4593b3e3b6..c102e0f498bf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -62,6 +62,9 @@ void lru_add_drain_cpu_zone(struct zone *zone);
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 
+void node_set_memory_state(int nid);
+void node_clear_memory_state(int nid);
+
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e5024f934932..e5cb770e4b09 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1197,7 +1197,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
-		node_set_state(nid, N_MEMORY);
+		node_set_memory_state(nid);
 	/*
 	 * Check whether we are adding normal memory to the node for the first
 	 * time.
@@ -2165,7 +2165,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	 * list. Otherwise this node would still appear in the fallback lists.
 	 */
 	if (node_arg.nid >= 0)
-		node_clear_state(node, N_MEMORY);
+		node_clear_memory_state(node);
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index a9d848c92678..46fe9a274a7a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1763,11 +1763,13 @@ static void __init free_area_init_node(int nid)
 	lru_gen_init_pgdat(pgdat);
 }
 
-/* Any regular or high memory on that node? */
+/* Publish the memory states of a node that has present pages. */
 static void __init check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
 
+	node_set_memory_state(pgdat->node_id);
+
 	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
 		if (populated_zone(zone)) {
@@ -1924,10 +1926,8 @@ static void __init free_area_init(void)
 		 *memory-less node. The pgdat will get fully initialized by
 		 *hotadd_init_pgdat() when memory is hotplugged into this node.
 		 */
-		if (pgdat->node_present_pages) {
-			node_set_state(nid, N_MEMORY);
+		if (pgdat->node_present_pages)
 			check_for_memory(pgdat);
-		}
 	}
 
 	calc_nr_kernel_pages();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aa1ed599c7c6..88d507f93b1a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -208,6 +208,16 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 };
 EXPORT_SYMBOL(node_states);
 
+void __meminit node_set_memory_state(int nid)
+{
+	node_set_state(nid, N_MEMORY);
+}
+
+void __meminit node_clear_memory_state(int nid)
+{
+	node_clear_state(nid, N_MEMORY);
+}
+
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE

-- 
2.56.1



