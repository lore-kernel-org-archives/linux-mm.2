Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9785AFD375C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18B06B0089; Wed, 25 Feb 2026 13:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6196B008A; Wed, 25 Feb 2026 13:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02876B008C; Wed, 25 Feb 2026 13:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A67F76B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:52:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48BC3160729
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:52:10 +0000 (UTC)
X-FDA: 84483874020.28.1E0E8A4
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id ED07B18000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:52:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0cIW2rf2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772045528; a=rsa-sha256;
	cv=pass;
	b=MOrufzN/WhQZ/uCC6QC7rF1lMv3oN8HvKLrvjf7FEb0Dgpqf31nXM5UZHLue50qhoBNgin
	aCRo/965n7oxBxMklRzsxQ31co+o1OyTF5h5ak5vuYsNpLIh+H7r8IVDG4RCHO/beuYMvD
	OhGgwTNDaGL4rz0xfWYBlW/nud4j4A8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0cIW2rf2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772045528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iVOkZnDaZKnxDwCxXuTasKFYGrTM4oqL6UDmqmgzC0=;
	b=Dg8ACBnNpu/lV6sVPaDnonbICAF1oehGiNcxdyZMwt3BHsU9eNXM/SNDLbYyRd7Qr8TWtU
	yW9is3prDkeppvACcX+4Rk9OR+OYSJ7U/Msa8OYKHT3HWygyMfPkgxtB8r0KhK8dAbKcmM
	3ukmN4mFhfWT0wuBMm55L5yoIQSYHOA=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so1179866b.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:52:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772045526; cv=none;
        d=google.com; s=arc-20240605;
        b=hrbnfsaFO62THcMHqGjykKIwWyJXUL/L7J9KFh1PnHKKar7HQ0fMOPaeGoVuWxp4tT
         hg2TNtoTAgJ7bb7k/IPg3ozGaU3NIDy42ZuV1OXAmvyM1Z8K3ymMZRFAXP4SXG72mNoH
         1brQiM2qXATHkuEpcK3KhdTW7I26fxXLyHARX8++M1RIEU8WUb6wnNCrAonqwZGaVKi4
         +rsblHwEP6Zf+u9Mc5JTQpCLRvM/ScX9m4Cb+GmUP5a6SUIeHPq0t7hs/yZXDZrBTJew
         TsDBGrSNSnx7OSyxKDt2fuO1V7mXA/sFeHVuHRVNCEvzl4frUt/af1BHjRpVYO/ZUce7
         r/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4iVOkZnDaZKnxDwCxXuTasKFYGrTM4oqL6UDmqmgzC0=;
        fh=7GV3mAs5zTFDPoytnIYo7Q8uBfGZBDC0Ux/SvkWoJ/w=;
        b=En5JGZZEviXPK2QGdAOElmQ24YSskXbKdceuG0lWd0qf3XhTSV3cBUCdV9PLaRDqcg
         yJtJaVniB+hZGqKytUA5pzW2DoD4aOJF2vcx2I0XkWZDy4xWN19smjbDWwslbE1QT+Hv
         hktOrXG9U4McZjF+sPGr3UG3OmZBnEe6esiLIsuBTDnEnSslIkiz8c7l2TeIl6rZjlAK
         CUVsbZC5m0lLu9JvXUC3knkC2LnP9BERLNYNtrk0dKhhmZoBBWoXjUYW9RG6MFfPoRJx
         PfRgAPDecfaYgQpUFh3sjo6QUzCKGBeXhAgDWTrZoci10bdkKag5zt8S1ufUIlbZ/Q5A
         meng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772045526; x=1772650326; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4iVOkZnDaZKnxDwCxXuTasKFYGrTM4oqL6UDmqmgzC0=;
        b=0cIW2rf24OS/u8LCNMPvsR828YiAfgzcDXZhZRbto2OqcgfcjfuItOj4PytnH0NHlY
         v9RIdvdi2L4cXuKA62TS+hP9fT2qqcQaw8tsZswrGginOPKcP3uHOACFo3SCPJjb50M0
         eRTBmDk+VYwtk764uu4Sjbc92AolT+AL9OZoVoaiAv85MYf0+ERH63uhvC+Lk6HpJmjd
         3GU9A2H88rlHUaXDsYgWhmppQc3xqyNG5IVBuW8NhFbAZRgHYxqE/SiwfLefytU7JIpW
         1nOH5LpVgpNWwfHpZo/TnWHmNiZHmyhEXnu+FTFoaazizc7FBXDvsPnp9mU9W6A0qYbG
         Xj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772045526; x=1772650326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4iVOkZnDaZKnxDwCxXuTasKFYGrTM4oqL6UDmqmgzC0=;
        b=mQ2ZiCfImCP5v75x8SrBKW4Q7uPm1XgZ0X/wGoHcuM0Ir5e2tor2kgTyiahe1TLHlt
         cmrAOBA6pxTUo0YiS0/WNDxMgWg+CyXxuQr65txYWhz3gIzlz4Gt6KWkONYFLyIZr6/9
         wD6Gvp21qYSStJARJtgSAfgnW/ZIU1t5JXMbXFCktyndb4lpc65rDqDmgXXi6Hn4HNNN
         zuyJ9pinNVw6vWYlm/F2lM0Op5rsx/L3kGmpnLcEQ1cf7sBAH/ACUxd3CRcjUpB4HnSG
         Un9ao0RnKgQm0gU9v9Bvgc647JqTJWbzTgozlcCD7d+EgEizlMkPau6bfV7jgZY0yT5C
         JfFw==
