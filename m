Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DDE3C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F946B00A2; Tue,  1 Sep 2026 04:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36DC6B00A3; Tue,  1 Sep 2026 04:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CB06B00A4; Tue,  1 Sep 2026 04:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A70496B00A2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:01:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC5F04034F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:01:45 +0000 (UTC)
X-FDA: 85164449370.02.D873667
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id BBFDD18000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:01:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CYVYYFGD;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788249703;
	b=CADsN8KxtKfxpVTPvwmDBVxxd95jtYo7ePaaxEaMODFUF3N7irf9zUxaoyMmxiI4Cj/Q2A
	p0tamENyy/Su00X7vzf0Z81C3I5vf7is0hobdpe+P3U2mAF2hN8XKi3WB2nYuo42Oh8eeh
	POI2Zu9Eu5XbEDfIO6t19kXN41I+BP4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6sI+2zMdUCPwykcT8zM0egcpu7A4Yk8drgxjgXx0D2E=;
	b=n5Q4xs81LlAIG5C0H4bq3hh+ZZvaBQSFyL0tNPupQYvdjSxL8CuYZJcy11/gFwD82Bljrm
	mxErPf5wVO58HYI5qqqZil3yDhurtew7cccrZ7wm8H1iP1uuZRXsUgC44z4jplAG/njRZv
	twixe8sJKTGlRGYo9vzACnDGNdq53vA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CYVYYFGD;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4843886fc9cso236860f8f.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:01:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788249702; cv=none;
        d=google.com; s=arc-20260327;
        b=QCjFwwnzmA7GQ2mce/g3w0i2spyYzLcz+V9Pn87KrJwM8TBF0C24jSBEKAF+wTURGu
         SorOQWFZVUphmgv74sOMrmH8LM56IOsNK4FA8PD1qL2xmyDqflxPJknHOoNH6FVEBLkH
         8HE9jOl7GXQ5/wbi189KSFp+g2lOC9tqp6gIycU6LM6hUb83XYmsYekoq3cEZd/KYnf5
         1rSYYZQPlGOTdnv5jkwhGGSrJdJBM3V85Usgr8NOw4Xm/wq/RIzd+u+Xc/CWGzq8tU5o
         1nBIjSwcDuAVd+kNUG901liLErfsTM2SKUdqYTP2gDB4tpeNi46CiNZCoQk3T1GnOans
         2bUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6sI+2zMdUCPwykcT8zM0egcpu7A4Yk8drgxjgXx0D2E=;
        fh=b2CN+ZP/E8D6TdzlpeicwUyAUTqBm59NGfpo11vhwJU=;
        b=KHZoq2Cpu+vaN8ThxYEJMGVBN93Egt3Xq+JOrWJiR+aI/iZQmQ27C6X4B3QBQNiyYq
         5JgjMDlaIp6vLCw99OiLjfJkOpGG7OUqljbHr31xF8z5cWxeR00ul/cLRccHCqCSYCaW
         YKABcNVMQLz03lsdRnYMdjawDSvJKp6D33JGklql/nJ8IMoL3odD58UpSgUTK1wMwEvJ
         IcbAVhvQ6aRkFkf2faHmAN/0/0960ps55FmrV5fyzyl1Fzn+G5Tbcn/3gceeR6HI+xRb
         RhhbnJBDvxImcOWyhESMpz9XdpUYDqQ9K+RVt5g4rVBC5OIG5DWd8uemX49h+jhO0gFt
         lNVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788249702; x=1788854502; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6sI+2zMdUCPwykcT8zM0egcpu7A4Yk8drgxjgXx0D2E=;
        b=CYVYYFGD1NYb5cFaw6lw+DQb9hiAGLX8xXX8XXYAzRqv2eGAymjhb7I3XowBaJxrGj
         PO+r6MqQInOafk7kZcWoWYnwAmPRKr+BwGouEMZ6MjwAtUmgcyZAdBP/UEjYH9ykWVQx
         cOZ1T0ZpzFZgfuOMtrfIxOhonTiRIqbQUS6I1adA9nGR8IIQxKylU6BvMko5vEjjPshQ
         hlvsyH7Qq16yLad+rU1VtThKrExVFZT8yh3Q/OUBFdP1X6DwUmPQUwb5buDODwnyfFRe
         eejT42ya3EzLH8RwRizoTpCMtr4hbnbPpOi3+fMj5ZG3rGzFBA+Q6fVnbU3OxNmkfBU+
         qZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788249702; x=1788854502;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6sI+2zMdUCPwykcT8zM0egcpu7A4Yk8drgxjgXx0D2E=;
        b=Nmz41o8ggp3PhuE5gr4v21urw4ppEbMKCzOgaXJzzWqVwVj1B7Uckj7/Wkr9GAEtb/
         XZwfYH70XosFjgXnrJmQq/2j8QAOwKw8s9Yf4hqlS2PVSn7vioeq7S+heCWwW3ZcS9VK
         qEa+T7xw/2Lf0iV1ucYo4CstUU19lhwbUdgodg4qhADBqPXiWUC2TY3sEZOEzhTXPBX3
         hM7KfeFy2zr8m+4ewSsX7gnSAnuqMYZ85wDatGfyUmFRQoOuCsS/1u04XiWlj3cl4cIa
         eNZbpCHJHwzVThZLgbqUFdm5cvAovTkcRY+5odmqQi9votuQDahHqf3KqqBnQb0rETki
         LsDg==
