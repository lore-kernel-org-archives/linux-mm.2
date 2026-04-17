Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A5FBF99C60
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 20:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E996B013D; Fri, 17 Apr 2026 16:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D155D6B013F; Fri, 17 Apr 2026 16:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CA76B0140; Fri, 17 Apr 2026 16:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B03546B013D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 16:41:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 365C6E4103
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:41:20 +0000 (UTC)
X-FDA: 84669217920.16.82B1B9B
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4747040002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:41:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UbTqiv3L;
	spf=pass (imf27.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776458478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mc5L8/2rvf9EGhlXImjnU4JiA5BGpM3lg66Pey7qRR8=;
	b=jM3UtW5XYpPkQ4zjZWfYSfQXmP9UZixNmNu598+6h7sMlS2nnJILrnQ5LWIJRWwb0tOQiO
	Ewd0AzvsExIryWXSfYsSZxQktY1hfbhoBfhwUkUqXwUcmebILmKyMpJP7iFY80P6aJ8BGT
	NJBI1HsgdPq684P8NrhNrSzeXZsadns=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UbTqiv3L;
	spf=pass (imf27.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776458478; a=rsa-sha256;
	cv=pass;
	b=IlcoLcWBA3J5uuqXx/hHIeVKQc5Wmb9N12Ddgy5ALMSIGsf4FGKUuMC1u/LKAbgcHUCSjG
	yB1y8YTOs7iDErt1p8jrjmQ2rIb1CVLpXjH7XOkaBEN6nRlcgcaXUyJJDwCBgHlRedtQRJ
	sTlTbyn8fFDksRUQiEgjV2TsS8hoUQk=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-651bc8f864fso771345d50.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776458477; cv=none;
        d=google.com; s=arc-20240605;
        b=fzR3BHhNKX4IYMi9ust6jfKleqSYu/TBkLFoLdtdyV9yzVG8ULvsDPCaHMBmBvliGN
         D29BziDi3lnMAsqmOC/6gchzoOy9gUPTqqP/ygjhe2ZMJYoJUoERvjrqdEhuDjuuJCVk
         F60nMnz9QWEacqb3CVTtdNxwSUVwqIteL6lrhMWTLbtGp0C72NXsZAlyxLQzyLLBlKvO
         X55ZhmTOXEYduxfxCzI3N5UPahGpgqyI6XgNP8DVD3cxjtE18QcTAbCPsbqHiQosmGBM
         k6iXYKda4oefiVZSC0VEsuX08Xk3K70fk+7FYiRCkWBuMFf15xtF9cqWWoQNmXNpoYlU
         VK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Mc5L8/2rvf9EGhlXImjnU4JiA5BGpM3lg66Pey7qRR8=;
        fh=JNO38XJUorKNrfQGMOAZWzDcBxVOoymMLQbbKxbZWy8=;
        b=CROVD0jOS+T/Lsu1snaqhkQ55nL96Zlh51KXLkSAWbBI8+jNyh18MFankkpGRnwZZ1
         zcbsGIzeBJ0xcZKgT5b1ATjlWnzvMHb4PCHmxtka1O1H1PZDt+w8WzHyG/qpoQMJfBgh
         L6l+fzTvo+UFMrphnOyY1HP9W5kokZuQnnk8AlO9p53gk1ebS0GdPf1y/1i3auNVRo2B
         L5QNxZrTQxh3L63Uwzd0bqMyPweZZtMerVEDlIq/wFZbKDmN8bTY46fEicpIUns8VISS
         tkngtjPW5XwSnKaqcEqwhqQqCkoty5ZcPMxOddiUVrkAaMudXHQVez32R2rVL+DXeqB7
         zjOA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776458477; x=1777063277; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mc5L8/2rvf9EGhlXImjnU4JiA5BGpM3lg66Pey7qRR8=;
        b=UbTqiv3LY24oDEmNfdFe5hXmxJ+Hf7AsbN+Tx8d7JOIiK0n0cOAIv3qa9yzfwB3wvw
         PBJ+GK9gl5/w33+Wr0imV9++736GdkMawoaKufu/YwYE+DWCONo5WyNs6Oet0qQzRuSn
         ywDmyPuNKHOsij+jvB4FGpLbsgG37cM3PHVTmk9FiaVkpR78ybG5PPQQPYiPbCQpuhgY
         j3zhax3nl7Hr4TLI56YEi8AedvM9r+UKSGFhaTcuzpHkMOdfPi77MaWhcW+nB5WN8OPS
         EFUYO5G/RYoF3vH0yfKx4qKlXE0ny6s+YTlbQNgj/YE5Prv/bs4j9nVsit6m3HW78Aoz
         Gw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776458477; x=1777063277;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mc5L8/2rvf9EGhlXImjnU4JiA5BGpM3lg66Pey7qRR8=;
        b=EIQ4dDHIbLDy3y6mgu+RF0kv/YTi+2/Y9tz1BDED6BTj2v7RmGsyRdT1X+4UDo90OT
         N16NVNTIhVCy45hZqMp+06XDRmITTodNLaoiQQOP2ff4g22YhMs2Tm6zkIfUP1+hBVkC
         TVdCOCcUcZVw7Y7lph399XWQqWruXAXV/p+0PsTzpNsQvAFV7ZM384xYhRMNh4N7uyAs
         zx5iIojfkjuUeDncU0QAvUJBhMg7aPmsefllDKhB3Xs7JBp7Gst98MD3Z7nHGyiR3z+G
         LIML8KQpa/TsM+NKuhzmJL9Pj3q6FIqPpihnWYDFZO8tFFoQU5xuoABxQ7idECoqSBVS
         Iiog==
X-Forwarded-Encrypted: i=1; AFNElJ/SUtRd2UXGg11T/ixDYRhqz1HEFal+DJj4pYTg+XQA7YfLP7arL586dXL3M3mq5WbaKVGRUaF9Rg==@kvack.org
X-Gm-Message-State: AOJu0YxUXZaRhq5QTzua8QK7boYevmo+wJa6lSHwXYI6MinwJiK38G9r
	nSbcE5xW+UPpol2xVztUAUmaCmctctxM+k+99tpqocnCSSZnDUOUXk9tSqnyuRtK6l7HGvdBicy
	Orck0vG1AbMpBlEr9GDG/7aaD+xnJvjY=
X-Gm-Gg: AeBDievaeebpUeqnM+kq/7yGvC0BL1PTiuWufrtliXHYHhFwoutI9q2iKQxNFsJW4za
	jyWjnbim0RAhFjAJrikWFyqH6TXSPQZ+05HC9BaGpZUrboxs+zO7nOCSbD8kqzppONlcj9vJMTM
	bklBfs9raPjm+pjD//nwyqSIguhCuI7EMFiNJPQtJgyGaTRwOtTZ+64FYNo2J/6Ik9FJ2TUk+a3
	UW0y7G6GpHKHD4zeoWVfOww61uL7MM/bTKBvmarkOJrzzmrNOOVrsJH7HT0srqBza7X1775vAtu
	aromvITvplmq5TyTXcuz6qc3vlp82v41n9RV0JXMqB8nU4zD0CyV
X-Received: by 2002:a53:e945:0:b0:650:dbb:e79c with SMTP id
 956f58d0204a3-65310a278bdmr3096868d50.40.1776458477280; Fri, 17 Apr 2026
 13:41:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260417094426.1556849-1-luca.boccassi@gmail.com> <3rtwn7lkj5icexyammer5limslchbkm4xdgynp5llbt3wwybnp@ikjv5si2xodg>
In-Reply-To: <3rtwn7lkj5icexyammer5limslchbkm4xdgynp5llbt3wwybnp@ikjv5si2xodg>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Fri, 17 Apr 2026 21:41:06 +0100
X-Gm-Features: AQROBzCSC3rE7AP0-H4hL0tA9NAIE5JD2R9rjoGlXVxZSGuKx95-rERAc1LspiI
Message-ID: <CAMw=ZnRpQQqq-ZoUmPKqs8=XBpZcQjFsrivmMXQsouR33ZNr8Q@mail.gmail.com>
Subject: Re: [PATCH v2] liveupdate: add LUO_SESSION_MAGIC magic inode type
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dwqor4hm5nqa8fckk8k8wqdwfp16n4as
X-Rspamd-Queue-Id: 4747040002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776458478-60737
X-HE-Meta: U2FsdGVkX1+vsc20tQNdyDXdVCbpISEjbAnf8r8JO7cJQ9OQ2m2K0qLN4rLn36b2skw1xwH6ACwhMyrhLbs3ZrpQUoknEy3HfJ0pEvsj60YQry/QqfLNS8Fx+J6rbdob0SWRmW66gxVfsfa/9FPSiKBvtvAIr8b0CfowdEL6DugC+m9P7WeUvMDlp37E487riG1l7HXqf7WobPzYDMfNJRV3ytKdfpkE183rNI/qUHSFvDwk7dd6iBTxoPfemH/H6msY3exS5s6LcP7yexpp/wVZHJyMa+oo6/yg4mozfwB+Xsq5DRGZifbTk5V8/RADleh2Rgpp96iHWfa9tAObusRJWzMIuQvFR7ZYpgv5fxogzpwxghJ2bdduCfbn0ISdyS0c6gwtkwRLUB1lK9KdjX+phjgU18RrDS80H4rBjRPQEuSN9xQiKXIzqnFDbBj95+K7PbhJUk8YEwKhkTsnTB+HKUNsVvgqdaPtBqODtOtTbUmR08dT5oUPXRtitMTQT0KeeqL87QMwtVM9Md340j9L4Yf/Rr1NX2oei6q550v1wDoCIpryAN8IgjloLiHZtJbFvgxZJ4A4Ku4qkxXYCe6W5uBwxO8pGqTsL8yT7s3dJVVE1MWdGt5e5dVqcGubG2hk7BqPg48qsDnsoR5+obGoq62oLyyFawb6wmHAlaDZdqUZ0/VQw8Fw5LQqQYPIVUa6lzQsX2ThYP9VPRht4R/AY73x/ccGKSOzXvxEPCXqfJpkEzMnZJ0TGLf5DtT8WexYaJBr0yVqqvrydCCbbK0TWunazv5U06V5z60roCvNLBQ5TN0TmWEwoF1cOFxTGbz/IGLQIDMHU2AHRPguOiYUfPQCpbEq9/YJiio2pNFshEaNx/RHu+OFafnyIWz+r9d0hVj6INxgCSTgdvRQqb/b0alQP4l2nNIOY1slgXc1ECpV0t6GpkTZj02zq3o1f3c4Lmfc3iaXB3kunGC
 rWgQKjMy
 tIWobkNU1YvuCCDf6IqvNdkk7aaoefBZ3WzVozwnL/FEaEv/v/JLEyamd3m+uyIy17pWoY82QSL7HORHENwTaP86JUdHX15xXSP+DRiVapdBRgYQ5HlybsoLb1PGDazlQTKNyksKGSYKsy9PUh03yCdWL9vnVlse0Uhixcs5z4vzQNwF9Z6HwXIkWNsYLdyIxTMsJdTvEAIQ5JhrNvwYUfwZBCMPD+DArgvpOy+lFAM2umo6EBQfm9habBY9ru1Kslw8E1RH99v+5HAlHq4tbu9Cg+hseeT2zrhE7NZVOIKr89d1G+CxJHZQbjuvs3Tp8wEtYaltcsfm9ffGSSINXutk6rN/Edu1YIc9nBeOaAY7cW+bTuV1O6RgTBiqaXlnH0K3ZFNPExsuTF5RTbaG3vBRQI9nynk1yFjVC6R0pvxJHaH6eBCW2TDG6XVWnj/HG4ymhwjN8v1Zb8gkSymwsBY7ABa5YdkVATJ5CzcWgvbJxPbsktZfBsIlrT/xztlb3hlrydHXMbecGXDwdk92ldPodzQ1SBemTLBSqVHWTJQa3FsuJ/IP2UNR8NA5E2hwGUkhRmbucGeGzgVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Apr 2026 at 21:34, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>
> On 04-17 10:44, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >
> > In userspace when managing LUO sessions we want to be able to identify
> > a FD as a LUO session, in order to be able to do the special handling
> > that they require in order to function as intended on kexec.
> >
> > Currently this requires scraping procfs and doing string matching on
> > the prefix of the dname, which is not an ideal interface.
> >
> > Add a singleton inode type with a magic value, so that we can
> > programmatically identify a fd as a LUO session via fstat().
>
> Hi Luca,
>
> The patch looks good to me, but please add a self-test to
> selftests/liveupdate/liveupdate.c to verify that the fstat interface works
> as expected.

Sure thing, added and sent v3

