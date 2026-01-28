Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8068DD3F098
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 16:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8582E6B0005; Wed, 28 Jan 2026 11:59:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806426B0089; Wed, 28 Jan 2026 11:59:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E74F6B008A; Wed, 28 Jan 2026 11:59:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6546B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:59:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEBD48C332
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:59:48 +0000 (UTC)
X-FDA: 84381984456.09.943025D
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id E1CC940016
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:59:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FA+C9S+R;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769619587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8ynwnXKpz0vw5o5hNyIwOQqePswhwikzffZ1I9kkgk=;
	b=XVFY2cRgPs0yKwfc7AXh4pJoQc59stAmVHgEK4eYk/JI4ddCctfaz8hgzwTpvox31KG/Sf
	jv5mjAGohJUtoLHvdqgsBZgT/XKjwwJ+sqtcUCeTfdIHxJGiJ2CzCqJXW/k7DEYp5LrUQ+
	Yuhd6Qoro/lbcBu1GJEl2jL2WO79OuA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FA+C9S+R;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769619587; a=rsa-sha256;
	cv=pass;
	b=Abm3PgaNlgT7mkQStSRRmhHnNB4nB2cPU5CeD2zr+70vPwYGbr+5TGoP2NzCgMDsWIfxep
	8pDqfm9RcDhkXX27JhkM8Eyh6PSlo6Eepth+xarH+5YV9om9By4rYwROACadShyDmoyAlq
	OmlDqfIbwgOT56gVb8HLLVD6qSGNE+Y=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-432755545fcso71788f8f.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:59:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769619585; cv=none;
        d=google.com; s=arc-20240605;
        b=aajF3TOofvDFx6dIOCCzUBVomVavn6su1SCcB1edGXMvpUR7IF4teXSgtcT+SWHCmX
         3tCYGU4gvkg1A50upGRn7i9zOEGoP0QvU1jYZrA8Y8DBfO0VgGAf8BcIEA4A89yhndm9
         lWOwiqC6AcCNctYlWxgDqC53/2h+mmhFpeKy70d8PWn4Vg+w2WHauRP+1dxc3Dhao8Td
         hmCBwzPx/rISFHX3bP5xZwxO7EsNnkJw6cZJgNfDpFDCibMdzcOeRAilRu++hzgNCizn
         yJTJ+r4gfWqMsgkwz5WcFGBPIzJ61lw4EUAB3lC4GC17/DThBH6DE3G4oRCMUaSvFqL4
         cruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R8ynwnXKpz0vw5o5hNyIwOQqePswhwikzffZ1I9kkgk=;
        fh=vggSsu5tobUrHKIoUbi9c10D6j8bWrbH6BH2+F8UCQM=;
        b=eFs+IwIRFxReJxUOrCOw1WVNnyzeZS1/3ATbdKBl5xPLvu1h4QplCGE502rr2suiiL
         bsFdV6dL+EC3SEvJRaQTT3cB8jYtC9naa7NQBVW2Ojeo2yc5B6kUUv0OKZsa6k3bBAFQ
         hC5cuX5806RzMHtyxUg30vMBBlH7rEK8bZYBzU7ZFqsSsocMYePEECzIQVB8olKhxTuE
         YI9hZOb6O72s4WuCCiknCwoTeg2jQXmQyfw92GUHrnhOJKf7IdSAfeqOMKUL0UcUz7gm
         t500mfHVAMorx1IU6stKJ7TipVUhSk7l53UyUC6B/+wIbe57IcIn/P4qwo4PvgXsGXbv
         tqpg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769619585; x=1770224385; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R8ynwnXKpz0vw5o5hNyIwOQqePswhwikzffZ1I9kkgk=;
        b=FA+C9S+RBHctte9u5nO85FOfMCSlXTgI4TFl/KD8Hr3gVx42ZYIPUqAio6SN+MQan5
         XDZsDJGpOk9HJ5bFFBZmzq+Jfk/lXRTAqaw7/GDDbnPV8kpibjKZJAf2dvgo4ILah/m/
         VQV4+HQHfpUMme83akyXXRHsgVbtUggKDeCDRr1XsVRjnrFiuAC6YbJTkmaWai/Dyvun
         wkLHF3VIo9uYifwWtYw4526P3foWVjJzBPjwYI23lZa0tT0zey7GNB/UaxBu6iEdlfKv
         z5e0/oPSjUuP0zsqEuaiNPDT8869BL7AR56Mq0vOBlRQgJd4UM33JaGBXGjFcQyLU+EO
         O8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769619585; x=1770224385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R8ynwnXKpz0vw5o5hNyIwOQqePswhwikzffZ1I9kkgk=;
        b=jctCGJ+IGyHbVbo48VisHnvJrtGnj7jHfnZcz3m0hjKllhjkDiexuHD+wZT+Pz6ilm
         q0Ir1qYi+npuXgXpbb8nw38NF/W2lR2ZFrjnQzk4isZOGa5z4lmFza4lbEplRwAMlJRH
         o10Amp+POnx43haOHvYcAHtD/yjgkcv2MLiAMn2GdNaNqnYYjM0279v8cpjOeKuZ0hBP
         2jYoT46wTAFOejo0JGJ0Zg7fw4o18sbt9+eZenfIGHcmrYSdEGQYtGD4xtZjetmiXuTP
         etowHTiDRG10NiZNC10rTHBgaJgx1yi47/DdUfG4g+4qLyuWMnxDFBfacLGo70X+oQ2X
         yMFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfLo7kGZm/mNR3YbsHBY/XgGBC2hNZZCk0i3OGqn4K+t6dLiGpjSvnq1ulAdaes/YmompeeeXXzA==@kvack.org
