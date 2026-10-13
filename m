Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC9FCA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 02:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88376B0088; Mon, 12 Oct 2026 22:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60816B008A; Mon, 12 Oct 2026 22:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975DE6B008C; Mon, 12 Oct 2026 22:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66DA06B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:17:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE7984091C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:17:11 +0000 (UTC)
X-FDA: 85315990662.10.F6E06CA
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00686140006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:17:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S6dPpvvN;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791857830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIn2x59SlJfeG2aH0jkfT5zU4fOVP6oTpHe5FuJew3U=;
	b=oUuGUROCmIrmKPdzIu16ShkR3okq162y4AtWJbhXmKgS+by1auPO6AGXxGmVy0Z/VQ/bH0
	5twJQXpx/iW5v9lTlUNzDJbhGp5LC9B2GNsaGVgtt6qpbzsqHS3fwPkCRJ2axJv3xonAFN
	iy7JXWumv90nIboMieNGTnzkNfSQDR4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791857830;
	b=cTV5YhZbTjxXpNt6XzFmdW29Qb/a5YcSU+Yb+neDgYDnz1K3RFHmZp1S87MHFV4f4SLg57
	uynB52DVgMpHDh7oBScuTovDxTJOu86LzTkPz09jkUPISd9Se8/9wuZfsmzNrhwbcyjOae
	Z3R98Bgyy3KKTranyDNxEO0AmAayrWc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S6dPpvvN;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-675617e81f9so2455615d50.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:17:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791857829; cv=none;
        d=google.com; s=arc-20260327;
        b=q2A7I+G4eNCI/DNJ15zyIaXkaU8LkuKcpNaqWRHcTFxErbqLYNVzlPwXKE4Ay69p2K
         K7zM9PfSUIG+tORDN/M0aSIZeBoD811C0iKW9Do+WloHAUiMRaE875CemMN5zzSp/oyp
         Tu266i6lm3w8GHZ1dsx6ZgNJIGi5eDloqor5iqjjCBFdJdr+mG5LkXpq7v7o/UEydmP9
         fmSFt1Iz6fc2ARH551DCjc5o1H5I0/xVXDUltCPMUzV4s8ZCbJgZDXx+aEHaPJvvuM/+
         2JCLx4upptrk6ezfeV3+dv/eIhhaab2LwvAw+PbLfqTnlzyYb0Y1rG75jfLsi+bDDIqJ
         Au7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yIn2x59SlJfeG2aH0jkfT5zU4fOVP6oTpHe5FuJew3U=;
        fh=FwkzBx/x/YUkJwwXlpfGB54JB60XpHDYn2OXqfHThCs=;
        b=XUGIR+xpEUAi4oYFnDm0uafrhyCJCj0sUYmqWBBaZmITu0RNj6hLx0+bOmf6VDmM3B
         Gsf4SFS3zIQH9XBszpXBnEym5QvohSyMlHJjeZSRlmhlZ0Yt19ruR0/XlpgoBn5fabki
         pnyhxxWrfAI3Q7XnPxfpXfDYWqDVEKqOm+6Ndbiq9GOTB91od7h/iQvc975NbkS/fxrg
         4pT6HfMLYC+nk+1SlyXSiiQNhRNkwEZgh4ykAE0z+skv5C8dbC3XBkKuL7TaiJfc5CY1
         N3N7pv//gzKnV/ZjTv9zuDxUlEYbpLeD9XUK9WwA+X4+5fbB2Js+zT86goJ1sK7sjLCj
         b3lQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791857829; x=1792462629; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yIn2x59SlJfeG2aH0jkfT5zU4fOVP6oTpHe5FuJew3U=;
        b=S6dPpvvNWyo16LYnlEfpNwTq9DfBBx/op3Ut8THsUuHKQ6yPbU/h41MfJbMnMk4A+Y
         lnIGZZQIkphwkHPq6AG8vsDOVoZ0okuVTjZGtDbqtJuGuVo/z5Zs3VYq33EZL59iyDux
         SEAZ55e+MYw53tF5b0k5MPiPqaPTy7HFMGLaJsUYIcjTzT5bo6bo4Mczrg6kuepZDJAD
         9QfNs786LVPzS/o44mMxmMkkKLJe6yaUM8chDZH/z8PTejHqez7Iz8eOquSllahniU1C
         2PwX1OZOFgHAtRqg2FK2HX/3Ydu8WCd2Cr0NpiLHlvufZeF67UGQMfpYQY8dxZX7W7Jb
         iHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791857829; x=1792462629;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yIn2x59SlJfeG2aH0jkfT5zU4fOVP6oTpHe5FuJew3U=;
        b=gSOj6DAFMQ0PU0KxZsd9L7Uu2zyBvAggRZaQBXFI/cp+XSLc3B1RCstkQpQPMj4IwR
         p9YHQ6haR7R1n/4gWMRPlFN/I1FISSiYt7REKY/Nl2avS0teODXpIXupMxgSf44F99a4
         fflaStjtVGNuSSp1ogmoRErsHlG/ekW+aTDetTw/Q5LakuDW/WR95chkfEORnVV0yVxh
         lRYJqSLxXm9NOry/eVArE00hOq0+qNy9EIhjbmw8jDWhAZRndi1VM/qU+gaj6P0n+jnk
         PvPC8d72s8KVWIvgrallAumVaL2rNGfFTk+lCfoufysKa15NhKa8Oy3WeyZIaaAryhDB
         ekaQ==
