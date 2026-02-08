Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFFCEF06E2
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 13:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30E556B0089; Sun,  8 Feb 2026 08:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBB06B0092; Sun,  8 Feb 2026 08:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193DA6B0093; Sun,  8 Feb 2026 08:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 068D96B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 08:23:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92F5D8BF9C
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:23:45 +0000 (UTC)
X-FDA: 84421356810.22.7AA2787
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 897C5C0006
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:23:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I9Kvd96J;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770557023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZIZNzbyl0ltEYOstNQmjNET5LwEuPQ8XuyDkoDHEg8=;
	b=POKpJd93MDnw6W56hZc+M4YISOi3H2uXsWS72gcA917CIQMG3GANW5IKdNVdDeLpcTnbWw
	mOvmbj69kmE5KVXD+3YliaNOlO/cglpTZpCTirM6vhLRzL9BXWT+WZVbKuTzU7ejn3sNOJ
	TLso3LQfzq8Cvd5uv4386tOZUwUvTQA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I9Kvd96J;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770557023; a=rsa-sha256;
	cv=pass;
	b=Xc1SmwSAiW1hBhyczHtUejn2Go/ejD12O153JX1eWYAhTScKMj3dKeH1qAtj5TUYUxI5S0
	U9QUKwkDX8vW8VXygLqFtRbpEVku0kkt5TFVpn+TIo5VK+KQbhs+oTTLR5DRPsvRGUKNQy
	jUOzv6cKr1WgGfP9xdV9ACBQbvRGj3I=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-382f0732612so11678541fa.1
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 05:23:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770557022; cv=none;
        d=google.com; s=arc-20240605;
        b=eSFhmn6PdJm8BsRS+3FlgTKBBqbeQxKS2xU5/Bl/qSVqDO4D1TYa6AlFAETay40cEQ
         +YwEwMSFapNO9+0tP4YWCXZrBofy6eePoidnp9y8DIzEicYMHLLrC68kxvF45hSYQFxr
         rh8YFfYdJpidepBnZQcwwUq4UYVd7h3N8/6q2MZFj9Ox3bcRqxOH9fToXV8NZMONyJq5
         RLmQx9BQH3OihYD49WFFeqnAMuqpTSP+JZpdzxxr6O6j/aWGS2RgGV9lQXJei3tEdIYj
         hcFZJTjf+DaqVJK4cedp1ujyGA4OyJ4/rlsdpSY0eJ+xrXssUDyiZmf3qJNe+HZySZ1x
         NvLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oZIZNzbyl0ltEYOstNQmjNET5LwEuPQ8XuyDkoDHEg8=;
        fh=TPeSa/DX5yb3XGggdDBr9VDWyBvlsQ9wLhltKRdkBM8=;
        b=bNLmPkFBLJL6eOHtDPx/wfaltnwovIqSN/1pE3eQ7BijB9/a9PIIc532k4fhUS0cIm
         6S4+0cYo3aFIIuEANBH5Oxjtt8rF4gkbAbQeCg0rUzKO3nrsLAIvjZrNnJidvL++oGu8
         f169CBT3BRClSkeO0RhQxS78HwmrjPORuFdHAjA8/If1raLIf8aNSOf+57yrRPYOKrRX
         meEi8pO5aJ/GGvyYB12hk+3sOYn37TovzM/kjxy6ZawOrHouciBXu/3f2x8rfoaaxS9X
         ICavpYxBToqE7OlbsRH5eZV/Pu4M9w6IHY0xWEaKX4j8uLVu89jZLBNa54pYMCVPqTWN
         EozA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770557022; x=1771161822; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZIZNzbyl0ltEYOstNQmjNET5LwEuPQ8XuyDkoDHEg8=;
        b=I9Kvd96JYCvYoJ5sHOk+ylU4MBsiHALBAAER5ih1aBsR4Ikc2qcKTQTpd1GAXshgd+
         hITeGjaBjknnpdfIcserzAHy17Z2nhsfLvYhc3Y7K212jYUkLpG9Vq6fPSL1uOnvp6jM
         hrY3ig226k8YYfFENc/xdHZ0xFFK8gpoI2IlBUSl8bkFo7Eu4CGDExYwSU4Qs6auaaRZ
         JH2n4xGwLIAAymgV+2EuOD+xSRHF4biUOS/vc8iiZW0VblD43Oz4u6ccT1NuiwFBKk0P
         XB+wFO0CDj4WVssOdbyjFInZhL5WW60CYjf118x7f6Mwn66JEA4FEho6sBEwpXJ0K3zx
         eRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770557022; x=1771161822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oZIZNzbyl0ltEYOstNQmjNET5LwEuPQ8XuyDkoDHEg8=;
        b=uTmDTNbG2dhFYkr+LPIMaHhNG4/kFfmYzZUImOfuHTJBlQcwc5uLvMh3b4ERKjow+y
         EIM66LnEkzg4frRU0oV5DipXu+ya9cD9XwFQhS8xGA7bvrcznYbyGj89vCceN0d3lnDC
         kl4CUxkIKGk9KHdOvBGp5QTtlto8Pgx2hBFatQG/vge1RJ0MNsC70/J37arDpJsUQ1GY
         L9oepxeFzLJ7JS8U9/fUVReFUEkM+bVFUzgxgOM6oJEDsBn6bq4DwdP25ryAgNT+9Nw3
         9ZVpf/WmtuejTis8R5O8qLKMr9Ty/ythM7say9FQVrM45nJDuKQ3SQzlEtIBGGkRXSnP
         I+/w==
