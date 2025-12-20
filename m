Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EE6E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 03:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2EB6B0088; Fri, 19 Dec 2025 22:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7F956B0089; Fri, 19 Dec 2025 22:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D615A6B008A; Fri, 19 Dec 2025 22:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4A646B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:49:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B93BC0329
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:49:42 +0000 (UTC)
X-FDA: 84238470204.11.402798A
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6D5E11C0002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:49:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fjS8tvTF;
	spf=pass (imf18.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766202580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7qYCgffKlEOqB9c2pFJE9Kp1sFrRzPgu7+2RZ9r6q0=;
	b=VtBNgP+3WIwl9aUMn+J+wDJ6gyFu+AsGXVUXOke3AmxjQx8OcWA229nGO7Zj4TbeIs9hlQ
	tE+8DzwjMN2ykyiRwL+qj4FNzKQOe+/e830CZYry/MzL4mhgPilmmgcyH4x5nZp+dOqRLo
	CIUqces5wbjLmBTkwXdCS8yTsCLwzEU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fjS8tvTF;
	spf=pass (imf18.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766202580; a=rsa-sha256;
	cv=none;
	b=6aSE/ThbN8rpcO754vQMiu/ytMgvsuvgpKQwIzhk2VHeE1FBUkatDKNMq1/6UDi/3mCPCv
	phyhU56p2wsz0Uu8Dqges9Ewck4hV3o4c/ziA4u5wb0P1WzuQNGX7JE+SfCj8Se0w//g3I
	lUp233S2azD4HgQlk/SoMfwpRv/NCCg=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64b8b5410a1so2097790a12.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766202579; x=1766807379; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7qYCgffKlEOqB9c2pFJE9Kp1sFrRzPgu7+2RZ9r6q0=;
        b=fjS8tvTFsKYyyl2BlI67ivf4u4IfKKDAzJNqudvGS+64/2I0/J/0n7LVQreftH57m2
         i5QwqlZ2e9xDgU+22FeSYisIJIWxvSai2ngAPb9yt6U4o9MGPwdD7Ft3nMKnEOJ3J8Tq
         wLebqKEXPUG6UkUJ2ugZXmqFb6M+1vuXiijGe4oyOdI70gJgNFJRPvGZr2VX08UwF7iW
         J3opOmztDveLZuaS1aGmhBDDiFQFtIB9eVsi8i1jskHRH3UB4Tpxk2K3Sw0czvkReXb9
         cwbeh9/MUPClbFrONUJa7JyPYSMgF97yQ/3yPxnL+ZiwfCt0hUJfToAg07y1dpwTzbmU
         Z5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766202579; x=1766807379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c7qYCgffKlEOqB9c2pFJE9Kp1sFrRzPgu7+2RZ9r6q0=;
        b=t/OnqTnMHK77P8b/U0BYMpbj3MAdmbBY0BK2EVfKLrtSLD33kT4EZcM6uuYdQ94RDO
         4lAb116EUT4psXhYIxzZ8FvnCZwWN1O6/Kh0tdXMALG55R7eKpVnXnIF6g+gQmupAcSy
         SdzzXlzyZD4EZql0NKlQvFolNSOLMc48Ukx4Qp9niiO8XPzGQ9cHb9X8AN1sQpWB1o6/
         xYp6W2wmy/alfhRt9Bve7l0m4ZXKjZ47utei4mIRL169QT2NhqFjP+fCjpNUoj72Zl0t
         7LVEyuHTHofeepduxbazvmvtXHPwI+ZeFTAEes2NMlm3uF8Klk6FC2CUn2AznjWmjGuv
         bgrA==
X-Gm-Message-State: AOJu0YzpAGLoOay5AkVyh/uTb3582EYFO6NS2IX9Uh4K9XkQBqIVmKIg
	2r4RvBlwYyd//6p5+cdRo1XtkqBizm0aL5FJGQj4+Z6p/kSi7Rk+MN8Xl61yJbqCYicBOBmjlRJ
	dJt3ifYzLtEK6V2NDEu3lMDbFR9FdZiI=
X-Gm-Gg: AY/fxX5GQw5enxjWAmuyNfP2uifLWIQ1hQiQjrA6/mrqK8UZmuI+gLdj9kV47weWq2k
	zqb/SlX/S/2RetJeEAL/YrT3DsYXTgShSeqkHyxUc0/OSXL379hZ2oPQVk1PObhzC5nDpCnBvvt
	P9AtT03/OZ+7d86cCDTircDsNE3PfeFN7udPJylAAo3O7DmUX9N8Gr07ftsUM7KrqmnE/ezjPbF
	lZV1YwE7ouod/7ma0kPDhDgORxNJVoKEmtBn2OnwzAXxZd3NTO6x5hRpJxSK+SwUweJ3TNLh89K
	H50nSLoixF1BCZLSLqRymej4h/6j
X-Google-Smtp-Source: AGHT+IF5ixoODhjdX2cDM8dWCF6V7nzj5ScvGzgKdRfMHgVw3qln8063IILPuJRbPLH52t6u8XtpWlt+eR8hHG8p4ZQ=
X-Received: by 2002:a17:907:6091:b0:b73:6931:558a with SMTP id
 a640c23a62f3a-b8036f61be1mr419474166b.18.1766202578529; Fri, 19 Dec 2025
 19:49:38 -0800 (PST)
MIME-Version: 1.0
References: <20251218150906.25042-1-klourencodev@gmail.com> <20251220022712.43244-1-sj@kernel.org>
In-Reply-To: <20251220022712.43244-1-sj@kernel.org>
From: Kevin Lourenco <klourencodev@gmail.com>
Date: Sat, 20 Dec 2025 04:49:27 +0100
X-Gm-Features: AQt7F2qahDAxkCT4HW3YG_V3avXkd9fqYt-GkqwfhT4-u5kd17JCGVuQ3HRejm8
Message-ID: <CAFveykMG1Qg=kG27y82PfH_prC5Jp=CTa_6Wttxu1cPkfzv9=A@mail.gmail.com>
Subject: Re: [PATCH] mm: fix minor spelling mistakes in comments
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D5E11C0002
X-Stat-Signature: 5o3f5u7xuki7kcxds69kx98dhuuh384h
X-Rspam-User: 
X-HE-Tag: 1766202580-247363
X-HE-Meta: U2FsdGVkX1/qGDJhZrmVTCXPu6Db1uXx7s4ecV/LLl4HVHkY7MmJDU5SCxUxNA8Sx5f5wiYY/viPdpU+JX3KuqJi5Xu082wf9UJ7fedu2dw2vnGRoyibQhIizcJIb8NOUMOxXtEPrbdGgUQrzmzQBrVMNiYYIUIoFzMeiYKTEQt5/ryLbkILdv3peD6yojitBcugm7qAYZCRzGY0pVzlbQdEDz8HuM9ceEcAhMbBB343D6fYJ6zx5IADYUNZmzY6686FYxJfjapQ+/c6pxeDUqqpYxryZDjU6qVUoIoFCaYl2fNBP7UDwUYChNWZhC+TqQVZzE3jrMGMOw1XUuITysV1U4ZWgcbgqQRLtxtU9Kzu9nP6Q4tkEIJsDWSCAzD/LETEhp00IAHsKA+XqHgadHFTEfN/bqbQsKODu9zIbK9EWcOA8320BJazVY4EX5zvysMviA67dLBBoPLTQ50Aq7lAsETnUNORb7zTcOo5Og7XzaWBQSk4mOJfg/ZG13rytUR9Yu4u90OFFxHCWPeN113UsxcZr5V92oh0ufpWWvGQTKaEUPCGbnRWSh0C5JiObNsbHrFhxOgEnh6rzSvQqf5Wpa6TugymKNv6tSRuuoDDfxCe1pkzk1cLajFhSVej0O+ajyDWIaDbscgxCUj2c2icAEhxdMZmhGMv73biHaDZ22C379A2wmcU14mOQJcfWLrz8mtUwBGZbHsJ0Po8vLcOqa5ObHsOZ3SBy/rJHTIGM37OJyE3yQHGI5QpP1P8BYnSuSTtilIl/GQqh248ZJOCzF4U/xqDVk0YLaTTHR2f5TuKtRrJ+PWzvgiS08zbOYzXQP96M/scS89QqRjXe/XAxDdlFLsmMukFJrPIfQHBDvjPj9MRZX+W5Sqlb9ryOyf+pwPPZoaTEQ/KoOPd61j+KvBO6hjQbo4NkKISaaZY4di1yI+ltsTC04gow5Ux44c+pkAlvDcbsjUfrOl
 inCIDRL5
 uxtLTvIjGF6LpSWCHewDT73QQM6xiueo4o9fG18Cwj6p2o6tl+yhKOIIoKulJgFIMAlgaOAKqqFja9EfUOs+emWXxh7M0rG7HXdEpU2VJWwdurR0irockon788vFV9vLXARZiXreKTEJ7tVbB4P88/kPHuTqdVBvcgnJbfEv9nTMYgyQSv5xUapK0iqwf5sdYi0CoirWTcnefSapxVhQ/0DDh4l3hpTSfMRkIdrq5vlGcDzdBaytIXTKvR9Aq9BkMzhP/n6TVRSInKrC8q9p3Z+fs0a/SRP1CjgMb9SmjPmbOZUM4gG38dL5TGYdBaiNNAPgLm0VoaE0YwdryKoZcz2BLfbOuFQg3IAevSh2W699FXKOI7L6rNlFgUS1vy+VpfACj7xoCN0AYl4rY/Bxm0Yp25Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

I think you=E2=80=99re right =E2=80=94 the wording there is probably not co=
rrect. If
anything, I would be more inclined to use =E2=80=9Cthe next step is=E2=80=
=9D
(singular), since there is only one alignment step following the start
gap adjustment.

That said, I intentionally limited this patch to clear typos. While
going through mm/, I did notice a number of grammatical issues in
comments, but I chose to ignore them to keep the scope focused cause
some typos actually made me wonder whether they were kernel-specific
terminology or just misspellings (e.g. =E2=80=9Csinze boot=E2=80=9D).

So I=E2=80=99d prefer to keep this patch dedicated to obvious typos only, a=
nd
leave grammar cleanups for future patches.

Thanks a lot for the review!

Best regards,
Kevin


Le sam. 20 d=C3=A9c. 2025 =C3=A0 03:27, SeongJae Park <sj@kernel.org> a =C3=
=A9crit :
>
> On Thu, 18 Dec 2025 16:09:06 +0100 klourencodev@gmail.com wrote:
>
> > From: Kevin Lourenco <klourencodev@gmail.com>
> >
> > Correct several typos in comments across files in mm/
> >
> > Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> > ---
> [...]
> > diff --git a/mm/vma.c b/mm/vma.c
> > index fc90befd162f..bf62ac1c52ad 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2909,8 +2909,8 @@ unsigned long unmapped_area(struct vm_unmapped_ar=
ea_info *info)
> >       /*
> >        * Adjust for the gap first so it doesn't interfere with the
> >        * later alignment. The first step is the minimum needed to
> > -      * fulill the start gap, the next steps is the minimum to align
> > -      * that. It is the minimum needed to fulill both.
> > +      * fulfill the start gap, the next steps is the minimum to align
> > +      * that. It is the minimum needed to fulfill both.
>
> Nit.  s/next steps is/next steps are/ ?
>
> I'm not sure if that is really grammartically correct.  I'm just asking. =
 Even
> if I'm correct, I wouldn't argue you have to fix it right now.  So please=
 feel
> free to ignore my comment.
>
> Reviewed-by: SeongJae Park <sj@kernel.org>
>
>
> Thanks,
> SJ
>
> [...]

