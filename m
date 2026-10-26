Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71880606A339
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=JdL3NJqd;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=jsaKGria
Received: by kanga.kvack.org (Postfix)
	id 89F416B05B3; Mon, 26 Oct 2026 13:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8771A6B05B4; Mon, 26 Oct 2026 13:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C2D6B05B5; Mon, 26 Oct 2026 13:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 521126B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:49:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D50FF407E6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:49:46 +0000 (UTC)
X-FDA: 85365515172.22.E16BBD8
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf29.hostedemail.com (Postfix) with ESMTP id C2E30120004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:49:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J dL3NJq";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=jsaKGria;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxV5ov3c0hTKqd9UolE8DYnovGSmzcocUgKkmdnwh3k=;
	b=THoGVu5LMaV7wUTND0x5APwrPWQoKTxvynmF1nnrVmWgaISi1H14YcEMn7sBn1PWbXfoKC
	TjSZE3eLab03Pg8sB3oTvd+Bz26OWjYJH9zGDTN3bukW7Wwg1BUZTG16UZ4A845az8cNvR
	PxaNu1yJerYGXz/o7d8ArvCc5Oasj4E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J dL3NJq";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=jsaKGria;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036984;
	b=X+XR3Naw8LE6VKMEuIQF9urVSWaYgOpRqsnfVwAJtTmlzj8wydGPu0mkCDqzdn1Dj0Rhqm
	NTE0x6iVWOhgMAPRDOy/JX0qsJ9X5WFNlixMFLs3pZ5hQf69g5XvdYUKub4epoTA9zJOGx
	X6PUNTU5cptrBAKaerbNxVas51WhOjY=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.phl.internal (Postfix) with ESMTP id 5530213802D3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:49:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 26 Oct 2026 13:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793036983; x=
	1793044183; bh=xxV5ov3c0hTKqd9UolE8DYnovGSmzcocUgKkmdnwh3k=; b=J
	dL3NJqdbugJRjuL9LjsbKRphw2KicwxMAV+dxpERQY19YmZ6QzhL4ln9wQHwiRfA
	TnU5tgHVCMuKDz2ydh5yqEc6EV5jCwljkkQj5ZzyPNS3axhN+/hZgOXyZkM/RtCl
	9H4yepfmeOHHV3GJJdQv6ve8B9gW3kfR3KxjI7e4KDv8mLQVmsJcmR2Lppfijn+t
	U0bMcyWlTqeZTEcSSfT1blE7VQo0bfWtsnRymicu6qzh6hPxZ3SKxuYefnpAhLyn
	K5or2rlyWtepue8dI6zJyXApcau2pJxOGCpQFsxmwhXzgQXmXs+W7obSdzuFvJhB
	ArncCXmZNz1bgx71MLw5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793036983; x=1793044183; bh=xxV5ov3c0hTKqd9UolE8DYnovGSmzcocUgK
	kmdnwh3k=; b=jsaKGriaA692dIgpgEARXfonTPOY41+tEtlzdyhDRdnf0v/lFz+
	IxIAldbuY99yXj2+uvwHOgBYeG5g2FbmNzgrMSdNjQrdWzYO72La7ZCdUG1f9d9J
	Af60QpKAvmZ0RHGaWtqd7AiXuoG0sfBjbbg0mrPU4EZ4YR9IOmVFhSc3+nSwNnzS
	ouQHdvYZsOx4LL9XXeYHdChsXjpNHSbE53VnBXxZFlwuftFZHKE88Ukc6HVdGyl9
	6nlEbXIzh61dNNA6idTeqYQmheLPlFDf2hj4CxzM5NGSizwEo1XjWs6sPmF1gx50
	c0KDCCrRBx+TfNBYTIAurgl9KFFzUjhsn1A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793036983; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:XKEoH/S0AJ5dOiPOvejLl/FeyjMFNW3AsMFVi5jFQbarKI7
	2PAIwZTSHnQVm2FKjFqEJ1wa5PnQwWT7J3TtXXBMI/Ye43DQlLxWl/XY1sUoia/y
	UVEQS+nZdUrD7hJBucidxghgcYSXUj9RKKJIVF114Wv7TYFv/ilgyVYmuOAxahRD
	PLT17PTaCWnAytD7MB+Ae1lpMpPszxXmIEeDl481aY9Vhx5rlBHeCGOBCj2CCdmo
	fLut2mK46xQT9rK6oN+E9AhcRR3s5pFgf9vPldq+hbOclpdeAtTMwSuPFjCKm2BC
	5DwW/fjCXZ4pnVB47nUyo7nQ04obO6Ctrrzxw7A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:oAI8CvIbumntInw+4PFy9SOzhfVHaiSI3xBGsLX0Fcc=:cIqzR+dk4dI8U2SGLdBfaB3Z+vbsjVLGPogfgOdxTgQ=;
