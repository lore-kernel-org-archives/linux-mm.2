Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628D2E9A04A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9155C6B008C; Tue, 17 Feb 2026 15:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2D76B0093; Tue, 17 Feb 2026 15:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5156B0095; Tue, 17 Feb 2026 15:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 68ECB6B008C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:55:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15D1B13A8D9
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:55:24 +0000 (UTC)
X-FDA: 84455154168.07.B6EF32A
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 21C12100010
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:55:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pDZNtsxg;
	spf=pass (imf05.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771361722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qLes+U0X8eX+LY2HRLt/bOCKE5ihfeAg/6ax+zlthY=;
	b=t48rbymParrpTR8ajwFLIUO2ssei/rAXYaAzC/93wj+4isr64oh+u6uvMVZjG4p9/1ljjG
	IdwPv9Aj0d1OJ/wLM8X/7umtCokH37pGsBKDxfrOkPaT9sT9fxOLP6Y+0+Co8UV9hUZaH2
	ZhU38dm3fuomX2uziP9ndG7eDTKkdsg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pDZNtsxg;
	spf=pass (imf05.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771361722; a=rsa-sha256;
	cv=pass;
	b=htIOGCtpYPnKCSM3yX77bH8odrRIeksHviRYER0SaSACzZSnVu9SzaMPbvPdwG4Sfzg9i6
	EFWDyK9hyiFzcl6+v8l2U67xcstoZqxnOLIqQ05a3mBylIOyse2hOm+h86YsGbtcNUz7r3
	Mi4VZNZndkSts9JiytsZ7Rhw/AMo7VY=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1270f10a774so668c88.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:55:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771361721; cv=none;
        d=google.com; s=arc-20240605;
        b=c9j722uxO8YqNVHic2F6lwyaSGnNOki3qTFsH++Rq/t0HF225hFRaHL+rH8up59RuV
         SBV6fX6oiSPeJTCqjo3GlIOLutWDioOaV1qSD/3FbwP56YBWz+hO9q5mlmvujnHnopJu
         wZ1IowBOZLDDQiYIFkYgsN9ixwCdSGleEy01XtHPY74jtUxDEDkHtei5cy2QKbPIXPi0
         fIcx11n3d/1JSw0IHFTYWh4s/IothFQWn+qQAdZkPSnA/5yrQRY3ezE886Wmgvl7PNOo
         iQSINvmVwNc3qaodlqb5MZlV1PNT6nD63stoIgciXmfm2EHNQ/+CTG9ttF2nSlpKdbEH
         0P4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7qLes+U0X8eX+LY2HRLt/bOCKE5ihfeAg/6ax+zlthY=;
        fh=p3z4z+3Z5PBjoz2dKpCXqt0AQq+udrqOrnvJFeu5CrE=;
        b=dJ2JAeuRRm8280LPncfmzy9Lk7/Rw0WL5aK29iFxxfVXrZnnP14+BEYWRqj4IU5lSC
         wJ6ifaYvpJ3Ax1K8vXPnqUS2X9hU7tyK4smD2z4UdOtDrQsgd67c5MAHeVIQcufdqBW2
         N9/lDKIJsvYaDmfYqYXr3ZhCA+cdNwjiD5ngxuMFNgr1xgY7MT5tGbmqi8swuwwSrrCB
         7RCq+OB5/wYmvt2AqkchAtSDDs1dh0z3ueIrO4PnH8tVHz8pkRfQvjxOEt9A3vQLN3aF
         isQvtqcVJGgAX7lux4oVAiCIcrl7KBgCOUdgEzCpTjnDBJTjgv5m+wEjMcUGDOseVAj1
         Uglg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771361721; x=1771966521; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qLes+U0X8eX+LY2HRLt/bOCKE5ihfeAg/6ax+zlthY=;
        b=pDZNtsxgjPHylqIqJt7M+tqZvKUrqSce7nTDnmkRTZmgAtBYtLmLXWOnNbzffwr3jb
         7qSGJU7d23fUFbKbdatSkt9EiOlD1HWvuMDJiXQtj8Q9LbZnUeaPhMR16iUW/2fSFFhf
         fMK6mOwS7INEtPRhetKnmpYGT5juiUd8kH6X3txqwTTgEAYQ15pUJtl4meSZLzUgxrLm
         ldAOs35r1H8JmxiEUg+T41qqHJR7+tQEHRHB+bmRYW3u9jI1/OgYvptivsbJd3fv+ea3
         FZRiZ9Jxz5UQh8FZjgd0cOha3//R7hOTDXFCjn9cv625h2BiYW9kNrwu1LiPrHNuJifP
         Pydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771361721; x=1771966521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7qLes+U0X8eX+LY2HRLt/bOCKE5ihfeAg/6ax+zlthY=;
        b=Niuuj+/0ahiDFHO/sWpsNtebtLWmEQQmRyrFBmcczbJ8yhg2RBk9UBpE8XlxpFILad
         TeDYr0jFNld4mvFtIIfACrsknFPZDUQrQZtnCDV6WZj32DsO52Z9D+zDyll6xxKtgNgR
         zf+bbxihRfzAGxAtPjtTIykKGOKS+0XfFeZCnB3fK4CB4drFNClAzOE0U8cwl95zb04m
         4bqOn5E/IPYRi1FiLfELeGpb4rAYBORAVXwWO0lIjT8HHXMJ0qUt8/gzML6yBkEvXpEl
         9+M/L4gAsu/f0lF0brgde12xes1llNozDXkPzLFChByDXepd5azmXB01Ta9S3kfIwrSx
         rvUA==
X-Forwarded-Encrypted: i=1; AJvYcCXVefRGpbuBdDD7OyzRk30jy5ggJEYEyUf9ij5H7whEyBRiwDaiRyXoJJavpGv4da/6lyftgw9pkA==@kvack.org
X-Gm-Message-State: AOJu0YwuFa6E2eSJVLUqQhDYmTOVwHrw6wPesOoNa1tiSE7uQpHEgrEA
	YMCB9MYVJc9qKObmaxpPfA9MyjfVQC7NZmt6znM9m+Dw7Ctn/akbLouZx4D9ZIy8KqgzBjXXEko
	lne76h9/PTKYHp3WXcWCUF0JyBT0Cszc7p+LdUNkT
X-Gm-Gg: AZuq6aJeziHKG0a+myKFx6CoVhkhsB6RlEnd/cmH4ZuoFyDJ2xMML5UspxDhiif1hKe
	hSPQo4KWlVTt+AjyY87W5fPL+kvDEp5yWsAZe+cEN4zlOZqFkApUEW441wbTxludOr2vEK9LWCC
	ja50AY8xYaIku9NIbTVkTplm6ehd3PKa3QUFpllLX/H+7GBxm21FdZ0nkvnkPHvELC2pkjxX+aF
	EpTILNMcqFsN/fSxDhw699WzZriNF0u49ii/N/ioUkjo1Uc4iOj+bG9931qBlL34cKwnfSkloQv
	p6grxW9bTkQDUyt9XLVU/WFJSr1nOhBKPY4zfw==
X-Received: by 2002:a05:7022:608c:b0:11a:2c18:9e70 with SMTP id
 a92af1059eb24-1274cc59264mr291646c88.11.1771361719997; Tue, 17 Feb 2026
 12:55:19 -0800 (PST)
MIME-Version: 1.0
References: <20260213123902.3466040-1-arnd@kernel.org> <20260213085842.0654f70a73ec05d88908ec25@linux-foundation.org>
 <b8f5244e-4ad8-4499-9cc4-c875121cdc2f@app.fastmail.com> <20260213092336.c2b0f2d1be17f1e2e9856f11@linux-foundation.org>
In-Reply-To: <20260213092336.c2b0f2d1be17f1e2e9856f11@linux-foundation.org>
From: Yuanchu Xie <yuanchu@google.com>
Date: Tue, 17 Feb 2026 14:55:03 -0600
X-Gm-Features: AaiRm52tjFdJFL5QV9uozcplfiuxMj09dq6mSSJMSEz_k17kkZBez8MnH8oZ8wc
Message-ID: <CAJj2-QFbx0iRMWQThPDfDJ04hNuZL0Xu-bGGRqGO4b3KgumGSA@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Wei Xu <weixugc@google.com>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kairui Song <kasong@tencent.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Koichiro Den <koichiro.den@canonical.com>, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Bertrand Wlodarczyk <bertrand.wlodarczyk@intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w9atnoib8eatt57wnere1m49m7gn971k
X-Rspam-User: 
X-Rspamd-Queue-Id: 21C12100010
X-Rspamd-Server: rspam01
X-HE-Tag: 1771361721-433378
X-HE-Meta: U2FsdGVkX1/TDCJHcF6Dzk/j5cv1Nmxq7a/CZ57+SLM0vG9C0QP40jOUVT7YMWzr4jQAHujdYtOO21wk287yVAbldILqthbDVI2BYOmPnagiaghT8gELnDpEic+klylM/C1vDLTvGZ/is+wEIpSRp49et5xQTTdhAU2EjXjP+RX2wtu4hUEXt+Pf/yt+V2D4bN9/l9Vkvr8cCfXmn+ttMY3EAWRjIeLj5azyoihMt3JqPUkmK61VvP3iAagizuc7VKkHlNxj9Z9IsBs4Ue9jZvg4J9BlxIBdKcBOeL3yUoLIrU+cbt1D1FeEWvUVTAJti0Xx7love0mdonuvgGVAj2lL3cXNWuhMUl6+mptoF98SD8IDBu9tBvn6GMhdHSEQ0v08ySouCBhkilWyrw12WS16AqEcDzSzfwhR2ZEbVdA7BVGXaRJnBnDy9XfdhjHh3Cra50IR/OF509wDY/uvzh+BmrSk1xeqD2xDMWwi9xa0zrkG1ceyk0eTEX0+sLrhncJwjifmpTIMmEss32JjttberHP002KxzGcX/5WyNwDjClJLbYAq6yFQAFq7zPzDquV6GGk4g0UPg9iNqT+5v+xS5tZqa+6fMl0r7jzIBYGvdGyewAm7D0HapYZK+5cBYFehM1o62PMktvFvKk2MriKaWpZuYr0CC5cpk4BqD0/aUN/qf5TpnO6uGE3U3pQL9TTxaIW4ze/UE5vrpP9tiik4B8fqZ+8HqgG7VgWsKou3hC+3S+3MNgi2/onofMnSlEfkN/mpzbKug1/U9klH4yAEQ9brDIlu+VUKIPP/PyNhH/EU1nTFe2PpfU1hnpJ8scWgAI6UwlnZ7V1u4GQ1K1HhJWi7uMny2CgxtFFcm3V5YOnkLM/6i2oVFME0/C+1XJRjNucSCJTgl+8okPF2FDQbxTvDX4OVPNZGdH2uu5FP/D+WPWeXagTtljSPS5G9kb8XQSK17CymZBJUwIP
 JSDMMW8m
 tpiPfvNiUVp757W8k3yM8by2fKyQA2wqQUzuSHGmreSVvCpIU2hKSRkHn6YmPmBvXryZajFseQzr4dyovkMWH+cyi5HStyhqful0aif7XWdEJCuKLL/7iolp7AYpig/vtycUiwULd0edBS1mSCYOYLP7s4i0twD6CrUggvPbvTp0gCXuH2lFuBr+VWIJ2LhwGll/xYR8PAaNExeFtQrjR2CHPb33OghHfPplMkZMoRdFIaDlHyi7UC+2m0KFtl3ZHuSgcqLS6pk1vvB6c2ShFDujQzVCfMQfSM/mu2nPn6gBEb8GUZ96bZXOJmifKNIoRu8Pg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew and Arnd,

On Fri, Feb 13, 2026 at 11:23=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 13 Feb 2026 18:07:04 +0100 "Arnd Bergmann" <arnd@arndb.de> wrote:
>
> > On Fri, Feb 13, 2026, at 17:58, Andrew Morton wrote:
> > > On Fri, 13 Feb 2026 13:38:56 +0100 Arnd Bergmann <arnd@kernel.org> wr=
ote:
> > >
> > >> From: Arnd Bergmann <arnd@arndb.de>
> > >>
> > >> When the -fsanitize=3Dbounds sanitizer is enabled,
> > >
> > > Is this an option in current kernels?
> >
> > Yes, this is CONFIG_UBSAN_ARRAY_BOUNDS. The actual warning
> > only shows up in some configurations with that, so either there
> > is some other dependency, or an element of chance based on gcc
> > optimizations.
>
> OK, I'll put a cc:stable on this, as people will want to compile older
> kernels with gcc-16.
>
> Aiming for upstreaming into 7.1-rc1 unless it's more urgent than I
> think.
>
> > > Seems a large change just to squish a compiler warning.  People might
> > > prefer a simple
> > >
> > > -   struct ctrl_pos sp, pv;
> > > +   struct ctrl_pos sp, pv =3D {};
> >
> > Right, that would clearly also shut up the warning.
> >
> > To me this seems less intuitive without an extra comment,
> > since read_ctrl_pos() is meant to initialize the entire
> > struct, but please pick whichever you find most readable
> > here.
>
> Let's see what the MGLRU maintainers have to say.

I went over the various cases of read_ctrl_pos and couldn't find
anything wrong (let me know if I'm mistaken), so this seems like a
mild compiler bug we're trying to work around. Given it's one single
version of gcc, I'm a fan of the simple `struct ctrl_pos sp, pv =3D {};`
with a comment.

Thanks,
Yuanchu

