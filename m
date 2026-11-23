Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E432606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oXONOuOT
Received: by kanga.kvack.org (Postfix)
	id 5B7126B05B5; Mon, 23 Nov 2026 14:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569026B05B6; Mon, 23 Nov 2026 14:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4706B05B7; Mon, 23 Nov 2026 14:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FFC06B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:12:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51E7D80984
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:12:28 +0000 (UTC)
X-FDA: 85467329976.22.90BE300
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id AAF25140005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:12:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXONOuOT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795461146;
	b=tHpqXQKM9bcylKka8m2ZsqkXOi/FYVw5UdCkBXFCDAQL0QL7KO2FRhjaKDODSIoLg6oI5e
	GIZVngYUxGAmtMx9Zw0QmL7GJls912qmJaFDneGSjloIjG7W/FCHQ5V/CDWscJ99v6Gc32
	uaTVjjhr054BtaCYhpc4//spzvpkOJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795461146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0jnP1mkAlUHs1a97wQnfbe+8kkRLHoLQ0+Z34Mwikw=;
	b=DNlIQSqe2W3n2BLpwbjKwzan9s9uXGYJ3M4dY75iOvCiIHh7UiG43oTh15tcau1i2g6VRw
	7bOfRmNLbDC3YtMw+0AwFKmRfX0CWLQY8a6RddGdmmLnVFrMFTdJHkHj0V5kSxXX0Bd5q/
	OxRggOFk53mSdQPcgCr1nu1LeZenGuM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXONOuOT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C07540128;
	Mon, 23 Nov 2026 19:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8301F000F4;
	Mon, 23 Nov 2026 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795461145;
	bh=H0jnP1mkAlUHs1a97wQnfbe+8kkRLHoLQ0+Z34Mwikw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oXONOuOTS1UfDF3A9Pntz/BqnedhydrfmA3NxgOMg/wq9D1srMpLfHQNjN29Jyp04
	 WDTlov1XjCoS0n72ihDLr8NHG6ru29TLEEH46FXV8To/gWp+6FIK1iVSFIJQp0Aofr
	 DL6wAr5pzPPHCobA60isWFMExToWtijysmfxu9oWlygZ8ReQRm0eA2mrijWds/CSxZ
	 CdfT/48CEc75waIWcbaPmi14VuAGUi+WDvIXWm7wKre4XAa1vYhdhkmfTZ1Ap5Uep2
	 Xot10DqddpcAwwy4+JHJ7/n8fU98noALBidcktFGCeHMRQDrFQYrbrzqVXaF94Qt38
	 4tneuCiRDUSMA==
Date: Mon, 23 Nov 2026 19:12:23 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mempool: account the element array to the caller
Message-ID: <awSPQdpyzyTeUl1v@thinkstation>
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
 <20261119-alloc_tag-v1-3-efcccfd3a9c9@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-alloc_tag-v1-3-efcccfd3a9c9@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAF25140005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: te34on497ur73etqjjjpne1sjeac8fq4
X-HE-Tag: 1795461146-539033
X-HE-Meta: U2FsdGVkX18MV0GpPEvBnmvS4YXePFUmhPAs3G+fsgqPtF/ZR40/dnzfqrX4iFtCTPTpAfMEvZsHIqEnc/CzEeP2/JSbrflufG7BUykXQZGrfWZV9wR7Zi1e00hEmvD8mXF+iZXSQVcq48sg9YRtPyDCi3Fx7MkDeJXeKRaarV//27gEU0UpSUcXMmbKMhS0+IwD1D08pj37hKWIMHJgS41q6bix/Dm15kae5dylIfkS3lR5OY2XlrrlByVsPG3t0/JO5q/h23U1LnIOyuXYmivyWFUPxUrBqTUVqQu9+RvQLXRsYxmpGxVgljcngzvXylQShKSAFVY9ClkKmcpwC751lLXJiNFtu3Pj/y/ZEzrsk4mZK7k495j459QkSpW7c34D1ufb9gP2CBbdYalwv7R1iLPQNIu9g5oJn4GF55XCtLHx4rMk2kimRtoRoKYx/4wyb6IoG6eVDyEigY+MutxKuMoxd+190LDp7NxvzUNZqlaqWJSOznzE1BCIPM30ntQeSRKXFbW8fVMDXKkF+1Qi0nDKI5yfyASnRMXokNWNNIvbzcwr0AFaPKbPpmp87Jr63xYwAxdAJskUyyMqeh0nrYbCaZkfDKXWIm2IKj+PRO98NQXuZAsImdR47RxHAi8eFAuza2qRCWDWkD00/kuMq3FTBhOppYKOas6DjDY62rhIkaTQ9XWYhKJh7nBnvxaKfvGiWw4gBM5dLkEAk3ObcNTCNZmApebht84GrWC8HOCeauY1D6VlTT+lDTuButo5d8gfZcylTlzoUJ/oJJprnav9YBDYllB3dv4vRzIdKykHZV9L1UdHQ2UVhB96VKnHeT/ahkmnqpVzl2k3OmJ0OnRprAp3WdvxRlOnM0ACgz0NVEd+4diJk0ILPNYJkFwo9VUZpRAUFFazjuVYgOlNZ5QeKKMI1YKJFIl9tBv8cd9fej4Iu323/nwFISedjcJS86Foe4ZRTom1cld
 AzBVOKub
 WHuHLDM1tOe3RCrGB29slML0Q8mVrlneYB4wIx/WoZYcIE+vk3mTUJ0tIye0UAl/E7pAZFLrvTYmlk5zBKPUTDP0rxmzLt4bLNetc2pUzXPzwJBN+nkuzma6Y11846Ajdc/eUepo7pn3jP5pJtNOyluIMe2SP+/b9xN0o+P8GXpsMZy4tLJ+lc6tY0qn4fXtBEW1+anihtDBibVr2FoAM9pkBPrqURo/pTZe4L+YNSPR4IB/In0mvJaEODBnf2oPmC2Naco84f8M7GbIw+nF0GfWpdQJ7wva/a0taQP97nProqMOAetlkhZ0bBWCJ7fPw7IqutNdXxENr9muk8VOhNg1fMEjOfY+W2eafUsQzXFXS9cKjUjpuqnAoYdXxPpraKD/FprtJucLy6xdXpi7Lma0+I/Iej2lkaRW6s843kNsrkBlg64zshr7dOPZ8xVXyYjuAz87WPWFEx6YYaLm2oBDEOGiTy7H4CmEXkIrZ4yPbA4f7X/XA8jOjOE50IqQTJtUdjkaHKhU8RCX7uJguG4fZxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 09:52:22AM +0100, David Hildenbrand (Arm) wrote:
> mempool_create_node() accounts the struct mempool and all elements to
> the caller, but the array of element pointers allocated by
> mempool_init_node() and mempool_resize() ends up being accounted to
> mm/mempool.c in /proc/allocinfo.
> 
> Let's consistently account all mempool allocations to the caller, like
> ptr_ring_init() and ptr_ring_resize() do, by using the _noprof variants.
> 
> mempool_init_node() is only called from mempool_init_noprof() and
> mempool_create_node_noprof(), which already set the allocation tag.
> 
> While at it, make mempool_init_node() static and rename it to
> mempool_init_node_noprof(): it is not used outside of mm/mempool.c, and
> calling it without an allocation tag would be wrong.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

