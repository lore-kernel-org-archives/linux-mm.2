Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBAFCD3426
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 13:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8476B0005; Sun,  3 May 2026 09:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878C36B008A; Sun,  3 May 2026 09:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E846B008C; Sun,  3 May 2026 09:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE2A6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 09:44:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B81F8A0798
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:44:08 +0000 (UTC)
X-FDA: 84726227376.20.CC2C7BA
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id D2C6740006
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:44:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j7r2qvro;
	spf=pass (imf07.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777815846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCLKgXi81ua7mr1gMnNhlp337DbC9YcL8LigKiW+X64=;
	b=ZL1gvp223P6aeZlSwIC+pT+JaTBMxvJxt7Dyd4OHJFyCUdmCUowfwhQWvkBiDRqbW4/Mnm
	k/k7ecJYO7FNIMS9wqQ8yDekNGNZZun2YIU1HMjSaPgpiol+0tjaz0YAHesW7zBioYwZim
	iwQiTRbPKCychjrJ6GrI+2MQVdl1TMQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777815846; a=rsa-sha256;
	cv=pass;
	b=4qN67zJYLkGYAjqebJIHKn+BKIrrIxmGxCK3fBtyHlJsC0oNmcv6lQ5n/matD6K6rOLXgX
	Fu6UnH+jaKqkB2aAPVAzF2F8M7PVSFM1gXNy0J8p0AI9cuv1sfubmhNYKon+ntR0tyjOwt
	iDlqUhaNjM7HNkzgYy7QcRQ4F2Z/tn0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j7r2qvro;
	spf=pass (imf07.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-6121f20650dso1275772137.1
        for <linux-mm@kvack.org>; Sun, 03 May 2026 06:44:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777815846; cv=none;
        d=google.com; s=arc-20240605;
        b=CKM7Vea5zEFXGtSD6ZejE6aYTk7gOGK1pvhtMHruCY0tV1dcJBm/A1yqFrhub49Yt1
         JqxDko37RzTJnVICWTOOKQtQxGCFyDhcf6Gu5981Dzf3DS9mburU7SdSYxrEHiuLay16
         OOHFE3xYdOoowLaQM3XPrlE6c4U/S7sHRdT0Hgu17sONxU3/ooQTLIRB+QBBt+a0VsZS
         gA9KoTynRNBlnkRl7a+3tKcxYOPAmfsRBKlxVIjBDhlXvFzcsy9V7QhPWUzGVhb16YeZ
         fUxaxlNfADeocejK6DzwUSWCoq397bwZrAz/GA99MQajh6PxgO/tdKO/W4Uews5iRvyI
         Uajg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KCLKgXi81ua7mr1gMnNhlp337DbC9YcL8LigKiW+X64=;
        fh=3Ms6TA3Mcw1vOOJLDVFUzOesn0WIr9Dj9RcWWlRozHY=;
        b=Ed9CiF4uXZSZi0Kka1rBK8urszWfjXmBKTd0wuC4x5BcDweZLdWHcvuyxNUBMy4uiT
         QJJWHKaBL6ZHUMjOrEfZCxBoNZ93yXzXXSxKfzanUjGTzpmpgvicRe5CAEFKnHaVTvip
         mXjlJTTM5v1tXW8NWkYa1ae6uBFkCbB99OY+Vy2r5Q3HSi0hIx1u10kOmW3Hc9+T6thK
         6CqDY0Go8PsLD6KxlAgEvkJC4OFB8tj89uIiv3OuDS6DdYh4ohz8nfHqDtLSwWFtLWnu
         mK5L2+tuNs+Dqdrjzq9B7xay6J7fzwghdM3gxbs21pP3mRzxdXekRqPo0p09fp8LUQeQ
         BLAg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777815846; x=1778420646; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KCLKgXi81ua7mr1gMnNhlp337DbC9YcL8LigKiW+X64=;
        b=j7r2qvro6LUuXkBv1Dmf0AWwFwhqsFGiLCQR4ovTbRLOysz62eubH3cGvHsmj6AUJF
         g/36J+8b5HOK1+xkU1mqwCB+WX2MgNy4U1GETmNPPArrT5NXalhA4GhgtterXxgvKji1
         IgKYvnhRm+wFP6zJhIXiVVH0poHIEJgL1Qrs2zU4z0RS8zJsxRXd5C81i+Wv01CtAZjt
         l9puO4xsiBjdrqNxfS324bGD9Nk9i3fcK0V+urqluLZea6g0g2+VHO5F5i40VO4Avgmh
         l/o6t4NzSqGCm0s/g4mzyoLYuSKS1+/o4upTsCKtot7TNQbC9ofViA7G+NhTlAkSsiWy
         qgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777815846; x=1778420646;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCLKgXi81ua7mr1gMnNhlp337DbC9YcL8LigKiW+X64=;
        b=Lel8U3gDVcQvYTnLIaSItFRg2SdjbQmOHW/3UMmx/G+sU0tNF+ZWf8igKAZl66xJKE
         YIrzR/3oVXPFOnN1P39MSRiG7fOTus8eEZ25kQnOBBn+2ADisYnQc8EHtBXotb5Vzofh
         PtyUQGHLzJ3Z5l/ZBdvkLt7Gh6liREyKqLY+gaoMM8BLJwykYT1BgyGJxHdfStmLgUci
         OKT9/PjO7FdkRyiYrvxKoS5C/3cTQX2sNX9vQL7LQn6btNZLkZ38J21QVqzGpsGjN9qz
         Xnkfd5Osre3iOTfupiS62TgcxwinYOVl3/VHFntqwpVucWZIg07K4qN+1pX+hYimhAjK
         bn1w==
X-Forwarded-Encrypted: i=1; AFNElJ+8pp07TMuM6MV9vhyDxTlaInAPoeKrUWmdiY1WoWWdUKPuIGZBZxzHkZKPru1eiQ7ufHaXCnDsng==@kvack.org
X-Gm-Message-State: AOJu0YyjjNA0GNxyezEE7ziObVm5d15NWYnfbDu+zNMZlSsvMzctKFqF
	ZF9b/pggqkcG7XZYx/0Mo7t5wLzXprCqrZdJBHTys5fFnyS8CzyzJJT1K8EOf0UzVTxz2JeT5dk
	+I33a0i6sgbE0opwdW6i0hclImV7DPCo=
X-Gm-Gg: AeBDieu5W21WlLY2EoWabS/xYSwexMKy8yM3d1kXg1jo6uygC0JZECvTqwmWQcTXIs8
	EX3z0GImoyuD1BVQxLRqVsrOeUS3wHfVsgEW9uQWeurX76US+ZN9varwwgfv/+3Izh4XMQt/XFu
	8WMvGC8fR962drvimwxQA4UyWEW1KCTaPadNkxE1bUrJ9D0Tf50QZ0JO/ADUBREdilgg9LDmBGB
	L14NskIkoD9qzOk2nDsmqL8OndqOGTQXll7Omuhwg5qjgiojmd2uQNJonVGdNOkleiQ0FM8v/Bz
	n1ui1PgQS7XBO4FwWo2HyxULDSIsTBCJ6t8RTEsCsNKMlc1dSqE=
X-Received: by 2002:a05:6102:548f:b0:609:5101:d668 with SMTP id
 ada2fe7eead31-62d8809577fmr2224446137.30.1777815845736; Sun, 03 May 2026
 06:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260503101229.654763-1-agarwal.vineet2006@gmail.com> <20260503062304.02b166415ef419cf4df6cb87@linux-foundation.org>
In-Reply-To: <20260503062304.02b166415ef419cf4df6cb87@linux-foundation.org>
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Date: Sun, 3 May 2026 19:13:53 +0530
X-Gm-Features: AVHnY4J8WZqCSDFrlvaHuxSlhBVfE_RE0NUZX71lJ3P8b3DkPbvD196ac9nyNc4
Message-ID: <CA+rjy8cFrKpdJw=N-gyVFkch-KZoPm5UXUFEC=RC=jHS4cz5Lg@mail.gmail.com>
Subject: Re: [PATCH v3] selftests/mm: ksm-functional-tests: fix partial write handling
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com
Content-Type: multipart/alternative; boundary="000000000000f614250650ea01d0"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D2C6740006
X-Stat-Signature: 93bhc98kgtaqwy587bhj1zf9axmjaph9
X-Rspam-User: 
X-HE-Tag: 1777815846-331282
X-HE-Meta: U2FsdGVkX18Y2IFDxqxWWORlu7C0suK3I4ElH2v2gG7a1YyIwT413A4sk1tNe6zGdlkVtAtVxhpRaT1ou7LqkJyF67CRwwMGilimIC04fC+9iHPhEnxFSV2fOmkex/zth3ExvtCTJfMQlDicER6bCPbo+O/HhTsOCmS/VVxUh1TwdOUF+uj+krNh1ZFaCoCM70vhiCmBAOo1vaQh4qggRhAa2QrYS7q8WFv4rOnOeHThP0JkZSfWPK/CuA9mj+rY7Mg47NBZUrx52VndeUQMkogVvnfpp+EDp3Q+J6KJ4I23C+hz5NjFJkivnuaZgnxXPbGJxFr0aD3Ei3a6Y7pq14JyzvJmFF6fCbTS2DC7GWBZub7VAy7i9h4d83Hmre22w+fY4ITAy0cn9pbh8pKb5nE3KwhxIHZGrsveM/1msbaYre0Kg+LllDbWNh7lKXuVaL2zWgt4O/tTkIyscgejMHeyRSnZX5MjDN6Rd7zNvh/pFF6rTcrqGjT6u4R9wMbnCDvlFEd+GWHRLDrh1qjRifdvihzOapuy2DdxfPdpwBF5XMU0oH3v9PLQl/v9sPeQVUIzJYMdAyC3idGCc2MV3yfI4De132Wu4eacj9b/Y3eqM9WNUsE7uoEYSOUkXmiBlUo4djYjf5Kq6+/fCTgMnMew5zpEsjJ/3PRN8Fga+Kc3Rv5LX42sYIC7hdmG7KXOEpycwwgsI/6U7Ir2OMKdwTgWnMiIHcIJlz2XDGoSJHdKwLG3RpU38wGP3ohTKiPPg3bS3kGrKYlru+P99OCP8O7I7VyfLe6ur1CXUtLy7QJa6GWpxoc9r6DJQV+tnxFGl733cMhHo4aUp4l5eJXsMc1PIgg4Uc62CnnBPL9xzuf06/BUnM1Qe9epxSYCWLoj6ukkG366uiPzjZn7jc3aUhcHFMh3ZzZrJfBeQxip3AsRb1d3ikt0+qILf+8eDVlXKmKNacPAI3pLL6VOvbn
 WwCUSKHL
 U88mB3VMrVl/L7VIic2V/HlbI+LVYn6qz5nvafrQjCXfzXW8J/pPVF9xYpX95t0HdBuAToVyDdjWiHFkuFNlb6d6QH99vFjTY23A5Vp1B2lSVfBtAM4YUf2LJLoa2Yifs5tbEaDOR6YvD+UzodwRfk20QvBZk9FeStn1GN+TJe4A7vfYJbT71OL60bIw+W7zKMzJE72nScFw7HBmwC61p1mA3KITDLAcresY1AhOP1gRayPiRQ+7RQbN8HYfmtrJ61QEm5ZZWVz2Z84qQcbvgGYdXqXT6mXVFEBgLT32LEuKIrQAbdiPjuPWoql5M4IoyFilTDAo6oo8HXJgsP9lC3pWPsY1evxQTCNJeb54ZiICrISB7b7fN44bynBgsOUWeZpppAS4K5O7W+XGU5DBIxAKc79dO8oQ6ny2wKO6ICr/AkhzsUC9SFmsIAltkYg09ajkQ9H/Se1RmyDAseWh7wxEOdxHdv4akO/oL7Y28p6lsb546thTQZAHxslJPEtrgIDvUpj0pZUuW2/mVyjW7TTP/hjMBQ10uWiBnPj1AQQimqj5a4pb4fdcXO5hQxu95qI8nMX1Bfn+8TvnVG/1E6wrsoC0Q8+d0Age8r3WOUyySn0WFGPiuYWzPTHmsxZf0kaDx0UEDM7Xr/r4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000f614250650ea01d0
Content-Type: text/plain; charset="UTF-8"

Hi,

Thanks for taking a look.

Regarding the AI review comments:

   -

   The issue in the original code is that partial writes (ret > 0 && ret <
   len)
   were not detected because the code only checked for write() <= 0. As a
   result,
   partial writes were treated as success.
   -

   The current check ret != len intentionally covers both partial writes and
   error cases (ret < 0) in a simple way, which follows the earlier
   suggestion
   to keep the logic straightforward for selftests.
   -

   For these tests, distinguishing specific error codes is not required, so
   returning -1 on any mismatch is sufficient.

Please let me know if you'd prefer any adjustments to the commit message.

Thanks,
Vineet


On Sun, 3 May 2026 at 18:53, Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Sun,  3 May 2026 15:38:40 +0530 Vineet Agarwal <
> agarwal.vineet2006@gmail.com> wrote:
>
> > Update write() checks to properly detect and handle partial writes.
> >
> > Previously, partial writes (ret > 0 && ret != len) could be treated
> > as success because write() does not set errno in this case and the
> > code returned -errno. This could result in returning 0 and
> > incorrectly signaling success.
> >
> > Fix this by verifying that write() returns the full expected length
> > and treating any mismatch as failure.
>
> Thanks.  AI review asked some questions:
>
> https://sashiko.dev/#/patchset/20260503101229.654763-1-agarwal.vineet2006@gmail.com
>
>

--000000000000f614250650ea01d0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p>Hi,</p><p>Thanks for taking a look.</p><p>Regarding the=
 AI review comments:</p><ul><li><p>The issue in the original code is that p=
artial writes (ret &gt; 0 &amp;&amp; ret &lt; len)<br>were not detected bec=
ause the code only checked for write() &lt;=3D 0. As a result,<br>partial w=
rites were treated as success.</p></li><li><p>The current check ret !=3D le=
n intentionally covers both partial writes and<br>error cases (ret &lt; 0) =
in a simple way, which follows the earlier suggestion<br>to keep the logic =
straightforward for selftests.</p></li><li><p>For these tests, distinguishi=
ng specific error codes is not required, so<br>returning -1 on any mismatch=
 is sufficient.</p></li></ul><p>Please let me know if you&#39;d prefer any =
adjustments to the commit message.</p><p>Thanks,<br>Vineet</p><br></div><br=
><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D=
"gmail_attr">On Sun, 3 May 2026 at 18:53, Andrew Morton &lt;<a href=3D"mail=
to:akpm@linux-foundation.org">akpm@linux-foundation.org</a>&gt; wrote:<br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex">On Sun,=C2=A0 3 May =
2026 15:38:40 +0530 Vineet Agarwal &lt;<a href=3D"mailto:agarwal.vineet2006=
@gmail.com" target=3D"_blank">agarwal.vineet2006@gmail.com</a>&gt; wrote:<b=
r>
<br>
&gt; Update write() checks to properly detect and handle partial writes.<br=
>
&gt; <br>
&gt; Previously, partial writes (ret &gt; 0 &amp;&amp; ret !=3D len) could =
be treated<br>
&gt; as success because write() does not set errno in this case and the<br>
&gt; code returned -errno. This could result in returning 0 and<br>
&gt; incorrectly signaling success.<br>
&gt; <br>
&gt; Fix this by verifying that write() returns the full expected length<br=
>
&gt; and treating any mismatch as failure.<br>
<br>
Thanks.=C2=A0 AI review asked some questions:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"https://sashiko.dev/#/patchset/20260=
503101229.654763-1-agarwal.vineet2006@gmail.com" rel=3D"noreferrer" target=
=3D"_blank">https://sashiko.dev/#/patchset/20260503101229.654763-1-agarwal.=
vineet2006@gmail.com</a><br>
<br>
</blockquote></div>

--000000000000f614250650ea01d0--

