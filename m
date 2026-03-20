Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941641099B30
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DC26B0196; Fri, 20 Mar 2026 16:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054956B0197; Fri, 20 Mar 2026 16:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E866E6B0198; Fri, 20 Mar 2026 16:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D646D6B0196
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:11:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A05C0136F48
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:11:00 +0000 (UTC)
X-FDA: 84567535080.21.AE9EF28
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 76267C0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:10:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AVvl85f0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of avagin@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=avagin@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774037458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhhwaRJdr3m+a+e4RMd5a5+XxZM0v4uXF5JcXjlZmjs=;
	b=ycfbs2/dObAR/Kc9LJ8ljtXE0Mm01IhR/KPIjAXhJ6iGM0y7SvGryBvlG/ZK/0lC2btH2k
	ODu9X6ofbld60MWdzE3UsKZoWxbmq6K18moq7HXSazY72BDTmIh/K7CYN0DAnKX0s6dQtG
	mZp8pGIGPUfhlwWuOdA/UZiR7qGaouI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774037458; a=rsa-sha256;
	cv=pass;
	b=gW3HTGUqpnfPM53iQmYw6S5ovhJw0BFNXby5IEjKS1aVGUNp/1WPPQRMzj3xLqnn+w7ab2
	UUUl9j5yM+/TjCEN11aakozLQXUjh+9HxWSVZEQqXRxZaEpUgUPR8f1WziAd6nOj3vUgfC
	bGfR3pMJue2LZ5lRH4OEt2oqC3NKQNI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AVvl85f0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of avagin@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=avagin@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-509062d829dso36931cf.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:10:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774037457; cv=none;
        d=google.com; s=arc-20240605;
        b=K4v1xvH6Kf0Pib21CPeaoHyU8OUCPfICTvdwL7gM2Q1JAmw2tu7rjj0nvMwtOpmP3A
         DNg1zDJZ0tK8V3307frve9FynofTJcarDbNGC+4k/3fgCldlzXB49ArN9/HO7L+poJmt
         Y4mxGX5RIbSGTCPwB/bnZxmEETDJ4r0rSpLVpcQrOWV1hCnWlC9zR2UM9B0lCE23qJL5
         a1VCDfT8cuygjpp1JeA968A3+HRaFVW5bN0CCMJt/N9TYrcOT0C4aAx6yghlcV/L5HRo
         UVxu2L34eC5yssP2a5lakzkQhd5hT2PmhHel/0KxJR+OwYqz2/D51BQk8wFg9CPBX6i8
         bf8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LhhwaRJdr3m+a+e4RMd5a5+XxZM0v4uXF5JcXjlZmjs=;
        fh=nd9J0VQn/C0zZEnTQIu4Fx8omwOYfQSpADa0zDZKdwk=;
        b=A9Kz4+z4YtPzDYL/pYoEb1VSNSIaUouMTZOrIG63wN6eUoLT7AJDw7/LLV6XnoMawz
         6bc5+Ec2pKyQ3jXEawMKpeZH+/cpIhyLMjSj7FKqpDXfk5HcNamEGdeMcKMWmOuUvLcE
         6L1tDT1LIw4V6fS8zn3uqwKKN5ikncHolGBGrXjx1qhEobPQ5YgMftEz5a+EiWQBBxD7
         jR/JYOAiDm9S9FDPx3JiwCutPKHt4Ftdz7TUlWaQeMcxGqGZBaGeSZPbEmzWtiD/O9Ji
         xv29aLFhGSShtewt2nRt7sgu8BTFZ0Dp47dlYNWpImXUrX+OS93mzILIe6FKhe4TXV4P
         9vkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774037457; x=1774642257; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LhhwaRJdr3m+a+e4RMd5a5+XxZM0v4uXF5JcXjlZmjs=;
        b=AVvl85f0jpB1FkYdXzVszS5+DcOebgXXk6lzVhdI0aZBrr3rkK8ztcvgUEIZwN9CCX
         3f1xSKTL31rEJHfArSQ1aNaAPhFORnntvmKlHIzjxOBT+Om96UPM00cl+QjF3eRCynnc
         22W4lr/7DzZmVzRL/mWBf+DlbnIXoUuAU5cmUPu00/XonLlDg4tssKw1IuydKsZhxspV
         9dJ9kixndgcU062cOT4tQ5QzfIt1Vtq88YLidL1gzGBqpYdPE0CjHyGLmSH0pWbSwF/j
         LV8sJCYCxXfD4rDdtDgPN20Jhqwf1IBsnlBQRtdRgwib/q8YoVlC0uhQmQHmPQD7wdyl
         WwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774037457; x=1774642257;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LhhwaRJdr3m+a+e4RMd5a5+XxZM0v4uXF5JcXjlZmjs=;
        b=kEynkANxlHYGKhD+mGfBqWvF9koWQoyWzZlAgt0t9r+ZEk8Az67YyJ16q7w4vjjkBR
         0mcBefvK+TJ3upWQDSJCLfUs9sTYg6GUHlNW1HmzbdIqvtD+KGImljxFhUTZwK0C0Ec7
         S8ckoRe4gL4mArh/1vQdvuyAlyrwd9j9p57/FjCeb6Dl65JGT5t1NCPyWgmTJhOPiTwf
         VhraTTDcvIBk1rxxEV3ExItY7u0+QNHE3vPkxmz17mH0wg2cr8byBR6ZCUx17bC6OqBe
         cbtPcx2eyF0cVKnWBU7g85t/Kc+nvviNiveob+3GsVVF65GDR630EfO1FlpUGIUPYcRC
         Bciw==
