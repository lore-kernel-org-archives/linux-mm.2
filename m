Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E8D606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 15:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nTSc0c7L
Received: by kanga.kvack.org (Postfix)
	id 205286B05B0; Thu, 26 Nov 2026 10:17:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD236B05B1; Thu, 26 Nov 2026 10:17:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CCDE6B05B2; Thu, 26 Nov 2026 10:17:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 972F56B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:17:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B94C1C3F42
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:17:11 +0000 (UTC)
X-FDA: 85477623462.29.2D809CF
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3162340011
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:17:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nTSc0c7L;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795706229;
	b=BsZnKesPMmnvZ1p41/iwkrRJfLE0dbp9wb2qA1YyiB93ZsI7nXnmg2/3/vWGGZwISmawWu
	aL67EKKeZtkOUVkMUtNR5Y5s3Gsb0iGXt3TgnI6chC5DRf1U03NN1OinQWqdGC09+L+oJS
	GGwuGm8AYf8bIxT2QwqXwxfUj4ySldQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795706229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzjKwk0Le2x/UkisX7hnImUaEzdnPPlkkivbYquJqUY=;
	b=SkVRBjI7Sr8KFS7A+4aSt4TXaPUnaQ0l9BB05hNWExijngiqy20LIcBOIML2YsiL2lZ4zC
	02kEx/2u/oFLM/sbBtVf4g5WqFcWrB35PrgxAXRfylZowmml/IRmTeZVuLsRN4daPdi4hH
	GbaB18z2r93Lo8Mks87SMgWCD5NZJ18=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nTSc0c7L;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b4e04eda5aso53143857b3.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:17:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795706228; cv=none;
        d=google.com; s=arc-20260327;
        b=f4JUfNukaqU81tdfL25piN0Aqna9jb4QWESJN9Gpuli7bGZOTJtfPPlVhFytQq8naj
         OdTDeAAV7mwmxakhIn6gjLVYv1hGtSUpVTpuUctge9shAu0MlFBX5Nft7VTZlUcAmnbZ
         169FUmV6fC3032BGhh8d+WfGAvbQiaonOP/vhyUvLzZ00rR+2DVK5hDY6deCVC74GQAq
         hTBydRyk4zNVbRl4VnECiFzGHA2yLWpElIdv4dLQLSuJ+3ATkelnycxPz2cQ6yTe2f69
         Z+UpdBVho/1zvGrkgKHUhjlmE9YuiEjcM9usAV4FaCJp6gaYRGG6aZdHUuz72znvE/Ea
         pEZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gzjKwk0Le2x/UkisX7hnImUaEzdnPPlkkivbYquJqUY=;
        fh=OegJ/MU/JgH4jkW4AnChu1D2HxnN+WvoFvYrMsVDjfU=;
        b=UhfUnes7ontS3VOUd0vkDJOdyosMdGEc5FR6GAFNfBZXDKWUDffnsCCH04Bl4KVdrm
         LuxYZGJmonJD/elHuNTWpKUYBLXCdFMWFyDdiWeM8lBZ++jFYhL8/qiNkuqMu8puJ90n
         pdeGNWfvaiLH59VxoMnSPkbDvKWy++iYUgt5ngWyR+Ppkq+D9bVkzf1dNV4OfSvuxUvB
         NoNBgxx6OCbxB+Jpty0/v7ZUM14wyUlEgMUk4sxY5NJTZ7AZxcfCaEKVY6UZWHenGCR0
         yvQhq22Ic7X6dCjPSzSgaxfPzXMDOESlPwxG6RxCF/CxGaTESQvhbNf54ysSxdm/w9/0
         uY2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795706228; x=1796311028; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gzjKwk0Le2x/UkisX7hnImUaEzdnPPlkkivbYquJqUY=;
        b=nTSc0c7L644z2tpjFiR+0wEa0Bb4/uh4uy54lqZPp5GGaPFPIkYNFE8a8sLQLLv7jA
         KP2FmQqnU2ARvFQzo0T82VHW00oCxEyognC2L80FS1pGOkntcwqdLnHGMPgTkM+B0dqk
         7GxvkDct6nzRPe5F7wWN8cpOY9iIbk800ZWBrUhXFpHpgB2yxr0bwVKJepQ3pThXkgCm
         QI9Rdc/u7/brtZNCudkmlB4/qQqme7EQ0nq5mM/6lxuKv/wRn5tCO1NSC5zcNrIA8Poi
         1wYzMlTP9L2apkJJpAPhdwmPHlYrnAOoqjL0CEFxcuo5vKtvkzXNj9/VuXmJl5fVNzd9
         G6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795706228; x=1796311028;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gzjKwk0Le2x/UkisX7hnImUaEzdnPPlkkivbYquJqUY=;
        b=qlzxhsNat1N+qEcuQT6ocp1ky3eGd+xDtpOzxj/Mm+qLIeotcWydqgBV/Htr692j7r
         5Ov1pq7V+0z12MH6zDPxkq0iw/CoySORSTSGYg48uycnChUijyaNf+WbGQong40pWbab
         mMbkDRoRm6L/55kuHDwONCpOc8iS1tQfhshgIEJ9rqk6KrEK/m0aV5eCypdNxRXy4+aq
         pnA5H15y60alSLjCi85SZvNdcNwAUkaFwVvWjdX59tNK3PdPu9mCi3hIW9Utv4IOaKjD
         qyKY2x0OmA0CWwRENtlutbtW1EUpC3j3yMJsq4LdcqHh7gh0ld1IH4dowskLQX9/bAOb
         zTSw==
