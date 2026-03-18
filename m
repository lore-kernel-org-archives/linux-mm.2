Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B2B8107761B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 21:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710F86B0338; Wed, 18 Mar 2026 17:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A376B033A; Wed, 18 Mar 2026 17:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562886B033B; Wed, 18 Mar 2026 17:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF196B0338
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:02:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0AFE13539B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:02:08 +0000 (UTC)
X-FDA: 84560406336.22.C48FF56
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0893D18000E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:02:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A+EOEniy;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773867727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gPDPE3uP04XSuNdZbsheC2vtbIrc4cqcngmTQFNGy0=;
	b=sAaIgSKJooUafYX/QlGQkcLU89Z8sk3oWo7rdidIWduqkdhaGu4a5V5jy1hRFq9X3CCeH5
	5K4u1D2Xx/H6OKA562OnFqBB5SJf9BGAAIVre3a+HlRw9zCrts/D2BW69O0F0XVRZ4QESH
	3lWhXB0KfOyByLBj+aiaR+8Cz4Xxusw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773867727; a=rsa-sha256;
	cv=none;
	b=cPTx6+j3tkyEfTLMYrbyMAPUw0DDB8QsPagaWyAA9GhkJOIcGugBNfxhDUhI6fldQmY3vG
	MbIA3Cnsv18BjzLfJZ+26Agsjf4Y9ORYc537ZiaWozlu+ojbI0SbzTold21I6K4WiDZghW
	NdHuzjkRNZetxWlosCVXjMNmN4lUF0w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A+EOEniy;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 18 Mar 2026 14:01:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773867724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+gPDPE3uP04XSuNdZbsheC2vtbIrc4cqcngmTQFNGy0=;
	b=A+EOEniyWQYhVl61shViOBJbhpEB+/bVhL09lUHRy4w2KAytPlP17s1k1J02xZwSxZA/8Q
	GurPFTE5HsA77/+1QbOb/rFmQPY1Pcg1wNES1HRi5Q7zA/Yt+ghc68alknlCEya6uYGxQ2
	5+NAHszXSoSn5V9GnVX6tIHSGIJ8Cv0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] mm: list_lru: introduce
 folio_memcg_list_lru_alloc()
Message-ID: <absSrpzmvvNbrhRD@linux.dev>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-7-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-7-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0893D18000E
X-Stat-Signature: 5xbdt51gzwrygzcc4munhwbgya3ewpzp
X-HE-Tag: 1773867726-671593
X-HE-Meta: U2FsdGVkX1++VHasdauXhEmM2sPU1lSC0UTEIDIKibkw8/EkD8Mry/wFAnyhYztkrT4F0jxKIiYfSipfdJONzf1rzafcCoLyB3TpcIO+qhmrPjQs8s1TgXAn0Czm3WOYkG3bctKEIm6wDVdVHuOSkDiRMrbtT3xQB4QPw3akfJ3QUOTVzSTMFhL+9L3x7+9iH8Hj0BK1860d1A2EYxdlHss+vf6KmaYBTUJIh11tYVh6Lh1SSSKNx+dURFxbsM9xgjPnlzDIQfcHpPHEERPNBvtTmz+juJ1Lbfdi6GLyOovMJts2OhLirselsOF9ezFEz1+yRMaGnkm/pFJjWVf/pG1XHQb6nI0foyu61myROc0U04F6Z70B/jjppltEx7YrClqN3ML9UsfP//yyGWQq1TLqjtFgv6rNtS7jWpIalw3cvylNXiCxCNSslgFyTY3jCiq9UHE/eKGP5iGaa/YgQm695NCSduFiNhFqGEQHCGHxs0MYgLpFE0UDQ9h2Z0QcTABTw19JZo1LxyRdXP1UQaqc8rF0OmWdHjUsDJ9IBjUk36qncnVyyG9trddvWA/yCT3vKQmOqbRouqn8rE/gJ1qafXe4cry3uFR1kfAuvgbi6Z8pYn6//wO3a3l2DrEu3k6dsE0uvKm10eDOXBjohKDrxLc70oGHsnfZkG04y5VRLQR1NVprjbGzudZ1GYqerf3pP/T5amyZWfYxes7IIIHVn2yrXrnkCEuLkzK7tT1WgalIYaX2yyyi5dwt0VoHrTyMUEgeeiN9IcIzlS4bgx9TDtnaO9Qr9XkceOpbrFu9NChgv69/5fIRG5y9x9eO9cWz0PuxzFYsn6oD48dUPYu1wPPoWQB78RePazSJq4U7DjlO6HWb7hiQy3PVLcAGlB6lFTnZYFoulzptnAr0ntsb6bHETEkbrv4J7HbF03YYvmiz3mgOgzGNvy1MBQihH380UVpeM+3yDZyQBpj
 oFXM0e2V
 9pIWaMEW5uthoiEPCmPFrBGS6UK3q60utdbe/toPcihkkqX2gvfn3uUv7Czh2gDJnvwp/8Pal05wA+4Hwhp/0/KKZAO9NRVpVYTrDC+ThftYYMaR+W/MLmoZDDq2zx0ADTn//BVhid32+3hQMb0Ugj1O8o0tDhAli1PykTvz7g+smed1Kgj1I2A9A4jmnRgjos7Ae1ByLWuVZVN/Q7TF71kau0T0pO6ewaHiveb35QF29+BYYMVPBZl6q92tbGeibFb2Gh922MpK0RNssq8jdxatVeKpkiYYuvqPLbDXGKGlM/5YiIjHAKvtCRcBJIENs/IZyHKkD741cpFU3xVxySWAMyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:24PM -0400, Johannes Weiner wrote:
> memcg_list_lru_alloc() is called every time an object that may end up
> on the list_lru is created. It needs to quickly check if the list_lru
> heads for the memcg already exist, and allocate them when they don't.
> 
> Doing this with folio objects is tricky: folio_memcg() is not stable
> and requires either RCU protection or pinning the cgroup. But it's
> desirable to make the existence check lightweight under RCU, and only
> pin the memcg when we need to allocate list_lru heads and may block.
> 
> In preparation for switching the THP shrinker to list_lru, add a
> helper function for allocating list_lru heads coming from a folio.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

