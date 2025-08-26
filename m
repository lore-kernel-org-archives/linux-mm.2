Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCEDCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E046B00A1; Tue, 26 Aug 2025 11:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDEF6B00A9; Tue, 26 Aug 2025 11:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD9E6B00AA; Tue, 26 Aug 2025 11:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17A076B00A1
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:02:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA52A56838
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:02:57 +0000 (UTC)
X-FDA: 83819225994.22.638D66B
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5BA416001D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:02:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RrDAu0O6;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756220575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+0PR2fJcjZ6JOVTFgH14262z5rkDGxSbAwbjWWLyng=;
	b=z3aUUvH53JcoVvQ8MIDtNliFpEoqqeE48Mghbi+tpVG9HE5/eRfkeD9WBVi4BrB1W0d9aK
	zFZNLgcSgi0czhYU30Wa0M2w0vrpieWHWZg1SUezE7QST+cR3CTz9gQLEOjd88NSLyNsC6
	uyyPnCHP9Dq2cW5MBRjSdLb8jBwneV0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RrDAu0O6;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756220575; a=rsa-sha256;
	cv=none;
	b=O1rcBMchac4T/3NefkvU3gc8xI0TSBHb1es5sivC/ycEadA7mDPrNLsd586XNY53HgOAE+
	gHZxi7a5itJuUHert9OF+twOGZoTV8D28AuB6T2oC16YhAnKKAfcDyVHI+MO+weU793JY5
	As8Q0wd6/Uma+rstoXJiyvetsjGC2/E=
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-61bf1542ecbso2616710eaf.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1756220574; x=1756825374; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+0PR2fJcjZ6JOVTFgH14262z5rkDGxSbAwbjWWLyng=;
        b=RrDAu0O6BlyzuQcuC7e/6ITS7Wl1r/x3278oDEOon+8c8XIklMjHkRUBlcX85UpqL3
         hM5gUm5jocrIB4FGanqbLUK4ZR0oL8l3P/cBfor6j/5eb+hp2b9L+FHpRmSzYj2dTBDb
         0P9yitZDmtNx7aqClocLcoV5uTWlwQQGYwMRuAtitsUDIFlP+N1nnbeoqKFRLfq3qW/k
         z4l/vDHnWjLe8RnyrC59CT1d1TAmrVbmKxxm2YJj3uwOhXFZyBRjcRH8ARtfkykxVVnI
         t9MHliwwpQK888DNPKt2FM+FbxrGw7cjtYcYm+HxKQ1dbz2J2OIUvolUWbUxNb17VgZB
         xzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756220575; x=1756825375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+0PR2fJcjZ6JOVTFgH14262z5rkDGxSbAwbjWWLyng=;
        b=tfRTOqWKbKwXj6xvFvdsQLo8GEDVjd5kcvSk7dQIvFe4+ZpsMQ2qTaCjuYLJronCmw
         YF+uEee0yoEwxQZvt8POPIpqO1q3e02K/eMsGBf2AO5Pj4TILBh1/2lzLWltGc6xWzj1
         rJ0JRBR2F+s1RHBg/ym6yHxKvu+d5h7b0CeFPVDzLnQ4FghRiMbeDvXjhJ/m9YxdynH9
         Q+Evo6p2sT7QITUWlbIPXiMzUaLdyVqGa1//D2GTQM99PN+vl7RvI1XH1GW74Qwgfkot
         L9ry5Q1rpUXtMGZM0v5DGDdqLrwF3Aadp9Fo7dsAAg47Rc3sYCLdXnUsGsRnDFtOhgvk
         ZSqg==
X-Forwarded-Encrypted: i=1; AJvYcCVtJXWBS2fCma3G5G0Ufjf0kamPL7+1M9x6EfoD18jQ8OT61ctX8FYUo53rTtnbGWaYjePGkMExEg==@kvack.org
X-Gm-Message-State: AOJu0YzNYzAhQ1R4E5THFuLBPfNs3ljSSfQ7l6SYzx0GWSH2nj961gwk
	Q32cOlE/2h9KPWqC4YPowbSlLTc0wSFNYoPIfT4U2SsBfhgGwLrWBznwniCk8hAKfpLoLfnpywd
	n9k3SKrg3FU6Dr++Va47jpl5xJ/O/3Rw0xESdLrIsnw==
