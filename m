Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6831F606C950
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R1FgcyVc
Received: by kanga.kvack.org (Postfix)
	id 7B4D06B05E9; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763BC6B05EA; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542696B05EC; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C09F6B05E9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EAA940160
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:02 +0000 (UTC)
X-FDA: 85456288764.24.059FC02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4751412000E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R1FgcyVc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198260;
	b=yiChqdZCxOx7E6swexu4IwfrHYNYyKWUdB4OilGdrCWaciqvXkeWWWY6UXRhHL58NiSyQt
	eohrSHac9KuzFk5+fKJt0TV0pzbtDnqqkAEG4efZBxWpCga/ahp7GYBTVzqeXRauNfH6Al
	RgHa5TLIeyo/ojXChejiCqPElDeqz3I=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198260;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4LUHMZ9Zq2StHJtUd5qOtvoSX+upmsion4LtPce8LQ=;
	b=IBwqy1ICv8AsBr4VoZqzCuyngeWhEgOlEtir7EpKf3SVDMvym1trwa6GFvTMa7LMzAjQ7d
	tl28mdTNo1ms7XdS2KyLDIn70k3cnYWV+l/L3r8EMwEtWipcG4Kj/8Ki5yWgPSF4AJLX3H
	QFqPL08zOn+rEAX1uwNdXEv9cgsXfaA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R1FgcyVc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94F4E46CAB;
	Fri, 20 Nov 2026 18:10:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198259;
	b=SylDWnHYbuOBKEWgvMbd/b/yJaFjKsSP3CqANHFQPc3vNm0295F5gpVtAmTl3Hv1qhQC
	 f3VxnXJBkdmXwX8L2tf8jB1MH+YI5dnjC80SH8iTgL/3HTV1ODCWNi2m4qwzOr6GwD4o2
	 uzOyn9/7+1zyxSOe3kB8sMt4EE8yGNeav6plDMaHR1JB/+VElJAC5SuKMJ00NJ3/SasEW
	 fDyjCvy5RJZnfxoaQJy/EVU7aDn3SfJhG7TWHpjjYvFDQyrDE+jIqQLrIfIMjM04dcM6p
	 qT2CET7+q/9OdZcvy4KnbJzF2+3ECaW8hSHNJJvcODvgyzf8XIR7c1XfRf4edjeyb7A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198259;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=N4LUHMZ9Zq2StHJtUd5qOtvoSX+upmsion4LtPce8LQ=;
	b=zP29Ji3w8gx5Lj2cOC2e4nht6M+/lCLnxKMlsYFuvoFpVhgTVaRv5Wr8mOZS5hTYSeFg
	 igGEop57KoFvYveQgs2PTBE4WMvVoKh7p6OjutyUlaVP7Hvgwdy0r59NMgklIDx+tH6EN
	 MtZ6niuNHJItrAzjERhljnd5iJL9nXq5b/IVfnLEsZIzHYigXx9m3dbRJ8GVJnc8COaYO
	 zQjdpgPRIURj+Si7P0Fz+0JjRb7XEXu2goIopWCDT8TK7grRTvv4w8ZBReGC9M/Ijau9Z
	 w6yMxpuM0ZjttB8ZH/9UpLkSsUflj8D8mmxwEOLbXT5+kuRDJbdUnkRHSPp/nJX/CLQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F0B181F0180F;
	Fri, 20 Nov 2026 18:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198259;
	bh=N4LUHMZ9Zq2StHJtUd5qOtvoSX+upmsion4LtPce8LQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=R1FgcyVc8hSdWc96l1IsODS5eVMMLLfJcfWw5l2lgV9M5mDQxAXuMJOmPr2YbNLUS
	 7R15stV2vyzbWe/nCPnKN/XtZ3yRnxe7ST3V1+ZsWz66j84W4aHqae20m41r7QiGsb
	 mFbbkhIEWqojPEu8mwDKgaJk//+Cyk3ATFgLCVshU/A80Gn1Gafx1WF5RSren/LXVo
	 HmLkP4G9AIoQWyTAU+Vly+aWC6W3VuW9+LAvbDhOktid7sjQcAjzlTvoon2d+gEQt3
	 1HLHoCwyb2qRSeAYvgBqkIG84PjWy/0XBx8+wr3QEnnWTxG+ogHsCdnqbzO/VWXELk
	 HGOv2Z/LUE51A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 00C844B965;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:32 -0500
