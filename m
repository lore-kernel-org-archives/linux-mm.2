Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DDC606A337
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cy+gu12d
Received: by kanga.kvack.org (Postfix)
	id B4A9F6B00EF; Wed, 18 Nov 2026 12:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB9F6B05B0; Wed, 18 Nov 2026 12:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3706B05B1; Wed, 18 Nov 2026 12:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6583D6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:46:19 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC3DC120821
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:46:18 +0000 (UTC)
X-FDA: 85448968836.18.FDFF242
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id D0CC9120006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:46:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=cy+gu12d;
	spf=pass (imf29.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.41 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795023977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIiWqHkbikiw9/PSo57TK7nq7ydcL7CNJ2g4TYGph1w=;
	b=j8UDXfNXc94b+ij6HR0UpvvPIZbMum/G+O8DXSs79K7FkF/wSysz3G8tTO2HgIfXB7BhfF
	Ev/cyyazXlEB/EIFvJhK+UCx5n+0rCpq7/HFByYtVGIhCdgy6p3z87PNQT47CMArCgGBNA
	Np0e7Aw4bWxsJWqQImZJ0VVRW0kZkks=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795023977;
	b=p1hesrEXLyKtfxz61ufgd4cwt6gKcU3a/yrEISklnDfWlLTCWXDw6JnDGKtZK5IJ+PenMi
	Hv78JnD8xhMiTJ/l6qQlEr0tirISsTMm5YhQWpbTaPhQM1aiYfmdDP+JJOCr680X4/f0kB
	VMkkifc274RLF9kB8ZAT12P/m4SDWJw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=cy+gu12d;
	spf=pass (imf29.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.41 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5c1465bbbdaso1062080e87.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:46:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795023975; cv=none;
        d=google.com; s=arc-20260327;
        b=ofe4ME6hX8A7yMxPgdNT9ZBsatfFiqZFHTvWBalRJT1PoQjzFRX39KwnD8mBAVR+6c
         UBrHFfwVJL/rSXERgAIsIPNRtjzzDsVBsPgJ6MDbEbI977JhI1607hTryxeoCEZvOzXe
         AtEQtWVW70Ud2h0N6ldi/GIhn+f0rZUqVmuZSpZa0X7nUwL7NadvVXdHP8ecEFbMLWQs
         uOQrxorqh1+uZxZqwPI/n/nn5peAK9dJZlSUq91GDAZ3aiSKOB50JAU+9p1F9p2bI4MD
         Az2XPVNp3p0P2QGRTcbTZ0BUfGzvLXU4/L7ZP0zevvoVaMmzHYx4LmiN1bmCiOtqDx/Z
         b0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SIiWqHkbikiw9/PSo57TK7nq7ydcL7CNJ2g4TYGph1w=;
        fh=KMuV9qz3UlEeOZIca8WCRNTkYnOEIiIacSHsnytbWQI=;
        b=VDqg41R/lkEd/rDJ8b1xi6zP2L9kn/mm0GFmrcdWi2htjeVDTQ32HMIeS8Kkzm54zy
         rI4FkV4yOAx7DZ+dUCTiVD0mQFEcMceFSM4uVHe5kW65urwbjRFQCouh6RE+TEpUhmpT
         c+0C1yyamvRMFozCCXhavHwZ9dgoRZykxGEEolsnNJTnTSFTo8DxhDae320coKfsPu4N
         rsGGfOq2QiS+EvvPvn7/PCCqxg5tT0aMZqf9lKQW/Vs77tw/q7ugTNzkR+ZhDuNS7X4/
         rvyktR3rcuzIkY7DLqkF7sze978v8gQSMcy0KY4YO6vq1PfEWJgU/mfb/5E8NY04BUa7
         x2VQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795023975; x=1795628775; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SIiWqHkbikiw9/PSo57TK7nq7ydcL7CNJ2g4TYGph1w=;
        b=cy+gu12dXOsrM4yskTXK9zp/k9zKaAiyWBYBFe0bDSqq9RYvz7WuFANp9LR0dgmfn/
         xrwVjm6EX6XtHtMfK5ePRGXDLQLJyxOhy0I8/gDeQO9nnblhHeyMePm7y8guRIQ9Qrnc
         8sclTFQLOexYiUO+93g8nDhwj47lV7ZY878WLiDDFvQhjCkjCWf7+FTVral9FcfAL+hl
         WC+ib4V2mV3o0mRynkrZs+SfgGtT6pcW5d9cNb9rta0zAYq0J6JGe+dPbRxWrmoVOkxu
         WGF+VE2G+W1fSC2+0aZd1fdJEO1jHTXxjS2Mckfc26nC7cP+o4vI+oa3Rq+txWVZptaU
         Zh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795023975; x=1795628775;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SIiWqHkbikiw9/PSo57TK7nq7ydcL7CNJ2g4TYGph1w=;
        b=EbID9Lw8xvobizdDLfIVJRZdbRdgMwTxfUGANyKc5Vh39J9ca4VVN/WcJEZNZTN761
         tNDNtB0bqdLgPoZb9REnbhFHxzyOUBOOEQBfrrYYl1V3U4pmNt38y/YNugmJiSV/GArT
         Du/cvR7ZXsG9vrpitWcs67QHPdS5YWVBluLUiQ5Knt3/cF9iaFwLpAD3iXCMxQt1kObe
         Q1h9wK84u6WTrEQd7RCiC0hKC/FbZFBrr5/do2PuGce5RZJ7Xgy9Nuc5liB5g80sXsuO
         CG+sr5pfmMB8uZiSpIddJoaVf223MaUiMEu9pGt2ZG/aonEkZ3ZV7WAMH6Xd/Hu8rog4
         7/UQ==
X-Forwarded-Encrypted: i=1; AL+hErEbjaamw5lQLT+oirMLZbvaI4at8msTOvqmNr4YFhaOish2LH7mLxaEzP2s4QC4BQOAI5utRpGHbw==@kvack.org
X-Gm-Message-State: APuU4Z+VGAPbUrP7CqCvGjd51iapbw2xNuVfK2Ab/VE0KLv12nIUpPEA
	5Bd1BamJ9ocfSbTtBSW5JXo1B0lQfigB+3Qxeb2o5eK3+8FN1FbRH5Wfsu1TeCvf00nIGtws7ex
	fM1JIoPerfVUZT54KY1Y457JLcwFBC+IogR/d6axW
X-Gm-Gg: AYBFou34d3Lknq/ZYAGgvqPDj6j8gTW/sa2qw71JKnxz8oik7wMRhNzAitPJz17LZMz
	I/GX0TXJP5cMOUCP6w5267feKZhDSVtwY82ahZAiqK34xAF0WyxCWIAc0vRJsbs+fdGNmhVmgLk
	hWlUdccRj5p4R8uxjlCdzUoKlTWx9LhfsRHxm8ERtbMfMV5i87qo7y+afpur25rFN4Qdn/4WOyk
	rYtbM2AC64S80UWZRXRRqAJ/6Wznl6ki4k/zyLsJGmLW6DU4AUx3vDEvi/f3I0pLQufk5dkt1/L
	JFF8Cm2cdHQUKX2RDyyAXohp6WOmbO2d+AZ8/4sE5Fwva7+JWcn3e2fyUPPL5+xwQJZASq1D5dJ
	YJ/YTcBNl08TB+VFAQwgp0QIulCZ56A0Ncw==
X-Received: by 2002:a05:6512:8346:b0:5c1:ac84:c105 with SMTP id
 2adb3069b0e04-5c1ac84c2a0mr745576e87.57.1795023975125; Wed, 18 Nov 2026
 09:46:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117231352.3816603-1-jarkko@kernel.org> <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org> <av3bkDnwmjunTleX@kernel.org>
In-Reply-To: <av3bkDnwmjunTleX@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Nov 2026 09:46:02 -0800
X-Gm-Features: Aa3M54rqJXQt69c6byOctTWRaXx3nXcFQskBrnHvxsTyM3qw4EOZDCkVbvK6iJk
Message-ID: <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Ben Segall <bsegall@google.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	John Johansen <john.johansen@canonical.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Kees Cook <kees@kernel.org>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Mel Gorman <mgorman@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>, 
	Paul Moore <paul@paul-moore.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Serge Hallyn <sergeh@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kexcs6pixbo9j1i1oxwkkho7t9rqzxec
X-Rspam-User: 
X-Rspamd-Queue-Id: D0CC9120006
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795023976-237396
X-HE-Meta: U2FsdGVkX1+QQm5wEiZxvdw411k8JGoLMj9Rnn4HRmZaJNlQp4AmktjgnfvbdIHBpzNMGljyMc//gkHbZkFfpaBBhLggDy40ciUDjahNqBYFKBr2bKRMjchckpKFOrYo4HeBxf+zBM1e++u+QWTT1c5mHA0/fAYnxRzcXO7qAZvowsdOsbmXkzLLEKuWt3smn6MyDUHtQht0Za0T0SvDOUexgEGqfTugs1IiDi5y8VkXU7+sVj1sljrdQCY3/+l+YGhoL+mvuPRb0mcK0M6Fz1e+55IDLakAW0jsu2O0S8Mnl1I6eJqgHYtCI2vvmQ12YU7DevkFtjKQMeJBC61vcwL88qlBVACc2y9mL4CIc48LhscwtOaOc4fbGMz7UJBc9zqHV6zPAhU1rKQrN6tkv+MNsjbEMSNRpaJ61HU0jXXFa5FNmPfyXEWBWC72tmOPO2wxmJBmNmqWPlZgK6RLKx1QHktjeimDE1gHaaOZC6W6+UdMfAHvWkTPklfVkLoHZWJ1xeFywzrSYASAjhJjVEyoOhyhCqFLrRIAuUGB91Gxe3eD6gMiETZ5QebRVwnl9cfQ6PI3xqnHGWOMTEmAS+HNJfN0MubgLGzNh4sbeVR6K/eABGwdlKCtvjBjK3eKSCa0kF6+tsxxTs6DtU6cWLV7cuY2k8xXzz5SJ4AhzRa21BkwST4ebh8AY6qBO4e8XySsFOZ8ulW8T1ocFWgg7wZ7gPVpSfk5tcaDgHHbG5L7gq2LlrVWrbEx65VQ6AZK82IwRuN5udPN+F8obzdNP34ET1kguZX+wK+Mkh5CAN2qDeZJPsyKIwDp1nKXs2N4mh5cwv279K8I9Fyu3PGZRkUd/kKPdOB8r7v0TEnioRMF7Pl+5dDYIA4p9T0hZoc2eFbAPd3eBbLG6tvj+IF9pCu5YSnHojGwfibXfI3AcFa1Ov4soKPFxvpSWqhAiMSSvY8t6UdEYKKP9jstWFx
 /uHBqnTS
 qa00/swW2ZrgXmBHzPv9DAKbr/V1Q3a+X0zHyqjch2WKweDrXS2ObekmlOlh+UA36Jo6haIFAiIeA9wzyyQR2+oDqvsVg6VrB5TpiFhtD2sMdHouP26zEaKI4a60X23KoKfxmHkCAiCYqqP+7U7Xualpyi5/Va/VeOeAxh+kaArlQ2idDxIxd4ruZE5Jqd6cCHrXUaHiTSHl+Y3gT9ReTOUavJIjSF7cvRULl1qLzA+sETS7FcYVKPVM8fwtD13KRqZFagNByh33hZY6JKrDlr0uslDi4KC1qjFW3rxJJ+Q8mHODEjLUMuxjtBKytuAx2OhilD5FLJbyjj9xDA/JTNmGXWtZX9O1Y2pu9HTzignzFPm0/UaDK8CvMxAxW4IctuS1eLG4KAKHawuAy83N6V8soja9qUM72/ACY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 9:08=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> On Wed, Nov 18, 2026 at 07:04:21PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> > > On Tue, Nov 17, 2026 at 3:14=E2=80=AFPM Jarkko Sakkinen <jarkko@kerne=
l.org> wrote:
> > > >
> > > > OVERVIEW
> > > > =3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > A root namespace (rootns) is a kernel object backed by a file descr=
iptor
> > > > that binds together:
> > > >
> > > > 1. A full or partial set of detached namespaces.
> > > > 2. A dedicated PID namespace for spawning processes into, signaling
> > > >    members, and polling or waiting on PID 1 exit.
> > > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must=
 be
> > > >    populated before going live, without inheriting host mount-tree
> > > >    ancestors.
> > > >
> > > > Work on this feature started in 2025 from David Howells' container =
object
> > > > patch set [1], which I turned into a namespace for namespace roots =
and
> > > > rebuilt around that premise.
> > > >
> > > > While the patch set is manually written, the original motivation ca=
me
> > > > from isolating LLM agents. Running untrusted agent workloads made i=
t
> > > > clear that OCI runtimes need to minimize their live configuration
> > > > surface.
> > > >
> > > > Assembling mounts, credentials, and namespaces inside helper proces=
ses
> > > > with a half-configured container is what I see as the main challeng=
e,
> > > > and the existential debate around namespaces and container objects =
is an
> > > > unfocused discussion topic.
> > >
> > >
> > > I've skimmed some of the series, and I see a bunch of good ideas that
> > > involve using an fd to manage a thing.  But I'm wondering how much of
> > > the value is added by that and how much is added by having a new
> > > *type* of thing: the "rootns".
> > >
> > > How much of the value comes from the rootns vs the new APIs to
> > > configure namespaces without entering them first?
> > >
> > > For that matter, the cells series also seems to contain a (possibly
> > > very similar) variant of the same thing.
> > >
> > > Would it make sense to come up with a patchset that does *just* the
> > > configure-a-namespace-by-fd part?  It seems to me that this should be
> > > an easier thing to agree on, and it's a big part of the complexity of
> > > all of this, and it solves a real problem even without
> > > cells/rootnses/jails/whatever.
> >
> > Is it  more accurately scope the part that is "just the fd-part" and
> > what you consider as "extra cruft"?

I'm not actually trying to say that anything is "extra cruft".  What I
mean is: there seems to be somewhat of a core that is pretty similar
between the two patchsets, and that core seems independently useful.

> >
> > I.e., where do you draw the border?
>
> I'm asking this because I had similar thoughts when I started this back
> in 2025. David had some good ideas but it did more than having a fd
> that does not go live before everything is set up properly.

I don't know that I have a very clear border, but here's an example:

rootns has MOVE_MOUNT_T_ROOTNS_ROOT.

cells has:

+What else goes into the tree is mounted on it before it becomes a
mount namespace.  A
+filesystem for the cell to write to is mapped in the same way:
+
+.. code-block:: c
+
+   fs =3D fsopen("tmpfs", 0);
+   fsconfig(fs, FSCONFIG_SET_STRING, "mode", "1777", 0);
+   fsconfig(fs, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
+   mnt =3D fsmount(fs, 0, MOUNT_ATTR_NOSUID | MOUNT_ATTR_NODEV);
+   mount_setattr(mnt, "", AT_EMPTY_PATH, &attr, sizeof(attr));
+   move_mount(mnt, "", tree, "tmp", MOVE_MOUNT_F_EMPTY_PATH);

(Source: https://lore.kernel.org/all/20261105-b4-cells-v3-2-bc9095937a84@to=
xicpanda.com/)

I feel like you are both *so close* to something that would stand
alone and make perfect sense.  I also feel like, if that's a goal,
then both series are slightly off from the bulls-eye.  (Keep in mind
that I've spend a total of about ten minutes looking at the relevant
parts of the series.)

If I've understood the two series correctly, and if I'm thinking of
these abilities as something that can stand alone, then I see the
following things that I'd improve.

rootns: Why can't I use a *mountns* fd to so the configuration?  Maybe
I'm misunderstanding something.

cells: The dance where I create an anonymous mountns, mount stuff into
it, and then attach it to the cell is cute.  But I think the userns
interaction is wrong: you are making me assemble all the mounts in
*my* userns and then clone the entire tree into a fresh, non-anonymous
mountns bound to the current userns.  And that clone operation is not
free and serves no actual practical purpose.

Why can't there be some variant of these where I can either create an
anonymous mount tree that is genuinely unbound from a userns or that
lives in *the target userns* or that *is already the final mountns*,
using just mount-related APIs?  In pseudocode:

int mountns_control_fd =3D create_mountns(either userns-free or with a
userns_control_fd);
fsopen, move_mount, , open_tree, etc;

Finally:

cells: I find it *incredibly annoying* that one generally cannot put
new mounts into an existing container using most existing container
managers.  I hit this on a surprisingly regular basis.  You seem to be
baking this into the whole cells design.  Why?

both of you: Can we please make it possible to do the parts of this
that oughtn't require privilege without privilege?  If the cap_userns
thing ever lands, cap_userns & CAP_SYS_ADMIN ought to be more than
sufficient to permit creating fresh mounts even without creating a
userns as long as we don't do anything that affects privileges within
our own userns.  Or let us create a userns, *not enter it*, and do all
the mounting without actually having CAP_SYS_ADMIN in the permitted
set.


--=20
Andy Lutomirski
AMA Capital Management, LLC

