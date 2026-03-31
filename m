Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F1B10F92EB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A196B0098; Tue, 31 Mar 2026 15:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB396B009B; Tue, 31 Mar 2026 15:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1166B009D; Tue, 31 Mar 2026 15:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DCEE6B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:28:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABADC1A03F3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:28:24 +0000 (UTC)
X-FDA: 84607344528.27.F511221
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4E5A1A0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:28:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="P7t6M2D/";
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="P7t6M2D/";
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774985302; a=rsa-sha256;
	cv=pass;
	b=ExZPW2DIypN0brHDpm9ePf+9PBPOqd8jyFCv+bzeonHJQ5Gh0wlCXdsXZqgo0XNtCzpZBQ
	QvlrIbddOnZyW8vO70QVjKB0Wehu6fahcJfxejbufOX5KkMNqiWGTH0iXms1z+9TXopuzO
	SGcebyK1ugLY4nmVYDKWNA+MMLFmLJ8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774985302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNrspuYtGpLQj+NkezxGKMIJ1rBS9R7nl7zWYbPt1p0=;
	b=HMoOouPAtEp/FyLDLi/1Z88651i560v2ZmceYEHgi265V3vH1ABboM8P51BBM1m2xCgc+r
	Hq4Zo6dChRw5mXk/F8qFLPdt6QcfzM/gv5iYdJodLFWlCubwEPkQkxAU09PKppBB4ZMonc
	XNHEyhaJaZhFs9hOdpII6tCwWOps1gc=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66bb6eb28acso5537651a12.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:28:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774985301; cv=none;
        d=google.com; s=arc-20240605;
        b=kOXyioYhgWFBNGPX5lcKYjW8lZ8lrII2a8wwMnZumdkR29B739VbCjV8CdKqGE8Zv7
         /WTeKWLsW88j0EFXZ7DMcaHDaplz4MbnZZ64JEnnI76Ud7uaICLk5hHAj60tjisJprq0
         rTFzaOb4K8S05rHoBdhODeCk2xncb1ZsHuoDqAWU5fXIW36445hp0FRZ6aecoPVub316
         tdERfrhZ+EH8HyL8T7JibiJ02zf96sYJxe/S1e1i1itQEiyo4dvnuzejgMptZJ4+zQNb
         4eoQ78OcRQs7vlENuInmgozbU++bu377mbinJZe9t2B12e54P0YgBtQUuTcwf+wtkYYx
         /VTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WNrspuYtGpLQj+NkezxGKMIJ1rBS9R7nl7zWYbPt1p0=;
        fh=26nqwr1YioI3qchoH53aAYQFSPVaHY8L0zVu2NPn0Sg=;
        b=LFvo8oT2GBR2SViuApYuF2IBCdvGxeQgPYGlnu2Q3MbQAac5H1XzkMtEsO0XeGePlz
         PiaShxJlqMoTBZKhYKOq28cQ2VdeWODfLr6JSKvxshnO8LInw2X7cb1yheM7nKOPsRW/
         ikVc/E5wmfPIKDl6j7L4SSR6m/bNmZyr/UCUjSQN3QOetw1FPljUoPCO3e8nOubJqsth
         iDSwBQczzRzPDbR6Lvm7usor21tSOmVmbsKIXwE1H6SOlNanMDDh227J2tcMfOj75Lx2
         Zo3CFxI/KB4f3rs2dLkm81RbnTHwp0sXhm9/tadcXpV5Rcl5MpfyNq05IJuJqRDkgri0
         ubnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774985301; x=1775590101; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WNrspuYtGpLQj+NkezxGKMIJ1rBS9R7nl7zWYbPt1p0=;
        b=P7t6M2D/V4D1T3TnwSpQcVxgpdLwqB4KAiPMTUNuVk70Q0JStN4dZe+qaUQSndMoU1
         i09Mc8AofATfOMbdWb4fKL2B6fz3x8ZnTUmsK0o+B67DwEAej6Q82AEMQGzaQHO8D947
         JNhsKi4UffBa8XH/hoQWTQWVPo6oLNGsTSNlebRjd7WFyR2VN1sp7lbncj87OZo9kCVi
         Up6VZyhzzegOke3obRpyEIYwQsDv1tvQjF8bLmIP4qFcGl5CKbB/354zT63ggElhOioz
         5MleB++lcIhBEoFcMoGxWtwKPuC/DP9KIbAQEzetnWlfKwihbpG39K+D6NrkyWrTue/X
         U2/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774985301; x=1775590101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WNrspuYtGpLQj+NkezxGKMIJ1rBS9R7nl7zWYbPt1p0=;
        b=gs/OsQZb0LNppRxQpq3Ol9RisLow6F06vBwqhMB/+L7X5FyRPgA1owBXSf1D6oL/bJ
         ZwJM59tdaFjkUXDjQrWElvJh+xqUNAaa+HmYl81CMVldnL8tpc72EWRCAv/VU9cginy7
         UXvXOUWe93fCBvgN92c5oygYFt5M0lgKMe5nO5mRvfyZoR+j2MKQX359bc9mjwJXA8V8
         VD/ch7WAKztb9kHGEqURJbHFZzaY8D5kVOGEhLX2f3/bqtiuWpQKJCy6EWFuu5AEZMYG
         AT58fq8sNs6Y0NLBqKIjGfzhjHn6jLUDFr+C2OGZ0KTtKtB3l7RrWvYiGaxXFQKu3ADG
         oUNg==
