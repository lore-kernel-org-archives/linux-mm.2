Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007DF606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DPw6DNCe
Received: by kanga.kvack.org (Postfix)
	id 1D7B16B066E; Thu, 19 Nov 2026 08:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189046B066F; Thu, 19 Nov 2026 08:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C64D6B0670; Thu, 19 Nov 2026 08:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E06E86B066E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:58:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33A4D160ACF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:58:47 +0000 (UTC)
X-FDA: 85452024294.30.A559026
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8896B20008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:58:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPw6DNCe;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795096725;
	b=S9DtaMCaGBsYyNqH7nGUMe2URYdOwKZvc/0JWrRJMfoLop7s2W2Rn5ScU9Q5XDaVG4wS5J
	Te7U2hs2RZqcOK/lX6UiIJ/fCuLg0LUSue1tCJLKBsbNmw+qKNlG2usvYNB9XDcEOIVfST
	sL6u1g2bvfAA4lBmIr//vgWN1m8fddg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795096725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+/Z+GSBe9p3l8KRKC/J0V0j2Fl7Ju04Nx7gfj60XfY=;
	b=Nd4SJv3IE36ieGpDMBXW7Byr/DK7xzt8xscqz32CADap316U/CVF4kj6U2Tzgj3oSnBwPr
	nqY/MIr8jHjobPXt2ESHtKJlvS3+BSIXgucT5PnWAaWBP21qM4Rh8dJC8BcOUXunLpoyGi
	iHoPnIdjgM/B3hXx9xTtt80waUM3a+M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPw6DNCe;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C95D040BC4;
	Thu, 19 Nov 2026 13:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C75A1F000C5;
	Thu, 19 Nov 2026 13:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795096724;
	bh=a+/Z+GSBe9p3l8KRKC/J0V0j2Fl7Ju04Nx7gfj60XfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DPw6DNCeOAM67Y1tF7h73C3YY7Wt08ykNTXv4QXKypZDGuQOdy1Gmv8W5G259LJqy
	 EDpJ84PfzvGLpJ413E6rL/+nbMciOWyHLVlNel5NTjDIluakeXaUBDpgW/dxtbcxhY
	 JbsLwoRqiewj9xvkUhUD6RdBdWkM4ANGQ3MKwRfGEFps+932xv3Wpw3s5nyaIh1DLb
	 QxmmroiSyMERAQlLbvvv0jWR68ZMXsAmUs4Xn9T0dYxc6srTA9QTylAHcr8WUnRVeN
	 BEjwFE7gqHqoOsU2adoVAF7ddrquz3vDMJK4YIkvff3BrGnfHTwx7lLdyIMJQ60zDf
	 vNmt+JbdgTS7g==
Date: Thu, 19 Nov 2026 13:58:38 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 3/3] mm/memory: merge __vm_insert_mixed() into
 vmf_insert_mixed()