X-Gm-Message-State: AFuF++mR/Kt/EkgeuDggwO1BnvB8DQaVlLL+XYb0rrtbTYO3+r8dwHk2
	qsqNuNuSrcW3bZ7mx2Ojayzc1rREHu+F//kjrvP92N4RWhHfGbRQ+9d8ylGyc9kqpO2WhAsAU/m
	yq/THNvLbNK2kNJ3HcIJ0JPBFUABouktuvpjvsLZ78A==
X-Gm-Gg: AYBFou1HCQCAtcdpX/UYBvHBrcypx2H7sYDjK4hYgVKcXAyi98SPAC7BbBFFT8nQmmn
	5kZHUgyIGshxL8RaXtVuBKPfrdJvPLUgg9P1wZ5r+5Psd1soZins37ecEM+sKs2y+JWWvuUGomF
	UGWknTW+KWSMCxAEkIMJpx2GD5nn3rveNnrgeua9tkysSh6GXXYu36TwrL0A+RPFkRgaoaZMLlx
	aNzBALEL8itNd7WAlpSYlrpJ4JYrZRy11g+1ESc8cU9VSilv9flZUOwUqJD49o+qnV+fbm7uM/z
	Ji2byYbmp6h/O+C5jOHdPxTmx1kF3e5qHmPeoD2eTclgFJR9ob+sXgCdEb7HmYFlg0nMPKlggnH
	+BLSU6AB6/SK4lV5RKHtVIoL8mWy7
X-Received: by 2002:a05:6000:2281:b0:482:f1fc:d9a0 with SMTP id
 ffacd0b85a97d-4843f87aeabmr6712191f8f.4.1788249701836; Tue, 01 Sep 2026
 01:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com> <20260831203941.0ba48ca2d794d6903d232e5f@linux-foundation.org>
In-Reply-To: <20260831203941.0ba48ca2d794d6903d232e5f@linux-foundation.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Tue, 1 Sep 2026 16:01:29 +0800
X-Gm-Features: AcwNN1UjSmK9JlzdsjDt_-K8RAww6ar8zn8bB36xbjsubff1PKRSHwhl8WjVIjs
Message-ID: <CA+qSx6xcm=C-ZFDfzJATRq5yHH0WGdg-15H0Z_YSA=HvFLP+bw@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] mm: avoid large folio splits when swap is unavailable
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org, 
	ryncsn@gmail.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, ljs@kernel.org
