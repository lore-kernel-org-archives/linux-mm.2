Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747A0C88E42
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 02:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F786B0005; Sun, 25 Jan 2026 21:06:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3186B0088; Sun, 25 Jan 2026 21:06:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984F06B0089; Sun, 25 Jan 2026 21:06:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 848086B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 21:06:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1909514064D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:06:49 +0000 (UTC)
X-FDA: 84372476538.29.A0FFA6C
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2BC46A0008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:06:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bXyF1EOq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769393207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZ5ZYGNKgcGexi8kzGllYmBnhwAhjx9WXPciRhcwUR0=;
	b=R4ojnUm6FPP5uP2nM/0r0xyBK6MsGx+Fs7OIssUWTTgcN5x5N7pWlIYdXaw76RviwJFrSM
	Pj/+XDW2QcNmyDKVvXJmPoLeQxPfwrb8vRSqRKpyrSq+LNJ5vhn+mQ0pN3RFmQpbTgpyqi
	+cGtN8HSig9zn9I0cWCQFPGMLPaESFc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769393207; a=rsa-sha256;
	cv=pass;
	b=gdFZYiV7H3Ac8IngJhspVqM0DjSMYTr1Tunfy+sy06757VTxeyqYHYOXAgpSGyAlgPasjZ
	Ejcu+7/e1bLFXiHRIQ3Xpzv1DeUP0smsfm1iOhLaKveB/qvVDpWySpfaFQgnCqDo/LW6CT
	UtJOEQASIxwoPxah3chr5uiZqHIaIuk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bXyF1EOq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89464760408so18231106d6.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 18:06:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769393206; cv=none;
        d=google.com; s=arc-20240605;
        b=I2TCwHumMM0UURXmop+sgpCNRdYcRm6jVxVbV4m9iugd8pXi7ul7KxNN5h8xRTJBZf
         SDpV5mhPtiOkL04eNJuWgmc+dgt0xFyhYhDGlG8MVwGhfg8zHhD9nrR8qrpJE9QahGCf
         gOqxxKeomI5s6KSH0vObWAvh2RAX99RUKzoAPjmqtJtWqu9JnwyY8TpX4W6CCF1B1dkL
         /IeW0K/wPhlQMZivi1vr6QJfR5MtF5MZGFa9ZnSJiquT4S28RJmMfC3EmZCWTDlmmmo+
         Lu5JOAVo7VqRy9pP81KC22XQMUqaoNq6woyT60Awr+nw3EubMS7QD96U0L7JM8fA0QGj
         RmVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bZ5ZYGNKgcGexi8kzGllYmBnhwAhjx9WXPciRhcwUR0=;
        fh=nO8vPiHV1D1WzbFebARg49ne1HNWbdq4Xg8pEHQBinU=;
        b=bByIN/LwzxuvsYAcmvhchVZMIx96psgPwxp4Y8aDFY/b+3PQaToyXRBmACZwdY7/A3
         Ka4pJCjNmyGaKRmap4gmqBuU46OLv4HmXXp4VuBSWa+6q2PPSJbrvoT8IoE3kETBGt21
         g3cKjoShycT2Nd2zTrgINvziIUQ0FvR56A/S+9X4GxjJzH0BmkLyFm3YR/1rPtU9l7cK
         VJKglsomjkmz34F6Fnv39vLdyhE2zyNSkiGSaBDOmRaFvdoEEXqYQUA9f1kJPQsup80k
         f5WExx+QvHxSw3enKAuUIt6QUCuA7lSjBg5mz3wlrLRCYEAKyJrjxUqK2w2PL/PvCSWn
         HVWQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769393206; x=1769998006; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZ5ZYGNKgcGexi8kzGllYmBnhwAhjx9WXPciRhcwUR0=;
        b=bXyF1EOqpagaUSfioe6l/LtXuCJGREkW/g9duLrezyO4ExObIziqr9/BCXcHH8I4Yc
         ewWzyJ9+ZR7J1EOkAHN3WPhv/vY/02dtNfzNhEr7RSdweeVbx3LRV4akECUTovW6Hzkn
         2u9ZkOKhy6QpGbYdLJ/R6gFe2UI0O4t25tUhPb9pyG+OKRWNZqg7Q2vvAaRLoFBybbC+
         jioPq4N7uN47T68sKPF/mJZXTN7hH1uFKvB8yYlUXyCjScNa2AuzEqFE6aap+P19Lrt/
         qP5lKFXivQfubcnCWOEqy9JRc/NBSuMPYJdfozOhMUTZiA7/VMWfyYBKHsN6jws8tsmW
         8tqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769393206; x=1769998006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bZ5ZYGNKgcGexi8kzGllYmBnhwAhjx9WXPciRhcwUR0=;
        b=NduvCsn09Z2pd9JsQRaHdqa+WYc2RQXz5HKXTVhOtJEpKOQcFXF2kOkDawolxOSnu6
         V2nDnyUsmxg5zAvMDLHX9g+qP9qT4L7ovO7kNMyWg22/DIZOs/eq0qJIQYE/ZV8pi10s
         HxqurN4sokTQozN1sz2rJVorQ8+XjGo5PsDfRDJmpGlurdW/fGYUtZwBl/iVvtEepcIy
         1cvB5oKWn5+gs0JtrJNbcY9q+HTHDkFc83KZxnYwPMUTWxDUVs2ZZm97cDtf2c6zFQ7j
         ePLYrSRB4Z6Y1r+4pinSEzWnI3u94UQ987o7nRvAjnbBCapZPSjuXB+jErD5RsdFfp6w
         bjCA==
