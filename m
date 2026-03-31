Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ADC910F92E9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832436B0096; Tue, 31 Mar 2026 14:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2936B0098; Tue, 31 Mar 2026 14:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8E16B0099; Tue, 31 Mar 2026 14:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9356B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:30:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFB2F8B486
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:30:47 +0000 (UTC)
X-FDA: 84607199334.19.D42F542
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8106120004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:30:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KNChGStB;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774981845; a=rsa-sha256;
	cv=pass;
	b=xQXokv65zyvX/mVNM2hm3+tzi26SjfT5p++DMdPhNFy0GrRdtjqyI/2A4oRu5FMbkb5FYZ
	PrpF6D+NQIsHolN1q7vxlNxQBJnFTqD/smEGSbzpsnvoxVWKx9opzc8F0xOSmvpQKQvP+m
	I9bkvL4I6/YhdA1EN6K3n3If2tzbfuw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774981845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzXFZg0mB+5Clpn1iKWeUt/f0+wv1xKbpxQ9jRIC0eI=;
	b=TRBmU/m2JEQI4HrDZq1+gJbgffLrHqxv+2Zw2VQyk/+0grgJMFwkCqORqh36wA5o3t73uU
	NfuxqOU4enqOcrSW55OU5JoWacnfxWhnZfwjC3yHNAo9wLxfdHkX0BatKJxOJPCzk6rA5z
	C+uptY3/ADk5yyz2gpvSSN9EvIyZWNw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KNChGStB;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64eaf8aa893so8282446d50.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:30:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774981845; cv=none;
        d=google.com; s=arc-20240605;
        b=krkUoAP8deWzX52Xhtc7yBP1KAudchIM9jT48dh7niyR6jV3vBzJ17s/1dWplpmR4T
         BZDqdCfsxxd33/yT1MWyUVHve9IhS6IsFJ1uoMG9jAdmiW9ozC5I3DiQQcHUXjN1u3Ew
         GniGNbM9n8aaZOLdntEqCXLg92AeCReXCXVSNslW8exwKlaprdcqVJE4x88Xx82RmKEB
         HbrjOEVLbptE8H2l5JhTwlJb89p9rMw0HplkqUy/XnfemmIrrbQeYxPjh0/EcEatFqTh
         58l/Wx9xWTybjViyRoGdtix1j3CXsu5UOgg2iJGzsFInBt32qwQJnDx6pS32ZO21sxhB
         tpjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IzXFZg0mB+5Clpn1iKWeUt/f0+wv1xKbpxQ9jRIC0eI=;
        fh=EDxFVepZ8no0Ol920C6PfVrqqnDERhDH2mJhBiPmc8w=;
        b=SFdIY8Tl25g+5vgq/WWziFdhfIxJ7s1zDAZ3kjUbEPElydcbYN8fSLICJGYXVlc2Fn
         LT0AgDa6DAghQw8CcU2aXOvlnr/gWkpPovgXdlJgeT3GY9oR9l5LvyPCQMyMrKsgCbrj
         W1E4CM8qJRnYel6nU5B/nKi6T546h9RGM68PS3WfTWMQazEfkVEeCztlFt96SXgknMMr
         vGjtZ/mtglXGSSNzPZ4YsavJJ+CQPvb8AyLaQKnM0waJQjQsJ4e43SmZvAa9K0pq4A58
         U39vn29xbY8xXG2d/kYEP8vzdP39xI0/m0iNkraPneJ2x85qSkD/3xv1j8+j6SkEpdgJ
         s8XQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774981845; x=1775586645; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IzXFZg0mB+5Clpn1iKWeUt/f0+wv1xKbpxQ9jRIC0eI=;
        b=KNChGStB624WXAqbk2WKLUnqI+AVt/JbNxxCYvUsQiUj+e3CKNd1BAgQex6JlQ3bvr
         KP21ZeInpEz2tlS7f8uuUsJ2B4qP5COprQ+WVLyjLKmWNH+pABcFEIe5/KcU8uqZWwpN
         Z1/NO5r0FuyEJypVkfjtqJmQ2zY5bOe3uMrlYoR6JSs9K/uZIMy/TcHzqoPFhVSZCBsa
         /ph/Sa8gLbwUlf1n1qjcX8d5/CFn0S3da+t+caKciymvug63HJRKrsL9X+8WnXNlc7Gp
         9QN6MZcbNODvdLXJiLiKsSajfUTn/j/r1jYC9iEpP4RpqgOTF7RUL3he5xh0bBDXQSTc
         iCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774981845; x=1775586645;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzXFZg0mB+5Clpn1iKWeUt/f0+wv1xKbpxQ9jRIC0eI=;
        b=Jex8Jy6GxOxRmQ9xmgnbGZdSa2t4dEFeE1QmAHpNcXyZrHdIFePqcf4Bx6bzJjjaY7
         6+SZ4DKnTS3Q48PD3vn7xmWdN8BJxEJvLnE4uwLIUgybFmMxZOrvW6zufySNKSef34SI
         Te7BKzF3MsliLb+xYOpKlTqIVEXvJ5zwu1ulZ44nbf/ylGNW0bf/Z7qYFKv1vSdNbTb7
         WXJlEo6kFHTo4hE4NF/H6uMtYFGRT66OhdGJ9xYEbozIq0TOxX05bOCkov9qAXn8jCON
         MnITF/o6DjOdeUeel5N5Mqebl6yGVx/QbpkQTOEdStCCSHAWsSqNDc0Kbuk28rD9Kd0r
         7XmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWKWXJA+UXUqi1s3GtAFAWwFp3wV52pc0wJKN7CC6yogyYRJdnpEr08nEQm97qVZyNFxEubM807w==@kvack.org
