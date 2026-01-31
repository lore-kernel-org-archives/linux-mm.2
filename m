Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FFDE6BF3C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 01:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C316B0088; Fri, 30 Jan 2026 20:05:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9541B6B0089; Fri, 30 Jan 2026 20:05:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860186B008A; Fri, 30 Jan 2026 20:05:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72BD76B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:05:50 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D929F59619
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:05:49 +0000 (UTC)
X-FDA: 84390466818.18.07C26A7
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id CD2BBC0004
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:05:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4pbBfbIB;
	spf=pass (imf10.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769821548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WR8rpY2KGV4n5Wdzx9LxUGbuZ8iHOgSWcj67TDHRUAg=;
	b=JTqkugl9DVKd9CUjKTvujFDLPS/kGJWMt/dH7T4JehR64/bJnK9MYDKykcck1Kl9U7nQth
	WnQ/e8UWwvqdd6B4k8lV4/AvhgipJ2rGoehT4ubCPLzSeLtLLIzPxz0pTI7zi0rhtNOaZn
	+oyXqNBhOS1hU8WOieBZ2IVWUqzIVh0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4pbBfbIB;
	spf=pass (imf10.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769821548; a=rsa-sha256;
	cv=pass;
	b=118gwb0vdOwKRIHvomY8uz+IAfIPytOf6rFYFhj03W4xJSMh0h6DM7z4MU9O50KuNlzZFW
	1O7I8JH/7Cit5G56I9VObXztxALlF0XFTj0dLSbK71BQf+Q7kQUP5k6/6AxtU8p6Ws4k0B
	6UrMSpvJWLMrcfOk5Qjzj90TkFb2Br4=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b8849dc12f6so402784466b.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:05:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769821546; cv=none;
        d=google.com; s=arc-20240605;
        b=YmxCYnTZkIV3QteUkSICJjS4xfKaB8HGpSVfwkRISq3ISDnNKmVOPx5mcPH4mnBnva
         765VROQgAa5lSFn8ghy0i+NVMm8euSzNycAOqPFA1aBcfL1I7jXCgLmtZ1EK2r/B6pSG
         XtTiwS4HluLoyJ7zds0QGjqcONpMatwyiNh1n3q8CsTxJ/2YIHNmyvp5Cctyig8ay5jB
         wdW4pmiuTGSKCvYcihcLPyAA7R3+tyJ3OVvjDnD1q0b6Mv50VLPbl5KbXv+OSAlvBALp
         vax85I5r//ra9y9EGRexZ45CJdgEMd2+is71n2ILFmCldRdQlJxXAJqHopQjoT+QY171
         OyYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WR8rpY2KGV4n5Wdzx9LxUGbuZ8iHOgSWcj67TDHRUAg=;
        fh=QcfbPIT8w5bLv9VooONXt2uPbuTO7r9EAoiIPO+XczE=;
        b=WvhgTblHhkOMD6FC80T6LSb84trQfHTReaYER1eTIURcWLdGm8j2diFTdNeDP6h2uS
         NGSYeHCs51/k9x5/baYAcJ7k7m3urVhzluXYRCKPOBW3oiiI13ReGplyc0lDmnO/hImu
         4+FqlaGBhAS/7gnAEqSClsYY3g9Rr8PlVy94Dr/kbuLkZ0m9vLKXOONhf26NH5TRjyvG
         f1Gi3JH9G0cxDl6OWhNccjZSzg6YsPGTUa3UomZRrpT0Woi6wxjiU8N2DqxI3ehG70jj
         vxV+sWVO8PkwOofkjW6JfPJYyLQz8i2/wzKaBLi/EyUO00EUK4ODMqbto4nuEleFIU/A
         AJmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769821546; x=1770426346; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WR8rpY2KGV4n5Wdzx9LxUGbuZ8iHOgSWcj67TDHRUAg=;
        b=4pbBfbIBdEvicxuWm0D7DlHcSLqS9v9zOMquOt8SB2ZWaO4yvJOoRfJB5MHAdWXEFR
         CNGtoyyv/JUJ1Hg0mbF0qA7J2f/nxlJgeY++OIJVyjPTKji7tPZ25Sf3+B6HMvUXC5FA
         WpyUPki95VKGz5FWkyQM/MRn9Lekf7wIO68AxmMz/guSQNWNyNfgy7YTzPyqlDWZ2+kX
         9pOalQqPFeMrYUnXhhp/PhB9pDMfVcc8gOI5ETPWk1YiZmABqqD43fcC0T2TUOyZNxSN
         a0+pGU/gglEAjJmE0fnfMFUF47f93ieu7gG7/kmcKE7QGz7rR1fBPBvwvgg/+EQCaNt+
         V9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769821546; x=1770426346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WR8rpY2KGV4n5Wdzx9LxUGbuZ8iHOgSWcj67TDHRUAg=;
        b=ZMq4DeGv/9FLGEuXK5Yrr4kP10xoHa61YqgeitnDaP1NdLdJIFX50N6edoA/Tnzszn
         Ojrd4Obm1/oJhVYFGTlJWXD12scSTBQ32UTAQiEI997PZXaO1Tl22un2LcrnQnIfuse2
         CS+N5x+eoQ4klyxgB7SE71nq492FvK4jKB3fCdP4MzrK9JySABWPtVbGMyPkiHYQhoMC
         VaPpP0tnbrA9D2sPBztCRqiyt8vkpvJOAiz7urGxTTgYcrkrFV7J6DxFuIvGjcbLuAWZ
         uXMJQl+2HbrjBQLCp+NF9kBHRdBI6IDI+343gn8QBSEslcI/0AQuNPqpDlTqjLL52NK6
         bnhg==
X-Forwarded-Encrypted: i=1; AJvYcCUQOi4LkFqoJiNk7ON4ar+0G67bKw1lgdZkpZzHgJKHlETTgIvgQi6QpNt8jfMWpmuLw3nV2vCkKw==@kvack.org
X-Gm-Message-State: AOJu0Yw4tOJ8lXkEs4wsl+SNOZfSgMVnaVqjJjcRNxSHcnB96xIL2RIt
	50wnEcoKURQKHeU+VygdvYNxRgRI6urFywvJxxw9Qghk5a6ex1TBZF7OoS5REbrPVhFkJZNZ9zK
	yakTRjBiA6vGyvR5C1QEcv/8+AupYr5aKMzGI9XMO
X-Gm-Gg: AZuq6aIlyot9NlWDtodxxyP2pz8NRaoF3kycyhvke7OuteMnNFqoRrF54xVcxpOmMUf
	+9byMWegXdWULfCvo798Nrd1WzJUJQSRHtdUGE/gY0ZhOGWAwnMPIIi/ktUPXdFdDhBvOaJc76h
	zyG+c8jk579GtnaRz+iYAx19BTEWaMZmXPHr9zrV1uqVoSn6WoiOgyCWcSnG0ad6g6kaOMInmaf
	gPZX9BkbaHdERmxJ2bxQwIzQQPqFdgp8go0XT+P0Qc7LHbcIpiEneNSh34GXCXh8jYtquJlr+Fz
	gnM=
X-Received: by 2002:a17:907:3e0d:b0:b87:322d:a8bc with SMTP id
 a640c23a62f3a-b8dff696c0fmr254282166b.31.1769821545900; Fri, 30 Jan 2026
 17:05:45 -0800 (PST)
MIME-Version: 1.0
References: <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV>
In-Reply-To: <20260130235743.GW3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Fri, 30 Jan 2026 17:05:34 -0800
X-Gm-Features: AZwV_Qi-TVApb-UR_yhUuzDZcqy8acCYfKVdTsorIhJOL99wmGwpM0Som40uK5A
Message-ID: <CAG2KctotL+tpHQMWWAFOQEy=3NX-7fa9YroqsjnxKmTuunJ2AQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: xzzzf7u68k1bn49ucn7c683iyfhwfi5j
X-Rspam-User: 
X-Rspamd-Queue-Id: CD2BBC0004
X-HE-Tag: 1769821547-706655
X-HE-Meta: U2FsdGVkX18O/jB0vgvGSL0HOWV6zzgcOK3GbOoMF/zeOLmr+l6a4ipCv+BK0834ZprcAhUH9CuF2y8iKLODR8qD0RmzBy0hARRj0OJMoh9qgNwHL759RpMqlhcraRCJwoPlQJDEj8UsNTEIxaw5mntmTVwvgGfKJoxeDrMC3RiAfG9sp4iPWJTLnbSVAmy0QBOmLXshiab70GRTvtaaW7e3yiT5qjQkmvaj64jIeK6i534Ejl7LNtLcJp4xOktLgup8Hc149pMWDkpA6XrY3MBVrjVLIaUFOX2ELGKIh+vJn7WBR2hRZbNGWMEWETjvJN7WCr632Yel5B5y+euhhpP/ShkghIO21PHTF7TBKCsdpNYQh6J9NrK6TEsZYd2gbwToRT3RvNq9bIMpaRuWpsWeZJ+3pmTu/Tf2xsV2yeQkybBZGTeqU93O+1OMDEvTW303LweTjJZIj5HN99vyc3IV2ov8XSS5oAzqG/UxI+Nf5M9blpARRXBp7GNcNm7V55p1a6HnLHNcVj8toYJK7njBmhlwlcobnLiOJ8AbNyBZIffGn5tRyWOlxet8QhIKHUK170dd6zH73IC7xEvd1E58wTVuqp5tGua4XrXc3W7dIVUqrrji2dbYRrurqyNty+4m1CU8phPRvF3q9mQSwlKZXoQ+F7CmYeEZcEuiGeJBWOw6CPGV9HXKkRnF8NiIulC/VuVSP9/X6wTBTZAPlgJUHTyrYcpDzB2Rxo6NHW8IQSIB3SSpTwKIJyISihrBzrjuPsjb91za/rtM0+2cjySmZ/zEvxpzqNLOuiPIpm+NIW8Bw864UlSlNj8Q3ufEtQj/SL6mxJEiG8lS8LJ5hY5aLBxz2YQtPAqb4UNAkN3l7gMS1+ZzXpN4jNrPtxQKs8uTQXMuf4F2kH5TMup8Iu4gPKBGKhlg6vw+H0PXb46G1BI53lY97l+gVuaWHCJcy2V0jhhNEWcA33P4zpO
 xxbZvtQL
 g/sSpKl5s/E4EzxRlc7Jr3+saYUvlknXf3S/NAspPl4knMuYCsqcSbYnQdMXc0GkkKpcGkU3fkvC7ekC3RDEFVCPVid7nrRxxEJ66HViuiiGFXrDhR4XlKb9jqxJW8V4f1YwgVUburM0u6KgiOkBfOp/q+rNbpQY17Rqs16/EPR5DzImSIuQrZ0pIj2eTSpxCjE75immAW2wZ8DSLlurMeReJMxh+9+/P7Jc1J9Q011NeuOyN5TiKK6pY/ZT7H5gAERguEjqIfZ82/M5wy0WWPWusS9sbSKHBnDyR/ImrE6CiEsNlWjr2OFXRFauLWDasokcSHE3iN/AniTtkWHeAg123G6s8+kPRfmmf0rx1BZAeaiC7tbxn7fxSdeZtC5PP/hfT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.043268, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 3:55=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:

> So we have something that does O_NDELAY opens of ep0 *and* does not retry=
 on
> EAGAIN?
>
> How lovely...  Could you slap
>         WARN_ON(ret =3D=3D -EAGAIN);
> right before that
>         if (ret < 0)
>                 return ret;

Surprisingly ret =3D=3D 0 every time, so no difference in dmesg logs with
this addition.

> in there and see which process is doing that?  Regression is a regression=
,
> odd userland or not, but I would like to see what is that userland actual=
ly
> trying to do there.
>
> *grumble*
>
> IMO at that point we have two problems - one is how to avoid a revert of =
the
> tail of tree-in-dcache series, another is how to deal with quite real
> preexisting bugs in functionfs.
>
> Another thing to try (not as a suggestion of a fix, just an attempt to fi=
gure
> out how badly would the things break): in current mainline replace that
>         ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK)
> in ffs_ep0_open() with
>         ffs_mutex_lock(&ffs->mutex, false)
> and see how badly do the things regress for userland.  Again, I'm not say=
ing
> that this is a fix - just trying to get some sense of what's the userland
> is doing.

Ergo this didn't make a difference either.

