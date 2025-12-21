Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 135D5E6748D
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 02:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B56E6B0005; Sat, 20 Dec 2025 21:35:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562B96B0089; Sat, 20 Dec 2025 21:35:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444446B008A; Sat, 20 Dec 2025 21:35:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 317466B0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 21:35:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B48C8137B79
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 02:35:32 +0000 (UTC)
X-FDA: 84241912104.27.B174E00
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51707140005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 02:35:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D2YnNy8L;
	spf=pass (imf09.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766284530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gQsxdbTqeeMlgNLXWeTs3T6PsiN7QVqODqMSF2qt/w=;
	b=RceoVPdQTNrAOhJb1ZotkFV/OZ/QviRHrKHlAnXaTogSOKTWos+EpIDi0iDfvdVlWSGE+w
	hcsAvmNFmJDwmKMrykJqUSJikT9r4KjjqJO+Qn6g5FcCE18iUeqhnxy/sge8whk/lzLyb4
	YJDCfw40U5HbruTejSw89hase3JzGsM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D2YnNy8L;
	spf=pass (imf09.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766284530; a=rsa-sha256;
	cv=none;
	b=e1RkLz/xF+gwsqTINDS+yYvIII9kgei14yknt4T+COyqJqKb6tNAEhSt6DARVb56aFXrEP
	vmEzJw7yV6l/n3a3QTJaIltQpyc1V0Vubg9c1iFWkHDw4EEEOQgjseCe4x+hS8FPClyMcJ
	0Sv188gbsxUt4fL/7xTnca/ho47ZTbE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766284529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5gQsxdbTqeeMlgNLXWeTs3T6PsiN7QVqODqMSF2qt/w=;
	b=D2YnNy8LDxxUS87sb76smHZjI/1u8ewr2NDw4wdKjgyxZ38Zw6dma9br4eW9/r0NSBOaQx
	7lbJScDqLSi7aBBeL1R1kv4LCn8oqdeiqRzQ2BQVJoxaK2wuEHaqbgQN8Njf9FbTrnOYJR
	4KDTfKgvmho/LIgAt6lr2QuKr1/YEY0=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-VTpQ5Ky6NwuSIGNF3gCE5A-1; Sat, 20 Dec 2025 21:35:27 -0500
X-MC-Unique: VTpQ5Ky6NwuSIGNF3gCE5A-1
X-Mimecast-MFC-AGG-ID: VTpQ5Ky6NwuSIGNF3gCE5A_1766284527
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b630753cc38so5114242a12.1
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 18:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766284526; x=1766889326;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gQsxdbTqeeMlgNLXWeTs3T6PsiN7QVqODqMSF2qt/w=;
        b=R1SUIRTCTLC1nAZLJ38CRKILgH2snDRn8EF3uh9cKiW8dP/+VyBltd0Jmrp626u3mm
         +2LZmN8+SqbgzViZPOWuGSqEjH/2+7BWvIB3idg3GkBNmSskIo8LoJZ4JpXDlOGAAea7
         4FVhf2UxTYdCPPSCw/AOP2W7qxaCCZq1TDs/GBtlin/C0I5051dKiPDI1d/VAYXtc6sB
         uCwn9yQKWvIv12J1c8CdUrLiyzLr26YWknvdqou+vZfoyrBEC/e8INwOqwZhBbwHflB9
         k11xA8NNAQknFu3UU4hTHDHgUsRpstWQUVTDfUA1Oe2mAuThRk5NwffRlrtyFY1MZUi/
         V/ig==
X-Forwarded-Encrypted: i=1; AJvYcCWPCs3FpOfdU7pHoYVLJxTHqCbo52E/j6QdF6MpgXvhXr+mRrof82TAcBIiEjm6te7csBjY/s+5xA==@kvack.org
X-Gm-Message-State: AOJu0YyJICTW66sH/unuVZu4j2bjGQ9ajutcdKoAaj22BBjHINO/aOFZ
	Bj2qO0eR1y0XSlf1YfdYD4VUSiPy32dWcQXQiiq2MPaPKWd4KodIVnF8Ly/jNMGhpAy1iFOFeIp
	Wy0ECkBEwynIn2ryjIxaauIYRIBswKmkHpQDz8XvC8Ok+Sxy+Y6WmQtaxNnJ/+ATPUAF/X7QHZI
	A3+ysFBtQYLgUTlA8Jrc6C9wXb7aQ=
X-Gm-Gg: AY/fxX5UneDEscKfG83oClD1YxRqJGFYHDfvVoM5oNbMZmjkthY01PLlqB6uedMDG+T
	ASWhlAKuQ/ZCJh4/WpTfO+Sx+iZsduwnFkuqvJwdKEn+MkF19wZPsJugiBM7nos3HfSZa9gJm4s
	lwT+L8LFQCviTeSARwTt0YUi5CXrCFhJ9VI1j5WPNubIP5WOYWHx9ps8aaq6IbOjFr0XU=
X-Received: by 2002:a05:7301:4d16:b0:2b0:5306:1770 with SMTP id 5a478bee46e88-2b05ec3de81mr6388823eec.22.1766284526603;
        Sat, 20 Dec 2025 18:35:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeR4EsbezqFgEtlO04QhomF0cYTX4Y8ONQC2CZdQYoTrheRMgvamu1rUjFi3tWwkJ2xq+w8KIq1PL21XREyuw=
X-Received: by 2002:a05:7301:4d16:b0:2b0:5306:1770 with SMTP id
 5a478bee46e88-2b05ec3de81mr6388813eec.22.1766284526145; Sat, 20 Dec 2025
 18:35:26 -0800 (PST)
MIME-Version: 1.0
References: <20251220111645.2246009-1-liwang@redhat.com> <20251220111645.2246009-2-liwang@redhat.com>
 <20251220105811.3516167661cd696f464cc3b0@linux-foundation.org>
In-Reply-To: <20251220105811.3516167661cd696f464cc3b0@linux-foundation.org>
From: Li Wang <liwang@redhat.com>
Date: Sun, 21 Dec 2025 10:35:13 +0800
X-Gm-Features: AQt7F2qDbPwihelw_YUrtxt3d6alO2f-YhYevZjk-CxfxOlZGK9drdUm7A6lE88
Message-ID: <CAEemH2fsZAWnzCzv5vSyf-GRxExFaeUR_vYex9KxAtnBw-_b_Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] selftests/mm/write_to_hugetlbfs: parse -s with
 strtoull and use size_t
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Waiman Long <longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sl0ri9-rgPxAPFyTGj2kBVNzRnNLX71TqmyB8E9OcO4_1766284527
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="000000000000c0eb4406466d293d"
X-Rspamd-Server: rspam02
X-Stat-Signature: ndqz55uxicg984xy5im8k6ygf4e57h4g
X-Rspam-User: 
X-Rspamd-Queue-Id: 51707140005
X-HE-Tag: 1766284530-869563
X-HE-Meta: U2FsdGVkX18K3vspa+MhdjArlH3kRg3ICw9g3EW6X4i/NOq15+bt/LpyL3azFQfM2yJSHWFDN3/rpzK8nvBK4a2CaewIhhsjb7JJQsApyTDl2ELWHm2dmdWKiU6TcWxTZ3dDxW74RUHrGK92Sp6CGs6d9JnBg/FXK6jLKwZiIHgvZ1EvzKSpnjjB8pucYA7ihMvRbpC/eb2t62/00vX68HhLsYKTQ5KuKE9mCFiOLF7yOnhHdtNS3DfEEmocBnmCMtzFlnDvHk+8rgGnsxbBeSSBef9E+ADuPP+hRU857EWf0F/8NwQnAn1S0WOlM8H7xaPbVWf6a9sXWxmXtqG4QnRCuB/+yHT+fvRCiMRmO0jpp3MtLcFkxndhpcbONe3bpA+swc835Cst8myRHKxeVWpxgBxBIOoTmRLIw+wSvl/QfID9EjpskNDOKVtNd8MMg8/fiHx6oDNRkyBAWlDay/tGeLDUotgsaHRsVUp+yzsaA73boqN5HueUx9+xi32yCO9koEKdRbLvHw9oJJ6DIAQ3LuWE5uJMTAB8aVUZRsvhmGlo+0qZBhA9h0ulSs3evF3YNKkbHnxRmc3VrPOkUiISRzs64J0ucTVT/t8+zqkoEiLi35+Wbc7/J6NERZMl7P07pMS6HrQ2cnSF4nY/UnrQ9Tj3dWEqnWAmYs/YRmjmTuDjLslLRMC4qOQ3aGHKPJvkW6CwrlR5OulEWOwpMraPXc3M+8CHtSS0hpLGb1/2gp6Sx2deUxCAt3gusdb15PGvr1o0YZWgnLCzwfoleTDDpkjIyIOjNL4zgyS/HYKL8jw7kppsQmLNaHbTjIVXZh5uhfh78r3INUGPIZhNLVphmUO8mcM32Jw/PNPJgphqONyQgDiZElTOj/3GjnBVeBghMFzExRENbVw+I/JlxqOoOPLHFIq0+ZaGwbygtMTTzBx8gaqWqunBgkLgqaFEHCxOG5FkKhuJUoQx0l1
 2v8cRTSy
 9HXB/GOuseD9SmrIt66jCvuM8xBbzUp7ZhwblRUAZUYf8FnrT2oEpHrL/V7aNn9aV/bqn2yNCRCchsFmludsuTvYSvBMJCntxCU1wQ9/gye/7TFh5I0cQDSpnelkkvCXW47PHtf4GsnpiOuKkuPBPKhiXnhuwQRuadqIqE07ZIq6PKPLs1ay5KxLiAQAFOdnzu32QAl+0BuuYxlIPnIShOS+evKMcpAS/Y5PRU9k6wY0zl7V/YLZinB5YX4OopPeqJrpB8dr8I20btMbbw49yX1FnZhs1xYikSN13lErEd1D6iUvrfuok0YNbrh6xG4tnoUbJ/29YrE6VQqgDEAlyeRO2VirQKUc6JgNmQRtwfBrhdHud7HoZlIzilVl/qaLJrzEhqSHCC8CnFnEhXHSlxKAO4gQvlBNZBkAvJjvfn/BoyiVr8jt2P8vIZBjLmLKnbqL4lDeNom81Xxh7fSCMrftTb5uqm/4R9ldBNJWOhJOCgTyW0sda7+es6IPZ1VWCgloWNdsFUzMI5tMv4UBWWaHLmhyK/6Py2JIMIIePDbG082Jcvex8dcmmJfIMpS+YA7CCTHNxot866x/+IBVbmzPLqmmA2SQYiw87yMvRiX2tGg5TbEJ67gDzVM3XXZdJVlheeASXYY69jKK2QW14KvtJKpYDJvETzbCJcGV4jCvV2vs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000c0eb4406466d293d
Content-Type: text/plain; charset="UTF-8"

Andrew Morton <akpm@linux-foundation.org> wrote:

>  #./charge_reserved_hugetlb.sh -cgroup-v2
> >  # -----------------------------------------
> >  ...
> >  # nr hugepages = 10
> >  # writing cgroup limit: 5368709120
> >  # writing reseravation limit: 5368709120
>
> Can we fix that typo while we're in there?  "reservation".
>

Good catch, let's fix it in patch 2/3.


> >       while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
> >               switch (c) {
> >               case 's':
> > -                     size = atoi(optarg);
> > +                     errno = 0;
> > +                     char *end = NULL;
> > +                     unsigned long long tmp = strtoull(optarg, &end,
> 10);
>
> Coding-style nits: we do accept c99-style definitions nowadays but I do
> think our eyes prefer the less surprising "definitions come before
> code" style.  So the above could be
>
>                         char *end = NULL;
>                         unsigned long long tmp = strtoull(optarg, &end,
> 10);
>
>                         errno = 0;
>
> Also, `errno' belongs to libc.  It seems wrong to be altering it from
> within our client code.
>

Indeed, since I saw 'errono' modified in many places in this test,
so to avoid other effects, I set it to zero. However, we can abandon
this method and use sscanf() instead, thanks!


>
> > +                     if (errno || end == optarg || *end != '\0') {
> > +                             errno = EINVAL;
> > +                             perror("Invalid -s size");
> > +                             exit_usage();
> > +                     }
> > +                     if (tmp == 0) {
> > +                             errno = EINVAL;
> > +                             perror("size not found");
> > +                             exit_usage();
> > +                     }
> > +                     size = (size_t)tmp;
> >                       break;
>
> I'm not really clear on what problems we're trying to solve here, but
> this all seems like a lot of fuss.  Can we just do
>
>         if (sscanf(optarg, "%zu", &size) != 1)
>

Yes, I admit I was overthinking the int overflow handling.
This is nice, so the V2 should be simply like:

--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
+++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -68,7 +68,7 @@ int main(int argc, char **argv)
        int key = 0;
        int *ptr = NULL;
        int c = 0;
-       int size = 0;
+       size_t size = 0;
        char path[256] = "";
        enum method method = MAX_METHOD;
        int want_sleep = 0, private = 0;
@@ -86,7 +86,10 @@ int main(int argc, char **argv)
        while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
                switch (c) {
                case 's':
-                       size = atoi(optarg);
+                       if (sscanf(optarg, "%zu", &size) != 1) {
+                               perror("Invalid -s.");
+                               exit_usage();
+                       }
                        break;
                case 'p':
                        strncpy(path, optarg, sizeof(path) - 1);
@@ -131,7 +134,7 @@ int main(int argc, char **argv)
        }

        if (size != 0) {
-               printf("Writing this size: %d\n", size);
+               printf("Writing this size: %zu\n", size);
        } else {
                errno = EINVAL;
                perror("size not found");


And, if no more comments on the rest of patchset, I will send v2 later
today.


-- 
Regards,
Li Wang

--000000000000c0eb4406466d293d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_defa=
ult" style=3D"font-size:small"><br></div></div><div class=3D"gmail_quote"><=
div dir=3D"ltr" class=3D"gmail_attr">Andrew Morton &lt;<a href=3D"mailto:ak=
pm@linux-foundation.org" target=3D"_blank">akpm@linux-foundation.org</a>&gt=
; wrote:</div><div dir=3D"ltr" class=3D"gmail_attr"><br></div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">
&gt;=C2=A0 #./charge_reserved_hugetlb.sh -cgroup-v2<br>
&gt;=C2=A0 # -----------------------------------------<br>
&gt;=C2=A0 ...<br>
&gt;=C2=A0 # nr hugepages =3D 10<br>
&gt;=C2=A0 # writing cgroup limit: 5368709120<br>
&gt;=C2=A0 # writing reseravation limit: 5368709120<br>
<br>
Can we fix that typo while we&#39;re in there?=C2=A0 &quot;reservation&quot=
;.<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=
=3D"font-size:small">Good catch, let&#39;s fix it in patch 2/3.</div></div>=
<div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while ((c =3D getopt(argc, argv, &quot;s:p:m=
:owlrn&quot;)) !=3D -1) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (c) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case &#39;s&#39;=
:<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0size =3D atoi(optarg);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0errno =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0char *end =3D NULL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0unsigned long long tmp =3D strtoull(optarg, &amp;end, 10);<br>
<br>
Coding-style nits: we do accept c99-style definitions nowadays but I do<br>
think our eyes prefer the less surprising &quot;definitions come before<br>
code&quot; style.=C2=A0 So the above could be<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 char *end =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 unsigned long long tmp =3D strtoull(optarg, &amp;end, 10);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 errno =3D 0;<br>
<br>
Also, `errno&#39; belongs to libc.=C2=A0 It seems wrong to be altering it f=
rom<br>
within our client code.<br></blockquote><div><br></div>Indeed, <span class=
=3D"gmail_default" style=3D"font-size:small">since=C2=A0</span>I=C2=A0saw &=
#39;errono&#39; modified in many places in this test,<br>so to avoid other =
effects, I set it to zero. However, we can abandon<br>this method and use s=
scanf() instead, thank<span class=3D"gmail_default" style=3D"font-size:smal=
l">s!</span><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex">
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (errno || end =3D=3D optarg || *end !=3D &#39;\0&#39;) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0errno =3D EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0perror(&quot;Invalid -s size&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit_usage();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (tmp =3D=3D 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0errno =3D EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0perror(&quot;size not found&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit_usage();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0size =3D (size_t)tmp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0break;<br>
<br>
I&#39;m not really clear on what problems we&#39;re trying to solve here, b=
ut<br>
this all seems like a lot of fuss.=C2=A0 Can we just do<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sscanf(optarg, &quot;%zu&quot;, &amp;size) =
!=3D 1)<br></blockquote><div><br></div><div><div class=3D"gmail_default" st=
yle=3D"font-size:small">Yes, I admit I was overthinking the int overflow ha=
ndling.</div><div class=3D"gmail_default" style=3D"font-size:small">This is=
 nice, so the V2 should be simply like:</div><div class=3D"gmail_default" s=
tyle=3D"font-size:small"><br></div><div class=3D"gmail_default" style=3D"fo=
nt-size:small">--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c<br>+++=
 b/tools/testing/selftests/mm/write_to_hugetlbfs.c<br>@@ -68,7 +68,7 @@ int=
 main(int argc, char **argv)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 int key =3D 0;<=
br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 int *ptr =3D NULL;<br>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 int c =3D 0;<br>- =C2=A0 =C2=A0 =C2=A0 int size =3D 0;<br>+ =C2=A0 =
=C2=A0 =C2=A0 size_t size =3D 0;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 char path[2=
56] =3D &quot;&quot;;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 enum method method =3D=
 MAX_METHOD;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 int want_sleep =3D 0, private =
=3D 0;<br>@@ -86,7 +86,10 @@ int main(int argc, char **argv)<br>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 while ((c =3D getopt(argc, argv, &quot;s:p:m:owlrn&quot;)=
) !=3D -1) {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 swi=
tch (c) {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &=
#39;s&#39;:<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 size =3D atoi(optarg);<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sscanf(optarg, &qu=
ot;%zu&quot;, &amp;size) !=3D 1) {<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 perro=
r(&quot;Invalid -s.&quot;);<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit_usage()=
;<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 case &#39;p&#39;:<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strncpy(path, optarg, size=
of(path) - 1);<br>@@ -131,7 +134,7 @@ int main(int argc, char **argv)<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>=C2=A0<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (=
size !=3D 0) {<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf=
(&quot;Writing this size: %d\n&quot;, size);<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;Writing this size: %zu\n&quot;, size)=
;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 errno =3D EINVAL;<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 perror(&quot;size not found&quot;);</div></=
div></div><div><br></div><div><br></div><div><div class=3D"gmail_default" s=
tyle=3D"font-size:small">And, if no more comments on the rest of patchset, =
I will send v2 later today.</div><br></div><div><br></div><span class=3D"gm=
ail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signatu=
re"><div dir=3D"ltr"><div>Regards,<br></div><div>Li Wang</div></div></div><=
/div>
</div>

--000000000000c0eb4406466d293d--


