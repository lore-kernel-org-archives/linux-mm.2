Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 585FBCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A466B6B00B7; Thu, 21 Aug 2025 11:27:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E766B00B9; Thu, 21 Aug 2025 11:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B9D6B00BA; Thu, 21 Aug 2025 11:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 83CEE6B00B7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:27:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BE6AC0356
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:27:52 +0000 (UTC)
X-FDA: 83801144784.27.BEA697C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id C75654000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:27:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iz4nnmuz;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755790070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTgtJ49Xu9MWkFK2EAlVwrx17FYOOV7VldaM8h9Pwt4=;
	b=y8YWq0K19bhMLRw176oYMWI1phew9YxG27/T/vmVP1Kc1ARFZv9pMM1phtMywcM+qVssOr
	e19CI+BE0K7OZxZzgbnh6MydI+YAkxN5ilHDwUUEogxjWhbVMkEsy/GtF6GYYEoJUTtD7F
	sW8+km+v17aWaLoRJ+sWe4+wqAtfUVc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iz4nnmuz;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755790070; a=rsa-sha256;
	cv=none;
	b=VxUO6kJMt+Bmk81tDRRYeAk337QRlMhxhQ+ZQDZ8oFl55cxpZpgi7YVdubvx0XliBb5HSr
	9UVp+2K5NGW9YdJetO1GcS7GybDmd8ykbhCVSS/uAZccsbxfY3dukdyAbm/8O1LUZh2Ks0
	DyZV52tgmVTlHlwggghsJGybkxp3mAg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755790069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTgtJ49Xu9MWkFK2EAlVwrx17FYOOV7VldaM8h9Pwt4=;
	b=iz4nnmuzs5JhNqjp/bOXqPGzq5lsa+jkHpzTmaXO07T58a+4/BsJ8S08ZRqlTbimC+mHCo
	2y4sRcDj3jfpQnTVH5PSYU6EcbKjGkeDcWeR8ByYlbCgqyl84mLZLtgFRAItpWrlIRMZz5
	iTpEl6guHEWqXF6bQp9ezb6yfypTlHo=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-pO-C3ppdMLS0aPCCDo56DQ-1; Thu, 21 Aug 2025 11:27:47 -0400
X-MC-Unique: pO-C3ppdMLS0aPCCDo56DQ-1
X-Mimecast-MFC-AGG-ID: pO-C3ppdMLS0aPCCDo56DQ_1755790066
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-71fbb9572fdso15620927b3.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:27:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755790066; x=1756394866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RTgtJ49Xu9MWkFK2EAlVwrx17FYOOV7VldaM8h9Pwt4=;
        b=OR6dNqcvVfbn5Q2oh4jj9vJeyQphGtIudvfD9dHeihAQtOlomHzQMg1vGP/edSJCtq
         NYuPROVWk3apBTh1KAaKAyPBkoLxZKdqhTCzlLD+HUZA3GPARYpm4zFbffunW3IG6ADv
         /9Jpbq1+ZMg6QRS3C3tUXSC4Kou4McrxQ7yMfAsF3/f5vGJJg5JUjS9uOwxOUNN2/pPs
         MtrwUTqcvUyFB4B/1sLxqcGNpZdca/V7KcoERZ8vvWPTMxeC3pSUx93KfCijgbwaRu/0
         SNiqIq1JVzUyZChUAiC1QUpM28drK4wVoaGclx+EPSRFGE9qCn1DPOVH+Imey3VKfEMQ
         FRxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtR+uMCndS4uJOz75IhKSikdSdxUGi8gFW1u29Pz7SWbT/NRyCwIhVqVDhtug7jbOLgqF4AVOZ3Q==@kvack.org
X-Gm-Message-State: AOJu0Yw/zAHtYB+VIvtvyaLo3YI8eCev+R4DQkhj/H1kLLMhE6Os+9Uw
	m9FHvWtnfNdY4E01Y6X2CtGSeTpfYHyyvUmvLPDf0mxWTKeZLYZI7Yc94CfyuSh/jlArUh85GTy
	JCD0hx62Crtwk9ep/9p/hOxch9l22NAGU2/u8gWUiADbllTSRKRmUcEo4Gn2qu7FjtEYAYJT9Ss
	V/pomDIwANnjJga7bdw5YR7aE+1/A=
