Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42820D43367
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 02:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F82A6B0005; Thu, 11 Dec 2025 21:47:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8A76B0006; Thu, 11 Dec 2025 21:47:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE776B0007; Thu, 11 Dec 2025 21:47:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA5D6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:47:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0289A6016D
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:47:35 +0000 (UTC)
X-FDA: 84209283312.01.5F50506
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id DD49A18000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:47:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gFJt02E8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765507654; a=rsa-sha256;
	cv=none;
	b=zirOPUdSh9iYXTli5QUYuvx9apQ9VkXZebjquiYvOTX6XCqwQSMo7TCKG6m8sBh8lsQDHA
	lLfklYe2JPZcFJZrLAWm8PQFcYKIoS3faIzey73Tqr1waFeImOvhZgfFTVJ8sUxQ6eEVtH
	icUkuzu9gpZjQXJCySsXm+hXW77VoaQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gFJt02E8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765507654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXgyn08is2XL7LwnzfswaKLtnWzyXUyRHnUyXF1yth0=;
	b=0/d5XZcS4slDjjPajsdRU4n6dO/qRyoFCx/ZmIOVwXIaJnPYsud+qMtwi+Ptw3cG4T0lgK
	E7VIXYeUyh4bh94dG/e66/St24X1j2hv1xRsFSSQxhrernP1zyFbOcvZRzoWR1C2m7MGhJ
	I7659Dh1V6cazj/OzgR/a5VTqK+0U0w=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765507651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UXgyn08is2XL7LwnzfswaKLtnWzyXUyRHnUyXF1yth0=;
	b=gFJt02E8SOYWdB8V/7k24UvEy/oWFPQjpbLUYdlsK8ZlxzYN/chJgUrtJlCpHaXEdsGVix
	BJayCw/VAXCdqDycnYUOjVtZ1Pk7763ol1purNhD8MRUQ2DsR99dmE8f52yT2vkKXkd0dq
	dVgKbFFC65IcR9j0tpGIe+mTs4tbauw=
Date: Fri, 12 Dec 2025 02:47:27 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <d6a7cbdd9d16c5759d6511cbad3f7bf7b99d2247@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
 ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com,
 akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org,
 kasong@tencent.com, linux-crypto@vger.kernel.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com,
 ardb@kernel.org, ebiggers@google.com, surenb@google.com, "Accardi,
 Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius"
 <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
 <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
 "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
In-Reply-To: <SJ2PR11MB847266BEA195A20A095AFA73C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB8472E5CE1A777C8D07E32064C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bv3uk3kj47iiesreahlvregsmn6efndok6sueq5e3kr3vub554@nnivojdofmb6>
 <SJ2PR11MB847266BEA195A20A095AFA73C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: DD49A18000A
