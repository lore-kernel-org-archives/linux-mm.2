Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD0CC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 21:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B9B6B0095; Fri, 11 Sep 2026 17:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECA56B0096; Fri, 11 Sep 2026 17:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD696B0098; Fri, 11 Sep 2026 17:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE2606B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:11:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75B0FC0160
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:11:20 +0000 (UTC)
X-FDA: 85202727120.26.A14D9BD
Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	by imf31.hostedemail.com (Postfix) with ESMTP id 83D8120009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:11:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s7atofJg;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.37 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789161078;
	b=fWvEq11vRlmiOWhqeFmUI+8u5EBm4UvoacXjtT43G+XsQbAX0rH0JWTxtb5c2XsgAhTfOS
	JU6u50hyEJxa4KZTT9ay9LxTeyR6sDj16DMCTChGd2qZh/QGSa08XFs20+Vz7oPFbTy0BU
	XT95rZ2wmEF1/VAd2vu+zeMuLflsw/k=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s7atofJg;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.37 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789161078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6HV8uHNfHnA3I2z6iazz6poKohSe+yKAEsfT8M/ffc=;
	b=pVhE69TfPbfaak/pXP50/jXnC1zLzyYCgI74Y1duMNS4a6Udf30Ubm1bBIPZPDe90GsIfB
	gql7GGa1RGP5SMwK/CNbrU1zBagNdXiQGo8Vb0v42iWLhnU4mBjexgpENPjnOG6eH61fbz
	VuOhODmzlUn96PgDoxnc4lq8LYdJgfo=
Received: by mail-pz2-f37.google.com with SMTP id 41be03b00d2f7-cc4bdf8acd6so343806a12.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:11:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789161077; cv=none;
        d=google.com; s=arc-20260327;
        b=qX8oAnpA1G7sYQbaAxMu6viqoHgFeuvR7Q9JcmyK6iWa8/OZaQdqGLYb8KWu15oaeM
         6rNPM6z419Nf2uga37Ff3wB6il1MjpE43/+vE9cMegGUR+vM6WCQgPLHc22aOmYU+Fv8
         bikaFRq3mJGRZI5lL5HD3SnYNTz6q+rj1G5j5b/4QFY3eRN1JUVQpwDR2w1zHuXGf1h7
         BnhC9fE/K9QtZkSXDsPXGnsavIprwR9xpct+CVnLWy6NfyxpLq75yyWK/syXSf4QYdgi
         rrKh5PCb+ALS6DfntH8OzuQMrpwo1E44TJw1maML9LF2qpZR8cnRHmCeC+iOq+wnyim4
         dFkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c6HV8uHNfHnA3I2z6iazz6poKohSe+yKAEsfT8M/ffc=;
        fh=+gaamkn34x54p4vD1i4DCjjWps72bRpshJvMxuiulwk=;
        b=lxFyFTeqyTrSqJFF6/1h5DrDLGSgNQ5b7o9xLJwZfcJwsQlhclBw5k97jzfH/M0ruN
         ALeqo/a/iwvUSRCtRouYKVKV5xD1E6nHrZjBAmrfSzp7T9XpoGTuz51TgXjuNg7XXifF
         tTJKfsWQa5a5VhHgYlD8wnaddiI5dwsd2ZGz9o0++KQ1KJabTo9F8q+k4AgDCwPF8Dc/
         B+TYb+mG8CsB24z/tIBa48TDllLvcFtXLtvqiE1oNMtOojZfsjj7eWIXLQEE1b4lW7oW
         uVA8CWJhqfG/HjJ66ryYC3dgxCV79sglJNvHmEbEevgyZKVHSZWbNtzXeXQNG1VCMHY0
         IUlQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789161077; x=1789765877; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c6HV8uHNfHnA3I2z6iazz6poKohSe+yKAEsfT8M/ffc=;
        b=s7atofJgTB89Mhb4dk9y50Q5jBfS4KuPgcDO4gg5VaNlNXTtcK5iLW/UAi9Q2ImEoD
         5bHlnghV+gXytCSoq/fJalmOx6uVj2PGWMc8Ap25CgjjhSTQcjvYFQLGIQBJvVV3bAEa
         DrZlWJOPw3bMWzqVCUlSXXmZ7O4Fx8gx1SKvtWcES3sSMGjKjoKw4kREMAlAi7+Filib
         E0WNf/XxWW5M/YuBww5CsFU3PF9Ve2i/XdCxowCB3bJ8UBMXIuZLThEDGlm7IxnCqfsv
         QfusKXTQvaZYFMyIf/Gtlb+qs8ERil6eKV7douKz6h5XysvwhPPnxoh84fhrwm2GRwVV
         GHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789161077; x=1789765877;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c6HV8uHNfHnA3I2z6iazz6poKohSe+yKAEsfT8M/ffc=;
        b=qLg2rocHJX35kPIExDTokTMj957NQViDalqH4KO9XqzeXluNhYP5Q9Kgztes9JLyNb
         oQWLYKdUBywxn1Y1TDACJPbZeimG6pnnWVUPfXarfRSxrTLuk8g3ZRgZQjDFU964pQMe
         my4TK2qI4JuF9rw58VMhv/f4KA5+pxeot2Gf1lmP/KmivgH51MahN0xA7Qvf4HOHTx2k
         kReJSm/f0SNlv+jPNyahQgSGM3xi7Wt9LsHDuz3fTLHBL6MA8kDSaqmyXXowIoHFVWQC
         TGjRArPkBZcmKkM88Wj42dXUEyz0ke72uXMDe5x7Cpr1U3BRDNiKOTGcwHT2PtXP/nLg
         zrcg==
