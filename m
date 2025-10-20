Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0345FCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB468E000E; Mon, 20 Oct 2025 16:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B8F8E002D; Mon, 20 Oct 2025 16:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FD48E000E; Mon, 20 Oct 2025 16:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 33D808E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:54:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D02E5C015A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:47 +0000 (UTC)
X-FDA: 84019696614.06.B3E2F61
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id F1D95A0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mrmy4x5g;
	spf=pass (imf15.hostedemail.com: domain of chuckwolber@gmail.com designates 209.85.166.42 as permitted sender) smtp.mailfrom=chuckwolber@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEzeVMf7yd3k9tN316yfDHR9Rwqsd/fqemFJOI3QiHA=;
	b=sv7JPZZjbNtPAQFLomEFdu+vfXskos3crTn4MMsjdUmju0UTH0TLFXvT/UdxdjuJ4SYnlP
	ubab1o62sDLpFdzgYwYp2SL+PzGkUQWJetKHbwKWtomx7mcf9YyKIIdvTu5+e5l9zmtABx
	3RnTpcU9jhA0Z/NLWsfQZ5v62MBIwJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993686; a=rsa-sha256;
	cv=none;
	b=mojIKOO5j7wHteMTFNedLwo9zRXZie4Tph8i3sdt1AhC4r6h/eCc9avmekOYuYpExCeYUT
	tUyimOdKvF5jv3E6Txlc7NAN07QOb7IO7MBInjV0ZXaMTxPJTkvOccEVqL5lTGGBFdI3e6
	9bVstiMvUeI1KUtr3p420Gi/sc2eR6Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mrmy4x5g;
	spf=pass (imf15.hostedemail.com: domain of chuckwolber@gmail.com designates 209.85.166.42 as permitted sender) smtp.mailfrom=chuckwolber@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-93bccd4901aso416926539f.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760993685; x=1761598485; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cEzeVMf7yd3k9tN316yfDHR9Rwqsd/fqemFJOI3QiHA=;
        b=mrmy4x5gy4724S3wYPLmlIRTnxSzVUsruPUpd4jN3IdxOPQJZSZ5/wa4oxJLgyb8eG
         UFSdimLNmhkD9gbWe7Xz2Q4ZfguWFY/iLL+v1XbC5k+F7VnO8OyERJm5McZA0npsge6Q
         GSvY+jMkkGVATpAylWDOLjmV0y1FZ3clTTTj6rOOF4qrYqiS1k7DDSXaL5CEuNsJYGGu
         N3Av7iy8cdROOIBG8fJoqDaDjDj0oXa9EqqF4fns4YAFOjed6eEIYYWUUY9EwL8somT1
         6foSP59YZ3WiEz3i8CeRdYkI9jFE3vni6okXtHyYS+Ppd2qlkePdEHu9D8EldSPwtrET
         9KrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993685; x=1761598485;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cEzeVMf7yd3k9tN316yfDHR9Rwqsd/fqemFJOI3QiHA=;
        b=cR+kEKQVlNaymgLz0E5GgXAkbimRwL2ep2MCXmRB9HC5pHATzTRzHChmkpdMn9rM4W
         AXF1Z/gx+sjCl7oQJkZDoUGaPBENI9GWR9h7UKpZDtGhIy8m1aj2/PAeIdFnR0KLxv+F
         0Yl8XoNx2cN9vBa7Dr8uz4Esj+8h0fgl2rszxH5SKOsSkQq/jOBY6b/E1fs6R0opBjNy
         wtXPEtBl++68IxEi5Std9qIcv4QtZ8V1qpGcYnm7EjastFHfsacdMpuit5Nsnzo2hj0f
         MW20CBokd6H+cMTwN/1+9XH7wZ8nS8976mh+wFIy/zMLnxj1lDwzNnVlJQmuKBBzQXWe
         FiwA==
X-Forwarded-Encrypted: i=1; AJvYcCX0SytbG0Zyl1v/90Dt4sHLi1cFPlOpioQlK/fnnuhhtTMwkTzvLVrLRceII6820jhVyFDaG1fWZg==@kvack.org
X-Gm-Message-State: AOJu0YxZgBpsvvPdcOIkcRJ201QWpf3eG7abdqIhcXecAsemTLW/3yRk
	Db9a1zoTp6nz94UHDv+r1H9FV6LR2fRZAfeY6aD6UpPoN8pUxg9TAENkpDY0Ct9WJnF2DSLCmUR
	QUzy1dSu6O2uRy2FBdaY4S8Z2reInlNs=