X-Gm-Gg: ASbGnctCWc9j2Itcw4nX0LBwZvEoRVoHIFnG5ICqfRwBUtqT+OgDcblFQ8BSbYsB7Jf
	pIuPkUiuM00uDoy0Yk1TJpQJXCQtjTvoYKcL6avhF0ljjnoatgb7DJfsO2A9+TpGijyVV4plXBM
	qDDa7QFulL/BBayO1SsF8XkWE/43fenJhJ5BMvaaONFIwSuYqjhzhmLLsdHbFtvIqbm+tCh9NCr
	jsU
X-Google-Smtp-Source: AGHT+IGZRoryUW5ksQYVJjIedWGTznIaiVqZiY1Pg/H6rjAtNQNm/14jN2CvpI319rkbtN5Pjbxs+aqTIMSdEzY6AGA=
X-Received: by 2002:a05:6808:3442:b0:434:b43:d4a3 with SMTP id
 5614622812f47-437c543fdd9mr854638b6e.12.1756220572416; Tue, 26 Aug 2025
 08:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <mafs0ms7mxly1.fsf@kernel.org> <CA+CK2bBoLi9tYWHSFyDEHWd_cwvS_hR4q2HMmg-C+SJpQDNs=g@mail.gmail.com>
 <20250826142406.GE1970008@nvidia.com>
In-Reply-To: <20250826142406.GE1970008@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 26 Aug 2025 15:02:13 +0000
X-Gm-Features: Ac12FXyHXPcCjTtFR9AWQQdvDhbej8DQJ5aeFKL6iCSLSRPcL1vtdZDLkhVgq68
Message-ID: <CA+CK2bBrCd8t_BUeE-sVPGjsJwmtk3mCSVhTMGbseTi_Wk+4yQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 114739mguekthq6szbjq7rnro55hmmfd
X-Rspam-User: 
X-Rspamd-Queue-Id: D5BA416001D
X-Rspamd-Server: rspam05
X-HE-Tag: 1756220575-320060
X-HE-Meta: U2FsdGVkX1+l2XHblGv9Y6fNYVpU5u+ZFO8X0ecSkBbjTheu1APSQGMbN9JqU1XxiLrA3itA29/PT8uureJ1woSdZiMvKH7Y8dnawMzSLBbKgSflDWo25nOFjU8TB6+ddsj0O3MLO7i9X6UkUOKOopJ1F94XDUp4nGFKB6i3AD4YV2Oxh1AXvKLPLlNoW1XjakPAn4w/eQbvGAr6rqR69PJXWNZmykqaj+iZL5Oe912HKYgBf4uNJGB2WRjlTlT6oOxp9BX/4k+ZXr0vApvhwAU9VfoCgTuxprmXZ90jVYGtfd9SEy2soqhDBqD861Z8bh/2LOpWBwb+pqYT2FT7clKs6L9VHuRTYL3SumdmxWh+SoxtuiJC0fvZvkJqxONg7GMd81HxMLqOK4NOzosOuHJSDfP99lFdERLe8lpXR+F3gMhLAXjpcJrnyKhkzsYfy+eQqa8EyrGw0uyZ1Ws+Trrf9i3oDQK9zUCBMZS58kUKxQMl2GvFJZoMr4PyqPeCgPfzkDDiOS7vGATLMeOi3wPQLiBZtytQQUAwAnNltNIHtQXcXEBz0lUHlwDhUWCBPg96EwHWOq/6uDFG7T32XuF8Fdtvrs/HSFwAMPq+ifanhtBBLJZJETf59+kO66G8G0tRbVI3hsdl1Nl16B3B3+4b+ZIUQQw/ociHrAsUTXPVsRoy2C7UKPEbLbTEefE4GuBwXeQhadtxxZRSPdlaXBtQb/V4W3fgztwb0ErcDQvnZGS/H+YiAcsJ+qjtobUL0uzuS3P8cwqwA7JZLvjbUmUJxeRSMlOJU60lFtdNCXRRCD8PSbyPd8aCRNdlUSOxqHVLRXvIy8L5MzcQh0rWYg3iafQjAvHiE5cFkF87k2h5sN8heoQU/6Eys5LUXdG6s59ZvSShmZ02Gc7rdb6Mfq9d3RgkciPwANpz1CH+IiI9cBwcoAbJs/tCbkUi08PZXZ4InEgLO5JxFRd2XbG
 5lWcJ0PN
 RoBlyx8kCWf0HF4oTEg4iFlNpEcZdSVN8S0ZDTL2/tzyWAoJqxyY7DGJ76Yhx8DHo74EkKjbSPDZsV6RbaAD/zOg714oulBrGLxJSnGHujAz+T+TfYHx7zIRKjQNG6pU4k1/hfvsYDYA4yuWwj3VzIgPe0AdmQPQ3QklCS9OIVtgoslW1d5FiMv7x4l4rvU0EQnCP/cNp3cUw/3cmFrnxpJnL+dPwVR8O2Uwich8SurLe4oZIYICF3DlY6zGKM29TrOvXozFx0KGpNbbEuoYKV9NDR28ULKH5cvYCa4H3myBzCW66xNLVOEF6frdZZsRMq6LIwsAMdZT8goQs2PywXiE91+o9yp/hbzqCGsuhedxE/Az5Fq5CYjIdi6PYjfbPwMRR5jh70O+fVDqeGNJIb//pC0rulII7pJXzLYMA2yiimA7mf4zsvXmR8k4NkJLLUMOUlICaRW00PAYpv75/KwdRFASbrV7uDqOJ0IWhW+9XBOwCTxFKjXn5c1l7t+HPekysWm9qGZ3LCY8yfX9f5JYBy5eB6KVO1bxc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 2:24=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Aug 26, 2025 at 01:54:31PM +0000, Pasha Tatashin wrote:
