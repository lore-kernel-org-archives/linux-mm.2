Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBBA606A325
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 03:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XFjaKJrv
Received: by kanga.kvack.org (Postfix)
	id 32EE06B05B0; Sat, 24 Oct 2026 23:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1596B05B1; Sat, 24 Oct 2026 23:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1523D6B05B2; Sat, 24 Oct 2026 23:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5D816B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 23:36:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CF73C04EA
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 03:36:34 +0000 (UTC)
X-FDA: 85359736308.24.A0B8DEB
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id A15A3140002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 03:36:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XFjaKJrv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792899392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjKh57N4UF4L0vPTEmwKkugiAf2AMgqPZ3+VipYde0U=;
	b=Rb4MCKbxQnPDqTX5VGI/ZMZG8mJpVD8uyRUJNfnpSTZZ7dTyebZ8iKxJc6UGx4QL8Vmj6r
	oLGxEk3I5eQLK/cRaVHsPe89WWR/Uug7CiozbeQl4Ttf8CWMQGggyTKHVL3JArfSUQD7Ek
	iu7p7YwVfe7IXnVW9jPR/ekGhqZtfx8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XFjaKJrv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792899392;
	b=gQ2St6m12XfaA8v6bK/CxrSFACP93MidA3WvwRIuzuK9XA5/h/9XvLox/qYzTngSzP5CUp
	IFAW7qiH1uu9owBfqhnALbejUveoE6gZq5ks3ydfd5PIKvY0c4AAyH/KcKIWUXenJiL6WW
	eElJQ8HuGXesxJF3OXEF2u48fWXlXMA=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-679a420b5afso1840730d50.3
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 20:36:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792899392; cv=none;
        d=google.com; s=arc-20260327;
        b=N+YS8yqznU5CkvyHGRUnNsAOlsEcZ8rdAgRJ9Qd2+98ZsZOwBZ/YtRahmnTEWZpAiN
         GV9ieTyAAAliv/KMcZ8kS2u7VJlQr6R+GC/ubdJtbf3nIK9Cl2UNXKVU0ymN38gs+Xff
         0tpmSAoIX0RdT7aab9etXc8www1I2MHCAL29bMfbxfiiNs2Z8b+mytz4+cWO18xi+6Od
         LGUDjCZwkyd6Cqi86fg9v77ADdRzjhZOpVASvPnhJWrUi2YZfBsRxRsF895h/IBeInec
         bjxJv6mmQdD+pt28jypLwgCpUvxqCdXHE5+mpa7ARcDPKMCTo0kcLMAjk1EF1XCcvguD
         t0EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DjKh57N4UF4L0vPTEmwKkugiAf2AMgqPZ3+VipYde0U=;
        fh=cEUgXXSslYMzmmeuamFal8WKUe5tRcO57mmPoLvinyw=;
        b=OSkFymSDJZupVUbO70yl69JJtoKjAfnEnK44LXq2750Mj3IRruKvhUuWYliLESWkhq
         7c0HxvHArPBnMj3sWsBS1lq7lHPdUvxvrBb2zxbEAaRaNqKNdeVEGrVxthZC1eZg7UgU
         uqXz584B1Irx594U/o2UilYBXBrBxnKF98El81u066hqsq1LpGfzbdPTSfEn2GYa7LMi
         zfWG6Gpr3GdUBvgFlCYcWFEQ6tktoDrAGF3Q9DF78Ko/t2bTeEfuoTKwFRAVphfyJH1p
         YeSXuQCoTxsvn6nLqcNSV3hLnD7x2FJHLlW7s56deFifqAy7/okERDUndaY2TiPvA1Pa
         K6TA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792899392; x=1793504192; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DjKh57N4UF4L0vPTEmwKkugiAf2AMgqPZ3+VipYde0U=;
        b=XFjaKJrv3t6EteIuasMBojaaiX9UYN8jYxAiQNUzcWaxh+vMc/LnqVc4B7p04KkG2i
         KflmLss4EvNUjn7d8TedzrFCLWYVM7h3hO3G43qoA8DFYvMZgMZBOOfy07pUpN9KOavE
         TqeP7Kad+pKW/8FtFQEC2DvkClBEhspzptIv/nir9qOYL8YaIDEYgM1M4ue+fy/+lLii
         WGBoVlknRA8QDcKivbaVW5ch5FWNjjXHGBfGNycTMAPHyZD2resEPiRwTdbpi6Q54zDc
         FaRROYP/vfFGoR7LQq3Bq0Op9U+inNrXwr8xRn6mcld1DNM91elc1wWvCEfl1jzaz9XL
         iOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792899392; x=1793504192;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DjKh57N4UF4L0vPTEmwKkugiAf2AMgqPZ3+VipYde0U=;
        b=HkPAjWra5iPnX9u2fmBwOq5LN6LNx8523/3Ec6U9f5fBWiNL4gnVMylpkqDOZdZuvE
         0rVWZO5ZudalYJwFDDqO/6gDzkzuyYLL1rfn6D1rhi1s9o1tKn2osYj5qQtu8p6OoTKy
         7Qd4FHoS+R01qUdOPgPiR/dvVRMzZKYd77RaW73AjFRCTJr27G1cCpsuFyU3M8bGeobU
         FZJzSRyGmAPcu+Z89urwMINhaliaJLNuqikdRECgvnflzbo6/eVCQj5m2Sn/deAVrUFi
         QHudlLjDbejJxEsiNFI1duJcQgitzCyIahA5N0GLAAxbZ1cj154j2rNrGTxPqu0SMPWR
         3yUw==