Message-ID: <av8AOI_d5vSB6YeG@gremlin>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-4-ekffu200098@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002160535.661399-4-ekffu200098@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8896B20008
X-Rspam-User:
X-Stat-Signature: g7jkc1ytmu7ec775utwe8yboy4j6nrfw
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795096725-982351
X-HE-Meta: U2FsdGVkX1+uk0rEvbqeF6GIqp2o0wfuHqB46KfecpwSfqaJ2GswbaTibSkfLaRWxv7nmWQHPeSUqTJfA/0Zubbt4s2jAuHLdGUlagMLzfh629KoFWmgcpeh+3n8PkbG4Da7Lwz/4Ihr/4X+zDb+2gheiwzE9W7QtA+/7c59pw8F7ojdnSAqCl5xeoyQVaJsoijvP9ot1G08vHBG/UA75qsi9ahmh/htEOynIKlszuk0H/oZXcceaRK4ajA+xO+Fhjsp9+BGdwQXL7Gd6MF1Gax5OrUWrS0pEcVvTqErh+lXoObGo54IBoO2L8puFVfh5KZ+g0s8qN/5Xuj7MSHc/LBOgRec5JwAvarZBulDro5tQLMfmygWEECuUNfvEv0j8E7gy7UtbObhmcu44XvXqx+KSiMM2SRUnnfqKJkaPZpIVX8OBcpyzXn714eAM0My90yIx3/cZDiOLeAmcmuPXwIKpY5En/EpS+17CM1P4E22vc8xxZeyUl9Qc9V0qi+/BQZ0RChinbvTTNAHohgKY5rij9fPtYesc5U1GeoPV/gnobJeuXqdohZulwsfi9VuMUnxTYOwCBkgQU5KVtPpcf2W2n6v+GGUNfb51bAtQhwUCKZ760b2BDOVdosJN28ugZDdGyq+/cfOqe/IKCPcIbuQfyinzXPQtkAwWcsK9teXwyqh/4dYuGCvCqde1vLZvnaaS+fkB4XZbc0C8YZUNalORZ9NtmTmmrDkg9UopBqBuOihmuDhApJbQOwK3tfWn4wE4l3AIG9u7yqpX/IySU+NZqJZkcoil+CRvK4ELXhbIPMXP8kyk3rco8X6tCi0Ua5cdndtXvWd4Ep5B40pYOQHRRgwvyZO6vWmXZzITpMH6N+MlFbrANbUDsE5aCpUx1s1XOimLJwIWrtjoe1/TRNZeO0Q7Nuff6WiaFuc7Bl1/sqJPItxCHT+fZnDJvqMjBV2TeSvOQY6XmU2Mnl
 WzZIIbnY
 UPTm85zLmlTMc//habP65IjxDGNzLdb9r5Ow/bSRvyyroxYYNrV523kWLHejn/XnyYkAt93wqtoZenaet2fo/hx/gP+n+RINY0XDSakBtFxGvWrjOeLN/HUbAs0zl2Gbs1GrJXDIDTUqJ3Uv5/IPkBmO7zzAMXllshmNS5/eK1ZVwp1XadIIGJ3+PHUuEiBTx4Q7yR36n152Fb3F2T3yGDk5a+W7ullW5X2Z25shTO6stBOws7rf2uh4NxA6Rhc5T7xvS8e3BNbzbHw1dZTZeQuYTL3om2mvctaqzwzACcUMHLIl55EL9L8pGcH1+V2VoE8MCnGjRYVdbCuNGlSXn3oIJ8isM6iaiNMYaVjMZMFxn4aJor9+LHSIaw2Uf6xIygluVx+628B1NTuV8DVDNVKhuglaCAu95NT5qC8qPBerlFWz8kpTeCLud5mISMCn37sAFXUuZJThAbB34Uj7QGwRZfEBFaaavEK4sOWAVxtx3BwZKjm0v9ApeUoyLgQSAsqhXxMlKlIY86SlR6pYXrxqqhRW6y6vegTdFPeCHFeYdk9O0D37nZoVt2/CqSHMQwN0f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 03, 2026 at 01:05:34AM +0900, Sang-Heon Jeon wrote:
> vmf_insert_mixed() just calls __vm_insert_mixed() with the same
> arguments.
>
> So merge __vm_insert_mixed() into vmf_insert_mixed().
>
> No functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 6c1d38eba7b2..bde650e207c9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2991,8 +2991,8 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
>  	return false;
>  }
>
> -static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn)
> +vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long pfn)
>  {
>  	pgprot_t pgprot = vma->vm_page_prot;
>  	int err;
> @@ -3041,6 +3041,7 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>
>  	return VM_FAULT_NOPAGE;
>  }
> +EXPORT_SYMBOL(vmf_insert_mixed);
>
>  vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
>  			bool write)
> @@ -3062,13 +3063,6 @@ vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
>  }
>  EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
>
> -vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> -		unsigned long pfn)
> -{
> -	return __vm_insert_mixed(vma, addr, pfn);
> -}
> -EXPORT_SYMBOL(vmf_insert_mixed);
> -
>  /*
>   * maps a range of physical memory into the requested pages. the old
>   * mappings are removed. any references to nonexistent pages results
> --
> 2.43.0
>

--
Cheers, Lorenzo