X-Gm-Gg: ASbGncurVpbNSAgA4b9Qlwl+3tsZ/aSzT2eZ4Al+N/wWxA2OAAPRBLiV0LMBxeC7YrV
	g/dBxJB9/vImA7RgQ3ndTBRHuZaifpJnb5D44IP7kP3Ea5HKCqF6XLVoQLWxnjbqxsrmxyGaZ0L
	8TxFlzZCJsTxn/CFnQgxNqGPc=
X-Received: by 2002:a05:690c:3606:b0:71f:c5f0:337b with SMTP id 00721157ae682-71fc88e8a3bmr32433277b3.1.1755790066398;
        Thu, 21 Aug 2025 08:27:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFc5TqILdLWzdl1VIfMGwn0VK5fkAbHYWIlUJd1eTuGNqYvohCQdcedJXpukc5CDWRWTZRM1EwqOto/rJviUU=
X-Received: by 2002:a05:690c:3606:b0:71f:c5f0:337b with SMTP id
 00721157ae682-71fc88e8a3bmr32432717b3.1.1755790065938; Thu, 21 Aug 2025
 08:27:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com> <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
In-Reply-To: <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 21 Aug 2025 09:27:19 -0600
X-Gm-Features: Ac12FXw32JsJSfHSBfYcPkLsEOjNfM5l-nBIkC40qTwdDNq4sNQAax1B3J0lGVw
Message-ID: <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, corbet@lwn.net, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2UhzPg0xrHwfGbCRTrm-pqfQ-N7-stAgm3H1rAUJiag_1755790066
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C75654000A
X-Rspam-User: 
X-Stat-Signature: wa6bctm81rigt3dwp159dhmgqj77i9k5
X-Rspamd-Server: rspam09
X-HE-Tag: 1755790069-582554
X-HE-Meta: U2FsdGVkX1/2/ZDCgNx6SNURh8HlKvNF1wuC5dT/YkISutQ/plVyo+ekD3qzSwC9VH1DlVIhTYDcdYtoZBwBm65X9Nm2/YvUQlOeazDtLPyyGPXXfHabkV3jyy4Wt6MA0XHB5gBz0/BvUZBxBf+t4x0+X86oU4T2dTN1hhXvje3I8+ZN3qEeqOgLb31UNFQKMf2kG8gUgKWua/0C/GXeGtkhd+P1SVdxSJeLuYX3lIc/Qsx2WS6EqMhQG4uagIU58QP2N7gRsciXLvJ4Eh3uMphEf/8zmdpZuH1GiyYqDELO4do0FI53nQPv+o2NR5OT3q7EXJAvguEp3seg3Xo6glYMp/+eDg/tozgM47mUKRGzGAmGHRzzuVKWP0gUyrZnAf1HUritbDAv40LCmbCSS3xYBpkDIuSShnJvjvWnuv1wDbm1GR1Ll/v2ePdkNYbj1ASXsWKRkV1Mhm9O/dS3Iq+lqYegiVOfq8GC8at67Hg8fvkpZjjIr6EjFr3TUveSfS0LBTjznZU7cAFDDINlvOJwAzzHPmIyjasOSKLEw15z4OgkDcJ6JkV2JZELKUDJ0XxSewSREidw+jAdI9ysBXB4CQVTcB5wd28CHgSNaa60zkgCmlseCXqTsKTpHPHRZkcOuyBJkmTbmq8LhlN/trssJxsINXIJnGM5VPNcwRx1O9LXGl8wBS+jIsTYJ1RDZmDhbz7eCqdW+OJeXueXvq/dmt8iBnnqD9JAnnKZlNUyVcfRf47KCQwW085eMXp0N4IBkurDyXTVLSyKo56hWTVUGoiZ1v6UmBi5wLCfeImT116RyOGOHOec9sey8nQjoKwDtT8JpYLl4rFqggFolF8XFM6/gb4m0KIZehJC9QNlem95caUL5Wr+uv443pC4Aj/SYRJbLGXTByhtsYMK3jLdWiHim+7Tklg9BjmY+cuBRe/uu9Qn5TH9i374rRKvpWcY1u58EE9/F7zI3DG
 MunEtI9p
 ZR5kdWUryzN+ZCpcD4lQofxf5poK9LlWgGKfHZpyXwlsaca7lnwKHTBzwNBGU9Kcz8LQmTtnVH1BeRNdoctapo+grcggxpPtj8T8ouY2k1j/Lo7/17+YMjkflHgBQhiPrmHVR+fFi1bjyFS4LNwt9FblrmmriiXkUYq7hAIsl1NfQtjjIWv4+u+SAEXDTfVndUFyFl8+w+v3o7xtvnCbzGyE8Ujz0yNMhcc2tiVT6npAvjUFSKlv6iAUQfCS03ZyTDjB2jf9lUxQXBJwS2cHci8yyAUA7eCy5m/JqmgXQ4M62nGC8FRgCuT5C6Tj0CaApwurksO0Yz13krb5UTsUHgbk3tJSdgUkhgCY1kXSBrh3ez9zMWCbp9i+asT9wrQ5A11AxnjUHNF6b+9CaaBQgEYi/xjGwL74ldfRUhC3a+39z9Q18qeLPBpY54aoRcFxHWuneHgpMHBDTDAI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 9:25=E2=80=AFAM Nico Pache <npache@redhat.com> wrot=
