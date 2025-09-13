Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E843ACA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 01:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12B28E0005; Fri, 12 Sep 2025 21:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC17D8E0001; Fri, 12 Sep 2025 21:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB06D8E0005; Fri, 12 Sep 2025 21:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C83D28E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:13:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70077BC2A9
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 01:13:13 +0000 (UTC)
X-FDA: 83882453466.09.4E5E044
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8568B1C000E
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 01:13:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SOILg1kb;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757725991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4EUXzuwG8g5dEWMNxsaodZcDZGKV08nehR5jB3hgkY=;
	b=LbyNr0PVfM6bD1qPbaYqrRAHZFm94+Dsa1nSq1bC7L9b0rlz6C/iPfytuAdfLmEnmoV7vB
	efDH4MjcfUY5d8kLzD6QaQTurBBXwme5TnnO/EypicOYaLq/dUQhvD+e5HDJ+QMyYqRlJ0
	5pxf5oMGeJpbIrkyj4ylD7I3PhwSAv8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757725991; a=rsa-sha256;
	cv=none;
	b=nnMyHIj/l6gu2cQ1AOHejQ8mQH7Gjgl1kQ64W6m4LQcT/OLhZ6LWUE5kMYBSpIK/ysK7jw
	6ddVd7/pjv9VK7w9OV66WHj2XsMzloyU9o1YZ8F5lK7k93OyMixTPF4mVWxBbchpDw/qhX
	I+9Cx74wcDPkYxU6GdBFgdqmPdImXVU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SOILg1kb;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45df09c7128so20500005e9.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757725990; x=1758330790; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4EUXzuwG8g5dEWMNxsaodZcDZGKV08nehR5jB3hgkY=;
        b=SOILg1kby6YOCLju4BxeNU5PJe0ny5M+JFfy9qnCM8uCoMr0rnoaU62DFKxLhORoW8
         fCK6cKK+xCCk83GysuybVJ4Qar2YypneS0CumzzLGCr6aJPWEyFeXWDNW23w5dWKrwaO
         o+ruiFB2QjnMTusj9IY/obJ6YCSBploA2f78nw/D69XEakDjK8jbf7eyJnQVs2s0hB8T
         HzwvIrn1+LHHorVwE7Ox+vl/dkGg1ne7lMmikESEJz3SZjJInKxohfQqwdHJDZFFHhBO
         ybxL7Sgp67EDqlb2qr/J3IaGhTbA5Mshd+TNHFwO+pbmOpg9cQzk4pRolFEzP1UMWWDV
         UAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757725990; x=1758330790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H4EUXzuwG8g5dEWMNxsaodZcDZGKV08nehR5jB3hgkY=;
        b=S69rEXKrYP9ORJAf6HQ7mwzm2NVjqNqdQjdLYbhwT9KkCjZxUiEN4W472V+pL49gwu
         r/dDRl4GRVOsBafrz4pCV4THnMnjDAz2zEQOKYFrRvGayFyvqeFcNaTn8fTFhrKAVzq3
         wAUn7N2CdWWqiBawqHxpIDiGzyQSOQui0UxbxJ9we2QfV5k/V+6tqtyUsW4mGAahsxn8
         ujDmsCBfbdWKMAFkUz1zeG6m0nH2om8POSwntREFZ15TIArocBpdncQJSSVKG45zuFJ+
         bYaIZi2TeVyKLib3R6L/7attvaLXI5N9jAtBkAk6GTSGsztUTiEuy6qxeMeztbrKS+OR
         dsSw==
X-Forwarded-Encrypted: i=1; AJvYcCU7mY2diIGWrnCw+CsQKJo/YwG9gASc4ZTo3Ncl6Y9d1GracoUPyZAMlt6njXBhfR7OZbhw4poVQw==@kvack.org
X-Gm-Message-State: AOJu0Ywr20wBBKVT6W4mKvLbIxxL4r9I1UHKZ+nxzCn+z+b82crNmJOs
	gzul+74loEBAD2WVlpH1fXq/VN3p/swA3Mgioc7noZcNyRDlBVd2oQlbv3sXlFh+kUiVGiT1Y6C
	JJzXyj0O/NQvL6k3mxMsmi+xNAnxksXs=
X-Gm-Gg: ASbGncvWAG2uJSntGzRabZHHJlViq7OzCJLAwEIZ15UeoZ9Fz83CcAzjobBcXlTQOrO
	42ul+pxOh//3FHQhqyXPt3Dh8ztQdYTXzE/2nXd0OVyUX1BEOI1D4F9qLdbzuyol4H1cdOl9FIU
	Z8EV9qdFYgWMjhWi9Zu8rCguj3IU735/2suJv30Z8Srfu7OSdX6icMaAMyCOzXINALvlE8ISQve
	tdr9Z7k74nt8CV3wRGqI7GlhOaeMoPAxteyRbSp4Y6lcPs=
X-Google-Smtp-Source: AGHT+IHQusnaWyzqi7z8+SdxxYqLwbP5wSVWYadYvwZ5P+qVKkcPKQAbJQ22ri0ioQfEz6fWXRvmCABTnZivxFQqR5g=
X-Received: by 2002:a05:6000:26c6:b0:3cf:3f1:acd8 with SMTP id
 ffacd0b85a97d-3e765a2367emr4974884f8f.28.1757725989506; Fri, 12 Sep 2025
 18:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
 <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
 <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
 <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
 <CAADnVQJuAo5K417ZZ77AA1LM5uZr5O2v1dRrEEue-v39zGVyVw@mail.gmail.com>
 <rfwbbfu4364xwgrjs7ygucm6ch5g7xvdsdhxi52mfeuew3stgi@tfzlxg3kek3x> <CAJuCfpHJEUypV2HWRHqE598kr-1Nz_DokMz_UgrUnq8YkFcb9w@mail.gmail.com>
