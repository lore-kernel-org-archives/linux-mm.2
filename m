Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7641A606D804
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DaKkO9ZN
Received: by kanga.kvack.org (Postfix)
	id 8B4766B05B2; Fri,  6 Nov 2026 09:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BDA6B05B4; Fri,  6 Nov 2026 09:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8CE6B05BB; Fri,  6 Nov 2026 09:00:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55C646B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:00:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEFD4160D86
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:00:04 +0000 (UTC)
X-FDA: 85404853128.21.B4321B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 159B010000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:00:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DaKkO9ZN;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eexjMTFN7v7lg4Z4c2OJF+aW3LZ2WWO1iLxRzvA3R5o=;
	b=RsdaUS5EmPzC39tuzC421VcHeofz6nLptw9s9O3o6HfhSzF2IE9n8UMUsAvkI/lg8siTvc
	fQwTSl5yrXsMyRcJDyYQMCiSofwdMDTGvOxwDBE5uWfvJ258+N8q419SxjtBeqZ7J6PMQ0
	UEreUnjVr5ew5Oy02jF4nN/xumQHv8M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973603;
	b=POhuMrIMTEmE5f9jwQgsZkxeARJOHTmq+g4NVlPzk1VBNxhKN8oV5NdVdYoOkpt92VMNFY
	XNMdGMUm8ELB9j5zQ+Dn3oZh/nlAWwwxyT2xl526hcGu51uuhSHn5Blu/36v5j2aA5LfHh
	NFdYXzDWZfBlMuUdeDkEP0Z6yDfEpX8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DaKkO9ZN;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A1B5415AE;
	Fri,  6 Nov 2026 14:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FA51F008A2;
	Fri,  6 Nov 2026 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793973602;
	bh=eexjMTFN7v7lg4Z4c2OJF+aW3LZ2WWO1iLxRzvA3R5o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DaKkO9ZNM+Q0qufgnjGc4HJfMAHod8W7cPvk/BoWGONZIPuWWC1VI7wa0izsehCYp
	 y1M2i3BDf3U7weGU+sACcf9bWpVy1Kla6JDrKBATOxNs+GKYNXiomVng22LHQOwg1i
	 QAKaGHCAPXovJRH6hg+9dR3n9GeXmUrRpidhEBeg0RbQfg8jOFO3+Sp4YADVSSIhbL
	 d9w2cAutD+eeTskAXRDelnjVGyJKJKXCaUtkJ2cJ0fAjjBUmSCoLS3PD4mkscVTnM8
	 5mDbKPlvw0+JnDylvP3Iv0s9VXZwUb7KUPo4pKpTfHPLzJRPnCSBr7oevSCfCOp37b
	 0b6GZSWCT9wmg==
From: David Hildenbrand <david@kernel.org>
To: akpm@linux-foundation.org, david@kernel.org, 
 Song Hu <husong@kylinos.cn>
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
 apopple@nvidia.com, willy@infradead.org, shivankg@amd.com, 
 ridong.chen@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261104044313.2099309-1-husong@kylinos.cn>
References: <20261104044313.2099309-1-husong@kylinos.cn>
Subject: Re: [PATCH] mm/migrate: don't move memcg NR_FILE_PAGES for
 swapcache
Message-Id: <179397359780.3625.7399143861133982340.b4-ty@b4>
Date: Fri, 06 Nov 2026 14:59:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: rs4c444uu9cqikkmue96f9ztpgfnqkzw
X-Rspamd-Queue-Id: 159B010000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793973602-442536
X-HE-Meta: U2FsdGVkX1+nErecIapi80vvc5nx5CFGgJ92IZsvPh79aUbXQ7pZReSPdx3KzhuPnn2RZ9m7VHDSP5c9xgPY3OoafPKlHV+4fKIdTIcs70JEE4zPgyPNqSjO0VbAmjacmLefsTL2/xbUgiKvCk3fxU+l9KW034wtWFBqIPBthQD3FcKJPtJIsgB/0IM4WHy/sDm3qCoAtOBDYJxlV+r/b9rXULAUs49nwX4Y+sZk+e76tCx1hbPR2VvzKNEdoz04tuJbgmDN20OhqEmMyOglbkmiKAaTU7PxdTEpAVVGKhlwMuIxlD0fc6/w151RFq/1FON70eORBDbh19ADDDBrTBIA4u7N6ecDiRODAmXlRnGPnxhRiWtfzlDmLkt5XqPQrMUe3oRAT7B9OCpZGOHBPe34dBl9PJUiF54XcSiISV6mVysiNj9O5lWi6FkUCGdjmUhX6ncaRUBxTM5M1exUMndtmySxqIvYealcok6CT7gL1lEezGFc/1qUl9k6/7gGKNoJKUYrUt5/NtevK/H+1Z13YHbckfjTZL5BotCSDFIwFC79+lwB5jGyD5/PL4sfwmdn9iyA0G9BJXhjkIVLXVjb2jsJIeUBwgRcNPUnog08cHXSs1lhdlduf2btxDAMy1mcOjr5YwWWAOxgxeXW8u7NYmyR9YoCBzY3dRlcHX+mzwRKH0CQZbz8bhLcdsDAB9PCN13oo2nYSq704/Z3CV9tUZcl7H36X4X+jX4PvpUasB29lT4LB4IegQWfAWmExEmIN8X+oAZFNiWrDx/1hsOjEV2717JR4zhhJfq0v1WdTc6ZMl8p6H0JDZGibEnStEsqRu5vvQtwBV0eHlcujvFvBSzA58ixF+PceobdOjEoLDwrJ4D3bPQMOrkJiLe3Hu1ytEI/fNtw9M8xTvO4Ua0MnGZ2v6N5MZ24lL+LCoTh61I9gOTxXVY2Jm2JE+KPspRqGRlcnyBORZyLtNQ
 oQi2U+jk
 m5JXXGX6w4kPQZciLoKayaN1lXK6+o5XuFIND/JgohscvOWDcppHMK57ev/ytPPYQn6cHJ2pcX/DvyHKqDKOxDezIxeBsydmRsR0yBjrQAc4XjbofjjhSwJurNwREgZjl61WvSEgGLLPooRRWhArs6CsX+8lhCRSYdPo5WHt1vvK/rdDoZmjHotmVIno6mEFacUp1eCaFCDy/umhaoUNp/Y0modHMBEVuRtawqOIw4xbqeu5r8NAA3bjbU/kZ1sGIHeQPFwMSi8tD2oqBUlIq5sKPhs87l9M7P5muBD+FPqK8VbhkcntjoZvnKb5UadVwrTDVcA3Gb+kGRnOcWtq9udFF6xfABTTAruBvNGpto1fRzFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 12:43:12 +0800, Song Hu wrote:
> NR_FILE_PAGES lives on both the node and the memcg plane for page
> cache folios: filemap_add_folio() and filemap_unaccount_folio() charge
> it to the folio's node and memcg, while __swap_cache_add_folio() and
> __swap_cache_del_folio() maintain the node plane of NR_FILE_PAGES and
> the memcg plane of NR_SWAPCACHE.  A folio in the swap cache therefore
> carries no per-memcg NR_FILE_PAGES count: shmem folios drop their
> memcg file accounting when swapped out, and anon folios never had any.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/migrate: don't move memcg NR_FILE_PAGES for swapcache
      https://git.kernel.org/mm/core/c/ecf439e4

-- 
Cheers,

David


