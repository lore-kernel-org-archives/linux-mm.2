Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB7D9EF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 06:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD966B0005; Fri, 13 Feb 2026 01:00:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B9C6B0089; Fri, 13 Feb 2026 01:00:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97486B008A; Fri, 13 Feb 2026 01:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4CF46B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:00:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59C5FB8BEF
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:00:18 +0000 (UTC)
X-FDA: 84438383316.12.375130A
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C22E80009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:00:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ncDihiuX;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770962416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geyAiFe6CRp+TmFBVbanEC0GJjERyNXe0YNZiczyJ5M=;
	b=N9YKjHbS33Aaw0OAWmFNSL978ENXI+tX03A1Enh1tXMJCmwrc5mkfqUlKXyOqhpK2NIIXT
	KIsO96pu1bKgJqaTdeTON5DE0J1XPszmeoXVe8mnuJH7sVHKIgadW8jCI5JVvJosXVn20o
	Vn9lyl35dOwpuV26ktJTduZgiXXEcrs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ncDihiuX;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770962416; a=rsa-sha256;
	cv=pass;
	b=j3a1fvRwGRgzPMrnQAwXnq6WKHHz6j9327qv2iJZxI9z/a4tRyv75k6dchSfx2hHgECOvm
	40J3dhgjVNc+RjtAaQXiOgnbq1MDDo02aqmsYLGL+EZiL6VQM21ijpVIJMUooZV7fCnBe0
	RyoqsTa/DoIwkvCQO6YM0F9aLqu1Ncw=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5033b64256dso258721cf.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 22:00:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770962415; cv=none;
        d=google.com; s=arc-20240605;
        b=aiYD3wJDqqomqkU+RYRIeox+NNc70yVpmV4J7mWBwRtikKrRFSrM+dXkTm6Dpa1D+U
         CegQg6lVWbDn2G2k6i8ip7sFZe94SArcWBMAklX6H75c6X0po5Km6+VK7pweDTsxLzFi
         p+LcE6WbHuC4tEmoL3tX+ndqe0cSgVqzLWk11CezHE4eFq25maPuE/nFpOl4xF+S0zhA
         JNSmKaYEogDuY/Ssybdobiy1kSeiEtZWxKC0P7pXqIDcMe82l4zjiHW5l0YEdIgj7OYf
         Jim3rAGNt8DExQ3ogXV+1bFPmJRvOPMv/zCLLICWjx9gthqY3YtN5t8EZNF2dfpa4fsN
         52Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=geyAiFe6CRp+TmFBVbanEC0GJjERyNXe0YNZiczyJ5M=;
        fh=NXnL03r+SxDZmoa0OirXhcaRjV5/Zg+xhW2u/sVB0lg=;
        b=lRp6JPUrVFThVqUJQVDKQT31w2WINDop3M/blEE4rmKfqCQkv7b+fhLlMJmUqNHoXb
         XUtWSQ83TdZOVBKgNxgX2JYNoF4OSuM7AQCmvoYKJ+RlF9CMcdCM6UN/9AWNrq94TL+f
         Jltvl9MSIlnbCESxZoLU0+6vM/Dt1iI+vILEhXTXvHLMZ8O9+xcWcEU1fXTp/5bG5RgB
         diNAPDcY0SZYPqrq/Fwie2lO88qqf66NcmtZLsXXq9c4e5gmIe0IC7J5pk1I7tW9sarx
         MOxjgNh5DR9cQLBK6aPSaNWXF+9VXa76vMURGH2SiQM+503V7mxGcj1CEjtI8surWGEm
         BxLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770962415; x=1771567215; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=geyAiFe6CRp+TmFBVbanEC0GJjERyNXe0YNZiczyJ5M=;
        b=ncDihiuXA0m1g8l+4pPe563tVw6KYNQxmq9Zga4Tj6hFatEwI2m8kAOcbxcJ4kEDVH
         bdVL35Qmg4IiSdCm+HOsOBfOgq8Vw3vxW+QWTq6inIZXJfmrXSc9kPMpQoZ3tLEGO8nm
         O5Uqbl735XKtZKm+HAtDKsga3G3rrKvFQ9vYU02MUGikcDcgHfe3g9Qpl7PwEp+o6EHx
         jSI3j4HUkczm3JmCdkbC5AVIlqgFxJh6b697PzWgUsYyPZMWz3wIfyVAZcdqhXUgphrs
         WbI+8A4JofGYU8pylAWtFYPThYgYSthk7brfjpM9EAwM0xOPPf471k++Tv5ybTBrrd45
         JdWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770962415; x=1771567215;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=geyAiFe6CRp+TmFBVbanEC0GJjERyNXe0YNZiczyJ5M=;
        b=Vwk+07O7SKtx8xOWuM6QLeDC8sKdOFhMyjMmDNBdqW5Ht84sWssRKuvRyQbr0583LW
         ci7IiYU3mvfrB8f7mulwP1b6w12k0xRT6yN2BRZayzokewqa6r65MnO0VD5QTX4rU8Uu
         VXfBQGW1bUh+3HOXPoZQWfgNOY/rMqymVS/KssvOI8keOwJBCjXCzEHwotIx7m9TBmAm
         RvngJHOLsGRfu6kSd0UySim4SD6b0Pk0L2kQdF0hag6AoQh/LDPBf5LIbOIyGACMvmEt
         or1oGI1ONV2DtwBtU7kglSsChayZKnJXl1UmJ1rppA3FXBq0o4qOflez2lacsr4f8524
         FGCg==
