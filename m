Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95318CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE2F6B01FC; Tue, 26 Aug 2025 08:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5FF6B01FF; Tue, 26 Aug 2025 08:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12C16B0200; Tue, 26 Aug 2025 08:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFBBE6B01FC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:11:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DEE2139052
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:11:23 +0000 (UTC)
X-FDA: 83818793646.23.6EEC995
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6AF1480008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:11:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CUD/Hvox";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756210281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImL/pg0xdjCGRWENhybt6xqpo1ixfGJNV4xBI1zktCQ=;
	b=7TGYq97EXEAi2K/RlNQathx8MMkVtOVcF7L+mPCArSCKqjUyrw1U5iLBvWEJYxChse7vK6
	LDToif9x7yzKWJH8fDrykuRQ/dXa8iQbO4TmKhIZ1EqgkXUgZD2pPMrXTFqwBKEvW5088w
	nZ3LdMQbwAnfj24/eJ2QbwyFNZc1NUM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CUD/Hvox";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756210281; a=rsa-sha256;
	cv=none;
	b=FuIItm5Ee6+peYnUiO+8KBNF9N+ltJNmKq+vv8vfXjOiWO1wwWaWsbp/WJwDCDPwIGCB+V
	0U562fRsR914oMvQodstGGolSt3EsTROcCuMavYyjSMcymJd/1B1G/m9HIRcShhEULDK5A
	HVrJAUs/u8QDlKhKpXtJP/S/53xugZw=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-70d93f57924so58260906d6.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756210280; x=1756815080; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ImL/pg0xdjCGRWENhybt6xqpo1ixfGJNV4xBI1zktCQ=;
        b=CUD/Hvox0vAPpj8wF6cxK0NPAAM2f111ECzAR/nvOFZaVIBZlIOc01unxNOwdZMcT2
         QfJ+WyhXKaRWZSAJjuznWs19dyF0PNQ//76ZsAHMK5xBHMVKFd2JCuJ12jvccNUZKxas
         Cer/iRD4dU9dEhiL6MVtl/D44BlhitTAzK7oB983RqlSdA1rvKfKCB4yUykPJByoo+kM
         yw7i29AXLTo74oA3tRpAjNVPYv492BfDwfL3NWUhjWjrcdEFjE62QxZ2KVD3H5Ch+m10
         nVwT/Hs/u6MChR/KIk7ugSvt8GtLNjHh04AhfTKlaOAcHnd40MgGQJABMRYuJ457rhiz
         mvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756210280; x=1756815080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ImL/pg0xdjCGRWENhybt6xqpo1ixfGJNV4xBI1zktCQ=;
        b=bdzM9ydO2t73neaORemZ9uAX5IuBDYmmmIQx8fUOgsEZ1rVwkyuxB3PD/g9pn3qRIp
         hZKxfQ5Py/WMzjUMWan9x9p6MFLOpxINdq+JNAKCR29Uo13SLfZMOO7c7KupSLtB2Q7W
         awppDizJNdoTqyAUQarK/loKP96lIMXR7c2bpXxkfiDpSvfEmM07sMEolArnAQLS1Eco
         tYWLZvd719dswodj/EY+qryuFdy8ZTOoA7PNNwpKuqATFJLoINjtgtvPN83rniZU4RuP
         u/t0FNDXBeo5LJ17PpgIpNgFEB2H8ENLY0Mu/ovH0tZ3eM8O2DEN9/fb4J4rIxQxLOme
         gbug==
X-Forwarded-Encrypted: i=1; AJvYcCW9RokYFC/KXIZPYO85YqlJ3bBzpPQgDtPK3UDSik5k1boRvfoK9Z0wD5TEEQLmTzeMI70S1JAhJA==@kvack.org
X-Gm-Message-State: AOJu0YwJIS1GRgotab3vwoZXUvykz7qHGVGhBE/X/wQRvip4SuR1XUfN
	aXsUMpfS2OEvzoj1uG7I4+dnsIYAbMVsw4fRd0Y4FqnSZZ9HZE0CiIIRhGXkyS1c2Yn9q/Xpewc
	3lQmmPYABq/mu2sG3gRe5ES/6ZTfqutc=
X-Gm-Gg: ASbGncsSLx+SQAW+svthn43cAPTgWNvKNfnL0r/AsfRmmQyYVDwUhpecI2nXZa8VDre
	1s/8nnuOkWPkdmDoQawprnpGF0+JM8n99VwV5rorbZ3rJ9uc2+z9hQmZLD+Ykjuv5HXTWeYPfD2
	BfgkVXPIEbcZ7UnBW3F2Xd5SDjlSCurpl9FdJeuDY8YvEUqoVqqDD5XLtCa4gD3tcgLIYzz8JP6
	PZmLtq+ZkeMJbaFTn7qMQEuOyo318qiUBnTcRtF
X-Google-Smtp-Source: AGHT+IEJAG2qKNzxlah6l/w2L3/KsxC8SauReCHdhKHjO7bLzRLIuTYZp5EjbFuJL94qP6L3iBxwYtkrnQTe9YDl6e8=
X-Received: by 2002:ad4:4f09:0:b0:70d:9b08:8df4 with SMTP id
 6a1803df08f44-70d9b089047mr125928626d6.67.1756210280301; Tue, 26 Aug 2025
 05:11:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <d8f723c4-4cb0-431d-9df2-ba4ec74c7b43@redhat.com>
 <ed4fc853-97ce-47b3-be80-4de9627c3276@gmail.com>
