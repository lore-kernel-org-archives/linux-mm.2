Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8BF606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 01:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WizpStaM
Received: by kanga.kvack.org (Postfix)
	id 9E2996B08C6; Tue, 24 Nov 2026 20:41:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993076B08C7; Tue, 24 Nov 2026 20:41:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A186B08C8; Tue, 24 Nov 2026 20:41:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3BB6B08C6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:41:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC127A0DCF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:41:47 +0000 (UTC)
X-FDA: 85471939854.11.A6DFE73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F1F2140003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:41:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WizpStaM;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795570906;
	b=TpkCC22jDmV5ve070iCLhWN9cQ/CDu56KcZ+/Ns8CN82iLrR6X+fuXcHB30dl8AUoCjQZw
	JrAJkcogH5JwUiEtfULoz3EhjV+LJ5XQNfub0B0GEZ394m2EtslqVF78VQjTVh+sL/pfNn
	1kxVfjTIiyNmHov4iJA9Bmv+ZCiuhzQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795570906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uALuexdmM829eAKCCxuAtcwAcX/KrdDY7PYwPZUEDc=;
	b=HLuWoESxqIuXdIfnXS+0zVhlinn0SiyuBe0kAJ6qLzQc20Ag7Pz58lb+0IVn8SCkbOVHqI
	sspn/4T+VO64RLrTbR+Qyq8nlZpUurcR3352gmLs2iI7okRcEsEZL78DMr0P3r7ugpNr45
	WJD/xlXvWBAso2Q6Bzm586nNoW1Fv/M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WizpStaM;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBBEB61DB8;
	Wed, 25 Nov 2026 01:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD771F000CF;
	Wed, 25 Nov 2026 01:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795570905;
	bh=0uALuexdmM829eAKCCxuAtcwAcX/KrdDY7PYwPZUEDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WizpStaM3pGyZ6aLPTA550frhN/LMtmfDktlk+ZzOz3iB/9QelKkTsH5MLGmLaUyP
	 itQsUN01OJ9EVXPsKFeHuxpI5NnkAeYhBtSez1PS1p7Z1NX7XTCCaakFGK4NSA08tY
	 haGL3bYL4fcmhiMEC+HRMV81GPTlCSor6X8StVGmwxfgythZ08KTWin9PirR7hhgiP
	 B2y6WpUhkadSTyg+rx2gedv/bEQQl+PpRpG7HF5KRmxbSbqUmQV4CliTMBMbZFrU0W
	 /84p1tYb2cgSHsqFS+vPiDXu+86RBRidyrB1S3LMydHmZdLi/C3eUyycB0ue/bZzEX
	 cGp0LT/HvtDFA==