X-ME-Sender: <xms:tJLfaiFURCNdynr59obpYBBiVl4V5UzanoXaw9VQTms5MmvDtIuP-w>
    <xme:tJLfaiezpFzXO-Zfv_74k1daYZBx6nHLGhU7gb5qHt1m95IWKbwRmmHtAaVqg2Wis
    zafiftWyYeKAGSyT1Kjbi9iIpDJqezGMiLgTiCWhUE99To5FR2lAiWt>
X-ME-Received: <xmr:tJLfahJkh1-pM4dmfx0_FPH8hg8zgScCWFiPl7YL1n4UUWyyhTGAzxUa80U>
X-ME-Proxy-Cause: dmFkZTF3TFhuE3wGcZJjUzIyjpcTOyexH41fjQWtbyhLeXHhYokFl+PdzJCSXxGGgJCuOJ
    dy5xoklUsRtz+csfRFFFJskyhlsSQsto9rVk3Xlz3nETmWH8sqjeYYmCn0LJzkpgO57i5k
    rdDoyf1u9Kchi7X+0v96xV5zGmpLMOO9JQ5HHJkAv5WxzI0OrT8Sq74zbsPUvq7mGA7rRZ
    IIwvOGRi06s646S/NkFK+4dyblma9DUxNKJT1uTJkvS+vsg2bD+Upt3/LTu/0HWVZlK0Jj
    DlFAwQClbZ6XOv6mqbXadmBiTvGlWIFDBKnMCr7YO4yM+t3ktQ/4bZdUK9LFzakP+92+Fm
    vG79z7HcXs2kjYGMgAzRjuQ0Qg90Hot+Ca0+OaVT98vuHtEbFT0dJOmcOSmfcw/Xw6u2d1
    ydWX/qnX0spiO/oLJjHsmk+rsjzeachNCfZqYri4OECtaMqBqLsy8GKT4bQbqK5deL+Y+j
    xz4oi0XTNlD6jG61NGTNYmy4QmHW5t9idNlTTjUXxyjcS9YURryFMnzp27h1BibhDflcz5
    UY0o1n8SpTQHwQ3/5malhwYKSeSMg8q6/xrtSPPcVMnMpyyR9vsCGY0TTUpc/3e38AVljE
    CwiXQtNotFjguQ2i5vkeoRsoHb1TyfkFlTP3gRHzl3UveODfQuz8nenQXqlQ
X-ME-Proxy: <xmx:tJLfarraKcese7WoQH1qripNE2RW3sQ02AnhQpBgIvlz7tnud-QoxA>
    <xmx:tJLfagazhqAewp0B4A9M3D6fTyn7_VpRNZ0nuifN8YsHYk9-7jyB2Q>
    <xmx:tJLfahiI7id630K9NmomSvn62flSZaHn2KKrgta1RGySXMbr7guD7g>
    <xmx:tJLfatrSUI9pQ0K6u_jA0hZM_uWTVUEDYP0jCuf0p5tgifabZsZhnQ>
    <xmx:t5LfapU-At2geLhbkQFkmFVQe5KK6EYoSm5kLoDw3GYWlWKmcDqAJ0O7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 13:49:39 -0400 (EDT)
Date: Mon, 26 Oct 2026 17:49:38 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 13/16] mm/shmem: preserve allocation errors when swapping
 in large entries
