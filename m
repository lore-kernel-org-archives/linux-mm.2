Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E5AC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 15:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5026B0093; Wed,  5 Aug 2026 11:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BC96B0095; Wed,  5 Aug 2026 11:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C4B6B0096; Wed,  5 Aug 2026 11:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0946B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:15:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16FED1204D0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:15:29 +0000 (UTC)
X-FDA: 85067564778.06.880CA08
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2D0E41A0010
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:15:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=CV16dChQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B rkCumc";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785942927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7ZkDliwRfxhvVTQMfE6v/Ojz2Rmn9+34DO9xroTB1E=;
	b=thPW6AT/xMTATD5j0n/lVUNqYY201qxMc0Kv5MFSfvc5YJ9C1Opn0U/4YrhU9g2xp825IL
	8kfNiPU6w6M2kU31VywUCiEmGql0byTNPZSAJI76DrpltDKA0cQuP4T56ReAk8VSV2af+C
	tv+Batb91CoHcO8Cla0c4hINH4AMx7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785942927;
	b=7E2cR89VpD0XxHbDql9RT6tntDxQ5z+LWCZoo0xOaobnch6cXlw2urlptlAD/JFqxj9WSy
	SmL1/eRzN6+nDTp9koaM6a1z+i54nY0UKw/ZRWkpDX8uuYC8BIe3oww9JbGTy1SOuyuRNk
	owiIUlydCGCySqiPZccP/tzItzGJ8fk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=CV16dChQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B rkCumc";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 77BBF13001B1;
	Wed,  5 Aug 2026 11:15:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 05 Aug 2026 11:15:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1785942925; x=1785950125; bh=U7ZkDliwRfxhvVTQMfE6v/Ojz2Rmn9+3
	4DO9xroTB1E=; b=CV16dChQ5cM5hNAW2Xpz1qNJpSQFxsNzwTScqiWyrQlluc/E
	ZFKqQczPOSUsA9Vxt5qXDBq+ApY6rJ/BXHyZRFyljNZhcuzlUCOQ7R/G1LTAEhy1
	IxA290pnEXJ6pqnNcsxpX6wKjG3fkxc7adu5yGhxTGBxM4CYVpswo9bizhNqOEfM
	BwZllnnVo+1mj0jiF/JquD4NAu0KPERBz2xnfFig9serGOpFnz/VfekMThWJhiy2
	xVS2nGmHfb5EgLmRZob/+XosVo92W3Rquq32vl3nmcRE9lIt2cyuJo/s/ku2q07R
	zRWE8V1VVoicdDIAFPuPxBjEb1ApFbQb8TXqag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785942925; x=
	1785950125; bh=U7ZkDliwRfxhvVTQMfE6v/Ojz2Rmn9+34DO9xroTB1E=; b=B
	rkCumcSu1eHyLBD3L8/6qpJ7NjR3/c4/OP8fmym4j9kyI1dyDFjet/ZYtmcQe0fM
	OCSuv49cCjdk2oOd7I1d9Ahd7qwjRbEclDLNa5gI9/iR22zO4zqRR96O2Rh2lTTE
	LuHSf5KK4K4e7k3eAPJkn4XQv8iJISND8X+PjS2CBwMyw37NK6Hrqc2QPhoIDXc0
	WgJcg9x1x3vGSFtLad1zHVdH/InzfY1x9c89LtNnI5SszS3fyMLryGcB+KsmOUzK
	bv0HwcHFM5iVitUq/CCDWmVEqmw/+vkHaePSVLCOpbcdASPiJYNyOgouw3R1bM9g
	rwE9wQTO0FClXfmc6aeUw==
X-ME-Sender: <xms:jVNzapcFQGW0a4umdWMy8Dyqn0wCOd0Zx63GWgSjDhr-OMpV4Q2P9A>
    <xme:jVNzahept3Q22xii7irx8XCYvF9Nv-u3z8VopB8FDyDbfXhqlNuuDqQKoBRXpJd5v
    JCelOpuR5z-bsnLWBRlnVCf7SPMbiTQTQ8I8tFUyP_1fCAf-QF_7lc>
