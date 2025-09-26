Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BB8CAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 08:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9468E0003; Fri, 26 Sep 2025 04:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B758E0001; Fri, 26 Sep 2025 04:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1801C8E0003; Fri, 26 Sep 2025 04:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07B6B8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 04:30:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5664BA6ED
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:30:53 +0000 (UTC)
X-FDA: 83930730786.15.B7BE7A9
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id C57BFA0002
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:30:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bQxFlsyv;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758875451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thNEWAej1SgNRB1VQB78OWVsXGLh5leQSnto1fDdVSk=;
	b=Y7H0BDHcvJxgTTHHASYsP2+GhBNoPjpuvJ56NjOl9TTicRVSXulyd1EbfzvfEZx+ceXaOI
	jojdkKF9GYoMIMhTMo78Ex8c3L/6TDuBjfIMJLmCM0Csz6AoR7Zi/NyyLk9UFUMRtmAMWL
	GoaJyhO8Zn+OSmMPghpLIJgpzK0Izb8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bQxFlsyv;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758875451; a=rsa-sha256;
	cv=none;
	b=tseUNmEJV0Vqk4VZSi8YDaK+sGm2nCstaEiLfVcL2IcReMNumIIbRNtN6x+l3H79FTB9UR
	2qWItiDdFuZbOdrZu6ehuplZ9XfAlAFXO2gXUPT/LlpEUErLMueuCD/dLIW1gkVTyw81GR
	h76+5beMMJ2kGTXJrwrgo0WIsg1dDHo=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-85cee530df9so176143485a.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 01:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758875451; x=1759480251; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thNEWAej1SgNRB1VQB78OWVsXGLh5leQSnto1fDdVSk=;
        b=bQxFlsyvZYFYXjMRPtNLJqGmi5Z8RxoOwzevIawFeRIEgRYmZYVlFMIQiG6TVgvQmz
         sgHUPpkOKBuyXtQW+2h7TYcPlmSiD4W6PRNzDw/JQvFTmhlvAOslKfNfwhBq2u63jIP2
         aDI8g3gd2vKgg5SBKdadx7lnJnjRifanfNrMwcybboZXHoA4y/smWkAiXGaau2afWUlr
         lnexe0JpwKUfB/I9u3gwawi4XU4RGEHwi7V+3ckVr8U7wWePijDO8SXLAH9l+R71OqU2
         TDZx+iugR9GP0VmA6KwgqThiBgAXM5566lg0zru8YCbYWb4QL3t/G6VE1MsEPLw+gl5i
         qhjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758875451; x=1759480251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=thNEWAej1SgNRB1VQB78OWVsXGLh5leQSnto1fDdVSk=;
        b=wpaEQ5pN0spJZ0dgP/ga6ayWPGZ0M9fdsevY16OdmTu/2/Dv0KHcVkp3Nx/0Uua3US
         R4ZzFwCbbpyF1WKc46E8Ywufsl/j55Ny8AY8IxbKO/pN4JjOmJktfwasvIv8HXL4Ch2W
         Gwegl1Z/YTiY3A9GXjkSmRBfJ9hCqK2+hHfRz/NRKuhztXQk2dAbGFEXnMLmVuLzHBOr
         MkLRM5//9uBSsuA4b6JhLXDhoPyH9mxc8RpN/kC7p4sXAD9+9+kwv86ZJ1w/GlCR35eP
         i4pSliaq4IwgWvAJB3Ec0EBbkpdPW9InvEBS+aHuY9jFKemCxDAvujjyxbMGHeSwDcuU
         Le/w==
X-Forwarded-Encrypted: i=1; AJvYcCVCXaCThHA87TdCAHrkruJgN4Ia9KylQsCtg9sc0nfLuAK80KvnVeeVpkFK9AGtdNNn6q2VcUCLmA==@kvack.org
X-Gm-Message-State: AOJu0YzfPdI6Os66a8X7PKSgqXOeQh2aFBClyg9RQMk06h3/W8VTjiRy
	CBtWIya5GNKN+s2k8UzUozgVHiSqGRL1aGu2Jr7wffj+HC/XWZ8dfTHeuYTCBFCxe65VkG5LlDO
	LhRv1XKL1Lm1O8j8Twu9AyntMOewdeB8=
X-Gm-Gg: ASbGncu4jMMZ7KS28OQ6Nm8z4fyfOICCluKn+TL21yyouNYzNtbPcSvh1hRhyx5C5Xf
	eZrO7deqFuyNAvEnJjUQVhyMJA9X0mU+zzNQyS8JFacRnZQDI6q4DOaboMYWwJ7n0ghEQnA3YD9
	m2pg4pBC0qlqfKcXigg3+oVylFTNEU1OUcjeD0TizlTHB60TnpiLRm5lIpP3R9C40Y/kjRWjQ5E
	MwE7TDZg5YZqIaafhVaqcZBNHuW1qpozxf+lgAHXtslNaNtSO12
X-Google-Smtp-Source: AGHT+IEQn2g7GaenVfYIpg8793sRNRvoNraVY1RS2Agp6V7rHhz6AY0mis3Yq6EL3hWLSblCY/erSkrYcA7XajSRSvo=
X-Received: by 2002:a05:6214:500e:b0:780:6d61:bfad with SMTP id
 6a1803df08f44-7fc3b6e52c0mr95155536d6.45.1758875450618; Fri, 26 Sep 2025
 01:30:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250924181138.1762750-1-charan.kalla@oss.qualcomm.com> <CACePvbW=-KZhU_qi4UUw7Pjbz4o=SQwHmQyEOkxhpMvdetbPCg@mail.gmail.com>
In-Reply-To: <CACePvbW=-KZhU_qi4UUw7Pjbz4o=SQwHmQyEOkxhpMvdetbPCg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 26 Sep 2025 16:30:38 +0800
X-Gm-Features: AS18NWBUnKefLjkuLJYGaF1esLUxyHaCmdfHq0pDaW4STq_tBlLvrGMPK_6-4c8
Message-ID: <CAGsJ_4zhL=4qJDmGA5E-z7=VixkUXOi+qBnN3S-WWH2UbYj=ZA@mail.gmail.com>
Subject: Re: [PATCH V2] mm: swap: check for stable address space before
 operating on the VMA
To: Chris Li <chrisl@kernel.org>
Cc: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>, david@redhat.com, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	akpm@linux-foundation.org, shikemeng@huaweicloud.com, kasong@tencent.com, 
	nphamcs@gmail.com, bhe@redhat.com, zhangpeng.00@bytedance.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C57BFA0002
X-Stat-Signature: bmthuy6trat4tcufrxjuret451a39kp1
X-HE-Tag: 1758875451-451659
X-HE-Meta: U2FsdGVkX1/xjN0C+3VHKgIkTZzBnlLJP/HnIVS5zMjQ39aOZ8HExCPQz4YzOvIPCN/A2u3XjF6csFi0rzpcnAcEq2hElIzC9mQLzpjMKgHx+PCJaGUL7yaHvc1hJlruzhwmPhl6EypwMkN6TRpI5gxE4e4mqGyuX9zBSJBQOy3xnzgkEGjykCRPnaJNC5ohDEqOlvyHydeHYWl2aZTFfXiCAoGz0bt1ctfCR5X2I3p9tcWWGGvYCEagPp1rhnlWKPPmAfyuse+VsZyK40IS0edLZ93lUSOmqKWCYhsP3TWlSx5h52RNJCO/QI4S7t46luoHLfcxLz/GgDnCh5v/cv/0OPSjkEmItBHlnGI7JAyIh6Vj7YwRqq8WKee6CD2bve8M320bmKj/0vMAkhrqR0qstpa590VmiyP2EGarlCtfJIhEteLWQKAeHs8c/rjF9ZZiKREfbCKzxxFUQo8YfnkYFE/mOa5A4RNEHeUo2uJ+faq8ln6vViRZ7FjHu6IcbYFL/CHXen/s73qrjlfTIyREdLlXRd96c2m3Hz9dhzptoHDiPVAN6bkeSGGe+kIrmb9wg/RYJMkHSJP06hnTL8976TcuFLy94DDpIqH4ujnkFfugAQLITKTlrXvXBGGMjBEe7qEm9m1npyrglnY9tjR5JzzHXrhIRBWMq7ZSGhKFQZJ2EAZzOIGBXGiDIuxANOUCU93YbigdRz/rai4IXILgYXGdbz+Fsr19BsZSgEurI+NGL51eMGkKmwl43sB3HpyAcholH3MSILY6MiLl9hofCz2VtMGJKzPTeDCkFOW+YA/P3wc+pt8zZf6DyyZHGU20VVeQXzKVtwghQeguySfKJobqT1K4cmcBdqmMudFWzDE9ZsSgrFKH2pnUTS0JXMj1TWsxLzIjY05JD3PRDm7WaIQ+v6bO4BWe5+bgrnpQSATyx5XFQcUncfUJVJQP6sLB/omkiDMeUcuN0iy
 6Xzb2VnZ
 8E/PV/tMdTgkpbIYz7eqI3nuuAr4s5WGCvoeMCcjpMAZQxh6W2ezB1L5UyMNC1wHiJLbs/TC4mgG/Qjj7AmNFhVenCu0zGHCX1U4mJdd2KImSX5sMea7tWBBauBoGyyhB4RFY12sWUD4omoN25XJSiNcCE8ppdFrs35qnO9fzxpa0ij+08FnnnfF0ts1Jq7jRpxJsEHhdS+QM3cK0JN7WI9fIq8W7mP3F2aDiuTyz/zulpNn4/KggnCULFFR6MY5zeTVIVXsYt6jGlvVonoaOau5wft38hEeDppO+stcy44Zuf/eVtPzoJ8sDUHduhkkWKyBnfxU2ncgSalzlAbdJGdLqo81Z69E8Ve/XTnOtYdXezpH4Au69CRK7bKW+qxGZqAbq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 9:03=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
[...]
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -2389,6 +2389,8 @@ static int unuse_mm(struct mm_struct *mm, unsigne=
d int type)
> >         VMA_ITERATOR(vmi, mm, 0);
> >
> >         mmap_read_lock(mm);
> > +       if (check_stable_address_space(mm))
> > +               goto unlock;
>
> This is checking the MMF_UNSTABLE bit in the mm flags.
> What is the locking requirement for accessing the mm flags MMF_UNSTABLE b=
it?
> Here we hold the mm mmap read lock.
>
> As far as I can tell, there are two paths that can set that bit.
>
> 1) dup_mm()
> It holds the mm mmap write lock. This path is fine due to the write lock.
> So far the above race against dup_mm(), adding this  check is fine.
>
> 2)  __oom_reap_task_mm()
> It holds the mmap read lock when setting the MMF_UNSTABLE as far as I can=
 tell.
> So checking the MMF_UNSTABLE with another __oom_reap_task_mm() does
> not exclude each other.
> This is more of a question for oom reaping.
> Does MMF_UNSTABLE have the test vs set racing here? It seems this
> check does not protect against  __oom_reap_task_mm(). I have no idea
> if this race is triggerable. Just want someone else to double check if
> my understanding is correct or not.

I haven=E2=80=99t actually run the code.
My guess is there=E2=80=99s a race when checking MMF_UNSTABLE against the
OOM reaper. I think it=E2=80=99s fine either way=E2=80=94whether we skip an=
 OOM-reaped
mm upfront or take a middle path=E2=80=94since the OOM reaper will handle t=
hose
PTEs with the PTL just like unuse_pte() does and eventually free the mm
of the reaped process. It=E2=80=99s probably better to skip it early and av=
oid
unnecessary unuse_pte() calls.

>
> I can see this patch does protect the intended race in dup_mm() vs
> unuse_mm(), it adds value.

This also seems to add values for OOM-reaped processes to avoid a
useless unuse(), in case we aren=E2=80=99t skipping this mm right now. I=E2=
=80=99m
not sure if we=E2=80=99ve been skipping OOM-reaped processes elsewhere.

Hi Charan, do you have any observations on this? If an additional value is
added, could we record it in the changelog? Otherwise, can we add some
description in the changelog to address Chris=E2=80=99 concern?

Thanks
Barry