X-Forwarded-Encrypted: i=1; AKwUvBw/m12N1+eFym22HjSyPWjliTgarePi1aHFYjzFWe1ubNFP6sz3QwI/SyJolV23p7CZKvp824kcEA==@kvack.org
X-Gm-Message-State: AFq9FYJWFxNkX/3YLiGPrXT9UhXQccbDT2Tx6hoQOw4A4CFsT9oLKJbs
	xJ7NUvh5laA0lHTFIu479r0A9g8SsMZaUzb8C99a8M5XYkfoHYj5UyqGXAfFN8ZUehbDgzt3xKa
	qPwkbOMOy0xTNj5JMBo37TWG4oKWTmZY=
X-Gm-Gg: AYBFou0Cyb0Q7YtnUUTvTBiDakr0hk99Hj8ucr0O4M9qClpcrbNRYsmLIMSd6wQSFRb
	AIDCktopGa+tw1gq7ECc6HAVWZHGRA8Z2qAxUC56b/fSdetWoP/a+U6de2Yi9vtCEaohAnC9iHA
	yu/5sAEEAVX5JWtp5Agk3GtjFHMKBVDsXqdfHkKLERA+eZYb/pnqHFutC54wTowvb80a4UGaWMq
	g5dcpbByvjdzHMOgaYxe2z7TuT+HRsD7G1p0oZ+Zqmt65Xwg4l8iEiIcd9dXIRhglSCCfndgbIF
	ZfZAfro83nMvLkxnNd20WO424/GPFe4YOMddWZsmt36aCfiYz+JJ85HVenQH4yVvaLHCI1DAafg
	H1hv0OTjI5w==
X-Received: by 2002:a05:690e:1383:b0:671:7e90:70f4 with SMTP id
 956f58d0204a3-6793678d44dmr3771206d50.10.1791857828879; Mon, 12 Oct 2026
 19:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <20261012120438.52849-1-laoar.shao@gmail.com> <d9a3367a1852158f60cc2e89677fb12f@kernel.org>
