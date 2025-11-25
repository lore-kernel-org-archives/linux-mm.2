Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D04A7D0E6D1
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 12:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C026B0006; Tue, 25 Nov 2025 07:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02236B0024; Tue, 25 Nov 2025 07:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F0A6B002A; Tue, 25 Nov 2025 07:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6D306B0006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:39:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 641444FD42
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:39:27 +0000 (UTC)
X-FDA: 84149085174.25.027A8FB
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id EFA5F180011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:39:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nTiHvz6e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764074365; a=rsa-sha256;
	cv=none;
	b=3C6r2g98R2cKSptIxaHX8phlnWaB/hT2vacgtyxgSfxvOQ9E8HMETWsFFMeluyBvDFnYbz
	AXTL9yPcum/TsCIULVAMtZmG1a75ETC344MgarKeA3QXmYorF7m6rdT5TPenFSEIAqWYnQ
	BW1iZbY8H5sy7WVui8SDV4obIoIk4Kw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nTiHvz6e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764074365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r47ko9tqrh1CHMcuZiyYgpMsClYo0ThKH5iXQ+5qeO0=;
	b=Bpmw0WDvr5IEIbvNpvzPWeALuGBh+0pGPnyK/9jM0BwmS39kwA0oj/i0jUI4HfnPSETeCb
	Jit3zXL9Jcdue2vJIyMJZ/YzUfdnzDTQnN1DG3ki2kA78pXZL27AOkssxaX9lrz5jJE3Iv
	EUsf+gBjaq1szu3lQZMnQoSvTLnn/cs=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764074360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r47ko9tqrh1CHMcuZiyYgpMsClYo0ThKH5iXQ+5qeO0=;
	b=nTiHvz6ekOScWYJK5xH6BI23HoTKy5GzZ1p6Ze5lpm3ikHo/Uzgewi28+QtbBJaQ19sLBn
	eOMzmS6HnfdlrY9HODH2VrNQHrPSe3KuM8FQPGbgPDirBlnGXf/YSX8JWBIAhrb74YF071
	6wEDfDenPhmPUrZZEXT/MJkHcZh4Iqg=
Date: Tue, 25 Nov 2025 12:39:11 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <6ff7dad904bcb27323ea21977e1160ebfa5e283d@linux.dev>
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
In-Reply-To: <aSWdSlhU3acQ9Rq1@tiehlicka>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <87ldk1mmk3.fsf@linux.dev>
 <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
 <aR9p8n3VzpNHdPFw@tiehlicka>
 <f5c4c443f8ba855d329a180a6816fc259eb8dfca@linux.dev>
 <aSWdSlhU3acQ9Rq1@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EFA5F180011
X-Rspamd-Server: rspam07
X-Stat-Signature: xs14pmwf13padk99gwcuhqrmab5sn6fb
X-Rspam-User: 
X-HE-Tag: 1764074363-792129
X-HE-Meta: U2FsdGVkX1/7tzxH3a1f4y5hj47geqzwn4xiY+FpcY1a5LM6Ha2fIsuLUEkYoiGcdcD772qAF8a9uH+ATSJLxhmozZQqg1T3PAPfa9vgJdGi6MDWjE5xOKJAMoWusAbjJsqCNo6GEswrhKAq0mj1YrJ27WGlsvJui7skj8Dg4aCA4NisCw/Wo2ZkGMbrmaTgtfEbD7L5pB3cCZ4ncskRt4zZ/t6C72ET2QFy4WqE4sfneT2vwotOWpEblkqmakC/xKyPwmqW5Yz8EO4xF6TP5SUKF4BF8VIuA08Ub8iDN8/4/cPsH/Gebj9G6iYrsyUDgV1AqZtT+2AsOWVBU8D+OXJob9jmlrLfvTlDzmdWTaI4KVDt7TwH+nHRv7RotMbprP38GXfzGDY1s9c3FEEVhhfYWd4ij0b81wInWV3Llbux2mLBGhO59UMHsrV8S/fvcTAN0HjI78hjDUvzieMoG1w1PQlYzVnYJO+keigX8gZZVrFLIKSta2KVFo9zU5kNt039c0TRAKk7PXnJIFoQRY63u67Sh5zIPqNfShPAcI1NS8WDybDNp0FvTa9LhmEmQRjJc8PMVBx8OF7uDRDF5lCCmvjKdNG+LgyUyBCkxrT4nskEsrWgLwU5fJ0JpUwlawzBwhpuSTRdTVP1FZllxe6A/yX0shc0+2VIhb0lvspmyiYPHXyOXxORr4TV137j7NXpAd+T3nI27H6BzhXc1lFGcFPJodrdivMkWlHJhgx6DZvPSbgulpt5xzySeYTU4zwLfIWlClu6tx91i4AsOOw3WAqHmdDix60j218AItso7/l4OZsHjWE7ne2+JfRkzDp6CP5Xnj6zFe2FX4dU6PIm5Zk1VGVq21ULYl9qaoZ5Mcl9Wz6cylazn+vupwvlB/yFB//tWTRYphq2Wr5fhwKLCcmzRaZYEeRpTSnG24F5qAcBCSEBww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B411=E6=9C=8825=E6=97=A5 20:12, "Michal Hocko" <mhocko@suse.co=
m mailto:mhocko@suse.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40suse.com=
%3E > =E5=86=99=E5=88=B0:


