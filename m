Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6DBF433D2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3971D6B0005; Wed, 15 Apr 2026 21:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347C46B0088; Wed, 15 Apr 2026 21:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236246B008A; Wed, 15 Apr 2026 21:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 116446B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:11:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCBCE13B346
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:11:09 +0000 (UTC)
X-FDA: 84662640258.06.25273D8
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id B82FF40004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:11:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEYakgxe;
	spf=pass (imf27.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776301867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qrrhmgmZDYw5E+hQ224f5Q2lFV/TMwZnRK3/UV1354=;
	b=T3kczZEPdUeRpRjpdtwdl6gj55l3FT18sMNlkY1Ixv8MvJMs1XPhJy0smmOGcS+cafnBJL
	XTHVWBjfD2+O2wwpvbcEq/MQrXuc3305RPGl+hR6KYJIgCIXzahZyr8HR4+MynJpRiDSro
	y1I8eTCaFjmgYuxCJmmszlJDWdMdvKk=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEYakgxe;
	spf=pass (imf27.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776301867; a=rsa-sha256;
	cv=pass;
	b=G54m8dvZ7xrpHCA5jAGFB50mYjn9j3eJHmwVtDo0mM8zSA21UBKWqdV06rZMmSCnp3kVtx
	DYAo0fWS9yfrpQG/FqFt5txt+3AwUjkJv4c9DiIjkSQQa2D6lT01f5FrR2d9Kgg6qtSNaH
	ikL7aaL0E2wq/UO6k0GT78nQwgJErM4=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d73352cf2so3653058f8f.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776301866; cv=none;
        d=google.com; s=arc-20240605;
        b=fyUV23z3iXnnYzj+AREnqPp3SM2UWGUVxLLiilgpJrAmfokE5gLuvKKn4HhdA/j0Wk
         B8ailEP8mILsDIqb/krivczlA7mRfAuy4m0w6g2xLyogiGtnNoj9zHdex3JOWd+f/T02
         QasPhfOjFLZ9SdXGn+dNFlDf/Hy8d901dXA1HwVnXZSO0Z7omuiDCXKG3oY/vBd3OOhA
         9UwNYyXOo+4y6ew6Bq/I13luA9hdlt/Tf/7j/fR9jBL66/azFpiDx+kW9LSPAroosA3O
         LbDM1c0oNf2dTkG0eFER03A9LcI0ZbTRZL/+W+GQpOJhkchEDjDYaHArvFEP9FX561LM
         m/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4qrrhmgmZDYw5E+hQ224f5Q2lFV/TMwZnRK3/UV1354=;
        fh=K2ih27N6zRUTj3WHJEaxEymlruoAL8NipbcL2YdD4uI=;
        b=lEqdg4GegjmilqORnKJD87A77Ycay4sOrfE4j1jGGZLott/AtvGMguEkYKFd4uzYxw
         6wO9H5B2PWqOhkV5TNW/q4JY4XUiaZfg/Le1n/dQKQrE/JP6L6q+GYkldrPItdWBQEAN
         qYD1t7FpCRsxqx1sazXamKlxJizn19FjW7NKRlqUSDVCrKxiiDt8VWBODzn4aiAbOq7b
         v2XFEZ/AjBSS3NhBnzxTWUaSL5+bAjo6Z+yl/Li+Wy9hdtVJ9KnBTspLRkNZx3AuLyp1
         4Y4AEbV5rWk87E672OUPOSSHluGWIxVX9IYgmA+B/8bypGihl4qxm065pyJv+dt9aiB/
         M9Vw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776301866; x=1776906666; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qrrhmgmZDYw5E+hQ224f5Q2lFV/TMwZnRK3/UV1354=;
        b=EEYakgxeUjcxND7lfWxkzcn/WOyunfbxsUuUDlYqs+cy5b1w0J79RYx5ZCpvFa/V+S
         C2cTebzQ0NjNhCPRNW83RLlfIHLSfcE8WheJXUSKRdfb3NCWfrMcqqZ9eXFwWkO7nf6r
         NubyL5EcyzdMMyUQnJNj8523tv/DSqqtYJPFdhg+hJEl87BSbs577KWoL18iAEbZNcGj
         oM99FtzQED3dKBAxySzsygcp7hwTq0rl1VxCGnKS5Hs3/2tfsCeLrSuauAhs3ST0Iii9
         RrFBf59JBeUG9JAkLRfDP/0Ng3jQ732wSQOx5dV4s/kUfg8ltXPVJQFIWgvyl6lq0hm/
         oshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776301866; x=1776906666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4qrrhmgmZDYw5E+hQ224f5Q2lFV/TMwZnRK3/UV1354=;
        b=i3jsQoR2CKhClrvrlpe6VECvYYNlaL4k3R3vWoSkvT1WYH23pt4GSYceKKBDKXrxYy
         /6lC8G07hSdd6VeRxrdAYyvWbSxppKDlxpXTW4pp8E460zAxvEdL2EbiR6HTdro32FGJ
         JRkOWwDv7x++AjAjachcRUvgUk8VqxSRTP19EPirOu4DTKflTTQ74yUJCGBvF00AFHIG
         Z0tfkEYvdoUda7O1yPniORfQql+aqpqecV94OzVvVzNE2Cf74mp64Q5uhjsIuVggKx49
         +CdqNs8DWuEwVdeTDtz2WV5/iaQAVMM5BsH3AwAvCJeSOuNMGJU8cYegmVOTnwlqKaBV
         664Q==
X-Forwarded-Encrypted: i=1; AFNElJ+sa1bMWhRr1OZp1ziluAfT9TpaO+wqDGIJIRXjO7Mcr2yPxFKsSio13Kh8oaqKTyv3yVBKvRF8mQ==@kvack.org
X-Gm-Message-State: AOJu0Yyop1O0aNp7qrWn769rhjcR/I/xPPE4ZC8goEawa9mZjJYPdlHa
	2z+w+Z/J/b6FODSGDePg4m0Zi0qSs9vawlWAxBDLoYR3KJUt+AWNBQ77eSABemjCVzKogGjdepA
	OGqwlOtVyTfPb5jxkrPekgAuLMEwuYC8=
X-Gm-Gg: AeBDiev/Ry7riDqsoTpCaO7HaQdnbJJgq5Yki2DnMgDCmZR3gc2+7mfKOhpYVrZN9SG
	uT0kC6kHGDDSP+2Rt+A7RCbPidQZXTZ562d97Dn/CbglkLvXkBRsGOh4yiC/4Kt0ooNeWGhuEcA
	nXmEVYr/2ilVYd/d3h+wCFO6u+7MsRziDmwaX+BCLH4Tp+k4htd9hBtroszY3ozStEm+2YDviFA
	Lx+I23YDjVVK2T1F2fP+DY6VUTK1bW0LeDXrR9SyOGCRr96d3qVOf7jnCs6SzFMUrD9Z5BXwO0D
	zyTDHkxtGz3cB2WG//EzrimIqu6eRy5jc3dOoa4=
X-Received: by 2002:a5d:64c4:0:b0:43b:498f:dceb with SMTP id
 ffacd0b85a97d-43d6427bac4mr31767379f8f.9.1776301865860; Wed, 15 Apr 2026
 18:11:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260203073757.135088-1-ahacigu.linux@gmail.com>
 <20260204033553.50039-1-ahacigu.linux@gmail.com> <4FEDFC64-4EE4-4FC5-98DB-FAF9182FDFAB@linux.dev>
 <CAJuCfpHRgc-xBm=wYyh+AgD7FhJ93y94dw9JDzgBS1v_=bqCZw@mail.gmail.com>
In-Reply-To: <CAJuCfpHRgc-xBm=wYyh+AgD7FhJ93y94dw9JDzgBS1v_=bqCZw@mail.gmail.com>
From: Altan Hacigumus <ahacigu.linux@gmail.com>
Date: Wed, 15 Apr 2026 18:10:52 -0700
X-Gm-Features: AQROBzA52HtVTMOGwDtsLbIPDmd5IJuhjTtmCxTsELApsmkhaRRS1_G1fcCiynU
Message-ID: <CALjTKDmVQmQx7J252=oeNiLCcsi0QHVdzJAZaf2e1oYBVRvyMQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/shrinker: Fix refcount leak in shrink_slab_memcg()
To: Suren Baghdasaryan <surenb@google.com>
Cc: Muchun Song <muchun.song@linux.dev>, akpm@linux-foundation.org, david@fromorbit.com, 
	zhengqi.arch@bytedance.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: iogjewptrcxtz8iakch8jp96bticarm1
X-Rspamd-Queue-Id: B82FF40004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776301867-609050
X-HE-Meta: U2FsdGVkX1/D3sCMe2Mf4lD1JFexUHGZboSvGutO3nSX0hPPW73jms53JbN519BBVnDU0WFQN5L1l6xAu+biWoMbuIrvV31q5aTxZ/VP+q0dxiwGnXgSfKHRxyIX3TS9GeomjRXM7JykiuQEHCZdljwtgu4dVorfKiyqNWq8zAQRsc11HB8WF1acZ7JFiEGMRUWW4d0PFkFgwNNPE1n7idyuF9fYworoy12qlmtNpNg7FzKw3sm/0EQ7MLjh1fgLMIIdTyDAnTIIYSP8r6JGvWndaJuqUyXvM/FPZJwOp3/a+toJGzYaVskoVfAIhLv5oF4mzG8/gdREtn9pHn2Xxc29a0y3Uvatl0kSSPRtSkOLa1r312DEbX5ZvPJ0gmrFc+yRTVpap7lGoqP1T+lPNdw7RMf9bRF7lbT/3GLhBMYnJOgyEJlE3f3l2BW+7/PuJw/HkuczDSOI8JPKWkQUDoGf5hQyG/sXR0/NKazyrPe2/Oh/4vLL76QBbAs5u+rs+o5ZLNwj5XShqfry89nSC6fIovpBDZE++hz8AwB6zEo0kEmGqs2/eFg4OMaUQ2Aw+9vtq8FoXcVjwKpFZTaIbqx7VCQ4xQYIn/RvrBFjhr9vMjuMmpbr4NSJks7HHDdgSIg73q15PDYshXyinopW25PsJwS6tunHQH8upYOpphsEb175+AqfjGYqUGRTNgRLkntijj+tZQWcb6dgldPZqMIIf8fqpYEiw/megDRJrzdKrxO4pq7AU7CRcIIfeV/F043hWy1ACq6zY7NPvYGZGjS8ScG3RahN+59UjkvT5Up+WwJaZ72Ps2NBJnBasQJyKAjbR6dTMv7RUMO2mhHavrE3FmLzycr8mffUBBwFBhEnmJZ1z+LFCVzK39dxbKGC9oUPIohk06LlwqVfOXQqiZ7UaJwxBtEJj4ORVBM3tY9SN3kJGSfCDXykn+ZSu30jCh7/2gtKnFAdC4rHBOR
 9U8KZUtl
 KTi1aFdLolZjLRmYd/WX9DUo9pkgYdTJe9RV4WuHN+UGWmqn1Njag8xp7YUOlYTEVsgzXMnSYnbx2ttltoAxDt+2uNGzYKE5EIspz51TTZUkReFqZvy3mEaO9XksPSwFk+5u9J6WA7ove0HNkDYwpgBBGUlaHwSTo6agmQGVOH4lGKuyhPz/VGvoY+cNIiBv6NXpmiPYRwqvDhIWvP3N0Qr42KrxIuYxvwBexR0CAAwts0iTJwT7LrkjOifIsqh1JxA0YI4RygwHTBEANeULrD6uRffGnSCTxrehpC8cDM8KUpITElhyKiT4XGtByP3u1ii4ubL600zSOH6OUoXEglL4iZajaFgVXuCplYS87I6jruYSq4wi9BCLH66cXi/wBzoqELyhSoRJSgGnPWRBx8KwQBNrxLzcukKI+yfKfJMx7XMMeXVUD3NSJ+1AjhmiubARARiB0yACTIgFIPTeKeCXV9cDNoSG6vFlRU8hDaOzE9m4QUYqUI1l02iGrsDTpM2Dhw6xJFtomT4nXlRHY9o1xRwM1tUbQelevepzTRHRvYwjGyNOfAArwCJjoFfdLilHD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 2:27=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Feb 3, 2026 at 8:00=E2=80=AFPM Muchun Song <muchun.song@linux.dev=
> wrote:
> >
> >
> >
> > > On Feb 4, 2026, at 11:35, Altan Hacigumus <ahacigu.linux@gmail.com> w=
rote:
> > >
> > > When kmem is disabled for memcg, slab-backed shrinkers are skipped.
> > > However, shrink_slab_memcg() doesn't drop the reference acquired via
> > > shrinker_try_get() before continuing.
> > >
> > > Add the missing shrinker_put().
> > >
> > > Also, since memcg_kmem_online() and shrinker flags cannot change
> > > dynamically, remove the shrinker from the bitmap to avoid unnecessary
> > > future scans.
> > >
> > > Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")
>
> Sorry for noticing this late but 50d09da8e119 was introduced back in
> 6.6. Is there a reason this change is not CC'ed to
> stable@vger.kernel.org ?
>

Right, no particular reason; it should be fine for stable.

Thanks,
 Altan