Subject: [PATCH 41/60] mm/page_alloc: relax a private request whose node
 becomes ineligible
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-41-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=6951;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=C2lGBLJod3NcaBo85CjVEXWAAO0FPHUICJ5RG9BwKOc=;
 b=JDY7uV4eikBnxv6llFVY6VolS/1VlCkSAEYghL17DozTh0aYg9lRJWAk67Fn72xJYpFmyychC
 sazxiFhhQ+HCfqTJqkOEcFduj64EA2V+c1bfaDbrQNVpad7gQAyoF6H
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uaf55ma3coo336wrcjnh6h6ab656gcz5
X-Rspamd-Queue-Id: 4751412000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795198260-523418
X-HE-Meta: U2FsdGVkX1+ox2tY1ltuMaTV+yQwq9oxmHHdItZQjVnMy+Rm/K/SS/kcu5nXesL20URmZqyVcQtFzvA+xJq+xKjYBaOsvDvpJ+49lp2jxi40+L+0C7hONZ98xuAqzTiGWxgie5jnkMHYuc+Py0zAX+05W064nA6MI1CCnMfJEhytKRw43ZvuOrFa25oPCFH3H2INzrJ56S+rmR+UQlcqmepsITndFUKkh5x9aykBKx0wY7Jlsst+LNWrmB2WceUlNsBBg2hbaHt2vrInmwvayXDJp/OtEOPF3jGdSl6KyaA1fRMahTBLL7XWED1sdcqy8rarhbzbUmSejNN9LYBdulCpAf7agi7oNpfx5wPe7pSXJuz4+1dAKEVvR0bAdFqkiBcDknEmVQbaiItAj7rY9lQdB2r4MJ2rhjB0jjJujEbVvgALXnUDM2h6qUwYM4v8b6S3bRAQTab3cZJU7MdH7G4ZAJGts9ToSnVDgeQZ9aqjKqWqFgxv6zDNvgmwSCp+0q7RDBRbM8afSMq25u/MdHMLg/C3AzV5OJ39jb4VnWBSUE3F2aQN2HsNz9QKzNA0o0svTef9YwFm38uratML9kaia+ovFenC/K0MSwD19E/dh3cMbfL+X/z4+8HnXSCb4tbUZiIVt3xA8bIHkUOPXyd9mQxcmAOdEQJxtmG1AwXwufIRkGFm32sDzUtxS5YlhfJ4nlenb1BjvgD9VzGLfdFdvCeNMziD5szMbwC/HPOk+ufmuebh0P6x2xl/af96BF7Xa2ZgB2ib0PwOWapR5xhHkW5c9kCHCrE8HYi5SCHj9VLesgaaby8N9SR+BhCzLoP71eSL9PHvmgpoa6uV6iwvr3B+jr3Pnb8bkggRA7aXOV4W6hWh5HcaNEntuZ+VOUD1lyOgnxL/+IYM/M26rnBBQQfRp8d3dUaVNNQyKwJdzoRGQCWtKsKpMBFIuoTAaw8mz/LpE9cRLUBCK0I
 NMeabOd4
 iKYZtqxkJl5WCPTvRzBUNa3fSJH4TxST93OYqlqOqjKAQJPXaUKsKGdxjvRYosV2RoLiCpKieipeOZFHtavnAGW+5LtWtVfbNrur2kTliGLGP4RG0BJrWgTGqXI3Csb1vLwxsA4olrhfUCtGpktc4oFk8dImgc/ApJuB6+Mo2MFdSxD6megTwS7N2Geus6jWFejRK8hxg+pNHwm8mpdKmwQqp5Pj+bXd5AJdwQkXSJI13JfHOOL8MVT939Om76b/SAyWp+dPzAGxT8VzuwoL8s/IrhX4Arpp7qIfgEjDGYcqXoCl44vDpHI6BKzyRwffBz1rOwLj0acTAGGMFNCYWIvHWgd5zKm9dtxlvZmm2cjThuyniXB/9JlulSwTi/wNaxFZvFOutxeKDl9heniQeUqu+MjY3Iyg4HKA2zRwsVvlw1ShxuQTlezVZDbINRdjpHLjcDu6mw5LGuL8KGtvo2MNofvkOAuZXPCDY4UP7bgcvJHRP7UYOgxlxXweRlAdJvcCAPGdRCF8ArKFJfY9bbIbLZqgSVe/bwctW7KjLZq66cvNnWcrQz3NyrRdTQ2G8upDxDce+6ooNWzdtofHeY6mIBuHTRqkDrabGJxhzlJ6N+MaZFxnftU975rT+ZQ2XScG+7Qr9U+Q4FCFcyo1k3NBAkt1NwVErGXQt+gTQ+0HZytACIEhx9wMSSfFshTOH9EatNNBkjnRVv44R3suZ6WeMalEUyRDAYBBS4vTantVAh1KisOIVdxQSHqDe8dfdBw2Jz8wAwRNxJa0c/DqO+8LTgzm5YzvtO7LglAIb6j7J99U2eBNfp32hOgqg0qGsJ3lh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