X-Forwarded-Encrypted: i=1; AJvYcCWMgcOM1Ta15pEEOhAbdbkiFzTCN1OhN5WpsRQD2p18GuU5ETnpISypOMqkmb8m9NK+CwNdlOHGxw==@kvack.org
X-Gm-Message-State: AOJu0Yxx1lce+v8Z6g4OM8qWuRcIzwqVdbF0eb33IE1p/pzZCuGipInh
	B4P94Rp+aMIuQJjP8mLRkioToSmfIrHMj4DSsppdhCv1PRR2RD9D4F76rxBQE63kl9nYfdAM8/5
	GTjeX/8a4r1hBvTLreH+3+1zLpvXY9529XT7q7Cfa
X-Gm-Gg: ATEYQzx7YsuepaOyDA02HFh/C/Sm/J7q0PJuBJgHpriUd7w8tqlMZnFMbXvwWvaJeEd
	npChUaLncY3QpFJHGRT1NjDB6HoAK0wssf5D+GN5pabbgpRNm9ebDYdQf6Rk+IMlSEG6wHlBVcT
	vOb3WODA5Gt6cF0MNI1MaYy7sJORQSNEPSQHWVbWOWwaM5ucEnIrwGAGtRw3lRi8WhighgH5bT6
	b7qdWIw+V1poX+Fwd2Q/Ja7OjW0RC7IiJK4x8O6CrKUCDqbNzkKHMJJi+toZHP7tKE0zHyEG8Xa
	kABwqu4=
X-Received: by 2002:a05:622a:8d1b:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-50b46cd00damr3116521cf.12.1774037457126; Fri, 20 Mar 2026
 13:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260217180108.1420024-1-avagin@google.com> <20260217180108.1420024-3-avagin@google.com>
 <CGME20260320091528eucas1p14a64767f916b556d30cfa00bfd320ace@eucas1p1.samsung.com>
 <aec9c36d-d67a-4b61-9950-57b95afedf75@samsung.com> <202603201118.2F75F8D@keescook>
