Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDBBCD342C
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 10:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFCD6B0092; Mon,  4 May 2026 06:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7566B0095; Mon,  4 May 2026 06:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3152A6B0096; Mon,  4 May 2026 06:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2018D6B0092
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:03:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C6808C928
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:03:17 +0000 (UTC)
X-FDA: 84729299634.16.1B19DD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD1EE160003
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:03:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e1ZrImbe;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777888996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPph3rYQIc84+KR627aCN8Yr5PHyYSpd1jWQoN5pbgM=;
	b=sjOMd7ZO37kN6y32KGWxDzFGALRvlr97yiXGMNTiIKCj+LrXU0R0/hlAcYfh9gkaBDd9MA
	yJPWMB3CKxlkjq6eePEDSDjl6eeCCjlxtNbbYbm7uk5pZCcC0xiGLr18IUZtsgOPRCmupc
	kUP0p9bq2ye+a5WW9s5llI/oDzSzLu8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e1ZrImbe;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777888996; a=rsa-sha256;
	cv=none;
	b=GQ7UZiVS11mSzTvvf5TAukVSxLEk1qx33MCZ/DJUHEdlyhNTH2OuquiASDUGdfPj88LfcW
	wSp30XSF3uXtXzjOvk1YnYlFN26/OSaIYxcopDtNgf4oYjlQeR/83gO4aiR80q7lkALK1t
	hSlEvjKduo0MWYce03Iihn3j1Q6eE00=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 99AA2416A1;
	Mon,  4 May 2026 10:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F70C2BCB8;
	Mon,  4 May 2026 10:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777888994;
	bh=enCxJHACsOEBuyxU2hbnmEQEliV/sn1koOsAuC4iyrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e1ZrImbeTyVCLuc7NGpS6TanJr/86xmMVmcnzDmbdJmdjldjiRkkT6EoxUWK3szJV
	 HSzJvfkf56daCqg2XDFkEDrY40SaCTYICN2sJKE9sX895dXLG5XEo0MayXx94ufK2Y
	 h8mKEAtRxtQ9Cd2S6g1kZVtingvvQ9K5m2N0zCnIqzdZU1tHPKB0c3/YH4LIeXe9Ov
	 K/LJZTVBpBco7L0ErHq/jF88oLP7N/GyLZpJk6xWI1ISsn0wrkrBQpQGpqtWsVRK14
	 h7wmYe8shEEYaMlfmEZtPtmWCOL5b7rUc0IBEB5Nbvqvs8i8QwHDTDTfcspNumJtIb
	 8iZ78XcJ+sEOA==
Date: Mon, 4 May 2026 12:03:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Michal Clapinski <mclapinski@google.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 0/3] kho: add support for deferred struct page init
Message-ID: <afhu23BqEOW_6_jz@kernel.org>
References: <20260423122538.140993-1-mclapinski@google.com>
 <afcdDm4aAJvNaQqH@kernel.org>
 <2vxzse87392a.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzse87392a.fsf@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD1EE160003
X-Rspam-User: 
X-Stat-Signature: ke9rzzqr1ik3x5zpjsd7grt7zwdsdiwr
X-HE-Tag: 1777888995-895025
X-HE-Meta: U2FsdGVkX1/Z6bSNGeWb8mIO3Xco/79e788XHIWXau5yPvoHS+rYx2LIc63++iGDopthP027PD2gp0xbzXJPGW1qZTHyJbQOTxzeE2pH4h4kEWZy0cqHWE8pdRldrrB6yZuyFaHUYcGISHFNJ+9rh22r2oRdDE+42dWCqO3cd56J3MdLfZ49JHVFHONao4/GRrP3MHy7s7NfNjM/oQAlabhqsK/w5bt+JjqXwBahhwoh9AIxLR9ef0fmeVH0uH0M8JxkERtQy7FCmxdWAAPM5ftNW0rFIbixTIPw6xNmU1MiBeMEj2cmhLIw/dSPCNnCvxUm1DN6wKbhh8B+y4I4SLn3mbXll13KNS+uq/7+6pFF859pMpoP90vVLqEZaEhlD5kGMGes0OJTFbjsPVAgLvEZlX76sPl3XqNoiFjFIRw2GUrwYdHZIYXHBNNCk4ZLVCSs9nMMlOjDi5meXj3oEI9Z6QDc3cCSq7pI6ra3DcbN/23qGoTvEH20YoqwEaF9thhRPvEYXMIW4EjBPO6+eUycd3Nt6NqlK+MCKYRqYdm/ztBipeO1eJorDUxjupfyCQerd8VVe5Gz0cUNI/YWPtgSQUVJ+JXHTqzRdSyPVf7cR3Gwgk3DUTUpU2L/XPzJ9YtDYq9iWhVkumJAwjzidQtzzYCRaaNzhaaJN4GuM5rXkfvATuTPvusB9uFN0xeAZfFMzOp9uyOtO5aGwcBY1YAucMONEsRauxFfn0JeFlQ1BbU4MhCxcPpgMbuO/YXTlWrnj2W25ARjRFgLbT2pAx/7XggbXT6rmSBg4DA/sE6cZOH2rZCLNu7DHIjYPoCEMxDZUm/JhBzHevjanYDIJ1Mfk3orfR507k+NuCRL8fyphkpTSSvb6Ecd7ENpXZm+lqY5v6CQPUBoJVQh91Y3v8eC4Akn1iE3TBCptf1HJuhsn6gZbPB0fRDi8exIm5kYsyGv9Hugh3mggwYFBwF
 L8zkSPZq
 sFF2guR9nyE4QVqCEy66jlP1YcDx2SDKzBHhtjNQhoQXf46GAPX2T8jh6NkUOkjUM6y5yaQYqbKmogf3ZWn4AJVqRrGv5Ymhza4jpEBOgfys03tCuCAA1T3FcoKf7mGUS6pYrep8/n7pJq0ynjJb1kBJRU325wIazluH74Q+lqwKldDA6y9XCHNY7l1fkH52Ho6XaZzGgVq/4ZQfloJRgk8gIsBJ8faCCZd2GYEXd+/JL4rsmihSP4UEoWLnSo3g4LT3HmoIaMQDfHZBSE8YN1ZwN2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 09:53:01AM +0200, Pratyush Yadav wrote:
> On Sun, May 03 2026, Mike Rapoport wrote:
> 
> > Hi Michal,
> >
> > On Thu, Apr 23, 2026 at 02:25:35PM +0200, Michal Clapinski wrote:
> >> When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> >> initialization is deferred to parallel kthreads that run later in
> >> the boot process.
> >
> > This patchset breaks memblock tests:
> > https://github.com/linux-mm/linux-mm/actions/runs/25259346624/job/74063911769
> >
> > Can you please send a fix?
> 
> Would something like this do the trick? It fixes the build for me and
> the tests pass.
> 
> I can send this as a proper patch if this looks good.

Yes, please :)
 
> --- 8< ---
> diff --git a/tools/testing/memblock/linux/mmzone.h b/tools/testing/memblock/linux/mmzone.h
> index bb682659a12d..8d934ff5b080 100644
> --- a/tools/testing/memblock/linux/mmzone.h
> +++ b/tools/testing/memblock/linux/mmzone.h
> @@ -35,4 +35,8 @@ typedef struct pglist_data {
>  
>  } pg_data_t;
>  
> +enum migratetype {
> +	MIGRATE_CMA,
> +};
> +
>  #endif
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

