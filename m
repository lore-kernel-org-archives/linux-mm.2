Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C57F8CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 14:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233BC8E0015; Wed, 12 Nov 2025 09:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E41B8E0011; Wed, 12 Nov 2025 09:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9DE8E0015; Wed, 12 Nov 2025 09:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E866F8E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:48:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8A6259577
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:48:07 +0000 (UTC)
X-FDA: 84102235014.11.368AC5B
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id A5FBF1C000A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:48:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HrBvVsBs;
	spf=pass (imf20.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762958885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VNPigpgIeukJ7CSSeeB9OOzKnRd+iQCK/rhwRam1G8=;
	b=HDlXLp5BnQ1o6KFlO01NUAq7F6+roDtEKm+BWJC0H9kNoxO/FqD846LzMFq6IOivDfj74V
	YtxGzuqaW+se0798xe2J1OtD5KcVQ+SxzXhNmkxyM3jzPrpD7lt4G4zdHY7ugPNs96p67S
	5XIIEqxIckz9WkluzVoHdOYAJL7xbck=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HrBvVsBs;
	spf=pass (imf20.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762958885; a=rsa-sha256;
	cv=none;
	b=xpqj/fR6YWznb8m4N18Zkzn0W+tOnlo641GppVViadicF2KDx/gYnnxlK+T+XHOA0wWzv+
	S42zhh7Z41Haua83BDyNXGru0SPgNkZU+f2TtuMnz2QpsoieRBaK7qGVd1bQdFLoquTJi7
	BGPa2eMGDAue2bibuQiDccurjw1VdlY=
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-37775ed97daso7349521fa.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762958884; x=1763563684; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3VNPigpgIeukJ7CSSeeB9OOzKnRd+iQCK/rhwRam1G8=;
        b=HrBvVsBsAojUj59BCN64sbvKRodlH/PlXi+/U3FXl+jHJX6r3FalkXIPCzRczi+YLe
         /FUY9zPQjh9poK4rpjs8KSotRxrE6KLeKJFNR6PF6fi6lPifxoDwPXyMtRZo4uoPB+Jd
         YnrMIEuQeuC4fBtxFwr+OMvYvxdseF9SRdaglRrT5Hbev2TwmQESyaZ22OKw0PIezFqK
         RofFlSrOPscyh/dbXHliuz9jqj352ujrz1gDui25xfPNwTMKvUVKBvD43Oj8rRIQeIu5
         1FOS8SA4tRcH1UEl1+EG5eo1CPdqAebCfsyPPKe+5W6mP7is68n5h4QVImFoAZj0CJMT
         HxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762958884; x=1763563684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VNPigpgIeukJ7CSSeeB9OOzKnRd+iQCK/rhwRam1G8=;
        b=cIN3i3M7We6VWNzr7C6vs3rjPgMkQGEQn03WZtrka1KvJiGvnOapeZKyTQedDwl3gB
         CS+/FsJByXm+qXj79WTZIxYjhRFWOEtwwc8UgR6R/K/jpkhqC1crJrsEeIuMGzrnadvD
         i07vlJT9g+K200mTfwGAYuV+UddSluUUYFMJOFiTnR6Pn3yAHUcq8a7k/3B9ARM4nYxY
         f8+lE68LfOhXr+NZrIGx7vyzvn+TzvTz84Pzo6xUxht9j1Zax1XZ7BCYYJMsYFiYNLOl
         Bp6QZ22PtOcKzX2LvzrA/jvZoJfbmYxmT2bf/2dgCltwBZzpur+qiha1kK1AcJ5js+ZC
         /Owg==
X-Forwarded-Encrypted: i=1; AJvYcCX0iKG84oSdaeMaxS6d+kl8wn5mHDbehL0qdAmM1bPQwlEEoVUk5VNWkLRdgSCaNG0hEkYzhtVekw==@kvack.org
X-Gm-Message-State: AOJu0YwOOKjb0gzH18d6nndNgDwt8+T/RM9nGjK56Bewl2IjGcmZ0X97
	4eacLrDPWBT/vdd1USCVGQJ4teDAWrGnl+uR6OfNCcpfb5Kh/wpLPzZP0InDtF0rJ8jYbUfo+bM
	sMOLkniuhnTBMrp9m7yg3Pwfw4Lkzwb4=
X-Gm-Gg: ASbGncssSAYvXCwy7VT67pYwiy7Quygx/dwp4/1xRzvDt54zOqCcTlE05bZsZb1UQW+
	B7ujhjBuTZWm8vjMQ/c6vBhVDa45G90g5CCNoNdttkp9x+yh8c845isdMJl+eSeJoDfdn/b/HdO
	c9N2ZiqW3gPzaKnm7Tbzm2QDMCGv3eXNV2Sv6S0KqVLUBAuGelZG+xpp6lmTmQySxwP4F9S4pog
	RrEKAr8m8NByUQBDEuR36Y2QrkjNx9rn8+sEyH3VeuJiDCIkFRK5vi4UPFG9/Aacb6lO1NJ6g==
X-Google-Smtp-Source: AGHT+IHKXaM4H8ZexYYwatmRvIKlpWlg7nRJG8gwsD/vxeOb2JJ4n7gp5V3aZgP5LXHuVOrSowoC3ggKd835v4apLtI=
X-Received: by 2002:a05:6512:159b:b0:593:de8b:9a04 with SMTP id
 2adb3069b0e04-59576e106cfmr1121136e87.1.1762958883355; Wed, 12 Nov 2025
 06:48:03 -0800 (PST)
MIME-Version: 1.0
References: <20251111125331.12246-1-harry.yoo@oracle.com> <eesmaqfwnhq4xcoduevr5aodsf622ugn5aheywvpbhpg5fzhcv@5zbfhikqmrtl>
 <CANfXJztJZJ4eaFf+FxC=deFeO7MG0__U3FVtBDcmS7iUk3gFgw@mail.gmail.com> <aRN_0P3CXDJujrLp@hyeyoo>
In-Reply-To: <aRN_0P3CXDJujrLp@hyeyoo>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Wed, 12 Nov 2025 15:47:52 +0100
X-Gm-Features: AWmQ_bmaTqLPdupqx_Dy9TCGShsW9nOMFZ9fF5jI2IWHj08va9dTT9zY9Cmf1Wg
Message-ID: <CANfXJztkO_r41SU6jNBnh=tYDSQ=rAFj4hZFX6Crk1WDAg-QDA@mail.gmail.com>
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="000000000000ff016e064366d9b3"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A5FBF1C000A
X-Stat-Signature: 3mtzxm5zg6erig7k5qkb3apzyf141rj7
X-Rspam-User: 
X-HE-Tag: 1762958885-436275
X-HE-Meta: U2FsdGVkX19gJACa76BJg8VHEbxxqBqckhSggp/lrR2oCy3BkmBwdbNWBx20Dv6eAyqyIBOiLJgcv4017+Yooy4MUKQBvcSn/VlSo7J9FvLprGmVZOZ5/HDBqhnCMfZMVPNL7Doaq0mtiHADgd1EVZUg2lQOTqsd8iHRIq2rn8FZ/oycbu33tH2WjgD7RwXj1l5Up38GLlZWNHtkZF43BLYK1Qn0pYigQCbs39OvmZbJ15Pa4brl93brIJVejocSrimkkfx2DzEkMWFfGKdrvyXqxx9p15xoBXbMqzVNFFbslk+n1riaSwp2QeBCYLYjeGqzy5gu/5dMtLETMtiAUwzC3ficw/aONLmzScxyuKcPHDS4p3BriQVGyGGXYtDp40/nuNrqvzZ+4lDSw66VgSc7jX64E18A464IHsjSMQ67OVu6qUWLXXVT/d+Cc2G6ZLrSshp3y7CuPjLKzs2f7t2KyK93N4gdrUGZ8CxyfNmggLeWcXeBibUgrG+Nct1ti7s69Xq5Fe3gymD79v+uDGujK5SG/Jv5b6AYudg601ozSrywVQgxNdN9LfLjWORVLhHksjEsC9qlFUzdj0Um+wTnX330xa4SkE0AzUuAXlRby9cdQr8qxCH8hW6/bre3YZyLCHEeNWzWDZv79g32AwPMSiK6155zo0t2lLc7rDcuPwsolPf0YkI5LjI+PZClG5dwErilxzP5EyrI8VO1PTA0vShLLnN7msZvLKbO6yLy+0+YJAQmSGqFuf3IsJ3cO3JHbIItD2V2ucuL+v9iorMec2huHluWAPelQVj3NfrPVQGQXGh7Qfx5Yi0hmRt1qNBRM8SroVMoWjni47quUiiOLZtCZuMj1gZay6DAfJ1YRn0anCTWTLfe54XFaDPn/3a3up1Ll4suQsdCqmjbIGxZkDIZRFROfX23JTkCp1pKs2Xwbc73PwIEEoAZDgkqALI7qLiNApLwPxtZ7o3
 NXVeWBBG
 VTFcwWbU+tnL1yX+fM+BO+MtcFBSJQXp7++oE8zTFKp417lqOQQx8CgmqpOJT5bomxinmq42bSOPvefUn37J99DbzQ2Fz+6NimT9OYkDKh37VfGQ0VpIYpxWQp+SjLeloLO1JicHnbOqD3ZxZvzv5/H08wPDumBncnBITSAauH3qiMyQLcAVN7ljDi5RSinNemSwggNiP65Ks0LRv/WtGprj6G1dBDSgr+Kmu/yDNqxhZ5ciI2Om+zUfaa/LH30baRd3ca0h/Sg0nb4t5tzwxY+bNYyX89x/Xjyt+C5H6SaxLll2gudbcbF8sf04r3kZGDP5UoJweo1aIP0S4QE9mubPI4AVnzx7586uu3QSCEesptFbWOWfI1cuA15tu1Bk/4mVsiaQzIe3A4xePn5sjYJML5C2geVwvVa6MjhUk6lSi4DEGmXbA2CXd6BySvMS10GkKNzOgvLZRAcZgLeVkH3G539E+LhVVy7N8ookMbH4YZ8+02bmGFh4+AKWaxUckKC7rAwnxh1HxD6C43uu7jagB93HV1R5yCc2iUy5b3An+5YeUnCy3SuEg5+ogRS7DPKK54WFnitIEGUOoOTeeSVRZIfWDkz/VQvBuMaWtuuObnsFnz2gre3SLSyhW6kWrjVpzwW/CDM62gHirH9UXKQ84z2JBJr+7mUZFBw4bd7Nf8/JBof00PMlxj9S6Vx6vJcF+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000ff016e064366d9b3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We wont make it until next week.
Maybe you guys can compile newest r5 kernel with that patch ?
We are using https://prebuiltkernels.com/ and do not compiled 6.18
ourselves. We can do that next week. This week is full of emergencies lol
If you can provide me two debs like prebuild kernels i could deploy it and
leave for testing for 1-2 days.


--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


wt., 11 lis 2025 o 19:29 Harry Yoo <harry.yoo@oracle.com> napisa=C5=82(a):

> On Tue, Nov 11, 2025 at 05:48:35PM +0100, Tytus Rogalewski wrote:
> > Do you guys still need that debug then?
> > I think this is happening only when qemu vm is working.
> >
> > I can get results within 1-2 days.
>
> Hi Tythus!
>
> Really appreciate you reporting the bug and testing it.
>
> Now that I know what went wrong, I realize that `slab_debug=3DU` paramete=
r
> will hide the bug, since we disable "sheaves" feature for
> debug caches.
>
> Instead of testing with `slab_debug=3DU` parameter, could you please
> apply this patch on top of Linux v6.18-rc5, build & install it,
> and verify that the memory leak is indeed resolved on your machine?
>
> > --
> >
> > tel. 790 202 300
> >
> > *Tytus Rogalewski*
> >
> > Dolina Krzemowa 6A
> >
> > 83-010 Jagatowo
> >
> > NIP: 9570976234
> >
> >
> > W dniu wt., 11 lis 2025 o 16:37 Liam R. Howlett <Liam.Howlett@oracle.co=
m
> >
> > napisa=C5=82(a):
> >
> > > * Harry Yoo <harry.yoo@oracle.com> [251111 07:55]:
> > > > The commit 989b09b73978 ("slab: skip percpu sheaves for remote obje=
ct
> > > > freeing") introduced the remote_objects array in free_to_pcs_bulk()
> to
> > > > skip sheaves when objects from a remote node are freed.
> > > >
> > > > However, the array is flushed only when:
> > > >   1) the array becomes full (++remote_nr >=3D PCS_BATCH_MAX), or
> > > >   2) slab_free_hook() returns false and size becomes zero.
> > > >
> > > > When neither of the conditions is met, objects in the array are
> leaked.
> > > > This resulted in a memory leak [1], where 82 GiB of memory was
> allocated
> > > > for the maple_node cache.
> > > >
> > > > Flush the array after successfully freeing objects to sheaves
> > > > in the do_free: path.
> > > >
> > > > In the meantime, move the snippet if (!size) goto flush_remote;
> outside
> > > > the while loop for readability. Let's say all objects in the array
> are
> > > > from a remote node: then we acquire s->cpu_sheaves->lock and try to
> free
> > > > an object even when size is zero. This doesn't appear to be harmful=
,
> > > > but isn't really readable.
> > > >
> > > > Reported-by: Tytus Rogalewski <tytanick@gmail.com>
> > > > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D220765
> > > > Closes:
> > >
> https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb184@=
linux-foundation.org
> > > > Closes: https://lore.kernel.org/all/aRGDTwbt2EIz2CYn@hyeyoo
> > > > Fixes: 989b09b73978 ("slab: skip percpu sheaves for remote object
> > > freeing")
> > > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > >
> > >
> > > Thanks Harry.
> > >
> > > Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > >
> > > > ---
> > > >  mm/slub.c | 8 ++++++--
> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > index f1a5373eee7b..a787687a0d59 100644
> > > > --- a/mm/slub.c
> > > > +++ b/mm/slub.c
> > > > @@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct kmem_cach=
e
> *s,
> > > size_t size, void **p)
> > > >
> > > >               if (unlikely(!slab_free_hook(s, p[i], init, false))) =
{
> > > >                       p[i] =3D p[--size];
> > > > -                     if (!size)
> > > > -                             goto flush_remote;
> > > >                       continue;
> > > >               }
> > > >
> > > > @@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct kmem_cach=
e
> *s,
> > > size_t size, void **p)
> > > >               i++;
> > > >       }
> > > >
> > > > +     if (!size)
> > > > +             goto flush_remote;
> > > > +
> > > >  next_batch:
> > > >       if (!local_trylock(&s->cpu_sheaves->lock))
> > > >               goto fallback;
> > > > @@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct kmem_cach=
e
> *s,
> > > size_t size, void **p)
> > > >               goto next_batch;
> > > >       }
> > > >
> > > > +     if (remote_nr)
> > > > +             goto flush_remote;
> > > > +
> > > >       return;
> > > >
> > > >  no_empty:
> > > > --
> > > > 2.43.0
> > > >
> > >
>
> --
> Cheers,
> Harry / Hyeonggon
>

