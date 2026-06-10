Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E11CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3956B008A; Wed, 10 Jun 2026 08:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBEA6B008C; Wed, 10 Jun 2026 08:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13BA6B0093; Wed, 10 Jun 2026 08:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2FE16B008A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:29:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AC0F1C3474
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:29:27 +0000 (UTC)
X-FDA: 84863933574.24.8B73CBC
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89F7240007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:29:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=WvDDwVgj;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf17.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781094565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ckf24HwJNr0/jCTjEgcbMFrOZMOX2rhuYx11RBKLbRI=;
	b=H/LNGtBCOUhsqG4KmZeVVfLkU5SdN4eTfJu1KoL8HgH8qot1YWiEqL/6GQIZ5tCx52qmQh
	KbGcLKBg6pCXSlbVAVjx2munjXlddbtgsnEnW20JFEJ++ZwdwkizAR4IHmiahWsKokKprj
	TKYKLAlTVsEE/iOaDeBop/RrQoSTH5w=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=WvDDwVgj;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf17.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781094565;
	b=j/YOxAKmtvogegCXFI90t7yo8mIaWEf7qfLkoZAEEsJgWplaIY8N7XesTCWUn2jLTh/ziC
	KTJkx6jiVRtEHm/huE/Y8e0z3BK3/exuRTEnwgIk13lBwh23JElEg8ouHFRz8/qA2X2xga
	zkjR1dUIFGwGkyGrDq0EBr9SKqdulMQ=
ARC-Seal: i=1; a=rsa-sha256; t=1781094549; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=P8D++KH7LHOQpE3Rrq+mnUydsarX4SA8jf37vzhCBVtdpXd9oICu2vM2tNQE2bw3EFi7weXZFFlzkHl3SxvVMsMUCMuPU8dM3Y+1GvEQzIF+Rpw+70J/Vn9h5lvB+1/bAaGU2fvr/YCOpyAXkTMf8ymyMRLKwp9+J+IJkNeTga8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781094549; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ckf24HwJNr0/jCTjEgcbMFrOZMOX2rhuYx11RBKLbRI=; 
	b=mUTmYgpyHmOoGuHezBtMDvJHAJNG71qY/+PD9+moxQK1Jkh8pok05MkSrIHHKZON0v60ZFQRagSjcoBE9A3ANnVxEQN0NUXx3D2VhglOkHIiMqyDzIJcAQk3agMZP+EERK4I+OV2mvfOdE1pnChPg/ID1zDYRGJXStzi/5plQyw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781094549;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ckf24HwJNr0/jCTjEgcbMFrOZMOX2rhuYx11RBKLbRI=;
	b=WvDDwVgjxHIb6Ld4g/STPkj/qNyJrcX72eFf7bqJitIWy/EzMXAo4o6Q5lwnf870
	homOUv6wByNuqLwm/c7J6HHcMwiq8lbk1Td4lWIWiSg0M2rKPVn77MjTWE8BnhZv2Zv
	9YTeG3B1BxTxwESjMHgSAHbmGhCWNG4mipLqXTSM=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1781094546927254.30322356312638; Wed, 10 Jun 2026 05:29:06 -0700 (PDT)
Date: Wed, 10 Jun 2026 20:29:06 +0800
From: Li Chen <me@linux.beauty>
To: "John Ericson" <mail@johnericson.me>
Cc: "Andy Lutomirski" <luto@kernel.org>,
	"Christian Brauner" <brauner@kernel.org>,
	"Kees Cook" <kees@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-api" <linux-api@vger.kernel.org>,
	"LKML" <linux-kernel@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"x86" <x86@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>
Message-ID: <19eb181fdd4.6d028f442844776.3737831021032223216@linux.beauty>
In-Reply-To: <4e049396-377d-48a7-a34c-91318413a876@app.fastmail.com>
References: <20260528095235.2491226-1-me@linux.beauty>
 <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
 <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
 <19eacd64508.26b92c022125848.262962729296162879@linux.beauty> <4e049396-377d-48a7-a34c-91318413a876@app.fastmail.com>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Queue-Id: 89F7240007
