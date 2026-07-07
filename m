Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C8E9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81566B00A2; Tue,  7 Jul 2026 05:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D317C6B00A4; Tue,  7 Jul 2026 05:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22C16B00A5; Tue,  7 Jul 2026 05:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 882D86B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:22:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12A6F120397
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:22:06 +0000 (UTC)
X-FDA: 84961439052.16.81A8927
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37CC7C000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:22:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BEtP+4bc;
	spf=pass (imf28.hostedemail.com: domain of eddyz87@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=eddyz87@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783416124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czp6DDn3Tg1L7Caksu341JziUocBqKvToENHXSg/2y4=;
	b=7WsWYszwqCiIVbrQu/tlWtmaG3MGV8nK3UOSh6f1J/lquPRjGYkNB4f24RpaePl9XE/Kl1
	mvouhEYwI89CKAxopxhS3+q6/+lEJSXkfe+Ub03z7FXu+l2MdqcfkaCr1sMjBvtNdEj+wi
	mmIHd7ig9TbSbZKrTf8Kg8Jmak9LOv8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BEtP+4bc;
	spf=pass (imf28.hostedemail.com: domain of eddyz87@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=eddyz87@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783416124;
	b=NyBz/mkhFKvBJX7e2xChq3RNPVA/QCfDwHY18++Ky/ZfuQqKL+VeEpWoGgQqBu9Qg2EsTM
	zvKWir6B/ttV9geryvtVqLI+eYAkffmn3imurBEtQRJGusPyVrJtoKN/4pOMBVXruaNcSP
	XnSR1wC7cPOtpdGFXTZhS9Zolq1J7UM=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so1816513a91.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 02:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783416123; x=1784020923; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=czp6DDn3Tg1L7Caksu341JziUocBqKvToENHXSg/2y4=;
        b=BEtP+4bcW85VIwOMz7LFmXMYqB2G68hlpntswD98+ZvbNSB3a+krs2HjaOQYsFGAib
         miWEd8q2QwFk/AEXBMRpguyzjrhdX9NHWxpJbKs5PVglo6t6gGd0TM+pfeAZXpRHkYOI
         HGBFNFlM7YMRLDXvpSSSQ/c1+UwyKgJYDaSr104mIMvdyTPzsMoS4UWNdfZWY3wPEEsS
         uOOpvRps8ilUsHPtjwR2nfByarCLgRoPPViUqxIbCcX43eWvABwnK/gmCtkV2UVZRHGm
         8NWNXsqtDsLCa05utso98mr/Fyt8kD4cXt/Fly7ejDEkjlQqr7hmy57MoOYkhjq4xBG4
         TB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783416123; x=1784020923;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=czp6DDn3Tg1L7Caksu341JziUocBqKvToENHXSg/2y4=;
        b=c8Padg8GuXC61jJNzcN4H1xP8bxrKWvJQfozOr4fUb4ieXB4VFKrzpBWXYqf8/TEEc
         H8VMjyVzSh34T9pX1h3U9YJesPWUfxmFcOk6jqWR4mYW78SI/DRFBpA8Q/f1dDOXn7Zs
         lv2V6X8EBuYjCHYva3XEAGX83NIQ7pjaGVbZEj2Cz4RY1Xh57Bj/SYLVJJ4X8rpbcR/u
         RMPdkvdUu261CTLrAX8ItETeHj/mzVX1U9pnTZ+y+JKT3nHBy6Xd1cKDnYtykGXh15aF
         3iN36oqdiUR/w+WDiNmMDluSELAdRBDIH0g20OOxkXzkZAELzKkcWhxmPdCBtwVej8m+
         0qaA==
X-Forwarded-Encrypted: i=1; AHgh+Rqzzvf5om6ZJfJDVDcxxBSOOAHEcwZXoR8YsRUsxcLLpbihlyCyhMXbPcf/VI1ZiCeRZ88s8L+2rQ==@kvack.org
X-Gm-Message-State: AOJu0YxSl1kTuvG9q1eTRdCrjVAXd8qmLKq3KyQ9909USRueBBLHPpyP
	Os6yFBSCOGbalguWtFwQBGoTeCJdI8ei9EQGAOUSbJY+1crX4b00Q09G
X-Gm-Gg: AfdE7ckUQWP1/Xor2P9ILgiLQOI8jb6hHzWFS6mW9X3ehk8luyrwDx+Ha9+DpTRt19v
	q8A4+RIMjTphBd4bWqYEkATPjKec+ii/TiLQ2fXYFqQiqVg2HLstukMVZzkdVV+UfYoU33pu0rm
	+JXkkVNirDY5WJuAn0xSzx4X+jhfkSXLrGCMdJs7+HfXGk07v1JfvWC3bSJ3FKKtMJPwwndaetT
	w0JymfhsYOKXgEpVKqnxtMAvFzDfm5lDw9hozPcpSu35Q96DDmNyUz9zlB0+hzUFQKDYeQHWHqs
	RJDaS6zuUvfwuS8WKircaRGtb9CBcTGDg2kKaPEn8IcqXFlfJliA/NQDu/zTzQnld2vmGqb/wbX
	45zn4BTPS7KPDRmGsiN1DkfNHLMOvS0pj9di97OocOvZsEq/nUW4FD6MxxlgWyqVUQcBro7On16
	5BKbMOqTGal4TNKBkwet+bukyHnbPKZc2M6ZXm33D0Ha18qYCINpo=
X-Received: by 2002:a17:90b:5350:b0:37f:9cdf:f03d with SMTP id 98e67ed59e1d1-38757894fc7mr4396669a91.32.1783416123050;
        Tue, 07 Jul 2026 02:22:03 -0700 (PDT)
Received: from [192.168.0.13] ([38.34.87.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-387d36676easm759200a91.9.2026.07.07.02.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 02:22:02 -0700 (PDT)
Message-ID: <eccfd9a8dd1af1668e142b9b866194333647b0d5.camel@gmail.com>
Subject: Re: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg
 stat readers
From: Eduard Zingerman <eddyz87@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Ziyang Men <ziyang.meme@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
  Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Kumar Kartikeya Dwivedi	 <memxor@gmail.com>,
 bpf@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,  Song Liu
 <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>,  Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan
 <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	kernel-team@meta.com, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2026 02:21:59 -0700
In-Reply-To: <akxW5dzvR9e2CfGq@linux.dev>
References: <20260704045617.487664-1-ziyang.meme@gmail.com>
	 <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
	 <akxW5dzvR9e2CfGq@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-10 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 37CC7C000C
X-Stat-Signature: 8wyftunagmuak81qqzca8jupkwufz3ck
X-HE-Tag: 1783416124-59772
X-HE-Meta: U2FsdGVkX1/Wc0ddmL15Sm5ta56TGx3hZrMulamFyjfYxzuPM6Kl86FdNDFCNDD5JJ0CM2/AQR1DcqGjG5pWu44PiCjAF73LwldXEEyAHluURxBebpOEs/jYR1V+NcLlG+f7Cu0ib9oLfgp+HnYQ6j+mwDlG2UnpinOPmREEHukjN6DztQJEFqSsiO7FB3TySCNHivb0yPPMKTuGGhVaLbsyDVdrX6qD46p+9inH/1KnNahbAwgAXR188eTswGfFKvcmYWcQSZ7WoHezK9MxcUvhBVgSvA4BDX8LQQoIVxufVk0xgdnQ8P28x7aXXQyBNC56kMPMTfUZSZ+/Iqwj+SBUaNgodwxv3ACO5b8ahXoG4bSbYCGqV7jgnlbkwZ+tK8p6R2wcGCZrKHTmE3qifG1V4ZaNt/k3zvHwEgdtXHuXSdo1Bs6zb1WMcN2sBgZ8iPBmSTjupPhDHA03oBzCwINrsiAPTqE/ySr9oFEMb5TrVZc08tLbIcG4vXcq1JqrPrDkh+l5iHD8YtBkJgHzkx80maqfCtyTWxRTZezHW84LyBzfeJVG/PnsVFwR3zcNk6afIvlbxpDDFtEHhOA4g7rD95lCWDORm/NPCPf4cij2xLyz0Ne7u/vtyJrxaCdD5zInGBf5O0bZXZLVMw0X0SVBgNXhAtfhbGhqlTpjisc1U0j1gDKn+mZr1qkGNg1vyHyBTerPM8XvKxLJ8F8SuQNGIKMefw/UOxon8fMDhRt4+ay7Z8dIkzLpK66PXOEc6CezPYYPt+C+E+n767YZhzOB3OdEAo/mUjRKCWh1D6Oh+WqOxOzDXX7o3UqySpk3in2by7Ol92Vc8BPkvKfwJxhoR5Yz9Qh/VWk0ElFbdXu5zZi5fRlpPZ2MTWXsO9rmdfQdm2hVnu4Ln/zysO6aWLM5oHK6GjjXJO3LyNMEJAWWmwRMXfsfsrmvgL8WfGIj7K+7Vou6NnyDiExH5S/
 4y9iWwJ+
 k1Ich/25+tvjZx5ngQmCzdonN9fru3kpUJfK9yh2LdLn2RnRPs8Ofqi0v+YSbFzQGMzQmiRrHzXDLsJP3A0g+tty9hEZ4aFkWwxMkvan/U2Ylel8mbj/rW/aeUKdDrDq4MODzUErZVncClFraLgIeXvxJSA1lYHMcRNnb+I7KmyZ3D5mxUTwrRuK65BCwGNvSdMrop1Sm2+JBpZmx9xCFwc8/vYdUAvc3I4BIFVu0JbNsqlm6YxkS12+xpvyhE2EC+mK8RHvpv3+Ef5pWmiHFxuOa4UpJgmAFM3Hm2IzLHaM8CgaaJhnUqrYb9ngTxIajEw8QRQWy0EWVzHBZHbiN0YDk44qfiBsaCVz0N3pXGe7rAYkmZmlQ50zBglDYVKmBy1pLcXIPU7LnhR3Up7RA8H3rfUbNRzeaB2N7BaTC6/4zaU0v2J2IHUMPpoCSbo6xsHlYqQsrcLoYuPPiBqT2dn7wehA3D42/RHI0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-07-06 at 18:50 -0700, Shakeel Butt wrote:
> On Mon, Jul 06, 2026 at 05:17:50PM -0700, Eduard Zingerman wrote:
> > On Fri, 2026-07-03 at 21:56 -0700, Ziyang Men wrote:
> >=20
> > [...]
> >=20
> > Hi Ziyang,
> >=20
> > I'm a bit hesitant adding 2.5K lines of code to the BPF selftests,
> > as this code would need to be (a) maintained, (b) run at each CI invoca=
tion.
> > Hence, the tests added need to be relevant for the BPF sub-system.
> >=20
> > Regarding the benchmarking part, as you state yourself:
> >=20
> > =C2=A0 > In my testing (a 60-CPU VM) the BPF path is roughly an order o=
f magnitude
> > =C2=A0 > faster than the per-cgroup memory.stat parse for a whole-tree =
scan, mainly
> > =C2=A0 > because it avoids the per-cgroup open/read and string parsing.
> >=20
> > With this, I think the benchmarking code can be dropped altogether.
> >=20
> > Next, the three memcg_stat_{reader,churn,churn_percpu}.c files share a
> > lot of utility code almost verbatim (e.g. tree definition/construction)=
.
> > Such duplication should be avoided.
> >=20
> > Finally, from the BPF point of view the test exercises the following fu=
nctionality:
> > - kfuncs:
> > =C2=A0 - bpf_mem_cgroup_page_state
> > =C2=A0 - bpf_mem_cgroup_vm_events
> > =C2=A0 - bpf_put_mem_cgroup
> > =C2=A0 - bpf_get_mem_cgroup
> > - main iterator logic.
> >=20
> > All kfuncs but bpf_get_mem_cgroup() are thin wrappers around mm/memcont=
rol.c code,
> > all kfuncs including the bpf_get_mem_cgroup() are already exercised in =
the selftests.
> > The iterator logic itself is covered by 8 sub-tests in the prog_tests/c=
group_iter.c.
> > Hence two questions:
> > - What do these new tests add in terms of tests coverage?
> > - Why do BPF selftests need to exercise the churn and churn_percpu scen=
arios?
> >=20
> > Shakeel, could you please comment as well?
>=20
> Hi Eduard,
>=20
> Thanks a lot for taking a look. The main motivation I had behind requesti=
ng
> Ziyang to send this series (beside making him learn the tooling and proce=
ss of
> sending patches to lkml) was to have a reference implementation and perfo=
rmance
> comparison for BPF based cgroup/memcg stats collection.
>=20
> However you have correctly pointed out that selftests might not be the ri=
ght
> place for such kind of code as selftests are more focused on functional t=
ests
> and run by a lot of CIs while this is a performance benchmarking code.
>=20
> I am wondering if there is a place for this benchmarking code in kernel u=
nder
> tools folder but archiving it on lkml might be good enough and should be =
easily
> searchable. Anyways thanks again for your time.

Hi Shakeel,

We do have bpf benchmarks in the kernel tree, the entry point is
tools/testing/selftests/bpf/bench.c. These are supposed to be
performance measurements and are executed manually from time to time
(quite rarely, as far as I understand), not by CI.
However, if I understand Ziyang's assessment correctly, this code is
not really a performance test, but kind of a load test.

Thanks,
Eduard

