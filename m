Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145C9606BDEF
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bUuhlsV8
Received: by kanga.kvack.org (Postfix)
	id 4091C6B05D7; Fri, 20 Nov 2026 13:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393F16B05D8; Fri, 20 Nov 2026 13:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A356B05D9; Fri, 20 Nov 2026 13:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6D1F6B05D7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80FB540169
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:33 +0000 (UTC)
X-FDA: 85456287546.07.8029154
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 668A81C000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUuhlsV8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198231;
	b=I2JrrXdctHAfqJegXEafan/PUS8ckagKZ+sjnT5b4jjtse5YoUc1ZITEDIFR0Hj/5h3b3z
	ZOLI40Dp4XFm9hHB53qvT8JyE7Iv6e7k0FFvSFOJadZk0mOKI4wgqezaNRX7JT9ya3LY1e
	/gu+m6hLwi+XEkibYN7+kzDnOD9RscI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198231;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdtYjjt4icTMCNkBVK8ZqJ6Cita/durqIaktzLd3ASQ=;
	b=ZQ1kYbPa/3KZLO6CTuBEPmbU9RxDW7GbLg5AxkZd8O4H+XLe4fEZT0SXMkcWtcJVQWJ7VQ
	oNz1alCdEo/Z8fs6Ew/u/PjRa7JS1ata4+qNJfP4gBhQpCMRkhoBK03rOzd5DfnfWsP4Br
	Xa0ydB92p04Z1SuHbi0I5F28bpMsqy4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUuhlsV8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32CEB45DAC;
	Fri, 20 Nov 2026 18:10:31 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198230;
	b=vsh74B9CYtl1lfxC5lWL19FG7KQOT18H53MAQ0rhDpZynfUgpjRZiFwZdt8zDm9BbMlD
	 5GparFwhDTIYdeQ0cLO20qlP3FNaUBYtSQN2c+E/EISxCaZG4zCWqPWmG9mRkdVPz9A5b
	 DLGxdPztg+rzzSJ5Tc/8QcLR8NlLxq5DmlNflgLjUq2uZ7sgle7E8c76WEHpwwuTL4GBw
	 xrANdE5Y+sAASUf33X8LYXttbVVmO6Qfirx1vnpCQo4I+5Kp9lImoEBrKORHslQPSrEdY
	 8uyzmNNo/ITw4MGIC8aEqZGbKsxzvUI+7G5m74tthlcjuAnhjTIEit9+kjM4tZMSW2A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198230;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DdtYjjt4icTMCNkBVK8ZqJ6Cita/durqIaktzLd3ASQ=;
	b=jVR4CmColImiRvrQV5L/m3Y6L47QUULT9DFUzTjytpJNVTrYlvpfqV5ZXVyoh1LfW63e
	 PHhxC5yc/12/DZWkECxgu5OaNdKpkz4JMMKMTwpxuSNU6S2i6HzIV67nqtE3Yl0v98MPZ
	 nAbMFPLwZxiCrfsqZFw7HNt2G7CiJVwHCtNR0jv4vcnYlU1nonXwnaxlBpzwRpBInSn+4
	 BcGOml5qgVkODJwOOHGutYWGJSXoerl3Z97Xywqd0qKRHVoNfuLp1bbVQD1s9HB0QQJxN
	 j0Ghp4dcS11+1uO4OEyuekkJQJBv8qxPtAseiLIyL6lQBtJcSFIxkdUvgYNHGSILo2g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 85D971F000F0;
	Fri, 20 Nov 2026 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198230;
	bh=DdtYjjt4icTMCNkBVK8ZqJ6Cita/durqIaktzLd3ASQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bUuhlsV8PTfX/PnRHaRgakk5uth+Fi6G5SKUVpd6h/FAc45oS3vC1ByuTd+bWU/eb
	 Dpr2pBcrvnMkmdGqnvleYzcCdZXyMJbTKchKw25p4MA2WZlM251X1FncEO1ya4ssqo
	 l/f7LfJqzojRCvw2Vi0+bVXba3ytji3Oym4JeT6N6X0wZC2rZaz4PAd9fbrZDfdfbN
	 ySWBzRBwR79snU7OhUz23Bu3/HTmOCPzOHDL/var0uGvQpK/DxUzkGP68xahsh9IJr
	 brX57kvd2u5JzOdxADgOGaYOLjjjw26PCHSMIJBiyYll1X2sILw2TWP/Ean05AZY/6
	 +SJWttkYwUeqA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9B3534B939;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:21 -0500