X-Forwarded-Encrypted: i=1; AJvYcCWShC+Qohjr4OSwRkIoMsJpKZSfjsY444wqFryH1GNDPvG/I/27xo4pm3lpRtyC1Gd3JTpNqw4Hzw==@kvack.org
X-Gm-Message-State: AOJu0YwpgmRAm2srTwcmRXMV5qXRe4dyq1u44Nr3aRdP0WFP1bqmh+Ku
	CQa8bGlLi2BBoJDUQGoFuVikxuQnoUb4Ia2QG11Fzb8GaaGToyvWA0wEELb97h0yqLpPnhj9d14
	Z94anJGoO3mESiajRQ+iNfra+9oFVDrKnL7Nuwtrk
X-Gm-Gg: ATEYQzwCgBBXB/g5jrmZroM9BfBv+U0ta/oYNOICg0CECrAxJzDTsH4ERNBTtNVAd3V
	BA2O2vIX9pS7MoZ5j0RXRyzKwBEBuK4Sq9JsF8c9cUVgqfZgfiMyr8ZQmwb34865ZhsT2sGBwJs
	f+M/Gi47L4jKIheaubIUchleXtr5Mdma+bksOQak1VNpuNSsosgSlrDYEk0TEpk8O2gOPI2Q7vX
	ZgBA032aD30DznO3KcAOOGxCS0A4XNQFmw33+iY7EWBzcPncakplqd3vM4l61y7hXymppAeVamy
	qD2Gxt7Tj7jMgzR+6jX65U85MF+43FEW06QLm5Zh7MVciFhOkVv9nglL8LPEMJuvm5qb/g==
X-Received: by 2002:a17:907:9345:b0:b87:1be6:c707 with SMTP id
 a640c23a62f3a-b90819d9848mr1250245566b.17.1772045526051; Wed, 25 Feb 2026
 10:52:06 -0800 (PST)
MIME-Version: 1.0
References: <cover.1770854662.git.ackerleytng@google.com> <18dbaf2ff9579b285d92f26b9a69e1e302f3bbcc.1770854662.git.ackerleytng@google.com>
In-Reply-To: <18dbaf2ff9579b285d92f26b9a69e1e302f3bbcc.1770854662.git.ackerleytng@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 25 Feb 2026 10:51:29 -0800
X-Gm-Features: AaiRm50XxXWOX9aUqCLJd9hStNskLlQ1-JFNXvuIWR8a-npd0KRSIcBGQr5XjmY
Message-ID: <CADrL8HWf4UN=eOi0HV7APRXR9Z_YFMrw703ocW57wPNjGRRh9Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/7] mm: hugetlb: Move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
To: Ackerley Tng <ackerleytng@google.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	kalyazin@amazon.com, mhocko@kernel.org, michael.roth@amd.com, 
	muchun.song@linux.dev, osalvador@suse.de, pasha.tatashin@soleen.com, 
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
	seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
	vannapurve@google.com, yan.y.zhao@intel.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED07B18000A
