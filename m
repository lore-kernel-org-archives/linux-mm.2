Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EF1CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 04:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891BF6B0005; Sat,  2 May 2026 00:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841E66B008A; Sat,  2 May 2026 00:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758186B008C; Sat,  2 May 2026 00:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6379E6B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 00:36:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF5E940464
	for <linux-mm@kvack.org>; Sat,  2 May 2026 04:36:54 +0000 (UTC)
X-FDA: 84721219548.13.ABF3F99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 63A3C100006
	for <linux-mm@kvack.org>; Sat,  2 May 2026 04:36:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khUhouRH;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777696613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vEqrNM8Ov0C8IDajlqIGYV7f2vnVxAjud2zW0XHTtU=;
	b=Y2KwkGx2vzXAo06a/YR4KZ9ZMc1uWrwfQR0kj4u+kDcyNSl/PhzUHXKupdNP6N1dcwPjLQ
	s55Qma9k+g9ZXr5a0DaUMl46mO+IjoUYDThD+3/cBPPgSNyxr0cTccPvDO2W8vcythNm1F
	LXWgoB6Ur/qg/mD7Gf6FIjt0H6hXFys=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777696613; a=rsa-sha256;
	cv=none;
	b=ijJ5f89L9OYpJSPkb+a40kLFvHwQDfNeSOwhbbrB+qQwLGKxc2xRoEYemUxouDsXNT82IT
	zb//se3ldMYtjLCTJvjhNS6sBf6zuwugnyfUuO11pZpQtS9k2NtZ5PWsBPUyC8CocWlRP5
	EGpk7ZoB2g6/gbuyiRs9RnIS0hXNdfc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khUhouRH;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9051160120;
	Sat,  2 May 2026 04:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEFFC19425;
	Sat,  2 May 2026 04:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777696612;
	bh=zolhHJ2pt/HuMbYoWDKt/Qpf9wHLyNZaEq9WM6A8T/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=khUhouRHFXetPZownjlJj4oZgiqqxHq+Ezb6aMBWxNmAbbyg2CSseLu7M8Of9wTIi
	 8ZPeDIjrC6Cjg9VPAAoQ5Xaa5hTvSsVi6BAkLQAh/umFl8x3zj/K6yEx1v6m/p6yZb
	 92JpBKWi3CxecuI1V+J6sseusteO1FdkC6PDdfVepJkiXNfT2uTyd3QGQ0Hu+zbAQv
	 r7/rL9EzUinG9AlODzSgPoPz4YVVk2IoKuDDzABQgRAod8pHNDt7X65Ftbx6Z2RPzI
	 Nxunz0hzvDIvYkrDauANYBwzAwEztwr+qTC3OoVaJga4y75klCQ/vJd+Dk2P868q6y
	 kr8q/ZkoNIj3A==
Date: Sat, 2 May 2026 06:36:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 27/54] selftests/mm: hugepage_settings: add APIs for
 HugeTLB setup and teardown
Message-ID: <afV_WAK56lQKn_z1@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-28-rppt@kernel.org>
 <2f443474-4448-462e-bc1e-55bc657d70ba@redhat.com>
 <afTF9RCy8eBoWYaj@kernel.org>
 <22b1cadc-4b0d-4e2a-987c-e7a7bc2265eb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22b1cadc-4b0d-4e2a-987c-e7a7bc2265eb@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 63A3C100006
X-Stat-Signature: zd3gr1wg58yi3fqz64hy5thzekp5mh5m
X-Rspam-User: 
X-HE-Tag: 1777696613-496974
X-HE-Meta: U2FsdGVkX19YNpdjY3VVz/S/zog0zgDvEh8+zwb8kA4tua+35rFqqRuZKpzXaxc3A87IW1aHrt4Y0IsjL6q9g94lm3vPpTMj8K7NcQi5NdOo6IE+BiNzZhLTrk8YpDuMMVNdQZJZHzQUQRANLv00396VpC4usPzQgKsKIIC++YZDaFLv+ekxCRTuofwPYDNuh1Xpy7SnobRFeGlwcjRIfpPLjob+cFar2JOoyj4CTPEY3I3GbIQcstmGdGUb3RH2RsPE7dQhy0gOXxFNBnoHu+YU97CVdB0WpXDLy8vd8OUYxAWyiEvEapKp8cneqrHmxZdXIRWQ/LE3vVUb08HzDK8MvANONKtFiNPXlzLfKwGFq/3cia+LWTOZ9Kx2z9O3PxapvgMoOC83qk2j+XIzYmwwRdJwXvEBL9y+C2Je9rdRdZXBzRyTBLzqc+lEqVtILFlGdeAb+HczYR8cTaoDnVAgmY69rtQyGAXAajlvHmZAFhotwoWm+0XDjwe7G3zwhAOKXriEVrBxwWW3z3nXpE/tEpxwyffxh2yqXVNM7eojMHX3vetEGKQMtB+thgXq4JZvyldXewmVUbRqR4zkGrlBMDC/CCgFPjdSosQtP250E+BYyA5APepGwDGsSWNRcBKT8F0HeEUOvIo0wL2n5Nafihu9TDwID0+J6GZvLBu24RMhSfLOP3mSvmlx+NXwydvNXnCa/tBDZ4pOXmzy9yAlw6AmxhOSkQsxnShNX8sdu7kgVqYxcR3zyn+5rXUYc51TFM9xrJpzaLgfNm9pOqriNEKRUUuJpTWnpgxgpV1Q/NkVIatuBamJFIFOHTnD4F9OmsH4qWRk5kj0+mK8/pwc+DG2qUqzpFmB3Wg6KNooND5iJ58AzJZEwoQoWyhkmL9/McDdkp1fcdr8tMTxLY6XznNq0eLAay0gFunNWBHxQTWIxMZXnHUt6PbodGDm/mN33O+0Llb9Yj/TVVI
 ili/6/2V
 jtoulrnS047bmbcd1KvxkG/L6cmHZK30XszKM7BuvhtRaY9PqvptD7z6gwT+iwrH9M0WSU5aqYp1pHy5VT1qCavYWRccbMkTvKztcO4f+EZWEXbrE9qZvE8z+xtSavWhoPACL4XEDrbnwQ4XkK6+Zuxixch+ZU/bgKgcW053EcOBlY8gMlnd97UIdN3IkJUVCf2LVY+2LTaLKQP1cOYxVkaxG2sTmU+Dc6LGcBYdeKceFl00V52vYjdcGX/gyQwk3hOTBsIXxiCdvVRYpcQyP/8STN7Ris4X/E2L+wFbsTQRYJbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 03:30:18PM -0400, Luiz Capitulino wrote:
