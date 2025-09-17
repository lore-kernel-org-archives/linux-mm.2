Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37F9CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71078E0012; Wed, 17 Sep 2025 16:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16D88E006D; Wed, 17 Sep 2025 16:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4898E0012; Wed, 17 Sep 2025 16:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8928E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:31:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3359C068B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:31:52 +0000 (UTC)
X-FDA: 83899888464.05.2A34169
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 12A4C2000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:31:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Guac/vBp";
	spf=pass (imf13.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758141111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OBIs0bUsQlBfNz/o3OM/cckvzwG61wfY25aaGHql4M=;
	b=eNBrSN5cP79iN58EaAAjAccaGWCV1q0DWTXTpfkO2ffgG+UgrQlxYc9TuXwaSulShukxtG
	L3Ob+/dCBMF7GWBx3q+MHq4HHynEZTzuzAMdiHlossB9mSGvyq0HUuWPwUgnhImMahfEgS
	mGemRIQrMhSjAZ7TE0WZn+j2n6NkeFo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Guac/vBp";
	spf=pass (imf13.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758141111; a=rsa-sha256;
	cv=none;
	b=VAa+g5bFRp3uWnFN2aLO94j/MvYjrlm6PH6b9iQhc/OymsyYstG8LUL3UILNpxGzBA6Uyy
	MEpDrkAbChPl86nhloDPznlxRpn+CqtGB9YbbKbKIBovZc494me60xq3452MTGS28un035
	p2FM7Ydsq/rIlbxhbMMiLlgFYD1LFwo=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-265f460ae7bso36415ad.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758141110; x=1758745910; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OBIs0bUsQlBfNz/o3OM/cckvzwG61wfY25aaGHql4M=;
        b=Guac/vBpJUh7gd5A3CXaxXJXsTMboWrpEASW825kraAKiotQhxtuRtVmKOCiTiysqA
         3t1NZANEIZZ5IbdEK91KHkfFJUEnl2rUxIIOMoSGlXC4aMVl7usTMM4yWrYdORtqblFv
         RPPLyvOOKOHji0wkpBXlbnpnqHcVQLJ2YpervqQh50gsr4FqWvzU7R6Z3ujINHnoCgaO
         Nev04hygVMOqsmqV1gJFgonaT7GhjK+m2CzP7Gmw/5hr7yrrtFxGnWFLQ1n67KP+BcIX
         KUAvJlhedFwclOimYKa/nBYxzL5GGsLxV/C18gysqsz0nPUoL9f0Ry5jrPqB1jVSaaRM
         ZsIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758141110; x=1758745910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5OBIs0bUsQlBfNz/o3OM/cckvzwG61wfY25aaGHql4M=;
        b=KMCA1B4LJ5vceoGeI5hl+I0atIwj+kH0pfBwCcSyB2CKT0LvohDmT5d59ZyqVe8gNA
         CTBhSx7xu5dugf94GZMfYFIaufrsavHr2+MWRJ5dzj6gZ/q6kV/dd+eATyodgxxEZLK8
         z+RVuSPs1k+ByfXC7TJJ4qE7J4VBiJLgHxNam3J5nmlB4FlYFfY1bwKry6FC+4WlRNqk
         U5EkDPnf8ek6b3ya0MNuS/B8bqp/zwi3i6g+cqdyhkspflB9h/7G402RKroUsGYTRgDU
         cyxI2FoNbnBCnkdKemeW6FLTcYkqqFO6eqvZ7syI+Pd5oLCct825MubSAiSEdcyC9PPH
         P7UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVO5CvXpW6qdrV3Qla5d0gdat5XapVBWOJl++Bf2bgtAzuqJcZy9pDrzHpjWnQYZFFyuWUUg9qUGA==@kvack.org
X-Gm-Message-State: AOJu0Yz3Vg71kfcf07wTHaf8Ga2U2n8ieo4vWlkkfCgnLwOhRnENnfvq
	FLf6zUjwD+JCKSgAwcU7ptNZteRWUGsp35r0XY7IWm8I0pchMf7SD+mehEs8fZGQIMbXOLGph4v
	2RswGrbVqOAcscvwwqJqSKdOGHZZDrs9O/Frp9XQb
X-Gm-Gg: ASbGncsD6KRU9k52oWI4GQr2Azp/ikuyZ5N4HakNyHIIEJZ81WEOne1I4cVdrPwujIG
	eE4gFxU7aQVn35pUUqGUFBf53zBbcZLS6LIY8cgiPtKFC7lqwiuNg1wcnsvurT18wIhCcxEOTOu
	WIkoJho19d+flAv4hBe98aQEduNGVjgXzZEZ0A+jaerc2lUYdYRZFBp2PKKDJYN4sb/4wxkXFJo
	enzjIkqEbCyAbiMGeotmCCUZF7daIKL/AVxoRjgoRBP2yZUhgAANdsU0xRD8nQ=
X-Google-Smtp-Source: AGHT+IGi1Cl1cxLljbDRwITE9vfhwz+DrDPsOJguUQv2zzG51+QwzyCb4weDhywo5yliSwxcW6sHs7Lpaphswpsb2Ak=
X-Received: by 2002:a17:902:e550:b0:24c:f4b1:baaf with SMTP id
 d9443c01a7336-26808a33cc5mr6423875ad.1.1758141109587; Wed, 17 Sep 2025
 13:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-7-kaleshsingh@google.com> <eb7820ed-3351-4cb5-8341-d6a48ed7746f@redhat.com>
 <CAC_TJvctkyGEKv8mVE83D2DzCd-HiXh9co_DuZfwuF86FJoiJw@mail.gmail.com> <322fd5d2-d7f4-40d8-8a06-6e7c5e9ef180@redhat.com>
In-Reply-To: <322fd5d2-d7f4-40d8-8a06-6e7c5e9ef180@redhat.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 17 Sep 2025 13:31:37 -0700
X-Gm-Features: AS18NWACcEbm1lm4H8WkQEbyfcTpHlrzU-8yyCAEibl_VJPt8WSVNJn2mY9O19Y
Message-ID: <CAC_TJvf84Zerwe7-UiRW3AYnC=_Zu3tVSSWTRcaEyoRGEnBHug@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] mm: add assertion for VMA count limit
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rugay6fmjisxcewq95wri4ng5i5nycna
X-Rspam-User: 
X-Rspamd-Queue-Id: 12A4C2000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1758141110-999893
X-HE-Meta: U2FsdGVkX19Ijt76dg1Qi34uW8OAGZPgy5ja2T2MAVdBOoxfRxf/3YxcTKH8zrvXk7hknnPKR7L00PeS8jNwsNGWAj7Z1cQZLyObQtyBuArs5RcNMF3O5j8+51D4hlCr96SQtC44tKVKBNwh9OVWqeRpbICUy4md5ygicbBJ75g/Kd0tASH8GFqYxwKgEEqplWWs/o9PSI+fFJNHcfNQ/j0P1E3d8d6g90bEsy9FV2DrcAnCj2y+go9Yu5nzjHgk1bIaTJcMvYwOP/r6QTqelfSr/EWUnKFD81+5qc8sVATWXts4zOwM3wpA03xG+zD8uxZ4kleeEkv3vfsI28MCmFe3Ld5e/lP2RDC7nYSH0tNyyIF1a1QgUwl+RQUNeXWZdr/8rnS6p2Y/T1DzRaG70bkC4xCiyVpgbcVrYOzaqGSb/00EeU4OV8YXt/Ces0UZEetXDTpkgcsywwuMt19GidIxQ4O7e6Dqzc19E6qqJ1owIqWdnx+Rw8r15TUeC6n6o4SuOpkBhiZ/QYYoxLB/a/x6n34YmZzBV4dGvuHXfPOH8WEEHMIPgsly5E+gIWziA0nC9sbXDhNC2RC1K6E2zz7p0fetDbDyBS6jvW4oZ6PY8bZu/Wc8KRzzK6tGOhfe+1GEu4ejJeyV3Uptu+vrVr8CykILldSiew1Cd8aHaedBUiVyT4ZAEMv9angMBpnQQ8gTqoMMHk6f4W4rLpRCqeJ1+AW2wHlMT08TkUzPJ7TJdAqb2UzkIzBEkQ597EVN1FKjyasloqD7z+cPINtVLrpQX0ORiAdrIfWJIV3qPdnmK02BII9pPGLNsIliv6TlT3/lkT0cStDQ4sTiWjRoFGVKBEeVpIVUVq/CRbvyIOKaeuqJvISR1kldkeW+Lr5WJAokuAQk9kBFc6f4QZX7i1tgZjRQJyPIbNLHFkh7HcnSgJJFvEtQNUhRJk0H0bD7H3h/T3eLsSFK2UHDs2w
 5G3HnIDO
 E2G+NXXbSEa5JSkvjYrMd6NoSHSMZYBBBdlAfmQ/njMAZwJOjylK+znoC9foDZmPGcKhryTkiegZXk0a5x6kl1tMGuECNFd9t+rezPVu2gGiQfQimLoBdy3LSiRXxl7dTK9ImKz8vhhNoNLm2zbFsnwV1rw/wNVoeEQlLvzR82vVa63+6aKBoS8oc1hgTh7fU2AQzGuH6gy7B+Lkjq4jm3I86DobHKldLm/SCuAHv0Xn7t35KTnyY0FvuSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 11:34=E2=80=AFAM David Hildenbrand <david@redhat.co=
m> wrote:
>
> >> Can't that fire when changing the max count from user space at just th=
e
> >> wrong time?
> >
> > You are right: technically it's possible if it was raised between the
> > time of checking and when the new VMA is added.
> >
> >>
> >> I assume we'll have to tolerated that and might just want to drop this
> >> patch from the series.
> >>
> >
> > It is compiled out in !CONFIG_VM_DEBUG builds, would we still want to d=
rop it?
>
> Due to the racy nature I think any kinds of assertions would be wrong.
> Without any such races possible I would agree that the checks would be
> nice to have.

Alright I'll drop this in the next revision.

Thanks,
Kalesh

>
> --
> Cheers
>
> David / dhildenb
>

