Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B968CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A435F6B0095; Tue, 12 May 2026 02:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B596B0096; Tue, 12 May 2026 02:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9583B6B0098; Tue, 12 May 2026 02:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 868E06B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:48:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CA35402BC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:48:58 +0000 (UTC)
X-FDA: 84757840356.25.2F82056
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B221A18000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:48:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fS1MMDK/";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778568536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqJXMG4AbbLvtxyV8k0pDme0ixuoamEMGaG4tQgEDmE=;
	b=W80Ng7s+7Gcx16Zai89XRmaHQcf886Ah/Hzee0qfj935XArjyRAGwUwiw16Byjydt60jpZ
	wgDuUJQjscddh7lexaKkzcUYKngSQdg10+Vgfw8btK7GWgmDAvn2T62SMzOBHa2l65dxXd
	gkS3Nn+pfCEZMFs5b+8pZVjw6dLpS3k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fS1MMDK/";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778568536; a=rsa-sha256;
	cv=none;
	b=KoFjQPY6vrMlpZrC8Z9c0ZxkMrConiroLcHgz7LTQfwgwVHUr+Flp1hQgRAGlLQavNcLJn
	TDfyg9QBk4QIZqfH05RJBWw+5SLeoBY6zd6nOMrbHsFAsxxCOQamdSMaPhuHWuf24IeLot
	AN7GpkOVJ4UMTKz76RK3xW+5iDhHfa4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E1276012A;
	Tue, 12 May 2026 06:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33335C2BCB0;
	Tue, 12 May 2026 06:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778568535;
	bh=7xqrAItGMPFyfU6pVB+y7187hkbW+5r5jDMYDqJoTiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fS1MMDK/QN+dzfCxgYeQoTcjMJ6ttyRYGb+GSjpCa2iG+uGxKaqxoEaqAY7XgpLqj
	 h7gUD3lvWerOn0JiTixBa6c19jpcru3ryNOL92poGX3XMSk1iRVr+IZnyFSMn7o7EV
	 EHiWqSP27esFnTSHl9Vxf/76IRsntTbyDzIF/9pucqUWazVu/9m2QRMtcjEwNsJBu+
	 ML7cfHnDWBi/7OR5wTxB6MpCzVeZH47EHccjWxf4mrJcm6pyMhLYCveiPX3vPceR4Z
	 vq8d/Z6DZ+GeD2vrRL20SRAT3tW5YhAY2yZCz7B/NDHxTUN+Z8LVjZLJUE+dNqebCY
	 62nm+RXEgU0sg==
Date: Tue, 12 May 2026 09:48:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] kho: add a struct for radix callbacks
Message-ID: <agLNUKE5LZqcoUex@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-4-pratyush@kernel.org>
 <agHB7HB-p_vkLS7R@kernel.org>
 <2vxzzf25c39x.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzzf25c39x.fsf@kernel.org>
