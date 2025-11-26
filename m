Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D099D10374
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 03:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A206B0005; Tue, 25 Nov 2025 22:05:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9F76B0008; Tue, 25 Nov 2025 22:05:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9271C6B000D; Tue, 25 Nov 2025 22:05:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82DD16B0005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:05:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BEC65045D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:05:41 +0000 (UTC)
X-FDA: 84151268082.11.E7EAAB4
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47EA9140009
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:05:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Rf/0zDXV";
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764126339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3jgBp1PfnBYXrgF3jUSFmct+uUwYqUAcA/YWm6mwpU=;
	b=vOE7k/vEJzFkItVUEYQGpgyb7a6K7D3gQQIfqA02QdWcWRQFhsEtxFVT1OXCWbhHGCcMmc
	qvxoBqxWfBK5OpSp4ygSHdQYM9Bnm1moXZbq8dTFqLri3SxnrqlPj7/XiLaAMAHA1AIOoM
	yf8EBn+6yL/4JtcIiLLlqiIkFbXbNK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764126339; a=rsa-sha256;
	cv=none;
	b=qgV3570WKMjZ9J9qMlCwygMPu1E3w0gxKzak2NjIHq+ZoybIqWCcKjAr4CjmBUjH/ZKYUd
	TlCsMlP8HjDg4F6L9Yspq4Rfbjr/52Y66PB/ZbGmD1JKw8JyW8QL1a3/8kp94rLehFFl4f
	51zAUI0kX496Mlvs3QzhBMHvjW7GPe8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Rf/0zDXV";
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764126336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a3jgBp1PfnBYXrgF3jUSFmct+uUwYqUAcA/YWm6mwpU=;
	b=Rf/0zDXV8pBEyrbJgCvi0cWN+tHuwPVBoE7qmSdzYp0RxLX2/9C0eJ/lRaTggE4Jz09mHU
	q9SeeV7XGll5YyOoq3FbocY1aXFvGpPdgazLV468zQsMUqBGszJHjJqievxz+Ont9mbh8/
	9uXZQegwa9tzWpJgohYtRx0/ve536GA=
Date: Wed, 26 Nov 2025 03:05:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <87af0c7a8fc35cd96519a4e3f09d39918bdb7370@linux.dev>
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
In-Reply-To: <aSWnPfYXRYxCDXG3@tiehlicka>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <87ldk1mmk3.fsf@linux.dev>
 <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
 <aR9p8n3VzpNHdPFw@tiehlicka>
 <f5c4c443f8ba855d329a180a6816fc259eb8dfca@linux.dev>
 <aSWdSlhU3acQ9Rq1@tiehlicka>
 <6ff7dad904bcb27323ea21977e1160ebfa5e283d@linux.dev>
 <aSWnPfYXRYxCDXG3@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 47EA9140009
X-Stat-Signature: kob4877wheaajo4rn7k5cjxmzdckg19o
X-Rspam-User: 
X-HE-Tag: 1764126339-444533
X-HE-Meta: U2FsdGVkX18kAWOsXiOUuX0GYEBQU+7Suj7BG7/lN1+R8yliowzs9wgwcgsLBFh7CEB9DyXyw97MjIYoYZxVj6pmP0V1qKxrSGCAGg/0qc4fknEmkRaRKa9X9XdwvYeQkxybc/dwpNfReuMMv9mYsMTmFfAsX5HRxykENmm6AC6uXx2cL0xw2KNhTX5Tk1jyhzzZjM3PYSxr+2/Ugin1PmKhxdyf9F+Xx7mXxsD22dcHmEztOzEQ45LExyeXAlbOSMZEfkAAjX70S1Je7r+oUuY8/Mmy2lzR3/TJqIFJNGoid2ysKBBiXISl5OFcVcwONtSizMhLB4ojgGF+LHm5yOgo1Z3n4OPLIdUNbGoMXF62eoxyFzJ/n/YZT+lslL0aw+8H76JOlO0KtD6LjYG06EsjExE4BEKODDWS7BWxDjqZwGSmOcGL0mzkpUqbj7hvohQtfWUoDlRSK+F+yqzuGA3r1dkg+pCQj1Br/Llok1OBtMZ4BkvG8AeaXrvdMWCONPMr+uXrU5fwJPh2d4SXF3tspCTXcTCRqQtvAfT8bsPNq7ckZbEae86HhSL8tKoHDp/lQhyj20bZjG2p8gjGfTDyKT5Qum0H3B+1RscHNGcM1uacf7uwfxlQAqm07ubv0/Osjg5yv7cCReNcZKNo5fVLYqPVpgS+fHAULctLROmoCUgmHUgHNpFz0H754DDfN2zXkauW2y9uIUpPUuDAS6efA/ishcrRpHX/J2GFLxyie2Bq2FKru2vhp5UGxzDopc0DSom2rTEWEiDuQSU9eBPpv7HowCCataQeupW8t19tkcFaoXaT4x5x7rAJ/ax17i2Xx++1ziBT+i3mVM7tIkH7ZmBj/h6HpQLeYm61aL1OeEhLYRRfkD3Jd71CMfCBNk+KHbrZc3rhryEGf8QTyH22fb2PhbZp5vxzqoeIXkfBLrK2cLIHZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B411=E6=9C=8825=E6=97=A5 20:55, "Michal Hocko" <mhocko@suse.co=
m mailto:mhocko@suse.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40suse.com=
%3E > =E5=86=99=E5=88=B0:


>=20
>=20On Tue 25-11-25 12:39:11, hui.zhu@linux.dev wrote:
>=20
>=20>=20
>=20> My goal is implement dynamic memory reclamation for memcgs without =
limits,
> >  triggered by specific conditions.
> >=20=20
>=20>  For instance, with memcg A and memcg B both unlimited, when memcg =
A faces
> >  high PSI pressure, ebpf control memcg B do some memory reclaim work =
when
> >  it try charge.
> >=20
>=20Understood. Please also think whether this is already possible with
> existing interfaces and if not what are roadblocks in that direction.

I think it's possible to implement a userspace program using the existing
PSI userspace interfaces and the control interfaces provided by memcg to
accomplish this task.
However, this approach has several limitations:
the entire process depends on the continuous execution of the userspace
program, response latency is higher, and we cannot perform fine-grained
operations on target memcg.

Now that Roman has provided PSI eBPF functionality at
https://lore.kernel.org/lkml/20251027231727.472628-1-roman.gushchin@linux=
.dev/
Maybe we could add eBPF support to memcg as well, allowing us to implemen=
t
the entire functionality directly in the kernel through eBPF.

Best,
Hui

>=20
>=20Thanks!
> --=20
>=20Michal Hocko
> SUSE Labs
>

