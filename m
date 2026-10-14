Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3077CCC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B524D6B008A; Tue, 13 Oct 2026 23:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02726B008C; Tue, 13 Oct 2026 23:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18026B0092; Tue, 13 Oct 2026 23:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68AC96B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:09:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D13601A040E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:09:19 +0000 (UTC)
X-FDA: 85319750838.15.1B9083E
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id EAC2F40005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:09:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VdfOBasU;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791947357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZxFoqnlOiUWhIXdGMf7+RiabdBM+98/BuYUZOMYxiQ=;
	b=MBxdZSX2vbCKr2GaCI/nmp70ydZ7wd2aYAyD2Wu5Nm0H48tO1YOGVlo1JZQ0WtTR9QpXTW
	BfjMV+kfKpWT5loP6Sh0faRiVjZdlzpQEHTKKGyaaA9AlQkbZMZz2xlhWYIF/x6hk4dKHQ
	U5rMvyHuKqM/hIFVXuhBddmmSohQ1Oc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791947357;
	b=pEAV3sG8zOy294gN2ljZnAqzl2o3Gf/YOMRxkEYnn40fqcJE7QLWBjP0Iw9hgq9OUuZ9OT
	UQ5dCetBcL7UVcC8+Oo27SppRGkuMDMK+pHW7PIwGeWM9kIUD8/o3oA8Q0r5ZYHDknITzg
	y7atGT0+1bh4ORbH5G1WMpW2lNW6WCU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VdfOBasU;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-677aec6ddfcso3076491d50.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:09:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791947357; cv=none;
        d=google.com; s=arc-20260327;
        b=gX+KBZHxmchB3r5gJbxZ9yuBIx0BxuDHcWsYqRa/VpDnqPHGZHn3yKeYAli9gR2Ww5
         9TV7dBYiAyjjxSjcbXSFmtqkTc9PTA3fpcoLlEnD06v1Oldc+KkzgNhceAzozD7B+Srb
         ClXa0nX//sVeRovrxL+wEatukI5AXRnZT8SNwTQ3LdTwPqb3MZykZIdetgrhXIyTrInG
         TUTjkTKkz7WdiTVwbzu4kIZ8mHVKP2ruypn2SDLaWcOMEtIjYP2OI+wEMk4M6DpDkGi1
         oVIZDLwrJZZlvc6wF1+Ea5kQxgxi2s/H5v+5zdI4BRCDsjJwjmuDYanSuZGo7W1m5L8V
         E0dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DZxFoqnlOiUWhIXdGMf7+RiabdBM+98/BuYUZOMYxiQ=;
        fh=IRp0WE/FrpsAjjikCS4nS63SWwzniOwaDm1fgvZh+XM=;
        b=QTzAy0c+l1NVKLOitK8lebz1qAwaPzvmzyNVwf7bxUG1U5lOnupQWAt/eLDBwxFSxF
         2/ageEkHMPzZu2eofQMRXz/RVws49Xc3cjY99DOsDhF1/uAaiXQT0j0V3O3Q+I9DptLQ
         Pr/wtGBExdLR3gVTUj1XwavfZenib/tyGlZxol5kJ2l6PaqXUl2QrqehjUAGkVFn07on
         uT5ndtTBeb6JOMSYsI/LlycfI1OC8s6h316YFu6/Sn6OczWTDAd33fV5Xv7P9om8bZUH
         2BLkSDndsQBI74axl6F32a6dJPV69uY57HASwY2CQXI4X28C/QtsVx36OCW1fxwXX8j6
         4I+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791947357; x=1792552157; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DZxFoqnlOiUWhIXdGMf7+RiabdBM+98/BuYUZOMYxiQ=;
        b=VdfOBasUsCzYqdXdp1NA1BVKsuJ9pgBK1QVznWLTwz+74tbPBQHsWWPsnp1h/WuaDN
         BmBdIOYGW53ygT6iXTljUUPcOCNfJ7opcIbT3T0x4ppDWuKSlEpw7wAOAn9XOYg1KndX
         7Ucp5d5TGLPGBJhUqQUELikG6DGqAk+K5ouMTuFm1H55anyivzvAx5kgglmQzvTsR0AJ
         Gnwyeo46HiBxSw3uveh+FFs3me65yXYi4FQW55R0JpvqeAR67Ivc9fKpT+Tew4jFPhXU
         ZZBVd/QI7SL7k51E+RJtXTmIx4R2GMHkx8oRB0oYVQHcXBDOBGI4MIwp3IPT8G6tGhhq
         boCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791947357; x=1792552157;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DZxFoqnlOiUWhIXdGMf7+RiabdBM+98/BuYUZOMYxiQ=;
        b=gQ3784ULbWr4AeCMgXuHAlq893d24wsMb31S4eX4LiV1tVLEwdKLJvBT1eAIOIJszc
         jUE7YVE0Wf/oH+kweHoO/mzn8kP8sz+O9wfLA2Rv2kaEtCC4vbyglYDfejYz4bKrHhbh
         OkIYqNijNyJucIe/k3WkQol0/q15Mf8redRL4M5bbqKxgpMZtLjVJ0yqKTnhGFc7Mmj3
         H0657fHnhKDW4qRKBhv4XmQKdK5gIBPoUX+h6y3v+UCb2t7JXfWYToJO1EX07/is7HzS
         sGJjfJmsC+straY3TeCQD4GelK3ocGSh0wDrgo/V0E2+HEQ6fH6xfTXit9fa6U+0WnOk
         iHiQ==
