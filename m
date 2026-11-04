Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A663606A33F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VjXz8EtB
Received: by kanga.kvack.org (Postfix)
	id 571F46B05B4; Wed,  4 Nov 2026 07:16:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522DE6B05B5; Wed,  4 Nov 2026 07:16:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C556B05B6; Wed,  4 Nov 2026 07:16:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 229A86B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:16:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 044A81C4052
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:16:50 +0000 (UTC)
X-FDA: 85397335422.05.1E8EDE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7872E20004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:16:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VjXz8EtB;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793794609;
	b=OXjKpaUlrhPJ5goEKaNojNBEgmCWpyDI3BkGEww/OlWhmlZsMNRqCQxDxdQ6jld5cjmgAz
	gfs6PeO3Ha+o0vIqqPLS63EFVIUDJGrNOP+er3+zchMet0f058p9KCESdKtqnrEYFT1p96
	VE3L8uvcfx5cVL4pclCShfNGL+X4xRY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VjXz8EtB;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793794609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/3vwj+tiIm8HubUvjjG20WDs17JU+2NaRtagz2TVFw=;
	b=bpeEwnQg5gZ9jH/5S7Qo3+UqVIR+sUZsgtLScPBDNVRrgKqX2bEnKcpjbWjjsyYeD9ISBX
	HYiWD4ytqFAL4OO5PjIITwyYr4vfgyYA0VGxYqHVbFZRpmZVHA+o3GfVGPZY/TyRdKaYqN
	taBgwQrIGIujVz7Ey8E0SWNtyfqJEH8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB13C60DD3;
	Wed,  4 Nov 2026 12:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6581F000C1;
	Wed,  4 Nov 2026 12:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793794608;
	bh=5/3vwj+tiIm8HubUvjjG20WDs17JU+2NaRtagz2TVFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VjXz8EtBZHlvkbgkiDZA4dGgUrfn6x4W2ZaYI3reZytIB49vC7+K9tkSlFq8cnvAr
	 MfTS0Ovayt0zPn9AW9/ZEz4jx+zZMRXBsSe5PR/RhIo04p8vyofcnRSZ4KBKWTmfrk
	 IhqAJ8VQaaez+i9POmQRNK9CK0LGAu1yM0EDY8gbYijmKxNAX13KWX8qq21nIeKqr9
	 g3rl7By2zm9EO55PQvYWsyGKv+1McckTMwir1q56IvK7COH9oQmi/pZLA9ktpXwjB2
	 Q/Yjvxfu2GEOG7a3eSS85xpv06XoRIKkv9fOkKYZ7lpJQzrj4Y0FHzGeLTC0tuEJJF
	 pfUiyu44MfovQ==
Date: Wed, 4 Nov 2026 12:16:46 +0000
From: Harry Yoo <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: kernel-team@meta.com, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array
 after concurrent resizes
Message-ID: <aush3AHoVsuLJ_Ig@thinkstation>
References: <20261016132510.789715-1-nickolai@csail.mit.edu>
 <179330739525.606664.13318485044610934477.b4-ty@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179330739525.606664.13318485044610934477.b4-ty@b4>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7872E20004