X-Forwarded-Encrypted: i=1; AKwUvByJujwf/W2qKk2/yd7eHunZ8iFqsOn3NTAbQf4zXNByc8MUDceZSMb3x0d21Aa5FJXAp+iUlKiE5A==@kvack.org
X-Gm-Message-State: AFq9FYKpS9fDjTrVTTMLXH5o/5C0GvrDYx3TEkjnBPS9n6r7bjdxrdxH
	ToXLGfrmxXYprgsPjeE55H2cUwZ0j57nJTqWxDsgKjsL7J8UuFCiMfKXTciY8/8T3pfzzD9ao4k
	9R0AGyGXkpygYFoAFYgbjOwqeacjTPvY=
X-Gm-Gg: AYBFou28b/p+9GfEramz1uhTMCBLufam6sC2b1GG3gCuRM/J4CG3L8Z4DWLiXv2W4uW
	thhUuYc7bPh+7o4dff8jdQG0SLTdKiQVgGOn8AbhVef+QyBskg7kZBx4XkQsZG9mZ3RO1kZl/nF
	hKu4enTKi87eY0QJOOR2eptB61qwHZYjX2g29PeYFU6Uctccc+Nyrcx3GlNRP2nGlUGD5ryCi4j
	2M1myWfdJ/6bQoJ6+3fOevK1nMeXWvn1gFLXRYAXQjDmxZUlNeBFPkI2FX0QK+vLVu5DPGQCHax
	cbXQjhBpScHGHGyuMjZyDontx516VBta4CxC2NAlpP6rDi4d7doAlaR8vfBsJGn63zIFd8cVaVz
	aBo84z8tAPREp+/RxyP6Fn2Kz37xCCAHquZyy5oa5bCQcbs2rxtbWs5J/9gHUJKuS0sE=
X-Received: by 2002:a05:690e:1a27:b0:679:95cd:1aed with SMTP id
 956f58d0204a3-67a454bdfc5mr1270836d50.60.1792899391596; Sat, 24 Oct 2026
 20:36:31 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019064157.29885-1-laoar.shao@gmail.com> <f68e7f9e-6037-4087-b7cd-a17ea4dba279@bytedance.com>
In-Reply-To: <f68e7f9e-6037-4087-b7cd-a17ea4dba279@bytedance.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 25 Oct 2026 11:35:55 +0800
X-Gm-Features: AclHuK-Ie5-cJruVMuWsByPpF2E5memGw2rPj5uhPsydhaudr0vHLSJ1wQm8wZE
Message-ID: <CALOAHbBP3n1uyC6qE-678ZNvh+12HSQ-H24xg4RqGtaZXKbL1A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 0/5] BPF-based per-cgroup NUMA balancing
 mode selection
