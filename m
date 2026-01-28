Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835D1D46BE0
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 18:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972B16B0005; Wed, 28 Jan 2026 13:23:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6CE6B0089; Wed, 28 Jan 2026 13:23:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802046B008A; Wed, 28 Jan 2026 13:23:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC0B6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:23:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 157FCC1E8A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:23:47 +0000 (UTC)
X-FDA: 84382196094.09.34D7A3F
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 27BEDC000E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:23:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/TKcIBB";
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769624625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dks1n+tLn9aMw/JnuP0H2rQMs66fm3ChmT9gGdwBgv8=;
	b=OvPpSvqHFHuWyRsOi5Qoi/wToWt432pYJImuJxq/9PH8aG7ouNKDgVZR/zll3D2cwL5wDr
	/tNO5T2b4Rxux4cFv7F0X/MdoQIySKtMt0zXDi7tULt00CO/nGlbYxBKS4WSt2VAoEwY0h
	Pjh6il/P1cxrCQ+urlDYMxZjajVgUKU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/TKcIBB";
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769624625; a=rsa-sha256;
	cv=none;
	b=yVYiqEObh4U9CO2kjTH0tNHTJo2sFmcNQdspoJ7d4gjyTJALGkwN4Luat+BP3NlkErMhYS
	bBf3FYJEh491zUnvV5LFjIAgXo+fLEoq9UcKD3OmZPniPT0N6295y1TvEuuR/y9iTXJ7E1
	m/NUrwm59fpsP6jQtvy4TMM29H5pTRQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769624622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dks1n+tLn9aMw/JnuP0H2rQMs66fm3ChmT9gGdwBgv8=;
	b=T/TKcIBBphm5L5F1YLVql/At3jjPNegsOzmM1WMurTi7yjSmsV2Y9xwPoMRDFqjcOfKsRh
	8AiAMlGX1VQVdl5A3uXFHwubzIUTIs7jIhK4tkO+fjPvOGixtvzt82coITpwonDzRMOJ15
	/fSTu/hou6lTRkk6Om9Cv9fjNhEMbWI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>,  bpf <bpf@vger.kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Matt Bobrowski <mattbobrowski@google.com>,
  Shakeel Butt <shakeel.butt@linux.dev>,  JP Kobryn
 <inwardvessel@gmail.com>,  LKML <linux-kernel@vger.kernel.org>,  linux-mm
 <linux-mm@kvack.org>,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 00/17] mm: BPF OOM
