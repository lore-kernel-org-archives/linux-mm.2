Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F45CAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 19:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7218E0006; Tue, 16 Sep 2025 15:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE2F8E0001; Tue, 16 Sep 2025 15:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD0E8E0006; Tue, 16 Sep 2025 15:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 142A28E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:27:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F5015723E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:27:14 +0000 (UTC)
X-FDA: 83896096788.23.DDF701A
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id C03B94000B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:27:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kSdM4GVR;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758050832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+88pAM765ByhxxTvIHtdee+u4rcNPCpXp45pnbq2P4=;
	b=AGLtWvvcKek94NX9Py4rJ1FnixUQLm//IRQJ8C8FWXrV6hDzHXKZAxlvcG9v1eeyY19Tr0
	LCkofuScGe+sdxdxSk00DzNIgk927iueuMzCj/tfiaF3mDjbSU1cOQ2yPRPm4PVOnabOYH
	/Ro3Q3HAkUAJvJBbBKjOUNub9gLt5CM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kSdM4GVR;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758050832; a=rsa-sha256;
	cv=none;
	b=UcybqwpkKafHEUUItiiNtMlSkvQzSWaZs6972KO+iyzbODsSb8e6V9aqsD8XuftI0UqUB1
	Z8SUGiC8ubazd5iqrBsYf2v5fxfHhnWwA9pVuE7YXlVhgXoeWPFnSclJtOFmGIOzVbEF2m
	DJiRm1vkRw/0DC9n8l5FnI0/ow3O5D4=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-265f460ae7bso35465ad.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758050831; x=1758655631; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e+88pAM765ByhxxTvIHtdee+u4rcNPCpXp45pnbq2P4=;
        b=kSdM4GVR83ZZVvjE5rT+fRuGWi4Zk9fmyxatxSPzdmvnI/mNBlGaMoPRfaON6VHhP6
         ZmGobDxVd32p30xCwNPQlD6sSx9rdaw0OOVqNvdVh3HkA3+kdV2WZ5iXM6YAA2fzkCj6
         BiaFtsr9NvLA8bJBSvA70tYaSj/T2YBVpfDHJRZKE3GUzv1mZgDo1wzAAsHFTi1exNnO
         hPLdq69rQOMLPMFOVB6wKhz+qaX64CZCLtFxCLKU7ST6gsaTCcfUIAlV2otuxdpxcK3S
         z7fM4ahTNgSJbkX2VvnGbnHdSyDagiOT9nfNGf6QsIMZfBDwkXPuCjQv+AV2MF3ckw+J
         0pGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758050831; x=1758655631;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e+88pAM765ByhxxTvIHtdee+u4rcNPCpXp45pnbq2P4=;
        b=exHV2EUVKaJIdvnUxTMsRyv1VIEF3cEyCzyma4IAGc7PM2lAqhZEqGGIvKMFIphhOq
         3PNpvuuG5S/DoqtC4idY7SaAz7XlMS2qe71h6a2Zdxj358ZWMEJc48IfXsFUmSEJEstj
         6S7PCCwQB+m54NTgPDRCXL97K/U4bSZtrVQyCYp87XM+4G6rNd5yQwnnldONbdtnC3Gd
         CKpvPGp3U/3jGC5JLeCrYVPAu5mdF9DV5bk5x2+P/KuZscHfzAl27ACFmETfVEIy0oFN
         qpFMTV0moOBYLaMKb0+t+2kXB8eHiI3f/HRlZ/lylKizmLaPbfStbjWEy0Ive+wUFCvt
         NBpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK33E/cZ/3D3bbXSX6E6j9Ridfd4felFmugc7THPJjqs5D/4vmdYzjRRtNNtCVIVDrhviFmXKHzw==@kvack.org
X-Gm-Message-State: AOJu0Yw9SfavCuV2H/U9YpoxP+BjBwQwmEY15hhisxwPGWANYB2B60l6
	tJ1WCd5XIXv3kH9lsNVNTqNBxQ9v1lzDJH9w0UowWQBolXI1BODfr4wja86Efvschw==
X-Gm-Gg: ASbGncu094OpTm2Oadb0vMC8hf/nAAS+pvaEnptF+IJ9VbrvJBZWNySuhyLLYHt3b1C
	4Hosrx26kjo2nCCfKg/vddcS2RLGc5SO0RRtFuri5v4pKF3hH0Pj0cIqknMtyfnIuB9jytQWkOp
	OuPeQXGmoNF2n/Fvi61iGCXjj7nhZbioFIVTq0fcaWvoXHULw3RpnQI4HTzufdreRflHaTZ81MA
	CQRoab1HcFcFM220eliXtwDnp73fA0bHzSkg0PWd0oSDTifD36dS66cYaT9Opdzvsj1nW6SR+EE
	7JnywMxsSPZzm+TpSHeh7jFWn9vPksleAYLgr2OuOC06giu0SDrPFFKGvDAshsln9NVLxn40FUU
	wnlNfKAHt20rhhhS1285dfPGKsRgq287UCemh2gSxQ3ftKc8FvpxMuJXjodfXqMHO2wAOTr/Mqr
	nnyDiJaDXtl2DsTmmZzK2hSGHgayOFwuCPFXIntHwmb5EV6trEP7sxDe/IKelcI7u9hw==
