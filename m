Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED7B1CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378C46B0007; Thu, 21 Aug 2025 10:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350596B000A; Thu, 21 Aug 2025 10:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D526B000C; Thu, 21 Aug 2025 10:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3FC6B0007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:05:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBAA8117709
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:05:55 +0000 (UTC)
X-FDA: 83800938270.19.3EDB041
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1022A40010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:05:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 147.75.193.91 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755785154; a=rsa-sha256;
	cv=none;
	b=G50RkXPB2bkaCTqC37Wp5EgVFHYTmiOPQnVh/FvwbgazEZSw7NJmamg51ZT2DH4tRgNACf
	OZH0EPE2FKa1htbZX12oIyawE37rjvgwPe7AuHzAFWaxG0qwTQzgz30+nULelK45WnduXY
	GCCrhF/DZSOHAgWsxxySkY6cl4VhuFc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 147.75.193.91 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755785154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HNoHUyesvMROPr1ZxZzURzgg7XvLEjrM0OkIc4eV0FY=;
	b=c40cjLsfkXUU+0SJq7/qj29w+8mpEcZ67fT1DLkXjzLIHNT3m1EGJdH9N+wy5PkHC+ifvv
	cj9cilv6xz4lQVjt3nCOlUuHclPFZo6iHVhhGZxExOHKuzuu4OgtBGaXFeCnXGoKnVKgxZ
	lj6oRMu0kPhX37GArEx7vE/t1ZTQNXw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 46254A58419;
	Thu, 21 Aug 2025 14:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC6EC4CEEB;
	Thu, 21 Aug 2025 14:05:50 +0000 (UTC)
Message-ID: <425a4538-1b01-4766-9f49-4f21f6151c66@redhat.com>
Date: Thu, 21 Aug 2025 16:05:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove is_migrate_highatomic()
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250821-is-migrate-highatomic-v1-1-ddb6e5d7c566@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250821-is-migrate-highatomic-v1-1-ddb6e5d7c566@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1022A40010
X-Stat-Signature: kxiyi6grdk73b5d66e74g7dmx4sb3npb
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspam: Yes
X-HE-Tag: 1755785153-561106
X-HE-Meta: U2FsdGVkX1/AEyGioDT5/6InKQS9E8k61TEdwp28scvHI8Vsf3rYpFepp1PkMRKl8zRwR1B/OgFLDXRv1GlWdu+vLn1vwNFqGePS1BE8RhdirFxvbnxJor2KmSYQJVZ1Nsh4DU3cqdcMHml0ov8KulfdE/FGzp/7kh5fwAlFtsaxonQMZdh8/JQh9NShwUMoay8d+fU80X6LHCYwHqQuR9HYAgxRc/er+dHo/tMijNFZ5/GlhO64ZYJxU/tbT+8Li8s75CzcFFqxcoQ/cWaFXfsgSkX9TNuAVpGg84jbz6l2sqwyhSfHxtTq56UsmVNCznOiY5NpN5j8/adbSD4SfWm7nTpeAR35IQ9tpBnMP6QMVDnC8lw/F/pWul7KB7HSUZMIkvANpNhj3UtU6j1z0r3ATd4DbJlZRXCsYvaICh7cGmi2sB7MtnwgoJpQRvjs28zCVVtHxLKxDdHZFFeIl30hYD5p3SSf3AJ2AbzLSQF/hUPjoeDyLBjDZdl6XUXFGEGkBd412AQRQOvspl/3ZOIkprDXFkgLDBH2By5rgieMsGoOznGAMnTUcpKsP3p+4t+plj/F6DabWrjwpcqTvdPn9jtXCifTMKWRp0uv4BeKIM+DEJGd481KMwCJaO9c4/XG1YMVb9DUU0pGWIIBHxZSFeD8QqwNE4mamVZVU6TgGuh4vTZfzyDy4Hm7xJldQ87lWYcUcIGKWPPYR9dGFV3EltMTwEo74ruIvzVH7etUQk4GU6te2APL+23R5KZFofzG1L5Eiz6y78hlartujL29FQgFw7IWwrmiHoIGpw4e9vdC1cU58ld7Gzh8w7dNO4vDMMM0xevHTKXn5HrvP5s0Y6DTIBGtH3NuR3u8wFoC/t7eFnSmmpsZdm0u9wuJSQ8NSYw5PtGHUxv7/XAithPrNALoaxu4ynVd8bBmoWck8QZwVDBmK74y5BeG1gx9wN01LcKujZn+Q0chAmL
 fdKKjheL
 N7xBmvJHqt27gkmLctfbu3mDF2Lor28/KCvJg/lCsnVNp33+CEJuLKJisrjrFk2zNV3ET3zKghc3tOgIdSm+xjffjMcwMbBoDVGjV6fLiRtt0Q8AYYro1GSWnRl7foTJRe8X98sFzVhb8PmOJKO9vct+CO9no1bxbfcMAEuow0hAHMVD916qkjH734hcFVgAVAFlee2n7FBQZX2Rurxejr9iDawgaAfg1KUpvz3WP2Gd9/PzIKYJJHIrFYreyYNdrKsFOzXjHyaE9RQtRP9hVP6/e0ILp6f4n/Ji0HUDIyOdLp7xl8S4aW/DyWcTBUp55tPiprPhBwUfBpo9k85DMOd1VFOD+bMx2dbSlWt//qqCpcpcNu+5e9Li8o6Zx+Bk651A1eaeF2zLTtGMTpLYVr+0DtSLSWo1TZoscAtaG6WnO1P/4OisnUJgbaSoa3logSq7uKd2d9roYXOP4n50nXo0grFLnRn1/FGFoN6lk8bLU5PWS7pR2JJpkKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 15:29, Brendan Jackman wrote:
> There are 3 potential reasons for is_migrate_*() helpers:
> 
> 1. They represent higher-level attributes of migratetypes, like
>     is_migrate_movable()
> 
> 2. They are ifdef'd, like is_migrate_isolate().
> 
> 3. For consistency with an is_migrate_*_page() helper, also like
>     is_migrate_isolate().
> 
> It looks like is_migrate_highatomic() was for case 3, but that was
> removed in commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
> accounting").
> 
> So remove the indirection and go back to a simple comparison.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb

