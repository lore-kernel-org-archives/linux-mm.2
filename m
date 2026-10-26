Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450F960A260B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=b8VWtkd6;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=y+0ALcDW
Received: by kanga.kvack.org (Postfix)
	id 600AA6B05B0; Mon, 26 Oct 2026 13:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1DB6B05B1; Mon, 26 Oct 2026 13:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0D76B05B4; Mon, 26 Oct 2026 13:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2592C6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:26:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AF971A0312
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:26:18 +0000 (UTC)
X-FDA: 85365456036.04.DDA2B74
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C768180003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:26:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b 8VWtkd";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=y+0ALcDW;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793035576;
	b=GaIA5MDBhJynMQB7AVNcgkbOVepnlYp4Hk1AdAkxIeMIQUY7tL8Hhjg4+EP8ptxCdKjObg
	RkZwxMDxfJbgla84kRVcMtWIi6tR01ydB03pjejFNtDw1jdyWvMpL/CstfHKwRrXFD8OYj
	gS9SsmVNCo90lYsVuPbFXBic1J+LRXU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b 8VWtkd";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=y+0ALcDW;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793035576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gozRlQP2gdqbfsNX2AM4B2Y+PLg6RWuvQqaTDn2tvas=;
	b=GJ/dBewjmdOw4wrNhNmts9gBQyvzdWzfeFmQjohbLiIxwiIrzNU7i85SWE4S0aEml5UH7+
	E9svd5+mR05ejdB7BFNCJqDS0fBRquTI2kH/xZoIY0v4jnj5QwBW6gMZSS+T6/3v+YvKnN
	AY/bP4Tppn15mLYPzqdL0w2bMTgzgbI=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.phl.internal (Postfix) with ESMTP id F3DB813802FB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:26:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 26 Oct 2026 13:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793035575; x=
	1793042775; bh=gozRlQP2gdqbfsNX2AM4B2Y+PLg6RWuvQqaTDn2tvas=; b=b
	8VWtkd6ivSPvtKaIADrhl8vqZ0T7gVGFJChcXopg/CW0OT0MZK6KUzDk1DUInA3A
	DQXd7M/ANUBd3ZGolmlHwqbsN2t/n007uoNRPupxYUYsf2lGZ05faE0Z3xgp+iHP
	HNyJ3XTI7DVt2nt135NlJXphagsj//Ts17Z1fgZAoPDu0llimgoHavU/362eOt/x
	0fTYYihiI0pDObelXPDCdxO4Xvz4jPE8gmo1lK+V75WNMEHTG92aptK5kcxgiijd
	lqYcZgDn77WVHVeoFDrLFs6TEYS0Hrt0pEVVsHOsI0DBjHkw1ctsgNaZwj+x41yk
	BLTHWJFls30fC5YMeCAUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793035575; x=1793042775; bh=gozRlQP2gdqbfsNX2AM4B2Y+PLg6RWuvQqa
	TDn2tvas=; b=y+0ALcDWLZbbQexG18HzxDCXYXQAj67ZHExGPDL+IMp+bC3VD6M
	9RGkovUeJzcVXxyvTEc/PNnXsjMIVtA4V+Nbw9Os77A9561EjSbyblmgaaTpurPN
	aB/nqJnyyAmDiOB+vCccGJa5uCJ6r+4FNX88+pCB7TPAH2ohsWrxnHPu2aXdVh92
	sl4TGQxUbC+pGTYa9tt3f2ZKOkKcbMi7285KQMEnndcWqzKN+LrlY0F+aY31jaIE
	jvz3wICN6CNwwlYl3Wbu+Che/AtxxVmW0Vtu379Ed8D4RYpG8dy6eNOa7BSaqs+t
	f0HftapAQoHnG8Ip0t2HWoHADZDwhokWXZw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793035575; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:CbzetVHX9Q75tzu09KXQ6xH7/MmL4rAJWQ0dtjdyddDQ8iu
	Mk+EDxmm4emDDGtN9veaMakEwELQzqwnlM4KFEJpu/DuhFafWf09LiSssqRWkNI3
	czP+Yggrdz2KuKnPRxmkNi6Ri2V9tzXQB2WsVYi5I7iOsZE0eGQzV4e9bLcHEaYH
	rvVdwPC1N0g6keyJQ407jwoxEzlMVeHnf4dBxxLvQOfUtSjgjMaBfOfjeCh6j/4Z
	6civtheTc9pvE5a8pqTg+Hv3DTfTIVwMO+xVnsSN5Cu4I+oNRUVCUwrAOPY7Xxmn
	SLXvEZDDnr8hbj4Xf2x49uMdOvxgDOfuIOrckxQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:GufLRvjeK9T9oNyQQq/JPRD8A7tK4hGwgAEL7dOtYz4=:IGb6NM7NJpowcOS7AREsu1vwVu3cjYvnaSjEGyip5II=;
