Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B9DAEB48EB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 09:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F6E6B0089; Thu, 12 Feb 2026 04:23:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9F86B008A; Thu, 12 Feb 2026 04:23:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC4E6B008C; Thu, 12 Feb 2026 04:23:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 801286B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:23:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FE6D16077C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:23:08 +0000 (UTC)
X-FDA: 84435265656.05.794BD2E
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3028D160005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:23:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nvPqHxHr;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770888186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOtwOaawqm5YCOOGpYlVVEXa/IipPl5Ioo0RNIEb2Qg=;
	b=ZCBS2CM0cripvFHZEVc4rOPH1ruJ1zVNgEG5KfQkba8bTewhU+p0CTOspQm4q+KDrbxazb
	YuFxniQT5J9IGT3AGzEq9ve/vFjrswxqgJ9XsKnbJIi/ta6iRpNMrvDpU3a+0Z/FUKW0wF
	6aeojYtU1+sYp29ObL3seLAdifiZPtc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nvPqHxHr;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770888186; a=rsa-sha256;
	cv=none;
	b=GzqAri0W6ullwd5y+K2MYVc+oLc8r5OgBRRKb7dNoVjpZcje/pnPLpzu/ejw6h/Ed/hLJD
	RiNYyyJOGe8Qk5d8deZY2BeFMUXOUkcYoufVl9nQ/3/tzQ7WCx+bIA++LuBA8QEExzT8XS
	UbMp/9ctWEI+CwtK6gKKuVLvhCmq8ZE=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770888184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MOtwOaawqm5YCOOGpYlVVEXa/IipPl5Ioo0RNIEb2Qg=;
	b=nvPqHxHr0KgdC09FjroI0w+XrWY/hJ68UL4/0rh2ftPJh5s8PEVk6tHapWR7m/Ri5dxtnv
	nNQ0yX2uF46GhiKFyKQsKJbEln8+aTnsFZAO98AyIIXUrkhEn4mrYuzBh7bi7l7Nsdwoo+
	gniHvShoHs+8GogwC2C38z+MWvWD6r0=
Date: Thu, 12 Feb 2026 09:23:00 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <9302f6e6d89af6b68d673a2f90e366ebcf947e29@linux.dev>
TLS-Required: No
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: Check
 bpf_mem_cgroup_page_state return value
To: bot+bpf-ci@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
 song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
 kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org,
 shuah@kernel.org, zhuhui@kylinos.cn, inwardvessel@gmail.com,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
 martin.lau@kernel.org, eddyz87@gmail.com, yonghong.song@linux.dev,
 clm@meta.com, ihor.solodrai@linux.dev
In-Reply-To: <0d926bdc5b5e030fafc82de73c3f3e5412c051fc6763f77da9ea6aa316bd8f13@mail.kernel.org>
References: <042df9438d9e78bcd66f1fa0e7043b9ea8cda96c.1770883926.git.zhuhui@kylinos.cn>
 <0d926bdc5b5e030fafc82de73c3f3e5412c051fc6763f77da9ea6aa316bd8f13@mail.kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: i1hw97gg9yzucwxsxoscuax4pbcndauw
