Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B53606A334
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=bOvgs7bp
Received: by kanga.kvack.org (Postfix)
	id A37E16B00EF; Wed,  4 Nov 2026 10:32:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8CF6B05B1; Wed,  4 Nov 2026 10:32:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7326B05B2; Wed,  4 Nov 2026 10:32:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60D656B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:32:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B72C2120751
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:32:19 +0000 (UTC)
X-FDA: 85397827998.24.047F913
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id BF3421C0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:32:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bOvgs7bp;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793806337;
	b=VuGVI80VDTZCowvvtAwCedoQp5iFbMrsAoZqW3Ixj50omqnKb3F58WcsQpVy1EOkyQG4J3
	6NIDEpPxA7Y9OLkRk6BVobytlpp8HrPNqJWRfwoD0lU9X0JJN3KRMMeyJz4w+3p/nDDSFb
	HXAG68VSMp7GDat4J3t8PFBR3CIDPHM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bOvgs7bp;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793806337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RsAyHrXNfqX02yWykA3lATIbdnc5zjm5tP62HlWexE4=;
	b=J+OXQb70nX6I0v1PC7D0tQHZuXbWSwmV2mEJISJrpiOousKXoZMuCK3FHGnvFGgRK+Ob57
	PGgLRSGo6EHUahlfw9AClm8rp0m6e4tbSeccSZtEWnfnupXz56eN2q1Ebu6IaglCf6JmAE
	iLcPpTdeui3PtzbAmNYf7jUhK8flngg=
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-7cc81984fceso234959137.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 07:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793806337; x=1794411137; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RsAyHrXNfqX02yWykA3lATIbdnc5zjm5tP62HlWexE4=;
        b=bOvgs7bppKeR4/f3UQCi6Gpu8re59g8YT5qOQ3eMO3qe2yGHcqOHyJXfpYqIP1Sv/T
         Wp2FOZuoZAVPTgI+guaKuBs8Aw3eCUXnoLHvHbVYcccsU3WU3jSlrx7EITiCQ5Y4q8Q1
         8UWMUgRxkmbFb3YTIZULodaZfkgPvIYkFvebEspkvoB7UJKr3dlEdolpuft/rAdFLORy
         MSJ8+ISNxri49pcX0FNs1nDBLRMqbDyb1JR1eNXvjaGvpM+AYk2kAbcAhhuODA1/K5nN
         aAYpAegLEtCgmANUiKudhQ6YSKPcEX0p3UNkOpOn6WQEzuLHSg5AePTMHyxwBfRrLHks
         UdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793806337; x=1794411137;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RsAyHrXNfqX02yWykA3lATIbdnc5zjm5tP62HlWexE4=;
        b=igYgKr+WjvKTmYmPn5BfmJn9eeCtPwCK6T8YDA553kqKcQhD3J82EcrAaq0j0r5xsn
         AfV4ugZUfKvorPZ/0Cb1osXFcMGnlXsnJdEDOreyJUNXQMs5tgxkaWmo1BNHukAm10jp
         r2UxZXQOWXxQGK33X0rW87NnKwXVn5BCK+KaxHBi5PPj8hZiE8NrYmMx0xSoZpHNxZqB
         IeBi6sYeztq6E1qM+DIeQd+MvInnEDyhPVKRZbKXKyVP4naDvZ0ALNba6/6GyBCvVuci
         OcUbpniNHZly0EUQbhySdU9SW05Rljj5GQUCCvrChdqyFbQ87XW0JGwZjNV3JXV9S/BL
         MLtQ==
X-Forwarded-Encrypted: i=1; AKwUvBzQVQjhCVDyTQspP6ptKIiBX82JGENncv2p3/3qZ9qvPnAcYaPIEYahTBltn8TRzXcXXR/SSoCxSQ==@kvack.org
X-Gm-Message-State: APuU4Z+nJJyJPdpd0HJ69b9F9emTCfEDT6Ohglo3KpxHus1Qpne6z5l0
	SlkMNlbV+53gUYUKNirJsuUTXPXKLcg3oBVDt9QTaMWXVWp3aE0sYdImBh7MbDJWZ24=
