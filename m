Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4FF4C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FEA6B0088; Tue, 25 Aug 2026 11:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907546B0095; Tue, 25 Aug 2026 11:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780566B0098; Tue, 25 Aug 2026 11:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49EC86B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:01:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F0F4120497
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:01:41 +0000 (UTC)
X-FDA: 85140106002.07.3D7D30A
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6EAA514000D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:01:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v1zgu8gr;
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787670099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oIFfbtqqpkWwrgVhDrxQYn46cLcGtScXKxY6SpqPlY=;
	b=Ni1fBNMZtbWnJhY0E14DP/EllFNl3TG7JYiO81dFjPpjxssF4kHrSLo5S9stY/OLk0RMl8
	+g52v+8NLY8jyC5OHwhS/Uec03Xdb7odzLp0L3KnT5ZV4syAhu/xBVl9JQfoSkT2B99/v7
	7hkI+heK8Y5JzWBNUCeaj1UbH38xBsw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787670099;
	b=d7B3EelkFhTsF2+lA3Jq+5Aw4O4EmCU2qbdmvTIAA0u8+UbDNrzX/Q2DeI0sc/+9vprh5y
	D0wCO8B6w6VHETUgV0c0r14WspXmRwlny6rhk/lnk7/a/IC8FhV2nxtfIso52uUNcTafAS
	rhXQ5nHl8RwYvfEWLROY/jZD+LARiCo=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v1zgu8gr;
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d3b445a84fso105375ad.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:01:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787670098; cv=none;
        d=google.com; s=arc-20260327;
        b=QmafU5ON9H1J01zyc5aXyQQ5t7ZxnO9VKJW0VTRRU466rAISBmwGyymQgXVuoYCXp3
         qLtXB0JKqzNo00su7UcpLQQfS2UVRnj4P1GnPxl5lfQl6gyByGvMjzCKD6qSLB3Z0VRr
         nUgPa9TTqLwZVBnOPM/9IazBQdJ6uzV3/qQgL1nSKYVF17ll93WGblrnvO1LOB1rzlqx
         QOVCvitKcOdZUMnGG+WnAbwKQEkH3a/Xytg19w1hpw2kdUUMbPFVVAh+7+P71zQNzRJo
         6xdX66m3UcplR7967dickjiN1ZmCTT4IxQzwHiTB3vZpb/2wEUCH3N9B/Qr2xf5Z/sOS
         0nMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0oIFfbtqqpkWwrgVhDrxQYn46cLcGtScXKxY6SpqPlY=;
        fh=262PcrkfuXNdhTVu5PEZceOhTe/OTHGGBhCOzsfo0og=;
        b=MStGC20rLS71NUYD3yt5EVo05DxNgXJ7d+1lqQcw0zy8VHfsuGoR7c3MbnN+EcZn5n
         5qQu+YxpWQ5b6fByoQIj8YLJbeDORG2MnJVbNNM6aPHlBEXVhyfw+/3AmG9a+iy3L0Td
         Q6fJJbqiLwM8pYqKVlFAKY7w+e8aRDwn4m61mV2JIONePQiiFvN3FEM/YjtdzqU/c8ac
         ANQXJkUUL4R8Ww6YthcZYi9yp1KDcb8xQEdFIv3r79C/XWg8vCOtNVQcKj96lIfyjydu
         gRSXQlHej8J26ngEnPEDxVL3Vb9UFxj0dQqmsHvig+Ht+z0UU4wyzrW9FJaw6+KSifF5
         kdTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787670098; x=1788274898; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0oIFfbtqqpkWwrgVhDrxQYn46cLcGtScXKxY6SpqPlY=;
        b=v1zgu8grkuOiMxRfD92OFn+8pWwTrmBNkimQBPJ4bdhJ/lUFM/QN9uC1R4/ax7yU4A
         71i8/TYgu3ioBnANMyhOXjAvkmG0xQIIFRnfJNU8Mscud1JS7Vvcc7RVWGG/kFsNClZv
         9g+l4/Oi2w7hkb0DGIkCe+pJ/bZUQs8YOqHkFc39c+zZex3xnqZ+2EohsKOA5IOYxRBE
         qqWPt+QFStXHKYZg6rzCPTUhGXROQ+USndQ28cPzk5dG61SkgbYOTLKJoZ2fUNLafXqE
         n4PRFLZRdM8st49aIuguM83WO+NfCnZrTt4MXYYot6j/St+hbHRcRF8nRIzogIK2FdKD
         QTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787670098; x=1788274898;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0oIFfbtqqpkWwrgVhDrxQYn46cLcGtScXKxY6SpqPlY=;
        b=Cbg+kd13JGBdBo9tCPJJs5O0GkvoO9MQ/BwYqg04hFgrmSv+UpuQq16IsGf+K5n7jk
         EJZOPXre1RzbFgxtaduNOW/9/z4xoAHEeK4PtqKmuB7dQqD+krIntKxFxJM8OCLyAg6W
         1gQ3ClmesMYMRkkNeRQWP/mUVODl3TKTKOtfQqQnt5BewttKoOafdeSu6jrDOeUAQsxA
         nfgLq+i0fDeGbQK8ynF2++9LkUtFfgWWS/0xb+GD/6oYUPnyoYTLJ1ALel8bbCDf4ays
         Hk7kU1McSMLH63c8BCxO1ea9EUuQJ2h71xH2opd3LFEgO8NCzCoOjjcOnfWoS1sgW+jQ
         0bYw==
