Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3951FCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 18:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC778E0030; Mon, 18 Aug 2025 14:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5C698E000A; Mon, 18 Aug 2025 14:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73338E0030; Mon, 18 Aug 2025 14:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3F828E000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:47:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D4DA1A0A39
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:47:24 +0000 (UTC)
X-FDA: 83790761208.27.E5D9E09
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2AE27C000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:47:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fT+6cKY5;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755542843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h+q0dQZyXjwiVna/qdmYwFty7+4QP8wlenLPfPU4ybI=;
	b=RrumLXyB932UlRORNJon8IQG9/XPpdoy6KBim9RAqP04Xy+9XrEmAxTTJnYVuTA4oH4WUu
	2bnKh4FlWRoySNf8lwwjTSfZoRS0qUnMIePvx5/K6QSeYJ3F7RuUlmqSaNSNVEPIkO+F7Z
	G1qQmNLTILM/+DawIO5nQ9VsehM7m6c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755542843; a=rsa-sha256;
	cv=none;
	b=7DjkiGG8v/81CwDy6WGK8GpJ4ohJIH9uyk0o7IcsUEJKNKnL2TwTzmzMevJkA0dinaMnJM
	v0FRmcwxluk5Gn3lvv7wkRRqX+QBd4bNhlYPdiIKPQatQHkyPlLF85mS9gu8e3jLpMc5wz
	1S+xLLDhcSBgt9NIH0qUXCtTy+TZ8jo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fT+6cKY5;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755542839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h+q0dQZyXjwiVna/qdmYwFty7+4QP8wlenLPfPU4ybI=;
	b=fT+6cKY5SW9ud/HQq2Jjmg+rGfIZYENyeEUS2fD5hp+uiWlb58YP4vKBRHjcz6ojhSyWg9
	kP901WLvabyW9uXifTsf1ehbo/jZXV1cptnbqK15RhqKwAmMbhYFj9i6l3pqRwffY7IqPm
	Rt3QRUcLJgj+8/3wtJbTN+Bds3MBoMM=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Boris Burkov <boris@bur.io>,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH] memcg: remove warning from folio_lruvec
Date: Mon, 18 Aug 2025 11:46:44 -0700
Message-ID: <20250818184644.3679904-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2AE27C000F
X-Stat-Signature: wxkqe5wyabe5zkdoyipfztsib3qzj4h9
X-Rspam-User: 
X-HE-Tag: 1755542840-779435
X-HE-Meta: U2FsdGVkX180aHVAweNf5N5aX7uNOpy0my3rd5+M0WeGTEroc8Lby5wavPMfwwHBr8DZFz5YQLbp3OenMsPNsjqroeLWxdAboIb9fcuinb7bSp/yk27LDutMUjOo7HKJtCazx41R4SYfAvv6syfVGTWEe3nmO9A55VYleHPFPbJ7Gn7YDBJyNP/5ZiBKMHsCcW2bq0FCBMEo46TjGN2nzKCpM2+FSb3ApVbGlrwP7AaG77WPXHuXkSC0JiCHxWQYM0VEvFAFG+TmxUzdU5mJ1EkBbLivz147OJKa7akeoZiqQsQr6cdpVs9ipGMcdnbC1gnuX7/D6PIRn5t+zHgveq4uuj8XYjenQBr/U27TownOZJdbh7zrJCbrm2QVsu55qOYZIrlAqQvEFjY1/XjcXYbaL6vR+hj11nYKMrl5Am0xYYohRo4n7dhFtJy7wPT5DhNMnh4+WmNhslMeKQPFRZ1l/UMk3M2ivdxpY7XQnt9N1IvP0xPRluCn1DQ2cCfgOOtvoew+58Q7UEuq6/TTKiyasQ+yfrp1dGNMcUm9iosxQGn3pVRmth1sR0zamsaoRAAUuXzJR19hZO9izRS0DcK359imxSeO9BMNRiWqWW1N3MZ8/qfdwISGON9amf14QR1f2CrnrG+5i9xVmaFKHGaGWShxcMRm2Rh2PsgrQKwX5ktBSdih0tzYtrqpme7L9Af+4mFIHvk3fb2RXpwkyRPQqXBx8KJNOUIHoo2PBAdJP8mvKln3pIba+auplXuUkJdzXw5sozlAA0Vi4VW1IlVsuLua6ehYCoSGozIqDMmbiDXpHbSMqSgT8A7aebzZmDCEXHtZW+Fyf1A3rDXmoNX37eKETkYFs8ZeLby0W17JCYou+W700PjmYHX2wD62mwWT8NC2lNMQgDKglVQzw48o9lXqnFPa7vrOy8FNPLvyLavmcbvBmEgdbXmmXvqD5vQCCUjFerH3YmK0Uxa
 mP/a+4yA
 3YDRokx1vKlB6nLxJ20B/vYnF+eFE9EIWK8sILmkfNon5TMZy882fGdk0fcW46W7apgK/I3JZH8A23K5/0xa2T2BTfocVQO51y0IxmoguDl2lIvdCw+YTtQSh6oPr/JtUWFEDCEsm+P4H+YlPwJ00QCRpqQMKr0kU08QaGBQvTGwee4JdLlqjownsatUe5s5ZCTbVbGoHC/JqItuLH/q2YeqZrN97BgLp8rk3xfInvsd+kWrE1l72OKSJZNVPKnhoedp0AnEF4s0lnUAia6/x4pMQmeIKBOYYNjQtyI4IdEtmcUD0FVPpWG7U3Uzlq7UE/yJYUz4rXRPSOCncShQNS2xJbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a4055888629bc ("mm/memcg: warning on !memcg after readahead page
charged") added the warning in folio_lruvec (older name was
mem_cgroup_page_lruvec) for !memcg when charging of readahead pages were
added to the kernel. Basically lru pages on a memcg enabled system were
always expected to be charged to a memcg.

However a recent functionality to allow metadata of btrfs, which is in
page cache, to be uncharged is added to the kernel. We can either change
the condition to only check anon pages or file pages which does not have
AS_UNCHARGED in their mapping. Instead of such complicated check, let's
just remove the warning as it is not really helpful anymore.

Closes: https://ci.syzbot.org/series/15fd2538-1138-43c0-b4d6-6d7f53b0be69
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9fa3afc90dd5..fae105a9cb46 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -729,10 +729,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
  */
 static inline struct lruvec *folio_lruvec(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
-
-	VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled(), folio);
-	return mem_cgroup_lruvec(memcg, folio_pgdat(folio));
+	return mem_cgroup_lruvec(folio_memcg(folio), folio_pgdat(folio));
 }
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
-- 
2.47.3