X-ME-Received: <xmr:jVNzakR3U3R-wUnoX4cHF_6onJ-lPSmUfBQX9BZpsN8BhQF_grIfOnRApkY>
X-ME-Proxy-Cause: dmFkZTFHKfj67EM/RMXyAf8uRwuo4d07TxotiadWQn4kDCiLCwUYzIuTbRY0RQpqX1k6oT
    WhTK1MOY3WugcZC52K6LXS1Rl3mBLj4Ydb/byy10WXX4yQi8pS1xDlrsOpEcGgy7a7AZoi
    98lQtQp6JVBcANtP5P0BIFc32itP8/jhbG2tyfi2fKtKxnb9ghmdFsDUE7bqwkkR7Yvw0l
    i/G5WnwWrqwe76bY+cx4Au05hC+Ivxa14J26Fgx2R3u+UI2ASEvRk5kw9iNsEtAu/rP6f2
    MVh/CfN4p4xRMbrhEycC2/Kf8tHkS7P0O/aL+LzcQiVtX7lqrcR/V09fdS3w/RWkCAdIpb
    i4lsQQepRlniLqqftZOHcYZ8KgDi2xU8bSle35erJaDDYsFmaAURN6wGQh5U7B4XI04Uso
    8X1i5GlrW84Sd8Akb0Uk8/qfTHSEHdXmn4DhzmoVAFeWBlq7TqXJdjxXE+97Gpyr5GhFVy
    nMrucB/VyyG5aBahifVcC+/4e2cw9da0TU23ve+UKw3DkTkdTfSDv4puLLPVP95se+oflH
    NYELDcUsbrfkctuBFqs8cXsupQ8mBdUtiA1iRYeHhBpa4i2B1UZXSL7EwDrM4LLaCL9a64
    MGJTxaWsmwawyKe9I3H1xO5E4+Lwqo9kuAeTqnmIXerZqi/PgwsvLc3rDZpA
X-ME-Proxy: <xmx:jVNzanglh1oS_QB8HX3EJJQCK94KPROnnypZQyqOnoiUb4wyIk4tQw>
    <xmx:jVNzaoplAwdiady-jvq_6NGkObtaLgMLr6Ej4ThsxTRCwewm6MGSvw>
    <xmx:jVNzavPOdAz2PEl3eKqpwIMCVtCYzbSuOujXd-j3ivnrZHBmScmQLw>
    <xmx:jVNzauZ9ixV-ySuyac-A3FHPvJRcpnFyVm93EklMeNSvOuws6rE-aQ>
    <xmx:jVNzarB_1VzbTWyZx8QhvBUG35ENdZ-8Qc3KAtl4QIXut_m5ZoUsEkm->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Aug 2026 11:15:24 -0400 (EDT)
Date: Wed, 5 Aug 2026 16:15:23 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Nico Pache <nico.pache@linux.dev>, Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Hugh Dickins <hughd@google.com>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] selftests/mm: improve khugepaged coverage
Message-ID: <anNTWtDac3b-u0sf@thinkstation>
References: <20260802195254.1937477-1-kirill@shutemov.name>
 <f9f01bc0-490b-4d06-85a0-e4693b80696c@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f9f01bc0-490b-4d06-85a0-e4693b80696c@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D0E41A0010