X-Forwarded-Encrypted: i=1; AHgh+RqLW3PjBmyrSjYj40r7gnXDARUlh+Q7OBC3w4ZCfSaZe+0l4R8CI3xtOIypd8DgTXkta0NyfKuorg==@kvack.org
X-Gm-Message-State: AFuF++lVza2v/KV+JoC/CikHkoh+jH+M90yZ/qn/db3S53d1ZAreUTBV
	RjivujoLiD1oi2cPn5lfssthZhuODs3wMc6MAaKQFZaNe6yq3lQ2OcMVIZTR36OsaN6vbihgQFe
	O2hTm5mxwIjIAPmSk2pseKSa710QV8T4c/GySoHuq
X-Gm-Gg: AR+sD112W2bSKdIBE1bGLp9lddS+N0WiszrcJcuRHv0JtkgcZDPjxeeSFlC04cuZ6MN
	4RTHoaEkWBt/Zv9wfedp8QOQL6d5h5LhPGgj18yEg5d49XXQ7SFji97C5DS0qxWsCsiYHXELm4J
	DoH9XsZZWeTb6Ok10OZCHNZg9Q4Vbq7HUhHmdUuBnhOVg2wfFrycwITWDqS472VLlTDa3rBHEHh
	NP/8H+wgFlaCdgaXSlX71p/jWKMBSrM8VrqH+P+SdLNbnRO09b6RbxQNPRfq4oAMnqYmkmbp9fQ
	XWd3yLbf7HdOQzL0GfUwul3yZqb/w8l71od3SawoGZ4CV4MUY1W6/OGWO8fokBbP5dvL9AoiOhc
	WW1o5lwMx1WBLL+Ap+8KoKld3vFqXlg==
X-Received: by 2002:a17:902:f142:b0:2c0:defb:557e with SMTP id
 d9443c01a7336-2d6e07f52b9mr5455445ad.1.1787670096873; Tue, 25 Aug 2026
 08:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
 <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org> <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
 <aoibvf6CY99IXynk@gremlin> <CAG48ez0CX-PT5Yk5gYJuB6wPe26j0gHHXQqYoNtTA=iHe_5Wdw@mail.gmail.com>
 <aox7tVIQBMuz-xFO@gremlin> <CAG48ez2-8UjzOp=St5eTPyG_yd2iBmPF6y7qVBTNaPNJgoX=BA@mail.gmail.com>
 <ao2a33Xf3U0kQmM_@gremlin> <CAG48ez00PjoaXt4xJn1DCNdZfmFn4faya++=U2EeW0_vcYXcqg@mail.gmail.com>
 <ao2jfUGzbtlW0LBI@gremlin>