X-Forwarded-Encrypted: i=1; AJvYcCUPxKb/r0unBz89whs+CCGBw4LcZRg7nZ7KG4BPQF+iz90NaG4vZnFDzYOWr+elZlFSag05pAwLfw==@kvack.org
X-Gm-Message-State: AOJu0YxlNPoiImef+QRjgUAeBgmuP04lgOJRoiXh6ckRoW0fgTCPLGWh
	Xr9fGnvMHmXxkz5GGm0BnK4SdIkBUZI2I3nLnvAY14Lyke0YNratk4x7rYIXRrEm0PN+fl8jHpV
	fUJ8V4dkrIWAJMc5gkvrdxpgb9mI8Brc=
X-Gm-Gg: AZuq6aLIzasWWrKVWSGJDrVC91hiZFcWZ8iBjjsJbMZ0A0ZyV7x1geZlo4i+jWrKESy
	pWWCjiD1cXs0YfKo2jkgW0ptEbFSivjte/jiISzv5X7/jX83+xZ8YzvO9aAb9v4kEN+1UisQ6x/
	jTAiywdpEJ2XNc3ZOHxP7TN6A1zxXhr0BGbUI+PhHe8aBDb8JYbXFxZFkjM2Rt4GbWsM8PP4Ouv
	45yxEf8538wlVhp6qz2hLC960/vweROQg3Kz9dPJrB9FvjPG7RtwS4Q1ElHmZTvsm6xDo77
X-Received: by 2002:a05:651c:4204:b0:385:bb79:77a9 with SMTP id
 38308e7fff4ca-386b51520f0mr22146761fa.41.1770557021260; Sun, 08 Feb 2026
 05:23:41 -0800 (PST)
MIME-Version: 1.0
References: <20260201122554.1470071-1-vernon2gm@gmail.com> <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org> <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org> <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
 <1a6d8295-e27b-4440-a367-af0432a7af4f@kernel.org> <6zltgzs24wpypzu36ldwgtzilhv2z3ofuu45azp5u45huiwqvj@6jhhp5r24po6>
 <78b9bb1c-21aa-435f-a697-ebbfbe604a5a@arm.com>
