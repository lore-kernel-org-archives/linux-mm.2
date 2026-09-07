Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57713C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204956B00A7; Mon,  7 Sep 2026 06:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4D26B00A9; Mon,  7 Sep 2026 06:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAD06B00AA; Mon,  7 Sep 2026 06:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D230F6B00A7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:56:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 146E580107
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:56:05 +0000 (UTC)
X-FDA: 85186661490.09.82577A8
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E62040002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:56:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y jX0Xvo";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=VVnUv86V;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778563;
	b=lbgEobzsh60msi/2esgZhijHK9EjXpcaoSqvifjVFtYuFT4AT7Grm+6ifuPkhdfWmYwq7W
	fdFUt5WOa2PASB4oBDgZff4X0j5xcmAXkSepMT8L/fULLLI3AskOcNAPEZoj4NvMzS3Fk5
	nkZoR0sskMUs84vO6CUrsMdO6FshpCA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y jX0Xvo";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=VVnUv86V;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6lbYxm83JbmP8qJnr0Ogd18054WFY+Ycq+o9l1/0PY=;
	b=5zDvPRq9xRpUA/K1+6BWdHFT+fxaECVe35lhk0fiAJXsaaedp0bRMwUMOnZj1cVeYGviFF
	zE6uT7iOrI9mp7AHhA3vV4r+AHUOaIA4pXr1HoKHGpcgSM+kyFP3oZfOxW2MoFLNfNPX9h
	1vibvAdLZrS9VRMIuvnrTm15pgNFsxU=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id AFE431400202;
	Mon,  7 Sep 2026 06:56:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 07 Sep 2026 06:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788778562; x=
	1788864962; bh=F6lbYxm83JbmP8qJnr0Ogd18054WFY+Ycq+o9l1/0PY=; b=Y
	jX0Xvo7oGUW/F2QhyRT8seoU0e0FRHzb90YPtWCI4rD76gS2qxWZSOS6AJteqVhw
	OTboYETbjneWQCp6eahnsUco4gqwvRQmSgXRLUo18ztOGXvg5zkN9KdQMkiYx1E+
	+Xb+j75D1bxX0DI44SAtX+z+RzD0FiFRTYENDXiH0Gg7KiBbKNKvdz1KUt84/Sxj
	0afyzh2v0Q9NQbuWdY3jx4Wayk4/PiI7EFNJtBbHDUgwDn6P2ALqr0agGGOE6Ddz
	6rImegbasfQaMrpdvSRqBEd3DkKgXjIZtE2AiXB1zk+AdJqhVm6zI4L1OhYrhQzk
	efg+yyx3H6qozsSgn1aUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788778562; x=1788864962; bh=F6lbYxm83JbmP8qJnr0Ogd18054WFY+Ycq+
	o9l1/0PY=; b=VVnUv86VbRqJ4pV2wlCMOSvkXpaXQmS+CMMJyJioxlMxzFkuAM8
	cakjHBoK+ox2jw/l9djUsqJVXYkjvESA2Xr5W+oJ2ndT+w5rPt5hcApZhzwQ/e6H
	4Csc3Ugd+s1LODbu0xRNlmC6UJWvxrX8+JunYbILtsMCA165+OjTK8OZ8KarX1ZJ
	NPr9WKk4Hy5DIMU4VLnGxZv8yHOqHcEbyq9p+oiL3Vjrd/jcRfz4N5P2NkqNAPn5
	OsUt7tq8O6EGkjy0cf8W9vLrWmMHRpPAOGSBhZJFLZj9M3gk5ARII/eMBUy+d4t7
	lkDUye7EJvVgKI0KKQJogGGirk0wEk+RHhQ==
X-ME-Sender: <xms:QZieasA7HwhiONj2STBEXUK0dq29atl8-HemJRtzoZpLPVLAk5XuZA>
    <xme:QZieasKrmmcFjKTi9NTLmDMLk1t_HPJklhVvNzT6J4EaU0weM84eePeHdZThE0n6E
    bH-6swicY-nWdg0jALv_iKE_ADvAJYvQqkHBpIJEXopYEp7q9B1UlQ>
