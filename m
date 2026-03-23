Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB947D58CBE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 02:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25AA46B0005; Sun, 22 Mar 2026 22:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C466B0088; Sun, 22 Mar 2026 22:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBB36B0089; Sun, 22 Mar 2026 22:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2C646B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:56:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 837D31B8893
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:56:36 +0000 (UTC)
X-FDA: 84575814792.12.7311392
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4596140005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:56:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/YKGTg7";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774234594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1d90f1umJH/7Db/x9BWxw3tlzkAxFg9WfSxI5SCzd6U=;
	b=017ICCKvPR/D7PHD/VLYFlj5q+zhYWg9el/wgezaseduAdqut4uGKS1ccvPvWY3kLCUBQq
	nMrBv9tl8pvew56TXOQ6Me0ShBslrp7KYs/W4YRt5/tkK1qp2P8ZdkeuXBKM29EqX3mkRy
	9fiyqx8eUwuTUdIQPV9X4wVcgSoQFVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774234594; a=rsa-sha256;
	cv=none;
	b=3W2GqspmV1F/HHe6cpiQfKdqtJJCruSnCmlHtd1dQkPtZcS+5mU6vDqd+Dfa1V00f+FOfN
	wNNyWrLUJ/IRn0JtlywRPB0jJWZfxaY1q33EMmG8/TOFfhbu4DKvkILYsvnmA/yC3ramQm
	+XMN4cGZsSDd/LI3qD45lD66SzcyBys=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/YKGTg7";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774234593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1d90f1umJH/7Db/x9BWxw3tlzkAxFg9WfSxI5SCzd6U=;
	b=X/YKGTg7IMwPPK9iEHeWn/iolfCB5vfQ34a/cWTZ9THeTZds27HsA/qkIvZLOd6tMIR48K
	unAixo2BKOGZbcoS1KRVxf0+d1+zFdgWKG/XMcTkXzHvq8FATESHAm1wy067QlO3YTlqle
	xhgTLdSy413VO/++2NbCFxY8LYJwMzs=
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com
 [74.125.82.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-DKo7cqCjOm2zvr1OOi7GJA-1; Sun, 22 Mar 2026 22:56:30 -0400
X-MC-Unique: DKo7cqCjOm2zvr1OOi7GJA-1
X-Mimecast-MFC-AGG-ID: DKo7cqCjOm2zvr1OOi7GJA_1774234589
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-127876be621so2408786c88.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774234589; x=1774839389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1d90f1umJH/7Db/x9BWxw3tlzkAxFg9WfSxI5SCzd6U=;
        b=LI/S6LRAYRXdz9esf38lsnHeeMW8/v+fUqRoIyEwKsN9LSrgsSIQ71g+PA3ZDSVUGf
         GdOmL9QR6foF7XY8fsHNF4EUHjdv26WCD5Dpy0XuPfR79YT0Puy3j4h1xdhW7shDQH6t
         7z4ml3drS8CeBjI1cjY5ohWH/liQNRSEspy0Me/Ldwi0xzZazlhtdMvhYWAQB6W01j8z
         efPLGhz/niMuii8FlKX8YOlXghJw9T1T36Dm9PeTNosVbCWT07f3+CpOc7R2mt6vDYm2
         widG0T8xdk666gjQEgsxcNW0AHNvQR/iY/bB/rQsWzQ9HGpEsuyoUbj51r5Tu2UTMyJC
         KuyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsd1iIBv5u12TU4UTukqPET9SD8BoIC5JNMTBLcFaG5tsqVKEyjxLooVebcKNsAIQZr9RpLQYsww==@kvack.org
X-Gm-Message-State: AOJu0Yx9m+ZUSCP01F3Gc9++sD3AZcJfV2AA+UDJIUVR/DHYXgD+5qRA
	iAzpeqrjFF7NlqVICMHAXLSJd95DT1X+1ZTJ0zt2N3HttjqAqXZCPjSdlgkJ+eeAEW23ih5+JKY
	JYOtxPCsee7Q3wjrsgjF5bVhN+st4AKVAjlOhZdIJTMLWRb0wcG+WyVi1iUPWAYcNNKNgkTAPUs
	Cg6xLJBr2bY75fBsX/kKrMY1Fgre0=
X-Gm-Gg: ATEYQzyJiIhVXO+ahjZ5lxTPBeIdWc6hABWmdN4kHI4rnq+vcTCyyfHVqoFQuEFD5HH
	h+jqo62Aan3f1m3a+d0vMPpZKGwKDhJdVngSuoEZP74Xl23wsFMkiBjF74vp7Lb0dYlvbp+AzQP
	+vzjeQFbSOhgJN8TnQvPy1UCx+m26Oi9Dod/V4z79AXzsjHx5UfKsWjcc5WgpNPUjX/+8U8wENt
	atsQi4=
X-Received: by 2002:a05:7022:f50a:b0:12a:6d05:3941 with SMTP id a92af1059eb24-12a6d053ae2mr2290669c88.2.1774234588734;
        Sun, 22 Mar 2026 19:56:28 -0700 (PDT)
X-Received: by 2002:a05:7022:f50a:b0:12a:6d05:3941 with SMTP id
 a92af1059eb24-12a6d053ae2mr2290648c88.2.1774234587774; Sun, 22 Mar 2026
 19:56:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260320204241.1613861-1-longman@redhat.com> <20260320204241.1613861-4-longman@redhat.com>
 <CAEemH2cJeTWLCLnmHqQY+tAs8b8FM+AmQ3UYd8McM760cN_Atw@mail.gmail.com>
In-Reply-To: <CAEemH2cJeTWLCLnmHqQY+tAs8b8FM+AmQ3UYd8McM760cN_Atw@mail.gmail.com>
From: Li Wang <liwang@redhat.com>
Date: Mon, 23 Mar 2026 10:56:16 +0800
X-Gm-Features: AQROBzC62EzvNeD8h8HmjN0YJE8T2mvwm2Y1UIuOF9mDvXT68oTEjubQW5FqjO0
Message-ID: <CAEemH2drJX+XX8H4Z4SyrgtQ+63c7iL7KdS=V4LSkoAq_YWtTA@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] selftests: memcg: Iterate pages based on the
 actual page size
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>, 
	Sebastian Chlad <sebastianchlad@gmail.com>, Guopeng Zhang <zhangguopeng@kylinos.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cTBc7LSnYVNffXNOPytbhL_VGCuKaxuYGYIqQEOo2cQ_1774234589
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="0000000000005a5da8064da82e94"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4596140005
X-Stat-Signature: 1qeuf6t1apm44xmraxhyc4z88w99yzth
X-Rspam-User: 
X-HE-Tag: 1774234594-890098
X-HE-Meta: U2FsdGVkX181TwTyhWA+m1SyNiO+iYqPrdTbQjwVDKZZaomxfJsSK5tWCdbFqfqaKSWZm6+QZksjCLFNJWeEmumAS37t+Lp2emJUfMfH6YseMGScPLrpE14LAWsVRNunTTctf1BukgRsxU2Rg9Fp+3B3Evd/GcFvoxGIpc585+KsJQ3SjMTeQkV+khCxfFJTfInPmmaA/zn+KOmjv7SjfVDSI5PG97ho0gDSN7yBKFqoFbcLIXyFoIZbbGDnHw/YJWzvikU8+JD1uUZXt9aklioW3r0CuR/oOPX6dNdo1t/9yz6ffo7DLC3fDzZVEW7hRfukjgcnMPpDx1sC4UCW7AQwj49A0TT0eZ0JozVpD2r2Zy4BHtgECfenxJXXkHbdk9uoC2sJTylhJm24jKYx6lLez1sVVjSJEHB+8tMIkqOL1/jZLtk1Eq+zkgDtdyVE3rA487pvLLMCfmo3xf7AKASfPCfObnUD5BIgwVGk2RaNeI4kcprYazNDHiT3lpBJrjw/Qm7y2e0uw00t9q8Ay00t3MvFP+wa0q4RiTJbmf+CSNIb///HlzPCzHhCFyBDgfIlIRPIxuCJF5vnxv43jadQ5HW3eS9HsW5j2kN+vlJ9XLaYK5G8lZUYQsOMAUZdkcyNqhlDznEb5CufDXD9qosBJXoT05YXLBg138UTQsnb6RNtvAufnqWP09dPfC/vhhR3Zw1NEORgxFMTphQmX2TAZ4YBfQiEaYhVYYKNen88kN7F8j/RsVLKzYLyip9gExj12TrGCfrQOAt0CWv9Zm9XmaYlDZTHxBVRbJCWijzLdTRBL58IkkWVXMXQRi4iAhkHbm+BSUamDGr1D98mH0++avdJdjpMDnt7Bn2gZ/YCiX5JlCtLn2dbcA1TtiqIYGBqhYi7ELi6iqrbdK95LChrbi5Y9OQW2650xq7Br4yCi2VmKSPFkw3K/FnUdwylhGyvN6+l0PbuPXYzC+o
 7V8LgqGp
 xWjktnVrtyZCCzUz/e+8/CvX6mFggBZ2hAFqrkYpyeJNYseUK7BOsFaQ53uJGD+w2df3ObGLsHS9Uxf4PA40D3MaiQkJO45JriYuEc6zUccupN3BsXpqqTOzNreHsSF6rpkADD5SoWfwfbFkmdOFzTVwTQaDZvviGhvT2vf0CVT5J0aEBktmUF3hFdnUnF86pRkXGuUoFaCAmdY7At62t14krqIUuEoKCJeacqwOoupEN1A+xfkh6bspOTX2wS6tiv+X94/ashDh4+OLx83QajQZ4A47xHlC85zDhIW5NK6/YAR69GNWfmWJL3/XlzQuZaO/2dO8P2Y0cfzZvnueDXyU07zVBQkcIv+FPok+Ip2OGc+jCtVcoeHPz84WBz3QGxygWM2Pu6CB2QMQD55x+ZaIq9fts40bwEsSmD7eJ2XqsEcbxmRROzCO7pePSW88jlxbXV7TEaqoQ6oePOrsVxFT9iwz14tHAtyE5gjudGxd2kyctu7t7Lnzn+Cih4QO12tXF8AcvuJmdv3+ELm5LpEZeb8tuG8Y4T58xsh5raXYHtDruyjuHaLC67T2kHOdK0sEbtY9WltWj02Km2ixXCykviqkF9xNABs9O3FzUq7aBQAnMdJsZ+6JqY/yUi7WW/jyqxkZvKWalqoFzbBBdZacZAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000005a5da8064da82e94
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2026 at 10:53=E2=80=AFAM Li Wang <liwang@redhat.com> wrote:

