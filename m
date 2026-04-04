Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9ADAE88D70
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 04:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F4A6B0005; Sat,  4 Apr 2026 00:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0016B0089; Sat,  4 Apr 2026 00:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5C36B008A; Sat,  4 Apr 2026 00:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC6456B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 00:57:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B9CF1A07A6
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:57:03 +0000 (UTC)
X-FDA: 84619663926.13.A8B1B59
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7739B140005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:57:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="AeXI/xXU";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775278621; a=rsa-sha256;
	cv=none;
	b=bMDt1pdXhKY49voz1p3+5+KbFgC58yn4rj7zuuqYszNszLPI1K83VcLdcqVPePC2pjHnh/
	GQ6dCCaDiQ6B68rnFysWQPcwri6Coco5e3Cmd8nsdKTZu+pmCJp+KDxle3WBbZujFjK4m/
	L5piLFfOW6Y6D7+ngccd1TwVtUCCfgE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="AeXI/xXU";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775278621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgw8Wj60r42pOFY5siLpwGwPlFHXm49nAzFlyKb96kE=;
	b=rltaUVNwEjTpQ2OgPrwOUZkU0L3L40bsFh4WoOS/Ajk/vVufnLh2tAibCFulG950iXqMMN
	u4o5RgI3G7QKrJukcwmRxGl04/ISOy0q1PcguzWRxP4fahBMWyqEe40M21EhFcHJ6m4U9D
	yoWR9OG0gfu1ZkUFb2CkJIG4BsqiEDU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sgw8Wj60r42pOFY5siLpwGwPlFHXm49nAzFlyKb96kE=; b=AeXI/xXU6jUJ2aqueVw1zo1ch2
	IzYDFwm/ZFG37UTIbOii+YOAL+wVhmJUJ3qoK0KfX1HHQRCgLSEReehfypZIPjh5setCCqsaXok6c
	qDa5l5Q4S83P47f/rWZkgvZKpi+nOCVDQflPxIbCAO6XvbEEokHM+0kohMcpANNF6KHjbpRoEsK/n
	AEqVijqozTpaZNqkkqFYshaw2moYjMzZ97E0TNqff512fpyerbe5kcFdAWgSGb5mRxvL/n3aN38LI
	uL6SIg0S1y26gPszBhuZtEEz8PZmSSkpq01TC4W/xZwaHNXCgxVTb+JVZ/w4zCkt24dKHx3j4mL2i
	WnO/FJ6w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w8t43-0000000FVB7-1rqE;
	Sat, 04 Apr 2026 04:56:55 +0000
Date: Sat, 4 Apr 2026 05:56:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu
 accounting
Message-ID: <adCaF0jpayWn6-FR@casper.infradead.org>
References: <20260404033844.1892595-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404033844.1892595-1-joshua.hahnjy@gmail.com>
X-Stat-Signature: gfzf6oxfpdao57iq85yko3azq35h4duq
X-Rspamd-Queue-Id: 7739B140005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775278621-513892
X-HE-Meta: U2FsdGVkX19zZh/8r7+fNijpCe7PqmroGkfaYihPx9oXbdfiejcq3m0g8iKodPgWjUgPeKEsMit6c2VabUkYrYUSRP4Gn0wHS93YQnOlR4p6HVUW7YCaCd1QiZQ26xYuZ/Q9BM19gcm/jC8Ns1lJoVqgMl2U3G99KCPYk8euobchsPXSTT46goIJRdXbA3BmO8pXE1ErMJWHXiCAN/nO7RsRLzp3N9pxhibJnMTgsPRc84YO5XcBQvYcZParobQ8omN1di3AWnYa55smgtKGlPI1FV/6+0zNysNbJFT3lY4/xvfVDqePpcVqH0Qn9ODtRzRepwYyaWFUkaVEVZUwn8F0+0Ml3o+477utbkTAjLjCRrYIr3eU2mxYQ4EvgEUmX287yrf8vinvfq1T0ukMJRlmJnz2Mv2jwZHlgxmIpnodlrTx1MYnxOBGAfCEXmqpbKKLwC29c039I02NE9Ne2uAvPYltz3YBI/4fLVlybnIqlMTknQS51ElYs61wm0xjx6UgUspzsqaHGMTJEOIuFPnAKeC8MlC5JtGMXBQaAvAzQkedzr6GqnDsUeDQrA8db8KcfSGA43/2zvGL4ZBq7p/dab8sy5mufHT/j+5BdPZWyMII7P2wd2MxnT0CTIzO/Rn8YR6XvWT6PD+YH12YOijwY2ahump6IK/FrwoEd5yrglB8pgTRjNA31zcUzghx8Y97Mj/lxChuXM8cZq0FUMmKqKO1OWlCY05dAgOSXSNF2FIJ9N4b5m3oXkWhqsNuvxvmmoOVWaVMLHZGEurwBfgDyMG1pCVqwSt3qatkq5k3epClUsUhVUsNy8j5f4FX9zOqyWzeTe+PDg5fxUnE/pLGRNNbugNOlqKLSX8TRMlWqikXmEdgQ0SAY0bgHs9hIXJENGM6dDENQRtBILwVH4NyJrHSf3qDqihRIVB61wl3FuGCcQMbyUyQn93BA8ndR6fIa+ZQhju1ykv8635
 hO9pfP7j
 GXfE7zNkKM2FBcYjfxV6C7i2axgEmG4gz+kQlr9HRYiZnqRHd4atArJ0cZxDWHLpn3BalwpBY0ucV1fwM0TtXdpOv+14BNMKiQB8KQbUejAWaWbwoEWaHMv27AQmixThubcTcCuZ3NpPl5xR9IZYgXQRzwL8AZm2feNKxJbXldh2OnlAWMGlii4delotYlpk7af3XTgjC4LyZ6evLhzZ1438BsFlxsUeycaTkp1GG/ynwdzSPiUOf2hsAwHIa5WMdj9+XG+pNcpJI1rWLieTMWZ65flkwWdBv0f/Oq/rrpJOnfmMNS158K91TFlzI0sbrhabk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 08:38:43PM -0700, Joshua Hahn wrote:
> +EXPORT_SYMBOL(mod_memcg_lruvec_state);

What module uses this symbol?