X-Forwarded-Encrypted: i=1; AJvYcCVwSbygWIHxSFx+IKtAw0ZvThQfKN7k4m8CGWzGKkkCC3FD0doUXM2H7TnrCxHzJwiWwpQKiYU1IQ==@kvack.org
X-Gm-Message-State: AOJu0YxySBn38kjXtkWkryinDV9Ol9kVrME/HrWLdzn/JF+GnCV2eluG
	i2Iz9m5EX+1QsqsIYgq5ypg37VLzvxO/YTpdrPNs5IKvBViZszMWKmvmb2ogJVYxQe8PH83s53K
	9o5/jeWBYILtEoFl2HczGJRmX9HyDL6DcAIHikdEXAQ==
X-Gm-Gg: ATEYQzwf0A0tt/TPNyjxLo6qkJp2J2mCs1Is2Jul5Qc5uOqxRLCLX1/8oHxiHZHZyOI
	QssIYGPjPJGnnQywvz9Obd390J6CcA9ALU/+2Uax5KgGyC0CjLakOv91kT/clGFFJQJgPYcWn+p
	vzDojj+E6qwGx67W+Ju6Jkt1I4Giddq7jHmvd2NRR9oHI/Eckcrk6y/fu8reHtpv/YE1rW5txuI
	NF/y1WtIN1J0tuUEkEeHxRK9V04V51uFk/1Cdml3Vlopxz69xfbQfWDSq0TbZCdm/vMa8cNDMR4
	G4LsXhuVsa81HgGOaWZZ1NfMt9SxMLW7XWHi1A==
X-Received: by 2002:aa7:d8c5:0:b0:66d:ce0a:2589 with SMTP id
 4fb4d7f45d1cf-66dce0a2664mr215108a12.18.1774985300846; Tue, 31 Mar 2026
 12:28:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175639.4066033-1-luca.boccassi@gmail.com>
 <CA+CK2bCKJ8rkJ_onp9Za0KNuWujH4Gzue3a=HvwOJAK2tYhReA@mail.gmail.com> <CAMw=ZnQcAggXOXY2s77qtgTS_d4td-5PXeMXEkMEVwnMFUrGPw@mail.gmail.com>