X-Forwarded-Encrypted: i=1; AKwUvBzZgx6gu4BLdyHMAaFBbCPVpFgiy8lrmxRNd5Pj1YW0a+O4W/fQkHNEOTigew1Clxz1OHOInc5RFQ==@kvack.org
X-Gm-Message-State: AFuF++l+nLpYMTWyBbGXzztZ/QKkOnWewBGyZBbHmSppeb7w7xipKstm
	jfMQ+u4bpH84CuBuxicQ5cexVNrKRPQatn11uxekytr5ERNiXqjZkzeaQTlmheMIELhmdKVqw/Z
	mxgxEKRrN7x4ldKZ7hfiTDNMTYzRWTwQ01E9N//Xk
X-Gm-Gg: AYBFou22eaJLI9kkeDXfFtXVeXDREiEanuCUleYBBGQI5fulPbwMiBHKandJFXyjce9
	+kEvjrgn8kCOpzmlpdZsUBSXurJnc1i63y4llsYlPGSDWISt1oj0ztS0NR28bXciymiXj8TTboE
	BjaCZ+MKKwiCWUrNP5oiUzT0k1hoe3kJJjwvBOfYmmVQRxuGYKFk9c4n2idqlIJMn3A7q66zyyS
	cIaKfYmpfsJZ/UBeZuPfzKQA8GPTMqNOBUYpplQ6KSdzWeYr//LYnXMkb5jCu1DuB5/Yw7XXh7r
	ap4pqQC1u7bsK+tCD619Gk33ar/C/DLYj/NikyTMBYfoKKmZF5m798QB
X-Received: by 2002:a05:6a21:a95:b0:3da:6bdd:2c74 with SMTP id
 adf61e73a8af0-3daed306372mr12662047637.10.1789161076494; Fri, 11 Sep 2026
 14:11:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260901180713.4185641-1-dmatlack@google.com> <CAEvNRgEs82CVTL_CUn=Ovrwvt86U1dxzr8psWGu=nk98ZH6Esw@mail.gmail.com>
 <aqRFSiicubfsw3N6@google.com> <CAEvNRgFCrcyk6F0vJ11pgj2EDSUAXj6Zw-oEdZpfj2SrH1Cv9g@mail.gmail.com>