X-ME-Received: <xmr:QZieam__O3WKf_im4KmROwP_Of9vdBiR7mxobQTR3iInuvU-Y5LlaVPe3TU>
X-ME-Proxy-Cause: dmFkZTG3PVKk6/dBlCY9MyEqHeq/YD8qaSwBBn0/5FZxKMy2ibK2aT6dY6SikOzIpcZJJZ
    0mB/SyAjAnTvowh1qg7gdtVfg9iuNruxOi9V6GiQRPks8HOHntmOyDsadX/skN+YgpufWK
    n4q0QgK2D3RXx8OP68/Ho8HmTgce79UgjbxR4LeLU3o7Gp2IAAh2OlrLXhkm+Tpsi78Iq6
    lme+bbPuIZAxWBX234GC2jt5ENcuojIS4t/mv03y/rONCCbzz84c+wd7m48mtxqQLhyf09
    /ytQuiYjrtq1nZdw9GaPF/T0jF0pLcAOGkPqtNwj1e2WcJV1UaRLLmyLlaB5Gl2zqtxBKm
    O6mTp01rfqQcb/MnseRWJAfS470fDA7zi3eRR2QkmhIPtOykCVz/jpEOQYFBQedZycRBpm
    RUnQbL5OdsapNR7vWXpoLvuTx1g4Ik1d+mGmRxQhs56SUBe7L51/wvFyoQ6Mi/6h1Tobv8
    E/w1lVvJ8ZBwv7NptH6+RmHWS4cpSGigPkJg+/8HTgUKfjAeRkUWzhtPIlSaH999Fm1Hxc
    +zgaU2WKhMa/mltdM0KUnRhJ0FufEGPos1v/YXH7d4qAmIb+frxn6XNLbPmV4BGcaBaS2a
    Y2Mv7I/P1n59bsZKp84w6zUW3YRIHNE9rcBe+UHunG777uc/OmJJ61dXX4WA
X-ME-Proxy: <xmx:QZieaq9IhWAF4-rjM6CI8WanivZN7oVk3syZdXC9bNz5UTqRJXWrWA>
    <xmx:QZieao_kSKUxkbJ5_B6cIt8WC_9-6qNw9WRbqchKmZvh448QiPRTJA>
    <xmx:QZieatJLxXZylXwZiOJDlao-w55lAvFldli0OscYsp8X6G2AiMkkHw>
    <xmx:QZiealQ_luD9NQ399_rrwYJgsxQUztRObWgkaCva94yizPLHiYQWFg>
    <xmx:QpieatF5zQfKdOIfPKeUeneKwjGUOS0B8hSLptim8GryWSzPZsvlB_3C>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 06:56:01 -0400 (EDT)
Date: Mon, 7 Sep 2026 11:56:00 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/12] mm/collapse: state what a collapse may do in the
 policy
Message-ID: <ap6XERs2j7e1lZCU@thinkstation>
References: <cover.1788533997.git.kas@kernel.org>
 <b01681c3cc945a7f7c3c7ca1de502f7cc0e93fe8.1788533997.git.kas@kernel.org>
 <c070e67a-4c1e-478f-aa28-09fb88f8a786@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c070e67a-4c1e-478f-aa28-09fb88f8a786@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: c6z7bgiq3sf537jkp4e11ta9xgejff7j
