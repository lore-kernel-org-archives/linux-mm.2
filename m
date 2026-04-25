Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37CBFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 20:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B806B008A; Sat, 25 Apr 2026 16:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2432E6B008C; Sat, 25 Apr 2026 16:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1802E6B0092; Sat, 25 Apr 2026 16:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 086446B008A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:58:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 977DCA03B4
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:58:10 +0000 (UTC)
X-FDA: 84698290740.25.F4B6346
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CE3AC80009
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:58:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BcbK+xze;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777150689; a=rsa-sha256;
	cv=none;
	b=GdltaBV5AZurw+XzEXk0xiuKke3KtvYtCb3uf4x5W/bnloBaxv9ft41m7lLEZejpPU26H/
	0SF2IVE9v3vIFzflRNWMijUZy6bUlwTpstW30VZsA8ZsRJi1sUe+M6BzHCoOkodte+uCFq
	R2gszrNI1hGrM4kInGJlU9s8mjTttiI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BcbK+xze;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777150689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgdEEd8doLUvs/dn9flQgsDbHK4z9m7/mgNcer+Vti0=;
	b=r2Wb4Ylu/w7tfMnljQIZWgRxirf0iAiDjTQPKU+Tzb07lSt9/TfgxvcD8dCv1EUUrb92z4
	v/PUvNsVLELJoK2pxT/x+rHFpMT2f+ufFmFUCtmqQAW+N+SLKka0pf4MZLuh6+zajCM5EZ
	L89xvpm3ADKZ1bmoJZNB6r4Qn94pqDY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC47B43FF2;
	Sat, 25 Apr 2026 20:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58321C2BCB0;
	Sat, 25 Apr 2026 20:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777150687;
	bh=+hSFQy10jXOwXKkPWQmI+ovca5nHeECfaZ4vk+Fo/YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcbK+xzeaaHw9zafOoOvGc7MHhe83Ktwvpsj77yR27U01k3Fog5Cu92T7e+Zgy+Rb
	 DRkuvkSHMQbRZcRWTU64fej+2Cb61+rhjAC0pISZtsud0iql0tLkPeS55ZE426MtTI
	 53ULH9sFlXlUDcrLs6tMtBHqF0njXcP8xDORQFP4bG2rJJuYhkFtd0lcWYJaQU5Fs3
	 1/6v994uGrQ3Kfr3kUck4nTDKOhDnCmR1KUnzr/WltYvDPMqOs4LPfEoK/Ux2Fcc2r
	 P46q/+Lik147WDM3VgtT/3jucTBQ7Sh/XjaTLMe+AhtMeVVWl0z4BAyqmSn/MkGGry
	 Vb1FP+3dHuFSQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: ryncsn@gmail.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	chenridong@huaweicloud.com,
	chrisl@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	kaleshsingh@google.com,
	laoar.shao@gmail.com,
	lenohou@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@google.com,
	surenb@google.com,
	vernon2gm@gmail.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	yuzhao@google.com,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