X-Forwarded-Encrypted: i=1; AJvYcCVnUkKBrMhJVz514o10V+FTVgZV4Wo4ey5r/u4T/ph170Ri6+Fqs1i21LO2Htox68lBId7dZezlyg==@kvack.org
X-Gm-Message-State: AOJu0YzfDUgiB6sJbgEO8xM0wHY7ekBkyNDcSy2p6BJ1MfIcw1ieCUT0
	bWs9jDsaUe0tPacPhOxGbBJC4hvmIAIjO5eCsPOsp7O9+K8wGf4VVWr/UIDn1NnA3zRN6IiYzWN
	wYXnuOHT4UAOV7Sfv1kd6STAnRAi6PWg=
X-Gm-Gg: AZuq6aI+deZKvJejxzQ7knCxdoP2H1iFRI56a+EDhJ1Lc9didjyRWdCaMonGMZ+S/rX
	aM982Txut/NvKMHjHLmaJ0xwnJpihQdWLp6ZG38Zc7EWRPhnO3QfRA6oQ0S4vkUPm9Xn3ZjVPXf
	WJhS0fNSbZIrd7fCWqnVxxpI+z7yjw220ij0J7+fI8oBqzanUBIc76ZkEDyaXz0Yfb1szLaoRvn
	1HIiWR6mx5N8yhSpQ9UYRN+7fZIbkXy0SrzOnkrgu2oaWI3PlQ/2jTg2hIW4Zky8i98KFcIzw==
X-Received: by 2002:a05:6214:29e8:b0:88a:35cf:8db3 with SMTP id
 6a1803df08f44-894b06defdemr42458756d6.18.1769393206037; Sun, 25 Jan 2026
 18:06:46 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-5-vernon2gm@gmail.com>
 <5820b1e9-3c45-432c-84aa-638cf92fd240@linux.dev> <CACZaFFPCZfxG+FK9rrefFi1UmtWxiOf2j6KXx+9JDJfcHBz8ww@mail.gmail.com>
 <8fb6cba3-681a-4e63-9409-d35ab628d42c@linux.dev> <CACZaFFNY8+UKLzBGnmB3ij9amzBdKJgytcSNtA8fLCake8Ua=A@mail.gmail.com>
 <18e34ad4-82b1-42c3-b01d-ac6e5330c4e0@arm.com>
