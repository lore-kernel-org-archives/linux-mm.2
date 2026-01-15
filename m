Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A3D1D41161
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 10:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97F3F6B00A2; Thu, 15 Jan 2026 05:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CC56B00A3; Thu, 15 Jan 2026 05:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F236B00A4; Thu, 15 Jan 2026 05:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 704AA6B00A2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:24:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D814D13A3E4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:24:48 +0000 (UTC)
X-FDA: 84333814656.11.EADE1F8
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	by imf03.hostedemail.com (Postfix) with ESMTP id B1EB020004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:24:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Vk5+c4mr;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.68 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768472687; a=rsa-sha256;
	cv=none;
	b=zLT2ddJIT6DjmCuunm4V7+6kcj/GAYoGyxiinp/llMNt8i0ACIFvDrpf8hOhsYZYJB1QQB
	VEjKofEttmEtJtcaIIPt4slNhqoCppRE6nye9Qy0GSLO/ja1SqoRpAfHhosPAJw4w/UiQ6
	ct80AFW6h2u7X3zG3OOpiGHIJn5VHFY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Vk5+c4mr;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.68 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768472687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZP8rRtEvMK5KfbtDsP2vfBcfyghWq57iuvfXZ5BkugU=;
	b=7OpI0SViz18PkL5Br0aEcbwhTgndM8kFe38VLA8ygpgZdg4JyUCJY4xP95M89LaThXksif
	N5GxmSpPL29kJdOFun/uhySduQgxYyLM1rBVqx5NzoRBXpukhSckI7a4ZA+A6IYMDNGH0h
	TImGM/Jsmq8ZuSqhPnZ6SwAjrQti+20=
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-432d2c7dd52so593416f8f.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768472685; x=1769077485; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZP8rRtEvMK5KfbtDsP2vfBcfyghWq57iuvfXZ5BkugU=;
        b=Vk5+c4mrpwUfzTZ0xVnoMpMf2BB5b7DSS1WdQkzbORdCqj36ojGI8mIr00t2Dr4n1V
         XZVjafw8UB4/8ylh0hTnIYEu9RfrP9fLhUS6yop8yZ647UtmxJMhKf6J9gO4zlBcqglu
         Pgen0/SymZASHVSsAlr5sqw84g+Fxr/9inezxx+oq1EtjmtMZ+Js9XCxSqiBCZPD6+X7
         WQLK+dYHq5dVXqvX5XBrIUP4c/Ne0+aPurku4ed+yiCYecITREUczprUrZfe2PNKCFQk
         hHEl26S9rL9oVHwEfe1pNgKa9F7F4DnKBw2wdZRveEr/E95gEUEo/ZfvdgKBDIvLEZGa
         nlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768472685; x=1769077485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZP8rRtEvMK5KfbtDsP2vfBcfyghWq57iuvfXZ5BkugU=;
        b=YB2JeUyEOsd16yYsiO5e/+vitizakxBOqTrm0PVym9HcGk8pgWAytkHFs3DGZYt9eQ
         tbkAwUMV4VMGYL7caRSNIXPT5pTLentXsYHLYjXSzM4itCJj5Mga+oc+LYmZCNzkmMAB
         0Lfe3yhmhhN7O9DNwQEVkYGqkCTyfykunwAjZdqHbYukN4sErtsDSgn5hXcyL8cTL7dT
         cKRNJcrhnQKO5OqHPGSVPYfqjKlQRdZliuB2tNkIXr7DePs47HvZ9kdyD6T8By8x7s+m
         EW5abO+3zhJcDDMTGDG3BePFfTzCwK71DRSAxMlFyKvqoDVk/wjo8k+2NyAj0SjG2dWS
         6Dzg==
X-Forwarded-Encrypted: i=1; AJvYcCV5riXifLksNBV2ZXmXWQMXHcEVy4Y2CDMfYm+Vy5xbCAw+jShbcDRTcQltWIaPJ34+2ISpJWS3mQ==@kvack.org
X-Gm-Message-State: AOJu0YyFZtwxbAWGmFVjT12WulTBm0ohXHTB5kLQVuwYl+DWxVnddJFa
	eVToRIfFxpupullcjQpmSBBotYP0mtJvt6BjBTaU+8WS9rx4B3BJyQ1sdoDShZBTwCI=
