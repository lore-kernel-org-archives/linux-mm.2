Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C8E106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 22:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5635F6B00C6; Thu, 12 Mar 2026 18:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7866B00C8; Thu, 12 Mar 2026 18:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9E56B00CA; Thu, 12 Mar 2026 18:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A97F6B00C6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:42:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7BCE1B7FB7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:42:07 +0000 (UTC)
X-FDA: 84538885494.06.085DBE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AA7A012000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:42:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mdT6dHHc;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773355325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lC2a+1vOmRKp3WlfoeTjd43xyQDMCZwY8VihOpOWx2k=;
	b=5WFi1lhL2x8QFUAuZK+ckcVYVjC8AOy5Bmga0gyUciDlPCZTwOKAYZy2cpXXaVqGu4VSeM
	n5ijF91z64AFnztmBIrL6lrp52R8ic0nAWjUiaHaJ6rt9MpbsZYzvGaTWdoTuu1UQNdmSE
	SbllSPTFHWsm3sTyIbXvMGs1xsCbqpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773355325; a=rsa-sha256;
	cv=none;
	b=u80hYyG9FAbRLCo7FPJ5197ndo9hStGh/VjV9PsLXehlNNq54SAY8KR1892WPgSnsnd6Wi
	HzXW0pcRvY3ESBJwhc9hxPn83VBQWXomI7FOQ1cPpre7PD5cBa4N7TTrTLqKwwAPTKDLoH
	uIUv+vXZ8REV3cRJSTMdjoWvEl0iuBM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mdT6dHHc;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76B7542ABB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CF1C19425
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773355324;
	bh=HHV+jtL/hjU1db8zdC4zMLkvl9PbzMDoy2kQU0Dx+tM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mdT6dHHcAt6V/CpqpRZaVALOF95EOcrXXZ784JAFN/5vX8mb8wbvdAj2GsxZ6cb0F
	 0BXeyXrEGp74j9yFwVVyz56cXYOQKCdRNuvWoODPBUdBJFFBgJ54LMDcgtGIAW5OEP
	 ZUv2Xuoah7em2JMErw7xsVJrtH5YFiQ2+9vFhtLrnlfjPKizcwBJCYVAQhVH8sa6Wr
	 v1RTI9b1UFbAJdkynr9U4lvc/CMujwmDzDDomsR9GzSV/TZPnFAyfL13nC9f5nWnQD
	 7Dpu476sZjNOlQkt7Hk3KqMwX7zC+M1qJ6zbGPxb9ccdLsJ8x13Qyv9jf+yrC4Q/4r
	 r2Xr5Bhn7ySeQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b976536806cso51778266b.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:42:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXPtysG8uAkKq4T8ZuvpBac8TQapFyyMo1rBLww0Wr6gsLxmhxlyH9bkwISc6bAWcsdTyI3PzG20g==@kvack.org
X-Gm-Message-State: AOJu0Yy5xIjs15ZBxt/hAF9S3eViDKyJzZXe8w0kJ1462jEheMhyFqem
	YpoKZiwjLSelFNHKdtQse19/EkBGigIWDh7SBs1/gO0aUapIL28/sLh0JiIfRNx0gD30sar5wMA
	te76LgActwNxUBqxYAmOfJ98G2pxcKf0=
X-Received: by 2002:a17:907:94d3:b0:b94:1771:5296 with SMTP id
 a640c23a62f3a-b97651433b9mr58650466b.23.1773355323156; Thu, 12 Mar 2026
 15:42:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260312040627.55257-1-liwang@redhat.com> <20260312040627.55257-2-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-2-liwang@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 12 Mar 2026 15:41:51 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMzR_buk+fqJ_r6pgtdV6H=m__BDZJ3TMrVhUotghf4+w@mail.gmail.com>
