Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA1FFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66996B00B3; Mon, 27 Apr 2026 14:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E174C6B00B6; Mon, 27 Apr 2026 14:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05B56B00B7; Mon, 27 Apr 2026 14:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC9FF6B00B3
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:22:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51E1286E4B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:22:36 +0000 (UTC)
X-FDA: 84705156312.11.271006D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7501EA000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:22:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HSSOZjVb;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777314154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/KMirMHSjSB1swterfioemTfmMtbVrKvVqnr27FyTo=;
	b=PL8VXZdj3U70q8iCPCU/N9qlhNBqmGWHFgCGGYb97SlxZAHUnA7Zu1eQA2AMw76+fXq/+Z
	jVTKESDNxdLphMNJYsZSdD4nB0CocnYdNlLGlOCGCcYpsKva+GQGm6WoxMG5sfaiQzJa+f
	TwmCUpsj6uQktLsQ8jBvT0gX2bzOLkc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777314154; a=rsa-sha256;
	cv=none;
	b=7Tcc9xLob4kXO6lcYEC2eRvovps59G1jnZpPz2BBi4U8thZW56zkVG4FRBig8Ij1Zv9QFJ
	ojWlB1SDVKmU4ZKOYsoSEXIbAuNcAh7hlZ/Qp6eIUxehFZ9WvWtRYmrpHFcQhDyB8lic1e
	SrJ+vg9NWB4knI1f8xu5dRA+qnKZ88M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HSSOZjVb;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5795B43AC3;
	Mon, 27 Apr 2026 18:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF49C19425;
	Mon, 27 Apr 2026 18:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777314146;
	bh=ZWEoXgUS/wfNTmJKMH464dC01fv+yC02z9MlWK6fI5s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HSSOZjVbACaTHAh1yK4L/NRqT1Na3DhszOVcUjsGdS1txy2IfGGyWfcEH4aup3OrZ
	 aHSpCZmwug1e/IqhatX+a4f160We6zSXtvAij3J1eSSI4viMlBpuODrp01fQY/JHp9
	 0ea7VaLV+X+SXsEf9GwKpAu6UQDLi9TZe2zgfaGA=
Date: Mon, 27 Apr 2026 11:22:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko
 <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes
 <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens
 <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, Leno Hou
 <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao
 <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, Kairui
 Song <ryncsn@gmail.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-Id: <20260427112225.3f752a385f58bd7dfddfaa25@linux-foundation.org>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7501EA000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 9xt7jgmb6tg3acy9ogxc1ycdqrknt3ug
X-HE-Tag: 1777314154-55424
X-HE-Meta: U2FsdGVkX1/0j6z58DGJoIeefGDpT2QOEAP0luThfPVA0aqikAfMxFnMQfM888B2RxgzIPgY9+sSy2FChlRKpfM4fE8U61h9pZFZfSzII1/dkAW3M2VR1shTeC8nbpmZ7Xilu/pfamSmyb0mfpPNKoDfCDoj2Xp+uGBjBF5Tm9XUKS4/5OMui7Db9VTysA+mRj2wz/s/Wgic3YNYOeKIi37MjPjV1GbaoEEeu0ZYo489GhrmyY1yE3gfFgTaHUXR9TS9UhQZn7ZsgA1b/gMvac0udP7F/cb0EiA/AIk/14dZ5QRT+jtSEyIWivYYI2rvx+5W1zhpZbf+iYZ0mg7jNoL1AXPHy1yhPde5K/vmhxizJDL+ncvs7Eid9aPtSLmlqfsrH0SB7sOzSBcCpH8fU7RSyDlULACvvYs8nnrCf/sMTOqOU0TJGG5bHe7Vw7qdSvq87vM86ees2rmLS96Fec6kZDdieWzlG94fRdlkqTQJmUliodvD0lXqlDpeKmeC83u5Q5vomB46FpTAOjewSRPJMMQWxdIB6L7xmxiL4sAPrd2evmQLVGcnB+q6q5AqqXdUCVm7c7/wcippnaWobWOzC8I1ZWDvWaSfGQnMv837SLO4ZK/CL3K5mByWmI5pEdSqu65ga3FTas/bvpjhqK9iX9K+QMay6JFNhlN/jjdT3Oa1myETMB+T8CtfRjMTegmlzP1Y/ZiCx118+QPwj1TAS3ar1zUAtDxEXZ4m8963JtXjjZJpCUeqXcy5sZX7GRK99xThPep/w3J+qTZh2ZZaveXyw18xgRkuLDsSaEuF4jaGDEXvkN6Ycw32zKwXZGFBkIlV/wu+SXGeVZP0JXi571ma5AbqrtAUR35avR7YbaT6h9yA3JV6qyaY7OA/zXyob0tiIsArGdOGuqHxs4lQUkXUcD5v9HUXAjKCpNkndIpJ2LvUO4aN0rtxkyDlCRgbfOJYgXHeUW86yTs
 LPUgelmz
 bDVuJ2Cotnfa8RP8JIuIjtEZJyP//6b7NWtRPnI22+x/tFB6UzyNDBhjNTrvI+Q18uVlY4bLkStDhbgVdv1sFObd8PU0irlQY7ZWOak2d4xHjPTFboH5PA4McBlf/Y7+q78UDFCzRUoyNgP7qTPOJmHJGmEcb2F5j2fR9mYhs1qCHvhBAphkw2C0WDKmhEoKTWqBCZjPJDwohtpBeu5VtBHEdzGPO/BTMddTnkyxdQ/dl0l/gQjkvdBv6Lk2zxKmoA/0gssx5eG5v67p57H60+GqCWj2x3BUxBFZ38Qm19qx+aEaKz116weboguyyCYCmhgJSa0luc9huB8u4cXyPQ0n4hzgytlH6fS1xEduzNA0JhiyfRATmGXAZK5iEvdd8cQ3a6BraRaO5ELIN2lArDRhF27SWwX9Qz7RK5LOe8/ptcj1xcW1AVdtV10X3BXcoKb8Q9Vp46Rml0Wo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 02:06:51 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> This series cleans up and slightly improves MGLRU's reclaim loop and