Content-Type: multipart/alternative; boundary="0000000000003f71f5065a67541c"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BBFDD18000E
X-Stat-Signature: ex7hrdpsjiakgccrofsebiksmgskycmc
X-HE-Tag: 1788249703-74829
X-HE-Meta: U2FsdGVkX1/wcGfJjhr6rf5hy6cobWtKfkGbIemZX93i08PprfadckdNVlZthQzch6Cwunh8r43T0QT+YEs9C6xPgD5h+wknWN101hX0Ag4dlUDBoJzormZPCnPpqI611gfXLf7LikONSABGryF/BCJRtowFFNNAM6/+JOhVmGYOTp77umUP/3wBekBVyxLncFW2uI4LcYeLmEIfPNxzx+PQtpn3uiMlc6fItD1LJtFTuz2E9IkOGrtS5J4IVgpHgIxxZyco6vfQalcYkbEdOEJwL2il+HRP+daMm9CnHKYImA3X+q404l7oodTkpCyFmZbME7GYestXfxjxArSdvQAjWvvo6l+svtB7DAXp0USf66rsQt3lsp4qBdKtaiq+pVXo9xAp5A49UzDyrRSUplE5ndzb3zHP0J4Lz6ePo/0ZdCZ4Oop9cXHofCoHBxpX3URkfKTXthOrVe/7F0N8Km0exVW+H8m6LgqCpPCsciODlq7iuzva1VaFOQCm0PF/pefeD/9mNLluv+9x+UzmTGIxyt6abaS57QP+vl8NGGgV+XiMesxNDnYRInapYgKB0Au0nS73b3SI+/YRw7mzcwI6aAfC+g+oPP/q1F12EpQjqpYOJZc1H/gmj1How0mmPr+MWG5T3PS5+qtLGp+/K04DyU2lHqbUdP0on4lwk3BrozJYMapdw91CbNXlaJLCVnnDFX43j1QTCU0T+nYoYI7yfbBk9HJeQaNsGtYBK4wGPkHjp9h3354SMY0VEw/KnohSpCmFsGjGfOfeB7Czsn5Cs/5XSOvK7e1BBcy+6q8r4mExSLAvykSB64Vhph14zXACIUfC84CGVadk0/QcOxKIZgqKIdyJcwbWeMEdsRAsKej7/BjVwEm2X7ltdeGVHoXIWq/vgpLjZklpcGAeoURdvpnfjM+wW8S0E5fkOj31ru2aehpcTePdVV5NcQaKR+sm5Ra2+OucVHEbtSt
 FUp9fM6h
 W5gBPyS06XPobqiwvViQp0XKkqxQqbGjfMin1E7JRhAAK0zmtpZCFR2KiTdzQSK3Ut0Ofl3TDuYFE0vRWCEh17jSvKhKgkdMMgC5TkV38VFQsroVzkDFZADaIRolGRaOcR3qZ76NTJVIWXG/JfRPzbJwvSwk1nf2R+b2Wu+jiWnUe30ms58W1tly2jCII1+c5AOqNtdo/vzaIdag4MVopfrUEf6w4Mqju0UzrvTiIjyulGmxVS6amIZV3BriTuaSAeZA7narDZXr+1iDY/jqzzPJnTc7eWAImivyCxhKZYmTPFvBBx7wwJmgnR303iDrch3ZwFNaItcvEFksszG5xXdF8Qa/tb14DZQfPL4+eBRrfwhG1nbJzjcHiQteM9jrfXi2OxYLOy5qrGBowsc9EXPRKEugVLbbYIfYFpDZIJD19jW/GLUMRJ37+Ii7V9MBYZUDR69N5mmoY65XV3M3m1p1mtowQkXoc3P3PVzxJdfZr2PMgalAHUvGp9zdD0rdNdw90T3oJ/QR+f8vG46sWNS0A8R8sob5I7uvyNbTQPKxsjgVQ7mqiXVdE9UpC5HAedIlCClu0fhVZr+c5bac5GLgIBGBQSQ3iiGDon6wgxx56aElBNMg5/V178DZnfNDP18BeTZ6hOXOfQCsIihxysSKOI87xxYmxW55Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000003f71f5065a67541c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 11:39=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org>
wrote:

> On Sun, 30 Aug 2026 12:29:16 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com=
>
> wrote:
>
> > This is v7 of Barry's original RFC patch, "mm: Avoiding split large
> > folios if swap has no space":
> >
> > https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org
> >
> > Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
> > large-folio split counter increased by 1024 even though no swapout
> > progress was possible. Skipping the split in that case kept the counter
> > at 0.
> >
> > This series makes folio_alloc_swap() classify failures according to
> > whether splitting a large folio might allow swapout to make progress.
> > Callers can then avoid destroying the large folio when neither global
> > swap availability nor the folio's memcg swap hierarchy has capacity for
> > even a smaller folio.
>
> Thanks.  Sashiko had a question which didn't occur against v6:
>
>
> https://sashiko.dev/#/patchset/20260830-folio_swap_entry-v1-0-7786b52acbc=
8@columbia.edu


Hi Andrew,

I think the Sashiko link points to a different series:

[PATCH 0/8] mm: remove page_swap_entry()

The Sashiko page for this v7 reports "No issues found":

https://sashiko.dev/#/patchset/20260830042920.2280454-1-xueyuan.chen21@gmai=
l.com


Did you intend to link a different question?

Thanks,
Xueyuan

--0000000000003f71f5065a67541c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Sep 1, =
2026 at 11:39=E2=80=AFAM Andrew Morton &lt;<a href=3D"mailto:akpm@linux-fou=
ndation.org">akpm@linux-foundation.org</a>&gt; wrote:<br></div><blockquote =
class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px sol=
id rgb(204,204,204);padding-left:1ex">On Sun, 30 Aug 2026 12:29:16 +0800 Xu=
eyuan Chen &lt;<a href=3D"mailto:xueyuan.chen21@gmail.com" target=3D"_blank=
">xueyuan.chen21@gmail.com</a>&gt; wrote:<br>
<br>
&gt; This is v7 of Barry&#39;s original RFC patch, &quot;mm: Avoiding split=
 large<br>
&gt; folios if swap has no space&quot;:<br>
&gt; <br>
&gt; <a href=3D"https://lore.kernel.org/r/20260618221720.71768-1-baohua@ker=
nel.org" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/r/202=
60618221720.71768-1-baohua@kernel.org</a><br>
&gt; <br>
&gt; Barry&#39;s RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP=
: the<br>
&gt; large-folio split counter increased by 1024 even though no swapout<br>
&gt; progress was possible. Skipping the split in that case kept the counte=
r<br>
&gt; at 0.<br>
&gt; <br>
&gt; This series makes folio_alloc_swap() classify failures according to<br=
>
&gt; whether splitting a large folio might allow swapout to make progress.<=
br>
&gt; Callers can then avoid destroying the large folio when neither global<=
br>
&gt; swap availability nor the folio&#39;s memcg swap hierarchy has capacit=
y for<br>
&gt; even a smaller folio.<br>
<br>
Thanks.=C2=A0 Sashiko had a question which didn&#39;t occur against v6:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"https://sashiko.dev/#/patchset/20260=
830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu" rel=3D"noreferrer" tar=
get=3D"_blank">https://sashiko.dev/#/patchset/20260830-folio_swap_entry-v1-=
0-7786b52acbc8@columbia.edu</a></blockquote><div><br></div>Hi Andrew,<br><b=
r>I think the Sashiko link points to a different series:<br><br>	[PATCH 0/8=
] mm: remove page_swap_entry() =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<br><br>Th=
e Sashiko page for this v7 reports &quot;No issues found&quot;: =C2=A0 =C2=
=A0 =C2=A0 =C2=A0<br><br>	<a href=3D"https://sashiko.dev/#/patchset/2026083=
0042920.2280454-1-xueyuan.chen21@gmail.com">https://sashiko.dev/#/patchset/=
20260830042920.2280454-1-xueyuan.chen21@gmail.com</a> =C2=A0 =C2=A0<br><br>=
Did you intend to link a different question? =C2=A0 =C2=A0<br><br>Thanks,<b=
r><div><span style=3D"background-color:transparent">Xueyuan</span>=C2=A0</d=
iv></div></div>

--0000000000003f71f5065a67541c--