X-Rspamd-Queue-Id: 2E62040002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788778563-565986
X-HE-Meta: U2FsdGVkX1/jcGI/CWojOC2PxR8UqrMys47YQkLkGSdX5z9Qzy/ck8X6eGmvnj9seC20F3QpchzutBFdIKlMTsRe8Crm9G3iALs438nQqi9hMbf18DdnUFWHMvfkENijSCN1uienvzGGcq9b/aVDFJxmwHiZ64+A9LJyBXZW2dYXy++BRlkuC25MJT7vCJjHmEumFOlVgVoqD4H7ei/QCrXCOYk8FapV70j98Of2vFOnGWBrPGGlPV4nl8SxUmlEcbAj5oWgTONYKeArUYoHxzT2sc2WOVwQO2bH83C01kSK583PYz2bh1BJNe2snoN4PGusVHoC6UNydzLDpgC2wYfEBL3mb2iQf3UmMVhjW7nb61BBKL+uX9u00cdyZMv/4Mhc+x8DwrVOnM3Yec4yrgCKIvKfiQS0DhkfXixhuSskEwtI09tVqOh5toq67SnLEZ4KIdWZbWF8CPxuTPg89x4AyIMTdxwc6E8Z/jomL5/vmisDRKe9UkSS5q9Wh2NpmBYBu7r016xrFlLOAACWEvD5+y4MbE6UGwheq8kRByhtdKNZZz8u6cdJyobT3Fk3qg5XjrfcE+v12WforUd39V59mn88DMFEU0v0CVJEM/D0Ukm7Bx2w5m5AD3y0Vt6pSJi7koeEXEAstSqB8xdlfAgXlY6LAhz/V9sxZoo6CSnl5rwxEBznFI56VIGda6J5HLFvBQ2OR+oTXawE9f1kLwq5U+x5HJoYO/WQHTrlbSW4HG4hc8vKRBHw4oo3LD5+EqNjMxrpWNv46jB07FY5L5UBOgzeg2FSBUr/Wbltin4e6Av5NOLxsQUV+/dZBTYtXy59A1jD5OOmJofwgXVcmIRM0xChrUj377tWBrP6rk2qQWW7Tn2Jv1fTowiDGaHJJ0IGLmkUqFfaEcAdMe4q8dXuzkIw2lV6MSvJVRhFGYugFOu8yvrhsWn3ndu94K77LtCsai+W60FOKv8cbBk
 ld5nVloB
 htLic9LyaBCq033fDiTVtN7BWQKFAOjnZLjCG5nturGOckxQswYPR9NPsnp8azbK/Ol51lAQUxwB42033vf8mKDnlctL0a33kQjzO477FCu1d3Jpc8g2DV9gQMwppAq+CUtLzpM/Uhd0UExi+2eBqSehQXXh0kQ4DCKSLQExMNqu95I0Fx6cvRGoX8ka1aCZeY4psxreUbosi+/ulyda2prZ9z6RHCCruyWZRHIiNLdvPv7zsl5JqWHZXIDwjevhiqLaAP0R8UNgUHUZ2mV8BD7+3NKZL7Ol2WD/0OoS0hInrzA6Xya1UWC1BhRaC/q8dPMJEpJRtFCDz61RWrF0rrr6Lbn5f+GcvJ6o0zluSZ87KhPfhsjVsdfWE7Vi0WTqFEJTPinVkKeEN8b6KQtDSde5dxNaMjYWVFwDPT3kF6Pr7LR9jWpPmRU+yw9sc+jK35Xuz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 05:05:19PM +0800, Baolin Wang wrote:
> > +/* What a collapse is allowed to do, decided by the caller that asks for it */
> > +struct collapse_policy {
> > +	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
> > +	unsigned int max_ptes_none;
> > +	unsigned int max_ptes_swap;
> > +	unsigned int max_ptes_shared;
> > +
> > +	/*
> > +	 * Hold a sub-PMD window to a stricter rule than a PMD: no swapped-out
> > +	 * and no shared PTEs at all, and max_ptes_none as
> > +	 * collapse_max_ptes_none() scales it.
> > +	 */
> > +	bool strict_sub_pmd;
> 
> This is a bit confusing to me. Actually, the check for mTHP collapse is
> stricter.
> 
> How about naming it 'allow_mthp_collapse'? That way we can keep the most
> original comments for the collapse_max_ptes_xxx() functions, which is
> clearer to me.
> 
> If others have a better name, please ignore my comment.

I would rather keep strict_sub_pmd.

Which orders a caller asks for is already decided elsewhere:
collapse_possible_orders() hands khugepaged every anonymous order and
MADV_COLLAPSE the PMD order only, from tva_type.

A flag called allow_mthp_collapse next to that would read as
a second place deciding the same thing, and flipping it would not change
which orders get collapsed.  What it does change is how a sub-PMD window
is judged once one is asked for, and it is read at exactly the three
places that judge one.

I will do:

      /* Take no swapped-out or shared PTE into a sub-PMD collapse */
      bool strict_sub_pmd;

> 
> > +	/*
> > +	 * Collapse only where it looks worth doing: require some sign the
> > +	 * range is in use, and leave clean lazyfree folios for reclaim rather
> > +	 * than collapsing them into a folio that is not lazyfree.
> > +	 */
> > +	bool skip_lazyfree;
> > +	bool require_referenced;
> > +
> > +	/*
> > +	 * Finish the job rather than leaving it half done for a fault to pick
> > +	 * up: map the PMD over a file collapse before returning, and write
> > +	 * dirty pages back and retry once instead of refusing them.  Both cost
> > +	 * latency the caller has to be willing to pay.
> > +	 */
> 
> Can you simplify theses comments? I think the 'install_pmd' is easy to
> expalain. :)

Done for v2.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

