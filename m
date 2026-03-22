Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4C2FC72B1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 10:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98FCC6B00A5; Sun, 22 Mar 2026 06:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940D66B00A6; Sun, 22 Mar 2026 06:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F1D6B00A7; Sun, 22 Mar 2026 06:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 752946B00A5
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:03:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FE171407E8
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:03:34 +0000 (UTC)
X-FDA: 84573261948.20.D45E606
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A09D4C0004
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:03:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jkwqs+Gd;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774173812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgV97nrXKS4evIy2Ut/S7Iw2f9T7wvmtiE3+zTq7KKU=;
	b=LR7mYwD1uOXXbN2p71XcisZITAZorcuKl7HD8SzA5hUQcrHTZ47InRTrt6pqstRw/++0Bq
	Ega/cjvEA0jbBvnxZYKk1fEeteRO0LICr3t+DGBJmlAViUoqlderCOIyGsxwtI9cvUvz8y
	aZ5vHbLhk4G/gLiWDJ7g0IiihcUshac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774173812; a=rsa-sha256;
	cv=none;
	b=wt+l33UT/oPAcc3py6gsrWChBEf1aQsanx1juV0+S4PKvd5iBHd4dWH6ypGuc9yo0WRk+d
	s7yn2NH1q2iTcNWfZafdWQHSSojhFQOqMWuQgf020HD4X4G+drV8qFY4lAHDs/XzrkBDaU
	rTtqLpZwJgVoZTwmumrXWaqhWqblg80=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jkwqs+Gd;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F2E18600AE;
	Sun, 22 Mar 2026 10:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E66C19424;
	Sun, 22 Mar 2026 10:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774173811;
	bh=Fd+lxjtADX8/WZHW/OyQK4X1bNRqeHw1tgTw6r/x3uY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jkwqs+GdaaEAajw166Bmx1YdcGAsvLlGDPSFBV70sxX+r1fX5sTLxCaahqhaG/lUd
	 MUVFpXziVlYbj1lO2VnT9P8q0ZW4amvS6+Pc+bGSziz9pcMYA0Wv3M2IXakVzvhvJM
	 LJGXn61p9spS2dEUse2xD8c2n/9cNe9Fv5vRUXOOoFl5PmWJg8GZ9oxHl+WeAUWa5t
	 xlfltvoQkLoBSKpJUaerBRbWx2DpQAlkTGOhBSNaZvvhwwk6NnJtbolesp9EM9EIFO
	 cNiBxU0nK9gppQK6FZUvlQkCpr/05lk+bGhp/MJUH7Uek1PPbNsbeQkncCWE4VhLOn
	 7TY1/0TcY3zSQ==
Date: Sun, 22 Mar 2026 12:03:20 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 02/15] userfaultfd: introduce struct mfill_state
Message-ID: <ab--aBVpTIU0Kn7d@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-3-rppt@kernel.org>
 <cf190f78-3f5f-499a-aa78-35261850b01a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf190f78-3f5f-499a-aa78-35261850b01a@kernel.org>
