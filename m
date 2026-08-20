Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DF07C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 15:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157876B0092; Thu, 20 Aug 2026 11:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1302C6B0095; Thu, 20 Aug 2026 11:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045086B009B; Thu, 20 Aug 2026 11:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9E176B0092
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:00:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68C99A23BC
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:00:37 +0000 (UTC)
X-FDA: 85121959314.22.7B86018
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5E4C840004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:00:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="y bSy9LU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=PHxqwqwy;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787238035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NHH3MAtXegQM8wmmdhADbFPM8G3Gs+3JvKoiIEVOUc=;
	b=OzW6DGkk5vDnbp9F1Mgs6I+m9rLpS3de0Pl7OgbgBfuErLYbeIEr6doryOJZLjc8HrlWBd
	tb+QGScJ3AWJSrdCjcSRG13ZRK1PZge6cVc0Z5is4URYqe6Gr9xSfa8wWuDZkuI4ZL+sBC
	vxb6iYJYIcCWSEVv/8u3vnBmCheA8Lw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="y bSy9LU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=PHxqwqwy;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787238035;
	b=b5Jnr+X1JJAbIrdYRmWlUwnmKSc/DbD88SZ9h2fFOvsUbC4aZd+b6k3bQMI55ADWM8IWUb
	SaXN9LY3qqHFJwOemmaiHl/SjridsLiSJ1bNTUAMlcJxBn2FKRY0m1MR+p4Ty93INlFmtQ
	yaxBa12FO/+AzZ3i4Zxe9LMO3/mVJPg=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CED8F14000F9;
	Thu, 20 Aug 2026 11:00:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 20 Aug 2026 11:00:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787238034; x=
	1787324434; bh=9NHH3MAtXegQM8wmmdhADbFPM8G3Gs+3JvKoiIEVOUc=; b=y
	bSy9LUpE2TURrJNCOInPhz/J81lPAqVQADV0DEAbsVj6h+mjSiK+Pl5c2no3xAln
	ZT+pzGa5KiN3qQ1x3RGqaD2pT7iMHj66SjHDcH4vpCe+WtG9UYs1/w1HQt3DgXYw
	ItJLSrzyMCOODVb9vONn/rL509AB5VFE8/QGOMilyEcJ4sDB3ebU1+mbDFlpyRkA
	zjdEmsD+LkS6yLwImrIg6rHzcVhXV2236J9+up/B3D0Avpxf0iUqUZosYUgX1Idt
	LOAcDc3RVspuEr9GEoy+OVY0Lgf6FmLe97KGYBiI9H4Yj5GiICPjiwyAL5TNkSPP
	v6j3URIh8hBHdCcpwVcOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787238034; x=1787324434; bh=9NHH3MAtXegQM8wmmdhADbFPM8G3Gs+3JvK
	oiIEVOUc=; b=PHxqwqwynGL8tEvQeE+15D03uaZFylAb8AkxfjH8V5Vt6Jbvlp7
	AhiFrpT+7afJNlj81D3/Iq4+NDqmGfRvB5Rr11IX8jH0uj85Dr62ruGO/6sQxZOR
	g+kdENZsyo9MQ8rah61ds4e2rrVYWo6P+hlDTmsrRUYVubr7bffCwgDcM7qei2SA
	NWuR1t7zRwAeoEM4wWKYT/BILWDwM8huFhdZiSxg2fSTQsHuyt04/fcxKlpuggyX
	IuAbbyI85ALz3lifCqJPfyXbX6yD7d+OJAnM2dcgWhVYHjuYRhxBaOwxwU9d0Wl/
	wCP27Dpn5O/7UcZHkAShrBw+OxBleBUYP9g==
X-ME-Sender: <xms:khaHamGnNRiFZlkdmJZ4zuJg3rhsgAjyObmc5LXpP_-6mO31if4RTQ>
    <xme:khaHaqpYN-WTlny29pDASt1_ZFQWgmW1Fx5qHl0s9tyr4ADGxZvU9Yho15Y3g-CAs
    JIeKX93VxZmhF21HB-OIrBa57AdC_Ofhw_hIgAgUeZhzYKJX4a138E>
