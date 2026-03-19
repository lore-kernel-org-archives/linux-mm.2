Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0244C1091929
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6006B0095; Thu, 19 Mar 2026 17:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD616B044B; Thu, 19 Mar 2026 17:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C706B04EF; Thu, 19 Mar 2026 17:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED14F6B0095
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:57:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D566160753
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:57:06 +0000 (UTC)
X-FDA: 84564173652.10.B1FD5EE
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6FF3BC0008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:57:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l lcQSop";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Bjg+dmZT;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773957424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cYUbHVZqxGsZ9RWAyJj31WCuW6l1bi98Wnse7Kjgeo=;
	b=4maBbYrzl27y2whjrUSD2PMveNlbkH8S1ymvfKrSfWjrLSzBuBHe9kGE/V/Dfb+GOysl9O
	XKpZcFQzm68WfIyEm7zFUsbWKfwQN3z2H98/55ed5yW99Xea0t3lagJt92B8yrfW1ajoF+
	76S/D69bP4346Wbi6R8RfUpEa91XtVY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l lcQSop";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Bjg+dmZT;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773957424; a=rsa-sha256;
	cv=none;
	b=dVzYx1GK2mc41AXOuP2SW+24XgV4KLyx7DOKshE/HnvregIFmsf/HhZ2FW0wMifJ5voKU3
	e8Qg3kkyOriAAUMRsTCaVQ2THe5rNKS6gVLnYnkWbrCJklFFrFLd1qrIKuzK9xUWGwxZ8K
	pJzrSdgH4SHzXp+xe7C87HgzW8KjssA=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 5BAB71D001DC;
	Thu, 19 Mar 2026 17:57:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 19 Mar 2026 17:57:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1773957422; x=
	1774043822; bh=5cYUbHVZqxGsZ9RWAyJj31WCuW6l1bi98Wnse7Kjgeo=; b=l
	lcQSop5bgUOI9AdErI7RQ9An3FwOlx+fb7WYh7aB1hRDuBo9tp3ARgFNA50ewihd
	Nco4dV/ddTpw/Hn6nkgMT+r87/3QZUqRabYin07bR2iVXOFFfiA0nkdxxDrc/fAV
	SZv5Kp38xwu24WalYGgRmKx/RN2rOcO+vQx11nFL6vuZEz8DcDB97hKjApu2csaq
	pLF0/AVWsmSxHgwyyA2fEY318ULtwSpdXrDPZj7H00ACKIgSn2r7B+qpV8u37zZx
	fXugW2S3qw6Uhk+N45zPmpgSSlalRxMexrUZ0vSNhCGuQ0OvHa1nJwpVrY4WvGY5
	U1mmr74WRMOuALHPT+wlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773957422; x=1774043822; bh=5cYUbHVZqxGsZ9RWAyJj31WCuW6l1bi98Wn
	se7Kjgeo=; b=Bjg+dmZT4UTrFGxYYOPWtgtvjy0f0tL/8v5+CBNF4gFniqqlInM
	NaLSC05dw+M/WRkOLN0IwlJcPIEaakcTusDEGAlSi61sQMzdQJN1oEWxd7m/GCIT
	pBfxqyvQRibP2neAtlTKnXf9/Wev9izuTSxJE2ofe9KTroESLaGuDAGaIQHn28rA
	Wi8ANekCL5YqdNg3ngHOQgSM5zCWWHdwG771Ry+4Cu2luBo79ojFlhQrLv+nRkY8
	0MyhhA28FARkDod+M/uhZWKB1lXl364xZnpywQOv8XDi1nt44daJ8iNz+ZZ1q8OY
	84C4twYece6jDJqPKKf9tJ0JVpx2JfSgbBA==
X-ME-Sender: <xms:LHG8aear1C9qyv9_4KTRZVonRRzAUn6tNCGvuQ-CdbSd8EbSWysN6g>
    <xme:LHG8afCPpakc6AEvA0DAFnsNhnYmY5NG6dW5aqBkiAMxXazKW4kBiQFiK1p1QqRUS
    jK4SW2lSXWovbtysvx5cKyx60HWXshuwlxMbX1-BJ9gJLnM4PGG_GY>
X-ME-Received: <xmr:LHG8aQV7SJspcuFFqGtb3P0U1AStxx1JmMAOM6YvvBGbC5jJmO4RaU7kbOn_6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdekudehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeef
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdp
    rhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeiiihihse
    hnvhhiughirgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfigrnhhgsehlihhnuhig
    rdgrlhhisggrsggrrdgtohhmpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorh
    grtghlvgdrtghomhdprhgtphhtthhopehnphgrtghhvgesrhgvughhrghtrdgtohhmpdhr
    tghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtohepug
    gvvhdrjhgrihhnsegrrhhmrdgtohhm
X-ME-Proxy: <xmx:LHG8aY2rJs2K9jOVTCdvS829xbz1qRmZ2ct4E1Rw7PoqrYO3uvrcmw>
    <xmx:LHG8aRVxe413-hjCg3mQhZB3537PTcbaZZCaAFvVBL8NcW3bfL7H-A>
    <xmx:LHG8aeCEE34I1BH4jftR4CsybeonFzw1kacUWNMTWpamHI616CpMmA>
    <xmx:LHG8aUoeDwG7ge8TO3IkFXAlsfXf2UjlfQmgS864DO3LpMZHzkhgww>
    <xmx:LnG8aTZAdTK40KaU4KiTkaDQlSweliS_PoZkKz6D8T9AtT2XVUf9AUSX>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 17:56:58 -0400 (EDT)