X-Stat-Signature: hd44ggatybfizm5g76bask6rc98pn1p6
X-HE-Tag: 1785942927-406182
X-HE-Meta: U2FsdGVkX1/BE18KVJvJOW21zTuVXdeU+596r2hqrKodqIcdsUCygs1lJHVzuRHsRE8eup93lHXzRrqQOzeQ7BrhCtNXkVJae8vUrKzcn/GhCjEZuc0ShGUWUEVjWmoZwzNxIGnIdl3WFN75icuA55u/BED0/ZtLTbbnAhIpiJsJHpglw+HORYr/5f0sSS30Xka/oE/ZFtZPKXcjD/WPqGJ36UYA1LHWfwMbiS9LWYAsF1ovSDelGEdXalObLWiyOPOOs+IseJ265JCRLW4LbPDmN7rIeXL+DrdvrtPfMrXKRtL8ov56ydE3lVHyZ2PFl10b/He+1GwtCuohMERFj9zPHW++vZGD2r5ekrA6Ybb4QIsAp1jRNNEggQE19+3Zo3GPhpUPqSAJkIYNySi21rpv8sVbbyk7cTEqIZ8Acd9Qrdjt5dpC3YpDYJgAS6N4LxbK2EifFV93aMBIU4DwcwJWXESAnvi1R5GkvYdNflcDvltcvLwEjCNF6CjFYDjNPlGFQgyvHe2A1orqv793ddQTplUx1MC9L5TFb1+9AdLyO1Z8zznLl+udSYPMc/fof6eWWLRTWBExqaUjLbZ0sQg3/vjwore9ViHZRLPL7SKcpBvoxrn0WBqtd08lWWB/pdj1zmJDJp7f7gBEIT7dFKZeTPyrzQdA5Rr6DWwEEIWGAkQABYCz/BS2AZtZp7gp1zwPNncxGQhiSuNNPjHvSqhsV3GDi/rtN9w8LB9pltjwcHovDL7bajsFy6O9DrlNELlffod3ClZz+l4fVjhn7c7ceiuHN6v91WL/WBZ11nc8iz2Rg316bWi3Mpnv6TWx/gzdr/sN3vy+doNhuO9kGXroa7xjMnmCdO/dWP/FE+6Qjpi8EL+CT9gL2lAm9KHp+j1l8to/ZwFl/vJed2CLV1MvL7R8y87NTlsOoBszZLsAEhNqHozjEHwagOfjM7X3XEuT1Rxl9/pdk8mJr8r
 OZzIDhY1
 Ned7d62nVrGxToxXxTG4QuVX6Aq5ISaq58+k2amncX5+WJUzOudTENLvgYi5wcWREdPsLsdNyBbZdHxv/bc+SKaKRSUK73tRl8nOYaktRrU8JBNvM9cvGz2ekgcpzyvc5TX8sOHsStss4sIFnPeEYzGvPThBK8s21RDNEc/jKLv5EZVQxNuK+Qg3JU0F/HX5KoJXWFYhLiYtH1onTfFAlM0W6j//Miqe0SLd9APXOS2i+deTvSjk4OTOasVAujgc/DVeoCfF5+HtuMdRGhJg/Fam/rwGEXCOiv657u1Okr3AIrN/sBFDV60yAtQ/kGWdm4UZmlxWPBHgNaf1dvAGWaFZHR9NrpbfgNugx/LzPKRuCFlSZXICWcWbvfaFWgqvbFXVchd2d1n/ODjzk/AMErccnMK+30s+iSWW0llyGLWNZQpbS5Uu6G51nAabSy+5EMS379UAUeBDIXZBFuGWvvNdRWz2UxGopMCR6NeRP0ePtBJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 09:21:09AM +0800, Baolin Wang wrote:
> 
> 
> On 8/3/26 3:52 AM, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > mTHP collapse went in for 7.2 with no functional selftest coverage. Every
> > khugepaged collapse case is PMD-shaped, down to the detection: it reads
> > smaps AnonHugePages, which cannot see anything below the PMD order.
> 
> Yes, I’ve already sent out several versions of mTHP collapse test cases[1].
> Not sure if you’ve seen my patchset, and it looks like some of our work
> overlaps :(

My bad. I've missed it. Acked now.

I will rebase my patches on top of yours and removing duplication.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