To: Li Zhe <lizhe.67@bytedance.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, 
	yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A15A3140002
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: xyrdc9z9xcrhxaw3x4n8gez98741dhmr
X-HE-Tag: 1792899392-19528
X-HE-Meta: U2FsdGVkX1847hKuJwfKh2DoILBbZEhZDYI/YBntAlChJNZ9ibP+27ahT08UqyIoAH2CO+uanaTB8aplrQteL6l6iCcTXfMBrwYia6CKB9XfYEtDKYZLwnrcelMXMqe8MctuDUvUg/ns6O56osEefyqcKQKuDTHmSFMGd8ZsVqKR7dRyqjF2DJd54yG1LeOwSwLwXwqdfkYj53j4vVCkQndRU0aFybbI9gd+LtBstZtJGGxR+uWp1g9CRzQfjQksx37WF+/+HFpAuGcoodWjh355lt4OttfLs/si09S8wQ6DeGV9yl98PtAM1azCavAFCqv3h615WffS31nzGLWInkfk9GySxi1InLcRDbf7OK/8fD51kTis7RdeRNqL/4qmJqFLkKKgAwoNBboPPYk5u3a1yXslu/aBkMk/8tihBcuUujT9aIb9+fh/H311ayICfWAdHkfytrde4beliuG0s3x01Emju2EOooEoRTgYm9TwpBoDM4usBEYEpKBr1h498lqlxSti/PYd2yu8Vrq/J1yS479JwJq2iQbUIF5nQLuCmV5/jTq38sn+GlQ+L12BtZ9f+SGSk3HTP/kSF3SjzUTKkkcQOmNZ1Lk9oLWCRHkm6q09oKVS9zdVzkDX0rxJwRCT+BL0JXtHhhIo2m9ryyRuwX190B2AyA3PHAoPtdv4m6nPt7HaijLf1BtMCJ2kfx257/0lD0grHS14HUbvekE6ZNY7zz+RHVQX+PMYcjlSUUqUHsyAG/2lkEYgisdd9kZNPCKQDWWEp93xvMuhLFu2186RmaKpR5cb079ioQMn+uG75idLbABTVzRXP1nyjEiJalmvD7GvrYlq3Awj0FEm2DyGFnITCqzth3aYXl3j6TGF7FKunZLspI1UEg55LQ1fRPMDGBfKNSj4y1XyioIwjr3gGXu/IPWz1389oGktwsMxXObJw1ldVTND2s/n9hX8eGp/M8hbfc+MN1R
 OWLnmhT1
 bFk2/0BUhehPRDtsIXIKFC0Ctp5xO+IMxV6f9MVnhH61mCWkCu9aOnaZVEWoN7J5FAar5tiI+KwvBC8L8jtCODrf5o0tiCm8kr/uhuH6pzhJJaIjpGKfYh7QT5RnUQPWZcN5cnVZHSd+nqYDsh/yC2aqevKE9wvs2iGHfZpz1oPuDkO28Y2czCPC+COHovxkjzuVcsGuWmivZaLbBitPTcPUEutQ3Nk87g26D6cTlnsBb4okjqx5Du2bgRdART4pT2j/R7cS6FNXgblZQeYiOrfhIR7LxIFjVKvZ4fiVtvjgztBhu3iFEq9C/rKOj5hU6S/pcQAYwhgTlpad25Cl0nCMMdh56vsTqAEtjIdF3IByWB7Y0OHYfW+P2ecJMKpdUrYoLZcMC89sn5iCaN+m1JDfRslVe1mOfPq8Is2xgkB9My7yV0RDpsQ4SRyw7R9nIb1ZiFWdlTkS6A7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 2:32=E2=80=AFPM Li Zhe <lizhe.67@bytedance.com> wro=