In-Reply-To: <ao2jfUGzbtlW0LBI@gremlin>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 17:00:59 +0200
X-Gm-Features: AcwNN1U7WXh0ifC0L0ioBcpyrRebieCgpS1C9eeY3jXHe62YSQNBLeFZPlG6sX8
Message-ID: <CAG48ez1ttTOf6wobCpRK+upYJqU82jgmxGSX_e7xWuxU7xYoYg@mail.gmail.com>
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
X-Stat-Signature: oj4oubjcy1bg1sa4jwiqgyig3hdw4ho3
X-Rspamd-Queue-Id: 6EAA514000D
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787670099-334959
X-HE-Meta: U2FsdGVkX19EzH0hsyDdw2RpuaB+hLMn7/rcLTZuNah2zEejJcwWbOuDVBSYCxAw55J/SF1KoNjVkLwdFm77aOkAqzcJlsfZGFDTJ0o6zDJZNBtcsMCxhwKNeQBVwWQ58GNZcuP4I6qw4+pPf3hSTvV9PNi1soHzV+qZeBdxhzmQBbgKGTtb3DJnIpDrkA024dmkANQ7XH1hZqC9raN0p+nSYA3KQn1Mo8O5v4i33x+accHc3wLtyZoL9z0gp1mkmx6q6jkqNZIc4temqpxKh3blyxiKUDKYwSAH+1+hKstb/DA6qjXYp/G2pRtSj/iapOEZirBupyrqxV0w5KV5jazzfQ1ShGe8RxVO17D48U//4Rwc7glN078nWzdAxpq9YlF9CaOJcyk8Ay9Mn5cW0MdMT9qspI9uLGgihOopHnxEDTyMV5o2f+a/E2EZq1coTCKPIMArnX350bK7caWAPfTICiGLiKpBarrXuxcPWZwW/0FeI/maWfZI2yvDTF9UE826ztXe8qYHySomS+BGRTMpIkMBNvowJ1ZIUgRZFuPu0h/UtkpY6HNJv2zmYsqEc4zL0N1Ldla5a5cdtOBW30D6WsfjNJc4OcJLNQba72hSnYbZAQWIyAUUG86NRpZsJ2M/uaY5vTAHnsZmsEkvqIktAyVCpbra3nsy1gvHh+oOYsEAcYdWjadY8u7VQP8YUM2Zgx/1nq+uJUe9dxRbWnNknIxt/cfsl2it3SzUCeCRoRv8hXaikf41/eKEc7+DZB2MtprmFDa45YYpthRTCrYY2yLTpeH/J0QEiCFov6yghDwFfwXOT26QgIuSPwYfXjATDJoiWCRXdhtXDfFSElLzz6+abh9lBeGEwGI/5xSMSrQDbov7VhaAwg563iltA7Q4VR4Ymj67Sqx84Xsfde9Btm+R2l0jYiXXLwSmwtxpVQ+rYEVYORHIcEzW0CWbUfmtW8mtYs7b24H+9fq
 RJtdTolo
 dnSFOrF2KelO6eesIFeeCRzajFWU0vORRIuNaWi/y/NldZ1zX4uORRyWe3aCevsY+PNFqvHDNTg8fKfRL3KE0olsN/41xKYPyHjJ6RoFdOd+eAhR/07yMRD/JZUwA6lDWbaP6efvv8wchKFqwrkirgvb7PCUU+QELLHHbiZIO4RTJ2xDJ+LUB1puivE1JQf2/GHSP73+pIpwq3+EiwIFFof3i4iek9hmv2Xj0yQlOkhn0goT/SwFxBkqgA8K3l53LwUjPMyCD117VAc0lCebA5nb5V5+bxXpUWlC1RMKf5zr0lh8yexL2h5LjP7B5WmrxbhU8iiQv7XYf4r4kkNNSi/DZ0ichPrm9sH2aXziYOoiu5rsv5X+xxhCAgkb3b0100aaulvk+cZ2clQoKwGV6kgXPtIzrAzw+U4KlqrkLVw7iLqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 4:24=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
> On Tue, Aug 25, 2026 at 04:08:42PM +0200, Jann Horn wrote:
> > On Tue, Aug 25, 2026 at 3:42=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> > > On Mon, Aug 24, 2026 at 07:43:02PM +0200, Jann Horn wrote:
> > > > On Mon, Aug 24, 2026 at 7:33=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@=
kernel.org> wrote:
> > > > > On Mon, Aug 24, 2026 at 07:06:04PM +0200, Jann Horn wrote:
> > > > > > On Fri, Aug 21, 2026 at 8:52=E2=80=AFPM Lorenzo Stoakes (ARM) <=
ljs@kernel.org> wrote:
> > > > > > > The sharing a /proc/mem fd seems like that's a pretty dumb th=
ing to do in
> > > > > > > general :) but I guess you have to protect against that.
> > > > > >
> > > > > > Yeah, it's a kinda weird thing to do...
> > > > >
> > > > > Yup :)) but I guess we have to account for people doing weird stu=
ff...
> > > > >
> > > > > In this case (I do mention it in a reply elsewhere I think) it do=
es seem
> > > > > like perhaps you should separately check for current->mm !=3D mm =
of (what was
> > > > > originally /proc/self/mm)?
> > > >
> > > > I wouldn't want to do it for this access check, since that could le=
ad
> > > > to "confused deputy" problems.
> > >
> > > I guess if it got the decision wrong somehow that'd be a problem? Or =
wrongly
> > > OK'd it on one level but then that led to the fd being passed on assu=
mption it
> > > was OK to do it or something?
> >
> > The problematic scenario would be something like:
> >
> > 1. process A opens fd1=3Dopen("/proc/self/mem",O_RDWR)
> > 2. process A does lseek(fd1, <address of libc>, SEEK_SET)
> > 3. A sends fd1 to privileged daemon B as a "log output" FD
> > 4. privileged daemon B write()s into fd1
> >
> > In this scenario, daemon B is just trying to write log output into a
> > file descriptor. If we checked the current credentials on write(), we
> > might enable FOLL_FORCE just because daemon B is generally permitted
> > to use ptrace.
> >
> > This illustrates why, in general, the "ambient privilege" that a
> > process has must not influence write() access decisions.
>
> Ahh. That makes sense.
>
> But I mean in this case the check would be that the mm is the one belongi=
ng to
> the process in question so wouldn't you need in the first place to have o=
btained
> a privileged mm anyway?
>
> If the check is literally mm of /proc/$pid/mem =3D=3D current->mm?

Ah, right, true.

Still, I think I want to generally avoid looking at the current
process in write(). If I did add such a check, and the check failed,
I'm also not sure what I'd do with this information.

> And wouldn't prilileged process -> fd to /proc/$pid/mem -> less privilege=
d
> process be a fail in itself?

Yes, true.

