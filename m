Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD82CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DEF98E000E; Tue, 16 Sep 2025 18:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78F788E0001; Tue, 16 Sep 2025 18:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A55B8E000E; Tue, 16 Sep 2025 18:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54A9D8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:05:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16CC8C0336
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:05:27 +0000 (UTC)
X-FDA: 83896495494.11.F872FCA
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 23F874000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:05:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Mw9n7g3O;
	spf=pass (imf12.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758060325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCuFWaEaTyxMpEbKjJErTv/bKVugd63JivVHXq58spM=;
	b=rdLnyBJTUU0bm0gZGRqEoN2a9G3CJhSF7lBjK+1M8Fti9L3RortbJliTmF1PyapMSiwI4o
	2tsVrLl7x771nCIt0POdfUudB1AX3N4AIj5a6DsVGFBApRSzhP8lrHMrCJvt/7htGrspCO
	oO4Cmpoaxe2j2dzefbsDUE8wICaCo1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758060325; a=rsa-sha256;
	cv=none;
	b=3qo33ZmPwmNmyv4NNKxQbUXYcMwqsA5Emv2RYc6h73Wq7r6dxiJsAqxj9lD4t4y1N+CG92
	bdR5GaMrNxAx/UIoOGNjNJgAJj0IoCSpUKjj7ND8Imzbv/ZI0xiS1UR98n5eSCNZNmTZse
	OMs3UyIX+nYGr/0cYc6SOps5nMb6eXQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Mw9n7g3O;
	spf=pass (imf12.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-265f460ae7bso61245ad.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758060324; x=1758665124; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BCuFWaEaTyxMpEbKjJErTv/bKVugd63JivVHXq58spM=;
        b=Mw9n7g3OnQVm7RJEESRrfwOkOc72Qm2mT7VlImi6B3uq7K6yUhUCvJAdAw897uxdvS
         A/Mc8EE+6vzh1RaFRPfdNl2jo5m7gFFhZndnQb8QPZr3m7qqIa4XGsMwJ+D2rVd9uy3s
         zH9WcRp7GmGrciGMTR2HoqwTvaxivPulv4qdhggXDmyNt0pP2fmvyGxty4r85U0pyTR1
         ZuAdimvioeLFcXkpht0jDSU7BrAhc6wQ33qt8umW3jFSzp0T5jLlMHuHyqz6SuaP9SwQ
         HZjYdMJAblr+PLgTTQJzWt+BoSFF4+uau8g1tjgk2P6CtLv1tIo0X5hnJW7aHOw6G7bb
         8vMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758060324; x=1758665124;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BCuFWaEaTyxMpEbKjJErTv/bKVugd63JivVHXq58spM=;
        b=iBg4dqR0d//DGgoNC8Hb1Y90pNry7cmqmWiIlpjkLmJBx1/OUrY+4MA1VSio1PI1lZ
         ytCJZIaJVV7FZniTg+0goS5nxJUumL42s/VLOyCSY8EIjv1d443ON0IZBrqBln+2Rhb1
         9+ZUcp42/9syo6dhMW02UMUwDnsk1R3zLyVjgcEkPsjoTZs0p0twmSsguyat2VCxvfNG
         fvGptxJ7jPpNUweZXvG9v1WgKv5cUJcEr7qWxLmQtQrDReEBmcJO/DcPKuWaIOUaM47F
         PlRxbhBlAdiG3/A5kytZH1cRb0S89+67MyY0FkjFEXqe2IkbL32MLpgmgTTAgZSzXZYp
         8Dow==
X-Forwarded-Encrypted: i=1; AJvYcCVB8rbSz6UXN6DprQczTJZWpkuWlOlnhw+BxWGp/pM+9rj+cv+FdbelHsS0NkOp59EZLc+LfjG9LQ==@kvack.org
X-Gm-Message-State: AOJu0YyU5ceCoytjaAB5jHn0KDNbwJ9zkITEP2c8zMwRGjNGRsxcJSiw
	b1/Ml3pYEg/xZqbRwZMBfmuA6VJyBcjiSkzQE5f4ARfeI32nD0y69yNuGEPhBWf4zYfqag7HLwW
	/TxL80FQfpkXOT/8h6st6rtH07gUqdVlv1EOJOMeC
X-Gm-Gg: ASbGnctdHgDcbePEKs8DG9e599RnD/jkAsNeZwymvTe34Wj4kNXqJyGc5x29OwphrwT
	GGHhqzoHspZqhpvhk0sLA9BkRhHuABIokloyXTbnYzCFWUPDxq1QvDEgJVMe2RTk7mRp/gcIc4C
	wHqLp2Yfk36G3EVYxYFinW0qpIqow0JQqfant0qkT7E4MZU/HEwcSNtRC0Im2F2wkH7u3eo5sgB
	QXuZJiuzXKB
X-Google-Smtp-Source: AGHT+IGFiMJtBRQK2I//m/TyMNOu4cM1WyKbQ2mAFWYqL/mgUtJzL6Fob0E1REoA7pUjyKDeoqAY+qgQbLGfaXMGxqQ=
X-Received: by 2002:a17:902:e751:b0:231:f6bc:5c84 with SMTP id
 d9443c01a7336-26800f6615emr1702695ad.8.1758060323741; Tue, 16 Sep 2025
 15:05:23 -0700 (PDT)
MIME-Version: 1.0
References: <1757967196.153116687@apps.rackspace.com> <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com> <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com>
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com>
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com> <CADrL8HWS7h0e0AcjbE0npoVwqvWK6c_aqML4T+MJnTkCz5AcNg@mail.gmail.com>
In-Reply-To: <CADrL8HWS7h0e0AcjbE0npoVwqvWK6c_aqML4T+MJnTkCz5AcNg@mail.gmail.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Tue, 16 Sep 2025 15:04:46 -0700
X-Gm-Features: AS18NWDXI2C6q8nIt_zxBo99cKkGqDVr8mFyFyREWHC7_I8sz_OGbf9wlbmGOGw
Message-ID: <CAJHvVcjznC9KdMDMLPCP7W5Aq_u3GobPVZQoUF=wrhUN3OL9VQ@mail.gmail.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range fails
To: James Houghton <jthoughton@google.com>
Cc: "David P. Reed" <dpreed@deepplum.com>, Peter Xu <peterx@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="00000000000017cede063ef2518e"
X-Stat-Signature: asbnddsc94goi9auqaejebyfdtk5jsuy
X-Rspam-User: 
X-Rspamd-Queue-Id: 23F874000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758060324-932450
X-HE-Meta: U2FsdGVkX18XBD+3RoNeXAg4RSs+CNgaeoIR7Dw+ce53kxPCXH4+CDG6P12cubuWUeuvfOI+7+wx7Csee7uHcE5h0VmsQ3XtvFjBaAe+/tXq0iJWTqf2ZxLi567R2jrNHHpbxiPjDjsXVYnCjM4I+YRqNJNgBRscua/DQyiSG6QIkF95w8zVXxDazM1Gld2WwMLFs5Vm/KXqGPOQZm7hI+rxZzcnQ3dJLbSaxOPiB/++SSKZsYGyGoKHVxiMj+RaMzsdf2y62jktR4YyZ/0t08uuz0p49sPtazo2ZW2ufq9r7tjrJFW2tQu0wAT9rvDYMY32bbOwBjs8/02C+dRFrxH85YosEIot04/VoHE1r7lrjizoiJXWbHxm8Hwys/LU03froCWuWPdJkzSGvYq+XXjVMZIVo+FvIlrCClFf0Ji2ObPfysRwzXiiVUSTVOszMWLYeuifZkaOhMEqz3tkKfZ2kUheN1CBKBs/K0GN6xcDK8AQficKSV3WGDt9fPuvNVHPK6guqPFFm82XrG6HeI4YXHFYzewkqelqDXoyQWhhHp1eYh+2nu7d3bS8g5w0mQqkwRDVW4BZ/SuYpiChaVKJ/wFq4S2BjiYfTsOGxwyCJ+JDRHjVGtcU59rtad/snkKDxqHn6zrPxtA5NO951OeZBRtVXgDK/d6hwtnI2NpU3F0cAGVD4cixapas3RMOEFvOkXpnhMVVPbC23AfNa4+XKk8UzrOrHQBKnTBPmWzieCxeUxfZy+N2oGzljft9yoBEs8Y2NxDbHiYnFi5MUDzDqOSfJy3Wl3OWuILThhE+PwJcacfcRyfjIrY8NR8A9qmUfEL/lv9IvHsz4zM/ttHCbkacqmb/61Hv/KPu/UHyyKe/nX0IE5WNDhmzzmwCi11Hm0WiZnXc2XJAe6eZq0dnGrIPD0Z2E919UYyLBhxuVVq4b76kFr8EPSpIqQ8mslkUdlwg4lHJjGp8SzC
 V8iw9Q9R
 bIMKmYilP+iGa9UGov2PR3UxHbOUghPRQg7IsEBVeEaXbZWnWlLeWLCePlmMR2lrQldZJKv1GspCqdEM0vG/NQVSUH5k5CW8YZAc0Kt4pqKrLsG0ilWKl1lQgS2jpyXpF4QYGAWpv0cqNQJYhGHPkDUU3UbwqJY9BN4ARbZWpqN2nH628UW8apzrfurwSTz/4gow3D0PzbXbhHQgd6g/Pre+toISaWMdj3F+2YF0LVpb8KroDJ63lRsA72KUzpBu8OL9wVCjsnPFZpey+7UM3GB3UbtNb0/KOBzrfNI8LS6d0P5N4PpOWmk5NLc0ZwNY3OoROndU2wKQv4V8Hqgy+JycUN45wXfaI5pH0y3GkBhgB35ZNdkAT+p7DYnNI8hOAuwv17ISSQ7iZi/UJWhxypltMB3m2lqOLLG85gSSIsJTkdW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000121, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000017cede063ef2518e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 12:11=E2=80=AFPM James Houghton <jthoughton@google.=
com>
wrote:

> On Tue, Sep 16, 2025 at 11:35=E2=80=AFAM Axel Rasmussen
> <axelrasmussen@google.com> wrote:
> >
> >
> >
> > On Tue, Sep 16, 2025 at 10:27=E2=80=AFAM David P. Reed <dpreed@deepplum=
.com>
> wrote:
> >>
> >> Than -
> >>
> >> Just to clarify -
> >> Looking at the man page for UFFDIO_API, there are two "feature bits"
> that indicate cases where "minor" handling is now supported, and can be
> enabled.
> >> UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM
> >> In my reading of the documents, these seem to imply that before they
> were added as new features, that MAP_PRIVATE|MAP_ANONYMOUS mappings were
> supported, and that the "new" additions to the MINOR mode were just for
> HUGETLBFS and MAP_SHARED cases.
> >
> >
> > Actually minor fault support didn't exist at all before those two
> features were added. :)
> >
> > You are right that userfaultfd's use of "minor fault" is (unfortunately=
)
> slightly different from the meaning in other contexts. I think the more
> normal meaning is, faults which do not incur I/O (i.e., swap faults and
> file faults [i.e., faults on non-swap-backed pages] are major, other faul=
ts
> are minor).
> >
> > For userfaultfd, a minor fault is a fault where the page already exists
> in the page cache, but the page table entry wasn't setup. I don't think
> that scenario can ever happen for anonymous, private mappings, so it
> doesn't really make sense to be able to register such mappings in this
> mode. If you create a mapping with mmap(MAP_ANON|MAP_PRIVATE) and then
> access it (read or write), that fault requires allocation of a new page, =
so
> userfaultfd does not consider that a "minor fault". My recollection thoug=
h
> is if you make a file on tmpfs or hugetlbfs, fallocate() it or whatever,
> and you MAP_PRIVATE that file, *that* registration will work.
>
> Ah! You're right... MAP_PRIVATE *is* supported (for tmpfs and
> hugetlbfs only), and UFFDIO_CONTINUE will, upon finding the page in
> the page cache, install a RO PTE for it.
>