X-Gm-Gg: AY/fxX68P59jb84PAj2BJcln7ZSaO6LCyaTcPE3Qq9AxYKlnS404JuaevNSChK3D1Lc
	+TETNdNBJD79IceZq+4XBvS1WDMef4vkszQH6jp3C2/ZN3b9YFnzDq6LFOa4v+oGeVkhglWbcjC
	mBdzrLp1Q6m5rG8reVxyq8bhd1b/kcPMjMDRQc0fhUnAvcX5TwHtKboGaEqXuj5JcS5LBrKROCr
	uDRmTNGczwvCWM7bjSuTwq/LomzNHYO+r9Gg9FmKJ3pg78Q06zjXHUsWA2esO/0EkvqzorjguOq
	gyTERmdmzJGYMIZs7lnX6fLC1lNJF6po4h082whL73G44NjRtnv7xq0IczidLrbQ7COeZMMZ1kJ
	zs/xzZAYeAdVZpw9BTG0XfJI7sI5unpadGmBbxS/MPSpLqHMHn+Bqeb7AMuLekFOAXtxPYKnrH+
	548JLcVeyI/S5wqBaSJcASGyz+kDXwFvY=
X-Received: by 2002:a05:6000:420a:b0:430:fd0f:28fe with SMTP id ffacd0b85a97d-4342c54ace1mr7667501f8f.31.1768472684978;
        Thu, 15 Jan 2026 02:24:44 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-434af64a778sm5006260f8f.3.2026.01.15.02.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 02:24:44 -0800 (PST)
Date: Thu, 15 Jan 2026 11:24:42 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: roman.gushchin@linux.dev, inwardvessel@gmail.com, 
	shakeel.butt@linux.dev, akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, yu.c.chen@intel.com, zhao1.liu@intel.com, bpf@vger.kernel.org, 
	linux-mm@kvack.org, tj@kernel.org
