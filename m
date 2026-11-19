Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E3FC606A61D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hui6CRpH
Received: by kanga.kvack.org (Postfix)
	id C79326B066C; Thu, 19 Nov 2026 12:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C299C6B066D; Thu, 19 Nov 2026 12:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40406B066F; Thu, 19 Nov 2026 12:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 449196B066C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:12:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B99501C4659
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:12:50 +0000 (UTC)
X-FDA: 85452513300.22.B2C9E5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5F06D4000F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:12:33 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795108353;
	b=JzBQA7pIvL+dYJgY5qG+cz87iOF19J8413NZQEqralpDOLA7GQ8oWUc6h4Pmt0UXT3ESXF
	BEW13Tlf553h2UBCy74OnHll502Y7fNSBjKSM4B8ktLa3W1CFvxPVmwLBeMViniiNj1y/j
	CUJyo4Nl7VkzytoVmN4F32Plb9xgsco=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795108353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5byhV97n6P3OBfGuLDvdezO+quTywLYBChMiMmstwM=;
	b=k4mYePEP3i72mnQmsPW/CWlg/EUtcCrWNd19OVDNUfabWaGPt7uPC6D+zabt2YjmiuuUN/
	iIGqV1aL9I/grnFC2JCueFXxUbtpaFnuQpzKcRsJ3ZZZcMw0Znm6xiZ1f56YAOWbZKPSsH
	85ajMcVhJq8qnbHV31uFFSSahk/MSO4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hui6CRpH;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 854004422B;
	Thu, 19 Nov 2026 17:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96E71F000C5;
	Thu, 19 Nov 2026 17:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795108352;
	bh=O5byhV97n6P3OBfGuLDvdezO+quTywLYBChMiMmstwM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Hui6CRpHqGNGxr5oPed/8hLSI5FAFf8smhFqWGEzeO65nkP2/gqPWEh/wOT7IOl5T
	 jPKDvKHd8hbz/KKTZQ6x+4vz4bONaOonPX75U+uUSI9x31wwAYTCONHOWZ2WaCNRp0
	 cmu4uF335ewBG/Iq7JkMw8KEeiWx3K7XIAgHE7WG0wK3/HixUY/P27J2ODwSw+g+Dl
	 YplXojF3grj1QdqgffjCClxv4tnFyjY4KEBV8bmKLqhUWyvQ7KFi8r917qanOmlVgf
	 2939LiAPdDLBcX2MPjy0JEag2cEXxZMuC2U8mA2f0wmN5ToORsAYyuZGjfcf243IQ4
	 PbhdqtmOZmf4A==
From: David Hildenbrand <david@kernel.org>
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jingyi Sun <1045704958@qq.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <tencent_69A761EE2ABA6F15B942EBF0EE686B2DE608@qq.com>
References: <tencent_69A761EE2ABA6F15B942EBF0EE686B2DE608@qq.com>
Subject: Re: [PATCH v3] mm: shmem: limit forced anonymous shmem huge orders
 to MAX_PAGECACHE_ORDER
Message-Id: <179510834962.6900.17066358141269764658.b4-ty@b4>
Date: Thu, 19 Nov 2026 18:12:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-HE-Tag: 1795108353-891706
X-HE-Meta: U2FsdGVkX19Qokp/I0qHv63nFhMia5+gsSgPpQdSlMLSN60kQNC2NrZWcwrAOKh07Nq+TgXmbVq44blXdDSWYJorLRHBakYJjxMAxpzxpScsnbr1wOcDxgukLsn7Qt1T3WU1Jv3cH6541fEvm59nO0UaLPmPa04bvXvJlPCLACRcYJDJi/quVao0m4z2Gs78TTaHsYmvRfvtZBbdpF+6Ts+JfgfUdP7cpT6+1skvCazRPY1kdmRfD8CBEfWksc7J7kI+0utEwsZOGDOYVuVKmDDMztAVyGlZEMRASCjHqXXQoeG6C8UyMuZzcRfC422BUMcktnrdAx53aADxsu7awiCxtGIzK3tDG+12JS2g35NrL625lg75nyz8FFTQosc4fDfco9vBxN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 18:22:07 +0800, Jingyi Sun wrote:
> When the top-level shmem_enabled knob is set to "force",
> shmem_allowable_huge_orders() returns huge_shmem_orders_inherit for
> anonymous shmem without masking it with THP_ORDERS_ALL_FILE_DEFAULT,
> unlike the other return path at the end of the same function.
> 
> huge_shmem_orders_inherit defaults to BIT(HPAGE_PMD_ORDER). On arm64
> with 64K base pages HPAGE_PMD_ORDER is 13, while MAX_PAGECACHE_ORDER
> is 11 because of the xarray split limit. With shmem_enabled=force, an
> anonymous MAP_SHARED mapping can therefore get a 512M (order-13) folio
> in the page cache. Splitting it later, e.g. on swap-out from
> shmem_writeout(), triggers
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: shmem-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm: shmem: limit forced anonymous shmem huge orders to MAX_PAGECACHE_ORDER
      https://git.kernel.org/mm/core/c/a0dc4b77

-- 
Cheers,

David


