Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB54C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 23:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFBE6B009F; Tue,  7 Jul 2026 19:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6826B00A0; Tue,  7 Jul 2026 19:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCA36B00A1; Tue,  7 Jul 2026 19:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 102176B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:50:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73E05405E9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:50:17 +0000 (UTC)
X-FDA: 84963626874.08.1F33E3F
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8F49420002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:50:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARTRwq3n;
	spf=pass (imf31.hostedemail.com: domain of eddyz87@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=eddyz87@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783468215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jR5FDbXPbDj7uRWgGm0G3zwUJBd3PGR+m1Sli1Axe2k=;
	b=49SMp7LW2VShwr0uTZ2sF9QGnYlC25oIG+hgcCnOk/lIBaJUKC8u/cULr/52saJdyBooay
	sN6IwJ/NwRGPDCNnbJHOZVKrWDV7ZfDQnv//TspN+1YfmDIasRX7Pf6eu15Q8Ljwmf4WeK
	WheqylsPGyj/w7R5++q0zKyI6PMjrKw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783468215;
	b=VY6H6osfcE/U+db8eZ8tvI/QK0aHPwrVbSyjQamOGYM8z7QWKYKZIABG/TybthN8EyJk3P
	rFum5Fh5OPRUbVI3+3S+cTV6WLUJEQeVSOOnaEq2QQ7vuxs+5+5H8l0X80rDU6ayeHu2eX
	tYRIB3LVDl9i5Y0PoLpaKNnWWkzIhkA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARTRwq3n;
	spf=pass (imf31.hostedemail.com: domain of eddyz87@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=eddyz87@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c96b08cdd1cso28196a12.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 16:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783468214; x=1784073014; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jR5FDbXPbDj7uRWgGm0G3zwUJBd3PGR+m1Sli1Axe2k=;
        b=ARTRwq3nJtiaV0kIW/0tW69W1n6fC+jkmsXORBZTinC4C0L67QZViRqa1a56SwbMnF
         /p9nJSnc0XFV70I18HoYBnBcBMhTsZC0F+l4MoobWxph+UtbYgdFFK5O37f9CSYWRpvL
         v6U9/tpzana4cjNBYbu3m7IA2eAqwjHWhfRVv4W8lhLHuZlCLGy0+Wu14cO2LyRGMngz
         YGe4xoeVKfXsXcDY/CjD0hyR3Fh9vt+pjTJVhIttxbBRu8XNnnifAWdllnoMzt13ttTg
         WkTWLEitEDcyzXUX7rd+uMkWSG3xaLW03lDx05+naDfR73P4oYIAazqn83dlrk5nYKFw
         INdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783468214; x=1784073014;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jR5FDbXPbDj7uRWgGm0G3zwUJBd3PGR+m1Sli1Axe2k=;
        b=lPOnIh/2eM26X9uAaiCCY/AKXNG7YH99kIpmCYN1zj2ybnk+WfIzI3hIzhQ1C/DODP
         8Nndoy9WHjeh7Wv8ZwLC0z+QbiMn9lcEuFE8XwYWE0g6u1s/VEAuqnoUycQJPDozDfVr
         e5PRZ+7MFSoQScDF/znlt5UeSCR4l4YNljFZYrYXTLiKCAtSvxYbKba7tC0lcRiIh2sM
         T2xo3Bh7SNIrea8hGkUq9fiYgpAbuLHE9Bguu54Ojl/KhfPXx7J1uriCmMAcOXWkEVeV
         88SkZd+OkdFrBw1jJB/Sk00vfkD9ZbFseVXfoXnJXlw2hEqmW0NibmddEuNb8VWpuDrn
         b/Pw==
X-Forwarded-Encrypted: i=1; AHgh+RoNHo/mv1snFwtzEjPvlsUXOjOyou5RmczZCX2W5vc6ADS6gLwWCbVINnR/MqxvvnKE1dIOf3iHjA==@kvack.org
X-Gm-Message-State: AOJu0YxfSA8J2gXrNutqvC2TJOZzrWh+oIL6cKdqOuZfy6CaI0VrAVl0
	7gDnKwuYxLp4UO1bX1bjBmanQWxLpMgIsj0RocbSdqn8U98Ey5BvReq5
X-Gm-Gg: AfdE7cnoEc6e7xLWhGWnrnaON8VAt6yP8oFL4wzuagYWx9ZLlIkJ2s4s1/Th/41V4cW
	8yAIzXBKy6zD+1YcgIUB4B4z60HINzSxK0xfGSc9nEQCibBe+Y+1EXSB0Gdydqx2DmhdWjGg7u8
	OEh3H1ORQiYpHnULURXl3MnvUrOXesc7s2Kpl6IHBa8d+4mUQqoWam8Yiv+BIoddeE6lDWdBVRm
	v45FnVd0WHl9MFdEQoSaL+hOg+E7E23Qc430Y1FRDGvlbJTUeQ0D8kW5Mg3cJN+GV8DTGrGlA9n
	/xQna1459ARIxxujSuorEyo5znHgbrPy8riQqqKHoB/LauhB0W01Pcw1LxovdCyzXm+vcl7ihqS
	FwUiPnpBokO7RaeNbAH0AI3D+sW58TyYa8s6fj8gwcGmCr9znmSLlSfPLUOIiuRE5+/WiIabZik
	4tEvfNkmAURM84LCmMLuCkS8Q240v+WRmFUjhh+cTmBizw1sCClWJIYByDpCc4FkLDfUu0Bg==
X-Received: by 2002:a05:6a21:3295:b0:3bf:7fa5:8922 with SMTP id adf61e73a8af0-3c08ed13de2mr7843747637.2.1783468214356;
        Tue, 07 Jul 2026 16:50:14 -0700 (PDT)
Received: from ?IPv6:2a03:83e0:115c:1:f2fe:14ed:44aa:14cf? ([2620:10d:c090:500::2:84e7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659d7c8bsm13083613c88.12.2026.07.07.16.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 16:50:13 -0700 (PDT)
Message-ID: <bc47c75a00acab57e7fea72612e0f6f089ddecc9.camel@gmail.com>
Subject: Re: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg
 stat readers
From: Eduard Zingerman <eddyz87@gmail.com>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Alexei Starovoitov
 <ast@kernel.org>,  Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Kumar Kartikeya Dwivedi	 <memxor@gmail.com>,
 bpf@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,  Song Liu
 <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>,  Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan
 <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	kernel-team@meta.com, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2026 16:50:11 -0700
In-Reply-To: <ak2LXDWoPFSJL2Q9@devvm16600.scu0.facebook.com>
References: <20260704045617.487664-1-ziyang.meme@gmail.com>
	 <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
	 <akxW5dzvR9e2CfGq@linux.dev>
	 <eccfd9a8dd1af1668e142b9b866194333647b0d5.camel@gmail.com>
	 <ak2LXDWoPFSJL2Q9@devvm16600.scu0.facebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F49420002
X-Stat-Signature: hodgxi51zmyih98ombj66h4sdxwdsogp
X-HE-Tag: 1783468215-185629
X-HE-Meta: U2FsdGVkX1/unVtp223t1gsm/ufsrEwqRa2cLJscZDjqQPKueI76Y0PWuAJEwApdoRWiDawQOogR1ZBcyp43rEb2YYjY3RhIgFk1krcQ2CTJVLkd5shzzFsi6Pg0fAYOh0hGEf+Twymd3+HxOTjGuZESE5q1QsBOTjR3RKuIjU6Mjpeyb9Bd/SxG/LNXGouMi308ctgT9yAvLt0UX88vz5UAN0CnDYK8DNWiHAwV5zhmOtcwDTH2JILTXpd7sph97tkikECUKwNL+u42SdEmmE4HIfWh/szN3UXntxxz8vGSQ4i/T67OsAZqcn07WEn+cPCw+mvIBON8CPqtMwF+xfIZwSzA6XeeRjGz/Gt7AR1WdM+lsZN+eSIhxWht1S8flpZ39hkIaws6oSsByY6DDmvuly62iulJKaRhviEMQymxLUDKoVsX/lf0laUQ83RJvhaRc2dyh1Qlxgtt2Gx0INqWxDqk8jMnUgG6hsD5QnEeMbfuhvkyauunWxyVS/fAtM0RKVwgrp63UDloHiEZ+l/9dUjl6EVxJa1YaJBT/ti2wSKpDDEHdwy8g6+WcCPjq/Jw4QZsIWrgrdFUJT7WTmu0QZytqk3u5SJzTiYr7iyrrT8TO0w7Rvz7liu1uhIyZMDLedoc+GMx5RSVxx+wVFRjG25kP9KbJQs3YEqzpeWt0b9O2CGjMZLBNXt65+R7oviiKMmzLIT4IVyUo4bzvc1pXzm0qbN3rT5zDrD6sCpR1VFhs2Jri+dTJ4uAvCLOJEbGTkEVCcT4WowOSKUAa0aTvtHCr+9owJPzF8WwsXXlQLLcd4DfbYZTrWcOkPV5nwNE73HdZUM02j/AMYqrb6QK9Op/y5Pm9QotXIagqjVSNZiHE1+1PnNeRQeijBH42ezS2/4qZSG9rbfrnVEq7esa9n52bY4kNwXfF0wJfho3yPe6H2mLCuoXTvDLHEYvva4pGn/FflQBCPTqPuI
 uvArTmWV
 8Ew1FbqyUbvxD1duLN0bAE/HqVGnNQU2w7xfKxu/+AbOgaTEedabweJJMqP+B3grxVUpnKTOB1LBuWHlca5oVk+5kjMe0TTIzFZcqKIvBufJeK71V9f7I2CKag0ZzdTeRHLQZBsEEJZg7thngzBdgzW46QIU7ASWTD2z3xJHIxBxbEKZUxu7FkalnYKNFU9rsM+d4UZ8fLrnM1UMpYa4fooXxExRHVGrQGGh0gInUdHXrqeBXur0u85CxwR+qg84ivgwbrRfWq4tvIAmCVZwb9cHT5ElrnowdM88ZoYiYne6X10S+MMeUO/LhMpChAzLJ0YBZNZEK+38WrWqNqt+foLMwt1EnZlUaz1isRQOLWjF/BryAGjuwqP7kIENwjzL7POmty/PEtidL3JfDXn/u0wiq/8fNvvjjpRAsG7HvKeEl3fEbdGf1+vTHSPQxQhxg6Ht1Lxvjn07nYLDGgpze7aerlBpriYR1qeKbj29NBfJ5KYc1kOdUFV1Ur5MlNI1Pb0QPc6dPf0amS2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-07-07 at 16:27 -0700, Ziyang Men wrote:
> On Tue, Jul 07, 2026 at 02:21:59AM -0700, Eduard Zingerman wrote:
> > On Mon, 2026-07-06 at 18:50 -0700, Shakeel Butt wrote:
> > > On Mon, Jul 06, 2026 at 05:17:50PM -0700, Eduard Zingerman wrote:
> > > > On Fri, 2026-07-03 at 21:56 -0700, Ziyang Men wrote:
> > > >=20
> > > > [...]
> > > >=20
> > > > Hi Ziyang,
> > > >=20
> > > > I'm a bit hesitant adding 2.5K lines of code to the BPF selftests,
> > > > as this code would need to be (a) maintained, (b) run at each CI in=
vocation.
> > > > Hence, the tests added need to be relevant for the BPF sub-system.
> > > >=20
> > > > Regarding the benchmarking part, as you state yourself:
> > > >=20
> > > > =C2=A0 > In my testing (a 60-CPU VM) the BPF path is roughly an ord=
er of magnitude
> > > > =C2=A0 > faster than the per-cgroup memory.stat parse for a whole-t=
ree scan, mainly
> > > > =C2=A0 > because it avoids the per-cgroup open/read and string pars=
ing.
> > > >=20
> > > > With this, I think the benchmarking code can be dropped altogether.
> > > >=20
> > > > Next, the three memcg_stat_{reader,churn,churn_percpu}.c files shar=
e a
> > > > lot of utility code almost verbatim (e.g. tree definition/construct=
ion).
> > > > Such duplication should be avoided.
> > > >=20
> > > > Finally, from the BPF point of view the test exercises the followin=
g functionality:
> > > > - kfuncs:
> > > > =C2=A0 - bpf_mem_cgroup_page_state
> > > > =C2=A0 - bpf_mem_cgroup_vm_events
> > > > =C2=A0 - bpf_put_mem_cgroup
> > > > =C2=A0 - bpf_get_mem_cgroup
> > > > - main iterator logic.
> > > >=20
> > > > All kfuncs but bpf_get_mem_cgroup() are thin wrappers around mm/mem=
control.c code,
> > > > all kfuncs including the bpf_get_mem_cgroup() are already exercised=
 in the selftests.
> > > > The iterator logic itself is covered by 8 sub-tests in the prog_tes=
ts/cgroup_iter.c.
> > > > Hence two questions:
> > > > - What do these new tests add in terms of tests coverage?
> > > > - Why do BPF selftests need to exercise the churn and churn_percpu =
scenarios?
> > > >=20
> > > > Shakeel, could you please comment as well?
> > >=20
> > > Hi Eduard,
> > >=20
> > > Thanks a lot for taking a look. The main motivation I had behind requ=
esting
> > > Ziyang to send this series (beside making him learn the tooling and p=
rocess of
> > > sending patches to lkml) was to have a reference implementation and p=
erformance
> > > comparison for BPF based cgroup/memcg stats collection.
> > >=20
> > > However you have correctly pointed out that selftests might not be th=
e right
> > > place for such kind of code as selftests are more focused on function=
al tests
> > > and run by a lot of CIs while this is a performance benchmarking code=
.
> > >=20
> > > I am wondering if there is a place for this benchmarking code in kern=
el under
> > > tools folder but archiving it on lkml might be good enough and should=
 be easily
> > > searchable. Anyways thanks again for your time.
> >=20
> > Hi Shakeel,
> >=20
> > We do have bpf benchmarks in the kernel tree, the entry point is
> > tools/testing/selftests/bpf/bench.c. These are supposed to be
> > performance measurements and are executed manually from time to time
> > (quite rarely, as far as I understand), not by CI.
> > However, if I understand Ziyang's assessment correctly, this code is
> > not really a performance test, but kind of a load test.
> >=20
> > Thanks,
> > Eduard
>=20
> Hi Eduard,
>=20
> Thanks a lot for the review. Yes, as Shakeel mentioned, the performance
> comparison for BPF-based cgroup stats collection was the original motivat=
ion.

You said yourself that the test is comparing an in-kernel walk to
parsing strings and opening files.

> But the patch also carries functional value: alongside that comparison, i=
t
> checks the correctness of the stats the kfuncs return.
>=20
> Let me first answer the main question -- what these tests add over what w=
e
> already have -- and then lay out a plan.
>=20
> First, the static test (memcg_stat_reader) vs the existing cgroup_iter_me=
mcg.
>=20
> The existing test calls the kfuncs, but for each value it only checks whe=
ther it
> is greater than zero. For example, in prog_tests/cgroup_iter_memcg.c:
>=20
>      memset(map, 1, len);                    /* dirty some anon */
>      if (!ASSERT_OK(read_stats(link), "read stats"))
>              goto cleanup;
>      ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val");
>=20
> It never checks the value is actually correct -- i.e. compares it against=
 the
> value in cgroupfs -- only that it is non-zero.
>=20
> Besides, it also walks a single cgroup:
>=20
>      .cgroup.order =3D BPF_CGROUP_ITER_SELF_ONLY,
>=20
> and reads only five fields.

Arguably one of the the cgroup_iter_memcg.c tests can be extended to
allocate some mem and check if the value is reflected in the stats.
But there is a line between MM tests and BPF tests.
All BPF kfuncs except iterator logic itself are thin wrappers on
top of the existing MM functionality. Hence, I don't think that
BPF selftests are a place to stress-test these things.

>=20
> The memcg_stat_reader in this patch adds three things:
>=20
>    1. It compares the numbers. It reads the stats through the kfuncs and =
checks
>       they match the values in memory.stat, instead of only checking they=
 are
>       non-zero (memcg_stat_reader.c, check_correctness()):
>=20
>          /*
>           * anon (NR_ANON_MAPPED) is rstat-flushed and, with the charger
>           * stopped, deterministic: BPF and memory.stat must agree.
>           */
>          if ((b.anon > f.anon ? b.anon - f.anon
>                               : f.anon - b.anon) > anon_tol)
>                  anon_mism++;
>          ...
>          ASSERT_EQ(anon_mism, 0, "bpf vs file anon (rstat-flushed)");
>=20
>       This is the main gap: b.anon comes from the kfunc, f.anon from pars=
ing
>       memory.stat, and the test requires them to agree.

> "This is the main gap"
I'd prefer interacting with a human, not LLM.

>    2. It covers a whole subtree, not a single cgroup:
>=20
>          linfo.cgroup.order =3D BPF_CGROUP_ITER_DESCENDANTS_PRE;
>    3. It reads a much broader field set (~40 fields, collect_full_stats()=
).
>       Minor.

I don't think that it's responsibility of BPF selftests to check all
these fields.

> Second, the churn test adds something the static test cannot.
>=20
> These counters are kept separately on each CPU for speed, and are only ad=
ded
> together when the code "flushes" them. The existing test does call the fl=
ush,
> right before reading (progs/cgroup_iter_memcg.c):
>=20
>      bpf_mem_cgroup_flush_stats(memcg);
>      memcg_query.nr_anon_mapped =3D bpf_mem_cgroup_page_state(
>              memcg, bpf_core_enum_value(enum node_stat_item, NR_ANON_MAPP=
ED));
>=20
> But if the cgroup is idle there is nothing to add up, so the flush does n=
o real
> work -- and since the result is only checked for non-zero, nothing verifi=
es the
> flush gathered anything. If bpf_mem_cgroup_flush_stats() were replaced by=
 an
> empty stub, this test would very likely still pass (the kernel also flush=
es on
> its own, periodically and on thresholds).
>=20
> With activity going on, especially spread across several CPUs, we can mak=
e the
> flush do real work and then check it by comparing the numbers after the a=
ctivity
> stops. That flush check is missing from all of the current tests, and thi=
s is
> where memcg_stat_churn / churn_percpu come in.

This sounds like an MM stress test.

> Finally, my plan:
>=20
>    1. Keep the static (value-correctness) test, or fold it into cgroup_it=
er_memcg
>       if that works better. I also noticed that several kfuncs are not ca=
lled by
>        any test today (no callers anywhere under tools/testing/selftests/=
bpf/,
>        only __ksym declarations in vmlinux.h): bpf_get_root_mem_cgroup,
>        bpf_mem_cgroup_usage, and bpf_mem_cgroup_memory_events. The static=
 test
>        would be a good place to cover them too.

From BPF perspective the test is over-complicated.
There is no need for a generic tree construction.
Creating a hierarchy of several cgroups, allocating memory within
these cgroups and walking them would work perfectly fine.
Existing selftests already do that. Aside from querying actual memory
amount what else do you want to cover?

>    2. Keep only one of the two churn tests -- most likely the per-CPU one=
, since
>       it is the stronger of the two -- and change its correctness check t=
o
>       actually verify the flush by comparing the numbers. The current che=
ck is
>       weak; it only checks non-zero values and that every cgroup was visi=
ted:
>=20
>          ASSERT_EQ(missing, 0, "all cgroups present in map");
>          ASSERT_GT(total_anon, 0, "tree carries anon under churn");

These are MM tests, not BPF tests.

>    3. Move the code these tests share into a common header, to remove the
>       duplication you pointed out. Or we can combine these two tests into=
 a
>       single one if works better.
>=20
>    4. Keep the focus on functional testing in the selftests. The file-vs-=
BPF
>       timing could stay as an extra bonus -- printed only as informationa=
l
>       output in verbose mode, never as pass/fail -- but I'm happy to move=
 that
>       comparison to the bench framework if you think it fits better there=
.
>=20
> Please let me know if you have any concerns with this plan. I am happy to=
 take
> any suggestions on how to improve the tests, or to change the focus of th=
e
> selftests
>=20
> Thanks again,
> Ziyang

