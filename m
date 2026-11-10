Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4A7606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OaFaFnnG
Received: by kanga.kvack.org (Postfix)
	id B7F886B05B3; Mon,  9 Nov 2026 20:53:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B314F6B05B4; Mon,  9 Nov 2026 20:53:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F96A6B05B5; Mon,  9 Nov 2026 20:53:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69F976B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:53:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6099A8592
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:53:57 +0000 (UTC)
X-FDA: 85417538514.05.BC06612
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0B6081C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:53:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OaFaFnnG;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794275636;
	b=gijhgtALSEV4R7hUWt8macrqclaeTFf/EiCMtHpQZkYq8MKg2tiFcz8tfJk+tY+dnye/Tq
	hCKe8cLaf9jDHOv4JDlFrggDD1vnG+zk7HX/N6uPIs8E39RtLGBYp9de7haG091cSme8TF
	RLGYDC/U0+YThe9b3fhCsiQBvZmTgOI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OaFaFnnG;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794275636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUH2iaJE8DQ9XreGrrxcpLj5+gSWzYR66IHD/grDUA0=;
	b=ZDzBatvgwGaha1M1EUJ63OqskmLbmZNkNHK1VsNJseDLqg7qDZgmwdFTqMyghyuwXLcyQQ
	FxZRBIUjhwHIIhdGIRFa5qspwa/qkq26vAHN7B/5R4QpIJh5Vg1KItTKcl9i6samd51pbX
	KQREnJcOQ6QsBG8c/UGP7j4hS0h/wrw=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so960799a91.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 17:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275635; x=1794880435; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fUH2iaJE8DQ9XreGrrxcpLj5+gSWzYR66IHD/grDUA0=;
        b=OaFaFnnGF/zfBLigdCJ1IqRkay+EGVUSxEmklSotwqzfQjVACbO4PdgrsOvj7K6hJu
         slGIal4TTEPePwA5EmnZixrQgH4byYYxHnriwTwuKnsXRdiiHb0MZ/Wc3YFCrgOyaldx
         /d5efMH8nCwDs7DQQLiR7QJYK5cRyPG3Eey9oIvZbEJ5dRC+Mv9uihdgDJUFAEDHwrdu
         iTai/ZkDYUedc+2TIyuS1mbtETU2Vg3cULflJVmI9HLzTdgFQBmdBUtozgpKE09bSztc
         acxB4o0A2UnrmG/ENo4cfxaD/EGEthyiK3HFLJi28MOWFNZ6lHG0i2zMQbFleDhHJc64
         l4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275635; x=1794880435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fUH2iaJE8DQ9XreGrrxcpLj5+gSWzYR66IHD/grDUA0=;
        b=lWAlfr/KITQUUQKFQqKbqSCZ5Wvk383SCZyp09WVXsOQfZsmq21GyDqYHgbHw1TqH0
         OL+nsCYpV5KiQZ0omjNdkuvD5EKMu8kFUgOhd48Rw4Ao2zhfHpdSsVNqOtpejszBmhQ5
         1rDyqo6XQrqWzlOEDqY+MT5K4vwENFEgnel/8YKsPA/jHtCUbdaWdMXIjxEy9QbavBSf
         MGw20eSFNNU1oOkD/QD1i2HhEOyJC7RdP5SFFfPZXw3w3VoQ7FP97IG3z/oOmIjBtrtq
         rU1/rrub/Cz84J9vq3jjrtE1l1EGR2wzQalTL2lquK8gfE8h4JSWzum5/Qs9agBt4NIq
         fTZw==
X-Forwarded-Encrypted: i=1; AL+hErHGxrxgvCmSUjpZUb6sWB5fmsYxNIlAxiJOZGE0X8whxxOMAcA+GGduCHfK7uDTlPA9+JSQpB/FHQ==@kvack.org
X-Gm-Message-State: APuU4Z9m51TOsTILumTrNbmgE7zbQ28qvWN5ZKkhIjZyhKkU4Ii7koP+
	XDGGvn4Yxeyf9Eku+MsfUl4uZZ1yIdDylCZwT0NhJsWE+Af6ABnesrFu
