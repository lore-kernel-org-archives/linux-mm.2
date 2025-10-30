Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52EC4CCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9564B8E01A2; Wed, 29 Oct 2025 20:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906ED8E0106; Wed, 29 Oct 2025 20:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F57B8E01A2; Wed, 29 Oct 2025 20:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 715468E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:24:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19B7CC097E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:24:30 +0000 (UTC)
X-FDA: 84052884300.06.54F0C81
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 31CE0180012
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:24:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KMdm6dSX;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761783868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epzPhO8vgI37OQJ5YBJFLRek4SKDfV+z2knwPznfnng=;
	b=od2tRbYtNTI2LGFd9YxSgpAJN3NmNm09/cs1azzZ5SXLvtm4MATCewSaeKcK1yXCednG3q
	q5eT4KTMDk67auJeLaqT2KZyC0bjqnHwer6Dmxp2DNexzxAizAe+GuLT9fENPmvmQwmVy5
	S0YRe+fAk0hk1Lm19JY2T64TbS4f7Kw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KMdm6dSX;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761783868; a=rsa-sha256;
	cv=none;
	b=sqLx7lmymPaXqDMpD4EjX/SDqVBU9/jiJO+ZBI/aVP7eyuDjgkcIEodR2RzPLHyOlHkI10
	76qL7uWuZUJ9RNKMU5My5M9mLFeUls+2SpwY4WOB9KEIhxllHuP/qc+aRXINBKvVAT6Mf4
	asXZIb/VPV72nOiQF17SkbXCdw4c3qg=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-429b7eecf7cso31825f8f.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761783867; x=1762388667; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epzPhO8vgI37OQJ5YBJFLRek4SKDfV+z2knwPznfnng=;
        b=KMdm6dSXLmxdD0ost6yr9ZKldfowsAD+rCEqMvpRbbkN88HuU+aiyE6o9nbrRFgBI8
         bSOo7A6uMupHRmXzlTVTj1CGbM9r6E5lOtQl5GHOkXepzLLwbMuUJRt0wrnIrmbz3vgb
         dqJSozmTcH9F1mFOnSHy2eOSluugmjDOfGDXF+aDSsR2fmnam1NfC0tqnEDTscNQ2EXf
         T1LSqnqN+bmuHtJhpFhx5O+1oyCsjlAD9Qp7k5dlHoYnuS+qlb2UiBFO0tlS72KuwWXi
         AiexBETD0DLbLt+M6jaVbuuma6V1fHRBcVeyK2zlq7CwOco2UXzflQ3FFy83wnRS2XxN
         yo0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761783867; x=1762388667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=epzPhO8vgI37OQJ5YBJFLRek4SKDfV+z2knwPznfnng=;
        b=dI70fTbMyPQ6KN5HO3c7+VUhDDpiTGiQKW4EtoyqhC4DBAXYtrK/p/r16P4Bky3RKb
         +U2nQoRTfM1MUPyJLbjekvvM6tenQSgIL9XXKXfqKZlMqfRc8DDt7ir3/gfCGHq+pKgP
         cSOrCHxj8WrVWhG8/aQEX9h6wtYw0W12zLJ5G4Ffuk2aEZg2HgT+VjwEmtEGW5kflQ3p
         4ep8R0+wYrMc36q3AMrLM+v8KD0VbFAVhccsDDbilp3kIBJj5qv1HWwymnUOvhUW3eMy
         XUGc95zfEPqB0doMo+MWJvuhCylbIVODrxsDLjIwQlJa2OVAvp4YlR/rg+3omGcri6A+
         ZMvA==
X-Forwarded-Encrypted: i=1; AJvYcCWSMbJCVOJ0y2uaBYOvL1P8HjSfjF41dvGAhbsLne+P0jz+oRUHu/eYkXQJreUHZChKtDhv1T3xgw==@kvack.org
X-Gm-Message-State: AOJu0Yw6nvp/yYxsgMCzivd96OaKN+jgDStPxjL9BDmbpcVVxKJJAk3f
	IyIOpwCMQzRCbSlph5FktyMs0ghQuH+B2FblxrJ0RRBHAXTwCt2lIZzUqNk4nkJO9biL67GAxkq
	pmw51nFgafE+/jXY4F3jSn/AR2CiN5Fk=
X-Gm-Gg: ASbGncuEcBUqtXenVb7FIYVTv/is7nPLXFL0BG8nfHMvDvDOkeSJKhiQJBGsdB4yY3U
	mEsZd7pNi/Lvf6gV/QpmGmsWgPGNpy8Cc3eAtF12izClzS6RfFkXShPTvE4vmZRoxY+ORwmutC+
	rlrNcsbzsljbucyBhPk4dEXCLA2n41m10eloo3GDvMr8ytGzbCNTLek8xJCYlkwM8McmeNhGt4x
	72OIP2pGjAxC/HfNUKHfRJbyTpcIIxKt3Z+818lWV9ZL5X9g3hCmjgy0e2hadpF+NveYaTWhQeZ
	3AhwSrcwEK1JTDELgQ==
X-Google-Smtp-Source: AGHT+IGrpyN5vXmTDxAJ2Hbps4KQtgd5KIZx2gAkx82y7AWs2BOA0ibbW+EbXbkybCTf6OBaGDisHC0/rb+R99V6Svo=
X-Received: by 2002:a05:6000:2584:b0:401:2cbf:ccad with SMTP id
 ffacd0b85a97d-429b4c56bbbmr1308255f8f.17.1761783866576; Wed, 29 Oct 2025
 17:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-12-6ffa2c9941c0@suse.cz> <CAADnVQ+nAA5OeCbjskbrtgYbPR4Mp-MtOfeXoQE5LUgcZOawEQ@mail.gmail.com>
 <a110ffdb-1e87-4a5a-b01b-2e7b0658ae33@suse.cz>