Why does it have to be RO? I think it depends on the PROT_ flag you
specified when you created the private mapping.


>
> But what happens when the write comes after installing the RO PTE? My
> reading of the code today makes me think that we'd get a minor
> userfault and then be unable to continue...! (The only reasonable
> behavior is that CoW is done without triggering a userfault... I
> assumed/thought this was the behavior today. I wish I had time to test
> this -- I hope I'm misreading it.)
>

It's possible my memory is wrong, but I don't think UFFD minor fault
handling really interacts with CoW faults. IOW, I think you get a UFFD
minor fault when the PTE is missing, not when it's RO resulting in CoW. I
think there we just CoW the page as per normal and no fault is reported via
UFFD?


>
> :( Here I was thinking I understood how userfaultfd minor faults worked.
>

--00000000000017cede063ef2518e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Sep 16,=
 2025 at 12:11=E2=80=AFPM James Houghton &lt;<a href=3D"mailto:jthoughton@g=
oogle.com">jthoughton@google.com</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">On Tue, Sep 16, 2025 at 11:35=E2=80=AFAM A=
xel Rasmussen<br>
&lt;<a href=3D"mailto:axelrasmussen@google.com" target=3D"_blank">axelrasmu=
ssen@google.com</a>&gt; wrote:<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On Tue, Sep 16, 2025 at 10:27=E2=80=AFAM David P. Reed &lt;<a href=3D"=
mailto:dpreed@deepplum.com" target=3D"_blank">dpreed@deepplum.com</a>&gt; w=
rote:<br>
&gt;&gt;<br>
&gt;&gt; Than -<br>
&gt;&gt;<br>
&gt;&gt; Just to clarify -<br>
&gt;&gt; Looking at the man page for UFFDIO_API, there are two &quot;featur=
e bits&quot; that indicate cases where &quot;minor&quot; handling is now su=
pported, and can be enabled.<br>
&gt;&gt; UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM<br>
&gt;&gt; In my reading of the documents, these seem to imply that before th=
ey were added as new features, that MAP_PRIVATE|MAP_ANONYMOUS mappings were=
 supported, and that the &quot;new&quot; additions to the MINOR mode were j=
ust for HUGETLBFS and MAP_SHARED cases.<br>
&gt;<br>
&gt;<br>
&gt; Actually minor fault support didn&#39;t exist at all before those two =
features were added. :)<br>
&gt;<br>
&gt; You are right that userfaultfd&#39;s use of &quot;minor fault&quot; is=
 (unfortunately) slightly different from the meaning in other contexts. I t=
hink the more normal meaning is, faults which do not incur I/O (i.e., swap =
faults and file faults [i.e., faults on non-swap-backed pages] are major, o=
ther faults are minor).<br>
&gt;<br>
&gt; For userfaultfd, a minor fault is a fault where the page already exist=
s in the page cache, but the page table entry wasn&#39;t setup. I don&#39;t=
 think that scenario can ever happen for anonymous, private mappings, so it=
 doesn&#39;t really make sense to be able to register such mappings in this=
 mode. If you create a mapping with mmap(MAP_ANON|MAP_PRIVATE) and then acc=
ess it (read or write), that fault requires allocation of a new page, so us=
erfaultfd does not consider that a &quot;minor fault&quot;. My recollection=
 though is if you make a file on tmpfs or hugetlbfs, fallocate() it or what=
ever, and you MAP_PRIVATE that file, *that* registration will work.<br>
<br>
Ah! You&#39;re right... MAP_PRIVATE *is* supported (for tmpfs and<br>
hugetlbfs only), and UFFDIO_CONTINUE will, upon finding the page in<br>
the page cache, install a RO PTE for it.<br></blockquote><div><br></div><di=
v>Why does it have to be RO? I think it depends on the PROT_ flag you speci=
fied when you created the private mapping.</div><div>=C2=A0</div><blockquot=
e class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px s=
olid rgb(204,204,204);padding-left:1ex">
<br>
But what happens when the write comes after installing the RO PTE? My<br>
reading of the code today makes me think that we&#39;d get a minor<br>
userfault and then be unable to continue...! (The only reasonable<br>
behavior is that CoW is done without triggering a userfault... I<br>
assumed/thought this was the behavior today. I wish I had time to test<br>
this -- I hope I&#39;m misreading it.)<br></blockquote><div><br></div><div>=
It&#39;s possible my memory is wrong, but I don&#39;t think UFFD minor faul=
t handling really interacts with CoW faults. IOW, I think you get a UFFD mi=
nor fault when the PTE is missing, not when it&#39;s RO resulting in CoW. I=
 think there we just CoW the page as per normal and no fault is reported vi=
a UFFD?</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:=
1ex">
<br>
:( Here I was thinking I understood how userfaultfd minor faults worked.<br=
>
</blockquote></div></div>

--00000000000017cede063ef2518e--