In-Reply-To: <202603201118.2F75F8D@keescook>
From: Andrei Vagin <avagin@google.com>
Date: Fri, 20 Mar 2026 13:10:45 -0700
X-Gm-Features: AaiRm51yn5c4oimlFjjoRvWoFjMJfZAHWiv8mClLSa5lHouXZ2YDt9TCQwUh5jQ
Message-ID: <CAEWA0a5L-OAsc6x9i4TvSHN9D3ox7geXquZ+7yYYWueG3C47kg@mail.gmail.com>
Subject: Re: [PATCH 2/4] exec: inherit HWCAPs from the parent process
To: Kees Cook <kees@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: multipart/alternative; boundary="00000000000073cd1b064d7a4849"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 76267C0004
X-Stat-Signature: 9xmri9rdwson1bi57becqmfhsu4wi9a5
X-Rspam-User: 
X-HE-Tag: 1774037458-305202
X-HE-Meta: U2FsdGVkX1+QKfsqZcA11xPEyXBw9X+wPjHL3ct/QxW0Jau1lbv8m4j+raVJ2xbduV4j/U6GJvgGbI0y2yEYeXhMeer+U6iLjxWS5DhXL1bB2pJZY6GFpTN89DotPvoi6+QKrOccFTxWauyLEENZ3xsX3myTIkXMtd1VqaeA8bf7vpOe6t/KrICKqPtnaKj6FwQ7s/E2LjfJ7AmMRwOwDECfpZI2iP9JBmuySZrRtdnDWeP8XAZWtVzlJL1yfYeYDC8gdQFs8+lSlsqtLW6xPW3fXrRrQb1jjN8yN21NOHS3XoMhvlDI9LFUcNiOekIt1aCmhJvZZb7NZo1EeATc1Tm20TIAWH3LHBb82FrJ0WFdCaYuZ0YL4k/TCtSRnmSq5bOHC625Ajo2r3mlAl+mWH1fG95fMNHAexLK4hW7HD2NjZPAmmCj5EJpQMm/EvCYe+6mMLaYh65XtRnjGsWJK/m7KdykmWgvKAvZiAHWjQiW7D38hzsAWJE+muStXvMkvxQMt9jJEKNNGYpP5E1MJy+ib54DIRFLyUHwl2Tsa50y4WBXZ6jRlMqwKhY3FxG6XvgxnQC4NCNX3CREX5zCgQLE0VPMrciHG7RTLN5CMIA2FmbloWs9udCZe8bOhcGrPulESRofzTAn8iz1m+uwjF5vyA/mMf4u0G/93E5T5HkiDSiisCjPwc6pjC9oWswSOslIi+uQFKPDcDV55QFYVeEqaPOL13Mf7a1cBAhULFdaYKjj8fbw4TZRMx8uzwzlt968bR8exK+ZSEqG/1+tJ8fseqotLAPtnZ82p93+xy+0andaD/kEMfVOczIg2WCiYegsCH17TFM8yiAYdbVV3z3EgpqlcdSVcaaMz4kG5V2HoG3uMX13RpcX62BOX9aAD2bHDL+eFQXfsGWf2urH2akMrEJy6V29IW2qzYd8yNC12E7xH/AyJDVyGONeKYBQqGb5/aG8TrF3DVlfWIa
 S7yIqZwC
 PSYwl5s2vGhD+dMbyMDRiSxxFqBLPvCmemoifdSf2rgp3F3eQ18jDpyd4F+PmfqlNRU15y4HGWpOnJurhW8CrRBKnPcFxU9M/c7YmN9ovUe0rbi1MiT2L38skOaE0zgFTtSW8XFb7UHESjl+pfYQtEozQIRa8rQrtNOIDS+nG0lbyOuOLdlGV/HMSyWncVm3Z+WP5MaWmlqgUleuG8EDzymuIcBz7aMSRGWp3V07+49mMiEa8zS9Qx982c1JQZX9XD66dE2+zRdoPLYBP0U2BCzGIgaCX/G3J0/nkUcnH+5RG35/DYFPfcmy9e6dkubixGN/emlvlCQqzhLCYWarbv16rqOb63K5Y1Ow+DYfGbL64nqGAi0kjv+OVhkmiBZw/sWPYRSbmd9a/gzYwY1hoF5BjXaKFbLOaSvjZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000073cd1b064d7a4849
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 20, 2026 at 11:19=E2=80=AFAM Kees Cook <kees@kernel.org> wrote:
>
> On Fri, Mar 20, 2026 at 10:15:26AM +0100, Marek Szyprowski wrote:
> > Hi,
> >
> > On 17.02.2026 19:01, Andrei Vagin wrote:
> > > Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
> > > AT_HWCAP2, etc.) from a parent process when they have been modified
via
> > > prctl.
> > >
> > > To support C/R operations (snapshots, live migration) in heterogeneou=
s
> > > clusters, we must ensure that processes utilize CPU features availabl=
e
> > > on all potential target nodes. To solve this, we need to advertise a
> > > common feature set across the cluster.
> > >
> > > This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
> > > auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).
When
> > > execve() is called, if the current process has MMF_USER_HWCAP set, th=
e
> > > HWCAP values are extracted from the current auxiliary vector and
stored
> > > in the linux_binprm structure. These values are then used to populate
> > > the auxiliary vector of the new process, effectively inheriting the
> > > hardware capabilities.
> > >
> > > The inherited HWCAPs are masked with the hardware capabilities
supported
> > > by the current kernel to ensure that we don't report more features
than
> > > actually supported. This is important to avoid unexpected behavior,
> > > especially for processes with additional privileges.
> > >
> > > Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > > Reviewed-by: Alexander Mikhalitsyn <
aleksandr.mikhalitsyn@futurfusion.io>
> > > Signed-off-by: Andrei Vagin <avagin@google.com>
> >
> > This patch landed in yesterday's linux-next as commit ac8c259ce0d5
> > ("exec: inherit HWCAPs from the parent process"). In my tests I found
> > that it causes regression on my Khadas VIM3L board, which is based
> > on Amlogic Meson SM1 (S905D3) SoC
> > (arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts). Running init
> > process fails after this patch:
> >
> > Freeing unused kernel memory: 13696K
> > Run /sbin/init as init process
> > Kernel panic - not syncing: Attempted to kill init! exitcode=3D0x000000=
04
> > CPU: 1 UID: 0 PID: 1 Comm: init Not tainted 7.0.0-rc4-next-20260319
> > #12369 PREEMPT
> > Hardware name: Khadas VIM3L (DT)
> >
> > What is probably important here, this board (for some internal,
> > historical reasons) uses armv7l rootfs, but other boards used in my
> > tests, based on different SoCs, also use such rootfs and boot fine with
> > yesterday's linux-next. Reverting ac8c259ce0d5 commit (together with
> > 0ea77bbf3b98 due to dependencies) on top of next-20260319 fixes this
issue.
>
> Thanks for the report! I've dropped these patches from -next for now.
> Andrei can you investigate what is needed to fix this?

