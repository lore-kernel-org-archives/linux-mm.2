Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E1FD6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE23D6B0088; Thu, 18 Dec 2025 07:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD7C6B0089; Thu, 18 Dec 2025 07:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6AF6B008A; Thu, 18 Dec 2025 07:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA466B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:21:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77FA1C120A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:21:22 +0000 (UTC)
X-FDA: 84232502004.27.901D788
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83C17C000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:21:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mhx2f3VQ;
	spf=pass (imf28.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766060480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jB7Mq3uTVAUZ4LCtSm1b46a21popHdUL7PDoTvew/6o=;
	b=MGoQhpBK+wZkQSJ8gIGwj/B++p5pAeryG1B/kQr4Pgr35wb1p4MynQh9R/XrtwL59eW/MM
	wF6GSin7sKv84VSCy48YfeYbVH3C07nnuNzsWCuXzd3OWXL8zCrXgfHgA0WPijOv7p/+FP
	SAFdXG6Pwp8lVJxha2pvvAlE/DFHmUU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mhx2f3VQ;
	spf=pass (imf28.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766060480; a=rsa-sha256;
	cv=none;
	b=Q9LufxFlkCi4FJoRmOklm8ZuDsMp4B6zkm+IdfbcuxoQNpNOyQehCFxs2nla+LcnMvy9TU
	oV8JZI2vCjKpO+UmSE/04OdT/6obQLcBtBFQghYR7ewATTQwNtR5cpsja5KBPAjN0bpXRi
	+41g+aawoceqCXvVUTm2TVLJW3H5YR8=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64b5ed53d0aso561849a12.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766060479; x=1766665279; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jB7Mq3uTVAUZ4LCtSm1b46a21popHdUL7PDoTvew/6o=;
        b=mhx2f3VQGGbak1EKdQ5syl6nI1VyVn8p7BUTj4So5tGyTauE9pDzlK8ZmaifB2Onrh
         lJGOFyaYiz2qebjup4YDpOEX0icCIVQC6nQN+1bJ7ladiIx67DMKMf/YcYd3xWjX70I4
         2Y476ZlC8cB0k+B5K3EYnDLlEojIy8pY0MeB54zty+AB1IvD5FVc66pAYjBAI2WXbw3O
         lfp44zgaYll9h3UgNWcyccrhdytMB+cV4XAjRVjwoslqwmkCS6ItLp9786uNjgP1mRrL
         ZsXSi2T8GReSa3F/wA/com2Ayk1SYp/Bfwd0CXzwRk3CfWlASwlYIdE+lP6nOp0YhtIU
         X81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766060479; x=1766665279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jB7Mq3uTVAUZ4LCtSm1b46a21popHdUL7PDoTvew/6o=;
        b=bDsPD/dXT9jFWBXZfX9uMnNlqmmvnnJj8EkIRK7FFLxKJYhgzku+90KHVJigQvv7kg
         fBXfZCdCUuoQ/mUUw0miCUpg7vbdT0qehxOBxURqZ57Ne6gmdJgh16lwrwMpqfHttN+M
         E6IdFhOGyOyE8X9xVEKc2gFMWlHbk74AVy4AuHe/C8wJqVUS23kDDgldyvcjOb18e1kn
         KblnTQQ0PBF3WKzl+r4xNmc4O5FFrrQcTDhAHOw1ntL9hAZb4MP9TPBGtbxlNPWIzarL
         2oWpIvwi0/vfVaUCzutqhgWY+cqa0V5tiUMPNx/Q9XHpOOyWVb9Rgj3XBYb7DuvD18Wk
         DFLA==
X-Gm-Message-State: AOJu0Yxtirld7n+uLTS0IxPkSYhIMKwATo5kkZn3W+DrIAr8ZJAACIQC
	LxL/oE/BWjePyKjKRXxFBEr3T7ndWqBYpw3hVsQvCx+jLxTG9tM1spzxNTpPDCQgJGLrI10lzKN
	FnNxXBE/WwJFxMOYj+Q7uIGeY06MSF6Y=
X-Gm-Gg: AY/fxX4MhpGQ3YyjOIZgaWdjeX05mcN+iUkOofeI64d01OS3Qic9oyJ2meJfL9mqTTO
	KNn+UgCh6mb5cnmrlVvOWVw5a1rJsOM7FDRYKdMzc3c90NrlVYN2WlCqEeQ7w5Zl1+TKicXPAsW
	zruGmxH0wq805nLM0Vl045cH/OMbvtEDyqcxrCHfGDjgwksS97oHZEEiIBnlm0kYW3VCgZC7v2N
	2CkAAEiJSJPACla+v5k7JGP+gNJHRjc2T0Z2fiNwlUUG3xYuPlfnMuzWN1P+2XFd9pn7mKYMsuL
	eAwfOQVporOflAy1W6wt/jugZd+/8a8v+mJUSII=
X-Google-Smtp-Source: AGHT+IE/PJWYKNoxgvgmzWbit2wjwc0EfaxXLyWyZa1k4g2ml/6xwA40hw2jDFSPQIiL48U7HF3l5mHHgcwN7vuzgLg=
X-Received: by 2002:a05:6402:4403:b0:64b:62b3:5051 with SMTP id
 4fb4d7f45d1cf-64b62b350damr1885993a12.33.1766060478785; Thu, 18 Dec 2025
 04:21:18 -0800 (PST)
MIME-Version: 1.0
References: <20251218112016.9613-1-klourencodev@gmail.com> <0544a9e4-bfef-4af8-9f68-a5aade840adf@kernel.org>
In-Reply-To: <0544a9e4-bfef-4af8-9f68-a5aade840adf@kernel.org>
From: Kevin Lourenco <klourencodev@gmail.com>
Date: Thu, 18 Dec 2025 13:21:07 +0100
X-Gm-Features: AQt7F2ovw9YThLghGd_wojP3CuRYWjt9K7-Tnb2R_dwwcaXUxbLB6nKPddhvW-U
Message-ID: <CAFveykPV1ZFWWgu+HK090njGoMDqhH5SAd9EmG-+VO9a4vLg4A@mail.gmail.com>
Subject: Re: [PATCH] Correct minor spelling mistake in huge_memory.c.
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 83C17C000C
X-Stat-Signature: hcx5msmby9n1xntx77o6psuizoc7efru
X-Rspam-User: 
X-HE-Tag: 1766060480-398959
X-HE-Meta: U2FsdGVkX1/K9wUL//4BYRqSaYKj5n2eEYhJL0uiosQKJVzbLdTbxmMVrRyu/AZ8Z/S81zLTgkVX1N565Odxpa9IShvrfRQHiY7CCbKIzhwqwu0mO/R4aJMfF0xISPwuNWSgYBk88T4BWAx0Jk/MBKZlsfxk3QABa33O7tPbFwtvpTpv4Vh7S6y+cSrB5SO9N/AS+z36ZBTvk5EnyBu1cun/PFFy0TzIO4MEjeWw4CTN6n/ZBz5czee6Mx1tnUiGqLKb4iqfSJoaWuqIny7mrSxMRbQVjZCojG7dJxCczrVmCjzf4u6bxeXDvvxZGLp2McB5jImIS1sR5YbIPtk7utpu1oOciMgwnElMKX6hs8nZIp0jfJLmc0cXJD9R1MuONGIt9HrkpB649zz/PUDQZrpboh7FWvECXanib/Mjg9Psr0jSqNVy31PAMe7C0gOBuQa28n/NvpHQBsMhR5RUw3NM6BD9lAh4GOIxw+U//jbkxkXGYviypw/Jmt09nV8yipn29CJtYalPude2BqIYn59ncQ7hM8XZGfUdCvFRgcRtkGFqtKM8Rubvh8/P3iFvBxK2H6CnEEMGTbi39O5dXyzFaMOKdrbNk7e74YL4DSNsENCKxL2Ph1AC362BWEoJm/BS3IS0mcH1FBlQH00gcP/8gAF8pWr87rE5ybbYbNToOC6Vg1SNqzegJPEA+akQC7Hww0XQqLaiN1fMS+Ctwhud0RaW20w5QzgtPaCwOLD50x0tVBqHl/TF3FhdXa9/GL7B1y7gZSEib0RBzi4o9hAUQIHLda5NcC8Ssrd1tm+tlrJ8qkdZMOKZz/nFVeApLhaJTWJus+w2Z03Iq4sAXktw/N62jwVr/Dt5lsU5vHEtNkCgQ5J/BxvHrS0VmO1t3kdD9fZfP697GwH5BxzpP2w0qZHwp0K7tisjLDjqrC/Oh7BasEiqbSCaVpVokJ6p8k+dPBYjGHzdQ2JkrCd
 XjlpbxCp
 W24uLEJ5twepDxJuURVK/HzqaNLZ1WHoECu291vKUKOI88WIAdSuVwCN/DGNUm59iiiO5GLrqk/nVEA9kJgqjaoqgZsKNiX7d2pvTIQUF5M9571u+mWLDDB7YA5M/QaqDUURS28dJ7yqqhwiNa/Is5Z8DuKh+jxl7cZpaPQ8FkArDhMto/K8hw1F5AOgaR9x1J4SRXpPDYqMFyThQg02RNNoXWBxvQHsqFXIR2wYkDj3bVkmqwISrFhpf+GqQag/pXKIcyyj8W0QdMyanwXSkFx3KjdE1YwD8TLd81ktNyVaoRbmUh6CKJh1oIjohugD6KnhP/t8kpefro/Fgii/1qfZT7IqzBBPnn3tUnzXZ/txYJkHZMzDkYuW7fi2WISxSYTeGd7L9r7y7Uao2DT1JOPjXadiyOAW1UIITldHl4JKLMc/bekk4diytRd3D/MO+Cgtk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

I have found no other spelling issues. I also did a deeper review of
the mm/ directory in general and identified more than 20 evident typos
across various files.

I was considering cleaning all of mm/ in one go to provide a more
thorough and consistent update. However, if you feel that doing so
would not add significant value and would only consume reviewer / my
time, I completely understand and can refrain from submitting them.
Alternatively, I could create a single patch that addresses all the
typos at once in mm/.

Please let me know your preference.

Best regards,
Kevin


Le jeu. 18 d=C3=A9c. 2025 =C3=A0 12:54, David Hildenbrand (Red Hat)
<david@kernel.org> a =C3=A9crit :
>
> On 12/18/25 12:20, klourencodev@gmail.com wrote:
> > From: Kevin Lourenco <klourencodev@gmail.com>
> >
> > No functional changes.
>
> Subject: "mm/huge_memory: correct minor spelling mistake"
>
> Then a simple "Let's correct progated -> propagated in a comment."
>
> You can drop the "no functional change" part as you only modify a comment=
.
>
> >
> > Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> > ---
> >   mm/huge_memory.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 40cf59301c21..5efd2cf4f073 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3220,7 +3220,7 @@ static void __split_huge_pmd_locked(struct vm_are=
a_struct *vma, pmd_t *pmd,
> >                               swp_entry =3D make_readable_device_privat=
e_entry(
> >                                                       page_to_pfn(page =
+ i));
> >                       /*
> > -                      * Young and dirty bits are not progated via swp_=
entry
> > +                      * Young and dirty bits are not propagated via sw=
p_entry
> >                        */
> >                       entry =3D swp_entry_to_pte(swp_entry);
> >                       if (soft_dirty)
>
> Are there any other spelling issues in that file so we can avoid more of
> these patches that don't add a lot of value and only consume reviewer tim=
e?
>
> --
> Cheers
>
> David

