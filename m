Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E406D606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 21:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dJqXFZoN
Received: by kanga.kvack.org (Postfix)
	id CCA806B05E8; Thu, 12 Nov 2026 16:21:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53FB6B05E9; Thu, 12 Nov 2026 16:21:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BE46B05EA; Thu, 12 Nov 2026 16:21:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83FD26B05E8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:21:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13DA01A17BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:21:02 +0000 (UTC)
X-FDA: 85427737164.20.43C2081
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2896340007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:20:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dJqXFZoN;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794518460;
	b=CqM1yW4LH/3CcEUoYzbzEcIFKrub/H5O7bNjIbvpe4a9M4vVH1x6GahF48BTNsV+lbibXd
	3W4co9wOzdXIBeWsLkm9YCJjvaLd1bk5CU+cDcd7xX1e4P0RKNhA8fX3UkrNWNhRH22VjL
	vRaMEZV7ViAF1n5tZ1WwAoeNSdHJ/20=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dJqXFZoN;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794518460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+bQ1zQpnSC2gph5DKJ41cDVxSj9AD/66mgtcKZOk5Q=;
	b=ZxjSiD/i3E6WRmrkVZyxc5/v8FKboICloo/WI68vNNniCAHuvNUtia8IQWwi5JcNidMnwI
	4pq1lbauokhPuYq7ApUUnYm1Uj3DswqpxonPl+VOixrJOmhib2Mg0l5m8Wr/bh2T07R9Bd
	Hf40C7EWMHKxtf1G71wsdMciFiiwAoc=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-492fcbfaa87so108163f8f.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:20:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794518458; cv=none;
        d=google.com; s=arc-20260327;
        b=ivj2iRwYxX0IaKw8sbCcpEA6GZJBATA+ZL1mpnnH+Ytf6kW5A55l27hydeFyRLdmsU
         WocBzyIsCnGFg2TdQ8C8b6HBjOa3oqc5xOk4+ntS49svEnOl1uUNSX+s5Sw9e9Ar3PZA
         FzekIB66TrGwftAzAMpTPqAX/RGGrVzPewXqyw1MTY1JeZnPVnt3t/Hxq/JxOSa9YerL
         Y9Fomr3vVfdHdENYnWXrQtqclAJ5UHGmO3QAFard7wcgJ+Axv8RIY+IBqNc43n4sQhm7
         orHsVj03a4+HRn7FVJzBVD95X7UzvZG1s9e+ZiF8PhnuutjvQGl1Ku8/3vSxghLWjm7s
         oCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3+bQ1zQpnSC2gph5DKJ41cDVxSj9AD/66mgtcKZOk5Q=;
        fh=AgTULX8jDcY4xkZ+E72BuJqdLhgBqBptsAe4z0cLsHo=;
        b=EKIXHrlKZNvLmar3znB6SYUGTa1evTkTUIsk5Ajx6URin9akQCUVlvwLwDnVqNLGzu
         HpmD5cvloUCYSJWodCdqOjd7ZMjpS7jFtgAi9PHNpt+FgZFlXanSnAugnFCPgJwCeeHR
         QLMBaN/gQw6CDhTVioJ3eRgwv+jUNn7YeOHgqFUfOw+tutsxe/VFCW/bHEzgDuOyL0ci
         OVOw4ZYjXHaWe9xwqtxPjM8kFJ6vfnWAYik7UFKuu0xMF8Z1jcU9INJ8FBqHuJvH31ra
         HLcaPEhNh2iNmtaaYjY0ijDwTM16KfNMeM+P+8stOPIx48wgG1sV7WmKR2IkdVauILA7
         QGEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794518458; x=1795123258; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3+bQ1zQpnSC2gph5DKJ41cDVxSj9AD/66mgtcKZOk5Q=;
        b=dJqXFZoNuWd1Oq6x92f00VY1tIoWZ+KledpsAsErAyvPRqWkm4F6mPR723BAmkhZzm
         iwapfmpul350uF7G1YlDUbK4lwHoWWs80UeGrm5+aCsmK85P6NuNMMKDx/NsaMC0nnq6
         DNvhYUwPNiiRJ1Dk1jb5nG5vQ33JuHgWCc3zDoTTN6HZux/ZdlVUzz2dxVt0MSPHdMSX
         zusbSDjDPp7vkxUGoWRH76J6e8P4KB/Ygjq+X47d2FWFKqgo8wG+FFHvhH1qse/8z1PK
         qb74XL3vZmD8CKUECivq3nTJG3fqZRUAolyojuTmdG73sd+LaBZBSsBbQdD8GTddBkDo
         CU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794518458; x=1795123258;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3+bQ1zQpnSC2gph5DKJ41cDVxSj9AD/66mgtcKZOk5Q=;
        b=n4ei7x4X+voBDBRNPKlPC1ZWHhy6h7Xb95fV9+2yCmX92KyqD0TaRjhhMzdzHhyEPk
         7K/MVvfVU/zQuL+9Odocol+/QKgHoGH7R1hcL2egCdo6+pXtGm19h87IKLhF3o9o06Pu
         yn5X+nJsL6bNvZxYnhD+Vkhvf0lKdVvLrXX+FihjB0CXTDLljIvjZHmWTUS1PxiZHycF
         SApcmUuwzGuC3eC+Vv6aNHPHf2EuFiPfndm5WDOpuTW8H6RRKbDWaX+I0k3FIZNeWvg9
         jag4lIpfnUmmIXm1Z6rTaK2L7+KcsOhOL4kgyGjNTIunxo5ZQ3Or/nGOj6r+SkqDQrph
         XSgw==
X-Forwarded-Encrypted: i=1; AL+hErGprBum6qQt7oAnDKqxtf28yi/vTphrK8VxxrYCZBVPSVYGpqzYkrp6J0zy6quyU1HTY3EnvtUGXw==@kvack.org
X-Gm-Message-State: APuU4Z/m6+NVbjXZRzW1rC4aYE48xaBb2Z3Nq7OcjdolnXqSLOhW9lUg
	/SIkMyTmi0NTiEq7k1bwWOVUdVrHan/dClu7kciANU72InybLOq2484AliefNTL6cMjw5WkSS+D
	GbOW//zu7/4iGxOGN46CqbbEX2rzqzJk=
X-Gm-Gg: AYBFou01U7MVeesEgSvi5Q7uQ2v69SLsrG0QVswCj/GwAGAZRsHpzeE/ZTHMIfWPioa
	a72u5goW10rYY6ZSZ5NTBBeR1gA7RjS1TItOqQ6opoJ4hKwYh5eyavPYo0TATh8m+QE2hMoblR5
	MCSljSu2F5ZqQ6Kqv9PeHck6lhle81nx8f51Osr0IdK/vJ5YAv27zjqRL5ZuY5FHDZSVrq0d8fy
	E9mpbA3NXMBKwW0sER9drH/up1Gh5S2HT3y44xvIIKVBS/E+vnIprDdwkMh9SgFlIDQqiaO1pHn
	OF6QUDBslCdymkZPStQXd8jjvBTRK1/DXRBQ5qvwtQYpNvbncg01J7TBom9UbTdlDa55wzSzlLB
	VRdxoZ9h1f11BcPP2mkX3vgMGOLK0qzzFrjh8rTB2lo9hR8B/kqmeDpkItgeBueW0s+lfn57UaE
	WyIeaF6GOvE3o0/aXYpkbPfDJqPDITWuTcy8R694k=
X-Received: by 2002:a05:6000:4553:b0:492:d8c2:7fcc with SMTP id
 ffacd0b85a97d-49c7316495amr847969f8f.11.1794518458411; Thu, 12 Nov 2026
 13:20:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
 <CAJnrk1ZkhvyGLUyZrf_gA3XBv1XTfHArGOMgqr=5XbSCBJHz4Q@mail.gmail.com> <2ed65a57aaa676a59651abd671f18dc9b55f9195.camel@amd.com>
In-Reply-To: <2ed65a57aaa676a59651abd671f18dc9b55f9195.camel@amd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 12 Nov 2026 13:20:45 -0800
X-Gm-Features: AclHuK8puMc590udg5ez_riNBORT-fzpcDwPqPA6P2g1nr93_9dn3rTPcwxK2Vc
Message-ID: <CAJnrk1ZjM+cs1XH=fhmGW1-EtthW52hoqxua1dw43mopXCW6pA@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] mm: batch rmap walks during large folio migration
To: "Garg, Shivank" <shivankg@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kmanaouil.dev@gmail.com" <kmanaouil.dev@gmail.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"weixugc@google.com" <weixugc@google.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"harry@kernel.org" <harry@kernel.org>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "riel@surriel.com" <riel@surriel.com>, 
	"david@kernel.org" <david@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "surenb@google.com" <surenb@google.com>, 
	"rientjes@google.com" <rientjes@google.com>, "kinseyho@google.com" <kinseyho@google.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"gourry@gourry.net" <gourry@gourry.net>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"usama.arif@linux.dev" <usama.arif@linux.dev>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"jannh@google.com" <jannh@google.com>, "liam@infradead.org" <liam@infradead.org>, 
	"mhocko@suse.com" <mhocko@suse.com>, "ljs@kernel.org" <ljs@kernel.org>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"apopple@nvidia.com" <apopple@nvidia.com>, "fvdl@google.com" <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eq19fpmy3t8cxzy9o1z5r4jf6fxof95j
X-Rspamd-Queue-Id: 2896340007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794518459-81886
X-HE-Meta: U2FsdGVkX1/KtslHOcjNZ30crQ2nGjAD7hqEHrGCJ80FYFfjduxxgv64+YvRvYlsaG4KCnV5p68ezxJP2eb0R/q3aghsSPyKhDiiUke1BRVPP1tQFokfza0YQ8iN5LtuOjYSwPftxJZIMmy8/s697nXicFve8jtu5kvqNazBPmKtbl3mfwIpIGnYFwsBzNkJQ2llv7mdxscE8WCQwzLbppeaqg+Ls3OQJmYFl7TVFE/WNgQofCP9Z1l8va6Lv6z93mrPLuOpkpgE1pt2Lpud8/EKtuph4S3lBag5OdTKsixkHLICOJ4CXhUY9z8I8mVg2VH5pkwb2cafeWcleplpLFXSy5xJb3qv3ybQUf4AdY2y3AEF8Tpy8DOK5ggVh0F27hVuh9n1P2h0xbcksedSfk4u++yzglN8FCSl6lM29LBlY/s/XTXjezydAXgr/jxNVif2XLvVBAGf/Or2doeH8nPPSSrvonDbJT3naHC6zQs43xReU9heTlkP8cinGfH1hwHPIE2KCxWgOwARTwR869rUfOpEXOTiAJxW29mjmjZT3oVbsK3862f7yNV047cwKgdSfPJLfPUrfBgWdBBDUNzqj0Lx7e/z0YV1cSqssW86npqlygFi8Et0vkNxYxtVHdzsaww4USsyNZoMtJvHmPpQm+OW0SCXtESDuZPMb1BoPKMkxYtkjIa+JfADcJCJ3UtdkEV7bmhM+kNbbYq3UWyIc27AON3YA9B5xOpJdZwOuwMZ5dbKysts1/16g+llSmdJ8k73TeVLCJXFRQmMqIGt+o+PTr8nMqQDeztN+rLaNS/xhWzKD8Eb1bNw6IgSRU4ZCvHjkxi80f9EzH5M5Sd42K7RRSoQq9xNWe+yF+bezNjojnwjIE/3i5urX3J5RpDaWggd365x4Utd52H4OqLA75YA8NVv3J/pp6No8xY+7zG0idhhgvU8ih8j/6uh4JjRv7juvmqu+eXX/p5
 37JzdJKD
 ddADd/x2ey8z+IHFk69I2d7/2LZBNVAZvzaUiEaT9+NDJIIEH1uqVlJCx4Pl+lehzO+E0PyE+RpK3lFaSj2ky0ByaEKigDSaBSPbZakPqkGiu80ZSdWCHCEtiT8pyaOumK3OTgx/WNk7+mBFRDgb4iMgJJYQmctt3ucaW+Be27QhvafQAdtxvNm6NDf5bJIjN3KXcFcbKrT78jOk5KHblBDXaTjBC/3H1RabHY82tmuM0G0o40soSTgdllXqL+G5jprnUK2VhrzrNdGfdVhkmNWY2rmvWrR+G7Wrvs5KL9SehnewSj3FHgmmJbx1DYSVjZHmzBxven4Pz70I5OaGRcMDP4A7mKvhwakj18VbrQGufcwTjQY+6j0EbmVkvdW3nGM/fPkvgl5GpLXDjYoT1M52FEE4Tu7CFlg3UaqsIqQV9ehKtOr9tpJ1VrUrEeiwDT9k6R8Xba1ZUb31C6rFw9YxU9oLnjK6iBqhu3MAix+dbaIT6O3i66BOgck6ILW0CA8LPDLWHB0zOSJMtuUkfnGiYxmeRJyaD/JKuEJaEIeZO14k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:37=E2=80=AFAM Garg, Shivank <shivankg@amd.com> w=
rote:
>
> On Tue, 2026-11-10 at 16:08 -0800, Joanne Koong wrote:
> > On Wed, Aug 12, 2026 at 9:24=E2=80=AFPM Shivank Garg <shivankg@amd.com>=
 wrote:
