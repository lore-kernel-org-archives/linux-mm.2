Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1A6FC5918
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CACED6B0089; Thu, 26 Feb 2026 04:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DB86B008C; Thu, 26 Feb 2026 04:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A5F6B0092; Thu, 26 Feb 2026 04:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7E136B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:28:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51C62BC7B8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:28:29 +0000 (UTC)
X-FDA: 84486082338.20.71029E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D4021C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:28:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bglXENi0;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772098107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjNn0DW8X7BMZIiYffsT7aRLzca+LaPXCwgk8nIS06I=;
	b=r8Qptg+6BCGnUkz94ZbMiGEc8bB/GL1+5aR1EIbgJ3bHnuHy4xhL1y8k3uQNbK+5iDBSP0
	k5QkDG3SrGl3Sbd3tUPZ6E0kO9GQHbokGeI9jdt2OfLTqjlPnxFLzencRPPc5Kj17ONx6h
	9Md9j1bJntVJqEUNi8XaSh+XfB1EhwA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bglXENi0;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772098107; a=rsa-sha256;
	cv=none;
	b=T1dCSqZL5tdpPtbsdgkZwGTNhfRSC1R0kujnOXiWeZzj3I7TVQ9VeYoRy+Y/NswRSxqs1k
	EGXDMDvvlstbJw+HolmVmeXC59nn3DmHXZY2+98/7mkfD6QeRlV4u9NM1gsj1jMosbJN3x
	swy1ZwZK5zNanITjJEB/SZPZmY7grXc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E9913600AA;
	Thu, 26 Feb 2026 09:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E40C2BC87;
	Thu, 26 Feb 2026 09:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772098106;
	bh=fALqYoMiX+Kd0jgcI5CbhqnXJCzX55g39+GTvxHfx60=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bglXENi0e4UPNiaM1uFq9hn4xXbLjPfXrdMuxAHDcUL9kFYvCvcY2IslYnCEtyaW+
	 PC//lmqnbVrkzz4R22j8s04gCWq+MjfUS9fCSlZrpq+cS9sFNktvc3+z2hG2VWpQrV
	 7+ROf+zY43WqeBs3Q4XTi7Hz95I+E83qoKDOxC/xGAd/atlkAa66exRQdf7Sb/Rj2c
	 JME4i40QYJXqsfDf6iUvkkvANLXLO+DClGoKofgcvFVdZk+pM663H+ml0djiNMNmXd
	 Wi4V5VDWf91eljULHU9TycA+TTKfinrn2oatcZimXPXNEM0hbBFmWeyS6hgSlPqBpe
	 F5Y+duezqZvjQ==
Message-ID: <25723c0f-c702-44ad-93e9-1056313680cd@kernel.org>
Date: Thu, 26 Feb 2026 10:28:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226012929.169479-1-npache@redhat.com>
 <20260226012929.169479-4-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226012929.169479-4-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D4021C000A
X-Stat-Signature: prqroqmyswm3x6ijhhk3pmx36kox69ky
X-HE-Tag: 1772098107-271820
X-HE-Meta: U2FsdGVkX19Biboi/WSbp88MAT2Zz4V2PkfPG4GcIxRM+2GtrHoTeAFatJxgr5TvOvJST1PhrL4DfB0oRbdklCe5MaqAK51O+N3+SwIt5P8TGsL+O8PnNymBmuHNmDHzehPywlW/gDFb+6Hpb+s638acU1fDmj9piO3uhJSa9pJ29vZx7p6dSKsaGSDmaOJUjLdY3Ifr8VjCziIp1VoJFa7PflPNYoSzcoDLqxWlpFWzbQZbPVhHbw5oin3h2IkxzifaH4uZZeLm3qfTny1cm4IY+R2y9CGeU+WBnyy1iIm74r7jDxAR1WBeuA00Sp/x8wvDQMtWbiQ87rcjPc6GrUJcyflS1I/G6sHqqEExK2tyX7WpWtJ2OpaFk6cMKbFDgzb7hF/9RVUcU401zvfYwjsXenzNI7XJj7OzQf76gpvpwla8UTOfGf2tLdldmFiTnZwGC8AyoLfVOkQ77LrjGnjMX6TS1+vJ4GgNdgj44QwyRsPRsv2sVyBASuid2uBOjkZ0UD/Fawm08c781G344heKKA2g77GE4lI08Mo6usDfoCnAZl/2+WgkZwqPawtZMKY4T6Zz0hXU1NH23ZaXpFyHFk4lzH+g/zW2cvfxCsalfV/ah57uDROTSkvhQNEyc66glVtupY/HhnRpioLMrtX89hfFrrKsO/iL2F8Do9hn0vmM1aNEK51C1B2sHmjyuxLKvw1yiFbUxjer9EGiXqwUJ66wGl/uwI7XdeXcpASOXmDzSfz5Wr+A/LbTPceaecLliS8RWnhdwTGfCNVzGx8o4bu0Zisrtl8L8H956OLZ5hpW2FIVwZwvrjP/75cqAv2ItaP3jmQ0aBPQrVmKNp2O3cwIAWpdMWi4Gt9PXHvWpoPBt7G2cGdgz/UUrkyjSxgQy8PK56uNmNewCTg2TfdPtTyRHZ5rf/UYXumUpoXH4r5gtgcNBPKPhYKoM/z3+LcmBKvMatXWq/pMh5j
 FR6LriOG
 v4DGLY+pq2mtVFxMkaPH8PS8j8YqSJUexfKnOzmZIsycOmIRE7Y83VfJu/eq9yOn8cHxtDH38iExsr6E8yM4Mo5GrGz6YfJ6U2EobuORpffrNcv1JaJVoZ6TCxXieLpd3+AnBIp2PYXcdyfJHO3zHYZuCJgyLxDyK+GSVRAgi78N3kc+FC8qyWaQ/rQpNMwpbs53PvPFmYqX4e1fQtgfRsocCV1GkRjSx3iY9kHpDmg5aV2bk/tYGlRxN92fndI4BaDu1lGXf0O5EISw9EJb//nQRURDs78YpIwO0CLf0/MiWn2VptYo6UKCizrPKzfKObnd23rOnvg8xlNEcOIhgMLMGYEtN5Fhy3/qc0yqAR0qKkWGwFrPT74Y5838wVsEx/9RLuPAnUIr/qRTN40w+1fKgEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 02:29, Nico Pache wrote:
> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> signify the limit of the max_ptes_* values. Add a define for this to
> increase code readability and reuse.
> 
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2ef4b972470b..4615f34911d1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -89,6 +89,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
>   *
>   * Note that these are only respected if collapse was initiated by khugepaged.
>   */
> +#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)

I'd call it "KHUGEPAGED_MAX_PTES_LIMIT", because it's khugepaged
specific (no madvise) and matches the parameters.

Apart from that

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

