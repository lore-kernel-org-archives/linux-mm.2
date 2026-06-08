Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1E9CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C4D6B0099; Mon,  8 Jun 2026 04:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03B66B009B; Mon,  8 Jun 2026 04:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3896B009D; Mon,  8 Jun 2026 04:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 900B76B0099
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:35:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46FFE409DF
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:02 +0000 (UTC)
X-FDA: 84856085244.02.1DA8444
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5ACC540007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eGcPKxUH;
	spf=pass (imf07.hostedemail.com: domain of ruoyuw560@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=ruoyuw560@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780907700;
	b=O7G6Uuxc5cW4JnYpdDC0O1GY9jaLRC3lba/A9Q33cd/uzS/HFnxnVk/OixIrmZU4SB3hVW
	Rpqw4ABjB6MjUQ/ZKhOzquqJp9yR96yHMm5fotYpQhCfFTr5BL2VJYMVt9jVUi7KkeUjyA
	yv49HfiA5ciU7t1w/Og6ZvIbAGOyXaU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eGcPKxUH;
	spf=pass (imf07.hostedemail.com: domain of ruoyuw560@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=ruoyuw560@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GI9HyRivvXFEnmqNkS1Rb0d5x/ibbUpDkgguHD0gNns=;
	b=rwyOfSeNMLHPdHbNuZ1wJW7laNAe8p8jyBTXwukV3UN+FUPKtVJmOrpQLVPNnWfP/LEzC3
	k2yTNFsepXVztCKChSTvCpaboPo5qFczZP7EVb8vHv9sUL7T/d4z5BuK5cw/wFfhrUO+XF
	v91dFm9rHrem/oO78ak4/ksL4v+VOMg=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-59bbe027424so3381626e0c.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780907699; cv=none;
        d=google.com; s=arc-20240605;
        b=a6Dtzud32cscjvIY0j82rubfmu9zpFkuIr9UfZFriYS1QSQSjuVTBq4R0Z66glpTHw
         tkX55d3BLyFISy2V4JvtNooKICsjlbrr7BZAH2IdI8gn9fPLTrqUY/ryvW31EEqXriuI
         OhiEsdJAcLM6I6Sck8VapecBhY93CbQDIqNgzSbK3oyKLBl/EgZo4C+R/nUDz8joz5LK
         rntFjKYu3deCWj+kF3fQhwS2kRUzLxpN2vD1tysb79tmnqGkcNQTm11Scap26sFULeNH
         orR8JlF/UL2dj1SWvdrXkIBlO6CYasBhWJdTl3QBfGz8jHONANs0J6lOQP1IhG4VjHLW
         WMbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GI9HyRivvXFEnmqNkS1Rb0d5x/ibbUpDkgguHD0gNns=;
        fh=azYjrwjZ+QF5toeaF/OpvzmkSXDoAeVFtpwEARZSUgo=;
        b=ZdYd+yYKTNy3eDCH4DVheMz4gd3fRycbKgEJXZ0mThL0w3m86VmMr9ldpvBATBSRw4
         zVOtmMwCEv5wG4adgFcub+rlST31HpdEcJD73yBAek9n/rxiBIeq3A0wUIHIm3kUKtgl
         BKRMwnRbWTBLSd6P2paLMQMde9anKmCx78JeraK3EVHf0jdOpjJauJS/tAl7EtQj3Yoz
         0iMd0yqfMPbQz9M6SNSwlnpb+yp77SfXj9/goWxNg5V4SZZcXoC0DIptCLCY/cJ1asKz
         vxx2p3M+IK9dIuQ6BNA9OlhZ1uwFPZtEhrODgxdbPwWz2P/AuQfx0yorcCiW8wKc0BVI
         aDYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780907699; x=1781512499; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GI9HyRivvXFEnmqNkS1Rb0d5x/ibbUpDkgguHD0gNns=;
        b=eGcPKxUHx8HAy+fOtjNxT5hg8r2HsSjJUYNu/5jgHSQstV627EswR2ZdUr10dTByQ7
         BQ3CJiyqpfp/D2rfORIsaO3DccrVzbfcbswloJwUwsNasYEcb4l3tMj8M1jRUDu8UunI
         1P9Vg15XJTZlYoTjUa5905LFwNTP565M/mzs+YW+NdoasGisX/5eZ8Rpc3bJaX53N6VC
         ePqVzfrJ1lE8XQFZ8hnf1d7nqluRBx7TdfbnlTnMsg8AdaHbckdQBFpcnHAdPZ0eg6z9
         huUScrUGw4ZgV8XYpdoiLkX6GfoX0WezLYMx8zWoldNPK/iZcCgekOCxg21k9sGSvdN4
         u6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907699; x=1781512499;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GI9HyRivvXFEnmqNkS1Rb0d5x/ibbUpDkgguHD0gNns=;
        b=KXL1MfhBZ1QjfpTXRYPZX0Q4RKpgJoyuD82Buwom/LP+ZMXDbbeMqysAVLORtXQVjK
         utRb9wZ5DN5Vrk/iJWZwMaXZHimnz8EedzIIGFrqkzIC3CjyEA2aqmxhQtGEuf3nLIJW
         FwXy/KLZzmTEvLHo1dk/KdSpimcCACYABQemZ9KNLw65kLni4QjPEgLBDNIK4PwOEB5J
         CGCJGeIvg3f+Ec3D8dxnT7lkGifPaEqZ+ayCM9HadRgggnp50o6F0hpbcLQg2Hr8v1c4
         XcyWgl1QDYHunA2+wt5dwzcgy0CoLDsKaFov2gFUYDvxfFIZ3Gf+QLFhbLF9e3lJNsQz
         z1vg==
X-Forwarded-Encrypted: i=1; AFNElJ9YphY2qhgJC1nuO0ZJtnRnK00TAM7BltuyotNUTTG8RaUoOowldXj6pqSi6kVRq8UU6nsxbyPihA==@kvack.org
X-Gm-Message-State: AOJu0YxJWq3yvsnerroGbBola2yqU3mH4+DerV0F4NITBn8JUVA4msyL
	y21pCFTlaeuLEXISIvPeiBeZJYKtPpdqtwV3Sobor7xpdUr+F9/7crAteWYJwacETPdbINuPIap
	/gN8TrXtdw3WDz9chejQGebg1sj8n4L8=
X-Gm-Gg: Acq92OFl9UF/OF0rDUABuuu+z2uuhzoq2lOZsIxKP67iTzaufhOlRhrp74XBjWZTOrG
	FfBtAWJ2MyJhyN5ooKEMVDJVLV9Y97RAr6jOVfnQdqNiF7hxd7o1HICxZw98xrtSyXtuI+1hWm2
	oBLvybMIClHMDHPZ0nTXnJgFazSKc4zLk57LLJK8j+lOe67pdJ9ao+lDR4DV72sYoTM9MiSxkY0
	ZOnNRoLCm6Cludbzex/TOAKUOuw1KNLxPvaukFnTDVeaHmkBrHcnXRyyZY6qPqdDkDBHnuyUTAe
	WJ54TkjPDHRbWuYf/uNZ4Scr
X-Received: by 2002:a05:6102:6899:b0:631:ec2d:12b2 with SMTP id
 ada2fe7eead31-6feed1ac3ebmr7065800137.1.1780907699317; Mon, 08 Jun 2026
 01:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260608063644.39-1-ruoyuw560@gmail.com> <aiZ3EZZV6LqsTxQM@tiehlicka>
In-Reply-To: <aiZ3EZZV6LqsTxQM@tiehlicka>
From: Ruoyu Wang <ruoyuw560@gmail.com>
Date: Mon, 8 Jun 2026 16:34:48 +0800
X-Gm-Features: AVVi8Ce-bK3bF-qiL5XYy4uPurdqMGonNC1rAfZl6eSsKB-AW_HbDWLDhQpKCtk
Message-ID: <CAK_7xqyyDqNW1+puMSp2LzxmOKxFUx-UO9uGiDKoL7ZTJ8+3ZQ@mail.gmail.com>
Subject: Re: [PATCH] mm: memcontrol-v1: use nofail allocations for soft limit trees
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000cbb0e90653b9e22e"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5ACC540007
X-Rspam-User: 
X-Stat-Signature: 3ejx6acxdodqyg3z1z7331zqrgujw939
X-HE-Tag: 1780907700-650041
X-HE-Meta: U2FsdGVkX192DCJcS9lyneUepnDKJ/kih9cQ3Xui48LJk7f0wy3+ro8q1/b+JCjvPuqjXJAQAie/oqnqLVe3wwwKOVdUyDUQwDllejc8GO99LJJuHoOcYbrfm5JPj7dK5DnhnewX00sSiuZ1OnLkLtGccfVx60NGiK+BM5XiqPqh47Frfi+6O4JkIg90J36d6nJQ4KWwOh4Z3udAZzoTm8VyO4pcWL5vWJl/79/i6HcQH2JmYNYoPDdyMoUHVprCtfwNdjNOX0tl8HqkWS5efz8ytEk8jN53xE+AgaqAOOiexp7Si8vu1w7u8KcqOdEsoC8LKX5SHxSgVfvhPb5212Q2cX1yrQf1D1FFJSmhOOJSEYASHpe/pdAFiPSnXVsX4rhTDtVXzk1/z5qroa/GfFR9GMfSTDiC5rRGjXr7LWjPrb6fPtneX+OYEICxZAu//jtpHSa3utMzL94sx2wE4WxkUQnBGqEcyJusYUxDWYs4GRTHqCXr1jIGRzmnfD0AiZ5Dl0Raoi4htTWNs7wgzQcJNK0+xwRayQVCU34WCSrwcc8F8beFtfJJLwJwIJvfVYEOT6sW/ZlhxUhvGKmHH5991w9MBmC7EF79/mCZzXk07kWL2C1ixTRdcYfCzZjJaqxGYpTVqNgIpHAHECG5WP5f+q+YVQ7LgOvQn2J60/Y0J8RbW1QfoRq2/3qEQUCOP8uC35zGBKAxeCMcOfTCRyX8pvPqZmgUC1k314B6vbtQiJpt+0ve1rQXjlrXSUqsGbz9NfCF51V7DcPimWlRAV1nVm78EJrmzfbsLquy3L8EuXIcr7Jx9upGtXbOCvocqYT30ujEO58LOUOru4VLhZ9rdYC5m/Y3HJmuQsI81ymkdN3BUyxhWZHnKp9zqLJirPXzydWAQzOamtzQJOEQJQN6RgiQR3Z7JWHcP5U7oL22VfcFJW4UpzSU/AAfXodyjrxhHLCLV2Ak3Mj1H4q
 kc2JvWWi
 8IGdPuRU6JrjuSjiK/FgE0rUEJuzR8DaqVYlP11OMBu60wGrs/WchFAn9R1G+1Tw9OBwH8prVnVcwIIgm2p1ofhUFWOBrGyVOQuMawDPmNeiyYNCxDab4JHg/qU2/OTGZcql9XVovLq9pCGg7tZJc3KYeDCY3MJnWJz753dd4hKIVmNrI33ikK52b/wxm0UCWDhsmCscNtTR+ae75S8GMi1W+HXFXh/O8JRvZaUHeB7NYZp6D+JTv8r9PhIw8ASK40nbObX+8Usbl1fq0/d/RZk6rsF+U5o8uVrRLBBDfczylfWlhioHMdQZoV/7Bw1eUwg1B9kh/oToxE69vv/+UwNFzOq19yfp7QPv//bCHZtVyBp5WLDxaX3mqbsjWaBKFdoRc19ZL2FFgHtHebWjT7m6eZJCiiiolqNPudKa5m9aIdP5GGKtoGX0PzIrWGv/pK+8eH4C83aHJBfZ/wA6wiMAk9IL1FhB68fkkFx+AIj6Z3RyEXeBtGgs/7HcjoLL2zCQT3K6DIEa9RpKjwSHwFD2yitsyWi06DozuFY/lEuw8beIb9qUlxwS6cMQTv4AjdZyKgQk8SSEXvLThfO2IEWopQwStqMWnlwc2fxfe5sSvNrW2fe11KGCD6c/rjTq8jRSNyBSEoDjrQJ6e2OZKoeTmyNfxmyjyQ4MAwnib5Hmk2OY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000cbb0e90653b9e22e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

No, I have not observed this allocation failing in practice.

This was found by static analysis and then checked by reading the code:
memcg1_init() dereferences rtpn unconditionally after kzalloc_node(). I
treated the soft-limit tree as mandatory memcg v1 init state and used
__GFP_NOFAIL because continuing without it would not be useful.

I agree this is early boot init code, and I do not have a
runtime failure report or fault-injection reproduction for it. If such
allocations are considered not worth handling in this path, feel
free to drop the patch.

Thanks,
Ruoyu Wang

On Mon, Jun 8, 2026 at 4:02=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrote=
:

> On Mon 08-06-26 14:36:44, Ruoyu Wang wrote:
> > memcg1_init() allocates one soft-limit tree node per NUMA node and
> > then initializes the returned object. If kzalloc_node() fails, the
> rb_root
> > and lock initialization dereference NULL.
> >
> > The per-node soft-limit tree is required by memcg v1. Use nofail
> > GFP_KERNEL allocations for these init-time objects so the init path doe=
s
> > not continue without the required tree nodes.
>
> This is an early init code executing in during boot. Have you really
> seen this allocation failing?
>
> > Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
> > ---
> >  mm/memcontrol-v1.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> > index 433bba9dfe715..3f41a15d8a8cf 100644
> > --- a/mm/memcontrol-v1.c
> > +++ b/mm/memcontrol-v1.c
> > @@ -2246,7 +2246,8 @@ static int __init memcg1_init(void)
> >       for_each_node(node) {
> >               struct mem_cgroup_tree_per_node *rtpn;
> >
> > -             rtpn =3D kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> > +             rtpn =3D kzalloc_node(sizeof(*rtpn), GFP_KERNEL |
> __GFP_NOFAIL,
> > +                                 node);
> >
> >               rtpn->rb_root =3D RB_ROOT;
> >               rtpn->rb_rightmost =3D NULL;
> > --
> > 2.51.0
>
> --
> Michal Hocko
> SUSE Labs
>

--000000000000cbb0e90653b9e22e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">No, I have not observed this allocation failing in practic=
e.<br><br>This was found by static analysis and then checked by reading the=
 code:<br>memcg1_init() dereferences rtpn unconditionally after kzalloc_nod=
e(). I<br>treated the soft-limit tree as mandatory memcg v1 init state and =
used<br>__GFP_NOFAIL because continuing without it would not be useful.<br>=
<br>I agree this is early boot init code, and I do not have a<br>runtime fa=
ilure report or fault-injection reproduction for it. If such<br>allocations=
 are considered not worth handling in this path, feel<br>free to drop the p=
atch.<br><br>Thanks,<br>Ruoyu Wang</div><br><div class=3D"gmail_quote gmail=
_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Jun 8, 2026=
 at 4:02=E2=80=AFPM Michal Hocko &lt;<a href=3D"mailto:mhocko@suse.com">mho=
cko@suse.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddin=
g-left:1ex">On Mon 08-06-26 14:36:44, Ruoyu Wang wrote:<br>
&gt; memcg1_init() allocates one soft-limit tree node per NUMA node and<br>
&gt; then initializes the returned object. If kzalloc_node() fails, the rb_=
root<br>
&gt; and lock initialization dereference NULL.<br>
&gt; <br>
&gt; The per-node soft-limit tree is required by memcg v1. Use nofail<br>
&gt; GFP_KERNEL allocations for these init-time objects so the init path do=
es<br>
&gt; not continue without the required tree nodes.<br>
<br>
This is an early init code executing in during boot. Have you really<br>
seen this allocation failing?<br>
<br>
&gt; Signed-off-by: Ruoyu Wang &lt;<a href=3D"mailto:ruoyuw560@gmail.com" t=
arget=3D"_blank">ruoyuw560@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 mm/memcontrol-v1.c | 3 ++-<br>
&gt;=C2=A0 1 file changed, 2 insertions(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c<br>
&gt; index 433bba9dfe715..3f41a15d8a8cf 100644<br>
&gt; --- a/mm/memcontrol-v1.c<br>
&gt; +++ b/mm/memcontrol-v1.c<br>
&gt; @@ -2246,7 +2246,8 @@ static int __init memcg1_init(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0for_each_node(node) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct mem_cgrou=
p_tree_per_node *rtpn;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rtpn =3D kzalloc_node=
(sizeof(*rtpn), GFP_KERNEL, node);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rtpn =3D kzalloc_node=
(sizeof(*rtpn), GFP_KERNEL | __GFP_NOFAIL,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0node);<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rtpn-&gt;rb_root=
 =3D RB_ROOT;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rtpn-&gt;rb_righ=
tmost =3D NULL;<br>
&gt; -- <br>
&gt; 2.51.0<br>
<br>
-- <br>
Michal Hocko<br>
SUSE Labs<br>
</blockquote></div>

--000000000000cbb0e90653b9e22e--

