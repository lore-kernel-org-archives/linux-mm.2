Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A81CF6BF3
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7C776B009F; Wed,  7 Jan 2026 02:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D9D6B00A1; Wed,  7 Jan 2026 02:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B364B6B00A2; Wed,  7 Jan 2026 02:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3E566B009F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:28:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D0141AB85
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:44 +0000 (UTC)
X-FDA: 84304340568.28.C37DBE7
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7CD1DC0004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2U+vu2gi;
	spf=pass (imf22.hostedemail.com: domain of 3KAteaQgKCAkkrwpsrjxpxxpun.lxvurw36-vvt4jlt.x0p@flex--bingjiao.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3KAteaQgKCAkkrwpsrjxpxxpun.lxvurw36-vvt4jlt.x0p@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767770922; a=rsa-sha256;
	cv=none;
	b=fzJ5yFWoxcKLjs4TARHOfEykrkb75RBXAn3J7DXKdPMAfoQjPqAx5TYQC0sLfgZn0AzOyT
	GSJXXEpzl3FuJLFqHvp7fKwklm7cXSaKzqTeIHr9N8dLO83723xw5DBmGooriwsZJLWLRR
	WGWbNu2etICNi2rbjpauHb7CD/UOuvg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2U+vu2gi;
	spf=pass (imf22.hostedemail.com: domain of 3KAteaQgKCAkkrwpsrjxpxxpun.lxvurw36-vvt4jlt.x0p@flex--bingjiao.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3KAteaQgKCAkkrwpsrjxpxxpun.lxvurw36-vvt4jlt.x0p@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVVdYtQjw2TjeADeQ9BPsRLaeco/a1loIhNj19y7Cbk=;
	b=uxPnLEZ6e4/EbLQJwKS3aKF5Gti0uHSlrtmjyndsx/ERyYKT9gkZfXpioR+QQIq6TzNo20
	qU4BKyenhTrMubaaqRwrTbIiK8GC926T5X6tOfgoXgdnfA6Zsg3U6XSfgaIMfDe0A2YYdo
	FMFL+jI59kX3uDW2G6sj3r1s1hbqC1k=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ae56205588so1422783eec.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 23:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767770921; x=1768375721; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tVVdYtQjw2TjeADeQ9BPsRLaeco/a1loIhNj19y7Cbk=;
        b=2U+vu2giWT52tIbUbnRYe3ITjdCLhgNwzjHSg/732i5COdiASO67Pdtq3lDzlxU7m/
         3kGDtR3voN5sYyYJXeOjz/wjiqfyeqL1BlGC8A8YpEGvUSpETAcF3vvFMi3/+VYYmbbT
         WUVo+ykS7bHpn7cJNIH/DG/R+BG4YhHm6P3ghfZSLe4TKdMW33dcTYIdMOd/PxTvC5RK
         W47VCTHBq5HgxKXdgszIY59yfb+tv4JgTL4hZO9DQDbXR22/zVmwpuWD/4FvaY6ASyvM
         2nQpmE2897bEQiGiySCdWdcGSFEbh2Lz7ypytqci8EaYwgdWcgvg0pkkEp9sq7H0h0+q
         6iJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767770921; x=1768375721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tVVdYtQjw2TjeADeQ9BPsRLaeco/a1loIhNj19y7Cbk=;
        b=IF55nEZLeNyZMs468PbiY2D3u6iFn/x94tJo2HxwbR1+tq4xqHAygBl7Ds/MK9sBS+
         tsGCFP7/zTG8gmH5m4cqgIzn4fMEiUnUSECUnNeeDJl5reKchWpH4LS3d5qZrDYw1/d8
         PLYV0G5koVBP+ObO63d7UUx0JFUzMkwKJpp/bk/GiENVRicE8qhvHIJi5MIXv8u06eKh
         BrmY2X9I9Kxd4HFl1nDFYyyqvkJ3wyLCBL7Ht+BNZsV1C9vrtVUm/Qmmz5WykiKmADjJ
         H04a9XAStw+Jl2AV1vIB/STVp0JRafzdP5kvTk8a2AQf+1gkyu4FQZFOUVcZSd5rSKHU
         WfLQ==
X-Gm-Message-State: AOJu0Yyw2pK0JZ0CgdJs5MBa/oQ7rtk2lxf8URg+JWH2S/8gfsrh0ryn
	4+3jNtoW8f7Ir/A15+XrfWiM6zJtDqXZGhmSHKplZ4RMfZSSrfamUWGqbsytAvxl4LtXZPvrEN6
	fTF+//cGEjhUU72UZxrUTLqtUP1Rmkm8r3uPGwg3Jr67ffkGmBdVyPvDdHuG8Fufh1XDDrlqmKk
	YwfLaRQ4PtgmARDp3+B19uwobxId0NnY4bLKXFz3uoYQ==
X-Google-Smtp-Source: AGHT+IFxZws29DhbbpH/KLYsAEx4pmiup8IragiPN7LI9PGQse+5aOUlD8Y1F5pVoTzX71AYu/bTg5dfcYA6Bg==
X-Received: from dybnl3.prod.google.com ([2002:a05:7300:cf83:b0:2ac:37c6:d441])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:188f:b0:2a4:4e54:dc69 with SMTP id 5a478bee46e88-2b17d343af1mr699818eec.38.1767770920934;
 Tue, 06 Jan 2026 23:28:40 -0800 (PST)
Date: Wed,  7 Jan 2026 07:28:14 +0000
In-Reply-To: <20260107072814.2324646-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260107072814.2324646-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.358.g0dd7633a29-goog
Message-ID: <20260107072814.2324646-3-bingjiao@google.com>
Subject: [PATCH v1 2/2] mm/vmscan: select the closest perferred node in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: Bing Jiao <bingjiao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CD1DC0004
X-Rspamd-Server: rspam04
X-Stat-Signature: 3aecymiu51miy3f71dcig19o99xs9y4h
X-HE-Tag: 1767770922-642686
X-HE-Meta: U2FsdGVkX19bKBGHmXm0zaqrwGf9fQVKtkpp2sCtzi49IHX4EX0pWw0RdhNK580EFNY+TpRoDB1hAWKEvb5bRnh3Cc1k1AKkYhcRJ02692XHG6vo93uUVK1bkN2hZ4fs6D19Yj/0njiInvwmMUvZrElnpsY7pfS+FReaHPlRFWcjcN8fLnnbB3xpWXlsxpuEnGCxFkT7pOHodMEPxKTKoNwu2ljh5heu7SXxZjREAJQA6dkMb4vgsSawO3ZlUZuIaKsaNHNZqHjyjJjEOgqSdc5avr2Vknt1TOaFxJM/iYsRFHf8+Igz/cCx+p5WqmlZsrb3dojx57au5flXKC++W6PJo84DQMjfswk23POS4GceBdwG5B335ssELJJmZumQs2/WkScWzdhsfVUwNyKe2+MQnPWjYf+DCcB3/xGgLpB5xIYLkNM99MvPAibJBJGBiVJCF4oT59d4GA8ynLiCULUU4aCD7crNUI0qDSt7Tk39vAuZy03iyYPnoWwONuYC8q8eZVDnbKMAetGHdfEr0GmbIpgLZctfDdWcu6wj0gdW/kT4faNwrPnLGhrYiIPjhaIVP8WoplSS5HuE9DW74hh4yCjSF2gQQNUSObicbSNFr48896nNgV0ku7/7QemcglQic59aOFYBIY279ke1kbpsnZdPJIBaUl0yDcGN1IJX1W7haJVPtpqHZuoaxTEEOpUHYFs/DvZCeueVuCEOZwI64f3TdMYqhCWAMi8lsVHgq/gx7BIZPhhf7jl7uXKXg4gFotwUHFzaCdwPKQAUdH4UWwJvtgEh7kR9QCsaFlFDauDrvjD1SoEVxyf027J32IiLcKH3/muDk9NhdIYKpWP0u8nk8VRtdXpWa5tNeDsL5t6LW/dIuVeWdLEY6cCpCOwL1UbeiHX42SA8+dFYB/Qar7vdW0KEiU4/DbnauXt7OioMoHMVHexSRyW4n7jblaCB/4FhC9Wp6iA1feC
 5BY1WShQ
 +dH6jb+yrmEt+dIQLDO46WkPbWpv1y1J1UmUE7qeYBWyWHcFaqc1bAtF1fyxFViobaO3BHpgDOxhgRlrQC7dYKr8QAgsiJqDET9tjWtoGUMEvj8pVaMbKkFaJvcE0d5tA3XqsXh0SSs9NIdHvhFMMiDLK9T52kjoVy2pzM6S8sd88CErqxADJoJ4QT41g9ZEveS3txyr3AeBE846klK5p4VYQo7yL782LGJKBM2fXFowkrGkpKzukAZMM413+Tyg08qKqLc8Xej2YsXnM0yNXkoK0lHMZXg8qR9RwTTRlt7PDIBL1NZMmxxwsPWJWwBN1C2ZdBYnvYNEJBlxaobjce9aeDg6CRBSP9JBm0YzWHD5CDkUWoJKc3RDlxpiWjhG5sRaVNhlir8AAz24RrRljwCMEFA4J/rE7Z/+E68s6wJyk5tWUraHhQVPExiiGU+T9jIpKxyof4ljS5K5iZHV1lE+5GYo+iqCyBIt+ic54sfHad27b4mM9eY4tSGZYmTU7Kr5rr4lM9kC4zlh4cYkfNnvm7kM8Ut3j9SMmRzg+t1b4kovpQipfnQDfFzc2tqhem+D2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The preferred demotion node should be the one closest to the source
node to minimize migration latency. However, if the preferred node
is not set in mems_allowed, demote_folio_list() currently randomly
select one from allowed nodes as the new preferred node. This can
result in selecting a very distant node.

Update demote_folio_list() to traverse the demotion targets
hierarchically until the perferred node is set in mems_allowed,
ensuring the perferred target is always the closest available node.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 mm/vmscan.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index db2413c4bd26..d452974c946e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1052,8 +1052,18 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (nodes_empty(allowed_mask))
 		return false;

-	if (!node_isset(target_nid, allowed_mask))
-		target_nid = node_random(&allowed_mask);
+	while (target_nid != NUMA_NO_NODE &&
+	       !node_isset(target_nid, allowed_mask)) {
+		/* Get the preferred demotion target from the next tier. */
+		target_nid = next_demotion_node(target_nid);
+	}
+
+	/*
+	 * The perferred node query is subject to race conditions such as
+	 * nodes in the next tier are hot-unplugged.
+	 */
+	if (target_nid == NUMA_NO_NODE)
+		return 0;
 	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
--
2.52.0.358.g0dd7633a29-goog