X-Stat-Signature: 8xkobdjwbqeufosbgrn5jr6wgm1az4w9
X-Rspam-User: 
X-HE-Tag: 1793794609-571813
X-HE-Meta: U2FsdGVkX19va4d29zJZolt7JUKGE5NGCPzJkM0A+nVmVDSA/fcfnPHCQm/0x9rBeCxRtngPEovgQ1DfhIOL1bJCtBzF46SlUXxOoh6xHUx2biXm6M8tvHfnSncQxPcPlMyQL0e7yuPCISgoV3QPADO6FCTxh5shpwDrJVA3MDjkMF0fNayg1CeyvRWYt7aArtps6W8ZTr+XhNK95XKEIoFat9vJpKosUULu2t0bOBAvqvaA0ahyxPQ7xa+thitqagNz2JCl8xMen2bVMvoFPv+ZvJRlC/V+v4aj+cwcyW2xrqYLx6X3EfbrxSQxfWAzA395h404dJ3ZgYXFGtFtukuOhCB2CMHXcgN2ehmyv32RC/E+DmL2W3eokSy7AxxyL9xOWf9kRdcHcIFODREi5ljyAYfffrKC28wyFJDJpUxNgwUDkgV3P2AHHUyQOVk142BlCZishUrphLjr2CNOlZpcn3sjt2Y07zGvkD4Ljk0S27/MPWv81khjYp+ALggOQc+v7IwXK+Oe2Td8LFormpApv2OwZfwnz/9vdXNgLYVmtxvLx+EBbGUfgmfoYvFEeichHXs8D0jdpMlsJew/mx7qwk0+jwOOAXMQTsr6ph1w0Xt5AVjTTYNEpJRvbmc8CE7zwlFYZG4U7x5c9q5IaWgAc0iHWty2K4h2vFAF+Pu4lHGOywPZKF/8HsuD79Lin+fmsnDqYctDKe5gDzGN3ssv9J9Yno3f4+tZ4oyJd1Zahr9IWnQ1Ygo2rb6Kpb7WvbFRwUtF54u9LQU3xNv05VURVYDG8xn9Tv2MXX9xMO2F/RuXEG8dhdyJwxkdKgQNJEW562vu8IJP9cypA1X13n2Br7jjNAv71C84PCwvQosRW5CnBuqmp8TVtVZqLRyeVMwVpXiyi0hr+QZHIwlRqoxFRtVTfo579/5pxxHsD+N2P/+ifb7BB6dNIRTp83/e0S1v8SLRyD+ixMcSkA0
 kjNqag65
 YHl3Um9jC8EPKyzHaS2h5vMW7BZ1YjVe/DQbVbLjQ971BYGuSO0zfXfs9MoJvbdnZVHb+nkdyJMVFR6ZT4Wa0GPKVlt9SfgedGpCK+YeVHNn3t4fuoQgabiIKRmNmOkbVPwQB4XIrI4E+zY0Xex0Lbhu8/HaWYkjuFLIgFyfdry4QEUFPLhak6Aw8sxnlKLa0yRqz9jpny3ldwTLI3PJf8l3k0jf3K5uJl8GoOJPVKL87biznldiR8sl9cEjyHR4HHeDSL2JOvAkelU9ONeUEx6r3fdPqx0gj14JLHlbGMyrhx6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 08:59:01PM +0000, Harry Yoo (Meta) wrote:
> On Fri, 16 Oct 2026 09:25:10 -0400, Nickolai Zeldovich wrote:
> > mempool_resize() shrinks a pool by dropping pool->lock around every
> > free_fn() call and, once the pool holds no more than new_min_nr
> > elements, stores new_min_nr into pool->min_nr.  new_min_nr was only
> > compared against pool->min_nr before the lock was first dropped, so that
> > store assumes nothing changed meanwhile.  The kernel-doc allows
> > mempool_alloc()/mempool_free() to run while a resize is in progress and
> > the grow path also copes with concurrent resizes ("Raced, other resize
> > will do our work"), but the shrink path does not: while its lock is
> > dropped another resize may shrink the pool below new_min_nr and a third
> > one may grow it again to a size between the two, replacing
> > pool->elements with an array of exactly that size.  Storing the stale
> > new_min_nr afterwards leaves pool->min_nr larger than the elements
> > array.
> > 
> > [...]
> 
> Applied to mm/slab.git slab/for-next-fixes, thanks!
> 
> [1/1] mempool: fix min_nr exceeding the elements array after concurrent resizes
>       commit: 8dde7b06d2d819422c736dad7efb9635b6673cc2

For the record, I rerouted this from slab/for-next-fixes to
slab/for-next as it's not targeting -stable.

mempool: mempool: fix min_nr exceeding the elements array after concurrent resizes
commit: ce6518e61e3b4bf4f97f7ac6204049b9eba7eb75

-- 
Cheers,
Harry / Hyeonggon

