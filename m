Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A82606A328
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lR5Yhus4
Received: by kanga.kvack.org (Postfix)
	id 16FAF6B05BB; Tue,  3 Nov 2026 13:32:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148106B05BC; Tue,  3 Nov 2026 13:32:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E6A6B05BD; Tue,  3 Nov 2026 13:32:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D31616B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:32:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68C9B1C3D0D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:32:58 +0000 (UTC)
X-FDA: 85394654436.02.6A2F922
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6E10180012
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:32:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lR5Yhus4;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2mCcxNx71AdEX2AD/m5T8Vdk5yeOOOCszsNCu2WWj04=;
	b=QwAj6rx6lFFBfkK1KACeKzLR5L2WS0xfKKYMfJ7RKYzTMfGKg2KwLxgLrZ7GpoDNOFm6XE
	w29P/uyHCOPjanMfDyQKC+Dh+gwbCCZcjhM5z4L/ka+ivS5zKnvEQAZQ+oUGq01vdBo8vX
	hWXsd+1Au6D25C1YtL+vBQWRSo4uqP8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lR5Yhus4;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730776;
	b=td+NAoB/yYPiFGSgZTWyImU2R97q+aJbjjlbzBMyMPdzsdHFn24eq7KUbpE4EYs3h3B7gz
	7QTVELldZpuMcW86DNm0usJKYdENnnsAeeenCXtPyc7N0XnlMs0k3LD1vyIoaibEjEW/IL
	VkDphLtcUDvzqjg8CvTuc1BTUl2k1Wg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0219640BDC;
	Tue,  3 Nov 2026 18:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEA01F000C1;
	Tue,  3 Nov 2026 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730775;
	bh=2mCcxNx71AdEX2AD/m5T8Vdk5yeOOOCszsNCu2WWj04=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lR5Yhus4sMJk9zLIVPqiiFVjJH0xhDD3dHHY5F6LOu4/L2NFRSH9bvWn1V9C+Hsm3
	 /StrnHWSpxAF+CQHwGSQZGDT9ZAZFrA1Vz90GiQ0u+YRNV+gRWxChJQp/pCaakQ/0h
	 UAX0wVKX37jwighHVY3DyieBqFQBxjvqWP4PNi9ei09VtUHSnfruGPDoZT0+GaPruL
	 P40ny61Lv6Z6CRJaKupElfIYfFTPlAL9Z+ZuRWXfcwqtNRre9U8pCgtFhF/G5qsobm
	 YHuqjNVz0Oy5WNXyhwqMA2uNRyVv0lxqOcbl/vsZ+MU2HT9CUQxk08Ezl6Jk5ES76i
	 AUWJk3WI1Y6og==
Date: Tue, 3 Nov 2026 20:32:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>,
	Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] kho: skip zero-sized lowmem and global bootmem areas
Message-ID: <auoo0EOKJLn9GUIw@kernel.org>
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
 <20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org>
 <2vxza4nqm27n.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxza4nqm27n.fsf@kernel.org>