Subject: Re: [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa
 balancing
Message-ID: <z5lvdg7fonhyrt4zphak6hnhlazyntyrbvcpxtr32rrksktg3j@wpvmby6yonbr>
References: <20260113121238.11300-1-laoar.shao@gmail.com>
 <20260113121238.11300-3-laoar.shao@gmail.com>
 <cfyq2n7igavmwwf5jv5uamiyhprgsf4ez7au6ssv3rw54vjh4w@nc43vkqhz5yq>
 <CALOAHbB3Ruc+veQxPC8NgvxwBDrnX5XkmZN-vz1pu3U05MXnQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sgrrerx4codwdoe2"
Content-Disposition: inline
In-Reply-To: <CALOAHbB3Ruc+veQxPC8NgvxwBDrnX5XkmZN-vz1pu3U05MXnQg@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: qg7np8pwn8ejw36grq6ks3xdn3ajss64
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B1EB020004
X-HE-Tag: 1768472686-516436
X-HE-Meta: U2FsdGVkX1+390ACPTuqwPZMrSPSisFpMB1W9NchFpouPSpuyLuVuiWAiRku+r0NEIyGWioyL3C65V9CihucaShNxKdL/fm2jeecAmwUN1RwQDUZYKgObp+j8u4gbkgmuR1CNiS4qmZbELUj61QoSSHhguuXOWE21zjFVniCLJxiCWFqXAT8LiChKotvH2W05INpQqiCj8cRt8BiRHOWjVeJEwd0Y5X4TKJ1UJbjh++0H7wGCt4ZQf6J1JBLlhXaBLZYA86WGP7328tlq5X5JU/oSFVHRhLVjTkmCaTBj9gkWU1AxNxnaxcPUtL7O526UqyQxybfRkecgPsrudvq+YN4cQaeuYX9bknEQcGmlfqMgeBw7XmvOYBHUgt4nySYyPwZp/N6wgHQAdy4d1uUmmpDu9WP5v0ESeKavMQdZuJJ5avI+8pmAUfP+PdGXjPqah7AWGSY55uKQ22PZyHxeuLW41T8Dj9olhI8lQQSso0Gx6QZRC7NYpeoO4HOVgA1ROPl9GSZkgwfO4NCXVAQTg/KUNHAW7yYXLawrmsE2+jBC0J0KBtxtYs/DdjAngTX+P+tUNN0H27UnB/3b8CPCa2Q57GdvJb+uec8ys/8ZFQlyf467ZxZ8ibUt7AXxfsAmGuKvpN2ZueSzipEWg5vsztych3CrZtH9TjmKsypo8ViN9xkfyecsVg/L9oKQuBAKWqZMM1xIsGQUxiOkIHhljzqvukZvPgzZ3zqadcHFyhtsgyqbHd6y35E0vJNlGSKolqMY0U0Yx/dU6GKys7bm5O1IQk/yZuofaVUUbxen16sOcI95lmc+A5b6D2+qRHFzxXtKzsMbTe/CvwiagAVmqTHLbwpiTaWJMsIrRakxSK4vL7z6ppj8EoH8FIMd7RFbymuYOKy6LheBasuv7+JHlJkEMzwICgDHDxmfj2EBVp3m4r67kRpyfKuFcigtCgHhA/SJPRYXZ1jnrD4zPg
 8usdED46
 +vZ/8Bx4/1tG2MY/cz2QmDT3gORn5Qjs8FLMVnc9lIrR2ZkqT1WwP04S8u0QVNb26Skk+Gjaher1Pt7z863pFPIy2b16Jvurp4YIa2oGPX5HOWQGv9aq4c1qUMXJV3lTw0/uc+gFbrNZTx9jIXECBWkWjVduwaroe5nddnyFAfflkiuBy1LymszrzjAM2BzVIxW7Mpc6zXI50hBrzhQ+2pr2qhBdU6d/khwRrUrfukMavaG5HmWmZOftoL3QtrbYLsQTGVuDvKRsIo+J176qd8I+W9xtgs/qQG/y0i9lpgRQrz/1nid+iJ87vPVMngGHFqAihsYiTgd06D2mrbp4TrJUS/SWjfhUICDGELMaK/C2SrS+yzQL5F0lVZDzHbPjxUrdTYtTEm6uhTRd2izJ/yBjrvfkNuxx6kZGFEhj42MHeaeH8G+EVAVLOkehHmj5GdKjH0pCY7z5dKslw7DZhzqMWFTGdDD7MLBZlHG/pRhdbK1Ylz3xnr2UdnkdZ7EcuZ9DKAG4I9F9/FdtBHUO4ZJhpcoHjqB71TWwkzAavjtuYjcAqH8t9BNDDmYFU+NF/Yr4A3XZL6KDk2aPHcspuZPqKNvAMCm7UqJeGsDwyffmHwmMyfbeEglqacN+NOQHgD0iBoJk4p0leBNAnxFWna8y77Mhd6Rm6KNfH+MHJ32n7BJckPiX1t2FH1PoiXwJ9R56RV3qXaw/7/EITWmBLA7HQuGSF3V5mXSd/oYhFhTyeHCbjWU2Avqkj8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--sgrrerx4codwdoe2
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa
 balancing
MIME-Version: 1.0

Hi Yafang.

On Wed, Jan 14, 2026 at 08:13:44PM +0800, Yafang Shao <laoar.shao@gmail.com=
> wrote:
> On Wed, Jan 14, 2026 at 5:56=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.=
com> wrote:
> >
> > On Tue, Jan 13, 2026 at 08:12:37PM +0800, Yafang Shao <laoar.shao@gmail=
=2Ecom> wrote:
> > > bpf_numab_ops enables NUMA balancing for tasks within a specific memc=
g,
> > > even when global NUMA balancing is disabled. This allows selective NU=
MA
> > > optimization for workloads that benefit from it, while avoiding poten=
tial
> > > latency spikes for other workloads.
> > >
> > > The policy must be attached to a leaf memory cgroup.
> >
> > Why this restriction?
>=20
> We have several potential design options to consider:
>=20
> Option 1.   Stateless cgroup bpf prog
>   Attach the BPF program to a specific cgroup and traverse upward
> through the hierarchy within the hook, as demonstrated in Roman's
> BPF-OOM series:
>=20
>     https://lore.kernel.org/bpf/877bwcpisd.fsf@linux.dev/
>=20
>     for (memcg =3D oc->memcg; memcg; memcg =3D parent_mem_cgroup(memcg)) {
>         bpf_oom_ops =3D READ_ONCE(memcg->bpf_oom);
>         if (!bpf_oom_ops)
>             continue;
>=20
>           ret =3D bpf_ops_handle_oom(bpf_oom_ops, memcg, oc);
>     }
>=20
>    - Benefit
>      The design is relatively simple and does not require manual
> lifecycle management of the BPF program, hence the "stateless"
> designation.
>    - Drawback
>       It may introduce potential overhead in the performance-critical
> hotpath due to the traversal.
>=20
> Option 2:  Stateful cgroup bpf prog
>   Attach the BPF program to all descendant cgroups, explicitly
> handling cgroup fork/exit events. This approach is similar to the one
> used in my BPF-THP series:
>=20
>      https://lwn.net/ml/all/20251026100159.6103-4-laoar.shao@gmail.com/
>=20
>   This requires the kernel to record every cgroup where the program is
> attached =E2=80=94 for example, by maintaining a per-program list of cgro=
ups
> (struct bpf_mm_ops with a bpf_thp_list). Because we must track this
> attachment state, I refer to this as a "stateful" approach.
>=20
>   - Benefit: Avoids the upward traversal overhead of Option 1.
>   - Drawback: Introduces complexity for managing attachment state and
> lifecycle (attach/detach, cgroup creation/destruction).
>=20
> Option 3:  Restrict Attachment to Leaf Cgroups
>   This is the approach taken in the current patchset. It simplifies
> the kernel implementation by only allowing BPF programs to be attached
> to leaf cgroups (those without children).
>   This design is inspired by our production experience, where it has
> worked well. It encourages users to attach programs directly to the
> cgroup they intend to target, avoiding ambiguity in hierarchy
> propagation.
>=20
> Which of these options do you prefer? Do you have other suggestions?

I appreciate the breakdown.
With the options 1 and 2, I'm not sure whether they aren't reinventing a
wheel. Namely the stuff from kernel/bpf/cgroup.c:
- compute_effective_progs() where progs are composed/prepared into a
  sequence (depending on BPF_F_ALLOW_MULTI) and then
- bpf_prog_run_array_cg() runs them and joins the results into a
  verdict.

(Those BPF_F_* are flags known to userspace already.)

So I think it'd boil down to the type of result that individual ops
return in order to be able to apply some "reduce" function on those.

> > Do you envision how these extensions would apply hierarchically?
>=20
> This feature can be applied hierarchically, though it adds complexity
> to the kernel. However, I believe that by providing the core
> functionality, we can empower users to manage their specific use cases
> effectively. We do not need to implement every possible variation for
> them.

I'd also look around how sched_ext resolved (solves?) this. Namely the
step from one global sched_ext class to per-cg extensions.
I'll Cc Tejun for more info.


> > Regardless of that, being a "leaf memcg" is not a stationary condition
> > (mkdirs, writes to `cgroup.subtree_control`) so it should also be
> > prepared for that.
>=20
> In the current implementation, the user has to attach the bpf prog to
> the new cgroup as well ;)

I'd say that's not ideal UX (I imagine there's some high level policy
set to upper cgroups but the internal cgroup (sub)structure of
containers may be opaque to the admin, production experience might have
been lucky not to hit this case).
In this regard, something like the option 1 sounds better and
performance can be improved later. Option 1's "reduce" function takes
the result from the lowest ancestor but hierarchical logic should be
reversed with higher cgroups overriding the lowers.

(I don't want to claim what's the correct design, I want to make you
aware of other places in kernel that solve similar challenge.)

Thanks,
Michal

--sgrrerx4codwdoe2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaWjAaBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Aip5wEAmBM3Eh0XmAjz2UXAxlR4
TIdMfYbIuVZcUPqJBLuuKwEBAP+Tg17ePUYbRyjXabdKqyVmbO6OT7tDGpaUncgR
wBgO
=50PV
-----END PGP SIGNATURE-----

--sgrrerx4codwdoe2--

