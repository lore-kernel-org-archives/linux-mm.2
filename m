Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799F9606A326
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jnz4FDKF
Received: by kanga.kvack.org (Postfix)
	id 68EDE6B05B1; Wed, 28 Oct 2026 11:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666D96B05B4; Wed, 28 Oct 2026 11:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D3D6B05B5; Wed, 28 Oct 2026 11:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB8B6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:01:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18F051A0121
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:01:33 +0000 (UTC)
X-FDA: 85372348866.06.6FD4277
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4CB1040016
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:01:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jnz4FDKF;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199691;
	b=fE2+EeKpfLxlOynZIzwJ+5E+t1G7JEOAMLLhFMtWq0vqoZ+PGx8rZ4/DfUoyJDWy83swUI
	i7e2SA3KenVyan9Yq+234ob9yjB1sjjMjXZ0SAxk2hFQygDyEfALbLeQXlB1NiuS1+bmcE
	Qw9KT7kH6B7ZtsxnQAeB+W0d0M2CmIg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jnz4FDKF;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrtuy91IpWzzThsCveQ6a7h3MVCj9ehEufJFJ4ndZkw=;
	b=2KfdYGF9MrWZtq3Xw767FTmXipTN5qDtUyfNzLhzcu4EK23zavNMeMrDw1mhb7zlnvndN+
	tTd66NNOX+svJgEIAUMPw5yN6fGv+D+kN1zuDJfZI/Bk0Y5SjDCvdVxoK9Grni9lOIl6d5
	tgtyObVOCS62tyRH9x2eGDyfiXanT18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90EB6600DA;
	Wed, 28 Oct 2026 15:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC7D1F01825;
	Wed, 28 Oct 2026 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199690;
	bh=qrtuy91IpWzzThsCveQ6a7h3MVCj9ehEufJFJ4ndZkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jnz4FDKF10wh2Ob59odgXGD9RU612x00cjLp88yMU+M3mx/KDDnBifu/MtreJUHWj
	 6cls1EYwPWacfXzv4KomI7jh3tj4enFISnNJtH446deXMQLqL1uUx5WAp6Xs7Yxafm
	 ESGQpYU8KgpcgNYN/YHLrziMiFPBeZVeRZ3VsTnRDw22CsEmRKApPC3sbqb//zEyuY
	 GrlJdSeKuXv6PkltlW8pFEH/7lr1H8athK/QWBeJK2SXnEm93NbWRw5Ic5x2HpoR64
	 cFA/3OTj2KnyUyVJL9WV4+/WtDh5URjIbZBMRjKhojjE62Tlm9kM/MIx6+o3TlN+n7
	 bXtVzqgu0T3VQ==
Date: Wed, 28 Oct 2026 16:01:24 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Frank van der Linden <fvdl@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 3/3] mm/hugetlb: fix NR_HUGETLB accounting for unused
 surplus folios
Message-ID: <auIORHr432BlmbrD@localhost.localdomain>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
 <20261028113319.38544-4-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028113319.38544-4-kaitao.cheng@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CB1040016
X-Stat-Signature: p7axs4ireauaeirdwwppynni1so755cr
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793199691-488580
X-HE-Meta: U2FsdGVkX189mTNLlyQyAILXDeCax2s+n7dJZ1JRx/mHreuGQmHjzn1rgyklDrct11VnlRV5NPShmVC+wV7dISLbipAQeFJj3+p24axK+lvs/S3enufTa8icGlG82Ju34P5ug6J1/oQ2Lv5PO82Toap3FDbrIvU65I01ZpD8mYECk8IvkxhOk32yEipnyZh81U5LZrdyUIIkEfkKJxj7iUkJ31qDU2lKMcnRl4eY3VI51VkndThD0/L3xy80n6v/D50YLdBN1YWN7pxp8t9d5ciHvwvW22K+WIwCyY2aCNnbgqrhpD74XhEKQrqHX0oQhompgJNl8okwGYs/rad5rZe9yq/9QzSYLKkS7zujOZBZlTVeUbSAMLa47Wm5bvsLsd5gnwEnnrLVpw3gHLYiJsAVfWYelVzJnpIedi6dnnvaWgvF3luplhK8JMklJooB7i1U4IdKeWevYm7xTPzX9S4PuB+qoXbehEWi5t/jPNEG86DFTd3+wNcBbYEFO2rbTgRMzD0LgHn2wOt88PM6IKa6Y4oAb5khtRGKfwt9ZNoVoqSA4dDFxgwL6ekfIwPYyHe72oWVLSkB3VH8m/tIbh03sV/4ixkrE4G+87GOav3/wDnF45KuNwZUsb77chclMCHW9PbFzmOsppoVdidwsGQsTAL/aeenczux2NS/PZHE1aCkonIzp6FinYhK/L2hSTELSsgnyELaxUvUfm7tXDnNl3e+U78j9h75RcmF74Yh9Jf4NJvKt6h+P1zNdcXFUdXGJe3b74mtXy0y02hdJk4x1q6OQQ1go6AjH9gPtq1SPR03LcB1iQmSMcvjOFUvuq8HSF79/O9KN9WwIqKVyawok+XbZqm1z96VqCbkkO5sbGx+Q41xnTQZQCMctT8GFJLiZIOo9VvlJ3dftkmgczWn7YpDiKk6iHUOHECXruGzYHlP1ThM+LIb/0JueVBPBtkuPtnHPA73HETaFNE
 NT0YiUOU
 RRVT0IGhmQv1sQRvE+SqijkV2wIJgM0eSai1/bkLOXdoRcHeZGjHVqCBImCNxqYapkx4kVoWB6nds0BrQpm31EzugcYFbeiVPa+z5tDaBLaOCfUGKRjsBX57QY6Wxebu1EByriCuUtJE6TJLD1OlhDbThj+MVpRbf+kUE47/TjoI7yiRewScgLI304Vu45XX7oMb3nWPc+PO7uHeu/qedsg7nul8dMnpzIRqAsQAb8g2sFhGay5qh7gDjuzVtE6z5By3RCO2yN0AOnwqBR/u1Tjk2Sais10psSXpYWmsi0Y5JYcH40EObqiOtQenqwiTSCrAyVV0yQlvCa7R4iJjyDJRgzwAXSOqqk8Eyfk5sCkyrMC1ojky+i6b8RyLGbK1YB80NB9TG+WlfVhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 07:33:19PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> free_huge_folio() unconditionally decrements NR_HUGETLB, but freshly
> allocated surplus folios can be freed before the counter has been
> incremented.
> 
> This happens when alloc_surplus_hugetlb_folio() rejects a fresh folio
> after its second surplus limit check. It also happens when
> gather_surplus_pages() frees folios because a reservation cannot be
> satisfied, or because concurrent pool changes leave excess folios
> after the reservation succeeds.
> 
> These paths leave unmatched decrements, causing HugeTLB usage to be
> underreported and potentially underflowing the counter.
> 
> Increment NR_HUGETLB before calling free_huge_folio() in both paths
> to balance its unconditional decrement.
> 
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Closes: https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

I feel like the whole hugetlb accounting is a bit of a nightmare.
I wish we could teach free_huge_folio to ignore accounting-wise these pages
but not sure if that would be any prettier/easier.

I will have another look later on.

 

-- 
Oscar Salvador
SUSE Labs