X-Rspamd-Queue-Id: 3028D160005
X-Rspam-User: 
X-HE-Tag: 1770888185-680995
X-HE-Meta: U2FsdGVkX1+b2O9SDqqqSxP1wZG0doGxtV8f5Tzt6xZmAuHOPl5/dgQUni+8yuJHbRyOvzOPNAuLWFifU6zLi8j/o0k5UivgvgMGHFZpDzSJuHFMLsllb8gcH/NokMhoGQQyMleTxjcSDyOPf8sE3JQOvD+i13WXwbAFEjRhviosCce7HgtrSJFSKpo6gTpIqVvywJtjX4zhkQbGWGMWOov2xPE/nMkIlLR0IErLwSOuuUoz9AyUNjR3rT/5/TDkL9yuTkZKGAjAItOivVh3Y8equw+TE6C5e9XJ4HCSg76/BGYvum4iOusd4fVIUvuDLx7xJpUem9z9qPkf1wqc4iPG09vJqsKl6slJFzDHkNo92DJ+vc/BR4IYlzX/OyTg9jf9D06nw3n22w7GxA2EiPtMlXSyvpylBq1fwGJvfFoiRtKJxr32rQXJhnt6RXXnsLljL2i4Ywt972d48ZJxl3VH6MpEUPVB1Xy6cam+zFiIM2SAAUuIkuehquNLZ4fGaHemis1xqXUSMZHDuoIW3ay01kCSvZO6ECVot5y80MLnXQN9BB9WG5oAg7vUuAbun2ZAMJFBXTb4k0WE5A6Tx7yHHjUqBrJDq+0lkD6GQJsrfjBlTLcAiClhoBc+zyg/PNrJ4fw4z+PxH6LtcTXH5Kcz8sMx6+jHmizS84Hq8+6kTiSSSJneIZYOg5VVglvbkypmRHjVMT//xN9UIq+X6adGyqVigHVUqZr9Sld0Ze7grT9VTBqz9zSmBEAgsH6XMdFQTvuji28wP/oFwJ89Nnb8Tdrm9Hd4H3gwT3st+rnJojeMKApVtukaJDJ8iolKj21b1kbWtrNpfJN5w/zVk0LCLMe1jogLgVJYxL3A+SD6lhWy986arY4jaQnEoW4Hp0NE3QFSXW3pD3/erH3l23X5LpgKLTSxsuekXs32Uja/deNv41xe54KPCZjwbLRBpmTkAPv0RuvFz+pTL4d
 9HE3Ug9w
 JtAPpZaBYH6iXt1ekIw5fBLjHr5Uv5pNHmlR/79bm6r6/dQT2bdUhbBTgg5Mgs7k55eTA5ZlIll/iVwWwrx62DQ3lB96ZcGkjg7cgxMBOtGfy6IfX/0WI7C+z7ar0GhM2MXtLJl1GEnnRP7GUIh59/J4mauJC11XJSV3soC4CvWcgoDqefTpcedfZFWIOMUtljBX/hUrKeG7+CdIQWFSSLeqy23SOlLhtjZtjrjKgaKiHmRbyaEhrMXXD+IjJiBMjcm3gqhG77c6uWh9QJ/zkk0ARL6WNrDaDo1YqkyYkcnGU+K6XJkiJVu2tgMhUJHerBu4oVD6yAflaMJJUXxEdGAtQZh+a/SRJmGVTr1UGzSbHOLwiw1I81ClmEdVuAjef1gMZrhHQkdTSUu4K+rTTTfGm8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B42=E6=9C=8812=E6=97=A5 16:50, bot+bpf-ci@kernel.org mailto:bo=
t+bpf-ci@kernel.org  =E5=86=99=E5=88=B0:


>=20
>=20>=20
>=20> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_mem=
cg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> >  --- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> >  +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> >=20
>=20[ ... ]
>=20
>=20>=20
>=20> @@ -170,6 +180,8 @@ static void test_pgfault(struct bpf_link *link,=
 struct memcg_query *memcg_query)
> >  if (!ASSERT_OK(read_stats(link), "read stats"))
> >  goto cleanup;
> >=20
>=20>  + ASSERT_NEQ(memcg_query->pgfault, (unsigned long)-1,
> >  + "bpf_mem_cgroup_page_state PGFAULT");
> >=20
>=20 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
>=20The assertion message references bpf_mem_cgroup_page_state(), but the=
 BPF
> program actually uses bpf_mem_cgroup_vm_events() to retrieve the pgfaul=
t
> value:
>=20
>=20tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c:
>  memcg_query.pgfault =3D bpf_mem_cgroup_vm_events(memcg, PGFAULT);
>=20
>=20Should the message be "bpf_mem_cgroup_vm_events PGFAULT" instead?

Good catch!  I will fix it in the next version.

Best,
Hui

>=20
>=20---
> AI reviewed your patch. Please fix the bug or email reply why it's not =
a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/REA=
DME.md
>=20
>=20CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21=
939182103
>=20
>=20AI-authorship-score: low
> AI-authorship-explanation: The commit message uses first-person narrati=
ve describing a real back-porting scenario, and the code changes are simp=
le repetitive assertions typical of human-written test improvements.
> issues-found: 1
> issue-severity-score: low
> issue-severity-explanation: Minor documentation issue where an assertio=
n message references the wrong BPF function name; does not affect test co=
rrectness or system behavior.
>

