Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E65C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366DA6B00DB; Mon, 29 Jun 2026 17:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317056B00DC; Mon, 29 Jun 2026 17:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22DA16B00DD; Mon, 29 Jun 2026 17:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA82F6B00DB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:50:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70BDC167654
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:50:28 +0000 (UTC)
X-FDA: 84934294536.07.00B7BEC
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7913940007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:50:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b="DCT01Bg/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.169 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782769826;
	b=3y+Lw3e6ifRbszse50eCDasY2MvGsAFbQbhqThBw/JrNWDDWz/MqKk+YrZ0io6WzCWv7w3
	kQV1PVb4RSRPkTMvp3Y6h3Xjrt2kWE4+b5/kiIJVUib3QO5gYlyBm+QfuOPUZSfhZuaA5p
	+bO06NJygc1LtvrqwAxZ3c/0tamSxSQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782769826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2llOgQYBxpmnTUq9sCCQre1s4FqkjHrXxMuD91zMJhQ=;
	b=SNv5X66FtSBi9U4+SggB7zq8yubhLE/WImYn9x3a+uCPEJLBEOQgpM7bXBlvdOeLIQAs3s
	a4wGUgwmpdFuED+Bzr9Dx9IctzPzCx/4/QDBsMeUURK5xpNcA/W+MMogWBEU2ifz+QMFCl
	WbPjdTK1z+sATHvnpdHFtlAJ57p2Y88=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b="DCT01Bg/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.169 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-845e47133c9so571533b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:50:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782769825; cv=none;
        d=google.com; s=arc-20260327;
        b=n4/NhbFqPPpC3+DFbVMUWmvZnwOx0LvvfuhsP0OhwBfM4e4jAcB8x74bWE9gUrBDCE
         TE14kGDE7/bCEIXGgatPgWH58zpaojSEkfDb5HspiiadAXvieBCZv6Ocxh/GQbCGuozY
         orFlCkmTyxM1QStyBARFzVQ2W6ePRvC59simVmvdpfk32juPNviuyZzSvCCbuaRRx6l+
         AZpt7TW6j2420waYxSE3KA8giPL7oEbnYndx2niiFv8VZTyU8GTex0kJ1i35nYkqhPIe
         yT7YhaP/sy52RTNjPvO1MJzKCwb7qt7ssG9kTnx2WgGrhYC54Uugfc2N6IuAmEUupyDg
         6bvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2llOgQYBxpmnTUq9sCCQre1s4FqkjHrXxMuD91zMJhQ=;
        fh=ODQmMZ9aQTcfuObENXTZBHuznZBhwsCFkn+yAo3I32o=;
        b=YsfIll6cBPa1Ko0pM5sntsuFV7I/BxAzKccjDj5FqLjv7DQgXBDJw5ATQ0TVr17zXj
         bNuvGyxHBzTd5XzedhLLj/8t2QRJcxvyKR9ZSflI4fiy7++yp771CupMAcGsu7y3Ehkg
         z88fHAzCpUkBFnAXY3WB/URA3cDUoLdbmsdH9yobDCbppQ7D0bU9kBAkUhoQz9Ysy/Fd
         g0zhHEg2McKYRHIZI8++8Bm3c3SZoikZ5FUnMk4zzcHMgpAvQEow+IWECbkkmjt1sqzs
         sDsgi/F+/0SNZad3N9E+CGObiyzV1ZJE/4qFwvEFguzH0hFfrmOgjxpl91iJqy76cDoO
         QJMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782769825; x=1783374625; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2llOgQYBxpmnTUq9sCCQre1s4FqkjHrXxMuD91zMJhQ=;
        b=DCT01Bg/46cVGVWDE6rrdiUzJ1EodmPma2V8dlIYp0J/IR8tsropV4ielfkZt8fDdA
         MKpO/R7pMM4rx2uwunRvLm2jlu3Ni+J+SnUh/37Cfm6rKnmbe3VMMmOCpNiqtKBHpbzr
         FdiM8yYoEaooB3hSLzn0+F/YIc1VvP8hwk+2OEitV2FlN/NwP6/GNkQepmd0RlWv7HZW
         iujEz/nTW2MF74LPtlFBqtdR21TE7o1ygJUpQtGdkNnqiof5vw1WbVkh3Z0KaiHF9Afj
         YiDSyPeHxse1cWnkP1T7pzdCRKLQLPuAKDWXDs2U79dQm4UFn6zZXHabsx41FJBArAQ9
         oCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782769825; x=1783374625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2llOgQYBxpmnTUq9sCCQre1s4FqkjHrXxMuD91zMJhQ=;
        b=oEylgR5NlDpSm6MZ6R4GisDmVPt8nGtMEiPAIQCGMKUoGND+NzcLlbUON4Shr9nrh6
         a8gPAFEqeq3ahg62JZRz6SXxrILPBs+E7Kzwm7uKIrk6VP35fl3MI+QO/0fbUrLewFZT
         nmqgyuKZ9mBIfQ/gfZEwevOc+5A5rqHoxP8Tku3xcqhJOK0TDLPEPE+BMAmL5rrKNMyc
         bv8t7m/6r7dz/9GL/diRK9ej+KgxgxKjhCSsmriuFh9KVfF859MrDg9HR7W8nOKOZybC
         tXT/JwV5BT4cpbyLygoaDe8MGhcZPf/7LF0zHgxUGSVYwin4hWzSHs4FMwBhNh4DsRNS
         WYEg==