In-Reply-To: <ed4fc853-97ce-47b3-be80-4de9627c3276@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 26 Aug 2025 20:10:43 +0800
X-Gm-Features: Ac12FXzZZhivnVJyBOI8iejkd_haUHtgHc6xuPfqezPTB1X-J44KnLBSJW6VTiM
Message-ID: <CALOAHbB=b4wCT9WFOyRUgWo08=tBvnMQrBWrfAKM0mgJxEB2og@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 00/10] mm, bpf: BPF based THP order selection
To: Usama Arif <usamaarif642@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6AF1480008
X-Stat-Signature: tjrs77qr8psep7w6hoonq8krk31ysnuj
X-Rspam-User: 
X-HE-Tag: 1756210281-987881
X-HE-Meta: U2FsdGVkX1+NqPe2YlTm2zdWEFmQ6FAGQF25dZQvcVI1OvWzBHnEtmUrBwwItp5TCnaKo2BMb7oc7rEZoN+Ev7hJEaIWJcLRCQ9jYHXPur0scPwS+zyQ4hoNWquGWl25Q2uPicO62pfpvpxG4xFbE3sIFLjJ92uo1u0/PjVFe4GW88PB7Jjyrk+Gq2nYTu2TIMQoaX13gd07GxiFyCEYNlqg3M1ClAWoiIUrikcIS6e5xys1AL2N7IBtZjKf00tgltp7covOok+5uCSIYk2Bn4UrK37POHyN78YHuOsKEbz5xf26jSeZuYo9JzyzFL44idPGmCpOeFMBXPpV2C5UP1SnCTxSceQAT91phnY+Ma6kDIzBxzLoXmdQ/8uQki3ruMW6ftOHflbyaCrh61icIdeE9q8LNLPncMJlE1GkEeMEipGdmYru1BvjqCD0YC8TiREPlwM9DDq4uVBYvAdJ+5ttfrjS6CyEsRxh6aP1YInwePnNPqmuAN+3BJTM5JFV4Mdz0u0x3CRxr1s3uShPRbLqAJsmHbRyAcNmYzwbK8sndOmfcP8NA5Fo0W/SbDyTlIohjjDiwRq69bp+Em8i7d6si3tALyDTMMHLnGHCmTa9Iyk8ZsD6HBBtpltgVEmUviSUI3LjRVap0gKtnXfaoBWfQjsZ1XpnuIVQipIlFBIrKtoGZiRq9a9Nt6BK2HYKMWAHbHRwFw2IQJYiyrLTXMF2Au5pMWR281YVYg+r+oe5S6X3e48L83O2+B1MoP81EnotcZt6S3E/E2cwZnDYG5sYTXtGdregqU1Zr0hmDoOMPHLF1vIyrOcHqy06FDQxJ3fVDyK5+Ds+wzbTBEWQb+uBWxv968k/ta9IJAZ1wQrltTKBAwkKH0XGwZOPiHSKbnIv0wdRDLlwmpgyR+DToaE2Fa0DXWYucW/r70cQUC5a03UZWQD/8Iv8ygDgsrChJICyyFkvqB2VBH/9s6X
 UefAck+n
 JfsN34lyQ6s7j+JTOVGvJDvvqsfj9TJMete2xkaerdcqhJ2F7hPfdumV4vYJXkneuH3VYa/HiqHlzjrTIdtI+Jm2EV75Nu9Xe//dCI5+TYEN5mRyvk7eDpzibe9qkX7a6Ct3pPjGZB/LubTaBDzhnG/R3P12HyiUnmFejVIAeqDN9/OQGQ77eY/KqVBOWxFcZOPbDZMHr1aPdVSnVe74AkOjirmbn3zaI6Rcpf1hlwz/lvfHOGpE4okl+t45EDRVVJEno/+IezsB64bWjC9O+ezhC04dkhuG5FAx4szzskL3CnBFFH7nu3MYPIzSxRLuiBSN3mi8pONHvNSIk7evVTCqBbiLJmg5kBaYXNh/rgXVwvYebK80heIyz9/qYrGBICG1pJQFYQMPGsLFgZXsYREcaQLH8ErGxzuK4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 5:52=E2=80=AFPM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
>
>
> On 26/08/2025 08:42, David Hildenbrand wrote:
> > On 26.08.25 09:19, Yafang Shao wrote:
> >> Background
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> Our production servers consistently configure THP to "never" due to
> >> historical incidents caused by its behavior. Key issues include:
> >> - Increased Memory Consumption
> >>    THP significantly raises overall memory usage, reducing available m=
emory
> >>    for workloads.
> >>
> >> - Latency Spikes
> >>    Random latency spikes occur due to frequent memory compaction trigg=
ered
> >>    by THP.
> >>
> >> - Lack of Fine-Grained Control
> >>    THP tuning is globally configured, making it unsuitable for contain=
erized
> >>    environments. When multiple workloads share a host, enabling THP wi=
thout
> >>    per-workload control leads to unpredictable behavior.
> >>
> >> Due to these issues, administrators avoid switching to madvise or alwa=
ys
> >> modes=E2=80=94unless per-workload THP control is implemented.
> >>
> >> To address this, we propose BPF-based THP policy for flexible adjustme=
nt.
> >> Additionally, as David mentioned [0], this mechanism can also serve as=
 a
> >> policy prototyping tool (test policies via BPF before upstreaming them=
).
> >
> > There is a lot going on and most reviewers (including me) are fairly bu=
sy right now, so getting more detailed review could take a while.
> >
> > This topic sounds like a good candidate for the bi-weekly MM alignment =
session.
> >
> > Would you be interested in presenting the current bpf interface, how to=
 use it,  drawbacks, todos, ... in that forum?
> >
>
> Could I get an invite please? Thanks!

IIUC, a Google Meet link will be shared publicly on the upstream
mailing list, allowing any interested developers to join. If the
session is invite-only instead, I will make sure you receive an
invitation, given the significant help you've already provided for
this series.

--=20
Regards
Yafang