X-Gm-Features: AaiRm50EiwfxZTHpWfQGcASFk7zY7F3P-3cUk_qRomA1oNgqKm5k_mkkpcGbFG8
Message-ID: <CAO9r8zMzR_buk+fqJ_r6pgtdV6H=m__BDZJ3TMrVhUotghf4+w@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] selftests/cgroup: avoid OOM in test_swapin_nozswap
To: Li Wang <liwang@redhat.com>
Cc: mkoutny@suse.com, yosryahmed@google.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA7A012000F
X-Stat-Signature: o3ztkfrzn1ogors3cp7fb7qej93uoqjs
X-HE-Tag: 1773355325-192478
X-HE-Meta: U2FsdGVkX18YWy8sAWRTPR0cpv4EjDaF6zLV7kXkBviWvJK0W0rF1BqNGAwISf8WWC/u/wlwJZOMa8rm0ruyTNoWp0B2VXBBaEqBp9NxBFnK1vh2WUZvWKw39tmMeWpDzx7iv3F8G1e3cjYkL6y9XM8IKPnJScSH4XeUoODo7W/XH6PXsGu+6nJ73Nf9z2Omvt58yEt+pKpTp0PdCzc9G2FtQZSlMOW3OCWxIVy5zRAA1812yGjCD5SJKcnscf0q5UUVX1t/VjaGDOh8LaMM5Fnxz4x1V7KmzMzCbNPIHY/5SeY034uiiubylRWvl38XzlWWp4HieJvkXaM38ff24H7FOo1toZwdDVYBKmlCzQaxWek7TGDe8IKdF/B6yJEAAa1VPr3Igb7f+QR2m/CHjRdU/F9IVxX4Om0iPB+KSjKJJs+qwE23e1HJ1tpa23uvAxXWrYniwF3jOyWi+O23h4+/88iWY/norfDWvLqrKrq90mwORnjEnhE7tRJHAdp21fg3vom8qpd9AJ6h9Snobp6fBDUqGDg9Fp6wEPeQzfqOJES/QJ3rpgdgeitGY6xU6IvsOBQ4iYTuxX9AOJlqsRA4iB9XAPt3w9qqpvNeNnnnUaIedeKY5uogpLxvhNExZjPqNsfIhElYg8HXvQ772EtaFvsFSNPfb+yzMGm5T1HlyZdWi9jdq8N//4HX8MrT7V9mROaKetmU1XDiNtlPBLdG58IjM8CTK6DJQqHcWhxmntw5G5xnH6V36NuAexkHVik0pEUWsDp4IoPHUWFy4P1nFU2mZzckzQTYpK2mcfbv8iWmjv6FDog1E/CfQNXMcfvlknH90/icMRKSDSZ897rnUmFX0ObIrq2+vKbJznTqtU2CARZuyp3apXKtBOycfnMvSabfAJLSz1sEjB3puggpg3yRZas+ISwzFjpRJVgdXnwhHITKeuV2roO2O29HyFbKm63vmnuDB/PHEcJ
 10PkTeTf
 7OpD9Q0CEWmP2fUyEcqgYAKofUKjo11tp+E0oUiuYkcQ9VGzzCsuUAUfN7RCwVCkHNAnVuxT1EJqXb+9K+H5UzSCIDupqVV5djBKDPGmXmrBkz+HKYCfyEhexTt69t8EgERZZ6FTlf8ZyKQI3ZgA30f7jvGkwZsNF3OgyHxPhCI4e5B4yfls8Rg91PS4dwzr/bkgwZLgGPbxaJjM3dDLN5po/ljEdtMmIuOzEQHBEyQOj8K/dJJRdNs54mJdHSkFE/4vrm8g0plx1v/pD9eH3ASI9+Nbqdzw3E77iIqa0iVqVId0KCh4WfSCQ3BVYwsdfM57+2raq5qANitkahs9zlFVuj406Vog3R1VjQe1mkdSIuKr9YOsiEu3VeMLLBCp3AAX3klhTMfrkCH0Mk0Evb+ZzOJmTeylq06Nu52bLx81OU/787oi7ie2ilPcfR+PSM31yM4xTJxRjpHpyHetY7+pjbkiWvoWiVK3JY+G5Yn21PC9GyM0522N1RpKBDlO96WeIPdY26I+RHM3z1S9ILvG8+5UV5Miu4ebN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 9:06=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> test_swapin_nozswap can hit OOM before reaching its assertions on some