In-Reply-To: <d9a3367a1852158f60cc2e89677fb12f@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 13 Oct 2026 10:16:32 +0800
X-Gm-Features: AclHuK-uH2UB1rAnuK0zhwCfF8NmZTYihTg9_NG0CYh1qo0sK-2XTafwZpGcmUQ
Message-ID: <CALOAHbBE_1ssK_26c-UY7N6WxhkVNpB6v9WACVGaOiWZ5zchCA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
To: Tejun Heo <tj@kernel.org>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00686140006
X-Stat-Signature: 11ftoxumgporrp4qnszkj8xranqt9e6d
X-HE-Tag: 1791857829-659541
X-HE-Meta: U2FsdGVkX19V49jwDUoW3AHdxTf2Da2F4i4hAmq7JOp9LaXiNzytt1uT8GsJK06R1JKtH2eMs6/zxzjj7uZv8ke3ACPAZhvt42tkn2I+uBMv/+l9uFvUy2UZfCVGVcSTbpDOKDM+uR8f86xBwZ4XNo/RtDl1lx/KU9X9oL8e3TgwnQBY5Gjc+B74YTIL82XpMSPXxz+yWEgUz6dQ46qLOsxuWOv1w7MWBROCuLchxweapcpVABMtoxQELjBs7YZ3+HyLBRsGqrvtuN7MPmkvP3LDibrO7NLyJAItqf1NYN9ivDo5+e3GXpc1S1XzeDtisaEUhkIrY0sZ5dCbjY0k5jbKEU2PIZotT40DSIjiWdUsxlCIVQS3S9rNoyQ+V1Wm0eyRWjbmw3ShYIuNqAHgFS7ZawAm2L1FtJwW2/5KaDhMJxl+Ws0b9eQl4n6HUpqbei4Ou0MqXlc4CnfpIrqM5aeAkf8GA1/WIOdCwbacvnm2w77tZ9/3FO02tatvs7E6R+145aKy24X3V7oApJyGQxutgmCDu9pJMXVizg2mhk5k5PEopip+yS3LxBgWhK25qbmeBNlZMSFmkfXrtwQQClmEIHF9gK6sMTYJkTp4vouNWEpSs5BuTdA31olTXt155E0M+U9JqUhY20SBGIFhenjxd/EOtVUb9smlp91eLZFGS0zXXgYNQIOPoZTMl0bGBmXpt7xhPEjXd2QuspMvanyH5UugOFUjP6L4MmoknSYS4IbSTgAdc9wWUh8cFjgfspwYghgjtzB5nP04YU7p6fXHeExWjhjc19c53XtZS5BY4HRLKIBzYI4EB6WVjkr9L5k9G28Wvj8lQgelTBJbx23Kd4WWrwlPrfiHVg8zWeJuCgj26SAobKuXDapIo4qmMXGk9d6Tfe76ZLeNybbBXKyWEajbM4TGhkXnnG0cK85Xkhe+AAfgQft69wQuDUOZpuUq5gYHyVKdcje1Yj4
 fLQnCCYS
 t+JoXP+VGRVHy9QdiVhgc1lyfFEp5X9tbO2v/lmlMxOxvxaeVYYGJqk4RFzXuEAUyl/jnpQc57GkKIuVsgHc1BBu9YhWcO4IdCr16ZnrhlHBFrUoDLUyxyD6JTA0Nkd7fWDc+IMYSyOv+8FEehFcEqVDU8toDxBjVvStV9arPZ/ecueVTrhENxdsvDqHPIuanjSLp7BqrG3hvgph/WESFUw8EsFLuzte+Suz1hTQeQZIEpiGVK1btC6QerN4oCmhyLWkm6FaXlxjL5q/n7nFglDdVlv0xAjDSqEQhFP4HeAK6q/WcDhuxvCND9dRoJNC7rkmAnKgC6UPt8Hr/frtFEtNzkFoKNan+OIwW13rql9GTUhyqHVsN4j89fA+eeT9oLfeKkWGylvH/+n87IoAozrvD0MEv4HTMbmUFTuigPy0qUZ6yYv0bYAkOCa9VYkC8cVe0Zb2GttgZVNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 1:51=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Mon, Oct 12, 2026 at 08:04:35PM +0800, Yafang Shao wrote:
> > This series adds a bpf_numab_ops struct_ops which attaches to a
> > cgroup. The kernel consults the policies of the matching cgroup and of
> > every ancestor and combines what they return.
>
> The op doesn't compute anything. It returns a fixed mode per cgroup and
> that's all the series uses it for. BPF is unnecessary here. This is a
> prctl() feature, not a struct_ops one.

Part of the consults are keyed on struct folio rather than struct
task_struct: the folio surface answers from the folio's memcg, the
owner's request, not the touching task's. I don't see how to key
these callsites to a per-task setting.  Please correct me if I'm
wrong.

prctl() is also a stable uAPI rather than a kernel-internal
interface: a new option is frozen the day it merges, which is a
poor fit for a feature whose semantics are still moving.  The
struct_ops/kfunc surface is explicitly exempt from the uAPI
stability rules, which is what lets us experiment with the kernel
feature rapidly.

--=20
Regards
Yafang