e:
>
> On Thu, Aug 21, 2025 at 9:20=E2=80=AFAM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Thu, Aug 21, 2025 at 08:43:18PM +0530, Dev Jain wrote:
> > >
> > > On 21/08/25 8:31 pm, Lorenzo Stoakes wrote:
> > > > OK so I noticed in patch 13/13 (!) where you change the documentati=
on that you
> > > > essentially state that the whole method used to determine the ratio=
 of PTEs to
> > > > collapse to mTHP is broken:
> > > >
> > > >     khugepaged uses max_ptes_none scaled to the order of the enable=
d
> > > >     mTHP size to determine collapses. When using mTHPs it's recomme=
nded
> > > >     to set max_ptes_none low-- ideally less than HPAGE_PMD_NR / 2 (=
255
> > > >     on 4k page size). This will prevent undesired "creep" behavior =
that
> > > >     leads to continuously collapsing to the largest mTHP size; when=
 we
> > > >     collapse, we are bringing in new non-zero pages that will, on a
> > > >     subsequent scan, cause the max_ptes_none check of the +1 order =
to
> > > >     always be satisfied. By limiting this to less than half the cur=
rent
> > > >     order, we make sure we don't cause this feedback
> > > >     loop. max_ptes_shared and max_ptes_swap have no effect when
> > > >     collapsing to a mTHP, and mTHP collapse will fail on shared or
> > > >     swapped out pages.
> > > >
> > > > This seems to me to suggest that using
> > > > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none as som=
e means
> > > > of establishing a 'ratio' to do this calculation is fundamentally f=
lawed.
> > > >
> > > > So surely we ought to introduce a new sysfs tunable for this? Perha=
ps
> > > >
> > > > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_r=
atio
> > > >
> > > > Or something like this?
> > > >
> > > > It's already questionable that we are taking a value that is expres=
sed
> > > > essentially in terms of PTE entries per PMD and then use it implici=
tly to
> > > > determine the ratio for mTHP, but to then say 'oh but the default v=
alue is
> > > > known-broken' is just a blocker for the series in my opinion.
> > > >
> > > > This really has to be done a different way I think.
> > > >
> > > > Cheers, Lorenzo
> > >
> > > FWIW this was my version of the documentation patch:
> > > https://lore.kernel.org/all/20250211111326.14295-18-dev.jain@arm.com/
> > >
> > > The discussion about the creep problem started here:
> > > https://lore.kernel.org/all/7098654a-776d-413b-8aca-28f811620df7@arm.=
com/
> > >
> > > and the discussion continuing here:
> > > https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@redh=
at.com/
> > >
> > > ending with a summary I gave here:
> > > https://lore.kernel.org/all/8114d47b-b383-4d6e-ab65-a0e88b99c873@arm.=
com/
> > >
> > > This should help you with the context.
> > >
> > >
> >
> > Thanks and I"ll have a look, but this series is unmergeable with a brok=
en
> > default in
> > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_ratio
> > sorry.
> >
> > We need to have a new tunable as far as I can tell. I also find the use=
 of
> > this PMD-specific value as an arbitrary way of expressing a ratio prett=
y
> > gross.
> The first thing that comes to mind is that we can pin max_ptes_none to
> 255 if it exceeds 255. It's worth noting that the issue occurs only
> for adjacently enabled mTHP sizes.
>
> ie)
> if order!=3DHPAGE_PMD_ORDER && khugepaged_max_ptes_none > 255
>       temp_max_ptes_none =3D 255;
Oh and my second point, introducing a new tunable to control mTHP
collapse may become exceedingly complex from a tuning and code
management standpoint.
> >
> > Thanks, Lorenzo
> >