From: SJ Park <sj@kernel.org>
To: Kairui Song <kasong@tencent.com>
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
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 03/18] mm/memcontrol: avoid potential counter leak when reparenting local stats
Date: Tue, 24 Nov 2026 17:41:36 -0800
Message-ID: <20261125014136.98425-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kqyrnkjutoz9z8onedz4ufzft5z1efy5
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F1F2140003
X-HE-Tag: 1795570906-704306
X-HE-Meta: U2FsdGVkX1/sCB//GEX8aN8uTrHQG8JXnapMUMLJ8icQIRoAc5tOcKChWcSQKRi8Nqq8RJu8Igyrj8NpR3HM709dCw7+GsFiTA9Oek+c7YIMUIzCn15kBYSTaH9ic//ABMTMnXysdKMCFdKS5wmNYmn0P+GvZniwWxUJr2QMpwgegp2Oo+LbAQWteVcjLOfUNrn1L31nlf+eaG8cNF8pvQajMpPkNVWnPP4h3phexACwiXfb8n0jTTi1UgrKmd1vR0FAU2aHXTsOCKfbhcHbormeES98lxw/mMngPLHCUzG+4c1TMoigZK3yYz76AGOT8RFivTcQ9FOinLYibeliXyHkJTXrp3N3SeuFU6g/IlJA1WCLLbasyDWKUxbV9oSHN/E/I8aF+bFh6k4MLKBjlXfd1pTjr/6zsMtBfN+5/wm0nJLL9Sn0lVWO2HwVaNIod/OnGJuYPiuiAtraMbn6Z6sG+3D+GQNVFCsAHpJuF+cShugSlsuEBIYbBrWz4GJaY4L6goPoQHMnjgZgufLxBf/RVQJhjThxCOl6ueXiDxafT+E/ji7aAUlwgJchfZLvMBBORqu5bScW3RXZybk18t234rEqEsjdE2LFao80jJFiHelrT1a1cDz0QoQe67wwrzsFKO55lIBOtdzHw5UeptHv57iE0PZUSHPKPLKNA/nNOilM94orZ7LTnRBF1iUbtcZqmm2tRpsOWmYvfwKwF59Jn0OdiTseeZZv3YGFLXt98jHak3TsQoE+2DHWQwYAWzoG/9u+VBB0W8hj0yyEDRCyuaoxBR5eYF7JchVszlgg22Dl8OvWDATYSZcGJOaJ/43LzjDvhSYqf2weEguY8Hg8X3FCHmxpCv34SeUSGQc6x35jSQK83YO59X3IEnPG/7iEix5icOWiO0JjF3FEFRy3F0iq0kyWxzKQ1YJCovH/w88i3fn5T99stlD4sIt9BJx/r0/2FihxO9nst0q
 bdeyv/po
 uBkOvgZm6i6RBAGhGRdPEocs62Svp4yiSIXDBSuJGc0/qCLnXs8SKYFYFBKhQh3zkWAE2xjqlgX5Y5PDViKy/GD8kPR8pLRFoWA1bZytt1Q6m9UbBPvY4vtVj/m0qtKCDO3D9JwktHpq6emDO0yjgYOV9zmuoEBCxj3IhIv6+PpfkvopWZMouy9rQYK+OnD0ywEFlUNcIyyDrSUQ0iGfsATfPveH2vq1KHo+mts0UQXlarTU/Gl5qox6TRazbXfFqxkjGLgTjYE8fAODWOneRmsTf1sq+toewBz233BYQ9S2sQjBT5nuJrdZ5hXWkovvUeuAcwtXa+pwt/exYW6+j+i085gNQwx6AQRYXaPGMVKER8s/5p4TK8Vf00bzp1MrREKK28k03RC7I52MGmKnmaFGECY0t61UHURsR3EQfK8U2O7bdWgcD1pc43AkPHnsY6g54n1QnXJdXWTucc59necQ+Q2+xa4C/fDWlD1qVhKPm4bDqOPnIFfTF4D1IwU8OVp3f4RFfjCWCgcziMYvrhcmgPgOSjv+i6eBAZaLOquqU9u4vZ+pT5tLZSteBSaSu64md89nPf0agvwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 02:52:55 +0800 Kairui Song <kasong@tencent.com> wrote:

> lruvec_page_state_local() clamps negative values to zero on SMP.  That
> is right for readers reporting page counts, but can be wrong for
> reparenting once MGLRU updates the counters without the lruvec lock.
> 
> Reparenting runs after the forced stats flush, so a negative is a real
> balance that has to move to the parent, not be discarded. We will
> introduce lockless MGLRU promotion which may cause following problem:
> 
>  1. A refs CAS on a folio on the child's lruvec moves it from
>     inactive to active, and its active/inactive counter update follows
>     as a separate step.
> 
>  2. A concurrent isolation of the folio reads the folio as active,
>     debits the child's NR_ACTIVE_* by delta before CSS_DYING is visible
>     to it.
> 
>  3. The child is killed, and the two __update_lru_size() calls from
>     step 1 land on the parent: NR_INACTIVE_* -delta, then NR_ACTIVE_*
>     +delta.
> 
> The child is left with NR_ACTIVE_* -delta while the parent holds the
> matching +delta, and reparenting the child's raw value is what cancels
> the parent's credit.  However, if the child happens to hold few enough
> folios for that counter to be negative, lruvec_page_state_local() clamps
> the child's negative to zero, which drops the debit instead, so the
> parent keeps NR_ACTIVE_* overcounted by delta, and its active + inactive
> total overcounted as well, permanently: the child's local counters are
> gone once reparenting is done.
> 
> So use a raw signed helper and reparent with that.  Ordinary readers
> still keep the clamp.

Makes sense to me.

> 
> Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com/
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

