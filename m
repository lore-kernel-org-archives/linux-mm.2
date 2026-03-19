Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9601090253
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCEB06B055A; Thu, 19 Mar 2026 12:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B585D6B055C; Thu, 19 Mar 2026 12:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A472B6B055D; Thu, 19 Mar 2026 12:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5566B055A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:52:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 463121DDD1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:52:44 +0000 (UTC)
X-FDA: 84563406648.22.BC70E1F
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf06.hostedemail.com (Postfix) with ESMTP id 164DC18000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:52:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="p ZMPNeZ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=p5ZGcl5i;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773939162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiY88PiTkAC1sq3eRtNxrpg4KxKs+Hr6MzSOzgCjoJM=;
	b=P1STV6iuGRXdLXcIFnel37yuCjsoDqZDAgx7wKO4TnNGepB8BeMTk6pQmyCQSEI+9ADKwk
	FDdZddGE33HWm3w5FBKetI94RnPONMHGVIfFB9TlzxEQqc3xujIbdALmH4RkPsbzEsDshd
	bwK+gl3mbNZCaYu//v5ChueOsyaEm4o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="p ZMPNeZ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=p5ZGcl5i;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773939162; a=rsa-sha256;
	cv=none;
	b=tXnG54Ifh+nqQFY2A8YSnsgrYY8bPbhLAH/Zym92e9+PIiVV/oCnU0EEZa4cv8h19JkWBV
	RFTjzgPc5QzSxH8hQX9b7tmWyJaoLwcUEavzGg1Qkt7xFBgY0qp7rQ4+Cu+dL/J52vPh8V
	4CaxGoVUc1uLryfW4dZIFFSgbIkLhjk=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E95C67A0023;
	Thu, 19 Mar 2026 12:52:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 19 Mar 2026 12:52:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1773939159; x=
	1774025559; bh=NiY88PiTkAC1sq3eRtNxrpg4KxKs+Hr6MzSOzgCjoJM=; b=p
	ZMPNeZmnV90bEtC6oitocToIkV4IIZ/dROfM/0KJPQXZZcjiK/Ut/sIt2LetOsVe
	gg3YcpJjUvDUr50nZEmQAxzPOVmi05ocUAsgvA6fngkkNrBWPCTfoOJDpizIrDu5
	Lvh6SZA5sb5BWztQqKbgRJtFiKVpoqsgwnWOD+XmcdR/cawS5tYD98AAbMYIAZY0
	D3hD/6QnbCvAQdl/+dd/1W3x4lAdQ5gqUpfUT0eIEMMMhXVmVZRtvb9UlZwxCW+g
	DzEnMGPJLwCGQXEtJ+1R8xTF10Lml2OSPlPJm4aXlso5mDwr88H0qqKU6Grqlb45
	wL5Jok9LqlAO7/7xakRjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773939159; x=1774025559; bh=NiY88PiTkAC1sq3eRtNxrpg4KxKs+Hr6MzS
	OzgCjoJM=; b=p5ZGcl5i5s0qGdFJSzKRCqdSkG+0r86q71emte4hVwMHE9kga32
	YgJM1FY8xEOfpH03WDpxDSKEDiEiCXyTk11V14VMn9Bh95sfndXOeDyCa161HL+M
	0Kfsg2gFwj9d6nIdllCRomdGnTSgpoU4qLw2oyjDct8bZWGIkoHlHcrIYPgyGy0m
	le/v7fdlkTujWknTLC5d4yKtlirokiJwur9tlkbvO6lFCjcczseC6pGIevfU4lKV
	o0gVLe56M2K1IZzFao0BhJgMXnydODTczPPV9L1r2TQh8Vvi0Hzmo5UmgsdMv/+P
	SChijFgeF1X6O0Tc2ZC4k93s5lxo91lq5iA==
X-ME-Sender: <xms:1im8afL0wcFbwoMPni-lOYKOzFsTaLuJjAay8GZBuixYMfdTpc9rfQ>
    <xme:1im8aQxyXroKSf2KpKoUezASimRzrKpQIusKO4dvHkDNfk-nexEw59BtrmyeCZqCU
    S2vfw9blUWwVdt3MCdb1sXe8CyQz9WWtWtI7swifeOe4ZTkzk1uBgs>
X-ME-Received: <xmr:1im8afHo9Y62kvCR2WFiJBtMnAsK-awb0hMVQ2UK1IH747XKUm77-gmBn_sWuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdejheegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:1im8aQmBUFw62vK087u39ZUODslcuxh1BKUCRABjeVqlKxgcMT_sIQ>
    <xmx:1im8aeG-aG62ETkF061qEPOotW0ZHWp_wq8z7-4B7oYHsoZtZ-QbjA>
    <xmx:1im8abzsEhe7xMmByzBhCO8lIpOMWJCoOGS_R64KB-f0dyhnpnAEaQ>
    <xmx:1im8afb-7SN0000k09lAn7Bq-z1ty_SFNpiUzMB1SJuokU_kEKkqfg>
    <xmx:1ym8aYJ_rC8ODv2HLarQhvdGHJQD4psP6GF4wd7-MAxh-bmvy4_a04rr>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 12:52:36 -0400 (EDT)
