Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5908FC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7202E6B008C; Tue, 25 Aug 2026 10:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8496B0099; Tue, 25 Aug 2026 10:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60DA66B009B; Tue, 25 Aug 2026 10:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE5F6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:09:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EF4A16043E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:09:23 +0000 (UTC)
X-FDA: 85139974206.04.7D0E4A6
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id A240380009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:09:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aThZ8ydz;
	spf=pass (imf02.hostedemail.com: domain of jannh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXPt5VZpDf4uErUsjt3ZAZlmlIM/hF9XA8Fbbo+LtZY=;
	b=ktyr0vtRiG6gl4Z7GRYr9/sUMC6WE37mxZ6Hqv3PXEDOx7V1fe8NP5fPgoBsBrhlnlYcaE
	vLHwbLUlKq6RMPXT8CqrxzUFQ7AMS71eGoKEMafqKQrEYJdmSo4zeGH7bEevVufTgxMpd4
	5Wl1xdED6Z12SuKpMXgkv8fd/uEIFyk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787666961;
	b=O4IZvFL9iz87gYRy6dYCVCo6J8/nhI9iObpXkA8NxfZMQCSyzZdgxp/M4rZ//QxqANyB3B
	7P+c6uINYsdig8FjL4ROmqS3bPundjmm5IaRWGrIQIFFXrB15kdGjnjU02bfpWO0enVI6L
	nK9b1DcTKL+KgcB1X97bBDUSvGBM9xU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aThZ8ydz;
	spf=pass (imf02.hostedemail.com: domain of jannh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d3b440b97aso107385ad.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:09:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787666960; cv=none;
        d=google.com; s=arc-20260327;
        b=IKV83uxMgIDbFBnHCJjHXhTCI9Nrs4VqBb6nT6JilPdXLzhQthrT6eHEowaEuvvt/M
         hMMvkRTg8yYoK1nDMC4iEJ6u5VVOY17mgaciBwPLCggl0U2drnCZkJXejL0geDtC7O5P
         NoE+trT7Y9plyCSBrkkx2atEpVhk+FfJhmh5iOpKt8ZU5hSV0LUb0WjMn6YC+qxWtN1x
         9KiCXHwaKGoqW9cOsGIcaP2PKyYyX5LriiQ64aUsAyjh1ftf1QsWiyqU4jPtV1sXK8Bk
         HnxIWSbuFjDFz1BBPPnKc2z/s1hbyyNuKuxhHvtdDN+XUhQkgWB46HInrT50dDhxYBtV
         OGBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rXPt5VZpDf4uErUsjt3ZAZlmlIM/hF9XA8Fbbo+LtZY=;
        fh=NLFqr0TQX4HqhgVKuLN5II/+WFjoc7pjS/iRBFhk08s=;
        b=s8ifZCGCS51qQs9GAZ3A0OfgTXP3zqBWPFmq7S0El8p3QT9KQhM8SCLZvmeNDWIg8M
         8iFibAFC1ds8X22HV4M/9N+JAV5aXz5Rt61qU1V71SzdX7eMHOq/VNxoEW2mayiJFZR8
         6KCQPDombcsAsz8medHGKuisSN9bK42qa3KKT99AJPmzXrli5bM3g+SgZWGYDtw9TvgJ
         VmRc/tpi07xJLFi5aK/P46eK7mfMcAOjLlCv5M38+j6cIvn6/JZnNyC8Hc6xrp1xpxKU
         KV/+k2MkaHu/C6FJQzYDw5TgjEzp98vFjFElrgdT8V8v3f4vEiD43MvkV90kCySHJod7
         HLmA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787666960; x=1788271760; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rXPt5VZpDf4uErUsjt3ZAZlmlIM/hF9XA8Fbbo+LtZY=;
        b=aThZ8ydzC7I/pbqP2tGqiNpBF8G5xpBm8g30SswzOB2vOuAKZhimIRgka138y3zxO5
         0yFJW0MAtkCYgMuJFdxBHXR9wr5oVmqGVrOvXiKz6g9Zavfh3RFfv/9paSaXRH+EaaAV
         NBQpoK7Y61ezmvDtfWDdHXBSqKM2uFKJkufYQ6vV7r8uyULMoEsIw51DHqKDJz9B1fwe
         1+ijzl1UYNi7uZTj2pP21sYSPqi5KiqtmZxBzy3QLejrgzgWft6lP9GBg3pRtNiPiMFe
         m1LEelqOfBQgLVb24m5cJ3sm+cM+/ur9xJ4l2OIDtAbZw7jp+9W0n7LXMEhQ7ecFk+Wl
         ERaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787666960; x=1788271760;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rXPt5VZpDf4uErUsjt3ZAZlmlIM/hF9XA8Fbbo+LtZY=;
        b=N9GGTWeIAE2Cb4z9e3RrQBqNnFg4vekpz42myK1zPIU4yzCI9NPr7BL3K9zXxJSp++
         YQGErfVjjCZUzhiVzFa/zY83Z+U5QhKg+vs9SHHeK2T8MPF2ys3aJBNCzw7Icy/z6l+h
         3UdcfDDXjcNwggeUUcNKfZ2gJcMQsQI+pTYMv/Y3OfUi9YyQPote79E4aPWAr/wSceUL
         jjC3SiB1VyaqqN5Zwnt9ZXqNz0F16EzBJIheql0VkolEoT0aUnOhS41ac0qjiFCI1SCV
         ag8U3P4Rz6PCMjQOH2NPbfnuzVYMeHMNt/j/vAfkS9/TUOZCrLAUWUks1h0FGmKuLoHS
         Vo4g==
X-Forwarded-Encrypted: i=1; AHgh+Rq3fOSAbBBJEpaP6AiuB/h7CbmppfzEgnwqxP2v5pLeoaKLvRQ5OfT+Qq4YxUBsh/5PIRROMLhBnA==@kvack.org
X-Gm-Message-State: AFuF++mjJh2vHL7rONzMAbUEG4Dj8DnYKTYVKLrRxh7ocFXKKEBZZ5BA
	UcnMt0ivvaH5pmcLgPnBFurQjAtxyQi4opToEdszttYPvtENBUnO1S47HUZtSD1JsKlPB4B4LY8
	Ww6MBb/9Wjw3tQPpUVN//nvFjzzMHf6xgbAXuVOe2
X-Gm-Gg: AR+sD11ymv7/xLToenG8SUbNUOu9GsqAEkeoKb2XM/dNT30hfsQ2cKhZ8OOnFNJddCj
	DV5c0V8Bi7SzUYDSPwhRGV1u7/wkYpYyYIrXz8/7AeBN1eRdwDoOCju/M8aEr1OMGMDbl7iO3MC
	IOHuIx/MLBunnmOYbzZjElBEShQ/otR4uo9NMWeArGjtOQKMHioygX8Rv0M2Y3htEPsWSaAPVmb
	wKFUQt9hQKW4tgN+z15UIk8dm8tEJV5ny/n6ngPSOXbJ7FKrGipstcn3qOLbAzDYsI0mcpjcHlc
	QIS2D6WWrI8CtomDuAS9NDX+fcbo87Dj5BWfzkbbHJ7dSRV8ZLs+FFOYPbMG1a+Mrh8o/4uiRUX
	9Ern0Uf3DUFB0vfBG1SU4H6EagNBJGg==
X-Received: by 2002:a17:902:ef4c:b0:2d5:db38:8010 with SMTP id
 d9443c01a7336-2d6f2f25ba3mr341215ad.15.1787666958726; Tue, 25 Aug 2026
 07:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com> <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
 <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org> <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
 <aoibvf6CY99IXynk@gremlin> <CAG48ez0CX-PT5Yk5gYJuB6wPe26j0gHHXQqYoNtTA=iHe_5Wdw@mail.gmail.com>
 <aox7tVIQBMuz-xFO@gremlin> <CAG48ez2-8UjzOp=St5eTPyG_yd2iBmPF6y7qVBTNaPNJgoX=BA@mail.gmail.com>
 <ao2a33Xf3U0kQmM_@gremlin>
In-Reply-To: <ao2a33Xf3U0kQmM_@gremlin>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 16:08:42 +0200
X-Gm-Features: AcwNN1WtvUE6nvnD4lMNaCfocLK-DLM3bUJQe4WrdBFVB5gGe4Bk4AlrWw9e41Y
Message-ID: <CAG48ez00PjoaXt4xJn1DCNdZfmFn4faya++=U2EeW0_vcYXcqg@mail.gmail.com>
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: csatj6h3m7jdso7hbq8zpg7x3pb5hk3z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A240380009
X-HE-Tag: 1787666961-251702
X-HE-Meta: U2FsdGVkX1/C/pd+pUc+TdpezNLwWs/xQu6jMBo7IkUB0/qkymWg1RuQ5jLSob7gtpQBNK0lZ8g+aJMMj9spIcdSoQQXsjBVizTEEHP+4nmCAnfIb81Dj8MckxgO3wkdlOQQUk4rfwMAAsteNPMjdnWNZ5deJxEab8930OCOsEeGpKYiOpcb7q/wj7a5ewEld3tGb5kgYHmuUjcVmZjY48W71IHfcdsnKlYFjz/pjqbIhp7psGsUanXaGGTwYSo7rfv8PsNJw5VjTEqLLkfjV93T5jEJb//A027JUJLERHfA2picKPlW75QTMgNEjpx8PzFAhDbZt/nHxm3CUtpLpIKAyPgigBPPMY0CfGgGTcK9YX0Sv/ElYHVzaRkd7nuSqi9VXjld9/bZvjEOJ84ihevIcx/bcxCnAmSsX6dGeYiOt2RfyPCLoe0X+exEoXFYJzZdEw+SMuciXDhrYmnXuUJ6erRONZylu24bG/D6PgnHapbk91a6HYLtBvac+zwWVInlfI7/RcLe1IhB1QVFnZg7oIGdUSIWCDC5m6oq6N2CRrRKRC5wHVgeh3ZKJi3lBnTPTUKTFtYmKoXRJ1rSzGUZXWQ0/OYDC9MP/utDTyJbgmK2yc/reBj75J87PkdgWOq0tVDW82qLmEmnX3etgJObdtXUVxxZKBPjU8QUsBVHOVmWiNW1FGvJnNF7Zn0Gg3xAT3tORNBsYtybPGFCCi6rVcn3yUyaczLmUkdfSoRcGpaNiqG1zrSGeUrXvD4pSmXFfBmuzdP08tnyhdmXW2dUYkbOW/8TGXMuiNHPdScjKPuX1luNbjvGbPVJNOdabIZk65bmDwGoi2+X+i0do5pUFXRp9QdyPbZzJp4Vu1Uqg25x7M+HGL2tbda9xH4RDLAg4UZ7IluRpDOZ4YlQS4Ig56gNvENOekEnEAijIW7kD8Ehg9bVbgTFhJjhgh+HKeRfsxIFIqHbmfnyXG1
 9kn5tQ2l
 /wxuzbhbht4G4FYzMmlDO3nyM+gEfbsio9db+QM/7HtsqJ50bcM7Nzp/Yv51AS5+9kOFS4FRPGye46+cpABcMEtMnY4Wj5Q6VGwctaBMsb58Sr1/KoCTsZ+nrOQfYk3BDf/zLjg1D9Gd/T3p5Lib+cnpgcvG0CzC1k2ib3pdFGSdcfTgJUfSL2RIXJkWHN54gLoKJa1y5//RZ8BW7XF9p6h5nKIaIbHyNmcmiqILwz5nQNnYl8YRD6UOZVUzo1qowoO/a+1y1ZYcOgcbKTO6XTMHW0UKHFfZIgb8atIyfjOcPpmvSRuwVqmdW4PEBKk4gGiABQQw8zBfpHE99J2Vs4j/bsXyGkCIUgRbq8rwFqsWS9vtc+Yxk1mVk19jHqn1OcxQsrOQmL8dv5SB84DcoZGnXCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 3:42=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
> On Mon, Aug 24, 2026 at 07:43:02PM +0200, Jann Horn wrote:
> > On Mon, Aug 24, 2026 at 7:33=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> > > On Mon, Aug 24, 2026 at 07:06:04PM +0200, Jann Horn wrote:
> > > > On Fri, Aug 21, 2026 at 8:52=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@=
kernel.org> wrote:
> > > > > The sharing a /proc/mem fd seems like that's a pretty dumb thing =
to do in
> > > > > general :) but I guess you have to protect against that.
> > > >
> > > > Yeah, it's a kinda weird thing to do...
> > >
> > > Yup :)) but I guess we have to account for people doing weird stuff..=
.
> > >
> > > In this case (I do mention it in a reply elsewhere I think) it does s=
eem
> > > like perhaps you should separately check for current->mm !=3D mm of (=
what was
> > > originally /proc/self/mm)?
> >
> > I wouldn't want to do it for this access check, since that could lead
> > to "confused deputy" problems.
>
> I guess if it got the decision wrong somehow that'd be a problem? Or wron=
gly
> OK'd it on one level but then that led to the fd being passed on assumpti=
on it
> was OK to do it or something?

The problematic scenario would be something like:

1. process A opens fd1=3Dopen("/proc/self/mem",O_RDWR)
2. process A does lseek(fd1, <address of libc>, SEEK_SET)
3. A sends fd1 to privileged daemon B as a "log output" FD
4. privileged daemon B write()s into fd1

In this scenario, daemon B is just trying to write log output into a
file descriptor. If we checked the current credentials on write(), we
might enable FOLL_FORCE just because daemon B is generally permitted
to use ptrace.

This illustrates why, in general, the "ambient privilege" that a
process has must not influence write() access decisions.

For a similar historical example, see
https://project-zero.issues.chromium.org/issues/42450869 where we used
to do capability checks in the old expand_downwards() logic, which
could be reached by writing into /proc/$pid/mem. That made it possible
for an unprivileged process to map virtual address 0 by providing
/proc/$pid/mem as stderr to a setuid root binary.