X-Forwarded-Encrypted: i=1; AKwUvBxKCSosOFzlgngGF5d5mSSHvjEGmwy86XDKtIb7Uq1SnGtxJqXukrj7ejwBobsXXyBug1NCs2pQoQ==@kvack.org
X-Gm-Message-State: AFq9FYLvCc8II1iSK1OSmuombzGDw/yOLjlqgCoTxKYTWDM9U8ThsIdr
	/CfNz1jAC2zf6Owvny6TqVH+Ru4NNmCg5tx9HZrK+o32lU3XMCY8o3NcKb9I/OWQQq9hB2hi4sv
	YKHhKDxdCcjXgX6CHOLZu5vxbqzy3GeQ=
X-Gm-Gg: AYBFou0/HL1TieonHO8Cnx8yuz4A9RGwVCl8KMFEZ77L5+/0zFHoqoNnSwO5PuBQHSC
	VwnkjNtbaoeqFwhsMQIuNyEC9dm93MbKkT2iEsk8ymGBqBP8ZXHjYK1CYz4v9uBFK78zITi7I6C
	jzL1J8BObKsOrZncO8AEiU03uv5CAdCeT6NKqJOfj8dFCTKVBcFQ6vCR/hImi8++syHexafciVL
	EM1ZGpAyeF7ds6GHNGtjoaFgseiedAElApecCrX9UEosKmhaBR4U1wMmoaQ10OTVgOl1GNzv2DZ
	fDBiLwIsH9RjoA5ddkfISEU77Cwf0ICz4NoCZtlvLqmDvckREWSid2pUfDIsBK5xaMMPGmie2GB
	EKiItSzRNZQ==
X-Received: by 2002:a05:690e:1913:b0:676:e85e:5ec with SMTP id
 956f58d0204a3-67975b9e0fbmr1610555d50.139.1791947356910; Tue, 13 Oct 2026
 20:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <20261012120438.52849-1-laoar.shao@gmail.com> <as5RFhW1Ch8ta5nZ@gourry-fedora-PF4VCD3F>
