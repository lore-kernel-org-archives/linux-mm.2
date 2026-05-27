Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8B61CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1011F6B0005; Wed, 27 May 2026 05:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B26D6B008A; Wed, 27 May 2026 05:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09A96B008C; Wed, 27 May 2026 05:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E03226B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:22:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B138A0561
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:22:42 +0000 (UTC)
X-FDA: 84812659764.22.B4E2538
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id A19C3180006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:22:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rW3e9VUR;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779873760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zvjt27z8kXkbGkzX4jrChRm57mlyR6guk2SEu0CSjpw=;
	b=kT6o8/aq5oiBK9FoGTtwH1MSoIEMkksjBQEjmRDKs3MVx38BvrcDvs+LsO7O+3kNg47rzt
	ERlsu3IWam2Xdtlb77qH7IhmRzo6a9jJJrPkHjtm938q9Jg39eLetJWn5Rynf+t4syW6lF
	0Kfq0tw5QIbZv48ewjA95xaMuQd9DSM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rW3e9VUR;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779873760; a=rsa-sha256;
	cv=none;
	b=XXlRx+ozmztmbWzdefGuNmR4FbeBRiB2IKwDOHqy90S53RWSxSR3/6ADTizHPOs/tTEYg+
	k6CqfTJ9y3FJzNteDai7GxdfP/9mHhUkFl04Fv5e3BgaJi3JZDaS5FKrmdKq5aTs9cbYD1
	z6TIvI0h8fcIpWxNqS+4otFX/PnFvb8=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49050bfe053so18955365e9.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 02:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779873759; x=1780478559; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zvjt27z8kXkbGkzX4jrChRm57mlyR6guk2SEu0CSjpw=;
        b=rW3e9VURcOwqGRhwVzif0h+fOr1XQgNAisnCc+aHc5PmJKnJHjZcoycF3sMfcRL8fk
         pUjOeQSkH9lcuZZQnCgY7euzLBazegb4xzBXMx7hUpalIJ/xWlImRecaYPDdBE9CqTUD
         dSSYPjviB4By8XCXPZ8z1zxSt7h0QxEb+198Hz2IkBp2nyHt1GpGREa0VIQbA4NMpdAv
         oMx/4i81DNztaKrHaiX5T7MS5VpLZ817tbPIinHyu0cX6Xl05EOxa/53C1/XSeGK+MNZ
         sNser8bz1x7d9QDGZVkkOJJpx8sPLZVweYjvTQ2iLnZlSp2xMvo6HkgSUxNwC/VV5u3i
         pMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779873759; x=1780478559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zvjt27z8kXkbGkzX4jrChRm57mlyR6guk2SEu0CSjpw=;
        b=hvdGbZKm58leMGUNkftFiUgfrImwGz5aWWSgdLIax1RLNtTdj+T0Uz9KmxWCj6p7Lg
         Nuc2ys3SXzR+erm7xIyrZ46DnX61OaEP11ipW7bDjXzPdPFnsgE8UrZqiLisVOI9HLDP
         huAdL2KNP7Zu9vYIxtycpbyx63l7XXCZjzSddLb59oYhXTK4O4Nea74o7unc52G8X9Wt
         q2Vx4RbLmf9Q0dR7uxHj1FBq1jQCDwZcp6j7c+2EqE5l3cw4R/Ra7vTCHWQeC9ydl1pr
         Fvkp/h2KWdxKsd1uk2wec1ZwzyLB4/mHGOQMXdl3fTB4uCAsIDNbGPdFhJPyimfp0Vyz
         JbVA==
X-Forwarded-Encrypted: i=1; AFNElJ9J7QS2feqr2m40OsFVdLjbHRLMrJQH9BCZ3DRbbZQr2RKOxPIzNBSx3eNRtFbqgpj8AHrAqo7urA==@kvack.org
X-Gm-Message-State: AOJu0Yw1CL38LiKou9Xd9wT10j6FWQZbhECGOZ0VCFJIsbW1b8pB/ZVz
	RVLELI/Q4+aBq6ACh7kSJ94MhocGNoXcI+nl81uL/34aBtbLuKfx0bsd