> setups. The test currently sets memory.max=3D8M and then allocates/reads
> 32M with memory.zswap.max=3D0, which may over-constrain reclaim and kill
> the workload process.
>
> Raise memory.max to 24M so the workload can make forward progress, and
> lower the swap_peak expectation from 24M to 8M to keep the check robust
> across environments.
>
> The test intent is unchanged: verify that swapping happens while zswap
> remains unused when memory.zswap.max=3D0.
>
> =3D=3D=3D Error Logs =3D=3D=3D
>
>   # ./test_zswap
>   TAP version 13
>   1..7
>   ok 1 test_zswap_usage
>   not ok 2 test_swapin_nozswap
>   ...
>
>   # dmesg
>   [271641.879153] test_zswap invoked oom-killer: gfp_mask=3D0xcc0(GFP_KER=
NEL), order=3D0, oom_score_adj=3D0
>   [271641.879168] CPU: 1 UID: 0 PID: 177372 Comm: test_zswap Kdump: loade=
d Not tainted 6.12.0-211.el10.ppc64le #1 VOLUNTARY
>   [271641.879171] Hardware name: IBM,9009-41A POWER9 (architected) 0x4e02=
02 0xf000005 of:IBM,FW940.02 (UL940_041) hv:phyp pSeries
>   [271641.879173] Call Trace:
>   [271641.879174] [c00000037540f730] [c00000000127ec44] dump_stack_lvl+0x=
88/0xc4 (unreliable)
>   [271641.879184] [c00000037540f760] [c0000000005cc594] dump_header+0x5c/=
0x1e4
>   [271641.879188] [c00000037540f7e0] [c0000000005cb464] oom_kill_process+=
0x324/0x3b0
>   [271641.879192] [c00000037540f860] [c0000000005cbe48] out_of_memory+0x1=
18/0x420
>   [271641.879196] [c00000037540f8f0] [c00000000070d8ec] mem_cgroup_out_of=
_memory+0x18c/0x1b0
>   [271641.879200] [c00000037540f990] [c000000000713888] try_charge_memcg+=
0x598/0x890
>   [271641.879204] [c00000037540fa70] [c000000000713dbc] charge_memcg+0x5c=
/0x110
>   [271641.879207] [c00000037540faa0] [c0000000007159f8] __mem_cgroup_char=
ge+0x48/0x120
>   [271641.879211] [c00000037540fae0] [c000000000641914] alloc_anon_folio+=
0x2b4/0x5a0
>   [271641.879215] [c00000037540fb60] [c000000000641d58] do_anonymous_page=
+0x158/0x6b0
>   [271641.879218] [c00000037540fbd0] [c000000000642f8c] __handle_mm_fault=
+0x4bc/0x910
>   [271641.879221] [c00000037540fcf0] [c000000000643500] handle_mm_fault+0=
x120/0x3c0
>   [271641.879224] [c00000037540fd40] [c00000000014bba0] ___do_page_fault+=
0x1c0/0x980
>   [271641.879228] [c00000037540fdf0] [c00000000014c44c] hash__do_page_fau=
lt+0x2c/0xc0
>   [271641.879232] [c00000037540fe20] [c0000000001565d8] do_hash_fault+0x1=
28/0x1d0
>   [271641.879236] [c00000037540fe50] [c000000000008be0] data_access_commo=
n_virt+0x210/0x220
>   [271641.879548] Tasks state (memory values in pages):
>   ...
>   [271641.879550] [  pid  ]   uid  tgid total_vm      rss rss_anon rss_fi=
le rss_shmem pgtables_bytes swapents oom_score_adj name
>   [271641.879555] [ 177372]     0 177372      571        0        0      =
  0         0    51200       96             0 test_zswap
>   [271641.879562] oom-kill:constraint=3DCONSTRAINT_MEMCG,nodemask=3D(null=
),cpuset=3D/,mems_allowed=3D0,oom_memcg=3D/no_zswap_test,task_memcg=3D/no_z=
swap_test,task=3Dtest_zswap,pid=3D177372,uid=3D0
>   [271641.879578] Memory cgroup out of memory: Killed process 177372 (tes=
t_zswap) total-vm:36544kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB, UID:0=
 pgtables:50kB oom_score_adj:0
>
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

