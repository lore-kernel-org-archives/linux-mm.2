Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA65BCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E7A8E0007; Tue, 16 Sep 2025 14:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F5E8E0001; Tue, 16 Sep 2025 14:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDD48E0007; Tue, 16 Sep 2025 14:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3D18E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:35:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E24CBC0289
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:35:50 +0000 (UTC)
X-FDA: 83895967260.15.71C9E37
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 103EA18000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:35:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gvY42MzB;
	spf=pass (imf24.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758047749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jv7oaIHfrPnWolRAUwMAHrfSaRXeenaXfJ1eWBHIqYI=;
	b=mZCbXpGKWXepfsMzvIo77vByBsf2AD3ppUM5YOzuo8J0FmpRqmmjgd7Svd7Y8g+ZK272ZU
	hJFcn1DD0pd22eSTw40cX/++lf3n2Km5+jbMEkx4cn/xJgokAi9keDwz4adLfMNXTner9E
	1wbuQYuhbV1TXqBKxl+RtQaH4zv4DVw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gvY42MzB;
	spf=pass (imf24.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758047749; a=rsa-sha256;
	cv=none;
	b=rQvz3TEnOI871nf7bj8a/T+dns9aX3eyXZrEmQ/MKGyht2mpF5T7L3ukzi3HgNkok3AKcS
	tQOewsmCne0X2vhFaljKGW2Zv5tgXcakiLrkVSFgP560s64LmmzXMaSYGgyjD/o+GH4Y8l
	98Ak0VrWrhv+FFuaqE1AKJ+R5++wcKQ=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-265abad93bfso25305ad.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758047748; x=1758652548; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jv7oaIHfrPnWolRAUwMAHrfSaRXeenaXfJ1eWBHIqYI=;
        b=gvY42MzBD/ZHwfI+if3bybC/yEtmG3R4p5izCiJAt2REUohbx5zfsHntwCZdHBBxtQ
         MMpQcdnREQDTbDPlWFO+O8pSNvpQZHDYnWTTr1dCSfS8feh761vjNPe/ACt2timp3am+
         Lgu01uzvFGPnVtRikBsYPL9BT243thYqtxqGAabRUtJR5lhTJFMjBPghpxLH4dts4s1g
         Ad2HAL1rodr4ej0go36XHWFKhMAwXzQvPaVdmQHQnsI9M57nnQZ18qqL2zW1jAriAU4m
         Dn5Nc7EXE5iEkEViurLcsISRmPJvS0xZxyaDDvl2GeuTn15r5nUKM8WaUPccUP0JS1sv
         08Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758047748; x=1758652548;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jv7oaIHfrPnWolRAUwMAHrfSaRXeenaXfJ1eWBHIqYI=;
        b=VqBtKvX9R+vg5NF5bOgnWGPim+VGgho2Rurk2UE0D3K++NKgxoxMUrvxePGHdxNy4q
         ld1iMksxEtJfqSCcgMyIubJl8dNkg6PQ424YCQn8gXYtZvuePh+FieZRAAy6InrhFRaH
         958V3RUsGn2nJthOFyLxGTxUU01CZPMEhjXlC2HEnVcbahO+Heao1qZtqQlkYxIkZSZR
         W3h8o6lKQ8T93UetPIOsvEHP8Z3S+D7Z+GbZZ/I/RcDomY7hgs8dn2u5F0jHvu6iRqAi
         iZSMDP8GKTuakb9DHDFLavKtb9ZmoHuRKY2VXddiA1jym3sZf9s2O8lW5iQpSqxW33iB
         OcAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrUgGuTA7QHn/+6wDZZAMaWaDfrPTID9lOsBf5RlGdY6whFlmIVsZyi83g9mrd+DAzrqM1APr7dg==@kvack.org
X-Gm-Message-State: AOJu0Yz6k393rJaP2OgHONuYWkD/CFryaX4FtfuSRq/b9hN6YXESNvIw
	3Y5RY4+dBwyttJcOD2RlYuehRJNzRtnZDzSi4iUjZ/xo39AQJQoaoyrTU5l9JEYf7XG9wXdp0LL
	HAvw1aS5GgfKtNIFwZzB+GfsSFel3BaiNamBLSGYK
X-Gm-Gg: ASbGncugylH7Zr+FGy/cajARJdmRxIIwQb7uXnciMja7IqtHFVxjJksOPWmXfWjvnUD
	w2l1gvKUFGUfi1x9Y+dyqv/zKFYeiumyyYopu6cdou/7GdvQjkHhUzmQT1T4TTxUjMb0iIYwlkV
	giyiCc+pcSj3P+E3rNSjwMQMjzgxHhGBxQ0kJebFbmPdjRpsrdCmitfmJEY8AOf+cYo4X3EHb2g
	rDu+B7R2Z+K+LSrul4cYEI=
X-Google-Smtp-Source: AGHT+IFnKdQWUrwHGQSkrPdf0moMjXXZ1A+IYR70daX42QbAE1wkKGvYulE4QW6KE+iPeTxeubVCpV/5g/TSwJVO+Ps=
X-Received: by 2002:a17:903:41c3:b0:25d:c405:132e with SMTP id
 d9443c01a7336-26800f4d873mr614075ad.12.1758047747512; Tue, 16 Sep 2025
 11:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <1757967196.153116687@apps.rackspace.com> <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com> <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com>
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com>
In-Reply-To: <1758043654.112619688@apps.rackspace.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Tue, 16 Sep 2025 11:35:10 -0700
X-Gm-Features: AS18NWAuGmVDtmu7cFXTApXqzr3q5Tq2DoxGYq9oUzEdbp5Pw6i8ZbcG8LePA9o
Message-ID: <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range fails
To: "David P. Reed" <dpreed@deepplum.com>
Cc: Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="0000000000007db140063eef631c"
X-Rspamd-Queue-Id: 103EA18000C
X-Rspamd-Server: rspam05
X-Stat-Signature: 6cqaogeqqibbbe9wcu3drok3sqe9sett
X-Rspam-User: 
X-HE-Tag: 1758047748-483312
X-HE-Meta: U2FsdGVkX1+PuhN6KII62MJ7NanWccvN/m1uXRTDD4K12Q678Bt/ej4BzL4SMTyBBhKg5ZEFpk6IsAim6nXpd4rI1ZagbWHdcpoiVnXffQHb8aTOpYZXWetU/RM3B/JqxrOA+515vDIBwEjPgmFYWef7QzXxpAeztICo7SRuCorBdYHxqHxlUDHzp9+x9rXVJ9FUN+LH0oMHIrXJRovXgRhcWYfpr6UBgfD0W8xWppyjjlYjR+J36zRCE3lmGcAcHZ0JwYJ9snrk//v5CegFFJxAKYFVA6G7nwUnzCmOdRfdO6jPMsPYn2wozW+QUjNZhlxKLBCCS7UFvSsD9oSKTilU6Po26snVaOhh09yamLlzwCfaJnhhuB2xVTH5RrHcHTz0CUk3zagnqK1tEgQ1AMHwiMjJ79gkKPjiryKyOTnWRfZ7sKtMJw5ctMW5LWx/PZQDcALDaY7pWZOdnFEIOvrzNnQGjUpl0ZAth8Z1UTSdu0iotSS0FbO11oJvmZ4x/cq7DfFX+dR/xGiUaUzsNyC/7DAYdYJ7ADc7Ntw/DXQ34ZroepqyoTYEWXEZF1bCXXgv4ROQhy/PxZIK0t1fIH+1x/IY2LZJPxp2ibifjuM1g9TkP4u7yNW//VyiwmMblJgmF+tRYvAbYcG23itWV6nZgymXoDKlTRiBBHnCs+vXyHcXI33+EieRYBcsvctY7n59leALpzXsQps0ENHBP8GTjlrNoUu8iXq1SPmXfEicRv1tc4VrjclD3ksLorCnIfcoA3eQhflJCHsfFBzcHrT577PLWDBe2oRTF7t25tgZYJYg1yYuegv6If22Ro2lQlx7hSXnM2d3aoo3zNgzgOQey/i1Jq1CNJHmaS8aBPp4s8tBsxtDyLgjjtUOJRvhr0D1/At1gt0fMgN42gLiTMYI3rgoC1rFnYf9fuuZKAB7r+ggBwTpdh5FC9a2tnrox3dhOIPoJR+8MDDZKGa
 IxXV5wEJ
 w5JukoMqOHhL+FDkgLKQN2DcthgvP9H9/t9QwBfrDwZnQjUDkVBmmVZYg7rEt1Ypp+6fz8NexhoNUx5kSCnDKqbIOoMKHhIgY30cVTHARYj7leIuXZZBTMLnkCOUIsDAd9b7Murapd7Dw6CK17nnsoGzY5LtgXiyuI66WrczIzU0l3saChk4vjK0XPPQLIKbmcNPsYRaHIo8H06+DY22xgfpp7+bGRd961HosccbF8TYaP/9tmmzlGJ86YrPwz28F8YJr/xJMvccCHWSla293hieHMBNH8gOOEm2i+kKkNyFohicqCxvrLKsqPChvU2Hzx90OoKnSsLXXUl/6SclXtfoN303ofdtX3yZsekP7CAuhSPz7dN0xwNxQAOr9aMSIjSSHj6/1CppqcAYJzfW+yU3u8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000007db140063eef631c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 10:27=E2=80=AFAM David P. Reed <dpreed@deepplum.com=
> wrote:

> Than -
>
> Just to clarify -
> Looking at the man page for UFFDIO_API, there are two "feature bits" that
> indicate cases where "minor" handling is now supported, and can be enable=
d.
> UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM
> In my reading of the documents, these seem to imply that before they were
> added as new features, that MAP_PRIVATE|MAP_ANONYMOUS mappings were
> supported, and that the "new" additions to the MINOR mode were just for
> HUGETLBFS and MAP_SHARED cases.
>

Actually minor fault support didn't exist at all before those two features
were added. :)

You are right that userfaultfd's use of "minor fault" is (unfortunately)
slightly different from the meaning in other contexts. I think the more
normal meaning is, faults which do not incur I/O (i.e., swap faults and
file faults [i.e., faults on non-swap-backed pages] are major, other faults
are minor).

For userfaultfd, a minor fault is a fault where the page already exists in
the page cache, but the page table entry wasn't setup. I don't think that
scenario can ever happen for anonymous, private mappings, so it doesn't
really make sense to be able to register such mappings in this mode. If you
create a mapping with mmap(MAP_ANON|MAP_PRIVATE) and then access it (read
or write), that fault requires allocation of a new page, so userfaultfd
does not consider that a "minor fault". My recollection though is if you
make a file on tmpfs or hugetlbfs, fallocate() it or whatever, and you
MAP_PRIVATE that file, *that* registration will work.


>
> It seems odd that anonymous page faults and COW would not be handled,
> given that context.
>
> Anyway, that's unclear in any of the documentation. This just adds to my
> last response where I explain my use case.
>
>
>

--0000000000007db140063eef631c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Sep 16,=
 2025 at 10:27=E2=80=AFAM David P. Reed &lt;<a href=3D"mailto:dpreed@deeppl=
um.com">dpreed@deepplum.com</a>&gt; wrote:<br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex">Than -<br>
<br>
Just to clarify - <br>
Looking at the man page for UFFDIO_API, there are two &quot;feature bits&qu=
ot; that indicate cases where &quot;minor&quot; handling is now supported, =
and can be enabled.<br>
UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM <br>
In my reading of the documents, these seem to imply that before they were a=
dded as new features, that MAP_PRIVATE|MAP_ANONYMOUS mappings were supporte=
d, and that the &quot;new&quot; additions to the MINOR mode were just for H=
UGETLBFS and MAP_SHARED cases.<br></blockquote><div><br></div><div>Actually=
 minor fault support didn&#39;t exist at all before those two features were=
 added. :)</div><div><br></div><div>You are right that userfaultfd&#39;s us=
