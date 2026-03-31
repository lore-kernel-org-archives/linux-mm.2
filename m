Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E75710F92F8
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9CB56B0092; Tue, 31 Mar 2026 15:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D6A6B0095; Tue, 31 Mar 2026 15:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63EC6B0096; Tue, 31 Mar 2026 15:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A70B06B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:47:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FE20E069E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:47:10 +0000 (UTC)
X-FDA: 84607391820.14.605CD99
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6739640009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:47:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I00PhrkB;
	spf=pass (imf04.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774986428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6pVCvPmJ8zZo4wz569DUvEXPXLd6B6BfKDtUFU2IIE=;
	b=RHnTvszNfuosGb0RiomIm/qBRz3AG5xBLUMA1f78klRgJI5sF0PR6f5fYIyenxGeSTu7z9
	GAUxPVewnPEbDI/5Ya1oF+IrTUCOXm9KtXsSnFbaSX4eW/TuNEhWmkpnH5gKZmpE88WnUc
	Mc49AUtkpWbPwQPEnxMItvbPoXDrnso=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I00PhrkB;
	spf=pass (imf04.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774986428; a=rsa-sha256;
	cv=pass;
	b=j4H/FyJ2GcJe3fbv1kjSmuQOsSDZXeB3ZOT1xYHU+5/MowovFdD2i3r8r1CyHVzyh70hqL
	GiljXNmgqJApNF5mPc+fLSW5uTbbQdlIu2iF5DcR+6v/Z3lqTJfMdQAlgxwoIVMnWwo2hj
	dtJxuOtgkYfhtwHWuBCbTKS2ySC5cDk=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6500eae6d2fso6585979d50.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:47:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774986427; cv=none;
        d=google.com; s=arc-20240605;
        b=BVVMp9E88MBY/7kQx8jBHvlUoNOclxXlhxg6uB2SDGyr5FHNSGvx/tOhF3dtmNThMs
         AMpY4Fatsm0EKYFu92mlvC6xzP4BhLtaRZVoNJc/u/S2VmffEzg41Xg54LUHk8r/oGDh
         OAe6W8L4lIbnDGgDWk3i7WIfCtLnPgAgVF3AxDf+Kz8dh9+Y9D9eNwdcIIz57ZiCw0n1
         Fg25LGRHuaNlr6tDcRLQNuWcPEu/CV2EU/Iqv7wIgsk/tuAYOoB+9iYpuJUWnrPuw8KV
         v8deEVCF51Ax9no532aHWqGecGk58S4IW6rd42ETp5BmrexLQ9Q0+CWnuGqaIxCs3APj
         X7nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P6pVCvPmJ8zZo4wz569DUvEXPXLd6B6BfKDtUFU2IIE=;
        fh=StQvEQzt5Va0YmPDSdbXWemWL2lL4nfbQCWbTxGNeuw=;
        b=ed9kjmo71KS0qG8oqD3TQO5P8bcViVNQW7vE2p23VtUUV8iwklqEfd3u1TzOxuD0+n
         FBbphlmx9Jggy5mX6mbXhTkDWbhc1kuESuKsl73Mdy8oO3urNGDhKrn4gSgy7iGQccO2
         v9gr5NqhRXIJB4PeEbsy1gz805H9fSqTvEeO4mVBILut5RqD+UkYq2Ru4ucjNBSGEfAi
         3YQ9Dxju0g7HYVEkU5/clC9R4fhcFlgS+aegz3I5OsJ8ecqXlG42BQ+GiFwELlcV2nt4
         +28G/PM2HPlGUAfgEzKpR0vb6H+MbgqwjG3e0JoJST8knueonKeT1AyHZPl/7wWoMuUq
         Zdig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774986427; x=1775591227; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6pVCvPmJ8zZo4wz569DUvEXPXLd6B6BfKDtUFU2IIE=;
        b=I00PhrkBo/iGlfsWCAw16C180Mrc4D1g3oIam3GR6c19ejj+W2Ju7kEMEl1gLZ8GFu
         B53HpfijD7QAL97kBLgEcLzNnuO4oRE29MV4aUTaGTg3mc4BfAAgdL+O7H4maj0JlTXD
         XZKidrKHOXij/5btDowkQgH6nnJ5JBLevZxV4wPexPQeM9hI/mrsxPxMfr4vwhVMhSsX
         XzPR9AScCbHqXwMWqepf+3XWA0XZzaOdSWsdA8RlO1sFh7Jgv/DtKgPLSl2h+ZSCixwd
         KcmdTC6VPCWjjSmXyuI4yp/82B9WftiXdjAd6iy2UtBqAdJOCkSHTR3W76g5h7bHVZ2K
         x8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986427; x=1775591227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P6pVCvPmJ8zZo4wz569DUvEXPXLd6B6BfKDtUFU2IIE=;
        b=XBdp6gY+POrZXsKZbDQLHvce2kY4xohFZlp90dW5wNTO1D991jcUeZ1UUPAOjffFOY
         BcFPo0vWa611BquobosNW2zQB1VqqTyGMDdQI05QioprKiNGi0DGs9ObRchHhdtWLidB
         uTtvzrgu+IjB46iKC3yFaNx5RiYd+5xuF+kzYtOZzBdnHv64k02scsPEIf3NmBLUgPNp
         dGR5bZJEj7E0ZN/KPG6Is/YjxbTKd70T7CNS5CE3t0MTe3puhvXKN5qeqq5ueFfNMrbn
         de5ywQM9I2W5Xc/fyoL6BnJLWWr/hdEe6ME+OPZd2SCjpj3dWSTndsSpd4uD2oe9tAxO
         gElA==
X-Forwarded-Encrypted: i=1; AJvYcCXyhdCWG6NLqNqF9/lKY0uuE0BarfUTo8eE6hXCWe1fem4qGNRF6lb7g7asYGWDOVsEXgV5PmYmaA==@kvack.org
X-Gm-Message-State: AOJu0YyQazg8Ue9qqKQzQ0uopHaPvLC7KseXODoONlBgC7AyTKqF6l9g
	HKjMnuVx3jJYr6Wvkl9rHIGRQsg5QZjtjpqDoRNc22dvoFJEWUULe9gTys2a0hdObOH+bMzx7X3
	Cn2rPCj33/LG4DeO9NbWsyqaYw8cBhxQ=
X-Gm-Gg: ATEYQzwmk8o5m+BKIAEojmqcuYHf4pNkJw2bHIKWw1zmCQWbmfPUuExM9f9Y7utBliG
	MGGv/BcA7o7T4D351OTIaPsVdMqhILKewcJtT9Y/ZiPpteQMCPie+iCNfLkXEUkRdz3FxDBOBdv
	2Fw7Gi39eeV80z9GryHPW+yJJaII2QN4TCPxgSP/SOUHvdFkXsaniC80HBbTcLqWW56aO/yeux6
	okqvnp0ysKCFbAPY9oUmw5fUZKT3nmhqlOQzXA7YXieGRczkCQlH93pt25K+ID1BAS7oBTcoBe3
	phKlOxjv1L+zIzZoU+44WOMgcsdkrJfJBMWq+gQyQg==
X-Received: by 2002:a53:adce:0:b0:64f:1278:e7b3 with SMTP id
 956f58d0204a3-6502fdc14aemr517173d50.22.1774986427400; Tue, 31 Mar 2026
 12:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175639.4066033-1-luca.boccassi@gmail.com>
 <CA+CK2bCKJ8rkJ_onp9Za0KNuWujH4Gzue3a=HvwOJAK2tYhReA@mail.gmail.com>
 <CAMw=ZnQcAggXOXY2s77qtgTS_d4td-5PXeMXEkMEVwnMFUrGPw@mail.gmail.com> <CA+CK2bDB1Z9tsv7dHGHGnfRcSyYZ7MTsCXtvJYVMAmgRZyZ=PQ@mail.gmail.com>
In-Reply-To: <CA+CK2bDB1Z9tsv7dHGHGnfRcSyYZ7MTsCXtvJYVMAmgRZyZ=PQ@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 31 Mar 2026 20:46:56 +0100
X-Gm-Features: AQROBzCZMrg1QaVOm36h96ccl-T60eQ_EqWFDMABE8fw_zScwCx681KFLt1TMfk
Message-ID: <CAMw=ZnQEuYrti57ZRXRUYXVryyBRwQgaU_7Moc5R4zaUHjYSGw@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6739640009
X-Stat-Signature: qidksczzg6cx6y3rhayotr88jo7gs1bu
X-Rspamd-Server: rspam06
X-HE-Tag: 1774986428-620381
X-HE-Meta: U2FsdGVkX1+yyOvpFG4lqWle1YWnGQjmGYHem2oZ8BxMslcxyUB8cHggG6TwINwNK6laieSL4ujjnTQK6W6w8CY9Uwpd4JIQ7J4HedXWFoe2ixSByqTa/5XZUSsXsMjR/9AX03oj65grQpVAs5QLKRwHhL/wI0+eTMqPCUmGjFl1n+EMAdYRRC66Akc7Zy0TxUNcSZ6g6llqOarzexJ7uZ0lykOJXgNK4PSYpiuLugathiDXxVGvUia7ACxP/UL/Qpj2qR2U55Qtqq6pEVefFWi2k9iG555RuEXyZbpAqsk39e7LRnqxS8za1GxieFJ0r+3d+5+RKuX/KPLDevyR0XwHIOt6TFGcM0uzxU24h9ih/jYVhHnGIG8gqb0TBWBnsVe9smvyZVzrsoqeqeUyPd0uaJuzzUGjgxrcIBWmH7tSdDhLpEabA5zm4AYTS+2ep1I3chEZ4xcqdSXYZo7fW6vcek6/ukZYlnESP/lbk1adugLIt2ZyC+kNC70iaG1fnuZikBYaWb5HvOwE9GA+Mpzj8uOB707/mCZmMp59hxnKvvp/ilhzZ145UeBS8192dQ9BtSdOWZEehcMmQOajwM2hiJWRXhDGZNRPDxRntGezYonOgPNzI3ufy0WYLkJ1y0/wzdA7RNiczYk78ET0pT/meEywjw6BkrxrqWDynAuQxzUIRGHXxy95iqsV4i5Mu16WQikbre3y065w1Dsmw7iT2bbLdoyd9nfl3hyKc2xnRjTuI9dNYB0DDS3sRf988eGeOj5i/8nRrabBDD0uHOTau/r0lgp9E1qQ3i65fMtMgnrBVSzwPDDIba3iBJ70fQ77rzoptipvzRNTT9tx1jV/PeibQyO2mkwDKVQ+NBLIIlusQJTa9FSsObklG0lCg7VCzqsrlkEvs/L+Bmg5UpdDpoxbaV9YilUhbtCLJsgzjex1hYWakYf9oGOvn5ynA3KkYT4SDEpyUyWeZyF
 Fd0GN+8w
 dRt4HzpKExiKvgmcvvFr4KyC8sdxlvsvccXzI06/5r8s5p8pOIvTJa6eJEMYBQUOS4TAh8nKKCzlCISMXCTbbBMTbeMpPgljugumtVC6J6t4GO7eV+nv/88Kt9Yd58sWva9wCiNaeH+AXulMpak835qq1dFehbOpOGE4qOsAFCCugBDqwqp1tKxL5pMw8RMAfpGAuu/aQmami/Ffegl05quPZicLcZzyMh96ArLxa1QdqhMvfOpD7KEab9KoKhj6YRdEekeCfzIfmTWqCy8go7sMuUu/dzaTERQr8Zf5DBS43u3pdrwxQRL/vvdsd4WeUuTI9Z9tageWrBL1w/OgU5RC4kmOu8S7bu5fy9WendIgs6BR9AEpZ9Ra1BMnDvmExPEEsBZzgr9LEYkCXMpU5sIc2/F39gUN6dQc/HYA/1/Xz4dzbnEJ56bN5e+BKbVTjSmYYhZ0hybFAQ13PlFBgfLKnZESCI9Lhu0eOpquuBAxpJAqH2Sm8afkyBZmCR8nk1HtXQSipRfEqDocSNevli/0d62kdp40PBd27JBBhVHfHH2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 at 20:28, Pasha Tatashin <pasha.tatashin@soleen.com> wr=
ote:
>
> On Tue, Mar 31, 2026 at 3:07=E2=80=AFPM Luca Boccassi <luca.boccassi@gmai=
l.com> wrote:
> >
> > On Tue, 31 Mar 2026 at 19:34, Pasha Tatashin <pasha.tatashin@soleen.com=
> wrote:
> > >
> > > On Tue, Mar 31, 2026 at 1:56=E2=80=AFPM <luca.boccassi@gmail.com> wro=
te:
> > > >
> > > > From: Luca Boccassi <luca.boccassi@gmail.com>
> > > >
> > > > Userspace when requesting a session specifies a name and gets a FD,
> > > > but then there is no way to go back the other way and get the name
> > > > given a LUO session FD. This is problematic especially when there
> > > > is a userspace orchestrator that wants to check what FDs it is
> > > > handling for clients.
> > > >
> > > > Resolving the /proc/self/fd/X is lossy as that has a hard limit
> > > > of characters, so names might be truncated. Also requiring going
> > > > through procfs and doing manual string mangling is not a nice
> > > > pattern.
> > >
> > > Hi Luca,
> > >
> > > Thank you for working on this.
> > >
> > > This needs more explanation. The way I see it, the user orchestrator
> > > can be the only one that has access to /dev/liveupdate (and this is
> > > actually enforced by kernel). It opens it and creates session_fds for
> > > any client out there. So, the orchestrator already has the FDs and
> > > sends them to clients(e.g. via SCM_RIGHTS). It then monitors the PIDs
> > > of the clients, and if they die, it closes the session_fds for them,
> > > as their data does not need to be preserved.
> > >
> > > Could you please explain why the user orchestrator would need to quer=
y
> > > the session_fds, since it is the one that creates them in the first
> > > place and has to keep them open in order to preserve them during a
> > > live update?
> >
> > The orchestrator cannot and will not hold on to all this state, that
> > is not possible. It will simply hand out session FDs on-demand via an
> > IPC, enforcing a naming convention for the client, and immediately
> > forget about them. Clients will hold them and use them as they see
> > fit, and then store them in the FD store on shutdown if they want to
> > commit them, and that's where the orchestrator will get them back, and
>
> I see. The idea is to expand the LUO Session API to be compatible with
> the systemd FD store API.
>
> > they need to be verified that they come from the right cgroup, what
> > the client's portion of the name is to be able to hand them back after
> > reboot, and so on.
>
> So, if I understand correctly, the enforcement of who gets a systemd
> stored fd returned to them is based on the cgroup name, right?
> Presumably, after a reboot, each VMM would have to start in a separate
> cgroup (using the same name as in the previous kernel) and request its
> session FDs back from systemd. That is what will be used to verify
> ownership, am I correct?

It could work either way, it depends on what the client wants to do
w.r.t state separation. If the client is fine with having a single
service being in charge of all sessions, that's of course ok, it can
have as many as it wants to.
But this also makes it possible to have strict state separation
enforced when that is instead desired. I intend to make the interface
to request a session privileged by default, but also gated by polkit,
so that it is easy to make it unprivileged and scoped to specific
uid/gid/services/etc if one wants to, with a simple polkit rule, and
in that case we really want to be sure that nobody is playing games
with other cgroups' sessions, as a precaution.

I haven't finished getting this part going, but I'm close - the client
asks for a session and provides a name, and the cgroup path of the
caller is prefixed to it when creating the session. That way they are
all tagged in a way that is immutable and unique, and that clients
cannot mess with. If the client wants multiple sessions they'll all
have the same prefix.