In-Reply-To: <18e34ad4-82b1-42c3-b01d-ac6e5330c4e0@arm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 26 Jan 2026 10:06:35 +0800
X-Gm-Features: AZwV_Qj5n3w0NQjJLciHUdhtx0fdi1WeS65zz_zCGDqNQoZsv1qJtLIEfzZwg1s
Message-ID: <CAGsJ_4z1TRf9jbONe_cmqNQ2_t_vPKfQ4z1aweOcoLtMiosKxg@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 4/5] mm: khugepaged: skip lazy-free folios
To: Dev Jain <dev.jain@arm.com>
Cc: Vernon Yang <vernon2gm@gmail.com>, david@kernel.org, 
	Lance Yang <lance.yang@linux.dev>, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2BC46A0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nsks5jbptmkkwenfszhh6bafmuf48oxe
X-HE-Tag: 1769393206-528401
X-HE-Meta: U2FsdGVkX1/V2dJewVFND/sgzDbsf526JCKQ5YPpsWQNP6c+G/61dhoYomqI42KLsuVchwcev55pp+R5LgerQvXbShLfUU34yn8tCJ/t5/YH6eUOw41k8eP+r+xy+fbsAI51Ma54Y60TRgDDOzk/oT8WJ+fSQ3Nu0thEkYIykJ1V0aFbqyTLeqddpf6JIH5rMKhecAtbQi/QS8Hi4NAL3fyyj8VfxN52qITkh6yrFcZs35X6mAJX9y1n3fCKVF09Oe4aXqPwpHAu1CclPpMMvwtYBLB9uKh8XsYUxFc2ObLlR6cEF7UuaC5aPBMZ/nrw1IzkPe6hOyytkJQbABAyDsiiCMYsvKFAYw2Oto3QqfkPeRAgR9kbCLIiKkO2OalDKA1CKnadaK2cuciPC9sDIsGCYW+H7UnLLGpY0pv4qUhkfBQ6stJYAST35Q2Bu3cnnBYNdb0hRtzwif/oWadPisz/buwVWboCLUnnsqGc+etIOeA+cQNy4GvF3BxWlzBBMaAF8TI5mrv3wVFVaOhDr4vq40491li50m53bKJdPehdYt0eGUtR0xfW59zfqCCuzMSafcF6B4iutUYLrj6vKoMe3YbUAkb/GjPwbiskBU3OX2FWTgI1VVaepk8mojVmDS78uItC17M6YKtwTya7WNvqMYJQS7nM3lPrS4zYGTS9F/aV0XPUxaDV30OatZ8S9VjGUHFvyCs01xMC1Xneutxb3/vyB/gkYI5rTFvhazViqeSvqzMXmW3w7w+8yERAs2xc8k1Bed8sJapS/+f5Ze4CqjwAwfKKuwsa0dy0FNlks5OeTKdNvT6zHxOPGGKxxt+eNI/AwwqWScsSOCRFpIK4zbLWmSt+9/Dli3EwJQ3tkOiow/q/7PdddM8eDVO3y2RrE2QPfucdZwr+cx7qTIOt55HWZnUY6GHdGnlmvhKZ+F2jpqubQDqAj7cpfvGRExZMHgmkakAlOGddxek
 nG0bDUmT
 MRRSu9j+fgVkUmkkP8pkK2lAMYnfqr0ijAyB9FUkYxT/6NkojbYB+SAewaEHp0s9II3jRYo6ub/xL7+PAu8+O8SSb/chdLOdlc7HEG86nH88m7tBLGNOwNMBH30JtysAB3byvmFnr8FrJZLKv9aYdJ7q6X1/uNb7X4EbB8dAEE/qsYXkAuQ3KMMqFMa+DRNp+1CgslU7NctOqssX9Y66c9+nBwYdjfszRzF/vIBE0J/zSdRXBJVSkWyotGuGVpJsPAfjCx6kjk6pj9KuxXKncO+N4ST/7eGBGa9NmBJ+UgSwGorU349rZS8m0E9hl2MMR+DRA/IFyiTOvczKlRgrj+0srRC/RfR3AzBC8y+PW7by2AkkR8OiNnQ0lmSBP0WWdAF8Fyk/K/s6CjSHI8p5fbbhnFTujCW18JlUWPWmt/+Ghiv2xWZEccosKdYCupjvLcTkllzy9jOIkuVffDp78JoroiIVVLikpRtA5E6eM2pB1Ym6PP9QwUre7Pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 2:48=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