X-Gm-Gg: ASbGncvTkkTLjsiuhzB30IisMXO6sQ4RIROtdJp8f/N/CQvp9llAkUp+ciDuTNTEbPV
	Nse3Afku/e0H1dSeln/IYw5NCbU+HU+eCEjdmageW0z9P120ZHVSb8m36mGZsREN77PQjJwksjO
	cgPX1K672gtJ+7yvrcXulK9h5TmNcyiLx7/0t1niwKD+7eU/1UEWrQUZ8FY/JiPU4h8hSiU2NJ8
	Vr8protyEu+aj7cLVo9CrZtv2fe2nKU1Om3hsfaRXhsJqqzhH1nWHoFks2PFs2hgmOv07tRjsAG
	ZyayCoVo9DQlNbU7bHuIzzPwxqaIcZ6ZmCuGMghcZtAXNewBWsaQVdDiTBG5meOcHyq75bL3UoM
	GfRRUWCLZgsU3oJF4BTjsuz80ge2+jQo5pUGClkLGx9n4z60m9XtQYg48
X-Google-Smtp-Source: AGHT+IHo+9GFPQIZJgMb1zdR4neF+BAoBW8uSVE+l+1oxEKTrQiSqJT6BwvpjuthE7SeqkhLpXqZfQwjf+0vLEL79KY=
X-Received: by 2002:a05:6e02:1a46:b0:430:b05a:ecbe with SMTP id
 e9e14a558f8ab-430c5234cd7mr213904755ab.4.1760993683952; Mon, 20 Oct 2025
 13:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <20250910170000.6475-2-gpaoloni@redhat.com>
 <878qifgxbj.fsf@trenco.lwn.net> <85166a8a-ad54-42d0-a09f-43e0044cf4f4@redhat.com>
In-Reply-To: <85166a8a-ad54-42d0-a09f-43e0044cf4f4@redhat.com>
From: Chuck Wolber <chuckwolber@gmail.com>
Date: Mon, 20 Oct 2025 20:54:27 +0000
X-Gm-Features: AS18NWCz8CUGo4W0Kw553bxc2jcFK5zDsBgIs6orMS07q-VmX96ukenvgRHVvAM
Message-ID: <CAB=6tBSx12EN5c_0sNKQag+-K84G0YSwf_CV3K9ipRJ=7rU-9w@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing
 testable code specifications
To: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Gabriele Paoloni <gpaoloni@redhat.com>, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, gregkh@linuxfoundation.org, linux-mm@kvack.org, 
	safety-architecture@lists.elisa.tech, acarmina@redhat.com, 
	kstewart@linuxfoundation.org
Content-Type: multipart/alternative; boundary="000000000000fbd93b06419d4a9c"
X-Rspamd-Server: rspam05
X-Stat-Signature: fmwusiq69wzgz6ccqzxqiz5kpcapnagn
X-Rspam-User: 
X-Rspamd-Queue-Id: F1D95A0007
X-HE-Tag: 1760993685-432481
X-HE-Meta: U2FsdGVkX18V6xtIsfJ1imKA//q0w5CL76EbMqr+xjrc211laRTsTIlbM3SbEgochwNds+mYO9L6aovYe3HJp0Qg7UIDo3PCKQGcRvTi58qyziS3xg0CcKkOfldYzydRaI4tjX5KcMObaWE4VO/7RJ/SewH+9YNXW5e1l9ugkRSEpKx+KA5IdCWTycXqUBsy+jhOnKxwL0GKlNhO/BicFzdji2JyekW8+ec3lB+XiHSHL/OAR3PXEII3g6yla/9R40mKDufcUsKaRV8XKQmkOjKKA8STKp42MG2E+AY4IL3q9Aha210abuoFWMpErYCU3RVBSaMQvZIwVBJL54qN1SgnHWqFXxejXkSBkjK3zQG2gwQLtoVpVJc3wS2tZjkY6pjLI76s4HSK8BJuZOBV9aoczT+2VBuHl/ZZH8rKttyb1TkD2CF2oeylrXzqcJFKfh32JikCqiWKhQi2YRFjoJzoSZmi7TpkRfRIw9PfvJaBooi5nH0bO5+lV6NGZ74VJCtLMJyNJjIdGVcBkMq8kmny54O451fFfVWKYDPevwUXuu6nXb53+DcnBEJG8Rin2fCFKbZtcyhh8/RZlh57Nmy4Fxg0UNM8waAU7FDVvykUXP2ueV+Lb9x0YkMLxBIRcXXy/R2pH8+kFUeIM3bZkMQshyI9+DtPofSPA9LXFExsSSIs5/Wr8/KV/2MpzGi3QEnPYUTwUNkdVJ2e+jtGLPRj425NVAUfVB5rUiUT6tPF1rBNgKXzHsiy3B3FZ2HjLB89ETgwPQ2GeTMBIWfKFWWpDYrdnITiQCEC5F2r8ljw4LtB3lW3z9FSGa4MWVGAMKvsd1FCmi5ySY/WGh9Fu5vFxaRkFWyL68lVcbwdJzBOE5ormG9Nmspe3NN7Ig79vQs9f2vkm9364qfzYpHcv+QkjshIRn9HruqZrThrOxayQcWQlK50D8NUpeFmu0Y666+9vyUHWcRWFCmj0nF
 3rvU9apI
 51jpbSYZ6hgbAk/yF5eRcePdHCpL/4LnpVKaj3mZX4JsWEWjU1vh5z7A6okY8M/eO2SkJPrEXQpO3O6TtsoYabBedqDfQlYpxUennc63b/RMkspgdxsLk47hazV5lzCY11gQpCo4zmvuHoyYN5EX5TJHdjbMr0Y0WeErnYEPG1vv8RJ/5VoGcZEAQBNLWR/ITxLMpuTbeASnuueGaZcou9A24w7txkJwbyM+eOleGt2bRjRHJ8rcHkyPG7s2alT1GG3WITjn8FLdG+wXoSAP+O99Uigi/vqQLQGKJPSJutY+HIA3HYlG+xu+DYn6nPW+14mfCeID3uwg13mqJqANPwEKIu/mfcQrU1i+2PG1N5EtaE8ihOdXUu7p3Swbyc8Uawb3Y8WRLyEQa+E4ijVXo56NWZ+my1RnkSgjI3PY9C8wkkVIdl7jjhCtkEP4VxRB+rkZuIX1SNiShZnGWyfyP03KtzIZjVZP0FFqyJt3MY39ghHo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000fbd93b06419d4a9c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 7:35=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:

