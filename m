Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9EC606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 01:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUrEpXVA
Received: by kanga.kvack.org (Postfix)
	id 81F716B08C4; Tue, 24 Nov 2026 20:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6686B08C5; Tue, 24 Nov 2026 20:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF2E6B08C6; Tue, 24 Nov 2026 20:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 400396B08C4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:32:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C7E6C0D64
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:32:20 +0000 (UTC)
X-FDA: 85471916040.18.17DBB59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8163E4000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:32:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AUrEpXVA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795570338;
	b=GE7SxtDOLUwQ+UoUHFfFKgfasRBUb+0PZSB1c6K4C1/22+bwwRQesZTawf6WYihJ0fSFyI
	a9IQQHMW77jzTk0PuHt8MkRM7eCqQR+KiKKgqa8vT3nlgH0t2VrPgSqkEhSw+0JqDd9ORm
	Tx7Xl/SS/FGuF91WTjE9zpaGirSlLiU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795570338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=og5FI6XPTPwFhyPH6I0WYk7eOtsOgs0wLbpVaIplXks=;
	b=AAWM2uKvXtZb2AIiwgkEC9AqritGqJ0jtAHTm8qW6mOcjK+6lAa/0D/YG5Vd5CAfl2GOWm
	9RLPi6oTKbUXcqitYQl0gUw2L1dXGC78fqUoyGacFvFiuNzPrAHj0fCmAe2GdfQN6jF2cB
	0UQx8hK2dVYifcSApAqz4B1s7LtZjiw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AUrEpXVA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2A20602C5;
	Wed, 25 Nov 2026 01:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4D91F000CA;
	Wed, 25 Nov 2026 01:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795570337;
	bh=og5FI6XPTPwFhyPH6I0WYk7eOtsOgs0wLbpVaIplXks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUrEpXVAjM8bz2I2DWmDW2a2h7J84X+Q58Pkdgk4IdFrP8XGgwZcEnJBoy1LsUTiY
	 AMz4FUNqo5EpmLOZiikYpnpe6t96aHKMh4sQSuXJZcYPUGhFLTTgXemKdOiLVVDcr2
	 QmfEORqou1gCEsegiiOo7JrLL3NfHUybgf+bXhhe7T/1xN3HI4vzGa5G5QgFo1G9LH
	 dR1zjSrZfeY0WAOtxikEDFS8P2pYEK94IDviO9sMC372CSoYrdp9J793W2ByKcrSKq
	 NyESCGqoPviJQLWp0Yfyy3bdfISde/0fW1yWjKY5bdYnjWeWFG0Z4LKpGMNyG4Qo4s
	 qssgyk+G1rX+w==
From: SJ Park <sj@kernel.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	Maxim Muzafarov <maxmuzaf@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	Tianyi Chen <hi@tychen.cc>,
	Kairui Song <kasong@tencent.com>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic without holding LRU lock
Date: Tue, 24 Nov 2026 17:32:07 -0800
Message-ID: <20261125013208.98216-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8163E4000A
X-Stat-Signature: rs4cxdmg7gbbokw1sy84miu38ab67sp6
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795570338-940531
X-HE-Meta: U2FsdGVkX1/l2Cku3n+GRAM8VjIlP3FpR0TkgV4Z18mY4ZDfdxjErvgnReZD0asaYE3R6xIOjgkVwYYtSTj0GIwERAK7a/Nb/f0YSIq8Ck8TASVhe2i8f5Dfi8EtZQ5RnxzV2WeQ3DKbcsifQkbtycp57VGVa7/99qLLRk39i4VJ6Guy6oQ7L1ACfXvtNrKfTnbXkD9WG1pXZDZBWE/9VOHzU2tIWMm//viFA0jRPKPw3+xEKNRwRvu+/fDwkia211CHvxeU4lfvK5GL9bO0Lqm/xHak/2cAnZ59OdselfZWywnzO+kV/qLtK2zbB+zeV4JrXdoHfWPKfmey3GwuiojEXKy+65feN5yO7GXNktxr+MOaEEJEGb/A0nApnX70YQ2DcEf+oYX2pRKGNW8OqAdM+BOHvkEjUzyVam+aFPe+4UFrD4x4YYhwBpstcss7EI9xmiYVdAw3HO9JiuvBWD/AEsNaABp67q56EYLy2e/AOGGKnnFKL4JQ2WrksUPqkkjW6JPdjNsREN+HaiuiQdgQW9B6PsGQeGhti9Mm1sSWBXQt5wzrbcJplUOLsPuiehxPJy+ukhyn8FR8VQupcaBC1bkNAK+o1orLL7uELddDwar/6IkThCzAvyvsNqtE/veHHWRg3D/6B9R+eXSto0LafR/rGEypI6mFPZCszbn/+rn9jiS6ZgSpqfbTlnMzURacBHBAqdbS7k+x96GxIMoJa9DvWFpbhtFz78W1+YREsWKU+bUf9ShLLSpQu43qvV+LMvsuSoO008TaOah48Je5ppqKT5l2FTDXYikCVZtR3umuFsYpC/qfUWBx/0ewDh144h2krQ77yYvWxpgq7cuwnWY4p+OYwHegC8LjkhSWvZ49Iw20tJp/YyErX/7zeKTVaxLFP9FOHZ4rCjBJQILO7gNcegLis/OCS2mSsoz5NBnqqIfC5J33CyK7CErAuNWfzWnFUxT94AKE0St
 c4Tmm+UE
 2kGv5qBRg4gYkQ5gj5JDflSAgLICxHO5H5SiCvm0XUh+5Qz9c6wM7ruCcvlTpVyRUt9TtQFQ5XnFhf93z+hMpej5KiNHcCO0mKkrf5o9KEgQMKWTTTGIsDEbjMH76nNnq6W5awzIPlJX45Wy5UTrNjuT/yycRKSdZoJ+32gT5LqiivEDll1Sk/pNoz87pgptvc0b+k8i5Xr+3TgfJ52eUOUJIkIdWW0i5ze2yLLSiM9Kopo5BynnWqbVJyQZ/9iJ3juCa/2v03XJfisQhjXDhXy/lun0uRQSPl9cFDGNuUGOsJqVFVlpq2hTU4FfHJr163cA75nHCV849KOhnX8VtDhYugwmyzRb4tx1mEP9weBnb6tSHGoyY0GOCikoe74JJ7fKWnjnB904lSGeDLK7T7yBPJOudvyCYoETbXGERHFdKx8kLIz7JeM6m96X1UEYcT3WpfPCcCu7N24ek0o3xS9+nVhL4X9CTrJIyZ3A3bKxXmb8YBGwsBouC6QpqtHpqmEFdFuT+NEuAw6hWohjblV0hOvLH2K/NmR8WW4lKxgh1r+JPXPYTO34I2Yto1xz0a2WOFRkWgStsJoq3o4tig6emIItjwzIbf2vhhE6eR1yNhdGsebMn3Wk8pvPkeroQAnF8zOjHvqwKKIJqS7stVoXuwk6z+iwSHMMkKQiuYvMbxscKsVfRLPbN3kPPgzI0//5W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 02:52:54 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.

Makes sense to me.

> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

