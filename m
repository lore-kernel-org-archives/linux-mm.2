Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 017F8CFA76B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B496B0088; Fri, 21 Nov 2025 05:32:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B966B00A2; Fri, 21 Nov 2025 05:32:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A366B00A8; Fri, 21 Nov 2025 05:32:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8406B0088
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:32:45 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A249E89924
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:32:44 +0000 (UTC)
X-FDA: 84134250648.14.4D163D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7125914000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:32:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kw2sMc+i;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of yizhan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=yizhan@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763721162; a=rsa-sha256;
	cv=none;
	b=xOQ5ydXeGGEIuzswHEJS1l/a+sufJWZavPmhlFc5OIHg88hT62L2Zwvef8oGAEzObMQED5
	/cUnvcy1vDjNydH58akXmvPoRxeUcC0hwhUPnrKXs/2+cGj69xS8YjpixPm4uJti0tC9uO
	NwUqZ6OS2HE4C/G4DCQODtQc/P6xI7s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kw2sMc+i;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of yizhan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=yizhan@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763721162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdAkbekJFyMmA5YDifKhnhvomu4HpXjr8UsibrhCSR4=;
	b=PA4xN9s6L3xKD5xz2ZuyVSAQrpWOJg/zDOP/OA/nM4RAvdkjPtf4FZP/ddKq5vS+12wGWS
	jN98AVHB7gKQglpTYQu39Bor51ABpDni9ccLNslbdwky9ULU3aj4+jh7hXHFzhjDUBfMDP
	k9z8eY9Somf163DX6IA+mw804tt/18o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763721161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pdAkbekJFyMmA5YDifKhnhvomu4HpXjr8UsibrhCSR4=;
	b=Kw2sMc+iD5pbHTuJrVybtgT0RVvOYaiQqe9U+m+pyr3k45XsseBcHC8SOvGFnSkhsAJSEk
	42XvyU+OysU7/oC85wRJI6wu5Xxv7PuwWGNzIBk8oqz2iVPmEUGNUvQcb018YItnQUdvze
	NV6OHn31w3bDhuJMW7gs8EjQHtAsyqU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-9ocipovDOkyOiO7QPRuI-Q-1; Fri, 21 Nov 2025 05:32:40 -0500
X-MC-Unique: 9ocipovDOkyOiO7QPRuI-Q-1
X-Mimecast-MFC-AGG-ID: 9ocipovDOkyOiO7QPRuI-Q_1763721159
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-37b926d6633so8645411fa.2
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:32:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763721153; x=1764325953;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdAkbekJFyMmA5YDifKhnhvomu4HpXjr8UsibrhCSR4=;
        b=WoH6ylN7meecZbDBzM6Whqd5m/A3hTOkOOwrLhzaWQEY6ksraQNFXjx2wQCrbgPN7O
         ksAv1FwEizpinH9AwuRNCkupekToZbpSy+kt37D48YaoRHjXd+52ESAOsBrKHR/nxIjd
         NbfjmGTRIlBd5uATRzotJ4kXnOFXkiXELOkbaJJWy/6EwfrPI+URYGuY+57q14UnJltE
         OWQdChl/nTIn1QsTH0GPNtG1qu9VZ8IFk+pS6M48OWxON7jWFNnG+ui9/Rfc2lam7yOM
         3llWBK0CjFgqCHDE3oPqovZpkDtwVXaki3HmPRqxpWD16Z6Pet76qF/mmwcc5lIs1xnb
         kU8A==
X-Forwarded-Encrypted: i=1; AJvYcCXTo0FtCZgA8ZRe0kPW+b6H2j1Fy/WoR4sPIwjVAJCaX+6vcM2ZLgXwGDRnjcLtykOCdwrbI4LZrA==@kvack.org
X-Gm-Message-State: AOJu0YxSz8TkRQucmFGNILAToma+d8ekMspakvIZhBuR3BYh/s86sKIq
	xwMaJFE/gKnpjuj17WJxYdEu/Iu6ybEyx0KGorbWqYdPHVagvOlzYdVZ1tBvPiWxNMdrfZC+gdn
	K9ounf/IWJ6zuhckC/W/NrpJG9CPFUEN0BEaZzXHnrauqdmNHvpgVBL+lQnLrlW5tYhhJd3mq52
	MITUV+bgxBLv1W24g7UAKxsa+kcRY=