Date: Sun, 26 Apr 2026 04:57:59 +0800
Message-Id: <20260425205759.1701-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAMgjq7DM6Sd5EYx=PLtYHBYk6gAPFupYg2a7nib2KrGBO=HtGw@mail.gmail.com>
References: <CAMgjq7DM6Sd5EYx=PLtYHBYk6gAPFupYg2a7nib2KrGBO=HtGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xs61chxyfwrwcrnatbgdinzuwgoezg7o
X-Rspam-User: 
X-Rspamd-Queue-Id: CE3AC80009
X-Rspamd-Server: rspam07
X-HE-Tag: 1777150688-599430
X-HE-Meta: U2FsdGVkX1+s+5KUzMNMuA9GSfAf+4s5zTpEdpyhJmfyOVBK7I+84X7uOX/cOUnQx5RQ8tUDjMBKtarWj+K4oTVqqqNeWNEXcRzfaRFE3cbaSbMRWv/YrBg1RhLFORoYi/i9VdCrT5DwIxG4KfelzWWq68oSEvv18Trec8K3SQeSGWyEzfeLHaz4LmwEovcD4Y9kLxTcdM8LbNxc0Br1k3z9I33czikZbeRSKeddHH21JXEH0gmjHC8AtFk02kCURPU5g0mgUE1cgQITlo0z2bFc8BgOjVcvbabkQ9hIB5LFMomLsjnq0mHxYJMu1qfgemj4l2ljThB7rp1MAl5+72aAZZpwMxmEVTPuC0Xac/78nsTP9+B7XpFyYQDTMBtTmVZXHMIAmINq16MdwT8t3dYVk3sRliFuPiY8WmCRVTEOKKgWuLqLoekLJeyVh4ju4kYJLUF4N6631wFV2M4I5cDFm2jseFVamAWeumdkFEyt169+mMU46ZC3VJ+Hl3oe22bLmZ99JqVTdVtZcdwUtPE+rSeM/mHf2tVtqWsszs+PQyyqB+FVeW7wGJyWehx/9FZ1YGg8R2FPEzXBX/XcNtL7i1FOC+HRZsi/grd6j2BM0/EQYWQJIydikoVqQbuPUu++SnFNOoQHVc2cLrPz4XPxs++lM3x16EplrXhz5M2LRvD7tsHRaHzvNkKx3ABLyffOTwO/HBmVWAzX4c/RUfdNVewgqYeKSPrdq61CZixh2Y2YqoEksbs4aE4KbEU1bUU5mS3tu560VmGMeA/LFkaDyXhL6crAnhuaXx0LWcGNuu9Qk7qucP7bXwxUBvhgmQ+IW4X5vWxlVDCzX+T4dES7n5Cku4mHKZrxoHIVolvsp/GJ3x8AckKVX7oWLncIhUvbk8z2JKZvana8sMO05Hua9Pr6LPKYVAq0kUzgppI7oPs9A3e1Bh7wCFH06jAcHlQyNYaXJtcYAT1P8Pg
 yDTK70fU
 Td0IoOCrR9WJn1WHhsmQNuApyv/xcA7tbSkT+tVb/GIqeFzaoxQLXyRoZ7HvaX7qKSDHrrelswYU9ayZz71g9upPYtvh3qxOJmffE1UcqJF3KsyM4fn2ezh/lwKQq8n4yePyBacgZ16nWcwZBQ8ukRT8Ks8s8+o4PWLF2eKJpY/82NiZlmZ36B7pXgB2Vs8ZXbeiVoNi/7P2ghKrVP3+uKlOsb45h4zeJ+LhrSwrgtlFVFE6OtjhdTQ6kbsyya/u8NkdZMtK7zWnJve4U+tTBx4NA6D34u2QfOedSyu1UQ4wUitJEls07rLd5yawWVctnbDJUD7v/z5I3UAD+Qjb4GbnsMVoO8YW+3DtYun5GlfWy4+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 9:30 PM Kairui Song <ryncsn@gmail.com> wrote:
[...]
>
> I just ran a matrix of for kernels (mainline, mm-new HEAD, before this
> series, after this series) X 3 different memcg configs (-j96 3G, -j48
> 2G, -j24 1G), and none of these showed any regression but all
> improvement. That's really odd.
>
> One possibility is that I removed the:
>
> if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS >
> lrugen->max_seq)
>     scanned = 0;
>
> Which will make the reclaim loop go further and trigger aging.
> Previously if reclaim drained the LRU's cold gens, it may go reclaim
> slab instead. So idle inodes will be dropped with the mapping and
> reclaim more file, and we won't see any refault data from that since
> the mapping itself is gone. Sys will be lower too, as IO isn't counted
> as sys. Checking your data, despite sys is higher, real is acutually
> lower, which matches my guess.
>
> Will the following patch help? I'm not sure if this is the problem,
> but this added back that early abort, personally I don't think this
> really makes much sense as it's more like a workaround for other
> issues, but if that helps we might better keep it.

Hi Kairui, after five hours of sleep I’m feeling much more
refreshed and should have identified the issue. I think the
problem will be clear once you look at the patch below.
Feel free to include it in the new version if you find it
helpful.

From e3a0b50dc53a3a5f2ef1adfb73111336e3c2d08b Mon Sep 17 00:00:00 2001
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Date: Sun, 26 Apr 2026 08:34:21 +1200
Subject: [PATCH] mm/mglru: Avoid falling back to another type when
 scan_folios() leaves no remaining pages

While remaining reaches 0 in scan_folios(), we quickly fall back
to the other type in isolate_folios(). This is incorrect, as the
current type may still have sufficient folios. Falling back can
undermine the positive_ctrl_err() result from get_type_to_scan(),
which is derived from swappiness.

A simple fix is to continue scanning this type for another round.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ef45f3a4aa38..169fbbe17c7b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4788,8 +4788,13 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
-- 
2.34.1

Thanks
Barry

