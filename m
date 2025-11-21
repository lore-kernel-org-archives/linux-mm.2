Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2595ECFA469
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 02:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0466B000C; Thu, 20 Nov 2025 21:46:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787286B002B; Thu, 20 Nov 2025 21:46:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4496B000D; Thu, 20 Nov 2025 21:46:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57E346B002B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:46:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7FBEC0436
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:46:42 +0000 (UTC)
X-FDA: 84133076244.25.1B306AC
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE6931C000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:46:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RXKuJU/R";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763693201; a=rsa-sha256;
	cv=none;
	b=l0ExUMMWkdfIpgoOfAmL4E4ohMxhTFvDDsoK4ePaQmlJPOgm2u9jmFunNPoJPwajX90Gy2
	XIbQiti6tzbqh5TbcS8pj0rBFxGLYagU25XH3yOn4gyAJUBySqKfs81byh4/0iNYRHZW3r
	IYt8CH6qbv+8G3VjoVqGfwwvPr0TXQc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RXKuJU/R";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763693201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yYZn6QK5gg9APsMYldZKsKSIWjXDUkqOUS9S8IfOMQ=;
	b=ArsFPKYpnt+AfDLmv3y9++ltnqbGdo4Ow0OuiPOFymugYnvsyPE+RulWFv4gpet1BoWcZf
	pgPYgE2B+6dC9F3xwMhkqto5LM1ZtNrYLBX2YmGlKAARWPocLP+PbNI0b/ycnlliZBWmjL
	1f1T5OmX1nuv9xOODE1PkeBa+B38qnw=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763693196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0yYZn6QK5gg9APsMYldZKsKSIWjXDUkqOUS9S8IfOMQ=;
	b=RXKuJU/RA1cAjc1XUBHWdIB9doG2Wk814x1wLnldU/d0slv40i246MHbcPxCVv8Z7ah4GX
	tU01cPDa5Zxf/9up0Y0JiDZQe0KB46S33I1BVcb7IkEpeZNkoRR1xAhu/BizuIrlwYWvtW
	gpBi8k0becQydlkbV7NHMiRxNgU9NF0=
Date: Fri, 21 Nov 2025 02:46:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <f5c4c443f8ba855d329a180a6816fc259eb8dfca@linux.dev>
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
In-Reply-To: <aR9p8n3VzpNHdPFw@tiehlicka>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <87ldk1mmk3.fsf@linux.dev>
 <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
 <aR9p8n3VzpNHdPFw@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE6931C000D
X-Stat-Signature: zahhnse9exu1egk4uo51fye8ttehd458
X-HE-Tag: 1763693200-356161
X-HE-Meta: U2FsdGVkX19JffTV/wGxVHy3jb9WT9OKFimaiFsHWSHcXAyzUXAt2iWzLhOIbfm0XatgRgMqwnTaiVxn8allEBr0QGZuWxY+PsWS9TVPVAIF6Lf77hStKtFT4RjEFPP+mtAB6upj2N9V2VwcAVWI4yovxupiSi9d1pjZoOGIufJz+oH5P2cppqqSoClto8/be1+tpujzzGrhJ03T0mSfdccDYxdcKVVNvifAbCjQ9xH6tsw/Nz6JTg5O7xe+zmtnb5eAg1zCNNXePBvFpV+DErbccI7Luw4v46Hr4Dtnic4W2yLy+8sNKWy1y0Bu4fTyuk7Cn6mtxiH5JoqIIKIIVgFL/fsElyrleyzXbFSMzvoG6H8wtRrP14YKk4xc+IKn05i/2EQSElU3EtELD+8pLaE/UCDDye4QZrGTGD4z4qS1wMtK6WZqoSZinnvbAaQ83ofFUczifw4xub2mHP7AMG83n8jj0OtWAycsNGnfJngbE0zaGdDw5BO7s719oi2fFN8Niefo6StVsAd7RlLPNdr5ob8zqtifAI7iw14+wjDcp5Xlou4Aq9/yeD55IarI8/DT+3Z26o+PfmN6Zw2hgFwUwfFywsMnSb+DSkFcgnSWGWb/GbtGCtnTVdEApZ5FWQVtM9e2pC/0tHndL28DHz1ltGYQekSA3+LYqisgaCe7uw1d8eb8xuKGEArNDepv2HV18zh5lpl7oY3hCqLqPw/EJwtp9Wq1PDP5n+qUhWNI7vXDWQ+77xJsigOuqbahlvNvYJ1mZMktsnppT5OmAS/mijIyqXbPjB+gjIN9OxnHdqxKNSK0dFrAhGESMaAXPKeOMiCp+4srb98TPQxoxM2SK8yIaPfA1J+qdca2k1X3Zjv1hQpa/KiByQmDvGWkSqkSNi38T6uD6KC/z/YghN30YUP3c68WPGf+4xJ2blatzbDVBhO0Y/ZwdoBqxsl6Pc3qh7WtaP4vQCEs8E0
 amDCm7jy
 iv0l6i3RcgUH8WOqVD9WYn96lBy6jTOsX/gruz0MB9wllcYOmEGxlwX2aZG3niApNzUPtAfZ21Nxb7/noOpgIEff7W/+0im/40cOD/Ls+lfJ/2g1RLxZYXt5NRqEPPYu/wK+Ic+FmTP5yQ0J+LUdK7vXqC51H8g063oGRKy1dnEd+kzvc3GCyOUEk8Sf4A+1Qp4Iui3FveDeyF+lmrt0Y/c0ze3nR6SsT9djvh65UlmKxP3u/MGpytV68H3h5k3oCNd9wRoMcm9IVEeWLe5IbtgeC2phf92LAPUq3902rwt05g0IQbmm7X0ydzr74WRB2vzzdnG152/RsJlkYzh0ekupb7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B411=E6=9C=8821=E6=97=A5 03:20, "Michal Hocko" <mhocko@suse.co=