In-Reply-To: <CAMw=ZnQcAggXOXY2s77qtgTS_d4td-5PXeMXEkMEVwnMFUrGPw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 15:27:43 -0400
X-Gm-Features: AQROBzD_cmcyX3I7_Q-hpxpZ7m3linx6OUGK94mkQkw4O6IVQgnm7N_y1t610xE
Message-ID: <CA+CK2bDB1Z9tsv7dHGHGnfRcSyYZ7MTsCXtvJYVMAmgRZyZ=PQ@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C4E5A1A0005
X-Stat-Signature: tp68phbpxza8hn1hzpki93beq9xubio3
X-Rspam-User: 
X-HE-Tag: 1774985302-709005
X-HE-Meta: U2FsdGVkX1+esgNYGzyk9b5FzaX7kNh+ihwuNUkLCETsJoAsyGEMBoQjAHPP0mX88631lGgQE5Sum8BgOfkttVaf/xfA55emcFsvrpSNwoEJzgqEH2xxPQ0aJK+802XfADBg9hLOiVigD58J6IVjjbgwvJnVF73jT5LdXkbmxnZ/S1RRCWUbkY7Pn8/VYNF/hYygLqcdGQ4PyE8dX1qDON+ZAVvThdRYfI8AMV4N3a2PQCX3VQCseE2NcItME4qEAjro3RaMDXIPAuECI3YGCjx83MQ0eVRzmE6HwQEu5zsKWRZbOY5w0ISiSUkhUgNb+fotk8y1I5xJa7ErCT7gPCnk63q8oGnqhb5W8r8q3AaFYmjusox4Ei9Uf8fOjYYnX6n4aNgFDeNcpNqoTutASJo28XfUhzkTQBquSzxBmkd+o4g2Z1Albf0RY5nGnUAooUSG2MXHSholNUgy6vOfX6TIArEP8bwqs4ahuNhf2HN7XejVH9+50CWiJBrIDVBq2wradllVoxYwHxbkBcylV9w/Zy5j7JTnI7eED2CUkVtDzSM2Mv2hWq5qI8NLXmvOWMFrZK63XJtLpDvxoySQ3hKtnBtqucHsdP1B0iJ0jUbMUsa6k/uDxOqmOFfG9CDhsRBPCsEnxxGcI8uQ0h28CbELJ38XVYQENYpGDLYggzs8+1z5OsKDrgXvWKDbTAGtD7w38oPqWABwRNyYK+pCOsVgYxm1AX1bF1R1IWoINUDaZXHIMf2KHHJ3VTm9rvHXvJJ+X7ZRgcfR9LpvQHgqU6n1K5DUwT52yksqdo2q8EwIDLiv2WwoJyZr/iKNLlo804RdeZqLW4FVwUwzq9degMrroEE5brVtUbLLGehQXEjb8WvSWJ8vh5H3vYw5g1bT2TFA2Urhq3gEfiLQ6PczRlQSpF+8k6jDikXXlQVhjuEwAk4tkYvyPsR+NBmFLi/XkCUdoip1Po0IXQtB038
 MQvJZtcD
 oH5yNVl8x88ApqGvpYUbvYFh1/uXzGWH6eYfjCIkvov+Ud+Qbt8nAUITCUye2j9YZX57RbgvHgSE3Mt2zuttqnhmIqjvAwvG0JzFA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 3:07=E2=80=AFPM Luca Boccassi <luca.boccassi@gmail.=
com> wrote:
>
> On Tue, 31 Mar 2026 at 19:34, Pasha Tatashin <pasha.tatashin@soleen.com> =
wrote:
> >
> > On Tue, Mar 31, 2026 at 1:56=E2=80=AFPM <luca.boccassi@gmail.com> wrote=
:
> > >
> > > From: Luca Boccassi <luca.boccassi@gmail.com>
> > >
> > > Userspace when requesting a session specifies a name and gets a FD,
> > > but then there is no way to go back the other way and get the name
> > > given a LUO session FD. This is problematic especially when there
> > > is a userspace orchestrator that wants to check what FDs it is
> > > handling for clients.
> > >
> > > Resolving the /proc/self/fd/X is lossy as that has a hard limit
> > > of characters, so names might be truncated. Also requiring going
> > > through procfs and doing manual string mangling is not a nice
> > > pattern.
> >
> > Hi Luca,
> >
> > Thank you for working on this.
> >
> > This needs more explanation. The way I see it, the user orchestrator
> > can be the only one that has access to /dev/liveupdate (and this is
> > actually enforced by kernel). It opens it and creates session_fds for
> > any client out there. So, the orchestrator already has the FDs and
> > sends them to clients(e.g. via SCM_RIGHTS). It then monitors the PIDs
> > of the clients, and if they die, it closes the session_fds for them,
> > as their data does not need to be preserved.
> >
> > Could you please explain why the user orchestrator would need to query
> > the session_fds, since it is the one that creates them in the first
> > place and has to keep them open in order to preserve them during a
> > live update?
>
> The orchestrator cannot and will not hold on to all this state, that
> is not possible. It will simply hand out session FDs on-demand via an
> IPC, enforcing a naming convention for the client, and immediately
> forget about them. Clients will hold them and use them as they see
> fit, and then store them in the FD store on shutdown if they want to
> commit them, and that's where the orchestrator will get them back, and

I see. The idea is to expand the LUO Session API to be compatible with
the systemd FD store API.

> they need to be verified that they come from the right cgroup, what
> the client's portion of the name is to be able to hand them back after
> reboot, and so on.

So, if I understand correctly, the enforcement of who gets a systemd
stored fd returned to them is based on the cgroup name, right?
Presumably, after a reboot, each VMM would have to start in a separate
cgroup (using the same name as in the previous kernel) and request its
session FDs back from systemd. That is what will be used to verify
ownership, am I correct?