Message-ID: <at-SpfCdyXq18_Ab@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-13-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-13-703206d5fa0c@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C2E30120004
X-Stat-Signature: w66n9c17gj7e6hccnbmzh55zw9oqabrk
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793036984-535775
X-HE-Meta: U2FsdGVkX184iPA7PFULrW5C+M+oof6NdzVb2Cs1oU5MgvUl5jVeNVhSELdHnxRIe/dJQTIeaqzEk++XoHQXFsNTub0IBRnyhgyqOxHhI7yI7NPqz/loySeYnL4PwD0WUIKG5hdcCtaEijKPaUIxVZNM9PDoLttgqTEE87eMvtSg5TC/irnRJ8RcTYRZwcwYTkE2G2+/T1/iXcYs7jgyaM307rYju8dHDDpuxw1zokSobsjQJBxFw7XquMRMErJS5V+ofHepauUfju2f7iU2qQfShrfF4Oorot+6T7DHoYypboWyrsVX2KVpR1KkXvMms3kC9VRYW3VuRSnLhIAM3KMFVh56+RaVVk6zOrv+srXmbTdP+y5ZCoGbd5pkYK5lwqjj+hZL3PLi5O/EB9Fv3X0zsUo8/vyz0T1DFWbWt7+hadXQBry4IeRgZr7YF2nWiTjcCuQFz9BYD34YLTYJRMHgEwbki/YoRFHcZcw9M+VFYfUVNdpTi5jX8XKDk+STnyzivZn2wF6s361gwVUjSWQQfbPPpL0+dUo465Cv3LmJz02P5/60N3Kc2K0xAodXyN9dkesntC3dJcpSKQx66c154s1DoYRU0i99TYzf+6IDd+VX8s+9GBo69Bzrsah8r8dU2MobAuFxZK5qwjCmt5u0+0BnKyEgWA8G3tnF2mvuQTo/RcTZEZwOCXOfu7yBa+atzcmIJGWONxYq58YaV6JQvZCe2g8h4uDQqDZ93hhvLg8WQQZxxYPcpggeh2tEtwa/fIMxUeyO9pOWoSUzdMPD977UpA7eKd236V/nXgw32dxT4bzRp4LtYVhW71FWVGs1V2OhXZTz1tAEA9qXOkw58thFxDgYF60FqoDJI0MFuNvdVuIELeQTQVOJMg1DVuPdNqcbf2LZbQyImWr6tQXRo+EQ2ZkePlqwpAHlmr2GxBVlEIAzv7ELyLRVZOZ1T85BK6au+5UqPX1LvG6
 vnvS6LmC
 GA1448BSC0p6DlFdhMGSjEzOCBexXkq5tTDSVokZvAM+7u+Xp5aZzAiIYD++0KUghAPUr033YIwhAeaf/5+nGN21aDPNkSLQmewjTNxmefViKVLjKemoq5a33/aE9qC0B14KrQij6ZtprkcrszUSDJCKbgbkJoIxDmu/9vPsPoLiqgtmioehnbkn+KYRJ/da5ffllyVQqPEA+31BESVpg+xE9NcoUG+zCIebdW9YJrJj8LPzV2jo80QW+PyPK8nBZfCTjhdRJOEzDWsHh1/1FPggrW7QDPLysNa3PHi3ED5itAOMsPJ8JImz0TVRvBdsZCeckRlDk1mz9FVJbcA8wgA1YGY+kUmO6JbF3xDoeP3uG4OC130GblQH+9ID892k/N0oSyXmIcyzgYuQAuQVZ4TicKkLn0eFxMj41qvYJlTKh+TSxGPU2SmAGhwEk+Eh+QWy+BK+Vw0v+jp3+p0O+nnbD5a5thMw/M/VbggOpcvHT0gXWcyoLoOp0H9ARd/Jd4pExY5umzpSI5MA4r1AAS1BCedTPG3SYo7uLH/VZnIQwvsdQTi0F85WgVXMBUxsPeLDyMUH9VzMoQEsLvYAAK6ulvyBUVTQmM3wFMvBPDXtXdI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:46AM +0100, David Hildenbrand (Arm) wrote:
> shmem_swapin_folio() adjusts swap to the requested slot within a large
> swap entry before allocating a folio. If allocation or charging fails,
> the error path compares this adjusted value with the original entry
> still stored in the XArray in shmem_confirm_swap().
> 
> Unless the index is at the start of the entry, this turns -ENOMEM into
> -EEXIST even though nothing changed.
> 
> The caller retries -EEXIST, so persistent allocation failures can leave
> the task spinning instead of returning the error.
> 
> Restore swap to index_entry on allocation failure so the existing error
> path checks the original entry. This preserves the allocation error if
> the entry is unchanged and still retries if it changed concurrently.
> 
> Original fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 91ab656ece13 ("mm/shmem, swap: tidy up swap entry splitting")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