X-Forwarded-Encrypted: i=1; AJvYcCXzu41Dl+p1KOwg0ZMwiK/48BBEzYNakW5eO26nVAw1jeuSNchuFd7EKPn84Me92eesmsRQiqyRrw==@kvack.org
X-Gm-Message-State: AOJu0YyULbV3IcByF6OYchowgaVqh1KfsRQgZvj7LJE0y8i4FDMAeT9r
	JUN6DfoAI2rrxZ2j5BNwt/UD4xeMfHl1KdM/eIdSW3K4BeTrtcq/XZyRBD9gpKHVZ0cx7O+D73S
	HSv009bB60X4zVtVmDyezlwpdZHxtppBjkO3mFQOM
X-Gm-Gg: AZuq6aKlp1ehqov1NN7CwVCirnCgZxSj8ZMBku+THdIDeJALTDLyAEEOiZqgtK3Wq1M
	auoxnJcMpcviRDb9y5LpZ0tqt/0zL+rDyGfvQQtgDLkazQ1O4+gwb3XY5+Pj5mvdbmUOGJ2suuR
	vIFv972cfU1Ew9ulr6VHg/M+Y7LSPPBr20bEiLlh4YRh8GgyKrAEzaICeutPB3oQmxDUQrB/J2q
	jBVGDIqHUrVBOQpZ48w0cuhVb87NcE0e+7l+qXvd2yMwO5hrI/8NJ9mgoGV81H6sKOcH6/sUcHN
	avyaTDaMkIs6/PS7k6xLws+BR/S3jR3Juzg=
X-Received: by 2002:ac8:5789:0:b0:4f1:a61a:1e8 with SMTP id
 d75a77b69052e-506a84d057fmr3597231cf.10.1770962414846; Thu, 12 Feb 2026
 22:00:14 -0800 (PST)
MIME-Version: 1.0
References: <698e287a.a70a0220.2c38d7.009f.GAE@google.com> <muuhcv22gzsr2a3g4lsu4zqsjkdbjqxn7bszh7r4nuqgq2oc5a@7jqpwr6v2vez>
 <CAJuCfpFkHnmX_40RdjnWmicB46Miry6Bc6Lht2rfno0jopraUQ@mail.gmail.com> <6pj7qr6p2wcg5pbigqzbxikpyxw32zqaysepdzhggbvrd3rf3o@5nu3sf6wz6uf>