X-Gm-Gg: AYBFou3gBlVG7hRUq7OL9WkUlhSH0niX6lrJ6z4l2mnUN5FRUwqQ5imZfqyghEtva7G
	DLe+cv+ozKbYzud4Bm7KidkpUO2g7/AxDRKwzcVNzo8YQW2OXUl9E0rC0BDQ2/psN3GLslEDxMy
	luskzESufFvmyTVJZDJ9vxnPcwcqUM/57knivvap+8j+qFtsXhwm7UAqMmhyyH2ZObP9P2UDcn1
	up2avzu7soWSSLBCcjB3bODlcyTItvFSUwjnrq0ls22yj1snkakMNoOY29x+nMzISHJCZIA/tUw
	ZH7vc4iP05vFAvrPi9CzPh7vXtfdCtapmWhrPgkugO8R92RxAxfCgtqjvANrFv10lkfVE1zeLYi
	phW2AcxNYaY3mzPz6vokZ0xEe+mv7T/c64hd8lpH/tCxgXo4CW1UuglK3LXiMZyQ9YtuvbyUgjE
	QEoB5mPX5+DxUZeOQnwXCt8znd2l8mOobaVdpGQvsTnR809w4PqqTjO+/J0ikoUZX2aEx23kYAB
	AKrI42XFgau+H+XemH+uJxWiaSzONIbxOgO2Edva4Q5AN7GoLQxJdMfADptFYvBC9ed64ecrJ1f
	IAnbMpPdGlqQ94enIM+tuRXIjoXp7F/sljFB7bJliT0sDihKgacYPo2IO4XuQZ0+0NrbTE7X/04
	J24GF+g==
X-Received: by 2002:a17:90b:1c09:b0:3b0:9a2e:b491 with SMTP id 98e67ed59e1d1-3b166d31311mr1425834a91.66.1794275634865;
        Mon, 09 Nov 2026 17:53:54 -0800 (PST)
Received: from localhost ([2a03:2880:ff:58::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1678d1c0csm1631708a91.6.2026.11.09.17.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:53 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 2/4] mm: memcg: read root lruvec stats from the node counters
Date: Mon,  9 Nov 2026 17:53:19 -0800
Message-ID: <20261110015321.611093-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261110015321.611093-1-joannelkoong@gmail.com>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B6081C0005
X-Stat-Signature: q5cdtmj1134c6e9xzpim7y87h9iyae77
X-Rspam-User: 
X-HE-Tag: 1794275635-965024
X-HE-Meta: U2FsdGVkX18ahkaqXrYYVd1kUrjHfllZY50pmIQYcZQfq47+HGPN1UQkAc8/cN+n5iwpZoLUWT2TvVb72E0lJmKNdn4aJirhNvbx/C+GYouDucsWhsCTk7/rLGiLWyaTgJV5lC5sXBnckxEWNMiJGsuvCqBZTDNLviMygAgA/r4D5dVSAGk885pQOAeZiB6gyvdpV3EZRGDIaXZ6JjFVYAXndY5oOemF6ceROmWJoUlZ8+w2R2pV9hOXXg04cMdZOvge7D5z1qyKEItS3KMM0mBmnVvnIonwxQ8DmolpcR6EIr40+dv5fH/q6Kl6z5p9h6+13jOgUVnxN9ReJWplZniWJq5h3gRM370cx3YL6N5wWcQn+9IfeQz8HEM89Q3OJs8Hb0aGvUiKYEE+oNwIGq//hUejyas1deeS4MHLXYrfTTkuxDSrEGPJSLj6q5lkx4yDJhe442P96QrUAmcLG57yLMzX0BU0Rc+krpmvxZ8y8qsmIIbinKM2bXK4Zti/K/3fJ5csBkB0UwgJlyCPBEjtFo0UKUahHMEVhfZcH2PHpZfakwD9zl1yktzpx932dgSyhdgDWDoNwZ0iUUSTbe4IUQfx+uUFsHRUofQOWDNjFk6DSth02FxVY49exmMKLDoxQd/hOT0/17OYROrtpIpYMH5ZUgnxVC4WrRrFOvsJosXjE1zxjnNs6KA33MCFtBJnAFA598NI4/rbI1YMP/df9ymwXsJsG5ECAQ142u7KpDkptc6B9lXhVw3vK8BHIiPo9DNObU2Pej+saUbq5y7cqMsV5ok8gY7p4hx46WxP+BsN+4R+0mwBZAYkKAc0/FXuJ0BnzeenTfRYa/hql3ZhSj55qkm26Szp5fH9OsgbwjCmlivWX/3aOL/gGP7yMQ1zmiK6Lp6ew2GSa3G4X6r+qTJElh/wpyTg2kSt+9TaL9puuLKp/nWysbx/fFnBMnEXtqDy9m/Evmfoa7I
 KG7HJ4oo
 JrJqvYBpMxbDbDFZDUmQvH9KEg2M+My8AqkvGkOEk04VdNqIIBK/vPSReXArtZPD3JQJb4IldnrpMD9yHmT3/CkKRk3loLDyn4eHuXQ8MSxKNDeX1kIfkO0j0VJzpP43gOqyFpKlNV/fZZH8GhQQDwKhSm6xUrVdD0SoDpfpuBPeUzsQkhhO1eT1nD24UftDJR/CTnPjxS0YLcdC1ZnOdm1VhApsks8zYY4lKYZ90hGUNqRVYZWzIC94wWAp5lkhO1WLVJtrp0r6RaY/+V1UHBCJZcL/bHqshJVYey3OW+ClaJO1AzxbcH7QD71+L7OhcsJEanVXbDUYw7+RBN33CJHBU/E5hLhsUbOyzA4dngd45MOm7XCSItb62gkJrqLLPizYL2PZ/rMSaYdRbi8XP5fCQjEcEkQ9zJ3MwNx4MGAzTmWniDGxtgIGdnQ8Papu5wTKQPWqKLaMtWsU9KEr7Tw6VoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For the root memcg, lruvec_page_state() returns the rstat value, which
needs a flush to be up to date. Flushing the root memcg is expensive, as
it flushes every memcg in the system.

Most memcg node stats only track memory charged to a memcg, so the root
memcg's hierarchical value equals the node counter, which is always up
to date and doesn't need a flush. For those stats, have
lruvec_page_state() and lruvec_page_state_monotonic() read the node
counter for the root memcg, as they already do when memcg is disabled.
Callers that only read the root memcg's own lruvec then no longer need
to flush it, which the following patches take advantage of. It also
makes the root memcg's stats more accurate, as callers that ratelimit
the flush can otherwise read values that are seconds old.

The exceptions are the kernel memory stats (slab, kernel stack, page
tables, secondary page tables and vmalloc), hugetlb, and
WORKINGSET_NODERECLAIM, which counts reclaimed xarray nodes (slab
objects). Their node counters also count memory that isn't charged to a
memcg, which falls into two categories:

a) the allocation isn't accounted to any memcg (eg kernel page tables,
   or hugetlb when hugetlb accounting is off)