Sure, I am working on that. The issue relates to how COMPAT_HWCAP-s
are handled. I will prepare the fix.

Thanks,
Andrei

--00000000000073cd1b064d7a4849
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>On Fri, Mar 20, 2026 at 11:19=E2=80=AFAM Kees Cook=
 &lt;<a href=3D"mailto:kees@kernel.org">kees@kernel.org</a>&gt; wrote:<br>&=
gt;<br>&gt; On Fri, Mar 20, 2026 at 10:15:26AM +0100, Marek Szyprowski wrot=
e:<br>&gt; &gt; Hi,<br>&gt; &gt;<br>&gt; &gt; On 17.02.2026 19:01, Andrei V=
agin wrote:<br>&gt; &gt; &gt; Introduces a mechanism to inherit hardware ca=
pabilities (AT_HWCAP,<br>&gt; &gt; &gt; AT_HWCAP2, etc.) from a parent proc=
ess when they have been modified via<br>&gt; &gt; &gt; prctl.<br>&gt; &gt; =
&gt;<br>&gt; &gt; &gt; To support C/R operations (snapshots, live migration=
) in heterogeneous<br>&gt; &gt; &gt; clusters, we must ensure that processe=
s utilize CPU features available<br>&gt; &gt; &gt; on all potential target =
nodes. To solve this, we need to advertise a<br>&gt; &gt; &gt; common featu=
re set across the cluster.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; This patch a=
dds a new mm flag MMF_USER_HWCAP, which is set when the<br>&gt; &gt; &gt; a=
uxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).=C2=A0 Whe=
n<br>&gt; &gt; &gt; execve() is called, if the current process has MMF_USER=
_HWCAP set, the<br>&gt; &gt; &gt; HWCAP values are extracted from the curre=
nt auxiliary vector and stored<br>&gt; &gt; &gt; in the linux_binprm struct=
ure. These values are then used to populate<br>&gt; &gt; &gt; the auxiliary=
 vector of the new process, effectively inheriting the<br>&gt; &gt; &gt; ha=