In-Reply-To: <CAEvNRgFCrcyk6F0vJ11pgj2EDSUAXj6Zw-oEdZpfj2SrH1Cv9g@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 11 Sep 2026 14:10:45 -0700
X-Gm-Features: AcwNN1VPqi3zVmYZAELfBj-CBxTUTXJC8KC_tY6rHii958hpSbyM_Grda2-osHc
Message-ID: <CALzav=cKG9hXskFgQfub3Jg5O-rKUWBe8TBcPdJz+tBKzenFrg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] liveupdate: LIVEUPDATE_SESSION_RETRIEVE_INTO_FD
To: Ackerley Tng <ackerleytng@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 83D8120009
X-Rspam-User: 
X-Stat-Signature: p4sx3gpaxfbakxgmfomj8aui8rqx9mm4
X-HE-Tag: 1789161078-34814
X-HE-Meta: U2FsdGVkX19wudK08NkvmNHuj6wPEO/mviFLwbV9ad1feheozFY+ewGtFhMMqFp+yQTRWj2KWf+BnG/vrCFfE6PKvlXT5Cwk1aeSEbbe/1mwILWFkzwlr4UVzGKfjhYepKBoUmMsmgfNf2wYChtUR/yAnoZbXM/gPXVCTpuzh5rziP8FMWoP/oIv6wbr4ehOZc25++dDePmRf9bggqNDXpfuqYTxVNQ84nnsVcsSWSIF53cByNmn8RcIAfU4aUP41yIpmY2mMcxfhI2DrRExkYGhUbyHyU2ynrxaL13MLTEuvyxIyO9ifCeXqkzjGs9FVIqdyZ+MhPdZgdRXBfoEHvIfgGrsy7RUAfYlV1FPC+gocjTfocL0+mSI+6XC+ORtUdOzPsUTr9hZxRGitwSyg76fQ17uawq9oWBKty0ATh81JlWF78DCt7Uf0fjkhUvBg/mLD9/+VhBOnbr++KhqDlN1hGqURgKeh3Disd9AjPJ4XAyVMCEmHmk7bAQxoGMNsN2ssuvS++r23SFVXZKKU1/BUrNi4PyuxSzTrMtdBlVDRu4yzgBRgcAFykLgo80Q4IpLOk3HZqJdMZ6Uz+3lK7PkI/JJvlUcyAwMmvaR4a96eV4+F+Q0eY+8KB9qKwfwLMj7i0kBjpfqIHas+GG/YAySIJzHd56HnuiNLHCKydEY+Gww7SxpRzwZ4/bvx3rmEBzaYpaKlxuqenjsyLLWptlatxESOtciRZGLTX+fLoCQ+geovZlUA9omE/fQwQODotffwOr0yoANvGXNAjD1fOGiB1aRBTj0x+iN+clNVAftwSopMi1hlc2iQ7PxeKaou+jh3oQ3WeD97DgLR0KlVcdeJWIcXwaPQI5+bqhL9XuIqzMc+HKI8+/KTCg+BdoDB4hKvzIeUlVuQjaqhG9kUSkVwYic5/Z0OaG4YEnKv2gd33o2OQE21RO+C7jtRVgz0d9vW5f+3qWen2qpVip
 KH6BvF3r
 sAC4yu0RNMaUqqNi6YGhIM1X8j5wTT6kQxEbw68bbiNmtVqIs5a6qau2BoXiLTm5qF/mZY9li+/LSwvAC9wjj6Wdf09xfwyua4ZxZVg4RvoazOTLgjEfcPdrNIVyJjjT0w9uqF1bR4pqtE+YRS0YGXHTSOlslEPsLLakCkaolZN/8htc6w7+jw16Ffl6xzJWbGcVVUywlqZj4dRTgHMT/U6OpUWigwznBfO4SlAZSawfjUZGZQwVEuRxojlEnKpOgpu8OumsqJjBnakRpgomUt80Vhy1RR5GM2IPpgJY1SpYeMeNiyzKsvQNGWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 1:59=E2=80=AFPM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> David Matlack <dmatlack@google.com> writes:
>
> > On 2026-09-11 11:04 AM, Ackerley Tng wrote:
> >> David Matlack <dmatlack@google.com> writes:
> >>
> >> > This series adds support for LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, a =
new
> >> > UAPI to enable preserved files to be restored into a userspace-provi=
ded
> >> > file instead of a kernel-allocated file, and uses this to support
> >> > preserving tmpfs files in-place without any changes to the LUO ABI.
> >> >
> >>
> >> I'm interested in the idea of retrieving folios into an fd for a
> >> different reason, I'm exploring handling over ownership physical memor=
y
> >> to a guest_memfd.
> >>
> >> > The Live Update Orchestrator (LUO) API currently explicitly returns =
a
> >> > new struct file for every preserved file during retrieve() (e.g. via
> >> > memfd_alloc_file()). This then forces userspace to use anonymous mem=
fds
> >> > for all in-memory files it wants to preserve. This works reasonably =
well
> >> > for VM guest memory but does not work well for other types of files =
that
> >> > userspace may want to preserve (e.g. in-memory logs, binaries,
> >> > configuration files, etc.).
> >> >
> >>
> >> Does this assume that VM guest memory is usually provided using
> >> anonymous memfds?
> >>
> >> More generally, is the problem that there isn't a simple way to
> >> implement retrieval into anything other than anonymous memfds?
> >
> > Roughly, yes.
> >
> >> > Preserving entire tmpfs mounts in-place would require a large amount=
 of
> >> > kernel support and would effectively make tmpfs an ABI, which is a
> >> > non-starter (or so I hear). Instead, we can delegate the reconstruct=
ion
> >> > of the tmpfs mounts (directory structure, permissions, etc.) post-ke=
xec
> >> > to userspace. The kernel just needs to preserve the contents of tmpf=
s
> >> > files and provide userspace a mechanism to restore those contents ba=
ck
> >> > into a specific file on the filesystem after the kexec. Hence,
> >> > LIVEUPDATE_SESSION_RETRIEVE_INTO_FD.
> >> >
> >>
> >> Suppose pre-kexec, the data was in a tmpfs file (and fd), how would th=
e
> >> preservation work? Would the user have to
> >>
> >> 1. Transfer the data from tmpfs fd -> anonymous fd
> >> 2. Preserve from anonymous fd
> >> 3. kexec
> >> 4. Set up the tmpfs fd
> >> 5. Retrieve into the tmpfs fd
> >
> > No, the proposal in this series is to support:
> >
> > 1. ioctl(LIVEUPDATE_SESSION_PRESERVE_FD, {TOKEN, tmpfs_fd})
> > 2. kexec
> > 3. tmpfs_fd =3D open(..., O_CREAT)
> > 4. ioctl(LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, {TOKEN, tmpfs_fd})
> >
> > No transfering to or from an anonymous fd is required.
> >
>
> Cool that preserving a tmpfs_fd is supported. How is that done without
> preserving the rest of the tmpfs stuff?
>
> Why is it possible to preserve the fd without the rest of the tmpfs
> stuff but not retrieve without the rest of the tmpfs stuff?
>
> Is retrieving into an fd a bit too much of a shortcut? Would preserving
> the rest of the tmpfs eventually be required, and hence retrieval of the
> rest of tmpfs should also be eventually supported symmetrically?