A private request allocates only from its node's private zonelist. If
the cpuset revokes the node, or memory hotplug removes it, the request
has nowhere left to allocate, and a faulting task retries forever.

An ordinary bind policy does not hit this. A cpuset change rebinds it,
and check_retry_cpuset() drops a nodemask that no longer intersects the
cpuset. A private binding is never rebound, and dropping its nodemask
does not help, since the private zonelist still holds only its node.

Add relax_private_alloc() as the last of the slowpath retry checks.
When no node in a private request's zonelist is in its nodemask and
allowed by the cpuset, it drops ALLOC_ZONELIST_PRIVATE and the nodemask
and switches to the common zonelist of the preferred node, which
alloc_context now records. It runs after check_retry_cpuset() and
check_retry_zonelist(), so a concurrent update retries with the original
constraints instead.

A node counts in any zone type, so a GFP zone restriction or an
exhausted node never relaxes a request. A __GFP_THISNODE private request
is never relaxed. check_retry_cpuset() leaves a private request's
nodemask alone.

The alloc_context comment now lists nodemask and alloc_flags among the
fields the slowpath may change.

Without private nodes, the slowpath retry checks are unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 mm/page_alloc.h |  7 ++++---
 2 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a219057931c3..63cc8729c41a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4078,6 +4078,35 @@ __alloc_pages_cpuset_fallback(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+/* A request on the private zonelist. */
+static bool alloc_is_private(const struct alloc_context *ac)
+{
+	return ac->alloc_flags & ALLOC_ZONELIST_PRIVATE;
+}
+
+/*
+ * Whether a private request can still allocate: some node in its zonelist is
+ * in its nodemask and allowed by the cpuset. Any zone type counts, so neither a
+ * GFP zone restriction nor an exhausted node makes the request unsatisfiable.
+ */
+static bool alloc_private_reachable(gfp_t gfp, const struct alloc_context *ac)
+{
+	struct zoneref *z;
+	struct zone *zone;
+
+	/* A strict local private request keeps its allocation domain. */
+	if (gfp & __GFP_THISNODE)
+		return true;
+
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, MAX_NR_ZONES - 1,
+					ac->nodemask) {
+		if (!cpusets_enabled() ||
+		    node_isset(zone_to_nid(zone), cpuset_current_mems_allowed))
+			return true;
+	}
+	return false;
+}
+
 static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	const struct alloc_context *ac, unsigned long *did_some_progress)