In-Reply-To: <6pj7qr6p2wcg5pbigqzbxikpyxw32zqaysepdzhggbvrd3rf3o@5nu3sf6wz6uf>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 13 Feb 2026 06:00:03 +0000
X-Gm-Features: AZwV_QidTMR1LqdcoSutPfz7eCqGzwmNWtNZ056roLKaWpUEg3Z9UOz_SWNbsMk
Message-ID: <CAJuCfpEo-Lj1fetH5GtRX0q_jPP0c_VFgWgNBH3=pJ8Sza-8-Q@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in mas_walk
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: wecq4ms81xzdxz91huassy67ar9mjap1
X-Rspamd-Queue-Id: 5C22E80009
X-Rspam-User: 
X-HE-Tag: 1770962416-113016
X-HE-Meta: U2FsdGVkX18h3aBurzyE3NwUSK2c7qEm09nN8OzLNO66UUCQnYD+ZxU1P8a5eIsU727fj7m9QYLRsdSU8WQbJbdIFxpmVO6qhXFdSQhi2+WsiNDSJuCmT2dUz2yUie2WrjkS03i5QOzoFz0UWQyKaPm6PxyOXPfMVXB3Lf2ugfbCU6O4r8peNfv8YFHVnHGIe3yTDM2WmymoEsqMkD+NRPRKxyMbK9tU6VO6vfH/qB2bCkZ4nPEMZTC+PEqzAlA5JgQPwIx+MNL9Lg01aCm25XEvhklO0vGBUBo4vKsJ0Xo0zw+1VurQPWLr8o5FBbxYkg8kGUSU7AwCRm+MyqL1TC/I2wn4owq22AgWdlew5ILb+Xo3FhbKrlnjUmlPfEs/iY5/Mz9o/1yFhgoNFmEfpM0prFktMvB4mz/PwIVa5B742mHh/+OZc+NDmfpA+xSEL3deUbn8el7b5VMJSqCXuh8SUxyRM+pi1ctHXt9mS18a2QgzyEhDI6XPaxSlvaVzmNHC4yLAAthtc0COzANwM9N7uQ5zq0KXfp+ccNGEsleTooJZXhBAtPw24iy4T5RSP/Ebw4CWswQWlmd80gfjQJNO6SM+1ZIC6nrDEd1klEd4HxpzgkROLQ31T1yX4Ca5LM4KIjMArawil31dZXTSsJBrWAbQIozeZ57yyYV/yKn2rvS3OfvcKcKzs6MGKvhFHn9DLpfHpeSJFRdlYxpog0GK3JE+YNzwZTHH3wK6uszuk1EaA/eCD83IIMbre+ZGBjTGl7pM1np1uTuIFe2l+f5kPYt6wmPBsSRhQ3DGV6iMbNQnuWz+dSqWjnwcx8vCOtD5sdRkc/HPi4HlSwnuzY8PK8k2jbB3q6TFVq2VPH7Sfn84jb7pNP0YDd6KASJlzEXMgKBS+hwoDl1X56FjRypDgPUuG38ULxb/0pDV/4mQ3tLDHxUzMdV1kHlsV3PUfBxpdOZ3uvtQVOco8b9
 cugEf8c+
 q8BhY7PTxxXhkQeoF65AcDwRzYcERO1djptQ1EJWc2Yjz/ij77bf+aI4RvztcCo82BBTKyKoJuzdT6zUmnJ3YaBmfrvMaAKBsHmp5IqE6Krp7SnLSDmnQG3KeX+9kExAssuZ930izOuQK+kiucDmWAdFHKQjUIcmrdWZIndtk8+QEBRZpZjUALYqJVKfZY14JwKdm3AoCjE/ll7GU09okqIGRzLMj5RSaYpRO6mYoyb8VjUWGM3G40e59rKbIjdQvQeLac1UFwKcifY8b4RTgjFxuvg/vvxeydJywgVQWUmAE9GBlp5zwraqikQH214qkoB4GclpeGW6JZHFecukoRAyBRo7o3YymAAc+Kq0xY6GCHjTR6tV+qf3nPP28u4j9rbuakcQdlxgfEac3M5iALbHkFyupr4CoLVzVHD9RZdhOmKzVrP+SqJ83uvzIuHE4j/YxBJLExn+e3Vn8dE6i+NBtQqPqdLjdUq+t05OWaB4k6CFSiXpYWfIatTHXQ8lrbQxwDRsN6hqB/OWkHsL/bON386DAOtEILw02V7ZwvqVikCpfqsAqKx17iM31hqpwzURn8KEHRdJdP7IGvBXTAe4jRp8+fLvTN3TNLbSzptjK7ZBNGyPspkNTue7tWV/aeLmVGrqe0Ek6fHbVx9x1TXQf2cGnB5sqwaLq7Qbwe0p89rGh9dvrAYA8q+eZXO+ihCnBx44ENmocowV68TZ8YS6ueSYD5I/SkXrXwhWMHs1mrqPg0qU2Xg3av+tDqhgRAsDkKb52Fl+L3y7R4sI+o3K8kIOmCJt8dRuVXdUFwgMsxneseQ56P5QrGkUSlafCsORwOJBAjCr1BvIBFbAvxW8F/vJjQgt+C7qJaCmnO/cXp47T3cdPYEmAgi0Z6Jfm5hn63uSEKJhNPfHwYojke0ZHzrmfemWjl4X14B9eWKSkP1lHOyWTgJT1iJZm7Rnc7hS3Q9g9fY2SB+Poq9JmAze+yQo+
 tYDRXF5c
 mU5sfsCKNVCOoxq9h8L6RQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 2:53=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [260212 16:31]:
> > On Thu, Feb 12, 2026 at 12:56=E2=80=AFPM Liam R. Howlett
> > <Liam.Howlett@oracle.com> wrote:
> > >
> > > * syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com> [260=
212 14:22]:
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    192c0159402e Merge tag 'powerpc-7.0-1' of git://git=
.kernel..
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1304cc0=
2580000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Daaa1d65=
5bee4457b
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D54245a237=
762e7cbecf0
> > > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils=
 for Debian) 2.44
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13d40=
ffa580000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1704cc0=
2580000
> > > >
> > > > Downloadable assets:
> > > > disk image: https://storage.googleapis.com/syzbot-assets/a421507183=
71/disk-192c0159.raw.xz
> > > > vmlinux: https://storage.googleapis.com/syzbot-assets/4cda72c184d0/=
vmlinux-192c0159.xz
> > > > kernel image: https://storage.googleapis.com/syzbot-assets/404b09fd=
74ca/bzImage-192c0159.xz
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to th=
e commit:
> > > > Reported-by: syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com
> > >
> > > This looks like the mm is not reference counted correctly.
> > >
> > > The maple tree has been destroyed via exit_mmap() while
> > > do_user_addr_fault() is executing.
> > >
> > > >
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > BUG: KASAN: slab-use-after-free in ma_dead_node lib/maple_tree.c:57=
2 [inline]
> > > > BUG: KASAN: slab-use-after-free in mte_dead_node lib/maple_tree.c:5=
87 [inline]
> > > > BUG: KASAN: slab-use-after-free in mas_start lib/maple_tree.c:1207 =
[inline]
> > >
> > > This shows it is the root node that is incorrect (which is stored in =
the
> > > mm_struct directly).
> > >
> > > > BUG: KASAN: slab-use-after-free in mas_state_walk lib/maple_tree.c:=
3291 [inline]
> > > > BUG: KASAN: slab-use-after-free in mas_walk+0x8cf/0x9b0 lib/maple_t=
ree.c:4599
> > > > Read of size 8 at addr ffff888078907400 by task syz.0.18/6008
> > > >
> > > > CPU: 0 UID: 0 PID: 6008 Comm: syz.0.18 Not tainted syzkaller #0 PRE=
EMPT(full)
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 01/24/2026
> > > > Call Trace:
> > > >  <TASK>
> > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> > > >  print_address_description mm/kasan/report.c:378 [inline]
> > > >  print_report+0x156/0x4c9 mm/kasan/report.c:482
> > > >  kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
> > > >  ma_dead_node lib/maple_tree.c:572 [inline]
> > > >  mte_dead_node lib/maple_tree.c:587 [inline]
> > > >  mas_start lib/maple_tree.c:1207 [inline]
> > > >  mas_state_walk lib/maple_tree.c:3291 [inline]
> > > >  mas_walk+0x8cf/0x9b0 lib/maple_tree.c:4599
> > > >  lock_vma_under_rcu+0x101/0x5a0 mm/mmap_lock.c:253
> > > >  do_user_addr_fault+0x41f/0x12f0 arch/x86/mm/fault.c:1325
> > >
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >
> > > >  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
> > > >  exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
> > > >  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> > > > RIP: 0033:0x342000
> > > > Code: Unable to access opcode bytes at 0x341fd6.
> > > > RSP: 002b:000000000000000e EFLAGS: 00010246
> > > > RAX: 0000000000000000 RBX: 00007ff2e4816090 RCX: 00007ff2e459bf79
> > > > RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0002000020003b4a
> > > > RBP: 00007ff2e46327e0 R08: 0000000000000103 R09: 0000000000000000
> > > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > > R13: 00007ff2e4816128 R14: 00007ff2e4816090 R15: 00007ffc4f622688
> > > >  </TASK>
> > > >
> > > > Allocated by task 5934:
> > > >  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
> > > >  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
> > > >  unpoison_slab_object mm/kasan/common.c:340 [inline]
> > > >  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:366
> > > >  kasan_slab_alloc include/linux/kasan.h:253 [inline]
> > > >  slab_post_alloc_hook mm/slub.c:4953 [inline]
> > > >  slab_alloc_node mm/slub.c:5263 [inline]
> > > >  kmem_cache_alloc_noprof+0x2ad/0x780 mm/slub.c:5270
> > > >  mt_alloc_one lib/maple_tree.c:174 [inline]
> > > >  mas_dup_build lib/maple_tree.c:6299 [inline]
> > > >  __mt_dup+0x5a8/0xc20 lib/maple_tree.c:6382
> > > >  dup_mmap+0x36d/0x1e20 mm/mmap.c:1744
> > > >  dup_mm kernel/fork.c:1530 [inline]
> > > >  copy_mm kernel/fork.c:1582 [inline]
> > > >  copy_process+0x7371/0x79b0 kernel/fork.c:2223
> > > >  kernel_clone+0xfc/0x930 kernel/fork.c:2654
> > > >  __do_sys_clone+0xd9/0x120 kernel/fork.c:2795
> > > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > >  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
> > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > >
> > > > Freed by task 6003:
> > > >  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
> > > >  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
> > > >  kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
> > > >  poison_slab_object mm/kasan/common.c:253 [inline]
> > > >  __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
> > > >  kasan_slab_free include/linux/kasan.h:235 [inline]
> > > >  slab_free_hook mm/slub.c:2540 [inline]
> > > >  slab_free mm/slub.c:6674 [inline]
> > > >  kfree+0x1c7/0x690 mm/slub.c:6886
> > > >  mt_destroy_walk+0xc0a/0xfa0 lib/maple_tree.c:5028
> > > >  mte_destroy_walk lib/maple_tree.c:5049 [inline]
> > > >  mte_destroy_walk lib/maple_tree.c:5040 [inline]
> > > >  __mt_destroy+0x2d7/0x390 lib/maple_tree.c:6446
> > >
> > > __mt_destroy() is called with rcu disabled because the last mm_struct
> > > user should be gone.
> > >
> > > exit_mmap() is only called when there are no mm users left, and then =
the
> > > mm is write locked before removing the rcu protection on the tree.
> > >
> > > It appears that somehow the fault has the mm without holding a refere=
nce
> > > to it.
> >
> > I tried reproducing on my qemu with the same head commit, config and
> > using C reproducer and it did not reproduce. I think the only
> > difference I have is the GCC version I used. Mine is gcc (Debian
> > 15.2.0-3) 15.2.0.
> >
>
> I get futex issues before I see this issue - but it could be related.
>
> I was planning to add some debug tomorrow to see if I could figure it
> out.

Thanks Hillf!
Makes sense. The reproduced does use PROCMAP_QUERY. The fix
https://lore.kernel.org/all/20260212234050.03FC6C19421@smtp.kernel.org/
did not reach Linus' tree yet.

>
> > >
> > >
> > > >  exit_mmap+0x5d3/0xae0 mm/mmap.c:1312
> > > >  __mmput+0x12a/0x410 kernel/fork.c:1174
> > > >  mmput+0x67/0x80 kernel/fork.c:1197
> > > >  exit_mm kernel/exit.c:581 [inline]
> > > >  do_exit+0x78a/0x2a30 kernel/exit.c:959
> > > >  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
> > > >  __do_sys_exit_group kernel/exit.c:1123 [inline]
> > > >  __se_sys_exit_group kernel/exit.c:1121 [inline]
> > > >  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
> > > >  x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls=
_64.h:232
> > > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > >  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
> > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > >
> > >
> > >