> > > > https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v3
> > > >
> > > > Changelog from v2:
> > > > - Addressed comments from Mike Rapoport and Jason Gunthorpe
> > > > - Only one user agent (LiveupdateD) can open /dev/liveupdate
> > > > - With the above changes, sessions are not needed, and should be
> > > >   maintained by the user-agent itself, so removed support for
> > > >   sessions.
> > >
> > > If all the FDs are restored in the agent's context, this assigns all =
the
> > > resources to the agent. For example, if the agent restores a memfd, a=
ll
> > > the memory gets charged to the agent's cgroup, and the client gets no=
ne
> > > of it. This makes it impossible to do any kind of resource limits.
> > >
> > > This was one of the advantages of being able to pass around sessions
> > > instead of FDs. The agent can pass on the right session to the right
> > > client, and then the client does the restore, getting all the resourc=
es
> > > charged to it.
> > >
> > > If we don't allow this, I think we will make LUO/LiveupdateD unsuitab=
le
> > > for many kinds of workloads. Do you have any ideas on how to do prope=
r
> > > resource attribution with the current patches? If not, then perhaps w=
e
> > > should reconsider this change?
> >
> > Hi Pratyush,
> >
> > That's an excellent point, and you're right that we must have a
> > solution for correct resource charging.
> >
> > I'd prefer to keep the session logic in the userspace agent (luod
> > https://tinyurl.com/luoddesign).
> >
> > For the charging problem, I believe there's a clear path forward with
> > the current ioctl-based API. The design of the ioctl commands (with a
> > size field in each struct) is intentionally extensible. In a follow-up
> > patch, we can extend the liveupdate_ioctl_fd_restore struct to include
> > a target pid field. The luod agent, would then be able to restore an
> > FD on behalf of a client and instruct the kernel to charge the
> > associated resources to that client's PID.
>
> This wasn't quite the idea though..
>
> The sessions sub FD were intended to be passed directly to other
> processes though unix sockets and fd passing so they could run their
> own ioctls in their own context for both save and restore. The ioctls
> available on the sessions should be specifically narrowed to be safe
> for this.
>
> I can understand not implementing session FDs in the first version,
> but when sessions FD are available they should work like this and
> solve the namespace/cgroup/etc issues.
>
> Passing some PID in an ioctl is not a great idea...

Hi Jason,

I'm trying to understand the drawbacks of the PID-based approach.
Could you elaborate on why passing a PID in the RESTORE_FD ioctl is
not a good idea?

From my perspective, luod would have a live, open socket to the client
process requesting the restore. It can use SO_PEERCRED to securely
identify the client's PID at that moment. The flow would be:

1. Client connects and resumes its session with luod.
2. Client requests to restore TOKEN_X.
3. luod verifies the client owns TOKEN_X for its session.
4. luod calls the RESTORE_FD ioctl, telling the kernel: "Please
restore TOKEN_X and charge the resources to PID Y (which I just
verified is on the other end of this socket)."
5. The kernel performs the action.
6. luod receives the new FD from the kernel and passes it back to the
client over the socket.

In this flow, the client isn't providing an arbitrary PID; the trusted
luod agent is providing the PID of a process it has an active
connection with.

The idea was to let luod handle the session/security story, and the
kernel handle the core preservation mechanism. Adding sessions to the
kernel, delegates the management and part of the security model into
the kernel. I am not sure if it is necessary, what can be cleanly
managed in userspace should stay in userspace.

Thanks,
Pasha


>
> Jason