In-Reply-To: <78b9bb1c-21aa-435f-a697-ebbfbe604a5a@arm.com>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Sun, 8 Feb 2026 21:23:30 +0800
X-Gm-Features: AZwV_QglA-0-l7x9xF1ftx-Sqfnt07biNm-yGebo5N5uuHZ9SADIuYNz9ktcBr8
Message-ID: <CACZaFFN8Y1dKYJPeNcnE+9hfBYNFLCJMi4TAyKuQ70JvjcrZPQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: Dev Jain <dev.jain@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: sst7i1n5e1iqp7d6ua4unrca3to6qyb4
X-Rspamd-Queue-Id: 897C5C0006
X-Rspam-User: 
X-HE-Tag: 1770557023-31455
X-HE-Meta: U2FsdGVkX18sfHSdTllwE0ruW1NycvmsJKMdpF+MTJkbg4bYvR9jID2aauSFVrBJOlWEpiuHEHCDdr7NNT7xGx718p3Drk3ya6k+zj3FOSPGvJ0CaGEVicnm78wQVCuGCsA07P22mNuk1IbrOCSiLh8Cj4Lr75MpYFdy0KQFrSPB81uzRURxI/U+1pe90dXxyFOZZcFGyd4OR9Q0XPdrBUVJvN8teCHRCdD6tj2LfOkWR1m9fyhk3hr8SdanrHGvPjZiWSJaUbzLVs+DllP03CGQ1LcnIx7ZLPw3bl50HmYbBrPI1dzJyFwxepc2n99INWwYiutxlUo1jt7TbwGqJwl9x8t9K1wcCdIVTtStLWC8LhkqnD498aj11IJtmdbKKs2GdiJv8MFtctrjNs4g3vnZqHVk0L6RkW8UBLGW0mo3rwKHTtjixypt4Uztd3wzzoRsqrenvdLaGyJUjeQmWQm+IpQ7zeHL04bS5I269rqyBKzyT0yW+ECM0IuTKtJsoEoDIGD1eL+bIA9clvghPDjeL5jfZsYq5UzeYV1Ej/Fvjze/9Ys9gdMyMN3H7RfyYWUHYhD6dtMdgblH+bFo0DQP+xEivysrf0OSmQWjw406rP7Z1zMk0l5GXj1keKhR+wCX/wWqFkoLCqVceruoEd7mVtJSibZ+lD+B2KwTEOslWYPbVFzC6jQnFZsaUMuNeNEn4vDXa7spRaco9pWHcC26x9G+RgwR/zMVG0/rJGeiqzB35y6vXsnhDhLogMo4ilxbGOg/VxrOb/1O1UMIqej7vusVfJ/FgXtcef+O/adUjlWXztfzO7n+jw9U+IrGhwlfck/yD3tGon5nHuo9Rmzdk80pZJ36JBBEV9Rg3LNSg+w42Vk4pljgmO6lMxEq6wUONQUYa9V/IRoxORFTSWf1CrvfEniCaV4bwgdGjJ8Y9DyUq7hoTeF4+Kp/WxNteMTRMxvLaxLgnnPJylR
 xEpy/Ki/
 Gdv7BmG25iiKMmlukggK7ILEVOZXcd+K0shYmcoFBQO1ziMRJBGxJflf32izInqIWiFRhKLdSu6mBTWlns6M6VOxJqptirPPULuzkhw51mXzlyc8F6B6RL4fGu0bZ2d8UmAaIxuzrmKL6tHUXL2XhLF6MIcS54LoWx7CkvTrRO5XOtnDBwqmP07h6c1pQPp/1/+47Nt6c33M2DBjL3MMBGoBYH4IERhmdX5Ky4xywCdQfW1lwz4+chXczqCd33UAUCO3Fu8CgVEY1d3h19pXR14uaGPHNgXYVZKvuhgOOM2p5nTCQC0sYSOcJgeU8yFoKurU2hYvzW5vt0ger6jbseIMQhsHpsyRxkPQQWEBxPkh9lrgXpWMpVwL2yexd/vAJ3uJQW/mqD4zQlNbOvLD0DRtPjNiE00b2XbI+NQ4MdEPHVw1/Xxjp4FNVFmRk4vKUcJtj8cNCh2pIq5ob5PrmbVRjUegun9kfkO5gVDqUFBDFK3k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 8, 2026 at 5:05=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> On 06/02/26 4:42 pm, Vernon Yang wrote:
> > On Fri, Feb 06, 2026 at 10:02:48AM +0100, David Hildenbrand (Arm) wrote=
:
> >> On 2/5/26 15:25, Dev Jain wrote:
> >>> On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
> >>>> On 2/5/26 07:08, Vernon Yang wrote:
> >>>>> On Thu, Feb 5, 2026 at 5:35=E2=80=AFAM David Hildenbrand (arm)
> >>>>> <david@kernel.org> wrote:
> >>>>>
> >>>>> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not m=
ax().
> >>>> Yes!
> >>>>
> >>>>>
> >>>>> I'm also worried that the compiler can't optimize this since the bo=
dy of
> >>>>> the loop is complex, as with Dev's opinion [1].
> >>>> Why do we even have to optimize this? :)
> >>>>
> >>>> Premature ... ? :)
> >>>
> >>> I mean .... we don't, but the alternate is a one liner using max().
> >> I'm fine with the max(), but it still seems like adding complexity to
> >> optimize something that is nowhere prove to really be a problem.
> > Hi David, Dev,
> >
> > I use "*cur_progress +=3D 1" at the beginning of the loop, the compiler
> > optimize that. Assembly as follows:
> >
> > 60c1: 4d 29 ca        sub    %r9,%r10         // r10 is _pte, r9 is pte=
, r10 =3D _pte - pte
> > 60c4: b8 00 02 00 00  mov    $0x200,%eax      // eax =3D HPAGE_PMD_NR
> > 60c9: 44 89 5c 24 10  mov    %r11d,0x10(%rsp) //
> > 60ce: 49 c1 fa 03     sar    $0x3,%r10        //
> > 60d2: 49 83 c2 01     add    $0x1,%r10        // r10 +=3D 1
> > 60d6: 49 39 c2        cmp    %rax,%r10        // r10 =3D min(r10, eax)
> > 60d9: 4c 0f 4f d0     cmovg  %rax,%r10        //
> > 60dd: 44 89 55 00     mov    %r10d,0x0(%rbp)  // *cur_progress =3D r10
> >
> > To make the code simpler, Let us use "*cur_progress +=3D 1".
>
> Wow! Wasn't expecting that. What's your gcc version? I checked with
> gcc 11.4.0 (looks pretty old) with both x86 and arm64, and it couldn't
> optimize.

$ gcc --version
gcc (GCC) 15.2.1 20250808 (Red Hat 15.2.1-1)

Above is my gcc version. However, I performed the assembly again without
any optimization :(

I suspect that I might have messed up the environment earlier, failing to
compile the newly modified code successfully, which resulted is assembly
old_khugepaged.o.