X-Rspam-User: 
X-Stat-Signature: 4p1n5b1p9jap3ynz5on9otrj5dg14w3c
X-Rspamd-Server: rspam09
X-HE-Tag: 1781094565-913279
X-HE-Meta: U2FsdGVkX18rfGweREVy+747hf7kfHJUne2TxPy7L2EtmiI2rb4XtIRKv2OpG+mg6bziM1lRSCNc7dHeUpve6LUSRxwr/xDwU0nLsvwuEse5K20sMgKBfdLENku/DX8KXVKfGH00iD7pQI2N3D3UNuaL1f/CVcMFhMuIhsgakQ3/UZyv13JbD66u/TxRex/5SEF5idbioUv/PrKfm2qdEjHbALskfQYhDmegmxgEK752heqcvBmLb3DioS/TR7ooHCLBoS0s3SXB7V46P/brxbm4uU/KMM2ImFoR68c4S0Oy2L9iYVwdsZEJkez1M9IH+bpDe6fX9zUVL3Kud+kCKl5fjcchEUh7xvOHse4RmBYdKiv6Va9/xATOGUZsvJNYlK0w2QOjPSOPS8VQkJAIesHTTvmZc1y67WC3ZAOki+JSUmO8MgJ3KXFj64NNlU7RfVEGT9VZ6tRpXbgMHttmn5w3KxVum4LLClxjwS0iIKNwAmCosJO45FXG1lKUA0oaOeYTNhdTEwYLwgjaAjd2XfBSFeQYLBnX0k13IL7c/B68yJNdSriXxAyXhpq44TTDSjMYyOaf4sEFhrcG97KTpOSqv/DPZ2Uif6tNoqKi5dDJpnc7GYa/CsNd9MIw+BJGdVGgaoMlWZJJ0zkQoScuqGzDc8q9/D9167Xwen+mVkhqTGTFzA4L1eamjxNYCxARFVm57O79f3Ff6sMqs+aQLONF/Z+p2+/B8EUtZJ79cEutkFvZLg61dizRi7Rn5+VZXDnMcaAAwiEpw5uyCUlPQQ/86CU1tjaZNpoIiRR42YQi+qxj/npbi7P2DnTWbefsNEe5vH2ObIjAC0fAwZEwMevxBCcj6AFhqD46rVm00y0SWhatLRBv4BvjQF0tib3gRTPJpIxX5IWlXiJeQFyUCluH/z+OCfnZaMlAKAwEfOPRA+lqmtVLq5IhoGp0NvEQX0Vg27I1NL0C3q8XTmk
 2F21f8cB
 JH5OvZhB2/+LmCm93pTOQ2Z8sKXgx/sg6/I1A1OBvfOe8fNzBriem6QCwPZvjwqKbqlNWCJrSvGpI4Dl1FfJvzI4mbR6b04Q8zRxgNfq+a8Gb2ybwiDxCcq0SWHZxUnCVDtYemkfD6+a3hQXaYB+c9LqtZ4JNWwx6YVod2RYNFZ8EjHy4IJNTN0TpvM1KlOyqxAyk7+Bn0HMYcTRG98EVmdtouto6wAv008pwAU9kdfRBKzz3E1+nzJUigE7bBl7ys5Hwjn9ca644y6cZ+jP605xr+Al+fkwQdkcJIAJ5sAxbi/JcGH25TS26EGnSFxk+dZ+zD6KFNFq3VdbeOTy+MtOUottzH2YJ2hR/8Q80RNFupGq/0OpiKt6aEltXVByTOUbzYmd+wpTLVkVdUzh5HMrseCIR8YYnaRnNwt/kBvrYWmr0spqRVofdjSe2ML8T53VUSE6LgHVf/raxDKgh8smjLn1lbw6p8h6nQrvsAOdEjpqSuzCwibq0fUwukfKBZwne
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi John,

 ---- On Wed, 10 Jun 2026 01:27:47 +0800  John Ericson <mail@johnericson.me=
> wrote ---=20
 >=20
 >=20
 > On Tue, Jun 9, 2026, at 10:43 AM, Li Chen wrote:
 > > Hi Andy,
 > >
 > > ---- On Tue, 09 Jun 2026 08:01:57 +0800  Andy Lutomirski <luto@kernel.=
org> wrote ---
 > > > [...]
 > > >
 > > > After contemplating this for a bit... why pidfd?  Doesn't a pidfd
 > > > refer to an actual process that is, or at least was, running?  This
 > > > new thing is a process that we are contemplating spawning.  I can
 > > > imagine that basically all pidfd APIs would be a bit confused by the
 > > > nonexistence of the process in question.
 > > >
 > >
 > > Yes, I think that is a real concern.
 > >
 > > In my current local WIP I tried to keep that distinction explicit.
 > > pidfd_spawn_open() returns a pidfs-backed builder fd, not a normal pid=
fd
 > > referring to a process. The builder fd is allocated as an anonymous pi=