X-ME-Received: <xmr:khaHakMmKYlYiSlWPA-bm_BW25GZzfm-WBHlsMm4cBrPFLv_40aJgT8Rmp0>
X-ME-Proxy-Cause: dmFkZTE0/9X7WIzT7v0cJ1Q68jjWE24R4f9YD+0vv/l4GrYIP7tL5wuv093UaXVgVH30E8
    80/ZyKNSEHmGq7ojjVQqWlktXNiRKQYT8pxO4ERvYN1NOvSqsMenUQKZxDhs+dHKXEVPI6
    UQQI3Cnxqx257NeEinkkbSMAgIyrxGy+3LyIVGD662Q9JoUG3XYDJGL2sXVXCbPKO39QrX
    iwCOxpG2/06ZaIhxY9r4yHvNjqDfm/OrVj93wsPLClOa0UNxBIXUehNGDPpbqr4MpNbeSo
    /3U46K13FXumbfTWf33t2x28XQ8MR5zuXgJxJvRFw/xeMsvO6a64SnRydROJmhGIrt/wFH
    +K37V1yOAoB6fwsiRq0cHC06gi2Y2E1FBp+ddRUkRsBuF3CEoKbKmiOMyflSStNRWTUL1p
    4YxUt6h0cGoKGpPXs2vMr7wzHwnBvtaQ7z07Q8Nqk4q+/UZeJf/45TWikhigUxinmx3azV
    gkxUA+qHp/NWcZnaPXxmyxVm/KlKpppJOftyEkqSyzEpWyk6VjF4dxF89yrWKVjrYxs38c
    6SDNc5ybBk5uGxQycyp0kY3hDW8o0WKvG928wnqhTqjl4XLvTrfde9HVu8Cstdt+S4DcNQ
    xqQredZLSBYoxAqpvtNV5sv1zjhBl6xxcp0rcFpHtzkKB8a9BpAwcFFa2+RA
X-ME-Proxy: <xmx:khaHamfGePOUDx_KIr-CYt3fgla9L8ETY60ZgWHB3MG9ENcYDXguvw>
    <xmx:khaHaiRHdbUzGdikB4dUgxAaZ50EPlCYGgwP-F2hKm_OH9Y37ujDog>
    <xmx:khaHalqo3uZVoZSbr8MTIBVao_ZEKKDSTO4_xcKgfOBhGywwyYHwSg>
    <xmx:khaHao7-20IRSnV_KugpYALdKzVrKpiwHmYgttlohevlP5g-tGBAJQ>
    <xmx:khaHao0eLrIu1KQhhVdJ-QeLxcqyJPJ_P4rsas9Zlo6hPkmOBkTLIK4J>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 11:00:32 -0400 (EDT)
Date: Thu, 20 Aug 2026 16:00:31 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Qi Xi <xiqi2@huawei.com>, akpm@linux-foundation.org, vbabka@kernel.org, 
	longli@microsoft.com, kotaranov@microsoft.com, jan.kiszka@siemens.com, 
	kbingham@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	sunnanyong@huawei.com, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm: drop stale MAX_ORDER references
Message-ID: <aocWWrK_K1iCtq4P@thinkstation>
References: <20260818122408.4182417-1-xiqi2@huawei.com>
 <aocAePwuxr4te2jG@thinkstation>
 <AF9812A4-550F-4E3A-B67C-EAF6F9F56982@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF9812A4-550F-4E3A-B67C-EAF6F9F56982@nvidia.com>