> > >
> > > Migrating a PTE-mapped large folio currently walks the folio's rmap
> > > one page at a time. It does so twice per migration:
> > > 1. try_to_migrate_one(): Replace present PTEs with migration entries
> > > 2. remove_migration_pte(): Restore migration entries to working PTEs.
> > >
> > > For a folio with N contiguous PTEs, each walk repeats page_vma_mapped=
_walk()
> > > and the associated operation per subpage of the folio. (256 iteration=
s
> > > for 1M folio).
> > >
> > > This series enables both walks to process a batch of consecutive PTEs
> > > that map the same large folio and do some refactoring and clean up on
> > > the way.
> > >
> > > Performance:
> > >
> > > AMD EPYC ZEN 3, 2-socket system (1 node per socket).
> > > move_pages() migrating 1 GB from node 0 -> node 1, throughput
> > > in GB/s:
> > >                        batch-         batch-restore
> > > folio     vanilla       restore-only   + unmap         restore%   res=
tore+unmap%
> > > 4K        2.96=C2=B10.15     3.02=C2=B10.14      2.99=C2=B10.17      =
   +2.2%    +1.0%
> > > 64K       5.99=C2=B10.10     6.12=C2=B10.08      7.65=C2=B10.16      =
   +2.2%   +27.7%
> > > 256K      6.48=C2=B10.09     6.67=C2=B10.08      9.23=C2=B10.14      =
   +2.9%   +42.4%
> > > 1M        6.76=C2=B10.10     6.98=C2=B10.10      9.74=C2=B10.19      =
   +3.1%   +44.0%
> > > 2M       10.50=C2=B10.20    10.44=C2=B10.16     10.67=C2=B10.21      =
   -0.5%    +1.6%
> > >
> > > In plain migration, the folio copy itself dominates the cost, so thes=
e rmap walk
> > > savings are only partly visible end-to-end.
> > >
> > > When the folio copy is batched-copy and offloaded to DMA engine [1], =
the copy is
> > > no longer the bottleneck and rmap-walk batching translates into much =
larger gains:
> > >
> > > This series + [1], DMA Offload on PTDMA (DCBM), 16 channels:
> > >
> > >                     batch-copy                      dcbm+restore
> > > folio    vanilla    -offload(dcbm)  dcbm+restore    +unmap          (=
rmap batch impact)
> > > 4K       3.05=C2=B10.13   2.76=C2=B10.11       2.77=C2=B10.12        =
2.74=C2=B10.09
> > > 64K      5.85=C2=B10.11  10.66=C2=B10.27      11.56=C2=B11.45       1=
7.55=C2=B10.56
> > > 256K     6.26=C2=B10.08  13.64=C2=B12.73      13.68=C2=B10.16       3=
4.76=C2=B10.57       (2.54x)
> > > 1M       6.58=C2=B10.08  14.25=C2=B10.07      15.27=C2=B10.77       4=
4.28=C2=B10.27       (3.11x)
> > > 2M      10.61=C2=B10.24  65.26=C2=B10.96      65.25=C2=B11.65       6=
5.66=C2=B10.87
> > >
> >
> > Hi Shivank,
> >
> > Are you planning to send a v3 of this series? My reason for asking is
> > because batching the unmap also fixes an existing issue where when
> > try_to_migrate_one() unmaps a PTE-mapped anon mTHP one PTE at a time,
> > the folio looks partially mapped partway through and gets flagged for
> > deferred split. My mTHP underused shrinker series [1] makes this more
> > common since every underused mTHP split will now go through this path,
> > which makes this bug a blocker for the series. More context can be
> > found in [2], which was my attempt to fix this bug, but then David
> > suggested we fix it in a better way by batching, and Zi pointed me to
> > this series.
> >
> > Thanks,
> > Joanne
> >
> > [1] https://lore.kernel.org/linux-mm/20261103212004.1356327-1-joannelko=
ong@gmail.com/
> > [2] https://lore.kernel.org/linux-mm/20261109220958.2071687-1-joannelko=
ong@gmail.com/
>
>
> Glad to hear this series helps your use case.
>
> Yes, I'm working on v3. I slowed down on it because it depends on
> Optimize anonymous large folio unmapping series [1], which hasn't been
> merged yet.

Thanks for the context.

>
> If it helps, I can send v3 sooner, addressing the v2 comments, rebase
> on the current tree, and split into unmap-side and restore-side series
> for easier review.

That would be great! The unmap side is the part that fixes the
deferred split issue for me.

Thanks,
Joanne