Subject: [PATCH 30/60] mm/memory_hotplug: keep private memory out of the
 auto-movable ratio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-30-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1663;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=HgTV8d94LjdwsJMGwb3+Vry/TTvf1tnHS+uF7N7JLj4=;
 b=1P55MY17I+a8cu0KecQdsP4lOTbFUbQWC6JVR7uUJH6xpwOzawPJ9vMaF4+CKy+NuwVaaINT8
 wCDorNsASZVCR3jg5Bhndx5xpS/opyzqs664oVh52KWLV73mn24pwg2
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 668A81C000C
X-Stat-Signature: pz9pa64jhrhoq9zzhgcctio6ar66kqsd
X-HE-Tag: 1795198231-721856
X-HE-Meta: U2FsdGVkX18LTJebPUFNGWshKxQY7EE4qS0Ym1KYO5EWWwvYogeh33dcPDb8z8z39rTUiVPjRipvPy/PQFLduwtd0EPR2xQb5IdVScJ+53ta0fK9FyZ03UKHj+W+9ct+s+LL+3pSLpOlXQaoaF9h/LDzk+LyhW/M5tMVdZfHHMThgVTA9ltxuhr1pfk3dxyInOxhHAzw7+gKyUeG1rnvUGKZqaymMJnDIofsDRTXvFhVVtqlfSrgPg8dujDLGiFBSTMDHCvDbKusRDYzGkA/hiNEROIRIRcPNqquop972HnMb1kL9nSBH5X4E14MbED5YymhrY4zYuZLKbD/P018qZPSW8G12r7Y9HbjpNIQLzF/sj61oUAtSMiLTZ7r4kxvasa3SftiPdlw51UuZ295lkuGW5pnWRyDSpc9a1uM//baAvlb81pb5Mo8T8gO6prY3NxqrgCUhkLza2lKZXjGXdOfPIupvKAP5NG2dJ3sj94S8E0hLDt6/gtgD+yXj4bERDpIHICHNYt0LMMnOlhopJCsuGNLWQjoj88HGlD6y5gGfvuPJ/n4Vwq7yOMHfYtKug8bawqqmXK1XX+KlV0fGtIqQBCnCUy3ZDVgUlEoMUNXTwd7+N0kiYjIGk/i1/5Cn4kOJCOVs0y81LhJAJK0yIsoYCiu4hZ8p8DxSga2v2BuhnxsBv9OwmQ9+7zRSLAP/ugjCRnbw4uQBJUTQnbNxiZB+WjeaDSSU4dXTHIs0FFKNqkHi08j0ov/QKCJe05NgfwDCKyhAjIJpsBfxZ78W13z21LJMrUM/4Za7ki9tW/ycv/ZyrPMGPoBIHZ2ip+pw3CQfSeUzG/XY+zJoHxLftDfSOYrRcY7YYFb4n5kfWb5+ThlRkPI1pN1RUt5bLAscoY2NqFN4Bxx+xh/cmPKQPKvv4jQChfoa8ovMY9Vh9i7h7AOdVUIK64IjH7nxH9U3j5ofI2jKS2d5lP6/wT
 meCRfigX
 nmavjUnpccACW6vabmZe87nT6BPY/vRyYNmRaT6yVjzYmG03u4vM0SUbtd7R33MuyUDq/t1vf1gmGA1YBb3FKGN/jcR3E1qs59WJ85qJQm41P59ZmJqkmiq9kqMvuFrOms52ZE7hNJWnIullAEmHg7i1Iq/UqnZozfBBvUwhcIBvvM027Zo2pYPcS9whSixmxAqa33IItneV7Lg64sbh0R4/6WSsw6yw5FSEMxeNHXWdnndXgS+z5GgowJxFT2U1u+1qiIwQsLCmjO8VxNCJ5+DqEyNU+ww6e5PoayTnKI7AEWxX5F8mTCPHGK6LClfPYvW5lN1wnnu6eiVDb6MYeqX7qhWNp4XzgllwSbChim81ulVE/M7ROkcE2rEB1Q2gFu/aepTo+81UpWOI/rLgLEZBEfFwFwnahx86rwQzKQ4hWJn4KhCLoFiIR5/jdwH58Z2QcKbUBkg0Q7otjOVA/HVaWrV2rgwxFdEZ2wju2TZdRmRrj+F09cZW55w2+PaXniWu4G+48gdhVP33FZyliKw6cfjzizNLkYC/F2vCZ0GQcIl3tw1LkJrvDmhUaOcYAir/T+Yyw6cv3tjumkSumMQ1yP4Zem1308ti5QmgkpvL8pQluQ/hLjmIYfLxWBDeA/zQZ/Zkic6sVS3YbVugMIklmwvlC44EurwtQJLzxjz/I1fobaqFxrKwkkIomtHW0grAubCchRD10sCUNTRXN14Ozl6Fc7UMR114JJo+ZCr/dh9XvPqU4/GADKhw10WDiLD5tf43SMKjN9gKgVyHhkAIuJao3AlLRMfjxPffhI348DltQcv8PZ/9rvxlT5xl55kzK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

The auto-movable online policy keeps ZONE_MOVABLE within
auto_movable_ratio of the early kernel memory, since kernel memory
holds the metadata movable memory needs. It counts all populated zones.

Private memory in ZONE_NORMAL is counted as kernel memory, but no
kernel allocation can use it. The policy can then online more
ZONE_MOVABLE than kernel memory can support.

Leave zones and dynamic memory groups on private nodes out of the
statistics the ratio is computed from, as ZONE_DEVICE memory already is.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b4d94021d46e..d7ce60c6815f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -782,6 +782,10 @@ struct auto_movable_stats {
 static void auto_movable_stats_account_zone(struct auto_movable_stats *stats,
 					    struct zone *zone)
 {
+	/* Private memory is outside the movable:kernel balance. */
+	if (node_state(zone_to_nid(zone), N_MEMORY_PRIVATE))
+		return;
+
 	if (zone_idx(zone) == ZONE_MOVABLE) {
 		stats->movable_pages += zone->present_pages;
 	} else {
@@ -808,6 +812,10 @@ static int auto_movable_stats_account_group(struct memory_group *group,
 	struct auto_movable_group_stats *stats = arg;
 	long pages;
 
+	/* private memory is outside the movable:kernel balance. */
+	if (node_state(group->nid, N_MEMORY_PRIVATE))
+		return 0;
+
 	/*
 	 * We don't support modifying the config while the auto-movable online
 	 * policy is already enabled. Just avoid the division by zero below.

-- 
2.56.1