X-Gm-Gg: Acq92OG4g9TJp894jrOAUcIB0fLaBjkUNmNn5Y1xmlgTr9sC0ggU508XhzKF0n4CfgH
	9dl7J9PHcZC92Sx7Inrxi6BUIZPq1RTH7oHOUtznfWfKYQrThNWmsnikyGBa5UBmOBpEEaAlxFz
	DSkJfp1Hj+HG8UTrAUobRLMVwmTIAEfZMVrm6VCQiLOkrKJYvHM/CAPb0BuT+WxzBC6rdUfmx5K
	Jcj6b3z1D/zLMieLpwepCNXXKzuxpcV9gOa8aHhdLwmAcloKbr//fKiBpAbog1FhdfmZ21S+mMS
	JCw4muVVwLBwBXAqlwEEuMtleSMSwUHKiP5Gj7y/0Dh/+Zn+d6smsa8mRxRjidCdLOZRlos++Wq
	zpEEDJS+Uw/I0DIwPqwWFea5iICdWwQx5TmshG1qVzK5iIEWR5ndNXrgT3TzOSB5b2fsyp/8hOa
	t1CqJCC8t8M+LA68OHeg/SL8at0BHSwam2iCzYHBMqohIdcpuRBPwl3NKX1Ti2EysOqbqM0gOso
	tRMNCyf5Lc6rxcE2FHQLp9lYfWsokecWej//4fFZzZWsg48RFPqkD0=
X-Received: by 2002:a05:600c:1f90:b0:490:5e2a:dbaf with SMTP id 5b1f17b1804b1-4905e2adc0dmr212138645e9.21.1779873758884;
        Wed, 27 May 2026 02:22:38 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4907e6a1f29sm14599705e9.5.2026.05.27.02.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 02:22:38 -0700 (PDT)
Date: Wed, 27 May 2026 10:22:35 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, will@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-ID: <aha321ndGSdReBJR@fedora>
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com>
 <ahAjudlB32VbkKbG@fedora>
 <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
 <1be38262-53de-4a27-9841-393e12fc1475@kernel.org>
 <db11078b-a283-4717-bed2-da56e77c7132@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db11078b-a283-4717-bed2-da56e77c7132@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A19C3180006