X-Rspamd-Server: rspam10
X-Stat-Signature: 4umu7cakcydhy8qktta5k7s6au8tc5js
X-HE-Tag: 1765507653-608329
X-HE-Meta: U2FsdGVkX1/yttRP1XVljavf5eLloN0PXhbXUZrONrQW5SezgNebZDkjUK2FT8a5hFnY87HCsNvDoSx+zlXd8GtmrpHHYk9ZOiwx93BuSlFpqTF7D3+VnMd6zCGV+cTrR6/fGCd4Un60fadkhtRPXVLvhN0TyrgVYZjTxazbwlrgWmSjS2LsbiCa28SaM2bKzxojzidsGybVsYd4jLDnJKtf+oir8MsvhZvVK5MQKQqhsRgnfM/JMJGcsF5ABPbiNOl7W8RjLxD08cqvacxwZ948iTbhZ/7FTvENfnO6AGl207qUx7002XF+e+xTOp3OM0TbIKFmCwke+qrZl8b+vEo0xHbe/k4smI4J4dJxZDu40ovnqX3N288pwhXselEW8V+OweV9QRnVRvheOAJ6cnO4kfH0Z6A5dprF6rEJgcYC1X6fP0EKM29XEkrC3xNwkQ9goA6Jg6EENPklSdiL0x4H+Ufnq/tk5RU0ujTjjhbU6j1uO22q3MwjB4f4arFqh/eo4u65cUavhb48GL+24RKJdt7GT5NQY6q0JbckiwTE8hrEg6WP70NShGCZfZxv/EE8TTS6l6rwQuCPQxMacvGfropgDQFUem26cCsdcsKFf083KD8w8ay3NmFtEOb9XI0QV2zQYtFtBchztzqC7vwRiofJ+itTm3iPPAumexuwfzfmvQYVLBdhnM+GxgDhK3zy4MR0xvYkZpx/Or9CWYo4toPE8fc/QBOF5Jt0VH2cw+JNT9vWhrsZIIAWmA1ajjtdHe1WJ37p5baN4ljvMZmRuMXEH7Uyx58ez6nD4vIcGEwS6OzgJZpQe2RLT3cMCYPcibx8RaDk4lPJS9ojfdKVWXHiP3CBb5GYd9Vjgc0QMSrDfc8FqxEWlhez+fG3U47yOK3zNX8xa4Ndiu3MhSHm9GHbEQKQ6jfUz98Ow9UKvYtUGs2XxT6R5GgseNM7Y3PcDG6+5W91DoFltjU
 qgbpcRcI
 yLNEyp4EORzEoc5texcFAZAAk1s0TPdVMMtKo/QNC0l4Hn9X0XT2D5WVOiNySpIjreSWxxFVeDBIcMAslHKSvDANbHRHvlpbsPsNSN/ZlZRKlErweYE9Yxk1IYiI6Sv73wuFEgjil2wvWsDte8yVDyLFxuYLn8ExtKG9At7P33qj3xlY9H/I/bta/irRxbBCGq4xET+/iS3oVVddY3JVQp4gfKGc9G55WoUSLh0IX/AcuTB/pSu64YqqhV3p1l3WuUQHttrURpSsfXvYxkPE6kVDgWnb32mZ9Pi/Ul8UGIuRLpPMjEkmHMq7HhqK7a0uDts+Is328BhDzOAM/f8ZGlfrCKtFOx2MAZiq1xYhXOnPGu2WdCGEFWjazxQgzfKPSxUhUUZbivJ/rKAR05nKZBTACRPr03yrO8toZgnWo9mDfjv9fIhDaU+dSe2NC45oDJ1pG31JC7j6EZipKyg7Y6aNtblsFWI1VngGmPOYq5+onk8gmyvjow0PXrIit3NCgZE0IDye0DDayZDeDOJmgv0Ic0uzPgU3VYTNRBatYeeQ9YSA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

December 11, 2025 at 5:58 PM, "Sridhar, Kanchana P" <kanchana.p.sridhar@i=
ntel.com mailto:kanchana.p.sridhar@intel.com?to=3D%22Sridhar%2C%20Kanchan=
a%20P%22%20%3Ckanchana.p.sridhar%40intel.com%3E > wrote:


>=20
>=20>=20
>=20> -----Original Message-----
> >  From: Yosry Ahmed <>
> >  Sent: Thursday, December 11, 2025 5:06 PM
> >  To: Sridhar, Kanchana P <>
> >  Cc:;;
> >  hannes@cmpxchg.org; mailto:hannes@cmpxchg.org; ;;
> >  usamaarif642@gmail.com; mailto:usamaarif642@gmail.com; ;;
> >  ying.huang@linux.alibaba.com; mailto:ying.huang@linux.alibaba.com; ;
> >  senozhatsky@chromium.org; mailto:senozhatsky@chromium.org; ;; linux-
> >  crypto@vger.kernel.org; mailto:crypto@vger.kernel.org; ;
> >  davem@davemloft.net; mailto:davem@davemloft.net; ;;
> >  ebiggers@google.com; mailto:ebiggers@google.com; ; Accardi, Kristen =
C
> >  <>; Gomes, Vinicius <>;
> >  Feghali, Wajdi K <>; Gopal, Vinodh
> >  <>
> >  Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resource=
s
> >  exist from pool creation to deletion.
> >=20=20
>=20>  On Fri, Dec 12, 2025 at 12:55:10AM +0000, Sridhar, Kanchana P wrot=
e:
> >=20
>=20>  > -----Original Message-----
> >  > From: Yosry Ahmed <>
> >  > Sent: Thursday, November 13, 2025 12:24 PM
> >  > To: Sridhar, Kanchana P <>
> >  > Cc:;;
> >  >;;
> >  chengming.zhou@linux.dev; mailto:chengming.zhou@linux.dev;=20
>=20>  >;;;
> >  >;;
> >  >;;; linux-
> >  >;;
> >  >;;;
> >  >;; Accardi, Kristen C
> >  > <>; Gomes, Vinicius
> >  <>;
> >  > Feghali, Wajdi K <>; Gopal, Vinodh
> >  > <>
> >  > Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx
> >  resources
> >  > exist from pool creation to deletion.
> >  >
> >  > On Tue, Nov 04, 2025 at 01:12:32AM -0800, Kanchana P Sridhar wrote=
:
> >  >
> >  > The subject can be shortened to:
> >  >
> >  > "mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool"
> >  >
> >  > > This patch simplifies the zswap_pool's per-CPU acomp_ctx resourc=
e
> >  > > management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> >  > > acomp_ctx's resources' (acomp, req, buffer) lifetime will also b=
e from
> >  > > pool creation to pool deletion. These resources will persist thr=
ough CPU
> >  > > hotplug operations instead of being destroyed/recreated. The
> >  > > zswap_cpu_comp_dead() teardown callback has been deleted from th=
e
> >  call
> >  > > to cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a
> >  > result, CPU
> >  > > offline hotplug operations will be no-ops as far as the acomp_ct=
x
> >  > > resources are concerned.
> >  >
> >  > Currently, per-CPU acomp_ctx are allocated on pool creation and/or=
 CPU