--000000000000ff016e064366d9b3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>We wont make it until next week.</div><div>Maybe you =
guys can compile newest r5 kernel with that patch ?<br>We are using=C2=A0<a=
 href=3D"https://prebuiltkernels.com/">https://prebuiltkernels.com/</a> and=
 do not compiled 6.18 ourselves. We can do that next week. This week is ful=
l of emergencies lol</div><div>If you can provide me two debs like prebuild=
 kernels i could deploy it and leave for testing for 1-2 days.</div><div><b=
r><br></div><div><div dir=3D"ltr" class=3D"gmail_signature" data-smartmail=
=3D"gmail_signature"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><di=
v dir=3D"ltr">







<p style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-fami=
ly:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">--</font></p><p =
style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">tel. 790 202 300</f=
ont></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal;f=
ont-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"color:rgb(68,=
68,68);font-size:x-small">Tytus Rogalewski</b><br></p><p style=3D"font-stre=
tch:normal;font-size:12px;line-height:normal;font-family:&quot;Helvetica Ne=
ue&quot;;margin:0px"><font size=3D"1" color=3D"#999999">Dolina Krzemowa 6A<=
/font></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal=
;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" color=
=3D"#999999">83-010 Jagatowo</font></p><p style=3D"font-stretch:normal;font=
-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot;;margin=
:0px"><font size=3D"1" color=3D"#999999">NIP: 9570976234</font></p></div></=
div></div></div></div></div><br></div><br><div class=3D"gmail_quote gmail_q=
uote_container"><div dir=3D"ltr" class=3D"gmail_attr">wt., 11 lis 2025 o 19=
:29=C2=A0Harry Yoo &lt;<a href=3D"mailto:harry.yoo@oracle.com">harry.yoo@or=
acle.com</a>&gt; napisa=C5=82(a):<br></div><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);=
padding-left:1ex">On Tue, Nov 11, 2025 at 05:48:35PM +0100, Tytus Rogalewsk=
i wrote:<br>
&gt; Do you guys still need that debug then?<br>
&gt; I think this is happening only when qemu vm is working.<br>
&gt; <br>
&gt; I can get results within 1-2 days.<br>
<br>
Hi Tythus!<br>
<br>
Really appreciate you reporting the bug and testing it.<br>
<br>
Now that I know what went wrong, I realize that `slab_debug=3DU` parameter<=
br>
will hide the bug, since we disable &quot;sheaves&quot; feature for<br>
debug caches.<br>
<br>
Instead of testing with `slab_debug=3DU` parameter, could you please<br>
apply this patch on top of Linux v6.18-rc5, build &amp; install it,<br>
and verify that the memory leak is indeed resolved on your machine?<br>
<br>
&gt; --<br>
&gt; <br>
&gt; tel. 790 202 300<br>
&gt; <br>
&gt; *Tytus Rogalewski*<br>
&gt; <br>
&gt; Dolina Krzemowa 6A<br>
&gt; <br>
&gt; 83-010 Jagatowo<br>
&gt; <br>
&gt; NIP: 9570976234<br>
&gt; <br>
&gt; <br>
&gt; W dniu wt., 11 lis 2025 o 16:37 Liam R. Howlett &lt;<a href=3D"mailto:=
Liam.Howlett@oracle.com" target=3D"_blank">Liam.Howlett@oracle.com</a>&gt;<=
br>
&gt; napisa=C5=82(a):<br>
&gt; <br>
&gt; &gt; * Harry Yoo &lt;<a href=3D"mailto:harry.yoo@oracle.com" target=3D=
"_blank">harry.yoo@oracle.com</a>&gt; [251111 07:55]:<br>
&gt; &gt; &gt; The commit 989b09b73978 (&quot;slab: skip percpu sheaves for=
 remote object<br>
&gt; &gt; &gt; freeing&quot;) introduced the remote_objects array in free_t=
o_pcs_bulk() to<br>
&gt; &gt; &gt; skip sheaves when objects from a remote node are freed.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; However, the array is flushed only when:<br>
&gt; &gt; &gt;=C2=A0 =C2=A01) the array becomes full (++remote_nr &gt;=3D P=
CS_BATCH_MAX), or<br>
&gt; &gt; &gt;=C2=A0 =C2=A02) slab_free_hook() returns false and size becom=
es zero.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; When neither of the conditions is met, objects in the array =
are leaked.<br>
&gt; &gt; &gt; This resulted in a memory leak [1], where 82 GiB of memory w=
as allocated<br>
&gt; &gt; &gt; for the maple_node cache.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Flush the array after successfully freeing objects to sheave=
s<br>
&gt; &gt; &gt; in the do_free: path.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; In the meantime, move the snippet if (!size) goto flush_remo=
te; outside<br>
&gt; &gt; &gt; the while loop for readability. Let&#39;s say all objects in=
 the array are<br>