X-ME-Sender: <xms:NI3fau8C5fYRyEFdBIlwkgvsnGbKTkAjYVlXc-4TRD_AE6qcvpQCNw>
    <xme:NI3fat00BJ_tzOaPbuYE3NrPun6gIQw5uJce1lSfNDqwAyOcRo_Ln72JzJN4HxcW3
    whOpfjze-aI6n4gmmJs_74Mg25vWKgB9VkCM3ujQZCXvC1qhSCw5dA8>
X-ME-Received: <xmr:NI3fapAig9jAm91KpG7iN9M36V9w6iiYGfAlv-eYOnL9fHoY8BaycO8MUlw>
X-ME-Proxy-Cause: dmFkZTFhALYc8iJiMlQC3g5bs7hQtPkv6lAItKCPDxNXrELyHy6SwWe3pV3Af7XmlPOZjP
    +TGoPutgWE/CDwNnpX69avMckpL8UV8zdpnMdPlXKkri7okyrxzdU8T+p+iF9UHx5tvwf9
    75PBrpgk4RnZYSRHo2SZqaMsBdjNFcnEnMHBP0yK25AuDlaeYBfs/9A2LCP9q3CXEEm2Dh
    7ofMwg9geSlYFfQZ8DFQkdWXrwTAhyDer5ayPZp94JeOiWCWbBcDXCQnyH0azeXwmi2avE
    rsXZXiu6K0AydSc5T10UD80G0DXte/dNSaj9nP8KPL+lJYKrQdzkiSpt2ehaeU9npH81r/
    1/AKY5HfzGsR+NtE6hNBVXFH3G64hnQZ9RwKPe/xNtu8bHQ4XuiNnrpZI5Rcxa8r+0NLU0
    GvNra05Tp9OSU9uDAFiV/4tE37bQglwCh8hd28PMLvcigB+mXgrhVhMisbG+TQ62dJsxZs
    KsYT2BVS+gQxwLKelcDnyHj2IjigAOXAebzcxhfuBrKuHXbep04KDU8m5elSe5h980yVQD
    ZUXdForo2hfXobY6hSzY4uvgQUxvw1a5aaAAOT2vhnO1WjAwUr24Al0+BP190B8R0goZHn
    qNRNozquHcwa7iqNx6dZHBD+6JdAZczycQaU9UNuL9bgcrvMkFpGT+CpfJCg
X-ME-Proxy: <xmx:NI3famAqp1cporiiSZVpbdgbI2fRAW0qerIqgl-1I40Q4ZMr-Q-kpA>
    <xmx:NI3farTAeByf3_0qae4dpP1QDSlvFP9gJj-pbYvmmgZBZkWlf3JXiA>
    <xmx:NI3fai6vsOY5KEKqTZLXzySlqtZRqV88jRXZWr8QzSFTKr5X3dv0AA>
    <xmx:NI3fajg7YVPru30XaX8_GjeLmRRUMVhCEU1fxO_g-wFza-tL7p7oww>
    <xmx:N43faiv4vPUoWlf1qYKPSj4XEiHMscYi4G7LrCwZ9hEqiOkBTH1lWchm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 13:26:11 -0400 (EDT)
