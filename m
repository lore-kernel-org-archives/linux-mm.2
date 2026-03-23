Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C4BF46122
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5A86B008C; Mon, 23 Mar 2026 10:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CA36B0092; Mon, 23 Mar 2026 10:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9A76B0093; Mon, 23 Mar 2026 10:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2776B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:02:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2C7F160C0A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:01:59 +0000 (UTC)
X-FDA: 84577491558.06.DB57C2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0976C1C000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:01:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIv7r9gm;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774274518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTFQgd6UAfntX2EOBvUp4JNXjOc1vvt+dLwlVyJXSdI=;
	b=xREkELMzb4xL+FmPAAETwMznyVVL0zVrQA9lU4O4auByHJmOrEq7AAjgmjZ7BNJJf1pT0V
	5NwimeO6StJ966y3ql+IaLLiJRLoGd90bYpA63FhuoZ5/nI72hv8u8A6mpOxRtA4RErbdF
	SDRSQ3fzCpCIDiN9x5BTJLu0VFMYan4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIv7r9gm;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774274518; a=rsa-sha256;
	cv=none;
	b=3kZE4J0HwJz4vURNZc71Wg8e7UYKYWIN7hPQBg/eXVHOYkPNKosQKJPI+uV/bh4L6aKSUY
	TWdm/yIHT7MGBk9m6Wd9Tpsrm99CX7mbzs9fSPxV/chhuYAp5f6/9UwtzFoHGi2Dc1GqAF
	1LheDen6+Ljcdtd/wCDVisiVvK4hLO8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D1EC437B4;
	Mon, 23 Mar 2026 14:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B164C4CEF7;
	Mon, 23 Mar 2026 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774274517;
	bh=qRBoRCAG1AghwUkxPxW1t9X5uhJ/X4+sJp2KekgxAqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eIv7r9gmkdp2hQEPT+RQwzw0HAh83mEHzwReJJ/Q9UBeyVaChRDaUEzOSoeiJKeK4
	 n9qKuj1CmKD0NsohFdfzulvf0uXu0NWBBmdnKs3ycY7oOXjXmujJx8wmqneSixxXuk
	 vyfd30GO09g1zf/RFeQ9m6yeAguxw+nbT5kcz8Mgd2G/8ZD1/3KXULj2Pyck95PmJw
	 pg78MTNkrW9Ss8g6U+EAcCHJjx5rxWzOxubohZEPyH9wD71BGLBzA4eumRnKjvevyE
	 U2zXyKD4TgOdp1AlhnLI6rVb69SYqF0PxBYw+kAn8IrPnOI+vc+xiUrJi9KQjvbac4
	 mQzv3WX2XKB5g==
Date: Mon, 23 Mar 2026 16:01:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] memblock: move reserve_bootmem_range() to memblock.c
 and make it static
Message-ID: <acFHzfJp0CxR43fG@kernel.org>
References: <20260323072042.3651061-1-rppt@kernel.org>
 <445a1456-68da-45e7-ac0a-c1ed0cd086c4@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <445a1456-68da-45e7-ac0a-c1ed0cd086c4@lucifer.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0976C1C000F