X-Gm-Gg: AYBFou1OffE17vzlX7FCapKh11wSkB8i9+Djz78TGjZ333fl1Pt/D0VtWi248mlgE+A
	i5OEYCA3aKB9zwLqKUxirQQ8eskVWloxdyYEoidObgqmOsKAth3Jx3mSfXEyFL2Mtxer+U/v3jU
	Yn5LBxnvqwmTGcUW/qTO7fg8Ez/lEpOkDgwoTgEz1T0HaiZX3hH9DVm9AveYHcgpvCKyOVehN7Q
	xQkkzDVNm84hbKKF6eNmM0IQw/BmpSUNmjji0qYmD5EsGRq/qPDm4sbXb625VQATIJcXjNIyhiz
	6nIMUKgIofcOii99C6Ox3R16in+c52o3dTyzn9siX5r0M/MaYzgA04NpV/tnLvZKWMyxflpAxQC
	gCa1OUkceMahuBKNWp4jC5h6v76LIHZ2jlx+ixbRPrUrblORiDRJnGtZoJjWFzIksIH/JV8gJ3b
	YJr1geyaQo4J5XZYTheg4HzsXPCOvjBCddyfZnNOvYlRp2+AS/IKpn9huo2T8iA7QIo9nC3VSYN
	SEvoz3lzOz0GTR45gnPsQWa0jDPNZDYCPHMG4Hz+w74CyBgTiCrHB5FNPVdP5p9PkVICRPdczwC
	lF7/RgFWjJt/atxCPdP4zEWFa64CwFMpHSoTGIDEFDgU9TyDwSi/wuur0DUphUQ7wWee4ilNgSX
	2XBVLE2nkP/nBU3OdeWcKeSilcQAQb5M=
X-Received: by 2002:a05:6102:e0d:b0:7bd:b263:14c8 with SMTP id ada2fe7eead31-7d072784174mr5342781137.30.1793806336602;
        Wed, 04 Nov 2026 07:32:16 -0800 (PST)
Received: from google.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d2770ffbb4sm1208724137.0.2026.11.04.07.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 07:32:15 -0800 (PST)
Date: Wed, 4 Nov 2026 10:32:14 -0500
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Pei <cp0613@linux.alibaba.com>, 
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>, 
	Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] kho: skip zero-sized lowmem and global bootmem areas
Message-ID: <autM3_pSLuOGZQCh@google.com>
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
 <20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org>
 <auo3PzmisfK3br1l@google.com>
 <ausVbqZd9qgZf4zc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ausVbqZd9qgZf4zc@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF3421C0008
X-Stat-Signature: ma5sxfy5q9r7mmeae39hha938ijm4nus
X-Rspam-User: 
X-HE-Tag: 1793806337-645631
X-HE-Meta: U2FsdGVkX19tRtDHWH7qGL0sYUTQR6s7lKlO+5G2qA64JB+b1ZV3Q4EtdDcBPJpPJTva3GQCstCcgSqjCChEyo0K+r4nz0OOtneXEkKMieXy3M8Mey9krmE1IZLxnSmow+uyZDqDlioRpyFPHjfJwZsmRl8d1LyHpNGp3YULvY9wGfV3JtsHti1CkFXmM7nXe6/B4iG5pAJdasDy37LdfPiyU82EBjyUwhwxA2Ckm8QwgRbF8CR2KrVB/9epiSjX+HcUWWLTimlnBdxZldXd34j8lc0ijTMhdKyFkaC6I+idmFEZsCjEFamvLwvR/jawj1D/Z3kLVlb1C/ebgLe60eUIzfdtRm9Z1OsUmmkyR3OR4Avslv/ai5AaEn7jJ4RycmBRaJthRssqoD4KUIp/R1ippTRukedkTSiYJmiWxjrUsIyxjoSZpKzPo6SNmcgs6KB71P9ou1KdGCMwia2F4DCBiXewmrX7ZB/dUIUNge0sJYkIs3oSd/MQbG/WbDavkft2SjmpUYw5ihaRno47q8pjD+2bAoxSmn0k2KkDeR+GoiFa4H693yJurxMggkJ4X28bTwIHvyJ5HNRrCYDDmJyOD6jcIkdDxiEe7Okde2jKnfhjI1zbmx9gTafrCDNgu0Oc0C22JngGk6BsNTi6IYztBFS9IrmFQo1qVB7KxdDb/pXfMhdRcLRB6vCqjISKc6W5OUhKjaGKlV3J/3IzwcRoz2bu/6bRXngwpsdinXbkBL+sUWZQ2Y0tKXIjd+PZXA0s7x9slHgLMGfu87YeNL8HqXodYCGiy9Nsl/Xp3fdzafb4yq5D+TSpB3IA7ICNgWPWXRnvw0EvDbIBXk+Y4A77PByUWbpBfpHIrcm3Md09/j+mzeIbl5KWWxcLGiRb4rN9j/rwnUBanAo/kE4pp780fymQHmlwV+ey5mwybkTnHNFoeNrRJsDP3N26LhWi7/KgfSXOfSsg0KqipD7
 GJgIEYUD
 5Mhy2oH3vEc/Yci4hhUd3jIIyPukf0gywhwPyjj7Lu5SW4RO8dCRyub7S0Lwne23HJ1I9XIsHBBBKQyOpFYil++aKm5qPul83t0E/EE05owDCFLHSm8Uq3EQkRv4coVqbp1f7oJLLmwM+G2tE+6qkQmhk6ItT1Ev11UMr7kvPSV5nItH8VVBkYmXq2+jNKWELWC3rVRCGw/FdB6/LmYi/1dGdN5yAjlIuiA04K6ur6JANORHQA8BekfvLxxaWx9b/pLVPZkagBzVjaoIybu/RzJIzgTwTJ+MQ2Pp+Rjuo0zb14ZbfPWSMGTCeUq9diUbrSBCt5vTi03wfIYW6KjS5EhKEodWvWbq2PPaAsFVeAkmF+avzem1sBoZQwzwckm1GHrXsrxekmBOsO3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11-04 13:22, Mike Rapoport wrote:
