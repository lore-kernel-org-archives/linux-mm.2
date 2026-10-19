Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B98F606A321
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=avrWlHXY
Received: by kanga.kvack.org (Postfix)
	id 51D796B033F; Mon, 19 Oct 2026 14:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE396B0340; Mon, 19 Oct 2026 14:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD106B0341; Mon, 19 Oct 2026 14:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 193026B033F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:47:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A813807D3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:47:17 +0000 (UTC)
X-FDA: 85340258514.08.DA01CF7
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id DED55180005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:47:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=avrWlHXY;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792435635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hbKgm88xqZwylAt4q2OznWtgQkbJqO8+m4FSvU2MBBc=;
	b=WbSSUFuUhCE6DPV/AkDO7j+SY6BLOYgjPwPX861o/vGexLTZcek9mGd+6NHx1EMttrY3mx
	HRM47TWAaNdJbBIGDROVpsyEk/dxnssBgdY/rheDQMVwT5Q0CF01/sU70IhqStSxMivJzf
	j5bWLXRnlj/yMs5C+GnrVwB6LXTVvf4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=avrWlHXY;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792435635;
	b=BMzcw35JV0PvGo7tNqab63Ay5v39XnUCDltA/ZrFRh7sxM+rARnHJxM2K0GM2UU4nDj+VS
	mQHdU/BIFjmVYo873TrUrKGC0sjpCt5z2QfmcHwnRWGZiETTrMI50AqKWXXt5Olf8wV4qb
	urz5ImewvXlR0h4evQBJnLnIqptEkig=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-917a04338c1so22977136d6.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792435635; x=1793040435; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hbKgm88xqZwylAt4q2OznWtgQkbJqO8+m4FSvU2MBBc=;
        b=avrWlHXYRZZO44sT1+GqSB1LCsmV8ECkVyX3aakDOI+9bgMKbamjBnqXfyglR21m3z
         BY18cpM7rOA1d6Y3L12VrEyZOHszVfkP3nkoOPPfyYLe/ua25wR648jv+MV2PZrz4yn7
         b/fnIOz78DjSt2oxr9pUWgWSkuQkB0yxaRdUIoSZRZ5o++ddrAImbCo2ImLPzGHjK9rw
         DWUSzFHDGMRzbouvZxql7pzA5zkH5ckBqu6eBFRGE7Yzy+EvMf8McXTA1gg/d9gxkcDx
         h/FlXkKVTWeVA9xWLptIZb6/eE7J8dZjIZ210Ayj+EH29eRARYX6vd5sSxQEiDFJqcvN
         qKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792435635; x=1793040435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hbKgm88xqZwylAt4q2OznWtgQkbJqO8+m4FSvU2MBBc=;
        b=V54tB4f4FiVm6QLSUXAJKlyaOuEwmFHD+pjP213NuE1B2+utfzhFiVE9PRl6wJpndX
         ULAx3/2x4xU+K8GyAtouxqMDRfWTUoWUR714frEcJtGStx62aOaBbtTeSkEZHcOF1NbG
         p4huQYyUlnGs57LlVwmNMnpHN/dIeEyhPM0sikYpXJ7cfvlp+rrtIazoT/4rR3aa51Bv
         ExKurnCE0BWvKlVdgG5jH7kROe9ZCKOH9wzeEwBMkV9dvvb9tBCQ7kakUGy2uhEe+9GE
         CCwfSucvjWCvZ3xk7Rw/dJIJQjm7+y1XNk/2xGf2gC2lH867Scp0p+vWB2dYo1v6RTV6
         iSzw==
X-Gm-Message-State: AFq9FYJk8D+OZ+UKU/7kSWXQ9yMpiVGH1do0/rVTVDSOwTLLsG/t3C13
	ggSryaTq84dDMOoH3ZPHEMZeP0riyXtsebzngpcw5c9fdVNFNBmEQFsNnwRNqqPTPZIpsM0Lbk6
	Na8PzX14=
X-Gm-Gg: AYBFou3isEnxpXvafh8rBpfajLrrx00uTzw7IcZE/pfMPhathZpvNT5+Lo+afi1bQeO
	ZsPv98czeiAOGkRp9NRGkOuQn6T6hct3qYEM4N/en4Unlrg86C/SBOfZjcw56hb8i35OxlZCclF
	YvVmdTVwKhV65wPe94QEV78H7uHrl2L6Qja4SuT6kT05MQZ0WzyIqVDwu6JD56Lomzj2jM4eU4x
	I0tzA6b2CDqrC/uW8nPPXRMkHc8HEROM+uh9ILq9msDQQSDT6nF+PxBMzRFQFtUKsv9WMHH/Bpv
	6cHGZjjyx910Wvl1fWmNRI/tkBqh7sgrGBrIBXyxigWpYaws5q6uzo7Q3831/KjKsJoiq0E9CIL
	KJQ5w+iRQMxARNeyML4Yi69uZcUMLa9GgRTwWakACcdh4Mg723+EUY4UEnBVDpVvDM2X0KyHhIy
	EyQyPM8akVv7w2kL5qlVoADUnmHpuH56Vj+MBD06J747pFPeDtmYxKSz+9URkybVHfswPi1qdto
	QleAqwh2ct/kgOCMmm+14HA7Jc7PDpvEban8zB35ylkHZx+NjOtwiH63NFG