X-Stat-Signature: gg7hyj6acm6s6p1m1cy9s9dfm3e876ch
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A6E10180012
X-HE-Tag: 1793730776-726622
X-HE-Meta: U2FsdGVkX1/07ZK8O/S0MwdFHKYZSE6Rn//zkWtddmKBweb7xfZxw3vrltIzcFjUU0KVs9JlGICP7IyoUowtKGoAj7WotGDT1YZuLNnb7QZmG5Uu7M1xAtDW2oADZMeEQDg8jVtZrcSNI1CmQQtlZFKmJKMgrC6ufT6I+RedgVYmLE00mSq8P2mZEQKXLyXYm2dcCvS9ZHWp+G83pCJK4LncHKju4oAJMnpEe+GW/xDvli3n1ggbiizxjh0+OMqRf5UT/rg/GSkZr3FyT03fBArhPTGMjx0K0UrHawxEwlvs+kBU9kKT5+HN2ehEUZGdYWuKTYiSCoIMnQ3UCbSyv+1BtoXEFXchl+DO1Bpl3EqQ4gS+0jPzIkYTyICIwDJq3MdrN/dpzsPon0Py0RWHW8xzMG+GtTyV/+u+VDB7a9KkHUwGOoN0gx3Nbf+URHNC3a6+MNrYSKNVWlti9ZtnzclKBiZqWVoX4yPBekWduGblnjeVTCcjfKN5NIuSwGJIsq14BUbwPq52VAI0EvWB9wRTdFYWelNaO2PhI2qzBid4XubIiOsWc2hnrROEaNPTt8bIq5PUPXn4LwpWfTbLNwpc0/1GoVnc/HPx3XrDltF9mpbWuLrcXR3m30ky30tVtco9URxO8yeg98QWMGjK4E2G6J0Fv1Dl/D/ou8HGeeOcnFuYY3sBeHAo6ugPc1/V4z8kU0c8i2bwxKFEkZwipY03mUqQBOZUXj0EljCjWPXDkV6eceNe7Em4KR2HsifAURc+uEohP/sPX/tI9vzzIpQSfHwj2cv1ZVJzyqwz0+KyvlSEocgA3E++PPkhF9a4IPW+6sOapxF+5hdwNOm0WbqiSUlu/oKE2PBl4Gfxx1Eey4RPwTxXQ6J5d61bHfU51YZRxfBbSpTZeJNtoEj7/iOCE6uopAVnnakNHauRSiFKtALCC1ci+jiL6qshISiJt8geidFpxLB31PEKxD8
 g6nC1Z5y
 6hZTDKGCja4JvR9L1+plMfOnd2dV6ejUGhqOMg+x/rXJ5bSs4sjF9kIkWorgpFpXNMpVRoQGIdZzMkBqyevsZfcaN1TwaKQAGaguLhcyscR/4bEuP30Hs+JvMaZkRJan4V9QoqHWx4vW00o5rFnQ4tNiiCA+5dHPKQ2tAKf1suViC539Y5BGI3aFrSNevcLw3tSJ9wzDlxF+OipwAP9wH/STgl3o0uf+m4mZMhpCWyJBdfKXh2aYhj6TEyGcfAuLH2pMPAubHH+P4aJ9vP73EykNlnANqfCg4MnxksU/uRtUFJqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:14:36PM +0100, Pratyush Yadav wrote:
> Hi Mike,
> 
> On Tue, Nov 03 2026, Mike Rapoport (Microsoft) wrote:
> 
> > The lowmem and the global bootmem areas can have zero size, for example
> > when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
> > either of those areas is explicitly set to zero with kho_bootmem=.
> >
> > For a zero-sized allocation memblock returns an address without reserving
> > anything, and that empty area is recorded in kho_bootmem. If there is no
> > memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
> > fails and KHO gets disabled.
> >
> > Extract a helper that checks for zero size and allocates memory from
> > memblock, and use it to skip empty areas the same way as empty per-node
> > areas are skipped.
> >
> > Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> > Reported-by: Chen Pei <cp0613@linux.alibaba.com>
> > Closes: https://lore.kernel.org/all/20261026131851.9942-1-cp0613@linux.alibaba.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thanks for the patch! LGTM for the most part, one minor nitpick below.
> 
> > ---
> >  kernel/liveupdate/kexec_handover.c | 61 ++++++++++++++++++--------------------
> >  1 file changed, 29 insertions(+), 32 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 6f1f55fe31819..f268c57413a7e 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -820,6 +820,27 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
> >  	return false;
> >  }
> >  
> > +static int __init kho_reserve_bootmem_area(int *idx, phys_addr_t size,
> > +					   phys_addr_t end, int nid)
> > +{
> > +	phys_addr_t addr;
> > +	int i = *idx;
> > +
> > +	if (!size)
> > +		return 0;
> > +
> > +	addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES, 0, end,
> > +					nid, true);
> > +	if (!addr)
> > +		return -ENOMEM;
> > +
> > +	kho_bootmem[i].addr = addr;
> > +	kho_bootmem[i].size = size;
> > +	*idx = i + 1;
> > +
> > +	return 0;
> 
> I reckon it will be cleaner if you update kho_bootmem_cnt here directly.
> So you directly do:
> 
> 	kho_bootmem[kho_bootmem_cnt].addr = addr;
> 	kho_bootmem[kho_bootmem_cnt].size = size;
> 	kho_bootmem_cnt++;
> 
> You won't have to pass around *idx and you won't need the final
> kho_bootmem_cnt assignment.

Ack.
 
> You might also want to have a kho_bootmem_max_cnt and do some bounds
> checking here.

Hmm, feels like over protecting. And if future patches will miss it AI will
yell anyway :)
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

