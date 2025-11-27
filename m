Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2371ACFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 08:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA5A6B0023; Thu, 27 Nov 2025 03:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B0F6B0024; Thu, 27 Nov 2025 03:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559376B0026; Thu, 27 Nov 2025 03:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40CF46B0023
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:51:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF871160A0B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:51:27 +0000 (UTC)
X-FDA: 84155768214.04.E7B7B38
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id E3039A0008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:51:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FH10daL6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764233486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlDmIt4icJ0MGcl8FRUaHm3th7RS/YZ+jPJUHQbVqU4=;
	b=6+eJSx4/jfLyV6R9uuh5VHW452Q3rIR3Ec0BRojx/pQaYXYDIStQevAUMMcHH8GF3a9RYc
	ySEciyboIYOvZT6q1adCfE8X4UzLFtS9ha8tV0nxz9W6sYHieNOYyI/6i55Ib1gTA7ZCye
	LlNyrIq3aFrF0+HQduVlRMnkIMHsem0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FH10daL6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764233486; a=rsa-sha256;
	cv=none;
	b=ASXxCY3i12BUcFBVeiLGi0h2FSb06Urv1QQqH1iLGZB4KpOq6/PNcq9c2b7+bYdmO2LTRm
	iFwFj2SeVHiwoiXi2INJZYo7rGFAGjqmRPW5Br1NF/KsQrqLLOOFG/aDdZKDIt1rY1MHif
	QX/YmV8RbJa4VfeUjlhu/g/LsJol3uk=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764233483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NlDmIt4icJ0MGcl8FRUaHm3th7RS/YZ+jPJUHQbVqU4=;
	b=FH10daL69qK9TUXgf95R7j/IKzB/Swn10cKC6bkagWW/imN++jq4KVBF+mqpINurX6UGGm
	twE/NgXtXzXEfHMQPGZlIzEP0wl7RCKwfm0QISOQpzIKIknjRyWt9wEdkgP5YLOxKaA5Gp
	gvpWSEXVOgTlMoPNFL+IjPp5KcG4wSg=
Date: Thu, 27 Nov 2025 08:51:18 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <412806a9d1ba8269376f9b227b960d52542f2453@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH 0/3] Memory Controller eBPF support
To: "Michal Hocko" <mhocko@suse.com>
Cc: "Roman Gushchin" <roman.gushchin@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko" <andrii@kernel.org>,
 "Martin KaFai Lau" <martin.lau@linux.dev>, "Eduard Zingerman"
 <eddyz87@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "John Fastabend" <john.fastabend@gmail.com>,
 "KP Singh" <kpsingh@kernel.org>, "Stanislav Fomichev" <sdf@fomichev.me>,
 "Hao Luo" <haoluo@google.com>, "Jiri Olsa" <jolsa@kernel.org>, "Shuah
 Khan" <shuah@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Nathan Chancellor"
 <nathan@kernel.org>, "Kees Cook" <kees@kernel.org>, "Tejun Heo"
 <tj@kernel.org>, "Jeff Xu" <jeffxu@chromium.org>, mkoutny@suse.com, "Jan
 Hendrik Farr" <kernel@jfarr.cc>, "Christian Brauner"
 <brauner@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Brian
 Gerst" <brgerst@gmail.com>, "Masahiro Yamada" <masahiroy@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <aSckUNAfVokeC_2F@tiehlicka>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <87ldk1mmk3.fsf@linux.dev>
 <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
 <aR9p8n3VzpNHdPFw@tiehlicka>
 <f5c4c443f8ba855d329a180a6816fc259eb8dfca@linux.dev>
 <aSWdSlhU3acQ9Rq1@tiehlicka>
 <6ff7dad904bcb27323ea21977e1160ebfa5e283d@linux.dev>
 <aSWnPfYXRYxCDXG3@tiehlicka>
 <87af0c7a8fc35cd96519a4e3f09d39918bdb7370@linux.dev>
 <aSckUNAfVokeC_2F@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E3039A0008
