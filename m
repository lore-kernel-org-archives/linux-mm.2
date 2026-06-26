Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BCC7C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7276A6B00EE; Fri, 26 Jun 2026 12:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFAF6B00F0; Fri, 26 Jun 2026 12:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615936B00F1; Fri, 26 Jun 2026 12:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 365CC6B00EE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:12:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A89638DCA1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:12:13 +0000 (UTC)
X-FDA: 84922555746.17.3EFC1F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id DFFBA18000C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:12:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQPMbViz;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782490332;
	b=rklcClwTptQY0ni1CMtz+5MZT+D8XEeDFxaEDxRZG0m5p8Wmw1YGPDQ8djk89yn4K+IwjX
	+LfmsdkXXLAjHw7iuVryzSXI26tT9EuQQuiuGMTIx1O54hJPA2IqqsHXMRhh5INwqnK4J7
	7CMsJDKf8k3Fin6i8ZlS1rCdoN29eVs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782490332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZmJ5FAUnKSZNe/4tfkRMgIB/pgG0Tmi0diyqJ7nPEs=;
	b=cq6SM8VpC2Mn/dfsUHpbaSepCsCZd7D+99GEJYJ2VSm5Rt4bTE+B9ws6vNbz7e6/2BShjd
	/c+omktqsFIxAlse3gc9rCbnQyJKyCEhVWL/VeQzRpIS+u4zm6MWQDCXVk0Lz2Pcam2R25
	R6isT/CWT0X7XfusOVcnjyoanYYqM1c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQPMbViz;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0958D43534;
	Fri, 26 Jun 2026 16:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BAC1F000E9;
	Fri, 26 Jun 2026 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782490330;
	bh=KZmJ5FAUnKSZNe/4tfkRMgIB/pgG0Tmi0diyqJ7nPEs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BQPMbVizG95hAt/8047HSKMeQsim+Jg7gZG6JWlOOFk2v7B6OBpdBP+YhYY1NSCx3
	 GNVwZnGNfJa9jQOZP/0NogmebDDudQxIbzRVkdLZN0oSJbt3lhb4SB/N+3k7qseuUH
	 0qfSfZ5wTixIwfN8D/PDSLS0sTeDvvPBjcOHc9ZRveJrSZLJmF2aech3YvNdhxUk3m
	 AlRxH7+TtGweQazKzTjqDF2/TESXrCQk28erqSy97CA0cs17xP6XG/Td/1zvpEh6wm
	 7US4qioeGR6+C816i0glNmbbP+kJFCsmwP4rKzufw1tqVZoailjOJGQNDS7OF0KNAi
	 Yni2bS24/qA7Q==
Message-ID: <2e9fefd1-38e3-4561-a7a4-d66b5e9f81e5@kernel.org>
Date: Fri, 26 Jun 2026 18:12:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/migrate: fix stale list name in
 migrate_folios_move() comment
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
 <20260626-migrate-cleanups-prep-v1-2-a95933af7619@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260626-migrate-cleanups-prep-v1-2-a95933af7619@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wtfh9eaef9qf5m4kiwye3xnbxmwtqqfz
X-Rspamd-Queue-Id: DFFBA18000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1782490331-123943
X-HE-Meta: U2FsdGVkX19ZuR5ukVM/cAgUdb4hZXcUZv0E4hfpqp110RNqrSg1stqB9W/2cbNSnWnCJHMkWBBGWH9L53Ok+z3KC96weoj6QhYljK/Q5BSRewmEl6NEIcVriYaItNXmLXphNtzUOKaUhRhIqmfNQf5Al/j0R5oYFnK0gVMnwuHb0V2UQuSne04Oi0mzNX1CiqQyWUfduZBR/m5jOpB2ppflrMW2qxllrbz3jvc/UrUe2pUpZeVdfpy6I3zMv/jV4Skm16/Sn8+oXaneT4fDDe1IXWbjXiR2e/WbP3jezVzW+UnxIiws49m/LQ7Fo0oTNe1llGCeorpd2Xv6HlHW3lQF+tXAte4hxOCItJkJO/6NmKGtQ5axSl1Q5OYrcK6YrvNr71pMijElxU2934gC5W4wB7Hln0xk5qKUpAA5ze/QRSNem3XDrCT99VePCzFGcquvTeXyPNE6VPv6QnTbtId65VaRWRadRQsvEusLD0CzIwm1bPEqFRWeW6Pt0yZpDvFLJvOtOrSHIxNl9v6VlYeMwZMwSw096NacuTZhCyfhOqrJFDRAnOCEKzBhHMyrwgAl7lWaKoGjdl+RxPwYCMz2ZaW8PbhzXHX5eS/0YiHfOW9FxPS5jQJykcgyhDNByyS97suCL2F388yXllhwBAPwg0sJr1urYuj4sSMYEdw3xyBzMAq2Vj40bsFq8whjYyKYMtP7TE56SEOb2oiPk0CKjmPkA5e7TS5Gz+OVgLMyq/j8kQd0XrZnSsWS8tGkcyK79m35+tnfa9kH9bU2u/ZU4fjk5HOo2UD4ub4+y9a2DYdSbESM/UHGgLCDpK1g7ZtBY3Fb71rxFZityeO5pAk/i9eNqwvsB9s8cSdcYnJfGhwrGV5MfaaUQtdpUjQbljXuGNCFwQlC0Y3ED3V2BR/NnV99AMoIDcM6E990JK90nW8rSG4XDNejJGTLZOEALvBjze1AHpgSjLpkgsX
 e8ZZoZRo
 rqK63pZDBJCrsa51x+XBh7qAnFiH876Ktlgksv/VI8SKEA3IHYUg76LnkTF2P/g7qIZ4QIFn/wvwogfZXAm0lBlGVzGrm31JRQfL31y6fejr+wVHr9PNCGFSNcgzjkOEEGFnZqINTf0iqd41xAJmzP212MHK+77RUC864MRL65anLeQ9QzSfYbFAbYRfzsYFU7jD1NcF5HqEZRs0UyF1K4MBRYFKy4sFP61MK6xVpf1TTrT+iAGQlM2c68MgmfcO3iACAX4uRTC9BXP8timXdko79Aa+oGWv+MEc5eAAsD875Zz0dqF73ixRGJgfpcjJ0XWCoE08U5I7sstWN2krUpGaPFZWosw5Z+l45b6ZywLD/UfGBiGfXHxXoLX0v4NY4su01tQ6qiCE9UOuXNOooFu8/FrtXeThlTyXVmVGr4lqQd4s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 11:37, Shivank Garg wrote:
> The return-value description in migrate_folios_move() still refers to
> unmap_folios, but that list no longer exists. Update this name to
> src_folios.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index dd7dbd8d84a0..84b4c24f9dac 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1738,7 +1738,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>  		/*
>  		 * The rules are:
>  		 *	0: folio will be freed
> -		 *	-EAGAIN: stay on the unmap_folios list
> +		 *	-EAGAIN: stay on the src_folios list
>  		 *	Other errno: put on ret_folios list
>  		 */
>  		switch (rc) {
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

