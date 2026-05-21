Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C517CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1591E6B00AB; Thu, 21 May 2026 00:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109B96B00AC; Thu, 21 May 2026 00:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A276B00AD; Thu, 21 May 2026 00:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E25356B00AB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:15:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 930B58D9A1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:15:30 +0000 (UTC)
X-FDA: 84790112820.20.1A47A31
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8BB8120008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:15:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=aCSkqgkf;
	spf=pass (imf29.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336928; a=rsa-sha256;
	cv=none;
	b=jmwagVxJGy0usF0voYQb5UVu6TIOLAx5KkCnGzggOAjkobRvyKd8P4bUhS91ocTT5a0zX1
	dRCm0LPSBsStwCmYeQTzoDdhGe/j+M6HJRbQSp1Kr7wlzMFyuOu8z9dxyQvlEpByyNNrC7
	XIH3gbFxpbjU5TjKeo3qFRiT5eskmeI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=aCSkqgkf;
	spf=pass (imf29.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mx7h0My419s2P7k1BFl0yESBgvzIQJC2piNf13boJc=;
	b=KDiMd0+OImZ5nrnRYy/GGWeBx7oIVMFtVPSSWyKaRuEY4zekjstLteuZATQZJ3Ci7PcQjX
	QKexDhEEx1T9EKX7bRT8Lr0TqJe2iA4ixE4SnUx7o1Xm/a+G6waj7NkCz6xWLE4PcKyBRT
	svYJwSKNDrcqhr+ZiKC/Q3XLmIr1AiQ=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b4583f0a1aso36657225ad.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 21:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1779336927; x=1779941727; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mx7h0My419s2P7k1BFl0yESBgvzIQJC2piNf13boJc=;
        b=aCSkqgkfcDBBSUf5K/o1x+CCRjjMA6x+gndB7w5c+drRgKrtK9kItLoUeolvdfR+Q5
         wroK1I/D2lMWDWMAxud4tjWSmkr52gKHK9ws32yFoP50jPNkrTSB7G58yiwHhHwB6a5u
         s6pg3dU/tGkOBjFe3llzqHU51NkKMmJehaNBUlQczofeThb/fRWaGXSEbNA3Dd3SvU2F
         ODxuMWBTsTV5EucA7ncveXFXt65JWE8d2h0TbHNYQEVdeXHJdTlXdt2D4zmJpAelBPDu
         zbQPOB1tTxMke3VipJLHbOB3eQDvtKGUJhuw4Bjm7auNPck6SNypsYUdtv7yEVwPhq91
         usTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779336927; x=1779941727;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8mx7h0My419s2P7k1BFl0yESBgvzIQJC2piNf13boJc=;
        b=OetkxXDoK88kiXR8LnN1GfzDfiYhzY2Kyz5TGaKzAFDndKX2mLL5oBT54/vdyZkRG5
         beKTI8e0tz3NsHo/OILvrWAr7YV1Nu9jfH1ojCeGwHJuCGyWZxeZO3iL26oTmeVeRxcG
         wbJMXk9edwBdlmrKySxtI6Grh6YRsht3zwdTMEGLqzLOPy9TrVhtC3F5fEj6vGmxZ2m4
         xvN0vT8+73R13MF2nTpGJQ2Gxkb9x9nq+8NDmdm7izjoNBSOGrwozqTFLmPOlxCHHpr8
         NxmAYlaGT6ovUos6xoGWayk9Di0AymVn7Mo12f1fjFHfcijF17gNA3og+rSfUQzG20q8
         ketw==
X-Forwarded-Encrypted: i=1; AFNElJ+Uu1fxM1awBKrh/mo7U9itsoFzfOF/L7UHfYTy/InInsHWyr0l/drk56FwUTxnvvmzzyy9W9o/xw==@kvack.org
X-Gm-Message-State: AOJu0Yw3Q1bECCInB2iT3URYPHDJLakzHl1/23NXrp/LH9LX1MlwI1yQ
	UuFrDwX2owrT1RUPsXnL/pp+NaaiwueZg+auKaER+tS70fejvvEWc1z9qvelP1Sarn0=
X-Gm-Gg: Acq92OEFyfx//m9m2IiX3r63wu/5O+7mQqjKWerOHRO9bcH2b1/pJ3t5EJh2ehDZaUY
	VA94YRc7TzX9EpQhDfuh9MotuMP2fwtmM5NOdvmoT2PJm5eHX4pIWLNd1d4a8ZcSZoiXew+P78z
	lZSRPLks5XsMzGC7RI3koHUdQ0oe9eNl2oFlY1rFl0u6vR0g+N2kyWYAOI1i/FjzADzJ5cr3Fno
	Vt3i50zOrqpXgJQ7/atk0kodSYHL9hU4T58mNxUbegblni5wyWthnIZRoUqYozGcWLjSCrTscUp
	8viE0KqPOb1iXPpcLB9LqlZ7KyAZkiT1+2e98s+lW7mLd9QltyCI8e9CPMeTssJPTEeMJHOHQBE
	XII6EKsDqjRy7LLAY080xDr29QWUVylKxTpVKTyzmQ34uIxFM3sucy9bCPktKGb7zGOmQReASaX
	KkS+sYGDaFPRk5sKTKWNrtxiHSR1//S76BfmI=
X-Received: by 2002:a17:902:c946:b0:2ae:5629:ac55 with SMTP id d9443c01a7336-2bea331d50dmr10441855ad.21.1779336927286;
        Wed, 20 May 2026 21:15:27 -0700 (PDT)
Received: from localhost ([2001:569:58a0:da00:a5c8:c4ce:f7c1:40c1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d234540sm234841675ad.79.2026.05.20.21.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 21:15:26 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 May 2026 00:15:26 -0400
Message-Id: <DIO2ARBBUOJX.1OJ5RVION2UH1@etsalapatis.com>
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Tejun Heo" <tj@kernel.org>, "David Vernet" <void@manifault.com>,
 "Andrea Righi" <arighi@nvidia.com>, "Changwoo Min" <changwoo@igalia.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>,
 <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] sched_ext: Require an arena for cid-form schedulers
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-7-tj@kernel.org>
In-Reply-To: <20260520235052.4180316-7-tj@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A8BB8120008
X-Rspamd-Server: rspam03
X-Stat-Signature: 5ug7a98agtpactbhiwik5uabc74tp61z
X-HE-Tag: 1779336928-807290
X-HE-Meta: U2FsdGVkX1/OSgMYGrRkNGFrD+9Z6BpvcugNtzdNgQZ6ka6YPPai5qxWVuYas5KwPcUgIOYLkL2Ox7GUSMGqJdUz48WuvZ6l4SLVfxfMngTG6TTu3xNKM1MPxZ59MAkxiPd4p1P5HfK3Dxeznr5BkqV/WRf2XBRr9dar0rnrMAkNaipLhI3eEtIJJ9Y410T6KCTWZ8e1QOBKGWrpYAZ9HT95qsDg8VmOo8afbKRGOs/5K43apGsjT9EDtyzuPVsfuRo8s1JY+FF36OpMKaK5fGn04fl0EixnNJflabPJjmjmmI12wcS4f/0m2a9EEMXU4Bk4g/2+ZRiCQyCE0aT6KHEgES9nysW8uyE2fAcQqLUFPbxb5umqUkk8gAaBO1zfiNSSJGBl7T8Lp/kohbkBGE5AbROxJARWiB+Qil4xVYR5MSIlK8KFI1FfYgz6Kswa+9f19/1hNDe/seiVFoXxQmygVamjT2rqpfq2wpZ2biL0GMzYlOa+ryM3obvuWAT6u5t1WZ37h6kKdAqzp9wvtwaA+rb6DoSS+yFbwz+JDbRWkwkHgnM1v//2AL0Fq7SBWrkoBF13PGh2z9WwiZ5sDX/Vf+6c9aS7P8RH1IU4TGDeo8+/k/mnW56CoFnCRWIMHHfgKs2BuTKYbwCZmpeNe0TKM9d8BCa5v71QOGRF+cBxE3fg9pOU4PV6EFfU1Jx+KFeVADN+V/SyIUpwXPPDnTn79mWMAGFDXxgurOeog3A8NEhCEaC4Gl16ExhCmxJ0TDgfJSD+1Hk5hUNog1fyJlf2FFzjR1VLM085MRR+QCup+TGn/uA9XqkobLPZm+k77Udqv8/BkuA/XfCP8ytxxRMbR9KTalSV2X3oQgwWmG/G9jMjlchwEpiBYLRz88Tu7sxTB9ZJFGTrQuwGZrmUPSknDPZNFhE1PupDoX3HyjDxXDCts9B8CWHz8lDj0ucxkjbbW8uYE+GxT+rIaWP
 mEExcTf/
 tX8vLib41u4h7GlIJq6kwq0oRPIdgftuObh6ej1Flj4TOgPWgAHJSUvSc36F5x0TV+tDjWHyXXUVTDsqlLxxbB+iQ7b7RVLbJUdE5qEvuT+QOYw8JbPh5slRkwZs6FB8rTd6WehpFo7HCbcAA/COl5yvDrJIelMSo7vZokVExotlELGpFMqewW5QvsL3R5BgJD+tg1/FWJiL6Dq0Va2+09q/J+huiEcVpuLKcYazxblqzv2tGNc8kxdmbrdZ0nqPPP4JLilX2rDIk/aXMU4PfJ1EUPd6NnaNMoFn+0GVHROT9XptkX9xyH+SgqQlrMr8MabrzMF1pP88WiL99AsWOe+OoXfDIJPWQV1imEtKmGVPRW0Ev73fP9OPC6R59HLYMQrISU8uspNPbGraKti9qwzsGvt1fdu78gdDRiMmWYs1bwF9tJeM/Cf02FW2evkEkkcidiA919nJ6Yo0T1sG49yeyr1s8OTDi9+J9NQ5rxomO+j+u8V32oE96uoh7SkJ54OZADkvz3dEqP5nRA6qNhCm1j+OUIUIcpYstXzV/7KZuzRmrvkC5dxF54H+HcLvnekPJvWHjkj4OaVGPulzN+AoLtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 20, 2026 at 7:50 PM EDT, Tejun Heo wrote:
> Upcoming patches will let the kernel place arena-resident scratch shared
> with the BPF program (e.g. per-CPU set_cmask cmask) so the BPF side can
> dereference it directly via __arena pointers, replacing the current
> cmask_copy_from_kernel() probe-read loop. That requires each cid-form
> scheduler to expose its arena to the kernel. Kernel- side accesses are
> recovered by the per-arena scratch-page mechanism.
>
> bpf_scx_reg_cid() walks the struct_ops member progs via
> bpf_struct_ops_for_each_prog() and reads each prog's arena via
> bpf_prog_arena(). The verifier enforces one arena per program, so each
> member prog contributes at most one arena. All non-NULL contributions mus=
t
> match and at least one member prog must use an arena. The map ref is held=
 on
> scx_sched and dropped on sched destroy. cpu-form schedulers (bpf_scx_reg)
> are unchanged - no arena requirement.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/sched/ext.c          | 56 ++++++++++++++++++++++++++++++++++++-
>  kernel/sched/ext_internal.h |  8 ++++++
>  2 files changed, 63 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
> index 9c458552d14f..56f94ac32ba0 100644
> --- a/kernel/sched/ext.c
> +++ b/kernel/sched/ext.c
> @@ -5003,6 +5003,8 @@ static void scx_sched_free_rcu_work(struct work_str=
uct *work)
> =20
>  	rhashtable_free_and_destroy(&sch->dsq_hash, NULL, NULL);
>  	free_exit_info(sch->exit_info);
> +	if (sch->arena_map)
> +		bpf_map_put(sch->arena_map);
>  	kfree(sch);
>  }
> =20
> @@ -6746,6 +6748,7 @@ struct scx_enable_cmd {
>  		struct sched_ext_ops_cid	*ops_cid;
>  	};
>  	bool			is_cid_type;
> +	struct bpf_map		*arena_map;	/* arena ref to transfer to sch */
>  	int			ret;
>  };
> =20
> @@ -6913,6 +6916,15 @@ static struct scx_sched *scx_alloc_and_add_sched(s=
truct scx_enable_cmd *cmd,
>  		return ERR_PTR(ret);
>  	}
>  #endif	/* CONFIG_EXT_SUB_SCHED */
> +
> +	/*
> +	 * Consume the arena_map ref bpf_scx_reg_cid() took. Defer to here so
> +	 * earlier failure paths leave cmd->arena_map set and bpf_scx_reg_cid
> +	 * drops the ref. After this point, sch owns the ref and any cleanup
> +	 * runs through scx_sched_free_rcu_work() which puts it.
> +	 */
> +	sch->arena_map =3D cmd->arena_map;
> +	cmd->arena_map =3D NULL;
>  	return sch;
> =20
>  #ifdef CONFIG_EXT_SUB_SCHED
> @@ -7898,11 +7910,53 @@ static int bpf_scx_reg(void *kdata, struct bpf_li=
nk *link)
>  	return scx_enable(&cmd, link);
>  }
> =20
> +struct scx_arena_scan {
> +	struct bpf_map	*arena;
> +	int		err;

Can we skip the int err here...

> +};
> +
> +/*
> + * The verifier enforces one arena per BPF program, so each struct_ops
> + * member prog contributes at most one arena via bpf_prog_arena().
> + * Require all non-NULL contributions to match.
> + */
> +static int scx_arena_scan_prog(struct bpf_prog *prog, void *data)
> +{
> +	struct scx_arena_scan *s =3D data;
> +	struct bpf_map *arena =3D bpf_prog_arena(prog);
> +
> +	if (!arena)
> +		return 0;
> +	if (s->arena && s->arena !=3D arena) {
> +		s->err =3D -EINVAL;

...and just directly return -EINVAL here? bpf_struct_ops_for_each_prog
breaks when we return non-zero so do we need the extra scx_arena_scan
struct?

> +		return 1;
> +	}
> +	s->arena =3D arena;
> +	return 0;
> +}
> +
>  static int bpf_scx_reg_cid(void *kdata, struct bpf_link *link)
>  {
>  	struct scx_enable_cmd cmd =3D { .ops_cid =3D kdata, .is_cid_type =3D tr=
ue };
> +	struct scx_arena_scan scan =3D {};
> +	int ret;
> =20
> -	return scx_enable(&cmd, link);
> +	bpf_struct_ops_for_each_prog(kdata, scx_arena_scan_prog, &scan);
> +	if (scan.err) {
> +		pr_err("sched_ext: cid-form scheduler uses multiple arena maps\n");
> +		return scan.err;
> +	}
> +	if (!scan.arena) {
> +		pr_err("sched_ext: cid-form scheduler must use a BPF arena map\n");
> +		return -EINVAL;
> +	}
> +
> +	bpf_map_inc(scan.arena);
> +	cmd.arena_map =3D scan.arena;
> +	ret =3D scx_enable(&cmd, link);
> +	if (cmd.arena_map)		/* not consumed by scx_alloc_and_add_sched() */
> +		bpf_map_put(cmd.arena_map);
> +	return ret;
>  }
> =20
>  static void bpf_scx_unreg(void *kdata, struct bpf_link *link)
> diff --git a/kernel/sched/ext_internal.h b/kernel/sched/ext_internal.h
> index 7258aea94b9f..d40cfd29ddaa 100644
> --- a/kernel/sched/ext_internal.h
> +++ b/kernel/sched/ext_internal.h
> @@ -1111,6 +1111,14 @@ struct scx_sched {
>  		struct sched_ext_ops_cid	ops_cid;
>  	};
>  	bool			is_cid_type;	/* true if registered via bpf_sched_ext_ops_cid */
> +
> +	/*
> +	 * Arena map auto-discovered from member progs at struct_ops attach.
> +	 * cid-form schedulers must use exactly one arena across all member
> +	 * progs. NULL on cpu-form.
> +	 */
> +	struct bpf_map		*arena_map;
> +
>  	DECLARE_BITMAP(has_op, SCX_OPI_END);
> =20
>  	/*