Date: Thu, 19 Mar 2026 16:52:31 +0000
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
Subject: Re: [PATCH v2 1/9] mm/huge_memory: simplify vma_is_specal_huge()
Message-ID: <abwpKc6PbHiqQRg3@thinkstation>
References: <cover.1773924928.git.ljs@kernel.org>
 <613669b1b2082d34f5632907003ae3874eff2ed9.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <613669b1b2082d34f5632907003ae3874eff2ed9.1773924928.git.ljs@kernel.org>
X-Rspamd-Queue-Id: 164DC18000B
X-Rspamd-Server: rspam07
X-Stat-Signature: bzcf33ka3nn97s1tp71d1apyynrfo4f1
X-Rspam-User: 
X-HE-Tag: 1773939161-10255
X-HE-Meta: U2FsdGVkX19kDmvHCkDTZo20GJdbcKir8fkwKkOVxpKLIj2nFaG66VA8h3lWuYB/g3v48YGa0gMwIBJokMd3e00bmabXcLnMVtxDh/8XX4A0ylT0eqQou4NJvBwVgO9NkuIWv4uFJX5Qw+NuW4gJ6riSaWmjdwPOPt/wWD21VXPeGxHjLCHauE7GVYa3bTKBfVpHXyJ/S7wJecYFMywgfxX2eVCiwuTIZa/YYRpRYOXK9A6j8b+lTvBj+3HtonbAmOAAmxYC/MZ5yDsX6Uq1RexXaOEyx2V2VJF66ZFNrl106xMgqIiL2ramRE1w22fLrtz7CNXk1NHB6Gk+6EDCavHrjMwaf0fK2fiHqP+fBauQ8Pr4eBra4SYHDXIb0e4y3GaP1ExJQ5MMOLbj8wpIzdXee2rbzLsCrWhPg60yaSjTxJIRFvhP/L5lZ2CfhH4IZjRXkV55khGNhB2i3v8YGybyZYA56Q+qOBd2Dm6RAYWBWrxVkCuRzh4cpxUAyA+anZLkAygq904/q969nFf6U36UhSmVrKm2Lb3Dd/e9kLYon9cR0ZLmZJXRZ6/GwsNHaUpbCNKgVzgiLOHJzF7zJlxEAQXOTSfAMZ1cqgKGKkI5vHx9l65g/rx+K8XE2cOC+Oe0j5fZNQlbcwgefWw4Dgyh9A08NIbnoWuaeaCHwQxGttKi5OmpGULA6Ferfk5avRTrUsZ9+EPVN3qs2npLLlyLa8oAm5Ca61e347uDt7pZDk0AFnDNYmviHrUFgxN5Wo6ZM1Jo8wUo5JLf9fQCnTDzWi3oFHi1XxkYOxjNwCH/9q7rbdQoJgihBOP6rmWn2CkfMmtKIde4F9WR/V0JX66+FgIt8kNSldyttDPHZ5/1ISRxeTzjT6yZIwVrc4rs0lNXQ/uV18B1btEY4Dg+e0yFg9Jjmr7r1QPdrC59sgEpWRo7C/LFy87b/QsDy3pKtd16mpJ/SOHZlvjO8lu
 IXqnzyX0
 yIwoA1kioox5+PT4vxA+aYkKNjXuHLyTFN4oLLbNIk+rLPU26bPPTWdxGhcF76TTJcQCPxz3btbmuUdOcWbIz7o7F7OGFrUctSkmQEL1KpeErtB8YWVAc+1gefsS7DJF0J5xhc62NU1/enBReYb0O8YdHaNnx0LWG3zKs6Ce3SlY4QhUAbIlC9FPWct3OzsLDyzfn6K2hkm6hbBkkjHDO0zo66ETg+7xywdtEBLLkB/lc/2Vd1cqlhHXWwXd0MfXsOQxO9dL+sFNYwzfaVEFgSy73oWRDLtza8w/iqYw2AOe5lMseTezQGVD7aXCrVic3U3mP5V2ISP0x4h7bnAyS9OqmDzQHukJu/tsVXLW6rtCf34V+uiiw0R6phPpQDf7UPPuP/pE/ZjnXN1IsnB2aUdd2gHx9ztBvkSbDoq/+1VeZYtd/53WRfX4LFtye+B9RWNO3SHkmC2I+uflvGYXU2HcGm2UYwwQwoiz2zmPQL8JjVig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 01:00:07PM +0000, Lorenzo Stoakes (Oracle) wrote:
> This function is confused - it overloads the term 'special' yet again,
> checks for DAX but in many cases the code explicitly excludes DAX before
> invoking the predicate.
> 
> It also unnecessarily checks for vma->vm_file - this has to be present for
> a driver to have set VMA_MIXEDMAP_BIT or VMA_PFNMAP_BIT.

What enforces this?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