e of &quot;minor fault&quot; is (unfortunately) slightly different from the=
 meaning in other contexts. I think the more normal meaning is, faults whic=
h do not incur I/O (i.e., swap faults and file faults [i.e., faults on non-=
swap-backed pages] are major, other faults are minor).</div><div><br></div>=
<div>For userfaultfd, a minor fault is a fault where the page already exist=
s in the page cache, but the page table entry wasn&#39;t setup. I don&#39;t=
 think that scenario can ever happen for anonymous, private mappings, so it=
 doesn&#39;t really make sense to be able to register such mappings in this=
 mode. If you create a mapping with mmap(MAP_ANON|MAP_PRIVATE) and then acc=
ess it (read or write), that fault requires allocation of a new page, so us=
erfaultfd does not consider that a &quot;minor fault&quot;. My recollection=
 though is if you make a file on tmpfs or hugetlbfs, fallocate() it or what=
ever, and you MAP_PRIVATE that file, *that* registration will work.</div><d=
iv>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
It seems odd that anonymous page faults and COW would not be handled, given=
 that context.<br>
<br>
Anyway, that&#39;s unclear in any of the documentation. This just adds to m=
y last response where I explain my use case.<br>
<br>
<br>
</blockquote></div></div>

--0000000000007db140063eef631c--