X-Received: by 2002:a05:6214:3f89:b0:915:4229:17a3 with SMTP id 6a1803df08f44-91bdf7ef1bfmr142927206d6.25.1792435635045;
        Mon, 19 Oct 2026 11:47:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040e2ddesm3081366d6.36.2026.10.19.11.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:47:14 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	weixugc@google.com,
	aneesh.kumar@linux.ibm.com
Subject: [PATCH] mm/memory-tiers: reset demotion targets of nodes without memory
Date: Mon, 19 Oct 2026 14:47:10 -0400
Message-ID: <20261019184712.3422641-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DED55180005
X-Stat-Signature: hxstmwpawqt3nddiwjwp1b67m7mw1643
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792435635-510123
X-HE-Meta: U2FsdGVkX18kEaSnUzwOhIXFABzKC8MGpg9JCj2FnH8SJGaz1m5cVuvJoC9EdOE+Sz+CypWl3z9glIF0+cBxpWNMmNp3/ntj25UH1nSQNJY3UZbSLKHFkekNPGlGDNwVRiBCkIAnqOw9Uv7yT6R0SPlxj5wEiabdmA2lPJRylreTufuGwtKV+FRxMwy5OL42tlAX4uD4OVwMs59jcTWxdWZaUZL1wLtWoyYCst5s+tUHITRMAHzv8RvOJY7FnZ2LHTYS9EmC3s17/G3S8hu9PtrJuyT2/bkOZpzkGtZsO4IoIcddANi385CUE+YYTSL8yKSP/gJ3dG+2ZPIsP9NwNoe0IREU5DcEKBWw4oiWGOtWve7IPcrYKXwG3ApCILy2rteecM+IM3wJxpwstNggVNiQpYi3RPFjaFvM5G+ggz2GU+HLoPOKsxPW++CxicwwwxvrFf1TQbz9AOa580qAM55jc9Gwe5HFQTZGAeSw+Zs3WVXWY5HLw166oTRyhuQzTOIINWVHlUoAtKV7jMlXVMzmFoBtnrgWhVjwXgCYaw/LTviDJ0vubwfKxfoJAYitL6iH0GEqsKr1RiKM1k1kbKuglUYumfEd9ib7JBVRyoe7JSSL93zPSgRz1xAXR0iCvl1VAGsoHdVyPa1OLoHsvDOZR0Mso54QMXQDuFurWA6AzjNwO3e0gQWcEgWC+NcwHyzuAZCDUmsSslJh76W4MTtWA36/PX4rkovk5kSeCXaAMALlDtM1CSxEGYACjjr1+EbgrZyz7DYX/rMB4XM0unmKv8GqY1WRYz8fjo3yyv/9YvIoaeLfqBasLIgw93v8RfAC7NfZlwDxnWaEIZgW053CbUZt5+AEwacdjlSi0ftpOSVpssSMZmVlzVkQpVTilPq1+/wLUUFLD6WuEtyrRrN9YFXyMAQc9taW+RGapP8cEqTCG+mqlYqewi43jyGfr1L7OS/Y6jc890YfuQc
 67dC5U6V
 RUKKoktb0w9DUEhxBC3AldsT6+lAqARLoEkM8LchzSdNMQFdIzdgeyLQL+YYDFF0jGiloLFZvSyzwNoB6fuGIivb2P0pO7VL/lPjkVcu8ocdfhQkedVEUj38wYs+MXPQ2dDYxR6Mr8wGrg7yezZbHbkHbH/euILXAAHlgpn5e1hWWpf1cYRzKPBWAhhn+PxDbLBbRMymFAh4p4RI+0QcfDluWRXU3Wz411F3uX5SnYE4PTvfRDhlvS0J5zeCjaxqUGBjAQuJ+9zY1pUbdyIjW1s1e//5pjip+G8wxvfKz0cdixOWpG5NsnHJfAiBAtjszUIcc/b1FAd7+66SkEH++5FSb+GIdRJR1laxGXQK0igIJoinD+oc5ylto8B+Q9fCd2P6o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a node loses its last memory, offline_pages() clears N_MEMORY
before the memory-tier callback rebuilds the demotion targets.
disable_all_demotion_targets() resets only N_MEMORY nodes, so the node
keeps its old node_demotion[] entry while it has no memory. Before
6c542ab75714, the reset covered every online node.

A reclaimer reads the stale entry only between the node regaining memory
and its targets being rebuilt, and it filters the entry against the
current allowed targets, so there is no user-visible effect. To see it,
online and then offline a node's only DIMM: a debugger still finds the
lower-tier node in node_demotion[nid].preferred.

Reset the targets of every node.

Fixes: 6c542ab75714 ("mm/demotion: build demotion targets based on explicit memory tiers")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory-tiers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b586..7197f1a67a340 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -378,7 +378,7 @@ static void disable_all_demotion_targets(void)
 	struct memory_tier *memtier;
 	int node;
 
-	for_each_node_state(node, N_MEMORY) {
+	for_each_node(node) {
 		node_demotion[node].preferred = NODE_MASK_NONE;
 		/*
 		 * We are holding memory_tier_lock, it is safe
-- 
2.53.0-Meta