X-Gm-Message-State: AOJu0YwH8GTBLDOP7mlQY5VHph4sRnCPr0Ys173qnhGQuLzaowApkgWC
	j65UB+RhhO164ATdaHFN/1hryIgG+//KGUUHNFUkBjiP7YNiMK6Lxotf0mVclZ5e3lq1otXB4ph
	zb/VepzlitOaqYKe0lr61qm+t4zNBW10=
X-Gm-Gg: ATEYQzyujEe145qeSDNZ8OzfObmUeFwoH5XiDygEe/TNiRoHBV2DaBoFV8/Khr/Vi7u
	+NKeO0TA1h/QtxW72DjfMGwjBupSkgk8Q1itJlCXc1d13rKP+pH93kgC9LjM81uYBIQs+jp0wts
	10So7VF7Gj0yHq5eUNaI3D+yKjac6KzWMvxlYfmdH/vcw1p2uyKJ8Uf3XdWodwkjtz6HEBwmnk7
	nhSRk1qzNPstuYsWNl8zknPxZilYzXaONT33oVtnE193bfFK7GV7uFO1nuLN3kauhLhkSBASFsg
	Nq+359VYL50VNLyZ8RrDdW9RdGg+WwmUrGM3Ns4il6dW6oy6L7b2
X-Received: by 2002:a05:690e:d0f:b0:64e:df9a:afa9 with SMTP id
 956f58d0204a3-6502fe67827mr341452d50.51.1774981844509; Tue, 31 Mar 2026
 11:30:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175456.4065874-1-luca.boccassi@gmail.com> <CA+CK2bB0bMxW721Q+SzFJENe4X0_GwcOh83R-mm1V5dig3oP3A@mail.gmail.com>