X-Google-Smtp-Source: AGHT+IFVhu1HB0ZSCofGaztjxsqj3Wgml8yyzA3KFYUh8Azzl2s2++2gyAKdXri+mmOv8BeFKDU3UA==
X-Received: by 2002:a17:902:e751:b0:231:f6bc:5c84 with SMTP id d9443c01a7336-26800f6615emr852675ad.8.1758050831246;
        Tue, 16 Sep 2025 12:27:11 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:3226:ed0a:4c73:99d2] ([2a00:79e0:2eb0:8:3226:ed0a:4c73:99d2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b346dasm17161924b3a.68.2025.09.16.12.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 12:27:09 -0700 (PDT)
Date: Tue, 16 Sep 2025 12:27:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
cc: Eugen Hristev <eugen.hristev@linaro.org>, 
    Matthew Wilcox <willy@infradead.org>, Amit Shah <amit@infradead.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
    Christoph Lameter <cl@linux.com>, Dave Hansen <dave.hansen@intel.com>, 
    David Hildenbrand <david@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>, 
    Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Kirill Shutemov <k.shutemov@gmail.com>, 
    Mel Gorman <mel.gorman@gmail.com>, Michal Hocko <mhocko@suse.com>, 
    Mike Rapoport <mike.rapoport@gmail.com>, Peter Xu <peterx@redhat.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, Shivank Garg <shivankg@amd.com>, 
    Sterling Alexander <stalexan@redhat.com>, 
    Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
    Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>, 
    Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, rdunlap@infradead.org
Subject: Re: [Invitation] Linux MM Alignment Session on kmemdump on
 Wednesday
In-Reply-To: <nglllfwopxgz3fye3grko3hmbvpmfhewj36qg6lbh3b66bjpvz@foxfjulayqst>
Message-ID: <08c0b550-0a78-0b25-308d-18b143999599@google.com>
References: <426751f4-428b-ed01-509b-d13e719a2006@google.com> <aMhgoUvziLPNt_vI@casper.infradead.org> <cfac2d98-2214-4bd3-a4cb-9b319acb462f@linaro.org> <aMlS9Kb6_x3fqsLG@casper.infradead.org> <50b566d6-aeda-48cc-bd67-362cb29b214a@linaro.org>
 <nglllfwopxgz3fye3grko3hmbvpmfhewj36qg6lbh3b66bjpvz@foxfjulayqst>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: C03B94000B
X-Stat-Signature: pssqw5hmune1u7qodky1xkz5s4jtss8x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758050832-736244
X-HE-Meta: U2FsdGVkX1/I5osv3AeVDFlKzAK4NBpLPtftM9UlCb8PqcMyWFnTWh2xxwJYs/mwmGxu7k0Kb4CxzVoS2AllNNtD5CFTthGShGtKqQxMOZMR4xbgWfUzr6wDt8TfPWP1HzFue7y5eYD4jZyC3d1eoMezSDvyovaWLat7gWLXr7WmqMJ0H6PzlncFqCeVOUFrF/sKlV/0xaQXbiU3rA/ZCx+Cs1HmFYd93mLv3G0X6J9iKowdYOsQoRbq+gb+xhebNptzc7YGROdUOPjVBBoyCrcy4P/m4ivzZ4oEHVKAj7DYXnS/ZBT5XlFpvRU8bwy5lw0HwmMpq3K5UYroRMFOTx83mO68/oD5yKl81KBufxR1XtnAaq0iagQdbXZGkdMbatb6wnr3B5I7ohAkhJkMVlDVTZdoxiqeNcJIQ7fPlZJmu4VHUNxR+EOdGAO3E6Mrs+JpvWuFwXthqZVJgIekbSx9ZofU2wrF6745hjegqytRouWPNVMITTl0AM2yzgX7dONjR24WU8AEWvzlzFLa3Mld40FINl7gFckTLiFYDofl887tr+G3W3a6i2QqqpWOQ0brOYDq3WY1GBmoDeZ6XI+ElUpfK/BVN+h0Q1bGLtAxWBFiB4C5KuSklYzQYuIabIcq/bgtPBFpWNnh/GCOfl4FGFBJc7PpwEeyFimAWxcH9f9MJa26l1F9+5u5etT8ANdCfxfbNV+OiU4hiCerJB7qGQ2VQ/Kc5uxWnKzV4JcNP00+kTlG9wgYKkoIw/bIE5mix4S+mhHG+EHZXsUbcBt51UN5FjJxeKaK4/ipsoaN+tJEFw70ahHkx4K7NTKc5ptHE46Xqm2blLalPRfEi9bHjw+7dnQJfFD7dJCCmWA0nLC5688HgZW18+j2J1T3dni8ApMpdm8UAjeIY8hiMPIdSsdTRK95lzFecEsjnn1MndDT/ah2BpfUsoAooQEcwLkxqUb+appdG+0osjJ
 bUVzjJzA
 2agACBmAcilJ0qHYb2Wb4KOga0mP0oo2qDkMtJsn1PwFM2hzD6GgVAtYHmnw9gvG2T+pvWgE0EjCeO1x7Ag1S/c6cn1zP1XVyyxj74nAE/IBeuzvRr1maRbfBQFdbcAMR97kGkdNumnVu5DtuZgIihiqo0/348mncBWMcUgiNBnHYoZz/p+pLbl2UlgTH+x7KF6lnO55kULl01LU/35e77EsW5S+HlOarhSktuQjfpRQz0QPcm36wB2HHB50pYlUMQoC/hiDdaPtCh2vVWUU1UjWJEyU7vpHPFfSuln1bYJTgRpC48EclQLPZ327rvlfmhwnO+U3kC+S2tUMMloTHfYRzDXItSRq+hzKvKno7wwchXMaToTvmPBpaNyYqCUMSaIVa1tT+frcqTZzgCbl2TckTfkJaNqlz7faZHGKXcdbnrIOrnDRAPMmrAtrEmzgj2uktYpGoKacl2LCDzeac86dsbEOBnDtCmrWTDD3MLWXw1nK+4HtkdXtAHcMglN5k4/TkACyY5kVtpDoqoJBtoBI2srkOXjrcHm/4/Lb/KA/GuRmESLdojfnamF+9kCvpFQl35RtUlzrZMN7349AqBRdBAyHXODej8a0g1nQnquBP28s/69OzoYIJs2kCUQJAF/KN0WRNmxWegAY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025, Shakeel Butt wrote:

> > >>>> This week's topic will be kmemdump led by Eugen Hristev.  See the latest
> > >>>> proposal at https://lwn.net/Articles/1031319/.
> > >>>
> > >>> I don't understand what this has to do with mm, to be honest.
> > >>> It looks like a debugging aid.
> > >>
> > >> It was suggested to move it to mm/ :
> > >>
> > >> https://lore.kernel.org/all/0fa9e4e7-1247-4c82-8c0b-fa65b7fbb56d@infradead.org/
> > > 
> > > I feel like you should be able to explain this rather better than
> > > "somebody else told me to move it".  As of this moment, I still don't
> > > know what kmemdump even is.
> > > 
> > >>>
> > >>> https://lore.kernel.org/lkml/20250422113156.575971-2-eugen.hristev@linaro.org/
> > >>>
> > >>> is a great example of how to write a lot of documentation that doesn't
> > >>> actually tell the reader what anything is.
> > >>>
> > >>>
> > >>
> > >> Here is a link to the v3 where I changed it a little bit :
> > >>
> > >> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
> > >>
> > >> I am eager to improve the documentation to make more sense out of it, I
> > >> am happy with suggestions.
> > > 
> > > Start by telling me what it is.
> > 
> > A way to select memory areas from the kernel that can be used to debug
> > the kernel, instead of saving the whole memory dump which is mostly not
> > of interest and takes a lot of space.
> > Anyone can register a pointer and a size, these are placed into a list,
> > and a dedicated firmware can parse it and save it in case of a crash.
> > Does this make sense ?
> 
> Is it only for kernel or is available for userspace as well? And the
> crashes here, we are talking about kernel crashes or includes process
> crashes as well?
> 

Yeah, I think understanding the scope of this work, both in the current 
RFC as well as the long term vision, is going to be useful.

In this case of kmemdump, which I agree is not core mm, it's likely best 
to use this alignment session to first describe the problem statement: 
what are we trying to solve?  The reference to dedicated firmware above 
piques at least my curiosity.

I see some interaction on the latest RFC, asking questions, and deciding 
the interaction with pstore, I think the goal of this session would be to 
determine if (1) the problem is worth solving, (2) if there are existing 
mechanisms that can already get us there, and (3) if the current approach 
makes sense long term or if any pivots are needed.

Hopefully an interactive discussion will save time in the long term by 
ensuring alignment in this area even if the feedback turns out to be "no, 
we're not doing this."  That would likely best be done by first 
describing, thoroughly, the problem statement before jumping into 
implementation specifics.