> >  > hotplug, and destroyed on pool destruction or CPU hotunplug. This
> >  > complicates the lifetime management to save memory while a CPU is
> >  > offlined, which is not very common.
> >  >
> >  > Simplify lifetime management by allocating per-CPU acomp_ctx once =
on
> >  > pool creation (or CPU hotplug for CPUs onlined later), and keeping=
 them
> >  > allocated until the pool is destroyed.
> >  >
> >  > >
> >  > > This commit refactors the code from zswap_cpu_comp_dead() into a
> >  > > new function acomp_ctx_dealloc() that is called to clean up acom=
p_ctx
> >  > > resources from:
> >  > >
> >  > > 1) zswap_cpu_comp_prepare() when an error is encountered,
> >  > > 2) zswap_pool_create() when an error is encountered, and
> >  > > 3) from zswap_pool_destroy().
> >  >
> >  >
> >  > Refactor cleanup code from zswap_cpu_comp_dead() into
> >  > acomp_ctx_dealloc() to be used elsewhere.
> >  >
> >  > >
> >  > > The main benefit of using the CPU hotplug multi state instance s=
tartup
> >  > > callback to allocate the acomp_ctx resources is that it prevents=
 the
> >  > > cores from being offlined until the multi state instance additio=
n call
> >  > > returns.
> >  > >
> >  > > From Documentation/core-api/cpu_hotplug.rst:
> >  > >
> >  > > "The node list add/remove operations and the callback invocation=
s are
> >  > > serialized against CPU hotplug operations."
> >  > >
> >  > > Furthermore, zswap_[de]compress() cannot contend with
> >  > > zswap_cpu_comp_prepare() because:
> >  > >
> >  > > - During pool creation/deletion, the pool is not in the zswap_po=
ols
> >  > > list.
> >  > >
> >  > > - During CPU hot[un]plug, the CPU is not yet online, as Yosry po=
inted
> >  > > out. zswap_cpu_comp_prepare() will be run on a control CPU,
> >  > > since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section
> >  of
> >  > "enum
> >  > > cpuhp_state". Thanks Yosry for sharing this observation!
> >  > >
> >  > > In both these cases, any recursions into zswap reclaim from
> >  > > zswap_cpu_comp_prepare() will be handled by the old pool.
> >  > >
> >  > > The above two observations enable the following simplifications:
> >  > >
> >  > > 1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim can=
not
> >  > use
> >  > > the pool. Considerations for mutex init/locking and handling
> >  > > subsequent CPU hotplug online-offline-online:
> >  > >
> >  > > Should we lock the mutex of current CPU's acomp_ctx from start t=
o
> >  > > end? It doesn't seem like this is required. The CPU hotplug
> >  > > operations acquire a "cpuhp_state_mutex" before proceeding, henc=
e
> >  > > they are serialized against CPU hotplug operations.
> >  > >
> >  > > If the process gets migrated while zswap_cpu_comp_prepare() is
> >  > > running, it will complete on the new CPU. In case of failures, w=
e
> >  > > pass the acomp_ctx pointer obtained at the start of
> >  > > zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, ca=
n
> >  > > only undergo migration. There appear to be no contention scenari=
os
> >  > > that might cause inconsistent values of acomp_ctx's members. Hen=
ce,
> >  > > it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
> >  > > zswap_cpu_comp_prepare().
> >  > >
> >  > > Since the pool is not yet on zswap_pools list, we don't need to
> >  > > initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). T=
his
> >  > > has been restored to occur in zswap_cpu_comp_prepare().
> >  > >
> >  > > zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
> >  > > valid. If so, it returns success. This should handle any CPU
> >  > > hotplug online-offline transitions after pool creation is done.
> >  > >
> >  > > 2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
> >  > > migrated to another CPU before the current CPU is dysfunctional.=
 If