X-Rspamd-Server: rspam08
X-Stat-Signature: m59yb7iytfkercmyxj4qy5ykw98upqcq
X-HE-Tag: 1774274517-319383
X-HE-Meta: U2FsdGVkX18I/afcCd3hwdCSbOU0Js7yz8Un/7Ar73DqZsW8r4vEsSlLET2q1ICyhBanpoydaLG9oC7EnUL1Ioj4vmAQiql+E+7NDhQJlxQLrjOnIdjDNKBoc44wP7kpqJLWYcitdjP9Fsz3y9jHZ4dGWd4Z37dJN0qaTV3zkaEJ40aptfUwNqlCEzOJVvM2nOQuUGjQJoWcNAuMUo1sHIkJO71QhV97OBlpLy5r4JoJ7x0Y4jNCunW1pM9cMYYYiAGk9IYvV/8hMbOoyzqJC021dnlq8f/TpNMk/rUwkYYQvYzPqLyCtvKing4jwD+KS/XdTryxvQNbbm4+z9ow6esx/7tFyAMuKDCgec7VvU8x5oELGaNJDM9+qmUkWWRqn+j4HBFl59wBrK+LYRZliE3VyNSXapUVFsh9+saF2n1b+PVSw1OoIm7FsK1BF886iwbhR0eMEUuRo7FmjgcZoYKJ1BwxBpwTFp7A62/vHc81blLMkfVwfYI7ODhLZNTWFdxdVsWW+j2anMhPsaZC1k1JKM8b7q/jCblmXBLfbYGKsvwMO45MkGDka6XHHbqP22qDp0eEBxISmpx1A6rYRP8Cm/jS24y6cvnilbYneW1TouU9wcMurJF+sn2g9H6zWqMwB83vSA5LBPZ3gCPoZtwIpxCZC0VYk9vkTgTiD49uDrYA7BhSZ7DBDOcJJ15b8Sd0ieLW9dBB7xdUoMKcZyicZwmVOuVOJjbSgZ3WYa8bY/SCd7R3K7A12QcT+Kc/dehde8HHELHg2WJyPkCS7RNRzKNGizIWt6XHV6/qZp9IWhdEByWS8sbYmdqL+kE2M0K/SFf1NSYmWRqHg9Sq2Us4bJU1zQwpu2Qov2Hlk+2n0LKmc8QZRnG0Gwvq60yZvJ588F6vxxVccv473pK6X0pG0QQbthkLRfPJtQnr+6shWdboRItA16EXpeXKnNilP4O/iGMtgie0do/a3T4
 oP76P8mr
 HO87r2QgeXj2SdtcDT8sVPpdiRKPjb2uB9OQBylFWSVVxkWLo5yAvDw5xpZSvVyJseeJzlJ2dAXLEWZnSHVRGc6jdBzzcC9fxOkKCfSt8IbTzKx8QI6+sJMgc9PLeEnIpuiZcJxAu5MJuudNdixTAFeHXlN5UtFxxP/cal4QC0pZ0J0Aypc0i6zofo5SEzzV4zrIMmVDgySwGvWBIclbIMc1BOdfoDOphPlpjTEP3KO8DVAEckQG1lGlFIZMioqrk3sajw3DYKLMC9JlcjlvcKnsSWJ/9AhyCijaP8HyKq2n1rFOzpiZcEOGb3pP0iVdz9LC0mCUFYUMB/wAfh9l/wyfGLpSSoAsFdy2B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 12:37:51PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 23, 2026 at 09:20:42AM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > reserve_bootmem_region() is only called from
> > memmap_init_reserved_pages() and it was in mm/mm_init.c because of its
> > dependecies on static init_deferred_page().
> >
> > Since init_deferred_page() is not static anymore, move
> > reserve_bootmem_region(), rename it to memmap_init_reserved_range() and
> > make it static.
> >
> > Update the comment describing it to better reflect what the function
> > does and drop bogus comment about reserved pages in free_bootmem_page().
> >
> > Update memblock test stubs to reflect the core changes.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> LGTM and passed local tests so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks!
 
> > ---
> 
> FYI I saw the below when running make in tools/testing/memblock, doesn't look
> related to this change but maybe something to address?
> 
> 
> cc -I. -I../../include -Wall -O2 -fsanitize=address -fsanitize=undefined -D CONFIG_PHYS_ADDR_T_64BIT   -c -o memblock.o memblock.c
> memblock.c: In function ‘memblock_add_range.isra’:
> memblock.c:710:17: warning: ‘end_rgn’ may be used uninitialized [-Wmaybe-uninitialized]
>   710 |                 memblock_merge_regions(type, start_rgn, end_rgn);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> memblock.c:616:42: note: ‘end_rgn’ was declared here
>   616 |         int idx, nr_new, start_rgn = -1, end_rgn;
>       |                                          ^~~~~~~

Oddly enough it does not warn in the kernel build, so I kept ignoring this :)
Should be fixed indeed.

-- 
Sincerely yours,
Mike.