> On 2026-05-01 11:25, Mike Rapoport wrote:
> > > >    	return mode == 1 || mode == 3;
> > > >    }
> > > > +#define HUGETLB_MAX_NR_PAGESIZES 10
> > > > +struct hugetlb_settings {
> > > > +	unsigned long free_hugepages[HUGETLB_MAX_NR_PAGESIZES];
> > > 
> > > It looks like we don't actually use this in the API or maybe I'm missing
> > > something?
> > 
> > Yes, it's used only in later patches.
> 
> I don't see it, the patch below builds fine (again, sorry in advance if
> I'm missing something obvious):

You are right, I misunderstood you comment and I thought you referred to
entire API being unused in this patch.

free_hugepages is not used and it should not be a part of the saved state.
 
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index 097ba085f423..a023cfeb69c5 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -341,7 +341,6 @@ bool thp_is_enabled(void)
>  #define HUGETLB_MAX_NR_PAGESIZES 10
>  struct hugetlb_settings {
> -	unsigned long free_hugepages[HUGETLB_MAX_NR_PAGESIZES];
>  	unsigned long nr_hugepages[HUGETLB_MAX_NR_PAGESIZES];
>  	unsigned long sizes[HUGETLB_MAX_NR_PAGESIZES];
>  	unsigned long default_size;
> @@ -509,7 +508,6 @@ static void __hugetlb_save_settings(void)
>  		if (!sz)
>  			continue;
> -		settings->free_hugepages[i] = hugetlb_free_pages(sz);
>  		settings->nr_hugepages[i] = hugetlb_nr_pages(sz);
>  	}
> 
> > I felt it would be too churny to add users in this patch.
> > > Otherwise, the API looks great to me. But if you allow me to bikeshed :)
> > > 
> > > I think I'd do:
> > > 
> > > struct hugetlb_state {
> > > 	unsigned long nr_hugepages;
> > > 	unsigned long size;
> > > };
> > > 
> > > struct hugetlb_settings {
> > > 	struct hugetlb_state hstate[HUGETLB_MAX_PAGESIZES];
> > > 	unsigned long default_size;
> > > 	int nr_sizes;
> > > };
> > 
> > It might be slightly nicer abstraction but ...
> > > > +static void __hugetlb_save_settings(void)
> > > > +{
> > > > +	struct hugetlb_settings *settings = &hugetlb_saved_settings;
> > > > +	int nr_sizes;
> > > > +
> > > > +	settings->default_size = default_huge_page_size();
> > > > +	if (!settings->default_size)
> > > > +		return;
> > > > +
> > > > +	nr_sizes = detect_hugetlb_page_sizes(settings->sizes,
> > > > +					     HUGETLB_MAX_NR_PAGESIZES);
> > 
> > ... this immediately becomes more complex.
> > 
> > > > +	if (!nr_sizes) {
> > > > +		settings->default_size = 0;
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	for (int i = 0; i < nr_sizes; i++) {
> > > > +		unsigned long sz = settings->sizes[i];
> > > > +
> > > > +		if (!sz)
> > > > +			continue;
> > > > +
> > > > +		settings->free_hugepages[i] = hugetlb_free_pages(sz);
> > > > +		settings->nr_hugepages[i] = hugetlb_nr_pages(sz);
> > 
> > And this as well.
> 
> We'd need a little more code to handle those cases, may or may not be
> worth it. But enough bikesheding from my side :) the series is great as
> is.
> 
> 

-- 
Sincerely yours,
Mike.