> Hi Waiman,
>
> I currently have another patch in hand that is functionally identical to
> patch 3/7 here (requested by Sashiko).
>
> May I go ahead and merge it directly into my patch series, while
> retaining your authorship attribution?
>
> Otherwise, our respective patches will conflict when merged into the
> mm-tree.
>
> See:
> https://sashiko.dev/#/patchset/20260322061038.156146-1-liwang@redhat.com
>

The overlap patch:
  https://lore.kernel.org/all/20260313043532.103987-4-liwang@redhat.com/

--=20
Regards,
Li Wang

--0000000000005a5da8064da82e94
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-size:small"><br></div></div><br><div class=3D"gmail_quote gmail_quote_con=
tainer"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Mar 23, 2026 at 10:53=
=E2=80=AFAM Li Wang &lt;<a href=3D"mailto:liwang@redhat.com">liwang@redhat.=
com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div style=3D"font-si=
ze:small">Hi Waiman,</div><div style=3D"font-size:small"><br></div><div sty=
le=3D"font-size:small">I currently have another patch in hand that is funct=
ionally identical to</div><div style=3D"font-size:small">patch 3/7 here (re=
quested by Sashiko).=C2=A0</div><div style=3D"font-size:small"><br></div><d=
iv style=3D"font-size:small">May I go ahead and merge it directly into my p=
atch series, while</div><div style=3D"font-size:small">retaining your autho=
rship attribution?</div><div style=3D"font-size:small"><br>Otherwise, our r=
espective patches will conflict when merged into the mm-tree.</div><div sty=
le=3D"font-size:small"><br></div><div style=3D"font-size:small">See:=C2=A0<=
a href=3D"https://sashiko.dev/#/patchset/20260322061038.156146-1-liwang@red=
hat.com" target=3D"_blank">https://sashiko.dev/#/patchset/20260322061038.15=
6146-1-liwang@redhat.com</a></div></div></div></div></blockquote><div><br><=
/div><div class=3D"gmail_default" style=3D"font-size:small">The overlap pat=
ch:</div><div class=3D"gmail_default" style=3D"font-size:small">=C2=A0=C2=
=A0<a href=3D"https://lore.kernel.org/all/20260313043532.103987-4-liwang@re=
dhat.com/">https://lore.kernel.org/all/20260313043532.103987-4-liwang@redha=
t.com/</a></div></div><div><br></div><span class=3D"gmail_signature_prefix"=
>-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><div dir=3D"ltr">=
<div>Regards,<br></div><div>Li Wang</div></div></div></div>

--0000000000005a5da8064da82e94--