> On Tue, Nov 03, 2026 at 02:48:36PM -0500, Pasha Tatashin wrote:
> > On 11-03 13:49, Mike Rapoport (Microsoft) wrote:
> > > The lowmem and the global bootmem areas can have zero size, for example
> > > when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
> > > either of those areas is explicitly set to zero with kho_bootmem=.
> > > 
> > > For a zero-sized allocation memblock returns an address without reserving
> > > anything, and that empty area is recorded in kho_bootmem. If there is no
> > > memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
> > > fails and KHO gets disabled.
> > > 
> > > Extract a helper that checks for zero size and allocates memory from
> > > memblock, and use it to skip empty areas the same way as empty per-node
> > > areas are skipped.
> > > 
> > > Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> > > Reported-by: Chen Pei <cp0613@linux.alibaba.com>
> > > Closes: https://lore.kernel.org/all/20261026131851.9942-1-cp0613@linux.alibaba.com
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  kernel/liveupdate/kexec_handover.c | 61 ++++++++++++++++++--------------------
> > >  1 file changed, 29 insertions(+), 32 deletions(-)
> > > 
> > > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > > index 6f1f55fe31819..f268c57413a7e 100644
> > > --- a/kernel/liveupdate/kexec_handover.c
> > > +++ b/kernel/liveupdate/kexec_handover.c
> > > @@ -820,6 +820,27 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
> > >  	return false;
> > >  }
> > >  
> > > +static int __init kho_reserve_bootmem_area(int *idx, phys_addr_t size,
> > > +					   phys_addr_t end, int nid)
> > > +{
> > > +	phys_addr_t addr;
> > > +	int i = *idx;
> > > +
> > > +	if (!size)
> > > +		return 0;
> > > +
> > > +	addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES, 0, end,
> > > +					nid, true);
> > > +	if (!addr)
> > > +		return -ENOMEM;
> > > +
> > > +	kho_bootmem[i].addr = addr;
> > > +	kho_bootmem[i].size = size;
> > > +	*idx = i + 1;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  /**
> > >   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
> > >   *
> > > @@ -832,7 +853,7 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
> > >  static void __init kho_reserve_bootmem(void)
> > >  {
> > >  	int nid, i = 0, max_nr_bootmem;
> > > -	phys_addr_t addr, size;
> > > +	phys_addr_t size;
> > >  
> > >  	if (!kho_enable)
> > >  		return;
> > > @@ -852,56 +873,32 @@ static void __init kho_reserve_bootmem(void)
> > >  	 * reserve bootmem area in low memory for lowmem allocations in the
> > >  	 * next kernel
> > >  	 */
> > > -	size = bootmem_size_lowmem;
> > > -	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
> > > -					 ARCH_LOW_ADDRESS_LIMIT);
> > > -	if (!addr) {
> > > +	if (kho_reserve_bootmem_area(&i, bootmem_size_lowmem,
> > > +				     ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE)) {
> > >  		pr_err("Failed to reserve lowmem bootmem\n");
> > 
> > You are adding a helper that returns an error code and then ignoring it 
> > at all call sites. Even though it can only return -ENOMEM right now, 
> > dropping the return value is not good practice.
> 
> I don't think error code is important here.

Perhaps, but it is just not elegant to add a function that returns an 
error, call that function from three places, and ignore that error every 
time.

What is wrong with:

err = kho_reserve_bootmem_area(...);
if (err) {
        pr_err("Failed to reserve lowmem bootmem: %pe\n", ERR_PTR(err));
        ...
}

> Even if some theoretical future update will change
> kho_reserve_bootmem_area() to return anything but -ENOMEM I don't see why
> the error code should be printed at all.
> 
> And anyway, that would be the part of that change.

I just don't see why not do it right away? If the function is only used 
as a boolean check, then just make it return a bool, and move prints 
inside.

In any case, this is not critical and I am not insisting on the change, 
but I think it would look better.

> 
> -- 
> Sincerely yours,
> Mike.

-- 
Pasha