X-Gm-Message-State: AOJu0YwHdv5HCoMAsV5lyAwoL6NisngtGZ3Z3R1u56LmHplm4p64tGxt
	nkDRZBpyEscclDjiGC+HYw6tZmj+neMlxKzKli2hghgSUJFIoYl1LbsddNdvtA3P1fV3JTKtuYy
	nNlpNjJmx/A3wgE6Y95Ln0Ie8TrSh0Do=
X-Gm-Gg: AZuq6aLSdcPiHY54XLWY/Ad4aKfcvQo/J0AYmVma15W5Q6mecs1/qvRxTYkQiEbuavG
	Yl9nPnK+kIajDOAYOrcSxqyKwBUzLiyDv8IaKto0h4gyt58zCWclNxKJ8lwZAo58muIOGdNJmYA
	Aw1TCRtAPk8pzcmtrdshmmMEKiWJJXqiRkKcsLWc3M+q1eN0tUx80WzV0MgnWnrzaysb3NGiBCR
	xrRPXmrbiX26p00xox6EMWCbxiEEjmooeDeZY5Spkfbqk6k47EG5uChjGqs/qQ9U91/242Gyakd
	tNg4DglOx4y6RkfU8E+mXtyo7oRtsbvEohBy+CYbLfT7Te6HFaIftUenK5topMlb3C0jZntDrlB
	Lb9eRhXfxJh9xbg==
X-Received: by 2002:a05:6000:613:b0:435:97f6:4f44 with SMTP id
 ffacd0b85a97d-435dd1d8cebmr9330589f8f.56.1769619585046; Wed, 28 Jan 2026
 08:59:45 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <aXh_LpTzDhvv20uB@tiehlicka> <7ia44io6kbwj.fsf@castle.c.googlers.com> <aXnDdkYmtipGwSjK@tiehlicka>