b) the allocation is accounted, but it comes from a task running in the
   root cgroup, and the root memcg isn't charged for it

As such, these stats still need to read the rstat value, since the node
counter value can be higher than the rstat value.

One user-visible change is that the root memcg's memory.numa_stat (and
the hierarchical_* entries of the cgroup v1 memory.numa_stat) now
reports the node counters for the non-excluded stats, as it reads
lruvec_page_state(). This is more accurate, but as a result, it may not
exactly match the root memcg's memory.stat, which still reads the rstat
values.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memcontrol.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ebc9330aeae..2575bf2ba0ea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -389,7 +389,14 @@ ino_t page_cgroup_ino(const struct page *page)
 }
 EXPORT_SYMBOL_GPL(page_cgroup_ino);
 
-/* Subset of node_stat_item for memcg stats */
+/*
+ * Subset of node_stat_item for memcg stats.
+ *
+ * Stats whose node counters can also count memory that isn't charged to a memcg
+ * must be listed in node_stat_includes_unaccounted(). Otherwise,
+ * lruvec_page_state() returns the node counter for them for the root memcg,
+ * which can be larger than the root memcg's actual value.
+ */
 static const unsigned int memcg_node_stat_items[] = {
 	NR_INACTIVE_ANON,
 	NR_ACTIVE_ANON,
@@ -504,13 +511,52 @@ struct lruvec_stats {
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
+/*
+ * Whether the node counter for @idx can also count memory that isn't charged
+ * to a memcg (eg kernel memory that isn't accounted). For these stats, the
+ * node counter can be larger than the root memcg's value, so the root memcg
+ * has to read its rstat value instead.
+ */
+static bool node_stat_includes_unaccounted(enum node_stat_item idx)
+{
+	switch (idx) {
+	case NR_SLAB_RECLAIMABLE_B:
+	case NR_SLAB_UNRECLAIMABLE_B:
+	case WORKINGSET_NODERECLAIM:
+	case NR_VMALLOC:
+	case NR_KERNEL_STACK_KB:
+	case NR_PAGETABLE:
+	case NR_SECONDARY_PAGETABLE:
+#ifdef CONFIG_HUGETLB_PAGE
+	case NR_HUGETLB:
+#endif
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * Whether @lruvec should read the node counter for @idx instead of its rstat
+ * value. For the root memcg, stats that only count memory charged to a memcg
+ * have the same hierarchical value as the node counter. The node counter is
+ * preferred since it is always up to date, whereas the rstat value needs a
+ * flush, which for the root memcg flushes every cgroup in the system.
+ */
+static bool lruvec_use_node_stat(const struct lruvec *lruvec,
+				 enum node_stat_item idx)
+{
+	return mem_cgroup_is_root(lruvec_memcg(lruvec)) &&
+	       !node_stat_includes_unaccounted(idx);
+}
+
 unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
 {
 	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || lruvec_use_node_stat(lruvec, idx))
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
@@ -551,7 +597,7 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 	const struct mem_cgroup_per_node *pn;
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || lruvec_use_node_stat(lruvec, idx))
 		return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-- 
2.52.0