X-Forwarded-Encrypted: i=1; AL+hErHImJWUPi1irQiAq0kGtP/qJIlYyE1gfoRcSB1wwIdQbuiZA1fggUQKbHgSaFHUFUDd/kqQg4L4gQ==@kvack.org
X-Gm-Message-State: APuU4Z/7iodpima8B7unkB1lxSOZ1HrrEEOdAcbJAYh/6yGWOf30WIRe
	6UPH3yA2z04i+vYkctDmQwWGZepftDR6iCcAsJe05ZKow+CMGIiwOM1u3G2LriZxpvdK2fMFABY
	Zi9716bAAr1FZyDMOwdA8+G82LZK+zvw=
X-Gm-Gg: AZFdTZeWYRsH6jaV/WzKdNRJuu2HeP5ZIixXJuNzsBSmeCnnRZpfRAetlz2KeYiLuPL
	tyP9MFWEedNyq3HTCoHh1RX8At4fbcN0C8rWTl/EsuNNgaRkuCE2vkZRlJJKHjG/HbXJrXDo+bE
	d1T/HJFMhs49nU9DID89Aydl8rX3LqnDjnVeveXQogi5rLlT6s0y0GlCVfIm5eqRKH1mdIjkH5k
	VjTZyt8KQwCboFAmbraoaWtuCvnfUHcHk58D1BFCZtoa68X5kpeqH3WyGBhhNZXAaFTbxcs7qjf
	z8kBVK5w7QQzPWM48cMFd8Q15v6IF5afG9cy3aU0dLx4VTLze10j1YC46NQ2bm/irg/CWc0Xkv6
	/nFy4nMymkItmqytMLJch2Q7HLQyJbsZZ3XnUtM5ECn1qA96QF3HWbgp1Um/WVOp7fA==
X-Received: by 2002:a05:690e:d50:b0:67d:a3f0:7d98 with SMTP id
 956f58d0204a3-67df4487e2amr8033601d50.81.1795706228153; Thu, 26 Nov 2026
 07:17:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125155108.24098-1-ekffu200098@gmail.com> <1b0242ef-49ad-4d7d-820e-d1e6569eacf8@linux.dev>
 <931acd3e-0689-4517-bbd2-d06109ac4a6e@kernel.org>