X-Gm-Gg: ASbGncu216cWlAcFQJjUPng7HiehA+ImhR0j5MBWaItpKnU64KVtzaszVaSpTdLHxCh
	+BgrscVUFywQiOJdo/x/HaG8Gk6o56KHlrfZP2DhD2OIsDgXc6b7+4a0ZndFxqEInTq4t2TPTLW
	xNfbK2mwKeQxsEySjxStFjWNjAwa0oM9Mbc7nKmuRgMgWEZ58iZUaZ6Rr/atckXznyRZc=
X-Received: by 2002:a05:651c:41d8:b0:372:90ab:8bbc with SMTP id 38308e7fff4ca-37cd9286492mr4036901fa.26.1763721153408;
        Fri, 21 Nov 2025 02:32:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEBeCjd9H0jTyvzE9Ry3a6y4ZV9ufqW8k6XrHgrtjOO6RsQhefSTUnhY05u5ZyBQBaHwCHRhtYRtP8/SKyXLmw=
X-Received: by 2002:a05:651c:41d8:b0:372:90ab:8bbc with SMTP id
 38308e7fff4ca-37cd9286492mr4036761fa.26.1763721152894; Fri, 21 Nov 2025
 02:32:32 -0800 (PST)
MIME-Version: 1.0
References: <CAHj4cs9Ez5f+SsHMcbYVeKGScuL9vq71i57kRgu2KneRtXRwmw@mail.gmail.com>
 <05281713-80b3-4199-8e76-672e84fcc33e@kernel.dk> <CAHj4cs8+Xgz1qgf3H0sDMFhVAmzb9EsVmuJoRLBOgP7bQymodw@mail.gmail.com>
 <CAHj4cs_4-5g5oW-Wx7KwceALy8F-Ku4cxQGMZ88ARpvZN4HRjg@mail.gmail.com>
 <CAHj4cs9AUA94ntY0uhDDAmoWTMA3kxpSCArKG9MHcgkVASJfAg@mail.gmail.com> <e281da57-caa0-4e36-8ff2-80175bc43090@suse.de>
In-Reply-To: <e281da57-caa0-4e36-8ff2-80175bc43090@suse.de>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Fri, 21 Nov 2025 18:32:20 +0800
X-Gm-Features: AWmQ_blhRlbpZIwmkooeOO8KYiXmisZ0C9ZDsJzS4GknGFaK1rM4x791j_04cSE
Message-ID: <CAHj4cs-mxgZ+tWXgOfjYx+X_bC35zBHyMbNYcCUuHe0JPLsHWw@mail.gmail.com>
Subject: Re: [bug report] kernel BUG at mm/hugetlb.c:5868! triggered by
 blktests nvme/tcp nvme/029
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, 
	"open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>, 
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Daniel Wagner <dwagner@suse.de>, 
	Ming Lei <ming.lei@redhat.com>, linux-mm@kvack.org, muchun.song@linux.dev, 
	osalvador@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3uAaR5WKoNim5b5--aVwokJvajI8IWf48oc7xwHpeFs_1763721159
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="000000000000cd2a0506441854a2"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7125914000E
X-Stat-Signature: jgwxfja7ude6ez4fjwyq1tq7pazfdo5e
X-HE-Tag: 1763721162-366818
X-HE-Meta: U2FsdGVkX1+dRYRyRldJaYKT1Jf4b1l/czqHiAA+TbA5xvA5nTTUL0lTFEqVy09rXfub7QpPlnqiMOP8aoP28TfqdjCv7uIH/Xc1pVZcQRstPWd+0/HiuwdTxDhUi0R4YJByDzji3sG0jZwOJ/7tNIMeAziH8FIcAHRqLAhIq1frovZSCi6yRw51t0sWHakUrx87JLk/AS1VC52FjiZWO+oPl2DPkEJBCz0JnYMbP5oeLWw5GE78qV05nVEwRNGJ+oHwgnf32sc09vaxx5hJU2/ALthjJgntuC9IY/eK16WnxHUu3ggxGbgl47+8g3Zue1dhJoSaGX62csc6VYxeKhySQRcQ0b07ANxe5GFRNxMiHCUCJCXvYJwDj3qf+zEpf+h78A75oxO5C7B6uW2Bf1bUcxxTaPRJ/L8c2Bm+lPKQs9S8Kvbx+LAJgCSLcPBiQ7cSnKR26Z+1Rx19jYiBcZG/9ZugObWyKJNZp1z063RtU27/2n0ua42FuEoY1nVDvux5F4yjvNHTUtcUQAQHv0FvtRBZDU6RLUxJXtT2hNVH2cnb9G3a5V2o92OUSG5tgTMyOlEijRqsOQWMNjEpwf1+V3S1m9kfcyF1H0pEgmeTOFRHzsUraJs/u0U8rSGHUN8QcaMu3l/cjm7SDoz+lIDp+zkk+PSWAmJQ7gT3GZjuPoZzhTDftb/21hahRkkO2O7P3LGKytAO1PWButmE51yvs5L5NJwki9maqbWTMQAJJy0tiky9GlLy+r9JNBGiOi0NMTisuTEwuITvaT4yrJB/qabvglpYSXK0sk8pxcyTpeIJWAAH0TfaQxYMtRfMSkOW5O4KQJgHGY6aEQEF+SoHuwW2iHLf7BAXz3XSoIRelO1yn6D6MDvLl7sBj8W18G7ijorUu23NO9vmvIv0wEFnNNJ+j6R2F0h7yQvx8Ao7yrjF7TIAQK+X0u9JmTGy05lZeMsSBD2IzG/OVYr
 VD726W/N
 Ei2paMpWqc/ksTKUMxTPEFTmBaewELqUNhP5jwHOFqultrpuK2oWAupR1CUSsKqAlfCcooBEBc4KVlyNV2Qp8Jl05CTyM8WZN+1MZwJcyiDfYdBMDlQMOMFhRybwtX2BrrkcrHKgOGWLAe8k6CIo6fnh9b5RM04h0abTCamv9CGH34OE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000cd2a0506441854a2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 3:44=E2=80=AFPM Hannes Reinecke <hare@suse.de> wrot=