> >> +------------
> >> +The Documentation/doc-guide/kernel-doc.rst chapter describes how to
> document the code using the kernel-doc format, however it does not specif=
y
> the criteria to be followed for writing testable specifications; i.e.
> specifications that can be used to for the semantic description of low
> level requirements.
> >
> > Please, for any future versions, stick to the 80-column limit; this is
> > especially important for text files that you want humans to read.
> >
> > As a nit, you don't need to start by saying what other documents don't
> > do, just describe the purpose of *this* document.
> >
> > More substantially ... I got a way into this document before realizing
> > that you were describing an addition to the format of kerneldoc
> > comments.  That would be good to make clear from the outset.
> >
> > What I still don't really understand is what is the *purpose* of this
> > formalized text?  What will be consuming it?  You're asking for a fair
> > amount of effort to write and maintain these descriptions; what's in it
> > for the people who do that work?
>
> I might be wrong, but sounds to me like someone intends to feed this to
> AI to generate tests or code.
>

Absolutely not the intent. This is about the lossy process of converting
human
ideas to code. Reliably going from code to test requires an understanding o=
f
what was lost in translation. This project is about filling that gap.


In that case, no thanks.
>
> I'm pretty sure we don't want this.
>

Nor I. If you find any references in our work that amount to a validation o=
f
your concerns, please bring them to our attention.

..Ch:W..

--000000000000fbd93b06419d4a9c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-family:monospace">On Mon, Oct 20, 2025 at 7:35=E2=80=AFPM David Hildenbra=
nd &lt;<a href=3D"mailto:david@redhat.com">david@redhat.com</a>&gt; wrote:<=
/div></div><div class=3D"gmail_quote gmail_quote_container"><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid =
rgb(204,204,204);padding-left:1ex">&gt;&gt; +------------<br>
&gt;&gt; +The Documentation/doc-guide/kernel-doc.rst chapter describes how =
to document the code using the kernel-doc format, however it does not speci=
fy the criteria to be followed for writing testable specifications; i.e. sp=
ecifications that can be used to for the semantic description of low level =
requirements.<br>
&gt; <br>
&gt; Please, for any future versions, stick to the 80-column limit; this is=
<br>
&gt; especially important for text files that you want humans to read.<br>
&gt; <br>
&gt; As a nit, you don&#39;t need to start by saying what other documents d=
on&#39;t<br>
&gt; do, just describe the purpose of *this* document.<br>
&gt; <br>
&gt; More substantially ... I got a way into this document before realizing=
<br>
&gt; that you were describing an addition to the format of kerneldoc<br>
&gt; comments.=C2=A0 That would be good to make clear from the outset.<br>
&gt; <br>
&gt; What I still don&#39;t really understand is what is the *purpose* of t=
his<br>
&gt; formalized text?=C2=A0 What will be consuming it?=C2=A0 You&#39;re ask=
ing for a fair<br>
&gt; amount of effort to write and maintain these descriptions; what&#39;s =
in it<br>
&gt; for the people who do that work?<br>
<br>
I might be wrong, but sounds to me like someone intends to feed this to <br=
>
AI to generate tests or code.<br></blockquote><br>Absolutely not the intent=
. This is about the lossy process of converting human<br>ideas to code. Rel=
iably going from code to test requires an understanding of<br>what was lost=
 in translation. This project is about filling that gap.<div><span class=3D=
"gmail_default" style=3D"font-family:monospace"><br></span></div><div><br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex">
In that case, no thanks.<br>
<br>
I&#39;m pretty sure we don&#39;t want this.<br></blockquote><div><br></div>=
<div>Nor I. If you find any references in our work that amount to a validat=
ion of<br>your concerns, please bring them to our attention.<br><br>..C<spa=
n class=3D"gmail_default" style=3D"font-family:monospace">h</span>:W..</div=
><div><br></div></div></div>

--000000000000fbd93b06419d4a9c--