X-Forwarded-Encrypted: i=1; AFNElJ+yn4N5qegfz/PK7EVPeSKFkdeITc6buHreQNW0XbU7bmcp4JsHuiN0h0gKJ/RzAMINiCdNkSKrYg==@kvack.org
X-Gm-Message-State: AOJu0Yx24//qzyoRBAearVsS2MQLJXydcVzlLvlnX5EMFUSSK826nbK9
	f8unGjZuq94E1QtUcTT20WMAakGv4SqbYzsCDWb3kI8DVWdYE7Atdor41w5DvD6twOp/KoANx6h
	k0y5RQ7xr+Z4Uq8dPp66n3vLL5Xeg7mF7AX8I8HNk
X-Gm-Gg: AfdE7cncqKcT6zQAMZI+GNJbCEH9OcLYA4+DsHUM7fas50HfD2uMEagRcMhLjZ1g1tg
	7n/oF2BHd7kqU20QKBFDjB43LWB3ZwavPEmczgxbU/VP1MTOr+6ZGlQpegCCZy4y1eCbJoGxFBK
	4JJA7C2XbFK6Et5j9yQ3PtyxOaFrFt8QDATkQG55eyg3KKR+Eilv1UQ8Vl8+YHB/+rFFaGnz3la
	MGSkwM962v5sqFnUcyVt01OazztBBnW8KBT7Jrk2b0LtQPvA6TYgTK+dVGsp2DgcBzDGLsi5wzU
	uEcJ/4x8aP68hnJ8Hs73E8t+181Ixq0=
X-Received: by 2002:a05:6300:2208:b0:3b3:a66e:3911 with SMTP id
 adf61e73a8af0-3bfc6d9d5c9mr715479637.19.1782769825442; Mon, 29 Jun 2026
 14:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260626173444.2252041-1-xmei5@asu.edu> <aj7UNceukU9zYeGH@pedro-suse.lan>
 <CAPpSM+RVFDOYJFT2iwgNYdjbwqF-MmrbYizpLYksd1SLb5bT9g@mail.gmail.com>
 <499a4e15-34a4-421b-946a-c855199fdbf9@zytor.com> <akH34ycu5-q2Yc_D@casper.infradead.org>
 <3c4094d8-ae5e-4ffd-b28a-0c10db50296c@zytor.com> <CAPpSM+TA6ECyCO4J3c9CrezbApMO66Fm5u8z6djDaFj5Wtagng@mail.gmail.com>