In-Reply-To: <931acd3e-0689-4517-bbd2-d06109ac4a6e@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 27 Nov 2026 00:16:56 +0900
X-Gm-Features: Aa3M54onaw8MJYDddQT_3nYWVFohYsmtAwqNoqMbydwkYedoY5CvfFd6KJvm8zY
Message-ID: <CABFDxMGzXM2iQjv9hLVnrDTrXfxhJ5NHkXiiucciHo8eMGn2ag@mail.gmail.com>
Subject: Re: [PATCH] mm/cma: reject long-term pins of HugeTLB folios
 overlapping crashkernel CMA
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Frank van der Linden <fvdl@google.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Jiri Bohac <jbohac@suse.cz>, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3162340011
X-Stat-Signature: m6z8ogmb5sx3qwao8ujpapkjpjatdomc
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795706229-585329
X-HE-Meta: U2FsdGVkX1/Y7StXgHN9/wP2ZSnsTXtp5R4lM9Xjm0vu0izVr5qQ7FuJjvUB1CPJMOZsiMaws1P9kYslBRSUOQzg0tws4B5NZjJOAEQ2MvhEgf1VbCJaye54kJcw9NZsZOIj5rijyv/F1K28Ml1PM53B0W4B/TdcsDSRYXXP2UixKekCPVuKQtLb20i7x69rGbNXSxrWHMlU8e0w/ibnBrvcAQLWCVgLfZ2ae0hlJtE/KodebUpl/9dr+O8YQGiyVj24Yx2dAT2ghHFX/soDj9RS/X/hinWaTMMjnl+yPYxNhySTGS3h21CeI1+7YRtotk4o+BEIBZPinD0EGWN4Kt8ToA//CFDHiZRJxY/dAQZpCzMOJ2BKuDeBZogkO2FDDU5gV+KX8cuzN7zedSvtPI0hy9GJvZcPddOx53EkinU675rvChYEDc2uWJjST33Qeg/GqyMCPpxOo4JA0KeADZXTqJG7ouRU5pxtKzH13JhDV33AWhLdpKat5Z8pOcZVku2hCi1WPzciHQZzxUTKq5H2O9pKXYKTUGgdrKxgS+ZUJnBP0mNGyam/p4JLifEbc6UpqI0gJn9VfdJCel9Ulp0j8N1Ruk7gK32vqZMMQSKloWIujqPg9wgKnVGz5k3PtiZ9CEal+pJv/3SPywPMLlXsWlHthBJJ/BllRyjh/kn+85xiVyhx98oLJTAjXt9FAIviE2E1mkHVO79eutvTnBY6KPnWJiPPRHbzXMyooc+be8YBLqBGCQiD3Hdd1s1UurS4Ao3fYE4l2zAzX6oFu6ZpvhmFHDHrF3HvaCcDkYZnVXHqywSI/18/CcYGHBfLHz/jBI9ihYnZ+QGug1rRFV0cIZqeYko1iLsbA+IsrWzAKVBA01yTGKuQOLPhL7VfY6cvPj2i4EW7UHmjKSKWtAotWtbjKo3j0nIUtM4c9Spt+V1mms4PE/WKMY0yhP6hmnEzT2ZRkt85rhtQUJe
 7YlOJhoB
 GklDn5GkToqwizIxRqnUt31BjIzySfEBJZmR6BgliqqdD6Nnb2OYkvMKborT5pzeaOsYYz4pD0PBKH6W5PovMRj0/M2zLXPLtSH47V+y4mlKUfKUSfXx/6ExZbHl+OaGq8FnmEORdBvHbbI/w4WWbPsJrTLItFZIRTplC61L9HpFmlxisDSPMFuaKLCbmfvT5SwrBTRfn6yuKwokUFQIVBJv0QhBekuNOLdE2QEVcVRyWwRI6H6KJDM83y3DGoka9hNRdbZOc0FazkTmn/f0iia3jxyHcg4lCynxdFlqGm3d0btenLW1w04tCT5UBUiJj86PaJJILl3bfZC13EqilG/YEIwhkuQBy4TBuCy4BkYIHgEU6vxBv7YEvlK5Zxpyxa6YCmi6fc3C7Va96pwtxZLxL0Sy/T+Y16a8IZdttEO3okfJpzUNbb+0EDzLMUznuylUX44yVyHcrWaQ1Q0sUZVjcZz8X39d6vC22T9ZM3ek1SOKDRZapSGQxpYZb1C0A63VnP5LytiSr1tDP7AnanGznGTwGd77P/NLXqnin7Il1N4MHS5bAPI9R3b7FJLUEygq7e68oWC82PRIEWOXbTXxjic63in6RY7D3MKhxCXZFoTR0w5aFzAwYNn+Ul6KW0G5MTgoMhqEp1TpQcE5ljHcVzwrv84X70mzVy1USyHYYBp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, Usama, David, Michal