In-Reply-To: <CAJuCfpHJEUypV2HWRHqE598kr-1Nz_DokMz_UgrUnq8YkFcb9w@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 12 Sep 2025 18:12:58 -0700
X-Gm-Features: AS18NWAQ_JVZ6ksw_Ihjl7aesVBJtv75f6ANMQoytxQD4Xbw-t5oGghb1fY5kzY
Message-ID: <CAADnVQJQo6+AwJ_LxARVu37J-5T-7tyn1kA5hMVDGDfEyjF6mQ@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8568B1C000E
X-Stat-Signature: 33pk6ycyycpexsgsn3miymdxe11ywbkh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757725991-887650
X-HE-Meta: U2FsdGVkX1/sD04xA16f6tl9noIymgkOM5n/WloDGCDLoAxz09MUDzRcUZ0rcN1vb5XwSn2e15NujP1Sm4KOywI3te/4GNvDvppZeHgvZGaIT+wlpmRczomFkfuSxHCloKDAhE8uRHdSTLmLql1V+nC305pUEUTPlitnjLt+lQTCXWIdsTV7ffjfrH33iAtE92ngDgK8DkO2xMkTl8jM1tDyq4DgihBaWceTPSusFnLN0/Vxxjg70jechVz+FY2gdhCK0P40kzYqHTbep1+64grBxcyf6qT7sI6YotLJ7yBB0f6dBSq3fa0XI+ndqYD4SPidfLQPE6pfiZ/O5nIiIv12Q0oQIhjwCPzJru4Om0cwMlNdcmnZ8yO95UAII8js45Kks1ThSYgQdxtoXa1waT5t8UKAvwO1yoDCRe5h4Ofn2se9SXPTVEQYTStTCtU9kvcfijiACFZ9s5IsBL6JChzWB4z6mykIHR/JfQdXMPLkIWRdai93HKRH7tKVaEv/oo6tv1NAWjJmG6C73rva9WZFpLjuU2kxyHqkmpy3rPh7VDbDgNZAkgzzSoW0eoxzXzXWiq3yk0unv/aJpNQz+4U9R4xlDDCf8BLmZyx6/WlH7JOa6ypdTh01M9VmxuwO3FaddQ7XXgQz1vvn5E8K0AqOhS1ifgwk6wtsx7kFHNAibMiinQV6qhW/JcMP/EjzttH12R/Xn8+3cx1naxJQPbb8izyBJkDwwFSfvsU8pT/bztHBWrlybelQnpq4W3MaiwDH60AaNVGXHDuii7RSVRVv0GtMfPZrk3qIg64ia2LiNYduqSWeked0KJTbN+xFvsnY+OR9Qe/6tW7XgQ3tptaCLL8YFlipQl/ABvmNTG9IVdR9ZsEt04s/EYz410P03njsZ/apdoui0kIYEA9NNmOynWSTbSo2F5XW8s2RPiVohaW2GmPh3tSxohSnyg4c86nF18oFDJI3NeP5gj0
 +xndtNm6
 uYORHp9fCbu+MHML3H7uUN6+ZTyh5AFJBHPUd5MtdIt84EFNaURRv09E+AOFTYLFtuGocya8ozC6psLM5Dx9iQ7SPCwJF9IomnvgWAiJ0Wjh6qAuuTKkcVcu4xPpsxECakSNh/EipzWGvZAeZnjOmMY/bHwaL8sIPHZaDgEd1giC/oRdzHGwLC38ddtTioTenm/2VtdeMtxLhWJYIvxqdYS76rAhl0k78Fi0IgSAWb4WQ38SEmZZKPP29QVTr8Dp5O3pDvZYLX33SRxfdhcKZweWHqevtdaEdU1KSRhM7avdFhmqKjc2l3knY3vqrv4/SL5pMKxqiLLs9kwV+fs0Y42XbZKb8HdVOLlG8Nej7Dq1wfiwtMHvbH0b7q2mlmKCktohpF0E3Fws2x9l6ZBepvMw6mq/oAqL7IcuSLlpoJ7PiiXxLwJQ7jsCc5/fgS2MPLDOqPcIOzlTg0nA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 5:36=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> > > > Suren is
> > > > fixing the condition of VM_BUG_ON_PAGE() in slab_obj_exts(). With t=
his
> > > > patch, I think, that condition will need to be changed again.
> > >
> > > That's orthogonal and I'm not convinced it's correct.
> > > slab_obj_exts() is doing the right thing. afaict.
> >
> > Currently we have
> >
> > VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS))
> >
> > but it should be (before your patch) something like:
> >
> > VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS | OBJEXTS_A=
LLOC_FAIL)))
> >
> > After your patch, hmmm, the previous one would be right again and the
> > newer one will be the same as the previous due to aliasing. This patch
> > doesn't need to touch that VM_BUG. Older kernels will need to move to
> > the second condition though.
>
> Correct. Currently slab_obj_exts() will issue a warning when (obj_exts
> =3D=3D OBJEXTS_ALLOC_FAIL), which is a perfectly valid state indicating
> that previous allocation of the vector failed due to memory
> exhaustion. Changing that warning to:
>
> VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS |
> OBJEXTS_ALLOC_FAIL)))
>
> will correctly avoid this warning and after your change will still
> work. (MEMCG_DATA_OBJEXTS | OBJEXTS_ALLOC_FAIL) when
> (MEMCG_DATA_OBJEXTS =3D=3D OBJEXTS_ALLOC_FAIL) is technically unnecessary
> but is good for documenting the conditions we are checking.

I see what you mean. I feel the comment in slab_obj_exts()
that explains all that would be better long term than decipher
from C code. Both are fine, I guess.