X-Rspamd-Queue-Id: 5E4C840004
X-Stat-Signature: hg7zoitp1ujgbsk5z1dk11w3ymcdq5ed
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787238035-452599
X-HE-Meta: U2FsdGVkX185JIWMO2q8Hacdm8+aFRU+6+2K0ZwLH8akgLWIep1iJrLG3nK2QZhnUt0WsaeJqT62YilegsL9mQ11rt0Zf/o0Y5bORFAV4NDQXylNSipizb5NWEwY3E8cw/ZU1UYZttzyeiCUTZVRX1hard+3gnSVch8khmvCEeKJ1xzb/AXkvZAccnzlqO/xH4E9fhdpeHHW6SAKnIk7QLVU+T4LT6PbVuc5f+5uPNNWonh7wh8UgawIVEIEipHLzy+SYmIJQod7nlsISX5WzHko4/9AeniEjFkPoXOAkZTMXpDZau4CgWGASAeKS23ZksMebkBsyCw1fNTq/IpA3mKVcaLfFuxPdvWHUVyi0CL2HhH4txmgbcOHbEnw8eYEPaa4J+KuiIMfoYvU5vnCe0GGmqtMO76Iphw8TYCw7FRTNG9jfq7a8TAcW/ql5hEOK4sbpsQ3yPK9XXyUkCSU7Y8imw8L5MjgPPnuJagaFlMYv25ChCjs9DnfhOdaS5AmCDYbEsTwal1F3wacj0WHuZxHl7uMKBeTJjqjiS66a3RDhOjZmKBBhUtNoo2Na11AmMWUD5xfgi1pR6t8nMMP2YZxxJjmiY+vRYlB41BTKjzkruu8tzCPZSmEPrlgW+gcS5wl7VH5iOSZxL6vuW6u/u1KKHCn5rjvohRZ/zmizpaxH+n7O8QkxD+SgQBn+QfVzunI711X88oFOUulfRV497vXxdp33vSbhOfLlAWczIiw3yvnWPCMoxKmm23wih2C3VIFKSx/vfj4a2WnTnWTaUeLE4GKhDz6hHqIsHVN66DkhFYSvbb/yahlx1jU+ViW7tegPCFVJ+DTGTuZAxqBRq0P3Nn6/QySRDdECrbU0xhMJW8VqBRXGU2QFnMemMxalRkh8/Z09O4IWOUet2XjCD4vJBPE125KD8fdBPtMiw4X4GGJKHXldkDEoyHkzmWzIj/GJwrr6uCfTX6eRRl
 I/M02V/Z
 fegk7svL+Tc0ytT91Lfh1sv7l/Y2zrIuTQkzukL2c9g3e3WTfCkEidkNQ+vocyGcOjGmGJ2rK9KaB5sskh/KuXCDyc5FG1nzeCG2t5tecpl+Fj502Bi9vAHkL1kB5YVkxLvoZaeYo6yynHRJ/rWY2VEUl9FQkgwpKGMQ5DrIesmgz1eevhi2LL+yM0JjyRiO7xLbNOnomnwvUf0RgyqdBq5dBcTtEoBynUMSfAgPNybpzzOmJiqa7r6GE5uNJVMTuWECK05dbLQZf+no9igtTvZTXvQID3diD0e90pcgBwsOGxcXjaHstNWv9sC55bIPS8AFh2HkO992yxAU+FF/ukqDyVGE9JsLgPd6KG+//OcR6Jomu1V/leeEeEtZEMpJ5Xbun3QvECUC93w0yudwOR2gxhDaQHUwFM/15KRt6FrbDXv+63h6ouArF+jLQ8EOh9BbYBJ1FdLwRE/PvqTMK5Ujmwf97jgsEJD9pv+Ef81tzd50MuMf1v3zuYmCmXLARUxVaYflgL3yCGVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 09:52:03AM -0400, Zi Yan wrote:
> On 20 Aug 2026, at 9:27, Kiryl Shutsemau wrote:
> 
> > On Tue, Aug 18, 2026 at 08:24:08PM +0800, Qi Xi wrote:
> >> The treewide rename in commit 5e0a760b4441 ("mm, treewide: rename
> >> MAX_ORDER to MAX_PAGE_ORDER") left a few spots still using the old
> >> name:
> >>
> >>   - two comments in include/net/mana/mana.h and mm/page_alloc.c;
> >>   - the gdb helper scripts/gdb/linux/mm.py, where self.MAX_ORDER is
> >>     a local mirror of the kernel's MAX_ORDER define.
> >>
> >> Rename the leftover instances to MAX_PAGE_ORDER so the tree is
> >> consistent.
> >>
> >> No functional changes.
> >>
> >> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> >> ---
> >>  include/net/mana/mana.h | 4 ++--
> >>  mm/page_alloc.c         | 2 +-
> >>  scripts/gdb/linux/mm.py | 8 ++++----
> >>  3 files changed, 7 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> >> index 04acb6791dbd..1d5bed71d6a7 100644
> >> --- a/include/net/mana/mana.h
> >> +++ b/include/net/mana/mana.h
> >> @@ -40,8 +40,8 @@ enum TRI_STATE {
> >>  #define COMP_ENTRY_SIZE 64
> >>
> >>  /* This Max value for RX buffers is derived from __alloc_page()'s max page
> >> - * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
> >> - * size beyond this value gets rejected by __alloc_page() call.
> >> + * allocation calculation. It allows maximum 2^(MAX_PAGE_ORDER -1) pages. RX
> >
> > Should it reference MAX_ORDER_NR_PAGES instead?
> 
> It is fixed in v2[1].

It is not :)

My point is that 2^MAX_PAGE_ORDER is MAX_ORDER_NR_PAGES.

But v2 is good enough.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