@@ -4753,8 +4782,10 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	 * from MPOL_BIND mempolicy (whose documented semantics is to be ignored
 	 * when it does not intersect with the cpuset restrictions) or the
 	 * caller can deal with a violated nodemask.
+	 *
+	 * relax_private_alloc() handles a private request instead.
 	 */
-	if (cpusets_enabled() && ac->nodemask &&
+	if (cpusets_enabled() && ac->nodemask && !alloc_is_private(ac) &&
 			!cpuset_nodemask_valid_mems_allowed(ac->nodemask)) {
 		ac->nodemask = NULL;
 		return true;
@@ -4773,6 +4804,23 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	return false;
 }
 
+/*
+ * Relax a private request that can no longer allocate, because the cpuset
+ * revoked its node or memory hotplug removed it. Drop the nodemask and allocate
+ * from the common zonelist of the preferred node. Called after
+ * check_retry_cpuset() and check_retry_zonelist() found no concurrent update.
+ */
+static bool relax_private_alloc(gfp_t gfp, struct alloc_context *ac)
+{
+	if (!alloc_is_private(ac) || alloc_private_reachable(gfp, ac))
+		return false;
+
+	ac->nodemask = NULL;
+	ac->alloc_flags &= ~ALLOC_ZONELIST_PRIVATE;
+	ac->zonelist = node_zonelist(ac->preferred_nid, gfp);
+	return true;
+}
+
 static void check_alloc_stall_warn(gfp_t gfp_mask, const nodemask_t *nodemask,
 				unsigned int order, unsigned long alloc_start_time)
 {
@@ -5060,7 +5108,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * unless it can execute just once.
 	 */
 	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
-	    check_retry_zonelist(zonelist_iter_cookie))
+	    check_retry_zonelist(zonelist_iter_cookie) ||
+	    relax_private_alloc(gfp_mask, ac))
 		goto restart;
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
@@ -5095,7 +5144,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * a unnecessary OOM kill.
 	 */
 	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
-	    check_retry_zonelist(zonelist_iter_cookie))
+	    check_retry_zonelist(zonelist_iter_cookie) ||
+	    relax_private_alloc(gfp_mask, ac))
 		goto restart;
 
 	/* Reclaim has failed us, start killing things */
@@ -5121,7 +5171,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * a unnecessary OOM kill.
 	 */
 	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
-	    check_retry_zonelist(zonelist_iter_cookie))
+	    check_retry_zonelist(zonelist_iter_cookie) ||
+	    relax_private_alloc(gfp_mask, ac))
 		goto restart;
 
 	/*
@@ -5172,6 +5223,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int *alloc_flags)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
+	ac->preferred_nid = preferred_nid;
 	ac->zonelist = select_zonelist(preferred_nid, gfp_mask, *alloc_flags);
 	ac->nodemask = nodemask;
 	ac->migratetype = gfp_migratetype(gfp_mask);
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index c0a0e6abe4cd..3dd73ce641b5 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -73,11 +73,11 @@
  * between functions involved in allocations, including the alloc_pages*
  * family of functions.
  *
- * nodemask, migratetype and highest_zoneidx are initialized only once in
+ * migratetype, preferred_nid and highest_zoneidx are initialized only once in
  * __alloc_pages() and then never change.
  *
- * zonelist, preferred_zone and highest_zoneidx are set first in
- * __alloc_pages() for the fast path, and might be later changed
+ * zonelist, nodemask, preferred_zone, highest_zoneidx and alloc_flags are set
+ * first in __alloc_pages() for the fast path, and might be later changed
  * in __alloc_pages_slowpath(). All other functions pass the whole structure
  * by a const pointer.
  */
@@ -85,6 +85,7 @@ struct alloc_context {
 	struct zonelist *zonelist;
 	const nodemask_t *nodemask;
 	struct zoneref *preferred_zoneref;
+	int preferred_nid;
 	int migratetype;
 
 	/*

-- 
2.56.1