In-Reply-To: <CA+CK2bB0bMxW721Q+SzFJENe4X0_GwcOh83R-mm1V5dig3oP3A@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 31 Mar 2026 19:30:33 +0100
X-Gm-Features: AQROBzCjV1bB1C8lbNRLUx1soqcEo75UdpTHnFwLY0Cg7bO5t7ePalSG-Humf6A
Message-ID: <CAMw=ZnQZm_k_mMQPmKwuBtkFyXXgAn9MK1NzmVbZst4nGu6xhw@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: truncate getfile name to NAME_MAX
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, pratyush@kernel.org
Content-Type: multipart/alternative; boundary="0000000000005328f0064e562ac9"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8106120004
X-Stat-Signature: si4wunpexjssfiwg68hxeqoicers6ame
X-HE-Tag: 1774981845-311003
X-HE-Meta: U2FsdGVkX1+KoaeuauVHDHgur6wIe1tT2+t4JRg8uyzzre9xCrsn8HizsG7lk1vERk0v7xVI8dntedi8J3ch1KZlmPRWRf1qguUac8h6GNwUWf5ZNfNrNDAMF0iVdRcRPl8/Amdv26wtIYqwz7ZFmNAzYZeMWQ/l3vG22W3o8OYpuueZI4rjrXP0R3y6dJkXWqcSID2tb/UCsZUyJN1TvPvGZa6Z7b4lRT3JRgPWoG+t6Qex5tiVXbPooWoqirfgDva6taijW5Bv4Hl+x3GJatTIOx3/U3TUgTj//2hBRE1VcCaQdWYMmgy8CQpfTwv9jJ8kE8Q++A/KpCM9L9Km04TP2vWRVLne+a/9lDzjhmep9B8vAqT7naLq9E/a8KXp5vKJrzFSdfcXXmHchsVs9o10kHeWRzKP/Q7YD8EIMdVI1cKRMK7sEERMw2WByIyPqAfQlOtn5D3O32xvI8FJTj3z/VIxZ+UlYXlZFZmwJSd0n6RPxbjQ317VNzlRqeiHX0k3D+wwM76+idyoZKiGXkyIub6BU+KDPqJTEbeZdJA4bvqheCZGLOqDMeyfLb/eEp3ki34BcC+l4sGLbBFQv6joza3gdX+GyLdzW/+jNSqGwy/Z5Y+GNMtnLEfmzkmmy8T7h/CIN5VOixyF3W3YVwUL854tYKK0mr5r0wg3kBQW/Y+gf6kom3f07LjHWdwn23qnuohA1HHo+ugNUUke+skxwzS4D+AWyY5pE2L00HYtpDkCexFlnrUlajthwx2Z25xdYIpIE0hGBFDpOilFYjhOno5HRbSVmFq65MHO2VVwMB2BJT4sR0kv7MoG+HzRhR0ra9QEJ4yq4n+ij4XWSVz8v3KRlBa5cw9iqoUn9HfMmA2eq7uwE93dLEav+nGW31c2E0RTjFAjs5R0yE6vxNeUrHhbUUljywCBula3EXztGciQ91uCnoVRLKusjt1KHNcdb9aSgrCBJneRl0i
 bjUDeIsO
 R5+PlLoeo29dbTWV96qvxHdKq4eykwfGvBSSUb7P9+iMIQ1IGf45UVbm+wFb4/OrXiDdSvemZw2N7jFDkdhJaVXUSyEgBkbAK48B/Y1Oz0gpZu57R/xFyFfUrr8kYCvnm6g8sUjAgXULEOz7ehUqUv6fXuntp+R7xcxsHTLykGj2DSVgc8Zh9KchlQ9gNVw1MitbHFUhGXwPgVXpOHAbzIQATqYxzWk+ZqAlA4P1ZWsBb16o52h6fE4PVNdTFW9CzkDOUhBOi47RhVFS3pkHzkn9NSrSulVVqX/bBtsKcdzV/Ml4znWWa80HHKwkJgjiw0lG8P7+PrK2m7ZNYyYU+JY0QbCgVLV+kgqdMAXtRSaq9zBT3qCYAWfQjO6jzaxHpEeeLRi1Wij+jiYr3Uwys/oYbZ7blsbr/t2USLFKtasjXbF2jsIHeoyulfceKiP7F1Va6S19LsXNhHepnmnKPcX15/1h3GHKqMdh8mszZu3XIBUZkQ/N2lSyiKRTGvgkJPd3EJSZgZwKjTYA5133+TfW6Y22slzs8vzttpZ+LiAizG1ZK/eUcNieQjzsMNxvftoZ0iptDq0jc3thWtXvu5EKaAprveTIoqpzFTpUL4f8ZuEO8/6HhhvdTSfvnFMaXccEmo5xMeUSITjjzL5MlX0BaBqxqZbmNx21YAJ5YELANFDUI7V+pyV1epfmvYgdcNcJwL5EWx1YNzbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000005328f0064e562ac9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Mar 2026, 19:21 Pasha Tatashin, <pasha.tatashin@soleen.com>
