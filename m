Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C9A109446E
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 11:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF206B0092; Sat, 21 Mar 2026 07:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690366B00A3; Sat, 21 Mar 2026 07:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5BB6B00AB; Sat, 21 Mar 2026 07:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4911C6B0092
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 07:45:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7C1613B01E
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:45:30 +0000 (UTC)
X-FDA: 84569890020.26.EB245B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DC33A1C0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:45:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T5PzIng9;
	spf=pass (imf18.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774093529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gWxRnA4o5J88o0JU8bbrSYGV7Oh3v8+lDg2wG9wC4Y=;
	b=ffdgIaFXeMBSBuIx+d6T670Sf27FPIAaBcCbaJalgZ+T+7U+AYpybt2fxpCPaUpm5etWFS
	bpj/ICMoLRMa1IQTPyrNvfWQIZ5briNjoLTzpyo55DAuunJOE7EuT/2aQUeVA4TW7g2iEZ
	ozdsWGFkUGPrib8icTqrM5d+ZwKfXTo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774093529; a=rsa-sha256;
	cv=none;
	b=6J4IMLU7FUFgf8kHJ2U/LOAGcJoLQ0qhp13c4v/POySpE4JlJMrj74cxCa8xyR0lQjqpI1
	epeW+KLbfkDdntgiLh9UilSewqb0EQBTR1psl8vuhXRu5OBZpHKAOac7q89zqWLl1P0HDf
	xMl63qwKyKF7lwNbcS0soGrxUS8exXs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T5PzIng9;
	spf=pass (imf18.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5BD444444
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5858C2BCB5
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774093527;
	bh=5gWxRnA4o5J88o0JU8bbrSYGV7Oh3v8+lDg2wG9wC4Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=T5PzIng9XmAWU0NElccFBg+Fcow9B5GpUB0kcYpiX/1+wDVah7EamOiBYce3LajqH
	 QBqQ3xPIv2iCZEqESFZ1Bw6UQhRtwtnG4N25KQrpP9kUBqv37FdIfG4zMqhBaUArrw
	 NqwYPfm/7W5jRMCb/5HjQiQeY02oog3qqU8IQk2aM9ljPYYfs1TVc4Cs6MJ+8VZT7Q
	 EuF8fd33rRdKw/YG27pPef5xS0Qi8gF99Qoeh3SCXU+HRjc3HFro3+TYVY8Q5vqh0N
	 vN0btUMuhhjf+Pa6vbPOHta+XUj4JQDt3IALXSUzZlyDk1kqcyk7egF+w2oIi9Al+d
	 K9jxRxf7Ax3NA==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-41708f6c3feso1998896fac.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:45:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWajcn0eEx//zIMv1/6SYOxfSOY7z79tog4OCZLlOtWyPSlLmYVR8L06hARSppJzZSk/CGOzwHF2A==@kvack.org
X-Gm-Message-State: AOJu0YyjGrEh5dN8x1oSXbaTEk7YK3Hqkc9HrLdvA/PpVfsY4vuFg/Wd
	vzgfabJ2H85tI1qr9gpjcLTb9XymB7uypsb2PqHkP8fh6RG81PqhLlNPuL2oKe1Rkf2GTUXrhGn
	ceLVpNAz84hEZ5Piz5JwFAStF1Ls/PLs=
X-Received: by 2002:a05:6870:781a:b0:417:53dc:9ae9 with SMTP id
 586e51a60fabf-41c10f0cf0dmr4084666fac.11.1774093526776; Sat, 21 Mar 2026
 04:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260320170313.163386-1-youngjun.park@lge.com>
 <20260320170313.163386-4-youngjun.park@lge.com> <CAJZ5v0gHTPCkVySAuPBkPoV=SwmBRG_c-TtPbz0CNsUUPEkY8w@mail.gmail.com>
 <ab53krr0y981Qyk8@yjaykim-PowerEdge-T330> <CAJZ5v0gVbQQdpyWb72qDcsAoj7vg2v=pXOjdMuWzKHJsdJcHNw@mail.gmail.com>
In-Reply-To: <CAJZ5v0gVbQQdpyWb72qDcsAoj7vg2v=pXOjdMuWzKHJsdJcHNw@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sat, 21 Mar 2026 12:45:15 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0ge3K4DOZHxJyWARZWu_N96_sAw2T-8nr54zSKH-hOfRA@mail.gmail.com>
X-Gm-Features: AaiRm52gCEdxK_vakaMhQSOho6CDMu4blBPb341noC6S01UTTzbvP-c25uXYVbY
Message-ID: <CAJZ5v0ge3K4DOZHxJyWARZWu_N96_sAw2T-8nr54zSKH-hOfRA@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] PM: hibernate: fix spurious GFP mask WARNING in
 uswsusp path
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DC33A1C0005
X-Stat-Signature: wmn9kpziceftqecepq85qe1nyyia6uuy
X-Rspam-User: 
X-HE-Tag: 1774093528-585585
X-HE-Meta: U2FsdGVkX1+kV+rvNSIT30cSC4J2qP3mUsIED5UFmvCSIHwlSxn2zGCeidmZMbe1wLZKrT53+lRbE7TVwESJsRcLPBJIJJF/Zzwk4ZXKwu3sZgR01WAARGHwCgyomSfuStTBDJRtxwDcfGX65yyDJaViSfMlqOKyA98/or1GpTzmStbHvsgGXuNuO87Sz9w31K7+/BKGjCCSkdI69ECLycUcLWH3/lUZOGEOqp7uVybNf7Xn1u0biGHgtHH1dXAAeGsTrXboQW0NPyoKdvUTS4Dtj/QpQsJdhc6+6lLvCyX/Vxiwrrk9pd8DMRe2hQt+hU6LEEcWET/W2Pm37nBsukwQc+6DDzCQYw4fHUBQWX/lbDylFIucW2jUE0grsh2DD4q5fyZd9UGdfMpZQzs6l4UfiXbMreyXQMn98c5NS3npdVClc0nPQ5qI2BjansZ0mEaWbPVG7FFHV7WH0wypGGibg95gtBtJoFhMNpyObjXonuN6Jvne3LKD5BSbj0L+5fglwMBLkJG3r6YBsTwjIFjueNzPqr0WaM44oh+MZ8IwDKVK0oOZUJvSZlkT+NFV1xw/zWNT911mqEqDeGasRwxhdYRrIG/5NgPTDEo9SpCyHjxGw6YEV6TbcxURpoTAUqP1umJz3/hQLRnsfG5t2NDKF+Mo8ROi0bdMj8+y4Xt8SNhqMKCETVA4aE8jXI1+XOoBItkY2urwMTwkI8RQsR9/XSYYqiPRdrdm362p/yvrOxRyfUdH1MtZXz2VeGphYRGE8mNY/2Z6c1brBxhoPKVRW8t6yCa46ngEypGqTApDF72zkuEqWGG6T/IhIYCa5osFOFO9usglsP7C99B61G7Mqn8RK/CDUs6M/NiX8Wrt28rnFM4hXKmyHFLS0xd8jxlhs1w4dF5w1cdbKAdilDocp0k3Cgxgjm94bsEKE6Po3tCbSdh5/OzjWFgg3w2ek7rcvEUMlUbs3QbdAQC
 DDQIiWCa
 Lear9lps11ASmgB7KUUpjNR2DJ/LH3KCSQr5Zm+5w75j/4eutFiRCP3m4LRIndAj2asiH2z8gyCCtV/pJ2PQMxNCejtY3sNhwtEjr0K7U5H54RHRr728Gcssr1PrjzcW6wj+SeFUqEmh4xdt0jJm138ZLcGpEXk1dEnVji4TIDXlP/ROZjqzHi7OzYB59j6C0JeZZe38VhQkojqve6lNhMs/X2VPBQn1OoJpduf/nX/97mTAx2J1TCouUAK8NLN0f9pRjrYojm8mQc+2INSy9VCfb2aSqfWVqeOy38c/kvgL90qTJRCdxz9ut4uixZ3jm2PQX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 12:32=E2=80=AFPM Rafael J. Wysocki <rafael@kernel.o=
rg> wrote:
>
> On Sat, Mar 21, 2026 at 11:48=E2=80=AFAM YoungJun Park <youngjun.park@lge=
.com> wrote:
> >
> > On Fri, Mar 20, 2026 at 07:20:24PM +0100, Rafael J. Wysocki wrote:
> > >...
> >
> > Hi Rafael,
> >
> > Thanks for the review. Sorry for the back and forth on this one.
> > I'm preparing to send the uswsusp GFP mask fix separately as you
> > requested (with _nowarn rename and lockdep_assert_held).
> >
> > Before sending, I wanted to check on the approach. I originally
> > found this WARNING while testing uswsusp and thought it was a
> > localized issue. But AI review has kept uncovering more cases =E2=80=94
> > first SNAPSHOT_FREEZE + snapshot_release(), and now
> > dpm_resume_end() when dpm_prepare() fails.
>
> dpm_resume_end() should not be called after a failing dpm_prepare().
>
> Which code path is that?

OK, I see.

Let me have a deeper look at this.

