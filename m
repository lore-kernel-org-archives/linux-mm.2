Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40EADFD8740
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6206B0005; Tue, 17 Mar 2026 07:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D1D6B0088; Tue, 17 Mar 2026 07:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A42E6B0089; Tue, 17 Mar 2026 07:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 838326B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:25:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 184DE1406D1
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:25:34 +0000 (UTC)
X-FDA: 84555324588.21.3FA6F1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7032280011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:25:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f9jD/4Fk";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773746732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9e+yKnCtiF4HEwCiCUAlH11+H/AH+F3Id7ThrSC/MIM=;
	b=CXzf26N/uq/2iu79GKXDCYte6pB+DUDrIcwx4sOTp43Ywlfnrkmu0YZzGbUm+EX8Z+7OI7
	OfTFLpZP2ts4iit2uHl8+c5ZUl++vjVqxAN59thYMDZjLtOaWg1Q0nK+VobvdvPnC4G+gS
	beihcyDnEtbeiBbkpa2QzAq0FolrJiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773746732; a=rsa-sha256;
	cv=none;
	b=tpifsowPRpMPecwuyVaTuCrCZvHRYaspPEFHNfWs8dl6nKM0XtuAa6XwHQi5qf8NLQjf5V
	YU5beBctq+IgbJXJyHQMtDHAgh8JIgmrzuCePe9kYXRZ009/APVv+6WRWdy1f+HxbBoGJh
	NBcE6vjOqxer+y1HewLeSPvv06Bh6j0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f9jD/4Fk";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98DA241A1C;
	Tue, 17 Mar 2026 11:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AE3C19425;
	Tue, 17 Mar 2026 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773746731;
	bh=9e+yKnCtiF4HEwCiCUAlH11+H/AH+F3Id7ThrSC/MIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f9jD/4FkF/y0X9YzGOpFSN1Lad+SwWaMRBPW1jCYGtk4hgpQDPZhDmhcTeASlEBnj
	 lfnG3H3qkimaPi62i09w0qB871A2lew3z8hNrkmwJTcYI0dFjuugk0SQPEHGWEXCRb
	 YZcgOOYJMOLpI3KUMUmO6rLQlMNZ4xm6c/ND5zkgeOd+SPdxJTIm/3UM5zuSzEJtqj
	 y7xeOnWW7buC3u9mTIM3VhH5vvfBh3lCzw52qIMtlEgiS15XyZryrBCvmnU0zAjbzs
	 eBDA8TQmS7lWnq5stQdTA3+JLAO0OXwSO2AnNfwA1yEdWL6k9ZmERg5ky/c6bm43hB
	 B41H4jlXdccDw==
Date: Tue, 17 Mar 2026 11:25:23 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Sohil Mehta <sohil.mehta@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	Wei Yang <richard.weiyang@gmail.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH v6 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Message-ID: <8f873cbb-93ef-40d9-99c8-ce9970aefb82@lucifer.local>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
 <322f6f2f-840e-462f-96b0-b603b9c88582@intel.com>
 <abfVLky1zanZyEx8@gmail.com>
 <a503cbfc-e7d9-40f0-99ef-d640a0b5d78e@intel.com>
 <1b7d1bdf-c002-4543-b858-09fd2b1b73f9@lucifer.local>
 <abk5eqVbwlw1FGsI@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abk5eqVbwlw1FGsI@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 8jg1gpno1ipa6da5j5oncygj7c4z1s49
X-Rspamd-Queue-Id: 7032280011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773746732-592601
X-HE-Meta: U2FsdGVkX1+BX3mo7rvKRtyyD24WQcXVYBJZTbVp2sdryXxT4sM1hndamR95c8ELaK/mF5DMmsWvFv3RK8qFZpMiETZST7noB0Vzw3du3Dw2gzq9hNkJurzzh76ybdUVSJgA4Z11Nv3mixrcn5fF2eCkO4w5JRBut9ovsfyKkMuY4SkdYEw3zHcsfiykrWhRLE8ZDzfjfCOrnTWOLHSK5/7wV9rGJwsAHMYqmIU616wW7Y5oC/0NnghH3JSjTdcfHJs+epuz1rGX58LbB083z4XYloMWFLU1xMjSc6d8gemkvrhC2iKaqUYYVvQuPpsbUjg9OGh8ED7k62T1kUJzeEsmK3aPmJRq/IJPfiX3CHaahysRIZPszuqrc+yl2nLazVcl4Uq/gEnjhzhnkSPPhZUSzBlikLVxCVVCi/lgyqLzZIvOzbBjj+YqDiRkBcdIHuJwmEqO30GE1Eb0PXSzbgNcApvbmcWBrqeBmPsxMb+s1vXHsRh2LeZXTchHqbpk8L7c82CHXGS2GdY0DtwbfOq34mQOziQbLg/79inAqejHdkLRcwkIN6rv2bIBPFOFK0kYh8nbhHkHKC8EVxqBUTtq6280OLMIr/7FuOco5i/I3ndkdV0i0AUjaAlWoGPCQ2X7nKx3r+Fe7YtDdmfHeTeizM8vaB3BNd4be7cM9r/cczjFcoPJxqJwEdGSjwa98kh3f9l48af+VFhTqYW5Tj459/BJ1rC+YeOCJoP8B1V34doMwUkSZZXI6fiAaTUX742YUeOpmPf5INQh305wsl6YYt88wEeBohwqGE3zqE1oVP9wyBrKxPzEQnbBldSf059RMTCAz8EhG/OfUv0OM9+Bk+JbjQMsz25MmY2EWyKCFDjnikuZCQsR3rHd/yfEbhTeBDcEtOKiUZkgPJuDAZebKOPWVV+UPQUc0Lp61IEGiPa9ySUn4r7EmUK+p5zCnVaoeqVV1NmOntAIv2G
 FQXciGCe
 VjnXHpCs0YWon33X2+oOVqJxbyc0h/6RLurYsN73tR9V87neq8p70nZWltJKwIAbcPbuSU5jLJ7vpumkWDhdp9amZsoDs0knsYDp+FkLu7YHcbvn9aiWIKn0xwR51ZA0HtUbFAOOYXzE6zE9Pc1oLJEVZ4uYG2F1PAbu3LZcihJwobwFMGKuFXZ1P3biOuKH0tDnAylHYrRyvlYBBvSjQFgjUHfIKONcpKsRK4rxxPcYLqvEXEj6Z3HnaZcMTxPiek8kHdBZpVn4kVuXU3IeY8cKUdDBHJECSSMN2e2fk9buAUt+OZImKjc/54Sep0ilEVOHQi+gjDOcxwyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 04:23:37AM -0700, Breno Leitao wrote:
> On Tue, Mar 17, 2026 at 09:37:39AM +0000, Lorenzo Stoakes (Oracle) wrote:
> >
> > Given the above I think we should switch back to the atomic accessors.
> >
> > We can address the broader issues with this horrible code in a separate
> > series.
>
> Ack. let me respin then.

Thanks!

>
> > > Overall, as you mentioned below, protecting transparent_hugepage_flags
> > > with a spinlock seems like a better, long-term solution to me as well.
> >
> > Yeah, let's look at doing a follow up that cleans this up in general and
> > address that then.
>
> Sure. I am planning to improve defrag_store() as the next work, and then
> come up with this additional spinlock for transparent_hugepage_flags.
>

To be clear by the way by 'horrible code' I meant the existing logic with the
globals etc. not your change which is positive and welcome :)

Cheers, Lorenzo

