Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F018FD116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 12:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8536B002E; Fri, 28 Nov 2025 07:52:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28F0D6B002F; Fri, 28 Nov 2025 07:52:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178F96B0030; Fri, 28 Nov 2025 07:52:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06E176B002E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:52:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0E511A053C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:52:24 +0000 (UTC)
X-FDA: 84160004208.03.12002B8
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC03B180009
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:52:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPjKIQmZ;
	spf=pass (imf16.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764334343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IaJqHHvEOEOyHC+8The6Gg0uY2rUdA1lvq9vEry25rg=;
	b=vfg0CR0/7pKy9rTkBxb32oGjsZyadKjflPgmC4yZvKxx3WYjXcDZZhkff2OEL7eRXQMpUR
	3pQQ1GUaDbapLdjVOczokglwaGzoSViC7vn0dcDDTvSX7uLSJeUWarnjqrfEptRqm+N+aC
	GOMgAZMcDIw3EsNNsX028rlA+6jcr+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764334343; a=rsa-sha256;
	cv=none;
	b=haUfKELlC8i8ShZPU9PUWEuZ4R7UMHOgj+21gupuo5ZqF7k8A5lyxjVImtHvU0IdEXJrWj
	L/2Jvahi0uvmCEPygytrVOtpTYl7ajtF2w3IIOJ56tQjHbQJsX+qyMqtKGO1yWFMcQUKL5
	06Rr92IZ82zqdhrt2mEqlXxOfPunTNY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPjKIQmZ;
	spf=pass (imf16.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-789314f0920so15388397b3.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764334342; x=1764939142; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IaJqHHvEOEOyHC+8The6Gg0uY2rUdA1lvq9vEry25rg=;
        b=jPjKIQmZpfSrcMVAJMC+3v80D29iZAAZ2y3zo55fLsIQ0Bn7X0AVyV8nQGT01pxnOZ
         6j01QmmHviGltOL0SXq2DNgyNeTl+RglM3wk/FsQZ32QLKyxSPyxMou/S3cFvFRsJYvX
         y7n13sv3IswmtG3Z19bnPKAHw1didIx81mQDR1v7g6c5+QQ2n1egtwmN5a7jB3v5N/d7
         f6BVl+Fwm9PsEQiKrXDy9A9f2Ith5pftrP67ok6iqK45pbXPf7qLwVW9gqau1hbxa3zX
         HJ173aNbAVxRfNCuFEQiXsNo939qo/iHh3JY0jO5VpgqhppOUYwRukCCJVN36cLP2Yd/
         GFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764334342; x=1764939142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IaJqHHvEOEOyHC+8The6Gg0uY2rUdA1lvq9vEry25rg=;
        b=bbuEXPZ3kYGybGjaZZyOuBDr7C1pRQV9gwxjgq6cdnX4xRqydjv4MrZ/NLpe8RhEVX
         QUnHjdoIY/XhOQnPcb7VuxPV4m9xVWhsltSWOaCnvk9ArEUavQOFkZu4j1k7ERa6jvFH
         CMWURobfqPcCcVnUkADz9UEW16Q+Ml2nGkYk9AEHS5zWE5Ql9FmI7n3h+TVVoPDBW/SF
         CJC7C5+QXuDlirBa79WfUeHvxDymCBprwokQfInnu0Wp5O7X/WW70ScRey8ozxumkOkz
         CnLFEwOYom6Tp+jesn/zAPvY6I10aYB7UZ7GE45Wf++r/4fLypwnc48XvY3uuaw+iEOM
         /xeA==
X-Forwarded-Encrypted: i=1; AJvYcCVgW/BDbRzybDA2BKx0ANo0zLh7Ga17tZ+o/z/iED//1Iin6AQq1tPJFWkqFJvFcI8A8LwW7vWM6Q==@kvack.org
X-Gm-Message-State: AOJu0Yy6zqwxjnoQ2wpcC4fGeQ68LT1AmtPMBjm9YdwgniN4LSWCCVXt
	7WG+2QnDqxxyVmc4IxYsmCSQjStzxuG/+iRSmHHCAlbVUCdpvaYCV5FRAgteSS3EYBt1LSWA4gT
	IF1cpl/pQ17yBWEPhvZ/N9xW/SQ7Vcfc=
X-Gm-Gg: ASbGncuemS304kty+6hwHktLH/Z+E0/9gce8YmzyRbXR98i8gDprjlOrr2Fcw5TtfES
	Dey8yEXUKQ3hqwNYLpj8TaMYJcqBLbX/CzhqiSubduK1/nKa2pl2kAKUl6GZcJe3vcN63J7EeqN
	Ksoi3WhawwpksQJ2X6LB9Oz54ZBLmdU6XLVMlNasPYPpQ4NOHR5sBAYz5QobbPsh7aUKwypB9tT
	aV56WZKWVuODLOmVyycOjXjUnXhxR5z/raEvAlvNAvMBLaC/3bV/Ycxe+KT+5h4lQ13WhyECyMa
	ZrJwxvs=
X-Google-Smtp-Source: AGHT+IHFAwArfULn0f8hVfIIvR+szkl4hyE5JvWr5ut7aQy5zexLaRsPQvxenCpRtcJtHN+Xt1JIW24w2z0pfxej6TA=
X-Received: by 2002:a05:690c:708c:b0:786:4ed4:24f0 with SMTP id
 00721157ae682-78ab6db1675mr119567317b3.5.1764334341850; Fri, 28 Nov 2025
 04:52:21 -0800 (PST)
MIME-Version: 1.0
References: <20251026100159.6103-7-laoar.shao@gmail.com> <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
 <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
 <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
 <9f73a5bd-32a0-4d5f-8a3f-7bff8232e408@kernel.org> <CALOAHbCR3Y=GCpX8S9CctONO=Emh4RvYAibHU=ZQyLP1s0MOVQ@mail.gmail.com>
 <48878c07-6e8c-47eb-bc8e-13366c06762a@lucifer.local> <CALOAHbBKxHDuGoND5xwxsScKY6aW8eiqE5QuHppd25RpYHf_pQ@mail.gmail.com>
 <f60522c2-e10f-45b1-9501-9b1e4223d8ce@lucifer.local> <CALOAHbCVGX3C6mbbH+e5bB2=Cnz-UVbEVBXZWP3fvhqGe9LSXg@mail.gmail.com>
 <600a793c-4000-444b-bb5c-2023f7198903@lucifer.local>
In-Reply-To: <600a793c-4000-444b-bb5c-2023f7198903@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 28 Nov 2025 20:51:45 +0800
X-Gm-Features: AWmQ_bmzNdWxaf5edAf5hNm2J7xYf3uPCO4yxzK9O_LWX4sRpZLLAEg74C_5rno
Message-ID: <CALOAHbDYiiv2HaTayGzCB=D_kwLPeV=xUcr_fHJckopF_pMQuw@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC03B180009
X-Stat-Signature: m5d5jdfsemwzci95kmgiscc5abedeids
X-Rspam-User: 
X-HE-Tag: 1764334342-484329
X-HE-Meta: U2FsdGVkX1+Bl6N/HjqCfD4H3gb5ETeWdaabSYtZGQc44lwd9S18MqeK1lt8eOwb7gmBFVdSwevDZkjkm33I+YjG77QGEjyRbMJVqH1MEwcJdT84l/G23DiKHbv1WMYz7jheel0dDXOEmTDVUkPDmbYIIDVJdT9Ji65iw9Py41tp+s/tiW5zROcnGP6ixiwVc1lZIoXfvpeE+VTdgTMwffGXXhF22U7JDDXSOaCVHTLQawop9l7g1q7XyTqYYNkpXm1PYDxCmU/VfqVai7uOrIya7YL66fXkt9BuPd1/LE7kwZiE2A7NL85PoohNnVm1DY99JM6ZGBInS9zS85gRvvTzQnyPBTtLTNiw+3BVWOkjDHYYl99cGbgBhsgR13Y3kEvNUhUKrCBQgYgmVVK8kZmm6G4geZiZKE2MMcG4c4EQhjbLHRnTlIoA68tE43oQx8yzgQ+9qjYgJVrVxvJs6/TTqPCsbr3u5ct2dT9z44VK0FoGpY0mt3uuHZMdtHYEg3VV7TZzeE/ITOk49keGXWqRqfa1ziRC9QKF6N+SzQY58tBf7legkI4sNo16Lz8ImePOLzWMdyZte0H0KiYIu9f+Vc3dDB1y4Riticz5rf8s9TWWF1I3xzfXGDo9IiwaO7rxzX7Chim+SeYm7+NQFDUiNJJmtEwOHrcEG35p2WZaBl1YRNkbI4zqXU51rFtckhApgmXubJUVyGpS5LrdRwTe9+zYFer9/Ns1VhGCqb07VisQQ1aYXGBFdLwfVJ8uwQhhBir3E3RGZsvrQKf31RVL1cQq4snmM8zfpsW2B+gLFgR+C6xwCJEIz1zc6pjTOWKQv54mxDJN5mYg5s6mwi4yABb9XEUC+W7g6iwkSASIfaIpoEVq22/zQckuoY83FlFu1BjEOgLlSNRsiLCa3Up7TMJ+gVrQ2g/b4hVehqujEvQaFrVQJgNwvNbWRRCEJAUiXobgFAucx2WIMIi
 lrGx4IDb
 698fr6eKkveg/KptqUlR0ntdGTKqcNM5LePXo+G6uKa+/2wffAYk5qd/x6WyJao/slCGl9sushkGFW8LqgzENV6v9CFDiyFZZ2rxIH63MBsNYTUu5X4p5IOhKb1uoZXDHQVgq2II38HSQmK28n7t9TwndbRK05PPFC5tb9YLZvDsRd0ABL114NuAoEAtDe3hjIxp8GEqawdzd1M3yhScZO/QwaZOF6av/2M9DU55mINnBSqQuar9PtyaDyIhCTyPk8afoc9TaheVHPPdMnzAMnNbx3LcAs+dr7v7HUfpDiD6TLL6GjUkFGyqGJ9EnaKDVmFvXLACX6f1us8cojVoGiCvQFZUpZNRaD/glV8rpIj2p511k6oBICseVm60X6hX4Mzbd3q2P+LAvoRAq7kJTioupeIkDQmfR5SatCQoyQaYMq3uV9HY0ja+2AOg7J5mAtXyC+GYWbeI3mXZlo5P4WJt+v8VKJNpJLPVLoWiu8kFC4mXbuirdQYjcmO2GNd7fwDMao8u+EkveO23Vr4wmcx2KU5LskRFdW4TJUAAUO2wsNt5Lsa0K3iUAB8OYw5aBjvn4vpHIbcatJkEIqXMc4SCbDgbp9c9N6yGqHbbCHtE0Zb0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 8:18=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Nov 28, 2025 at 07:56:48PM +0800, Yafang Shao wrote:
> > The CONFIG_EXPERIMENTAL_PLEASE_DO_NOT_RELY_ON_THIS flag was changed in =
v9:
> >
> >   https://lore.kernel.org/linux-mm/20250930055826.9810-1-laoar.shao@gma=
il.com/
> >
> > The change was suggested by Randy and Usama:
> >
> >   https://lwn.net/ml/all/a5015724-a799-4151-bcc4-000c2c5c7178@infradead=
.org/
> >
> > At that time, you were on holiday, so you may have missed this update.
> >
>
> It's moot because this series isn't upstreamable, but... :)
>
> To risk sounding grumpy, in future do please make sure to check about cha=
nges
> that contradict things maintainers _explicitly_ ask you to do.
>
> You can always off-list mail if people take time to come back to review.

Thanks for your suggestion :-)

--=20
Regards
Yafang