te:
>
> On 10/19/26 2:41 PM, Yafang Shao wrote:
> > The Problem
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > In our large fleet of Kubernetes-managed servers, NUMA balancing has
> > been historically disabled globally on each server. With the increasing
> > deployment of multi-socket AMD EPYC servers, cross-NUMA access has
> > become a critical performance issue, which made us reconsider enabling =
NUMA
> > balancing to address it.
> >
> > Enabling NUMA balancing globally is still not acceptable since it can
> > introduce latency spikes for latency-sensitive workloads. What we need =
is
> > to choose per workload whether NUMA balancing runs at all, and which mo=
de
> > it runs in. A latency-sensitive service wants NUMA balancing disabled,
> > while a batch service wants its PMEM-resident memory promoted when hot
> > without paying for scheduler-driven migration. No single global setting
> > serves both.
> >
> > The Design
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This series introduces the fine-grained per-cgroup NUMA balancing
> > control. It grows out of Tejun's suggestion to store the existing
> > NUMA_BALANCING_* bitmask per cgroup and expose it through BPF kfuncs.
> > cgroup::numab_mode holds the request: NUMAB_FOLLOW_SYSTEM (-1) defers
> > to the global sysctl state, anything else is a bitmask.
> > bpf_numab_set_mode() writes a request, bpf_numab_get_mode() reads the
> > combined request of the cgroup and of every ancestor back. The hot
> > paths walk the same chain at read time behind a static key, so while no
> > cgroup makes a request the overhead is one patched-out branch.
> >
> > An opt-out wins and binds the subtree: a DISABLED request anywhere in
> > the chain opts the cgroup's tasks out entirely. Otherwise the requested
> > bits OR together and the kernel reads them independently, the way
> > kernel.numa_balancing reads them, so a combined NORMAL|TIERING engages
> > both modes. A DISABLED request only speaks for the cgroup's tasks,
> > never for its memory, which follows the remaining requests of its
> > ancestors.
> >
> > The cost of the additive combination is that an ancestor cannot cap
> > tiering short of a full opt-out: a descendant's TIERING request
> > re-engages promotion for its own memory, and promotion is the mode that
> > consumes the shared fast tier.
>
>
> I am not sure that this matches the usual cgroup hierarchy semantics.

I think the usual cgroup hierarchy semantics being invoked here is
the semantics of resource limits: an ancestor's limit binds every
descendant.  That is the right semantics for limits: a limit
partitions a shared, finite resource, and what a descendant
consumes comes out of its ancestors' pool, so an ancestor's limit
must bind every level below it.

A policy request is a different kind of knob: it is a preference
about how the kernel should treat the workload, not a quantity
drawn from a parent's pool.  Nothing is consumed by expressing it,
so the limit semantics does not carry over; the question is only
how the preferences of several levels should combine.

We chose the additive answer: a descendant may ask for more on top
of what its ancestors asked for, while an opt-out at any level
still wins - DISABLED anywhere in the tree caps the whole
subtree.

This also matches our operational experience with policy-type
knobs in our Kubernetes fleet: letting a child refine the result
has worked better than having the parent's choice bind the child.

So with
                      Pod     (NORMAL)
                  /              \
  cgroup-A (none)  cgroup-B (TIERING)

the effective modes are

                           Pod     (NORMAL)
                  /                      \
  cgroup-A (NORMAL)  cgroup-B (TIERING|NORMAL)

> If promotion consumes the shared fast tier, why is a descendant allowed
> to re-enable TIERING when an ancestor cannot cap it short of a full
> opt-out?

Promotion can't make a cgroup consume more memory than it may
already consume: it moves the cgroup's own folios, within its own
memory limit, from the slow tier into the fast tier.  The cost to
the rest of the system is placement contention on the fast tier,
which each contributor's own limit bounds.

What an ancestor can't do now is cap only tiering while leaving
normal balancing available below.  If that targeted cap is wanted,
the natural extension is a negative request: NO_TIERING would
propagate down the tree like the positive requests and mask
TIERING out of the effective mode.  With

                  Pod (NORMAL | NO_TIERING)
                     /            \
            cgroup-A (none)   cgroup-B (TIERING)

the effective modes would be

                      Pod (NORMAL)
                     /            \
            cgroup-A (NORMAL)  cgroup-B (NORMAL)

For the RFC I would keep the modes minimal and add NO_TIERING
as a follow-up once there is a real user for it.  If you think the
targeted cap should be there from the start, it is a small
addition.  What do you think?

--
Regards
Yafang