> >  > > zswap_[de]compress() holds the acomp_ctx->mutex lock of the
> >  offlined
> >  > > CPU, that mutex will be released once it completes on the new
> >  > > CPU. Since there is no teardown callback, there is no possibilit=
y of
> >  > > UAF.
> >  > >
> >  > > 3) Pool creation/deletion and process migration to another CPU:
> >  > >
> >  > > - During pool creation/deletion, the pool is not in the zswap_po=
ols
> >  > > list. Hence it cannot contend with zswap ops on that CPU. Howeve=
r,
> >  > > the process can get migrated.
> >  > >
> >  > > Pool creation --> zswap_cpu_comp_prepare()
> >  > > --> process migrated:
> >  > > * CPU offline: no-op.
> >  > > * zswap_cpu_comp_prepare() continues
> >  > > to run on the new CPU to finish
> >  > > allocating acomp_ctx resources for
> >  > > the offlined CPU.
> >  > >
> >  > > Pool deletion --> acomp_ctx_dealloc()
> >  > > --> process migrated:
> >  > > * CPU offline: no-op.
> >  > > * acomp_ctx_dealloc() continues
> >  > > to run on the new CPU to finish
> >  > > de-allocating acomp_ctx resources
> >  > > for the offlined CPU.
> >  > >
> >  > > 4) Pool deletion vis-a-vis CPU onlining:
> >  > > The call to cpuhp_state_remove_instance() cannot race with
> >  > > zswap_cpu_comp_prepare() because of hotplug synchronization.
> >  > >
> >  > > This patch deletes acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock=
().
> >  > > Instead, zswap_[de]compress() directly call
> >  > > mutex_[un]lock(&acomp_ctx->mutex).
> >  >
> >  > I am not sure why all of this is needed. We should just describe w=
hy
> >  > it's safe to drop holding the mutex while initializing per-CPU
> >  > acomp_ctx:
> >  >
> >  > It is no longer possible for CPU hotplug to race against allocatio=
n or
> >  > usage of per-CPU acomp_ctx, as they are only allocated once before=
 the
> >  > pool can be used, and remain allocated as long as the pool is used=
.
> >  > Hence, stop holding the lock during acomp_ctx initialization, and =
drop
> >  > acomp_ctx_get_cpu_lock()//acomp_ctx_put_unlock().
> >=20
>=20>  Hi Yosry,
> >=20
>=20>  Thanks for these comments. IIRC, there was quite a bit of technica=
l
> >  discussion analyzing various what-ifs, that we were able to answer
> >  adequately. The above is a nice summary of the outcome, however,
> >  I think it would help the next time this topic is re-visited to have=
 a log
> >  of the "why" and how races/UAF scenarios are being considered and
> >  addressed by the solution. Does this sound Ok?
> >=20=20
>=20>  How about using the summarized version in the commit log and linki=
ng to
> >  the thread with the discussion?
> >=20
>=20Seems like capturing just enough detail of the threads involving the
> discussions, in this commit log would be valuable. As against reading l=
ong
> email threads with indentations, as the sole resource to provide contex=
t?
>

If you feel strongly about it then sure, but try to keep it as concise as=
 possible, thanks.