dfs
 > > file with builder-specific file operations:
 > >
 > >     file =3D pidfs_alloc_anon_file("[pidfd_spawn]",
 > >                                  &pidfd_spawn_builder_fops, builder,
 > >                                  O_RDWR);
 > >
 >=20
 > What does your builder fd point to, explicitly? For example in my other =
reply I
 > talked about how it was "real" process state. In my FreeBSD patch, for e=
xample,
 > I found there was already a status for a process "in exec", and I figure=
d that
 > was clean to reuse for one of these "embryonic" processes that also hadn=
't
 > started running. I would reckon that Linux probably has some similar not=
ions.
 >=20
 > > and the normal pidfd helpers still reject it because it does not use t=
he
 > > ordinary pidfd file operations:
 > >
 > >     struct pid *pidfd_pid(const struct file *file)
 > >     {
 > >         if (file->f_op !=3D &pidfs_file_operations)
 > >             return ERR_PTR(-EBADF);
 > >         return file_inode(file)->i_private;
 > >     }
 > >
 > > So the current split is:
 > >
 > >     builder_fd =3D pidfd_spawn_open(...);       /* builder object */
 > >     pidfd_config(builder_fd, ...);
 > >     child_pidfd =3D pidfd_spawn_run(builder_fd, ...); /* real pidfd */
 > >
 > > Only the last fd is a normal pidfd for an actual child process. The bu=
ilder
 > > fd is only accepted by the builder operations.
 > >
 > > This avoids having to define what waitid(P_PIDFD), pidfd_send_signal()=
,
 > > pidfd_getfd(), poll(), etc. mean before the process exists.
 >=20
 > I wouldn't be so sure this is necessary/good. For example, I think it co=
uld
 > make sense to wait on a process that has yet to be started; one just wai=
ts for
 > both the process to start and the process to exit. Obviously a blocking =
syscall
 > in the thread that is spawning the process is not useful, but the asynch=
ronous
 > poll variation seems fine.
 >=20
 > As long as there is real process state here, it shouldn't be too hard to
 > implement.
 >=20
 > > The downside is that it adds a separate open-style entry point and is =
less
 > > uniform than the pidfd_open(0, PIDFD_EMPTY) spelling Christian sketche=
d.
 >=20
 > I do think there is no point having two file descriptors. The file descr=
iptor
 > that previously referred to the builder/embryonic process then can refer=
 to the
 > real process, right?
 >=20
 > > If people think there is a better way to represent the pre-spawn build=
er
 > > state, or if the preference is to integrate it directly into pidfd_ope=
n()
 > > with an explicit empty/future-pidfd state, I would be happy to discuss=
 that.
 >=20
 > Hope the above answers your question? I suppose my ideas lean more on th=
e
 > "future" than "empty" side --- there is indeed a thread in the thread gr=
oup,
 > with real VM/namespace/file descriptor etc. state. Moreover, state gets
 > initialized before the process is started, so the actual start is a pret=
ty
 > lightweight step of just letting the scheduler know the now-ready proces=
s can
 > be scheduled. The only thing that distinguishes the embryonic process fr=
om a
 > real one is simply that it isn't running --- i.e. isn't (yet) available =
to be
 > scheduled --- so the pidfds holders are free to poke at its state.
 >=20
 > Cheers,
 >=20
 > John
 >=20

Thanks, this helped a lot. I looked at FreeBSD/OpenBSD/XNU after your
note. FreeBSD has P_INEXEC, OpenBSD has PS_INEXEC, and XNU seems even
closer with P_LINTRANSIT, described as "process in exec or in creation".
Linux does not seem to have a single equivalent today: current->in_execve
is only an LSM hint, while the real synchronization is spread across
exec_update_lock, cred_guard_mutex, and the exec path.

I am switching my local WIP from the two-fd builder model to one fd,
closer to Christian's sketch:

fd =3D pidfd_open(0, PIDFD_EMPTY);
pidfd_config(fd, ...);
pidfd_spawn_run(fd, ...);

In my current local version, I still use copy_process(), so the fd points
at a real task_struct/pid that is not woken until run. Following
Christian's point that existing APIs can handle this not-yet-running case
with ESRCH, I currently make ordinary pidfd operations that need a real
started process return -ESRCH before start.

I am not sure yet whether Linux should grow a general exec/creation
transition state like that, or whether a narrower future-process
lifecycle is enough for this API. I will think more about that when
working on the pristine process version.

Regards,
Li=E2=80=8B