In-Reply-To: <aXnDdkYmtipGwSjK@tiehlicka>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 28 Jan 2026 08:59:34 -0800
X-Gm-Features: AZwV_QhfTbIzyHtilkrEQ2Z-0JECgEQt__ywu-4_XBgXY2AoFHuz3-NaKL7HAiE
Message-ID: <CAADnVQ+ghTc5FtJCjm4ya3y3xVpSuJe-7ctdT-thowqWguc1pA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/17] mm: BPF OOM
To: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E1CC940016
X-Stat-Signature: yop66gt6cohiuedzh4o56qph4noszqkj
X-Rspam-User: 
X-HE-Tag: 1769619586-454821
X-HE-Meta: U2FsdGVkX1+HAjivahPGItdlJ2FK+UAE4tonoI4cAS3jlhJrfFVv/Jl+HFK/r/pzg+JfXzPSXG1iVkTiaTzWRsKGg/o77dixwAAs2GRNjjT0Z70dL/hxFv95AuJLLtrihSKO8aWvFTsxL/QEaclCrwobD1RWkeK87Ol4RC7WopgLU1E3SjOyu9d78QkbxPu9X4TIvTgjqijbZFGBL5zmaBMBBh2Uw/GDhzvThwhWr1jnVOnL9wED8uqm1AWJvH5RQjiNbtyLOhVPXeMKsayf2Ykc7GFH/ozk71HLu1Jp7emtVlcVG/vWeQO8PZK/e2iDb/vs4GOm86xvv4eZeKBj2iYXW47ttIkPwG9Lg4PW00tFGLqs4GLlU8pH4YXSEwmf0Kmkeo3zsB5YZYZ9/RsdvS/i0s6+4K4U5v9J1j3EvtaPaiaShS+6PCGbuazLhjWhFotLRCjnF7Upd9qhUNg5GjG69nmaf/7jKHWP8WR2m+SHRjIpwuwRBRBj+/nTJBhiqZJmvBF2Nrs6MYK4vTs6/mzVmAVBTMTbFrCkaQA2eSP+e8Db4UfOcKWOBi9ultShFmF1ukKuEBxOqcHVTkBVtFPdhlnoGzIEAbHIXpwrj6NHVMXLlbGgz5k++9JpCoqtdWGq8cO41yhRs6RIvsC/czpsd1ggro2yG8zkYBccawRCJjDrcPMwlek1cmOCzZSYSnZFP4Z3t3iRWOY96bIiuqyyMxKVg6PXSaHyPlIpTJ6rqzkamEKNFFrHvC8nYm+exOG+MO7+xMffiEr5vZ3ZpHGG8I+I75PeO0El35RK+uzK/kvJS0lgh1h2qdvBQoCAVvW45s4kdS9jKA0q1cWwAw5/QAnOc0we+B3CNuci20aDsMf3wz0bX5Ytq31oqz2mgO9A+YdjAhQ8wElYt4L36WIPU6hZiLg15S3EKZ1h+zmrxprtwDNIvBQxHl8aBQ+jgmMNjytrvGGjYWjz4Ye
 w4dBBLVZ
 McWYid1LyvrUbBRYKRLltyHdjUTctrbWxgtIypnVswjht7qzEG4Z4l4auZwU0K55Q2r9nGYoda5gJ2Gn6y/lueEhi5/pWuL+TKCtcBhad4mjShA6+O/F5AVgcp9o8XgwriRXAo/scvVRaFEa28tlV5mvblEM8Hxy/ZH/RrGKffXuso7UWYM5CbvcOan327F/6P1yWHLI+pxXMoPDj/0wwVkKF9fIxaw5+HO5GO4mWbf/ao06myoXycaAkHOLZQT4ssFmEeoqhnNJyIa/tCGf7i0n+y2K15esi01/KBvjxM+/7dD/rZa1ssEug1UKpErcGMkTK1oqRsG5ROu2k6WMnFRUIjgZiM0dxxDU2qBCmWPWTZDyThAkWg/FbitIE1N5DQDoAMPNNG5+d51d1riU4/sHkbvDwwPDsdGW5TEnpQjAQzC0MBv9lbg/O3/SkhdDH+W7c3b6GS0S01sWDGS+ZG49zFTfbjdIZiR7dVCiSIdlg92Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 12:06=E2=80=AFAM Michal Hocko <mhocko@suse.com> wro=
te:
>
>
> > Another viable idea (also suggested by Andrew Morton) is to develop
> > a production ready memcg-aware OOM killer in BPF, put the source code
> > into the kernel tree and make it loadable by default (obviously under a
> > config option). Myself or one of my colleagues will try to explore it a
> > bit later: the tricky part is this by-default loading because there are
> > no existing precedents.
>
> It certainly makes sense to have trusted implementation of a commonly
> requested oom policy that we couldn't implement due to specific nature
> that doesn't really apply to many users. And have that in the tree. I am
> not thrilled about auto-loading because this could be easily done by a
> simple tooling.

Production ready bpf-oom program(s) must be part of this set.
We've seen enough attempts to add bpf st_ops in various parts of
the kernel without providing realistic bpf progs that will drive
those hooks. It's great to have flexibility and people need
to have a freedom to develop their own bpf-oom policy, but
the author of the patch set who's advocating for the new
bpf hooks must provide their real production progs and
share their real use case with the community.
It's not cool to hide it.
In that sense enabling auto-loading without requiring an end user
to install the toolchain and build bpf programs/rust/whatnot
is necessary too.
bpf-oom can be a self contained part of vmlinux binary.
We already have a mechanism to do that.
This way the end user doesn't need to be a bpf expert, doesn't need
to install clang, build the tools, etc.
They can just enable fancy new bpf-oom policy and see whether
it's helping their apps or not while knowing nothing about bpf.