X-Rspam-User: 
X-Stat-Signature: n3dkk7ajchg8dg795bjpu918fo839j7r
X-Rspamd-Queue-Id: A09D4C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1774173812-167383
X-HE-Meta: U2FsdGVkX1//3dYRo2RsKAmy8p/XgsKFqiouchGnmLXWig0K+VVl+zGHknUC16FlG2V0DKjjuQEMoPgADR7VWtF78nt10rcxDEEK/uUNcgXH/4TRAG9Rpl+p9UXFSN923nTAN5tC1qd0kJgQmkvusKO4VYmdsCF+1x7dxC6DkZr9/xo941a9VPdqCMgyk0Kl91RleqjR8F2/mtf2wzTAsxh2pO0zsoV2WNduNiaF4TvEFogep2/dbXZRG4/WDVbAn8xoBS+MjJw0kxPvfJSjj83FpaA+Ya2H5bukf0bT7Xl4KwxZoX9bJBhtg9ZBw9rMRx9FehIKesthG8JjxkOjgH+RVUjBFmo6RRFU3h6x5b5BEc8nzQIKdw508jot65tpzNzaSGZFw+HgF77ohB8rZDwh98dA5QilqiOCGujdXhM+J0av9W5hmU0io8D3rFMNJX/HiOqLhfymSUNd7+rVH+ZGd5VUf+/Sjp8i2qxSff0GtkMQQUWGIFXUJPQzQmpmaSu1eHqKrnpj5szMMoVr9lSZpGIiQoCTPhzsQjbovUAU1eak0jC4bM95H7L9Az5hLVLbOB6WsLTn/RZ0j/+2UnLTLcSOXrtGMKmqW2PDLo8UGyN71o52J0qODRJjGuPnuaZtGTkHli5Cj132Q88M1H1ZHk4kfJEATswJJf8F1fqtu2dUubdU4R29J8hqHV6KGydqhYh0XawpoFKCCVdRZRe19cYRuEGBrIdQfvqZeKG4o0y2VP7K5Q4eWtAJJXpRUundlSjgL9svZUz4NnW7LJ7HyWxUz4IIW9uCn4dwzvb4SCDZM/ObkF1TMi5u2R0APKRVqaGVK4Y+1MbuuSvbsFe5FRFXb+s1R2griVfDoIx8iVEVA0hURPRaRWufz1XOMPziXqc0lTyuQq7vC8ITW9hjbacCJZzvab3R7IMaI9I9v5GYcHfWfqmHPi+DACmda7wnG7dtMzGFeE6eNhZ
 +Tow1ird
 jEIzrLWaFy5B6A+3pjR1ZStWRqDEW++sMPQnsPaK1USGbZYClGkIIicsf+MxLiKOge16xWt+SD6U8djT7mxsm3Se6nbHUge6u/Y+9RfBwnO2Iq7Pyam01kTfU3sJ2/8CCeQisACbIFr1o2FR0Q+obIzXRvxfo+aqeGO2/9MlSTHsGvaH4fF/BRMySNYcIkfAyip2xlvzzqxE31NAWfDdng2CFm9GgJQ3K5zqKXHa9TrCD2p3ie4FJoGHTyrfkdRDKFA0u70sUity7cL2hsiECoC6/AZ3V3A++XGtLN064g9TdoAFnsRos9WQPdMfxPs1u6lJPLXQCH1WFAak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 01:43:02PM +0100, David Hildenbrand (Arm) wrote:
> On 3/6/26 18:18, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > mfill_atomic() passes a lot of parameters down to its callees.
> > 
> > Aggregate them all into mfill_state structure and pass this structure to
> > functions that implement various UFFDIO_ commands.
> > 
> > Tracking the state in a structure will allow moving the code that retries
> > copying of data for UFFDIO_COPY into mfill_atomic_pte_copy() and make the
> > loop in mfill_atomic() identical for all UFFDIO operations on PTE-mapped
> > memory.
> > 
> > The mfill_state definition is deliberately local to mm/userfaultfd.c, hence
> > shmem_mfill_atomic_pte() is not updated.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> 
> [...]
> 
> >  			if (fatal_signal_pending(current))
> > @@ -866,10 +882,10 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> >  
> >  out_unlock:
> >  	up_read(&ctx->map_changing_lock);
> > -	uffd_mfill_unlock(dst_vma);
> > +	uffd_mfill_unlock(state.vma);
> >  out:
> > -	if (folio)
> > -		folio_put(folio);
> > +	if (state.folio)
> > +		folio_put(state.folio);
> >  	VM_WARN_ON_ONCE(copied < 0);
> >  	VM_WARN_ON_ONCE(err > 0);
> >  	VM_WARN_ON_ONCE(!copied && !err);
> >	return copied ? copied : err;
> 
> I guess, "copied" could be easily avoided by
> comparing state.src_addr with start_addr.

Yeah, but a dedicated variable is more robust against potential changes
in state handling. And it's surely more descriptive and shorter than 

state.src_addr - src_addr;
 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

