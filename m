Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF70DE909C3
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0894E6B0005; Tue, 17 Feb 2026 10:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037326B0089; Tue, 17 Feb 2026 10:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64B86B008A; Tue, 17 Feb 2026 10:22:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D325D6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:22:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DE8F1C17D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:22:34 +0000 (UTC)
X-FDA: 84454315428.07.C981128
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8B81A180012
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:22:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YcfYbsF5;
	spf=pass (imf24.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771341752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nukXF9Xg4mYCFlks9WtY3qEg0ubGFjMU5OSmWanzog4=;
	b=Du/D9kCzAKwhHNs13ss+ocgOSEdZvCxhNrNv8s14E9cADF9QWlZDVJyD6A0FE6yQKj39vQ
	KPd+ldbnWefp87UxHvUZlDixn6OAN5M4G7pYnUqT6Bt0HZ/SKRa2e7WdBCVhCnqpFOwaSS
	v9uPjdlC7PP3cRbhian8IqlJ+wSRVCQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771341752; a=rsa-sha256;
	cv=pass;
	b=sFO1Vlbw7kAb4OsV2oEoyjHndOGXxGcBD4mKsmui6xor/yXAM1TTnXVc7DJS5bhwFKat1r
	y7xGZuCk6Ndm3DeEWgnF07zLSAZz6LL6AS7OZ8wiZagCLnO7OMAVbrhzvdmx14qM6Y9amt
	2r9Lyh4LozVBD9HUiLD+sGrsdtXcyII=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YcfYbsF5;
	spf=pass (imf24.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-64aea64bf15so3794852d50.2
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:22:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771341751; cv=none;
        d=google.com; s=arc-20240605;
        b=Es52NWgHKAQRiNGCoBex6paTYlsumoX/ppkLZgViYkb2OKWRItlbEjFc9cF7XC0XQi
         55Ws9hZEpcMICffCcVj1sMqeBivEET5iguvkA8sNgswZnYb7xlkmlANN+WriLBSxFiLb
         X6jXVjwlpz91MsZkrhtTGb0F8JysJh7PVp1pH2a/qb+rsvMqxsTUwAZC0lb2RL46BsHC
         k0iNxNSNchLMniFXY+Q3mkTbyCUyrB5ksHtLkpIaZmp+PeeaJZ1TfR5bIYSydV150rvc
         vZteZLh//38NmPb84lnpB10a8z+F4nNE57ptCOq7wiBG66twyo1Y35T2duxFLF184flC
         oMYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nukXF9Xg4mYCFlks9WtY3qEg0ubGFjMU5OSmWanzog4=;
        fh=qT6Bkw6Rd5Xd9Ghb+A3m7ZqHQ83Z5rr21KIaDL1BkIg=;
        b=b5mcgwpBvRv8VoSVyZWuEPeoFljWu1BLvjuTE/MjP46Y/+XlYDkFbPvH6YDwd92Svo
         zSSqCkMSfmU5zceeL5wwRksLH9giZ1ylpB30J+dv+7yI+lriIVsiu0w79hSSDEiL0K41
         cfchnNn3sBzFMqoP4vZFMDWQePPM3l7fJgPocNJj/L5+3lxIcfre7J0uIb+mtFfdq6ja
         F3szAigHI3STD09chDoa+gf0zBhmwWSdTGILx9l8ece1Rf1/NJByRqyCHypexsZztaIA
         tbIHJ6Vo7grJgxdAlsrRAW9Ob272tACXUHL8tHMaa9OalKFqxkZ/nwG8vTlxbJBb/1Po
         PJBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771341751; x=1771946551; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nukXF9Xg4mYCFlks9WtY3qEg0ubGFjMU5OSmWanzog4=;
        b=YcfYbsF5JKu5chQdsZooFeh4EZ62GFmbqLR4p2aba/lKTYzUGohL9imBAaxaMb5aia
         K62GKkzfOE4xu9wAv8ZrCQm7jNhkmfjxbmNYSm3ohBufMDyEYok5P4bEyHM/risCfX8z
         yF+rdhdDDJw8hOW0vmTtoj8TWH1hxy5u/goerGc5KfWq8YsbwbpHE00igPplEJABSIg0
         4kUaajlKqpI6XfSAArVpxaKLdLcdF0pxfs4J+7VH5KLi68ElCKC8N+EF44XdslkVu+Ff
         Ol1nGkKOv7vUlP2HUXhXAk0Ra2GZ58zGA5/E+eHo0Qu9DJPhBp+suBQ/FRiuGSQPDlVt
         C+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771341751; x=1771946551;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nukXF9Xg4mYCFlks9WtY3qEg0ubGFjMU5OSmWanzog4=;
        b=udvkXp9m7pX84Znb4IPVhBlYw3rq3DBRHaxuA+TmaYZ78SusBrtu6Tiued1dCAn+uL
         HRelAv2NskY5udmWaoA+YsRCg7OECzwg9NVzQXM5dzkRHtf8JWizt+FXXCLOeBtnDfar
         jxtGqZEdqBhflmZkw0MtErDSri0ax+XPuYYNxFkSiA4JCmlS9mINJzxT9yRHivdfPOtx
         P9XWk2DdEZNkJed8DTrzKha+EVbuCDeBaSAIyRhPNGtRxzKcGfSsGTTIrJxuz6oEQLng
         NwCa/PklPJjp5bDBok6um4RxCHtiQPJqZP9jhVVE/agHmcN0+0wU2BxATZgUVJkVpb36
         qtKw==
X-Forwarded-Encrypted: i=1; AJvYcCV89A6wyErk5wlcxeZ7JuqTSszjiuPo1OTgVR4UvJr8bymQ1kSV0rzvbHvzYu2s0y+4TWzAla+DHg==@kvack.org
X-Gm-Message-State: AOJu0YzXbDnHoAc3COt5upo2ANUT/SOjJ+ELZZD1bcbCO37yvzBLhowU
	TWzXqHdNVslef9Lz7J+554qJqzsk6pCOQTGGt0uAdtqD1YEcloqbFcyMjuIw7fgGJzi27I1cVvw
	q0PqGBZOoFFXCmk0eBwOBsuCbh+jDGwY=
X-Gm-Gg: AZuq6aJhVoF553j3zyNhjstbBSHu+5Mv3OOqYZdu+Ifap6E+BoVwYFmZTx1+489PTJx
	QVL5ja1m7h7Bhd13vbj7nX8GHRa3Yp4gyXEtlfjBvlso2tcQn4ETJ+btwhseMBVuwOPPX3SSSmO
	gxowKZOoOhpysFWSJjWVN22TYF3Q9tCtmbmPPzuwOY59yZoGxIyM0DE6dTARI+RZ2IHB64MWowv
	Y+FeVi3rztjHwCHO45IJHHFOU87hqHQFPFe5nTaRRAGg1OvrP2hKQXHLjLPCIMKdT6/oGz1dlxy
	0NsrIncDSO38DjZzEiI=
X-Received: by 2002:a05:690c:398:b0:794:d388:6145 with SMTP id
 00721157ae682-797a0cab64bmr232116807b3.41.1771341751329; Tue, 17 Feb 2026
 07:22:31 -0800 (PST)
MIME-Version: 1.0
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
In-Reply-To: <20260214084514.2842745-1-haowenchao22@gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Tue, 17 Feb 2026 23:22:20 +0800
X-Gm-Features: AaiRm51UrRdXonh8mo_NHAl3qg9sqKL1Lf2RIBWfYZeAC77X0oR_CweZDnevJwM
Message-ID: <CAOptpSP1zx1akeGkZEuPBx1Fk8uz8rs4_m5c55GwPUROmCGxKg@mail.gmail.com>
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous pages
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 16bwffs1nhtij5qhxen354ux978axt5j
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8B81A180012
X-HE-Tag: 1771341752-970931
X-HE-Meta: U2FsdGVkX1/no4aTKnnNKxm0BTy/+4JDkGDNfoO8RcsYteycT0xSlwyN3dQLljgZRgxEZZn0yWFBaJH3R5Rv+N4rVvYw3UTKKuUR1zTDEeTGnmoE69rCCNXAkxJ4lPYgKf5Ao8gWkkvmpimF1k00vOtqtQ+oehDYEsl+WoZyd8/F6ukxmxMwjRotOGxzpE2qEXF54OVVmpvylB4O7NfTovRJgYGvHdUctiF2xhkF0gyZds3GMnfVcCgw2oCtCMBGESeroTf9OE+yYdrRVb1pREc0kgT14VgDj2CJiCKgkChQA7ZQ6yQA39xFNQisOqDKtMJdxv7QJ8CObTEqBeW4/Xd+c7XLzbbT1VbdfALVXjYwSET7QFsx2CT2mRMBiDOqZiuRPGProFs/kPPxwn0NH6l6Tp7dZ9GEs0/P7y/4FVFWZaqt3MbTPebVzrK5gPrHQ3Y5kyx2tTzH/bEu1Yt018a0e5OfNcYA/VIMrB31PIQ0OUI1HpeG36ArQhv/+1zYzeNLUIORRNDAYxH12AgqAcwf/WPmbQNntYmIL0f7dWRO2/hjQvRh9/xjlp2IWEHrNiprbhmZdqgYiiTfqvlsrvkwC0QFlcEKzj1Sk01de4bE6hEFGsgDN7+mFzZHKzLw/ZcSGK8rB84vQUBZpD1ln+LGZflbO11hqzY0UmpSKDi1Ps/etAR9Z0ez9ynchdJxXEY8mphOjlO1Ck7Rt1kWeuXNOp/psu5cHpbsDceUlsFgFV3+8LjB0jqeJaxxMHupzJS1FfPwxs0tAfJ82tNCN02x+83LrP0B7WuQpxL3iNJEUEvHdSedGMm18V8eQcmV4GI6NnTOKNNoexDAXq55dBwhjOn9TFIWhkHxtIj5YpvJx0Rn1w44LLgR8hr7fi13rR1gXJBA5GdNAg/OW15KOUHnT60g0lBcqfPpJ/ZaGylNp9Sk90rX8QKNTlKwzVb5oEo+wdysIQySiPn5Yfx
 ohhoEg7Y
 JZrjj/aJP6A+s7wfnQZJBeESUc+CFDCKqeIGqB5pYosM7JlelC6nGoXB+x62ZSSLmIR1mSqe/ZcuSjDjtRoNnCdFIp57KI4KATrd6vymxQ1hPEWeVyUK/lasyTmWkkdEMrpQcMWBAxYWWrUU98O1LNXdCRngKiswsoIWbm6/gbPi6mw2/Icn3VJzG4GrerxMRXyFWephL9N+IJ/Xc6lmCqvh2sL41AjAGj+n5vtgHYNrYz4l8iKhykYmRzKGXpKISl5s7ZJNQNGwPd78WBWw3padvG1ICLe7m+cZzag0OHeYi+Nmm8SAFov3PwvE1XVtXNWWACsjEERDayIMuATiMdns+4Y2HrFL2Ch7SaDwxWC6qwJD8YyqSBkaeKjO3jBqfx7h4rDR6PpF59Z0JFIgU57MSMy5TOsLCVW+j9Ju1+H9t4MMd6M9I+ni6c2g4dmzUPr1T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 14, 2026 at 4:45=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> Add kernel command line option "count_zero_page" to track anonymous pages
> have been allocated and mapped to userspace but zero-filled.
>
> This feature is mainly used to debug large folio mechanism, which
> pre-allocates and map more pages than actually needed, leading to memory
> waste from unaccessed pages.
>
> Export the result in /proc/pid/smaps as "AnonZero" field.
>
> Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowencha=
o22@gmail.com/

Sorry for the late reply. We are now on Chinese New Year holiday, so...

The original goal of this patch is to measure memory waste from anonymous
THPs - pages pre-allocated on fault but never accessed.

On memory-sensitive devices like mobile phones, this helps us make better
decisions about when and how to enable THP. I think this is useful for
guiding THP policies, even as a debugging feature.

Let me summarize the discussion so far:
- Matthew Wilcox questioned the value and raised concerns fork but haven't
  exec path
- Michal Hocko criticized the inefficiency of scanning zero-filled pages.
- Kiryl Shutsemau prefers a system-call-based interface.
- David Hildenbrand acknowledged the value and suggested implementation
  improvements.
Please correct me if I missed or misrepresented anything.

I suggest we first agree whether this functionality is useful for upstream,
before discussing implementation details.

Reasons why this should go upstream from me:

- Anonymous THP can introduce real memory waste, but we currently have no
  good way to measure it.
- With accurate metrics, we can make better THP policy: disable for
  low-utilization cases, or early-unmap to relieve memory pressure and so
  on. This is especially valuable for mobile/embedded devices.

Possible implementations:

1. A new smaps counter (default-off) to count zero-filled pages.
2. A new madvise command like MADV_GET_ZEROPAGE
3. A dedicated system call

I welcome feedback on whether this is useful, and any better approaches.

Thank you.

