Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE45606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 22:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mf0H8n6l
Received: by kanga.kvack.org (Postfix)
	id C44F36B05B2; Fri, 30 Oct 2026 18:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE7C6B05B3; Fri, 30 Oct 2026 18:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96416B05B4; Fri, 30 Oct 2026 18:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 819CC6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:32:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECBC58081C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:32:20 +0000 (UTC)
X-FDA: 85380742440.13.2D2D832
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 41386120002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:32:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mf0H8n6l;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793399539;
	b=3YUovkRL1IsczSLn7/n0vwyCZqYj6jlgd1UjWUsGUPOjHItEydzJARwv+e56mHwAEvNCaQ
	KAKu68vzgn0DleJeUKHM2PfoLveBER3peJodiOk61B7vmPrlq40Iv3Vjf2i5cPOWoBd5e/
	wq6Tv15saTV5JTheirnf6O2bveW4gEU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mf0H8n6l;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793399539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMD12ToJn0xQB7xf6U5d1DnCbzAwSTm27dnDbxjC75U=;
	b=c3vXEf8BbBT/GXVLdd0Xwn82SwXI9NtphbKTulOFRE2B7wQzH+ZwrAA6r9pvwZuVCkNNYG
	0hsYMxtNiOFN14kkO+VfO8hFNyK1qwQq/ZfWF9wmuoK4rpZUndKcHxd7fD6VA+QCgplkhb
	kMoBY8iGYzA94DSw6pn3qkGbbWBR7ys=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97E4F41397;
	Fri, 30 Oct 2026 22:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1E91F000C1;
	Fri, 30 Oct 2026 22:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793399537;
	bh=EMD12ToJn0xQB7xf6U5d1DnCbzAwSTm27dnDbxjC75U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mf0H8n6lDxMhaiGf9PwQ7zbyb01Yn05om7wGAds4CS3+MqKH5s1FEk5dJk3GW1wi5
	 WNX65VuIQ7KuWO0J8SSqxK5Yw/xsQvLe2CgpLeOB7ViCBRmiipuvudcMkwEhe/4FjR
	 Km/uK3MjJZ9pp+sni01ojDZVxWlze5nIkLUNl1hg8UilPWNP4L40YnA79WaQwLK67d
	 yuaSIXfOcXWy/cQC5Ym+7+o3xd8RP+8oasaUPt12k2uF27JYxcyTiG5B8+WOnCrnaL
	 REmulvJTA0NJ7hD7vJlcPkSjdKprjovBk5S9XenyVRElQ1N8sD71wKwXiPVrMQEZDQ
	 FO+hK1bDxu94A==
Date: Fri, 30 Oct 2026 22:32:15 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-new v1 2/2] mm: vmscan: skip anon folios zswap would
 refuse when writeback is off
Message-ID: <auUZPZfxNNBCH5uf@google.com>
References: <20261030095223.325309-1-jiayuan.chen@linux.dev>
 <20261030095223.325309-3-jiayuan.chen@linux.dev>
 <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
 <CAGsJ_4y52-hyd=JrPaX-isNWNFUfX30aLCgbsiCAFjxDzhYs8Q@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4y52-hyd=JrPaX-isNWNFUfX30aLCgbsiCAFjxDzhYs8Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 41386120002