X-Stat-Signature: s8rywiyugmgaiwjgiqbj7qcob5zgoi9c
X-HE-Tag: 1779873760-489233
X-HE-Meta: U2FsdGVkX1885JpG/h/BbbKA0qaN6FjRmh8fBB+XApmuMJ+mhxke+TGz/b/hwE4KVcEDTiUwoX5nsc7bwI4LfbNs5DCxhikcZpiusacMEYGa3h1F67/KnCWT4cVnWanWhrXbW43LYPEKQsNvHMgFUGJvnJahZq7eibNAw9MfazdSc7VQmP8fEBhBOnM0glj12QzKeQmsw8WnKXcokHat55CPlgaNekHCOoCidGbHsIiZlp3NXVwN6cfgs5JnckPUGUz0zlzrtkxdCnhh85bdGYCg+etqnO+V48N+vhMdk1kc2XrC5p3yXauCvGIAoxlcQQAGjzJEXpy86cd7HDpJDm9KPha0UFdlRqYleJTC1dyxT2ljhGfI5/yfZTks4r6GYIuZpMLymQu8fnRINGZFPmOBEJxvuzPAiBhbMcmm1CFI1cn0/oC1AIMYMTiuseHPFjlQ29iv4wwGw2bX0HVDOzxcqmARTyx8xriPOv22frnnVx8oMwvuw1LhJ76NETDfxjtD69VGpL6sxdvqUs74cpR4oL2mb4B3HUGy/b7S4xSwIwtC2yrzZF5r8o8f3KtVp7sTONE4Qy++onC2j0IZonb7vBAPK71BUrB5f5cSPTmwebA0dIb2RyydDHKFdaS6N/WqFqYrxmL1sbbL4Rs/4cfweWgk/lkx1XcX/GmFH2ULruvfiQIzF11jjgWVuIVtQjw6XFmlbKGyNpXJmDG0Pb0oN9mYlEtghyHBeOzcDAVnVolfHSEnKd0qcWVMPDUzMv/EF1cfosvYzkLwIc5xtMnfznEUgyazyU0gh+MbptNAYXYjvXC1u9GZ4sNYOR2R0flLFKNOhNP9V5KSHevYLWZPadYCiPI/fNsVkxQ4OnJ3mQ5ZpdrYUje5SYji74Zlhd2BlzB8wNRZSwv9lQyn/QWGUGPme+/WcjnnFZ6XZZz/cnD8T0Xc2xlcn1zbxBlDtdKYF+rCHWE3vQ0WZWf
 4W1BnFh0
 D8ucpVbJubbeMCHwVJJSvmjWP/riiFewoZuRJl/iLN5vIKaPvsKKd0SnvNMOsPp3hfJrD2bAd3BFxIATeba+vxbvRpO8XiNrzKAMcURJ+FR2C2X2Xizx7+4TYgGI6EwKpE8QSo0OQ3hwZ8ALilSxQ7nDqhwjUJstKgs9+pxFpwr+sxu569LrNSuS8AWkOJwVFBUbJ1Z9lo/2rT+JZC4WaCMUPm/jYW1XcA4dU0ArhFmYguvXIkwrswiYuGLoeYzymlTNz2sZq53j9v8X/7G3tdd3761yRkmn0zxez0IBAVGiIx2zpBqcMAeDu0WU7VunLs3Ac7qfhlvXNL+MQD4UtbMXyhLp5H9vhzCEOyTrQQdfB3P4w8a1iOa5IqGBfSGUdhsGXCmX3HoKORL08t0fNcuhxnQTLi8udJDBOmgxqXi0+xgATFoDxSQ+xvkIOqBRFTQL/61wSGbVO8eIWB1verMXQGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:34:19AM +0200, Kevin Brodsky wrote:
> On 26/05/2026 14:31, David Hildenbrand (Arm) wrote:
> > On 5/26/26 13:54, Kevin Brodsky wrote:
> >> On 22/05/2026 11:36, Vishal Moola wrote:
> >>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> >>>> index 4c8959153ac4..9d42cbddce27 100644
> >>>> --- a/arch/arm64/mm/mmu.c
> >>>> +++ b/arch/arm64/mm/mmu.c
> >>>> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> >>>>  
> >>>>  static void free_hotplug_pgtable_page(struct page *page)
> >>>>  {
> >>>> +	if (folio_test_pgtable(page_folio(page)))
> >>> This should work.
> >>>
> >>>> +		pagetable_dtor(page_ptdesc(page));
> >>>> +
> >>>>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> >>> In the case we presumably have a page table page (ptdesc) at this
> >>> point, we should really be freeing it with pagetable_free() as well.
> >> Agreed, I think this is the right thing to do, something like:
> >>
> >> if (folio_test_pgtable(page_folio(page)))
> >> pagetable_dtor_free(page_ptdesc(page)); else
> >> free_hotplug_page_range(page, PAGE_SIZE, NULL);
> > That code pattern is wrong.
> >
> > folio_test_pgtable() shouldn't exist.
> >
> > In the future, something is either a pgtable or a folio, not both.
> >
> > So check the type against the page, not the folio.
> 
> In other words use PageTable(page) instead? Interestingly I can see a
> few calls to folio_test_pgtable() across the kernel but none to
> PageTable(), maybe just an antipattern then? The ctor/dtor also use
> __folio_{set,clear}_pgtable().

If we know for sure we have the head page (which we probably do here), we
should use PageTable(page).

I included the folio APIs as a defensive way to ensure large order page
table users don't break. We only set the type on the head page, and using
a folio guarantees we're accessing that head page. This can go away as soon
as someone looks at the architectures that allocate large order ptdescs.

Also, most (if not all) 'pgtables' don't use ptdescs yet, but they
probably should... Anyway, in this particular case, it looks like pgtable
is just a name symbolizing 'page table' and not our type 'pgtable_t' anyway
so I'm just rambling.