Date: Thu, 19 Mar 2026 21:56:53 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] mm/huge_memory: deduplicate zap deposited table
 call
Message-ID: <abxwNW_kKakiYvsp@thinkstation>
References: <cover.1773924928.git.ljs@kernel.org>
 <29fa4129cd560681c67433b4c344b2c9a027d1b4.1773924928.git.ljs@kernel.org>
 <abwr3EmhNZVwOkR3@thinkstation>
 <420f1b11-3b62-46dc-be33-58fbd5a4c8b3@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <420f1b11-3b62-46dc-be33-58fbd5a4c8b3@lucifer.local>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6FF3BC0008
X-Stat-Signature: hbykgqjzn9cnnfaf6y9riemggnoytau4
X-Rspam-User: 
X-HE-Tag: 1773957424-152114
X-HE-Meta: U2FsdGVkX18CJYFiOxV3WPhDMVgnr42lA+vHGKQCzkpSd0qEjALRpIqN2pc69xXgsT3pbcoCtB3brJdyoIxE/vXgXej/bOWs5toTvfpnaYJ8hvYbveOI9klWLjZuee7zimP4Js8Ver2o+/ZExbmmVYqbLW7yg/RcJE55+hyim4aG1+69Tedk8f2F7vp7bfkZEY8yvnyEtLs+oopNQ5peT0tQzR0FhN6nO2OF8xtcmOxFtmtlHui0rxnMhcVzhzftjzdMhYb04KgidakLRG8Npz50ZhJkMX8aQ5lWLGYB2UaiMzmf2FdmhkxyCjYnW3P5yVnbyYMLsCXK8mCg4TdNx2uC+zMjnU0wLoH886ZtGM/z+tWEKkTfeFHm8wL81cgjj8RefrqxpKU4cTqCkjVGU9vuEn7ZvqKe9seDWOnvP+pOpPl0b+S3joDunXxYVL0BZVRuRcRrvL+tKswNmVZu+xoNWto4v5FNVKG4zexBJlSHIlK06HXg3Ho6p8R6N/rOUqygj3AVnWaCytcM8TyeDiqCpQsl5xQpg+6wCAFm6/9lwBR+WIRNOTXlKm8vCBEVMbusxzX6yvGM5lkIaHc8VtOhD/axcrXR+QDDbmHaUCrnamPJj2WfTQlySc0W17YgBHZdfjrxOLmDzo/+dqfRWkNP5uP6PMzql5Uv/fLEpgEDh9vNuBquY9/cuvcsKB/s47KNmRSMC/afEzU5fZcoTzoahyZ03/5GgJ0hqs4kSOcPLTwapkw4QHiVZbABRNc5xE8ql806LK3hq7cfmUGA4e2GScPdw/FEdHsEYF4h1ixgtGtzAR/0Aw0HR369LOGEF4hXDnoOQFwiPzYWxvQPb1rK14bHkmgCFhLqPW5mV+FbRpMiNyT6UKgFkwc4cYpThYybwAJqiTL9Qp1K+VV2Cs32RRdX3BPbGxmEKCJBvO2MUymcfOD4VsKBUyI7E27mWGwiKxt6hS899jTUgD/
 Uuchlb8p
 mGWqEwuU5UNlFFcvmLFOsloHY76vTIYdKgA38DbkzOkbYfYPJDS0+XmjLRHbc9/RO4oh3irM3lksCUhmTMlCE0d4y3xK4UvTaiDpoQDhZF7a9WUfyYInuqvW0oZrvchuDFO4pCiwAeSi2n87uAWvTJ6+0PPtWao3zmOAPpnC46kgIK6WdEuwQ4LSPlTdGNB3FPigOaOfP60+dHqLL2P3Z8957IwfP3xPwwkf+RPY2MpNYRv7EFdonokpgfxcOIKBHZBPQKV2BSEsPnkr7EnsQx0fhfKY0YQo7s86ZJFPPlBha9/bEsBYukCfZdonj4IL/nJxZnAZbalsN37PoMWe9QlcbOAMYJq1u53N9cpEcK7sLWYanhu0XNV+F5hCv9ZEZ0SaahytogJeVeH/YK2pg8HMAgVysKAPaSfeZi+edjvbBZyfqO2dFxXFMDwqIzeDXdAUjc/yDJUapTSpVxS8ueBenqKMmFmFHyv25PdeCcOg5RI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 05:18:11PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 05:03:10PM +0000, Kiryl Shutsemau wrote:
> > On Thu, Mar 19, 2026 at 01:00:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 499c31bf8f83..c4e00c645e58 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -2431,6 +2431,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> > >  		 pmd_t *pmd, unsigned long addr)
> > >  {
> > >  	struct folio *folio = NULL;
> > > +	bool needs_deposit = false;
> >
> > I think 'has_deposit' is a better name here.
> 
> That's fine, can rename.
> 
> >
> > And initialize it to arch_needs_pgtable_deposit().
> 
> Yeah I considered that, but then you have to do logic like:
> 
> has_deposit = has_deposit || <whatever>;
> 
> Which is a bit ugly.

You are overthinking it. Just do

	if (!vma_is_dax(vma))
		has_deposit = true;

No need in squeezing it into single line.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