X-Stat-Signature: ahur4gt4ioco6n1b8x5npudzwi94pbw9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793399539-881029
X-HE-Meta: U2FsdGVkX1/+s1S0O8nC7nBmC2AQ279a+U/es563EpKea0ycOoFCAuBnkuS5z07tVuSjw7RVAYR0ucnZru8xSvpKXTjPMxqcyU7JTlTQnv/y55dHG6QQquy0Np+q2zvr4YQ9Vv5TN9Dzh9nH5kJxJ9GdOv3ZfRT2+rHKsSBj9WmUSwdBcQU/tg2/dwpNbot/XpI5dMNtIhEFwJZ+2T/wLPI0JzrrnuErf9pFEQEgol+nZaeeNwcusMXW4WI+rIp7Tsvwz/zrpbYkQ4JHNuZzRByWQvN9EvS7Ao/oXnW1Ep9CP6QVP7TDgw0MvgChy7OhRVSHHMkUqLYg7XztWQaJo9M9kVdfuGsv9D1fYbCjXnRf40t+BIMC1duaTrBcsVysn6VPsMCN+KFhoWAoTkVfCFYpy7qdyXXFR+wZpgKb/X82/y3xpBV9P5WLomAbP1GE+bgLA4Uo5FrC+H0O1FawDfV8OCLpCZgg9KY/5tjIR87DG8YDAj5FB/CQZiZjfPsECy5CCJw8cMlKa/5m61hJduI5OKflP43j2aEpifoptAk7Spls62+jIRMBgmJiusUD14iV0qyifOMzuVqZA0R1B6RYdsYkY3YF5FOGANfG/fsbpnzp23VsUh231OmLmQvhgiD3/H46naNurqbPvo7m/N1JzATpJ0DXAITgoyu1z479iNlpfquI24LTmSmkLtc3UmHUqrpnUWO+PHNH2Yb9Tye5Gm35xpzz2z4qeiiTCRJaFjbzjzsIzD+Frcdu79Rv5e8Tf8ISo5RRHbFlY/J/CRyTx2GeKLGs819Q8rJXPV0ZaSIMNXa+LKoBzq4CAz/RSVvmePSgE+hg4UgFBCciPhZeGg/SQxdWeHt4Z4f787wfKyR4OyXnPwY/N6X/m5QF5L8cRGH6NbCHuuGRkz0dldkVvWE7rXDT17C/rIWExWA8PdH6IH34jeET0t23AXSrBP1x3zpPkUOYtFiVWdf
 7iSKCnCU
 XTWUkphb/gnUDhSbNoO/zlWvSl+haOp65U0hvsDDEc5BodxR8c8CcdE0/FSsWi5ehQ93mVY3O6/I6p9ZWZhHBEvY8TyVFbCfIQTVSzvy4VXBKdY2ck7TvSv2KUj7+qPrUGx2+Iblxv5T6PgWfOlbkQe/l/43F6tlBma8Ux6+Qjl1VRxKj3hExmUF4+e4+Y9NqLGbV9++K2kw8IQvUYr9gy0zFNpgRIjjcUyVyz59i3FUV5+wnnB+5wGVQ77baenr2WXObeGmEoGfoz7FOKHCY1cQ7uSOCtgrYa/l2tfgTNUdHHLYOaOpiKvggMkzlOcGVtDXj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 03:03:26AM +0800, Barry Song wrote:
> On Sat, Oct 31, 2026 at 1:52 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Fri, Oct 30, 2026 at 2:53 AM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> > >
> > > A memcg with memory.zswap.writeback=0 can only swap into zswap. Once
> > > zswap stops taking its pages, because the pool is at its limit or the
> > > memcg is at memory.zswap.max, swap_writeout() has nowhere to put a
> > > dirty folio and returns AOP_WRITEPAGE_ACTIVATE.
> > >
> > > shrink_folio_list() only learns that at the very end. Every folio it
> > > picks gets a swap slot, is unmapped, fails in swap_writeout() and goes
> > > back to the active list, to be aged and tried again. Each round costs
> > > a slot, an rmap walk, a TLB flush and a minor fault for the owner, and
> > > frees nothing. The folio also stays in the swap cache holding its slot.
> > >
> > > The obvious place for a zswap check is can_reclaim_anon_pages(), but
> > > it cannot go there. Zero-filled folios never reach zswap:
> > > swap_writeout() marks them in the swap table and returns before
> > > zswap_store() is called. They need no pool space, they are common, and
> > > a memcg-wide "no anon" decision would keep them in memory for as long
> > > as zswap is full. With zswap full they must still be reclaimable.
> >
> > I really wonder if we should revisit not swapping zero-filled pages at
> > all, and instead mapping them to the zero page read-only (and whatever
> > the equivalent for shmem could be), because yes, the right place is
> > can_reclaim_anon_pages(). I don't remember what happened to that
> > proposal, Usama do you remember?
> 
> Hi Yosry,
> 
> FYI, I recalled that we discussed something similar in this
> thread too:
> https://lore.kernel.org/linux-mm/20241212073711.82300-1-21cnbao@gmail.com/
> 
> It would be nice to see an implementation that maps
> zero-filled pages to the shared zero page.

Yeah I also found Usama's attempt and the complication that were found,
unfortunately it's not simple:

https://lore.kernel.org/linux-mm/20240604105950.1134192-1-usamaarif642@gmail.com/.

