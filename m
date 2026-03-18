Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6F3FCD0DA
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A63B6B0137; Wed, 18 Mar 2026 04:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657DA6B0139; Wed, 18 Mar 2026 04:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D546B013A; Wed, 18 Mar 2026 04:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 45B436B0137
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:50:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFEBCBA521
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:50:42 +0000 (UTC)
X-FDA: 84558563124.23.EB6414D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B8DF4000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:50:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ab6lwJ2Y;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773823841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFgFyvLp1bTDjeOj2Ntl76WYXj0lahPihJmhMPC9M/I=;
	b=ueVNNsGmnGS1GUcvowlxhrHODg2xV7g5+2iusjpkFPsElrmcg8WN57nsyO0/OA72DKi1aC
	H/lY96DL61o1m6uH5dyaQyPPwoxIXdTUd+5caZQNifKVrNxwqVgx/B0JK4uzuYIWimThrg
	+vhRflgwRg4O3x4IvHP3J5ZwCo+jUkI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ab6lwJ2Y;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773823841; a=rsa-sha256;
	cv=none;
	b=dKvqcTZ5uyJCvap9jUOsIj22bmDpk7BSE3vHuuTLQFfb6cKybLZGJbrbp5R3VFZRZ3Rx63
	Mlbna8WtjSltjp3oPzzxFeqmZj1/ubEV5dIbLNM7aWZtDjfD3IxSbqn6f6S071H1NIj9Nu
	k4qhfkIs4ScDPbrRilkrxvxyGFY6Lz8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 01F3F40836;
	Wed, 18 Mar 2026 08:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693B3C19421;
	Wed, 18 Mar 2026 08:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773823839;
	bh=nV3CgZQVuze+oFz4RZF7Bj0CJqIuEP6bWFViPuWXut8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ab6lwJ2YzuuyOJQcorOYMuqxkU+bbI8BtyGoEKJPYdRcOE69b9R5iDPwpLA+o5r+v
	 UdxY18Nf8PFve4Ecj2wiyr23uciS56NbvrURSA3V8iPfyGkxUC9H1M3YvbVmnfaGw1
	 gtO6Xbe80k3gg7eqt+pzzokT1/K7CmtEEL0ovp0836+/58T2KhvsxUHX9s6XDP5I19
	 eaYkrSo4IvFzHnJY0RfD5ZD7cHXlHdD8JaK0fbgxsDsveyy3LaC7beF7Zh149YQmdl
	 Nwhv8dSqJr8pQvP93YezgNOutiNb3nwZ57XVGxQypSBoMmqN2GrvPPJ9DWTxDqGd9/
	 ieMr2pkNkEn/g==
Date: Wed, 18 Mar 2026 10:50:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 11/14] mm/sparse: drop set_section_nid() from
 sparse_add_section()
Message-ID: <abpnWdLe1xRJ4uqt@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-12-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-12-david@kernel.org>
X-Stat-Signature: h18tbtkm4kcu14qmnobr69ghj8ediraj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B8DF4000B
X-HE-Tag: 1773823841-843950
X-HE-Meta: U2FsdGVkX18oON5vP5t0UtueCd74kOqtH0+kyF7xh4O9sp+8PaDolonstNogLqhl2WngiYr5/Pe4NRrirKVXRdtBOVCi/qvXPTdEem1MJL6pdN8OtctsSyxPTNNkT04q62bUyfP6KCAj2Xy0HmW45hEG1QMw+/PE2I8F+F3kVw0lOWYT141OPRBOxiMY+1xYvatiOwUaxe9qRi/jgtNiwnhfUUnuYrTH+ph6P7cyRvNzmD9lREk4DorOKN9g5HpsvnutS4OEQnOoDnHGWswO9B4s6Eenp1S8RVtDwnvPLbB0b39fDgnQg4sV/xAg+7R50/uyE/UgPwCcYbhdD5KjWohRBY0yz2sFtsqIioiwJyBLpm2Pvt3PRhjEYaylNBzxf9QtN3cvXPREakReC1yLbDqlOSwZRfMyePP6lCNZgxXXA6RhSRxuPsUNxZLeSpyJ5LLtlr6O0/aosBBP4ftdflXuV9PRS9/LtCGhrFi7rwY13g5lKZ+Ia/t1C0GOvzWokBD2UlFj1Aow3GrxEWGe/LsxTMtSd2skrkYJhQY/kHj4eAOqK2qobOwRRAe3aRzGD63tyODE6IiemkLwglvhb76xf3vg/Kah1R0LCBBa4AOZQni5n0ldKYp+IhRkFImj5JiBboplbgrAW7wlrjalla/SYWAGh/HwTuXW4Q5pfUZjKyReYFdS+LcXTZp9EkUQiPFwO4WgU5X5BhshPlac3cOgHh97lyIxNzB2h78VUO1eGVnbZckfpRDqkbSKJ/xvD2Ycu1nLg/yj2R+0f7Ddmxy6u+Qgc8xsFeu8KE6q/wDlu6vZy0YsB27EaSE38ldY/WCJG5j2vP9k0/QQMT7XUKuLt3C1S3dlpNzUMD6C/EpP0DYMhdRV+7be4HkztBxtWlwtD42luTwN8Zs3uCIkv8+GrinD5+9t12wdMoWZfYsRlIUSqONfuEUEOtiYLgYO38faQt1xF2TsnUPq0Ey
 5CJB0Gf7
 BLjJt2lo3OhBAzXojMWcc0VhKQWEevZgSlRQZRHypDgb+eI02IqTYgJKzz2+f26w08iEkvDZvkHRY46lzWFiHG2PTNqbLz3pz856ga2wu8e6esZVRmIrGPLp3a8HFgpIymX8JEB9N9so6gZXqbi9bw3LAvgtcIiSPnifkFX6iX0HH4mYggomPIo9bzA/CCeFWTL5FNG+i/kvDxZYFmiBQLjBptvMzarIH0rBccLnaXRa2g9xvfi9sejrQHamnoOQR/oWKRem7hQwglXY8IwzIl3apU9ivqRZZHxtdShuZ6Xyjp+faqzP81JoJLo2yW/qbzkKpIFczcFRFqRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:49PM +0100, David Hildenbrand (Arm) wrote:
> CONFIG_MEMORY_HOTPLUG is CONFIG_SPARSEMEM_VMEMMAP-only. And
> CONFIG_SPARSEMEM_VMEMMAP implies that NODE_NOT_IN_PAGE_FLAGS cannot be set:

Maybe 

... implies that node is always in page flags and NODE_NOT_IN_PAGE_FLAGS
cannot be set

> see include/linux/page-flags-layout.h
> 
> 	...
> 	#elif defined(CONFIG_SPARSEMEM_VMEMMAP)
> 	#error "Vmemmap: No space for nodes field in page flags"
> 	...
> 
> So let's remove the set_section_nid() call to prepare for moving
> CONFIG_MEMORY_HOTPLUG to mm/sparse-vmemmap.c
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/sparse.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 7b0bfea73a9b..b5a2de43ac40 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -769,7 +769,6 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
>  	page_init_poison(memmap, sizeof(struct page) * nr_pages);
>  
>  	ms = __nr_to_section(section_nr);
> -	set_section_nid(section_nr, nid);
>  	__section_mark_present(ms, section_nr);
>  
>  	/* Align memmap to section boundary in the subsection case */
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

