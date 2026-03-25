Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DFCFEA81C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318866B0005; Wed, 25 Mar 2026 03:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1016B0089; Wed, 25 Mar 2026 03:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C77F6B008A; Wed, 25 Mar 2026 03:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09E016B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:31:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 995565AE9D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:31:06 +0000 (UTC)
X-FDA: 84583764132.25.777071E
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8DE26A0013
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:31:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=VBlvPRQO;
	spf=pass (imf25.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774423864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LRor7oZnl2gk48SOhwpp5bgA4g98rV8TzWVj64hfSy4=;
	b=MtnmA8CMauU0wlVr2xU0Pabkl+hD4A/jVupXhYlp8r++DB2HgqY0YcbEuO4akeKSC4xHny
	axksXX833A/k6PzAqiYpgsRNk6y8ECH1MG8eGqDc6cdyQVvwif0WfU0SnHPK2HfrG9ZOnS
	Y3QbfGTdq7+nRpPohjD385OoxKouCD8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=VBlvPRQO;
	spf=pass (imf25.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774423864; a=rsa-sha256;
	cv=pass;
	b=ZZ8t3tgR2I2vLMbZu6JVnXJMM7SXdZVPgwykfO0oEx4jOSkDM9mFO+4eWZaLSGQ4wdzz4w
	jlgv2QElGnbNChac/QmU/cBNbPVDUzB9Mr8Dpw2W60Fc8adBZN/mw83koE73G2GcpFLLpY
	VT1CLop5MwKtGPTOyL+NUFWL9zYNj0k=
ARC-Seal: i=1; a=rsa-sha256; t=1774423839; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=RgkZUvzrFXb7IUuxWpYRPPG4sVRS1HxPT41WVuBSgXH8BBsrDEZsPZIYNIWsZXXdmd/IUp/mqpwT8JNX9xim5rnrc4TfikF8qMaVm+60NUg/7JiQdKO6gxUtKnP190dTNmMOTNo7ezzrbsdX5hVC0QXXNIRh+wWN3Jg992GQUxc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774423839; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=LRor7oZnl2gk48SOhwpp5bgA4g98rV8TzWVj64hfSy4=; 
	b=b5qmkAZgf+j2gwuvQCZEFmWTJ0XKTiMGv1hqHVwuwudKLvcqRks+GVuj9eCGQFEwBFBGGKolnWJ3KEgT20JXdghxccGdKNNd9kc2Se+kgwSAfmFa5iVYAGcW9Sr9rOtM6n4ZdqsN21B5OjL6bkaR6Q3UiYvzfJCRJ1C6LlFBJh0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774423839;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=LRor7oZnl2gk48SOhwpp5bgA4g98rV8TzWVj64hfSy4=;
	b=VBlvPRQOpyfhT5XN0xWlL9ZblM7oGQNSVZXaTMYjjhCjiqRZ7yqp8mvyVyBt1qKN
	Hhsv7DIsq1t4Uv02iQXdmkZJWfiB1zHszFy2DPgF2L0kh/sXvReVus7wboW0ak+ySYR
	uGWNJzwjcwjw/BG1GdAmiQ8QLwWLew+81csNbMRQ=
Received: by mx.zoho.eu with SMTPS id 1774423836046413.8985698344709;
	Wed, 25 Mar 2026 08:30:36 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] mm/damon/core: validate goal nid before accessing node data
Date: Wed, 25 Mar 2026 07:30:34 +0000
Message-Id: <20260325073034.140353-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DE26A0013
X-Stat-Signature: wxw6gedsfcrw9cuwz3qxitopi4h1peyj
X-Rspamd-Server: rspam06
X-HE-Tag: 1774423864-550611
X-HE-Meta: U2FsdGVkX19FCY25bObvEGaT50ddDHkomBQREqJSrkKJhYpPIgFlYT/8Ne5djvD/kKboiUeNxW56eG+lo2/jXg1ED/QdEFfP6cAV4Fo5bwz7KSHcrpGAe800vIj7fngyZmmGzdOee6aYQN5ZioMT4aM+sdRQc5XMZrhB9uiz5QMm8en4PfpYYhfyP/UqMQoMb36Zo/7yLzZgxyzwbCkKjagAEFUBbCu3TTNgRitEL4+crVsuGhYmMNCZR0u2d705ceoCGfIxhhEcNuDZum3TGnK4bn4eJfaeO5EsCIzv7cYnUtDD/lUpzWrY+hZJiam4lzm57OsvAD1bQcH/kqreb5UOBZSRKjF+pY0zoR6Ksz+dTRq3mAQecu/tP1CcZXJ6iELRP9+H0Mq9ryYClurNcw0H5/AUZu97dbVPpHO3uM3aQYgoPuf95zj/6Vc40+lizkjT9WLTbT95ccc4mF0PSQPvRpgKVCgOCx4Fbr2jVc+GVGTX26Q2QEi8NmpxmTh6mdIT16iYPabFB8WXoXH7uTN66Q/xz2mKO8pcTnCdmOxS7dcTAhkCLgnPCj6zQr6bJkW9/cJthxqbdlfwxOZcVpllzxUSqwvb0mnMQJCvAcD2x8XuuZBs16LDDRifrIBwGS85RmH0XEgEptxmGJMH8CVU8gvjM19xtcpQNuhqnRcVocFwVWtjMEE6nZ0kgGqDADBb5RDDVnoGndluhYeggOUqwmgGnSzjEWlSpA66nBxmlosUeduGI+VojcUdhRxAqh5/pQBDztrGzaxRbvcwUhSJSAg/ap+d+SrOqEokJEmBKYjF1oQ3jHUsotx7tpwBszRzINnww1Vz9lCklxAL6BCZ4hU/f891ZyWchRQjtIOzxOYENTCkS7GMiLH128Gm3xFFBV6sZk0q3xNEYb7eAV97ok3Kjb47c+h4Su7NziDaXxArYfraoakPvq862NoQcXhk0N+WBNhBqXypkvc
 WAPS6mtQ
 nCoqZ8YopIeTX6CjAvMEIQwsI6WdeCRsPCeBC0n/riqH6/GehMxOf/HVo7czs4FXSe71aQeM/lR2IwTiAVyB6cRwFBqbQWLShliOI3kxxXsdmlL4YkFdhYAcby1yqgLP9gTJ+7PbvGf2N4fh9VEv5LwFjX5EvRmecpfZLF4eCmmMezvD2sUfIjCvkOZDCXDTMAIzh7Rf/nfYDFfM92/hG33RXRPMgmRsmT4y16ZOHihfLRIERTgwe91tndExPQGCnl9ZoD2qNaE2uLiAtP73Rr1Smq9wibR0f2gAyhnOGAIhDsGKbH+mJCicr95JVHGNLCZHmsrzf9VtbAtUc0LFkT2gG8IxL4Z3jP0Cy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_get_node_mem_bp() and damos_get_node_memcg_used_bp() pass
goal->nid directly to si_meminfo_node() and NODE_DATA() without
checking that it refers to a valid, online NUMA node.  Since
goal->nid is set from userspace via sysfs with no validation, a
negative or out-of-range value causes an out-of-bounds access in
NODE_DATA(), and a valid but offline node gives undefined results.

Add bounds and node_online() checks before using the nid.

Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 59b709f04975..6ee421141996 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2227,6 +2227,10 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 	struct sysinfo i;
 	__kernel_ulong_t numerator;
 
+	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
+	    !node_online(goal->nid))
+		return 0;
+
 	si_meminfo_node(&i, goal->nid);
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
@@ -2243,6 +2247,10 @@ static unsigned long damos_get_node_memcg_used_bp(
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
+	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
+	    !node_online(goal->nid))
+		return 0;
+
 	memcg = mem_cgroup_get_from_id(goal->memcg_id);
 	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
-- 
2.34.1