rdware capabilities.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; The inherited HWCA=
Ps are masked with the hardware capabilities supported<br>&gt; &gt; &gt; by=
 the current kernel to ensure that we don&#39;t report more features than<b=
r>&gt; &gt; &gt; actually supported. This is important to avoid unexpected =
behavior,<br>&gt; &gt; &gt; especially for processes with additional privil=
eges.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; Reviewed-by: Cyrill Gorcunov &lt;=
<a href=3D"mailto:gorcunov@gmail.com">gorcunov@gmail.com</a>&gt;<br>&gt; &g=
t; &gt; Reviewed-by: Alexander Mikhalitsyn &lt;<a href=3D"mailto:aleksandr.=
mikhalitsyn@futurfusion.io">aleksandr.mikhalitsyn@futurfusion.io</a>&gt;<br=
>&gt; &gt; &gt; Signed-off-by: Andrei Vagin &lt;<a href=3D"mailto:avagin@go=
ogle.com">avagin@google.com</a>&gt;<br>&gt; &gt;<br>&gt; &gt; This patch la=
nded in yesterday&#39;s linux-next as commit ac8c259ce0d5<br>&gt; &gt; (&qu=
ot;exec: inherit HWCAPs from the parent process&quot;). In my tests I found=
<br>&gt; &gt; that it causes regression on my Khadas VIM3L board, which is =
based<br>&gt; &gt; on Amlogic Meson SM1 (S905D3) SoC<br>&gt; &gt; (arch/arm=
64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts). Running init<br>&gt; &gt; =
process fails after this patch:<br>&gt; &gt;<br>&gt; &gt; Freeing unused ke=
rnel memory: 13696K<br>&gt; &gt; Run /sbin/init as init process<br>&gt; &gt=
; Kernel panic - not syncing: Attempted to kill init! exitcode=3D0x00000004=
<br>&gt; &gt; CPU: 1 UID: 0 PID: 1 Comm: init Not tainted 7.0.0-rc4-next-20=
260319<br>&gt; &gt; #12369 PREEMPT<br>&gt; &gt; Hardware name: Khadas VIM3L=
 (DT)<br>&gt; &gt;<br>&gt; &gt; What is probably important here, this board=
 (for some internal,<br>&gt; &gt; historical reasons) uses armv7l rootfs, b=
ut other boards used in my<br>&gt; &gt; tests, based on different SoCs, als=
o use such rootfs and boot fine with<br>&gt; &gt; yesterday&#39;s linux-nex=
t. Reverting ac8c259ce0d5 commit (together with<br>&gt; &gt; 0ea77bbf3b98 d=
ue to dependencies) on top of next-20260319 fixes this issue.<br>&gt;<br>&g=
t; Thanks for the report! I&#39;ve dropped these patches from -next for now=
.<br>&gt; Andrei can you investigate what is needed to fix this?<div><br></=
div><div>Sure, I am working on that. The issue relates to how COMPAT_HWCAP-=
s</div><div>are handled. I will prepare the fix.<br><br></div><div>Thanks,<=
/div><div>Andrei</div></div>

--00000000000073cd1b064d7a4849--