> On 24/01/26 8:52 am, Vernon Yang wrote:
> > On Sat, Jan 24, 2026 at 12:32=E2=80=AFAM Lance Yang <lance.yang@linux.d=
ev> wrote:
> >> On 2026/1/23 23:08, Vernon Yang wrote:
> >>> On Fri, Jan 23, 2026 at 5:09=E2=80=AFPM Lance Yang <lance.yang@linux.=
dev> wrote:
> >>>> On 2026/1/23 16:22, Vernon Yang wrote:
> >>>>> From: Vernon Yang <yanglincheng@kylinos.cn>
> >>>>>
> >> [...]
> >>
> >>>>> @@ -583,6 +584,11 @@ static enum scan_result __collapse_huge_page_i=
solate(struct vm_area_struct *vma,
> >>>>>                folio =3D page_folio(page);
> >>>>>                VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> >>>>>
> >>>>> +             if (!pte_dirty(pteval) && folio_test_lazyfree(folio))=
 {
> >>>> I'm wondering if we need "cc->is_khugepaged &&" as well here?
> >>>>
> >>>> We should allow users to enforce collapse via the madvise_collapse()
> >>>> path even if pages are marked lazyfree, IMHO.
> >>> $ man madvise
> >>> MADV_COLLAPSE
> >>>          Perform a best-effort synchronous collapse of the native pag=
es
> >>>          mapped by the memory range into Transparent Huge Pages (THPs=
).
> >>>
> >>> The semantics of MADV_COLLAPSE are best-effort and do not imply to en=
force
> >>> collapsing, so we don't need "cc->is_khugepaged" here.
> >>>
> >>> We can imagine that if a user simultaneously uses MADV_FREE and
> >>> MADV_COLLAPSE, it indicates a misunderstanding of their semantics.
> >>> As the kernel, we need to safeguard the baseline.
> >> No. Afraid I don't think so.
> >>
> >> To be clear, what I meant by "enforce":
> >>
> >> Yep, MADV_COLLAPSE is best-effort - it can fail. But when users
> >> call MADV_COLLAPSE, they're explicitly asking for collapse.
> >>
> >> Compared to khugepaged just scanning around, that's already "enforce"
> >> - users are actively requesting it, not passively waiting for.
> >>
> >> Note that you're *breaking* userspace. Users would not be able
> >> to collapse the range where there are any lazyfree pages anymore,
> >> even when they explicitly call MADV_COLLAPSE.
> >>
> >> For khugepaged, skipping lazyfree makes sense.
> > I got your meaning, this is equivalent to two questions:
> >
> > 1. Does the semantics of best-effort imply any "enforce" meaning?
> > 2. When madvise(MADV_FREE| MADV_COLLAPSE), do we want to collapse
> >    lazyfree folios?
> >
> > This is a semantic warning, and I'd like to hear others' opinions.
>

That said, it does feel a bit unfortunate. I was wondering whether we
want to give users a hint in this case, e.g. via something like:

pr_warn("Attempt to enforce hugepage collapse on lazyfree memory");

But I'm not sure whether this is actually worth a printk, or if it would
just add noise without providing actionable value.

> Regarding "best-effort", it is best-effort in the sense that, the
> madvise(MADV_COLLAPSE) is a syscall needed not for correctness,
> but for optimization purposes. So it is not the end of the world
> if the syscall fails. But, since the user has decided to do an
> expensive operation (syscall), kernel needs to try harder to
> make sure those CPU cycles weren't a waste.
>

Thanks
Barry