> dirty writeback handling. As a result, we can see an up to ~30% increase
> in some workloads like MongoDB with YCSB and a huge decrease in file
> refault, no swap involved. Other common benchmarks have no regression,
> and LOC is reduced, with less unexpected OOM, too.

Thanks, I've updated mm.git's mm-new branch to this version.

> Changes in v7:
> - Fix swappiness not being effective with a standalone fix patch
>   from Barry Song. It's OK to be a standalone fix since that is not a
>   major bug but an unexpected behavior change, and shouldn't effect any
>   bisecting. I slightly adjusted the commit message as the subjcect is too
>   long and getting truncated for mail:
>   https://lore.kernel.org/linux-mm/20260425205759.1701-1-baohua@kernel.org/
> - Remove the min limit for calculating nr_to_scan:
>   https://lore.kernel.org/linux-mm/aet1hd9DfRH4aSOO@KASONG-MC4/
>   Instead just revert to V1:
>   https://sashiko.dev/#/message/20260318-mglru-reclaim-v1-3-2c46f9eb0508%40tencent.com
>   Everyone was fine with that, the min limit in later version was
>   introduced to cover sashiko's review on V1, but now think again, that's
>   actually not a bug and instead could be beneficial. This min
>   check doesn't always make sense and there isn't any practical issue observed.
> - Retest still looking very good in every case.

Here's how v7 altered mm.git.   (Looks small - did I mess this up?)


--- a/mm/vmscan.c~b
+++ a/mm/vmscan.c
@@ -4788,8 +4788,13 @@ static int isolate_folios(unsigned long
 			*isolate_scanned = scanned;
 			break;
 		}
-
-		type = !type;
+		/*
+		 * If scanned > 0 and isolated == 0, avoid falling back to the
+		 * other type, as this type remains sufficient. Falling back
+		 * too readily can disrupt the positive_ctrl_err() bias.
+		 */
+		if (!scanned)
+			type = !type;
 	}
 
 	return total_scanned;
@@ -4909,18 +4914,14 @@ static long get_nr_to_scan(struct lruvec
 	unsigned long nr_to_scan, evictable;
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
-	nr_to_scan = evictable;
 
 	/* try to scrape all its memory if this memcg was deleted */
 	if (!mem_cgroup_online(memcg))
-		return nr_to_scan;
+		return evictable;
 
-	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
+	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
 	nr_to_scan >>= sc->priority;
 
-	if (!nr_to_scan && sc->priority < DEF_PRIORITY)
-		nr_to_scan = min(evictable, SWAP_CLUSTER_MAX);
-
 	return nr_to_scan;
 }
 
_