m mailto:mhocko@suse.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40suse.com=
%3E > =E5=86=99=E5=88=B0:


>=20
>=20On Thu 20-11-25 09:29:52, hui.zhu@linux.dev wrote:
> [...]
>=20
>=20>=20
>=20> I generally agree with an idea to use BPF for various memcg-related
> >  policies, but I'm not sure how specific callbacks can be used in
> >  practice.
> >=20=20
>=20>  Hi Roman,
> >=20=20
>=20>  Following are some ideas that can use ebpf memcg:
> >=20=20
>=20>  Priority=E2=80=91Based Reclaim and Limits in Multi=E2=80=91Tenant =
Environments:
> >  On a single machine with multiple tenants / namespaces / containers,
> >  under memory pressure it=E2=80=99s hard to decide =E2=80=9Cwho shoul=
d be squeezed first=E2=80=9D
> >  with static policies baked into the kernel.
> >  Assign a BPF profile to each tenant=E2=80=99s memcg:
> >  Under high global pressure, BPF can decide:
> >  Which memcgs=E2=80=99 memory.high should be raised (delaying reclaim=
),
> >  Which memcgs should be scanned and reclaimed more aggressively.
> >=20=20
>=20>  Online Profiling / Diagnosing Memory Hotspots:
> >  A cgroup=E2=80=99s memory keeps growing, but without patching the ke=
rnel it=E2=80=99s
> >  difficult to obtain fine=E2=80=91grained information.
> >  Attach BPF to the memcg charge/uncharge path:
> >  Record large allocations (greater than N KB) with call stacks and
> >  owning file/module, and send them to user space via a BPF ring buffe=
r.
> >  Based on sampled data, generate:
> >  =E2=80=9CTop N memory allocation stacks in this container over the l=
ast 10 minutes,=E2=80=9D
> >  Reports of which objects / call paths are growing fastest.
> >  This makes it possible to pinpoint the root cause of host memory
> >  anomalies without changing application code, which is very useful
> >  in operations/ops scenarios.
> >=20=20
>=20>  SLO=E2=80=91Driven Auto Throttling / Scale=E2=80=91In/Out Signals:
> >  Use eBPF to observe memory usage slope, frequent reclaim,
> >  or near=E2=80=91OOM behavior within a memcg.
> >  When it decides =E2=80=9COOM is imminent,=E2=80=9D instead of just k=
illing/raising
> >  limits, it can emit a signal to a control=E2=80=91plane component.
> >  For example, send an event to a user=E2=80=91space agent to trigger
> >  automatic scaling, QPS adjustment, or throttling.
> >=20=20
>=20>  Prevent a cgroup from launching a large=E2=80=91scale fork+malloc =
attack:
> >  BPF checks per=E2=80=91uid or per=E2=80=91cgroup allocation behavior=
 over the
> >  last few seconds during memcg charge.
> >=20
>=20AFAIU, these are just very high level ideas rather than anything you =
are
> trying to target with this patch series, right?
>=20
>=20All I can see is that you add a reclaim hook but it is not really cle=
ar
> to me how feasible it is to actually implement a real memory reclaim
> strategy this way.
>=20
>=20In prinicipal I am not really opposed but the memory reclaim process =
is
> rather involved process and I would really like to see there is
> something real to be done without exporting all the MM code to BPF for
> any practical use. Is there any POC out there?

Hi Michal,

I apologize for not delivering a more substantial POC.

I was hesitant to add extensive eBPF support to memcg
because I wasn't certain it aligned with the community's
vision=E2=80=94and such support would require introducing many
eBPF hooks into memcg.

I will add more eBPF hook to memcg and provide a more
meaningful POC in the next version.

Best,
Hui


> --=20
>=20Michal Hocko
> SUSE Labs
>