>=20
>=20On Fri 21-11-25 02:46:31, hui.zhu@linux.dev wrote:
>=20
>=20>=20
>=20> 2025=E5=B9=B411=E6=9C=8821=E6=97=A5 03:20, "Michal Hocko" <mhocko@s=
use.com mailto:mhocko@suse.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40su=
se.com%3E > =E5=86=99=E5=88=B0:
> >=20=20
>=20>=20=20
>=20>=20=20
>=20>  On Thu 20-11-25 09:29:52, hui.zhu@linux.dev wrote:
> >  [...]
> >=20=20
>=20>  >=20
>=20>  > I generally agree with an idea to use BPF for various memcg-rela=
ted
> >  > policies, but I'm not sure how specific callbacks can be used in
> >  > practice.
> >  >=20
>=20>  > Hi Roman,
> >  >=20
>=20>  > Following are some ideas that can use ebpf memcg:
> >  >=20
>=20>  > Priority=E2=80=91Based Reclaim and Limits in Multi=E2=80=91Tenan=
t Environments:
> >  > On a single machine with multiple tenants / namespaces / container=
s,
> >  > under memory pressure it=E2=80=99s hard to decide =E2=80=9Cwho sho=
uld be squeezed first=E2=80=9D
> >  > with static policies baked into the kernel.
> >  > Assign a BPF profile to each tenant=E2=80=99s memcg:
> >  > Under high global pressure, BPF can decide:
> >  > Which memcgs=E2=80=99 memory.high should be raised (delaying recla=
im),
> >  > Which memcgs should be scanned and reclaimed more aggressively.
> >  >=20
>=20>  > Online Profiling / Diagnosing Memory Hotspots:
> >  > A cgroup=E2=80=99s memory keeps growing, but without patching the =
kernel it=E2=80=99s
> >  > difficult to obtain fine=E2=80=91grained information.
> >  > Attach BPF to the memcg charge/uncharge path:
> >  > Record large allocations (greater than N KB) with call stacks and
> >  > owning file/module, and send them to user space via a BPF ring buf=
fer.
> >  > Based on sampled data, generate:
> >  > =E2=80=9CTop N memory allocation stacks in this container over the=
 last 10 minutes,=E2=80=9D
> >  > Reports of which objects / call paths are growing fastest.
> >  > This makes it possible to pinpoint the root cause of host memory
> >  > anomalies without changing application code, which is very useful
> >  > in operations/ops scenarios.
> >  >=20
>=20>  > SLO=E2=80=91Driven Auto Throttling / Scale=E2=80=91In/Out Signal=
s:
> >  > Use eBPF to observe memory usage slope, frequent reclaim,
> >  > or near=E2=80=91OOM behavior within a memcg.
> >  > When it decides =E2=80=9COOM is imminent,=E2=80=9D instead of just=
 killing/raising
> >  > limits, it can emit a signal to a control=E2=80=91plane component.
> >  > For example, send an event to a user=E2=80=91space agent to trigge=
r
> >  > automatic scaling, QPS adjustment, or throttling.
> >  >=20
>=20>  > Prevent a cgroup from launching a large=E2=80=91scale fork+mallo=
c attack:
> >  > BPF checks per=E2=80=91uid or per=E2=80=91cgroup allocation behavi=
or over the
> >  > last few seconds during memcg charge.
> >  >=20
>=20>  AFAIU, these are just very high level ideas rather than anything y=
ou are
> >  trying to target with this patch series, right?
> >=20=20
>=20>  All I can see is that you add a reclaim hook but it is not really =
clear
> >  to me how feasible it is to actually implement a real memory reclaim
> >  strategy this way.
> >=20=20
>=20>  In prinicipal I am not really opposed but the memory reclaim proce=
ss is
> >  rather involved process and I would really like to see there is
> >  something real to be done without exporting all the MM code to BPF f=
or
> >  any practical use. Is there any POC out there?
> >=20=20
>=20>  Hi Michal,
> >=20=20
>=20>  I apologize for not delivering a more substantial POC.
> >=20=20
>=20>  I was hesitant to add extensive eBPF support to memcg
> >  because I wasn't certain it aligned with the community's
> >  vision=E2=80=94and such support would require introducing many
> >  eBPF hooks into memcg.
> >=20=20
>=20>  I will add more eBPF hook to memcg and provide a more
> >  meaningful POC in the next version.
> >=20
>=20Just to make sure we are on the same page. I am not suggesting we nee=
d
> more of those hooks. I just want to see how many do we really need in
> order to have a sensible eBPF driven reclaim policy which seems to be
> the main usecase you want to puruse, right?

I got your point.

My goal is implement dynamic memory reclamation for memcgs without limits=
,
triggered by specific conditions.

For instance, with memcg A and memcg B both unlimited, when memcg A faces
high PSI pressure, ebpf control memcg B do some memory reclaim work when
it try charge.

Best,
Hui

> --=20
>=20Michal Hocko
> SUSE Labs
>

