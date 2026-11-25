Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A919606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 01:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQ+GX78V
Received: by kanga.kvack.org (Postfix)
	id 467C16B08C2; Tue, 24 Nov 2026 20:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FF36B08C3; Tue, 24 Nov 2026 20:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F296B08C4; Tue, 24 Nov 2026 20:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF836B08C2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:26:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86F13C0D5E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:26:09 +0000 (UTC)
X-FDA: 85471900458.21.D53E9C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id EEAA3C000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:26:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQ+GX78V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795569968;
	b=od99JPD24CadTz8LYJ2LUY+XItYRme6GNCP8XEQIkiGqGWzR0Im4bv76kqiYOlWLwl4u5t
	cqmOD7VaQFc48L5pEykRgJljvgjpUZ1taxN3UUaQbE3NGa5jZIGPK6ZQKyuv9YgKV6VVkN
	4zOdf2mpZFHf5h1X5GFvEoJMhWz5siA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795569968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ca3B9Vvi6+90qx4u9Sp1DXWE1+uVNN4yzp9+O5Q2YIs=;
	b=5rf/Dy9uVJQh/oLjLWVg64o5AviBUx217B141CBQXFGG4VuMApDHR3F/YQA5sUnxbF59x6
	Fk/V5jMybaEFZ3+ezfI9Fm9j3CjcKjzxwImswZIsuSoGynbqzpItp5WPkla8jkNjBosmcn
	cWYjJ2qKcdOC7rKdb1Qb7SW0kGoHLjQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQ+GX78V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5217B600B1;
	Wed, 25 Nov 2026 01:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D6B1F000C6;
	Wed, 25 Nov 2026 01:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795569967;
	bh=Ca3B9Vvi6+90qx4u9Sp1DXWE1+uVNN4yzp9+O5Q2YIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQ+GX78VKftJ6+id7UodYIJVWt0mLOwYTL+d/5FUAfPlDVbAfxmLIdg74hMbpoT9A
	 qMASA0BppbiZBYE6BmaS441yhU2m7bViO3tuhrklReMv1XIrnAaAlDJgGNBKQYY1sN
	 j3WxIaMwitlY3uyl8ziV6MaUD8lIEJLChB3uP6+mbI2Mtg8GRodlirFdOOYH5yVKlU
	 1X913VYCj42FXa4OS7y0H2qP2ZFNkiOG1ZFhzSMhFTAk8hV/VIEqU2+unCXJTZBxN6
	 wzdqDIb/f5BYWCtK6UNW5RduhBRF1ScAN3blsgfmikp7PfnMx1qSjB/LMh2Z8ppaIb
	 BPNSW7eGhWylA==
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
Subject: Re: [PATCH v6 01/18] mm/mglru: rename the generation offset in lru_gen_folio_seq()
Date: Tue, 24 Nov 2026 17:25:57 -0800
Message-ID: <20261125012558.98032-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124-mglru-fg-v6-1-8ffea39934a6@tencent.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: du845uwr71p6bak4hi4htemrx6zpoax3
X-Rspamd-Queue-Id: EEAA3C000E
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795569967-167627
X-HE-Meta: U2FsdGVkX1+9NPZR2+fW0sBMxU3cChg9F50UnIy5c7OhLAuPV6zgO5bfUsFhi8I3STZdQ1fVAsUggd6oegFTObqjme8de6qq9TFNGEt299txOsBb1JAKPpfOOiPH/u7fwiDmfmcLpky2DcPXMdh+zIeKGLRIOR9zEXqDV5sLJafYKIqFOKaYIIcvquaYKkegI+juQhXP5kdEcLECQOTFs26AHg+rON1h/iQ+iEcPevYs/DHAums4OIR1OLqKydNvH92XJ8ypOyAIWukRkdEf3D/eB/qlAebG8/TXtzVJoxVEvZRt50RSk8iiR02WBZN6jGArLA/iAdnrrqLtqiPXNC8ycX71TwCH/iMo/pNZw601SbMsGuzvntt8va01y6lBfDfGEFxg2AEbktAvasF4mcwMMOcdb9oIfBECpsRm9Aq8kiBAbp4aXYBhj9MeCSGypeLo02TsElKq6/y5Q0/nls3gSfcue9fevTRz3brLEByJG7Ea7FEGIEoruYxHXxziWkQNgo3DJ7m5kKYyjPZ8ahhecM8Z2+00CVaWv4dKeuKoh08/CACvWytTynEHBO6jVQTD9gK+ObNt9g5vVZDeufSw0Qm1GQykTIYmLaGedjiSmKrg7/KZ65C8z+c0yG5y4t/iFocKfGHBonqRfYIgkhfJQ0udhGODZ1oCGLx/Q6QwZsmJCWp/xW3zUz+LFiTEcAtHNZG8DuQUculDYQ+hqZvhEjlt8eqGWm1B9FS0zHZq5MK2GQ19PXL+MxP1RamPAoRMxAnrEm6ifj9IzozT7b8kiTeJk012EM6cdYDJOCeHh7OlXwYy0UF/a7NmHop5MCwOHvqXq7X3arSLiwaq6RamDoXfWvOQgsvDWOdc5SOAo+Db8oibeKqQG3OF42QB12R94HP8Y/89LmKMRrAEOh4sS2NPwm5cibrQy5k1soz5JvC0wcjUhqMF0eHkt/cZVm5fAtgoLJT7FrYsz7q
 mqOa0kF4
 LzJkJ8XC++Givxmrrd8V2iIW28eNF6lOlVLzKsOsLR6V+pivsMN69VdSaqUZA8tV/7IaoH9XjqTwVF5AeWUB3Wvz2RBq4IhZTqLvezQwHX3vDB8n2SlAk2mEZjHONBL6dO/S56Dz08aStkNoUHPJQg1fAT7QVrzIdJCwwFMxYiwkG3OcnNPu/RTqoTO3k/4jPFcEkvmjqIQhaecYlLSWoTCp3GpAl9w8qQza8VaTYV3DXA2b+ZYxNHNXTdc5gNEBUwz7NjcEi2txfAub3M8Uc+gZ2WZQbpqWb3XVYajGWoobmgOEmmNs0sMo2p1TAt3H0zyFAKFdzyO29vSA53aQuTABEOBig9PAWF43JxXX766vazycqDlAVfQA2F+MyQMTvKkNpZ2O6WZbEoueGSjx4MLyEoFX4EnY6LATYJOQ4dQxGTc1F92JhCivYpbaIP4bw7oVJFGzSQx56DgNTj2+fiBwxGEg44ohkfukny+0haalkWMldjUT4oJCSnHbOEylNhUdAr5y1f1X/pBvot3whESrV79BNolEAmIfKMRAteCZN+eLX/MqaHD67HT8dmjCsTQTvvO7fIMXYdn/Z4xYpZ7LihjfQXFCJS32TR3pDro3AM1YsBnUW/uBBr3U4TkyhOCAZy+DwEDcj60fRhBbJCfxnXsqCrjxJnSE03u7YK8dljV/xwsy5O+SaoywF5zUhpKnS1ejCS5SYGqoL9CFXanpg5OBoCMaHSz27i5/oAF9RlS5b0vNmzcz3dWFku2eyY7ia
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 02:52:53 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
> 
> lru_gen_folio_seq() computes how many generations below max_seq a folio
> should be added to, but stores it in a variable named "gen". Elsewhere in
> MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
> so reusing the name for a relative offset is confusing.
> 
> Rename it to "age", which matches what the value means: the newest
> generation is age 1, and a larger age is an older generation.
> 
> No functional change.

Looks good to me.

> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> [kasong: dropped the comment table part, the series rewrites it]
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