In-Reply-To: <CAPpSM+TA6ECyCO4J3c9CrezbApMO66Fm5u8z6djDaFj5Wtagng@mail.gmail.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Mon, 29 Jun 2026 14:50:05 -0700
X-Gm-Features: AVVi8CcXquKjNGGEs37RhJuoKAaonZ0o2UeH9tYWgQXG4kXrQ8gmEx7u0A4Wai8
Message-ID: <CAPpSM+STqnUmzdx13rxya8_7z860st8R4oj+30TRJP094zQY6Q@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	Kees Cook <kees@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>, 
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7913940007
X-Stat-Signature: 7u3mogbuycaby9i7faha6y7nqje7gnsc
X-HE-Tag: 1782769826-970305
X-HE-Meta: U2FsdGVkX19+rDE/sJlMX/EBAC8wX508dVbGsieg5a4mSGULWsD+nEHrFmvmjcOT1qeuBVdR2rasfexdPWsNZSxHRGyC3OBpGZ8Jio1/h16oG8fOFbh/DjfRFyr6hc3+/5MKRoX0CGL9fZziPD0JcMooJRnPff9s+GXhXiFOTT9v7mna4aflbIEo8KOW6LPvhDbyXTIZUSAHLJwe65MnO1e5iQEZSL+fUEPlT/Xa76Onpdta/0RUD10WI6q1VBxTcUQEO4P5+54OEk4bQHEX+hO6E34a3j2eRCffz5bfDL9Ucc2+vYUxOhmDKnJq7rNFdZY8YB1ZpnjmOnDnXYc8Jk8sn6R6/D/T8lp9qlWLdg85pf3lXIf7JbNNLiFH6kemwQQKL30pi7/QxFMfCU7QcoOLAAwon2MWDjRtu/QRCDvbs8VJ3CX8P/EvqX05r7NHC7fty0LIyiyCzdHFYsRCOHokilyQMqQReek84zHFBwzAoK4AYGkmToiYkj0Lnq1JDUvo57RDD4IXeO8rFke0mjhVXOFkiqSKsvlLun2Raod399Sn+/PzBmK2b2UUAT/Guo1T74fj7Es1CFKOyzeTPODe+kBS2pDNThA5g9QE3szvjbvTsrlLUsb9onVfc4AnXmZc6Kqms+Pl61zvnOe+81QAEo2BMrRrg9l4xKV/YGZIXqzhVdVeZ7MGfgAVQ/zfwOnH2nw49Q4aEQPsvT41kBspY2N2Bl5vXDbjFyHFvhxKZQr4duEj2J89avvMSSFaqRLlTQYC1Ysb3Kw9SGZNn11ff+n5K6I8AcOh3eUvqNb1y/MxWw0yTGI6jM8ABH66EdbOtVEBF29UVZ+VGL0yOyPPvqrGEB+Icyrljy128lPxxH63Q5Foyz7ESN074ds8S1eKMqKzgOEI/JFDYk0yjyw752HjreCgbNZUEg8tNenFm+fyGwoOF3mGJbwCNRB7mzJkD0ergh1azO2prw3
 l0J6GFpr
 hiN8tO5kyUZ5PP3l7rcTzyPBmtWppR7WJfhy7qgBWFyWKmAF7rmbypJRLBQWDMUh7k91ErG1YmvHcxZF1M3yfNYymlp9Axjcc+XHyzkmtApN9fC7UY5M4uWHeWRrZdAMQsoJIigbz0KDiLobY9RsBwXjaxgcWWNYVEhGUEXRZiqtKAN1KpgMwkcBwz67htWw1H+EijlTBHrl8DNkTdojamdnfTXerO4r7XFnIZuo6qZy2BZ6vprkn8aNDXQF6erd9nTsGSoHXaYCZfg1qpY5at++4PWCFIsi1w2iVyVZiJ8TULfjHYvYxmqbqyctFj7ZznRUIO9nwS0OXYkpyRupMsH7zPx0mvK98k4o4kLuOKxRuWCEvkOjRwiIeAVjuHkqh/UfekSjTxaOzONo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An AI reviewer found an issue:
https://sashiko.dev/#/patchset/20260626173444.2252041-1-xmei5@asu.edu
And that's correct; we added one more change in v2:

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3217,7 +3217,7 @@ struct vm_struct *__get_vm_area_node(unsigned long si=
ze,
return NULL;
if (!(flags & VM_NO_GUARD))
- size +=3D PAGE_SIZE;
+ size +=3D VMAP_GUARD_SIZE;
area->flags =3D flags;
area->caller =3D caller;

v2 was sent: https://lore.kernel.org/linux-mm/20260629214712.1198680-1-xmei=
5@asu.edu/T/#u

Thanks,
Xiang

On Mon, Jun 29, 2026 at 10:21=E2=80=AFAM Xiang Mei <xmei5@asu.edu> wrote:
>
> On Mon, Jun 29, 2026 at 5:50=E2=80=AFAM H. Peter Anvin <hpa@zytor.com> wr=
ote:
> >
> > On 2026-06-28 21:43, Matthew Wilcox wrote:
> > > On Sun, Jun 28, 2026 at 07:09:37PM -0700, H. Peter Anvin wrote:
> > >>
> > >>> 2) `enter` is not rare since we can take part in the instruction.
> > >>
> > >> This sentence doesn't parse.
> > >
> > > They mean that we can jump into the middle of an instruction, and it =
is
> > > not rare to see a 'c8' byte in the instruction stream.
> > >
> >
> > OK, I see the point now. The main difference is that ENTER doesn't requ=
ire a
> > REX prefix, whereas ADD/SUB/LEA do (otherwise it truncates RSP and ever=
ything
> > immediately dies as a result of SMAP violations [you are welcome].)
> >
>
> Yes, Matthew's explanation is correct. (Btw, thanks Matthew!)
>
> Xiang
>
> > This means that an offending bit combination is far less common.
> >
> >         -hpa
> >

