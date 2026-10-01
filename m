Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B7ECA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 22:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6FE06B0088; Thu,  1 Oct 2026 18:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C218D6B008A; Thu,  1 Oct 2026 18:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FAC6B008C; Thu,  1 Oct 2026 18:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79F316B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:21:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8C0240574
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 22:21:26 +0000 (UTC)
X-FDA: 85275479772.30.A1C6A74
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf30.hostedemail.com (Postfix) with ESMTP id F211880009
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 22:21:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DArKaRU4;
	spf=pass (imf30.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790893284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mALVOgiCxDIxJdJ6U8iXiJsvHp+DzhgFCGAE0EkhNn0=;
	b=OUTkPcyel39A+EUZbik8WALIak4MmvZY/N1QgcAzvYC/ZJTt1iFJ2ZdKcTWRbMkMw/uitJ
	C3iPVDlxmtCleuXCmWLATIcbhdqIcdsR7SrvkijbI0oNgbkl1Y9QEANcCGlyWcaorO6+xJ
	Jj6FoFl4Qf+mlbLojPBmORkfvOH6BMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790893285;
	b=X3zaZg6x7C7AZ8KQ4Ij614+gvLdcxYME1pZBrgQxNpNLQ6azxADs00oHROd1LEd+PXXa5N
	HhZvRJhbP3O2eEX+6yuEECLE6ya4yOCEOawCaar2cfhtJwTZEqx5SOOdShyDnOjeuMvVex
	LhWyFtIxRqDQ0GbrDjcsJEhp56aZVRw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DArKaRU4;
	spf=pass (imf30.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b0f4efe31so649678f8f.2
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 15:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790893283; x=1791498083; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mALVOgiCxDIxJdJ6U8iXiJsvHp+DzhgFCGAE0EkhNn0=;
        b=DArKaRU4zg6sxU3vfp6D5YEilDt5YXO69D9OiKvwHHbpK0Cj8XyqQtI8bUsUJtytmy
         luwa0kO8FBcfcB0u+sJ5kICGa4CmJGXvFWRTb8r9kqVRmmUXC1k3Ky5V+AUdgOPid6ht
         MLpvVWQlyvvKyPEWHQGPxhf+8qa2l6YZvXpWk0m805x4xKLaXNdh/V7RaFutHIKD2ljb
         d+fI3JTh8Fd2CgavVg/DarM/EQlNVWvlXXlNc4Y0o4rxeuUnbW6lSn4YsPtS91qJsoOY
         ACLcwPZpg4cKL/maWj56A4ZRue0XG5o2ljW8UzCpPbZaZWI2cqnZGDSQCYRzU0nVB/mV
         VzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790893283; x=1791498083;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mALVOgiCxDIxJdJ6U8iXiJsvHp+DzhgFCGAE0EkhNn0=;
        b=CVEKRznSWbAoUfGGfEN7Brm5aO/4OpRUrJbFXxRhFZfw6kBL/3eAB1dhLpM0FTgLBD
         Y8hvESIfSHgOeNz0y4AeDr2He6bQBIX27Y7GsI54RBkVq6GM5tB6lOxN/rARsezih/VF
         aqrxZFIKETM6MWw/+HihBF0y/sC/IWQS7K8w1In13OGnHEeYwZjOxxnNmLZg3/d+8Duk
         bCGANx0Uo1FGaazItHKTef8FwGGkG5p5es9RLDcMjayU8y4rjiWZ1KV9TElNEtCW4LnQ
         oE6y5OR0p19r4nddxTaD5JzKrfQCe99yVXZtA91b59NiKKM2DtwfXtIJWvE9Epmd4rVA
         0geA==
X-Forwarded-Encrypted: i=1; AKwUvBxSh8HB1Crpu0Qa1qGYbP/94lEIKXqxjuoq95tu8QkzJ5Df2wSurHvDVA19Yn4GYY59kuV5LuqbQw==@kvack.org
X-Gm-Message-State: AFq9FYIXmYLfM21N3cqQSe9N6Wz1Y5kwlf20pyfWB/CdU+dEmOEt0jCa
	Tsp+Jw/5m59YvqqQCuFJdlka0cqB8jxXurVu3EXsfNKj/gmd/WSIxpk3
X-Gm-Gg: AYBFou1aNSFGqYamE83FQb3wTaOkgnIxFRtWbdD4Rt/9XK1w5JwMVsBYSikvRijwllF
	sJi6jzNybF4QHwj3E4hj5wn0h7qj6FFvmNTaz5U8/oMrfzSg/Hls2EmvM4B+GBaz7+9AyqLlqn1
	PZishsvHu8hef8Iqs+MxGidJTXNWwz791Ts3tQTPo6jfUIWHMQhzOUEnU7J98sHhxWqVll8frXZ
	MBEJ4udd1goORQiJjhEWj1o4qbVXM7oqUM1GGWYkYQ20DVAvs1ZvHESiVtwHPG+4HUMUvp+Vsex
	U6LMkJ1fULakPXzS3gBB/k/NutFK4u9ueSEc9IrNYXz0xN+hZoDvDhrR0gcjeXef9YNASr5EeAC
	ZZ4ig84rxn7h7yr2VdSqKgh8avI+6GlxFwYXkx37ysclobzyk3VZnvZ0VTOPWhZi93JI6c1zQ//
	BzI+BmGRr9rDZL9ToO9m8bl/ry2kQkQPlPexXexu2L494J14GEFAjYuDOfd0yFmFNRPkdab+YKG
	EQrz4MB1Hju8UCnQG04+zSGcqOCWoDlkIY=
X-Received: by 2002:a05:6000:4b06:b0:48a:f318:ac02 with SMTP id ffacd0b85a97d-48b1270e876mr1613511f8f.19.1790893283205;
        Thu, 01 Oct 2026 15:21:23 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b382fe9cesm1315755f8f.42.2026.10.01.15.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 15:21:22 -0700 (PDT)
Date: Thu, 1 Oct 2026 23:21:21 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
 luizcap@redhat.com, pbonzini@redhat.com
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261001232121.65c54816@pumpkin>
In-Reply-To: <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
	<arZHp8hjYFXE8Rkt@gremlin>
	<arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
	<areOeRwZOez0eHm7@gremlin>
	<arotyz5g6LozSjb1@pcnci.linuxbox.cz>
	<arwNebjYXyGqrp32@pcnci.linuxbox.cz>
	<arzRBv9ceJsxJppI@gremlin>
	<ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
	<ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F211880009
X-Stat-Signature: 97buojasrawymm5auxts81fcj5wpmurw
X-Rspam-User: 
X-HE-Tag: 1790893284-152261
X-HE-Meta: U2FsdGVkX1/poPSKU4PMt/ZQuPpUJKRignaDf90hm5cOzgGBi95anPqZfa8K+3oOFSk8WdFTPuwV8CHpW7pp2/9K7sYSoyURFSNR5qd2v31dP20UHti3SrdIGw5XXJXsVJxwKBPnZNMs5xjaZiSjIMcDicFJHnW4YkDqtr+ZtUAG9TOTOnuARMxvLyeCIjIwjAUoD3STc8+YvZqGfMyod+0kJmREUdsRqugAXdkytU96m9fMuR8gOSqSvk/iuQb/Yvo/+NgEjDixnDE27YqI4ud1G2YzzjEqlhb9oR5+/yWRDBkbBCWJeDXekEMqf0fmk64fZvknkd6p3JFlcNobynnuuJ6o7Vq1Mv1a6VpDd/xrDnY/+bWUQrFHsOqgNEcslScqw6a5jvwMKpig4m9EW4NlHoS0mjLhIYXu7tmxeSmIcyYOcuNgGxC50ZSRrgWUDN0AMJxveJq3zWIsT3iQdAxJ/OnuhqCKLQK/B17sfZh6iv0Qyaxk7t1qrWXUJHSJ8M+NuPyw4goSn2yI2gqA9iW1ZFA0l5CJ4F8S/U7MUgHnpDXBWNaPfH2q40qEFXVnDAlVt+id76zOy7dlaD6wdie/Z4GeK+ocMbZPWsbW0STbHnHXFu098pBoRFkuTkvU8dlONDHd1aQzCbUt5ivXal7oDKOb8ZMCpBm4C2QZc6YHGxnPt4FfhTKliXYcHjh7iG7NpvDIAhGc3MVBMwkb70wi3jBJQiaSN3bsEH45LYZGUEYZbQew3b04Rv7xrR5+HROxAEBgRB7bM749Enrk+S3xN7Gnube7StGys6AjfntMwtu8AbS8X+aOCeo4zQIKOKihQCzqpzbhofXpP4pdv+MYaSM65dbT/9KYfgFt2IX4FdB7BqLgjD0pG/hfL7s2C68fVFdZ0X58MBWebZ2labdk9CROOWDKhlhUz3VaDSA/1CwP2Z7Xs7tmomxQlbKDSwlKZU6NbyI5T6LDxvQ
 fkqcC3iY
 oR1n51zHwtgG4unlkaEpYSuv3vOjjKvsVu1k7Qs1BGFbZznXly7MxGzBovwLx+8WgMqRxou9A96YqxehE3aqfsinLBC5HFegWiTZF6lPO/ySKI6vD/k923/u653/uo4B6Rszc4Eac6vTU3PSm72uySZmbdCek4sM1HCARWj0Y8+n/lQtW/VhHB7G0kzRWtaR5muac+mePCFmbTAGhkQ8hcnV/TMQu0QKC9999pwaqd35i3CFfIWNgxyvbRjqyIs2CDMpHkqQwlPPqwooc0AnJCvjcenehoHlCRlqYi/USgR5mr120o3XTfZN8Mlu4U5tiX4z05bDgv2iB2QFgxoqQP5SzMJ5ADtE30xQZplrwG9klgpSjWPvO+0XgEcHhnrtGvjht1EFM1BX9keHdi8vNAV+FfDxLz8swebfYyLaQaP6NI8L87bYyuPv/ttuh4UE2IGlIp4o+BlN24kCmNDCLN1bGa0saPXm/5+raTnECtDEvRCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Oct 2026 21:40:58 +0200
Nikola Ciprich <nikola.ciprich@linuxbox.cz> wrote:

> Hello again,
>=20
> the good (?) news is, in the meantime we got another crash on different m=
achine
> and I have a kdump including complete vmcore. This one was 6.18.53
>=20
> here are some details:
>=20
> Hardware: Supermicro AS-2024US-TRT / H12DSU-iN, BIOS 3.5 (2025-09-22). Du=
al-socket AMD EPYC 7343 16-Core, 32 CPUs, 1024 GB RAM.
>=20
> analyzed with crash + matching vmlinux debuginfo:
>=20
> Oops:
> general protection fault, probably for non-canonical address 0xfffffff0c9=
30038
> RIP: __d_lookup+0x4a/0xc0
> Comm: systemd PID: 1274600 CPU: 23
> Call trace:
> __d_lookup
> lookup_fast
> walk_component
> link_path_walk
> path_openat
> do_filp_open
> do_sys_openat2
> __x64_sys_openat
> do_syscall_64
>=20
> Exception frame registers:
> RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 000000000000000b
> RDX: ffff985ffd223600 RSI: ffffb18962823d70 RDI: ffff989ddf09b5c0
> RBP: 000000005560450b R8: 000000007fffffff R9: fefefefefefefeff
> R10: 0000000000000000 R11: 93c3d2eb02a31dda R12: ffff989ddf09b5c0
> R13: ffff989ddf09b5c0 R14: ffffb18962823d70 R15: 0000000000000000
>=20
> Faulting instruction (cmp %ebp,0x18(%rbx)) dereferences RBX+0x18. RBX held
> the non-canonical value 0x0fffffff0c930020, giving fault address
> 0x0fffffff0c930038. __d_lookup was walking the d_hash (hlist_bl) bucket;
> RBX was the node pointer being dereferenced.

Surprisingly it looks like your compile matches the one I built from head.
The crash seems to be from the 'if (dentry->d_name.hash !=3D hash) read.
Annoyingly the list is followed with 'mov (%rbx),%rbx' so you don't get the
address of the previous item.
However the same bad address is in %rax.
That would rather imply that it is the first time around the loop and
the 'bad address' came from the hash table itself.
(Unless the exception code manages to corrupt %rax.)

The list being corrupt would have to be memory reuse (for something else)
and the rcu protection not working.

I've just noticed that the RAX and RBX values (and the code RPC offset)
exactly match those in your original report from 25-sep.
That can't be a coincidence.
Has to be some kind of 'smoking gun'.
Possibly scanning the entire dump for 0x0c930020 might show it being
used somewhere?

David



>=20
> Observations from the vmcore:
>=20
> The faulting value 0x0fffffff0c930020 is non-canonical and is not a mapped
> kernel address:
> crash> kmem 0x0fffffff0c930020 =20
> kmem: cannot determine page for fffffff0c930020
> fffffff0c930020: physical address not found in mem map
>=20
> The dentry being looked up (RDI/R12/R13 =3D 0xffff989ddf09b5c0) is intact=
 and
> well-formed:
>  name "app.slice", len 9, d_name.hash 0xCE973022 (consistent)
>  d_op =3D kernfs_dops; valid d_parent, d_inode, d_sb
>  d_hash.next =3D 0x0 (this node is the end of its bucket chain)
>=20
>  The target dentry and its hash chain in the dump show no corruption; the
>  chain terminates cleanly.
>=20
> No page migration, compaction, or THP activity was in progress on any CPU
> at panic. "bt -a" filtered for migrate*/compact*/khugepaged/kcompactd/
> kswapd/split_huge*/folio*/d_move/rename returned nothing.
>=20
> Automatic NUMA balancing was disabled at crash time (read from kernel mem=
ory):
>  crash> p sysctl_numa_balancing_mode =20
>  $ =3D 0
>=20
> Top-level (PMD) transparent hugepage policy was "never" at crash time:
> crash> p/x transparent_hugepage_flags =20
> $ =3D 0x1c0
> Bits set: 6 (DEFRAG_REQ_MADV), 7 (DEFRAG_KHUGEPAGED), 8 (USE_ZERO_PAGE).
> Bits 0 (TRANSPARENT_HUGEPAGE_FLAG) and 1 (REQ_MADV_FLAG) are clear, i.e.
> sysfs enabled =3D never. Per-order mTHP controls (huge_anon_orders_*) wer=
e not
> inspected for this dump, so mTHP state is not asserted here.
>=20
> No MCE/EDAC/hardware-error records are present in the kernel log for this=
 host.
>=20
> I can provide the full vmcore and the matching vmlinux/debuginfo on reque=
st, and
> run further crash queries against it.
>=20
> not sure if this is of any help?
>=20
> with regards
>=20
> nik
>=20
>=20
>=20
> On Wed, Sep 30, 2026 at 08:40:23PM +0200, Nikola Ciprich wrote:
> > (CC Paolo Bonzini)
> >=20
> > Hello Lorenzo,
> >  =20
> > >=20
> > > Yeah 6.18.15 is expected, I'd not say reverting is really worthwhile =
honestly,
> > > given what you've observed previously. =20
> > yes, I wasn't available at the time he was dealing with that..
> >=20
> >  =20
> > >=20
> > > Maybe worth checking if commit 26505e1b5b54 ("KVM: SVM: make svm_flus=
h_tlb_gva
> > > do a full asid flush if NPT enabled") helps in that case? =20
> > sure, I'll do that.. however, the patch doesn't apply cleanly on top of=
 6.18.54 at
> > all.. what do you guys recommend, is it OK to adjust the patch to this =
kernel
> > (I have to admit I'm able to do that, but without any deep knowledge of=
 the subsystem)
> > or do you recommend to apply some of the previous patches?
> >=20
> > tried going through them, but its ~134 commits affecting svm.c between
> > v6.18 and 26505e1b5b54
> >=20
> > cheers
> >=20
> > nik
> >  =20
> > >=20
> > > --
> > > Cheers, Lorenzo
> > >  =20
> >=20
> > --=20
> > Ing. Nikola CIPRICH
> > technick=C3=BD =C5=99editel
> >=20
> > +420 591 166 214
> > +420 777 093 799
> > nikola.ciprich@linuxbox.cz
> >=20
> > www.linuxbox.cz
> >  =20
>=20