The idea is that the kernel is responsible for preserving the
_contents_ of the tmpfs file in place. Userspace is responsible for
setting up a new tmpfs mount, configuring permissions, etc. after
kexec and telling the kernel which file should receive those preserved
contents. Userspace set up these mounts before kexec, so it is
responsible for setting them up after kexec as well. I see no issue
with that.

There is some nuance that this series doesn't handle though (it is RFC
after all). Pratyush brought up offline that the tmpfs mount might
have allocation policies attached to it. The
LIVEUPDATE_SESSION_RETRIEVE_INTO_FD handler needs to confirm the
preserved contents do not violate the allocation policies of the mount
it is retrieving into. But that seems easily solvable to me.

>
> >> > An alternative approach to restoring data to a named file would be
> >> > supporting a zero-copy sendfile() that can be used to convert named
> >> > tmpfs files to/from memfds across the kexec. But this poses signific=
ant
> >> > challenges on the *preserve* side since the preserved file might sti=
ll
> >> > be actively in use. The benefit of the retrieve-into approach introd=
uced
> >> > in this series is that it does not require dealing with two differen=
t
> >> > files. There is only ever one file that owns the preserved memory.
> >> >
> >>
> >> Would it be more symmetric if the process is
> >>
> >> 1. Transfer the data from tmpfs fd -> anonymous fd
> >> 2. Preserve from anonymous fd
> >> 3. kexec
> >> 4. Retrieve into anonymous fd
> >> 5. Transfer the data from anonymous fd -> tmpfs fd
> >>
> >> As to the exact details of "transfer", I think the best we could do
> >> would be some kind of move from one fd's page cache to the other fd's
> >> page cache?
> >>
> >> Is the goal of the transfer to avoid any memcpy and fully transfer
> >> ownership (so, not just by increasing folio refcounts?)
> >
> > Yes this is the alternative proposal that has been proposed and
> > discussed a little bit off list, with sendfile() and copy_file_range()
> > being the possible mechanisms to do the "transfer". I think there are a
> > few fundamental problems with that approach on the pre-kexec side.
> >
> >  1. iommufd requires that fds mapped into it are preserved. If the file
> >     mapped into iommufd is tmpfs, but then we transfer that file to mem=
fd
> >     for preservation, iommufd will fail to preserve because the tmpfs f=
ile
> >     is not preserved.
> >
> >  2. Even if you only use this feature for files not mapped into an
> >     iommufd, transfering the contents in a zero-copy way seems
> >     challenging. What do you do if the tmpfs file is still in use when
> >     you want to transfer it?
> >
>
> When you say in-use, I suppose you mean folio is in-use by some IO and
> is mapped in IO page tables, and that the IO must continue while the
> folio is transferred?
>
> Are you expecting guests (as in stage 2 mappings) to continue to be
> functional while the folio is transferred?
>
> I'll have to think a bit more, I was initially thinking of just
> transferring folios where I could unmap from everywhere (processes,
> stage 2, IO page tables) for the transfer.

I was imagining a userspace process may have the tmpfs file mmap()'d
and is accessing the memory. I guess you can argue that userspace
should stop doing that during LU. But I think the iommufd use-case
shows that that is not really possible. The whole point is to preserve
the memory mapped into the iommufd throughout the Live Update.

>
> >> > By leaving file and metadata allocation purely in the purview of
> >> > userspace, programs can create the target files where they want, wit=
h
> >> > the names and security permissions they desire, before directing the
> >> > kernel to restore the preserved folios into them.
> >> >
> >> > Currently, only tmpfs shmem files are allowed as valid target recept=
ors.
> >> > Attempting to target populated files, or anything other than an empt=
y
> >> > shmem file, will trigger -EINVAL. HugeTLBfs files could be supported=
 in
> >> > the future.
> >> >
> >>
> >> Is this basically that at some point, all in-memory filesystems' fds c=
an
> >> support transfers?
> >
> > Yes, theoretically.
> >
> >>
> >> >
> >> > [...snip...]
> >> >

