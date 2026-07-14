Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A2FEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F294E6B009B; Tue, 14 Jul 2026 16:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9F86B009D; Tue, 14 Jul 2026 16:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17876B009E; Tue, 14 Jul 2026 16:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC2816B009B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:02:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AECC1403AC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:02:58 +0000 (UTC)
X-FDA: 84988455636.10.A8397D9
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id 85D4E40009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:02:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dfMb2v7Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuIl5xuy4TZoJQCjWgZF0VALuE2V1cGmxxoJ5Co9yXc=;
	b=af6bfXpSC7o2E9+57kMenmqpk2FpXLTYIAu8D89Pal+b+B8aB9zjAx+nwKWiFLy6c4j7bK
	LI43ADZEYJv6/QgPes5U/Iuu3g6LL4KwBE6+UeVKK36kQu0VsMW0lmESFX0t1tql0P6H19
	NpDUFnOb8bAQdwnUMVS6V7eJNTX+d0U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dfMb2v7Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059376;
	b=KITmYQoZq2wrA3aBb4CU8vsZWQIPGXb8sk1eZxJwgVkRil9lLBk8wIROzFUwcya6ClJOJv
	xDa3t4V2He6KrS/Rm01AirwS2RV7N9NUf8NnsVia7iSAOH4f0j5y2NPsRdfbY3ctjnnNFX
	KGe6jzLqVY0+4O3m4t0HErm5zHTZhbo=
Date: Tue, 14 Jul 2026 13:02:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DuIl5xuy4TZoJQCjWgZF0VALuE2V1cGmxxoJ5Co9yXc=;
	b=dfMb2v7QRs6gvUh/4AsKzjMa0nEeQQwr3az2MHCdmRUrc0jVbYKAzo/608o82CGKbaVBSW
	MHOK0lRA9g15VEPCl1ToGduRGEn4buZl4cm4PkrJkYZmsOdVJl1X1ovJA3F3NXKm5DnUAB
	e8BdVXDhs0eL77rZclJyYfEAJHLnOo4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: factor out memcg kmem uncharge sequence
Message-ID: <alaVzJ1OhSSgD6hY@linux.dev>
References: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85D4E40009
X-Stat-Signature: 6zrjg71e3dr6wnmeoxoegggnn4oqywa1
X-HE-Tag: 1784059376-238776
X-HE-Meta: U2FsdGVkX1//9VOL5X7BxVgHSV9H6eyQSIrZU69ePHeMGFJ96umBYv+DbSwBcE1Kn/ld5O8tVQtW3lkJICVkJ64FRwAKazeIoqhP2uFkdOnfz15cG+MYf1UJ5Y33eUi8PmGXm2sC+S1iH3SSB2VC8lhM/2PzVlaU66/UybpLgS8sd5vnHtSarac68UJrFzE8cTsaJDnl5nBbXS8yvMcdvRHlBycImmHEqISXMTX5E+vQdo84iTkRGHJMgkuEvO1c7vB3ANkcXcYzYxEm20p8u/fN9PTKiN+Vxdczy+9w2jf+a0nAGd6KHOifoJsC2U+NPS4H8ohvKJawY5rF8Fr6aGVAy3HnwJIVL0diah7TY7hmsdDTpevd0EBw6bRRs0pS0hU85cDLeGsZHiqDVB/KnsKVOOGa1JOFumbf3rCPLTCL/s79kqO5QmhdZ6d+Np2Y0mEQY3RJQeNZwJhL+U+lD2dj3Fydw2Z3CA9jN3dV9DAfeIZ7GDJkLLmtG98gGdVcCO0QPENFxA0OaM83YJXVGtxqq9o4D0g6XrUmAZIBeCwFwBEl84NgIWxXMniUbOIlOfwIkptKEJG/e6rXBu7JH5KBhqy77b8JMf8gYHE4fbX3ezRWprXRb+NtQPjpN7AcSiP5eN1LlrmHMMed8BzkxmlfX0qL1wIJRhjlC7QY5sNA/TbiNqjtqLFKUsz7gSBMnDMcSs8pRUiL0pP65izerwpfDBh97/5BC7HlbXEBnAo998sWM3Em0jBnnzIQOIpaSSdM80win0VaLssR1VvcLymufY/HDt8ean7gcsdij0cHcWYXgNXOMkfihWn4PhuJ2PUkzm9rUjvN3wPQZ2gIWz7Bfn3l0Elaf/zHJhAiuxuTfW41BVGumBhE7620OfBPZS6WZx6cnFHekKfc323KJjwtgz0Ywd7Mk8sYFEFcThZkGAMZyiYHRLXVITEdvKAqcRgCmGRUKxMxMewArVR
 07gW3uT+
 TJJM+CeBKuHqL6rS7SdzqipJvPSf01eTxE6sRCaiVYIB1eDgSup4iNKSOopJlzv2UnS2/CSFk+NmmVJF/sYE0Fc49E5j7YbaWb56D6YZJFiHqLr/r0ZCWUPZhwCtchXEKFVfBxRaJxHzplKI94z3vz/h9yMRTcoEzMePq5Od7Z4nqkZQL/JsynVuqKk8jLoSioPG8zmWgXobNZ+f7f0iO8ce68g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 05:03:04PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The kmem-uncharge sequence (mod_memcg_state(MEMCG_KMEM) +
> memcg1_account_kmem + conditional memcg_uncharge) is duplicated verbatim
> in obj_cgroup_release() and drain_obj_stock_slot(). Factor it into a
> small memcg_uncharge_kmem() helper. The reference get/put stays at the
> call sites, as they differ.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

