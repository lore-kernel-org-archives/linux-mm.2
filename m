Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1AE1E6BF3F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 22:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9106B0088; Fri, 30 Jan 2026 17:32:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0DA6B0089; Fri, 30 Jan 2026 17:32:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2AF6B008A; Fri, 30 Jan 2026 17:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1916F6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:32:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B23C51A04A8
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:32:09 +0000 (UTC)
X-FDA: 84390079578.29.57F61A1
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id B34974000F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:32:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r+Fdgqus;
	spf=pass (imf27.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769812327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5nbc6oPm8LRFAHxRjfK4s+TrvKdniacoUK6JWeX1CM=;
	b=Rxrg9lOYuQoNq9xGq2VbYEcA17a7UWAh0IG5gsWpgizwPTm08gWzNH5ZVglcgVLNZe5ni3
	xL3Mr5YSqDcU80OPp0Rnxa2rihW3WUkph7ffP18S6mFSdzeMgXJKoZay3yW1oh87EQhreh
	TfeJEtI0h/n8U4ODyp32cP54PxIH9h8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r+Fdgqus;
	spf=pass (imf27.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769812327; a=rsa-sha256;
	cv=pass;
	b=MtJNRuCFCT05IYKNcemuwgYBA0xoWlNZW6wQAyITymxwTcXjfv6fYSSy983vOKeGL1aMm1
	XO1rW4iiD9w4A9nOMs28573sn3OV7MI58UHLuKasOFlIQncfFc/ELAMezNnJYGRbA7qEww
	uf31koROpWzrg19aE7szPhV+/81nvno=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8850aa5b56so415300466b.2
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769812326; cv=none;
        d=google.com; s=arc-20240605;
        b=AkEJZKTHUNgeKiH0ISdqZTIsYLg3odg9pa2m8moHibJdR4ON2xqZQGzdshHFKVPEf9
         In8f8gGFKhZggNTk+3YPVl23ib6/0ZtGoVWSXbictEMitniz4KBD27Z/y2zZEQMD9aFD
         CF+6KG2vkx7M5xMvHBQ+ivnV+Li8XQycuwWqxKuu2y2WTUClxLlUa1P3grgzPofk7CG+
         OEAqDPxgA68+FuS94IAxSp5CpdWMaYrl83OVP2UFSjffhOcDvjLZW1ftCRk11CpyU+vU
         J9Yy1V3yG/JhS/5kb+EIlqvSoXw1GdETNX2r4ar6WhoVAqNfwaEWB9shICWrRewTTWs/
         m8lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V5nbc6oPm8LRFAHxRjfK4s+TrvKdniacoUK6JWeX1CM=;
        fh=1ggYY+MNZKJE+ALghbatvOfMsn1b3HxCDpqP8eDkSEY=;
        b=ZsFbUbdcddyP2+pkRfuuo45QCE8+Go4x2MVogcTfV16N2TSK+BJH9+b8Vu93RCSjBn
         wftG2+DRzPU0UybivYhccQKcG55dPsm3Kcw5lFWak9VT6PUebAwaZaqFVZEO/SUQZJgx
         2bTRBMkqGqqNiQQxUlrt7WNaOZ0xsejLC/LEQdWQWGfDHWONC/R4LOj+GikMxthl90aU
         BCLgtHRF5LWymHS/X3wLh0k6PiE6PGmYlKKuGPreVcTNkoEks8CSr2JqWvQeXuoO11yG
         kmrJXBYb2EJzzu69nY55MOCZTupr43AhyNgtMhl1VUMJ0TvFomnQ/J+z0mSuo5U22jpx
         3+Tg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769812326; x=1770417126; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5nbc6oPm8LRFAHxRjfK4s+TrvKdniacoUK6JWeX1CM=;
        b=r+FdgqusGgWsxMOCdVRZ3vEsRrCXCnYYtb0OyGyA465A5W3sg1tdTQOZ/6ENuHTb1h
         Rc2ykfQ3tpgmgHoy5f0DbI7GSGkANIBETMdOr2tfYvfnHmHA5f5WSZkLERwsnNx+QgU5
         OZ6hJQlX0fhAh7uDxr2PdpXRKKypZ6JhHTkIgftCX0GY4To5jQb4Qecayu7IGGFVhq+W
         IAvFQtUEUH2oDyZxgxT0v27ECdqC36gDkC42XYgWIlUY9VoEp6K8XsC3NPciu5RDRTZP
         R17tLF18E1Sfe5DrEKqp3HCtoScc/XWyL2cd6X7FgzI4XauhZ3gc8UFTazBNzVcSG5e2
         1iOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769812326; x=1770417126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V5nbc6oPm8LRFAHxRjfK4s+TrvKdniacoUK6JWeX1CM=;
        b=kAASD3r0wDC55Uw+ENIxD8IJbZcd1ejuR6Y+JROT4GhT9bGDZYXbuXsZAln4OacpBg
         NLIT2N3M8IIsZsOEfwTxl1VfLPgPMiJ75IQ+11p9oTwrrwXr95o6Y+Yf4yZYTf0ouRLw
         RbQizS72lttD2wTte0w/iR5rU7UN2GQT6po+EJxt6KE51PN6FvCkcwZyNqYHIyFXCctu
         syHAbXIEB2FIhZhRjNrHS9asV8oMpRNxWKZrr5VYBS6zSRBL4XUG7lqQbfFukSpTTEW+
         p0naAJvXmgqPIzcGpnRIDo0RklCzYf0RmaYBOWUNfBklj8gO9oCB9lEBLa+IoLQKoDow
         ePyA==
X-Forwarded-Encrypted: i=1; AJvYcCWGCUtBZI/p6yZG16mKdVQCWTFSpGRCkJgW2NJHNhOBHAgGNjT4Hc2ZBFyweMJbhhb0FW4+LyLwYg==@kvack.org
X-Gm-Message-State: AOJu0YzRgvMcJj3Yp3MOMZlnf/TNTEcn9pF5e90FgOO/vWoQ1zdOhwTU
	p+u9dDwIlv2JQ3K/uKkVT/mjJJsn54JqlyVGmAoNgQCieCfCje5NRy8YjEw86wMLwXKwBz5beZA
	5QNOn+/qqg0bxiPrt5lzB0kLHo/5pFM2Yv/Skoahk
X-Gm-Gg: AZuq6aJXxAqtWmCJN8qS1iC6QcknIUBvWlKiandeBieuec0MR0RZ1H4lSAR1ZQAfGau
	tWTsXn4eKHpp9LZDz5Mojw6Ebs+BBZ2fuGszDgnXqrqOfhwNcgyQVfj7nt1JriCp+svFXCOdeda
	2Mm7gl8Dx0EE+gqynFBsCRikE3PHlL8yduyfImhWWVjEXh4GuNFgzdTiyQ6jh7Ch9hLd1yebo7R
	zvOFC/octpOhYEZx0tTqjLz5FRUMwsv/6pmpN0h150msAEzArzQnh5NIYuxWTI98FUd
X-Received: by 2002:a17:907:e0d8:b0:b8e:14cc:9197 with SMTP id
 a640c23a62f3a-b8e14cca990mr91520566b.15.1769812325869; Fri, 30 Jan 2026
 14:32:05 -0800 (PST)
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com> <20260130070424.GV3183987@ZenIV>
In-Reply-To: <20260130070424.GV3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Fri, 30 Jan 2026 14:31:54 -0800
X-Gm-Features: AZwV_QjYrhpLENkXIfDxcZ9u-zvP7f57lE4mcVebqUxFVKgl6ULvCT7XG0RHQoc
Message-ID: <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B34974000F
X-Stat-Signature: uf6xib185q4bbahbz13eqeijxuxjpqzc
X-Rspam-User: 
X-HE-Tag: 1769812327-782165
X-HE-Meta: U2FsdGVkX18MJKFL5Df7eSKcyrrEtlhNBvGLbpgOzyT5DyCMzCqBKIyDv0iYVhsm5xeyZh9oi/JrjY24mMBVF3aCyBaZzyjKOL13bFNzNvEfEK5MG+t1dKit49DabJ5F/WkR1zDlr1VY7AZw269YlBoYILqjP5OfytDfqWzPQJ0DGYxo0OWCYgUTZzy2HG5NKpJPMn8WcmRB0rB+6HsnSkAb+Nfo93ZAK8BoePr7f8zSW4XJeJzgntt82wsBHQ6TC7+VTcIfjofX6qEqfq/WKFnvIZpJU85A14cSzu9lsdNaD1iatHIy6XkW5YaKAYUc3H6/Sl3V5uMz7sN3vv/Fm2BHS07nmkJqAXPHDe3uKoMlt+RdVKgPy1ltfs+FxeZ4wI+e5VdnoBRAkT+x1FE9VnDhAYPcarNwqN9lfhDnzSnAcm0cHUZsXLn3H6Y9Emj1+oLsGpQMqWba5ll2mMe9JGgCVT2wD8pd3ra/rIl8b3+3QpZ3GVSQnKeasSQMCBNqzO6fIV7HgEJg0XLgaytT5bIzfQiy7zi4UBIAfnNF2DnpvhZoOxEF2DOh5ud5tsnhcl01kUP8xSOqUH3o8wRvzElE2pGAMDnBio0T1065cMsW7Do7Q0mrHBrS/VrYa4LizQWNdsJZa32WO0JttrLA8HzLshSSMfv3yfPTSpJafj/A5ouCHRjiq7TpdlHUc0hwEuQZC7o598ekaeOtkfpMLCp0a0z/6DlWSkuctpvzUWMYOy4e89zjsjY9ZmEjK2llPTHcyG89Y27wU/l9cgR+BuKHRg72/yVLh1Up3P6L/h8GpnC9AnuE3VlXTqbMhwhILBzgXJr36sCww2vRpA3mCymotxYIbUtl/2CK7E7t8I6we2eUGAxV+v8DwzVP3xQ55dlxQJjYmw5aq1kPLTE4ISEn9fQ3ZnutMAYZN/TR9HZj3PTjfLiqRQwofGbfpt0+2CHCPRVjai3IwDCm6Yu
 1EMvpQB7
 Wm1WxBFXuPNtBikqpYsvN5qTAuWpJtU8KfQSA+TPi1VlG6kwYW46I6NFMWEqMApCiit2JNOJt2EFYtRxv/pdM86+GigYredTxar6PY1RiyKXTojwNn4i89UTpUKWd1coi8gn7lk2uq80DqZ7Xw2jHQ36At8ZMnhhISRgTAph5QFKd3kp2IqNqJnn6AxZuD7LnNhci+BA0pUxHJ4UQUkhege4bhO4xc7WWYuz+fkO1nwieFDDkG7XRdZeeprqsEUqYgu/J/k7sGxp7fS10HyGo7y/Zemf18fWLBYYSVxJJfV+ByPFvIhulHlQryo/XrTZvatpYARdps/Q9bEYhPIlWuqDkQSZN9bPj/6w3Afu/8478nIuaXPG85XAsEuVSDsLegG+8IVpo9+yX2EtNYTpd0gUGAw9VtbEghWMSWqk/IQzPCNqnXrbZ6zi2wQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000020, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 11:02=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> OK.  Could you take a clone of mainline repository and in there run
> ; git fetch git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git f=
or-wsamuel:for-wsamuel
> then
> ; git diff for-wsamuel e5bf5ee26663
> to verify that for-wsamuel is identical to tree you've seen breakage on
> ; git diff for-wsamuel-base 1544775687f0
> to verify that for-wsamuel-base is the tree where the breakage did not re=
produce
> Then bisect from for-wsamuel-base to for-wsamuel.
>
> Basically, that's the offending commit split into steps; let's try to fig=
ure
> out what causes the breakage with better resolution...

Confirming that bisect points to this patch: 09e88dc22ea2 (serialize
ffs_ep0_open() on ffs->mutex)

