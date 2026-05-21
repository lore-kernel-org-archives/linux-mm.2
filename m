Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6C5CD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560A36B0096; Thu, 21 May 2026 19:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512436B0098; Thu, 21 May 2026 19:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFCC6B0099; Thu, 21 May 2026 19:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6466B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:27:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62B28120702
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:27:05 +0000 (UTC)
X-FDA: 84793014810.17.3B0720A
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 83542180007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:27:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="a93/QC7J";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779406023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2d2XGchJMUeRdfEHZWQj8Yrh95g8jOeOZi4Dn5MU5Q=;
	b=HK0AhSm9efwQJ/6UMAJKLfeWNONLKZxwARtXFPRKYwrzRp+gyR5HwmGi/VoUJp3F2Qb3Ic
	n3KX01ka1CFIcSW6ZygMdsbf1LAaJRyBm98rs/V6vpCQa1sTgZKSJumv42xgoip1JRKNdw
	xnNGF83WGEw8UwnlwfuiLbw97EvH+jo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="a93/QC7J";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779406023; a=rsa-sha256;
	cv=none;
	b=A4TbDw1P++OwRm0Uy3ZuUt1WW3TDg3lNl/29PoePvv1UHbMJBtGOSO6+eFenF+S6vsSZpB
	sPdS8L/9FCcY3k555oSjZ8g115lQ7sxWhG9E/4+vn9fJCwWTMFlmRegxJOpbAfJwzbta1h
	ud90QXLvN3CCkUmVm2gIqZeQNj7jUFI=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-516cbe16bcfso6709251cf.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 16:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779406022; x=1780010822; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N2d2XGchJMUeRdfEHZWQj8Yrh95g8jOeOZi4Dn5MU5Q=;
        b=a93/QC7JEnlbfgdFsCMi2MXRftbzHLkmk6J42s1pqR1paipJzsTNqJsoIz0wxoT+zD
         UFY+ob/WDRnf2QUsPqkVdiLiOYB+KRQD5N2AX+x+nZWRb+6K4JnpH2bPSmtRxn+8Ba57
         LhQhucNrQJKlIM7sQPDZpFwD3WINwXQEAK81rhPZ3YJpDXB2YhR0nFp8hU9O4iSwuT9j
         L6Iq7Gvxf2xIg/2etJhci30z706KIqZA2jxxu6WX87Gnk5xMxzMd3HaCXNf1WHoMJasp
         KeONIWNbq4I9CIwpHkWc15/UeQC6GgnI5U+GisG/+GNbSzqrL79MOAUba1XeZe9BXe94
         dFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779406022; x=1780010822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N2d2XGchJMUeRdfEHZWQj8Yrh95g8jOeOZi4Dn5MU5Q=;
        b=QDFHHPyn6OrytfkkPgCjf/G5cn+dGKYrE0DZ693hcjFo48a9CQJN4jLmsvdOkje0GI
         6YwSDSYeI3Ksrr0NJxQaYa3AV6guc31F8VOdjE2ecIyVilc2gVUoWkpfCIvdgN3+0Llk
         vgkhoTSyWgE03XBf9jgqffTr7pSiscErbA77iFVbrjzipk7dJ5036mFttXX2OgOW2u/i
         AZpkBO9VC6kd+eaU3ULyVvoYh1R3cNsQM2zAsADqJok0unKiR1UAUv+uaQzKgpwSJ1zy
         gHqOEhtgpmtdBjBTMmY+zaxLCuCk1+MiEfNOt3U78eEPuhVR1/hFm6BlNYvwWlHC/kTY
         FWqw==
X-Forwarded-Encrypted: i=1; AFNElJ/+95L9+gQM3bc+tnHTm+5HqAuubkkSDmXcvGQKM76y2MHMRtmc8zDheqh7R4uwTCfoW3aG4dAwsw==@kvack.org
X-Gm-Message-State: AOJu0YwGGtXc0kRXqvqOduR0i8Mcy9ekxIYYc64nVF/OpRvWSdrs3jQd
	WuNO3wN3SlU3rDN3/ouD50/QTreEnMcUJvC1fQdovG5ZQZWsqIQwT+RyEzCG/6qSL0M=