X-Rspamd-Server: rspam11
X-Stat-Signature: z5atw3atjyqa1en93exuyp1gokc8mmmp
X-HE-Tag: 1764233485-187829
X-HE-Meta: U2FsdGVkX18/LJumLxQnRqhi10zEpgZEsdL20UTqAxg46ckP07YzldHilh/TzaNL+8pV5CTdFO+7OSqpfsEFoXbFkisuZyvsCANtcfDzsAPz5meEcZnquDp4RC0S8HRTZ/BWoralK2ihSjSLIyCPMyfzNnmEzjPcizsA48y1Wz23aVrcgRxH1752Y8UFwYPDesrs5vlAXyIlMhjn7fMQcNcGBviWoLLOq3BpVbU1pUHJfWyLpucaJg0AsAEC+tkodY38NUcxcmwGnqGmyvgLtxes3eBk5dJys+dzFVP3cRI7svbYUcNz474TkjRFCH5C6RroEgpNa/xLkELdI/HYbQlvDA5ItII6e62nC6Yc/rPmaKEp2dqxouVCBSBiOME+64NEBA6EOevncA1DPDNnJOI2KSnDB7jQ1DggYSCU0OR4efVnIOt8eQ57DygxIxCNc9Jw0NYJjnVP4NeHAqVmPmuf/FGm34CPeYibLp6MNbsRLasPkFLViNWX/iK1QFty3igOlttXAkjPKyIBbZONsgZ43QQMIHuI1SqB3AHUIw/pEHo7ckjJEMDLDhfKxY5MyGXiROgQkunAm9v96PG6M/2JZ1tIdB81Herg16OX1i+Y+Ryd5fsW/mc9M9+uQE5VwUlEZtnmInPwHZRQ6UrehD63lFiIweevfaj8h8tgYVTwLVRRaouBDxi3vwQFXGrYiAlwTvg8DD6q4OJgF8VjrAdj4lVwSOPfj/1q79ag15HLPVr93fRuxRzD0ggCJbSFYiMcaa0Q23y1OFM06rTJr1JaIK/bsm+3n+61qQuUIU/AiEV97e1cL2RVxtVThrozQeZUDdhJvDbgwCzxVsQhbcMtkjuLs9uH1akkSAuLme7Lrrjo9k++fcQ1BeOrtSj3heUDfzYHs+vrZDE5rjN0+OVyBcsF76UqQGcy8Qjavkczu5jzoTlmEgHfXDX5JR+ltVs6tY3ap98aigLKvlS
 ul2nZpAD
 Zy/Is4XMR2OzT7zFGwX7+bEddNHtTKxeWnhRNrL0lJ+hlxdWRqo6Wknkvv35isQjXGU1lxz9LPWD50Kr6QfpaIxGpVOcXhQk3QD4pucbNK744CVdMJcjUlHAYMOKVNDRtVIqEm+jki3kL2qNX5SdKIwYBVJn09QilFuc4sP33BocZjm7E7CpaTMywMU6leLfC+D2+GJUDs/fyYCJesePCs29M2QgTRbsQ6PxeBewSI7gXPDbGWiIBSQ4tNQ/9RI0RBsRG5xoEzilKjld1oiHE6oPh4BUkzXK4Mw0ICuhSP0LZ9UcGTx9CmrTi1dmuo5WCzRdHBLlh68wthvz1jftXAc1DXZTk8eXHkpUrhZ+2YAI+6jg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B411=E6=9C=8827=E6=97=A5 00:01, "Michal Hocko" <mhocko@suse.co=
m mailto:mhocko@suse.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40suse.com=
%3E > =E5=86=99=E5=88=B0:


>=20
>=20On Wed 26-11-25 03:05:32, hui.zhu@linux.dev wrote:
>=20
>=20>=20
>=20> 2025=E5=B9=B411=E6=9C=8825=E6=97=A5 20:55, "Michal Hocko" <mhocko@s=
use.com mailto:mhocko@suse.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40su=
se.com%3E > =E5=86=99=E5=88=B0:
> >=20=20
>=20>=20=20
>=20>=20=20
>=20>  On Tue 25-11-25 12:39:11, hui.zhu@linux.dev wrote:
> >=20=20
>=20>  >=20
>=20>  > My goal is implement dynamic memory reclamation for memcgs witho=
ut limits,
> >  > triggered by specific conditions.
> >  >=20
>=20>  > For instance, with memcg A and memcg B both unlimited, when memc=
g A faces
> >  > high PSI pressure, ebpf control memcg B do some memory reclaim wor=
k when
> >  > it try charge.
> >  >=20
>=20>  Understood. Please also think whether this is already possible wit=
h
> >  existing interfaces and if not what are roadblocks in that direction=
.
> >=20=20
>=20>  I think it's possible to implement a userspace program using the e=
xisting
> >  PSI userspace interfaces and the control interfaces provided by memc=
g to
> >  accomplish this task.
> >  However, this approach has several limitations:
> >  the entire process depends on the continuous execution of the usersp=
ace
> >  program, response latency is higher, and we cannot perform fine-grai=
ned
> >  operations on target memcg.
> >=20
>=20I will need to back these arguments by some actual numbers.

Agree =E2=80=93 I=E2=80=99ll implement a PoC show it.

Best,
Hui

>=20
>=20>=20
>=20> Now that Roman has provided PSI eBPF functionality at
> >  https://lore.kernel.org/lkml/20251027231727.472628-1-roman.gushchin@=
linux.dev/
> >  Maybe we could add eBPF support to memcg as well, allowing us to imp=
lement
> >  the entire functionality directly in the kernel through eBPF.
> >=20
>=20His usecase is very specific to OOM handling and we have agreed that
> this specific usecase is really tricky to achieve from userspace. I
> haven't see sound arguments for this usecase yet.
> --=20
>=20Michal Hocko
> SUSE Labs
>