e:

> On 11/20/25 16:18, Yi Zhang wrote:
> > I did more testing today, and found that this issue cannot be
> > reproduced if I don't set the nr_hugepages
> >
> >
> https://github.com/linux-blktests/blktests/blob/master/tests/nvme/029#L71
> >
>
> But is the inverse also true, namely _can_ you reproduce it when
> nr_hugepages is set?
>
> Yes, it's now 100% reproduced in my environment.
CCed linux-mm@



> After all, there seems to be an issue with hugepages, so it's not
> surprising that we don't see it if we don't use hugepages...
>
> Cheers
>
> Hannes
> --
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich
>
>

--=20
Best Regards,
  Yi Zhang

--000000000000cd2a0506441854a2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Nov 21,=
 2025 at 3:44=E2=80=AFPM Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de=
">hare@suse.de</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padd=
ing-left:1ex">On 11/20/25 16:18, Yi Zhang wrote:<br>
&gt; I did more testing today, and found that this issue cannot be<br>
&gt; reproduced if I don&#39;t set the nr_hugepages<br>
&gt; <br>
&gt; <a href=3D"https://github.com/linux-blktests/blktests/blob/master/test=
s/nvme/029#L71" rel=3D"noreferrer" target=3D"_blank">https://github.com/lin=
ux-blktests/blktests/blob/master/tests/nvme/029#L71</a><br>
&gt; <br>
<br>
But is the inverse also true, namely _can_ you reproduce it when<br>
nr_hugepages is set?<br>
<br></blockquote><div>Yes, it&#39;s now 100% reproduced in my environment.<=
/div><div>CCed linux-mm@</div><div><br></div><div>=C2=A0</div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">
After all, there seems to be an issue with hugepages, so it&#39;s not<br>
surprising that we don&#39;t see it if we don&#39;t use hugepages...<br>
<br>
Cheers<br>
<br>
Hannes<br>
-- <br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 Kernel Storage Architect<br>
<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 +49 911 74053 688<br>
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg<br>
HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich<br>
<br>
</blockquote></div><div><br clear=3D"all"></div><div><br></div><span class=
=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_s=
ignature"><div dir=3D"ltr"><div>Best Regards,</div><div>=C2=A0 Yi Zhang</di=
v></div></div></div>

--000000000000cd2a0506441854a2--