X-Gm-Gg: Acq92OHZLKo8iQZziI0MllJnHef1MQWXWvHcQtI/cUQ++jYd5P03cnPueUvsASYrUfC
	eDXuiS9qLy6L/nBP+hH4t/NhHTbKjqN4ilUe5dosxsOwFskeN2j1orTvN7HbkmYvnWg7HlokoSH
	j0gveF6TkJeYoXCo4FflQZH/1Puks47Ml8A4S3vKVSpFwfV2UhllT8+QXIUYeR12yrbKpGITbHl
	a8iZ51pFrEy+o68SMc7Kk1/Sk+1YW7wbZjmodTV/MrgScoaXDFOYb4lHMqr3Ti0kILQG8eM3RRL
	o6wwjq6qnhJrellnIjufhZUqysymXZ2nJLJi5UnoJgPNgfoKI0exDjVCP09U6QSAO4hUuoqNck/
	3OfRoIVLNjwO1TavZTKPEc53gxU6sXrA8pVacCl1NRdhjRnuTwwTur7o3a3Nqg+xAJx3tDbUVNi
	2qBrmMs8jwq7Q9kJL4e1Z76yiIy+LPIbNHqtSqdFSnETBC+iD23trAxfa3bzDJEQ==
X-Received: by 2002:a05:622a:a0b:b0:50d:83a4:2995 with SMTP id d75a77b69052e-516d42e2faamr22496001cf.21.1779406022521;
        Thu, 21 May 2026 16:27:02 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516d63015b0sm4856051cf.5.2026.05.21.16.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 16:27:02 -0700 (PDT)
Date: Thu, 21 May 2026 23:27:01 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] kho: store incoming radix tree in kho_in
Message-ID: <ag-UnPWdmYzqn_BV@plex>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-3-pratyush@kernel.org>
 <agHA2imH5hdMSlId@kernel.org>
 <2vxz4ikddi6y.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz4ikddi6y.fsf@kernel.org>
X-Stat-Signature: kp8x7pmujz4n15pupxctz6988pu39he1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83542180007
X-Rspam-User: 
X-HE-Tag: 1779406023-188994
X-HE-Meta: U2FsdGVkX187pSl3w2jckT5a2qBRXVLjjkNA5tu/0U3vFpu5+nFXx9+1gkJDo6WU3jmi+gxR5aroUNxM009lY73WjJIGMH8rDDOq6WFZJYSg5QG4+IrgllUX5NXqM3I+6eg1g/B9mEGOjAeIOco4dWPQgibUPtyrfF8vSwqskapXtO3aVSLZWLH1zPfWmsv5HnG3vLrveBOrTiER3FI5uev3LPT+Me0yPsmXC9DvRQsPaJPSuqbTdBj7Fws6jIB8SFzNpqFLxkBht0GmzYtleq648LkrIMPtwoj7CEGEAU/KlzZ9YftC48X5OK4ZW72dW2GsaHG1I6oOCZhaLAq7jSqdpIOa6haZLA4G5UY3JNhfteo5m3oaG4+UCTyJ5Fh9Pe1MviJS4MnT6mpYUW4xAMlxMgcWA6ddiPW1TMn1pDigX5hZAb0BVsnLnn43L10mjS30dJyiKuF8qwSOEXZDn5/qgpy76DlaUsmPFq8KZ8nosGDEi3YVNEpfUMz79pIo9byRtirV/9NVWik0GZJvHCAwxrpblJKp4YlRlBP2WIOvpu1T3gg5yqzIDKP7RVbrpmCDABODKRP8y0QCmwV86Nu+lGapMYkV6f46/doEIdamKRCkpt28zTLJWs5PYjXwQRBz+pYuf8u7HG18YPEAMQBR25fLsVhQoVH07Ts7v2iCMAjWfyxtm0RlR2JW1qJoT1pQWp2fWpl0SbooHHYLxQncbR9WMQtVpm3n2uBuCH8ka/GMCPCrlf9uRY0Gx3DhWaYciQoUSSjvxTv8mYhsxs5yfX7bydnhsHr5ax9//3v7htgVuOP7pvSKpbvkwP439m+L78/RpW7gjQ7/MLax/BAAw8gt2Gwi8sXntVhVpv2HKdgwNOWQ0QfTG+cCmpTJFINt2w5KXO64ZA7k6v8A6Kfo3Y/4uGgwnhbHq2eHOtwbmGbcVgdlpYYXEP77BpFHsyJ6cyVLjHZT+3ylUc+
 yvZS943J
 kW77KP5xH5HogZVpvfQRTYe3gyoJmOfUj1BVKxigSttsKKJqnGD7ddTZO4MbQKxR49FexoILVDGNVVIEmNZEOxc+Me/IRFynCwiL7exHf7M7AWUlMiXImGVZPvRY/zGasWERLQU7vTQZ3/m95J/WjFj2/5aMS3XqP9REatjX8gUGtRKQJ7667BTpqoks/IbU+YTIM9lw7dVmUv1ZXwAYCEx+mUF/+l/tZ+HYVOzIZWI+9oqoP69+S+NaEvdEBB1raU993rk2xtJ2TDLScUTus3PfO9PvvuWnJ1KQS+u4RYxzLalV+HJsk6m5RTDA9hIl8Gm5AajLwdwAGHRJRDTjvhyIB1uB+eOnR0uoYv+rK0n5Zbka9yE7BTv/C4p+F8s+vsJUW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-11 18:28, Pratyush Yadav wrote:
> On Mon, May 11 2026, Mike Rapoport wrote:
> 
> > On Wed, Apr 29, 2026 at 03:39:04PM +0200, Pratyush Yadav wrote:
> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> 
> >> This allows other functions to also use the radix tree. While at it,
> >> also use kho_get_mem_map_phys() instead of duplicating the code to get
> >> the radix tree root from the FDT.
> >> 
> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >> ---
> >>  kernel/liveupdate/kexec_handover.c | 27 ++++++++-------------------
> >>  1 file changed, 8 insertions(+), 19 deletions(-)
> >> 
> >> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> >> index ba568d34c5b4..5758dc6fab5d 100644
> >> --- a/kernel/liveupdate/kexec_handover.c
> >> +++ b/kernel/liveupdate/kexec_handover.c
> >> @@ -1294,6 +1294,7 @@ struct kho_in {
> >>  	char previous_release[__NEW_UTS_LEN + 1];
> >>  	u32 kexec_count;
> >>  	struct kho_debugfs dbg;
> >> +	struct kho_radix_tree radix_tree;
> >>  };
> >>  
> >>  static struct kho_in kho_in = {
> >> @@ -1373,24 +1374,10 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
> >>  
> >>  static int __init kho_mem_retrieve(const void *fdt)
> >>  {
> >> -	struct kho_radix_tree tree;
> >> -	const phys_addr_t *mem;
> >> -	int len;
> >> -
> >> -	/* Retrieve the KHO radix tree from passed-in FDT. */
> >> -	mem = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
> >> -
> >> -	if (!mem || len != sizeof(*mem)) {
> >> -		pr_err("failed to get preserved KHO memory tree\n");
> >> -		return -ENOENT;
> >> -	}
> >> -
> >> -	if (!*mem)
> >> -		return -EINVAL;
> >> -
> >> -	tree.root = phys_to_virt(*mem);
> >> -	mutex_init(&tree.lock);
> >> -	return kho_radix_walk_tree(&tree, kho_preserved_memory_reserve);
> >> +	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
> >
> > Do we really want to remove an explicit check for 0 and get a WARN() in
> > kho_radix_walk_tree()?
> 
> If mem_map_phys is 0 then kho_populate() never sets kho_in.scratch_phys
> and thus kho_mem_retrieve() never gets called. So here it will never be
> 0, and if it is, a WARN() is certainly warranted.
> 
> Perhaps I should add a comment since this isn't so obvious?
> 
> >
> >> +	mutex_init(&kho_in.radix_tree.lock);
> >> +	return kho_radix_walk_tree(&kho_in.radix_tree,
> >> +				   kho_preserved_memory_reserve);
> >>  }
> >>  
> >>  static __init int kho_out_fdt_setup(void)
> >> @@ -1597,8 +1584,10 @@ void __init kho_memory_init(void)
> >>  	if (kho_in.scratch_phys) {
> >>  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
> >>  
> >> -		if (kho_mem_retrieve(kho_get_fdt()))
> >> +		if (kho_mem_retrieve(kho_get_fdt())) {
> >>  			kho_in.fdt_phys = 0;
> >> +			kho_in.radix_tree.root = NULL;
> >
> > I'd make kho_mem_retrieve() void and put these there.
> 
> Sure, will do.

+1 on this one, otherwise LGTM.

Pasha

> 
> >
> >> +		}
> >>  	} else {
> >>  		kho_reserve_scratch();
> >>  	}
> >> -- 
> >> 2.54.0.545.g6539524ca2-goog
> >> 
> 
> -- 
> Regards,
> Pratyush Yadav