In-Reply-To: <as5RFhW1Ch8ta5nZ@gourry-fedora-PF4VCD3F>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 14 Oct 2026 11:08:40 +0800
X-Gm-Features: AclHuK-Cs4-tIw-JWscmzRL89aJpa2RhvKqogcNm_f37Lr6_J9191jM_ZK2WR2Y
Message-ID: <CALOAHbCOTSOPTzoSqKoBJZ56o0pfW_dGQ7ZM_e1jT9N16z3VPQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
To: Gregory Price <gourry@gourry.net>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EAC2F40005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: jjuqoicit64uns6hei8iu7z1ezyhowxk
X-HE-Tag: 1791947357-832948
X-HE-Meta: U2FsdGVkX1+vx4+0cPpetqdbop5Xuruy9QFSkKjTesbG2DU4t3l/4WgbivPZGijbnkRbxcBPy7459sVPP59LI+QmVj/ZLmSVamFfT8CIdte99O7pI8dzVfGm/mdmSNhOP8lCue2EB9qFCDlTgzcbz4vtXP9c7Omc74XxEfyM0MVfQx9+6Fv5dBcSeWywx6k/sfpn9ddY2TOmiHou86LMt79UwfdAZ4YTNsevQ95feFg7PIersTz+xJR921kTYOEnMH4v9xmCloIxLGppI63065Y6vlJOJiLowtGOmZKlrH3OE5xlS4R/vt7kq/LLxAOxHisVgD9pmQw3Z2zpTise7bUtQjQ76qfSbLahQ+1m+43BsfCfhNYZ+hrFrkUpTEdRdq99dXP5Yeg4fK6rUfgMVYJ8EUuHzfsKG0SLtn+QVLkGd3bHi8nqInv9orQIt2eZZ31fFSQSk1yeGWrhNO/NnfZEcpq6XPCzPgt5bBff2bkGv8zz+Y9qHXu/+85GK8unTaqug1cKxVc0g5nIBdrSr5SiAoFuUlGVfcuSbHjFQNWXJTuQvmG9B2AbwQrgwozk3/hrqtcY0hvhmkyynRIjSKCOds1yZFltjZ8ZJ1Yvq+dG+GgUdOziDr64BabjCfYKrQg6Nmdi3KHv2bGVM4UlJe0FngC1kc91d+MpS7kx30AxglOLWxNq60RdjPr71K5b4QgdlphpEMyG57yyqVH5n3g9rurhPMMPEoh9j/z8aRVOW9wRkRuKV1/355/J8xpHZ1Wv1eCZ3sAOiBHp8R73C9Vi8FnR0NgSf6pc25pALKX5jxVcoFY54GDjqdcOik4x1lUOl/18CYG6rSjG+FPPs4baIcqOt3xwfWfX6gmk0jXzq8mkFON4GCqnRAuySeisPSiE9GL92SkECT3CHw4l/+F0amjHw858eL0iApcFg9AG7rT2+cusgiVrahLucKayLxSzDl4e1StRTsr+p8N
 xfFjUQvC
 sEntkHWBxz6ciimSmHs3W2Pn10raiZNIGBhfW5Elk3yao0A/cyGpBabeyr7KlF3d8n496WLLPZcDEcybIa26+NjXyg6159ZgEsNXJCW8KTaJAT+VvWQB35tTsQOMc2RIQwJ6kBLNdJeQZVFQMdQvKQCKiij3ymau4FJfbcK/mHdpdYgEYT+rzs1OPRc4vH8EeOI+LF+zIMw+mnnInrM45zObgU5fiusru+DBOCq/C7u496eyPZUNyySis360e+v/8tM7nPIwKuALfjEtEy1y+XKQ2LpSr+zFRry+nDXXSo8hTZZU8xOGSX0UzimwqhmI8fIvECk8L7XqchuM5IznY+FD9hKE15TSg/uxGo91Yc8D8qTfYv00Zitrpvuw0nCL/OCN0SkS7A08Wth4hNh2mmo3LHQs63LK/gB2ByPFHTXBNktsZ/8t08vvqh9Je+YbCjAbmRdylH5hQYe+p4V+hkkwrVvrOZuCHTzMbyykjRvWJneTzJO4Q5MjNBTezCnhxu57TxK6AkfeX0Wb6Z3if8CKMTPnmFQeOOxmn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 11:49=E2=80=AFPM Gregory Price <gourry@gourry.net> =
wrote:
>
> On Mon, Oct 12, 2026 at 08:04:35PM +0800, Yafang Shao wrote:
> > The Problem
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > In our large fleet of Kubernetes-managed servers, NUMA balancing has
> > been historically disabled globally on each server. With the increasing
> > deployment of multi-socket AMD EPYC servers, cross-NUMA access has
> > become a critical performance issue, which made us reconsider.
> >
> > Enabling NUMA balancing globally is still not acceptable: it increases
> > the overall system overhead and can introduce latency spikes for
> > latency-sensitive workloads. What we need is to choose per workload
> > whether NUMA balancing runs at all, and which mode it runs in. A
> > latency-sensitive service may want the scheduler's NUMA statistics
> > without tiering's promotion machinery, while a batch service wants its
> > PMEM-resident memory promoted when hot without paying for
> > scheduler-driven migration. No single global switch serves both.
>
> Have you tested with recent fixes?  NUMA balancing has been broken for a
> few years now (starvation issues causing VMAs to never be scanned,
> east-west filters causing south->north promotions to be skipped, shmem
> being entirely exempt, others).
>
> https://lore.kernel.org/linux-mm/20260629163337.1264881-1-hannes@cmpxchg.=
org/
> https://lore.kernel.org/linux-mm/20260930112206.205083-1-gourry@gourry.ne=
t/

Thanks for sharing these.

These look different from the latency spikes we've seen on our
production servers =E2=80=94 ours occurred with NUMA balancing in normal mo=
de
=E2=80=94 though I haven't yet figured out whether ours is shmem-related.
Given its problematic history, it's hard for us to re-enable it in
production globally. That said, I'll try to backport the fixes above
to our internal kernel.

>
> I also concur with Tejun that ops seems like overkill for this feature,
> this seems like something that can already be managed.

Tejun also suggested starting with a smaller kfunc rather than the
heavyweight struct_ops, in a separate mailing list thread. I agree
that this would be a good starting point.

>
> For example, why not add a new numa balancing mode bit that says
> "enabled but only for explicitly opted in tasks" and then ignore the
> global default mempolicy, e.g.:
>
>   if (numab_mode & NUMA_BALANCING_OPT_IN &&
>       mpol !=3D default &&
>       mpol.flags & MPOL_F_NUMA_BALANCING)
>       /* do balancing */

Another option would be to add a cgroup::numab_mode field (without
exposing a cgroupfs interface file for now) to implement per-cgroup
numab mode. I will think it over, considering both your suggestion and
Tejun's.


--
Regards
Yafang