&gt; &gt; &gt; from a remote node: then we acquire s-&gt;cpu_sheaves-&gt;lo=
ck and try to free<br>
&gt; &gt; &gt; an object even when size is zero. This doesn&#39;t appear to=
 be harmful,<br>
&gt; &gt; &gt; but isn&#39;t really readable.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Reported-by: Tytus Rogalewski &lt;<a href=3D"mailto:tytanick=
@gmail.com" target=3D"_blank">tytanick@gmail.com</a>&gt;<br>
&gt; &gt; &gt; Closes: <a href=3D"https://bugzilla.kernel.org/show_bug.cgi?=
id=3D220765" rel=3D"noreferrer" target=3D"_blank">https://bugzilla.kernel.o=
rg/show_bug.cgi?id=3D220765</a><br>
&gt; &gt; &gt; Closes:<br>
&gt; &gt; <a href=3D"https://lore.kernel.org/linux-mm/20251107094809.12e9d7=
05b7bf4815783eb184@linux-foundation.org" rel=3D"noreferrer" target=3D"_blan=
k">https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb184=
@linux-foundation.org</a><br>
&gt; &gt; &gt; Closes: <a href=3D"https://lore.kernel.org/all/aRGDTwbt2EIz2=
CYn@hyeyoo" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/al=
l/aRGDTwbt2EIz2CYn@hyeyoo</a><br>
&gt; &gt; &gt; Fixes: 989b09b73978 (&quot;slab: skip percpu sheaves for rem=
ote object<br>
&gt; &gt; freeing&quot;)<br>
&gt; &gt; &gt; Signed-off-by: Harry Yoo &lt;<a href=3D"mailto:harry.yoo@ora=
cle.com" target=3D"_blank">harry.yoo@oracle.com</a>&gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; Thanks Harry.<br>
&gt; &gt;<br>
&gt; &gt; Acked-by: Liam R. Howlett &lt;<a href=3D"mailto:Liam.Howlett@orac=
le.com" target=3D"_blank">Liam.Howlett@oracle.com</a>&gt;<br>
&gt; &gt;<br>
&gt; &gt; &gt; ---<br>
&gt; &gt; &gt;=C2=A0 mm/slub.c | 8 ++++++--<br>
&gt; &gt; &gt;=C2=A0 1 file changed, 6 insertions(+), 2 deletions(-)<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; diff --git a/mm/slub.c b/mm/slub.c<br>
&gt; &gt; &gt; index f1a5373eee7b..a787687a0d59 100644<br>
&gt; &gt; &gt; --- a/mm/slub.c<br>
&gt; &gt; &gt; +++ b/mm/slub.c<br>
&gt; &gt; &gt; @@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct km=
em_cache *s,<br>
&gt; &gt; size_t size, void **p)<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (un=
likely(!slab_free_hook(s, p[i], init, false))) {<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0p[i] =3D p[--size];<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0if (!size)<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto flush_remote;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0continue;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; @@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct km=
em_cache *s,<br>
&gt; &gt; size_t size, void **p)<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i++;<b=
r>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0if (!size)<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto flush_=
remote;<br>
&gt; &gt; &gt; +<br>
&gt; &gt; &gt;=C2=A0 next_batch:<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!local_trylock(&amp;s-&gt;cpu_=
sheaves-&gt;lock))<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto f=
allback;<br>
&gt; &gt; &gt; @@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct km=
em_cache *s,<br>
&gt; &gt; size_t size, void **p)<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto n=
ext_batch;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0if (remote_nr)<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto flush_=
remote;<br>
&gt; &gt; &gt; +<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 no_empty:<br>
&gt; &gt; &gt; --<br>
&gt; &gt; &gt; 2.43.0<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
<br>
-- <br>
Cheers,<br>
Harry / Hyeonggon<br>
</blockquote></div>

--000000000000ff016e064366d9b3--

