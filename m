Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A47606B25D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dCcG2i5f
Received: by kanga.kvack.org (Postfix)
	id 836A86B0685; Fri, 13 Nov 2026 05:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C2F6B0691; Fri, 13 Nov 2026 05:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4DB6B06A0; Fri, 13 Nov 2026 05:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 353F26B0685
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:51:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A32BE14044B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:51:43 +0000 (UTC)
X-FDA: 85429780086.23.458EB00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0239310000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:51:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dCcG2i5f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794567102;
	b=bZWbxtCVHK+vOR+h3hHe5DlMQlz29r2MIIsK1Yj+LWPrZVRVmfAvhbMY21xPKcbCGapZAo
	g1Eil8M06HJ3BLWGAn1pZ3vWHZRUqfbZbibl0paBmd34V65qVQDn2CuwNhbJgKWGUS3sSV
	2xpUPfHq2tyqhthWcHup2OdesV23ghs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794567102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EE1wdDV3l4vc6SGBux4/xDk3zRZe8hWDSeaRMrJ8Q8=;
	b=ANfW6xfPO80X0jyvjCyzAfxepHsdFrIcSmfIAVZSruSqgycPIGu/c4ZR15jMWYw2mGsEL9
	/IyDZis2HjWqGpusEU0AmfMZQxKwDhFewDo0iDCT7ccMM92zbBYiju9D+4EaYkA6hWHn1R
	b3byus1Jr5aW9cveBefNpkRJM+4iUtY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dCcG2i5f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96528626BB;
	Fri, 13 Nov 2026 10:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE3C1F000CD;
	Fri, 13 Nov 2026 10:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794567101;
	bh=2EE1wdDV3l4vc6SGBux4/xDk3zRZe8hWDSeaRMrJ8Q8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dCcG2i5fW9HPy6zti+G7Mo18ybFErglRsGv/muyQHPvQTwch0Q6GfO+V0p2B1JccS
	 FW1pWmIoNeDlpnRBwAO8RrkPYOwirzHyDxZzbe0K4Jf5or2cLaLVIk724wccyd2rVy
	 TyknkPAWnVUZ7xQQlB5DIlbc9ckd+39TfM1DxaZgB+c6+OV4/tGyvfY5UkZObxxHrX
	 rxwVzSEG4vpfb52W9oYc5UqOCCRqYQtXfX838LYXVIp6m49/bvKAnc94j59kzB+GQb
	 9gWezpYE/tVwJHjQawhn4Zu+8wZVZkuexQzEBec3Zar8oK8iOIEld6DiNHgEfkwjMp
	 EcGB4jeTKFiOw==
From: David Hildenbrand <david@kernel.org>
To: david@kernel.org, kas@kernel.org, hughd@google.com, 
 akpm@linux-foundation.org, Wandun Chen <chenwandun1@gmail.com>
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
 apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261113083927.2727599-1-chenwandun1@gmail.com>
References: <20261113083927.2727599-1-chenwandun1@gmail.com>
Subject: Re: [PATCH v3] mm/migrate: improve mlock tracking for PTE-mapped
 large folios
Message-Id: <179456709796.6844.3779042426492180260.b4-ty@b4>
Date: Fri, 13 Nov 2026 11:51:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 0239310000B
X-Rspamd-Server: rspam12
X-Stat-Signature: zarg9pqan6ekgns3dpdfd166y1r9e7j9
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794567101-46114
X-HE-Meta: U2FsdGVkX18mmlEGcJcSLvnvTXVH70wBEsOp9pJFX7XWUOZ25Dl89m7uOjE7o6JU95hYt2aHezSL9TcMZfJhZTjTsmwRfabJUxvUPPjvLJGFb+lNBc8E0P3ILJ1rucRhWaDszxI98jJCNTInHq3SSGiAfsxluDUwoCEPzHZf7gwE/Ct/VAZrkPMgPuAWNqiIQGAcXyfUhAesRkUTuPPzYUHhawRvHI85noqRRuL2si4pMmDns87cobyXG3qThHPevQHJXeCLL5oqSJ0/paZoPRdmAMVAh6SL+ncVYI0iLYMx11vm4AZysqJugrqTCYQQAtJbA1qsK18fUd3j7oXWzdvSioMlxy5B4JZKn3p+9AHTnAgehOOnf66kphuZHfc5X56XkZo7Cx6aL+2hsW7f+0wv9l4MeAQkiypLVbgbbaMxOi/3Bs7xolDPSYwIrFcNdEbW6mWTYlTA4+rYplDqzyxleRVgBW7Ko5B9eZ3DNpKskRSjh99zQycFqv64Bma2L/gpRhlBlMFjSxZfWOjH66zO3iaQcANQX9FaziegGMJqAQI1GRF9Om70qUOH/fHqVJ4EVzwEuxYCK3qLRUdE+leAM0jyWFonFyuOBV1Upviy9TDyb8xqj/fpb4RrHElbqZvbCB62gbZtrQR3alpI633RRDNt/B2+z+kSAGm8CUcnFUa5ytgPnRqr8PYa0j8RfH0R+LQEseIkJlI0iqCgQXBWzwdt+C+9uM0Y2UuifLWCQIk9koX68N2hNg8QkNsXd4Ot0A47vjzYGFNIUohTygXeORxa9IlbHsWmx6sXIhMDaG6scknWVj2FkTNjOG6bkvpnWIxA2YYyoA57WHXcSbEqZHVbX23kNqlza1GgA0lccAA7PdjVYq08AASmNGdUEvRi9iuYukoCXxm1zL3aJeCvpjIFydpx831ajUH4m84K3nujOyrrz7ihkJl4UrAzzBimcNCu4NX/jZmvk4w
 W93LnNL0
 11RKzC1t8ZjH61HyQQl4nYPqsVhfK2rx3KfU3Rev+p21dUdLgOrbN7eug42TmVyEjxQB03o2PhuYjROcyZa77RMVjIW+GTreSE1SXEJ0votofN/Dqdeuo0NTjEOsFh2DqlTrUV45vmmwc0+3ccDQOXJJTfR8wMWIDZbEeDdsYjAfz0VzfSIIqsedCuL/aBIQla7i5qVMcsXnha0ox3NHX2ySMkRiCt3ZkoIYldIURf/JmJ0kOTsZwdOWymS2ZQaVQbYtLIAVzCQi8unLrfYakNb/X4h38WMzy5LyL/2eeBFRyuYogDK+DQrmIwI6T8+JyVD+YfZUAMnCl1LM1nHjWPQRQTNYaHQ1xqS6f3TWTMBgtpbtqinCytEDf/UwV2rNS/oL1QoY5EEgh+9Hm0LK55wygj2TxqaBaqtnligdJZc6sg1lOB8iIXmzqL/i2n7AsbJL80e59HbK0FqzQTTLybFLJSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 16:39:27 +0800, Wandun Chen wrote:
> Commit ab521b4142aa ("mm/rmap: improve mlock tracking for large folios")
> mlocks a large folio when all its pages are added in one rmap operation.
> However, when a PTE-mapped large folio is migrated, remove_migration_pte()
> restores PTEs individually, passing nr_pages = 1 to the rmap helpers. As a
> result, PG_mlocked is not set on the destination folio.
> 
> Reclaim can restore mlock in try_to_unmap(), but Mlocked in /proc/meminfo
> remains undercounted until that scan occurs.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/migrate: improve mlock tracking for PTE-mapped large folios
      https://git.kernel.org/mm/core/c/9fa01fbb

-- 
Cheers,

David