X-Stat-Signature: bf1hgpcmqzzcy1spfri57z7hjn3c1dh5
X-HE-Tag: 1772045527-351777
X-HE-Meta: U2FsdGVkX1+ihRPezl91wolWZ6NOlKofxiNnPl6o/b29PXRZv1cw/gbd8iYK0dPGayA0u86SpQU5NGVozQAswNBB3uaBP5Xcd6jrzULkx3t0mZr4tUkQ32/oxmZonBPDid6cAyLvVmgfzmvmeRm7970B4Ca9pLPmi8tH128N4P2uzuOxRnc6Ls4qxntdu9xBZ4kKZN/W27hsHlCH7xdOZb8zBoNlQnmLR2ySipHm179Hdy34bd/OFFVSGVMrDAO4rzwRoCkHJCubKCNem4DNMWGXiCADrdWfN/X5gBiMo09CdAu3Y6G2wH72Jjtb1+DWU3ZCEv1C/AaukalAald92giUgo1ELjFSfCZb6YNKAp/fZkH5F1c8z04iHcQbaHYA8pbgq6Xvmpr0PUFkSxqOKqMqbEcsXanGyBCC7Dd/pCKFcMA7XSQljffLomGXcztEpWzQ/W/Oy3XBPwzZ69yft/S3RL8vAPZ0OsW4FsYxuXlQvS6DepBiU5XFu5Hmf6qcr3kEm9mOxydNU9R9cgCkU/xF+bl27gEYBtfn4s1/is5bhh3XfExEUC8Okn0OocAYhd6YDPPZCnlt3C3XNN236hb8/GfD716Ou1GY9Ggflmfcqxd2gZrZktsJQgQ5ujijIvijnU4HCz2dfQLZocx/7iGPFkPiy/zdkN1pfqkNaKg7wuR8hEx1vlkfGhGI3TYEEXntp9pSlNe2fnEADWbl8UakZsAn+iv9ghHdJeYuLioh3vukmSIvJqBuZzrWK9PiUhWv9nAE9lqqT41A5U2l4S8QLGU9iUf0VnbboEZ4/j+r2v/ZPI0RdyQ3gEOHRndTCTtO0JhpQHg/e3tObUVEukk+SOwI8FvVieJjFAzPge2gr0zAMheun+CHG/44lFZrGaz5X/RtTs6RUoAJlZoJLaLzEnvlshJE7AGqgs1pLoDNO5Ru66sxbsWSgSWZX81Kf0F/egKPkuCD38yFIMU
 4WY+cC4o
 6xxaSMog6BD8EftDl6/YOAuNMniV7Faf0hZy82lEJewCn3wOVFFWq4upEC2ic9BzquJGHIRNY8MmdB1ic476qgi/O81Ecr43bbnjvNKMgjR/KKIzRV0PAR7aPy9J5cYzHrC8OqBR18AuZJfoV93xVqeq+SJWct3mQ3rpiqji9MmpRVvYKaNEfkOw+aIPbMYa3PKKo8L2eFsqZHr845m+E+V+hqy+F91mRAtkieMgfdtUsfqfA0cNzK3SrLxDVXxcPvN1afp3fdp5KmlIYALH/MtPxjlK7eAwzdwNczSMy3WdAe62yZMDnU0E5xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 4:37=E2=80=AFPM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> Move memory policy interpretation out of
> alloc_buddy_hugetlb_folio_with_mpol() and into alloc_hugetlb_folio() to
> separate reading and interpretation of memory policy from actual
> allocation.
>
> This will later allow memory policy to be interpreted outside of the
> process of allocating a hugetlb folio entirely. This opens doors for othe=
r
> callers of the HugeTLB folio allocation function, such as guest_memfd,
> where memory may not always be mapped and hence may not have an associate=
d
> vma.
>
> No functional change intended.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: James Houghton <jthoughton@google.com>