2026=EB=85=84 11=EC=9B=94 26=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 10:07,=
 David Hildenbrand (Arm) <david@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> On 11/25/26 22:49, Usama Arif wrote:
> >
> >
> > On 25/11/2026 07:51, Sang-Heon Jeon wrote:
> >> crashkernel=3Dsize,cma uses existing hugetlb_cma memory, so
> >> crashk_cma_ranges[] may contain HugeTLB folios. HugeTLB folios allocat=
ed
> >> from hugetlb_cma can be long-term pinned without being migrated.
> >>
> >> After a crash, the crash kernel uses the memory in crashk_cma_ranges[]=
,
> >> but a device can still write to a long-term pinned folio.
> >>
> >> So reject long-term pins of HugeTLB folios overlapping
> >> crashk_cma_ranges[].
> >>
> >
> > Is spending the workload to protect the dump the right way round for th=
is
> > option?  kdump.rst describes it as
> >
> >       This reservation method is intended for systems that can't afford=
 to
> >       sacrifice enough memory for standard crashkernel reservation and =
where
> >       less reliable and possibly incomplete kdump is preferable to no k=
dump at
> >       all.
> >
> > so the dump is the part the admin has already agreed to give up.
>
> We have in there:
>
> "This option increases the risk of a kdump failure: DMA transfers configu=
red by
> the first kernel may end up corrupting the second kernel's memory."
>
> ... but I recall some discussions about short-term vs. long-term vs. cma
> discussions.
>
> Ah: https://lore.kernel.org/all/ZWJllXCN0SDIELrX@dwarf.suse.cz/
>
> "User pages for RDMA, should be pinned with FOLL_LONGTERM and that
> would migrate them away from the CMA area.
>
> But you're right that DMA to user pages pinned without
> FOLL_LONGTERM would still be possible. Would this be a problem in
> practice? Do you see any way around it?
> "
>
> And later (me):
>
> https://lore.kernel.org/all/04904e86-5b5f-4aa1-a120-428dac119189@redhat.c=
om/
>
> "What does "short" mean? At least in theory, long-term pinning is
> forbidden for MIGRATE_CMA, so we should not have such pages mapped into
> an iommu where DMA can happily keep going on for quite a while.
>
> But that assumes that our old kernel is not buggy, and doesn't end up
> mapping these pages into an IOMMU where DMA will just continue. I recall
> that DRM might currently be a problem, described here [1]."
>
>
> And in the end, we settled for the 10s wait, crossing our fingers that it=
 will
> be alright :)

Thanks for the explanation. So, the possibility of corruption of
CMA-based crashkernel is already well known, and should be taken care
of by administrators. I also agree that saving memory by reusing
hugetlb cma could be very helpful, and it's not a good idea to block
that.

Feel free to drop this patch. Sorry for the noise.

Best regards,
Sang-Heon Jeon

> --
> Cheers,
>
> David