In-Reply-To: <a110ffdb-1e87-4a5a-b01b-2e7b0658ae33@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 29 Oct 2025 17:24:15 -0700
X-Gm-Features: AWmQ_bm8V8LdP4A-G3QXinsd8ut065vtjAkDQw3A14j7is_ar0KxcjD8kryVmlU
Message-ID: <CAADnVQ+8x2b5qddRxU50xeq69XMY5RNi8ZfvTbERidKwTYrzqA@mail.gmail.com>
Subject: Re: [PATCH RFC 12/19] slab: remove the do_slab_free() fastpath
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u18rq7eoqyf338ppptgx8p7i3gquxtbm
X-Rspamd-Queue-Id: 31CE0180012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761783867-238077
X-HE-Meta: U2FsdGVkX1+Td3jUEWvZ2YjWCKUCl5B6lW8Y8bgBY8KxXRkc6ekKwNIX6OIC2vdXP5FXHiaYjEEh8BCAONE96Ic8egctTNAeoA6GsCAaoeG3cBmumeONo1yWU8TvpDX0hYsRU+JjJ5NUmJ6UBO/rrAVRHC+zfM07SYwlItY1ZbpcjyNLgZC8nWZ/+LrGnVkkrQ/C+e9nH2jinNWmORMfa8WIyKyii6Q9gSzvRpwDM2hoPpFtglh0Mrk9n/znPkmPGNfijCqwK1BCTNF/vePvCKOpVF6wZXDXSTia4vSo5+8Ls/FXYN76XDFBSpZFMYhRW2CD0tmtYM7LUw7EajE7fTKOiZcRMhlrNryIxVXAZUK/reGngdO3yrg4JkXwZkiuBXugsluRo9mONRTDtg+8/jr9Pa4VZm9t7xVzyzS4tTkcbjCRO+ORaZFGyHX3zxyXccR7rsdntKcEyID3Me0b+216Y4owvh3VzD60hpT9qLX+wCng24vSuj5RMyS+yC3gZYiS6txAbgtttX1tw4AYiYNzkUbWWxtY98EHfspSIVAd3/HIrlj7Q9sfJKEetaIvwrMqIKb6IjE/e/Rt9LJXfl6IuVmYD4s39avABSARvrFxTG5wTubk2pTmapmuyXRmV1bSRGDBaQflRsLYnz74eNB6JTqse/Q4a8CiLaAAHxRV0Lkg+TwEtRDuJhfyQ74Y14viECSzQ/Ur39OQg1VK/a0jtEyYTFEYoGSdw5GgEUVpzPlXfx4YJOCEUU1lR9z3cnYs+OcXgF/EtCO9fgGyy8HtzUcghmi+RSYCdjCuDlA3s7AetpanGZuFl+4SSppxOMoZslr2av9Oe0NjLwx850sINaaxXasR6Gn9KAwdNIWyskLzi/ZPls1Ah4mDSB7GV4y6lLDQ4CLdzY9/bk3r0t/SB+PQ0P048r59BPCBTqp6fe6pMGx1J2BN0biO//LUxxIWmcea6iiff1QmrbZ
 +/DVwhRB
 igAGaVVXPKtVsx8CWvJ+RLSPW+/qXs8bsze7rcO6TvtWhNIUWp/yV++clo8uwxIeOj8cyIAcbR7itpxiPWPxzohCdkw1EN4Bd6FJN3Vs4uWF0XOkppEcuXgupLfHdW82CWgq5UgtxPXOz/ombRWqhZ/Kn6BhJkoBZeFXJCZqThJbzs3Nj52r0WvwYjG/5M3UTTBwlqP8dwWSrgOjP1DmMrkt4ZojvERHLwWKD3cIUrrycsxlAePiogsb9tQ3TieH0CG/pFIBtFAMTTbHWP6B9F12lFf62dRJYLhNuKj42f9M2+Om+5qsdwBYyH8JD9BVeX5PwZaOQ/2m1vh/GbzVjfdl0rzzHOz7XIpJRha3XKDyNtLDD9yNtRtI/fEg3b8GByzkShOAK022U6Hb/gLMv0OKXzjgxW8lw9Mqaf2luowiW9VyvUj828CmfaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 3:44=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
>
> You mean the one that doesn't go the "if (unlikely(slab !=3D c->slab))" w=
ay?
> Well that unlikely() there might be quite misleading. It will be true whe=
n
> free follows shortly after alloc. If not, c->slab can be exhausted and
> replaced with a new one. Or the process is migrated to another cpu before
> freeing. The probability of slab =3D=3D c->slab staying true drops quickl=
y.
>
> So if your tests were doing frees shortly after alloc, you would be indee=
d
> hitting it reliably, but is it representative?
> However sheaves should work reliably as well too with such a pattern, so =
if
> some real code really does that significantly, it will not regress.

I see. The typical usage of bpf map on the tracing side is
to attach two bpf progs to begin/end of something (like function entry/exit=
),
then map_update() on entry that allocates an element, populate
with data, then consume this data in 2nd bpf prog on exit
that deletes the element.
So alloc/free happen in a quick succession on the same cpu.
This is, of course, just one of use cases, but it was the dominant
one during early days.