wrote:

> On Tue, Mar 31, 2026 at 1:55=E2=80=AFPM <luca.boccassi@gmail.com> wrote:
> >
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >
> > dynamic_dname() harcodes its limit to NAME_MAX bytes, which includes a
> > NUL terminator and a 'anon_inode:' prefix. If the name passed on goes
> > above the limit it results in userspace getting a ENAMETOOLONG error.
> >
> > Truncate the name to NAME_MAX - 12 - 1 characters to ensure this never
> > fails (accounting for prefix and NUL).
> >
> > Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
> >
> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > ---
> > Builds on top of this just sent by Aleksa:
> >
> >
> https://lore.kernel.org/linux-fsdevel/20260401-dynamic-dname-name_max-v1-=
1-8ca20ab2642e@amutable.com/
> >
> >  kernel/liveupdate/luo_session.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/liveupdate/luo_session.c
> b/kernel/liveupdate/luo_session.c
> > index 7836772956406..4a40c7fdfb44f 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -366,11 +366,14 @@ static const struct file_operations
> luo_session_fops =3D {
> >  /* Create a "struct file" for session */
> >  static int luo_session_getfile(struct luo_session *session, struct fil=
e
> **filep)
> >  {
> > -       char name_buf[128];
> > +       char name_buf[NAME_MAX];
> >         struct file *file;
> >
> >         lockdep_assert_held(&session->mutex);
> > -       snprintf(name_buf, sizeof(name_buf), "[luo_session] %s",
> session->name);
> > +       /* dynamic_dname() rejects names above NAME_MAX bytes, includin=
g
> NUL terminator
> > +        * and a 'anon_inode:' prefix. Truncate to NAME_MAX - 12 - 1 to
> avoid
> > +        * ENAMETOOLONG. */
> > +       snprintf(name_buf, NAME_MAX - 12 - 1, "[luo_session] %s",
> session->name);
>
> I am confused by this change, the maximum session name length is: 64,
> as defined in:
> include/uapi/linux/liveupdate.h
> /* The maximum length of session name including null termination */
> #define LIVEUPDATE_SESSION_NAME_LENGTH 64
>
> So, 128 should be enough to include:
> "[luo_session] %s", session->name
>
> Or am I missing something?
>
> Pasha
>

Yeah we need to to bump that size, it's too small - see the shared doc.
This is anyway needed for safety, as the user space call falls apart
completely if it goes over the hard coded limit, so it should always be
used as a max value

>

--0000000000005328f0064e562ac9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><div class=3D"gmail_quote gmail_quote_container"><di=
v dir=3D"ltr" class=3D"gmail_attr">On Tue, 31 Mar 2026, 19:21 Pasha Tatashi=
n, &lt;<a href=3D"mailto:pasha.tatashin@soleen.com">pasha.tatashin@soleen.c=
om</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Tue, Mar 31, 2=
026 at 1:55=E2=80=AFPM &lt;<a href=3D"mailto:luca.boccassi@gmail.com" targe=
t=3D"_blank" rel=3D"noreferrer">luca.boccassi@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; From: Luca Boccassi &lt;<a href=3D"mailto:luca.boccassi@gmail.com" tar=
get=3D"_blank" rel=3D"noreferrer">luca.boccassi@gmail.com</a>&gt;<br>
&gt;<br>
&gt; dynamic_dname() harcodes its limit to NAME_MAX bytes, which includes a=
<br>
&gt; NUL terminator and a &#39;anon_inode:&#39; prefix. If the name passed =
on goes<br>
&gt; above the limit it results in userspace getting a ENAMETOOLONG error.<=
br>
&gt;<br>
&gt; Truncate the name to NAME_MAX - 12 - 1 characters to ensure this never=
<br>
&gt; fails (accounting for prefix and NUL).<br>
&gt;<br>
&gt; Fixes: 0153094d03df (&quot;liveupdate: luo_session: add sessions suppo=
rt&quot;)<br>
&gt;<br>
&gt; Signed-off-by: Luca Boccassi &lt;<a href=3D"mailto:luca.boccassi@gmail=
.com" target=3D"_blank" rel=3D"noreferrer">luca.boccassi@gmail.com</a>&gt;<=
br>
&gt; ---<br>
&gt; Builds on top of this just sent by Aleksa:<br>
&gt;<br>
&gt; <a href=3D"https://lore.kernel.org/linux-fsdevel/20260401-dynamic-dnam=
e-name_max-v1-1-8ca20ab2642e@amutable.com/" rel=3D"noreferrer noreferrer" t=
arget=3D"_blank">https://lore.kernel.org/linux-fsdevel/20260401-dynamic-dna=
me-name_max-v1-1-8ca20ab2642e@amutable.com/</a><br>
&gt;<br>
&gt;=C2=A0 kernel/liveupdate/luo_session.c | 7 +++++--<br>
&gt;=C2=A0 1 file changed, 5 insertions(+), 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_s=
ession.c<br>
&gt; index 7836772956406..4a40c7fdfb44f 100644<br>
&gt; --- a/kernel/liveupdate/luo_session.c<br>
&gt; +++ b/kernel/liveupdate/luo_session.c<br>
&gt; @@ -366,11 +366,14 @@ static const struct file_operations luo_session_=
fops =3D {<br>
&gt;=C2=A0 /* Create a &quot;struct file&quot; for session */<br>
&gt;=C2=A0 static int luo_session_getfile(struct luo_session *session, stru=
ct file **filep)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0char name_buf[128];<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0char name_buf[NAME_MAX];<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct file *file;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lockdep_assert_held(&amp;session-&gt;=
mutex);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0snprintf(name_buf, sizeof(name_buf), &quot=
;[luo_session] %s&quot;, session-&gt;name);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0/* dynamic_dname() rejects names above NAM=
E_MAX bytes, including NUL terminator<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * and a &#39;anon_inode:&#39; prefix. Tru=
ncate to NAME_MAX - 12 - 1 to avoid<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * ENAMETOOLONG. */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0snprintf(name_buf, NAME_MAX - 12 - 1, &quo=
t;[luo_session] %s&quot;, session-&gt;name);<br>
<br>
I am confused by this change, the maximum session name length is: 64,<br>
as defined in:<br>
include/uapi/linux/liveupdate.h<br>
/* The maximum length of session name including null termination */<br>
#define LIVEUPDATE_SESSION_NAME_LENGTH 64<br>
<br>
So, 128 should be enough to include:<br>
&quot;[luo_session] %s&quot;, session-&gt;name<br>
<br>
Or am I missing something?<br>
<br>
Pasha<br></blockquote></div></div><div dir=3D"auto"><br></div><div dir=3D"a=
uto">Yeah we need to to bump that size, it&#39;s too small - see the shared=
 doc. This is anyway needed for safety, as the user space call falls apart =
completely if it goes over the hard coded limit, so it should always be use=
d as a max value</div><div dir=3D"auto"><div class=3D"gmail_quote gmail_quo=
te_container"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex">
</blockquote></div></div></div>

--0000000000005328f0064e562ac9--