X-Stat-Signature: noayi67bf6euh5dijbs6coqtszcmfewm
X-Rspamd-Queue-Id: B221A18000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778568536-126249
X-HE-Meta: U2FsdGVkX1+hyozopRrTvaj8FyIk1BOc3jO6lmNx+MVd5WwCHqwXFQdTBXvG5AyWoMuuNm/nv2cVXZJE9aX4yHsagKosYrBOB6IdbcotECMxSmWSYFawxXBmZBUUNlMoC2sAYoXns+QN6FMQmpatxh/Ni9WH5uxswZ4UfIdHKyDRzoqf9H2Zd1/CETJFtxemYgbcu7n0ucc9x4b9uRtwUWRyYU9ak3avsrGZmpjVexxnZ7jOQspHqMVTFY9uDeNYbKoBuHpPHWTmodVMqSXEfhpn+4zpauIFlxvmMusfY4CMP2f1wQS6jtS9mfBm8F1tNUBL98P7Z0AH89llk9NyHve2sBIFh+HsrlnKAkH0VYfSUMCV5t0ikHRL5E+95HqCef5h2cwOKVmOYRWp89jVEOKxzBfGxsvR2gfp4SR1eNyXQLvmi0/bmvamBxwZLnz7JqnzoNPZCFvEI46246/3XcOwSLHHWfjVo7rkv2VwXAmKyHfXFuhYCLK2AjAaGeefomCsytE/eX8kTKIx+YubTDl9Nz53WvBc2pZJPNtbsmZoh2l9UV03gQa9NZxE/JnuxwicOVgUYPoEtFoER7LIB0DRRAqaXPvDGWMZ/UPwPy4M91Ph6+Lvu+00rbdfn0ubF+KdVEWA4DT6Or8FAj1NWaf+g4G3yULrgl9q3lLWnSRAmCQXSVbG2/2dTJBO5EpOR3EKV6bFYFrRF+ibVtnMkN0x1yaPVbf+h5Mca6Ttb9Xo8FCKRW3OkqF3IsgJLX2gADiqgIJ2Yxs2yBwdghtVbf7KiThYwQmKwhu/wcVnWVW1kSaGDYJY28v1y7bhOtPELL28yoJ5sbji1lXQUtdDR41KUYi17OOpijL2OpWP+tFDjAhz2icRAuB4QIU91JIcXfbHx0qoU+3r1wgLSYpAxu/MsnyjeZGTdXtmzyWNltzG2s5YU2+RZ5xG+7ZVIEWXtsW8OPLCK993b0BPWcZ
 sH+DxFrP
 Z7hcuMpyn0wotYYc4edFgMR5pg2HiKmZVmkT4cfQj7e3kwHk5AmlpWv6riDhmd+flk2I0Lyd4gAHZrFUrVbiS4UyZu4FQTL9Ieu6irZU9FlX+AaeHOiEmFodlSTqdg0TtoMDfkclWifsEKuNeBes+kUEFhjjzd9YC2ofEP9N9foEJxZeXJhFpLBdvuq7zVBc1dt7YpYFTgiQwN8FmIj0ds4JUKTCFZbtn6e0SrnKRKDV6IQdTIGI6AtuCHBF48kJp6YA3uYRXvqgNlraGdOAuBqbL8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 06:35:54PM +0200, Pratyush Yadav wrote:
> On Mon, May 11 2026, Mike Rapoport wrote:
> 
> > On Wed, Apr 29, 2026 at 03:39:05PM +0200, Pratyush Yadav wrote:
> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> 
> >> A future commit will add more callbacks for the KHO radix tree. Add a
> >> struct for collecting the callbacks.
> >> 
> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >> ---
> [...]
> >> --- a/kernel/liveupdate/kexec_handover.c
> >> +++ b/kernel/liveupdate/kexec_handover.c
> >> @@ -266,16 +266,18 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
> >>  }
> >>  EXPORT_SYMBOL_GPL(kho_radix_del_key);
> >>  
> >> -static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
> >> -			       unsigned long key,
> >> -			       kho_radix_tree_walk_callback_t cb)
> >> +static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
> >> +			       const struct kho_radix_walk_cb *cb)
> >>  {
> >>  	unsigned long *bitmap = (unsigned long *)leaf;
> >>  	unsigned int i;
> >>  	int err;
> >>  
> >> +	if (!cb->key)
> >> +		return 0;
> >> +
> >>  	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
> >> -		err = cb(key | i);
> >> +		err = cb->key(key | i);
> >
> > key(key) reads weird :)
> > Can't say I have a good name, maybe key_action()?
> 
> I thought the context of it being under a callback struct would make it
> more obvious. I don't like key_action() much better TBH, but I don't
> have a strong opinion. Perhaps Pasha can suggest a 3rd option and we
> pick on randomly ;-)

Another option I thought is to call them ->leaf() and ->node().
 
> >
> >>  		if (err)
> >>  			return err;
> >>  	}
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