Date: Mon, 26 Oct 2026 17:26:10 +0000
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
Subject: Re: [PATCH 11/16] mm/shmem: rescan after nonuniform folio splitting
Message-ID: <at-MPTlXmfs7r5Xh@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-11-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-11-703206d5fa0c@kernel.org>
X-Stat-Signature: oskuzexyq5iiipxbqi1y8zct3r51njao
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6C768180003
X-Rspam-User: 
X-HE-Tag: 1793035576-721203
X-HE-Meta: U2FsdGVkX1+JUlAsvagFXBjO/71LDyBCsjCou9ePanRx7gqfkRscKNV5nsuuXSrdDdozfr4blbnEu9P/JniTqjvPcuCLeVcJ9D4KgUtJAIHfCfwaD6eikO9bnsaaFmo5h3D/wDUze0LCzHkTg9L04FL8PIchuSGvzu2Oqd0SoxQJSoUoUqzvg2SW61c2hnq0WqP6uo/D5HRicyonT1t7cfR1XHrBjnQ97Yw13j3XhlVUVMFQhlsL4DHi+yZS8/qTddNyVEn9cjbY0c3SAiZnoZv9Jtds2byqzTOjHsonGiSsuffhDEMhWvulbQRmMIpMfimKelKODeJhx9TdEcuA+EtNEuTpN/nzi4IryTw0bXRE+jPq4X+GGFwuSVCnhyNOf/gA00wm3iyc8h1pwF0D/+84deqUcp3ztbAM8kaM+Zyrq73ktrXo2v4uyHZitB4YrOGzIcbZhXAjbaC3V7FnKZBfGOTxYYICm7d4+IJcdTOrdszXckEAuIv2eRebyVHfhfYcJgoRELqBcGvFBkT7EBHPXg6co3yXSYBC5s9D/Jh09hK0B/a9gablmLwEdewI1kqh5BXtzCBEf1Pb7IeAPY5K/KJdk9OBqCTQQmOulYTn4JHM9vGNMk1H7NdukRdnnIF9ROus8hZvTmwN2uSATTwCTsDmC2SsO+m1IE18ZLu+R/F/I7VKZJqSO3bfdBgLyFtL0ymKfJDfxtu/gD4oaDNf6p6ThQl7ro9NwB1mHohwh5dBFyX6+nmNgU24KjTPn7vKg1IKXZlsIzrFkQ5CjBUcYT9WmP5/wSLkw++3Njq++MN9GrXuU4MivSyVZp8TqJEhrtDNU6fJSvviAPKIWuvDG7CiY7ZQ9TGRXH+TMlzgpQIIv8SPV5X8kbRDgwLumJEdyNEwT+78witW19IN8hYYJl9LIQK9Rdz13laY+J33wbjtyCUwN8seSbVrOLyV7XB4d9MZU/no0UwILDy
 oXP2S4p/
 Ehn6i2T+qWw53krQJ6KPzG35hZDHA/uhM9efgejEpFgt3Lr96zFvqzuYzd98cya45tOm6n7GKvIyvTy9YOY2BSLc6Pc3INGZwI6QMX3C0QTJw6gtjRCgwdg5hdo76EqDp1qLcQ2sPXrQVrEEcCEQ67Sb5LxJfMrHs1vRb9GtyOQIwucqYQ45JwktrS/pgpX/xgp8ZUQOT3QHX35VfbMOs6ek/RTBCJG5z0Y4IC2VH0Hh52/L2Ys3H7q4nfx+3zzrrJNnPDGOYoWCbdnmsDY0kXTnBghY8a30UyEy9VVqbSxwiTO7Xa4rWLkHzJkslNM8W43Wz3mMvbwiPfIJIcnAd96Y0DXdtPmKyuHKKb7VOdphawbhEu+eyLFmRpTY/qd1XkDjUpdrdbbroQlowOPIYozNsG0dqEqWFGH0EN8/V8H3WK7AKuAu/rLQ1H3/eXJBDVpfKxb6LAOzRyStGonRJ017cpMVGpEfxcOqnKmhmVwUEgGKQZUXGSvJSjylWvOuaOC3fHxktIrtVmqoe1rm771jxjSZraYBLXqEwH5eDubf5nxue7GTxs9WNaLTTMifnUGUlyMtaGsO4yKTeFyqVCXDxWvpwqqNM2FEV71kLKewVzBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:44AM +0100, David Hildenbrand (Arm) wrote:
> The final scan in shmem_undo_range() restarts after a successful split
> only if the original folio is no longer large. A nonuniform split can
> leave that folio large, so the scan skips the newly created folios.
> Hole punching then leaves pages within the hole allocated even though
> they could be discarded.
> 
> For example, a fault below the hole can allocate a 2 MiB folio after
> boundary handling. Punching a 1 MiB hole at offset 64 KiB splits the
> folio successfully but leaves the original folio at order 4. The scan
> continues past all 512 pages, leaving 2 MiB allocated instead of 1 MiB.
> The hole reads as zero, but the pages and their block charges remain.
> 
> Restart when the original folio is still in the mapping after partial
> truncation, identified by checking folio->mapping. If the helper
> removed the whole folio, no rescan is needed.
> 
> Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate operation")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Do we want split state after truncate_inode_partial_folio() to be
communicated more explicit? ->mapping check works, but it might not be
obvious why. Just an idea for a follow up.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