In-Reply-To: <CAADnVQ+ghTc5FtJCjm4ya3y3xVpSuJe-7ctdT-thowqWguc1pA@mail.gmail.com>
	(Alexei Starovoitov's message of "Wed, 28 Jan 2026 08:59:34 -0800")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<aXh_LpTzDhvv20uB@tiehlicka> <7ia44io6kbwj.fsf@castle.c.googlers.com>
	<aXnDdkYmtipGwSjK@tiehlicka>
	<CAADnVQ+ghTc5FtJCjm4ya3y3xVpSuJe-7ctdT-thowqWguc1pA@mail.gmail.com>
Date: Wed, 28 Jan 2026 10:23:34 -0800
Message-ID: <87zf5x1tqx.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 5ormgs3wq4gj18rtqqpr57y3rtakent1
X-Rspamd-Queue-Id: 27BEDC000E
X-Rspam-User: 
X-HE-Tag: 1769624624-554056
X-HE-Meta: U2FsdGVkX18aAbztcRtNCzfTG602DsknAgJ9I+O1qtvm7pRtvIIaUbK7h4GJqqNFGOa8E2B6xHIEpgGsfzh0KMsljV7hGEapjO+ft+p/jyo/KqBYLMTGziNmys9J4gGyWkv+yTrKLnJq+bU1yHqhDGcKbdhHFK0qMnFzOPmZHh6CqappKScv5jx/Zp19Vm0fWeio+gksjEd0bvhS7MmCIHwG/JLfJT0YptYM3gupN0qqtTcAW/YAqk7fyQ3sSehrYLyaDnDK4kHCnJm98QfzG+7QdaknvHdi1Z6sAYsB6qovioW8XDhBocetSl8QZhOKUD427IsofSVryLXMIvwTGF7JuNhivGbDYvUqDjUZe38BQzcpON7Arh7atI90ouwMEkrAplbXLapEJmJxkDdLiDGE4JCX8zoS1FwlGjQUKdx+m7F+t/EZzKMvfPLU3sDzR2h/UBNtGcOSAm1pEJqAoBu/0W1T6t7UANBzQaWV1gxRtlTW4t5MB7x0ICNWF9NGKZaupV75V69duoqhcO3rmC4hItMISKHyLpux7MfGu3srh5P/QxgWoaChDpr7y7umV2LmjwwJ2voM3MU0/fxk26lB+WQkwLRXBms1LX4WZDP3gwFzOjJNbEWrxPPxYNhjrXen8/Mq4oCE82g+B2tmzY36ywxOWKNbBMzVjvSQVgujVwTVKJNyNYFNwOXfFXeJhvnGM0P/BzBVquH0wQ/aCgm57i83M1SQp7PauIz9zTSyRm3g1NFrB+m7SPKg1lJVfYEbu31Bvw+2NGdphbdEt1ppapMtVMAe9fpqPQ91VLD7iBVDSp72n63xA6pu9UfblzoitYYQDBLgkF6hprKS6RRDubyQ+CuDl7TJKqHQzPpcKDGGU84BTtcu8tOQ9/hJ89LdSTwCtsPrHxB1tuPfR4Ou/eTZ3kdvq8sMh+vh1Pkbd+hD8NZehelbnEma/+BnT6MI/AocofZJlUU0yoO
 V+HV/+8N
 xbd7aJo8XwQoJwSG/8uHSrKsLrsqcAkb4OCjIM5WGrBKQdHqWuEMCmING8Uv7iuDCCT9WSobSjXkoLWgnU/mLiXMfkSWs7O+LOWmNiP+pW1nRom/vVyibJPuE/3kbx3w6OgJLNxrRuz1pGWZDjlHtpvsf9+xg9Z/++/zZw8rzXy0L2rVTwpCfm9jBWjcezft2FY9CODhlaT+mAbA5MjlhdBu2ZkAU6U/vQS0bjl/3jXeQEsPQhaNy3mRAhN7ZhFwHv0KAkJWw7nOiDwI2iEZTZGSUVGbgHw+ReZAjFN4EqzJVpZX2LZH07mxxd+Z+WmzLWA12K6MvzHo2nYsfYgRmQPNcvifBhS0RegNQE5eFSsJU9aQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Jan 28, 2026 at 12:06=E2=80=AFAM Michal Hocko <mhocko@suse.com> w=
rote:
>>
>>
>> > Another viable idea (also suggested by Andrew Morton) is to develop
>> > a production ready memcg-aware OOM killer in BPF, put the source code
>> > into the kernel tree and make it loadable by default (obviously under a
>> > config option). Myself or one of my colleagues will try to explore it a
>> > bit later: the tricky part is this by-default loading because there are
>> > no existing precedents.
>>
>> It certainly makes sense to have trusted implementation of a commonly
>> requested oom policy that we couldn't implement due to specific nature
>> that doesn't really apply to many users. And have that in the tree. I am
>> not thrilled about auto-loading because this could be easily done by a
>> simple tooling.
>
> Production ready bpf-oom program(s) must be part of this set.
> We've seen enough attempts to add bpf st_ops in various parts of
> the kernel without providing realistic bpf progs that will drive
> those hooks. It's great to have flexibility and people need
> to have a freedom to develop their own bpf-oom policy, but
> the author of the patch set who's advocating for the new
> bpf hooks must provide their real production progs and
> share their real use case with the community.
> It's not cool to hide it.

In my case it's not about hiding, it's a chicken and egg problem:
the upstream first model contradicts with the idea to include the
production results into the patchset. In other words, I want to settle
down the interface before shipping something to prod.

I guess the compromise here is to initially include a bpf oom policy
inspired by what systemd-oomd does and what is proven to work for a
broad range of users. Policies suited for large datacenters can be
added later, but also their generic usefulness might be limited by the
need of proprietary userspace orchestration engines.

> In that sense enabling auto-loading without requiring an end user
> to install the toolchain and build bpf programs/rust/whatnot
> is necessary too.
> bpf-oom can be a self contained part of vmlinux binary.
> We already have a mechanism to do that.
> This way the end user doesn't need to be a bpf expert, doesn't need
> to install clang, build the tools, etc.
> They can just enable fancy new bpf-oom policy and see whether
> it's helping their apps or not while knowing nothing about bpf.

Fully agree here. Will implement in v4.

Thanks!

